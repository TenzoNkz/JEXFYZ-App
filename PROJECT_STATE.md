# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-26T22:55:00+07:00 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Current owner request and execution mode

- **Workspace:** `CODE_FULL` / **Eksekusi Code!**. The owner clarified that each command means one continuous full-cycle execution through all currently authorized App-only WP0–WP10 work and a verified build-ready handoff—not a single-file tranche followed by a request to continue. This rule is in `MASTER_PROMPT.md` and Prompt 2 of `CHAT_TRANSFER_PROMPTS.md`.
- **Work status:** IN_PROGRESS. Continue incrementally and in dependency order. Do not mark blocked, unverified or unimplemented work as complete.
- **Scope:** Flutter/Dart App source, tests, App-side Android code/config justified by App scope, docs, static audits and available non-publishing Validation Only CI.
- **Excluded:** Build App/APK/package build, signing/release/tags/assets publication; Firmware/BIN/protocol; BLE identity/security/backend; OTA transport/trust/recovery; Firebase production changes; signing secrets/keystores; flashing and physical devices. Build App remains separately authorized only by a fresh explicit owner command.

## Current main and validation

- **Canonical repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Current HEAD:** `9317f70f164ab28ae0c590af1459903501ea1543`; root tree `cf22f0bf44e03feeda8d0321b5944cc4d2d69459`. Recursive inventory: 142 entries / 96 blobs / 46 trees; truncated=false.
- **Latest Validation Only:** #82 / run `45858238070` / job `140042152884`; terminal SUCCESS on source/test SHA `b5b11ac0f37c201b51f1cfb0e816ee56813f1d1b`. Locked dependencies, Dart formatter/post-format, analyzer and Flutter tests **225/225 PASS**. Current HEAD also contains only the CI formatter-only follow-up `8b5b662725cfcf5b5b084209ed97989361148d13` for `lib/usage_statistics.dart` and `test/usage_statistics_test.dart`.
- **Latest published package:** Build #167 / source SHA `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`. It predates the current main changes and is historical evidence only, not a package of current HEAD.
- **Latest source correction:** Usage Statistics Clear History no longer reclassifies cached Battery/Hotside readings as new samples or advances P1 HOT freshness. A real HOT telemetry receipt is required before the new session has P1 coverage. The exact behavior and regression are recorded in `APP_NOTES.md` and `CHANGELOG.md`.

## Audit, architecture and visual status

- `REPOSITORY_UPGRADE_PLAN.md` contains an explicit disposition for all 96 tracked files. This is not full WP0 completion: `lib/main.dart` remains an open full-file content/architecture audit. Several earlier native/config files are KEEP / VERIFIED; the six-plus previously formatter-touched Dart/test files have now been inspected.
- **Architecture:** WP2–WP8 are not complete. `lib/main.dart` remains the largest concentration of dashboard, BLE/P1 session, command, telemetry, OTA presentation orchestration and screen UI responsibilities. No risky big-bang extraction or redesign has been declared complete.
- **Usage Statistics:** whole `lib/usage_statistics.dart` and `test/usage_statistics_test.dart` reviewed; Clear History freshness bug fixed. No actual SQLite v1→v2 fixture/integration run or long-duration Android performance soak was performed.
- **BLE App-only authorization:** BLOCKED / NOT IMPLEMENTED. Existing Just Works + SYNC_READY does not cryptographically authenticate the official App. A valid solution requires separately scoped Firmware and trusted backend enrollment/grant design; no static APK secret/first-peer shortcut was introduced.
- **Visual:** **VISUAL NOT VERIFIED**. No current-main Android screenshots exist for the full Home/control/Connection/Settings/Statistics/Floating Monitor locale/theme/viewport matrix. The launcher icon remains an opaque RGB asset despite the documented transparency target; protected pending a separate design decision. The cooler hero binary could not be inspected directly in this workspace and remains protected.
- **Toolchain:** Flutter/Dart/Gradle/ADB are not available locally. Validation Only runs Flutter/Dart only; it does not compile Kotlin/Android or prove API/OEM behavior. Current-main Android compile and device validation are NOT RUN.

## Required invariants

Single BLE/GATT owner; immutable P1 framing/UUID/commands and SYNC/SYNC_READY gate; serialized writes and scan-generation invalidation; command intent vs ACK vs confirmed telemetry; SQLite schema v2 / v1→v2 migration, 30-day retention, raw 1-Hz, session/gap semantics, HOT-only freshness and 64+8+1 queue; preserve JE X FYZ/Horizon identity, asset, theme, type, localization, accessibility and approved Home contracts. Native Floating Monitor remains a presentation-only projection of Flutter-owned telemetry.

## Next work

Continue the full `lib/main.dart` audit, map the current owners/callers before WP2/WP3 extraction, then progress through design system/screens and native visual work only where evidence and authorization permit. Keep commits coherent; run Validation Only on every source/test increment. Do not proceed to Build App from this workspace.
