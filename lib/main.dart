/*
  AI-MEMORY / FILE CONTRACT
  File: main.dart
  Owns: JE Cooler App root and Dashboard composition plus the single BLE/P1 session,
        firmware telemetry mapping, command confirmation and OTA coordination.
  State authority: firmware telemetry is authoritative for physical Fan/Peltier/Adaptive/LED state.
  Presentation boundaries: connection_sheet.dart owns the manual Connection sheet; home_notify.dart
  owns the stateless Home NOTIFY card and localized copy; led_controls.dart owns LED controls/preview;
  jex_animated_icon.dart
  owns status-indicator animation and glyph painting.
  These modules receive App values and must not own BLE/GATT, P1 writes or persisted device state.
  Localization: every user-facing string must use JexText or JexText.phrase().
  English UI uses ON/OFF; Indonesia UI uses HIDUP/MATI.
  Language names are displayed as English / Indonesia.
  BLE protocol tokens such as FAN:ON, FAN:OFF, PELTIER:ON, ADAPTIVE:ON, RGB:OFF
  are machine protocol values and must never be translated.
  Floating Monitor receives the same live telemetry; it does not own a second BLE connection.
  Build/runtime rule: source edits here do not imply a build; Build App is explicit.
*/

/*
  AI MAINTENANCE MEMORY
  ---------------------
  Scope: Flutter/Android App only. Firmware source and BIN are external.

  Integration invariants:
  - BLE identity/protocol/UUIDs below are part of the JE X FYZ contract.
  - Firmware telemetry is authoritative for physical state and safety.
  - A BLE write is not proof that hardware changed permanently.
  - State-changing commands require the BLE sync/session gate.
  - Phone battery heartbeat and hotside telemetry remain 1 Hz.
  - Online OTA release metadata is read from Firebase Realtime Database; GitHub is binary-only.
  - Wi-Fi credentials stay in flutter_secure_storage.
  - Current OTA availability accepts any valid DIFFERENT firmware version.
  - Do not reintroduce legacy commands or blocking PROCESSING UI.

  Maintenance:
  - Prefer minimal, evidence-based fixes.
  - Check exact official APIs before replacing lifecycle/transport behavior.
  - Preserve these comments as project memory when refactoring.
*/

/*
  JE X FYZ / JE COOLER
  Horizon Cooler UI base + JE X FYZ / P1 protocol

  Core rules:
  - Horizon Cooler remains the visual/layout and Android foundation.
  - JE X FYZ uses firmware-owned state and an atomic P1 BLE sync/ready handshake.
  - Firebase App Check / Play Integrity remains enabled for app security. Firmware release metadata comes from Firebase Realtime Database; GitHub hosts only the firmware .bin.
  - Phone battery temperature is sent every 1 second while BLE is connected.
  - Manual voltage commands use a 1-second app guard matching firmware.
  - Adaptive ON/OFF always relies on firmware to return the selector to 5V.
  - BLE connection never replays local runtime state into the device.
  - Auto Connect is passive: it never requests BLE permission or turns Bluetooth on; it requires a known cooler identity and Bluetooth already enabled.
  - UI never pretends a command succeeded until device telemetry confirms it.
*/

// --- IMPORT BOUNDARY: Dart/Flutter and JE X FYZ plugin dependencies ---
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'p1_frame_decoder.dart';
import 'p1_command_contract.dart';
import 'p1_ack_waiters.dart';
import 'jex_design_tokens.dart';

import 'app_bootstrap.dart';
import 'app_root.dart';
import 'app_security.dart';
import 'app_settings.dart';
import 'connection_scan_coordinator.dart';
import 'connection_sheet.dart';
import 'dashboard_shared_components.dart';
import 'floating_monitor.dart';
import 'home_notify.dart';
import 'led_controls.dart';
import 'jex_animated_glyph.dart';
import 'jex_animated_icon.dart';
import 'usage_statistics.dart';

export 'app_root.dart' show JeCoolerApp, appName;

part 'dashboard_temperature_tab.dart';
part 'dashboard_control_tabs.dart';
part 'dashboard_control_components.dart';
part 'dashboard_home_tab.dart';

// Premium icon system: Phosphor Icons (Regular/Bold).
// Material Icons are intentionally not used by JE X FYZ UI controls.
// --- PRODUCT/INTEGRATION CONSTANTS: identity, BLE UUIDs, OTA endpoint, UI limits ---
const String appVersion = '1.0.0+3'; // Keep synchronized with pubspec.yaml.
const String headerName = 'JE X FYZ';
const String serviceUuid = '6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001';
const String rxUuid = '6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001';
const String txUuid = '6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001';
// AI-MEMORY: Firebase Realtime Database is the firmware release metadata/control plane. GitHub is binary-only.
// Keep the GitHub repository allowlist below unchanged unless the release source intentionally changes.
const String firmwareMetadataUrl =
    'https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json';
const Duration voltageGuardDuration = Duration(seconds: 1);
const int fanSpeedMin = 50;
const int fanSpeedMax = 100;

bool isSupportedP1Protocol(String value) => value.trim().toUpperCase() == 'P1';

int peltierRearmTarget(int hotLimit) => hotLimit - 1;

// AI-UI-GEOMETRY: Shared submenu dimensions keep VOLTAGE, CONTROL, ADAPTIVE, and LED aligned.
const double jexSubmenuRowMinHeight = JexLayoutTokens.submenuRowMinHeight;
const double jexSubmenuToggleWidth = JexLayoutTokens.submenuToggleWidth;
const double jexSubmenuToggleHeight = JexLayoutTokens.submenuToggleHeight;

// Curated hue-first presets; the Brightness slider remains the only intensity control.
// AI-METHOD: isVoltageCommand — Accept only 5V, 9V, or 12V.
bool isVoltageCommand(String value) {
  final v = value.trim().toUpperCase();
  return v == '5V' || v == '9V' || v == '12V';
}

bool isUserVisibleResetReason(String value) {
  final normalized = value.trim().toUpperCase();
  return normalized.isNotEmpty &&
      normalized != 'POWERON' &&
      normalized != 'POWER_ON' &&
      normalized != 'UNKNOWN' &&
      normalized != 'UNAVAILABLE_CORE_3_3_7';
}

bool isNotifyErrorMessage(String value) {
  final normalized = value.trim().toUpperCase();
  if (normalized.isEmpty) return false;
  const markers = <String>[
    'FAILED',
    'ERROR',
    'NOT FOUND',
    'DISCONNECTED',
    'SERVICE DISCOVERY',
    'GAGAL',
    'KESALAHAN',
    'TIDAK DITEMUKAN',
    'TERPUTUS',
    'DID NOT CONFIRM',
    'NOT CONFIRMED',
    'UNCONFIRMED',
    'BELUM MENGONFIRMASI',
    'TIDAK MENGONFIRMASI',
    'BELUM TERKONFIRMASI',
    'TIDAK TERKONFIRMASI',
    'TIDAK DIKONFIRMASI',
  ];
  return markers.any(normalized.contains);
}

// WCAG contrast ratio for opaque foreground/background colors.
double jexContrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = math.max(foregroundLuminance, backgroundLuminance);
  final darker = math.min(foregroundLuminance, backgroundLuminance);
  return (lighter + .05) / (darker + .05);
}

// AI-THEME: lightThemeAccentText — Darken a semantic accent only as far as needed for contrast.
Color lightThemeAccentText(
  Color color, {
  Color background = Colors.white,
  double minimumContrast = 4.5,
}) {
  if (!minimumContrast.isFinite || minimumContrast < 1.0) {
    throw ArgumentError.value(minimumContrast, 'minimumContrast');
  }
  final opaqueColor = color.withValues(alpha: 1.0);
  if (jexContrastRatio(opaqueColor, background) >= minimumContrast) {
    return opaqueColor;
  }

  final hsl = HSLColor.fromColor(opaqueColor);
  var lowerLightness = 0.0;
  var upperLightness = hsl.lightness;
  var best = Colors.black;
  for (var i = 0; i < 24; i++) {
    final candidateLightness = (lowerLightness + upperLightness) / 2;
    final candidate = hsl.withLightness(candidateLightness).toColor();
    if (jexContrastRatio(candidate, background) >= minimumContrast) {
      best = candidate;
      lowerLightness = candidateLightness;
    } else {
      upperLightness = candidateLightness;
    }
  }
  return best;
}

// Keep semantic decoration colors distinct from accessible Light Mode foregrounds.
Color jexHomeNotifyForegroundColor({
  required bool darkTheme,
  required bool hasError,
  required bool warning,
  bool connected = true,
}) {
  if (!connected) {
    return darkTheme ? const Color(0xFFB8C1CC) : const Color(0xFF475467);
  }
  if (darkTheme) {
    if (hasError) return const Color(0xFFFF5164);
    if (warning) return const Color(0xFFFFB72B);
    return const Color(0xFF4DE7B7);
  }
  if (hasError) return const Color(0xFFB42318);
  if (warning) return const Color(0xFFB54708);
  return const Color(0xFF027A48);
}

// AI-METHOD: isTransientOtaResultEvent — Accept only fresh OTA success/failure envelopes for Home NOTIFY.
bool isTransientOtaResultEvent(String value) {
  final upper = value.trim().toUpperCase();
  return upper.startsWith('OTA_SUCCESS|') ||
      upper.startsWith('OTA_FAILED|') ||
      upper.startsWith('OTA_UP_TO_DATE|');
}

// AI-METHOD: parseFirmwareVersion — Parse supported V<major>.<minor> labels only.
List<int>? parseFirmwareVersion(String version) {
  final match = RegExp(r'^V(\d+)(?:\.(\d+))?$')
      .firstMatch(version.trim().toUpperCase());
  if (match == null) return null;
  final major = int.tryParse(match.group(1)!);
  final minor = int.tryParse(match.group(2) ?? '0');
  if (major == null || minor == null) return null;
  return <int>[major, minor];
}

// AI-METHOD: isNewerFirmwareVersion — Compatibility/test helper; current OTA policy uses different-version comparison.

// AI-METHOD: isDifferentFirmwareVersion — Current OTA availability rule: any valid version different from device version is an OTA target.
bool isDifferentFirmwareVersion(String latest, String current) {
  final a = parseFirmwareVersion(latest);
  final b = parseFirmwareVersion(current);
  if (a == null || b == null) return false;
  return a[0] != b[0] || a[1] != b[1];
}

// AI-METHOD: canAutoConnect — Pure policy gate for passive Auto Connect.
// It must never prompt for permissions, enable Bluetooth, or connect without a known cooler.
bool canAutoConnect({
  required bool autoConnectEnabled,
  required String? knownRemoteId,
  required bool bluetoothScanGranted,
  required bool bluetoothConnectGranted,
  required bool bluetoothAdapterOn,
  required bool legacyLocationReady,
}) {
  return autoConnectEnabled &&
      knownRemoteId != null &&
      knownRemoteId.trim().isNotEmpty &&
      bluetoothScanGranted &&
      bluetoothConnectGranted &&
      bluetoothAdapterOn &&
      legacyLocationReady;
}

// Static release-audit anchors: firebase_app_check/firebase_core and
// providerAndroid: const AndroidPlayIntegrityProvider() are wired by AppBootstrap;
// TamperScreen remains here and uses the je_x_fyz/security bridge in app_security.dart.
// AppBootstrap owns startup order and cloud-initialization failure policy.
// The official shell receives Dashboard as a child; Tamper UI stays beside the native
// security-channel audit path and does not create or own a device session.
Future<void> main() => AppBootstrap.production().start(
  createOfficialApp: () => const JeCoolerApp(dashboard: DashboardScreen()),
  createTamperApp: () => const TamperApp(),
);

class TamperApp extends StatelessWidget {
  const TamperApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark(useMaterial3: true);
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: darkTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF111113),
        textTheme: darkTheme.textTheme.apply(fontFamily: 'Roboto'),
        primaryTextTheme: darkTheme.primaryTextTheme.apply(
          fontFamily: 'Roboto',
        ),
      ),
      home: const TamperScreen(),
    );
  }
}

class TamperScreen extends StatelessWidget {
  const TamperScreen({super.key});

