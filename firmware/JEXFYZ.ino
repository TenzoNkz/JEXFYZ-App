#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <HTTPUpdate.h>
#include <Update.h>
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

static constexpr char FW_VERSION[] = "V4.6";

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
size_t localOtaExpectedBytes = UPDATE_SIZE_UNKNOWN;
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
static void failLocalOta(const String& stage, int errorCode, const String& error);
static void failOnlineOta(const String& stage, int errorCode, const String& error);

static const char* voltageToString(Voltage value) {
  switch (value) {
    case Voltage::V5:  return "5V";
    case Voltage::V9:  return "9V";
    case Voltage::V12: return "12V";
  }
  return "5V";
}

static Voltage voltageFromString(String value) {
  value.trim();
  value.toUpperCase();
  if (value == "12V") return Voltage::V12;
  if (value == "9V") return Voltage::V9;
  return Voltage::V5;
}

static bool isHigherVoltage(Voltage a, Voltage b) {
  return static_cast<uint8_t>(a) > static_cast<uint8_t>(b);
}

static Voltage lowerVoltage(Voltage value) {
  if (value == Voltage::V12) return Voltage::V9;
  return Voltage::V5;
}

static Voltage clampToAdaptiveCeiling(Voltage target) {
  return isHigherVoltage(target, adaptiveCeiling) ? adaptiveCeiling : target;
}

static String boolText(bool value) {
  return value ? "ON" : "OFF";
}

static String formatTemperature(float value, bool valid) {
  if (!valid || !isfinite(value)) return "--";
  return String(value, 1);
}

static String resetReasonText() {
  switch (esp_reset_reason()) {
    case ESP_RST_POWERON:   return "POWERON";
    case ESP_RST_EXT:       return "EXTERNAL";
    case ESP_RST_SW:        return "SOFTWARE";
    case ESP_RST_PANIC:     return "PANIC";
    case ESP_RST_INT_WDT:   return "INT_WDT";
    case ESP_RST_TASK_WDT:  return "TASK_WDT";
    case ESP_RST_WDT:       return "WDT";
    case ESP_RST_DEEPSLEEP: return "DEEPSLEEP";
    case ESP_RST_BROWNOUT:  return "BROWNOUT";
    case ESP_RST_SDIO:      return "SDIO";
    default:                return "UNKNOWN";
  }
}

static bool parseHexColor(String value, uint32_t& output) {
  value.trim();
  if (value.startsWith("#")) value.remove(0, 1);
  if (value.length() != 6) return false;

  uint32_t parsed = 0;
  for (size_t i = 0; i < 6; ++i) {
    const char c = value.charAt(i);
    uint8_t digit = 0;

    if (c >= '0' && c <= '9') {
      digit = static_cast<uint8_t>(c - '0');
    } else if (c >= 'A' && c <= 'F') {
      digit = static_cast<uint8_t>(c - 'A' + 10);
    } else if (c >= 'a' && c <= 'f') {
      digit = static_cast<uint8_t>(c - 'a' + 10);
    } else {
      return false;
    }

    parsed = (parsed << 4) | digit;
  }

  output = parsed;
  return true;
}

static String colorToHex(uint32_t color) {
  char buffer[8];
  snprintf(buffer, sizeof(buffer), "#%06lX", static_cast<unsigned long>(color & 0xFFFFFFUL));
  return String(buffer);
}

static bool parseIntRange(const String& raw, int minValue, int maxValue, int& output) {
  String value = raw;
  value.trim();
  if (value.isEmpty()) return false;

  bool negative = false;
  size_t index = 0;
  if (value.charAt(0) == '-') {
    negative = true;
    index = 1;
  }
  if (index >= value.length()) return false;

  long parsed = 0;
  for (; index < value.length(); ++index) {
    const char c = value.charAt(index);
    if (c < '0' || c > '9') return false;
    parsed = parsed * 10L + static_cast<long>(c - '0');
    if (parsed > 2147483647L) return false;
  }

  if (negative) parsed = -parsed;
  if (parsed < minValue || parsed > maxValue) return false;

  output = static_cast<int>(parsed);
  return true;
}

static bool parseFloatRange(const String& raw, float minValue, float maxValue, float& output) {
  String value = raw;
  value.trim();
  if (value.isEmpty()) return false;

  bool negative = false;
  bool decimalSeen = false;
  bool digitSeen = false;
  size_t index = 0;
  if (value.charAt(0) == '-') {
    negative = true;
    index = 1;
  }
  if (index >= value.length()) return false;

  double integerPart = 0.0;
  double fractionPart = 0.0;
  double fractionScale = 0.1;

  for (; index < value.length(); ++index) {
    const char c = value.charAt(index);
    if (c >= '0' && c <= '9') {
      digitSeen = true;
      const int digit = c - '0';
      if (!decimalSeen) {
        integerPart = integerPart * 10.0 + digit;
        if (integerPart > 1000000.0) return false;
      } else {
        fractionPart += digit * fractionScale;
        fractionScale *= 0.1;
      }
      continue;
    }

    if (c == '.' && !decimalSeen) {
      decimalSeen = true;
      continue;
    }

    return false;
  }

  if (!digitSeen) return false;
  double parsed = integerPart + fractionPart;
  if (negative) parsed = -parsed;
  if (parsed < minValue || parsed > maxValue) return false;

  output = static_cast<float>(parsed);
  return isfinite(output);
}

static void loadSettings() {
  prefsReady = prefs.begin("jexfyz", false);
  if (!prefsReady) return;

  hotLimit = constrain(prefs.getInt("hotLimit", 45), HOT_LIMIT_MIN, HOT_LIMIT_MAX);
  battery5Limit = constrain(
      prefs.getInt("batt5", 25),
      BATTERY_LIMIT_MIN,
      BATTERY5_LIMIT_MAX);
  battery12Limit = constrain(
      prefs.getInt("batt12", 35),
      BATTERY12_LIMIT_MIN,
      BATTERY12_LIMIT_MAX);

  if (battery12Limit < battery5Limit + 2) {
    battery12Limit = min(BATTERY12_LIMIT_MAX, battery5Limit + 2);
  }

  rgbOn = prefs.getBool("rgbOn", false);
  const int storedMode = prefs.getUChar("rgbMode", 1);
  rgbMode = static_cast<LedMode>(constrain(storedMode, 1, 8));
  rgbBrightness = prefs.getUChar("brightness", 100);
  if (rgbBrightness > 100) rgbBrightness = 100;

  rgbColor = prefs.getUInt("rgbColor", 0xFFFFFF);
  color5V = prefs.getUInt("color5V", 0xFF0000);
  color9V = prefs.getUInt("color9V", 0x00FF00);
  color12V = prefs.getUInt("color12V", 0x0000FF);

  otaResult = prefs.getString("lastOta", "NONE");
}

static void markSettingsDirty() {
  settingsDirty = true;
  settingsDirtyAt = millis();
}

static void saveSettingsNow() {
  if (!prefsReady) return;

  prefs.putInt("hotLimit", hotLimit);
  prefs.putInt("batt5", battery5Limit);
  prefs.putInt("batt12", battery12Limit);
  prefs.putBool("rgbOn", rgbOn);
  prefs.putUChar("rgbMode", static_cast<uint8_t>(rgbMode));
  prefs.putUChar("brightness", rgbBrightness);
  prefs.putUInt("rgbColor", rgbColor);
  prefs.putUInt("color5V", color5V);
  prefs.putUInt("color9V", color9V);
  prefs.putUInt("color12V", color12V);
  settingsDirty = false;
}

static void processSettingsPersistence() {
  if (settingsDirty && millis() - settingsDirtyAt >= SETTINGS_SAVE_DEBOUNCE_MS) {
    saveSettingsNow();
  }
}

static void saveOtaResult(const String& result) {
  otaResult = result;
  if (prefsReady) prefs.putString("lastOta", otaResult);
}

static uint8_t fanDutyFromPercent(uint8_t percent) {
  return static_cast<uint8_t>(lroundf((percent / 100.0f) * 255.0f));
}

static void writeFanPwm() {
  if (!fanOn) {
    ledcWrite(PIN_FAN, 0);
    return;
  }

  ledcWrite(PIN_FAN, fanDutyFromPercent(fanPwm));
}

static void stopPeltierOutput() {
  peltierSoftStarting = false;
  peltierSoftStartAtMs = 0;
  ledcWrite(PIN_PELTIER, 0);
}

static void beginPeltierSoftStart() {
  peltierSoftStarting = true;
  peltierSoftStartAtMs = millis();
  ledcWrite(PIN_PELTIER, 0);
}

static void processPeltierSoftStart() {
  if (!peltierOn) {
    stopPeltierOutput();
    return;
  }

  if (!peltierSoftStarting) {
    ledcWrite(PIN_PELTIER, 255);
    return;
  }

  const uint32_t elapsed = millis() - peltierSoftStartAtMs;
  if (elapsed >= PELTIER_SOFT_START_MS) {
    peltierSoftStarting = false;
    ledcWrite(PIN_PELTIER, 255);
    return;
  }

  const uint32_t duty = (elapsed * 255UL) / PELTIER_SOFT_START_MS;
  ledcWrite(PIN_PELTIER, static_cast<uint32_t>(duty));
}

static bool hotsideProtectionActiveNow() {
  return ntcValid && isfinite(hotsideC) && hotsideC >= static_cast<float>(hotLimit);
}

static bool safetyAllowsPeltier() {
  if (otaActive) return false;
  if (!ntcValid) return false;
  if (hotsideProtectionActiveNow()) return false;
  if (!fanOn) return false;

  if (adaptiveOn &&
      peltierHotOffUntilMs != 0 &&
      millis() < peltierHotOffUntilMs) {
    return false;
  }

  return true;
}

