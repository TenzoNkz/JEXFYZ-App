# JE X FYZ / JE Cooler — Legacy Transfer, Rules & History Snapshot

**Captured verbatim from App repository commit `8295352ee710b7136cad9f6f6842477b028f4d20` on 2026-10-14.** This snapshot exists to avoid losing prior project memory while files are renamed/reorganized. It contains old/duplicated status blocks and historical statements, including some that are no longer current. Never use those blocks as current truth; verify live source and use `PROJECT_STATE.md`, `CHAT_RULES.md` and `MEMORY_INDEX.md`.

---

## Archived file: `README.md`

- Original blob: `1939fbe4cb1c714cae67dee0ccdf8decc7668582`
- Purpose preserved: Legacy file named README that actually contained transfer prompt templates

`````markdown
# JE X FYZ — Chat Transfer Protocol

This file is reserved **only for transferring work between ChatGPT conversations**. It is not a project changelog, execution diary, or technical source of truth. Current project state belongs in `CHAT_TRANSFER.md`; persistent state and technical history belong in their dedicated files.

## Prompt 1 — Chat-Limit Recap / Save to Repository

Copy this prompt when the current conversation is nearing its context limit:

```text
@Thinking CHAT-LIMIT RECAP — SAVE TO REPOSITORY

Tujuan: rekonsiliasi state percakapan dengan repository, lalu REPLACE
CHAT_TRANSFER.md dengan transfer protocol/snapshot terbaru.

WAJIB:
1. Baca CHAT_TRANSFER.md sebelum menggantinya.
2. Verifikasi current main HEAD, source aktif, App source, workflow, dan status PR/branch yang relevan.
3. Baca PROJECT_STATE.md, HANDOVER.md, CHAT_RULES.md, serta catatan teknis yang relevan.
4. Pisahkan CURRENT TRUTH, VERIFIED, USER-REPORTED, UNVERIFIED, HYPOTHESIS,
   HISTORY/OBSOLETE, dan CHAT-ONLY STATE.
5. Simpan versi/path/blob SHA/commit SHA serta bukti compile, test, flash, dan OTA secara tepat.
6. Replace CHAT_TRANSFER.md; jangan append snapshot duplikat.
7. Update PROJECT_STATE.md/HANDOVER.md hanya jika state persisten memang berubah.
8. Re-read file yang disimpan dan verifikasi commit serta isinya.

BATASAN:
- Jangan mengubah source fungsional hanya karena proses transfer.
- Jangan compile Firmware, Build App, membuat BIN, flash/OTA, atau release tanpa
  perintah eksplisit yang sesuai.
- Prefer commit langsung ke main. Jangan membuat branch/PR kecuali diminta.
- Jangan mengklaim test atau validasi yang tidak dijalankan.
- Jika write gagal, tandai BLOCKED dan jangan mengklaim transfer tersimpan.

Selesaikan verifikasi persistence dan laporkan bukti commit secara singkat.
```

## Prompt 2 — New Chat Boot / QC Pre-Release

Copy this prompt when opening a new conversation:

```text
@Thinking NEW CHAT BOOT — JE X FYZ / QC PRE-RELEASE

Jangan memulai ulang project atau langsung mengubah source.

MANDATORY BOOT:
1. Baca CHAT_TRANSFER.md terlebih dahulu.
2. Baca PROJECT_STATE.md, HANDOVER.md, dan CHAT_RULES.md.
3. Baca APP_NOTES.md, FIRMWARE_NOTES.md, firmware/FIRMWARE_ANALYSIS.md,
   OTA_PROTECTION.md, BUILD_NOTES.md, dan CHANGELOG.md bila relevan.
4. Periksa current main HEAD, active Firmware source/version/blob,
   App source, workflow aktif, PR/branch penting, dan status file yang relevan.
5. Rekonsiliasi kontradiksi tanpa mengarang fakta.
6. Jangan mengubah source saat boot/reconciliation.

AUTHORITY:
Current source + active workflow > PROJECT_STATE.md > authoritative current notes
> CHAT_RULES.md/HANDOVER.md/CHANGELOG.md > CHAT_TRANSFER.md > current chat > old chat.

QC:
- Source presence/static audit bukan bukti compile, flash, atau physical behavior.
- Jangan Build App kecuali user eksplisit meminta Build App.
- Jangan compile/build Firmware kecuali user eksplisit meminta compile/build Firmware.
- Jangan flash, mengubah production OTA metadata, atau release tanpa otorisasi.
- Source fungsional frozen selama QC kecuali ada defect nyata dengan root cause jelas
  dan fix yang sempit.
- Jangan membuat PR/branch; default-nya commit langsung ke main bila ada izin eksekusi.

FIRST RESPONSE (Indonesian):
CURRENT PROJECT TRUTH
REPOSITORY RECONCILIATION
VERIFIED
UNVERIFIED
KNOWN RISKS
NEXT EXACT QC GATE
WORKFLOW STATUS

Jangan minta user mengulang informasi yang sudah tersedia. Setelah laporan boot,
tunggu perintah selanjutnya.
```

`````

---

## Archived file: `CHAT_RULES.md`

- Original blob: `5162171f88df4cc2407b7402ffbf8561f7fdf689`
- Purpose preserved: Legacy rules mixed with obsolete V6.1 status and implementation log

`````markdown
## CURRENT V6.4 EXECUTION STATUS — 2026-10-14

- [VERSION ALIGNMENT — SOURCE ONLY] Active source is `firmware/JEXFYZ-V6.4.ino` with `FW_VERSION = "V6.4"`; the V6.3-named active file is retired. The source revision has not been compiled; no BIN generation, flash/OTA, Firebase update, or release is implied.

### Peltier voltage-transition restart prevention — 2026-10-13

- [FIXED IN SOURCE — NOT COMPILED] On a voltage transition, firmware pauses Peltier PWM only if the 5-second soft-start is still active: it records that state and forces GPIO5 PWM to 0% before selector handoff. If soft-start has completed and PWM is already 100%, Peltier PWM stays at 100% throughout the voltage transition unless a Peltier-OFF command or safety protection stops it. Fan remains ON/forced to 100%; the existing 200 ms break-before-make selector sequence is unchanged.
- [IMPLEMENTED IN SOURCE] An interrupted ramp remains at 0% through the existing 1,000 ms settle interval (`PELTIER_VOLTAGE_SETTLE_MS`, aliased to `VOLTAGE_GUARD_MS`), then starts a fresh 5-second ramp from 0%. A completed ramp is not interrupted: it stays at 100% during the selector transition, without another soft-start or a forced 0% interval. Peltier-OFF, thermal/sensor safety, or OTA safe-output handling must stop output and cancel any pending ramp resume.
- [REGRESSION CONTRACT ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` checks pause-before-selector ordering only for an active ramp, the conditional 1-second settle/fresh-ramp path, uninterrupted 100% duty when the ramp already completed, cancellation on Peltier OFF, and reset-reason diagnostics.
- [USER-REPORTED SYMPTOM] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON during soft-start. A power transient/brownout is a plausible hypothesis, not a confirmed reset cause; capture `BOOT: RESET_REASON=...` after the next user-side reproduction.
- [UNVERIFIED] The latest source revision has not been compiled or tested on hardware. The earlier V6.3 compile report predates this fix. No BIN, flash, physical OTA, or release operation was performed.
- [CANONICAL MEMORY] See [VOLTAGE_TRANSITION_MEMORY.md](VOLTAGE_TRANSITION_MEMORY.md) for the full incident record, exact timing contract, safeguards, and validation boundary.

### Online OTA connection regression correction — 2026-10-13

- [SOURCE FIX IMPLEMENTED] V6.3 Online OTA restores the previous `cloudClient.setInsecure()` connection path. The inline ISRG Root X1 certificate, CA validation call, `configTime()`, `TIME_SYNCING` state, and 20-second NTP gate were removed. On Wi-Fi connection, the blue indicator runs directly before the GitHub GET attempt.
- [PRESERVED] The HTTPS transport, raw GitHub BIN URL allowlist for `TenzoNkz/JEXFYZ-Firmware`, redirect blocking, download size/image checks, safe-output sequencing, and OTA recovery path remain in place. `setInsecure()` does not validate the server certificate identity.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_4_qc_contract_test.dart` now asserts the restored connection path, removal of CA/NTP gates, blue-before-GitHub flow, and retention of the URL allowlist/redirect block.
- [USER-REPORTED RESULT — 2026-10-13] The user reports that V6.3 compiled successfully after this correction and Online OTA can connect to GitHub again. This confirms the reported compile/connect result only; a complete BIN transfer, successful `Update.end()`, reboot, and confirmation of the new firmware version were not separately established here. Because CA validation and the OTA-only NTP gate were removed together, the available evidence does not isolate which one alone caused the earlier failure.
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, user-reported evidence boundary, trade-off, and recurrence-prevention rules.
- [NOT DONE BY ASSISTANT] No firmware compile, BIN generation/publication, flash, physical OTA run, or APK Build was performed by this assistant session.


### APP BLE reconnect and Online OTA acknowledgement follow-up — 2026-10-13

- [FIXED IN APP SOURCE] Disconnect rediscovery now avoids starting when Auto Connect is disabled or no previously paired cooler identity is known. The retry loop is cancelled when Bluetooth/permissions/location prerequisites fail, and scanning is suppressed during BLE syncing. Retry starts again when Auto Connect is enabled or the app resumes while disconnected.
- [FIXED IN APP SOURCE] A missing `CLOUDOTA` ACK due to `TIMEOUT` or `DISCONNECTED` is treated as ambiguous, not as a definite rejection. The app preserves OTA recovery state and tells the user it is waiting for reconnection or an OTA result. A definite rejection while BLE remains connected still follows the rejection path.
- [REGRESSION CONTRACTS ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` now checks both retry-loop cancellation and ambiguous OTA ACK handling. No Flutter tests or Dart analysis have run for this change because this environment has no Flutter/Dart executable.
- [PRESERVED BY USER INSTRUCTION] `android/app/build.gradle` still has `versionName "Telegram @horizontalzzz"` as the user's intentional identity. It was not modified.
- [VALIDATION BOUNDARY] Source and contract assertions were reviewed statically only; the user separately reports a successful firmware compile and restored GitHub connection. No Build App/APK build, BIN publication, flash, complete OTA install, or hardware validation was performed by this assistant session.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.4.ino`, blob `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. The user reports a successful firmware compile and GitHub connection, but no complete OTA transfer/apply/reboot proof is recorded here. No BIN generation/publication, flash, independent hardware validation, Android BLE pairing, or APK Build was performed by the assistant.
- [NOT RELEASED] V6.4 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

## HISTORICAL V6.2 FULL EXECUTION — 2026-10-13

