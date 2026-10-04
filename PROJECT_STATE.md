# JE X FYZ — CURRENT PROJECT STATE

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Current source state is V4.5 firmware + synchronized App; see Git history for exact HEAD.
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Active Firmware: V4.5
- Active Firmware source: firmware/JEXFYZ-V4.5.ino
- Firmware source blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App main source blob: 8ebd878b116d7ef093b6df54894a7db876eb0f02
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Latest verified App Build: #50 (older App source; not validation for current source)

## FIRMWARE
- V4.4 Local OTA: user-confirmed PASS.
- V4.4 Online OTA: user-confirmed PASS.
- V4.5 fixes active-GATT disconnect ordering, keeps Online OTA on the V3.2-style path, emits OTA_UP_TO_DATE as a one-shot event, and gates rapid-rise protection on Peltier ON.
- Local OTA remains Golden/Protected.
- Online OTA: Wi-Fi BLUE → GitHub GREEN → download complete BLUE → flash success GREEN → restart; failure RED/recovery.
- Yellow Online OTA progress layer remains removed.
- Any valid different firmware version is eligible; equal version is Up to date.
- Timing remains cooperative; no executable delay() and no timing while() loops.

## APP
- App BLE/P1 architecture is preserved.
- Online OTA recovery now treats the expected GATT disconnect as an OTA lifecycle event, reconnects independently of passive Auto Connect, and restores the normal P1 sync contract.
- App now uses firmware-reported Adaptive Ceiling, exact battery threshold ranges (5V 20–30°C / 12V 30–40°C), current OTA stage tokens, and actual SAFETY OK/LOCKED semantics.
- OTA password entry is masked.
- App Build has not been triggered by the V4.5 source changes.

## HARDWARE
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- Arduino Standard + official Arduino-ESP32 Core 3.3.7.
- GPIO 5 Peltier, GPIO 6 Fan, GPIO 0 Hotside NTC, GPIO 1 Touch, GPIO 3 12V, GPIO 4 9V, GPIO 7 WS2812.
- BLE and Wi-Fi are mutually exclusive because the ESP32-C3 is single-radio for this product.

## CI / BUILD
- App workflow: .github/workflows/app-build.yml
- Trigger workflow: .github/workflows/app-build-trigger.yml
- App build remains manual-by-issue-trigger only.
- Firmware-only or source-only changes do not trigger a release APK automatically.
- Latest verified App Build #50 remains the last verified APK for its own source commit.

## VALIDATION BOUNDARY
- V4.4 OTA was physically user-confirmed successful.
- V4.5 source/static audit is complete.
- V4.5 ArduinoDroid/Core 3.3.7 compile, BIN generation, flashing, and physical OTA validation are still pending.
- Current App source changes are not covered by Build #50.

## EXACT NEXT ACTION
Compile V4.5 with ArduinoDroid/Core 3.3.7, generate/verify BIN, flash hardware, then validate Online OTA BLE disconnect/reconnect and Local OTA. Run Build App only on an explicit Build App command.
