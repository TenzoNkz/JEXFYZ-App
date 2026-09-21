# JE X FYZ — FIRMWARE MASTER CONTEXT

> **READ RULE:** Read this document before changing firmware. Re-read the relevant sections after every hardware, protocol, safety, timing, BLE, OTA, or version change.
>
> **CHANGE RULE:** This is a living firmware specification. The newest explicit user instruction and newest firmware source override older notes. Do not silently restore superseded behavior.
>
> **SOURCE-OF-TRUTH ORDER:** newest user instruction → newest user-provided firmware source / firmware repository → this firmware context → older discussion.

---

## 0. FIRMWARE IDENTITY

- Project: **JE X FYZ**
- Firmware repository: `https://github.com/TenzoNkz/JEXFYZ-Firmware`
- MCU: **ESP32-C3 Super Mini**
- Current inspected source: `JEXFYZ_V3.2_BLE_FIXED_ARDUINODROID.ino`
- Code firmware version: `V3.2`
- BLE device name: `JE X FYZ`
- Protocol version: `P1`
- App counterpart: `https://github.com/TenzoNkz/JEXFYZ-App`

**Version rule:** Inspect the newest firmware source/repository before version-specific changes.

---

## 1. FIRMWARE — MASTER REFERENCE

> **SCOPE:** This file is the living context for the **ESP32-C3 firmware only**. App UI, Flutter architecture, Android build workflow, and presentation details belong in `JE_X_FYZ_APP_MASTER_CONTEXT.md` inside the app repository.
>
> **SEPARATION RULE:** Keep firmware implementation, hardware ownership, safety algorithms, timing, BLE server protocol, persistence, and OTA execution here. Do not copy the app UI specification into this file.

### 1.1 Current firmware identity

- Target MCU: **ESP32-C3 Super Mini**.
- Current inspected firmware source: `JEXFYZ_V3.2_BLE_FIXED_ARDUINODROID.ino`.
- Code firmware version: `V3.2`.
- BLE device name: `JE X FYZ`.
- Protocol version: `P1`.
- Engineering reference: Horizon Cooler is used only as an engineering/reference baseline; JE X FYZ owns its own hardware, safety, OTA, and protocol behavior.
- Firmware runtime is designed around `millis()`/state machines; no normal runtime `delay()` is intended.
- `yield()` is reserved for bounded OTA-specific operations.

### 1.2 Firmware hardware map

| GPIO | Hardware | Firmware role |
|---|---|---|
| GPIO0 | NTC 10K | Hotside temperature ADC |
| GPIO1 | TTP223 touch | Manual 5V → 9V → 12V voltage cycling |
| GPIO3 | 12V optocoupler | 12V voltage selector |
| GPIO4 | 9V optocoupler | 9V voltage selector |
| GPIO5 | Peltier MOSFET | Peltier PWM/output |
| GPIO6 | Fan MOSFET | Fan PWM/output |
| GPIO7 | WS2812B, 8 LEDs | User RGB + OTA/safety indication |

**Critical correction:** GPIO5 = **Peltier** and GPIO6 = **Fan**. This mapping previously became swapped and must not be silently reverted.

### 1.3 NTC / temperature measurement

- Sensor topology in the inspected source: **3.3V → NTC 10K → GPIO0 → 10K → GND**.
- NTC nominal resistance: 10KΩ.
- NTC nominal temperature point: 25°C.
- Beta value: 3950.
- Firmware performs exactly one ADC voltage read approximately every **1 second**.
- Fault thresholds in the inspected firmware: ≤50 mV or ≥3250 mV = invalid NTC.
- Invalid NTC is a safety fault: Fan is forced ON at 100%, Peltier OFF, Adaptive OFF, and voltage is driven/locked toward 5V safety state.
- Hotside limit range: **40°C–50°C**.
- Current firmware default hotside limit: **45°C**.

### 1.4 Cooling outputs and safety ownership

- Firmware is the final source of truth for Fan, Peltier, voltage, Adaptive, and safety state.
- Fan/Peltier interlock is global: Peltier cannot remain ON without Fan availability.
- Normal reset state: 5V, Fan OFF, Peltier OFF, Adaptive OFF; NTC fault immediately changes this to safe airflow behavior.
- Critical hotside protection: Fan ON at 100%, Peltier OFF.
- In Adaptive hotside protection, Peltier stays OFF through a full **10-second** cooling window before any permitted resume/step-down behavior.
- If the hotside is still unsafe after the Adaptive cooldown window, Adaptive discards one voltage level (12V→9V or 9V→5V). At 5V with continued protection, Adaptive turns OFF.
- Normal manual voltage changes do **not** intentionally toggle Fan/Peltier state.
- Peltier uses 20 kHz, 8-bit PWM with a non-blocking **5-second** 0→100% soft-start ramp in the inspected firmware.
- Fan uses 25 kHz, 8-bit PWM.
- Firmware fan speed range: **50%–100%**, step **10%**.

