# JE X FYZ — LATEST CHAT TRANSFER

## 1. TRANSFER METADATA
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Phase: **V4.6 — CODE COMPLETE → QC / PRE-RELEASE → NOT RELEASED**
- Active Firmware: V4.6
- Source: firmware/JEXFYZ-V4.6.ino
- Firmware blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- Firmware source change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d
- App: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified App Build: 37245703677 / GitHub Release jexfyz-latest
- App build was not rerun for V4.6.

## 2. CURRENT TASK
- QC / PRE-RELEASE validation of Firmware V4.6.
- No release has been declared.

## 3. CURRENT WORKFLOW
- App Build is manual-by-issue-trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER.
- Token: JEXFYZ_BUILD_TRIGGER_V1.
- Normal push/PR do not trigger App Build.
- Current workflow publishes exactly one obfuscated, production-signed APK to GitHub Release jexfyz-latest.
- No Actions artifact delivery is used.

## 4. USER REQUIREMENTS
- Preserve 60-second BOOT_AP_HARD_LIMIT.
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: 5-second soft-start, then 100%.
- Remove Rapid Hotside-rise protection.
- Preserve normal Hotside temperature-limit safety.
- Preserve all unrelated behavior.

## 5. FROZEN / ACCEPTED DECISIONS
- GPIO Peltier = 5; Fan = 6.
- Local OTA = Golden/Protected.
- Wi-Fi/BLE single-radio ownership remains mandatory.
- BLE Service/RX/TX UUIDs and P1 remain frozen.
- App source/UI remains frozen unless QC proves an integration defect.
- Source has no executable delay() and no timing while() loops.

## 6. REJECTED / OBSOLETE
- Rapid Hotside-rise protection is removed/obsolete.
- Feature development during QC is out of scope.
- App Build without explicit Build App authorization is out of scope.

## 7. APP STATE
- App 1.0.0+3, functionally unchanged for V4.6.
- Latest verified APK predates V4.6.

## 8. FIRMWARE STATE
- V4.6 active source, blob cd2ebd7395343f64b824e74c1370b04cea6835ab.
- One active versioned .ino remains.
- Static/source audit PASS.
- Compile/BIN/flash/physical runtime UNVERIFIED.

## 9. ANDROID / BLE / OTA / FIREBASE / CI
- Frozen BLE UUIDs/P1.
- Online OTA requires active GATT disconnect before Wi-Fi handoff.
- Local OTA remains Golden/Protected.
- Current App Build workflow is direct Release, issue-triggered, owner/title/token gated.
- Production signing certificate remains unchanged.

## 10. SOURCE CHANGES
- V4.5 → V4.6.
- Hardware touch voltage bounce sequence added.
- Hardware cooling ON forces Fan 100%.
- 5-second Peltier soft-start preserved.
- Rapid-rise protection/state/history removed.
- No App source functional change.

## 11. COMMITS / SHAs
- Firmware source change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d.
- Firmware blob: cd2ebd7395343f64b824e74c1370b04cea6835ab.
- This QC transition changes documentation only.

## 12. BUILD STATE
- Latest verified App Build: 37245703677.
- V4.6 Firmware compile/BIN/flash: UNVERIFIED.
- V4.6 App integration: UNVERIFIED.
- V4.6 NOT RELEASED.

## 13. BUGS / SYMPTOMS
- No new V4.6 runtime bug established yet.

## 14. VERIFIED ROOT CAUSES
- None newly established during QC.
- Static audit is passing.

## 15. HYPOTHESES / LIKELY CAUSES
- None accepted as fact.
- Hardware/runtime behavior must be measured.

## 16. GEMINI RESULTS
- No current Gemini result is being used as release evidence.

## 17. FAILED APPROACHES / DEAD ENDS
- Legacy Actions-artifact delivery is obsolete.
- Older Online OTA variants are historical; current source uses the protected V4.5/V4.6 contract.

## 18. KNOWN RISKS
- Physical V4.6 behavior not validated.
- V4.6 OTA not physically validated.
- Latest verified App APK predates V4.6.

## 19. UNRESOLVED QUESTIONS
- Does V4.6 compile on ArduinoDroid/Core 3.3.7?
- Does V4.6 flash and boot reliably?
- Does touch voltage bounce behave physically as specified?
- Does hardware Fan ON reach 100%?
- Does Peltier execute exactly the 5-second soft-start?
- Do Local/Online OTA and BLE recovery pass?
- Does App ↔ V4.6 integration pass?

## 20. CHAT-ONLY INFORMATION
- User requested moving into QC / PRE-RELEASE mode and intends to move chat before context limit.

## 21. EXACT NEXT ACTION
- Compile V4.6 → generate BIN → flash ESP32-C3 → Hardware QC.

## 22. REQUIRED FIRST ACTION IN NEW CHAT
- Read README.md, PROJECT_STATE.md, CHAT_RULES.md, APP_NOTES.md, FIRMWARE_NOTES.md,
  BUILD_NOTES.md, CHANGELOG.md, firmware/FIRMWARE_ANALYSIS.md, HANDOVER.md,
  CHAT_TRANSFER.md.
- Inspect exact current source/workflow and branch HEAD.
- Reconcile repository truth.
- Remain in QC / PRE-RELEASE mode.

## 23. AUTHORITY / RECONCILIATION NOTES
- Current source/workflow outrank all documentation.
- CHAT_TRANSFER.md is transfer evidence only.
- V4.6 source/static audit is current evidence; V4.6 runtime is still unverified.
- Older V4.5/V4.4 validation evidence must not be promoted to V4.6 runtime proof.

## 24. TRANSFER COMPLETION
- [IMPLEMENTED] QC phase persisted in repository memory.
- [IMPLEMENTED] README Prompt 2 updated to QC / PRE-RELEASE transfer procedure.
- [IMPLEMENTED] Functional App/Firmware source untouched by this docs-only transition.
- [PENDING] Physical QC gates remain.
