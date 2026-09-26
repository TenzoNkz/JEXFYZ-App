#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <NetworkClientSecure.h>
#include <Preferences.h>
#include <Adafruit_NeoPixel.h>
#include <OneButton.h>
#include <math.h>
#include <time.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include "esp_system.h"
#include "esp_err.h"
#include "esp_ota_ops.h"
#include "freertos/FreeRTOS.h"
#include "freertos/portmacro.h"

static constexpr char FW_VERSION[] = "V4.8";

static constexpr char PROTOCOL_VERSION[] = "P1";
static constexpr char BLE_NAME[] = "JE X FYZ";

static constexpr char SERVICE_UUID[] = "6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001";
static constexpr char RX_UUID[]      = "6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001";
static constexpr char TX_UUID[]      = "6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001";

static constexpr uint8_t PIN_NTC     = 0;
static constexpr uint8_t PIN_TOUCH   = 1;
static constexpr uint8_t PIN_12V     = 3;
static constexpr uint8_t PIN_9V      = 4;
static constexpr uint8_t PIN_PELTIER = 5;
static constexpr uint8_t PIN_FAN     = 6;
static constexpr uint8_t PIN_LED     = 7;
static constexpr uint8_t LED_COUNT   = 8;

static constexpr uint8_t OUTPUT_ON  = HIGH;
static constexpr uint8_t OUTPUT_OFF = LOW;

static constexpr char AP_SSID[]     = "JE X FYZ";
static constexpr char AP_PASSWORD[] = "0987654321";
static const IPAddress AP_IP(192, 168, 4, 1);
static const IPAddress AP_GATEWAY(192, 168, 4, 1);
static const IPAddress AP_SUBNET(255, 255, 255, 0);

// ============================================================================
// ============================ OTA SAFETY LOCK ==============================
// OTA is release-critical. Keep this section near the top of the file.
// Never remove or bypass OTA startup, OTA priority, OTA diagnostics, safe
// outputs, finalization, or boot-partition activation during feature changes.
// Every future firmware change must pass the OTA safety audit and build.
// ============================================================================
static constexpr uint32_t BOOT_AP_TIMEOUT_MS          = 10000;
static constexpr uint32_t LED_FRAME_INTERVAL_MS       = 33;
static constexpr uint32_t OTA_RESTART_DELAY_MS        = 1200;
static constexpr uint32_t OTA_FAILURE_INDICATOR_MS    = 1000;
static constexpr uint32_t WIFI_CONNECT_TIMEOUT_MS     = 15000;
static constexpr uint32_t ONLINE_OTA_HTTP_TIMEOUT_MS  = 60000;
static constexpr size_t ONLINE_OTA_RANGE_CHUNK_BYTES  = 64 * 1024;
static constexpr uint8_t ONLINE_OTA_RANGE_RETRIES    = 3;
static constexpr uint32_t OTA_MAX_FIRMWARE_BYTES     = 2 * 1024 * 1024;
static_assert(ONLINE_OTA_RANGE_CHUNK_BYTES > 0,
              "OTA SAFETY: range chunk must be non-zero");
static_assert(ONLINE_OTA_RANGE_CHUNK_BYTES <= OTA_MAX_FIRMWARE_BYTES,
              "OTA SAFETY: range chunk exceeds firmware limit");
static_assert(OTA_MAX_FIRMWARE_BYTES <= 2 * 1024 * 1024,
              "OTA SAFETY: firmware limit exceeded");

// ============================================================================
// ======================= OTA STATE / PRIORITY LOCK =========================
// These declarations intentionally precede application feature state.
// ============================================================================
enum class OtaState : uint8_t {
  IDLE,
  BOOT_AP,
  LOCAL_UPLOAD,
  CLOUD_CONNECTING,
  CLOUD_DOWNLOADING,
  CLOUD_APPLYING,
  SUCCESS,
  FAILED,
};

static bool serviceOtaPriority();
static void processPendingOnlineOtaStart();

// ========================== END OTA PRIORITY LOCK ===========================

static constexpr size_t BLE_TX_QUEUE_SIZE = 48;
static constexpr size_t BLE_RX_QUEUE_SIZE = 16;
static constexpr uint32_t BLE_TX_INTERVAL_MS = 15;
static constexpr uint32_t ONLINE_OTA_START_WAIT_MS = 1500;
static constexpr uint32_t BLE_START_RETRY_MS = 750;
static constexpr uint8_t BLE_START_MAX_ATTEMPTS = 8;
static constexpr uint8_t RADIO_OFF_SETTLE_YIELDS = 12;

static constexpr float NTC_FIXED_OHMS    = 10000.0f;
static constexpr float NTC_NOMINAL_OHMS  = 10000.0f;
static constexpr float NTC_NOMINAL_C     = 25.0f;
static constexpr float NTC_BETA          = 3950.0f;
static constexpr uint32_t NTC_READ_INTERVAL_MS = 1000;
static constexpr uint32_t NTC_FAULT_LOW_MV  = 50;
static constexpr uint32_t NTC_FAULT_HIGH_MV = 3250;

static constexpr uint32_t VOLTAGE_GUARD_MS             = 1000;
static constexpr uint32_t VOLTAGE_DEADTIME_MS           = 200;
static constexpr uint32_t HOT_PELTIER_OFF_MS          = 10000;
static constexpr uint32_t ADAPTIVE_UPWARD_DELAY_MS      = 5000;
static constexpr uint32_t BATTERY_VALID_TTL_MS          = 5000;
static constexpr uint32_t SETTINGS_SAVE_DEBOUNCE_MS     = 10000;

static constexpr uint32_t USER_CONTROL_GUARD_MS          = 250;

static constexpr int HOT_LIMIT_MIN = 40;
static constexpr int HOT_LIMIT_MAX = 50;
static constexpr int BATTERY_LIMIT_MIN = 20;
static constexpr int BATTERY5_LIMIT_MAX = 48;
static constexpr int BATTERY12_LIMIT_MIN = 22;
static constexpr int BATTERY12_LIMIT_MAX = 50;

