import 'dart:collection';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';


/// A deterministic backing map for exercising the plugin's existing test platform.
/// flutter_secure_storage delegates its mock read/write/delete operations to this Map.
class _FailureInjectingStorageMap extends MapBase<String, String> {
  _FailureInjectingStorageMap({
    this.failReads = false,
    this.failWrites = false,
    this.failDeletes = false,
    this.onWriteAttempt,
    Map<String, String>? initialValues,
  }) : _values = Map<String, String>.of(initialValues ?? const {});

  final bool failReads;
  final bool failWrites;
  final bool failDeletes;
  final void Function()? onWriteAttempt;
  final Map<String, String> _values;

  int readAttempts = 0;
  int writeAttempts = 0;
  int deleteAttempts = 0;

  @override
  String? operator [](Object? key) {
    readAttempts++;
    if (failReads) throw StateError('Injected secure-storage read failure');
    return _values[key];
  }

  @override
  void operator []=(String key, String value) {
    writeAttempts++;
    onWriteAttempt?.call();
    if (failWrites) throw StateError('Injected secure-storage write failure');
    _values[key] = value;
  }

  @override
  Iterable<String> get keys => _values.keys;

  @override
  void clear() => _values.clear();

  @override
  String? remove(Object? key) {
    deleteAttempts++;
    if (failDeletes) throw StateError('Injected secure-storage delete failure');
    return _values.remove(key);
  }

  String? valueWithoutFailure(String key) => _values[key];
}

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

    test('missing settings restore and publish established defaults', () async {
      final loaded = await AppSettingsStore.load();

      expect(loaded.toJson(), const AppSettings().toJson());
      expect(appLanguageNotifier.value, AppLanguage.english);
      expect(appThemeNotifier.value, AppThemePreset.defaultTheme);
      expect(appNotifySafetyNotifier.value, isTrue);
      expect(appNotifyFirmwareNotifier.value, isTrue);
      expect(appNotifyBluetoothNotifier.value, isTrue);
      expect(appAutoConnectNotifier.value, isFalse);
    });

    test('save publishes and persists one complete settings record', () async {
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
    });

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

    test('save normalizes identity and clear removes it', () async {
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
    });
  });
  group('secure-storage failure handling', () {
    test('AppSettingsStore.load publishes defaults when storage read fails', () async {
      appLanguageNotifier.value = AppLanguage.indonesia;
      appThemeNotifier.value = AppThemePreset.dark;
      appNotifySafetyNotifier.value = false;
      appNotifyFirmwareNotifier.value = false;
      appNotifyBluetoothNotifier.value = false;
      appAutoConnectNotifier.value = true;

      final failingStorage = _FailureInjectingStorageMap(failReads: true);
      FlutterSecureStorage.setMockInitialValues(failingStorage);

      final loaded = await AppSettingsStore.load();

      expect(loaded.toJson(), const AppSettings().toJson());
      expect(appLanguageNotifier.value, AppLanguage.english);
      expect(appThemeNotifier.value, AppThemePreset.defaultTheme);
      expect(appNotifySafetyNotifier.value, isTrue);
      expect(appNotifyFirmwareNotifier.value, isTrue);
      expect(appNotifyBluetoothNotifier.value, isTrue);
      expect(appAutoConnectNotifier.value, isFalse);
      expect(failingStorage.readAttempts, 1);
    });

    test('AppSettingsStore.save publishes before a failed storage write', () async {
      const settings = AppSettings(
        language: AppLanguage.indonesia,
        theme: AppThemePreset.dark,
        notifySafety: false,
        notifyFirmware: false,
        notifyBluetooth: false,
        autoConnect: true,
      );
      var notifiersWerePublishedBeforeWrite = false;
      final failingStorage = _FailureInjectingStorageMap(
        failWrites: true,
        onWriteAttempt: () {
          notifiersWerePublishedBeforeWrite =
              appLanguageNotifier.value == AppLanguage.indonesia &&
              appThemeNotifier.value == AppThemePreset.dark &&
              !appNotifySafetyNotifier.value &&
              !appNotifyFirmwareNotifier.value &&
              !appNotifyBluetoothNotifier.value &&
              appAutoConnectNotifier.value;
        },
      );
      FlutterSecureStorage.setMockInitialValues(failingStorage);

      await expectLater(AppSettingsStore.save(settings), completes);

      expect(failingStorage.writeAttempts, 1);
      expect(notifiersWerePublishedBeforeWrite, isTrue);
      expect(appLanguageNotifier.value, AppLanguage.indonesia);
      expect(appThemeNotifier.value, AppThemePreset.dark);
      expect(appNotifySafetyNotifier.value, isFalse);
      expect(appNotifyFirmwareNotifier.value, isFalse);
      expect(appNotifyBluetoothNotifier.value, isFalse);
      expect(appAutoConnectNotifier.value, isTrue);
    });

    test('firmware notice skips blank versions and fails open on read errors', () async {
      final failingStorage = _FailureInjectingStorageMap(failReads: true);
      FlutterSecureStorage.setMockInitialValues(failingStorage);

      expect(await AppSettingsStore.shouldNotifyFirmware('  '), isFalse);
      expect(failingStorage.readAttempts, 0);
      expect(await AppSettingsStore.shouldNotifyFirmware('V9.9'), isTrue);
      expect(failingStorage.readAttempts, 1);
    });

    test('markFirmwareNotified contains storage write failures', () async {
      final failingStorage = _FailureInjectingStorageMap(failWrites: true);
      FlutterSecureStorage.setMockInitialValues(failingStorage);

      await expectLater(
        AppSettingsStore.markFirmwareNotified('V9.9'),
        completes,
      );

      expect(failingStorage.writeAttempts, 1);
    });

    test('KnownCoolerStore.load clears the notifier when storage read fails', () async {
      knownCoolerRemoteIdNotifier.value = 'stale-cooler';
      final failingStorage = _FailureInjectingStorageMap(failReads: true);
      FlutterSecureStorage.setMockInitialValues(failingStorage);

      expect(await KnownCoolerStore.load(), isNull);
      expect(knownCoolerRemoteIdNotifier.value, isNull);
      expect(failingStorage.readAttempts, 1);
    });

    test('KnownCoolerStore.save publishes normalized identity despite write failure', () async {
      final failingStorage = _FailureInjectingStorageMap(failWrites: true);
      FlutterSecureStorage.setMockInitialValues(failingStorage);

      await expectLater(KnownCoolerStore.save('  cooler-03  '), completes);

      expect(failingStorage.writeAttempts, 1);
      expect(knownCoolerRemoteIdNotifier.value, 'cooler-03');
    });

    test('KnownCoolerStore.clear clears notifier despite delete failure', () async {
      const key = 'jexfyz_known_cooler_remote_id_v1';
      knownCoolerRemoteIdNotifier.value = 'cooler-04';
      final failingStorage = _FailureInjectingStorageMap(
        failDeletes: true,
        initialValues: const <String, String>{key: 'cooler-04'},
      );
      FlutterSecureStorage.setMockInitialValues(failingStorage);

      await expectLater(KnownCoolerStore.clear(), completes);

      expect(failingStorage.deleteAttempts, 1);
      expect(knownCoolerRemoteIdNotifier.value, isNull);
      expect(failingStorage.valueWithoutFailure(key), 'cooler-04');
    });
  });

}
