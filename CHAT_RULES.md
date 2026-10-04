# JE X FYZ — ACTIVE CHAT / ENGINEERING RULES

## COMMANDS
- @Thinking Diskusi! = discussion/review only; no functional source, release, or build.
- @Thinking Tanya Gemini! = diagnosis/patch-request; return exact OLD → NEW patches only.
- @Thinking Eksekusi! = implement approved scope + affected audit + memory sync + commit.
- @Thinking Eksekusi Full! = implement + full audit + memory sync + commit; App Build is not implied.
- @Thinking Build App! = explicit full App Build workflow in a fresh engineering environment.
- @Thinking Eksekusi & Build App! = implement → audit → sync → commit → explicit App Build.

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
- Hotside NTC safety is authoritative.

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
- Build trigger is manual-by-issue only; the trigger workflow calls a reusable App Build engine.
- The restored App Build engine uses Actions artifacts for APK + Dart symbols, matching the proven historical delivery path.

## MEMORY RULES
- Persist meaningful project state in repository documentation.
- CHAT_TRANSFER.md is the latest transfer snapshot, not source of truth.
- Replace transfer snapshots; do not append repeated full snapshots.
- Obsolete history belongs in CHANGELOG or Git history, not Current State.
- Discussion memory sync must not change functional source.
- Current source/workflow always wins on conflicts.

## CURRENT STATUS
- Firmware: V4.5.
- App: 1.0.0+3.
- Latest verified downloadable App Build: #2.
- Build #53: [VERIFIED] CI gates through production signing; [BLOCKED] artifact creation by Actions quota.
- Local OTA: [CONFIRMED] user-confirmed working on V4.4 before V4.5 promotion; Local OTA remains protected.
- Online OTA: [CONFIRMED] V3.2-style path retained; V4.5 physical validation still pending.
- Current App Build trigger: [COMMITTED] .github/workflows/jexfyz-app-build-trigger.yml.
- Current reusable App Build engine: [COMMITTED] .github/workflows/jexfyz-app-build-engine.yml.
- The previous single-workflow Release-asset path is retained as historical evidence only.
- Latest verified downloadable APK remains historical workflow run #2 / GitHub Release jexfyz-latest; the restored workflow pair has not been re-run yet.
- Restored workflow pair is intentionally based on the proven Build #50-era reusable engine + issue trigger.
