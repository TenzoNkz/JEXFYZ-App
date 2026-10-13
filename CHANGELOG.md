## Online OTA TLS clock validation — 2026-10-13

- Firmware remains V6.2. Online OTA now synchronizes system time asynchronously after Wi-Fi connects and before CA-validated HTTPS begins. Time synchronization is bounded at 20 seconds and uses the existing OTA failure/recovery path on timeout.
- Redirects are disabled for the allowlisted raw GitHub BIN URL. The configured public CA validation remains enabled; no SHA/custom signature was added, and Local OTA is unchanged.
- Added QC assertions and a GitHub Actions quality workflow to resolve dependencies, commit generated `pubspec.lock` on main if needed, run `flutter test`, and run `flutter analyze`. The workflow does not build APK or firmware.
- No compile, APK build, flash, device OTA, or physical test was performed; review CI and perform manual hardware validation before sign-off.

## CURRENT V6.2 FULL EXECUTION — 2026-10-13

- Active Firmware: `firmware/JEXFYZ-V6.2.ino`, blob SHA `eaf7ac76d20b7ba67dfc5a0abf5b4ef7083b9265`; last Firmware source update commit `cac71e8bdfc701a7ffb9b5e3fb1ea1bc6817884d`. V6.1 source retired.
- App: `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`; latest App correction commit `116921bd28d280039ba191371fa276149466c802`; version unchanged at `1.0.0+3`.
- Thermal rules: 30-second protection stage at 12 V, 9 V and 5 V; Peltier OFF immediately, Fan 100%. Hotside <= `hotLimit - 1°C` for 5 continuous seconds before the 30-second deadline cancels the stage and keeps the rail. Otherwise 12 V/9 V steps down one rail and an unrecovered 5 V stage enters terminal manual-restart lock.
- Thermal voltage recovery: each upward rail needs 60 continuous seconds at or below `hotLimit - 1°C`, up to the saved Adaptive ceiling. Terminal 5 V lock does not auto-recover. Manual re-arm threshold is -1°C plus 5-second stability.
- Online OTA uses HTTPS CA validation while retaining the raw GitHub allowlist for `TenzoNkz/JEXFYZ-Firmware`. BLE command writes require an encrypted bonded connection with Secure Connections/Just Works. Local OTA was intentionally left unchanged.
- App updates: normal BLE reconnect scheduling after disconnect state update; OTA disconnect marker is armed before `CLOUDOTA`; voltage ACK is followed by authoritative `VOLTAGE` telemetry confirmation; RGB colors normalize optional `#`; Dashboard/Floating Monitor show unknown output status while offline; safety copy uses -1°C.
- Regression tests added/updated; `.gitignore` added. `pubspec.lock` remains BLOCKED until real dependency resolution can run with Flutter/Dart—no lockfile was fabricated.
- Validation: Flutter tests/analyze could not run because no Flutter/Dart executables or local checkout are available. No APK build, firmware compile, BIN, flash, OTA or physical-device validation was performed.
- Release state: V6.2 source-only DEVELOPMENT + QC / PRE-RELEASE, NOT RELEASED. Production firmware repository and Firebase metadata were not changed.

## DOCUMENTATION HOUSEKEEPING — 2026-10-13

- [COMMITTED] Root `README.md` is reserved for chat-transfer instructions; version/execution history was removed from README.
- [COMMITTED] `CHAT_TRANSFER.md` was replaced with one reconciled, structured snapshot; stale duplicated/current-state claims were removed and PR #18 is recorded as closed/not merged.
- [UNRESOLVED] Source branch `fix/adaptive-power-sequencing` still exists; the available GitHub connector did not provide a branch-delete action.
- [DOCS ONLY] No App/Firmware functional source, workflow, compile, build, BIN, flash, OTA, Firebase metadata, or release was changed.

## CURRENT V6.1 TOUCH-ADAPTIVE TELEMETRY SYNC FIX — 2026-10-13

- [VERIFIED SOURCE DEFECT] The hardware Touch long-press path called `setAdaptiveState(false, reason)` and sent only `ACK:TOUCH_ADAPTIVE;REASON=OFF`; unlike the App BLE command handler, it did not publish the `ADAPTIVE` state delta. The App ACK handler displays the result but does not mutate the Adaptive state, so the dashboard switch and Floating Monitor could remain stale.
- [IMPLEMENTED] The Touch Adaptive-OFF path now publishes authoritative `ADAPTIVE`, `ADAPTIVE_CEILING`, `FAN`, `PELTIER`, and `FAN_SPEED` state deltas before its Touch ACK. App continues to treat Firmware telemetry as authoritative; no speculative App-side state mutation was introduced.
- [PRESERVED] The 200 ms selector deadtime, safe-5V handoff, 5-second Peltier OFF→ON soft-start, deferred white 3-blink OFF indicator, BLE UUIDs/P1, and protected OTA code were not intentionally changed. `VOLTAGE` remains reported by the existing completed-transition path rather than being misreported as already settled during selector deadtime.
- [IMPLEMENTED] Added `test/firmware_touch_adaptive_sync_test.dart`, a static source-contract guard for the Touch telemetry sequence and App state-consumption path.
- [STATIC AUDIT ONLY] Current V6.1 version/file alignment is retained; source inventory remains one `analogReadMilliVolts(PIN_NTC)` call site, no lexical `delay(` call site, and no lexical `while(` loop call site.
- [UNVERIFIED] The new test has not been executed in this repository environment; no Flutter test/analyze, Arduino compile, BIN, flash, physical BLE/UI validation, App Build, or OTA regression was run as part of this change.
- [NOT RELEASED] V6.1 remains DEVELOPMENT + QC / PRE-RELEASE. No production BIN or Firebase OTA metadata was changed.

