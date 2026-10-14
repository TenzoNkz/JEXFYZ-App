# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Snapshot date: 2026-10-14 (Asia/Jakarta). This detailed transfer file bridges project memory across chats. It is a snapshot, NOT a substitute for fetching live GitHub state; all hashes and status need rechecking after later commits.

## 0. New-chat boot — mandatory order

1. Read this entire CHAT_TRANSFER.md first, from first line to last line.
2. Fetch live main HEAD, full recursive tree, every current source/config/test/workflow/document path and blob SHA, exactly one active Firmware .ino and its FW_VERSION, App source/package/version, Actions run IDs plus head SHAs, open/closed PR and branch state, and artifact repository root.
3. Read MEMORY_INDEX.md, CHAT_RULES.md and PROJECT_STATE.md completely.
4. Read all relevant canonical notes in full: App → APP_NOTES.md; Firmware/hardware → FIRMWARE_NOTES.md + firmware/FIRMWARE_TECHNICAL_REFERENCE.md; OTA → OTA_PROTECTION.md + OTA_REGRESSION_MEMORY.md; Peltier/rail change → VOLTAGE_TRANSITION_MEMORY.md; Build App → BUILD_NOTES.md + workflow; approved visuals → DESIGN_NOTES.md.
5. Read HANDOVER.md for exact next actions and CHANGELOG.md for history. Do not rely only on remembered chat summaries where repository evidence exists.
6. At context/chat limit, use Prompt A in CHAT_TRANSFER_PROMPTS.md: read this old transfer fully, reconcile all files with live main, then replace this file once at the end. Do not append another current-state block.
7. Do not ask the user to repeat a saved decision. Search archives/Git history to recover missing historical detail, then place it in one canonical file with a correct evidence label. Never guess. All three archive documents are forensic-only and their old internal CURRENT lines are not live truth.
8. Audit every text, Markdown, source, configuration, workflow and test file in the repository. Check every Markdown link and every renamed path/version/workflow/test reference. Read complete relevant files, not just first-line excerpts.

## 1. Repository checkpoint immediately before this transfer refresh

- Canonical repository: TenzoNkz/JEXFYZ-App, private, branch main.
- Main HEAD immediately before this transfer write: 2d01ef02051e1098d53e0ebcfd590f88decc02f0. This snapshot will be written last; its resulting commit must have this exact commit as parent. Re-fetch final HEAD and verify parent after saving.
- Last live open-PR search returned 0. Branches observed: diag/latest-stable-v16, diagnostic/v1.6-heap-check, fix/adaptive-power-sequencing, main, tmp-jexfyz-v5-test. Continue on main by default.
- Closed-PR search returned #18, #7, #5, #4, #3, #2, #1. The connector’s closed-PR records do not reliably expose merge status; do not infer merged/unmerged from closure alone.
- Active firmware source: firmware/JEXFYZ-V6.4.ino. FW_VERSION = "V6.4". Source blob: f0dd9d1ebdc7d9d0966384f557efa2e2123df792. Exactly one active versioned .ino was found.
- Active App source: lib/main.dart, blob 535e396005a3bd1429db3096c627d87043b0e1b4.
- App package/version: com.horizontalzzz.jexfyz / 1.0.0+3.
- Android Gradle versionName "Telegram @horizontalzzz" is intentional identity text and must remain unchanged.
- Test paths: test/v6_4_qc_contract_test.dart; test/firmware_touch_adaptive_sync_test.dart; test/app_protocol_notify_contract_test.dart; test/widget_test.dart. These exist; existence does not mean execution. All four are still unrun during this memory task.
- Active build workflow: .github/workflows/jexfyz-app-build-trigger.yml, blob 7c41358311be195d43f011c1e9a4da98772fcb7d. Issue opened/reopened only; exact title JE X FYZ — BUILD APP TRIGGER plus token JEXFYZ_BUILD_TRIGGER_V1; no push/PR trigger. Toolchain Java 17 / Flutter 3.47.2 stable / Gradle 9.3.1; current workflow runs analyze, Flutter tests, one obfuscated signed APK build, certificate verification and release-asset verification. Re-fetch before every authorized build.
- Artifact repo TenzoNkz/JEXFYZ-Firmware latest observed HEAD ac6445bd5284c15d0fd66897213d1b6c68a1c729; root contains exactly JEXFYZ.cpp.bin, blob c1a6e1fe84967944d5e0f4ff85c92fbc265e2f88, size 1455936 bytes. No README/note/source files exist there. BIN is untouched and provenance matching V6.4 is unverified.
- Phase: DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED.
- This full memory/doc reconciliation did not run Flutter tests/analyze, compile Firmware, build App/APK, create/replace BIN, edit Firebase, flash/OTA hardware or release. Current V6.4 remains source-only and NOT RELEASED.

