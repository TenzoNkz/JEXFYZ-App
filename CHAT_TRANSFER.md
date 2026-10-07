# JE X FYZ — CHAT TRANSFER / NEW CHAT BOOT PROTOCOL

> Transfer Protocol v3 — current V5.9 integrated QC snapshot reconciled from main.

## 0. READ FIRST / MANDATORY BOOT

- [VERIFIED] Current repository: TenzoNkz/JEXFYZ-App.
- [VERIFIED] Branch: main.
- [VERIFIED] Current main HEAD at the start of this functional execution: 414cc6959d9fd5d89968da19b9473b317b0cbba7; firmware execution commit: 3c5aca4e6e6e01ea025d76965c85d8014e84a378.
- [VERIFIED] Current active Firmware: V5.9 at firmware/JEXFYZ-V5.9.ino.
- [VERIFIED] Current App: 1.0.0+3; package com.horizontalzzz.jexfyz.
- [VERIFIED] Current phase: V5.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED.
- [POLICY] Read this file first, then reconcile current source/configuration before acting.
- [POLICY] Current source and workflow always outrank this transfer snapshot when they conflict.
- [POLICY] Do not ask the user to repeat project facts already documented here or in the authoritative repository files.
- [POLICY] Transfer/save does not authorize functional source changes, App Build, Firmware release, BIN publishing, or unverified runtime claims.

## 1. PROJECT IDENTITY

- [CURRENT TRUTH] Project: JE X FYZ.
- [CURRENT TRUTH] App name: JE Cooler.
- [CURRENT TRUTH] Header/branding: JE X FYZ.
- [CURRENT TRUTH] Hardware: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [CURRENT TRUTH] Firmware source authority: firmware/ inside JEXFYZ-App.
- [CURRENT TRUTH] Firmware publishing repository: TenzoNkz/JEXFYZ-Firmware.
- [CURRENT TRUTH] Active Firmware: V5.9.
- [CURRENT TRUTH] App version: 1.0.0+3.
- [CURRENT TRUTH] Package: com.horizontalzzz.jexfyz.
- [CURRENT TRUTH] Release status: NOT RELEASED.

## 2. AUTHORITY HIERARCHY

1. Current source/configuration and current workflow.
2. PROJECT_STATE.md.
3. Authoritative current engineering notes.
4. HANDOVER.md / CHAT_RULES.md / CHANGELOG.md.
5. CHAT_TRANSFER.md.
6. Current chat statements.
7. Old chat/history.

- [POLICY] Historical statements are evidence of history, not current implementation permission.
- [POLICY] When documentation conflicts with source, record the discrepancy rather than guessing.

## 3. USER COMMAND PROTOCOL

- [USER REQUIREMENT] @Thinking Diskusi! = discussion/review only.
- [USER REQUIREMENT] @Thinking Tanya Gemini! = diagnosis/OLD → NEW patch request; do not silently execute.
- [USER REQUIREMENT] @Thinking Eksekusi! = implement approved scope + affected audit + docs/memory sync + commit; no App Build unless separately commanded.
- [USER REQUIREMENT] @Thinking Eksekusi Full! = full implementation + broad affected audit + docs/memory sync + commit; App Build is not implied.
- [USER REQUIREMENT] @Thinking Build App! = explicit App Build operation.
- [USER REQUIREMENT] @Thinking Eksekusi & Build App! = implement → audit → docs → commit → App Build.
- [POLICY] Chat-limit transfer/save itself is documentation-only.

## 4. CURRENT PROJECT MODE

- [CURRENT TRUTH] QC / PRE-RELEASE.
- [CURRENT TRUTH] Functional source is frozen except for a demonstrated QC defect with clear root cause and approved scope.
- [CURRENT TRUTH] V5.9 is NOT RELEASED.
- [POLICY] Static audit, compile, BIN generation, flash, physical QC, OTA regression, App integration, and App Build are separate gates.

## 5. HARDWARE CONTRACT

