/*
  JE X FYZ / JE COOLER
  Horizon Cooler UI base + JE X FYZ V2.8 protocol

  Core rules:
  - Horizon Cooler remains the visual/layout and Android foundation.
  - JE X FYZ V2.8 uses firmware-owned state and an atomic BLE sync/ready handshake.
  - Firebase is READ-ONLY and only queried at firmware_update.
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
import 'package:firebase_database/firebase_database.dart';
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
const String firebaseDbUrl =
    'https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app';
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

  bool _bleReady = false;
  bool _bleSessionReady = false;
  bool _syncReadyAck = false;
  bool connected = false;
  bool syncing = false;
  bool fullSyncReceived = false;
  bool voltageGuardActive = false;
  bool adaptiveTransitioning = false;
  bool batteryReadBusy = false;
  bool fanCommandBusy = false;
  bool peltierCommandBusy = false;
  bool adaptiveCommandBusy = false;
  bool controlCommandBusy = false;
  String controlCommandName = '';
  bool dashboardReady = false;
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
  int rgbMode = 0;
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
  String lastOtaResult = 'NONE';
  int stateSequence = 0;

  int tabIndex = 0;

  DatabaseReference? firmwareDb;
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
    _initFirebase();
    _requestPermissions();
  }

  @override
  void dispose() {
    connectionSub?.cancel();
    notificationSub?.cancel();
    batteryTimer?.cancel();
    voltageGuardTimer?.cancel();
    reconnectTimer?.cancel();
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

  void _initFirebase() {
    try {
      firmwareDb = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: firebaseDbUrl,
      ).ref();
    } catch (e) {
      debugPrint('Firebase database init: $e');
    }
  }

  Future<void> _requestPermissions({bool showResult = false}) async {
    if (!Platform.isAndroid) return;
    try {
      final scan = await Permission.bluetoothScan.request();
      final connect = await Permission.bluetoothConnect.request();
      final location = await Permission.locationWhenInUse.request();

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

      if (showResult && mounted) {
        _showSnackBar(
          'Bluetooth ${scan.isGranted && connect.isGranted && adapter == BluetoothAdapterState.on ? "ON" : "needs permission"} • '
          'Location ${location.isGranted ? "ON" : "needs permission"}',
          color: scan.isGranted && connect.isGranted
              ? Colors.green
              : Colors.orangeAccent,
        );
      }
    } catch (e) {
      debugPrint('Permission setup: $e');
    }
  }

  Future<void> _scanAndConnect() async {
    if (syncing) return;
    await _requestPermissions();
    if (!mounted) return;

    setState(() {
      syncing = true;
      notice = 'Scanning for JE X FYZ...';
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
        await scanSub?.cancel();
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
      _showSnackBar('Bluetooth scan failed.', color: Colors.redAccent);
    } finally {
      await scanSub?.cancel();
      if (mounted && !connected) {
        setState(() => syncing = false);
      }
    }
  }

  Future<void> _connect(BluetoothDevice target) async {
    await connectionSub?.cancel();
    await notificationSub?.cancel();
    batteryTimer?.cancel();
    voltageGuardTimer?.cancel();

    try {
      if (device != null && device != target) {
        await device!.disconnect();
      }
    } catch (_) {}

    device = target;
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
        controlCommandBusy = false;
        controlCommandName = '';
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
        notice = 'Connecting to JE X FYZ...';
      });
    }

    connectionSub = target.connectionState.listen((state) {
      if (state != BluetoothConnectionState.disconnected) return;
      _handleBleDisconnected();
    });

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
    } catch (e) {
      debugPrint('BLE connect/discovery: $e');
      await notificationSub?.cancel();
      notificationSub = null;
      _bleReady = false;
      _bleSessionReady = false;
      if (mounted) {
        setState(() {
          connected = false;
          syncing = false;
          notice = e is StateError ? e.message : 'Bluetooth connection failed';
        });
      }
      try {
        await target.disconnect();
      } catch (_) {}
      rethrow;
    }
  }

  void _handleBleDisconnected() {
    notificationSub?.cancel();
    notificationSub = null;
    _bleReady = false;
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    dashboardReady = false;
    _pendingTelemetry.clear();
    batteryTimer?.cancel();
    for (final waiters in _ackWaiters.values) {
      for (final waiter in waiters) {
        if (!waiter.isCompleted) waiter.complete('DISCONNECTED');
      }
    }
    _ackWaiters.clear();
    if (!mounted) return;
    setState(() {
      connected = false;
      syncing = false;
      dashboardReady = false;
      controlCommandBusy = false;
      controlCommandName = '';
      voltage = '--';
      hotsideTemp = '--';
      phoneBatteryTemp = '--';
      phoneBatteryValid = false;
      safety = 'LOCKED';
      safetyReason = 'DISCONNECTED';
      firmwareVersion = 'V?';
      resetReason = 'UNKNOWN';
      notice = 'Device disconnected.';
    });
  }

  Future<void> _discoverServices(BluetoothDevice target) async {
    BluetoothCharacteristic? discoveredRx;
    BluetoothCharacteristic? discoveredTx;

    for (var discoveryAttempt = 0; discoveryAttempt < 2; discoveryAttempt++) {
      final services = await target.discoverServices();
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

    await discoveredTx.setNotifyValue(true);
    await Future<void>.delayed(const Duration(milliseconds: 220));

    _bleReady = true;

    // V3.2 keeps the V3.1 atomic SYNC -> SYNC_READY protocol. Give the device
    // several opportunities to drain its automatic connect-time sync and then
    // request a clean snapshot ourselves.
    for (var attempt = 0; attempt < 5 && !fullSyncReceived && mounted; attempt++) {
      await sendCommand('SYNC', showError: false);
      final deadline = DateTime.now().add(const Duration(milliseconds: 1200));
      while (mounted && !fullSyncReceived && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 35));
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

    // If encrypted writes require Android bonding on this device, create the
    // bond and retry the handshake exactly once. This is a recovery path only;
    // already-bonded devices do not see another pairing step.
    if ((!_syncReadyAck || !fullSyncReceived || !_bleSessionReady) && Platform.isAndroid) {
      try {
        await target.createBond();
        await Future<void>.delayed(const Duration(milliseconds: 450));
        _syncReadyAck = false;
        fullSyncReceived = false;
        _bleSessionReady = false;
        await sendCommand('SYNC', showError: false);
        final retrySyncDeadline = DateTime.now().add(const Duration(milliseconds: 1500));
        while (mounted && !fullSyncReceived && DateTime.now().isBefore(retrySyncDeadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 35));
        }
        fullSyncReceived = false;
        await sendCommand('SYNC_READY', showError: false);
        final retryReadyDeadline = DateTime.now().add(const Duration(milliseconds: 3000));
        while (mounted &&
            !(_syncReadyAck && fullSyncReceived && _bleSessionReady) &&
            DateTime.now().isBefore(retryReadyDeadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 40));
        }
      } catch (e) {
        debugPrint('BLE bond recovery: $e');
      }
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
      notice = '';
      rgbColorController.text = rgbColor;
      color5Controller.text = color5V;
      color9Controller.text = color9V;
      color12Controller.text = color12V;
    });
    _startBatteryTelemetry();

    if (resetReason != 'POWERON' && resetReason != 'UNKNOWN') {
      _showSnackBar(
        'ESP32 Reset: ${_friendlyReset(resetReason)}',
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

      try {
        final payload = utf8.encode('$command\n');
        final canNoResponse = rx!.properties.writeWithoutResponse;
        final requiresResponse = _requiresResponse(command);
        await rx!.write(
          payload,
          withoutResponse: !requiresResponse && canNoResponse,
        );
        if (!completer.isCompleted) completer.complete(true);
      } catch (e) {
        debugPrint('BLE write $command: $e');

        // V3.2 exposes an encrypted RX characteristic on ESP32 builds that
        // enable BLE security. If Android has not bonded yet, recover once for
        // the session handshake instead of making the user reconnect manually.
        final normalized = command.trim().toUpperCase();
        if (Platform.isAndroid &&
            (normalized == 'SYNC' || normalized == 'SYNC_READY') &&
            device != null) {
          try {
            await device!.createBond();
            await Future<void>.delayed(const Duration(milliseconds: 400));
            await rx!.write(
              payload,
              withoutResponse: !requiresResponse && canNoResponse,
            );
            if (!completer.isCompleted) completer.complete(true);
            return;
          } catch (bondError) {
            debugPrint('BLE bonded write recovery $command: $bondError');
          }
        }

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

    // Hold every field until the final verified sync is complete.
    if (!dashboardReady) {
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
        rgbMode = int.tryParse(value) ?? rgbMode;
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

  bool _beginControlCommand(String name) {
    if (!connected || controlCommandBusy) return false;
    if (mounted) {
      setState(() {
        controlCommandBusy = true;
        controlCommandName = name;
      });
    }
    return true;
  }

  void _endControlCommand() {
    if (!mounted) return;
    setState(() {
      controlCommandBusy = false;
      controlCommandName = '';
    });
  }

  Future<bool> _sendAndConfirm(
    String command,
    bool Function() predicate, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final accepted = await _sendAndWaitAck(
      command,
      showError: false,
      timeout: timeout,
    );
    if (!accepted) return false;

    await Future<void>.delayed(const Duration(milliseconds: 260));

    final synced = await _requestFreshSync(timeout: timeout);
    if (!synced) return false;

    return predicate();
  }

  Future<void> _requestVoltage(String target) async {
    if (!connected ||
        adaptiveOn ||
        voltageGuardActive ||
        controlCommandBusy ||
        !isVoltageCommand(target)) {
      return;
    }
    if (target == voltage) return;
    if (!_beginControlCommand('Voltage')) return;

    try {
      if (mounted) setState(() => voltageGuardActive = true);
    voltageGuardTimer?.cancel();
    voltageGuardTimer = Timer(voltageGuardDuration, () {
      if (mounted) setState(() => voltageGuardActive = false);
    });

    final accepted = await _sendAndConfirm(
      'VOLTAGE:$target',
      () => voltage == target,
      timeout: const Duration(seconds: 3),
    );
      if (!accepted) {
        voltageGuardTimer?.cancel();
        if (mounted) setState(() => voltageGuardActive = false);
      }
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _toggleFan(bool enabled) async {
    if (!connected || adaptiveOn || fanCommandBusy || controlCommandBusy) return;
    if (!_beginControlCommand('Fan')) return;
    if (mounted) setState(() => fanCommandBusy = true);
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'FAN:ON' : 'FAN:OFF',
        () => fanOn == enabled,
      );
      if (!ok && mounted) {
        _showSnackBar('Fan change was not confirmed by the device.', color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) setState(() => fanCommandBusy = false);
      _endControlCommand();
    }
  }

  Future<void> _togglePeltier(bool enabled) async {
    if (!connected || adaptiveOn || peltierCommandBusy || controlCommandBusy) return;
    if (!_beginControlCommand('Peltier')) return;
    if (mounted) setState(() => peltierCommandBusy = true);
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
        final fanOk = await _sendAndConfirm('FAN:ON', () => fanOn);
        if (!fanOk) {
          _showSnackBar('Fan activation was not confirmed by the device.', color: Colors.orangeAccent);
          return;
        }
      }

      final ok = await _sendAndConfirm(
        enabled ? 'PELTIER:ON' : 'PELTIER:OFF',
        () => peltierOn == enabled,
        timeout: const Duration(seconds: 6),
      );
      if (!ok && mounted) {
        _showSnackBar('Peltier change was not confirmed by the device. ${safetyReason == 'NONE' ? '' : safetyReason}', color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) setState(() => peltierCommandBusy = false);
      _endControlCommand();
    }
  }

  Future<void> _toggleAdaptive(bool enabled) async {
    if (!connected ||
        adaptiveTransitioning ||
        adaptiveCommandBusy ||
        controlCommandBusy) {
      return;
    }
    if (!_beginControlCommand('Adaptive Mode')) return;
    if (mounted) setState(() {
      adaptiveTransitioning = true;
      adaptiveCommandBusy = true;
    });
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF',
        () => adaptiveOn == enabled,
        timeout: const Duration(seconds: 4),
      );
      if (!ok && mounted) {
        _showSnackBar('Adaptive Mode change was not confirmed by the device.', color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) {
        setState(() {
          adaptiveCommandBusy = false;
          if (!adaptiveOn) adaptiveTransitioning = false;
        });
      }
      _endControlCommand();
    }
  }

  Future<void> _setRgb(bool enabled) async {
    if (!connected || controlCommandBusy) return;
    if (!_beginControlCommand('LED Power')) return;
    try {
      final ok = await _sendAndConfirm(
        'RGB:' + (enabled ? 'ON' : 'OFF'),
        () => rgbOn == enabled,
      );
      if (!ok && mounted) {
        _showSnackBar('LED power change was not confirmed by the device.');
      }
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _setMode(int mode) async {
    if (!connected || controlCommandBusy) return;
    if (!_beginControlCommand('LED Mode')) return;
    try {
      final next = mode.clamp(0, 7).toInt();
      final ok = await _sendAndConfirm('MODE:$next', () => rgbMode == next);
      if (!ok && mounted) {
        _showSnackBar('LED mode change was not confirmed by the device.');
      }
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _setBrightness(double value) async {
    if (!connected || controlCommandBusy) return;
    if (!_beginControlCommand('LED Brightness')) return;
    try {
      final next = value.round().clamp(0, 100).toInt();
      final ok = await _sendAndConfirm('BRIGHTNESS:$next', () => brightness == next);
      if (!ok && mounted) {
        setState(() => brightnessDraft = brightness);
        _showSnackBar('LED brightness change was not confirmed by the device.');
      }
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _setFanSpeed(double value) async {
    if (!connected || adaptiveOn || voltage != '12V' || controlCommandBusy) return;
    if (!_beginControlCommand('Fan Speed')) return;
    try {
      final next = ((value / 10).round() * 10)
          .clamp(fanSpeedMin, fanSpeedMax)
          .toInt();
      final ok = await _sendAndConfirm('FANSPEED:$next', () => fanSpeed == next);
      if (!ok && mounted) {
        setState(() => fanSpeedDraft = fanSpeed);
        _showSnackBar('Fan speed change was not confirmed by the device.');
      }
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _setHotLimit(int value) async {
    if (!connected || adaptiveOn || controlCommandBusy) return;
    if (!_beginControlCommand('Hotside Limit')) return;
    try {
      final next = value.clamp(40, 50).toInt();
      if (mounted) setState(() => hotLimitDraft = next);
      final ok = await _sendAndConfirm('HOTLIMIT:$next', () => hotLimit == next);
      if (!ok && mounted) setState(() => hotLimitDraft = hotLimit);
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _setBattery5(int value) async {
    if (!connected || adaptiveOn || controlCommandBusy) return;
    if (!_beginControlCommand('Battery 5V Ceiling')) return;
    try {
      final next = value.clamp(20, 48).toInt();
      if (next >= battery12Limit - 1) return;
      if (mounted) setState(() => battery5Draft = next);
      final ok = await _sendAndConfirm('BATT5:$next', () => battery5Limit == next);
      if (!ok && mounted) setState(() => battery5Draft = battery5Limit);
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _setBattery12(int value) async {
    if (!connected || adaptiveOn || controlCommandBusy) return;
    if (!_beginControlCommand('Battery 12V Floor')) return;
    try {
      final next = value.clamp(22, 50).toInt();
      if (next <= battery5Limit + 1) return;
      if (mounted) setState(() => battery12Draft = next);
      final ok = await _sendAndConfirm('BATT12:$next', () => battery12Limit == next);
      if (!ok && mounted) setState(() => battery12Draft = battery12Limit);
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _sendColor(String command, TextEditingController controller) async {
    final value = controller.text.trim().toUpperCase();
    if (!isValidHexColor(value)) {
      _showSnackBar('Enter a valid hex color in #RRGGBB format.');
      return;
    }
    if (!connected || controlCommandBusy) return;
    if (!_beginControlCommand('LED Color')) return;
    try {
      final ok = await _sendAndWaitAck(
        command + ':' + value.substring(1),
        showError: false,
      );
      if (!ok && mounted) {
        _showSnackBar('Color change was not confirmed by the device.');
      }
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _resetTemperatureSettings() async {
    if (!connected || adaptiveOn || controlCommandBusy) return;
    if (!_beginControlCommand('Reset Temperature')) return;
    try {
      final ok = await _sendAndWaitAck('RESET:TEMPERATURE', showError: false);
      if (!ok && mounted) _showSnackBar('Temperature reset was not confirmed by the device.');
    } finally {
      _endControlCommand();
    }
  }

  Future<void> _resetVoltageColors() async {
    if (!connected || controlCommandBusy) return;
    if (!_beginControlCommand('Reset Voltage Colors')) return;
    try {
      final ok = await _sendAndWaitAck('RESET:VOLTAGECOLORS', showError: false);
      if (!ok && mounted) _showSnackBar('Voltage color reset was not confirmed by the device.');
    } finally {
      _endControlCommand();
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
        dbRef: firmwareDb,
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
      'OTA dimulai. BLE akan terputus saat Wi-Fi OTA berjalan.',
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
      case 'NTC_ERROR': return 'Temperature sensor validation failed.';
      case 'HOTSIDE_PROTECTION': return 'Hotside protection is active. Peltier output is temporarily disabled.';
      case 'FAN_REQUIRED': return 'Fan must be running before Peltier can be enabled.';
      case 'PELTIER_ON': return 'Fan control is locked while Peltier is active.';
      case 'ADAPTIVE_ACTIVE': return 'Manual cooling controls are locked while Adaptive Mode is active.';
      case 'MANUAL_12V_ONLY': return 'Fan speed control is available only in manual 12V mode.';
      case 'VOLTAGE_GUARD_OR_BUSY': return 'Voltage control is busy. Awaiting device confirmation.';
      case 'SYNC_REQUIRED': return 'Device synchronization is still in progress.';
      case 'RATE_LIMIT': return 'Command rate limited. Awaiting device confirmation.';
      case 'MUST_BE_BELOW_BATT12': return 'The 5V battery threshold must remain below the 12V threshold.';
      case 'MUST_BE_ABOVE_BATT5': return 'The 12V battery threshold must remain above the 5V threshold.';
      default: return reason.replaceAll('_', ' ').toLowerCase();
    }
  }

  void _showSnackBar(String message, {Color color = Colors.blueAccent}) {
    if (!mounted || message.trim().isEmpty) return;
    setState(() => notice = message.trim());
  }

  void _showBluetoothMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF15161E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.67,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 10, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E202B),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Bluetooth • JE X FYZ',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(PhosphorIconsBold.x, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.scanResults,
                  initialData: const [],
                  builder: (context, snapshot) {
                    final results = snapshot.data ?? [];
                    final filtered = results.where((r) {
                      final serviceMatch = r.advertisementData.serviceUuids.any(
                        (uuid) => uuid.toString().toLowerCase() == serviceUuid,
                      );
                      final name = r.device.platformName.trim().toLowerCase();
                      return serviceMatch || name == 'je x fyz';
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(PhosphorIconsRegular.bluetooth, color: Colors.blueAccent, size: 34),
                            const SizedBox(height: 12),
                            const Text('Scanning for JE X FYZ...', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: _startScanFromSheet,
                              icon: const Icon(PhosphorIconsBold.arrowClockwise),
                              label: const Text('SCAN AGAIN'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final result = filtered[index];
                        final name = result.device.platformName.isNotEmpty
                            ? result.device.platformName
                            : result.advertisementData.advName;
                        return ListTile(
                          leading: const Icon(PhosphorIconsBold.bluetooth, color: Colors.blueAccent),
                          title: Text(name.isEmpty ? 'JE X FYZ' : name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(result.device.remoteId.toString(), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          onTap: () {
                            Navigator.pop(context);
                            _connect(result.device);
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
      },
    ).whenComplete(() => FlutterBluePlus.stopScan());
    _startScanFromSheet();
  }

  Future<void> _startScanFromSheet() async {
    await _requestPermissions();
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
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 76),
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 7),
        decoration: BoxDecoration(
          color: const Color(0x0EFFFFFF),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.22)),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const Spacer(),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 7.3,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.55,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              display,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                height: 0.95,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeStateChip({
    required String label,
    required bool value,
    required IconData icon,
  }) {
    final active = value;
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: active ? const Color(0x1A54E3FF) : const Color(0x0BFFFFFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? const Color(0x6654E3FF) : const Color(0x14FFFFFF),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: active ? const Color(0x1454E3FF) : const Color(0x0AFFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 17,
                color: active ? Colors.cyanAccent : Colors.white38,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 7.4,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    active ? 'ON' : 'OFF',
                    style: TextStyle(
                      color: active ? Colors.cyanAccent : Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? Colors.cyanAccent : Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeFanSpeed() {
    final enabled = connected && voltage == '12V' && !adaptiveOn;
    final progress = (fanSpeed.clamp(fanSpeedMin, fanSpeedMax) - fanSpeedMin) /
        (fanSpeedMax - fanSpeedMin);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0x0EFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(PhosphorIconsBold.gauge, size: 15, color: Colors.white54),
              const SizedBox(width: 7),
              const Text(
                'FAN SPEED',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 7.6,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.75,
                ),
              ),
              const Spacer(),
              Text(
                '$fanSpeed%',
                style: TextStyle(
                  color: enabled ? Colors.white : Colors.white38,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.toDouble(),
              minHeight: 5,
              backgroundColor: const Color(0x15FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(
                enabled ? Colors.cyanAccent : Colors.white24,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              enabled ? 'MANUAL 12V' : 'NOT AVAILABLE',
              style: const TextStyle(
                color: Colors.white30,
                fontSize: 6.7,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.65,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _professionalNotice() {
    final custom = notice.trim();
    if (custom.isNotEmpty) return custom;

    switch (safetyReason) {
      case 'WAITING_FOR_NTC':
      case 'WAITING_FOR_SENSOR_VALIDATION':
        return 'Validating temperature sensors...';
      case 'NTC_ERROR':
        return 'Temperature sensor validation failed. Cooling is locked for safety.';
      case 'HOTSIDE_PROTECTION':
        return 'Hotside protection is active. Peltier output is temporarily disabled.';
      case 'FAN_REQUIRED':
        return 'Fan must be running before Peltier can be enabled.';
      case 'PELTIER_ON':
        return 'Fan control is locked while Peltier is active.';
      case 'ADAPTIVE_ACTIVE':
        return 'Manual cooling controls are locked while Adaptive Mode is active.';
      case 'MANUAL_12V_ONLY':
        return 'Fan speed control is available only in manual 12V mode.';
      case 'VOLTAGE_GUARD_OR_BUSY':
        return 'Voltage control is busy. Awaiting device confirmation.';
      case 'RATE_LIMIT':
        return 'Command rate limited. Awaiting device confirmation.';
      case 'DISCONNECTED':
        return 'Bluetooth is disconnected. Connect to continue.';
      case 'NONE':
        return 'System ready. Device state is synchronized.';
      default:
        return _friendlyReason(safetyReason);
    }
  }

  Widget _homeNotify() {
    final alert = safety != 'OK' &&
        safetyReason != 'NONE' &&
        safetyReason != 'WAITING_FOR_NTC' &&
        safetyReason != 'WAITING_FOR_SENSOR_VALIDATION';
    final icon = alert
        ? PhosphorIconsBold.warning
        : PhosphorIconsBold.shieldCheck;
    final color = alert ? Colors.orangeAccent : Colors.greenAccent;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: alert ? 0.10 : 0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert ? 'SYSTEM ALERT' : 'SYSTEM STATUS',
                  style: TextStyle(
                    color: color,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _professionalNotice(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x12FFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              connected ? 'ONLINE' : 'OFFLINE',
              style: TextStyle(
                color: connected ? Colors.cyanAccent : Colors.white38,
                fontSize: 6.7,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeArea(double height) {
    final batteryValue = connected && phoneBatteryValid ? phoneBatteryTemp : '--';
    final hotValue = connected ? hotsideTemp : '--';
    final voltageValue = connected && voltage != '--' ? voltage : '--';
    final adaptiveValue = connected ? (adaptiveOn ? 'ON' : 'OFF') : '--';

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 44,
                  child: IconButton(
                    tooltip: connected ? 'Disconnect' : 'Bluetooth',
                    icon: Icon(
                      connected
                          ? PhosphorIconsBold.bluetoothConnected
                          : PhosphorIconsBold.bluetooth,
                      color: connected ? Colors.blueAccent : Colors.white,
                      size: 25,
                    ),
                    onPressed: connected ? _disconnect : _showBluetoothMenu,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        headerName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
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
                          color: Colors.white30,
                          fontWeight: FontWeight.w700,
                          fontSize: 6.8,
                          letterSpacing: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x0FFFFFFF),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: const Color(0x14FFFFFF)),
                  ),
                  child: Icon(
                    connected ? PhosphorIconsBold.checkCircle : PhosphorIconsBold.linkBreak,
                    color: connected ? Colors.greenAccent : Colors.white38,
                    size: 17,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    tooltip: 'Firmware',
                    icon: const Icon(
                      PhosphorIconsBold.gear,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: _openFirmwareSettings,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 5),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _homeMetric(
                                  'BATTERY TEMPERATURE',
                                  batteryValue,
                                  batteryValue == '--' ? '' : '°C',
                                  color: Colors.orangeAccent,
                                  icon: PhosphorIconsBold.batteryHigh,
                                ),
                                const SizedBox(width: 6),
                                _homeMetric(
                                  'HOTSIDE TEMPERATURE',
                                  hotValue,
                                  hotValue == '--' ? '' : '°C',
                                  color: safety == 'FAULT'
                                      ? Colors.redAccent
                                      : Colors.cyanAccent,
                                  icon: PhosphorIconsBold.thermometer,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Row(
                              children: [
                                _homeMetric(
                                  'VOLTAGE INDICATOR',
                                  voltageValue,
                                  '',
                                  color: Colors.blueAccent,
                                  icon: PhosphorIconsBold.lightning,
                                ),
                                const SizedBox(width: 6),
                                _homeMetric(
                                  'ADAPTIVE MODE',
                                  adaptiveValue,
                                  '',
                                  color: adaptiveOn ? Colors.greenAccent : Colors.white70,
                                  icon: PhosphorIconsBold.sparkle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _homeStateChip(
                                label: 'PELTIER',
                                value: peltierOn,
                                icon: PhosphorIconsBold.snowflake,
                              ),
                              const SizedBox(width: 6),
                              _homeStateChip(
                                label: 'FAN',
                                value: fanOn,
                                icon: PhosphorIconsBold.wind,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _homeFanSpeed(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final imageHeight =
                              (constraints.maxHeight * 0.98).clamp(195.0, 290.0).toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(left: 3, right: 0),
                            child: Image.asset(
                              'assets/jexfyzcooler.png',
                              height: imageHeight,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            _homeNotify(),
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
    final homeHeight =
        (media.size.height * 0.45).clamp(335.0, 465.0).toDouble();

    if (syncing && !dashboardReady) {
      return _buildSyncGate();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111113),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHomeArea(homeHeight),
            Expanded(
              child: Container(
                width: double.infinity,
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
                      height: 46,
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
    );
  }

  Widget _buildSyncGate() {
    final status =
        notice.trim().isEmpty ? 'Synchronizing with JE X FYZ...' : notice.trim();

    return Scaffold(
      backgroundColor: const Color(0xFF111113),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  PhosphorIconsBold.arrowsClockwise,
                  color: Colors.blueAccent,
                  size: 46,
                ),
                const SizedBox(height: 20),
                const Text(
                  headerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reading the complete device state before showing the dashboard.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x0FFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x18FFFFFF),
                    ),
                  ),
                  child: const Text(
                    'SYNC IN PROGRESS • CONTROLS LOCKED',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
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
  final DatabaseReference? dbRef;
  final Future<void> Function(String ssid, String password, String url, String version) onUpdate;

  const FirmwareUpdateDialog({
    super.key,
    required this.currentVersion,
    required this.dbRef,
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
    _checkFirebase();
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

  Future<void> _checkFirebase() async {
    setState(() {
      status = 'CHECKING';
      latestVersion = '';
      firmwareUrl = '';
      updateAvailable = false;
    });

    if (widget.dbRef == null) {
      if (mounted) setState(() => status = 'FAILED');
      return;
    }

    try {
      final snapshot = await widget.dbRef!.child('firmware_update').get();
      if (!snapshot.exists || snapshot.value is! Map) {
        throw StateError('Missing firmware_update');
      }
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final version = data['version']?.toString().trim() ?? '';
      final url = data['url']?.toString().trim() ?? '';
      if (parseFirmwareVersion(version) == null || !url.startsWith('https://')) {
        throw StateError('Invalid firmware metadata');
      }
      if (!mounted) return;
      setState(() {
        latestVersion = version;
        firmwareUrl = url;
        updateAvailable = isNewerFirmwareVersion(version, widget.currentVersion);
        status = updateAvailable ? 'UPDATE' : 'UP_TO_DATE';
      });
    } catch (e) {
      debugPrint('Firebase OTA metadata: $e');
      if (mounted) setState(() => status = 'FAILED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E202B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Firmware Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              const Text('Firmware metadata unavailable.', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))
            else if (!updateAvailable)
              Text(widget.currentVersion == 'V?' ? 'Waiting for device version...' : 'System is up to date.', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))
            else ...[
              const Text('New firmware available.', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: ssid,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Wi-Fi SSID', labelStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(PhosphorIconsRegular.wifiHigh, color: Colors.blueAccent)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: password,
                obscureText: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Wi-Fi Password', labelStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(PhosphorIconsBold.lock, color: Colors.blueAccent)),
              ),
              const SizedBox(height: 6),
              const Text('Wi-Fi credentials are stored in Android secure storage.', style: TextStyle(color: Colors.white38, fontSize: 9)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CLOSE', style: TextStyle(color: Colors.grey))),
        if (status == 'FAILED')
          FilledButton(onPressed: _checkFirebase, child: const Text('RETRY')),
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
            child: const Text('UPDATE FIRMWARE'),
          ),
      ],
    );
  }
}
