## CURRENT V6.3 EXECUTION STATUS — 2026-10-13

### Peltier voltage-transition restart prevention — 2026-10-13

- [FIXED IN SOURCE — NOT COMPILED] When an accepted voltage change occurs while the logical Peltier state is ON, firmware now forces physical GPIO5 PWM to 0% before opening the selector handoff. Fan remains enabled and is forced to 100%; the existing 200 ms break-before-make sequence remains unchanged.
- [IMPLEMENTED IN SOURCE] After selector completion, PWM stays at 0% for 1,000 ms using `PELTIER_VOLTAGE_SETTLE_MS` (aliased to the existing `VOLTAGE_GUARD_MS`), then a new 5-second soft-start begins from 0%. This also protects transitions when Peltier had already reached full duty.
- [REGRESSION CONTRACT ADDED — NOT RUN] `test/v6_3_qc_contract_test.dart` checks pause-before-selector ordering, the 1-second settle gate, restart of the fresh ramp, and retention of `BROWNOUT` reset diagnostics.
- [USER-REPORTED SYMPTOM] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON during soft-start. A power transient/brownout is a plausible hypothesis, not a confirmed reset cause; capture `BOOT: RESET_REASON=...` after the next user-side reproduction.
- [UNVERIFIED] The latest source revision has not been compiled or tested on hardware. The earlier V6.3 compile report predates this fix. No BIN, flash, physical OTA, or release operation was performed.
- [CANONICAL MEMORY] See [VOLTAGE_TRANSITION_MEMORY.md](VOLTAGE_TRANSITION_MEMORY.md) for the full incident record, exact timing contract, safeguards, and validation boundary.

### Online OTA connection regression correction — 2026-10-13

- [SOURCE FIX IMPLEMENTED] V6.3 Online OTA restores the previous `cloudClient.setInsecure()` connection path. The inline ISRG Root X1 certificate, CA validation call, `configTime()`, `TIME_SYNCING` state, and 20-second NTP gate were removed. On Wi-Fi connection, the blue indicator runs directly before the GitHub GET attempt.
- [PRESERVED] The HTTPS transport, raw GitHub BIN URL allowlist for `TenzoNkz/JEXFYZ-Firmware`, redirect blocking, download size/image checks, safe-output sequencing, and OTA recovery path remain in place. `setInsecure()` does not validate the server certificate identity.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_3_qc_contract_test.dart` now asserts the restored connection path, removal of CA/NTP gates, blue-before-GitHub flow, and retention of the URL allowlist/redirect block.
- [USER-REPORTED RESULT — 2026-10-13] The user reports that V6.3 compiled successfully after this correction and Online OTA can connect to GitHub again. This confirms the reported compile/connect result only; a complete BIN transfer, successful `Update.end()`, reboot, and confirmation of the new firmware version were not separately established here. Because CA validation and the OTA-only NTP gate were removed together, the available evidence does not isolate which one alone caused the earlier failure.
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, user-reported evidence boundary, trade-off, and recurrence-prevention rules.
- [NOT DONE BY ASSISTANT] No firmware compile, BIN generation/publication, flash, physical OTA run, or APK Build was performed by this assistant session.


### APP BLE reconnect and Online OTA acknowledgement follow-up — 2026-10-13

- [FIXED IN APP SOURCE] Disconnect rediscovery now avoids starting when Auto Connect is disabled or no previously paired cooler identity is known. The retry loop is cancelled when Bluetooth/permissions/location prerequisites fail, and scanning is suppressed during BLE syncing. Retry starts again when Auto Connect is enabled or the app resumes while disconnected.
- [FIXED IN APP SOURCE] A missing `CLOUDOTA` ACK due to `TIMEOUT` or `DISCONNECTED` is treated as ambiguous, not as a definite rejection. The app preserves OTA recovery state and tells the user it is waiting for reconnection or an OTA result. A definite rejection while BLE remains connected still follows the rejection path.
- [REGRESSION CONTRACTS ADDED — NOT RUN] `test/v6_3_qc_contract_test.dart` now checks both retry-loop cancellation and ambiguous OTA ACK handling. No Flutter tests or Dart analysis have run for this change because this environment has no Flutter/Dart executable.
- [PRESERVED BY USER INSTRUCTION] `android/app/build.gradle` still has `versionName "Telegram @horizontalzzz"` as the user's intentional identity. It was not modified.
- [VALIDATION BOUNDARY] Source and contract assertions were reviewed statically only; the user separately reports a successful firmware compile and restored GitHub connection. No Build App/APK build, BIN publication, flash, complete OTA install, or hardware validation was performed by this assistant session.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.3.ino`, blob `61237855ad87878553828ac7c37830d754b7fd9e`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. The user reports a successful firmware compile and GitHub connection, but no complete OTA transfer/apply/reboot proof is recorded here. No BIN generation/publication, flash, independent hardware validation, Android BLE pairing, or APK Build was performed by the assistant.
- [NOT RELEASED] V6.3 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

