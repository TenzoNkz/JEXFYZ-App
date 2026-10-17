# JE X FYZ / JE Cooler — Firmware & Hardware Reference

Durable hardware and behavior decisions belong here. For code-level structure see firmware/FIRMWARE_TECHNICAL_REFERENCE.md; for protected OTA use OTA_PROTECTION.md; for incidents read the two dedicated regression-memory files. Latest App release Build #71 is App-only and is not Firmware compilation or OTA proof.

## Hardware platform and pinout

- MCU: ESP32-C3 Super Mini / ESP32-C3 Dev Module; logic/ADC reference assumption is 3.3 V.
- ESP32-C3 has one radio path: Wi-Fi OTA and BLE must not operate as concurrent radio owners; transfer ownership deliberately.
- GPIO 0: Hotside NTC ADC.
- GPIO 1: TTP223 Touch input.
- GPIO 3: 12 V selector control.
- GPIO 4: 9 V selector control.
- GPIO 5: Peltier MOSFET PWM.
- GPIO 6: Fan MOSFET PWM.
- GPIO 7: WS2812 LED.
- MOSFET wiring remembered from the project: GPIO → R100 → gate; 100 kΩ gate-source pull-down. Fan positive goes to supply (called “Decoy” in wiring notes); fan negative goes to MOSFET drain. Verify physical wiring before making assumptions about unexpected voltage/current.

## NTC / sampling

- Nominal NTC: 10 kΩ; fixed divider resistor: 10 kΩ; Beta 3950; 25°C nominal model; divider uses 3.3 V assumption.
- Use the calibrated ESP32-C3 `analogReadMilliVolts(PIN_NTC)` path and one ADC sample per second. The user explicitly rejected median filtering, trimmed means and multi-sample averaging. Do not add them without explicit approval.
- NTC temperature telemetry / Hotside safety reading interval: one second.
- Sensor fault/invalid state must fail safe: Fan 100%, Peltier OFF, Adaptive OFF and safe 5 V according to current implementation.
- Hotside limit range: 40–50°C; default 45°C.
- A reported reset cause is unknown until Serial `BOOT: RESET_REASON=...` or matching BLE telemetry is captured.

## Output and timing contracts

- Peltier PWM: 20 kHz, 8-bit; ordinary OFF→ON uses a 5-second soft-start to full duty.
- Fan PWM: 25 kHz, 8-bit; manual Fan setting range 50–100%; cooling/safety demands may force 100%.
- Selector break-before-make deadtime: 200 ms. Maintain the existing safe selector sequence.
- Existing shared voltage guard/rail settle interval: 1 second.
- Adaptive upward voltage step: 5-second non-blocking dwell after each completed increase in both HOTSIDE and HOTSIDE_BATTERY profiles; downward steps are immediate unless a specific safety transition governs otherwise.
- Use cooperative `millis()` timing. No executable `delay()` or timing `while()` loops.
- Every functional Firmware change increments `FW_VERSION`; filename must match; only one active versioned `.ino` may exist.

## Peltier voltage-transition contract — V6.6

Read `VOLTAGE_TRANSITION_MEMORY.md` before changing this logic.

- If Peltier is OFF, changing voltage does not turn it ON.
- If Peltier is ON and 5-second soft-start is still running when a normal Manual Volt or Adaptive transition is accepted: save the interrupted-ramp state; force GPIO5 PWM to 0% before selector outputs change; retain 200 ms break-before-make; wait the existing 1-second settle; then start a fresh full 5-second ramp.
- If soft-start is already complete (full duty): do not force PWM to 0%. Keep PWM at 100% continuously through the selector transition unless OFF/safety commands require shutdown.
- Fan stays ON/100% during handoff.
- Peltier-OFF, Hotside/NTC safety or OTA safe outputs must clear the pending resume so output cannot restart after an overriding shutdown.
- Adaptive entry/exit uses the safe-5V selector handoff without forcing an additional Peltier OFF/ON cycle. The shared transition helper pauses only an active soft-start; a completed ramp remains at 100%, while explicit OFF and existing safety/OTA paths retain priority.
- User reported a restart during 5 V→12 V while Peltier/Fan were ON during soft-start. Supply transient/brownout is a hypothesis only. Capture reset diagnostics; do not claim cause without evidence.

## Hotside / Adaptive safety