## 2. Permanent user commands and authorization limits

- @Thinking Diskusi! = inspect/explain/compare/recommend only. No repository writes.
- @Thinking Tanya Gemini! = diagnosis/patch-request context; normally precise OLD → NEW patch.
- @Thinking Eksekusi! = execute the discussed narrow scope plus directly related audit and memory synchronization.
- @Thinking Eksekusi Full! = approved change, full related audit/tests/contracts/docs/memory and final verification. It does not imply Build App or Firmware compile.
- @Thinking Build App! = explicit App Build authorization.
- @Thinking Eksekusi & Build App! = approved source task followed by explicitly requested App Build.
- Separate explicit authorization is required for App Build, Firmware compile/build, BIN creation/publication/replacement, Firebase/production metadata change, flashing, physical OTA and release.
- The user compiles Firmware themselves; do not compile on their behalf unless separately instructed.
- Prefer direct commits to main; don't create a branch or PR unless user asks.
- Preserve Android versionName "Telegram @horizontalzzz".
- Never claim write/test/build/compile/flash/OTA/installed-version/release success without matching live evidence.

## 3. Canonical repo split and memory map

TenzoNkz/JEXFYZ-App is the single canonical home for App source, editable firmware .ino, all docs, memory, design decisions, transfer prompts and changelog.

- README.md: overview + navigation.
- MEMORY_INDEX.md: boot order, canonical file map and evidence/source hierarchy.
- CHAT_RULES.md: permanent commands, authorization, version rule, repository separation and memory discipline.
- PROJECT_STATE.md: current-only status and unresolved validation gates; no historical dumps.
- CHAT_TRANSFER.md: detailed context bridge, replaced as a whole at context limit.
- CHAT_TRANSFER_PROMPTS.md: Prompt A chat-limit reconciliation, Prompt B new-chat boot, Prompt C persist a decision, plus category-by-category memory checklist.
- HANDOVER.md: concise exact next actions.
- APP_NOTES.md: UI, BLE/P1, telemetry, reconnect, localization and App-side OTA-ACK behavior.
- FIRMWARE_NOTES.md: board, wiring, sensors, cooling, Adaptive, timing, safety.
- firmware/FIRMWARE_TECHNICAL_REFERENCE.md: code-level architecture/static invariants; replaces retired firmware/FIRMWARE_ANALYSIS.md.
- OTA_PROTECTION.md: protected OTA logic and approval/audit gate.
- OTA_REGRESSION_MEMORY.md: Online OTA incident, current transport, security trade-off and evidence gap.
- VOLTAGE_TRANSITION_MEMORY.md: Peltier ramp branching, rail timing, incident and hardware QC.
- BUILD_NOTES.md: explicit App Build workflow and release constraints.
- DESIGN_NOTES.md: approved grille, monogram, asset proportions and image editing boundaries.
- CHANGELOG.md: curated historical milestone ledger; superseded approaches must be labelled.
- archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md: verbatim old status/reference docs for forensic recovery only; it contains contradictory stale claims.
- archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md: verbatim prior prompt/rules/transfer/history/OTA notes for forensic recovery only.
- archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md: verbatim artifact-repo notes copied before enforcing BIN-only.
- Old archive content is never current truth. Recover a missing old fact from archives/Git history and transfer only that fact into its proper active note.

TenzoNkz/JEXFYZ-Firmware must contain JEXFYZ.cpp.bin only. Do not re-add a README, firmware source, memory or notes there. Current observed BIN SHA: c1a6e1fe84967944d5e0f4ff85c92fbc265e2f88. Do not replace it without explicit authorization and verified provenance.

## 4. Firmware version policy — mandatory

