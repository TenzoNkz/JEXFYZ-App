# JE X FYZ / JE Cooler — Voltage Transition & Peltier Soft-Start Memory

Last reconciled: 2026-10-14 (Asia/Jakarta).
Canonical source: `firmware/JEXFYZ-V6.4.ino` (last observed blob `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`).
Static regression contract: `test/v6_4_qc_contract_test.dart` (last observed blob `f071c9642c1a06726d25b8c26a814845b02a55d6`).
Validation state: source-only. Firmware compile, Flutter test execution, physical reproduction, current measurement and thermal/OTA regression remain unverified.

## Incident

[USER-REPORTED — 2026-10-13] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON while the 5-second Peltier soft-start was still active. No exact reset reason from that reproduction was supplied. Supply transient/brownout is a hypothesis, not a confirmed cause.

## Current V6.4 transition contract

Applies to normal voltage changes requested in Manual Volt and while Adaptive is active. Branch behavior is based on Peltier ramp state when a voltage transition is accepted.

1. If Peltier is logically OFF, voltage change must not enable it.
2. If Peltier is logically ON and `peltierSoftStarting == true`, save the interrupted-ramp state and force GPIO5 PWM to 0% **before selector outputs are switched off**. Preserve logical Peltier-ON state to avoid false App OFF telemetry.
3. Keep selector break-before-make at 200 ms.
4. For the interrupted ramp only, keep GPIO5 at 0% through the existing 1,000 ms rail-settle guard (`PELTIER_VOLTAGE_SETTLE_MS`, alias of `VOLTAGE_GUARD_MS`), then start a new full 5,000 ms ramp from 0%.
5. If soft-start has already completed and PWM is at 100%, do not write PWM 0%; keep 100% continuously through selector deadtime and transition completion. No unnecessary re-ramp.
6. Fan remains ON/forced to 100% through the voltage handoff.
7. Explicit Peltier-OFF, Hotside/NTC safety, or OTA safe-output must shut down Peltier and clear any pending pause/resume flags; a saved ramp must never restart after an overriding OFF/safety action.
8. Adaptive entry/exit is its own safe-5V handoff: Peltier intentionally OFF before switching and, if it had been on and safety permits, restored only through the ordinary 5-second OFF→ON ramp.
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

The static test contract exists but was **not executed** as part of this memory update. Do not call its presence a pass.

## Hardware validation plan

1. Compile the V6.4 source yourself with ArduinoDroid + Arduino-ESP32 Core 3.3.7.
2. Manual Volt: during an active ramp, switch rail and confirm 0% → 200 ms selector deadtime → existing 1-second settle → fresh 5-second ramp.
3. Manual Volt: after ramp reaches 100%, switch rail and confirm Peltier remains continuously active at 100%; no forced pause or extra ramp.
4. Repeat both cases in Adaptive under safe operating conditions.
5. Verify Fan stays on/100% through handoff.
6. Verify explicit OFF, NTC/Hotside safety and OTA safe output cancel resume.
7. If reset recurs, record `BOOT: RESET_REASON=...` and diagnostic telemetry. A rail transient hypothesis needs evidence; ideally measure supply voltage and Peltier current.
8. Run thermal, Manual/Adaptive, Local OTA and Online OTA regression separately; don't conflate the gates.

## Future-change rule

Do not unconditionally pause Peltier on every voltage change, restart soft-start after it has completed, enable Peltier when it was OFF, or bypass safety cancellation. Any authorized change to transition timing/behavior must update source-level test contracts and this memory. All project memories belong in the App repository; the separate Firmware artifact repository must contain only `JEXFYZ.cpp.bin`.
