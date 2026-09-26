# JE X FYZ FIRMWARE — COMPLETE ENGINEERING MEMORY

## 1. SOURCE AUTHORITY AND CURRENT STATE

- Authoritative firmware source: `firmware/JEXFYZ.ino`.
- Current firmware version: `V3.2`.
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

### CI discrepancy to remember
The GitHub Actions Firmware Build workflow currently compiles with Arduino ESP32 FQBN option `PartitionScheme=min_spiffs`, not the exact ArduinoDroid label above. The source itself does not depend on this documentation difference, but the CI build target is currently not identical to the user's proven ArduinoDroid menu selection. Do not silently assume that `min_spiffs` means `No FS 4MB (2MB APP x2)`; verify the Arduino core's exact board-option mapping before changing the workflow.

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
- Update.h.
- HTTPClient.h.
- WiFiClientSecure.h.
- Preferences.h.
- WS2812FX.h.
- math.h.
- time.h.
- BLEDevice.h.
- BLEServer.h.
- BLEUtils.h.
- BLE2902.h.
- BLESecurity.h.
- ESP system reset-reason support.
- FreeRTOS queue-mutex support.

Pinned/required project libraries:
- WS2812FX 1.4.7.
- Adafruit NeoPixel is kept in the CI dependency list at >=1.1.7 in the source project memory, although the current source's direct LED object uses WS2812FX.

The firmware source does not use OneButton.

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

Local OTA is intended only for firmware updating.

Web endpoints:
- `GET /` serves the built-in OTA HTML page.
- `POST /update` receives the firmware upload.

The page:
- Shows JE X FYZ branding.
- Shows the running firmware version.
- Accepts only `.bin` files in the file picker.
- Shows upload progress.
- Uses XMLHttpRequest to post the binary to `/update`.
- Reports success/failure in the browser.

Upload behavior:
- On upload start, OTA state becomes `LOCAL_UPLOAD`.
- Cooling outputs are forced safe/off.
- `Update.begin(UPDATE_SIZE_UNKNOWN)` is opened.
- Each upload chunk is written through `Update.write()`.
- The final write is accepted only when `Update.end(true)` and `Update.isFinished()` both succeed.
- Successful local OTA stores `LOCAL_SUCCESS`, shows a green blink, and schedules restart after 1.2 seconds.
- Failed local OTA aborts the update, stores a failure reason, shows a red indicator, and does not restart.
- After a local OTA failure, Wi-Fi remains available so another upload attempt can be made without rebooting.
- Local OTA state and result are exposed through BLE telemetry after normal radio recovery.

Local OTA timing:
- Restart delay: 1,200 ms.
- Failure indicator window: 1,000 ms.

## 8. ONLINE / CLOUD OTA OVER BLE + WI-FI

Online OTA is initiated by BLE and then takes exclusive control of the Wi-Fi radio.

BLE supplies:
- `SSID:<wifi name>`.
- `PASS:<wifi password>`.
- `URL:<https URL>`.
- `VERSION:<metadata>`.
- `CLOUDOTA`.

Requirements before starting:
- SSID must be non-empty.
- Password must be non-empty.
- URL must be HTTPS.
- Version metadata must be non-empty.
- Duplicate pending requests are rejected.

The request is held briefly so queued BLE acknowledgements can be transmitted first. The start wait is 1,500 ms, after which the firmware starts online OTA even if the phone has disappeared.

When online OTA begins:
- Fan OFF.
- Peltier OFF.
- Adaptive OFF.
- Voltage is forced to 5V.
- Fan PWM state is normalized to 100.
- BLE queues are cleared.
- BLE client/session state is reset.
- BLE is deinitialized.
- Soft AP is disconnected.
- Wi-Fi enters STA mode.
- Wi-Fi sleep is disabled.
- Auto-reconnect is disabled.
- Wi-Fi connects using the supplied credentials.

HTTPS validation:
- The firmware uses a built-in DigiCert root bundle for TLS validation.
- The HTTPS server must validate through the trusted CA bundle.
- GitHub/raw-content TLS is expected to be covered by this trusted certificate set.
- Redirect following is enabled with a maximum of 5 redirects.
- HTTP timeout is 12 seconds.
- The device performs system-time synchronization using pool.ntp.org, time.nist.gov, and time.google.com because certificate validation requires a valid clock.

Before touching the OTA partition, the downloaded image is checked:
- HTTP response must be 200 OK.
- Content size must be positive.
- Stream must be available.
- The first payload byte must be 0xE9, the expected ESP32 image magic byte.
- This rejects HTML pages, JSON, source files, GitHub error pages, and other non-firmware payloads before OTA write begins.

Download behavior:
- Payload is read in 1024-byte chunks.
- Each successful chunk is written with `Update.write()`.
- Last received-byte timestamp is refreshed as data arrives.
- No-data timeout: 7,000 ms.
- A complete download transitions to `CLOUD_APPLYING`.
- `Update.end(false)` must succeed and `Update.isFinished()` must be true.

Online OTA success:
- Stores a success result, including the supplied metadata when present.
- Shows green blink.
- Schedules restart after 1,200 ms.

Online OTA failure:
- Aborts the update.
- Stores the failure reason.
- Shows a red indicator.
- Turns Wi-Fi fully OFF.
- Clears cloud credentials from runtime RAM state.
- Resets cooling state to 5V/Fan OFF/Peltier OFF/Adaptive OFF.
- Restarts BLE without an ESP reset.

Online OTA states:
- IDLE
- BOOT_AP
- LOCAL_UPLOAD
- CLOUD_CONNECTING
- CLOUD_DOWNLOADING
- CLOUD_APPLYING
- SUCCESS
- FAILED

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

# END OF FIRMWARE ENGINEERING MEMORY


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