- [CURRENT TRUTH] Active Firmware file: `firmware/JEXFYZ-V6.2.ino`; content blob SHA: `88d92f652a3cf973eb34bcfe3a9d73d9cbd87123`. The last Firmware source update is commit `13377f00b49d9de0bbd31a872c0da7251be56e8d`. V6.1 source is retired from the active tree.
- [CURRENT TRUTH] App file: `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`, last App correction commit `116921bd28d280039ba191371fa276149466c802`. App version remains `1.0.0+3`.
- [IMPLEMENTED IN SOURCE] Adaptive thermal safety uses 30-second dwell at 12 V, 9 V, and 5 V. Peltier turns OFF immediately and Fan remains at 100%. If Hotside reaches `hotLimit - 1°C` and remains there for 5 consecutive seconds before the 30-second deadline, the timer is cancelled, the rail is retained, and Peltier may resume. Otherwise 12 V/9 V steps down one rail, while an unrecovered 5 V stage enters terminal Adaptive/Peltier lock requiring manual restart.
- [IMPLEMENTED IN SOURCE] After a thermal downshift, voltage recovery is one step at a time after 60 seconds continuously at or below `hotLimit - 1°C` at each rail, up to the saved pre-downshift Adaptive ceiling. The Battery Adaptive controller is gated while thermal recovery is active. Terminal 5 V lock does not auto-recover.
- [IMPLEMENTED IN SOURCE] Manual Peltier re-arm threshold is `hotLimit - 1°C`, qualified by 5 seconds of stable readings.
- [IMPLEMENTED IN SOURCE] Online OTA retains the `TenzoNkz/JEXFYZ-Firmware` raw BIN allowlist, synchronizes NTP time with a 20-second timeout, validates HTTPS using ISRG Root X1, and rejects redirects. Local OTA stays as-is; no signature/checksum layer was added.
- [IMPLEMENTED IN SOURCE] BLE command writes require encryption/bonding using Secure Connections with Just Works pairing. MITM/passkey is not enabled because the ESP32-C3 has no passkey display/input; Android first pairing and reconnect require physical verification.
- [IMPLEMENTED IN SOURCE] App normal reconnect begins only after offline state is committed; Online OTA recovery is armed before `CLOUDOTA`; voltage success waits for matching `VOLTAGE` telemetry; LED confirmation normalizes optional `#`; Dashboard and Floating Monitor show unknown output status while disconnected; re-arm copy uses `hotLimit - 1°C`.
- [IMPLEMENTED] Added `test/v6_2_qc_contract_test.dart`, updated `test/firmware_touch_adaptive_sync_test.dart` to the V6.2 path, and added Flutter/Dart/Android `.gitignore`.
- [BLOCKED] `pubspec.lock` is absent from `main`. A temporary GitHub Actions run resolved dependencies, but its lockfile push was rejected as non-fast-forward; the subsequent test/analyze steps were skipped. The temporary workflow was removed and no lockfile was committed.
- [UNVERIFIED] `flutter test` and `flutter analyze` remain unexecuted: the temporary Action skipped both after its lockfile push failed. This environment has no local Flutter/Dart toolchain. Firmware was not compiled, App APK was not built, BIN/flash/OTA/hardware/Android pairing tests were not performed.
- [NOT RELEASED] V6.2 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repo/Firebase release metadata were not modified.

# JE X FYZ — ACTIVE CHAT / ENGINEERING RULES

## COMMANDS
- @Thinking Diskusi! = discussion/review only; no functional source, release, or build.
- @Thinking Tanya Gemini! = diagnosis/patch-request; return exact OLD → NEW patches only.
- @Thinking Eksekusi! = implement approved scope + affected audit + memory sync + commit.
- @Thinking Eksekusi Full! = implement + full audit + memory sync + commit; App Build is not implied.
- @Thinking Build App! = explicit full App Build workflow in a fresh engineering environment.
- @Thinking Eksekusi & Build App! = implement → audit → sync → commit → explicit App Build.

## CURRENT PHASE
- **V6.1 — source-only / DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## QC / SOURCE FREEZE
- QC is validation-first, not feature-development.
- Treat functional source as FROZEN during QC.
- [HISTORICAL] V5.8/V5.9 QC records apply only to those historical source versions; current source is V6.1.
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
- OTA protection reminder is active; protected OTA source/contract drift requires explicit discussion/approval.
- Anti-downgrade is intentionally OFF; any valid firmware version different from the device version may be installed.
- Hotside NTC safety is authoritative.

## OTA PROTECTION RULES
- OTA_PROTECTION.md is the engineering reminder for the protected OTA path.
- OTA changes require a demonstrated OTA defect, explicit discussion/approval, and a full OTA re-audit.
- Do not refactor or optimize OTA while working on unrelated functionality.

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

## LATEST QC SOURCE FIX — 2026-10-13
- [IMPLEMENTED] Touch long-press Adaptive-OFF now emits authoritative Adaptive/ceiling/Fan/Peltier/Fan-speed telemetry; source blob: 50dee6c7ed3cb5780e97deaa235fe81856152ec2.
- [IMPLEMENTED] Added static source-contract regression test at test/firmware_touch_adaptive_sync_test.dart; test execution is UNVERIFIED.
- [UNVERIFIED] Firmware compile/BIN/flash, App tests/Build, physical sync validation, and OTA regression remain open. Do not upgrade any gate to PASS.

## CURRENT STATUS
- Phase: V6.1 source-only DEVELOPMENT + QC / PRE-RELEASE.
- Release status: NOT RELEASED.
- Firmware source: V6.1 (`firmware/JEXFYZ-V6.1.ino`); latest source blob 50dee6c7ed3cb5780e97deaa235fe81856152ec2; compile/BIN/flash unverified.
- App: 1.0.0+3.
- V6.1 source inventory: one NTC ADC-read call site and no `delay(` call site; this limited source check is not a compile or runtime test.
- V5.7 physical OTA update was user-confirmed successful; V6.1 physical validation is UNVERIFIED.
- V6.1 compile/BIN/flash/physical/OTA/App integration remain QC gates; no firmware compile workflow is active on `main`.
- Latest verified downloadable App Build remains historical; V5.9 App Build was NOT executed by this source integration.
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- OTA protection reminder: OTA_PROTECTION.md (documentation-only; no CI enforcement).

`````

---

## Archived file: `CHAT_TRANSFER.md`

- Original blob: `fbb5909e81a03f750c3630b445a2da16ed5c233f`
- Purpose preserved: Prior transfer snapshot; preserved exactly for recovery

`````markdown
# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Snapshot date: 2026-10-14 (Asia/Jakarta). This file replaces the previous snapshot; it is a boot/transfer protocol, not a substitute for checking live GitHub state.

Current OTA source note: the Online OTA connection correction was introduced in the V6.3 revision and remains present in active V6.4 source via `cloudClient.setInsecure()`. The embedded CA certificate and OTA-only NTP time-sync gate are removed; blue feedback follows Wi-Fi connection before the GitHub GET attempt. The raw GitHub BIN URL allowlist and redirect blocking remain. This bypasses server certificate identity validation. [USER-REPORTED] Firmware compile succeeded and Online OTA connects to GitHub again after this change. Full transfer, flash/apply completion, successful reboot, and installed-version confirmation are not independently recorded here. Canonical Online OTA prevention record: [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md). The Peltier rail-transition rule is tracked in [VOLTAGE_TRANSITION_MEMORY.md](VOLTAGE_TRANSITION_MEMORY.md): active soft-start pauses and restarts after settling, while a completed ramp keeps PWM at 100% throughout the transition. The current revision has not been compiled or hardware-tested.

## 0. Mandatory boot and authority

1. Read this file first, then fetch current `main` HEAD and source blobs.
2. Read `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_RULES.md`, `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `firmware/FIRMWARE_ANALYSIS.md`, `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`, `BUILD_NOTES.md`, and `CHANGELOG.md`.
3. Verify current workflows, tests, open/closed PRs, and relevant branches.
4. Authority order: live source/Git refs/workflows; `PROJECT_STATE.md`; technical notes; `HANDOVER.md`/`CHAT_RULES.md`/`CHANGELOG.md`; this file; chat-only state.
5. Label statements as CURRENT TRUTH, VERIFIED, USER-REPORTED, UNVERIFIED, HYPOTHESIS, HISTORY/OBSOLETE, or CHAT-ONLY STATE. Never turn historical or user-reported facts into verified facts without evidence.

## 1. User command and safety protocol

- [USER REQUIREMENT] `Diskusi` = inspect/explain/recommend; do not write changes.
- [USER REQUIREMENT] `Eksekusi` authorizes the discussed change only; keep scope narrow.
- [USER REQUIREMENT] Build App only after an explicit “Build App” command.
- [USER REQUIREMENT] Firmware compile/build, BIN generation, flash, OTA, Firebase/production metadata changes, and release each require their own explicit authorization.
- [USER REQUIREMENT] Prefer direct commits to `main`; do not create branches or PRs unless requested.
- [USER REQUIREMENT] User will compile Firmware themselves; do not compile on their behalf.
- [MANDATORY VERSION RULE — NOW ALIGNED] Every functional Firmware source revision bumps `FW_VERSION`, matches the active `.ino` filename, and leaves only one active versioned `.ino`. The V6.4 source rename/version bump fixes the stale V6.3 alignment; source-only status does not imply a compiled BIN.
- [USER-CONFIRMED] Android Gradle `versionName "Telegram @horizontalzzz"` is intentional creator/contact identity. Preserve it exactly.
- Never claim a write, test, build, device validation, or release that did not occur.

## 2. Current repository checkpoint

- [VERIFIED] Repository: `TenzoNkz/JEXFYZ-App`; primary branch: `main`. Pre-transfer main HEAD (before this snapshot update) was `0e6edc1d59c058a09cccc90ad546c87985eb1e09`; this snapshot update creates a newer commit.
- [VERIFIED] Latest functional OTA source restoration commit: `a87bbcecdca26b3648abff9cb88937e250b41f1f`; `firmware/JEXFYZ-V6.3.ino` now uses `cloudClient.setInsecure()` without the embedded CA or NTP gate. Commit: https://github.com/TenzoNkz/JEXFYZ-App/commit/a87bbcecdca26b3648abff9cb88937e250b41f1f. The OTA contract test update follows in commit `dc0d6ec13d3f58ab864e006e7defb543fd4752b6`.
- [CURRENT SOURCE — LATEST REVISION NOT COMPILED] Active Firmware source is `firmware/JEXFYZ-V6.4.ino`; it remains one self-contained `.ino`. The earlier OTA fix uses `cloudClient.setInsecure()` with CA/NTP gate removed. User reported that prior revision compiled and GitHub connection recovered. The V6.4 revision pauses Peltier PWM only if a voltage change interrupts an active 5 s ramp; after the 1 s settle it restarts a full 5 s ramp. If the ramp had completed, PWM stays at 100% through selector movement without a forced OFF or re-ramp. `FW_VERSION` and the single active filename both align at V6.4. This revision has not been compiled. V6.2 and the stale V6.3 active filename are retired.
- [VERIFIED] App source: `lib/main.dart`, blob `535e396005a3bd1429db3096c627d87043b0e1b4`. Package `com.horizontalzzz.jexfyz`; pubspec version remains `1.0.0+3`.
- [VERIFIED] `android/app/build.gradle` blob `d8681cb73156b61da7749633abd63e2fb8c287ba`; intentional `versionName "Telegram @horizontalzzz"` remains unchanged.
- [VERIFIED] Latest V6.4 QC contract test: `test/v6_4_qc_contract_test.dart`, blob `f071c9642c1a06726d25b8c26a814845b02a55d6`.
- [VERIFIED] Firmware regression test `test/firmware_touch_adaptive_sync_test.dart` points at V6.4 source; blob `a8df6ca2be18c3b7ed9c25e5c148f0d5056556d5`.
- [IMPLEMENTED IN SOURCE; PRIOR REVISION USER-REPORTED COMPILE SUCCESS] Online OTA uses `cloudClient.setInsecure()`; the embedded ISRG Root X1 PEM, CA validation, `configTime()`, and `TIME_SYNCING`/20-second NTP gate remain removed. Blue Wi-Fi feedback leads directly to the GitHub GET attempt. User-reported compile success and recovered GitHub connectivity refer to the earlier revision; the latest Peltier transition fix has not been compiled. This intentionally skips server certificate validation; the GitHub raw-BIN URL allowlist and redirect blocking remain.
- [VERIFIED] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`); `.gitignore` is present.
- [VERIFIED] Only observed workflow in `.github/workflows/` is `.github/workflows/jexfyz-app-build-trigger.yml`, blob `6b1d6cd3c65c4913c288652ac7597e126b37d0cf`. It is manually issue-triggered with title `JE X FYZ — BUILD APP TRIGGER` and body token `JEXFYZ_BUILD_TRIGGER_V1`; normal pushes/PRs do not build the release APK.
- [VERIFIED] Branch search returned `main`, `fix/adaptive-power-sequencing`, `diag/latest-stable-v16`, `diagnostic/v1.6-heap-check`, and `tmp-jexfyz-v5-test`. The non-main branches are not authorization to switch development context; main is authoritative.
- [VERIFIED CURRENT QUERY] Open-PR search returned zero results. Closed-PR search returned #18, #7, #5, #4, #3, #2, and #1. The search connector does not expose a reliable merged flag in these results; closure is verified, but do not infer merged/unmerged status for each item solely from the closed list. Earlier project notes record PR #18 as CLOSED / NOT MERGED; confirm its merge field directly before relying on that distinction.

