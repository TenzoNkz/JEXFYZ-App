import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/p1_telemetry_contract.dart';

import 'support/source_contract_helpers.dart';

void main() {
  group('P1TelemetryContract', () {
    test('splits on the first colon and trims only key/value boundaries', () {
      final entry = P1TelemetryContract.parseLine('  FAN  :  ON  ');

      expect(entry, isNotNull);
      expect(entry!.key, 'FAN');
      expect(entry.value, 'ON');
    });

    test('preserves additional colons and delimiters inside the value', () {
      final entry = P1TelemetryContract.parseLine(
        'LAST_OTA_RESULT:OTA_FAILED|REASON:HTTP:503',
      );

      expect(entry, isNotNull);
      expect(entry!.key, 'LAST_OTA_RESULT');
      expect(entry.value, 'OTA_FAILED|REASON:HTTP:503');
    });

    test('preserves protocol key and value casing', () {
      final entry = P1TelemetryContract.parseLine('ble_session:ready');

      expect(entry, isNotNull);
      expect(entry!.key, 'ble_session');
      expect(entry.value, 'ready');
    });

    test('rejects empty, keyless and delimiter-free rows', () {
      for (final line in ['', 'FAN', ':ON', '   : ON']) {
        expect(P1TelemetryContract.parseLine(line), isNull, reason: line);
      }
    });

    test('does not treat ACK envelopes as telemetry entries', () {
      expect(P1TelemetryContract.parseLine('ACK:FAN;REASON=ON'), isNull);
    });

    test(
      'Dashboard uses the same pure parser for SYNC and live telemetry rows',
      () {
        final source = File('lib/main.dart').readAsStringSync();

        expect(
          countDartFragments(source, 'P1TelemetryContract.parseLine(line)'),
          2,
        );
        expect(
          containsDartFragment(
            source,
            '_syncSnapshot[entry.key] = entry.value;',
          ),
          isTrue,
        );
        expect(
          containsDartFragment(
            source,
            '_commitTelemetry(<String, String>{entry.key: entry.value});',
          ),
          isTrue,
        );
      },
    );
  });
}
