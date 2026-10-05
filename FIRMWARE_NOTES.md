# JE X FYZ — CURRENT FIRMWARE NOTES

## ACTIVE
- Version: V5.7
- Source: firmware/JEXFYZ-V5.7.ino
- Blob: 05044824a6ec15e77634dffc16c14b4bddada8bb
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## CURRENT PHASE
- CODE COMPLETE
- QC / PRE-RELEASE
- NOT RELEASED
- Functional source is frozen unless QC demonstrates a real defect.

## CONTROL CONTRACT
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling long press ON: Fan 100%.
- Peltier OFF → ON: 5-second cooperative soft-start, unchanged.
- Hotside NTC sampling uses 16 calibrated ADC samples, trims 4 low + 4 high outliers, and averages the remaining 8 samples.
- NTC temperature has no additional EMA/Kalman smoothing; safety remains responsive to the filtered ADC result.
- Normal Peltier ON/OFF emits no Peltier LED indicator.
- After Hotside safety forces Peltier OFF, failed re-arm ON attempts blink red for 1 s; a successful re-arm ON attempt at hotLimit - 2°C blinks green for 1 s.
- Adaptive activation cannot bypass an active Peltier safety latch.
- Fan remains 25 kHz, 8-bit, 50–100% for App-controlled operation.
- Voltage selector deadtime 200 ms; voltage guard 1 s.
- Adaptive HOTSIDE safety timing uses the 10-second step-down sequence; both Adaptive profiles use a 5-second dwell after every upward voltage step; Peltier restart safety uses the 2°C re-arm hysteresis.
- TTP223 Touch uses 30 ms press/release qualification, 60–500 ms valid tap duration, 800 ms double-tap window, second-tap grace, and 1 s startup grace.
- RGB/touch double-tap behavior remains unchanged at the command level; only input recognition timing/filtering was hardened.

## SAFETY CONTRACT
- Hotside NTC remains the universal thermal safety input and is sampled every 1 s.
- Hotside limit remains 40–50°C, default 45°C.
- NTC fault remains Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- Rapid Hotside-rise slope protection is removed completely.
- No RAPID_HOTSIDE_RISE safety event is emitted.
- Normal Hotside temperature-limit protection remains active, with a 10-second step-down dwell.

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

## V5.4 CHANGE — HOTSIDE DWELL FAN + LED — 2026-10-06
- Adaptive HOTSIDE safety keeps Fan ON at 100% throughout each full 10-second thermal dwell.
- Every completed HOTSTEP keeps Fan ON at 100% while Hotside safety remains active.
- Hotside dwell LED: 9 seconds red blink, then 1 second green blink.
- The 10-second thermal dwell itself is unchanged.
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
- Implemented HOTSIDE 12V hold 10s → 9V; HOTSIDE 9V hold 10s → 5V; 5V is terminal with manual Peltier restart required.
- Preserved the pre-mutation cooling snapshots so Fan/Peltier/Fan-speed transitions remain realtime.

## STATIC AUDIT
- 4784 lines.
- Firmware version/file alignment: V5.3 / JEXFYZ-V5.3.ino.
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
