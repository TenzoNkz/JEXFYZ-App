# JE X FYZ — LATEST CHAT TRANSFER

## 1. TRANSFER METADATA
- [VERIFIED] Repository: TenzoNkz/JEXFYZ-App
- [VERIFIED] Branch: main
- [VERIFIED] Pre-save HEAD: e36acabe61cbec5b906c60947dfa29b363d25cfe
- [VERIFIED] Current phase: V4.6 — CODE COMPLETE → QC / PRE-RELEASE → NOT RELEASED
- [VERIFIED] Active firmware: V4.6
- [VERIFIED] Active firmware source: firmware/JEXFYZ-V4.6.ino
- [VERIFIED] Firmware source blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- [VERIFIED] Firmware source-change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d
- [VERIFIED] App: JE Cooler / header JE X FYZ / package com.horizontalzzz.jexfyz / version 1.0.0+3
- [VERIFIED] App main/settings/test blobs: f762f6d1cdd1351e57e7d93665ff2f5898769b42 / f11235bab559b291928550e06984532581ddad6a / aa86778beb8fcc3ce6a12454f6354f96ec99a160
- [VERIFIED] Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- [VERIFIED] Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- [VERIFIED] No reusable App Build engine is active.
- [VERIFIED] This snapshot is a chat-limit persistence operation; it does not authorize release or App Build.

## 2. CURRENT TASK
- [CONFIRMED] V4.6 is code-complete and the project is in QC / PRE-RELEASE.
- [CONFIRMED] Release has not been declared.
- [CONFIRMED] This chat-limit recap must persist the complete current state before chat transfer.
- [CONFIRMED] No functional source, release, or App Build is authorized by this recap.

## 3. CURRENT WORKFLOW
- [VERIFIED] App Build is manual-by-issue-trigger only.
- [VERIFIED] Issue title: JE X FYZ — BUILD APP TRIGGER.
- [VERIFIED] Required body token: JEXFYZ_BUILD_TRIGGER_V1.
- [VERIFIED] Trigger accepts issue opened/reopened only and is gated by repository owner, exact title, and token.
- [VERIFIED] Normal push/PR does not trigger the App Build workflow.
- [VERIFIED] Toolchain: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, ubuntu-24.04.
- [VERIFIED] Release build is obfuscated and production-signed.
- [VERIFIED] Exactly one APK is delivered as JEXFYZ-release.apk to GitHub Release tag jexfyz-latest.
- [VERIFIED] Current delivery does not use Actions artifacts.
- [VERIFIED] Latest downloadable App Build: workflow run 37245703677.
- [VERIFIED] Latest APK size 54,327,520 bytes; SHA-256 a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2.
- [VERIFIED] Latest App Build source commit: fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- [VERIFIED] App Build is separate from Firmware compile/flash/runtime QC.

## 4. USER REQUIREMENTS
- [USER REQUIREMENT] Preserve BOOT_AP_HARD_LIMIT at 60 seconds.
- [USER REQUIREMENT] Hardware single tap must cycle 5V → 9V → 12V → 9V → 5V → ...
- [USER REQUIREMENT] Hardware-only Fan ON must run at 100%.
- [USER REQUIREMENT] Hardware-only Peltier ON must use the existing 5-second soft-start, then 100%.
- [USER REQUIREMENT] Remove Rapid Hotside-rise protection.
- [USER REQUIREMENT] Preserve normal Hotside temperature-limit protection.
- [USER REQUIREMENT] Preserve all other behavior unless a QC finding proves a defect.
- [USER REQUIREMENT] During QC, source is frozen; do not add features or refactor without a demonstrated QC need.

