# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner scope and repository policy

- **Workspace:** `CODE_FULL` / Eksekusi Code. Complete App-only WP0–WP10 and build-ready handoff, then the approved REPO_FULL cleanup cycle.
- **Repository:** direct commits to `main` only; no secondary branches or PRs. Prior live preflight found one branch (`main`) and an empty rulesets response.
- **Execution writer:** owner designates this CODE_FULL chat as the sole execution conversation. Re-fetch live `main`, target file SHAs and base tree before each commit; expected-HEAD updates only.
- **Included:** App Flutter/Dart source/tests/docs/config and static audit.
- **Excluded:** Build App/APK/sign/release until a fresh explicit `Eksekusi Build App!`; Firmware/BIN/P1 wire/functional changes, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operation.

## Current source checkpoint

- **main:** `4c5feb51c8777b0576d0ac11f3fafb921db91b38`; root tree `a7474fc394c6b070de0195e82b53127a63e0bf38`; recursive tree 150 entries / 104 blobs / 46 trees, `truncated=false`.
- **Register:** 104 unique path dispositions are being reconciled against the 104 live blobs; no source path is missing from the live tree.
- **WP2 bootstrap:** `lib/app_bootstrap.dart` owns ordered official-install verification, secure preference restore, best-effort Firebase/App Check, portrait setup and root launch. Startup behavior and failure policy have five targeted regression cases.
- **WP2 Settings:** `lib/settings_pages.dart` is a part of `floating_monitor.dart`; Settings root/subpages were moved without changing storage keys, FloatingConfig, bridge, native renderer or telemetry.
- **Device authority:** `main.dart` / Dashboard remains the single BLE/GATT/P1 session owner; no protocol/command/session behavior was changed by these extractions.
- **CI:** Validation Only #116 on SHA `65d324f0a96ae6815a873413f49926017908bf49` passed locked dependencies, analyzer and 239/239 tests; read-only formatter failed. Validation Only #118 is pending/in progress on exact source SHA `4c5feb51c8777b0576d0ac11f3fafb921db91b38`.
- **Latest published package:** Build #167 / immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main remains unreleased.

## Protected contracts and evidence

P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; serialized scan invalidation; command intent vs ACK vs telemetry-confirmed outputs; Usage Statistics schema v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT freshness, null gaps and 64+8+1 queue; application identity, settings persistence, theme/assets/localization and 360-dp canvas remain protected.

Flutter/Dart/Gradle/ADB unavailable locally. Hosted Validation Only does not compile Android/Kotlin or prove screenshots/device/OEM behavior. Visual acceptance remains **VISUAL NOT VERIFIED**. SQLite migration runtime fixture and long-session performance soak remain NOT RUN.

## Next action

Reconcile Validation Only #118 on exact `4c5feb51c8777b0576d0ac11f3fafb921db91b38`; continue WP2 App root/shared-core extraction and WP3 Dashboard/device-session characterization. After CODE_FULL closes, execute the approved REPO_FULL cycle. Do not invoke Build App.
