# JE X FYZ — CURRENT FIRMWARE ANALYSIS

## SOURCE
- Active: firmware/JEXFYZ-V4.8.ino
- Version: V4.8
- Blob: d47b62edbf275032780ef05d6ac3be1df06e350b
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## CURRENT PHASE
> **V4.8 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

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
- Double tap RGB and long-press Adaptive-OFF remain unchanged.

## SAFETY
- Hotside NTC is the universal thermal safety input.
- Normal Hotside temperature-limit protection remains active with the V4.8 10-second step-down dwell.
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
- 4688 lines.
- Firmware source/file alignment: V4.8 / JEXFYZ-V4.8.ino.
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
- HOTSIDE sequence: 12V hold → 9V → 5V.
- 5V terminal safety exits Adaptive and requires manual Peltier restart.
- Manual-mode Hotside protection preserves the selected rail.

## VALIDATION BOUNDARY
- [VERIFIED] Source/static audit.
- [UNVERIFIED] Arduino compile.
- [UNVERIFIED] BIN generation.
- [UNVERIFIED] ESP32-C3 flash.
- [USER-CONFIRMED] V4.6 physical hardware behavior passed before the V4.8 telemetry fix.
- [UNVERIFIED] V4.8 physical hardware regression after the telemetry fix.
- [UNVERIFIED] Safety runtime.
- [UNVERIFIED] Local OTA V4.6.
- [UNVERIFIED] Online OTA/BLE recovery V4.6.
- [VERIFIED] V4.8 source/static audit for the realtime telemetry fix.
- [UNVERIFIED] V4.8 compile/BIN/flash/OTA and App integration after the fix.
- [NOT RELEASED] Release Gate is incomplete.