static constexpr uint8_t FAN_PWM_MIN = 50;
static constexpr uint8_t FAN_PWM_MAX = 100;
static constexpr uint8_t FAN_PWM_STEP = 10;
static constexpr uint32_t FAN_PWM_FREQ = 25000;
static constexpr uint8_t FAN_PWM_RESOLUTION = 8;
static constexpr uint32_t PELTIER_PWM_FREQ = 20000;
static constexpr uint8_t PELTIER_PWM_RESOLUTION = 8;
static constexpr uint32_t PELTIER_SOFT_START_MS = 5000;

WebServer webServer(80);
Preferences prefs;
Adafruit_NeoPixel leds(LED_COUNT, PIN_LED, NEO_GRB + NEO_KHZ800);
OneButton touchButton(PIN_TOUCH, false, false);

BLEServer* bleServer = nullptr;
BLECharacteristic* rxCharacteristic = nullptr;
BLECharacteristic* txCharacteristic = nullptr;
volatile bool bleClientConnected = false;
static constexpr uint16_t BLE_INVALID_CONN_ID = 0xFFFF;
uint16_t bleConnectionId = BLE_INVALID_CONN_ID;
String bleTxQueue[BLE_TX_QUEUE_SIZE];
size_t bleTxHead = 0;
size_t bleTxTail = 0;
size_t bleTxCount = 0;
uint32_t bleNextNotifyAt = 0;

String bleRxQueue[BLE_RX_QUEUE_SIZE];
size_t bleRxHead = 0;
size_t bleRxTail = 0;
size_t bleRxCount = 0;

static portMUX_TYPE bleQueueMux = portMUX_INITIALIZER_UNLOCKED;
volatile bool bleQueueResetPending = false;

bool onlineOtaStartPending = false;
uint32_t onlineOtaRequestedAt = 0;
uint32_t stateSequence = 0;

enum class Voltage : uint8_t {
  V5 = 0,
  V9 = 1,
  V12 = 2,
};

enum class LedMode : uint8_t {
  STATIC = 1,
  BREATH = 2,
  CENTER_OUT = 3,
  OUTER_IN = 4,
  DUAL_CHASE = 5,
  LEFT_RIGHT = 6,
  RAINBOW = 7,
  TWINKLE = 8,
};

enum class VoltageRequestSource : uint8_t {
  MANUAL,
  TOUCH,
  BATTERY,
  HOTSTEP,
  ADAPTIVE,
  SAFETY,
};

Voltage currentVoltage = Voltage::V5;
Voltage pendingVoltage = Voltage::V5;

bool fanOn = false;
bool peltierOn = false;
bool peltierSoftStarting = false;
uint32_t peltierSoftStartAtMs = 0;
bool adaptiveOn = false;
Voltage adaptiveCeiling = Voltage::V12;

bool ntcValid = false;
float hotsideC = NAN;
uint32_t ntcMv = 0;
uint32_t lastNtcReadMs = 0;

bool batteryValid = false;
float batteryC = NAN;
uint32_t lastBatteryRxMs = 0;
int lastBatteryZone = -1;

int hotLimit = 45;
int battery5Limit = 25;
int battery12Limit = 35;

uint8_t fanPwm = 100;

bool rgbOn = false;
LedMode rgbMode = LedMode::STATIC;
uint8_t rgbBrightness = 100;
uint32_t rgbColor = 0xFFFFFF;
uint32_t color5V = 0xFF0000;
uint32_t color9V = 0x00FF00;
uint32_t color12V = 0x0000FF;

bool settingsDirty = false;
uint32_t settingsDirtyAt = 0;
bool prefsReady = false;

bool voltageTransition = false;
uint32_t voltageTransitionAt = 0;
uint32_t lastVoltageChangeMs = 0;
bool voltageGuardArmed = false;

String lastSafetyReasonSent;

bool voltageIndicatorActive = false;
uint32_t voltageIndicatorUntil = 0;
uint32_t lastLedFrameAtMs = 0;
uint32_t twinkleUpdateAtMs = 0;
uint8_t twinkleLevel[LED_COUNT] = {0};

bool hotProtectionActive = false;
bool adaptiveHotStepPending = false;
uint32_t adaptiveHotStepDueMs = 0;
uint32_t peltierHotOffUntilMs = 0;
bool adaptiveResumePeltierAfterHotStep = false;

bool adaptiveUpPending = false;
Voltage adaptiveUpTarget = Voltage::V5;
uint32_t adaptiveUpDueMs = 0;

bool adaptiveDownPending = false;
Voltage adaptiveDownTarget = Voltage::V5;

// ========================= OTA STATE — PROTECTED ===========================
bool otaActive = false;
OtaState otaState = OtaState::BOOT_AP;
uint32_t otaRestartAt = 0;
uint32_t otaFailureIndicatorUntil = 0;
String otaResult = "NONE";

String cloudSsid;
String cloudPassword;
String cloudUrl;
String cloudVersion;

HTTPClient cloudHttp;
NetworkClientSecure cloudClient;
size_t localOtaBytesReceived = 0;
size_t localOtaExpectedBytes = 0;
esp_ota_handle_t localOtaHandle = 0;
const esp_partition_t* localOtaPartition = nullptr;
bool localOtaStarted = false;

bool bleStartPending = true;
uint8_t bleStartAttempts = 0;
uint32_t bleStartRetryAt = 0;
uint32_t cloudBytesReceived = 0;
uint32_t cloudPhaseStartedAt = 0;
bool cloudTimeSyncStarted = false;

// ====================== OTA DIAGNOSTICS — PROTECTED =========================
String otaDiagnosticStage = "IDLE";
String otaDiagnosticError = "NONE";
int otaDiagnosticErrorCode = 0;
uint8_t otaDiagnosticProgress = 0;
uint8_t otaDiagnosticLastPublishedProgress = 255;

bool bootApActive = true;
uint32_t bootApStartedAt = 0;
bool bootApHadClient = false;
bool bootApClientSafe = false;

volatile bool bleSyncPending = false;

volatile bool bleCommandGateOpen = false;

bool userControlGuardArmed = false;
uint32_t lastUserControlCommandMs = 0;

uint32_t ledBlinkAt = 0;
bool ledBlinkPhase = false;