| Function | GPIO |
| --- | ---: |
| NTC Hotside | 0 |
| TTP223 Touch | 1 |
| 12V selector | 3 |
| 9V selector | 4 |
| Peltier | 5 |
| Fan | 6 |
| WS2812 | 7 |

- [FROZEN] ESP32-C3 single-radio rule: Wi-Fi and BLE must never own the radio concurrently.
- [FROZEN] Fan PWM: 25 kHz, 8-bit, 50–100%.
- [FROZEN] Peltier PWM: 20 kHz; OFF→ON soft-start 5 seconds, cooperative.
- [FROZEN] Selector deadtime: 200 ms break-before-make.
- [FROZEN] Voltage guard: 1 second after completed transition.
- [FROZEN] NTC model: 10K NTC + 10K fixed resistor + Beta 3950 + 3.3 V reference design.
- [FROZEN] V5.9 NTC cadence: exactly one calibrated ADC reading every 1 second.
- [FROZEN] Hotside limit: 40–50°C, default 45°C.
- [FROZEN] NTC fault: Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.

## 6. FIRMWARE CONTRACT

- [VERIFIED] Active source contains FW_VERSION V5.9.
- [VERIFIED] Static source checks: one NTC ADC read, no executable delay(), no timing while(), no RAPID_HOTSIDE_RISE, dead bleSyncPending state removed.
- [IMPLEMENTED] Effective Peltier safety lock blocks Peltier when Hotside is above hotLimit - 2°C or NTC is invalid; Manual red blink persists until thermal re-arm, then green 2x.
- [IMPLEMENTED] Green safety feedback is now emitted only at thermal re-arm; successful Peltier ON commands do not emit an additional green indicator.
- [IMPLEMENTED] Blocked effective-lock ON attempt remains safety-gated; the active Hotside red lock indicator has priority while unrearmed.
- [IMPLEMENTED] Adaptive activation uses the same effective safety latch gate.
- [FROZEN] Both HOTSIDE and HOTSIDE_BATTERY Adaptive profiles wait 5 seconds after each completed upward voltage step; downward changes remain immediate.
- [IMPLEMENTED] Adaptive Hotside safety uses a 20-second thermal stage per rail: 19-second red blink + final 1-second blue blink; if Hotside reaches <= hotLimit - 2°C, green 2x indicates re-arm and Peltier may resume on the same rail.
- [OBSOLETE] Rapid Hotside slope/RAPID_HOTSIDE_RISE protection.

## 7. TOUCH CONTRACT

- [FROZEN] TTP223 direct Active-High.
- [FROZEN] Single tap: 5V → 9V → 12V → 9V → 5V → ...
- [FROZEN] Double tap: RGB.
- [FROZEN] Long press: 5 seconds.
- [FROZEN] STARTUP_GRACE_MS 1000.
- [FROZEN] QUALIFICATION_MS 30.
- [FROZEN] Valid tap: 60–500 ms raw HIGH.
- [FROZEN] DOUBLE_TAP_WINDOW_MS 800.
- [FROZEN] LONG_PRESS_MS 5000.
- [IMPLEMENTED] Touch cooling/re-arm path uses the same effective Peltier safety gate as the BLE command path.
- [USER-CONFIRMED] V5.7 compiled and updated hardware successfully before V5.8/V5.9 source work.

## 8. APP CONTRACT

