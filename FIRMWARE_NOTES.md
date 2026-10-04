# JE X FYZ — CURRENT FIRMWARE NOTES

## ACTIVE
- Version: V4.4
- Source: firmware/JEXFYZ-V4.4.ino
- Blob: 18f74d5c87b85886b6d3d44fddd4938f4db7019c
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## OTA CONTRACT
Local OTA:
- Golden/Protected.
- User-confirmed working on V4.3.
- Do not change for unrelated Online OTA issues.

Online OTA:
- V3.2-style bounded Wi-Fi retry path.
- No yellow download-progress layer.
- Wi-Fi success BLUE.
- GitHub connection GREEN.
- Download complete BLUE.
- Flash success GREEN then restart.
- Failure RED then recovery.
- Any valid different version is eligible; equal version is Up to date.
- Download processing remains cooperative.

## V4.4 CHANGE
V4.3 only stopped BLE advertising during Online OTA and did not explicitly close an active GATT connection.

V4.4 adds:
bleServer->disconnect(bleServer->getConnId())

This is executed before Wi-Fi takes the single ESP32-C3 radio.

## RUNTIME STATUS
- V4.3 Local OTA: PASS — user confirmed.
- V4.3 Online OTA: PASS — user confirmed.
- V4.4 GATT disconnect behavior: pending physical verification.

## STATIC AUDIT
- 5223 lines
- balanced braces/parentheses/brackets
- executable delay() = 0
- timing while() = 0
- yellow 0xFFFF00 = 0
- stale Online OTA progress refs = 0
- explicit GATT disconnect call = 1

## NEXT VALIDATION
Compile → BIN → flash → Online OTA → confirm BLE disconnect + telemetry stop → confirm restart/reconnect/sync → verify Local OTA.