static constexpr size_t BLE_RX_BUFFER_SIZE = 512;
char bleRxBuffer[BLE_RX_BUFFER_SIZE];
size_t bleRxLength = 0;

static void showAll(uint32_t color, uint8_t brightness = 255);
static void sendText(const String& line);
static void sendDelta(const char* key, const String& value);
static void setOtaState(OtaState state);
static const char* otaStateText(OtaState state);
static void sendAck(const String& item, bool ok, const String& reason);
static void sendFullSync();
static void handleCommand(const String& command);
static void feedBleRx(const String& incoming);
static void startBle();
static void startLocalOtaAp();
static void stopLocalOtaAp();
static void startOnlineOta();
static void processOnlineOta();
static bool requestVoltage(Voltage target, VoltageRequestSource source, bool bypassGuard = false);
static void publishSafetyReason();
static void evaluateAdaptiveBattery();
static void serviceBleTx();
static void clearBleTxQueue();
static void clearBleRxQueue();
static void processBleRxQueue();
static void processPendingOnlineOtaStart();
static void setOtaDiagnosticStage(const String& stage);
static void setOtaDiagnosticProgress(uint8_t progress);
static void setOtaDiagnosticError(int errorCode, const String& error);
static String otaFailureResult(const String& mode, const String& stage, int errorCode, const String& error, uint8_t progress);
static String otaSuccessResult(const String& mode, const String& stage, const String& version);
static String otaUpdateFailureStage(bool online, int errorCode);
static void abortLocalOtaTransaction() {
  if (localOtaStarted) {
    esp_ota_abort(localOtaHandle);
  }
  localOtaStarted = false;
  localOtaHandle = 0;
  localOtaPartition = nullptr;
}

static void failLocalOta(
    const String& stage,
    int errorCode,
    const String& error) {
  abortLocalOtaTransaction();
  setOtaDiagnosticStage(stage);
  setOtaDiagnosticError(errorCode, error);
  saveOtaResult(
      otaFailureResult("LOCAL", stage, errorCode, error, otaDiagnosticProgress));
  setOtaState(OtaState::FAILED);
  resetBlinkState();
  otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
  otaActive = false;
  localOtaBytesReceived = 0;
  localOtaExpectedBytes = 0;

  // Local OTA failure deliberately keeps the AP alive so the user can retry.
  // BLE remains stopped while the recovery web page is serving.
  bootApActive = true;
  bootApHadClient = true;
  bootApClientSafe = true;
  applyOtaSafeOutputs();
}

static void localOtaUploadHandler() {
  HTTPUpload& upload = webServer.upload();

  if (upload.status == UPLOAD_FILE_START) {
    otaRestartAt = 0;
    otaActive = true;
    setOtaState(OtaState::LOCAL_UPLOAD);
    setOtaDiagnosticStage("LOCAL_FILE_CHECK");
    setOtaDiagnosticProgress(0);
    setOtaDiagnosticError(0, "NONE");
    resetBlinkState();

    abortLocalOtaTransaction();
    localOtaBytesReceived = 0;
    localOtaExpectedBytes = 0;

    String filename = upload.filename;
    filename.toLowerCase();
    if (!filename.endsWith(".bin")) {
      failLocalOta("LOCAL_FILE_CHECK", -1, "INVALID_FILE_TYPE");
      return;
    }

    if (!webServer.hasArg("size")) {
      failLocalOta("LOCAL_SIZE_CHECK", -1, "SIZE_REQUIRED");
      return;
    }

    const long parsedSize = webServer.arg("size").toInt();
    if (parsedSize <= 0 ||
        parsedSize > static_cast<long>(OTA_MAX_FIRMWARE_BYTES)) {
      failLocalOta("LOCAL_SIZE_CHECK", -1, "INVALID_FILE_SIZE");
      return;
    }

    localOtaExpectedBytes = static_cast<size_t>(parsedSize);
    localOtaPartition = esp_ota_get_next_update_partition(nullptr);

    if (localOtaPartition == nullptr) {
      failLocalOta("LOCAL_UPDATE_BEGIN", static_cast<int>(ESP_ERR_NOT_FOUND), "NO_OTA_PARTITION");
      return;
    }

    if (localOtaExpectedBytes > localOtaPartition->size) {
      failLocalOta(
          "LOCAL_SIZE_CHECK",
          static_cast<int>(ESP_ERR_INVALID_SIZE),
          "FIRMWARE_EXCEEDS_PARTITION_" +
              String(static_cast<unsigned long>(localOtaPartition->size)));
      return;
    }

    applyOtaSafeOutputs();
    setOtaDiagnosticStage("LOCAL_UPDATE_BEGIN");

    const esp_err_t beginErr = esp_ota_begin(
        localOtaPartition,
        localOtaExpectedBytes,
        &localOtaHandle);
    if (beginErr != ESP_OK) {
      failLocalOta(
          "LOCAL_UPDATE_BEGIN",
          static_cast<int>(beginErr),
          String("esp_ota_begin: ") + esp_err_to_name(beginErr));
      return;
    }

    localOtaStarted = true;
    setOtaDiagnosticStage("LOCAL_RECEIVE");
    saveOtaResult("IN_PROGRESS|MODE=LOCAL|STAGE=LOCAL_RECEIVE|PROGRESS=0");
    return;
  }

  if (upload.status == UPLOAD_FILE_WRITE) {
    if (otaState != OtaState::LOCAL_UPLOAD ||
        !otaActive ||
        !localOtaStarted) {
      return;
    }

    if (upload.currentSize == 0) return;
    setOtaDiagnosticStage("LOCAL_FLASH_WRITE");

    const size_t chunkSize = static_cast<size_t>(upload.currentSize);
    if (localOtaBytesReceived + chunkSize > localOtaExpectedBytes) {
      failLocalOta("LOCAL_SIZE_VERIFY", -1, "UPLOAD_SIZE_EXCEEDED");
      return;
    }

    const esp_err_t writeErr = esp_ota_write(
        localOtaHandle,
        upload.buf,
        chunkSize);
    if (writeErr != ESP_OK) {
      failLocalOta(
          "LOCAL_FLASH_WRITE",
          static_cast<int>(writeErr),
          String("esp_ota_write: ") + esp_err_to_name(writeErr));
      return;
    }

    localOtaBytesReceived += chunkSize;
    const uint8_t progress = static_cast<uint8_t>(
        min<size_t>(
            100,
            (localOtaBytesReceived * 100ULL) /
                max<size_t>(1, localOtaExpectedBytes)));
    setOtaDiagnosticProgress(progress);

    if (localOtaBytesReceived > OTA_MAX_FIRMWARE_BYTES) {
      failLocalOta("LOCAL_SIZE_VERIFY", -1, "OTA_TOO_LARGE");
    }
    return;
  }

  if (upload.status == UPLOAD_FILE_END) {
    if (otaState != OtaState::LOCAL_UPLOAD ||
        !otaActive ||
        !localOtaStarted) {
      return;
    }

    setOtaDiagnosticStage("LOCAL_SIZE_VERIFY");
    if (localOtaBytesReceived == 0 ||
        localOtaBytesReceived != localOtaExpectedBytes) {
      char detail[96];
      snprintf(
          detail,
          sizeof(detail),
          "UPLOAD_SIZE_MISMATCH_%lu_%lu",
          static_cast<unsigned long>(localOtaBytesReceived),
          static_cast<unsigned long>(localOtaExpectedBytes));
      failLocalOta("LOCAL_SIZE_VERIFY", -1, detail);
      return;
    }

    setOtaDiagnosticProgress(100);
    setOtaDiagnosticStage("LOCAL_IMAGE_VERIFY");

    const esp_err_t endErr = esp_ota_end(localOtaHandle);
    localOtaHandle = 0;
    localOtaStarted = false;

    if (endErr != ESP_OK) {
      const String detail =
          String("esp_ota_end: ") + esp_err_to_name(endErr);
      failLocalOta(
          endErr == ESP_ERR_OTA_VALIDATE_FAILED
              ? "LOCAL_IMAGE_VERIFY"
              : "LOCAL_FINALIZE",
          static_cast<int>(endErr),
          detail);
      return;
    }

    setOtaDiagnosticStage("LOCAL_BOOT_PARTITION");
    const esp_err_t bootErr =
        esp_ota_set_boot_partition(localOtaPartition);
    localOtaPartition = nullptr;

    if (bootErr != ESP_OK) {
      failLocalOta(
          "LOCAL_BOOT_PARTITION",
          static_cast<int>(bootErr),
          String("esp_ota_set_boot_partition: ") +
              esp_err_to_name(bootErr));
      return;
    }

    setOtaDiagnosticError(0, "NONE");
    saveOtaResult(
        otaSuccessResult("LOCAL", "LOCAL_BOOT_PARTITION", FW_VERSION));
    setOtaState(OtaState::SUCCESS);
    otaActive = true;
    resetBlinkState();
    otaRestartAt = millis() + OTA_RESTART_DELAY_MS;
    localOtaExpectedBytes = 0;
    return;
  }

  if (upload.status == UPLOAD_FILE_ABORTED) {
    failLocalOta("LOCAL_RECEIVE", -1, "UPLOAD_ABORTED");
  }
}

