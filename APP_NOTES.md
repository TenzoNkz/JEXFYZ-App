# JE X FYZ — CURRENT APP NOTES

## IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- Settings blob: f11235bab559b291928550e06984532581ddad6a

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
- Battery thresholds match Firmware V4.5: 5V 20–30°C and 12V 30–40°C.
- Current Firmware OTA stage tokens are mapped for presentation.
- Wi-Fi password input is masked.
- Firebase supplies release metadata; GitHub hosts the fixed firmware BIN URL.
- Wi-Fi credentials remain in flutter_secure_storage.

## BUILD STATUS
- Build #51 failed at Dart analysis because _startCloudOta was missing its closing brace; fixed in commit ea5261230245fc86061cdf85f65ccd0208e607d3.
- Build #52 passed App compilation and signing but failed in the workflow signing-output shell pipeline; fixed in commit e33141efd47b8f1ca025e832097e1106d9119b65.
- Build #53 passed audit, analysis, tests, APK compilation, and production signing verification, but artifact upload failed because GitHub Actions artifact quota was exhausted.
- Current workflow publishes one replaceable APK artifact and no separate symbols artifact.
- Build #50 remains the latest verified downloadable APK; #53 has no downloadable artifact.
