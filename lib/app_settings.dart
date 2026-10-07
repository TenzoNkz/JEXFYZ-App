// AI-MEMORY / FILE CONTRACT
// File: app_settings.dart
// Owns: persisted App preferences, language/theme notifiers, and the single JexText localization table.
// Localization contract: language names are English/Indonesia; English power states are ON/OFF;
// Indonesian power states are HIDUP/MATI.
// Technical identifiers (BLE, P1, OTA, RGB, LED, NTC, FPS) remain untranslated.
// BLE protocol tokens are never localized here; this file only defines user-facing presentation.
// Storage keys are compatibility contracts and must not be changed casually.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// All user-facing application strings are resolved through JexText for full language coverage.
enum AppLanguage { english, indonesia }
enum AppThemePreset { defaultTheme, light, dark }

// AI-MEMORY / MODEL CONTRACT
// AppSettings is the persisted UI preference model. It must remain independent from
// live device telemetry so reconnects never replay local control state into firmware.
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
    // New installs default to Manual; an existing saved preference is preserved.
    this.autoConnect = false,
  });

  // AI-METHOD / COPY CONTRACT
  // Creates an immutable preference variant without changing persisted storage until save()
  // is explicitly called by the settings store.
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

  // AI-METHOD / SERIALIZATION CONTRACT
  // Serialize only persisted application preferences. Storage names are compatibility keys.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language.name,
        'theme': theme.name,
        'notifySafety': notifySafety,
        'notifyFirmware': notifyFirmware,
        'notifyBluetooth': notifyBluetooth,
        'autoConnect': autoConnect,
      };

  // AI-METHOD / DESERIALIZATION CONTRACT
  // Parse persisted preferences defensively; malformed or missing data falls back to defaults.
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
        // Missing/malformed Auto Connect preference falls back to the new Manual default.
        autoConnect: decoded['autoConnect'] is bool ? decoded['autoConnect'] as bool : false,
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
final ValueNotifier<bool> appAutoConnectNotifier = ValueNotifier<bool>(false);
final ValueNotifier<String?> knownCoolerRemoteIdNotifier = ValueNotifier<String?>(null);

// AI-MEMORY / STORE CONTRACT
// AppSettingsStore is the only persistence boundary for application-level settings.
class AppSettingsStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'jexfyz_app_settings_v2';
  static const String _firmwareNoticeKey = 'jexfyz_last_firmware_notice';

  // AI-METHOD / LOAD CONTRACT
  // Read secure storage, decode the model, and publish the values through the global notifiers.
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

  // AI-METHOD / SAVE CONTRACT
  // Publish settings immediately, then persist the exact same model to secure storage.
  static Future<void> save(AppSettings settings) async {
    _apply(settings);
    try {
      await _storage.write(key: _key, value: jsonEncode(settings.toJson()));
    } catch (_) {}
  }

  // AI-METHOD / APPLY CONTRACT
  // Synchronize persisted preference values into the notifiers consumed by the UI.
  static void _apply(AppSettings settings) {
    appLanguageNotifier.value = settings.language;
    appThemeNotifier.value = settings.theme;
    appNotifySafetyNotifier.value = settings.notifySafety;
    appNotifyFirmwareNotifier.value = settings.notifyFirmware;
    appNotifyBluetoothNotifier.value = settings.notifyBluetooth;
    appAutoConnectNotifier.value = settings.autoConnect;
  }

  // AI-METHOD / FIRMWARE-NOTICE CONTRACT
  // Prevent repeated firmware-update notifications for the same version string.
  static Future<bool> shouldNotifyFirmware(String version) async {
    if (version.trim().isEmpty) return false;
    try {
      final last = await _storage.read(key: _firmwareNoticeKey);
      return last != version;
    } catch (_) {
      return true;
    }
  }

  // AI-METHOD / FIRMWARE-NOTICE CONTRACT
  // Persist the version after its notification has been handled.
  static Future<void> markFirmwareNotified(String version) async {
    try {
      await _storage.write(key: _firmwareNoticeKey, value: version);
    } catch (_) {}
  }
}


