# JE X FYZ / JE Cooler — Voltage Transition & Peltier Soft-Start Memory

Last reconciled: 2026-10-20 (Asia/Jakarta).
Canonical active source: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`. V6.9 retains temperature target tiers and paces Adaptive 12 V PWM by 10-point steps (down every 10 seconds, up every 1 second); the step clock resets during rail transitions and thermal dwell. V6.9 is NOT COMPILED / NOT INSTALLED; source-to-BIN provenance and current device version remain UNVERIFIED. V6.7 compile/online update is historical USER-REPORTED evidence.
Static regression contract: `test/firmware_qc_contract_test.dart` blob `1b35feeb1e411efec44261ec130eec4535004454`; Touch/Adaptive sync contract `test/firmware_touch_adaptive_sync_test.dart` blob `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8`. Both are NOT RUN for V6.9.

**App-side validation evidence:** Build #83 / run `39192430789` passed 96/96 Flutter tests and the App release gates for source `dfc7e6633298498bb6eac21182c9306d5e3cac1d`; the Release handoff is blocked by a stale Git tag, and this App run does not prove Firmware compilation, source-to-BIN provenance or physical rail-transition behavior. The user's V6.7 compile/online-update success remains historical USER-REPORTED evidence; V6.9 is not compiled. Physical transition reproduction, current measurement, and end-to-end thermal/OTA behavior remain unverified.

## Incident

[USER-REPORTED — 2026-10-13] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON while the 5-second Peltier soft-start was still active. No exact reset reason from that reproduction was supplied. Supply transient/brownout is a hypothesis, not a confirmed cause.

[USER-REPORTED — EARLIER SEPARATE INCIDENT; RESET REASON UNAVAILABLE] The hardware was also reported to restart when Adaptive was enabled after selecting 12 V and turning Peltier and Fan ON. Do not assume this is the same root cause as the 5 V→12 V active-soft-start incident. The V6.7 source retains a safe-5V selector handoff without forcing Peltier OFF solely for that handoff; physical reproduction and reset-reason capture remain open.

## Current V6.7 transition contract

Applies to normal voltage changes requested in Manual Volt and while Adaptive is active. Branch behavior is based on Peltier ramp state when a voltage transition is accepted.

1. If Peltier is logically OFF, voltage change must not enable it.
2. If Peltier is logically ON and `peltierSoftStarting == true`, save the interrupted-ramp state and force GPIO5 PWM to 0% **before selector outputs are switched off**. Preserve logical Peltier-ON state to avoid false App OFF telemetry.
3. Keep selector break-before-make at 200 ms.
4. For the interrupted ramp only, keep GPIO5 at 0% through the existing 1,000 ms rail-settle guard (`PELTIER_VOLTAGE_SETTLE_MS`, alias of `VOLTAGE_GUARD_MS`), then start a new full 5,000 ms ramp from 0%.
5. If soft-start has already completed and PWM is at 100%, do not write PWM 0%; keep 100% continuously through selector deadtime and transition completion. No unnecessary re-ramp.
6. Fan remains ON/forced to 100% through the voltage handoff.
7. Explicit Peltier-OFF, Hotside/NTC safety, or OTA safe-output must shut down Peltier and clear any pending pause/resume flags; a saved ramp must never restart after an overriding OFF/safety action. If a user explicitly turns Peltier OFF during Adaptive-stop handoff, also clear `adaptiveStopRestorePeltier` so handoff completion cannot turn it back ON.
8. Adaptive entry/exit still returns the selector to safe 5 V, but must preserve the logical Peltier-ON state through the handoff. `requestVoltage()` uses the existing pause helper: only an active soft-start is paused and restarted after the 1-second settle; a completed ramp stays at 100%. A Peltier already OFF stays OFF, and explicit OFF/Hotside/NTC/OTA safety can override.
9. Keep cooperative/non-blocking timing. Do not introduce executable `delay()` or timing `while()`.

## Static regression expectations

- In `requestVoltage()`, transition acceptance is recorded before `pausePeltierForVoltageTransition()`; pause precedes selector output shutdown.
- `pausePeltierForVoltageTransition()` returns without writing PWM or setting pause state when `peltierSoftStarting` is false.
- Active-ramp path records the resume flag before clearing active soft-start and forcing PWM 0%.
- During `voltageTransition`, the control path forces 0% only if `peltierVoltagePauseActive` is true.
- After settle, only a captured interrupted ramp starts a fresh 5-second ramp.
- Completed ramp keeps `ledcWrite(PIN_PELTIER, 255)` / 100% continuously.
- `stopPeltierOutput()` clears both pending pause and saved-resume state.
- Retain reset reason reporting, including `ESP_RST_BROWNOUT`, Serial `BOOT: RESET_REASON=...` and telemetry `RESET_REASON`.

Historical clarification: the contract was not yet executed when first written on 2026-10-15. Build #62 and later App tests exercised source contracts; Build #83 is the latest successful App artifact run, though the Release tag mismatch remains unresolved. No App run proves Firmware compilation or physical behavior.

## Hardware validation plan

1. Preserve the user's report that V6.6 compiled with ArduinoDroid + Arduino-ESP32 Core 3.3.7; confirm the actual compile log and source-to-BIN version provenance before publication/OTA. Do not recompile solely for App-only UI edits.
2. Manual Volt: during an active ramp, switch rail and confirm 0% → 200 ms selector deadtime → existing 1-second settle → fresh 5-second ramp.
3. Manual Volt: after ramp reaches 100%, switch rail and confirm Peltier remains continuously active at 100%; no forced pause or extra ramp.
4. Adaptive ON and OFF: repeat during active soft-start (0% pause, 200 ms deadtime, 1-second settle, fresh 5-second ramp) and after ramp completion (continuous 100%); confirm no additional Adaptive-specific OFF/ON cycle under normal conditions.
5. Verify Fan stays on/100% through handoff.
6. Verify explicit OFF, NTC/Hotside safety and OTA safe output cancel resume.
7. If reset recurs, record `BOOT: RESET_REASON=...` and diagnostic telemetry. A rail transient hypothesis needs evidence; ideally measure supply voltage and Peltier current.
8. Run thermal, Manual/Adaptive, Local OTA and Online OTA regression separately; don't conflate the gates.

## Future-change rule

Do not unconditionally pause Peltier on every voltage change, restart soft-start after it has completed, enable Peltier when it was OFF, or bypass safety cancellation. Any authorized change to transition timing/behavior must update source-level test contracts and this memory. All project memories belong in the App repository; the separate Firmware artifact repository must contain only `JEXFYZ.cpp.bin`.