static void applyCoolingOutputs() {
  const bool previousFan = fanOn;
  const bool previousPeltier = peltierOn;
  const uint8_t previousPwm = fanPwm;

  if (!ntcValid) {
    fanOn = true;
    fanPwm = 100;
    peltierOn = false;
  }

  if (!fanOn) peltierOn = false;
  if (peltierOn && !safetyAllowsPeltier()) peltierOn = false;

  if (peltierOn && !previousPeltier) {
    beginPeltierSoftStart();
  } else if (!peltierOn) {
    stopPeltierOutput();
  }

  processPeltierSoftStart();
  writeFanPwm();

  if (fanOn != previousFan || peltierOn != previousPeltier || fanPwm != previousPwm) {
    ++stateSequence;
  }
  if (fanOn != previousFan) sendDelta("FAN", boolText(fanOn));
  if (peltierOn != previousPeltier) sendDelta("PELTIER", boolText(peltierOn));
  if (fanPwm != previousPwm) sendDelta("FAN_SPEED", String(fanPwm));
}

static constexpr uint8_t LEFT_PIXELS[4] = {0, 1, 2, 3};
static constexpr uint8_t RIGHT_PIXELS[4] = {7, 6, 5, 4};

static uint32_t scaleColor(uint32_t color, uint8_t brightness) {
  const uint8_t r = static_cast<uint8_t>((((color >> 16) & 0xFFU) * brightness) / 255U);
  const uint8_t g = static_cast<uint8_t>((((color >> 8) & 0xFFU) * brightness) / 255U);
  const uint8_t b = static_cast<uint8_t>(((color & 0xFFU) * brightness) / 255U);
  return leds.Color(r, g, b);
}

static uint32_t blendLevel(uint32_t color, uint8_t baseBrightness, float level) {
  if (level <= 0.0f) return 0;
  if (level > 1.0f) level = 1.0f;
  const uint8_t brightness = static_cast<uint8_t>(lroundf(baseBrightness * level));
  return scaleColor(color, brightness);
}

static void showAll(uint32_t color, uint8_t brightness) {
  const uint32_t scaled = scaleColor(color, brightness);
  for (uint8_t i = 0; i < LED_COUNT; ++i) {
    leds.setPixelColor(i, scaled);
  }
  leds.show();
}

static uint32_t currentVoltageColor() {
  switch (currentVoltage) {
    case Voltage::V5:  return color5V;
    case Voltage::V9:  return color9V;
    case Voltage::V12: return color12V;
  }
  return color5V;
}

static uint8_t hardwareBrightness() {
  return static_cast<uint8_t>(map(rgbBrightness, 0, 100, 0, 255));
}

static void clearAllLeds() {
  leds.clear();
  leds.show();
}

static void stopUserLedOutput() {
  clearAllLeds();
  lastLedFrameAtMs = 0;
  twinkleUpdateAtMs = 0;
  for (uint8_t i = 0; i < LED_COUNT; ++i) twinkleLevel[i] = 0;
}

static void resetLedAnimationState() {
  lastLedFrameAtMs = 0;
  twinkleUpdateAtMs = 0;
  for (uint8_t i = 0; i < LED_COUNT; ++i) twinkleLevel[i] = 0;
}

static void startUserLedEffect() {
  resetLedAnimationState();
}

static void renderBlink(uint32_t color) {
  if (millis() - ledBlinkAt < 250) return;

  ledBlinkAt = millis();
  ledBlinkPhase = !ledBlinkPhase;
  showAll(ledBlinkPhase ? color : 0x000000, 255);
}

static void resetBlinkState() {
  ledBlinkAt = 0;
  ledBlinkPhase = false;
}

static void startVoltageIndicator() {
  if (!rgbOn) {
    voltageIndicatorActive = false;
    stopUserLedOutput();
    return;
  }

  voltageIndicatorActive = true;
  voltageIndicatorUntil = millis() + 1000;
  showAll(currentVoltageColor(), hardwareBrightness());
}

static void renderCustomLedFrame(uint32_t now) {
  if (now - lastLedFrameAtMs < LED_FRAME_INTERVAL_MS) return;
  lastLedFrameAtMs = now;

  leds.clear();
  const uint8_t baseBrightness = hardwareBrightness();
  const uint32_t baseColor = rgbColor;

  switch (rgbMode) {
    case LedMode::STATIC: {
      const uint32_t color = scaleColor(baseColor, baseBrightness);
      for (uint8_t i = 0; i < LED_COUNT; ++i) leds.setPixelColor(i, color);
      break;
    }

    case LedMode::BREATH: {
      const float phase = (now % 2200UL) / 2200.0f;
      const float level = 0.12f + 0.88f * (0.5f + 0.5f * sinf(phase * 2.0f * PI));
      const uint32_t color = blendLevel(baseColor, baseBrightness, level);
      for (uint8_t i = 0; i < LED_COUNT; ++i) leds.setPixelColor(i, color);
      break;
    }

    case LedMode::CENTER_OUT: {
      const float progress = (now % 1600UL) / 400.0f;
      for (uint8_t pair = 0; pair < 4; ++pair) {
        const float distance = static_cast<float>(pair);
        float level = 0.0f;
        if (progress >= distance) level = 1.0f;
        else if (progress > distance - 1.0f) level = progress - distance + 1.0f;
        const uint32_t color = blendLevel(baseColor, baseBrightness, level);
        leds.setPixelColor(LEFT_PIXELS[3 - pair], color);
        leds.setPixelColor(RIGHT_PIXELS[3 - pair], color);
      }
      break;
    }

    case LedMode::OUTER_IN: {
      const float progress = (now % 1600UL) / 400.0f;
      for (uint8_t pair = 0; pair < 4; ++pair) {
        const float distance = static_cast<float>(pair);
        float level = 0.0f;
        if (progress >= distance) level = 1.0f;
        else if (progress > distance - 1.0f) level = progress - distance + 1.0f;
        const uint32_t color = blendLevel(baseColor, baseBrightness, level);
        leds.setPixelColor(LEFT_PIXELS[pair], color);
        leds.setPixelColor(RIGHT_PIXELS[pair], color);
      }
      break;
    }

    case LedMode::DUAL_CHASE: {
      static constexpr uint8_t sequence[] = {0, 1, 2, 3, 2, 1};
      const uint8_t position = static_cast<uint8_t>((now / 150UL) % 6U);
      const uint8_t pair = sequence[position];
      leds.setPixelColor(LEFT_PIXELS[pair], scaleColor(baseColor, baseBrightness));
      leds.setPixelColor(RIGHT_PIXELS[pair], scaleColor(baseColor, baseBrightness));
      break;
    }

    case LedMode::LEFT_RIGHT: {
      const float phase = (now % 1800UL) / 1800.0f;
      const float wave = 0.5f + 0.5f * sinf(phase * 2.0f * PI);
      const float leftLevel = 0.10f + 0.90f * wave;
      const float rightLevel = 0.10f + 0.90f * (1.0f - wave);
      const uint32_t leftColor = blendLevel(baseColor, baseBrightness, leftLevel);
      const uint32_t rightColor = blendLevel(baseColor, baseBrightness, rightLevel);
      for (uint8_t i = 0; i < 4; ++i) {
        leds.setPixelColor(LEFT_PIXELS[i], leftColor);
        leds.setPixelColor(RIGHT_PIXELS[i], rightColor);
      }
      break;
    }

    case LedMode::RAINBOW: {
      const uint16_t offset = static_cast<uint16_t>((now / 10UL) & 0xFFFFU);
      for (uint8_t logical = 0; logical < LED_COUNT; ++logical) {
        const uint16_t hue = static_cast<uint16_t>(offset + logical * 8192U);
        leds.setPixelColor(logical, Adafruit_NeoPixel::ColorHSV(hue, 255, baseBrightness));
      }
      break;
    }

    case LedMode::TWINKLE: {
      if (now - twinkleUpdateAtMs >= 70) {
        twinkleUpdateAtMs = now;
        for (uint8_t i = 0; i < LED_COUNT; ++i) {
          if (twinkleLevel[i] > 18) twinkleLevel[i] = static_cast<uint8_t>(twinkleLevel[i] - 18);
          else twinkleLevel[i] = 0;
        }
        const uint8_t sparkCount = 1 + static_cast<uint8_t>(random(2));
        for (uint8_t n = 0; n < sparkCount; ++n) {
          const uint8_t pixel = static_cast<uint8_t>(random(LED_COUNT));
          twinkleLevel[pixel] = 140 + static_cast<uint8_t>(random(116));
        }
      }
      for (uint8_t i = 0; i < LED_COUNT; ++i) {
        const uint8_t level = twinkleLevel[i];
        leds.setPixelColor(i, scaleColor(baseColor, static_cast<uint8_t>((baseBrightness * level) / 255U)));
      }
      break;
    }
  }

  leds.show();
}

static void processLeds() {
  if (otaState == OtaState::SUCCESS) {
    renderBlink(0x00FF00);
    return;
  }

  if (otaState == OtaState::FAILED) {
    if (millis() < otaFailureIndicatorUntil) {
      renderBlink(0xFF0000);
      return;
    }

    resetBlinkState();
    setOtaState(bootApActive ? OtaState::BOOT_AP : OtaState::IDLE);
    if (!bootApActive && !otaActive) startUserLedEffect();
    return;
  }

  if (otaState == OtaState::CLOUD_CONNECTING ||
      otaState == OtaState::CLOUD_DOWNLOADING ||
      otaState == OtaState::CLOUD_APPLYING) {
    renderBlink(0x0000FF);
    return;
  }

  if (bootApClientSafe || otaActive || otaState == OtaState::LOCAL_UPLOAD) {
    stopUserLedOutput();
    return;
  }

  if (!ntcValid || hotsideProtectionActiveNow()) {
    renderBlink(0xFF0000);
    return;
  }

  if (!rgbOn) {
    stopUserLedOutput();
    return;
  }

  if (voltageIndicatorActive) {
    if (millis() >= voltageIndicatorUntil) {
      voltageIndicatorActive = false;
      startUserLedEffect();
    } else if (millis() - lastLedFrameAtMs >= LED_FRAME_INTERVAL_MS) {
      lastLedFrameAtMs = millis();
      showAll(currentVoltageColor(), hardwareBrightness());
    }
    return;
  }

  renderCustomLedFrame(millis());
}

