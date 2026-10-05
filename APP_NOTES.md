# JE X FYZ — CURRENT APP NOTES

## CURRENT IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Main source blob: 8341c125489f5cf419ce7a76fb41b698e70a92dc
- Settings blob: f11235bab559b291928550e06984532581ddad6a
- Tests blob: 7f6650466b3f9e9d02ef43f889c1d184beeb2497

## CURRENT PHASE
- App is functionally FROZEN during Firmware V4.6 QC unless an integration QC finding requires an App fix.
- The latest verified APK predates V4.6 and does not prove V4.6 physical integration.

## CONTROL
- Peltier ON from Fan-OFF state now requires a confirmed FAN:ON, then a 2-second non-blocking wait, then a fresh guard check before PELTIER:ON.
- Fan already ON does not incur the 2-second precharge wait.
- If BLE disconnects, Adaptive becomes active, or Fan is no longer ON during the 2-second wait, PELTIER:ON is not sent.
- Peltier still uses the existing 6-second command-confirmation timeout, while the firmware remains responsible for the 5-second Peltier soft-start.

## BLE / SESSION
- flutter_blue_plus is the BLE transport.
- JE X FYZ service/RX/TX UUIDs are frozen.
- P1 SYNC/SYNC_READY remains the usable-session gate.
- Firmware telemetry remains authoritative for hardware and safety state.
- Passive Auto Connect remains permission-free and preference-controlled.
- Online OTA recovery is explicit and does not depend on passive Auto Connect.
- Expected Online OTA GATT disconnect is treated as an OTA lifecycle event, not a normal Bluetooth error.
- After OTA reconnect, the App completes normal P1 sync and surfaces the one-shot OTA result.

## OTA / FIRMWARE SYNC
- Firmware update flow remains OTAENTER, SSID, PASS, URL, VERSION, CLOUDOTA.
- OTA_UP_TO_DATE is recognized as a one-shot result.
- App uses firmware-reported Adaptive Ceiling and current SAFETY OK/LOCKED semantics.
- Battery thresholds match Firmware V4.6: 5V 20–30°C and 12V 30–40°C.
- Current Firmware OTA stage tokens are mapped for presentation.
- Wi-Fi password input is masked.
- Firebase supplies release metadata; GitHub hosts the fixed firmware BIN URL.
- Wi-Fi credentials remain in flutter_secure_storage.
- The V4.6 firmware-only change removes rapid-rise protection; no App command contract change was required.

## BUILD / CI STATUS
- Latest verified downloadable App Build: workflow run 37245703677.
- Current release workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- Active workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- Workflow is a direct owner/title/token-gated issue-triggered Release build.
- Workflow publishes exactly one JEXFYZ-release.apk to GitHub Release jexfyz-latest.
- No Actions artifact is used by the current delivery path.
