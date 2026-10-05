# JE X FYZ — CURRENT PROJECT STATE

## CURRENT PHASE
> **V5.2 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V5.2
- Firmware source change commit: 3729812c29a7c727e1b40ba18bc3b030b187904c
- Active Firmware source: firmware/JEXFYZ-V5.2.ino
- Firmware source blob: 3ecb7fef69a5db41475fe2b76d2ae1bc1fef616b
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- App main source blob: 93ed2e3e3cf2aadf503825675bb121f9c167689f
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: 6e6dd60b3b7a7615875851b7af027bc0bd2ea326
- App CONTROL source change commit: b9f316e50770acb66770515395344de6c6e80ea6
- Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- App Build workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Direct issue-triggered Release workflow is authoritative; no reusable engine is active.
- Latest verified downloadable App Build: workflow run 37261171475 / GitHub Release jexfyz-latest.
- Latest verified APK: JEXFYZ-release.apk, 54,327,520 bytes, SHA-256 b8045d0b6fa6d05b421bd6b1c0318d4ee4529734d7b471534700f95676200888.
- No App Build was executed for the CONTROL precharge change.

## APP HOME FAN SPEED DISPLAY QC — 2026-10-05
- [IMPLEMENTED] Fixed Home Fan Speed display for Adaptive + 12V: it now shows 100% instead of --.
- [PRESERVED] Manual + 12V continues to show the actual user-controlled Fan Speed.
- [PRESERVED] Adaptive Fan Speed remains non-editable; this is a display fix only.
- [IMPLEMENTED] Added regression coverage for Adaptive 12V = 100%, Manual 12V = configured speed, and 9V = 100%.
- [NOT BUILT HERE] App Build was not executed for this source fix.

## CURRENT APP SAFETY NOTIFY — 2026-10-05
- [IMPLEMENTED] Peltier restart notifications report the exact re-arm temperature (`hotLimit - 2°C`).
- [IMPLEMENTED] Touch ON/OFF ACKs are treated as valid results and surfaced cleanly; successful touch cooling is no longer shown as an error.
- [IMPLEMENTED] Retired `RAPID_HOTSIDE_RISE` notification wording was removed from the App.
- [IMPLEMENTED] Peltier failure notification avoids duplicating the firmware safety reason.

## V5.2 PELTIER SAFETY REARM FEEDBACK — 2026-10-05
- [IMPLEMENTED] Manual Peltier restart remains locked until Hotside <= hotLimit - 2°C after a Hotside safety event, including the 5V Adaptive terminal state.
- [IMPLEMENTED] Hardware Touch cooling ON now respects the same 2°C re-arm hysteresis and no longer bypasses the latch.
- [IMPLEMENTED] Any failed Peltier ON safety attempt gets a non-blocking 1-second red LED blink; a successful Peltier ON gets a non-blocking 1-second green LED blink.
- [IMPLEMENTED] App NOTIFY now explains the re-arm threshold dynamically and no longer surfaces the retired RAPID_HOTSIDE_RISE reason.
- [IMPLEMENTED] Touch cooling success/failure ACKs are presented as clean notifications; ON/OFF ACK reasons are no longer misclassified as errors.
- [IMPLEMENTED] Firmware version bumped V5.0 → V5.1 for this functional safety revision.
- [NOT BUILT HERE] App Build was not executed for this change.

## V5.0 SELECTOR / MOSFET / LED TIMING EXECUTION — 2026-10-05
- [IMPLEMENTED] Voltage selector: GPIO3 = 12V Optocoupler/Decoy, GPIO4 = 9V Optocoupler/Decoy; both OFF for 200 ms before the target selector is enabled, preventing simultaneous selector activation.
- [IMPLEMENTED] GPIO5 Peltier MOSFET and GPIO6 Fan MOSFET are not forcibly turned OFF during voltage changes; Peltier PWM state is preserved through the selector deadtime.
- [IMPLEMENTED] Fan is forced to 100% at the start of every voltage transition.
- [IMPLEMENTED] Fan Speed is adjustable only while already at 12V; commands during a voltage transition are rejected, and returning to 12V does not restore a previous speed preference.
- [IMPLEMENTED] HOTSIDE red LED blink duration is 10 seconds and is aligned with each 10-second HOTSIDE timing stage, including the 5V terminal stage.
- [IMPLEMENTED] Firmware version bumped V4.9 → V5.0 for this functional revision.
- [NOT BUILT HERE] App Build remains a separate operation.

## V4.9 HOTSIDE EXECUTION — 2026-10-05
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
- [IMPLEMENTED] Peltier Safety popup now queues FAN:ON and PELTIER:ON together; no App-side Fan telemetry wait remains between the two commands.
- [QC FIX] Firmware V4.9 publishes Fan/Peltier/Fan-speed realtime deltas from pre-mutation state snapshots.
- [QC FIX] App consumes unsolicited FAN/PELTIER/FAN_SPEED telemetry immediately and reconciles stale Notify errors only after healthy live safety telemetry.
- Firmware version incremented from V4.6 to V4.9 because this is a functional realtime-telemetry QC fix.

## QC / RELEASE STATE
- [VERIFIED] V5.0 source/static audit passed for the selector/MOSFET/Fan/LED timing revision.
- [UNVERIFIED] Arduino compilation, BIN generation, V5.1 flash/OTA, and App ↔ Firmware physical integration after this revision.
- [NOT RELEASED] V5.2 is not yet a released firmware.
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
- V5.2 compile/BIN/flash/OTA validation remains pending.

## APP
- App version remains 1.0.0+3.
- [IMPLEMENTED] CONTROL Peltier-start sequence: App queues FAN:ON then PELTIER:ON back-to-back; Firmware owns the 5-second Peltier soft-start.
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
- No App Build was executed for the popup start-sequence revision.

## VALIDATION BOUNDARY
- [VERIFIED] Repository/source audit for the requested V5.0 selector/MOSFET/Fan/LED behavior.
- [USER-CONFIRMED] V4.6 Firmware compilation, Online OTA, and hardware test succeeded before the V4.9 telemetry fix.
- [UNVERIFIED] Firmware compile independently reproduced in this environment.
- [UNVERIFIED] Final BIN generation.
- [UNVERIFIED] ESP32-C3 flash.
- [UNVERIFIED] Hardware-only touch/Fan/Peltier behavior.
- [UNVERIFIED] Hotside/NTC safety runtime tests.
- [UNVERIFIED] V5.2 Local OTA and Online OTA + GATT recovery.
- [UNVERIFIED] App Build after the safety/Notify fixes and App ↔ V5.2 physical integration.
- [NOT RELEASED] Release Gate is not complete.

## EXACT NEXT ACTION
> **Compile V5.2 → generate BIN → flash/OTA → Build App separately → install APK → App ↔ Firmware safety/Notify QC.**