## 3. Current App follow-up in source

- [IMPLEMENTED IN SOURCE; NOT RUNTIME-VERIFIED] BLE disconnect rediscovery should not start when Auto Connect is disabled or no known cooler identity exists; it cancels retry work when Bluetooth/permissions/location prerequisites fail, suppresses scanning while syncing, and retries after Auto Connect is enabled or app resumes while disconnected.
- [IMPLEMENTED IN SOURCE; NOT RUNTIME-VERIFIED] A `CLOUDOTA` ACK timeout/disconnect is ambiguous, not proof of rejection. Keep OTA recovery state and show waiting-for-reconnect/result messaging. Roll back only on a definite rejection while BLE remains connected.
- [IMPLEMENTED IN SOURCE] The V6.3 QC contract test includes static regression assertions for reconnect cancellation and ambiguous OTA ACK behavior.
- [UNVERIFIED] Flutter tests and Dart analysis have not been run for this follow-up. The current environment reported no Flutter/Dart executable. A prior GitHub Actions run for the V6.2 candidate had 45 passing Flutter tests, but it does not validate current V6.4/current App changes.
- [STATUS] User-reported compile/GitHub-connect success applies to the earlier V6.3 revision. The latest source including the Peltier voltage-transition fix is not compiled or hardware-tested. No APK build/Build App, assistant-side Firmware compile, BIN generation/publication, flash, independent physical BLE pairing, hardware thermal test, or complete OTA transfer/apply/reboot regression was performed in this session.
- [CURRENT TRUTH] This snapshot records a separately authorized Peltier voltage-transition change. Read `VOLTAGE_TRANSITION_MEMORY.md` before any future transition-timing edit.

## 4. Firmware contract and status

- [VERIFIED SOURCE] Target is ESP32-C3 Super Mini / ESP32-C3 Dev Module; logic 3.3 V.
- [USER REQUIREMENT] Pin map: NTC GPIO0; Touch GPIO1; 12 V GPIO3; 9 V GPIO4; Peltier GPIO5; Fan GPIO6; WS2812 GPIO7.
- [USER REQUIREMENT] NTC 10 kΩ + 10 kΩ, Beta 3950; one calibrated ADC sample per second; do not add median/multi-sample averaging. No blocking `delay()` or timing `while()`.
- [USER REQUIREMENT] Hotside limit 40–50 °C, default 45 °C. Manual Peltier re-arm threshold is `hotLimit - 1 °C` plus five seconds stable, as reflected in current V6.4 source/notes.
- [VERIFIED STATIC SOURCE CONTRACT] V6.3 manual Peltier safety latch remains blocking until `enforceSafety()` observes Hotside at/below `hotLimit - 1°C` for five continuous seconds; a single low sample cannot bypass stability.
- [VERIFIED STATIC SOURCE CONTRACT] Adaptive thermal protection has 30-second stages at 12 V, 9 V, and 5 V with Peltier OFF and Fan 100%. Five continuous seconds at/below `hotLimit - 1°C` before the stage deadline cancels the stage; otherwise it steps down 12→9→5 V. Unrecovered 5 V enters terminal lock requiring manual restart. Recovery up one rail requires 60 seconds stable per rail, capped by saved Adaptive ceiling.
- [VERIFIED STATIC SOURCE CONTRACT] Touch long-press while Adaptive is active publishes `ADAPTIVE`, `ADAPTIVE_CEILING`, `FAN`, `PELTIER`, and `FAN_SPEED` telemetry before the `TOUCH_ADAPTIVE` ACK.
- [FIXED IN SOURCE — NOT COMPILED] A voltage transition pauses GPIO5 PWM at 0% only when Peltier's 5 s soft-start is still active; the interrupted ramp restarts after the existing 1 s settle. If soft-start is complete, PWM remains at 100% throughout selector movement. The 200 ms break-before-make sequence is unchanged. Peltier-OFF/safety cancels pending restart. Reset diagnostics still expose `BROWNOUT`.
- [HYPOTHESIS — NOT CONFIRMED] The reported immediate restart during 5 V → 12 V mid-soft-start may be caused by a current transient / supply brownout; capture `BOOT: RESET_REASON=...` after compiling and testing this latest source revision.
- [UNVERIFIED] Static assertions do not prove compilation, real-time behavior, sensor accuracy, LEDs, cooling, or device safety. User-side compile/flash/device tests remain necessary.

## 5. BLE / OTA protected contracts

- BLE service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`; RX: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`; TX: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- [USER REQUIREMENT] ESP32-C3 has one radio path: Wi-Fi OTA and BLE must not own radio simultaneously. OTA flow, state machine, LED indications, recovery, and local OTA are protected; read `OTA_PROTECTION.md` before any OTA-related changes.
- [VERIFIED SOURCE] Online OTA uses TLS via `cloudClient.setInsecure()` and only permits the allowlisted raw GitHub firmware URL prefix; redirects remain blocked. Because certificate verification is bypassed, HTTPS server identity is not authenticated. No custom SHA/signature layer was added; Firebase firmware metadata remains version + link.
- [UNVERIFIED] Current Firebase rules/App Check enforcement and live metadata were not checked in this transfer.
- [VERIFIED CURRENT REPOSITORY CHECKPOINT] Artifact repository `TenzoNkz/JEXFYZ-Firmware` contains `JEXFYZ.cpp.bin`; latest observed upload commit is `b345637acfdbd3f80ae6159a14cc09ddbc05f934` (2026-10-13T13:47:12Z). Matching the BIN to the V6.4 source blob/build provenance has not been independently verified. Do not assume or republish it without provenance and explicit authorization. Its README and OTA regression memory now document this boundary. Current documentation blobs: `README.md` `5972c344d7c97e031f38e0f4bba795470f95b17b`, `OTA_REGRESSION_MEMORY.md` `3b9d5a092a81bb96907b96c9df52df35306aa31d`, and mirrored `VOLTAGE_TRANSITION_MEMORY.md` `a63eb7c83062b4185f436ca3cf02cdb171a37d1b`; these are documentation-only updates and the BIN was not changed.
- [CROSS-REPO MEMORY LINKS] Firmware artifact repo README: https://github.com/TenzoNkz/JEXFYZ-Firmware/blob/main/README.md. Mirrored OTA prevention note: https://github.com/TenzoNkz/JEXFYZ-Firmware/blob/main/OTA_REGRESSION_MEMORY.md. Canonical Online OTA memory: https://github.com/TenzoNkz/JEXFYZ-App/blob/main/OTA_REGRESSION_MEMORY.md. Canonical voltage-transition memory: https://github.com/TenzoNkz/JEXFYZ-App/blob/main/VOLTAGE_TRANSITION_MEMORY.md. Mirrored transition memory: https://github.com/TenzoNkz/JEXFYZ-Firmware/blob/main/VOLTAGE_TRANSITION_MEMORY.md.
- [USER REQUIREMENT] Do not publish BIN, edit Firebase metadata, flash, or initiate OTA during transfer or QC discussion.

## 6. Android build and release

- [VERIFIED] Workflow file: `.github/workflows/jexfyz-app-build-trigger.yml`; issue title `JE X FYZ — BUILD APP TRIGGER`; body token `JEXFYZ_BUILD_TRIGGER_V1`.
- [VERIFIED WORKFLOW CONFIG] Java 17, Flutter 3.47.2 stable; workflow runs `flutter analyze --no-fatal-infos`, `flutter test`, and builds one obfuscated production-signed release APK after checks.
- [USER REQUIREMENT] Do not trigger this workflow unless user explicitly says Build App.
- [UNVERIFIED] Current V6.4 firmware source and current App changes have not passed a new test/analyze/build run; do not report green status based on older CI evidence.
- [USER-REPORTED] The corrected V6.3 source compiled successfully and GitHub connection recovered. [UNVERIFIED] The complete BIN transfer/apply/reboot result is not separately recorded; the assistant has not independently compiled or tested hardware.

## 7. Persistent state files and what changed

- [VERIFIED] Current OTA/voltage-transition source behavior, user-reported earlier compile/GitHub connectivity result, and regression-prevention rules are recorded in project notes. Current observed blobs at reconciliation time:
  - `PROJECT_STATE.md`: `21440eaa7f590baefcf7189a06a155251ee37efb`
  - `HANDOVER.md`: `3867c4a2b23d77e234e163ffae96c1cb61f92c48`
  - `CHAT_RULES.md`: `5162171f88df4cc2407b7402ffbf8561f7fdf689`
  - `APP_NOTES.md`: `ee6d188ee6a82fc73a10be4979c0ddefc18708c7`
  - `FIRMWARE_NOTES.md`: `f9463f39031760c5dc29a8c575b992f1c85f1bdb`
  - `BUILD_NOTES.md`: `ba4d69b10f8427769a547b112c2d9e5ac7d2686e`
  - `firmware/FIRMWARE_ANALYSIS.md`: `9e009ec08b1dcac9d43b75f8b22473481ed45aaa`
  - `OTA_PROTECTION.md`: `b68b762c618ed78b6f1c20fa133b58b26eff97bc`
  - `CHANGELOG.md`: `0a0ddc64fba1d002c91f01ccfcdf264213bc46f1`
  - `OTA_REGRESSION_MEMORY.md`: `904099dd44d704fca8566ad47905ba1a13388a5c`
  - `VOLTAGE_TRANSITION_MEMORY.md`: `a63eb7c83062b4185f436ca3cf02cdb171a37d1b`
  - `firmware/JEXFYZ-V6.4.ino`: `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`
  - `test/v6_4_qc_contract_test.dart`: `f071c9642c1a06726d25b8c26a814845b02a55d6`
  - `test/firmware_touch_adaptive_sync_test.dart`: `a8df6ca2be18c3b7ed9c25e5c148f0d5056556d5`