// AI-MEMORY / KNOWN-COOLER-CONTRACT
// Persists only the identity of a cooler that completed a real BLE/P1 session.
// Auto Connect may use this identity, but it never grants BLE permission or powers Bluetooth on.
class KnownCoolerStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'jexfyz_known_cooler_remote_id_v1';

  // AI-METHOD / LOAD-CONTRACT
  // Load the last cooler identity without prompting the user or touching Bluetooth state.
  static Future<String?> load() async {
    try {
      final raw = await _storage.read(key: _key);
      final value = raw?.trim();
      knownCoolerRemoteIdNotifier.value =
          value == null || value.isEmpty ? null : value;
      return knownCoolerRemoteIdNotifier.value;
    } catch (_) {
      knownCoolerRemoteIdNotifier.value = null;
      return null;
    }
  }

  // AI-METHOD / SAVE-CONTRACT
  // Save only after a complete BLE/P1 session has succeeded.
  static Future<void> save(String remoteId) async {
    final value = remoteId.trim();
    if (value.isEmpty) return;
    knownCoolerRemoteIdNotifier.value = value;
    try {
      await _storage.write(key: _key, value: value);
    } catch (_) {}
  }

  // AI-METHOD / CLEAR-CONTRACT
  // Explicitly forget the known cooler identity; no Bluetooth operation is performed here.
  static Future<void> clear() async {
    knownCoolerRemoteIdNotifier.value = null;
    try {
      await _storage.delete(key: _key);
    } catch (_) {}
  }
}