- Every functional Firmware source change bumps FW_VERSION.
- The active .ino filename must exactly match FW_VERSION, with exactly one active versioned .ino.
- Documentation-only edits do not require version bump.
- A source version bump/file rename does not prove a BIN build, Firebase promotion, flash, OTA or release.
- Correct sequence: functional source edit → bump version/rename filename → update tests/docs/hash refs → static audit → user compiles with ArduinoDroid + Arduino-ESP32 Core 3.3.7 → verify BIN provenance → only with separate authorization consider OTA/Firebase/flash/release and physical validation.
- Keep cooperative millis() timing; no executable delay() or timing while() loop.
- A reboot symptom does not prove brownout; capture BOOT: RESET_REASON=... / RESET_REASON telemetry.

## 5. Hardware and sensor memory

- Board: ESP32-C3 Super Mini / ESP32-C3 Dev Module; 3.3 V logic. Wi-Fi and BLE share one radio path.
- GPIO0 = Hotside NTC; GPIO1 = TTP223 touch; GPIO3 = 12 V selector; GPIO4 = 9 V selector; GPIO5 = Peltier MOSFET; GPIO6 = Fan MOSFET; GPIO7 = WS2812.
- MOSFET wiring remembered: GPIO → R100 → Gate; 100 kΩ Gate–Source pull-down. Fan positive to supply (earlier wiring note called it “Decoy”), fan negative to MOSFET Drain. Verify physical wiring/cabling before assuming software; a past 12 V selection problem was later found to be a loose cable.
- NTC: nominal 10 kΩ + 10 kΩ fixed divider resistor; Beta 3950; 3.3 V divider assumption. Use calibrated analogReadMilliVolts(PIN_NTC), one sample every second. The user rejected median, trimmed mean and all multi-sample averaging; do not re-add.
- NTC invalid/fault safety: Peltier OFF, Fan 100%, Adaptive OFF, selector safe at 5 V according to current source contract.
- Hotside limit range 40–50°C; default 45°C.
- Peltier PWM 20 kHz, 8-bit; normal OFF→ON soft-start 5 seconds.
- Fan PWM 25 kHz, 8-bit; manual setting 50–100%, current step constant 10. Safety/cooling can force 100%.
- Selector break-before-make 200 ms; shared voltage guard/settle 1,000 ms.
- Both Adaptive upward-voltage profiles use a five-second dwell after completed upward step.
- Hotside telemetry every second; other state deltas normally only when changed.
- Persistent settings share a 10-second quiet-period debounce; every new change resets it, then only modified values are stored. Adaptive Profile is runtime-only.
- Hotside NTC is the universal thermal input.
- Local OTA boot SoftAP owns the only radio path: current no-client timeout is 10 seconds, hard cap is 60 seconds after AP interaction, Wi-Fi OFF settle is 160 ms before BLE ownership. OTA state/LED timing must be verified from source and must not be inferred from LEDs alone.

## 6. Current V6.4 voltage-transition contract

Read VOLTAGE_TRANSITION_MEMORY.md completely before any rail/Peltier change.

- Normal Manual Volt or Adaptive voltage transition branches by Peltier ramp state when accepted.
- If Peltier is OFF, a voltage change must not enable it.
- If ON while the five-second soft-start is still active: save the interrupted-ramp state, force GPIO5 PWM 0% before selector output change, keep 200 ms break-before-make, retain the existing 1-second rail settle, then start a fresh full five-second ramp.
- If soft-start completed and Peltier is at full duty: maintain 100% PWM continuously throughout transition. Do not force 0%, needlessly pause, or add another ramp merely because the rail changed.
- Fan remains ON/forced 100% during the handoff.
- Explicit Peltier-OFF, Hotside/NTC safety and OTA safe-output must stop Peltier and clear pending pause/resume state.
- Adaptive entry/exit uses its separate safe-5V handoff; restoration occurs only through safety gates and standard five-second OFF→ON ramp.
- Contract test exists at test/v6_4_qc_contract_test.dart (blob f071c9642c1a06726d25b8c26a814845b02a55d6); it was not run in this cleanup.
- User reported a restart at 5 V→12 V with Peltier/Fan ON during active ramp. Supply transient/brownout remains a hypothesis. If reproduced capture reset diagnostic and ideally supply voltage/Peltier current.
- [SEPARATE USER-REPORTED INCIDENT — RESET REASON UNKNOWN] Hardware was also reported to restart when Adaptive was enabled after selecting 12 V and turning Peltier and Fan ON. Do not conflate this with the active-soft-start rail-change restart; V6.4 requires safe-5V Adaptive entry and physical reproduction/reset-reason capture remains open.

## 7. Thermal / Adaptive / touch / RGB

