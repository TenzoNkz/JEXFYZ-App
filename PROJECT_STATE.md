# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Owner scope and repository policy

- Workspace CODE_FULL — owner-approved incremental App-only WP0–WP10 rework and premium UI redesign. REPO_FULL follows only after CODE_FULL closes.
- Repository TenzoNkz/JEXFYZ-App; `main` is the sole active/integration branch.
- ChatGPT/Codex is the sole implementation author and reviewer, committing scoped App source/tests/docs/config directly to main. No Copilot, external coding agents, branches or PR handoffs.
- Included: Flutter/Dart App source/tests/docs/config/static audit and non-publishing Validation Only.
- Excluded: Build App/APK/sign/release unless a fresh explicit command; Firmware/BIN/P1 wire/security/behavior; OTA transport/trust/recovery; Firebase production/backend mutation; signing material; flashing or physical device operation.

## Current implementation and validation

- Last tested App source SHA: `828c42c8c6d7ac17bab0e168ac6fbf063d5abcae`; source tree `dfacea99e0d04b38f6f8ebfd2b1ced63c50a95fd`, 171 entries / 125 blobs / 46 trees, `truncated=false`.
- Validation Only #247 / run `46056210434` / job `140699207905`, exact SHA above, terminal SUCCESS: dependencies PASS; formatter 49 files / 0 changed; analyzer PASS with 135 information diagnostics under `--no-fatal-infos`; **317/317 Flutter tests PASS**.
- WP5 lock-menu extraction commits: `900740e1ad85ed71dd6e18780c5153799c12d37a` → `4e7e66b8bf1a78faff9dbfe1ecc92fbbd33a913a` → `2239405b9c616abdbc61d0aa27bc88fd6572c715` → `828c42c8c6d7ac17bab0e168ac6fbf063d5abcae`. New `lib/dashboard_display_menu.dart` owns lock reason selection and stateless rendering only. Dashboard supplies live values and existing guarded Connect callback; it remains the single BLE/GATT/P1/session/ACK/telemetry/command owner.
- Changed code/test paths: new `lib/dashboard_display_menu.dart`; updated `lib/main.dart`, `lib/jex_animated_icon.dart`, `test/widget_test.dart`, `test/device_copy_notification_contract_test.dart`; new `test/dashboard_display_menu_test.dart`.
- No UUID/framing/command/SYNC changes, no scanner/ACK ownership movement, no storage identity/schema, OTA, Firebase production, native service or build/release path changes.
- WP1: AppSettingsStore/KnownCoolerStore have 14 plugin-mock tests (7 normal + 7 failure injection); preference/identity keys and defaults/schema unchanged. The prior WP0 full review of `lib/app_settings.dart` and 353 bilingual localization/placeholder audit is recorded KEEP/VERIFIED. Actual Android keystore remains unverified.
- WP8 Flutter mock tests: 4 FloatingStore schema-v2 persistence cases (#220) + 10 FloatingBridge MethodChannel tests (#223). Kotlin service/WindowManager/Canvas/OEM behavior unverified; same-session native service recovery remains an owner product decision.

## Current work and remaining acceptance

- Full `lib/main.dart` Dashboard ownership/content audit is still open; map state variables, mutation sites, callers, lifecycle, external effects, tests and source contracts before a further extraction.
- WP4 semantic token role classification and WP5 screen refinements for Home, Voltage, Control, Adaptive, LED and Temperature remain open.
- WP6 Connection/Settings/subpages/dialogs/sheets; WP7 Usage Statistics; WP8 Floating Monitor configuration/store/bridge/native boundary; WP9 visual/golden/integration/platform evidence; WP10 final file/diff/governance closure remain open.
- Usage Statistics invariants: schema v2/v1→v2 migration, 30-day retention, raw 1-Hz samples, session/timestamp semantics, HOT-only freshness, explicit null gaps, gap-safe decimation, bounded 64+8+1 queue; profile 1h/6h/24h before optimization.
- Visual constraints: Quiet Luxury / Precision Instrument, existing brand/assets/font/palette, seven Home metric rows, 360-dp canvas/DPI scaling, EN/ID, semantic Light/Dark, accessibility/focus/reduced motion. No VISUAL PASS without actual Android/OEM screenshots.

## Evidence limits and release boundary

Local Flutter/Dart/Gradle/ADB unavailable. Hosted Validation Only does not compile Android/Kotlin or prove device behavior. Android/Kotlin compile, physical secure storage, native overlay, Android/OEM screenshots, SQLite v1→v2 runtime fixture and 1h/6h/24h profile remain NOT RUN. Overall result **VISUAL NOT VERIFIED**.

Build #167 remains latest published App package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/APK/sign/release, Firmware/BIN, P1 wire/security, OTA, Firebase production, signing, flash or device operation occurred.

## Next action

Continue complete live `lib/main.dart` Dashboard state, caller, side-effect and test-coverage audit from source SHA `828c42c8c6d7ac17bab0e168ac6fbf063d5abcae`. Keep Dashboard the single BLE/GATT/P1/session/telemetry/command owner.
