/*
  JE X FYZ / JE COOLER
  Horizon Cooler UI base + JE X FYZ / P1 protocol

  Core rules:
  - Horizon Cooler remains the visual/layout and Android foundation.
  - JE X FYZ uses firmware-owned state and an atomic P1 BLE sync/ready handshake.
  - Firebase App Check / Play Integrity remains enabled for app security. Firmware release metadata comes from the public GitHub manifest.
  - Phone battery temperature is sent every 1 second while BLE is connected.
  - Manual voltage commands use a 1-second app guard matching firmware.
  - Adaptive ON/OFF always relies on firmware to return the selector to 5V.
  - BLE connection never replays local runtime state into the device.
  - UI never pretends a command succeeded until device telemetry confirms it.
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_icons/phosphor_icons.dart';


// Premium icon system: Phosphor Icons (Regular/Bold).
// Material Icons are intentionally not used by JE X FYZ UI controls.
const String appName = 'JE Cooler';
const String headerName = 'JE X FYZ';
const String serviceUuid = '6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001';
const String rxUuid = '6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001';
const String txUuid = '6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001';
const String firmwareManifestUrl =
    'https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/manifest.json';
const Duration voltageGuardDuration = Duration(seconds: 1);
const int fanSpeedMin = 50;
const int fanSpeedMax = 100;

const MethodChannel securityChannel = MethodChannel('je_x_fyz/security');

Future<bool> _isOfficialBuild() async {
  if (!Platform.isAndroid) return true;
  try {
    final result = await securityChannel.invokeMethod<bool>('isOfficialBuild');
    return result == true;
  } catch (e) {
    debugPrint('Security check: $e');
    return false;
  }
}

bool isVoltageCommand(String value) {
  final v = value.trim().toUpperCase();
  return v == '5V' || v == '9V' || v == '12V';
}

List<int>? parseFirmwareVersion(String version) {
  final match = RegExp(r'^V(\d+)(?:\.(\d+))?$')
      .firstMatch(version.trim().toUpperCase());
  if (match == null) return null;
  final major = int.tryParse(match.group(1)!);
  final minor = int.tryParse(match.group(2) ?? '0');
  if (major == null || minor == null) return null;
  return <int>[major, minor];
}

bool isNewerFirmwareVersion(String latest, String current) {
  final a = parseFirmwareVersion(latest);
  final b = parseFirmwareVersion(current);
  if (a == null || b == null) return false;
  if (a[0] != b[0]) return a[0] > b[0];
  return a[1] > b[1];
}

bool isValidHexColor(String value) {
  return RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value.trim());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final officialBuild = await _isOfficialBuild();
  if (!officialBuild) {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
    runApp(const TamperApp());
    return;
  }

  try {
    await Firebase.initializeApp();
    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: const AndroidPlayIntegrityProvider(),
      );
    } catch (e) {
      // App Check can be rolled out from monitoring to enforcement in Firebase
      // without breaking the official UI when the backend is not yet enforced.
      debugPrint('Firebase App Check init: $e');
    }
  } catch (e) {
    debugPrint('Firebase init: $e');
  }

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  runApp(const JeCoolerApp());
}

class TamperApp extends StatelessWidget {
  const TamperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF111113),
        fontFamily: 'Roboto',
      ),
      home: const TamperScreen(),
    );
  }
}

class TamperScreen extends StatelessWidget {
  const TamperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111113),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0x18FF453A),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0x40FF453A)),
                  ),
                  child: const Icon(
                    PhosphorIconsBold.warning,
                    color: Colors.redAccent,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  headerName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'OFFICIAL BUILD\nINTEGRITY CHECK FAILED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 25,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This application cannot continue because its integrity check failed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () => SystemNavigator.pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2B31),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'EXIT',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JeCoolerApp extends StatelessWidget {
  const JeCoolerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF111113),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

/// Backwards-compatible alias for simple widget tests.
typedef MyApp = JeCoolerApp;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const MethodChannel batteryChannel =
      MethodChannel('je_x_fyz/battery_temp');

  BluetoothDevice? device;
  BluetoothCharacteristic? rx;
  BluetoothCharacteristic? tx;
  StreamSubscription<BluetoothConnectionState>? connectionSub;
  StreamSubscription<List<int>>? notificationSub;

  Future<void> _writeQueue = Future<void>.value();
  Timer? batteryTimer;
  Timer? voltageGuardTimer;
  Timer? reconnectTimer;
  Timer? runtimeSyncTimer;

  bool _bleReady = false;
  bool _bleSessionReady = false;
  bool _syncReadyAck = false;
  bool connected = false;
  bool syncing = false;
  bool fullSyncReceived = false;
  bool voltageGuardActive = false;
  bool adaptiveTransitioning = false;
  bool batteryReadBusy = false;
  bool dashboardReady = false;
  bool _bleConnecting = false;
  final Map<String, List<Completer<String>>> _ackWaiters = {};
  final Map<String, String> _syncSnapshot = {};
  final Map<String, String> _pendingTelemetry = {};

  int brightnessDraft = 100;
  int fanSpeedDraft = 100;
  int hotLimitDraft = 45;
  int battery5Draft = 25;
  int battery12Draft = 35;
  String incomingBuffer = '';
  String notice = '';

  String voltage = '--';
  String hotsideTemp = '--';
  String phoneBatteryTemp = '--';
  bool phoneBatteryValid = false;
  bool fanOn = false;
  bool peltierOn = false;
  bool adaptiveOn = false;
  String adaptiveCeiling = '12V';
  bool rgbOn = false;
  int rgbMode = 1;
  int brightness = 100;
  String rgbColor = '#FFFFFF';
  String color5V = '#FF0000';
  String color9V = '#00FF00';
  String color12V = '#0000FF';
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
  String lastOtaResult = 'NONE';
  int stateSequence = 0;

  int tabIndex = 0;

  final TextEditingController rgbColorController =
      TextEditingController(text: '#FFFFFF');
  final TextEditingController color5Controller =
      TextEditingController(text: '#FF0000');
  final TextEditingController color9Controller =
      TextEditingController(text: '#00FF00');
  final TextEditingController color12Controller =
      TextEditingController(text: '#0000FF');

  @override
  void initState() {
    super.initState();
    try {
      FlutterBluePlus.setOperationQueueMode(OperationQueueMode.perDevice);
    } catch (e) {
      debugPrint('BLE operation queue: $e');
    }
  }

  @override
  void dispose() {
    connectionSub?.cancel();
    notificationSub?.cancel();
    batteryTimer?.cancel();
    voltageGuardTimer?.cancel();
    reconnectTimer?.cancel();
    runtimeSyncTimer?.cancel();
    device?.disconnect();
    rgbColorController.dispose();
    color5Controller.dispose();
    color9Controller.dispose();
    color12Controller.dispose();
    for (final waiters in _ackWaiters.values) {
      for (final waiter in waiters) {
        if (!waiter.isCompleted) waiter.complete('CANCELLED');
      }
    }
    _ackWaiters.clear();
    super.dispose();
  }

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
        locationService = await batteryChannel.invokeMethod<bool>(
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
      final locationReady =
          sdk > 30 || (location.isGranted && locationService);
      final ready = bluetoothReady && locationReady;

      if (showResult && mounted) {
        _showSnackBar(
          ready ? 'Connection ready.' : 'Connection needs access.',
          color: ready ? Colors.green : Colors.orangeAccent,
        );
      }
      return ready;
    } catch (e) {
      debugPrint('Permission setup: $e');
      return false;
    }
  }

  Future<void> _setBackgroundService(bool enabled) async {
    if (!Platform.isAndroid) return;
    try {
      await batteryChannel.invokeMethod<void>(
        enabled ? 'startBackgroundService' : 'stopBackgroundService',
      );
    } catch (e) {
      debugPrint('Background service ' +
          (enabled ? 'start' : 'stop') +
          ': $e');
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

  Future<void> _scanAndConnect() async {
    if (syncing) return;
    final accessReady = await _requestPermissions();
    if (!accessReady) {
      if (mounted) setState(() => notice = 'Connection access required.');
      return;
    }
    if (!mounted) return;

    setState(() {
      syncing = true;
      notice = 'Scanning...';
    });

    StreamSubscription<List<ScanResult>>? scanSub;
    BluetoothDevice? found;

    try {
      await FlutterBluePlus.stopScan();
      final completer = Completer<BluetoothDevice?>();

      scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final serviceMatch = result.advertisementData.serviceUuids.any(
            (uuid) => uuid.toString().toLowerCase() == serviceUuid,
          );
          final name = result.advertisementData.advName.trim().toLowerCase();
          final platformName = result.device.platformName.trim().toLowerCase();
          if (serviceMatch || name == 'je x fyz' || platformName == 'je x fyz') {
            if (!completer.isCompleted) completer.complete(result.device);
            break;
          }
        }
      });

      await FlutterBluePlus.startScan(
        withServices: <Guid>[Guid(serviceUuid)],
        timeout: const Duration(seconds: 10),
        androidCheckLocationServices: false,
        androidUsesFineLocation: false,
      );
      found = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
      await FlutterBluePlus.stopScan();

      // Some ESP32-C3 advertising stacks omit the 128-bit service UUID from
      // the first scan packet. Fall back to a name-based scan instead of
      // declaring the device unavailable.
      if (found == null) {
        final fallback = Completer<BluetoothDevice?>();
        await scanSub.cancel();
        scanSub = FlutterBluePlus.scanResults.listen((results) {
          for (final result in results) {
            final name = result.advertisementData.advName.trim().toLowerCase();
            final platformName = result.device.platformName.trim().toLowerCase();
            if (name == 'je x fyz' || platformName == 'je x fyz') {
              if (!fallback.isCompleted) fallback.complete(result.device);
              break;
            }
          }
        });
        await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 6),
          androidCheckLocationServices: false,
          androidUsesFineLocation: false,
        );
        found = await fallback.future.timeout(
          const Duration(seconds: 6),
          onTimeout: () => null,
        );
        await FlutterBluePlus.stopScan();
      }

      if (found == null) {
        _showSnackBar('JE X FYZ was not found.', color: Colors.orangeAccent);
        return;
      }

      await _connect(found);
    } catch (e) {
      debugPrint('BLE scan: $e');
      _showSnackBar('Scan failed.', color: Colors.redAccent);
    } finally {
      await scanSub?.cancel();
      if (mounted && !connected) {
        setState(() => syncing = false);
      }
    }
  }

  Future<void> _connect(BluetoothDevice target) async {
    await FlutterBluePlus.stopScan();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await connectionSub?.cancel();
    await notificationSub?.cancel();
    batteryTimer?.cancel();
    voltageGuardTimer?.cancel();

    // Never let a previous failed/stalled GATT write block the next session.
    _writeQueue = Future<void>.value();

    try {
      if (device != null && device!.remoteId != target.remoteId) {
        await device!.disconnect();
      }
    } catch (_) {}
    device = target;
    _bleConnecting = true;
    rx = null;
    tx = null;
    _bleReady = false;
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    incomingBuffer = '';
    _syncSnapshot.clear();
    _pendingTelemetry.clear();

    if (mounted) {
      setState(() {
        syncing = true;
        connected = false;
        dashboardReady = false;
        voltage = '--';
        hotsideTemp = '--';
        phoneBatteryTemp = '--';
        phoneBatteryValid = false;
        fanOn = false;
        peltierOn = false;
        adaptiveOn = false;
        rgbOn = false;
        safety = 'LOCKED';
        safetyReason = 'WAITING_FOR_SENSOR_VALIDATION';
        firmwareVersion = 'V?';
        resetReason = 'UNKNOWN';
        notice = 'Connecting to device...';
      });
    }

    connectionSub = target.connectionState.listen((state) {
      if (state != BluetoothConnectionState.disconnected) return;
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

        await _discoverServices(target);
        lastError = null;
        break;
      } catch (e) {
        lastError = e;
        debugPrint('BLE connect/discovery attempt ${attempt + 1}: $e');
        await notificationSub?.cancel();
        notificationSub = null;
        _bleReady = false;
        _bleSessionReady = false;
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

  void _handleBleDisconnected() {
    unawaited(_setBackgroundService(false));
    notificationSub?.cancel();
    notificationSub = null;
    _bleReady = false;
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    dashboardReady = false;
    _pendingTelemetry.clear();
    batteryTimer?.cancel();
    runtimeSyncTimer?.cancel();
    for (final waiters in _ackWaiters.values) {
      for (final waiter in waiters) {
        if (!waiter.isCompleted) waiter.complete('DISCONNECTED');
      }
    }
    _ackWaiters.clear();
    if (_bleConnecting) return;
    if (!mounted) return;
    setState(() {
      connected = false;
      syncing = false;
      dashboardReady = false;
      voltage = '--';
      hotsideTemp = '--';
      phoneBatteryTemp = '--';
      phoneBatteryValid = false;
      safety = 'LOCKED';
      safetyReason = 'DISCONNECTED';
      firmwareVersion = 'V?';
      resetReason = 'UNKNOWN';
      notice = 'Bluetooth disconnected.';
    });
  }

  Future<void> _discoverServices(BluetoothDevice target) async {
    BluetoothCharacteristic? discoveredRx;
    BluetoothCharacteristic? discoveredTx;

    for (var discoveryAttempt = 0; discoveryAttempt < 2; discoveryAttempt++) {
      final services = await target.discoverServices().timeout(const Duration(seconds: 8));
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
      throw StateError('JE X FYZ BLE service discovery failed');
    }

    rx = discoveredRx;
    tx = discoveredTx;

    // Register the listener BEFORE enabling notifications. Also register the
    // subscription with FlutterBluePlus so it is cancelled automatically with
    // the device connection.
    await notificationSub?.cancel();
    notificationSub = discoveredTx.lastValueStream.listen((bytes) {
      if (bytes.isNotEmpty) {
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
    for (var attempt = 0; attempt < 5 && !fullSyncReceived && mounted; attempt++) {
      await sendCommand('SYNC', showError: false);
      final deadline = DateTime.now().add(const Duration(milliseconds: 1500));
      while (mounted && !fullSyncReceived && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
    }

    if (!fullSyncReceived) {
      // If the first GATT session did not deliver notifications, re-subscribe
      // once before failing. The service cache was already validated above.
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await discoveredTx.setNotifyValue(false);
      await discoveredTx.setNotifyValue(true);

      for (var attempt = 0; attempt < 3 && !fullSyncReceived && mounted; attempt++) {
        await sendCommand('SYNC', showError: false);
        final deadline = DateTime.now().add(const Duration(milliseconds: 1000));
        while (mounted && !fullSyncReceived && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 35));
        }
      }
    }

    if (!fullSyncReceived) {
      throw StateError('BLE sync failed');
    }

    // Phase 2: open the firmware command gate. No runtime state is written by
    // the App before the firmware confirms this handshake.
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    final readyAccepted = await sendCommand('SYNC_READY', showError: false);
    if (!readyAccepted) {
      throw StateError('BLE session handshake write failed');
    }

    final readyDeadline = DateTime.now().add(const Duration(milliseconds: 3500));
    while (mounted &&
        !(_syncReadyAck && fullSyncReceived && _bleSessionReady) &&
        DateTime.now().isBefore(readyDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!_syncReadyAck || !fullSyncReceived || !_bleSessionReady) {
      throw StateError('BLE session not ready');
    }

    // Final synchronized snapshot includes the phone battery temperature.
    await _readBatteryTemperatureOnce(updateUi: false);
    fullSyncReceived = false;
    await sendCommand('SYNC', showError: false);
    final finalSyncDeadline = DateTime.now().add(const Duration(milliseconds: 2500));
    while (mounted &&
        !fullSyncReceived &&
        DateTime.now().isBefore(finalSyncDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!fullSyncReceived) {
      throw StateError('Final Full Sync failed');
    }

    if (!mounted) return;

    final readySnapshot = Map<String, String>.from(_pendingTelemetry);
    _pendingTelemetry.clear();

    setState(() {
      for (final entry in readySnapshot.entries) {
        _applyTelemetryValue(entry.key, entry.value);
      }
      connected = true;
      syncing = false;
      dashboardReady = true;
      notice = 'System ready.';
      rgbColorController.text = rgbColor;
      color5Controller.text = color5V;
      color9Controller.text = color9V;
      color12Controller.text = color12V;
    });
    _startBatteryTelemetry();
    unawaited(_setBackgroundService(true));

    if (resetReason != 'POWERON' && resetReason != 'UNKNOWN') {
      _showSnackBar(
        'Reset: ${_friendlyReset(resetReason)}',
        color: Colors.orangeAccent,
      );
    }
  }

  Future<void> _disconnect() async {
    try {
      await device?.disconnect();
    } catch (e) {
      debugPrint('disconnect: $e');
    }
  }

  Future<bool> sendCommand(String command, {bool showError = true}) {
    final completer = Completer<bool>();
    _writeQueue = _writeQueue.then((_) async {
      if (!_bleReady || rx == null) {
        if (showError && mounted) {
          _showSnackBar('Bluetooth is not ready.', color: Colors.orangeAccent);
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
      final canNoResponse = rx!.properties.writeWithoutResponse;
      final requiresResponse = _requiresResponse(command);

      try {
        await rx!.write(
          payload,
          withoutResponse: !requiresResponse && canNoResponse,
        ).timeout(const Duration(seconds: 4));
        if (!completer.isCompleted) completer.complete(true);
      } catch (e) {
        debugPrint('BLE write $command: $e');

        if (!completer.isCompleted) completer.complete(false);
      }
    }).catchError((_) {
      if (!completer.isCompleted) completer.complete(false);
    });
    return completer.future;
  }

  String? _ackItemForCommand(String command) {
    final c = command.trim().toUpperCase();
    if (c == 'SYNC_READY') return 'SYNC_READY';
    if (c == 'OTAENTER') return 'OTAENTER';
    if (c == 'CLOUDOTA') return 'CLOUDOTA';
    if (c == 'RGB:ON' || c == 'RGB:OFF') return 'RGB';
    if (c.startsWith('MODE:')) return 'MODE';
    if (c.startsWith('BRIGHTNESS:')) return 'BRIGHTNESS';
    if (c.startsWith('COLOR:')) return 'COLOR';
    if (c.startsWith('V5COLOR:')) return 'V5COLOR';
    if (c.startsWith('V9COLOR:')) return 'V9COLOR';
    if (c.startsWith('V12COLOR:')) return 'V12COLOR';
    if (c.startsWith('HOTLIMIT:')) return 'HOTLIMIT';
    if (c.startsWith('BATT5:')) return 'BATT5';
    if (c.startsWith('BATT12:')) return 'BATT12';
    if (c.startsWith('VOLTAGE:')) return 'VOLTAGE';
    if (c == 'FAN:ON' || c == 'FAN:OFF') return 'FAN';
    if (c == 'PELTIER:ON' || c == 'PELTIER:OFF') return 'PELTIER';
    if (c == 'ADAPTIVE:ON' || c == 'ADAPTIVE:OFF') return 'ADAPTIVE';
    if (c.startsWith('FANSPEED:')) return 'FANSPEED';
    if (c == 'RESET:TEMPERATURE') return 'RESET_TEMPERATURE';
    if (c == 'RESET:VOLTAGECOLORS') return 'RESET_VOLTAGECOLORS';
    if (c.startsWith('SSID:')) return 'SSID';
    if (c.startsWith('PASS:')) return 'PASS';
    if (c.startsWith('URL:')) return 'URL';
    if (c.startsWith('VERSION:')) return 'VERSION';
    return null;
  }

  Future<String> _waitForAck(String item, {Duration timeout = const Duration(seconds: 3)}) async {
    final completer = Completer<String>();
    (_ackWaiters[item] ??= <Completer<String>>[]).add(completer);
    try {
      return await completer.future.timeout(timeout);
    } catch (_) {
      final list = _ackWaiters[item];
      list?.remove(completer);
      if (list != null && list.isEmpty) _ackWaiters.remove(item);
      return 'TIMEOUT';
    }
  }

  Future<bool> _sendAndWaitAck(
    String command, {
    bool showError = true,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final item = _ackItemForCommand(command);
    if (item == null) return sendCommand(command, showError: showError);
    final ackFuture = _waitForAck(item, timeout: timeout);
    final sent = await sendCommand(command, showError: showError);
    if (!sent) {
      final waiters = _ackWaiters[item];
      if (waiters != null && waiters.isNotEmpty) {
        waiters.removeLast();
        if (waiters.isEmpty) _ackWaiters.remove(item);
      }
      return false;
    }
    final reason = await ackFuture;
    return reason == 'OK' ||
        reason == 'ACCEPTED' ||
        reason == 'READY' ||
        reason == 'STARTING';
  }

  Future<bool> _waitUntil(bool Function() predicate, {Duration timeout = const Duration(seconds: 3)}) async {
    final deadline = DateTime.now().add(timeout);
    while (mounted && DateTime.now().isBefore(deadline)) {
      if (predicate()) return true;
      await Future<void>.delayed(const Duration(milliseconds: 35));
    }
    return predicate();
  }

  bool _requiresResponse(String command) {
    final c = command.trim().toUpperCase();
    return c == 'SYNC' ||
        c == 'SYNC_READY' ||
        c == 'CLOUDOTA' ||
        c == 'OTAENTER' ||
        c.startsWith('VOLTAGE:') ||
        c.startsWith('SSID:') ||
        c.startsWith('PASS:') ||
        c.startsWith('URL:') ||
        c.startsWith('VERSION:') ||
        c.startsWith('FAN:') ||
        c.startsWith('PELTIER:') ||
        c.startsWith('ADAPTIVE:') ||
        c.startsWith('FANSPEED:') ||
        c.startsWith('HOTLIMIT:') ||
        c.startsWith('BATT5:') ||
        c.startsWith('BATT12:') ||
        c.startsWith('RESET:') ||
        c.startsWith('PHONE:BT=');
  }

  void _parseIncoming(String incoming) {
    incomingBuffer += incoming;
    if (incomingBuffer.length > 16000) {
      final marker = incomingBuffer.lastIndexOf('<SYNC_START>');
      incomingBuffer = marker >= 0 ? incomingBuffer.substring(marker) : '';
    }

    while (true) {
      final start = incomingBuffer.indexOf('<SYNC_START>');
      if (start < 0) break;
      final end = incomingBuffer.indexOf('<SYNC_END>', start);
      if (end < 0) break;

      final before = incomingBuffer.substring(0, start);
      if (before.isNotEmpty) {
        for (final line in before.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty) _applyLine(trimmed);
        }
      }

      final payload = incomingBuffer.substring(
        start + '<SYNC_START>'.length,
        end,
      );
      incomingBuffer = incomingBuffer.substring(end + '<SYNC_END>'.length);

      _syncSnapshot.clear();
      for (final rawLine in payload.split('\n')) {
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
      _commitTelemetry(_syncSnapshot);
      fullSyncReceived = true;
    }

    while (incomingBuffer.contains('\n') && !incomingBuffer.contains('<SYNC_START>')) {
      final nl = incomingBuffer.indexOf('\n');
      final line = incomingBuffer.substring(0, nl).trim();
      incomingBuffer = incomingBuffer.substring(nl + 1);
      if (line.isNotEmpty) _applyLine(line);
    }
  }

  void _handleAckLine(String line) {
    final parts = line.substring(4).split(';');
    final item = parts.isNotEmpty ? parts[0].split('=').first.trim().toUpperCase() : '';
    final rawReason = parts.length > 1 && parts[1].startsWith('REASON=')
        ? parts[1].substring(7)
        : 'UNKNOWN';
    final reason = rawReason.trim().toUpperCase();

    final waiters = _ackWaiters[item];
    if (waiters != null && waiters.isNotEmpty) {
      final waiter = waiters.removeAt(0);
      if (!waiter.isCompleted) waiter.complete(reason);
      if (waiters.isEmpty) _ackWaiters.remove(item);
    }

    if (item == 'SYNC_READY' &&
        (reason == 'OK' || reason == 'READY' || reason == 'STARTING')) {
      _syncReadyAck = true;
      return;
    }

    if (reason != 'OK' &&
        reason != 'ACCEPTED' &&
        reason != 'READY' &&
        reason != 'STARTING') {
      _showSnackBar(_friendlyReason(reason), color: Colors.orangeAccent);
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
    _commitTelemetry(<String, String>{key: value});
  }

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
      _pendingTelemetry.addAll(values);
      return;
    }

    if (!mounted) return;
    setState(() {
      for (final entry in values.entries) {
        _applyTelemetryValue(entry.key, entry.value);
      }
    });
  }

  void _applyTelemetryValue(String key, String value) {
    switch (key) {
      case 'VERSION':
        firmwareVersion = value;
        break;
      case 'PROTOCOL':
        break;
      case 'STATE_SEQ':
        stateSequence = int.tryParse(value) ?? stateSequence;
        break;
      case 'BLE_SESSION':
        _bleSessionReady = value == 'READY';
        break;
      case 'VOLTAGE':
        voltage = value;
        if (adaptiveTransitioning && value == '5V') {
          adaptiveTransitioning = false;
        }
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
        if (!adaptiveOn) {
          adaptiveTransitioning = false;
        } else if (voltage != '5V') {
          adaptiveTransitioning = true;
        }
        break;
      case 'ADAPTIVE_CEILING':
        adaptiveCeiling = value;
        break;
      case 'RGB':
        rgbOn = value == 'ON';
        break;
      case 'MODE':
        rgbMode = (int.tryParse(value) ?? rgbMode).clamp(1, 8).toInt();
        break;
      case 'BRIGHTNESS':
        brightness = (int.tryParse(value) ?? brightness).clamp(0, 100).toInt();
        brightnessDraft = brightness;
        break;
      case 'RGB_COLOR':
        rgbColor = value;
        rgbColorController.text = value;
        break;
      case 'COLOR_5V':
        color5V = value;
        color5Controller.text = value;
        break;
      case 'COLOR_9V':
        color9V = value;
        color9Controller.text = value;
        break;
      case 'COLOR_12V':
        color12V = value;
        color12Controller.text = value;
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
        otaProgress = (int.tryParse(value) ?? otaProgress).clamp(0, 100).toInt();
        break;
      case 'OTA_ERROR_CODE':
        otaErrorCode = int.tryParse(value) ?? otaErrorCode;
        break;
      case 'OTA_ERROR':
        otaError = value;
        break;
      case 'LAST_OTA_RESULT':
        lastOtaResult = value;
        break;
      case 'RESET_REASON':
        resetReason = value;
        break;
      case 'TEMP_HOT_LIMIT':
        hotLimit = (int.tryParse(value) ?? hotLimit).clamp(40, 50).toInt();
        hotLimitDraft = hotLimit;
        break;
      case 'BATT_5':
        battery5Limit = (int.tryParse(value) ?? battery5Limit).clamp(20, 48).toInt();
        battery5Draft = battery5Limit;
        break;
      case 'BATT_12':
        battery12Limit = (int.tryParse(value) ?? battery12Limit).clamp(22, 50).toInt();
        battery12Draft = battery12Limit;
        break;
      case 'NTC_MV':
        break;
    }
  }

  void _startBatteryTelemetry() {
    batteryTimer?.cancel();
    batteryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _readBatteryTemperatureOnce();
    });
  }

  Future<void> _readBatteryTemperatureOnce({bool updateUi = true}) async {
    if (batteryReadBusy) return;
    batteryReadBusy = true;
    try {
      final value = await batteryChannel.invokeMethod<dynamic>('getBatteryTemperature');
      final temp = value is num ? value.toDouble() : -1.0;
      final valid = temp >= 0.0 && temp <= 100.0;

      if (updateUi && mounted) {
        setState(() {
          phoneBatteryValid = valid;
          phoneBatteryTemp = valid ? temp.toStringAsFixed(1) : '--';
        });
      }

      if (_bleReady) {
        await sendCommand(
          valid ? 'PHONE:BT=${temp.toStringAsFixed(1)}' : 'PHONE:BT=-1.0',
          showError: false,
        );
      }
    } catch (e) {
      debugPrint('Battery temp: $e');
      if (mounted) {
        setState(() {
          phoneBatteryValid = false;
          phoneBatteryTemp = '--';
        });
      }
    } finally {
      batteryReadBusy = false;
    }
  }

  void _scheduleRuntimeSync() {
    if (!connected || !_bleReady || !_bleSessionReady) return;
    runtimeSyncTimer?.cancel();
    runtimeSyncTimer = Timer(const Duration(milliseconds: 90), () {
      if (!mounted || !connected || !_bleReady || !_bleSessionReady) return;
      // Refresh firmware-owned state after a short burst of commands.
      // This is deliberately non-blocking so rapid controls stay responsive.
      unawaited(sendCommand('SYNC', showError: false));
    });
  }

  Future<bool> _sendAndConfirm(
    String command, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final accepted = await _sendAndWaitAck(
      command,
      showError: false,
      timeout: timeout,
    );
    if (accepted) {
      _scheduleRuntimeSync();
      _notifyCommandAccepted(command);
    }
    return accepted;
  }

  Future<void> _requestVoltage(String target) async {
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
          _showSnackBar('Voltage change not confirmed.');
        }
      }
    } catch (e) {
      debugPrint('Voltage command: $e');
      voltageGuardTimer?.cancel();
      if (mounted) {
        setState(() => voltageGuardActive = false);
        _showSnackBar('Voltage change failed.');
      }
    }
  }

  Future<void> _toggleFan(bool enabled) async {
    if (!connected || adaptiveOn) return;
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'FAN:ON' : 'FAN:OFF',
      );
      if (!ok && mounted) {
        _showSnackBar('Fan change was not confirmed by the device.', color: Colors.orangeAccent);
      }
    } catch (e) {
      debugPrint('Fan command: $e');
      if (mounted) _showSnackBar('Fan command failed.', color: Colors.orangeAccent);
    }
  }

  Future<void> _togglePeltier(bool enabled) async {
    if (!connected || adaptiveOn) return;
    try {
      if (enabled && !fanOn) {
        final approved = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Peltier Safety'),
            content: const Text('Fan must be running before Peltier can be enabled.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('BATAL')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('NYALAKAN FAN')),
            ],
          ),
        );
        if (approved != true) return;
        final fanOk = await _sendAndConfirm('FAN:ON');
        if (!fanOk) {
          _showSnackBar('Fan activation was not confirmed by the device.', color: Colors.orangeAccent);
          return;
        }
      }

      final ok = await _sendAndConfirm(
        enabled ? 'PELTIER:ON' : 'PELTIER:OFF',
        timeout: const Duration(seconds: 6),
      );
      if (!ok && mounted) {
        _showSnackBar('Peltier change was not confirmed by the device. ${safetyReason == 'NONE' ? '' : safetyReason}', color: Colors.orangeAccent);
      }
    } catch (e) {
      debugPrint('Peltier command: $e');
      if (mounted) _showSnackBar('Peltier command failed.', color: Colors.orangeAccent);
    }
  }

  Future<void> _toggleAdaptive(bool enabled) async {
    if (!connected) return;
    if (mounted) setState(() {
      adaptiveTransitioning = true;
    });
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF',
        timeout: const Duration(seconds: 4),
      );
      if (!ok && mounted) {
        _showSnackBar('Adaptive Mode change was not confirmed by the device.', color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) {
        setState(() {
          adaptiveTransitioning = false;
        });
      }
    }
  }

  Future<void> _setRgb(bool enabled) async {
    if (!connected) return;
    try {
      final ok = await _sendAndConfirm(
        'RGB:' + (enabled ? 'ON' : 'OFF'),
      );
      if (!ok && mounted) {
        _showSnackBar('LED power change was not confirmed by the device.');
      }
    } catch (e) {
      debugPrint('LED power command: $e');
      if (mounted) _showSnackBar('LED power command failed.');
    }
  }

  Future<void> _setMode(int mode) async {
    if (!connected) return;
    try {
      final next = mode.clamp(1, 8).toInt();
      final ok = await _sendAndConfirm('MODE:$next');
      if (!ok && mounted) {
        _showSnackBar('LED mode change was not confirmed by the device.');
      }
    } catch (e) {
      debugPrint('LED mode command: $e');
      if (mounted) _showSnackBar('LED mode command failed.');
    }
  }

  Future<void> _setBrightness(double value) async {
    if (!connected) return;
    try {
      final next = value.round().clamp(0, 100).toInt();
      final ok = await _sendAndConfirm('BRIGHTNESS:$next');
      if (!ok && mounted) {
        setState(() => brightnessDraft = brightness);
        _showSnackBar('LED brightness change was not confirmed by the device.');
      }
    } catch (e) {
      debugPrint('LED brightness command: $e');
      if (mounted) _showSnackBar('LED brightness command failed.');
    }
  }

  Future<void> _setFanSpeed(double value) async {
    if (!connected || adaptiveOn || voltage != '12V') return;
    try {
      final next = ((value / 10).round() * 10)
          .clamp(fanSpeedMin, fanSpeedMax)
          .toInt();
      final ok = await _sendAndConfirm('FANSPEED:$next');
      if (!ok && mounted) {
        setState(() => fanSpeedDraft = fanSpeed);
        _showSnackBar('Fan speed change was not confirmed by the device.');
      }
    } catch (e) {
      debugPrint('Fan speed command: $e');
      if (mounted) _showSnackBar('Fan speed command failed.');
    }
  }

  Future<void> _setHotLimit(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(40, 50).toInt();
      if (mounted) setState(() => hotLimitDraft = next);
      final ok = await _sendAndConfirm('HOTLIMIT:$next');
      if (!ok && mounted) {
        setState(() => hotLimitDraft = hotLimit);
        _showSnackBar('Hotside limit not confirmed.');
      }
    } catch (e) {
      debugPrint('Hotside limit command: $e');
      if (mounted) {
        setState(() => hotLimitDraft = hotLimit);
        _showSnackBar('Hotside limit failed.');
      }
    }
  }

  Future<void> _setBattery5(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(20, 48).toInt();
      if (next >= battery12Limit - 1) return;
      if (mounted) setState(() => battery5Draft = next);
      final ok = await _sendAndConfirm('BATT5:$next');
      if (!ok && mounted) {
        setState(() => battery5Draft = battery5Limit);
        _showSnackBar('5V battery limit not confirmed.');
      }
    } catch (e) {
      debugPrint('Battery 5V command: $e');
      if (mounted) {
        setState(() => battery5Draft = battery5Limit);
        _showSnackBar('5V battery limit failed.');
      }
    }
  }

  Future<void> _setBattery12(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(22, 50).toInt();
      if (next <= battery5Limit + 1) return;
      if (mounted) setState(() => battery12Draft = next);
      final ok = await _sendAndConfirm('BATT12:$next');
      if (!ok && mounted) {
        setState(() => battery12Draft = battery12Limit);
        _showSnackBar('12V battery limit not confirmed.');
      }
    } catch (e) {
      debugPrint('Battery 12V command: $e');
      if (mounted) {
        setState(() => battery12Draft = battery12Limit);
        _showSnackBar('12V battery limit failed.');
      }
    }
  }

  Future<void> _sendColor(String command, TextEditingController controller) async {
    final value = controller.text.trim().toUpperCase();
    if (!isValidHexColor(value)) {
      _showSnackBar('Enter a valid hex color in #RRGGBB format.');
      return;
    }
    if (!connected) return;
    try {
      final ok = await _sendAndConfirm(
        command + ':' + value.substring(1),
      );
      if (!ok && mounted) {
        _showSnackBar('Color change was not confirmed by the device.');
      }
    } catch (e) {
      debugPrint('Color command: $e');
      if (mounted) _showSnackBar('Color command failed.');
    }
  }

  Future<void> _resetTemperatureSettings() async {
    if (!connected || adaptiveOn) return;
    try {
      final ok = await _sendAndConfirm('RESET:TEMPERATURE');
      if (!ok && mounted) _showSnackBar('Temperature reset was not confirmed by the device.');
    } catch (e) {
      debugPrint('Temperature reset: $e');
      if (mounted) _showSnackBar('Temperature reset failed.');
    }
  }

  Future<void> _resetVoltageColors() async {
    if (!connected) return;
    try {
      final ok = await _sendAndConfirm('RESET:VOLTAGECOLORS');
      if (!ok && mounted) _showSnackBar('Voltage color reset was not confirmed by the device.');
    } catch (e) {
      debugPrint('Voltage color reset: $e');
      if (mounted) _showSnackBar('Voltage color reset failed.');
    }
  }

  Future<bool> _requestFreshSync({Duration timeout = const Duration(seconds: 3)}) async {
    fullSyncReceived = false;
    final sent = await sendCommand('SYNC', showError: false);
    if (!sent) return false;
    return _waitUntil(() => fullSyncReceived, timeout: timeout);
  }

  Future<void> _openFirmwareSettings() async {
    if (!connected) {
      _showSnackBar('Connect to JE X FYZ first.', color: Colors.orangeAccent);
      return;
    }
    await _requestFreshSync();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => FirmwareUpdateDialog(
        currentVersion: firmwareVersion,
        onUpdate: _startCloudOta,
      ),
    );
  }

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
      final ok = await _sendAndWaitAck(command, showError: false, timeout: const Duration(seconds: 4));
      if (!ok) {
        _showSnackBar(
          'OTA could not start: command ${_ackItemForCommand(command) ?? command} was rejected by the device.',
          color: Colors.redAccent,
        );
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }

    _showSnackBar(
      'OTA in progress.',
      color: Colors.purpleAccent,
    );
    _startOtaReconnectMonitor();
  }

  void _startOtaReconnectMonitor() {
    reconnectTimer?.cancel();
    int attempts = 0;
    reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (connected || attempts >= 12) {
        timer.cancel();
        return;
      }
      attempts++;
      await _scanAndConnect();
      if (connected) timer.cancel();
    });
  }

  Map<String, String> _otaDiagnosticFields(String raw) {
    final fields = <String, String>{};
    for (final part in raw.split('|')) {
      final index = part.indexOf('=');
      if (index <= 0) continue;
      fields[part.substring(0, index).trim().toUpperCase()] =
          part.substring(index + 1).trim();
    }
    return fields;
  }

  String _friendlyOtaStage(String stage) {
    switch (stage.toUpperCase()) {
      case 'LOCAL_FILE_CHECK': return 'File check';
      case 'LOCAL_SIZE_CHECK': return 'Size check';
      case 'LOCAL_UPDATE_BEGIN': return 'Update begin';
      case 'LOCAL_RECEIVE': return 'Receiving';
      case 'LOCAL_FLASH_WRITE': return 'Flash write';
      case 'LOCAL_SIZE_VERIFY': return 'Size verify';
      case 'LOCAL_FINALIZE': return 'Finalize';
      case 'LOCAL_FLASH_READBACK': return 'Flash readback';
      case 'LOCAL_FLASH_ERASE': return 'Flash erase';
      case 'LOCAL_BOOT_PARTITION': return 'Boot partition';
      case 'ONLINE_WIFI_CONNECT': return 'Wi-Fi connect';
      case 'ONLINE_TIME_SYNC': return 'Time sync';
      case 'ONLINE_HTTPS_BEGIN': return 'HTTPS connect';
      case 'ONLINE_HTTP_UPDATE': return 'HTTP update';
      case 'ONLINE_UPDATE_BEGIN': return 'Update begin';
      case 'ONLINE_DOWNLOAD': return 'Download';
      case 'ONLINE_RANGE_PROBE': return 'Range probe';
      case 'ONLINE_RANGE_REQUEST': return 'Range request';
      case 'ONLINE_RANGE_RESPONSE': return 'Range response';
      case 'ONLINE_RANGE_WRITE': return 'Range write';
      case 'ONLINE_RANGE_RETRY': return 'Range retry';
      case 'ONLINE_RANGE_RESUME': return 'Range resume';
      case 'ONLINE_FLASH_WRITE': return 'Flash write';
      case 'ONLINE_FLASH_ERASE': return 'Flash erase';
      case 'ONLINE_FLASH_READBACK': return 'Flash readback';
      case 'ONLINE_IMAGE_VALIDATE': return 'Image validate';
      case 'ONLINE_IMAGE_VERIFY': return 'Image verify';
      case 'ONLINE_BOOT_PARTITION': return 'Boot partition';
      case 'ONLINE_HTTP_RESPONSE': return 'HTTP response';
      default: return stage.replaceAll('_', ' ');
    }
  }

  String _friendlyOtaResult(String value) {
    final raw = value.trim();
    if (raw.isEmpty || raw.toUpperCase() == 'NONE') return '';
    final upper = raw.toUpperCase();

    if (upper.startsWith('OTA_FAILED|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = fields['MODE'] ?? 'OTA';
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final error = fields['ERROR'] ?? 'Unknown error';
      final progress = fields['PROGRESS'] ?? '--';
      final code = fields['CODE'] ?? '0';
      return 'OTA failed • $mode • $stage • $error [${progress}% / code $code]';
    }

    if (upper.startsWith('OTA_SUCCESS|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = fields['MODE'] ?? 'OTA';
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final version = fields['VERSION'] ?? '';
      return 'OTA successful • $mode • $stage${version.isEmpty ? '' : ' • $version'}';
    }

    if (upper.startsWith('IN_PROGRESS|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = fields['MODE'] ?? 'OTA';
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final progress = fields['PROGRESS'] ?? '0';
      return 'OTA in progress • $mode • $stage • ${progress}%';
    }

    if (upper == 'IN_PROGRESS') return 'OTA update in progress.';
    if (upper == 'LOCAL_SUCCESS') return 'Local OTA successful.';
    if (upper.startsWith('SUCCESS_')) {
      return 'OTA successful: ' + raw.substring(8) + '.';
    }
    if (upper.startsWith('UPLOAD_SIZE_MISMATCH_')) {
      final parts = raw.split('_');
      if (parts.length >= 5) {
        return 'OTA failed: uploaded ' + parts[3] + ' / ' + parts[4] + ' bytes.';
      }
      return 'OTA failed: upload size mismatch.';
    }
    if (upper.startsWith('OTA_END_ERROR_')) {
      final parts = raw.split('_');
      if (parts.length >= 5) {
        return 'OTA failed: ' + parts.sublist(4).join(' ').toLowerCase() + '.';
      }
      return 'OTA failed: finalization error.';
    }
    if (upper.contains('FAILED') || upper.contains('ERROR')) {
      return 'OTA failed: ' + raw.replaceAll('_', ' ').toLowerCase() + '.';
    }
    return raw.replaceAll('_', ' ');
  }

  String _friendlyReset(String value) {
    switch (value) {
      case 'BROWNOUT': return 'Brownout / supply drop';
      case 'PANIC': return 'Firmware panic';
      case 'SOFTWARE': return 'Software reset';
      case 'WDT':
      case 'INT_WDT':
      case 'TASK_WDT': return 'Watchdog reset';
      case 'EXTERNAL': return 'External reset';
      case 'DEEPSLEEP': return 'Deep sleep reset';
      case 'POWERON': return 'Power-on';
      default: return value;
    }
  }

  String _friendlyReason(String reason) {
    switch (reason) {
      case 'NTC_ERROR': return 'Temperature sensor error.';
      case 'HOTSIDE_PROTECTION': return 'Hotside protection active.';
      case 'FAN_REQUIRED': return 'Fan required before Peltier.';
      case 'PELTIER_ON': return 'Fan locked while Peltier is ON.';
      case 'ADAPTIVE_ACTIVE': return 'Manual cooling controls locked.';
      case 'MANUAL_12V_ONLY': return 'Manual 12V only.';
      case 'VOLTAGE_GUARD_OR_BUSY': return 'Voltage command pending.';
      case 'SYNC_REQUIRED': return 'Device sync in progress.';
      case 'RATE_LIMIT': return 'Command rate limited.';
      case 'MUST_BE_BELOW_BATT12': return '5V battery limit must stay below 12V.';
      case 'MUST_BE_ABOVE_BATT5': return '12V battery limit must stay above 5V.';
      default: return reason.replaceAll('_', ' ').toLowerCase();
    }
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
    final media = MediaQuery.of(context);
    const designWidth = 360.0;
    const homeHeight = 420.0;
    final scale = media.size.width / designWidth;
    final top = media.padding.top + homeHeight * scale;
    final sheetHeight = (media.size.height - top).clamp(1.0, media.size.height).toDouble();

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
            child: _ConnectionSheetContent(
              onScan: _startScanFromSheet,
              onConnect: _connect,
              onOpenBluetoothSettings: _openBluetoothSettings,
              onOpenLocationSettings: _openLocationSettings,
            ),
          ),
        );
      },
    ).whenComplete(() => FlutterBluePlus.stopScan());

    _startScanFromSheet();
  }

  Future<void> _startScanFromSheet() async {
    final accessReady = await _requestPermissions();
    if (!accessReady) return;
    try {
      await FlutterBluePlus.stopScan();
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidCheckLocationServices: false,
        androidUsesFineLocation: false,
      );
    } catch (e) {
      debugPrint('start scan sheet: $e');
    }
  }

  Widget _homeMetric(
    String label,
    String value,
    String unit, {
    required Color color,
    required IconData icon,
  }) {
    final display = value == '--' ? '--' : value + unit;
    final active = value != '--';

    return Padding(
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 41,
                height: 41,
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: color.withValues(alpha: 0.52),
                        width: 1.1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 13,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          maxLines: 1,
                          style: const TextStyle(
                            color: const Color(0xFFD4D7E0),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.45,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      display,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: active ? color : const Color(0xFF7F8592),
                        fontSize: 18.5,
                        fontWeight: FontWeight.w900,
                        height: 0.95,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeStateChip({
    required String label,
    required bool value,
    required IconData icon,
    required Color color,
  }) {
    return _homeMetric(
      label,
      connected ? (value ? 'ON' : 'OFF') : '--',
      '',
      color: color,
      icon: icon,
    );
  }

  Widget _homeFanSpeed() {
    final displaySpeed = !connected
        ? '--'
        : (voltage == '5V' || voltage == '9V')
            ? '100%'
            : (!adaptiveOn && voltage == '12V')
                ? '$fanSpeed%'
                : '--';
    return _homeMetric(
      'FAN SPEED',
      displaySpeed,
      '',
      color: const Color(0xFFFFCD38),
      icon: PhosphorIconsRegular.gauge,
    );
  }

  String _compactNotifyMessage(String message) {
    final raw = message.trim();
    if (raw.isEmpty) return '';

    final lower = raw.toLowerCase();
    if (lower == 'scanning for je x fyz...') return 'Scanning...';
    if (lower == 'connecting to je x fyz...') return 'Connecting to device...';
    if (lower == 'device disconnected.') return 'Bluetooth disconnected.';
    if (lower == 'je x fyz was not found.') return 'Device not found.';
    if (lower == 'bluetooth scan failed.') return 'Scan failed.';
    if (lower == 'bluetooth is not ready.') return 'Bluetooth unavailable.';
    if (lower == 'connect to je x fyz first.') return 'Connect to device first.';
    if (lower.startsWith('ota could not start:')) return 'OTA start rejected.';
    if (lower.contains('was not confirmed by the device')) {
      final prefix = raw.replaceFirst(
        RegExp(r'\s+was not confirmed by the device\.?[\s\S]*$', caseSensitive: false),
        '',
      ).trim();
      return prefix.isEmpty ? 'Device did not confirm the command.' : prefix + ' not confirmed.';
    }
    if (lower.contains('command failed.')) {
      final prefix = raw.replaceFirst(
        RegExp(r'\s+command failed\.?$', caseSensitive: false),
        '',
      ).trim();
      return prefix.isEmpty ? 'Command failed.' : prefix + ' failed.';
    }
    return raw;
  }

  String _professionalNotice() {
    final custom = _compactNotifyMessage(notice);

    // Safety validation states are meaningful only after a device is connected.
    // Do not let a stale pre-connection WAITING_* state surface as a warning
    // while the Home dashboard is actually offline. Preserve other explicit
    // latest-event messages such as connection failures or device-not-found.
    if (!connected && !_bleConnecting) {
      final upper = custom.toUpperCase();
      final staleValidation = upper == 'VALIDATING TEMPERATURE...' ||
          upper == 'TEMPERATURE SENSORS: VALIDATING...' ||
          upper == 'VALIDATING TEMPERATURE SENSORS...';
      if (custom.isEmpty || staleValidation) {
        return 'Bluetooth disconnected.';
      }
      return custom;
    }

    final otaNotice = _friendlyOtaResult(lastOtaResult);
    if (otaNotice.isNotEmpty && lastOtaResult.toUpperCase() != 'IN_PROGRESS') {
      return otaNotice;
    }

    if (custom.isNotEmpty) return custom;

    if (_bleConnecting) return 'Connecting to device...';
    if (syncing && !dashboardReady) return 'Synchronizing device...';

    switch (safetyReason) {
      case 'WAITING_FOR_NTC':
      case 'WAITING_FOR_SENSOR_VALIDATION':
        return 'Validating temperature...';
      case 'NTC_ERROR':
        return 'Temperature sensor error. Cooling locked.';
      case 'HOTSIDE_PROTECTION':
        return 'Hotside protection active. Peltier paused.';
      case 'FAN_REQUIRED':
        return 'Fan required before Peltier.';
      case 'PELTIER_ON':
        return 'Fan locked while Peltier is ON.';
      case 'ADAPTIVE_ACTIVE':
        return 'Manual cooling controls locked.';
      case 'MANUAL_12V_ONLY':
        return 'Manual 12V only.';
      case 'VOLTAGE_GUARD_OR_BUSY':
        return 'Voltage command pending.';
      case 'RATE_LIMIT':
        return 'Command rate limited.';
      case 'DISCONNECTED':
        return 'Bluetooth disconnected.';
      case 'NONE':
        return 'System ready.';
      default:
        return _friendlyReason(safetyReason);
    }
  }

  void _notifyCommandAccepted(String command) {
    if (!mounted) return;
    final c = command.trim().toUpperCase();
    String? message;

    if (c.startsWith('VOLTAGE:')) {
      message = 'Voltage set to ' + c.substring(8) + '.';
    } else if (c == 'FAN:ON') {
      message = 'Fan ON.';
    } else if (c == 'FAN:OFF') {
      message = 'Fan OFF.';
    } else if (c == 'PELTIER:ON') {
      message = 'Peltier ON.';
    } else if (c == 'PELTIER:OFF') {
      message = 'Peltier OFF.';
    } else if (c == 'ADAPTIVE:ON') {
      message = 'Adaptive ON.';
    } else if (c == 'ADAPTIVE:OFF') {
      message = 'Adaptive OFF.';
    } else if (c.startsWith('FANSPEED:')) {
      message = 'Fan ' + c.substring(9) + '%.';
    } else if (c == 'RGB:ON') {
      message = 'LED ON.';
    } else if (c == 'RGB:OFF') {
      message = 'LED OFF.';
    } else if (c.startsWith('MODE:')) {
      message = 'Mode updated.';
    } else if (c.startsWith('BRIGHTNESS:')) {
      message = 'Brightness updated.';
    } else if (c.startsWith('COLOR:') ||
        c.startsWith('V5COLOR:') ||
        c.startsWith('V9COLOR:') ||
        c.startsWith('V12COLOR:')) {
      message = 'Color updated.';
    } else if (c.startsWith('HOTLIMIT:')) {
      message = 'Hotside ' + c.substring(9) + '°C.';
    } else if (c.startsWith('BATT5:')) {
      message = '5V battery limit updated.';
    } else if (c.startsWith('BATT12:')) {
      message = '12V battery limit updated.';
    } else if (c == 'RESET:TEMPERATURE') {
      message = 'Temperature reset.';
    } else if (c == 'RESET:VOLTAGECOLORS') {
      message = 'Colors reset.';
    }

    if (message != null) {
      setState(() => notice = message!);
    }
  }

  String _notifyStateLabel() {
    final custom = notice.trim().toUpperCase();
    if (_bleConnecting) return 'NOTIFY • BLUETOOTH';
    if (syncing && !dashboardReady) return 'NOTIFY • SYNC';

    final otaResultUpper = lastOtaResult.trim().toUpperCase();
    final hasError = custom.contains('FAILED') ||
        custom.contains('ERROR') ||
        custom.contains('NOT FOUND') ||
        custom.contains('SERVICE DISCOVERY') ||
        otaResultUpper.contains('FAILED') ||
        otaResultUpper.contains('ERROR');
    if (hasError) return 'NOTIFY • ERROR';

    // WAITING_* is a startup/sensor-validation state and must not be shown as
    // a safety warning while the dashboard is offline.
    final warning = connected &&
        safety != 'OK' &&
        safetyReason != 'NONE' &&
        safetyReason != 'WAITING_FOR_NTC' &&
        safetyReason != 'WAITING_FOR_SENSOR_VALIDATION';
    if (warning) return 'NOTIFY • WARNING';
    return 'NOTIFY';
  }

  String _notifyStatusLabel() {
    final custom = notice.trim().toUpperCase();
    if (custom.contains('FAILED') ||
        custom.contains('ERROR') ||
        custom.contains('NOT FOUND') ||
        custom.contains('DISCONNECTED') ||
        custom.contains('SERVICE DISCOVERY')) {
      return 'ERROR';
    }
    if (_bleConnecting) return 'CONNECTING';
    if (syncing && !dashboardReady) return 'SYNCING';
    return connected ? 'ONLINE' : 'OFFLINE';
  }

  Widget _homeNotify() {
    final custom = notice.trim().toUpperCase();
    final otaResultUpper = lastOtaResult.trim().toUpperCase();
    final hasError = custom.contains('FAILED') ||
        custom.contains('ERROR') ||
        custom.contains('NOT FOUND') ||
        custom.contains('DISCONNECTED') ||
        custom.contains('SERVICE DISCOVERY') ||
        otaResultUpper.contains('FAILED') ||
        otaResultUpper.contains('ERROR');
    final warning = safetyReason != 'NONE' &&
        safetyReason != 'WAITING_FOR_NTC' &&
        safetyReason != 'WAITING_FOR_SENSOR_VALIDATION';
    final alert = hasError || warning;
    final icon = hasError
        ? PhosphorIconsBold.xCircle
        : alert
            ? PhosphorIconsBold.warning
            : PhosphorIconsRegular.shieldCheck;
    final color = hasError
        ? const Color(0xFFFF5164)
        : alert
            ? const Color(0xFFFFB72B)
            : const Color(0xFF4DE7B7);
    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: hasError ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 43,
            child: Center(
              child: Icon(icon, size: 27, color: color),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _notifyStateLabel(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: 13,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _professionalNotice(),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            color: Color(0xFFF4F6FA),
                            fontSize: 10.5,
                            height: 1.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0x12FFFFFF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              _notifyStatusLabel(),
              style: TextStyle(
                color: hasError
                    ? const Color(0xFFFF8A98)
                    : connected
                        ? Colors.cyanAccent
                        : Colors.white38,
                fontSize: 7.3,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E7E9)),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 5)),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.2)),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }

  Widget _switchRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required bool enabled,
    required Future<void> Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Container(

          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: value ? Colors.blueAccent.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.04),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 19, color: value ? Colors.blueAccent : Colors.black38),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              StaticSwitcher(

                child: Text(
                  subtitle,
                  key: ValueKey<String>(subtitle),
                  style: TextStyle(fontSize: 10, color: enabled ? Colors.black45 : Colors.black38, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.blueAccent,
          activeTrackColor: Colors.blueAccent.withValues(alpha: 0.25),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }

  Widget _voltageRow(String target, String mode) {
    final active = voltage == target;
    final disabled = !connected || adaptiveOn || voltageGuardActive;
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: disabled ? null : () => _requestVoltage(target),
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: active ? Colors.black : const Color(0xFFE4E4E7)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Text(target, style: TextStyle(color: active ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            Expanded(
              child: Text(mode, style: TextStyle(color: active ? Colors.white70 : Colors.black45, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            StaticSwitcher(

              child: Icon(
                active ? PhosphorIconsBold.checkCircle : PhosphorIconsRegular.circle,
                key: ValueKey<bool>(active),
                color: active ? Colors.blueAccent : Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smoothList({
    required List<Widget> children,
    required String storageKey,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(2, 2, 2, 20),
  }) {
    return ListView(
      key: PageStorageKey<String>(storageKey),
      physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollCacheExtent: const ScrollCacheExtent.pixels(480),
      padding: padding,
      children: children,
    );
  }

  Widget _buildVoltageTab({Key? key}) {
    return KeyedSubtree(key: key, child: _smoothList(
      storageKey: 'voltage',
      children: [
        _sectionTitle(
          'Voltage',
          subtitle: adaptiveOn ? 'Adaptive controls voltage.' : 'Manual 5V / 9V / 12V.',
        ),
        _card(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Column(
            children: [
              _voltageRow('5V', '5V Manual'),
              _voltageRow('9V', '9V Manual'),
              _voltageRow('12V', '12V Manual'),
            ],
          ),
        ),
        if (voltageGuardActive)
          const Padding(
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text('Awaiting voltage confirmation.', style: TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        _card(
          child: Row(
            children: [
              const Icon(PhosphorIconsRegular.lightning, size: 19, color: Colors.blueAccent),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  connected ? 'Firmware state: ${voltage == '--' ? 'syncing...' : voltage}' : 'Connect first.',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildControlTab({Key? key}) {
    final speedEnabled = connected && !adaptiveOn && voltage == '12V';
    final fanLocked = connected && !adaptiveOn && peltierOn;
    return KeyedSubtree(key: key, child: _smoothList(
      storageKey: 'control',
      children: [
        _sectionTitle('Cooling', subtitle: 'Fan, Peltier, and speed.'),
        _card(
          padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
          child: Column(
            children: [
              _switchRow(
                title: 'Fan',
                subtitle: fanLocked ? 'ON • locked by Peltier' : (fanOn ? 'Fan is ON' : 'Fan is OFF'),
                icon: PhosphorIconsRegular.wind,
                value: fanOn,
                enabled: connected && !adaptiveOn && !peltierOn,
                onChanged: _toggleFan,
              ),
              const Divider(height: 20),
              _switchRow(
                title: 'Peltier',
                subtitle: peltierOn ? 'ON • 5 s soft-start' : 'Peltier is OFF',
                icon: PhosphorIconsRegular.snowflake,
                value: peltierOn,
                enabled: connected && !adaptiveOn,
                onChanged: _togglePeltier,
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(PhosphorIconsRegular.gauge, size: 20, color: Colors.black45),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fan Speed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                        SizedBox(height: 3),
                        Text('Manual 12V • 50–100% • 25 kHz PWM', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Text('$fanSpeed%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                ],
              ),
              Slider(
                min: 50,
                max: 100,
                divisions: 5,
                value: fanSpeedDraft.clamp(50, 100).toDouble(),
                activeColor: Colors.black,
                inactiveColor: Colors.black12,
                onChanged: speedEnabled
                    ? (v) => setState(() => fanSpeedDraft = ((v / 10).round() * 10).clamp(50, 100).toInt())
                    : null,
                onChangeEnd: speedEnabled ? _setFanSpeed : null,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: _miniStatus('PELTIER', peltierOn ? 'ON' : 'OFF', peltierOn ? Colors.cyan : Colors.black38),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _miniStatus('FAN', fanOn ? 'ON' : 'OFF', fanOn ? Colors.blueAccent : Colors.black38),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _miniStatus('PWM', '$fanSpeed%', Colors.deepPurpleAccent),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  safety == 'OK' ? 'SAFETY: OK' : 'SAFETY: $safety${safetyReason == 'NONE' ? '' : ' • $safetyReason'}',
                  style: TextStyle(color: safety == 'OK' ? Colors.green.shade700 : Colors.orangeAccent, fontSize: 9, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _miniStatus(String label, String value, Color color) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.black45, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          const SizedBox(height: 2),
          StaticSwitcher(

            child: Text(value, key: ValueKey<String>('$label:$value'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptiveTab({Key? key}) {
    return KeyedSubtree(key: key, child: _smoothList(
      storageKey: 'adaptive',
      children: [
        _sectionTitle('Adaptive', subtitle: 'Firmware controls voltage.'),
        _card(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(

                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: adaptiveOn ? Colors.green.withValues(alpha: 0.13) : Colors.black.withValues(alpha: 0.06),
                ),
                child: Icon(adaptiveOn ? PhosphorIconsBold.shield : PhosphorIconsRegular.shield, color: adaptiveOn ? Colors.green.shade700 : Colors.black45),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adaptive Switch', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                    SizedBox(height: 4),
                    Text('Hotside + phone battery temperature.', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Switch(
                value: connected && adaptiveOn,
                activeThumbColor: Colors.green,
                onChanged: connected ? _toggleAdaptive : null,
              ),
            ],
          ),
        ),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Policy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
              const SizedBox(height: 7),
              const Text(
                'Firmware returns to 5V first, then uses the phone battery temperature zone to target 5V / 9V / 12V. Manual controls are locked while Adaptive is ON.',
                style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.35, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _miniMetric('Ceiling', adaptiveCeiling),
                  const SizedBox(width: 8),
                  _miniMetric('Battery', phoneBatteryValid ? '$phoneBatteryTemp°C' : '--'),
                ],
              ),
            ],
          ),
        ),
        _card(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Row(
            children: [
              const Icon(PhosphorIconsRegular.info, size: 18, color: Colors.blueAccent),
              const SizedBox(width: 9),
              Expanded(
                child: StaticSwitcher(

                  child: Text(
                    adaptiveTransitioning ? 'Transitioning...' : 'Adaptive state: ${adaptiveOn ? 'ON' : 'OFF'}',
                    key: ValueKey<String>('adaptive:$adaptiveOn:$adaptiveTransitioning'),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _miniMetric(String label, String value) {
    return Expanded(
      child: Container(

        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE4E4E6))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.black45, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            StaticSwitcher(

              child: Text(value, key: ValueKey<String>('$label:$value'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorField(String label, TextEditingController controller, String command) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              TextField(
                controller: controller,
                enabled: connected,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E2E5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E2E5))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                  hintText: '#RRGGBB',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: connected ? () => _sendColor(command, controller) : null,
          child: const Text('Set', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildLedTab({Key? key}) {
    final modeNames = <String>['Static', 'Breath', 'Center Out', 'Outer In', 'Dual Chase', 'Left ↔ Right', 'Rainbow', 'Twinkle'];
    final safeMode = rgbMode.clamp(1, 8);
    final modeName = modeNames[safeMode - 1];
    return KeyedSubtree(key: key, child: _smoothList(
      storageKey: 'led',
      children: [
        _sectionTitle('LED', subtitle: '4 kiri + 4 kanan • custom effects.'),
        _card(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              _switchRow(
                title: 'Power',
                subtitle: rgbOn ? 'ON' : 'OFF',
                icon: PhosphorIconsBold.lightbulb,
                value: rgbOn,
                enabled: connected,
                onChanged: _setRgb,
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: connected ? () => _setMode(rgbMode - 1) : null, icon: const Icon(PhosphorIconsBold.caretLeft, size: 28)),
                  Container(

                    width: 138,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFE4E4E6))),
                    child: StaticSwitcher(

                      child: Text('Mode $rgbMode • $modeName', key: ValueKey<int>(rgbMode), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                    ),
                  ),
                  IconButton(onPressed: connected ? () => _setMode(rgbMode + 1) : null, icon: const Icon(PhosphorIconsBold.caretRight, size: 28)),
                ],
              ),
              Row(
                children: [
                  const Icon(PhosphorIconsRegular.sun, color: Colors.black38, size: 20),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 100,
                      divisions: 20,
                      value: brightness.clamp(0, 100).toDouble(),
                      activeColor: Colors.black,
                      inactiveColor: Colors.black12,
                      onChanged: connected ? (v) => setState(() => brightness = v.round()) : null,
                      onChangeEnd: connected ? _setBrightness : null,
                    ),
                  ),
                  SizedBox(width: 42, child: Text('$brightness%', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900))),
                ],
              ),
            ],
          ),
        ),
        _sectionTitle('Custom Color'),
        _card(child: Row(children: [
          Expanded(child: TextField(
            controller: rgbColorController,
            enabled: connected,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              labelText: 'Color',
              hintText: '#FFFFFF',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )),
          const SizedBox(width: 8),
          FilledButton(onPressed: connected ? () => _sendColor('COLOR', rgbColorController) : null, child: const Text('Set')),
        ])),
        _sectionTitle('Voltage Colors', subtitle: 'Shown after voltage change.'),
        _card(child: Column(children: [
          _colorField('5V', color5Controller, 'V5COLOR'),
          const Divider(height: 18),
          _colorField('9V', color9Controller, 'V9COLOR'),
          const Divider(height: 18),
          _colorField('12V', color12Controller, 'V12COLOR'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: connected ? _resetVoltageColors : null,
              icon: const Icon(PhosphorIconsBold.arrowClockwise, size: 17),
              label: const Text('Reset Colors'),
            ),
          ),
        ])),
      ],
    ));
  }

  Widget _adjuster({required String title, required int value, required int min, required int max, required ValueChanged<int> onChanged, String unit = '°C'}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text('Range $min–$max$unit', style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        IconButton(onPressed: value <= min ? null : () => onChanged(value - 1), icon: const Icon(PhosphorIconsRegular.minusCircle)),
        Container(

          width: 66,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFE3E3E5))),
          child: StaticSwitcher(

            child: Text('$value$unit', key: ValueKey<String>('$value$unit'), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.blueAccent)),
          ),
        ),
        IconButton(onPressed: value >= max ? null : () => onChanged(value + 1), icon: const Icon(PhosphorIconsRegular.plusCircle)),
      ],
    );
  }

  Widget _buildTemperatureTab({Key? key}) {
    final locked = adaptiveOn;
    final midLow = battery5Limit + 1;
    final midHigh = battery12Limit - 1;
    return KeyedSubtree(key: key, child: _smoothList(
      storageKey: 'temperature',
      children: [
        _sectionTitle('Thermal', subtitle: locked ? 'Locked while Adaptive is ON.' : 'Sensor readings remain independent from the protection threshold.'),
        _card(
          child: _adjuster(
            title: 'Hotside Limit',
            value: hotLimitDraft,
            min: 40,
            max: 50,
            onChanged: (v) {
              if (!connected || locked) return;
              _setHotLimit(v);
            },
          ),
        ),
        _sectionTitle('Battery Zones', subtitle: '9V uses the middle zone.'),
        _card(
          padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
          child: Column(
            children: [
              _adjuster(
                title: '5V Ceiling',
                value: battery5Draft,
                min: 20,
                max: 48,
                onChanged: (v) {
                  if (!connected || locked || v >= battery12Limit - 1) return;
                  _setBattery5(v);
                },
              ),
              const Divider(height: 14),
              Row(
                children: [
                  SizedBox(width: 100, child: Text('9V Zone', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black45))),
                  Expanded(child: StaticSwitcher(duration: const Duration(milliseconds: 150), child: Text('≈ $midLow–$midHigh°C', key: ValueKey<String>('$midLow:$midHigh'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)))),
                  const Icon(PhosphorIconsRegular.lock, color: Colors.black26),
                ],
              ),
              const Divider(height: 14),
              _adjuster(
                title: '12V Floor',
                value: battery12Draft,
                min: 22,
                max: 50,
                onChanged: (v) {
                  if (!connected || locked || v <= battery5Limit + 1) return;
                  _setBattery12(v);
                },
              ),
            ],
          ),
        ),
        if (locked)
          _card(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: const Row(children: [
              Icon(PhosphorIconsBold.lock, size: 18, color: Colors.orangeAccent),
              SizedBox(width: 9),
              Expanded(child: Text('Locked in Adaptive.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
            ]),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: connected && !locked ? _resetTemperatureSettings : null,
            icon: const Icon(PhosphorIconsBold.arrowClockwise, size: 17),
            label: const Text('Reset Temperature'),
          ),
        ),
      ],
    ));
  }

  Widget _buildTabContent() {
    return switch (tabIndex) {
      0 => _buildVoltageTab(key: const ValueKey('voltage-tab')),
      1 => _buildControlTab(key: const ValueKey('control-tab')),
      2 => _buildAdaptiveTab(key: const ValueKey('adaptive-tab')),
      3 => _buildLedTab(key: const ValueKey('led-tab')),
      4 => _buildTemperatureTab(key: const ValueKey('temperature-tab')),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildHomeArea(double height) {
    final batteryValue = connected && phoneBatteryValid ? phoneBatteryTemp : '--';
    final hotValue = connected ? hotsideTemp : '--';
    final voltageValue = connected && voltage != '--' ? voltage : '--';
    final adaptiveValue = connected ? (adaptiveOn ? 'ON' : 'OFF') : '--';

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 8),
        child: Column(
          children: [
            SizedBox(
              height: 42,
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                        tooltip: connected ? 'Disconnect' : 'Bluetooth',
                        icon: Icon(
                          connected
                              ? PhosphorIconsRegular.bluetoothConnected
                              : PhosphorIconsRegular.bluetooth,
                          color: connected ? const Color(0xFF4D8CFF) : const Color(0xFFF4F6FA),
                          size: 24,
                        ),
                        onPressed: connected ? _disconnect : _showBluetoothMenu,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          headerName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFF7F8FC),
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                            letterSpacing: 0.2,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'DEVELOPED BY HORIZON',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF737986),
                            fontWeight: FontWeight.w700,
                            fontSize: 6.8,
                            letterSpacing: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                        tooltip: 'Firmware',
                        icon: const Icon(
                          PhosphorIconsRegular.gear,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: _openFirmwareSettings,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 10,
                    child: FractionallySizedBox(
                      widthFactor: 0.96,
                      alignment: Alignment.centerLeft,
                      child: Transform.translate(
                        offset: const Offset(-3, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 4),
                          child: Column(
                          children: [
                          _homeMetric(
                            'BATTERY TEMPERATURE',
                            batteryValue,
                            batteryValue == '--' ? '' : '°C',
                            color: const Color(0xFFFFB52E),
                            icon: PhosphorIconsRegular.batteryHigh,
                          ),
                          _homeMetric(
                            'HOTSIDE TEMPERATURE',
                            hotValue,
                            hotValue == '--' ? '' : '°C',
                            color: safety == 'FAULT'
                                ? const Color(0xFFFF5164)
                                : const Color(0xFF22E6DE),
                            icon: PhosphorIconsRegular.thermometer,
                          ),
                          _homeMetric(
                            'VOLTAGE INDICATOR',
                            voltageValue,
                            '',
                            color: const Color(0xFF4D8CFF),
                            icon: PhosphorIconsRegular.lightning,
                          ),
                          _homeMetric(
                            'ADAPTIVE MODE',
                            adaptiveValue,
                            '',
                            color: const Color(0xFFC05BFF),
                            icon: PhosphorIconsRegular.sparkle,
                          ),
                          _homeStateChip(
                            label: 'PELTIER SWITCH',
                            value: peltierOn,
                            icon: PhosphorIconsRegular.snowflake,
                            color: const Color(0xFF18DFFF),
                          ),
                          _homeStateChip(
                            label: 'FAN SWITCH',
                            value: fanOn,
                            icon: PhosphorIconsRegular.fan,
                            color: const Color(0xFF38E3AD),
                          ),
                          _homeFanSpeed(),
                          ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 13,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final imageHeight =
                              (constraints.maxHeight * 0.99).clamp(240.0, 430.0).toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(left: 2, right: 0),
                            child: Image.asset(
                              'assets/jexfyzcooler.png',
                              width: double.infinity,
                              height: imageHeight,
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: _homeNotify(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String title, int index) {

    final selected = tabIndex == index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => tabIndex = index),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF17181C) : const Color(0xFFF2F2F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? const Color(0xFF17181C) : const Color(0xFFE5E5E8),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF5E6068),
                  fontWeight: FontWeight.w900,
                  fontSize: 9,
                  letterSpacing: 0.05,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    const designWidth = 360.0;
    const homeHeight = 420.0;

    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        backgroundColor: const Color(0xFF111113),
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
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(34),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 11),
                                  SizedBox(
                                    height: 42,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        children: [
                                          _tab('VOLTAGE', 0),
                                          _tab('CONTROL', 1),
                                          _tab('ADAPTIVE', 2),
                                          _tab('LED', 3),
                                          _tab('TEMPERATURE', 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 19),
                                    child: Divider(
                                      color: Colors.black12,
                                      thickness: 1.1,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
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

class _ConnectionSheetContent extends StatefulWidget {
  final Future<void> Function() onScan;
  final Future<void> Function(BluetoothDevice device) onConnect;
  final Future<void> Function() onOpenBluetoothSettings;
  final Future<void> Function() onOpenLocationSettings;

  const _ConnectionSheetContent({
    required this.onScan,
    required this.onConnect,
    required this.onOpenBluetoothSettings,
    required this.onOpenLocationSettings,
  });

  @override
  State<_ConnectionSheetContent> createState() => _ConnectionSheetContentState();
}

class _ConnectionSheetContentState extends State<_ConnectionSheetContent> {
  static const MethodChannel _channel = MethodChannel('je_x_fyz/battery_temp');

  Timer? _refreshTimer;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  PermissionStatus _scanPermission = PermissionStatus.denied;
  PermissionStatus _connectPermission = PermissionStatus.denied;
  PermissionStatus _locationPermission = PermissionStatus.denied;
  bool _locationServiceEnabled = false;
  int _androidSdk = 0;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: 650),
      (_) => _refreshStatus(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    if (!Platform.isAndroid) return;
    try {
      final adapter = await FlutterBluePlus.adapterState.first;
      final scan = await Permission.bluetoothScan.status;
      final connect = await Permission.bluetoothConnect.status;
      final location = await Permission.locationWhenInUse.status;
      final sdk = await _getAndroidSdkInt();

      bool locationService = false;
      try {
        locationService = await _channel.invokeMethod<bool>(
              'isLocationServiceEnabled',
            ) ??
            false;
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _adapterState = adapter;
        _scanPermission = scan;
        _connectPermission = connect;
        _locationPermission = location;
        _androidSdk = sdk;
        _locationServiceEnabled = locationService;
      });
    } catch (e) {
      debugPrint('Connection status: $e');
    }
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      return await _channel.invokeMethod<int>('getAndroidSdkInt') ?? 0;
    } catch (e) {
      debugPrint('Android SDK check: $e');
      return 0;
    }
  }

  bool get _bluetoothDenied =>
      !_scanPermission.isGranted || !_connectPermission.isGranted;

  bool get _bluetoothOn =>
      !_bluetoothDenied && _adapterState == BluetoothAdapterState.on;

  bool get _locationDenied =>
      _androidSdk > 0 &&
      _androidSdk <= 30 &&
      !_locationPermission.isGranted;

  bool get _locationOn =>
      _locationServiceEnabled && !_locationDenied;

  Color _statusColor(bool on, bool denied) {
    if (denied) return const Color(0xFFFF6B7A);
    if (on) return const Color(0xFF63E6BE);
    return const Color(0xFFFFB74D);
  }

  Widget _indicator({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF191A22),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withValues(alpha: 0.55),
                width: 1.1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 19, color: color),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tapBluetooth() async {
    if (_bluetoothDenied) {
      await openAppSettings();
    } else {
      await widget.onOpenBluetoothSettings();
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _refreshStatus();
  }

  Future<void> _tapLocation() async {
    if (_locationDenied) {
      await openAppSettings();
    } else {
      await widget.onOpenLocationSettings();
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    final btColor = _statusColor(_bluetoothOn, _bluetoothDenied);
    final locationColor = _statusColor(_locationOn, _locationDenied);
    final locationRequired = _androidSdk > 0 && _androidSdk <= 30;

    return Material(
      color: const Color(0xFF15161E),
      child: Column(
        children: [
          Container(
            height: 66,
            padding: const EdgeInsets.fromLTRB(18, 7, 7, 5),
            decoration: const BoxDecoration(
              color: Color(0xFF1E202B),
              border: Border(
                bottom: BorderSide(color: Color(0x141FFFFFFF)),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 42, height: 42),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    PhosphorIconsRegular.x,
                    color: Colors.white70,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 10),
            child: Row(
              children: [
                _indicator(
                  label: _bluetoothOn ? 'Bluetooth ON' : 'Bluetooth OFF',
                  icon: _bluetoothOn
                      ? PhosphorIconsRegular.bluetooth
                      : PhosphorIconsRegular.bluetoothSlash,
                  color: btColor,
                  onTap: _tapBluetooth,
                ),
                const SizedBox(width: 8),
                _indicator(
                  label: _locationOn ? 'Location ON' : 'Location OFF',
                  icon: _locationOn
                      ? PhosphorIconsRegular.mapPin
                      : PhosphorIconsRegular.mapPin,
                  color: locationColor,
                  onTap: _tapLocation,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 10, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Devices',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 38, height: 38),
                  tooltip: 'Scan',
                  onPressed: widget.onScan,
                  icon: const Icon(
                    PhosphorIconsRegular.arrowClockwise,
                    color: Color(0xFF5C9DFF),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.scanResults,
              initialData: const [],
              builder: (context, snapshot) {
                final filtered = (snapshot.data ?? const <ScanResult>[]).where((r) {
                  final serviceMatch = r.advertisementData.serviceUuids.any(
                    (uuid) => uuid.toString().toLowerCase() == serviceUuid,
                  );
                  final name = r.device.platformName.trim().toLowerCase();
                  final advName = r.advertisementData.advName.trim().toLowerCase();
                  return serviceMatch || name == 'je x fyz' || advName == 'je x fyz';
                }).toList();

                if (filtered.isEmpty) {
                  final unavailable =
                      _bluetoothDenied ||
                      _adapterState != BluetoothAdapterState.on ||
                      (locationRequired && !_locationOn);

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          unavailable
                              ? PhosphorIconsRegular.bluetoothSlash
                              : PhosphorIconsRegular.bluetooth,
                          color: unavailable
                              ? btColor
                              : const Color(0xFF5C9DFF),
                          size: 36,
                        ),
                        const SizedBox(height: 11),
                        Text(
                          unavailable ? 'Connection unavailable.' : 'Scanning...',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 13),
                        FilledButton.icon(
                          onPressed: unavailable ? null : widget.onScan,
                          icon: const Icon(
                            PhosphorIconsRegular.arrowClockwise,
                            size: 18,
                          ),
                          label: const Text('Scan'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Color(0x14FFFFFF), height: 1),
                  itemBuilder: (_, index) {
                    final result = filtered[index];
                    final name = result.device.platformName.isNotEmpty
                        ? result.device.platformName
                        : result.advertisementData.advName;
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        PhosphorIconsRegular.bluetooth,
                        color: Color(0xFF63E6BE),
                      ),
                      title: Text(
                        name.isEmpty ? 'JE X FYZ' : name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onTap: () async {
                        await FlutterBluePlus.stopScan();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        await widget.onConnect(result.device);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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

class FirmwareUpdateDialog extends StatefulWidget {
  final String currentVersion;
  final Future<void> Function(String ssid, String password, String url, String version) onUpdate;

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

  final ssid = TextEditingController();
  final password = TextEditingController();
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _checkGitHub();
  }

  @override
  void dispose() {
    ssid.dispose();
    password.dispose();
    super.dispose();
  }

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

  Future<void> _checkGitHub() async {
    setState(() {
      status = 'CHECKING';
      latestVersion = '';
      firmwareUrl = '';
      updateAvailable = false;
    });

    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(firmwareManifestUrl));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.userAgentHeader, 'JE-Cooler');

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != HttpStatus.ok) {
        throw StateError(
          'GitHub manifest HTTP ' + response.statusCode.toString(),
        );
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map) {
        throw StateError('Invalid GitHub manifest');
      }

      final data = Map<String, dynamic>.from(decoded);
      final version = data['version']?.toString().trim() ?? '';
      final url = data['url']?.toString().trim() ?? '';
      final parsedUrl = Uri.tryParse(url);
      final validUrl = parsedUrl != null &&
          parsedUrl.scheme == 'https' &&
          parsedUrl.host == 'raw.githubusercontent.com' &&
          parsedUrl.path.startsWith('/TenzoNkz/JEXFYZ-Firmware/');

      if (parseFirmwareVersion(version) == null || !validUrl) {
        throw StateError('Invalid firmware manifest');
      }

      if (!mounted) return;
      setState(() {
        latestVersion = version;
        firmwareUrl = url;
        updateAvailable =
            isNewerFirmwareVersion(version, widget.currentVersion);
        status = updateAvailable ? 'UPDATE' : 'UP_TO_DATE';
      });
    } catch (e) {
      debugPrint('GitHub OTA manifest: ' + e.toString());
      if (mounted) setState(() => status = 'FAILED');
    } finally {
      client.close(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E202B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Firmware', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current: ${widget.currentVersion}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            Text('Latest: ${latestVersion.isEmpty ? '--' : latestVersion}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            if (status == 'CHECKING')
              const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            else if (status == 'FAILED')
              const Text('Metadata unavailable.', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))
            else if (!updateAvailable)
              Text(widget.currentVersion == 'V?' ? 'Waiting for device...' : 'Up to date.', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))
            else ...[
              const Text('Update available.', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: ssid,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'SSID', labelStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(PhosphorIconsRegular.wifiHigh, color: Colors.blueAccent)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: password,
                obscureText: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(PhosphorIconsBold.lock, color: Colors.blueAccent)),
              ),
              const SizedBox(height: 6),
              const Text('Saved securely.', style: TextStyle(color: Colors.white38, fontSize: 9)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.grey))),
        if (status == 'FAILED')
          FilledButton(onPressed: _checkGitHub, child: const Text('Retry')),
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
            child: const Text('Update'),
          ),
      ],
    );
  }
}
