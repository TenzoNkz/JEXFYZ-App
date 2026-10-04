# JE X FYZ — CURRENT FIRMWARE ANALYSIS

## SOURCE
- Active: firmware/JEXFYZ-V4.4.ino
- Version: V4.4
- Blob: acbd376b4b5a1f536e83c35b24600e85462de579
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

## ARCHITECTURE
- ESP32-C3 single-radio model: Wi-Fi and BLE ownership are mutually exclusive.
- OTA is processed before normal application work.
- Local OTA uses boot SoftAP and is protected.
- Online OTA uses Firebase metadata and the approved GitHub raw BIN endpoint.
- Firmware is streamed into the inactive OTA partition.
- Timing is cooperative.

## ONLINE OTA V4.4
1. Clear BLE queues/session flags.
2. If a client is actively connected, close its GATT connection with:
   bleServer->disconnect(bleServer->getConnId())
3. Stop advertising.
4. Transfer radio ownership to Wi-Fi.
5. Use the V3.2-style bounded Wi-Fi retry path.
6. Download and finalize.
7. Restart and recover BLE.

The purpose of step 2 is to make Android observe a real BLE disconnect so live App telemetry stops before Wi-Fi OTA.

## INDICATORS
- Start OFF
- Wi-Fi connected BLUE
- GitHub connected GREEN
- Download complete BLUE
- Flash success GREEN then restart
- Failure RED then recovery
- Yellow progress milestones removed

## HARDWARE
| Function | GPIO |
| Hotside NTC | 0 |
| Touch | 1 |
| 12V selector | 3 |
| 9V selector | 4 |
| Peltier | 5 |
| Fan | 6 |
| WS2812 | 7 |

## SAFETY
- Hotside NTC is the universal thermal safety input.
- Fan PWM 25 kHz, 8-bit, 50–100%.
- Peltier PWM 20 kHz, 8-bit.
- Peltier OFF→ON starts the 5 s soft-start.
- Voltage changes do not restart the soft-start.
- Selector deadtime 200 ms.
- Voltage guard 1 s.

## STATIC RESULT
- 5223 lines.
- Braces, parentheses, brackets balanced.
- Executable delay() = 0.
- Timing while() = 0.
- Yellow 0xFFFF00 = 0.
- Stale Online OTA progress refs = 0.
- Explicit GATT disconnect call = 1.

## VALIDATION BOUNDARY
V4.3 physical OTA success is user-confirmed. V4.4 physical validation is pending.