## 5. FROZEN / ACCEPTED DECISIONS
- [CONFIRMED] Firmware V4.6 is the active version.
- [CONFIRMED] GPIO mapping: NTC 0, Touch 1, 12V 3, 9V 4, Peltier 5, Fan 6, WS2812 7.
- [CONFIRMED] Fan PWM is 25 kHz, 8-bit, 50–100% for App-controlled behavior; hardware touch ON forces 100%.
- [CONFIRMED] Peltier PWM is 20 kHz, 8-bit; OFF→ON starts the 5-second soft-start.
- [CONFIRMED] Voltage selector deadtime is 200 ms; shared voltage guard is 1 s.
- [CONFIRMED] Hotside NTC is sampled every 1 s and remains the universal thermal safety input.
- [CONFIRMED] Hotside limit is 40–50°C, default 45°C.
- [CONFIRMED] NTC fault forces Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- [CONFIRMED] Local OTA is Golden/Protected.
- [CONFIRMED] ESP32-C3 Wi-Fi/BLE single-radio ownership remains mutually exclusive.
- [CONFIRMED] BLE Service/RX/TX UUIDs and P1 contract are frozen.
- [CONFIRMED] App source/UI and current App CI workflow are frozen during QC unless integration QC demonstrates a defect.
- [CONFIRMED] No executable delay() and no timing while() loops.
- [CONFIRMED] Functional firmware changes increment FW_VERSION and keep .ino filename aligned.

## 6. REJECTED / OBSOLETE DECISIONS
- [OBSOLETE] Rapid Hotside-rise protection is removed in V4.6.
- [OBSOLETE] Legacy one-way hardware voltage sequence was replaced by the bounce sequence.
- [OBSOLETE] Legacy Actions-artifact APK delivery is not used by the current workflow.
- [OBSOLETE] Older V4.3/V4.4 Online OTA variants are historical; V4.5/V4.6 source is current.
- [REJECTED] Feature development during QC unless justified by a demonstrated QC failure.
- [REJECTED] Treating static audit or App Build as hardware/runtime validation.
- [REJECTED] Treating Build #53 as a successful downloadable release.

## 7. APP STATE
- [VERIFIED] App name: JE Cooler.
- [VERIFIED] In-app header: JE X FYZ.
- [VERIFIED] Package: com.horizontalzzz.jexfyz.
- [VERIFIED] Version/build: 1.0.0+3.
- [VERIFIED] flutter_blue_plus is the BLE transport.
- [VERIFIED] P1 SYNC/SYNC_READY remains the usable-session gate.
- [VERIFIED] Firmware telemetry is authoritative for physical/safety state.
- [IMPLEMENTED][COMMITTED] Online OTA recovery is explicit and does not depend on passive Auto Connect.
- [IMPLEMENTED][COMMITTED] Expected Online OTA GATT disconnect is treated as an OTA lifecycle event, not a normal Bluetooth error.
- [IMPLEMENTED][COMMITTED] App surfaces the one-shot OTA result after reconnect/P1 sync.
- [VERIFIED] V4.6 firmware-only change did not change App source or command contract.
- [UNVERIFIED] Physical App ↔ V4.6 integration.

## 8. FIRMWARE STATE
- [VERIFIED] Active source: firmware/JEXFYZ-V4.6.ino.
- [VERIFIED] Source blob: cd2ebd7395343f64b824e74c1370b04cea6835ab.
- [IMPLEMENTED][COMMITTED] V4.5 → V4.6 version promotion for functional hardware changes.
- [IMPLEMENTED][COMMITTED] Hardware single-tap voltage bounce sequence.
- [IMPLEMENTED][COMMITTED] Hardware cooling ON via long press forces Fan PWM 100%.
- [IMPLEMENTED][COMMITTED] Peltier OFF→ON retains 5-second soft-start, then 100%.
- [IMPLEMENTED][COMMITTED] Rapid Hotside-rise threshold/event/history removed.
- [PRESERVED] Normal Hotside temperature-limit safety.
- [PRESERVED] 60 s BOOT_AP hard limit.
- [PRESERVED] Local OTA, Online OTA, BLE/P1, Adaptive, RGB, telemetry, and radio ownership architecture.
- [VERIFIED] Only one active versioned .ino exists under firmware/: JEXFYZ-V4.6.ino.

