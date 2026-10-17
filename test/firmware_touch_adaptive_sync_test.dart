import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Touch Adaptive-OFF publishes authoritative state before its ACK', () {
    final source = File('firmware/JEXFYZ-V6.7.ino').readAsStringSync();
    final start = source.indexOf('static void executeTouchLong() {');
    final end = source.indexOf('static void processTouchInput()', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));

    final touchHandler = source.substring(start, end);
    final stateChange = touchHandler.indexOf('setAdaptiveState(false, reason);');
    final successAck = touchHandler.indexOf(
      'sendAck("TOUCH_ADAPTIVE", true, "OFF");',
      stateChange,
    );

    expect(stateChange, greaterThanOrEqualTo(0));
    expect(successAck, greaterThan(stateChange));

    final publication = touchHandler.substring(stateChange, successAck);
    expect(publication, contains('sendDelta("ADAPTIVE", boolText(adaptiveOn));'));
    expect(publication, contains('sendDelta("ADAPTIVE_CEILING", voltageToString(adaptiveCeiling));'));
    expect(publication, contains('sendDelta("FAN", boolText(fanOn));'));
    expect(publication, contains('sendDelta("PELTIER", boolText(peltierOn));'));
    expect(publication, contains('sendDelta("FAN_SPEED", String(fanPwm));'));
  });

  test('App consumes Adaptive telemetry as the shared displayed state', () {
    final source = File('lib/main.dart').readAsStringSync();

    expect(source, contains("case 'ADAPTIVE':\n        adaptiveOn = value == 'ON';"));
    expect(source, contains('adaptiveOn: connected && adaptiveOn,'));
  });
}
