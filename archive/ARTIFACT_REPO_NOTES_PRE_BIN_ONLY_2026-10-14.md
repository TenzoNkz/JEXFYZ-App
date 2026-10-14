# Legacy artifact-repository notes before BIN-only cleanup

Verbatim content fetched from `TenzoNkz/JEXFYZ-Firmware` at commit `6f0dd8582bafa639e46e29d9c474aba8f4569622` before its documentation files were removed. This archive is for evidence/history only; canonical current notes now live in `TenzoNkz/JEXFYZ-App`. Do not use the copied repo-policy statements to override the user's final decision: the artifact repo must contain only `JEXFYZ.cpp.bin`.

---

## `README.md`

Original blob: `ac89c7a90b77a7831478e4caeae59ea650857bd1`; purpose: Artifact BIN provenance and prior repo policy.

`````markdown
# JE X FYZ Firmware Artifact Repository

This repository serves the firmware binary used for JE X FYZ / JE Cooler Online OTA. The deployable artifact path is `JEXFYZ.cpp.bin`.

## Source-of-truth boundary

- Canonical editable firmware source and QC/test contracts live in [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App), notably [`firmware/JEXFYZ-V6.4.ino`](https://github.com/TenzoNkz/JEXFYZ-App/blob/main/firmware/JEXFYZ-V6.4.ino).
- This repository's `JEXFYZ.cpp.bin` is a binary artifact, not the editable source. An upload timestamp alone does not establish which exact source blob or compile configuration produced it.
- The latest observed BIN upload in the repository history is commit [`b345637acfdbd3f80ae6159a14cc09ddbc05f934`](https://github.com/TenzoNkz/JEXFYZ-Firmware/commit/b345637acfdbd3f80ae6159a14cc09ddbc05f934), which changes `JEXFYZ.cpp.bin`. Its source-blob/build provenance has not been independently verified in this record. Do not assume it necessarily corresponds to the current V6.4 source without matching provenance.
- This documentation update does not replace, rebuild, or modify the existing BIN.

## Online OTA connection regression memory

V6.3 source was restored to the previously working `cloudClient.setInsecure()` path after the CA certificate validation and OTA-only NTP time-sync gate were associated with a user-reported GitHub connection failure. The user reports that V6.3 then compiled successfully and Online OTA could connect to GitHub again. This is user-reported; full BIN transfer, installation, reboot, and post-reboot version confirmation are not independently proven by this repository change.

Read the canonical [OTA Regression Memory in the source repository](https://github.com/TenzoNkz/JEXFYZ-App/blob/main/OTA_REGRESSION_MEMORY.md) before changing or publishing OTA firmware.

## Voltage transition / Peltier soft-start regression memory

The active V6.4 source pauses Peltier PWM at 0% only when a voltage change interrupts an in-progress 5-second soft-start, preserves the existing 200 ms break-before-make interval, and waits the existing 1-second voltage guard before restarting a fresh 5-second ramp. If soft-start had already completed, Peltier PWM remains at 100% throughout the voltage transition; it is not deliberately turned OFF unless a Peltier-OFF command or safety protection requires it. The current V6.4 source revision has not been compiled or hardware-validated in the assistant's workflow. See the [canonical source memory](https://github.com/TenzoNkz/JEXFYZ-App/blob/main/VOLTAGE_TRANSITION_MEMORY.md) and the [mirrored artifact-repository note](VOLTAGE_TRANSITION_MEMORY.md). This documentation-only update does not modify the BIN.

## Release guardrails

- Do not replace/publish `JEXFYZ.cpp.bin`, change Firebase/production metadata, flash a device, or perform a release without explicit authorization.
- Keep the raw GitHub BIN URL allowlist, redirect blocking, image/size checks, safe outputs, OTA recovery, and radio handoff intact.
- `setInsecure()` keeps TLS encryption but skips server certificate identity validation. URL allowlisting does not replace cryptographic server authentication.
- Build/test/release claims must be labeled accurately. A source contract test is not proof that a test was executed; a successful compile is not proof of successful end-to-end OTA installation.

`````

---

## `OTA_REGRESSION_MEMORY.md`

Original blob: `3b9d5a092a81bb96907b96c9df52df35306aa31d`; purpose: Mirrored OTA incident record before consolidation.

