# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-14 (Asia/Jakarta). Re-fetch live `main` and source hashes before acting; this handover is a guide, not proof of current repository state.

## Current state

- Active Firmware source: `firmware/JEXFYZ-V6.6.ino`; `FW_VERSION = "V6.6"`; source blob observed at last reconciliation: `f51ba6db5d0e91318f63fea4014bb87f7bf76222`.
- Active App source: `lib/main.dart`, current blob `6012d2e2d60dcbf2c5a816c78e63edbfb04b44c2`, pubspec version `1.0.0+3`, package `com.horizontalzzz.jexfyz`.
- Current Firmware status: source-only DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED. V6.6 not independently compiled/hardware validated here.
- Main V6.6 QC contract: `test/v6_6_qc_contract_test.dart`. This UI/notification execution updated `test/widget_test.dart` (`9c18e801b242ba3bdfd68a414407d778461b83a4`); Flutter tests and analyze have NOT run.
- Latest observed successful App Build run: `38520146994` on commit `1024eb8e145429913aacb52f4cf352e087885d44`; it predates the LED UI/notification source changes and does not validate current source. The exact current test list and run evidence are refreshed in `CHAT_TRANSFER.md`.
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

- Source updates: `lib/main.dart` (6012d2e2d60dcbf2c5a816c78e63edbfb04b44c2), `JexNotificationUtils.kt` (4156c17ffa9f871586f01a89dd507664cac81ba9), `drawable/ic_notification.xml` (787d1ccfaf758af4cc3f1be5cc4fa4d01a8ada3d), and `test/widget_test.dart` (9c18e801b242ba3bdfd68a414407d778461b83a4).
- Dashboard status icons now use per-kind filled vector shapes, soft glows and natural motion cycles. Menu/palette and notification changes are presentation-only; firmware/protocol/control behavior remains unchanged.
- Color and Peltier Safety remain distinct overlays but are anchored to the display-menu region. Notification branding uses one monochrome JE monogram at left only.
- Flutter tests/analyze were not run in this execution (Flutter/Dart SDK unavailable); no App Build, firmware compile, BIN/Firebase change, OTA/flash, physical-device QC or release operation occurred. The user's report of successful installation refers to an earlier app build.
