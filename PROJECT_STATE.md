# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-26 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner request and mode

- **Workspace:** `CODE_FULL` / **Eksekusi Code!**. Each command is one continuous full-cycle execution through the owner-authorized App-only WP0–WP10 work and build-ready handoff—not a single-file tranche.
- **Work status:** IN_PROGRESS. Continue in coherent dependency-ordered commits until source work and available acceptance gates are complete or a concrete protected/evidence boundary blocks a claim.
- **Included:** Flutter/Dart App source/tests, justified App-side Android source/config, docs, static audit and non-publishing Validation Only CI.
- **Excluded:** Build App/APK/package build, signing/release/tag/assets publication; Firmware/BIN/P1 wire changes; BLE identity/security/backend; OTA transport/trust/recovery; Firebase production; signing secrets/keystores; flashing/physical device.

## Current code/test checkpoint

- **Latest tested source/test SHA:** `59fb624120b01ba505d23691df0928e55eefed3b`.
- **Current code/test HEAD after formatter-only follow-up:** `16b9f78f384011ca59def5e0ac32bb6bc33e4178`; root tree `832dfc9b4091d73f24addece1615a12221ca17c1`; 144 entries / 98 blobs / 46 trees; `truncated=false`.
- **Validation Only #87:** run `45865736407` / job `140067960188`, terminal SUCCESS. Locked dependencies, formatter/post-format, analyzer and full Flutter tests **230/230 PASS**. Analyzer emitted 106 information-level diagnostics with `--no-fatal-infos`.
- **Latest published package:** Build #167 / immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; it predates current main and does not include these source changes.

## Implemented source increments

- **Usage Statistics Clear History:** cached Battery/Hotside values are not turned into new samples or a fake HOT receipt; coverage waits for actual HOT telemetry. Validation Only #82 passed 225/225.
- **Passive BLE rediscovery:** unawaited passive `_connect()` failures are consumed/logged. Dashboard and scan/GATT/P1 ownership remain unchanged. Validation Only #85 passed 226/226.
- **App official-build gate:** `lib/app_security.dart` isolates the existing `je_x_fyz/security` channel; Android accepts only native Boolean true, false/null/error denies, non-Android behavior is unchanged. `main.dart` delegates through `isOfficialBuild()`; TamperScreen retains developer contact. Native Kotlin certificate verification and signing config are unchanged.
- **Regression repair:** Validation Only #86 failed ten legacy widget source checks because they used the removed channel declaration as painter-section sentinel. The painter code remained. #87 uses the following `TamperApp` class boundary; all 230 tests pass.
- **Current read-back:** `lib/main.dart` blob `80360d5d5576bb6487e36ee05f0cac8c120a1a94`; `lib/app_security.dart` `d068875271d0f0ba29b7e60dfb61b1a79d984e0b`; `test/app_security_test.dart` `8dc3421643be284984015834141fe3bc156a9b27`; `test/widget_test.dart` `d6295320db42f2d3d25862b317cefbc2f4afcd63`.

## Audit, architecture and visual status

- The repository register has **98/98 file dispositions**. This is not full WP0 completion: the complete content/architecture audit of `lib/main.dart` remains OPEN.
- **Architecture:** WP2 has begun with the AppSecurity adapter; Dashboard still owns the sole BLE/GATT/P1 session, command/ACK, telemetry and screen rendering. WP2–WP8 extraction/redesign is incomplete.
- **Usage Statistics:** source/tests reviewed and Clear History freshness defect fixed. SQLite v1→v2 runtime fixture and long-session CPU/memory soak remain NOT RUN.
- **BLE App-only authorization:** BLOCKED / NOT IMPLEMENTED. Just Works + SYNC_READY does not cryptographically identify the official App; a valid solution requires separately scoped Firmware + trusted backend work.
- **Visual:** **VISUAL NOT VERIFIED**. No current-main Android screenshots for the complete screen/viewport/locale/theme/state matrix. Launcher PNG remains protected as opaque RGB without alpha; hero PNG bytes were unavailable for direct visual review.
- **Toolchain/evidence:** Flutter/Dart/Gradle/ADB absent locally. Validation Only is Flutter/Dart-only; it does not compile Kotlin/Android or prove OEM/device behavior. Current-main Android compile/device and performance soak are NOT RUN.

## Required invariants

One BLE/GATT owner; unchanged P1 framing/UUIDs/commands/SYNC/SYNC_READY; serialized writes and scan-generation invalidation; command intent vs ACK vs confirmed telemetry; SQLite schema v2/v1→v2, 30-day retention, raw 1-Hz samples, session/gap semantics, HOT-only freshness and 64+8+1 queue; JE X FYZ/Horizon identity, assets, theme, typography, localization, accessibility and Home/360-dp contracts. Native Floating Monitor remains a presentation-only projection.

## Next work

Continue complete `lib/main.dart` audit and use current callers/tests to choose the next pure, well-bounded extraction. Then progress through remaining WP2–WP10 layers, screens, Settings, Statistics, Floating Monitor and screenshot/integration validation. Keep commits coherent and run Validation Only for each source/test increment. Do not invoke Build App in this workspace.