static bool voltageGuardAllows(bool bypassGuard) {
  if (bypassGuard || !voltageGuardArmed) return true;

  return millis() - lastVoltageChangeMs >= VOLTAGE_GUARD_MS;
}

static bool manualVoltageRequestAllowed(VoltageRequestSource source) {  if (!adaptiveOn) return true;
  return source == VoltageRequestSource::BATTERY ||
         source == VoltageRequestSource::HOTSTEP ||
         source == VoltageRequestSource::ADAPTIVE ||
         source == VoltageRequestSource::SAFETY;
}

static bool requestVoltage(Voltage target, VoltageRequestSource source, bool bypassGuard) {
  if (otaActive || voltageTransition) return false;
  if (!manualVoltageRequestAllowed(source)) return false;
  if (!voltageGuardAllows(bypassGuard)) return false;

  if (!ntcValid && target != Voltage::V5) return false;

  if (adaptiveOn) {
    target = clampToAdaptiveCeiling(target);
  }

  if (target == currentVoltage) return true;

  if (!bypassGuard) {
    voltageGuardArmed = true;
    lastVoltageChangeMs = millis();
  }

  pendingVoltage = target;
  voltageTransition = true;
  voltageTransitionAt = millis();

  digitalWrite(PIN_9V, OUTPUT_OFF);
  digitalWrite(PIN_12V, OUTPUT_OFF);

  return true;
}

static void completeVoltageTransition() {
  if (!voltageTransition) return;
  if (millis() - voltageTransitionAt < VOLTAGE_DEADTIME_MS) return;

  currentVoltage = pendingVoltage;
  digitalWrite(PIN_9V, currentVoltage == Voltage::V9 ? OUTPUT_ON : OUTPUT_OFF);
  digitalWrite(PIN_12V, currentVoltage == Voltage::V12 ? OUTPUT_ON : OUTPUT_OFF);

  voltageTransition = false;

  if (!voltageGuardArmed) {
    voltageGuardArmed = true;
    lastVoltageChangeMs = millis();
  }

  if (currentVoltage != Voltage::V12 || adaptiveOn) {
    fanPwm = 100;
  }

  applyCoolingOutputs();
  startVoltageIndicator();

  ++stateSequence;
  sendDelta("VOLTAGE", voltageToString(currentVoltage));

  if (adaptiveOn && currentVoltage == Voltage::V5 && batteryValid && ntcValid) {
    evaluateAdaptiveBattery();
  }
}

static float ntcTemperatureFromOhms(float ohms) {
  const float t0 = NTC_NOMINAL_C + 273.15f;
  const float invT = (1.0f / t0) + (logf(ohms / NTC_NOMINAL_OHMS) / NTC_BETA);
  return (1.0f / invT) - 273.15f;
}

static void sampleNtcIfDue() {
  if (millis() - lastNtcReadMs < NTC_READ_INTERVAL_MS) return;
  lastNtcReadMs = millis();

  ntcMv = analogReadMilliVolts(PIN_NTC);

  if (ntcMv <= NTC_FAULT_LOW_MV || ntcMv >= NTC_FAULT_HIGH_MV) {
    ntcValid = false;
    hotsideC = NAN;
    return;
  }

  const float voltage = ntcMv / 1000.0f;
  const float ntcOhms = NTC_FIXED_OHMS * ((3.3f / voltage) - 1.0f);

  if (!isfinite(ntcOhms) || ntcOhms <= 1.0f) {
    ntcValid = false;
    hotsideC = NAN;
    return;
  }

  const float temperature = ntcTemperatureFromOhms(ntcOhms);
  if (!isfinite(temperature)) {
    ntcValid = false;
    hotsideC = NAN;
    return;
  }

  ntcValid = true;
  hotsideC = temperature;
}

static void forceSafeFiveVolt() {
  const bool previousAdaptive = adaptiveOn;
  const Voltage previousCeiling = adaptiveCeiling;
  const uint8_t previousPwm = fanPwm;
  const bool previousFan = fanOn;
  const bool previousPeltier = peltierOn;

  adaptiveUpPending = false;
  adaptiveDownPending = false;
  adaptiveHotStepPending = false;
  peltierHotOffUntilMs = 0;
  adaptiveResumePeltierAfterHotStep = false;

  fanOn = true;
  peltierOn = false;
  peltierSoftStarting = false;
  peltierSoftStartAtMs = 0;
  adaptiveOn = false;
  adaptiveCeiling = Voltage::V12;
  fanPwm = 100;

  if (voltageTransition) {

    pendingVoltage = Voltage::V5;
  } else if (currentVoltage != Voltage::V5) {
    requestVoltage(Voltage::V5, VoltageRequestSource::SAFETY, true);
  }

  applyCoolingOutputs();

  if (previousFan != fanOn) sendDelta("FAN", boolText(fanOn));
  if (previousPeltier != peltierOn) sendDelta("PELTIER", boolText(peltierOn));
  if (previousAdaptive != adaptiveOn) sendDelta("ADAPTIVE", boolText(adaptiveOn));
  if (previousCeiling != adaptiveCeiling) {
    sendDelta("ADAPTIVE_CEILING", voltageToString(adaptiveCeiling));
  }
  if (previousPwm != fanPwm) sendDelta("FAN_SPEED", String(fanPwm));
  publishSafetyReason();
}

static void enforceSafety() {
  if (!ntcValid) {
    forceSafeFiveVolt();
    hotProtectionActive = false;
    return;
  }

  hotProtectionActive = hotsideProtectionActiveNow();

  if (hotProtectionActive) {
    const bool wasPeltierOn = peltierOn;
    const bool wasFanOn = fanOn;
    const uint8_t wasFanPwm = fanPwm;

    fanOn = true;
    fanPwm = 100;
    if (peltierOn) {
      peltierOn = false;
      stopPeltierOutput();
      sendDelta("PELTIER", "OFF");
    }
    if (!wasFanOn) sendDelta("FAN", "ON");
    if (wasFanPwm != 100) sendDelta("FAN_SPEED", "100");

    if (adaptiveOn && !adaptiveHotStepPending) {
      const uint32_t now = millis();

      adaptiveHotStepPending = true;
      peltierHotOffUntilMs = now + HOT_PELTIER_OFF_MS;
      adaptiveHotStepDueMs = peltierHotOffUntilMs;

      if (!adaptiveResumePeltierAfterHotStep) {
        adaptiveResumePeltierAfterHotStep = fanOn && wasPeltierOn;
      }

      adaptiveUpPending = false;
      adaptiveDownPending = false;
    }
  }

  if (adaptiveResumePeltierAfterHotStep &&
      adaptiveOn &&
      fanOn &&
      !voltageTransition &&
      peltierHotOffUntilMs != 0 &&
      millis() >= peltierHotOffUntilMs &&
      !hotsideProtectionActiveNow()) {
    adaptiveResumePeltierAfterHotStep = false;
    peltierHotOffUntilMs = 0;
    peltierOn = true;
  }

  if (peltierOn && !fanOn) {
    peltierOn = false;
    stopPeltierOutput();
  }

  applyCoolingOutputs();
}

static void processAdaptiveHotTimer() {
  if (!adaptiveOn || !ntcValid || !adaptiveHotStepPending) return;
  if (voltageTransition) return;
  if (millis() < adaptiveHotStepDueMs) return;

  adaptiveHotStepPending = false;
  adaptiveUpPending = false;
  adaptiveDownPending = false;
  const bool wasPeltierOn = peltierOn;
  peltierOn = false;
  stopPeltierOutput();
  if (wasPeltierOn) sendDelta("PELTIER", "OFF");

  if (!hotsideProtectionActiveNow()) {
    const bool resume = adaptiveResumePeltierAfterHotStep && fanOn;

    adaptiveResumePeltierAfterHotStep = false;
    peltierHotOffUntilMs = 0;

    if (resume) {
      peltierOn = true;
    }

    applyCoolingOutputs();
    return;
  }

  if (currentVoltage == Voltage::V12) {
    adaptiveCeiling = Voltage::V9;
    sendDelta("ADAPTIVE_CEILING", "9V");
  } else if (currentVoltage == Voltage::V9) {
    adaptiveCeiling = Voltage::V5;
    sendDelta("ADAPTIVE_CEILING", "5V");
  } else {

    adaptiveOn = false;
    adaptiveCeiling = Voltage::V12;
    adaptiveResumePeltierAfterHotStep = false;
    peltierHotOffUntilMs = 0;
    fanPwm = 100;

    applyCoolingOutputs();
    sendDelta("ADAPTIVE", "OFF");
    sendDelta("ADAPTIVE_CEILING", voltageToString(adaptiveCeiling));
    sendDelta("FAN_SPEED", String(fanPwm));
    return;
  }

  const Voltage target = lowerVoltage(currentVoltage);
  const bool accepted = requestVoltage(target, VoltageRequestSource::HOTSTEP, true);

  if (!accepted) {

    sendDelta("SAFETY_REASON", "VOLTAGE_STEP_FAILED");
  }
}

static String safetyReason() {
  if (!ntcValid) return "NTC_ERROR";
  if (hotsideProtectionActiveNow()) return "HOTSIDE_PROTECTION";
  if (peltierOn && !fanOn) return "FAN_REQUIRED";
  return "NONE";
}

static int batteryZoneFor(float temperature) {
  if (temperature < battery5Limit) return 5;
  if (temperature < battery12Limit) return 9;
  return 12;
}

static Voltage batteryZoneVoltage(int zone) {
  if (zone >= 12) return Voltage::V12;
  if (zone >= 9) return Voltage::V9;
  return Voltage::V5;
}

static void updateBatteryValidity() {
  if (!batteryValid) return;
  if (millis() - lastBatteryRxMs <= BATTERY_VALID_TTL_MS) return;

  batteryValid = false;
  batteryC = NAN;
  lastBatteryZone = -1;
  adaptiveUpPending = false;
  adaptiveDownPending = false;
  sendDelta("BATTERY", "--");
  sendDelta("BATTERY_VALID", "0");
}

