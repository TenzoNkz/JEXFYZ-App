# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Active handover — CODE_FULL, then REPO_FULL

- **Owner scope:** finish approved App-only WP0–WP10 and evidence-backed build-ready handoff; then run approved REPO_FULL cleanup. Build App requires fresh `Eksekusi Build App!`.
- **Repository:** `TenzoNkz/JEXFYZ-App`, `main` only; direct commits, no secondary branches/PRs. Re-fetch HEAD, target blobs and tree before each write; expected-HEAD protection.
- **Current main:** `b77a534c8e61cc287f06244a23f4f5d6293ae27f`; root tree `5bf70519bd284a5481e9cdf63e9f1efa1892c8b8`; 157 entries / 111 blobs / 46 trees, `truncated=false`. Upgrade register: 111/111 unique path dispositions.
- **Validated source/test:** `0448d03c39536c57ad7e8c2d36718d525d2d60fb`; Validation Only #148 / run `45943879592` / job `140324041087`, terminal SUCCESS — locked dependencies, formatter (35 files / 0 changed), analyzer and **253/253 Flutter tests** PASS. Current main is a docs-only descendant.
- **WP2:** bootstrap in `app_bootstrap.dart`; Settings in `settings_pages.dart`; injected App shell in `app_root.dart`. Existing verifier, persisted keys/defaults and Floating Monitor bridge/native lifecycle unchanged.
- **WP3:** `p1_frame_decoder.dart` owns P1 stream framing only; `p1_command_contract.dart` pure command classification only. Dashboard remains sole BLE/GATT/P1/session owner and retains write serialization, transactions, ACK waiters, SYNC/SYNC_READY, reconnect and telemetry truth. Next: test/extract only per-item FIFO ACK waiter lifecycle.
- **WP4 foundation:** `jex_design_tokens.dart` centralizes approved geometry and semantic roles; cross-screen adoption and screenshot acceptance remain open.
- **Protected:** P1 UUID/framing/commands/SYNC; one BLE owner; scan generations; ACK vs telemetry-confirmed state; Usage Statistics schema v2/v1→v2/30-day/1-Hz/HOT/null-gaps/64+8+1; native Canvas/WindowManager; app identity and OTA/Firmware boundaries.
- **Latest package:** Build #167 only, source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`. Current main is not released. No Build App/APK/sign/Release, Firmware/BIN, OTA, Firebase production, flashing or device operation.
- **Evidence blockers:** local Flutter/Dart/Gradle/ADB absent. Android/Kotlin, screenshot/OEM review, SQLite fixture and long-session profile NOT RUN. Visual acceptance **VISUAL NOT VERIFIED**.

## Next action

Continue WP3 by extracting the tested per-item FIFO ACK waiter lifecycle without relocating BLE/GATT/session or physical telemetry ownership. Run focused tests and Validation Only before wider screen redesign.
