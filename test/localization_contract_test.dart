import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/main.dart'
    show formatOtaUploadSizeMismatch, homeNotifyForTelemetryChange;
import 'package:jexfyz_cooler/usage_statistics.dart'
    show UsageStateDomain, usageStateLabel;

Set<String> _placeholders(String value) => RegExp(
  r'\{[A-Za-z][A-Za-z0-9_]*\}',
).allMatches(value).map((match) => match.group(0)!).toSet();

void main() {
  group('Localization contracts', () {
    test('dictionary entries provide both locales and matching placeholders', () {
      final source = File('lib/app_settings.dart').readAsStringSync();
      final entries = RegExp(
        r"'([^']+)'\s*:\s*\{([\s\S]*?)\},",
      ).allMatches(source).toList();
      expect(entries.length, greaterThanOrEqualTo(350));

      for (final entry in entries) {
        final key = entry.group(1)!;
        final translations = entry.group(2)!;
        final english = RegExp(
          r"AppLanguage\.english:\s*'((?:\\.|[^'\\])*)'",
          dotAll: true,
        ).firstMatch(translations)?.group(1);
        final indonesia = RegExp(
          r"AppLanguage\.indonesia:\s*'((?:\\.|[^'\\])*)'",
          dotAll: true,
        ).firstMatch(translations)?.group(1);
        expect(english, isNotNull, reason: 'Missing English copy: $key');
        expect(indonesia, isNotNull, reason: 'Missing Indonesian copy: $key');
        expect(
          _placeholders(english!),
          _placeholders(indonesia!),
          reason: 'Placeholder mismatch: $key',
        );
      }
    });

    test('literal inline phrase pairs preserve placeholder parity', () {
      const paths = <String>[
        'lib/main.dart',
        'lib/floating_monitor.dart',
        'lib/usage_statistics.dart',
      ];
      final pair = RegExp(
        r"JexText\.phrase\(\s*'((?:\\.|[^'\\])*)'\s*,\s*'((?:\\.|[^'\\])*)'\s*,",
        dotAll: true,
      );
      var checked = 0;
      for (final path in paths) {
        final source = File(path).readAsStringSync();
        for (final match in pair.allMatches(source)) {
          checked++;
          expect(
            _placeholders(match.group(1)!),
            _placeholders(match.group(2)!),
            reason: 'Inline phrase placeholder mismatch in $path',
          );
        }
      }
      expect(checked, greaterThanOrEqualTo(120));
    });

    test('OTA mismatch keeps received and expected byte counts in order', () {
      const event = 'UPLOAD_SIZE_MISMATCH_120400_131072';
      expect(
        formatOtaUploadSizeMismatch(event, AppLanguage.english),
        'OTA failed: 120400 bytes received; 131072 bytes expected.',
      );
      expect(
        formatOtaUploadSizeMismatch(event, AppLanguage.indonesia),
        'OTA gagal: 120400 byte diterima; 131072 byte diharapkan.',
      );
      expect(
        formatOtaUploadSizeMismatch(
          'UPLOAD_SIZE_MISMATCH_120400_x',
          AppLanguage.english,
        ),
        isNull,
      );
    });

    test('approved safety and prerequisite copy remains equivalent', () {
      expect(JexText.of('peltierSafety', AppLanguage.english), 'Peltier Safety');
      expect(JexText.of('peltierSafety', AppLanguage.indonesia), 'Keselamatan Peltier');
      expect(
        JexText.of('sensorErrorCoolingLocked', AppLanguage.indonesia),
        'Sensor suhu bermasalah. Pendinginan dinonaktifkan demi keselamatan.',
      );
      expect(
        JexText.of('peltierFanRequiredTitle', AppLanguage.indonesia),
        'Kipas harus menyala sebelum pendinginan.',
      );
      expect(
        JexText.of('fullSyncFailed', AppLanguage.indonesia),
        'Tidak dapat menyelesaikan sinkronisasi perangkat.',
      );
      expect(
        JexText.of('resetDeepSleep', AppLanguage.indonesia),
        'Perangkat kembali aktif dari mode tidur hemat daya.',
      );
    });

    test('JexText.format interpolates named values in both locales', () {
      const values = <String, String>{
        'receivedBytes': '120400',
        'expectedBytes': '131072',
      };
      expect(
        JexText.format('otaSizeMismatchDetailed', values, AppLanguage.english),
        'OTA failed: 120400 bytes received; 131072 bytes expected.',
      );
      expect(
        JexText.format('otaSizeMismatchDetailed', values, AppLanguage.indonesia),
        'OTA gagal: 120400 byte diterima; 131072 byte diharapkan.',
      );
    });

    test('Safety NOTIFY success preserves passed/succeeded meaning', () {
      expect(
        homeNotifyForTelemetryChange(
          key: 'SAFETY',
          previousValue: 'LOCKED',
          currentValue: 'OK',
          language: AppLanguage.english,
        ),
        'Safety checks passed.',
      );
      expect(
        homeNotifyForTelemetryChange(
          key: 'SAFETY',
          previousValue: 'LOCKED',
          currentValue: 'OK',
          language: AppLanguage.indonesia,
        ),
        'Pemeriksaan keselamatan berhasil.',
      );
    });

    test('Usage Statistics state domains remain distinct', () {
      expect(
        usageStateLabel('ON', AppLanguage.english, domain: UsageStateDomain.logicalMode),
        'Active',
      );
      expect(
        usageStateLabel('OFF', AppLanguage.indonesia, domain: UsageStateDomain.logicalMode),
        'NONAKTIF',
      );
      expect(usageStateLabel('ON', AppLanguage.indonesia), 'HIDUP');
      expect(usageStateLabel('OFF', AppLanguage.indonesia), 'MATI');
    });
  });
}
