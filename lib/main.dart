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
const String serviceUuid = '6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001';
const String rxUuid = '6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001';
const String txUuid = '6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001';
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1014),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
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
    'CONTROL',
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
    // Keep the battery read cadence at exactly 1 Hz without overlapping native
    // battery requests if Android takes longer than one second to respond.
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

      // Battery telemetry is deliberately sent every second while connected.
      // The firmware receives it as data/heartbeat and creates a voltage
      // request only when the 5V/9V/12V battery zone actually changes.
      if (connected && valid) {
        await _sendRaw('PHONE:BT=${value.toStringAsFixed(1)}');
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
    setState(() {
      syncing = true;
    });

    BluetoothDevice? found;
    StreamSubscription<List<ScanResult>>? scanSub;
    try {
      await FlutterBluePlus.stopScan();
      final completer = Completer<BluetoothDevice?>();
      scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final serviceMatch = result.advertisementData.serviceUuids.any(
            (u) => u.toString().toLowerCase() == serviceUuid,
          );
          final name = result.advertisementData.advName.toLowerCase();
          if (serviceMatch || name == 'je x fyz') {
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
            } catch (_) {
              // Already bonded or OS handles pairing automatically.
            }
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
      if (service.uuid.toString().toLowerCase() != serviceUuid) continue;
      for (final characteristic in service.characteristics) {
        final id = characteristic.uuid.toString().toLowerCase();
        if (id == rxUuid) foundRx = characteristic;
        if (id == txUuid) foundTx = characteristic;
      }
    }

    if (foundRx == null || foundTx == null) {
      _showReason('BLE UUID JE X FYZ tidak cocok.');
      await target.disconnect();
      return;
    }

    rx = foundRx;
    tx = foundTx;
    await foundTx!.setNotifyValue(true);
    await txSub?.cancel();
    txSub = foundTx.lastValueStream.listen(_parseIncomingBytes);

    await _sendRaw('SYNC');

    final deadline = DateTime.now().add(const Duration(seconds: 3));
    while (mounted && !fullSyncDone && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    if (!fullSyncDone) {
      _showReason('Full Sync gagal.');
      if (mounted) setState(() => syncing = false);
      return;
    }

    // First connection: firmware state is now the source of truth. We send a
    // complete command set once, then every later user action sends only the
    // command that actually changed.
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
      await Future<void>.delayed(const Duration(milliseconds: 20));
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
      if (!connected && command != 'SYNC' && characteristic == null) return;
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
    rxBuffer += utf8.decode(bytes, allowMalformed: true);
    if (rxBuffer.length > 8192) {
      final index = rxBuffer.lastIndexOf('<SYNC_START>');
      rxBuffer = index >= 0 ? rxBuffer.substring(index) : '';
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
      String item = parts.isNotEmpty ? parts.first : 'COMMAND';
      String reason = 'UNKNOWN';
      if (item.contains('=')) item = item.split('=').first;
      for (final part in parts.skip(1)) {
        if (part.startsWith('REASON=')) reason = part.substring(7);
      }
      if (reason != 'OK' && reason != 'ACCEPTED' && reason != 'STARTING') {
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
          // The local 1-second guard begins at the user's tap in _changeVoltage.
          // Do not restart it when the firmware reports the completed voltage.
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
          // During a normal ON transition, stay locked until the firmware
          // reports the forced 5V state. During OFF, keep the transition lock
          // until the same 5V confirmation arrives. Full Sync with an already
          // active Adaptive session has voltage=5V before this field, so it
          // does not get stuck in a phantom transition state.
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
    if (!connected || adaptiveOn || adaptiveModeTransitioning || voltageCommandLocked || voltage == target) return;

    // Start the same 1-second manual guard immediately on the user's tap.
    // This runs concurrently with the firmware's 200 ms optocoupler
    // break-before-make dead-time; it is not added after the transition.
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
    await _sendRaw(value ? 'FAN:ON' : 'FAN:OFF');
  }

  Future<void> _togglePeltier(bool value) async {
    if (!connected || adaptiveOn) return;
    if (!value) {
      await _sendRaw('PELTIER:OFF');
      return;
    }

    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perhatian'),
        content: const Text('Pastikan kipas sudah terpasang.'),
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
    if (approved == true) await _sendRaw('PELTIER:ON');
  }

  Future<void> _toggleAdaptive(bool value) async {
    if (!connected || adaptiveModeTransitioning) return;
    setState(() => adaptiveModeTransitioning = true);
    await _sendRaw(value ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF');
  }

  Future<void> _toggleRgb(bool value) async {
    await _sendRaw(value ? 'RGB:ON' : 'RGB:OFF');
  }

  Future<void> _setMode(int mode) async {
    await _sendRaw('MODE:$mode');
  }

  Future<void> _setBrightness(int value) async {
    await _sendRaw('BRIGHTNESS:$value');
  }

  Future<void> _setFanSpeed(int value) async {
    if (!connected || adaptiveOn || voltage != '12V') return;
    await _sendRaw('FANSPEED:$value');
  }

  Future<void> _setHotLimit(int value) async {
    if (!connected || adaptiveOn) return;
    await _sendRaw('HOTLIMIT:$value');
  }

  Future<void> _setBattery5(int value) async {
    if (!connected || adaptiveOn) return;
    await _sendRaw('BATT5:$value');
  }

  Future<void> _setBattery12(int value) async {
    if (!connected || adaptiveOn) return;
    await _sendRaw('BATT12:$value');
  }

  void _showReason(String value) {
    if (!mounted) return;
    setState(() => notifyReason = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _firmwareDialog() async {
    if (!connected) return;
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
      final canUpdate = _versionCompare(latest, firmwareVersion) > 0 &&
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
    List<int> parse(String v) => v
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .split('.')
        .where((x) => x.isNotEmpty)
        .map(int.tryParse)
        .whereType<int>()
        .toList();
    final x = parse(a), y = parse(b);
    for (int i = 0; i < (x.length > y.length ? x.length : y.length); i++) {
      final xv = i < x.length ? x[i] : 0;
      final yv = i < y.length ? y[i] : 0;
      if (xv != yv) return xv.compareTo(yv);
    }
    return 0;
  }

  Future<void> _startOnlineOta({
    required String ssid,
    required String password,
    required String url,
    required String version,
  }) async {
    if (ssid.trim().isEmpty || password.isEmpty || !url.startsWith('https://')) {
      _showReason('SSID/password/URL OTA tidak valid.');
      return;
    }
    await _sendRaw('OTAENTER');
    await _sendRaw('SSID:${ssid.trim()}');
    await _sendRaw('PASS:$password');
    await _sendRaw('URL:$url');
    await _sendRaw('VERSION:$version');
    await _sendRaw('CLOUDOTA');
    _showReason('OTA dimulai. Bluetooth akan terputus sementara.');
    _startOtaReconnectMonitor();
  }

  void _startOtaReconnectMonitor() {
    otaReconnectTimer?.cancel();
    int attempts = 0;
    otaReconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (connected || attempts >= 12) {
        timer.cancel();
        return;
      }
      attempts++;
      await _scanAndConnect();
      if (connected) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          headerName,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          tooltip: 'Bluetooth',
          onPressed: _scanAndConnect,
          icon: Icon(
            Icons.bluetooth,
            color: connected ? Colors.blueAccent : Colors.grey,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _home(context),
            if (notifyReason.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    notifyReason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            _menuTabs(),
            const SizedBox(height: 4),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) => setState(() => menuIndex = index),
                children: const [
                  _VoltagePage(),
                  _ControlPage(),
                  _AdaptivePage(),
                  _LedPage(),
                  _TemperaturePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _home(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: SizedBox(
        height: 254,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: _InfoCard(
                      'Battery Temperature',
                      batteryAvailable && phoneBatteryTemp != null
                          ? '${phoneBatteryTemp!.toStringAsFixed(1)}°C'
                          : '--',
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 48,
                    child: _InfoCard(
                      'Hotside Temperature',
                      hotsideTemp == null
                          ? '--'
                          : '${hotsideTemp!.toStringAsFixed(1)}°C',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _InfoCard('Voltage', voltage)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _InfoCard(
                            'Adaptive Mode',
                            adaptiveOn ? 'ON' : 'OFF',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _InfoCard('Fan', fanOn ? 'ON' : 'OFF')),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _InfoCard('Peltier', peltierOn ? 'ON' : 'OFF'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/je_cooler.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTabs() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: menuNames.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final selected = index == menuIndex;
          return ChoiceChip(
            label: Text(menuNames[index]),
            selected: selected,
            onSelected: (_) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showSettings() async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.system_update),
              title: const Text('Firmware Update'),
              subtitle: Text('$firmwareVersion → Firebase metadata'),
              onTap: _firmwareDialog,
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(appName),
              subtitle: const Text(firmwareVersionText),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCard(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C23),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _VoltagePage extends StatelessWidget {
  const _VoltagePage();
  @override
  Widget build(BuildContext context) => const _PagePanel(title: 'Voltage control');
}

class _ControlPage extends StatelessWidget {
  const _ControlPage();
  @override
  Widget build(BuildContext context) => const _PagePanel(title: 'Fan + Peltier control');
}

class _AdaptivePage extends StatelessWidget {
  const _AdaptivePage();
  @override
  Widget build(BuildContext context) => const _PagePanel(title: 'Adaptive battery mode');
}

class _LedPage extends StatelessWidget {
  const _LedPage();
  @override
  Widget build(BuildContext context) => const _PagePanel(title: 'LED settings');
}

class _TemperaturePage extends StatelessWidget {
  const _TemperaturePage();
  @override
  Widget build(BuildContext context) => const _PagePanel(title: 'Temperature settings');
}

class _PagePanel extends StatelessWidget {
  final String title;
  const _PagePanel({required this.title});
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_DashboardScreenState>();
    if (state == null) return const SizedBox.shrink();
    switch (title) {
      case 'Voltage control':
        return _VoltageControls(state: state);
      case 'Fan + Peltier control':
        return _ControlControls(state: state);
      case 'Adaptive battery mode':
        return _AdaptiveControls(state: state);
      case 'LED settings':
        return _LedControls(state: state);
      default:
        return _TemperatureControls(state: state);
    }
  }
}

class _VoltageControls extends StatelessWidget {
  final _DashboardScreenState state;
  const _VoltageControls({required this.state});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sectionCard(
            context,
            title: 'Voltage',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.adaptiveOn || state.adaptiveModeTransitioning)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'LOCKED — Adaptive Mode aktif',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                if (!state.adaptiveOn && !state.adaptiveModeTransitioning && state.voltageCommandLocked)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'GUARD — tunggu 1 detik setelah perpindahan voltage',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                Row(
                  children: ['5V', '9V', '12V'].map((v) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: FilledButton.tonal(
                          onPressed: (!state.connected || state.adaptiveOn || state.adaptiveModeTransitioning || state.voltageCommandLocked)
                              ? null
                              : () => state._changeVoltage(v),
                          child: Text(v),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      );
}

class _ControlControls extends StatelessWidget {
  final _DashboardScreenState state;
  const _ControlControls({required this.state});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sectionCard(
            context,
            title: 'Cooling',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.adaptiveOn)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'LOCKED — Adaptive Mode aktif',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                Row(
              children: [
                Expanded(
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fan'),
                    value: state.fanOn,
                    onChanged: state.connected && !state.adaptiveOn && !state.adaptiveModeTransitioning && !state.peltierOn ? state._toggleFan : null,
                  ),
                ),
                Expanded(
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Peltier'),
                    value: state.peltierOn,
                    onChanged: state.connected && !state.adaptiveOn && !state.adaptiveModeTransitioning ? state._togglePeltier : null,
                  ),
                ),
              ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            context,
            title: 'Fan Speed',
            child: Column(
              children: [
                Text('${state.fanSpeed}%'),
                Slider(
                  min: 50,
                  max: 100,
                  divisions: 5,
                  value: state.fanSpeed.toDouble().clamp(50, 100),
                  onChanged: (!state.connected ||
                          state.adaptiveOn ||
                          state.adaptiveModeTransitioning ||
                          state.voltage != '12V')
                      ? null
                      : (v) => state._setFanSpeed((v / 10).round() * 10),
                ),
              ],
            ),
          ),
        ],
      );
}

class _AdaptiveControls extends StatelessWidget {
  final _DashboardScreenState state;
  const _AdaptiveControls({required this.state});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sectionCard(
            context,
            title: 'Adaptive',
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Adaptive Mode'),
              subtitle: Text('Ceiling: ${state.adaptiveCeiling}'),
              value: state.adaptiveOn,
              onChanged: state.connected ? state._toggleAdaptive : null,
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            context,
            title: 'Battery Temperature',
            child: Text(
              state.batteryAvailable && state.phoneBatteryTemp != null
                  ? '${state.phoneBatteryTemp!.toStringAsFixed(1)}°C'
                  : '--',
            ),
          ),
        ],
      );
}

class _LedControls extends StatelessWidget {
  final _DashboardScreenState state;
  const _LedControls({required this.state});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sectionCard(
            context,
            title: 'RGB',
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('RGB'),
              value: state.rgbOn,
              onChanged: state.connected ? state._toggleRgb : null,
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            context,
            title: 'Mode',
            child: DropdownButtonFormField<int>(
              initialValue: state.rgbMode.clamp(0, 7),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Static')),
                DropdownMenuItem(value: 1, child: Text('Breath')),
                DropdownMenuItem(value: 2, child: Text('Color Wipe')),
                DropdownMenuItem(value: 3, child: Text('Running Lights')),
                DropdownMenuItem(value: 4, child: Text('Scan')),
                DropdownMenuItem(value: 5, child: Text('Theater Chase')),
                DropdownMenuItem(value: 6, child: Text('Rainbow')),
                DropdownMenuItem(value: 7, child: Text('Twinkle')),
              ],
              onChanged: state.connected
                  ? (value) {
                      if (value != null) state._setMode(value);
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            context,
            title: 'Brightness',
            child: Slider(
              min: 0,
              max: 100,
              divisions: 20,
              value: state.brightness.toDouble().clamp(0, 100),
              onChanged: state.connected
                  ? (value) => state._setBrightness(value.round())
                  : null,
            ),
          ),
        ],
      );
}

class _TemperatureControls extends StatelessWidget {
  final _DashboardScreenState state;
  const _TemperatureControls({required this.state});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sectionCard(
            context,
            title: 'Hotside Protection',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.adaptiveOn)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'LOCKED — Adaptive Mode aktif',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                Text('${state.hotLimit}°C'),
                Slider(
                  min: 40,
                  max: 50,
                  divisions: 10,
                  value: state.hotLimit.toDouble().clamp(40, 50),
                  onChanged: state.connected && !state.adaptiveOn && !state.adaptiveModeTransitioning
                      ? (v) => state._setHotLimit(v.round())
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            context,
            title: 'Battery Thresholds',
            child: Column(
              children: [
                Text('5V below ${state.battery5Limit}°C'),
                Slider(
                  min: 20,
                  max: 48,
                  divisions: 28,
                  value: state.battery5Limit.toDouble().clamp(20, 48),
                  onChanged: state.connected && !state.adaptiveOn && !state.adaptiveModeTransitioning
                      ? (v) => state._setBattery5(v.round())
                      : null,
                ),
                Text('12V at ${state.battery12Limit}°C'),
                Slider(
                  min: 22,
                  max: 50,
                  divisions: 28,
                  value: state.battery12Limit.toDouble().clamp(22, 50),
                  onChanged: state.connected && !state.adaptiveOn && !state.adaptiveModeTransitioning
                      ? (v) => state._setBattery12(v.round())
                      : null,
                ),
              ],
            ),
          ),
        ],
      );
}

Widget _sectionCard(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1C23),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        child,
      ],
    ),
  );
}

class _OtaDialog extends StatefulWidget {
  final String currentVersion;
  final String latestVersion;
  final bool canUpdate;
  final Future<void> Function(String ssid, String password) onStart;

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
  final ssid = TextEditingController();
  final password = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current: ${widget.currentVersion}'),
            Text('Latest: ${widget.latestVersion.isEmpty ? '--' : widget.latestVersion}'),
            if (widget.canUpdate) ...[
              const SizedBox(height: 12),
              TextField(controller: ssid, decoration: const InputDecoration(labelText: 'Wi-Fi SSID')),
              TextField(controller: password, obscureText: false, decoration: const InputDecoration(labelText: 'Wi-Fi Password')),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE'),
        ),
        FilledButton(
          onPressed: !widget.canUpdate
              ? null
              : () => widget.onStart(ssid.text, password.text),
          child: Text(widget.canUpdate ? 'UPDATE' : 'UP TO DATE'),
        ),
      ],
    );
  }
}
