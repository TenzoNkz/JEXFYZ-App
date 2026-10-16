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

- Latest verified release is [Build #62](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441), exact source `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. It passed audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, Android release build/signing, publication and re-downloaded asset verification. It includes Shizuku UserService binding lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` plus the aligned test-contract repair.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has one APK (asset `645909183`, `54,636,716` bytes; SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`) and one matching source ZIP (asset `645909184`, `2,871,177` bytes; SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`). Both were re-downloaded and verified against the exact Build #62 source marker.
- Build #61 / run `38841172623` failed because one widget-test assertion expected the old shared Shizuku binding names and fallback parser pattern (87 passed, 1 failed). The test-only repair now checks attempt-scoped binding and the current WindowManager diagnostic output. Build #62 passed 88/88 without removing tests or weakening a gate.
- **Physical-device validation remains open:** actual Shizuku UserService binding/lifecycle on the target phone, OEM SurfaceFlinger layer visibility, foreground FPS and overlay/icon animation require device evidence. CI success does not substitute for a phone-side run and diagnostic status/logs.
- Actual FPS, Shizuku UserService behavior, OEM SurfaceFlinger layer access and phone-side rendering remain **NOT DEVICE-VERIFIED**. No Firmware/BIN, Firebase, OTA, BLE hardware-control or thermal-safety code was changed.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable firmware source is `firmware/JEXFYZ-V6.6.ino`. Its embedded `FW_VERSION`, filename and the single active versioned `.ino` must always match.
- The user considers Firmware V6.6 correct/final and reports successful compilation plus two successful Online OTA updates with the same V6.6 version. Do not modify/recompile/reflash it unless the user reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified; do not infer it from the user report.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Current validation boundary

- Canonical App repo is TenzoNkz/JEXFYZ-App, branch main. Latest verified release is [Build #62 / run 38841458441](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441), source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. Audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK compilation, V1/V2/V3 signing, production certificate verification, matching source archive, publication and downloaded-asset verification all passed.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly two verified assets: [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) (asset `645381550`, `54,636,716` bytes; SHA-256 `47892215de179c8cb2975ad5c99b8b3b1398559873352411ed74d001aa001274`) and [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) (asset `645381553`, `2,866,092` bytes; SHA-256 `dd9bdc1f8082c70ab2ff73892f5434057d36cedc870fd92184b8ed579e2b538a`). See `APP_BUILD_REPORT.md` for the full attempt history and verification evidence.
- Build #62 verifies Shizuku lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` and test-only repair in commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. Physical UserService binding, OEM layer access, live FPS and visual rendering remain **NOT DEVICE-VERIFIED**.
- Shizuku remains the explicit FPS permission/execution path using the restricted AIDL UserService. Shizuku permission alone does not prove service binding or SurfaceFlinger layer availability. Actual phone FPS, overlay rendering and OEM behavior remain **NOT DEVICE-VERIFIED**.
- Only active workflow is `.github/workflows/jexfyz-app-build-trigger.yml`. It is owner/title/token-guarded and listens to issue opened/reopened; normal push/PR does not build/release. Only `@Thinking Eksekusi Build App!` authorizes that operation.
- Firmware source remains `firmware/JEXFYZ-V6.6.ino`, `FW_VERSION="V6.6"`. User compiles firmware; V6.6 is user-accepted final. App CI does not imply Firmware/BIN/Firebase/OTA/flash/device action.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
