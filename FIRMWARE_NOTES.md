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


## CURRENT V5.9 INTEGRATED QC BATCH — 2026-10-06

- Firmware source: `firmware/JEXFYZ-V5.9.ino`.
- App: 1.0.0+3.
- Status: DEVELOPMENT + QC / PRE-RELEASE — NOT RELEASED.
- App + Firmware are one integrated contract.
- Peltier safety re-arm: effective Hotside lock; thermal re-arm is signaled with 2 green blinks at <= hotLimit - 2°C; Touch/BLE/Adaptive use the same effective safety gate.
- Adaptive Hotside recovery: 20 seconds per rail with 19 seconds red blink + final 1 second blue blink; re-arm before the boundary resumes Peltier on the same rail.
- Adaptive sequence: 12V -> 9V -> 5V, each with its own 20-second thermal stage. If 5V still fails to re-arm after 20 seconds, Adaptive exits and the Peltier stays locked until manual restart.
- Manual Hotside protection: selected voltage is preserved; red blink continues for the entire lock until the <= hotLimit - 2°C re-arm threshold; then 2 green blinks.
- Normal successful Peltier ON no longer emits green feedback; green is reserved for the thermal re-arm event.
- App: P1 required for session readiness; stale Peltier re-arm notice clears on healthy safety telemetry; safety-sensitive paired startup is serialized; PHONE:BT is coalesced; ONLINE_IMAGE_VALIDATE is mapped.
- Android notification preference is not saved ON unless runtime permission is granted.
- Foreground BLE-support service is NOT_STICKY.
- OTA Local, OTA Online, Wi-Fi↔BLE handoff, OTA state/recovery, image validation, URL/path contract, and BLE/P1/SYNC architecture remain FROZEN.
- `versionName "Telegram @horizontalzzz"` is intentional and unchanged.
- App Build was NOT requested by this execution.
- V5.9 compile/flash/physical regression and final release gate remain pending.

# JE X FYZ — CURRENT FIRMWARE NOTES

## ACTIVE CANDIDATE
- Version: V6.1
- Source: firmware/JEXFYZ-V6.1.ino
- Blob: 3f8c61ef2add303b495b1cc19e6ee6be04cea028
- Branch: fix/adaptive-power-sequencing (not merged)
- Main baseline: V6.0
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## CURRENT PHASE
- DEVELOPMENT + QC / PRE-RELEASE
- NOT RELEASED
- Source-level audit: PASS.
- Compile/BIN/flash/physical/OTA regression: UNVERIFIED.
- Functional source is frozen again unless a new reproducible QC defect is established.

## V5.9 INTEGRATED QC — 2026-10-06
- Peltier safety lock auto-releases when Hotside is at or below `hotLimit - 2°C`.
- Thermal re-arm readiness is indicated directly when Hotside reaches the configured 2°C hysteresis threshold; a later Peltier ON command has no additional green indicator.
- While the effective lock is still active, a forced Peltier ON attempt keeps the red 1-second indication.
- NTC conversion math remains unchanged; only the sampling method returned from the V5.6 multi-sample burst to one reading per second.

## CONTROL CONTRACT
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling long press ON: Fan 100%.
- Peltier OFF → ON: 5-second cooperative soft-start, unchanged.
- Hotside NTC sampling is exactly 1 calibrated ADC reading every 1 second.
- NTC temperature has no median, trimmed mean, EMA, Kalman, sorting, or multi-sample burst; safety uses the single current ADC result.
- Normal Peltier ON/OFF emits no Peltier LED indicator.
- After Hotside safety forces Peltier OFF, failed re-arm ON attempts blink red for 1 s; a successful re-arm ON attempt at hotLimit - 2°C blinks green for 1 s.
- Adaptive activation cannot bypass an active Peltier safety latch.
- Fan remains 25 kHz, 8-bit, 50–100% for App-controlled operation.
- Voltage selector deadtime 200 ms; voltage guard 1 s.
- Adaptive HOTSIDE safety timing uses a 20-second thermal stage per rail; both Adaptive profiles retain the 5-second dwell after every upward voltage step; Peltier restart safety uses the 2°C re-arm hysteresis.
- TTP223 Touch uses 30 ms press/release qualification, 60–500 ms valid tap duration, 800 ms double-tap decision window from first valid release, second-tap grace, 1 s startup grace, and preserved 3+ tap cancellation.
- RGB/touch double-tap behavior remains unchanged at the command level; only input recognition timing/filtering was hardened.

