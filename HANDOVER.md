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

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.3.ino`, blob `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. The user reports a successful firmware compile and GitHub connection, but no complete OTA transfer/apply/reboot proof is recorded here. No BIN generation/publication, flash, independent hardware validation, Android BLE pairing, or APK Build was performed by the assistant.
- [NOT RELEASED] V6.3 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

## HISTORICAL V6.2 FULL EXECUTION — 2026-10-13

- Active Firmware file: `firmware/JEXFYZ-V6.2.ino`, blob SHA `88d92f652a3cf973eb34bcfe3a9d73d9cbd87123`; last Firmware source update commit `13377f00b49d9de0bbd31a872c0da7251be56e8d`. V6.1 source has been retired from the active tree.
- App file `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`; latest App correction commit `116921bd28d280039ba191371fa276149466c802`; app version remains `1.0.0+3`.
- Adaptive thermal stages: 30 s at 12 V, 9 V and 5 V; Peltier OFF immediately, Fan 100%. Recovery before the 30-second deadline requires Hotside <= `hotLimit - 1°C` for 5 consecutive seconds, cancelling the timer and retaining the rail. If unrecovered, 12 V/9 V steps down; 5 V enters terminal manual-restart lock.
- After a thermal downshift, voltage recovery is one step per 60 seconds of continuous Hotside <= `hotLimit - 1°C`, no higher than the saved pre-downshift ceiling. Terminal 5 V lock cannot auto-recover. Manual re-arm uses the same -1°C threshold and 5-second stable qualification.
- Online OTA retains the GitHub raw BIN allowlist and validates HTTPS with ISRG Root X1. BLE command writes require bonded Secure Connections with Just Works pairing; MITM/passkey is not configured due to no device input/display. Local OTA is unchanged.
- App normal BLE reconnect order, OTA expected-disconnect race, voltage telemetry confirmation, LED color normalization, disconnected output unknown state, and -1°C safety copy are implemented.
- Regression tests were added/updated; `.gitignore` added. `pubspec.lock` is absent from `main`. A temporary GitHub Actions run resolved dependencies, but its lockfile push was rejected as non-fast-forward; tests/analyze were skipped and the temporary workflow was removed. No lockfile was committed.
- Validation boundary: `flutter pub get` succeeded in a temporary GitHub Actions job, but its lockfile push failed as non-fast-forward, so test/analyze were skipped; that workflow was removed. No APK build, firmware compile/BIN, flash, OTA, Android pairing or hardware validation occurred. V6.2 is source-only DEVELOPMENT + QC / PRE-RELEASE, not released.

## CURRENT V6.1 TOUCH-ADAPTIVE TELEMETRY SYNC FIX — 2026-10-13

- [VERIFIED SOURCE DEFECT] The hardware Touch long-press path called `setAdaptiveState(false, reason)` and sent only `ACK:TOUCH_ADAPTIVE;REASON=OFF`; unlike the App BLE command handler, it did not publish the `ADAPTIVE` state delta. The App ACK handler displays the result but does not mutate the Adaptive state, so the dashboard switch and Floating Monitor could remain stale.
- [IMPLEMENTED] The Touch Adaptive-OFF path now publishes authoritative `ADAPTIVE`, `ADAPTIVE_CEILING`, `FAN`, `PELTIER`, and `FAN_SPEED` state deltas before its Touch ACK. App continues to treat Firmware telemetry as authoritative; no speculative App-side state mutation was introduced.
- [PRESERVED] The 200 ms selector deadtime, safe-5V handoff, 5-second Peltier OFF→ON soft-start, deferred white 3-blink OFF indicator, BLE UUIDs/P1, and protected OTA code were not intentionally changed. `VOLTAGE` remains reported by the existing completed-transition path rather than being misreported as already settled during selector deadtime.
- [IMPLEMENTED] Added `test/firmware_touch_adaptive_sync_test.dart`, a static source-contract guard for the Touch telemetry sequence and App state-consumption path.
- [STATIC AUDIT ONLY] Current V6.1 version/file alignment is retained; source inventory remains one `analogReadMilliVolts(PIN_NTC)` call site, no lexical `delay(` call site, and no lexical `while(` loop call site.
- [UNVERIFIED] The new test has not been executed in this repository environment; no Flutter test/analyze, Arduino compile, BIN, flash, physical BLE/UI validation, App Build, or OTA regression was run as part of this change.
- [NOT RELEASED] V6.1 remains DEVELOPMENT + QC / PRE-RELEASE. No production BIN or Firebase OTA metadata was changed.

