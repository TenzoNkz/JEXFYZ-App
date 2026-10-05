## 2026-10-06 — V5.5 PELTIER SAFETY REARM LED FEEDBACK
- [IMPLEMENTED] Normal Peltier ON/OFF no longer produces green/red Peltier LED feedback.
- [IMPLEMENTED] After Hotside Safety forces Peltier OFF, the existing manualPeltierSafetyLatch remains active until an explicit successful Peltier ON attempt.
- [IMPLEMENTED] Any blocked ON attempt while that latch is active blinks red for 1 second.
- [IMPLEMENTED] A successful ON attempt after Hotside reaches hotLimit - 2°C blinks green for 1 second and clears the latch.
- [PRESERVED] Hotside dwell LED remains 9 seconds red + final 1 second green and has LED priority over the short re-arm feedback.
- [COMMITTED] V5.5 source creation commit: adfb3e3860f6c7004e577981d668fef46f467d47.
- [COMMITTED] V5.4 source retirement commit: 12973ebace66f660c6c1b0a7a48407e96c02ea08.
- [COMMITTED] V5.5 follow-up safety-attempt correction commit: b29d050dcb7deea0ffc5339c76a37bf27a7dacb1.
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
- Firmware: V5.3
- Active source: firmware/JEXFYZ-V5.3.ino
- Firmware blob: d6b5262c0ed429999ef6a951841bca6b24296949
- Firmware source change commits: 85bf8acf79fd91f0d3bbbe2440bec8bab73774da → 90f459ac4720a3ec509543bcc4e83bde96e3d910
- App: 1.0.0+3
- App package: com.horizontalzzz.jexfyz
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified App Build: workflow run 37261171475 / GitHub Release jexfyz-latest
- Current App source has no fixed 2-second Fan precharge; Firmware 5-second Peltier soft-start is authoritative.

## CURRENT PHASE
> **V5.3 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## V5.3 ADAPTIVE VOLTAGE RISE DWELL — 2026-10-05
- Both Adaptive profiles use the same 5-second cooperative dwell after every completed upward voltage step.
- The first upward step after Adaptive reaches the required safe 5V state also waits 5 seconds.
- Downward Adaptive changes remain immediate.
- HOTSIDE_BATTERY evaluation now honors the same rise timer.

## IMPLEMENTED / FROZEN
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: 5-second soft-start, then 100%.
- BOOT_AP_HARD_LIMIT_MS: 60 seconds.
- Rapid Hotside-rise protection removed.
- Normal Hotside temperature-limit protection preserved.
- Local OTA Golden Path preserved.
- BLE/P1/UUIDs, Adaptive, RGB, telemetry, and App CI workflow preserved; V5.0 adds selector-only voltage deadtime, MOSFET-preserved voltage changes, 100% Fan transition behavior, and 10-second HOTSIDE LED timing.
- App CONTROL: Peltier Safety popup queues FAN:ON and PELTIER:ON back-to-back; Firmware owns the 5-second Peltier soft-start.
- App realtime fix: unsolicited FAN/PELTIER/FAN_SPEED telemetry updates Control; stale Notify errors reconcile against healthy live state.

## QC RULE
Functional source is frozen during QC. Only a demonstrated QC failure with a clear root cause justifies a targeted source change.

## QC NEXT
1. Compile V5.3.
2. Generate BIN.
3. Flash / OTA V5.3.
4. Hardware-only QC.
5. Safety QC.
6. Local OTA.
7. Online OTA/BLE recovery.
8. Build App separately and run App ↔ Firmware integration QC, including the V5.0 HOTSIDE safety sequence.
9. Release Gate.

## VALIDATION
- [VERIFIED] Source/static audit.
- [USER-CONFIRMED] V4.6 firmware compilation, Online OTA, and hardware test succeeded before the later V5.0 revision.
- [UNVERIFIED] V5.3 compile/BIN/flash/OTA and App ↔ V5.3 integration after this revision.
- [NOT RELEASED] V5.3.

## APP POPUP START SEQUENCE — 2026-10-05
- When the Peltier Safety popup is approved from Fan-OFF, the App starts FAN:ON and PELTIER:ON confirmation flows together.
- sendCommand() serializes the actual writes as FAN:ON → PELTIER:ON without waiting for Fan telemetry confirmation first.
- No App-side precharge/confirmation delay remains between the two commands.
- Firmware remains the final safety authority and owns the 5-second Peltier soft-start.
- App Build is separate and is not run by this source execution.

## V5.0 SELECTOR / MOSFET / LED TIMING — 2026-10-05
- Voltage selector GPIO3 = 12V Optocoupler/Decoy and GPIO4 = 9V Optocoupler/Decoy.
- Selector break-before-make: both selector outputs OFF for 200 ms, then the target selector output ON; never simultaneous.
- GPIO5 Peltier MOSFET and GPIO6 Fan MOSFET are not forcibly turned OFF during voltage changes.
- Fan is forced to 100% when a voltage transition begins; Fan Speed is adjustable only at 12V.
- Returning to 12V does not restore a previous Fan Speed preference; Fan remains at 100%.
- HOTSIDE LED red blink runs for 10 seconds during every HOTSIDE timing stage, including 5V terminal protection.
- Firmware Peltier OFF → ON 5-second soft-start remains unchanged.
- App Build is separate and is not run by this Firmware execution.

## V4.9 HOTSIDE EXECUTION — 2026-10-05
- 12V Hotside limit: Fan ON, Peltier OFF, 10s dwell, then 9V.
- 9V Hotside limit: Fan OFF, Peltier OFF, 10s dwell, then 5V.
- 5V Hotside limit: terminal safety state; Adaptive exits and manual Peltier restart is required.
- Manual-mode Hotside preserves selected voltage.
- Rapid Hotside-rise protection remains absent.
- App fixed 2-second precharge removed; Firmware 5-second Peltier soft-start remains authoritative.
- App Build intentionally not executed here.