## V6.1 SOURCE PROMOTION BASELINE — 2026-10-12

- [CURRENT TRUTH] Active firmware source: `firmware/JEXFYZ-V6.1.ino`; `FW_VERSION` is `V6.1`; target ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [IMPLEMENTED] V6.1 carries forward the Adaptive rail-handoff fix: Peltier PWM is disabled before the 200 ms selector break-before-make transition, and prior Peltier operation is restored after safe 5 V completion through the existing safety gates and 5-second OFF→ON soft-start.
- [IMPLEMENTED] Adaptive ON feedback remains three orange blinks after successful activation; Adaptive OFF feedback is deferred until the safe-5V handoff completes when the mode actually changed from ON to OFF, or starts immediately if already at 5 V.
- [DIAGNOSTIC] Firmware writes `BOOT: RESET_REASON=<reason>` to Serial during startup.
- [COMMITTED] V6.1 source added on `main` in commit `5fa7a4033a1cf2c5989c5fb9511be75cf34b7dbe`; the obsolete V6.0 source path was removed in commit `167f44df6c379d6d2a7a03b47f6620c609a4136c`. No PR was used.
- [NO BUILD] This V6.1 source/version promotion did not run a compile/build, generate a V6.1 BIN, flash hardware, or update production OTA metadata.
- [UNVERIFIED] Physical confirmation that the reported Adaptive restart is eliminated, that both LED indicators render on hardware, and that thermal/OTA regression remains pending.
- [NOT RELEASED] Production firmware repository `TenzoNkz/JEXFYZ-Firmware` and Firebase `firmware_update.json` were not changed. V6.1 remains source-only until separately built, validated, and explicitly released.

> The V6.0 section below is historical QC/build evidence only; it does not imply that V6.1 has been built, flashed, or released.

## HISTORICAL V6.0 EXECUTION — 2026-10-12

- [HISTORICAL] Active firmware source during the V6.0 QC snapshot: `firmware/JEXFYZ-V6.0.ino`; `FW_VERSION` was V6.0; target ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [FIX IMPLEMENTED] Adaptive ON now de-energizes Peltier PWM before a 200 ms selector break-before-make handoff to 5V. Once 5V completes, existing safety gates apply and the previously active Peltier is restored through `applyCoolingOutputs()`, invoking the existing 5-second OFF→ON soft-start.
- [FIX IMPLEMENTED] Adaptive OFF similarly de-energizes Peltier before forcing 5V; if Peltier was active, it is restored only after the 5V handoff completes and safety still permits it.
- [FIX IMPLEMENTED] Adaptive OFF white 3-blink feedback is deferred until the safe-5V handoff completes when the mode actually changed from ON to OFF; when already at 5V, feedback starts immediately. Successful Adaptive ON retains orange 3-blink feedback after activation and validation.
- [DIAGNOSTIC] Firmware boot prints `BOOT: RESET_REASON=<reason>` to Serial so reset cause can be captured even if BLE telemetry is interrupted.
- [COMMITTED] Adaptive handoff code: `2b119ac51f7989a00f82cfb4c190c0310881fdd1`.
- [COMMITTED] Firmware contract comment alignment: `45390c258d1769e3834b3c1dac68fd8eeced3b4d`.
- [COMMITTED] Firmware compile workflow: `e3e1922b05187e5df0fdbdc78402f62899dcf2e6`; QC prerelease delivery replaces artifact upload because Actions artifact storage quota was exhausted: `2e0aa75f9edb9a0646d90466d4183f20058f0306`.
- [VERIFIED BUILD] GitHub Actions run #83 passed with Arduino-ESP32 Core 3.3.7, target `esp32:esp32:esp32c3:PartitionScheme=min_spiffs`; job/run: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38267907193.
- [VERIFIED IMAGE] Compile reported 1,465,067 bytes program storage (74% of 1,966,080 bytes) and 46,740 bytes global RAM (14% of 327,680 bytes). Generated QC BIN is 1,465,216 bytes; ESP image magic `E9` and configured OTA size checks passed.
- [VERIFIED QC ASSET] Byte-for-byte release re-download verification passed. SHA-256: `b50af3bf9b43f1f78425e4dbd273534f218acd8c58a539eb2426bf3d9d5b10a8`. QC-only prerelease: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/firmware-qc-latest.
- [HISTORICAL] During the V6.0 QC snapshot, the GPIO mapping, NTC single-sample 1 Hz path, safety gates, selector deadtime, voltage guard, Adaptive 5-second upward dwell, OTA runtime logic, BLE/P1, App source, and production OTA metadata were not intentionally changed. The V6.0 production BIN in `TenzoNkz/JEXFYZ-Firmware` and Firebase `firmware_update.json` remained unchanged.
- [AUDIT PASS] Post-change lexical delimiter check passed; Adaptive start/stop order, delayed OFF indicator, OTA pending-flag cleanup, and boot reset diagnostic were checked in source.
- [UNVERIFIED] Physical ESP32-C3 flash/update; whether the original restart is eliminated on hardware; physical orange/white LED feedback; Peltier/Fan and thermal regression; Local/Online production OTA regression.
- [NOT RELEASED] Project remains DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED. The `firmware-qc-latest` prerelease is for manual/local QC only; it is not the production OTA release. App Build was not run.

> Older V5.9 sections remain historical; the V6.1 source-only state is recorded above.

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