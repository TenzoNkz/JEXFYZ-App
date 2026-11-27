// AI-MEMORY / FILE CONTRACT
// Owns localized Home/OTA copy helpers and the stateless Home NOTIFY presentation card.
// It does not own BLE, session state, native channels, storage, or OTA transport.
// Physical state and safety are supplied by callers from authoritative device telemetry.

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart' show AppLanguage, JexText;
import 'jex_animated_glyph.dart';

String otaStageLocalizationKey(String stage) {
  const special = <String, String>{
    'ONLINE_IMAGE_VALIDATE': 'otaStageOnlineImageValidate',
  };
  return special[stage.trim().toUpperCase()] ?? '';
}
Map<String, String> _otaEventFields(String raw) {
  final fields = <String, String>{};
  for (final part in raw.split('|')) {
    final index = part.indexOf('=');
    if (index <= 0) continue;
    fields[part.substring(0, index).trim().toUpperCase()] = part
        .substring(index + 1)
        .trim();
  }
  return fields;
}

String _localizedOtaMode(String mode, AppLanguage language) {
  switch (mode.trim().toUpperCase()) {
    case 'LOCAL':
      return JexText.of('otaModeLocal', language);
    case 'ONLINE':
      return JexText.of('otaModeOnline', language);
    default:
      return 'OTA';
  }
}

String _localizedOtaStage(String stage, AppLanguage language) {
  final specialKey = otaStageLocalizationKey(stage);
  if (specialKey.isNotEmpty) return JexText.of(specialKey, language);
  const keyByStage = <String, String>{
    'LOCAL_FILE_CHECK': 'otaStageLocalFileCheck',
    'LOCAL_SIZE_CHECK': 'otaStageLocalSizeCheck',
    'LOCAL_UPDATE_BEGIN': 'otaStageLocalUpdateBegin',
    'LOCAL_RECEIVE': 'otaStageLocalReceive',
    'LOCAL_FLASH_WRITE': 'otaStageLocalFlashWrite',
    'LOCAL_SIZE_VERIFY': 'otaStageLocalSizeVerify',
    'LOCAL_IMAGE_VERIFY': 'otaStageLocalImageVerify',
    'LOCAL_BOOT_PARTITION': 'otaStageLocalBootPartition',
    'ONLINE_REQUEST': 'otaStageOnlineRequest',
    'ONLINE_VERSION_CHECK': 'otaStageOnlineVersionCheck',
    'ONLINE_UP_TO_DATE': 'otaStageOnlineUpToDate',
    'ONLINE_WIFI_CONNECT': 'otaStageOnlineWifiConnect',
    'ONLINE_WIFI_CONNECTED': 'otaStageOnlineWifiConnected',
    'ONLINE_WIFI_RETRY_2': 'otaStageOnlineWifiRetry2',
    'ONLINE_WIFI_RETRY_3': 'otaStageOnlineWifiRetry3',
    'ONLINE_WIFI_FAILED': 'otaStageOnlineWifiFailed',
    'ONLINE_GITHUB_CONNECT': 'otaStageOnlineGithubConnect',
    'ONLINE_GITHUB_CONNECTED': 'otaStageOnlineGithubConnected',
    'ONLINE_DOWNLOAD': 'otaStageOnlineDownload',
    'ONLINE_DOWNLOAD_COMPLETE': 'otaStageOnlineDownloadComplete',
    'ONLINE_FLASH_PREPARE': 'otaStageOnlineFlashPrepare',
    'ONLINE_FLASH_FINALIZE': 'otaStageOnlineFlashFinalize',
    'ONLINE_FLASH_SUCCESS': 'otaStageOnlineFlashSuccess',
  };
  final key = keyByStage[stage.trim().toUpperCase()] ?? 'unknownOtaStage';
  return JexText.of(key, language);
}

/// Formats frozen firmware OTA result envelopes for Home NOTIFY only.
///
/// Diagnostic fields are deliberately suppressed. This helper never reads transport
/// state, mutates an OTA session, or sends a firmware command.
String localizedOtaResultNotice(String value, AppLanguage language) {
  final raw = value.trim();
  if (raw.isEmpty || raw.toUpperCase() == 'NONE') return '';
  final upper = raw.toUpperCase();

  if (upper.startsWith('OTA_FAILED|')) {
    final fields = _otaEventFields(raw);
    return localizedOtaFailureSummary(
      language,
      mode: _localizedOtaMode(fields['MODE'] ?? 'OTA', language),
      stage: _localizedOtaStage(fields['STAGE'] ?? 'UNKNOWN', language),
    );
  }

  if (upper.startsWith('OTA_UP_TO_DATE|')) {
    final fields = _otaEventFields(raw);
    final mode = _localizedOtaMode(fields['MODE'] ?? 'OTA', language);
    final version = fields['VERSION'] ?? '';
    final details = <String>[JexText.of('otaUpToDate', language)];
    if (mode.toUpperCase() != 'OTA') details.add(mode);
    if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}
/// Concise, localized Home NOTIFY presentation for OTA outcomes.
/// Raw firmware error tokens/codes are intentionally excluded from user-facing copy.
String localizedOtaFailureSummary(
  AppLanguage language, {
  String? mode,
  String? stage,
}) {
  final base = JexText.of(
    'otaFailed',
    language,
  ).replaceFirst(RegExp(r'[.!]\s*$'), '');
  final details = <String>[base];
  final unknownStage = JexText.of('unknownOtaStage', language);
  for (final candidate in <String?>[mode, stage]) {
    final value = candidate?.trim() ?? '';
    if (value.isEmpty ||
        value.toUpperCase() == 'OTA' ||
        value == unknownStage) {
      continue;
    }
    details.add(value);
  }
  return details.join(' • ');
}

/// Successful OTA copy only includes validated, user-meaningful metadata.
String localizedOtaSuccessSummary(
  AppLanguage language, {
  String? mode,
  String? version,
}) {
  final base = JexText.of(
    'otaSuccessful',
    language,
  ).replaceFirst(RegExp(r'[.!]\s*$'), '');
  final details = <String>[base];
  final normalizedMode = mode?.trim() ?? '';
  if (normalizedMode.isNotEmpty && normalizedMode.toUpperCase() != 'OTA') {
    details.add(normalizedMode);
  }
  final normalizedVersion = version?.trim() ?? '';
  if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}$')
      .hasMatch(normalizedVersion)) {
    details.add(normalizedVersion);
  }
  return details.join(' • ');
}

String peltierRearmNotice(int hotLimit, AppLanguage language) {
  final target = JexText.formatNumber(hotLimit - 1, language);
  return JexText.phrase(
        'Peltier is locked for safety. Cool Hotside to ≤ ',
        'Peltier dikunci demi keselamatan. Turunkan suhu sisi panas hingga ≤ ',
        language,
      ) +
      target +
      ' °C' +
      JexText.phrase(', then try again.', ', lalu coba lagi.', language);
}

double? parseHomeTemperatureCelsius(String value) {
  final normalized = value
      .trim()
      .replaceFirst(RegExp(r'\s*°?\s*C$', caseSensitive: false), '')
      .trim()
      .replaceAll(',', '.');
  final temperature = double.tryParse(normalized);
  return temperature != null && temperature.isFinite ? temperature : null;
}

bool homeHotsideLimitReached(String temperature, {required int hotLimit}) {
  final value = parseHomeTemperatureCelsius(temperature);
  return value != null && value >= hotLimit;
}

String homeHotsideLimitNotice(
  String temperature, {
  required int hotLimit,
  required AppLanguage language,
}) {
  final value = parseHomeTemperatureCelsius(temperature);
  final current = value == null
      ? temperature.trim()
      : JexText.formatNumber(
          value,
          language,
          decimalDigits: 1,
          groupThousands: false,
        );
  return JexText.phrase(
        'Hotside limit reached: ',
        'Batas suhu sisi panas tercapai: ',
        language,
      ) +
      current +
      ' °C (' +
      JexText.phrase('limit ', 'batas ', language) +
      JexText.formatNumber(hotLimit, language) +
      ' °C).';
}

bool isActiveHomeSafetyReason(String reason) {
  // Only persistent protection/fault states override a newer ordinary event.
  // Operational reasons such as ADAPTIVE_ACTIVE, VOLTAGE_TRANSITION and FAN_REQUIRED
  // are events/status explanations, not indefinitely active safety latches.
  const priorityReasons = <String>{
    'HOTSIDE_PROTECTION',
    'PELTIER_SAFETY_LATCH',
    'NTC_ERROR',
    'VOLTAGE_FORCE_FAILED',
  };
  return priorityReasons.contains(reason.trim().toUpperCase());
}

String homeFanSpeedChangedNotice(
  int previousSpeed,
  int currentSpeed, {
  required AppLanguage language,
}) {
  if (currentSpeed < previousSpeed) {
    return JexText.phrase(
          'Fan speed reduced to ',
          'Kecepatan kipas diturunkan ke ',
          language,
        ) +
        currentSpeed.toString() +
        '%.';
  }
  if (currentSpeed > previousSpeed) {
    return JexText.phrase(
          'Fan speed increased to ',
          'Kecepatan kipas dinaikkan ke ',
          language,
        ) +
        currentSpeed.toString() +
        '%.';
  }
  return JexText.phrase(
        'Fan speed set to ',
        'Kecepatan kipas diatur ke ',
        language,
      ) +
      currentSpeed.toString() +
      '%.';
}

/// Format Firmware upload-size mismatch events with received/expected values in fixed order.
/// Returns null for malformed events so the existing generic fallback remains available.
String? formatOtaUploadSizeMismatch(String event, AppLanguage language) {
  final match = RegExp(
    r'^UPLOAD_SIZE_MISMATCH_(\d+)_(\d+)$',
    caseSensitive: false,
  ).firstMatch(event.trim());
  if (match == null) return null;
  return JexText.format('otaSizeMismatchDetailed', {
    'receivedBytes': JexText.formatNumber(int.parse(match.group(1)!), language),
    'expectedBytes': JexText.formatNumber(int.parse(match.group(2)!), language),
  }, language);
}

/// One telemetry transition becomes one localized sentence; values never accumulate.
String? homeNotifyForTelemetryChange({
  required String key,
  required String previousValue,
  required String currentValue,
  required AppLanguage language,
}) {
  if (previousValue == currentValue) return null;
  switch (key) {
    case 'VOLTAGE':
      return JexText.phrase(
            'Voltage set to ',
            'Tegangan diatur ke ',
            language,
          ) +
          currentValue +
          '.';
    case 'FAN':
      return JexText.of(currentValue == 'ON' ? 'fanOn' : 'fanOff', language);
    case 'PELTIER':
      return JexText.of(
        currentValue == 'ON' ? 'peltierOn' : 'peltierOff',
        language,
      );
    case 'ADAPTIVE':
      return JexText.of(
        currentValue == 'ON' ? 'adaptiveOn' : 'adaptiveOff',
        language,
      );
    case 'SAFETY':
      if (currentValue.trim().toUpperCase() == 'OK') {
        return JexText.phrase(
          'Safety checks passed.',
          'Pemeriksaan keselamatan berhasil.',
          language,
        );
      }
      return JexText.phrase(
        'Safety protection active.',
        'Proteksi keselamatan aktif.',
        language,
      );
    case 'FAN_SPEED':
      final before = int.tryParse(previousValue);
      final after = int.tryParse(currentValue);
      if (before == null || after == null || before == after) return null;
      return homeFanSpeedChangedNotice(before, after, language: language);
    case 'RGB':
      return JexText.of(currentValue == 'ON' ? 'ledOn' : 'ledOff', language);
    case 'MODE':
    case 'LED_SYNC':
      return JexText.of('modeUpdated', language);
    case 'BRIGHTNESS':
      return JexText.phrase(
            'LED brightness set to ',
            'Kecerahan LED diatur ke ',
            language,
          ) +
          currentValue +
          '%.';
    case 'RGB_COLOR':
      return JexText.of('colorUpdated', language);
    case 'ADAPTIVE_PROFILE':
      final profile = currentValue.trim().toUpperCase() == 'BATTERY'
          ? JexText.phrase('Battery', 'Baterai', language)
          : JexText.phrase('Hotside', 'Sisi Panas', language);
      return JexText.phrase(
            'Adaptive profile set to ',
            'Profil Adaptif diatur ke ',
            language,
          ) +
          profile +
          '.';
    case 'ADAPTIVE_CEILING':
      final ceiling = currentValue.trim().toUpperCase();
      return JexText.phrase(
            'Adaptive voltage ceiling set to ',
            'Batas tegangan Adaptif diatur ke ',
            language,
          ) +
          ceiling +
          '.';
    default:
      // HOT/BATTERY temperature samples do not generate ordinary notices.
      return null;
  }
}

