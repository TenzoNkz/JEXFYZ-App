# JE X FYZ / JE Cooler — Firmware & Hardware Reference

Durable hardware and behavior decisions belong here. For code-level structure see firmware/FIRMWARE_TECHNICAL_REFERENCE.md; for protected OTA use OTA_PROTECTION.md; for incidents read the dedicated regression-memory files.

## Current product baseline — 2026-10-21

- Owner confirms the sold/shipped unit uses App Build #124 and Firmware V7.1, which was compiled and updated through Online OTA. This is USER-REPORTED deployment status and supersedes older notes that describe V7.1 as not compiled/deployed.
- The independently verified App release is Build #124 / Actions run 39386733061, package source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. App CI does not independently verify Firmware compilation, source-to-BIN identity, physical OTA/reboot, BLE recovery, or thermal/electrical behavior.
- Treat V7.1 as the field baseline; avoid discretionary Firmware/OTA changes to a unit that cannot be routinely recovered physically. Preserve source/version filename alignment and the current OTA contract.



## BLE authorization checkpoint — 2026-10-20 (BLOCKED / NOT IMPLEMENTED)

- User requires normal UX: power on cooler → open App → Connect BLE → use it; no QR, no additional Touch gesture, and preserve all current gestures.
- Current `firmware/JEXFYZ-V7.1.ino` configures encrypted/bonded writes but uses Just Works; `SYNC_READY` opens its command gate. This is not proof of official App identity.
- Do not add a self-service first-key claim: any arbitrary initial BLE peer might claim the cooler. A server-authorized, device-bound enrollment grant and per-session nonce/signature verification are required. See `BLE_APP_AUTH.md`.
- At the 2026-10-20 BLE-auth review, no Firmware source edit/version bump occurred in that task. The owner subsequently confirmed V7.1 compile/Online OTA success on 2026-10-21; exact source-to-BIN provenance and installed identity remain independently unverified.
- **OTA PROTECTED / NO CHANGE:** all Local/Online OTA logic, transport/TLS, handoff, checks, timing, recovery and restart remain untouched.


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

## Current Peltier voltage-transition contract — V6.7

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
- [USER REQUIREMENT / STILL NOT IMPLEMENTED IN V7.0] A prior request called for a very rapid Hotside rise to shut Peltier OFF immediately and require manual re-arm/restart. The active V7.0 contract does not implement slope/rate-of-rise protection; do not describe the request as completed. If reconsidered, discuss first, update source with a mandatory version bump and test the safety behavior.
- Keep thermal/NTC safety higher priority than App requests, normal RGB animation, or pending Peltier restart.

## Current Adaptive Fan PWM — V7.1 2°C limit-relative target bands with stepped controller

- Active editable source: `firmware/JEXFYZ-V7.1.ino`, blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`, embedded `FW_VERSION="V7.1"`. V7.1 updates Adaptive 12 V Fan target tiers and bumps filename/version together. The prior V7.0 compile/Online OTA report is USER-REPORTED for V7.0 only; V7.1 has NOT been compiled, installed or physically validated.
- Target selection uses the floored whole-degree category: `temperatureCategoryC = floor(hotsideC)`, `belowLimitC = hotLimit - temperatureCategoryC`. Bands relative to configured `hotLimit`: delta ≤2°C →100%; delta 3–4°C →90%; delta 5–6°C →80%; delta 7–8°C →70%; delta 9–10°C →60%; delta ≥11°C →50%. At a 40°C limit: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29°C →50%. Bands move with the setting, not fixed absolute temperatures.
- PWM changes remain paced: decrease by 10 percentage points after each full 10-second interval and increase by 10 points after each 1-second interval. A direction change starts a fresh clock. Voltage-transition, Adaptive HOTSTEP, thermal dwell and inactive-output conditions reset pacing and preserve full-speed priority.
- Raw-decimal safety remains independent of the target function: `hotsideC >= hotLimit` forces Fan 100% immediately, and the existing safety supervisor turns Peltier OFF. Adaptive at 5 V / 9 V remains Fan 100%. Manual fan behavior, BLE/telemetry, Touch, rail timing and OTA were not intentionally changed.
- NTC still uses one calibrated `analogReadMilliVolts(PIN_NTC)` sample per second; no filter, blocking delay or timing loop was introduced.
- Updated QC contract `test/firmware_qc_contract_test.dart` blob `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync contract `test/firmware_touch_adaptive_sync_test.dart` blob `7c203a11f79de62744af8536bbf2e3219d7f0909`. Static checks were reviewed; contract tests and Arduino compile have NOT RUN for V7.1. No V7.1 BIN, Firebase, OTA, flash or device operation occurred.

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

