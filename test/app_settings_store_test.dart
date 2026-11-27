import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';

void _resetAppNotifiers() {
  appLanguageNotifier.value = AppLanguage.english;
  appThemeNotifier.value = AppThemePreset.defaultTheme;
  appNotifySafetyNotifier.value = true;
  appNotifyFirmwareNotifier.value = true;
  appNotifyBluetoothNotifier.value = true;
  appAutoConnectNotifier.value = false;
  knownCoolerRemoteIdNotifier.value = null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
    _resetAppNotifiers();
  });

  group('AppSettingsStore', () {
    test(
      'load restores persisted settings and publishes every notifier',
      () async {
        const settings = AppSettings(
          language: AppLanguage.indonesia,
          theme: AppThemePreset.dark,
          notifySafety: false,
          notifyFirmware: true,
          notifyBluetooth: false,
          autoConnect: true,
        );
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'jexfyz_app_settings_v2': jsonEncode(settings.toJson()),
        });

        final loaded = await AppSettingsStore.load();

        expect(loaded.toJson(), settings.toJson());
        expect(appLanguageNotifier.value, AppLanguage.indonesia);
        expect(appThemeNotifier.value, AppThemePreset.dark);
        expect(appNotifySafetyNotifier.value, isFalse);
        expect(appNotifyFirmwareNotifier.value, isTrue);
        expect(appNotifyBluetoothNotifier.value, isFalse);
        expect(appAutoConnectNotifier.value, isTrue);
      },
    );

    test(
      'missing settings restore and publish established defaults',
      () async {
      final loaded = await AppSettingsStore.load();

      expect(loaded.toJson(), const AppSettings().toJson());
      expect(appLanguageNotifier.value, AppLanguage.english);
      expect(appThemeNotifier.value, AppThemePreset.defaultTheme);
      expect(appNotifySafetyNotifier.value, isTrue);
      expect(appNotifyFirmwareNotifier.value, isTrue);
      expect(appNotifyBluetoothNotifier.value, isTrue);
      expect(appAutoConnectNotifier.value, isFalse);
      },
    );

    test(
      'save publishes and persists one complete settings record',
      () async {
        const settings = AppSettings(
          language: AppLanguage.indonesia,
          theme: AppThemePreset.light,
          notifySafety: false,
          notifyFirmware: false,
          notifyBluetooth: true,
          autoConnect: true,
        );

        await AppSettingsStore.save(settings);

        final stored = await storage.read(key: 'jexfyz_app_settings_v2');
        expect(jsonDecode(stored!), settings.toJson());
        expect(appLanguageNotifier.value, AppLanguage.indonesia);
        expect(appThemeNotifier.value, AppThemePreset.light);
        expect(appNotifySafetyNotifier.value, isFalse);
        expect(appNotifyFirmwareNotifier.value, isFalse);
        expect(appNotifyBluetoothNotifier.value, isTrue);
        expect(appAutoConnectNotifier.value, isTrue);
      },
    );

    test(
      'firmware notice gate suppresses only the persisted version',
      () async {
        expect(await AppSettingsStore.shouldNotifyFirmware('  '), isFalse);
        expect(await AppSettingsStore.shouldNotifyFirmware('V7.2'), isTrue);

        await AppSettingsStore.markFirmwareNotified('V7.2');

        expect(await AppSettingsStore.shouldNotifyFirmware('V7.2'), isFalse);
        expect(await AppSettingsStore.shouldNotifyFirmware('V7.3'), isTrue);
      },
    );
  });

  group('KnownCoolerStore', () {
    test(
      'load trims the persisted device identity before publishing it',
      () async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'jexfyz_known_cooler_remote_id_v1': '  cooler-01  ',
        });

        expect(await KnownCoolerStore.load(), 'cooler-01');
        expect(knownCoolerRemoteIdNotifier.value, 'cooler-01');
      },
    );

    test('blank persisted identity is exposed as unknown', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        'jexfyz_known_cooler_remote_id_v1': '   ',
      });

      expect(await KnownCoolerStore.load(), isNull);
      expect(knownCoolerRemoteIdNotifier.value, isNull);
    });

    test(
      'save normalizes identity and clear removes it',
      () async {
        await KnownCoolerStore.save('  cooler-02  ');

        expect(
          await storage.read(key: 'jexfyz_known_cooler_remote_id_v1'),
          'cooler-02',
        );
        expect(knownCoolerRemoteIdNotifier.value, 'cooler-02');

        await KnownCoolerStore.save('   ');

        expect(
          await storage.read(key: 'jexfyz_known_cooler_remote_id_v1'),
          'cooler-02',
        );

        await KnownCoolerStore.clear();

        expect(
          await storage.read(key: 'jexfyz_known_cooler_remote_id_v1'),
          isNull,
        );
        expect(knownCoolerRemoteIdNotifier.value, isNull);
      },
    );
  });
}
