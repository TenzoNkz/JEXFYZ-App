/*
  JE X FYZ Firmware V3.0
  ESP32-C3 Super Mini

  DESIGN BASIS
  - Horizon Cooler is a REFERENCE for engineering discipline only:
      non-blocking runtime timing, millis()-based state machines, bounded BLE
      parsing, safe boot/output states, and explicit safety ownership.
  - JE X FYZ keeps its own system behavior where the hardware/specification
    differs from Horizon Cooler.

  JE X FYZ PROJECT-SPECIFIC RADIO BEHAVIOR
  - Boot: silent Wi-Fi AP local-OTA window for 10 seconds; normal cooler
      functions remain active during the window.
    If a Wi-Fi client connects, all physical outputs are forced OFF and BLE is
      released so the Wi-Fi OTA path owns the device safely.
  - If a Wi-Fi client connects within that window, Wi-Fi remains active until
    that client disconnects.
  - After Wi-Fi is fully shut down, BLE starts and remains the normal radio.
  - There is only ONE touch sensor, so touch never controls radio mode.

  FINAL PIN MAP
    GPIO0 = NTC 10K
    GPIO1 = TTP223 touch
    GPIO3 = 12V optocoupler
    GPIO4 = 9V optocoupler
    GPIO5 = PELTIER MOSFET
    GPIO6 = FAN MOSFET
    GPIO7 = WS2812B, 8 LEDs

  TIMING
  - No executable delay() call is used anywhere in the firmware.
  - Runtime timing uses millis() and state machines.
  - yield() is used only inside bounded, OTA-exclusive blocking operations.
  - NTC acquisition: exactly one ADC voltage reading every 1 second.
  - Manual voltage guard: 1 second begins immediately when a manual voltage
    request is accepted. The guard runs concurrently with the optocoupler
    break-before-make dead-time, so the 1 second is not added after it.
    This applies to both App manual voltage commands and single-touch cycling.
  - Adaptive ON/OFF always forces voltage back to 5V before Adaptive proceeds.
  - While Adaptive is ON, manual voltage, Fan/Peltier control, Fan PWM, and
    Temperature settings are rejected by firmware; RGB remains available.
  - Voltage selector optocoupler break-before-make dead-time: 200 ms.
  - Adaptive upward battery change delay: 5 seconds.
  - Adaptive hotside Peltier OFF / step-down delay: 10 seconds.
  - Battery validity heartbeat timeout: 5 seconds.
  - NVS settings debounce: 10 seconds after the last change.
  - App control anti-spam: user commands inside 250 ms are rejected with RATE_LIMIT.

  OTA
  - Local OTA: boot-time AP only. Successful upload blinks green, then restarts; failure blinks red and keeps Wi-Fi/web OTA alive without restart.
  - Online OTA: BLE supplies SSID/PASS/URL; blue blink during Wi-Fi/download, green after verified update, red on failure; failures return BLE without ESP restart.
    firmware version metadata for online OTA.
  - HTTPS is required for online OTA.

  SAFETY
  - Normal reset starts at 5V, Fan OFF, Peltier OFF, Adaptive OFF; an NTC fault immediately forces Fan ON at 100%.
  - NTC fault: Fan ON at 100%, Peltier OFF, Adaptive OFF, 5V lock.
  - Hotside Protection: 40..50C, default 45C.
  - Critical hotside: Fan ON at 100%, Peltier OFF; selected voltage is retained in manual mode.
  - Adaptive overheat: keep Fan ON at 100%, cut Peltier, wait 10s, discard the highest reached
    voltage for this Adaptive session, step down one level, and re-enable
    Peltier when safe. At 5V, Adaptive is turned OFF.
  - Adaptive ceiling resets to 12V when Adaptive is turned OFF.
  - Fan/Peltier interlock is global and enforced in firmware.
  - Battery temperature is supplied by the App every 1 second for synchronized telemetry.
  - Battery changes generate a voltage request ONLY when the battery zone changes.
  - Normal voltage changes never toggle Fan/Peltier; cooling state remains continuous.
  - Peltier PWM: 20 kHz, 8-bit. GPIO5 uses non-blocking PWM ramp from 0..100% over 2 seconds to reduce supply-current shock/brownout risk when the TEC is enabled.
  - Fan PWM: 25 kHz, 8-bit. Fan current is low, so no additional fan soft-start is used.

  PERSISTENCE
  - RGB group only.
  - Temperature group only.
  - LAST_OTA_RESULT is stored separately for post-reboot reporting.
  - No runtime Fan/Peltier/Voltage/Adaptive/PWM state is persisted.

  EXTERNAL LIBRARIES
    WS2812FX 1.4.7
    Adafruit NeoPixel >= 1.1.7
*/

#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <Update.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <Preferences.h>
#include <WS2812FX.h>
#include <math.h>
#include <time.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <BLESecurity.h>

#include "esp_system.h"
#include "freertos/FreeRTOS.h"
#include "freertos/portmacro.h"

// ===========================================================================
// Identity / protocol
// ===========================================================================
static constexpr char FW_VERSION[] = "V3.2";
// Firmware version policy: every firmware change increments this value.
// Version policy: every firmware change increments one major.minor step; never use V1.10 or patch suffixes.
static constexpr char PROTOCOL_VERSION[] = "P1";
static constexpr char BLE_NAME[] = "JE X FYZ";

static constexpr char SERVICE_UUID[] = "6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001";
static constexpr char RX_UUID[]      = "6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001";
static constexpr char TX_UUID[]      = "6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001";

// ===========================================================================
// Hardware
// ===========================================================================
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

// ===========================================================================
// Local OTA AP
// ===========================================================================
static constexpr char AP_SSID[]     = "JE X FYZ";
static constexpr char AP_PASSWORD[] = "0987654321";
static const IPAddress AP_IP(192, 168, 4, 1);
static const IPAddress AP_GATEWAY(192, 168, 4, 1);
static const IPAddress AP_SUBNET(255, 255, 255, 0);

static constexpr uint32_t BOOT_AP_TIMEOUT_MS          = 10000;
static constexpr uint32_t OTA_RESTART_DELAY_MS        = 1200;
static constexpr uint32_t OTA_FAILURE_INDICATOR_MS    = 1000;
static constexpr uint32_t WIFI_CONNECT_TIMEOUT_MS     = 15000;
static constexpr uint32_t OTA_NO_DATA_TIMEOUT_MS      = 7000;

