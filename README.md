# JE X FYZ / JE Cooler App

Flutter Android companion app for the JE X FYZ thermoelectric cooler, paired with the ESP32-C3 firmware.

## Start here

1. [Memory Index](MEMORY_INDEX.md) — authoritative map of all project knowledge and where to write new decisions.
2. [Chat Rules](CHAT_RULES.md) — commands, authorization boundaries, source/version rules, and memory protocol.
3. [Current Project State](PROJECT_STATE.md) — live development status only; check GitHub before relying on it.
4. [Chat Transfer Snapshot](CHAT_TRANSFER.md) — boot protocol and last-reconciled handover. Always refresh it against live `main`.
5. [App Reference](APP_NOTES.md) — UI, controls, BLE, telemetry, and localization contracts.
6. [Firmware Reference](FIRMWARE_NOTES.md) and [Firmware Technical Reference](firmware/FIRMWARE_TECHNICAL_REFERENCE.md) — hardware, control, sensor, safety, and implementation contracts.
7. [OTA Protection](OTA_PROTECTION.md), [OTA Regression Memory](OTA_REGRESSION_MEMORY.md), and [Voltage Transition Memory](VOLTAGE_TRANSITION_MEMORY.md) — protected code paths and known regressions.
8. [Build and Release](BUILD_NOTES.md) — explicit APK build procedure and validation boundaries.
9. [App Build Report](APP_BUILD_REPORT.md) — attempts, fixes, test/signing evidence and final build status; the next Build App chat loads it through Prompt D.
10. [Changelog](CHANGELOG.md) — historical changes; history never overrides current code.
11. [Design Notes](DESIGN_NOTES.md) — approved grille, icon, and brand design constraints.
12. [Transfer Prompt Templates](CHAT_TRANSFER_PROMPTS.md) — copy-ready prompts for saving context and starting a new chat.
13. `archive/` contains immutable, verbatim legacy snapshots for forensic recovery only. Any old `CURRENT` status inside an archive is not live truth. Some root-relative links retained from the original documents do not resolve when the snapshot is viewed inside `archive/`; this is intentional to preserve the snapshots byte-for-byte. Use the canonical root-level files linked above for navigation.

## Current release and source validation boundary — 2026-10-19

Latest successful released artifact is **Build #95** / [Actions run 39217718351](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39217718351), source commit `cd691b874ddb0e454ba69891a3e0da3001df892f`. All 21 guarded workflow steps passed, analyzer passed with 23 info-level deprecations, **99/99 Flutter tests passed**, APK signing/certificate, corresponding source ZIP and Release/tag/source checks passed. Native JUnit tasks were NO-SOURCE.
- APK asset `655596091`, SHA-256 `856718ada30c5ef5081b5bb28a5e00c3b9d234e00ebced58a211112cc381140d`.
- Source ZIP asset `655596090`, SHA-256 `262d552e564b7c0a1727048a2e2897777ff18fa7296381a77f2c10236784ce7e`.

## Current animation smoothness follow-up — source only / NOT RUN / NOT RELEASED

- New source blob: `lib/main.dart` `f0bc1375799e7b9e4466a3124ddb031d5f58e522`; updated test blob: `test/widget_test.dart` `653a67f3c946bb10c0da350f9677e19b3275ed58`.
- Main UI icon cycles are Battery 1.5 s, Hotside 1.65 s, Voltage 1.0 s, Adaptive 2.3 s, Peltier 2.1 s; fire/snow particles are larger with eased wrap fades; phase drift is periodic; whole-icon breathing is removed; Peltier crystal rocking is separate from snowfall; Fan rate uses an integrated phase and a 420 ms smooth angular-rate retarget. Home glyphs are 26 dp in the existing 38×38 dp tile.
- The change preserves the existing semantic colours, telemetry authority, warnings, BLE/control behavior, Fan PWM policy, three blades/airflow ribbons, and unknown-value handling.
- The new tests/analyzer are **NOT RUN** because neither Flutter nor Dart CLI is installed. The new source is not included in Build #95. Physical-device smoothness and profile-mode frame workload remain UNVERIFIED. No Build App, Firmware/BIN, Firebase, OTA, flash, or device operation was performed.



## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. The live recursive tree currently has exactly one entry, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was checked; do not read the payload or add README, note, source, or memory files there. Source-to-BIN provenance remains UNVERIFIED.
- The active editable Firmware source is `firmware/JEXFYZ-V6.7.ino` (`FW_VERSION="V6.7"`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`). The user reports successful compilation and online update; this is USER-REPORTED and not independently verified. Source-to-BIN provenance remains UNVERIFIED.
- V6.6 compile/two-same-version OTA statements are historical user reports. V6.7 has a separate user-reported compile/online-update success; no independent compile log, BIN identity, OTA evidence or current device version was inspected.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #92 / run `39211726896` is the latest successful artifact, built from `6610fecb3e47d9941cbf96043b7da3b2a869753b`; its 98/98 Flutter tests and guarded release/tag gates passed. The current seven-icon source follow-up is newer than Build #92 and remains **NOT RUN / NOT RELEASED**. Do not start a build from `Eksekusi Full`; only the separate `@Thinking Eksekusi Build App!` authorizes the full validation/build/release workflow.
- Next verification step, after a separately authorized `@Thinking Eksekusi Build App!`, is to run the repaired workflow through its guarded issue trigger, confirm all required gates pass, and verify the Git tag, Release metadata, APK and source ZIP all reference the same source commit. Then verify indicator rendering and BLE/Fan telemetry on a real phone. Build #83 already contains the current painter source; physical validation remains pending.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
