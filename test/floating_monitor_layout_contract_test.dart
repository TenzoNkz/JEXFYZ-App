// AI-MEMORY / TEST CONTRACT
// Checks the App-side Floating Monitor layout and presentation constraints from source.
// Android WindowManager attachment, OEM permissions, overlays, and live telemetry require device validation.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../lib/floating_monitor.dart';

void main() {
  test('Floating Monitor normalizes and persists compact size, opacity and background', () {
    const defaults = FloatingConfig();
    expect(defaults.size, closeTo(0.6, 0.0001));
    expect(defaults.opacity, closeTo(0.9, 0.0001));
    expect(defaults.backgroundColor, FloatingBackgroundColor.black);
    expect(defaults.style, FloatingDisplayStyle.letters);

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
    expect(largest.size, closeTo(1.0, 0.0001));

    final stepped = FloatingConfig.fromJson('{"size":0.63,"style":"icons"}');
    expect(stepped.size, closeTo(0.65, 0.0001));
    expect(stepped.opacity, closeTo(0.9, 0.0001));
    expect(stepped.style, FloatingDisplayStyle.letters);
    expect(stepped.toMap()['style'], 'letters');

    final legacyOpacity = FloatingConfig.fromJson('{"size":0.63,"opacity":0.18}');
    expect(legacyOpacity.size, closeTo(0.65, 0.0001));
    expect(legacyOpacity.opacity, closeTo(0.20, 0.0001));
    expect(legacyOpacity.copyWith(opacity: 0.33).opacity, closeTo(0.35, 0.0001));
    expect(largest.opacity, 1);
    expect(largest.backgroundColor, FloatingBackgroundColor.black);
  });

  test('Floating Monitor legacy configuration migrates S to F and drops old FPS F', () {
    final migrated = FloatingConfig.fromJson(
      '{"order":["F","B","H","V","A","P","S"],"selected":["S"]}',
    );
    expect(migrated.order, <String>['B', 'H', 'V', 'A', 'P', 'F']);
    expect(migrated.selected, <String>{'F'});
    expect(migrated.toMap()['metricSchemaVersion'], FloatingMetric.schemaVersion);
  });

  test('Floating Monitor settings show live numeric values and opacity marks', () {
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final settings = File('lib/app_settings.dart').readAsStringSync();

    expect(floating, contains('config.size.toStringAsFixed(2)'));
    expect(floating, contains('max: 1.00'));
    expect(floating, contains('divisions: 14'));
    expect(floating, isNot(contains('size.toDouble().clamp(0.3, 0.8)')));
    expect(floating, isNot(contains('nativeSize.toDouble().clamp(0.3, 0.8)')));
    expect(floating, contains('nativeSize.toDouble().clamp(0.3, 1.0)'));
    expect(floating, contains('class JexFixedScalePage extends StatelessWidget'));
    expect(floating, contains('TextScaler.noScaling'));
    expect(floating, contains('telemetry: floatingTelemetryNotifier.value'));
    expect(floating, contains('size.toDouble().clamp(0.3, 1.0)'));
    expect(floating, contains("maxLabel: '1.00×'"));
    expect(floating, contains('(config.opacity * 100).round()'));
    expect(floating, contains("minLabel: '0%'"));
    expect(floating, isNot(contains("midLabel: '50%'")));
    expect(floating, contains("maxLabel: '100%'"));
    expect(floating, contains('divisions: 20'));
    expect(floating, isNot(contains("JexText.of('displayStyle', lang)")));
    expect(floating, isNot(contains('SegmentedButton<FloatingDisplayStyle>')));
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
    expect(native, contains('val leftX = dp(8f * scale)'));
    expect(native, isNot(contains('val centeredX = (width - itemWidth(metric)) / 2f')));
    expect(native, contains('config.style = "letters"'));
    expect(native, contains('config.enabled && data.connected'));
    expect(native, contains('if (config.enabled && data.connected) ensureOverlay() else removeOverlay()'));
    expect(native, contains('config.backgroundColor == "white"'));
    expect(native, contains('coerceIn(0.3f, 1.0f)'));
    expect(native, contains('coerceIn(0.0f, 1.0f)'));
    expect(native, isNot(contains('Gravity.CENTER_HORIZONTAL')));
  });

  test('Settings removes the About section and page entirely', () {
    final settingsSource = File('lib/floating_monitor.dart').readAsStringSync();
    final localizationSource = File('lib/app_settings.dart').readAsStringSync();
    final settingsStart = settingsSource.indexOf('class SettingsPage extends StatelessWidget');
    final settingsEnd = settingsSource.indexOf('class LanguageSettingsPage', settingsStart);
    expect(settingsStart, isNonNegative);
    expect(settingsEnd, greaterThan(settingsStart));
    final settingsPage = settingsSource.substring(settingsStart, settingsEnd);

    expect(settingsPage, isNot(contains("JexText.of('aboutSection'")));
    expect(settingsPage, isNot(contains("JexText.of('about'")));
    expect(settingsPage, isNot(contains('AboutSettingsPage')));
    expect(settingsSource, isNot(contains('class AboutSettingsPage')));
    expect(settingsSource, isNot(contains('class _AboutRow')));
    expect(localizationSource, isNot(contains("'aboutSection':")));
    expect(localizationSource, isNot(contains("'about':")));
  });

}