- Manual Peltier lock re-arms only after Hotside stays at or below hotLimit - 1°C for five continuous seconds. A single low sample cannot bypass it.
- Current source constant HOT_PELTIER_OFF_MS is 30 seconds. Adaptive thermal stage has a 30-second window at 12 V/9 V/5 V, with Peltier OFF and Fan 100%.
- Five continuous seconds at/below hotLimit - 1°C before timeout cancels the stage and allows recovery only as permitted.
- If it doesn't recover, 12 V/9 V steps down one rail; unrecovered 5 V enters a terminal lock requiring manual restart.
- After thermal step-down, restore upward one rail after 60 continuous seconds stable at/below hotLimit - 1°C, no higher than saved Adaptive ceiling.
- HOTSIDE is Adaptive default at boot; HOTSIDE_BATTERY is runtime-selectable and not persisted. Missing battery temperature falls back to HOTSIDE behavior without silently changing profile.
- Phone Battery thresholds currently default to 25°C at 5 V and 35°C at 12 V, with 0.5°C hysteresis and 5-second firmware freshness TTL. App heartbeat is 1 Hz through `je_x_fyz/battery_temp` / `PHONE:BT`, and coalesces pending messages. This does not change NTC’s one-calibrated-sample-per-second requirement.
- No rapid Hotside slope/rise protection in known V6.x contract. [HISTORICAL USER REQUIREMENT / NOT IMPLEMENTED] A prior request asked for fast Hotside rise to shut Peltier OFF and require manual re-arm; V6.4 does not implement slope/rate-of-rise protection.
- One TTP223 touch sensor; no separate Wi-Fi/BLE toggle. Gesture QC history: ~1,000 ms startup grace, 30 ms qualification, raw HIGH tap 60–500 ms, 800 ms double tap window from first valid release, 5,000 ms long press. Verify live source before changing.
- Adaptive ON: orange 3 blinks. Adaptive OFF: white 3 blinks; if Adaptive was active, OFF feedback waits until safe 5 V handoff completes.
- [USER-REPORTED HISTORICAL ISSUE / UNVERIFIED] White Adaptive-OFF three-blink feedback was previously reported missing immediately after restart. Transition feedback code alone does not prove boot-time initial OFF indication; specifically verify before claiming resolved.
- Default voltage LEDs: 5 V red, 9 V green, 12 V blue; customizable/resettable.
- Current RGB modes: Static, Breath, Mirror Pulse, Comet, Dual Chase, Left/Right, Rainbow; Center Out/Outer In retired.
- Firmware publishes LED animation phase/cycle telemetry to sync App preview. Safety/OTA LED indication outranks decorative RGB. Old V5.x LED/thermal timing is historical; live source wins.

## 8. App UI, BLE/P1, telemetry

- App name JE Cooler; brand/header JE X FYZ. Flutter/Dart Android app uses flutter_blue_plus. Horizon Cooler App is primary architecture/UI reference.
- UI direction: dark header, white rounded content panel, compact VOLTAGE/ADAPTIVE top tabs. Home includes Hotside/Battery temperatures, voltage indicator, Adaptive, Peltier/Fan, Fan speed and Notify reason.
- Menu path: VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Keep compact sideways submenu; don't redesign during QC.
- Manual voltage 5/9/12 V, remembered cycle 5→9→12→9→5. App guard is one second and voltage completion awaits authoritative matching VOLTAGE telemetry.
- Fan PWM manual range 50–100%, practical increments 5/10; user setting belongs to Manual Volt, not Adaptive-managed fan.
- Adaptive ON locks manual voltage touch; Adaptive ON/OFF returns to safe 5 V first. Previously running Peltier returns only when safe through normal five-second ramp.
- BLE service UUID: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001. RX: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001. TX: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001. Protocol is P1.
- Firmware telemetry is authoritative; command ACK alone is not proof of physical state.
- Auto Connect/reconnect respects preference, previously known cooler identity, Bluetooth/permission/location prerequisites and session sync; cancel retries/scans if prerequisites fail and suppress scans during sync.
- Permanent App UI requirement: do not show a standalone Battery Protection Guard badge/guard state. Keep genuine, independently actionable localized safety/Notify messages; this rule is presentation-only and must not weaken thermal behavior.
- Pairing intent: one authorized App identity/key-lock relationship per cooler firmware. Treat the exclusive 1:1 enforcement as UNVERIFIED until provisioning/source path and physical pairing behavior are verified; current static source confirms encrypted/bonded writes only.
- App disconnected/unknown physical outputs show --, not stale ON/OFF.
- Touch Adaptive-OFF publishes ADAPTIVE, ADAPTIVE_CEILING, FAN, PELTIER, FAN_SPEED telemetry before its ACK.
- CLOUDOTA TIMEOUT/DISCONNECTED is ambiguous. Preserve recovery state and wait for reconnection/result; only definite rejection while BLE connected permits rollback.
- Localization English/Indonesia; English ON/OFF, Indonesian HIDUP/MATI. Machine protocol identifiers (BLE, P1, OTA, RGB, LED, NTC, FPS) remain untranslated. All safety/Notify/OTA visible text uses localization.
- Secure storage for preferences; cooler identity saved only after successful BLE/P1 session.
- Floating Monitor stable metrics F/B/H/V/A/P/S; S is the only fan metric, not a separate Fan metric. If Fan OFF, S shows localized OFF/MATI. It never owns second BLE/GATT. Native channels include je_x_fyz/battery_temp, je_x_fyz/floating, je_x_fyz/security, je_x_fyz/notifications; MainActivity owns settings bridge, FloatingMonitorService owns WindowManager overlay, JeForegroundService backs an existing BLE session only.
- Package com.horizontalzzz.jexfyz / version 1.0.0+3. Preserve Gradle versionName "Telegram @horizontalzzz". Brand PNG assets assets/jexfyzicon.png and assets/jexfyzcooler.png are transparent 1:1.

