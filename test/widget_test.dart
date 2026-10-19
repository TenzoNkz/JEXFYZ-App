import 'dart:io';
// AI-MEMORY / TEST CONTRACT
// This file validates deterministic UI helpers, localization contracts, and pure parsing rules.
// It does not prove BLE, Android OEM permission behavior, overlay compositing, OTA transport,
// or physical firmware behavior.
// Localization contract under test: English/Indonesia names stay stable; ON/OFF becomes
// HIDUP/MATI only in Indonesia. BLE protocol tokens remain English machine identifiers.

// AI TEST MEMORY:
// These tests validate UI rendering and pure helper/parsing rules only.
// They do not prove BLE, OTA, or physical hardware runtime.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:jexfyz_cooler/main.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/floating_monitor.dart';

void main() {
  test('Display-menu lock policy covers all disconnected menus and Adaptive-only restrictions', () {
    for (var tab = 0; tab < 5; tab++) {
      expect(
        displayMenuLockReason(
          connected: false,
          adaptiveActive: false,
          adaptiveTransitioning: false,
          tabIndex: tab,
        ),
        DisplayMenuLockReason.bluetoothDisconnected,
        reason: 'Disconnected submenu $tab must receive the full-menu Bluetooth lock.',
      );
    }

    for (var tab = 0; tab < 5; tab++) {
      final expected = const <int>{0, 1, 4}.contains(tab)
          ? DisplayMenuLockReason.adaptiveActive
          : DisplayMenuLockReason.none;
      expect(
        displayMenuLockReason(
          connected: true,
          adaptiveActive: true,
          adaptiveTransitioning: false,
          tabIndex: tab,
        ),
        expected,
        reason: 'Adaptive should lock Voltage, Control, and Temperature only.',
      );
    }

    expect(
      displayMenuLockReason(
        connected: true,
        adaptiveActive: false,
        adaptiveTransitioning: true,
        tabIndex: 1,
      ),
      DisplayMenuLockReason.adaptiveActive,
    );
    expect(
      displayMenuLockReason(
        connected: true,
        adaptiveActive: false,
        adaptiveTransitioning: false,
        tabIndex: 2,
      ),
      DisplayMenuLockReason.none,
    );
  });

  test('Display lock overlays blur one complete submenu and center one lock panel', () {
    final source = File('lib/main.dart').readAsStringSync();
    final tabsStart = source.indexOf('Widget _buildTabContent()');
    final tabsEnd = source.indexOf('// AI-METHOD / HOME-CONTRACT', tabsStart);
    expect(tabsStart, isNonNegative);
    expect(tabsEnd, greaterThan(tabsStart));
    final lockSource = source.substring(tabsStart, tabsEnd);
    expect(lockSource, contains('_lockedDisplayMenu(content, lockReason)'));
    expect(lockSource, contains('ImageFiltered('));
    expect(lockSource, contains('ImageFilter.blur(sigmaX: 4.8, sigmaY: 4.8)'));
    expect(lockSource, contains('IgnorePointer(child: content)'));
    expect(lockSource, contains('Positioned.fill('));
    expect(lockSource, contains('child: Center('));
    expect(lockSource, contains('CONNECT TO JE X FYZ FIRST'));
    expect(lockSource, contains('LOCKED BY ADAPTIVE MODE'));
    expect(lockSource, isNot(contains('_tab(')));

    final buildStart = source.indexOf('Widget build(BuildContext context) {', source.indexOf('class _DashboardScreenState'));
    final dashboardBuild = source.substring(buildStart);
    expect(dashboardBuild.indexOf('_tab(JexText.of'), lessThan(dashboardBuild.indexOf('_buildTabContent()')));
  });

  test('Peltier Adaptive and LED switches mirror manual Voltage without labels or checkmarks', () {
    final source = File('lib/main.dart').readAsStringSync();
    final rowStart = source.indexOf('Widget _switchRow(');
    final rowEnd = source.indexOf('Widget _jexToggle(', rowStart);
    expect(rowStart, isNonNegative);
    expect(rowEnd, greaterThan(rowStart));
    final row = source.substring(rowStart, rowEnd);
    expect(row, contains('bool showStateLabel = true'));
    expect(row, contains('bool showCheck = true'));
    expect(row, contains('bool neutralRow = false'));
    expect(row, contains('if (showStateLabel) ...['));
    expect(row, contains('showCheck: showCheck,'));

    for (final marker in [
      "title: JexText.of('peltier', lang)",
      "title: JexText.of('fan', lang)",
      "title: JexText.of('adaptiveSwitch', lang)",
      "title: JexText.of('power', lang)",
    ]) {
      final start = source.indexOf(marker);
      final end = source.indexOf('onChanged:', start);
      expect(start, isNonNegative, reason: 'Missing switch row: $marker');
      expect(end, greaterThan(start));
      final call = source.substring(start, end);
      expect(call, contains('showStateLabel: false'));
      expect(call, contains('showCheck: false'));
      expect(call, contains('neutralRow: true'));
    }
  });

  test('Hotside contour is continuous and indicator painters have distinct motion signatures', () {
    final source = File('lib/main.dart').readAsStringSync();
    final shellStart = source.indexOf('Path _hotsideSilhouette(double s)');
    final shellEnd = source.indexOf('void _drawAdaptiveArrowHead', shellStart);
    expect(shellStart, isNonNegative);
    expect(shellEnd, greaterThan(shellStart));
    final hotsideShell = source.substring(shellStart, shellEnd);
    expect(hotsideShell, contains('..cubicTo('));
    expect(hotsideShell, isNot(contains('..addRRect(')));
    expect(hotsideShell, isNot(contains('..addOval(')));

    final painterStart = source.indexOf('class _JexIconPainter extends CustomPainter {');
    final painterEnd = source.indexOf('const MethodChannel securityChannel', painterStart);
    final painter = source.substring(painterStart, painterEnd);
    for (final effect in [
      'final sheenRect',
      'final bulbRadius',
      '_drawAdaptiveFlow(canvas, s, active ? angle : 0.0, mainColor, strength)',
      'final branchPulse',
      'final electricalSpine = Path()',
      'metric.extractPath(tail, head)',
      'Path _flameTonguePath(',
      'void _drawSnowflake(',
      'final rotor = _fanSilhouette(s, angle)',
      'final needleAngle = start + sweep * safeLevel',
      'Connection status is represented by colour, not Bluetooth-icon motion.',
    ]) {
      expect(painter, contains(effect), reason: 'Missing refined effect: $effect');
    }
    expect(painter, isNot(contains('_adaptiveLoop(s, angle)')));
    expect(painter, isNot(contains('final flowAngle = phase * 2 + .6;')));
    expect(painter, isNot(contains('final sweepRect = Rect.fromLTWH')));
    expect(painter, isNot(contains('final glintStart = start + sweep * p;')));
    expect(painter, isNot(contains('jexFanSpeedNeedleWobble')));

    final adaptiveStart = painter.indexOf('void _drawAdaptiveFlow');
    final adaptiveEnd = painter.indexOf('Path _crystalSilhouette', adaptiveStart);
    final adaptive = painter.substring(adaptiveStart, adaptiveEnd);
    expect(adaptive, isNot(contains('flowAngle')));
    expect(adaptive, isNot(contains('Offset(center.dx + math.cos(flowAngle)')));

    final flamesStart = painter.indexOf('void _drawThermalFlames');
    final flamesEnd = painter.indexOf('void _drawSnowflake', flamesStart);
    final flames = painter.substring(flamesStart, flamesEnd);
    expect(flames, contains('_flameTonguePath'));
    expect(flames, contains('baseline - height'));
    expect(flames, isNot(contains('canvas.drawCircle')));
    expect(flames, isNot(contains('canvas.drawLine')));

    final snowStart = painter.indexOf('void _drawSnowflake');
    final snowEnd = painter.indexOf('void _drawFanAirflow', snowStart);
    final snow = painter.substring(snowStart, snowEnd);
    expect(snow, contains('branchAngle'));
    expect(snow, contains('fall * 1.24'));
    expect(snow, isNot(contains('canvas.drawCircle')));

    final airflowStart = painter.indexOf('void _drawFanAirflow');
    final airflowEnd = painter.indexOf('@override\\n  void paint', airflowStart);
    final airflow = painter.substring(airflowStart, airflowEnd);
    expect(airflow, contains('These streamlines orbit inside the rotor footprint'));
    expect(airflow, contains('math.sin(startAngle)'));
    expect(airflow, isNot(contains('final x1 = s * (.70 + offset * .095)')));
  });

  testWidgets('tamper screen shows an insult-only wall and opens developer contact',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    var contactRequested = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(securityChannel, (call) async {
      if (call.method == 'openDeveloperContact') {
        contactRequested = true;
        return true;
      }
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(securityChannel, null);
    });

    await tester.pumpWidget(const TamperApp());
    await tester.pump();

    expect(find.text('HUBUNGI DEVELOPER'), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
    expect(find.textContaining('KONTOL'), findsWidgets);
    expect(find.textContaining('MEMEK'), findsWidgets);
    expect(find.textContaining('ANJING'), findsWidgets);
    expect(find.textContaining('MONYET'), findsWidgets);
    expect(find.textContaining('BABI'), findsWidgets);

    final renderedText = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
        .join(' ')
        .toLowerCase();
    for (final forbidden in [
      'integrity',
      'integritas',
      'build',
      'verifikasi',
      'modifikasi',
      'telegram',
      '@horizontalzzz',
      'exit',
    ]) {
      expect(renderedText, isNot(contains(forbidden)));
    }

    final screenSource = File('lib/main.dart').readAsStringSync();
    final screenStart = screenSource.indexOf('class TamperScreen extends StatelessWidget {');
    final screenEnd = screenSource.indexOf('\nclass JeCoolerApp extends StatelessWidget {', screenStart);
    expect(screenStart, isNonNegative);
    expect(screenEnd, greaterThan(screenStart));
    final screenContract = screenSource.substring(screenStart, screenEnd).toLowerCase();
    expect(screenContract, isNot(contains('integrity')));
    expect(screenContract, isNot(contains('integritas')));
    expect(screenContract, isNot(contains('official build')));
    expect(screenContract, contains('opendevelopercontact'));
    expect(screenContract, contains('child: icon('));
    expect(screenContract, contains('phosphoriconsbold.warning'));
    expect(screenContract, isNot(contains('jexanimatedicon.glyph')));
    expect(
      screenContract,
      contains('padding: const edgeinsets.symmetric(horizontal: 12, vertical: 4)'),
    );
    expect(screenContract, contains('color: const color(0xff101014)'));
    expect(screenContract, contains('borderradius: borderradius.circular(12)'));
    expect(
      screenContract,
      contains('border.all(color: const color(0xff30252a), width: 1)'),
    );
    expect(screenContract, contains('textalign: textalign.center'));
    expect(screenContract, contains('softwrap: true'));

    final nativeSource = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt',
    ).readAsStringSync();
    expect(nativeSource, contains('"openDeveloperContact" -> result.success(openDeveloperContact())'));
    expect(nativeSource, contains('Uri.parse("https://t.me/horizontalzzz")'));

    await tester.tap(find.text('HUBUNGI DEVELOPER'));
    await tester.pump();
    expect(contactRequested, isTrue);
    expect(tester.takeException(), isNull);
  });

  test('Dashboard indicators use integrated 2D silhouettes instead of stacked ornaments', () {
    final source = File('lib/main.dart').readAsStringSync();
    final start = source.indexOf('class _JexIconPainter extends CustomPainter {');
    final end = source.indexOf('const MethodChannel securityChannel', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final painter = source.substring(start, end);
    expect(painter, contains('Path _batterySilhouette'));
    expect(painter, contains('Path _hotsideSilhouette'));
    expect(painter, contains('void _drawAdaptiveFlow'));
    expect(painter, contains('void _drawAdaptiveArrowHead'));
    expect(painter, contains('Path _crystalSilhouette'));
    expect(painter, contains('Path _fanSilhouette'));
    expect(painter, contains('final warningBlend ='));
    expect(painter, isNot(contains('_drawGlow')));
    expect(painter, contains('_drawThermalFlames'));
    expect(painter, contains('_drawFrostParticles'));
    expect(painter, contains('_drawFanAirflow'));
    expect(painter, isNot(contains('_drawFanBlade')));
    expect(painter, isNot(contains('sparkCount')));
    expect(painter, isNot(contains('particleAngle')));
  });

  test('BLE session protocol gate accepts only P1', () {
    expect(isSupportedP1Protocol('P1'), isTrue);
    expect(isSupportedP1Protocol(' p1 '), isTrue);
    expect(isSupportedP1Protocol('P2'), isFalse);
    expect(isSupportedP1Protocol(''), isFalse);
  });

  test('stale Peltier re-arm notice clears after healthy firmware state', () {
    final notice = peltierRearmNotice(45, AppLanguage.english);
    expect(shouldClearStaleNotifyError(
      connected: true,
      safety: 'OK',
      safetyReason: 'NONE',
      liveTelemetryReceived: true,
      notice: notice,
    ), isTrue);
    expect(shouldClearStaleNotifyError(
      connected: true,
      safety: 'LOCKED',
      safetyReason: 'PELTIER_SAFETY_LATCH',
      liveTelemetryReceived: true,
      notice: notice,
    ), isFalse);
  });

  test('ONLINE_IMAGE_VALIDATE maps to its OTA localization key', () {
    expect(otaStageLocalizationKey('ONLINE_IMAGE_VALIDATE'), 'otaStageOnlineImageValidate');
    expect(otaStageLocalizationKey('UNKNOWN_STAGE'), '');
  });

  testWidgets('JE Cooler dashboard renders', (tester) async {
    // AI-MEMORY / DASHBOARD-VIEWPORT-CONTRACT
    // Use a tall portrait viewport so the fixed Home canvas and production submenu render
    // without test-only overflow. This is a UI layout guard, not device-runtime validation.
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
    expect(find.text('VOLTAGE'), findsWidgets);
    expect(find.text('Low Mode'), findsOneWidget);
    expect(find.text('Mid Mode'), findsOneWidget);
    expect(find.text('High Mode'), findsOneWidget);
    expect(find.text('VERTICAL'), findsNothing);
    expect(find.text('Side Text'), findsNothing);
    expect(find.text('5V'), findsOneWidget);
    expect(find.text('9V'), findsOneWidget);
    expect(find.text('12V'), findsOneWidget);

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



  test('Localization keeps language names stable and maps power states correctly', () {
    // AI-MEMORY / LOCALIZATION-CONTRACT
    // Language names must be English / Indonesia regardless of the selected language.
    expect(JexText.of('english', AppLanguage.english), 'English');
    expect(JexText.of('english', AppLanguage.indonesia), 'English');
    expect(JexText.of('indonesia', AppLanguage.english), 'Indonesia');
    expect(JexText.of('indonesia', AppLanguage.indonesia), 'Indonesia');
    // Indonesia uses baku UI terminology while coding identifiers remain English.
    expect(JexText.of('temperature', AppLanguage.indonesia), 'Suhu');
    expect(JexText.of('batteryTemperature', AppLanguage.indonesia), 'Suhu Baterai');
    expect(JexText.of('hotsideTemperature', AppLanguage.indonesia), 'Suhu Panas');
    expect(JexText.of('hotsideTemperature', AppLanguage.english), 'Hotside Temperature');
    expect(JexText.of('speed', AppLanguage.english), 'Fan');
    expect(JexText.of('speed', AppLanguage.indonesia), 'Kipas');
    expect(JexText.of('fanSpeedLabel', AppLanguage.english), 'Fan Speed');
    expect(JexText.of('fanSpeedLabel', AppLanguage.indonesia), 'Kecepatan Kipas');
    expect(JexText.of('power', AppLanguage.english), 'RGB Power');
    expect(JexText.of('power', AppLanguage.indonesia), 'Daya RGB');
    expect(JexText.of('voltage', AppLanguage.indonesia), 'Tegangan');
    expect(JexText.of('voltageIndicator', AppLanguage.indonesia), 'Indikator Tegangan');
    expect(JexText.of('brightness', AppLanguage.indonesia), 'Kecerahan');
    expect(JexText.of('default', AppLanguage.indonesia), 'Bawaan');
    expect(JexText.of('opacity', AppLanguage.indonesia), 'Transparansi');
    expect(JexText.of('adaptiveSwitch', AppLanguage.indonesia), 'Sakelar Adaptif');
    expect(JexText.of('adaptiveOn', AppLanguage.indonesia), 'Mode Adaptif aktif.');
    expect(JexText.of('adaptiveOff', AppLanguage.indonesia), 'Mode Adaptif nonaktif.');
    expect(JexText.of('allow', AppLanguage.indonesia), 'Izinkan');
    expect(JexText.of('unknownError', AppLanguage.indonesia), 'Kesalahan tidak diketahui');

    // User-facing power states are ON/OFF in English and HIDUP/MATI in Indonesia.
    expect(JexText.of('on', AppLanguage.english), 'ON');
    expect(JexText.of('off', AppLanguage.english), 'OFF');
    expect(JexText.of('on', AppLanguage.indonesia), 'HIDUP');
    expect(JexText.of('off', AppLanguage.indonesia), 'MATI');
  });

  test('Peltier re-arm notify uses the 1C safety hysteresis threshold', () {
    expect(
      peltierRearmNotice(45, AppLanguage.english),
      'Peltier is locked. Cool the Hotside to ≤ 44°C before restarting.',
    );
    expect(
      peltierRearmNotice(45, AppLanguage.indonesia),
      'Peltier terkunci. Dinginkan Hotside hingga ≤ 44°C sebelum menyalakan kembali.',
    );
  });


  test('Battery thermal colours stay ice blue through 30C and turn red at 40C', () {
    expect(jexThermalBatteryLevel('20.0'), 0);
    expect(jexThermalBatteryLevel('30.0°C'), 0);
    expect(jexThermalBatteryLevel('35.0'), closeTo(.5, 1e-9));
    expect(jexThermalBatteryLevel('40.0'), 1);
    expect(jexThermalBatteryLevel('45.0'), 1);
    expect(jexThermalBatteryLevel('--'), 0);
    expect(jexThermalBatteryFireActive('39.99'), isFalse);
    expect(jexThermalBatteryFireActive('40.0'), isTrue);
    expect(jexThermalBatteryFireActive('--'), isFalse);

    expect(jexThermalBatteryColor('18.0'), jexThermalIceBlue);
    expect(jexThermalBatteryColor('20.0'), jexThermalIceBlue);
    expect(jexThermalBatteryColor('30.0'), jexThermalIceBlue);
    expect(jexThermalBatteryColor('35.0'), isNot(jexThermalIceBlue));
    expect(jexThermalBatteryColor('35.0'), isNot(jexThermalRed));
    expect(jexThermalBatteryColor('40.0'), jexThermalRed);
    expect(jexThermalBatteryColor('45.0'), jexThermalRed);
    expect(jexThermalBatteryColor('--'), jexThermalIceBlue);
  });

  test('Hotside colour starts ice blue at 30C and reaches red at its configured limit', () {
    expect(jexHotsideTemperatureColor('29.9', hotLimit: 45), jexThermalIceBlue);
    expect(jexHotsideTemperatureColor('30.0', hotLimit: 45), jexThermalIceBlue);
    expect(jexHotsideTemperatureColor('--', hotLimit: 45), jexThermalIceBlue);
    expect(jexHotsideTemperatureColor('35.0', hotLimit: 45), isNot(jexThermalIceBlue));
    expect(jexHotsideTemperatureColor('40.0', hotLimit: 45), isNot(jexThermalRed));
    expect(jexHotsideTemperatureColor('44.0', hotLimit: 45), isNot(jexThermalRed));
    expect(jexHotsideTemperatureColor('45.0', hotLimit: 45), jexThermalRed);
    expect(jexHotsideTemperatureColor('35.0', hotLimit: 35), jexThermalRed);
    expect(jexHotsideTemperatureColor('49.0', hotLimit: 50), isNot(jexThermalRed));
    expect(jexHotsideTemperatureColor('50.0', hotLimit: 50), jexThermalRed);
    expect(jexHotsideFireActive('44.99', hotLimit: 45), isFalse);
    expect(jexHotsideFireActive('45.0', hotLimit: 45), isTrue);
    expect(jexHotsideFireActive('--', hotLimit: 45), isFalse);
    expect(jexTemperatureIndicatorLevel('45.0', minC: 30, maxC: 45), 1);
    expect(jexTemperatureIndicatorLevel('44.0', minC: 30, maxC: 45), lessThan(1));
  });

  test('Voltage colour and energy are consistent for 5V, 9V, 12V and disconnected fallback', () {
    expect(jexVoltageIndicatorColor('5V'), const Color(0xFFFF4D5A));
    expect(jexVoltageIndicatorColor('9V'), const Color(0xFF52E6A2));
    expect(jexVoltageIndicatorColor('12V'), const Color(0xFF4D8CFF));
    expect(jexVoltageIndicatorColor('--'), const Color(0xFFFF4D5A));
    expect(jexVoltageEnergyLevel('5V'), lessThan(jexVoltageEnergyLevel('9V')));
    expect(jexVoltageEnergyLevel('9V'), lessThan(jexVoltageEnergyLevel('12V')));
    expect(jexVoltageEnergyLevel('--'), 0);
  });

  test('Home sensor icon levels are clamped and never invent a missing temperature', () {
    expect(
      jexTemperatureIndicatorLevel('45 °C', minC: 20, maxC: 60),
      closeTo(.625, .0001),
    );
    expect(jexTemperatureIndicatorLevel('20°C', minC: 20, maxC: 60), 0);
    expect(jexTemperatureIndicatorLevel('80°C', minC: 20, maxC: 60), 1);
    expect(
      jexTemperatureIndicatorLevel('--', minC: 20, maxC: 60, fallback: .42),
      .42,
    );
  });

  test('Home Notify connection status is localized in English and Indonesian', () {
    String label({
      required bool connected,
      String notice = '',
      bool connecting = false,
      bool syncing = false,
      AppLanguage language = AppLanguage.english,
    }) =>
        homeNotifyConnectionLabel(
          notice: notice,
          isConnecting: connecting,
          isSyncing: syncing,
          connected: connected,
          language: language,
        );

    expect(label(connected: true), 'CONNECTED');
    expect(label(connected: false), 'DISCONNECTED');
    expect(label(connected: true, language: AppLanguage.indonesia), 'TERHUBUNG');
    expect(label(connected: false, language: AppLanguage.indonesia), 'TERPUTUS');
    expect(label(connected: false, connecting: true), 'CONNECTING');
    expect(label(connected: false, syncing: true), 'SYNCING');
    expect(label(connected: false, notice: 'Wireless ADB failed'), 'ERROR');
    expect(label(connected: false, notice: 'Bluetooth Disconnected'), 'DISCONNECTED');
    expect(label(connected: true, notice: 'Bluetooth Disconnected'), 'CONNECTED');
  });

  test('Home Fan Speed shows authoritative PWM in Adaptive and Manual at 12V', () {
    expect(
      homeFanSpeedDisplay(
        connected: true,
        fanOn: true,
        voltage: '12V',
        adaptiveOn: true,
        fanSpeed: 70,
        offLabel: 'OFF',
      ),
      '70%',
    );
    expect(
      homeFanSpeedDisplay(
        connected: true,
        fanOn: true,
        voltage: '12V',
        adaptiveOn: false,
        fanSpeed: 70,
        offLabel: 'OFF',
      ),
      '70%',
    );
    expect(
      homeFanSpeedDisplay(
        connected: true,
        fanOn: true,
        voltage: '9V',
        adaptiveOn: true,
        fanSpeed: 70,
        offLabel: 'OFF',
      ),
      '100%',
    );
  });

  test('Floating Monitor migrates legacy FPS and Speed configuration to six metrics', () {
    final config = FloatingConfig.fromJson(
      '{"order":["F","B","H","V","A","P","S"],"selected":["F","S"]}',
    );
    expect(config.order, <String>['B', 'H', 'V', 'A', 'P', 'F']);
    expect(config.selected, <String>{'F'});
    expect(config.toMap()['metricSchemaVersion'], FloatingMetric.schemaVersion);
    final current = FloatingConfig.fromJson(config.toJson());
    expect(current.order, config.order);
    expect(current.selected, config.selected);
  });

  test('Floating Monitor state presentation keeps Adaptive and Peltier independent from Fan', () {
    const telemetry = FloatingTelemetry(
      fanOn: false,
      speed: 70,
      adaptiveOn: true,
      peltierOn: true,
      connected: true,
    );
    expect(floatingMetricVisible('F', telemetry), isTrue);
    expect(floatingMetricVisible('A', telemetry), isTrue);
    expect(floatingMetricVisible('P', telemetry), isTrue);
    expect(floatingMetricStatus('A', telemetry, AppLanguage.english), 'ON');
    expect(floatingMetricStatus('P', telemetry, AppLanguage.english), 'ON');
    expect(floatingMetricStatus('A', telemetry, AppLanguage.indonesia), 'HIDUP');
    expect(floatingMetricStatus('P', telemetry, AppLanguage.indonesia), 'HIDUP');
    expect(floatingMetricStatus('F', telemetry, AppLanguage.english), 'OFF');
    expect(floatingMetricStatus('F', telemetry, AppLanguage.indonesia), 'MATI');
  });

  test('Floating Monitor settings keeps overlay controls and removes FPS and Shizuku UI', () {
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final native = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt').readAsStringSync();

    expect(floating, isNot(contains('Widget _livePreview(')));
    expect(floating, isNot(contains('_livePreview(telemetry)')));
    expect(floating, contains("JexText.of('orientation', lang)"));
    expect(floating, contains('SegmentedButton<bool>('));
    expect(floating, isNot(contains('Shizuku')));
    expect(floating, isNot(contains('fpsAccessStatus')));
    expect(floating, contains("case 'F':\n        return JexText.of('speed', lang);"));
    expect(native, contains('"F" -> "F:" + if (!data.connected) "--" else if (data.fanOn) data.speed.toString() else offText'));
    expect(native, isNot(contains('SurfaceFlinger')));
  });

  test('Floating Monitor replays telemetry after service startup and resizes for live values', () {
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final nativeService = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt').readAsStringSync();

    expect(floating, contains('await FloatingBridge.updateData(floatingTelemetryNotifier.value)'));
    expect(nativeService, contains('data.connected = obj.optBoolean("connected", false)'));
    expect(nativeService, contains('hudView?.requestLayout()'));
    expect(nativeService, contains('A" -> "A:" + if (!data.connected) "--"'));
    expect(nativeService, contains('P" -> "P:" + if (!data.connected) "--"'));
    expect(nativeService, contains('F" -> "F:" + if (!data.connected) "--"'));
  });

  test('OTA result notifications accept one-shot success/failure/up-to-date events', () {
    expect(isTransientOtaResultEvent('OTA_SUCCESS|MODE=ONLINE|STAGE=ONLINE_FLASH_SUCCESS|VERSION=V2.5|PROGRESS=100'), isTrue);
    expect(isTransientOtaResultEvent('OTA_FAILED|MODE=LOCAL|STAGE=LOCAL_IMAGE_VERIFY|CODE=5|ERROR=UPDATE_FAILED|PROGRESS=100'), isTrue);
    expect(isTransientOtaResultEvent('OTA_UP_TO_DATE|MODE=ONLINE|STAGE=ONLINE_UP_TO_DATE|VERSION=V2.5|PROGRESS=100'), isTrue);
    expect(isTransientOtaResultEvent('NONE'), isFalse);
    expect(isTransientOtaResultEvent('IN_PROGRESS|MODE=ONLINE|STAGE=ONLINE_WIFI_CONNECT|PROGRESS=0'), isFalse);
  });

  test('Live cooling telemetry clears stale command errors only in a healthy state', () {
    expect(
      shouldClearStaleNotifyError(
        connected: true,
        safety: 'OK',
        safetyReason: 'NONE',
        liveTelemetryReceived: true,
        notice: 'Fan command failed.',
      ),
      isTrue,
    );
    expect(
      shouldClearStaleNotifyError(
        connected: true,
        safety: 'LOCKED',
        safetyReason: 'HOTSIDE_PROTECTION',
        liveTelemetryReceived: true,
        notice: 'Fan command failed.',
      ),
      isFalse,
    );
    expect(
      shouldClearStaleNotifyError(
        connected: true,
        safety: 'OK',
        safetyReason: 'NONE',
        liveTelemetryReceived: true,
        notice: 'Firmware update failed.',
      ),
      isFalse,
    );
    expect(
      shouldClearStaleNotifyError(
        connected: true,
        safety: 'OK',
        safetyReason: 'NONE',
        liveTelemetryReceived: false,
        notice: 'Fan command failed.',
      ),
      isFalse,
    );
  });

  test('Voltage uses the same leading slot and shared toggle geometry as control rows', () {
    expect(jexSubmenuRowMinHeight, 62.0);
    expect(jexSubmenuToggleWidth, 54.0);
    expect(jexSubmenuToggleHeight, 32.0);
  });

  test('Submenu geometry is shared between Voltage and control toggles', () {
    expect(jexSubmenuRowMinHeight, 62.0);
    expect(jexSubmenuToggleWidth, 54.0);
    expect(jexSubmenuToggleHeight, 32.0);
  });

  test('Manual voltage toggles stay theme-colored while labels keep voltage accents', () {
    final source = File('lib/main.dart').readAsStringSync();
    final choiceStart = source.indexOf('Widget _voltageChoiceCustom(');
    final choiceEnd = source.indexOf('// AI-METHOD / CONTROL-TAB CONTRACT', choiceStart);
    expect(choiceStart, isNonNegative);
    expect(choiceEnd, greaterThan(choiceStart));
    final choice = source.substring(choiceStart, choiceEnd);
    expect(choice, contains('color: jexVoltageIndicatorColor(target)'));
    expect(choice, contains('accent: scheme.primary,'));
    expect(choice, contains('showCheck: false,'));
    expect(choice, isNot(contains('accent: accent,')));

    final toggleStart = source.indexOf('Widget _jexToggle(');
    final toggleEnd = source.indexOf('Widget _smoothList(', toggleStart);
    final toggle = source.substring(toggleStart, toggleEnd);
    expect(toggle, contains('bool showCheck = true'));
    expect(toggle, contains('displayedValue && showCheck'));
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
    expect(isDifferentFirmwareVersion('V1.8', 'V1.7'), isTrue);
    expect(isDifferentFirmwareVersion('V1.7', 'V1.8'), isTrue);
    expect(isDifferentFirmwareVersion('V1.8', 'V1.8'), isFalse);
  });

  test('JE X FYZ indicator animation policy follows connection and output state', () {
    expect(
      jexIndicatorAnimationActive(connected: false, stateActive: true),
      isFalse,
    );
    expect(
      jexIndicatorAnimationActive(connected: true, stateActive: false),
      isFalse,
    );
    expect(
      jexIndicatorAnimationActive(connected: true, stateActive: true),
      isTrue,
    );

    for (final kind in [
      JexAnimatedIconKind.battery,
      JexAnimatedIconKind.hotside,
      JexAnimatedIconKind.voltage,
    ]) {
      expect(
        jexIconAnimationPermitted(connected: true, kind: kind, stateActive: false),
        isTrue,
        reason: '$kind is a continuous telemetry indicator while connected.',
      );
      expect(
        jexIconAnimationPermitted(connected: false, kind: kind, stateActive: true),
        isFalse,
        reason: '$kind must stop immediately when Bluetooth disconnects.',
      );
    }

    for (final kind in [
      JexAnimatedIconKind.adaptive,
      JexAnimatedIconKind.peltier,
      JexAnimatedIconKind.fan,
      JexAnimatedIconKind.led,
    ]) {
      expect(
        jexIconAnimationPermitted(connected: true, kind: kind, stateActive: false),
        isFalse,
        reason: '$kind must be static while OFF.',
      );
      expect(
        jexIconAnimationPermitted(connected: true, kind: kind, stateActive: true),
        isTrue,
      );
      expect(
        jexIconAnimationPermitted(connected: false, kind: kind, stateActive: true),
        isFalse,
      );
    }
    expect(
      jexIconAnimationPermitted(
        connected: true,
        kind: JexAnimatedIconKind.speed,
        stateActive: true,
      ),
      isFalse,
      reason: 'Fan Speed interpolates PWM updates without a decorative phase loop.',
    );
    expect(
      jexIconAnimationPermitted(
        connected: true,
        kind: JexAnimatedIconKind.bluetooth,
        stateActive: true,
      ),
      isFalse,
      reason: 'Bluetooth connection state is indicated by colour, not motion.',
    );
    expect(
      jexIconAnimationPermitted(
        connected: true,
        kind: JexAnimatedIconKind.generic,
        stateActive: true,
      ),
      isFalse,
    );

    expect(
      jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 5),
      const Duration(milliseconds: 2600),
    );
    expect(
      jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 9),
      const Duration(milliseconds: 1250),
    );
    expect(
      jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 12),
      const Duration(milliseconds: 620),
    );
    expect(
      jexIconAnimationDuration(
        JexAnimatedIconKind.fan,
        voltageLevel: 12,
        fanSpeedLevel: .5,
      ),
      const Duration(milliseconds: 1240),
    );
    expect(
      jexIconAnimationDuration(JexAnimatedIconKind.adaptive),
      const Duration(milliseconds: 4600),
    );
  });

  test('Fan and Peltier indicator effects follow authoritative voltage classes', () {
    expect(jexVoltageAnimationLevel('5V'), 5);
    expect(jexVoltageAnimationLevel('9V'), 9);
    expect(jexVoltageAnimationLevel('12V'), 12);
    expect(jexVoltageAnimationLevel('--'), 5);

    expect(jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 5).inMilliseconds,
        greaterThan(jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 9).inMilliseconds));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 9).inMilliseconds,
        greaterThan(jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 12).inMilliseconds));

    expect(jexVoltageEnergyLevel('5V'), .25);
    expect(jexVoltageEnergyLevel('9V'), .50);
    expect(jexVoltageEnergyLevel('12V'), 1.0);

    expect(jexPeltierFrostIntensity(5), .25);
    expect(jexPeltierFrostIntensity(9), .50);
    expect(jexPeltierFrostIntensity(12), 1.0);
    expect(jexPeltierFrostParticleCount(5), 3);
    expect(jexPeltierFrostParticleCount(9), 6);
    expect(jexPeltierFrostParticleCount(12), 14);
  });

  test('Fan Speed level retargeting eases between values without abrupt jumps', () {
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: 0), closeTo(.2, 1e-9));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: .5), closeTo(.5, 1e-9));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: 1), closeTo(.8, 1e-9));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: .25), lessThan(.35));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: .75), greaterThan(.65));
  });

  test('Fan Speed needle has no autonomous wobble and follows retargeted PWM', () {
    final source = File('lib/main.dart').readAsStringSync();
    final painterStart = source.indexOf('class _JexIconPainter extends CustomPainter {');
    final painterEnd = source.indexOf('const MethodChannel securityChannel', painterStart);
    final painter = source.substring(painterStart, painterEnd);
    final speedStart = painter.indexOf('case JexAnimatedIconKind.speed:');
    final speedEnd = painter.indexOf('case JexAnimatedIconKind.led:', speedStart);
    final speed = painter.substring(speedStart, speedEnd);

    expect(speed, contains('final needleAngle = start + sweep * safeLevel;'));
    expect(speed, isNot(contains('jexFanSpeedNeedleWobble')));
    expect(speed, isNot(contains('glintStart')));
    expect(speed, isNot(contains('canvas.drawArc(gauge, glintStart')));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: .5), closeTo(.5, 1e-9));
  });

  test('LED palette exposes current RGB colors', () {
    expect(ledColorPalette, hasLength(36));
    expect(ledColorPalette.first, '#FF1744');
    expect(ledColorPalette.last, '#FFFFFF');
    expect(ledColorPalette, contains('#FFFFFF'));
    expect(ledColorPalette, isNot(contains('#000000')));
    for (final hex in ledColorPalette) {
      expect(RegExp(r'^#[0-9A-F]{6}$').hasMatch(hex), isTrue);
      expect(ledPaletteColor(hex), isA<Color>());
    }
  });
  test('LED modes preserve firmware IDs while Mirror Pulse is retired', () {
    expect(supportedLedModeIds, [1, 2, 4, 5, 6, 7]);
    expect(isSupportedLedModeId(1), isTrue);
    expect(isSupportedLedModeId(3), isFalse);
    expect(ledModeDisplayIndex(4), 2);
    expect(ledModeDisplayIndex(7), 5);
    expect(ledFirmwareModeForDisplayIndex(2), 4);
    expect(ledFirmwareModeForDisplayIndex(5), 7);
  });

  test('LED sync snapshot parses mode, phase and cycle atomically', () {
    final parsed = LedSyncSnapshot.parse('4,1601,1600');
    expect(parsed, isNotNull);
    expect(parsed!.mode, 4);
    expect(parsed.phaseMs, 1);
    expect(parsed.cycleMs, 1600);
    expect(LedSyncSnapshot.parse('4,20'), isNull);
    expect(LedSyncSnapshot.parse('3,0,2400')?.mode, 3);
    expect(LedSyncSnapshot.parse('8,0,1000'), isNull);
  });

  test('LED preview stays vivid independently of hardware Brightness', () {
    final red = ledPreviewColors(mode: 1, phaseMs: 0, baseColor: '#FF1744').first;
    expect(red.red, 255);
    expect(red.green, 23);
    expect(red.blue, 68);
    expect(ledPreviewPixelOpacity(mode: 1, level: 1, active: true), 1.0);
    expect(ledPreviewPixelOpacity(mode: 1, level: 0, active: true), 1.0);
    expect(ledPreviewPixelOpacity(mode: 7, level: .2, active: true), 1.0);
  });

  test('Patterned LED preview uses a pale baseline for truly inactive pixels', () {
    final red = ledPaletteColor('#FF1744');
    final inactiveComet = ledPreviewPixelColor(
      mode: 4,
      level: 0,
      animatedColor: red,
      active: true,
      darkTheme: true,
    );
    final activeComet = ledPreviewPixelColor(
      mode: 4,
      level: 1,
      animatedColor: red,
      active: true,
      darkTheme: true,
    );
    final poweredOff = ledPreviewPixelColor(
      mode: 1,
      level: 1,
      animatedColor: red,
      active: false,
      darkTheme: true,
    );

    expect(inactiveComet, const Color(0xFFCDD4DF));
    expect(activeComet, red);
    expect(poweredOff, const Color(0xFFCDD4DF));
    expect(ledPreviewPixelOpacity(mode: 4, level: 0, active: true), 1.0);
  });

  test('Display menus anchor to the display area on normal and short screens', () {
    expect(displayMenuOverlayTop(screenWidth: 360, availableHeight: 900), 492.0);
    expect(displayMenuOverlayTop(screenWidth: 360, availableHeight: 400), 256.0);
  });

  test('Dashboard indicators use distinct, slower motion cycles', () {
    expect(jexIconAnimationDuration(JexAnimatedIconKind.battery), const Duration(milliseconds: 4200));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.hotside), const Duration(milliseconds: 4400));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.voltage), const Duration(milliseconds: 3000));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.adaptive), const Duration(milliseconds: 6400));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.peltier), const Duration(milliseconds: 5200));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 5), const Duration(milliseconds: 2600));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 9), const Duration(milliseconds: 1250));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.fan, voltageLevel: 12), const Duration(milliseconds: 620));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.speed), const Duration(milliseconds: 1800));
  });

  test('LED color palette has 36 hue-ordered presets with localized names', () {
    expect(ledColorPalette, hasLength(36));
    expect(ledColorDisplayName('#FF1744', AppLanguage.english), 'Candy Red');
    expect(ledColorDisplayName('#FF1744', AppLanguage.indonesia), 'Merah Permen');
    expect(ledColorDisplayName('#A85D32', AppLanguage.indonesia), 'Cokelat');
    expect(ledColorDisplayName('#FFFFFF', AppLanguage.english), 'White');
    expect(ledColorDisplayName('#FF0000', AppLanguage.english), 'Red');
    expect(ledColorDisplayName('#00FFFF', AppLanguage.english), 'Cyan');
    expect(ledColorDisplayName('#FFB6C1', AppLanguage.english), 'Pink');
    expect(ledColorDisplayName('#ABCDEF', AppLanguage.english), 'Custom Color');
    expect(JexText.of('select', AppLanguage.english), 'Select');
    expect(JexText.of('select', AppLanguage.indonesia), 'Pilih');
    expect(ledColorPalette, isNot(contains('#000000')));
  });

  test('LED UI keeps its own color menu anchored to the display region', () {
    final source = File('lib/main.dart').readAsStringSync();
    expect(source, contains('widget.modeName.toUpperCase()'));
    expect(source, isNot(contains('widget.modeNumber')));
    expect(source, contains('ledColorDisplayName(rgbColor, lang)'));
    expect(source, contains("stateKnown ? JexText.of(value ? 'on' : 'off', lang) : JexText.of('off', lang)"));
    expect(source, contains('final displayedValue = stateKnown && value;'));
    final colorDialogStart = source.indexOf('Future<void> _showLedColorPicker() async {');
    final colorDialogEnd = source.indexOf('// AI-METHOD: _openFirmwareSettings', colorDialogStart);
    expect(colorDialogStart, isNonNegative);
    expect(colorDialogEnd, greaterThan(colorDialogStart));
    final colorDialog = source.substring(colorDialogStart, colorDialogEnd);
    expect(colorDialog, contains('Alignment.bottomCenter'));
    expect(colorDialog, isNot(contains('displayMenuOverlayTop(')));
    expect(colorDialog, isNot(contains('SingleChildScrollView')));
    expect(colorDialog, contains('onCancel:'));
    expect(colorDialog, contains('barrierDismissible: false'));
    expect(colorDialog, contains('PopScope<void>(\n          canPop: false'));
    expect(colorDialog, contains('onSelect: _setRgbColor'));
    final colorCardStart = source.indexOf('class _JexColorPickerCard');
    final colorCardEnd = source.indexOf('enum JexAnimatedIconKind', colorCardStart);
    expect(colorCardStart, isNonNegative);
    expect(colorCardEnd, greaterThan(colorCardStart));
    final colorCard = source.substring(colorCardStart, colorCardEnd);
    expect(colorCard, contains('fontSize: 22'));
    expect(colorCard, contains('fontSize: 15'));
    expect(colorCard, contains('mainAxisExtent: 42'));
    expect(colorCard, contains('alignment: Alignment.centerRight'));
    expect(colorCard, contains("JexText.of('select', lang)"));
    expect(colorCard, contains('onPressed: _isApplying ? null : _applySelection'));
    expect(colorCard, contains('setState(() => _draftSelected = value)'));
    expect(colorCard, contains('final applied = await widget.onSelect(_draftSelected);'));
    expect(colorCard, contains('if (applied && mounted) Navigator.of(context).pop()'));
    expect(colorCard, isNot(contains('onTap: () => widget.onSelect(')));
    expect(source, contains("JexText.of('cancel', lang)"));
    expect(source, contains('Future<bool> _setRgbColor(String hex) async'));
    expect(source, contains('colors: ledColorPresets'));
    expect(source, contains('constraints: const BoxConstraints(maxWidth: 420)'));
    expect(source, contains('showGeneralDialog<void>'));
  });

  test('LED preview exposes the physical 4-left/4-right pixel map', () {
    final staticLevels = ledPreviewLevels(mode: 1, phaseMs: 0);
    final retiredModeFallsBackToStatic = ledPreviewLevels(mode: 3, phaseMs: 0);
    final cometHead = ledPreviewLevels(mode: 4, phaseMs: 0);
    final dualChase = ledPreviewLevels(mode: 5, phaseMs: 0);
    final colors = ledPreviewColors(
      mode: 1,
      phaseMs: 0,
      baseColor: '#FFFFFF',
    );

    expect(staticLevels, hasLength(8));
    expect(staticLevels, everyElement(1.0));
    expect(retiredModeFallsBackToStatic, everyElement(1.0));
    expect(cometHead[0], 1.0);
    expect(cometHead[7], greaterThan(0.0));
    expect(cometHead[6], greaterThan(0.0));
    expect(dualChase[0], 1.0);
    expect(dualChase[7], 1.0);

    expect(colors, hasLength(8));
    expect(colors.first.red, 255);
    expect(colors.first.green, 255);
    expect(colors.first.blue, 255);
  });

  test('Voltage and Bluetooth indicators avoid stacked sweeps and ripple rings', () {
    final source = File('lib/main.dart').readAsStringSync();
    final painterStart = source.indexOf('class _JexIconPainter extends CustomPainter {');
    final painterEnd = source.indexOf('const MethodChannel securityChannel', painterStart);
    expect(painterStart, isNonNegative);
    expect(painterEnd, greaterThan(painterStart));
    final painter = source.substring(painterStart, painterEnd);
    final voltageStart = painter.indexOf('case JexAnimatedIconKind.voltage:');
    final voltageEnd = painter.indexOf('case JexAnimatedIconKind.adaptive:', voltageStart);
    final bluetoothStart = painter.indexOf('case JexAnimatedIconKind.bluetooth:');
    final bluetoothEnd = painter.indexOf('case JexAnimatedIconKind.generic:', bluetoothStart);
    expect(voltageStart, isNonNegative);
    expect(voltageEnd, greaterThan(voltageStart));
    expect(bluetoothStart, isNonNegative);
    expect(bluetoothEnd, greaterThan(bluetoothStart));
    final voltage = painter.substring(voltageStart, voltageEnd);
    final bluetooth = painter.substring(bluetoothStart, bluetoothEnd);
    expect(voltage, contains('final bolt = _bolt(s);'));
    expect(voltage, isNot(contains('sheen')));
    expect(voltage, isNot(contains('spark')));
    expect(bluetooth, contains('final glyph = Path()'));
    expect(bluetooth, contains('canvas.drawPath(glyph'));
    expect(bluetooth, isNot(contains('drawArc')));
    expect(bluetooth, isNot(contains('drawCircle')));
  });

  test('LED preview timing matches the firmware animation cycles', () {
    expect(ledAnimationCycleMs(1), 1000);
    expect(ledAnimationCycleMs(2), 2200);
    expect(ledAnimationCycleMs(3), 1000);
    expect(ledAnimationCycleMs(4), 1600);
    expect(ledAnimationCycleMs(5), 900);
    expect(ledAnimationCycleMs(6), 1800);
    expect(ledAnimationCycleMs(7), 30000);

    final yellow = ledPreviewColors(
      mode: 7,
      phaseMs: 5000,
      baseColor: '#FFFFFF',
    ).first;
    expect(yellow.red, greaterThan(240));
    expect(yellow.green, greaterThan(240));
    expect(yellow.blue, lessThan(20));
  });

  test('LED localization matches the six supported modes', () {
    expect(JexText.of('ledModeStatic', AppLanguage.english), 'Static');
    expect(JexText.of('ledModeBreath', AppLanguage.english), 'Breath');
    expect(JexText.of('ledModeComet', AppLanguage.english), 'Comet');
    expect(JexText.of('ledModeDualChase', AppLanguage.english), 'Dual Chase');
    expect(JexText.of('leftRight', AppLanguage.english), 'Left / Right');
    expect(JexText.of('leftRight', AppLanguage.indonesia), 'Kiri / Kanan');
    expect(JexText.of('ledModeRainbow', AppLanguage.english), 'Rainbow');
    expect(JexText.of('ledModeUnsupported', AppLanguage.english), 'Unsupported');
    expect(JexText.of('ledModeUnsupported', AppLanguage.indonesia), 'Tidak didukung');
    expect(JexText.of('ledModeComet', AppLanguage.indonesia), 'Komet');
  });

  test('Fan rotor keeps one integrated silhouette and smooth phase-controlled motion', () {
    final source = File('lib/main.dart').readAsStringSync();
    final painterStart = source.indexOf('class _JexIconPainter extends CustomPainter {');
    final painterEnd = source.indexOf('const MethodChannel securityChannel', painterStart);
    final stateStart = source.indexOf('class _JexAnimatedIconState');
    final stateEnd = source.indexOf('class _JexIconPainter', stateStart);
    expect(painterStart, isNonNegative);
    expect(painterEnd, greaterThan(painterStart));
    final painter = source.substring(painterStart, painterEnd);
    final state = source.substring(stateStart, stateEnd);
    expect(painter, contains('final rotor = _fanSilhouette(s, angle);'));
    expect(painter, contains('canvas.drawPath(rotor, _fill('));
    expect(painter, isNot(contains('_drawFanBlade')));
    expect(state, contains('_animateFanToCycleBoundary();'));
    expect(state, contains('unawaited(_coastFanToStop());'));
  });

  test('Fan voltage change preserves phase and OFF coasts smoothly to a stop', () {
    final source = File('lib/main.dart').readAsStringSync();
    final stateStart = source.indexOf('class _JexAnimatedIconState');
    final stateEnd = source.indexOf('class _JexIconPainter', stateStart);
    expect(stateStart, isNonNegative);
    expect(stateEnd, greaterThan(stateStart));
    final iconState = source.substring(stateStart, stateEnd);
    expect(iconState, contains('else if ((fanVoltageChanged || fanSpeedChanged) && widget.active)'));
    expect(iconState, contains('_animateFanToCycleBoundary();'));
    expect(iconState, contains('await controller.animateTo('));
    expect(iconState, contains('controller.repeat();'));
    expect(iconState, contains('unawaited(_coastFanToStop());'));
    expect(iconState, contains('const coastCycles = .16;'));
    expect(iconState, contains('Curves.easeOutCubic'));
    expect(iconState, isNot(contains('coastDelta')));
    expect(iconState, contains('frostTransitionController.forward(from: 0)'));
    expect(iconState, isNot(contains('_frostFromVisibility')));
    expect(iconState, contains('if (widget.active)'));
  });

  test('Indicator animations stop on disconnect and OFF glyphs stay fully coloured', () {
    final source = File('lib/main.dart').readAsStringSync();
    final stateStart = source.indexOf('class _JexAnimatedIconState');
    final stateEnd = source.indexOf('class _JexIconPainter', stateStart);
    final painterStart = source.indexOf('class _JexIconPainter extends CustomPainter {');
    final painterEnd = source.indexOf('const MethodChannel securityChannel', painterStart);
    expect(stateStart, isNonNegative);
    expect(stateEnd, greaterThan(stateStart));
    expect(painterStart, isNonNegative);
    expect(painterEnd, greaterThan(painterStart));

    final state = source.substring(stateStart, stateEnd);
    final painter = source.substring(painterStart, painterEnd);
    expect(state, contains('void _stopAnimationsForDisconnect()'));
    expect(state, contains('frostTransitionController.stop();'));
    expect(state, contains('speedLevelTransitionController.stop();'));
    expect(state, contains('jexIconAnimationPermitted('));
    expect(state, contains('if (!widget.connected)'));
    expect(state, contains('_fanCoasting'));
    expect(state, contains('_resumeCycleWithoutPhaseSnap();'));
    expect(state, contains('Future<void> _finishIconCycleBoundary(int durationMs) async'));
    expect(state, contains('curve: Curves.linear'));
    expect(state, isNot(contains('widget.kind != JexAnimatedIconKind.fan && !controller.isAnimating')));

    expect(painter, contains('const opacity = 1.0;'));
    expect(painter, contains('final breath = active ? 1.0 + .014 * pulse * strength : 1.0;'));
    expect(painter, isNot(contains('final idleBreath')));
    expect(painter, contains('_drawThermalFlames'));
    expect(painter, contains('_drawFrostParticles'));
    expect(painter, contains('_drawFanAirflow'));
    expect(painter, contains('const tickCount = 9'));
    expect(painter, contains('_drawAdaptiveArrowHead'));

    final bluetoothStart = painter.indexOf('case JexAnimatedIconKind.bluetooth:');
    final bluetoothEnd = painter.indexOf('case JexAnimatedIconKind.generic:', bluetoothStart);
    final bluetooth = painter.substring(bluetoothStart, bluetoothEnd);
    expect(bluetooth, contains('canvas.drawPath(glyph'));
    expect(bluetooth, isNot(contains('drawCircle')));
    expect(bluetooth, isNot(contains('drawArc')));
  });

  test('Fan Speed gauge retargets smoothly and fades its motion on state changes', () {
    final source = File('lib/main.dart').readAsStringSync();
    final stateStart = source.indexOf('class _JexAnimatedIconState');
    final stateEnd = source.indexOf('class _JexIconPainter', stateStart);
    final speedStart = source.indexOf('case JexAnimatedIconKind.speed:');
    final speedEnd = source.indexOf('case JexAnimatedIconKind.led:', speedStart);
    expect(stateStart, isNonNegative);
    expect(stateEnd, greaterThan(stateStart));
    expect(speedStart, isNonNegative);
    expect(speedEnd, greaterThan(speedStart));
    final iconState = source.substring(stateStart, stateEnd);
    final speed = source.substring(speedStart, speedEnd);
    expect(iconState, contains('late final AnimationController speedLevelTransitionController;'));
    expect(iconState, contains('final current = _currentSpeedLevel();'));
    expect(iconState, contains('speedLevelTransitionController.forward(from: 0)'));
    expect(iconState, contains('Duration(milliseconds: 420)'));
    expect(iconState, contains('Duration(milliseconds: 520)'));
    expect(speed, contains('final needleAngle = start + sweep * safeLevel;'));
    expect(speed, isNot(contains('glintStart')));
    expect(speed, isNot(contains('jexFanSpeedNeedleWobble')));
    expect(speed, contains('final needle = Path()..moveTo(cx, cy)..lineTo(tip.dx, tip.dy);'));
    expect(speed, contains('const tickCount = 9'));
    expect(speed, contains('if (active && safeLevel > 0)'));
    expect(speed, contains('mainColor.withValues(alpha: .92)'));
  });

  test('Integrated indicator animation preserves seamless phase transitions', () {
    final source = File('lib/main.dart').readAsStringSync();
    final stateStart = source.indexOf('class _JexAnimatedIconState');
    final stateEnd = source.indexOf('class _JexIconPainter', stateStart);
    expect(stateStart, isNonNegative);
    expect(stateEnd, greaterThan(stateStart));
    final state = source.substring(stateStart, stateEnd);
    expect(state, contains('unawaited(_animateActivityTransition(true));'));
    expect(state, contains('late final AnimationController activityTransitionController;'));
    expect(state, contains('late final AnimationController speedLevelTransitionController;'));
    expect(state, contains('Duration(milliseconds: active ? 360 : 440)'));
    expect(state, contains('Curves.easeInOutCubic'));
    expect(state, contains('unawaited(_coastFanToStop());'));
  });

  test('Peltier Safety dialog uses readable text and comfortable touch targets', () {
    final source = File('lib/main.dart').readAsStringSync();
    final dialogStart = source.indexOf('showGeneralDialog<bool>');
    final dialogEnd = source.indexOf('if (approved != true) return;', dialogStart);
    expect(dialogStart, isNonNegative);
    expect(dialogEnd, greaterThan(dialogStart));
    final dialog = source.substring(dialogStart, dialogEnd);
    expect(dialog, contains('fontSize: 24'));
    expect(dialog, contains('fontSize: 17'));
    expect(dialog, contains('minimumSize: const Size(86, 48)'));
    expect(dialog, contains('minimumSize: const Size(142, 50)'));
  });

  test('Android notifications use JE X FYZ branding and meaningful foreground text', () {
    final activity = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt').readAsStringSync();
    final appSource = File('lib/main.dart').readAsStringSync();
    final bleService = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt').readAsStringSync();
    final floatingService = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt').readAsStringSync();
    final helper = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt').readAsStringSync();
    final icon = File('android/app/src/main/res/drawable/ic_notification.xml').readAsStringSync();

    expect(activity, contains('setJexNotificationBranding(this)'));
    expect(activity, contains('jexNotificationContentIntent(this, id)'));
    expect(activity, contains('requestNotificationPermission()'));
    expect(helper, contains('setSmallIcon(R.drawable.ic_notification)'));
    expect(helper, isNot(contains('R.drawable.jexfyzicon')));
    expect(helper, isNot(contains('setLargeIcon')));
    expect(icon, contains('Bold JE monogram'));
    expect(icon, contains('android:pathData='));
    expect(icon, contains('M2,3 H10'));
    expect(icon, isNot(contains('Legacy monochrome X resource retained')));
    expect(bleService, contains('Bluetooth connected · cooler session active'));
    expect(bleService, contains('Bluetooth terhubung · sesi cooler aktif'));
    expect(floatingService, contains('Floating Monitor active'));
    expect(floatingService, contains('Monitor Melayang aktif'));
    expect(icon, contains('android:fillColor="#FFFFFFFF"'));
    expect(appSource, contains("JexText.of('bluetoothDisconnected', appLanguageNotifier.value)"));
  });

  test('Light and Dark themes use inverse semantic text contrast', () {
    final light = buildJexTheme(AppThemePreset.light);
    final dark = buildJexTheme(AppThemePreset.dark);

    expect(light.brightness, Brightness.light);
    expect(light.scaffoldBackgroundColor, const Color(0xFFEEF0F4));
    expect(light.colorScheme.surface, Colors.white);
    expect(light.colorScheme.onSurface, const Color(0xFF111318));
    expect(light.colorScheme.onSurfaceVariant, const Color(0xFF3F444D));
    expect(light.colorScheme.surfaceContainerHighest, const Color(0xFFE4E7EC));

    expect(dark.brightness, Brightness.dark);
    expect(dark.colorScheme.onSurface, const Color(0xFFF4F6FA));
    expect(dark.colorScheme.onSurfaceVariant, const Color(0xFF979DA8));
  });

  test('Default JE X FYZ theme is dark outside dashboard', () {
    final theme = buildJexTheme(AppThemePreset.defaultTheme);
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, const Color(0xFF0F1013));
  });

  test('Localized Notify error detection is language-aware', () {
    expect(isNotifyErrorMessage('Voltage change failed.'), isTrue);
    expect(isNotifyErrorMessage('Perubahan tegangan gagal.'), isTrue);
    expect(isNotifyErrorMessage('System ready.'), isFalse);
    expect(isNotifyErrorMessage('Sistem siap.'), isFalse);
  });

  test('Reset reason POWER_ON is not shown as a user-facing reset event', () {
    expect(isUserVisibleResetReason('POWER_ON'), isFalse);
    expect(isUserVisibleResetReason('POWERON'), isFalse);
    expect(isUserVisibleResetReason('BROWNOUT'), isTrue);
  });

  test('Reset reason sentinel is not a user-facing event', () {
    expect(isUserVisibleResetReason('UNAVAILABLE_CORE_3_3_7'), isFalse);
    expect(isUserVisibleResetReason('POWERON'), isFalse);
    expect(isUserVisibleResetReason('UNKNOWN'), isFalse);
    expect(isUserVisibleResetReason('BROWNOUT'), isTrue);
  });

  test('Light Theme Home metric value role uses dark semantic accent', () {
    const semantic = Color(0xFF4DE7B7);
    final safe = lightThemeAccentText(semantic);
    expect(safe, isNot(semantic));
    expect(safe.computeLuminance(), lessThan(semantic.computeLuminance()));
    expect(safe.red, greaterThanOrEqualTo(0));
    expect(safe.green, greaterThanOrEqualTo(0));
    expect(safe.blue, greaterThanOrEqualTo(0));
  });

  test('Light Theme semantic accent text reduces luminance for bright surfaces', () {
    const cyan = Color(0xFF4DE7B7);
    final textColor = lightThemeAccentText(cyan);
    expect(textColor.computeLuminance(), lessThan(cyan.computeLuminance()));
  });

  test('Light theme keeps accent roles visually available for colorful metric cards', () {
    final light = buildJexTheme(AppThemePreset.light);
    expect(light.colorScheme.primary.computeLuminance(), greaterThan(0.20));
    expect(light.colorScheme.onSurface.computeLuminance(), lessThan(0.05));
    expect(light.colorScheme.outlineVariant, isNot(light.colorScheme.surface));
  });

  test('Light theme keeps neutral surfaces and reserved accent roles', () {
    final light = buildJexTheme(AppThemePreset.light);
    expect(light.colorScheme.surface, isNot(light.colorScheme.primary));
    expect(light.colorScheme.surfaceContainerHighest, isNot(light.colorScheme.primary));
    expect(light.colorScheme.outlineVariant, isNot(light.colorScheme.primary));
    expect(light.colorScheme.onSurface.computeLuminance(), lessThan(0.05));
    expect(light.colorScheme.onSurfaceVariant.computeLuminance(), lessThan(0.10));
  });

  test('Light theme uses dark high-contrast semantic text', () {
    final theme = buildJexTheme(AppThemePreset.light);
    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, const Color(0xFFEEF0F4));
    expect(theme.colorScheme.onSurface, const Color(0xFF111318));
    expect(theme.colorScheme.onSurfaceVariant, const Color(0xFF3F444D));
  });

  test('Auto Connect stays passive until known cooler and Bluetooth are already ready', () {
    expect(
      canAutoConnect(
        autoConnectEnabled: true,
        knownRemoteId: null,
        bluetoothScanGranted: true,
        bluetoothConnectGranted: true,
        bluetoothAdapterOn: true,
        legacyLocationReady: true,
      ),
      isFalse,
    );
    expect(
      canAutoConnect(
        autoConnectEnabled: true,
        knownRemoteId: 'AA:BB:CC:DD:EE:FF',
        bluetoothScanGranted: true,
        bluetoothConnectGranted: true,
        bluetoothAdapterOn: false,
        legacyLocationReady: true,
      ),
      isFalse,
    );
    expect(
      canAutoConnect(
        autoConnectEnabled: true,
        knownRemoteId: 'AA:BB:CC:DD:EE:FF',
        bluetoothScanGranted: true,
        bluetoothConnectGranted: true,
        bluetoothAdapterOn: true,
        legacyLocationReady: true,
      ),
      isTrue,
    );
  });

  test('New default Auto Connect preference is Manual', () {
    expect(const AppSettings().autoConnect, isFalse);
    final parsed = AppSettings.fromJson('{"language":"english"}');
    expect(parsed.autoConnect, isFalse);
  });

  test('Default Settings theme stays dark', () {
    final theme = buildJexTheme(AppThemePreset.defaultTheme);
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, const Color(0xFF0F1013));
  });

}