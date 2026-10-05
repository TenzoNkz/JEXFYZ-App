## 2026-10-06 — OTA SECURITY SEAL
### PERSISTENT
- [IMPLEMENTED] OTA Security Seal added at .github/workflows/ota-security-seal.yml.
- [IMPLEMENTED] Protected seal manifest: firmware/OTA_SECURITY_SEAL.json.
- [IMPLEMENTED] Protected seal lock: firmware/OTA_SECURITY_SEAL.lock.
- [IMPLEMENTED] Protected regions cover Firmware OTA runtime/priority, BLE radio handoff, App any-different-version policy, and Firebase OTA metadata validation.
- [PRESERVED] Anti-downgrade is OFF; any valid firmware version different from the device version remains eligible for OTA.
- [PRESERVED] V5.7 Firmware source and App runtime source were not functionally changed by the seal operation.
- [USER-CONFIRMED] V5.7 OTA update to hardware succeeded before seal installation.

## 2026-10-06 — V5.7 QC EXECUTION RECORD
### PERSISTENT
- [VERIFIED] Functional source authority is now V5.7: firmware/JEXFYZ-V5.7.ino, blob 652e54afdd9c7c347cd82072f573f1729c4b46de.
- [COMMITTED] V5.7 source promotion commit: d2ec5d56383f25a105835b10698f62cf19cbf5df.
- [COMMITTED] V5.7 Touch FSM correction commit: 77591d7406aa8613a3dc9beb33828af5a592d8d5.
- [COMMITTED] V5.6 source retirement commit: 38f8f2738cca18fbac3830d241baa1f5596cc719.
- [IMPLEMENTED] TTP223 uses 30 ms qualification, 60–500 ms tap duration, 800 ms double-tap window from first valid release, second-tap grace, 1 s startup grace, and preserved 3+ tap cancellation.
- [PRESERVED] 1x Voltage, 2x RGB, 5 s long press, and cooperative timing contracts.
- [USER-CONFIRMED] V5.7 Firmware was successfully OTA-updated onto the physical hardware; the device is running V5.7.
- [UNVERIFIED] Full V5.7 functional runtime regression, Local OTA regression, Online OTA/BLE recovery regression, and App integration remain pending.
- [NOT RELEASED] V5.7.

### PERSISTENT
- [VERIFIED] Functional source authority is now V5.6: firmware/JEXFYZ-V5.6.ino, blob f291e05b16235b0e944ea135238335024201355a.
- [COMMITTED] V5.6 source promotion commit: 1c5159652584bea8e26878a61e88f44aff5e3713.
- [COMMITTED] V5.5 source retirement commit: c342e2e25c508e38f5ffa33aeffa05ac149d4eee.
- [IMPLEMENTED] Hotside NTC now uses 16 calibrated ADC samples, trims 4 low + 4 high outliers, and averages the 8 middle samples.
- [PRESERVED] Existing 10K/10K/Beta3950 model, 3.3 V divider reference, 1-second cadence, and safety behavior.
- [PRESERVED] No EMA/Kalman temperature filter, speculative VREF constant, voltage clamp, offset calibration, or blocking timing.
- [UNVERIFIED] Compile, BIN, flash, physical runtime, Local OTA, Online OTA/BLE recovery, and App integration for V5.6.
- [NOT RELEASED] V5.6.

### PERSISTENT
- [VERIFIED] Functional source authority is now V5.5: firmware/JEXFYZ-V5.5.ino, blob 5f72b3557f91c33827ee61f8c2eaf1cab2cfd786.
- [COMMITTED] V5.5 source promotion commit: adfb3e3860f6c7004e577981d668fef46f467d47.
- [COMMITTED] V5.4 source retirement commit: 12973ebace66f660c6c1b0a7a48407e96c02ea08.
- [COMMITTED] V5.5 safety-attempt correction commit: b29d050dcb7deea0ffc5339c76a37bf27a7dacb1.
- [COMMITTED] V5.5 final latch-consistency correction commit: 87c69ce33024e9653efbe9f52cbce84a857efaf4.
- [IMPLEMENTED] Normal Peltier ON/OFF no longer emits green/red Peltier LED feedback.
- [IMPLEMENTED] After Hotside safety-forced Peltier OFF, failed re-arm ON attempts blink red for 1 s.
- [IMPLEMENTED] Successful re-arm ON at Hotside <= hotLimit - 2°C blinks green for 1 s and clears the existing safety latch.
- [IMPLEMENTED] Adaptive activation cannot bypass an active safety latch.
- [PRESERVED] Hotside dwell indicator remains 9 s red + final 1 s green and has LED priority.
- [UNVERIFIED] Compile, BIN, flash, physical runtime, Local OTA, Online OTA/BLE recovery, and App integration for V5.5.
- [NOT RELEASED] V5.5.

