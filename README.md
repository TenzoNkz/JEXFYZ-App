# JE X FYZ / JE Cooler App

Flutter Android companion app for the JE X FYZ thermoelectric cooler, paired with the ESP32-C3 firmware.

## Current source-only follow-up — 2026-10-20

- The Home card heading is localized as `Notification` / `Notifikasi`; Contact Developer and user-facing copy are localized consistently in English and Indonesian. Hotside terminology is standardized as `Hotside` / `Suhu Hotside`.
- This copy pass is source-only and has NOT been validated by Flutter tests/Dart analysis or an App Build. Build #116 remains the latest verified release.

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

- Latest successful App release: **Build #116**, Actions run [39355262101](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39355262101), packaged source `48683874db659df940272bed1c860072ead2d767`. Live `jexfyz-latest` Release/tag target that package commit.
- APK asset `657979004`, SHA-256 `8570914f331583d2cc462f61881609c0eae56639a139f2d60a832e4aaa81ea27`; corresponding source ZIP asset `657979008`, SHA-256 `60ef4e79529aabcbb4f4093b9f8a18b5d383d5c651c1c303dd8bb774e7b0dd5d`.
- Build #116 passed 109 Flutter tests, analyzer exit 0 with 25 info-level diagnostics, configured Android gate, signing checks, ZIP integrity, asset hash/source-marker checks, and exact tag/commit verification. Native Android JUnit tasks were `NO-SOURCE`.
- Current source-only follow-up is **NOT RUN / NOT RELEASED**: `lib/main.dart` blob `8eb24de58a2e510b3d05abbb29bce45bb0a42810`, `test/widget_test.dart` blob `a82875dd47ad904818fcd4c1c47b1a3ac0ca8fd2`. Fire now uses falling flame-shaped particles with rounded-frame clipping; NOTIFY is exactly `NOTIFY` with a 2 dp top inset, while its height stays 44 dp, body remains limited to two lines, metric rows stay 45 dp, and the pre-NOTIFY gap stays 3 dp.
- Flutter tests and Dart analysis have NOT RUN on this newest change. Build #116 must not be treated as validation of these later edits.
- Firmware V6.9 compile/install remains USER-REPORTED; independent logs, source-to-BIN provenance, installed version and physical behavior remain UNVERIFIED. No App Build/Firmware/device action was started in this Full task.

## Remaining validation outside CI

- Build #113 / run 39350217172 is the latest successful App artifact. The subsequent 45 dp/fixed-height NOTIFY/background-fire follow-up is newer than Build #113 and NOT RUN / NOT RELEASED. Do not start App Build from Eksekusi Full; only `@Thinking Eksekusi Build App!` authorizes the full App validation/build/release workflow.
- Next App verification step requires a separate `@Thinking Eksekusi Build App!`: run the guarded issue-trigger workflow, confirm gates and verify tag, Release metadata, APK and source ZIP all reference the same package source. Until then, current 45 dp/fixed-NOTIFY/background-fire edits remain unvalidated/unreleased. Firmware V6.9 compile/install is user-reported, but exact source-to-BIN provenance and physical behavior remain unverified. Physical UI, BLE/Fan telemetry, and firmware behavior remain unverified.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
