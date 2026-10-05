# JE X FYZ — CURRENT PROJECT STATE

## CURRENT PHASE
> **V4.8 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V4.8
- Firmware source change commit: d03998ac5137e475bc1f6778931b25a509068a28
- Active Firmware source: firmware/JEXFYZ-V4.8.ino
- Firmware source blob: d47b62edbf275032780ef05d6ac3be1df06e350b
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- App main source blob: 6def6eb10936bdec1923a6dfe1c809d5f71b1177
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: d9ddfca369980fc0cd5ecdf80de1a10a5b1a2e18
- Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- App Build workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Direct issue-triggered Release workflow is authoritative; no reusable engine is active.
- Latest verified downloadable App Build: workflow run 37245703677 / GitHub Release jexfyz-latest.
- Latest verified APK: JEXFYZ-release.apk, 54,327,520 bytes, SHA-256 a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- No App Build was executed for the CONTROL precharge change.

## V4.8 HOTSIDE EXECUTION — 2026-10-05
- [IMPLEMENTED] HOTSIDE 12V limit: Fan remains ON, Peltier OFF, 10-second dwell, then 9V.
- [IMPLEMENTED] HOTSIDE 9V limit: Fan OFF, Peltier OFF, 10-second dwell, then 5V.
- [IMPLEMENTED] HOTSIDE 5V terminal state: Adaptive exits, Peltier remains OFF, and manual restart is required after thermal re-arm.
- [IMPLEMENTED] Manual-mode Hotside protection preserves the selected voltage.
- [IMPLEMENTED] Manual Peltier safety re-arm hysteresis: 2°C below hotLimit.
- [IMPLEMENTED] App fixed 2-second Peltier precharge removed; firmware soft-start remains authoritative.
- [NOT BUILT HERE] App Build is intentionally separate from this execution.

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
- [QC FIX] Firmware V4.8 publishes Fan/Peltier/Fan-speed realtime deltas from pre-mutation state snapshots.
- [QC FIX] App consumes unsolicited FAN/PELTIER/FAN_SPEED telemetry immediately and reconciles stale Notify errors only after healthy live safety telemetry.
- Firmware version incremented from V4.6 to V4.8 because this is a functional realtime-telemetry QC fix.

## QC / RELEASE STATE
- [VERIFIED] V4.8 source/static audit passed for the realtime telemetry fix.
- [UNVERIFIED] Arduino compilation, BIN generation, V4.8 flash/OTA, and App ↔ Firmware physical integration after the fix.
- [NOT RELEASED] V4.8 is not yet a released firmware.
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
- V4.8 compile/BIN/flash/OTA validation remains pending.

## APP
- App version remains 1.0.0+3.
- [IMPLEMENTED] CONTROL Peltier-start sequence: App confirms FAN:ON then sends PELTIER:ON; Firmware owns the 5-second Peltier soft-start.
- Fan already ON -> Peltier ON remains immediate; no App-side precharge timer.
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
- [VERIFIED] Repository/source audit for the requested V4.8 realtime telemetry fix.
- [USER-CONFIRMED] V4.6 Firmware compilation, Online OTA, and hardware test succeeded before the V4.8 telemetry fix.
- [UNVERIFIED] Firmware compile independently reproduced in this environment.
- [UNVERIFIED] Final BIN generation.
- [UNVERIFIED] ESP32-C3 flash.
- [UNVERIFIED] Hardware-only touch/Fan/Peltier behavior.
- [UNVERIFIED] Hotside/NTC safety runtime tests.
- [UNVERIFIED] V4.8 Local OTA and Online OTA + GATT recovery.
- [UNVERIFIED] App Build after the realtime fix and App ↔ V4.8 physical integration.
- [NOT RELEASED] Release Gate is not complete.

## EXACT NEXT ACTION
> **Compile V4.8 → generate BIN → flash/OTA → Build App → install APK → App ↔ Firmware realtime Control/Notify QC.**