- [CURRENT TRUTH] App remains 1.0.0+3 with package com.horizontalzzz.jexfyz.
- [IMPLEMENTED] BLE session readiness requires PROTOCOL=P1 in addition to SYNC_READY/full sync/session readiness.
- [IMPLEMENTED] High-level state-changing BLE confirmation calls are serialized with _commandTransactionQueue.
- [IMPLEMENTED] Peltier ACK failure reason is retained for safety-specific user feedback.
- [IMPLEMENTED] Fan→Peltier popup startup executes ordered confirmation so generic Fan success cannot race the Peltier safety result.
- [IMPLEMENTED] Stale Peltier re-arm notices can be cleared by healthy firmware safety telemetry.
- [IMPLEMENTED] ONLINE_IMAGE_VALIDATE is a known OTA presentation stage.
- [IMPLEMENTED] PHONE:BT heartbeat is coalesced to retain only the newest pending value.
- [IMPLEMENTED] Native notification calls use a dedicated MethodChannel and notification ON is not persisted without native permission.
- [IMPLEMENTED] BLE-support foreground service uses START_NOT_STICKY.
- [FROZEN] Android versionName is exactly Telegram @horizontalzzz; this is intentional and must not be changed.
- [VERIFIED SOURCE] Current heartbeat helper is now top-level in main.dart; the earlier lexical-scope issue was corrected by commit 7d5f0f5adf7fec92b33c92a3b6a6eb58a9ab36a8.

## 9. BLE / P1 CONTRACT

- [FROZEN] BLE device name: JE X FYZ.
- [FROZEN] Service UUID: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001.
- [FROZEN] RX UUID: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001.
- [FROZEN] TX UUID: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001.
- [FROZEN] Transport: flutter_blue_plus.
- [FROZEN] One intended GATT session.
- [FROZEN] Handshake: SYNC → SYNC_READY; PROTOCOL=P1 must be valid before dashboard readiness.
- [FROZEN] Firmware telemetry remains physical-state authority.
- [POLICY] Do not migrate/rewrite BLE without a demonstrated defect.

## 10. OTA PROTECTED CONTRACT

- [PROTECTED] Local OTA.
- [PROTECTED] Online OTA.
- [PROTECTED] OTA priority/lifecycle/state machine.
- [PROTECTED] Wi-Fi ↔ BLE radio handoff.
- [PROTECTED] OTA recovery after failure.
- [PROTECTED] OTA safety output.
- [PROTECTED] OTA timeout/retry.
- [PROTECTED] Image validation.
- [PROTECTED] Firmware OTA URL/path contract.
- [PROTECTED] App OTA version-selection contract.
- [VERIFIED] Current V5.9 work did not intentionally redesign the OTA runtime.
- [FROZEN] Wi-Fi must obtain radio ownership only after BLE/GATT is torn down.
- [FROZEN] Anti-downgrade is OFF.
- [FROZEN] No cryptographic OTA signing or CI-enforced OTA seal is active.
- [USER-CONFIRMED] V5.7 OTA reached physical hardware successfully.
- [UNVERIFIED] Final V5.9 Local OTA and Online OTA runtime regression.

## 11. FIREBASE / OTA METADATA

- [CURRENT] Metadata endpoint: https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json.
- [FROZEN] Firebase firmware linking uses version + URL; SHA is intentionally NOT required.
- [CURRENT] Firmware binary repository: TenzoNkz/JEXFYZ-Firmware.
- [CURRENT] Published binary filename: JEXFYZ.cpp.bin.
- [CURRENT] Approved raw OTA URL: https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin.
- [POLICY] Any valid firmware version DIFFERENT from the device version may be selected; same version requires no update.
- [UNVERIFIED] Published BIN provenance does not independently prove the embedded V5.9 version.

## 12. ANDROID / APP BUILD CONTRACT

- [VERIFIED] Build workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- [VERIFIED] Trigger is GitHub Issues opened/reopened only, gated by repository owner, exact title, and JEXFYZ_BUILD_TRIGGER_V1.
- [FROZEN] Normal push/PR does not generate a release APK.
- [FROZEN] Toolchain: ubuntu-24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- [FROZEN] Output: one obfuscated production-signed JEXFYZ-release.apk via GitHub Release jexfyz-latest.
- [VERIFIED] Android minSdk 24, targetSdk 36, compileSdk 37.
- [FROZEN] versionName Telegram @horizontalzzz.
- [POLICY] App Build is never implied by Firmware execution or chat transfer.

## 13. SOURCE / COMMIT MAP

