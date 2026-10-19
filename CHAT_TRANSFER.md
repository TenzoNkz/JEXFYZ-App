# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after the Home NOTIFY and indicator-spacing restoration on 2026-10-20 (Asia/Jakarta). This snapshot is written last after the source, regression contract, and canonical docs updates. Its HEAD below is the pre-transfer HEAD; it cannot self-reference its own future commit.

## 1. Authority and command scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`. Work directly on main; no branches/PRs unless explicitly requested.
- Pre-transfer HEAD: `f25d72c7f1a880daf069fd8338acb5bda1328b9f`; parent: `55c97b66c683d0b059fc837805796f67f9f617c0`. Recursive tree: 67 entries (49 blobs / 18 trees), not truncated.
- `@Thinking Diskusi!` is read-only. `@Thinking Eksekusi Full!` authorizes scoped source/tests/docs/audit/commit, not App Build. `@Thinking Eksekusi Build App!` is the separate authorization for the official App build/test/package/release flow. `@Thinking Chat Stuck!` recovers an authorized operation but does not widen its scope.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. App repository owns app/firmware source and all project memory. `TenzoNkz/JEXFYZ-Firmware` is BIN-only. No Firmware compile, BIN publication, Firebase update, OTA, flashing, or device operation occurred.

## 2. Current Home layout restoration — SOURCE UPDATED / NOT RUN / NOT RELEASED

- Current `lib/main.dart` blob: `0341122a53e7a6bb00d9f079bfcb350b385c83cb`.
- Current `test/widget_test.dart` blob: `eeee8dcdb9dd88b985145e059913759f5f325920`.
- Restored `_homeMetric` to the original 44 dp row height. The indicator tile stays 38 dp inside the original 41 dp icon lane, restoring the vertical rhythm from Battery Temperature through Fan Speed.
- Restored the original `_homeNotify` layout structure: icon on the left, title/body immediately beside it, both left-aligned inside a `Row`. Removed the separate CONNECTED/DISCONNECTED badge only; there is no centered text `Stack` or empty right-side badge lane.
- NOTIFY card minimum and the reserved Home slot are both 56 dp, slightly taller than the old 44 dp card so the body can wrap to at most two lines at normal font size. No `FittedBox` shrinking. All other Home proportions, cooler illustration, tabs, submenu, icon painters, BLE behavior, control logic and telemetry semantics remain unchanged.
- Added regression contracts for 44 dp metric rows, 38/41 dp indicator geometry, the 56 dp Notify card/slot, left-icon/text-left `Row`, at-most-two-line body, no `Stack`/`FittedBox`, and removal of the connection badge. A test string escape found during static audit was corrected in the current test blob.
- **Validation state:** static source checks passed. Flutter tests, Dart analyzer and App Build have NOT RUN for this latest correction. Build #108 must not be treated as verification of this new geometry.

## 3. Latest successful App release — Build #108

- Latest successful App run: [Build #108 / run 39294761979](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39294761979), exact packaged source commit `51f401c90085b0bef5599375f7819d0294375938`. Analyzer exited 0 with 25 info findings/no warnings or errors; 107 Flutter tests passed; Android gate and APK/source ZIP/signing/source-marker verification passed.
- APK asset ID `656953696`, 54,734,939 bytes, SHA-256 `a7e46390a2b8a487eb85e69d33af685dbc79f9814c201cce9fd255e1164cf8ed`.
- Corresponding source ZIP asset ID `656953697`, 2,866,251 bytes, SHA-256 `4b3095747a711888afa9879e70cd8d3fc74b22659e68f338e6e8cbc2430d12be`.
- Release `jexfyz-latest` and its tag target Build #108 source `51f401c90085b0bef5599375f7819d0294375938`. Build #108 includes earlier badge-free NOTIFY and thermal/Voltage redesign, but it still used the incorrect centered text group and 41 dp metric rows. The current row44/card56 layout is newer and unreleased.

## 4. Current Firmware source boundary

- Exactly one active versioned sketch: `firmware/JEXFYZ-V6.8.ino`, blob `7b4df708708e021aad39258468eed2fde94d202f`, embedded `FW_VERSION="V6.8"`.
- V6.8 has deterministic Adaptive 12 V Fan PWM tiers from `delta = hotLimit - hotsideC`: delta <1.5°C →100%; 1.5–<2.5°C →90%; 2.5–<3.5°C →80%; 3.5–<4.5°C →70%; 4.5–<5.5°C →60%; delta ≥5.5°C →50%. Integer examples remain 1°C below=100%, 2°C=90%, 3°C=80%, 4°C=70%, 5°C=60%, 6°C or more=50%. The limit/protection forces 100%; Adaptive 5V/9V remain 100%.
- The V6.7 trend-window/timer algorithm and its old versioned sketch/test file were retired. Firmware V6.8 is SOURCE UPDATED / NOT COMPILED / NOT INSTALLED. Current Firmware test blobs: `test/firmware_qc_contract_test.dart` `59f376af6b3ec1c22d24f71db6afa40927a835fd`; `test/firmware_touch_adaptive_sync_test.dart` `a96b501d694b6eb4ad42fca0c61a8a430b129105`. These tests have NOT RUN.
- Firmware artifact repo recursive tree remains exactly one file, `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was examined; payload and source-to-BIN provenance remain UNVERIFIED.

## 5. Canonical memory fingerprints

- `PROJECT_STATE.md`: `ba5922b37098903e0d828002e64f528bd72341b8`
- `HANDOVER.md`: `d2a5720c531ac5e6b4a103ce6300ca5964c6a3a4`
- `MEMORY_INDEX.md`: `245ee943f7cb6ea9afb929ad0b788f0507c392a0`
- `APP_NOTES.md`: `5349fd82f8eb6c8ab6be61671d8db69aa483374d`
- `DESIGN_NOTES.md`: `d25972e14129f6d6ef1f1bfd18b252ca36d69524`
- `CHANGELOG.md`: `8be3c83ba771cb412dbd2af261d6886199d6e86e`
- `APP_BUILD_REPORT.md`: `c10f2df7341208ef918bb8aac6bedb50d741bf93`
- `CHAT_RULES.md`: `b06c8a1631f97b60d5abf66e6892142a53484052`
- `README.md`: `593f25f973f061bdbbf7a3be00ea27847b1d2e65`
- `.github/workflows/jexfyz-app-build-trigger.yml`: `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12` (unchanged guarded workflow).

## 6. Recovery disposition

- Source restored to original Home icon spacing and Row-based NOTIFY layout; connection badge removed; 56 dp two-line card/slot added.
- Tests and canonical notes updated and committed directly to `main`.
- No App Build, Flutter/Dart test/analyzer run, Firmware compile, BIN, Firebase, OTA, flash, or hardware action was performed.