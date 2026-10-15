import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../lib/floating_monitor.dart';

void main() {
  test('Floating Monitor normalizes and persists compact size, opacity and background', () {
    const defaults = FloatingConfig();
    expect(defaults.size, closeTo(0.6, 0.0001));
    expect(defaults.opacity, closeTo(0.9, 0.0001));
    expect(defaults.backgroundColor, FloatingBackgroundColor.black);

    final smallest = FloatingConfig.fromJson(
      '{"enabled":true,"size":0.1,"opacity":0,"backgroundColor":"white"}',
    );
    expect(smallest.size, closeTo(0.3, 0.0001));
    expect(smallest.opacity, 0);
    expect(smallest.backgroundColor, FloatingBackgroundColor.white);
    expect(smallest.toMap()['backgroundColor'], 'white');

    final largest = FloatingConfig.fromJson(
      '{"size":1.8,"opacity":1.4,"backgroundColor":"unknown"}',
    );
    expect(largest.size, closeTo(0.8, 0.0001));
    expect(largest.opacity, 1);
    expect(largest.backgroundColor, FloatingBackgroundColor.black);
  });

  test('Floating Monitor settings show live numeric values and opacity marks', () {
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final settings = File('lib/app_settings.dart').readAsStringSync();

    expect(floating, contains('config.size.toStringAsFixed(2)'));
    expect(floating, contains('(config.opacity * 100).round()'));
    expect(floating, contains("minLabel: '0%'"));
    expect(floating, contains("midLabel: '50%'"));
    expect(floating, contains("maxLabel: '100%'"));
    expect(floating, contains('divisions: 100'));
    expect(floating, contains('SegmentedButton<FloatingBackgroundColor>'));
    expect(floating, contains("JexText.of('backgroundColor', lang)"));
    expect(settings, contains("'backgroundColor':"));
    expect(settings, contains("'black':"));
    expect(settings, contains("'white':"));
  });

  test('Native Floating Monitor centers text inside a freely draggable compact box', () {
    final native = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt',
    ).readAsStringSync();

    expect(native, contains('gravity = Gravity.TOP or Gravity.START'));
    expect(native, contains('layoutParams.x = downX + dx.roundToInt()'));
    expect(native, contains('layoutParams.y = downY + dy.roundToInt()'));
    expect(native, contains('var cursor = (width - contentWidth) / 2f'));
    expect(native, contains('val centeredX = (width - itemWidth(metric)) / 2f'));
    expect(native, contains('config.backgroundColor == "white"'));
    expect(native, contains('coerceIn(0.3f, 0.8f)'));
    expect(native, contains('coerceIn(0.0f, 1.0f)'));
    expect(native, isNot(contains('Gravity.CENTER_HORIZONTAL')));
  });
}
