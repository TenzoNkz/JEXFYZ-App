# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner scope and repository policy

- **Workspace:** `CODE_FULL` — this conversation is the active execution workspace. Complete owner-approved App-only WP0–WP10 and evidence-backed build-ready handoff; then execute approved `REPO_FULL`.
- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`; direct commits only, no branches/PRs. Re-fetch HEAD/tree/target SHAs and use expected-HEAD updates before writes.
- **Included:** Flutter/Dart App source/tests/docs/configuration/static audit and non-publishing Validation Only CI.
- **Excluded:** Build App/APK/sign/release until a fresh `Eksekusi Build App!`; Firmware/BIN/P1 wire/behavior, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operations.

## Current source and validation

- **main:** `1b6b38bddf902a251a385f48f921dad523ae036b`; root tree `75dd8dcc790d34f7fb479f46c8307a2490d17ed9`; recursive tree 164 entries / 118 blobs / 46 trees, `truncated=false`.
- **Validation Only #187:** run `45968056100` / job `140401426317`, exact source SHA above, terminal **SUCCESS**: locked dependencies PASS; formatter 42 files / 0 changed; analyzer PASS (109 information-level diagnostics under `--no-fatal-infos`); Flutter tests **280/280 PASS**.
- **WP1 storage:** `test/app_settings_store_test.dart` adds seven mock-storage behavior tests. They cover load/save/defaults/notifier projection, firmware-notice version gating, and KnownCoolerStore trim/blank/clear. Production keys/defaults/schema/code remain unchanged. Plugin error injection and real Android storage behavior remain open/not verified.
- **WP2:** ordered startup/security/cloud bootstrap, injected App root and Settings presentation have been separated while preserving the official-build-first gate and platform behavior.
- **WP3:** pure P1 frame decoder, pure command classification and per-item FIFO ACK waiter lifecycle are isolated. Dashboard remains the only BLE/GATT/P1/session/telemetry owner.
- **WP4:** shared geometry/semantic color/typography/shape token foundation exists; cross-route consumer audit and actual visual acceptance remain open.
- **WP5:** Home, Voltage/Control/Adaptive/LED and Temperature presentation builders are split into `dashboard_home_tab.dart`, `dashboard_control_tabs.dart` and `dashboard_temperature_tab.dart` parts of `main.dart`. #187 verifies the extraction with the full suite; Dashboard owner audit and final screen/design review remain open.
- **WP6–WP10:** Connection/Settings/dialog polish; Usage Statistics architecture/UI; Floating Monitor Flutter/native split; deterministic visual/integration/platform evidence; and final file/diff/governance closure remain open.

## Protected contracts and evidence limits

P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; ACK vs telemetry-confirmed physical outputs; settings keys/defaults and Usage Statistics v2/v1→v2, 30-day retention, raw 1-Hz/HOT freshness/null gaps/64+8+1; native Canvas/WindowManager; existing brand, theme/assets/localization and 360-dp canvas remain protected.

Flutter/Dart/Gradle/ADB are unavailable locally. Hosted Validation Only does not compile Android/Kotlin or prove OEM/device behavior. Android/Kotlin compilation, actual screenshots/device/OEM, SQLite v1→v2 runtime fixture, 1h/6h/24h performance profile and whole-App visual acceptance remain NOT RUN / **VISUAL NOT VERIFIED**.

Build #167 remains the latest published App package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/release, Firmware/BIN, OTA, Firebase production, signing, flashing or device operation occurred.

## Next action

Reconcile the Dashboard/main ownership graph and remaining WP4 token consumers against live source, then continue behavior-preserving WP5/WP6 screen work. Group related changes and validate before commit. Do not claim visual/platform acceptance without actual evidence.
