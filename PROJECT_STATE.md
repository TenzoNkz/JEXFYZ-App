## CURRENT V5.9 INTEGRATED QC + HOTSIDE RECOVERY UPDATE — 2026-10-07

- [VERIFIED] Current main HEAD after this execution: d50e49d2574ca9408ae0e7c22486be2801cbee1e.
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