// AI-MEMORY / LOCALIZATION CONTRACT
// Every visible application string must come from this table or JexText.phrase().
// Never translate frozen protocol tokens such as FAN:ON or RGB:OFF.
// Power-state presentation is English ON/OFF and Indonesian HIDUP/MATI.
// Language-selector presentation is always English / Indonesia.
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
      AppLanguage.english: 'Indonesia',
      AppLanguage.indonesia: 'Indonesia',
    },
    'appearance': {
      AppLanguage.english: 'Appearance',
      AppLanguage.indonesia: 'Tampilan',
    },
    'default': {
      AppLanguage.english: 'Default',
      AppLanguage.indonesia: 'Bawaan',
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
      AppLanguage.indonesia: 'Suhu',
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
    'brightness': {
      AppLanguage.english: 'Brightness',
      AppLanguage.indonesia: 'Kecerahan',
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
      AppLanguage.indonesia: 'Transparansi',
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
      AppLanguage.indonesia: 'Hotside',
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
      AppLanguage.indonesia: 'Indikator Tegangan',
    },
    'adaptiveMode': {
      AppLanguage.english: 'Adaptive Mode',
      AppLanguage.indonesia: 'Mode Adaptif',
    },
    'peltierSwitch': {
      AppLanguage.english: 'Peltier Switch',
      AppLanguage.indonesia: 'Sakelar Peltier',
    },
    'fanSwitch': {
      AppLanguage.english: 'Fan Switch',
      AppLanguage.indonesia: 'Sakelar Kipas',
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
      AppLanguage.indonesia: 'Batas Hotside',
    },
    'batteryZones': {
      AppLanguage.english: 'Battery Zones',
      AppLanguage.indonesia: 'Zona Baterai',
    },
    'fiveVCeiling': {
      AppLanguage.english: '5V Limit',
      AppLanguage.indonesia: 'Batas 5V',
    },
    'twelveVFloor': {
      AppLanguage.english: '12V Limit',
      AppLanguage.indonesia: 'Batas 12V',
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
      AppLanguage.english: 'Locked while Adaptive Mode is active.',
      AppLanguage.indonesia: 'Terkunci saat Mode Adaptif aktif.',
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
      AppLanguage.indonesia: 'Perlindungan Hotside',
    },
    'hotsideBattery': {
      AppLanguage.english: 'Hotside + Battery',
      AppLanguage.indonesia: 'Hotside + Baterai',
    },
    'peltierSafety': {
      AppLanguage.english: 'Peltier Safety',
      AppLanguage.indonesia: 'Keamanan Peltier',
    },
    'fanRequiredPeltier': {
      AppLanguage.english: 'Fan must be running before Peltier can be enabled.',
      AppLanguage.indonesia: 'Kipas harus aktif sebelum Peltier dapat dimulai.',
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
      AppLanguage.english: 'OTA start was rejected.',
      AppLanguage.indonesia: 'Permintaan OTA ditolak.',
    },
    'otaInProgress': {
      AppLanguage.english: 'OTA is in progress.',
      AppLanguage.indonesia: 'OTA sedang berlangsung.',
    },
    'otaUpToDate': {
      AppLanguage.english: 'OTA is already up to date.',
      AppLanguage.indonesia: 'Firmware sudah versi terbaru.',
    },
    'otaReconnectFailed': {
      AppLanguage.english: 'OTA finished, but BLE recovery could not reconnect.',
      AppLanguage.indonesia: 'OTA selesai, tetapi BLE tidak dapat tersambung kembali.',
    },
    'systemReady': {
      AppLanguage.english: 'System ready.',
      AppLanguage.indonesia: 'Sistem siap.',
    },
    'deviceStatusUpdate': {
      AppLanguage.english: 'Device status updated.',
      AppLanguage.indonesia: 'Status perangkat diperbarui.',
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
      AppLanguage.indonesia: 'HIDUP',
    },
    'off': {
      AppLanguage.english: 'OFF',
      AppLanguage.indonesia: 'MATI',
    },
    'hSideProtection': {
      AppLanguage.english: 'Hotside Protection',
      AppLanguage.indonesia: 'Perlindungan Hotside',
    },
    'hSideBattery': {
      AppLanguage.english: 'Hotside + Battery',
      AppLanguage.indonesia: 'Hotside + Baterai',
    },
    'batteryTemperature': {
      AppLanguage.english: 'Battery Temperature',
      AppLanguage.indonesia: 'Suhu Baterai',
    },
    'hotsideTemperature': {
      AppLanguage.english: 'Hotside Temperature',
      AppLanguage.indonesia: 'Suhu Hotside',
    },
    'fanSpeed': {
      AppLanguage.english: 'Fan Speed',
      AppLanguage.indonesia: 'Kecepatan Kipas',
    },
    'resetTemperature': {
      AppLanguage.english: 'Reset Temperature Settings',
      AppLanguage.indonesia: 'Atur Ulang Pengaturan Suhu',
    },
    'hotsideLimitNotConfirmed': {
      AppLanguage.english: 'Hotside limit was not confirmed.',
      AppLanguage.indonesia: 'Batas Hotside tidak terkonfirmasi.',
    },
    'hotsideLimitFailed': {
      AppLanguage.english: 'Hotside limit update failed.',
      AppLanguage.indonesia: 'Gagal memperbarui batas Hotside.',
    },
    'battery5LimitNotConfirmed': {
      AppLanguage.english: '5V battery limit not confirmed.',
      AppLanguage.indonesia: 'Batas baterai 5V tidak terkonfirmasi.',
    },
    'battery5LimitFailed': {
      AppLanguage.english: '5V battery limit failed.',
      AppLanguage.indonesia: 'Gagal memperbarui batas baterai 5V.',
    },
    'battery12LimitNotConfirmed': {
      AppLanguage.english: '12V battery limit not confirmed.',
      AppLanguage.indonesia: 'Batas baterai 12V tidak terkonfirmasi.',
    },
    'battery12LimitFailed': {
      AppLanguage.english: '12V battery limit failed.',
      AppLanguage.indonesia: 'Gagal memperbarui batas baterai 12V.',
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
    'notificationSafetyDescription': {
      AppLanguage.english: 'Notify when Hotside reaches the set limit.',
      AppLanguage.indonesia: 'Beri tahu saat Hotside mencapai batas yang ditetapkan.',
    },
    'otaFailed': {
      AppLanguage.english: 'OTA failed.',
      AppLanguage.indonesia: 'OTA gagal.',
    },
    'otaSuccessful': {
      AppLanguage.english: 'OTA successful.',
      AppLanguage.indonesia: 'OTA berhasil.',
    },
    'otaProgress': {
      AppLanguage.english: 'OTA in progress • ',
      AppLanguage.indonesia: 'OTA sedang berlangsung • ',
    },
    'adaptiveCeiling': {
      AppLanguage.english: 'Adaptive Limit',
      AppLanguage.indonesia: 'Batas Adaptif',
    },
    'resetBrownout': {
      AppLanguage.english: 'Power supply dropped. Device restarted.',
      AppLanguage.indonesia: 'Tegangan suplai turun. Perangkat dimulai ulang.',
    },
    'resetPanic': {
      AppLanguage.english: 'System error caused a restart.',
      AppLanguage.indonesia: 'Kesalahan sistem menyebabkan perangkat dimulai ulang.',
    },
    'resetSoftware': {
      AppLanguage.english: 'System restarted.',
      AppLanguage.indonesia: 'Sistem dimulai ulang.',
    },
    'resetWatchdog': {
      AppLanguage.english: 'System recovered after a watchdog reset.',
      AppLanguage.indonesia: 'Sistem pulih setelah reset watchdog.',
    },
    'resetExternal': {
      AppLanguage.english: 'Device restarted.',
      AppLanguage.indonesia: 'Perangkat dimulai ulang.',
    },
    'resetDeepSleep': {
      AppLanguage.english: 'Device resumed from deep sleep.',
      AppLanguage.indonesia: 'Perangkat melanjutkan dari mode deep sleep.',
    },
    'resetPowerOn': {
      AppLanguage.english: 'Device started.',
      AppLanguage.indonesia: 'Perangkat dinyalakan.',
    },
    'ledModeStatic': {
      AppLanguage.english: 'Static',
      AppLanguage.indonesia: 'Statis',
    },
    'ledModeBreath': {
      AppLanguage.english: 'Breath',
      AppLanguage.indonesia: 'Napas',
    },
    'ledModeCenterOut': {
      AppLanguage.english: 'Center Out',
      AppLanguage.indonesia: 'Dari Tengah',
    },
    'ledModeOuterIn': {
      AppLanguage.english: 'Outer In',
      AppLanguage.indonesia: 'Dari Luar',
    },
    'ledModeDualChase': {
      AppLanguage.english: 'Dual Chase',
      AppLanguage.indonesia: 'Kejar Ganda',
    },
    'ledModeRainbow': {
      AppLanguage.english: 'Rainbow',
      AppLanguage.indonesia: 'Pelangi',
    },
    'currentVersion': {
      AppLanguage.english: 'Current',
      AppLanguage.indonesia: 'Saat Ini',
    },
    'latestVersion': {
      AppLanguage.english: 'Latest',
      AppLanguage.indonesia: 'Terbaru',
    },
    'updateAvailableSentence': {
      AppLanguage.english: 'Update available.',
      AppLanguage.indonesia: 'Pembaruan tersedia.',
    },
    'savedSecurelySentence': {
      AppLanguage.english: 'Saved securely.',
      AppLanguage.indonesia: 'Disimpan dengan aman.',
    },
    'close': {
      AppLanguage.english: 'Close',
      AppLanguage.indonesia: 'Tutup',
    },
    'updateAction': {
      AppLanguage.english: 'Update',
      AppLanguage.indonesia: 'Perbarui',
    },
    'horizontal': {
      AppLanguage.english: 'Horizontal',
      AppLanguage.indonesia: 'Horizontal',
    },
    'vertical': {
      AppLanguage.english: 'Vertical',
      AppLanguage.indonesia: 'Vertikal',
    },
    'languageEnglish': {
      AppLanguage.english: 'English',
      AppLanguage.indonesia: 'English',
    },
    'languageIndonesia': {
      AppLanguage.english: 'Indonesia',
      AppLanguage.indonesia: 'Indonesia',
    },
    'appVersion': {
      AppLanguage.english: 'App Version',
      AppLanguage.indonesia: 'Versi Aplikasi',
    },
    'otaFinalizationError': { AppLanguage.english: 'OTA failed: finalization error.', AppLanguage.indonesia: 'OTA gagal: terjadi kesalahan saat finalisasi.' },
    'otaSizeMismatch': { AppLanguage.english: 'OTA failed: upload size mismatch.', AppLanguage.indonesia: 'OTA gagal: ukuran unggahan tidak cocok.' },
    'commandRejected': { AppLanguage.english: 'Command failed.', AppLanguage.indonesia: 'Perintah gagal.' },
    'otaCouldNotStart': { AppLanguage.english: 'OTA could not start: command ', AppLanguage.indonesia: 'OTA tidak dapat dimulai: perintah ' },
    'rejectedByDevice': { AppLanguage.english: ' was rejected by the device.', AppLanguage.indonesia: ' ditolak oleh perangkat.' },
    'otaSuccessfulGeneric': { AppLanguage.english: 'OTA successful: ', AppLanguage.indonesia: 'OTA berhasil: ' },
    'otaFailedGeneric': { AppLanguage.english: 'OTA failed: ', AppLanguage.indonesia: 'OTA gagal: ' },
    'otaUploaded': { AppLanguage.english: 'OTA failed: uploaded ', AppLanguage.indonesia: 'OTA gagal: ukuran unggahan ' },
    'otaBytes': { AppLanguage.english: ' bytes.', AppLanguage.indonesia: ' byte.' },
    'otaLocalSuccessful': { AppLanguage.english: 'Local OTA successful.', AppLanguage.indonesia: 'OTA lokal berhasil.' },
    'allow': { AppLanguage.english: 'Allow', AppLanguage.indonesia: 'Izinkan' },
    'unknownError': { AppLanguage.english: 'Unknown error', AppLanguage.indonesia: 'Kesalahan tidak diketahui' },
    'unknownOtaStage': { AppLanguage.english: 'Unknown stage', AppLanguage.indonesia: 'Tahap tidak diketahui' },
    'otaModeLocal': { AppLanguage.english: 'Local', AppLanguage.indonesia: 'Lokal' },
    'otaModeOnline': { AppLanguage.english: 'Online', AppLanguage.indonesia: 'Online' },
    'otaStageLocalFileCheck': { AppLanguage.english: 'File check', AppLanguage.indonesia: 'Periksa berkas' },
    'otaStageLocalSizeCheck': { AppLanguage.english: 'Size check', AppLanguage.indonesia: 'Periksa ukuran' },
    'otaStageLocalUpdateBegin': { AppLanguage.english: 'Update begin', AppLanguage.indonesia: 'Mulai pembaruan' },
    'otaStageLocalReceive': { AppLanguage.english: 'Receiving', AppLanguage.indonesia: 'Menerima' },
    'otaStageLocalFlashWrite': { AppLanguage.english: 'Flash write', AppLanguage.indonesia: 'Menulis flash' },
    'otaStageLocalSizeVerify': { AppLanguage.english: 'Size verify', AppLanguage.indonesia: 'Verifikasi ukuran' },
    'otaStageLocalFinalize': { AppLanguage.english: 'Finalize', AppLanguage.indonesia: 'Finalisasi' },
    'otaStageLocalFlashReadback': { AppLanguage.english: 'Flash readback', AppLanguage.indonesia: 'Baca ulang flash' },
    'otaStageLocalFlashErase': { AppLanguage.english: 'Flash erase', AppLanguage.indonesia: 'Hapus flash' },
    'otaStageLocalImageVerify': { AppLanguage.english: 'Image verification', AppLanguage.indonesia: 'Verifikasi citra' },
    'otaStageLocalBootPartition': { AppLanguage.english: 'Boot partition', AppLanguage.indonesia: 'Partisi boot' },
    'otaStageOnlineWifiConnect': { AppLanguage.english: 'Wi-Fi connect', AppLanguage.indonesia: 'Hubungkan Wi-Fi' },
    'otaStageOnlineWifiConnected': { AppLanguage.english: 'Wi-Fi connected', AppLanguage.indonesia: 'Wi-Fi terhubung' },
    'otaStageOnlineRequest': {
      AppLanguage.english: 'OTA request',
      AppLanguage.indonesia: 'Permintaan OTA',
    },
    'otaStageOnlineVersionCheck': {
      AppLanguage.english: 'Version check',
      AppLanguage.indonesia: 'Periksa versi',
    },
    'otaStageOnlineUpToDate': {
      AppLanguage.english: 'Already up to date',
      AppLanguage.indonesia: 'Sudah versi terbaru',
    },
    'otaStageOnlineWifiRetry2': {
      AppLanguage.english: 'Wi-Fi retry 2',
      AppLanguage.indonesia: 'Percobaan Wi-Fi 2',
    },
    'otaStageOnlineWifiRetry3': {
      AppLanguage.english: 'Wi-Fi retry 3',
      AppLanguage.indonesia: 'Percobaan Wi-Fi 3',
    },
    'otaStageOnlineWifiFailed': { AppLanguage.english: 'Wi-Fi failed', AppLanguage.indonesia: 'Wi-Fi gagal' },
    'otaStageOnlineWifiDropped': { AppLanguage.english: 'Wi-Fi dropped', AppLanguage.indonesia: 'Wi-Fi terputus' },
    'otaStageOnlineTimeSync': { AppLanguage.english: 'Time sync', AppLanguage.indonesia: 'Sinkronisasi waktu' },
    'otaStageOnlineGithubConnect': { AppLanguage.english: 'GitHub connect', AppLanguage.indonesia: 'Hubungkan GitHub' },
    'otaStageOnlineGithubConnected': { AppLanguage.english: 'GitHub connected', AppLanguage.indonesia: 'GitHub terhubung' },
    'otaStageOnlineHttpUpdate': { AppLanguage.english: 'HTTP update', AppLanguage.indonesia: 'Pembaruan HTTP' },
    'otaStageOnlineUpdateBegin': { AppLanguage.english: 'Update begin', AppLanguage.indonesia: 'Mulai pembaruan' },
    'otaStageOnlineDownload': { AppLanguage.english: 'Download', AppLanguage.indonesia: 'Unduh' },
    'otaStageOnlineDownloadComplete': { AppLanguage.english: 'Download complete', AppLanguage.indonesia: 'Unduhan selesai' },
    'otaStageOnlineFlashPrepare': { AppLanguage.english: 'Prepare flash', AppLanguage.indonesia: 'Siapkan flash' },
    'otaStageOnlineFlashFinalize': { AppLanguage.english: 'Finalize flash', AppLanguage.indonesia: 'Finalisasi flash' },
    'otaStageOnlineFlashSuccess': { AppLanguage.english: 'Flash successful', AppLanguage.indonesia: 'Flash berhasil' },
    'otaStageOnlineRangeProbe': { AppLanguage.english: 'Range probe', AppLanguage.indonesia: 'Uji rentang' },
    'otaStageOnlineRangeRequest': { AppLanguage.english: 'Range request', AppLanguage.indonesia: 'Minta rentang' },
    'otaStageOnlineRangeResponse': { AppLanguage.english: 'Range response', AppLanguage.indonesia: 'Respons rentang' },
    'otaStageOnlineRangeWrite': { AppLanguage.english: 'Range write', AppLanguage.indonesia: 'Tulis rentang' },
    'otaStageOnlineRangeRetry': { AppLanguage.english: 'Range retry', AppLanguage.indonesia: 'Ulangi rentang' },
    'otaStageOnlineRangeResume': { AppLanguage.english: 'Range resume', AppLanguage.indonesia: 'Lanjutkan rentang' },
    'otaStageOnlineFlashWrite': { AppLanguage.english: 'Flash write', AppLanguage.indonesia: 'Menulis flash' },
    'otaStageOnlineFlashErase': { AppLanguage.english: 'Flash erase', AppLanguage.indonesia: 'Hapus flash' },
    'otaStageOnlineFlashReadback': { AppLanguage.english: 'Flash readback', AppLanguage.indonesia: 'Baca ulang flash' },
    'otaStageOnlineImageValidate': { AppLanguage.english: 'Image validation', AppLanguage.indonesia: 'Validasi citra' },
    'otaStageOnlineImageVerify': { AppLanguage.english: 'Image verification', AppLanguage.indonesia: 'Verifikasi citra' },
    'otaStageOnlineBootPartition': { AppLanguage.english: 'Boot partition', AppLanguage.indonesia: 'Partisi boot' },
    'otaStageOnlineHttpResponse': { AppLanguage.english: 'HTTP response', AppLanguage.indonesia: 'Respons HTTP' },
    'notConfirmedSuffix': { AppLanguage.english: 'not confirmed.', AppLanguage.indonesia: 'tidak dikonfirmasi.' },
    'failedSuffix': { AppLanguage.english: 'failed.', AppLanguage.indonesia: 'gagal.' },

    'notificationFirmwareDescription': {
      AppLanguage.english: 'Notify when a firmware update is available.',
      AppLanguage.indonesia: 'Beri tahu saat pembaruan firmware tersedia.',
    },
    'notificationBluetoothDescription': {
      AppLanguage.english: 'Notify when JE X FYZ connects or disconnects.',
      AppLanguage.indonesia: 'Beri tahu saat JE X FYZ terhubung atau terputus.',
    },
    'autoConnectDescription': {
      AppLanguage.english: 'Connect to JE X FYZ automatically when it is advertising.',
      AppLanguage.indonesia: 'Hubungkan JE X FYZ secara otomatis saat perangkat menyiarkan sinyal.',
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
      AppLanguage.indonesia: 'Bluetooth HIDUP',
    },
    'bluetoothOff': {
      AppLanguage.english: 'Bluetooth OFF',
      AppLanguage.indonesia: 'Bluetooth MATI',
    },
    'locationOn': {
      AppLanguage.english: 'Location ON',
      AppLanguage.indonesia: 'Lokasi HIDUP',
    },
    'locationOff': {
      AppLanguage.english: 'Location OFF',
      AppLanguage.indonesia: 'Lokasi MATI',
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
      AppLanguage.indonesia: 'Penulisan handshake sesi BLE gagal.',
    },
    'bleSessionNotReady': {
      AppLanguage.english: 'BLE session not ready.',
      AppLanguage.indonesia: 'Sesi BLE belum siap.',
    },
    'fullSyncFailed': {
      AppLanguage.english: 'Full Sync failed.',
      AppLanguage.indonesia: 'Sinkronisasi penuh gagal.',
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
      AppLanguage.english: 'Temperature sensor error. Cooling is locked.',
      AppLanguage.indonesia: 'Sensor suhu bermasalah. Pendinginan dikunci.',
    },
    'hotsideProtectionActive': {
      AppLanguage.english: 'Hotside protection is active. Peltier is paused.',
      AppLanguage.indonesia: 'Perlindungan Hotside aktif. Peltier dijeda.',
    },
    'voltageSetTo': {
      AppLanguage.english: 'Voltage set to ',
      AppLanguage.indonesia: 'Tegangan diatur ke ',
    },
    'fanOn': {
      AppLanguage.english: 'Fan ON.',
      AppLanguage.indonesia: 'Kipas aktif.',
    },
    'fanOff': {
      AppLanguage.english: 'Fan OFF.',
      AppLanguage.indonesia: 'Kipas nonaktif.',
    },
    'peltierOn': {
      AppLanguage.english: 'Peltier ON.',
      AppLanguage.indonesia: 'Peltier aktif.',
    },
    'peltierOff': {
      AppLanguage.english: 'Peltier OFF.',
      AppLanguage.indonesia: 'Peltier nonaktif.',
    },
    'adaptiveOn': {
      AppLanguage.english: 'Adaptive ON.',
      AppLanguage.indonesia: 'Mode Adaptif aktif.',
    },
    'adaptiveOff': {
      AppLanguage.english: 'Adaptive OFF.',
      AppLanguage.indonesia: 'Mode Adaptif nonaktif.',
    },
    'ledOn': {
      AppLanguage.english: 'LED ON.',
      AppLanguage.indonesia: 'LED aktif.',
    },
    'ledOff': {
      AppLanguage.english: 'LED OFF.',
      AppLanguage.indonesia: 'LED nonaktif.',
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
      AppLanguage.english: 'Temperature settings reset.',
      AppLanguage.indonesia: 'Pengaturan suhu diatur ulang.',
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
    'mode': {
      AppLanguage.english: 'Mode',
      AppLanguage.indonesia: 'Mode',
    },
    'adaptiveProfile': {
      AppLanguage.english: 'Profile',
      AppLanguage.indonesia: 'Profil',
    },
    'adaptiveSwitch': {
      AppLanguage.english: 'Adaptive Switch',
      AppLanguage.indonesia: 'Sakelar Adaptif',
    },
    'location': { AppLanguage.english: 'Location', AppLanguage.indonesia: 'Lokasi' },
    'currentValue': { AppLanguage.english: 'Current', AppLanguage.indonesia: 'Saat Ini' },
    'latestValue': { AppLanguage.english: 'Latest', AppLanguage.indonesia: 'Terbaru' },
    'waitingForDevice': { AppLanguage.english: 'Waiting for device...', AppLanguage.indonesia: 'Menunggu perangkat...' },
    'upToDateSentence': { AppLanguage.english: 'Up to date.', AppLanguage.indonesia: 'Sudah terbaru.' },
    'firmwareMetadataUnavailableSentence': { AppLanguage.english: 'Firmware metadata unavailable. Check Firebase read access.', AppLanguage.indonesia: 'Metadata firmware tidak tersedia. Periksa akses baca Firebase.' },
  };

  // AI-METHOD / PHRASE CONTRACT
  // Resolve a two-language inline phrase without changing technical protocol values.
  static String phrase(
    String english,
    String indonesia, [
    AppLanguage? language,
  ]) {
    return (language ?? appLanguageNotifier.value) == AppLanguage.english
        ? english
        : indonesia;
  }

  // AI-METHOD / LOOKUP CONTRACT
  // Resolve one localized UI string; return the key only for an intentionally missing entry.
  static String of(String key, [AppLanguage? language]) {
    final lang = language ?? appLanguageNotifier.value;
    return _values[key]?[lang] ?? key;
  }
}

// AI-METHOD / THEME CONTRACT
// Construct the global Settings theme. Dashboard-specific theme boundaries are handled
// by main.dart so the Default Dashboard can remain black-header/white-content.
ThemeData buildJexTheme(AppThemePreset preset) {
  final isLight = preset == AppThemePreset.light;
  final isDark = !isLight;
  final background = isLight
      ? const Color(0xFFEEF0F4)
      : (preset == AppThemePreset.dark ? const Color(0xFF0C0E12) : const Color(0xFF0F1013));
  final surface = isLight
      ? const Color(0xFFFFFFFF)
      : (preset == AppThemePreset.dark ? const Color(0xFF171A20) : const Color(0xFF191B20));
  // AI-THEME / LIGHT-CONTRAST-CONTRACT
  // Light mode uses near-black semantic text on white/light surfaces, mirroring Android system light mode.
  // Dark mode keeps the inverse relationship: near-white text on dark surfaces.
  final foreground = isDark ? const Color(0xFFF4F6FA) : const Color(0xFF111318);
  final muted = isDark ? const Color(0xFF979DA8) : const Color(0xFF3F444D);
  final primary = isLight ? const Color(0xFF3E72FF) : const Color(0xFF6A9DFF);

  return ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: background,
    canvasColor: background,
    cardColor: surface,
    primaryColor: primary,
    dividerColor: isDark ? const Color(0xFF2A2E36) : const Color(0xFFD7DBE2),
    colorScheme: (isDark ? ColorScheme.dark : ColorScheme.light)(
      primary: primary,
      onPrimary: isDark ? const Color(0xFF07101E) : Colors.white,
      secondary: primary,
      onSecondary: isDark ? Colors.black : Colors.white,
      surface: surface,
      onSurface: foreground,
      onSurfaceVariant: muted,
      surfaceContainerHighest: isDark ? const Color(0xFF242831) : const Color(0xFFE4E7EC),
      outline: isDark ? const Color(0xFF383D47) : const Color(0xFFD6DAE1),
      outlineVariant: isDark ? const Color(0xFF2B3039) : const Color(0xFFDDE1E7),
      error: const Color(0xFFFF5267),
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: foreground,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(color: foreground, fontSize: 20, fontWeight: FontWeight.w900),
      iconTheme: IconThemeData(color: foreground),
    ),
    listTileTheme: ListTileThemeData(
      textColor: foreground,
      iconColor: muted,
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isLight ? const Color(0xFFF5F6F8) : const Color(0xFF20232A),
      labelStyle: TextStyle(color: muted),
      hintStyle: TextStyle(color: muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? const Color(0xFF343944) : const Color(0xFFD4D8DF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? const Color(0xFF343944) : const Color(0xFFDDE0E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? primary : muted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? primary.withValues(alpha: 0.28)
            : (isDark ? const Color(0xFF30343D) : const Color(0xFFD8DCE3)),
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? primary.withValues(alpha: 0.55)
            : (isDark ? const Color(0xFF4A4F59) : const Color(0xFFC5CAD2)),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? primary : muted,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primary,
      thumbColor: primary,
      inactiveTrackColor: isDark ? const Color(0xFF3A3E48) : const Color(0xFFD9DDE4),
      overlayColor: primary.withValues(alpha: 0.12),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(color: foreground, fontSize: 20, fontWeight: FontWeight.w900),
      contentTextStyle: TextStyle(color: muted, fontSize: 14),
    ),
    textTheme: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light).textTheme.apply(
      bodyColor: foreground,
      displayColor: foreground,
    ),
    fontFamily: 'Roboto',
  );
}