import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

const String appName = 'JE Cooler';
const String headerName = 'JE X FYZ';
const String firmwareVersionText = 'Telegram @horizontalzzz';
const String serviceUuid =
    '6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001';
const String rxUuid =
    '6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001';
const String txUuid =
    '6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001';
const String firebaseDbUrl =
    'https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app';
const Duration voltageGuard = Duration(seconds: 1);

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
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF111113),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

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
  StreamSubscription<List<int>>? txSub;
  Timer? batteryTimer;
  bool _batteryReadBusy = false;
  Timer? voltageTimer;
  bool voltageCommandLocked = false;
  bool adaptiveModeTransitioning = false;
  Timer? otaReconnectTimer;
  Future<void> _writeQueue = Future<void>.value();

  bool connected = false;
  bool syncing = false;
  bool batteryAvailable = false;
  double? phoneBatteryTemp;
  double? hotsideTemp;
  String voltage = '--';
  bool fanOn = false;
  bool peltierOn = false;
  bool adaptiveOn = false;
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
  String lastOtaResult = 'NONE';
  String resetReason = 'UNKNOWN';
  String firmwareVersion = 'V?';
  String otaState = 'IDLE';
  String notifyReason = '';
  String adaptiveCeiling = '12V';

  final PageController pageController = PageController();
  int menuIndex = 0;
  String rxBuffer = '';
  bool fullSyncDone = false;
  bool fullCommandSetSent = false;

  static const List<String> menuNames = [
    'VOLTAGE',
    'ADAPTIVE',
    'LED',
    'TEMPERATURE',
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _startBatteryReader();
  }

  @override
  void dispose() {
    connectionSub?.cancel();
    txSub?.cancel();
    batteryTimer?.cancel();
    voltageTimer?.cancel();
    otaReconnectTimer?.cancel();
    pageController.dispose();
    device?.disconnect();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();
    }
  }

  void _startBatteryReader() {
    _readBatteryTemperature();
    batteryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _readBatteryTemperature();
    });
  }

  Future<void> _readBatteryTemperature() async {
    if (_batteryReadBusy) return;
    _batteryReadBusy = true;

    try {
      final result = await batteryChannel.invokeMethod<dynamic>(
        'getBatteryTemperature',
      );
      final value = result is num ? result.toDouble() : -1.0;
      final valid = value >= 0 && value <= 100;

      if (!mounted) return;

      setState(() {
        batteryAvailable = valid;
        phoneBatteryTemp = valid ? value : null;
      });

      if (connected && valid) {
        await _sendRaw(
          'PHONE:BT=${value.toStringAsFixed(1)}',
        );
      }
    } catch (e) {
      debugPrint('Battery temperature: $e');
    } finally {
      _batteryReadBusy = false;
    }
  }

  Future<void> _scanAndConnect() async {
    await _requestPermissions();
    if (!mounted) return;

    setState(() => syncing = true);

    BluetoothDevice? found;
    StreamSubscription<List<ScanResult>>? scanSub;

    try {
      await FlutterBluePlus.stopScan();

      final completer = Completer<BluetoothDevice?>();

      scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final serviceMatch =
              result.advertisementData.serviceUuids.any(
            (u) => u.toString().toLowerCase() ==
                serviceUuid.toLowerCase(),
          );
          final name =
              result.advertisementData.advName.toLowerCase();

          if (serviceMatch || name == 'je x fyz') {
            if (!completer.isCompleted) {
              completer.complete(result.device);
            }
            break;
          }
        }
      });

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
      );

      found = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );

      await FlutterBluePlus.stopScan();

      if (found == null) {
        _showReason('JE X FYZ tidak ditemukan.');
        return;
      }

      await _connect(found);
    } catch (e) {
      _showReason('Bluetooth scan/connect gagal.');
      debugPrint('BLE scan: $e');
    } finally {
      await scanSub?.cancel();
      if (mounted) setState(() => syncing = false);
    }
  }

  Future<void> _disconnect() async {
    try {
      await device?.disconnect();
    } catch (e) {
      debugPrint('BLE disconnect: $e');
    }
  }

  Future<void> _connect(BluetoothDevice target) async {
    await connectionSub?.cancel();
    await txSub?.cancel();

    try {
      if (device != null && device != target) {
        await device!.disconnect();
      }
    } catch (_) {}

    device = target;
    rx = null;
    tx = null;
    connected = false;
    syncing = true;
    fullSyncDone = false;
    fullCommandSetSent = false;
    rxBuffer = '';

    connectionSub = target.connectionState.listen((state) async {
      if (!mounted) return;

      if (state == BluetoothConnectionState.connected) {
        try {
          if (Platform.isAndroid) {
            try {
              await target.createBond();
            } catch (_) {}

            try {
              await target.requestMtu(247);
            } catch (_) {}
          }

          await _discover(target);
        } catch (e) {
          debugPrint('BLE discovery: $e');
        }
      } else if (state == BluetoothConnectionState.disconnected) {
        await txSub?.cancel();
        txSub = null;

        if (!mounted) return;

        setState(() {
          connected = false;
          syncing = false;
          rx = null;
          tx = null;
          hotsideTemp = null;
          voltage = '--';
          batteryAvailable = false;
          phoneBatteryTemp = null;
          safety = 'LOCKED';
          safetyReason = 'DISCONNECTED';
          voltageCommandLocked = false;
          adaptiveModeTransitioning = false;
        });
      }
    });

    await target.connect(
      license: License.nonprofit,
      timeout: const Duration(seconds: 12),
      autoConnect: false,
      mtu: 247,
    );
  }

  Future<void> _discover(BluetoothDevice target) async {
    final services = await target.discoverServices();

    BluetoothCharacteristic? foundRx;
    BluetoothCharacteristic? foundTx;

    for (final service in services) {
      if (service.uuid.toString().toLowerCase() !=
          serviceUuid.toLowerCase()) {
        continue;
      }

      for (final characteristic in service.characteristics) {
        final id = characteristic.uuid.toString().toLowerCase();
        if (id == rxUuid.toLowerCase()) foundRx = characteristic;
        if (id == txUuid.toLowerCase()) foundTx = characteristic;
      }
    }

    if (foundRx == null || foundTx == null) {
      _showReason('BLE UUID JE X FYZ tidak cocok.');
      await target.disconnect();
      return;
    }

    rx = foundRx;
    tx = foundTx;

    await foundTx.setNotifyValue(true);
    await txSub?.cancel();

    txSub = foundTx.lastValueStream.listen(_parseIncomingBytes);

    await _sendRaw('SYNC');

    final deadline = DateTime.now().add(const Duration(seconds: 3));

    while (
        mounted &&
        !fullSyncDone &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(
        const Duration(milliseconds: 50),
      );
    }

    if (!fullSyncDone) {
      _showReason('Full Sync gagal.');
      if (mounted) setState(() => syncing = false);
      return;
    }

    await _sendFullCommandSet();

    if (!mounted) return;

    setState(() {
      connected = true;
      syncing = false;
      fullCommandSetSent = true;
    });

    await _readBatteryTemperature();
  }

  Future<void> _sendFullCommandSet() async {
    final commands = <String>[
      'VOLTAGE:$voltage',
      fanOn ? 'FAN:ON' : 'FAN:OFF',
      peltierOn ? 'PELTIER:ON' : 'PELTIER:OFF',
      adaptiveOn ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF',
      rgbOn ? 'RGB:ON' : 'RGB:OFF',
      'MODE:$rgbMode',
      'BRIGHTNESS:$brightness',
      'COLOR:$rgbColor',
      'V5COLOR:$color5V',
      'V9COLOR:$color9V',
      'V12COLOR:$color12V',
      'FANSPEED:$fanSpeed',
      'HOTLIMIT:$hotLimit',
      'BATT5:$battery5Limit',
      'BATT12:$battery12Limit',
    ];

    for (final command in commands) {
      await _sendRaw(command);
      await Future<void>.delayed(
        const Duration(milliseconds: 20),
      );
    }

    if (batteryAvailable && phoneBatteryTemp != null) {
      await _sendRaw(
        'PHONE:BT=${phoneBatteryTemp!.toStringAsFixed(1)}',
      );
    }
  }

  Future<void> _sendRaw(String command) {
    _writeQueue = _writeQueue.then((_) async {
      final characteristic = rx;

      if (!connected &&
          command != 'SYNC' &&
          characteristic == null) {
        return;
      }

      if (characteristic == null) return;

      try {
        await characteristic.write(
          utf8.encode('$command\n'),
          withoutResponse: false,
        );
      } catch (e) {
        debugPrint('BLE write $command: $e');
      }
    });

    return _writeQueue;
  }

  void _parseIncomingBytes(List<int> bytes) {
    rxBuffer += utf8.decode(
      bytes,
      allowMalformed: true,
    );

    if (rxBuffer.length > 8192) {
      final index = rxBuffer.lastIndexOf('<SYNC_START>');
      rxBuffer = index >= 0
          ? rxBuffer.substring(index)
          : '';
    }

    while (rxBuffer.contains('\n')) {
      final nl = rxBuffer.indexOf('\n');
      final line = rxBuffer.substring(0, nl).trim();
      rxBuffer = rxBuffer.substring(nl + 1);

      if (line.isEmpty) continue;
      _parseLine(line);
    }
  }

  void _parseLine(String line) {
    if (line == '<SYNC_START>') {
      fullSyncDone = false;
      return;
    }

    if (line == '<SYNC_END>') {
      fullSyncDone = true;
      return;
    }

    if (line.startsWith('ACK:')) {
      final parts = line.substring(4).split(';');
      String reason = 'UNKNOWN';

      for (final part in parts.skip(1)) {
        if (part.startsWith('REASON=')) {
          reason = part.substring(7);
        }
      }

      if (reason != 'OK' &&
          reason != 'ACCEPTED' &&
          reason != 'STARTING') {
        _showReason(reason);
      }

      return;
    }

    final sep = line.indexOf(':');
    if (sep <= 0) return;

    final key = line.substring(0, sep).trim();
    final value = line.substring(sep + 1).trim();

    _applyField(key, value);
  }

  void _applyField(String key, String value) {
    if (!mounted) return;

    setState(() {
      switch (key) {
        case 'VERSION':
          firmwareVersion = value;
          break;

        case 'VOLTAGE':
          voltage = value;
          if (adaptiveModeTransitioning && value == '5V') {
            adaptiveModeTransitioning = false;
          }
          break;

        case 'FAN':
          fanOn = value == 'ON';
          break;

        case 'PELTIER':
          peltierOn = value == 'ON';
          break;

        case 'HOT':
          hotsideTemp = double.tryParse(value);
          break;

        case 'BATTERY':
          phoneBatteryTemp = double.tryParse(value);
          batteryAvailable = phoneBatteryTemp != null;
          break;

        case 'BATTERY_VALID':
          batteryAvailable = value == '1';
          if (!batteryAvailable) phoneBatteryTemp = null;
          break;

        case 'ADAPTIVE':
          adaptiveOn = value == 'ON';
          if (adaptiveOn) {
            adaptiveModeTransitioning = voltage != '5V';
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
          brightness = int.tryParse(value) ?? brightness;
          break;

        case 'RGB_COLOR':
          rgbColor = value;
          break;

        case 'COLOR_5V':
          color5V = value;
          break;

        case 'COLOR_9V':
          color9V = value;
          break;

        case 'COLOR_12V':
          color12V = value;
          break;

        case 'FAN_SPEED':
          fanSpeed = int.tryParse(value) ?? fanSpeed;
          break;

        case 'SAFETY':
          safety = value;
          break;

        case 'SAFETY_REASON':
          safetyReason = value;
          if (value != 'NONE') notifyReason = value;
          break;

        case 'LAST_OTA_RESULT':
          lastOtaResult = value;
          break;

        case 'RESET_REASON':
          resetReason = value;
          break;

        case 'TEMP_HOT_LIMIT':
          hotLimit = int.tryParse(value) ?? hotLimit;
          break;

        case 'BATT_5':
          battery5Limit = int.tryParse(value) ?? battery5Limit;
          break;

        case 'BATT_12':
          battery12Limit = int.tryParse(value) ?? battery12Limit;
          break;

        case 'OTA_STATE':
          otaState = value;
          break;

        case 'NTC_MV':
          break;
      }
    });
  }

  Future<void> _changeVoltage(String target) async {
    if (!connected ||
        adaptiveOn ||
        adaptiveModeTransitioning ||
        voltageCommandLocked ||
        voltage == target) {
      return;
    }

    setState(() => voltageCommandLocked = true);

    voltageTimer?.cancel();
    voltageTimer = Timer(voltageGuard, () {
      if (!mounted) return;
      setState(() => voltageCommandLocked = false);
    });

    await _sendRaw('VOLTAGE:$target');
  }

  Future<void> _toggleFan(bool value) async {
    if (!connected || adaptiveOn) return;
    if (peltierOn && !value) return;

    await _sendRaw(
      value ? 'FAN:ON' : 'FAN:OFF',
    );
  }

  Future<void> _togglePeltier(bool value) async {
    if (!connected || adaptiveOn) return;

    if (!value) {
      await _sendRaw('PELTIER:OFF');
      return;
    }

    if (!fanOn) {
      final approved = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Perhatian'),
          content: const Text(
            'Pastikan kipas sudah terpasang.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('BELUM'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (approved != true) return;

      await _sendRaw('FAN:ON');
    }

    await _sendRaw('PELTIER:ON');
  }

  Future<void> _toggleAdaptive(bool value) async {
    if (!connected || adaptiveModeTransitioning) return;

    setState(() => adaptiveModeTransitioning = true);
    await _sendRaw(
      value ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF',
    );
  }

  Future<void> _toggleRgb(bool value) async {
    if (!connected) return;

    await _sendRaw(
      value ? 'RGB:ON' : 'RGB:OFF',
    );
  }

  Future<void> _setMode(int mode) async {
    if (!connected) return;
    await _sendRaw('MODE:$mode');
  }

  Future<void> _setBrightness(int value) async {
    if (!connected) return;

    final clamped = value.clamp(0, 100);
    await _sendRaw('BRIGHTNESS:$clamped');
  }

  Future<void> _setFanSpeed(int value) async {
    if (!connected ||
        adaptiveOn ||
        voltage != '12V') {
      return;
    }

    final clamped = (value / 10).round() * 10;
    await _sendRaw('FANSPEED:$clamped');
  }

  Future<void> _setHotLimit(int value) async {
    if (!connected || adaptiveOn) return;

    await _sendRaw(
      'HOTLIMIT:${value.clamp(40, 50)}',
    );
  }

  Future<void> _setBattery5(int value) async {
    if (!connected || adaptiveOn) return;

    await _sendRaw(
      'BATT5:${value.clamp(20, 48)}',
    );
  }

  Future<void> _setBattery12(int value) async {
    if (!connected || adaptiveOn) return;

    await _sendRaw(
      'BATT12:${value.clamp(22, 50)}',
    );
  }

  Future<void> _setCustomColor(String color) async {
    if (!connected) return;
    rgbColor = color;
    setState(() {});
    await _sendRaw('COLOR:$color');
  }

  Future<void> _setVoltageColor(String voltageKey, String color) async {
    if (!connected) return;

    setState(() {
      switch (voltageKey) {
        case '5V':
          color5V = color;
          break;
        case '9V':
          color9V = color;
          break;
        case '12V':
          color12V = color;
          break;
      }
    });

    final command = switch (voltageKey) {
      '5V' => 'V5COLOR',
      '9V' => 'V9COLOR',
      '12V' => 'V12COLOR',
      _ => '',
    };

    if (command.isEmpty) return;

    await _sendRaw('$command:$color');
  }

  Future<void> _resetVoltageColors() async {
    const defaults = <String, String>{
      '5V': '#FF0000',
      '9V': '#00FF00',
      '12V': '#0000FF',
    };

    setState(() {
      color5V = defaults['5V']!;
      color9V = defaults['9V']!;
      color12V = defaults['12V']!;
    });

    if (!connected) return;

    await _sendRaw('V5COLOR:#FF0000');
    await _sendRaw('V9COLOR:#00FF00');
    await _sendRaw('V12COLOR:#0000FF');

    _showReason('Voltage LED colors reset.');
  }

  Future<void> _resetTemperatureSettings() async {
    setState(() {
      hotLimit = 45;
      battery5Limit = 25;
      battery12Limit = 35;
    });

    if (!connected) {
      _showReason('Temperature settings reset locally.');
      return;
    }

    await _sendRaw('HOTLIMIT:45');
    await _sendRaw('BATT5:25');
    await _sendRaw('BATT12:35');

    _showReason('Temperature settings reset.');
  }

  Future<void> _firmwareDialog() async {
    if (!connected) {
      _showReason('Connect to JE X FYZ first.');
      return;
    }

    try {
      final snapshot = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: firebaseDbUrl,
      ).ref('firmware_update').get();

      final data = snapshot.value is Map
          ? Map<String, dynamic>.from(snapshot.value as Map)
          : <String, dynamic>{};

      final latest = (data['version'] ?? '').toString();
      final url = (data['url'] ?? '').toString();

      final canUpdate =
          _versionCompare(latest, firmwareVersion) > 0 &&
          url.startsWith('https://');

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => _OtaDialog(
          currentVersion: firmwareVersion,
          latestVersion: latest,
          canUpdate: canUpdate,
          onStart: (ssid, password) async {
            Navigator.pop(context);
            await _startOnlineOta(
              ssid: ssid,
              password: password,
              url: url,
              version: latest,
            );
          },
        ),
      );
    } catch (e) {
      _showReason('Firebase firmware metadata gagal dibaca.');
      debugPrint('Firebase OTA: $e');
    }
  }

  int _versionCompare(String a, String b) {
    List<int> parse(String value) => value
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .split('.')
        .where((x) => x.isNotEmpty)
        .map(int.tryParse)
        .whereType<int>()
        .toList();

    final x = parse(a);
    final y = parse(b);

    final maxLength = x.length > y.length
        ? x.length
        : y.length;

    for (int i = 0; i < maxLength; i++) {
      final xv = i < x.length ? x[i] : 0;
      final yv = i < y.length ? y[i] : 0;

      if (xv != yv) {
        return xv.compareTo(yv);
      }
    }

    return 0;
  }

  Future<void> _startOnlineOta({
    required String ssid,
    required String password,
    required String url,
    required String version,
  }) async {
    if (ssid.trim().isEmpty ||
        password.isEmpty ||
        !url.startsWith('https://')) {
      _showReason(
        'SSID/password/URL OTA tidak valid.',
      );
      return;
    }

    await _sendRaw('OTAENTER');
    await _sendRaw('SSID:${ssid.trim()}');
    await _sendRaw('PASS:$password');
    await _sendRaw('URL:$url');
    await _sendRaw('VERSION:$version');
    await _sendRaw('CLOUDOTA');

    _showReason(
      'OTA dimulai. Bluetooth akan terputus sementara.',
    );

    _startOtaReconnectMonitor();
  }

  void _startOtaReconnectMonitor() {
    otaReconnectTimer?.cancel();

    int attempts = 0;

    otaReconnectTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        if (connected || attempts >= 12) {
          timer.cancel();
          return;
        }

        attempts++;
        await _scanAndConnect();

        if (connected) timer.cancel();
      },
    );
  }

  void _showReason(String value) {
    if (!mounted) return;

    setState(() => notifyReason = value);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111113),
      appBar: AppBar(
        title: const Text(
          headerName,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: connected ? 'Disconnect' : 'Bluetooth',
          onPressed: syncing
              ? null
              : (connected ? _disconnect : _scanAndConnect),
          icon: syncing
              ? const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.3,
                    color: Colors.blueAccent,
                  ),
                )
              : Icon(
                  connected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth,
                  color: connected
                      ? Colors.blueAccent
                      : Colors.white,
                ),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: _firmwareDialog,
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHome(),
            if (notifyReason.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  4,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    notifyReason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Expanded(
              child: _buildPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 14),
      child: SizedBox(
        height: 254,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopData(
                    connected && batteryAvailable
                        ? phoneBatteryTemp!
                            .toStringAsFixed(1)
                        : '--',
                    '°C',
                    'Battery Temperature',
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 19),
                  _buildTopData(
                    connected
                        ? (hotsideTemp == null
                            ? '--'
                            : hotsideTemp!
                                .toStringAsFixed(1))
                        : '--',
                    connected &&
                            hotsideTemp != null
                        ? '°C'
                        : '',
                    'Hotside Temperature',
                    color: safety == 'FAULT'
                        ? Colors.redAccent
                        : Colors.cyanAccent,
                  ),
                  const SizedBox(height: 19),
                  _buildTopData(
                    connected
                        ? voltage.replaceAll('V', '')
                        : '--',
                    connected && voltage != '--'
                        ? 'V'
                        : '',
                    'Voltage Indicator',
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 19),
                  _buildTopData(
                    connected
                        ? (adaptiveOn ? 'ON' : 'OFF')
                        : '--',
                    '',
                    'Adaptive Mode',
                    color: adaptiveOn
                        ? Colors.greenAccent
                        : Colors.grey,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Transform.translate(
                offset: const Offset(-25, -8),
                child: Transform.scale(
                  scale: 1.32,
                  child: Image.asset(
                    'assets/je_cooler.png',
                    fit: BoxFit.contain,
                    height: 250,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopData(
    String value,
    String unit,
    String label, {
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            if (unit.isNotEmpty && value != '--')
              Padding(
                padding: const EdgeInsets.only(
                  top: 3,
                  left: 2,
                ),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        10,
        17,
        10,
        0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(
              menuNames.length,
              (index) => _buildTabMenu(
                menuNames[index],
                index,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.black12,
            thickness: 1.2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  if (!mounted) return;
                  setState(() => menuIndex = index);
                },
                children: const [
                  _VoltageMenuPage(),
                  _AdaptiveMenuPage(),
                  _LedMenuPage(),
                  _TemperatureMenuPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabMenu(
    String title,
    int index,
  ) {
    final selected = menuIndex == index;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: title,
        child: GestureDetector(
          onTap: () {
            pageController.animateToPage(
              index,
              duration: const Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 2,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF17181C)
                  : const Color(0xFFF2F2F4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected
                    ? const Color(0xFF17181C)
                    : const Color(0xFFE5E5E8),
              ),
            ),
            child: Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : const Color(0xFF5E6068),
                  fontWeight: FontWeight.w800,
                  fontSize: 10.5,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title, {
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        4,
        8,
        4,
        6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
              color: Colors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _premiumCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE7E7E9),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _adaptiveLockNotice({
    required String text,
  }) {
    return _premiumCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 10,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_rounded,
            size: 18,
            color: Colors.orangeAccent,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoltageMenuContent() {
    final locked = adaptiveOn ||
        adaptiveModeTransitioning ||
        !connected;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        0,
        0,
        0,
        18,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _sectionTitle(
          'Voltage Control',
          subtitle: adaptiveOn
              ? 'Adaptive is controlling the output voltage.'
              : 'Choose the output voltage manually.',
        ),
        _premiumCard(
          padding: const EdgeInsets.fromLTRB(
            10,
            5,
            10,
            10,
          ),
          child: Column(
            children: [
              _voltageRow(
                '5V',
                'Low Mode',
                locked,
              ),
              _voltageRow(
                '9V',
                'Mid Mode',
                locked,
              ),
              _voltageRow(
                '12V',
                'High Mode',
                locked,
                isLast: true,
              ),
            ],
          ),
        ),
        if (voltageCommandLocked)
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 2,
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.timer_outlined,
                  size: 15,
                  color: Colors.black38,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Voltage guard aktif — tunggu 1 detik.',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 7),
        _sectionTitle(
          'Cooling Control',
          subtitle:
              'Fan and Peltier follow the hardware safety interlock.',
        ),
        _premiumCard(
          padding: const EdgeInsets.fromLTRB(
            13,
            10,
            13,
            10,
          ),
          child: Column(
            children: [
              _controlSwitchRow(
                title: 'Fan',
                subtitle: fanOn
                    ? 'Cooling fan is ON'
                    : 'Cooling fan is OFF',
                icon: Icons.air_rounded,
                value: fanOn,
                enabled: connected &&
                    !adaptiveOn &&
                    !adaptiveModeTransitioning &&
                    !peltierOn,
                onChanged: _toggleFan,
              ),
              const Divider(height: 20),
              _controlSwitchRow(
                title: 'Peltier',
                subtitle: peltierOn
                    ? 'Thermoelectric cooler is ON'
                    : 'Thermoelectric cooler is OFF',
                icon: Icons.ac_unit_rounded,
                value: peltierOn,
                enabled: connected &&
                    !adaptiveOn &&
                    !adaptiveModeTransitioning,
                onChanged: _togglePeltier,
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.speed_rounded,
                    size: 20,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fan Speed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          voltage == '12V'
                              ? '$fanSpeed% • Manual 12V'
                              : '100% outside Manual 12V',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 54,
                    padding: const EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE1E1E3),
                      ),
                    ),
                    child: Text(
                      '$fanSpeed%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                min: 50,
                max: 100,
                divisions: 5,
                value: fanSpeed
                    .clamp(50, 100)
                    .toDouble(),
                activeColor: Colors.black,
                inactiveColor: Colors.black12,
                onChanged: connected &&
                        !adaptiveOn &&
                        !adaptiveModeTransitioning &&
                        voltage == '12V'
                    ? (value) => _setFanSpeed(
                          value.round(),
                        )
                    : null,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '50%',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    safety == 'FAULT'
                        ? 'SAFETY: FAULT'
                        : 'SAFETY: $safety',
                    style: TextStyle(
                      color: safety == 'FAULT'
                          ? Colors.redAccent
                          : Colors.black45,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '100%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _voltageRow(
    String value,
    String mode,
    bool locked, {
    bool isLast = false,
  }) {
    final isActive = voltage == value;

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: !connected ||
                  adaptiveOn ||
                  adaptiveModeTransitioning ||
                  voltageCommandLocked
              ? null
              : () => _changeVoltage(value),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 150,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.black
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isActive
                    ? Colors.black
                    : const Color(0xFFE3E3E5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? Colors.blueAccent
                        : Colors.black26,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        mode,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white70
                              : Colors.black45,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (locked && adaptiveOn)
                  const Icon(
                    Icons.lock_outline,
                    size: 17,
                    color: Colors.black38,
                  ),
                if (isActive && !locked)
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Colors.blueAccent,
                  ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const SizedBox(height: 6),
      ],
    );
  }

  Widget _controlSwitchRow({
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
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value
                ? Colors.black
                : Colors.black.withValues(alpha: 0.06),
          ),
          child: Icon(
            icon,
            color: value
                ? Colors.white
                : Colors.black45,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.blueAccent,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }

  Widget _buildAdaptiveMenuContent() {
    final locked = adaptiveOn;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        0,
        0,
        0,
        18,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _sectionTitle(
          'Adaptive Switch',
          subtitle: locked
              ? 'Adaptive is controlling the output automatically.'
              : 'Adaptive starts from 5V and selects a safe voltage ceiling.',
        ),
        _premiumCard(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: adaptiveOn
                      ? Colors.green.withValues(alpha: 0.13)
                      : Colors.black.withValues(alpha: 0.06),
                ),
                child: Icon(
                  adaptiveOn
                      ? Icons.shield_rounded
                      : Icons.shield_outlined,
                  color: adaptiveOn
                      ? Colors.green.shade700
                      : Colors.black45,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adaptive Mode',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Automatic safe voltage control',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: connected && adaptiveOn,
                activeThumbColor: Colors.green,
                onChanged: connected &&
                        !adaptiveModeTransitioning
                    ? _toggleAdaptive
                    : null,
              ),
            ],
          ),
        ),
        _sectionTitle(
          'Adaptive Status',
          subtitle:
              'The ceiling can drop during a session when the hotside is unsafe.',
        ),
        _premiumCard(
          padding: const EdgeInsets.fromLTRB(
            14,
            12,
            14,
            12,
          ),
          child: Column(
            children: [
              _adaptiveStatusRow(
                'Current Voltage',
                connected ? voltage : '--',
                Icons.bolt_rounded,
                Colors.blueAccent,
              ),
              const Divider(height: 18),
              _adaptiveStatusRow(
                'Adaptive Ceiling',
                connected ? adaptiveCeiling : '--',
                Icons.vertical_align_bottom_rounded,
                Colors.green,
              ),
              const Divider(height: 18),
              _adaptiveStatusRow(
                'Battery Input',
                connected && batteryAvailable
                    ? '${phoneBatteryTemp!.toStringAsFixed(1)}°C'
                    : '--',
                Icons.battery_std_rounded,
                Colors.orangeAccent,
              ),
              const Divider(height: 18),
              _adaptiveStatusRow(
                'Hotside Input',
                connected && hotsideTemp != null
                    ? '${hotsideTemp!.toStringAsFixed(1)}°C'
                    : '--',
                Icons.device_thermostat_rounded,
                Colors.cyanAccent.shade700,
              ),
            ],
          ),
        ),
        if (adaptiveOn)
          _adaptiveLockNotice(
            text:
                'Voltage, Cooling, LED brightness speed and Temperature protection controls are locked while Adaptive is ON.',
          ),
        if (notifyReason.isNotEmpty)
          _premiumCard(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(
                  safety == 'FAULT'
                      ? Icons.error_outline_rounded
                      : Icons.info_outline_rounded,
                  color: safety == 'FAULT'
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  size: 18,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    notifyReason,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _adaptiveStatusRow(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildLedMenuContent() {
    final percent = brightness.clamp(0, 100);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        0,
        0,
        0,
        18,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _sectionTitle(
          'LED Control',
          subtitle:
              'RGB illumination, patterns, brightness and voltage colors.',
        ),
        _premiumCard(
          padding: const EdgeInsets.fromLTRB(
            14,
            12,
            14,
            10,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rgbOn
                          ? Colors.black
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    child: Icon(
                      Icons.lightbulb_rounded,
                      color: rgbOn
                          ? Colors.white
                          : Colors.black38,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LED Power',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'RGB illumination',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: connected && rgbOn,
                    activeThumbColor: Colors.blueAccent,
                    onChanged: connected
                        ? _toggleRgb
                        : null,
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.animation_rounded,
                    color: Colors.black38,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Pattern',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFFE4E4E6),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: rgbMode.clamp(0, 7).toInt(),
                        isDense: true,
                        iconSize: 18,
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('Static'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Breath'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Wipe'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Running'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('Scan'),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('Theater'),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text('Rainbow'),
                          ),
                          DropdownMenuItem(
                            value: 7,
                            child: Text('Twinkle'),
                          ),
                        ],
                        onChanged: connected &&
                                !adaptiveOn
                            ? (value) {
                                if (value != null) {
                                  _setMode(value);
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Custom RGB',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  _colorSwatch(
                    rgbColor,
                    onTap: connected
                        ? () => _showColorEditor(
                              title: 'Custom RGB',
                              initial: rgbColor,
                              onSelected:
                                  _setCustomColor,
                            )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rgbColor.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: connected
                        ? () => _showColorEditor(
                              title: 'Custom RGB',
                              initial: rgbColor,
                              onSelected:
                                  _setCustomColor,
                            )
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                        color: Color(0xFFE1E1E3),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.brightness_low_rounded,
                    color: Colors.black38,
                    size: 20,
                  ),
                  Expanded(
                    child: Slider(
                      value: percent.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black12,
                      onChanged: connected &&
                              !adaptiveOn
                          ? (value) => _setBrightness(
                                value.round(),
                              )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 42,
                    child: Text(
                      '$percent%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _sectionTitle(
          'Voltage Indicator Colors',
          subtitle:
              'Colors shown by the cooler for 5V, 9V and 12V.',
        ),
        _premiumCard(
          padding: const EdgeInsets.fromLTRB(
            13,
            10,
            13,
            9,
          ),
          child: Column(
            children: [
              _voltageColorRow(
                '5V',
                'Low',
                color5V,
              ),
              const Divider(height: 18),
              _voltageColorRow(
                '9V',
                'Mid',
                color9V,
              ),
              const Divider(height: 18),
              _voltageColorRow(
                '12V',
                'High',
                color12V,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: connected &&
                    !adaptiveOn
                ? _resetVoltageColors
                : null,
            icon: const Icon(
              Icons.restart_alt_rounded,
              size: 17,
            ),
            label: const Text(
              'Reset Colors',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(
                color: Color(0x33FF5252),
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              minimumSize: Size.zero,
              tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _voltageColorRow(
    String voltageValue,
    String mode,
    String color,
  ) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorFromHex(color),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                voltageValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$mode • $color',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _colorSwatch(
          color,
          size: 30,
          onTap: connected && !adaptiveOn
              ? () => _showColorEditor(
                    title: '$voltageValue LED Color',
                    initial: color,
                    onSelected: (next) =>
                        _setVoltageColor(
                      voltageValue,
                      next,
                    ),
                  )
              : null,
        ),
      ],
    );
  }

  Widget _colorSwatch(
    String hex, {
    double size = 34,
    VoidCallback? onTap,
  }) {
    final swatch = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _colorFromHex(hex),
        border: Border.all(
          color: Colors.black26,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );

    if (onTap == null) return swatch;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        size / 2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: swatch,
      ),
    );
  }

  Color _colorFromHex(String value) {
    final clean = value
        .replaceAll('#', '')
        .trim();

    if (clean.length != 6) {
      return Colors.white;
    }

    final parsed = int.tryParse(
      'FF$clean',
      radix: 16,
    );

    return parsed == null
        ? Colors.white
        : Color(parsed);
  }

  Future<void> _showColorEditor({
    required String title,
    required String initial,
    required Future<void> Function(String) onSelected,
  }) async {
    final controller = TextEditingController(
      text: initial.toUpperCase(),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            textCapitalization:
                TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Hex color',
              hintText: '#RRGGBB',
              prefixIcon: Icon(
                Icons.palette_outlined,
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9a-fA-F#]'),
              ),
              LengthLimitingTextInputFormatter(7),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () async {
                final raw =
                    controller.text.trim();

                final normalized =
                    raw.startsWith('#')
                        ? raw.toUpperCase()
                        : '#${raw.toUpperCase()}';

                if (!RegExp(
                  r'^#[0-9A-F]{6}$',
                ).hasMatch(normalized)) {
                  _showReason(
                    'Gunakan format #RRGGBB.',
                  );
                  return;
                }

                await onSelected(normalized);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Widget _buildTemperatureMenuContent() {
    final controlsEnabled =
        connected &&
        !adaptiveOn &&
        !adaptiveModeTransitioning;

    final midLow = battery5Limit + 1;
    final midHigh = battery12Limit - 1;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        0,
        0,
        0,
        18,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _sectionTitle(
          'Temperature',
          subtitle: adaptiveOn
              ? 'Protection settings are locked while Adaptive is ON.'
              : 'Protection limits are applied by the ESP32.',
        ),
        _premiumCard(
          padding: const EdgeInsets.fromLTRB(
            13,
            10,
            13,
            10,
          ),
          child: _tempAdjusterTile(
            title: 'Hotside Overheat Limit',
            value: hotLimit,
            unit: '°C',
            min: 40,
            max: 50,
            enabled: controlsEnabled,
            onMinus: () => _setHotLimit(
              hotLimit - 1,
            ),
            onPlus: () => _setHotLimit(
              hotLimit + 1,
            ),
          ),
        ),
        _sectionTitle(
          'Battery Protection',
          subtitle:
              '9V is automatically centered between the 5V and 12V thresholds.',
        ),
        _premiumCard(
          padding: const EdgeInsets.fromLTRB(
            13,
            7,
            13,
            7,
          ),
          child: Column(
            children: [
              _batteryLimitRow(
                title: '5V',
                subtitle:
                    '< $battery5Limit°C • Below',
                value: battery5Limit,
                enabled: controlsEnabled,
                min: 20,
                max: 48,
                onChanged: _setBattery5,
              ),
              const Divider(height: 18),
              Row(
                children: [
                  const SizedBox(width: 42),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          '≈ $midLow–$midHigh°C',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '9V • derived automatically • LOCKED',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.lock_outline,
                    size: 19,
                    color: Colors.black26,
                  ),
                ],
              ),
              const Divider(height: 18),
              _batteryLimitRow(
                title: '12V',
                subtitle:
                    '> $battery12Limit°C • Above',
                value: battery12Limit,
                enabled: controlsEnabled,
                min: 22,
                max: 50,
                onChanged: _setBattery12,
              ),
            ],
          ),
        ),
        if (adaptiveOn)
          _adaptiveLockNotice(
            text:
                'Temperature settings are locked while Adaptive Mode is ON.',
          ),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Hot 40–50°C • Battery 20–50°C',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: controlsEnabled
                  ? _resetTemperatureSettings
                  : null,
              icon: const Icon(
                Icons.restart_alt_rounded,
                size: 17,
              ),
              label: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(
                  color: Color(0x33FF5252),
                ),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        ),
        _premiumCard(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 11,
          ),
          child: Row(
            children: [
              Icon(
                safety == 'FAULT'
                    ? Icons.error_outline_rounded
                    : Icons.verified_user_outlined,
                color: safety == 'FAULT'
                    ? Colors.redAccent
                    : Colors.green.shade700,
                size: 20,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      safety == 'FAULT'
                          ? 'Safety Fault'
                          : 'Safety State',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      connected
                          ? safetyReason
                          : 'DISCONNECTED',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                connected ? safety : '--',
                style: TextStyle(
                  color: safety == 'FAULT'
                      ? Colors.redAccent
                      : Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tempAdjusterTile({
    required String title,
    required int value,
    required String unit,
    required int min,
    required int max,
    required bool enabled,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Range $min–$max$unit',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.remove_circle_outline_rounded,
          ),
          color: Colors.black54,
          onPressed: enabled && value > min
              ? onMinus
              : null,
        ),
        Container(
          width: 64,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0xFFE3E3E5),
            ),
          ),
          child: Text(
            '$value$unit',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.blueAccent,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline_rounded,
          ),
          color: Colors.black54,
          onPressed: enabled && value < max
              ? onPlus
              : null,
        ),
      ],
    );
  }

  Widget _batteryLimitRow({
    required String title,
    required String subtitle,
    required int value,
    required bool enabled,
    required int min,
    required int max,
    required Future<void> Function(int) onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: enabled
                  ? Colors.blueAccent
                  : Colors.black26,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '$value°C',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: enabled && value > min
              ? () => onChanged(value - 1)
              : null,
          icon: const Icon(
            Icons.remove_circle_outline_rounded,
          ),
          color: Colors.black54,
        ),
        IconButton(
          onPressed: enabled && value < max
              ? () => onChanged(value + 1)
              : null,
          icon: const Icon(
            Icons.add_circle_outline_rounded,
          ),
          color: Colors.black54,
        ),
      ],
    );
  }
}

class _VoltageMenuPage extends StatelessWidget {
  const _VoltageMenuPage();

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<
            _DashboardScreenState>();

    if (state == null) {
      return const SizedBox.shrink();
    }

    return state._buildVoltageMenuContent();
  }
}

class _AdaptiveMenuPage extends StatelessWidget {
  const _AdaptiveMenuPage();

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<
            _DashboardScreenState>();

    if (state == null) {
      return const SizedBox.shrink();
    }

    return state._buildAdaptiveMenuContent();
  }
}

class _LedMenuPage extends StatelessWidget {
  const _LedMenuPage();

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<
            _DashboardScreenState>();

    if (state == null) {
      return const SizedBox.shrink();
    }

    return state._buildLedMenuContent();
  }
}

class _TemperatureMenuPage extends StatelessWidget {
  const _TemperatureMenuPage();

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<
            _DashboardScreenState>();

    if (state == null) {
      return const SizedBox.shrink();
    }

    return state._buildTemperatureMenuContent();
  }
}

class _OtaDialog extends StatefulWidget {
  final String currentVersion;
  final String latestVersion;
  final bool canUpdate;
  final Future<void> Function(
    String ssid,
    String password,
  ) onStart;

  const _OtaDialog({
    required this.currentVersion,
    required this.latestVersion,
    required this.canUpdate,
    required this.onStart,
  });

  @override
  State<_OtaDialog> createState() => _OtaDialogState();
}

class _OtaDialogState extends State<_OtaDialog> {
  final TextEditingController ssid =
      TextEditingController();
  final TextEditingController password =
      TextEditingController();

  @override
  void dispose() {
    ssid.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Firmware Update'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current: ${widget.currentVersion}',
            ),
            const SizedBox(height: 4),
            Text(
              'Latest: ${widget.latestVersion.isEmpty ? '--' : widget.latestVersion}',
            ),
            if (widget.canUpdate) ...[
              const SizedBox(height: 14),
              TextField(
                controller: ssid,
                decoration: const InputDecoration(
                  labelText: 'Wi-Fi SSID',
                  prefixIcon:
                      Icon(Icons.wifi_rounded),
                ),
              ),
              TextField(
                controller: password,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: 'Wi-Fi Password',
                  prefixIcon:
                      Icon(Icons.lock_outline),
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (widget.canUpdate)
              const Text(
                'Firmware metadata is read from Firebase. OTA requires HTTPS.',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 10,
                ),
              )
            else
              const Text(
                'No firmware update is currently available.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE'),
        ),
        if (widget.canUpdate)
          FilledButton(
            onPressed: () async {
              await widget.onStart(
                ssid.text,
                password.text,
              );
            },
            child: const Text('UPDATE'),
          ),
      ],
    );
  }
}
