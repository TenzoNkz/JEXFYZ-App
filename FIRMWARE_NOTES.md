# JE X FYZ — CURRENT FIRMWARE NOTES

## ACTIVE
- Version: V4.7
- Source: firmware/JEXFYZ-V4.7.ino
- Blob: d47b62edbf275032780ef05d6ac3be1df06e350b
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
- Fan remains 25 kHz, 8-bit, 50–100% for App-controlled operation.
- Voltage selector deadtime 200 ms; voltage guard 1 s.
- Adaptive behavior remains unchanged.
- RGB/touch double-tap behavior remains unchanged.

## SAFETY CONTRACT
- Hotside NTC remains the universal thermal safety input and is sampled every 1 s.
- Hotside limit remains 40–50°C, default 45°C.
- NTC fault remains Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- Rapid Hotside-rise slope protection is removed completely.
- No RAPID_HOTSIDE_RISE safety event is emitted.
- Normal Hotside temperature-limit protection remains active.

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

## V4.7 CHANGE
- Promoted V4.6 → V4.7 for the demonstrated realtime telemetry QC defect.
- Implemented hardware touch voltage bounce sequence.
- Hardware cooling ON forces Fan to 100%.
- Preserved the existing Peltier 5-second OFF→ON soft-start.
- Removed the rapid Hotside-rise slope/event protection only.
- Preserved normal Hotside temperature-limit safety and all unrelated runtime/OTA/BLE/App contracts.
- Added pre-mutation cooling snapshots so Fan/Peltier/Fan-speed transitions are emitted when logical state changes occur before output application.

## STATIC AUDIT
- 4667 lines.
- Firmware version/file alignment: V4.7 / JEXFYZ-V4.7.ino.
- Only one active versioned .ino exists under firmware/.
- executable delay() = 0 (comments excluded).
- timing while() = 0.
- RAPID_HOTSIDE_RISE = 0.
- rapid-rise state/history identifiers = 0.
- GPIO Peltier = 5; Fan = 6.
- BOOT_AP_HARD_LIMIT_MS = 60000.
- PELTIER_SOFT_START_MS = 5000.

## QC GATES
- Compile V4.7.
- Generate BIN.
- Flash/OTA ESP32-C3.
- Hardware-only control QC.
- Safety QC.
- Local OTA Golden Path.
- Online OTA + BLE recovery.
- App ↔ Firmware integration.

## VALIDATION BOUNDARY
- V4.4 OTA: user-confirmed PASS for all OTA paths before V4.5 promotion.
- V4.6 source/static audit: PASS.
- V4.7 compile/BIN/flash/physical validation: pending.
