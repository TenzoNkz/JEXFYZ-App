# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner scope and repository policy

- **Workspace:** `CODE_FULL` — complete owner-approved App-only WP0–WP10 and evidence-backed build-ready handoff; then execute approved `REPO_FULL`.
- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`; direct commits only, no branches/PRs. Re-fetch HEAD/tree/target SHAs and use expected-HEAD updates before writes.
- **Included:** Flutter/Dart App source/tests/docs/configuration/static audit and non-publishing Validation Only CI.
- **Excluded:** Build App/APK/sign/release until a fresh `Eksekusi Build App!`; Firmware/BIN/P1 wire/behavior, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operations.

## Current source and validation

- **main:** `ca98699bd8404b12a082d21e1a74727c468dd3ce`; root tree `cdd314967d8e15356fdd3f9f723e624b59648a5c`; recursive tree **165 entries / 119 blobs / 46 trees**, `truncated=false`.
- **Validation Only #194:** run `45983828867` / job `140454219639`, exact source SHA above, terminal **SUCCESS**: locked dependencies PASS; formatter 43 files / 0 changed; analyzer PASS (110 information-level diagnostics, zero warnings/errors under `--no-fatal-infos`); Flutter tests **281/281 PASS**.
- **WP1 storage:** `test/app_settings_store_test.dart` adds seven mock-storage behavior tests. Production keys/defaults/schema unchanged. Plugin error injection and real Android storage behavior remain open/not verified.
- **WP2/WP3:** ordered bootstrap, App root, Settings presentation, pure P1 frame decoder, pure command contract and FIFO ACK-waiter lifecycle are separated. Dashboard remains the only BLE/GATT/P1/session/telemetry/command authority.
- **WP4:** shared geometry/semantic color/typography/shape token foundation exists; cross-route consumer audit and actual visual acceptance remain open.
- **WP5 Batch 1:** new `lib/dashboard_shared_components.dart` contains reusable Dashboard Card and section heading components. Twelve Card and seven heading call sites moved from `main.dart` to Control/Temperature presentation parts. Widget contract test verifies established geometry, theme surface/border/shadow and title typography; exact source passed #194. No Dashboard state/command/telemetry ownership moved.
- **WP5 remaining:** extract the shared row/toggle/scroll presentation helpers as a separate next batch, then refine Home/Control/Adaptive/LED/Temperature screens; do not treat structural extraction as full visual acceptance.
- **WP6–WP10:** Connection/Settings/dialog polish; Usage Statistics architecture/UI; Floating Monitor Flutter/native split; deterministic visual/integration/platform evidence; final file/diff/governance closure remain open.

## Protected contracts and evidence limits

P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; ACK vs telemetry-confirmed physical outputs; settings keys/defaults and Usage Statistics v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT-only P1 freshness, explicit null gaps and bounded queue; native Canvas/WindowManager; brand, theme/assets/localization and 360-dp canvas/DPI behavior remain protected.

Flutter/Dart/Gradle/ADB are unavailable locally. Hosted Validation Only does not compile Android/Kotlin or prove OEM/device behavior. Android/Kotlin compilation, actual screenshots/device/OEM, SQLite v1→v2 runtime fixture, 1h/6h/24h performance profile and whole-App visual acceptance remain NOT RUN / **VISUAL NOT VERIFIED**.

Build #167 remains the latest published App package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/release, Firmware/BIN, OTA, Firebase production, signing, flashing or device operation occurred.

## Next action

Continue WP5 with one bounded extraction batch for the shared Control row, toggle and scroll-list presentation helpers. Preserve Dashboard as sole state/session/command owner, update source-contract tests to follow the new part, and run exact-SHA Validation Only before selecting another batch.
