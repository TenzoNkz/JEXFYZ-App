# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Owner scope and repository policy

- **Workspace:** `CODE_FULL` / Eksekusi Code. Complete App-only WP0–WP10 and build-ready handoff, then the approved REPO_FULL cleanup cycle.
- **Repository:** direct commits to `main` only; no secondary branches or PRs. Prior live preflight found one branch (`main`) and an empty rulesets response.
- **Execution writer:** owner designates this CODE_FULL chat as the sole execution conversation. Re-fetch live `main`, target file SHAs and base tree before each commit; expected-HEAD updates only.
- **Included:** App Flutter/Dart source/tests/docs/config and static audit.
- **Excluded:** Build App/APK/sign/release until a fresh explicit `Eksekusi Build App!`; Firmware/BIN/P1 wire/functional changes, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operation.

## Current source checkpoint

- **main:** `d5228516e825a3e7b9ae72bcea8239bb90b32d38`; root tree `5260bcbc9bb520975c5d4cfc551938c750c7aafb`; recursive tree 160 entries / 114 blobs / 46 trees, `truncated=false`.
- **File register:** 114/114 unique tracked blob dispositions; the two ACK-waiter module/test paths are now included. A complete disposition is not proof of complete WP0–WP10 content review.
- **Validation Only #166:** run `45956791122` / job `140365017067`, terminal SUCCESS on exact source/test SHA `d5228516e825a3e7b9ae72bcea8239bb90b32d38`: locked dependencies PASS; formatter PASS (37 files / 0 changed); analyzer PASS; Flutter tests **262/262 PASS**.
- **WP2:** ordered bootstrap in `app_bootstrap.dart`; Settings presentation in `settings_pages.dart`; injected root in `app_root.dart`. Official-build verification, preference identity/defaults and Floating Monitor bridge/native renderer remain separate and unchanged.
- **WP3:** `p1_frame_decoder.dart` owns framing; `p1_command_contract.dart` owns pure command classification; `p1_ack_waiters.dart` owns per-item FIFO waiter registration/completion/cancellation/timeouts/bulk cancellation. Dashboard remains sole BLE/GATT/P1/session owner and retains writes, transaction sequencing, SYNC/SYNC_READY, reconnect and authoritative telemetry.
- **WP4:** `jex_design_tokens.dart` now covers approved layout/semantic roles plus existing typography and input-shape values. Base/compact themes and Settings semantic foreground/surface/outline roles consume those tokens; regression tests preserve existing numeric appearance. Cross-route reusable-component adoption and actual visual acceptance remain open.
- **Release:** Build #167 remains latest package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged.
- **Evidence limits:** Flutter/Dart/Gradle/ADB unavailable locally. Android/Kotlin compilation, screenshots/OEM/device, SQLite runtime fixture and 1h/6h/24h profiling NOT RUN. Visual outcome **VISUAL NOT VERIFIED**.


## Protected contracts and evidence

P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; serialized scan invalidation; command intent vs ACK vs telemetry-confirmed outputs; Usage Statistics schema v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT freshness, null gaps and 64+8+1 queue; application identity, settings persistence, theme/assets/localization and 360-dp canvas remain protected.

Flutter/Dart/Gradle/ADB unavailable locally. Hosted Validation Only does not compile Android/Kotlin or prove screenshots/device/OEM behavior. Visual acceptance remains **VISUAL NOT VERIFIED**. SQLite migration runtime fixture and long-session performance soak remain NOT RUN.

## Latest source state and next action

Live main is `d5228516e825a3e7b9ae72bcea8239bb90b32d38` (160 entries / 114 blobs / 46 trees, not truncated). Validation Only #167 failed only the formatter gate after 273/273 tests and analyzer passed; the single declaration was reformatted in this live main. Validation Only #168 / run `45957362284` is pending on this exact SHA. The new pure AppSettings tests remain unverified until #168 is terminal.

## Next action

Continue WP4 by auditing and adopting shared semantic typography/shape/surface tokens across remaining Flutter routes without changing approved values or hardware semantics. Then implement WP5 Home and Voltage/Control/Adaptive/LED/Temperature screen refinements with per-tab behavioral regression tests. Keep Dashboard as the only BLE/P1 session owner, preserve the 360-dp composition and all cooler/telemetry contracts, and leave screenshot acceptance explicitly VISUAL NOT VERIFIED until actual Android evidence exists. After CODE_FULL closes, execute the approved REPO_FULL cycle; do not invoke Build App.
