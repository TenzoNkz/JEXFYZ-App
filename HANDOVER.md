# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-14 (Asia/Jakarta). Re-fetch live `main` and source hashes before acting; this handover is a guide, not proof of current repository state.

## Current state

- Active Firmware source: `firmware/JEXFYZ-V6.6.ino`; `FW_VERSION = "V6.6"`; source blob observed at last reconciliation: `f51ba6db5d0e91318f63fea4014bb87f7bf76222`.
- Active App source: `lib/main.dart`, current blob `96a4c968e102a7ebc6b00d3932cf998829b1d07a`, pubspec version `1.0.0+3`, package `com.horizontalzzz.jexfyz`.
- Firmware source remains V6.6 and release state remains DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED. User reported successful V6.6 compilation and Online OTA update, but compile logs/artifact provenance and complete physical QC were not independently verified here.
- Main V6.6 QC contract: `test/v6_6_qc_contract_test.dart`. The latest App UI execution updated `test/widget_test.dart` (`dbdb8e8cb407c3b534747086027c5512aac9fe20`); Flutter tests/analyze were NOT run because Flutter/Dart SDK is unavailable.
- Latest live successful App Build: run `38535535278` on commit `97c5497e2aa31184de425c264def6dec7844f734` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38535535278); analyze/tests/build/signature/release-asset verification succeeded on that commit. Release `jexfyz-latest` currently contains `JEXFYZ-release.apk` (54,506,164 bytes, SHA-256 `bb740029d24e1b76b41796d3ef979bc7c3ee7d96ff3fe96fdaacbcdb5ebf426b`) targeting `97c5497`. This is the preceding revision, not the latest animation/Color Picker source. The current source/test commits remain unbuilt.
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

1. User compiles active V6.6 using ArduinoDroid with Arduino-ESP32 Core 3.3.7. Confirm binary/version provenance; do not assume the already-published BIN matches source.
2. Pair App and Firmware V6.6 and test Static, Breath, Comet, Dual Chase, Left ↔ Right and Rainbow in order. Confirm Mirror Pulse is absent and ID 3 is migrated/rejected.
3. Verify LED_SYNC on initial sync, mode switch, RGB ON/OFF and periodic updates; inspect lag/jumps under BLE traffic.
4. Check saturated colors at 1%, 10%, 46% and 100% brightness, and confirm the one-row preview fits narrow screens: left arrow → four left LEDs → centered localized mode name only (no numeric index) → four right LEDs → right arrow.
5. Run Flutter tests/analyze when a Flutter SDK/runner is available. Check disconnected CONTROL/ADAPTIVE/LED toggles remain OFF-looking, disabled and knob-left while dashboard/Floating Monitor show unknown `--`. Validate the single JE X FYZ notification monogram (no right-side large icon), title/body/tap intent and permission request on Android 13+ and older supported Android. Physically inspect the seven smooth Home indicator animations, pale inactive Comet/Dual Chase pixels, full-colour Static/Rainbow preview at low hardware Brightness, and display-anchored Color/Peltier Safety menus. Firmware compile and physical LED behavior remain separate gates.

6. With hardware, reproduce Manual Volt and Adaptive voltage changes while the 5-second soft-start is still active. Expected: GPIO5 PWM 0% during selector handoff, preserve 200 ms deadtime, hold through 1-second settle, then start a fresh 5-second ramp. Adaptive ON/OFF must not introduce a separate Peltier OFF cycle. Capture reset reason if reboot recurs.
7. Repeat after soft-start completes, including Adaptive ON and OFF. Expected: Peltier PWM remains 100% continuously throughout rail transition unless explicit OFF or safety shuts it down; no Adaptive-specific OFF/ON cycle.
8. Verify Peltier-OFF, Hotside/NTC protection and OTA safe-output cancel all pending ramp resume.
9. Verify Adaptive timeout/recovery, Hotside re-arm, Touch telemetry sync, LED feedback, Wi-Fi→BLE handoff and both OTA routes.
10. Separately authorize/run Flutter test and analyze. A test file or static inspection alone is not a pass.
11. Build App only on explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`, and only after reviewing the current workflow.

## Known uncertainty

- User reported the V6.3 OTA connection correction compiled and Online OTA connected to GitHub. This does not prove V6.6 compile, complete BIN download/apply, reboot, or installed-version confirmation.
- LED synchronization uses atomic `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` snapshots created at BLE notify time; App preview interpolates from each snapshot with a monotonic clock. Physical synchronization still needs validation after matching V6.6 firmware is compiled and installed.
- The 5 V→12 V reboot during active Peltier ramp could be a supply transient/brownout, but this has not been proved. Preserve and collect `BOOT: RESET_REASON=...` diagnostics.
- The selected Online OTA path uses `cloudClient.setInsecure()`: HTTPS server certificate identity is not authenticated. This trade-off was chosen after the CA/NTP-gated attempt failed in the user's observed environment; don't change it without explicit discussion/approval.
- No App Build, firmware compile, BIN publication, Firebase update, physical flash/OTA or release was performed by this handover/documentation refresh.

## Reference routing

Use `MEMORY_INDEX.md` to find canonical notes. Use `CHANGELOG.md` for history only. Never copy old V5.x/V6.1/V6.2 status blocks forward as current truth. The complete cross-chat startup and memory-reconciliation procedure is in `CHAT_TRANSFER_PROMPTS.md`.

 
## Latest UI change-set boundary (2026-10-14)

- Source updates: `lib/main.dart` (`96a4c968e102a7ebc6b00d3932cf998829b1d07a`), `test/widget_test.dart` (`dbdb8e8cb407c3b534747086027c5512aac9fe20`), and the previously verified notification source/assets. See live `main` for current hashes.
- Fan rotation is voltage-aware (5V slow / 9V medium / 12V fast); Peltier frost density/glow is voltage-scaled and fades when OFF. This is illustrative App animation only, with no firmware/BLE/control behavior change.
- Color Picker is fixed to the bottom safe area, has a localized top-left Cancel button and no scrollable outer panel. Cancel dismisses without sending RGB; swatch selection retains the existing command path. Peltier Safety stays separate with its required Fan-before-Peltier gate.
- Flutter tests/analyze were not run in this execution (Flutter/Dart SDK unavailable); no App Build, Firmware compile, BIN/Firebase change, OTA/flash, physical-device QC or release operation occurred in this execution. The user's earlier V6.6 compile/Online OTA and preceding App Build reports remain user-reported, not independently validated here.
