## CURRENT V5.9 QC FOLLOW-UP — 2026-10-08

- [IMPLEMENTED / COMMITTED] Latest Firmware source remains `firmware/JEXFYZ-V5.9.ino`; current source blob: `18982b3af0f235bade264643c8022f2cd1ce2d72`; implementation commit: `5190d8d587e358e3853a483c34b9a09ddd9620dc`.
- [USER-CONFIRMED / PRE-FIX] Firmware compiled successfully and V5.9 Online OTA updated the hardware before this QC follow-up.
- [IMPLEMENTED] Adaptive Hotside recovery dwell is now 30 seconds only at 12 V and 9 V: 29 seconds red blink + final 1 second blue before stepping down.
- [IMPLEMENTED] Adaptive 5 V is terminal: no 30-second countdown and no blue phase. While Hotside remains above the re-arm threshold, Adaptive exits into the manual-restart thermal lock and the LED remains continuous red until Hotside reaches <= `hotLimit - 2°C`.
- [IMPLEMENTED] Peltier command-result LED feedback has been removed. Peltier ON/OFF commands no longer start a separate red/green indicator that can interrupt the Hotside red blink. Green remains reserved for thermal re-arm.
- [IMPLEMENTED] Adaptive activation is now gated: Fan and Peltier must already both be ON from the Control menu. Pressing Adaptive with either output OFF is denied and does not turn either output ON.
- [PRESERVED] OTA runtime, BLE/P1, GPIO mapping, NTC single-sample cadence, selector deadtime, voltage guard, Peltier soft-start, and Adaptive 5-second upward dwell were not intentionally changed.
- [AUDIT PASS] Post-change static audit: no executable `delay()`, no timing `while()`, no `RAPID_HOTSIDE_RISE`, exactly one `analogReadMilliVolts(PIN_NTC)` path, GPIO5=Peltier / GPIO6=Fan, braces balanced, obsolete Peltier attempt-indicator symbols removed.
- [UNVERIFIED] This post-fix source has not yet been recompiled, flashed, physically regression-tested, or used for a new OTA/BIN publication.
- [NOT RELEASED] Project remains V5.9 DEVELOPMENT + QC / PRE-RELEASE.

## V5.9 APP LOCALIZATION / NOTIFY CLEANUP — 2026-10-07

- Standardized English as the master/reference language for user-facing App copy.
- Synchronized Indonesian translations to the same meaning, context, tone, and severity.
- Replaced user-facing reset/debug wording such as `Reset: POWER_ON` with concise localized status messages.
- Removed raw internal reason presentation from known Peltier, Fan, Adaptive, LED, temperature, connection, and command feedback.
- Made Notify error classification language-aware for English and Indonesian.
- Added explicit `TextDecoration.none` to Home Notify message and status text.
- Standardized core UI terminology around Hotside and Indonesian “Sakelar”.
- Updated localization regression tests.
- App Build and current Flutter analyze/test execution remain unverified.

## V5.9 HOTSIDE RECOVERY / LED QC UPDATE — 2026-10-07

- Changed Adaptive Hotside thermal recovery from 10 seconds to 20 seconds per rail.
- Adaptive Hotside LED now blinks red for the first 19 seconds and blue during the final 1 second before a required step-down.
- If Hotside reaches <= hotLimit - 2°C before the 20-second boundary, the Peltier is allowed to resume on the same Adaptive rail and the LED blinks green 2x.
- Adaptive Hotside now applies the 20-second stage independently at 12V, 9V, and 5V.
- After an unrecovered 20-second 5V stage, Adaptive exits and the Peltier remains locked until thermal re-arm and manual restart.
- Manual Hotside protection now keeps red LED indication active for the entire thermal lock until Hotside reaches <= hotLimit - 2°C, then shows green 2x; the selected Manual voltage is preserved.
- Removed the previous green feedback attached to a successful Peltier ON command so green exclusively communicates thermal re-arm readiness.
- OTA, BLE/P1, selector timing, voltage guard, and Peltier soft-start behavior were not intentionally changed.
- V5.9 compile/BIN/flash/physical/OTA/App integration and release gates remain unverified.

