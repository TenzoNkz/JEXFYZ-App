# JE X FYZ / JE Cooler — Voltage Transition & Peltier Soft-Start Contract

Last reconciled: 2026-10-23 (Asia/Jakarta). This is the current rail/transition contract plus two user-reported incidents. Current source is authoritative if the source changes.

## Current source and evidence

- Active Firmware: firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", live blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- V7.1's described change is Adaptive Fan target tiers; the preserved voltage-transition / Peltier soft-start contract below remains the project invariant.
- Owner reports V7.1 compiled and installed via Online OTA. This is USER-REPORTED; exact BIN identity, physical reboot, BLE recovery and rail/current behavior remain independently UNVERIFIED.
- No Firmware compilation, BIN/Firebase change, OTA, flash or device operation was performed in this docs rework.

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

