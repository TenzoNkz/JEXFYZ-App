import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/home_notify.dart';

void main() {
  test('empty and NONE OTA events have no visible message', () {
    expect(localizedOtaResultNotice('', AppLanguage.english), isEmpty);
    expect(localizedOtaResultNotice(' NONE ', AppLanguage.indonesia), isEmpty);
  });

  test('OTA failure localizes safe fields and suppresses raw diagnostics', () {
    for (final language in AppLanguage.values) {
      final notice = localizedOtaResultNotice(
        'OTA_FAILED|MODE=ONLINE|STAGE=ONLINE_IMAGE_VALIDATE|CODE=17|ERROR=SECRET',
        language,
      );
      expect(
        notice,
        localizedOtaFailureSummary(
          language,
          mode: JexText.of('otaModeOnline', language),
          stage: JexText.of('otaStageOnlineImageValidate', language),
        ),
      );
      expect(notice, isNot(contains('SECRET')));
      expect(notice, isNot(contains('CODE=17')));
    }
  });

  test('unknown OTA stage uses the localized generic stage label', () {
    const language = AppLanguage.english;
    expect(
      localizedOtaResultNotice(
        'OTA_FAILED|MODE=OTA|STAGE=FUTURE_STAGE|CODE=5',
        language,
      ),
      localizedOtaFailureSummary(
        language,
        mode: 'OTA',
        stage: JexText.of('unknownOtaStage', language),
      ),
    );
  });

  test('up-to-date result accepts only safe version metadata', () {
    const language = AppLanguage.english;
    final expected =
        JexText.of('otaUpToDate', language) +
        ' • ' +
        JexText.of('otaModeOnline', language);
    expect(
      localizedOtaResultNotice(
        'OTA_UP_TO_DATE|MODE=ONLINE|VERSION=V2.5',
        language,
      ),
      expected + ' • V2.5',
    );
    expect(
      localizedOtaResultNotice(
        'OTA_UP_TO_DATE|MODE=ONLINE|VERSION=../../private',
        language,
      ),
      expected,
    );
  });

  test('success result localizes mode and filters malformed version', () {
    const language = AppLanguage.indonesia;
    expect(
      localizedOtaResultNotice(
        'OTA_SUCCESS|MODE=LOCAL|VERSION=V3.1+2',
        language,
      ),
      localizedOtaSuccessSummary(
        language,
        mode: JexText.of('otaModeLocal', language),
        version: 'V3.1+2',
      ),
    );
    expect(
      localizedOtaResultNotice(
        'OTA_SUCCESS|MODE=LOCAL|VERSION=<unsafe>',
        language,
      ),
      localizedOtaSuccessSummary(
        language,
        mode: JexText.of('otaModeLocal', language),
      ),
    );
  });

  test('progress result clamps percent and omits unknown stage', () {
    const language = AppLanguage.english;
    final progressBase = JexText.of(
      'otaProgress',
      language,
    ).replaceAll(RegExp(r'\s*•\s*$'), '');
    expect(
      localizedOtaResultNotice(
        'IN_PROGRESS|MODE=ONLINE|STAGE=UNKNOWN|PROGRESS=135',
        language,
      ),
      progressBase + ' • ' + JexText.of('otaModeOnline', language) + ' • 100%',
    );
    expect(
      localizedOtaResultNotice('IN_PROGRESS', language),
      JexText.of('otaInProgress', language),
    );
  });

  test('legacy OTA result tokens preserve existing localized behavior', () {
    expect(
      localizedOtaResultNotice('LOCAL_SUCCESS', AppLanguage.english),
      localizedOtaSuccessSummary(
        AppLanguage.english,
        mode: JexText.of('otaModeLocal', AppLanguage.english),
      ),
    );
    expect(
      localizedOtaResultNotice(
        'SUCCESS_FIRMWARE_REBOOTED',
        AppLanguage.indonesia,
      ),
      localizedOtaSuccessSummary(AppLanguage.indonesia),
    );
    expect(
      localizedOtaResultNotice('OTA_END_ERROR_42', AppLanguage.english),
      localizedOtaFailureSummary(AppLanguage.english),
    );
    expect(
      localizedOtaResultNotice(
        'UPLOAD_SIZE_MISMATCH_12_24',
        AppLanguage.english,
      ),
      formatOtaUploadSizeMismatch(
        'UPLOAD_SIZE_MISMATCH_12_24',
        AppLanguage.english,
      ),
    );
  });

  test(
    'unknown event identifiers remain generic rather than leaking tokens',
    () {
      expect(
        localizedOtaResultNotice(
          'UNRECOGNIZED_INTERNAL_EVENT',
          AppLanguage.english,
        ),
        JexText.of('deviceStatusUpdate', AppLanguage.english),
      );
      expect(
        localizedOtaResultNotice('Plain message', AppLanguage.english),
        'Plain message',
      );
    },
  );

  test('reset reasons remain localized and unknown values stay generic', () {
    expect(
      localizedResetReason('BROWNOUT', AppLanguage.english),
      JexText.of('resetBrownout', AppLanguage.english),
    );
    expect(
      localizedResetReason('PANIC', AppLanguage.english),
      JexText.of('resetPanic', AppLanguage.english),
    );
    expect(
      localizedResetReason('SOFTWARE', AppLanguage.english),
      JexText.of('resetSoftware', AppLanguage.english),
    );
    for (final reason in ['WDT', 'INT_WDT', 'TASK_WDT']) {
      expect(
        localizedResetReason(reason, AppLanguage.english),
        JexText.of('resetWatchdog', AppLanguage.english),
      );
    }
    expect(
      localizedResetReason('EXTERNAL', AppLanguage.english),
      JexText.of('resetExternal', AppLanguage.english),
    );
    expect(
      localizedResetReason('DEEPSLEEP', AppLanguage.indonesia),
      JexText.of('resetDeepSleep', AppLanguage.indonesia),
    );
    for (final reason in ['POWER_ON', 'POWERON']) {
      expect(
        localizedResetReason(reason, AppLanguage.indonesia),
        JexText.of('resetPowerOn', AppLanguage.indonesia),
      );
    }
    expect(
      localizedResetReason('FUTURE_RESET_TOKEN', AppLanguage.indonesia),
      JexText.of('deviceStatusUpdate', AppLanguage.indonesia),
    );
  });
}
