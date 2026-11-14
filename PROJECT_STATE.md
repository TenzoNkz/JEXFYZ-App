# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-14 (Asia/Jakarta). This file is current truth only. Build-by-build history belongs in APP_BUILD_REPORT.md and CHANGELOG.md; detailed execution evidence belongs in CHAT_TRANSFER.md and APP_PREBUILD_AUDIT.md.

## Repository baseline

- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current recursive tree before this authorized policy patch: 133 entries, 52 Markdown files, `truncated=false`; one guarded App release workflow; one active sketch at `firmware/JEXFYZ-V7.2.ino`.
- Twelve canonical `.agents/skills` definitions and twelve `.github/skills` mirrors remain byte-identical.
- Root `analysis_options.yaml` is now present and includes `package:flutter_lints/flutter.yaml`. `flutter_lints 6.0.0` was already a direct dev dependency and is locked in `pubspec.lock`.
- The guarded release workflow still has issue-only opened/reopened triggers; there is no push/PR auto-release path. Its concurrency policy is now job-level under the guarded build job, not workflow-level.
- No Dart/Flutter SDK or actionlint binary is installed in the current execution runtime; no SDK/cache was found in the common runtime directories checked, and network DNS/download attempts could not reach GitHub or Flutter's artifact host. The only repository workflow is the guarded App Build/QC/Release pipeline; no non-publishing validation workflow exists.

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
2. **P2 lint policy — ENABLED; diagnostic audit PENDING:** root `analysis_options.yaml` includes the locked `flutter_lints 6.0.0` rule set. Build #162's 23 info-level findings predate this configuration and are not a post-activation baseline. Flutter/Dart are unavailable here, so new diagnostics are **NOT RUN**.
3. **P2 formatter baseline — NOT ESTABLISHED:** the guarded workflow still has no Dart formatter step. On an SDK-equipped checkout, run `dart format --output=none --set-exit-if-changed lib test`; format and review a formatting-only diff if needed, then repeat until clean. Add a blocking formatter gate only after the clean baseline is recorded.
4. **CI/governance:** a non-publishing validation workflow, persisted coverage artifact, reviewed full-SHA action pinning and main-branch protection remain open. Do not run or repurpose the release workflow as a validation-only task.
5. **P2 tests:** retain the 188-test suite and add real FlutterBluePlus/plugin-channel lifecycle tests, native MethodChannel/service tests where meaningful, and a real SQLite v1→v2 fixture migration test. Do not add empty native JUnit tests solely to avoid `NO-SOURCE`.
6. **P2 maintainability:** extract lower-coupling data/UI seams incrementally only after regression tests exist. BLE coordinator extraction is high-risk and should be late, not a mechanical rewrite.

## Firmware and security boundaries

- Current App repository sketch: `firmware/JEXFYZ-V7.2.ino`, `FW_VERSION="V7.2"`. No Arduino compile, BIN provenance, physical NVS/rail/Touch/LED, thermal/electrical, OTA, flash or device validation is established by App CI.
- BLE App-only identity authentication remains **BLOCKED / NOT IMPLEMENTED**; Just Works bonding plus `SYNC_READY` is not proof of official App identity.
- Online OTA still calls `cloudClient.setInsecure()`: transport is encrypted but server certificate identity is not authenticated. Preserve the protected OTA allow-list/recovery contract; do not redesign without specific authorization.
- The owner previously reported Firmware V7.2 and Build #159 installed and safe in use; this is USER-REPORTED, not independent device validation.

## Immediate next action

- Preferred next step: add a separate manually dispatched, non-publishing workflow at `.github/workflows/jexfyz-app-validation.yml` (requires a new explicit `Eksekusi Full!` authorization). It should use read-only permissions and Flutter 3.47.2 to run `flutter pub get --enforce-lockfile`, `dart format --output=none --set-exit-if-changed lib test`, `flutter analyze --no-fatal-infos` and `flutter test --coverage`; no APK/AAB, Gradle, signing, Firebase, Release or Firmware/device steps. Once committed to main, the owner can launch it under Actions → JE X FYZ — Validation Only → Run workflow. Record its source SHA and each command's exit code; do not reuse the guarded Build App workflow.
- Do not invoke Build App/APK/Release for this task. Firmware compile/BIN/Firebase/OTA/flash and device operations remain separately gated.
