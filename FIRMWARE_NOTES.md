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

## ACTIVE
- Version: V5.9
- Source: firmware/JEXFYZ-V5.9.ino
- Blob: 11879cda3e96411c16cc372a176dcef6b71ebe94
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7


## CURRENT PHASE
- CODE COMPLETE
- DEVELOPMENT + QC / PRE-RELEASE
- NOT RELEASED
- Functional source is frozen unless QC demonstrates a real defect.


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