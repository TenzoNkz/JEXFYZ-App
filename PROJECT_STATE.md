# JE X FYZ — CURRENT PROJECT STATE

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V4.6
- Active Firmware source: firmware/JEXFYZ-V4.6.ino
- Firmware source blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- App main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- App Build workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Direct issue-triggered Release workflow is authoritative; no reusable engine is active.
- Latest verified downloadable App Build: workflow run 37245703677 / GitHub Release jexfyz-latest.
- Latest verified APK: JEXFYZ-release.apk, 54,327,520 bytes, SHA-256 a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- This V4.6 firmware execution did not run App Build.

## CURRENT TASK RESULT
- [IMPLEMENTED] Hardware single-tap voltage now follows 5V → 9V → 12V → 9V → 5V → ...
- [IMPLEMENTED] Hardware long-press cooling ON forces Fan to 100%.
- [PRESERVED] Peltier OFF → ON keeps the existing cooperative 5-second soft-start.
- [PRESERVED] BOOT_AP_HARD_LIMIT_MS remains 60 seconds.
- [REMOVED] Rapid Hotside-rise protection and its dedicated slope/event state/history.
- [PRESERVED] Normal Hotside temperature-limit safety.
- [PRESERVED] Local OTA Golden/Protected path and single-radio Wi-Fi/BLE ownership.
- [PRESERVED] BLE UUIDs, P1 protocol, Adaptive, RGB, telemetry, and App behavior.
- Firmware version incremented from V4.5 to V4.6 because these are functional firmware changes.

## FIRMWARE
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- Core: Arduino-ESP32 3.3.7.
- GPIO contract: NTC 0, Touch 1, 12V 3, 9V 4, Peltier 5, Fan 6, WS2812 7.
- Fan PWM: 25 kHz, 8-bit, 50–100%; hardware touch ON forces 100%.
- Peltier PWM: 20 kHz, 8-bit, 5-second OFF→ON soft-start.
- Hotside NTC sample interval: 1 s.
- Hotside limit range: 40–50°C, default 45°C.
- NTC fault behavior remains Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- Rapid-rise slope protection is removed; no RAPID_HOTSIDE_RISE event is emitted.
- V4.6 compile/BIN/flash/physical runtime validation remains unverified.

## APP
- App source and UI were not functionally changed by this firmware execution.
- App continues to treat firmware telemetry as authoritative for physical/safety state.

## CI / BUILD
- App Build is manual issue-trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER.
- Required token: JEXFYZ_BUILD_TRIGGER_V1.
- Normal push/PR do not trigger App Build.
- Workflow uses Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, ubuntu-24.04.
- Release build is obfuscated and production-signed.
- Exactly one APK is published to GitHub Release jexfyz-latest as JEXFYZ-release.apk.
- No App Build was implied or executed by this firmware-only change.

## VALIDATION BOUNDARY
- Repository/source audit: PASS for V4.6 requested behavior.
- Firmware compile/BIN/flash: UNVERIFIED.
- Physical touch/fan/peltier behavior: UNVERIFIED.
- App Build: not run in this execution.
- Latest verified App APK evidence predates V4.6 and remains valid for the unchanged App source only.
