#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <Preferences.h>
#include <Adafruit_NeoPixel.h>
#include <OneButton.h>
#include <math.h>
#include <time.h>
#include <atomic>
#include <cstring>
#include "esp_heap_caps.h"

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <Update.h>

// ArduinoDroid auto-generates function prototypes before the sketch body.
// Keep all sketch-scoped enum types visible to those generated prototypes.
enum class OtaState : uint8_t;
enum class OnlineOtaFlow : uint8_t;
enum class OnlineOtaIndicatorNext : uint8_t;
enum class Voltage : uint8_t;
enum class LedMode : uint8_t;
enum class VoltageRequestSource : uint8_t;

static constexpr char FW_VERSION[] = "V1.7";

// ============================================================================
// ========================== HEAP DIAGNOSTIC BUILD ===========================
// Diagnostic-only instrumentation retained from the earlier V1.0 baseline. Do not interpret it as physical validation.
// ============================================================================
static bool heapDiagPostAdvertisingActive = false;
static uint8_t heapDiagPostAdvertisingChecks = 0;
static uint32_t heapDiagPostAdvertisingStartedAt = 0;

static void runHeapCheck(const char* checkpointLabel) {
  Serial.print("[HEAP_CHECK] ");
  Serial.print(checkpointLabel);
  Serial.print(" | Free: ");
  Serial.print(ESP.getFreeHeap());
  Serial.print(" | Result: ");

  const bool intact = heap_caps_check_integrity_all(true);
  Serial.println(intact ? "OK" : "CORRUPTED");
  if (!intact) {
    Serial.println("[HEAP_CHECK] CORRUPTION DETECTED - STOPPING DIAGNOSTIC CHECKPOINTS");
    Serial.flush();
  }
}

static void scheduleHeapDiagPostAdvertisingChecks() {
  heapDiagPostAdvertisingActive = true;
  heapDiagPostAdvertisingChecks = 0;
  heapDiagPostAdvertisingStartedAt = millis();
}

static void processHeapDiagPostAdvertisingChecks() {
  if (!heapDiagPostAdvertisingActive) return;

  const uint32_t elapsed = millis() - heapDiagPostAdvertisingStartedAt;
  if ((heapDiagPostAdvertisingChecks & 0x01U) == 0 && elapsed >= 1000U) {
    heapDiagPostAdvertisingChecks |= 0x01U;
    runHeapCheck("CP15_1S_AFTER_ADVERTISING");
  }

  if ((heapDiagPostAdvertisingChecks & 0x02U) == 0 && elapsed >= 30000U) {
    heapDiagPostAdvertisingChecks |= 0x02U;
    runHeapCheck("CP16_30S_AFTER_ADVERTISING");
    heapDiagPostAdvertisingActive = false;
  }
}

// ======================== END HEAP DIAGNOSTIC BUILD ========================

static constexpr char PROTOCOL_VERSION[] = "P1";
static constexpr char BLE_NAME[] = "JE X FYZ";

static constexpr char SERVICE_UUID[] = "6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001";
static constexpr char RX_UUID[]      = "6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001";
static constexpr char TX_UUID[]      = "6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001";

static constexpr uint8_t PIN_NTC     = 0;
static constexpr uint8_t PIN_TOUCH   = 1;
static constexpr uint8_t PIN_12V     = 3;
static constexpr uint8_t PIN_9V      = 4;
static constexpr uint8_t PIN_PELTIER = 6;
static constexpr uint8_t PIN_FAN     = 5;
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
static constexpr uint32_t BOOT_AP_HARD_LIMIT_MS       = 60000;
static constexpr uint32_t LED_FRAME_INTERVAL_MS       = 33;
static constexpr uint32_t OTA_RESTART_DELAY_MS        = 1200;
static constexpr uint32_t OTA_FAILURE_INDICATOR_MS    = 1000;
static constexpr uint32_t WIFI_CONNECT_TIMEOUT_MS     = 15000;
static constexpr uint8_t WIFI_CONNECT_MAX_ATTEMPTS      = 3;
static constexpr uint32_t WIFI_CONNECT_RETRY_BACKOFF_MS = 3000UL;
static constexpr uint32_t ONLINE_OTA_HTTP_TIMEOUT_MS  = 60000;
static constexpr uint32_t ONLINE_OTA_RESULT_INDICATOR_MS = 2000;
static constexpr uint32_t OTA_MAX_FIRMWARE_BYTES     = 2 * 1024 * 1024;
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

