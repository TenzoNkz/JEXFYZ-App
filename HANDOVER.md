# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Active handover — CODE_FULL, then REPO_FULL

- **Owner request:** finish App-only WP0–WP10 rework/redesign and a verified build-ready handoff; afterward run one approved REPO_FULL simplification cycle.
- **Repository policy:** main-only. GitHub currently reports one branch (`main`) and zero rulesets. All changes commit directly to `main`; no branches or PRs. Owner confirms this CODE_FULL subchat is the only active project execution chat.
- **Pre-batch main:** `10cca8e160ebd7f1d25d3af48c2d94b69b4e64a9`; 148 entries / 102 blobs / 46 trees / `truncated=false`.
- **Connection extraction:** manual sheet UI/lifecycle moved to `lib/connection_sheet.dart`; scan coordinator, BLE/GATT ownership and P1 semantics remain with Dashboard. Source/tests are present; current-main CI validation remains required.
- **Validation Only #96:** source input `c00b7a81d777bf98e9d57796373a4606b9aaf579`; formatter/analyzer/test steps passed, but final summary failed because `main` advanced before the formatter-only push. It is not a terminal pass for current main. Validation Only #95 remains the last terminal source-validation success on SHA `e304c1fadb65af42177df41f04ff6d0bb2528b95` (230/230).
- **Current CI policy change:** main-only Validation Only becomes read-only (`contents: read`, no formatter/write/commit); the guarded Build App remains unchanged and issue/title/token gated.
- **Boundaries:** no Build App/APK/sign/release, Firmware/BIN/P1 wire changes, BLE identity/security, OTA, Firebase production, signing secrets, flashing or device operation. Whole-App visual acceptance remains **VISUAL NOT VERIFIED**.

## Evidence blockers

Flutter/Dart/Gradle/ADB are absent locally. Validation Only does not compile Kotlin/Android, and CI cannot replace Android screenshots/device/OEM checks. SQLite v1→v2 runtime fixture and representative 1h/6h/24h performance soak remain NOT RUN.

## Next action

Run exact-SHA main-only Validation Only after governance changes, then resume CODE_FULL source audit and redesign. Do not trigger Build App in this workspace.