String relocalizeHomeNotifyMessage(String message, AppLanguage language) {
  final raw = message.trim();
  if (raw.isEmpty) return raw;

  final segments = raw.split(' • ').map((part) => part.trim()).toList();
  final lead = segments.isEmpty ? '' : segments.first;
  final leadLower = lead.toLowerCase();
  if (leadLower == 'firmware update completed' ||
      leadLower == 'pembaruan firmware selesai') {
    var mode = '';
    var version = '';
    for (final part in segments.skip(1)) {
      if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}$').hasMatch(part) &&
          RegExp(r'\d').hasMatch(part)) {
        version = part;
      } else if (part.toUpperCase() != 'OTA') {
        mode = JexText.relocalize(part, language);
      }
    }
    return localizedOtaSuccessSummary(language, mode: mode, version: version);
  }
  if (leadLower == 'firmware update failed' ||
      leadLower == 'pembaruan firmware gagal') {
    var mode = '';
    var stage = '';
    for (final part in segments.skip(1)) {
      final normalized = part.toLowerCase();
      final isMode = const <String>{
        'online',
        'local',
        'daring',
        'lokal',
      }.contains(normalized);
      if (isMode && mode.isEmpty) {
        mode = JexText.relocalize(part, language);
      } else if (part.toUpperCase() != 'OTA') {
        stage = JexText.relocalize(part, language);
      }
    }
    return localizedOtaFailureSummary(language, mode: mode, stage: stage);
  }

  final fanSpeedChange = RegExp(
    r'^(?:Fan speed (reduced|increased|set) to|Kecepatan kipas (diturunkan ke|dinaikkan ke|diatur ke))\s*(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (fanSpeedChange != null) {
    final englishAction = fanSpeedChange.group(1)?.toLowerCase();
    final indonesiaAction = fanSpeedChange.group(2)?.toLowerCase();
    final speed = fanSpeedChange.group(3)!;
    if (englishAction == 'reduced' || indonesiaAction == 'diturunkan ke') {
      return JexText.phrase(
            'Fan speed reduced to ',
            'Kecepatan kipas diturunkan ke ',
            language,
          ) +
          speed +
          '%.';
    }
    if (englishAction == 'increased' || indonesiaAction == 'dinaikkan ke') {
      return JexText.phrase(
            'Fan speed increased to ',
            'Kecepatan kipas dinaikkan ke ',
            language,
          ) +
          speed +
          '%.';
    }
    return JexText.phrase(
          'Fan speed set to ',
          'Kecepatan kipas diatur ke ',
          language,
        ) +
        speed +
        '%.';
  }

  final ledBrightness = RegExp(
    r'^(?:LED brightness set to|Kecerahan LED diatur ke)\s*(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (ledBrightness != null) {
    return JexText.phrase(
          'LED brightness set to ',
          'Kecerahan LED diatur ke ',
          language,
        ) +
        ledBrightness.group(1)! +
        '%.';
  }

  final hotsideReached = RegExp(
    r'^(?:Hotside limit reached:|Batas suhu (?:Hotside|Sisi panas) tercapai:)\s*(\d+(?:[.,]\d+)?)\s*°?\s*C\s*\((?:limit|batas)\s*(\d+)\s*°?\s*C\)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (hotsideReached != null) {
    return homeHotsideLimitNotice(
      hotsideReached.group(1)!,
      hotLimit: int.parse(hotsideReached.group(2)!),
      language: language,
    );
  }

  final adaptiveProfile = RegExp(
    r'^(?:Adaptive profile set to|Profil Adaptif diatur ke)\s*(Battery|Baterai|Hotside|Sisi panas)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (adaptiveProfile != null) {
    final rawProfile = adaptiveProfile.group(1)!.toLowerCase();
    final isBattery = rawProfile == 'battery' || rawProfile == 'baterai';
    return JexText.phrase(
          'Adaptive profile set to ',
          'Profil Adaptif diatur ke ',
          language,
        ) +
        JexText.phrase(
          isBattery ? 'Battery' : 'Hotside',
          isBattery ? 'Baterai' : 'Sisi Panas',
          language,
        ) +
        '.';
  }

  final voltage = RegExp(
    r'^(?:Voltage set to|Tegangan diatur ke)\s+([^\s.!?]+)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (voltage != null) {
    return JexText.phrase('Voltage set to ', 'Tegangan diatur ke ', language) +
        voltage.group(1)! +
        '.';
  }

  final fanSpeed = RegExp(
    r'^(?:Fan speed set to|Kecepatan kipas diatur ke)\s+(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (fanSpeed != null) {
    return JexText.phrase(
          'Fan speed set to ',
          'Kecepatan kipas diatur ke ',
          language,
        ) +
        fanSpeed.group(1)! +
        '%.';
  }

  final hotsideLimit = RegExp(
    r'^(?:Hotside temperature limit set to|Batas suhu (?:Hotside|Sisi panas) diatur ke)\s+(\d+)\s*°?\s*C\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (hotsideLimit != null) {
    return JexText.phrase(
          'Hotside temperature limit set to ',
          'Batas suhu sisi panas diatur ke ',
          language,
        ) +
        JexText.formatNumber(int.parse(hotsideLimit.group(1)!), language) +
        ' °C.';
  }

  if (raw == '5V battery limit updated.' ||
      raw == 'Batas baterai 5V diperbarui.') {
    return JexText.phrase(
      '5V battery limit updated.',
      'Batas baterai 5V diperbarui.',
      language,
    );
  }
  if (raw == '12V battery limit updated.' ||
      raw == 'Batas baterai 12V diperbarui.') {
    return JexText.phrase(
      '12V battery limit updated.',
      'Batas baterai 12V diperbarui.',
      language,
    );
  }

  final rearm = RegExp(
    r'^(?:Peltier is locked for safety\. Cool (?:Hotside|the hot side) to ≤|Peltier dikunci demi keselamatan\. Turunkan suhu (?:Hotside|sisi panas) hingga ≤)\s*(\d+)\s*°?\s*C,?\s*(?:then try again|lalu coba lagi)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (rearm != null) {
    return peltierRearmNotice(int.parse(rearm.group(1)!) + 1, language);
  }

  return JexText.relocalize(raw, language);
}

const Set<String> _jexKnownNotifyReasonCodes = <String>{
  'NTC_ERROR',
  'HOTSIDE_PROTECTION',
  'PELTIER_SAFETY_LATCH',
  'VOLTAGE_STEP_FAILED',
  'VOLTAGE_FORCE_FAILED',
  'ADAPTIVE_RECOVERY_WAIT',
  'ADAPTIVE_RISE_WAIT',
  'ADAPTIVE_STARTING',
  'FAN_REQUIRED',
  'PELTIER_ON',
  'ADAPTIVE_ACTIVE',
  'MANUAL_12V_ONLY',
  'VOLTAGE_TRANSITION',
  'VOLTAGE_GUARD_OR_BUSY',
  'VOLTAGE_LOCKED',
  'NVS_SAVE_FAILED',
  'SYNC_REQUIRED',
  'RATE_LIMIT',
  'RANGE_50_100_STEP_10',
  'MUST_BE_BELOW_BATT12',
  'MUST_BE_ABOVE_BATT5',
  'UNKNOWN_GROUP',
  'WAITING_FOR_NTC',
  'WAITING_FOR_SENSOR_VALIDATION',
  'DISCONNECTED',
  'NONE',
};

/// Translate firmware/internal reason identifiers into concise UI text. Unknown codes
/// deliberately fall back to a generic status message; raw codes remain diagnostic-only.
String localizedNotifyReason(
  String reason, {
  required int hotLimit,
  required AppLanguage language,
}) {
  switch (reason.trim().toUpperCase()) {
    case 'PELTIER_SAFETY_LATCH':
    case 'HOTSIDE_PROTECTION':
      return peltierRearmNotice(hotLimit, language);
    case 'NTC_ERROR':
      return JexText.phrase(
        'Temperature sensor fault. Peltier is disabled for safety.',
        'Sensor suhu bermasalah. Peltier dinonaktifkan demi keselamatan.',
        language,
      );
    case 'VOLTAGE_STEP_FAILED':
      return JexText.phrase(
        'Adaptive Mode could not complete the voltage change.',
        'Mode Adaptif tidak dapat menyelesaikan perubahan tegangan.',
        language,
      );
    case 'VOLTAGE_FORCE_FAILED':
      return JexText.phrase(
        'Safety protection could not set 5V. Check the device.',
        'Proteksi keselamatan gagal mengatur 5V. Periksa perangkat.',
        language,
      );
    case 'ADAPTIVE_RECOVERY_WAIT':
      return JexText.phrase(
        'Adaptive Mode is waiting for voltage recovery to stabilize.',
        'Mode Adaptif menunggu hingga pemulihan tegangan stabil.',
        language,
      );
    case 'ADAPTIVE_RISE_WAIT':
      return JexText.phrase(
        'Adaptive Mode is waiting before increasing voltage.',
        'Mode Adaptif menunggu sebelum menaikkan tegangan.',
        language,
      );
    case 'ADAPTIVE_STARTING':
      return JexText.phrase(
        'Adaptive Mode is starting.',
        'Mode Adaptif sedang dimulai.',
        language,
      );
    case 'FAN_REQUIRED':
      return JexText.phrase(
        'Turn on the fan before enabling Peltier.',
        'Nyalakan kipas sebelum mengaktifkan Peltier.',
        language,
      );
    case 'PELTIER_ON':
      return JexText.phrase(
        'Fan controls are locked while Peltier is active.',
        'Kontrol kipas dikunci saat Peltier aktif.',
        language,
      );
    case 'ADAPTIVE_ACTIVE':
      return JexText.phrase(
        'Manual cooling controls are unavailable in Adaptive Mode.',
        'Kontrol pendinginan manual tidak tersedia saat Mode Adaptif aktif.',
        language,
      );
    case 'MANUAL_12V_ONLY':
      return JexText.phrase(
        'Fan speed adjustment requires 12V in Manual Mode.',
        'Kecepatan kipas hanya dapat diatur pada 12V dalam Mode Manual.',
        language,
      );
    case 'VOLTAGE_TRANSITION':
      return JexText.phrase(
        'Voltage change in progress. Please wait.',
        'Perubahan tegangan berlangsung. Tunggu sebentar.',
        language,
      );
    case 'VOLTAGE_LOCKED':
      return JexText.phrase(
        'Voltage is locked to 5V. Turn off Lock Voltage in Settings to change it.',
        'Tegangan terkunci di 5V. Matikan Kunci Tegangan di Pengaturan untuk mengubahnya.',
        language,
      );
    case 'NVS_SAVE_FAILED':
      return JexText.phrase(
        'Lock is active for this session, but the device could not save it. Retry the setting.',
        'Kunci aktif untuk sesi ini, tetapi perangkat gagal menyimpannya. Coba ulang pengaturan.',
        language,
      );
    case 'VOLTAGE_GUARD_OR_BUSY':
      return JexText.phrase(
        'Voltage control is busy. Try again shortly.',
        'Kontrol tegangan sedang sibuk. Coba lagi sebentar.',
        language,
      );
    case 'SYNC_REQUIRED':
      return JexText.phrase(
        'Device synchronization is in progress.',
        'Sinkronisasi perangkat sedang berlangsung.',
        language,
      );
    case 'RATE_LIMIT':
      return JexText.phrase(
        'Please wait before sending another command.',
        'Tunggu sebentar sebelum mengirim perintah berikutnya.',
        language,
      );
    case 'RANGE_50_100_STEP_10':
      return JexText.phrase(
        'Fan speed must be 50–100% in 10% steps.',
        'Kecepatan kipas harus 50–100% dengan kelipatan 10%.',
        language,
      );
    case 'MUST_BE_BELOW_BATT12':
      return JexText.phrase(
        'The 5V battery limit must be lower than the 12V limit.',
        'Batas baterai 5V harus lebih rendah daripada batas 12V.',
        language,
      );
    case 'MUST_BE_ABOVE_BATT5':
      return JexText.phrase(
        'The 12V battery limit must be higher than the 5V limit.',
        'Batas baterai 12V harus lebih tinggi daripada batas 5V.',
        language,
      );
    case 'UNKNOWN_GROUP':
      return JexText.phrase(
        'This reset request is not supported.',
        'Permintaan reset ini tidak didukung.',
        language,
      );
    case 'WAITING_FOR_NTC':
    case 'WAITING_FOR_SENSOR_VALIDATION':
      return JexText.phrase(
        'Checking temperature sensors.',
        'Memeriksa sensor suhu.',
        language,
      );
    case 'DISCONNECTED':
      return JexText.of('bluetoothDisconnected', language);
    case 'NONE':
      return JexText.of('systemReady', language);
    default:
      return JexText.phrase(
        'Device status needs attention. Check the connection and try again.',
        'Status perangkat perlu diperiksa. Periksa koneksi, lalu coba lagi.',
        language,
      );
  }
}

