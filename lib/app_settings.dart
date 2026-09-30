import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppLanguage { english, indonesia }
enum AppThemePreset { defaultTheme, light, dark }

class AppSettings {
  final AppLanguage language;
  final AppThemePreset theme;
  final bool notifySafety;
  final bool notifyFirmware;
  final bool notifyBluetooth;
  final bool autoConnect;

  const AppSettings({
    this.language = AppLanguage.english,
    this.theme = AppThemePreset.defaultTheme,
    this.notifySafety = true,
    this.notifyFirmware = true,
    this.notifyBluetooth = true,
    this.autoConnect = true,
  });

  AppSettings copyWith({
    AppLanguage? language,
    AppThemePreset? theme,
    bool? notifySafety,
    bool? notifyFirmware,
    bool? notifyBluetooth,
    bool? autoConnect,
  }) {
    return AppSettings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notifySafety: notifySafety ?? this.notifySafety,
      notifyFirmware: notifyFirmware ?? this.notifyFirmware,
      notifyBluetooth: notifyBluetooth ?? this.notifyBluetooth,
      autoConnect: autoConnect ?? this.autoConnect,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language.name,
        'theme': theme.name,
        'notifySafety': notifySafety,
        'notifyFirmware': notifyFirmware,
        'notifyBluetooth': notifyBluetooth,
        'autoConnect': autoConnect,
      };

  static AppSettings fromJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const AppSettings();
      AppLanguage language = AppLanguage.english;
      AppThemePreset theme = AppThemePreset.defaultTheme;
      try {
        language = AppLanguage.values.byName(decoded['language']?.toString() ?? '');
      } catch (_) {}
      try {
        theme = AppThemePreset.values.byName(decoded['theme']?.toString() ?? '');
      } catch (_) {}
      return AppSettings(
        language: language,
        theme: theme,
        notifySafety: decoded['notifySafety'] is bool ? decoded['notifySafety'] as bool : true,
        notifyFirmware: decoded['notifyFirmware'] is bool ? decoded['notifyFirmware'] as bool : true,
        notifyBluetooth: decoded['notifyBluetooth'] is bool ? decoded['notifyBluetooth'] as bool : true,
        autoConnect: decoded['autoConnect'] is bool ? decoded['autoConnect'] as bool : true,
      );
    } catch (_) {
      return const AppSettings();
    }
  }
}

final ValueNotifier<AppLanguage> appLanguageNotifier = ValueNotifier<AppLanguage>(AppLanguage.english);
final ValueNotifier<AppThemePreset> appThemeNotifier = ValueNotifier<AppThemePreset>(AppThemePreset.defaultTheme);
final ValueNotifier<bool> appNotifySafetyNotifier = ValueNotifier<bool>(true);
final ValueNotifier<bool> appNotifyFirmwareNotifier = ValueNotifier<bool>(true);
final ValueNotifier<bool> appNotifyBluetoothNotifier = ValueNotifier<bool>(true);
final ValueNotifier<bool> appAutoConnectNotifier = ValueNotifier<bool>(true);

class AppSettingsStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'jexfyz_app_settings_v2';
  static const String _firmwareNoticeKey = 'jexfyz_last_firmware_notice';

  static Future<AppSettings> load() async {
    try {
      final raw = await _storage.read(key: _key);
      final settings = raw == null ? const AppSettings() : AppSettings.fromJson(raw);
      _apply(settings);
      return settings;
    } catch (_) {
      const settings = AppSettings();
      _apply(settings);
      return settings;
    }
  }

  static Future<void> save(AppSettings settings) async {
    _apply(settings);
    try {
      await _storage.write(key: _key, value: jsonEncode(settings.toJson()));
    } catch (_) {}
  }

  static void _apply(AppSettings settings) {
    appLanguageNotifier.value = settings.language;
    appThemeNotifier.value = settings.theme;
    appNotifySafetyNotifier.value = settings.notifySafety;
    appNotifyFirmwareNotifier.value = settings.notifyFirmware;
    appNotifyBluetoothNotifier.value = settings.notifyBluetooth;
    appAutoConnectNotifier.value = settings.autoConnect;
  }

  static Future<bool> shouldNotifyFirmware(String version) async {
    if (version.trim().isEmpty) return false;
    try {
      final last = await _storage.read(key: _firmwareNoticeKey);
      return last != version;
    } catch (_) {
      return true;
    }
  }

  static Future<void> markFirmwareNotified(String version) async {
    try {
      await _storage.write(key: _firmwareNoticeKey, value: version);
    } catch (_) {}
  }
}