## 9. OTA / cloud — do not casually edit

Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md fully before any OTA change.

- ESP32-C3 has one radio path. Wi-Fi OTA must completely shut OFF and settle before BLE advertising/session resumes.
- Local OTA Boot SoftAP currently has `BOOT_AP_TIMEOUT_MS=10000`, `BOOT_AP_HARD_LIMIT_MS=60000`, and `WIFI_OFF_SETTLE_MS=160`. No concurrent Wi-Fi/BLE radio ownership; verify current values before any authorized OTA edit.
- OTA has priority over normal application task. Safe output: Peltier/Fan OFF and selector forced safe at 5 V; retain state-machine indications and recovery.
- App OTA command sequence: OTAENTER → SSID → PASS → URL → VERSION → CLOUDOTA. Arm expected disconnect/recovery before CLOUDOTA; reconnect and complete P1 sync before delivering final OTA result.
- Earlier Online OTA experiment added embedded ISRG Root X1 CA/setCACert plus configTime/NTP/TIME_SYNCING 20-second gate. User observed Wi-Fi blue after connect and red failure at the GitHub attempt. No exact serial/HTTP error was supplied, so do not invent it from LED behavior.
- The V6.3-origin correction restored cloudClient.setInsecure(), removed the embedded CA and OTA-only NTP gate, and proceeded from Wi-Fi success/blue to GitHub GET. User reported V6.3 compiled and GitHub connection recovered.
- Security trade-off: setInsecure() bypasses HTTPS server certificate identity validation. CA and NTP gate were removed together; evidence does not isolate the sole prior failure cause. Do not call this authenticated TLS; do not silently restore the old path. Any change requires prior discussion/approval, exact diagnostics, one variable at a time where practical, and full OTA/hand-off/recovery audit.
- Keep allowlist prefix https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/, redirects disabled, HTTP/length/size checks, ESP image magic 0xE9, streaming Update lifecycle, safe output and failure recovery.
- User does not want a custom firmware SHA/signature field in Firebase metadata; current intended data model is version + link.
- Previously requested OTA indicator intent: Wi-Fi success blue then download/update; success green then restart; failure red then restore BLE without forced restart where state machine supports it. Check exact current source before describing details.
- User report for V6.3 does not prove V6.4 compile, full BIN transfer, Update.end(), reboot, BLE recovery or installed version.

## 10. App Build / release