static void handleOtaRoot() {
  String html = FPSTR(LOCAL_OTA_PAGE);
  html.replace("%VERSION%", FW_VERSION);
  webServer.send(200, "text/html", html);
}

static void handleOtaPost() {
  webServer.sendHeader("Connection", "close");

  if (otaState == OtaState::FAILED) {
    webServer.send(
        500,
        "text/plain",
        "OTA FAILED: " + otaResult);
    return;
  }

  if (otaState == OtaState::SUCCESS) {
    webServer.send(
        200,
        "text/plain",
        "OTA verified. Green indicator active; device will restart.");
    return;
  }

  webServer.send(
      409,
      "text/plain",
      "OTA not finalized: " + otaResult);
}

static void startLocalOtaAp() {

  onlineOtaStartPending = false;
  bootApActive = true;
  bootApHadClient = false;
  otaActive = false;
  setOtaState(OtaState::BOOT_AP);

  WiFi.disconnect(true, false);
  WiFi.setHostname("JE-X-FYZ");
  WiFi.setAutoReconnect(false);
  WiFi.mode(WIFI_AP);

  const bool configOk = WiFi.softAPConfig(AP_IP, AP_GATEWAY, AP_SUBNET);
  const bool apOk = configOk && WiFi.softAP(AP_SSID, AP_PASSWORD);

  if (!apOk) {
    bootApActive = false;
    setOtaState(OtaState::FAILED);
    otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
    stopWiFiRadio();
    startBle();
    return;
  }

  bootApStartedAt = millis();

  webServer.on("/", HTTP_GET, handleOtaRoot);
  webServer.on("/update", HTTP_POST, handleOtaPost, localOtaUploadHandler);
  webServer.begin();
}

static void stopLocalOtaAp() {
  webServer.stop();
  stopWiFiRadio();
  bootApActive = false;
  if (otaState == OtaState::BOOT_AP) {
    setOtaState(OtaState::IDLE);
  }
}

// ======================== END OTA ENGINE — LOCKED ==========================
static bool setFanState(bool desired, String& reason) {
  if (adaptiveOn) {
    reason = "ADAPTIVE_ACTIVE";
    return false;
  }

  if (!ntcValid) {
    reason = "NTC_ERROR";
    return false;
  }

  if (!desired && peltierOn) {
    reason = "PELTIER_ON";
    return false;
  }

  if (!desired && hotsideProtectionActiveNow()) {
    reason = "HOTSIDE_PROTECTION";
    return false;
  }

  if (!desired) {
    adaptiveResumePeltierAfterHotStep = false;
  }

  if (fanOn != desired) {
    fanOn = desired;
    applyCoolingOutputs();
  }

  reason = "OK";
  return fanOn == desired;
}

