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

- Latest successful release is Build #100 / https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39237262140, source 51bea70b2ca17f285bf35c3e547dc44c70f26d59. All 21 workflow steps passed; 103/103 Flutter tests passed; analyzer exited 0 with 25 info-level findings and no errors/warnings; APK signatures/certificate, matching source ZIP, downloaded asset digests and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- APK asset ID 655957943, SHA-256 a59c0a37b2025ad2b250bd4354b887379d96658e9f7757692691fa23b7b4d0a2; source ZIP asset ID 655957946, SHA-256 e60c4705097009d843b624bf8f0f989770a76aba6fdfbdd8d2159d77f98890f1.
- New source follow-up after Build #100 professionalizes Home STATUS/NOTIFY text, hides raw firmware reason and OTA error/code identifiers, localizes common failures, and shortens category labels. Blobs: lib/main.dart 51b52042b6429ae2e4a4f2508685cd8326af68c8; lib/app_settings.dart e91ecd2a00eafdec3f681daabb74fd49fcd25bf2; test/widget_test.dart 9d80171a12af084748b88fcdd06d3d6b3cf65e1f. It is NOT RUN / NOT RELEASED; Build #100 does not include it.
- Real-device display, language switching, BLE/PWM behavior and hardware safety are not proven by source assertions. No Firmware/BIN/Firebase/OTA/device operation was performed.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. The live recursive tree currently has exactly one entry, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was checked; do not read the payload or add README, note, source, or memory files there. Source-to-BIN provenance remains UNVERIFIED.
- The active editable Firmware source is `firmware/JEXFYZ-V6.8.ino` (`FW_VERSION="V6.8"`, blob `4f8011337fc3c9e3f1ace717fbd7179e1331bff8`). It replaces Adaptive 12V Fan PWM trend control with direct Hotside-limit temperature tiers. V6.8 is source-only, not compiled/installed; source-to-BIN provenance remains UNVERIFIED.
- V6.6/V6.7 compile/OTA reports are historical user reports. V6.7 compilation and online update were user-reported, but no independent compile log, BIN identity, OTA evidence or current device version was inspected.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #100 / run 39237262140 is the latest successful artifact, built from source 51bea70b2ca17f285bf35c3e547dc44c70f26d59; its 103/103 Flutter tests and guarded release/tag gates passed. The current bilingual notification-copy cleanup is newer than Build #100 and remains NOT RUN / NOT RELEASED. Do not start a build from Eksekusi Full; only the separate @Thinking Eksekusi Build App! authorizes the full validation/build/release workflow.
- Next verification step, after a separately authorized `@Thinking Eksekusi Build App!`, is to run the repaired workflow through its guarded issue trigger, confirm all required gates pass, and verify the Git tag, Release metadata, APK and source ZIP all reference the same source commit. Then verify indicator rendering and BLE/Fan telemetry on a real phone. Build #83 already contains the current painter source; physical validation remains pending.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
