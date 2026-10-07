## CURRENT V5.9 INTEGRATED QC + HOTSIDE RECOVERY UPDATE — 2026-10-07

- [VERIFIED] Functional execution started from main HEAD 414cc6959d9fd5d89968da19b9473b317b0cbba7; firmware update committed as d13883f075c075672fb0c8c906877cba8402b7b4.
- [VERIFIED] Firmware: V5.9 at firmware/JEXFYZ-V5.9.ino; latest firmware blob 6fec4071056aca4fd93cbeaecfc81d7f6d19ef60.
- [VERIFIED] App: 1.0.0+3; package com.horizontalzzz.jexfyz; main blob 8a2e97946c4bc4ac2aa3ea09e3a1aca4b15fc6a0.
- [IMPLEMENTED] V5.9 integrated App/Firmware QC changes remain present.
- [IMPLEMENTED] New Hotside recovery contract: 20 s Adaptive stage per rail, 19 s red + 1 s blue, green 2x only on <= hotLimit - 2°C re-arm, continuous Manual red until re-arm, and 5V terminal lock after an unrecovered 20 s Adaptive stage.
- [VERIFIED] The earlier heartbeat-helper scope issue is corrected; current helper is top-level.
- [PROTECTED] OTA Local/Online and Wi-Fi↔BLE handoff remain frozen.
- [UNVERIFIED] V5.9 compile, BIN, flash, physical, OTA, App integration, and release gates.
- [NOT RELEASED] App Build was not run by this transfer save.

# TRANSFER PROTOCOL V2 — 2026-10-06

## 2026-10-06 — V5.8 PELTIER REARM + NTC SINGLE-SAMPLE QC FIX
- [IMPLEMENTED] Active source promoted to `firmware/JEXFYZ-V5.8.ino`.
- [FIX] Peltier safety lock releases automatically at `hotLimit - 2°C`; the next successful Peltier ON retains the green 1-second re-arm feedback.
- [FIX] Locked Peltier ON attempts emit red 1-second feedback while the effective safety lock is active.
- [FIX] NTC sampling is exactly one calibrated ADC reading every 1 second; the V5.6 16-sample trimmed-mean path is retired.
- [PRESERVED] No OTA, BLE, GPIO, Adaptive timing, selector timing, voltage guard, or Peltier soft-start changes.
- [USER-CONFIRMED] V5.7 compile + hardware update succeeded before this fix.
- [UNVERIFIED] V5.8 compile/BIN/flash/physical QC is pending.
- [AUDIT PASS] Static source audit passed: no executable `delay()`, no timing `while()` loop, single NTC ADC sample path, latch auto-release path present, and no App source/workflow change.


- [IMPLEMENTED] `CHAT_TRANSFER.md` is now the detailed cross-chat boot protocol.
- [POLICY] New chats must read it first, reconcile current `main`, and avoid repeating established context questions.
- [CURRENT] V5.8 firmware QC fix is implemented; App source/build remains unchanged.
- [VERIFIED] Pre-write main HEAD: `c7faf134742fc6fdbebc3f66469c8aa5dd9980c6`.

## 2026-10-06 — V5.7 TTP223 TOUCH ACCURACY QC FIX
- [IMPLEMENTED] Firmware V5.7 is active at firmware/JEXFYZ-V5.7.ino.
- [IMPLEMENTED] TTP223 input uses 30 ms PRESS/RELEASE qualification before gesture processing.
- [IMPLEMENTED] Valid tap duration is 60–500 ms; duration is measured from raw HIGH start to raw LOW transition so qualification does not shrink the usable tap interval.
- [IMPLEMENTED] Double-tap window is 800 ms from first valid release with second-tap grace; double resolves at the decision boundary and 3+ taps in the same sequence remain cancel/no-action.
- [IMPLEMENTED] Startup grace is 1 second, and boot-held touch is ignored until a qualified release occurs.
- [PRESERVED] 1x Voltage, 2x RGB, 5 s long press, no delay(), and cooperative timing contracts.
- [COMMITTED] V5.7 source promotion commit: d2ec5d56383f25a105835b10698f62cf19cbf5df.
- [COMMITTED] V5.7 Touch FSM correction commit: 77591d7406aa8613a3dc9beb33828af5a592d8d5.
- [COMMITTED] V5.6 source retirement commit: 38f8f2738cca18fbac3830d241baa1f5596cc719.
- [UNVERIFIED] V5.7 compile, BIN generation, flash, physical touch behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.7 is not released.