static void scheduleAdaptiveBatteryTarget(Voltage target) {
  target = clampToAdaptiveCeiling(target);

  if (target == currentVoltage) {
    adaptiveUpPending = false;
    adaptiveDownPending = false;
    return;
  }

  if (isHigherVoltage(target, currentVoltage)) {
    adaptiveDownPending = false;
    adaptiveUpPending = true;
    adaptiveUpTarget = target;
    adaptiveUpDueMs = millis() + ADAPTIVE_UPWARD_DELAY_MS;
    return;
  }

  adaptiveUpPending = false;
  if (!requestVoltage(target, VoltageRequestSource::BATTERY, false)) {
    adaptiveDownPending = true;
    adaptiveDownTarget = target;
  }
}

static void evaluateAdaptiveBattery() {
  if (!adaptiveOn || !ntcValid || !batteryValid) return;
  if (adaptiveHotStepPending || hotsideProtectionActiveNow()) return;

  const int zone = batteryZoneFor(batteryC);
  if (zone == lastBatteryZone) return;

  lastBatteryZone = zone;
  scheduleAdaptiveBatteryTarget(batteryZoneVoltage(zone));
}

static void processAdaptiveBatteryDown() {
  if (!adaptiveOn || !ntcValid || !batteryValid) return;
  if (adaptiveHotStepPending || !adaptiveDownPending || voltageTransition) return;
  if (hotsideProtectionActiveNow()) return;

  const Voltage liveTarget = clampToAdaptiveCeiling(batteryZoneVoltage(batteryZoneFor(batteryC)));

  if (liveTarget == currentVoltage) {
    adaptiveDownPending = false;
    return;
  }

  if (isHigherVoltage(liveTarget, currentVoltage)) {
    adaptiveDownPending = false;
    scheduleAdaptiveBatteryTarget(liveTarget);
    return;
  }

  adaptiveDownTarget = liveTarget;
  if (requestVoltage(adaptiveDownTarget, VoltageRequestSource::BATTERY, false)) {
    adaptiveDownPending = false;
  }
}

static void processAdaptiveUpTimer() {
  if (!adaptiveOn || !ntcValid || !batteryValid) return;
  if (adaptiveHotStepPending || !adaptiveUpPending || voltageTransition) return;

  if (hotsideProtectionActiveNow()) {
    adaptiveUpPending = false;
    return;
  }

  const Voltage liveTarget = clampToAdaptiveCeiling(batteryZoneVoltage(batteryZoneFor(batteryC)));
  if (liveTarget != adaptiveUpTarget) {
    adaptiveUpTarget = liveTarget;
    adaptiveUpDueMs = millis() + ADAPTIVE_UPWARD_DELAY_MS;
    return;
  }

  if (millis() < adaptiveUpDueMs) return;

  if (requestVoltage(adaptiveUpTarget, VoltageRequestSource::BATTERY, false)) {
    adaptiveUpPending = false;
  }
}

static void clearBleTxQueue() {
  portENTER_CRITICAL(&bleQueueMux);
  for (size_t i = 0; i < BLE_TX_QUEUE_SIZE; ++i) bleTxQueue[i] = "";
  bleTxHead = 0;
  bleTxTail = 0;
  bleTxCount = 0;
  bleNextNotifyAt = millis();
  portEXIT_CRITICAL(&bleQueueMux);
}

static void clearBleRxQueue() {
  portENTER_CRITICAL(&bleQueueMux);
  for (size_t i = 0; i < BLE_RX_QUEUE_SIZE; ++i) bleRxQueue[i] = "";
  bleRxHead = 0;
  bleRxTail = 0;
  bleRxCount = 0;
  portEXIT_CRITICAL(&bleQueueMux);
}

static void enqueueBleRxPayload(const String& payload) {
  if (payload.isEmpty()) return;
  portENTER_CRITICAL(&bleQueueMux);
  if (bleRxCount < BLE_RX_QUEUE_SIZE) {
    bleRxQueue[bleRxTail] = payload;
    bleRxTail = (bleRxTail + 1) % BLE_RX_QUEUE_SIZE;
    ++bleRxCount;
  }
  portEXIT_CRITICAL(&bleQueueMux);
}

static void processBleRxQueue() {
  if (!bleClientConnected) {
    clearBleRxQueue();
    return;
  }

  String payload;
  portENTER_CRITICAL(&bleQueueMux);
  if (bleRxCount > 0) {
    payload = bleRxQueue[bleRxHead];
    bleRxQueue[bleRxHead] = "";
    bleRxHead = (bleRxHead + 1) % BLE_RX_QUEUE_SIZE;
    --bleRxCount;
  }
  portEXIT_CRITICAL(&bleQueueMux);

  if (!payload.isEmpty()) feedBleRx(payload);
}

static void sendText(const String& line) {
  if (txCharacteristic == nullptr || !BLEDevice::getInitialized()) return;
  if (!bleClientConnected || line.isEmpty()) return;

  String payload = line;
  if (payload.length() > 177) payload = payload.substring(0, 177);
  payload += '\n';

  portENTER_CRITICAL(&bleQueueMux);
  if (bleTxCount < BLE_TX_QUEUE_SIZE) {
    bleTxQueue[bleTxTail] = payload;
    bleTxTail = (bleTxTail + 1) % BLE_TX_QUEUE_SIZE;
    ++bleTxCount;
  }
  portEXIT_CRITICAL(&bleQueueMux);
}

static void serviceBleTx() {
  if (bleQueueResetPending) {
    bleQueueResetPending = false;
    clearBleTxQueue();
    clearBleRxQueue();
  }

  if (!bleClientConnected || txCharacteristic == nullptr || !BLEDevice::getInitialized()) {
    return;
  }
  if (millis() < bleNextNotifyAt) return;

  String payload;
  portENTER_CRITICAL(&bleQueueMux);
  if (bleTxCount > 0) {
    payload = bleTxQueue[bleTxHead];
    bleTxQueue[bleTxHead] = "";
    bleTxHead = (bleTxHead + 1) % BLE_TX_QUEUE_SIZE;
    --bleTxCount;
  }
  portEXIT_CRITICAL(&bleQueueMux);

  if (payload.isEmpty()) return;
  txCharacteristic->setValue(payload);
  txCharacteristic->notify();
  if (payload.startsWith("<SYNC_END>")) {
  }
  bleNextNotifyAt = millis() + BLE_TX_INTERVAL_MS;
}

static void sendDelta(const char* key, const String& value) {
  sendText(String(key) + ":" + value);
}

static void sendAck(const String& item, bool ok, const String& reason) {
  sendText("ACK:" + item + "=" + (ok ? "OK" : "DENIED") + ";REASON=" + reason);
}

static const char* otaStateText(OtaState state) {
  switch (state) {
    case OtaState::BOOT_AP:          return "BOOT_AP";
    case OtaState::LOCAL_UPLOAD:     return "LOCAL_UPLOAD";
    case OtaState::CLOUD_CONNECTING: return "CLOUD_CONNECTING";
    case OtaState::CLOUD_DOWNLOADING:return "CLOUD_DOWNLOADING";
    case OtaState::CLOUD_APPLYING:   return "CLOUD_APPLYING";
    case OtaState::SUCCESS:          return "SUCCESS";
    case OtaState::FAILED:           return "FAILED";
    case OtaState::IDLE:             return "IDLE";
  }
  return "IDLE";
}

// ====================== OTA DIAGNOSTIC CORE — LOCKED ========================
static String sanitizeOtaDetail(String value) {
  value.replace("|", "/");
  value.replace("\r", " ");
  value.replace("\n", " ");
  value.trim();
  if (value.isEmpty()) value = "UNKNOWN";
  if (value.length() > 96) value = value.substring(0, 96);
  return value;
}

static void setOtaDiagnosticStage(const String& stage) {
  otaDiagnosticStage = stage;
  if (bleClientConnected) {
    sendDelta("OTA_STAGE", otaDiagnosticStage);
  }
}

static void setOtaDiagnosticProgress(uint8_t progress) {
  progress = constrain(progress, static_cast<uint8_t>(0), static_cast<uint8_t>(100));
  otaDiagnosticProgress = progress;
  if (bleClientConnected &&
      (otaDiagnosticLastPublishedProgress == 255 ||
       progress == 0 ||
       progress == 100 ||
       progress >= otaDiagnosticLastPublishedProgress + 5)) {
    otaDiagnosticLastPublishedProgress = progress;
    sendDelta("OTA_PROGRESS", String(progress));
  }
}

static void setOtaDiagnosticError(int errorCode, const String& error) {
  otaDiagnosticErrorCode = errorCode;
  otaDiagnosticError = sanitizeOtaDetail(error);
  if (bleClientConnected) {
    sendDelta("OTA_ERROR_CODE", String(otaDiagnosticErrorCode));
    sendDelta("OTA_ERROR", otaDiagnosticError);
  }
}

static String otaFailureResult(
    const String& mode,
    const String& stage,
    int errorCode,
    const String& error,
    uint8_t progress) {
  return "OTA_FAILED|MODE=" + mode +
         "|STAGE=" + stage +
         "|CODE=" + String(errorCode) +
         "|ERROR=" + sanitizeOtaDetail(error) +
         "|PROGRESS=" + String(progress);
}

static String otaSuccessResult(
    const String& mode,
    const String& stage,
    const String& version) {
  return "OTA_SUCCESS|MODE=" + mode +
         "|STAGE=" + stage +
         "|VERSION=" + sanitizeOtaDetail(version) +
         "|PROGRESS=100";
}

