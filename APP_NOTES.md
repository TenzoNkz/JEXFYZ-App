# JE X FYZ — CURRENT APP NOTES

## CURRENT IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Main source blob: 6def6eb10936bdec1923a6dfe1c809d5f71b1177
- Settings blob: f11235bab559b291928550e06984532581ddad6a
- Tests blob: d9ddfca369980fc0cd5ecdf80de1a10a5b1a2e18

## CURRENT PHASE
- App is in DEVELOPMENT + QC during the V4.7 integration-fix cycle; further changes remain limited to demonstrated QC findings.
- The latest verified APK predates the V4.7 realtime telemetry fix and does not prove V4.7 physical integration.

## CONTROL
- Peltier ON from Fan-OFF state now requires a confirmed FAN:ON, then a 2-second non-blocking wait, then a fresh guard check before PELTIER:ON.
- Fan already ON does not incur the 2-second precharge wait.
- Realtime QC fix: unsolicited FAN/PELTIER/FAN_SPEED telemetry is applied immediately as firmware-authoritative Control state.
- If BLE disconnects, Adaptive becomes active, or Fan is no longer ON during the 2-second wait, PELTIER:ON is not sent.
- Peltier still uses the existing 6-second command-confirmation timeout, while the firmware remains responsible for the 5-second Peltier soft-start.
- Notify QC fix: stale command/connection errors clear only after healthy live cooling/safety telemetry; actual safety warnings remain visible.

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
- Battery thresholds remain 5V 20–30°C and 12V 30–40°C; current firmware source is V4.7.
- Current Firmware OTA stage tokens are mapped for presentation.
- Wi-Fi password input is masked.
- Firebase supplies release metadata; GitHub hosts the fixed firmware BIN URL.
- Wi-Fi credentials remain in flutter_secure_storage.
- The V4.7 firmware telemetry fix preserves the P1 command contract and adds targeted App realtime/Notify reconciliation.

## BUILD / CI STATUS
- Latest verified downloadable App Build: workflow run 37245703677.
- Current release workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- Active workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- Workflow is a direct owner/title/token-gated issue-triggered Release build.
- Workflow publishes exactly one JEXFYZ-release.apk to GitHub Release jexfyz-latest.
- No Actions artifact is used by the current delivery path.
