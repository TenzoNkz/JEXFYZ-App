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

## Current release and source validation boundary — 2026-10-20

- Latest successful App release is **Build #113**, Actions run [39350217172](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39350217172), packaged source `05e4f644d6bf82ae2682154082c3e44a4876205a`. The live `jexfyz-latest` Release and tag both point to that commit. APK asset `657872748`, SHA-256 `7252e952983560254822b8d77a9a1c47d5a3f91d80bf8ed50e58586bbe2c2991`; source ZIP asset `657872749`, SHA-256 `0fcccecc639e20f16d65976a5f3c334dd2ce4f7692d2a4d95b5b8aaad7dae59f`.
- Build #113 passed 109 Flutter tests, Dart analyzer exit 0 with 25 info-level diagnostics, the configured Android Gradle gate, V1/V2/V3 signing and certificate checks, and published-asset/hash/tag verification. Native Android JUnit tasks were `NO-SOURCE`, so no native Android JUnit cases ran.
- Latest App source follow-up is newer than Build #113 and **NOT RUN / NOT RELEASED**: `lib/main.dart` blob `d0fdb7482d939b34b0a1824b33d37f6457835818`, `test/widget_test.dart` blob `09cfe3e7b744b988571a28ad0d9377da5ee36cb1`. It sets all seven Home metric rows to 45 dp, uses a 3 dp gap above fixed-height 44 dp NOTIFY, scales wrapped body text to fit up to two lines, keeps cooler image constraints stable, and paints Battery/Hotside fire behind their foreground silhouettes using `ClipOp.difference`.
- The source-only follow-up has NOT had Flutter tests or Dart analysis executed. Build #113 must not be treated as validation of these newer edits.
- Firmware V6.9 source remains `firmware/JEXFYZ-V6.9.ino` (blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`). The user reports successful compile/install; independent logs, source-to-BIN provenance, installed version and physical PWM/thermal behavior remain UNVERIFIED. No Firmware tests were run for V6.9 in the recorded CI evidence.
- Physical UI/layout, BLE, thermal/electrical safety, PWM response, source-to-BIN identity, Firebase/OTA, flash and installed-device version require evidence outside App CI.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. The live recursive tree has exactly one entry, blob `821b022f97353d9a7aea4695b2e37c98b7488e15`, 1,456,560 bytes. Only tree metadata was inspected; do not read the payload or add README, note, source, or memory files there. Source-to-BIN provenance remains UNVERIFIED.
- The active editable Firmware source is `firmware/JEXFYZ-V6.9.ino` (`FW_VERSION="V6.9"`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`). It retains Hotside-limit temperature tiers and adds 10-second downsteps/1-second upsteps with transition grace. The user reports V6.9 compiled/installed; independent compile logs, source-to-BIN provenance and installed version remain UNVERIFIED.
- V6.6/V6.7 compile/OTA reports are historical user reports. V6.7 compilation and online update were user-reported, but no independent compile log, BIN identity, OTA evidence or current device version was inspected.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #113 / run 39350217172 is the latest successful App artifact. The subsequent 45 dp/fixed-height NOTIFY/background-fire follow-up is newer than Build #113 and NOT RUN / NOT RELEASED. Do not start App Build from Eksekusi Full; only `@Thinking Eksekusi Build App!` authorizes the full App validation/build/release workflow.
- Next App verification step requires a separate `@Thinking Eksekusi Build App!`: run the guarded issue-trigger workflow, confirm gates and verify tag, Release metadata, APK and source ZIP all reference the same package source. Until then, current 45 dp/fixed-NOTIFY/background-fire edits remain unvalidated/unreleased. Firmware V6.9 compile/install is user-reported, but exact source-to-BIN provenance and physical behavior remain unverified. Physical UI, BLE/Fan telemetry, and firmware behavior remain unverified.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