## SAFETY CONTRACT
- Hotside NTC remains the universal thermal safety input and is sampled every 1 s.
- Hotside limit remains 40–50°C, default 45°C.
- NTC fault remains Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- Rapid Hotside-rise slope protection is removed completely.
- No RAPID_HOTSIDE_RISE safety event is emitted.
- Normal Hotside temperature-limit protection remains active, with a 20-second Adaptive step-down dwell and continuous Manual re-arm indication.

## OTA CONTRACT
Local OTA:
- Golden/Protected.
- Boot AP hard limit remains 60 seconds.
- Wi-Fi and BLE radio ownership remain mutually exclusive.

Online OTA:
- V3.2-style bounded Wi-Fi retry path.
- No yellow progress layer.
- Existing OTA result LED/state-machine behavior remains unchanged.
- Download processing remains cooperative.

## OTA PROTECTION — 2026-10-06
- Repository reminder: OTA_PROTECTION.md.
- OTA path is protected/frozen during normal feature work.
- OTA changes require a demonstrated OTA defect, explicit discussion/approval, and full OTA re-audit.
- Anti-downgrade remains OFF; any valid firmware version different from the device version may be selected.
- This reminder is a process guard; it does not replace compile, BIN, OTA, or hardware QC.

## V5.4 CHANGE — HOTSIDE DWELL FAN + LED — 2026-10-06
- Adaptive HOTSIDE safety keeps Fan ON at 100% throughout each full 20-second thermal dwell.
- Every completed HOTSTEP keeps Fan ON at 100% while Hotside safety remains active.
- Hotside Adaptive dwell LED: 19 seconds red blink, then 1 second blue blink; green 2x is shown only when the Hotside re-arm threshold is reached.
- Promoted Firmware V5.3 → V5.4.
- No blocking timing was introduced.

## V5.3 CHANGE — ADAPTIVE VOLTAGE RISE DWELL
- Both HOTSIDE and HOTSIDE_BATTERY Adaptive profiles now wait 5 seconds after a completed upward voltage transition before the next increase.
- Adaptive activation from safe 5V starts the same 5-second upward dwell.
- Downward Adaptive steps remain immediate.
- The existing non-blocking millis() timing model is preserved.
- Firmware version bumped V5.2 → V5.3.

## V5.2 CHANGE
- Promoted V4.7 → V4.9 for the approved HOTSIDE-only safety sequence and realtime telemetry baseline.
- Preserved the hardware touch voltage bounce sequence.
- Hardware cooling ON forces Fan to 100%.
- Preserved the existing Peltier 5-second OFF→ON soft-start.
- Removed the rapid Hotside-rise slope/event protection only.
- Implemented HOTSIDE 12V 20s → 9V; HOTSIDE 9V 20s → 5V; 5V receives the same 20s stage and becomes a terminal Peltier lock if still unrearmed.
- Preserved the pre-mutation cooling snapshots so Fan/Peltier/Fan-speed transitions remain realtime.

## STATIC AUDIT
- 4907 lines.
- Firmware version/file alignment: V5.7 / JEXFYZ-V5.7.ino.
- Only one active versioned .ino exists under firmware/.
- executable delay() = 0 (comments excluded).
- timing while() = 0.
- RAPID_HOTSIDE_RISE = 0.
- rapid-rise state/history identifiers = 0.
- GPIO Peltier = 5; Fan = 6.
- BOOT_AP_HARD_LIMIT_MS = 60000.
- PELTIER_SOFT_START_MS = 5000.
- PELTIER_SAFETY_ATTEMPT_INDICATOR_DURATION_MS = 1000.
- HOT_PELTIER_OFF_MS = 10000.

## QC GATES
- Compile V5.4.
- Generate BIN.
- Flash/OTA ESP32-C3.
- Hardware-only control QC.
- V5.4 Peltier safety/selector/Adaptive rise-dwell/HOTSide sequence QC.
- Local OTA Golden Path.
- Online OTA + BLE recovery.
- App ↔ Firmware integration after the separately executed App Build.

## VALIDATION BOUNDARY
- V4.4 OTA: user-confirmed PASS for all OTA paths before V4.5 promotion.
- V4.7 source/static audit: PASS.
- V4.7 compile/BIN/flash/physical validation: pending.