enum class OnlineOtaFlow : uint8_t {
  IDLE,
  RADIO_TEARDOWN,
  WIFI_CONNECTING,
  DOWNLOAD,
  FLASH_FINALIZE,
};

enum class OnlineOtaIndicatorNext : uint8_t {
  NONE,
  PREPARE_DOWNLOAD,
  DOWNLOAD,
  FLASH_FINALIZE,
  RESTART,
  RECOVER,
};

static bool serviceOtaPriority();
static void processPendingOnlineOtaStart();

// ========================== END OTA PRIORITY LOCK ===========================

static constexpr size_t BLE_TX_QUEUE_SIZE = 48;
static constexpr size_t BLE_RX_QUEUE_SIZE = 8;
static constexpr size_t BLE_RX_BUFFER_SIZE = 512;
static constexpr uint32_t BLE_TX_INTERVAL_MS = 15;
static constexpr uint32_t ONLINE_OTA_START_WAIT_MS = 1500;
static constexpr uint32_t BLE_START_RETRY_MS = 750;
static constexpr uint8_t BLE_START_MAX_ATTEMPTS = 8;
static constexpr uint8_t RADIO_OFF_SETTLE_YIELDS = 16;

static constexpr float NTC_FIXED_OHMS    = 10000.0f;
static constexpr float NTC_NOMINAL_OHMS  = 10000.0f;
static constexpr float NTC_NOMINAL_C     = 25.0f;
static constexpr float NTC_BETA          = 3950.0f;
static constexpr uint32_t NTC_READ_INTERVAL_MS = 1000;
static constexpr uint32_t NTC_FAULT_LOW_MV  = 50;
static constexpr uint32_t NTC_FAULT_HIGH_MV = 3290;

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
static constexpr float BATTERY_HYSTERESIS_C = 0.8f;

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
String bleTxQueue[BLE_TX_QUEUE_SIZE];
size_t bleTxHead = 0;
size_t bleTxTail = 0;
size_t bleTxCount = 0;
uint32_t bleNextNotifyAt = 0;

char bleRxQueue[BLE_RX_QUEUE_SIZE][BLE_RX_BUFFER_SIZE];
std::atomic<size_t> bleRxHead{0};
std::atomic<size_t> bleRxTail{0};

volatile bool bleQueueResetPending = false;

bool onlineOtaStartPending = false;
uint32_t onlineOtaRequestedAt = 0;
uint8_t onlineWifiConnectAttempt = 0;
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
uint8_t lastPeltierDuty = 0;
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

WiFiClientSecure cloudClient;
size_t localOtaBytesReceived = 0;
size_t localOtaExpectedBytes = 0;
bool localOtaStarted = false;

bool bleStartPending = true;
uint8_t bleStartAttempts = 0;
uint32_t bleStartRetryAt = 0;
uint32_t cloudPhaseStartedAt = 0;

OnlineOtaFlow onlineOtaFlow = OnlineOtaFlow::IDLE;
bool onlineResultIndicatorActive = false;
uint32_t onlineResultIndicatorStartedAt = 0;
uint32_t onlineResultIndicatorColor = 0;
OnlineOtaIndicatorNext onlineResultIndicatorNext = OnlineOtaIndicatorNext::NONE;
uint32_t onlineResultIndicatorLastPhase = 0xFFFFFFFFUL;
bool onlineHttpActive = false;
int onlineHttpResponseCode = 0;
int onlineHttpExpectedBytes = 0;
bool onlineUpdateStarted = false;
HTTPClient onlineHttpClient;

// ====================== OTA DIAGNOSTICS — PROTECTED =========================
String otaDiagnosticStage = "IDLE";
String otaDiagnosticError = "NONE";
int otaDiagnosticErrorCode = 0;
uint8_t otaDiagnosticProgress = 0;
uint8_t otaDiagnosticLastPublishedProgress = 255;

// ==================== END OTA DIAGNOSTIC CORE — PROTECTED =================

bool bootApActive = false;
bool bootApPending = true;
uint32_t bootApStartedAt = 0;
bool runtimeFeaturesReady = false;
bool bootApHadClient = false;
bool bootApClientSafe = false;

volatile bool bleSyncPending = false;

volatile bool bleCommandGateOpen = false;

