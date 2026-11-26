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

  test(
    'Location service check guards the API 28-only method on minSdk 24 devices',
    () {
      final activity = File(
        'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt',
      ).readAsStringSync();
      final functionStart = activity.indexOf(
        'private fun isLocationServiceEnabled(): Boolean {',
      );
      final functionEnd = activity.indexOf(
        'private fun openLocationSettings(): Boolean {',
        functionStart,
      );
      expect(functionStart, greaterThanOrEqualTo(0));
      expect(functionEnd, greaterThan(functionStart));

      final implementation = activity.substring(functionStart, functionEnd);
      final apiGuard = implementation.indexOf(
        'if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)',
      );
      final api28Call = implementation.indexOf('manager.isLocationEnabled');
      final legacyBranch = implementation.indexOf('} else {', apiGuard);
      expect(apiGuard, greaterThanOrEqualTo(0));
      expect(api28Call, greaterThan(apiGuard));
      // The API-28-only property must remain in the guarded branch, not the
      // legacy provider fallback that executes on minSdk 24–27 devices.
      expect(api28Call, lessThan(legacyBranch));
      expect(legacyBranch, greaterThan(apiGuard));
      expect(
        implementation.indexOf(
          'manager.isProviderEnabled(LocationManager.GPS_PROVIDER)',
          legacyBranch,
        ),
        greaterThan(legacyBranch),
      );
      expect(
        implementation.indexOf(
          'manager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)',
          legacyBranch,
        ),
        greaterThan(legacyBranch),
      );
    },
  );

  test(
    'Transient Android alert IDs do not collide with persistent service IDs',
    () {
      final main = File('lib/main.dart').readAsStringSync();
      final bleService = File(
        'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt',
      ).readAsStringSync();
      final floatingService = File(
        'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt',
      ).readAsStringSync();

      const transientIds = <int>{2101, 2102, 2103, 2104};
      final bleMatch = RegExp(r'NOTIFICATION_ID\s*=\s*(\d+)')
          .firstMatch(bleService);
      final floatingMatch = RegExp(r'NOTIFICATION_ID\s*=\s*(\d+)')
          .firstMatch(floatingService);
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
    },
  );

  test('Floating Monitor hides offline and restores only after full-sync connection', () {
    final main = File('lib/main.dart').readAsStringSync();
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final native = File(
      'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt',
    ).readAsStringSync();

    expect(
      floating,
      contains('class JexFixedScalePage extends StatelessWidget'),
    );
    expect(floating, contains('textScaler: TextScaler.noScaling'));
    expect(main, contains('Future<void> _restoreFloatingMonitorAfterSync()'));
    expect(
      main,
      contains(
        '// Immediately detach any stale native overlay while this app session is offline.\n    _publishFloatingTelemetry();',
      ),
    );
    expect(
      main,
      contains('final currentTelemetry = floatingTelemetryNotifier.value;'),
    );
    expect(
      main,
      contains('if (!currentTelemetry.connected || !connected) return;'),
    );
    expect(
      native,
      contains(
        'if (config.enabled && data.connected) ensureOverlay() else removeOverlay()',
      ),
    );
    expect(native, contains('if (config.enabled && data.connected)'));
  });

  test('Deferred OTA result is translated only when it is shown', () {
    final main = File('lib/main.dart').readAsStringSync();
    expect(main, contains('pendingOtaResult = otaResult;'));
    expect(
      main,
      contains(
        'final syncedOtaNotice = isTransientOtaResultEvent(resultEvent)',
      ),
    );
    expect(
      main,
      isNot(contains('pendingOtaResult = _friendlyOtaResult(otaResult);')),
    );
  });

  test(
    'Firmware notification cooldown is recorded only after native post succeeds',
    () {
      final main = File('lib/main.dart').readAsStringSync();
      final activity = File(
        'android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt',
      ).readAsStringSync();

      final otaStart = main.indexOf(
        'if (updateAvailable && appNotifyFirmwareNotifier.value)',
      );
      final otaEnd = main.indexOf(
        "debugPrint('Firebase OTA metadata:",
        otaStart,
      );
      expect(otaStart, greaterThanOrEqualTo(0));
      expect(otaEnd, greaterThan(otaStart));

      final otaNotification = main.substring(otaStart, otaEnd);
      final showCall = otaNotification.indexOf(
        ".invokeMethod<bool>('showNotification'",
      );
      final successGuard = otaNotification.indexOf(
        'if (notificationShown == true)',
      );
      final markNotified = otaNotification.indexOf(
        'await AppSettingsStore.markFirmwareNotified(version);',
      );
      expect(showCall, greaterThanOrEqualTo(0));
      expect(successGuard, greaterThan(showCall));
      expect(markNotified, greaterThan(successGuard));
      expect(
        otaNotification,
        isNot(contains(".invokeMethod<void>('showNotification'")),
      );

      final showStart = activity.indexOf(
        'private fun showUserNotification(',
      );
      final showEnd = activity.indexOf(
        'private fun openBluetoothSettings(',
        showStart,
      );
      expect(showStart, greaterThanOrEqualTo(0));
      expect(showEnd, greaterThan(showStart));

      final showImplementation = activity.substring(showStart, showEnd);
      final permissionCheck = showImplementation.indexOf(
        'PackageManager.PERMISSION_GRANTED',
      );
      final permissionRequest = showImplementation.indexOf(
        'requestNotificationPermission(language)',
        permissionCheck,
      );
      final deniedResult = showImplementation.indexOf(
        'return false',
        permissionRequest,
      );
      final postNotification = showImplementation.indexOf(
        '.notify(id, notification)',
      );
      final successfulResult = showImplementation.indexOf(
        '\n            true',
        postNotification,
      );
      expect(permissionCheck, greaterThanOrEqualTo(0));
      expect(permissionRequest, greaterThan(permissionCheck));
      expect(deniedResult, greaterThan(permissionRequest));
      expect(postNotification, greaterThan(deniedResult));
      expect(successfulResult, greaterThan(postNotification));
    },
  );

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

    expect(
      main,
      contains('Future<void> _syncNotificationChannelLanguage() async'),
    );
    expect(main, contains("'updateNotificationChannelLanguage'"));
    expect(main, contains('unawaited(_syncNotificationChannelLanguage());'));
    expect(
      activity,
      contains(
        'JeForegroundService.updateNotificationChannelLanguage(this, language)',
      ),
    );
    expect(
      activity,
      contains(
        'FloatingMonitorService.updateNotificationChannelLanguage(this, language)',
      ),
    );
    expect(
      foreground,
      contains(
        'fun updateNotificationChannelLanguage(context: Context, language: String)',
      ),
    );
    expect(
      floating,
      contains(
        'fun updateNotificationChannelLanguage(context: Context, language: String)',
      ),
    );
    expect(foreground, contains('Bluetooth connected · device session active'));
    expect(foreground, contains('Bluetooth terhubung · sesi perangkat aktif'));
    expect(floating, contains('"Floating Monitor"'));
    expect(floating, contains('"Monitor Melayang"'));
    expect(floating, contains('activeModeText'));
    expect(floating, contains('inactiveModeText'));
  });
}