## V5.9 APP + FIRMWARE BLE QC INTEGRATION — 2026-10-06

- Repaired the App 1 Hz PHONE:BT heartbeat into a valid class method with coalescing so only the newest pending value is retained.
- Required `PROTOCOL=P1` in the active BLE session readiness polling gate.
- Command-owned BLE ACK errors no longer emit a competing generic error snackbar.
- Fan→Peltier popup startup now stops after an unconfirmed Fan start; Peltier safety reasons `PELTIER_SAFETY_LATCH` and `HOTSIDE_PROTECTION` retain notification priority.
- Added regression coverage for P1 readiness, stale Peltier re-arm notice clearing, and `ONLINE_IMAGE_VALIDATE` presentation mapping.
- Firmware V5.9 Peltier safety re-arm, Touch, and Adaptive semantics remain aligned; OTA runtime behavior was not changed.
- V5.9 compile/BIN/flash/physical/OTA runtime and explicit App Build remain pending.
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

## V5.8 PELTIER REARM + NTC SINGLE-SAMPLE QC FIX — 2026-10-06
- Promoted Firmware V5.7 → V5.8 for two reproducible QC findings.
- Fixed the Peltier safety-lock state so its effective lock clears automatically once Hotside reaches `hotLimit - 2°C`.
- Preserved the red 1-second LED for blocked Peltier ON attempts while the effective safety lock is active.
- Preserved one-shot green 1-second LED feedback for the first successful Peltier ON after a safety-forced shutdown.
- Replaced the V5.6 16-sample trimmed-mean NTC path with exactly one calibrated ADC reading every 1 second.
- Preserved the existing 10K NTC / 10K resistor / Beta 3950 / 3.3 V conversion model.
- OTA, BLE/P1, GPIO, Adaptive timing, selector timing, voltage guard, and Peltier soft-start were not intentionally changed.
- App source/build was not changed or run for this Firmware-only QC fix.

## OTA PROTECTION REMINDER — 2026-10-06
- Replaced the temporary CI-based OTA Security Seal experiment with the requested repository reminder file OTA_PROTECTION.md.
- Removed the dedicated OTA Seal workflow and manifest/lock files.
- Preserved the existing V5.7 OTA behavior and the policy that any valid firmware version different from the device version may be installed.
- No anti-downgrade policy was introduced.
- No App Build was executed.

## V5.7 TTP223 TOUCH ACCURACY QC FIX — 2026-10-06
- Promoted Firmware V5.6 → V5.7 for a targeted TTP223 touch recognition correction.
- Added 30 ms raw-input qualification for PRESS and RELEASE edges to reject short false transitions.
- Added 60–500 ms valid tap duration using raw HIGH duration.
- Increased double-tap window to 800 ms, starting after the first valid tap release.
- Added second-tap grace: a second tap started before the deadline is allowed to finish after the deadline.
- Preserved 3+ tap cancellation by resolving a double sequence at the decision boundary instead of firing it immediately on the second release.
- Added 1-second startup grace and blocks boot-held touch until a qualified release.
- Preserved the existing 1x voltage, 2x RGB, and 5-second long-press command semantics.
- App source/build was not changed or run for this Firmware-only QC fix.

## V5.6 NTC ADC FILTERING QC FIX — 2026-10-06
- Promoted Firmware V5.5 → V5.6 for a targeted NTC QC correction.
- Replaced single-sample Hotside ADC capture with 16-sample calibrated burst sampling.
- Uses a 50% trimmed mean: discard 4 lowest and 4 highest samples, then average the 8 middle samples.
- Preserved the 3.3 V divider-reference calculation, 10K NTC / 10K resistor / Beta 3950 model, and 1-second sampling cadence.
- Did not add EMA/Kalman temperature filtering, speculative VREF changes, voltage clamping, or offset calibration.
- App source/build was not changed or run for this Firmware-only QC fix.