static bool setPeltierState(bool desired, String& reason) {
  if (adaptiveOn) {
    reason = "ADAPTIVE_ACTIVE";
    return false;
  }

  if (!desired) {
    adaptiveResumePeltierAfterHotStep = false;
    if (peltierOn) {
      peltierOn = false;
      applyCoolingOutputs();
    }
    reason = "OK";
    return true;
  }

  if (!ntcValid) {
    reason = "NTC_ERROR";
    return false;
  }

  if (!fanOn) {
    reason = "FAN_REQUIRED";
    return false;
  }

  if (hotsideProtectionActiveNow()) {
    reason = "HOTSIDE_PROTECTION";
    return false;
  }

  if (!peltierOn) {

    peltierOn = true;
    applyCoolingOutputs();
  }

  reason = peltierOn ? "OK" : safetyReason();
  return peltierOn;
}

static bool forceAdaptiveFiveVolt() {

  if (voltageTransition) {
    pendingVoltage = Voltage::V5;
    return true;
  }

  if (currentVoltage == Voltage::V5) return true;

  return requestVoltage(
      Voltage::V5,
      VoltageRequestSource::ADAPTIVE,
      true);
}

static void setAdaptiveState(bool desired, String& reason) {
  const bool previousAdaptive = adaptiveOn;
  const Voltage previousCeiling = adaptiveCeiling;
  if (desired) {
    if (!ntcValid) {
      adaptiveOn = false;
      adaptiveCeiling = Voltage::V12;
      reason = "NTC_ERROR";
      return;
    }

    adaptiveOn = true;
    if (!previousAdaptive) {
      adaptiveCeiling = Voltage::V12;
      adaptiveHotStepPending = false;
      peltierHotOffUntilMs = 0;
      adaptiveResumePeltierAfterHotStep = false;
      adaptiveUpPending = false;
      adaptiveDownPending = false;
      lastBatteryZone = -1;
      fanPwm = 100;
    }

    if (!forceAdaptiveFiveVolt()) {
      adaptiveOn = previousAdaptive;
      reason = "VOLTAGE_FORCE_FAILED";
      return;
    }

    applyCoolingOutputs();
    reason = "OK";

    if (currentVoltage == Voltage::V5 && batteryValid) {
      evaluateAdaptiveBattery();
    }
  } else {
    adaptiveOn = false;
    adaptiveHotStepPending = false;
    peltierHotOffUntilMs = 0;
    adaptiveUpPending = false;
    adaptiveDownPending = false;
    adaptiveResumePeltierAfterHotStep = false;
    adaptiveCeiling = Voltage::V12;
    fanPwm = 100;

    if (!forceAdaptiveFiveVolt()) {

      reason = "VOLTAGE_FORCE_FAILED";
    } else {
      reason = "OK";
    }

    applyCoolingOutputs();
  }

  if (adaptiveOn != previousAdaptive) {
    ++stateSequence;
    sendDelta("ADAPTIVE", boolText(adaptiveOn));
  }
  if (adaptiveCeiling != previousCeiling) {
    sendDelta("ADAPTIVE_CEILING", voltageToString(adaptiveCeiling));
  }
}

static bool setRgbState(bool desired) {
  if (rgbOn == desired) return true;

  rgbOn = desired;
  ++stateSequence;
  markSettingsDirty();

  if (rgbOn) {
    startUserLedEffect();
  } else {
    stopUserLedOutput();
  }

  sendDelta("RGB", boolText(rgbOn));
  return true;
}

static bool setFanSpeed(uint8_t value, String& reason) {
  if (value < FAN_PWM_MIN || value > FAN_PWM_MAX || value % FAN_PWM_STEP != 0) {
    reason = "RANGE_50_100_STEP_10";
    return false;
  }

  if (adaptiveOn) {
    reason = "ADAPTIVE_ACTIVE";
    return false;
  }

  if (currentVoltage != Voltage::V12) {
    reason = "MANUAL_12V_ONLY";
    return false;
  }

  if (fanPwm != value) {
    fanPwm = value;
    writeFanPwm();
    sendDelta("FAN_SPEED", String(fanPwm));
  }

  reason = "OK";
  return true;
}

static void handleSettingsReset(const String& group) {
  String normalized = group;
  normalized.trim();
  normalized.toUpperCase();

  if (normalized == "TEMPERATURE") {
    if (adaptiveOn) {
      sendAck("RESET_TEMPERATURE", false, "ADAPTIVE_ACTIVE");
      return;
    }
    const bool changed = hotLimit != 45 || battery5Limit != 25 || battery12Limit != 35;
    hotLimit = 45;
    battery5Limit = 25;
    battery12Limit = 35;
    if (changed) {
      markSettingsDirty();
      enforceSafety();
      sendDelta("TEMP_HOT_LIMIT", String(hotLimit));
      sendDelta("BATT_5", String(battery5Limit));
      sendDelta("BATT_12", String(battery12Limit));
    }
    sendAck("RESET_TEMPERATURE", true, "OK");
    return;
  }

  if (normalized == "VOLTAGECOLORS") {
    const bool changed = color5V != 0xFF0000 || color9V != 0x00FF00 || color12V != 0x0000FF;
    color5V = 0xFF0000;
    color9V = 0x00FF00;
    color12V = 0x0000FF;
    if (changed) {
      markSettingsDirty();
      sendDelta("COLOR_5V", colorToHex(color5V));
      sendDelta("COLOR_9V", colorToHex(color9V));
      sendDelta("COLOR_12V", colorToHex(color12V));
    }
    sendAck("RESET_VOLTAGECOLORS", true, "OK");
    return;
  }

  sendAck("RESET", false, "UNKNOWN_GROUP");
}

