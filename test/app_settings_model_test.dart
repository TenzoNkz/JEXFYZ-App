import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';

void main() {
  group('AppSettings value model', () {
    test('defaults retain the established preference contract', () {
      const settings = AppSettings();

      expect(settings.language, AppLanguage.english);
      expect(settings.theme, AppThemePreset.defaultTheme);
      expect(settings.notifySafety, isTrue);
      expect(settings.notifyFirmware, isTrue);
      expect(settings.notifyBluetooth, isTrue);
      expect(settings.autoConnect, isFalse);
    });

    test('serializes and restores every persisted preference', () {
      const settings = AppSettings(
        language: AppLanguage.indonesia,
        theme: AppThemePreset.dark,
        notifySafety: false,
        notifyFirmware: true,
        notifyBluetooth: false,
        autoConnect: true,
      );

      expect(settings.toJson(), <String, dynamic>{
        'language': 'indonesia',
        'theme': 'dark',
        'notifySafety': false,
        'notifyFirmware': true,
        'notifyBluetooth': false,
        'autoConnect': true,
      });

      final restored = AppSettings.fromJson(
        '{"language":"indonesia","theme":"dark","notifySafety":false,'
        '"notifyFirmware":true,"notifyBluetooth":false,"autoConnect":true}',
      );
      expect(restored.toJson(), settings.toJson());
    });

    test('malformed JSON falls back to safe model defaults', () {
      final settings = AppSettings.fromJson('{not valid JSON');

      expect(settings.toJson(), const AppSettings().toJson());
    });

    test('non-map JSON roots fall back to safe model defaults', () {
      for (final raw in <String>['null', 'true', '42', '"settings"']) {
        expect(
          AppSettings.fromJson(raw).toJson(),
          const AppSettings().toJson(),
          reason: 'Unexpected model for root value $raw',
        );
      }
    });

    test('unknown enum names fall back without discarding valid booleans', () {
      final settings = AppSettings.fromJson(
        '{"language":"japanese","theme":"system","notifySafety":false,'
        '"notifyFirmware":false,"notifyBluetooth":true,"autoConnect":true}',
      );

      expect(settings.language, AppLanguage.english);
      expect(settings.theme, AppThemePreset.defaultTheme);
      expect(settings.notifySafety, isFalse);
      expect(settings.notifyFirmware, isFalse);
      expect(settings.notifyBluetooth, isTrue);
      expect(settings.autoConnect, isTrue);
    });

    test('missing or wrong-typed boolean fields use their model defaults', () {
      final settings = AppSettings.fromJson(
        '{"language":null,"theme":12,"notifySafety":"false",'
        '"notifyFirmware":null,"notifyBluetooth":0}',
      );

      expect(settings.language, AppLanguage.english);
      expect(settings.theme, AppThemePreset.defaultTheme);
      expect(settings.notifySafety, isTrue);
      expect(settings.notifyFirmware, isTrue);
      expect(settings.notifyBluetooth, isTrue);
      expect(settings.autoConnect, isFalse);
    });

    test('copyWith can explicitly turn boolean preferences off', () {
      const original = AppSettings(
        language: AppLanguage.indonesia,
        theme: AppThemePreset.light,
        notifySafety: true,
        notifyFirmware: true,
        notifyBluetooth: true,
        autoConnect: true,
      );

      final updated = original.copyWith(
        notifySafety: false,
        notifyFirmware: false,
        notifyBluetooth: false,
        autoConnect: false,
      );

      expect(updated.language, AppLanguage.indonesia);
      expect(updated.theme, AppThemePreset.light);
      expect(updated.notifySafety, isFalse);
      expect(updated.notifyFirmware, isFalse);
      expect(updated.notifyBluetooth, isFalse);
      expect(updated.autoConnect, isFalse);
    });

    test('copyWith preserves fields that are not provided', () {
      const original = AppSettings(
        language: AppLanguage.indonesia,
        theme: AppThemePreset.dark,
        notifySafety: false,
        notifyFirmware: true,
        notifyBluetooth: false,
        autoConnect: true,
      );

      final updated = original.copyWith(theme: AppThemePreset.light);

      expect(updated.language, original.language);
      expect(updated.theme, AppThemePreset.light);
      expect(updated.notifySafety, original.notifySafety);
      expect(updated.notifyFirmware, original.notifyFirmware);
      expect(updated.notifyBluetooth, original.notifyBluetooth);
      expect(updated.autoConnect, original.autoConnect);
    });
  });

  group('Dashboard palette semantics', () {
    test(
      'default preset keeps the dark Home header and light Dashboard body',
      () {
        expect(
          jexHomeHeaderUsesDarkPalette(AppThemePreset.defaultTheme),
          isTrue,
        );
        expect(
          jexDashboardContentUsesDarkPalette(AppThemePreset.defaultTheme),
          isFalse,
        );
      },
    );

    test('light preset uses light palettes for both surfaces', () {
      expect(jexHomeHeaderUsesDarkPalette(AppThemePreset.light), isFalse);
      expect(jexDashboardContentUsesDarkPalette(AppThemePreset.light), isFalse);
    });

    test('dark preset uses dark palettes for both surfaces', () {
      expect(jexHomeHeaderUsesDarkPalette(AppThemePreset.dark), isTrue);
      expect(jexDashboardContentUsesDarkPalette(AppThemePreset.dark), isTrue);
    });
  });
}