## 2026-10-06 — V5.6 NTC ADC FILTERING QC FIX
- [IMPLEMENTED] Firmware V5.6 is active at firmware/JEXFYZ-V5.6.ino.
- [IMPLEMENTED] Hotside NTC uses 16 calibrated ADC samples per 1-second sample period, trims 4 low + 4 high values, and averages the remaining 8.
- [PRESERVED] NTC model remains 10K / 10K divider / Beta 3950 with the existing 3.3 V reference assumption.
- [PRESERVED] No temperature EMA/Kalman filter, VREF guess, voltage clamp, offset calibration, delay(), or timing loop was introduced.
- [COMMITTED] V5.6 source promotion commit: 1c5159652584bea8e26878a61e88f44aff5e3713.
- [COMMITTED] V5.5 source retirement commit: c342e2e25c508e38f5ffa33aeffa05ac149d4eee.
- [UNVERIFIED] V5.6 compile, BIN generation, flash, physical safety behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.6 is not released.

## 2026-10-06 — V5.5 PELTIER SAFETY REARM LED FEEDBACK
- [IMPLEMENTED] Normal Peltier ON/OFF no longer produces green/red Peltier LED feedback.
- [IMPLEMENTED] After Hotside Safety forces Peltier OFF, the existing manualPeltierSafetyLatch remains active until an explicit successful Peltier ON attempt.
- [IMPLEMENTED] Any blocked ON attempt while that latch is active blinks red for 1 second.
- [IMPLEMENTED] A successful ON attempt after Hotside reaches hotLimit - 2°C blinks green for 1 second and clears the latch.
- [PRESERVED] Hotside dwell LED remains 9 seconds red + final 1 second green and has LED priority over the short re-arm feedback.
- [COMMITTED] V5.5 source creation commit: adfb3e3860f6c7004e577981d668fef46f467d47.
- [COMMITTED] V5.4 source retirement commit: 12973ebace66f660c6c1b0a7a48407e96c02ea08.
- [COMMITTED] V5.5 follow-up safety-attempt correction commit: b29d050dcb7deea0ffc5339c76a37bf27a7dacb1.
- [COMMITTED] V5.5 final latch-consistency correction commit: 87c69ce33024e9653efbe9f52cbce84a857efaf4.
- [IMPLEMENTED] Adaptive activation is blocked while the Peltier safety latch is active; the latch can only clear on a successful re-arm ON attempt.
- [UNVERIFIED] V5.5 compile, BIN generation, flash, physical safety behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.5 is not released.

## 2026-10-06 — V5.4 HOTSIDE DWELL FAN + LED QC FIX
- [IMPLEMENTED] Firmware V5.4 is active at `firmware/JEXFYZ-V5.4.ino`.
- [IMPLEMENTED] Adaptive Hotside safety keeps Fan ON at 100% during the complete 10-second thermal dwell.
- [IMPLEMENTED] Completed HOTSTEP transitions keep Fan ON at 100% while Hotside protection remains active.
- [IMPLEMENTED] Hotside dwell LED sequence is 9 seconds red blink followed by 1 second green blink.
- [IMPLEMENTED] Functional source changed only for these reproducible QC findings; no unrelated feature/refactor change.
- [COMMITTED] V5.4 source creation commit: fd883ca695cab2f35014b3cf069fa9454ae6bc89.
- [COMMITTED] V5.3 source retirement commit: 65d971616c793e7dd056c6a7896d552516fe626c.
- [UNVERIFIED] V5.4 compile, BIN generation, flash, physical safety behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.4 is not released.

## CHAT-LIMIT RECONCILIATION — 2026-10-05
- [VERIFIED] Repository main HEAD before CHAT_TRANSFER write: 3a54d83956f357750684a32279952cbd7fb484f8.