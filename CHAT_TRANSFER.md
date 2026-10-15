# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Snapshot date: 2026-10-15 (Asia/Jakarta). This transfer is refreshed last. Parent checkpoint before this update: `main` HEAD `d638f6941d9ac16a228f4b78ed001ca2e925f716`, tree `e497c41249c7af91ca3d128c84fbed7ad61eca79`. Build #40 / run `38713854518` passed audit/license checks, dependency installation, Dart analysis, 80 Flutter tests, obfuscated APK build, V1/V2/V3 signing and official certificate verification. The generated source ZIP passed integrity validation, but the step failed on an incorrect SPAKE2 source path assertion. The workflow path has been corrected in pending blob `225584c8feaf8e43ff7228fd6ab3dc84491e34ba`; it must be committed and the full Build App workflow rerun. No Release publication occurred in #40, so the latest released APK remains the older Build #36 asset. Continue without asking the user to choose a technical route: retain Kadb/Wireless ADB, embed the GPL license, publish matching source ZIP alongside exactly one APK to the same private Release, and verify both downloaded hashes.

## 0. New-chat boot — mandatory order

1. Read this entire CHAT_TRANSFER.md first, from first line to last line.
2. Fetch live main HEAD, full recursive tree, every current source/config/test/workflow/document path and blob SHA, exactly one active Firmware .ino and its FW_VERSION, App source/package/version, Actions run IDs plus head SHAs, open/closed PR and branch state, and artifact repository root.
3. Read MEMORY_INDEX.md, CHAT_RULES.md and PROJECT_STATE.md completely.
4. Read all relevant canonical notes in full: App → APP_NOTES.md; Firmware/hardware → FIRMWARE_NOTES.md + firmware/FIRMWARE_TECHNICAL_REFERENCE.md; OTA → OTA_PROTECTION.md + OTA_REGRESSION_MEMORY.md; Peltier/rail change → VOLTAGE_TRANSITION_MEMORY.md; Build App → BUILD_NOTES.md + workflow; approved visuals → DESIGN_NOTES.md.
5. Read HANDOVER.md for exact next actions and CHANGELOG.md for history. Do not rely only on remembered chat summaries where repository evidence exists.
6. For a general/Discussion chat limit, use Prompt A only when broad project-memory reconciliation is needed, then replace this file last. For a Build App chat limit, use Prompt D exactly once as the first message in the replacement Build App chat; Prompt D loads live repository/build evidence and continues the same work. There is no separate Build App recap chat or recap prompt, and Prompt A must not be used just to hand off Build App work.
7. Do not ask the user to repeat a saved decision. Search archives/Git history to recover missing historical detail, then place it in one canonical file with a correct evidence label. Never guess. All three archive documents are forensic-only and their old internal CURRENT lines are not live truth.
8. Audit every text, Markdown, source, configuration, workflow and test file in the repository. Check every Markdown link and every renamed path/version/workflow/test reference. Read complete relevant files, not just first-line excerpts.

## 1. Repository checkpoint immediately before this transfer refresh

