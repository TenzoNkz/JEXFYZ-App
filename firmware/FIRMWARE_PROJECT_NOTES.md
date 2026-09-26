# JE X FYZ FIRMWARE — PROJECT MEMORY / ENGINEERING NOTES

> Firmware-specific memory is kept separate from APP_PROJECT_NOTES.md.

## Current source
- Authoritative source: firmware/JEXFYZ.ino
- Current source version: V3.2
- Target: ESP32-C3 Super Mini
- The current source uses WS2812FX 1.4.7 and lists Adafruit NeoPixel as an external dependency.
- The current source does not include OneButton; the build workflow does not invent an unused dependency.

## Distribution architecture
- Source stays inside the private JEXFYZ-App repository under firmware/.
- GitHub Actions compiles automatically when firmware/JEXFYZ.ino changes and also supports manual dispatch.
- Compiled release binaries are published to public repository TenzoNkz/JEXFYZ-Firmware.
- Public distribution uses manifest.json plus releases/JEXFYZ-Vx.x.bin.
- The App consumes the public manifest over HTTPS.
- Firebase is not used for firmware release metadata.

## Build environment
- Arduino CLI via arduino/setup-arduino-cli@v2.
- ESP32 Arduino core pinned to 3.2.1.
- WS2812FX pinned to 1.4.7.
- Adafruit NeoPixel pinned to 1.12.5.

## Publishing secret
- GitHub Actions secret required in JEXFYZ-App: FIRMWARE_REPO_TOKEN.
- The token must have Contents: Read and write access to TenzoNkz/JEXFYZ-Firmware.
- The token must never be embedded in firmware, APK, or manifest.

## OTA contract
- App supplies the existing BLE OTA commands: OTAENTER, SSID, PASS, URL, VERSION, CLOUDOTA.
- Release URLs are HTTPS raw GitHub URLs.
- No SHA/hash field is used in the firmware update metadata contract.

## Validation status
- Workflow configuration is added in the private repository.
- GitHub Actions firmware Run #2 failed because Arduino CLI requires the sketch directory name and main .ino filename to match; workflow is now corrected to stage as build/JEXFYZ/JEXFYZ.ino. The user has configured FIRMWARE_REPO_TOKEN; publish validation remains pending.
- The public repository retains its existing JEXFYZ.cpp.bin as the initial baseline; the workflow removes that legacy filename after the first automated release.
