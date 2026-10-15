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
13. `archive/` contains verbatim legacy snapshots for forensic recovery only. Any old `CURRENT` status inside an archive is not live truth.

## Current source validation boundary — 2026-10-16

- Latest verified release is [Build #58](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38793790061), exact source `db11df355780174b1da7dcea4d5947bfa7ba7ca5`. It passed Dart analysis, 87/87 Flutter tests, Android release build/signing, release publication and asset verification.
- Current post-release diagnostic source checkpoint is `becd7f20517fbdaa4bb9922501f28fbed2282223). It improves foreground-window lookup with a full `dumpsys window` fallback when `dumpsys window displays` does not identify focus, keeps sampler status at `starting` until a valid sample is produced, and displays the actual native FPS state in Floating Monitor settings.
- The post-Build #58 source/test changes have **not** been analyzed, test-run, Kotlin-compiled, built or device-verified. Build #58 remains the latest verified APK; it does not contain these follow-up changes.
- FPS remains device-dependent. A Shizuku grant does not prove a UserService connection or matching SurfaceFlinger layer exists. The new UI status should help distinguish `foreground_unknown`, `no_layer_data`, `sample_invalid`, and service/command failures.
- No Firmware/BIN, Firebase, OTA, BLE hardware-control or thermal-safety code was changed.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable firmware source is `firmware/JEXFYZ-V6.6.ino`. Its embedded `FW_VERSION`, filename and the single active versioned `.ino` must always match.
- The user considers Firmware V6.6 correct/final and reports successful compilation plus two successful Online OTA updates with the same V6.6 version. Do not modify/recompile/reflash it unless the user reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified; do not infer it from the user report.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Current validation boundary

- Canonical App repo is TenzoNkz/JEXFYZ-App, branch main. The latest release build is [Build #56 / run 38785365015](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38785365015), source commit 235f47b47af4f32582a7f18825ed76d2c6bba54f. It passed audit, dependency resolution, Dart analysis, all 86 Flutter tests, obfuscated Android APK compilation, V1/V2/V3 signing, production-certificate verification, matching-source archive checks, publication and downloaded-asset verification.
- Release [jexfyz-latest](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has exactly two intended assets: [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) (54,538,412 bytes; SHA-256 1ae3ef476c170ab0a9d78a77264c5281d60341a931db102c7b8645e4b0dadd19) and [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) (2,860,746 bytes; SHA-256 546d9e6bd99b84273e3b2dca8aa85ced979e118c0704ad97a0a16ff5e9e046c3). See APP_BUILD_REPORT.md for asset IDs and signing evidence.
- Shizuku is the explicit Game FPS permission/execution path. Legacy Wireless ADB pairing/identity-store, Kadb/SPAKE2, app-process DUMP permission and grant/revoke UI are removed. Native FPS uses a restricted AIDL UserService.
- USER-REPORTED runtime issue: permission status shows “Shizuku permission granted”, yet F is -- in a screenshot of JE Cooler's own Floating Monitor settings page. Build #56 now permits focused-window FPS sampling for JE Cooler itself and Android UI layers when SurfaceFlinger exposes them; switch across JE Cooler, Settings/launcher and an actual game before attributing any persistent -- to a defect. No device logs/status map have been captured yet.
- Build #56 success is CI evidence, not a physical-device test. Shizuku UserService binding, SurfaceFlinger reads, layer matching and actual game FPS remain device/OEM-unverified.
- Only active workflow is .github/workflows/jexfyz-app-build-trigger.yml. It is owner/title/token-guarded and listens to issue opened/reopened; normal push/PR does not build/release. Only @Thinking Eksekusi Build App! authorizes that operation.
- Firmware source is firmware/JEXFYZ-V6.6.ino, FW_VERSION="V6.6". User compiles firmware; V6.6 is user-accepted final. No Firmware/BIN/Firebase/OTA/flash action is implied by App CI.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
