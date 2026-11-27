# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Owner scope and repository policy

- Workspace: CODE_FULL — complete owner-approved App-only WP0–WP10 and evidence-backed build-ready handoff; then execute approved REPO_FULL.
- Repository: TenzoNkz/JEXFYZ-App, branch main; direct commits only, no branches/PRs. Re-fetch HEAD/tree/target SHAs and use expected-HEAD updates before writes.
- Included: Flutter/Dart App source/tests/docs/configuration/static audit and non-publishing Validation Only CI.
- Excluded: Build App/APK/sign/release until a fresh Eksekusi Build App!; Firmware/BIN/P1 wire/behavior, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operations.

## Current source and validation

- Validated source: `a2f4c4f467ece3bfd37981f8e9176a71d7419c28`; recursive tree 166 entries / 120 blobs / 46 trees, `truncated=false`.
- Validation Only #205: run `45994605388` / job `140490735361`, exact source SHA above, terminal SUCCESS: locked dependencies PASS; formatter 44 files / 0 changed; analyzer PASS; Flutter tests **285/285 PASS**.
- WP1 storage: test/app_settings_store_test.dart adds seven mock-storage behavior tests. Production keys/defaults/schema unchanged. Plugin error injection and real Android storage behavior remain open/not verified.
- WP2/WP3: ordered bootstrap, App root, Settings presentation, pure P1 frame decoder, pure command contract and FIFO ACK-waiter lifecycle are separated. Dashboard remains the only BLE/GATT/P1/session/telemetry/command authority.
- WP4: shared layout/semantic color/typography/shape token foundation exists; static consumer audit is underway across Dashboard, Settings, Statistics, LED/Floating Monitor and Home notification. Preserve screen-specific density and measured plot geometry; visual acceptance remains open.
- WP5 Batch 1: lib/dashboard_shared_components.dart contains reusable JexDashboardCard and JexDashboardSectionTitle. Twelve Card and seven heading call sites moved from main.dart to Control/Temperature presentation parts. Widget contract test verifies established geometry, theme surface/border/shadow and title typography; exact source passed #194. No Dashboard state/command/telemetry ownership moved.
- WP5 Batch 2: lib/dashboard_control_components.dart extracts _switchRow, _jexToggle and _smoothList into a state-bound presentation extension. Control and Temperature callsites use the extension; widget and Firmware QC source-contract tests follow the new part location. Exact source passed #198, 281/281 tests. Runtime BLE/GATT/P1/session/command ownership remains in Dashboard.
- WP5 Batch 3: keyed Dashboard content transition (210-ms fade + approximately 5.4-dp slide; 90-ms fade under reduced motion), outgoing tab pointer/semantics isolation, active-tab semantics at the first frame, unique toggle key ownership and regression tests. Validation Only #205 passed on exact source above.
- WP5 remaining: refine Home/Control/Adaptive/LED/Temperature screen composition, visual hierarchy, responsive fit and accessibility only where current source/test/visual evidence identifies a bounded issue; do not claim screenshot acceptance without device captures.
- WP6–WP10: Connection/Settings/dialog polish; Usage Statistics architecture/UI; Floating Monitor Flutter/native split; deterministic visual/integration/platform evidence; final file/diff/governance closure remain open.

## Protected contracts and evidence limits

P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; ACK vs telemetry-confirmed physical outputs; settings keys/defaults and Usage Statistics v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT-only P1 freshness, explicit null gaps and bounded queue; native Canvas/WindowManager; brand, theme/assets/localization and 360-dp canvas/DPI behavior remain protected.

Flutter/Dart/Gradle/ADB are unavailable locally. Hosted Validation Only does not compile Android/Kotlin or prove OEM/device behavior. Android/Kotlin compilation, actual screenshots/device/OEM, SQLite v1→v2 runtime fixture, 1h/6h/24h performance profile and whole-App visual acceptance remain NOT RUN / VISUAL NOT VERIFIED.

Build #167 remains the latest published App package on immutable source 0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81; current main is not packaged. No Build App/release, Firmware/BIN, OTA, Firebase production, signing, flashing or device operation occurred.

## Next action

Continue WP4 cross-route design-token audit. Classify repeated values by semantic role, promote only demonstrably equivalent constants, preserve one-off chart/telemetry/canvas geometry, add targeted tests and validate the next source batch with exact-SHA Validation Only.