static void handleCommand(const String& command) {
  if (command == "SYNC") {
    sendFullSync();
    return;
  }

  if (command == "SYNC_READY") {
    bleCommandGateOpen = true;

    sendFullSync();
    sendAck("SYNC_READY", true, "OK");
    return;
  }

  if (command == "OTAENTER") {
    sendAck("OTAENTER", true, "READY");
    return;
  }

  if (command.startsWith("SSID:")) {
    cloudSsid = command.substring(5);
    cloudSsid.trim();
    sendAck("SSID", !cloudSsid.isEmpty(), cloudSsid.isEmpty() ? "INVALID" : "OK");
    return;
  }

  if (command.startsWith("PASS:")) {
    cloudPassword = command.substring(5);
    sendAck("PASS", !cloudPassword.isEmpty(), cloudPassword.isEmpty() ? "INVALID" : "OK");
    return;
  }

  if (command.startsWith("URL:")) {
    cloudUrl = command.substring(4);
    cloudUrl.trim();
    const bool ok = validHttpsUrl(cloudUrl);
    sendAck("URL", ok, ok ? "OK" : "HTTPS_REQUIRED");
    return;
  }

  if (command.startsWith("VERSION:")) {
    cloudVersion = command.substring(8);
    cloudVersion.trim();
    sendAck("VERSION", !cloudVersion.isEmpty(), cloudVersion.isEmpty() ? "INVALID" : "OK");
    return;
  }

  if (command == "CLOUDOTA") {
    if (cloudSsid.isEmpty() || cloudPassword.isEmpty() || !validHttpsUrl(cloudUrl) || cloudVersion.isEmpty()) {
      sendAck("CLOUDOTA", false, "MISSING_METADATA");
      return;
    }

    if (onlineOtaStartPending) {
      sendAck("CLOUDOTA", false, "ALREADY_PENDING");
      return;
    }

    sendAck("CLOUDOTA", true, "STARTING");
    onlineOtaStartPending = true;
    onlineOtaRequestedAt = millis();
    return;
  }

  if (command == "RGB:ON") {
    const bool ok = setRgbState(true);
    sendAck("RGB", ok, ok ? "OK" : "FAILED");
    return;
  }

  if (command == "RGB:OFF") {
    const bool ok = setRgbState(false);
    sendAck("RGB", ok, ok ? "OK" : "FAILED");
    return;
  }

  if (command.startsWith("MODE:")) {
    int value = 0;
    if (!parseIntRange(command.substring(5), 0, 7, value)) {
      sendAck("MODE", false, "INVALID");
      return;
    }

    const LedMode newMode = static_cast<LedMode>(value);
    if (rgbMode != newMode) {
      rgbMode = newMode;
      markSettingsDirty();
      if (rgbOn) startUserLedEffect();
      sendDelta("MODE", String(value));
    }

    sendAck("MODE", true, "OK");
    return;
  }

  if (command.startsWith("BRIGHTNESS:")) {
    int value = 0;
    if (!parseIntRange(command.substring(11), 0, 100, value)) {
      sendAck("BRIGHTNESS", false, "RANGE_0_100");
      return;
    }

    if (rgbBrightness != static_cast<uint8_t>(value)) {
      rgbBrightness = static_cast<uint8_t>(value);
      markSettingsDirty();
      if (rgbOn) startUserLedEffect();
      sendDelta("BRIGHTNESS", String(value));
    }

    sendAck("BRIGHTNESS", true, "OK");
    return;
  }

  if (command.startsWith("COLOR:")) {
    uint32_t parsed = 0;
    if (!parseHexColor(command.substring(6), parsed)) {
      sendAck("COLOR", false, "INVALID_HEX");
      return;
    }

    if (rgbColor != parsed) {
      rgbColor = parsed;
      markSettingsDirty();
      if (rgbOn) startUserLedEffect();
      sendDelta("RGB_COLOR", colorToHex(rgbColor));
    }

    sendAck("COLOR", true, "OK");
    return;
  }

  if (command.startsWith("V5COLOR:")) {
    uint32_t parsed = 0;
    if (!parseHexColor(command.substring(8), parsed)) {
      sendAck("V5COLOR", false, "INVALID_HEX");
      return;
    }

    if (color5V != parsed) {
      color5V = parsed;
      markSettingsDirty();
      sendDelta("COLOR_5V", colorToHex(color5V));
    }

    sendAck("V5COLOR", true, "OK");
    return;
  }

  if (command.startsWith("V9COLOR:")) {
    uint32_t parsed = 0;
    if (!parseHexColor(command.substring(8), parsed)) {
      sendAck("V9COLOR", false, "INVALID_HEX");
      return;
    }

    if (color9V != parsed) {
      color9V = parsed;
      markSettingsDirty();
      sendDelta("COLOR_9V", colorToHex(color9V));
    }

    sendAck("V9COLOR", true, "OK");
    return;
  }

  if (command.startsWith("V12COLOR:")) {
    uint32_t parsed = 0;
    if (!parseHexColor(command.substring(9), parsed)) {
      sendAck("V12COLOR", false, "INVALID_HEX");
      return;
    }

    if (color12V != parsed) {
      color12V = parsed;
      markSettingsDirty();
      sendDelta("COLOR_12V", colorToHex(color12V));
    }

    sendAck("V12COLOR", true, "OK");
    return;
  }

  if (command.startsWith("HOTLIMIT:")) {
    if (adaptiveOn) {
      sendAck("HOTLIMIT", false, "ADAPTIVE_ACTIVE");
      return;
    }
    int value = 0;
    if (!parseIntRange(command.substring(9), HOT_LIMIT_MIN, HOT_LIMIT_MAX, value)) {
      sendAck("HOTLIMIT", false, "RANGE_40_50");
      return;
    }

    if (hotLimit != value) {
      hotLimit = value;
      markSettingsDirty();
      enforceSafety();
      sendDelta("TEMP_HOT_LIMIT", String(hotLimit));
    }

    sendAck("HOTLIMIT", true, "OK");
    return;
  }

  if (command.startsWith("BATT5:")) {
    if (adaptiveOn) {
      sendAck("BATT5", false, "ADAPTIVE_ACTIVE");
      return;
    }
    int value = 0;
    if (!parseIntRange(command.substring(6), BATTERY_LIMIT_MIN, BATTERY5_LIMIT_MAX, value)) {
      sendAck("BATT5", false, "RANGE_20_48");
      return;
    }

    if (value >= battery12Limit - 1) {
      sendAck("BATT5", false, "MUST_BE_BELOW_BATT12");
      return;
    }

    if (battery5Limit != value) {
      battery5Limit = value;
      markSettingsDirty();
      sendDelta("BATT_5", String(battery5Limit));
    }

    sendAck("BATT5", true, "OK");
    return;
  }

  if (command.startsWith("BATT12:")) {
    if (adaptiveOn) {
      sendAck("BATT12", false, "ADAPTIVE_ACTIVE");
      return;
    }
    int value = 0;
    if (!parseIntRange(command.substring(7), BATTERY12_LIMIT_MIN, BATTERY12_LIMIT_MAX, value)) {
      sendAck("BATT12", false, "RANGE_22_50");
      return;
    }

    if (value <= battery5Limit + 1) {
      sendAck("BATT12", false, "MUST_BE_ABOVE_BATT5");
      return;
    }

    if (battery12Limit != value) {
      battery12Limit = value;
      markSettingsDirty();
      sendDelta("BATT_12", String(battery12Limit));
    }

    sendAck("BATT12", true, "OK");
    return;
  }

  if (command.startsWith("VOLTAGE:")) {
    if (adaptiveOn) {
      sendAck("VOLTAGE", false, "ADAPTIVE_ACTIVE");
      return;
    }

    String rawTarget = command.substring(8);
    rawTarget.trim();
    Voltage target = voltageFromString(rawTarget);
    const bool requestedValid = rawTarget.equalsIgnoreCase("5V") ||
                                rawTarget.equalsIgnoreCase("9V") ||
                                rawTarget.equalsIgnoreCase("12V");
    if (!requestedValid) {
      sendAck("VOLTAGE", false, "INVALID");
      return;
    }

    const bool accepted = requestVoltage(target, VoltageRequestSource::MANUAL, false);
    sendAck("VOLTAGE", accepted,
            accepted ? "ACCEPTED" : "VOLTAGE_GUARD_OR_BUSY");
    return;
  }

  if (command == "FAN:ON") {
    String reason;
    const bool ok = setFanState(true, reason);
    sendAck("FAN", ok, reason);
    return;
  }

  if (command == "FAN:OFF") {
    String reason;
    const bool ok = setFanState(false, reason);
    sendAck("FAN", ok, reason);
    return;
  }

  if (command == "PELTIER:ON") {
    String reason;
    const bool ok = setPeltierState(true, reason);
    if (!ok) sendDelta("SAFETY_REASON", reason);
    sendAck("PELTIER", ok, reason);
    return;
  }

  if (command == "PELTIER:OFF") {
    String reason;
    const bool ok = setPeltierState(false, reason);
    sendAck("PELTIER", ok, reason);
    return;
  }

  if (command == "ADAPTIVE:ON") {
    String reason;
    setAdaptiveState(true, reason);
    sendAck("ADAPTIVE", adaptiveOn, reason);
    return;
  }

  if (command == "ADAPTIVE:OFF") {
    String reason;
    setAdaptiveState(false, reason);
    sendAck("ADAPTIVE", true, reason);
    return;
  }

  if (command.startsWith("FANSPEED:")) {
    int value = 0;
    String reason;
    if (!parseIntRange(command.substring(9), FAN_PWM_MIN, FAN_PWM_MAX, value)) {
      sendAck("FANSPEED", false, "RANGE_50_100_STEP_10");
      return;
    }
    const bool ok = setFanSpeed(static_cast<uint8_t>(value), reason);
    sendAck("FANSPEED", ok, reason);
    return;
  }

  if (command.startsWith("RESET:")) {
    handleSettingsReset(command.substring(6));
    return;
  }

  if (command.startsWith("PHONE:BT=")) {
    float value = 0.0f;
    if (!parseFloatRange(command.substring(9), 0.0f, 100.0f, value)) {
      if (batteryValid || !isnan(batteryC)) {
        batteryValid = false;
        batteryC = NAN;
        lastBatteryZone = -1;
        adaptiveUpPending = false;
        adaptiveDownPending = false;
        sendDelta("BATTERY", "--");
        sendDelta("BATTERY_VALID", "0");
      }
      return;
    }

    if (!isfinite(value) || value < 0.0f || value > 100.0f) {
      if (batteryValid || !isnan(batteryC)) {
        batteryValid = false;
        batteryC = NAN;
        lastBatteryZone = -1;
        adaptiveUpPending = false;
        adaptiveDownPending = false;
        sendDelta("BATTERY", "--");
        sendDelta("BATTERY_VALID", "0");
      }
      return;
    }

    const int newZone = batteryZoneFor(value);
    const bool wasValid = batteryValid;
    const bool zoneChanged = !wasValid || newZone != lastBatteryZone;
    const bool valueChanged = !wasValid || isnan(batteryC) || fabsf(batteryC - value) > 0.05f;

    batteryC = value;
    batteryValid = true;
    lastBatteryRxMs = millis();

    if (valueChanged) sendDelta("BATTERY", formatTemperature(batteryC, true));
    if (!wasValid) sendDelta("BATTERY_VALID", "1");

    if (zoneChanged) {
      lastBatteryZone = newZone;
      if (adaptiveOn) evaluateAdaptiveBattery();
    }
    return;
  }

  sendAck("COMMAND", false, "UNKNOWN");
}