### PERSISTENT
- [VERIFIED] Functional source authority is now V5.4: `firmware/JEXFYZ-V5.4.ino`, blob 0b1fd030aad646001b6c2f75bc248caa843b30eb.
- [COMMITTED] Source fix commit: fd883ca695cab2f35014b3cf069fa9454ae6bc89.
- [COMMITTED] V5.3 retirement commit: 65d971616c793e7dd056c6a7896d552516fe626c.
- [IMPLEMENTED] Adaptive HOTSIDE Hotside-limit dwell keeps Fan ON at 100% for the full 10 seconds.
- [IMPLEMENTED] Hotside dwell LED blinks red for 9 seconds and green for the final 1 second.
- [PRESERVED] 10-second thermal dwell duration and downstream safety sequence.
- [PRESERVED] 5-second Adaptive upward dwell, 200 ms selector deadtime, 1 s voltage guard, 5-second Peltier soft-start, OTA/BLE/P1 contracts.
- [UNVERIFIED] Compile, BIN, flash, physical runtime, Local OTA, Online OTA/BLE recovery, and App integration for V5.4.
- [NOT RELEASED] V5.4.

# JE X FYZ — CHAT TRANSFER SNAPSHOT

## 1. TRANSFER METADATA
### PERSISTENT
- [CONFIRMED] Project: JE X FYZ / JE Cooler.
- [VERIFIED] Repository: TenzoNkz/JEXFYZ-App.
- [VERIFIED] Branch: main.
- [VERIFIED] Current post-fix state is V5.7; prior pre-fix transfer HEAD 3a54d83956f357750684a32279952cbd7fb484f8 is historical evidence.
- [VERIFIED] Current phase: V5.7 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED.
- [VERIFIED] Active Firmware: V5.7.
- [VERIFIED] Active Firmware source: firmware/JEXFYZ-V5.7.ino.
- [VERIFIED] Firmware source blob: 652e54afdd9c7c347cd82072f573f1729c4b46de.
- [VERIFIED] App: JE Cooler; header JE X FYZ; package com.horizontalzzz.jexfyz; version 1.0.0+3.
- [VERIFIED] App main source blob: 48406cda017be1ce939ff682497324bf3680a7f3.
- [VERIFIED] App settings source blob: f11235bab559b291928550e06984532581ddad6a.
- [VERIFIED] App regression-test source blob: 1951964af7542324b2ae27b1bd94f84e1c853060.
- [VERIFIED] Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- [VERIFIED] Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- [VERIFIED] V5.7 is the active source; older firmware source revisions are retained only as history, not as active source.
- [CONFIRMED] This transfer is documentation/state persistence only. It does not authorize a new functional source change, Firmware release, or App Build.

## 2. CURRENT TASK
### PERSISTENT
- [CONFIRMED] The prior functional requirement was that both Adaptive modes wait 5 seconds whenever Adaptive voltage increases.
- [IMPLEMENTED] Current QC fix: Adaptive Hotside safety keeps Fan ON at 100% during the full 10-second thermal dwell, with LED red blink for 9 seconds followed by green blink for the final 1 second.
- [IMPLEMENTED] HOTSIDE and HOTSIDE_BATTERY both enforce the 5-second cooperative dwell after each completed upward voltage step.
- [IMPLEMENTED] Adaptive startup from the mandatory safe 5V state starts the same 5-second upward dwell before the first increase.
- [IMPLEMENTED] Downward Adaptive voltage changes remain immediate.
- [IMPLEMENTED] Hotside fallback keeps the same cooperative upward-rise timing.
### CHAT-ONLY
- [CONFIRMED] The user first asked whether the 5-second rise had already been executed, then clarified that “all Adaptive modes” means both Adaptive profiles, then issued @Thinking Eksekusi Full!.

