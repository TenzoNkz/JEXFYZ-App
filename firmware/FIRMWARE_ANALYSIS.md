# JE X FYZ — CURRENT FIRMWARE ANALYSIS

## SOURCE
- Active: firmware/JEXFYZ-V5.7.ino
- Version: V5.7
- Blob: 652e54afdd9c7c347cd82072f573f1729c4b46de
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## CURRENT PHASE
> **V5.7 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## ARCHITECTURE
- ESP32-C3 single-radio model: Wi-Fi and BLE ownership are mutually exclusive.
- OTA is processed before normal application work.
- Local OTA uses boot SoftAP and remains protected.
- Online OTA uses Firebase metadata and the approved GitHub raw BIN endpoint.
- Firmware streams the image into the inactive OTA partition.
- Timing is cooperative.

## HARDWARE CONTROL
- GPIO: NTC 0, Touch 1, 12V 3, 9V 4, Peltier 5, Fan 6, WS2812 7.
- Single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: 5-second soft-start, then 100%.
- Adaptive upward voltage changes: 5-second cooperative dwell after every completed increase in both profiles; downward changes remain immediate.
- Double tap RGB and long-press Adaptive-OFF remain unchanged.

## V5.7 TTP223 TOUCH ACCURACY QC FIX — 2026-10-06
- TTP223 input processing is layered: raw GPIO → 30 ms qualification → stable edge → gesture engine.
- Startup touch input is ignored for the first 1,000 ms; if Q is already HIGH after startup grace, that held state is blocked until a qualified release.
- Tap validity uses raw HIGH duration 60–500 ms, avoiding double-counting the 30 ms input qualification time.
- Double-tap window is 800 ms from the first valid release. A second press that begins before the deadline gets release grace beyond the deadline; completed double tap resolves at the decision boundary, preserving the prior 3+ tap cancellation behavior.
- Long press remains 5,000 ms and is evaluated continuously from the qualified press.
- No blocking delay or timing wait was introduced.

## V5.6 NTC ADC FILTERING QC FIX — 2026-10-06
- Single-sample Hotside ADC capture was replaced with a bounded 16-sample calibrated burst.
- Samples are insertion-sorted and reduced with a 50% trimmed mean: discard 4 lowest + 4 highest, average the middle 8.
- NTC conversion remains the existing 10K / 25°C / Beta 3950 model and the existing 3.3 V divider-reference assumption.
- Sensor fault gates remain applied after the filtered ADC millivolt result; abnormal results are invalidated rather than clamped into a temperature.
- No temperature-history filter was added, avoiding deliberate thermal lag in the safety path.

## V5.5 PELTIER SAFETY REARM LED FEEDBACK — 2026-10-06
- Normal Peltier ON/OFF no longer calls a Peltier LED command-result indicator.
- manualPeltierSafetyLatch remains set after cooldown until an explicit Peltier ON attempt succeeds; this preserves the distinction between a safety re-arm attempt and normal ON/OFF.
- While the latch is active, every blocked Peltier ON attempt produces a non-blocking 1-second red blink.
- When Hotside is <= hotLimit - 2°C, a successful Peltier ON attempt produces a non-blocking 1-second green blink and clears the latch.
- The Hotside 10-second dwell indicator keeps LED priority, so its 9-second red + final 1-second green sequence is not disrupted.
- No second safety latch or alternate thermal threshold was introduced.
- Adaptive start is explicitly blocked while manualPeltierSafetyLatch is active, so the safety re-arm cannot be bypassed through Adaptive mode.

## V5.4 HOTSIDE DWELL FAN + LED QC FIX — 2026-10-06
- Adaptive HOTSIDE safety keeps Fan ON at 100% for the complete 10-second thermal dwell.
- Completed HOTSTEP transitions keep Fan ON at 100% while thermal protection remains active.
- Hotside dwell LED uses 9 seconds red blink plus the final 1 second green blink.
- The selector step timing and 10-second dwell duration are unchanged.
- Firmware version/file alignment is now V5.4 / JEXFYZ-V5.4.ino.

## V5.3 ADAPTIVE VOLTAGE RISE DWELL
- HOTSIDE and HOTSIDE_BATTERY both use the same 5-second post-transition dwell for every upward voltage step.
- Adaptive startup from safe 5V also waits 5 seconds before the first upward step.
- The timer remains cooperative and does not use blocking delay() or while() timing.

## V5.2 TOUCH ACK CLEANUP
- Successful Touch cooling OFF uses an explicit OFF acknowledgement.

## V5.2 PELTIER SAFETY REARM FEEDBACK
- Manual and 5V Adaptive-terminal Peltier restart remains locked until Hotside <= hotLimit - 2°C.
- Hardware Touch restart uses the same re-arm hysteresis and cannot bypass the latch.
- Failed Peltier ON: red blink 1 second. Successful Peltier ON: green blink 1 second.

## V5.1 SAFETY REARM FEEDBACK
- Peltier ON safety rejection: 1-second red blink.
- Peltier ON success: 1-second green blink.
- Re-arm threshold: Hotside <= hotLimit - 2°C.
- Touch and App Peltier start paths use the same safety latch semantics.

## SAFETY
- Hotside NTC is the universal thermal safety input.
- Normal Hotside temperature-limit protection remains active with the 10-second step-down dwell.
- Rapid Hotside-rise protection was removed; no dedicated slope/event/history state remains.
- NTC invalid state still forces Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.

## OTA
1. Capture active GATT state/connection ID.
2. Close the active GATT session when present.
3. Clear BLE session/controller state.
4. Stop advertising.
5. Transfer radio ownership to Wi-Fi.
6. Use the V3.2-style bounded Wi-Fi retry path.
7. Download and finalize.
8. Restart and recover BLE.

## STATIC RESULT
- 4784 lines.
- Firmware source/file alignment: V5.4 / JEXFYZ-V5.4.ino.
- One active versioned .ino.
- executable delay() = 0 (comments excluded).
- timing while() = 0.
- RAPID_HOTSIDE_RISE = 0.
- rapid-rise state/history identifiers = 0.
- Yellow 0xFFFF00 = 0.
- Stale Online OTA progress refs = 0.
- Explicit BLE GATT disconnect = 1.
- Hard limit: 60000 ms.
- Peltier soft-start: 5000 ms.
- HOTSIDE safety dwell: 10000 ms.
- HOTSIDE sequence: 12V hold → 9V → 5V, with 10-second LED timing at each stage.
- 5V terminal safety exits Adaptive and requires manual Peltier restart.
- Manual-mode Hotside protection preserves the selected rail.

## VALIDATION BOUNDARY
- [VERIFIED] Source/static audit.
- [UNVERIFIED] Arduino compile.
- [UNVERIFIED] BIN generation.
- [UNVERIFIED] ESP32-C3 flash.
- [USER-CONFIRMED] V4.6 physical hardware behavior passed before the V4.9 telemetry fix.
- [UNVERIFIED] V4.9 physical hardware regression after the telemetry fix.
- [UNVERIFIED] Safety runtime.
- [UNVERIFIED] Local OTA V4.6.
- [UNVERIFIED] Online OTA/BLE recovery V4.6.
- [VERIFIED] V4.9 source/static audit for the realtime telemetry fix.
- [UNVERIFIED] V5.4 compile/BIN/flash/OTA and App integration after this revision.
- [NOT RELEASED] Release Gate is incomplete.
