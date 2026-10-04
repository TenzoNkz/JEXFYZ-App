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
- Current release workflow: .github/workflows/jexfyz-build.yml
- Current release workflow blob: 08a137b4d315cc12e830a7e8dbc1ea40c3d2873d.
- Legacy app-build.yml and app-build-trigger.yml are deleted.
- APK delivery now uses GitHub Release tag jexfyz-latest; the workflow does not use Actions-artifact upload.
- New workflow run #1 remains a historical artifact-quota failure; the new Release-asset path is not yet validated by a fresh build.