## 9. ANDROID / BLE / OTA / FIREBASE / CI
- [VERIFIED] BLE UUIDs:
  - Service: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001
  - RX: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001
  - TX: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001
- [VERIFIED] Online OTA flow is GATT disconnect → BLE state clear/advertising stop → Wi-Fi ownership → bounded transfer/finalize → restart → BLE recovery → P1 sync.
- [VERIFIED] Local OTA uses the boot SoftAP and remains protected.
- [CONFIRMED] Firebase supplies firmware release metadata; GitHub hosts the fixed firmware BIN URL.
- [CONFIRMED] Product firmware linkage uses version + link, not SHA.
- [VERIFIED] Wi-Fi credentials use flutter_secure_storage.
- [VERIFIED] Production signing certificate SHA-256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- [VERIFIED] App Build workflow is the direct Release workflow described above.

## 10. SOURCE CHANGES
- [COMMITTED] Firmware source changed from V4.5 to V4.6.
- [COMMITTED] firmware/JEXFYZ-V4.5.ino was promoted/renamed to firmware/JEXFYZ-V4.6.ino.
- [COMMITTED] Hardware touch sequence now uses 5V → 9V → 12V → 9V → 5V → ...
- [COMMITTED] Hardware long-press ON forces fanPwm = 100.
- [COMMITTED] Peltier OFF→ON soft-start path remains PELTIER_SOFT_START_MS = 5000.
- [COMMITTED] Rapid-rise protection constant, event flag, prior-temperature history, slope calculation, and safety branch were removed.
- [COMMITTED] No App functional source change was made.
- [COMMITTED] QC transition changes are documentation-only.

## 11. COMMITS / SHAs
- [COMMITTED] Firmware V4.6 source-change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d.
- [VERIFIED] Firmware source blob: cd2ebd7395343f64b824e74c1370b04cea6835ab.
- [VERIFIED] App main/settings/test blobs: f762f6d1cdd1351e57e7d93665ff2f5898769b42 / f11235bab559b291928550e06984532581ddad6a / aa86778beb8fcc3ce6a12454f6354f96ec99a160.
- [VERIFIED] Active App Build workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- [VERIFIED] QC-phase documentation sync was committed before this transfer; this snapshot replaces the previous transfer snapshot.

## 12. BUILD STATE
### Latest verified App Build
- [BUILT][VERIFIED] Run: 37245703677.
- [VERIFIED] Source commit: fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- [VERIFIED] Audit, dependencies, Dart analysis, Flutter tests, obfuscated APK compilation, production signing, and Release publication passed.
- [VERIFIED] Exactly one Release asset: JEXFYZ-release.apk.
- [VERIFIED] Asset ID: 610989112.
- [VERIFIED] Size: 54,327,520 bytes.
- [VERIFIED] SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- [VERIFIED] No Actions artifact was created.

### Historical build evidence
- [BUILT][VERIFIED] Build #50 / run 36996987220: successful App build with APK and symbol artifacts.
- [BUILT][FAILED] Build #51 / run 37196189548: Dart parser failure caused by missing _startCloudOta closing brace; fixed in ea5261230245fc86061cdf85f65ccd0208e607d3.
- [BUILT][FAILED] Build #52 / run 37196349621: signing verification shell failed due pipefail/SIGPIPE; fixed in e33141efd47b8f1ca025e832097e1106d9119b65.
- [BUILT][FAILED] Build #53 / run 37196778932: audit/analysis/tests/release/signing passed, but Actions artifact creation was blocked by quota.
- [BUILT][BLOCKED] Historical single-workflow run 37199918015: build/signing gates passed, artifact creation blocked by quota.
- [BUILT][VERIFIED] Release-delivery run 37201925842: successful GitHub Release delivery.
- [VERIFIED] Current workflow no longer depends on Actions artifact quota.

