# JE X FYZ — CURRENT FIRMWARE ANALYSIS

## SOURCE
- Active: firmware/JEXFYZ-V4.5.ino
- Version: V4.5
- Blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## ARCHITECTURE
- ESP32-C3 single-radio model: Wi-Fi and BLE ownership are mutually exclusive.
- OTA is processed before normal application work.
- Local OTA uses boot SoftAP and remains protected.
- Online OTA uses Firebase metadata and the approved GitHub raw BIN endpoint.
- Firmware streams the image into the inactive OTA partition.
- Timing is cooperative.

## ONLINE OTA
1. Capture active GATT state/connection ID.
2. Close the active GATT session when present.
3. Clear BLE session/controller state.
4. Stop advertising.
5. Transfer radio ownership to Wi-Fi.
6. Use the V3.2-style bounded Wi-Fi retry path.
7. Download and finalize.
8. Restart and recover BLE.

## APP SYNC CONTRACT
- App marks the Online OTA disconnect as expected.
- Recovery scans/connects using the known cooler identity without requiring passive Auto Connect to be enabled.
- Final P1 sync restores the dashboard and surfaces the one-shot OTA result.

## SAFETY / CONTROL
- Hotside NTC is the universal thermal safety input.
- Rapid Hotside-rise latching is only armed while Peltier is ON.
- Fan PWM 25 kHz, 8-bit, 50–100%.
- Peltier PWM 20 kHz, 8-bit.
- Selector deadtime 200 ms.
- Voltage guard 1 s.
- Adaptive Ceiling remains firmware-owned and is exposed over telemetry.

## STATIC RESULT
- 4648 lines.
- Firmware source/file alignment: V4.5.
- One active versioned .ino.
- executable delay() = 0.
- timing while() = 0.
- Yellow 0xFFFF00 = 0.
- Stale Online OTA progress refs = 0.
- Explicit BLE GATT disconnect = 1.
- Dead adaptive-resume state = 0.
- Legacy newer-version comparator = 0.

## VALIDATION BOUNDARY
V4.4 physical OTA success is user-confirmed. V4.5 source/static audit is complete. V4.5 compile/BIN/flash/physical validation remains pending.