## V6.1 SOURCE PROMOTION BASELINE — 2026-10-12

- [CURRENT TRUTH] Active firmware source: `firmware/JEXFYZ-V6.1.ino`; `FW_VERSION` is `V6.1`; current source blob after Touch telemetry fix: `50dee6c7ed3cb5780e97deaa235fe81856152ec2`; target ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [IMPLEMENTED] V6.1 carries forward the Adaptive rail-handoff fix: Peltier PWM is disabled before the 200 ms selector break-before-make transition, and prior Peltier operation is restored after safe 5 V completion through the existing safety gates and 5-second OFF→ON soft-start.
- [IMPLEMENTED] Adaptive ON feedback remains three orange blinks after successful activation; Adaptive OFF feedback is deferred until the safe-5V handoff completes when the mode actually changed from ON to OFF, or starts immediately if already at 5 V.
- [DIAGNOSTIC] Firmware writes `BOOT: RESET_REASON=<reason>` to Serial during startup.
- [COMMITTED] V6.1 source added on `main` in commit `5fa7a4033a1cf2c5989c5fb9511be75cf34b7dbe`; the obsolete V6.0 source path was removed in commit `167f44df6c379d6d2a7a03b47f6620c609a4136c`. No PR was used.
- [NO BUILD] This V6.1 source/version promotion did not run a compile/build, generate a V6.1 BIN, flash hardware, or update production OTA metadata.
- [UNVERIFIED] Physical confirmation that the reported Adaptive restart is eliminated, that both LED indicators render on hardware, and that thermal/OTA regression remains pending.
- [USER-REPORTED / UNVERIFIED] On the previously installed firmware: Manual 12V → Fan ON + Peltier ON → Adaptive ON causes immediate hardware restart; Adaptive is OFF after reboot. No RESET_REASON notification appeared and neither the orange ON nor white OFF indicator was seen. Root cause remains unverified.
- [USER-CONFIRMED] The previous 12V physical-output complaint was a loose cable and was fixed physically; it is not a confirmed software defect.
- [UNVERIFIED] Main now contains V6.1 source with the Adaptive rail-handoff fix and Serial boot reset-reason log, but V6.1 has not been built, flashed, or physically tested.
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

## 2026-10-07 — V5.9 APP LOCALIZATION / NOTIFY CLEANUP
- [IMPLEMENTED] English is the master/reference language for all user-facing App copy.
- [IMPLEMENTED] Indonesian copy was aligned to identical meaning and natural UI terminology.
- [IMPLEMENTED] Reset notifications no longer show raw `Reset: POWER_ON` style text.
- [IMPLEMENTED] Known internal safety/command reasons are mapped to concise localized user-facing text.
- [IMPLEMENTED] Notify error-state detection works with both English and Indonesian wording.
- [IMPLEMENTED] Home Notify message/status styles explicitly disable text decoration.
- [IMPLEMENTED] Localization tests were synchronized.
- [UNVERIFIED] Flutter analyze/test and App Build for the updated source.

## CURRENT V5.9 INTEGRATED QC + HOTSIDE RECOVERY UPDATE — 2026-10-07

- [VERIFIED] Functional execution started from main HEAD 414cc6959d9fd5d89968da19b9473b317b0cbba7; final firmware update/comment commits completed before documentation-sync commits.
- [VERIFIED] Firmware: V5.9 at firmware/JEXFYZ-V5.9.ino; latest firmware blob 6fec4071056aca4fd93cbeaecfc81d7f6d19ef60.
- [VERIFIED] App: 1.0.0+3; package com.horizontalzzz.jexfyz; main blob 06850f297087b11789d3daa239f272dbe7591f32; settings blob 8bcbfbc6a91eb6274d641c0921a0411aa01bebd7; widget-test blob 430e5542ed80cb2170c4236511f94e2615cea5ba2.
- [IMPLEMENTED] V5.9 integrated App/Firmware QC changes remain present.
- [IMPLEMENTED] New Hotside recovery contract: 20 s Adaptive stage per rail, 19 s red + 1 s blue, green 2x only on <= hotLimit - 2°C re-arm, continuous Manual red until re-arm, and 5V terminal lock after an unrecovered 20 s Adaptive stage.
- [VERIFIED] The earlier heartbeat-helper scope issue is corrected; current helper is top-level.
- [PROTECTED] OTA Local/Online and Wi-Fi↔BLE handoff remain frozen.
- [UNVERIFIED] V5.9 compile, BIN, flash, physical, OTA, App integration, and release gates.
- [NOT RELEASED] App Build was not run by this transfer save.