static String otaUpdateFailureStage(bool online, int errorCode) {
  const String prefix = online ? "ONLINE_" : "LOCAL_";
  switch (errorCode) {
    case UPDATE_ERROR_READ: return prefix + "FLASH_READBACK";
    case UPDATE_ERROR_WRITE: return prefix + "FLASH_WRITE";
    case UPDATE_ERROR_ERASE: return prefix + "FLASH_ERASE";
    case UPDATE_ERROR_ACTIVATE: return prefix + "BOOT_PARTITION";
    case UPDATE_ERROR_MAGIC_BYTE: return prefix + "IMAGE_VALIDATE";
    case UPDATE_ERROR_MD5:
    case UPDATE_ERROR_SHA256:
    case UPDATE_ERROR_SHA512:
    case UPDATE_ERROR_SIGN: return prefix + "IMAGE_VERIFY";
    case UPDATE_ERROR_STREAM: return prefix + "DOWNLOAD";
    case UPDATE_ERROR_SPACE:
    case UPDATE_ERROR_SIZE:
    case UPDATE_ERROR_NO_PARTITION:
    case UPDATE_ERROR_BAD_ARGUMENT: return prefix + "UPDATE_BEGIN";
    default: return prefix + "FINALIZE";
  }
}

// ================= END OTA DIAGNOSTIC CORE — LOCKED ========================
static void setOtaState(OtaState state) {
  if (otaState == state) return;
  otaState = state;
  sendDelta("OTA_STATE", otaStateText(otaState));
}

static void sendFullSync() {
  clearBleTxQueue();
  sendText("<SYNC_START>");
  sendDelta("STATE_SEQ", String(stateSequence));
  sendDelta("VERSION", FW_VERSION);
  sendDelta("PROTOCOL", PROTOCOL_VERSION);
  sendDelta("BLE_SESSION", bleCommandGateOpen ? "READY" : "SYNC_REQUIRED");
  sendDelta("VOLTAGE", voltageToString(currentVoltage));
  sendDelta("FAN", boolText(fanOn));
  sendDelta("PELTIER", boolText(peltierOn));
  sendDelta("HOT", formatTemperature(hotsideC, ntcValid));
  sendDelta("BATTERY", formatTemperature(batteryC, batteryValid));
  sendDelta("BATTERY_VALID", batteryValid ? "1" : "0");
  sendDelta("ADAPTIVE", boolText(adaptiveOn));
  sendDelta("ADAPTIVE_CEILING", voltageToString(adaptiveCeiling));
  sendDelta("RGB", boolText(rgbOn));
  sendDelta("MODE", String(static_cast<uint8_t>(rgbMode)));
  sendDelta("BRIGHTNESS", String(rgbBrightness));
  sendDelta("RGB_COLOR", colorToHex(rgbColor));
  sendDelta("COLOR_5V", colorToHex(color5V));
  sendDelta("COLOR_9V", colorToHex(color9V));
  sendDelta("COLOR_12V", colorToHex(color12V));
  sendDelta("FAN_SPEED", String(fanPwm));
  const String reason = safetyReason();
  sendDelta("SAFETY", reason == "NONE" ? "OK" : "LOCKED");
  lastSafetyReasonSent = reason;
  sendDelta("SAFETY_REASON", reason);
  sendDelta("OTA_STATE", otaStateText(otaState));
  sendDelta("OTA_STAGE", otaDiagnosticStage);
  sendDelta("OTA_PROGRESS", String(otaDiagnosticProgress));
  sendDelta("OTA_ERROR_CODE", String(otaDiagnosticErrorCode));
  sendDelta("OTA_ERROR", otaDiagnosticError);
  sendDelta("LAST_OTA_RESULT", otaResult);
  sendDelta("RESET_REASON", resetReasonText());
  sendDelta("TEMP_HOT_LIMIT", String(hotLimit));
  sendDelta("BATT_5", String(battery5Limit));
  sendDelta("BATT_12", String(battery12Limit));
  sendDelta("NTC_MV", String(ntcMv));
  sendText("<SYNC_END>");
}

static void publishSafetyReason() {
  const String reason = safetyReason();
  if (reason != lastSafetyReasonSent) {
    lastSafetyReasonSent = reason;
    sendDelta("SAFETY", reason == "NONE" ? "OK" : "LOCKED");
    sendDelta("SAFETY_REASON", reason);
  }
}

static void sendHotsideTelemetry() {

  sendDelta("HOT", formatTemperature(hotsideC, ntcValid));
  publishSafetyReason();
}

static bool isUserControlCommand(const String& raw) {
  String c = raw;
  c.trim();
  c.toUpperCase();

  return c == "RGB:ON" ||
         c == "RGB:OFF" ||
         c.startsWith("MODE:") ||
         c.startsWith("BRIGHTNESS:") ||
         c.startsWith("COLOR:") ||
         c.startsWith("V5COLOR:") ||
         c.startsWith("V9COLOR:") ||
         c.startsWith("V12COLOR:") ||
         c.startsWith("HOTLIMIT:") ||
         c.startsWith("BATT5:") ||
         c.startsWith("BATT12:") ||
         c.startsWith("VOLTAGE:") ||
         c == "FAN:ON" ||
         c == "FAN:OFF" ||
         c == "PELTIER:ON" ||
         c == "PELTIER:OFF" ||
         c == "ADAPTIVE:ON" ||
         c == "ADAPTIVE:OFF" ||
         c.startsWith("FANSPEED:") ||
         c == "RESET:TEMPERATURE" ||
         c == "RESET:VOLTAGECOLORS";
}

static String controlAckItem(const String& raw) {
  String c = raw;
  c.trim();
  c.toUpperCase();

  if (c == "RGB:ON" || c == "RGB:OFF") return "RGB";
  if (c.startsWith("MODE:")) return "MODE";
  if (c.startsWith("BRIGHTNESS:")) return "BRIGHTNESS";
  if (c.startsWith("COLOR:")) return "COLOR";
  if (c.startsWith("V5COLOR:")) return "V5COLOR";
  if (c.startsWith("V9COLOR:")) return "V9COLOR";
  if (c.startsWith("V12COLOR:")) return "V12COLOR";
  if (c.startsWith("HOTLIMIT:")) return "HOTLIMIT";
  if (c.startsWith("BATT5:")) return "BATT5";
  if (c.startsWith("BATT12:")) return "BATT12";
  if (c.startsWith("VOLTAGE:")) return "VOLTAGE";
  if (c.startsWith("FAN:")) return "FAN";
  if (c.startsWith("PELTIER:")) return "PELTIER";
  if (c.startsWith("ADAPTIVE:")) return "ADAPTIVE";
  if (c.startsWith("FANSPEED:")) return "FANSPEED";
  if (c == "RESET:TEMPERATURE") return "RESET_TEMPERATURE";
  if (c == "RESET:VOLTAGECOLORS") return "RESET_VOLTAGECOLORS";
  return "COMMAND";
}

static bool userControlRateLimited(const String& command) {
  if (!isUserControlCommand(command)) return false;

  const uint32_t now = millis();
  if (userControlGuardArmed &&
      static_cast<uint32_t>(now - lastUserControlCommandMs) < USER_CONTROL_GUARD_MS) {
    sendAck(controlAckItem(command), false, "RATE_LIMIT");
    return true;
  }

  userControlGuardArmed = true;
  lastUserControlCommandMs = now;
  return false;
}

static void dispatchBleLine(const String& raw) {
  String command = raw;
  command.trim();
  if (command.isEmpty()) return;
  if (command.length() > 180) return;

  if (!bleCommandGateOpen && command != "SYNC" && command != "SYNC_READY") {
    sendAck("SESSION", false, "SYNC_REQUIRED");
    return;
  }

  if (userControlRateLimited(command)) {
    return;
  }

  handleCommand(command);
}

static void feedBleRx(const String& incoming) {
  for (size_t i = 0; i < incoming.length(); ++i) {
    const char c = incoming[i];

    if (c == '\r') continue;

    if (c == '\n') {
      if (bleRxLength > 0) {
        bleRxBuffer[bleRxLength] = '\0';
        dispatchBleLine(String(bleRxBuffer));
        bleRxLength = 0;
      }
      continue;
    }

    if (bleRxLength >= BLE_RX_BUFFER_SIZE - 1) {

      bleRxLength = 0;
      continue;
    }

    bleRxBuffer[bleRxLength++] = c;
  }
}

class ServerCallbacks : public BLEServerCallbacks {
 public:
  void onConnect(BLEServer* server) override {
    bleClientConnected = true;
    bleConnectionId =
        server != nullptr ? server->getConnId() : BLE_INVALID_CONN_ID;

    bleSyncPending = false;
    bleCommandGateOpen = false;
    userControlGuardArmed = false;
    lastUserControlCommandMs = 0;
    bleQueueResetPending = true;
  }

  void onDisconnect(BLEServer* server) override {
    (void)server;

    bleClientConnected = false;
    bleConnectionId = BLE_INVALID_CONN_ID;
    bleSyncPending = false;
    bleCommandGateOpen = false;
    bleQueueResetPending = true;

    if (!otaActive && !bootApActive && BLEDevice::getInitialized()) {
      BLEDevice::startAdvertising();
    }
  }

#if defined(CONFIG_BLUEDROID_ENABLED)
  void onConnect(BLEServer* server, esp_ble_gatts_cb_param_t* param) override {
    (void)server;
    if (param != nullptr) {
      bleConnectionId = param->connect.conn_id;
    }
  }

  void onDisconnect(BLEServer* server, esp_ble_gatts_cb_param_t* param) override {
    (void)server;
    if (param != nullptr && bleConnectionId == param->disconnect.conn_id) {
      bleConnectionId = BLE_INVALID_CONN_ID;
    }
  }
#endif

#if defined(CONFIG_NIMBLE_ENABLED)
  void onConnect(BLEServer* server, ble_gap_conn_desc* desc) override {
    (void)server;
    if (desc != nullptr) {
      bleConnectionId = desc->conn_handle;
    }
  }

  void onDisconnect(BLEServer* server, ble_gap_conn_desc* desc) override {
    (void)server;
    if (desc != nullptr && bleConnectionId == desc->conn_handle) {
      bleConnectionId = BLE_INVALID_CONN_ID;
    }
  }
#endif
};

