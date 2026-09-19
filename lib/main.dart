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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

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
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init: $e');
  }
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  runApp(const JeCoolerApp());
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
  final Map<String, List<Completer<String>>> _ackWaiters = {};
  final Map<String, String> _syncSnapshot = {};

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
          adapter = await FlutterBluePlus.adapterState.first;
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

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      found = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
      await FlutterBluePlus.stopScan();

      if (found == null) {
        _showSnackBar('JE X FYZ tidak ditemukan.', color: Colors.orangeAccent);
        return;
      }

      await _connect(found);
    } catch (e) {
      debugPrint('BLE scan: $e');
      _showSnackBar('Bluetooth scan gagal.', color: Colors.redAccent);
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

    if (mounted) {
      setState(() {
        syncing = true;
        connected = false;
        notice = 'Connecting...';
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
        timeout: const Duration(seconds: 12),
        mtu: 247,
      );

      if (Platform.isAndroid) {
        try {
          await target.requestMtu(247);
        } catch (_) {}
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
      voltage = '--';
      hotsideTemp = '--';
      phoneBatteryTemp = '--';
      phoneBatteryValid = false;
      safety = 'LOCKED';
      safetyReason = 'DISCONNECTED';
      firmwareVersion = 'V?';
      resetReason = 'UNKNOWN';
      notice = 'Disconnected';
    });
  }

  Future<void> _discoverServices(BluetoothDevice target) async {
    final services = await target.discoverServices();
    BluetoothCharacteristic? discoveredRx;
    BluetoothCharacteristic? discoveredTx;

    for (final service in services) {
      if (service.uuid.toString().toLowerCase() != serviceUuid) continue;
      for (final characteristic in service.characteristics) {
        final id = characteristic.uuid.toString().toLowerCase();
        if (id == rxUuid) discoveredRx = characteristic;
        if (id == txUuid) discoveredTx = characteristic;
      }
    }

    if (discoveredRx == null || discoveredTx == null) {
      _showSnackBar('UUID JE X FYZ tidak cocok.', color: Colors.redAccent);
      await target.disconnect();
      return;
    }

    rx = discoveredRx;
    tx = discoveredTx;

    // Register the notification listener BEFORE enabling notifications.
    // Otherwise Android can deliver the first automatic Full Sync before the
    // Dart listener exists, producing partial/delayed UI state.
    await notificationSub?.cancel();
    notificationSub = discoveredTx.lastValueStream.listen((bytes) {
      if (bytes.isNotEmpty) {
        _parseIncoming(utf8.decode(bytes, allowMalformed: true));
      }
    });
    await discoveredTx.setNotifyValue(true);
    await Future<void>.delayed(const Duration(milliseconds: 120));

    _bleReady = true;

    // Phase 1: get the current hardware state. The UI stays disconnected while
    // this happens, so no partial/stale state is ever shown.
    for (var attempt = 0; attempt < 4 && !fullSyncReceived && mounted; attempt++) {
      await sendCommand('SYNC', showError: false);
      final deadline = DateTime.now().add(const Duration(milliseconds: 1500));
      while (mounted && !fullSyncReceived && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
    }

    if (!fullSyncReceived) {
      throw StateError('Full Sync failed');
    }

    // Phase 2: open the firmware command gate. V2.8 responds with a fresh
    // Full Sync and then ACKs SYNC_READY. The UI still stays hidden.
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    final readyAccepted = await sendCommand('SYNC_READY', showError: false);
    if (!readyAccepted) {
      throw StateError('BLE session handshake write failed');
    }

    final readyDeadline = DateTime.now().add(const Duration(milliseconds: 3000));
    while (mounted &&
        !(_syncReadyAck && fullSyncReceived && _bleSessionReady) &&
        DateTime.now().isBefore(readyDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!_syncReadyAck || !fullSyncReceived || !_bleSessionReady) {
      throw StateError('BLE session not ready');
    }

    // Now the command gate is open, so the phone battery temperature can be
    // sent to the firmware without being rejected. We then request one final
    // Full Sync so the dashboard's first visible snapshot contains every value
    // from the same firmware state, including BATTERY.
    await _readBatteryTemperatureOnce(updateUi: false);
    fullSyncReceived = false;
    await sendCommand('SYNC', showError: false);
    final finalSyncDeadline = DateTime.now().add(const Duration(milliseconds: 2000));
    while (mounted &&
        !fullSyncReceived &&
        DateTime.now().isBefore(finalSyncDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!fullSyncReceived) {
      throw StateError('Final Full Sync failed');
    }

    if (!mounted) return;
    setState(() {
      connected = true;
      syncing = false;
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
          _showSnackBar('Bluetooth belum siap.', color: Colors.orangeAccent);
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
    if (!mounted || values.isEmpty) return;
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

  Future<bool> _sendAndConfirm(
    String command,
    bool Function() predicate, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final accepted = await _sendAndWaitAck(command, showError: false, timeout: timeout);
    if (!accepted) return false;
    return _waitUntil(predicate, timeout: timeout);
  }

  Future<void> _requestVoltage(String target) async {
    if (!connected || adaptiveOn || voltageGuardActive || !isVoltageCommand(target)) return;
    if (target == voltage) return;

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
  }

  Future<void> _toggleFan(bool enabled) async {
    if (!connected || adaptiveOn || fanCommandBusy) return;
    if (mounted) setState(() => fanCommandBusy = true);
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'FAN:ON' : 'FAN:OFF',
        () => fanOn == enabled,
      );
      if (!ok && mounted) {
        _showSnackBar('Fan command tidak dikonfirmasi firmware.', color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) setState(() => fanCommandBusy = false);
    }
  }

  Future<void> _togglePeltier(bool enabled) async {
    if (!connected || adaptiveOn || peltierCommandBusy) return;
    if (mounted) setState(() => peltierCommandBusy = true);
    try {
      if (enabled && !fanOn) {
        final approved = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Peltier Safety'),
            content: const Text('Fan harus ON agar Peltier dapat dijalankan.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('BATAL')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('NYALAKAN FAN')),
            ],
          ),
        );
        if (approved != true) return;
        final fanOk = await _sendAndConfirm('FAN:ON', () => fanOn);
        if (!fanOk) {
          _showSnackBar('Fan belum terkonfirmasi ON.', color: Colors.orangeAccent);
          return;
        }
      }

      final ok = await _sendAndConfirm(
        enabled ? 'PELTIER:ON' : 'PELTIER:OFF',
        () => peltierOn == enabled,
        timeout: const Duration(seconds: 6),
      );
      if (!ok && mounted) {
        _showSnackBar('Peltier command tidak dikonfirmasi firmware. ${safetyReason == 'NONE' ? '' : safetyReason}', color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) setState(() => peltierCommandBusy = false);
    }
  }

  Future<void> _toggleAdaptive(bool enabled) async {
    if (!connected || adaptiveTransitioning || adaptiveCommandBusy) return;
    if (mounted) setState(() { adaptiveTransitioning = true; adaptiveCommandBusy = true; });
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF',
        () => adaptiveOn == enabled,
        timeout: const Duration(seconds: 4),
      );
      if (!ok && mounted) {
        _showSnackBar('Adaptive command tidak dikonfirmasi firmware.', color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) setState(() { adaptiveCommandBusy = false; if (!adaptiveOn) adaptiveTransitioning = false; });
    }
  }

  Future<void> _setRgb(bool enabled) async {
    if (!connected) return;
    final ok = await _sendAndConfirm('RGB:${enabled ? 'ON' : 'OFF'}', () => rgbOn == enabled);
    if (!ok && mounted) _showSnackBar('LED command tidak dikonfirmasi firmware.', color: Colors.orangeAccent);
  }

  Future<void> _setMode(int mode) async {
    if (!connected) return;
    final next = mode.clamp(0, 7).toInt();
    final ok = await _sendAndConfirm('MODE:$next', () => rgbMode == next);
    if (!ok && mounted) _showSnackBar('Mode LED tidak dikonfirmasi firmware.', color: Colors.orangeAccent);
  }

  Future<void> _setBrightness(double value) async {
    if (!connected) return;
    final next = value.round().clamp(0, 100).toInt();
    final ok = await _sendAndConfirm('BRIGHTNESS:$next', () => brightness == next);
    if (!ok && mounted) {
      setState(() => brightnessDraft = brightness);
      _showSnackBar('Brightness tidak dikonfirmasi firmware.', color: Colors.orangeAccent);
    }
  }

  Future<void> _setFanSpeed(double value) async {
    if (!connected || adaptiveOn || voltage != '12V') return;
    final next = ((value / 10).round() * 10).clamp(fanSpeedMin, fanSpeedMax).toInt();
    final ok = await _sendAndConfirm('FANSPEED:$next', () => fanSpeed == next);
    if (!ok && mounted) {
      setState(() => fanSpeedDraft = fanSpeed);
      _showSnackBar('Fan Speed tidak dikonfirmasi firmware.', color: Colors.orangeAccent);
    }
  }

  Future<void> _setHotLimit(int value) async {
    if (!connected || adaptiveOn) return;
    final next = value.clamp(40, 50).toInt();
    if (mounted) setState(() => hotLimitDraft = next);
    final ok = await _sendAndConfirm('HOTLIMIT:$next', () => hotLimit == next);
    if (!ok && mounted) setState(() => hotLimitDraft = hotLimit);
  }

  Future<void> _setBattery5(int value) async {
    if (!connected || adaptiveOn) return;
    final next = value.clamp(20, 48).toInt();
    if (next >= battery12Limit - 1) return;
    if (mounted) setState(() => battery5Draft = next);
    final ok = await _sendAndConfirm('BATT5:$next', () => battery5Limit == next);
    if (!ok && mounted) setState(() => battery5Draft = battery5Limit);
  }

  Future<void> _setBattery12(int value) async {
    if (!connected || adaptiveOn) return;
    final next = value.clamp(22, 50).toInt();
    if (next <= battery5Limit + 1) return;
    if (mounted) setState(() => battery12Draft = next);
    final ok = await _sendAndConfirm('BATT12:$next', () => battery12Limit == next);
    if (!ok && mounted) setState(() => battery12Draft = battery12Limit);
  }

  Future<void> _sendColor(String command, TextEditingController controller) async {
    final value = controller.text.trim().toUpperCase();
    if (!isValidHexColor(value)) {
      _showSnackBar('Format warna harus #RRGGBB.', color: Colors.orangeAccent);
      return;
    }
    if (!connected) return;
    final ok = await _sendAndWaitAck('$command:${value.substring(1)}', showError: false);
    if (!ok && mounted) _showSnackBar('Perubahan warna ditolak firmware.', color: Colors.orangeAccent);
  }

  Future<void> _resetTemperatureSettings() async {
    if (!connected || adaptiveOn) return;
    final ok = await _sendAndWaitAck('RESET:TEMPERATURE', showError: false);
    if (!ok && mounted) _showSnackBar('Reset temperature ditolak firmware.', color: Colors.orangeAccent);
  }

  Future<void> _resetVoltageColors() async {
    if (!connected) return;
    final ok = await _sendAndWaitAck('RESET:VOLTAGECOLORS', showError: false);
    if (!ok && mounted) _showSnackBar('Reset warna ditolak firmware.', color: Colors.orangeAccent);
  }

  Future<bool> _requestFreshSync({Duration timeout = const Duration(seconds: 3)}) async {
    fullSyncReceived = false;
    final sent = await sendCommand('SYNC', showError: false);
    if (!sent) return false;
    return _waitUntil(() => fullSyncReceived, timeout: timeout);
  }

  Future<void> _openFirmwareSettings() async {
    if (!connected) {
      _showSnackBar('Connect ke JE X FYZ terlebih dahulu.', color: Colors.orangeAccent);
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
          'OTA gagal dimulai: command ${_ackItemForCommand(command) ?? command} ditolak firmware.',
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
      case 'NTC_ERROR': return 'NTC belum valid';
      case 'HOTSIDE_PROTECTION': return 'Hotside protection aktif';
      case 'FAN_REQUIRED': return 'Fan harus ON';
      case 'ADAPTIVE_ACTIVE': return 'Control terkunci saat Adaptive ON';
      case 'MANUAL_12V_ONLY': return 'Fan Speed hanya tersedia pada Manual 12V';
      case 'VOLTAGE_GUARD_OR_BUSY': return 'Voltage guard/busy aktif';
      case 'SYNC_REQUIRED': return 'BLE session belum selesai sinkronisasi';
      case 'MUST_BE_BELOW_BATT12': return 'BATT5 harus di bawah BATT12';
      case 'MUST_BE_ABOVE_BATT5': return 'BATT12 harus di atas BATT5';
      default: return reason;
    }
  }

  void _showSnackBar(String message, {Color color = Colors.blueAccent}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
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
                      icon: const Icon(Icons.close, color: Colors.white70),
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
                            const Icon(Icons.bluetooth_searching, color: Colors.blueAccent, size: 34),
                            const SizedBox(height: 12),
                            const Text('Scanning for JE X FYZ...', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: _startScanFromSheet,
                              icon: const Icon(Icons.refresh),
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
                          leading: const Icon(Icons.bluetooth, color: Colors.blueAccent),
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
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      debugPrint('start scan sheet: $e');
    }
  }

  Widget _homeMetric(
    String label,
    String value,
    String unit, {
    required Color color,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: color.withValues(alpha: 0.90)),
            const SizedBox(width: 7),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.16),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Text(
                          value,
                          key: ValueKey<String>('$label:$value'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 0.98,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    if (unit.isNotEmpty && value != '--')
                      Padding(
                        padding: const EdgeInsets.only(left: 3, bottom: 2),
                        child: Text(
                          unit,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.35,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: active ? const Color(0x1E54E3FF) : const Color(0x0FFFFFFF),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: active ? const Color(0x8054E3FF) : const Color(0x16FFFFFF),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: active ? Colors.cyanAccent : Colors.white38),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                active ? 'ON' : 'OFF',
                key: ValueKey<bool>(active),
                style: TextStyle(
                  color: active ? Colors.cyanAccent : Colors.white.withValues(alpha: 0.45),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeNotify() {
    final message = notice.trim().isNotEmpty
        ? notice.trim()
        : (safetyReason == 'NONE' ? 'System ready' : safetyReason);
    final alert = safety != 'OK' && safetyReason != 'NONE';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: alert ? const Color(0x18FFB34D) : const Color(0x0EFFFFFF),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: alert ? const Color(0x40FFB34D) : const Color(0x12FFFFFF),
        ),
      ),
      child: Row(
        children: [
          Icon(
            alert ? Icons.warning_amber_rounded : Icons.notifications_none_rounded,
            size: 13,
            color: alert ? Colors.orangeAccent : Colors.white38,
          ),
          const SizedBox(width: 5),
          const Text(
            'NOTIFY',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                message,
                key: ValueKey<String>(message),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: alert ? Colors.orangeAccent : Colors.white60,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                ),
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                active ? Icons.check_circle : Icons.radio_button_unchecked,
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
              _voltageRow('5V', 'Low Mode'),
              _voltageRow('9V', 'Mid Mode'),
              _voltageRow('12V', 'High Mode'),
            ],
          ),
        ),
        if (voltageGuardActive)
          const Padding(
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text('Voltage guard aktif — tunggu 1 detik.', style: TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        _card(
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded, size: 19, color: Colors.blueAccent),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  connected ? 'Firmware state: ${voltage == '--' ? 'syncing...' : voltage}' : 'Connect untuk mengontrol voltage.',
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
        _sectionTitle('Cooling Control', subtitle: 'Fan, Peltier and PWM are grouped here.'),
        _card(
          padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
          child: Column(
            children: [
              _switchRow(
                title: 'Fan',
                subtitle: fanLocked ? 'Fan is ON • locked while Peltier is ON' : (fanOn ? 'Fan is ON' : 'Fan is OFF'),
                icon: Icons.air_rounded,
                value: fanOn,
                enabled: connected && !adaptiveOn && !peltierOn,
                onChanged: _toggleFan,
              ),
              const Divider(height: 20),
              _switchRow(
                title: 'Peltier',
                subtitle: peltierOn ? 'Peltier is ON • soft-start 5s' : 'Peltier is OFF',
                icon: Icons.ac_unit_rounded,
                value: peltierOn,
                enabled: connected && !adaptiveOn,
                onChanged: _togglePeltier,
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(Icons.speed_rounded, size: 20, color: Colors.black45),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fan Speed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                        SizedBox(height: 3),
                        Text('Manual 12V only • 50–100% • 25 kHz PWM', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600)),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 170),
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: adaptiveOn ? Colors.green.withValues(alpha: 0.13) : Colors.black.withValues(alpha: 0.06),
                ),
                child: Icon(adaptiveOn ? Icons.shield_rounded : Icons.shield_outlined, color: adaptiveOn ? Colors.green.shade700 : Colors.black45),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adaptive Switch', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                    SizedBox(height: 4),
                    Text('Hotside + phone battery zone', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Switch(
                value: connected && adaptiveOn,
                activeThumbColor: Colors.green,
                onChanged: connected && !adaptiveTransitioning ? _toggleAdaptive : null,
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
              const Icon(Icons.info_outline_rounded, size: 18, color: Colors.blueAccent),
              const SizedBox(width: 9),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    adaptiveTransitioning ? 'Adaptive transition in progress — waiting for confirmed state.' : 'Adaptive state: ${adaptiveOn ? 'ON' : 'OFF'}',
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE4E4E6))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.black45, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
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
        _sectionTitle('LED Control', subtitle: '8× WS2812B • firmware-owned color/effect state.'),
        _card(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              _switchRow(
                title: 'LED Power',
                subtitle: rgbOn ? 'RGB illumination is ON' : 'RGB illumination is OFF',
                icon: Icons.lightbulb_rounded,
                value: rgbOn,
                enabled: connected,
                onChanged: _setRgb,
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: connected ? () => _setMode(rgbMode - 1) : null, icon: const Icon(Icons.chevron_left_rounded, size: 28)),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 138,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFE4E4E6))),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 170),
                      child: Text('Mode $rgbMode • $modeName', key: ValueKey<int>(rgbMode), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                    ),
                  ),
                  IconButton(onPressed: connected ? () => _setMode(rgbMode + 1) : null, icon: const Icon(Icons.chevron_right_rounded, size: 28)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.brightness_low_rounded, color: Colors.black38, size: 20),
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
        _sectionTitle('Voltage Indicator Colors', subtitle: 'Shown briefly after a completed voltage transition.'),
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
              icon: const Icon(Icons.restart_alt_rounded, size: 17),
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
        IconButton(onPressed: value <= min ? null : () => onChanged(value - 1), icon: const Icon(Icons.remove_circle_outline_rounded)),
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 66,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFE3E3E5))),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: Text('$value$unit', key: ValueKey<String>('$value$unit'), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.blueAccent)),
          ),
        ),
        IconButton(onPressed: value >= max ? null : () => onChanged(value + 1), icon: const Icon(Icons.add_circle_outline_rounded)),
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
        _sectionTitle('Temperature Protection', subtitle: locked ? 'Locked while Adaptive is ON.' : 'Sensor display remains independent from the protection threshold.'),
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
        _sectionTitle('Phone Battery Temperature Zones', subtitle: '9V is the derived middle zone.'),
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
                  Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 150), child: Text('≈ $midLow–$midHigh°C', key: ValueKey<String>('$midLow:$midHigh'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)))),
                  const Icon(Icons.lock_outline, color: Colors.black26),
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
              Icon(Icons.lock_rounded, size: 18, color: Colors.orangeAccent),
              SizedBox(width: 9),
              Expanded(child: Text('Temperature settings are locked while Adaptive Mode is ON.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
            ]),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: connected && !locked ? _resetTemperatureSettings : null,
            icon: const Icon(Icons.restart_alt_rounded, size: 17),
            label: const Text('Reset Temperature'),
          ),
        ),
      ],
    ));
  }

  Widget _buildTabContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: switch (tabIndex) {
        0 => _buildVoltageTab(key: const ValueKey('voltage-tab')),
        1 => _buildControlTab(key: const ValueKey('control-tab')),
        2 => _buildAdaptiveTab(key: const ValueKey('adaptive-tab')),
        3 => _buildLedTab(key: const ValueKey('led-tab')),
        4 => _buildTemperatureTab(key: const ValueKey('temperature-tab')),
        _ => const SizedBox.shrink(key: ValueKey('empty-tab')),
      },
    );
  }

  Widget _buildHomeArea(double height) {
    final batteryValue = connected && phoneBatteryValid ? phoneBatteryTemp : '--';
    final hotValue = connected ? hotsideTemp : '--';
    final voltageValue = connected && voltage != '--' ? voltage.replaceAll('V', '') : '--';
    final adaptiveValue = connected ? (adaptiveOn ? 'ON' : 'OFF') : '--';

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 46,
                  child: IconButton(
                    tooltip: connected ? 'Disconnect' : 'Bluetooth',
                    icon: Icon(connected ? Icons.bluetooth_connected : Icons.bluetooth, color: connected ? Colors.blueAccent : Colors.white, size: 26),
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
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19, letterSpacing: 0.2),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'DEVELOPED BY HORIZON',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w700, fontSize: 7.5, letterSpacing: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 46,
                  child: IconButton(
                    tooltip: 'Firmware',
                    icon: const Icon(Icons.settings, color: Colors.white, size: 25),
                    onPressed: _openFirmwareSettings,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: LayoutBuilder(
                      builder: (context, leftConstraints) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 9, right: 5, top: 2, bottom: 2),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: leftConstraints.maxWidth - 14,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                          _homeMetric('BATTERY TEMPERATURE', batteryValue, '°C', color: Colors.orangeAccent, icon: Icons.battery_std_rounded),
                          _homeMetric('HOTSIDE TEMPERATURE', hotValue, hotValue != '--' ? '°C' : '', color: safety == 'FAULT' ? Colors.redAccent : Colors.cyanAccent, icon: Icons.device_thermostat_rounded),
                          _homeMetric('VOLTAGE INDICATOR', voltageValue, voltageValue != '--' ? 'V' : '', color: Colors.blueAccent, icon: Icons.bolt_rounded),
                          _homeMetric('ADAPTIVE MODE', adaptiveValue, '', color: adaptiveOn ? Colors.greenAccent : Colors.white70, icon: Icons.auto_awesome_rounded),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              _homeStateChip(label: 'PELTIER', value: peltierOn, icon: Icons.ac_unit_rounded),
                              const SizedBox(width: 6),
                              _homeStateChip(label: 'FAN', value: fanOn, icon: Icons.air_rounded),
                            ],
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0x0FFFFFFF),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: const Color(0x12FFFFFF)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.speed_rounded, size: 13, color: Colors.white38),
                                const SizedBox(width: 5),
                                const Text('FAN SPEED', style: TextStyle(color: Colors.white38, fontSize: 7.5, fontWeight: FontWeight.w900, letterSpacing: 0.6)),
                                const Spacer(),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 160),
                                  child: Text(
                                    '$fanSpeed%',
                                    key: ValueKey<int>(fanSpeed),
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),
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
                          ),
                        ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Align(
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final imageHeight = (constraints.maxHeight * 0.95).clamp(185.0, 275.0).toDouble();
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: imageHeight,
                              maxWidth: constraints.maxWidth,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2, right: 0, top: 2),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.asset('assets/jexfyzcooler.png', height: imageHeight),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String title, int index) {
    final selected = tabIndex == index;
    return AnimatedScale(
      scale: selected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOutCubic,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 190),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF17181C) : const Color(0xFFF2F2F4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? const Color(0xFF17181C) : const Color(0xFFE5E5E8)),
            boxShadow: selected
                ? const [BoxShadow(color: Color(0x13000000), blurRadius: 8, offset: Offset(0, 3))]
                : const [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF5E6068),
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final homeHeight = (media.size.height * 0.42).clamp(315.0, 430.0).toDouble();

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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 11),
                    SizedBox(
                      height: 50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                      child: Divider(color: Colors.black12, thickness: 1.1, height: 1),
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
                decoration: const InputDecoration(labelText: 'Wi-Fi SSID', labelStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(Icons.wifi, color: Colors.blueAccent)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: password,
                obscureText: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Wi-Fi Password', labelStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(Icons.lock, color: Colors.blueAccent)),
              ),
              const SizedBox(height: 6),
              const Text('Password disimpan di Android secure storage.', style: TextStyle(color: Colors.white38, fontSize: 9)),
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