// Trusted DigiCert G2/G5 TLS roots for HTTPS OTA validation. The bundle
// covers the current GitHub raw-content chain and the planned G5 transition.
static constexpr char GITHUB_ROOT_CA[] PROGMEM = R"CERT(-----BEGIN CERTIFICATE-----
MIIDjjCCAnagAwIBAgIQAzrx5qcRqaC7KGSxHQn65TANBgkqhkiG9w0BAQsFADBh
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBH
MjAeFw0xMzA4MDExMjAwMDBaFw0zODAxMTUxMjAwMDBaMGExCzAJBgNVBAYTAlVT
MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
b20xIDAeBgNVBAMTF0RpZ2lDZXJ0IEdsb2JhbCBSb290IEcyMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuzfNNNx7a8myaJCtSnX/RrohCgiN9RlUyfuI
2/Ou8jqJkTx65qsGGmvPrC3oXgkkRLpimn7Wo6h+4FR1IAWsULecYxpsMNzaHxmx
1x7e/dfgy5SDN67sH0NO3Xss0r0upS/kqbitOtSZpLYl6ZtrAGCSYP9PIUkY92eQ
q2EGnI/yuum06ZIya7XzV+hdG82MHauVBJVJ8zUtluNJbd134/tJS7SsVQepj5Wz
tCO7TG1F8PapspUwtP1MVYwnSlcUfIKdzXOS0xZKBgyMUNGPHgm+F6HmIcr9g+UQ
vIOlCsRnKPZzFBQ9RnbDhxSJITRNrw9FDKZJobq7nMWxM4MphQIDAQABo0IwQDAP
BgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNVHQ4EFgQUTiJUIBiV
5uNu5g/6+rkS7QYXjzkwDQYJKoZIhvcNAQELBQADggEBAGBnKJRvDkhj6zHd6mcY
1Yl9PMWLSn/pvtsrF9+wX3N3KjITOYFnQoQj8kVnNeyIv/iPsGEMNKSuIEyExtv4
NeF22d+mQrvHRAiGfzZ0JFrabA0UWTW98kndth/Jsw1HKj2ZL7tcu7XUIOGZX1NG
Fdtom/DzMNU+MeKNhJ7jitralj41E6Vf8PlwUHBHQRFXGU7Aj64GxJUTFy8bJZ91
8rGOmaFvE7FBcf6IKshPECBV1/MUReXgRPTqh5Uykw7+U0b6LJ3/iyK5S9kJRaTe
pLiaWN0bfVKfjllDiIGknibVb63dDcY3fe0Dkhvld1927jyNxF1WW6LZZm6zNTfl
MrY=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFZjCCA06gAwIBAgIQCPm0eKj6ftpqMzeJ3nzPijANBgkqhkiG9w0BAQwFADBN
MQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xJTAjBgNVBAMT
HERpZ2lDZXJ0IFRMUyBSU0E0MDk2IFJvb3QgRzUwHhcNMjEwMTE1MDAwMDAwWhcN
NDYwMTE0MjM1OTU5WjBNMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xJTAjBgNVBAMTHERpZ2lDZXJ0IFRMUyBSU0E0MDk2IFJvb3QgRzUwggIi
MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCz0PTJeRGd/fxmgefM1eS87IE+
ajWOLrfn3q/5B03PMJ3qCQuZvWxX2hhKuHisOjmopkisLnLlvevxGs3npAOpPxG0
2C+JFvuUAT27L/gTBaF4HI4o4EXgg/RZG5Wzrn4DReW+wkL+7vI8toUTmDKdFqgp
wgscONyfMXdcvyej/Cestyu9dJsXLfKB2l2w4SMXPohKEiPQ6s+d3gMXsUJKoBZM
pG2T6T867jp8nVid9E6P/DsjyG244gXazOvswzH016cpVIDPRFtMbzCe88zdH5RD
nU1/cHAN1DrRN/BsnZvAFJNY781BOHW8EwOVfH/jXOnVDdXifBBiqmvwPXbzP6Po
sMH976pXTayGpxi0KcEsDr9kvimM2AItzVwv8n/vFfQMFawKsPHTDU9qTXeXAaDx
Zre3zu/O7Oyldcqs4+Fj97ihBMi8ez9dLRYiVu1ISf6nL3kwJZu6ay0/nTvEF+cd
Lvvyz6b84xQslpghjLSR6Rlgg/IwKwZzUNWYOwbpx4oMYIwo+FKbbuH2TbsGJJvX
KyY//SovcfXWJL5/MZ4PbeiPT02jP/816t9JXkGPhvnxd3lLG7SjXi/7RgLQZhNe
XoVPzthwiHvOAbWWl9fNff2C+MIkwcoBOU+NosEUQB+cZtUMCUbW8tDRSHZWOkPL
tgoRObqME2wGtZ7P6wIDAQABo0IwQDAdBgNVHQ4EFgQUUTMc7TZArxfTJc1paPKv
TiM+s0EwDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcN
AQEMBQADggIBAGCmr1tfV9qJ20tQqcQjNSH/0GEwhJG3PxDPJY7Jv0Y02cEhJhxw
GXIeo8mH/qlDZJY6yFMECrZBu8RHANmfGBg7sg7zNOok992vIGCukihfNudd5N7H
PNtQOa27PShNlnx2xlv0wdsUpasZYgcYQF+Xkdycx6u1UQ3maVNVzDl92sURVXLF
O4uJ+DQtpBflF+aZfTCIITfNMBc9uPK8qHWgQ9w+iUuQrm0D4ByjoJYJu32jtyoQ
REtGBzRj7TG5BO6jm5qu5jF49OokYTurWGT/u4cnYiWB39yhL/btp/96j1EuMPik
AdKFOV8BmZZvWltwGUb+hmA+rYAQCd05JS9Yf7vSdPD3Rh9GOUrYU9DzLjtxpdRv
/PNn5AeP3SYZ4Y1b+qOTEZvpyDrDVWiakuFSdjjo4bq9+0/V77PnSIMx8IIh47a+
p6tv75/fTM8BuGJqIz3nCU2AG3swpMPdB380vqQmsvZB6Akd4yCYqjdP//fx4ilw
MUc/dNAUFvohigLVigmUdy7yWSiLfFCSCmZ4OIN1xLVaqBHG5cGdZlXPU8Sv13WF
qUITVuwhd4GTWgzqltlJyqEI8pc7bZsEGCREjnwB8twl2F6GmrE52/WRMmrRpnCK
ovfepEWFJqgejF0pW8hL2JpqA15w8oVPbEtoL8pU9ozaMv7Da4M/OMZ+
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIICGTCCAZ+gAwIBAgIQCeCTZaz32ci5PhwLBCou8zAKBggqhkjOPQQDAzBOMQsw
CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xJjAkBgNVBAMTHURp
Z2lDZXJ0IFRMUyBFQ0MgUDM4NCBSb290IEc1MB4XDTIxMDExNTAwMDAwMFoXDTQ2
MDExNDIzNTk1OVowTjELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJ
bmMuMSYwJAYDVQQDEx1EaWdpQ2VydCBUTFMgRUNDIFAzODQgUm9vdCBHNTB2MBAG
ByqGSM49AgEGBSuBBAAiA2IABMFEoc8Rl1Ca3iOCNQfN0MsYndLxf3c1TzvdlHJS
7cI7+Oz6e2tYIOyZrsn8aLN1udsJ7MgT9U7GCh1mMEy7H0cKPGEQQil8pQgO4CLp
0zVozptjn4S1mU1YoI71VOeVyaNCMEAwHQYDVR0OBBYEFMFRRVBZqz7nLFr6ICIS
B4CIfBFqMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MAoGCCqGSM49
BAMDA2gAMGUCMQCJao1H5+z8blUD2WdsJk6Dxv3J+ysTvLd6jLRl0mlpYxNjOyZQ
LgGheQaRnUi/wr4CMEfDFXuxoJGZSZOoPHzoRgaLLPIxAJSdYsiJvRmEFOml+wG4
DXZDjC5Ty3zfDBeWUA==
-----END CERTIFICATE-----
)CERT";

