// AI-MEMORY / DEVICE-COPY + NOTIFICATION-CONTRACT
// Static source contracts for user-facing terminology, notification identity and BLE-gated overlay.
// These checks do not replace Flutter execution, Android compilation, OEM permission checks or device QA.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Home brand remains unchanged while device-facing copy is generic and bilingual', () {
    final main = File('lib/main.dart').readAsStringSync();
    final copy = File('lib/app_settings.dart').readAsStringSync();

    expect(main, contains("const String headerName = 'JE X FYZ';"));
    expect(main, contains('CONNECT YOUR DEVICE FIRST'));
    expect(main, contains('Connect your device to use this menu.'));
    expect(main, contains('Hubungkan perangkat untuk menggunakan menu ini.'));
    expect(main, isNot(contains('CONNECT TO JE X FYZ FIRST')));
    expect(copy, contains("AppLanguage.english: 'Device connected.'"));
    expect(copy, contains("AppLanguage.indonesia: 'Perangkat terputus.'"));
    expect(copy, contains("'firmwareUpdateAvailableBody':"));
    expect(copy, contains('Connect your device to update.'));
    expect(copy, contains('Hubungkan perangkat untuk memperbarui firmware.'));
  });

  test('Transient Android alert IDs do not collide with persistent service IDs', () {
    final main = File('lib/main.dart').readAsStringSync();
    final bleService = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt',
    ).readAsStringSync();
    final floatingService = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt',
    ).readAsStringSync();

    const transientIds = <int>{2101, 2102, 2103, 2104};
    final bleMatch = RegExp(r'NOTIFICATION_ID\s*=\s*(\d+)').firstMatch(bleService);
    final floatingMatch = RegExp(r'NOTIFICATION_ID\s*=\s*(\d+)').firstMatch(floatingService);
    expect(bleMatch, isNotNull);
    expect(floatingMatch, isNotNull);
    final bleId = int.parse(bleMatch!.group(1)!);
    final floatingId = int.parse(floatingMatch!.group(1)!);

    expect(bleId, 2110);
    expect(floatingId, 2301);
    expect(transientIds.contains(bleId), isFalse);
    expect(transientIds.contains(floatingId), isFalse);
    expect(main, contains('2101,'));
    expect(main, contains('2104,'));
  });

  test('Floating Monitor hides offline and restores only after full-sync connection', () {
    final main = File('lib/main.dart').readAsStringSync();
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final native = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt',
    ).readAsStringSync();

    expect(floating, contains('class JexFixedScalePage extends StatelessWidget'));
    expect(floating, contains('textScaler: TextScaler.noScaling'));
    expect(main, contains('Future<void> _restoreFloatingMonitorAfterSync()'));
    expect(main, contains('// Immediately detach any stale native overlay while this app session is offline.\n    _publishFloatingTelemetry();'));
    expect(main, contains('final currentTelemetry = floatingTelemetryNotifier.value;'));
    expect(main, contains('if (!currentTelemetry.connected || !connected) return;'));
    expect(native, contains('if (config.enabled && data.connected) ensureOverlay() else removeOverlay()'));
    expect(native, contains('if (config.enabled && data.connected)'));
  });

  test('Deferred OTA result is translated only when it is shown', () {
    final main = File('lib/main.dart').readAsStringSync();
    expect(main, contains('pendingOtaResult = otaResult;'));
    expect(main, contains('final syncedOtaNotice = isTransientOtaResultEvent(resultEvent)'));
    expect(main, isNot(contains('pendingOtaResult = _friendlyOtaResult(otaResult);')));
  });

  test('All Android notification channels follow the selected App language', () {
    final main = File('lib/main.dart').readAsStringSync();
    final activity = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt',
    ).readAsStringSync();
    final foreground = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt',
    ).readAsStringSync();
    final floating = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt',
    ).readAsStringSync();

    expect(main, contains('Future<void> _syncNotificationChannelLanguage() async'));
    expect(main, contains("'updateNotificationChannelLanguage'"));
    expect(main, contains('unawaited(_syncNotificationChannelLanguage());'));
    expect(activity, contains('JeForegroundService.updateNotificationChannelLanguage(this, language)'));
    expect(activity, contains('FloatingMonitorService.updateNotificationChannelLanguage(this, language)'));
    expect(foreground, contains('fun updateNotificationChannelLanguage(context: Context, language: String)'));
    expect(floating, contains('fun updateNotificationChannelLanguage(context: Context, language: String)'));
  });
}
