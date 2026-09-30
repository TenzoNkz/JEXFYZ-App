// AI TEST MEMORY:
// These tests validate UI rendering and pure helper/parsing rules only.
// They do not prove BLE, OTA, or physical hardware runtime.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:jexfyz_cooler/main.dart';

void main() {
  testWidgets('JE Cooler dashboard renders', (tester) async {
    // Use a tall portrait viewport so the fixed Home canvas plus the
    // production submenu both have room to render without test-only overflow.
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const JeCoolerApp());
    await tester.pump();

    expect(find.text('JE X FYZ'), findsOneWidget);
    expect(find.text('Battery Temperature'), findsOneWidget);
    expect(find.text('Hotside Temperature'), findsOneWidget);
    expect(find.text('Voltage Indicator'), findsOneWidget);
    expect(find.text('Voltage'), findsOneWidget);
    expect(find.text('Adaptive Mode'), findsOneWidget);
    expect(find.text('Peltier Switch'), findsOneWidget);
    expect(find.text('Fan Switch'), findsOneWidget);
    expect(find.text('Fan Speed'), findsOneWidget);
    expect(find.text('Temperature'), findsOneWidget);

    // Notify is part of the Home dashboard. Its label may include a
    // contextual suffix such as "• ERROR", "• SYNC", etc.
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.data ?? '').trim().startsWith('NOTIFY'),
      ),
      findsOneWidget,
    );

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

  test('LED palette exposes current RGB colors', () {
    expect(ledColorPalette, hasLength(12));
    expect(ledColorPalette.first, '#FF0000');
    expect(ledColorPalette.last, '#FF0080');
    for (final hex in ledColorPalette) {
      expect(RegExp(r'^#[0-9A-F]{6}$').hasMatch(hex), isTrue);
      expect(ledPaletteColor(hex), isA<Color>());
    }
  });
}
