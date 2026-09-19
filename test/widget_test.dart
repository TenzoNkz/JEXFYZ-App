import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/main.dart';

void main() {
  testWidgets('JE Cooler dashboard renders', (tester) async {
    await tester.pumpWidget(const JeCoolerApp());
    await tester.pump();
    expect(find.text('JE X FYZ'), findsOneWidget);
    expect(find.text('Battery Temperature'), findsOneWidget);
    expect(find.text('Adaptive Mode'), findsOneWidget);
    expect(find.text('VOLTAGE'), findsOneWidget);
    expect(find.text('TEMPERATURE'), findsOneWidget);
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