# TRANSFER PROTOCOL V2 — 2026-10-06

## 2026-10-06 — V5.8 PELTIER REARM + NTC SINGLE-SAMPLE QC FIX
- [IMPLEMENTED] Active source promoted to `firmware/JEXFYZ-V5.8.ino`.
- [FIX] Peltier safety lock releases automatically at `hotLimit - 2°C`; the next successful Peltier ON retains the green 1-second re-arm feedback.
- [FIX] Locked Peltier ON attempts emit red 1-second feedback while the effective safety lock is active.
- [FIX] NTC sampling is exactly one calibrated ADC reading every 1 second; the V5.6 16-sample trimmed-mean path is retired.
- [PRESERVED] No OTA, BLE, GPIO, Adaptive timing, selector timing, voltage guard, or Peltier soft-start changes.
- [USER-CONFIRMED] V5.7 compile + hardware update succeeded before this fix.
- [UNVERIFIED] V5.8 compile/BIN/flash/physical QC is pending.
- [AUDIT PASS] Static source audit passed: no executable `delay()`, no timing `while()` loop, single NTC ADC sample path, latch auto-release path present, and no App source/workflow change.


- [IMPLEMENTED] `CHAT_TRANSFER.md` is now the detailed cross-chat boot protocol.
- [POLICY] New chats must read it first, reconcile current `main`, and avoid repeating established context questions.
- [CURRENT] V5.8 firmware QC fix is implemented; App source/build remains unchanged.
- [VERIFIED] Pre-write main HEAD: `c7faf134742fc6fdbebc3f66469c8aa5dd9980c6`.

## 2026-10-06 — V5.7 TTP223 TOUCH ACCURACY QC FIX
- [IMPLEMENTED] Firmware V5.7 is active at firmware/JEXFYZ-V5.7.ino.
- [IMPLEMENTED] TTP223 input uses 30 ms PRESS/RELEASE qualification before gesture processing.
- [IMPLEMENTED] Valid tap duration is 60–500 ms; duration is measured from raw HIGH start to raw LOW transition so qualification does not shrink the usable tap interval.
- [IMPLEMENTED] Double-tap window is 800 ms from first valid release with second-tap grace; double resolves at the decision boundary and 3+ taps in the same sequence remain cancel/no-action.
- [IMPLEMENTED] Startup grace is 1 second, and boot-held touch is ignored until a qualified release occurs.
- [PRESERVED] 1x Voltage, 2x RGB, 5 s long press, no delay(), and cooperative timing contracts.
- [COMMITTED] V5.7 source promotion commit: d2ec5d56383f25a105835b10698f62cf19cbf5df.
- [COMMITTED] V5.7 Touch FSM correction commit: 77591d7406aa8613a3dc9beb33828af5a592d8d5.
- [COMMITTED] V5.6 source retirement commit: 38f8f2738cca18fbac3830d241baa1f5596cc719.
- [UNVERIFIED] V5.7 compile, BIN generation, flash, physical touch behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.7 is not released.

## 2026-10-06 — V5.6 NTC ADC FILTERING QC FIX
- [IMPLEMENTED] Firmware V5.6 is active at firmware/JEXFYZ-V5.6.ino.
- [IMPLEMENTED] Hotside NTC uses 16 calibrated ADC samples per 1-second sample period, trims 4 low + 4 high values, and averages the remaining 8.
- [PRESERVED] NTC model remains 10K / 10K divider / Beta 3950 with the existing 3.3 V reference assumption.
- [PRESERVED] No temperature EMA/Kalman filter, VREF guess, voltage clamp, offset calibration, delay(), or timing loop was introduced.
- [COMMITTED] V5.6 source promotion commit: 1c5159652584bea8e26878a61e88f44aff5e3713.
- [COMMITTED] V5.5 source retirement commit: c342e2e25c508e38f5ffa33aeffa05ac149d4eee.
- [UNVERIFIED] V5.6 compile, BIN generation, flash, physical safety behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.6 is not released.

