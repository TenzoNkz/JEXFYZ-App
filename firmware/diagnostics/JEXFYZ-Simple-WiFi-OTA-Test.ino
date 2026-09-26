#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <Update.h>

// JE X FYZ — SIMPLE Arduino Standard Wi-Fi OTA TEST
// Arduino-ESP32 Core 3.3.7
// Intentionally simple: no custom Wi-Fi configuration,
// no BLE, no Preferences, no project logic.

const char* ssid = "JE X FYZ OTA";
const char* password = "0987654321";

WebServer server(80);

void setup() {
  Serial.begin(115200);

  Serial.println();
  Serial.println("JE X FYZ SIMPLE WIFI OTA");
  Serial.print("CORE: ");
  Serial.println(ESP.getCoreVersion());

  Serial.println("WIFI: starting SoftAP...");

  if (!WiFi.softAP(ssid, password)) {
    Serial.println("WIFI: SoftAP FAILED");
    return;
  }

  Serial.println("WIFI: SoftAP OK");
  Serial.print("WIFI: SSID = ");
  Serial.println(ssid);
  Serial.print("WIFI: IP = ");
  Serial.println(WiFi.softAPIP());

  server.on("/", HTTP_GET, []() {
    server.send(
      200,
      "text/html",
      "<h2>JE X FYZ OTA</h2>"
      "<form method='POST' action='/update' enctype='multipart/form-data'>"
      "<input type='file' name='update'>"
      "<input type='submit' value='UPDATE'>"
      "</form>"
    );
  });

  server.on(
    "/update",
    HTTP_POST,
    []() {
      if (Update.hasError()) {
        server.send(500, "text/plain", "OTA FAILED");
      } else {
        server.send(200, "text/plain", "OTA OK - RESTARTING");
        ESP.restart();
      }
    },
    []() {
      HTTPUpload& upload = server.upload();

      if (upload.status == UPLOAD_FILE_START) {
        Serial.print("OTA: ");
        Serial.println(upload.filename);

        if (!Update.begin(UPDATE_SIZE_UNKNOWN)) {
          Update.printError(Serial);
        }
      }
      else if (upload.status == UPLOAD_FILE_WRITE) {
        if (Update.write(upload.buf, upload.currentSize) != upload.currentSize) {
          Update.printError(Serial);
        }
      }
      else if (upload.status == UPLOAD_FILE_END) {
        if (!Update.end(true)) {
          Update.printError(Serial);
        } else {
          Serial.print("OTA: ");
          Serial.print(upload.totalSize);
          Serial.println(" bytes");
        }
      }
      else if (upload.status == UPLOAD_FILE_ABORTED) {
        Update.abort();
        Serial.println("OTA: ABORTED");
      }
    }
  );

  server.begin();
  Serial.println("HTTP: READY");
  Serial.println("RESULT: WIFI + OTA READY");
}

void loop() {
  server.handleClient();
}
