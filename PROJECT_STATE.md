# JE X FYZ / JE Cooler — Current Project State

Last updated: 2026-10-21 (Asia/Jakarta). This file is current-only state; use `CHANGELOG.md` for historical changes.

## Product and deployed baseline

- **App Build #124:** owner confirms this is the App used by the sold unit.
- **Firmware V7.1:** owner confirms it compiled successfully and was installed by Online OTA.
- **Product status:** sold and shipped; routine physical disassembly/repair is unavailable. Treat future changes as remote-maintenance work with a high bar for firmware/OTA safety.
- These compile/deployment facts are USER-REPORTED. The App release itself is independently evidenced by Actions run `39386733061` and package source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. Repository/App CI does not independently establish exact installed BIN identity, in-field boot/reconnect behavior or thermal/electrical behavior.

## Code and release baseline

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`. Fetch live HEAD and tree each time; do not treat the source SHA packaged in Build #124 as the current docs/source HEAD.
- Active Firmware source: `firmware/JEXFYZ-V7.1.ino`; embedded version `FW_VERSION="V7.1"`. Firmware artifact repository `TenzoNkz/JEXFYZ-Firmware` is BIN-only.
- Build #124 passed 116 Flutter tests and configured App release gates. Analyzer exit was 0 with 25 info-level diagnostics; Android unit-test tasks were NO-SOURCE. APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`, source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.

## Firmware operating contract — do not alter during cleanup

- Adaptive target bands relative to the configured Hotside limit: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%. At 40°C, exact bands are 40/39/38→100%, 37/36→90%, 35/34→80%, 33/32→70%, 31/30→60%, ≤29→50%.
- Raw-decimal protection remains immediate: Fan 100% and Peltier OFF at/above the configured limit. Adaptive ramp up is +10 points/second; down is −10 points/10 seconds; Adaptive 5 V/9 V stays at 100%.
- Maintain NTC one-sample-per-second calibration path, cooperative non-blocking loop, Touch/P1 behavior, Peltier/selector/rail timing, BLE/radio ownership, safe OTA outputs and failure/recovery logic.

## OTA and remote-maintenance policy

- Baseline is frozen for discretionary functional work. Prefer no release unless it fixes a concrete problem or is required for maintenance.
- Do not casually modify Local/Online OTA, redirects, allowlists, size/image checks, timeouts, Update lifecycle, restart or BLE-recovery logic. The current Online OTA path uses `cloudClient.setInsecure()`, which does not authenticate server certificate identity; retain the current chosen trade-off unless a specific authorized redesign is evaluated.
- App-only changes can still affect BLE, OTA command sequencing, URL/version handling, reconnect behavior and update UX. They require source review and the required App validation/release authorization.
- An App Build command does not authorize Firmware compilation/BIN publication, Firebase changes, OTA, flash or device operations. `@Thinking Eksekusi Full!` does not authorize the App Build pipeline.

## Current known blockers / evidence boundaries

- BLE App-only authorization is BLOCKED / NOT IMPLEMENTED: trusted backend enrollment/signing is missing. Encrypted/bonded BLE writes and `SYNC_READY` do not prove official App identity.
- Owner confirms V7.1 compile and successful Online OTA to the sold unit, but exact BIN-to-source provenance, independent installed-version query, physical reboot/BLE recovery and long-run thermal behavior are not independently observable from the repository.
- Do not claim a physical reset cause without `BOOT: RESET_REASON=...` or equivalent evidence. Hotside rate-of-rise protection remains an unimplemented historic requirement unless live source shows otherwise.

## Memory and handoff protocol

- `CHAT_TRANSFER.md` is a rolling checkpoint, not a long transcript recap. Keep it accurate and update it after a substantive Discussion concludes and after each execution completes/blocks.
- General/Discussion context limit: Prompt B in `CHAT_TRANSFER_PROMPTS.md` loads live state then continues without a recap stage. Build App context limit: Prompt D loads build state and `APP_BUILD_REPORT.md`, then continues the same authorized operation.
- Prompt A is reserved for explicit full-memory reconciliation. If interrupted before a checkpoint write, recover from the last saved point and verify live evidence; do not pretend unsaved content was saved.
