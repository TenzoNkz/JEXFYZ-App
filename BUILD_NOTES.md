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
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, evidence boundary, trade-off, and prevention rules.
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
- [UNVERIFIED] The added V6.3 latch regression has not been run. User-reported compile success and restored GitHub connectivity are recorded above, but a complete OTA transfer/apply/reboot proof is not established here. No BIN generation/publication, assistant-side flash, independent hardware validation, Android BLE pairing, or APK Build was performed.
- [NOT RELEASED] V6.3 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

## HISTORICAL V6.2 FULL EXECUTION — 2026-10-13

- Active Firmware: `firmware/JEXFYZ-V6.2.ino`, blob SHA `88d92f652a3cf973eb34bcfe3a9d73d9cbd87123`; last Firmware source update commit `13377f00b49d9de0bbd31a872c0da7251be56e8d`. V6.1 source retired.
- App: `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`; latest App correction commit `116921bd28d280039ba191371fa276149466c802`; version unchanged at `1.0.0+3`.
- Thermal rules: 30-second protection stage at 12 V, 9 V and 5 V; Peltier OFF immediately, Fan 100%. Hotside <= `hotLimit - 1°C` for 5 continuous seconds before the 30-second deadline cancels the stage and keeps the rail. Otherwise 12 V/9 V steps down one rail and an unrecovered 5 V stage enters terminal manual-restart lock.
- Thermal voltage recovery: each upward rail needs 60 continuous seconds at or below `hotLimit - 1°C`, up to the saved Adaptive ceiling. Terminal 5 V lock does not auto-recover. Manual re-arm threshold is -1°C plus 5-second stability.
- Online OTA uses HTTPS CA validation while retaining the raw GitHub allowlist for `TenzoNkz/JEXFYZ-Firmware`. BLE command writes require an encrypted bonded connection with Secure Connections/Just Works. Local OTA was intentionally left unchanged.
- App updates: normal BLE reconnect scheduling after disconnect state update; OTA disconnect marker is armed before `CLOUDOTA`; voltage ACK is followed by authoritative `VOLTAGE` telemetry confirmation; RGB colors normalize optional `#`; Dashboard/Floating Monitor show unknown output status while offline; safety copy uses -1°C.
- Regression tests added/updated; `.gitignore` added. `pubspec.lock` is absent from `main`: an ephemeral GitHub Actions `flutter pub get` succeeded, but the generated lockfile push was rejected as non-fast-forward. Test/analyze steps were skipped and the temporary workflow was removed.
- Validation: a temporary quality workflow resolved dependencies but failed pushing `pubspec.lock` due non-fast-forward; tests/analyze were skipped and the temporary workflow was removed. No lockfile was committed. No APK build, firmware compile, BIN, flash, OTA or physical-device validation was performed.
- Release state: V6.2 source-only DEVELOPMENT + QC / PRE-RELEASE, NOT RELEASED. Production firmware repository and Firebase metadata were not changed.

# JE X FYZ — BUILD NOTES

## CURRENT PHASE
- Firmware V6.1 is the active **source-only QC / PRE-RELEASE** target.
- V6.1 is **NOT RELEASED** and has no current compile/BIN/flash evidence.
- App Build remains a separate explicit operation.


## APP BUILD POLICY
- App Build is explicit and separate from Firmware build/flash.
- Manual issue trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Required token: JEXFYZ_BUILD_TRIGGER_V1
- One normal APK, not a Play Store bundle.
- Obfuscation is required.
- Java 17 / Flutter 3.47.2 stable / Gradle 9.3.1 / ubuntu-24.04.
- Production signing certificate SHA256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0

## CURRENT DELIVERY WORKFLOW
- [COMMITTED] .github/workflows/jexfyz-app-build-trigger.yml is the only active App Build workflow.
- [COMMITTED] It is triggered only by issue opened/reopened events and gated by repository owner, exact title, and JEXFYZ_BUILD_TRIGGER_V1.
- [VERIFIED] Current `.github/workflows` directory contains only `jexfyz-app-build-trigger.yml`; the former `.github/workflows/firmware-build.yml` was deleted in commit `32bc3c3fcb0c074e39d7ea49428f98d7845e4073`.
- [USER REQUIREMENT] Firmware compile/build must be explicitly requested; do not start it as an automatic consequence of source execution or documentation sync.
- [COMMITTED] Normal push/PR do not trigger App Build.
- [COMMITTED] Release build is obfuscated and production-signed.
- [COMMITTED] Exactly one APK is published to GitHub Release jexfyz-latest as JEXFYZ-release.apk.
- [COMMITTED] Actions-artifact upload is not used.
- [VERIFIED] Latest downloadable Release delivery is workflow run 37245703677.

## LATEST VERIFIED RELEASE BUILD
- [BUILT][VERIFIED] Workflow run: 37245703677.
- [VERIFIED] Source commit: fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- [VERIFIED] Security/architecture audit, dependencies, Dart analysis, Flutter tests, obfuscated APK compilation, production signing, and filename preparation passed.
- [VERIFIED] GitHub Release jexfyz-latest updated successfully.
- [VERIFIED] Exactly one Release asset exists: JEXFYZ-release.apk.
- [VERIFIED] Asset ID: 610989112; size: 54,327,520 bytes; SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- [VERIFIED] Actions artifact list for the run is empty.

## QC / BUILD BOUNDARY
- Firmware QC does not imply App Build.
- App Build does not prove Firmware compile, flash, OTA, or physical behavior.
- Do not run App Build unless the explicit Build App command is given.

- Firmware-only/integrated QC changes do not automatically trigger or require App Build.
- This V5.9 integrated execution did not start an App Build.
- Do not infer Firmware compile/BIN/physical validation from an App Build result.