/// Normalize the Home STATUS body in the currently selected UI language.
/// Known safety codes become useful instructions; unknown identifiers are never shown.
String normalizeHomeNotifyText(
  String message, {
  required int hotLimit,
  required AppLanguage language,
}) {
  var raw = message.trim();
  if (raw.isEmpty) return '';

  // OTA event envelopes have their own parser and must reach it unchanged.
  if (RegExp(
    r'^OTA_(?:SUCCESS|FAILED|UP_TO_DATE)\|',
    caseSensitive: false,
  ).hasMatch(raw)) {
    return raw;
  }

  // Interpret only a terminal underscore token as a reason. This avoids matching ordinary
  // words such as "none" inside readable prose.
  final suffixCode = RegExp(
    r'(?:^|\s)([A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+)\s*$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (suffixCode != null) {
    final code = suffixCode.group(1)!.toUpperCase();
    if (_jexKnownNotifyReasonCodes.contains(code)) {
      return localizedNotifyReason(
        code,
        hotLimit: hotLimit,
        language: language,
      );
    }
    raw = raw.substring(0, suffixCode.start).trim();
  }

  const genericIssue = 'Check the device connection, then try again.';
  const genericIssueId = 'Periksa koneksi perangkat, lalu coba lagi.';
  if (raw.isEmpty)
    return JexText.phrase(genericIssue, genericIssueId, language);

  final lower = raw.toLowerCase();
  final confirmationFailed = <String>[
    'did not confirm',
    'was not confirmed',
    'not confirmed',
    'could not confirm',
    'belum mengonfirmasi',
    'tidak mengonfirmasi',
    'belum terkonfirmasi',
    'tidak terkonfirmasi',
    'tidak dikonfirmasi',
  ].any(lower.contains);
  final commandFailed = <String>[
    'command failed',
    'change failed',
    'settings failed',
    'failed.',
    ' gagal',
    'tidak berhasil',
  ].any(lower.contains);

  if (lower.contains('temperature sensor fault') ||
      lower.contains('temperature sensor error') ||
      lower.contains('sensor suhu bermasalah')) {
    return JexText.phrase(
      'Temperature sensor fault. Peltier is disabled for safety.',
      'Sensor suhu bermasalah. Peltier dinonaktifkan demi keselamatan.',
      language,
    );
  }

  if (confirmationFailed || commandFailed) {
    final fanSpeedIssue =
        lower.contains('fan speed') ||
        lower.contains('fan-speed') ||
        lower.contains('kecepatan kipas');
    final peltierIssue = lower.contains('peltier');
    final adaptiveIssue =
        lower.contains('adaptive') || lower.contains('mode adaptif');
    final voltageIssue =
        lower.contains('voltage') || lower.contains('tegangan');
    final fanIssue = lower.contains('fan') || lower.contains('kipas');
    final brightnessIssue =
        lower.contains('brightness') || lower.contains('kecerahan');
    final colorIssue =
        lower.contains('color') ||
        lower.contains('colour') ||
        lower.contains('warna');
    final ledIssue = lower.contains('led') || lower.contains('rgb');
    final modeIssue = lower.contains('mode');
    final temperatureIssue =
        lower.contains('temperature') ||
        lower.contains('suhu') ||
        lower.contains('hotlimit');

    if (peltierIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'The device did not confirm the Peltier change. Check the safety status.',
              'Perangkat belum mengonfirmasi perubahan Peltier. Periksa status keselamatan.',
              language,
            )
          : JexText.phrase(
              'Peltier change failed. Check safety status.',
              'Perubahan Peltier gagal. Periksa status keselamatan.',
              language,
            );
    }
    if (voltageIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Voltage change not confirmed. Check device status.',
              'Perubahan tegangan belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Voltage change failed. Check device status.',
              'Perubahan tegangan gagal. Periksa status perangkat.',
              language,
            );
    }
    if (adaptiveIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Adaptive Mode change was not confirmed. Check device status.',
              'Perubahan Mode Adaptif belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Adaptive Mode change failed. Check device status.',
              'Perubahan Mode Adaptif gagal. Periksa status perangkat.',
              language,
            );
    }
    if (fanSpeedIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Fan speed not confirmed. Check device status.',
              'Kecepatan kipas belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Fan speed change failed. Check device status.',
              'Perubahan kecepatan kipas gagal. Periksa status perangkat.',
              language,
            );
    }
    if (fanIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Fan change not confirmed. Check device status.',
              'Perubahan kipas belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Fan change failed. Check device status.',
              'Perubahan kipas gagal. Periksa status perangkat.',
              language,
            );
    }
    if (brightnessIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Brightness change not confirmed. Check device status.',
              'Perubahan kecerahan belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Brightness change failed. Check device status.',
              'Perubahan kecerahan gagal. Periksa status perangkat.',
              language,
            );
    }
    if (colorIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Color change not confirmed. Check device status.',
              'Perubahan warna belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Color change failed. Check device status.',
              'Perubahan warna gagal. Periksa status perangkat.',
              language,
            );
    }
    if (ledIssue || modeIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'LED change not confirmed. Check device status.',
              'Perubahan LED belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'LED change failed. Check device status.',
              'Perubahan LED gagal. Periksa status perangkat.',
              language,
            );
    }
    if (temperatureIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Temperature settings not confirmed. Check device status.',
              'Pengaturan suhu belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Temperature settings failed. Check device status.',
              'Pengaturan suhu gagal. Periksa status perangkat.',
              language,
            );
    }
    return confirmationFailed
        ? JexText.phrase(
            'Command not confirmed. Check device status.',
            'Perintah belum terkonfirmasi. Periksa status perangkat.',
            language,
          )
        : JexText.phrase(
            'Action failed. Check device status and try again.',
            'Tindakan gagal. Periksa status perangkat, lalu coba lagi.',
            language,
          );
  }

  raw = raw
      .replaceAll(RegExp(r'\b[A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+\b'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (raw.isEmpty)
    return JexText.phrase(genericIssue, genericIssueId, language);
  return raw;
}

/// Returns true when a live, healthy firmware update can clear a stale Home NOTIFY error.
/// Computes the Home Fan Speed presentation from authoritative runtime state.
String homeFanSpeedDisplay({
  required bool connected,
  required bool fanOn,
  required String voltage,
  required bool adaptiveOn,
  required int fanSpeed,
  required String offLabel,
}) {
  if (!connected) return '--';
  if (!fanOn) return offLabel;
  if (voltage == '5V' || voltage == '9V') return '100%';
  // At 12 V, show authoritative live PWM in both Manual and Adaptive.
  if (voltage == '12V') return '$fanSpeed%';
  return '--';
}

String homeNotifyConnectionLabel({
  required String notice,
  required bool isConnecting,
  required bool isSyncing,
  required bool connected,
  required AppLanguage language,
}) {
  final custom = notice.trim().toUpperCase();
  if (custom.contains('FAILED') ||
      custom.contains('ERROR') ||
      custom.contains('NOT FOUND') ||
      custom.contains('SERVICE DISCOVERY') ||
      custom.contains('DID NOT CONFIRM') ||
      custom.contains('NOT CONFIRMED') ||
      custom.contains('UNCONFIRMED') ||
      custom.contains('BELUM MENGONFIRMASI') ||
      custom.contains('TIDAK MENGONFIRMASI') ||
      custom.contains('BELUM TERKONFIRMASI') ||
      custom.contains('TIDAK TERKONFIRMASI') ||
      custom.contains('TIDAK DIKONFIRMASI') ||
      custom.contains('GAGAL') ||
      custom.contains('KESALAHAN')) {
    return JexText.of('error', language);
  }
  if (isConnecting) return JexText.of('connecting', language);
  if (isSyncing) return JexText.of('syncing', language);
  return JexText.of(connected ? 'connected' : 'disconnected', language);
}

bool shouldClearStaleNotifyError({
  required bool connected,
  required String safety,
  required String safetyReason,
  required bool liveTelemetryReceived,
  required String notice,
}) {
  if (!connected || !liveTelemetryReceived) return false;

  final safe =
      safety.trim().toUpperCase() == 'OK' &&
      safetyReason.trim().toUpperCase() == 'NONE';
  if (!safe) return false;

  final upper = notice.trim().toUpperCase();
  if (upper.isEmpty || upper.contains('OTA') || upper.contains('FIRMWARE')) {
    return false;
  }

  return upper.contains('PELTIER IS LOCKED') ||
      upper.contains('PELTIER TERKUNCI') ||
      upper.contains('NOT CONFIRMED') ||
      upper.contains('COMMAND FAILED') ||
      upper.contains('FAILED') ||
      upper.contains('ERROR') ||
      upper.contains('TIDAK DIKONFIRMASI') ||
      upper.contains('GAGAL') ||
      upper.contains('KESALAHAN');
}

/// Fixed-height Home notification presentation.
/// Dashboard supplies all status, safety, localization and contrast decisions;
/// this widget only renders those values and never reads device/session state.
class HomeNotifyCard extends StatelessWidget {
  final bool darkTheme;
  final bool hasError;
  final bool warning;
  final bool connected;
  final Color foregroundColor;
  final String label;
  final String message;

  const HomeNotifyCard({
    super.key,
    required this.darkTheme,
    required this.hasError,
    required this.warning,
    required this.connected,
    required this.foregroundColor,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final noticeTextColor = darkTheme
        ? const Color(0xFFF4F6FA)
        : const Color(0xFF16181D);
    final alert = hasError || warning;
    final icon = hasError
        ? PhosphorIconsBold.xCircle
        : alert
        ? PhosphorIconsBold.warning
        : !connected
        ? PhosphorIconsRegular.info
        : PhosphorIconsRegular.shieldCheck;
    final color = hasError
        ? const Color(0xFFFF5164)
        : alert
        ? const Color(0xFFFFB72B)
        : !connected
        ? const Color(0xFF7C8797)
        : const Color(0xFF4DE7B7);

    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: darkTheme
            ? color.withValues(alpha: hasError ? .12 : .07)
            : color.withValues(alpha: hasError ? .11 : .08),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: darkTheme
              ? color.withValues(alpha: .25)
              : foregroundColor.withValues(alpha: .28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 34,
            child: Center(
              child: JexAnimatedGlyph(
                icon: icon,
                size: 27,
                color: foregroundColor,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bodyStyle = TextStyle(
                        color: noticeTextColor,
                        fontSize: 10.5,
                        decoration: TextDecoration.none,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      );
                      TextPainter measure(double fontSize) => TextPainter(
                        text: TextSpan(
                          text: message,
                          style: bodyStyle.copyWith(fontSize: fontSize),
                        ),
                        textDirection: Directionality.of(context),
                        maxLines: 2,
                        ellipsis: '…',
                      )..layout(maxWidth: constraints.maxWidth);

                      final wraps =
                          measure(10.5).computeLineMetrics().length > 1;
                      final fontSize = wraps ? 9.5 : 10.5;
                      // Keep NOTIFY readable. Longer copy is ellipsized to two lines,
                      // never reduced to microtype to force the full message into 44 dp.
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          message,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: bodyStyle.copyWith(fontSize: fontSize),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
).hasMatch(version)) {
      details.add(version);
    }
    return details.join(' • ');
  }

  if (upper.startsWith('OTA_SUCCESS|')) {
    final fields = _otaEventFields(raw);
    return localizedOtaSuccessSummary(
      language,
      mode: _localizedOtaMode(fields['MODE'] ?? 'OTA', language),
      version: fields['VERSION'] ?? '',
    );
  }

  if (upper.startsWith('IN_PROGRESS|')) {
    final fields = _otaEventFields(raw);
    final mode = _localizedOtaMode(fields['MODE'] ?? 'OTA', language);
    final stage = _localizedOtaStage(fields['STAGE'] ?? 'UNKNOWN', language);
    final progress = int.tryParse(fields['PROGRESS'] ?? '')?.clamp(0, 100);
    final details = <String>[
      JexText.of('otaProgress', language).replaceAll(RegExp(r'\s*•\s*
/// Concise, localized Home NOTIFY presentation for OTA outcomes.
/// Raw firmware error tokens/codes are intentionally excluded from user-facing copy.
String localizedOtaFailureSummary(
  AppLanguage language, {
  String? mode,
  String? stage,
}) {
  final base = JexText.of(
    'otaFailed',
    language,
  ).replaceFirst(RegExp(r'[.!]\s*$'), '');
  final details = <String>[base];
  final unknownStage = JexText.of('unknownOtaStage', language);
  for (final candidate in <String?>[mode, stage]) {
    final value = candidate?.trim() ?? '';
    if (value.isEmpty ||
        value.toUpperCase() == 'OTA' ||
        value == unknownStage) {
      continue;
    }
    details.add(value);
  }
  return details.join(' • ');
}

/// Successful OTA copy only includes validated, user-meaningful metadata.
String localizedOtaSuccessSummary(
  AppLanguage language, {
  String? mode,
  String? version,
}) {
  final base = JexText.of(
    'otaSuccessful',
    language,
  ).replaceFirst(RegExp(r'[.!]\s*$'), '');
  final details = <String>[base];
  final normalizedMode = mode?.trim() ?? '';
  if (normalizedMode.isNotEmpty && normalizedMode.toUpperCase() != 'OTA') {
    details.add(normalizedMode);
  }
  final normalizedVersion = version?.trim() ?? '';
  if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}$')
      .hasMatch(normalizedVersion)) {
    details.add(normalizedVersion);
  }
  return details.join(' • ');
}

String peltierRearmNotice(int hotLimit, AppLanguage language) {
  final target = JexText.formatNumber(hotLimit - 1, language);
  return JexText.phrase(
        'Peltier is locked for safety. Cool Hotside to ≤ ',
        'Peltier dikunci demi keselamatan. Turunkan suhu sisi panas hingga ≤ ',
        language,
      ) +
      target +
      ' °C' +
      JexText.phrase(', then try again.', ', lalu coba lagi.', language);
}

double? parseHomeTemperatureCelsius(String value) {
  final normalized = value
      .trim()
      .replaceFirst(RegExp(r'\s*°?\s*C$', caseSensitive: false), '')
      .trim()
      .replaceAll(',', '.');
  final temperature = double.tryParse(normalized);
  return temperature != null && temperature.isFinite ? temperature : null;
}

bool homeHotsideLimitReached(String temperature, {required int hotLimit}) {
  final value = parseHomeTemperatureCelsius(temperature);
  return value != null && value >= hotLimit;
}

String homeHotsideLimitNotice(
  String temperature, {
  required int hotLimit,
  required AppLanguage language,
}) {
  final value = parseHomeTemperatureCelsius(temperature);
  final current = value == null
      ? temperature.trim()
      : JexText.formatNumber(
          value,
          language,
          decimalDigits: 1,
          groupThousands: false,
        );
  return JexText.phrase(
        'Hotside limit reached: ',
        'Batas suhu sisi panas tercapai: ',
        language,
      ) +
      current +
      ' °C (' +
      JexText.phrase('limit ', 'batas ', language) +
      JexText.formatNumber(hotLimit, language) +
      ' °C).';
}

bool isActiveHomeSafetyReason(String reason) {
  // Only persistent protection/fault states override a newer ordinary event.
  // Operational reasons such as ADAPTIVE_ACTIVE, VOLTAGE_TRANSITION and FAN_REQUIRED
  // are events/status explanations, not indefinitely active safety latches.
  const priorityReasons = <String>{
    'HOTSIDE_PROTECTION',
    'PELTIER_SAFETY_LATCH',
    'NTC_ERROR',
    'VOLTAGE_FORCE_FAILED',
  };
  return priorityReasons.contains(reason.trim().toUpperCase());
}

String homeFanSpeedChangedNotice(
  int previousSpeed,
  int currentSpeed, {
  required AppLanguage language,
}) {
  if (currentSpeed < previousSpeed) {
    return JexText.phrase(
          'Fan speed reduced to ',
          'Kecepatan kipas diturunkan ke ',
          language,
        ) +
        currentSpeed.toString() +
        '%.';
  }
  if (currentSpeed > previousSpeed) {
    return JexText.phrase(
          'Fan speed increased to ',
          'Kecepatan kipas dinaikkan ke ',
          language,
        ) +
        currentSpeed.toString() +
        '%.';
  }
  return JexText.phrase(
        'Fan speed set to ',
        'Kecepatan kipas diatur ke ',
        language,
      ) +
      currentSpeed.toString() +
      '%.';
}

/// Format Firmware upload-size mismatch events with received/expected values in fixed order.
/// Returns null for malformed events so the existing generic fallback remains available.
String? formatOtaUploadSizeMismatch(String event, AppLanguage language) {
  final match = RegExp(
    r'^UPLOAD_SIZE_MISMATCH_(\d+)_(\d+)$',
    caseSensitive: false,
  ).firstMatch(event.trim());
  if (match == null) return null;
  return JexText.format('otaSizeMismatchDetailed', {
    'receivedBytes': JexText.formatNumber(int.parse(match.group(1)!), language),
    'expectedBytes': JexText.formatNumber(int.parse(match.group(2)!), language),
  }, language);
}

/// One telemetry transition becomes one localized sentence; values never accumulate.
String? homeNotifyForTelemetryChange({
  required String key,
  required String previousValue,
  required String currentValue,
  required AppLanguage language,
}) {
  if (previousValue == currentValue) return null;
  switch (key) {
    case 'VOLTAGE':
      return JexText.phrase(
            'Voltage set to ',
            'Tegangan diatur ke ',
            language,
          ) +
          currentValue +
          '.';
    case 'FAN':
      return JexText.of(currentValue == 'ON' ? 'fanOn' : 'fanOff', language);
    case 'PELTIER':
      return JexText.of(
        currentValue == 'ON' ? 'peltierOn' : 'peltierOff',
        language,
      );
    case 'ADAPTIVE':
      return JexText.of(
        currentValue == 'ON' ? 'adaptiveOn' : 'adaptiveOff',
        language,
      );
    case 'SAFETY':
      if (currentValue.trim().toUpperCase() == 'OK') {
        return JexText.phrase(
          'Safety checks passed.',
          'Pemeriksaan keselamatan berhasil.',
          language,
        );
      }
      return JexText.phrase(
        'Safety protection active.',
        'Proteksi keselamatan aktif.',
        language,
      );
    case 'FAN_SPEED':
      final before = int.tryParse(previousValue);
      final after = int.tryParse(currentValue);
      if (before == null || after == null || before == after) return null;
      return homeFanSpeedChangedNotice(before, after, language: language);
    case 'RGB':
      return JexText.of(currentValue == 'ON' ? 'ledOn' : 'ledOff', language);
    case 'MODE':
    case 'LED_SYNC':
      return JexText.of('modeUpdated', language);
    case 'BRIGHTNESS':
      return JexText.phrase(
            'LED brightness set to ',
            'Kecerahan LED diatur ke ',
            language,
          ) +
          currentValue +
          '%.';
    case 'RGB_COLOR':
      return JexText.of('colorUpdated', language);
    case 'ADAPTIVE_PROFILE':
      final profile = currentValue.trim().toUpperCase() == 'BATTERY'
          ? JexText.phrase('Battery', 'Baterai', language)
          : JexText.phrase('Hotside', 'Sisi Panas', language);
      return JexText.phrase(
            'Adaptive profile set to ',
            'Profil Adaptif diatur ke ',
            language,
          ) +
          profile +
          '.';
    case 'ADAPTIVE_CEILING':
      final ceiling = currentValue.trim().toUpperCase();
      return JexText.phrase(
            'Adaptive voltage ceiling set to ',
            'Batas tegangan Adaptif diatur ke ',
            language,
          ) +
          ceiling +
          '.';
    default:
      // HOT/BATTERY temperature samples do not generate ordinary notices.
      return null;
  }
}

String relocalizeHomeNotifyMessage(String message, AppLanguage language) {
  final raw = message.trim();
  if (raw.isEmpty) return raw;

  final segments = raw.split(' • ').map((part) => part.trim()).toList();
  final lead = segments.isEmpty ? '' : segments.first;
  final leadLower = lead.toLowerCase();
  if (leadLower == 'firmware update completed' ||
      leadLower == 'pembaruan firmware selesai') {
    var mode = '';
    var version = '';
    for (final part in segments.skip(1)) {
      if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}$').hasMatch(part) &&
          RegExp(r'\d').hasMatch(part)) {
        version = part;
      } else if (part.toUpperCase() != 'OTA') {
        mode = JexText.relocalize(part, language);
      }
    }
    return localizedOtaSuccessSummary(language, mode: mode, version: version);
  }
  if (leadLower == 'firmware update failed' ||
      leadLower == 'pembaruan firmware gagal') {
    var mode = '';
    var stage = '';
    for (final part in segments.skip(1)) {
      final normalized = part.toLowerCase();
      final isMode = const <String>{
        'online',
        'local',
        'daring',
        'lokal',
      }.contains(normalized);
      if (isMode && mode.isEmpty) {
        mode = JexText.relocalize(part, language);
      } else if (part.toUpperCase() != 'OTA') {
        stage = JexText.relocalize(part, language);
      }
    }
    return localizedOtaFailureSummary(language, mode: mode, stage: stage);
  }

  final fanSpeedChange = RegExp(
    r'^(?:Fan speed (reduced|increased|set) to|Kecepatan kipas (diturunkan ke|dinaikkan ke|diatur ke))\s*(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (fanSpeedChange != null) {
    final englishAction = fanSpeedChange.group(1)?.toLowerCase();
    final indonesiaAction = fanSpeedChange.group(2)?.toLowerCase();
    final speed = fanSpeedChange.group(3)!;
    if (englishAction == 'reduced' || indonesiaAction == 'diturunkan ke') {
      return JexText.phrase(
            'Fan speed reduced to ',
            'Kecepatan kipas diturunkan ke ',
            language,
          ) +
          speed +
          '%.';
    }
    if (englishAction == 'increased' || indonesiaAction == 'dinaikkan ke') {
      return JexText.phrase(
            'Fan speed increased to ',
            'Kecepatan kipas dinaikkan ke ',
            language,
          ) +
          speed +
          '%.';
    }
    return JexText.phrase(
          'Fan speed set to ',
          'Kecepatan kipas diatur ke ',
          language,
        ) +
        speed +
        '%.';
  }

  final ledBrightness = RegExp(
    r'^(?:LED brightness set to|Kecerahan LED diatur ke)\s*(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (ledBrightness != null) {
    return JexText.phrase(
          'LED brightness set to ',
          'Kecerahan LED diatur ke ',
          language,
        ) +
        ledBrightness.group(1)! +
        '%.';
  }

  final hotsideReached = RegExp(
    r'^(?:Hotside limit reached:|Batas suhu (?:Hotside|Sisi panas) tercapai:)\s*(\d+(?:[.,]\d+)?)\s*°?\s*C\s*\((?:limit|batas)\s*(\d+)\s*°?\s*C\)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (hotsideReached != null) {
    return homeHotsideLimitNotice(
      hotsideReached.group(1)!,
      hotLimit: int.parse(hotsideReached.group(2)!),
      language: language,
    );
  }

  final adaptiveProfile = RegExp(
    r'^(?:Adaptive profile set to|Profil Adaptif diatur ke)\s*(Battery|Baterai|Hotside|Sisi panas)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (adaptiveProfile != null) {
    final rawProfile = adaptiveProfile.group(1)!.toLowerCase();
    final isBattery = rawProfile == 'battery' || rawProfile == 'baterai';
    return JexText.phrase(
          'Adaptive profile set to ',
          'Profil Adaptif diatur ke ',
          language,
        ) +
        JexText.phrase(
          isBattery ? 'Battery' : 'Hotside',
          isBattery ? 'Baterai' : 'Sisi Panas',
          language,
        ) +
        '.';
  }

  final voltage = RegExp(
    r'^(?:Voltage set to|Tegangan diatur ke)\s+([^\s.!?]+)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (voltage != null) {
    return JexText.phrase('Voltage set to ', 'Tegangan diatur ke ', language) +
        voltage.group(1)! +
        '.';
  }

  final fanSpeed = RegExp(
    r'^(?:Fan speed set to|Kecepatan kipas diatur ke)\s+(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (fanSpeed != null) {
    return JexText.phrase(
          'Fan speed set to ',
          'Kecepatan kipas diatur ke ',
          language,
        ) +
        fanSpeed.group(1)! +
        '%.';
  }

  final hotsideLimit = RegExp(
    r'^(?:Hotside temperature limit set to|Batas suhu (?:Hotside|Sisi panas) diatur ke)\s+(\d+)\s*°?\s*C\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (hotsideLimit != null) {
    return JexText.phrase(
          'Hotside temperature limit set to ',
          'Batas suhu sisi panas diatur ke ',
          language,
        ) +
        JexText.formatNumber(int.parse(hotsideLimit.group(1)!), language) +
        ' °C.';
  }

  if (raw == '5V battery limit updated.' ||
      raw == 'Batas baterai 5V diperbarui.') {
    return JexText.phrase(
      '5V battery limit updated.',
      'Batas baterai 5V diperbarui.',
      language,
    );
  }
  if (raw == '12V battery limit updated.' ||
      raw == 'Batas baterai 12V diperbarui.') {
    return JexText.phrase(
      '12V battery limit updated.',
      'Batas baterai 12V diperbarui.',
      language,
    );
  }

  final rearm = RegExp(
    r'^(?:Peltier is locked for safety\. Cool (?:Hotside|the hot side) to ≤|Peltier dikunci demi keselamatan\. Turunkan suhu (?:Hotside|sisi panas) hingga ≤)\s*(\d+)\s*°?\s*C,?\s*(?:then try again|lalu coba lagi)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (rearm != null) {
    return peltierRearmNotice(int.parse(rearm.group(1)!) + 1, language);
  }

  return JexText.relocalize(raw, language);
}

const Set<String> _jexKnownNotifyReasonCodes = <String>{
  'NTC_ERROR',
  'HOTSIDE_PROTECTION',
  'PELTIER_SAFETY_LATCH',
  'VOLTAGE_STEP_FAILED',
  'VOLTAGE_FORCE_FAILED',
  'ADAPTIVE_RECOVERY_WAIT',
  'ADAPTIVE_RISE_WAIT',
  'ADAPTIVE_STARTING',
  'FAN_REQUIRED',
  'PELTIER_ON',
  'ADAPTIVE_ACTIVE',
  'MANUAL_12V_ONLY',
  'VOLTAGE_TRANSITION',
  'VOLTAGE_GUARD_OR_BUSY',
  'VOLTAGE_LOCKED',
  'NVS_SAVE_FAILED',
  'SYNC_REQUIRED',
  'RATE_LIMIT',
  'RANGE_50_100_STEP_10',
  'MUST_BE_BELOW_BATT12',
  'MUST_BE_ABOVE_BATT5',
  'UNKNOWN_GROUP',
  'WAITING_FOR_NTC',
  'WAITING_FOR_SENSOR_VALIDATION',
  'DISCONNECTED',
  'NONE',
};

/// Translate firmware/internal reason identifiers into concise UI text. Unknown codes
/// deliberately fall back to a generic status message; raw codes remain diagnostic-only.
String localizedNotifyReason(
  String reason, {
  required int hotLimit,
  required AppLanguage language,
}) {
  switch (reason.trim().toUpperCase()) {
    case 'PELTIER_SAFETY_LATCH':
    case 'HOTSIDE_PROTECTION':
      return peltierRearmNotice(hotLimit, language);
    case 'NTC_ERROR':
      return JexText.phrase(
        'Temperature sensor fault. Peltier is disabled for safety.',
        'Sensor suhu bermasalah. Peltier dinonaktifkan demi keselamatan.',
        language,
      );
    case 'VOLTAGE_STEP_FAILED':
      return JexText.phrase(
        'Adaptive Mode could not complete the voltage change.',
        'Mode Adaptif tidak dapat menyelesaikan perubahan tegangan.',
        language,
      );
    case 'VOLTAGE_FORCE_FAILED':
      return JexText.phrase(
        'Safety protection could not set 5V. Check the device.',
        'Proteksi keselamatan gagal mengatur 5V. Periksa perangkat.',
        language,
      );
    case 'ADAPTIVE_RECOVERY_WAIT':
      return JexText.phrase(
        'Adaptive Mode is waiting for voltage recovery to stabilize.',
        'Mode Adaptif menunggu hingga pemulihan tegangan stabil.',
        language,
      );
    case 'ADAPTIVE_RISE_WAIT':
      return JexText.phrase(
        'Adaptive Mode is waiting before increasing voltage.',
        'Mode Adaptif menunggu sebelum menaikkan tegangan.',
        language,
      );
    case 'ADAPTIVE_STARTING':
      return JexText.phrase(
        'Adaptive Mode is starting.',
        'Mode Adaptif sedang dimulai.',
        language,
      );
    case 'FAN_REQUIRED':
      return JexText.phrase(
        'Turn on the fan before enabling Peltier.',
        'Nyalakan kipas sebelum mengaktifkan Peltier.',
        language,
      );
    case 'PELTIER_ON':
      return JexText.phrase(
        'Fan controls are locked while Peltier is active.',
        'Kontrol kipas dikunci saat Peltier aktif.',
        language,
      );
    case 'ADAPTIVE_ACTIVE':
      return JexText.phrase(
        'Manual cooling controls are unavailable in Adaptive Mode.',
        'Kontrol pendinginan manual tidak tersedia saat Mode Adaptif aktif.',
        language,
      );
    case 'MANUAL_12V_ONLY':
      return JexText.phrase(
        'Fan speed adjustment requires 12V in Manual Mode.',
        'Kecepatan kipas hanya dapat diatur pada 12V dalam Mode Manual.',
        language,
      );
    case 'VOLTAGE_TRANSITION':
      return JexText.phrase(
        'Voltage change in progress. Please wait.',
        'Perubahan tegangan berlangsung. Tunggu sebentar.',
        language,
      );
    case 'VOLTAGE_LOCKED':
      return JexText.phrase(
        'Voltage is locked to 5V. Turn off Lock Voltage in Settings to change it.',
        'Tegangan terkunci di 5V. Matikan Kunci Tegangan di Pengaturan untuk mengubahnya.',
        language,
      );
    case 'NVS_SAVE_FAILED':
      return JexText.phrase(
        'Lock is active for this session, but the device could not save it. Retry the setting.',
        'Kunci aktif untuk sesi ini, tetapi perangkat gagal menyimpannya. Coba ulang pengaturan.',
        language,
      );
    case 'VOLTAGE_GUARD_OR_BUSY':
      return JexText.phrase(
        'Voltage control is busy. Try again shortly.',
        'Kontrol tegangan sedang sibuk. Coba lagi sebentar.',
        language,
      );
    case 'SYNC_REQUIRED':
      return JexText.phrase(
        'Device synchronization is in progress.',
        'Sinkronisasi perangkat sedang berlangsung.',
        language,
      );
    case 'RATE_LIMIT':
      return JexText.phrase(
        'Please wait before sending another command.',
        'Tunggu sebentar sebelum mengirim perintah berikutnya.',
        language,
      );
    case 'RANGE_50_100_STEP_10':
      return JexText.phrase(
        'Fan speed must be 50–100% in 10% steps.',
        'Kecepatan kipas harus 50–100% dengan kelipatan 10%.',
        language,
      );
    case 'MUST_BE_BELOW_BATT12':
      return JexText.phrase(
        'The 5V battery limit must be lower than the 12V limit.',
        'Batas baterai 5V harus lebih rendah daripada batas 12V.',
        language,
      );
    case 'MUST_BE_ABOVE_BATT5':
      return JexText.phrase(
        'The 12V battery limit must be higher than the 5V limit.',
        'Batas baterai 12V harus lebih tinggi daripada batas 5V.',
        language,
      );
    case 'UNKNOWN_GROUP':
      return JexText.phrase(
        'This reset request is not supported.',
        'Permintaan reset ini tidak didukung.',
        language,
      );
    case 'WAITING_FOR_NTC':
    case 'WAITING_FOR_SENSOR_VALIDATION':
      return JexText.phrase(
        'Checking temperature sensors.',
        'Memeriksa sensor suhu.',
        language,
      );
    case 'DISCONNECTED':
      return JexText.of('bluetoothDisconnected', language);
    case 'NONE':
      return JexText.of('systemReady', language);
    default:
      return JexText.phrase(
        'Device status needs attention. Check the connection and try again.',
        'Status perangkat perlu diperiksa. Periksa koneksi, lalu coba lagi.',
        language,
      );
  }
}

/// Normalize the Home STATUS body in the currently selected UI language.
/// Known safety codes become useful instructions; unknown identifiers are never shown.
String normalizeHomeNotifyText(
  String message, {
  required int hotLimit,
  required AppLanguage language,
}) {
  var raw = message.trim();
  if (raw.isEmpty) return '';

  // OTA event envelopes have their own parser and must reach it unchanged.
  if (RegExp(
    r'^OTA_(?:SUCCESS|FAILED|UP_TO_DATE)\|',
    caseSensitive: false,
  ).hasMatch(raw)) {
    return raw;
  }

  // Interpret only a terminal underscore token as a reason. This avoids matching ordinary
  // words such as "none" inside readable prose.
  final suffixCode = RegExp(
    r'(?:^|\s)([A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+)\s*$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (suffixCode != null) {
    final code = suffixCode.group(1)!.toUpperCase();
    if (_jexKnownNotifyReasonCodes.contains(code)) {
      return localizedNotifyReason(
        code,
        hotLimit: hotLimit,
        language: language,
      );
    }
    raw = raw.substring(0, suffixCode.start).trim();
  }

  const genericIssue = 'Check the device connection, then try again.';
  const genericIssueId = 'Periksa koneksi perangkat, lalu coba lagi.';
  if (raw.isEmpty)
    return JexText.phrase(genericIssue, genericIssueId, language);

  final lower = raw.toLowerCase();
  final confirmationFailed = <String>[
    'did not confirm',
    'was not confirmed',
    'not confirmed',
    'could not confirm',
    'belum mengonfirmasi',
    'tidak mengonfirmasi',
    'belum terkonfirmasi',
    'tidak terkonfirmasi',
    'tidak dikonfirmasi',
  ].any(lower.contains);
  final commandFailed = <String>[
    'command failed',
    'change failed',
    'settings failed',
    'failed.',
    ' gagal',
    'tidak berhasil',
  ].any(lower.contains);

  if (lower.contains('temperature sensor fault') ||
      lower.contains('temperature sensor error') ||
      lower.contains('sensor suhu bermasalah')) {
    return JexText.phrase(
      'Temperature sensor fault. Peltier is disabled for safety.',
      'Sensor suhu bermasalah. Peltier dinonaktifkan demi keselamatan.',
      language,
    );
  }

  if (confirmationFailed || commandFailed) {
    final fanSpeedIssue =
        lower.contains('fan speed') ||
        lower.contains('fan-speed') ||
        lower.contains('kecepatan kipas');
    final peltierIssue = lower.contains('peltier');
    final adaptiveIssue =
        lower.contains('adaptive') || lower.contains('mode adaptif');
    final voltageIssue =
        lower.contains('voltage') || lower.contains('tegangan');
    final fanIssue = lower.contains('fan') || lower.contains('kipas');
    final brightnessIssue =
        lower.contains('brightness') || lower.contains('kecerahan');
    final colorIssue =
        lower.contains('color') ||
        lower.contains('colour') ||
        lower.contains('warna');
    final ledIssue = lower.contains('led') || lower.contains('rgb');
    final modeIssue = lower.contains('mode');
    final temperatureIssue =
        lower.contains('temperature') ||
        lower.contains('suhu') ||
        lower.contains('hotlimit');

    if (peltierIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'The device did not confirm the Peltier change. Check the safety status.',
              'Perangkat belum mengonfirmasi perubahan Peltier. Periksa status keselamatan.',
              language,
            )
          : JexText.phrase(
              'Peltier change failed. Check safety status.',
              'Perubahan Peltier gagal. Periksa status keselamatan.',
              language,
            );
    }
    if (voltageIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Voltage change not confirmed. Check device status.',
              'Perubahan tegangan belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Voltage change failed. Check device status.',
              'Perubahan tegangan gagal. Periksa status perangkat.',
              language,
            );
    }
    if (adaptiveIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Adaptive Mode change was not confirmed. Check device status.',
              'Perubahan Mode Adaptif belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Adaptive Mode change failed. Check device status.',
              'Perubahan Mode Adaptif gagal. Periksa status perangkat.',
              language,
            );
    }
    if (fanSpeedIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Fan speed not confirmed. Check device status.',
              'Kecepatan kipas belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Fan speed change failed. Check device status.',
              'Perubahan kecepatan kipas gagal. Periksa status perangkat.',
              language,
            );
    }
    if (fanIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Fan change not confirmed. Check device status.',
              'Perubahan kipas belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Fan change failed. Check device status.',
              'Perubahan kipas gagal. Periksa status perangkat.',
              language,
            );
    }
    if (brightnessIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Brightness change not confirmed. Check device status.',
              'Perubahan kecerahan belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Brightness change failed. Check device status.',
              'Perubahan kecerahan gagal. Periksa status perangkat.',
              language,
            );
    }
    if (colorIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Color change not confirmed. Check device status.',
              'Perubahan warna belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Color change failed. Check device status.',
              'Perubahan warna gagal. Periksa status perangkat.',
              language,
            );
    }
    if (ledIssue || modeIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'LED change not confirmed. Check device status.',
              'Perubahan LED belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'LED change failed. Check device status.',
              'Perubahan LED gagal. Periksa status perangkat.',
              language,
            );
    }
    if (temperatureIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Temperature settings not confirmed. Check device status.',
              'Pengaturan suhu belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Temperature settings failed. Check device status.',
              'Pengaturan suhu gagal. Periksa status perangkat.',
              language,
            );
    }
    return confirmationFailed
        ? JexText.phrase(
            'Command not confirmed. Check device status.',
            'Perintah belum terkonfirmasi. Periksa status perangkat.',
            language,
          )
        : JexText.phrase(
            'Action failed. Check device status and try again.',
            'Tindakan gagal. Periksa status perangkat, lalu coba lagi.',
            language,
          );
  }

  raw = raw
      .replaceAll(RegExp(r'\b[A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+\b'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (raw.isEmpty)
    return JexText.phrase(genericIssue, genericIssueId, language);
  return raw;
}

/// Returns true when a live, healthy firmware update can clear a stale Home NOTIFY error.
/// Computes the Home Fan Speed presentation from authoritative runtime state.
String homeFanSpeedDisplay({
  required bool connected,
  required bool fanOn,
  required String voltage,
  required bool adaptiveOn,
  required int fanSpeed,
  required String offLabel,
}) {
  if (!connected) return '--';
  if (!fanOn) return offLabel;
  if (voltage == '5V' || voltage == '9V') return '100%';
  // At 12 V, show authoritative live PWM in both Manual and Adaptive.
  if (voltage == '12V') return '$fanSpeed%';
  return '--';
}

String homeNotifyConnectionLabel({
  required String notice,
  required bool isConnecting,
  required bool isSyncing,
  required bool connected,
  required AppLanguage language,
}) {
  final custom = notice.trim().toUpperCase();
  if (custom.contains('FAILED') ||
      custom.contains('ERROR') ||
      custom.contains('NOT FOUND') ||
      custom.contains('SERVICE DISCOVERY') ||
      custom.contains('DID NOT CONFIRM') ||
      custom.contains('NOT CONFIRMED') ||
      custom.contains('UNCONFIRMED') ||
      custom.contains('BELUM MENGONFIRMASI') ||
      custom.contains('TIDAK MENGONFIRMASI') ||
      custom.contains('BELUM TERKONFIRMASI') ||
      custom.contains('TIDAK TERKONFIRMASI') ||
      custom.contains('TIDAK DIKONFIRMASI') ||
      custom.contains('GAGAL') ||
      custom.contains('KESALAHAN')) {
    return JexText.of('error', language);
  }
  if (isConnecting) return JexText.of('connecting', language);
  if (isSyncing) return JexText.of('syncing', language);
  return JexText.of(connected ? 'connected' : 'disconnected', language);
}

bool shouldClearStaleNotifyError({
  required bool connected,
  required String safety,
  required String safetyReason,
  required bool liveTelemetryReceived,
  required String notice,
}) {
  if (!connected || !liveTelemetryReceived) return false;

  final safe =
      safety.trim().toUpperCase() == 'OK' &&
      safetyReason.trim().toUpperCase() == 'NONE';
  if (!safe) return false;

  final upper = notice.trim().toUpperCase();
  if (upper.isEmpty || upper.contains('OTA') || upper.contains('FIRMWARE')) {
    return false;
  }

  return upper.contains('PELTIER IS LOCKED') ||
      upper.contains('PELTIER TERKUNCI') ||
      upper.contains('NOT CONFIRMED') ||
      upper.contains('COMMAND FAILED') ||
      upper.contains('FAILED') ||
      upper.contains('ERROR') ||
      upper.contains('TIDAK DIKONFIRMASI') ||
      upper.contains('GAGAL') ||
      upper.contains('KESALAHAN');
}

/// Fixed-height Home notification presentation.
/// Dashboard supplies all status, safety, localization and contrast decisions;
/// this widget only renders those values and never reads device/session state.
class HomeNotifyCard extends StatelessWidget {
  final bool darkTheme;
  final bool hasError;
  final bool warning;
  final bool connected;
  final Color foregroundColor;
  final String label;
  final String message;

  const HomeNotifyCard({
    super.key,
    required this.darkTheme,
    required this.hasError,
    required this.warning,
    required this.connected,
    required this.foregroundColor,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final noticeTextColor = darkTheme
        ? const Color(0xFFF4F6FA)
        : const Color(0xFF16181D);
    final alert = hasError || warning;
    final icon = hasError
        ? PhosphorIconsBold.xCircle
        : alert
        ? PhosphorIconsBold.warning
        : !connected
        ? PhosphorIconsRegular.info
        : PhosphorIconsRegular.shieldCheck;
    final color = hasError
        ? const Color(0xFFFF5164)
        : alert
        ? const Color(0xFFFFB72B)
        : !connected
        ? const Color(0xFF7C8797)
        : const Color(0xFF4DE7B7);

    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: darkTheme
            ? color.withValues(alpha: hasError ? .12 : .07)
            : color.withValues(alpha: hasError ? .11 : .08),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: darkTheme
              ? color.withValues(alpha: .25)
              : foregroundColor.withValues(alpha: .28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 34,
            child: Center(
              child: JexAnimatedGlyph(
                icon: icon,
                size: 27,
                color: foregroundColor,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bodyStyle = TextStyle(
                        color: noticeTextColor,
                        fontSize: 10.5,
                        decoration: TextDecoration.none,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      );
                      TextPainter measure(double fontSize) => TextPainter(
                        text: TextSpan(
                          text: message,
                          style: bodyStyle.copyWith(fontSize: fontSize),
                        ),
                        textDirection: Directionality.of(context),
                        maxLines: 2,
                        ellipsis: '…',
                      )..layout(maxWidth: constraints.maxWidth);

                      final wraps =
                          measure(10.5).computeLineMetrics().length > 1;
                      final fontSize = wraps ? 9.5 : 10.5;
                      // Keep NOTIFY readable. Longer copy is ellipsized to two lines,
                      // never reduced to microtype to force the full message into 44 dp.
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          message,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: bodyStyle.copyWith(fontSize: fontSize),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
), ''),
    ];
    if (mode.toUpperCase() != 'OTA') details.add(mode);
    if (stage != JexText.of('unknownOtaStage', language)) details.add(stage);
    if (progress != null) details.add('$progress%');
    return details.join(' • ');
  }

  if (upper == 'IN_PROGRESS') return JexText.of('otaInProgress', language);
  if (upper == 'LOCAL_SUCCESS') {
    return localizedOtaSuccessSummary(
      language,
      mode: JexText.of('otaModeLocal', language),
    );
  }
  if (upper.startsWith('SUCCESS_')) {
    // The suffix is an internal event identifier, not user-facing copy.
    return localizedOtaSuccessSummary(language);
  }
  if (upper.startsWith('UPLOAD_SIZE_MISMATCH_')) {
    return formatOtaUploadSizeMismatch(raw, language) ??
        JexText.of('otaSizeMismatch', language);
  }
  if (upper.startsWith('OTA_END_ERROR_')) {
    // Detailed suffixes belong in internal diagnostics, not the Home status card.
    return localizedOtaFailureSummary(language);
  }
  if (upper.contains('FAILED') || upper.contains('ERROR')) {
    return localizedOtaFailureSummary(language);
  }
  return raw.contains('_') ? JexText.of('deviceStatusUpdate', language) : raw;
}

/// Localized reset-cause copy for the user-facing Home NOTIFY surface.
String localizedResetReason(String value, AppLanguage language) {
  switch (value) {
    case 'BROWNOUT':
      return JexText.of('resetBrownout', language);
    case 'PANIC':
      return JexText.of('resetPanic', language);
    case 'SOFTWARE':
      return JexText.of('resetSoftware', language);
    case 'WDT':
    case 'INT_WDT':
    case 'TASK_WDT':
      return JexText.of('resetWatchdog', language);
    case 'EXTERNAL':
      return JexText.of('resetExternal', language);
    case 'DEEPSLEEP':
      return JexText.of('resetDeepSleep', language);
    case 'POWER_ON':
    case 'POWERON':
      return JexText.of('resetPowerOn', language);
    default:
      return JexText.of('deviceStatusUpdate', language);
  }
}


/// Concise, localized Home NOTIFY presentation for OTA outcomes.
/// Raw firmware error tokens/codes are intentionally excluded from user-facing copy.
String localizedOtaFailureSummary(
  AppLanguage language, {
  String? mode,
  String? stage,
}) {
  final base = JexText.of(
    'otaFailed',
    language,
  ).replaceFirst(RegExp(r'[.!]\s*$'), '');
  final details = <String>[base];
  final unknownStage = JexText.of('unknownOtaStage', language);
  for (final candidate in <String?>[mode, stage]) {
    final value = candidate?.trim() ?? '';
    if (value.isEmpty ||
        value.toUpperCase() == 'OTA' ||
        value == unknownStage) {
      continue;
    }
    details.add(value);
  }
  return details.join(' • ');
}

/// Successful OTA copy only includes validated, user-meaningful metadata.
String localizedOtaSuccessSummary(
  AppLanguage language, {
  String? mode,
  String? version,
}) {
  final base = JexText.of(
    'otaSuccessful',
    language,
  ).replaceFirst(RegExp(r'[.!]\s*$'), '');
  final details = <String>[base];
  final normalizedMode = mode?.trim() ?? '';
  if (normalizedMode.isNotEmpty && normalizedMode.toUpperCase() != 'OTA') {
    details.add(normalizedMode);
  }
  final normalizedVersion = version?.trim() ?? '';
  if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}$')
      .hasMatch(normalizedVersion)) {
    details.add(normalizedVersion);
  }
  return details.join(' • ');
}