// State synchronization is firmware-authoritative: App and touch commands
// never directly define App state; BLE telemetry reflects the actual hardware.
// Radio reliability / BLE TX pacing. BLE notifications are serialized from
// the main loop, never from BLE callbacks, so radio-mode switches are safe.
static constexpr size_t BLE_TX_QUEUE_SIZE = 48;
static constexpr size_t BLE_RX_QUEUE_SIZE = 16;
static constexpr uint32_t BLE_TX_INTERVAL_MS = 15;
static constexpr uint32_t ONLINE_OTA_START_WAIT_MS = 1500;

// ===========================================================================
// NTC
// Hardware: 3.3V > NTC 10K > GPIO0 > R10K > GND
// ===========================================================================
static constexpr float NTC_FIXED_OHMS    = 10000.0f;
static constexpr float NTC_NOMINAL_OHMS  = 10000.0f;
static constexpr float NTC_NOMINAL_C     = 25.0f;
static constexpr float NTC_BETA          = 3950.0f;
static constexpr uint32_t NTC_READ_INTERVAL_MS = 1000;
static constexpr uint32_t NTC_FAULT_LOW_MV  = 50;
static constexpr uint32_t NTC_FAULT_HIGH_MV = 3250;

// ===========================================================================
// Safety / timing / limits
// ===========================================================================
static constexpr uint32_t VOLTAGE_GUARD_MS             = 1000;
static constexpr uint32_t VOLTAGE_DEADTIME_MS           = 200;
static constexpr uint32_t HOT_PELTIER_OFF_MS          = 10000;
static constexpr uint32_t ADAPTIVE_UPWARD_DELAY_MS      = 5000;
static constexpr uint32_t BATTERY_VALID_TTL_MS          = 5000;
static constexpr uint32_t SETTINGS_SAVE_DEBOUNCE_MS     = 10000;
// App control anti-spam backstop. UI also serializes commands; firmware rejects
// duplicate user commands arriving inside this guard window.
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

// ===========================================================================
// Objects
// ===========================================================================
WebServer webServer(80);
Preferences prefs;
WS2812FX leds(LED_COUNT, PIN_LED, NEO_GRB + NEO_KHZ800, 2, 2);

BLEServer* bleServer = nullptr;
BLECharacteristic* rxCharacteristic = nullptr;
BLECharacteristic* txCharacteristic = nullptr;
BLESecurity* bleSecurity = nullptr;
volatile bool bleClientConnected = false;
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

// ===========================================================================
// Types
// ===========================================================================
enum class Voltage : uint8_t {
  V5 = 0,
  V9 = 1,
  V12 = 2,
};

enum class LedMode : uint8_t {
  STATIC = 0,
  BREATH = 1,
  WIPE = 2,
  RUNNING = 3,
  SCAN = 4,
  THEATER = 5,
  RAINBOW = 6,
  TWINKLE = 7,
};

enum class VoltageRequestSource : uint8_t {
  MANUAL,
  TOUCH,
  BATTERY,
  HOTSTEP,
  ADAPTIVE,
  SAFETY,
};

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

// ===========================================================================
// Runtime state
// ===========================================================================
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
WiFiClientSecure cloudClient;
uint32_t cloudBytesReceived = 0;
int cloudExpectedSize = -1;
uint32_t cloudPhaseStartedAt = 0;
uint32_t cloudLastDataAt = 0;
bool cloudTimeSyncStarted = false;

bool bootApActive = true;
uint32_t bootApStartedAt = 0;
bool bootApHadClient = false;
bool bootApClientSafe = false;

// BLE lifecycle is strictly state-neutral. Connecting/disconnecting BLE must
// never alter voltage, FAN, Peltier, Adaptive, RGB, or fan PWM. A pending
// full-sync is serviced from the main loop so the client receives the actual
// runtime state without letting the BLE callback mutate cooler state.
volatile bool bleSyncPending = false;
// BLE session gate: a newly connected client must complete SYNC -> SYNC_READY
// before any state-changing command is accepted. This prevents stale app state
// from being replayed into the cooler immediately after BLE connection.
volatile bool bleCommandGateOpen = false;

// Firmware-side anti-spam guard for App-originated state-changing commands.
// Telemetry, SYNC, SYNC_READY and OTA metadata are intentionally excluded.
bool userControlGuardArmed = false;
uint32_t lastUserControlCommandMs = 0;

uint32_t ledBlinkAt = 0;
bool ledBlinkPhase = false;

// Bounded BLE command accumulator. Commands are newline terminated.
static constexpr size_t BLE_RX_BUFFER_SIZE = 512;
char bleRxBuffer[BLE_RX_BUFFER_SIZE];
size_t bleRxLength = 0;

// ===========================================================================
// Forward declarations
// ===========================================================================
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

// ===========================================================================
// Helpers
// ===========================================================================
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

// ===========================================================================
// Persistence
// ===========================================================================
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
  rgbMode = static_cast<LedMode>(constrain(static_cast<int>(prefs.getUChar("rgbMode", 0)), 0, 7));
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

// ===========================================================================
// Fan / Peltier safety
// ===========================================================================
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

  // During Adaptive hotside protection, Peltier must remain OFF for the full
  // configured cooldown window. This gate applies to App and touch commands.
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

  // A missing/invalid NTC is a thermal fault. Keep airflow available as the
  // conservative fail-safe, while Peltier remains forced OFF. The safety
  // manager may later clear this condition when the NTC becomes valid again.
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

  // Firmware state is the source of truth. Any real output-state change made
  // here is immediately mirrored to the BLE client, including changes caused
  // by safety interlocks rather than by an App command.
  if (fanOn != previousFan || peltierOn != previousPeltier || fanPwm != previousPwm) {
    ++stateSequence;
  }
  if (fanOn != previousFan) sendDelta("FAN", boolText(fanOn));
  if (peltierOn != previousPeltier) sendDelta("PELTIER", boolText(peltierOn));
  if (fanPwm != previousPwm) sendDelta("FAN_SPEED", String(fanPwm));
}

