## CURRENT V6.3 EXECUTION STATUS — 2026-10-13

### Online OTA connection regression correction — 2026-10-13

- [FIXED IN SOURCE — NOT COMPILED] V6.3 Online OTA now restores the previous `cloudClient.setInsecure()` connection path. The inline ISRG Root X1 certificate, CA validation call, `configTime()`, `TIME_SYNCING` state, and 20-second NTP gate were removed. On Wi-Fi connection, the blue indicator runs directly before the GitHub GET attempt.
- [PRESERVED] The HTTPS transport, raw GitHub BIN URL allowlist for `TenzoNkz/JEXFYZ-Firmware`, redirect blocking, download size/image checks, safe-output sequencing, and OTA recovery path remain in place. `setInsecure()` does not validate the server certificate identity.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_3_qc_contract_test.dart` now asserts the restored connection path, removal of CA/NTP gates, blue-before-GitHub flow, and retention of the URL allowlist/redirect block.
- [UNVERIFIED] This source change has not been compiled or tested on physical hardware. No BIN was generated, published, flashed, or installed; no OTA test was run.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.3.ino`, blob `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. No V6.3 Firmware compile, BIN, flash, hardware, Android BLE pairing, or OTA regression has been performed. No APK Build was run.
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