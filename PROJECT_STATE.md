# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-14 (Asia/Jakarta). This file is current truth only. Build-by-build history belongs in APP_BUILD_REPORT.md and CHANGELOG.md; detailed continuation belongs in CHAT_TRANSFER.md.

## Repository baseline

- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current recursive tree baseline at the start of this documentation pass: 133 entries, 52 Markdown files, `truncated=false`; one workflow at `.github/workflows/jexfyz-app-build-trigger.yml`; one active sketch at `firmware/JEXFYZ-V7.2.ino`.
- Twelve canonical `.agents/skills` definitions and twelve `.github/skills` mirrors remain byte-identical.
- The current review-start main checkpoint was 35 commits ahead / 0 behind Build #162's source SHA, and the complete compare listed only Markdown files. No App source, tests, Android source/configuration, dependencies, workflow or Firmware code changed after the packaged source.
- Root `analysis_options.yaml` is absent although `flutter_lints: ^6.0.0` is declared. The release workflow has no Dart formatter step and there is no separate non-publishing validation workflow.

## Latest verified App package — Build #162 SUCCESS

- **Run/job:** [Actions run 43430275967](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43430275967), job `131901744336`, completed SUCCESS.
- **Exact packaged source:** `6854d8eb58a5f077cbc99749a35d37a4f55b8efa`. Release ID `403010611` and tag `jexfyz-latest` point to this SHA.
- **Hosted QC:** analyzer 23 info-level findings / zero warnings/errors; Flutter **188/188 passed**; Android Gradle gate `BUILD SUCCESSFUL in 3m56s`. Native Android App JUnit tasks were `NO-SOURCE`; no native App JUnit case executed.
- **APK:** SHA-256 `56c08bd490e52a8616627613675141a91c14ab6893cca0e1e54d5e5ac1a053f2`.
- **Corresponding source ZIP:** SHA-256 `86bd61edfe59acd6063367f7b8704356d2bf192d8c55c150f0f0e6b6285db42e`; downloaded ZIP integrity/source marker passed.
- Both generated/downloaded APKs passed V1/JAR, V2 and V3 verification with the pinned JE X FYZ certificate. The certificate is self-signed and not publicly CA-trusted.
- Included fixes: lowercase About handle `@horizontalzzz`; current Usage Statistics session/header/axis/readout presentation; Floating Monitor's unique Fan glyph; prior approved Peltier, Lock Voltage, About and Home-tab refinements.
- Build #160 and #161 remain failed historical attempts. Never rewrite them as success. See APP_BUILD_REPORT.md.
- Build #162 owner installation is not independently confirmed. Build #159 installation was previously USER-REPORTED; do not promote that report to Build #162 installation evidence.
- Visual acceptance at 350-dp/420-dp, portrait/constrained height, English/Indonesian and Light/Dark remains **VISUAL NOT VERIFIED**. App CI does not prove physical BLE, OEM, cooling, thermal/electrical or Firmware behavior.

## Current App architecture and contracts

- Inventory: seven Dart App source files, nine Dart test files / 188 test declarations, four Kotlin source files, one active Firmware sketch. Largest Dart files: `main.dart` 10,564 lines, `usage_statistics.dart` 3,409, `floating_monitor.dart` 1,766 and `app_settings.dart` 1,678.
- Usage Statistics uses local SQLite schema v2 with a v1→v2 `onUpgrade`, 30-day retention, raw 1-Hz Battery/Hotside samples, explicit gaps, HOT-only P1 freshness, session continuity and a bounded FIFO writer queue (64 normal + 8 reserved + 1 critical endSession slot). A full selected-session summary/decimation pass still runs each second; long-duration CPU/memory and storage-pressure soak remain unverified.
- BLE coordinator code has serialized scan ownership, attempt-generation invalidation and subscription/timer cleanup. Android 12+ Scan/Connect plus legacy pre-Android-12 Bluetooth/Location declaration/request paths exist. Static source checks are not OEM/device validation.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"` and Flutter version `1.0.0+3`.

## Confirmed repository hardening backlog

1. **P1 workflow concurrency:** global workflow-level group `jexfyz-cooler-build` with `cancel-in-progress: true` is evaluated for all issue opened/reopened events; owner/title/body-token guard is only on `jobs.build.if`. An unrelated issue can cancel a valid active release. Proposed fix: job-level concurrency under the guarded job, cancel active run = false, and explicit queue policy. Use `queue: max` if every valid trigger must queue FIFO (up to 100 pending); preserve every existing guard/release gate.
2. **P2 lint/format:** activate `flutter_lints` through root `analysis_options.yaml`, stage/fix resulting diagnostics, normalize formatting and add a formatter gate. This configuration change has not been authorized/performed in this session.
3. **P2 CI/governance:** add a non-publishing validation workflow before making checks required; main branch metadata previously reported `protected=false`. Pin third-party Actions to verified full SHAs or use a supported workflow dependency lockfile.
4. **P2 tests:** retain the 188-test suite and add real FlutterBluePlus/plugin-channel lifecycle tests, native MethodChannel/service tests where meaningful, a real SQLite v1→v2 fixture migration test and a persisted coverage report. Existing unit/widget tests are not all source-string checks; do not add empty native JUnit tests solely to avoid `NO-SOURCE`.
5. **P2 maintainability:** extract lower-coupling data/UI seams incrementally only after regression tests exist. BLE coordinator extraction is high-risk and should be late, not a mechanical rewrite.

## Firmware and security boundaries

- Current App repository sketch: `firmware/JEXFYZ-V7.2.ino`, `FW_VERSION="V7.2"`. No Arduino compile, BIN provenance, physical NVS/rail/Touch/LED, thermal/electrical, OTA, flash or device validation is established by App CI.
- BLE App-only identity authentication remains **BLOCKED / NOT IMPLEMENTED**; Just Works bonding plus `SYNC_READY` is not proof of official App identity.
- Online OTA still calls `cloudClient.setInsecure()`: transport is encrypted but server certificate identity is not authenticated. Preserve the protected OTA allow-list/recovery contract; do not redesign without specific authorization.
- The owner previously reported Firmware V7.2 and Build #159 installed and safe in use; this is USER-REPORTED, not independent device validation.

## Immediate next action

- First obtain explicit scope authorization for the workflow concurrency and lint/configuration changes, because `Eksekusi Full!` alone does not override the concrete-scope rules in MASTER_PROMPT.md.
- Then implement the smallest workflow correction and lint baseline, keep all existing release guards/gates, validate with a non-publishing path where available, and refresh the release/docs evidence. Any APK/QC/release still requires a separate `Eksekusi Build App!`.
