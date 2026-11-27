# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner scope and repository policy

- **Workspace:** `CODE_FULL` / Eksekusi Code. Complete App-only WP0–WP10 and build-ready handoff, then the approved REPO_FULL cleanup cycle.
- **Repository:** direct commits to `main` only; no secondary branches or PRs. Prior live preflight found one branch (`main`) and an empty rulesets response.
- **Execution writer:** owner designates this CODE_FULL chat as the sole execution conversation. Re-fetch live `main`, target file SHAs and base tree before each commit; expected-HEAD updates only.
- **Included:** App Flutter/Dart source/tests/docs/config and static audit.
- **Excluded:** Build App/APK/sign/release until a fresh explicit `Eksekusi Build App!`; Firmware/BIN/P1 wire/functional changes, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operation.

## Current source checkpoint

- **main:** `3cd16490c3f9b0b73c86fc1df1ad78d0fa24ed17`; root tree `5bf70519bd284a5481e9cdf63e9f1efa1892c8b8`; recursive tree 157 entries / 111 blobs / 46 trees, `truncated=false`.
- **Validated App source/test SHA:** `0448d03c39536c57ad7e8c2d36718d525d2d60fb` (current main is a documentation-only descendant); register 111/111 unique path dispositions.
- **Validation Only #148:** run `45943879592` / job `140324041087`, terminal SUCCESS on exact source/test SHA: dependencies PASS; formatter PASS (35 files / 0 changed); analyzer PASS; Flutter tests **253/253 PASS**.
- **WP2:** ordered bootstrap in `app_bootstrap.dart`; Settings presentation in `settings_pages.dart`; injected root in `app_root.dart`. Existing verifier, preferences and Floating Monitor bridge/native renderer remain unchanged.
- **WP3:** `p1_frame_decoder.dart` pure framing; `p1_command_contract.dart` pure command classification. Dashboard remains sole BLE/GATT/P1/session owner and retains writes, transaction sequencing, ACK waiters, SYNC/SYNC_READY, reconnect and authoritative telemetry.
- **WP4 foundation:** `jex_design_tokens.dart` centralizes approved dimensions and semantic ColorScheme roles; screen integration and visual acceptance remain open.
- **Release:** Build #167 remains latest package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged.
- **Evidence limits:** Flutter/Dart/Gradle/ADB unavailable locally. Android/Kotlin, screenshots/OEM/device, SQLite runtime fixture and 1h/6h/24h profiling NOT RUN. Visual outcome **VISUAL NOT VERIFIED**.


## Protected contracts and evidence

P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; serialized scan invalidation; command intent vs ACK vs telemetry-confirmed outputs; Usage Statistics schema v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT freshness, null gaps and 64+8+1 queue; application identity, settings persistence, theme/assets/localization and 360-dp canvas remain protected.

Flutter/Dart/Gradle/ADB unavailable locally. Hosted Validation Only does not compile Android/Kotlin or prove screenshots/device/OEM behavior. Visual acceptance remains **VISUAL NOT VERIFIED**. SQLite migration runtime fixture and long-session performance soak remain NOT RUN.

## Next action

Reconcile Validation Only #118 on exact `4c5feb51c8777b0576d0ac11f3fafb921db91b38`; continue WP2 App root/shared-core extraction and WP3 Dashboard/device-session characterization. After CODE_FULL closes, execute the approved REPO_FULL cycle. Do not invoke Build App.
