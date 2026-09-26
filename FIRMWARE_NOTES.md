# JE X FYZ FIRMWARE — COMPLETE ENGINEERING MEMORY

## 1. SOURCE AUTHORITY AND CURRENT STATE

- Authoritative firmware source: `firmware/JEXFYZ.ino`.
- Current source firmware version: V4.1 (official Espressif/Arduino-ESP32 OTA refactor + Core 3.3.12 baseline; published by successful dedicated Firmware Build Run #25 as the online OTA test target).
- Protocol version: `P1`.
- BLE device name: `JE X FYZ`.
- Target hardware: ESP32-C3 Super Mini / ESP32-C3 Dev Module class.
- Firmware source is intentionally comment-free as of the source cleanup recorded below. All design, safety, timing, hardware, protocol, OTA, persistence, and implementation explanations previously embedded as C/C++ comments are documented here instead.
- Version policy: every firmware change must increment the major.minor firmware version. Use the project sequence style such as V1.0, V1.1 ... V1.9, V2.0; do not use V1.10 or a patch suffix.