`````markdown
# JE X FYZ — Online OTA Regression Memory (Artifact Repository)

Updated: 2026-10-14 (Asia/Jakarta)

This repository primarily stores the OTA binary, not editable firmware source. The active editable source is now `firmware/JEXFYZ-V6.4.ino` in [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App); the V6.3 references below describe the historical revision where the Online OTA correction was first applied. The full engineering incident log is in [TenzoNkz/JEXFYZ-App / OTA_REGRESSION_MEMORY.md](https://github.com/TenzoNkz/JEXFYZ-App/blob/main/OTA_REGRESSION_MEMORY.md).

Related electrical/selector restart issue is tracked separately in [VOLTAGE_TRANSITION_MEMORY.md](https://github.com/TenzoNkz/JEXFYZ-App/blob/main/VOLTAGE_TRANSITION_MEMORY.md).

## Incident record

- User reported that V6.3 connected to Wi-Fi (blue indicator) then showed red at the GitHub connection stage after a change to CA-based HTTPS validation.
- Source at the time contained an embedded ISRG Root X1 certificate applied with `cloudClient.setCACert(GITHUB_ROOT_CA)`, plus an OTA-only NTP time-sync gate (`configTime()`, `TIME_SYNCING`, 20-second timeout).
- Source was restored to `cloudClient.setInsecure()`; the CA PEM and OTA-only NTP gate were removed. Blue Wi-Fi feedback now precedes the GitHub GET attempt.
- [HISTORICAL USER REPORT] User reported the corrected V6.3 revision compiled successfully and Online OTA could connect to GitHub again. This does not validate V6.4 or prove that the repository BIN matches its source.
- Do not claim an independently reproduced build or end-to-end OTA completion from this note. A full transfer, `Update.end()`, successful restart, and confirmation of the installed version need separate evidence.
- The change removed CA validation and the NTP gate together, so available evidence does not isolate either as the sole cause. The user attributes the failure to the CA addition; preserve that as the user's conclusion, not as a single-variable controlled experiment.

## Required guardrails

1. Do not reintroduce a custom CA, certificate pinning, `setCACert()`, or OTA-only NTP/TLS-time gate without discussion and explicit user authorization.
2. Keep raw GitHub BIN URL allowlisting, redirect blocking, file-length/size validation, ESP image magic-byte validation, streaming update lifecycle, safe outputs, radio handoff, and failure recovery intact.
3. `setInsecure()` does not authenticate the TLS peer certificate. URL allowlisting alone is not cryptographic proof of server identity.
4. Do not change `JEXFYZ.cpp.bin`, Firebase/production release metadata, or release state unless explicitly authorized.
5. A binary upload timestamp is not proof that the file matches the active source blob. Record source commit/blob, toolchain, compile result, and artifact checksum when a future build/release is authorized.

## Artifact checkpoint

- Latest observed BIN upload commit at the time of this record: [`b345637acfdbd3f80ae6159a14cc09ddbc05f934`](https://github.com/TenzoNkz/JEXFYZ-Firmware/commit/b345637acfdbd3f80ae6159a14cc09ddbc05f934).
- The artifact was not modified by the documentation update.
- Source-to-BIN correspondence is not independently confirmed in this note.

`````

---

## `VOLTAGE_TRANSITION_MEMORY.md`

Original blob: `a63eb7c83062b4185f436ca3cf02cdb171a37d1b`; purpose: Mirrored rail-transition contract before consolidation.

