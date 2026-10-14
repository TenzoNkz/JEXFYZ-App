# JE X FYZ / JE Cooler — Legacy Notes Snapshot Before Reorganization

**Archive captured from `main` commit `8295352ee710b7136cad9f6f6842477b028f4d20` on 2026-10-14.** The following are verbatim pre-cleanup text snapshots kept for forensic/historical recovery. They contain obsolete and contradictory `CURRENT` status blocks and MUST NOT be treated as current source of truth. Current state is in `PROJECT_STATE.md`; route memory via `MEMORY_INDEX.md`; historical decisions are curated in `CHANGELOG.md`.

Do not copy these old status lines forward. Use this archive only to recover a historical detail that was not carried into the canonical references.

---

## Archived file: `PROJECT_STATE.md`

- Original blob at snapshot: `21440eaa7f590baefcf7189a06a155251ee37efb`
- Reason preserved: Legacy snapshot before memory cleanup

`````markdown
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
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, user-reported evidence boundary, trade-off, and recurrence-prevention rules.
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
- [USER-REPORTED / UNVERIFIED] On the previously installed firmware, sequence reported: select Manual 12V, enable Fan and Peltier, then enable Adaptive; hardware immediately restarts, and after reboot Adaptive is OFF. No reset-reason notification was shown and neither orange ON nor white OFF feedback was observed. This does not establish brownout or another root cause.
- [USER-CONFIRMED] The earlier physical 12V output issue was caused by a loose cable and was resolved by securing the cable; do not treat that earlier 12V symptom as a confirmed firmware defect.
- [UNVERIFIED] V6.1 source includes the Adaptive rail-handoff fix and Serial `BOOT: RESET_REASON=` diagnostic, but no V6.1 compile, BIN, flash, or hardware confirmation has been recorded.
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

## V5.9 APP LOCALIZATION / NOTIFY QC UPDATE — 2026-10-07
- [IMPLEMENTED] English is the master/reference copy for all localized user-facing messages.
- [IMPLEMENTED] Indonesian copy was aligned to the English meaning and standardized for natural UI terminology.
- [IMPLEMENTED] Notify reset handling no longer exposes `Reset: POWER_ON` or internal reset tokens.
- [IMPLEMENTED] Notify error classification now recognizes both English and Indonesian status wording.
- [IMPLEMENTED] Home Notify text and status chip explicitly use `TextDecoration.none`.
- [IMPLEMENTED] Core terminology now uses Hotside/Suhu Hotside consistently, and Indonesian switch labels use “Sakelar”.
- [IMPLEMENTED] Localization regression tests were updated.
- [UNVERIFIED] Flutter analyze/test and App Build on this post-cleanup source.

## CURRENT V5.9 INTEGRATED QC + HOTSIDE RECOVERY UPDATE — 2026-10-07

- [VERIFIED] Last functional App execution HEAD: 015eb56d52b4aaeb1431db4ece1ef19d140f961c.
- [VERIFIED] Active Firmware V5.9: firmware/JEXFYZ-V5.9.ino; updated blob 6fec4071056aca4fd93cbeaecfc81d7f6d19ef60.
- [VERIFIED] Active App 1.0.0+3: lib/main.dart; updated blob 06850f297087b11789d3daa239f272dbe7591f32.
- [VERIFIED] App settings blob 8bcbfbc6a91eb6274d641c0921a0411aa01bebd7; tests blob 430e5542ed80cb2170c4236511f94e2615cea5ba2.
- [VERIFIED] Firmware static audit after the thermal update: no executable delay(), no timing while(), no RAPID_HOTSIDE_RISE; one NTC ADC sample per 1 s remains intact.
- [VERIFIED] Current App includes P1 validation, serialized command confirmation, coalesced heartbeat, Peltier ACK reason handling, OTA stage presentation, notification channel, and NOT_STICKY service.
- [VERIFIED] The earlier heartbeat-helper lexical-scope issue is corrected in the current main.dart by commit 7d5f0f5adf7fec92b33c92a3b6a6eb58a9ab36a8.
- [PROTECTED] OTA Local, OTA Online, radio handoff, state/recovery, image validation, URL/path contract, and BLE/P1 architecture remain frozen.
- [IMPLEMENTED] Adaptive Hotside thermal stage is 20 s per rail with 19 s red + final 1 s blue; <= hotLimit - 2°C re-arms Peltier and shows green 2x; 12V -> 9V -> 5V each gets its own 20 s stage.
- [IMPLEMENTED] Manual Hotside protection keeps red blinking until <= hotLimit - 2°C, then green 2x; 5V Adaptive remains locked after an unrecovered 20 s stage and requires manual Peltier restart.

# JE X FYZ — CURRENT PROJECT STATE

## V5.8 PELTIER REARM + NTC SINGLE-SAMPLE QC FIX — 2026-10-06
- [IMPLEMENTED] Firmware promoted V5.7 → V5.8 for the reproducible Peltier safety-lock and NTC sampling QC findings.
- [FIX] Effective Peltier safety lock now clears automatically once Hotside reaches `hotLimit - 2°C`; one-shot green re-arm feedback remains armed for the next successful Peltier ON.
- [FIX] Locked Peltier ON attempts retain the red 1-second feedback path while the effective safety lock is active.
- [FIX] Hotside NTC is exactly one calibrated ADC reading every 1 second; the V5.6 16-sample trimmed-mean path is retired.
- [PRESERVED] NTC remains 10K / 10K divider / Beta 3950 with the existing 3.3 V reference assumption.
- [PRESERVED] OTA, BLE/P1, GPIO mapping, Adaptive 5-second upward dwell, selector deadtime, voltage guard, and Peltier 5-second soft-start were not intentionally changed.
- [USER-CONFIRMED] V5.7 compiled successfully and was successfully updated to the hardware before this V5.8 QC fix.
- [UNVERIFIED] V5.8 compile, BIN generation, flash/update, and physical regression remain pending.
- [AUDIT PASS] Final V5.8 source audit: no executable `delay()`, no timing `while()` loop, NTC sample-count path removed, brace/parenthesis balance is zero, and only the intended firmware/docs files changed versus pre-fix HEAD.


## TRANSFER PROTOCOL V2 — 2026-10-06
- [IMPLEMENTED] `CHAT_TRANSFER.md` was upgraded to a detailed boot/transfer protocol to prevent context repetition between chats.
- [FROZEN] The transfer protocol does not authorize functional source changes, Firmware release, or App Build.
- [CURRENT] Active Firmware is V5.9 at `firmware/JEXFYZ-V5.9.ino`.
- [CURRENT] Current main HEAD is reconciled at the last documented checkpoint; source/workflow outrank this historical pointer.
- [POLICY] New chats must reconcile the transfer snapshot against current repository truth before acting and must not ask for already-documented project facts.


## CURRENT PHASE
> **V5.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V5.9
- Active Firmware source: firmware/JEXFYZ-V5.9.ino
- Firmware source blob: 11879cda3e96411c16cc372a176dcef6b71ebe94
- Firmware compile/BIN/flash/physical regression: UNVERIFIED
- OTA Protection reminder: ACTIVE in OTA_PROTECTION.md.
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- App main source blob: df4a244723420f8057745275838d7e07c1e0c82a
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: 2da4bff01d3eed749eeba873e9ec2e577c04def9
- App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Release status: NOT RELEASED
- This V5.9 execution did not run App Build.


## OTA PROTECTION REMINDER — 2026-10-06
- [IMPLEMENTED] OTA_PROTECTION.md is the repository's documentation-only protection reminder.
- [PRESERVED] Firmware OTA runtime behavior and App OTA behavior were not changed by the protection reminder.
- [PRESERVED] Anti-downgrade is OFF; any valid firmware version different from the device version may be installed.
- [PRESERVED] No CI-enforced OTA seal, manifest, lock file, or OTA-security workflow is active.
- [USER-CONFIRMED] V5.7 OTA successfully updated the physical hardware.
- [POLICY] OTA changes require a demonstrated OTA defect, clear root cause, explicit approval, and full OTA re-audit.

## V5.7 TTP223 TOUCH ACCURACY QC FIX — 2026-10-06
- [QC FIX / FINALIZED] Double-tap resolution is held until the 800 ms decision window; 3+ taps inside the same sequence remain cancel/no-action as in the prior gesture contract.
- [COMMITTED] Latest V5.7 Touch FSM correction commit: 77591d7406aa8613a3dc9beb33828af5a592d8d5.
- [QC FIX / IMPLEMENTED] TTP223 GPIO input now passes through a 30 ms stable-state qualification layer before gesture processing.
- [QC FIX / IMPLEMENTED] Valid tap duration is qualified at 60–500 ms using the raw HIGH duration, preventing qualification overhead from rejecting short but real taps.
- [QC FIX / IMPLEMENTED] Double-tap decision window is 800 ms and starts after the first valid tap release.
- [QC FIX / IMPLEMENTED] If the second tap starts before the 800 ms deadline, release may occur slightly after the deadline and still resolves as double tap.
- [QC FIX / IMPLEMENTED] A 1-second startup grace period ignores boot-time touch input; a touch already held during startup must be released before any new gesture is accepted.
- [PRESERVED] Single tap remains voltage sequence control, double tap remains RGB toggle, and long press remains 5 seconds.
- [IMPLEMENTED] Firmware promoted V5.6 → V5.7 for this targeted Touch accuracy correction.
- [USER-CONFIRMED] V5.7 compiled and was successfully updated to the hardware before the V5.8 fix.
- [UNVERIFIED] V5.8 compile/BIN/flash/physical functional QC remains pending.

## V5.6 NTC ADC FILTERING QC FIX — 2026-10-06
- [QC FIX / IMPLEMENTED] Hotside NTC sampling now uses a bounded 16-sample calibrated ADC burst once per 1-second sampling period.
- [QC FIX / IMPLEMENTED] ADC samples are insertion-sorted, then the 4 lowest and 4 highest samples are discarded; the remaining 8 samples are averaged as the filtered NTC millivolt value.
- [PRESERVED] NTC remains 10K nominal, 10K fixed resistor, Beta 3950, GPIO0, 12-bit ADC, and 11 dB attenuation.
- [PRESERVED] VREF calculation remains the existing 3.3 V design value; no speculative 3.28 V constant was introduced.
- [PRESERVED] No EMA/Kalman temperature filter, voltage clamp, offset calibration, or blocking timing was introduced.
- [IMPLEMENTED] Firmware promoted V5.5 → V5.6 for this targeted NTC QC correction.
- [NOT BUILT HERE] V5.6 compile/BIN/flash/physical validation remains pending.

## V5.5 PELTIER SAFETY REARM LED FEEDBACK — 2026-10-06
- [QC FIX / IMPLEMENTED] Normal Peltier ON/OFF no longer emits the green/red Peltier LED command indicator.
- [QC FIX / IMPLEMENTED] The Peltier LED feedback is reserved for ON attempts while manualPeltierSafetyLatch is active after a Hotside safety-forced Peltier OFF.
- [IMPLEMENTED] Any blocked re-arm attempt while the safety latch is active emits a non-blocking 1-second red blink.
- [IMPLEMENTED] A successful re-arm ON attempt after Hotside reaches hotLimit - 2°C emits a non-blocking 1-second green blink, then clears the latch.
- [PRESERVED] Hotside dwell LED remains 9 seconds red blink + final 1 second green blink and keeps priority over the short Peltier re-arm feedback.
- [IMPLEMENTED] Firmware promoted V5.4 → V5.5 for this targeted QC correction.
- [IMPLEMENTED] Safety latch remains authoritative until the explicit successful Peltier re-arm attempt; Adaptive start cannot bypass an active latch.
- [COMMITTED] Latest V5.5 safety-latch correction commit: 87c69ce33024e9653efbe9f52cbce84a857efaf4.
- [NOT BUILT HERE] V5.5 compile/BIN/flash/physical validation remains pending.

## V5.4 HOTSIDE DWELL FAN + LED QC FIX — 2026-10-06
- [QC FIX / IMPLEMENTED] Adaptive HOTSIDE safety keeps Fan ON at 100% throughout the full 10-second Hotside thermal dwell at every Adaptive rail.
- [QC FIX / IMPLEMENTED] After each HOTSTEP completes, Fan remains ON at 100% while Hotside safety is still active.
- [QC FIX / IMPLEMENTED] Hotside thermal LED timing is now synchronized to the 10-second dwell: 9 seconds red blink followed by 1 second green blink.
- [PRESERVED] HOTSIDE thermal dwell remains 10 seconds before the lower-voltage safety step is requested.
- [PRESERVED] Adaptive upward-voltage dwell remains 5 seconds; downward Adaptive steps remain immediate.
- [PRESERVED] 200 ms selector deadtime, 1 s voltage guard, Peltier 5 s soft-start, NTC safety, OTA, BLE, and P1 contracts.
- [IMPLEMENTED] Firmware promoted V5.3 → V5.4 for this functional QC correction.
- [NOT BUILT HERE] V5.4 compile/BIN/flash/physical validation remains pending.

## CHAT-LIMIT RECONCILIATION — 2026-10-05
- [VERIFIED] Last reconciled main HEAD before this final documentation consolidation: 97f8b68545e50853871493ba8999ddb226c95d5b.3 handover for chat transfer).
- [VERIFIED] Active Firmware is V5.3 at `firmware/JEXFYZ-V5.3.ino`, blob d6b5262c0ed429999ef6a951841bca6b24296949.
- [VERIFIED] Active App main source blob is 48406cda017be1ce939ff682497324bf3680a7f3; App settings blob f11235bab559b291928550e06984532581ddad6a; tests blob 1951964af7542324b2ae27b1bd94f84e1c853060.
- [VERIFIED] V5.3 functional implementation is preserved in source commit 85bf8acf79fd91f0d3bbbe2440bec8bab73774da; V5.2 retirement is 90f459ac4720a3ec509543bcc4e83bde96e3d910. Compare 90f→current shows only documentation changes after the source retirement.
- [IMPLEMENTED] Both Adaptive profiles (HOTSIDE and HOTSIDE_BATTERY) now use a 5-second cooperative dwell after each completed upward voltage step. Adaptive startup from safe 5V also starts the same dwell; downward steps remain immediate.
- [OPEN QUESTION] Cached build documentation contains two historical IDs: PROJECT_STATE cites run 37261171475 / APK SHA-256 b8045d0b6fa6d05b421bd6b1c0318d4ee4529734d7b471534700f95676200888, while APP_NOTES records Build #9 run 37268139253 / APK digest 64f9be08a28007e42a27dfd7b0459857a06d7146200113a405638ef8f0353058. The current session could not independently re-fetch GitHub Actions/Release pages, so the discrepancy remains explicitly unresolved.

## V5.3 ADAPTIVE VOLTAGE RISE DWELL — 2026-10-05
- [IMPLEMENTED] Both Adaptive profiles (HOTSIDE and HOTSIDE_BATTERY) now wait 5 seconds after each completed voltage increase before allowing the next upward step.
- [IMPLEMENTED] Adaptive activation from the mandatory 5V safe state also starts the same 5-second upward dwell.
- [IMPLEMENTED] Downward Adaptive voltage changes remain immediate; the 5-second dwell applies only to voltage increases.
- [IMPLEMENTED] Hotside fallback keeps the same cooperative 5-second upward timing.
- [IMPLEMENTED] Firmware promoted V5.2 → V5.3.
- [NOT BUILT HERE] App Build was not executed.

## APP HOME FAN SPEED DISPLAY QC — 2026-10-05
- [IMPLEMENTED] Fixed Home Fan Speed display for Adaptive + 12V: it now shows 100% instead of --.
- [PRESERVED] Manual + 12V continues to show the actual user-controlled Fan Speed.
- [PRESERVED] Adaptive Fan Speed remains non-editable; this is a display fix only.
- [IMPLEMENTED] Added regression coverage for Adaptive 12V = 100%, Manual 12V = configured speed, and 9V = 100%.
- [NOT BUILT HERE] App Build was not executed for this source fix.

## CURRENT APP SAFETY NOTIFY — 2026-10-05
- [IMPLEMENTED] Peltier restart notifications report the exact re-arm temperature (`hotLimit - 2°C`).
- [IMPLEMENTED] Touch ON/OFF ACKs are treated as valid results and surfaced cleanly; successful touch cooling is no longer shown as an error.
- [IMPLEMENTED] Retired `RAPID_HOTSIDE_RISE` notification wording was removed from the App.
- [IMPLEMENTED] Peltier failure notification avoids duplicating the firmware safety reason.

## V5.2 PELTIER SAFETY REARM FEEDBACK — 2026-10-05
- [IMPLEMENTED] Manual Peltier restart remains locked until Hotside <= hotLimit - 2°C after a Hotside safety event, including the 5V Adaptive terminal state.
- [IMPLEMENTED] Hardware Touch cooling ON now respects the same 2°C re-arm hysteresis and no longer bypasses the latch.
- [IMPLEMENTED] Any failed Peltier ON safety attempt gets a non-blocking 1-second red LED blink; a successful Peltier ON gets a non-blocking 1-second green LED blink.
- [IMPLEMENTED] App NOTIFY now explains the re-arm threshold dynamically and no longer surfaces the retired RAPID_HOTSIDE_RISE reason.
- [IMPLEMENTED] Touch cooling success/failure ACKs are presented as clean notifications; ON/OFF ACK reasons are no longer misclassified as errors.
- [IMPLEMENTED] Firmware version bumped V5.0 → V5.2 for this functional safety/notification revision.
- [NOT BUILT HERE] App Build was not executed for this change.

## V5.0 SELECTOR / MOSFET / LED TIMING EXECUTION — 2026-10-05
- [IMPLEMENTED] Voltage selector: GPIO3 = 12V Optocoupler/Decoy, GPIO4 = 9V Optocoupler/Decoy; both OFF for 200 ms before the target selector is enabled, preventing simultaneous selector activation.
- [IMPLEMENTED] GPIO5 Peltier MOSFET and GPIO6 Fan MOSFET are not forcibly turned OFF during voltage changes; Peltier PWM state is preserved through the selector deadtime.
- [IMPLEMENTED] Fan is forced to 100% at the start of every voltage transition.
- [IMPLEMENTED] Fan Speed is adjustable only while already at 12V; commands during a voltage transition are rejected, and returning to 12V does not restore a previous speed preference.
- [IMPLEMENTED] HOTSIDE red LED blink duration is 10 seconds and is aligned with each 10-second HOTSIDE timing stage, including the 5V terminal stage.
- [IMPLEMENTED] Firmware version bumped V4.9 → V5.0 for this functional revision.
- [NOT BUILT HERE] App Build remains a separate operation.

## V4.9 HOTSIDE EXECUTION — 2026-10-05
- [IMPLEMENTED] HOTSIDE 12V limit: Fan remains ON, Peltier OFF, 10-second dwell, then 9V.
- [IMPLEMENTED] HOTSIDE 9V limit: Fan OFF, Peltier OFF, 10-second dwell, then 5V.
- [IMPLEMENTED] HOTSIDE 5V terminal state: Adaptive exits, Peltier remains OFF, and manual restart is required after thermal re-arm.
- [IMPLEMENTED] Manual-mode Hotside protection preserves the selected voltage.
- [IMPLEMENTED] Manual Peltier safety re-arm hysteresis: 2°C below hotLimit.
- [IMPLEMENTED] App fixed 2-second Peltier precharge removed; firmware soft-start remains authoritative.
- [NOT BUILT HERE] App Build is intentionally separate from this execution.

## TRANSFER / MEMORY STATE
- [VERIFIED] CHAT_TRANSFER.md was replaced at commit 3d21b33b5c96640f7393a4956ad2ccb868639644.
- [VERIFIED] Saved CHAT_TRANSFER blob: fc00fdf83cd461f4f76e1edca6b53453111f1137.
- [VERIFIED] Pre-save HEAD reconciled before transfer write: 3a54d83956f357750684a32279952cbd7fb484f8.
- [VERIFIED] CHAT_TRANSFER save commit: 3d21b33b5c96640f7393a4956ad2ccb868639644; saved blob fc00fdf83cd461f4f76e1edca6b53453111f1137.
- [VERIFIED] Later documentation-only reconciliation commits remain after the transfer save; their exact latest head is verified separately after this write.

## CURRENT TASK RESULT
- [IMPLEMENTED] Hardware single-tap voltage now follows 5V → 9V → 12V → 9V → 5V → ...
- [IMPLEMENTED] Hardware long-press cooling ON forces Fan to 100%.
- [PRESERVED] Peltier OFF → ON keeps the existing cooperative 5-second soft-start.
- [PRESERVED] BOOT_AP_HARD_LIMIT_MS remains 60 seconds.
- [REMOVED] Rapid Hotside-rise protection and its dedicated slope/event state/history.
- [PRESERVED] Normal Hotside temperature-limit safety.
- [PRESERVED] Local OTA Golden/Protected path and single-radio Wi-Fi/BLE ownership.
- [PRESERVED] BLE UUIDs, P1 protocol, Adaptive, RGB, telemetry, and existing App behavior outside the targeted CONTROL change.
- [IMPLEMENTED] Peltier Safety popup queues FAN:ON and PELTIER:ON back-to-back; no App-side Fan telemetry wait remains between the two commands.
- [QC FIX] Firmware V4.9 publishes Fan/Peltier/Fan-speed realtime deltas from pre-mutation state snapshots.
- [QC FIX] App consumes unsolicited FAN/PELTIER/FAN_SPEED telemetry immediately and reconciles stale Notify errors only after healthy live safety telemetry.
- Firmware version incremented from V4.6 to V4.9 because this is a functional realtime-telemetry QC fix.

## QC / RELEASE STATE
- [VERIFIED] V5.4 source/static audit passed for the Fan/LED Hotside dwell QC correction and prior safety revisions.
- [UNVERIFIED] Arduino compilation, BIN generation, V5.4 flash/OTA, and App ↔ Firmware physical integration after this revision.
- [NOT RELEASED] V5.4 is not yet a released firmware.
- Functional source is frozen during QC unless a demonstrated QC defect requires a targeted fix.

## FIRMWARE
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- Core: Arduino-ESP32 3.3.7.
- GPIO contract: NTC 0, Touch 1, 12V 3, 9V 4, Peltier 5, Fan 6, WS2812 7.
- Fan PWM: 25 kHz, 8-bit, 50–100%; hardware touch ON forces 100%.
- Peltier PWM: 20 kHz, 8-bit, 5-second OFF→ON soft-start.
- Hotside NTC sample interval: 1 s.
- Hotside limit range: 40–50°C, default 45°C.
- NTC fault behavior remains Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- Rapid-rise slope protection is removed; no RAPID_HOTSIDE_RISE event is emitted.
- V5.4 compile/BIN/flash/OTA validation remains pending.

## APP
- App version remains 1.0.0+3.
- [IMPLEMENTED] CONTROL Peltier-start sequence: App queues FAN:ON then PELTIER:ON back-to-back; Firmware owns the 5-second Peltier soft-start.
- Fan already ON -> Peltier ON remains immediate; no App-side precharge timer.
- App continues to treat firmware telemetry as authoritative for physical/safety state.
- App Build remains separate and was not executed by this change.

## CI / BUILD
- App Build is manual issue-trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER.
- Required token: JEXFYZ_BUILD_TRIGGER_V1.
- Normal push/PR do not trigger App Build.
- Workflow uses Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, ubuntu-24.04.
- Release build is obfuscated and production-signed.
- Exactly one APK is published to GitHub Release jexfyz-latest as JEXFYZ-release.apk.
- No App Build was executed for the popup start-sequence revision.

## VALIDATION BOUNDARY
- [VERIFIED] Repository/source audit for the requested V5.0 selector/MOSFET/Fan/LED behavior.
- [USER-CONFIRMED] V4.6 Firmware compilation, Online OTA, and hardware test succeeded before the V4.9 telemetry fix.
- [UNVERIFIED] Firmware compile independently reproduced in this environment.
- [UNVERIFIED] Final BIN generation.
- [UNVERIFIED] ESP32-C3 flash.
- [UNVERIFIED] Hardware-only touch/Fan/Peltier behavior.
- [UNVERIFIED] Hotside/NTC safety runtime tests.
- [UNVERIFIED] V5.3 Local OTA and Online OTA + GATT recovery.
- [UNVERIFIED] App Build after the safety/Notify fixes and App ↔ V5.3 physical integration.
- [NOT RELEASED] Release Gate is not complete.

## EXACT NEXT ACTION
> **Compile V5.4 → generate BIN → flash/OTA → hardware/safety QC → App Build separately → App ↔ V5.4 integration QC → Release Gate.**
`````

