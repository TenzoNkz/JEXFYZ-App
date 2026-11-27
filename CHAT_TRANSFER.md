<!-- ACTIVE_CHECKPOINT_START -->

## Active checkpoint — CODE_FULL then REPO_FULL — 2026-11-27

- **Owner scope:** App-only WP0–WP10 full rework + premium UI redesign; REPO_FULL follows only after CODE_FULL closes. Build App requires fresh explicit `Eksekusi Build App!`.
- **Repository:** `TenzoNkz/JEXFYZ-App`, direct `main` only; no branches/PRs. Re-fetch HEAD/tree/target blobs before each write and use expected-HEAD updates.
- **Live main:** `1b6b38bddf902a251a385f48f921dad523ae036b`; tree `75dd8dcc790d34f7fb479f46c8307a2490d17ed9`; 164 entries / 118 blobs / 46 trees, `truncated=false`. Register reconciled to 118/118 unique paths; path coverage is not complete source-content review.
- **Validation Only #187:** run `45968056100` / job `140401426317`, exact SHA above, terminal SUCCESS — dependencies PASS; formatter 42/0; analyzer PASS (109 info-level diagnostics under `--no-fatal-infos`); **280/280 Flutter tests PASS**.
- **WP1:** seven mock-storage tests for AppSettingsStore/KnownCoolerStore are verified in #187; production keys/defaults/schema unchanged. Plugin failure injection remains open.
- **WP2/WP3:** bootstrap/root/Settings presentation and pure P1 framing/command/ACK-waiter parts are separated. Dashboard remains sole BLE/GATT/P1/session and authoritative telemetry owner.
- **WP4:** shared geometry/semantic color/typography/shape token foundation exists; remaining route-consumer audit and visual acceptance open.
- **WP5:** `dashboard_home_tab.dart`, `dashboard_control_tabs.dart` and `dashboard_temperature_tab.dart` are presentation-only Dart library parts of `main.dart`; #187 verifies current source/tests, but final redesign/screenshot acceptance remains open.
- **Still open:** full Dashboard/`main.dart` ownership/content audit and remaining large-module review; WP4 cross-route token audit; WP5 screen refinement; WP6 Connection/Settings/dialogs; WP7 Usage Statistics; WP8 Floating Monitor; WP9 screenshots/goldens/integration/platform evidence; WP10 final file/diff/governance closure.
- **Protected:** BLE/P1 UUID/framing/commands/SYNC/SYNC_READY; single BLE owner; scan generations; ACK vs telemetry confirmation; Usage Statistics v2/v1→v2/30-day/raw 1-Hz/HOT/null-gap/gap-safe 64+8+1 queue; native Canvas/WindowManager; Firmware/OTA contracts.
- **Release/evidence:** Build #167 remains latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/APK/sign/release, Firmware/BIN, P1 wire/security, OTA, Firebase production, signing, flashing or device operations. Local Flutter/Dart/Gradle/ADB unavailable; Android/Kotlin, screenshot/OEM/device, SQLite runtime fixture and performance soak NOT RUN; visual result **VISUAL NOT VERIFIED**.

<!-- ACTIVE_CHECKPOINT_END -->