## 3. CURRENT WORKFLOW
### PERSISTENT
- [VERIFIED] App Build is manual-by-issue-trigger only.
- [VERIFIED] Issue title: JE X FYZ — BUILD APP TRIGGER.
- [VERIFIED] Required body token: JEXFYZ_BUILD_TRIGGER_V1.
- [VERIFIED] Trigger is restricted by repository owner, exact issue title, and required token; normal push/PR does not trigger the App Build.
- [VERIFIED] Toolchain configured by workflow: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, ubuntu-24.04.
- [VERIFIED] Release build is obfuscated and production-signed.
- [VERIFIED] APK delivery is through GitHub Release, not Actions artifact storage.
- [VERIFIED] Workflow publishes exactly one release APK named JEXFYZ-release.apk.
- [CONFIRMED] Build App is a separate explicit operation and is not part of Firmware execution or chat-transfer persistence.

## 4. USER REQUIREMENTS
### PERSISTENT
- [USER REQUIREMENT] Firmware versions progress V4.6 → V4.7 → V4.8 → V4.9 → V5.0 → V5.1 → V5.2 → V5.3; every functional Firmware source change bumps the version.
- [USER REQUIREMENT] Both Adaptive profiles must use a 5-second dwell after an upward voltage change.
- [USER REQUIREMENT] The 5-second dwell is for increases only; downward changes remain immediate.
- [USER REQUIREMENT] No blocking timing implementation; preserve cooperative millis()-based timing.
- [USER REQUIREMENT] ESP32-C3 Super Mini single-radio constraint: Wi-Fi and BLE must not own the radio concurrently.
- [USER REQUIREMENT] BLE should remain available after OTA/Wi-Fi shutdown and recover without requiring a device restart for normal disconnect/reconnect.
- [USER REQUIREMENT] App Build remains manual and separate from Firmware execution.
- [USER REQUIREMENT] No SHA is required for Firebase firmware metadata; version + raw BIN URL is the linkage contract.
- [USER REQUIREMENT] Peltier safety, Hotside safety, App Notify, BLE/P1 protocol, OTA, and hardware GPIO contracts already established remain preserved unless QC demonstrates a real defect.

## 5. FROZEN / ACCEPTED DECISIONS
### PERSISTENT
- [FROZEN] Firmware is the physical-state and safety authority; App telemetry reconciles to Firmware.
- [FROZEN] GPIO: NTC 0, Touch 1, 12V selector 3, 9V selector 4, Peltier 5, Fan 6, WS2812 7.
- [FROZEN] Fan PWM: 25 kHz, 8-bit, 50–100%; hardware Touch cooling ON forces Fan 100%.
- [FROZEN] Peltier PWM: 20 kHz; OFF→ON uses 5-second cooperative soft-start.
- [FROZEN] Voltage selector deadtime: 200 ms; voltage guard: 1 s.
- [FROZEN] Hotside NTC sampled every 1 s; limit range 40–50°C; default 45°C.
- [FROZEN] NTC fault: Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- [FROZEN] Rapid Hotside-rise protection is removed; RAPID_HOTSIDE_RISE is obsolete and absent.
- [FROZEN] Hotside safety: Adaptive 12V hold 10 s then 9V; Adaptive 9V hold 10 s then 5V; 5V is terminal safety state and requires manual Peltier re-arm.
- [FROZEN] Manual Hotside protection preserves the selected voltage.
- [FROZEN] Manual/Touch Peltier restart safety latch requires Hotside <= hotLimit - 2°C.
- [FROZEN] Peltier LED feedback is safety-rearm-only: failed ON attempt while the Hotside safety latch is active = red blink 1 s; successful re-arm ON at hotLimit - 2°C = green blink 1 s; normal ON/OFF has no Peltier LED.
- [FROZEN] Hotside NTC filtering: 16 calibrated ADC samples per 1-second period, discard 4 lowest + 4 highest, average 8 middle samples.
- [FROZEN] TTP223 touch recognition: 30 ms qualification, 60–500 ms tap duration, 800 ms double-tap window, second-tap grace, 1 s startup grace.
- [FROZEN] App Peltier Safety popup queues FAN:ON then PELTIER:ON back-to-back; Firmware owns the 5-second Peltier soft-start.
- [FROZEN] App Fan Speed display at Adaptive + 12V is 100%; Manual + 12V shows configured speed; Adaptive speed control remains locked.
- [FROZEN] Local OTA uses Golden/Protected path; Online OTA explicitly disconnects GATT before Wi-Fi ownership.
- [FROZEN] Firebase metadata uses firmware version + URL only; approved BIN host is raw GitHub under the JEXFYZ-Firmware repository.
- [FROZEN] Timing rules: no executable delay(); no timing while() loops.

