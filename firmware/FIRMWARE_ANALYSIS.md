## CURRENT V6.1 SOURCE PROMOTION — 2026-10-12

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
- Active: firmware/JEXFYZ-V5.9.ino
- Version: V5.9
- Blob: 11879cda3e96411c16cc372a176dcef6b71ebe94
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