- App Build and Firmware compile are separate.
- Latest observed successful App Build run is 38380312823 on `c21e2e52218e7f284ae8536855cf976199566975` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38380312823). It is a real successful run but targets an earlier commit, so it is NOT a fresh build/test certification of this transfer HEAD/source state. The four current test files are present and were not executed by this documentation task.
- Only workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- Explicit trigger title: JE X FYZ — BUILD APP TRIGGER.
- Required body token: JEXFYZ_BUILD_TRIGGER_V1.
- Issue opened/reopened only, validates owner/title/token. Normal push/PR must not build APK.
- Toolchain last recorded: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Output intent: one obfuscated/minified/shrunk production-signed ordinary APK JEXFYZ-release.apk, uploaded to GitHub Release jexfyz-latest. No Play Store bundle or Actions artifact.
- Historical signing SHA256 record: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0; verify live before any signing claim.
- Historical App run 37245703677, source commit fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366, asset ID 610989112, APK SHA256 a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2. Not evidence of latest release.
- Historical V6.2 candidate run 38362882150 reported 45 Flutter tests passing, but plain flutter analyze exited nonzero due 23 info-level deprecations; doesn't validate current V6.4.
- Build App only on explicit @Thinking Build App! or @Thinking Eksekusi & Build App!.

## 11. Approved grille / design memory

Read DESIGN_NOTES.md before any visual iteration.

- Approved grille: symmetrical solid white geometric square, perfect 1:1 outer contour, central purple X, four corner mounting holes.
- Preserve interior pattern/frame; remove only the two small left/right midpoint protrusions when that exact adjustment is requested.
- Flat 2D print-ready: no shadow, bevel, faux depth, gradient or texture.
- User tried HZ but explicitly reverted to the purple X. Purple X is approved.
- “Enlarge only” means scale the existing approved design; do not invent or redesign pattern/logo/hole/frame.
- Preserve transparent 1:1 icon/cooler PNG aspect ratio/transparency.

## 12. Memory cleanup / reconciliation completed

- Canonical memory routing is in `MEMORY_INDEX.md`; the transfer snapshot is only a boot bridge. `PROJECT_STATE.md` is current-only and `CHANGELOG.md` retains labeled history.
- README navigation, CHAT_RULES, PROJECT_STATE, HANDOVER, APP_NOTES, FIRMWARE_NOTES, BUILD_NOTES, CHANGELOG, firmware technical reference and OTA protection were updated where durable constraints or current evidence boundaries were missing.
- `APP_NOTES.md` now records the one-second phone Battery heartbeat, firmware 5-second freshness TTL, default Battery zones, no standalone Battery Protection Guard UI, and the one-App/one-cooler pairing-lock intent as unverified implementation.
- Firmware notes/technical reference/OTA protection now document the boot SoftAP 10-second no-client timeout, 60-second hard limit after interaction and 160 ms Wi-Fi-off settle before BLE radio ownership.
- `CHAT_TRANSFER_PROMPTS.md` is expanded to include complete tree and cross-reference audit rules plus a JE X FYZ durable-decision catalogue across hardware, thermal/Adaptive, App UI/BLE/P1, OTA/build and grille design. It preserves rejected approaches and evidence caveats.
- The retired `firmware/FIRMWARE_ANALYSIS.md` remains archived; current code-level reference is `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`.
- The old `test/v5_9_contract_test.dart` was already renamed to `test/app_protocol_notify_contract_test.dart`; contents unchanged, not run.
- This reconciliation preserved two distinct reported restart incidents, the unimplemented rapid-Hotside-rise request, and the Adaptive-OFF-after-restart LED symptom as clearly unverified/historical; no functional source behavior changed.
- Three dated `archive/LEGACY_*.md` snapshots remain untouched for forensic recovery; do not copy their old CURRENT/ACTIVE blocks into current notes.
- Artifact repo was checked at the end of this pass and contains only `JEXFYZ.cpp.bin`; this task did not touch its content/blob. App repo remains sole location for all documentation.
- No functional code changed in this reconciliation. No test/analyze, App Build, Firmware compile, BIN generation/publication, Firebase edit, flash/OTA or release was performed.

## 13. Historical version pointer — old history is not current

- V6.4: active source-only branch. Peltier voltage changes pause only active soft-start and preserve completed 100% duty. Compile/device gate remains open.
- V6.3-origin Online OTA fix remains present: setInsecure path; user-reported compile/connect result applies to V6.3.
- V6.2: historical Adaptive thermal stages/recovery, safety latch, BLE/reconnect and OTA ACK changes.
- V6.1: historical safe-5V Adaptive entry/exit, orange ON/white OFF indicator, reset diagnostics and Touch Adaptive-OFF telemetry.
- V6.0: historical Adaptive Profile runtime-only/HOTSIDE default, ten-second settings debounce and approved RGB/phase sync.
- V5.8: restored one calibrated NTC sample/sec after user rejected V5.6 multi-sample filtering.
- V5.7: TTP223 qualification/gesture timing.
- V5.4–V5.6: previous thermal/LED/filter approaches; several superseded.
- V4.x and V5.0–V5.3 detail remains in previous changelog/Git history archive. Recover missing facts from archive as historical, never copy old “current” states.
- For more detail, use CHANGELOG.md and archive snapshots; current source and current-only docs always win for present behavior.

