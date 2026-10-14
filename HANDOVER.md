# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-14 (Asia/Jakarta). Re-fetch live `main` and source hashes before acting; this handover is a guide, not proof of current repository state.

## Current state

- Active Firmware source: `firmware/JEXFYZ-V6.6.ino`; `FW_VERSION = "V6.6"`; source blob observed at last reconciliation: `f51ba6db5d0e91318f63fea4014bb87f7bf76222`.
- Active App source: `lib/main.dart`, current blob `96a4c968e102a7ebc6b00d3932cf998829b1d07a`, pubspec version `1.0.0+3`, package `com.horizontalzzz.jexfyz`.
- Firmware source remains V6.6 and release state remains DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED. User reported successful V6.6 compilation and Online OTA update, but compile logs/artifact provenance and complete physical QC were not independently verified here.
- Main V6.6 QC contract: `test/v6_6_qc_contract_test.dart`. Latest widget/source contracts are in `test/widget_test.dart` (`3af190d4520a7b753f3f9fc963f788f4aa247f5c`); Flutter tests/analyze were NOT run because Flutter/Dart SDK is unavailable.
- Latest live successful App Build: run `38545637192` on commit `9e790765f6683d342025317ce6594cc8519026de` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38545637192); security/architecture audit, dependency install, Dart analyze, Flutter tests, APK signing, release publication and downloaded-asset verification succeeded on that commit. Release `jexfyz-latest` contains one `JEXFYZ-release.apk` (54,505,507 bytes, SHA-256 `26b3746a9d6969475e72a56122d5c4051eaa8742f7d4e3559cc80f4fdb4d2b87`) targeting `9e790765`. That release predates the current animation/Peltier/dialog/JE-icon commits and is not a build of the current source.
- Open PR search last returned zero. Verify live; use main by default.
- Artifact repository `TenzoNkz/JEXFYZ-Firmware` is intended to contain only `JEXFYZ.cpp.bin`; all notes belong in this repo.
- App memory explicitly records a 1 Hz Android phone-battery heartbeat, firmware 5-second battery-data freshness TTL, and the requirement not to display a standalone Battery Protection Guard. One-App/one-cooler exclusive pairing is a user design intent whose exact enforcement remains unverified.

## First steps in the next session

1. Read `CHAT_TRANSFER.md` in full and then `MEMORY_INDEX.md`, `CHAT_RULES.md`, `PROJECT_STATE.md`.
2. Fetch current main HEAD/tree, current source blobs, tests, workflow, open PR state and artifact repo root. Do not quote the hashes above as current without rechecking.
3. Read the relevant canonical memory before changing code: `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` for OTA; `VOLTAGE_TRANSITION_MEMORY.md` for rail/Peltier timing; `APP_NOTES.md` for App behavior; `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` for firmware; `BUILD_NOTES.md` for build.
4. Respect the command protocol and authorization boundaries from `CHAT_RULES.md`.
5. Preserve these battery UI and pairing requirements in `APP_NOTES.md`; do not ask the user to repeat them. If exclusive pairing-lock work is requested, audit the exact BLE security/provisioning code first and report implementation versus intent.

## Exact next QC actions (only when authorized)

1. The user reports V6.6 compiled using ArduinoDroid/Core 3.3.7 and Online OTA update succeeded. Confirm the compile log, installed version and source-to-BIN provenance; do not recompile solely for these App-only changes or assume the existing BIN matches source.
2. Pair App and Firmware V6.6 and test Static, Breath, Comet, Dual Chase, Left ↔ Right and Rainbow in order. Confirm Mirror Pulse is absent and ID 3 is migrated/rejected.
3. Verify LED_SYNC on initial sync, mode switch, RGB ON/OFF and periodic updates; inspect lag/jumps under BLE traffic.
4. Check saturated colors at 1%, 10%, 46% and 100% brightness, and confirm the one-row preview fits narrow screens: left arrow → four left LEDs → centered localized mode name only (no numeric index) → four right LEDs → right arrow.
5. Run Flutter tests/analyze when a Flutter SDK/runner is available. The latest source commits were not tested here. Check disconnected CONTROL/ADAPTIVE/LED fallback, Home/Floating Monitor `--` unknown telemetry, the bold JE notification small-icon silhouette (no large icon), title/body/tap intent and Android notification permission. Physically inspect Fan phase continuity through 5V/9V/12V changes and coast-down on OFF, the geometric Peltier frost transition/fade, pale inactive Comet/Dual Chase pixels, vivid Static/Rainbow preview, the enlarged bottom-pinned Color Picker/Cancel, and enlarged Peltier Safety text/actions. The latest successful App Build is run `38535535278` on preceding source `97c5497`; a fresh build is still required for current source/test/native-icon commits. Firmware and physical LED behavior remain separate gates.

