// AI-MEMORY / FILE CONTRACT
// File: app_settings.dart
// Owns: persisted App preferences, language/theme notifiers, and the single JexText localization table.
// Localization contract: language names are English/Indonesia; English power states are ON/OFF;
// Indonesian power states are HIDUP/MATI.
// Technical identifiers (BLE, P1, OTA, RGB, LED and NTC) remain untranslated.
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
// Power states use ON/OFF in English and HIDUP/MATI in Indonesian. Floating metric F is labelled Fan/Kipas; PWM control retains Fan Speed/Kecepatan Kipas.
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
    'notification': {
      AppLanguage.english: 'Notification',
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
    'firmwareUpdateAvailableBody': {
      AppLanguage.english: 'Version {version} is available. Connect your device to update.',
      AppLanguage.indonesia: 'Versi {version} tersedia. Hubungkan perangkat untuk memperbarui firmware.',
    },
    'deviceConnectionNotifications': {
      AppLanguage.english: 'Device connection',
      AppLanguage.indonesia: 'Koneksi perangkat',
    },
    'bluetoothConnected': {
      AppLanguage.english: 'Device connected.',
      AppLanguage.indonesia: 'Perangkat terhubung.',
    },
    'bluetoothDisconnected': {
      AppLanguage.english: 'Device disconnected.',
      AppLanguage.indonesia: 'Perangkat terputus.',
    },
    'bluetooth': {
      AppLanguage.english: 'Bluetooth',
      AppLanguage.indonesia: 'Bluetooth',
    },
    'autoConnect': {
      AppLanguage.english: 'Automatic Connection',
      AppLanguage.indonesia: 'Koneksi Otomatis',
    },
    'floatingMonitor': {
      AppLanguage.english: 'Floating Monitor',
      AppLanguage.indonesia: 'Floating Monitor',
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
      AppLanguage.english: 'RGB Power',
      AppLanguage.indonesia: 'Daya RGB',
    },
    'fan': {
      AppLanguage.english: 'Fan',
      AppLanguage.indonesia: 'Kipas',
    },
    'color': {
      AppLanguage.english: 'Color',
      AppLanguage.indonesia: 'Warna',
    },
    'ledColorCandyRed': {
      AppLanguage.english: 'Candy Red',
      AppLanguage.indonesia: 'Merah Permen',
    },
    'ledColorCrimson': {
      AppLanguage.english: 'Crimson',
      AppLanguage.indonesia: 'Merah Tua',
    },
    'ledColorScarlet': {
      AppLanguage.english: 'Scarlet',
      AppLanguage.indonesia: 'Merah Skarlat',
    },
    'ledColorVermilion': {
      AppLanguage.english: 'Vermilion',
      AppLanguage.indonesia: 'Merah Jingga',
    },
    'ledColorCoral': {
      AppLanguage.english: 'Coral',
      AppLanguage.indonesia: 'Koral',
    },
    'ledColorSalmon': {
      AppLanguage.english: 'Salmon',
      AppLanguage.indonesia: 'Salmon',
    },
    'ledColorTangerine': {
      AppLanguage.english: 'Tangerine',
      AppLanguage.indonesia: 'Jingga Tangerin',
    },
    'ledColorPeach': {
      AppLanguage.english: 'Peach',
      AppLanguage.indonesia: 'Persik',
    },
    'ledColorCaramel': {
      AppLanguage.english: 'Caramel',
      AppLanguage.indonesia: 'Karamel',
    },
    'ledColorChocolate': {
      AppLanguage.english: 'Chocolate',
      AppLanguage.indonesia: 'Cokelat',
    },
    'ledColorAmber': {
      AppLanguage.english: 'Amber',
      AppLanguage.indonesia: 'Amber',
    },
    'ledColorGoldenYellow': {
      AppLanguage.english: 'Golden Yellow',
      AppLanguage.indonesia: 'Kuning Emas',
    },
    'ledColorLemon': {
      AppLanguage.english: 'Lemon',
      AppLanguage.indonesia: 'Kuning Lemon',
    },
    'ledColorChartreuse': {
      AppLanguage.english: 'Chartreuse',
      AppLanguage.indonesia: 'Hijau Chartreuse',
    },
    'ledColorLime': {
      AppLanguage.english: 'Lime',
      AppLanguage.indonesia: 'Hijau Limau',
    },
    'ledColorNeonGreen': {
      AppLanguage.english: 'Neon Green',
      AppLanguage.indonesia: 'Hijau Neon',
    },
    'ledColorEmerald': {
      AppLanguage.english: 'Emerald',
      AppLanguage.indonesia: 'Hijau Zamrud',
    },
    'ledColorMint': {
      AppLanguage.english: 'Mint',
      AppLanguage.indonesia: 'Hijau Mint',
    },
    'ledColorJade': {
      AppLanguage.english: 'Jade',
      AppLanguage.indonesia: 'Hijau Giok',
    },
    'ledColorTurquoise': {
      AppLanguage.english: 'Turquoise',
      AppLanguage.indonesia: 'Biru Pirus',
    },
    'ledColorCyan': {
      AppLanguage.english: 'Cyan',
      AppLanguage.indonesia: 'Sian',
    },
    'ledColorSkyBlue': {
      AppLanguage.english: 'Sky Blue',
      AppLanguage.indonesia: 'Biru Langit',
    },
    'ledColorAzure': {
      AppLanguage.english: 'Azure',
      AppLanguage.indonesia: 'Biru Azur',
    },
    'ledColorElectricBlue': {
      AppLanguage.english: 'Electric Blue',
      AppLanguage.indonesia: 'Biru Elektrik',
    },
    'ledColorRoyalBlue': {
      AppLanguage.english: 'Royal Blue',
      AppLanguage.indonesia: 'Biru Royal',
    },
    'ledColorIndigo': {
      AppLanguage.english: 'Indigo',
      AppLanguage.indonesia: 'Nila',
    },
    'ledColorBlueViolet': {
      AppLanguage.english: 'Blue Violet',
      AppLanguage.indonesia: 'Biru Ungu',
    },
    'ledColorViolet': {
      AppLanguage.english: 'Violet',
      AppLanguage.indonesia: 'Ungu Violet',
    },
    'ledColorPurple': {
      AppLanguage.english: 'Purple',
      AppLanguage.indonesia: 'Ungu',
    },
    'ledColorNeonPurple': {
      AppLanguage.english: 'Neon Purple',
      AppLanguage.indonesia: 'Ungu Neon',
    },
    'ledColorOrchid': {
      AppLanguage.english: 'Orchid',
      AppLanguage.indonesia: 'Ungu Anggrek',
    },
    'ledColorMagenta': {
      AppLanguage.english: 'Magenta',
      AppLanguage.indonesia: 'Magenta',
    },
    'ledColorFuchsia': {
      AppLanguage.english: 'Fuchsia',
      AppLanguage.indonesia: 'Fuchsia',
    },
    'ledColorHotPink': {
      AppLanguage.english: 'Hot Pink',
      AppLanguage.indonesia: 'Merah Muda Terang',
    },
    'ledColorRosePink': {
      AppLanguage.english: 'Rose Pink',
      AppLanguage.indonesia: 'Merah Muda Mawar',
    },
    'ledColorWhite': {
      AppLanguage.english: 'White',
      AppLanguage.indonesia: 'Putih',
    },
    'customColor': {
      AppLanguage.english: 'Custom Color',
      AppLanguage.indonesia: 'Warna Kustom',
    },
    'ledColorRed': {
      AppLanguage.english: 'Red',
      AppLanguage.indonesia: 'Merah',
    },
    'ledColorOrangeRed': {
      AppLanguage.english: 'Orange Red',
      AppLanguage.indonesia: 'Jingga Kemerahan',
    },
    'ledColorOrange': {
      AppLanguage.english: 'Orange',
      AppLanguage.indonesia: 'Jingga',
    },
    'ledColorGoldenOrange': {
      AppLanguage.english: 'Golden Orange',
      AppLanguage.indonesia: 'Jingga Emas',
    },
    'ledColorYellow': {
      AppLanguage.english: 'Yellow',
      AppLanguage.indonesia: 'Kuning',
    },
    'ledColorSpringLime': {
      AppLanguage.english: 'Spring Lime',
      AppLanguage.indonesia: 'Hijau Limau Muda',
    },
    'ledColorGreen': {
      AppLanguage.english: 'Green',
      AppLanguage.indonesia: 'Hijau',
    },
    'ledColorSpringGreen': {
      AppLanguage.english: 'Spring Green',
      AppLanguage.indonesia: 'Hijau Muda',
    },
    'ledColorDeepSkyBlue': {
      AppLanguage.english: 'Deep Sky Blue',
      AppLanguage.indonesia: 'Biru Langit Pekat',
    },
    'ledColorBlue': {
      AppLanguage.english: 'Blue',
      AppLanguage.indonesia: 'Biru',
    },
    'ledColorPink': {
      AppLanguage.english: 'Pink',
      AppLanguage.indonesia: 'Merah Muda',
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
    'backgroundColor': {
      AppLanguage.english: 'Background Color',
      AppLanguage.indonesia: 'Warna Latar',
    },
    'black': {
      AppLanguage.english: 'Black',
      AppLanguage.indonesia: 'Hitam',
    },
    'white': {
      AppLanguage.english: 'White',
      AppLanguage.indonesia: 'Putih',
    },

    'orientation': {
      AppLanguage.english: 'Orientation',
      AppLanguage.indonesia: 'Orientasi',
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
      AppLanguage.english: 'Fan',
      AppLanguage.indonesia: 'Kipas',
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
      AppLanguage.english: 'STATUS',
      AppLanguage.indonesia: 'STATUS',
    },
    'notifyBluetooth': {
      AppLanguage.english: 'CONNECTION',
      AppLanguage.indonesia: 'KONEKSI',
    },
    'notifySync': {
      AppLanguage.english: 'SYNC',
      AppLanguage.indonesia: 'SINKRONISASI',
    },
    'notifyError': {
      AppLanguage.english: 'ERROR',
      AppLanguage.indonesia: 'ERROR',
    },
    'notifyWarning': {
      AppLanguage.english: 'WARNING',
      AppLanguage.indonesia: 'PERINGATAN',
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
    'connected': {
      AppLanguage.english: 'CONNECTED',
      AppLanguage.indonesia: 'TERHUBUNG',
    },
    'disconnected': {
      AppLanguage.english: 'DISCONNECTED',
      AppLanguage.indonesia: 'TERPUTUS',
    },
    'thermal': {
      AppLanguage.english: 'Thermal',
      AppLanguage.indonesia: 'Termal',
    },
    'hotsideLimit': {
      AppLanguage.english: 'Hotside Limit',
      AppLanguage.indonesia: 'Batas Suhu Hotside',
    },
    'batteryZones': {
      AppLanguage.english: 'Battery Temperature Zones',
      AppLanguage.indonesia: 'Zona Suhu Baterai',
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
      AppLanguage.english: 'Controls are unavailable while Adaptive Mode is on.',
      AppLanguage.indonesia: 'Kontrol tidak tersedia saat Mode Adaptif aktif.',
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
      AppLanguage.english: 'The fan must be running before Peltier can be enabled.',
      AppLanguage.indonesia: 'Kipas harus menyala sebelum Peltier dapat diaktifkan.',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.indonesia: 'Batal',
    },
    'select': {
      AppLanguage.english: 'Select',
      AppLanguage.indonesia: 'Pilih',
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
      AppLanguage.english: 'Firmware information is unavailable.',
      AppLanguage.indonesia: 'Informasi firmware tidak tersedia.',
    },
    'password': {
      AppLanguage.english: 'Password',
      AppLanguage.indonesia: 'Kata Sandi',
    },
    'showPassword': {
      AppLanguage.english: 'Show password',
      AppLanguage.indonesia: 'Tampilkan kata sandi',
    },
    'hidePassword': {
      AppLanguage.english: 'Hide password',
      AppLanguage.indonesia: 'Sembunyikan kata sandi',
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
      AppLanguage.english: 'Firmware update could not start.',
      AppLanguage.indonesia: 'Pembaruan firmware tidak dapat dimulai.',
    },
    'otaInProgress': {
      AppLanguage.english: 'Firmware update in progress.',
      AppLanguage.indonesia: 'Pembaruan firmware sedang berlangsung.',
    },
    'otaUpToDate': {
      AppLanguage.english: 'Firmware is up to date.',
      AppLanguage.indonesia: 'Firmware sudah versi terbaru.',
    },
    'otaReconnectFailed': {
      AppLanguage.english: 'The update finished, but the device could not reconnect.',
      AppLanguage.indonesia: 'Pembaruan selesai, tetapi perangkat tidak dapat tersambung kembali.',
    },
    'systemReady': {
      AppLanguage.english: 'System ready.',
      AppLanguage.indonesia: 'Sistem siap.',
    },
    'deviceStatusUpdate': {
      AppLanguage.english: 'Device status refreshed.',
      AppLanguage.indonesia: 'Status perangkat diperbarui.',
    },
    'connectingDevice': {
      AppLanguage.english: 'Connecting to the device…',
      AppLanguage.indonesia: 'Menghubungkan ke perangkat…',
    },
    'scanning': {
      AppLanguage.english: 'Scanning for devices…',
      AppLanguage.indonesia: 'Mencari perangkat…',
    },
    'bluetoothNotReady': {
      AppLanguage.english: 'Bluetooth is unavailable. Check your settings.',
      AppLanguage.indonesia: 'Bluetooth tidak tersedia. Periksa pengaturan Anda.',
    },
    'connectFirst': {
      AppLanguage.english: 'Connect your device to continue.',
      AppLanguage.indonesia: 'Hubungkan perangkat untuk melanjutkan.',
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
      AppLanguage.english: 'The device did not confirm the Hotside limit change.',
      AppLanguage.indonesia: 'Perangkat belum mengonfirmasi perubahan batas suhu Hotside.',
    },
    'hotsideLimitFailed': {
      AppLanguage.english: 'Hotside limit update failed.',
      AppLanguage.indonesia: 'Gagal memperbarui batas Hotside.',
    },
    'battery5LimitNotConfirmed': {
      AppLanguage.english: 'The device did not confirm the 5V battery limit change.',
      AppLanguage.indonesia: 'Perangkat belum mengonfirmasi perubahan batas baterai 5V.',
    },
    'battery5LimitFailed': {
      AppLanguage.english: '5V battery limit failed.',
      AppLanguage.indonesia: 'Gagal memperbarui batas baterai 5V.',
    },
    'battery12LimitNotConfirmed': {
      AppLanguage.english: 'The device did not confirm the 12V battery limit change.',
      AppLanguage.indonesia: 'Perangkat belum mengonfirmasi perubahan batas baterai 12V.',
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
      AppLanguage.english: 'Connection established.',
      AppLanguage.indonesia: 'Koneksi berhasil dibuat.',
    },
    'connectionAccessRequired': {
      AppLanguage.english: 'Bluetooth permission is required to connect.',
      AppLanguage.indonesia: 'Izin Bluetooth diperlukan untuk menghubungkan perangkat.',
    },
    'deviceNotFound': {
      AppLanguage.english: 'Device not found nearby.',
      AppLanguage.indonesia: 'Perangkat tidak ditemukan di sekitar.',
    },
    'scanFailed': {
      AppLanguage.english: 'Could not scan for devices. Check Bluetooth permissions.',
      AppLanguage.indonesia: 'Pemindaian perangkat gagal. Periksa izin Bluetooth.',
    },
    'notificationSafetyDescription': {
      AppLanguage.english: 'Send a notification when Hotside reaches the set limit.',
      AppLanguage.indonesia: 'Kirim notifikasi saat suhu Hotside mencapai batas yang ditetapkan.',
    },
    'otaFailed': {
      AppLanguage.english: 'Firmware update failed.',
      AppLanguage.indonesia: 'Pembaruan firmware gagal.',
    },
    'otaSuccessful': {
      AppLanguage.english: 'Firmware update completed.',
      AppLanguage.indonesia: 'Pembaruan firmware selesai.',
    },
    'otaProgress': {
      AppLanguage.english: 'Firmware update in progress • ',
      AppLanguage.indonesia: 'Pembaruan firmware berlangsung • ',
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
      AppLanguage.english: 'System restarted automatically after becoming unresponsive.',
      AppLanguage.indonesia: 'Sistem dimulai ulang secara otomatis setelah tidak merespons.',
    },
    'resetExternal': {
      AppLanguage.english: 'Device restarted.',
      AppLanguage.indonesia: 'Perangkat dimulai ulang.',
    },
    'resetDeepSleep': {
      AppLanguage.english: 'Device resumed from low-power sleep.',
      AppLanguage.indonesia: 'Perangkat kembali aktif dari mode hemat daya.',
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
      AppLanguage.english: 'Breathing',
      AppLanguage.indonesia: 'Efek Napas',
    },
    'ledModeComet': {
      AppLanguage.english: 'Comet',
      AppLanguage.indonesia: 'Komet',
    },
    'ledModeDualChase': {
      AppLanguage.english: 'Dual Chase',
      AppLanguage.indonesia: 'Chase Ganda',
    },
    'ledModeRainbow': {
      AppLanguage.english: 'Rainbow',
      AppLanguage.indonesia: 'Pelangi',
    },
    'ledModeUnsupported': {
      AppLanguage.english: 'Unsupported',
      AppLanguage.indonesia: 'Tidak didukung',
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
      AppLanguage.english: 'Send a notification when a firmware update is available.',
      AppLanguage.indonesia: 'Kirim notifikasi saat pembaruan firmware tersedia.',
    },
    'notificationBluetoothDescription': {
      AppLanguage.english: 'Send a notification when the device connects or disconnects.',
      AppLanguage.indonesia: 'Kirim notifikasi saat perangkat terhubung atau terputus.',
    },
    'autoConnectDescription': {
      AppLanguage.english: 'Connect to the device automatically when available.',
      AppLanguage.indonesia: 'Sambungkan perangkat secara otomatis saat tersedia.',
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
      AppLanguage.english: 'Unable to connect right now. Please try again.',
      AppLanguage.indonesia: 'Belum dapat terhubung. Silakan coba lagi.',
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
    'contactDeveloper': {
      AppLanguage.english: 'Contact Developer',
      AppLanguage.indonesia: 'Hubungi Pengembang',
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
      AppLanguage.english: 'Bluetooth permission is required to connect.',
      AppLanguage.indonesia: 'Izin Bluetooth diperlukan untuk menghubungkan perangkat.',
    },
    'bleServiceDiscoveryFailed': {
      AppLanguage.english: 'The device’s Bluetooth service was not found.',
      AppLanguage.indonesia: 'Layanan Bluetooth perangkat tidak ditemukan.',
    },
    'bleSyncFailed': {
      AppLanguage.english: 'Could not sync with the device.',
      AppLanguage.indonesia: 'Tidak dapat menyinkronkan perangkat.',
    },
    'bleHandshakeWriteFailed': {
      AppLanguage.english: 'Could not complete Bluetooth connection setup.',
      AppLanguage.indonesia: 'Penyiapan koneksi Bluetooth tidak dapat diselesaikan.',
    },
    'bleSessionNotReady': {
      AppLanguage.english: 'The Bluetooth session is not ready yet.',
      AppLanguage.indonesia: 'Sesi Bluetooth belum siap.',
    },
    'fullSyncFailed': {
      AppLanguage.english: 'Could not complete device sync.',
      AppLanguage.indonesia: 'Sinkronisasi perangkat tidak selesai.',
    },
    'floatingPermissionTitle': {
      AppLanguage.english: 'Floating Monitor Permission',
      AppLanguage.indonesia: 'Izin Floating Monitor',
    },
    'floatingPendingConnection': {
      AppLanguage.english: 'Floating Monitor will appear when the device is connected.',
      AppLanguage.indonesia: 'Floating Monitor akan tampil saat perangkat terhubung.',
    },
    'floatingPermissionMessage': {
      AppLanguage.english: 'The app needs permission to display Floating Monitor over other apps. Android will open the display-over-other-apps setting.',
      AppLanguage.indonesia: 'Aplikasi memerlukan izin untuk menampilkan Floating Monitor di atas aplikasi lain. Android akan membuka pengaturan tampilan di atas aplikasi lain.',
    },
    'overlayPermissionDenied': {
      AppLanguage.english: 'Overlay permission was not granted.',
      AppLanguage.indonesia: 'Izin tampilan mengambang belum diberikan.',
    },
    'overlaySettingsFailed': {
      AppLanguage.english: 'Could not open the Android overlay permission settings.',
      AppLanguage.indonesia: 'Pengaturan izin tampilan mengambang Android tidak dapat dibuka.',
    },
    'floatingStartFailed': {
      AppLanguage.english: 'Floating Monitor could not be started. Check its permissions and try again.',
      AppLanguage.indonesia: 'Floating Monitor tidak dapat dijalankan. Periksa izinnya, lalu coba lagi.',
    },
    'synchronizingDevice': {
      AppLanguage.english: 'Syncing device…',
      AppLanguage.indonesia: 'Menyinkronkan perangkat…',
    },
    'validatingTemperature': {
      AppLanguage.english: 'Checking temperature readings…',
      AppLanguage.indonesia: 'Memeriksa pembacaan suhu…',
    },
    'sensorErrorCoolingLocked': {
      AppLanguage.english: 'Temperature sensor error. Cooling has been disabled for safety.',
      AppLanguage.indonesia: 'Sensor suhu bermasalah. Pendinginan dinonaktifkan demi keamanan.',
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
      AppLanguage.english: 'LED mode updated.',
      AppLanguage.indonesia: 'Mode LED diperbarui.',
    },
    'brightnessUpdated': {
      AppLanguage.english: 'LED brightness updated.',
      AppLanguage.indonesia: 'Kecerahan LED diperbarui.',
    },
    'colorUpdated': {
      AppLanguage.english: 'LED color updated.',
      AppLanguage.indonesia: 'Warna LED diperbarui.',
    },
    'temperatureReset': {
      AppLanguage.english: 'Temperature settings have been reset.',
      AppLanguage.indonesia: 'Pengaturan suhu berhasil diatur ulang.',
    },
    'commandNotConfirmed': {
      AppLanguage.english: 'Action not confirmed. Check device status.',
      AppLanguage.indonesia: 'Tindakan belum terkonfirmasi. Periksa status perangkat.',
    },
    'commandFailed': {
      AppLanguage.english: 'Action failed. Check device status and try again.',
      AppLanguage.indonesia: 'Tindakan gagal. Periksa status perangkat, lalu coba lagi.',
    },
    'firmware': {
      AppLanguage.english: 'Firmware',
      AppLanguage.indonesia: 'Firmware',
    },
    'firmwareMetadataCheckFailed': {
      AppLanguage.english: 'Could not load firmware information. Please try again later.',
      AppLanguage.indonesia: 'Informasi firmware tidak dapat dimuat. Silakan coba lagi nanti.',
    },
    'leftRight': {
      AppLanguage.english: 'Left / Right',
      AppLanguage.indonesia: 'Kiri / Kanan',
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
    'firmwareMetadataUnavailableSentence': { AppLanguage.english: 'Could not load firmware information. Please try again later.', AppLanguage.indonesia: 'Informasi firmware tidak dapat dimuat. Silakan coba lagi nanti.' },
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

  // AI-METHOD / RELOCALIZATION CONTRACT
  // Re-resolve a previously stored table string in the current language without changing
  // stable bilingual labels or technical protocol identifiers.
  static String relocalize(String value, AppLanguage language) {
    final raw = value.trim();
    if (raw.isEmpty) return raw;

    // If the value already equals its requested-language entry, keep it as-is.
    for (final variants in _values.values) {
      if (variants[language] == raw) return raw;
    }

    String? translated;
    for (final variants in _values.values) {
      final english = variants[AppLanguage.english];
      final indonesia = variants[AppLanguage.indonesia];
      if (english == null || indonesia == null || english == indonesia) continue;

      String? candidate;
      if (raw == english) candidate = indonesia;
      if (raw == indonesia) candidate = english;
      if (candidate == null) continue;

      if (translated != null && translated != candidate) {
        // Ambiguous source text must not be translated to a guessed label.
        return raw;
      }
      translated = candidate;
    }
    return translated ?? raw;
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

// AI-THEME / COMPACT-SETTINGS-CONTRACT
// Applies a restrained typography/visual-density reduction only to Settings routes and the
// Bluetooth Connection sheet. Do not apply this theme globally to Home/Dashboard.
ThemeData buildJexCompactUiTheme(AppThemePreset preset) {
  final base = buildJexTheme(preset);
  final text = base.textTheme;
  final foreground = base.colorScheme.onSurface;
  final muted = base.colorScheme.onSurfaceVariant;

  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      titleTextStyle: base.appBarTheme.titleTextStyle?.copyWith(fontSize: 18),
      iconTheme: base.appBarTheme.iconTheme?.copyWith(size: 22),
    ),
    textTheme: text.copyWith(
      titleLarge: text.titleLarge?.copyWith(fontSize: 18),
      titleMedium: text.titleMedium?.copyWith(fontSize: 13),
      titleSmall: text.titleSmall?.copyWith(fontSize: 12),
      bodyLarge: text.bodyLarge?.copyWith(fontSize: 13),
      bodyMedium: text.bodyMedium?.copyWith(fontSize: 12),
      bodySmall: text.bodySmall?.copyWith(fontSize: 11),
      labelLarge: text.labelLarge?.copyWith(fontSize: 12),
      labelMedium: text.labelMedium?.copyWith(fontSize: 11),
      labelSmall: text.labelSmall?.copyWith(fontSize: 10),
    ),
    listTileTheme: base.listTileTheme.copyWith(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -0.5, vertical: -0.5),
      minVerticalPadding: 6,
      titleTextStyle: text.titleMedium?.copyWith(
        color: foreground,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      subtitleTextStyle: text.bodySmall?.copyWith(
        color: muted,
        fontSize: 11,
      ),
    ),
  );
}
