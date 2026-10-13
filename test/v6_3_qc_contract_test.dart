import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/floating_monitor.dart';
import 'package:jexfyz_cooler/main.dart';

void main() {
  test('Peltier re-arm target is hotLimit minus one degree', () {
    expect(peltierRearmTarget(45), 44);
    expect(peltierRearmTarget(40), 39);
    expect(peltierRearmTarget(50), 49);
  });

  test('LED color confirmation normalizes optional hash and case', () {
    expect(normalizeLedColor('FF0000'), 'FF0000');
    expect(normalizeLedColor('#ff0000'), 'FF0000');
    expect(normalizeLedColor(' #00FF80 '), '00FF80');
  });

  test('V6.3 firmware keeps one calibrated NTC read and cooperative timing', () {
    final source = File('firmware/JEXFYZ-V6.3.ino').readAsStringSync();
    expect(source, contains('FW_VERSION[] = "V6.3"'));
    expect(RegExp(r'analogReadMilliVolts\(PIN_NTC\)').allMatches(source).length, 1);
    expect(RegExp(r'^\s*delay\s*\(', multiLine: true).hasMatch(source), isFalse);
    expect(RegExp(r'^\s*while\s*\(', multiLine: true).hasMatch(source), isFalse);
  });

  test('Adaptive protection has 30-second stages and 60-second voltage recovery', () {
    final source = File('firmware/JEXFYZ-V6.3.ino').readAsStringSync();
    expect(source, contains('HOT_PELTIER_OFF_MS          = 30000'));
    expect(source, contains('HOTSIDE_REARM_STABLE_MS = 5000UL'));
    expect(source, contains('ADAPTIVE_VOLTAGE_RECOVERY_STABLE_MS = 60000UL'));
    expect(source, contains('adaptiveThermalRecoveryActive'));
    expect(source, contains('currentVoltage == Voltage::V5'));
    expect(source, contains('startHotsideRecoveryLockIndicator();'));
    expect(source, contains('now < peltierHotOffUntilMs &&'));
    expect(source, contains('adaptiveThermalRecoveryActive ||'));
  });

  test('Online OTA validates GitHub HTTPS; Local OTA scope stays unchanged', () {
    final source = File('firmware/JEXFYZ-V6.3.ino').readAsStringSync();
    expect(source, contains('https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/'));
    expect(source, contains('cloudClient.setCACert(GITHUB_ROOT_CA)'));
    expect(source, isNot(contains('cloudClient.setInsecure()')));
    expect(source, contains('case OnlineOtaFlow::TIME_SYNCING'));
    expect(source, contains('configTime(0, 0, "pool.ntp.org", "time.google.com")'));
    expect(source, contains('ONLINE_OTA_TIME_SYNC_TIMEOUT_MS = 20000UL'));
    expect(source, contains('HTTPC_DISABLE_FOLLOW_REDIRECTS'));
    expect(source, contains('static constexpr char AP_PASSWORD[] = "0987654321";'));
  });

  test('BLE command writes require encryption and bonding', () {
    final source = File('firmware/JEXFYZ-V6.3.ino').readAsStringSync();
    expect(source, contains('#include <BLESecurity.h>'));
    expect(source, contains('BLESecurity::setAuthenticationMode(true, false, true)'));
    expect(source, contains('BLECharacteristic::PROPERTY_WRITE_ENC'));
    expect(source, contains('setAccessPermissions(ESP_GATT_PERM_WRITE_ENC)'));
  });

  test('Floating Monitor uses unknown labels while the BLE session is offline', () {
    const telemetry = FloatingTelemetry(
      connected: false,
      adaptiveOn: true,
      peltierOn: true,
      fanOn: true,
      speed: 90,
    );
    expect(floatingMetricStatus('A', telemetry, AppLanguage.english), '--');
    expect(floatingMetricStatus('P', telemetry, AppLanguage.english), '--');
    expect(floatingMetricStatus('S', telemetry, AppLanguage.english), '--');
  });

  test('App waits for voltage telemetry and marks disconnected outputs unknown', () {
    final source = File('lib/main.dart').readAsStringSync();
    expect(source, contains("if (c.startsWith('VOLTAGE:')) return MapEntry('VOLTAGE', c.substring(8));"));
    expect(source, contains("case 'VOLTAGE':\n        return voltage.toUpperCase() == expected.toUpperCase();"));
    expect(source, contains('runtimeOutputsKnown = false;'));
    expect(source, contains("stateKnown ? JexText.of(value ? 'on' : 'off', lang) : '--'"));
  });

  test('manual Peltier lock cannot be bypassed by one threshold sample', () {
    final source = File('firmware/JEXFYZ-V6.3.ino').readAsStringSync();
    final start = source.indexOf('static bool manualPeltierSafetyLatchBlocksPeltier() {');
    final end = source.indexOf('static bool safetyAllowsPeltier()', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final helper = source.substring(start, end);
    expect(helper, contains('return manualPeltierSafetyLatch;'));
    expect(helper, isNot(contains('return hotsideC >')));
    expect(source, contains('if (manualPeltierSafetyLatch && hotsideRearmStable)'));
  });

}