---

## Archived file: `HANDOVER.md`

- Original blob at snapshot: `3867c4a2b23d77e234e163ffae96c1cb61f92c48`
- Reason preserved: Legacy handover with duplicated historical/current status

`````markdown
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
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, user-reported evidence boundary, trade-off, and recurrence-prevention rules.
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
`````

---

## Archived file: `APP_NOTES.md`

- Original blob at snapshot: `ee6d188ee6a82fc73a10be4979c0ddefc18708c7`
- Reason preserved: Legacy combined App notes and past execution log

`````markdown
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
`````

---

## Archived file: `FIRMWARE_NOTES.md`

- Original blob at snapshot: `f9463f39031760c5dc29a8c575b992f1c85f1bdb`
- Reason preserved: Legacy combined Firmware notes and past execution log

`````markdown
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

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.4.ino`, blob `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. The user reports a successful firmware compile and GitHub connection, but no complete OTA transfer/apply/reboot proof is recorded here. No BIN generation/publication, flash, independent hardware validation, Android BLE pairing, or APK Build was performed by the assistant.
- [NOT RELEASED] V6.4 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

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

## CURRENT V5.9 INTEGRATED QC BATCH — 2026-10-06

- Firmware source: `firmware/JEXFYZ-V5.9.ino`.
- App: 1.0.0+3.
- Status: DEVELOPMENT + QC / PRE-RELEASE — NOT RELEASED.
- App + Firmware are one integrated contract.
- Peltier safety re-arm: effective Hotside lock; thermal re-arm is signaled with 2 green blinks at <= hotLimit - 2°C; Touch/BLE/Adaptive use the same effective safety gate.
- Adaptive Hotside recovery: 20 seconds per rail with 19 seconds red blink + final 1 second blue blink; re-arm before the boundary resumes Peltier on the same rail.
- Adaptive sequence: 12V -> 9V -> 5V, each with its own 20-second thermal stage. If 5V still fails to re-arm after 20 seconds, Adaptive exits and the Peltier stays locked until manual restart.
- Manual Hotside protection: selected voltage is preserved; red blink continues for the entire lock until the <= hotLimit - 2°C re-arm threshold; then 2 green blinks.
- Normal successful Peltier ON no longer emits green feedback; green is reserved for the thermal re-arm event.
- App: P1 required for session readiness; stale Peltier re-arm notice clears on healthy safety telemetry; safety-sensitive paired startup is serialized; PHONE:BT is coalesced; ONLINE_IMAGE_VALIDATE is mapped.
- Android notification preference is not saved ON unless runtime permission is granted.
- Foreground BLE-support service is NOT_STICKY.
- OTA Local, OTA Online, Wi-Fi↔BLE handoff, OTA state/recovery, image validation, URL/path contract, and BLE/P1/SYNC architecture remain FROZEN.
- `versionName "Telegram @horizontalzzz"` is intentional and unchanged.
- App Build was NOT requested by this execution.
- V5.9 compile/flash/physical regression and final release gate remain pending.

# JE X FYZ — CURRENT FIRMWARE NOTES

## ACTIVE
- Version: V6.1
- Source: firmware/JEXFYZ-V6.1.ino
- Current blob after Touch telemetry fix: 50dee6c7ed3cb5780e97deaa235fe81856152ec2
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7


## CURRENT PHASE
- CODE COMPLETE
- DEVELOPMENT + QC / PRE-RELEASE
- NOT RELEASED
- Functional source is frozen unless QC demonstrates a real defect.


## V5.9 INTEGRATED QC — 2026-10-06
- Peltier safety lock auto-releases when Hotside is at or below `hotLimit - 2°C`.
- Thermal re-arm readiness is indicated directly when Hotside reaches the configured 2°C hysteresis threshold; a later Peltier ON command has no additional green indicator.
- While the effective lock is still active, a forced Peltier ON attempt keeps the red 1-second indication.
- NTC conversion math remains unchanged; only the sampling method returned from the V5.6 multi-sample burst to one reading per second.

## CONTROL CONTRACT
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling long press ON: Fan 100%.
- Peltier OFF → ON: 5-second cooperative soft-start, unchanged.
- Hotside NTC sampling is exactly 1 calibrated ADC reading every 1 second.
- NTC temperature has no median, trimmed mean, EMA, Kalman, sorting, or multi-sample burst; safety uses the single current ADC result.
- Normal Peltier ON/OFF emits no Peltier LED indicator.
- After Hotside safety forces Peltier OFF, failed re-arm ON attempts blink red for 1 s; a successful re-arm ON attempt at hotLimit - 2°C blinks green for 1 s.
- Adaptive activation cannot bypass an active Peltier safety latch.
- Fan remains 25 kHz, 8-bit, 50–100% for App-controlled operation.
- Voltage selector deadtime 200 ms; voltage guard 1 s.
- Adaptive HOTSIDE safety timing uses a 20-second thermal stage per rail; both Adaptive profiles retain the 5-second dwell after every upward voltage step; Peltier restart safety uses the 2°C re-arm hysteresis.
- TTP223 Touch uses 30 ms press/release qualification, 60–500 ms valid tap duration, 800 ms double-tap decision window from first valid release, second-tap grace, 1 s startup grace, and preserved 3+ tap cancellation.
- RGB/touch double-tap behavior remains unchanged at the command level; only input recognition timing/filtering was hardened.

## SAFETY CONTRACT
- Hotside NTC remains the universal thermal safety input and is sampled every 1 s.
- Hotside limit remains 40–50°C, default 45°C.
- NTC fault remains Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- Rapid Hotside-rise slope protection is removed completely.
- No RAPID_HOTSIDE_RISE safety event is emitted.
- Normal Hotside temperature-limit protection remains active, with a 20-second Adaptive step-down dwell and continuous Manual re-arm indication.

## OTA CONTRACT
Local OTA:
- Golden/Protected.
- Boot AP hard limit remains 60 seconds.
- Wi-Fi and BLE radio ownership remain mutually exclusive.

Online OTA:
- V3.2-style bounded Wi-Fi retry path.
- No yellow progress layer.
- Existing OTA result LED/state-machine behavior remains unchanged.
- Download processing remains cooperative.

## OTA PROTECTION — 2026-10-06
- Repository reminder: OTA_PROTECTION.md.
- OTA path is protected/frozen during normal feature work.
- OTA changes require a demonstrated OTA defect, explicit discussion/approval, and full OTA re-audit.
- Anti-downgrade remains OFF; any valid firmware version different from the device version may be selected.
- This reminder is a process guard; it does not replace compile, BIN, OTA, or hardware QC.

## V5.4 CHANGE — HOTSIDE DWELL FAN + LED — 2026-10-06
- Adaptive HOTSIDE safety keeps Fan ON at 100% throughout each full 20-second thermal dwell.
- Every completed HOTSTEP keeps Fan ON at 100% while Hotside safety remains active.
- Hotside Adaptive dwell LED: 19 seconds red blink, then 1 second blue blink; green 2x is shown only when the Hotside re-arm threshold is reached.
- Promoted Firmware V5.3 → V5.4.
- No blocking timing was introduced.

## V5.3 CHANGE — ADAPTIVE VOLTAGE RISE DWELL
- Both HOTSIDE and HOTSIDE_BATTERY Adaptive profiles now wait 5 seconds after a completed upward voltage transition before the next increase.
- Adaptive activation from safe 5V starts the same 5-second upward dwell.
- Downward Adaptive steps remain immediate.
- The existing non-blocking millis() timing model is preserved.
- Firmware version bumped V5.2 → V5.3.

## V5.2 CHANGE
- Promoted V4.7 → V4.9 for the approved HOTSIDE-only safety sequence and realtime telemetry baseline.
- Preserved the hardware touch voltage bounce sequence.
- Hardware cooling ON forces Fan to 100%.
- Preserved the existing Peltier 5-second OFF→ON soft-start.
- Removed the rapid Hotside-rise slope/event protection only.
- Implemented HOTSIDE 12V 20s → 9V; HOTSIDE 9V 20s → 5V; 5V receives the same 20s stage and becomes a terminal Peltier lock if still unrearmed.
- Preserved the pre-mutation cooling snapshots so Fan/Peltier/Fan-speed transitions remain realtime.

## STATIC AUDIT
- 4907 lines.
- Firmware version/file alignment: V5.7 / JEXFYZ-V5.7.ino.
- Only one active versioned .ino exists under firmware/.
- executable delay() = 0 (comments excluded).
- timing while() = 0.
- RAPID_HOTSIDE_RISE = 0.
- rapid-rise state/history identifiers = 0.
- GPIO Peltier = 5; Fan = 6.
- BOOT_AP_HARD_LIMIT_MS = 60000.
- PELTIER_SOFT_START_MS = 5000.
- PELTIER_SAFETY_ATTEMPT_INDICATOR_DURATION_MS = 1000.
- HOT_PELTIER_OFF_MS = 10000.

## QC GATES
- Compile V5.4.
- Generate BIN.
- Flash/OTA ESP32-C3.
- Hardware-only control QC.
- V5.4 Peltier safety/selector/Adaptive rise-dwell/HOTSide sequence QC.
- Local OTA Golden Path.
- Online OTA + BLE recovery.
- App ↔ Firmware integration after the separately executed App Build.

## VALIDATION BOUNDARY
- V4.4 OTA: user-confirmed PASS for all OTA paths before V4.5 promotion.
- V4.7 source/static audit: PASS.
- V4.7 compile/BIN/flash/physical validation: pending.
`````