bool userControlGuardArmed = false;
uint32_t lastUserControlCommandMs = 0;

uint32_t ledBlinkAt = 0;
bool ledBlinkPhase = false;
std::atomic<bool> bleLedResumePending{false};

// Local OTA result indicator is separate from normal LED effects.
// Success: green blink for the result window, then restart.
// Failure: red blink through the existing OTA failure indicator path.
bool localOtaResultIndicatorActive = false;
uint32_t localOtaResultIndicatorStartedAt = 0;
uint32_t localOtaResultIndicatorLastPhase = 0xFFFFFFFFUL;

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
static void failLocalOta(const String& stage, int errorCode, const String& error);
static void failOnlineOta(const String& stage, int errorCode, const String& error);
static bool validFirmwareVersion(const String& value);
static void clearCloudCredentials();
static void resetBlinkState();
static void startLocalOtaResultIndicator();
static bool processLocalOtaResultIndicator();
static void initializeRuntimeFeatures();

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

static const char* resetReasonText() {
  // Arduino-ESP32 Core 3.3.7 has no public ESP.getResetReason() API.
  // Do not substitute an invented or low-level lifecycle API here.
  return "UNAVAILABLE_CORE_3_3_7";
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
    if (runtimeFeaturesReady) {
      ledcWrite(PIN_FAN, 0);
    }
    return;
  }

  ledcWrite(PIN_FAN, fanDutyFromPercent(fanPwm));
}

static void stopPeltierOutput() {
  peltierSoftStarting = false;
  peltierSoftStartAtMs = 0;
  if (lastPeltierDuty != 0) {
    ledcWrite(PIN_PELTIER, 0);
    lastPeltierDuty = 0;
  }
}

static void beginPeltierSoftStart() {
  peltierSoftStarting = true;
  peltierSoftStartAtMs = millis();
  if (lastPeltierDuty != 0) {
    ledcWrite(PIN_PELTIER, 0);
    lastPeltierDuty = 0;
  }
}

static void processPeltierSoftStart() {
  if (!peltierOn) {
    stopPeltierOutput();
    return;
  }

  if (!peltierSoftStarting) {
    if (lastPeltierDuty != 255) {
      ledcWrite(PIN_PELTIER, 255);
      lastPeltierDuty = 255;
    }
    return;
  }

  const uint32_t elapsed = millis() - peltierSoftStartAtMs;
  if (elapsed >= PELTIER_SOFT_START_MS) {
    peltierSoftStarting = false;
    if (lastPeltierDuty != 255) {
      ledcWrite(PIN_PELTIER, 255);
      lastPeltierDuty = 255;
    }
    return;
  }

  const uint8_t duty = static_cast<uint8_t>((elapsed * 255UL) / PELTIER_SOFT_START_MS);
  if (duty != lastPeltierDuty) {
    ledcWrite(PIN_PELTIER, duty);
    lastPeltierDuty = duty;
  }
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
  showAll(ledBlinkPhase ? color : 0x000000, 255);}

static void startOnlineOtaResultIndicator(
    uint32_t color,
    OnlineOtaIndicatorNext nextAction) {
  onlineResultIndicatorActive = true;
  onlineResultIndicatorStartedAt = millis();
  onlineResultIndicatorColor = color;
  onlineResultIndicatorNext = nextAction;
  onlineResultIndicatorLastPhase = 0xFFFFFFFFUL;
  // Keep the LED OFF until the indicator state is actually processed.
  // This prevents a false static-color flash at the stage boundary.
  showAll(0x000000, 0);
}

