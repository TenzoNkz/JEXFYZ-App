import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FPS access requires Shizuku permission and has no ADB pairing path', () {
    final gradle = File('android/app/build.gradle').readAsStringSync();
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    final activity = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt').readAsStringSync();
    final service = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt').readAsStringSync();
    final shizukuService = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt').readAsStringSync();
    final aidl = File('android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl').readAsStringSync();
    final floating = File('lib/floating_monitor.dart').readAsStringSync();
    final settings = File('lib/app_settings.dart').readAsStringSync();
    final mainWidgetTest = File('test/widget_test.dart').readAsStringSync();

    expect(gradle, contains('dev.rikka.shizuku:api:13.1.5'));
    expect(gradle, contains('dev.rikka.shizuku:provider:13.1.5'));
    expect(gradle, contains('aidl = true'));
    expect(gradle, isNot(contains('com.flyfishxu:kadb')));
    expect(manifest, contains('rikka.shizuku.ShizukuProvider'));
    expect(manifest, contains('moe.shizuku.privileged.api'));
    expect(manifest, isNot(contains('android.permission.DUMP')));
    expect(manifest, isNot(contains('WirelessAdbPairingService')));
    expect(manifest, isNot(contains('ACCESS_WIFI_STATE')));
    expect(activity, contains('Shizuku.requestPermission(SHIZUKU_PERMISSION_REQUEST_CODE)'));
    expect(activity, contains('Shizuku.addBinderReceivedListenerSticky'));
    expect(activity, contains('"requestShizukuFpsPermission"'));
    expect(activity, contains('"openShizukuSetup"'));
    expect(activity, isNot(contains('ADB_PAIRING_CHANNEL')));
    expect(activity, isNot(contains('startWirelessAdbPairing')));
    expect(floating, contains('FloatingBridge.requestShizukuFpsPermission()'));
    expect(floating, contains('_requestShizukuFpsAccess()'));
    expect(floating, contains("if (metric == 'F' && value)"));
    expect(floating, contains('shizuku_permission_granted'));
    expect(floating, isNot(contains('adb shell pm grant')));
    expect(floating, isNot(contains('adb shell pm revoke')));
    expect(floating, isNot(contains('WirelessAdbPairingBridge')));
    expect(settings, contains("'shizukuNotRunning'"));
    expect(settings, contains("'requestShizukuPermission'"));
    expect(settings, isNot(contains('pairWirelessAdb')));
    expect(settings, isNot(contains('copyAdbCommand')));
    expect(service, contains('Shizuku.checkSelfPermission()'));
    expect(service, contains('Shizuku.bindUserService(fpsUserServiceArgs, fpsUserServiceConnection)'));
    expect(service, contains('runDumpsys("SurfaceFlinger", "--timestats", "-dump")'));
    expect(service, contains('.filter { layerBelongsToPackage(it.name, foregroundPackage) }'));
    expect(service, contains('delta * 1000.0 / elapsed.toDouble()'));
    expect(service, isNot(contains('android.permission.DUMP')));
    expect(service, isNot(contains('ProcessBuilder(')));
    expect(aidl, contains('Bundle executeFpsOperation(int operation);'));
    expect(shizukuService, contains('override fun executeFpsOperation(operation: Int): Bundle'));
    expect(shizukuService, contains('OP_START_CAPTURE'));
    expect(shizukuService, contains('OP_READ_FOREGROUND_ACTIVITY'));
    expect(shizukuService, contains('ProcessBuilder(listOf("/system/bin/dumpsys") + arguments)'));
    expect(shizukuService, isNot(contains('command: String')));
    expect(shizukuService, isNot(contains('intent.getStringExtra("command")')));
    expect(mainWidgetTest, isNot(contains('adb shell pm grant com.horizontalzzz.jexfyz android.permission.DUMP')));
    expect(mainWidgetTest, isNot(contains('adb shell pm revoke com.horizontalzzz.jexfyz android.permission.DUMP')));
  });
}