## V5.5 PELTIER SAFETY REARM LED FEEDBACK — 2026-10-06
- Promoted Firmware V5.4 → V5.5 for a targeted QC correction.
- Removed the normal Peltier ON/OFF green/red LED feedback.
- Re-scoped the Peltier LED to safety re-arm attempts only after Hotside Safety forces Peltier OFF.
- Failed re-arm ON attempts blink red for 1 second; successful re-arm ON attempts at hotLimit - 2°C blink green for 1 second.
- The existing manualPeltierSafetyLatch remains authoritative; it is cleared only after the successful re-arm ON attempt.
- Adaptive start cannot bypass an active Peltier safety latch.
- Hotside dwell LED priority is preserved: 9 seconds red blink + final 1 second green blink.
- App source/build was not changed or run for this Firmware-only QC fix.

## V5.4 HOTSIDE DWELL FAN + LED QC FIX — 2026-10-06
- Promoted Firmware V5.3 → V5.4 for a targeted QC correction.
- Adaptive HOTSIDE safety now keeps Fan ON at 100% through the full 10-second thermal dwell at every rail.
- Completed HOTSTEP transitions keep Fan ON at 100% while Hotside safety is active.
- Hotside dwell LED now blinks red for the first 9 seconds and green for the final 1 second.
- Preserved the 10-second thermal dwell, 5-second Adaptive upward dwell, 200 ms selector deadtime, 1 s voltage guard, and 5-second Peltier soft-start.
- App source and App Build were not changed or run for this Firmware-only QC fix.

## V5.3 ADAPTIVE VOLTAGE RISE DWELL — 2026-10-05
- Promoted Firmware V5.2 → V5.3.
- Both Adaptive profiles (HOTSIDE and HOTSIDE_BATTERY) now wait 5 seconds after every completed upward voltage step before allowing another increase.
- Adaptive activation from the mandatory safe 5V state starts the same 5-second upward dwell.
- Downward Adaptive steps remain immediate.
- The existing cooperative millis() timing model is preserved; no blocking delay/while timing was introduced.
- App source/build was not changed or run for this firmware-only revision.

## V5.2 TOUCH ACK CLEANUP — 2026-10-05
- Corrected the successful hardware Touch cooling OFF acknowledgement to use `OFF` rather than the generic safety reason, preventing a false NOTIFY error.
- Firmware remains V5.2 with the same 1-second Peltier command result indicators and 2°C re-arm latch.
- No App Build was executed.

## APP SAFETY NOTIFY CLEANUP — 2026-10-05
- Unified Peltier safety failure wording around the configured Hotside re-arm threshold.
- Removed retired RAPID_HOTSIDE_RISE notification mapping.
- Touch ON/OFF ACK reasons are treated as valid outcomes and shown cleanly.
- Duplicate generic Peltier failure notices are suppressed when firmware already reports the safety reason.
- No App Build was executed.

## V5.1 PELTIER SAFETY REARM FEEDBACK — 2026-10-05
- Promoted Firmware V5.0 → V5.1 for the requested Peltier restart protection and feedback.
- Manual and 5V Adaptive-terminal Peltier restart stays locked until Hotside reaches hotLimit - 2°C.
- Hardware Touch cooling ON now enforces the same re-arm hysteresis and no longer bypasses the latch.
- Failed Peltier ON attempts blink red for 1 second; successful Peltier ON attempts blink green for 1 second.
- App NOTIFY explains the required re-arm temperature and cleans up ACK success/failure wording.
- No App Build was executed.

## APP HOME FAN SPEED DISPLAY — 2026-10-05
- Fixed Home Fan Speed showing `--` while Adaptive Mode was ON at 12V.
- Adaptive + 12V now displays `100%`, matching the firmware-enforced Fan speed.
- Manual + 12V keeps displaying the configured Fan Speed; Adaptive Fan Speed control remains locked.
- Added regression coverage for Adaptive 12V = 100%, Manual 12V configured speed, and 9V = 100%.
- No App Build was executed.

