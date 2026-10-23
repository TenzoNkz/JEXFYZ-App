// AI-MEMORY / TEST CONTRACT
// Checks the App-side Floating Monitor layout and presentation constraints from source.
// Android WindowManager attachment, OEM permissions, overlays, and live telemetry require device validation.

import 'dart:io';

import 'package:flutter/material.dart';
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
    expect(floating, contains('final scale = constraints.maxWidth / designWidth;'));
    expect(
      floating,
      isNot(contains('(constraints.maxWidth / designWidth).clamp(0.0, 1.0).toDouble()')),
    );
    expect(floating, contains('size: Size(designWidth, designHeight)'));
    expect(floating, contains('padding: EdgeInsets.fromLTRB('));
    expect(floating, contains('media.padding.left / scale'));
    expect(floating, contains('media.viewPadding.left / scale'));
    expect(floating, contains('media.viewInsets.left / scale'));
    expect(floating, contains('child: OverflowBox('));
    expect(floating, contains('minWidth: designWidth'));
    expect(floating, contains('maxWidth: designWidth'));
    expect(floating, contains('minHeight: designHeight'));
    expect(floating, contains('maxHeight: designHeight'));
    expect(
      floating,
      contains('width: designWidth,\n                      height: designHeight,\n                      child: child,'),
    );
    expect(floating, contains('TextScaler.noScaling'));
    expect(floating, contains('builder: (_) => const JexFixedScalePage(child: LanguageSettingsPage())'));
    expect(floating, contains('builder: (_) => const JexFixedScalePage(child: AppearanceSettingsPage())'));
    expect(floating, contains('builder: (_) => const JexFixedScalePage(child: NotificationsSettingsPage())'));
    expect(floating, contains('builder: (_) => const JexFixedScalePage(child: BluetoothSettingsPage())'));
    expect(floating, contains('builder: (_) => const JexFixedScalePage(child: FloatingSettingsPage())'));
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

  test('Settings and Connection use compact visual tokens without changing the DPI canvas', () {
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final appSettings = File('lib/app_settings.dart').readAsStringSync();
    final main = File('lib/main.dart').readAsStringSync();

    final settingsStart = floating.indexOf('class SettingsPage extends StatelessWidget');
    final settingsEnd = floating.indexOf('// AI-MEMORY / LANGUAGE-PAGE-CONTRACT', settingsStart);
    expect(settingsStart, isNonNegative);
    expect(settingsEnd, greaterThan(settingsStart));
    final settings = floating.substring(settingsStart, settingsEnd);
    expect(settings, contains('data: buildJexCompactUiTheme(preset)'));
    expect(settings, contains('EdgeInsets.fromLTRB(8, 13, 8, 6)'));
    expect(settings, contains('EdgeInsets.symmetric(horizontal: 12, vertical: 10)'));
    expect(settings, contains('fontSize: 13'));
    expect(settings, contains('fontSize: 11'));
    expect(settings, contains('size: 19'));
    expect(settings, contains('size: 16'));

    final floatingSettingsStart = floating.indexOf('class _FloatingSettingsPageState');
    final floatingSettingsEnd = floating.indexOf(
      'class JexFixedScalePage extends StatelessWidget',
      floatingSettingsStart,
    );
    expect(floatingSettingsStart, isNonNegative);
    expect(floatingSettingsEnd, greaterThan(floatingSettingsStart));
    final floatingSettings = floating.substring(floatingSettingsStart, floatingSettingsEnd);
    expect(floatingSettings, contains("JexText.of('functions', lang)"));
    expect(floatingSettings, contains("JexText.of('backgroundColor', lang)"));
    expect(floatingSettings, contains("JexText.of('orientation', lang)"));
    expect(floatingSettings, contains('fontSize: 11, fontWeight: FontWeight.w900'));
    expect(floatingSettings, contains('fontSize: 10, fontWeight: FontWeight.w800'));
    expect(floatingSettings, contains('valueLabel'));
    expect(floatingSettings, contains('fontSize: 10, fontWeight: FontWeight.w900'));

    expect(floating, contains('final bool compactUi;'));
    expect(floating, contains('this.compactUi = false'));
    expect(floating, contains('buildJexCompactUiTheme('));
    expect(floating, contains('baseTheme: Theme.of(context)'));
    for (final page in [
      'LanguageSettingsPage',
      'AppearanceSettingsPage',
      'NotificationsSettingsPage',
      'BluetoothSettingsPage',
      'FloatingSettingsPage',
    ]) {
      expect(
        settings,
        contains('JexFixedScalePage(compactUi: true, child: $page())'),
      );
    }

    expect(appSettings, contains('ThemeData buildJexCompactUiTheme('));
    expect(appSettings, contains('AppThemePreset preset'));
    expect(appSettings, contains('ThemeData? baseTheme'));
    expect(appSettings, contains('fontSize: 18'));
    expect(appSettings, contains('fontSize: 13'));
    expect(appSettings, contains('fontSize: 12'));
    expect(appSettings, contains('fontSize: 11'));
    expect(appSettings, contains('VisualDensity(horizontal: -0.5, vertical: -0.5)'));

    expect(main, contains('compactUi: true,\n          child: SettingsPage('));
    final connectionStart = main.indexOf('class _ConnectionSheetContentState');
    final connectionEnd = main.indexOf('class StaticSwitcher', connectionStart);
    expect(connectionStart, isNonNegative);
    expect(connectionEnd, greaterThan(connectionStart));
    final connection = main.substring(connectionStart, connectionEnd);
    expect(connection, contains('height: 60,'));
    expect(connection, contains('fontSize: 16,'));
    expect(connection, contains('fontSize: 9.5,'));
    final devicesStart = connection.indexOf("JexText.of('devices', lang)");
    final devicesEnd = connection.indexOf('IconButton(', devicesStart);
    expect(devicesStart, isNonNegative);
    expect(devicesEnd, greaterThan(devicesStart));
    final devicesLabel = connection.substring(devicesStart, devicesEnd);
    expect(devicesLabel, contains('fontSize: 13,'));

    final emptyStateStart = connection.indexOf(
      "unavailable ? JexText.of('connectionUnavailable', lang) : JexText.of('scanning', lang)",
    );
    final emptyStateEnd = connection.indexOf('const SizedBox(height: 10)', emptyStateStart);
    expect(emptyStateStart, isNonNegative);
    expect(emptyStateEnd, greaterThan(emptyStateStart));
    final emptyStateMessage = connection.substring(emptyStateStart, emptyStateEnd);
    expect(emptyStateMessage, contains('fontSize: 12,'));
    expect(connection, contains('height: 42'));
    expect(connection, contains('tightFor(width: 42, height: 42)'));
    expect(connection, contains('tightFor(width: 40, height: 40)'));
    expect(
      main,
      contains('compactUi: true,\n              child: _ConnectionSheetContent('),
    );

    // The existing DPI master-canvas scale is left intact; compactness is typography/density only.
    expect(floating, contains('final scale = constraints.maxWidth / designWidth;'));
    expect(floating, isNot(contains('(constraints.maxWidth / designWidth).clamp(0.0, 1.0).toDouble()')));
  });

  testWidgets(
    'Fixed-scale pages match the Home canvas across display-density changes',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      // Keep the physical display constant; vary DPR so logical width changes.
      tester.view.physicalSize = const Size(1080, 2400);

      Size? logicalCanvasSize;
      Future<void> pumpAtDensity(double devicePixelRatio) async {
        tester.view.devicePixelRatio = devicePixelRatio;
        await tester.pumpWidget(
          MaterialApp(
            home: JexFixedScalePage(
              child: Builder(
                builder: (context) {
                  logicalCanvasSize = MediaQuery.sizeOf(context);
                  return const SizedBox.expand(key: ValueKey<String>('scale-probe'));
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      await pumpAtDensity(1080 / 420);
      expect(logicalCanvasSize!.width, closeTo(360.0, 0.01));
      expect(logicalCanvasSize!.height, closeTo(800.0, 0.01));
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('scale-probe'))).width,
        closeTo(360.0, 0.01),
      );
      var canvasTransform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(JexFixedScalePage),
          matching: find.byType(Transform),
        ),
      );
      expect(canvasTransform.transform.storage[0], closeTo(420 / 360, 0.01));
      expect(
        360.0 * canvasTransform.transform.storage[0] * tester.view.devicePixelRatio,
        closeTo(1080.0, 0.01),
      );
      expect(
        800.0 * canvasTransform.transform.storage[0] * tester.view.devicePixelRatio,
        closeTo(2400.0, 0.01),
      );

      await pumpAtDensity(1080 / 320);
      expect(logicalCanvasSize!.width, closeTo(360.0, 0.01));
      expect(logicalCanvasSize!.height, closeTo(800.0, 0.01));
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('scale-probe'))).width,
        closeTo(360.0, 0.01),
      );
      canvasTransform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(JexFixedScalePage),
          matching: find.byType(Transform),
        ),
      );
      expect(canvasTransform.transform.storage[0], closeTo(320 / 360, 0.01));
      expect(
        360.0 * canvasTransform.transform.storage[0] * tester.view.devicePixelRatio,
        closeTo(1080.0, 0.01),
      );
      expect(
        800.0 * canvasTransform.transform.storage[0] * tester.view.devicePixelRatio,
        closeTo(2400.0, 0.01),
      );
    },
  );

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
