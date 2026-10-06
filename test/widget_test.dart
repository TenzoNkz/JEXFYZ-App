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
    expect(JexText.of('hotsideTemperature', AppLanguage.indonesia), 'Suhu Panas');
    expect(JexText.of('voltage', AppLanguage.indonesia), 'Tegangan');
    expect(JexText.of('voltageIndicator', AppLanguage.indonesia), 'Indikator Tegangan');
    expect(JexText.of('brightness', AppLanguage.indonesia), 'Kecerahan');
    expect(JexText.of('default', AppLanguage.indonesia), 'Bawaan');
    expect(JexText.of('opacity', AppLanguage.indonesia), 'Transparansi');
    expect(JexText.of('adaptiveSwitch', AppLanguage.indonesia), 'Sakelar Adaptif');
    expect(JexText.of('adaptiveOn', AppLanguage.indonesia), 'Mode Adaptif HIDUP.');
    expect(JexText.of('adaptiveOff', AppLanguage.indonesia), 'Mode Adaptif MATI.');
    expect(JexText.of('allow', AppLanguage.indonesia), 'Izinkan');
    expect(JexText.of('unknownError', AppLanguage.indonesia), 'Kesalahan tidak diketahui');

    // User-facing power states are ON/OFF in English and HIDUP/MATI in Indonesia.
    expect(JexText.of('on', AppLanguage.english), 'ON');
    expect(JexText.of('off', AppLanguage.english), 'OFF');
    expect(JexText.of('on', AppLanguage.indonesia), 'HIDUP');
    expect(JexText.of('off', AppLanguage.indonesia), 'MATI');
  });

  test('Peltier re-arm notify uses the 2C safety hysteresis threshold', () {
    expect(
      peltierRearmNotice(45, AppLanguage.english),
      'Peltier is locked. Hotside must cool to <= 43°C before restart.',
    );
    expect(
      peltierRearmNotice(45, AppLanguage.indonesia),
      'Peltier terkunci. Suhu panas harus turun hingga <= 43°C sebelum dinyalakan lagi.',
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
    expect(ledColorPalette, hasLength(24));
    expect(ledColorPalette.first, '#FF0000');
    expect(ledColorPalette.last, '#FFFFFF');
    expect(ledColorPalette, contains('#FFFFFF'));
    expect(ledColorPalette, isNot(contains('#000000')));
    for (final hex in ledColorPalette) {
      expect(RegExp(r'^#[0-9A-F]{6}$').hasMatch(hex), isTrue);
      expect(ledPaletteColor(hex), isA<Color>());
    }
  });
  test('LED preview always exposes eight horizontal pixels', () {
    final staticLevels = ledPreviewLevels(mode: 1, elapsedMs: 0);
    final centerLevels = ledPreviewLevels(mode: 3, elapsedMs: 0);
    final colors = ledPreviewColors(
      mode: 1,
      elapsedMs: 0,
      baseColor: '#FFFFFF',
      brightness: 50,
    );

    expect(staticLevels, hasLength(8));
    expect(staticLevels, everyElement(1.0));
    expect(centerLevels, hasLength(8));
    expect(centerLevels[3], 1.0);
    expect(centerLevels[4], 1.0);
    expect(centerLevels[0], 0.0);
    expect(centerLevels[7], 0.0);
    expect(colors, hasLength(8));
    expect(colors.first.red, 128);
    expect(colors.first.green, 128);
    expect(colors.first.blue, 128);
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