class JexText {
  static const Map<String, Map<AppLanguage, String>> _values = {
    'settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.indonesia: 'Pengaturan',
    },
    'general': {
      AppLanguage.english: 'General',
      AppLanguage.indonesia: 'Umum',
    },
    'device': {
      AppLanguage.english: 'Device',
      AppLanguage.indonesia: 'Perangkat',
    },
    'firmwareSection': {
      AppLanguage.english: 'Firmware',
      AppLanguage.indonesia: 'Firmware',
    },
    'aboutSection': {
      AppLanguage.english: 'About',
      AppLanguage.indonesia: 'Tentang',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.indonesia: 'Bahasa',
    },
    'english': {
      AppLanguage.english: 'English',
      AppLanguage.indonesia: 'English',
    },
    'indonesia': {
      AppLanguage.english: 'Bahasa Indonesia',
      AppLanguage.indonesia: 'Bahasa Indonesia',
    },
    'appearance': {
      AppLanguage.english: 'Appearance',
      AppLanguage.indonesia: 'Tampilan',
    },
    'default': {
      AppLanguage.english: 'Default',
      AppLanguage.indonesia: 'Default',
    },
    'light': {
      AppLanguage.english: 'Light',
      AppLanguage.indonesia: 'Terang',
    },
    'dark': {
      AppLanguage.english: 'Dark',
      AppLanguage.indonesia: 'Gelap',
    },
    'notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.indonesia: 'Notifikasi',
    },
    'safetyAlert': {
      AppLanguage.english: 'Safety Alert',
      AppLanguage.indonesia: 'Peringatan Keselamatan',
    },
    'firmwareUpdate': {
      AppLanguage.english: 'Firmware Update',
      AppLanguage.indonesia: 'Pembaruan Firmware',
    },
    'bluetoothConnected': {
      AppLanguage.english: 'Bluetooth Connected',
      AppLanguage.indonesia: 'Bluetooth Terhubung',
    },
    'bluetoothDisconnected': {
      AppLanguage.english: 'Bluetooth Disconnected',
      AppLanguage.indonesia: 'Bluetooth Terputus',
    },
    'bluetooth': {
      AppLanguage.english: 'Bluetooth',
      AppLanguage.indonesia: 'Bluetooth',
    },
    'autoConnect': {
      AppLanguage.english: 'Auto Connect',
      AppLanguage.indonesia: 'Hubungkan Otomatis',
    },
    'floatingMonitor': {
      AppLanguage.english: 'Floating Monitor',
      AppLanguage.indonesia: 'Floating Monitor',
    },
    'about': {
      AppLanguage.english: 'About JE X FYZ',
      AppLanguage.indonesia: 'Tentang JE X FYZ',
    },
    'voltage': {
      AppLanguage.english: 'Voltage',
      AppLanguage.indonesia: 'Tegangan',
    },
    'control': {
      AppLanguage.english: 'Control',
      AppLanguage.indonesia: 'Kontrol',
    },
    'led': {
      AppLanguage.english: 'LED',
      AppLanguage.indonesia: 'LED',
    },
    'temperature': {
      AppLanguage.english: 'Temperature',
      AppLanguage.indonesia: 'Temperatur',
    },
    'power': {
      AppLanguage.english: 'Power',
      AppLanguage.indonesia: 'Daya',
    },
    'fan': {
      AppLanguage.english: 'Fan',
      AppLanguage.indonesia: 'Kipas',
    },
    'color': {
      AppLanguage.english: 'Color',
      AppLanguage.indonesia: 'Warna',
    },
    'displayStyle': {
      AppLanguage.english: 'Display Style',
      AppLanguage.indonesia: 'Gaya Tampilan',
    },
    'letters': {
      AppLanguage.english: 'Letters',
      AppLanguage.indonesia: 'Huruf',
    },
    'icons': {
      AppLanguage.english: 'Icons',
      AppLanguage.indonesia: 'Ikon',
    },
    'functions': {
      AppLanguage.english: 'Functions',
      AppLanguage.indonesia: 'Fungsi',
    },
    'size': {
      AppLanguage.english: 'Size',
      AppLanguage.indonesia: 'Ukuran',
    },
    'opacity': {
      AppLanguage.english: 'Opacity',
      AppLanguage.indonesia: 'Opasitas',
    },
    'fps': {
      AppLanguage.english: 'FPS',
      AppLanguage.indonesia: 'FPS',
    },
    'battery': {
      AppLanguage.english: 'Battery',
      AppLanguage.indonesia: 'Baterai',
    },
    'hotside': {
      AppLanguage.english: 'Hotside',
      AppLanguage.indonesia: 'Suhu Panas',
    },
    'volt': {
      AppLanguage.english: 'Volt',
      AppLanguage.indonesia: 'Tegangan',
    },
    'adaptive': {
      AppLanguage.english: 'Adaptive',
      AppLanguage.indonesia: 'Adaptif',
    },
    'peltier': {
      AppLanguage.english: 'Peltier',
      AppLanguage.indonesia: 'Peltier',
    },
    'speed': {
      AppLanguage.english: 'Speed',
      AppLanguage.indonesia: 'Kecepatan',
    },
    'voltageIndicator': {
      AppLanguage.english: 'Voltage Indicator',
      AppLanguage.indonesia: 'Tegangan',
    },
    'adaptiveMode': {
      AppLanguage.english: 'Adaptive Mode',
      AppLanguage.indonesia: 'Mode Adaptif',
    },
    'peltierSwitch': {
      AppLanguage.english: 'Peltier Switch',
      AppLanguage.indonesia: 'Saklar Peltier',
    },
    'fanSwitch': {
      AppLanguage.english: 'Fan Switch',
      AppLanguage.indonesia: 'Saklar Kipas',
    },
    'fanSpeedLabel': {
      AppLanguage.english: 'Fan Speed',
      AppLanguage.indonesia: 'Kecepatan Kipas',
    },
    'notify': {
      AppLanguage.english: 'NOTIFY',
      AppLanguage.indonesia: 'NOTIFIKASI',
    },
    'notifyBluetooth': {
      AppLanguage.english: 'NOTIFY • BLUETOOTH',
      AppLanguage.indonesia: 'NOTIFIKASI • BLUETOOTH',
    },
    'notifySync': {
      AppLanguage.english: 'NOTIFY • SYNC',
      AppLanguage.indonesia: 'NOTIFIKASI • SINKRONISASI',
    },
    'notifyError': {
      AppLanguage.english: 'NOTIFY • ERROR',
      AppLanguage.indonesia: 'NOTIFIKASI • KESALAHAN',
    },
    'notifyWarning': {
      AppLanguage.english: 'NOTIFY • WARNING',
      AppLanguage.indonesia: 'NOTIFIKASI • PERINGATAN',
    },
    'error': {
      AppLanguage.english: 'ERROR',
      AppLanguage.indonesia: 'KESALAHAN',
    },
    'connecting': {
      AppLanguage.english: 'CONNECTING',
      AppLanguage.indonesia: 'MENGHUBUNGKAN',
    },
    'syncing': {
      AppLanguage.english: 'SYNCING',
      AppLanguage.indonesia: 'MENYINKRONKAN',
    },
    'online': {
      AppLanguage.english: 'ONLINE',
      AppLanguage.indonesia: 'ONLINE',
    },
    'offline': {
      AppLanguage.english: 'OFFLINE',
      AppLanguage.indonesia: 'OFFLINE',
    },
    'thermal': {
      AppLanguage.english: 'Thermal',
      AppLanguage.indonesia: 'Termal',
    },
    'hotsideLimit': {
      AppLanguage.english: 'Hotside Limit',
      AppLanguage.indonesia: 'Batas Suhu Panas',
    },
    'batteryZones': {
      AppLanguage.english: 'Battery Zones',
      AppLanguage.indonesia: 'Zona Baterai',
    },
    'fiveVCeiling': {
      AppLanguage.english: '5V Ceiling',
      AppLanguage.indonesia: 'Batas Atas 5V',
    },
    'twelveVFloor': {
      AppLanguage.english: '12V Floor',
      AppLanguage.indonesia: 'Batas Bawah 12V',
    },
    'range': {
      AppLanguage.english: 'Range',
      AppLanguage.indonesia: 'Rentang',
    },
    'zone9v': {
      AppLanguage.english: '9V Zone',
      AppLanguage.indonesia: 'Zona 9V',
    },
    'lockedAdaptive': {
      AppLanguage.english: 'Locked in Adaptive.',
      AppLanguage.indonesia: 'Terkunci dalam Mode Adaptif.',
    },
    'lowMode': {
      AppLanguage.english: 'Low Mode',
      AppLanguage.indonesia: 'Mode Rendah',
    },
    'midMode': {
      AppLanguage.english: 'Mid Mode',
      AppLanguage.indonesia: 'Mode Sedang',
    },
    'highMode': {
      AppLanguage.english: 'High Mode',
      AppLanguage.indonesia: 'Mode Tinggi',
    },
    'hotsideProtection': {
      AppLanguage.english: 'Hotside Protection',
      AppLanguage.indonesia: 'Perlindungan Suhu Panas',
    },
    'hotsideBattery': {
      AppLanguage.english: 'Hotside + Battery',
      AppLanguage.indonesia: 'Suhu Panas + Baterai',
    },
    'peltierSafety': {
      AppLanguage.english: 'Peltier Safety',
      AppLanguage.indonesia: 'Keamanan Peltier',
    },
    'fanRequiredPeltier': {
      AppLanguage.english: 'Fan must be running before Peltier can be enabled.',
      AppLanguage.indonesia: 'Kipas harus menyala sebelum Peltier dapat diaktifkan.',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.indonesia: 'Batal',
    },
    'turnOnFan': {
      AppLanguage.english: 'Turn On Fan',
      AppLanguage.indonesia: 'Nyalakan Kipas',
    },
    'current': {
      AppLanguage.english: 'Current',
      AppLanguage.indonesia: 'Saat Ini',
    },
    'latest': {
      AppLanguage.english: 'Latest',
      AppLanguage.indonesia: 'Terbaru',
    },
    'updateAvailable': {
      AppLanguage.english: 'Update available.',
      AppLanguage.indonesia: 'Pembaruan tersedia.',
    },
    'waitingDevice': {
      AppLanguage.english: 'Waiting for device...',
      AppLanguage.indonesia: 'Menunggu perangkat...',
    },
    'upToDate': {
      AppLanguage.english: 'Up to date.',
      AppLanguage.indonesia: 'Sudah terbaru.',
    },
    'metadataUnavailable': {
      AppLanguage.english: 'Firmware metadata unavailable.',
      AppLanguage.indonesia: 'Metadata firmware tidak tersedia.',
    },
    'password': {
      AppLanguage.english: 'Password',
      AppLanguage.indonesia: 'Kata Sandi',
    },
    'ssid': {
      AppLanguage.english: 'SSID',
      AppLanguage.indonesia: 'SSID',
    },
    'savedSecurely': {
      AppLanguage.english: 'Saved securely.',
      AppLanguage.indonesia: 'Disimpan dengan aman.',
    },
    'otaStartRejected': {
      AppLanguage.english: 'OTA start rejected.',
      AppLanguage.indonesia: 'Mulai OTA ditolak.',
    },
    'otaInProgress': {
      AppLanguage.english: 'OTA in progress.',
      AppLanguage.indonesia: 'OTA sedang berlangsung.',
    },
    'systemReady': {
      AppLanguage.english: 'System ready.',
      AppLanguage.indonesia: 'Sistem siap.',
    },
    'connectingDevice': {
      AppLanguage.english: 'Connecting to device...',
      AppLanguage.indonesia: 'Menghubungkan ke perangkat...',
    },
    'scanning': {
      AppLanguage.english: 'Scanning...',
      AppLanguage.indonesia: 'Memindai...',
    },
    'bluetoothNotReady': {
      AppLanguage.english: 'Bluetooth is not ready.',
      AppLanguage.indonesia: 'Bluetooth belum siap.',
    },
    'connectFirst': {
      AppLanguage.english: 'Connect to JE X FYZ first.',
      AppLanguage.indonesia: 'Hubungkan ke JE X FYZ terlebih dahulu.',
    },
    'manual': {
      AppLanguage.english: 'Manual',
      AppLanguage.indonesia: 'Manual',
    },
    'auto': {
      AppLanguage.english: 'Auto',
      AppLanguage.indonesia: 'Otomatis',
    },
    'on': {
      AppLanguage.english: 'ON',
      AppLanguage.indonesia: 'AKTIF',
    },
    'off': {
      AppLanguage.english: 'OFF',
      AppLanguage.indonesia: 'NONAKTIF',
    },
    'hSideProtection': {
      AppLanguage.english: 'Hotside Protection',
      AppLanguage.indonesia: 'Perlindungan Suhu Panas',
    },
    'hSideBattery': {
      AppLanguage.english: 'Hotside + Battery',
      AppLanguage.indonesia: 'Suhu Panas + Baterai',
    },
    'batteryTemperature': {
      AppLanguage.english: 'Battery Temperature',
      AppLanguage.indonesia: 'Suhu Baterai',
    },
    'hotsideTemperature': {
      AppLanguage.english: 'Hotside Temperature',
      AppLanguage.indonesia: 'Suhu Panas',
    },
    'fanSpeed': {
      AppLanguage.english: 'Fan Speed',
      AppLanguage.indonesia: 'Kecepatan Kipas',
    },
    'resetTemperature': {
      AppLanguage.english: 'Reset Temperature',
      AppLanguage.indonesia: 'Atur Ulang Temperatur',
    },
    'closed': {
      AppLanguage.english: 'Close',
      AppLanguage.indonesia: 'Tutup',
    },
    'retry': {
      AppLanguage.english: 'Retry',
      AppLanguage.indonesia: 'Coba Lagi',
    },
    'update': {
      AppLanguage.english: 'Update',
      AppLanguage.indonesia: 'Perbarui',
    },
    'scan': {
      AppLanguage.english: 'Scan',
      AppLanguage.indonesia: 'Pindai',
    },
    'connectionReady': {
      AppLanguage.english: 'Connection ready.',
      AppLanguage.indonesia: 'Koneksi siap.',
    },
    'connectionAccessRequired': {
      AppLanguage.english: 'Connection access required.',
      AppLanguage.indonesia: 'Izin koneksi diperlukan.',
    },
    'deviceNotFound': {
      AppLanguage.english: 'JE X FYZ was not found.',
      AppLanguage.indonesia: 'JE X FYZ tidak ditemukan.',
    },
    'scanFailed': {
      AppLanguage.english: 'Scan failed.',
      AppLanguage.indonesia: 'Pemindaian gagal.',
    },
    'officialBuildFailed': {
      AppLanguage.english: 'This application cannot continue because its integrity check failed.',
      AppLanguage.indonesia: 'Aplikasi ini tidak dapat dilanjutkan karena pemeriksaan integritas gagal.',
    },
    'exit': {
      AppLanguage.english: 'Exit',
      AppLanguage.indonesia: 'Keluar',
    },
    'connection': {
      AppLanguage.english: 'Connection',
      AppLanguage.indonesia: 'Koneksi',
    },
    'devices': {
      AppLanguage.english: 'Devices',
      AppLanguage.indonesia: 'Perangkat',
    },
    'connectionUnavailable': {
      AppLanguage.english: 'Connection unavailable.',
      AppLanguage.indonesia: 'Koneksi tidak tersedia.',
    },
    'bluetoothOn': {
      AppLanguage.english: 'Bluetooth ON',
      AppLanguage.indonesia: 'Bluetooth AKTIF',
    },
    'bluetoothOff': {
      AppLanguage.english: 'Bluetooth OFF',
      AppLanguage.indonesia: 'Bluetooth NONAKTIF',
    },
    'locationOn': {
      AppLanguage.english: 'Location ON',
      AppLanguage.indonesia: 'Lokasi AKTIF',
    },
    'locationOff': {
      AppLanguage.english: 'Location OFF',
      AppLanguage.indonesia: 'Lokasi NONAKTIF',
    },
    'disconnect': {
      AppLanguage.english: 'Disconnect',
      AppLanguage.indonesia: 'Putuskan',
    },
    'developedByHorizon': {
      AppLanguage.english: 'DEVELOPED BY HORIZON',
      AppLanguage.indonesia: 'DIKEMBANGKAN OLEH HORIZON',
    },
    'connectionFailed': {
      AppLanguage.english: 'Connection failed.',
      AppLanguage.indonesia: 'Koneksi gagal.',
    },
    'connectionNeedsAccess': {
      AppLanguage.english: 'Connection needs access.',
      AppLanguage.indonesia: 'Akses koneksi diperlukan.',
    },
    'bleServiceDiscoveryFailed': {
      AppLanguage.english: 'JE X FYZ BLE service discovery failed.',
      AppLanguage.indonesia: 'Pencarian layanan BLE JE X FYZ gagal.',
    },
    'bleSyncFailed': {
      AppLanguage.english: 'BLE sync failed.',
      AppLanguage.indonesia: 'Sinkronisasi BLE gagal.',
    },
    'bleHandshakeWriteFailed': {
      AppLanguage.english: 'BLE session handshake write failed.',
      AppLanguage.indonesia: 'Penulisan jabat tangan sesi BLE gagal.',
    },
    'bleSessionNotReady': {
      AppLanguage.english: 'BLE session not ready.',
      AppLanguage.indonesia: 'Sesi BLE belum siap.',
    },
    'fullSyncFailed': {
      AppLanguage.english: 'Final Full Sync failed.',
      AppLanguage.indonesia: 'Sinkronisasi penuh akhir gagal.',
    },
    'floatingPermissionTitle': {
      AppLanguage.english: 'Floating Monitor Permission',
      AppLanguage.indonesia: 'Izin Floating Monitor',
    },
    'floatingPermissionMessage': {
      AppLanguage.english: 'JE X FYZ needs permission to display the Floating Monitor over other apps. Android will open the display-over-other-apps setting.',
      AppLanguage.indonesia: 'JE X FYZ memerlukan izin untuk menampilkan Floating Monitor di atas aplikasi lain. Android akan membuka pengaturan tampilan di atas aplikasi lain.',
    },
    'overlayPermissionDenied': {
      AppLanguage.english: 'Overlay permission was not granted.',
      AppLanguage.indonesia: 'Izin tampilan mengambang belum diberikan.',
    },
    'overlaySettingsFailed': {
      AppLanguage.english: 'Android overlay permission settings could not be opened.',
      AppLanguage.indonesia: 'Pengaturan izin tampilan mengambang Android tidak dapat dibuka.',
    },
    'floatingStartFailed': {
      AppLanguage.english: 'Floating Monitor could not be started.',
      AppLanguage.indonesia: 'Floating Monitor tidak dapat dijalankan.',
    },
    'synchronizingDevice': {
      AppLanguage.english: 'Synchronizing device...',
      AppLanguage.indonesia: 'Menyinkronkan perangkat...',
    },
    'validatingTemperature': {
      AppLanguage.english: 'Validating temperature...',
      AppLanguage.indonesia: 'Memvalidasi suhu...',
    },
    'sensorErrorCoolingLocked': {
      AppLanguage.english: 'Temperature sensor error. Cooling locked.',
      AppLanguage.indonesia: 'Kesalahan sensor suhu. Pendinginan dikunci.',
    },
    'hotsideProtectionActive': {
      AppLanguage.english: 'Hotside protection active. Peltier paused.',
      AppLanguage.indonesia: 'Perlindungan hotside aktif. Peltier dijeda.',
    },
    'voltageSetTo': {
      AppLanguage.english: 'Voltage set to ',
      AppLanguage.indonesia: 'Tegangan diatur ke ',
    },
    'fanOn': {
      AppLanguage.english: 'Fan ON.',
      AppLanguage.indonesia: 'Kipas AKTIF.',
    },
    'fanOff': {
      AppLanguage.english: 'Fan OFF.',
      AppLanguage.indonesia: 'Kipas NONAKTIF.',
    },
    'peltierOn': {
      AppLanguage.english: 'Peltier ON.',
      AppLanguage.indonesia: 'Peltier AKTIF.',
    },
    'peltierOff': {
      AppLanguage.english: 'Peltier OFF.',
      AppLanguage.indonesia: 'Peltier NONAKTIF.',
    },
    'adaptiveOn': {
      AppLanguage.english: 'Adaptive ON.',
      AppLanguage.indonesia: 'Adaptive AKTIF.',
    },
    'adaptiveOff': {
      AppLanguage.english: 'Adaptive OFF.',
      AppLanguage.indonesia: 'Adaptive NONAKTIF.',
    },
    'ledOn': {
      AppLanguage.english: 'LED ON.',
      AppLanguage.indonesia: 'LED AKTIF.',
    },
    'ledOff': {
      AppLanguage.english: 'LED OFF.',
      AppLanguage.indonesia: 'LED NONAKTIF.',
    },
    'modeUpdated': {
      AppLanguage.english: 'Mode updated.',
      AppLanguage.indonesia: 'Mode diperbarui.',
    },
    'brightnessUpdated': {
      AppLanguage.english: 'Brightness updated.',
      AppLanguage.indonesia: 'Kecerahan diperbarui.',
    },
    'colorUpdated': {
      AppLanguage.english: 'Color updated.',
      AppLanguage.indonesia: 'Warna diperbarui.',
    },
    'temperatureReset': {
      AppLanguage.english: 'Temperature reset.',
      AppLanguage.indonesia: 'Temperatur diatur ulang.',
    },
    'commandNotConfirmed': {
      AppLanguage.english: 'Device did not confirm the command.',
      AppLanguage.indonesia: 'Perangkat tidak mengonfirmasi perintah.',
    },
    'commandFailed': {
      AppLanguage.english: 'Command failed.',
      AppLanguage.indonesia: 'Perintah gagal.',
    },
    'firmware': {
      AppLanguage.english: 'Firmware',
      AppLanguage.indonesia: 'Firmware',
    },
    'firmwareMetadataCheckFailed': {
      AppLanguage.english: 'Firmware metadata unavailable. Check Firebase read access.',
      AppLanguage.indonesia: 'Metadata firmware tidak tersedia. Periksa akses baca Firebase.',
    },
    'leftRight': {
      AppLanguage.english: 'Left ↔ Right',
      AppLanguage.indonesia: 'Kiri ↔ Kanan',
    },
    'adaptiveSwitch': {
      AppLanguage.english: 'Adaptive Switch',
      AppLanguage.indonesia: 'Sakelar Adaptif',
    },
    'ledModeStatic': { AppLanguage.english: 'Static', AppLanguage.indonesia: 'Statis' },
    'ledModeBreath': { AppLanguage.english: 'Breath', AppLanguage.indonesia: 'Napas' },
    'ledModeCenterOut': { AppLanguage.english: 'Center Out', AppLanguage.indonesia: 'Dari Tengah' },
    'ledModeOuterIn': { AppLanguage.english: 'Outer In', AppLanguage.indonesia: 'Dari Luar' },
    'ledModeDualChase': { AppLanguage.english: 'Dual Chase', AppLanguage.indonesia: 'Kejar Ganda' },
    'ledModeRainbow': { AppLanguage.english: 'Rainbow', AppLanguage.indonesia: 'Pelangi' },
    'languageEnglish': { AppLanguage.english: 'English', AppLanguage.indonesia: 'Inggris' },
    'languageIndonesia': { AppLanguage.english: 'Bahasa Indonesia', AppLanguage.indonesia: 'Bahasa Indonesia' },
    'horizontal': { AppLanguage.english: 'Horizontal', AppLanguage.indonesia: 'Horizontal' },
    'vertical': { AppLanguage.english: 'Vertical', AppLanguage.indonesia: 'Vertikal' },
    'location': { AppLanguage.english: 'Location', AppLanguage.indonesia: 'Lokasi' },
    'currentValue': { AppLanguage.english: 'Current', AppLanguage.indonesia: 'Saat Ini' },
    'latestValue': { AppLanguage.english: 'Latest', AppLanguage.indonesia: 'Terbaru' },
    'updateAvailableSentence': { AppLanguage.english: 'Update available.', AppLanguage.indonesia: 'Pembaruan tersedia.' },
    'waitingForDevice': { AppLanguage.english: 'Waiting for device...', AppLanguage.indonesia: 'Menunggu perangkat...' },
    'upToDateSentence': { AppLanguage.english: 'Up to date.', AppLanguage.indonesia: 'Sudah terbaru.' },
    'savedSecurelySentence': { AppLanguage.english: 'Saved securely.', AppLanguage.indonesia: 'Disimpan dengan aman.' },
    'firmwareMetadataUnavailableSentence': { AppLanguage.english: 'Firmware metadata unavailable. Check Firebase read access.', AppLanguage.indonesia: 'Metadata firmware tidak tersedia. Periksa akses baca Firebase.' },
    'close': { AppLanguage.english: 'Close', AppLanguage.indonesia: 'Tutup' },
    'retry': { AppLanguage.english: 'Retry', AppLanguage.indonesia: 'Coba Lagi' },
    'updateAction': { AppLanguage.english: 'Update', AppLanguage.indonesia: 'Perbarui' },
    'currentVersion': { AppLanguage.english: 'Current', AppLanguage.indonesia: 'Saat Ini' },
    'latestVersion': { AppLanguage.english: 'Latest', AppLanguage.indonesia: 'Terbaru' },
  };

  static String phrase(
    String english,
    String indonesia, [
    AppLanguage? language,
  ]) {
    return (language ?? appLanguageNotifier.value) == AppLanguage.english
        ? english
        : indonesia;
  }

  static String of(String key, [AppLanguage? language]) {
    final lang = language ?? appLanguageNotifier.value;
    return _values[key]?[lang] ?? key;
  }
}

ThemeData buildJexTheme(AppThemePreset preset) {
  switch (preset) {
    case AppThemePreset.light:
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4D8CFF),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      );
    case AppThemePreset.dark:
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101114),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C9DFF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        cardColor: const Color(0xFF1A1B20),
      );
    case AppThemePreset.defaultTheme:
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF5C9DFF),
        scaffoldBackgroundColor: const Color(0xFF0F1013),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C9DFF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        cardColor: const Color(0xFF191B20),
        dividerColor: const Color(0xFF2B2E35),
      );
  }
}

