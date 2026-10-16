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

## Current source validation boundary — 2026-10-16

- Latest verified release is [Build #69](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38896502185), exact source/release HEAD `01212c32a802ca0e67f559307fe4e19a667489c6`. It passed audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, native TimeStats parser/watchdog-policy JUnit tests, obfuscated Android release build, V1/V2/V3 signing/certificate checks, publication and re-downloaded asset verification. Functional source is unchanged from Build #67/#68.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has one APK (asset `647189019`, `54,636,716` bytes; SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`) and one matching source ZIP (asset `647189016`, `2,877,171` bytes; SHA-256 `1ab19e552c128d09773794738a6a4340abfa82086fa83f2d7e883ed62f60a699`). Both were re-downloaded and verified against the exact Build #69 source marker.
- Build #63 failed one stale widget assertion (87 passed, 1 failed). Build #64 passed Flutter tests but native JUnit ran out of Java heap under the old 2 GiB Gradle heap. The assertion was fixed and Gradle heap raised to `-Xmx4096M`; Builds #65–#69 then passed complete release gates without deleting tests or weakening gates.
- **Latest release / CI-tested:** Build #69 revalidated TimeStats parser checkpoint `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`, Shizuku bind timeout `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d` and sampler watchdog checkpoint `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46`. Five watchdog-policy JUnit cases, four TimeStats parser JUnit cases and all 88 Flutter tests passed.
- Gradle heap remains `-Xmx4096M`. Physical Shizuku UserService binding, OEM TimeStats visibility, actual foreground FPS and overlay rendering remain **NOT DEVICE-VERIFIED**. No Firmware/BIN, Firebase, OTA, BLE hardware-control or thermal-safety code was changed.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable firmware source is `firmware/JEXFYZ-V6.6.ino`. Its embedded `FW_VERSION`, filename and the single active versioned `.ino` must always match.
- The user considers Firmware V6.6 correct/final and reports successful compilation plus two successful Online OTA updates with the same V6.6 version. Do not modify/recompile/reflash it unless the user reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified; do not infer it from the user report.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #68 is the latest verified release for source `1f35dcbc3c8bc85410e765b58430b4b485366c2c`. Full audit/test/build/signing/source archive/Release/download verification evidence is in `APP_BUILD_REPORT.md`.
- Install Build #68 and physically verify Shizuku UserService binding/lifecycle on the target phone, OEM TimeStats layer visibility, foreground FPS and overlay/icon rendering. If `F:--` persists, collect Settings sampler status and filtered `JexFpsDiag` logs, particularly `sampler_exception`, `sampler_watchdog_timeout`, `bind_requested`, `bind_connected`, `layer_match`, and `frame_sample`. CI does not verify device behavior.
- Firmware V6.6 is USER-ACCEPTED FINAL according to the user's report. Its compile log and source-to-BIN provenance remain independently unverified. App CI does not imply Firmware compilation, BIN provenance, Firebase, OTA, flash, BLE hardware or thermal-safety validation.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
