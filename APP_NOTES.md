## CURRENT V6.4 EXECUTION STATUS — 2026-10-14

- [VERSION ALIGNMENT — SOURCE ONLY] Active source is `firmware/JEXFYZ-V6.4.ino` with `FW_VERSION = "V6.4"`; the V6.3-named active file is retired. The source revision has not been compiled; no BIN generation, flash/OTA, Firebase update, or release is implied.

### Peltier voltage-transition restart prevention — 2026-10-13

- [FIXED IN SOURCE — NOT COMPILED] On a voltage transition, firmware pauses Peltier PWM only if the 5-second soft-start is still active: it records that state and forces GPIO5 PWM to 0% before selector handoff. If soft-start has completed and PWM is already 100%, Peltier PWM stays at 100% throughout the voltage transition unless a Peltier-OFF command or safety protection stops it. Fan remains ON/forced to 100%; the existing 200 ms break-before-make selector sequence is unchanged.
- [IMPLEMENTED IN SOURCE] An interrupted ramp remains at 0% through the existing 1,000 ms settle interval (`PELTIER_VOLTAGE_SETTLE_MS`, aliased to `VOLTAGE_GUARD_MS`), then starts a fresh 5-second ramp from 0%. A completed ramp is not interrupted: it stays at 100% during the selector transition, without another soft-start or a forced 0% interval. Peltier-OFF, thermal/sensor safety, or OTA safe-output handling must stop output and cancel any pending ramp resume.
- [REGRESSION CONTRACT ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` checks pause-before-selector ordering only for an active ramp, the conditional 1-second settle/fresh-ramp path, uninterrupted 100% duty when the ramp already completed, cancellation on Peltier OFF, and reset-reason diagnostics.
- [USER-REPORTED SYMPTOM] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON during soft-start. A power transient/brownout is a plausible hypothesis, not a confirmed reset cause; capture `BOOT: RESET_REASON=...` after the next user-side reproduction.
- [UNVERIFIED] The latest source revision has not been compiled or tested on hardware. The earlier V6.3 compile report predates this fix. No BIN, flash, physical OTA, or release operation was performed.
- [CANONICAL MEMORY] See [VOLTAGE_TRANSITION_MEMORY.md](VOLTAGE_TRANSITION_MEMORY.md) for the full incident record, exact timing contract, safeguards, and validation boundary.

### Online OTA connection regression correction — 2026-10-13

- [SOURCE FIX IMPLEMENTED] V6.3 Online OTA restores the previous `cloudClient.setInsecure()` connection path. The inline ISRG Root X1 certificate, CA validation call, `configTime()`, `TIME_SYNCING` state, and 20-second NTP gate were removed. On Wi-Fi connection, the blue indicator runs directly before the GitHub GET attempt.
- [PRESERVED] The HTTPS transport, raw GitHub BIN URL allowlist for `TenzoNkz/JEXFYZ-Firmware`, redirect blocking, download size/image checks, safe-output sequencing, and OTA recovery path remain in place. `setInsecure()` does not validate the server certificate identity.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_4_qc_contract_test.dart` now asserts the restored connection path, removal of CA/NTP gates, blue-before-GitHub flow, and retention of the URL allowlist/redirect block.
- [USER-REPORTED RESULT — 2026-10-13] The user reports that V6.3 compiled successfully after this correction and Online OTA can connect to GitHub again. This confirms the reported compile/connect result only; a complete BIN transfer, successful `Update.end()`, reboot, and confirmation of the new firmware version were not separately established here. Because CA validation and the OTA-only NTP gate were removed together, the available evidence does not isolate which one alone caused the earlier failure.
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, evidence boundary, trade-off, and prevention rules.
- [NOT DONE BY ASSISTANT] No firmware compile, BIN generation/publication, flash, physical OTA run, or APK Build was performed by this assistant session.


### APP BLE reconnect and Online OTA acknowledgement follow-up — 2026-10-13

- [FIXED IN APP SOURCE] Disconnect rediscovery now avoids starting when Auto Connect is disabled or no previously paired cooler identity is known. The retry loop is cancelled when Bluetooth/permissions/location prerequisites fail, and scanning is suppressed during BLE syncing. Retry starts again when Auto Connect is enabled or the app resumes while disconnected.
- [FIXED IN APP SOURCE] A missing `CLOUDOTA` ACK due to `TIMEOUT` or `DISCONNECTED` is treated as ambiguous, not as a definite rejection. The app preserves OTA recovery state and tells the user it is waiting for reconnection or an OTA result. A definite rejection while BLE remains connected still follows the rejection path.
- [REGRESSION CONTRACTS ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` now checks both retry-loop cancellation and ambiguous OTA ACK handling. No Flutter tests or Dart analysis have run for this change because this environment has no Flutter/Dart executable.
- [PRESERVED BY USER INSTRUCTION] `android/app/build.gradle` still has `versionName "Telegram @horizontalzzz"` as the user's intentional identity. It was not modified.
- [VALIDATION BOUNDARY] Source and contract assertions were reviewed statically only; the user separately reports a successful firmware compile and restored GitHub connection. No Build App/APK build, BIN publication, flash, complete OTA install, or hardware validation was performed by this assistant session.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.4.ino`, blob `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. The user reports a successful firmware compile and GitHub connection, but no complete OTA transfer/apply/reboot proof is recorded here. No BIN generation/publication, flash, independent hardware validation, Android BLE pairing, or APK Build was performed by the assistant.
- [NOT RELEASED] V6.4 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

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

## CURRENT APP / V6.1 INTEGRATION STATUS — 2026-10-12

### TOUCH ADAPTIVE-OFF TELEMETRY SYNC FIX — 2026-10-13

- [VERIFIED SOURCE DEFECT] The hardware Touch long-press path called `setAdaptiveState(false, reason)` and sent only `ACK:TOUCH_ADAPTIVE;REASON=OFF`; unlike the App BLE command handler, it did not publish the `ADAPTIVE` state delta. The App ACK handler displays the result but does not mutate the Adaptive state, so the dashboard switch and Floating Monitor could remain stale.
- [IMPLEMENTED] The Touch Adaptive-OFF path now publishes authoritative `ADAPTIVE`, `ADAPTIVE_CEILING`, `FAN`, `PELTIER`, and `FAN_SPEED` state deltas before its Touch ACK. App continues to treat Firmware telemetry as authoritative; no speculative App-side state mutation was introduced.
- [PRESERVED] The 200 ms selector deadtime, safe-5V handoff, 5-second Peltier OFF→ON soft-start, deferred white 3-blink OFF indicator, BLE UUIDs/P1, and protected OTA code were not intentionally changed. `VOLTAGE` remains reported by the existing completed-transition path rather than being misreported as already settled during selector deadtime.
- [IMPLEMENTED] Added `test/firmware_touch_adaptive_sync_test.dart`, a static source-contract guard for the Touch telemetry sequence and App state-consumption path.
- [STATIC AUDIT ONLY] Current V6.1 version/file alignment is retained; source inventory remains one `analogReadMilliVolts(PIN_NTC)` call site, no lexical `delay(` call site, and no lexical `while(` loop call site.
- [UNVERIFIED] The new test has not been executed in this repository environment; no Flutter test/analyze, Arduino compile, BIN, flash, physical BLE/UI validation, App Build, or OTA regression was run as part of this change.
- [NOT RELEASED] V6.1 remains DEVELOPMENT + QC / PRE-RELEASE. No production BIN or Firebase OTA metadata was changed.

- [VERIFIED SOURCE AUDIT] App parser `_applyTelemetryValue('ADAPTIVE')` updates the shared `adaptiveOn` state, and Floating Monitor receives that same state through `_publishFloatingTelemetry()`. App functional source did not need modification for this defect.
- [UNVERIFIED] App Flutter tests/analyze and App Build remain unrun; the added static source-contract test is not a BLE/UI runtime test.


- [CURRENT TRUTH] App source remains version `1.0.0+3`, package `com.horizontalzzz.jexfyz`; no App source change is part of the V6.1 firmware fix.
- [UNVERIFIED] App ↔ V6.1 integration and UI behavior on the physical device are not yet validated. No App Build was executed for V6.1.
- [POLICY] The V5.9 integration/localization records below are historical records, not the current firmware target.

## CURRENT V5.9 APP LOCALIZATION + NOTIFY CLEANUP — 2026-10-07

- [IMPLEMENTED] English is the master/reference language for user-facing copy.
- [IMPLEMENTED] Indonesian wording is synchronized to the English meaning, context, tone, and severity.
- [IMPLEMENTED] Home NOTIFY no longer exposes reset/debug text such as `Reset: POWER_ON`; user-facing reset messages are localized and concise.
- [IMPLEMENTED] Known safety, command, connection, and OTA status messages use professional, minimal wording without firmware protocol tokens or underscore-formatted reasons.
- [IMPLEMENTED] Error-state classification is language-aware for English and Indonesian.
- [IMPLEMENTED] Home NOTIFY message and status text explicitly disable text decoration to prevent accidental underline rendering.
- [IMPLEMENTED] Core Hotside terminology is standardized as “Hotside” / “Suhu Hotside”; “Sakelar” is used for Indonesian switch labels.
- [IMPLEMENTED] Localization regression coverage was updated for Hotside terminology, Notify error detection, Peltier re-arm copy, and POWER_ON reset handling.
- [NOT BUILT HERE] Flutter analyze/test execution and App Build remain pending.

## CURRENT V5.9 INTEGRATED QC BATCH — 2026-10-06

- Firmware source: `firmware/JEXFYZ-V5.9.ino`.
- App: 1.0.0+3.
- Status: DEVELOPMENT + QC / PRE-RELEASE — NOT RELEASED.
- App + Firmware are one integrated contract.
- Peltier safety re-arm: effective Hotside lock + one-shot post-safety feedback; Touch/BLE/Adaptive use the same effective safety gate.
- App: P1 required for session readiness; stale Peltier re-arm notice clears on healthy safety telemetry; safety-sensitive paired startup is serialized; PHONE:BT is coalesced; ONLINE_IMAGE_VALIDATE is mapped.
- Android notification preference is not saved ON unless runtime permission is granted.
- Foreground BLE-support service is NOT_STICKY.
- OTA Local, OTA Online, Wi-Fi↔BLE handoff, OTA state/recovery, image validation, URL/path contract, and BLE/P1/SYNC architecture remain FROZEN.
- `versionName "Telegram @horizontalzzz"` is intentional and unchanged.
- App Build was NOT requested by this execution.
- V5.9 compile/flash/physical regression and final release gate remain pending.

## FIRMWARE V5.3 SYNC — 2026-10-05
- [IMPLEMENTED IN FIRMWARE] Both Adaptive profiles now enforce a 5-second dwell after each completed upward voltage step.
- [PRESERVED] Downward Adaptive voltage changes remain immediate.
- [PRESERVED] App version remains 1.0.0+3; no App source change was required for this firmware-only behavior.
- [NOT BUILT HERE] App Build was not executed.

## APP PELTIER SAFETY NOTIFY — 2026-10-05
- [IMPLEMENTED] Peltier restart failures now explain the Hotside re-arm requirement, using the configured hotLimit minus 2°C.
- [IMPLEMENTED] The retired RAPID_HOTSIDE_RISE notification mapping was removed.
- [IMPLEMENTED] ACK handling treats ON/OFF as valid outcomes and shows unsolicited Touch cooling success in NOTIFY instead of flagging it as an error.
- [IMPLEMENTED] Peltier failure notices avoid duplicating a firmware-supplied safety reason.
- [NOT BUILT HERE] App Build was not executed.

## APP SAFETY NOTIFY / REARM — 2026-10-05
- Peltier restart lock notification states that Hotside must cool to `hotLimit - 2°C` before restart.
- Touch-generated ON/OFF ACK outcomes are classified correctly and surfaced as clean NOTIFY messages.
- Peltier failure notices prefer the firmware safety reason and avoid a duplicate generic warning.
- Retired RAPID_HOTSIDE_RISE presentation was removed.
- App Build was not executed.

## APP HOME FAN SPEED DISPLAY QC — 2026-10-05
- Fixed Home Fan Speed presentation for Adaptive + 12V: Fan Speed now displays 100% instead of --.
- Manual + 12V continues to display the actual configured Fan Speed.
- Adaptive Fan Speed remains non-editable; this change is presentation only.
- Added regression tests for Adaptive 12V = 100%, Manual 12V = configured speed, and 9V = 100%.
- No App Build was executed for this source fix.

## 2026-10-05 — BUILD APP #9 SUCCESS / V4.8 HOTSIDE TERMINAL RE-ARM

- Build #9 run `37268139253` completed successfully from source commit `9d44514cf251416ba75d71b039750f4fd33ae5e2`.
- Passed all active release gates: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, JE X FYZ security/architecture audit, dependency installation, `flutter analyze --no-fatal-infos`, `flutter test`, obfuscated release APK compilation, production signing verification, filename preparation, and GitHub Release publication.
- Release APK was compiled successfully at `build/app/outputs/flutter-apk/app-release.apk` and published as `JEXFYZ-release.apk`.
- Production signing verification passed:
  - DN: `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - Certificate SHA-256: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- GitHub Release `jexfyz-latest` contains exactly one APK asset: `JEXFYZ-release.apk`, asset ID `611619423`, size `54,327,520` bytes.
- Published APK SHA-256/digest: `64f9be08a28007e42a27dfd7b0459857a06d7146200113a405638ef8f0353058`.
- Release URL: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest
- Build URL: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/37268139253
- Current delivery workflow intentionally avoids Actions artifact storage quota and publishes exactly one direct APK to the GitHub Release.
- Dart symbols were generated by `--split-debug-info=build/symbols`, but the current direct Release workflow does not publish symbols separately.
- App package metadata remains `1.0.0+3`; Android user-visible version label remains `Telegram @horizontalzzz`.
- Source contains the latest V4.8 Hotside terminal re-arm hardening state. CI validates App compilation/signing only; no physical ESP32 runtime test occurred during Build #9.

## 2026-10-05 — PELTIER POPUP START SEQUENCE
- [IMPLEMENTED] Removed the UI-side Fan confirmation wait when starting Peltier from Fan-OFF via the Safety popup.
- [IMPLEMENTED] After popup approval, App starts both confirmation flows immediately; the serialized GATT write queue sends FAN:ON followed directly by PELTIER:ON.
- [PRESERVED] Firmware remains the final safety authority and keeps the 5-second Peltier soft-start.
- [NOT BUILT HERE] No App Build was executed for this source change.

## 2026-10-05 — BUILD APP #8 SUCCESS / V5.0 FIRMWARE SOURCE

- Build #8 run `37261171475` completed successfully from source commit `eeeec79e729383c4c588719efac677373a62bfa9`.
- Passed all active release gates: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, JE X FYZ security/architecture audit, dependency installation, `flutter analyze --no-fatal-infos`, `flutter test`, obfuscated release APK compilation, production signing verification, release filename preparation, and GitHub Release publication.
- Production signing verification passed with the required JE X FYZ certificate DN and SHA-256.
- GitHub Release `jexfyz-latest` contains exactly one APK asset: `JEXFYZ-release.apk`, asset ID `611422021`, size `54,327,520` bytes.
- Published APK SHA-256/digest: `b8045d0b6fa6d05b421bd6b1c0318d4ee4529734d7b471534700f95676200888`.
- Release URL: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest
- Build URL: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/37261171475
- The current delivery workflow intentionally avoids Actions artifact storage quota and publishes exactly one direct APK to the GitHub Release.
- Dart symbols were generated by `--split-debug-info=build/symbols`, but the current Release delivery workflow does not publish the symbols as a separate artifact.
- App package metadata remains `1.0.0+3`; Android user-visible version label remains `Telegram @horizontalzzz`.
- Build #8 remains App-only validation; it does not validate V5.0 ESP32 runtime behavior.

# JE X FYZ — CURRENT APP NOTES

- App CONTROL source change commit: b9f316e50770acb66770515395344de6c6e80ea6

## CURRENT IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Main source blob: df4a244723420f8057745275838d7e07c1e0c82a
- Settings blob: f11235bab559b291928550e06984532581ddad6a
- Tests blob: 2da4bff01d3eed749eeba873e9ec2e577c04def9

## CURRENT PHASE
- App remains in DEVELOPMENT + QC; current Firmware integration target is V5.9.
- App version remains 1.0.0+3.
- Android versionName remains intentionally Telegram @horizontalzzz.
- P1 is required before BLE dashboard/session readiness.
- Command confirmations are serialized at the high-level transaction layer.
- PHONE:BT heartbeat values are coalesced; no unbounded 1 Hz write backlog is allowed.
- Current source/runtime compile and device integration gates remain unverified.


## CONTROL
- Peltier ON from Fan-OFF state: after the safety popup is approved, the App queues FAN:ON and PELTIER:ON together; the BLE write queue preserves that order without waiting for Fan telemetry between commands.
- Fan already ON -> Peltier ON remains immediate.
- Firmware remains responsible for the 5-second Peltier soft-start.
- Realtime QC fix: unsolicited FAN/PELTIER/FAN_SPEED telemetry is applied immediately as firmware-authoritative Control state.
- Firmware remains the final safety authority; App does not add a fixed precharge timer.
- Peltier still uses the existing command-confirmation timeout, while the firmware remains responsible for the 5-second Peltier soft-start.
- Notify QC fix: stale command/connection errors clear only after healthy live cooling/safety telemetry; actual safety warnings remain visible.

## BLE / SESSION
- flutter_blue_plus is the BLE transport.
- JE X FYZ service/RX/TX UUIDs are frozen.
- P1 SYNC/SYNC_READY remains the usable-session gate.
- Firmware telemetry remains authoritative for hardware and safety state.
- Passive Auto Connect remains permission-free and preference-controlled.
- Online OTA recovery is explicit and does not depend on passive Auto Connect.
- Expected Online OTA GATT disconnect is treated as an OTA lifecycle event, not a normal Bluetooth error.
- After OTA reconnect, the App completes normal P1 sync and surfaces the one-shot OTA result.

## OTA PROTECTION
- OTA_PROTECTION.md is the repository reminder for the protected OTA path.
- OTA behavior is frozen during unrelated App work and should not be refactored or optimized casually.
- Any OTA change requires a demonstrated OTA defect, explicit discussion/approval, and full OTA re-audit.
- Anti-downgrade is OFF: any valid version different from the device version may be selected.

## OTA / FIRMWARE SYNC
- Firmware update flow remains OTAENTER, SSID, PASS, URL, VERSION, CLOUDOTA.
- OTA_UP_TO_DATE is recognized as a one-shot result.
- V5.7 OTA update to the physical hardware is user-confirmed successful.
- App uses firmware-reported Adaptive Ceiling and current SAFETY OK/LOCKED semantics.
- Battery thresholds remain 5V 20–30°C and 12V 30–40°C; current firmware source is V5.7.
- Current Firmware OTA stage tokens are mapped for presentation.
- Wi-Fi password input is masked.
- Firebase supplies release metadata; GitHub hosts the fixed firmware BIN URL.
- Wi-Fi credentials remain in flutter_secure_storage.
- V5.2 firmware preserves the P1 command contract and adds Peltier safety re-arm feedback; App control now starts Fan/Peltier back-to-back from the safety popup.

## BUILD / CI STATUS
- Latest verified downloadable App Build: workflow run 37245703677.
- Current release workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- Active workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- Workflow is a direct owner/title/token-gated issue-triggered Release build.
- Workflow publishes exactly one JEXFYZ-release.apk to GitHub Release jexfyz-latest.
- No Actions artifact is used by the current delivery path.

## V5.0 FIRMWARE CONTROL / SELECTOR
- GPIO3 = 12V Optocoupler/Decoy selector; GPIO4 = 9V Optocoupler/Decoy selector.
- Both selector outputs are OFF for 200 ms before the target output is enabled; they are never active together.
- GPIO5 Peltier MOSFET and GPIO6 Fan MOSFET remain physically active during selector voltage changes; Peltier PWM is not forcibly cleared.
- Fan is forced to 100% at the start of every voltage transition. Fan Speed is user-adjustable only at 12V.
- Returning to 12V does not restore a previous Fan Speed preference; Fan remains at 100% until manually changed.
- HOTSIDE LED red blink lasts 10 seconds during each HOTSIDE timing stage, including the 5V terminal stage.

## V4.8 HOTSIDE
- HOTSIDE safety dwell is non-blocking and uses 10 seconds before each lower-voltage step.
- 12V hot: Fan ON / Peltier OFF → 10s → 9V.
- 9V hot: Fan OFF / Peltier OFF → 10s → 5V.
- 5V hot: terminal Peltier OFF; Adaptive exits and manual restart remains latched until Hotside cools below the re-arm threshold.
- App no longer adds a fixed 2-second precharge before PELTIER:ON.
- App Build remains a separate operation.