String peltierRearmNotice(int hotLimit, AppLanguage language) {
  final target = JexText.formatNumber(hotLimit - 1, language);
  return JexText.phrase(
        'Peltier is locked for safety. Cool Hotside to ≤ ',
        'Peltier dikunci demi keselamatan. Turunkan suhu sisi panas hingga ≤ ',
        language,
      ) +
      target +
      ' °C' +
      JexText.phrase(', then try again.', ', lalu coba lagi.', language);
}

double? parseHomeTemperatureCelsius(String value) {
  final normalized = value
      .trim()
      .replaceFirst(RegExp(r'\s*°?\s*C$', caseSensitive: false), '')
      .trim()
      .replaceAll(',', '.');
  final temperature = double.tryParse(normalized);
  return temperature != null && temperature.isFinite ? temperature : null;
}

bool homeHotsideLimitReached(String temperature, {required int hotLimit}) {
  final value = parseHomeTemperatureCelsius(temperature);
  return value != null && value >= hotLimit;
}

String homeHotsideLimitNotice(
  String temperature, {
  required int hotLimit,
  required AppLanguage language,
}) {
  final value = parseHomeTemperatureCelsius(temperature);
  final current = value == null
      ? temperature.trim()
      : JexText.formatNumber(
          value,
          language,
          decimalDigits: 1,
          groupThousands: false,
        );
  return JexText.phrase(
        'Hotside limit reached: ',
        'Batas suhu sisi panas tercapai: ',
        language,
      ) +
      current +
      ' °C (' +
      JexText.phrase('limit ', 'batas ', language) +
      JexText.formatNumber(hotLimit, language) +
      ' °C).';
}