class RxCallbacks : public BLECharacteristicCallbacks {
 public:
  void onWrite(BLECharacteristic* characteristic) override {
    enqueueBleRxPayload(characteristic->getValue());
  }
};

static void stopBleRadio() {
  bleQueueResetPending = true;
  bleSyncPending = false;
  bleCommandGateOpen = false;

  if (BLEDevice::getInitialized()) {
    BLEServer* server = bleServer;
    const uint16_t connId = bleConnectionId;

    if (server != nullptr &&
        bleClientConnected &&
        connId != BLE_INVALID_CONN_ID) {
      server->disconnect(connId);

      const uint32_t disconnectDeadline = millis() + 250;
      while (bleClientConnected && millis() < disconnectDeadline) {
        yield();
      }
    }

    bleClientConnected = false;
    bleConnectionId = BLE_INVALID_CONN_ID;

    BLEDevice::deinit(false);
    yield();
  } else {
    bleClientConnected = false;
    bleConnectionId = BLE_INVALID_CONN_ID;
  }

  bleServer = nullptr;
  rxCharacteristic = nullptr;
  txCharacteristic = nullptr;
}

static void stopBleForBootWiFiClient() {
  stopBleRadio();
}

static void startBle() {
  if (otaActive) return;
  if (BLEDevice::getInitialized()) return;

  WiFi.disconnect(true, false);
  WiFi.softAPdisconnect(true);
  WiFi.mode(WIFI_OFF);

  if (!BLEDevice::init(BLE_NAME)) {
    return;
  }

  if (BLEDevice::setMTU(247) != ESP_OK) {
    BLEDevice::deinit(false);
    return;
  }

  bleServer = BLEDevice::createServer();
  if (bleServer == nullptr) {
    BLEDevice::deinit(false);
    return;
  }
  bleServer->setCallbacks(new ServerCallbacks());

  BLEService* service = bleServer->createService(SERVICE_UUID);
  if (service == nullptr) {
    BLEDevice::deinit(false);
    bleServer = nullptr;
    return;
  }

  const uint32_t rxProperties = BLECharacteristic::PROPERTY_WRITE;
  rxCharacteristic = service->createCharacteristic(RX_UUID, rxProperties);

  rxCharacteristic->setCallbacks(new RxCallbacks());

  txCharacteristic = service->createCharacteristic(
      TX_UUID,
      BLECharacteristic::PROPERTY_NOTIFY);
  txCharacteristic->addDescriptor(new BLE2902());

  service->start();

  BLEAdvertising* advertising = BLEDevice::getAdvertising();
  advertising->addServiceUUID(SERVICE_UUID);
  advertising->setScanResponse(true);
  advertising->setMinPreferred(0x06);
  advertising->setMaxPreferred(0x12);
  BLEDevice::startAdvertising();
  bleClientConnected = false;
  bleSyncPending = false;
  clearBleTxQueue();
  clearBleRxQueue();
  bleQueueResetPending = false;

  if (rgbOn) {
    startUserLedEffect();
  } else {
    stopUserLedOutput();
  }
}

// ============================================================================
// ========================== OTA ENGINE — LOCKED ============================
// Keep OTA networking, flash write/read, validation, cleanup, and activation
// isolated from application feature changes. No delay() belongs in this block.
// ============================================================================
static bool validHttpsUrl(const String& value) {
  return value.startsWith("https://") && value.length() <= 180;
}

static void clearCloudCredentials() {
  cloudSsid = "";
  cloudPassword = "";
  cloudUrl = "";
  cloudVersion = "";
}

static void stopWiFiRadio() {
  WiFi.disconnect(true, false);
  WiFi.softAPdisconnect(true);
  WiFi.mode(WIFI_OFF);
}

static void applyOtaSafeOutputs() {
  fanOn = false;
  peltierOn = false;
  adaptiveOn = false;
  adaptiveCeiling = Voltage::V12;
  fanPwm = 100;
  currentVoltage = Voltage::V5;
  pendingVoltage = Voltage::V5;

  stopPeltierOutput();
  ledcWrite(PIN_FAN, 0);
  digitalWrite(PIN_9V, OUTPUT_OFF);
  digitalWrite(PIN_12V, OUTPUT_OFF);
}

static void failOnlineOta(
    const String& stage,
    int errorCode,
    const String& error) {
  otaRestartAt = 0;
  cloudHttp.end();
  cloudClient.stop();

  setOtaDiagnosticStage(stage);
  setOtaDiagnosticError(errorCode, error);
  saveOtaResult(
      otaFailureResult("ONLINE", stage, errorCode, error, otaDiagnosticProgress));
  setOtaState(OtaState::FAILED);
  otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
  otaActive = false;
  onlineOtaStartPending = false;
  cloudTimeSyncStarted = false;

  stopWiFiRadio();
  clearCloudCredentials();
  applyOtaSafeOutputs();

  startBle();
}

static void startOnlineOta() {
  if (otaActive) return;
  if (cloudSsid.isEmpty() || cloudPassword.isEmpty() || !validHttpsUrl(cloudUrl)) return;

  otaActive = true;
  setOtaState(OtaState::CLOUD_CONNECTING);
  setOtaDiagnosticStage("ONLINE_WIFI_CONNECT");
  setOtaDiagnosticProgress(0);
  setOtaDiagnosticError(0, "NONE");
  otaRestartAt = 0;
  resetBlinkState();
  cloudPhaseStartedAt = millis();
  cloudBytesReceived = 0;
  cloudTimeSyncStarted = false;

  saveOtaResult("IN_PROGRESS|MODE=ONLINE|STAGE=ONLINE_WIFI_CONNECT|PROGRESS=0");
  applyOtaSafeOutputs();

  clearBleTxQueue();
  clearBleRxQueue();
  stopBleRadio();

  WiFi.disconnect(true, false);
  WiFi.softAPdisconnect(true);
  WiFi.setHostname("JE-X-FYZ");
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  WiFi.setAutoReconnect(false);
  WiFi.begin(cloudSsid.c_str(), cloudPassword.c_str());
}

static bool parseDecimalSizeToken(const String& token, size_t& value) {
  if (token.isEmpty()) return false;

  size_t parsed = 0;
  for (size_t i = 0; i < token.length(); ++i) {
    const char c = token.charAt(i);
    if (c < '0' || c > '9') return false;

    const size_t digit = static_cast<size_t>(c - '0');
    if (parsed > (SIZE_MAX - digit) / 10) return false;
    parsed = parsed * 10 + digit;
  }

  value = parsed;
  return true;
}

static bool parseContentRangeHeader(
    const String& header,
    size_t& rangeStart,
    size_t& rangeEnd,
    size_t& totalSize) {
  String value = header;
  value.trim();
  if (!value.startsWith("bytes ")) return false;

  const int dash = value.indexOf('-', 6);
  const int slash = value.indexOf('/', dash + 1);
  if (dash < 0 || slash < 0 || dash <= 6 || slash <= dash + 1) return false;

  const String startText = value.substring(6, dash);
  const String endText = value.substring(dash + 1, slash);
  const String totalText = value.substring(slash + 1);

  size_t parsedStart = 0;
  size_t parsedEnd = 0;
  size_t parsedTotal = 0;

  if (!parseDecimalSizeToken(startText, parsedStart) ||
      !parseDecimalSizeToken(endText, parsedEnd) ||
      !parseDecimalSizeToken(totalText, parsedTotal)) {
    return false;
  }

  if (parsedTotal == 0 ||
      parsedStart > parsedEnd ||
      parsedEnd >= parsedTotal) {
    return false;
  }

  rangeStart = parsedStart;
  rangeEnd = parsedEnd;
  totalSize = parsedTotal;
  return true;
}

static void configureOnlineOtaRangeHttp(HTTPClient& http) {
  http.setTimeout(ONLINE_OTA_HTTP_TIMEOUT_MS);
  http.setReuse(false);
  http.setRedirectLimit(5);
  http.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);
  http.addHeader("Accept-Encoding", "identity");
  http.addHeader("Cache-Control", "no-cache");
  http.addHeader("Connection", "close");
}

