# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner scope and repository policy

- **Workspace:** `CODE_FULL` / Eksekusi Code. Finish owner-approved App-only WP0–WP10 and build-ready handoff, then perform one approved REPO_FULL cycle.
- **Repository path:** direct commits to `main` only. GitHub returned exactly one branch (`main`) and no active repository rulesets. Do not create secondary branches or PRs.
- **Current active writer:** owner confirms this CODE_FULL subchat is the only active execution conversation. Before each commit, re-fetch `main`, target file SHAs and the full base tree; use expected-HEAD protection.
- **Included:** App Flutter/Dart source/tests/docs/configuration/static audit, then repository governance/workflow/documentation cleanup.
- **Excluded:** App Build/APK/signing/release until fresh `Eksekusi Build App!`; Firmware/BIN/P1 wire or functional changes, BLE identity/security, OTA, Firebase production, signing material, flashing and device operation.

## Current code checkpoint

- **Live main before this governance batch:** `10cca8e160ebd7f1d25d3af48c2d94b69b4e64a9`; recursive tree 148 entries / 102 blobs / 46 trees, not truncated.
- **Recent App extraction:** `lib/connection_sheet.dart` separates manual Connection sheet presentation/lifecycle UI from Dashboard. Scan/connect callbacks retain orchestration ownership; service UUID is injected. Current-main Validation Only is still required.
- **Earlier verified source baseline:** Validation Only #95 / run `45876793387` / job `140105796228`, tested SHA `e304c1fadb65af42177df41f04ff6d0bb2528b95`, 230/230 tests, formatter and analyzer pass. It predates the Connection extraction.
- **Validation Only #96:** tested older SHA `c00b7a81d777bf98e9d57796373a4606b9aaf579`; dependency, formatter, analyzer and test steps succeeded, but final summary failed after main advanced before its formatter-only commit. It is not a terminal pass for current main.
- **Latest published App package:** Build #167 / source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current source is not released.

## Protected contracts and evidence

One BLE/GATT/P1 owner; unchanged UUIDs/framing/commands/SYNC/SYNC_READY; serialized scan ownership and stale-attempt invalidation; command intent vs ACK vs telemetry-confirmed output; Usage Statistics schema v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT freshness, gap semantics and 64+8+1 queue; Android identity, theme/assets/localization, 360-dp layout and visual contracts remain protected.

Flutter/Dart/Gradle/ADB are unavailable locally. Validation Only is Flutter/Dart only; it does not compile Android/Kotlin or prove screenshot/device/OEM behavior. Whole-App visual state remains **VISUAL NOT VERIFIED**. SQLite migration fixture and long-session performance soak remain unverified.

## Next action

Complete current-main Validation Only gates, then continue CODE_FULL WP0–WP10. Only after CODE_FULL closes, run the approved single REPO_FULL cleanup cycle. Do not invoke Build App until a separate explicit owner command.
