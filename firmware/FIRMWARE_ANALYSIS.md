## CURRENT V6.3 EXECUTION STATUS — 2026-10-13

### Peltier voltage-transition restart prevention — 2026-10-13

- [FIXED IN SOURCE — NOT COMPILED] When an accepted voltage change occurs while the logical Peltier state is ON, firmware now forces physical GPIO5 PWM to 0% before opening the selector handoff. Fan remains enabled and is forced to 100%; the existing 200 ms break-before-make sequence remains unchanged.
- [IMPLEMENTED IN SOURCE] After selector completion, PWM stays at 0% for 1,000 ms using `PELTIER_VOLTAGE_SETTLE_MS` (aliased to the existing `VOLTAGE_GUARD_MS`), then a new 5-second soft-start begins from 0%. This also protects transitions when Peltier had already reached full duty.
- [REGRESSION CONTRACT ADDED — NOT RUN] `test/v6_3_qc_contract_test.dart` checks pause-before-selector ordering, the 1-second settle gate, restart of the fresh ramp, and retention of `BROWNOUT` reset diagnostics.
- [USER-REPORTED SYMPTOM] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON during soft-start. A power transient/brownout is a plausible hypothesis, not a confirmed reset cause; capture `BOOT: RESET_REASON=...` after the next user-side reproduction.
- [UNVERIFIED] The latest source revision has not been compiled or tested on hardware. The earlier V6.3 compile report predates this fix. No BIN, flash, physical OTA, or release operation was performed.
- [CANONICAL MEMORY] See [VOLTAGE_TRANSITION_MEMORY.md](../VOLTAGE_TRANSITION_MEMORY.md) for the full incident record, exact timing contract, safeguards, and validation boundary.

### Online OTA legacy connection restoration — 2026-10-13

- [SOURCE FIX IMPLEMENTED] Firmware V6.3 uses the prior `cloudClient.setInsecure()` path again. The embedded CA PEM, CA validation call, `configTime()`, `TIME_SYNCING` state and 20-second NTP gate are removed. Wi-Fi success directly starts the blue indicator before the GitHub GET attempt.
- [PRESERVED] GitHub raw BIN URL allowlisting, redirect blocking, size/image checks, safe outputs and OTA recovery remain present. The connection does not authenticate the HTTPS server certificate.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_3_qc_contract_test.dart` checks the new path and guards the allowlist/redirect behavior.
- [USER-REPORTED RESULT — 2026-10-13] The user reports V6.3 compiles successfully and Online OTA can connect to GitHub after the restoration. Full BIN transfer, `Update.end()`, restart and installed-version confirmation are not independently established. Since CA validation and NTP gating were removed together, the evidence does not isolate one of them as the sole root cause.
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](../OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, evidence boundary, trade-off, and prevention rules.
- [NOT DONE BY ASSISTANT] No firmware compile, BIN generation/publication, flash or hardware OTA was performed in this assistant session.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.3.ino`, blob `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. The user reports compile and GitHub connectivity success, but end-to-end firmware installation, flash confirmation, Android BLE pairing and complete OTA regression remain unverified here. No APK Build was run.
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
