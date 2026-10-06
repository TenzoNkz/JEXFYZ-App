# JE X FYZ — ACTIVE CHAT / ENGINEERING RULES

## COMMANDS
- @Thinking Diskusi! = discussion/review only; no functional source, release, or build.
- @Thinking Tanya Gemini! = diagnosis/patch-request; return exact OLD → NEW patches only.
- @Thinking Eksekusi! = implement approved scope + affected audit + memory sync + commit.
- @Thinking Eksekusi Full! = implement + full audit + memory sync + commit; App Build is not implied.
- @Thinking Build App! = explicit full App Build workflow in a fresh engineering environment.
- @Thinking Eksekusi & Build App! = implement → audit → sync → commit → explicit App Build.

## CURRENT PHASE
- **V5.7 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## QC / SOURCE FREEZE
- QC is validation-first, not feature-development.
- Treat functional source as FROZEN during QC.
- Only change functional source for a demonstrable/reproducible QC failure with a clear root cause.
- Do not refactor or change unrelated behavior while closing a QC finding.
- Record the finding, evidence, root cause, affected scope, fix, and re-audit result.

## AUTHORITY
1. CURRENT SOURCE / CURRENT WORKFLOW
2. PROJECT_STATE.md
3. AUTHORITATIVE NOTES
4. BUILD_NOTES.md / CHANGELOG.md / HANDOVER.md
5. CHAT_TRANSFER.md
6. CURRENT CHAT
7. OLD CHAT

## FIRMWARE RULES
- Functional image changes increment FW_VERSION.
- Active .ino filename matches FW_VERSION.
- One active versioned .ino under firmware/.
- No executable delay().
- No timing while() loops.
- Cooperative millis()-based timing.
- Local OTA is Golden/Protected.
- OTA has priority over normal application work.
- OTA protection reminder is active; protected OTA source/contract drift requires explicit [OTA-SEAL-RENEW].
- Anti-downgrade is intentionally OFF; any valid firmware version different from the device version may be installed.
- Hotside NTC safety is authoritative.

## OTA SECURITY SEAL RULES
- Protected OTA regions are CI-sealed against accidental edits.
- The seal covers Firmware OTA runtime/priority, BLE radio handoff, App version policy, and App Firebase metadata validation.
- Updating a sealed OTA region requires [OTA-SEAL-RENEW] and a refreshed seal manifest/lock that still passes CI.
- The seal is an integrity guard; it does not replace compile, BIN, flash, OTA, or hardware validation.

## APP RULES
- Firmware telemetry is authoritative for physical hardware state.
- Protocol tokens remain untranslated.
- User-facing text uses the localization layer.
- Wi-Fi credentials use secure storage.
- App Build is independent from Firmware build/flash.

## BUILD RULES
- App Build is manual-by-issue-trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Token: JEXFYZ_BUILD_TRIGGER_V1
- One normal APK, not a Play Store bundle.
- Obfuscated release build required.
- Normal push/PR must not generate a release APK.
- Firmware-only changes do not require App Build.
- Never claim build/compile/flash/runtime validation that did not occur.
- The active direct issue-triggered workflow publishes the APK to GitHub Release jexfyz-latest and does not use Actions artifacts.
- No reusable App Build engine is currently active.

## QC GATES
1. Firmware compile
2. BIN generation
3. Flash
4. Hardware-only behavior
5. Safety
6. Local OTA Golden Path
7. Online OTA + BLE recovery
8. App ↔ Firmware integration
9. Release Gate

## MEMORY RULES
- Persist meaningful project state in repository documentation.
- CHAT_TRANSFER.md is the latest transfer snapshot, not source of truth.
- Replace transfer snapshots; do not append repeated full snapshots.
- Obsolete history belongs in CHANGELOG or Git history, not Current State.
- Discussion memory sync must not change functional source.
- Current source/workflow always wins on conflicts.

## CURRENT STATUS
- Phase: V5.7 DEVELOPMENT + QC / PRE-RELEASE.
- Release status: NOT RELEASED.
- Firmware: V5.7.
- App: 1.0.0+3.
- Firmware V5.7 source/static audit: PASS.
- Firmware V5.7 OTA update to hardware: USER-CONFIRMED SUCCESS.
- Full V5.7 compile/BIN/flash/physical validation: UNVERIFIED.
- Latest verified downloadable App Build: workflow run 37245703677 via GitHub Release jexfyz-latest.
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- Current App Build workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- OTA Security Seal workflow: .github/workflows/ota-security-seal.yml.
- OTA Security Seal manifest: firmware/OTA_SECURITY_SEAL.json.
- OTA Security Seal lock: firmware/OTA_SECURITY_SEAL.lock.
- Latest OTA Security Seal commit: c2845ef674e9f3041115b6c5c3d618b7a5a5790d.