6. With hardware, reproduce Manual Volt and Adaptive voltage changes while the 5-second soft-start is still active. Expected: GPIO5 PWM 0% during selector handoff, preserve 200 ms deadtime, hold through 1-second settle, then start a fresh 5-second ramp. Adaptive ON/OFF must not introduce a separate Peltier OFF cycle. Capture reset reason if reboot recurs.
7. Repeat after soft-start completes, including Adaptive ON and OFF. Expected: Peltier PWM remains 100% continuously throughout rail transition unless explicit OFF or safety shuts it down; no Adaptive-specific OFF/ON cycle.
8. Verify Peltier-OFF, Hotside/NTC protection and OTA safe-output cancel all pending ramp resume.
9. Verify Adaptive timeout/recovery, Hotside re-arm, Touch telemetry sync, LED feedback, Wi-Fi→BLE handoff and both OTA routes.
10. Separately authorize/run Flutter test and analyze. A test file or static inspection alone is not a pass.
11. Build App only on explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`, and only after reviewing the current workflow.

## Known uncertainty

- User reported the V6.3-era Online OTA connection correction, and separately reports successful V6.6 compilation plus Online OTA update. The V6.6 compile log, built BIN provenance, complete installed-version confirmation and physical QC were not independently validated here.
- LED synchronization uses atomic `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` snapshots created at BLE notify time; App preview interpolates from each snapshot with a monotonic clock. Physical synchronization still needs validation after matching V6.6 firmware is compiled and installed.
- The 5 V→12 V reboot during active Peltier ramp could be a supply transient/brownout, but this has not been proved. Preserve and collect `BOOT: RESET_REASON=...` diagnostics.
- The selected Online OTA path uses `cloudClient.setInsecure()`: HTTPS server certificate identity is not authenticated. This trade-off was chosen after the CA/NTP-gated attempt failed in the user's observed environment; don't change it without explicit discussion/approval.
- No App Build, firmware compile, BIN publication, Firebase update, physical flash/OTA or release was performed by this handover/documentation refresh.

## Reference routing

Use `MEMORY_INDEX.md` to find canonical notes. Use `CHANGELOG.md` for history only. Never copy old V5.x/V6.1/V6.2 status blocks forward as current truth. The complete cross-chat startup and memory-reconciliation procedure is in `CHAT_TRANSFER_PROMPTS.md`.

 
## Latest UI change-set boundary (2026-10-14)

- Source updates: `lib/main.dart` (`2005f4c163d466f9015a564d5418af1e86e09b41`, `test/widget_test.dart` (`d028271363dea79c2473d96faeb206bfb153837e`), `JexNotificationUtils.kt` (`aecfc87121f2195ef6724613c612d674ed95ae55`), and `drawable/ic_notification.xml` (`cda9e8404d14a62a61157ec59fae2e491c19f5f7`). Check live `main` for current hashes.
- Fan rotation retains phase when changing voltage and coasts to a retained angle when OFF. Peltier uses a geometric thermoelectric-module/frost-crystal symbol, 420 ms smooth density/intensity interpolation, periodic crystal drift and a 520 ms OFF fade. Color Picker and Peltier Safety typography and touch targets are larger.
- Android notification small icon is a bold white JE vector monogram on transparent background, as the sole small icon; no large icon is set. The full-color app icon/dashboard branding remains unchanged.
- Flutter tests/analyze for current source were not run (Flutter/Dart SDK unavailable); no current-source App Build, Firmware compile, BIN/Firebase change, OTA/flash, device QC or release occurred. Latest successful App Build `38535535278` targets previous commit `97c5497` and does not contain these changes. Firmware V6.6/source was untouched.

