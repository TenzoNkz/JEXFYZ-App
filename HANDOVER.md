## CURRENT V6.0 EXECUTION — 2026-10-08

- [IMPLEMENTED] Firmware promoted V5.9 → V6.0 at firmware/JEXFYZ-V6.0.ino; FW_VERSION is V6.0.
- [IMPLEMENTED] Adaptive Profile is runtime-only. Default after boot is HOTSIDE; HOTSIDE_BATTERY remains the optional second Adaptive mode and is not stored in Preferences.
- [IMPLEMENTED] Persistent firmware settings are Hotside Limit, Battery 5V Limit, Battery 12V Limit, RGB ON/OFF, RGB Mode, RGB Brightness, and RGB Color.
- [IMPLEMENTED] All persistent setting changes share a 10-second quiet-period debounce. Every new change resets the timer; after 10 seconds without change, only values different from the persisted NVS shadow are written.
- [IMPLEMENTED] LED modes are now Static, Breath, Mirror Pulse, Comet, Dual Chase, Left/Right, and Rainbow. Center Out and Outer In are retired.
- [IMPLEMENTED] Firmware publishes LED animation phase/cycle telemetry; App preview uses that firmware phase and mirrors the physical 4-left/4-right LED layout.
- [PRESERVED] OTA, single-radio Wi-Fi/BLE handoff, BLE/P1, GPIO mapping, NTC 1 Hz single-sample path, selector deadtime, voltage guard, Peltier soft-start, thermal safety, and Adaptive 5-second upward dwell were not intentionally changed.
- [AUDIT PASS] Source-level invariants passed for V6.0 version alignment, LED mode set, HOTSIDE default, non-persistent Adaptive Profile, LED phase protocol, GPIO mapping, and single NTC ADC read path.
- [UNVERIFIED] V6.0 ArduinoDroid compilation, BIN generation, ESP32-C3 flash, physical LED synchronization, thermal regression, Local/Online OTA regression, and App Build remain unverified.
- [NOT RELEASED] Project remains DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED.

> Earlier V5.9 sections remain historical and do not override current V6.0 source/workflow.

## 2026-10-07 — V5.9 APP LOCALIZATION / NOTIFY CLEANUP
- [IMPLEMENTED] English is the master/reference language for all user-facing App copy.
- [IMPLEMENTED] Indonesian copy was aligned to identical meaning and natural UI terminology.
- [IMPLEMENTED] Reset notifications no longer show raw `Reset: POWER_ON` style text.
- [IMPLEMENTED] Known internal safety/command reasons are mapped to concise localized user-facing text.
- [IMPLEMENTED] Notify error-state detection works with both English and Indonesian wording.
- [IMPLEMENTED] Home Notify message/status styles explicitly disable text decoration.
- [IMPLEMENTED] Localization tests were synchronized.
- [UNVERIFIED] Flutter analyze/test and App Build for the updated source.

## CURRENT V5.9 INTEGRATED QC + HOTSIDE RECOVERY UPDATE — 2026-10-07

- [VERIFIED] Functional execution started from main HEAD 414cc6959d9fd5d89968da19b9473b317b0cbba7; final firmware update/comment commits completed before documentation-sync commits.
- [VERIFIED] Firmware: V5.9 at firmware/JEXFYZ-V5.9.ino; latest firmware blob 6fec4071056aca4fd93cbeaecfc81d7f6d19ef60.
- [VERIFIED] App: 1.0.0+3; package com.horizontalzzz.jexfyz; main blob 06850f297087b11789d3daa239f272dbe7591f32; settings blob 8bcbfbc6a91eb6274d641c0921a0411aa01bebd7; widget-test blob 430e5542ed80cb2170c4236511f94e2615cea5ba2.
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
- [VERIFIED] CHAT_TRANSFER save commit: 3d21b33b5c96640f7393a4956ad2ccb868639644.
- [VERIFIED] This Handover note is documentation-only; latest main HEAD is checked after the save sequence.
- [VERIFIED] Active Firmware V5.3: `firmware/JEXFYZ-V5.3.ino`, blob d6b5262c0ed429999ef6a951841bca6b24296949.
- [VERIFIED] Both Adaptive profiles share the 5-second upward-voltage dwell; safe-5V Adaptive startup also starts the dwell; downward changes remain immediate.
- [VERIFIED] App main source blob: 48406cda017be1ce939ff682497324bf3680a7f3.
- [OPEN QUESTION] Historical App Build records conflict between run 37261171475 (PROJECT_STATE) and run 37268139253 (APP_NOTES); no independent Actions-page recheck was possible in this session.
- [VERIFIED] CHAT_TRANSFER.md save commit: 3d21b33b5c96640f7393a4956ad2ccb868639644; saved blob fc00fdf83cd461f4f76e1edca6b53453111f1137.