static bool downloadOnlineOtaResumable() {
  const esp_partition_t* targetPartition =
      esp_ota_get_next_update_partition(nullptr);

  if (targetPartition == nullptr) {
    failOnlineOta(
        "ONLINE_UPDATE_BEGIN",
        static_cast<int>(ESP_ERR_NOT_FOUND),
        "NO_OTA_PARTITION");
    return false;
  }

  size_t totalSize = 0;
  String probeError = "RANGE_PROBE_FAILED";
  int probeCode = 0;
  bool probeOk = false;

  for (uint8_t attempt = 1; attempt <= ONLINE_OTA_RANGE_RETRIES; ++attempt) {
    if (attempt > 1) setOtaDiagnosticStage("ONLINE_RANGE_RETRY");
    setOtaDiagnosticStage("ONLINE_RANGE_PROBE");

    HTTPClient http;
    cloudClient.stop();
    cloudClient.useBuiltinCACertBundle();
    cloudClient.setTimeout(ONLINE_OTA_HTTP_TIMEOUT_MS);
    configureOnlineOtaRangeHttp(http);
    http.addHeader("Range", "bytes=0-0");

    const char* headerKeys[] = {"Content-Range", "Content-Length"};
    http.collectHeaders(headerKeys, 2);

    if (!http.begin(cloudClient, cloudUrl)) {
      probeError = "HTTP_BEGIN_FAILED";
      probeCode = -1;
      http.end();
      cloudClient.stop();
      continue;
    }

    setOtaDiagnosticStage("ONLINE_RANGE_RESPONSE");
    const int responseCode = http.GET();
    probeCode = responseCode;

    size_t responseStart = 0;
    size_t responseEnd = 0;
    size_t responseTotal = 0;
    const String contentRange = http.header("Content-Range");

    if (responseCode == HTTP_CODE_PARTIAL_CONTENT &&
        parseContentRangeHeader(
            contentRange, responseStart, responseEnd, responseTotal) &&
        responseStart == 0 &&
        responseEnd == 0 &&
        responseTotal > 0) {
      totalSize = responseTotal;
      probeOk = true;
      http.end();
      cloudClient.stop();
      break;
    }

    probeError = responseCode == HTTP_CODE_PARTIAL_CONTENT
                     ? "INVALID_CONTENT_RANGE"
                     : "HTTP_STATUS_" + String(responseCode);
    http.end();
    cloudClient.stop();
  }

  if (!probeOk) {
    failOnlineOta("ONLINE_RANGE_RESPONSE", probeCode, probeError);
    return false;
  }

  if (totalSize == 0 || totalSize > OTA_MAX_FIRMWARE_BYTES) {
    failOnlineOta(
        "ONLINE_SIZE_CHECK",
        -1,
        "INVALID_FIRMWARE_SIZE_" +
            String(static_cast<unsigned long>(totalSize)));
    return false;
  }

  const size_t freeSketchSpace =
      static_cast<size_t>(ESP.getFreeSketchSpace());
  if (totalSize > freeSketchSpace) {
    failOnlineOta(
        "ONLINE_SIZE_CHECK",
        -1,
        "FIRMWARE_EXCEEDS_FREE_SKETCH_SPACE_" +
            String(static_cast<unsigned long>(freeSketchSpace)));
    return false;
  }

  setOtaDiagnosticStage("ONLINE_UPDATE_BEGIN");
  esp_ota_handle_t otaHandle = 0;
  esp_err_t otaErr =
      esp_ota_begin(targetPartition, totalSize, &otaHandle);

  if (otaErr != ESP_OK) {
    failOnlineOta(
        "ONLINE_UPDATE_BEGIN",
        static_cast<int>(otaErr),
        String("esp_ota_begin: ") + esp_err_to_name(otaErr));
    return false;
  }

  size_t offset = 0;
  uint8_t buffer[2048];

  while (offset < totalSize) {
    const size_t rangeEnd =
        min(totalSize - 1, offset + ONLINE_OTA_RANGE_CHUNK_BYTES - 1);
    const size_t expectedChunk = rangeEnd - offset + 1;

    bool chunkComplete = false;
    String lastError = "RANGE_REQUEST_FAILED";
    int lastErrorCode = -1;

    for (uint8_t attempt = 1;
         attempt <= ONLINE_OTA_RANGE_RETRIES && !chunkComplete;
         ++attempt) {
      if (attempt > 1) setOtaDiagnosticStage("ONLINE_RANGE_RETRY");

      setOtaDiagnosticStage("ONLINE_RANGE_REQUEST");

      HTTPClient http;
      cloudClient.stop();
      cloudClient.useBuiltinCACertBundle();
      cloudClient.setTimeout(ONLINE_OTA_HTTP_TIMEOUT_MS);
      configureOnlineOtaRangeHttp(http);

      http.addHeader(
          "Range",
          "bytes=" + String(static_cast<unsigned long>(offset)) +
              "-" + String(static_cast<unsigned long>(rangeEnd)));

      const char* headerKeys[] = {"Content-Range", "Content-Length"};
      http.collectHeaders(headerKeys, 2);

      if (!http.begin(cloudClient, cloudUrl)) {
        lastError = "HTTP_BEGIN_FAILED";
        lastErrorCode = -1;
        http.end();
        cloudClient.stop();
        continue;
      }

      setOtaDiagnosticStage("ONLINE_RANGE_RESPONSE");
      const int responseCode = http.GET();
      lastErrorCode = responseCode;

      size_t responseStart = 0;
      size_t responseEnd = 0;
      size_t responseTotal = 0;
      if (responseCode != HTTP_CODE_PARTIAL_CONTENT ||
          !parseContentRangeHeader(
              http.header("Content-Range"),
              responseStart,
              responseEnd,
              responseTotal) ||
          responseStart != offset ||
          responseEnd != rangeEnd ||
          responseTotal != totalSize) {
        lastError = responseCode == HTTP_CODE_PARTIAL_CONTENT
                        ? "RANGE_MISMATCH"
                        : "HTTP_STATUS_" + String(responseCode);
        http.end();
        cloudClient.stop();
        continue;
      }

      if (http.getSize() > 0 &&
          static_cast<size_t>(http.getSize()) != expectedChunk) {
        lastError = "CONTENT_LENGTH_MISMATCH";
        lastErrorCode = HTTP_CODE_PARTIAL_CONTENT;
        http.end();
        cloudClient.stop();
        continue;
      }

      NetworkClient* stream = http.getStreamPtr();
      if (stream == nullptr) {
        lastError = "NO_STREAM";
        lastErrorCode = -1;
        http.end();
        cloudClient.stop();
        continue;
      }

      setOtaDiagnosticStage("ONLINE_RANGE_WRITE");
      size_t chunkReceived = 0;
      uint32_t lastByteAt = millis();
      bool streamFailed = false;

      while (chunkReceived < expectedChunk) {
        const int available = stream->available();

        if (available > 0) {
          const size_t wanted = min(
              static_cast<size_t>(available),
              min(sizeof(buffer), expectedChunk - chunkReceived));
          const int readCount = stream->read(buffer, wanted);

          if (readCount <= 0) {
            lastError = "STREAM_READ_FAILED";
            lastErrorCode = UPDATE_ERROR_STREAM;
            streamFailed = true;
            break;
          }

          otaErr = esp_ota_write(
              otaHandle,
              buffer,
              static_cast<size_t>(readCount));

          if (otaErr != ESP_OK) {
            lastError =
                String("esp_ota_write: ") + esp_err_to_name(otaErr);
            lastErrorCode = static_cast<int>(otaErr);
            http.end();
            cloudClient.stop();
            esp_ota_abort(otaHandle);
            failOnlineOta(
                "ONLINE_FLASH_WRITE",
                lastErrorCode,
                lastError);
            return false;
          }

          chunkReceived += static_cast<size_t>(readCount);
          offset += static_cast<size_t>(readCount);
          cloudBytesReceived = static_cast<uint32_t>(
              min(offset, totalSize));

          const uint8_t progress = static_cast<uint8_t>(
              min<size_t>(100, (offset * 100ULL) / totalSize));
          setOtaDiagnosticProgress(progress);
          renderBlink(0x0000FF);
          serviceBleTx();
          yield();
          lastByteAt = millis();
          continue;
        }

        if (!http.connected()) {
          lastError = "STREAM_CONNECTION_LOST";
          lastErrorCode = UPDATE_ERROR_STREAM;
          streamFailed = true;
          break;
        }

        if (millis() - lastByteAt >= ONLINE_OTA_HTTP_TIMEOUT_MS) {
          lastError = "STREAM_READ_TIMEOUT";
          lastErrorCode = UPDATE_ERROR_STREAM;
          streamFailed = true;
          break;
        }

        renderBlink(0x0000FF);
        serviceBleTx();
        yield();
      }

      http.end();
      cloudClient.stop();

      if (!streamFailed && chunkReceived == expectedChunk) {
        chunkComplete = true;
        continue;
      }

      if (streamFailed) {
        const size_t resumeOffset = offset;

        otaErr = esp_ota_abort(otaHandle);
        if (otaErr != ESP_OK) {
          failOnlineOta(
              "ONLINE_RANGE_RESUME",
              static_cast<int>(otaErr),
              String("esp_ota_abort: ") + esp_err_to_name(otaErr));
          return false;
        }

        setOtaDiagnosticStage("ONLINE_RANGE_RESUME");
#ifdef JEXFYZ_LEGACY_OTA
        // Core 3.3.7 compatibility: use a fresh OTA transaction when the
        // range stream stalls because esp_ota_resume() is unavailable there.
        otaErr = esp_ota_begin(targetPartition, totalSize, &otaHandle);
        offset = 0;
        cloudBytesReceived = 0;
        setOtaDiagnosticProgress(0);
        if (otaErr != ESP_OK) {
          failOnlineOta(
              "ONLINE_RANGE_RESUME",
              static_cast<int>(otaErr),
              String("legacy esp_ota_begin: ") + esp_err_to_name(otaErr));
          return false;
        }
#else
        otaErr = esp_ota_resume(
            targetPartition,
            0,
            resumeOffset,
            &otaHandle);

        if (otaErr != ESP_OK) {
          failOnlineOta(
              "ONLINE_RANGE_RESUME",
              static_cast<int>(otaErr),
              String("esp_ota_resume: ") + esp_err_to_name(otaErr));
          return false;
        }
#endif
      }
    }

    if (!chunkComplete) {
      const String failStage =
          lastErrorCode == UPDATE_ERROR_STREAM
              ? "ONLINE_RANGE_RESUME"
              : "ONLINE_RANGE_RESPONSE";
      failOnlineOta(
          failStage,
          lastErrorCode,
          lastError + " after " +
              String(static_cast<unsigned long>(otaDiagnosticProgress)) +
              "%");
      esp_ota_abort(otaHandle);
      return false;
    }
  }

  setOtaDiagnosticProgress(100);
  setOtaDiagnosticStage("ONLINE_FINALIZE");

  otaErr = esp_ota_end(otaHandle);
  if (otaErr != ESP_OK) {
    const String detail =
        String("esp_ota_end: ") + esp_err_to_name(otaErr);
    const String stage =
        otaErr == ESP_ERR_OTA_VALIDATE_FAILED
            ? "ONLINE_IMAGE_VERIFY"
            : "ONLINE_FINALIZE";
    failOnlineOta(
        stage,
        static_cast<int>(otaErr),
        detail);
    return false;
  }

  setOtaDiagnosticStage("ONLINE_BOOT_PARTITION");
  otaErr = esp_ota_set_boot_partition(targetPartition);
  if (otaErr != ESP_OK) {
    failOnlineOta(
        "ONLINE_BOOT_PARTITION",
        static_cast<int>(otaErr),
        String("esp_ota_set_boot_partition: ") +
            esp_err_to_name(otaErr));
    return false;
  }

  setOtaDiagnosticError(0, "NONE");
  saveOtaResult(
      otaSuccessResult(
          "ONLINE",
          "ONLINE_BOOT_PARTITION",
          cloudVersion.isEmpty() ? FW_VERSION : cloudVersion));
  setOtaState(OtaState::SUCCESS);
  otaRestartAt = millis() + OTA_RESTART_DELAY_MS;
  otaActive = true;
  clearCloudCredentials();
  return true;
}

