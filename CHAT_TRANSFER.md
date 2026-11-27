<!-- ACTIVE_CHECKPOINT_START -->

## Active checkpoint — CODE_FULL then REPO_FULL — 2026-11-27

- **Owner scope:** complete approved App-only WP0–WP10 through evidence-backed build-ready handoff; REPO_FULL follows after CODE_FULL. Build App requires fresh `Eksekusi Build App!`.
- **Repository:** `TenzoNkz/JEXFYZ-App`, direct `main` only; no branches/PRs. Re-fetch HEAD, target blobs and tree before every write; expected-HEAD protection.
- **Current main:** `f78d6b1294c88cb359b694041ea70dde0042bcd8`; root tree `3aa34e8f5c153d4979b120f7a5ae87c7c9c78596`; 159 entries / 113 blobs / 46 trees, `truncated=false`. Register: 113/113 unique path dispositions.
- **Validated source/test:** Validation Only #158 / run `45951691490` / job `140348775364`, exact SHA `f78d6b1294c88cb359b694041ea70dde0042bcd8`, terminal SUCCESS: dependencies, formatter (37/0), analyzer and **259/259 Flutter tests** PASS.
- **WP3:** `p1_frame_decoder.dart`, `p1_command_contract.dart` and `p1_ack_waiters.dart` are narrow pure boundaries. Dashboard remains sole BLE/GATT/P1/session owner; it retains write/transaction ordering, SYNC/SYNC_READY, reconnect and telemetry confirmation.
- **WP4:** shared tokens include existing typography/input-shape dimensions and semantic ColorScheme roles; theme builders and Settings consume them without changing current palette/values. Cross-route adoption and real screenshot acceptance remain open.
- **Next:** finish WP4 shared-token route audit, then WP5 Home and five control surfaces. Preserve the 360-dp canvas, cooler geometry, seven metric rows, commands and telemetry semantics.
- **Protected:** P1 UUID/framing/commands; one BLE owner; scan serialization/generation; ACK vs telemetry truth; Usage Statistics v2/v1→v2, 30-day, raw 1-Hz, HOT freshness/null gaps/gap-safe decimation/64+8+1; native Canvas/WindowManager; Firmware/OTA boundaries.
- **Release/evidence:** Build #167 remains latest published package on `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. Android/Kotlin, screenshots/OEM/device, SQLite fixture and performance profile NOT RUN; visual status **VISUAL NOT VERIFIED**. No Build App/APK/sign/release, Firmware/BIN, P1 wire changes, BLE identity/security, OTA, Firebase production, flashing or device operations.

<!-- ACTIVE_CHECKPOINT_END -->
