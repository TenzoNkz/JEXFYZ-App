# JE Cooler V1.4

Official Android controller for JE X FYZ.

- Android app name: **JE Cooler**
- In-app header: **JE X FYZ**
- Android package: `com.horizontalzzz.jexfyz`
- Android version text: **Telegram @horizontalzzz**
- Firebase project: `je-x-fyz`
- Reference: `TenzoNkz/Horizon-Cooler-App`

## V1.1 corrections

- No `delay()` in normal firmware loop.
- Boot behavior is JE-specific: Wi-Fi AP OTA first for 10 seconds, then Wi-Fi OFF and BLE ON permanently.
- If a Wi-Fi client connects during the boot OTA window, Wi-Fi remains until the client disconnects.
- One TTP223 only: single tap voltage, double tap RGB, 5-second hold Fan+Peltier.
- Local OTA is boot-window only; no extra OTA button is added.
- BLE parser accepts fragmented/multi-command newline frames with bounded buffering.
- App sends a complete command set once after the first Full Sync; afterward user changes send only the changed command.
- Phone battery temperature indicator remains active; battery telemetry is a data heartbeat, while Adaptive voltage commands happen only on battery-zone changes.
- Adaptive hot protection discards the highest voltage that triggered a step-down for the remainder of that Adaptive session. Ceiling resets to 12V only when Adaptive is switched OFF.
- Hotside display is not clamped; only the protection setting is 40–50°C.
- Online OTA uses Firebase metadata at firmware_update with only version and url. SHA-256 is not used. HTTPS is used for the firmware download.

## V1.2 changes

- Phone battery temperature is read every 1 second to stay synchronized with the firmware Hotside telemetry cadence.
- While BLE is connected, the App sends `PHONE:BT=x.x` every second as telemetry/heartbeat. The firmware alone decides when a battery-zone voltage request is needed.
- App-side battery reads are serialized so slow native responses cannot overlap.


## V1.4 / Firmware V1.5 synchronization
- Adaptive ON/OFF always returns the cooler voltage selector to 5V.
- While Adaptive is ON, Voltage manual, Control (Fan/Peltier/Fan Speed), and Temperature settings are locked in the App and rejected by firmware.
- RGB settings remain available.
- Manual voltage has a 1-second app-side guard in addition to the firmware guard.
- Battery temperature continues to be sampled/sent every 1 second.
- During an Adaptive ON/OFF transition, the relevant App controls remain locked until firmware confirms the forced 5V state.

- Manual voltage guard starts immediately on the App tap and runs concurrently with the firmware 200 ms optocoupler dead-time.
