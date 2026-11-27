<!-- ACTIVE_CHECKPOINT_START -->

## Active checkpoint — CODE_FULL then REPO_FULL — 2026-11-27

- **Owner scope:** continue approved App-only WP0–WP10 through evidence-backed build-ready handoff; then execute approved REPO_FULL cleanup. Build App requires fresh `Eksekusi Build App!`.
- **Repository:** `TenzoNkz/JEXFYZ-App`, direct `main` only; no branches or PRs. Re-fetch HEAD and target blobs before every write; use the current blob SHA for each sequential update.
- **Current main:** `a695248a7b3967b59606f7a8ba68b967a278bbb7`; recursive tree `5bf70519bd284a5481e9cdf63e9f1efa1892c8b8`, 157 entries / 111 blobs / 46 trees, `truncated=false`. Register: 111/111 unique path dispositions.
- **Validated source/test SHA:** `0448d03c39536c57ad7e8c2d36718d525d2d60fb`; Validation Only #148 / run `45943879592` / job `140324041087`, terminal SUCCESS: locked dependencies, formatter (35 files / 0 changed), analyzer and **253/253 Flutter tests** PASS. Current main is documentation-only after that source revision.
- **WP2:** bootstrap in `app_bootstrap.dart`; Settings presentation in `settings_pages.dart`; injected App shell in `app_root.dart`. Existing verifier, storage identities/defaults and Floating Monitor bridge/native service unchanged.
- **WP4 foundation:** `jex_design_tokens.dart` centralizes approved geometry and semantic roles; no palette/brand/assets/Home redesign implied. Cross-screen integration remains open.
- **WP3:** `p1_frame_decoder.dart` owns partial buffering/frame boundaries; `p1_command_contract.dart` owns pure command classification. Dashboard remains sole BLE/GATT/P1/session owner and retains writes, transaction ordering, ACK waiters, SYNC/SYNC_READY, reconnect, telemetry and output confirmation.
- **Next WP3 action:** characterize/extract only per-item FIFO ACK waiter lifecycle: timeout removal, exact cancellation after failed GATT write, DISCONNECTED/CANCELLED bulk completion. Keep BLE transport/session and telemetry authority in Dashboard.
- **Protected:** P1 UUID/framing/commands; scan serialization/generation; ACK vs telemetry truth; Usage Statistics v2/v1→v2, 30-day, raw 1-Hz, HOT freshness/null gaps/gap-safe decimation/64+8+1; native Canvas/WindowManager renderer.
- **Evidence limits:** Build #167 latest published package on `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. Local Flutter/Dart/Gradle/ADB unavailable. Android/Kotlin, screenshots/OEM/device, SQLite fixture and performance profile NOT RUN. Visual acceptance **VISUAL NOT VERIFIED**.
- **No side effects:** no Build App/APK/sign/Release, Firmware/BIN, P1 wire change, BLE identity/security, OTA, Firebase production, flashing or physical device operation.

<!-- ACTIVE_CHECKPOINT_END -->
