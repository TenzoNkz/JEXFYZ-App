# JE X FYZ — CURRENT APP NOTES

## CURRENT IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- Settings blob: f11235bab559b291928550e06984532581ddad6a
- Tests blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160

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

## BUILD / CI STATUS
- Build #51: [VERIFIED] source parser failure; fixed in ea5261230245fc86061cdf85f65ccd0208e607d3.
- Build #52: [VERIFIED] signing-shell pipefail/SIGPIPE failure; fixed in e33141efd47b8f1ca025e832097e1106d9119b65.
- Build #53: [VERIFIED] audit/analysis/tests/compile/signing passed; [BLOCKED] artifact creation due Actions quota.
- Latest verified downloadable APK remains Build #50.
- Current release workflow blob: 5c7faeb8fece972179a0607ffd2278bdfd174704.
- Current trigger workflow blob: 04d2293725e97c3cbc67ce8b6f0d9c1230802afd.
- No source/App behavior change is made by the present chat-limit transfer.
