# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner scope and repository policy

- **Workspace:** `CODE_FULL` / Eksekusi Code. Complete App-only WP0–WP10 and build-ready handoff, then one approved REPO_FULL cleanup cycle.
- **Repository:** direct commits to `main` only. GitHub verifies exactly one branch (`main`) and zero active repository rulesets. No secondary branches or PRs.
- **Execution writer:** owner confirms this CODE_FULL chat is the only active project execution conversation. Re-fetch live `main` and target-file SHAs before each commit; update refs with expected-HEAD protection.
- **Included:** App Flutter/Dart source/tests/docs/config/static audit and the approved later repository cleanup.
- **Excluded:** App Build/APK/sign/release until fresh `Eksekusi Build App!`; Firmware/BIN/P1 wire or functional changes, BLE identity/security, OTA, Firebase production, signing material, flashing and device operation.

## Current source checkpoint

- **main:** `c97a2fdc2698b16339d3f03ff04d992f2a0e7848`; root tree `0fb0dc18806ca564ea937964eb9ad77dae486e3c`; 147 entries / 101 blobs / 46 trees; not truncated.
- **Repository register:** 101 unique path dispositions cover all 101 live blobs; no missing or duplicate paths.
- **Home NOTIFY:** stateless `HomeNotifyCard` in `lib/home_notify.dart`; fixed 44 dp. Dashboard retains status, safety/HOT-limit, localization and foreground-color decisions.
- **Connection:** `lib/connection_sheet.dart` isolates manual sheet presentation/OS status lifecycle; scan/connect orchestration and BLE/GATT/P1 authority remain with Dashboard/coordinator.
- **Validation Only:** run `45884911511` / job `140133094930`, exact SHA above; dependency lock, formatter read-only, analyzer and **233/233 tests PASS**, terminal SUCCESS.
- **Latest published package:** Build #167 / source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`. Current main source remains unreleased.

## Protected contracts and evidence

One BLE/GATT/P1 owner; unchanged UUIDs/framing/commands/SYNC/SYNC_READY; serialized scan ownership and stale-attempt invalidation; command intent vs ACK vs telemetry-confirmed output; Usage Statistics schema v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT freshness, gap semantics and 64+8+1 queue; Android identity, theme/assets/localization and 360-dp layout remain protected.

Flutter/Dart/Gradle/ADB are unavailable locally. Validation Only does not compile Android/Kotlin or prove screenshots/device/OEM behavior. Whole-App visual state remains **VISUAL NOT VERIFIED**. SQLite migration fixture and long-session performance soak remain NOT RUN.

## Next action

Continue CODE_FULL Dashboard architecture/state-ownership audit and ordered WP0–WP10. After CODE_FULL closes, run the approved REPO_FULL cycle. Do not invoke Build App without a separate explicit owner command.
