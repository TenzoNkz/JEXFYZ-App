import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/source_contract_helpers.dart';

void main() {
  group('Dashboard phone battery telemetry', () {
    test(
      'platform read errors publish unavailable state and preserve the heartbeat contract',
      () {
        final source = File('lib/main.dart').readAsStringSync();
        const methodStart =
            'Future<void> _readBatteryTemperatureOnce({bool updateUi = true}) async {';
        const methodEnd = '  // AI-METHOD: _sendAndConfirm';
        final start = source.indexOf(methodStart);
        final end = source.indexOf(methodEnd, start);

        expect(start, isNonNegative);
        expect(end, greaterThan(start));

        final method = source.substring(start, end);
        final catchStart = method.indexOf('} catch (e) {');
        final finallyStart = method.indexOf('} finally {', catchStart);
        expect(catchStart, isNonNegative);
        expect(finallyStart, greaterThan(catchStart));

        final failurePath = method.substring(catchStart, finallyStart);
        expect(
          failurePath,
          containsDartFragment('''
if (updateUi && mounted) {
  setState(() {
    phoneBatteryValid = false;
    phoneBatteryTemp = '--';
  });
  _publishFloatingTelemetry();
}
'''),
        );
        expect(
          failurePath,
          containsDartFragment('''
UsageStatisticsRecorder.instance.recordTemperature(
  metric: 'battery',
  value: null,
)
'''),
        );
        expect(
          failurePath,
          containsDartFragment('''
if (_bleReady) {
  _queuePhoneBatteryHeartbeat('PHONE:BT=-1.0');
}
'''),
        );
        expect(
          source,
          containsDartFragment(
            "battery: connected && phoneBatteryValid ? phoneBatteryTemp : '--',",
          ),
        );
        expect(method, containsDartFragment('batteryReadBusy = false;'));
      },
    );
  });
}