- Manual Peltier safety latch re-arms only after Hotside remains at/below `hotLimit - 1°C` for five continuous seconds. A single low sample must not bypass the latch.
- Adaptive thermal safety has a 30-second recovery window at each rail (12 V, 9 V, 5 V), with Peltier OFF and Fan 100%.
- If Hotside reaches at/below `hotLimit - 1°C` for 5 continuous seconds before the window expires, cancel the active dwell and keep the rail/resume only where allowed.
- If it does not recover, 12 V/9 V step down one rail; unrecovered 5 V enters terminal lock requiring manual restart.
- After Adaptive thermal downshift, restoration proceeds upward one rail at a time after 60 seconds continuously at/below `hotLimit - 1°C`, no higher than the saved pre-downshift ceiling.
- HOTSIDE is default Adaptive profile after boot. HOTSIDE_BATTERY is a runtime selectable profile, not persisted. When Battery sensor data is missing, fall back to HOTSIDE behavior without changing chosen profile.
- No rapid Hotside-rise/slope protection is present in the known V6.x contract; do not claim it exists.
- [HISTORICAL USER REQUIREMENT / NOT IMPLEMENTED IN V6.6] A prior request called for a very rapid Hotside rise to shut Peltier OFF immediately and require manual re-arm/restart. The active V6.6 contract does not implement slope/rate-of-rise protection; do not describe the request as completed. If reconsidered, discuss first, update source with a mandatory version bump and test the safety behavior.
- Keep thermal/NTC safety higher priority than App requests, normal RGB animation, or pending Peltier restart.

## Touch and indicators

- TTP223 gesture processing history: startup ignore/grace ~1,000 ms; qualified stable edge; 30 ms qualification; tap valid raw HIGH 60–500 ms; double tap window 800 ms from first valid release; long press 5,000 ms. Verify current source before changing these timings.
- User-approved Adaptive indicators: ON blinks orange 3 times; OFF blinks white 3 times. OFF feedback is deferred until safe 5 V handoff completes if Adaptive was active; if already safely at 5 V it may start immediately.
- [USER-REPORTED HISTORICAL ISSUE / PHYSICAL STATUS UNVERIFIED] The white Adaptive-OFF three-blink indication was reported missing immediately after restart. A code path for Adaptive-OFF transition feedback does not by itself prove the initial boot-time OFF indication is shown; recheck exact source path and physically validate before calling this fixed.
- Default manual voltage LED map: 5 V red, 9 V green, 12 V blue; customizable with reset-to-default.
- Supported decorative RGB modes preserve firmware IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. Mirror Pulse ID 3 is retired; stored ID 3/invalid values migrate to Static and new ID 3 commands are rejected.
- Firmware sends one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple computed at BLE notification time. App preview interpolates monotonically and later snapshots correct phase drift without resetting animation each update.
- Firmware-safety/OTA LED feedback has higher priority than decorative RGB animation.

## Settings persistence / telemetry

- Firmware sends Hotside temperature telemetry every second.
- Other state changes should send only when changed.
- Persistent settings share a 10-second quiet-period debounce: every new change resets the timer; after 10 seconds idle, write only settings different from persisted shadow.
- Persisted settings include Hotside limit, Battery 5 V/12 V limits, RGB enable, mode, brightness and color. Adaptive Profile remains runtime-only.
- App must be kept synced using authoritative telemetry (Adaptive, ceiling, Fan, Peltier, Fan speed, Voltage), including hardware Touch changes.

## Adaptive Fan PWM at 12V — V6.7 source-only, uncompiled

- Adaptive Fan PWM at 12V is automatic only in Adaptive mode. Reaching the configured Hotside limit immediately forces Fan PWM to 100%.
- Downshift requires ten recent one-second NTC samples, their rolling average and every sample at/below `hotLimit - 2°C`, no meaningful warming trend, and one continuous stable 10-second interval. Decrease by 10 percentage points every 10 seconds, down to a 50% floor.
- Losing the safe margin or detecting a warming trend cancels downshift and raises PWM by 10 points per fresh one-second sample. Adaptive 5V/9V keep existing 100% Fan behavior. Existing Peltier/thermal safety logic retains authority.
- NTC acquisition remains one calibrated reading per second. Averaging is used only for Fan PWM downshift permission; no extra ADC reads or blocking timing loops were introduced.
Active source: `firmware/JEXFYZ-V6.7.ino`, blob `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`. It has not been compiled, published, OTA-applied or tested on hardware.

## Phone Battery Adaptive input / thresholds