static bool processOnlineOtaResultIndicator() {
  if (!onlineResultIndicatorActive) return false;

  const uint32_t elapsed = millis() - onlineResultIndicatorStartedAt;
  if (elapsed < ONLINE_OTA_RESULT_INDICATOR_MS) {
    // FIX: Fase dihitung tiap 500ms secara presisi (ON, OFF, ON, OFF)
    const uint32_t phase = elapsed / 500U;
    if (phase != onlineResultIndicatorLastPhase) {
      onlineResultIndicatorLastPhase = phase;
      const bool ledOn = (phase == 0U || phase == 2U);
      showAll(ledOn ? onlineResultIndicatorColor : 0x000000, 255);
    }
    return true;
  }

  if (onlineResultIndicatorLastPhase != 0xFFFFFFFFUL) {
    showAll(0x000000, 0);
    onlineResultIndicatorLastPhase = 0xFFFFFFFFUL;
  }
  onlineResultIndicatorActive = false;

  const OnlineOtaIndicatorNext nextAction = onlineResultIndicatorNext;
  onlineResultIndicatorNext = OnlineOtaIndicatorNext::NONE;

  switch (nextAction) {
    case OnlineOtaIndicatorNext::PREPARE_DOWNLOAD:
      onlineOtaFlow = OnlineOtaFlow::DOWNLOAD;
      prepareOnlineOtaDownload();
      break;

    case OnlineOtaIndicatorNext::DOWNLOAD:
      onlineOtaFlow = OnlineOtaFlow::DOWNLOAD;
      setOtaState(OtaState::CLOUD_DOWNLOADING);
      setOtaDiagnosticStage("ONLINE_DOWNLOAD");
      break;

    case OnlineOtaIndicatorNext::FLASH_FINALIZE:
      onlineOtaFlow = OnlineOtaFlow::FLASH_FINALIZE;
      setOtaState(OtaState::CLOUD_APPLYING);
      setOtaDiagnosticStage("ONLINE_FLASH_FINALIZE");
      break;

    case OnlineOtaIndicatorNext::RESTART:
      onlineOtaFlow = OnlineOtaFlow::IDLE;
      otaActive = true;
      setOtaState(OtaState::SUCCESS);
      otaRestartAt = millis() + 200;
      break;

    case OnlineOtaIndicatorNext::RECOVER:
      onlineOtaFlow = OnlineOtaFlow::IDLE;
      onlineUpdateStarted = false;
      onlineHttpActive = false;
      clearCloudCredentials();
      otaActive = false;
      otaState = OtaState::IDLE;
      // FIX: Kembalikan kontrol LED normal jika OTA Gagal
      bleLedResumePending.store(true, std::memory_order_release);
      startBle();
      break;

    case OnlineOtaIndicatorNext::NONE:
      break;
  }

  return true;
}

static bool validFirmwareVersion(const String& value) {
  String normalized = value;
  normalized.trim();
  normalized.toUpperCase();
  if (!normalized.startsWith("V") || normalized.length() < 2) return false;

  bool dotSeen = false;
  bool digitSeen = false;
  for (size_t i = 1; i < normalized.length(); ++i) {
    const char c = normalized.charAt(i);
    if (c >= '0' && c <= '9') {
      digitSeen = true;
      continue;
    }
    if (c == '.' && !dotSeen && i > 1 && i + 1 < normalized.length()) {
      dotSeen = true;
      continue;
    }
    return false;
  }
  return digitSeen;
}

static void resetBlinkState() {
  ledBlinkAt = 0;
  ledBlinkPhase = false;
}

static void startLocalOtaResultIndicator() {
  localOtaResultIndicatorActive = true;
  localOtaResultIndicatorStartedAt = millis();
  resetBlinkState();
  localOtaResultIndicatorLastPhase = 0xFFFFFFFFUL;

  // Start from a known OFF frame. processLeds() will render the
  // non-blocking green result blink on subsequent loop iterations.
  showAll(0x000000, 0);
}

static bool processLocalOtaResultIndicator() {
  if (!localOtaResultIndicatorActive) return false;

  const uint32_t elapsed = millis() - localOtaResultIndicatorStartedAt;

  // Four 500 ms phases: ON, OFF, ON, OFF.
  // Render only when the phase changes so leds.show() is not called on every
  // main-loop iteration.
  if (elapsed < 2000U) {
    const uint32_t phase = elapsed / 500U;
    if (phase != localOtaResultIndicatorLastPhase) {
      localOtaResultIndicatorLastPhase = phase;
      const bool ledOn = (phase == 0U || phase == 2U);
      showAll(ledOn ? 0x00FF00 : 0x000000, 255);
    }
    return true;
  }

  if (localOtaResultIndicatorLastPhase != 0xFFFFFFFFUL) {
    showAll(0x000000, 0);
    localOtaResultIndicatorLastPhase = 0xFFFFFFFFUL;
  }
  localOtaResultIndicatorActive = false;

  // Keep SUCCESS asserted while the normal OTA supervisor owns the
  // final restart boundary. No blocking delay is introduced here.
  otaRestartAt = millis() + OTA_RESTART_DELAY_MS;
  return true;
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
