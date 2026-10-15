import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Wireless ADB pairing uses an explicit notification action and a fixed local FPS grant', () {
    final gradle = File('android/app/build.gradle').readAsStringSync();
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    final activity = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt').readAsStringSync();
    final service = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/WirelessAdbPairingService.kt').readAsStringSync();
    final identity = File('android/app/src/main/kotlin/com/horizontalzzz/jexfyz/WirelessAdbIdentityStore.kt').readAsStringSync();
    final floating = File('lib/floating_monitor.dart').readAsStringSync();

    expect(gradle, contains('com.flyfishxu:kadb:1.3.0'));
    expect(manifest, contains('android:name=".WirelessAdbPairingService"'));
    expect(manifest, contains('android:exported="false"'));
    expect(manifest, contains('android:foregroundServiceType="specialUse"'));
    expect(activity, contains('"je_x_fyz/adb_pairing"'));
    expect(activity, contains('"startWirelessAdbPairing"'));
    expect(floating, contains("MethodChannel('je_x_fyz/adb_pairing')"));
    expect(floating, contains('WirelessAdbPairingBridge.start(language)'));
    expect(service, contains('RemoteInput.Builder(EXTRA_CODE)'));
    expect(service, contains('Regex("[0-9]{6}")'));
    expect(service, contains('Kadb.pair(LOOPBACK, requestedPort, code, "JE Cooler")'));
    expect(service, contains('Kadb.create(LOOPBACK, port'));
    expect(service, contains('private const val GRANT_DUMP_COMMAND = "pm grant com.horizontalzzz.jexfyz android.permission.DUMP"'));
    expect(service, isNot(contains('intent.getStringExtra("command")')));
    expect(identity, contains('AES/GCM/NoPadding'));
    expect(identity, contains('AndroidKeyStore'));
    expect(identity, contains('context.noBackupFilesDir'));
  });
}