  Future<void> _contactDeveloper() async {
    try {
      await securityChannel.invokeMethod<bool>('openDeveloperContact');
    } catch (error) {
      debugPrint('Developer contact launch failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = appLanguageNotifier.value;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.jexSurface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Icon(
                      PhosphorIconsBold.warning,
                      color: scheme.jexError,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    JexText.phrase(
                      'Official build verification failed',
                      'Verifikasi build resmi gagal',
                      language,
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    JexText.phrase(
                      'This copy of JE Cooler could not be verified. Install the official release and try again.',
                      'Versi JE Cooler ini tidak dapat diverifikasi. Pasang rilis resmi lalu coba lagi.',
                      language,
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.jexMutedForeground,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: _contactDeveloper,
                      child: Text(JexText.of('contactDeveloper', language)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Backwards-compatible alias for simple widget tests.
typedef MyApp = JeCoolerApp;

// --- DASHBOARD CONTROLLER: BLE lifecycle, telemetry, commands, OTA initiation, rendering ---
// AI-MEMORY / DASHBOARD OWNERSHIP
// DashboardScreen owns live UI state and BLE coordination for one JE X FYZ session.
// It may present firmware state but must never override firmware safety decisions.

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  static const MethodChannel batteryChannel = MethodChannel(
    'je_x_fyz/battery_temp',
  );

  BluetoothDevice? device;
  BluetoothCharacteristic? rx;
  BluetoothCharacteristic? tx;
  StreamSubscription<BluetoothConnectionState>? connectionSub;
  StreamSubscription<List<int>>? notificationSub;

  Future<void> _writeQueue = Future<void>.value();
  Timer? batteryTimer;
  Timer? voltageGuardTimer;
  Timer? reconnectTimer;
  Timer? disconnectRediscoveryTimer;
  StreamSubscription<List<ScanResult>>? disconnectRediscoverySub;
  final ConnectionScanCoordinator _connectionScanCoordinator =
      ConnectionScanCoordinator();
  Future<void> _manualConnectionSheetPreparation = Future<void>.value();
  bool hotAlertArmed = true;

  bool _bleReady = false;
  bool _bleSessionReady = false;
  bool protocolValid = false;
  bool _syncReadyAck = false;
  bool connected = false;
  bool runtimeOutputsKnown = false;
  bool syncing = false;
  bool fullSyncReceived = false;
  bool voltageGuardActive = false;
  bool adaptiveTransitioning = false;
  bool batteryReadBusy = false;
  bool dashboardReady = false;
  bool _bleConnecting = false;
  bool otaExpectedDisconnect = false;
  bool otaRecoveryActive = false;
  bool otaRecoveryScanInProgress = false;
  final P1AckWaiterCoordinator _ackWaiters = P1AckWaiterCoordinator();
  final Map<String, String> _syncSnapshot = {};
  String _lastCommandAckReason = '';
  String _lastPeltierAckFailureReason = '';
  Future<void> _commandTransactionQueue = Future<void>.value();
  String? _pendingPhoneBatteryCommand;
  bool _phoneBatteryHeartbeatQueued = false;
  final Map<String, String> _pendingTelemetry = {};

  int brightnessDraft = 100;
  int fanSpeedDraft = 100;
  int hotLimitDraft = 45;
  int battery5Draft = 25;
  int battery12Draft = 35;
  // Dashboard owns one decoder instance for the active BLE session; only framing state lives here.
  final P1FrameDecoder _p1FrameDecoder = P1FrameDecoder();
  String notice = '';
  String pendingOtaResult = '';
  int _homeNotifyRevision = 0;
  bool _floatingStartPending = false;
  bool _floatingStartAttemptedForSession = false;

  String voltage = '--';
  String hotsideTemp = '--';
  String phoneBatteryTemp = '--';
  bool phoneBatteryValid = false;
  bool fanOn = false;
  bool peltierOn = false;
  bool adaptiveOn = false;
  bool voltageLockKnown = false;
  bool voltageLockActive = false;
  bool voltageLockSaved = false;
  bool voltageLockBusy = false;
  String adaptiveCeiling = '12V';
  String adaptiveProfile = 'HOTSIDE';
  bool rgbOn = false;
  int rgbMode = 1;
  int brightness = 100;
  String rgbColor = '#FFFFFF';
  int ledPhaseMs = 0;
  int ledCycleMs = 1000;
  int ledSyncRevision = 0;
  int fanSpeed = 100;
  int hotLimit = 45;
  int battery5Limit = 25;
  int battery12Limit = 35;
  String safety = 'LOCKED';
  String safetyReason = 'WAITING_FOR_NTC';
  String firmwareVersion = 'V?';
  String resetReason = 'UNKNOWN';
  String otaState = 'IDLE';
  String otaStage = 'IDLE';
  int otaProgress = 0;
  int otaErrorCode = 0;
  String otaError = 'NONE';
  int stateSequence = 0;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appAutoConnectNotifier.addListener(_handleAutoConnectPreferenceChanged);
    appLanguageNotifier.addListener(_handleLanguagePreferenceChanged);
    unawaited(_syncNotificationChannelLanguage());
    // Immediately detach any stale native overlay while this app session is offline.
    _publishFloatingTelemetry();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoConnect());
    try {
      FlutterBluePlus.setOperationQueueMode(OperationQueueMode.perDevice);
    } catch (e) {
      debugPrint('BLE operation queue: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appAutoConnectNotifier.removeListener(_handleAutoConnectPreferenceChanged);
    appLanguageNotifier.removeListener(_handleLanguagePreferenceChanged);
    disconnectRediscoverySub?.cancel();
    connectionSub?.cancel();
    notificationSub?.cancel();
    batteryTimer?.cancel();
    unawaited(
      UsageStatisticsRecorder.instance.endSession(reason: 'dashboard_disposed'),
    );
    voltageGuardTimer?.cancel();
    reconnectTimer?.cancel();
    disconnectRediscoveryTimer?.cancel();
    disconnectRediscoveryTimer = null;
    disconnectRediscoverySub?.cancel();
    disconnectRediscoverySub = null;
    _connectionScanCoordinator.invalidatePassiveAttempts();
    device?.disconnect();
    _ackWaiters.completeAll('CANCELLED');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    // Re-check overlay permission after returning from Android Settings without
    // making repeated permission-channel calls for every telemetry frame.
    _floatingStartAttemptedForSession = false;
    if (connected && _bleReady && _bleSessionReady) {
      unawaited(_requestFreshSync(timeout: const Duration(seconds: 4)));
    } else if (!connected && !otaRecoveryActive && !otaExpectedDisconnect) {
      _startDisconnectRediscovery();
    } else {
      unawaited(_tryAutoConnect());
    }
  }

  // Rebuild localized status from the current language without waiting for new BLE traffic.
  // The overlay telemetry and existing Bluetooth foreground service also receive the new
  // language so their persistent presentation does not remain in the previous locale.
  void _handleLanguagePreferenceChanged() {
    if (!mounted) return;
    setState(() {});
    unawaited(_syncNotificationChannelLanguage());
    _publishFloatingTelemetry();
    if (connected) unawaited(_setBackgroundService(true));
  }

  // Update every Android notification channel to match the persisted App language,
  // even when the BLE foreground service and Floating Monitor are not running.
  Future<void> _syncNotificationChannelLanguage() async {
    try {
      await const MethodChannel('je_x_fyz/notifications').invokeMethod<void>(
        'updateNotificationChannelLanguage',
        <String, dynamic>{'language': appLanguageNotifier.value.name},
      );
    } catch (e) {
      debugPrint('Notification channel language: $e');
    }
  }

  // AI-METHOD / AUTO-CONNECT-PREFERENCE-CONTRACT
  // Enabling Auto Connect reevaluates the passive prerequisites immediately. Disabling it
  // cancels pending automatic reconnect work. This callback never requests permissions or
  // changes Bluetooth power state.
  void _handleAutoConnectPreferenceChanged() {
    if (appAutoConnectNotifier.value) {
      if (!connected && !otaRecoveryActive && !otaExpectedDisconnect) {
        _startDisconnectRediscovery();
      } else {
        unawaited(_tryAutoConnect());
      }
    } else if (!otaRecoveryActive && !otaExpectedDisconnect) {
      reconnectTimer?.cancel();
      reconnectTimer = null;
      unawaited(_cancelDisconnectRediscovery());
    }
  }

  // AI-METHOD / AUTO-CONNECT-CONTRACT
  // Auto Connect is passive: no BLE permission prompts, no Bluetooth power-on, and no
  // device scan until a previously successful cooler identity is known and all OS state
  // is already ready.
  Future<void> _tryAutoConnect() async {
    if (connected ||
        syncing ||
        _bleConnecting ||
        _connectionScanCoordinator.isManualSheetOpen ||
        _connectionScanCoordinator.isConnectionHandoffActive ||
        _connectionScanCoordinator.hasActiveOneShotAttempt ||
        _connectionScanCoordinator.hasActivePassiveAttempt ||
        (reconnectTimer?.isActive ?? false) ||
        !appAutoConnectNotifier.value ||
        knownCoolerRemoteIdNotifier.value == null) {
      return;
    }

    final scanPermission = await Permission.bluetoothScan.status;
    final connectPermission = await Permission.bluetoothConnect.status;
    final adapter = await FlutterBluePlus.adapterState.first;
    final sdk = await _androidSdkInt();

    var locationReady = true;
    if (sdk > 0 && sdk <= 30) {
      final permission = await Permission.locationWhenInUse.status;
      var serviceEnabled = true;
      try {
        serviceEnabled =
            await batteryChannel.invokeMethod<bool>(
              'isLocationServiceEnabled',
            ) ??
            false;
      } catch (_) {
        serviceEnabled = false;
      }
      locationReady = permission.isGranted && serviceEnabled;
    }

    if (!canAutoConnect(
      autoConnectEnabled: appAutoConnectNotifier.value,
      knownRemoteId: knownCoolerRemoteIdNotifier.value,
      bluetoothScanGranted: scanPermission.isGranted,
      bluetoothConnectGranted: connectPermission.isGranted,
      bluetoothAdapterOn: adapter == BluetoothAdapterState.on,
      legacyLocationReady: locationReady,
    )) {
      return;
    }

    unawaited(_scanAndConnect(automatic: true));
  }

  Future<void> _postNotification(String title, String body, int id) async {
    try {
      await const MethodChannel('je_x_fyz/notifications')
          .invokeMethod<void>('showNotification', <String, dynamic>{
            'title': title,
            'body': body,
            'id': id,
            'language': appLanguageNotifier.value.name,
          });
    } catch (e) {
      debugPrint('Notification: $e');
    }
  }

  void _publishFloatingTelemetry() {
    final telemetry = FloatingTelemetry(
      // Publish the current authoritative telemetry for the six-metric Floating Monitor.
      battery: connected && phoneBatteryValid ? phoneBatteryTemp : '--',
      hotside: connected ? hotsideTemp : '--',
      voltage: connected ? voltage : '--',
      fanOn: connected && fanOn,
      speed: fanSpeed,
      adaptiveOn: connected && adaptiveOn,
      peltierOn: connected && peltierOn,
      connected: connected,
    );
    floatingTelemetryNotifier.value = telemetry;
    if (!telemetry.connected) {
      _floatingStartAttemptedForSession = false;
      unawaited(FloatingBridge.updateData(telemetry));
      return;
    }
    final config = floatingConfigNotifier.value;
    if (config.enabled &&
        !_floatingStartAttemptedForSession &&
        !_floatingStartPending) {
      unawaited(_restoreFloatingMonitorAfterSync());
    } else {
      unawaited(FloatingBridge.updateData(telemetry));
    }
  }

  Future<void> _restoreFloatingMonitorAfterSync() async {
    if (_floatingStartPending || _floatingStartAttemptedForSession) return;
    _floatingStartPending = true;
    try {
      final config = floatingConfigNotifier.value;
      if (!mounted || !connected || !config.enabled) return;
      // Permission may be granted after Android Settings returns without a BLE reconnect.
      // Leave this attempt retryable until the public overlay permission is available.
      if (!await FloatingBridge.hasPermission()) {
        // Wait until the app resumes from Android Settings before trying again.
        _floatingStartAttemptedForSession = true;
        return;
      }
      final currentTelemetry = floatingTelemetryNotifier.value;
      if (!currentTelemetry.connected || !connected) return;
      _floatingStartAttemptedForSession = true;
      final started = await FloatingBridge.start(
        config,
        telemetry: currentTelemetry,
      );
      if (!started) return;
      final deadline = DateTime.now().add(const Duration(seconds: 3));
      var ready = false;
      while (DateTime.now().isBefore(deadline) && mounted && connected) {
        final state = await FloatingBridge.runtimeState();
        if (state?['running'] == true && state?['overlay'] == true) {
          ready = true;
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 120));
      }
      if (!ready || !mounted || !connected) return;
      await FloatingBridge.updateConfig(config);
      await FloatingBridge.updateData(floatingTelemetryNotifier.value);
    } finally {
      _floatingStartPending = false;
    }
  }

  // AI-METHOD: _requestPermissions — Prepare Android BLE permissions, adapter state, and legacy location requirements.
  Future<bool> _requestPermissions({bool showResult = false}) async {
    if (!Platform.isAndroid) return true;
    try {
      final scan = await Permission.bluetoothScan.request();
      final connect = await Permission.bluetoothConnect.request();
      final sdk = await _androidSdkInt();

      PermissionStatus location = await Permission.locationWhenInUse.status;
      if (sdk > 0 && sdk <= 30) {
        location = await Permission.locationWhenInUse.request();
      }

      var adapter = await FlutterBluePlus.adapterState.first;
      if (adapter == BluetoothAdapterState.off) {
        try {
          await FlutterBluePlus.turnOn();
          adapter = await FlutterBluePlus.adapterState
              .where((state) => state == BluetoothAdapterState.on)
              .first
              .timeout(const Duration(seconds: 8));
        } catch (e) {
          debugPrint('Bluetooth turn on: $e');
        }
      }

      bool locationService = true;
      try {
        locationService =
            await batteryChannel.invokeMethod<bool>(
              'isLocationServiceEnabled',
            ) ??
            false;
      } catch (e) {
        debugPrint('Location service state: $e');
      }

      final bluetoothReady =
          scan.isGranted &&
          connect.isGranted &&
          adapter == BluetoothAdapterState.on;
      final locationReady = sdk > 30 || (location.isGranted && locationService);
      final ready = bluetoothReady && locationReady;

      if (showResult && mounted) {
        _showSnackBar(
          ready
              ? JexText.of('connectionReady', appLanguageNotifier.value)
              : JexText.of('connectionNeedsAccess', appLanguageNotifier.value),
          color: ready ? Colors.green : Colors.orangeAccent,
        );
      }
      return ready;
    } catch (e) {
      debugPrint('Permission setup: $e');
      return false;
    }
  }

  // AI-METHOD: _setBackgroundService — Bridge the active BLE session to the native foreground service.
  Future<void> _setBackgroundService(bool enabled) async {
    if (!Platform.isAndroid) return;
    try {
      await batteryChannel.invokeMethod<void>(
        enabled ? 'startBackgroundService' : 'stopBackgroundService',
        enabled
            ? <String, dynamic>{'language': appLanguageNotifier.value.name}
            : null,
      );
    } catch (e) {
      debugPrint('Background service ' + (enabled ? 'start' : 'stop') + ': $e');
    }
  }

  Future<int> _androidSdkInt() async {
    if (!Platform.isAndroid) return 0;
    try {
      return await batteryChannel.invokeMethod<int>('getAndroidSdkInt') ?? 0;
    } catch (e) {
      debugPrint('Android SDK check: $e');
      return 0;
    }
  }

  // Serialize each scanner command while the one-shot lease reserves scanner ownership
  // across prerequisite awaits and the complete discovery/fallback sequence.
  Future<bool> _runOneShotScannerCommand(
    int attempt,
    Future<void> Function() operation,
  ) async {
    var operationCompletedForCurrentAttempt = false;
    await _connectionScanCoordinator.runSerialized(() async {
      if (!mounted ||
          !_connectionScanCoordinator.isOneShotAttemptCurrent(attempt)) {
        return;
      }
      await operation();
      operationCompletedForCurrentAttempt =
          mounted &&
          _connectionScanCoordinator.isOneShotAttemptCurrent(attempt);
    });
    return operationCompletedForCurrentAttempt;
  }

  // AI-METHOD: _scanAndConnect — Perform bounded BLE discovery and pass the matching device to the connection routine.
  Future<void> _scanAndConnect({
    bool automatic = false,
    bool otaRecovery = false,
  }) async {
    if (syncing) return;

    // Reserve synchronously before the first asynchronous permission/adapter check.
    // This excludes duplicate one-shot work and passive rediscovery while prerequisites
    // are pending. Opening the manual sheet or beginning a connection invalidates it.
    final attempt = _connectionScanCoordinator.beginOneShotAttempt();
    if (attempt == null) return;

    bool isCurrentAttempt() =>
        mounted && _connectionScanCoordinator.isOneShotAttemptCurrent(attempt);

    StreamSubscription<List<ScanResult>>? scanSub;
    BluetoothDevice? found;
    var ownsSyncing = false;

    try {
      if (automatic) {
        final scanPermission = await Permission.bluetoothScan.status;
        if (!isCurrentAttempt()) return;
        final connectPermission = await Permission.bluetoothConnect.status;
        if (!isCurrentAttempt()) return;
        final adapter = await FlutterBluePlus.adapterState.first;
        if (!isCurrentAttempt()) return;
        final sdk = await _androidSdkInt();
        if (!isCurrentAttempt()) return;

        var locationReady = true;
        if (sdk > 0 && sdk <= 30) {
          final permission = await Permission.locationWhenInUse.status;
          if (!isCurrentAttempt()) return;
          var serviceEnabled = true;
          try {
            serviceEnabled =
                await batteryChannel.invokeMethod<bool>(
                  'isLocationServiceEnabled',
                ) ??
                false;
          } catch (_) {
            serviceEnabled = false;
          }
          if (!isCurrentAttempt()) return;
          locationReady = permission.isGranted && serviceEnabled;
        }

        if (!canAutoConnect(
          autoConnectEnabled: otaRecovery || appAutoConnectNotifier.value,
          knownRemoteId: knownCoolerRemoteIdNotifier.value,
          bluetoothScanGranted: scanPermission.isGranted,
          bluetoothConnectGranted: connectPermission.isGranted,
          bluetoothAdapterOn: adapter == BluetoothAdapterState.on,
          legacyLocationReady: locationReady,
        )) {
          return;
        }
      } else {
        final accessReady = await _requestPermissions();
        if (!isCurrentAttempt()) return;
        if (!accessReady) {
          if (mounted) {
            setState(() {
              notice = JexText.of(
                'connectionAccessRequired',
                appLanguageNotifier.value,
              );
            });
          }
          return;
        }
      }

      // Recheck mutable App/connection state immediately before taking the UI
      // scanning state and issuing native scanner commands.
      if (!isCurrentAttempt() ||
          syncing ||
          (automatic && (connected || _bleConnecting))) {
        return;
      }

      setState(() {
        syncing = true;
        notice = JexText.of('scanning', appLanguageNotifier.value);
      });
      ownsSyncing = true;

      if (!await _runOneShotScannerCommand(
        attempt,
        () => FlutterBluePlus.stopScan(),
      )) {
        return;
      }

      final completer = Completer<BluetoothDevice?>();
      scanSub = FlutterBluePlus.onScanResults.listen(
        (results) {
          if (!isCurrentAttempt()) return;
          for (final result in results) {
            final serviceMatch = result.advertisementData.serviceUuids.any(
              (uuid) => uuid.toString().toLowerCase() == serviceUuid,
            );
            final name = result.advertisementData.advName.trim().toLowerCase();
            final platformName = result.device.platformName
                .trim()
                .toLowerCase();
            final knownMatch =
                knownCoolerRemoteIdNotifier.value != null &&
                result.device.remoteId.toString() ==
                    knownCoolerRemoteIdNotifier.value;
            final matches = automatic
                ? (knownMatch && serviceMatch)
                : (serviceMatch ||
                      name == 'je x fyz' ||
                      platformName == 'je x fyz');
            if (matches) {
              if (!completer.isCompleted) completer.complete(result.device);
              break;
            }
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        },
      );

      if (!await _runOneShotScannerCommand(
        attempt,
        () => FlutterBluePlus.startScan(
          withServices: <Guid>[Guid(serviceUuid)],
          timeout: const Duration(seconds: 10),
          androidCheckLocationServices: false,
          androidUsesFineLocation: false,
        ),
      )) {
        return;
      }

      found = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
      if (!isCurrentAttempt()) return;

      if (!await _runOneShotScannerCommand(
        attempt,
        () => FlutterBluePlus.stopScan(),
      )) {
        return;
      }

      // Some ESP32-C3 advertising stacks omit the 128-bit service UUID from
      // the first scan packet. The fresh-result fallback preserves the known
      // remote-ID match for that case without accepting retained prior results.
      if (found == null) {
        await scanSub.cancel();
        scanSub = null;
        if (!isCurrentAttempt()) return;

        final fallback = Completer<BluetoothDevice?>();
        scanSub = FlutterBluePlus.onScanResults.listen(
          (results) {
            if (!isCurrentAttempt()) return;
            for (final result in results) {
              final name = result.advertisementData.advName
                  .trim()
                  .toLowerCase();
              final platformName = result.device.platformName
                  .trim()
                  .toLowerCase();
              final knownMatch =
                  knownCoolerRemoteIdNotifier.value != null &&
                  result.device.remoteId.toString() ==
                      knownCoolerRemoteIdNotifier.value;
              final matches = automatic
                  ? knownMatch
                  : (name == 'je x fyz' || platformName == 'je x fyz');
              if (matches) {
                if (!fallback.isCompleted) fallback.complete(result.device);
                break;
              }
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!fallback.isCompleted) {
              fallback.completeError(error, stackTrace);
            }
          },
        );

        if (!await _runOneShotScannerCommand(
          attempt,
          () => FlutterBluePlus.startScan(
            timeout: const Duration(seconds: 6),
            androidCheckLocationServices: false,
            androidUsesFineLocation: false,
          ),
        )) {
          return;
        }

        found = await fallback.future.timeout(
          const Duration(seconds: 6),
          onTimeout: () => null,
        );
        if (!isCurrentAttempt()) return;

        if (!await _runOneShotScannerCommand(
          attempt,
          () => FlutterBluePlus.stopScan(),
        )) {
          return;
        }
      }

      if (!isCurrentAttempt()) return;
      if (found == null) {
        _showSnackBar(JexText.of('deviceNotFound'), color: Colors.orangeAccent);
        return;
      }

      // _connect() synchronously takes over with its connection-handoff fence.
      await _connect(found);
    } catch (e) {
      debugPrint('BLE scan: $e');
      _showSnackBar(JexText.of('scanFailed'), color: Colors.redAccent);
    } finally {
      // Best-effort cleanup for failures after scanner startup. The lease check
      // prevents an invalidated attempt from stopping a newer owner's scan.
      if (ownsSyncing && isCurrentAttempt()) {
        try {
          await _runOneShotScannerCommand(
            attempt,
            () => FlutterBluePlus.stopScan(),
          );
        } catch (e) {
          debugPrint('BLE scan cleanup: $e');
        }
      }
      await scanSub?.cancel();
      _connectionScanCoordinator.finishOneShotAttempt(attempt);
      if (ownsSyncing && mounted && !connected) {
        setState(() => syncing = false);
      }
    }
  }

  // AI-METHOD: _connect — Create a clean GATT session, discover the contract, and complete P1 synchronization.
  Future<void> _connect(BluetoothDevice target) async {
    // Keep passive scans blocked from the moment this async handoff starts until
    // _bleConnecting is set; selected-sheet close may happen before these awaits end.
    _connectionScanCoordinator.beginConnectionHandoff();
    try {
      await _cancelDisconnectRediscovery();
      await _connectionScanCoordinator.runSerialized(
        () => FlutterBluePlus.stopScan(),
      );
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await connectionSub?.cancel();
      await notificationSub?.cancel();
      batteryTimer?.cancel();
      voltageGuardTimer?.cancel();
    } catch (_) {
      _connectionScanCoordinator.completeConnectionHandoff();
      rethrow;
    }

    // Never let a previous failed/stalled GATT write block the next session.
    _writeQueue = Future<void>.value();

    try {
      if (device != null && device!.remoteId != target.remoteId) {
        await device!.disconnect();
      }
    } catch (_) {}
    device = target;
    _bleConnecting = true;
    _connectionScanCoordinator.completeConnectionHandoff();
    rx = null;
    tx = null;
    _bleReady = false;
    _bleSessionReady = false;
    protocolValid = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    _lastPeltierAckFailureReason = '';
    _p1FrameDecoder.clear();
    _syncSnapshot.clear();
    _pendingTelemetry.clear();

    if (mounted) {
      setState(() {
        syncing = true;
        connected = false;
        runtimeOutputsKnown = false;
        dashboardReady = false;
        voltageLockKnown = false;
        voltageLockActive = false;
        voltageLockSaved = false;
        voltageLockBusy = false;
        voltage = '--';
        hotsideTemp = '--';
        phoneBatteryTemp = '--';
        phoneBatteryValid = false;
        fanOn = false;
        peltierOn = false;
        adaptiveOn = false;
        rgbOn = false;
        ledPhaseMs = 0;
        ledCycleMs = 1000;
        ledSyncRevision++;
        safety = 'LOCKED';
        safetyReason = 'WAITING_FOR_SENSOR_VALIDATION';
        firmwareVersion = 'V?';
        resetReason = 'UNKNOWN';
        notice = JexText.of('connectingDevice', appLanguageNotifier.value);
      });
      _publishVoltageLockSettings();
      _publishFloatingTelemetry();
    }

    connectionSub = target.connectionState.listen((state) {
      if (state != BluetoothConnectionState.disconnected) return;

      // AI-METHOD: _handleBleDisconnected — Central BLE teardown path; clear stale timers, ACKs, session state, and UI telemetry.
      _handleBleDisconnected();
    });

    Object? lastError;
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        await target.connect(
          license: License.nonprofit,
          autoConnect: false,
          timeout: const Duration(seconds: 18),
          mtu: 247,
        );

        // FlutterBluePlus already performs the Android MTU request when `mtu`
        // is supplied to connect(). Avoid an immediate duplicate GATT operation
        // which can make some Android/ESP32 combinations unstable.
        await target.connectionState
            .where((state) => state == BluetoothConnectionState.connected)
            .first
            .timeout(const Duration(seconds: 4));

        // AI-METHOD: _discoverServices — Discover exact JE X FYZ service/RX/TX, enable notifications, and complete SYNC/SYNC_READY.
        await _discoverServices(target);
        // Reaching here means GATT discovery + SYNC + SYNC_READY succeeded; only now
        // is this cooler eligible for future passive Auto Connect.
        await KnownCoolerStore.save(target.remoteId.toString());
        lastError = null;
        break;
      } catch (e) {
        lastError = e;
        debugPrint('BLE connect/discovery attempt ${attempt + 1}: $e');
        await notificationSub?.cancel();
        notificationSub = null;
        _bleReady = false;
        _bleSessionReady = false;
        protocolValid = false;
        try {
          await target.disconnect();
        } catch (_) {}
        if (attempt == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 700));
        }
      }
    }

    _bleConnecting = false;

    if (lastError != null) {
      final message = lastError is StateError
          ? lastError.message
          : 'Connection failed.';
      if (mounted) {
        setState(() {
          connected = false;
          syncing = false;
          notice = _compactNotifyMessage(message);
        });
      }
      throw lastError;
    }
  }

  // AI-METHOD: _handleBleDisconnected — Central BLE teardown path; clear stale timers, ACKs, session state, and UI telemetry.
  Future<void> _cancelDisconnectRediscovery() async {
    // Invalidate immediately, before awaiting subscription cleanup. A scanOnce()
    // suspended in a permission/adapter Future must re-check its generation before
    // touching the shared scanner.
    _connectionScanCoordinator.invalidatePassiveAttempts();
    disconnectRediscoveryTimer?.cancel();
    disconnectRediscoveryTimer = null;
    final subscription = disconnectRediscoverySub;
    disconnectRediscoverySub = null;
    await subscription?.cancel();
  }

  void _startDisconnectRediscovery() {
    if (!mounted ||
        connected ||
        syncing ||
        _bleConnecting ||
        _connectionScanCoordinator.isManualSheetOpen ||
        _connectionScanCoordinator.isConnectionHandoffActive) {
      return;
    }
    if (!appAutoConnectNotifier.value ||
        knownCoolerRemoteIdNotifier.value == null) {
      unawaited(_cancelDisconnectRediscovery());
      return;
    }
    if (reconnectTimer?.isActive ?? false) return;

    final previousSubscriptionCleanup = _cancelDisconnectRediscovery();
    var attempts = 0;

    Future<void> scanOnce() async {
      if (!mounted ||
          connected ||
          syncing ||
          _bleConnecting ||
          _connectionScanCoordinator.isManualSheetOpen ||
          _connectionScanCoordinator.isConnectionHandoffActive ||
          (reconnectTimer?.isActive ?? false) ||
          attempts >= 10) {
        unawaited(_cancelDisconnectRediscovery());
        return;
      }

      final attempt = _connectionScanCoordinator.beginPassiveAttempt();
      if (attempt == null) return;
      bool isCurrentAttempt() =>
          mounted &&
          _connectionScanCoordinator.isPassiveAttemptCurrent(attempt);

      try {
        await previousSubscriptionCleanup;
        if (!isCurrentAttempt()) return;

        final scanPermission = await Permission.bluetoothScan.status;
        if (!isCurrentAttempt()) return;
        final connectPermission = await Permission.bluetoothConnect.status;
        if (!isCurrentAttempt()) return;
        final adapter = await FlutterBluePlus.adapterState.first;
        if (!isCurrentAttempt()) return;
        final sdk = await _androidSdkInt();
        if (!isCurrentAttempt()) return;

        var locationReady = true;
        if (sdk > 0 && sdk <= 30) {
          final permission = await Permission.locationWhenInUse.status;
          if (!isCurrentAttempt()) return;
          var serviceEnabled = true;
          try {
            serviceEnabled =
                await batteryChannel.invokeMethod<bool>(
                  'isLocationServiceEnabled',
                ) ??
                false;
          } catch (_) {
            serviceEnabled = false;
          }
          if (!isCurrentAttempt()) return;
          locationReady = permission.isGranted && serviceEnabled;
        }

        if (!canAutoConnect(
          autoConnectEnabled: appAutoConnectNotifier.value,
          knownRemoteId: knownCoolerRemoteIdNotifier.value,
          bluetoothScanGranted: scanPermission.isGranted,
          bluetoothConnectGranted: connectPermission.isGranted,
          bluetoothAdapterOn: adapter == BluetoothAdapterState.on,
          legacyLocationReady: locationReady,
        )) {
          unawaited(_cancelDisconnectRediscovery());
          return;
        }

        attempts++;
        await _connectionScanCoordinator.runSerialized(() async {
          if (!isCurrentAttempt()) return;
          await FlutterBluePlus.stopScan();
          if (!isCurrentAttempt()) return;

          final previous = disconnectRediscoverySub;
          disconnectRediscoverySub = null;
          await previous?.cancel();
          if (!isCurrentAttempt()) return;

          disconnectRediscoverySub = FlutterBluePlus.onScanResults.listen((
            results,
          ) {
            if (!isCurrentAttempt() || connected || _bleConnecting) return;
            for (final result in results) {
              final serviceMatch = result.advertisementData.serviceUuids.any(
                (uuid) => uuid.toString().toLowerCase() == serviceUuid,
              );
              final knownMatch =
                  knownCoolerRemoteIdNotifier.value != null &&
                  result.device.remoteId.toString() ==
                      knownCoolerRemoteIdNotifier.value;
              if (serviceMatch && knownMatch) {
                unawaited(_cancelDisconnectRediscovery());
                // Passive rediscovery has no awaiting caller; consume connection failures
                // after _connect updates the existing disconnected/error presentation.
                unawaited(
                  _connect(result.device)
                      .catchError((Object error, StackTrace stackTrace) {
                        debugPrint('BLE passive connection: $error');
                      }),
                );
                break;
              }
            }
          });

          if (!isCurrentAttempt()) {
            final staleSubscription = disconnectRediscoverySub;
            disconnectRediscoverySub = null;
            await staleSubscription?.cancel();
            return;
          }
          await FlutterBluePlus.startScan(
            withServices: <Guid>[Guid(serviceUuid)],
            timeout: const Duration(seconds: 2),
            androidCheckLocationServices: false,
            androidUsesFineLocation: false,
          );
        });

        // startScan() resolves once scanning has started. Keep this passive
        // attempt active until the plugin reports that the scan has completed
        // (timeout, connection handoff, manual-sheet pre-emption or stopScan()).
        await FlutterBluePlus.isScanning.where((scanning) => !scanning).first;
        if (!isCurrentAttempt()) return;
      } catch (e) {
        if (isCurrentAttempt()) {
          debugPrint('BLE disconnect rediscovery: $e');
        }
      } finally {
        _connectionScanCoordinator.finishPassiveAttempt(attempt);
      }
    }

    unawaited(scanOnce());
    disconnectRediscoveryTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(scanOnce()),
    );
  }

  // AI-METHOD: _startUsageStatisticsSession — Start only after full P1 readiness
  // and only when authoritative Firmware output telemetry confirms cooling activity.
  void _startUsageStatisticsSession() {
    final recorder = UsageStatisticsRecorder.instance;
    final sessionReady =
        connected &&
        dashboardReady &&
        _bleSessionReady &&
        protocolValid &&
        runtimeOutputsKnown;
    if (!sessionReady ||
        !usageCoolerIsActive(fanOn: fanOn, peltierOn: peltierOn)) {
      unawaited(recorder.endSession(reason: 'cooler_off'));
      return;
    }

    final coolerId =
        device?.remoteId.toString() ?? knownCoolerRemoteIdNotifier.value ?? '';
    final normalizedVoltage = voltage.trim().toUpperCase();
    final validVoltage = const {'5V', '9V', '12V'}.contains(normalizedVoltage)
        ? normalizedVoltage
        : null;
    unawaited(
      recorder.startSession(
        coolerId: coolerId,
        batteryC: phoneBatteryValid ? double.tryParse(phoneBatteryTemp) : null,
        hotsideC: hotsideTemp == '--' ? null : double.tryParse(hotsideTemp),
        voltage: validVoltage,
        adaptive: adaptiveOn ? 'ON' : 'OFF',
        peltier: peltierOn ? 'ON' : 'OFF',
        fanSpeed: fanOn ? fanSpeed : 0,
      ),
    );
  }

  // Record only authoritative P1 telemetry after the Dashboard has passed SYNC_READY.
  // A cooling session is active while either physical output is confirmed ON.
  void _recordUsageTelemetry(Map<String, String> values) {
    if (!connected || !dashboardReady || !_bleSessionReady || !protocolValid) {
      return;
    }

    final recorder = UsageStatisticsRecorder.instance;
    final outputStateReported =
        values.containsKey('FAN') || values.containsKey('PELTIER');
    final coolerActive = usageCoolerIsActive(
      fanOn: fanOn,
      peltierOn: peltierOn,
    );

    // Open the session before recording the state changes that caused the
    // OFF→ON transition. startSession is idempotent for the same cooler.
    if (outputStateReported && coolerActive) {
      _startUsageStatisticsSession();
    }

    if (values.containsKey('HOT')) {
      unawaited(
        recorder.recordTemperature(
          metric: 'hotside',
          value: hotsideTemp == '--' ? null : double.tryParse(hotsideTemp),
        ),
      );
    }

    if (values.containsKey('VOLTAGE')) {
      final normalized = voltage.trim().toUpperCase();
      if (const {'5V', '9V', '12V'}.contains(normalized)) {
        unawaited(recorder.recordState(metric: 'voltage', value: normalized));
      }
    }

    if (values.containsKey('ADAPTIVE')) {
      unawaited(
        recorder.recordState(
          metric: 'adaptive',
          value: adaptiveOn ? 'ON' : 'OFF',
        ),
      );
    }

    // Peltier state is recorded only from authoritative P1 telemetry.
    if (values.containsKey('PELTIER')) {
      unawaited(
        recorder.recordState(
          metric: 'peltier',
          value: peltierOn ? 'ON' : 'OFF',
        ),
      );
    }

    // A stored PWM setting while the physical fan is OFF is represented as 0%.
    if (values.containsKey('FAN') || values.containsKey('FAN_SPEED')) {
      unawaited(
        recorder.recordState(metric: 'fan_speed', value: fanOn ? fanSpeed : 0),
      );
    }

    // Record any final state/sample carried by the OFF packet before closing
    // the session. When Fan remains ON for thermal protection, the session stays open.
    if (outputStateReported && !coolerActive) {
      unawaited(recorder.endSession(reason: 'cooler_off'));
    }
  }

  void _handleBleDisconnected() {
    final expectedOtaDisconnect = otaExpectedDisconnect || otaRecoveryActive;
    unawaited(
      UsageStatisticsRecorder.instance.endSession(
        reason: expectedOtaDisconnect ? 'ota_handoff' : 'disconnected',
      ),
    );

    unawaited(_setBackgroundService(false));
    notificationSub?.cancel();
    notificationSub = null;
    _bleReady = false;
    _bleSessionReady = false;
    protocolValid = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    dashboardReady = false;
    _pendingTelemetry.clear();
    _lastPeltierAckFailureReason = '';
    if (!expectedOtaDisconnect) {
      pendingOtaResult = '';
    }
    batteryTimer?.cancel();

    _ackWaiters.completeAll('DISCONNECTED');
    if (_bleConnecting) return;
    if (!mounted) return;
    setState(() {
      connected = false;
      runtimeOutputsKnown = false;
      syncing = false;
      dashboardReady = false;
      voltageLockKnown = false;
      voltageLockActive = false;
      voltageLockSaved = false;
      voltageLockBusy = false;
      voltage = '--';
      fanOn = false;
      peltierOn = false;
      adaptiveOn = false;
      rgbOn = false;
      hotsideTemp = '--';
      phoneBatteryTemp = '--';
      phoneBatteryValid = false;
      safety = 'LOCKED';
      safetyReason = 'DISCONNECTED';
      firmwareVersion = 'V?';
      resetReason = 'UNKNOWN';
      notice = expectedOtaDisconnect
          ? JexText.of('otaInProgress', appLanguageNotifier.value)
          : JexText.of('bluetoothDisconnected', appLanguageNotifier.value);
    });
    _publishVoltageLockSettings();
    _publishFloatingTelemetry();

    // Start reconnect only after connected=false has been committed.
    if (expectedOtaDisconnect) {
      unawaited(_cancelDisconnectRediscovery());
      if (!(reconnectTimer?.isActive ?? false)) {
        _startOtaReconnectMonitor();
      }
    } else {
      _startDisconnectRediscovery();
    }

    if (!expectedOtaDisconnect && appNotifyBluetoothNotifier.value) {
      unawaited(
        _postNotification(
          JexText.of('device', appLanguageNotifier.value),
          JexText.of('bluetoothDisconnected', appLanguageNotifier.value),
          2103,
        ),
      );
    }
  }

  // AI-METHOD: _discoverServices — Discover exact JE X FYZ service/RX/TX, enable notifications, and complete SYNC/SYNC_READY.
  Future<void> _discoverServices(BluetoothDevice target) async {
    BluetoothCharacteristic? discoveredRx;
    BluetoothCharacteristic? discoveredTx;

    for (var discoveryAttempt = 0; discoveryAttempt < 2; discoveryAttempt++) {
      final services = await target.discoverServices().timeout(
        const Duration(seconds: 8),
      );
      discoveredRx = null;
      discoveredTx = null;

      for (final service in services) {
        final serviceId = service.uuid.toString().toLowerCase();
        if (serviceId != serviceUuid) continue;
        for (final characteristic in service.characteristics) {
          final id = characteristic.uuid.toString().toLowerCase();
          if (id == rxUuid) discoveredRx = characteristic;
          if (id == txUuid) discoveredTx = characteristic;
        }
      }

      if (discoveredRx != null && discoveredTx != null) break;

      if (Platform.isAndroid && discoveryAttempt == 0) {
        try {
          await target.clearGattCache();
        } catch (e) {
          debugPrint('BLE GATT cache clear: $e');
        }
        await Future<void>.delayed(const Duration(milliseconds: 350));
      }
    }

    if (discoveredRx == null || discoveredTx == null) {
      throw StateError(
        JexText.of('bleServiceDiscoveryFailed', appLanguageNotifier.value),
      );
    }

    rx = discoveredRx;
    tx = discoveredTx;

    // Register the listener BEFORE enabling notifications. Also register the
    // subscription with FlutterBluePlus so it is cancelled automatically with
    // the device connection.
    await notificationSub?.cancel();
    notificationSub = discoveredTx.lastValueStream.listen((bytes) {
      if (bytes.isNotEmpty) {
        // AI-METHOD: _parseIncoming — Parse framed full-sync data and newline telemetry/ACK messages.
        _parseIncoming(utf8.decode(bytes, allowMalformed: true));
      }
    });
    target.cancelWhenDisconnected(notificationSub!);

    await discoveredTx.setNotifyValue(true).timeout(const Duration(seconds: 5));
    await Future<void>.delayed(const Duration(milliseconds: 220));

    _bleReady = true;

    // V3.2 keeps the V3.1 atomic SYNC -> SYNC_READY protocol. Give the device
    // several opportunities to drain its automatic connect-time sync and then
    // request a clean snapshot ourselves.
    for (
      var attempt = 0;
      attempt < 5 && !fullSyncReceived && mounted;
      attempt++
    ) {
      // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
      await sendCommand('SYNC', showError: false);
      final deadline = DateTime.now().add(const Duration(milliseconds: 1500));
      while (mounted &&
          !fullSyncReceived &&
          DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
    }

    if (!fullSyncReceived) {
      // If the first GATT session did not deliver notifications, re-subscribe
      // once before failing. The service cache was already validated above.
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await discoveredTx.setNotifyValue(false);
      await discoveredTx.setNotifyValue(true);

      for (
        var attempt = 0;
        attempt < 3 && !fullSyncReceived && mounted;
        attempt++
      ) {
        // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
        await sendCommand('SYNC', showError: false);
        final deadline = DateTime.now().add(const Duration(milliseconds: 1000));
        while (mounted &&
            !fullSyncReceived &&
            DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 35));
        }
      }
    }

    if (!fullSyncReceived) {
      throw StateError(JexText.of('bleSyncFailed', appLanguageNotifier.value));
    }

    // Phase 2: open the firmware command gate. No runtime state is written by
    // the App before the firmware confirms this handshake.
    _bleSessionReady = false;
    protocolValid = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    final readyAccepted = await sendCommand('SYNC_READY', showError: false);
    if (!readyAccepted) {
      throw StateError(
        JexText.of('bleHandshakeWriteFailed', appLanguageNotifier.value),
      );
    }

    final readyDeadline = DateTime.now().add(
      const Duration(milliseconds: 3500),
    );
    while (mounted &&
        !(_syncReadyAck &&
            fullSyncReceived &&
            _bleSessionReady &&
            protocolValid) &&
        DateTime.now().isBefore(readyDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!_syncReadyAck ||
        !fullSyncReceived ||
        !_bleSessionReady ||
        !protocolValid) {
      throw StateError(
        JexText.of('bleSessionNotReady', appLanguageNotifier.value),
      );
    }

    // Final synchronized snapshot includes the phone battery temperature.
    // AI-METHOD: _readBatteryTemperatureOnce — Read phone battery temperature through Android.
    await _readBatteryTemperatureOnce(updateUi: false);
    fullSyncReceived = false;
    // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
    await sendCommand('SYNC', showError: false);
    final finalSyncDeadline = DateTime.now().add(
      const Duration(milliseconds: 2500),
    );
    while (mounted &&
        !fullSyncReceived &&
        DateTime.now().isBefore(finalSyncDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!fullSyncReceived) {
      throw StateError(JexText.of('fullSyncFailed', appLanguageNotifier.value));
    }

    if (!mounted) return;

    final wasOtaRecovery = otaRecoveryActive || otaExpectedDisconnect;
    final readySnapshot = Map<String, String>.from(_pendingTelemetry);
    _pendingTelemetry.clear();
    final syncedOtaResult = readySnapshot['LAST_OTA_RESULT'] ?? '';
    final resultEvent = pendingOtaResult.isNotEmpty
        ? pendingOtaResult
        : syncedOtaResult;
    // Format only when displayed so a language change during synchronization uses the current locale.
    final syncedOtaNotice = isTransientOtaResultEvent(resultEvent)
        ? _friendlyOtaResult(resultEvent)
        : '';
    pendingOtaResult = '';

    setState(() {
      for (final entry in readySnapshot.entries) {
        // AI-METHOD: _applyTelemetryValue — Map firmware telemetry keys into typed Flutter state.
        _applyTelemetryValue(entry.key, entry.value);
      }
      connected = true;
      runtimeOutputsKnown = true;
      syncing = false;
      dashboardReady = true;
      notice = syncedOtaNotice.isNotEmpty
          ? syncedOtaNotice
          : JexText.of('systemReady', appLanguageNotifier.value);
    });
    _publishVoltageLockSettings();
    _publishFloatingTelemetry();
    _startUsageStatisticsSession();

    if (wasOtaRecovery) {
      reconnectTimer?.cancel();
      reconnectTimer = null;
      otaRecoveryActive = false;
      otaExpectedDisconnect = false;
      otaRecoveryScanInProgress = false;
      if (appNotifyBluetoothNotifier.value && syncedOtaNotice.isNotEmpty) {
        unawaited(
          _postNotification(
            JexText.of('device', appLanguageNotifier.value),
            syncedOtaNotice,
            2102,
          ),
        );
      }
    } else if (appNotifyBluetoothNotifier.value) {
      unawaited(
        _postNotification(
          JexText.of('device', appLanguageNotifier.value),
          JexText.of('bluetoothConnected', appLanguageNotifier.value),
          2102,
        ),
      );
    }
    // AI-METHOD: _startBatteryTelemetry — Start the 1 Hz phone-battery heartbeat.
    _startBatteryTelemetry();
    unawaited(_setBackgroundService(true));

    if (isUserVisibleResetReason(resetReason)) {
      _showSnackBar(_friendlyReset(resetReason), color: Colors.orangeAccent);
    }
  }

  Future<void> _disconnect() async {
    try {
      await device?.disconnect();
    } catch (e) {
      debugPrint('disconnect: $e');
    }
  }

  // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
  Future<bool> sendCommand(String command, {bool showError = true}) {
    final completer = Completer<bool>();
    _writeQueue = _writeQueue
        .then((_) async {
          if (!_bleReady || rx == null) {
            if (showError && mounted) {
              _showSnackBar(
                JexText.of('bluetoothNotReady'),
                color: Colors.orangeAccent,
              );
            }
            if (!completer.isCompleted) completer.complete(false);
            return;
          }

          final normalized = command.trim().toUpperCase();
          if (!_bleSessionReady &&
              normalized != 'SYNC' &&
              normalized != 'SYNC_READY') {
            if (!completer.isCompleted) completer.complete(false);
            return;
          }

          final payload = utf8.encode('$command\n');
          final withoutResponse = P1CommandContract.usesWriteWithoutResponse(
            command,
            supportsWriteWithoutResponse: rx!.properties.writeWithoutResponse,
          );

          try {
            await rx!
                .write(payload, withoutResponse: withoutResponse)
                .timeout(const Duration(seconds: 4));
            if (!completer.isCompleted) completer.complete(true);
          } catch (e) {
            debugPrint('BLE write $command: $e');

            if (!completer.isCompleted) completer.complete(false);
          }
        })
        .catchError((_) {
          if (!completer.isCompleted) completer.complete(false);
        });
    return completer.future;
  }

  String? _ackItemForCommand(String command) =>
      P1CommandContract.ackItemForCommand(command);

  // AI-METHOD: _sendAndWaitAck — Send a command and await its firmware acknowledgement.
  Future<bool> _sendAndWaitAckInternal(
    String command, {
    bool showError = true,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    _lastCommandAckReason = '';
    final item = _ackItemForCommand(command);
    if (item == 'PELTIER') {
      _lastPeltierAckFailureReason = '';
    }
    if (item == null) return sendCommand(command, showError: showError);
    final ackWaiter = _ackWaiters.register(item);
    final ackFuture = _ackWaiters.waitFor(ackWaiter, timeout: timeout);
    final sent = await sendCommand(command, showError: showError);
    if (!sent) {
      _lastCommandAckReason = 'WRITE_FAILED';
      _ackWaiters.cancel(ackWaiter, reason: 'WRITE_FAILED');
      return false;
    }
    final reason = await ackFuture;
    _lastCommandAckReason = reason;
    final accepted = _isAckSuccessReason(reason);
    if (!accepted) return false;

    final expected = _expectedTelemetryForCommand(command);
    if (expected == null) return true;
    final confirmed = await _waitUntil(
      () => _telemetryValueMatches(expected.key, expected.value),
      timeout: timeout,
    );
    if (confirmed) return true;

    // A delta can be lost during a transient BLE notification gap. Reconcile
    // once from the firmware snapshot rather than trusting stale local state.
    final reconciled = await _requestFreshSync(
      timeout: const Duration(seconds: 2),
    );
    return reconciled && _telemetryValueMatches(expected.key, expected.value);
  }

  Future<bool> _sendAndWaitAck(
    String command, {
    bool showError = true,
    Duration timeout = const Duration(seconds: 3),
  }) {
    final next = _commandTransactionQueue.then<bool>(
      (_) => _sendAndWaitAckInternal(
        command,
        showError: showError,
        timeout: timeout,
      ),
    );
    _commandTransactionQueue = next.then<void>((_) {}, onError: (_) {});
    return next;
  }

  MapEntry<String, String>? _expectedTelemetryForCommand(String command) =>
      P1CommandContract.expectedTelemetryForCommand(command);

  bool _telemetryValueMatches(String key, String expected) {
    switch (key) {
      case 'FAN':
        return fanOn == (expected == 'ON');
      case 'PELTIER':
        return peltierOn == (expected == 'ON');
      case 'ADAPTIVE':
        return adaptiveOn == (expected == 'ON');
      case 'VOLTAGE_LOCK':
        return voltageLockKnown &&
            voltageLockActive == (expected.toUpperCase() == 'ON');
      case 'VOLTAGE':
        return voltage.toUpperCase() == expected.toUpperCase();
      case 'RGB':
        return rgbOn == (expected == 'ON');
      case 'MODE':
        return rgbMode == (int.tryParse(expected) ?? -1);
      case 'BRIGHTNESS':
        return brightness == (int.tryParse(expected) ?? -1);
      case 'RGB_COLOR':
        return normalizeLedColor(rgbColor) == normalizeLedColor(expected);
      case 'FAN_SPEED':
        return fanSpeed == (int.tryParse(expected) ?? -1);
      case 'TEMP_HOT_LIMIT':
        return hotLimit == (int.tryParse(expected) ?? -1);
      case 'BATT_5':
        return battery5Limit == (int.tryParse(expected) ?? -1);
      case 'BATT_12':
        return battery12Limit == (int.tryParse(expected) ?? -1);
      case 'ADAPTIVE_PROFILE':
        return adaptiveProfile.toUpperCase() == expected.toUpperCase();
      default:
        return false;
    }
  }

  Future<bool> _waitUntil(
    bool Function() predicate, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (mounted && DateTime.now().isBefore(deadline)) {
      if (predicate()) return true;
      await Future<void>.delayed(const Duration(milliseconds: 35));
    }
    return predicate();
  }

  // AI-METHOD: _parseIncoming — Dispatch decoded P1 frames to Dashboard-owned ACK and telemetry state.
  void _parseIncoming(String incoming) {
    for (final event in _p1FrameDecoder.addChunk(incoming)) {
      if (event is P1LineFrame) {
        _applyLine(event.line);
        continue;
      }
      if (event is P1SyncFrame) {
        _syncSnapshot.clear();
        for (final rawLine in event.payload.split('\n')) {
          final line = rawLine.trim();
          if (line.isEmpty) continue;
          if (line.startsWith('ACK:')) {
            _handleAckLine(line);
            continue;
          }
          final separator = line.indexOf(':');
          if (separator <= 0) continue;
          final key = line.substring(0, separator).trim();
          final value = line.substring(separator + 1).trim();
          _syncSnapshot[key] = value;
        }
        // Only Dashboard may commit the complete atomic snapshot or advance readiness.
        _commitTelemetry(_syncSnapshot);
        fullSyncReceived = true;
      }
    }
  }

  bool _isAckSuccessReason(String reason) =>
      P1CommandContract.isAckSuccessReason(reason);

  String? _friendlyAckSuccess(String item, String reason) {
    if (item == 'TOUCH_COOLING') {
      return reason == 'ON'
          ? JexText.phrase('Cooling started.', 'Pendinginan dimulai.')
          : reason == 'OFF'
          ? JexText.phrase('Cooling stopped.', 'Pendinginan dihentikan.')
          : null;
    }
    if (item == 'TOUCH_ADAPTIVE' && reason == 'OFF') {
      return JexText.phrase(
        'Adaptive Mode turned OFF.',
        'Mode Adaptif dimatikan.',
      );
    }
    return null;
  }

  void _handleAckLine(String line) {
    final parts = line.substring(4).split(';');
    final item = parts.isNotEmpty
        ? parts[0].split('=').first.trim().toUpperCase()
        : '';
    final rawReason = parts.length > 1 && parts[1].startsWith('REASON=')
        ? parts[1].substring(7)
        : 'UNKNOWN';
    final reason = rawReason.trim().toUpperCase();

    final hadWaiter = _ackWaiters.completeNext(item, reason);

    if (item == 'SYNC_READY' && _isAckSuccessReason(reason)) {
      _syncReadyAck = true;
      return;
    }

    if (!_isAckSuccessReason(reason)) {
      if (item == 'PELTIER') {
        _lastPeltierAckFailureReason = reason;
      }
      if (!hadWaiter) {
        _showSnackBar(_friendlyReason(reason), color: Colors.orangeAccent);
      }
      return;
    }

    if (!hadWaiter) {
      final successMessage = _friendlyAckSuccess(item, reason);
      if (successMessage != null) _showSnackBar(successMessage);
    }
  }

  void _applyLine(String line) {
    if (line.isEmpty) return;
    if (line.startsWith('ACK:')) {
      _handleAckLine(line);
      return;
    }
    final separator = line.indexOf(':');
    if (separator <= 0) return;
    final key = line.substring(0, separator).trim();
    final value = line.substring(separator + 1).trim();
    // AI-METHOD: _commitTelemetry — Buffer setup telemetry until dashboard readiness; otherwise update UI state.
    _commitTelemetry(<String, String>{key: value});
  }

  // AI-METHOD: _commitTelemetry — Buffer setup telemetry until dashboard readiness; otherwise update UI state.
  void _commitTelemetry(Map<String, String> values) {
    if (values.isEmpty) return;

    // The BLE session gate must be observable during the pre-dashboard
    // handshake. The firmware sends BLE_SESSION=READY inside the SYNC_READY
    // full snapshot, while all other telemetry remains buffered until the
    // final verified sync is complete.
    if (!dashboardReady) {
      final session = values['BLE_SESSION'];
      if (session != null) {
        _bleSessionReady = session.trim().toUpperCase() == 'READY';
      }
      final protocol = values['PROTOCOL'];
      if (protocol != null) {
        protocolValid = isSupportedP1Protocol(protocol);
      }
      final otaResult = values['LAST_OTA_RESULT'];
      if (otaResult != null && isTransientOtaResultEvent(otaResult)) {
        pendingOtaResult = otaResult;
      }
      _pendingTelemetry.addAll(values);
      return;
    }

    if (!mounted) return;
    final liveCoolingTelemetryReceived =
        values.containsKey('FAN') ||
        values.containsKey('PELTIER') ||
        values.containsKey('ADAPTIVE') ||
        values.containsKey('VOLTAGE') ||
        values.containsKey('FAN_SPEED') ||
        values.containsKey('SAFETY') ||
        values.containsKey('SAFETY_REASON');

    final previousHotsideAtLimit = homeHotsideLimitReached(
      hotsideTemp,
      hotLimit: hotLimit,
    );
    String? latestTelemetryNotice;
    String? latestSafetyReason;

    setState(() {
      for (final entry in values.entries) {
        final previousValue = _homeNotifyTelemetryValue(entry.key);
        final previousReason = safetyReason;
        // AI-METHOD: _applyTelemetryValue — Map firmware telemetry keys into typed Flutter state.
        _applyTelemetryValue(entry.key, entry.value);
        final currentValue = _homeNotifyTelemetryValue(entry.key);

        if (previousValue != null &&
            currentValue != null &&
            previousValue != currentValue) {
          final eventNotice = homeNotifyForTelemetryChange(
            key: entry.key,
            previousValue: previousValue,
            currentValue: currentValue,
            language: appLanguageNotifier.value,
          );
          if (eventNotice != null) latestTelemetryNotice = eventNotice;
        }

        if (entry.key == 'SAFETY_REASON' && safetyReason != previousReason) {
          latestSafetyReason = safetyReason;
        }
      }

      if (shouldClearStaleNotifyError(
        connected: connected,
        safety: safety,
        safetyReason: safetyReason,
        liveTelemetryReceived: liveCoolingTelemetryReceived,
        notice: notice,
      )) {
        notice = JexText.of('systemReady', appLanguageNotifier.value);
      }

      final hotsideAtLimit = homeHotsideLimitReached(
        hotsideTemp,
        hotLimit: hotLimit,
      );
      if (hotsideAtLimit) {
        // Safety is authoritative while the threshold is active.
        if (!previousHotsideAtLimit) {
          notice = homeHotsideLimitNotice(
            hotsideTemp,
            hotLimit: hotLimit,
            language: appLanguageNotifier.value,
          );
          _homeNotifyRevision++;
        } else if (latestTelemetryNotice != null ||
            latestSafetyReason != null) {
          // Retire an in-flight ACK without replacing the active safety warning.
          _homeNotifyRevision++;
        }
      } else if (isActiveHomeSafetyReason(safetyReason)) {
        if (latestTelemetryNotice != null || latestSafetyReason != null) {
          notice = _friendlyReason(safetyReason);
          _homeNotifyRevision++;
        }
      } else if (latestTelemetryNotice != null) {
        // The most recent confirmed control/LED event outranks ordinary operating reasons.
        notice = latestTelemetryNotice!;
        _homeNotifyRevision++;
      } else if (latestSafetyReason != null) {
        // Preserve actionable known reason copy instead of replacing it with a generic label.
        notice = safetyReason.trim().toUpperCase() == 'NONE'
            ? JexText.phrase(
                'Safety condition cleared.',
                'Kondisi keselamatan kembali normal.',
                appLanguageNotifier.value,
              )
            : _friendlyReason(safetyReason);
        _homeNotifyRevision++;
      }
    });

    _recordUsageTelemetry(values);

    final hotText = values['HOT'];
    final hot = hotText == null ? null : double.tryParse(hotText);
    if (hot != null && hot.isFinite) {
      if (hot < hotLimit) hotAlertArmed = true;
      if (hot >= hotLimit && hotAlertArmed && connected) {
        hotAlertArmed = false;
        final hotNotice = homeHotsideLimitNotice(
          hotsideTemp,
          hotLimit: hotLimit,
          language: appLanguageNotifier.value,
        );
        // Always update the in-app NOTIFY card. Android push remains governed by
        // the user's safety-notification preference.
        if (mounted && notice != hotNotice) {
          setState(() {
            notice = hotNotice;
            _homeNotifyRevision++;
          });
        }
        if (appNotifySafetyNotifier.value) {
          unawaited(
            _postNotification(
              JexText.of('safetyAlert', appLanguageNotifier.value),
              hotNotice,
              2101,
            ),
          );
        }
      }
    }
    _publishFloatingTelemetry();
  }

  // Read confirmed values whose changes should create a user-facing event.
  // Ordinary HOT/BATTERY temperature samples are deliberately excluded.
  String? _homeNotifyTelemetryValue(String key) {
    switch (key) {
      case 'VOLTAGE':
        return voltage;
      case 'FAN':
        return fanOn ? 'ON' : 'OFF';
      case 'PELTIER':
        return peltierOn ? 'ON' : 'OFF';
      case 'ADAPTIVE':
        return adaptiveOn ? 'ON' : 'OFF';
      case 'SAFETY':
        return safety.toUpperCase();
      case 'FAN_SPEED':
        return fanSpeed.toString();
      case 'RGB':
        return rgbOn ? 'ON' : 'OFF';
      case 'MODE':
      case 'LED_SYNC':
        return rgbMode.toString();
      case 'BRIGHTNESS':
        return brightness.toString();
      case 'RGB_COLOR':
        return rgbColor.toUpperCase();
      case 'ADAPTIVE_PROFILE':
        return adaptiveProfile.toUpperCase();
      case 'ADAPTIVE_CEILING':
        return adaptiveCeiling.toUpperCase();
      default:
        return null;
    }
  }

  // AI-METHOD: _applyTelemetryValue — Map firmware telemetry keys into typed Flutter state.
  void _applyTelemetryValue(String key, String value) {
    switch (key) {
      case 'VERSION':
        firmwareVersion = value;
        break;
      case 'PROTOCOL':
        protocolValid = isSupportedP1Protocol(value);
        break;
      case 'STATE_SEQ':
        stateSequence = int.tryParse(value) ?? stateSequence;
        break;
      case 'BLE_SESSION':
        _bleSessionReady = value == 'READY';
        break;
      case 'VOLTAGE_LOCK':
        voltageLockKnown =
            value.trim().toUpperCase() == 'ON' ||
            value.trim().toUpperCase() == 'OFF';
        voltageLockActive = value.trim().toUpperCase() == 'ON';
        _publishVoltageLockSettings();
        break;
      case 'VOLTAGE_LOCK_SAVED':
        voltageLockSaved = value.trim().toUpperCase() == 'ON';
        _publishVoltageLockSettings();
        break;
      case 'VOLTAGE':
        voltage = value;
        // 5V is the safe handoff milestone; wait for ADAPTIVE=ON for completion.
        break;
      case 'FAN':
        fanOn = value == 'ON';
        break;
      case 'PELTIER':
        peltierOn = value == 'ON';
        break;
      case 'HOT':
        hotsideTemp = value == '--' ? '--' : value;
        break;
      case 'BATTERY':
        phoneBatteryTemp = value;
        break;
      case 'BATTERY_VALID':
        phoneBatteryValid = value == '1';
        if (!phoneBatteryValid) phoneBatteryTemp = '--';
        break;
      case 'ADAPTIVE':
        adaptiveOn = value == 'ON';
        adaptiveTransitioning = false;
        break;
      case 'ADAPTIVE_CEILING':
        adaptiveCeiling = value;
        break;
      case 'ADAPTIVE_PROFILE':
        adaptiveProfile = value.toUpperCase();
        break;
      case 'RGB':
        rgbOn = value == 'ON';
        break;
      case 'MODE':
        // V6.6+ treats LED_SYNC as the atomic owner of mode/phase/cycle.
        // Older firmware sends only MODE plus separate phase fields.
        final activeFirmware = parseFirmwareVersion(firmwareVersion);
        final atomicLedSync =
            activeFirmware != null &&
            (activeFirmware[0] > 6 ||
                (activeFirmware[0] == 6 && activeFirmware[1] >= 6));
        if (!atomicLedSync) {
          rgbMode = (int.tryParse(value) ?? rgbMode).clamp(1, 7).toInt();
        }
        break;
      case 'LED_SYNC':
        final snapshot = LedSyncSnapshot.parse(value);
        if (snapshot != null) {
          rgbMode = snapshot.mode;
          ledPhaseMs = snapshot.phaseMs;
          ledCycleMs = snapshot.cycleMs;
          ledSyncRevision++;
        }
        break;
      // Backward compatibility for older firmware that emitted two separate fields.
      case 'LED_PHASE':
        ledPhaseMs = math.max(0, int.tryParse(value) ?? ledPhaseMs);
        break;
      case 'LED_CYCLE_MS':
        ledCycleMs = math.max(1, int.tryParse(value) ?? ledCycleMs);
        ledPhaseMs %= ledCycleMs;
        ledSyncRevision++;
        break;
      case 'BRIGHTNESS':
        brightness = (int.tryParse(value) ?? brightness).clamp(1, 100).toInt();
        brightnessDraft = brightness;
        break;
      case 'RGB_COLOR':
        rgbColor = value;
        break;
      case 'FAN_SPEED':
        fanSpeed = int.tryParse(value) ?? fanSpeed;
        fanSpeedDraft = fanSpeed;
        break;
      case 'SAFETY':
        safety = value;
        break;
      case 'SAFETY_REASON':
        safetyReason = value;
        break;
      case 'OTA_STATE':
        otaState = value;
        break;
      case 'OTA_STAGE':
        otaStage = value;
        break;
      case 'OTA_PROGRESS':
        otaProgress = (int.tryParse(value) ?? otaProgress)
            .clamp(0, 100)
            .toInt();
        break;
      case 'OTA_ERROR_CODE':
        otaErrorCode = int.tryParse(value) ?? otaErrorCode;
        break;
      case 'OTA_ERROR':
        otaError = value;
        break;
      case 'LAST_OTA_RESULT':
        // LAST_OTA_RESULT is event-only. Baseline/history values never replace Home NOTIFY.
        if (isTransientOtaResultEvent(value)) {
          notice = _friendlyOtaResult(value);
          if (value.trim().toUpperCase().startsWith('OTA_UP_TO_DATE|')) {
            otaExpectedDisconnect = false;
            otaRecoveryActive = false;
            otaRecoveryScanInProgress = false;
            reconnectTimer?.cancel();
            reconnectTimer = null;
          }
        }
        break;
      case 'RESET_REASON':
        resetReason = value;
        break;
      case 'TEMP_HOT_LIMIT':
        hotLimit = (int.tryParse(value) ?? hotLimit).clamp(40, 50).toInt();
        hotLimitDraft = hotLimit;
        break;
      case 'BATT_5':
        battery5Limit = (int.tryParse(value) ?? battery5Limit)
            .clamp(20, 30)
            .toInt();
        battery5Draft = battery5Limit;
        break;
      case 'BATT_12':
        battery12Limit = (int.tryParse(value) ?? battery12Limit)
            .clamp(30, 40)
            .toInt();
        battery12Draft = battery12Limit;
        break;
      case 'NTC_MV':
        break;
    }
  }

  // AI-METHOD: _startBatteryTelemetry — Start the 1 Hz phone-battery heartbeat.
  void _startBatteryTelemetry() {
    batteryTimer?.cancel();
    batteryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _readBatteryTemperatureOnce();
    });
  }

  // AI-METHOD / PHONE-BATTERY-HEARTBEAT-CONTRACT
  // Coalesce 1 Hz values so only the newest heartbeat is retained.
  void _queuePhoneBatteryHeartbeat(String command) {
    _pendingPhoneBatteryCommand = command;
    if (_phoneBatteryHeartbeatQueued) return;
    _phoneBatteryHeartbeatQueued = true;
    _writeQueue = _writeQueue
        .then((_) async {
          final pending = _pendingPhoneBatteryCommand;
          _pendingPhoneBatteryCommand = null;
          try {
            if (pending == null || !_bleReady || rx == null) return;
            final payload = utf8.encode('$pending\n');
            final withoutResponse = P1CommandContract.usesWriteWithoutResponse(
              pending,
              supportsWriteWithoutResponse: rx!.properties.writeWithoutResponse,
            );
            await rx!
                .write(payload, withoutResponse: withoutResponse)
                .timeout(const Duration(seconds: 4));
          } catch (e) {
            debugPrint('BLE heartbeat $pending: $e');
          } finally {
            _phoneBatteryHeartbeatQueued = false;
            if (_pendingPhoneBatteryCommand != null && _bleReady) {
              _queuePhoneBatteryHeartbeat(_pendingPhoneBatteryCommand!);
            }
          }
        })
        .catchError((_) {
          _phoneBatteryHeartbeatQueued = false;
        });
  }

  // AI-METHOD: _readBatteryTemperatureOnce — Read phone battery temperature through Android.
  Future<void> _readBatteryTemperatureOnce({bool updateUi = true}) async {
    if (batteryReadBusy) return;
    batteryReadBusy = true;
    try {
      final value = await batteryChannel.invokeMethod<dynamic>(
        'getBatteryTemperature',
      );
      final temp = value is num ? value.toDouble() : -1.0;
      final valid = temp >= 0.0 && temp <= 100.0;
      if (updateUi && mounted) {
        setState(() {
          phoneBatteryValid = valid;
          phoneBatteryTemp = valid ? temp.toStringAsFixed(1) : '--';
        });
        _publishFloatingTelemetry();
      }
      unawaited(
        UsageStatisticsRecorder.instance.recordTemperature(
          metric: 'battery',
          value: valid ? temp : null,
        ),
      );
      if (_bleReady) {
        _queuePhoneBatteryHeartbeat(
          valid ? 'PHONE:BT=' + temp.toStringAsFixed(1) : 'PHONE:BT=-1.0',
        );
      }
    } catch (e) {
      debugPrint('Battery temp: $e');
      if (updateUi && mounted) {
        setState(() {
          phoneBatteryValid = false;
          phoneBatteryTemp = '--';
        });
        _publishFloatingTelemetry();
      }
      unawaited(
        UsageStatisticsRecorder.instance.recordTemperature(
          metric: 'battery',
          value: null,
        ),
      );
      if (_bleReady) {
        // Keep Firmware's battery reading unknown after an unavailable platform sample.
        _queuePhoneBatteryHeartbeat('PHONE:BT=-1.0');
      }
    } finally {
      batteryReadBusy = false;
    }
  }

  // AI-METHOD: _sendAndConfirm — Wait for telemetry confirmation after a state-changing command.
  Future<bool> _sendAndConfirm(
    String command, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    // If newer telemetry arrives while the ACK is pending, it must keep priority.
    final noticeRevisionAtStart = _homeNotifyRevision;
    final previousFanSpeed = fanSpeed;
    final accepted = await _sendAndWaitAck(
      command,
      showError: false,
      timeout: timeout,
    );
    if (accepted) {
      _notifyCommandAccepted(
        command,
        expectedRevision: noticeRevisionAtStart,
        previousFanSpeed: previousFanSpeed,
      );
    }
    return accepted;
  }

  // AI-METHOD: _requestVoltage — Apply the 1-second manual voltage guard.
  Future<void> _requestVoltage(String target) async {
    if (voltageLockKnown && voltageLockActive && target != '5V') {
      if (mounted)
        _showSnackBar(
          _friendlyReason('VOLTAGE_LOCKED'),
          color: Colors.orangeAccent,
        );
      return;
    }
    if (!connected ||
        adaptiveOn ||
        voltageGuardActive ||
        !isVoltageCommand(target)) {
      return;
    }
    if (target == voltage) return;

    try {
      if (mounted) setState(() => voltageGuardActive = true);
      voltageGuardTimer?.cancel();
      voltageGuardTimer = Timer(voltageGuardDuration, () {
        if (mounted) setState(() => voltageGuardActive = false);
      });
      final accepted = await _sendAndConfirm(
        'VOLTAGE:$target',
        timeout: const Duration(seconds: 3),
      );
      if (!accepted) {
        voltageGuardTimer?.cancel();
        if (mounted) {
          setState(() => voltageGuardActive = false);
          _showSnackBar(
            JexText.phrase(
              'The device did not confirm the voltage change.',
              'Perangkat belum mengonfirmasi perubahan tegangan.',
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Voltage command: $e');
      voltageGuardTimer?.cancel();
      if (mounted) {
        setState(() => voltageGuardActive = false);
        _showSnackBar(
          JexText.phrase(
            'Voltage change failed.',
            'Perubahan tegangan gagal diterapkan.',
          ),
        );
      }
    }
  }

  // AI-METHOD / FAN-COMMAND-CONTRACT
  // Send only the frozen FAN:ON/FAN:OFF protocol token. Firmware telemetry is authoritative;
  // this function never invents or localizes the protocol value. User-facing errors are localized.
  Future<void> _toggleFan(bool enabled) async {
    if (!connected || adaptiveOn) return;
    try {
      final ok = await _sendAndConfirm(enabled ? 'FAN:ON' : 'FAN:OFF');
      if (!ok && mounted) {
        _showSnackBar(
          JexText.phrase(
            'The device did not confirm the Fan change.',
            'Perangkat belum mengonfirmasi perubahan kipas.',
          ),
          color: Colors.orangeAccent,
        );
      }
    } catch (e) {
      debugPrint('Fan command: $e');
      if (mounted)
        _showSnackBar(
          JexText.phrase(
            'Fan command failed.',
            'Perintah kipas gagal dijalankan.',
          ),
          color: Colors.orangeAccent,
        );
    }
  }

  // AI-METHOD / PELTIER-COMMAND-CONTRACT
  // When the popup approves Peltier startup from Fan-OFF, confirm FAN:ON first.
  // PELTIER:ON is sent only after the device acknowledges that the fan is on.
  Future<void> _togglePeltier(bool enabled) async {
    if (!connected || adaptiveOn) return;
    try {
      if (enabled && !fanOn) {
        final approved = await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: true,
          barrierLabel: JexText.of('peltierSafety', appLanguageNotifier.value),
          barrierColor: Colors.black.withValues(alpha: .54),
          transitionDuration: const Duration(milliseconds: 190),
          pageBuilder: (dialogContext, _, __) {
            return JexFixedScalePage(
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (dialogContext, constraints) {
                    final compactHeight = constraints.maxHeight < 520;
                    final scheme = Theme.of(dialogContext).colorScheme;
                    final fontFamily =
                        Theme.of(dialogContext)
                            .textTheme
                            .bodyMedium
                            ?.fontFamily ??
                        'Roboto';
                    final verticalPadding = compactHeight ? 11.0 : 14.0;
                    final sectionGap = compactHeight ? 6.0 : 8.0;

                    Widget step(IconData icon, String label) => Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: compactHeight ? 6 : 8,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.jexElevatedSurface.withValues(
                            alpha: .42,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: scheme.jexMutedForeground,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.jexForeground,
                                fontFamily: fontFamily,
                                decoration: TextDecoration.none,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 296),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(
                              14,
                              verticalPadding,
                              14,
                              verticalPadding - 2,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.jexSurface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: scheme.jexOutline.withValues(alpha: .82),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .14),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: DefaultTextStyle.merge(
                              style: TextStyle(
                                fontFamily: fontFamily,
                                decoration: TextDecoration.none,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD69A38)
                                              .withValues(alpha: .14),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          PhosphorIconsRegular.fan,
                                          color: Color(0xFFB7791F),
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 9),
                                      Expanded(
                                        child: Text(
                                          JexText.of(
                                            'peltierFanRequiredTitle',
                                            appLanguageNotifier.value,
                                          ),
                                          style: TextStyle(
                                            color: scheme.jexForeground,
                                            fontFamily: fontFamily,
                                            decoration: TextDecoration.none,
                                            fontSize: compactHeight ? 15 : 15.5,
                                            height: 1.15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: sectionGap),
                                  Text(
                                    JexText.of(
                                      'peltierCoolingPrerequisite',
                                      appLanguageNotifier.value,
                                    ),
                                    style: TextStyle(
                                      color: scheme.jexMutedForeground,
                                      fontFamily: fontFamily,
                                      decoration: TextDecoration.none,
                                      fontSize: compactHeight ? 11.5 : 12.5,
                                      height: 1.3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: sectionGap + 2),
                                  Row(
                                    children: [
                                      step(
                                        PhosphorIconsRegular.fan,
                                        JexText.of(
                                          'fan',
                                          appLanguageNotifier.value,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        child: Icon(
                                          PhosphorIconsRegular.arrowRight,
                                          size: 15,
                                          color: scheme.jexMutedForeground,
                                        ),
                                      ),
                                      step(
                                        PhosphorIconsRegular.snowflake,
                                        JexText.of(
                                          'peltier',
                                          appLanguageNotifier.value,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: compactHeight ? 9 : 11),
                                  SizedBox(
                                    height: 48,
                                    child: FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size.fromHeight(48),
                                        tapTargetSize:
                                            MaterialTapTargetSize.padded,
                                        textStyle: TextStyle(
                                          fontFamily: fontFamily,
                                          decoration: TextDecoration.none,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      icon: const Icon(
                                        PhosphorIconsRegular.power,
                                        size: 17,
                                      ),
                                      label: Text(
                                        JexText.of(
                                          'turnOnFanAndPeltier',
                                          appLanguageNotifier.value,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 0),
                                  SizedBox(
                                    height: 48,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size.fromHeight(48),
                                        tapTargetSize:
                                            MaterialTapTargetSize.padded,
                                        textStyle: TextStyle(
                                          fontFamily: fontFamily,
                                          decoration: TextDecoration.none,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: Text(
                                        JexText.of(
                                          'cancel',
                                          appLanguageNotifier.value,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          transitionBuilder: (_, animation, __, child) {
            final scale = Tween<double>(begin: .97, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: scale, child: child),
            );
          },
        );
        if (approved != true) return;

        // Safety-sensitive paired startup is serialized as one high-level transaction.
        // No generic Fan success is surfaced before the Peltier result is resolved.
        final fanOk = await _sendAndWaitAck('FAN:ON');
        if (!fanOk || !mounted) {
          if (mounted) {
            _showSnackBar(
              JexText.phrase(
                'The device has not confirmed that the fan is on.',
                'Perangkat belum mengonfirmasi bahwa kipas menyala.',
              ),
              color: Colors.orangeAccent,
            );
          }
          return;
        }

        final peltierOk = await _sendAndWaitAck(
          'PELTIER:ON',
          timeout: const Duration(seconds: 6),
        );
        if (!peltierOk && mounted) {
          final reason =
              (_lastPeltierAckFailureReason.isNotEmpty
                      ? _lastPeltierAckFailureReason
                      : safetyReason)
                  .trim()
                  .toUpperCase();
          if (reason == 'PELTIER_SAFETY_LATCH' ||
              reason == 'HOTSIDE_PROTECTION') {
            _showSnackBar(
              peltierRearmNotice(hotLimit, appLanguageNotifier.value),
              color: Colors.redAccent,
            );
          } else {
            _showSnackBar(
              JexText.phrase(
                'The device did not confirm the Peltier change.',
                'Perangkat belum mengonfirmasi perubahan Peltier.',
              ),
              color: Colors.orangeAccent,
            );
          }
        }
        return;
      }

      final ok = await _sendAndConfirm(
        enabled ? 'PELTIER:ON' : 'PELTIER:OFF',
        timeout: const Duration(seconds: 6),
      );
      if (!ok && mounted) {
        final reason = safetyReason.trim().toUpperCase();
        final message = enabled && reason.isNotEmpty && reason != 'NONE'
            ? localizedNotifyReason(
                reason,
                hotLimit: hotLimit,
                language: appLanguageNotifier.value,
              )
            : JexText.phrase(
                'The device did not confirm the Peltier change. Check the safety status.',
                'Perangkat belum mengonfirmasi perubahan Peltier. Periksa status keselamatan.',
                appLanguageNotifier.value,
              );
        _showSnackBar(message, color: Colors.orangeAccent);
      }
    } catch (e) {
      debugPrint('Peltier command: $e');
      if (mounted)
        _showSnackBar(
          JexText.phrase('Peltier command failed.', 'Perintah Peltier gagal.'),
          color: Colors.orangeAccent,
        );
    }
  }

  // AI-METHOD / ADAPTIVE-COMMAND-CONTRACT
  // Send the frozen ADAPTIVE command and wait for telemetry. Firmware determines resulting
  // voltage/safety behavior; Flutter only presents the confirmed state.
  Future<void> _toggleAdaptive(bool enabled) async {
    if (!connected) return;
    if (enabled && voltageLockKnown && voltageLockActive) {
      _showSnackBar(
        _friendlyReason('VOLTAGE_LOCKED'),
        color: Colors.orangeAccent,
      );
      return;
    }
    if (mounted)
      setState(() {
        adaptiveTransitioning = true;
      });
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF',
        timeout: const Duration(seconds: 4),
      );
      if (!ok && mounted) {
        _showSnackBar(
          JexText.phrase(
            'The device did not confirm the Adaptive Mode change.',
            'Perangkat belum mengonfirmasi perubahan Mode Adaptif.',
          ),
          color: Colors.orangeAccent,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          adaptiveTransitioning = false;
        });
      }
    }
  }

  // AI-METHOD: _setRgb — Set master RGB ON/OFF.
  Future<void> _setRgb(bool enabled) async {
    if (!connected) return;
    try {
      final ok = await _sendAndConfirm('RGB:' + (enabled ? 'ON' : 'OFF'));
      if (!ok && mounted) {
        _showSnackBar(
          JexText.phrase(
            'The device did not confirm the RGB power change.',
            'Perangkat belum mengonfirmasi perubahan daya RGB.',
          ),
        );
      }
    } catch (e) {
      debugPrint('LED power command: $e');
      if (mounted)
        _showSnackBar(
          JexText.phrase(
            'LED power command failed.',
            'Perintah daya LED gagal dijalankan.',
          ),
        );
    }
  }

  // AI-METHOD: _setMode — UI index maps to the stable firmware LED mode ID.
  Future<void> _setMode(int displayIndex) async {
    if (!connected) return;
    try {
      final next = ledFirmwareModeForDisplayIndex(displayIndex);
      final ok = await _sendAndConfirm('MODE:$next');
      if (!ok && mounted) {
        _showSnackBar(
          JexText.phrase(
            'The device did not confirm the LED mode change.',
            'Perangkat belum mengonfirmasi perubahan mode LED.',
          ),
        );
      }
    } catch (e) {
      debugPrint('LED mode command: $e');
      if (mounted)
        _showSnackBar(
          JexText.phrase(
            'LED mode command failed.',
            'Perintah mode LED gagal dijalankan.',
          ),
        );
    }
  }

  // AI-METHOD: _setBrightness — Set LED brightness 1–100; firmware maps this to hardware 0–255.
  Future<void> _setBrightness(double value) async {
    if (!connected) return;
    final next = value.round().clamp(1, 100).toInt();
    final previous = brightnessDraft.clamp(1, 100).toInt();

    try {
      final ok = await _sendAndConfirm('BRIGHTNESS:' + next.toString());
      if (ok) {
        if (mounted) {
          setState(() {
            brightness = next;
            brightnessDraft = next;
          });
        }
        return;
      }

      if (mounted) {
        setState(() => brightness = previous);
        _showSnackBar(
          JexText.phrase(
            'The device did not confirm the brightness change.',
            'Perangkat belum mengonfirmasi perubahan kecerahan.',
          ),
        );
      }
    } catch (e) {
      debugPrint('LED brightness command: $e');
      if (mounted) {
        setState(() => brightness = previous);
        _showSnackBar(
          JexText.phrase(
            'LED brightness command failed.',
            'Perintah kecerahan LED gagal dijalankan.',
          ),
        );
      }
    }
  }

  // AI-METHOD: _setRgbColor — Apply one palette color to firmware RGB color.
  Future<bool> _setRgbColor(String hex) async {
    if (!connected || rgbMode == 7) return false;
    final value = hex.trim().toUpperCase();
    if (!ledColorPalette.contains(value)) return false;
    if (value == rgbColor.toUpperCase()) return true;

    try {
      final ok = await _sendAndConfirm('COLOR:' + value.substring(1));
      if (!ok) {
        if (mounted) {
          _showSnackBar(
            JexText.phrase(
              'The device did not confirm the color change.',
              'Perangkat belum mengonfirmasi perubahan warna.',
            ),
          );
        }
        return false;
      }

      if (mounted) {
        setState(() => rgbColor = value);
      }
      return true;
    } catch (e) {
      debugPrint('LED color command: $e');
      if (mounted)
        _showSnackBar(
          JexText.phrase(
            'LED color command failed.',
            'Perintah warna LED gagal dijalankan.',
          ),
        );
      return false;
    }
  }

  // AI-METHOD / FAN-SPEED-CONTRACT
  // Accept 50–100% in 10% steps. Control is valid only for connected, non-Adaptive 12V mode;
  // the UI hides this control entirely when Fan is OFF.
  Future<void> _setFanSpeed(double value) async {
    if (!connected || adaptiveOn || voltage != '12V') return;
    try {
      final next = ((value / 10).round() * 10)
          .clamp(fanSpeedMin, fanSpeedMax)
          .toInt();
      final ok = await _sendAndConfirm('FANSPEED:$next');
      if (!ok && mounted) {
        setState(() => fanSpeedDraft = fanSpeed);
        _showSnackBar(
          JexText.phrase(
            'The device did not confirm the fan-speed change.',
            'Perangkat belum mengonfirmasi perubahan kecepatan kipas.',
          ),
        );
      }
    } catch (e) {
      debugPrint('Fan speed command: $e');
      if (mounted)
        _showSnackBar(
          JexText.phrase(
            'Fan speed command failed.',
            'Perintah kecepatan kipas gagal.',
          ),
        );
    }
  }

  // AI-METHOD: _setHotLimit — Set the hotside protection threshold.
  Future<void> _setHotLimit(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(40, 50).toInt();
      if (mounted) setState(() => hotLimitDraft = next);
      final ok = await _sendAndConfirm('HOTLIMIT:$next');
      if (!ok && mounted) {
        setState(() => hotLimitDraft = hotLimit);
        _showSnackBar(
          JexText.of('hotsideLimitNotConfirmed', appLanguageNotifier.value),
        );
      }
    } catch (e) {
      debugPrint('Hotside limit command: $e');
      if (mounted) {
        setState(() => hotLimitDraft = hotLimit);
        _showSnackBar(
          JexText.of('hotsideLimitFailed', appLanguageNotifier.value),
        );
      }
    }
  }

  // AI-METHOD: _setBattery5 — Set the 5V battery-temperature threshold.
  Future<void> _setBattery5(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(20, 30).toInt();
      if (next >= battery12Limit - 1) return;
      if (mounted) setState(() => battery5Draft = next);
      final ok = await _sendAndConfirm('BATT5:$next');
      if (!ok && mounted) {
        setState(() => battery5Draft = battery5Limit);
        _showSnackBar(
          JexText.of('battery5LimitNotConfirmed', appLanguageNotifier.value),
        );
      }
    } catch (e) {
      debugPrint('Battery 5V command: $e');
      if (mounted) {
        setState(() => battery5Draft = battery5Limit);
        _showSnackBar(
          JexText.of('battery5LimitFailed', appLanguageNotifier.value),
        );
      }
    }
  }

  // AI-METHOD: _setBattery12 — Set the 12V battery-temperature threshold.
  Future<void> _setBattery12(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(30, 40).toInt();
      if (next <= battery5Limit + 1) return;
      if (mounted) setState(() => battery12Draft = next);
      final ok = await _sendAndConfirm('BATT12:$next');
      if (!ok && mounted) {
        setState(() => battery12Draft = battery12Limit);
        _showSnackBar(
          JexText.of('battery12LimitNotConfirmed', appLanguageNotifier.value),
        );
      }
    } catch (e) {
      debugPrint('Battery 12V command: $e');
      if (mounted) {
        setState(() => battery12Draft = battery12Limit);
        _showSnackBar(
          JexText.of('battery12LimitFailed', appLanguageNotifier.value),
        );
      }
    }
  }

  // AI-METHOD: _requestFreshSync — Request a fresh firmware snapshot without replaying local state.
  Future<bool> _requestFreshSync({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    fullSyncReceived = false;
    final sent = await sendCommand('SYNC', showError: false);
    if (!sent) return false;
    return _waitUntil(() => fullSyncReceived, timeout: timeout);
  }

  void _publishVoltageLockSettings() {
    voltageLockSettingsNotifier.value = VoltageLockSettingsState(
      sessionReady:
          connected &&
          dashboardReady &&
          _bleReady &&
          _bleSessionReady &&
          protocolValid,
      known: voltageLockKnown,
      active: voltageLockActive,
      saved: voltageLockSaved,
      busy: voltageLockBusy,
    );
  }

  Future<void> _setVoltageLock(bool enabled) async {
    if (!connected ||
        !dashboardReady ||
        !voltageLockKnown ||
        voltageLockBusy ||
        (enabled == voltageLockActive && voltageLockSaved)) {
      return;
    }

    setState(() => voltageLockBusy = true);
    _publishVoltageLockSettings();
    try {
      final lockCommand = enabled ? 'VOLTAGE_LOCK:ON' : 'VOLTAGE_LOCK:OFF';
      final accepted = await _sendAndWaitAck(
        lockCommand,
        showError: false,
        timeout: const Duration(seconds: 6),
      );
      if (!accepted && mounted) {
        final reason = _lastCommandAckReason;
        _showSnackBar(_friendlyReason(reason), color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) {
        setState(() => voltageLockBusy = false);
        _publishVoltageLockSettings();
      }
    }
  }

  Future<void> _openSettings() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => JexFixedScalePage(
          compactUi: true,
          child: SettingsPage(
            currentFirmwareVersion: firmwareVersion,
            coolerId:
                device?.remoteId.toString() ??
                knownCoolerRemoteIdNotifier.value,
            hotLimit: hotLimit,
            onOpenFirmwareUpdate: _openFirmwareSettings,
            onVoltageLockChanged: _setVoltageLock,
          ),
        ),
      ),
    );
  }

  Future<void> _setAdaptiveProfile(String profile) async {
    if (!connected || adaptiveOn || (voltageLockKnown && voltageLockActive))
      return;
    final ok = await _sendAndConfirm('ADAPTIVE_PROFILE:' + profile);
    if (!ok && mounted) {
      _showSnackBar(
        JexText.phrase(
          'The device did not confirm the Adaptive Profile change.',
          'Perangkat belum mengonfirmasi perubahan Profil Adaptif.',
        ),
        color: Colors.orangeAccent,
      );
    }
  }

  Future<void> _showLedColorPicker() async {
    if (!connected || rgbMode == 7) return;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: JexText.of('color', appLanguageNotifier.value),
      barrierColor: Colors.black.withValues(alpha: .48),
      transitionDuration: const Duration(milliseconds: 210),
      pageBuilder: (dialogContext, _, __) {
        return JexFixedScalePage(
          child: PopScope<void>(
            canPop: false,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (dialogContext, constraints) {
                  // Keep the card compact; only the swatch grid scrolls. Swatches stage
                  // a preview and only Cancel or Select closes the picker.
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 312,
                          maxHeight: jexLedColorPickerMaxHeight(
                            constraints.maxHeight,
                          ),
                        ),
                        child: JexColorPickerCard(
                          colors: ledColorPresets,
                          selected: rgbColor.toUpperCase(),
                          onCancel: () {
                            if (dialogContext.mounted)
                              Navigator.pop(dialogContext);
                          },
                          onSelect: _setRgbColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final scale = Tween<double>(begin: .97, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: scale,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        );
      },
    );
  }

  // AI-METHOD: _openFirmwareSettings — Open the external firmware update dialog.
  Future<void> _openFirmwareSettings() async {
    if (!connected) {
      _showSnackBar(JexText.of('connectFirst'), color: Colors.orangeAccent);
      return;
    }
    // AI-METHOD: _requestFreshSync — Request a fresh firmware snapshot without replaying local state.
    await _requestFreshSync();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => JexFixedScalePage(
        child: FirmwareUpdateDialog(
          currentVersion: firmwareVersion,
          onUpdate: _startCloudOta,
        ),
      ),
    );
  }

  // AI-METHOD: _startCloudOta — Send Online OTA metadata/credentials to firmware and monitor BLE recovery.
  Future<void> _startCloudOta(
    String ssid,
    String password,
    String url,
    String version,
  ) async {
    if (!connected || !url.startsWith('https://')) return;
    if (ssid.trim().isEmpty || password.isEmpty) return;

    final commands = <String>[
      'OTAENTER',
      'SSID:${ssid.trim()}',
      'PASS:$password',
      'URL:$url',
      'VERSION:$version',
      'CLOUDOTA',
    ];

    for (final command in commands) {
      if (command == 'CLOUDOTA') {
        otaExpectedDisconnect = true;
        otaRecoveryActive = true;
        otaRecoveryScanInProgress = false;
      }

      final ok = await _sendAndWaitAck(
        command,
        showError: false,
        timeout: const Duration(seconds: 4),
      );
      if (!ok) {
        final ambiguousCloudOtaStart =
            command == 'CLOUDOTA' &&
            (_lastCommandAckReason == 'TIMEOUT' ||
                _lastCommandAckReason == 'DISCONNECTED');
        if (ambiguousCloudOtaStart) {
          // Missing ACK is not proof of rejection: firmware may already have
          // accepted CLOUDOTA and started its single-radio Wi-Fi handoff.
          // Preserve OTA recovery flags so a disconnect/reconnect or OTA result
          // can resolve the final state instead of showing a false rejection.
          _showSnackBar(
            JexText.phrase(
              'OTA start was not confirmed. Waiting for device reconnection or OTA result.',
              'Konfirmasi awal OTA belum diterima. Menunggu perangkat tersambung kembali atau hasil OTA.',
              appLanguageNotifier.value,
            ),
            color: Colors.orangeAccent,
          );
          return;
        }

        // Roll back only a definite rejection while the BLE session is still up.
        if (command == 'CLOUDOTA' && connected) {
          otaExpectedDisconnect = false;
          otaRecoveryActive = false;
          otaRecoveryScanInProgress = false;
          reconnectTimer?.cancel();
          reconnectTimer = null;
        }
        _showSnackBar(
          JexText.of('otaStartRejected', appLanguageNotifier.value),
          color: Colors.redAccent,
        );
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }

    _showSnackBar(
      JexText.of('otaInProgress', appLanguageNotifier.value),
      color: Colors.purpleAccent,
    );
  }

  // AI-METHOD: _startOtaReconnectMonitor — Retry BLE discovery after OTA disconnect/restart.
  void _startOtaReconnectMonitor() {
    reconnectTimer?.cancel();
    int attempts = 0;
    otaRecoveryActive = true;
    otaRecoveryScanInProgress = false;
    reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted || (!otaExpectedDisconnect && !otaRecoveryActive)) {
        timer.cancel();
        reconnectTimer = null;
        otaRecoveryScanInProgress = false;
        return;
      }

      if (connected || syncing || _bleConnecting) return;

      if (attempts >= 12) {
        timer.cancel();
        reconnectTimer = null;
        otaRecoveryActive = false;
        otaExpectedDisconnect = false;
        otaRecoveryScanInProgress = false;
        if (mounted) {
          setState(() {
            notice = JexText.of(
              'otaReconnectFailed',
              appLanguageNotifier.value,
            );
          });
        }
        return;
      }

      if (otaRecoveryScanInProgress) return;
      otaRecoveryScanInProgress = true;
      attempts++;

      try {
        await _scanAndConnect(automatic: true, otaRecovery: true);
      } catch (e) {
        debugPrint('OTA BLE recovery: $e');
      } finally {
        otaRecoveryScanInProgress = false;
      }

      if (connected) {
        timer.cancel();
        reconnectTimer = null;
      }
    });
  }

  Map<String, String> _otaDiagnosticFields(String raw) {
    final fields = <String, String>{};
    for (final part in raw.split('|')) {
      final index = part.indexOf('=');
      if (index <= 0) continue;
      fields[part.substring(0, index).trim().toUpperCase()] = part
          .substring(index + 1)
          .trim();
    }
    return fields;
  }

  // AI-METHOD: _friendlyOtaStage — Translate frozen OTA stage tokens into localized presentation text.
  String _friendlyOtaStage(String stage) {
    final specialKey = otaStageLocalizationKey(stage);
    if (specialKey.isNotEmpty) {
      return JexText.of(specialKey, appLanguageNotifier.value);
    }
    const keyByStage = <String, String>{
      'LOCAL_FILE_CHECK': 'otaStageLocalFileCheck',
      'LOCAL_SIZE_CHECK': 'otaStageLocalSizeCheck',
      'LOCAL_UPDATE_BEGIN': 'otaStageLocalUpdateBegin',
      'LOCAL_RECEIVE': 'otaStageLocalReceive',
      'LOCAL_FLASH_WRITE': 'otaStageLocalFlashWrite',
      'LOCAL_SIZE_VERIFY': 'otaStageLocalSizeVerify',
      'LOCAL_IMAGE_VERIFY': 'otaStageLocalImageVerify',
      'LOCAL_BOOT_PARTITION': 'otaStageLocalBootPartition',
      'ONLINE_REQUEST': 'otaStageOnlineRequest',
      'ONLINE_VERSION_CHECK': 'otaStageOnlineVersionCheck',
      'ONLINE_UP_TO_DATE': 'otaStageOnlineUpToDate',
      'ONLINE_WIFI_CONNECT': 'otaStageOnlineWifiConnect',
      'ONLINE_WIFI_CONNECTED': 'otaStageOnlineWifiConnected',
      'ONLINE_WIFI_RETRY_2': 'otaStageOnlineWifiRetry2',
      'ONLINE_WIFI_RETRY_3': 'otaStageOnlineWifiRetry3',
      'ONLINE_WIFI_FAILED': 'otaStageOnlineWifiFailed',
      'ONLINE_GITHUB_CONNECT': 'otaStageOnlineGithubConnect',
      'ONLINE_GITHUB_CONNECTED': 'otaStageOnlineGithubConnected',
      'ONLINE_DOWNLOAD': 'otaStageOnlineDownload',
      'ONLINE_DOWNLOAD_COMPLETE': 'otaStageOnlineDownloadComplete',
      'ONLINE_IMAGE_VALIDATE': 'otaStageOnlineImageValidate',
      'ONLINE_FLASH_PREPARE': 'otaStageOnlineFlashPrepare',
      'ONLINE_FLASH_FINALIZE': 'otaStageOnlineFlashFinalize',
      'ONLINE_FLASH_SUCCESS': 'otaStageOnlineFlashSuccess',
    };
    final key = keyByStage[stage.trim().toUpperCase()] ?? 'unknownOtaStage';
    return JexText.of(key, appLanguageNotifier.value);
  }

  // AI-METHOD: _friendlyOtaResult — Translate one-shot OTA result events into Home NOTIFY text.
  String _friendlyOtaMode(String mode) {
    switch (mode.trim().toUpperCase()) {
      case 'LOCAL':
        return JexText.of('otaModeLocal', appLanguageNotifier.value);
      case 'ONLINE':
        return JexText.of('otaModeOnline', appLanguageNotifier.value);
      default:
        return 'OTA';
    }
  }

  // User-facing OTA summaries never expose raw ERROR/CODE values or event tokens.
  String _friendlyOtaResult(String value) {
    final raw = value.trim();
    if (raw.isEmpty || raw.toUpperCase() == 'NONE') return '';
    final upper = raw.toUpperCase();
    final language = appLanguageNotifier.value;

    if (upper.startsWith('OTA_FAILED|')) {
      final fields = _otaDiagnosticFields(raw);
      return localizedOtaFailureSummary(
        language,
        mode: _friendlyOtaMode(fields['MODE'] ?? 'OTA'),
        stage: _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN'),
      );
    }

    if (upper.startsWith('OTA_UP_TO_DATE|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = _friendlyOtaMode(fields['MODE'] ?? 'OTA');
      final version = fields['VERSION'] ?? '';
      final details = <String>[JexText.of('otaUpToDate', language)];
      if (mode.toUpperCase() != 'OTA') details.add(mode);
      if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}$').hasMatch(version)) {
        details.add(version);
      }
      return details.join(' • ');
    }

    if (upper.startsWith('OTA_SUCCESS|')) {
      final fields = _otaDiagnosticFields(raw);
      return localizedOtaSuccessSummary(
        language,
        mode: _friendlyOtaMode(fields['MODE'] ?? 'OTA'),
        version: fields['VERSION'] ?? '',
      );
    }

    if (upper.startsWith('IN_PROGRESS|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = _friendlyOtaMode(fields['MODE'] ?? 'OTA');
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final progress = int.tryParse(fields['PROGRESS'] ?? '')?.clamp(0, 100);
      final details = <String>[
        JexText.of('otaProgress', language).replaceAll(RegExp(r'\s*•\s*$'), ''),
      ];
      if (mode.toUpperCase() != 'OTA') details.add(mode);
      if (stage != JexText.of('unknownOtaStage', language)) details.add(stage);
      if (progress != null) details.add('$progress%');
      return details.join(' • ');
    }

    if (upper == 'IN_PROGRESS') return JexText.of('otaInProgress', language);
    if (upper == 'LOCAL_SUCCESS') {
      return localizedOtaSuccessSummary(
        language,
        mode: JexText.of('otaModeLocal', language),
      );
    }
    if (upper.startsWith('SUCCESS_')) {
      // The suffix is an internal event identifier, not user-facing copy.
      return localizedOtaSuccessSummary(language);
    }
    if (upper.startsWith('UPLOAD_SIZE_MISMATCH_')) {
      return formatOtaUploadSizeMismatch(raw, language) ??
          JexText.of('otaSizeMismatch', language);
    }
    if (upper.startsWith('OTA_END_ERROR_')) {
      // Detailed suffixes belong in internal diagnostics, not the Home status card.
      return localizedOtaFailureSummary(language);
    }
    if (upper.contains('FAILED') || upper.contains('ERROR')) {
      return localizedOtaFailureSummary(language);
    }
    return raw.contains('_') ? JexText.of('deviceStatusUpdate', language) : raw;
  }

  String _friendlyReset(String value) {
    switch (value) {
      case 'BROWNOUT':
        return JexText.of('resetBrownout', appLanguageNotifier.value);
      case 'PANIC':
        return JexText.of('resetPanic', appLanguageNotifier.value);
      case 'SOFTWARE':
        return JexText.of('resetSoftware', appLanguageNotifier.value);
      case 'WDT':
      case 'INT_WDT':
      case 'TASK_WDT':
        return JexText.of('resetWatchdog', appLanguageNotifier.value);
      case 'EXTERNAL':
        return JexText.of('resetExternal', appLanguageNotifier.value);
      case 'DEEPSLEEP':
        return JexText.of('resetDeepSleep', appLanguageNotifier.value);
      case 'POWER_ON':
      case 'POWERON':
        return JexText.of('resetPowerOn', appLanguageNotifier.value);
      default:
        return JexText.of('deviceStatusUpdate', appLanguageNotifier.value);
    }
  }

  String _friendlyReason(String reason) {
    return localizedNotifyReason(
      reason,
      hotLimit: hotLimit,
      language: appLanguageNotifier.value,
    );
  }

  void _showSnackBar(String message, {Color color = Colors.blueAccent}) {
    if (!mounted || message.trim().isEmpty) return;
    setState(() => notice = _compactNotifyMessage(message));
  }

  Future<void> _openBluetoothSettings() async {
    try {
      await batteryChannel.invokeMethod('openBluetoothSettings');
    } catch (e) {
      debugPrint('Bluetooth settings: $e');
      await openAppSettings();
    }
  }

  Future<void> _openLocationSettings() async {
    try {
      await batteryChannel.invokeMethod('openLocationSettings');
    } catch (e) {
      debugPrint('Location settings: $e');
      await openAppSettings();
    }
  }

  void _showBluetoothMenu() {
    if (!mounted ||
        syncing ||
        _bleConnecting ||
        _connectionScanCoordinator.isConnectionHandoffActive ||
        !_connectionScanCoordinator.openManualSheet()) {
      return;
    }
    _manualConnectionSheetPreparation = _prepareManualConnectionSheet();
    final media = MediaQuery.of(context);
    const designWidth = JexLayoutTokens.masterCanvasWidth;
    const homeHeight = JexLayoutTokens.homeCanvasHeight;
    final scale = media.size.width / designWidth;
    final top = media.padding.top + homeHeight * scale;
    final sheetHeight = (media.size.height - top)
        .clamp(1.0, media.size.height)
        .toDouble();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.70),
      isScrollControlled: true,
      useSafeArea: false,
      enableDrag: true,
      showDragHandle: false,
      builder: (_) {
        return SizedBox(
          width: media.size.width,
          height: sheetHeight,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
            child: JexFixedScalePage(
              compactUi: true,
              child: ConnectionSheetContent(
                onScan: _startScanFromSheet,
                onConnect: _connect,
                onDeviceSelected:
                    _connectionScanCoordinator.markManualDeviceSelected,
                onOpenBluetoothSettings: _openBluetoothSettings,
                onOpenLocationSettings: _openLocationSettings,
                serviceUuid: serviceUuid,
              ),
            ),
          ),
        );
      },
    ).whenComplete(_finishManualConnectionSheet);
  }

  Future<void> _prepareManualConnectionSheet() async {
    await _cancelDisconnectRediscovery();
    await _connectionScanCoordinator.runSerialized(() async {
      if (_connectionScanCoordinator.isManualSheetOpen) {
        await FlutterBluePlus.stopScan();
      }
    });
  }

  Future<void> _finishManualConnectionSheet() async {
    final selectedDevice = _connectionScanCoordinator.manualDeviceSelected;
    var scannerStopped = selectedDevice;
    if (!selectedDevice) {
      try {
        await _connectionScanCoordinator.runSerialized(
          () => FlutterBluePlus.stopScan(),
        );
        scannerStopped = true;
      } catch (e) {
        debugPrint('Connection sheet scan cleanup: $e');
      }
    }
    final resumePassiveReconnect = _connectionScanCoordinator
        .closeManualSheet();
    if (resumePassiveReconnect && scannerStopped && mounted) {
      _startDisconnectRediscovery();
    }
  }

  Future<bool> _startScanFromSheet() async {
    await _manualConnectionSheetPreparation;
    if (!_connectionScanCoordinator.isManualSheetOpen) return false;
    final accessReady = await _requestPermissions();
    if (!accessReady || !_connectionScanCoordinator.isManualSheetOpen) {
      return false;
    }
    try {
      await _connectionScanCoordinator.runSerialized(() async {
        if (!_connectionScanCoordinator.isManualSheetOpen) return;
        await FlutterBluePlus.stopScan();
        if (!_connectionScanCoordinator.isManualSheetOpen) return;
        await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 10),
          androidCheckLocationServices: false,
          androidUsesFineLocation: false,
        );
      });
      return _connectionScanCoordinator.isManualSheetOpen;
    } catch (e) {
      debugPrint('start scan sheet: $e');
      rethrow;
    }
  }

  String _compactNotifyMessage(String message) {
    final trimmed = message.trim();
    final upper = trimmed.toUpperCase();

    // OTA envelopes and legacy result tokens must pass through the dedicated
    // localized formatter before any general STATUS normalization.
    if (isTransientOtaResultEvent(trimmed) ||
        upper == 'IN_PROGRESS' ||
        upper == 'LOCAL_SUCCESS' ||
        upper.startsWith('IN_PROGRESS|') ||
        upper.startsWith('SUCCESS_') ||
        upper.startsWith('UPLOAD_SIZE_MISMATCH_') ||
        upper.startsWith('OTA_END_ERROR_')) {
      return _friendlyOtaResult(trimmed);
    }

    final storedOtaSummary = RegExp(
      r'^(?:Firmware update (?:completed|failed)|Pembaruan firmware (?:selesai|gagal))(?: *•.*)?$',
      caseSensitive: false,
    ).hasMatch(trimmed);
    if (storedOtaSummary) {
      return relocalizeHomeNotifyMessage(trimmed, appLanguageNotifier.value);
    }

    final normalized = normalizeHomeNotifyText(
      trimmed,
      hotLimit: hotLimit,
      language: appLanguageNotifier.value,
    );
    final raw = relocalizeHomeNotifyMessage(
      normalized,
      appLanguageNotifier.value,
    );
    if (raw.isEmpty) return '';

    final lower = raw.toLowerCase();
    if (lower == 'scanning for device...' ||
        lower == 'scanning for devices...' ||
        lower == 'scanning for je x fyz...') {
      return JexText.of('scanning');
    }
    if (lower == 'connecting to the device...' ||
        lower == 'connecting to device...' ||
        lower == 'connecting to je x fyz...') {
      return JexText.of('connectingDevice');
    }
    if (lower == 'device disconnected.') {
      return JexText.of('bluetoothDisconnected');
    }
    if (lower == 'device not found.' || lower == 'je x fyz was not found.') {
      return JexText.of('deviceNotFound');
    }
    if (lower == 'bluetooth scan failed.') {
      return JexText.of('scanFailed');
    }
    if (lower == 'bluetooth is not ready.') {
      return JexText.of('bluetoothNotReady');
    }
    if (lower == 'connect your device to continue.' ||
        lower == 'connect to je x fyz first.') {
      return JexText.of('connectFirst');
    }
    if (lower.startsWith('reset:')) {
      final reset = raw.substring(raw.indexOf(':') + 1).trim();
      return _friendlyReset(reset);
    }
    if (lower.startsWith('ota could not start:')) {
      return JexText.of('otaStartRejected');
    }
    if (lower.contains('was not confirmed by the device')) {
      final prefix = raw
          .replaceFirst(
            RegExp(
              r'\s+was not confirmed by the device\.?[\s\S]*$',
              caseSensitive: false,
            ),
            '',
          )
          .trim();
      return prefix.isEmpty
          ? JexText.of('commandNotConfirmed', appLanguageNotifier.value)
          : prefix +
                ' ' +
                JexText.of('notConfirmedSuffix', appLanguageNotifier.value);
    }
    if (lower.contains('command failed.')) {
      final prefix = raw
          .replaceFirst(
            RegExp(r'\s+command failed\.?$', caseSensitive: false),
            '',
          )
          .trim();
      return prefix.isEmpty
          ? JexText.of('commandFailed', appLanguageNotifier.value)
          : prefix +
                ' ' +
                JexText.of('failedSuffix', appLanguageNotifier.value);
    }
    return raw;
  }

  // AI-METHOD: _professionalNotice — Normalize technical status into project UI wording.
  String _professionalNotice() {
    final custom = _compactNotifyMessage(notice);

    if (!connected && !_bleConnecting) {
      final upper = custom.toUpperCase();
      final staleValidation =
          upper == 'VALIDATING TEMPERATURE...' ||
          upper == 'TEMPERATURE SENSORS: VALIDATING...' ||
          upper == 'VALIDATING TEMPERATURE SENSORS...';
      if (custom.isEmpty || staleValidation) {
        return JexText.of('bluetoothDisconnected', appLanguageNotifier.value);
      }
      return custom;
    }

    // Hotside threshold is the only live condition that overrides ordinary events.
    if (connected && homeHotsideLimitReached(hotsideTemp, hotLimit: hotLimit)) {
      return homeHotsideLimitNotice(
        hotsideTemp,
        hotLimit: hotLimit,
        language: appLanguageNotifier.value,
      );
    }
    if (connected &&
        (isActiveHomeSafetyReason(safetyReason) ||
            safetyReason.trim().toUpperCase() == 'WAITING_FOR_NTC' ||
            safetyReason.trim().toUpperCase() ==
                'WAITING_FOR_SENSOR_VALIDATION')) {
      return _friendlyReason(safetyReason);
    }

    if (custom.isNotEmpty) return custom;

    if (_bleConnecting)
      return JexText.of('connectingDevice', appLanguageNotifier.value);
    if (syncing && !dashboardReady)
      return JexText.of('synchronizingDevice', appLanguageNotifier.value);

    return _friendlyReason(safetyReason);
  }

  void _notifyCommandAccepted(
    String command, {
    required int expectedRevision,
    required int previousFanSpeed,
  }) {
    if (!mounted || _homeNotifyRevision != expectedRevision) return;
    final c = command.trim().toUpperCase();
    final lang = appLanguageNotifier.value;
    String? message;

    if (c.startsWith('VOLTAGE:')) {
      message =
          JexText.phrase('Voltage set to ', 'Tegangan diatur ke ', lang) +
          c.substring(8) +
          '.';
    } else if (c == 'FAN:ON') {
      message = JexText.of('fanOn', lang);
    } else if (c == 'FAN:OFF') {
      message = JexText.of('fanOff', lang);
    } else if (c == 'PELTIER:ON') {
      message = JexText.of('peltierOn', lang);
    } else if (c == 'PELTIER:OFF') {
      message = JexText.of('peltierOff', lang);
    } else if (c == 'ADAPTIVE:ON') {
      message = JexText.of('adaptiveOn', lang);
    } else if (c == 'ADAPTIVE:OFF') {
      message = JexText.of('adaptiveOff', lang);
    } else if (c.startsWith('FANSPEED:')) {
      final requested = int.tryParse(c.substring(9));
      message = requested == null
          ? JexText.phrase(
              'Fan speed updated.',
              'Kecepatan kipas diperbarui.',
              lang,
            )
          : homeFanSpeedChangedNotice(
              previousFanSpeed,
              requested,
              language: lang,
            );
    } else if (c == 'RGB:ON') {
      message = JexText.of('ledOn', lang);
    } else if (c == 'RGB:OFF') {
      message = JexText.of('ledOff', lang);
    } else if (c.startsWith('MODE:')) {
      message = JexText.of('modeUpdated', lang);
    } else if (c.startsWith('BRIGHTNESS:')) {
      message =
          JexText.phrase(
            'LED brightness set to ',
            'Kecerahan LED diatur ke ',
            lang,
          ) +
          c.substring(11) +
          '%.';
    } else if (c.startsWith('COLOR:')) {
      message = JexText.of('colorUpdated', lang);
    } else if (c.startsWith('ADAPTIVE_PROFILE:')) {
      message = homeNotifyForTelemetryChange(
        key: 'ADAPTIVE_PROFILE',
        previousValue: '',
        currentValue: c.substring(17),
        language: lang,
      );
    } else if (c.startsWith('ADAPTIVE_CEILING:')) {
      message = homeNotifyForTelemetryChange(
        key: 'ADAPTIVE_CEILING',
        previousValue: '',
        currentValue: c.substring(17),
        language: lang,
      );
    } else if (c.startsWith('HOTLIMIT:')) {
      // Keep the existing Temperature-tab limit acknowledgement; do not notify on samples.
      message =
          JexText.phrase(
            'Hotside temperature limit set to ',
            'Batas suhu sisi panas diatur ke ',
            lang,
          ) +
          JexText.formatNumber(int.parse(c.substring(9)), lang) +
          ' °C.';
    } else if (c.startsWith('BATT5:')) {
      message = JexText.phrase(
        '5V battery limit updated.',
        'Batas baterai 5V diperbarui.',
        lang,
      );
    } else if (c.startsWith('BATT12:')) {
      message = JexText.phrase(
        '12V battery limit updated.',
        'Batas baterai 12V diperbarui.',
        lang,
      );
    } else if (c == 'RESET:TEMPERATURE') {
      message = JexText.of('temperatureReset', lang);
    }
    if (message != null) {
      setState(() {
        notice = message!;
        _homeNotifyRevision++;
      });
    }
  }

  String _notifyStateLabel() =>
      JexText.of('notification', appLanguageNotifier.value);

  // AI-METHOD: _homeNotify — Render the localized Home Notification card.
  // Retain the original icon-left / text-left Row; only the connection badge is removed.
  // Keep the 44-dp card geometry; long copy uses two-line ellipsis at readable text sizes.
  // AI-METHOD: _homeNotify — Resolve Dashboard-owned status and pass a value-only view model.
  // Physical/safety facts stay here; HomeNotifyCard is presentation-only.
  Widget _homeNotify() {
    final headerDark = jexHomeHeaderUsesDarkPalette(appThemeNotifier.value);
    final custom = notice.trim().toUpperCase();
    // A stale command error must not make an offline device look like an active fault.
    final hasError = connected && isNotifyErrorMessage(custom);
    final warning =
        connected &&
        ((safetyReason != 'NONE' &&
                safetyReason != 'WAITING_FOR_NTC' &&
                safetyReason != 'WAITING_FOR_SENSOR_VALIDATION') ||
            homeHotsideLimitReached(hotsideTemp, hotLimit: hotLimit));
    final foregroundColor = jexHomeNotifyForegroundColor(
      darkTheme: headerDark,
      hasError: hasError,
      warning: warning,
      connected: connected,
    );

    return HomeNotifyCard(
      darkTheme: headerDark,
      hasError: hasError,
      warning: warning,
      connected: connected,
      foregroundColor: foregroundColor,
      label: _notifyStateLabel(),
      message: _professionalNotice(),
    );
  }

  void _updateDashboardPresentation(VoidCallback update) => setState(update);

  // AI-METHOD: _buildTabContent — Select submenu content by tab index.
  Widget _buildTabContent() {
    final content = switch (tabIndex) {
      0 => _buildVoltageTab(key: const ValueKey('voltage-tab')),
      1 => _buildControlTab(key: const ValueKey('control-tab')),
      2 => _buildAdaptiveTab(key: const ValueKey('adaptive-tab')),
      3 => _buildLedTab(key: const ValueKey('led-tab')),
      4 => this._buildTemperatureTab(key: const ValueKey('temperature-tab')),
      _ => const SizedBox.shrink(),
    };
    final lockReason = displayMenuLockReason(
      connected: connected,
      adaptiveActive: adaptiveOn,
      adaptiveTransitioning: adaptiveTransitioning,
      tabIndex: tabIndex,
      voltageLockKnown: voltageLockKnown,
      voltageLockActive: voltageLockActive,
    );
    final tabContent = lockReason == DisplayMenuLockReason.none
        ? content
        : _lockedDisplayMenu(content, lockReason);
    return JexDashboardTabTransition(tabId: tabIndex, child: tabContent);
  }

  /// Blurs the complete submenu, then centers one lock panel above all of its content.
  /// Navigation tabs and the Bluetooth Home control live outside this Stack and remain usable.
  Widget _lockedDisplayMenu(Widget content, DisplayMenuLockReason reason) {
    final disconnected = reason == DisplayMenuLockReason.bluetoothDisconnected;
    final adaptiveLocked = reason == DisplayMenuLockReason.adaptiveActive;
    final voltageConfirmedAtFive = voltage == '5V';
    final scheme = Theme.of(context).colorScheme;
    final title = disconnected
        ? JexText.phrase(
            'CONNECT YOUR DEVICE FIRST',
            'HUBUNGKAN PERANGKAT TERLEBIH DAHULU',
          )
        : adaptiveLocked
        ? JexText.phrase(
            'LOCKED BY ADAPTIVE MODE',
            'TERKUNCI OLEH MODE ADAPTIF',
          )
        : tabIndex == 0
        ? (voltageConfirmedAtFive
              ? JexText.phrase(
                  'VOLTAGE LOCKED AT 5V',
                  'TEGANGAN TERKUNCI DI 5V',
                )
              : JexText.phrase('RETURNING TO 5V', 'SEDANG KEMBALI KE 5V'))
        : JexText.phrase(
            'ADAPTIVE MODE DISABLED',
            'MODE ADAPTIF DINONAKTIFKAN',
          );
    final detail = disconnected
        ? JexText.phrase(
            'Connect your device to use this menu.',
            'Hubungkan perangkat untuk menggunakan menu ini.',
          )
        : adaptiveLocked
        ? JexText.phrase(
            'Turn Adaptive Mode off to edit these settings.',
            'Matikan Mode Adaptif untuk mengubah pengaturan ini.',
          )
        : tabIndex == 0
        ? (voltageConfirmedAtFive
              ? JexText.phrase(
                  'The device confirms the 5V rail. Higher voltage selections are locked.',
                  'Perangkat mengonfirmasi tegangan 5V. Pilihan tegangan yang lebih tinggi dikunci.',
                )
              : JexText.phrase(
                  voltage == '--'
                      ? 'Waiting for confirmed 5V telemetry. The voltage lock remains active.'
                      : 'The voltage lock is active. The device is safely returning from $voltage to 5V.',
                  voltage == '--'
                      ? 'Menunggu telemetri 5V yang terkonfirmasi. Kunci tegangan tetap aktif.'
                      : 'Kunci tegangan aktif. Perangkat sedang kembali dengan aman dari $voltage ke 5V.',
                ))
        : JexText.phrase(
            'Adaptive Mode is forced OFF while Lock Voltage is active.',
            'Mode Adaptif dipaksa MATI selama Kunci Tegangan aktif.',
          );
    final accent = disconnected
        ? const Color(0xFF4D8CFF)
        : adaptiveLocked
        ? const Color(0xFFC05BFF)
        : const Color(0xFFD69A38);
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4.8, sigmaY: 4.8),
            child: IgnorePointer(child: content),
          ),
          Positioned.fill(
            child: ColoredBox(color: scheme.jexSurface.withValues(alpha: .46)),
          ),
          Positioned.fill(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 270),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                  decoration: BoxDecoration(
                    color: scheme.jexSurface.withValues(alpha: .96),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: scheme.jexOutline.withValues(alpha: .92),
                      width: 1.1,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .12),
                        blurRadius: 20,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIconsBold.lock, size: 38, color: accent),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.jexForeground,
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .25,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        detail,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.jexMutedForeground,
                          fontSize: 11.5,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (disconnected) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            // Reuse the established Bluetooth sheet and its serialized scan owner.
                            onPressed: _showBluetoothMenu,
                            icon: const Icon(
                              PhosphorIconsRegular.bluetooth,
                              size: 18,
                            ),
                            label: Text(JexText.phrase('Connect', 'Hubungkan')),
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              foregroundColor: accent,
                              backgroundColor: accent.withValues(alpha: .10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    final selected = tabIndex == index;
    final dark = _dashboardDark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => tabIndex = index),
          child: SizedBox.expand(
            child: Center(
              child: Container(
                width: double.infinity,
                height: JexLayoutTokens.homeTabPillHeight,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF17181C)
                      : (dark
                            ? const Color(0xFF22242A)
                            : const Color(0xFFE4E7EC)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF17181C)
                        : (dark
                              ? const Color(0xFF30323A)
                              : const Color(0xFFD6DAE1)),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : (dark ? Colors.white70 : const Color(0xFF16181D)),
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                      letterSpacing: 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _dashboardTopColor() => switch (appThemeNotifier.value) {
    AppThemePreset.defaultTheme => const Color(0xFF111113),
    AppThemePreset.light => const Color(0xFFEEF0F4),
    AppThemePreset.dark => const Color(0xFF101114),
  };

  bool get _dashboardDark =>
      jexDashboardContentUsesDarkPalette(appThemeNotifier.value);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    const designWidth = JexLayoutTokens.masterCanvasWidth;
    const homeHeight = JexLayoutTokens.homeCanvasHeight;
    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        backgroundColor: _dashboardTopColor(),
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // One master visual canvas. Its 360 dp design width is scaled once
              // to fill the current viewport. When Android Smallest Width/density
              // changes on the same physical display, logical width changes in the
              // opposite direction, so the rendered physical UI size stays stable.
              // A genuinely different physical display receives the same single
              // uniform scale across Home, Notify and Display Menu.
              final scale = constraints.maxWidth / designWidth;
              final designHeight = constraints.maxHeight / scale;

              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: designWidth,
                      height: designHeight,
                      child: Column(
                        children: [
                          SizedBox(
                            width: designWidth,
                            height: homeHeight,
                            child: _buildHomeArea(homeHeight),
                          ),
                          Expanded(
                            child: Container(
                              width: designWidth,
                              decoration: BoxDecoration(
                                color:
                                    appThemeNotifier.value ==
                                        AppThemePreset.dark
                                    ? const Color(0xFF171A20)
                                    : Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(34),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 11),
                                  SizedBox(
                                    height: 48,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          _tab(
                                            JexText.of(
                                              'voltage',
                                              appLanguageNotifier.value,
                                            ),
                                            0,
                                          ),
                                          _tab(
                                            JexText.of(
                                              'control',
                                              appLanguageNotifier.value,
                                            ),
                                            1,
                                          ),
                                          _tab(
                                            JexText.of(
                                              'adaptive',
                                              appLanguageNotifier.value,
                                            ),
                                            2,
                                          ),
                                          _tab(
                                            JexText.of(
                                              'led',
                                              appLanguageNotifier.value,
                                            ),
                                            3,
                                          ),
                                          _tab(
                                            JexText.of(
                                              'temperature',
                                              appLanguageNotifier.value,
                                            ),
                                            4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: _buildTabContent(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// --- CONNECTION SHEET: UI only; BLE ownership remains in DashboardScreen ---
class StaticSwitcher extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? switchInCurve;
  final Curve? switchOutCurve;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;
  final Widget Function(Widget?, List<Widget>)? layoutBuilder;

  const StaticSwitcher({
    super.key,
    required this.child,
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
  });

  @override
  Widget build(BuildContext context) => child;
}

class StaticScale extends StatelessWidget {
  final double scale;
  final Widget child;
  final Duration? duration;
  final Curve? curve;

  const StaticScale({
    super.key,
    required this.scale,
    required this.child,
    this.duration,
    this.curve,
  });

  @override
  Widget build(BuildContext context) => child;
}

// --- OTA UI: external firmware metadata/credentials; firmware performs flashing ---
class FirmwareUpdateDialog extends StatefulWidget {
  final String currentVersion;
  final Future<void> Function(
    String ssid,
    String password,
    String url,
    String version,
  )
  onUpdate;

  const FirmwareUpdateDialog({
    super.key,
    required this.currentVersion,
    required this.onUpdate,
  });

  @override
  State<FirmwareUpdateDialog> createState() => _FirmwareUpdateDialogState();
}

class _FirmwareUpdateDialogState extends State<FirmwareUpdateDialog> {
  String latestVersion = '';
  String firmwareUrl = '';
  String status = 'CHECKING';
  bool updateAvailable = false;
  bool passwordVisible = false;

  final ssid = TextEditingController();
  final password = TextEditingController();
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // AI-METHOD: _loadSavedCredentials — Load Wi-Fi credentials from secure storage only.
    _loadSavedCredentials();
    // AI-METHOD: _checkFirebase — Fetch and validate Firebase firmware release metadata.
    _checkFirebase();
  }

  @override
  void dispose() {
    ssid.dispose();
    password.dispose();
    super.dispose();
  }

  // AI-METHOD: _loadSavedCredentials — Load Wi-Fi credentials from secure storage only.
  Future<void> _loadSavedCredentials() async {
    try {
      final savedSsid = await storage.read(key: 'jexfyz_wifi_ssid') ?? '';
      final savedPass = await storage.read(key: 'jexfyz_wifi_pass') ?? '';
      if (mounted) {
        setState(() {
          ssid.text = savedSsid;
          password.text = savedPass;
        });
      }
    } catch (e) {
      debugPrint('secure storage: $e');
    }
  }

  // AI-METHOD: _checkFirebase — Read Firebase RTDB firmware metadata with optional App Check REST authorization.
  Future<void> _checkFirebase() async {
    if (!mounted) return;
    setState(() {
      status = 'CHECKING';
      latestVersion = '';
      firmwareUrl = '';
      updateAvailable = false;
    });

    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(Uri.parse(firmwareMetadataUrl));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.userAgentHeader, 'JE-Cooler');
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
      request.headers.set('Pragma', 'no-cache');

      // Firmware metadata is intentionally public-read data (version + public BIN URL).
      // Keep this REST request independent from Play Integrity/App Check so the
      // sideloaded production APK can read the update metadata reliably.
      // App Check remains enabled for the rest of the application's Firebase layer.
      final response = await request.close().timeout(
        const Duration(seconds: 12),
      );
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != HttpStatus.ok) {
        final detail = body.trim();
        final reason =
            response.statusCode == HttpStatus.unauthorized ||
                response.statusCode == HttpStatus.forbidden
            ? 'Firebase read permission/App Check rejected'
            : 'Firebase HTTP ' + response.statusCode.toString();
        throw StateError(reason + (detail.isEmpty ? '' : ': ' + detail));
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map) {
        throw StateError('Firebase firmware_update is not an object');
      }

      final data = Map<String, dynamic>.from(decoded);
      final version = data['version']?.toString().trim() ?? '';
      final url = data['url']?.toString().trim() ?? '';
      final parsedUrl = Uri.tryParse(url);
      final validUrl =
          parsedUrl != null &&
          parsedUrl.scheme == 'https' &&
          parsedUrl.host == 'raw.githubusercontent.com' &&
          parsedUrl.path == '/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin';

      if (parseFirmwareVersion(version) == null || !validUrl) {
        throw StateError(
          'Firebase firmware_update data invalid: expected version V<major>.<minor> and the fixed JEXFYZ.cpp.bin URL',
        );
      }

      if (!mounted) return;
      setState(() {
        latestVersion = version;
        firmwareUrl = url;
        updateAvailable = isDifferentFirmwareVersion(
          version,
          widget.currentVersion,
        );
        status = updateAvailable ? 'UPDATE' : 'UP_TO_DATE';
      });

      if (updateAvailable && appNotifyFirmwareNotifier.value) {
        final shouldNotify = await AppSettingsStore.shouldNotifyFirmware(
          version,
        );
        if (shouldNotify) {
          try {
            final notificationShown =
                await const MethodChannel('je_x_fyz/notifications')
                    .invokeMethod<bool>('showNotification', <String, dynamic>{
                      'title': JexText.of(
                        'firmwareUpdate',
                        appLanguageNotifier.value,
                      ),
                      'body': JexText.of(
                        'firmwareUpdateAvailableBody',
                        appLanguageNotifier.value,
                      ).replaceAll('{version}', version),
                      'id': 2104,
                      'language': appLanguageNotifier.value.name,
                    });
            if (notificationShown == true) {
              await AppSettingsStore.markFirmwareNotified(version);
            }
          } catch (e) {
            debugPrint('Firmware notification: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Firebase OTA metadata: ' + e.toString());
      if (mounted) {
        setState(() {
          status = 'FAILED';
          latestVersion = '';
          firmwareUrl = '';
          updateAvailable = false;
        });
      }
    } finally {
      client.close(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        JexText.of('firmware', appLanguageNotifier.value),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JexText.of('currentVersion', appLanguageNotifier.value) +
                  ': ' +
                  widget.currentVersion,
            ),
            const SizedBox(height: 5),
            Text(
              JexText.of('latestVersion', appLanguageNotifier.value) +
                  ': ' +
                  (latestVersion.isEmpty ? '--' : latestVersion),
            ),
            const SizedBox(height: 16),
            if (status == 'CHECKING')
              const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
            else if (status == 'FAILED')
              Text(
                JexText.of(
                  'firmwareMetadataCheckFailed',
                  appLanguageNotifier.value,
                ),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (!updateAvailable)
              Text(
                widget.currentVersion == 'V?'
                    ? JexText.of('waitingForDevice', appLanguageNotifier.value)
                    : JexText.of('upToDateSentence', appLanguageNotifier.value),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            else ...[
              Text(
                JexText.of(
                  'updateAvailableSentence',
                  appLanguageNotifier.value,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ssid,
                decoration: InputDecoration(
                  labelText: JexText.of('ssid', appLanguageNotifier.value),
                  prefixIcon: JexAnimatedGlyph(
                    icon: PhosphorIconsRegular.wifiHigh,
                    color: Theme.of(context).colorScheme.jexMutedForeground,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: password,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: JexText.of('password', appLanguageNotifier.value),
                  prefixIcon: JexAnimatedGlyph(
                    icon: PhosphorIconsBold.lock,
                    color: Theme.of(context).colorScheme.jexMutedForeground,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    tooltip: JexText.of(
                      passwordVisible ? 'hidePassword' : 'showPassword',
                      appLanguageNotifier.value,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    icon: Icon(
                      passwordVisible
                          ? PhosphorIconsRegular.eyeSlash
                          : PhosphorIconsRegular.eye,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                JexText.of('savedSecurelySentence', appLanguageNotifier.value),
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(JexText.of('close', appLanguageNotifier.value)),
        ),
        if (status == 'FAILED')
          FilledButton(
            onPressed: _checkFirebase,
            child: Text(JexText.of('retry', appLanguageNotifier.value)),
          ),
        if (updateAvailable)
          FilledButton(
            onPressed: () async {
              final s = ssid.text.trim();
              final p = password.text;
              if (s.isEmpty || p.isEmpty) return;
              await storage.write(key: 'jexfyz_wifi_ssid', value: s);
              await storage.write(key: 'jexfyz_wifi_pass', value: p);
              if (!context.mounted) return;
              Navigator.pop(context);
              await widget.onUpdate(s, p, firmwareUrl, latestVersion);
            },
            child: Text(JexText.of('updateAction', appLanguageNotifier.value)),
          ),
      ],
    );
  }
}
