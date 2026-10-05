## APP SAFETY NOTIFY / REARM — 2026-10-05
- App NOTIFY reports the exact Peltier re-arm threshold using `hotLimit - 2°C`.
- Failed Peltier ON safety requests are reported from the firmware reason; duplicate generic notices are suppressed.
- Touch ON/OFF ACKs are classified as successful outcomes and shown cleanly.
- Retired RAPID_HOTSIDE_RISE notification text is removed.
- App Build remains separate.

## V5.1 PELTIER SAFETY REARM FEEDBACK — 2026-10-05
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
- Firmware: V5.1
- Active source: firmware/JEXFYZ-V5.1.ino
- Firmware blob: e5a38482b09ce9f07f93b471914495238d9a81aa
- Firmware source change commit: 534bdfa94bdbe0c00bb05ffbb750ec8d07390a75
- App: 1.0.0+3
- App package: com.horizontalzzz.jexfyz
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified App Build: workflow run 37261171475 / GitHub Release jexfyz-latest
- Current App source has no fixed 2-second Fan precharge; Firmware 5-second Peltier soft-start is authoritative.

## CURRENT PHASE
> **V5.1 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

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
1. Compile V5.1.
2. Generate BIN.
3. Flash / OTA V5.1.
4. Hardware-only QC.
5. Safety QC.
6. Local OTA.
7. Online OTA/BLE recovery.
8. Build App separately and run App ↔ Firmware integration QC, including the V5.0 HOTSIDE safety sequence.
9. Release Gate.

## VALIDATION
- [VERIFIED] Source/static audit.
- [USER-CONFIRMED] V4.6 firmware compilation, Online OTA, and hardware test succeeded before the later V5.0 revision.
- [UNVERIFIED] V5.0 compile/BIN/flash/OTA and App ↔ V5.0 integration after this revision.
- [NOT RELEASED] V5.1.

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