## 14. Exact open validation queue

1. User compiles active V6.4 in ArduinoDroid with Arduino-ESP32 Core 3.3.7; keep the actual log and confirm firmware version.
2. Establish whether the artifact BIN provenance matches V6.4 before any publication/OTA. Current BIN path/size/hash are known; matching source provenance is not.
3. Physical Manual Volt and Adaptive transition while the 5-second ramp is active: expect 0% PWM, selector 200 ms deadtime, one-second settle, then a new full 5-second ramp.
4. Repeat after the ramp completes: expect uninterrupted 100% PWM unless explicit OFF/safety.
5. Verify Peltier-OFF/safety cancellation; Hotside latch/re-arm and 30/60-second Adaptive behavior; NTC fault failsafe; no multi-sample NTC filter.
6. Verify phone Battery heartbeat/freshness fallback and the App display rule (no standalone Battery Protection Guard). One-App-only pairing-lock remains unverified; test only if user authorizes that scope.
7. Confirm that the prior Adaptive-OFF white three-blink complaint does not remain at boot/restart; do not infer boot feedback from the OFF transition handler. The separate 12 V Adaptive-entry restart report also needs physical reproduction/reset reason if authorized.
8. Rapid Hotside-rise/manual-re-arm behavior is a historical unimplemented request. Do not claim it is part of V6.4 or implement it without explicit discussion/authorization and a firmware version bump.
7. Check touch telemetry, orange/white three-blink effects, default voltage LED map and App-authoritative physical-state display.
8. If authorized, run Flutter tests/analyze and record exact run/log. The source contracts exist but were not run in this cleanup.
9. Hardware-check BLE/P1 pairing/reconnect and radio handoff: Wi-Fi fully OFF plus 160 ms settle before BLE ownership; no concurrent Wi-Fi/BLE ownership.
10. Validate Local OTA. Separately verify Online OTA GET, body length/image check, Update completion, restart, BLE/P1 recovery and installed version. Blue/red LEDs alone are insufficient error diagnosis.
11. App Build only after explicit Build App command; use current workflow and report its run head SHA.
12. Release/BIN/Firebase promotion only after source/BIN provenance, software and hardware/OTA gates, plus separate authorization.

## 15. Evidence labels and don't guess

- CURRENT / VERIFIED = directly rechecked live repo/run.
- SOURCE IMPLEMENTED / NOT RUN = code/test contract exists; it didn't necessarily execute.
- USER-REPORTED = user said it happened; not independently verified.
- UNVERIFIED = evidence missing.
- HYPOTHESIS = plausible, unconfirmed cause.
- HISTORICAL / SUPERSEDED = only valid for the old version named.
- NOT RELEASED = no authorized/proven production release.

Never equate test file with passing run; compile with full OTA installation; blue LED with successful HTTP; ACK with hardware state; reboot with proven brownout; version bump with BIN build; or existing BIN with source provenance.

## 16. Last-observed blob fingerprints

All hashes below were fetched from live `main` at HEAD `2d01ef02051e1098d53e0ebcfd590f88decc02f0` immediately before this snapshot write. They fingerprint this checkpoint only. The future SHA of this file is deliberately not self-recorded; verify its commit and parent after saving.

