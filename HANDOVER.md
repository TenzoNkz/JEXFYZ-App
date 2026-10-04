# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.4
- Active source: firmware/JEXFYZ-V4.4.ino
- App: 1.0.0+3
- Latest App Build: #50
- V4.3 Local OTA: PASS — user confirmed
- V4.3 Online OTA: PASS — user confirmed
- V4.4 new BLE GATT disconnect: physical test pending

## CURRENT OBJECTIVE
Verify that clicking Update Firmware causes the active BLE GATT session to disconnect before Wi-Fi OTA begins.

Expected:
Update Firmware → BLE disconnect → App telemetry disappears → Online OTA → restart → BLE reconnect → sync → dashboard resumes.

## FROZEN
- Local OTA
- BLE UUID/P1 contract
- App package identity
- Manual App Build workflow
- V3.2-style Online OTA transport/retry/result-indicator path
- cooperative timing rules
- Firmware version/file alignment

## VALIDATION
Compile V4.4 with ArduinoDroid/Core 3.3.7, generate BIN, flash, test Online OTA, verify BLE disconnect and telemetry stop, then verify restart/reconnect/sync and Local OTA.

## BUILD
No App source/config/workflow change was made for V4.4. Build #50 remains the App baseline.
