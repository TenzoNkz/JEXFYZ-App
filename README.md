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
9. [Changelog](CHANGELOG.md) — historical changes; history never overrides current code.
10. [Design Notes](DESIGN_NOTES.md) — approved grille, icon, and brand design constraints.
11. [Transfer Prompt Templates](CHAT_TRANSFER_PROMPTS.md) — copy-ready prompts for saving context and starting a new chat.
12. `archive/` contains verbatim legacy snapshots for forensic recovery only. Any old `CURRENT` status inside an archive is not live truth.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable firmware source is `firmware/JEXFYZ-V6.6.ino`. Its embedded `FW_VERSION`, filename and the single active versioned `.ino` must always match.
- The user considers Firmware V6.6 correct/final and reports successful compilation plus two successful Online OTA updates with the same V6.6 version. Do not modify/recompile/reflash it unless the user reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified; do not infer it from the user report.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Current validation boundary

Current App source changes include natural Fan OFF coast-down with full-colour blades, a free-standing Peltier crystal without the square module/bolts and without OFF fading, and a subtly wobbling Fan Speed needle that eases to 0 when OFF. Widget source-contract tests were updated. Static source checks passed, but Flutter tests/analyze and device rendering were NOT run after these edits. The last successful build/test run predates these changes (Actions run `38556896542`).

The APK signature workflow fix also remains unverified by a build. The prior build reported V1=false, V2/V3=true; the updated workflow requires all three schemes. Explicit `@Thinking Build App!` authorization is required before running that workflow. Firmware V6.6 is accepted as final by the user after two same-version Online OTA updates; do not reopen Firmware operations unless asked. See [PROJECT_STATE.md](PROJECT_STATE.md) and [HANDOVER.md](HANDOVER.md) for current validation boundaries.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Run App Build only after an explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!` request. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a chat/context limit, follow Prompt A in `CHAT_TRANSFER_PROMPTS.md`, reconcile every memory/source file, and replace `CHAT_TRANSFER.md` last.
