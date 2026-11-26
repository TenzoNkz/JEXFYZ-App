<!-- ACTIVE_CHECKPOINT_START -->

## Active checkpoint — CODE_FULL then REPO_FULL — 2026-11-27

- **Owner scope:** finish App-only WP0–WP10 rework/redesign and verified build-ready handoff first; then run one approved REPO_FULL simplification cycle. Build App remains separately authorized.
- **Repository policy:** direct commits to `main` only; no secondary branches or PRs. GitHub currently confirms only `main` and zero active rulesets. Owner confirms this CODE_FULL subchat is the only active execution chat.
- **Pre-batch main:** `10cca8e160ebd7f1d25d3af48c2d94b69b4e64a9`; 148 entries / 102 blobs / 46 trees; `truncated=false`.
- **Connection extraction:** `lib/connection_sheet.dart` owns manual sheet presentation and OS status lifecycle; scan/connect orchestration remains injected from Dashboard. UUID is injected. BLE/GATT/P1/session ownership stays with the Dashboard/coordinator. Current-main Validation Only required.
- **Validation Only #96:** input `c00b7a81d777bf98e9d57796373a4606b9aaf579`; dependency/formatter/analyzer/test steps succeeded, but the job failed at final summary because `main` advanced before the formatter-only commit. It is not a terminal pass for current main.
- **Last terminal validation:** #95 / run `45876793387` / job `140105796228`, SHA `e304c1fadb65af42177df41f04ff6d0bb2528b95`, 230/230 tests with formatter/analyzer PASS. It predates Connection extraction.
- **CI work:** remove formatter write/auto-commit; keep main-only read-only Validation Only; retire unused PR validator; synchronize prompt/status/register/checkpoint references. Guarded Build App remains unchanged.
- **Protected contracts:** BLE/P1 UUID/framing/commands/SYNC_READY, single GATT owner, telemetry truth, Usage Statistics v2/migration/retention/1-Hz/HOT/gaps/64+8+1, OTA/Firebase/signing and Firmware protections remain unchanged.
- **Evidence limits:** local Flutter/Dart/Gradle/ADB unavailable; Validation Only cannot compile Android/Kotlin. No Android screenshot/OEM/device proof, SQLite migration fixture or long-session performance soak. Whole-App visual status **VISUAL NOT VERIFIED**.
- **Latest package:** Build #167 / immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current source is not released.
- **Next action:** exact-SHA main-only read-only Validation Only, then continue CODE_FULL WP0–WP10; only afterward REPO_FULL. No Build App trigger in CODE_FULL.

<!-- ACTIVE_CHECKPOINT_END -->
