## CURRENT V6.1 EXECUTION — 2026-10-12

- [IMPLEMENTED] Candidate firmware promoted from V6.0 to V6.1 at firmware/JEXFYZ-V6.1.ino; FW_VERSION is V6.1. The superseded V6.0 sketch is removed on this execution branch to preserve filename/version alignment and the one-active-sketch rule.
- [QC FINDING] User reported hardware restart when enabling Adaptive from 12V with Fan and Peltier ON; after reboot the App showed Adaptive OFF and did not surface a reset reason. Adaptive ON/OFF status indicators were not observed. The source showed that Adaptive rail handoff did not explicitly stop Peltier before selector deadtime; this was a credible sequencing hazard, but the physical reset root cause remains unverified.
- [FIX IMPLEMENTED] Adaptive ON now sets Peltier output OFF before selector outputs are released for the 200 ms deadtime. After validated completion at 5V, the existing 5 s Peltier OFF-to-ON soft-start is used to restore cooling.
- [FIX IMPLEMENTED] Adaptive OFF also removes Peltier load before a required rail change and restores a previously requested Peltier state only after the safe 5V endpoint, through the same 5 s soft-start. Failed transitions retain the safety path instead of silently claiming the rail changed.
- [FIX IMPLEMENTED] Adaptive ON orange feedback remains tied to successful activation. Adaptive OFF white feedback is deferred until the 5V transition completes and is skipped when NTC/Hotside safety owns the indication. A repeated OFF command when already OFF (including after reboot) is not a state change and does not emit the white transition indicator.
- [DIAGNOSTIC] Firmware prints BOOT RESET REASON: ... to Serial at startup so a future reproduction can capture BROWNOUT/PANIC/WDT even if App Notify hides UNKNOWN/POWER_ON or BLE reconnects too late.
- [PRESERVED] OTA workflow, BLE/P1, GPIO mapping, single-sample 1 Hz NTC reading, 200 ms selector deadtime, 1 s voltage guard, existing 5 s Adaptive upward dwell, and the App source were not intentionally changed. The only OTA-related source adjustment clears the new Adaptive staging flags at the existing safe-output boundary; OTA state-machine sequencing is unchanged.
- [AUDIT PASS] Source-level checks passed for version/file alignment, balanced delimiters, zero executable delay(), zero while() loops, exactly one NTC ADC-read call, GPIO3/4/5/6 mapping, 200 ms deadtime, 1 s voltage guard, 5 s Peltier soft-start, and retained OTA priority markers.
- [UNVERIFIED] ArduinoDroid/Core 3.3.7 compile, BIN generation, ESP32-C3 flash, physical reset/LED behavior, power-load regression, thermal regression, and Local/Online OTA runtime regression remain unverified. No firmware build or hardware test was available in this execution.
- [APP BUILD] Not run; this is a firmware-only change and repository rules do not imply an App Build.
- [NOT RELEASED] V6.1 remains DEVELOPMENT + QC / PRE-RELEASE — NOT RELEASED. The candidate is on branch fix/adaptive-power-sequencing; main remains at the V6.0 baseline pending review/merge.

> Earlier V6.0/V5.9 records below are historical. For this QC fix, reconcile against the V6.1 candidate source on fix/adaptive-power-sequencing; it has not been merged to main.


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
- Firmware candidate: V6.1
- Candidate source: firmware/JEXFYZ-V6.1.ino
- Candidate source blob: 3f8c61ef2add303b495b1cc19e6ee6be04cea028
- Candidate branch: fix/adaptive-power-sequencing (not merged); main baseline V6.0
- App: 1.0.0+3; App source unchanged by this fix
- Current phase: V6.1 candidate — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED
- App + Firmware remain one integrated contract.
- P1 remains mandatory for App BLE session readiness.
- OTA Local/Online, OTA state/recovery, and Wi-Fi↔BLE handoff remain protected/frozen.
- Firmware compile/BIN/flash/physical behavior: UNVERIFIED.
- App Build was not run by this firmware-only execution.

## QC NEXT
1. Compile V6.1 with ArduinoDroid / Arduino-ESP32 Core 3.3.7.
2. Generate V6.1 BIN and record image provenance.
3. Flash/update ESP32-C3 and capture boot Serial reset reason.
4. Verify Adaptive ON from 12V with Fan/Peltier ON: Peltier output OFF before selector transition, safe 5V completion, 5 s Peltier soft-start, orange three-blink indicator.
5. Verify Adaptive OFF returns safely to 5V; Peltier restoration uses 5 s soft-start where previously requested; white three-blink only after successful ON-to-OFF state change.
6. Check NTC invalid/Hotside limit, Fan/Peltier state consistency, GPIO selector exclusivity and voltage guard.
7. Run Local OTA Golden Path.
8. Run Online OTA + BLE recovery regression.
9. App-to-V6.1 integration QC; App Build remains separate and was not run.
10. Release Gate only after all required evidence passes.

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