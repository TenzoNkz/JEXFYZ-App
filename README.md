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

## Current release and source validation boundary — 2026-10-18

- Latest verified App release is Build #73 / [Actions run 39098410865](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39098410865), exact source/release commit `f1e81450428ffb113a76d430590c312ad6fa4781`. All 21 workflow steps passed, Dart analysis reported 23 info-level deprecations and **91/91 Flutter tests passed**. Android production compile/configured gate, obfuscated APK, V1/V2/V3 signing/certificate, corresponding source ZIP, release publication and downloaded-asset verification passed. Native JUnit tasks were NO-SOURCE; no native JUnit cases ran.
- APK asset 652517541, 54,538,331 bytes, SHA-256 `90ed2f36658ea0e4fa487d43ea7e4347545c9875b13d703ec9c2765445eea48b`. Matching source ZIP asset 652517543, 2,846,735 bytes, SHA-256 `ed7429aa9f6cb36e327d6d7b85efdf0b895ee8529c09a159053b98c8628902ef`. Release `jexfyz-latest` targets the exact Build #73 source commit. Details live in `APP_BUILD_REPORT.md`.
- Build #73 includes the TamperScreen profanity/contact screen, but **does not include** the later source-only Hotside contour, per-indicator motion, Peltier/Adaptive/LED toggle styling and Bluetooth/Adaptive submenu lock overlays. Four new UI test contracts exist but tests and analysis for these newest changes were NOT RUN; no APK build was triggered by this reconciliation.
- Active Firmware sketch is `firmware/JEXFYZ-V6.7.ino`, embedded `FW_VERSION="V6.7"`, matching filename, exactly one active versioned sketch. V6.7 remains source-only/uncompiled; prior V6.6 compile/two-OTA reports are historical user reports, and source-to-BIN provenance remains UNVERIFIED.
- Physical phone visuals, BLE/Fan telemetry, Firmware compilation, OTA, reboot and thermal/electrical behavior remain outside the verified App CI evidence.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable Firmware source is `firmware/JEXFYZ-V6.7.ino` (`FW_VERSION="V6.7"`, blob `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`). V6.7 is source-only/uncompiled; filename, embedded version and exactly-one-active-sketch must match.
- V6.6 compile/two-same-version OTA statements are historical user reports. The user reopened source work and authorized a V6.7 Adaptive Fan PWM change; V6.7 was not compiled, published, OTA-applied or installed. Source-to-BIN provenance remains unverified.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #73 is the latest verified release for source `f1e81450428ffb113a76d430590c312ad6fa4781`; full release evidence and hashes are in `APP_BUILD_REPORT.md`.
- Next verification step, after a separately authorized `@Thinking Eksekusi Build App!`, is device-side validation of the current Hotside contour, per-indicator motion, toggle styling, centered submenu lock overlays and live BLE/Fan telemetry. The current UI source/tests remain NOT RUN and are not in Build #73.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