- [CURRENT TRUTH] The V6.3-origin Online OTA correction remains in current V6.4 source; user-reported compile/GitHub recovery and the no-recurrence policy are recorded across the project notes and the new canonical `OTA_REGRESSION_MEMORY.md`. The companion `TenzoNkz/JEXFYZ-Firmware` repository now has a README and mirrored OTA memory; its BIN was not changed.
- [HISTORY/OBSOLETE] Older snapshots embedded below this file’s prior current-status header were contradictory and stale. This file is now being fully replaced to remove duplicate/obsolete snapshots; do not append another copy.

## 8. Historical validation ledger — do not overstate

- [HISTORY — V6.2 CANDIDATE] GitHub Actions run #38362882150 recorded 45 Flutter tests passing. Plain `flutter analyze` returned nonzero due to 23 info-level deprecation notices. This is not evidence that the current V6.4 Firmware source or its latest regression test passed.
- [UNVERIFIED CURRENT] The earlier source revision's compile and GitHub-connect recovery are user-reported. The latest source revision containing the active-ramp-only pause and full-duty continuity change is not compiled or physically validated. Full OTA install/reboot, voltage-transition reset regression, Flutter test, Dart analysis, and APK build remain unverified.
- [CURRENT TRUTH] Project remains DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED. No production BIN or Firebase metadata was modified by the App fixes or this transfer.

## 9. Next session checklist

1. Read `VOLTAGE_TRANSITION_MEMORY.md` before editing rail-transition/Peltier sequencing and `OTA_REGRESSION_MEMORY.md` before any OTA connection/TLS/time-sync change; re-fetch live `main` HEAD and all source/test/workflow blobs before making claims.
2. Confirm PR states and inspect divergent branches without switching away from main.
3. If user requests validation, run only the explicitly authorized validation; distinguish test/analyze from build, firmware compile, flash, and OTA.
4. Prefer validating the new App regression test and full Flutter test/analyze before Build App, but do not run the build workflow without the explicit trigger command.
5. The latest Peltier transition revision requires user-side compile. Test Manual Volt and Adaptive both during an active soft-start (expect PWM 0% during handoff, 1 s settling, then a new full 5 s ramp) and after the ramp completes (expect uninterrupted 100% PWM throughout voltage transition). Confirm Peltier-OFF/safety stops output and cancels any pending resume. Capture `BOOT: RESET_REASON=...` / `RESET_REASON` telemetry if a restart occurs. Do not publish a BIN or infer hardware success from source-only checks.

`````

---

## Archived file: `CHANGELOG.md`

- Original blob: `0a0ddc64fba1d002c91f01ccfcdf264213bc46f1`
- Purpose preserved: Previous detailed changelog, including release/build and older version details

`````markdown
## CURRENT V6.4 EXECUTION STATUS — 2026-10-14

- [VERSION ALIGNMENT — SOURCE ONLY] Active source is `firmware/JEXFYZ-V6.4.ino` with `FW_VERSION = "V6.4"`; the V6.3-named active file is retired. The source revision has not been compiled; no BIN generation, flash/OTA, Firebase update, or release is implied.

### Peltier voltage-transition restart prevention — 2026-10-13