## 6. REJECTED / OBSOLETE DECISIONS
### PERSISTENT
- [OBSOLETE] Firmware V5.2 source file firmware/JEXFYZ-V5.2.ino is retired; active source is V5.3.
- [OBSOLETE] App-side 2-second Fan precharge before Peltier ON.
- [OBSOLETE] Rapid Hotside-rise/slope protection and RAPID_HOTSIDE_RISE notification.
- [OBSOLETE] Forcing Peltier OFF merely because a normal voltage selector transition begins; Peltier logical/PWM state is preserved through selector transitions.
- [REJECTED] Treating the 5-second Adaptive dwell as applying to only one Adaptive profile.
- [REJECTED] Running App Build implicitly as part of Firmware implementation.
- [REJECTED] Using concurrent Wi-Fi + BLE on the ESP32-C3 single-radio device.

## 7. APP STATE
### PERSISTENT
- [VERIFIED] App version 1.0.0+3; package com.horizontalzzz.jexfyz.
- [VERIFIED] App main source blob 48406cda017be1ce939ff682497324bf3680a7f3.
- [VERIFIED] App settings blob f11235bab559b291928550e06984532581ddad6a.
- [VERIFIED] Test blob 1951964af7542324b2ae27b1bd94f84e1c853060.
- [IMPLEMENTED] Safety Notify uses dynamic re-arm threshold hotLimit - 2°C.
- [IMPLEMENTED] Touch ON/OFF ACKs are treated as valid outcomes; unsolicited Touch cooling success is surfaced cleanly.
- [IMPLEMENTED] Peltier failure notices avoid duplicating a firmware-provided safety reason.
- [IMPLEMENTED] Retired RAPID_HOTSIDE_RISE presentation was removed.
- [IMPLEMENTED] Home Fan Speed presentation is corrected for Adaptive + 12V.
- [IMPLEMENTED] Peltier Safety popup sends FAN:ON then PELTIER:ON without an App-side confirmation delay.
- [FROZEN] Firmware telemetry is authoritative; BLE writes are not treated as proof of physical state change.
- [UNVERIFIED] Current App source changes have not been rebuilt/tested in this session; the test source contains regression coverage, but execution of flutter test is not available in this environment.

## 8. FIRMWARE STATE
### PERSISTENT
- [VERIFIED] Version V5.4.
- [VERIFIED] Active source: firmware/JEXFYZ-V5.4.ino.
- [VERIFIED] Blob: 0b1fd030aad646001b6c2f75bc248caa843b30eb.
- [IMPLEMENTED] Hotside 10-second dwell Fan behavior is ON at 100%; LED is red 9 seconds then green 1 second.
- [IMPLEMENTED] Both HOTSIDE and HOTSIDE_BATTERY Adaptive profiles share adaptiveHotsideRiseDueMs as the cooperative 5-second upward-rise timer.
- [IMPLEMENTED] completeVoltageTransition() starts a fresh 5-second rise dwell after an Adaptive/Battery upward selector transition physically completes.
- [IMPLEMENTED] activateAdaptiveAfterSafeFiveVolt() starts the same 5-second dwell after Adaptive reaches safe 5V.
- [IMPLEMENTED] processAdaptiveHotTimer() uses the 5-second dwell for HOTSIDE Adaptive upward increases.
- [IMPLEMENTED] evaluateAdaptiveBattery() uses the same 5-second dwell for HOTSIDE_BATTERY upward increases; downward Battery-driven changes clear the rise timer and remain immediate.
- [IMPLEMENTED] Failed upward requests re-arm a new 5-second wait and report ADAPTIVE_RISE_WAIT.
- [VERIFIED] Static source audit: 4,778 lines; executable delay() count 0; timing while() count 0; RAPID_HOTSIDE_RISE count 0.
- [VERIFIED] Peltier soft-start remains 5,000 ms; Hotside thermal dwell remains 10,000 ms; Peltier safety re-arm feedback duration remains 1,000 ms; NTC sample cadence remains 1,000 ms.
- [UNVERIFIED] Arduino compile, BIN generation, ESP32-C3 flash, runtime Adaptive timing, Hotside safety runtime, and OTA runtime for V5.3.