bool isActiveHomeSafetyReason(String reason) {
  // Only persistent protection/fault states override a newer ordinary event.
  // Operational reasons such as ADAPTIVE_ACTIVE, VOLTAGE_TRANSITION and FAN_REQUIRED
  // are events/status explanations, not indefinitely active safety latches.
  const priorityReasons = <String>{
    'HOTSIDE_PROTECTION',
    'PELTIER_SAFETY_LATCH',
    'NTC_ERROR',
    'VOLTAGE_FORCE_FAILED',
  };
  return priorityReasons.contains(reason.trim().toUpperCase());
}

String homeFanSpeedChangedNotice(
  int previousSpeed,
  int currentSpeed, {
  required AppLanguage language,
}) {
  if (currentSpeed < previousSpeed) {
    return JexText.phrase(
          'Fan speed reduced to ',
          'Kecepatan kipas diturunkan ke ',
          language,
        ) +
        currentSpeed.toString() +
        '%.';
  }
  if (currentSpeed > previousSpeed) {
    return JexText.phrase(
          'Fan speed increased to ',
          'Kecepatan kipas dinaikkan ke ',
          language,
        ) +
        currentSpeed.toString() +
        '%.';
  }
  return JexText.phrase(
        'Fan speed set to ',
        'Kecepatan kipas diatur ke ',
        language,
      ) +
      currentSpeed.toString() +
      '%.';
}

