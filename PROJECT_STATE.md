# JE X FYZ — CURRENT PROJECT STATE

## CURRENT PHASE
> **V4.6 — CODE COMPLETE → QC / PRE-RELEASE → NOT RELEASED**

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V4.6
- Firmware source change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d
- Active Firmware source: firmware/JEXFYZ-V4.6.ino
- Firmware source blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- App main source blob: 8341c125489f5cf419ce7a76fb41b698e70a92dc
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: 7f6650466b3f9e9d02ef43f889c1d184beeb2497
- Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- App Build workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Direct issue-triggered Release workflow is authoritative; no reusable engine is active.
- Latest verified downloadable App Build: workflow run 37245703677 / GitHub Release jexfyz-latest.
- Latest verified APK: JEXFYZ-release.apk, 54,327,520 bytes, SHA-256 a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- No App Build was executed for the CONTROL precharge change.

## TRANSFER / MEMORY STATE
- [VERIFIED] Latest chat-limit transfer snapshot save commit: b59b63fa2a65ccd5ce45dec0cfb18f97d76989b7.
- [VERIFIED] Final CHAT_TRANSFER verification commit: 590d9ebcafe9a9dc5e0961343a3c2f4250d0e4aa.

## CURRENT TASK RESULT
- [IMPLEMENTED] Hardware single-tap voltage now follows 5V → 9V → 12V → 9V → 5V → ...
- [IMPLEMENTED] Hardware long-press cooling ON forces Fan to 100%.
- [PRESERVED] Peltier OFF → ON keeps the existing cooperative 5-second soft-start.
- [PRESERVED] BOOT_AP_HARD_LIMIT_MS remains 60 seconds.
- [REMOVED] Rapid Hotside-rise protection and its dedicated slope/event state/history.
- [PRESERVED] Normal Hotside temperature-limit safety.
- [PRESERVED] Local OTA Golden/Protected path and single-radio Wi-Fi/BLE ownership.
- [PRESERVED] BLE UUIDs, P1 protocol, Adaptive, RGB, telemetry, and existing App behavior outside the targeted CONTROL change.
- [IMPLEMENTED] When Peltier is requested ON while Fan is OFF, App now waits 2 seconds after confirmed FAN=ON before sending PELTIER:ON.
- Firmware version incremented from V4.5 to V4.6 because these are functional firmware changes.

## QC / RELEASE STATE
- [VERIFIED] V4.6 requested source/static audit passed.
- [UNVERIFIED] Arduino compilation, BIN generation, flash, physical hardware behavior, V4.6 OTA, and App ↔ Firmware physical integration.
- [NOT RELEASED] V4.6 is not yet a released firmware.
- Functional source is frozen during QC unless a demonstrated QC defect requires a targeted fix.

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
- App version remains 1.0.0+3.
- [IMPLEMENTED] CONTROL Peltier-start sequence: when Fan was OFF, App sends FAN:ON, waits for confirmed FAN=ON, waits 2 seconds, re-validates connection/Adaptive/Fan state, then sends PELTIER:ON.
- Fan already ON -> Peltier ON remains immediate; no extra 2-second wait.
- App continues to treat firmware telemetry as authoritative for physical/safety state.
- App Build remains separate and was not executed by this change.

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
- [VERIFIED] Repository/source audit for the requested V4.6 behavior.
- [USER-CONFIRMED] V4.6 Firmware compilation and Online OTA update succeeded in the user's environment.
- [UNVERIFIED] Firmware compile independently reproduced in this environment.
- [UNVERIFIED] Final BIN generation.
- [UNVERIFIED] ESP32-C3 flash.
- [UNVERIFIED] Hardware-only touch/Fan/Peltier behavior.
- [UNVERIFIED] Hotside/NTC safety runtime tests.
- [UNVERIFIED] Local OTA on V4.6.
- [UNVERIFIED] Online OTA + GATT disconnect/BLE recovery on V4.6.
- [UNVERIFIED] App Build after the CONTROL change and App ↔ V4.6 physical integration, including the new 2-second Fan precharge timing.
- [NOT RELEASED] Release Gate is not complete.

## EXACT NEXT ACTION
> **Build App → install APK → App ↔ Firmware V4.6 integration QC, including CONTROL Fan → 2 s → Peltier behavior.**