---

## Archived file: `BUILD_NOTES.md`

- Original blob at snapshot: `ba4d69b10f8427769a547b112c2d9e5ac7d2686e`
- Reason preserved: Legacy build notes

`````markdown
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
- [UNVERIFIED] The added V6.3 latch regression has not been run. User-reported compile success and restored GitHub connectivity are recorded above, but a complete OTA transfer/apply/reboot proof is not established here. No BIN generation/publication, assistant-side flash, independent hardware validation, Android BLE pairing, or APK Build was performed.
- [NOT RELEASED] V6.4 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

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

`````

---

## Archived file: `firmware/FIRMWARE_ANALYSIS.md`

- Original blob at snapshot: `9e009ec08b1dcac9d43b75f8b22473481ed45aaa`
- Reason preserved: Legacy firmware analysis

`````markdown
## CURRENT V6.4 EXECUTION STATUS — 2026-10-14

- [VERSION ALIGNMENT — SOURCE ONLY] Active source is `firmware/JEXFYZ-V6.4.ino` with `FW_VERSION = "V6.4"`; the V6.3-named active file is retired. This revision has not been compiled; no BIN generation, flash/OTA, Firebase update, or release is implied.

### Peltier voltage-transition restart prevention — 2026-10-13

- [FIXED IN SOURCE — NOT COMPILED] On a voltage transition, firmware pauses Peltier PWM only if the 5-second soft-start is still active: it records that state and forces GPIO5 PWM to 0% before selector handoff. If soft-start has completed and PWM is already 100%, Peltier PWM stays at 100% throughout the voltage transition unless a Peltier-OFF command or safety protection stops it. Fan remains ON/forced to 100%; the existing 200 ms break-before-make selector sequence is unchanged.
- [IMPLEMENTED IN SOURCE] An interrupted ramp remains at 0% through the existing 1,000 ms settle interval (`PELTIER_VOLTAGE_SETTLE_MS`, aliased to `VOLTAGE_GUARD_MS`), then starts a fresh 5-second ramp from 0%. A completed ramp is not interrupted: it stays at 100% during the selector transition, without another soft-start or a forced 0% interval. Peltier-OFF, thermal/sensor safety, or OTA safe-output handling must stop output and cancel any pending ramp resume.
- [REGRESSION CONTRACT ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` checks pause-before-selector ordering only for an active ramp, the conditional 1-second settle/fresh-ramp path, uninterrupted 100% duty when the ramp already completed, cancellation on Peltier OFF, and reset-reason diagnostics.
- [USER-REPORTED SYMPTOM] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON during soft-start. A power transient/brownout is a plausible hypothesis, not a confirmed reset cause; capture `BOOT: RESET_REASON=...` after the next user-side reproduction.
- [UNVERIFIED] The latest source revision has not been compiled or tested on hardware. The earlier V6.3 compile report predates this fix. No BIN, flash, physical OTA, or release operation was performed.
- [CANONICAL MEMORY] See [VOLTAGE_TRANSITION_MEMORY.md](../VOLTAGE_TRANSITION_MEMORY.md) for the full incident record, exact timing contract, safeguards, and validation boundary.