/// Format Firmware upload-size mismatch events with received/expected values in fixed order.
/// Returns null for malformed events so the existing generic fallback remains available.
String? formatOtaUploadSizeMismatch(String event, AppLanguage language) {
  final match = RegExp(
    r'^UPLOAD_SIZE_MISMATCH_(\d+)_(\d+)$',
    caseSensitive: false,
  ).firstMatch(event.trim());
  if (match == null) return null;
  return JexText.format('otaSizeMismatchDetailed', {
    'receivedBytes': JexText.formatNumber(int.parse(match.group(1)!), language),
    'expectedBytes': JexText.formatNumber(int.parse(match.group(2)!), language),
  }, language);
}

/// One telemetry transition becomes one localized sentence; values never accumulate.
String? homeNotifyForTelemetryChange({
  required String key,
  required String previousValue,
  required String currentValue,
  required AppLanguage language,
}) {
  if (previousValue == currentValue) return null;
  switch (key) {
    case 'VOLTAGE':
      return JexText.phrase(
            'Voltage set to ',
            'Tegangan diatur ke ',
            language,
          ) +
          currentValue +
          '.';
    case 'FAN':
      return JexText.of(currentValue == 'ON' ? 'fanOn' : 'fanOff', language);
    case 'PELTIER':
      return JexText.of(
        currentValue == 'ON' ? 'peltierOn' : 'peltierOff',
        language,
      );
    case 'ADAPTIVE':
      return JexText.of(
        currentValue == 'ON' ? 'adaptiveOn' : 'adaptiveOff',
        language,
      );
    case 'SAFETY':
      if (currentValue.trim().toUpperCase() == 'OK') {
        return JexText.phrase(
          'Safety checks passed.',
          'Pemeriksaan keselamatan berhasil.',
          language,
        );
      }
      return JexText.phrase(
        'Safety protection active.',
        'Proteksi keselamatan aktif.',
        language,
      );
    case 'FAN_SPEED':
      final before = int.tryParse(previousValue);
      final after = int.tryParse(currentValue);
      if (before == null || after == null || before == after) return null;
      return homeFanSpeedChangedNotice(before, after, language: language);
    case 'RGB':
      return JexText.of(currentValue == 'ON' ? 'ledOn' : 'ledOff', language);
    case 'MODE':
    case 'LED_SYNC':
      return JexText.of('modeUpdated', language);
    case 'BRIGHTNESS':
      return JexText.phrase(
            'LED brightness set to ',
            'Kecerahan LED diatur ke ',
            language,
          ) +
          currentValue +
          '%.';
    case 'RGB_COLOR':
      return JexText.of('colorUpdated', language);
    case 'ADAPTIVE_PROFILE':
      final profile = currentValue.trim().toUpperCase() == 'BATTERY'
          ? JexText.phrase('Battery', 'Baterai', language)
          : JexText.phrase('Hotside', 'Sisi Panas', language);
      return JexText.phrase(
            'Adaptive profile set to ',
            'Profil Adaptif diatur ke ',
            language,
          ) +
          profile +
          '.';
    case 'ADAPTIVE_CEILING':
      final ceiling = currentValue.trim().toUpperCase();
      return JexText.phrase(
            'Adaptive voltage ceiling set to ',
            'Batas tegangan Adaptif diatur ke ',
            language,
          ) +
          ceiling +
          '.';
    default:
      // HOT/BATTERY temperature samples do not generate ordinary notices.
      return null;
  }
}