## HISTORICAL / SUPERSEDED — Adaptive Fan PWM at 12V, V6.7 trend-gating correction

- Adaptive Fan PWM at 12V is automatic only in Adaptive mode. Reaching the configured Hotside limit immediately forces Fan PWM to 100%; Adaptive 5V/9V retain the established 100% Fan behavior.
- Downshift remains conservative: ten fresh one-second NTC samples, every sample and the rolling average at/below `hotLimit - 2°C`, no confirmed warming trend, and one continuous stable 10-second interval. Decrease by 10 percentage points every 10 seconds, with a 50% floor.
- **Correction:** failure to qualify for downshift no longer causes an automatic PWM increase. Upshift requires four consecutive one-second readings spanning at least 0.25°C of warming, with at least two of the three intervals rising. Each confirmed upshift adds 10 percentage points and is limited to one step per 3 seconds. A lone noisy sample or a merely incomplete stable window holds the current PWM.
- NTC acquisition remains one calibrated ADC reading per second. The four-sample trend and ten-sample downshift qualification reuse those readings; there are no extra ADC reads, blocking delays or timing loops. Existing thermal, Peltier, voltage-transition and OTA safety logic retains priority.
Historical source at that time: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`. On 2026-10-18 the user reported V6.7 compiled and was updated online; this remains USER-REPORTED and does not verify the current V6.8 source, BIN provenance, OTA logs or installed version.

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

[HISTORICAL USER-REPORTED — 2026-10-14] The user reported V6.6 was accepted, compiled and updated twice over Online OTA. On 2026-10-17 the user reopened Firmware source work and authorized the earlier V6.7 Adaptive Fan PWM trend-response change, which V6.8 superseded and V6.9 now replaces with timed temperature-tier ramping. The separate V6.7 compile/online-update report was provided on 2026-10-18; it remains USER-REPORTED and does not prove exact source-to-BIN identity or current installed-device behavior.

This is the 2026-10-14 user report, not an assistant-witnessed compile/flash log. Source-to-BIN provenance remains unverified. Previously reported restart symptoms and Adaptive-OFF boot indication remain historical/unverified. The separate request for rapid Hotside-rise shutdown/manual re-arm remains unimplemented; V6.7 added Adaptive Fan PWM trend response; V6.8 replaced it with direct temperature tiers; V6.9 retains those tiers and adds 10-second downsteps/1-second upsteps. Neither version adds a hard rate-of-rise shutdown or manual re-arm. Do not expand into that separate safety feature without explicit scope approval.

[HISTORICAL / SUPERSEDED APP CI EVIDENCE — BUILDS #39/#40, NOT FIRMWARE COMPILE] Builds #39 and #40 ran 80 Flutter tests, including then-current `test/v6_6_qc_contract_test.dart` assertions over V6.6 source. Build #40 compiled/signed the Android APK but stopped before publication at a source-archive path assertion. These historical App CI checks are not an Arduino/ESP32 compile, BIN-provenance validation, physical sensor/thermal test or OTA proof.

No Firmware source, BIN, Firebase metadata, flash or OTA operation was performed in this App-signing task.


## HISTORICAL / SUPERSEDED App CI evidence — Build #65 (later App Build #70; not Firmware compilation)

- App Build #65 / run `38851040144`, exact source `f301c1fbbafa3d6c17803d9a2f50bae390dc1343`, passed Dart analysis, **88/88 Flutter tests** and the native FPS parser JUnit gate, plus Android release/signing and downloaded asset checks. These App tests check source contracts and parser logic; they do not invoke the Arduino/ESP32 compiler or prove physical rail transitions, NTC accuracy, LED behavior, OTA transfer/apply/reboot or installed version.
- The user reports that Firmware V6.6 compiled and completed two same-version Online OTA updates. These remain USER-REPORTED rather than independently witnessed logs. V6.6 is USER-ACCEPTED FINAL; exact source-to-BIN provenance remains UNVERIFIED. No Firmware source was changed and no compile/BIN/Firebase/OTA/flash/device action occurred during this memory reconciliation.
