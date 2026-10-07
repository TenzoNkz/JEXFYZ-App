## CURRENT V5.9 INTEGRATED QC + HOTSIDE RECOVERY UPDATE — 2026-10-07

- [VERIFIED] Current main HEAD after this execution: d13883f075c075672fb0c8c906877cba8402b7b4 plus subsequent documentation-sync commits.
- [VERIFIED] Active Firmware V5.9: firmware/JEXFYZ-V5.9.ino; updated blob 6fec4071056aca4fd93cbeaecfc81d7f6d19ef60.
- [VERIFIED] Active App 1.0.0+3: lib/main.dart; blob 8a2e97946c4bc4ac2aa3ea09e3a1aca4b15fc6a0.
- [VERIFIED] App settings blob f11235bab559b291928550e06984532581ddad6a; tests blob 2da4bff01d3eed749eeba873e9ec2e577c04def9.
- [VERIFIED] Firmware static audit after the thermal update: no executable delay(), no timing while(), no RAPID_HOTSIDE_RISE; one NTC ADC sample per 1 s remains intact.
- [VERIFIED] Current App includes P1 validation, serialized command confirmation, coalesced heartbeat, Peltier ACK reason handling, OTA stage presentation, notification channel, and NOT_STICKY service.
- [VERIFIED] The earlier heartbeat-helper lexical-scope issue is corrected in the current main.dart by commit 7d5f0f5adf7fec92b33c92a3b6a6eb58a9ab36a8.
- [PROTECTED] OTA Local, OTA Online, radio handoff, state/recovery, image validation, URL/path contract, and BLE/P1 architecture remain frozen.
- [IMPLEMENTED] Adaptive Hotside thermal stage is 20 s per rail with 19 s red + final 1 s blue; <= hotLimit - 2°C re-arms Peltier and shows green 2x; 12V -> 9V -> 5V each gets its own 20 s stage.
- [IMPLEMENTED] Manual Hotside protection keeps red blinking until <= hotLimit - 2°C, then green 2x; 5V Adaptive remains locked after an unrecovered 20 s stage and requires manual Peltier restart.

# JE X FYZ — CURRENT PROJECT STATE

## V5.8 PELTIER REARM + NTC SINGLE-SAMPLE QC FIX — 2026-10-06
- [IMPLEMENTED] Firmware promoted V5.7 → V5.8 for the reproducible Peltier safety-lock and NTC sampling QC findings.
- [FIX] Effective Peltier safety lock now clears automatically once Hotside reaches `hotLimit - 2°C`; one-shot green re-arm feedback remains armed for the next successful Peltier ON.
- [FIX] Locked Peltier ON attempts retain the red 1-second feedback path while the effective safety lock is active.
- [FIX] Hotside NTC is exactly one calibrated ADC reading every 1 second; the V5.6 16-sample trimmed-mean path is retired.
- [PRESERVED] NTC remains 10K / 10K divider / Beta 3950 with the existing 3.3 V reference assumption.
- [PRESERVED] OTA, BLE/P1, GPIO mapping, Adaptive 5-second upward dwell, selector deadtime, voltage guard, and Peltier 5-second soft-start were not intentionally changed.
- [USER-CONFIRMED] V5.7 compiled successfully and was successfully updated to the hardware before this V5.8 QC fix.
- [UNVERIFIED] V5.8 compile, BIN generation, flash/update, and physical regression remain pending.
- [AUDIT PASS] Final V5.8 source audit: no executable `delay()`, no timing `while()` loop, NTC sample-count path removed, brace/parenthesis balance is zero, and only the intended firmware/docs files changed versus pre-fix HEAD.


## TRANSFER PROTOCOL V2 — 2026-10-06
- [IMPLEMENTED] `CHAT_TRANSFER.md` was upgraded to a detailed boot/transfer protocol to prevent context repetition between chats.
- [FROZEN] The transfer protocol does not authorize functional source changes, Firmware release, or App Build.
- [CURRENT] Active Firmware is V5.9 at `firmware/JEXFYZ-V5.9.ino`.
- [CURRENT] Current main HEAD is tracked by the latest repository commit..
- [POLICY] New chats must reconcile the transfer snapshot against current repository truth before acting and must not ask for already-documented project facts.


## CURRENT PHASE
> **V5.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V5.9
- Active Firmware source: firmware/JEXFYZ-V5.9.ino
- Firmware source blob: 11879cda3e96411c16cc372a176dcef6b71ebe94
- Firmware compile/BIN/flash/physical regression: UNVERIFIED
- OTA Protection reminder: ACTIVE in OTA_PROTECTION.md.
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- App main source blob: df4a244723420f8057745275838d7e07c1e0c82a
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: 2da4bff01d3eed749eeba873e9ec2e577c04def9
- App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Release status: NOT RELEASED
- This V5.9 execution did not run App Build.


## OTA PROTECTION REMINDER — 2026-10-06
- [IMPLEMENTED] OTA_PROTECTION.md is the repository's documentation-only protection reminder.
- [PRESERVED] Firmware OTA runtime behavior and App OTA behavior were not changed by the protection reminder.
- [PRESERVED] Anti-downgrade is OFF; any valid firmware version different from the device version may be installed.
- [PRESERVED] No CI-enforced OTA seal, manifest, lock file, or OTA-security workflow is active.
- [USER-CONFIRMED] V5.7 OTA successfully updated the physical hardware.
- [POLICY] OTA changes require a demonstrated OTA defect, clear root cause, explicit approval, and full OTA re-audit.

## V5.7 TTP223 TOUCH ACCURACY QC FIX — 2026-10-06
- [QC FIX / FINALIZED] Double-tap resolution is held until the 800 ms decision window; 3+ taps inside the same sequence remain cancel/no-action as in the prior gesture contract.
- [COMMITTED] Latest V5.7 Touch FSM correction commit: 77591d7406aa8613a3dc9beb33828af5a592d8d5.
- [QC FIX / IMPLEMENTED] TTP223 GPIO input now passes through a 30 ms stable-state qualification layer before gesture processing.
- [QC FIX / IMPLEMENTED] Valid tap duration is qualified at 60–500 ms using the raw HIGH duration, preventing qualification overhead from rejecting short but real taps.
- [QC FIX / IMPLEMENTED] Double-tap decision window is 800 ms and starts after the first valid tap release.
- [QC FIX / IMPLEMENTED] If the second tap starts before the 800 ms deadline, release may occur slightly after the deadline and still resolves as double tap.
- [QC FIX / IMPLEMENTED] A 1-second startup grace period ignores boot-time touch input; a touch already held during startup must be released before any new gesture is accepted.
- [PRESERVED] Single tap remains voltage sequence control, double tap remains RGB toggle, and long press remains 5 seconds.
- [IMPLEMENTED] Firmware promoted V5.6 → V5.7 for this targeted Touch accuracy correction.
- [USER-CONFIRMED] V5.7 compiled and was successfully updated to the hardware before the V5.8 fix.
- [UNVERIFIED] V5.8 compile/BIN/flash/physical functional QC remains pending.

## V5.6 NTC ADC FILTERING QC FIX — 2026-10-06
- [QC FIX / IMPLEMENTED] Hotside NTC sampling now uses a bounded 16-sample calibrated ADC burst once per 1-second sampling period.