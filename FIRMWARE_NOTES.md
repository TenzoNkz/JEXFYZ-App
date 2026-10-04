# JE X FYZ — CURRENT FIRMWARE NOTES

## ACTIVE
- Version: V4.5
- Source: firmware/JEXFYZ-V4.5.ino
- Blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## OTA CONTRACT
Local OTA:
- Golden/Protected.
- V4.4 OTA was user-confirmed successful before the V4.5 source promotion.
- Do not modify Local OTA for unrelated Online OTA work.

Online OTA:
- V3.2-style bounded Wi-Fi retry path.
- No yellow progress layer.
- Wi-Fi success BLUE.
- GitHub connection GREEN.
- Download complete BLUE.
- Flash success GREEN then restart.
- Failure RED then recovery.
- Any valid different version is eligible; equal version is Up to date.
- Download processing remains cooperative.

## V4.5 CHANGE
- Fixes GATT disconnect ordering by capturing the active connection ID before clearing the logical BLE-connected flag, then calling bleServer->disconnect(activeConnId).
- Emits OTA_UP_TO_DATE immediately as a one-shot LAST_OTA_RESULT event.
- Gates rapid Hotside-rise protection on Peltier being ON to avoid false thermal latching while Peltier is already OFF.
- Removes dead adaptive-resume state, unused legacy version comparison, unused timing constants/include, and generated [DOC-CONTRACT] comment noise.
- Keeps BLE/Wi-Fi radio ownership mutually exclusive.

## STATIC AUDIT
- 4648 lines.
- Firmware version/file alignment: V4.5 / JEXFYZ-V4.5.ino.
- Only one active versioned .ino exists under firmware/.
- executable delay() = 0.
- timing while() = 0.
- yellow 0xFFFF00 = 0.
- stale Online OTA progress refs = 0.
- explicit BLE GATT disconnect = 1.
- active GATT state is captured before bleClientConnected is cleared.

## VALIDATION BOUNDARY
- V4.4 OTA: user-confirmed PASS for all OTA paths.
- V4.5 source/static audit: PASS.
- V4.5 compile/BIN/flash/physical validation: pending.