// ===========================================================================
// LED manager
// ===========================================================================
static uint8_t ws2812fxMode(LedMode mode) {
  // WS2812FX 1.4.7 built-in IDs used by this project.
  switch (mode) {
    case LedMode::STATIC:  return 0;
    case LedMode::BREATH:  return 2;
    case LedMode::WIPE:    return 3;
    case LedMode::RUNNING: return 18;
    case LedMode::SCAN:    return 13;
    case LedMode::THEATER: return 16;
    case LedMode::RAINBOW: return 11;
    case LedMode::TWINKLE: return 22;
  }
  return 0;
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

static void showAll(uint32_t color) {
  for (uint8_t i = 0; i < LED_COUNT; ++i) {
    leds.setPixelColor(i, color);
  }
  leds.show();
}

static void stopUserLedOutput() {
  leds.stop();
  leds.setBrightness(0);
  leds.strip_off();
}

static void startUserLedEffect() {
  if (!rgbOn) {
    stopUserLedOutput();
    return;
  }

  leds.setBrightness(hardwareBrightness());
  leds.setColor(rgbColor);
  leds.setSpeed(1000);
  leds.setMode(ws2812fxMode(rgbMode));
  leds.start();
}

static void renderBlink(uint32_t color) {
  if (millis() - ledBlinkAt < 250) return;

  ledBlinkAt = millis();
  ledBlinkPhase = !ledBlinkPhase;
  leds.setBrightness(255);
  showAll(ledBlinkPhase ? color : 0x000000);
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
  leds.stop();
  leds.setBrightness(hardwareBrightness());
  showAll(currentVoltageColor());
}

static void processLeds() {
  // OTA status indicators have priority over normal RGB and Wi-Fi silent mode.
  // They are intentionally short, non-blocking and use the same WS2812 strip.
  if (otaState == OtaState::SUCCESS) {
    renderBlink(0x00FF00);  // green = verified OTA, restart pending
    return;
  }

  if (otaState == OtaState::FAILED) {
    if (millis() < otaFailureIndicatorUntil) {
      renderBlink(0xFF0000);  // red = OTA failed, recovery continues
      return;
    }

    resetBlinkState();
    setOtaState(bootApActive ? OtaState::BOOT_AP : OtaState::IDLE);
    if (!bootApActive && !otaActive) {
      startUserLedEffect();
    }
    return;
  }

  if (otaState == OtaState::CLOUD_CONNECTING ||
      otaState == OtaState::CLOUD_DOWNLOADING ||
      otaState == OtaState::CLOUD_APPLYING) {
    renderBlink(0x0000FF);  // blue = online OTA Wi-Fi/download in progress
    return;
  }

  // Boot Wi-Fi is intentionally silent: no blue blink, no status blink and
  // no forced RGB effect. The user's normal RGB mode remains available.
  if (bootApActive && !bootApHadClient && !otaActive) {
    if (!rgbOn) {
      stopUserLedOutput();
      return;
    }

    if (voltageIndicatorActive) {
      if (millis() >= voltageIndicatorUntil) {
        voltageIndicatorActive = false;
        startUserLedEffect();
      } else {
        leds.stop();
        leds.setBrightness(hardwareBrightness());
        showAll(currentVoltageColor());
      }
      return;
    }

    leds.service();
    return;
  }

  // A Wi-Fi client connection means the device is now in OTA/safe mode:
  // all physical outputs are OFF and normal RGB must stay silent.
  if (bootApClientSafe || otaActive || otaState == OtaState::LOCAL_UPLOAD) {
    stopUserLedOutput();
    return;
  }

  // Safety indication remains visible when normal RGB is OFF.
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
    } else {
      leds.stop();
      leds.setBrightness(hardwareBrightness());
      showAll(currentVoltageColor());
    }
    return;
  }

  leds.service();
}

// ===========================================================================
// Voltage manager
// ===========================================================================
static bool voltageGuardAllows(bool bypassGuard) {
  if (bypassGuard || !voltageGuardArmed) return true;

  // Manual App commands and single-touch voltage changes share the same
  // 1-second manual request guard, matching the Horizon timing discipline.
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

  // For manual voltage changes, start the full 1-second guard immediately
  // when the accepted request arrives. This timer runs concurrently with the
  // 200 ms optocoupler break-before-make dead-time. Safety/adaptive requests
  // may bypass this manual guard.
  if (!bypassGuard) {
    voltageGuardArmed = true;
    lastVoltageChangeMs = millis();
  }

  pendingVoltage = target;
  voltageTransition = true;
  voltageTransitionAt = millis();

  // Break-before-make applies only to the voltage selector optocouplers.
  // Fan and Peltier remain in their current control state during a normal
  // voltage transition.
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

  // Manual voltage guard was started at request acceptance and therefore runs
  // concurrently with the 200 ms optocoupler dead-time. Do not restart it
  // here. Safety/adaptive transitions may still establish their own timestamp
  // when they complete.
  if (!voltageGuardArmed) {
    voltageGuardArmed = true;
    lastVoltageChangeMs = millis();
  }

  // Fan/Peltier logical state is preserved across normal voltage changes.
  // Fan PWM returns to 100% whenever Manual 12V control is no longer active.
  if (currentVoltage != Voltage::V12 || adaptiveOn) {
    fanPwm = 100;
  }

  applyCoolingOutputs();
  startVoltageIndicator();

  ++stateSequence;
  sendDelta("VOLTAGE", voltageToString(currentVoltage));

  // Adaptive ON first returns to 5V. Only after that transition has actually
  // completed may battery logic schedule an upward move to 9V/12V.
  if (adaptiveOn && currentVoltage == Voltage::V5 && batteryValid && ntcValid) {
    evaluateAdaptiveBattery();
  }
}

// ===========================================================================
// NTC
// ===========================================================================
static float ntcTemperatureFromOhms(float ohms) {
  const float t0 = NTC_NOMINAL_C + 273.15f;
  const float invT = (1.0f / t0) + (logf(ohms / NTC_NOMINAL_OHMS) / NTC_BETA);
  return (1.0f / invT) - 273.15f;
}

static void sampleNtcIfDue() {
  if (millis() - lastNtcReadMs < NTC_READ_INTERVAL_MS) return;
  lastNtcReadMs = millis();

  // Exactly one ADC voltage reading per sample period.
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

// ===========================================================================
// Safety manager
// ===========================================================================
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

  // Thermal fault state: Peltier OFF, Fan forced ON at 100%.
  fanOn = true;
  peltierOn = false;
  peltierSoftStarting = false;
  peltierSoftStartAtMs = 0;
  adaptiveOn = false;
  adaptiveCeiling = Voltage::V12;
  fanPwm = 100;

  if (voltageTransition) {
    // Safety is allowed to retarget an in-flight voltage transition to 5V.
    // Keep the original transition timestamp so a persistent NTC fault cannot
    // extend the 100 ms dead-time forever.
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

    // Critical hotside protection: Peltier OFF, Fan forced ON at 100%.
    // The fan remains available throughout the cooling period.
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

      // Preserve whether Peltier was running when the safety event occurred.
      // It may resume only after the complete 10-second cooldown window.
      if (!adaptiveResumePeltierAfterHotStep) {
        adaptiveResumePeltierAfterHotStep = fanOn && wasPeltierOn;
      }

      // A hotside event invalidates any pending battery voltage request.
      adaptiveUpPending = false;
      adaptiveDownPending = false;
    }
  }

  // Never re-enable Peltier before the complete 10-second cooldown expires.
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

  // The fan has now had the full 10-second cooling window.
  adaptiveHotStepPending = false;
  adaptiveUpPending = false;
  adaptiveDownPending = false;
  const bool wasPeltierOn = peltierOn;
  peltierOn = false;
  stopPeltierOutput();
  if (wasPeltierOn) sendDelta("PELTIER", "OFF");

  // If the hotside recovered during the cooldown window, do not discard a
  // voltage level unnecessarily. Resume Peltier only after the full 10 s.
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

  // Hotside is still at/above the protection limit: discard one voltage level.
  if (currentVoltage == Voltage::V12) {
    adaptiveCeiling = Voltage::V9;
    sendDelta("ADAPTIVE_CEILING", "9V");
  } else if (currentVoltage == Voltage::V9) {
    adaptiveCeiling = Voltage::V5;
    sendDelta("ADAPTIVE_CEILING", "5V");
  } else {
    // No lower voltage exists. End this Adaptive session.
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
    // Safety step bypasses the normal 1-second manual guard.
    sendDelta("SAFETY_REASON", "VOLTAGE_STEP_FAILED");
  }
}