## 13. BUGS / SYMPTOMS
- [OPEN QUESTION] No new V4.6 runtime QC bug has been established.
- [CONFIRMED] Historical App Build #51 had cascading analyzer errors from the missing _startCloudOta closing brace.
- [CONFIRMED] Historical App Build #52 failed in shell signing-output verification despite correct signing identity.
- [CONFIRMED] Historical App Build #53 failed only at Actions artifact creation because storage quota was exhausted.
- [CONFIRMED] Historical V4.4 Online OTA GATT disconnect ordering issue was corrected in V4.5.
- [OPEN QUESTION] V4.6 physical behavior and OTA behavior have not yet been measured.

## 14. VERIFIED ROOT CAUSES
- [VERIFIED] Build #51 root cause: missing _startCloudOta closing brace.
- [VERIFIED] Build #52 root cause: Bash pipefail + grep pipeline caused SIGPIPE.
- [VERIFIED] Build #53 root cause: GitHub Actions artifact storage quota exhaustion.
- [VERIFIED] V4.4 GATT disconnect issue: BLE logical connection state was cleared before the explicit GATT disconnect guard; V4.5 corrected the ordering.
- [VERIFIED] V4.6 source audit confirms rapid-rise protection identifiers are absent.

## 15. HYPOTHESES / LIKELY CAUSES
- [HYPOTHESIS] None accepted as a V4.6 QC fact.
- [HYPOTHESIS] Hardware/runtime issues, if found, must be established by measurement/reproduction and not inferred from source alone.

## 16. GEMINI RESULTS
- [VERIFIED] No current Gemini result is being used as release evidence.
- [OPEN QUESTION] Older inaccessible Gemini discussion, if any, is not current evidence unless reproduced and reconciled.

## 17. FAILED APPROACHES / DEAD ENDS
- [OBSOLETE] Multi-artifact App delivery with Actions artifacts is no longer the delivery mechanism.
- [OBSOLETE] Legacy .github/workflows/jexfyz-build.yml and reusable-engine variants are historical; current source has one direct workflow file.
- [OBSOLETE] V3.3 yellow Online OTA progress layer.
- [OBSOLETE] V4.1/V4.2 Online OTA retry variants.
- [FAILED] Build #51 parser defect.
- [FAILED] Build #52 signing shell pipefail defect.
- [BLOCKED] Build #53 artifact quota.
- [FAILED APPROACH] Changing workflow triggers just to obtain an App Build is prohibited.

## 18. KNOWN RISKS
- [UNVERIFIED] V4.6 compile/BIN/flash has not been completed.
- [UNVERIFIED] Physical touch voltage sequence has not been tested.
- [UNVERIFIED] Hardware Fan 100% has not been physically measured.
- [UNVERIFIED] Peltier 5-second soft-start has not been physically measured.
- [UNVERIFIED] Hotside/NTC safety runtime has not been tested on V4.6.
- [UNVERIFIED] Local OTA on V4.6 has not been physically validated.
- [UNVERIFIED] Online OTA + active GATT disconnect/BLE recovery on V4.6 has not been physically validated.
- [UNVERIFIED] App ↔ V4.6 physical integration has not been validated.
- [KNOWN RISK] Latest verified App APK predates V4.6 firmware changes; it is not evidence of V4.6 runtime compatibility.
- [KNOWN RISK] V4.6 has not yet passed the final Release Gate.