- Firmware receives phone battery temperature from App protocol `PHONE:BT=<Celsius>`; the App sends a heartbeat at 1 Hz while connected.
- Current Battery-zone defaults are 25°C for 5 V and 35°C for 12 V, with 0.5°C hysteresis. Firmware marks the battery input stale after 5 seconds (`BATTERY_VALID_TTL_MS`).
- With HOTSIDE_BATTERY selected and valid phone Battery data, the controller uses the battery zones inside the saved Adaptive voltage ceiling. When Battery data becomes stale/unavailable, runtime control falls back to HOTSIDE behavior while preserving the selected HOTSIDE_BATTERY profile; do not silently rewrite the profile.
- This is separate from Hotside NTC sampling: the user explicitly rejected median, trimmed-mean and multi-sample NTC filtering; retain one calibrated NTC sample per second.

## Wi-Fi / BLE / OTA

- OTA has priority over normal application tasks. Ensure safe output state while OTA runs: Peltier OFF, Fan OFF, LED/output handling according to protected OTA state machine, selector safe at 5 V.
- Wi-Fi OTA and BLE use the same ESP32-C3 radio path; shut down Wi-Fi completely and allow it to settle before BLE owns the radio.
- Boot-time Local OTA uses the protected Wi-Fi SoftAP window: `BOOT_AP_TIMEOUT_MS = 10000` (10 seconds with no client); a separate 60-second hard limit covers an AP session that was interacted with but does not proceed to upload. BLE must not start while Wi-Fi owns the single radio; complete Wi-Fi shutdown and its existing 160 ms settle before BLE takes ownership. Read `OTA_PROTECTION.md` before modifying these timings.
- Read `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md` before any change.
- Current Online OTA path uses `cloudClient.setInsecure()`, removes embedded CA validation and OTA-only NTP/TIME_SYNCING gate, and starts GitHub GET after Wi-Fi connection feedback. This bypasses HTTPS server certificate identity validation; it was retained after the user-reported failure on the prior CA/NTP path.
- Preserve allowlisted URL prefix `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/`, redirect blocking, response/length/size checks, ESP image magic check, streaming/update lifecycle, safe outputs, failure recovery and restart semantics.
- No custom SHA/signature layer is part of the agreed Firebase update metadata contract; version + link. Do not assume the hosted BIN equals active source without verified provenance.
- Historical OTA LED intent: Wi-Fi connect success → blue feedback then download/update; OTA success → green feedback then restart; Wi-Fi/OTA failure → red feedback then restore BLE without forced reboot where the existing state machine allows. Check current source/protection file before asserting an exact LED sequence.

## Validation status

[HISTORICAL USER-REPORTED — 2026-10-14] The user reported V6.6 was accepted, compiled and updated twice over Online OTA. On 2026-10-17 the user reopened Firmware source work and authorized a V6.7 Adaptive Fan PWM change. That earlier compile/OTA report does not validate V6.7; V6.7 remains uncompiled.

This is the 2026-10-14 user report, not an assistant-witnessed compile/flash log. Source-to-BIN provenance remains unverified. Previously reported restart symptoms and Adaptive-OFF boot indication remain historical/unverified. The separate request for rapid Hotside-rise shutdown/manual re-arm remains unimplemented; V6.7 adds Adaptive Fan PWM trend response, not a hard rate-of-rise shutdown or manual re-arm. Do not expand into that separate safety feature without explicit scope approval.

[HISTORICAL / SUPERSEDED APP CI EVIDENCE — BUILDS #39/#40, NOT FIRMWARE COMPILE] Builds #39 and #40 ran 80 Flutter tests, including then-current `test/v6_6_qc_contract_test.dart` assertions over V6.6 source. Build #40 compiled/signed the Android APK but stopped before publication at a source-archive path assertion. These historical App CI checks are not an Arduino/ESP32 compile, BIN-provenance validation, physical sensor/thermal test or OTA proof.

No Firmware source, BIN, Firebase metadata, flash or OTA operation was performed in this App-signing task.


## HISTORICAL / SUPERSEDED App CI evidence — Build #65 (later App Build #70; not Firmware compilation)

- App Build #65 / run `38851040144`, exact source `f301c1fbbafa3d6c17803d9a2f50bae390dc1343`, passed Dart analysis, **88/88 Flutter tests** and the native FPS parser JUnit gate, plus Android release/signing and downloaded asset checks. These App tests check source contracts and parser logic; they do not invoke the Arduino/ESP32 compiler or prove physical rail transitions, NTC accuracy, LED behavior, OTA transfer/apply/reboot or installed version.
- The user reports that Firmware V6.6 compiled and completed two same-version Online OTA updates. These remain USER-REPORTED rather than independently witnessed logs. V6.6 is USER-ACCEPTED FINAL; exact source-to-BIN provenance remains UNVERIFIED. No Firmware source was changed and no compile/BIN/Firebase/OTA/flash/device action occurred during this memory reconciliation.