### 1.5 Voltage switching timing

- Supported voltages: **5V, 9V, 12V**.
- Manual voltage guard: **1 second** from the accepted manual request.
- Optocoupler break-before-make dead-time: **200 ms**.
- The 1-second manual guard and the 200 ms dead-time are part of firmware safety timing; the app may be asynchronous, but it must not bypass firmware protection.
- Adaptive ON/OFF returns the voltage path to **5V** before Adaptive proceeds according to firmware state logic.
- Adaptive battery upward transition delay: **5 seconds**.

### 1.6 Battery temperature / Adaptive coordination

- App sends phone/battery temperature using `PHONE:BT=<value>` as a **1 Hz heartbeat**.
- Firmware battery validity expires after **5 seconds** without a valid update.
- Battery temperature itself may update every second, but voltage requests are generated only when the battery zone changes.
- Battery zones are derived from the configurable `BATT5` and `BATT12` thresholds.
- Firmware defaults in the inspected source: `BATT5 = 25`, `BATT12 = 35`.
- Battery settings are rejected while Adaptive is active.
- Adaptive battery behavior is firmware-controlled and may request 5V/9V/12V based on battery zone, while hotside protection has higher safety priority.

### 1.7 BLE UUID / session model

- BLE service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`.
- RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`.
- TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- BLE session uses a synchronization gate:
  1. App connects.
  2. App requests `SYNC`.
  3. Firmware returns a full state snapshot.
  4. App sends `SYNC_READY`.
  5. Firmware opens the state-changing command gate and sends a fresh sync.
- This prevents stale app state from being replayed immediately after BLE connection.
- BLE connect/disconnect itself must not change voltage, Fan, Peltier, Adaptive, RGB, or PWM state.
- Firmware telemetry/state remains authoritative over optimistic app UI state.

### 1.8 BLE telemetry and synchronization

Full sync includes at minimum:

`STATE_SEQ`, `VERSION`, `PROTOCOL`, `BLE_SESSION`, `VOLTAGE`, `FAN`, `PELTIER`, `HOT`, `BATTERY`, `BATTERY_VALID`, `ADAPTIVE`, `ADAPTIVE_CEILING`, `RGB`, `MODE`, `BRIGHTNESS`, `RGB_COLOR`, `COLOR_5V`, `COLOR_9V`, `COLOR_12V`, `FAN_SPEED`, `SAFETY`, `SAFETY_REASON`, `OTA_STATE`, `LAST_OTA_RESULT`, `RESET_REASON`, `TEMP_HOT_LIMIT`, `BATT_5`, `BATT_12`, and `NTC_MV`.

Runtime telemetry rule:

- `HOT` is deliberately transmitted every second.
- Battery temperature is supplied by the app every second.
- Other state values are delta-driven: send when they change or when a full sync is requested.
- BLE TX uses a bounded queue; UI must not reintroduce a blocking “PROCESSING” overlay merely because a command is in flight.

### 1.9 Firmware command groups currently defined

The inspected firmware accepts these main command families:

- Session: `SYNC`, `SYNC_READY`.
- Online OTA setup: `OTAENTER`, `SSID:<...>`, `PASS:<...>`, `URL:<https://...>`, `VERSION:<...>`, `CLOUDOTA`.
- RGB: `RGB:ON`, `RGB:OFF`, `MODE:0..7`, `BRIGHTNESS:0..100`, `COLOR:#RRGGBB`.
- Voltage LED colors: `V5COLOR:#RRGGBB`, `V9COLOR:#RRGGBB`, `V12COLOR:#RRGGBB`.
- Temperature/battery thresholds: `HOTLIMIT:40..50`, `BATT5:...`, `BATT12:...`.
- Cooling: `VOLTAGE:5V|9V|12V`, `FAN:ON|OFF`, `PELTIER:ON|OFF`, `ADAPTIVE:ON|OFF`, `FANSPEED:50..100`.
- Settings reset: `RESET:<group>`.
- Phone battery heartbeat: `PHONE:BT=<temperature>`.

The app and firmware command vocabulary must remain aligned. Do not resurrect legacy command formats such as `CFG:`, `ADAPT:`, `RGBTOGGLE`, `RGBPREV`, `RGBNEXT`, `BR:`, or `AIM:` unless the user explicitly redesigns the protocol.

### 1.10 Command anti-spam / acknowledgements

