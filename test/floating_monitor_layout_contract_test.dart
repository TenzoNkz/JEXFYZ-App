// AI-MEMORY / TEST CONTRACT
// Checks the App-side Floating Monitor layout and presentation constraints from source.
// Android WindowManager attachment, OEM permissions, overlays, and live telemetry require device validation.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/floating_monitor.dart';
import '../lib/app_settings.dart';

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

  test('Floating Monitor native reconciliation is single-flight and lifecycle-bound', () {
    final source = File('lib/floating_monitor.dart').readAsStringSync();
    final start = source.indexOf('void _startRuntimeSync()');
    final end = source.indexOf('void dispose()', start);
    expect(start, isNonNegative);
    expect(end, greaterThan(start));
    final runtime = source.substring(start, end);

    expect(runtime, contains('Duration(seconds: 3)'));
    expect(runtime, contains('_runtimeSyncInFlight'));
    expect(runtime, contains('finally'));
    expect(runtime, isNot(contains('Duration(milliseconds: 300)')));
    expect(source, contains('runtimeTimer?.cancel();'));
    expect(source, contains('WidgetsBindingObserver'));
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
      RegExp(
        r'width:\s*designWidth,\s*height:\s*designHeight,\s*child:\s*child,',
      ).hasMatch(floating),
      isTrue,
    );
    expect(floating, contains('TextScaler.noScaling'));
    expect(floating, contains('JexFixedScalePage(compactUi: true, child: LanguageSettingsPage())'));
    expect(floating, contains('JexFixedScalePage(compactUi: true, child: AppearanceSettingsPage())'));
    expect(floating, contains('JexFixedScalePage(compactUi: true, child: NotificationsSettingsPage())'));
    expect(floating, contains('JexFixedScalePage(compactUi: true, child: BluetoothSettingsPage())'));
    expect(floating, contains('JexFixedScalePage(compactUi: true, child: FloatingSettingsPage())'));
    expect(
      RegExp(
        r"JexText\.phrase\s*\(\s*'Usage Statistics'\s*,\s*'Statistik Penggunaan'\s*,\s*language\s*,\s*\)",
      ).hasMatch(floating),
      isTrue,
    );
    expect(floating, contains('UsageStatisticsPage('));
    expect(
      RegExp(
        r'JexFixedScalePage\(\s*compactUi:\s*true,\s*child:\s*UsageStatisticsPage\(',
      ).hasMatch(floating),
      isTrue,
    );
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
    expect(settings, contains('EdgeInsets.fromLTRB(8, 10, 8, 5)'));
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

    final emptyStateHelper =
        connection.indexOf('connectionScanEmptyStateMessageKey(');
    expect(emptyStateHelper, isNonNegative);
    final emptyStateMessage = connection.indexOf(
      'JexText.of(messageKey, lang)',
      emptyStateHelper,
    );
    final emptyStateLayoutEnd =
        connection.indexOf('const SizedBox(height: 10)', emptyStateMessage);
    expect(emptyStateMessage, greaterThan(emptyStateHelper));
    expect(emptyStateLayoutEnd, greaterThan(emptyStateMessage));
    expect(
      connection.substring(emptyStateMessage, emptyStateLayoutEnd),
      contains('fontSize: 12,'),
    );
    expect(connection, contains('height: 42'));
    expect(connection, contains('tightFor(width: 42, height: 42)'));
    expect(connection, contains('tightFor(width: 40, height: 40)'));
    expect(
      main,
      contains('compactUi: true,\n              child: _ConnectionSheetContent('),
    );
    expect(main, contains('stream: FlutterBluePlus.isScanning'));
    expect(main, contains('stream: FlutterBluePlus.onScanResults'));
    expect(main, contains('key: ValueKey<int>(_scanGeneration)'));
    expect(main, contains('_scanErrorKey'));
    expect(main, contains('ConnectionScanCoordinator();'));
    expect(main, contains('beginPassiveAttempt()'));
    expect(main, contains('isPassiveAttemptCurrent(attempt)'));
    expect(main, contains('isConnectionHandoffActive'));
    expect(main, contains('hasActivePassiveAttempt'));
    expect(main, contains('hasActiveOneShotAttempt'));
    expect(main, contains('beginOneShotAttempt()'));
    expect(main, contains('isOneShotAttemptCurrent(attempt)'));
    expect(main, contains('finishOneShotAttempt(attempt)'));
    expect(main, contains('beginConnectionHandoff();'));
    expect(main, contains('completeConnectionHandoff();'));
    expect(main, contains('runSerialized(() async {'));
    expect(main, contains('onDeviceSelected:'));
    expect(main, contains('_finishManualConnectionSheet'));
    expect(main, contains('_prepareManualConnectionSheet'));
    expect(main, contains('Future<bool> _startScanFromSheet()'));

    final passiveStart = main.indexOf('void _startDisconnectRediscovery()');
    final passiveEnd = main.indexOf('void _handleBleDisconnected()', passiveStart);
    expect(passiveStart, isNonNegative);
    expect(passiveEnd, greaterThan(passiveStart));
    final passiveScanner = main.substring(passiveStart, passiveEnd);
    final startScanCall =
        passiveScanner.indexOf('await FlutterBluePlus.startScan(');
    final scanCompletionWait =
        passiveScanner.indexOf('await FlutterBluePlus.isScanning', startScanCall);
    final finishAttempt = passiveScanner.indexOf(
      '_connectionScanCoordinator.finishPassiveAttempt(attempt)',
      scanCompletionWait,
    );
    expect(startScanCall, isNonNegative);
    expect(scanCompletionWait, greaterThan(startScanCall));
    expect(finishAttempt, greaterThan(scanCompletionWait));

    final oneShotStart = main.indexOf('Future<void> _scanAndConnect(');
    final oneShotEnd = main.indexOf(
      'Future<void> _connect(BluetoothDevice target) async',
      oneShotStart,
    );
    expect(oneShotStart, isNonNegative);
    expect(oneShotEnd, greaterThan(oneShotStart));
    final oneShotScanner = main.substring(oneShotStart, oneShotEnd);
    final oneShotReservation = oneShotScanner.indexOf('beginOneShotAttempt()');
    final firstPermissionAwait =
        oneShotScanner.indexOf('await Permission.bluetoothScan.status');
    expect(oneShotReservation, isNonNegative);
    expect(firstPermissionAwait, greaterThan(oneShotReservation));
    expect(oneShotScanner, contains('if (!isCurrentAttempt()) return;'));
    expect(
      oneShotScanner.split('FlutterBluePlus.onScanResults.listen(').length - 1,
      2,
    );
    expect(
      oneShotScanner,
      isNot(contains('FlutterBluePlus.scanResults.listen(')),
    );
    expect(
      oneShotScanner.split('() => FlutterBluePlus.startScan(').length - 1,
      2,
    );
    expect(oneShotScanner, isNot(contains('await FlutterBluePlus.startScan(')));
    expect(oneShotScanner, isNot(contains('await FlutterBluePlus.stopScan(')));
    expect(oneShotScanner, contains('() => FlutterBluePlus.stopScan()'));

    final oneShotCommandStart =
        main.indexOf('Future<bool> _runOneShotScannerCommand(');
    final oneShotCommandEnd =
        main.indexOf('Future<void> _scanAndConnect(', oneShotCommandStart);
    expect(oneShotCommandStart, isNonNegative);
    expect(oneShotCommandEnd, greaterThan(oneShotCommandStart));
    final oneShotCommand = main.substring(oneShotCommandStart, oneShotCommandEnd);
    expect(oneShotCommand, contains('_connectionScanCoordinator.runSerialized('));
    expect(oneShotCommand, contains('isOneShotAttemptCurrent(attempt)'));

    expect(connection, contains('onPressed: _requestScan,'));
    expect(connection, isNot(contains('onPressed: widget.onScan')));
    expect(connection, contains('WidgetsBinding.instance.addPostFrameCallback'));
    expect(connection, isNot(contains('if (FlutterBluePlus.isScanningNow)')));

    // The existing DPI master-canvas scale is left intact; compactness is typography/density only.
    expect(floating, contains('final scale = constraints.maxWidth / designWidth;'));
    expect(floating, isNot(contains('(constraints.maxWidth / designWidth).clamp(0.0, 1.0).toDouble()')));
  });

  testWidgets(
    'Compact fixed-scale pages preserve the Home canvas across density changes',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      // Keep the physical display constant; vary DPR so logical width changes.
      tester.view.physicalSize = const Size(1080, 2400);

      Size? logicalCanvasSize;
      ThemeData? compactTheme;
      final inheritedTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3456AB),
          brightness: Brightness.light,
        ),
      );
      Future<void> pumpAtDensity(double devicePixelRatio) async {
        tester.view.devicePixelRatio = devicePixelRatio;
        await tester.pumpWidget(
          MaterialApp(
            theme: inheritedTheme,
            home: JexFixedScalePage(
              compactUi: true,
              child: Builder(
                builder: (context) {
                  logicalCanvasSize = MediaQuery.sizeOf(context);
                  compactTheme = Theme.of(context);
                  return const SizedBox.expand(key: ValueKey<String>('scale-probe'));
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(compactTheme!.textTheme.titleLarge!.fontSize, 18);
        expect(compactTheme!.textTheme.bodyLarge!.fontSize, 13);
        expect(compactTheme!.brightness, inheritedTheme.brightness);
        expect(compactTheme!.colorScheme.primary, inheritedTheme.colorScheme.primary);
        expect(compactTheme!.colorScheme.surface, inheritedTheme.colorScheme.surface);
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

      await pumpAtDensity(1080 / 350);
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
      expect(canvasTransform.transform.storage[0], closeTo(350 / 360, 0.01));
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

  test('Settings uses concise horizontal rows and meaningful values', () {
    final settingsSource = File('lib/floating_monitor.dart').readAsStringSync();
    final localizationSource = File('lib/app_settings.dart').readAsStringSync();
    final settingsStart = settingsSource.indexOf('class SettingsPage extends StatelessWidget');
    final settingsEnd = settingsSource.indexOf('class AboutSettingsPage', settingsStart);
    expect(settingsStart, isNonNegative);
    expect(settingsEnd, greaterThan(settingsStart));
    final settingsPage = settingsSource.substring(settingsStart, settingsEnd);

    final lockCard = settingsPage.indexOf('_voltageLockSettingRow(context, language, state)');
    final generalSection = settingsPage.indexOf("JexText.of('general', language)");
    expect(lockCard, isNonNegative);
    expect(generalSection, greaterThan(lockCard));
    expect(settingsPage, isNot(contains('DeviceDiagnosticsPage')));
    expect(settingsPage, isNot(contains('deviceDiagnostics')));

    final lockStart = settingsSource.indexOf('Widget _voltageLockSettingRow(');
    final lockEnd = settingsSource.indexOf('Widget _section(', lockStart);
    final lockLayout = settingsSource.substring(lockStart, lockEnd);
    expect(lockLayout, contains('width: 34'));
    expect(lockLayout, contains('height: 34'));
    expect(lockLayout, contains('fontSize: 12.5'));
    expect(lockLayout, contains('Switch.adaptive('));
    expect(lockLayout, contains('state.sessionReady && !state.busy'));
    expect(lockLayout, contains("ValueKey<String>('voltage-lock-card')"));
    expect(lockLayout, isNot(contains('subtitle')));
    expect(lockLayout, isNot(contains('CircularProgressIndicator')));
    expect(lockLayout, contains('color: scheme.onSurfaceVariant'));

    final firmwareSection = settingsPage.indexOf("JexText.of('firmwareSection', language)");
    final aboutRow = settingsPage.indexOf("JexText.of('about', language)");
    final aboutCard = settingsPage.indexOf('Card(\n                margin: const EdgeInsets.only(top: 8)');
    expect(firmwareSection, isNonNegative);
    expect(aboutCard, greaterThan(firmwareSection));
    expect(aboutRow, greaterThan(aboutCard));
    expect(settingsPage, contains("currentFirmwareVersion.trim() == 'V?'"));

    final itemStart = settingsSource.indexOf('Widget _item(');
    final itemEnd = settingsSource.indexOf('\n  }\n}', itemStart);
    expect(itemStart, isNonNegative);
    expect(itemEnd, greaterThan(itemStart));
    final itemLayout = settingsSource.substring(itemStart, itemEnd);
    expect(itemLayout, contains('BoxConstraints(minHeight: 48)'));
    expect(itemLayout, contains('maxLines: 1'));
    expect(itemLayout, contains('textAlign: TextAlign.end'));
    expect(itemLayout, contains('maxWidth: 88'));
    expect(itemLayout, contains('ConstrainedBox('));

    // Nonessential descriptors/counters are intentionally absent from Settings.
    expect(settingsPage, isNot(contains("'3'")));
    expect(settingsPage, isNot(contains('Temperature and operating history')));
    expect(settingsPage, isNot(contains("'JE Cooler'")));

    expect(settingsSource, contains('class AboutSettingsPage'));
    expect(settingsSource, isNot(contains('class DeviceDiagnosticsPage')));
    expect(settingsSource, contains('App Developer & Builder'));
    expect(settingsSource, contains('Special Thanks'));
    expect(settingsSource, contains('Ucapan Terima Kasih'));
    expect(settingsSource, contains('Pengembang Aplikasi & Perakit'));
    expect(settingsSource, contains('CrossAxisAlignment.stretch'));
    expect(settingsSource, contains('Design Inspiration'));
    expect(settingsSource, contains('3D Design & Printing'));
    expect(settingsSource, contains('@Horizontalzzz'));
    expect(settingsSource, contains('@FYZ737'));
    expect(settingsSource, contains('@Logos3dMichael'));
    expect(settingsSource, isNot(contains("'JE Cooler'")));
    expect(localizationSource, contains("'about': {"));
    expect(localizationSource, isNot(contains("'deviceDiagnostics': {")));
    expect(localizationSource, contains("'peltierFanRequiredTitle': {"));
  });

  testWidgets('About page renders localized Special Thanks credits with one aligned left edge', (tester) async {
    final previousLanguage = appLanguageNotifier.value;
    addTearDown(() => appLanguageNotifier.value = previousLanguage);
    appLanguageNotifier.value = AppLanguage.english;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        home: const AboutSettingsPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Special Thanks'), findsOneWidget);
    expect(find.text('JE Cooler'), findsNothing);
    expect(find.byType(Card), findsOneWidget);
    expect(find.text('App Developer & Builder'), findsOneWidget);
    expect(find.text('Horizon'), findsOneWidget);
    expect(find.text('@Horizontalzzz'), findsOneWidget);
    expect(find.text('Design Inspiration'), findsOneWidget);
    expect(find.text('FYZ'), findsOneWidget);
    expect(find.text('@FYZ737'), findsOneWidget);
    expect(find.text('3D Design & Printing'), findsOneWidget);
    expect(find.text('Logos'), findsOneWidget);
    expect(find.text('@Logos3dMichael'), findsOneWidget);

    final firstRoleLeft = tester.getTopLeft(find.text('App Developer & Builder')).dx;
    final secondRoleLeft = tester.getTopLeft(find.text('Design Inspiration')).dx;
    final thirdRoleLeft = tester.getTopLeft(find.text('3D Design & Printing')).dx;
    expect(secondRoleLeft, closeTo(firstRoleLeft, 0.01));
    expect(thirdRoleLeft, closeTo(firstRoleLeft, 0.01));

    appLanguageNotifier.value = AppLanguage.indonesia;
    await tester.pumpAndSettle();
    expect(find.text('Tentang'), findsOneWidget);
    expect(find.text('Ucapan Terima Kasih'), findsOneWidget);
    expect(find.text('JE Cooler'), findsNothing);
    expect(find.text('Pengembang Aplikasi & Perakit'), findsOneWidget);
    expect(find.text('Inspirasi Desain'), findsOneWidget);
    expect(find.text('Desain & Pencetakan 3D'), findsOneWidget);
    expect(find.text('@Horizontalzzz'), findsOneWidget);
    expect(find.text('@FYZ737'), findsOneWidget);
    expect(find.text('@Logos3dMichael'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Settings values share one line and redundant copy is absent', (tester) async {
    final previousLanguage = appLanguageNotifier.value;
    final previousTheme = appThemeNotifier.value;
    final previousAutoConnect = appAutoConnectNotifier.value;
    final previousLock = voltageLockSettingsNotifier.value;
    addTearDown(() {
      appLanguageNotifier.value = previousLanguage;
      appThemeNotifier.value = previousTheme;
      appAutoConnectNotifier.value = previousAutoConnect;
      voltageLockSettingsNotifier.value = previousLock;
    });
    appLanguageNotifier.value = AppLanguage.english;
    appThemeNotifier.value = AppThemePreset.dark;
    appAutoConnectNotifier.value = false;
    voltageLockSettingsNotifier.value = const VoltageLockSettingsState();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: SettingsPage(
          currentFirmwareVersion: 'V?',
          onOpenFirmwareUpdate: () async {},
          onVoltageLockChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    final languageCenter = tester.getCenter(find.text('Language'));
    final languageValueCenter = tester.getCenter(find.text('English'));
    expect((languageCenter.dy - languageValueCenter.dy).abs(), lessThan(3));

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('3'), findsNothing);
    expect(find.text('Temperature and operating history'), findsNothing);
    expect(find.text('JE Cooler'), findsNothing);
    expect(find.text('V?'), findsNothing);
    expect(find.text('Manual'), findsOneWidget);
    expect(find.text('OFF'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Lock Voltage stays one line and only its authoritative Switch changes state', (tester) async {
    final previousLanguage = appLanguageNotifier.value;
    final previousLock = voltageLockSettingsNotifier.value;
    addTearDown(() {
      appLanguageNotifier.value = previousLanguage;
      voltageLockSettingsNotifier.value = previousLock;
    });

    Future<double> pumpLockState(
      VoltageLockSettingsState state, {
      AppLanguage language = AppLanguage.english,
    }) async {
      appLanguageNotifier.value = language;
      voltageLockSettingsNotifier.value = state;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(useMaterial3: true),
          home: SettingsPage(
            currentFirmwareVersion: 'V7.2',
            onOpenFirmwareUpdate: () async {},
            onVoltageLockChanged: (_) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Not synchronized'), findsNothing);
      expect(find.text('Firmware V7.2+ required'), findsNothing);
      expect(find.text('Active · not saved'), findsNothing);
      expect(find.text('5V limit · Adaptive OFF'), findsNothing);
      expect(find.byKey(const ValueKey<String>('voltage-lock-card')), findsOneWidget);
      return tester.getSize(find.byKey(const ValueKey<String>('voltage-lock-card'))).height;
    }

    await pumpLockState(const VoltageLockSettingsState());
    expect(find.byType(Switch), findsNothing);
    expect(find.byType(Tooltip), findsWidgets);

    await pumpLockState(
      const VoltageLockSettingsState(sessionReady: true, known: false),
    );
    final unavailableTooltip = tester.widgetList<Tooltip>(find.byType(Tooltip))
        .firstWhere((tooltip) => tooltip.message == 'Firmware V7.2+ required');
    expect(unavailableTooltip.message, 'Firmware V7.2+ required');

    await pumpLockState(
      const VoltageLockSettingsState(
        sessionReady: true,
        known: true,
        active: true,
        saved: false,
      ),
    );
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byTooltip('Retry saving Lock Voltage'), findsOneWidget);

    final offHeight = await pumpLockState(
      const VoltageLockSettingsState(
        sessionReady: true,
        known: true,
        active: false,
        saved: true,
      ),
    );
    expect(find.byType(Switch), findsOneWidget);

    final onHeight = await pumpLockState(
      const VoltageLockSettingsState(
        sessionReady: true,
        known: true,
        active: true,
        saved: true,
      ),
    );
    expect(find.byType(Switch), findsOneWidget);
    expect(onHeight, closeTo(offHeight, 0.01));

    await pumpLockState(
      const VoltageLockSettingsState(
        sessionReady: true,
        known: true,
        active: true,
        saved: true,
        busy: true,
      ),
    );
    final busySwitch = tester.widget<Switch>(find.byType(Switch));
    expect(busySwitch.value, isTrue);
    expect(busySwitch.onChanged, isNull);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await pumpLockState(
      const VoltageLockSettingsState(sessionReady: true, known: false),
      language: AppLanguage.indonesia,
    );
    final localizedTooltip = tester.widgetList<Tooltip>(find.byType(Tooltip))
        .firstWhere((tooltip) => tooltip.message == 'Perlu Firmware V7.2+');
    expect(localizedTooltip.message, 'Perlu Firmware V7.2+');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Settings shows a known Firmware version as the right-side value', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: SettingsPage(
          currentFirmwareVersion: 'V7.2',
          onOpenFirmwareUpdate: () async {},
          onVoltageLockChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('V7.2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });


}