## 9. ANDROID / BLE / OTA / FIREBASE / CI
### PERSISTENT
- [VERIFIED] BLE service UUID: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001.
- [VERIFIED] BLE RX UUID: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001.
- [VERIFIED] BLE TX UUID: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001.
- [VERIFIED] App uses flutter_blue_plus for BLE and maintains one BLE/GATT session; Floating Monitor does not create a second BLE client.
- [VERIFIED] Android host package: com.horizontalzzz.jexfyz; MainActivity uses compileSdk 37, targetSdk 36, minSdk 24.
- [VERIFIED] Firebase firmware metadata URL: https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json.
- [VERIFIED] App source references Firebase App Check / Android Play Integrity and flutter_secure_storage.
- [VERIFIED] Firmware OTA allowlist requires the raw GitHub host under TenzoNkz/JEXFYZ-Firmware and .bin endpoint; version + URL is sufficient and SHA is intentionally not part of the metadata contract.
- [FROZEN] Online OTA flow explicitly tears down GATT/BLE before Wi-Fi handoff because ESP32-C3 has one radio antenna.
- [VERIFIED] CI workflow path: .github/workflows/jexfyz-app-build-trigger.yml; normal pushes/PRs do not run the release build.

## 10. SOURCE CHANGES
### PERSISTENT
- [COMMITTED] V5.3 feature commit: 85bf8acf79fd91f0d3bbbe2440bec8bab73774da — feat: add 5s adaptive voltage rise dwell.
- [COMMITTED] V5.2 source retirement commit: 90f459ac4720a3ec509543bcc4e83bde96e3d910 — chore: retire V5.2 firmware source.
- [COMMITTED] Subsequent commits through current pre-save HEAD are documentation-only with respect to the source tree; compare 90f459... → 3a54d... shows only PROJECT_STATE.md and HANDOVER.md as current-state documentation changes in the latest reconciliation commits, while the prior V5.3 history is also reflected in APP_NOTES.md, FIRMWARE_NOTES.md, firmware/FIRMWARE_ANALYSIS.md, and CHANGELOG.md.
- [IMPLEMENTED] No functional App source change was made for V5.3; the 5-second Adaptive dwell is firmware-only.

## 11. COMMITS / SHAs
### PERSISTENT
- [VERIFIED] Current pre-save main HEAD: 3a54d83956f357750684a32279952cbd7fb484f8 — docs: reconcile V5.3 handover for chat transfer.
- [COMMITTED] 50a556c7cb6b736902dc3007da0ffa070f687171 — docs: reconcile V5.3 project state for chat transfer.
- [COMMITTED] 3a54d83956f357750684a32279952cbd7fb484f8 — docs: reconcile V5.3 handover for chat transfer.
- [COMMITTED] 85bf8acf79fd91f0d3bbbe2440bec8bab73774da — V5.3 functional Adaptive rise dwell.
- [COMMITTED] 90f459ac4720a3ec509543bcc4e83bde96e3d910 — retire V5.2 source.
- [COMMITTED] 90f459... → 3a54... includes eight documentation-only commits after source retirement: e27feb83efb25f714d78e27ecd3a9268bd442f8b, cc2f3f17b2e562054f9d29b3feb88bfd1e62735a, 28aa4d724d42b024744fd804038543a6b8c14a0d, d3daf1c30d7dcbb76b7130372f685af1e80575af, b3a690f7256c69dd0b96166250f04483a7959186, c060645ac07f37e8590a8ec7f52452b4e959d0f8, fadbd022ebf774b15248e017741b8ced8a0ea117, 5afa578b2362087c59e7f1ef8723bb108e950864; plus the current transfer reconciliation commits 50a556... and 3a54....
- [OPEN QUESTION] A second historical Build #9 record exists in APP_NOTES with run 37268139253; it is not treated as independently re-verified here.