### Current source blobs
- [VERIFIED] Firmware V5.9: ee5db12f7e897bbc58557d9946af52786cb9f151.
- [VERIFIED] App main: 8a2e97946c4bc4ac2aa3ea09e3a1aca4b15fc6a0.
- [VERIFIED] App settings: f11235bab559b291928550e06984532581ddad6a.
- [VERIFIED] Floating Monitor: 4cd980ea1cc53c663e60267b2c865f3ebb09d91d.
- [VERIFIED] MainActivity: eeb135ef34b1d415196b86e6ffe1ac39d7bda5e2.
- [VERIFIED] Foreground service: 437655add9f12631570614314eef1db1fd9c4005.
- [VERIFIED] App tests: 2da4bff01d3eed749eeba873e9ec2e577c04def9; 29 test/testWidgets declarations detected.
- [VERIFIED] App Build workflow: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- [VERIFIED] Android Gradle: 8f053eeb4c3bdbfade7d04e1e350437d88954876.

### Recent relevant commits
- [COMMITTED] 7d5f0f5adf7fec92b33c92a3b6a6eb58a9ab36a8 — fix: correct Duration named argument.
- [COMMITTED] a75b759d60063bd39b6442ee6d524ac46af7ab30 — fix: complete V5.9 BLE and notification audit.
- [COMMITTED] c4d9d66c37deabd7f9dc0ebe8925096bb6ce8975 — fix: wire V5.9 OTA stage presentation helper.
- [COMMITTED] 8eebf1d1a3426f512cec1d7f1a459c34969cddc5 — fix: consume Peltier re-arm feedback on Touch success.
- [COMMITTED] 6bbc88ff27e4755a67e8658548b43207de07be01 — fix: reset P1 validation on every BLE session.
- [COMMITTED] 1f768d50e5b7f3b484c160289c67f44812f5c045 — fix: release coalesced BLE heartbeat queue safely.
- [COMMITTED] f40688d449a719c6dfc841582ace3150fffbf31f — feat: synchronize firmware safety re-arm for V5.9.

### Historical V5.7 evidence
- [USER-CONFIRMED] V5.7 compiled and was successfully updated to physical hardware.
- [UNVERIFIED] V5.9 compile/BIN/flash/physical validation.

## 14. QC STATUS

### VERIFIED
- [VERIFIED] Current main HEAD: 7d5f0f5adf7fec92b33c92a3b6a6eb58a9ab36a8.
- [VERIFIED] One active .ino exists: JEXFYZ-V5.9.ino.
- [VERIFIED] Firmware static source audit passes: one NTC read, zero executable delay, zero timing while, no RAPID_HOTSIDE_RISE.
- [VERIFIED] App contains P1 readiness gate, serialized ACK transaction queue, Peltier ACK-reason retention, coalesced heartbeat, OTA stage presentation, dedicated notification channel, and NOT_STICKY BLE-support service.
- [VERIFIED] Current App heartbeat helper is top-level; previous scope issue is no longer present in current main.dart.
- [VERIFIED] App Build workflow remains manual issue-triggered.
- [USER-CONFIRMED] V5.7 compile + OTA update to hardware succeeded.

### UNVERIFIED
- [UNVERIFIED] Flutter/Dart analysis and tests for current V5.9-integrated App.
- [UNVERIFIED] V5.9 Arduino compile.
- [UNVERIFIED] V5.9 BIN generation.
- [UNVERIFIED] V5.9 flash/update and image provenance.
- [UNVERIFIED] V5.9 physical control/safety behavior.
- [UNVERIFIED] Local OTA Golden Path on V5.9 image.
- [UNVERIFIED] Online OTA + BLE recovery on V5.9 image.
- [UNVERIFIED] Full App ↔ V5.9 hardware integration.
- [UNVERIFIED] V5.9 App Build/release.
- [UNVERIFIED] Final Release Gate.

## 15. RISKS

- [RISK] V5.9 has not been compiled or validated on physical ESP32-C3 hardware.
- [RISK] Final Local/Online OTA regression for the V5.9 image is still pending.
- [RISK] App current source has static changes but no current toolchain compile/test evidence in this chat.
- [RISK] Some historical project notes still contain older version references; use source + current state, not history.

