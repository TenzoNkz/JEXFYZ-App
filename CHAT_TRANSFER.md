## CURRENT V6.2 FULL EXECUTION — 2026-10-13

- Active Firmware: `firmware/JEXFYZ-V6.2.ino`, blob SHA `88d92f652a3cf973eb34bcfe3a9d73d9cbd87123`; last Firmware source update commit `13377f00b49d9de0bbd31a872c0da7251be56e8d`. V6.1 source retired.
- App: `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`; latest App correction commit `116921bd28d280039ba191371fa276149466c802`; version unchanged at `1.0.0+3`.
- Thermal rules: 30-second protection stage at 12 V, 9 V and 5 V; Peltier OFF immediately, Fan 100%. Hotside <= `hotLimit - 1°C` for 5 continuous seconds before the 30-second deadline cancels the stage and keeps the rail. Otherwise 12 V/9 V steps down one rail and an unrecovered 5 V stage enters terminal manual-restart lock.
- Thermal voltage recovery: each upward rail needs 60 continuous seconds at or below `hotLimit - 1°C`, up to the saved Adaptive ceiling. Terminal 5 V lock does not auto-recover. Manual re-arm threshold is -1°C plus 5-second stability.
- Online OTA uses HTTPS CA validation while retaining the raw GitHub allowlist for `TenzoNkz/JEXFYZ-Firmware`. BLE command writes require an encrypted bonded connection with Secure Connections/Just Works. Local OTA was intentionally left unchanged.
- App updates: normal BLE reconnect scheduling after disconnect state update; OTA disconnect marker is armed before `CLOUDOTA`; voltage ACK is followed by authoritative `VOLTAGE` telemetry confirmation; RGB colors normalize optional `#`; Dashboard/Floating Monitor show unknown output status while offline; safety copy uses -1°C.
- Regression tests added/updated; `.gitignore` added. `pubspec.lock` is absent from `main`: an ephemeral GitHub Actions `flutter pub get` succeeded, but the generated lockfile push was rejected as non-fast-forward. Test/analyze steps were skipped and the temporary workflow was removed.
- Validation: a temporary quality workflow resolved dependencies but failed pushing `pubspec.lock` due non-fast-forward; tests/analyze were skipped and the temporary workflow was removed. No lockfile was committed. No APK build, firmware compile, BIN, flash, OTA or physical-device validation was performed.
- Release state: V6.2 source-only DEVELOPMENT + QC / PRE-RELEASE, NOT RELEASED. Production firmware repository and Firebase metadata were not changed.

# JE X FYZ — CHAT TRANSFER / BOOT PROTOCOL

Snapshot date: 2026-10-13 (Asia/Jakarta). This snapshot was reconciled against `main` before the documentation refresh that began at HEAD `ae85fc52bbf81d24422d26a2ee3242aa4cb8a185`. Treat this file as a transfer guide and snapshot, not a substitute for checking the live repository.

## STATE LABELS

Use these labels precisely: [USER REQUIREMENT], [USER-CONFIRMED], [CURRENT TRUTH], [VERIFIED], [IMPLEMENTED], [COMMITTED], [BUILT], [TESTED], [UNVERIFIED], [HYPOTHESIS], [OBSOLETE], [REJECTED], [BLOCKED], [OPEN QUESTION].

## 0. READ FIRST / MANDATORY BOOT