String relocalizeHomeNotifyMessage(String message, AppLanguage language) {
  final raw = message.trim();
  if (raw.isEmpty) return raw;

  final segments = raw.split(' • ').map((part) => part.trim()).toList();
  final lead = segments.isEmpty ? '' : segments.first;
  final leadLower = lead.toLowerCase();
  if (leadLower == 'firmware update completed' ||
      leadLower == 'pembaruan firmware selesai') {
    var mode = '';
    var version = '';
    for (final part in segments.skip(1)) {
      if (RegExp(r'^[A-Za-z0-9][A-Za-z0-9._+\-]{0,31}$').hasMatch(part) &&
          RegExp(r'\d').hasMatch(part)) {
        version = part;
      } else if (part.toUpperCase() != 'OTA') {
        mode = JexText.relocalize(part, language);
      }
    }
    return localizedOtaSuccessSummary(language, mode: mode, version: version);
  }
  if (leadLower == 'firmware update failed' ||
      leadLower == 'pembaruan firmware gagal') {
    var mode = '';
    var stage = '';
    for (final part in segments.skip(1)) {
      final normalized = part.toLowerCase();
      final isMode = const <String>{
        'online',
        'local',
        'daring',
        'lokal',
      }.contains(normalized);
      if (isMode && mode.isEmpty) {
        mode = JexText.relocalize(part, language);
      } else if (part.toUpperCase() != 'OTA') {
        stage = JexText.relocalize(part, language);
      }
    }
    return localizedOtaFailureSummary(language, mode: mode, stage: stage);
  }

  final fanSpeedChange = RegExp(
    r'^(?:Fan speed (reduced|increased|set) to|Kecepatan kipas (diturunkan ke|dinaikkan ke|diatur ke))\s*(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (fanSpeedChange != null) {
    final englishAction = fanSpeedChange.group(1)?.toLowerCase();
    final indonesiaAction = fanSpeedChange.group(2)?.toLowerCase();
    final speed = fanSpeedChange.group(3)!;
    if (englishAction == 'reduced' || indonesiaAction == 'diturunkan ke') {
      return JexText.phrase(
            'Fan speed reduced to ',
            'Kecepatan kipas diturunkan ke ',
            language,
          ) +
          speed +
          '%.';
    }
    if (englishAction == 'increased' || indonesiaAction == 'dinaikkan ke') {
      return JexText.phrase(
            'Fan speed increased to ',
            'Kecepatan kipas dinaikkan ke ',
            language,
          ) +
          speed +
          '%.';
    }
    return JexText.phrase(
          'Fan speed set to ',
          'Kecepatan kipas diatur ke ',
          language,
        ) +
        speed +
        '%.';
  }

  final ledBrightness = RegExp(
    r'^(?:LED brightness set to|Kecerahan LED diatur ke)\s*(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (ledBrightness != null) {
    return JexText.phrase(
          'LED brightness set to ',
          'Kecerahan LED diatur ke ',
          language,
        ) +
        ledBrightness.group(1)! +
        '%.';
  }

  final hotsideReached = RegExp(
    r'^(?:Hotside limit reached:|Batas suhu (?:Hotside|Sisi panas) tercapai:)\s*(\d+(?:[.,]\d+)?)\s*°?\s*C\s*\((?:limit|batas)\s*(\d+)\s*°?\s*C\)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (hotsideReached != null) {
    return homeHotsideLimitNotice(
      hotsideReached.group(1)!,
      hotLimit: int.parse(hotsideReached.group(2)!),
      language: language,
    );
  }

  final adaptiveProfile = RegExp(
    r'^(?:Adaptive profile set to|Profil Adaptif diatur ke)\s*(Battery|Baterai|Hotside|Sisi panas)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (adaptiveProfile != null) {
    final rawProfile = adaptiveProfile.group(1)!.toLowerCase();
    final isBattery = rawProfile == 'battery' || rawProfile == 'baterai';
    return JexText.phrase(
          'Adaptive profile set to ',
          'Profil Adaptif diatur ke ',
          language,
        ) +
        JexText.phrase(
          isBattery ? 'Battery' : 'Hotside',
          isBattery ? 'Baterai' : 'Sisi Panas',
          language,
        ) +
        '.';
  }

  final voltage = RegExp(
    r'^(?:Voltage set to|Tegangan diatur ke)\s+([^\s.!?]+)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (voltage != null) {
    return JexText.phrase('Voltage set to ', 'Tegangan diatur ke ', language) +
        voltage.group(1)! +
        '.';
  }

  final fanSpeed = RegExp(
    r'^(?:Fan speed set to|Kecepatan kipas diatur ke)\s+(\d+)%\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (fanSpeed != null) {
    return JexText.phrase(
          'Fan speed set to ',
          'Kecepatan kipas diatur ke ',
          language,
        ) +
        fanSpeed.group(1)! +
        '%.';
  }

  final hotsideLimit = RegExp(
    r'^(?:Hotside temperature limit set to|Batas suhu (?:Hotside|Sisi panas) diatur ke)\s+(\d+)\s*°?\s*C\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (hotsideLimit != null) {
    return JexText.phrase(
          'Hotside temperature limit set to ',
          'Batas suhu sisi panas diatur ke ',
          language,
        ) +
        JexText.formatNumber(int.parse(hotsideLimit.group(1)!), language) +
        ' °C.';
  }

  if (raw == '5V battery limit updated.' ||
      raw == 'Batas baterai 5V diperbarui.') {
    return JexText.phrase(
      '5V battery limit updated.',
      'Batas baterai 5V diperbarui.',
      language,
    );
  }
  if (raw == '12V battery limit updated.' ||
      raw == 'Batas baterai 12V diperbarui.') {
    return JexText.phrase(
      '12V battery limit updated.',
      'Batas baterai 12V diperbarui.',
      language,
    );
  }

  final rearm = RegExp(
    r'^(?:Peltier is locked for safety\. Cool (?:Hotside|the hot side) to ≤|Peltier dikunci demi keselamatan\. Turunkan suhu (?:Hotside|sisi panas) hingga ≤)\s*(\d+)\s*°?\s*C,?\s*(?:then try again|lalu coba lagi)\.?$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (rearm != null) {
    return peltierRearmNotice(int.parse(rearm.group(1)!) + 1, language);
  }

  return JexText.relocalize(raw, language);
}

const Set<String> _jexKnownNotifyReasonCodes = <String>{
  'NTC_ERROR',
  'HOTSIDE_PROTECTION',
  'PELTIER_SAFETY_LATCH',
  'VOLTAGE_STEP_FAILED',
  'VOLTAGE_FORCE_FAILED',
  'ADAPTIVE_RECOVERY_WAIT',
  'ADAPTIVE_RISE_WAIT',
  'ADAPTIVE_STARTING',
  'FAN_REQUIRED',
  'PELTIER_ON',
  'ADAPTIVE_ACTIVE',
  'MANUAL_12V_ONLY',
  'VOLTAGE_TRANSITION',
  'VOLTAGE_GUARD_OR_BUSY',
  'VOLTAGE_LOCKED',
  'NVS_SAVE_FAILED',
  'SYNC_REQUIRED',
  'RATE_LIMIT',
  'RANGE_50_100_STEP_10',
  'MUST_BE_BELOW_BATT12',
  'MUST_BE_ABOVE_BATT5',
  'UNKNOWN_GROUP',
  'WAITING_FOR_NTC',
  'WAITING_FOR_SENSOR_VALIDATION',
  'DISCONNECTED',
  'NONE',
};

/// Translate firmware/internal reason identifiers into concise UI text. Unknown codes
/// deliberately fall back to a generic status message; raw codes remain diagnostic-only.
String localizedNotifyReason(
  String reason, {
  required int hotLimit,
  required AppLanguage language,
}) {
  switch (reason.trim().toUpperCase()) {
    case 'PELTIER_SAFETY_LATCH':
    case 'HOTSIDE_PROTECTION':
      return peltierRearmNotice(hotLimit, language);
    case 'NTC_ERROR':
      return JexText.phrase(
        'Temperature sensor fault. Peltier is disabled for safety.',
        'Sensor suhu bermasalah. Peltier dinonaktifkan demi keselamatan.',
        language,
      );
    case 'VOLTAGE_STEP_FAILED':
      return JexText.phrase(
        'Adaptive Mode could not complete the voltage change.',
        'Mode Adaptif tidak dapat menyelesaikan perubahan tegangan.',
        language,
      );
    case 'VOLTAGE_FORCE_FAILED':
      return JexText.phrase(
        'Safety protection could not set 5V. Check the device.',
        'Proteksi keselamatan gagal mengatur 5V. Periksa perangkat.',
        language,
      );
    case 'ADAPTIVE_RECOVERY_WAIT':
      return JexText.phrase(
        'Adaptive Mode is waiting for voltage recovery to stabilize.',
        'Mode Adaptif menunggu hingga pemulihan tegangan stabil.',
        language,
      );
    case 'ADAPTIVE_RISE_WAIT':
      return JexText.phrase(
        'Adaptive Mode is waiting before increasing voltage.',
        'Mode Adaptif menunggu sebelum menaikkan tegangan.',
        language,
      );
    case 'ADAPTIVE_STARTING':
      return JexText.phrase(
        'Adaptive Mode is starting.',
        'Mode Adaptif sedang dimulai.',
        language,
      );
    case 'FAN_REQUIRED':
      return JexText.phrase(
        'Turn on the fan before enabling Peltier.',
        'Nyalakan kipas sebelum mengaktifkan Peltier.',
        language,
      );
    case 'PELTIER_ON':
      return JexText.phrase(
        'Fan controls are locked while Peltier is active.',
        'Kontrol kipas dikunci saat Peltier aktif.',
        language,
      );
    case 'ADAPTIVE_ACTIVE':
      return JexText.phrase(
        'Manual cooling controls are unavailable in Adaptive Mode.',
        'Kontrol pendinginan manual tidak tersedia saat Mode Adaptif aktif.',
        language,
      );
    case 'MANUAL_12V_ONLY':
      return JexText.phrase(
        'Fan speed adjustment requires 12V in Manual Mode.',
        'Kecepatan kipas hanya dapat diatur pada 12V dalam Mode Manual.',
        language,
      );
    case 'VOLTAGE_TRANSITION':
      return JexText.phrase(
        'Voltage change in progress. Please wait.',
        'Perubahan tegangan berlangsung. Tunggu sebentar.',
        language,
      );
    case 'VOLTAGE_LOCKED':
      return JexText.phrase(
        'Voltage is locked to 5V. Turn off Lock Voltage in Settings to change it.',
        'Tegangan terkunci di 5V. Matikan Kunci Tegangan di Pengaturan untuk mengubahnya.',
        language,
      );
    case 'NVS_SAVE_FAILED':
      return JexText.phrase(
        'Lock is active for this session, but the device could not save it. Retry the setting.',
        'Kunci aktif untuk sesi ini, tetapi perangkat gagal menyimpannya. Coba ulang pengaturan.',
        language,
      );
    case 'VOLTAGE_GUARD_OR_BUSY':
      return JexText.phrase(
        'Voltage control is busy. Try again shortly.',
        'Kontrol tegangan sedang sibuk. Coba lagi sebentar.',
        language,
      );
    case 'SYNC_REQUIRED':
      return JexText.phrase(
        'Device synchronization is in progress.',
        'Sinkronisasi perangkat sedang berlangsung.',
        language,
      );
    case 'RATE_LIMIT':
      return JexText.phrase(
        'Please wait before sending another command.',
        'Tunggu sebentar sebelum mengirim perintah berikutnya.',
        language,
      );
    case 'RANGE_50_100_STEP_10':
      return JexText.phrase(
        'Fan speed must be 50–100% in 10% steps.',
        'Kecepatan kipas harus 50–100% dengan kelipatan 10%.',
        language,
      );
    case 'MUST_BE_BELOW_BATT12':
      return JexText.phrase(
        'The 5V battery limit must be lower than the 12V limit.',
        'Batas baterai 5V harus lebih rendah daripada batas 12V.',
        language,
      );
    case 'MUST_BE_ABOVE_BATT5':
      return JexText.phrase(
        'The 12V battery limit must be higher than the 5V limit.',
        'Batas baterai 12V harus lebih tinggi daripada batas 5V.',
        language,
      );
    case 'UNKNOWN_GROUP':
      return JexText.phrase(
        'This reset request is not supported.',
        'Permintaan reset ini tidak didukung.',
        language,
      );
    case 'WAITING_FOR_NTC':
    case 'WAITING_FOR_SENSOR_VALIDATION':
      return JexText.phrase(
        'Checking temperature sensors.',
        'Memeriksa sensor suhu.',
        language,
      );
    case 'DISCONNECTED':
      return JexText.of('bluetoothDisconnected', language);
    case 'NONE':
      return JexText.of('systemReady', language);
    default:
      return JexText.phrase(
        'Device status needs attention. Check the connection and try again.',
        'Status perangkat perlu diperiksa. Periksa koneksi, lalu coba lagi.',
        language,
      );
  }
}

