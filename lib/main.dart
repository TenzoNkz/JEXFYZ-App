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
  StreamSubscription<BondState>? bondStateSub;

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
    bondStateSub?.cancel();
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
        notice = Platform.isAndroid ? 'Connecting & securing JE X FYZ...' : 'Connecting to JE X FYZ...';
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

      // Firmware protects RX with encrypted writes. On Android, complete the
      // BLE bond before service discovery/handshake so the first SYNC write
      // cannot race the security manager. Already-bonded devices continue
      // without showing another pairing prompt.
      if (Platform.isAndroid) {
        final bonded = await _ensureBleBond(target);
        if (!bonded) {
          throw StateError('Bluetooth pairing was not completed');
        }
      }

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

  Future<bool> _ensureBleBond(BluetoothDevice target) async {
    if (!Platform.isAndroid) return true;

    BondState? current;
    try {
      current = await target.bondState.first.timeout(
        const Duration(seconds: 2),
      );
      if (current == BondState.bonded) {
        return true;
      }
    } catch (e) {
      debugPrint('BLE bond state read: $e');
    }

    await bondStateSub?.cancel();
    bondStateSub = null;

    final completer = Completer<bool>();
    bondStateSub = target.bondState.listen((state) {
      if (state == BondState.bonded) {
        if (!completer.isCompleted) completer.complete(true);
      }
    });
    target.cancelWhenDisconnected(bondStateSub!);

    try {
      // Force the Android system pairing dialog now instead of waiting for the
      // first encrypted GATT write to trigger it mid-handshake. If Android is
      // already in the bonding state, simply wait for the existing operation.
      if (current != BondState.bonding) {
        await target.createBond();
      }

      final bonded = await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => false,
      );
      return bonded;
    } catch (e) {
      debugPrint('BLE createBond: $e');
      return false;
    } finally {
      await bondStateSub?.cancel();
      bondStateSub = null;
    }
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

      final payload = utf8.encode('$command\n');

      try {
        // One authenticated write path for every command. The firmware RX
        // characteristic requires encryption, so do not fall back to
        // WRITE_NO_RESPONSE here.
        await rx!.write(payload, withoutResponse: false);
        if (!completer.isCompleted) completer.complete(true);
      } catch (e) {
        debugPrint('BLE secure write $command: $e');
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 37;
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 6 : 8,
              vertical: compact ? 2 : 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0x0EFFFFFF),
              borderRadius: BorderRadius.circular(compact ? 11 : 13),
              border: Border.all(color: const Color(0x14FFFFFF)),
            ),
            child: Row(
              children: [
                Container(
                  width: compact ? 22 : 27,
                  height: compact ? 22 : 27,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(compact ? 7 : 8),
                    border: Border.all(color: color.withValues(alpha: 0.22)),
                  ),
                  child: Icon(icon, size: compact ? 12 : 15, color: color),
                ),
                SizedBox(width: compact ? 6 : 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: compact ? 6.0 : 6.7,
                          fontWeight: FontWeight.w900,
                          letterSpacing: compact ? 0.45 : 0.55,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: compact ? 0 : 1),
                      Text(
                        display,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: compact ? 13.0 : 15.0,
                          fontWeight: FontWeight.w900,
                          height: 0.95,
                          letterSpacing: -0.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          );
        },
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 36;
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 6 : 8,
              vertical: compact ? 2 : 4,
            ),
            decoration: BoxDecoration(
              color: active ? const Color(0x1A54E3FF) : const Color(0x0BFFFFFF),
              borderRadius: BorderRadius.circular(compact ? 11 : 13),
              border: Border.all(
                color: active ? const Color(0x6654E3FF) : const Color(0x14FFFFFF),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: compact ? 21 : 25,
                  height: compact ? 21 : 25,
                  decoration: BoxDecoration(
                    color: active ? const Color(0x1454E3FF) : const Color(0x0AFFFFFF),
                    borderRadius: BorderRadius.circular(compact ? 7 : 8),
                  ),
                  child: Icon(
                    icon,
                    size: compact ? 12 : 14,
                    color: active ? Colors.cyanAccent : Colors.white38,
                  ),
                ),
                SizedBox(width: compact ? 6 : 7),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: compact ? 6.1 : 6.8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.75,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        active ? 'ON' : 'OFF',
                        style: TextStyle(
                          color: active ? Colors.cyanAccent : Colors.white60,
                          fontSize: compact ? 9.8 : 11.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? Colors.cyanAccent : Colors.white24,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _homeFanSpeed() {
    final enabled = connected && voltage == '12V' && !adaptiveOn;
    final progress = (fanSpeed.clamp(fanSpeedMin, fanSpeedMax) - fanSpeedMin) /
        (fanSpeedMax - fanSpeedMin);

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 42;
          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              compact ? 7 : 9,
              compact ? 3 : 5,
              compact ? 7 : 9,
              compact ? 3 : 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0x0EFFFFFF),
              borderRadius: BorderRadius.circular(compact ? 11 : 13),
              border: Border.all(color: const Color(0x14FFFFFF)),
            ),
            child: compact
                ? Row(
                    children: [
                      const Icon(
                        PhosphorIconsBold.gauge,
                        size: 14,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'FAN SPEED',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 6.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress.toDouble(),
                            minHeight: 3,
                            backgroundColor: const Color(0x15FFFFFF),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              enabled ? Colors.cyanAccent : Colors.white24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '$fanSpeed%',
                        style: TextStyle(
                          color: enabled ? Colors.white : Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            PhosphorIconsBold.gauge,
                            size: 14,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            'FAN SPEED',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 7.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.75,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$fanSpeed%',
                            style: TextStyle(
                              color: enabled ? Colors.white : Colors.white38,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress.toDouble(),
                          minHeight: 4,
                          backgroundColor: const Color(0x15FFFFFF),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            enabled ? Colors.cyanAccent : Colors.white24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          enabled ? 'MANUAL 12V' : 'NOT AVAILABLE',
                          style: const TextStyle(
                            color: Colors.white30,
                            fontSize: 5.9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
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

    return SizedBox(
      height: 42,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: alert ? 0.10 : 0.07),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 7),
            Text(
              alert ? 'ALERT' : 'STATUS',
              style: TextStyle(
                color: color,
                fontSize: 6.8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.95,
              ),
            ),
            const SizedBox(width: 7),
            const Text(
              '•',
              style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _professionalNotice(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 7),
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
                  fontSize: 6.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
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
    final disabled = !connected || adaptiveOn || voltageGuardActive || adaptiveTransitioning;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: disabled ? null : () => _requestVoltage(target),
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(15),
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
          'Voltage Control',
          subtitle: adaptiveOn ? 'Adaptive is controlling the voltage.' : '5V / 9V / 12V manual selector.',
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
            child: Text('Voltage guard active — awaiting device confirmation.', style: TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        _card(
          child: Row(
            children: [
              const Icon(PhosphorIconsBold.lightning, size: 19, color: Colors.blueAccent),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  connected ? 'Firmware state: ${voltage == '--' ? 'syncing...' : voltage}' : 'Connect to control voltage.',
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
    final speedEnabled = connected && !adaptiveOn && voltage == '12V' && !controlCommandBusy;
    final fanLocked = connected && !adaptiveOn && peltierOn;
    return KeyedSubtree(key: key, child: _smoothList(
      storageKey: 'control',
      children: [
        _sectionTitle('Cooling Control', subtitle: 'Manage the cooling fan, Peltier, and fan speed.'),
        _card(
          padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
          child: Column(
            children: [
              _switchRow(
                title: 'Fan',
                subtitle: fanLocked ? 'Fan is ON • locked while Peltier is ON' : (fanOn ? 'Fan is ON' : 'Fan is OFF'),
                icon: PhosphorIconsBold.wind,
                value: fanOn,
                enabled: connected && !adaptiveOn && !peltierOn && !controlCommandBusy,
                onChanged: _toggleFan,
              ),
              const Divider(height: 20),
              _switchRow(
                title: 'Peltier',
                subtitle: peltierOn ? 'Peltier is ON • 5 s soft-start' : 'Peltier is OFF',
                icon: PhosphorIconsBold.snowflake,
                value: peltierOn,
                enabled: connected && !adaptiveOn && !controlCommandBusy,
                onChanged: _togglePeltier,
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(PhosphorIconsBold.gauge, size: 20, color: Colors.black45),
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
        _sectionTitle('Adaptive Control', subtitle: 'Firmware-owned automatic voltage policy.'),
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
                    Text('Hotside and phone battery temperature control', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Switch(
                value: connected && adaptiveOn,
                activeThumbColor: Colors.green,
                onChanged: connected && !adaptiveTransitioning && !controlCommandBusy ? _toggleAdaptive : null,
              ),
            ],
          ),
        ),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Adaptive policy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
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
                    adaptiveTransitioning ? 'Adaptive transition in progress — awaiting device confirmation.' : 'Adaptive state: ${adaptiveOn ? 'ON' : 'OFF'}',
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
          child: const Text('SET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildLedTab({Key? key}) {
    final modeName = <String>['Static', 'Breath', 'Wipe', 'Running', 'Scan', 'Theater', 'Rainbow', 'Twinkle'][rgbMode.clamp(0, 7)];
    return KeyedSubtree(key: key, child: _smoothList(
      storageKey: 'led',
      children: [
        _sectionTitle('LED Control', subtitle: '8× WS2812B • firmware-managed lighting and effects.'),
        _card(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              _switchRow(
                title: 'LED Power',
                subtitle: rgbOn ? 'Lighting is ON' : 'Lighting is OFF',
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
                      onChanged: connected && !controlCommandBusy ? (v) => setState(() => brightness = v.round()) : null,
                      onChangeEnd: connected && !controlCommandBusy ? _setBrightness : null,
                    ),
                  ),
                  SizedBox(width: 42, child: Text('$brightness%', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900))),
                ],
              ),
            ],
          ),
        ),
        _sectionTitle('Custom RGB Color'),
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
          FilledButton(onPressed: connected ? () => _sendColor('COLOR', rgbColorController) : null, child: const Text('SET')),
        ])),
        _sectionTitle('Voltage Indicator Colors', subtitle: 'Shown briefly after a confirmed voltage change.'),
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
        _sectionTitle('Thermal Protection', subtitle: locked ? 'Locked while Adaptive is ON.' : 'Sensor readings remain independent from the protection threshold.'),
        _card(
          child: _adjuster(
            title: 'Hotside Overheat Limit',
            value: hotLimitDraft,
            min: 40,
            max: 50,
            onChanged: (v) {
              if (!connected || locked) return;
              _setHotLimit(v);
            },
          ),
        ),
        _sectionTitle('Phone Battery Temperature Zones', subtitle: '9V uses the calculated middle zone.'),
        _card(
          padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
          child: Column(
            children: [
              _adjuster(
                title: '5V Zone Ceiling',
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
                title: '12V Zone Floor',
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
              Expanded(child: Text('Temperature settings are locked while Adaptive Mode is active.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
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
    final content = switch (tabIndex) {
      0 => _buildVoltageTab(key: const ValueKey('voltage-tab')),
      1 => _buildControlTab(key: const ValueKey('control-tab')),
      2 => _buildAdaptiveTab(key: const ValueKey('adaptive-tab')),
      3 => _buildLedTab(key: const ValueKey('led-tab')),
      4 => _buildTemperatureTab(key: const ValueKey('temperature-tab')),
      _ => const SizedBox.shrink(),
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        content,
        if (controlCommandBusy) ...[
          const Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: ColoredBox(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: 2,
            left: 10,
            right: 10,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF17181C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PROCESSING: ' +
                      controlCommandName +
                      ' • awaiting device confirmation...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
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
            SizedBox(
              height: 39,
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: connected ? 'Disconnect' : 'Bluetooth',
                      icon: Icon(
                        connected
                            ? PhosphorIconsBold.bluetoothConnected
                            : PhosphorIconsBold.bluetooth,
                        color: connected ? Colors.blueAccent : Colors.white,
                        size: 24,
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
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: 'Firmware',
                      icon: const Icon(
                        PhosphorIconsBold.gear,
                        color: Colors.white,
                        size: 21,
                      ),
                      onPressed: _openFirmwareSettings,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, right: 6),
                      child: Column(
                        children: [
                          _homeMetric(
                            'BATTERY TEMPERATURE',
                            batteryValue,
                            batteryValue == '--' ? '' : '°C',
                            color: Colors.orangeAccent,
                            icon: PhosphorIconsBold.batteryHigh,
                          ),
                          const SizedBox(height: 4),
                          _homeMetric(
                            'HOTSIDE TEMPERATURE',
                            hotValue,
                            hotValue == '--' ? '' : '°C',
                            color: safety == 'FAULT'
                                ? Colors.redAccent
                                : Colors.cyanAccent,
                            icon: PhosphorIconsBold.thermometer,
                          ),
                          const SizedBox(height: 4),
                          _homeMetric(
                            'VOLTAGE INDICATOR',
                            voltageValue,
                            '',
                            color: Colors.blueAccent,
                            icon: PhosphorIconsBold.lightning,
                          ),
                          const SizedBox(height: 4),
                          _homeMetric(
                            'ADAPTIVE MODE',
                            adaptiveValue,
                            '',
                            color: adaptiveOn ? Colors.greenAccent : Colors.white70,
                            icon: PhosphorIconsBold.sparkle,
                          ),
                          const SizedBox(height: 4),
                          _homeStateChip(
                            label: 'PELTIER',
                            value: peltierOn,
                            icon: PhosphorIconsBold.snowflake,
                          ),
                          const SizedBox(height: 4),
                          _homeStateChip(
                            label: 'FAN',
                            value: fanOn,
                            icon: PhosphorIconsBold.wind,
                          ),
                          const SizedBox(height: 4),
                          _homeFanSpeed(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final height = constraints.maxHeight;
                        return Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/jexfyzcooler.png',
                            width: width,
                            height: height,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
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
        (media.size.height * 0.48).clamp(370.0, 520.0).toDouble();

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