## 19. UNRESOLVED QUESTIONS
- [OPEN QUESTION] Does V4.6 compile cleanly on ArduinoDroid with Arduino-ESP32 Core 3.3.7?
- [OPEN QUESTION] Does generated V4.6 BIN flash and boot reliably on ESP32-C3 Super Mini?
- [OPEN QUESTION] Does single-tap voltage bounce behave physically and respect the 200 ms selector deadtime / 1 s guard?
- [OPEN QUESTION] Does hardware cooling ON force Fan to a verified 100% duty cycle?
- [OPEN QUESTION] Does Peltier OFF→ON execute exactly 5 seconds of soft-start before 100%?
- [OPEN QUESTION] Does normal Hotside limit protection still behave correctly at configured threshold?
- [OPEN QUESTION] Does V4.6 NTC fault handling enter Fan 100% / Peltier OFF / safe 5V?
- [OPEN QUESTION] Do Local OTA and Online OTA both pass on V4.6?
- [OPEN QUESTION] Does Online OTA correctly close active GATT before Wi-Fi ownership and recover BLE/P1 after restart?
- [OPEN QUESTION] Does App ↔ V4.6 integration pass without command/telemetry regressions?
- [OPEN QUESTION] After all firmware/runtime gates pass, is the final release package and firmware metadata ready for Release Gate?

## 20. CHAT-ONLY INFORMATION
- [CHAT-ONLY] User explicitly moved the project into QC / PRE-RELEASE before release.
- [CHAT-ONLY] User plans to move to a new chat before context limit.
- [CHAT-ONLY] This prompt is the current chat-limit persistence instruction.
- [CHAT-ONLY] No physical V4.6 QC result has been reported in this chat.

## 21. EXACT NEXT ACTION
> **Compile V4.6 → generate BIN → flash ESP32-C3 → begin Hardware QC.**

## 22. REQUIRED FIRST ACTION IN NEW CHAT
- [USER REQUIREMENT] Read README.md.
- [USER REQUIREMENT] Read PROJECT_STATE.md.
- [USER REQUIREMENT] Read CHAT_RULES.md.
- [USER REQUIREMENT] Read APP_NOTES.md.
- [USER REQUIREMENT] Read FIRMWARE_NOTES.md.
- [USER REQUIREMENT] Read BUILD_NOTES.md.
- [USER REQUIREMENT] Read CHANGELOG.md.
- [USER REQUIREMENT] Read firmware/FIRMWARE_ANALYSIS.md.
- [USER REQUIREMENT] Read HANDOVER.md.
- [USER REQUIREMENT] Read CHAT_TRANSFER.md.
- [USER REQUIREMENT] Inspect exact current Firmware source, App source, workflow, branch, and HEAD.
- [USER REQUIREMENT] Reconcile repository truth before any source change.
- [USER REQUIREMENT] Remain in QC / PRE-RELEASE mode.

## 23. AUTHORITY / RECONCILIATION NOTES
- [VERIFIED] Authority order:
  1. CURRENT SOURCE / CURRENT WORKFLOW
  2. PROJECT_STATE.md
  3. AUTHORITATIVE NOTES
  4. BUILD_NOTES.md / CHANGELOG.md / HANDOVER.md
  5. CHAT_TRANSFER.md
  6. CURRENT CHAT
  7. OLD CHAT
- [RECONCILIATION] Current source confirms V4.6, GPIO mapping, 60 s hard limit, 5 s soft-start, hardware touch sequence, Fan 100% touch ON, and absence of rapid-rise identifiers.
- [RECONCILIATION] Current workflow is the single direct Release workflow; historical notes describing a reusable engine are obsolete/historical.
- [RECONCILIATION] Latest App Build evidence is run 37245703677; Firmware V4.6 runtime is separate and still unverified.
- [RECONCILIATION] Current repository documentation already identified QC as the phase; this recap preserves and expands that state.
- [VERIFIED] No functional App/Firmware source is being changed by this recap.

## 24. TRANSFER COMPLETION
- [IMPLEMENTED] New complete transfer snapshot is prepared from the accessible chat context plus current repository evidence.
- [IMPLEMENTED] Existing CHAT_TRANSFER.md will be replaced, not appended.
- [IMPLEMENTED] No functional App/Firmware source change is part of this operation.
- [PENDING] Final transfer-save commit SHA and post-save HEAD must be verified after the repository write.