- Firmware rejects duplicate user control commands arriving within **250 ms** as a backstop.
- App-side command coalescing/latest-state synchronization may reduce command spam further.
- Commands produce acknowledgements and/or deltas; a command being sent does not itself prove that the final physical state remained accepted.
- Safety-generated state changes are also mirrored over BLE so the app reflects real device state.

### 1.11 RGB / LED persistence

- RGB state/settings are persisted.
- Persisted RGB group includes RGB ON/OFF, mode, brightness, main RGB color, and voltage colors.
- Voltage default colors remain:
  - 5V → `#FF0000`
  - 9V → `#00FF00`
  - 12V → `#0000FF`
- RGB modes are indexed 0–7 in firmware.
- Temperature settings are persisted.
- Runtime Fan/Peltier/Voltage/Adaptive/PWM state is **not** persisted as a normal runtime state.
- Preferences are debounced and written about **10 seconds** after the last setting change.

### 1.12 OTA / radio ownership

The project uses a single-radio/antenna constraint, so OTA and BLE ownership must be serialized.

**Boot / local OTA:**

- Boot starts a silent Wi-Fi AP local-OTA window for about **10 seconds**.
- Normal cooler functions can remain active during the initial silent window until a Wi-Fi client actually connects.
- Once a Wi-Fi client connects, outputs are forced OFF and Wi-Fi/OTA takes exclusive ownership; BLE is released.
- If no client is present when the boot OTA window expires, Wi-Fi shuts down and BLE becomes the normal radio.

**Online OTA:**

- App supplies SSID, password, HTTPS firmware URL, and firmware version metadata.
- HTTPS is required.
- Online OTA uses blue LED indication during Wi-Fi/download, green for successful update, red for failure.
- OTA failure should return control to BLE without requiring an ESP32 restart when the current firmware path supports it.
- OTA success restarts the device after its success indication according to firmware state.

Never put real Wi-Fi passwords, API secrets, keystore secrets, or other credentials into this context file.

### 1.13 Firmware ↔ App invariants

These are cross-layer rules and therefore belong in the **single app master context**:

1. App UI may be optimistic for responsiveness, but firmware state is authoritative.
2. App and firmware must use the same BLE UUIDs and command vocabulary.
3. BLE session synchronization must complete before the app sends state-changing commands.
4. Safety decisions belong to firmware; UI must display the resulting state/reason.
5. The app must not assume that a sent command equals a permanent physical state.
6. Hotside telemetry remains 1 Hz; battery heartbeat remains 1 Hz.
7. Avoid unnecessary BLE spam; send settings/state deltas when changed.
8. Do not reintroduce blocking `PROCESSING` overlays.
9. Any firmware change that changes a command, telemetry key, safety rule, pin, timing, or version must also update this master context and any affected app code/tests.
10. Any app change that depends on firmware behavior must be validated against the latest firmware source before being treated as complete.

---

## 2. FIRMWARE ENGINEERING / SAFETY RULES

- Prefer non-blocking `millis()`-based state machines.
- Do not introduce normal runtime `delay()` calls; bounded OTA-specific blocking operations are the exception.
- Firmware owns physical safety and must enforce it independently of the app.
- Preserve voltage break-before-make timing and manual voltage guard behavior.
- Preserve NTC fault handling and cooling interlocks.
- Preserve BLE session protection against stale command replay.
- Preserve single-radio ownership between Wi-Fi OTA and BLE.
- Avoid unnecessary command/telemetry spam.

---

## 3. APP / FIRMWARE INTEGRATION BOUNDARY

The app context is maintained separately at:

```text
JEXFYZ-App/JE_X_FYZ_APP_MASTER_CONTEXT.md
```

Shared integration points:
- Service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`
- RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`
- TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`
- Firmware telemetry/state is authoritative.
- App must respect the current session sync gate.
- Firmware command vocabulary is authoritative; do not resurrect legacy commands.

---

## 4. FIRMWARE FILE DELIVERY RULE

Whenever firmware changes:
- provide the complete replacement `.ino` file
- provide the exact firmware repository-relative path
- provide a ZIP preserving that path according to the project workflow
- update this firmware context with confirmed changes
- never include secrets in the context or ZIP

---

## 5. FIRMWARE CHANGE LOG

### 2026-09-21
- Documentation split requested so firmware and app notes are separate and cannot be mixed.
- Firmware context now contains only firmware/hardware/protocol/safety/OTA information plus the minimum BLE integration boundary.
- Final pin correction remains GPIO5 = Peltier and GPIO6 = Fan.

### Future rule
For firmware changes, update this file only with firmware-side state and integration facts. For Flutter UI, Android, CI, or presentation changes, update the app context instead.