- **Live checkpoint:** refreshed during this documentation-only protocol update on 2026-10-15 (Asia/Jakarta).
- **Canonical repository/branch:** `TenzoNkz/JEXFYZ-App` / `main`.
- **Live checkpoint before this transfer write:** `main` HEAD `e3067f1290ebb0f763e02609f273559e889fddfe`; root tree `afb741a49573222455d82bf34500cccd84c55599` (71 entries / 52 blobs, 20 Markdown files, five Dart tests, not truncated). Five App branches exist: `diag/latest-stable-v16`, `diagnostic/v1.6-heap-check`, `fix/adaptive-power-sequencing`, `main`, `tmp-jexfyz-v5-test`; open PR count is zero. Latest Actions success is Build #36 / run `38689044316`, source commit `893393388b99fc6d9e59c420070a159a29e45e9a`. Its 77 tests and release gates passed only for its own earlier source; current Wireless ADB and Home UI redesign changes are newer and absent from that APK. Project state and release fingerprints were reconciled before this transfer refresh.
- **Latest failed Build App attempt:** [#39 / run 38705765370](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38705765370) on source commit `b9102695de25f61f0b985cab4cd384b4cda12534`; analysis and 80 tests passed, APK assembly failed for the missing SPAKE2 artifact. This source update adds a restricted JitPack declaration (new `android/build.gradle` blob `bb8c0caf26927bd614bb9b05ef79366424063663`), not a build result.
- **Active Firmware source:** `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION = "V6.6"`. Exactly one active versioned `.ino` is tracked and filename/version align. **USER ACCEPTANCE 2026-10-14:** user considers V6.6 correct/final and reports successful compilation and two successful Online OTA flashes/updates with the same version V6.6. Do not modify/recompile/reflash unless the user explicitly reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified, but is not an active task by itself.
- **Current App identity/source:** `lib/main.dart` blob `d097adea48988700a8a80ac423cc088959cfa1f6`; `lib/floating_monitor.dart` blob `bd230aee16fa77a0d8d2afb9f1a0c2d80cdcac86`; `lib/app_settings.dart` blob `c513cd4381ee960cd43612c4ac01e7954f651f62`; `test/widget_test.dart` blob `bf403ee3d29e8d2f3f6839b2244a00f1b60e8bdb`; native `FloatingMonitorService.kt` blob `038f12b2ca82255a3b202b10dd770d5caa5b2bbf`; `MainActivity.kt` blob `f7340e82a12cece063e310546dcba893e6a5a09f`; AndroidManifest blob `2124dcd969347d2c7bb1bd99374a398cf50d2387`. Package `com.horizontalzzz.jexfyz`, pubspec `1.0.0+3`; preserve Gradle `versionName "Telegram @horizontalzzz"`.
- **Current native notification files:** `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt` blob `aecfc87121f2195ef6724613c612d674ed95ae55`; `android/app/src/main/res/drawable/ic_notification.xml` blob `cda9e8404d14a62a61157ec59fae2e491c19f5f7`. The notification helper uses the transparent bold-white JE vector as the sole small icon and sets no large icon; launcher/app imagery still uses `jexfyzicon`.
- **Fan motion:** BLE voltage class continues to set speed: 5V = 2600 ms, 9V = 1250 ms, 12V = 620 ms. Voltage changes preserve phase by easing to an equivalent full-turn boundary. On OFF, the Fan coasts forward with ease-out over up to 0.16 turn (duration is scaled to current cycle), then retains the resting angle; blade/hub colours remain full-strength.
- **Peltier icon/motion:** the square thermoelectric module frame, center box and corner bolts are removed. The icon is a free-standing six-branch frost crystal with particles. While ON, crystal drift animates and frost density/intensity interpolates over 420 ms across voltage classes; when OFF, controllers stop and the crystal freezes at its current pose at full colour. No OFF fade. This is decorative UI, not a physical ice or temperature measurement.
- **Dialog sizing/interaction:** Color Picker title 22sp, selected-color label/action buttons 15sp, swatches 42dp; bottom-pinned, no draggable outer scroll panel. Swatches change only the draft preview/checkmark/name. Localized top-left Cancel discards the draft; localized top-right Select applies the existing confirmed COLOR command and closes only on success. Outside taps and Android system Back are blocked. Build #39 included the updated regression assertions in its 80-test pass; no APK has passed assembly after this Gradle repository change. Peltier Safety title 24sp, body 17sp, action text 16sp with 48–50dp targets. Fan-before-Peltier approval gate and the 36 palette colors are unchanged.
- **Latest successful App Build:** Build #36 / ID `38689044316` on code commit `893393388b99fc6d9e59c420070a159a29e45e9a` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38689044316). Security/architecture audit, dependency resolution, Dart analyze, all 77 Flutter tests, obfuscated APK build, V1/V2/V3 verification, production certificate validation, release publication and downloaded-asset verification passed. Release `jexfyz-latest` contains one `JEXFYZ-release.apk`, 54,620,251 bytes, SHA-256 `a5c9d97a3d28f7f711b0cd3c524289bc136cecec56d3b1d88821e43c713e9a13`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Build #36 predates Wireless ADB pairing; current source is not included. JAR/V1 metadata warnings remain separate from passing V1/V2/V3 verification.
- **Build workflow:** `.github/workflows/jexfyz-app-build-trigger.yml`, blob `0e400cbdedfd54506ae3ac3255da41580c86d750`. Build #36 verified V1/V2/V3 on the built APK and downloaded Release asset; Android manifest minSdk remains 24. JAR/V1 dependency META-INF warnings remain. Trigger title `JE X FYZ — BUILD APP TRIGGER`, token `JEXFYZ_BUILD_TRIGGER_V1`, Ubuntu 24.04 / Java 17 / Flutter 3.47.2 / Gradle 9.3.1. Pairing source after `893393388b99fc6d9e59c420070a159a29e45e9a` is absent from that APK.
- **Artifact repository:** `TenzoNkz/JEXFYZ-Firmware` main HEAD `cc0a0ae32b826753525c3f2a4442526648cef631`, root tree `b4db8f4e86dfb97d3313c70428b92eb9d4bd7511`; live recursive root contains only `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. Provenance matching V6.6 source remains UNVERIFIED.
- **Operation boundary:** Build #40 passed the app tests and APK/signature gates but did not publish because the corresponding-source archive validation used an incorrect source path. The corrected workflow path is `src/main/java/com/flyfish233/crypto/spake2/Spake2Context.java` in tag 1.0.5 (pending blob `225584c8feaf8e43ff7228fd6ab3dc84491e34ba`). Continue to the next official build and resolve all gates; no Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## 2. Permanent Thinking commands and authorization limits

- `@Thinking #Diskusi!` — full technical discussion and planning only. No repository write or source edit.
- `@Thinking #Diskusi! #Tanya Gemini!` — prepare a full, copy-ready Gemini prompt based on the agreed discussion, technical context, constraints and expected evidence.
- `@Thinking #Diskusi! #Jawaban Gemini!` — evaluate the user's pasted Gemini reply against current source, repository memory and prior decisions. Do not accept it automatically or execute it in discussion mode.
- **Required parent:** either Gemini subcommand without `#Diskusi!` in the same command is invalid. Reject it without processing its substantive request; ask for the correct command format only.
- `@Thinking #Eksekusi Full!` — execute the agreed scope, related audit/tests, doc/index/state/changelog reconciliation, verification and commit to `main`. It does NOT authorize App Build or Firmware/device operations.
- `@Thinking #Build App!` — run the entire App Build/QC loop, inspect exact logs, fix App-scope failures without weakening gates, re-run after evidence-based fixes, verify APK/signing/release asset, and update `APP_BUILD_REPORT.md`. At a Build App chat limit, the replacement Build App chat uses Prompt D once to LOAD + CONTINUE from live evidence; there is no separate recap chat.
- `@Thinking Chat Stuck!` — standalone emergency recovery. Halt blind retries, inspect logs/current repository/workflow/checkpoint, and resume only the last valid authorized task; avoid duplicate commits/builds and report `RECOVERED`, `BLOCKED` or `FAILED`. It does not itself authorize a Build App/Firmware/device operation.
- Retired commands: standalone `#Eksekusi!` and combined `#Eksekusi & Build App!`. Do not suggest or use them. The user has approved this updated protocol.
- If build progress is blocked by permissions/secrets, external services, hardware/device checks or work requiring separate authorization, record `BLOCKED` with the exact needed action; never report false success or loop blindly.
- Build workflow manual trigger title: `JE X FYZ — BUILD APP TRIGGER`; body token `JEXFYZ_BUILD_TRIGGER_V1`. Read the live workflow before any future build.
- User compiles Firmware themselves. Do not compile Firmware, generate/replace/publish BIN, modify Firebase/production metadata, flash hardware, run physical OTA, operate devices, or perform unrelated releases without separate explicit authorization.
- Prefer direct changes on `main`; do not create branches or PRs unless requested. Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.
- Never claim writes, tests, compile, APK signing, release, OTA, installation or physical validation without matching live evidence.

## 3. Canonical repo split and memory map

TenzoNkz/JEXFYZ-App is the single canonical home for App source, editable firmware .ino, all docs, memory, design decisions, transfer prompts and changelog.

- README.md: overview + navigation.
- MEMORY_INDEX.md: boot order, canonical file map and evidence/source hierarchy.
- APP_BUILD_REPORT.md: durable per-attempt App Build evidence ledger. Keep the work, failure/fix history, run IDs, test/analyze status, APK identity/SHA-256/signature results, warnings and unverified device checks here. The next Build App chat loads this file through Prompt D and continues; Discussion may also consult it.
- CHAT_RULES.md: permanent commands, authorization, version rule, repository separation and memory discipline.
- PROJECT_STATE.md: current-only status and unresolved validation gates; no historical dumps.
- CHAT_TRANSFER.md: detailed context bridge, replaced as a whole at context limit.
- CHAT_TRANSFER_PROMPTS.md: Prompt A general project-memory reconciliation, Prompt B read-only general/Discussion boot, Prompt C persist a decision, Prompt D one-shot Build App chat-limit LOAD + CONTINUE (no recap chat), plus category-by-category memory checklist.
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

TenzoNkz/JEXFYZ-Firmware must contain JEXFYZ.cpp.bin only. Do not re-add a README, firmware source, memory or notes there. Current observed BIN SHA: 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not replace it without explicit authorization and verified provenance.

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

## 6. Current V6.6 voltage-transition and LED contract

Read VOLTAGE_TRANSITION_MEMORY.md completely before any rail/Peltier change.

- Normal Manual Volt or Adaptive voltage transition branches by Peltier ramp state when accepted.
- If Peltier is OFF, a voltage change must not enable it.
- If ON while the five-second soft-start is still active: save the interrupted-ramp state, force GPIO5 PWM 0% before selector output change, keep 200 ms break-before-make, retain the existing 1-second rail settle, then start a fresh full five-second ramp.
- If soft-start completed and Peltier is at full duty: maintain 100% PWM continuously throughout transition. Do not force 0%, needlessly pause, or add another ramp merely because the rail changed.
- Fan remains ON/forced 100% during the handoff.
- Explicit Peltier-OFF, Hotside/NTC safety and OTA safe-output must stop Peltier and clear pending pause/resume state.
- Adaptive entry/exit returns the selector to safe 5 V without forcing a separate Peltier OFF/ON cycle. `requestVoltage()` pauses only an active soft-start; a completed ramp stays at 100%. A Peltier already OFF stays OFF; explicit OFF/Hotside/NTC/OTA safety still overrides.
- Contract test exists at `test/v6_6_qc_contract_test.dart` (blob `2bee4d960d014f0765422dcb5ed1c9870ba6ee3a`). The full Flutter test suite passed in Build App run `38556896542` on pre-signing-fix commit `67c5d26723c433b4af856c7759a967a3425bf67a`; this confirms the test suite ran but does not prove physical Firmware runtime.
- User reported a restart at 5 V→12 V with Peltier/Fan ON during active ramp. Supply transient/brownout remains a hypothesis. If reproduced capture reset diagnostic and ideally supply voltage/Peltier current.
- [SEPARATE USER-REPORTED INCIDENT — RESET REASON UNKNOWN] Hardware was also reported to restart when Adaptive was enabled after selecting 12 V and turning Peltier and Fan ON. Do not conflate this with the active-soft-start rail-change restart; V6.6 uses a safe-5V selector handoff without an extra Peltier OFF cycle, and physical reproduction/reset-reason capture remains open.

## 7. Thermal / Adaptive / touch / RGB

- Manual Peltier lock re-arms only after Hotside stays at or below hotLimit - 1°C for five continuous seconds. A single low sample cannot bypass it.
- Current source constant HOT_PELTIER_OFF_MS is 30 seconds. Adaptive thermal stage has a 30-second window at 12 V/9 V/5 V, with Peltier OFF and Fan 100%.
- Five continuous seconds at/below hotLimit - 1°C before timeout cancels the stage and allows recovery only as permitted.
- If it doesn't recover, 12 V/9 V steps down one rail; unrecovered 5 V enters a terminal lock requiring manual restart.
- After thermal step-down, restore upward one rail after 60 continuous seconds stable at/below hotLimit - 1°C, no higher than saved Adaptive ceiling.
- HOTSIDE is Adaptive default at boot; HOTSIDE_BATTERY is runtime-selectable and not persisted. Missing battery temperature falls back to HOTSIDE behavior without silently changing profile.
- Phone Battery thresholds currently default to 25°C at 5 V and 35°C at 12 V, with 0.5°C hysteresis and 5-second firmware freshness TTL. App heartbeat is 1 Hz through `je_x_fyz/battery_temp` / `PHONE:BT`, and coalesces pending messages. This does not change NTC’s one-calibrated-sample-per-second requirement.
- No rapid Hotside slope/rise protection in known V6.x contract. [HISTORICAL USER REQUIREMENT / NOT IMPLEMENTED] A prior request asked for fast Hotside rise to shut Peltier OFF and require manual re-arm; V6.6 does not implement slope/rate-of-rise protection.
- One TTP223 touch sensor; no separate Wi-Fi/BLE toggle. Gesture QC history: ~1,000 ms startup grace, 30 ms qualification, raw HIGH tap 60–500 ms, 800 ms double tap window from first valid release, 5,000 ms long press. Verify live source before changing.
- Adaptive ON: orange 3 blinks. Adaptive OFF: white 3 blinks; if Adaptive was active, OFF feedback waits until safe 5 V handoff completes.
- [USER-REPORTED HISTORICAL ISSUE / UNVERIFIED] White Adaptive-OFF three-blink feedback was previously reported missing immediately after restart. Transition feedback code alone does not prove boot-time initial OFF indication; specifically verify before claiming resolved.
- Default voltage LEDs: 5 V red, 9 V green, 12 V blue; customizable/resettable.
- Current RGB modes: Static ID 1, Breath ID 2, Comet ID 4, Dual Chase ID 5, Left/Right ID 6, Rainbow ID 7. Mirror Pulse ID 3 is retired; stored ID 3/invalid modes migrate to Static and new MODE:3 commands are rejected. If the App encounters legacy ID 3 from older firmware, previous navigation selects Breath (ID 2) and next selects Comet (ID 4).
- Firmware publishes one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` snapshot computed at BLE notify time. App interpolates monotonically between snapshots and adjusts drift without resetting the animation on every update. Separate `LED_PHASE`/`LED_CYCLE_MS` remains a compatibility fallback for older V6.x firmware.
- LED preview layout is left arrow → four left pixels → centered localized mode name only (no number) → four right pixels → right arrow. The center card is narrower and the whole preview strip is shorter. Left/right LED-column backgrounds are darker for contrast; pixel core visibility and glow are independent of the hardware Brightness slider, while animated mode levels and monotonic LED_SYNC interpolation remain active.

## 8. App UI, BLE/P1, telemetry

- App name JE Cooler; brand/header JE X FYZ. Flutter/Dart Android app uses `flutter_blue_plus`; Horizon Cooler App remains the primary architecture/UI reference.
- UI direction: dark header, white rounded content panel, compact VOLTAGE/ADAPTIVE top tabs. Home includes Hotside/Battery temperatures, voltage, Adaptive, Peltier/Fan, Fan speed and Notify reason.
- Menu path: VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Keep the compact sideways submenu; no unrelated redesign during QC.
- LED UI: compact mode-name-only strip with four LEDs on each side; preview visibility is independent of hardware Brightness. Color Picker has 36 localized hue-ordered presets, no HEX labels, legacy aliases including Cyan #00FFFF, and is pinned to the bottom safe area. Swatches stage a draft with local checkmark/preview/name only; no BLE COLOR command is sent until localized top-right Select. Select applies through confirmed COLOR and closes only on success; a failed/unconfirmed command leaves the current applied RGB unchanged and the dialog open. Localized top-left Cancel discards the draft. Outside taps and system Back cannot dismiss the modal.
- Dashboard Fan rotor follows authoritative BLE voltage: 5V = 2600 ms, 9V = 1250 ms, 12V = 620 ms. Voltage transitions preserve angular phase; Fan OFF eases forward to a full stop and retains its final pose with full-colour blades/hub.
- Peltier dashboard symbol is now a free-standing six-arm crystal (no square frame, center box or corner bolts). Frost intensity/density transitions over 420 ms across voltage classes while ON; when OFF, the full-colour crystal freezes in place and does not fade. Crystal drift is periodic when animated; this is only visual feedback, not a physical ice/temperature measurement.
- Fan Speed keeps its percentage bound to authoritative telemetry. A dedicated controller retargets its visible gauge from the current rendered level to the new target over 420 ms; a further target arriving mid-transition continues from the current visible level. OFF eases to 0 over 520 ms. The subtle ON needle wobble uses integer-frequency sine harmonics and is continuous at the loop boundary.
- Voltage-bolt sheen moves sinusoidally back and forth instead of snapping to the left edge. Bluetooth ripples use a squared-sine opacity envelope that reaches transparency with zero slope at repeat boundaries.
- Color Picker typography: 22sp title, 15sp selected-color label and actions, 42dp swatches, and 44dp Cancel/Select targets. Peltier Safety: 24sp title, 17sp body, 16sp actions, larger responsive padding and 48–50dp button targets. Palette colors are unchanged. The Fan-before-Peltier gate and Cancel/Turn On Fan semantics remain unchanged.
- Android notifications use a bold white `JE` vector monogram with transparent background as the sole small icon (`R.drawable.ic_notification`); no large icon is set. Event/status stays the localized body below JE X FYZ, tap opens the App, BLE/Floating Monitor service messages stay meaningful, and Android 13+ permission flow remains unchanged.
- Manual voltage: 5/9/12 V with sequence 5→9→12→9→5. Command completion awaits authoritative matching voltage telemetry.
- Fan PWM manual range 50–100%; setting belongs to Manual Volt, not Adaptive-managed Fan. Firmware telemetry is authoritative; ACK alone does not prove physical state.
- Adaptive ON locks manual voltage touch; Adaptive ON/OFF returns to safe 5 V first. Previously running Peltier returns only when safe through normal five-second ramp.
- BLE service UUID: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001; RX: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001; TX: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001. Protocol is P1.
- Auto Connect/reconnect respects preference, known cooler identity, Bluetooth/permissions/location prerequisites and session sync; no scan during sync, and retries/scans cancel when prerequisites fail.
- Permanent UI requirement: do not display a standalone Battery Protection Guard badge/state. Preserve genuinely actionable localized safety/Notify messages; presentation must not weaken thermal protection.
- Exclusive one-App/one-cooler key-lock is a design intent whose end-to-end enforcement remains UNVERIFIED until concrete source path and physical pairing behavior are verified.
- Home/Floating Monitor telemetry shows unknown (`--`) while BLE is disconnected. CONTROL/ADAPTIVE/LED menus show disabled OFF-looking fallback toggles only as a visual fallback, not physical telemetry.
- Touch Adaptive-OFF publishes ADAPTIVE, ADAPTIVE_CEILING, FAN, PELTIER and FAN_SPEED telemetry before acknowledgement.
- CLOUDOTA TIMEOUT/DISCONNECTED is ambiguous; preserve recovery state and await reconnection/result. Only definite rejection with BLE still connected permits rollback.
- Localization English/Indonesia; English ON/OFF, Indonesian HIDUP/MATI. Secure preferences; cooler identity only saved after successful BLE/P1 session.
- Floating Monitor metrics are F/B/H/V/A/P/S; S is the only Fan-related metric. It never owns a second BLE/GATT session. Keep Battery phone heartbeat at 1 Hz and firmware 5-second freshness TTL; no standalone Battery Protection Guard.
- Floating settings no longer render the middle live preview; orientation uses explicit Horizontal/Vertical controls. Native foreground FPS uses SurfaceFlinger TimeStats scoped to Android's resumed/focused package, and telemetry is replayed after overlay startup. A built-in Android 11+ Wireless ADB flow starts a foreground notification, discovers `_adb-tls-pairing._tcp.` via NSD/mDNS, accepts a fresh six-digit code only through notification RemoteInput, pairs the phone's ADB host identity, discovers `_adb-tls-connect._tcp.`, then attempts only the fixed `pm grant com.horizontalzzz.jexfyz android.permission.DUMP` and independently checks the permission. The identity is AES-GCM encrypted under Android Keystore in `noBackupFilesDir`; pairing code is not persisted and no arbitrary shell/remote-host API exists. Kadb 1.3.0 is Apache-2.0 and transitive SPAKE2-Java 1.0.5 is GPL-3.0; the current workflow packages both upstream source trees and the GPL notice alongside one APK in the same private Release. Manual trusted-ADB grant/revoke fallback remains. The Build #39 Flutter test suite passed (80 tests), but APK assembly failed before a deliverable was produced; native compilation and physical pairing behavior remain UNVERIFIED.

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
- User report for V6.3 does not prove V6.6 compile, full BIN transfer, Update.end(), reboot, BLE recovery or installed version.

## 10. App Build / release

- App Build and Firmware compile are separate operations; `@Thinking #Eksekusi Full!` does not imply Build App.
- Prior successful App Build before current loop/speed edits was run `38566673160` on commit `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b`; it validated the prior source only. The current source build is run #35 `38669526891`, commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`; 74 tests/analyze passed, V1/V2/V3 and downloaded asset verified, asset SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`.
- Build #36 includes retargetable Fan Speed interpolation, integer-harmonic loop-seamless wobble, sinusoidal voltage sheen and a squared-sine Bluetooth ripple envelope; `jexSmoothFanSpeedLevel` uses symmetric cubic smoothstep after Build #34 revealed the previous curve's midpoint did not satisfy the explicit test contract. Build #36 passed 77 Flutter tests and Dart analyze and verified APK build/signing/release download for commit `893393388b99fc6d9e59c420070a159a29e45e9a`. Wireless ADB pairing source/tests were committed afterward and are NOT in that APK. Build #39 ran all 80 Flutter tests including the pairing contracts, but APK assembly failed before a deliverable was produced.
- Active workflow `.github/workflows/jexfyz-app-build-trigger.yml`, blob `0e400cbdedfd54506ae3ac3255da41580c86d750`. Trigger title `JE X FYZ — BUILD APP TRIGGER`, body token `JEXFYZ_BUILD_TRIGGER_V1`; only owner/title/token-validated issue-open/reopen. Normal push/PR must not build APK.
- Toolchain: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1. Intended output: one obfuscated, production-signed normal APK `JEXFYZ-release.apk`, release tag `jexfyz-latest`; no Play Store bundle/Actions artifact.
- The only App Build command is `@Thinking #Build App!`. It owns end-to-end build/validation, App-scope repairs/re-runs, Release/asset verification and a durable entry in `APP_BUILD_REPORT.md`. It does not authorize Firmware compile, BIN, Firebase, OTA, flash or device operations. Latest success is Build #36 / run `38689044316` for older source `893393388b99fc6d9e59c420070a159a29e45e9a`; pairing source added afterward is unbuilt. Do not call this documentation/transfer commit a new build.
## 11. Approved grille / design memory

Read DESIGN_NOTES.md before any visual iteration.

- Approved grille: symmetrical solid white geometric square, perfect 1:1 outer contour, central purple X, four corner mounting holes.
- Preserve interior pattern/frame; remove only the two small left/right midpoint protrusions when that exact adjustment is requested.
- Flat 2D print-ready: no shadow, bevel, faux depth, gradient or texture.
- User tried HZ but explicitly reverted to the purple X. Purple X is approved.
- “Enlarge only” means scale the existing approved design; do not invent or redesign pattern/logo/hole/frame.
- Preserve transparent 1:1 icon/cooler PNG aspect ratio/transparency.

## 12. Prior memory cleanup / reconciliation completed (historical)

- Canonical memory routing is in `MEMORY_INDEX.md`; the transfer snapshot is only a boot bridge. `PROJECT_STATE.md` is current-only and `CHANGELOG.md` retains labeled history.
- README navigation, CHAT_RULES, PROJECT_STATE, HANDOVER, APP_NOTES, FIRMWARE_NOTES, BUILD_NOTES, CHANGELOG, firmware technical reference and OTA protection were updated where durable constraints or current evidence boundaries were missing.
- `APP_NOTES.md` now records the one-second phone Battery heartbeat, firmware 5-second freshness TTL, default Battery zones, no standalone Battery Protection Guard UI, and the one-App/one-cooler pairing-lock intent as unverified implementation.
- Firmware notes/technical reference/OTA protection now document the boot SoftAP 10-second no-client timeout, 60-second hard limit after interaction and 160 ms Wi-Fi-off settle before BLE radio ownership.
- `CHAT_TRANSFER_PROMPTS.md` is expanded to include complete tree and cross-reference audit rules plus a JE X FYZ durable-decision catalogue across hardware, thermal/Adaptive, App UI/BLE/P1, OTA/build and grille design. It preserves rejected approaches and evidence caveats.
- The retired path `firmware/FIRMWARE_ANALYSIS.md` is not present as an individual file in the live tree; prior context remains in the legacy archive snapshots. The current code-level reference is `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`.
- The old `test/v5_9_contract_test.dart` was already renamed to `test/app_protocol_notify_contract_test.dart`; contents unchanged, not run.
- This reconciliation preserved two distinct reported restart incidents, the unimplemented rapid-Hotside-rise request, and the Adaptive-OFF-after-restart LED symptom as clearly unverified/historical; no functional source behavior changed.
- Three dated `archive/LEGACY_*.md` snapshots remain untouched for forensic recovery; do not copy their old CURRENT/ACTIVE blocks into current notes.
- Artifact repo was checked at the end of this pass and contains only `JEXFYZ.cpp.bin`; this task did not touch its content/blob. App repo remains sole location for all documentation.
- In that earlier memory-cleanup task, no functional code changed and no test/analyze, App Build, Firmware compile, BIN generation/publication, Firebase edit, flash/OTA or release was performed. The current V6.6 LED source change is documented above and in the current source hashes.

## 13. Historical version pointer — old history is not current

- V6.6: current editable Firmware source. The user considers Firmware V6.6 final/correct and reports successful compile plus two successful Online OTA updates using the same version; do not reopen Firmware work without separate explicit request/authorization.
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

1. Latest authorized manual App Build #36 completed on code commit `893393388b99fc6d9e59c420070a159a29e45e9a`; it passed Dart analyze, 77 Flutter tests, V1/V2/V3 checks and downloaded release verification. Wireless ADB pairing is newer and needs a separately authorized build/QC plus physical device testing.
2. Build #36 asset SHA-256 is `a5c9d97a3d28f7f711b0cd3c524289bc136cecec56d3b1d88821e43c713e9a13`; V1/V2/V3 passed on built and downloaded assets. JAR/V1 reports dependency META-INF entries unprotected, including `META-INF/services/a1` and `META-INF/services/b1`. This asset predates Wireless ADB pairing.
3. On device, verify Fan coast-down/full colour; box-free Peltier crystal/no OFF fade; Speed gauge animates smoothly from each current value to successive target changes (including an update mid-transition), percentage text stays authoritative, ON wobble has no loop jump and OFF reaches far-left/0 over 520 ms.
4. Verify voltage sheen has no snap at either endpoint, Bluetooth ripples fade smoothly when radius wraps, plus notification JE icon/tap, Color Picker draft preview/Select confirmation/Cancel rollback/outside and system-Back blocking, offline `--` fallback and authoritative state after reconnect.
5. Build #36's existing regression suite and Dart analyze passed on its older source commit (77 tests). `test/adb_pairing_contract_test.dart` ran as part of Build #39's 80-test pass. Android/Kotlin compilation, physical notification pairing, mDNS, encrypted identity persistence, ADB connection, DUMP grant and live foreground FPS remain UNVERIFIED because APK assembly did not complete.
6. Preserve no-standalone Battery Protection Guard UI, 1 Hz phone Battery heartbeat/five-second Firmware freshness TTL and one-App/one-cooler pairing as unverified enforcement.
7. Firmware V6.6 is final by user acceptance after two reported successful same-version Online OTA updates. Do not edit/compile Firmware or run BIN/Firebase/OTA/flash operations unless user explicitly reopens Firmware work and separately authorizes it. The historical rapid-Hotside-rise request remains unimplemented; do not add proactively.
8. App Build #36 and release publication completed successfully for its older source. No Build App workflow was triggered by this recovery. No Firmware compile, BIN/Firebase/OTA/flash or physical hardware operation was performed.
## 15. Evidence labels and don't guess

- CURRENT / VERIFIED = directly rechecked live repo/run.
- SOURCE IMPLEMENTED / NOT RUN = code/test contract exists; it didn't necessarily execute.
- USER-REPORTED = user said it happened; not independently verified.
- UNVERIFIED = evidence missing.
- HYPOTHESIS = plausible, unconfirmed cause.
- HISTORICAL / SUPERSEDED = only valid for the old version named.
- NOT RELEASED = no authorized/proven production release.

Never equate test file with passing run; compile with full OTA installation; blue LED with successful HTTP; ACK with hardware state; reboot with proven brownout; version bump with BIN build; or existing BIN with source provenance.

## 16. Live blob fingerprints at pre-transfer HEAD `d638f6941d9ac16a228f4b78ed001ca2e925f716`

Checkpoint fetched immediately before this final transfer replacement. The recursive root tree is `e497c41249c7af91ca3d128c84fbed7ad61eca79` (76 entries / 55 blobs, non-truncated). These fingerprints refer to that verified parent checkpoint; this final transfer's blob/commit will differ.

Canonical project memory:
- `APP_NOTES.md`: `9c383ae3b4e2c53b553b3c5825fa7f4a4ada0dcb`
- `APP_BUILD_REPORT.md`: `a9a235a5301b282baa1229f54f624c7c26bd4801`
- `BUILD_NOTES.md`: `276274d5695e4ff7b2eca327cc9bf1c13ff7b41b`
- `CHANGELOG.md`: `39c17f1a6b6d4e26f724e4253d532228e198b314`
- `CHAT_RULES.md`: `9fd735f74edac08404528cc7c61e4a03e96a1e8e`
- `CHAT_TRANSFER_PROMPTS.md`: `5b252c88235ed92c82b7cb3fab5d02af9584a37c`
- `DESIGN_NOTES.md`: `e04382659dfdd618de0a156046f140452d275dc7`
- `FIRMWARE_NOTES.md`: `db53605779f157b3c966b15a07bef73199ca575d`
- `HANDOVER.md`: `f795fe3149a865db462ba0780f1368d61670e9d7`
- `MEMORY_INDEX.md`: `bf45cbe1f83c99e44d480a9f79b365ebaa30d9cc`
- `OTA_PROTECTION.md`: `06beb86b749b0f0e14c8cb517e43fe7c0f66a4e1`
- `OTA_REGRESSION_MEMORY.md`: `4342f3da76cf2962140146fbbe0ff8de5e956f4d`
- `PROJECT_STATE.md`: `7f29382eea586b0a93e6c31b576b3b739c6e58a3`
- `README.md`: `8d59077cf8c8dd89c15c5ca534cceff841296004`
- `VOLTAGE_TRANSITION_MEMORY.md`: `1c2167659fd0ed8f5db16bf63eb7897344a690ea`

Workflow/configuration:
- `.github/workflows/jexfyz-app-build-trigger.yml`: `187956b1344680eaf89f48fec28fd8a92e77f832`
- `pubspec.yaml`: `8f558273e21692af9958f914527fdc62d623d63a`
- `pubspec.lock`: `1e92812bfda2c28244a0556d71d1ec94084acc66`
- `android/app/build.gradle`: `05a0b863cfc6d73dc3789e364d7000eee0f3db0e`
- `android/build.gradle` (parent checkpoint): `ca11c0f28728b40577d25490811bcc2c8d05ca24`; updated blob in this execution: `bb8c0caf26927bd614bb9b05ef79366424063663`.
- `android/app/src/main/AndroidManifest.xml`: `2124dcd969347d2c7bb1bd99374a398cf50d2387`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`: `f7340e82a12cece063e310546dcba893e6a5a09f`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/WirelessAdbIdentityStore.kt`: `394eab93a17c563caf7db0511d4d36040c1c59ec`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/WirelessAdbPairingService.kt`: `7f2099cac0c78008d395ec0bb83e32e5f6d55384`
- `third_party/Kadb-1.3.0-LICENSE.txt`: `261eeb9e9f8b2b4b0d119366dda99c6fd7d35c64`

App source:
- `lib/main.dart`: `d097adea48988700a8a80ac423cc088959cfa1f6`
- `lib/floating_monitor.dart`: `bd230aee16fa77a0d8d2afb9f1a0c2d80cdcac86`
- `lib/app_settings.dart`: `c513cd4381ee960cd43612c4ac01e7954f651f62`
- `lib/jex_animated_glyph.dart`: `c9c5c2802cb0ed363c042620511148b0d58d36c4`

Tests:
- `test/adb_pairing_contract_test.dart`: `03609184edc5b2df09f40e62ffe99959ea337bad` (included in Build #39's 80-test pass; native pairing remains unverified)
- `test/widget_test.dart`: `bf403ee3d29e8d2f3f6839b2244a00f1b60e8bdb` (Home icon-level and Notify status assertions included in Build #39's 80-test pass)
- `test/v6_6_qc_contract_test.dart`: `2bee4d960d014f0765422dcb5ed1c9870ba6ee3a`
- `test/firmware_touch_adaptive_sync_test.dart`: `2d3fea509343a03b8d23623f4dcb2dd7fd972d39`
- `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`

Additional native/visual files:
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `038f12b2ca82255a3b202b10dd770d5caa5b2bbf`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt`: `9ea4dce7001bcd5cc10f9c1c7ad62f34ec54b03e`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt`: `aecfc87121f2195ef6724613c612d674ed95ae55`
- `android/app/src/main/res/drawable-nodpi/jexfyzicon.png`: `bad855f23416fd58aff194c30b7f8fd77f260ea8`
- `android/app/src/main/res/drawable/ic_notification.xml`: `cda9e8404d14a62a61157ec59fae2e491c19f5f7`
- `android/build.gradle`: `ca11c0f28728b40577d25490811bcc2c8d05ca24`
- `android/gradle.properties`: `13564f62c79279ecfd4fe0a8a247a4d2a4b11451`
- `android/settings.gradle`: `14545695cc9aba5912393ec293c284ee60d9ec10`
- `assets/jexfyzcooler.png`: `fbc47e3197534ae35330c1f1793c99705e5165d1`
- `assets/jexfyzicon.png`: `bad855f23416fd58aff194c30b7f8fd77f260ea8`
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `21b93fd525f04663d9a5e528fb926334d2acb816`
- `firmware/JEXFYZ-V6.6.ino`: `f51ba6db5d0e91318f63fea4014bb87f7bf76222` (not changed)

Artifact repository: `TenzoNkz/JEXFYZ-Firmware` main HEAD `cc0a0ae32b826753525c3f2a4442526648cef631`; root tree `b4db8f4e86dfb97d3313c70428b92eb9d4bd7511`; root contains only `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. Source/BIN provenance remains independently unverified.

## 17. Wireless ADB pairing recovery and Floating FPS execution outcome

- `@Thinking Chat Stuck!` is a standalone recovery command. It inspects live output, repository and last verified checkpoint, avoids blind repeats and resumes only the last valid authorization. It does not trigger Build App or authorize Firmware/device operations.
- Floating Monitor settings center preview is removed; Horizontal/Vertical is controlled explicitly. FPS uses native SurfaceFlinger TimeStats filtered to Android's resumed/focused foreground package. Telemetry replay/layout refresh and disconnected `--` behavior remain in the existing implementation.
- Recovery found the pairing feature already in live `main` via commits `4ad5d99bcea96e865978e3003482661b1e26101f` and `89855b59c8d6ee40151847e6633a07cb75aff6b0`. Commit `8b6939474386bbc8393185240e571faa23df4d54` added local discovery manifest permissions, a short-lived multicast lock, fixed grant confirmation polling and Android 13+ notification-permission preflight. Current docs were reconciled in `e1fb39b583cf693a55ca56ce5d433f03b985b40f`; this transfer commit is the final write.
- Pairing is Android 11+; its notification accepts a fresh six-digit code via `RemoteInput`, uses Kadb 1.3.0, local NSD/mDNS and loopback ADB, attempts only `pm grant com.horizontalzzz.jexfyz android.permission.DUMP`, then checks permission state. RSA identity is AES-GCM encrypted under Android Keystore in `noBackupFilesDir`. Pairing code is not persisted; no arbitrary shell or user-provided host/port API is exposed. Manual grant/revoke remains available.
- `test/adb_pairing_contract_test.dart` adds source assertions for notification RemoteInput, six-digit validation, fixed grant, encrypted identity, network permissions and multicast-lock lifecycle. Build #39 confirms Dart analysis passed and all 80 Flutter tests passed. The APK failed to assemble at the missing Maven artifact, so Android/Kotlin packaging and physical pairing remain unverified.
- Latest successful APK is Build #36 / run `38689044316` for older source commit `893393388b99fc6d9e59c420070a159a29e45e9a`; all 77 Flutter tests, Dart analyze, obfuscated APK, signing and Release re-download gates passed for that source. The APK does NOT include pairing. Full QC requires separate explicit `@Thinking #Build App!`.
- Pairing discovery, RemoteInput, encrypted identity persistence, ADB connection, OEM DUMP grant, live game FPS and physical overlay behavior remain UNVERIFIED pending build/device testing.
- Firmware V6.6 source, artifact BIN, Firebase, workflow trigger, OTA/flash and hardware were not changed or operated.
## 18. Home indicator animation + Notify label execution outcome

- User approved a complete redraw of all seven Home status indicators while keeping the original Home layout, cooler image placement, and submenu structure unchanged.
- Implemented in `lib/main.dart`: a separated thermometer tube/bulb with no crossing heat waves; segmented battery-temperature indicator; moving charge sweep clipped to the voltage bolt; compact Adaptive core/orbit; simplified six-arm Peltier crystal with four peripheral sparks; independently rotated Fan blades with the existing voltage-dependent speed and smooth coast-down; and a telemetry-driven Fan Speed gauge.
- Added `jexTemperatureIndicatorLevel` to normalize valid Celsius readings into clamped animation levels. Battery and Hotside level changes retarget with 520 ms cubic easing. Missing telemetry receives only a neutral visual fallback while BLE/session gating remains authoritative. Adaptive orbit animation is active only when Adaptive state is ON.
- Home Notify right-side badge now says CONNECTED / DISCONNECTED exactly in both app languages. The normal detail message “Bluetooth Disconnected” maps to DISCONNECTED rather than being misclassified as ERROR. Explicit failures, discovery errors, Connecting and Syncing remain distinct.
- Regression assertions added in `test/widget_test.dart` for numeric parsing/clamps/missing sensor data and Notify status in English/Indonesian, including a normal Bluetooth-disconnect message. Static source assertions confirmed the single-backslash Dart regex, removed Hotside heat-wave strokes, exact CONNECTED/DISCONNECTED labels in both language settings, and regression assertions. Chat Stuck recovery also reconciled stale current-source fingerprints and old Build #35 release metadata in PROJECT_STATE / APP_NOTES; Build #36 asset checksum/size is now recorded accurately. The current execution environment lacks Flutter/Dart/Gradle tools; GitHub Actions Build #39 did run Dart analysis and all 80 Flutter tests, but APK assembly failed at the missing Maven artifact. Android/Kotlin packaging and physical visual motion remain NOT RUN/UNVERIFIED.
- Source/UI commit: `266548b1f97a36d745a2f34e7e0ba88bf2b6c056` (`feat(ui): redesign animated home indicators and notify status`). Follow-up fixes: `a6e6b9077226fd76ca2ef7423b7800955edab5bd` (temperature parser and normal disconnect semantics), `13dfe6080feb0072b9213f11c33068b2989b437a` (exact status text in both languages), `9d574f1a64c00ad7449814fd8dac9c3f6345bba3` (current documentation fingerprints).
- Current UI-related blobs: `lib/main.dart` `d097adea48988700a8a80ac423cc088959cfa1f6`; `lib/app_settings.dart` `c513cd4381ee960cd43612c4ac01e7954f651f62`; `test/widget_test.dart` `bf403ee3d29e8d2f3f6839b2244a00f1b60e8bdb`. This work has NOT been built into an APK; the last successful App Build remains #36 / `38689044316` on old commit `893393388b99fc6d9e59c420070a159a29e45e9a`. Next build requires the separate `@Thinking #Build App!` authorization and physical device verification.
- The Home UI work did not touch Firmware V6.6 source/BIN, Firebase metadata, OTA, device flash or physical hardware. Artifact repository remains BIN-only and open PR count is zero.

## 19. Final rule for the next chat

Do not restart project development from this snapshot alone. Boot from live main, read canonical memories fully, preserve every durable user decision and rejected approach, recover missing history from archives without guessing, and persist meaningful outcomes in the correct canonical note. Replace the transfer file at the end of every substantial context-limit reconciliation, after reading its prior version completely.