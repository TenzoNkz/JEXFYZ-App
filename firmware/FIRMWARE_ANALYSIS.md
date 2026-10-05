# JE X FYZ — CURRENT FIRMWARE ANALYSIS

## SOURCE
- Active: firmware/JEXFYZ-V4.6.ino
- Version: V4.6
- Blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## ARCHITECTURE
- ESP32-C3 single-radio model: Wi-Fi and BLE ownership are mutually exclusive.
- OTA is processed before normal application work.
- Local OTA uses boot SoftAP and remains protected.
- Online OTA uses Firebase metadata and the approved GitHub raw BIN endpoint.
- Firmware streams the image into the inactive OTA partition.
- Timing is cooperative.

## HARDWARE CONTROL
- GPIO mapping: NTC 0, Touch 1, 12V 3, 9V 4, Peltier 5, Fan 6, WS2812 7.
- Single tap sequence: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: existing 5-second soft-start remains active.
- Double tap RGB and long-press Adaptive-OFF behavior remain unchanged.

## SAFETY
- Hotside NTC is the universal thermal safety input.
- Normal Hotside temperature-limit protection remains active.
- Rapid Hotside-rise protection was removed; no dedicated slope/event state remains.
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
- 4628 lines.
- Firmware source/file alignment: V4.6.
- One active versioned .ino.
- executable delay() = 0 (comments excluded).
- timing while() = 0.
- RAPID_HOTSIDE_RISE = 0.
- rapid-rise state/history identifiers = 0.
- Yellow 0xFFFF00 = 0.
- Stale Online OTA progress refs = 0.
- Explicit BLE GATT disconnect = 1.
- BOOT_AP_HARD_LIMIT_MS = 60000.
- PELTIER_SOFT_START_MS = 5000.

## VALIDATION BOUNDARY
V4.4 physical OTA success is user-confirmed. V4.6 source/static audit is complete. V4.6 compile/BIN/flash/physical validation remains pending.