## 2026-10-06 — V5.5 PELTIER SAFETY REARM LED FEEDBACK
- [IMPLEMENTED] Normal Peltier ON/OFF no longer produces green/red Peltier LED feedback.
- [IMPLEMENTED] After Hotside Safety forces Peltier OFF, the existing manualPeltierSafetyLatch remains active until an explicit successful Peltier ON attempt.
- [IMPLEMENTED] Any blocked ON attempt while that latch is active blinks red for 1 second.
- [IMPLEMENTED] A successful ON attempt after Hotside reaches hotLimit - 2°C blinks green for 1 second and clears the latch.
- [PRESERVED] Hotside dwell LED remains 9 seconds red + final 1 second green and has LED priority over the short re-arm feedback.
- [COMMITTED] V5.5 source creation commit: adfb3e3860f6c7004e577981d668fef46f467d47.
- [COMMITTED] V5.4 source retirement commit: 12973ebace66f660c6c1b0a7a48407e96c02ea08.
- [COMMITTED] V5.5 follow-up safety-attempt correction commit: b29d050dcb7deea0ffc5339c76a37bf27a7dacb1.
- [COMMITTED] V5.5 final latch-consistency correction commit: 87c69ce33024e9653efbe9f52cbce84a857efaf4.
- [IMPLEMENTED] Adaptive activation is blocked while the Peltier safety latch is active; the latch can only clear on a successful re-arm ON attempt.
- [UNVERIFIED] V5.5 compile, BIN generation, flash, physical safety behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.5 is not released.

## 2026-10-06 — V5.4 HOTSIDE DWELL FAN + LED QC FIX
- [IMPLEMENTED] Firmware V5.4 is active at `firmware/JEXFYZ-V5.4.ino`.
- [IMPLEMENTED] Adaptive Hotside safety keeps Fan ON at 100% during the complete 10-second thermal dwell.
- [IMPLEMENTED] Completed HOTSTEP transitions keep Fan ON at 100% while Hotside protection remains active.
- [IMPLEMENTED] Hotside dwell LED sequence is 9 seconds red blink followed by 1 second green blink.
- [IMPLEMENTED] Functional source changed only for these reproducible QC findings; no unrelated feature/refactor change.
- [COMMITTED] V5.4 source creation commit: fd883ca695cab2f35014b3cf069fa9454ae6bc89.
- [COMMITTED] V5.3 source retirement commit: 65d971616c793e7dd056c6a7896d552516fe626c.
- [UNVERIFIED] V5.4 compile, BIN generation, flash, physical safety behavior, OTA, and App integration remain pending.
- [NOT RELEASED] V5.4 is not released.

## CHAT-LIMIT RECONCILIATION — 2026-10-05
- [VERIFIED] Repository main HEAD before CHAT_TRANSFER write: 3a54d83956f357750684a32279952cbd7fb484f8.
- [VERIFIED] CHAT_TRANSFER save commit: 3d21b33b5c96640f7393a4956ad2ccb868639644.
- [VERIFIED] This Handover note is documentation-only; latest main HEAD is checked after the save sequence.
- [VERIFIED] Active Firmware V5.3: `firmware/JEXFYZ-V5.3.ino`, blob d6b5262c0ed429999ef6a951841bca6b24296949.
- [VERIFIED] Both Adaptive profiles share the 5-second upward-voltage dwell; safe-5V Adaptive startup also starts the dwell; downward changes remain immediate.
- [VERIFIED] App main source blob: 48406cda017be1ce939ff682497324bf3680a7f3.
- [OPEN QUESTION] Historical App Build records conflict between run 37261171475 (PROJECT_STATE) and run 37268139253 (APP_NOTES); no independent Actions-page recheck was possible in this session.
- [VERIFIED] CHAT_TRANSFER.md save commit: 3d21b33b5c96640f7393a4956ad2ccb868639644; saved blob fc00fdf83cd461f4f76e1edca6b53453111f1137.

