# JE X FYZ — CURRENT PROJECT STATE

## CURRENT PHASE
> **V5.5 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V5.5
- Firmware source change commits: 85bf8acf79fd91f0d3bbbe2440bec8bab73774da → fd883ca695cab2f35014b3cf069fa9454ae6bc89
- Active Firmware source: firmware/JEXFYZ-V5.5.ino
- Firmware source blob: ca6d88280dff8f14e220b6dc3b50e1967edaea1b
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- App main source blob: 48406cda017be1ce939ff682497324bf3680a7f3
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: 1951964af7542324b2ae27b1bd94f84e1c853060
- App CONTROL source change commit: b9f316e50770acb66770515395344de6c6e80ea6
- Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- App Build workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Direct issue-triggered Release workflow is authoritative; no reusable engine is active.
- Latest verified downloadable App Build: workflow run 37261171475 / GitHub Release jexfyz-latest.
- Latest verified APK: JEXFYZ-release.apk, 54,327,520 bytes, SHA-256 b8045d0b6fa6d05b421bd6b1c0318d4ee4529734d7b471534700f95676200888.
- No App Build was executed for the CONTROL precharge change.

## V5.5 PELTIER SAFETY REARM LED FEEDBACK — 2026-10-06
- [QC FIX / IMPLEMENTED] Normal Peltier ON/OFF no longer emits the green/red Peltier LED command indicator.
- [QC FIX / IMPLEMENTED] The Peltier LED feedback is reserved for ON attempts while manualPeltierSafetyLatch is active after a Hotside safety-forced Peltier OFF.
- [IMPLEMENTED] Any blocked re-arm attempt while the safety latch is active emits a non-blocking 1-second red blink.
- [IMPLEMENTED] A successful re-arm ON attempt after Hotside reaches hotLimit - 2°C emits a non-blocking 1-second green blink, then clears the latch.
- [PRESERVED] Hotside dwell LED remains 9 seconds red blink + final 1 second green blink and keeps priority over the short Peltier re-arm feedback.
- [IMPLEMENTED] Firmware promoted V5.4 → V5.5 for this targeted QC correction.
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
- [VERIFIED] Current main HEAD before this transfer write: 3a54d83956f357750684a32279952cbd7fb484f8 (docs: reconcile V5.3 handover for chat transfer).
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
