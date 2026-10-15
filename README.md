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

Latest App source smooths the Fan Speed gauge between telemetry targets over 420 ms from its currently rendered value, returns OFF to zero over 520 ms, and uses loop-continuous needle wobble. The voltage-bolt sheen now moves sinusoidally, and Bluetooth ripple rings fade to transparent smoothly at each repeat boundary. Fan coast-down and the full-colour box-free Peltier OFF pose remain.

Regression tests have been updated, but Flutter tests/analyze and device rendering were NOT run after the current source changes. Latest successful Build App run `38566673160` on older source commit `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b` predates these edits; it verified V1/V2/V3 on the APK and downloaded asset but warned `META-INF/services/a1` and `META-INF/services/b1` are not protected by JAR/V1. MT Manager's earlier signature label still needs a device recheck. Build App requires explicit `@Thinking Build App!` authorization. Firmware V6.6 is user-accepted as final; do not reopen Firmware operations unless requested. See [PROJECT_STATE.md](PROJECT_STATE.md) and [HANDOVER.md](HANDOVER.md).

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Run App Build only after an explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!` request. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a chat/context limit, follow Prompt A in `CHAT_TRANSFER_PROMPTS.md`, reconcile every memory/source file, and replace `CHAT_TRANSFER.md` last.