### Online OTA legacy connection restoration — 2026-10-13

- [SOURCE FIX IMPLEMENTED] Firmware V6.3 uses the prior `cloudClient.setInsecure()` path again. The embedded CA PEM, CA validation call, `configTime()`, `TIME_SYNCING` state and 20-second NTP gate are removed. Wi-Fi success directly starts the blue indicator before the GitHub GET attempt.
- [PRESERVED] GitHub raw BIN URL allowlisting, redirect blocking, size/image checks, safe outputs and OTA recovery remain present. The connection does not authenticate the HTTPS server certificate.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_4_qc_contract_test.dart` checks the new path and guards the allowlist/redirect behavior.
- [USER-REPORTED RESULT — 2026-10-13] The user reports V6.3 compiles successfully and Online OTA can connect to GitHub after the restoration. Full BIN transfer, `Update.end()`, restart and installed-version confirmation are not independently established. Since CA validation and NTP gating were removed together, the evidence does not isolate one of them as the sole root cause.
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](../OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, evidence boundary, trade-off, and prevention rules.
- [NOT DONE BY ASSISTANT] No firmware compile, BIN generation/publication, flash or hardware OTA was performed in this assistant session.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.4.ino`, blob `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. The user reports compile and GitHub connectivity success, but end-to-end firmware installation, flash confirmation, Android BLE pairing and complete OTA regression remain unverified here. No APK Build was run.
- [NOT RELEASED] V6.4 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

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

- [CURRENT TRUTH] Active firmware source: `firmware/JEXFYZ-V6.1.ino`; `FW_VERSION` is `V6.1`; target ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [IMPLEMENTED] V6.1 carries forward the Adaptive rail-handoff fix: Peltier PWM is disabled before the 200 ms selector break-before-make transition, and prior Peltier operation is restored after safe 5 V completion through the existing safety gates and 5-second OFF→ON soft-start.
- [IMPLEMENTED] Adaptive ON feedback remains three orange blinks after successful activation; Adaptive OFF feedback is deferred until the safe-5V handoff completes when the mode actually changed from ON to OFF, or starts immediately if already at 5 V.
- [DIAGNOSTIC] Firmware writes `BOOT: RESET_REASON=<reason>` to Serial during startup.
- [COMMITTED] V6.1 source added on `main` in commit `5fa7a4033a1cf2c5989c5fb9511be75cf34b7dbe`; the obsolete V6.0 source path was removed in commit `167f44df6c379d6d2a7a03b47f6620c609a4136c`. No PR was used.
- [NO BUILD] This V6.1 source/version promotion did not run a compile/build, generate a V6.1 BIN, flash hardware, or update production OTA metadata.
- [UNVERIFIED] Physical confirmation that the reported Adaptive restart is eliminated, that both LED indicators render on hardware, and that thermal/OTA regression remains pending.
- [NOT RELEASED] Production firmware repository `TenzoNkz/JEXFYZ-Firmware` and Firebase `firmware_update.json` were not changed. V6.1 remains source-only until separately built, validated, and explicitly released.

> The V6.0 section below is historical QC/build evidence only; it does not imply that V6.1 has been built, flashed, or released.

## HISTORICAL V6.0 EXECUTION — 2026-10-08

- [IMPLEMENTED] Firmware promoted V5.9 → V6.0 at firmware/JEXFYZ-V6.0.ino; FW_VERSION is V6.0.
- [IMPLEMENTED] Adaptive Profile is runtime-only. Default after boot is HOTSIDE; HOTSIDE_BATTERY remains the optional second Adaptive mode and is not stored in Preferences.
- [IMPLEMENTED] Persistent firmware settings are Hotside Limit, Battery 5V Limit, Battery 12V Limit, RGB ON/OFF, RGB Mode, RGB Brightness, and RGB Color.
- [IMPLEMENTED] All persistent setting changes share a 10-second quiet-period debounce. Every new change resets the timer; after 10 seconds without change, only values different from the persisted NVS shadow are written.
- [IMPLEMENTED] LED modes are now Static, Breath, Mirror Pulse, Comet, Dual Chase, Left/Right, and Rainbow. Center Out and Outer In are retired.
- [IMPLEMENTED] Adaptive state LED feedback is now three orange blinks on successful Adaptive ON and three white blinks on successful Adaptive OFF; the previous red→green→blue Adaptive-OFF feedback is retired. OTA and Hotside safety LED indicators remain unchanged.
- [IMPLEMENTED] Firmware publishes LED animation phase/cycle telemetry; App preview uses that firmware phase and mirrors the physical 4-left/4-right LED layout.
- [PRESERVED] OTA, single-radio Wi-Fi/BLE handoff, BLE/P1, GPIO mapping, NTC 1 Hz single-sample path, selector deadtime, voltage guard, Peltier soft-start, thermal safety, and Adaptive 5-second upward dwell were not intentionally changed.
- [AUDIT PASS] Source-level invariants passed for V6.0 version alignment, LED mode set, HOTSIDE default, non-persistent Adaptive Profile, LED phase protocol, GPIO mapping, and single NTC ADC read path.
- [UNVERIFIED] V6.0 ArduinoDroid compilation, BIN generation, ESP32-C3 flash, physical LED synchronization, thermal regression, Local/Online OTA regression, and App Build remain unverified.
- [NOT RELEASED] Project remains DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED.

> The V6.0 section above is historical; current V6.1 source-only state is recorded at the top.

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

# JE X FYZ — CURRENT FIRMWARE ANALYSIS

## SOURCE
- Active: firmware/JEXFYZ-V6.1.ino
- Version: V6.1
- Current blob after Touch telemetry fix: 50dee6c7ed3cb5780e97deaa235fe81856152ec2
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7


## CURRENT PHASE
> **V5.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**


## ARCHITECTURE
- ESP32-C3 single-radio model: Wi-Fi and BLE ownership are mutually exclusive.
- OTA is processed before normal application work.
- Local OTA uses boot SoftAP and remains protected.
- Online OTA uses Firebase metadata and the approved GitHub raw BIN endpoint.
- Firmware streams the image into the inactive OTA partition.
- Timing is cooperative.

## V5.8 PELTIER REARM + NTC SINGLE-SAMPLE QC FIX — 2026-10-06
- The effective Peltier safety lock auto-releases at `hotLimit - 2°C`.
- A one-shot re-arm feedback flag preserves the green 1-second LED for the first successful Peltier ON after a safety event.
- While the effective lock is active, blocked Peltier ON attempts preserve the red 1-second LED feedback path.
- NTC sampling is exactly one calibrated `analogReadMilliVolts()` sample per 1-second period.
- The prior 16-sample insertion-sort / 50% trimmed-mean path is removed.
- NTC electrical model remains 10K fixed resistor / 10K nominal NTC / Beta 3950 with the existing 3.3 V divider reference.
- Static V5.8 source audit passed for cooperative timing and balanced braces/parentheses; Arduino toolchain compilation and physical ESP32 validation remain separate and unverified.


## HARDWARE CONTROL
- GPIO: NTC 0, Touch 1, 12V 3, 9V 4, Peltier 5, Fan 6, WS2812 7.
- Single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: 5-second soft-start, then 100%.
- Adaptive upward voltage changes: 5-second cooperative dwell after every completed increase in both profiles; downward changes remain immediate.
- Double tap RGB and long-press Adaptive-OFF remain unchanged.

## V5.7 TTP223 TOUCH ACCURACY QC FIX — 2026-10-06
- TTP223 input processing is layered: raw GPIO → 30 ms qualification → stable edge → gesture engine.
- Startup touch input is ignored for the first 1,000 ms; if Q is already HIGH after startup grace, that held state is blocked until a qualified release.
- Tap validity uses raw HIGH duration 60–500 ms, avoiding double-counting the 30 ms input qualification time.
- Double-tap window is 800 ms from the first valid release. A second press that begins before the deadline gets release grace beyond the deadline; completed double tap resolves at the decision boundary, preserving the prior 3+ tap cancellation behavior.
- Long press remains 5,000 ms and is evaluated continuously from the qualified press.
- No blocking delay or timing wait was introduced.

## V5.6 NTC ADC FILTERING QC FIX — 2026-10-06
- Historical V5.6 change: multi-sample filtering was introduced here and is now retired by V5.8 after QC feedback.
- NTC conversion remains the existing 10K / 25°C / Beta 3950 model and the existing 3.3 V divider-reference assumption.
- Sensor fault gates remain applied after the filtered ADC millivolt result; abnormal results are invalidated rather than clamped into a temperature.
- No temperature-history filter was added, avoiding deliberate thermal lag in the safety path.

## V5.5 PELTIER SAFETY REARM LED FEEDBACK — 2026-10-06
- Normal Peltier ON/OFF no longer calls a Peltier LED command-result indicator.
- manualPeltierSafetyLatch remains set after cooldown until an explicit Peltier ON attempt succeeds; this preserves the distinction between a safety re-arm attempt and normal ON/OFF.
- While the latch is active, every blocked Peltier ON attempt produces a non-blocking 1-second red blink.
- When Hotside is <= hotLimit - 2°C, a successful Peltier ON attempt produces a non-blocking 1-second green blink and clears the latch.
- The Hotside 10-second dwell indicator keeps LED priority, so its 9-second red + final 1-second green sequence is not disrupted.
- No second safety latch or alternate thermal threshold was introduced.
- Adaptive start is explicitly blocked while manualPeltierSafetyLatch is active, so the safety re-arm cannot be bypassed through Adaptive mode.

## V5.4 HOTSIDE DWELL FAN + LED QC FIX — 2026-10-06
- Adaptive HOTSIDE safety keeps Fan ON at 100% for the complete 10-second thermal dwell.
- Completed HOTSTEP transitions keep Fan ON at 100% while thermal protection remains active.
- Hotside dwell LED uses 9 seconds red blink plus the final 1 second green blink.
- The selector step timing and 10-second dwell duration are unchanged.
- Firmware version/file alignment is now V5.4 / JEXFYZ-V5.4.ino.

## V5.3 ADAPTIVE VOLTAGE RISE DWELL
- HOTSIDE and HOTSIDE_BATTERY both use the same 5-second post-transition dwell for every upward voltage step.
- Adaptive startup from safe 5V also waits 5 seconds before the first upward step.
- The timer remains cooperative and does not use blocking delay() or while() timing.

## V5.2 TOUCH ACK CLEANUP
- Successful Touch cooling OFF uses an explicit OFF acknowledgement.

## V5.2 PELTIER SAFETY REARM FEEDBACK
- Manual and 5V Adaptive-terminal Peltier restart remains locked until Hotside <= hotLimit - 2°C.
- Hardware Touch restart uses the same re-arm hysteresis and cannot bypass the latch.
- Failed Peltier ON: red blink 1 second. Successful Peltier ON: green blink 1 second.

## V5.1 SAFETY REARM FEEDBACK
- Peltier ON safety rejection: 1-second red blink.
- Peltier ON success: 1-second green blink.
- Re-arm threshold: Hotside <= hotLimit - 2°C.
- Touch and App Peltier start paths use the same safety latch semantics.

## SAFETY
- Hotside NTC is the universal thermal safety input.
- Normal Hotside temperature-limit protection remains active with the 10-second step-down dwell.
- Rapid Hotside-rise protection was removed; no dedicated slope/event/history state remains.
- NTC invalid state still forces Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.

## OTA
1. Capture active GATT state/connection ID.
2. Close the active GATT session when present.
3. Clear BLE session/controller state.
4. Stop advertising.
5. Transfer radio ownership to Wi-Fi.
6. Use the V3.2-style bounded Wi-Fi retry path.
7. Download and finalize.
8. Restart and recover BLE.

## OTA PROTECTION — 2026-10-06
- Repository reminder: OTA_PROTECTION.md.
- OTA runtime, OTA priority, BLE radio handoff, and App OTA contracts are protected/frozen during normal feature work.
- Deliberate OTA changes require a demonstrated OTA defect, explicit discussion/approval, and full OTA re-audit.
- Anti-downgrade is explicitly OFF.

## STATIC RESULT — V5.9
- Active source/file alignment: V5.9 / firmware/JEXFYZ-V5.9.ino.
- No executable delay() or timing while() loops in the firmware source audit target.
- No RAPID_HOTSIDE_RISE.
- NTC sample path is exactly one calibrated ADC read per 1-second period.
- Peltier effective safety gate and one-shot re-arm feedback are unified across BLE, Touch, and Adaptive.
- OTA Local/Online runtime and single-radio handoff were preserved; no OTA functional source change was introduced by this batch.
- Compile/BIN/flash/physical/OTA runtime validation remains pending.


## VALIDATION BOUNDARY
- [VERIFIED] Source/static audit.
- [UNVERIFIED] Arduino compile.
- [UNVERIFIED] BIN generation.
- [UNVERIFIED] ESP32-C3 flash.
- [USER-CONFIRMED] V4.6 physical hardware behavior passed before the V4.9 telemetry fix.
- [UNVERIFIED] V4.9 physical hardware regression after the telemetry fix.
- [UNVERIFIED] Safety runtime.
- [UNVERIFIED] Local OTA V4.6.
- [UNVERIFIED] Online OTA/BLE recovery V4.6.
- [VERIFIED] V4.9 source/static audit for the realtime telemetry fix.
- [USER-CONFIRMED] V5.7 OTA update to hardware succeeded.
- [UNVERIFIED] V5.7 compile/BIN/flash/physical functional validation and App integration remain separate QC gates.
- [NOT RELEASED] Release Gate is incomplete.

`````

