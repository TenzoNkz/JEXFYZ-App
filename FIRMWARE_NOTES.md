# JE X FYZ FIRMWARE — COMPLETE ENGINEERING MEMORY

## 1. SOURCE AUTHORITY AND CURRENT STATE

- Authoritative firmware source: `firmware/JEXFYZ.ino`.
- Current source firmware version: V4.2 (local OTA hardening after the physical V4.0 local OTA test failed from the user-installed V3.9 device; Core 3.3.12 baseline; Firmware Build Run #26 verified successful).
- Protocol version: `P1`.
- BLE device name: `JE X FYZ`.
- Target hardware: ESP32-C3 Super Mini / ESP32-C3 Dev Module class.
- Firmware source is intentionally comment-free as of the source cleanup recorded below. All design, safety, timing, hardware, protocol, OTA, persistence, and implementation explanations previously embedded as C/C++ comments are documented here instead.
- Version policy: every firmware change must increment the major.minor firmware version. Use the project sequence style such as V1.0, V1.1 ... V1.9, V2.0; do not use V1.10 or a patch suffix.

#
## CURRENT EXECUTION CONTROL — AUTHORITATIVE

### Firmware source editing
- Firmware source can be discussed, reviewed, and changed in the Code sub-chat without starting CI.
- Plain `Eksekusi` means apply the agreed repository changes. It does NOT build the firmware `.bin`.
- Editing `firmware/JEXFYZ.ino` does not trigger Firmware Build.

### Firmware build command
- The user explicitly starts firmware compilation with `Eksekusi Firmware`.
- Only that command updates `.github/FIRMWARE_BUILD_TRIGGER`.
- The trigger file starts `.github/workflows/firmware-build.yml`.
- The workflow itself has no `workflow_dispatch` and no source-file trigger.
- Therefore the build is completely separated from ordinary source edits.

### App Build separation
- App compilation belongs to the Action sub-chat and starts only from `.github/APP_BUILD_TRIGGER` after the user says `Build App`.
- Firmware Build is never started by the Action sub-chat.

# 2. VERIFIED MANUAL UPLOAD REFERENCE — ARDUINODROID

The following configuration is the user's proven manual upload configuration and is the primary reference for avoiding board/upload mismatches.

| ArduinoDroid option | Verified value |
|---|---|
| Board | ESP32C3 Dev Module |
| JTAG Adapter | Disabled |
| USB CDC On Boot | Enabled |
| Partition Scheme | No FS 4MB (2MB APP x2) |
| CPU Frequency | 160MHz (WiFi) |
| Flash Mode | DIO |
| Flash Frequency | 80MHz |
| Flash Size | 4MB (32Mb) |
| Upload Speed | 921600 |
| Core Debug Level | None |
| Erase All Flash Before Sketch Upload | Disabled |
| Zigbee Mode | Disabled |

This exact ArduinoDroid configuration has been visually verified by the user and must be kept as the reference target for future manual upload discussions.

### CI / manual core baseline
The GitHub Actions Firmware Build workflow uses `PartitionScheme=no_fs` and is pinned to stable Arduino-ESP32 Core 3.3.12. Manual ArduinoDroid should use the same 3.3.12 core before physical V4.2 flashing.

## 3. BOARD, GPIO, AND ELECTRICAL MAP

| Function | GPIO / configuration |
|---|---|
| NTC 10K | GPIO0, divider input |
| TTP223 touch | GPIO1 |
| 12V selector optocoupler | GPIO3 |
| 9V selector optocoupler | GPIO4 |
| Peltier MOSFET | GPIO5 |
| Fan MOSFET | GPIO6 |
| WS2812B LED strip | GPIO7 |
| LED count | 8 |

NTC divider used by firmware:
- 3.3V -> NTC 10K -> GPIO0 -> fixed 10K resistor -> GND.
- NTC nominal resistance: 10,000 ohms.
- NTC nominal temperature: 25°C.
- Beta constant: 3950.
- ADC resolution: 12 bit.
- ADC attenuation on GPIO0: ADC_11db.

The GPIO5/GPIO6 assignment is important: GPIO5 is PELTIER and GPIO6 is FAN.

## 4. EXTERNAL LIBRARIES AND PLATFORM

The current source includes:
- Arduino core / Arduino.h.
- WiFi.h.
- WebServer.h.
- HTTPUpdate.h.
- Update.h.
- HTTPClient.h.
- WiFiClientSecure.h.
- Preferences.h.
- Adafruit_NeoPixel.h.
- OneButton.h.
- math.h.
- time.h.
- BLEDevice.h.
- BLEServer.h.
- BLEUtils.h.
- BLE2902.h.
- ESP system reset-reason support.
- Espressif error definitions (esp_err.h) where explicit API return checks are required.
- FreeRTOS queue-mutex support.

Pinned/required project libraries:
- OneButton 2.6.1.
- Adafruit NeoPixel 1.12.5.

WS2812FX is no longer used by the firmware. LED effects are implemented by the JE X FYZ custom LED engine on top of Adafruit NeoPixel.

## 5. SYSTEM ARCHITECTURE

The firmware is the authoritative runtime state owner.

Core design properties:
- Runtime is non-blocking and driven by `millis()` state machines.
- No executable `delay()` call exists in the firmware.
- `yield()` is used only where a bounded blocking OTA/network operation still requires scheduler servicing.
- BLE callbacks do not directly mutate cooler runtime state.
- BLE TX notifications are queued and serialized from the main loop.
- BLE RX payloads are bounded before dispatch.
- Safety enforcement is centralized in the firmware.
- Normal voltage changes preserve Fan/Peltier logical state.
- Radio ownership is exclusive: Wi-Fi and BLE are never intentionally active at the same time.

## 6. BOOT AND RADIO OWNERSHIP

### Boot-time local Wi-Fi OTA
At boot:
1. Normal hardware is initialized.
2. Runtime state is forced to a safe normal starting state.
3. The NTC is sampled immediately.
4. The device starts a silent Wi-Fi AP for up to 10 seconds.
5. BLE is deliberately not initialized while this boot AP owns the radio.

Local AP configuration:
- SSID: `JE X FYZ`.
- Password: `0987654321`.
- AP IP: `192.168.4.1`.
- Gateway: `192.168.4.1`.
- Subnet: `255.255.255.0`.
- Boot AP timeout: 10,000 ms.

During the no-client boot AP window:
- Normal cooler runtime continues.
- Normal RGB remains usable.
- No blue OTA blink is shown merely because the AP exists.
- BLE remains OFF.

If a Wi-Fi client connects during the boot AP window:
- All physical cooling outputs are forced OFF.
- Normal RGB output is stopped.
- BLE is shut down/released.
- Wi-Fi remains the exclusive radio while the client/AP OTA session is active.

If no client connects after 10 seconds:
- The AP is stopped.
- Wi-Fi is fully turned OFF.
- Only after Wi-Fi is OFF is BLE initialized and advertising started.

This sequence is critical for the ESP32-C3 single-radio/antenna constraint.

## 7. LOCAL WEB OTA

Local OTA uses the official Arduino-ESP32 Update library path used by Espressif's Web OTA examples.

Web endpoints:
- GET / serves the built-in OTA page.
- POST /update receives the firmware upload.

Upload behavior:
- The page accepts only .bin firmware files.
- The upload request includes the browser file size as the size query parameter when available.
- At UPLOAD_FILE_START, firmware verifies the .bin extension and calls Update.begin(size); when the size is unavailable it falls back to UPDATE_SIZE_UNKNOWN.
- Each upload chunk uses Update.write().
- With a known size, finalization uses Update.end(), letting the official updater enforce completion.
- With an unknown size, finalization uses Update.end(true), matching the official ESP32 Web OTA pattern.
- Update errors are captured through Update.errorString() and persisted in LAST_OTA_RESULT.
- Successful local OTA stores LOCAL_SUCCESS, shows a green blink, and schedules restart after 1.2 seconds.
- Failed local OTA aborts the official updater, stores the reason, shows red, keeps Wi-Fi available, and does not restart.

The local web UI remains deliberately simple and OTA-only.

## 8. ONLINE / CLOUD OTA OVER BLE + WI-FI

Online OTA is initiated by BLE and then takes exclusive control of Wi-Fi.

BLE supplies:
- SSID:<wifi name>
- PASS:<wifi password>
- URL:<https URL>
- VERSION:<metadata>
- CLOUDOTA

Requirements:
- SSID must be non-empty.
- Password must be non-empty.
- URL must use HTTPS.
- Version metadata must be non-empty.
- Duplicate pending requests are rejected.

Execution path:
1. BLE acknowledgements are given a 1.5 second start window.
2. Fan, Peltier, Adaptive, and higher-voltage selector state are forced safe.
3. BLE client state and queues are reset.
4. BLE is stopped with the official BLEDevice::deinit(false) path after the active connection is explicitly disconnected. The false argument retains controller memory so BLE can be initialized again after an OTA failure.
5. Wi-Fi enters STA mode with the supplied credentials.
6. The firmware waits for a valid system clock using configTime() before TLS validation, following Espressif's secure OTA example pattern.
7. WiFiClientSecure::useBuiltinCACertBundle() is used instead of a hardcoded DigiCert certificate block.
8. The official Arduino-ESP32 HTTPUpdate implementation performs the HTTPS GET, reads HTTPClient::getSize(), checks the HTTP status and image magic byte, calls Update.begin(size), streams through Update.writeStream(), and finalizes with the official Update.end() lifecycle.
9. httpUpdate.rebootOnUpdate(false) keeps control in the JE X FYZ runtime so the firmware can show the green success indication and restart on the existing 1.2 second timer.
10. The official HTTPUpdate error/result APIs provide the persisted failure reason.

HTTP/TLS configuration:
- HTTPS is required.
- Redirect following is enabled with a five-redirect limit on the HTTP client.
- HTTP client and secure client timeout are 12 seconds.
- The direct GitHub raw firmware URL is used without custom HTTP payload parsing.
- The CI release gate remains 2 MiB; the updater also enforces the available OTA partition size.

Online OTA result behavior:
- Success: stores the supplied metadata, shows green, schedules restart, then boots the new OTA partition.
- Failure: captures the official HTTPUpdate error string, turns Wi-Fi fully off, clears cloud credentials, forces safe outputs, restores BLE, and does not reboot.

This design intentionally uses the Espressif/Arduino-ESP32 OTA abstraction instead of a custom image parser or custom HTTP-to-OTA engine.

## 9. BLE IDENTITY, SECURITY, AND SESSION MODEL

BLE identity:
- Device name: `JE X FYZ`.
- Service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`.
- RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`.
- TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- BLE MTU: 247.

Security configuration:
- Secure Connections + bonding mode.
- IO capability: none.
- Key size: 16.
- Encryption and identity key masks are configured.
- RX writes require encrypted permissions.
- The protected RX path deliberately does not expose an unencrypted write-without-response route.
- The actual Arduino-ESP32 3.2.1-compatible API uses `ESP_LE_AUTH_REQ_SC_BOND` and `ESP_GATT_PERM_WRITE_ENCRYPTED`.

Session gate:
- On a new BLE connection, all state-changing commands are locked.
- The app must perform `SYNC`.
- The app then sends `SYNC_READY`.
- Only after `SYNC_READY` is accepted can state-changing commands be processed.
- This prevents stale app state from being replayed immediately after connection.
- BLE connect/disconnect never intentionally changes runtime voltage, Fan, Peltier, Adaptive, RGB, or Fan PWM.
- On disconnect, the firmware resumes advertising if the device is in normal BLE mode.

BLE queues:
- TX queue: 48 String entries.
- RX queue: 16 String entries.
- TX notification interval: 15 ms.
- RX command accumulator: 512 bytes.
- Individual commands longer than 180 characters are rejected.
- Queue operations use a FreeRTOS port mutex.

BLE callbacks:
- Connect callback only records lifecycle state and schedules queue reset.
- Disconnect callback resets BLE session gate and resumes advertising when safe.
- RX write callback only enqueues the received payload.
- Actual command dispatch happens from the main loop.

## 10. BLE TELEMETRY AND FULL SYNC

Full sync sends:
- `<SYNC_START>`
- `STATE_SEQ`
- `VERSION`
- `PROTOCOL`
- `BLE_SESSION`
- `VOLTAGE`
- `FAN`
- `PELTIER`
- `HOT`
- `BATTERY`
- `BATTERY_VALID`
- `ADAPTIVE`
- `ADAPTIVE_CEILING`
- `RGB`
- `MODE`
- `BRIGHTNESS`
- `RGB_COLOR`
- `COLOR_5V`
- `COLOR_9V`
- `COLOR_12V`
- `FAN_SPEED`
- `SAFETY`
- `SAFETY_REASON`
- `OTA_STATE`
- `LAST_OTA_RESULT`
- `RESET_REASON`
- `TEMP_HOT_LIMIT`
- `BATT_5`
- `BATT_12`
- `NTC_MV`
- `<SYNC_END>`

Hotside telemetry:
- Hotside temperature is intentionally transmitted every 1 second.
- Safety reason is republished with the hotside telemetry.
- Other runtime values use change-driven delta messages rather than unconditional 1-second spam.

Runtime safety reason values include:
- NONE
- NTC_ERROR
- HOTSIDE_PROTECTION
- FAN_REQUIRED
- VOLTAGE_STEP_FAILED

## 11. NTC TEMPERATURE ACQUISITION

Sampling:
- Exactly one ADC voltage acquisition every 1 second.
- First sample is performed immediately at boot.
- ADC value is read with `analogReadMilliVolts()`.
- Low/high fault window:
  - <=50 mV => invalid.
  - >=3250 mV => invalid.

Temperature conversion:
- Divider equation derives NTC resistance from measured ADC voltage using 3.3V and the fixed 10K resistor.
- Beta equation uses:
  - nominal resistance 10K,
  - nominal temperature 25°C,
  - beta 3950.
- Invalid mathematical results produce `ntcValid=false`.

NTC fault behavior:
- Fan is forced ON at 100%.
- Peltier is forced OFF.
- Voltage is forced/kept at 5V.
- Adaptive is disabled.
- Safety reason becomes `NTC_ERROR`.
- Normal RGB is overridden by the safety red indication when appropriate.

## 12. VOLTAGE SELECTOR

Available voltages:
- 5V
- 9V
- 12V

Hardware selector:
- 9V optocoupler on GPIO4.
- 12V optocoupler on GPIO3.

Normal request flow:
1. Reject if OTA is active or another transition is already active.
2. Reject manual voltage when Adaptive is ON.
3. Reject non-5V target when NTC is invalid.
4. Apply the manual one-second guard when appropriate.
5. Turn both 9V and 12V selector outputs OFF.
6. Wait 200 ms dead-time.
7. Apply the target selector output.
8. Preserve Fan/Peltier logical state.
9. Apply cooling/safety output arbitration.
10. Show the selected voltage color indicator for 1 second when RGB is ON.
11. Increment the state sequence and publish the new voltage.

Timing:
- Manual voltage guard: 1,000 ms.
- Optocoupler break-before-make dead-time: 200 ms.
- The one-second guard starts when the accepted manual request is received; the 200 ms selector dead-time runs inside that one-second protection window rather than adding another second afterward.
- Adaptive/safety voltage requests can bypass the manual guard when required.

Normal voltage switching does not intentionally turn Fan/Peltier OFF.

## 13. COOLING OUTPUTS AND PWM

Fan:
- GPIO6.
- PWM frequency: 25 kHz.
- Resolution: 8 bit.
- Allowed manual speed range: 50% to 100%.
- Step: 10%.
- Manual Fan PWM is available only when current voltage is 12V and Adaptive is OFF.
- Fan PWM is normalized back to 100% when 12V manual control is no longer active or Adaptive is active.
- No extra fan soft-start is used.

Peltier:
- GPIO5.
- PWM frequency: 20 kHz.
- Resolution: 8 bit.
- Logical Peltier ON can be reported immediately, but physical duty ramps from 0 to 255.
- Current source constant for the soft-start is 5,000 ms. The earlier inline source header that said 2 seconds was stale; the actual implementation is 5 seconds and this note records the code truth.
- Peltier OFF forces duty to zero immediately.

Interlock:
- Peltier cannot remain ON if Fan is OFF.
- User cannot turn Fan OFF while Peltier is ON.
- User cannot turn Peltier ON without Fan already ON.
- Critical hotside protection forces Fan ON at 100% and Peltier OFF.

## 14. ADAPTIVE MODE

Adaptive state:
- Adaptive ON requires a valid NTC.
- Adaptive ceiling starts at 12V.
- Every Adaptive ON forces the selector back to 5V first.
- Every Adaptive OFF also forces the selector back to 5V.
- Adaptive ceiling resets to 12V when Adaptive is turned OFF.
- Fan PWM is set to 100% in Adaptive.
- Manual voltage, manual Fan/Peltier control, Fan PWM, and temperature settings are rejected while Adaptive is active.
- RGB controls remain available.

Battery-zone mapping:
- Battery temperature below `battery5Limit` => 5V zone.
- Battery temperature below `battery12Limit` but at/above battery5 limit => 9V zone.
- Battery temperature at/above `battery12Limit` => 12V zone.

Default battery thresholds:
- BATT5 = 25°C.
- BATT12 = 35°C.

Editable ranges:
- BATT5: 20..48°C.
- BATT12: 22..50°C.
- BATT12 must remain above BATT5 with the firmware's enforced separation rule.

Battery behavior:
- Battery temperature comes from the App every 1 second through `PHONE:BT=`.
- A 5-second validity TTL is used.
- Battery values changing inside the same zone do not continuously retrigger voltage changes.
- A zone change is what creates the next Adaptive target.

Adaptive upward voltage:
- Upward movement is delayed by 5 seconds.
- If the live target changes during the wait, the timer is restarted for the new target.
- The target is clamped by the Adaptive ceiling.

Adaptive downward voltage:
- Downward changes are scheduled and processed without the 5-second upward delay.
- The normal voltage guard/interlocks still apply unless the request is a safety bypass.

## 15. HOTSIDE SAFETY / ADAPTIVE HOTSTEP

Hotside limit:
- User setting range: 40..50°C.
- Default: 45°C.

Critical protection:
- If valid hotside temperature reaches or exceeds the configured limit:
  - Fan is forced ON.
  - Fan PWM is forced to 100%.
  - Peltier is forced OFF.
  - Safety indication becomes active.
- In manual mode, the selected voltage is retained.
- In Adaptive mode, the high-temperature event also schedules a safety step.

Adaptive overheat sequence:
1. Peltier is cut OFF.
2. Fan remains ON at 100%.
3. Full 10-second cooling window begins.
4. Any pending battery-up or battery-down target is canceled.
5. If the hotside recovers during the 10-second window, Adaptive can resume Peltier after the full wait without unnecessarily discarding a voltage ceiling.
6. If the hotside is still protected after the full wait:
   - At 12V, Adaptive ceiling drops to 9V.
   - At 9V, Adaptive ceiling drops to 5V.
   - At 5V, Adaptive ends and Adaptive becomes OFF.
7. The firmware then requests the next lower voltage when a lower step exists.

Hotstep timing:
- Full Peltier-off cooling window: 10,000 ms.
- The source deliberately does not permanently disable cooling from a single hot event; recovery/resume is handled by the state machine.

## 16. BATTERY VALIDITY AND PHONE TELEMETRY

Command:
- `PHONE:BT=<temperature>`.

Accepted numeric range:
- 0..100°C.

Invalid battery telemetry:
- Marks battery data invalid.
- Sets battery display state to `--`.
- Clears Adaptive battery pending actions.
- Publishes `BATTERY_VALID=0`.

Valid battery telemetry:
- Updates battery temperature.
- Marks battery valid.
- Refreshes the 5-second validity TTL.
- Sends the value when materially changed.
- Updates the Adaptive battery zone when necessary.

The battery protection mechanism is firmware-side/system-side behavior and is not a separate safety UI object.

## 17. RGB / WS2812FX

LED strip:
- WS2812B / WS2812FX.
- 8 pixels on GPIO7.
- Driver object uses GRB + 800 kHz.

Persistent RGB state:
- RGB ON/OFF.
- RGB mode.
- Global RGB brightness.
- Custom RGB color.
- Per-voltage colors for 5V/9V/12V.

RGB modes:
| Firmware mode value | Name |
|---:|---|
| 0 | STATIC |
| 1 | BREATH |
| 2 | WIPE |
| 3 | RUNNING |
| 4 | SCAN |
| 5 | THEATER |
| 6 | RAINBOW |
| 7 | TWINKLE |

WS2812FX mappings used:
- STATIC -> built-in mode 0.
- BREATH -> 2.
- WIPE -> 3.
- RUNNING -> 18.
- SCAN -> 13.
- THEATER -> 16.
- RAINBOW -> 11.
- TWINKLE -> 22.

RGB defaults:
- RGB OFF.
- Mode STATIC.
- Brightness 100%.
- RGB color #FFFFFF.
- 5V color #FF0000.
- 9V color #00FF00.
- 12V color #0000FF.

Brightness:
- Firmware accepts 0..100%.
- Hardware brightness is derived from the stored percentage.

Voltage color indicator:
- After a voltage transition, the selected voltage color is displayed for 1 second when RGB is enabled.
- If RGB is OFF, the voltage indicator is not activated.

LED priority:
1. OTA SUCCESS green.
2. OTA FAILED red.
3. Online OTA connecting/downloading/applying blue.
4. Boot Wi-Fi silent mode.
5. Wi-Fi-client OTA-safe silence.
6. Safety red blink for invalid NTC/hotside protection.
7. Normal RGB effect.
8. Voltage color indicator when active.

Boot AP is intentionally visually silent when it is simply waiting for a client.

## 18. TOUCH SENSOR AND GESTURES

Hardware:
- One TTP223 sensor on GPIO1.
- There is intentionally no separate touch input for radio switching.

Timing:
- Debounce: 50 ms.
- Double-click window: 500 ms.
- Long press: 5 seconds.

Gesture mapping:
- Single tap: cycle manual voltage 5V -> 9V -> 12V. At 12V, next is not generated beyond the defined cycle logic; the firmware selects the next supported manual state according to current state.
- Double tap within 500 ms: RGB ON/OFF toggle.
- Long press after 5 seconds: Fan + Peltier ON/OFF operation.

Single tap handling:
- The first tap is held until the full double-click window expires.
- This prevents a real double tap from being interpreted as both a single voltage change and an RGB toggle.

Touch is suspended/ignored while OTA is active or while Adaptive forbids the corresponding manual action.

## 19. PERSISTENCE / NVS

NVS namespace:
- `jexfyz`.

Persisted groups:
### Temperature
- `hotLimit`.
- `batt5`.
- `batt12`.

### RGB
- `rgbOn`.
- `rgbMode`.
- `brightness`.
- `rgbColor`.
- `color5V`.
- `color9V`.
- `color12V`.

### OTA result
- `lastOta`.

NVS save policy:
- A settings change marks the configuration dirty.
- Settings are committed 10 seconds after the last change.
- The firmware does not persist runtime Fan/Peltier/Voltage/Adaptive/Fan PWM state.

Boot runtime reset is deliberate:
- 5V.
- Fan OFF.
- Peltier OFF.
- Adaptive OFF.
- Adaptive ceiling 12V.
- Fan PWM 100.
- Battery invalid until new phone telemetry arrives.
- NTC is re-sampled from hardware.

## 20. COMMAND PROTOCOL — APP / BLE

Session/system commands:
- `SYNC`
- `SYNC_READY`
- `OTAENTER`
- `SSID:<value>`
- `PASS:<value>`
- `URL:<https://...>`
- `VERSION:<value>`
- `CLOUDOTA`

RGB commands:
- `RGB:ON`
- `RGB:OFF`
- `MODE:<0..7>`
- `BRIGHTNESS:<0..100>`
- `COLOR:<6-digit hex>`
- `V5COLOR:<6-digit hex>`
- `V9COLOR:<6-digit hex>`
- `V12COLOR:<6-digit hex>`

Temperature commands:
- `HOTLIMIT:<40..50>`
- `BATT5:<20..48>`
- `BATT12:<22..50>`
- `RESET:TEMPERATURE`

Voltage/cooling commands:
- `VOLTAGE:5V`
- `VOLTAGE:9V`
- `VOLTAGE:12V`
- `FAN:ON`
- `FAN:OFF`
- `PELTIER:ON`
- `PELTIER:OFF`
- `ADAPTIVE:ON`
- `ADAPTIVE:OFF`
- `FANSPEED:<50|60|70|80|90|100>`

Color reset:
- `RESET:VOLTAGECOLORS`

Phone telemetry:
- `PHONE:BT=<0..100>`.

Unknown command behavior:
- The firmware returns a `COMMAND` failure with `UNKNOWN` reason.

Firmware command protections:
- Fresh BLE session requires SYNC -> SYNC_READY.
- User control commands inside the 250 ms anti-spam guard are rejected.
- Telemetry, SYNC, SYNC_READY, and OTA metadata are excluded from the user-control rate limit.

## 21. ACK / ERROR SEMANTICS

Common successful reason:
- OK.

Examples of intentional rejections:
- ADAPTIVE_ACTIVE.
- NTC_ERROR.
- PELTIER_ON.
- FAN_REQUIRED.
- HOTSIDE_PROTECTION.
- VOLTAGE_GUARD_OR_BUSY.
- RANGE_50_100_STEP_10.
- MANUAL_12V_ONLY.
- RANGE_40_50.
- RANGE_20_48.
- RANGE_22_50.
- MUST_BE_BELOW_BATT12.
- MUST_BE_ABOVE_BATT5.
- HTTPS_REQUIRED.
- MISSING_METADATA.
- ALREADY_PENDING.
- INVALID_HEX.
- INVALID.
- UNKNOWN_GROUP.
- SYNC_REQUIRED.

OTA failure result values currently generated include:
- TIME_SYNC_FAILED.
- DOWNLOAD_FAILED.
- INVALID_IMAGE_SIZE.
- INVALID_FIRMWARE_IMAGE.
- OTA_BEGIN_FAILED.
- OTA_WRITE_FAILED.
- DOWNLOAD_INCOMPLETE.
- OTA_FAILED.
- WIFI_FAILED.
- LOCAL_SUCCESS.
- UPLOAD_ABORTED.
- OTA_BEGIN_FAILED for local initiation failure.

Reset reason telemetry maps ESP reset reasons to:
- POWERON
- EXTERNAL
- SOFTWARE
- PANIC
- INT_WDT
- TASK_WDT
- WDT
- DEEPSLEEP
- BROWNOUT
- SDIO
- UNKNOWN

## 22. SAFETY / OUTPUT ARBITRATION RULES

Global rules:
- OTA-safe state has priority over ordinary cooler control.
- Invalid NTC is a thermal fault, not a normal off state.
- Peltier requires Fan.
- Fan cannot be switched OFF while Peltier is ON.
- Critical hotside protection can override a user's attempt to disable the Fan.
- Adaptive blocks manual cooling/voltage/temperature controls.
- Normal voltage changes do not intentionally interrupt active cooling.
- OTA radio transitions force outputs safe before ownership moves to Wi-Fi.
- Firmware state is source-of-truth and is mirrored back to the BLE client.

## 23. MAIN LOOP SERVICE ORDER

The normal loop gives priority to OTA and radio recovery.

Current high-level order:
1. Restart after successful OTA when restart time is reached.
2. Service boot-time local OTA AP.
3. Service active local OTA upload.
4. Service active online OTA.
5. Clear BLE queue reset requests.
6. Send pending full BLE sync.
7. Service BLE TX.
8. Process BLE RX.
9. Process pending online OTA start.
10. If online OTA becomes active, continue OTA and return.
11. Service touch gestures.
12. Sample NTC on its 1-second schedule.
13. Update battery validity TTL.
14. Process Adaptive hotstep timer.
15. Process Adaptive battery-down action.
16. Process Adaptive battery-up timer.
17. Complete voltage transition/dead-time.
18. Enforce safety.
19. Process Peltier soft start.
20. Process debounced NVS persistence.
21. Send hotside telemetry every 1 second.
22. Service LEDs.
23. Service BLE TX.
24. Call `yield()`.

This ordering is important because OTA/recovery must own the execution path before normal user-control work.

## 24. FIRMWARE SOURCE FUNCTION MAP

The current source is organized around the following major functions and responsibilities:

### Utility / parsing
- `voltageToString`, `voltageFromString`.
- `isHigherVoltage`, `lowerVoltage`, `clampToAdaptiveCeiling`.
- `boolText`, `formatTemperature`.
- `resetReasonText`.
- `parseHexColor`, `colorToHex`.
- `parseIntRange`, `parseFloatRange`.

### Persistence
- `loadSettings`.
- `markSettingsDirty`.
- `saveSettingsNow`.
- `processSettingsPersistence`.
- `saveOtaResult`.

### Fan/Peltier hardware
- `fanDutyFromPercent`.
- `writeFanPwm`.
- `stopPeltierOutput`.
- `beginPeltierSoftStart`.
- `processPeltierSoftStart`.
- `applyCoolingOutputs`.

### Safety
- `hotsideProtectionActiveNow`.
- `safetyAllowsPeltier`.
- `enforceSafety`.
- `safetyReason`.
- `publishSafetyReason`.

### Voltage state machine
- `voltageGuardAllows`.
- `manualVoltageRequestAllowed`.
- `requestVoltage`.
- `completeVoltageTransition`.
- `forceSafeFiveVolt`.
- `forceAdaptiveFiveVolt`.
- `startVoltageIndicator`.

### Temperature and Adaptive
- `ntcTemperatureFromOhms`.
- `sampleNtcIfDue`.
- `batteryZoneFor`.
- `batteryZoneVoltage`.
- `updateBatteryValidity`.
- `scheduleAdaptiveBatteryTarget`.
- `evaluateAdaptiveBattery`.
- `processAdaptiveBatteryDown`.
- `processAdaptiveUpTimer`.
- `processAdaptiveHotTimer`.
- `setAdaptiveState`.

### BLE transport
- `clearBleTxQueue`.
- `clearBleRxQueue`.
- `enqueueBleRxPayload`.
- `processBleRxQueue`.
- `sendText`.
- `serviceBleTx`.
- `sendDelta`.
- `sendAck`.
- `sendFullSync`.
- `sendHotsideTelemetry`.
- `isUserControlCommand`.
- `controlAckItem`.
- `userControlRateLimited`.
- `dispatchBleLine`.
- `feedBleRx`.
- `startBle`.
- BLE Server and RX callback classes.

### OTA
- `otaStateText`.
- `setOtaState`.
- `validHttpsUrl`.
- `clearCloudCredentials`.
- `stopWiFiRadio`.
- `applyOtaSafeOutputs`.
- `failOnlineOta`.
- `startOnlineOta`.
- `processOnlineOta`.
- `processPendingOnlineOtaStart`.
- `localOtaUploadHandler`.
- `handleOtaRoot`.
- `handleOtaPost`.
- `startLocalOtaAp`.
- `stopLocalOtaAp`.
- `stopBleForBootWiFiClient`.

### LEDs
- `ws2812fxMode`.
- `currentVoltageColor`.
- `hardwareBrightness`.
- `showAll`.
- `stopUserLedOutput`.
- `startUserLedEffect`.
- `renderBlink`.
- `resetBlinkState`.
- `processLeds`.

### Command handling
- `setFanState`.
- `setPeltierState`.
- `setFanSpeed`.
- `setRgbState`.
- `handleSettingsReset`.
- `handleCommand`.

### Touch
- `executeTouchSingle`.
- `executeTouchDouble`.
- `executeTouchLong`.
- `serviceTouch`.
- `setupTouch`.

### Lifecycle
- `setup`.
- `loop`.

## 25. CURRENT GPIO / OUTPUT SAFETY BASELINE AT BOOT

The hardware initialization explicitly:
- Configures NTC and touch inputs.
- Configures selector, Fan, and Peltier outputs.
- Starts with 9V selector OFF.
- Starts with 12V selector OFF.
- Starts Fan OFF.
- Starts Peltier OFF.
- Configures ADC.
- Attaches Fan PWM.
- Attaches Peltier PWM.
- Initializes WS2812FX.
- Loads persisted configuration.
- Resets runtime state.
- Samples NTC immediately.
- Runs safety enforcement.
- Starts the silent boot AP.

## 26. PUBLIC FIRMWARE DISTRIBUTION

Private source repository:
- `TenzoNkz/JEXFYZ-App`.

Public firmware repository:
- `TenzoNkz/JEXFYZ-Firmware`.

Current intended public layout:
- `manifest.json`
- `JEXFYZ-Vx.x.bin` at the main root.

Versioned filename rule:
- Firmware source `FW_VERSION[]` is extracted by CI.
- V3.2 -> `JEXFYZ-V3.2.bin`.
- V3.3 -> `JEXFYZ-V3.3.bin`.
- V4.0 -> `JEXFYZ-V4.0.bin`.

Manifest URL format:
- `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-Vx.x.bin`.

Legacy:
- `JEXFYZ.cpp.bin` is obsolete.
- `releases/` is obsolete for the current publication layout.
- Successful publish is intended to remove old root versioned binaries so the current root binary is the distribution target.

No SHA/hash field is part of the firmware release metadata contract.

## 27. GITHUB ACTIONS FIRMWARE BUILD BEHAVIOR

Current workflow:
- Name: Firmware Build.
- Explicit trigger only via `.github/FIRMWARE_BUILD_TRIGGER` after `Eksekusi Firmware`.
- Source changes do not trigger the workflow.
- No manual `workflow_dispatch` trigger remains.

Pinned CI environment:
- ESP32 Arduino core 3.2.1.
- WS2812FX 1.4.7.
- Adafruit NeoPixel 1.12.5.
- Ubuntu 24.04 runner.

CI compilation currently:
- Stages the sketch as `build/JEXFYZ/JEXFYZ.ino`.
- Compiles for ESP32-C3 with `PartitionScheme=min_spiffs`.
- Extracts `FW_VERSION[]`.
- Produces `JEXFYZ-Vx.x.bin`.
- Uploads the versioned firmware artifact.
- Attempts to publish to the public firmware repository.

Current cross-repository publication credential:
- Actions secret: `FIRMWARE_REPO_TOKEN`.
- Required for the private repository workflow to push to the separate public repository.
- The GitHub connection used to edit the repository is not the same credential context available as an Actions job secret.
- Do not embed the token in source, firmware, APK, or manifest.

## 28. VERIFIED CI HISTORY

### Run #6
- Failed against ESP32 Arduino core 3.2.1 because three BLE API calls no longer matched the pinned core.
- Fixed narrowly:
  - Secure authentication mode API updated.
  - Unavailable advertise-on-disconnect API removed because the existing disconnect callback already restarts advertising.
  - Encrypted GATT permission constant corrected.
- Commit: `3affa13a97d63eac1777ec2c6315fed9f8720a48`.

### Run #7
- Compile reached link stage but the default app partition was too small.
- Image size was about 1.826 MB versus a 1.310 MB default app slot.
- CI was changed to an OTA-capable larger partition scheme (`min_spiffs`).
- Commit: `80aec89a9dc9a9789169f1234b6ab9157b172a8a`.

### Run #8
- V3.2 compiled successfully.
- Image size: 1,826,608 bytes.
- Available app slot under CI `min_spiffs`: 1,966,080 bytes.
- Usage: about 92%.
- Artifact upload succeeded.
- Publish failed because `FIRMWARE_REPO_TOKEN` was unavailable.

### Run #9
- Triggered by the unified execution-trigger configuration update.
- This run was configuration verification, not a new firmware feature change.
- At the last recorded check it was still in progress.

## 29. COMMENT-FREE SOURCE CLEANUP

On 2026-09-26:
- The entire current `firmware/JEXFYZ.ino` source was processed with a C/C++-aware comment removal pass.
- Block comments and line comments were removed while preserving string literals, character literals, and raw string literals used for certificates and the local OTA HTML page.
- Original source length: 102,204 characters.
- New source length after comment removal: 80,236 characters.
- 21,968 characters of comments/annotation text were removed from the source.
- Lexical verification found 0 remaining C/C++ comments in the resulting source.
- No firmware logic was intentionally changed by this cleanup; the change was documentation placement/format only.
- All important design intent, implementation explanations, timing rationale, safety explanations, radio ownership rationale, and protocol documentation from the source comments have been moved into this `FIRMWARE_NOTES.md`.

## 30. CURRENT DOCUMENTATION RULE

For all future firmware work:
1. Read the latest `FIRMWARE_NOTES.md` from `main` before changing firmware.
2. Treat `firmware/JEXFYZ.ino` as the executable authority.
3. Do not reintroduce explanatory comments into `firmware/JEXFYZ.ino`; put durable documentation into this file instead.
4. Preserve the proven ArduinoDroid manual upload reference.
5. Keep firmware source, build configuration, OTA behavior, BLE contract, safety rules, and version policy synchronized with this note.
6. Every meaningful firmware change must update this note with the resulting behavior, files changed, verification state, and CI handoff information.
7. Firmware execution in the Code sub-chat uses the dedicated firmware trigger and must be followed through CI until the requested execution is verified.
8. Build failures must be fixed narrowly without unrelated feature changes.
9. Never claim firmware publication success until the public repository contains the expected versioned binary and the manifest points to it correctly.

## 31. 2026-09-26 — Documentation migration record

### Change
- Removed all comments from `firmware/JEXFYZ.ino`.
- Migrated the complete durable explanation of the firmware into this document.
- Added the proven ArduinoDroid board/upload configuration.
- Added the complete GPIO map.
- Added current protocol, telemetry, OTA, BLE security, NTC, voltage, cooling, Adaptive, safety, RGB, touch, persistence, CI, and distribution documentation.
- Added a source-function responsibility map.
- Recorded the exact source cleanup verification.

### Result
- Executable firmware source is now comment-free.
- Firmware engineering memory is centralized in `FIRMWARE_NOTES.md`.
- Source SHA after comment cleanup: `0a38cf7bfc91a450301eea37650d7b0e6dbe9942`.
## 2026-09-26 — Corrected firmware build trigger policy

- Firmware source changes must NOT automatically start Firmware Build.
- `Firmware Build` now triggers only when `.github/FIRMWARE_BUILD_TRIGGER` changes.
- Firmware source `firmware/JEXFYZ.ino` may be changed freely during implementation/discussion without starting CI.
- The Code sub-chat starts the build only after the user explicitly says `Eksekusi`.
- At that point the Code sub-chat updates `.github/FIRMWARE_BUILD_TRIGGER`, which starts exactly the same Firmware Build workflow.
- A single explicit execution may include firmware-only changes or a commit containing firmware plus other project files; the build trigger is independent of which project files were changed.
- `workflow_dispatch` remains removed.
- This supersedes the earlier note that said Firmware Build automatically triggered from `firmware/JEXFYZ.ino`.
- The unwanted Run #10 was caused by the previous source-path trigger and is not considered an intentional firmware execution request.

## 2026-09-26 — Final separation of firmware editing and firmware build

- Firmware implementation and firmware compilation are two separate user-controlled actions.
- In Code discussion, we can inspect and prepare changes without starting CI.
- After plain `Eksekusi`, Code applies the agreed repository changes, including `firmware/JEXFYZ.ino` when firmware source changes are part of the agreed work, but it does **not** update `.github/FIRMWARE_BUILD_TRIGGER`.
- Therefore source changes never automatically compile a `.bin`.
- The user separately commands `Eksekusi Firmware` when the current firmware source is ready to compile.
- Only that explicit firmware execution updates `.github/FIRMWARE_BUILD_TRIGGER` and starts Firmware Build.
- Firmware Build then verifies toolchain, identity, version, compile, artifact, and public firmware publication as applicable, and Code follows failures until the requested firmware execution is verified.
- This supersedes any older wording that described firmware source changes themselves as an automatic build trigger.


## 2026-09-26 — AUTHORITATIVE DISCUSSION → EXECUTION RULE

The project process is now explicitly two-phase:

### Phase 1 — Discussion first
- Every requested change is discussed/reviewed first.
- During discussion, no repository execution and no build is started.
- Proposed changes, affected files, expected behavior, preserved behavior, and risks are resolved before execution.

### Phase 2 — Explicit user command
- The exact command determines the action:
  - **`Eksekusi`** = apply all code/configuration/documentation fixes agreed during the discussion to the repository. This means make the discussed code correct across the relevant project files. It does **not** build App APK and does **not** build/publish firmware `.bin`.
  - **`Eksekusi Firmware`** = take the latest already-applied firmware source and build the newest firmware `.bin`, then publish it to the public `TenzoNkz/JEXFYZ-Firmware` repository using the configured Firmware Build pipeline. It is a separate action from applying source changes.
  - **`Build App`** in the Action sub-chat = trigger and complete the App Build workflow, repair build/CI failures narrowly when required, and deliver the verified APK artifact to chat.

### Strict separation
- Plain `Eksekusi` must never trigger `.github/APP_BUILD_TRIGGER` or `.github/FIRMWARE_BUILD_TRIGGER`.
- Plain `Eksekusi` must never compile or publish the firmware.
- `Eksekusi Firmware` is the only command in the Code workflow that intentionally updates `.github/FIRMWARE_BUILD_TRIGGER`.
- App Build remains exclusive to the Action sub-chat.
- Ordinary source changes never trigger either build workflow automatically.

## 2026-09-26 — Code #2 execution: firmware documentation/state synchronization

### Command
- User command: `Eksekusi Code`.

### Result
- Reviewed the latest firmware memory and reconciled the active separation between source editing and firmware compilation.
- No additional firmware source change was required from the immediately preceding discussion; the discussion established execution semantics rather than a new firmware feature.
- No `Eksekusi Firmware` operation was performed.
- `.github/FIRMWARE_BUILD_TRIGGER` was not updated by this Code execution.
- Firmware Build was not started.

### Authoritative workflow reminder
- Discuss first.
- Plain `Eksekusi` applies agreed repository/source/documentation changes only.
- `Eksekusi Firmware` separately builds the newest firmware and publishes the resulting versioned `.bin`.
- Firmware source changes do not automatically start CI.

## 2026-09-26 — V3.5 OTA PANIC TEST RELEASE

- User has manually flashed V3.4 because the previous online OTA attempt caused a firmware panic.
- Firmware source version is intentionally incremented to V3.5 for a controlled online-OTA test from a running V3.4 device.
- No functional firmware logic was intentionally changed in this version bump; the purpose is to make the App treat the public V3.5 package as a newer release and exercise the same online OTA transport path again.
- Preserve the existing V3.4 runtime behavior, BLE P1 contract, safety logic, radio exclusivity, and OTA flow while testing.
- `Eksekusi Firmware` is being performed now; build success, artifact, and public V3.5 publication must be verified before claiming the test package is ready.

## FIRMWARE BUILD #14 — V3.5 OTA TEST PACKAGE VERIFIED

- Run #14: `Firmware Build`, run ID `36214058400`.
- Head SHA: `511a84f9608da73f09452e1af5e0e09201f9f444`.
- ESP32-C3 compile: SUCCESS with the existing pinned build configuration.
- Firmware artifact `JEXFYZ-V3.5` uploaded successfully; artifact ID `10895889623`.
- Artifact size: 1,811,600 bytes; artifact is not expired at verification time.
- Cross-repository publication: SUCCESS using `TENZO_FULL_ACCESS`.
- Public repository `TenzoNkz/JEXFYZ-Firmware` independently verified to contain `JEXFYZ-V3.5.bin` and a V3.5 manifest.
- Public manifest URL points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V3.5.bin`.
- This V3.5 release is a controlled version-bump test package intended to exercise the online OTA path from the user-flashed V3.4 device; the previous OTA panic is not considered fixed until physical OTA testing is completed.

## 2026-09-26 — V3.6 EXECUTION: OTA MEMORY + BLE PAIRING FIX

- Firmware version advanced from V3.5 to V3.6 because executable firmware behavior changed.
- BLE pairing/bonding was removed from the runtime security setup. `BLESecurity`, `SC_BOND`, encrypted RX permissions, and the NimBLE encrypted-write property are no longer configured.
- The application-level `SYNC -> SYNC_READY` gate remains unchanged and continues to protect state-changing commands after connection.
- BLE shutdown for Wi-Fi OTA is centralized in `stopBleRadio()` and now uses `BLEDevice::deinit(true)` so BLE resources are released before HTTPS/TLS OTA memory pressure occurs.
- Online OTA cleanup now explicitly stops `cloudClient` on failure and before apply, and checks that the received byte count exactly matches the advertised image size before `Update.end(false)`.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, or P1 command/telemetry contract was intentionally changed.

## FIRMWARE BUILD #15 — V3.6 FULL FIX VERIFIED

- Run #15: `Firmware Build`, run ID `36214972250`, head SHA `4d80589119d9c49b0112ad7dd1cd272c1f33ce1b`.
- Compile, artifact upload, and public firmware publication all completed successfully.
- Firmware artifact `JEXFYZ-V3.6`, artifact ID `10896784103`, size 1,811,248 bytes, not expired at verification time.
- Public `TenzoNkz/JEXFYZ-Firmware` manifest now advertises V3.6 and points to `JEXFYZ-V3.6.bin`.
- Source verification confirms BLE bonding/security configuration is removed and V3.6 contains one `BLEDevice::deinit(true)` path for releasing BLE resources before online OTA.




## 2026-09-26 — Firmware source structure cleanup and App contract verification

### Source cleanup
- Reorganized the existing comment-free `firmware/JEXFYZ.ino` presentation without changing the control logic.
- Removed excessive blank-line runs and all trailing whitespace.
- Kept the existing functional order: constants/types → runtime state → prototypes → utilities → persistence → outputs/safety → voltage → temperature/Adaptive → BLE → OTA → command handlers → touch → setup/loop.
- Kept the source comment-free; durable explanations remain in this document.
- Source size changed from 80,236 to 79,451 characters and from 3,198 to 2,945 lines. The reduction is whitespace-only.

### App ↔ firmware contract verification
- Verified that the App and firmware use the same BLE service UUID, RX UUID, TX UUID, device name, and protocol value `P1`.
- Verified that the App command set matches the firmware command handlers for SYNC/session, OTA metadata, RGB, brightness/mode/colors, temperature limits, voltage, Fan, Peltier, Adaptive, Fan Speed, reset groups, and phone battery telemetry.
- Verified that the App consumes the firmware telemetry keys used by `sendFullSync()` and runtime deltas, including VERSION, PROTOCOL, BLE_SESSION, VOLTAGE, FAN, PELTIER, HOT, BATTERY, BATTERY_VALID, ADAPTIVE, ADAPTIVE_CEILING, RGB, MODE, BRIGHTNESS, RGB_COLOR, COLOR_5V/9V/12V, FAN_SPEED, SAFETY, SAFETY_REASON, OTA_STATE, LAST_OTA_RESULT, RESET_REASON, TEMP_HOT_LIMIT, BATT_5, BATT_12, and NTC_MV.
- No protocol or behavior change was introduced during this cleanup.

### CI / execution
- This was a Code execution only.
- No `.github/FIRMWARE_BUILD_TRIGGER` update was performed.
- No Firmware Build or `.bin` compilation was started by this change.
- The next separate `Eksekusi Firmware` will build the current source.

## 2026-09-26 — V3.9 OTA PANIC HARDENING EXECUTION

- Firmware source advanced from V3.8 to V3.9 for the runtime OTA panic hardening identified during the physical V3.7 -> V3.8 test.
- BLE OTA shutdown now explicitly terminates the known active connection before BLE stack de-initialization, and uses `BLEDevice::deinit(false)` so BLE memory remains reusable for the failure/recovery path.
- Online OTA does not use HTTP Content-Length, `HTTPClient::getSize()`, or `HTTPUpload::totalSize`.
- Online OTA reads the ESP32 image header and segment headers, validates ESP32-C3 identity, segment count/alignment, and calculates the exact image length including checksum padding and an appended 32-byte image hash when present.
- Online OTA starts `Update` with that calculated exact image size, writes the prefetched image preamble, rejects early disconnects as incomplete, rejects data beyond the calculated image size, and requires the received byte count plus `Update.isFinished()` before `Update.end(false)`.
- HTTP/1.0 mode is enabled for the GitHub raw image request and keep-alive reuse is disabled.
- Local OTA independently captures the image preamble, calculates the expected image size, requires an exact received-byte match, and finalizes with `Update.end(true)` because local `Update.begin(UPDATE_SIZE_UNKNOWN)` intentionally leaves the updater size at the OTA partition capacity.
- OTA failure diagnostics remain persisted through `LAST_OTA_RESULT`.
- GPIO5=Peltier, GPIO6=Fan, P1 BLE UUIDs, safety/cooling logic, NTC, Adaptive, voltage, RGB/LED, touch, and the 2 MiB CI release gate remain unchanged.

## FIRMWARE BUILD #20 — V3.9 FIRST HARDENING BUILD

- Run #20: `36220385175`.
- Source head SHA: `cab732e254a52bbd33f44dd159329f818963aaf2`.
- Compile, artifact upload, and public publication completed successfully.
- Artifact `JEXFYZ-V3.9`, artifact ID `10898324533`, was created successfully.
- This first V3.9 build was superseded before manual flashing because review found that its local OTA path incorrectly paired `Update.begin(UPDATE_SIZE_UNKNOWN)` with `Update.isFinished()`.

## FIRMWARE BUILD #21 — V3.9 CORRECTIVE BUILD VERIFIED

- Run #21: `36220619296`.
- Source head SHA: `ee364c6a85a52bbd33f44dd159329f818963aaf2`.
- ESP32-C3 Core 3.3.7 installation, dependency installation, source audit, compilation, artifact upload, and public firmware publication all completed successfully.
- Final artifact: `JEXFYZ-V3.9`, artifact ID `10898622293`, size 1,454,496 bytes, expired status false at verification time.
- Artifact digest: `sha256:667f66741490ef0391536bf1fa9eeb6adc90c357cdd4afb859022e0dd46c235b`.
- Public firmware repository manifest was independently verified as V3.9 and points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V3.9.bin`.
- The V3.9 corrective package is the package intended for the user's manual USB/ArduinoDroid flash before another online OTA experiment.

## 2026-09-26 — V3.9 NATIVE ESP OTA EXECUTION

- Replaced the fragile Arduino `Update` path and the previously introduced custom ESP image-size parser with the native ESP-IDF OTA API exposed by the ESP32-C3 platform: `esp_ota_begin`, `esp_ota_write`, `esp_ota_end`, and `esp_ota_set_boot_partition`.
- Online and local OTA now use native OTA handles with `OTA_SIZE_UNKNOWN`, so no HTTP Content-Length, multipart total size, or custom parsing of interleaved ESP image segments is required.
- `esp_ota_end` performs full image verification through the ESP-IDF OTA/image-verification stack before the boot partition is selected. A truncated or corrupt download therefore fails without selecting the new image.
- The 2 MiB runtime guard remains in place. A stream disconnect is only an end-of-transfer candidate; the actual acceptance decision is made by native OTA verification.
- BLE shutdown remains radio-exclusive and recovery-safe: active connections are explicitly terminated and `BLEDevice::deinit(false)` retains BLE controller memory so BLE can be initialized again after OTA failure.
- The previous V3.9 custom preamble parser is removed completely.
- No GPIO, P1 BLE UUIDs, cooling/safety behavior, NTC, Adaptive, voltage, RGB/LED, touch, or App protocol contract was changed.
- The V3.9 packages from Firmware Build #20 and #21 are superseded. The next build is the only V3.9 package that should be manually flashed and tested.
## 2026-09-26 — FIRMWARE BUILD #22 — V3.9 NATIVE ESP OTA FINAL VERIFIED

- Run #22: `36221049383`.
- Trigger/source head SHA: `ea43549d45b869dfe83196586ab1e4064e8b6065`.
- ESP32-C3 Core 3.3.7 installation, dependency installation, source audit, compilation, artifact upload, and public firmware publication all completed successfully.
- Final artifact: `JEXFYZ-V3.9`, artifact ID `10899520462`, artifact archive size 1,453,072 bytes, expired status false at verification time.
- Artifact digest: `sha256:fca198605a56ddf323f1f1b829048e1c97514aac9a5150c5b18f1548e2bc5a7a`.
- Extracted firmware binary size: 1,452,928 bytes. The binary identifies as an ESP-IDF application image for ESP32-C3 and contains the V3.9 firmware/BLE identity strings.
- The public firmware manifest was independently verified as V3.9 and points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V3.9.bin`.
- This #22 package supersedes V3.9 Build #20 and #21 and is the only V3.9 package intended for the user's controlled manual ArduinoDroid flash.
- After manual flash, first verify normal boot, BLE discovery/connection, and cooling behavior. The next online OTA test should use the same V3.9 device as the baseline only after that basic validation.

### V3.9 OTA implementation state
- Arduino `Update` was removed from the firmware OTA path.
- Online and local OTA use native ESP-IDF OTA handles with `OTA_SIZE_UNKNOWN`.
- Image acceptance is performed by `esp_ota_end()` and boot selection by `esp_ota_set_boot_partition()` only after native image verification succeeds.
- BLE shutdown keeps controller memory reusable with `BLEDevice::deinit(false)` and explicitly terminates the active connection before de-initialization.
- Online OTA does not use Content-Length, `HTTPClient::getSize()`, `HTTPUpload::totalSize`, or the previously invalid custom ESP image-size parser.
- A premature network disconnect can no longer be treated as proof of firmware completeness; the native OTA verifier is the final acceptance gate.
## 2026-09-26 — V4.0 OFFICIAL ESPRESSIF BASELINE / FULL OTA REFACTOR

- Source advanced from V3.9 to V4.0.
- Arduino-ESP32 CI baseline advanced from 3.3.7 to stable 3.3.12 (ESP-IDF 5.5.5).
- Online OTA now uses the official Arduino-ESP32 HTTPUpdate abstraction with HTTPClient::getSize(), Update.begin(size), Update.writeStream(), and Update.end().
- HTTPS uses WiFiClientSecure::useBuiltinCACertBundle(); the previous hardcoded DigiCert certificate bundle was removed.
- TLS clock setup remains based on Espressif's official secure OTA example pattern with configTime().
- Local OTA now uses the official Update API lifecycle and browser-provided file size when available.
- Custom native esp_ota_* download/write code and the custom ESP image-size parser were removed from the application firmware.
- BLE deinitialization remains BLEDevice::deinit(false) and occurs only after explicit active-connection termination, preserving BLE reinitialization after online OTA failures.
- GPIO mapping, P1 BLE UUIDs, safety, NTC, Adaptive, voltage, LED, touch, and App command/telemetry contracts were intentionally preserved.
- This is a source/configuration execution before the dedicated Firmware Build. The next Eksekusi Firmware build must verify Core 3.3.12 compilation, artifact publication, and public V4.0 manifest/package.

## FIRMWARE BUILD #23 — V4.0 FULL SUCCESS / PUBLISHED

- Run #23: Firmware Build, run ID 36224197399.
- Trigger/head SHA: 9cf979de169e3aab6fc941fa7754a1345bc944c0.
- ESP32-C3 Core 3.3.12 installation, dependency installation, source audit, version extraction, compilation, artifact upload, and public firmware publication all completed successfully.
- Artifact: JEXFYZ-V4.0, artifact ID 10899993135, not expired at verification time.
- Artifact archive size: 1,573,408 bytes.
- Artifact digest: sha256:f22ab1657d18d51a2e2de8e9bf737c02241442ed076ee2cf163829f7206637aa.
- Public firmware repository now contains JEXFYZ-V4.0.bin and manifest.json.
- Public V4.0 binary size: 1,573,264 bytes.
- Public manifest was independently verified as V4.0 and points to https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V4.0.bin.
- V4.0 preserves the P1 BLE contract, GPIO5=Peltier, GPIO6=Fan, safety/cooling/NTC/Adaptive/voltage/LED/touch behavior, and the 2 MiB release gate.
- V4.0 online OTA now follows the official Arduino-ESP32 HTTPUpdate -> getSize() -> Update.begin(size) -> Update.writeStream() -> Update.end() lifecycle.
- V4.0 TLS uses WiFiClientSecure::useBuiltinCACertBundle(); no hardcoded DigiCert certificate block remains in the firmware.
- The next required physical validation is controlled testing of V3.9 (or a manually flashed V4.0 baseline) -> V4.0 online OTA, plus local OTA regression verification.

## 2026-09-26 — V4.0 OFFICIAL ESPRESSIF SOURCE ALIGNMENT

- Current firmware source version: V4.0.
- Firmware CI baseline: Arduino-ESP32 Core 3.3.12 stable, based on ESP-IDF v5.5.5.
- Online OTA uses the official Arduino-ESP32 HTTPUpdate abstraction with a 12-second HTTPUpdate instance, official Content-Length/getSize handling, official Update.begin/writeStream/end lifecycle, and official HTTPUpdate error reporting.
- Online HTTPS uses NetworkClientSecure with the official built-in CA certificate bundle facility. Certificate time is synchronized with the official secure HTTPUpdate example pattern using pool.ntp.org and time.nist.gov.
- The previous hardcoded DigiCert certificate bundle in the application source is removed because the runtime now uses the official platform CA bundle.
- Local OTA continues to use the official Arduino Update API with a supplied browser file size when available and Update.end()/Update.end(true) according to the known-size/unknown-size path.
- BLE initialization checks BLEDevice::init() and BLEDevice::setMTU() return values; BLE shutdown continues to use BLEDevice::deinit(false) so controller memory remains reusable.
- P1 BLE UUIDs, GPIO mapping, cooling/safety behavior, NTC, Adaptive, voltage, RGB/LED, touch behavior, persistence, and Wi-Fi/BLE radio exclusivity are unchanged.
- The 2 MiB CI release gate remains active.


## FIRMWARE BUILD #24 — V4.0 FULL SUCCESS / PUBLISHED

- Run #24: Firmware Build, run ID `36225317977`.
- Trigger/head SHA: `e2678de6d3ef9afe28001c6992534429ff54c861`.
- ESP32-C3 Core 3.3.12 installation, source audit, compilation, artifact upload, and public firmware publication all completed successfully.
- Public repository contained `JEXFYZ-V4.0.bin` and a V4.0 manifest after this run.
- Public binary size at verification: 1,573,280 bytes.

## FIRMWARE BUILD #25 — V4.1 FULL SUCCESS / PUBLISHED

- Run #25: Firmware Build, run ID `36225940333`.
- Trigger/head SHA: `b9ea717bb5b3d05ff0c7b380b4126e9282b628ab`.
- Firmware source version: V4.1.
- Compile, artifact upload, and public publication all completed successfully.
- Public repository was advanced to `JEXFYZ-V4.1.bin` with a V4.1 manifest.
- Public V4.1 binary size: 1,573,280 bytes.
- V4.1 was created as the controlled firmware-version target after the V4.0 physical local OTA report.

## 2026-09-26 — V4.2 LOCAL OTA HARDENING AFTER PHYSICAL V4.0 FAILURE

- User reported that manually uploading the published V4.0 firmware through the local OTA page failed and the running device remained on V3.9.
- The exact physical failure cause was not known because no OTA page error string was supplied.
- The local OTA finalization path was changed from the known-size `Update.end()` branch to the official Arduino-ESP32 `Update.end(true)` path, while retaining the exact received-byte count check before finalization.
- The local OTA HTTP response now returns the persisted `otaResult` on failure, and the browser displays that returned diagnostic instead of a generic failure message.
- Firmware source advanced from V4.1 to V4.2 because the project version policy requires every executable firmware change to use a new major.minor version.
- GPIO5=Peltier, GPIO6=Fan, BLE P1 identity, cooling/safety, NTC, Adaptive, voltage, RGB/touch, and Wi-Fi/BLE radio exclusivity were not intentionally changed.

## FIRMWARE BUILD #26 — V4.2 FULL SUCCESS / PUBLISHED

- Run #26: Firmware Build, run ID `36226274561`.
- Source head SHA: `a09eba8322917d2f7b11e38e8428b09dcd5b1230`.
- Result: **SUCCESS**.
- ESP32-C3 Core 3.3.12, library installation, source audit, version extraction, compile, artifact upload, and public publication all completed successfully.
- Artifact: `JEXFYZ-V4.2`, artifact ID `10900183772`.
- Artifact archive size: 1,573,760 bytes.
- Artifact digest: `sha256:57d5414a28d789e6addff375cb4e2db37a3eda5e90f00ad4887b3d2c8932e2a6`.
- Public binary: `JEXFYZ-V4.2.bin`, size 1,573,616 bytes.
- Public manifest was independently verified as V4.2 and points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V4.2.bin`.
- Required physical validation remains: installed V3.9 device -> local boot AP OTA -> V4.2. Firmware is not declared physically OTA-verified until the user confirms the device reboots and reports V4.2.

## 2026-09-26 — V4.3 OTA FULL-STAGE DIAGNOSTICS

- Firmware source advanced from V4.2 to V4.3.
- Local and Online OTA failures now persist structured results containing MODE, STAGE, numeric error CODE, ERROR text, and PROGRESS.
- Local stages include file check, size check, Update begin, receive, flash write, size verify, finalize, flash readback/erase, and boot partition.
- Online stages include Wi-Fi connect, time sync, HTTPS begin, HTTP update, Update begin, download, flash write/erase/readback, image validation/verification, boot partition, and HTTP response.
- Live BLE telemetry adds OTA_STAGE, OTA_PROGRESS, OTA_ERROR_CODE, and OTA_ERROR; these keys are also included in full sync.
- NVS stores only the final OTA result, not every progress event.
- Existing exact byte-count validation and OTA radio ownership remain unchanged.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, BLE UUID/P1 contract, or Wi-Fi/BLE ownership rule was intentionally changed.


## FIRMWARE BUILD #27 — V4.3 FULL SUCCESS / PUBLISHED

- Run #27: Firmware Build, run ID `36229695808`.
- Source head SHA: `8f0578e2303abc9823f3315457d5cb905a82903e`.
- Result: SUCCESS.
- ESP32-C3 Core 3.3.12 installation, dependency installation, source audit, version extraction, compile, firmware artifact upload, ArduinoDroid temporary-source generation/upload, and public firmware publication all completed successfully.
- Firmware artifact: `JEXFYZ-V4.3`, artifact ID `10901902085`, not expired at verification time.
- Public binary: `JEXFYZ-V4.3.bin`, verified size 1,579,536 bytes.
- Public manifest: V4.3 -> `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V4.3.bin`.
- ArduinoDroid temporary source artifact: `JEXFYZ-V4.3-ArduinoDroid-Source`, artifact ID `10902041934`, not expired at verification time.
- The ArduinoDroid temporary source is intentionally compatible with the user's Core 3.3.7 setup by using `WiFiClientSecure` and `setInsecure()`; it is for temporary manual flashing/testing only and is not the normal secure online-OTA release source.
- Physical validation target: V4.2 -> V4.3 using the ArduinoDroid temporary .ino, then exercise Local OTA and Online OTA diagnostics.

## 2026-09-26 — ArduinoDroid V4.3 TEMPORARY SOURCE COMPATIBILITY FIX

- The first V4.3 ArduinoDroid temporary source generated by Firmware Build #27 failed to compile on the user's ArduinoDroid/Arduino-ESP32 Core 3.3.7 because Core 3.3.7 does not define UPDATE_ERROR_SHA256 or UPDATE_ERROR_SHA512.
- This is a temporary-source compatibility issue only; the normal V4.3 release source remains built against Core 3.3.12 and keeps its newer diagnostic enums.
- The CI temporary-source generation was corrected to strip the two unavailable Core 3.3.12-only case labels from the ArduinoDroid temporary copy, while retaining the rest of the OTA diagnostics.
- A corrected manual V4.3 ArduinoDroid source was exported for immediate USB flashing.
- No runtime cooling, BLE/P1, GPIO, NTC, Adaptive, voltage, RGB, touch, OTA protocol, or normal V4.3 release behavior was intentionally changed.
## 2026-09-26 — V4.4 ONLINE OTA STREAM TIMEOUT HARDENING

- Firmware source advanced from V4.3 to V4.4 after the physical V4.3 Online OTA test reached 77% and failed with UPDATE_ERROR_STREAM (code 6).
- Online OTA HTTP/socket timeout increased from 12 seconds to 60 seconds for NetworkClientSecure, HTTPClient, and HTTPUpdate.
- The diagnostic now appends the observed transfer percentage to a stream-timeout error, preserving the exact failure stage and numeric error code.
- This change targets intermittent/stalled download reads; Local OTA logic is not intentionally changed.
- Normal secure TLS verification remains enabled in the release firmware.
- ArduinoDroid temporary source generation remains Core 3.3.7-compatible for manual flashing.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, BLE UUID/P1 contract, or Wi-Fi/BLE radio ownership rule was intentionally changed.

## 2026-09-26 — V4.5 RESUMABLE ONLINE OTA EXECUTION

- Firmware source advanced from V4.4 to V4.5 after repeated physical Online OTA failures with UPDATE_ERROR_STREAM (code 6) at variable progress points.
- Online OTA no longer uses the single long-lived HTTPUpdate stream.
- Online OTA probes the public firmware URL with a one-byte Range request, then downloads in 64 KiB HTTP Range chunks.
- Each chunk uses a fresh HTTP connection with identity encoding, no-cache, and a 60-second timeout.
- If a range stream stalls after partial data is written, the OTA handle is aborted and resumed from the exact written offset with esp_ota_resume() without erasing the written image.
- Each range has up to 3 attempts; failure preserves the exact stage, numeric error code, and progress in OTA diagnostics.
- Online OTA explicitly calls esp_ota_end() for image validation and esp_ota_set_boot_partition() for activation.
- Local OTA behavior is intentionally unchanged by this release.
- Normal release TLS certificate verification remains enabled.
- ArduinoDroid temporary source generation remains Core 3.3.7-compatible.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, BLE UUID/P1 contract, or Wi-Fi/BLE radio ownership rule was intentionally changed.

## 2026-09-26 — V4.5 ARDUINODROID LEGACY OTA COMPATIBILITY

- Public V4.5 is built on Core 3.3.12 and uses esp_ota_resume() for true offset resume.
- The ArduinoDroid temporary source defines JEXFYZ_LEGACY_OTA and avoids esp_ota_resume() on Core 3.3.7; a stalled range retries from byte 0 on the temporary/manual build.
- This compatibility branch is only for manual flashing/testing. It does not alter the published Core 3.3.12 V4.5 binary behavior.

## FIRMWARE BUILD #31 — V4.5 RESUMABLE ONLINE OTA FULL SUCCESS

- Run #31: Firmware Build, run ID `36232892450`.
- Commit/source: `28cdf167580dc742ffb5965fbee3a2f033c94366`.
- Result: SUCCESS.
- ESP32-C3 Core 3.3.12 install, library install, source audit, version extraction, compilation, release artifact upload, ArduinoDroid temporary-source generation/upload, and public publication all succeeded.
- Release artifact: `JEXFYZ-V4.5`, artifact ID `10903365978`, size 1,576,272 bytes (artifact archive), digest `sha256:cfb0ea2940021b0747ec0946cef4fecc7c57dde37f6812b495b2d27e0b1d5684`.
- Public firmware: `JEXFYZ-V4.5.bin`, verified size 1,576,128 bytes.
- Public manifest is V4.5 and points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V4.5.bin`.
- ArduinoDroid temporary source artifact: `JEXFYZ-V4.5-ArduinoDroid-Source`, artifact ID `10903365980`, size 96,746 bytes (artifact archive), digest `sha256:93f9337021d920f499b247d029a7909a63a0711020938e65c939600ced2df820`.
- The temporary source defines `JEXFYZ_LEGACY_OTA`, uses `WiFiClientSecure + setInsecure()`, removes Core-3.3.12-only SHA error labels, and falls back to restarting the OTA transaction from byte 0 after a stream stall because `esp_ota_resume()` is not available on the user's Core 3.3.7 environment.
- The normal public V4.5 binary uses true `esp_ota_resume()` on Core 3.3.12.
- Physical validation is still pending: manual flash V4.5 temporary source, then Online OTA test.

## 2026-09-26 — V4.5 ARDUINODROID STRTOUL COMPATIBILITY FIX

- The V4.5 ArduinoDroid temporary source exposed a Core 3.3.7 compile error in the HTTP Content-Range parser because the new parser used strtoul().
- The parser is now implemented with a small internal decimal-token parser using Arduino String/size_t only, removing the strtoul dependency completely.
- The public Core 3.3.12 V4.5 Online OTA behavior remains unchanged.

## 2026-09-26 — V4.5 PHYSICAL ONLINE OTA SUCCESS / CURRENT BASELINE

- Physical V4.5 validation completed successfully on the user's ESP32-C3 hardware.
- Test method: the V4.5 diagnostic code was manually flashed through ArduinoDroid with the firmware label temporarily set to V3.8, then the device performed Online OTA to the public V4.5 release.
- Online OTA behavior observed: blue OTA indication during transfer, green success indication, device restart, then the App reported Current V4.5 and Latest V4.5 / Up to date.
- This confirms the V4.5 resumable Online OTA path works end-to-end on the target hardware with the published V4.5 binary.
- The earlier Online OTA failure mode UPDATE_ERROR_STREAM / code 6 at variable progress points (17%, 71%, 77%) is no longer reproducing in the successful V4.5 test.
- V4.5 Online OTA uses HTTP Range chunks, reconnect/retry, and true offset resume on the Core 3.3.12 public build.
- Public firmware repository baseline is now V4.5: JEXFYZ-V4.5.bin plus manifest.json.
- Public release engine: ESP32 Arduino Core 3.3.12.
- ArduinoDroid manual source remains a temporary Core 3.3.7-compatible source using JEXFYZ_LEGACY_OTA, WiFiClientSecure, and setInsecure() for manual flashing/testing only.
- Local OTA remains unresolved: the observed failure is LOCAL_FLASH_READBACK, UPDATE_ERROR_READ / code 3 at 100% after upload. This is separate from the now-working Online OTA path.
- OTA diagnostic telemetry remains active: OTA_STAGE, OTA_PROGRESS, OTA_ERROR_CODE, OTA_ERROR, and structured LAST_OTA_RESULT.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, BLE UUID/P1 contract, or Wi-Fi/BLE ownership behavior was changed by the V4.5 Online OTA fix.
- Current firmware test state: device is running V4.5 after a successful Online OTA update.
## 2026-09-26 — V4.6 OTA SAFETY LOCK / CODE HYGIENE EXECUTION

- Firmware source advanced from V4.5 to V4.6 for OTA-priority hardening and code cleanup.
- Added a top-of-file OTA Safety Lock with release-critical constants, compile-time size guards, OTA state declarations, and maintenance rules.
- Added an OTA Priority Supervisor that runs first in loop() and owns OTA restart, boot AP, Local OTA, Online OTA, and safe-output handling before application feature processing.
- OTA/AP startup was moved earlier in setup(), immediately after the power-control outputs are configured OFF and before sensor/LED/application initialization.
- OTA Diagnostic Core and OTA Engine are enclosed in locked comment fences to reduce accidental regression during future feature edits.
- Added a CI OTA protected-source audit that verifies required OTA engine functions, diagnostic telemetry, resumable transport, secure release TLS, loop priority, and absence of delay() inside the locked OTA engine.
- Existing V4.5 resumable Online OTA transport was preserved; the successful Range/reconnect/resume mechanism was not intentionally redesigned.
- Source whitespace was cleaned by removing trailing whitespace and excessive blank-line runs; deliberate OTA lock spacing remains.
- Absolute zero OTA failure cannot be guaranteed under all external conditions, but these guards are designed to keep OTA operational and prevent OTA-breaking source changes from reaching a release.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, BLE UUID/P1 contract, Wi-Fi/BLE ownership, or working V4.5 Online OTA behavior was intentionally changed.
## 2026-09-26 — V4.6 OTA STARTUP FAILURE-SAFE CORRECTION

- Corrected the early OTA/AP startup refactor so an AP startup failure cannot leave the device without BLE after the normal hardware/LED initialization completes.
- OTA/AP still starts early, but BLE fallback is deferred until feature hardware initialization has completed.
- OTA priority and the working V4.5 Range/reconnect/resume transport remain unchanged.
- CI audit now also rejects duplicate/missing OTA lock markers.

## V4.6 BUILD #33 ATTEMPT — OTA AUDIT MARKER CORRECTION
- Run #33 stopped before compile because the new CI OTA audit counted the shared text `OTA ENGINE — LOCKED` in both the start and end comments as a duplicate marker.
- The source itself was structurally correct; only the audit's marker-matching rule was too broad.
- The CI audit was tightened to distinguish start/end markers before the next V4.6 build.

## 2026-09-26 — EXECUTION COMPLETION RULE / OTA RELEASE GATE

- Rule for future full Code/Firmware execution: the task is not complete merely because a GitHub Actions run was triggered or is in progress.
- Continue until the latest required run reaches a terminal success state and the full pipeline is verified: source audit -> OTA safety audit -> compile -> firmware artifact -> ArduinoDroid temporary source -> publication -> public manifest.
- If any required stage fails, inspect the actual failure log, fix the root cause in the repository, commit the correction, trigger the next run, and continue verification until the final requested pipeline succeeds.
- Do not report completion or provide a final release artifact while the required run is failed, incomplete, or its required output has not been independently verified.
- Treat failed/intermediate runs as engineering states to be repaired within the same execution request.
## FIRMWARE BUILD #36 — V4.6 OTA SAFETY RELEASE FULL SUCCESS / PUBLISHED

- Run #36 completed successfully after automatically correcting the Run #35 OTA audit false-positive.
- Run #35 had failed only because the audit searched the explanatory comment `No delay()` as if it were a real blocking call; the audit was corrected to strip comments and check actual code.
- Run #36 then passed OTA safety audit, compilation, firmware artifact creation, ArduinoDroid temporary-source generation, and public publication.
- Firmware source version: V4.6. ESP32-C3 release engine: Arduino Core 3.3.12.
- Release artifact: `JEXFYZ-V4.6`, artifact ID `10903417989`, size 1,576,320 bytes, verified not expired at the time of completion.
- ArduinoDroid temporary source artifact: `JEXFYZ-V4.6-ArduinoDroid-Source`, artifact ID `10903632824`, size 100,010 bytes, verified not expired at the time of completion.
- Public firmware: `JEXFYZ-V4.6.bin`, verified size 1,576,176 bytes.
- Public manifest verified as V4.6 and points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V4.6.bin`.
- V4.6 source has OTA Safety Lock, OTA Priority Supervisor first in loop(), early OTA/AP startup, protected OTA Engine/Diagnostic Core fences, compile-time OTA guards, and a CI OTA protected-source audit.
- V4.5 resumable Online OTA transport remains preserved; no redesign was made to the working Range/reconnect/resume mechanism.
- Manual ArduinoDroid source remains Core 3.3.7-compatible and uses the temporary legacy branch only for manual flashing/testing.
- This is the final completed release state for the requested V4.6 OTA safety/code-organization execution. Physical V4.6 validation remains a separate hardware test step.
## 2026-09-26 — V4.7 EXECUTION / HTTP BODY DECODER CORRECTION

- V4.7 replaces the Online OTA raw `getStreamPtr()->read()` body path with Arduino-ESP32 `HTTPClient::writeToStream()` and a dedicated OTA flash Stream sink.
- The HTTPClient decoder remains responsible for Content-Length/chunked transfer framing before bytes reach the OTA flash writer.
- `Accept-Encoding: identity` now uses the official HTTPClient API `setAcceptEncoding()`.
- HTTP Range, retry/reconnect, and Core-3.3.12 `esp_ota_resume()` remain in place.
- Diagnostic progress/error reporting is preserved.
- Physical target: V4.5 known-good -> V4.7 manual/online validation. V4.6 image-verify failure at 100% / code 5379 is the defect being addressed.

## 2026-09-26 — V4.7 BUILD #37 FAILURE / STREAM SINK COMPILE FIX

- Run #37 reached the OTA protected-source audit successfully but failed during compile.
- Exact compiler error: OtaHttpFlashStream remained abstract because Print::write(uint8_t) is pure virtual in ESP32 Arduino Core 3.3.12.
- Added the required single-byte write(uint8_t) override, forwarding to the existing buffer-write implementation.
- No OTA runtime design change; this is a compile compatibility correction for the dedicated HTTPClient-to-flash sink.

## 2026-09-26 — V4.8 OTA/RADIO/LOCAL OTA FULL HARDENING

- Firmware advanced from V4.7 to V4.8.
- Local OTA no longer uses Arduino `UpdateClass`; it now uses ESP-IDF `esp_ota_begin/write/end/set_boot_partition`, eliminating the prior UpdateClass flash-readback verification path that produced `UPDATE_ERROR_READ / code 3` at 100%.
- Local OTA validates exact upload size and OTA partition capacity, validates the completed image with `esp_ota_end()`, and activates the target partition explicitly.
- ESP32-C3 Wi-Fi/BLE handoff is now explicit and retry-safe: Wi-Fi is forced OFF and settled before BLE initialization; partial BLE stack states are cleaned up; advertising is restored for a healthy initialized stack; BLE initialization failures are retried automatically.
- Local OTA failures keep the AP alive for another retry; Online OTA failures turn Wi-Fi OFF and enter BLE recovery.
- V4.7 Online OTA HTTP Range/reconnect/resume and HTTPClient `writeToStream()` body decoding remain unchanged.
- OTA Safety Lock, protected supervisor, locked OTA Engine/Diagnostic Core, and CI OTA audit remain mandatory.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, BLE UUID/P1 contract, or V4.7 Online OTA transport behavior was intentionally changed.

## 2026-09-26 — V4.8 BUILD FAILURE CORRECTION: UPDATE ERROR CONSTANTS

- V4.8 Run #40 compiled the source far enough to reveal that removing the Arduino Update/HTTPUpdate headers left legacy diagnostic names such as UPDATE_ERROR_READ/WRITE/STREAM undefined.
- Replaced those legacy dependency names with internal OTA error constants matching the documented numeric codes, so the firmware no longer depends on Update.h for diagnostics.
- No OTA transport, radio, or local OTA behavior changed in this correction.

## 2026-09-26 — V4.8 TEMPORARY SOURCE COMPILE GATE

- CI now compiles the generated ArduinoDroid temporary source with ESP32 Arduino Core 3.3.7 before the temporary-source artifact is uploaded.
- This prevents delivering a temporary `.ino` that passed only text transformation but fails in the user's ArduinoDroid engine.
- The public/release binary remains built with Core 3.3.12.

## 2026-09-26 — V4.8 CI TEMPORARY-SOURCE VALIDATION ISOLATION
- Run #44 failed because Core 3.3.7 was installed in the same runner as the Core 3.3.12 release build and exhausted runner disk while installing unused ESP32 toolchains.
- Moved ArduinoDroid/Core 3.3.7 temporary-source compilation into a dedicated validation job/runner.
- The release/publish job now waits for the dedicated validation job to pass.
- The validation job regenerates the same ArduinoDroid temporary-source transformation and compiles it with Core 3.3.7 before publication.
## 2026-09-26 — V4.8 BUILD #45 FAILURE / FINAL WORKFLOW VARIABLE FIX
- Run #45 failed before ArduinoDroid compilation because the isolated validation job contained malformed literal JavaScript-generated strings rather than shell variables.
- Corrected the validation job to use proper Bash ${VERSION}/${VALUE_FILE} expansion and the correct V4.8 audit version.
- Run #44 remains recorded separately as the runner-disk exhaustion failure; the validation job remains isolated on its own runner.

## 2026-09-26 — V4.8 BUILD #47 WORKFLOW FIX
- Run #47 failed in the dedicated ArduinoDroid validation job because the shell script still contained malformed JavaScript-style variable text and never initialized VERSION.
- Corrected the validation job to derive VERSION directly from FW_VERSION[] and use ordinary Bash expansion for the temporary filename.
- Release audit expectation is V4.8.

## 2026-09-26 — V4.8 BUILD #48 FAILURE / TEMP AUDIT QUOTING FIX
- Run #48 successfully installed Core 3.3.7 but failed in the ArduinoDroid source preparation checks because four grep commands still contained the malformed literal `"$"+"{VALUE_FILE}"`.
- Corrected those checks to standard Bash `${VALUE_FILE}` expansion.
- No firmware source or OTA logic changed in this correction.
## 2026-09-26 — V4.8 BUILD #49 FAILURE / TEMP PREP QUOTE FIX
- Run #49 reached Core 3.3.7 and failed only in the temporary-source preparation grep checks because the generated YAML still contained doubled quotes around ${VALUE_FILE}.
- Corrected the four grep checks to use normal Bash quoting.
- No firmware source/OTA behavior changed.
## 2026-09-27 — V4.9 RADIO STARTUP / CORE 3.3.7 BASELINE

- User hardware test on V4.8 showed neither the boot Wi-Fi AP nor BLE advertising was visible.
- Rebased the radio startup sequence to the known-good Core 3.3.7 behavior: complete peripheral initialization first, then start the 10-second boot AP.
- BLE handoff now uses full BLE stack deinitialization and explicitly settles Wi-Fi OFF before BLE initialization/advertising.
- Boot AP startup retries once after a complete Wi-Fi OFF cycle and prints deterministic AP/BLE readiness diagnostics to Serial.
- Removed the release dependency on `esp_ota_resume()`; range-stream recovery restarts the native OTA transaction from byte zero so the release remains Core 3.3.7 compatible.
- Firmware CI release core and ArduinoDroid validation core are both pinned to ESP32 Arduino Core 3.3.7.
- Firmware version advanced to V4.9.
- Physical hardware validation is still required after flashing V4.9.

## 2026-09-27 — V4.11 RADIO ROOT-CAUSE HARDENING / CORE 3.3.7

- V4.9 physical test still showed no visible Wi-Fi AP and no BLE.
- Analysis compared the V4.x radio lifecycle against the last known Core 3.3.7 baseline (V3.8).
- V4.11 restores the proven Core 3.3.7 Wi-Fi/BLE API order and `WiFiClientSecure` transport type.
- BLE recovery no longer gets stuck when the controller reports initialized while the BLE server/characteristics are absent; the stale controller is fully reinitialized.
- Boot AP startup now verifies that the AP actually remains in `WIFI_AP` mode before accepting the startup as successful, with one clean retry.
- After the 10-second AP window, Wi-Fi is explicitly settled OFF before BLE startup/recovery.
- The native `esp_ota_*` Local/Online OTA engine remains intact; no `esp_ota_resume()` dependency is used.
- Firmware remains pinned to ESP32 Arduino Core 3.3.7 for both release and ArduinoDroid validation.
- V4.11 is a new manual-flash test target; physical behavior still requires hardware validation.

## 2026-09-27 — V4.12 RADIO-FIRST BOOT ISOLATION

- V4.9 hardware test still showed no visible Wi-Fi/BLE after flashing the manually assembled file.
- Static analysis of the repository showed that the radio APIs themselves follow the V3.8 Core 3.3.7 baseline, but the V4.x boot path initializes many application/OTA features before starting the AP.
- V4.12 isolates radio startup: output pins are forced OFF, the WS2812 driver is initialized for diagnostics, then the boot AP is started before NTC/Preferences/PWM/application initialization.
- The remaining application features initialize only after the 10-second AP ownership window ends; BLE starts only after Wi-Fi ownership is released.
- BLE stale-controller recovery, AP post-start verification/retry, `WiFiClientSecure`, and the native `esp_ota_*` OTA engine remain protected.
- CI release and ArduinoDroid validation remain pinned to ESP32 Arduino Core 3.3.7.
- V4.12 source passed structural preflight: one setup(), one loop(), balanced braces/preprocessor blocks, no `esp_ota_resume()`, and required AP/BLE/OTA anchors present.
- Full CI compile remains the final pre-flash gate. Physical radio behavior still requires hardware validation.

# END OF FIRMWARE ENGINEERING MEMORY


## V3.4 CODE EXECUTION — CUSTOM LED ENGINE + ONEBUTTON

- Firmware version incremented from V3.2 to V3.4 for the approved runtime/library refactor and its build-correction pass.
- `firmware/JEXFYZ.ino` now uses `Adafruit_NeoPixel` as the low-level WS2812B driver; `WS2812FX` was removed completely.
- LED mode numbering is now 1..8:
  1. STATIC
  2. BREATH
  3. CENTER OUT
  4. OUTER IN
  5. DUAL CHASE
  6. LEFT RIGHT
  7. RAINBOW
  8. TWINKLE
- The LED engine is custom and non-blocking. It explicitly models the physical layout as 4 logical pixels on the left and 4 mirrored logical pixels on the right.
  - Left: `{0,1,2,3}`
  - Right: `{7,6,5,4}`
- Voltage indicator, OTA success/failure/progress indicators, and safety red indication remain higher-priority than user RGB effects.
- `OneButton` now handles the TTP223 input on GPIO1.
- Touch behavior remains: single click 5V -> 9V -> 12V; double click RGB ON/OFF; long press Fan + Peltier ON/OFF; debounce 50 ms; double-click window 500 ms; long press threshold 5 s.
- Existing OTA, BLE P1 protocol, safety, cooling interlocks, voltage dead-time, NTC, persistence, and radio ownership behavior were not intentionally changed by this refactor.
- Firmware CI dependency setup installs `OneButton 2.6.1` and `Adafruit NeoPixel 1.12.5`; WS2812FX is no longer installed.
- No App Build was triggered by this Code execution.
- `Eksekusi Firmware` is the separate build/publish step for V3.3.


## FIRMWARE BUILD #11 — V3.3 ATTEMPT / CORRECTION

- Run #11 compiled the new OneButton and Adafruit NeoPixel libraries successfully through dependency installation and source identity audit.
- Run #11 failed only in compilation because the custom LED block referenced `currentVoltageColor()` and `hardwareBrightness()` before their definitions; the helpers were restored in the correct order.
- The correction is included in firmware V3.4. A new `Eksekusi Firmware` build is required and will be verified through compile, artifact, and public-repository publication.


## FIRMWARE BUILD #12 — V3.4 BUILD VERIFIED / PUBLISH BLOCKED

- Run #12: `Firmware Build` on commit `02d8a756eeb8234a463e35dc3f5bdae354bb0ce5`.
- ESP32-C3 compile completed successfully with ESP32 Arduino core 3.2.1, OneButton 2.6.1, and Adafruit NeoPixel 1.12.5.
- Output: `JEXFYZ-V3.4.bin`, 1.8 MB; sketch usage 1,811,310 bytes / 1,966,080 bytes (92%).
- GitHub Actions artifact `JEXFYZ-V3.4` was successfully finalized as artifact ID `10896420002`; uploaded archive contains `JEXFYZ-V3.4.bin`.
- Public repository publication did not complete because the workflow runtime received an empty `FIRMWARE_REPO_TOKEN`. No public-repository file or manifest change is claimed from this run.
- The source/build itself is verified successful. Cross-repository publication remains pending until `FIRMWARE_REPO_TOKEN` is available to the workflow, after which the same V3.4 artifact/rebuild can be published to `TenzoNkz/JEXFYZ-Firmware`.


## CURRENT V3.4 PUBLISH CONFIGURATION

- Firmware Build publish step now reads the repository secret `TENZO_FULL_ACCESS` for access to `TenzoNkz/JEXFYZ-Firmware`.
- The workflow no longer references the legacy secret name `FIRMWARE_REPO_TOKEN`.
- `Eksekusi Firmware` has triggered a fresh V3.4 build after this secret-name correction; publication is considered complete only after the Actions publish step succeeds and the public repository is independently verified to contain `JEXFYZ-V3.4.bin` and a V3.4 `manifest.json`.


## FIRMWARE BUILD #13 — V3.4 FULL SUCCESS / PUBLISHED

- Run #13: `Firmware Build`, commit `81a36100bd766cea058d074e16ca484301f332e5`.
- Firmware V3.4 compile: SUCCESS on ESP32-C3 with ESP32 Arduino core 3.2.1, OneButton 2.6.1, and Adafruit NeoPixel 1.12.5.
- Build artifact `JEXFYZ-V3.4` was finalized successfully; artifact ID `10895544253`, expired status false at verification time.
- Cross-repository publish: SUCCESS using repository secret `TENZO_FULL_ACCESS`.
- Public firmware repo `TenzoNkz/JEXFYZ-Firmware` was independently verified to contain exactly `JEXFYZ-V3.4.bin` and `manifest.json` at root.
- Public binary size verified: 1,811,456 bytes.
- Public manifest verified:
  - version: `V3.4`
  - URL: `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V3.4.bin`
- The old V3.2 distribution file is no longer present in the public repo root after the publish cleanup.
- This is the first completed V3.4 build-and-publish verification after the `TENZO_FULL_ACCESS` secret rename.

## 2026-09-26 — V3.7 EXECUTION: OTA RECOVERY DIAGNOSTICS + EXACT HARDWARE PARTITION

- Firmware source advanced from V3.6 to V3.7 for the approved OTA-recovery changes.
- The CI firmware target was changed from `PartitionScheme=min_spiffs` to the ESP32-C3 `no_fs` partition scheme, which corresponds to the user's verified ArduinoDroid selection `No FS 4MB (2MB APP x2)`.
- Local OTA now starts `Update` with the uploaded file size when available, tracks received bytes, and requires an exact byte-count match before finalization.
- OTA end failures now preserve `Update.getError()` and `Update.errorString()` before aborting, storing a detailed `LAST_OTA_RESULT` value instead of only `OTA_FAILED`.
- Online OTA now also preserves the detailed `Update` finalization error before the common failure path.
- OTA start stores `IN_PROGRESS` so the App can distinguish an unfinished OTA from a prior successful/failed result.
- No GPIO, NTC, cooling, Adaptive, voltage, RGB, touch, BLE UUID, or P1 contract changes were introduced by this V3.7 OTA patch.
- This is a source/configuration execution only. No Firmware Build was started by this change.


## 2026-09-26 — V3.7 OTA FINALIZE CORRECTION

- Corrected the V3.7 OTA finalization check so `Update.isFinished()` is evaluated before `Update.end(false)`.
- The source no longer checks `Update.isFinished()` after a successful `Update.end()`, because Arduino-ESP32 3.2.1 resets the updater state during successful finalization.
- Local and online OTA now use `Update.end(false)` after confirming the full image has been received.
- This correction is required before treating the V3.7 package as a valid OTA release.

## FIRMWARE BUILD #16 — V3.7 FULL SUCCESS / PUBLISHED

- Run #16: Firmware Build, run ID `36217379643`, head SHA `b0daf9304666a799da9ec51919ee375846e969d5`.
- ESP32-C3 core install, dependency installation, source audit, version extraction, compilation, artifact upload, and cross-repository publication all completed successfully.
- Firmware artifact `JEXFYZ-V3.7`, artifact ID `10897368348`, contained `JEXFYZ-V3.7.bin`.
- Exact firmware binary size: 1,812,640 bytes. Binary SHA-256: `2a03892f1841e6c79a1bab34ccfe7593433a87bd291ce501c42a8c0c347e1f0f`.
- CI now uses the ESP32-C3 `no_fs` partition scheme, matching the user's verified ArduinoDroid `No FS 4MB (2MB APP x2)` target.
- Public repository `TenzoNkz/JEXFYZ-Firmware` was independently verified to contain `JEXFYZ-V3.7.bin` and a V3.7 manifest pointing to the GitHub raw firmware URL.
- Source verification after the build: V3.7 is present, GPIO5 remains Peltier, GPIO6 remains Fan, and BLE bonding/security configuration remains removed.
- This release is ready for the physical OTA test from the user's currently running V3.4 device. Hardware/wiring remains unchanged.


## 2026-09-26 — ArduinoDroid default-argument preprocessing fix

- Fixed the `showAll()` declaration/definition pattern in `firmware/JEXFYZ.ino` that caused ArduinoDroid to report `redefinition of default argument`.
- The default argument `brightness = 255` is now declared once in the explicit prototype and omitted from the function definition.
- No runtime behavior, GPIO mapping, OTA logic, BLE contract, safety logic, or hardware configuration changed.
- No Firmware Build was triggered by this source-only compatibility fix.

## 2026-09-26 — V3.8 OTA-FIRST EXECUTION

- Firmware source advanced from V3.7 to V3.8.
- Online OTA no longer depends on HTTP `Content-Length` / `HTTPClient::getSize()`.
- Online OTA uses `Update.begin(UPDATE_SIZE_UNKNOWN, U_FLASH)` and finalizes variable-length images with `Update.end(true)` after the download stream ends.
- Local OTA likewise no longer depends on `HTTPUpload::totalSize`; it uses `Update.begin(UPDATE_SIZE_UNKNOWN, U_FLASH)` and `Update.end(true)`.
- OTA write failures preserve detailed `Update.getError()` / `Update.errorString()` diagnostics before cleanup.
- Firmware CI is pinned to ESP32 Arduino Core 3.3.7, matching the user's ArduinoDroid environment.
- Firmware CI enforces a hard 2 MiB (`2,097,152` byte) release binary limit; binaries above this limit are rejected before publication.
- Hardware, GPIO mapping, P1 BLE contract, BLE UUIDs, NTC, cooling, voltage, Adaptive, LED, and touch behavior remain unchanged.
- This execution is OTA-first by design: the installed V3.7 device is the intended baseline for testing V3.7 -> V3.8 without USB/manual recovery dependency.
- Firmware Build was triggered separately after these source/configuration changes.


## FIRMWARE BUILD #17 — V3.8 OTA RELIABILITY FULL SUCCESS / PUBLISHED

- Run #17: Firmware Build, run ID `36219233740`, head SHA `d7bfaa25b43a4889656055f51a12e732c7e4bf1b`.
- ESP32-C3 Core 3.3.7 installation, dependency installation, source audit, version extraction, compilation, artifact upload, and public firmware publication all completed successfully.
- Published artifact: `JEXFYZ-V3.8`, artifact ID `10899170248`, not expired at verification time.
- Public firmware binary: `JEXFYZ-V3.8.bin`, verified size 1,453,120 bytes, below the 2 MiB release gate.
- Public manifest was independently verified as V3.8 and points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V3.8.bin`.
- Source verification after build confirms V3.8, no `HTTPClient::getSize()`, no `HTTPUpload::totalSize`, OTA uses `UPDATE_SIZE_UNKNOWN` and `Update.end(true)`, and CI uses ESP32 Core 3.3.7 with `PartitionScheme=no_fs`.
- Hardware/GPIO/P1/BLE UUID/cooling/safety behavior was not intentionally changed in this OTA-focused release.
- V3.8 is the new OTA test target from the user's installed V3.7 device. No USB/manual recovery is assumed for the test path.