1. Read this file first, then re-fetch live `main` HEAD.
2. Read `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_RULES.md`, and the relevant current notes: `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `firmware/FIRMWARE_ANALYSIS.md`, `OTA_PROTECTION.md`, `BUILD_NOTES.md`, and `CHANGELOG.md`.
3. Inspect current Firmware source/version/blob, App source, current workflows, test files, PR #18 state, and the divergent branch.
4. Do not alter source during boot/reconciliation. Report current truth and wait for a user command.

## 1. PROJECT IDENTITY

- [CURRENT TRUTH] Project/repository: JE X FYZ / JE Cooler — `TenzoNkz/JEXFYZ-App`; primary branch: `main`.
- [CURRENT TRUTH] Firmware target: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [CURRENT TRUTH] Firmware source of record lives under `firmware/` in this repository.
- [CURRENT TRUTH] Separate production firmware repository: `TenzoNkz/JEXFYZ-Firmware`.
- [CURRENT TRUTH] Flutter Android App package: `com.horizontalzzz.jexfyz`; App version `1.0.0+3`.
- [CURRENT TRUTH] Project phase: DEVELOPMENT + QC / PRE-RELEASE → **NOT RELEASED**.

## 2. AUTHORITY HIERARCHY

Use this order when records disagree:

1. Live current source, workflow, Git refs, and direct verification.
2. `PROJECT_STATE.md`.
3. Authoritative current technical notes.
4. `CHAT_RULES.md`, `HANDOVER.md`, and `CHANGELOG.md`.
5. This transfer file.
6. Current chat, then older chats.

History describes what was true at a past checkpoint. Never copy old version/status statements into current truth without verifying them.

## 3. USER COMMAND PROTOCOL

- [USER REQUIREMENT] `Diskusi` means inspect/explain/recommend; do not write changes.
- [USER REQUIREMENT] `Eksekusi` authorizes the discussed change only; do not broaden scope silently.
- [USER REQUIREMENT] Build App only when the user explicitly asks for App Build.
- [USER REQUIREMENT] Firmware compile/build must be explicitly requested separately. The user has said they will compile the current Firmware themselves later; do not compile it on their behalf unless explicitly instructed.
- [USER REQUIREMENT] Prefer direct commits to `main`; do not create branches or PRs unless explicitly requested.
- [USER REQUIREMENT] Do not flash hardware, trigger OTA, change Firebase/production metadata, or release without explicit authorization.
- Never claim a write, test, build, or physical verification that did not happen.

## 4. CURRENT PROJECT MODE

- [CURRENT TRUTH] QC / PRE-RELEASE; source is frozen except for a reproducible, relevant defect with a clear root cause and a narrowly scoped fix.
- [CURRENT TRUTH] Most recent functional task: fix App/Floating Monitor Adaptive state becoming stale when the user forces Adaptive OFF with the hardware Touch long-press.
- [CURRENT TRUTH] Current next device-level step is user-side Firmware compile/flash and physical BLE/UI verification; assistant must not initiate compile or App Build without the matching explicit instruction.
- [CURRENT TRUTH] App rebuild is not required for the Touch telemetry firmware change; no App Dart source was changed by that fix.

## 5. HARDWARE CONTRACT

- [USER REQUIREMENT] GPIO map: NTC ADC GPIO0; Touch GPIO1; 12V selector GPIO3; 9V selector GPIO4; Peltier GPIO5; Fan GPIO6; WS2812 LED GPIO7.
- [USER REQUIREMENT] ESP32-C3 logic is 3.3 V.
- [USER REQUIREMENT] Touch: one short touch cycles voltage; double touch controls RGB; 5-second long press toggles paired Fan/Peltier in normal manual use. While Adaptive is ON, 5-second long press exits Adaptive.
- [USER REQUIREMENT] Manual voltage sequence: 5 V → 9 V → 12 V → 9 V → 5 V → repeat.
- [USER REQUIREMENT] Selector outputs use 200 ms break-before-make deadtime. Voltage guard is 1 second.
- [USER REQUIREMENT] Fan PWM: 25 kHz, 8-bit, allowed adjustable range 50–100% in Manual 12 V mode; Fan safety override may force 100%.
- [USER REQUIREMENT] Peltier PWM: 20 kHz; every OFF→ON transition must use the cooperative 5-second soft-start.
- [USER REQUIREMENT] NTC: 10 kΩ sensor + 10 kΩ resistor, Beta 3950; exactly one calibrated ADC sample per second. Do not reintroduce median/multi-sample averaging.
- [USER REQUIREMENT] Hotside limit setting range 40–50 °C, default 45 °C.
- [USER REQUIREMENT] No blocking executable `delay()` and no timing `while()` loops.
- [USER REQUIREMENT] Do not reintroduce `RAPID_HOTSIDE_RISE`.
- [USER REQUIREMENT] Adaptive upward rail steps have a fresh 5-second dwell after each completed upward transition in both HOTSIDE and HOTSIDE_BATTERY profiles; downward thermal step-down is immediate.
- [USER REQUIREMENT] Manual thermal protection preserves the selected rail, forces Fan 100% and Peltier OFF, and requires manual Peltier restart after thermal re-arm.
- [USER REQUIREMENT] Peltier safety re-arm threshold is `hotLimit - 2 °C`. Normal Peltier ON/OFF must not produce an unrelated green/red LED cue; safety-state and re-arm cues are separate.
- [USER REQUIREMENT] Adaptive ON confirmation blinks orange three times; Adaptive OFF confirmation blinks white three times. The Adaptive state indicator currently has priority over the voltage indicator during its animation.

## 6. FIRMWARE CONTRACT / ACTIVE SOURCE

- [VERIFIED] Active path: `firmware/JEXFYZ-V6.1.ino`; source declares `FW_VERSION = "V6.1"`.
- [VERIFIED] Active V6.1 source blob after the Touch telemetry fix: `50dee6c7ed3cb5780e97deaa235fe81856152ec2`.
- [CURRENT TRUTH] V6.1 is committed source only for this current QC state. The current device's installed version is not proven by repository source alone.
- [IMPLEMENTED] On Adaptive OFF, firmware safely hands selector control back to 5 V; pending work waits for the 5 V transition to complete, and output restoration goes through existing safety checks and the 5-second Peltier soft-start.
- [IMPLEMENTED] Thermal behavior currently present in V6.1 source: `HOT_PELTIER_OFF_MS = 30000`; 12 V and 9 V Adaptive Hotside recovery stages use 30 seconds (red first 29 seconds, blue final 1 second). At 5 V, Adaptive enters terminal recovery lock with continuous red blink until thermal re-arm; there is no additional 30-second dwell at 5 V.
- [OPEN QUESTION / SOURCE-CONTRACT MISMATCH] The user's earlier frozen thermal contract specified 20 seconds at each reached Adaptive rail, including a 20-second 5 V terminal stage. The current V6.1 source instead implements 30 seconds at 12 V/9 V and a terminal 5 V recovery lock. Source is authoritative for what is actually implemented, but this mismatch must not be silently treated as resolved. Do not change it as part of document cleanup; raise it only when the user explicitly returns to that QC requirement.
- [IMPLEMENTED] Touch Adaptive-OFF path publishes the authoritative `ADAPTIVE`, `ADAPTIVE_CEILING`, `FAN`, `PELTIER`, and `FAN_SPEED` telemetry snapshot before `TOUCH_ADAPTIVE` ACK.
- [VERIFIED STATIC AUDIT] One lexical call site for `analogReadMilliVolts(PIN_NTC)`; no lexical `delay(` or `while(` call sites in the active firmware file. These are static inventory checks only, not a compile.
- [UNVERIFIED] Arduino compile, BIN, flash, physical operation, BLE telemetry timing, LEDs, cooling/thermal behavior, and OTA regression after the latest fix.

## 7. TOUCH CONTRACT

- [VERIFIED SOURCE] If Adaptive is active, the 5-second touch path invokes the existing Adaptive OFF path, sends a snapshot of the resulting state fields, then emits `TOUCH_ADAPTIVE` ACK.
- [VERIFIED SOURCE] The App's ACK handler reports the command result; the App's displayed Adaptive state is driven by `ADAPTIVE` telemetry.
- [IMPLEMENTED] This corrects the missing-state-delta defect without speculative App-side state mutation.
- [UNVERIFIED] The user must verify on hardware that a long touch turns Adaptive OFF and that dashboard + Floating Monitor synchronize promptly.

## 8. APP CONTRACT

- [CURRENT TRUTH] App source: `lib/main.dart`; active observed blob: `8189825511499cec01f357f1735dcee22426627b`.
- [CURRENT TRUTH] App uses `flutter_blue_plus`; displayed Adaptive state updates through the `ADAPTIVE` telemetry handler.
- [CURRENT TRUTH] Floating Monitor uses the same in-memory Adaptive state (`adaptiveOn: connected && adaptiveOn`).
- [CURRENT TRUTH] No App functional source edit was needed for the Touch telemetry fix; do not rebuild APK solely for this firmware telemetry change.
- [UNVERIFIED] Runtime synchronization after the V6.1 firmware is compiled/flashed has not yet been confirmed on hardware.

## 9. BLE / P1 CONTRACT

- Service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`.
- RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`.
- TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- [USER REQUIREMENT] One intended GATT session; telemetry/state from Firmware is authoritative.
- [USER REQUIREMENT] Hotside temperature is sent every second; other state/features are sent on change. Save preferences after 10 seconds without changes.
- [USER REQUIREMENT] Preserve existing BLE command, P1/SYNC_READY, ACK, NOTIFY, and `PHONE:BT=` contracts. No speculative BLE protocol redesign.

## 10. OTA PROTECTED CONTRACT

Read `OTA_PROTECTION.md` before any OTA-related discussion or change. OTA is protected/frozen.

- [USER REQUIREMENT] ESP32-C3 has one radio path: Wi-Fi OTA and BLE must not own radio simultaneously.
- [USER REQUIREMENT] Tear down BLE/GATT before Wi-Fi takes radio ownership; restore BLE after Wi-Fi fully stops.
- [USER REQUIREMENT] During OTA connection/update, put cooling and LEDs into the defined safe state.
- [USER REQUIREMENT] Local OTA and Online OTA behavior, state machine, and recovery paths are protected. Do not adjust them for unrelated cleanup.
- [USER REQUIREMENT] Firmware anti-downgrade policy is OFF: any valid firmware version different from the device version may update.
- Preserve the defined OTA result indications and BLE recovery behavior; see `OTA_PROTECTION.md` for the exact sequence.

## 11. FIREBASE / OTA METADATA

- [CURRENT TRUTH] Firmware metadata endpoint documented in notes: `https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`.
- [CURRENT TRUTH] Production firmware repository: `TenzoNkz/JEXFYZ-Firmware`; published file name: `JEXFYZ.cpp.bin`.
- [USER REQUIREMENT] Firmware metadata is version + link; do not add SHA as a Firebase firmware-linking requirement.
- [UNVERIFIED] Current live Firebase metadata was not independently fetched/verified as part of this snapshot.
- [NOT RELEASED] No production BIN or Firebase metadata was changed by the Touch telemetry fix or this documentation cleanup.

## 12. ANDROID / APP BUILD CONTRACT

- [USER REQUIREMENT] App Build is manual issue-trigger only.
- Workflow: `.github/workflows/jexfyz-app-build-trigger.yml`.
- Issue title: `JE X FYZ — BUILD APP TRIGGER`.
- Required body token: `JEXFYZ_BUILD_TRIGGER_V1`.
- Toolchain configured: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, `ubuntu-24.04`.
- Output: one obfuscated, production-signed `JEXFYZ-release.apk` published as a GitHub Release asset.
- [VERIFIED] Workflow directory contains only `jexfyz-app-build-trigger.yml`; normal pushes/PRs do not invoke this issue-triggered workflow.
- [USER REQUIREMENT] Do not Build App unless the user explicitly asks.
- [USER REQUIREMENT] Do not compile/build Firmware unless the user explicitly asks. User intends to compile it themselves later.

## 13. SOURCE / COMMIT MAP

- Repository: `TenzoNkz/JEXFYZ-App`; authoritative branch: `main`.
- Main HEAD before this documentation refresh: `ae85fc52bbf81d24422d26a2ee3242aa4cb8a185` (README transfer-protocol cleanup commit).
- Functional Touch telemetry synchronization commit: `74a49f08ae111da9b3fcd60d759aa0cce437e92d` — [view commit](https://github.com/TenzoNkz/JEXFYZ-App/commit/74a49f08ae111da9b3fcd60d759aa0cce437e92d).
- Documentation reconciliation commit following that fix: `d9eeedbd03b53fb9db8c16a7889635bccc22f413` — [view commit](https://github.com/TenzoNkz/JEXFYZ-App/commit/d9eeedbd03b53fb9db8c16a7889635bccc22f413).
- Active Firmware source/blob: `firmware/JEXFYZ-V6.1.ino` / `50dee6c7ed3cb5780e97deaa235fe81856152ec2`.
- App source/blob: `lib/main.dart` / `8189825511499cec01f357f1735dcee22426627b`.
- New static regression guard: `test/firmware_touch_adaptive_sync_test.dart` / `c744374b1a362c677667ffa300504216246b3cf9`.
- Persistent state notes: `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_RULES.md`, `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `BUILD_NOTES.md`, `OTA_PROTECTION.md`, `CHANGELOG.md`, `firmware/FIRMWARE_ANALYSIS.md`.
- Root `README.md` is reserved exclusively for chat transfer prompts/procedure, not project history.
- [CURRENT TRUTH] PR #18 is CLOSED and NOT MERGED: [Fix Adaptive rail handoff and status indicators (V6.1)](https://github.com/TenzoNkz/JEXFYZ-App/pull/18).
- [BLOCKED] Source branch `fix/adaptive-power-sequencing` still exists; its head is `33740be782d976a881e285bbf8b86b3b485b83c1`, with V6.1 blob `3f8c61ef2add303b495b1cc19e6ee6be04cea028`, different from the authoritative `main` Firmware blob. The available GitHub connection provides no branch-delete action here. Do not merge it or continue development from it; `main` remains authoritative.

## 14. QC STATUS

- [IMPLEMENTED] Firmware publishes Touch Adaptive-OFF state snapshot before its ACK.
- [IMPLEMENTED] Static source-contract test was added at `test/firmware_touch_adaptive_sync_test.dart`.
- [UNVERIFIED] That test was not executed.
- [UNVERIFIED] No `flutter analyze`, `flutter test`, Arduino compile, BIN generation, Firmware flash, physical BLE/App/Floating Monitor test, thermal regression, Local OTA regression, Online OTA regression, or App Build was performed for the latest fix/cleanup.
- [UNVERIFIED] No current device version proof; do not assume the user's physical device is running V6.1.
- [NOT RELEASED] Firmware remains source-only QC/PRE-RELEASE; no production release was made.

## 15. RISKS / OPEN QUESTIONS

- [OPEN QUESTION] After the user compiles/flashes V6.1, does a hardware 5-second touch while Adaptive is ON make the App dashboard and Floating Monitor display OFF promptly?
- [OPEN QUESTION] Do the orange ON and white OFF three-blink indicators display correctly on the physical WS2812 LED?
- [OPEN QUESTION] Is the previously reported Adaptive-entry restart eliminated? The original reset cause remains unproven because no Serial reset-reason log was captured.
- [OPEN QUESTION] The source/contract mismatch between 20-second expected Adaptive thermal dwell and actual 30-second 12 V/9 V source dwell plus terminal 5 V lock remains unresolved.
- [BLOCKED] Branch deletion is not available through the current GitHub connector actions; PR #18 has been closed, but its branch still exists.
- [USER-REPORTED] The earlier complaint that selecting 12 V did not affect hardware was traced to a loose cable and resolved by securing it. Do not re-open it as a confirmed firmware defect.

## 16. OBSOLETE / DO NOT REUSE

- [OBSOLETE] Previous active firmware paths/versions V5.8, V5.9, V6.0, and any old V6.1 branch blob are historical only; use the live source to establish current truth.
- [OBSOLETE] Older text claiming PR #18 is open or that no PR exists is superseded: PR #18 is closed, not merged.
- [OBSOLETE] Older text claiming the V6.1 source was built/flashed is not supported by current evidence.
- [REJECTED] Reintroducing NTC median/multi-sample filtering, `RAPID_HOTSIDE_RISE`, blocking timing, or a second BLE GATT session.
- [REJECTED] Blind merge/reuse of `fix/adaptive-power-sequencing`; its source differs from main.
- [REJECTED] Triggering a Firmware compile or App Build without the user's explicit request.

## 17. GEMINI EVIDENCE

- [UNVERIFIED] No new Gemini review or output was obtained during the latest Touch telemetry fix or this documentation cleanup. Do not fabricate or attribute evidence to Gemini.
- If the user later provides Gemini recommendations, treat them as proposals; reconcile them against live source and frozen contracts before implementation.

## 18. FAILED APPROACHES / INCIDENT HISTORY

- [USER-CONFIRMED] User objected when Firmware compilation appeared to happen without an explicit compile request.
- [VERIFIED] The old push-triggered Firmware compile workflow `.github/workflows/firmware-build.yml` is absent; deletion commit was `32bc3c3fcb0c074e39d7ea49428f98d7845e4073`. Current workflow directory contains only the manual App Build issue trigger.
- [VERIFIED] An unintended branch `fix/adaptive-power-sequencing` led to PR #18; the PR was closed without merge, but the branch remains.
- [HYPOTHESIS — NOT ROOT CAUSE] The previously reported restart during Adaptive entry may relate to power/rail handoff under load. The reset root cause is not established; require serial capture if it recurs.
- [FAILED EVIDENCE] No device Serial log or confirmed hardware reset reason was captured. Do not claim the restart issue is resolved solely from static source.

## 19. EXACT QC SEQUENCE

1. [USER ACTION] User compiles `firmware/JEXFYZ-V6.1.ino` themselves. Do not start compile on the user's behalf without a direct explicit request.
2. User verifies the exact compiled source/version, successful compilation, generated BIN, image magic/size, and SHA-256 locally. A static source audit is not a build proof.
3. User flashes the device as their own authorized hardware action and confirms the device reports V6.1.
4. With manual 12 V active, Fan and Peltier ON, allow the 1-second voltage guard to expire; enable Adaptive and verify Peltier-off-before-selector handoff, 200 ms deadtime, 5 V selection, safety gates, 5-second Peltier soft-start, and orange 3-blink confirmation.
5. Disable Adaptive using the 5-second hardware touch while it is ON. Verify Firmware telemetry shows Adaptive OFF, then App dashboard switch and Floating Monitor synchronize, and check white 3-blink feedback after the safe 5 V transition.
6. If restart recurs, capture Serial at 115200 baud and preserve the exact `BOOT: RESET_REASON=` line; do not infer brownout/panic without evidence.
7. Run thermal-safety checks against the actual current source; keep the 20 s-versus-30 s behavior mismatch visible rather than silently changing it.
8. Run Local OTA Golden Path and Online OTA/BLE recovery regression only when appropriately authorized; do not alter protected OTA code.
9. App Build is a separate operation and must not be run for this firmware-only change unless explicitly requested.

## 20. NEW CHAT FIRST RESPONSE

Report in Indonesian using these headings:
- CURRENT PROJECT TRUTH
- REPOSITORY RECONCILIATION
- VERIFIED
- UNVERIFIED
- KNOWN RISKS
- NEXT EXACT QC GATE
- WORKFLOW STATUS

Mention that V6.1 is committed source-only, the Touch telemetry fix exists in main, PR #18 is closed/not merged but its branch remains, and no new build/test/flash was run. Then wait for the user's command.

## 21. TRANSFER / MEMORY RULES

- At a context-limit event, replace this file; do not append duplicate snapshots.
- Keep current facts in `PROJECT_STATE.md` and `HANDOVER.md`; detailed historical versions belong in `CHANGELOG.md` and history-specific notes.
- Keep `README.md` exclusively for transfer prompts/procedure, never append project history there.
- Record exact active paths/blob SHAs, commit SHAs, workflow triggers, PR/branch state, and actual test/build evidence.
- Mark source implementation, build, hardware test, OTA regression, and release as separate gates.
- Do not ask the user for facts already available in the current repository/context.
- Documentation changes do not authorize source edits, compile, BIN publication, flash/OTA, App Build, or release.

## 22. CHAT-ONLY STATE

- [CHAT-ONLY] User says they will compile the Firmware themselves later.
- [CHAT-ONLY] User asked that root `README.md` contain only chat transfer instructions, not historical execution notes. The README was cleaned accordingly in commit `ae85fc52bbf81d24422d26a2ee3242aa4cb8a185`.
- [CHAT-ONLY] User asked to remove PR #18 from open PRs; it was closed but not merged. Branch deletion has not succeeded because the available connector provides no branch-delete action.
- [CHAT-ONLY] User does not expect an App rebuild for the latest firmware telemetry fix.

## 23. TRANSFER COMPLETION

- [VERIFIED] Root `README.md` now contains only chat-transfer prompts/procedure, not historical version or execution notes. README commit: `ae85fc52bbf81d24422d26a2ee3242aa4cb8a185`.
- [VERIFIED] The previous 342-line `CHAT_TRANSFER.md` was replaced by this single structured snapshot to remove duplicate and contradictory records. The first snapshot refresh commit was `0d1f906e73ee9593f145da2e56c3327d86e35533`; this commit records the completed verification pass.
- [VERIFIED] `CHANGELOG.md` now records this documentation cleanup; history remains in its dedicated file rather than README. Changelog commit: `0185c808ce6e3088b04a3ffb383ed7e0ca32a9ef`.
- [VERIFIED] Live re-fetch after the first transfer refresh confirmed: active Firmware path `firmware/JEXFYZ-V6.1.ino`, `FW_VERSION = "V6.1"`, Firmware blob `50dee6c7ed3cb5780e97deaa235fe81856152ec2`; App source blob `8189825511499cec01f357f1735dcee22426627b`; regression guard blob `c744374b1a362c677667ffa300504216246b3cf9`.
- [VERIFIED] Active workflow inventory contains only `.github/workflows/jexfyz-app-build-trigger.yml`.
- [VERIFIED] PR #18 is CLOSED and NOT MERGED. Branch `fix/adaptive-power-sequencing` still exists; branch deletion is not exposed by the available GitHub connector actions and is not claimed as completed.
- [VERIFIED] No functional App/Firmware source, workflow, test execution, compile/build, BIN, flash, OTA, Firebase metadata, or release was changed/run by the documentation cleanup.
- [VERIFIED] The final post-commit main HEAD and saved blob SHAs were re-fetched and checked after this final completion-note update; see the execution summary for the exact resulting commit.