## APP PELTIER POPUP START — 2026-10-05
- Removed the App-side confirmation wait after FAN:ON when starting Peltier from Fan-OFF through the Safety popup.
- FAN:ON and PELTIER:ON confirmation flows are now started together; the BLE write queue sends FAN:ON first and PELTIER:ON immediately after the Fan write completes, without waiting for Fan telemetry.
- Firmware safety authority and the existing 5-second Peltier soft-start remain unchanged.
- No App Build was executed.

## V5.0 SELECTOR / MOSFET / HOTSIDE LED TIMING — 2026-10-05
- Promoted Firmware V4.9 → V5.0 for the approved voltage-selector and cooling-output behavior revision.
- Voltage selector contract: GPIO3 = 12V Optocoupler/Decoy selector, GPIO4 = 9V Optocoupler/Decoy selector; both selector outputs are OFF for the mandatory 200 ms break-before-make deadtime and are never active together.
- GPIO5 Peltier MOSFET and GPIO6 Fan MOSFET are not forcibly turned OFF during voltage changes; the active Peltier PWM/output state continues through the selector deadtime.
- Fan is forced to 100% at the start of every voltage transition and remains the only allowed speed while transitioning or operating outside 12V.
- Fan Speed commands are accepted only at 12V and are rejected during a voltage transition; returning to 12V does not restore a previous preference and leaves Fan at 100% until the user manually changes it.
- HOTSIDE LED indication now blinks red for the full 10-second timing window at every HOTSIDE protection stage, including the final 5V terminal stage.
- Peltier OFF → ON keeps the existing 5-second cooperative soft-start.
- No App Build was executed as part of this Firmware-only change.

## V4.9 ADAPTIVE HOTSIDE LED — 2026-10-05
- Promoted Firmware V4.8 → V4.9 for the approved Adaptive Hotside LED stage indication.
- The Hotside LED red-blink indicator now fires once for each safety stage: initial hot stage, after a successful 12V → 9V step, and after a successful 9V → 5V terminal step.
- LED indication is event-driven and does not repeat every main-loop iteration while the Hotside limit remains active.
- All V4.8 safety timing and cooling behavior remains unchanged.
- App source/build was not changed by this firmware-only LED revision.

## V4.8 HOTSIDE SAFETY SEQUENCE — 2026-10-05
- Promoted Firmware V4.7 → V4.8 for the approved HOTSIDE-only thermal sequence.
- At 12V Hotside limit: Fan remains ON, Peltier turns OFF, and the controller holds 12V for 10 seconds before stepping to 9V.
- At 9V Hotside limit: Fan turns OFF, Peltier remains OFF, and the controller holds 9V for 10 seconds before stepping to 5V.
- At 5V Hotside limit: Peltier remains OFF as the terminal protection state; Adaptive exits and manual Peltier restart is required after thermal re-arm.
- Manual-mode Hotside protection preserves the currently selected voltage and forces Fan ON / Peltier OFF; it does not force an unrelated voltage change.
- Manual Peltier safety re-arm uses 2°C hysteresis below the configured Hotside limit.
- Rapid Hotside-rise/slope protection remains absent.
- Peltier OFF → ON retains the existing 5-second firmware soft-start.
- Removed the redundant App-side fixed 2-second Fan precharge; the Firmware owns Peltier startup timing.
- No App Build is performed as part of this Firmware execution.
## V4.7 REALTIME TELEMETRY QC FIX — 2026-10-05
- Promoted Firmware V4.6 → V4.7 after hardware/App QC exposed stale realtime Fan/Peltier state in the App.
- Firmware cooling telemetry now uses pre-mutation state snapshots across Touch, Adaptive, safety, voltage completion, and command-setter paths.
- App applies unsolicited FAN/PELTIER/FAN_SPEED telemetry directly to Control state.
- App Home Notify clears stale command/connection errors only after healthy live cooling/safety telemetry; safety warnings remain visible.
- Home Notify warning presentation is gated by active BLE connection.
- Added regression coverage for realtime Notify reconciliation.
- No App Build was executed.
- V4.7 is NOT RELEASED pending compile/BIN/flash/OTA and App integration QC.

