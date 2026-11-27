import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/p1_command_contract.dart';

void main() {
  group('P1CommandContract', () {
    test('maps every existing command family to its exact ACK item', () {
      const ackItems = <String, String>{
        'SYNC_READY': 'SYNC_READY',
        'OTAENTER': 'OTAENTER',
        'CLOUDOTA': 'CLOUDOTA',
        'RGB:ON': 'RGB',
        'RGB:OFF': 'RGB',
        'MODE:2': 'MODE',
        'BRIGHTNESS:75': 'BRIGHTNESS',
        'COLOR:#A1B2C3': 'COLOR',
        'HOTLIMIT:45': 'HOTLIMIT',
        'BATT5:25': 'BATT5',
        'BATT12:35': 'BATT12',
        'VOLTAGE_LOCK:ON': 'VOLTAGE_LOCK',
        'VOLTAGE:9V': 'VOLTAGE',
        'FAN:ON': 'FAN',
        'FAN:OFF': 'FAN',
        'PELTIER:ON': 'PELTIER',
        'PELTIER:OFF': 'PELTIER',
        'ADAPTIVE:ON': 'ADAPTIVE',
        'ADAPTIVE:OFF': 'ADAPTIVE',
        'ADAPTIVE_PROFILE:HOT': 'ADAPTIVE_PROFILE',
        'FANSPEED:80': 'FANSPEED',
        'RESET:TEMPERATURE': 'RESET_TEMPERATURE',
        'SSID:Cooler': 'SSID',
        'PASS:secret': 'PASS',
        'URL:https://example.invalid/update.bin': 'URL',
        'VERSION:V7.2': 'VERSION',
      };

      for (final entry in ackItems.entries) {
        expect(P1CommandContract.ackItemForCommand(entry.key), entry.value);
        expect(
          P1CommandContract.ackItemForCommand(
            ' ${entry.key.toLowerCase()} ',
          ),
          entry.value,
          reason: entry.key,
        );
      }

      expect(P1CommandContract.ackItemForCommand('RESET:POWER_ON'), isNull);
      expect(P1CommandContract.ackItemForCommand('FAN:AUTO'), isNull);
      expect(P1CommandContract.ackItemForCommand('UNKNOWN'), isNull);
    });

    test(
      'maps output commands to telemetry-confirmed values, not ACK labels',
      () {
        const expectedValues = <String, MapEntry<String, String>>{
          'FAN:ON': MapEntry('FAN', 'ON'),
          'FAN:OFF': MapEntry('FAN', 'OFF'),
          'PELTIER:ON': MapEntry('PELTIER', 'ON'),
          'PELTIER:OFF': MapEntry('PELTIER', 'OFF'),
          'ADAPTIVE:ON': MapEntry('ADAPTIVE', 'ON'),
          'ADAPTIVE:OFF': MapEntry('ADAPTIVE', 'OFF'),
          'VOLTAGE_LOCK:ON': MapEntry('VOLTAGE_LOCK', 'ON'),
          'VOLTAGE:9V': MapEntry('VOLTAGE', '9V'),
          'RGB:ON': MapEntry('RGB', 'ON'),
          'RGB:OFF': MapEntry('RGB', 'OFF'),
          'MODE:2': MapEntry('MODE', '2'),
          'BRIGHTNESS:75': MapEntry('BRIGHTNESS', '75'),
          'COLOR:#A1B2C3': MapEntry('RGB_COLOR', '#A1B2C3'),
          'FANSPEED:80': MapEntry('FAN_SPEED', '80'),
          'HOTLIMIT:45': MapEntry('TEMP_HOT_LIMIT', '45'),
          'BATT5:25': MapEntry('BATT_5', '25'),
          'BATT12:35': MapEntry('BATT_12', '35'),
          'ADAPTIVE_PROFILE:HOT': MapEntry('ADAPTIVE_PROFILE', 'HOT'),
        };

        for (final entry in expectedValues.entries) {
          final actual = P1CommandContract.expectedTelemetryForCommand(
            entry.key,
          );
          expect(actual?.key, entry.value.key, reason: entry.key);
          expect(actual?.value, entry.value.value, reason: entry.key);

          // Compare fields because MapEntry does not provide structural equality.
          final normalized = P1CommandContract.expectedTelemetryForCommand(
            ' ${entry.key.toLowerCase()} ',
          );
          expect(normalized?.key, entry.value.key, reason: entry.key);
          expect(normalized?.value, entry.value.value, reason: entry.key);
        }

        expect(
          P1CommandContract.expectedTelemetryForCommand('SYNC_READY'),
          isNull,
        );
        expect(
          P1CommandContract.expectedTelemetryForCommand('OTAENTER'),
          isNull,
        );
        expect(
          P1CommandContract.expectedTelemetryForCommand('FAN:AUTO'),
          isNull,
        );
      },
    );

    test(
      'preserves the exact set of commands requiring a GATT write response',
      () {
        const responseCommands = <String>[
          'SYNC',
          'SYNC_READY',
          'CLOUDOTA',
          'OTAENTER',
          'VOLTAGE_LOCK:ON',
          'VOLTAGE:9V',
          'SSID:Cooler',
          'PASS:secret',
          'URL:https://example.invalid/update.bin',
          'VERSION:V7.2',
          'FAN:ON',
          'PELTIER:ON',
          'ADAPTIVE_PROFILE:HOT',
          'ADAPTIVE:ON',
          'FANSPEED:80',
          'HOTLIMIT:45',
          'BATT5:25',
          'BATT12:35',
          'RESET:TEMPERATURE',
          'PHONE:BT=35',
        ];

        for (final command in responseCommands) {
          expect(
            P1CommandContract.requiresResponse(
              ' ${command.toLowerCase()} ',
            ),
            isTrue,
            reason: command,
          );
        }

        const noResponseCommands = <String>[
          'MODE:2',
          'BRIGHTNESS:75',
          'COLOR:#A1B2C3',
          'RGB:ON',
          'RGB:OFF',
          'UNRECOGNIZED',
        ];
        for (final command in noResponseCommands) {
          expect(
            P1CommandContract.requiresResponse(command),
            isFalse,
            reason: command,
          );
        }
      },
    );

    test('accepts only the established ACK success vocabulary', () {
      for (final reason in ['OK', 'ACCEPTED', 'READY', 'STARTING', 'ON', 'OFF']) {
        expect(P1CommandContract.isAckSuccessReason(reason), isTrue);
      }
      for (final reason in ['UNKNOWN', 'TIMEOUT', 'DISCONNECTED', 'REJECTED', 'ok']) {
        expect(P1CommandContract.isAckSuccessReason(reason), isFalse);
      }
    });
  });
}