## APP SAFETY NOTIFY / REARM — 2026-10-05
- App NOTIFY reports the exact Peltier re-arm threshold using `hotLimit - 2°C`.
- Failed Peltier ON safety requests are reported from the firmware reason; duplicate generic notices are suppressed.
- Touch ON/OFF ACKs are classified as successful outcomes and shown cleanly.
- Retired RAPID_HOTSIDE_RISE notification text is removed.
- App Build remains separate.

## V5.2 PELTIER SAFETY REARM FEEDBACK — 2026-10-05
- Peltier remains locked until Hotside <= hotLimit - 2°C after a safety latch, including the 5V Adaptive terminal state.
- Hardware Touch cooling ON now enforces the same re-arm threshold; it cannot bypass the latch.
- Failed Peltier ON attempts blink red for 1 second; successful Peltier ON attempts blink green for 1 second.
- App NOTIFY reports the configured re-arm temperature and cleaned ACK success/failure wording.
- App Build is separate and is not run by this Firmware/App source execution.

## APP HOME FAN SPEED DISPLAY QC — 2026-10-05
- Home Fan Speed now displays 100% when Adaptive is ON at 12V, matching Firmware behavior.
- Manual 12V remains displayable at the firmware-reported user-selected speed.
- The Adaptive speed control remains locked; only the display logic changed.
- Regression coverage added for Adaptive 12V, Manual 12V, and 9V cases.
- App Build is separate and was not run for this source fix.

# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: **V5.9**
- Active source: `firmware/JEXFYZ-V5.9.ino`
- Firmware source blob: `11879cda3e96411c16cc372a176dcef6b71ebe94`
- App: **1.0.0+3**
- App package: `com.horizontalzzz.jexfyz`
- App main blob: `df4a244723420f8057745275838d7e07c1e0c82a`
- App tests blob: `2da4bff01d3eed749eeba873e9ec2e577c04def9`
- Current phase: **V5.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**
- App + Firmware are one integrated contract.
- P1 is mandatory for App BLE session readiness.
- Peltier safety re-arm is unified across BLE and hardware Touch.
- OTA Local/Online, OTA state/recovery, and Wi-Fi↔BLE handoff remain protected/frozen.
- Android `versionName "Telegram @horizontalzzz"` is intentional and unchanged.
- App Build was not executed by this source integration batch.

## QC NEXT
1. Compile V5.9.
2. Generate V5.9 BIN.
3. Flash/update ESP32-C3 and verify image provenance.
4. Hardware-only control and safety QC.
5. Local OTA Golden Path.
6. Online OTA + BLE recovery.
7. App↔V5.9 integration QC.
8. Explicit App Build.
9. Release Gate.
## TRANSFER PROTOCOL V2
- [IMPLEMENTED] `CHAT_TRANSFER.md` is now the detailed cross-chat boot/transfer protocol.
- [POLICY] New chats read it first, reconcile current `main`, and do not ask the user to repeat established facts.
- [PRESERVED] Functional Firmware/App behavior, BLE/P1, OTA runtime, hardware safety, and App Build behavior are unchanged by the protocol update.
- [VERIFIED] Transfer Protocol v2 is documentation-only.

## OTA PROTECTION
- [ACTIVE] `OTA_PROTECTION.md` is the documentation-only OTA protection reminder.
- [FROZEN] Local OTA, Online OTA, state machine, radio handoff, recovery, validation, timeout/retry, and App OTA version-selection contracts.
- [PRESERVED] Anti-downgrade remains OFF.
- [USER-CONFIRMED] V5.7 OTA update reached the physical hardware successfully.
- [UNVERIFIED] Full final-image OTA regression remains a QC gate.

## QC NEXT
1. Compile V5.7.
2. Generate V5.7 BIN.
3. Verify flash/image provenance.
4. Hardware-only functional QC.
5. Safety QC.
6. Local OTA Golden Path.
7. Online OTA + BLE recovery.
8. App ↔ V5.7 integration QC.
9. Explicit App Build.
10. Release Gate.

## VALIDATION BOUNDARY
- [VERIFIED] Repository source/workflow reconciliation for this transfer.
- [USER-CONFIRMED] V5.7 OTA update to hardware succeeded.
- [UNVERIFIED] Full V5.7 compile/BIN/physical QC/App integration/Release Gate.

## HISTORICAL HANDOVER
Older V4.x–V5.6 records remain below this current handover as history only.
They MUST NOT override the current V5.7 source or current repository configuration.