## APP CONTROL PRECHARGE — 2026-10-05
- Added a 2-second Fan precharge interval when the user requests Peltier ON while Fan is OFF.
- App now waits for confirmed FAN=ON telemetry before starting the 2-second interval.
- After the interval, App re-validates BLE connection, Adaptive OFF, and Fan ON before sending PELTIER:ON.
- Fan already ON remains an immediate Peltier-start path; no extra delay is added.
- Added a regression test locking the precharge duration to exactly 2 seconds.
- Firmware source, Firmware behavior, BLE protocol tokens, and App Build workflow were not changed.

## QC / PRE-RELEASE MODE — 2026-10-05
- V4.6 code is complete and the project is now in QC / PRE-RELEASE.
- Functional source is frozen during QC unless a demonstrated defect requires a targeted fix.
- The next release gate is Firmware V4.6 compile → BIN → flash → Hardware QC.
- V4.6 is not released.

## V4.6 — 2026-10-05
- Promoted the active Firmware source from V4.5 to V4.6 for the approved hardware control changes.
- Changed hardware single-tap voltage selection to the requested bounce sequence: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON via touch now forces Fan PWM to 100%.
- Preserved the existing Peltier OFF → ON 5-second soft-start.
- Preserved BOOT_AP_HARD_LIMIT_MS at 60 seconds.
- Removed Rapid Hotside-rise protection, including its dedicated slope threshold, event flag, and Hotside history state.
- Preserved normal Hotside temperature-limit safety.
- Preserved Local OTA, Online OTA, BLE/P1, Adaptive, RGB, telemetry, and App behavior.
- No App Build was executed for this Firmware-only change.

## VERIFIED RELEASE BUILD — 2026-10-05
- Workflow run 37245703677 completed successfully from source commit fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- All build, analysis, test, obfuscated release compilation, and production signing gates passed.
- GitHub Release `jexfyz-latest` now contains exactly one asset: `JEXFYZ-release.apk`.
- Release asset ID: 610989112; size: 54,327,520 bytes; SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- No Actions artifact was created.

## RELEASE DELIVERY RESTORE — 2026-10-05
- Converted the restored reusable App Build engine from Actions-artifact delivery back to direct GitHub Release delivery.
- Engine now requires `contents: write`, publishes exactly one `JEXFYZ-release.apk` under `jexfyz-latest`, and replaces the existing asset with `--clobber`.
- Trigger workflow was raised to `contents: write` so the reusable workflow can publish the Release.
- No App/Firmware runtime source was changed.
- This execution includes an explicit Build App run to verify the new Release delivery path.

## APP BUILD WORKFLOW RESTORE UNDER NEW NAMES — 2026-10-05
- Restored the proven two-workflow App Build architecture without reusing the legacy filenames.
- Manual trigger: `.github/workflows/jexfyz-app-build-trigger.yml`.
- Reusable build engine: `.github/workflows/jexfyz-app-build-engine.yml`.
- The restored engine is based on the Build #50-era verified configuration: Java 17, Flutter 3.47.2, Gradle 9.3.1, production signing verification, obfuscated release APK, Actions artifact for the APK, and Dart symbols artifact.
- The previous `.github/workflows/jexfyz-build.yml` single Release-asset workflow was removed.
- No App Build was started by this execution; this is a workflow/configuration restore only.
- App/Firmware runtime source was not changed.

# JE X FYZ — CHANGELOG

## CI ARTIFACT QUOTA FIX — 2026-10-04
- Replaced Actions-artifact APK delivery in `.github/workflows/jexfyz-build.yml` with direct GitHub Release asset publication.
- Workflow permission changed from `contents: read / actions: write` to `contents: write`.
- Exactly one delivery asset is maintained as `jexfyz-latest / JEXFYZ-release.apk`; existing assets are replaced with `--clobber`.
- This removes Actions-artifact storage quota from the APK delivery path.
- App/Firmware runtime source was not changed.
- Workflow run #2 verified the new Release asset path end-to-end.
- Existing Release updates now retarget `jexfyz-latest` to the current build commit and keep it marked Latest.