`````markdown
# JE X FYZ / JE Cooler — Voltage Transition & Peltier Soft-Start Memory

Updated: 2026-10-14 (Asia/Jakarta)
Status: Active-ramp-only pause and uninterrupted 100% Peltier duty implemented in V6.4 source; compile/test/runtime/hardware result not yet validated for this revision.
Active source blob: `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`.
Regression contract blob: `f071c9642c1a06726d25b8c26a814845b02a55d6`.

## Incident report

[USER-REPORTED — 2026-10-13] The physical hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON while the 5-second Peltier soft-start was still active. The exact reset reason from that reproduction has not been supplied. A supply transient/brownout remains a plausible hypothesis, not a confirmed cause.

## Current transition contract

This rule applies to normal voltage changes requested in Manual Volt and while Adaptive is active. It is based on the Peltier ramp state **when the voltage transition is accepted**:

1. If Peltier is logically ON and `peltierSoftStarting` is true, save that state and force physical GPIO5 PWM to 0% before selector outputs are de-asserted. Preserve the logical ON request so the App does not report a false OFF. If soft-start has already completed, do not write PWM 0%—keep physical Peltier PWM at 100% throughout the selector transition. Fan remains enabled and is forced to 100%.
2. Keep the existing 200 ms break-before-make selector interval.
3. For a paused in-progress ramp only, retain the existing 1,000 ms rail-settle wait through `PELTIER_VOLTAGE_SETTLE_MS = VOLTAGE_GUARD_MS`. A completed 100% ramp is not paused and needs no Peltier-resume wait.
4. If the saved flag says the 5-second soft-start was still in progress, begin a **new full 5-second ramp from 0%** after settling.
5. If the saved flag indicates soft-start had already completed, keep **100% PWM running continuously** through the transition; do not pause Peltier, force 0%, or add another 5-second ramp.
6. If Peltier is OFF, do not enable it because of a voltage change. If an explicit Peltier-OFF request, thermal/sensor safety, or OTA safe-output path stops it during the transition, clear the saved resume state so it cannot restart automatically.
7. Adaptive entry/exit remains its separate safe-5V mode handoff: it intentionally switches Peltier OFF and, when allowed, restores it through the normal OFF→ON 5-second soft-start. Adaptive's subsequent ordinary rail changes use the conditional rule above. Adaptive thermal HOTSTEP safety may deliberately force Peltier OFF and must take priority.
8. The transition remains cooperative/non-blocking; no `delay()` or timing `while()` is introduced.

## Timing contract

- Selector break-before-make: 200 ms.
- Paused in-progress ramp: remain at 0% through the 1,000 ms post-selector settle, then start a fresh 5,000 ms soft-start.
- Already-completed ramp: maintain 100% PWM throughout selector deadtime and completion, unless OFF/safety forces shutdown.
- The 1-second interval is an existing software guard, not laboratory proof of the rail's electrical settling time. Hardware validation remains required.

## Regression safeguards

- In `requestVoltage()`, accepted transition state is recorded before `pausePeltierForVoltageTransition()`; the pause must happen before selector outputs are switched OFF.
- `pausePeltierForVoltageTransition()` must return without writing PWM or setting a pending pause when `peltierSoftStarting` is false; that state means the normal ramp has completed and the Peltier should remain at 100%.
- If `peltierSoftStarting` is true, save the interrupted-ramp flag before clearing the active ramp and forcing PWM to 0%.
- While `voltageTransition` is active, Peltier processing must only hold PWM at 0% when `peltierVoltagePauseActive` is true. A completed ramp must not be zeroed by the transition gate.
- After `PELTIER_VOLTAGE_SETTLE_MS`, resume only the captured in-progress ramp with a fresh 5 s soft-start; the completed-ramp path remains at 100% throughout and has no pending resume.
- `stopPeltierOutput()` must clear both pending pause and saved-resume state.
- Preserve the 200 ms deadtime, 1-second guard, 5-second OFF→ON soft-start, Hotside/sensor safety latches, safe output path, and cooperative main loop.
- Keep serial boot diagnostics and App `RESET_REASON` telemetry for `BROWNOUT`. If the hardware restarts again, record `BOOT: RESET_REASON=...` and the App telemetry before drawing a stronger root-cause conclusion.

## Validation status and release boundary

- [SOURCE FIX IMPLEMENTED] V6.4 pauses Peltier only when a voltage transition interrupts an active ramp; already-completed soft-start keeps PWM at 100% through the voltage change.
- [REGRESSION CONTRACT UPDATED — NOT RUN] The static Flutter test contract checks state capture, ordering, both resumption paths, stop-state cleanup, timing, and reset-reason diagnostics.
- [STATIC REVIEW ONLY] No firmware compile, Dart/Flutter test, physical reproduction, supply/current measurement, thermal regression, or repeated Manual/Adaptive rail test has been performed for this revision.
- The earlier user-reported compile result applied to a prior V6.3 revision and does not certify the current source.
- No BIN was generated or published, no Firebase metadata was changed, and no device was flashed or OTA-updated by this change.

## Future-change rule

Do not unconditionally pause Peltier on every voltage change, restart soft-start after it had completed, or bypass Peltier-OFF/safety cancellation. Any transition timing or behavior change must update the source-level contract and this memory first. Reset causality remains a hypothesis until real diagnostics and, ideally, supply/Peltier current measurements support it.

`````

