## CURRENT V6.0 EXECUTION — 2026-10-08

- [IMPLEMENTED] Firmware promoted V5.9 → V6.0 at firmware/JEXFYZ-V6.0.ino; FW_VERSION is V6.0.
- [IMPLEMENTED] Adaptive Profile is runtime-only. Default after boot is HOTSIDE; HOTSIDE_BATTERY remains the optional second Adaptive mode and is not stored in Preferences.
- [IMPLEMENTED] Persistent firmware settings are Hotside Limit, Battery 5V Limit, Battery 12V Limit, RGB ON/OFF, RGB Mode, RGB Brightness, and RGB Color.
- [IMPLEMENTED] All persistent setting changes share a 10-second quiet-period debounce. Every new change resets the timer; after 10 seconds without change, only values different from the persisted NVS shadow are written.
- [IMPLEMENTED] LED modes are now Static, Breath, Mirror Pulse, Comet, Dual Chase, Left/Right, and Rainbow. Center Out and Outer In are retired.
- [IMPLEMENTED] Firmware publishes LED animation phase/cycle telemetry; App preview uses that firmware phase and mirrors the physical 4-left/4-right LED layout.
- [PRESERVED] OTA, single-radio Wi-Fi/BLE handoff, BLE/P1, GPIO mapping, NTC 1 Hz single-sample path, selector deadtime, voltage guard, Peltier soft-start, thermal safety, and Adaptive 5-second upward dwell were not intentionally changed.
- [AUDIT PASS] Source-level invariants passed for V6.0 version alignment, LED mode set, HOTSIDE default, non-persistent Adaptive Profile, LED phase protocol, GPIO mapping, and single NTC ADC read path.
- [UNVERIFIED] V6.0 ArduinoDroid compilation, BIN generation, ESP32-C3 flash, physical LED synchronization, thermal regression, Local/Online OTA regression, and App Build remain unverified.
- [NOT RELEASED] Project remains DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED.

> Earlier V5.9 sections remain historical and do not override current V6.0 source/workflow.

## CURRENT V5.9 QC FOLLOW-UP — 2026-10-08

- [IMPLEMENTED / COMMITTED] Latest Firmware source remains `firmware/JEXFYZ-V5.9.ino`; current source blob: `2941942622efadf1d98ebd632ffddfdb40d5884b`; implementation commit: `5190d8d587e358e3853a483c34b9a09ddd9620dc`.
- [USER-CONFIRMED / PRE-FIX] Firmware compiled successfully and V5.9 Online OTA updated the hardware before this QC follow-up.
- [IMPLEMENTED] Adaptive Hotside recovery dwell is now 30 seconds only at 12 V and 9 V: 29 seconds red blink + final 1 second blue before stepping down.
- [IMPLEMENTED] Adaptive 5 V is terminal: no 30-second countdown and no blue phase. While Hotside remains above the re-arm threshold, Adaptive exits into the manual-restart thermal lock and the LED remains continuous red until Hotside reaches <= `hotLimit - 2°C`.
- [IMPLEMENTED] Peltier command-result LED feedback has been removed. Peltier ON/OFF commands no longer start a separate red/green indicator that can interrupt the Hotside red blink. Green remains reserved for thermal re-arm.
- [IMPLEMENTED] Adaptive activation is now gated: Fan and Peltier must already both be ON from the Control menu. Pressing Adaptive with either output OFF is denied and does not turn either output ON.
- [PRESERVED] OTA runtime, BLE/P1, GPIO mapping, NTC single-sample cadence, selector deadtime, voltage guard, Peltier soft-start, and Adaptive 5-second upward dwell were not intentionally changed.
- [AUDIT PASS] Post-change static audit: no executable `delay()`, no timing `while()`, no `RAPID_HOTSIDE_RISE`, exactly one `analogReadMilliVolts(PIN_NTC)` path, GPIO5=Peltier / GPIO6=Fan, braces balanced, obsolete Peltier attempt-indicator symbols removed.
- [UNVERIFIED] This post-fix source has not yet been recompiled, flashed, physically regression-tested, or used for a new OTA/BIN publication.
- [NOT RELEASED] Project remains V5.9 DEVELOPMENT + QC / PRE-RELEASE.

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