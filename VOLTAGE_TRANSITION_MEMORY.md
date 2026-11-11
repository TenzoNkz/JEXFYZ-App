# JE X FYZ / JE Cooler — Voltage Transition & Peltier Soft-Start Contract

Last reconciled: 2026-10-23 (Asia/Jakarta). This is the current rail/transition contract plus two user-reported incidents. Current source is authoritative if the source changes.

## Current source and evidence

- Active Firmware source: firmware/JEXFYZ-V7.2.ino, FW_VERSION="V7.2", blob 140e758e7101cadc3ccc58cc5c52e49534b0032c.
- The V7.1 owner-reported compile/Online OTA is historical; it does not validate V7.2. The existing voltage-transition/Peltier soft-start contract below remains required.
- V7.2 adds a persistent V5 lock. Lock ON retargets an in-flight transition to V5 without resetting voltageTransitionAt, rechecks the lock before selector assertion and keeps the loop enforcing a V5 endpoint. The lock command does not manipulate selector GPIO directly.
- V7.2 source was not compiled, and no BIN/Firebase/OTA/flash/device operation or physical power/rail test was performed.

## Two separate restart reports

1. USER-REPORTED, 2026-10-13: a reset during Manual 5 V→12 V while Peltier and Fan were ON and the 5-second Peltier ramp was active. No reset-reason log was supplied. Supply transient/brownout is a hypothesis, not a verified cause.
2. USER-REPORTED, earlier separate incident: reset when enabling Adaptive after selecting 12 V and switching Peltier/Fan ON. Reset reason unavailable. Do not assume this shares the first incident's root cause.

Capture Serial or BLE diagnostics BOOT: RESET_REASON=... if a future authorized reproduction is possible. Do not diagnose a brownout from symptoms alone.

## Accepted voltage-transition contract

- If Peltier is logically OFF, changing the voltage must not enable it.
- If Peltier is ON and peltierSoftStarting is true when a normal Manual Volt or Adaptive voltage transition is accepted, save the interrupted-ramp state and force GPIO5 PWM to 0% before selector outputs change.
- Preserve 200 ms break-before-make and the existing 1,000 ms voltage settle/guard. After the guard, only a captured interrupted ramp starts a fresh full 5,000 ms ramp from 0%.
- If the soft-start has already completed and PWM is at 100%, do not force 0% or re-ramp. Maintain full PWM continuously through the rail transition unless OFF/safety/OTA requires shutdown.
- Fan stays ON/100% during the handoff.
- Explicit Peltier-OFF, Hotside/NTC safety and OTA safe-output cancel all pending pause/resume state. A saved ramp must never restart after an overriding shutdown. An explicit Peltier-OFF during Adaptive-stop also clears adaptiveStopRestorePeltier.
- Adaptive entry/exit performs the established safe-5V selector handoff without forcing a redundant Peltier OFF→ON cycle. The shared transition helper pauses only an active soft-start; a completed ramp remains at 100%; a Peltier already OFF remains OFF.
- Maintain cooperative/non-blocking millis() timing. Do not add executable delay() or timing while().

## Static source-contract expectations

For a future authorized transition change, inspect the live source and tests and preserve:
- request acceptance before pause helper; pause helper before selector output shutdown;
- no PWM write or pause state when peltierSoftStarting is false;
- active ramp's resume flag is saved before clearing ramp state and forcing PWM 0%;
- during voltageTransition, 0% is forced only when peltierVoltagePauseActive;
- after settle, a new five-second ramp starts only for the captured interrupted ramp;
- completed ramp remains at full duty;
- stopPeltierOutput clears pause/resume state;
- reset-reason reporting includes BOOT: RESET_REASON=... and the source-defined RESET_REASON telemetry.

## Separate safety contract

This file concerns rail transitions. Hotside/NTC thermal safety and OTA override the saved ramp state and always retain priority. The rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm request is a different feature, NOT IMPLEMENTED in V7.1; see FIRMWARE_NOTES.md. Do not combine unrelated requirements into a voltage-transition refactor.

## Hardware validation plan — not performed by source review

1. During an active soft-start, change rail and observe 0% → 200 ms selector deadtime → 1 s guard → new 5 s ramp.
2. After full duty has been reached, change rail and verify continuous full PWM without forced pause/re-ramp.
3. Repeat Adaptive entry/exit during active and completed ramps.
4. Confirm Fan stays on/100% through transition.
5. Confirm explicit OFF, Hotside/NTC safety and OTA safe-output cancel pending resume.
6. If reset recurs, capture reset reason/telemetry and, when possible, supply voltage/Peltier current. Keep the two incidents separate.
7. Run thermal, Manual/Adaptive, Local OTA and Online OTA gates separately. App CI does not prove any of them.
## V7.2 Lock Voltage transition interaction

- Lock ON uses the same 200ms selector break-before-make and 1,000ms voltage settle/guard. If a transition is already active, only pendingVoltage is redirected to V5; voltageTransitionAt is not reset.
- If no transition is active and the rail is above V5, Lock ON requests V5 through requestVoltage(V5, SAFETY, true). Existing active-soft-start pause/resume and completed-ramp continuity remain authoritative.
- completeVoltageTransition() rechecks voltageLockActive immediately before selector GPIO assertion. The main scheduler requests V5 again if Lock is active and the applied rail is not V5.
- Enabling Lock forces Adaptive OFF. Unlock does not automatically restore Adaptive or the prior rail. Actual VOLTAGE telemetry reports handoff separately from Lock ACK.
- Source contracts were added but NOT RUN. Physical active-soft-start, completed-ramp, selector, settle-guard, NTC/Hotside priority, power-cycle and NVS-failure tests remain outstanding.

## Independent Gemini review cross-check — 2026-11-12

- Gemini's P0 claim that setting `voltageLockActive = true` before calling `setAdaptiveState(false)` blocks the safe 5V handoff is **not supported by the live source**. `forceAdaptiveFiveVolt()` redirects an existing transition to `pendingVoltage = V5`; otherwise it calls `requestVoltage(V5, VoltageRequestSource::ADAPTIVE, true)`. The central lock gate rejects only targets other than V5. The caller then reasserts the pending V5 target and SAFETY source. No source path shown makes the lock reject its own 5V handoff.
- When the transition reaches 5V, `adaptiveStopPending` completes. A previously ON Peltier request may be restored after that 5V selector commit; `adaptiveOn` remains false and is not automatically restored. This is distinct from restoring Adaptive.
- **Useful missing regression cases:** activate Lock during an existing 9V/12V selector deadtime, and activate Lock while Adaptive is ON at 9V/12V with Peltier OFF, active soft-start, and completed ramp variants. Verify pending target ends at V5, the original 200ms timestamp is retained, Adaptive remains OFF, and the accepted Peltier/soft-start contract is preserved. Existing Dart contracts are static source checks, not MCU state-machine simulation.
- H4's proposed 10-second power-cut window is not applicable to Lock: `vLock5V` is written immediately and read back, independently of the shared settings debounce. A reboot test must distinguish a completed OFF write from power loss during the write and assert the recovered persisted state rather than assume OFF.
- H5 must follow the actual safety indicator state machine. NTC/Hotside preemption must cancel the rejection flash and preserve safe outputs; the pasted excerpts do not guarantee one universal red thermal blink for every invalid-NTC condition.
- This review was source-only. No test, Firmware compile, BIN, power-cycle, rail, Touch, LED or device operation was performed.