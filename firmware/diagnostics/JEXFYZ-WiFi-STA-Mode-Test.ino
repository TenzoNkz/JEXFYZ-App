#include <Arduino.h>
#include <WiFi.h>

// JE X FYZ diagnostic only.
// Arduino-ESP32 Core 3.3.7 public API boundary test.
// Purpose: distinguish generic Wi-Fi initialization failure from the AP path.
// No WebServer, Update, BLE, Preferences, NTC, PWM, RGB, or project logic.

static uint32_t lastStatusAt = 0;

void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.println("JE X FYZ: WIFI STA MODE DIAGNOSTIC");
  Serial.print("CORE=");
  Serial.println(ESP.getCoreVersion());
  Serial.print("CHIP=");
  Serial.println(ESP.getChipModel());
  Serial.print("CHIP_REV=");
  Serial.println(ESP.getChipRevision());

  Serial.print("STEP 1: BEFORE WiFi.getMode MODE=");
  Serial.println(static_cast<int>(WiFi.getMode()));

  Serial.println("STEP 2: BEFORE WiFi.mode(WIFI_STA)");

  const bool modeOk = WiFi.mode(WIFI_STA);

  Serial.print("STEP 3: WiFi.mode(WIFI_STA) RESULT=");
  Serial.println(modeOk ? "OK" : "FAIL");

  Serial.print("STEP 4: WiFi.getMode MODE=");
  Serial.println(static_cast<int>(WiFi.getMode()));

  Serial.println("RESULT: WIFI STA MODE READY");
}

void loop() {
  if (millis() - lastStatusAt >= 2000) {
    lastStatusAt = millis();
    Serial.print("STATUS: mode=");
    Serial.print(static_cast<int>(WiFi.getMode()));
    Serial.print(" status=");
    Serial.println(static_cast<int>(WiFi.status()));
  }
}