static String safetyReason() {
  if (!ntcValid) return "NTC_ERROR";
  if (hotsideProtectionActiveNow()) return "HOTSIDE_PROTECTION";
  if (peltierOn && !fanOn) return "FAN_REQUIRED";
  return "NONE";
}

// ===========================================================================
// Battery / Adaptive manager
// ===========================================================================
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

// ===========================================================================
// BLE TX / Full Sync
// ===========================================================================
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
  // Hotside is the one runtime value intentionally transmitted every second.
  sendDelta("HOT", formatTemperature(hotsideC, ntcValid));
  publishSafetyReason();
}

// ===========================================================================
// BLE RX parser
// ===========================================================================
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

  // A fresh BLE session is read-only until the app has completed the
  // SYNC -> SYNC_READY handshake. This is the hard firmware-side protection
  // against connect-time state replay (for example an old app sending 5V).
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
      // Drop the whole partial frame. Never execute a truncated command.
      bleRxLength = 0;
      continue;
    }

    bleRxBuffer[bleRxLength++] = c;
  }
}

// ===========================================================================
// BLE callbacks / startup
// ===========================================================================
class ServerCallbacks : public BLEServerCallbacks {
 public:
  void onConnect(BLEServer* server) override {
    (void)server;

    // IMPORTANT: BLE connection is observational only. Do not touch any
    // cooler runtime state here. In particular, never force 5V on connect.
    bleClientConnected = true;
    // Do not push SYNC immediately from the connect callback. Android still
    // needs to discover GATT + enable TX notifications; an early notification
    // can be lost before the CCCD is enabled. The App now requests SYNC only
    // after notifications are ready.
    bleSyncPending = false;
    bleCommandGateOpen = false;
    userControlGuardArmed = false;
    lastUserControlCommandMs = 0;
    bleQueueResetPending = true;
  }

  void onDisconnect(BLEServer* server) override {
    (void)server;

    // IMPORTANT: BLE disconnect is also state-neutral. Runtime cooler state
    // remains exactly as-is. Phone battery validity expires naturally through
    // the normal 5-second timeout instead of being reset by BLE lifecycle.
    bleClientConnected = false;
    bleSyncPending = false;
    bleCommandGateOpen = false;
    bleQueueResetPending = true;

    if (!otaActive && !bootApActive && BLEDevice::getInitialized()) {
      BLEDevice::startAdvertising();
    }
  }
};

class RxCallbacks : public BLECharacteristicCallbacks {
 public:
  void onWrite(BLECharacteristic* characteristic) override {
    enqueueBleRxPayload(characteristic->getValue());
  }
};

static void stopBleForBootWiFiClient() {
  bleQueueResetPending = true;
  bleClientConnected = false;

  if (BLEDevice::getInitialized()) {
    BLEDevice::deinit(false);
  }

  bleServer = nullptr;
  rxCharacteristic = nullptr;
  txCharacteristic = nullptr;
  bleSyncPending = false;
  bleCommandGateOpen = false;
}