## APP SAFETY NOTIFY / REARM — 2026-10-05
- App NOTIFY reports the exact Peltier re-arm threshold using `hotLimit - 2°C`.
- Failed Peltier ON safety requests are reported from the firmware reason; duplicate generic notices are suppressed.
- Touch ON/OFF ACKs are classified as successful outcomes and shown cleanly.
- Retired RAPID_HOTSIDE_RISE notification text is removed.
- App Build remains separate.

## V5.2 PELTIER SAFETY REARM FEEDBACK — 2026-10-05
- Peltier remains locked until Hotside <= hotLimit - 2°C after a safety latch, including the 5V Adaptive terminal state.
- Hardware Touch cooling ON now enforces the same re-arm threshold; it cannot bypass the latch.
- Failed Peltier ON attempts blink red for 1 second; successful Peltier ON attempts blink green for 1 second.
- App NOTIFY reports the configured re-arm temperature and cleaned ACK success/failure wording.
- App Build is separate and is not run by this Firmware/App source execution.

## APP HOME FAN SPEED DISPLAY QC — 2026-10-05
- Home Fan Speed now displays 100% when Adaptive is ON at 12V, matching Firmware behavior.
- Manual 12V remains displayable at the firmware-reported user-selected speed.
- The Adaptive speed control remains locked; only the display logic changed.
- Regression coverage added for Adaptive 12V, Manual 12V, and 9V cases.
- App Build is separate and was not run for this source fix.

# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: **V5.9**
- Active source: `firmware/JEXFYZ-V5.9.ino`
- Firmware source blob: `11879cda3e96411c16cc372a176dcef6b71ebe94`
- App: **1.0.0+3**
- App package: `com.horizontalzzz.jexfyz`
- App main blob: `df4a244723420f8057745275838d7e07c1e0c82a`
- App tests blob: `2da4bff01d3eed749eeba873e9ec2e577c04def9`
- Current phase: **V5.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**
- App + Firmware are one integrated contract.
- P1 is mandatory for App BLE session readiness.
- Peltier safety re-arm is unified across BLE and hardware Touch.
- OTA Local/Online, OTA state/recovery, and Wi-Fi↔BLE handoff remain protected/frozen.
- Android `versionName "Telegram @horizontalzzz"` is intentional and unchanged.
- App Build was not executed by this source integration batch.

## QC NEXT
1. Compile V5.9.
2. Generate V5.9 BIN.
3. Flash/update ESP32-C3 and verify image provenance.
4. Hardware-only control and safety QC.
5. Local OTA Golden Path.
6. Online OTA + BLE recovery.
7. App↔V5.9 integration QC.
8. Explicit App Build.
9. Release Gate.
## TRANSFER PROTOCOL V2
- [IMPLEMENTED] `CHAT_TRANSFER.md` is now the detailed cross-chat boot/transfer protocol.
- [POLICY] New chats read it first, reconcile current `main`, and do not ask the user to repeat established facts.
- [PRESERVED] Functional Firmware/App behavior, BLE/P1, OTA runtime, hardware safety, and App Build behavior are unchanged by the protocol update.
- [VERIFIED] Transfer Protocol v2 is documentation-only.

## OTA PROTECTION
- [ACTIVE] `OTA_PROTECTION.md` is the documentation-only OTA protection reminder.
- [FROZEN] Local OTA, Online OTA, state machine, radio handoff, recovery, validation, timeout/retry, and App OTA version-selection contracts.
- [PRESERVED] Anti-downgrade remains OFF.
- [USER-CONFIRMED] V5.7 OTA update reached the physical hardware successfully.
- [UNVERIFIED] Full final-image OTA regression remains a QC gate.

## QC NEXT
1. Compile V5.7.
2. Generate V5.7 BIN.
3. Verify flash/image provenance.
4. Hardware-only functional QC.
5. Safety QC.
6. Local OTA Golden Path.
7. Online OTA + BLE recovery.
8. App ↔ V5.7 integration QC.
9. Explicit App Build.
10. Release Gate.

## VALIDATION BOUNDARY
- [VERIFIED] Repository source/workflow reconciliation for this transfer.
- [USER-CONFIRMED] V5.7 OTA update to hardware succeeded.
- [UNVERIFIED] Full V5.7 compile/BIN/physical QC/App integration/Release Gate.

## HISTORICAL HANDOVER
Older V4.x–V5.6 records remain below this current handover as history only.
They MUST NOT override the current V5.7 source or current repository configuration.