## 16. OBSOLETE / DO NOT REUSE

- [OBSOLETE] V4.x–V5.8 as active Firmware targets.
- [OBSOLETE] App-side fixed 2-second Fan precharge.
- [OBSOLETE] RAPID_HOTSIDE_RISE and rapid slope protection.
- [OBSOLETE] Concurrent Wi-Fi + BLE radio ownership.
- [OBSOLETE] Anti-downgrade enforcement.
- [OBSOLETE] Automatic App Build on push/PR.
- [OBSOLETE] Temporary CI OTA Security Seal experiment.

## 17. GEMINI EVIDENCE

- [VERIFIED] No authoritative Gemini result text is stored in the current repository snapshot.
- [POLICY] Never invent or promote unrecorded Gemini output to verified evidence.

## 18. FAILED APPROACHES

- [ENVIRONMENT LIMITATION] This chat had tool/orchestration interruptions during an earlier execution attempt.
- [ENVIRONMENT LIMITATION] No local Flutter/Dart/Arduino compiler run was completed here.
- [POLICY] Tool interruption or missing local toolchain is not evidence of a firmware/app runtime defect.

## 19. EXACT QC SEQUENCE

1. Run Flutter/Dart analysis and tests on the current App source.
2. Compile V5.9 with the intended Arduino-ESP32 3.3.7 toolchain.
3. Generate V5.9 BIN and record image provenance.
4. Flash/update ESP32-C3 and verify reported firmware version.
5. Run hardware-only functional QC.
6. Run safety QC, including Peltier re-arm, Adaptive timing, Hotside dwell, Fan/Peltier constraints, and NTC fault behavior.
7. Run Local OTA Golden Path.
8. Run Online OTA and verify Wi-Fi→BLE recovery plus single-radio ownership.
9. Run App ↔ V5.9 integration QC, including P1, ACK confirmation, Peltier NOTIFY/re-arm, heartbeat behavior, and OTA presentation.
10. Run App Build only after explicit @Thinking Build App! or @Thinking Eksekusi & Build App!.
11. Final Release Gate only after all required evidence exists.

## 20. NEW CHAT FIRST RESPONSE

Report only:
- CURRENT PROJECT TRUTH
- REPOSITORY RECONCILIATION
- VERIFIED
- UNVERIFIED
- KNOWN RISKS
- NEXT EXACT QC GATE

Then wait for the user's next command.

## 21. TRANSFER / MEMORY RULES

- [POLICY] On each context-limit event, replace CHAT_TRANSFER.md; do not append duplicate snapshots.
- [POLICY] Keep historical events in CHANGELOG/history.
- [POLICY] Preserve exact source paths, versions, blob SHAs, commit SHAs, run IDs, checksums, and evidence where material.
- [POLICY] Separate CURRENT TRUTH, VERIFIED, UNVERIFIED, HISTORY/OBSOLETE, and CHAT-ONLY state.
- [POLICY] Never convert HYPOTHESIS into VERIFIED without evidence.
- [POLICY] Transfer/save does not change functional source.

## 22. CHAT-ONLY STATE

- [CHAT-ONLY] User reported the previous chat became stuck and then invoked this persistence procedure.
- [CHAT-ONLY] Before this transfer, the user explicitly required OTA Local, OTA Online, and BLE protection to remain safe/frozen through later execution.
- [CHAT-ONLY] No new functional requirement is authorized by this transfer save.

## 23. TRANSFER COMPLETION

- [VERIFIED] Current CHAT_TRANSFER.md was read before replacement.
- [VERIFIED] Current main was reconciled immediately before the write.
- [VERIFIED] Only documentation files are being changed by this operation.
- [VERIFIED] No App Build is being run.
- [VERIFIED] No firmware BIN is being published.
- [NEXT] Continue from Section 19 after the next chat boots.