- [FIXED IN SOURCE — NOT COMPILED] On a voltage transition, firmware pauses Peltier PWM only if the 5-second soft-start is still active: it records that state and forces GPIO5 PWM to 0% before selector handoff. If soft-start has completed and PWM is already 100%, Peltier PWM stays at 100% throughout the voltage transition unless a Peltier-OFF command or safety protection stops it. Fan remains ON/forced to 100%; the existing 200 ms break-before-make selector sequence is unchanged.
- [IMPLEMENTED IN SOURCE] An interrupted ramp remains at 0% through the existing 1,000 ms settle interval (`PELTIER_VOLTAGE_SETTLE_MS`, aliased to `VOLTAGE_GUARD_MS`), then starts a fresh 5-second ramp from 0%. A completed ramp is not interrupted: it stays at 100% during the selector transition, without another soft-start or a forced 0% interval. Peltier-OFF, thermal/sensor safety, or OTA safe-output handling must stop output and cancel any pending ramp resume.
- [REGRESSION CONTRACT ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` checks pause-before-selector ordering only for an active ramp, the conditional 1-second settle/fresh-ramp path, uninterrupted 100% duty when the ramp already completed, cancellation on Peltier OFF, and reset-reason diagnostics.
- [USER-REPORTED SYMPTOM] Hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON during soft-start. A power transient/brownout is a plausible hypothesis, not a confirmed reset cause; capture `BOOT: RESET_REASON=...` after the next user-side reproduction.
- [UNVERIFIED] The latest source revision has not been compiled or tested on hardware. The earlier V6.3 compile report predates this fix. No BIN, flash, physical OTA, or release operation was performed.
- [CANONICAL MEMORY] See [VOLTAGE_TRANSITION_MEMORY.md](VOLTAGE_TRANSITION_MEMORY.md) for the full incident record, exact timing contract, safeguards, and validation boundary.

### Online OTA connection regression correction — 2026-10-13

- [SOURCE FIX IMPLEMENTED] V6.3 Online OTA restores the previous `cloudClient.setInsecure()` connection path. The inline ISRG Root X1 certificate, CA validation call, `configTime()`, `TIME_SYNCING` state, and 20-second NTP gate were removed. On Wi-Fi connection, the blue indicator runs directly before the GitHub GET attempt.
- [PRESERVED] The HTTPS transport, raw GitHub BIN URL allowlist for `TenzoNkz/JEXFYZ-Firmware`, redirect blocking, download size/image checks, safe-output sequencing, and OTA recovery path remain in place. `setInsecure()` does not validate the server certificate identity.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_4_qc_contract_test.dart` now asserts the restored connection path, removal of CA/NTP gates, blue-before-GitHub flow, and retention of the URL allowlist/redirect block.
- [USER-REPORTED RESULT — 2026-10-13] The user reports that V6.3 compiled successfully after this correction and Online OTA can connect to GitHub again. This confirms the reported compile/connect result only; a complete BIN transfer, successful `Update.end()`, reboot, and confirmation of the new firmware version were not separately established here. Because CA validation and the OTA-only NTP gate were removed together, the available evidence does not isolate which one alone caused the earlier failure.
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, evidence boundary, trade-off, and prevention rules.
- [NOT DONE BY ASSISTANT] No firmware compile, BIN generation/publication, flash, physical OTA run, or APK Build was performed by this assistant session.

### APP BLE reconnect and Online OTA acknowledgement follow-up — 2026-10-13

- [FIXED IN APP SOURCE] Disconnect rediscovery now avoids starting when Auto Connect is disabled or no previously paired cooler identity is known. The retry loop is cancelled when Bluetooth/permissions/location prerequisites fail, and scanning is suppressed during BLE syncing. Retry starts again when Auto Connect is enabled or the app resumes while disconnected.
- [FIXED IN APP SOURCE] A missing `CLOUDOTA` ACK due to `TIMEOUT` or `DISCONNECTED` is treated as ambiguous, not as a definite rejection. The app preserves OTA recovery state and tells the user it is waiting for reconnection or an OTA result. A definite rejection while BLE remains connected still follows the rejection path.
- [REGRESSION CONTRACTS ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` now checks both retry-loop cancellation and ambiguous OTA ACK handling. No Flutter tests or Dart analysis have run for this change because this environment has no Flutter/Dart executable.
- [PRESERVED BY USER INSTRUCTION] `android/app/build.gradle` still has `versionName "Telegram @horizontalzzz"` as the user's intentional identity. It was not modified.
- [VALIDATION BOUNDARY] Source and contract assertions were reviewed statically only; the user separately reports a successful firmware compile and restored GitHub connection. No Build App/APK build, BIN publication, flash, complete OTA install, or hardware validation was performed by this assistant session.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.4.ino`, blob `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. User-reported compile success and restored GitHub connectivity are recorded above, but a complete OTA transfer/apply/reboot proof is not established here. No BIN generation/publication, assistant-side flash, independent hardware validation, Android BLE pairing, or APK Build was performed.
- [NOT RELEASED] V6.4 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

## HISTORICAL V6.2 Online OTA TLS clock validation — 2026-10-13

- Firmware remains V6.2. Online OTA now synchronizes system time asynchronously after Wi-Fi connects and before CA-validated HTTPS begins. Time synchronization is bounded at 20 seconds and uses the existing OTA failure/recovery path on timeout.
- Redirects are disabled for the allowlisted raw GitHub BIN URL. The configured public CA validation remains enabled; no SHA/custom signature was added, and Local OTA is unchanged.
- Added QC assertions. A temporary no-build quality workflow was briefly tested: `flutter pub get` succeeded, but pushing generated `pubspec.lock` was rejected as non-fast-forward, so `flutter test`/`flutter analyze` were skipped. The temporary workflow was removed; no lockfile was committed.
- No compile, APK build, flash, device OTA, or physical test was performed; review CI and perform manual hardware validation before sign-off.

## HISTORICAL V6.2 FULL EXECUTION — 2026-10-13

- Active Firmware: `firmware/JEXFYZ-V6.2.ino`, blob SHA `88d92f652a3cf973eb34bcfe3a9d73d9cbd87123`; last Firmware source update commit `13377f00b49d9de0bbd31a872c0da7251be56e8d`. V6.1 source retired.
- App: `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`; latest App correction commit `116921bd28d280039ba191371fa276149466c802`; version unchanged at `1.0.0+3`.
- Thermal rules: 30-second protection stage at 12 V, 9 V and 5 V; Peltier OFF immediately, Fan 100%. Hotside <= `hotLimit - 1°C` for 5 continuous seconds before the 30-second deadline cancels the stage and keeps the rail. Otherwise 12 V/9 V steps down one rail and an unrecovered 5 V stage enters terminal manual-restart lock.
- Thermal voltage recovery: each upward rail needs 60 continuous seconds at or below `hotLimit - 1°C`, up to the saved Adaptive ceiling. Terminal 5 V lock does not auto-recover. Manual re-arm threshold is -1°C plus 5-second stability.
- Online OTA uses HTTPS CA validation while retaining the raw GitHub allowlist for `TenzoNkz/JEXFYZ-Firmware`. BLE command writes require an encrypted bonded connection with Secure Connections/Just Works. Local OTA was intentionally left unchanged.
- App updates: normal BLE reconnect scheduling after disconnect state update; OTA disconnect marker is armed before `CLOUDOTA`; voltage ACK is followed by authoritative `VOLTAGE` telemetry confirmation; RGB colors normalize optional `#`; Dashboard/Floating Monitor show unknown output status while offline; safety copy uses -1°C.
- Regression tests added/updated; `.gitignore` added. `pubspec.lock` is absent from `main`: an ephemeral GitHub Actions `flutter pub get` succeeded, but the generated lockfile push was rejected as non-fast-forward. Test/analyze steps were skipped and the temporary workflow was removed.
- Validation: a temporary quality workflow resolved dependencies but failed pushing `pubspec.lock` due non-fast-forward; tests/analyze were skipped and the temporary workflow was removed. No lockfile was committed. No APK build, firmware compile, BIN, flash, OTA or physical-device validation was performed.
- Release state: V6.2 source-only DEVELOPMENT + QC / PRE-RELEASE, NOT RELEASED. Production firmware repository and Firebase metadata were not changed.

## DOCUMENTATION HOUSEKEEPING — 2026-10-13

- [COMMITTED] Root `README.md` is reserved for chat-transfer instructions; version/execution history was removed from README.
- [COMMITTED] `CHAT_TRANSFER.md` was replaced with one reconciled, structured snapshot; stale duplicated/current-state claims were removed and PR #18 is recorded as closed/not merged.
- [UNRESOLVED] Source branch `fix/adaptive-power-sequencing` still exists; the available GitHub connector did not provide a branch-delete action.
- [DOCS ONLY] No App/Firmware functional source, workflow, compile, build, BIN, flash, OTA, Firebase metadata, or release was changed.

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

## HISTORICAL V6.0 EXECUTION — 2026-10-12

- [HISTORICAL] Active firmware source during the V6.0 QC snapshot: `firmware/JEXFYZ-V6.0.ino`; `FW_VERSION` was V6.0; target ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [FIX IMPLEMENTED] Adaptive ON now de-energizes Peltier PWM before a 200 ms selector break-before-make handoff to 5V. Once 5V completes, existing safety gates apply and the previously active Peltier is restored through `applyCoolingOutputs()`, invoking the existing 5-second OFF→ON soft-start.
- [FIX IMPLEMENTED] Adaptive OFF similarly de-energizes Peltier before forcing 5V; if Peltier was active, it is restored only after the 5V handoff completes and safety still permits it.
- [FIX IMPLEMENTED] Adaptive OFF white 3-blink feedback is deferred until the safe-5V handoff completes when the mode actually changed from ON to OFF; when already at 5V, feedback starts immediately. Successful Adaptive ON retains orange 3-blink feedback after activation and validation.
- [DIAGNOSTIC] Firmware boot prints `BOOT: RESET_REASON=<reason>` to Serial so reset cause can be captured even if BLE telemetry is interrupted.
- [COMMITTED] Adaptive handoff code: `2b119ac51f7989a00f82cfb4c190c0310881fdd1`.
- [COMMITTED] Firmware contract comment alignment: `45390c258d1769e3834b3c1dac68fd8eeced3b4d`.
- [COMMITTED] Firmware compile workflow: `e3e1922b05187e5df0fdbdc78402f62899dcf2e6`; QC prerelease delivery replaces artifact upload because Actions artifact storage quota was exhausted: `2e0aa75f9edb9a0646d90466d4183f20058f0306`.
- [VERIFIED BUILD] GitHub Actions run #83 passed with Arduino-ESP32 Core 3.3.7, target `esp32:esp32:esp32c3:PartitionScheme=min_spiffs`; job/run: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38267907193.
- [VERIFIED IMAGE] Compile reported 1,465,067 bytes program storage (74% of 1,966,080 bytes) and 46,740 bytes global RAM (14% of 327,680 bytes). Generated QC BIN is 1,465,216 bytes; ESP image magic `E9` and configured OTA size checks passed.
- [VERIFIED QC ASSET] Byte-for-byte release re-download verification passed. SHA-256: `b50af3bf9b43f1f78425e4dbd273534f218acd8c58a539eb2426bf3d9d5b10a8`. QC-only prerelease: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/firmware-qc-latest.
- [HISTORICAL] During the V6.0 QC snapshot, the GPIO mapping, NTC single-sample 1 Hz path, safety gates, selector deadtime, voltage guard, Adaptive 5-second upward dwell, OTA runtime logic, BLE/P1, App source, and production OTA metadata were not intentionally changed. The V6.0 production BIN in `TenzoNkz/JEXFYZ-Firmware` and Firebase `firmware_update.json` remained unchanged.
- [AUDIT PASS] Post-change lexical delimiter check passed; Adaptive start/stop order, delayed OFF indicator, OTA pending-flag cleanup, and boot reset diagnostic were checked in source.
- [UNVERIFIED] Physical ESP32-C3 flash/update; whether the original restart is eliminated on hardware; physical orange/white LED feedback; Peltier/Fan and thermal regression; Local/Online production OTA regression.
- [NOT RELEASED] Project remains DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED. The `firmware-qc-latest` prerelease is for manual/local QC only; it is not the production OTA release. App Build was not run.

> Older V5.9 sections remain historical; the V6.1 source-only state is recorded above.

## V5.9 APP LOCALIZATION / NOTIFY CLEANUP — 2026-10-07

- Standardized English as the master/reference language for user-facing App copy.
- Synchronized Indonesian translations to the same meaning, context, tone, and severity.
- Replaced user-facing reset/debug wording such as `Reset: POWER_ON` with concise localized status messages.
- Removed raw internal reason presentation from known Peltier, Fan, Adaptive, LED, temperature, connection, and command feedback.
- Made Notify error classification language-aware for English and Indonesian.
- Added explicit `TextDecoration.none` to Home Notify message and status text.
- Standardized core UI terminology around Hotside and Indonesian “Sakelar”.
- Updated localization regression tests.
- App Build and current Flutter analyze/test execution remain unverified.

## V5.9 HOTSIDE RECOVERY / LED QC UPDATE — 2026-10-07

- Changed Adaptive Hotside thermal recovery from 10 seconds to 20 seconds per rail.
- Adaptive Hotside LED now blinks red for the first 19 seconds and blue during the final 1 second before a required step-down.
- If Hotside reaches <= hotLimit - 2°C before the 20-second boundary, the Peltier is allowed to resume on the same Adaptive rail and the LED blinks green 2x.
- Adaptive Hotside now applies the 20-second stage independently at 12V, 9V, and 5V.
- After an unrecovered 20-second 5V stage, Adaptive exits and the Peltier remains locked until thermal re-arm and manual restart.
- Manual Hotside protection now keeps red LED indication active for the entire thermal lock until Hotside reaches <= hotLimit - 2°C, then shows green 2x; the selected Manual voltage is preserved.
- Removed the previous green feedback attached to a successful Peltier ON command so green exclusively communicates thermal re-arm readiness.
- OTA, BLE/P1, selector timing, voltage guard, and Peltier soft-start behavior were not intentionally changed.
- V5.9 compile/BIN/flash/physical/OTA/App integration and release gates remain unverified.

## V5.9 APP + FIRMWARE BLE QC INTEGRATION — 2026-10-06

- Repaired the App 1 Hz PHONE:BT heartbeat into a valid class method with coalescing so only the newest pending value is retained.
- Required `PROTOCOL=P1` in the active BLE session readiness polling gate.
- Command-owned BLE ACK errors no longer emit a competing generic error snackbar.
- Fan→Peltier popup startup now stops after an unconfirmed Fan start; Peltier safety reasons `PELTIER_SAFETY_LATCH` and `HOTSIDE_PROTECTION` retain notification priority.
- Added regression coverage for P1 readiness, stale Peltier re-arm notice clearing, and `ONLINE_IMAGE_VALIDATE` presentation mapping.
- Firmware V5.9 Peltier safety re-arm, Touch, and Adaptive semantics remain aligned; OTA runtime behavior was not changed.
- V5.9 compile/BIN/flash/physical/OTA runtime and explicit App Build remain pending.
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

## V5.8 PELTIER REARM + NTC SINGLE-SAMPLE QC FIX — 2026-10-06
- Promoted Firmware V5.7 → V5.8 for two reproducible QC findings.
- Fixed the Peltier safety-lock state so its effective lock clears automatically once Hotside reaches `hotLimit - 2°C`.
- Preserved the red 1-second LED for blocked Peltier ON attempts while the effective safety lock is active.
- Preserved one-shot green 1-second LED feedback for the first successful Peltier ON after a safety-forced shutdown.
- Replaced the V5.6 16-sample trimmed-mean NTC path with exactly one calibrated ADC reading every 1 second.
- Preserved the existing 10K NTC / 10K resistor / Beta 3950 / 3.3 V conversion model.
- OTA, BLE/P1, GPIO, Adaptive timing, selector timing, voltage guard, and Peltier soft-start were not intentionally changed.
- App source/build was not changed or run for this Firmware-only QC fix.

## OTA PROTECTION REMINDER — 2026-10-06
- Replaced the temporary CI-based OTA Security Seal experiment with the requested repository reminder file OTA_PROTECTION.md.
- Removed the dedicated OTA Seal workflow and manifest/lock files.
- Preserved the existing V5.7 OTA behavior and the policy that any valid firmware version different from the device version may be installed.
- No anti-downgrade policy was introduced.
- No App Build was executed.

## V5.7 TTP223 TOUCH ACCURACY QC FIX — 2026-10-06
- Promoted Firmware V5.6 → V5.7 for a targeted TTP223 touch recognition correction.
- Added 30 ms raw-input qualification for PRESS and RELEASE edges to reject short false transitions.
- Added 60–500 ms valid tap duration using raw HIGH duration.
- Increased double-tap window to 800 ms, starting after the first valid tap release.
- Added second-tap grace: a second tap started before the deadline is allowed to finish after the deadline.
- Preserved 3+ tap cancellation by resolving a double sequence at the decision boundary instead of firing it immediately on the second release.
- Added 1-second startup grace and blocks boot-held touch until a qualified release.
- Preserved the existing 1x voltage, 2x RGB, and 5-second long-press command semantics.
- App source/build was not changed or run for this Firmware-only QC fix.

## V5.6 NTC ADC FILTERING QC FIX — 2026-10-06
- Promoted Firmware V5.5 → V5.6 for a targeted NTC QC correction.
- Replaced single-sample Hotside ADC capture with 16-sample calibrated burst sampling.
- Uses a 50% trimmed mean: discard 4 lowest and 4 highest samples, then average the 8 middle samples.
- Preserved the 3.3 V divider-reference calculation, 10K NTC / 10K resistor / Beta 3950 model, and 1-second sampling cadence.
- Did not add EMA/Kalman temperature filtering, speculative VREF changes, voltage clamping, or offset calibration.
- App source/build was not changed or run for this Firmware-only QC fix.

## V5.5 PELTIER SAFETY REARM LED FEEDBACK — 2026-10-06
- Promoted Firmware V5.4 → V5.5 for a targeted QC correction.
- Removed the normal Peltier ON/OFF green/red LED feedback.
- Re-scoped the Peltier LED to safety re-arm attempts only after Hotside Safety forces Peltier OFF.
- Failed re-arm ON attempts blink red for 1 second; successful re-arm ON attempts at hotLimit - 2°C blink green for 1 second.
- The existing manualPeltierSafetyLatch remains authoritative; it is cleared only after the successful re-arm ON attempt.
- Adaptive start cannot bypass an active Peltier safety latch.
- Hotside dwell LED priority is preserved: 9 seconds red blink + final 1 second green blink.
- App source/build was not changed or run for this Firmware-only QC fix.

## V5.4 HOTSIDE DWELL FAN + LED QC FIX — 2026-10-06
- Promoted Firmware V5.3 → V5.4 for a targeted QC correction.
- Adaptive HOTSIDE safety now keeps Fan ON at 100% through the full 10-second thermal dwell at every rail.
- Completed HOTSTEP transitions keep Fan ON at 100% while Hotside safety is active.
- Hotside dwell LED now blinks red for the first 9 seconds and green for the final 1 second.
- Preserved the 10-second thermal dwell, 5-second Adaptive upward dwell, 200 ms selector deadtime, 1 s voltage guard, and 5-second Peltier soft-start.
- App source and App Build were not changed or run for this Firmware-only QC fix.

## V5.3 ADAPTIVE VOLTAGE RISE DWELL — 2026-10-05
- Promoted Firmware V5.2 → V5.3.
- Both Adaptive profiles (HOTSIDE and HOTSIDE_BATTERY) now wait 5 seconds after every completed upward voltage step before allowing another increase.
- Adaptive activation from the mandatory safe 5V state starts the same 5-second upward dwell.
- Downward Adaptive steps remain immediate.
- The existing cooperative millis() timing model is preserved; no blocking delay/while timing was introduced.
- App source/build was not changed or run for this firmware-only revision.

## V5.2 TOUCH ACK CLEANUP — 2026-10-05
- Corrected the successful hardware Touch cooling OFF acknowledgement to use `OFF` rather than the generic safety reason, preventing a false NOTIFY error.
- Firmware remains V5.2 with the same 1-second Peltier command result indicators and 2°C re-arm latch.
- No App Build was executed.

## APP SAFETY NOTIFY CLEANUP — 2026-10-05
- Unified Peltier safety failure wording around the configured Hotside re-arm threshold.
- Removed retired RAPID_HOTSIDE_RISE notification mapping.
- Touch ON/OFF ACK reasons are treated as valid outcomes and shown cleanly.
- Duplicate generic Peltier failure notices are suppressed when firmware already reports the safety reason.
- No App Build was executed.

## V5.1 PELTIER SAFETY REARM FEEDBACK — 2026-10-05
- Promoted Firmware V5.0 → V5.1 for the requested Peltier restart protection and feedback.
- Manual and 5V Adaptive-terminal Peltier restart stays locked until Hotside reaches hotLimit - 2°C.
- Hardware Touch cooling ON now enforces the same re-arm hysteresis and no longer bypasses the latch.
- Failed Peltier ON attempts blink red for 1 second; successful Peltier ON attempts blink green for 1 second.
- App NOTIFY explains the required re-arm temperature and cleans up ACK success/failure wording.
- No App Build was executed.

## APP HOME FAN SPEED DISPLAY — 2026-10-05
- Fixed Home Fan Speed showing `--` while Adaptive Mode was ON at 12V.
- Adaptive + 12V now displays `100%`, matching the firmware-enforced Fan speed.
- Manual + 12V keeps displaying the configured Fan Speed; Adaptive Fan Speed control remains locked.
- Added regression coverage for Adaptive 12V = 100%, Manual 12V configured speed, and 9V = 100%.
- No App Build was executed.

## APP PELTIER POPUP START — 2026-10-05
- Removed the App-side confirmation wait after FAN:ON when starting Peltier from Fan-OFF through the Safety popup.
- FAN:ON and PELTIER:ON confirmation flows are now started together; the BLE write queue sends FAN:ON first and PELTIER:ON immediately after the Fan write completes, without waiting for Fan telemetry.
- Firmware safety authority and the existing 5-second Peltier soft-start remain unchanged.
- No App Build was executed.

## V5.0 SELECTOR / MOSFET / HOTSIDE LED TIMING — 2026-10-05
- Promoted Firmware V4.9 → V5.0 for the approved voltage-selector and cooling-output behavior revision.
- Voltage selector contract: GPIO3 = 12V Optocoupler/Decoy selector, GPIO4 = 9V Optocoupler/Decoy selector; both selector outputs are OFF for the mandatory 200 ms break-before-make deadtime and are never active together.
- GPIO5 Peltier MOSFET and GPIO6 Fan MOSFET are not forcibly turned OFF during voltage changes; the active Peltier PWM/output state continues through the selector deadtime.
- Fan is forced to 100% at the start of every voltage transition and remains the only allowed speed while transitioning or operating outside 12V.
- Fan Speed commands are accepted only at 12V and are rejected during a voltage transition; returning to 12V does not restore a previous preference and leaves Fan at 100% until the user manually changes it.
- HOTSIDE LED indication now blinks red for the full 10-second timing window at every HOTSIDE protection stage, including the final 5V terminal stage.
- Peltier OFF → ON keeps the existing 5-second cooperative soft-start.
- No App Build was executed as part of this Firmware-only change.

## V4.9 ADAPTIVE HOTSIDE LED — 2026-10-05
- Promoted Firmware V4.8 → V4.9 for the approved Adaptive Hotside LED stage indication.
- The Hotside LED red-blink indicator now fires once for each safety stage: initial hot stage, after a successful 12V → 9V step, and after a successful 9V → 5V terminal step.
- LED indication is event-driven and does not repeat every main-loop iteration while the Hotside limit remains active.
- All V4.8 safety timing and cooling behavior remains unchanged.
- App source/build was not changed by this firmware-only LED revision.

## V4.8 HOTSIDE SAFETY SEQUENCE — 2026-10-05
- Promoted Firmware V4.7 → V4.8 for the approved HOTSIDE-only thermal sequence.
- At 12V Hotside limit: Fan remains ON, Peltier turns OFF, and the controller holds 12V for 10 seconds before stepping to 9V.
- At 9V Hotside limit: Fan turns OFF, Peltier remains OFF, and the controller holds 9V for 10 seconds before stepping to 5V.
- At 5V Hotside limit: Peltier remains OFF as the terminal protection state; Adaptive exits and manual Peltier restart is required after thermal re-arm.
- Manual-mode Hotside protection preserves the currently selected voltage and forces Fan ON / Peltier OFF; it does not force an unrelated voltage change.
- Manual Peltier safety re-arm uses 2°C hysteresis below the configured Hotside limit.
- Rapid Hotside-rise/slope protection remains absent.
- Peltier OFF → ON retains the existing 5-second firmware soft-start.
- Removed the redundant App-side fixed 2-second Fan precharge; the Firmware owns Peltier startup timing.
- No App Build is performed as part of this Firmware execution.
## V4.7 REALTIME TELEMETRY QC FIX — 2026-10-05
- Promoted Firmware V4.6 → V4.7 after hardware/App QC exposed stale realtime Fan/Peltier state in the App.
- Firmware cooling telemetry now uses pre-mutation state snapshots across Touch, Adaptive, safety, voltage completion, and command-setter paths.
- App applies unsolicited FAN/PELTIER/FAN_SPEED telemetry directly to Control state.
- App Home Notify clears stale command/connection errors only after healthy live cooling/safety telemetry; safety warnings remain visible.
- Home Notify warning presentation is gated by active BLE connection.
- Added regression coverage for realtime Notify reconciliation.
- No App Build was executed.
- V4.7 is NOT RELEASED pending compile/BIN/flash/OTA and App integration QC.

## APP CONTROL PRECHARGE — 2026-10-05
- Added a 2-second Fan precharge interval when the user requests Peltier ON while Fan is OFF.
- App now waits for confirmed FAN=ON telemetry before starting the 2-second interval.
- After the interval, App re-validates BLE connection, Adaptive OFF, and Fan ON before sending PELTIER:ON.
- Fan already ON remains an immediate Peltier-start path; no extra delay is added.
- Added a regression test locking the precharge duration to exactly 2 seconds.
- Firmware source, Firmware behavior, BLE protocol tokens, and App Build workflow were not changed.

## QC / PRE-RELEASE MODE — 2026-10-05
- V4.6 code is complete and the project is now in QC / PRE-RELEASE.
- Functional source is frozen during QC unless a demonstrated defect requires a targeted fix.
- The next release gate is Firmware V4.6 compile → BIN → flash → Hardware QC.
- V4.6 is not released.

## V4.6 — 2026-10-05
- Promoted the active Firmware source from V4.5 to V4.6 for the approved hardware control changes.
- Changed hardware single-tap voltage selection to the requested bounce sequence: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON via touch now forces Fan PWM to 100%.
- Preserved the existing Peltier OFF → ON 5-second soft-start.
- Preserved BOOT_AP_HARD_LIMIT_MS at 60 seconds.
- Removed Rapid Hotside-rise protection, including its dedicated slope threshold, event flag, and Hotside history state.
- Preserved normal Hotside temperature-limit safety.
- Preserved Local OTA, Online OTA, BLE/P1, Adaptive, RGB, telemetry, and App behavior.
- No App Build was executed for this Firmware-only change.

## VERIFIED RELEASE BUILD — 2026-10-05
- Workflow run 37245703677 completed successfully from source commit fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- All build, analysis, test, obfuscated release compilation, and production signing gates passed.
- GitHub Release `jexfyz-latest` now contains exactly one asset: `JEXFYZ-release.apk`.
- Release asset ID: 610989112; size: 54,327,520 bytes; SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- No Actions artifact was created.

## RELEASE DELIVERY RESTORE — 2026-10-05
- Converted the restored reusable App Build engine from Actions-artifact delivery back to direct GitHub Release delivery.
- Engine now requires `contents: write`, publishes exactly one `JEXFYZ-release.apk` under `jexfyz-latest`, and replaces the existing asset with `--clobber`.
- Trigger workflow was raised to `contents: write` so the reusable workflow can publish the Release.
- No App/Firmware runtime source was changed.
- This execution includes an explicit Build App run to verify the new Release delivery path.

## APP BUILD WORKFLOW RESTORE UNDER NEW NAMES — 2026-10-05
- Restored the proven two-workflow App Build architecture without reusing the legacy filenames.
- Manual trigger: `.github/workflows/jexfyz-app-build-trigger.yml`.
- Reusable build engine: `.github/workflows/jexfyz-app-build-engine.yml`.
- The restored engine is based on the Build #50-era verified configuration: Java 17, Flutter 3.47.2, Gradle 9.3.1, production signing verification, obfuscated release APK, Actions artifact for the APK, and Dart symbols artifact.
- The previous `.github/workflows/jexfyz-build.yml` single Release-asset workflow was removed.
- No App Build was started by this execution; this is a workflow/configuration restore only.
- App/Firmware runtime source was not changed.

# JE X FYZ — CHANGELOG

## CI ARTIFACT QUOTA FIX — 2026-10-04
- Replaced Actions-artifact APK delivery in `.github/workflows/jexfyz-build.yml` with direct GitHub Release asset publication.
- Workflow permission changed from `contents: read / actions: write` to `contents: write`.
- Exactly one delivery asset is maintained as `jexfyz-latest / JEXFYZ-release.apk`; existing assets are replaced with `--clobber`.
- This removes Actions-artifact storage quota from the APK delivery path.
- App/Firmware runtime source was not changed.
- Workflow run #2 verified the new Release asset path end-to-end.
- Existing Release updates now retarget `jexfyz-latest` to the current build commit and keep it marked Latest.


## SINGLE WORKFLOW / BUILD RUN #1 — 2026-10-04
- Deleted the legacy `.github/workflows/app-build.yml` and `.github/workflows/app-build-trigger.yml`.
- Created the new single `.github/workflows/jexfyz-build.yml`, based directly on the former App Build engine and gated by the dedicated owner/title/token issue trigger.
- Build run 37199918015 completed security/architecture audit, dependency installation, Dart analysis, Flutter tests, release APK compilation, production signing verification, and filename preparation successfully.
- Artifact upload was blocked by GitHub Actions artifact storage quota; no downloadable artifact was created.

## APP BUILD RUN #2 — VERIFIED — 2026-10-04
- Workflow run: 37201925842
- Source commit: 9136f11799143d91eb58e947ea10e9e576bb579f
- All App CI/security/build/signing gates passed.
- GitHub Release `jexfyz-latest` was updated successfully with exactly one asset: `JEXFYZ-release.apk`.
- Release asset ID: 609813273
- APK size: 54,327,520 bytes
- APK SHA256: 24fcd6f4d1f7843f34e8a31c352b43f23a581b57fc2d29ae71053eb7924092bb
- No Actions artifact was created by this run.

## V4.5 — 2026-10-04
- Promoted the active firmware source from V4.4 to V4.5 for functional hardening.
- Fixed explicit Online OTA GATT disconnect ordering so an active BLE session is closed before Wi-Fi radio handoff.
- Made OTA_UP_TO_DATE a one-shot LAST_OTA_RESULT event.
- Gated rapid Hotside-rise protection on Peltier being ON.
- Removed dead firmware state/legacy comparator and generated documentation noise.
- Synchronized App OTA recovery, safety presentation, Adaptive Ceiling, battery limits, and current OTA stage mapping.

## BUILD APP WORKFLOW RESET — 2026-10-04
- Deleted and recreated both App Build workflows.
- Historical workflow reset used Actions-artifact cleanup; current delivery uses GitHub Release asset publication.
- Trigger workflow remains manual issue-based and is restricted to the repository owner.

## BUILD APP CI — 2026-10-04
- Build #51 failed during Dart analysis because _startCloudOta was missing its closing brace; fixed in commit ea5261230245fc86061cdf85f65ccd0208e607d3.
- Build #52 confirmed App compilation and signing were correct; its workflow failed on a shell pipefail/SIGPIPE signing-output pipeline and was fixed in commit e33141efd47b8f1ca025e832097e1106d9119b65.
- Build #53 passed audit, analysis, tests, APK compilation, and production signing verification, then failed only because GitHub Actions artifact storage quota was exhausted.
- Current App build workflow publishes one replaceable direct GitHub Release asset and no separate symbol asset.

## V4.4 — 2026-10-04
- Added explicit active BLE GATT disconnect before Online OTA Wi-Fi handoff.
- Preserved the V3.2-style Online OTA transport/retry/result-indicator behavior.
- User subsequently confirmed V4.4 Local OTA and Online OTA success.

## V4.3 — 2026-10-04
- Restored Online OTA to the pre-yellow V3.2-style path.
- Removed yellow progress indicators and V4.2 cumulative passive Wi-Fi retry.
- User confirmed Local OTA and Online OTA success.

## V4.2 — 2026-10-04
- Introduced cumulative Online OTA Wi-Fi connection handling.
- Superseded by V4.3 rollback.

## V4.1 — 2026-10-04
- Simplified Online OTA Wi-Fi retry architecture.
- Superseded by V4.3 rollback.

## V4.0 — 2026-10-04
- Firmware hardening baseline before the V4.1–V4.3 OTA iterations.

## PRE-V4
- V3.3 introduced the yellow Online OTA progress layer.
- V3.2 is the exact pre-yellow Online OTA baseline.
`````

---

## Archived file: `OTA_PROTECTION.md`

- Original blob: `b68b762c618ed78b6f1c20fa133b58b26eff97bc`
- Purpose preserved: Previous OTA protection note before current-state/history separation

`````markdown
## CURRENT V6.4 EXECUTION STATUS — 2026-10-14

- [VERSION ALIGNMENT — SOURCE ONLY] Active source is `firmware/JEXFYZ-V6.4.ino` with `FW_VERSION = "V6.4"`; the V6.3-named active file is retired. This revision has not been compiled; no BIN generation, flash/OTA, Firebase update, or release is implied.

### Current Online OTA connection path — 2026-10-13

- [SOURCE FIX IMPLEMENTED] V6.3 Online OTA restores the previous `cloudClient.setInsecure()` connection path. The inline ISRG Root X1 certificate, CA validation call, `configTime()`, `TIME_SYNCING` state, and 20-second NTP gate were removed. On Wi-Fi connection, the blue indicator runs directly before the GitHub GET attempt.
- [PRESERVED] The HTTPS transport, raw GitHub BIN URL allowlist for `TenzoNkz/JEXFYZ-Firmware`, redirect blocking, download size/image checks, safe-output sequencing, and OTA recovery path remain in place. `setInsecure()` does not validate the server certificate identity.
- [TEST CONTRACT UPDATED — NOT RUN] `test/v6_4_qc_contract_test.dart` now asserts the restored connection path, removal of CA/NTP gates, blue-before-GitHub flow, and retention of the URL allowlist/redirect block.
- [USER-REPORTED RESULT — 2026-10-13] The user reports that V6.3 compiled successfully after this correction and Online OTA can connect to GitHub again. This confirms the reported compile/connect result only; a complete BIN transfer, successful `Update.end()`, reboot, and confirmation of the new firmware version were not separately established here. Because CA validation and the OTA-only NTP gate were removed together, the available evidence does not isolate which one alone caused the earlier failure.
- [CANONICAL REGRESSION MEMORY] Read [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md) before any Online OTA transport/TLS/time-sync change; it records the incident, evidence boundary, trade-off, and prevention rules.
- [NOT DONE BY ASSISTANT] No firmware compile, BIN generation/publication, flash, physical OTA run, or APK Build was performed by this assistant session.

### APP BLE reconnect and Online OTA acknowledgement follow-up — 2026-10-13

- [FIXED IN APP SOURCE] Disconnect rediscovery now avoids starting when Auto Connect is disabled or no previously paired cooler identity is known. The retry loop is cancelled when Bluetooth/permissions/location prerequisites fail, and scanning is suppressed during BLE syncing. Retry starts again when Auto Connect is enabled or the app resumes while disconnected.
- [FIXED IN APP SOURCE] A missing `CLOUDOTA` ACK due to `TIMEOUT` or `DISCONNECTED` is treated as ambiguous, not as a definite rejection. The app preserves OTA recovery state and tells the user it is waiting for reconnection or an OTA result. A definite rejection while BLE remains connected still follows the rejection path.
- [REGRESSION CONTRACTS ADDED — NOT RUN] `test/v6_4_qc_contract_test.dart` now checks both retry-loop cancellation and ambiguous OTA ACK handling. No Flutter tests or Dart analysis have run for this change because this environment has no Flutter/Dart executable.
- [PRESERVED BY USER INSTRUCTION] `android/app/build.gradle` still has `versionName "Telegram @horizontalzzz"` as the user's intentional identity. It was not modified.
- [VALIDATION BOUNDARY] Source and contract assertions were reviewed statically only; the user separately reports a successful firmware compile and restored GitHub connection. No Build App/APK build, BIN publication, flash, complete OTA install, or hardware validation was performed by this assistant session.

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.4.ino`, blob `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. User-reported compile success and restored GitHub connectivity are recorded above, but a complete OTA transfer/apply/reboot proof is not established here. No BIN generation/publication, assistant-side flash, independent hardware validation, Android BLE pairing, or APK Build was performed.
- [NOT RELEASED] V6.4 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

## HISTORICAL V6.2 OTA EXCEPTION — 2026-10-13

- Online OTA was explicitly approved for standard CA certificate verification to the already allowlisted GitHub raw BIN repository. The allowlist and existing download/update steps remain in place.
- Local OTA is explicitly unchanged: no checksum, signature, or additional verification layer was added.
- BLE write encryption/bonding was added because Online OTA credentials travel over the BLE command channel.
- V6.2 OTA paths remain uncompiled and untested on hardware. No APK build, Firmware compile, BIN, flashing or OTA operation was performed.
- This exception authorizes only the discussed Online HTTPS and BLE write protections; it does not grant broader OTA redesign.

# JE X FYZ — OTA PROTECTION

> 🔐 **OTA PROTECTED / FROZEN**

Dokumen ini adalah **segel pengingat engineering** untuk jalur OTA JE X FYZ.
Tujuannya mencegah perubahan OTA secara tidak sengaja saat kita memperbaiki fitur lain.

## 🚫 Jangan ubah sembarangan

Bagian berikut dianggap **protected**:

- Local OTA
- Online OTA
- OTA state machine
- OTA priority / lifecycle
- Wi-Fi ↔ BLE radio handoff
- OTA recovery setelah gagal
- OTA safety output
- OTA timeout dan retry logic
- Image validation
- Firmware OTA URL/path contract
- App OTA version-selection contract

**Jangan melakukan refactor, cleanup, optimasi, atau perubahan kecil pada OTA hanya karena sedang mengerjakan fitur lain.**

## ✅ Perubahan OTA hanya jika

1. Ada bug OTA yang benar-benar terbukti.
2. Root cause sudah jelas.
3. Perubahan dibahas dan disetujui secara eksplisit.
4. Setelah perubahan, seluruh jalur OTA diaudit ulang.

## 📌 Kontrak versi

**ANTI-DOWNGRADE: OFF**

Versi firmware yang **valid dan berbeda** dari versi perangkat boleh di-update.

Contoh:

- V5.7 → V5.8 ✅
- V5.7 → V5.6 ✅
- V5.7 → V6.0 ✅
- V5.7 → V5.7 ❌ tidak perlu update

Jadi segel ini **tidak** mengubah kebijakan versi OTA.

## 🔒 Kondisi baseline

OTA V5.7 berhasil digunakan untuk memperbarui hardware pada tahap historis sebelumnya.
Active source saat ini adalah V6.2 dan tetap source-only: belum dikompilasi, dibuat BIN, diflash, atau divalidasi pada hardware:

`firmware/JEXFYZ-V6.2.ino`

Keberhasilan OTA V5.7 adalah bukti historis untuk V5.7 saja, bukan bukti bahwa OTA V6.2 telah lulus hardware validation.

Dokumen ini **bukan** cryptographic signature, bukan CI enforcement, dan bukan pengganti pengujian OTA pada hardware.

### Prinsip utama

> **OTA sudah bekerja — jangan disentuh kecuali ada alasan OTA yang nyata.**

## HISTORICAL — V6.2 Online OTA TLS/CA clock validation (superseded by V6.3) — 2026-10-13

- [HISTORICAL / SUPERSEDED] V6.2 Online OTA synchronized system time before CA-validated HTTPS. This is no longer the active V6.3 connection path.
- Redirects were disabled for the direct raw GitHub BIN endpoint; CA validation and the NTP gate were subsequently removed by the V6.3 legacy-path restoration.
- Repository allowlist remains limited to `TenzoNkz/JEXFYZ-Firmware`; no custom firmware SHA/signature is added; Local OTA remains unchanged.
- The unapproved temporary quality workflow was removed after it failed to push a generated lockfile; test/analyze steps were skipped and no lockfile was committed.

`````

---

## Archived file: `OTA_REGRESSION_MEMORY.md`

- Original blob: `904099dd44d704fca8566ad47905ba1a13388a5c`
- Purpose preserved: Previous OTA incident memory snapshot

`````markdown
# JE X FYZ / JE Cooler — Online OTA Regression Memory

Last updated: 2026-10-14 (Asia/Jakarta)
Status: The Online OTA correction was introduced in the V6.3 revision and remains in active V6.4 source; compile and GitHub-connect recovery were user-reported; full OTA apply/reboot is not independently verified.

## 1. Incident and observed symptom

- Active source of truth is `firmware/JEXFYZ-V6.4.ino` in this repository, not the BIN-only production repository.
- The V6.3 Online OTA path contained an inline ISRG Root X1 PEM constant named `GITHUB_ROOT_CA`, configured via `cloudClient.setCACert(GITHUB_ROOT_CA)`.
- The same path introduced an OTA-only asynchronous NTP gate: `configTime(0, 0, "pool.ntp.org", "time.google.com")`, `OnlineOtaFlow::TIME_SYNCING`, and a 20-second timeout.
- User-reported symptom: Wi-Fi reached the connected state and the first blue indicator appeared, then a red indicator appeared at the GitHub connection stage. The device could not continue to the GitHub BIN response/download.
- Do not invent an HTTP/TLS error code: no serial diagnostic transcript establishing a specific error code was supplied.

## 2. Correction applied to V6.3

Commit: https://github.com/TenzoNkz/JEXFYZ-App/commit/a87bbcecdca26b3648abff9cb88937e250b41f1f

Active source blob after correction: `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`

- Removed the `GITHUB_ROOT_CA` PEM declaration and `setCACert()` call.
- Restored `cloudClient.setInsecure()` for the Online OTA HTTPClient/TLS connection.
- Removed the OTA-only `configTime()`, `TIME_SYNCING` state, epoch-validity condition, and 20-second NTP timeout gate.
- Restored the observed sequence: Wi-Fi connects → blue indicator → `prepareOnlineOtaDownload()` → GitHub GET attempt.
- Kept the target repository URL allowlist (`https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/`), redirect blocking, HTTP response/length checks, OTA size limit, ESP image magic-byte check (`0xE9`), streaming download, safe output shutdown, OTA lifecycle, and failure recovery.
- The OTA contract source was updated in commit https://github.com/TenzoNkz/JEXFYZ-App/commit/dc0d6ec13d3f58ab864e006e7defb543fd4752b6. Live test blob: `bf9d96cf671547e48465525c4661e48afd9863ee`. The Flutter test itself has not been run.

## 3. User confirmation and exact evidence boundary

- [USER-REPORTED — 2026-10-13] User reports V6.3 compiled successfully after the correction and Online OTA could connect to GitHub again.
- [NOT INDEPENDENTLY VERIFIED HERE] No build log or serial log was inspected by the assistant. The user report must be preserved as a user report, not upgraded to an assistant-performed compile/test.
- [NOT CONFIRMED AS END-TO-END] A complete BIN body transfer, successful `Update.end()`, reboot, and post-reboot firmware version confirmation were not separately established in this record.
- [NO ASSISTANT-SIDE RELEASE] The assistant did not compile the firmware, generate or publish a BIN, flash hardware, run physical OTA, edit Firebase release metadata, or Build App as part of this correction.
- The user attributes the failure to the CA trust addition. Technically, the CA validation and the OTA-only NTP gate were removed in the same correction; therefore this is strong before/after evidence for the combined CA/TLS/time-gated path, but it does not isolate whether the CA PEM alone or the added NTP gate alone caused the failure. Do not rewrite this as a proven single-variable experiment.

## 4. Security decision made for the current build

The user explicitly chose to restore the previous `setInsecure()` connection behavior because the CA-based Online OTA path failed in their observed environment.

Important consequence: `setInsecure()` still encrypts the TLS channel but skips peer certificate identity validation. URL allowlisting and redirect blocking constrain the requested URL/flow but do not cryptographically authenticate the GitHub server. Preserve the user-approved current behavior unless the user asks for a security redesign; do not silently re-add a CA, certificate pinning, or NTP dependency.

## 5. Regression-prevention rules

1. **Freeze the Online OTA transport baseline.** Do not add/remove a CA root, change `setInsecure()`/certificate validation, add time synchronization, or add a TLS state to the OTA state machine without prior discussion and explicit user approval.
2. **One transport change at a time.** If a future experiment is authorized, record the exact source diff and diagnostic stage/result; change one variable at a time so the actual cause can be distinguished.
3. **Do not infer a GitHub error from LEDs alone.** Blue then red narrows the failure stage, but the exact error needs `otaDiagnosticStage`, `otaDiagnosticErrorCode`, `otaDiagnosticError`, HTTP response code, or a serial/device log.
4. **Protect OTA behavior.** Preserve Wi-Fi↔BLE single-radio handoff, safe outputs, retry/timeouts, raw BIN URL allowlist, redirect policy, stream/size/image validation, Update lifecycle, failure recovery, and final restart path. Unrelated work must not refactor this code.
5. **Keep tests aligned with the chosen baseline.** Static regression checks should assert `setInsecure()` exists exactly on the Online OTA client path; the CA PEM and OTA-only NTP gate are absent; blue feedback leads to the GitHub connection attempt; the allowlist and redirect blocking remain. A test file is not evidence that the test ran.
6. **Separate source from release artifact.** Canonical source is in `TenzoNkz/JEXFYZ-App/firmware/JEXFYZ-V6.4.ino`. `TenzoNkz/JEXFYZ-Firmware` is an artifact repository containing `JEXFYZ.cpp.bin`; do not assume its BIN matches current source unless build provenance or matching hashes/version are verified.
7. **Authorization boundaries remain active.** User compiles firmware. Do not trigger Build App, firmware compile, BIN generation/publication, flashing, physical OTA, Firebase/production metadata update, or release unless separately and explicitly requested.
8. **Record status precisely.** The current known fact is user-reported compile success and restored GitHub connectivity. End-to-end installation is a separate QC gate until confirmed.

## 6. Current source audit

At commit/source blob `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`, static inspection found:
- one `cloudClient.setInsecure()` call in the GitHub OTA preparation path;
- no `GITHUB_ROOT_CA`, embedded certificate PEM, `setCACert()`, `configTime()`, `TIME_SYNCING`, or OTA-only NTP time gate;
- target raw GitHub firmware URL prefix allowlist retained;
- `HTTPC_DISABLE_FOLLOW_REDIRECTS` retained;
- normal GitHub GET and failure-handling path retained.

This is a static source audit only; it is not a firmware compile, runtime test, or full OTA success certificate.

`````

---

## Archived file: `VOLTAGE_TRANSITION_MEMORY.md`

- Original blob: `a63eb7c83062b4185f436ca3cf02cdb171a37d1b`
- Purpose preserved: Previous voltage-transition incident memory snapshot

`````markdown
# JE X FYZ / JE Cooler — Voltage Transition & Peltier Soft-Start Memory

Updated: 2026-10-14 (Asia/Jakarta)
Status: Active-ramp-only pause and uninterrupted 100% Peltier duty implemented in V6.4 source; compile/test/runtime/hardware result not yet validated for this revision.
Active source blob: `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`.
Regression contract blob: `f071c9642c1a06726d25b8c26a814845b02a55d6`.

## Incident report

[USER-REPORTED — 2026-10-13] The physical hardware restarted when changing from 5 V to 12 V with Peltier and Fan ON while the 5-second Peltier soft-start was still active. The exact reset reason from that reproduction has not been supplied. A supply transient/brownout remains a plausible hypothesis, not a confirmed cause.

## Current transition contract

This rule applies to normal voltage changes requested in Manual Volt and while Adaptive is active. It is based on the Peltier ramp state **when the voltage transition is accepted**:

1. If Peltier is logically ON and `peltierSoftStarting` is true, save that state and force physical GPIO5 PWM to 0% before selector outputs are de-asserted. Preserve the logical ON request so the App does not report a false OFF. If soft-start has already completed, do not write PWM 0%—keep physical Peltier PWM at 100% throughout the selector transition. Fan remains enabled and is forced to 100%.
2. Keep the existing 200 ms break-before-make selector interval.
3. For a paused in-progress ramp only, retain the existing 1,000 ms rail-settle wait through `PELTIER_VOLTAGE_SETTLE_MS = VOLTAGE_GUARD_MS`. A completed 100% ramp is not paused and needs no Peltier-resume wait.
4. If the saved flag says the 5-second soft-start was still in progress, begin a **new full 5-second ramp from 0%** after settling.
5. If the saved flag indicates soft-start had already completed, keep **100% PWM running continuously** through the transition; do not pause Peltier, force 0%, or add another 5-second ramp.
6. If Peltier is OFF, do not enable it because of a voltage change. If an explicit Peltier-OFF request, thermal/sensor safety, or OTA safe-output path stops it during the transition, clear the saved resume state so it cannot restart automatically.
7. Adaptive entry/exit remains its separate safe-5V mode handoff: it intentionally switches Peltier OFF and, when allowed, restores it through the normal OFF→ON 5-second soft-start. Adaptive's subsequent ordinary rail changes use the conditional rule above. Adaptive thermal HOTSTEP safety may deliberately force Peltier OFF and must take priority.
8. The transition remains cooperative/non-blocking; no `delay()` or timing `while()` is introduced.

## Timing contract

- Selector break-before-make: 200 ms.
- Paused in-progress ramp: remain at 0% through the 1,000 ms post-selector settle, then start a fresh 5,000 ms soft-start.
- Already-completed ramp: maintain 100% PWM throughout selector deadtime and completion, unless OFF/safety forces shutdown.
- The 1-second interval is an existing software guard, not laboratory proof of the rail's electrical settling time. Hardware validation remains required.

## Regression safeguards

- In `requestVoltage()`, accepted transition state is recorded before `pausePeltierForVoltageTransition()`; the pause must happen before selector outputs are switched OFF.
- `pausePeltierForVoltageTransition()` must return without writing PWM or setting a pending pause when `peltierSoftStarting` is false; that state means the normal ramp has completed and the Peltier should remain at 100%.
- If `peltierSoftStarting` is true, save the interrupted-ramp flag before clearing the active ramp and forcing PWM to 0%.
- While `voltageTransition` is active, Peltier processing must only hold PWM at 0% when `peltierVoltagePauseActive` is true. A completed ramp must not be zeroed by the transition gate.
- After `PELTIER_VOLTAGE_SETTLE_MS`, resume only the captured in-progress ramp with a fresh 5 s soft-start; the completed-ramp path remains at 100% throughout and has no pending resume.
- `stopPeltierOutput()` must clear both pending pause and saved-resume state.
- Preserve the 200 ms deadtime, 1-second guard, 5-second OFF→ON soft-start, Hotside/sensor safety latches, safe output path, and cooperative main loop.
- Keep serial boot diagnostics and App `RESET_REASON` telemetry for `BROWNOUT`. If the hardware restarts again, record `BOOT: RESET_REASON=...` and the App telemetry before drawing a stronger root-cause conclusion.

## Validation status and release boundary

- [SOURCE FIX IMPLEMENTED] V6.4 pauses Peltier only when a voltage transition interrupts an active ramp; already-completed soft-start keeps PWM at 100% through the voltage change.
- [REGRESSION CONTRACT UPDATED — NOT RUN] The static Flutter test contract checks state capture, ordering, both resumption paths, stop-state cleanup, timing, and reset-reason diagnostics.
- [STATIC REVIEW ONLY] No firmware compile, Dart/Flutter test, physical reproduction, supply/current measurement, thermal regression, or repeated Manual/Adaptive rail test has been performed for this revision.
- The earlier user-reported compile result applied to a prior V6.3 revision and does not certify the current source.
- No BIN was generated or published, no Firebase metadata was changed, and no device was flashed or OTA-updated by this change.

## Future-change rule

Do not unconditionally pause Peltier on every voltage change, restart soft-start after it had completed, or bypass Peltier-OFF/safety cancellation. Any transition timing or behavior change must update the source-level contract and this memory first. Reset causality remains a hypothesis until real diagnostics and, ideally, supply/Peltier current measurements support it.

`````