static void processPendingOnlineOtaStart() {
  if (!onlineOtaStartPending || otaActive || bootApActive) return;

  const bool queueDrained = bleTxCount == 0;
  const bool txSettled = queueDrained && millis() >= bleNextNotifyAt;
  const bool waitExpired = millis() - onlineOtaRequestedAt >= ONLINE_OTA_START_WAIT_MS;
  if (!txSettled && !waitExpired && bleClientConnected) return;

  onlineOtaStartPending = false;
  startOnlineOta();
}

static void executeTouchSingle() {
  if (otaActive || adaptiveOn) return;

  Voltage next = Voltage::V5;
  if (currentVoltage == Voltage::V5) next = Voltage::V9;
  else if (currentVoltage == Voltage::V9) next = Voltage::V12;

  const bool accepted = requestVoltage(next, VoltageRequestSource::TOUCH, false);
  sendAck("TOUCH_VOLTAGE", accepted,
          accepted ? "OK" : "VOLTAGE_GUARD_OR_BUSY");
}

static void executeTouchDouble() {
  if (otaActive) return;
  setRgbState(!rgbOn);
  sendAck("TOUCH_RGB", true, "OK");
}

static void executeTouchLong() {
  if (otaActive || adaptiveOn) return;

  if (fanOn && peltierOn) {
    fanOn = false;
    peltierOn = false;
    applyCoolingOutputs();
    sendAck("TOUCH_COOLING", true, "OFF");
    return;
  }

  fanOn = true;
  peltierOn = true;
  applyCoolingOutputs();
  sendAck("TOUCH_COOLING", peltierOn, peltierOn ? "ON" : safetyReason());
}