static void startBle() {
  if (otaActive) return;
  if (BLEDevice::getInitialized()) return;

  // BLE owns the radio exclusively. Every BLE startup explicitly shuts Wi-Fi
  // down first, so BLE and Wi-Fi can never remain active at the same time.
  WiFi.disconnect(true, false);
  WiFi.softAPdisconnect(true);
  WiFi.mode(WIFI_OFF);
  BLEDevice::init(BLE_NAME);
  BLEDevice::setMTU(247);

  if (bleSecurity == nullptr) {
    bleSecurity = new BLESecurity();
  }
  // Secure BLE policy: bonded Secure Connections, no MITM/passkey needed.
  // Authentication is deliberately deferred until a protected GATT write is
  // accessed. This prevents authentication and Android service discovery from
  // racing each other on ESP32-C3, while the RX characteristic still requires
  // encryption and the session gate below blocks all state-changing commands
  // until SYNC -> SYNC_READY completes.
  bleSecurity->setAuthenticationMode(true, false, true);
  // Do not call setForceAuthentication(): some Arduino-ESP32 cores
  // bundled by ArduinoDroid do not expose that API.
  // With encrypted RX permissions, authentication is still requested
  // when the protected characteristic is accessed.
  bleSecurity->setCapability(ESP_IO_CAP_NONE);
  bleSecurity->setKeySize(16);
  bleSecurity->setInitEncryptionKey(ESP_BLE_ENC_KEY_MASK | ESP_BLE_ID_KEY_MASK);
  bleSecurity->setRespEncryptionKey(ESP_BLE_ENC_KEY_MASK | ESP_BLE_ID_KEY_MASK);

  bleServer = BLEDevice::createServer();
  bleServer->setCallbacks(new ServerCallbacks());
  bleServer->advertiseOnDisconnect(true);

  BLEService* service = bleServer->createService(SERVICE_UUID);

  // All RX writes must be encrypted. We intentionally do NOT expose
  // WRITE_NR, because every application command is now sent with a GATT write
  // response, giving one consistent authenticated write path.
  uint32_t rxProperties = BLECharacteristic::PROPERTY_WRITE;
#if defined(CONFIG_NIMBLE_ENABLED)
  rxProperties |= BLECharacteristic::PROPERTY_WRITE_ENC;
#endif

  rxCharacteristic = service->createCharacteristic(RX_UUID, rxProperties);

#if defined(CONFIG_BLUEDROID_ENABLED)
  rxCharacteristic->setAccessPermissions(ESP_GATT_PERM_WRITE_ENC);
#endif

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

// ===========================================================================
// Online OTA — Firebase version + URL only
// ===========================================================================
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
  // Turn the Wi-Fi radio fully off without erasing any saved AP profile.
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

static void failOnlineOta(const char* reason) {
  otaRestartAt = 0;
  if (cloudHttp.connected()) cloudHttp.end();
  Update.abort();

  saveOtaResult(reason);
  setOtaState(OtaState::FAILED);
  otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
  otaActive = false;
  onlineOtaStartPending = false;
  cloudTimeSyncStarted = false;

  stopWiFiRadio();
  clearCloudCredentials();

  // Leave the hardware in a conservative runtime state after a failed OTA.
  // The device stays alive and BLE is brought back without ESP.restart().
  currentVoltage = Voltage::V5;
  pendingVoltage = Voltage::V5;
  fanOn = false;
  peltierOn = false;
  adaptiveOn = false;
  adaptiveCeiling = Voltage::V12;
  fanPwm = 100;
  stopPeltierOutput();
  ledcWrite(PIN_FAN, 0);
  digitalWrite(PIN_9V, OUTPUT_OFF);
  digitalWrite(PIN_12V, OUTPUT_OFF);

  startBle();
}

static void startOnlineOta() {
  if (otaActive) return;
  if (cloudSsid.isEmpty() || cloudPassword.isEmpty() || !validHttpsUrl(cloudUrl)) return;

  otaActive = true;
  setOtaState(OtaState::CLOUD_CONNECTING);
  otaRestartAt = 0;
  resetBlinkState();
  cloudPhaseStartedAt = millis();
  cloudLastDataAt = millis();
  cloudBytesReceived = 0;
  cloudExpectedSize = -1;
  cloudTimeSyncStarted = false;

  // OTA safety state.
  applyOtaSafeOutputs();

  // Wi-Fi and BLE are never active at the same time in JE X FYZ. This
  // function is called from the main loop, never from a BLE callback.
  clearBleTxQueue();
  clearBleRxQueue();
  bleClientConnected = false;
  bleCommandGateOpen = false;
  if (BLEDevice::getInitialized()) {
    BLEDevice::deinit(false);
  }
  bleServer = nullptr;
  rxCharacteristic = nullptr;
  txCharacteristic = nullptr;

  WiFi.disconnect(true, false);
  WiFi.softAPdisconnect(true);
  WiFi.setHostname("JE-X-FYZ");
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  WiFi.setAutoReconnect(false);
  WiFi.begin(cloudSsid.c_str(), cloudPassword.c_str());
}

static void processOnlineOta() {
  if (otaState == OtaState::CLOUD_CONNECTING) {
    if (WiFi.status() == WL_CONNECTED) {
      // TLS certificate validation requires a valid system clock. Sync time
      // non-blockingly while keeping the OTA LED state active.
      if (!cloudTimeSyncStarted) {
        configTime(0, 0, "pool.ntp.org", "time.nist.gov", "time.google.com");
        cloudTimeSyncStarted = true;
        cloudPhaseStartedAt = millis();
        return;
      }

      const time_t now = time(nullptr);
      if (now < 1700000000) {
        if (millis() - cloudPhaseStartedAt >= 10000) {
          failOnlineOta("TIME_SYNC_FAILED");
        }
        return;
      }

      setOtaState(OtaState::CLOUD_DOWNLOADING);
      cloudPhaseStartedAt = millis();
      cloudLastDataAt = millis();

      // Validate the HTTPS server certificate. The firmware is intentionally
      // not allowed to download executable code through an insecure TLS path.
      cloudClient.setCACert(GITHUB_ROOT_CA);
      cloudClient.setTimeout(12000);
      cloudHttp.setReuse(false);
      cloudHttp.setFollowRedirects(HTTPC_FORCE_FOLLOW_REDIRECTS);
      cloudHttp.setRedirectLimit(5);
      cloudHttp.setTimeout(12000);
      cloudHttp.addHeader("Cache-Control", "no-cache");
      cloudHttp.addHeader("Pragma", "no-cache");

      if (!cloudHttp.begin(cloudClient, cloudUrl)) {
        failOnlineOta("DOWNLOAD_FAILED");
        return;
      }

      const int statusCode = cloudHttp.GET();
      if (statusCode != HTTP_CODE_OK) {
        failOnlineOta("DOWNLOAD_FAILED");
        return;
      }
      cloudExpectedSize = cloudHttp.getSize();
      if (cloudExpectedSize <= 0) {
        failOnlineOta("INVALID_IMAGE_SIZE");
        return;
      }

      NetworkClient* imageStream = cloudHttp.getStreamPtr();
      if (imageStream == nullptr) {
        failOnlineOta("DOWNLOAD_FAILED");
        return;
      }

      // ESP32 app images start with 0xE9. Reject HTML, .ino source, JSON,
      // GitHub error pages, or any other non-firmware payload before touching
      // the OTA partition. This prevents a bad Firebase URL from becoming a
      // reboot/panic event.
      int firstByte = -1;
      const uint32_t firstByteDeadline = millis() + 3000;
      while (millis() < firstByteDeadline) {
        if (imageStream->available() > 0) {
          firstByte = imageStream->peek();
          break;
        }
        yield();
      }
      if (firstByte != 0xE9) {
        failOnlineOta("INVALID_FIRMWARE_IMAGE");
        return;
      }

      const size_t imageSize = static_cast<size_t>(cloudExpectedSize);
      if (!Update.begin(imageSize, U_FLASH)) {
        failOnlineOta("OTA_BEGIN_FAILED");
        return;
      }


      cloudBytesReceived = 0;
      cloudLastDataAt = millis();
      return;
    }

    if (millis() - cloudPhaseStartedAt >= WIFI_CONNECT_TIMEOUT_MS) {
      failOnlineOta("WIFI_FAILED");
    }
    return;
  }

  if (otaState == OtaState::CLOUD_DOWNLOADING) {
    NetworkClient* stream = cloudHttp.getStreamPtr();
    if (stream == nullptr) {
      failOnlineOta("DOWNLOAD_FAILED");
      return;
    }

    const int available = stream->available();
    if (available > 0) {
      uint8_t buffer[1024];
      const size_t requestLength = min(available, static_cast<int>(sizeof(buffer)));
      const int readLength = stream->read(buffer, requestLength);

      if (readLength > 0) {
        cloudLastDataAt = millis();

        if (Update.write(buffer, static_cast<size_t>(readLength)) != static_cast<size_t>(readLength)) {
          failOnlineOta("OTA_WRITE_FAILED");
          return;
        }

        cloudBytesReceived += static_cast<uint32_t>(readLength);
      }
    }

    if (cloudExpectedSize > 0 &&
        cloudBytesReceived >= static_cast<uint32_t>(cloudExpectedSize)) {
      setOtaState(OtaState::CLOUD_APPLYING);
      cloudPhaseStartedAt = millis();
      return;
    }

    if (!stream->connected() || millis() - cloudLastDataAt >= OTA_NO_DATA_TIMEOUT_MS) {
      if (cloudExpectedSize <= 0) {
        // Unknown-length response: reaching EOF is the completion condition.
        if (!stream->connected() && cloudBytesReceived > 0) {
          setOtaState(OtaState::CLOUD_APPLYING);
          cloudPhaseStartedAt = millis();
          return;
        }
      }

      failOnlineOta("DOWNLOAD_INCOMPLETE");
      return;
    }

    yield();
    return;
  }

  if (otaState == OtaState::CLOUD_APPLYING) {
    cloudHttp.end();

    const bool updateOk = Update.end(false);
    if (!updateOk || !Update.isFinished()) {
      failOnlineOta("OTA_FAILED");
      return;
    }

    saveOtaResult(cloudVersion.isEmpty() ? "SUCCESS" : "SUCCESS_" + cloudVersion);
    setOtaState(OtaState::SUCCESS);
    otaRestartAt = millis() + OTA_RESTART_DELAY_MS;
    clearCloudCredentials();
  }
}

// ===========================================================================
// Local OTA — boot-time Wi-Fi window only
// ===========================================================================
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
  xhr.open('POST','/update');
  xhr.upload.onprogress=e=>{
    if(e.lengthComputable)progress.value=(e.loaded/e.total)*100;
    status.textContent='Uploading... '+progress.value.toFixed(0)+'%';
  };
  xhr.onload=()=>{
    if(xhr.status===200){progress.value=100;status.textContent='Update verified. Green blink, then device will restart.';btn.disabled=true;}
    else { status.textContent='OTA failed. Wi-Fi remains active; you can try again.'; btn.disabled=false; }
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

static void localOtaUploadHandler() {
  HTTPUpload& upload = webServer.upload();

  if (upload.status == UPLOAD_FILE_START) {
    otaRestartAt = 0;
    otaActive = true;
    setOtaState(OtaState::LOCAL_UPLOAD);
    resetBlinkState();

    applyOtaSafeOutputs();

    if (!Update.begin(UPDATE_SIZE_UNKNOWN)) {
      saveOtaResult("OTA_BEGIN_FAILED");
      setOtaState(OtaState::FAILED);
      resetBlinkState();
      otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
      otaActive = false;
    }
    return;
  }

  if (upload.status == UPLOAD_FILE_WRITE) {
    if (otaState != OtaState::LOCAL_UPLOAD || !otaActive) return;
    if (Update.write(upload.buf, upload.currentSize) != upload.currentSize) {
      Update.abort();
      saveOtaResult("OTA_WRITE_FAILED");
      setOtaState(OtaState::FAILED);
      resetBlinkState();
      otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
      otaActive = false;
    }
    return;
  }

  if (upload.status == UPLOAD_FILE_END) {
    if (otaState != OtaState::LOCAL_UPLOAD || !otaActive) return;
    if (Update.end(true) && Update.isFinished()) {
      saveOtaResult("LOCAL_SUCCESS");
      setOtaState(OtaState::SUCCESS);
      otaActive = true;
      resetBlinkState();
      otaRestartAt = millis() + OTA_RESTART_DELAY_MS;
    } else {
      Update.abort();
      saveOtaResult("OTA_FAILED");
      setOtaState(OtaState::FAILED);
      resetBlinkState();
      otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
      otaActive = false;
    }
    return;
  }

  if (upload.status == UPLOAD_FILE_ABORTED) {
    otaRestartAt = 0;
    Update.abort();
    resetBlinkState();
    saveOtaResult("UPLOAD_ABORTED");
    setOtaState(OtaState::FAILED);
    otaFailureIndicatorUntil = millis() + OTA_FAILURE_INDICATOR_MS;
    otaActive = false;
  }
}

static void handleOtaRoot() {
  String html = FPSTR(LOCAL_OTA_PAGE);
  html.replace("%VERSION%", FW_VERSION);
  webServer.send(200, "text/html", html);
}

static void handleOtaPost() {
  if (otaState == OtaState::FAILED) {
    webServer.send(500, "text/plain", "OTA FAILED — Wi-Fi stays active; no restart.");
    return;
  }
  webServer.send(200, "text/plain", "OTA verified. Green indicator active; device will restart.");
}

static void startLocalOtaAp() {
  // Boot AP owns the radio exclusively for up to 10 seconds. BLE must remain
  // OFF during this window. A client connection moves the device into the
  // safe output-off OTA state and keeps BLE OFF while the AP remains active.
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

// ===========================================================================
// Command handlers
// ===========================================================================
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

  // Never allow the user/app to turn the cooling fan OFF while critical
  // hotside protection is active. The fan is the active cooling path.
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
    // Logical Peltier state changes to ON immediately for telemetry/control,
    // but the physical MOSFET output is ramped from 0% to 100% over
    // PELTIER_SOFT_START_MS by processPeltierSoftStart().
    peltierOn = true;
    applyCoolingOutputs();
  }

  reason = peltierOn ? "OK" : safetyReason();
  return peltierOn;
}

static bool forceAdaptiveFiveVolt() {
  // Retarget an in-flight selector transition, or start a new guarded bypass
  // transition. Fan/Peltier control state is intentionally preserved.
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

    // Every Adaptive ON starts from 5V. If a selector transition is already in
    // flight, retarget it to 5V rather than creating another transition.
    if (!forceAdaptiveFiveVolt()) {
      adaptiveOn = previousAdaptive;
      reason = "VOLTAGE_FORCE_FAILED";
      return;
    }

    applyCoolingOutputs();
    reason = "OK";

    // If already at 5V, battery logic may begin its normal upward delay now.
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

    // Every Adaptive OFF also returns to 5V. This bypasses the manual 1s guard
    // because it is a mode transition, not a user voltage selection.
    if (!forceAdaptiveFiveVolt()) {
      // Adaptive is already off, but preserve the requested state and report
      // the only failure condition available to the command caller.
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
    // Finalize the session with a fresh atomic state snapshot. This lets the
    // App receive phone battery + cooler state together before the UI unlocks.
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

  // Phone battery temperature is a 1 Hz data heartbeat. The voltage request
  // path is generated only when its 5V/9V/12V zone changes.
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

  // Let the queued CLOUDOTA ACK and any preceding BLE frames leave first.
  // After the bounded wait we start anyway, even if the phone disappeared.
  const bool queueDrained = bleTxCount == 0;
  const bool txSettled = queueDrained && millis() >= bleNextNotifyAt;
  const bool waitExpired = millis() - onlineOtaRequestedAt >= ONLINE_OTA_START_WAIT_MS;
  if (!txSettled && !waitExpired && bleClientConnected) return;

  onlineOtaStartPending = false;
  startOnlineOta();
}

// ===========================================================================
// Touch — ONE TTP223 sensor, firmware-owned gesture state machine
// ===========================================================================
// Gesture rules:
//   1x tap       -> next manual voltage (5V -> 9V -> 12V -> 5V)
//   2x tap <=500 ms -> RGB toggle
//   long press   -> Fan + Peltier ON/OFF
//
// The first tap is NEVER committed as a single tap immediately. It is held
// for the full double-click window so a second tap can cancel the pending
// single action. No delay() is used.
static constexpr uint32_t TOUCH_DEBOUNCE_MS = 50;
static constexpr uint32_t TOUCH_DOUBLE_CLICK_MS = 500;
static constexpr uint32_t TOUCH_LONG_PRESS_MS = 5000;

static bool touchRawState = false;
static bool touchStableState = false;
static uint32_t touchRawChangedAtMs = 0;
static uint32_t touchPressedAtMs = 0;
static uint32_t touchFirstTapReleasedAtMs = 0;
static bool touchPendingSingle = false;
static bool touchLongFired = false;

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
  sendAck("TOUCH_RGB", true, "OK");}

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

static void serviceTouch() {
  const uint32_t now = millis();
  const bool raw = digitalRead(PIN_TOUCH) == HIGH;

  // ---------------------------------------------------------------
  // Debounce raw GPIO level.
  // ---------------------------------------------------------------
  if (raw != touchRawState) {
    touchRawState = raw;
    touchRawChangedAtMs = now;
  }

  if (touchRawState != touchStableState &&
      now - touchRawChangedAtMs >= TOUCH_DEBOUNCE_MS) {
    touchStableState = touchRawState;

    if (touchStableState) {
      // Confirmed touch start.
      touchPressedAtMs = now;
      touchLongFired = false;
    } else {
      // Confirmed touch release.
      if (!touchLongFired && !otaActive) {
        if (touchPendingSingle &&
            now - touchFirstTapReleasedAtMs <= TOUCH_DOUBLE_CLICK_MS) {
          // Second tap arrived inside the double-click window.
          touchPendingSingle = false;
          touchFirstTapReleasedAtMs = 0;
          executeTouchDouble();
        } else {
          // First tap. Delay its single action until the double-click window
          // expires so a genuine second tap can still become DOUBLE.
          touchPendingSingle = true;
          touchFirstTapReleasedAtMs = now;
        }
      }
    }
  }

  // ---------------------------------------------------------------
  // Long press. Fire once after 5 seconds of stable touch.
  // ---------------------------------------------------------------
  if (touchStableState && !touchLongFired && !otaActive &&
      now - touchPressedAtMs >= TOUCH_LONG_PRESS_MS) {
    touchLongFired = true;
    touchPendingSingle = false;
    touchFirstTapReleasedAtMs = 0;
    executeTouchLong();
  }

  // ---------------------------------------------------------------
  // Commit a pending single tap only after the full double-click window.
  // ---------------------------------------------------------------
  if (touchPendingSingle && !touchStableState &&
      now - touchFirstTapReleasedAtMs > TOUCH_DOUBLE_CLICK_MS) {
    touchPendingSingle = false;
    touchFirstTapReleasedAtMs = 0;
    executeTouchSingle();
  }
}

static void setupTouch() {
  // TTP223 output is active HIGH. Start from the actual pin level so a
  // finger already touching the sensor during boot does not fabricate a tap.
  const bool initial = digitalRead(PIN_TOUCH) == HIGH;
  touchRawState = initial;
  touchStableState = initial;
  touchRawChangedAtMs = millis();
  touchPressedAtMs = initial ? millis() : 0;
  touchFirstTapReleasedAtMs = 0;
  touchPendingSingle = false;
  touchLongFired = false;
}

// ===========================================================================
// Setup / loop
// ===========================================================================
void setup() {
  Serial.begin(115200);

  // ========================================================================
  // NORMAL HARDWARE FIRST
  // ========================================================================
  pinMode(PIN_NTC, INPUT);
  pinMode(PIN_TOUCH, INPUT);
  setupTouch();
  pinMode(PIN_12V, OUTPUT);
  pinMode(PIN_9V, OUTPUT);
  pinMode(PIN_FAN, OUTPUT);
  pinMode(PIN_PELTIER, OUTPUT);

  digitalWrite(PIN_12V, OUTPUT_OFF);
  digitalWrite(PIN_9V, OUTPUT_OFF);
  digitalWrite(PIN_FAN, OUTPUT_OFF);
  digitalWrite(PIN_PELTIER, OUTPUT_OFF);

  analogReadResolution(12);
  analogSetPinAttenuation(PIN_NTC, ADC_11db);

  ledcAttach(PIN_FAN, FAN_PWM_FREQ, FAN_PWM_RESOLUTION);
  ledcWrite(PIN_FAN, 0);
  ledcAttach(PIN_PELTIER, PELTIER_PWM_FREQ, PELTIER_PWM_RESOLUTION);
  stopPeltierOutput();

  leds.init();
  stopUserLedOutput();

  loadSettings();

  // Runtime state is NEVER restored from NVS.
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

  // First sample immediately, then every 1 second.
  lastNtcReadMs = millis() - NTC_READ_INTERVAL_MS;
  sampleNtcIfDue();
  enforceSafety();

  // ========================================================================
  // SILENT BOOT WI-FI + NORMAL BLE
  // ========================================================================
  // AP is available for the boot window while cooler functions continue.
  // BLE is deliberately NOT initialized during this window.
  // Boot radio order is strict: Wi-Fi AP owns the radio for the first
  // 10 seconds. BLE is NOT started while the AP is active. If no client
  // connects, the loop turns Wi-Fi completely OFF after the 10-second
  // window and only then starts BLE.
  startLocalOtaAp();
}

void loop() {
  // ========================================================================
  // 1) OTA / RADIO RECOVERY HAS ABSOLUTE PRIORITY.
  // ========================================================================
  if (otaState == OtaState::SUCCESS &&
      otaRestartAt != 0 &&
      millis() >= otaRestartAt) {
    ESP.restart();
    return;
  }

  // -------------------------------------------------------------------------
  // Boot-time local OTA AP
  // -------------------------------------------------------------------------
  if (bootApActive) {
    webServer.handleClient();

    const uint8_t clientCount = WiFi.softAPgetStationNum();
    if (clientCount > 0) {
      if (!bootApHadClient) {
        bootApHadClient = true;
        bootApClientSafe = true;

        // The Wi-Fi client connection is the only boot event that forces the
        // cooler outputs OFF. The AP remains available for OTA handling.
        applyOtaSafeOutputs();
        stopUserLedOutput();
        stopBleForBootWiFiClient();
      }
    } else if (otaState != OtaState::LOCAL_UPLOAD && !otaActive &&
               millis() - bootApStartedAt >= BOOT_AP_TIMEOUT_MS) {
      // No Wi-Fi client after the full 10-second window: silently close the
      // AP and continue the normal BLE/cooler runtime.
      // stopLocalOtaAp() switches Wi-Fi fully OFF before this point.
      // Only after Wi-Fi is OFF do we initialize BLE.
      stopLocalOtaAp();
      bootApClientSafe = false;
      bootApHadClient = false;
      if (!BLEDevice::getInitialized()) {
        startBle();
      }
    }

    if (bootApHadClient || otaState == OtaState::LOCAL_UPLOAD || otaActive) {
      processLeds();
      return;
    }

    // IMPORTANT: no return here when Wi-Fi is only advertising. The normal
    // cooler loop continues during the silent 10-second AP window.
  }

  // -------------------------------------------------------------------------
  // Active local upload
  // -------------------------------------------------------------------------
  if (otaState == OtaState::LOCAL_UPLOAD) {
    webServer.handleClient();
    processLeds();
    return;
  }

  // -------------------------------------------------------------------------
  // Online OTA owns the radio path
  // -------------------------------------------------------------------------
  if (otaActive &&
      otaState != OtaState::SUCCESS &&
      otaState != OtaState::FAILED) {
    processOnlineOta();
    processLeds();
    return;
  }

  // -------------------------------------------------------------------------
  // Normal runtime. BLE TX is serialized before the next command/radio mode.
  // A fresh BLE connection receives a full state snapshot from the main loop.
  // This keeps the BLE callback state-neutral and prevents any connect-time
  // reset/overwrite of the active voltage or other cooler runtime settings.
  // -------------------------------------------------------------------------
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
  if (otaActive) {
    processOnlineOta();
    processLeds();
    return;
  }

  serviceTouch();
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

  // Keep the normal loop continuously schedulable; no delay() is used.
  yield();
}