Canonical memory docs:
- `README.md`: `8881b20dec2a7ea916b6d45e487156927516cd88`
- `MEMORY_INDEX.md`: `b738806db407cf24b939a8a3966589c03f679a8a`
- `CHAT_RULES.md`: `947ceaa6dd93972f45ce40f9e4b548fe10274e22`
- `PROJECT_STATE.md`: `08629b442c3e637543a2859242e4d009188a9b57`
- `CHAT_TRANSFER_PROMPTS.md`: `50ebdc054a70d66cf62bb252cc345ae9b6af1c86`
- `HANDOVER.md`: `ce213dbbdb3151e12d0e627f885c64773f0947a6`
- `APP_NOTES.md`: `fb240cdfff4151ac896e63c8121543c2cabef489`
- `FIRMWARE_NOTES.md`: `768a402c46af89c1bf20011dd6091bbfac00e813`
- `BUILD_NOTES.md`: `7627218cc6d2a3b3585ef63057b4eab9856fe916`
- `CHANGELOG.md`: `0b012efd2e6eb96b1ffd7cec007e90b6ec92c25f`
- `DESIGN_NOTES.md`: `e04382659dfdd618de0a156046f140452d275dc7`
- `OTA_PROTECTION.md`: `370fe25e6c9632f5ffe14ff27e4a61b35d30de45`
- `OTA_REGRESSION_MEMORY.md`: `e1e1fe88b65843d9626ea63aab018607e69b454f`
- `VOLTAGE_TRANSITION_MEMORY.md`: `232f18b16b960e669e3fddd65337cc82ac6a9b5e`
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `389e873ab68ee7c041b5b25378010be4c1ff739b`

Workflow, package metadata, active source and tests:
- `.github/workflows/jexfyz-app-build-trigger.yml`: `7c41358311be195d43f011c1e9a4da98772fcb7d`
- `.gitignore`: `a51c5ad7dabd81d6a7e42181fa7d5c3a25bdac15`
- `pubspec.yaml`: `8f558273e21692af9958f914527fdc62d623d63a`
- `pubspec.lock`: `1e92812bfda2c28244a0556d71d1ec94084acc66`
- `lib/main.dart`: `535e396005a3bd1429db3096c627d87043b0e1b4`
- `lib/app_settings.dart`: `0c29bed46b746c1171f61ee7b095c724474a5e6b`
- `lib/floating_monitor.dart`: `cfc21b3dc198b925786aa98658d647b1d8a3637b`
- `lib/jex_animated_glyph.dart`: `c9c5c2802cb0ed363c042620511148b0d58d36c4`
- `firmware/JEXFYZ-V6.4.ino`: `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`
- `test/v6_4_qc_contract_test.dart`: `f071c9642c1a06726d25b8c26a814845b02a55d6`
- `test/firmware_touch_adaptive_sync_test.dart`: `a8df6ca2be18c3b7ed9c25e5c148f0d5056556d5`
- `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`
- `test/widget_test.dart`: `3dc6ffaa5dac21db016bf7d7c86875036a902200`

Android config, native source and visual assets:
- `android/app/build.gradle`: `d8681cb73156b61da7749633abd63e2fb8c287ba`
- `android/app/src/main/AndroidManifest.xml`: `d82504cee09092d304d8edc98272ddd0b4732519`
- `android/app/proguard-rules.pro`: `50fc26f726ae8660fe04cf19da688431c8dca4a0`
- `android/build.gradle`: `ca11c0f28728b40577d25490811bcc2c8d05ca24`
- `android/settings.gradle`: `14545695cc9aba5912393ec293c284ee60d9ec10`
- `android/gradle.properties`: `13564f62c79279ecfd4fe0a8a247a4d2a4b11451`
- `android/app/google-services.json`: `f3ed065a7ee56b2a44f0a943a48fa578ba72e0d7`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`: `eeb135ef34b1d415196b86e6ffe1ac39d7bda5e2`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt`: `437655add9f12631570614314eef1db1fd9c4005`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `628aa4d06591b7e2c6e725cb6bc9a582063b025d`
- `assets/jexfyzicon.png`: `bad855f23416fd58aff194c30b7f8fd77f260ea8`
- `assets/jexfyzcooler.png`: `fbc47e3197534ae35330c1f1793c99705e5165d1`
- `android/app/src/main/res/drawable-nodpi/jexfyzicon.png`: `bad855f23416fd58aff194c30b7f8fd77f260ea8`

Forensic-only archives:
- `archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md`: `65ece82c5e8a07908accb4a81bd4c80e469b55de`
- `archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md`: `0438b7006d437d2c24d9e76d6aca7352ad5b0b2b`
- `archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md`: `10fab755affdbb8e29727390ad187fcb4bf6817d`


## 17. Final rule for the next chat

Do not restart project development from this snapshot alone. Boot from live main, read canonical memories fully, preserve every durable user decision and rejected approach, recover missing history from archives without guessing, and persist meaningful outcomes in the correct canonical note. Replace the transfer file at the end of every substantial context-limit reconciliation, after reading its prior version completely.