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

  test('Active firmware keeps one calibrated NTC read and cooperative timing', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    expect(source, contains('FW_VERSION[] = "V6.9"'));
    expect(RegExp(r'analogReadMilliVolts\(PIN_NTC\)').allMatches(source).length, 1);
    expect(RegExp(r'^\s*delay\s*\(', multiLine: true).hasMatch(source), isFalse);
    expect(RegExp(r'^\s*while\s*\(', multiLine: true).hasMatch(source), isFalse);
  });

  test('Adaptive protection has 30-second stages and 60-second voltage recovery', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    expect(source, contains('HOT_PELTIER_OFF_MS          = 30000'));
    expect(source, contains('HOTSIDE_REARM_STABLE_MS = 5000UL'));
    expect(source, contains('ADAPTIVE_VOLTAGE_RECOVERY_STABLE_MS = 60000UL'));
    expect(source, contains('adaptiveThermalRecoveryActive'));
    expect(source, contains('currentVoltage == Voltage::V5'));
    expect(source, contains('startHotsideRecoveryLockIndicator();'));
    expect(source, contains('now < peltierHotOffUntilMs &&'));
    expect(source, contains('adaptiveThermalRecoveryActive ||'));
  });

  test('V6.9 Adaptive Fan PWM uses timed 10-point ramp steps', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    expect(source, contains('FW_VERSION[] = "V6.9"'));

    final helperStart = source.indexOf('static uint8_t adaptiveFanTargetPwm(float temperatureC) {');
    final helperEnd = source.indexOf('static void resetAdaptiveFanPwmStepClock()', helperStart);
    final controllerStart = source.indexOf('static void processAdaptiveFanControl() {');
    final controllerEnd = source.indexOf('static String safetyReason()', controllerStart);
    expect(helperStart, greaterThanOrEqualTo(0));
    expect(helperEnd, greaterThan(helperStart));
    expect(controllerStart, greaterThanOrEqualTo(0));
    expect(controllerEnd, greaterThan(controllerStart));

    final helper = source.substring(helperStart, helperEnd);
    for (final tier in [
      'if (belowLimitC < 1.5f) return FAN_PWM_MAX;',
      'if (belowLimitC < 2.5f) return 90;',
      'if (belowLimitC < 3.5f) return 80;',
      'if (belowLimitC < 4.5f) return 70;',
      'if (belowLimitC < 5.5f) return 60;',
      'return FAN_PWM_MIN;',
    ]) {
      expect(helper, contains(tier), reason: 'Missing Adaptive Fan target tier: $tier');
    }
    expect(helper, contains('static_cast<float>(hotLimit) - temperatureC'));
    expect(helper, contains('if (!isfinite(temperatureC)) return FAN_PWM_MAX;'));

    final controller = source.substring(controllerStart, controllerEnd);
    expect(source, contains('ADAPTIVE_FAN_DOWNSTEP_INTERVAL_MS = 10000UL'));
    expect(source, contains('ADAPTIVE_FAN_UPSTEP_INTERVAL_MS = 1000UL'));
    expect(source, contains('ADAPTIVE_FAN_STEP_PERCENT = 10'));
    expect(controller, contains('if (!adaptiveOn)'));
    expect(controller, contains('if (voltageTransition || adaptiveHotStepPending ||'));
    expect(controller, contains('resetAdaptiveFanPwmStepClock();'));
    expect(controller, contains('hotsideProtectionActiveNow() || hotsideC >= static_cast<float>(hotLimit)'));
    expect(controller, contains('const uint32_t intervalMs = direction < 0'));
    expect(controller, contains('ADAPTIVE_FAN_DOWNSTEP_INTERVAL_MS'));
    expect(controller, contains('ADAPTIVE_FAN_UPSTEP_INTERVAL_MS'));
    expect(controller, contains('if (now - adaptiveFanStepStartedMs < intervalMs) return;'));
    expect(controller, contains('const int step = static_cast<int>(ADAPTIVE_FAN_STEP_PERCENT);'));
    expect(controller, contains('if (currentVoltage != Voltage::V12)'));

    for (final obsolete in [
      'ADAPTIVE_FAN_WINDOW_SAMPLES',
      'adaptiveFanStableWindowStartedMs',
      'warmingTrendConfirmed',
      'adaptiveFanPreviousTemperatureC',
      'adaptiveFanLastDownStepMs',
      'adaptiveFanLastUpStepMs',
    ]) {
      expect(source, isNot(contains(obsolete)), reason: 'Obsolete trend/window state remains: $obsolete');
    }

    expect(source, contains('static void processAdaptiveFanControl();'));
    expect(source, contains('processAdaptiveFanControl();'));
    // NTC remains one calibrated sample each second; the ramp is non-blocking.
    expect(RegExp(r'analogReadMilliVolts\\(PIN_NTC\\)').allMatches(source).length, 1);
    expect(source, contains('FAN_PWM_MIN = 50'));
    expect(source, contains('FAN_PWM_MAX = 100'));
    expect(RegExp(r'^\\s*delay\\s*\\(', multiLine: true).hasMatch(source), isFalse);
    expect(RegExp(r'^\\s*while\\s*\\(', multiLine: true).hasMatch(source), isFalse);
  });

  test('Online OTA preserves the legacy connection path and GitHub URL restrictions', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();

    expect(source, isNot(contains('GITHUB_ROOT_CA')));
    expect(source, isNot(contains('-----BEGIN CERTIFICATE-----')));
    expect(source, contains('cloudClient.setIn' + 'secure()'));
    expect(source, isNot(contains('cloudClient.setCACert(')));
    expect(source, isNot(contains('case OnlineOtaFlow::TIME_SYNCING')));
    expect(source, isNot(contains('configTime(')));
    expect(source, isNot(contains('ONLINE_OTA_TIME_SYNC_TIMEOUT_MS')));
    expect(source, isNot(contains('ONLINE_OTA_VALID_TIME_EPOCH')));

    expect(source, contains('https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/'));
    expect(source, contains('HTTPC_DISABLE_FOLLOW_REDIRECTS'));

    final wifiStart = source.indexOf('case OnlineOtaFlow::WIFI_CONNECTING:');
    final downloadStart = source.indexOf('case OnlineOtaFlow::DOWNLOAD:', wifiStart);
    expect(wifiStart, greaterThanOrEqualTo(0));
    expect(downloadStart, greaterThan(wifiStart));
    final wifiFlow = source.substring(wifiStart, downloadStart);
    expect(wifiFlow, contains('if (WiFi.status() == WL_CONNECTED)'));
    expect(wifiFlow, contains('0x0000FF'));
    expect(wifiFlow, contains('OnlineOtaIndicatorNext::PREPARE_DOWNLOAD'));

    expect(source, contains('static constexpr char AP_PASSWORD[] = "0987654321";'));
  });

  test('Manual and Adaptive transitions pause only an active soft-start and preserve full PWM', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();

    expect(source, contains('VOLTAGE_DEADTIME_MS           = 200'));
    expect(source, contains('VOLTAGE_GUARD_MS             = 1000'));
    expect(source, contains('PELTIER_VOLTAGE_SETTLE_MS = VOLTAGE_GUARD_MS'));
    expect(source, contains('PELTIER_SOFT_START_MS = 5000'));
    expect(source, contains('bool peltierVoltagePauseActive = false;'));
    expect(source, contains('bool peltierVoltageResumeSoftStart = false;'));
    expect(source, contains('static void pausePeltierForVoltageTransition()'));
    expect(source, contains('ledcWrite(PIN_PELTIER, 0);'));

    final requestStart = source.indexOf(
      'static bool requestVoltage(Voltage target, VoltageRequestSource source, bool bypassGuard)',
    );
    final transitionStart = source.indexOf(
      'static void completeVoltageTransition()',
      requestStart,
    );
    expect(requestStart, greaterThanOrEqualTo(0));
    expect(transitionStart, greaterThan(requestStart));

    final request = source.substring(requestStart, transitionStart);
    final markTransition = request.indexOf('voltageTransition = true;');
    final pausePeltier = request.indexOf('pausePeltierForVoltageTransition();');
    final selectorOff = request.indexOf('digitalWrite(PIN_9V, OUTPUT_OFF);');
    expect(markTransition, greaterThanOrEqualTo(0));
    expect(pausePeltier, greaterThan(markTransition));
    expect(selectorOff, greaterThan(pausePeltier));

    final pauseStart = source.indexOf('static void pausePeltierForVoltageTransition()');
    final processStart = source.indexOf('static void processPeltierSoftStart()', pauseStart);
    expect(pauseStart, greaterThanOrEqualTo(0));
    expect(processStart, greaterThan(pauseStart));
    final pauseHelper = source.substring(pauseStart, processStart);
    final completedRampGuard = pauseHelper.indexOf('if (!peltierSoftStarting)');
    final completeRampReturn = pauseHelper.indexOf('return;', completedRampGuard);
    final captureRamp = pauseHelper.indexOf('peltierVoltageResumeSoftStart = true;');
    final clearRamp = pauseHelper.indexOf('peltierSoftStarting = false;');
    expect(pauseHelper, contains('if (!peltierOn) return;'));
    expect(completedRampGuard, greaterThanOrEqualTo(0));
    expect(completeRampReturn, greaterThan(completedRampGuard));
    expect(captureRamp, greaterThan(completeRampReturn));
    expect(pauseHelper, contains('peltierVoltagePauseActive = false;'));
    expect(pauseHelper, contains('peltierVoltageResumeSoftStart = false;'));
    expect(pauseHelper, contains('peltierVoltagePauseActive = true;'));
    expect(pauseHelper, contains('lastPeltierDuty = 0;'));
    expect(clearRamp, greaterThan(captureRamp));

    final stopStart = source.indexOf('static void stopPeltierOutput()');
    final beginStart = source.indexOf('static void beginPeltierSoftStart()', stopStart);
    expect(stopStart, greaterThanOrEqualTo(0));
    expect(beginStart, greaterThan(stopStart));
    final stopHelper = source.substring(stopStart, beginStart);
    expect(stopHelper, contains('peltierVoltagePauseActive = false;'));
    expect(stopHelper, contains('peltierVoltageResumeSoftStart = false;'));

    final processEnd = source.indexOf('static bool hotsideProtectionActiveNow()', processStart);
    final process = source.substring(processStart, processEnd);
    final transitionGate = process.indexOf('if (voltageTransition)');
    final rampOnlyPauseGate = process.indexOf(
      'if (peltierVoltagePauseActive && lastPeltierDuty != 0)',
      transitionGate,
    );
    final waitGate = process.indexOf('if (peltierVoltagePauseActive)');
    final guardCheck = process.indexOf(
      'millis() - lastVoltageTransitionCompleteMs < PELTIER_VOLTAGE_SETTLE_MS',
    );
    final savedRamp = process.indexOf(
      'const bool restartSoftStart = peltierVoltageResumeSoftStart;',
      waitGate,
    );
    final clearSavedRamp = process.indexOf(
      'peltierVoltageResumeSoftStart = false;',
      savedRamp,
    );
    final conditionalRamp = process.indexOf('if (restartSoftStart)', clearSavedRamp);
    final freshRamp = process.indexOf('beginPeltierSoftStart();', conditionalRamp);
    final fullSpeedFallback = process.indexOf('if (!peltierSoftStarting)', conditionalRamp);
    final fullDutyWrite = process.indexOf('ledcWrite(PIN_PELTIER, 255);', fullSpeedFallback);

    expect(transitionGate, greaterThanOrEqualTo(0));
    expect(rampOnlyPauseGate, greaterThan(transitionGate));
    expect(waitGate, greaterThan(transitionGate));
    expect(guardCheck, greaterThan(waitGate));
    expect(savedRamp, greaterThan(guardCheck));
    expect(clearSavedRamp, greaterThan(savedRamp));
    expect(conditionalRamp, greaterThan(clearSavedRamp));
    expect(freshRamp, greaterThan(conditionalRamp));
    expect(fullSpeedFallback, greaterThan(freshRamp));
    expect(fullDutyWrite, greaterThan(fullSpeedFallback));

    // Device diagnostics must continue to expose a brownout reset reason.
    expect(source, contains('case ESP_RST_BROWNOUT: return "BROWNOUT";'));
    expect(source, contains('Serial.println(resetReasonText());'));
    expect(source, contains('sendDelta("RESET_REASON", resetReasonText());'));
  });

  test('Adaptive activation observes the new voltage-settle timestamp first', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    final start = source.indexOf('static void completeVoltageTransition() {');
    final end = source.indexOf('static float ntcTemperatureFromOhms', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final transition = source.substring(start, end);
    final selectorCommit = transition.indexOf('currentVoltage = pendingVoltage;');
    final transitionClosed = transition.indexOf('voltageTransition = false;', selectorCommit);
    final settleTimestamp = transition.indexOf(
      'lastVoltageTransitionCompleteMs = millis();',
      transitionClosed,
    );
    final adaptiveActivation = transition.indexOf(
      'activateAdaptiveAfterSafeFiveVolt();',
      transitionClosed,
    );

    expect(selectorCommit, greaterThanOrEqualTo(0));
    expect(transitionClosed, greaterThan(selectorCommit));
    expect(settleTimestamp, greaterThan(transitionClosed));
    expect(adaptiveActivation, greaterThan(settleTimestamp));
  });

  test('Adaptive ON/OFF handoffs do not force a redundant Peltier OFF cycle', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    final start = source.indexOf('static void setAdaptiveState(bool desired, String& reason) {');
    final end = source.indexOf('static bool setRgbState(bool desired)', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final handler = source.substring(start, end);

    final onHandoff = handler.indexOf(
      '// Keep Peltier state intact during the Adaptive safe-5V handoff.',
    );
    final redirect = handler.indexOf('if (voltageTransition)', onHandoff);
    final request = handler.indexOf(
      'if (!requestVoltage(Voltage::V5, VoltageRequestSource::ADAPTIVE, true))',
      redirect,
    );
    final onFailure = handler.indexOf('reason = "VOLTAGE_FORCE_FAILED";', request);
    expect(onHandoff, greaterThanOrEqualTo(0));
    expect(redirect, greaterThan(onHandoff));
    expect(request, greaterThan(redirect));
    expect(onFailure, greaterThan(request));
    final onHandoffPath = handler.substring(onHandoff, onFailure);
    expect(onHandoffPath, contains('applyCoolingOutputs('));
    expect(onHandoffPath, isNot(contains('peltierOn = false;')));

    final offHandoff = handler.indexOf(
      'const bool handoffRequired =',
      onFailure,
    );
    final forceFive = handler.indexOf('if (!forceAdaptiveFiveVolt())', offHandoff);
    expect(offHandoff, greaterThan(onFailure));
    expect(forceFive, greaterThan(offHandoff));
    final offHandoffPath = handler.substring(offHandoff, forceFive);
    expect(offHandoffPath, contains('applyCoolingOutputs('));
    expect(offHandoffPath, isNot(contains('peltierOn = false;')));
    expect(offHandoffPath, isNot(contains('if (handoffRequired && peltierOn)')));
  });

  test('Explicit Peltier OFF cancels deferred Adaptive-stop restoration', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    final start = source.indexOf('static bool setPeltierState(bool desired, String& reason) {');
    final end = source.indexOf('static bool forceAdaptiveFiveVolt()', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final handler = source.substring(start, end);
    final offStart = handler.indexOf('if (!desired) {');
    final cancelRestore = handler.indexOf('adaptiveStopRestorePeltier = false;', offStart);
    final peltierStop = handler.indexOf('peltierOn = false;', offStart);
    expect(offStart, greaterThanOrEqualTo(0));
    expect(cancelRestore, greaterThan(offStart));
    expect(peltierStop, greaterThan(cancelRestore));
  });

  test('V6.9 and newer App mode state is updated only by atomic LED_SYNC', () {
    final source = File('lib/main.dart').readAsStringSync();
    final start = source.indexOf("case 'MODE':");
    final end = source.indexOf("case 'LED_PHASE':", start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final handler = source.substring(start, end);
    expect(handler, contains('parseFirmwareVersion(firmwareVersion)'));
    expect(handler, contains('activeFirmware[1] >= 6'));
    expect(handler, contains('if (!atomicLedSync)'));
    expect(handler, contains('rgbMode = (int.tryParse(value) ?? rgbMode)'));
    expect(source, contains("case 'LED_SYNC':"));
  });

  test('Firmware retires Mirror Pulse without renumbering other LED IDs', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    expect(source, contains('STATIC = 1'));
    expect(source, contains('BREATH = 2'));
    expect(source, contains('COMET = 4'));
    expect(source, contains('DUAL_CHASE = 5'));
    expect(source, contains('LEFT_RIGHT = 6'));
    expect(source, contains('RAINBOW = 7'));
    expect(source, isNot(contains('MIRROR_PULSE')));
    expect(source, contains('if (!isSupportedLedModeId(value))'));
    expect(source, contains('prefs.putUChar("rgbMode", static_cast<uint8_t>(rgbMode))'));
  });

  test('Firmware emits atomic LED_SYNC snapshot at BLE notify time', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    final serviceStart = source.indexOf('static void serviceBleTx() {');
    final serviceEnd = source.indexOf('static void sendDelta(', serviceStart);
    expect(serviceStart, greaterThanOrEqualTo(0));
    expect(serviceEnd, greaterThan(serviceStart));
    final service = source.substring(serviceStart, serviceEnd);
    expect(service, contains('LED_SYNC_QUEUE_MARKER'));
    expect(service, contains('const uint32_t syncNow = millis();'));
    expect(service, contains('"LED_SYNC:"'));
    expect(service, contains('ledAnimationPhaseMs(syncNow)'));
    expect(service, contains('ledAnimationCycleMs(rgbMode)'));

    final publisherStart = source.indexOf('static void publishLedAnimationSync()');
    final publisherEnd = source.indexOf('static void renderCustomLedFrame(', publisherStart);
    final publisher = source.substring(publisherStart, publisherEnd);
    expect(publisher, contains('sendText(LED_SYNC_QUEUE_MARKER)'));
    expect(publisher, isNot(contains('sendDelta("LED_PHASE"')));
    expect(publisher, isNot(contains('sendDelta("LED_CYCLE_MS"')));
  });

  test('Full BLE sync sends atomic LED snapshot rather than two stale phase deltas', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    final start = source.indexOf('static void sendFullSync() {');
    final end = source.indexOf('static void sendHotsideTelemetry()', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final sync = source.substring(start, end);
    expect(sync, contains('publishLedAnimationSync()'));
    expect(sync, isNot(contains('sendDelta("LED_PHASE"')));
    expect(sync, isNot(contains('sendDelta("LED_CYCLE_MS"')));
  });

  test('BLE command writes require encryption and bonding', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
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
    expect(floatingMetricStatus('F', telemetry, AppLanguage.english), '--');
  });

  test('App waits for voltage telemetry and marks disconnected outputs unknown', () {
    final source = File('lib/main.dart').readAsStringSync();
    expect(source, contains("if (c.startsWith('VOLTAGE:')) return MapEntry('VOLTAGE', c.substring(8));"));
    expect(source, contains("case 'VOLTAGE':\n        return voltage.toUpperCase() == expected.toUpperCase();"));
    expect(source, contains('runtimeOutputsKnown = false;'));
    expect(source, contains("stateKnown ? JexText.of(value ? 'on' : 'off', lang) : JexText.of('off', lang)"));
    expect(source, contains('final displayedValue = stateKnown && value;'));
    expect(source, contains('alignment: displayedValue ? Alignment.centerRight : Alignment.centerLeft'));
  });

  test('manual Peltier lock cannot be bypassed by one threshold sample', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    final start = source.indexOf('static bool manualPeltierSafetyLatchBlocksPeltier() {');
    final end = source.indexOf('static bool safetyAllowsPeltier()', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final helper = source.substring(start, end);
    expect(helper, contains('return manualPeltierSafetyLatch;'));
    expect(helper, isNot(contains('return hotsideC >')));
    expect(source, contains('if (manualPeltierSafetyLatch && hotsideRearmStable)'));
  });

  test('BLE rediscovery stops polling when passive Auto Connect prerequisites are unavailable', () {
    final source = File('lib/main.dart').readAsStringSync();
    final start = source.indexOf('void _startDisconnectRediscovery()');
    final end = source.indexOf('void _handleBleDisconnected()', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final method = source.substring(start, end);

    final disabledGuard = method.indexOf('if (!appAutoConnectNotifier.value ||');
    expect(disabledGuard, greaterThanOrEqualTo(0));
    expect(
      method.indexOf('_cancelDisconnectRediscovery();', disabledGuard),
      greaterThan(disabledGuard),
    );

    final readinessGate = method.indexOf('if (!canAutoConnect(');
    expect(readinessGate, greaterThanOrEqualTo(0));
    expect(
      method.indexOf('_cancelDisconnectRediscovery();', readinessGate),
      greaterThan(readinessGate),
    );
    expect(method, contains('syncing ||'));
  });

  test('Cloud OTA timeout/disconnect remains ambiguous instead of showing rejection', () {
    final source = File('lib/main.dart').readAsStringSync();
    final start = source.indexOf('Future<void> _startCloudOta(');
    final end = source.indexOf('void _startOtaReconnectMonitor()', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final method = source.substring(start, end);

    final ambiguity = method.indexOf('if (ambiguousCloudOtaStart)');
    final rejectedNotice = method.indexOf("JexText.of('otaStartRejected'");
    expect(ambiguity, greaterThanOrEqualTo(0));
    expect(method, contains("_lastCommandAckReason == 'TIMEOUT'"));
    expect(method, contains("_lastCommandAckReason == 'DISCONNECTED'"));
    expect(method, contains('Waiting for device reconnection or OTA result.'));
    expect(rejectedNotice, greaterThan(ambiguity));

    final rollbackComment = method.indexOf(
      '// Roll back only a definite rejection while the BLE session is still up.',
      ambiguity,
    );
    expect(rollbackComment, greaterThan(ambiguity));
    final ambiguityBranch = method.substring(ambiguity, rollbackComment);
    expect(ambiguityBranch, isNot(contains('otaExpectedDisconnect = false;')));
    expect(ambiguityBranch, isNot(contains('otaRecoveryActive = false;')));
  });


  test('System LED indicators ignore RGB effect toggle but obey master brightness', () {
    final source = File('firmware/JEXFYZ-V6.9.ino').readAsStringSync();
    final voltageStart = source.indexOf('static void startVoltageIndicator() {');
    final voltageEnd = source.indexOf('static uint32_t ledAnimationCycleMs(', voltageStart);
    expect(voltageStart, greaterThanOrEqualTo(0));
    expect(voltageEnd, greaterThan(voltageStart));
    final voltageStartBody = source.substring(voltageStart, voltageEnd);
    expect(voltageStartBody, isNot(contains('if (!rgbOn)')));
    expect(voltageStartBody, contains('hardwareBrightness()'));

    final ledsStart = source.indexOf('static void processLeds() {');
    final ledsBody = source.substring(ledsStart);
    final voltagePriority = ledsBody.indexOf('if (voltageIndicatorActive)');
    final rgbOffGate = ledsBody.indexOf('if (!rgbOn)');
    expect(voltagePriority, greaterThanOrEqualTo(0));
    expect(rgbOffGate, greaterThan(voltagePriority));

    final litShowAll = RegExp(r'showAll\([^;\n]*,\s*255\)').allMatches(source);
    expect(litShowAll, isEmpty);
    expect(source, contains('showAll(ledOn ? indicatorColor : 0x000000, hardwareBrightness())'));
    expect(source, contains('showAll(ledOn ? adaptiveStateIndicatorColor : 0x000000, hardwareBrightness())'));
    expect(source, contains('analogReadMilliVolts(PIN_NTC)'));
  });

}