static void onTouchSingleClick() {
  executeTouchSingle();
}

static void onTouchDoubleClick() {
  executeTouchDouble();
}

static void onTouchLongPress() {
  executeTouchLong();
}

// ============================================================================
// ====================== OTA PRIORITY SUPERVISOR — LOCKED ====================
// Executed first by loop(). OTA gets control before normal feature processing.
// ============================================================================
static bool serviceOtaPriority() {
  if (otaState == OtaState::SUCCESS &&
      otaRestartAt != 0 &&
      millis() >= otaRestartAt) {
    ESP.restart();
    return true;
  }

  if (bootApActive) {
    webServer.handleClient();
    const uint8_t clientCount = WiFi.softAPgetStationNum();

    if (clientCount > 0 && !bootApHadClient) {
      bootApHadClient = true;
      bootApClientSafe = true;
      applyOtaSafeOutputs();
      stopUserLedOutput();
      stopBleForBootWiFiClient();
    } else if (clientCount == 0 &&
               otaState != OtaState::LOCAL_UPLOAD &&
               !otaActive &&
               millis() - bootApStartedAt >= BOOT_AP_TIMEOUT_MS) {
      stopLocalOtaAp();
      bootApClientSafe = false;
      bootApHadClient = false;
      bleStartPending = true;
      bleStartRetryAt = millis();
      return false;
    }

    if (bootApHadClient ||
        otaState == OtaState::LOCAL_UPLOAD ||
        otaActive) {
      processLeds();
    }
    return true;
  }

  if (otaState == OtaState::LOCAL_UPLOAD) {
    webServer.handleClient();
    processLeds();
    return true;
  }

  if (otaActive &&
      otaState != OtaState::SUCCESS &&
      otaState != OtaState::FAILED) {
    processOnlineOta();
    processLeds();
    return true;
  }

  return false;
}

static void setupTouch() {
  pinMode(PIN_TOUCH, INPUT);
  touchButton.setDebounceMs(50);
  touchButton.setClickMs(500);
  touchButton.setPressMs(5000);
  touchButton.attachClick(onTouchSingleClick);
  touchButton.attachDoubleClick(onTouchDoubleClick);
  touchButton.attachLongPressStart(onTouchLongPress);
}

void setup() {
  otaDiagnosticStage = "BOOT_AP";
  otaDiagnosticError = "NONE";
  otaDiagnosticErrorCode = 0;
  otaDiagnosticProgress = 0;
  otaDiagnosticLastPublishedProgress = 255;

  Serial.begin(115200);

  // Establish all power-control outputs OFF before starting OTA service.
  pinMode(PIN_12V, OUTPUT);
  pinMode(PIN_9V, OUTPUT);
  pinMode(PIN_FAN, OUTPUT);
  pinMode(PIN_PELTIER, OUTPUT);
  digitalWrite(PIN_12V, OUTPUT_OFF);
  digitalWrite(PIN_9V, OUTPUT_OFF);
  digitalWrite(PIN_FAN, OUTPUT_OFF);
  digitalWrite(PIN_PELTIER, OUTPUT_OFF);

  // OTA/AP starts before non-OTA feature initialization.
  startLocalOtaAp();

  pinMode(PIN_NTC, INPUT);
  pinMode(PIN_TOUCH, INPUT);
  setupTouch();

  analogReadResolution(12);
  analogSetPinAttenuation(PIN_NTC, ADC_11db);

  ledcAttach(PIN_FAN, FAN_PWM_FREQ, FAN_PWM_RESOLUTION);
  ledcWrite(PIN_FAN, 0);
  ledcAttach(PIN_PELTIER, PELTIER_PWM_FREQ, PELTIER_PWM_RESOLUTION);
  stopPeltierOutput();

  leds.begin();
  leds.clear();
  leds.show();
  resetLedAnimationState();

  loadSettings();

  currentVoltage = Voltage::V5;
  pendingVoltage = Voltage::V5;
  fanOn = false;
  peltierOn = false;
  adaptiveOn = false;
  adaptiveCeiling = Voltage::V12;
  fanPwm = 100;

  batteryValid = false;
  batteryC = NAN;
  lastBatteryZone = -1;
  ntcValid = false;
  hotsideC = NAN;

  lastNtcReadMs = millis() - NTC_READ_INTERVAL_MS;
  sampleNtcIfDue();
  enforceSafety();

  // BLE is started/retried by the radio supervisor after feature initialization.
  if (!bootApActive) {
    bleStartPending = true;
    bleStartRetryAt = millis();
  }
}

void loop() {

  // ================= OTA PRIORITY: DO NOT MOVE DOWN =================
  if (serviceOtaPriority()) return;

  serviceBleStartRecovery();

  if (bleQueueResetPending) {
    bleQueueResetPending = false;
    clearBleTxQueue();
    clearBleRxQueue();
  }

  if (bleSyncPending && bleClientConnected && txCharacteristic != nullptr) {
    bleSyncPending = false;
    clearBleTxQueue();
    sendFullSync();
  }

  serviceBleTx();
  processBleRxQueue();
  processPendingOnlineOtaStart();
  if (serviceOtaPriority()) return;

  touchButton.tick();
  sampleNtcIfDue();
  updateBatteryValidity();
  processAdaptiveHotTimer();
  processAdaptiveBatteryDown();
  processAdaptiveUpTimer();
  completeVoltageTransition();
  enforceSafety();
  processPeltierSoftStart();
  processSettingsPersistence();

  static uint32_t lastHotTelemetryMs = 0;
  if (millis() - lastHotTelemetryMs >= NTC_READ_INTERVAL_MS) {
    lastHotTelemetryMs = millis();
    sendHotsideTelemetry();
  }

  processLeds();
  serviceBleTx();

  yield();
}