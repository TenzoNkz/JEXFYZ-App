#include <Arduino.h>

// JE X FYZ diagnostic only.
// Pure Arduino runtime boundary test for Arduino-ESP32 Core 3.3.7.
// Purpose: prove whether the sketch reaches setup()/loop() before any Wi-Fi code.
// No WiFi, WebServer, Update, BLE, Preferences, NTC, PWM, RGB, or ESP-IDF API.

static uint32_t lastHeartbeatAt = 0;

void setup() {
  Serial.begin(115200);

  Serial.println();
  Serial.println("JE X FYZ: PURE ARDUINO RUNTIME DIAGNOSTIC");
  Serial.println("CORE RUNTIME: Arduino.h ONLY");
  Serial.println("STEP 1: setup() ENTERED");

  Serial.print("STEP 2: CORE=");
  Serial.println(ESP.getCoreVersion());

  Serial.print("STEP 3: CHIP=");
  Serial.println(ESP.getChipModel());

  Serial.print("STEP 4: CHIP_REV=");
  Serial.println(ESP.getChipRevision());

  Serial.println("RESULT: SETUP OK");
}

void loop() {
  const uint32_t now = millis();

  if (now - lastHeartbeatAt >= 1000) {
    lastHeartbeatAt = now;
    Serial.println("HEARTBEAT: LOOP OK");
  }
}