## HISTORICAL V6.2 FULL EXECUTION — 2026-10-13

- [CURRENT TRUTH] Active Firmware file: `firmware/JEXFYZ-V6.2.ino`; content blob SHA: `88d92f652a3cf973eb34bcfe3a9d73d9cbd87123`. The last Firmware source update is commit `13377f00b49d9de0bbd31a872c0da7251be56e8d`. V6.1 source is retired from the active tree.
- [CURRENT TRUTH] App file: `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`, last App correction commit `116921bd28d280039ba191371fa276149466c802`. App version remains `1.0.0+3`.
- [IMPLEMENTED IN SOURCE] Adaptive thermal safety uses 30-second dwell at 12 V, 9 V, and 5 V. Peltier turns OFF immediately and Fan remains at 100%. If Hotside reaches `hotLimit - 1°C` and remains there for 5 consecutive seconds before the 30-second deadline, the timer is cancelled, the rail is retained, and Peltier may resume. Otherwise 12 V/9 V steps down one rail, while an unrecovered 5 V stage enters terminal Adaptive/Peltier lock requiring manual restart.
- [IMPLEMENTED IN SOURCE] After a thermal downshift, voltage recovery is one step at a time after 60 seconds continuously at or below `hotLimit - 1°C` at each rail, up to the saved pre-downshift Adaptive ceiling. The Battery Adaptive controller is gated while thermal recovery is active. Terminal 5 V lock does not auto-recover.
- [IMPLEMENTED IN SOURCE] Manual Peltier re-arm threshold is `hotLimit - 1°C`, qualified by 5 seconds of stable readings.
- [IMPLEMENTED IN SOURCE] Online OTA retains the `TenzoNkz/JEXFYZ-Firmware` raw BIN allowlist, synchronizes NTP time with a 20-second timeout, validates HTTPS using ISRG Root X1, and rejects redirects. Local OTA stays as-is; no signature/checksum layer was added.
- [IMPLEMENTED IN SOURCE] BLE command writes require encryption/bonding using Secure Connections with Just Works pairing. MITM/passkey is not enabled because the ESP32-C3 has no passkey display/input; Android first pairing and reconnect require physical verification.
- [IMPLEMENTED IN SOURCE] App normal reconnect begins only after offline state is committed; Online OTA recovery is armed before `CLOUDOTA`; voltage success waits for matching `VOLTAGE` telemetry; LED confirmation normalizes optional `#`; Dashboard and Floating Monitor show unknown output status while disconnected; re-arm copy uses `hotLimit - 1°C`.
- [IMPLEMENTED] Added `test/v6_2_qc_contract_test.dart`, updated `test/firmware_touch_adaptive_sync_test.dart` to the V6.2 path, and added Flutter/Dart/Android `.gitignore`.
- [BLOCKED] `pubspec.lock` is absent from `main`. A temporary GitHub Actions run resolved dependencies, but its lockfile push was rejected as non-fast-forward; the subsequent test/analyze steps were skipped. The temporary workflow was removed and no lockfile was committed.
- [UNVERIFIED] `flutter test` and `flutter analyze` remain unexecuted: the temporary Action skipped both after its lockfile push failed. This environment has no local Flutter/Dart toolchain. Firmware was not compiled, App APK was not built, BIN/flash/OTA/hardware/Android pairing tests were not performed.
- [NOT RELEASED] V6.2 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repo/Firebase release metadata were not modified.

# JE X FYZ — ACTIVE CHAT / ENGINEERING RULES

## COMMANDS
- @Thinking Diskusi! = discussion/review only; no functional source, release, or build.
- @Thinking Tanya Gemini! = diagnosis/patch-request; return exact OLD → NEW patches only.
- @Thinking Eksekusi! = implement approved scope + affected audit + memory sync + commit.
- @Thinking Eksekusi Full! = implement + full audit + memory sync + commit; App Build is not implied.
- @Thinking Build App! = explicit full App Build workflow in a fresh engineering environment.
- @Thinking Eksekusi & Build App! = implement → audit → sync → commit → explicit App Build.

