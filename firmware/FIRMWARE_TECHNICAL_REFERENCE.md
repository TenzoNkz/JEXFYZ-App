# JE X FYZ — Firmware Technical Reference

Last source/safety-reference reconciliation: 2026-10-20 (Asia/Jakarta). Latest successful App artifact is Build #113 / run 39350217172, package source 05e4f644d6bf82ae2682154082c3e44a4876205a. The newer Home-layout/thermal-layer App follow-up is not validated/released. App CI does not prove Firmware compilation, BIN provenance or physical OTA/safety behavior.

## Current source identity

- Canonical editable source: firmware/JEXFYZ-V6.9.ino, blob 8e0f0ff5a65962ebdb44300b05fc161cf9349d96, embedded FW_VERSION=V6.9.
- Compile/install status: USER-REPORTED. The user says latest Firmware was compiled and installed. Independent logs, source-to-BIN relationship, installed device version and physical PWM/thermal behavior remain UNVERIFIED. Recorded Firmware contract tests have not run for V6.9.
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module, Arduino-ESP32 Core 3.3.7. Firmware compiles separately from App release.

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

## Current Adaptive Fan PWM at 12V — V6.9 paced temperature-tier ramp

- Target tiers use the floored whole-degree category, `temperatureCategoryC = floor(hotsideC)`, then the integer distance `belowLimitC = hotLimit - temperatureCategoryC`: ≤1 →100%; ≤2 →90%; ≤3 →80%; ≤4 →70%; ≤5 →60%; ≥6 →50%. For a 40°C limit, 36.0–36.99°C stays at 70%, and target 80% begins at category 37. This prevents 36.3°C →36.8°C from changing the target. The immediate protection override remains based on the unrounded reading (`hotsideC >= hotLimit`) and still forces 100% without delay.
- Actual PWM approaches the target in 10-point steps: decreasing waits 10,000 ms before each step; increasing waits 1,000 ms before each step. When direction changes, the clock starts for the new direction rather than allowing a stale timer to cause a step immediately.
- `voltageTransition`, Adaptive hot-step transition, thermal dwell and non-running output conditions reset the clock and preserve the full-speed priority. A 9 V → 12 V transition therefore remains at 100% through the handoff, then waits at least 10 seconds before the first reduction. Subsequent reductions happen no faster than one step per 10 seconds.
- Active Hotside protection or `hotsideC >= hotLimit` forces 100% immediately. Adaptive 5 V/9 V remains 100%; the normal safety controller remains authoritative.
- NTC acquisition remains one calibrated sample per second. No blocking delay, extra ADC read, averaging/filter, or timing loop was added.
- Current source is `firmware/JEXFYZ-V6.9.ino` blob `b35101a0cc5a597c55ecd4391cd99d5b62852417`; `test/firmware_qc_contract_test.dart` blob is `29325173289d78041002df41cc14262fcf89e045`. The source adds whole-degree target selection while retaining exact-decimal safety override and 10-second down/1-second up ramp cadence. Tests and Arduino compile have NOT RUN for this revision. The previous V6.9 compile/install was user-reported before this source change; this exact hash is not confirmed installed. The hardware-reset symptom remains unverified.

## HISTORICAL / SUPERSEDED — V6.8 direct temperature-tier controller

- V6.8 selected the same six temperature tiers directly, with no time-based pacing. The immediate 100% → 50% change after a 9 V → 12 V handoff is the abrupt step that V6.9 is intended to avoid. V6.8 source is no longer the active versioned sketch.
## HISTORICAL / SUPERSEDED — V6.7 Adaptive Fan trend-gating correction

- V6.7 required ten samples and a stable downshift period, and used a four-sample warming-trend gate for upshifts. Those rules are superseded by the V6.8 direct tier selector above. V6.7 compile/online-update remains historical user-reported evidence and does not validate V6.9.

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

**HISTORICAL App source-contract evidence:** Build #35 / run `38669526891` on commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8` passed Dart analyze and 74 Flutter tests including earlier V6.6 source assertions; that proves only those older App/test gates.

**LATER App source-contract evidence:** Build #39 and #40 each passed 80 Flutter tests, including `test/v6_6_qc_contract_test.dart` which reads the V6.6 source. Build #40 also passed Android APK compilation and signing before source-archive validation stopped publication. Neither result is an Arduino/ESP32 Firmware compile or physical OTA proof. V6.6 compile/two same-version Online OTA successes remain USER-REPORTED; independent logs, installed version, physical behavior and source-to-BIN provenance remain unverified.

## Static versus runtime validation

Static source assertions and file/blob checks can verify paths, constants and ordering. They cannot certify Arduino compilation, electrical stability, real NTC accuracy, LEDs, cooling, safety response, BLE pairing, full OTA apply or reboot. Record each validation gate separately.


## HISTORICAL / SUPERSEDED App CI boundary — Build #65 (2026-10-16), not Firmware compile proof

App Build #65 / run 38851040144 historically passed 88 Flutter tests plus the native FPS parser JUnit gate. Later Build #70 verified the App's FPS-retirement source (86/86 Flutter tests, native JUnit tasks NO-SOURCE); neither run is a Firmware compile. App source-contract checks over the active versioned sketch do not compile the Arduino/ESP32 sketch, prove source-to-BIN provenance, or prove physical safety/OTA behavior. V6.6 compile/two-same-version Online OTA statements are historical USER-REPORTED evidence. The user reported V6.7 compiled and was updated online on 2026-10-18; this is USER-REPORTED. The compile log, BIN identity, source-to-BIN provenance, OTA apply/reboot logs and current installed-device version remain UNVERIFIED. No firmware source/BIN, Firebase, OTA, flash or device operation occurred during this App build.