## 12. BUILD STATE
### PERSISTENT
- [VERIFIED] Latest build evidence retained in PROJECT_STATE: workflow run 37261171475, GitHub Release jexfyz-latest, APK JEXFYZ-release.apk, size 54,327,520 bytes, SHA-256 b8045d0b6fa6d05b421bd6b1c0318d4ee4529734d7b471534700f95676200888.
- [DOCUMENTED / UNRESOLVED] APP_NOTES additionally records Build #9 run 37268139253 with APK digest 64f9be08a28007e42a27dfd7b0459857a06d7146200113a405638ef8f0353058 and the same release asset name/size.
- [UNVERIFIED] Current V5.4 has no verified App Build associated with it.
- [UNVERIFIED] Current V5.4 Firmware has no verified compile/BIN/flash/OTA result.
- [CONFIRMED] App Build is not to be triggered by this transfer.

## 13. BUGS / SYMPTOMS
### PERSISTENT
- [RESOLVED] Prior ambiguity: whether the 5-second Adaptive rise dwell applied to both profiles. Current V5.3 source explicitly applies it to HOTSIDE and HOTSIDE_BATTERY.
- [RESOLVED] Adaptive + 12V Home Fan Speed displayed --; App now displays 100%.
- [RESOLVED] App Safety popup previously waited for Fan telemetry before Peltier command; it now queues FAN:ON then PELTIER:ON directly.
- [RESOLVED] Peltier restart safety notification previously lacked the exact dynamic re-arm threshold; App now reports hotLimit - 2°C.
- [RESOLVED] Touch OFF success was previously at risk of being interpreted as a safety error; Firmware now emits explicit OFF acknowledgement and App classifies OFF as success.
- [OPEN] V5.4 upward-rise timing and all current safety/OTA behavior still require physical QC.

## 14. VERIFIED ROOT CAUSES
### PERSISTENT
- [CONFIRMED] The latest five-second Adaptive requirement is a firmware scheduling/state-machine requirement, not an App UI delay.
- [VERIFIED] HOTSIDE upward timing is handled in processAdaptiveHotTimer().
- [VERIFIED] HOTSIDE_BATTERY upward timing is handled in evaluateAdaptiveBattery().
- [VERIFIED] Both paths share adaptiveHotsideRiseDueMs and reset it on downward changes or when no upward target remains.
- [VERIFIED] Post-transition re-arming is done only for actual upward Adaptive/Battery selector completions, so the dwell is tied to the physical selector completion rather than command enqueue time.

## 15. HYPOTHESES / LIKELY CAUSES
### PERSISTENT
- [HYPOTHESIS] Any future observed Adaptive step earlier than 5 seconds would most likely be caused by runtime timing/telemetry conditions around selector completion or by a not-yet-compiled/flashed V5.4 binary, not by the current source logic shown above.
- [UNVERIFIED] Physical thermal behavior can still differ from software intent because NTC calibration, MOSFET/optocoupler timing, wiring, supply sag, and real thermal load have not been revalidated for V5.3.

## 16. GEMINI RESULTS
### PERSISTENT
- [UNVERIFIED] No authoritative Gemini response/result text is retained in the currently available context for this transfer; prior internal discussion notes are not treated as Gemini evidence.
- [POLICY] Do not invent Gemini findings. Any future Gemini result must be copied as evidence and separated from local reasoning.

## 17. FAILED APPROACHES / DEAD ENDS
### PERSISTENT / CHAT HISTORY
- [CONFIRMED] Direct local repository clone attempts failed because the container could not resolve github.com; these failures do not indicate a repository problem.
- [CONFIRMED] Local Flutter/Dart/Arduino CLI/PlatformIO executables were unavailable in the prior build environment, so local compile validation could not be completed there.
- [CONFIRMED] GitHub Actions/Release pages could not be independently re-fetched in the current session through the available web path; cached repository documentation was therefore treated conservatively.
- [OBSOLETE] Earlier V4.8/V5.2 implementation paths are historical and must not be applied over V5.3.

## 18. KNOWN RISKS
### PERSISTENT
- [UNVERIFIED] V5.4 compile/BIN/flash/OTA.
- [UNVERIFIED] Physical Adaptive 5-second dwell on real hardware, including both profiles and step transitions, plus the V5.4 Hotside Fan/LED safety correction.
- [UNVERIFIED] Hotside safety sequence and 2°C re-arm behavior after V5.4 flash.
- [UNVERIFIED] Online OTA Wi-Fi/BLE teardown and recovery after V5.4 flash.
- [OPEN] Historical App Build metadata conflict remains unresolved.
- [RISK] Any release claim would be premature until QC gates are completed.

