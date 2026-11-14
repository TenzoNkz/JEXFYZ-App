# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-14 (Asia/Jakarta), after Validation Only run #14. This file is current truth only. Build-by-build history belongs in APP_BUILD_REPORT.md and CHANGELOG.md; detailed execution evidence belongs in CHAT_TRANSFER.md and APP_PREBUILD_AUDIT.md.

## Repository baseline

- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current recursive tree: 137 entries, `truncated=false`; two workflows under `.github/workflows/` (guarded App release and push-triggered non-publishing Validation Only); one active sketch at `firmware/JEXFYZ-V7.2.ino`.
- Twelve canonical `.agents/skills` definitions and twelve `.github/skills` mirrors remain byte-identical.
- Root `analysis_options.yaml` is now present and includes `package:flutter_lints/flutter.yaml`. `flutter_lints 6.0.0` was already a direct dev dependency and is locked in `pubspec.lock`.
- The guarded App release workflow keeps issue-only opened/reopened triggers and its owner/title/body-token guard; relevant pushes start Validation Only, not App Build/Release. Release concurrency is job-level under the guarded build job.
- Flutter/Dart and actionlint are unavailable in this ChatGPT runtime. Hosted Validation Only run #14 completed on Flutter 3.47.2 with 188/188 tests passed; no local Flutter test/build or actionlint check ran.

## Latest verified App package — Build #162 SUCCESS

- **Run/job:** [Actions run 43430275967](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43430275967), job `131901744336`, completed SUCCESS.
- **Exact packaged source:** `6854d8eb58a5f077cbc99749a35d37a4f55b8efa`. Release ID `403010611` and tag `jexfyz-latest` point to this SHA.
- **Hosted QC:** analyzer 23 info-level findings / zero warnings/errors; Flutter **188/188 passed**; Android Gradle gate `BUILD SUCCESSFUL in 3m56s`. Native Android App JUnit tasks were `NO-SOURCE`; no native Android JUnit case executed.
- **APK:** SHA-256 `56c08bd490e52a8616627613675141a91c14ab6893cca0e1e54d5e5ac1a053f2`.
- **Corresponding source ZIP:** SHA-256 `86bd61edfe59acd6063367f7b8704356d2bf192d8c55c150f0f0e6b6285db42e`; downloaded ZIP integrity/source marker passed.
- Build #160 and #161 remain failed historical attempts. Never rewrite them as success. See APP_BUILD_REPORT.md.
- Build #162 owner installation is not independently confirmed. Visual acceptance at 350-dp/420-dp, portrait/constrained height, English/Indonesian and Light/Dark remains **VISUAL NOT VERIFIED**.

## Current App architecture and contracts

- Inventory: seven Dart App source files, nine Dart test files / 188 test declarations, four Kotlin source files, one active Firmware sketch. Largest Dart files: `main.dart` 10,564 lines, `usage_statistics.dart` 3,409, `floating_monitor.dart` 1,766 and `app_settings.dart` 1,678.
- Usage Statistics uses local SQLite schema v2 with a v1→v2 `onUpgrade`, 30-day retention, raw 1-Hz Battery/Hotside samples, explicit gaps, HOT-only P1 freshness, session continuity and a bounded FIFO writer queue (64 normal + 8 reserved + 1 critical endSession slot). A full selected-session summary/decimation pass still runs each second; long-duration CPU/memory and storage-pressure soak remain unverified.
- BLE coordinator code has serialized scan ownership, attempt-generation invalidation and subscription/timer cleanup. Static source checks are not OEM/device validation.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"` and Flutter version `1.0.0+3`.

## Confirmed repository hardening state

1. **P1 workflow concurrency — FIXED in current main:** workflow-level concurrency was removed. `jexfyz-cooler-build` now exists only under `jobs.build`, after the unchanged owner-login, exact-title and body-token guard. It sets `cancel-in-progress: false` and `queue: max`, allowing one active plus up to 100 pending guarded release jobs. All original event triggers and release gates remain. The workflow was not run by this session.
2. **P2 lint policy — ENABLED; hosted baseline measured:** root `analysis_options.yaml` includes locked `flutter_lints 6.0.0`. Validation Only run #14 reports 119 info-level findings and zero warnings/errors. Build #162's 23 infos predate this rule set.
3. **P2 formatter baseline — ESTABLISHED/CLEAN:** hosted Validation Only run #14 formatted 17 checked files (14 changed), then final formatter check passed with zero remaining changes. After all 188 tests passed, workflow committed the formatter-only diff as `20676552cbfbb3276a6d7a7bc5f2541c13245c48`, guarded to `lib/` and `test/` with exact remote-HEAD verification.
4. **CI/governance:** separate push-triggered non-publishing Flutter Validation Only workflow exists on configured `main` paths with pinned action SHAs. Coverage retention and branch protection remain open; it never builds/releases the App.
5. **P2 tests:** retain the 188-test suite and add real FlutterBluePlus/plugin-channel lifecycle tests, native MethodChannel/service tests where meaningful, and a real SQLite v1→v2 fixture migration test. Do not add empty native JUnit tests solely to avoid `NO-SOURCE`.
6. **P2 maintainability:** extract lower-coupling data/UI seams incrementally only after regression tests exist. BLE coordinator extraction is high-risk and should be late, not a mechanical rewrite.

## Firmware and security boundaries

- Current App repository sketch: `firmware/JEXFYZ-V7.2.ino`, `FW_VERSION="V7.2"`. No Arduino compile, BIN provenance, physical NVS/rail/Touch/LED, thermal/electrical, OTA, flash or device validation is established by App CI.
- BLE App-only identity authentication remains **BLOCKED / NOT IMPLEMENTED**; Just Works bonding plus `SYNC_READY` is not proof of official App identity.
- Online OTA still calls `cloudClient.setInsecure()`: transport is encrypted but server certificate identity is not authenticated. Preserve the protected OTA allow-list/recovery contract; do not redesign without specific authorization.
- The owner previously reported Firmware V7.2 and Build #159 installed and safe in use; this is USER-REPORTED, not independent device validation.

## Immediate next action

- No pending task in the Validation Only stream: run #14 passed 188/188 and the formatter-only commit is on `main`. The latest packaged App remains Build #162. Visual/device acceptance or a future App release is a separate task and requires explicit owner authorization.
- Do not invoke Build App/APK/Release for this task. Firmware compile/BIN/Firebase/OTA/flash and device operations remain separately gated.
