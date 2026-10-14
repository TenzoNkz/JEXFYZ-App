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

  test('Floating Monitor exposes Speed as the only fan-related metric', () {
    final config = FloatingConfig.fromJson(
      '{"order":["FAN","F","B","H","V","A","P","S"],"selected":["FAN","S"]}',
    );
    expect(config.order.contains('FAN'), isFalse);
    expect(config.order.contains('S'), isTrue);
    expect(config.selected.contains('FAN'), isFalse);
    expect(config.selected.contains('S'), isTrue);
  });

  test('Floating Monitor state presentation keeps Adaptive and Peltier independent from Fan', () {
    const telemetry = FloatingTelemetry(
      fanOn: false,
      speed: 70,
      adaptiveOn: true,
      peltierOn: true,
      connected: true,
    );
    expect(floatingMetricVisible('S', telemetry), isTrue);
    expect(floatingMetricVisible('A', telemetry), isTrue);
    expect(floatingMetricVisible('P', telemetry), isTrue);
    expect(floatingMetricStatus('A', telemetry, AppLanguage.english), 'ON');
    expect(floatingMetricStatus('P', telemetry, AppLanguage.english), 'ON');
    expect(floatingMetricStatus('A', telemetry, AppLanguage.indonesia), 'HIDUP');
    expect(floatingMetricStatus('P', telemetry, AppLanguage.indonesia), 'HIDUP');
    expect(floatingMetricStatus('S', telemetry, AppLanguage.english), 'OFF');
    expect(floatingMetricStatus('S', telemetry, AppLanguage.indonesia), 'MATI');
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
      jexIconAnimationDuration(JexAnimatedIconKind.fan),
      const Duration(milliseconds: 1050),
    );
    expect(
      jexIconAnimationDuration(JexAnimatedIconKind.adaptive),
      const Duration(milliseconds: 2400),
    );
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
    expect(jexIconAnimationDuration(JexAnimatedIconKind.fan), const Duration(milliseconds: 1450));
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
    expect(ledColorPalette, isNot(contains('#000000')));
  });

  test('LED UI keeps its own color menu anchored to the display region', () {
    final source = File('lib/main.dart').readAsStringSync();
    expect(source, contains('widget.modeName.toUpperCase()'));
    expect(source, isNot(contains('widget.modeNumber')));
    expect(source, contains('ledColorDisplayName(rgbColor, lang)'));
    expect(source, contains("stateKnown ? JexText.of(value ? 'on' : 'off', lang) : JexText.of('off', lang)"));
    expect(source, contains('final displayedValue = stateKnown && value;'));
    expect(source, contains('displayMenuOverlayTop('));
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
    expect(helper, contains('R.drawable.ic_notification'));
    expect(helper, isNot(contains('R.drawable.jexfyzicon')));
    expect(helper, isNot(contains('setLargeIcon')));
    expect(icon, contains('JE X FYZ monogram'));
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