## CURRENT PHASE
- **V6.1 — source-only / DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## QC / SOURCE FREEZE
- QC is validation-first, not feature-development.
- Treat functional source as FROZEN during QC.
- [HISTORICAL] V5.8/V5.9 QC records apply only to those historical source versions; current source is V6.1.
- Only change functional source for a demonstrable/reproducible QC failure with a clear root cause.
- Do not refactor or change unrelated behavior while closing a QC finding.
- Record the finding, evidence, root cause, affected scope, fix, and re-audit result.

## AUTHORITY
1. CURRENT SOURCE / CURRENT WORKFLOW
2. PROJECT_STATE.md
3. AUTHORITATIVE NOTES
4. BUILD_NOTES.md / CHANGELOG.md / HANDOVER.md
5. CHAT_TRANSFER.md
6. CURRENT CHAT
7. OLD CHAT

## FIRMWARE RULES
- Functional image changes increment FW_VERSION.
- Active .ino filename matches FW_VERSION.
- One active versioned .ino under firmware/.
- No executable delay().
- No timing while() loops.
- Cooperative millis()-based timing.
- Local OTA is Golden/Protected.
- OTA has priority over normal application work.
- OTA protection reminder is active; protected OTA source/contract drift requires explicit discussion/approval.
- Anti-downgrade is intentionally OFF; any valid firmware version different from the device version may be installed.
- Hotside NTC safety is authoritative.

## OTA PROTECTION RULES
- OTA_PROTECTION.md is the engineering reminder for the protected OTA path.
- OTA changes require a demonstrated OTA defect, explicit discussion/approval, and a full OTA re-audit.
- Do not refactor or optimize OTA while working on unrelated functionality.

## APP RULES
- Firmware telemetry is authoritative for physical hardware state.
- Protocol tokens remain untranslated.
- User-facing text uses the localization layer.
- Wi-Fi credentials use secure storage.
- App Build is independent from Firmware build/flash.

## BUILD RULES
- App Build is manual-by-issue-trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Token: JEXFYZ_BUILD_TRIGGER_V1
- One normal APK, not a Play Store bundle.
- Obfuscated release build required.
- Normal push/PR must not generate a release APK.
- Firmware-only changes do not require App Build.
- Never claim build/compile/flash/runtime validation that did not occur.
- The active direct issue-triggered workflow publishes the APK to GitHub Release jexfyz-latest and does not use Actions artifacts.
- No reusable App Build engine is currently active.

## QC GATES
1. Firmware compile
2. BIN generation
3. Flash
4. Hardware-only behavior
5. Safety
6. Local OTA Golden Path
7. Online OTA + BLE recovery
8. App ↔ Firmware integration
9. Release Gate

## MEMORY RULES
- Persist meaningful project state in repository documentation.
- CHAT_TRANSFER.md is the latest transfer snapshot, not source of truth.
- Replace transfer snapshots; do not append repeated full snapshots.
- Obsolete history belongs in CHANGELOG or Git history, not Current State.
- Discussion memory sync must not change functional source.
- Current source/workflow always wins on conflicts.

## LATEST QC SOURCE FIX — 2026-10-13
- [IMPLEMENTED] Touch long-press Adaptive-OFF now emits authoritative Adaptive/ceiling/Fan/Peltier/Fan-speed telemetry; source blob: 50dee6c7ed3cb5780e97deaa235fe81856152ec2.
- [IMPLEMENTED] Added static source-contract regression test at test/firmware_touch_adaptive_sync_test.dart; test execution is UNVERIFIED.
- [UNVERIFIED] Firmware compile/BIN/flash, App tests/Build, physical sync validation, and OTA regression remain open. Do not upgrade any gate to PASS.

## CURRENT STATUS
- Phase: V6.1 source-only DEVELOPMENT + QC / PRE-RELEASE.
- Release status: NOT RELEASED.
- Firmware source: V6.1 (`firmware/JEXFYZ-V6.1.ino`); latest source blob 50dee6c7ed3cb5780e97deaa235fe81856152ec2; compile/BIN/flash unverified.
- App: 1.0.0+3.
- V6.1 source inventory: one NTC ADC-read call site and no `delay(` call site; this limited source check is not a compile or runtime test.
- V5.7 physical OTA update was user-confirmed successful; V6.1 physical validation is UNVERIFIED.
- V6.1 compile/BIN/flash/physical/OTA/App integration remain QC gates; no firmware compile workflow is active on `main`.
- Latest verified downloadable App Build remains historical; V5.9 App Build was NOT executed by this source integration.
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- OTA protection reminder: OTA_PROTECTION.md (documentation-only; no CI enforcement).
