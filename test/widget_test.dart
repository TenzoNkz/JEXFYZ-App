import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:jexfyz_cooler/main.dart';

void main() {
  testWidgets('JE Cooler dashboard renders', (tester) async {
    // Use a representative portrait surface for the production dashboard.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const JeCoolerApp());
    await tester.pump();

    expect(find.text('JE X FYZ'), findsOneWidget);
    expect(find.text('BATTERY TEMPERATURE'), findsOneWidget);
    expect(find.text('HOTSIDE TEMPERATURE'), findsOneWidget);

    expect(find.text('VOLTAGE TEMPERATURE'), findsOneWidget);
    expect(find.text('VOLTAGE'), findsOneWidget);

    expect(find.text('ADAPTIVE MODE'), findsOneWidget);
    expect(find.text('PELTIER SWITCH'), findsOneWidget);
    expect(find.text('FAN SWITCH'), findsOneWidget);
    expect(find.text('FAN SPEED'), findsOneWidget);
    expect(find.text('TEMPERATURE'), findsOneWidget);

    // Notify is part of the Home dashboard.
    expect(find.text('NOTIFY'), findsOneWidget);

    // The dashboard must render without a test-time layout exception.
    expect(tester.takeException(), isNull);
  });

  test('JE X FYZ voltage helper accepts only supported voltages', () {
    expect(isVoltageCommand('5V'), isTrue);
    expect(isVoltageCommand('9v'), isTrue);
    expect(isVoltageCommand('12V'), isTrue);
    expect(isVoltageCommand('13V'), isFalse);
    expect(isVoltageCommand('BR:128'), isFalse);
  });

  test('Firmware version parsing/comparison is numeric', () {
    expect(parseFirmwareVersion('V1.7'), [1, 7]);
    expect(parseFirmwareVersion('v3'), [3, 0]);
    expect(parseFirmwareVersion('V1.7.1'), isNull);
    expect(isNewerFirmwareVersion('V1.8', 'V1.7'), isTrue);
    expect(isNewerFirmwareVersion('V1.7', 'V1.8'), isFalse);
  });

  test('Hex color helper accepts six-digit RGB colors', () {
    expect(isValidHexColor('#FFFFFF'), isTrue);
    expect(isValidHexColor('#00ff7a'), isTrue);
    expect(isValidHexColor('FFFFFF'), isFalse);
    expect(isValidHexColor('#FFF'), isFalse);
  });
}