/// Normalize the Home STATUS body in the currently selected UI language.
/// Known safety codes become useful instructions; unknown identifiers are never shown.
String normalizeHomeNotifyText(
  String message, {
  required int hotLimit,
  required AppLanguage language,
}) {
  var raw = message.trim();
  if (raw.isEmpty) return '';

  // OTA event envelopes have their own parser and must reach it unchanged.
  if (RegExp(
    r'^OTA_(?:SUCCESS|FAILED|UP_TO_DATE)\|',
    caseSensitive: false,
  ).hasMatch(raw)) {
    return raw;
  }

  // Interpret only a terminal underscore token as a reason. This avoids matching ordinary
  // words such as "none" inside readable prose.
  final suffixCode = RegExp(
    r'(?:^|\s)([A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+)\s*$',
    caseSensitive: false,
  ).firstMatch(raw);
  if (suffixCode != null) {
    final code = suffixCode.group(1)!.toUpperCase();
    if (_jexKnownNotifyReasonCodes.contains(code)) {
      return localizedNotifyReason(
        code,
        hotLimit: hotLimit,
        language: language,
      );
    }
    raw = raw.substring(0, suffixCode.start).trim();
  }

  const genericIssue = 'Check the device connection, then try again.';
  const genericIssueId = 'Periksa koneksi perangkat, lalu coba lagi.';
  if (raw.isEmpty)
    return JexText.phrase(genericIssue, genericIssueId, language);

  final lower = raw.toLowerCase();
  final confirmationFailed = <String>[
    'did not confirm',
    'was not confirmed',
    'not confirmed',
    'could not confirm',
    'belum mengonfirmasi',
    'tidak mengonfirmasi',
    'belum terkonfirmasi',
    'tidak terkonfirmasi',
    'tidak dikonfirmasi',
  ].any(lower.contains);
  final commandFailed = <String>[
    'command failed',
    'change failed',
    'settings failed',
    'failed.',
    ' gagal',
    'tidak berhasil',
  ].any(lower.contains);

  if (lower.contains('temperature sensor fault') ||
      lower.contains('temperature sensor error') ||
      lower.contains('sensor suhu bermasalah')) {
    return JexText.phrase(
      'Temperature sensor fault. Peltier is disabled for safety.',
      'Sensor suhu bermasalah. Peltier dinonaktifkan demi keselamatan.',
      language,
    );
  }

  if (confirmationFailed || commandFailed) {
    final fanSpeedIssue =
        lower.contains('fan speed') ||
        lower.contains('fan-speed') ||
        lower.contains('kecepatan kipas');
    final peltierIssue = lower.contains('peltier');
    final adaptiveIssue =
        lower.contains('adaptive') || lower.contains('mode adaptif');
    final voltageIssue =
        lower.contains('voltage') || lower.contains('tegangan');
    final fanIssue = lower.contains('fan') || lower.contains('kipas');
    final brightnessIssue =
        lower.contains('brightness') || lower.contains('kecerahan');
    final colorIssue =
        lower.contains('color') ||
        lower.contains('colour') ||
        lower.contains('warna');
    final ledIssue = lower.contains('led') || lower.contains('rgb');
    final modeIssue = lower.contains('mode');
    final temperatureIssue =
        lower.contains('temperature') ||
        lower.contains('suhu') ||
        lower.contains('hotlimit');

    if (peltierIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'The device did not confirm the Peltier change. Check the safety status.',
              'Perangkat belum mengonfirmasi perubahan Peltier. Periksa status keselamatan.',
              language,
            )
          : JexText.phrase(
              'Peltier change failed. Check safety status.',
              'Perubahan Peltier gagal. Periksa status keselamatan.',
              language,
            );
    }
    if (voltageIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Voltage change not confirmed. Check device status.',
              'Perubahan tegangan belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Voltage change failed. Check device status.',
              'Perubahan tegangan gagal. Periksa status perangkat.',
              language,
            );
    }
    if (adaptiveIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Adaptive Mode change was not confirmed. Check device status.',
              'Perubahan Mode Adaptif belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Adaptive Mode change failed. Check device status.',
              'Perubahan Mode Adaptif gagal. Periksa status perangkat.',
              language,
            );
    }
    if (fanSpeedIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Fan speed not confirmed. Check device status.',
              'Kecepatan kipas belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Fan speed change failed. Check device status.',
              'Perubahan kecepatan kipas gagal. Periksa status perangkat.',
              language,
            );
    }
    if (fanIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Fan change not confirmed. Check device status.',
              'Perubahan kipas belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Fan change failed. Check device status.',
              'Perubahan kipas gagal. Periksa status perangkat.',
              language,
            );
    }
    if (brightnessIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Brightness change not confirmed. Check device status.',
              'Perubahan kecerahan belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Brightness change failed. Check device status.',
              'Perubahan kecerahan gagal. Periksa status perangkat.',
              language,
            );
    }
    if (colorIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Color change not confirmed. Check device status.',
              'Perubahan warna belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Color change failed. Check device status.',
              'Perubahan warna gagal. Periksa status perangkat.',
              language,
            );
    }
    if (ledIssue || modeIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'LED change not confirmed. Check device status.',
              'Perubahan LED belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'LED change failed. Check device status.',
              'Perubahan LED gagal. Periksa status perangkat.',
              language,
            );
    }
    if (temperatureIssue) {
      return confirmationFailed
          ? JexText.phrase(
              'Temperature settings not confirmed. Check device status.',
              'Pengaturan suhu belum terkonfirmasi. Periksa status perangkat.',
              language,
            )
          : JexText.phrase(
              'Temperature settings failed. Check device status.',
              'Pengaturan suhu gagal. Periksa status perangkat.',
              language,
            );
    }
    return confirmationFailed
        ? JexText.phrase(
            'Command not confirmed. Check device status.',
            'Perintah belum terkonfirmasi. Periksa status perangkat.',
            language,
          )
        : JexText.phrase(
            'Action failed. Check device status and try again.',
            'Tindakan gagal. Periksa status perangkat, lalu coba lagi.',
            language,
          );
  }

  raw = raw
      .replaceAll(RegExp(r'\b[A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+\b'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (raw.isEmpty)
    return JexText.phrase(genericIssue, genericIssueId, language);
  return raw;
}

/// Returns true when a live, healthy firmware update can clear a stale Home NOTIFY error.
/// Computes the Home Fan Speed presentation from authoritative runtime state.
String homeFanSpeedDisplay({
  required bool connected,
  required bool fanOn,
  required String voltage,
  required bool adaptiveOn,
  required int fanSpeed,
  required String offLabel,
}) {
  if (!connected) return '--';
  if (!fanOn) return offLabel;
  if (voltage == '5V' || voltage == '9V') return '100%';
  // At 12 V, show authoritative live PWM in both Manual and Adaptive.
  if (voltage == '12V') return '$fanSpeed%';
  return '--';
}

String homeNotifyConnectionLabel({
  required String notice,
  required bool isConnecting,
  required bool isSyncing,
  required bool connected,
  required AppLanguage language,
}) {
  final custom = notice.trim().toUpperCase();
  if (custom.contains('FAILED') ||
      custom.contains('ERROR') ||
      custom.contains('NOT FOUND') ||
      custom.contains('SERVICE DISCOVERY') ||
      custom.contains('DID NOT CONFIRM') ||
      custom.contains('NOT CONFIRMED') ||
      custom.contains('UNCONFIRMED') ||
      custom.contains('BELUM MENGONFIRMASI') ||
      custom.contains('TIDAK MENGONFIRMASI') ||
      custom.contains('BELUM TERKONFIRMASI') ||
      custom.contains('TIDAK TERKONFIRMASI') ||
      custom.contains('TIDAK DIKONFIRMASI') ||
      custom.contains('GAGAL') ||
      custom.contains('KESALAHAN')) {
    return JexText.of('error', language);
  }
  if (isConnecting) return JexText.of('connecting', language);
  if (isSyncing) return JexText.of('syncing', language);
  return JexText.of(connected ? 'connected' : 'disconnected', language);
}

bool shouldClearStaleNotifyError({
  required bool connected,
  required String safety,
  required String safetyReason,
  required bool liveTelemetryReceived,
  required String notice,
}) {
  if (!connected || !liveTelemetryReceived) return false;

  final safe =
      safety.trim().toUpperCase() == 'OK' &&
      safetyReason.trim().toUpperCase() == 'NONE';
  if (!safe) return false;

  final upper = notice.trim().toUpperCase();
  if (upper.isEmpty || upper.contains('OTA') || upper.contains('FIRMWARE')) {
    return false;
  }

  return upper.contains('PELTIER IS LOCKED') ||
      upper.contains('PELTIER TERKUNCI') ||
      upper.contains('NOT CONFIRMED') ||
      upper.contains('COMMAND FAILED') ||
      upper.contains('FAILED') ||
      upper.contains('ERROR') ||
      upper.contains('TIDAK DIKONFIRMASI') ||
      upper.contains('GAGAL') ||
      upper.contains('KESALAHAN');
}

/// Fixed-height Home notification presentation.
/// Dashboard supplies all status, safety, localization and contrast decisions;
/// this widget only renders those values and never reads device/session state.
class HomeNotifyCard extends StatelessWidget {
  final bool darkTheme;
  final bool hasError;
  final bool warning;
  final bool connected;
  final Color foregroundColor;
  final String label;
  final String message;

  const HomeNotifyCard({
    super.key,
    required this.darkTheme,
    required this.hasError,
    required this.warning,
    required this.connected,
    required this.foregroundColor,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final noticeTextColor = darkTheme
        ? const Color(0xFFF4F6FA)
        : const Color(0xFF16181D);
    final alert = hasError || warning;
    final icon = hasError
        ? PhosphorIconsBold.xCircle
        : alert
        ? PhosphorIconsBold.warning
        : !connected
        ? PhosphorIconsRegular.info
        : PhosphorIconsRegular.shieldCheck;
    final color = hasError
        ? const Color(0xFFFF5164)
        : alert
        ? const Color(0xFFFFB72B)
        : !connected
        ? const Color(0xFF7C8797)
        : const Color(0xFF4DE7B7);

    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: darkTheme
            ? color.withValues(alpha: hasError ? .12 : .07)
            : color.withValues(alpha: hasError ? .11 : .08),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: darkTheme
              ? color.withValues(alpha: .25)
              : foregroundColor.withValues(alpha: .28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 34,
            child: Center(
              child: JexAnimatedGlyph(
                icon: icon,
                size: 27,
                color: foregroundColor,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bodyStyle = TextStyle(
                        color: noticeTextColor,
                        fontSize: 10.5,
                        decoration: TextDecoration.none,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      );
                      TextPainter measure(double fontSize) => TextPainter(
                        text: TextSpan(
                          text: message,
                          style: bodyStyle.copyWith(fontSize: fontSize),
                        ),
                        textDirection: Directionality.of(context),
                        maxLines: 2,
                        ellipsis: '…',
                      )..layout(maxWidth: constraints.maxWidth);

                      final wraps =
                          measure(10.5).computeLineMetrics().length > 1;
                      final fontSize = wraps ? 9.5 : 10.5;
                      // Keep NOTIFY readable. Longer copy is ellipsized to two lines,
                      // never reduced to microtype to force the full message into 44 dp.
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          message,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: bodyStyle.copyWith(fontSize: fontSize),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
