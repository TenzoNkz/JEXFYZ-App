<!-- ACTIVE_CHECKPOINT_START -->

## Active checkpoint — CODE_FULL then REPO_FULL — 2026-11-27

- **Owner scope:** App-only WP0–WP10 full rework + premium UI redesign; REPO_FULL follows only after CODE_FULL closes. Build App requires fresh explicit `Eksekusi Build App!`.
- **Repository:** `TenzoNkz/JEXFYZ-App`, direct `main` only; no branches/PRs. Re-fetch HEAD/tree/target blobs before each write and use expected-HEAD updates.
- **Live main:** `ca98699bd8404b12a082d21e1a74727c468dd3ce`; root tree `cdd314967d8e15356fdd3f9f723e624b59648a5c`; 165 entries / 119 blobs / 46 trees, `truncated=false`. Register reconciled to 119/119 unique paths; path coverage is not complete source-content review.
- **Latest exact-SHA validation:** Validation Only #194 / run `45983828867` / job `140454219639`, exact source SHA above, terminal **SUCCESS** — locked dependencies PASS; formatter 43 files / 0 changed; analyzer PASS (110 information-level diagnostics, zero warnings/errors under `--no-fatal-infos`); **281/281 Flutter tests PASS**.
- **WP1:** seven mock-storage tests for AppSettingsStore/KnownCoolerStore are verified in #187; production keys/defaults/schema unchanged. Plugin failure injection remains open.
- **WP2/WP3:** bootstrap/root/Settings presentation and pure P1 framing/command/ACK-waiter parts are separated. Dashboard remains sole BLE/GATT/P1/session/telemetry/command owner.
- **WP4:** shared geometry/semantic color/typography/shape token foundation exists; remaining route-consumer audit and visual acceptance open.
- **WP5 Batch 1:** new `lib/dashboard_shared_components.dart` provides `JexDashboardCard` and `JexDashboardSectionTitle`. Twelve Card and seven heading call sites moved from Dashboard state into Control/Temperature presentation parts. Exact prior style geometry and semantic theme roles are retained; widget test checks the visual property contract. Validation Only #194 verifies the exact source SHA.
- **Still open:** full Dashboard/`main.dart` ownership/content audit and remaining large-module review; WP4 cross-route token audit; WP5 remaining row/toggle/list extraction and screen refinement; WP6 Connection/Settings/dialogs; WP7 Usage Statistics; WP8 Floating Monitor; WP9 screenshots/goldens/integration/platform evidence; WP10 final file/diff/governance closure.
- **Protected:** BLE/P1 UUID/framing/commands/SYNC/SYNC_READY; single BLE owner; scan generations; ACK vs telemetry confirmation; Usage Statistics v2/v1→v2/30-day/raw 1-Hz/HOT/null-gap/gap-safe 64+8+1 queue; native Canvas/WindowManager; Firmware/OTA contracts.
- **Release/evidence:** Build #167 remains latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/APK/sign/release, Firmware/BIN, P1 wire/security, OTA, Firebase production, signing, flashing or device operations. Local Flutter/Dart/Gradle/ADB unavailable; Android/Kotlin, screenshot/OEM/device, SQLite runtime fixture and performance soak NOT RUN; visual result **VISUAL NOT VERIFIED**.

<!-- ACTIVE_CHECKPOINT_END -->