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
  test('Home icon painter restores Build #54 primitives and interpolates activity', () {
    final source = File('lib/main.dart').readAsStringSync();
    expect(source, contains('void _drawThermalFlames('));
    expect(source, contains('void _drawFanBlade('));
    expect(source, contains('final softPulse = .5 + .5 * math.sin(angle);'));
    expect(source, contains('oldDelegate.activity != activity'));
    expect(source, contains('final strength = activity.clamp(0.0, 1.0).toDouble();'));
    expect(source, isNot(contains('void _drawBlade(')));
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
    expect(JexText.of('hotsideTemperature', AppLanguage.indonesia), 'Suhu Hotside');
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

  test('Home Notify connection status says Connected/Disconnected in both languages', () {
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
    expect(label(connected: true, language: AppLanguage.indonesia), 'CONNECTED');
    expect(label(connected: false, language: AppLanguage.indonesia), 'DISCONNECTED');
    expect(label(connected: false, connecting: true), 'CONNECTING');
    expect(label(connected: false, syncing: true), 'SYNCING');
    expect(label(connected: false, notice: 'Wireless ADB failed'), 'ERROR');
    expect(label(connected: false, notice: 'Bluetooth Disconnected'), 'DISCONNECTED');
    expect(label(connected: true, notice: 'Bluetooth Disconnected'), 'CONNECTED');
  });

  test('Home Fan Speed shows 100% for Adaptive at 12V', () {
    expect(
      homeFanSpeedDisplay(
        connected: true,
        fanOn: true,
        voltage: '12V',
        adaptiveOn: true,
        fanSpeed: 70,
        offLabel: 'OFF',
      ),
      '100%',
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

  test('JE X FYZ custom indicator motion is gated by BLE and state', () {
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

    expect(jexPeltierFrostIntensity(5), lessThan(jexPeltierFrostIntensity(9)));
    expect(jexPeltierFrostIntensity(9), lessThan(jexPeltierFrostIntensity(12)));
    expect(jexPeltierFrostParticleCount(5), 2);
    expect(jexPeltierFrostParticleCount(9), 5);
    expect(jexPeltierFrostParticleCount(12), 8);
  });

  test('Fan Speed level retargeting eases between values without abrupt jumps', () {
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: 0), closeTo(.2, 1e-9));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: .5), closeTo(.5, 1e-9));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: 1), closeTo(.8, 1e-9));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: .25), lessThan(.35));
    expect(jexSmoothFanSpeedLevel(from: .2, to: .8, progress: .75), greaterThan(.65));
  });

  test('Fan Speed needle wobble is periodic at the repeat boundary', () {
    expect(jexFanSpeedNeedleWobble(0), closeTo(0, 1e-9));
    expect(jexFanSpeedNeedleWobble(1), closeTo(0, 1e-9));
    expect(jexFanSpeedNeedleWobble(.25), closeTo(.035, 1e-9));
    expect(jexFanSpeedNeedleWobble(.75), closeTo(-.035, 1e-9));
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
    expect(jexIconAnimationDuration(JexAnimatedIconKind.battery), const Duration(milliseconds: 2600));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.hotside), const Duration(milliseconds: 3200));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.voltage), const Duration(milliseconds: 1900));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.adaptive), const Duration(milliseconds: 4600));
    expect(jexIconAnimationDuration(JexAnimatedIconKind.peltier), const Duration(milliseconds: 3000));
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
    expect(JexText.of('leftRight', AppLanguage.english), 'Left ↔ Right');
    expect(JexText.of('ledModeRainbow', AppLanguage.english), 'Rainbow');
    expect(JexText.of('ledModeUnsupported', AppLanguage.english), 'Unsupported');
    expect(JexText.of('ledModeUnsupported', AppLanguage.indonesia), 'Tidak didukung');
    expect(JexText.of('ledModeComet', AppLanguage.indonesia), 'Komet');
  });

  test('Fan voltage change preserves phase and OFF coasts smoothly to a stop', () {
    final source = File('lib/main.dart').readAsStringSync();
    final stateStart = source.indexOf('class _JexAnimatedIconState');
    final stateEnd = source.indexOf('class _JexIconPainter', stateStart);
    expect(stateStart, isNonNegative);
    expect(stateEnd, greaterThan(stateStart));
    final iconState = source.substring(stateStart, stateEnd);
    expect(iconState, contains('fanVoltageChanged && widget.active'));
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

  test('Indicator motion fades before pausing and resumes at a cycle boundary', () {
    final source = File('lib/main.dart').readAsStringSync();
    final stateStart = source.indexOf('class _JexAnimatedIconState');
    final stateEnd = source.indexOf('class _JexIconPainter', stateStart);
    expect(stateStart, isNonNegative);
    expect(stateEnd, greaterThan(stateStart));
    final state = source.substring(stateStart, stateEnd);
    expect(state, contains('Future<void> _animateActivityTransition(bool active) async'));
    expect(state, contains('if (!active && widget.kind != JexAnimatedIconKind.fan)'));
    expect(state, contains('Future<void> _finishIconCycleBoundary(int durationMs) async'));
    expect(state, contains('curve: Curves.linear'));
    expect(state, contains('_resumeCycleWithoutPhaseSnap();'));
    expect(source, contains('final harmonic = (i + 1).toDouble();'));
    expect(source, isNot(contains('phase * (1.7 + i * .23)')));
  });

  test('Peltier crystal is symmetric and its particles remain in a bounded ring', () {
    final source = File('lib/main.dart').readAsStringSync();
    final peltierStart = source.indexOf('case JexAnimatedIconKind.peltier:');
    final peltierEnd = source.indexOf('case JexAnimatedIconKind.fan:', peltierStart);
    expect(peltierStart, isNonNegative);
    expect(peltierEnd, greaterThan(peltierStart));
    final peltier = source.substring(peltierStart, peltierEnd);
    expect(peltier, isNot(contains('moduleRect')));
    expect(peltier, contains('final spine = Path()'));
    expect(peltier, contains('final branches = Path()'));
    expect(peltier, isNot(contains('canvas.rotate(angle / 6)')));
    expect(peltier, contains('for (var i = 0; i < 6; i++)'));
    expect(peltier, contains('for (var i = 0; i < 4; i++)'));
    expect(peltier, contains('final frostIntensity ='));
    expect(peltier, contains('final particleCountValue = frostParticleCountOverride ??'));
    expect(peltier, contains('final particleAngle = angle + math.pi / 4 + i * math.pi / 2;'));
    expect(peltier, contains('final radius = s * (.405 + .012 * math.sin(particlePhase));'));
    expect(peltier, contains('final particleOpacity ='));
    expect(peltier, contains('(.20 + .80 * strength'));
    expect(peltier, isNot(contains('final petal = Path()')));
  });

  test('Fan animation uses compact blades and the same soft activity transition as other indicators', () {
    final source = File('lib/main.dart').readAsStringSync();
    final bladeStart = source.indexOf('void _drawFanBlade(');
    final bladeEnd = source.indexOf('void paint(Canvas canvas, Size size)', bladeStart);
    final fanStart = source.indexOf('case JexAnimatedIconKind.fan:');
    final fanEnd = source.indexOf('case JexAnimatedIconKind.speed:', fanStart);
    expect(bladeStart, isNonNegative);
    expect(bladeEnd, greaterThan(bladeStart));
    expect(fanStart, isNonNegative);
    expect(fanEnd, greaterThan(fanStart));
    final blades = source.substring(bladeStart, bladeEnd);
    final fan = source.substring(fanStart, fanEnd);
    expect(blades, contains('alpha: .94'));
    expect(blades, contains('canvas.rotate(angle)'));
    expect(blades, contains('s * .445'));
    expect(fan, contains('_drawFanBlade(canvas, size, rotation + i * math.pi * 2 / 3)'));
    expect(fan, contains('canvas.drawCircle(hub, s * .079, fill(color.withValues(alpha: 1)))'));
    expect(source, contains('activityTransitionController.animateTo('));
    expect(source, contains('curve: Curves.easeInOutCubic'));
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
    expect(iconState, contains('late final AnimationController activityTransitionController;'));
    expect(iconState, contains('final current = _currentSpeedLevel();'));
    expect(iconState, contains('speedLevelTransitionController.forward(from: 0)'));
    expect(iconState, contains('Duration(milliseconds: 420)'));
    expect(iconState, contains('Duration(milliseconds: 520)'));
    expect(speed, contains('jexFanSpeedNeedleWobble(progress)'));
    expect(speed, contains('final actual = level.clamp(0.0, 1.0).toDouble();'));
    expect(speed, contains('stroke(s * .060, color.withValues(alpha: .62 + (.96 - .62) * strength))'));
    expect(speed, contains('final needleWobble = jexFanSpeedNeedleWobble(progress) * strength;'));
    expect(source, contains('activityTransitionController.value'));
  });

  test('Voltage sweep stays clipped to its bolt and Bluetooth ripples fade smoothly', () {
    final source = File('lib/main.dart').readAsStringSync();
    final voltageStart = source.indexOf('case JexAnimatedIconKind.voltage:');
    final voltageEnd = source.indexOf('case JexAnimatedIconKind.adaptive:', voltageStart);
    expect(voltageStart, isNonNegative);
    expect(voltageEnd, greaterThan(voltageStart));
    final voltage = source.substring(voltageStart, voltageEnd);
    expect(voltage, contains('canvas.clipPath(bolt)'));
    expect(voltage, contains('final sweepY = s * (.13 + .72 * (.5 - .5 * math.cos(angle)));'));
    expect(voltage, contains('fill(Colors.white.withValues(alpha: (.08 + .24 * voltageEnergy + .04 * pulse) * strength))'));
    expect(voltage, contains('final voltageEnergy = level.clamp(0.0, 1.0).toDouble();'));
    final bluetoothStart = source.indexOf('case JexAnimatedIconKind.bluetooth:');
    final bluetoothEnd = source.indexOf('case JexAnimatedIconKind.generic:', bluetoothStart);
    expect(bluetoothStart, isNonNegative);
    expect(bluetoothEnd, greaterThan(bluetoothStart));
    final bluetooth = source.substring(bluetoothStart, bluetoothEnd);
    expect(bluetooth, contains('math.pow(math.sin(math.pi * wave), 2).toDouble()'));
    expect(bluetooth, contains('* strength'));
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