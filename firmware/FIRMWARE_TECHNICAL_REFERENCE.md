# JE X FYZ — Firmware Technical Reference

Last source audit recorded: 2026-10-14 (Asia/Jakarta). Always fetch live source and compare before relying on line locations/hashes.

## Current source identity

- Canonical editable source: `firmware/JEXFYZ-V6.6.ino`.
- `FW_VERSION = "V6.6"`; source blob last observed: `f51ba6db5d0e91318f63fea4014bb87f7bf76222`.
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module, Arduino-ESP32 Core 3.3.7, compiled by the user in ArduinoDroid.
- This reference is not compile proof. The user reported that V6.6 compiled successfully and Online OTA update succeeded. The assistant did not independently verify the compile log, installed version or whether the artifact BIN matches this source; physical safety/thermal/LED regression and complete OTA recovery gates remain open. Release state remains DEVELOPMENT + QC / PRE-RELEASE, NOT RELEASED.

## Architecture

- Cooperative main loop; time-based control uses `millis()` rather than blocking delays.
- OTA is supervised before normal application work.
- ESP32-C3's single radio path requires an explicit Wi-Fi/BLE ownership handoff.
- Local OTA starts from a boot SoftAP. Current constants are `BOOT_AP_TIMEOUT_MS = 10000` (no-client window) and `BOOT_AP_HARD_LIMIT_MS = 60000` (hard cap after AP interaction). BLE may start only after Wi-Fi is shut down and the existing 160 ms radio-settle interval elapses. Treat this as protected OTA/radio behavior.
- Hotside NTC is the universal thermal safety input.
- Firmware maintains authoritative hardware state and sends telemetry/state deltas to App. The App must not invent physical state from command ACK alone.
- RGB sync uses one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple. An internal queue marker is expanded only in `serviceBleTx()` immediately before notification, so phase/mode/cycle are atomic and phase does not age in the BLE queue.
- Firmware IDs are Static 1 (1000 ms), Breath 2 (2200 ms), Comet 4 (1600 ms), Dual Chase 5 (900 ms), Left/Right 6 (1800 ms), Rainbow 7 (30000 ms). ID 3 is retired; saved ID 3/invalid values migrate to Static and `MODE:3` is rejected.
- App provides Android phone Battery temperature at 1 Hz via `PHONE:BT`; current Firmware Battery freshness TTL is 5 seconds and the Battery zones have 0.5°C hysteresis. The App’s Battery heartbeat does not change the one-calibrated-sample-per-second NTC rule.
- Persistent setting writes share a quiet-period debounce; Adaptive Profile is runtime-only.

## Pin/output map

| Function | Pin / setting |
|---|---|
| Hotside NTC ADC | GPIO0 |
| TTP223 touch | GPIO1 |
| 12 V selector | GPIO3 |
| 9 V selector | GPIO4 |
| Peltier MOSFET | GPIO5 |
| Fan MOSFET | GPIO6 |
| WS2812 LEDs | GPIO7 |
| Peltier PWM | 20 kHz, 8-bit, 5 s normal OFF→ON ramp |
| Fan PWM | 25 kHz, 8-bit; manual target 50–100% |
| Selector deadtime | 200 ms break-before-make |
| Shared voltage guard | 1,000 ms |
| NTC sample/telemetry cadence | one calibrated sample per second |

Electrical assumptions: logic/divider reference 3.3 V; 10 kΩ fixed resistor + 10 kΩ nominal NTC, Beta 3950. Use `analogReadMilliVolts(PIN_NTC)` as the single sample; no median, trimmed mean or multi-sample average. NTC invalid state fails safe (Peltier OFF, Fan 100%, Adaptive OFF, safe 5 V according to current implementation).

## Voltage transition and Peltier soft-start

The canonical detailed incident/contract is `VOLTAGE_TRANSITION_MEMORY.md`.

- `requestVoltage()` records accepted transition state and pauses only an active Peltier soft-start before selector shutdown.
- If the ramp is active, capture the interrupted state, force GPIO5 to 0%, retain selector 200 ms break-before-make, and restart a fresh five-second ramp after the one-second guard.
- If ramp completion has already occurred, keep PWM at 100% throughout the rail transition. No forced 0%, no redundant ramp.
- If Peltier is logically OFF, a voltage change never turns it on.
- OFF command, thermal/NTC safety and OTA safe-output must cancel pending resume state. Explicit Peltier OFF during Adaptive-stop also clears the deferred restore flag, preventing handoff completion from turning Peltier back on.
- Fan remains on/forced to 100% during transition.
- Adaptive mode entry/exit uses a safe-5V selector handoff without forcing an additional Peltier OFF/ON cycle. The common voltage-transition helper pauses only an active soft-start; a completed ramp stays at 100%. Explicit OFF and Hotside/NTC/OTA safety retain priority.
- A reported restart during 5 V→12 V with active ramp is not proven to be brownout. Use `BOOT: RESET_REASON=...` and live telemetry for diagnosis.

## Hotside / Adaptive safety

- Hotside limit: configurable 40–50°C, default 45°C.
- Manual Peltier safety latch requires Hotside `<= hotLimit - 1°C` continuously for five seconds before re-arm; no single-sample bypass.
- Adaptive thermal protection uses a 30-second stage at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%.
- Five seconds continuously at/below `hotLimit - 1°C` before timeout cancels the stage. Otherwise 12 V/9 V step down one rail; unrecovered 5 V enters terminal lock requiring manual restart.
- Restoration after thermal step-down requires 60 seconds continuously at/below `hotLimit - 1°C` for each upward rail, capped at the saved pre-downshift Adaptive ceiling.
- HOTSIDE is the startup default; HOTSIDE_BATTERY is runtime selectable but is not persisted. Battery sensor loss falls back to HOTSIDE behavior without changing the user's profile selection.
- No rapid Hotside slope/rise protection is present in the known V6.x contract.

## Touch / indicators / preferences

- TTP223 gesture timing recorded from QC: about 1,000 ms startup grace, 30 ms qualification, raw HIGH tap duration 60–500 ms, 800 ms double-tap window and 5,000 ms long press. Verify the live source before adjusting.
- Adaptive ON indication: three orange blinks. Adaptive OFF: three white blinks; OFF indication waits for safe 5 V completion if Adaptive was active.
- Manual voltage indicator defaults: 5 V red, 9 V green, 12 V blue; colors are configurable.
- Safety and OTA indications outrank decorative RGB animation.
- Persistent settings include Hotside limit, Battery 5 V/12 V limits, RGB enable/mode/brightness/color. Every setting change resets the shared 10-second quiet-period timer; write only changed persistent values after the period. Adaptive Profile remains runtime-only.

## OTA boundaries

- Read `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md` before any OTA source edit.
- Current Online OTA uses `cloudClient.setInsecure()`; the embedded root CA validation and OTA-only NTP/TIME_SYNCING gate are absent. This bypasses server certificate identity validation; do not hide this security trade-off.
- Keep raw GitHub URL allowlist for `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/`, redirects disabled, response/length/size/image checks, streaming update lifecycle, all-off safety output, failure recovery and restart behavior.
- No custom SHA/signature layer is part of the user-approved Firebase OTA metadata model; version + link only.
- Never assume the artifact BIN is compiled from current source until source/version/build provenance is verified.

## Static versus runtime validation

Static source assertions and file/blob checks can verify paths, constants and ordering. They cannot certify Arduino compilation, electrical stability, real NTC accuracy, LEDs, cooling, safety response, BLE pairing, full OTA apply or reboot. Record each validation gate separately.