## SINGLE WORKFLOW / BUILD RUN #1 — 2026-10-04
- Deleted the legacy `.github/workflows/app-build.yml` and `.github/workflows/app-build-trigger.yml`.
- Created the new single `.github/workflows/jexfyz-build.yml`, based directly on the former App Build engine and gated by the dedicated owner/title/token issue trigger.
- Build run 37199918015 completed security/architecture audit, dependency installation, Dart analysis, Flutter tests, release APK compilation, production signing verification, and filename preparation successfully.
- Artifact upload was blocked by GitHub Actions artifact storage quota; no downloadable artifact was created.

## APP BUILD RUN #2 — VERIFIED — 2026-10-04
- Workflow run: 37201925842
- Source commit: 9136f11799143d91eb58e947ea10e9e576bb579f
- All App CI/security/build/signing gates passed.
- GitHub Release `jexfyz-latest` was updated successfully with exactly one asset: `JEXFYZ-release.apk`.
- Release asset ID: 609813273
- APK size: 54,327,520 bytes
- APK SHA256: 24fcd6f4d1f7843f34e8a31c352b43f23a581b57fc2d29ae71053eb7924092bb
- No Actions artifact was created by this run.

## V4.5 — 2026-10-04
- Promoted the active firmware source from V4.4 to V4.5 for functional hardening.
- Fixed explicit Online OTA GATT disconnect ordering so an active BLE session is closed before Wi-Fi radio handoff.
- Made OTA_UP_TO_DATE a one-shot LAST_OTA_RESULT event.
- Gated rapid Hotside-rise protection on Peltier being ON.
- Removed dead firmware state/legacy comparator and generated documentation noise.
- Synchronized App OTA recovery, safety presentation, Adaptive Ceiling, battery limits, and current OTA stage mapping.

## BUILD APP WORKFLOW RESET — 2026-10-04
- Deleted and recreated both App Build workflows.
- Historical workflow reset used Actions-artifact cleanup; current delivery uses GitHub Release asset publication.
- Trigger workflow remains manual issue-based and is restricted to the repository owner.

## BUILD APP CI — 2026-10-04
- Build #51 failed during Dart analysis because _startCloudOta was missing its closing brace; fixed in commit ea5261230245fc86061cdf85f65ccd0208e607d3.
- Build #52 confirmed App compilation and signing were correct; its workflow failed on a shell pipefail/SIGPIPE signing-output pipeline and was fixed in commit e33141efd47b8f1ca025e832097e1106d9119b65.
- Build #53 passed audit, analysis, tests, APK compilation, and production signing verification, then failed only because GitHub Actions artifact storage quota was exhausted.
- Current App build workflow publishes one replaceable direct GitHub Release asset and no separate symbol asset.

## V4.4 — 2026-10-04
- Added explicit active BLE GATT disconnect before Online OTA Wi-Fi handoff.
- Preserved the V3.2-style Online OTA transport/retry/result-indicator behavior.
- User subsequently confirmed V4.4 Local OTA and Online OTA success.

## V4.3 — 2026-10-04
- Restored Online OTA to the pre-yellow V3.2-style path.
- Removed yellow progress indicators and V4.2 cumulative passive Wi-Fi retry.
- User confirmed Local OTA and Online OTA success.

## V4.2 — 2026-10-04
- Introduced cumulative Online OTA Wi-Fi connection handling.
- Superseded by V4.3 rollback.

## V4.1 — 2026-10-04
- Simplified Online OTA Wi-Fi retry architecture.
- Superseded by V4.3 rollback.

## V4.0 — 2026-10-04
- Firmware hardening baseline before the V4.1–V4.3 OTA iterations.

## PRE-V4
- V3.3 introduced the yellow Online OTA progress layer.
- V3.2 is the exact pre-yellow Online OTA baseline.