static void processOnlineOta() {
  if (otaState != OtaState::CLOUD_CONNECTING) return;

  if (WiFi.status() == WL_CONNECTED) {
    if (!cloudTimeSyncStarted) {
      setOtaDiagnosticStage("ONLINE_TIME_SYNC");
      configTime(0, 0, "pool.ntp.org", "time.nist.gov");
      cloudTimeSyncStarted = true;
      cloudPhaseStartedAt = millis();
      return;
    }

    const time_t now = time(nullptr);
    if (now < 1700000000) {
      if (millis() - cloudPhaseStartedAt >= 10000) {
        failOnlineOta("ONLINE_TIME_SYNC", -1, "TIME_SYNC_FAILED");
      }
      return;
    }

    setOtaState(OtaState::CLOUD_DOWNLOADING);
    setOtaDiagnosticStage("ONLINE_RANGE_PROBE");
    cloudBytesReceived = 0;
    setOtaDiagnosticProgress(0);
    resetBlinkState();

    cloudHttp.end();
    cloudClient.stop();

    if (!downloadOnlineOtaResumable()) {
      return;
    }
  }

  if (otaActive &&
      otaState == OtaState::CLOUD_CONNECTING &&
      millis() - cloudPhaseStartedAt >= WIFI_CONNECT_TIMEOUT_MS) {
    failOnlineOta("ONLINE_WIFI_CONNECT", -1, "WIFI_FAILED");
  }
}

static const char LOCAL_OTA_PAGE[] PROGMEM = R"HTML(
<!doctype html>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>JE X FYZ OTA</title>
<style>
body{margin:0;background:#0f1014;color:#fff;font-family:Arial,sans-serif}
main{max-width:560px;margin:28px auto;padding:22px}
.card{background:#1a1c23;border-radius:20px;padding:22px;box-shadow:0 8px 28px #0008}
h1{margin:0 0 6px;font-size:25px}p{color:#a8acb8}
input{width:100%;box-sizing:border-box;margin:14px 0;padding:14px;border-radius:12px;border:1px solid #3d414d;background:#101116;color:#fff}
button{width:100%;padding:14px;border:0;border-radius:12px;background:#4e8cff;color:#fff;font-weight:800}
progress{width:100%;height:18px;margin-top:16px}
#status{margin-top:12px;font-size:13px;color:#a8acb8}
.small{font-size:12px;color:#8b909d;margin-top:14px}
</style>
</head>
<body>
<main><div class="card">
<h1>JE X FYZ</h1>
<p>Firmware OTA</p>
<p>Current firmware: <b>%VERSION%</b></p>
<form id="otaForm">
<input id="firmware" type="file" accept=".bin" required>
<button id="uploadBtn" type="submit">Upload &amp; Update</button>
</form>
<progress id="progress" value="0" max="100"></progress>
<div id="status">Ready.</div>
<div class="small">Successful OTA: green blink, then restart. Failed OTA: red blink; Wi-Fi remains active and no restart occurs.</div>
</div></main>
<script>
const form=document.getElementById('otaForm');
const fileInput=document.getElementById('firmware');
const btn=document.getElementById('uploadBtn');
const progress=document.getElementById('progress');
const status=document.getElementById('status');
form.addEventListener('submit',e=>{
  e.preventDefault();
  if(!fileInput.files.length)return;
  const xhr=new XMLHttpRequest();
  const file=fileInput.files[0];
   xhr.open('POST','/update?size='+encodeURIComponent(file.size.toString()));
  xhr.upload.onprogress=e=>{
    if(e.lengthComputable)progress.value=(e.loaded/e.total)*100;
    status.textContent='Uploading... '+progress.value.toFixed(0)+'%';
  };
  xhr.onload=()=>{
    if(xhr.status===200){progress.value=100;status.textContent='Update verified. Green blink, then device will restart.';btn.disabled=true;}
    else { status.textContent='OTA failed: '+(xhr.responseText||'Unknown OTA error'); btn.disabled=false; }
  };
  xhr.onerror=()=>status.textContent='Connection error.';
  btn.disabled=true;
  const data=new FormData();
  data.append('firmware',fileInput.files[0]);
  xhr.send(data);
});
</script>
</body>
</html>
)HTML";

static void failLocalOta(
    const String& stage,
    int errorCode,
    const String& error) {
  setOtaDiagnosticStage(stage);
  setOtaDiagnosticError(errorCode, error);
  saveOtaResult(
      otaFailureResult("LOCAL", stage, errorCode, error, otaDiagnosticProgress));
  Update.abort();
  setOtaState(OtaState::FAILED);
  resetBlinkState();
  otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
  otaActive = false;
  localOtaBytesReceived = 0;
  localOtaExpectedBytes = UPDATE_SIZE_UNKNOWN;
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
    localOtaBytesReceived = 0;
    localOtaExpectedBytes = UPDATE_SIZE_UNKNOWN;

    String filename = upload.filename;
    filename.toLowerCase();
    if (!filename.endsWith(".bin")) {
      failLocalOta("LOCAL_FILE_CHECK", -1, "INVALID_FILE_TYPE");
      return;
    }

    if (webServer.hasArg("size")) {
      const long parsedSize = webServer.arg("size").toInt();
      if (parsedSize <= 0 || parsedSize > static_cast<long>(OTA_MAX_FIRMWARE_BYTES)) {
        failLocalOta("LOCAL_SIZE_CHECK", -1, "INVALID_FILE_SIZE");
        return;
      }
      localOtaExpectedBytes = static_cast<size_t>(parsedSize);
    }

    saveOtaResult("IN_PROGRESS|MODE=LOCAL|STAGE=LOCAL_UPDATE_BEGIN|PROGRESS=0");
    applyOtaSafeOutputs();
    setOtaDiagnosticStage("LOCAL_UPDATE_BEGIN");

    if (!Update.begin(localOtaExpectedBytes)) {
      String detail = Update.errorString();
      if (detail.isEmpty()) detail = "UPDATE_BEGIN_FAILED";
      failLocalOta("LOCAL_UPDATE_BEGIN", Update.getError(), detail);
      return;
    }

    setOtaDiagnosticStage("LOCAL_RECEIVE");
    return;
  }

  if (upload.status == UPLOAD_FILE_WRITE) {
    if (otaState != OtaState::LOCAL_UPLOAD || !otaActive) {
      return;
    }

    if (upload.currentSize == 0) return;
    setOtaDiagnosticStage("LOCAL_FLASH_WRITE");

    const size_t chunkSize = static_cast<size_t>(upload.currentSize);
    if (localOtaExpectedBytes != UPDATE_SIZE_UNKNOWN &&
        localOtaBytesReceived + chunkSize > localOtaExpectedBytes) {
      failLocalOta("LOCAL_SIZE_VERIFY", -1, "UPLOAD_SIZE_EXCEEDED");
      return;
    }

    const size_t written = Update.write(upload.buf, chunkSize);
    if (written != chunkSize) {
      String detail = Update.errorString();
      if (detail.isEmpty()) detail = "UPDATE_WRITE_FAILED";
      failLocalOta("LOCAL_FLASH_WRITE", Update.getError(), detail);
      return;
    }

    localOtaBytesReceived += chunkSize;
    if (localOtaExpectedBytes != UPDATE_SIZE_UNKNOWN && localOtaExpectedBytes > 0) {
      const uint32_t percent =
          static_cast<uint32_t>((localOtaBytesReceived * 100ULL) / localOtaExpectedBytes);
      setOtaDiagnosticProgress(static_cast<uint8_t>(constrain(percent, 0UL, 100UL)));
    }
    if (localOtaBytesReceived > OTA_MAX_FIRMWARE_BYTES) {
      failLocalOta("LOCAL_SIZE_VERIFY", -1, "OTA_TOO_LARGE");
    }
    return;
  }

  if (upload.status == UPLOAD_FILE_END) {
    if (otaState != OtaState::LOCAL_UPLOAD || !otaActive) return;

    setOtaDiagnosticStage("LOCAL_SIZE_VERIFY");
    if (localOtaBytesReceived == 0) {
      failLocalOta("LOCAL_SIZE_VERIFY", -1, "OTA_INCOMPLETE");
      return;
    }

    if (localOtaExpectedBytes != UPDATE_SIZE_UNKNOWN &&
        localOtaBytesReceived != localOtaExpectedBytes) {
      char detail[64];
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
    setOtaDiagnosticStage("LOCAL_FINALIZE");
    const bool finished = Update.end(true);

    if (!finished) {
      const int errorCode = Update.getError();
      String detail = Update.errorString();
      if (detail.isEmpty()) detail = "UPDATE_END_FAILED";
      const String failStage = otaUpdateFailureStage(false, errorCode);
      failLocalOta(failStage, errorCode, detail);
      return;
    }

    setOtaDiagnosticError(0, "NONE");
    setOtaDiagnosticStage("LOCAL_BOOT_PARTITION");
    saveOtaResult(otaSuccessResult("LOCAL", "LOCAL_BOOT_PARTITION", FW_VERSION));
    setOtaState(OtaState::SUCCESS);
    otaActive = true;
    resetBlinkState();
    otaRestartAt = millis() + OTA_RESTART_DELAY_MS;
    localOtaExpectedBytes = UPDATE_SIZE_UNKNOWN;
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
      if (!BLEDevice::getInitialized()) startBle();
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

}

void loop() {

  // ================= OTA PRIORITY: DO NOT MOVE DOWN =================
  if (serviceOtaPriority()) return;

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
  // A pending OTA can become active immediately; return to the locked
  // supervisor before any application feature code executes.
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