# JE X FYZ — CURRENT PROJECT STATE

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- HEAD: b612626861cee4f5f8b4d20e6ef0d88c5f0ca550
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Active Firmware: V4.4
- Active Firmware source: firmware/JEXFYZ-V4.4.ino
- Firmware source blob: acbd376b4b5a1f536e83c35b24600e85462de579
- App source baseline: lib/main.dart, blob 7a0003ff7aa9691468139714ec18d364e5896b38
- Latest verified App Build: #50

## FIRMWARE
- V4.3 Local OTA: PASS, user-confirmed.
- V4.3 Online OTA: PASS, user-confirmed.
- V4.4 adds explicit active-GATT disconnect before Online OTA Wi-Fi handoff.
- Local OTA remains Golden/Protected.
- Online OTA retains the V3.2-style bounded Wi-Fi/retry/result-indicator behavior.
- Online result flow: Wi-Fi BLUE → GitHub GREEN → download complete BLUE → flash success GREEN → restart; failure RED/recovery.
- Yellow 20/40/60/80/100% progress layer: removed.
- Equal firmware version: Up to date; any other valid version is eligible.
- Download remains cooperative and bounded per loop pass.
- Physical V4.4 flash/runtime validation: pending.

## APP
- App source/config/workflow unchanged by V4.4.
- Existing App BLE disconnect handler already clears live telemetry/session state.
- V4.4 is a firmware-only change; new App Build is not required unless App source/config changes.
- Latest verified Build #50 details are maintained in BUILD_NOTES.md.

## HARDWARE
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- Arduino Standard + official Arduino-ESP32 Core 3.3.7.
- GPIO 5 Peltier, GPIO 6 Fan, GPIO 0 Hotside NTC, GPIO 1 Touch, GPIO 3 12V, GPIO 4 9V, GPIO 7 WS2812.
- BLE and Wi-Fi are treated as mutually exclusive because the ESP32-C3 is single-radio for this product.
- No executable delay().
- No timing while() loops.
- Hotside NTC is the universal thermal safety input.

## CI / BUILD
- App workflow: .github/workflows/app-build.yml
- App workflow blob: 731f4a7a43bf58d01a382053457d1f67a4742c8a
- Trigger workflow: .github/workflows/app-build-trigger.yml
- Trigger blob: 89598aff0b006bb3db6819080a13965fc5a6247d
- Trigger issue title: JE X FYZ — BUILD APP TRIGGER
- Trigger token: JEXFYZ_BUILD_TRIGGER_V1
- Toolchain: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, ubuntu-24.04.
- Normal push/PR must not generate a release APK.

## VERSION / SOURCE RULES
- Every functional Firmware image change increments FW_VERSION.
- Active versioned .ino filename must match FW_VERSION.
- Keep one active versioned .ino in firmware/.
- Current source/workflow outrank historical notes.
- Documentation-only cleanup never changes firmware version.

## VALIDATION
Verified by source/static audit:
- braces balanced
- parentheses balanced
- brackets balanced
- executable delay() = 0
- timing while() = 0
- yellow 0xFFFF00 refs = 0
- stale Online OTA progress refs = 0
- explicit BLE GATT disconnect = 1

Pending:
- compile V4.4 in ArduinoDroid/Core 3.3.7
- generate/verify V4.4 BIN
- flash V4.4
- verify BLE disconnect and App telemetry stop at Online OTA start
- verify BLE reconnect + sync after restart
- verify Local OTA remains intact

## EXACT NEXT ACTION
Compile/flash V4.4 and test:
Update Firmware → BLE disconnects → App telemetry stops → Online OTA continues → restart → BLE reconnects → sync.