## 19. UNRESOLVED QUESTIONS
### PERSISTENT
- [OPEN QUESTION] Has V5.4 been compiled successfully with the intended Arduino-ESP32 3.3.7 environment?
- [OPEN QUESTION] Has V5.4 BIN been generated and flashed/OTA-updated onto the ESP32-C3?
- [OPEN QUESTION] On hardware, does each Adaptive upward change occur only after the full 5-second dwell and does Hotside dwell maintain Fan 100% with 9 s red + 1 s green LED?
- [OPEN QUESTION] Which historical App Build run, 37261171475 or 37268139253, should be treated as the canonical latest verified release record?
- [OPEN QUESTION] Has current App ↔ V5.4 integration been revalidated after V5.4?

## 20. CHAT-ONLY INFORMATION
### CHAT-ONLY
- [CONFIRMED] The user clarified that both Adaptive profiles must wait 5 seconds on voltage increases, then authorized this V5.4 QC fix execution for Hotside Fan/LED dwell behavior.
- [CONFIRMED] This recap request explicitly forbids functional source changes, release, and App Build.
- [CONFIRMED] The next chat must start from repository truth, not from the older V4.6/V5.2 transfer snapshot.
- [CHAT-ONLY] The command protocol used by the user in this project: @Thinking Diskusi!, @Thinking Tanya Gemini!, @Thinking Eksekusi!, @Thinking Eksekusi Full!, @Thinking Build App!, and @Thinking Eksekusi & Build App!.

## 21. EXACT NEXT ACTION
### PERSISTENT
> **Compile V5.7 → generate BIN → complete hardware/safety QC → regression-check Local OTA + Online OTA/BLE recovery → Build App separately → App ↔ V5.7 integration QC → Release Gate.**
- [CONFIRMED] Do not run App Build merely because the chat transfers.

## 22. REQUIRED FIRST ACTION IN NEW CHAT
### PERSISTENT
> **Read CHAT_TRANSFER.md first, then reconcile current main HEAD/source/workflow against PROJECT_STATE.md, HANDOVER.md, FIRMWARE_NOTES.md, firmware/FIRMWARE_ANALYSIS.md, APP_NOTES.md, and CHANGELOG.md. Treat firmware/JEXFYZ-V5.7.ino as the active Firmware source and V5.7 as the current version. OTA Security Seal is active; anti-downgrade remains OFF.**
- [CONFIRMED] Do not modify functional source on the first action unless a separately issued command authorizes it.
- [CONFIRMED] Continue from QC state; V5.7 is not released.

## 23. AUTHORITY / RECONCILIATION NOTES
### PERSISTENT
- [AUTHORITY] Active Firmware source authority: JEXFYZ-App/firmware/firmware source tree; the separate TenzoNkz/JEXFYZ-Firmware repository is treated as binary/published-output storage, not as the source of truth.
- [AUTHORITY] App source authority: current main branch under lib/.
- [AUTHORITY] CI authority: .github/workflows/jexfyz-app-build-trigger.yml for App release, plus .github/workflows/ota-security-seal.yml for OTA integrity.
- [RECONCILED] Current App main blob in PROJECT_STATE was previously stale (93ed2e3e...) and is now corrected to 48406cda...; this was documentation-only.
- [RECONCILED] Current phase/active Firmware records are aligned to V5.7.
- [RECONCILED] Current Handover includes V5.7 and the OTA Security Seal.
- [VERIFIED] Current main HEAD has advanced beyond the historical 3a54... transfer snapshot; OTA Security Seal renewal is committed on main.

## 24. TRANSFER COMPLETION
### PERSISTENT
- [CONFIRMED] Existing CHAT_TRANSFER.md was read before replacement.
- [CONFIRMED] Current project/docs/source/workflow were reconciled against repository HEAD before save.
- [COMPLETED BY THIS OPERATION] This file is being updated with the current V5.7 state and OTA Security Seal record.
- [REQUIRED AFTER WRITE] Re-read CHAT_TRANSFER.md, verify its saved blob/commit and then verify current main HEAD and active source/workflow.
