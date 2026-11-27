# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Owner scope and repository policy

- Workspace: CODE_FULL — complete owner-approved App-only WP0–WP10 and evidence-backed build-ready handoff; then continue the separately approved REPO_FULL work.
- Repository: TenzoNkz/JEXFYZ-App; `main` is the sole active branch and integration branch.
- Latest owner decision (2026-11-27): CODE_FULL is ChatGPT/Codex-only. ChatGPT/Codex authors and reviews App source/tests/docs/config directly on `main` through the connected GitHub integration. Do not use Copilot, external coding agents, feature branches or PR handoffs. Re-fetch exact HEAD and target blob SHAs before every write; review each diff; verify commit/read-back and push-triggered Validation Only on the exact SHA.
- Included: Flutter/Dart App source/tests/docs/configuration/static audit and non-publishing Validation Only CI.
- Excluded: Build App/APK/sign/release until a fresh Eksekusi Build App!; Firmware/BIN/P1 wire/behavior, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operations.

## Current execution state

- GitHub connected identity has repository admin permission. The active execution model is ChatGPT/Codex direct-to-main; latest branch, protection and run state must be re-fetched before further writes. The branch API last reported `protected=false`; repo metadata reported `allow_auto_merge=false`.
- Issue #45 was rewritten to ChatGPT/Codex-only direct-main WP1 instructions and closed as completed after the exact-SHA Validation Only #217 result.
- Validation Only workflow: `.github/workflows/jexfyz-app-validation.yml`; push-to-main only, path-filtered to App source/tests/config/assets/workflow paths, least-privilege `contents: read`, checkout credential persistence disabled. Inspect the live workflow and Actions run for each exact changed SHA. Build App remains a separately guarded issue/title/token release workflow.
- The connected GitHub integration supports repository reads/writes, commits, Actions inspection and issue operations. Do not create redundant integrations or hand work to Copilot.

## Clarification of rework scope

“Full Rework” names the owner-approved WP0–WP10 App modernization scope; it is not a greenfield rewrite. Compare Build #167 source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81` with validated source `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0`: 603 descendant repository commits and 77 changed paths, including 21 App source files and 18 test files. App-source delta +11,377/-10,489 lines largely reflects extraction/reorganization: `main.dart` 11,434→4,831 lines; `usage_statistics.dart` 3,650→3,651; `floating_monitor.dart` 1,959→1,209 with Settings subpages in `settings_pages.dart`. Dashboard remains the single BLE/GATT/P1/session/telemetry/command authority. The 603 commits are aggregate history since Build #167, not 603 source rewrites in one interaction.

## Current source and validation

- Last historically validated source checkpoint: `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0`. Latest WP1 test source: `c11800e867bee2e8fb1426f865a28f2fb00cabf4`; repository tree last measured 166 entries / 120 blobs / 46 trees, `truncated=false`.
- Validation Only #217 / run `46039843488` / job `140644469587`, exact WP1 test source SHA `c11800e867bee2e8fb1426f865a28f2fb00cabf4`, terminal SUCCESS — dependencies PASS; formatter 44 files / 0 changed; analyzer gate PASS (`--no-fatal-infos`, 127 info-level diagnostics, zero warnings/errors); **292/292 Flutter tests PASS**.
- WP1 storage: seven original normal-path plus seven new test-only read/write/delete failure-injection tests cover AppSettingsStore/KnownCoolerStore; all 292 Flutter tests pass on #217. Production keys/defaults/schema and `lib/app_settings.dart` remain unchanged. Real Android secure-storage behavior remains unverified.
- WP2/WP3: ordered bootstrap, App root, Settings presentation, pure P1 frame decoder, pure command contract and FIFO ACK-waiter lifecycle are separated. Dashboard remains the only BLE/GATT/P1/session/telemetry/command authority.
- WP4: shared layout/semantic color/typography/shape tokens exist. Compact-control radius and Statistics axis-label typography are covered; cross-route role classification remains open. Preserve screen-specific density and measured plot geometry. Visual acceptance remains open.
- WP5: shared dashboard card/section components, state-bound control presentation helpers, and reduced-motion-aware tab transitions are in place. No BLE/GATT/P1/session/command ownership moved. Screen-level visual refinement and screenshot acceptance remain open.
- WP6–WP10: Connection/Settings/dialog polish; Usage Statistics architecture/UI; Floating Monitor Flutter/native split; deterministic visual/integration/platform evidence; final file/diff/governance closure remain open.

## Protected contracts and evidence limits

Preserve P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; ACK vs telemetry-confirmed physical outputs; settings keys/defaults and Usage Statistics v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT-only freshness, explicit null gaps and bounded queue; native Canvas/WindowManager; brand, theme/assets/localization and 360-dp canvas/DPI behavior.

Flutter/Dart/Gradle/ADB were unavailable in the previous runtime and must be checked again. Hosted Validation Only does not compile Android/Kotlin or prove OEM/device behavior. Android/Kotlin compilation, actual screenshots/device/OEM, SQLite v1→v2 runtime fixture, 1h/6h/24h performance profile and whole-App visual acceptance remain NOT RUN / VISUAL NOT VERIFIED.

Build #167 remains the latest published App package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current `main` is not packaged. No Build App/release, Firmware/BIN, OTA, Firebase production, signing, flashing or device operation occurred.

## Next action

Resume the dependency-ordered WP0 file audit at `lib/connection_scan_coordinator.dart`, the next live inventory path. Continue the WP0–WP10 App workstream with bounded direct-main ChatGPT/Codex commits and exact-SHA Validation Only checks. No Build App, Firmware/BIN, OTA, Firebase production, signing, flash or device operation is authorized by CODE_FULL.