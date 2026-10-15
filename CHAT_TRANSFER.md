# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Snapshot date: 2026-10-15 (Asia/Jakarta). Live checkpoint before this transfer replacement: main HEAD `1b1b8d3088b04bf8270d0984cd14374b290f3403`, commit timestamp `2026-10-15T01:54:44Z` UTC, message `docs: update latest verified CI reference`, parent `0fad780446890be26b0d94c36fd42ac006da6c8c`. This detailed transfer file bridges project memory across chats. It is a snapshot, NOT a substitute for fetching live GitHub state; verify live hashes/status after the transfer commit.

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

- **Live checkpoint:** main HEAD `1b1b8d3088b04bf8270d0984cd14374b290f3403` at commit timestamp `2026-10-15T01:54:44Z` UTC.
- **Canonical repository/branch:** `TenzoNkz/JEXFYZ-App` / `main`.
- **Main HEAD immediately before this transfer write:** `1b1b8d3088b04bf8270d0984cd14374b290f3403`; message `docs: update latest verified CI reference`; parent `0fad780446890be26b0d94c36fd42ac006da6c8c`; commit timestamp `2026-10-15T01:54:44Z` UTC. Root tree `b77a46b4e6ab8613f89d7e66ac46f451beb81031`; verified recursive inventory `65` entries, `47` blobs including the transfer file, `46` other blobs, `truncated=false`.
- **Live branch tips:** `diag/latest-stable-v16` `ec77759d224c581870d98330d9278896ff29e50b`; `diagnostic/v1.6-heap-check` `1a4cd83b3ee82cdc2d86277dc4a0eb4c4238f8a3`; `fix/adaptive-power-sequencing` `33740be782d976a881e285bbf8b86b3b485b83c1`; `tmp-jexfyz-v5-test` `b388cba98ea1d9e92873df64ba3224d6cb99156d`; `main` `1b1b8d3088b04bf8270d0984cd14374b290f3403`. Open PRs: 0.
- **Active Firmware source:** `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION = "V6.6"`. Exactly one active versioned `.ino` is tracked and filename/version align. **USER ACCEPTANCE 2026-10-14:** user considers V6.6 correct/final and reports successful compilation and two successful Online OTA flashes/updates with the same version V6.6. Do not modify/recompile/reflash unless the user explicitly reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified, but is not an active task by itself.
- **Current App identity/source:** `lib/main.dart` blob `a1818d281fdbea900bf9cde5b83c40d09d61dcc3` (267,000 bytes); `test/widget_test.dart` blob `4b7bf68f3c73d6ffe80509ccb75ce6e08607b020` (35,748 bytes); `lib/app_settings.dart` `232a7575460e5417f7b760f24b5057687a47ee1a`; `lib/floating_monitor.dart` `cfc21b3dc198b925786aa98658d647b1d8a3637b`. Package `com.horizontalzzz.jexfyz`, pubspec `1.0.0+3`; preserve Gradle `versionName "Telegram @horizontalzzz"`.
- **Current native notification files:** `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt` blob `aecfc87121f2195ef6724613c612d674ed95ae55`; `android/app/src/main/res/drawable/ic_notification.xml` blob `cda9e8404d14a62a61157ec59fae2e491c19f5f7`. The notification helper uses the transparent bold-white JE vector as the sole small icon and sets no large icon; launcher/app imagery still uses `jexfyzicon`.
- **Fan motion:** BLE voltage class continues to set speed: 5V = 2600 ms, 9V = 1250 ms, 12V = 620 ms. Voltage changes preserve phase by easing to an equivalent full-turn boundary. On OFF, the Fan coasts forward with ease-out over up to 0.16 turn (duration is scaled to current cycle), then retains the resting angle; blade/hub colours remain full-strength.
- **Peltier icon/motion:** the square thermoelectric module frame, center box and corner bolts are removed. The icon is a free-standing six-branch frost crystal with particles. While ON, crystal drift animates and frost density/intensity interpolates over 420 ms across voltage classes; when OFF, controllers stop and the crystal freezes at its current pose at full colour. No OFF fade. This is decorative UI, not a physical ice or temperature measurement.
- **Dialog sizing:** Color Picker title 22sp, selected-color label/Cancel 15sp, swatches 42dp; bottom-pinned, no draggable outer scroll panel, and localized Cancel dismisses without sending RGB. Peltier Safety title 24sp, body 17sp, action text 16sp with 48–50dp targets. Existing Fan-before-Peltier approval gate is unchanged; palette colors are unchanged.
- **Latest successful App Build before current smooth-animation edits:** run `38566673160` on commit `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38566673160). Audit, dependency install, Dart analyze, Flutter tests, APK build and downloaded release verification passed for that earlier source. V1/V2/V3 were true for built APK and downloaded asset with `--min-sdk-version 23`. Release `jexfyz-latest` has one `JEXFYZ-release.apk` (54,521,947 bytes; SHA-256 `f7ae531834c17fea0dd187307e2e8961dca65aa87b96754082b41475bfc9c845`). Logs warn `META-INF/services/a1` and `META-INF/services/b1` are not protected by JAR/V1. This build predates current Fan Speed retargeting, sinusoidal voltage sheen and Bluetooth ripple-envelope edits.
- **Build workflow:** `.github/workflows/jexfyz-app-build-trigger.yml`, blob `0e400cbdedfd54506ae3ac3255da41580c86d750`. Signing hardening was exercised by run `38566673160`: V1/V2/V3=true for build APK and downloaded release asset using `--min-sdk-version 23`; Android manifest minSdk remains 24. JAR/V1 warnings for `META-INF/services/a1` and `META-INF/services/b1` remain. Trigger title `JE X FYZ — BUILD APP TRIGGER`, required body token `JEXFYZ_BUILD_TRIGGER_V1`, Ubuntu 24.04 / Java 17 / Flutter 3.47.2 / Gradle 9.3.1. Current smooth-animation source has not been built.
- **Artifact repository:** `TenzoNkz/JEXFYZ-Firmware` main HEAD `cc0a0ae32b826753525c3f2a4442526648cef631`, root tree `b4db8f4e86dfb97d3313c70428b92eb9d4bd7511`; live recursive root contains only `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. Provenance matching V6.6 source remains UNVERIFIED.
- **Operation boundary:** App source and widget regression contracts changed at the hashes above. Static source/readback checks passed; current-source Flutter tests/analyze and device rendering have NOT run. Latest successful CI run `38566673160` verified tests/analyze/build/signature on older commit `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b`, not current source. No App Build was started during this animation task. No Firmware source/compile, BIN replacement, Firebase metadata, OTA/flash/device operation occurred. User accepts Firmware V6.6 as final after two same-version Online OTA updates. Phase remains DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED.

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
- LED UI: compact mode-name-only strip with four LEDs on each side; preview visibility is independent of hardware Brightness. Color Picker has 36 localized hue-ordered presets, no HEX labels, legacy aliases including Cyan #00FFFF, and is pinned to the bottom safe area. Localized top-left Cancel dismisses without sending RGB; swatch selection retains the COLOR command path.
- Dashboard Fan rotor follows authoritative BLE voltage: 5V = 2600 ms, 9V = 1250 ms, 12V = 620 ms. Voltage transitions preserve angular phase; Fan OFF eases forward to a full stop and retains its final pose with full-colour blades/hub.
- Peltier dashboard symbol is now a free-standing six-arm crystal (no square frame, center box or corner bolts). Frost intensity/density transitions over 420 ms across voltage classes while ON; when OFF, the full-colour crystal freezes in place and does not fade. Crystal drift is periodic when animated; this is only visual feedback, not a physical ice/temperature measurement.
- Fan Speed keeps its percentage bound to authoritative telemetry. A dedicated controller retargets its visible gauge from the current rendered level to the new target over 420 ms; a further target arriving mid-transition continues from the current visible level. OFF eases to 0 over 520 ms. The subtle ON needle wobble uses integer-frequency sine harmonics and is continuous at the loop boundary.
- Voltage-bolt sheen moves sinusoidally back and forth instead of snapping to the left edge. Bluetooth ripples use a squared-sine opacity envelope that reaches transparency with zero slope at repeat boundaries.
- Color Picker typography: 22sp title, 15sp selected-color label and Cancel, 42dp swatches and 44dp Cancel touch target. Peltier Safety: 24sp title, 17sp body, 16sp actions, larger responsive padding and 48–50dp button targets. No palette-color change. The Fan-before-Peltier gate and Cancel/Turn On Fan semantics remain unchanged.
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

- App Build and Firmware compile are separate operations; `@Thinking Eksekusi Full!` does not imply Build App.
- Latest successful App Build is run `38566673160` on earlier source commit `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38566673160). Audit, dependency resolution, Dart analyze, Flutter tests, APK build and release re-download verification passed for that source. `apksigner verify --min-sdk-version 23` reported V1/V2/V3=true for built APK and downloaded asset. Release contains one `JEXFYZ-release.apk` (54,521,947 bytes; SHA-256 `f7ae531834c17fea0dd187307e2e8961dca65aa87b96754082b41475bfc9c845`). Logs warn `META-INF/services/a1` and `META-INF/services/b1` are not protected by JAR/V1.
- That successful build predates current smooth Fan Speed retargeting, integer-harmonic wobble, sinusoidal voltage sheen and Bluetooth ripple-envelope source/test changes. These edits have not been built or tested by Flutter.
- Only workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `0e400cbdedfd54506ae3ac3255da41580c86d750`. Trigger title `JE X FYZ — BUILD APP TRIGGER`, required body token `JEXFYZ_BUILD_TRIGGER_V1`; issue-open/reopen only after owner/title/token validation. Normal push/PR must not generate an APK.
- Toolchain: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1. Intended output is one obfuscated, production-signed normal APK `JEXFYZ-release.apk`; no Play Store bundle or Actions artifact.
- Run App Build only after explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`. No App Build was run in this animation execution.
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
- The retired `firmware/FIRMWARE_ANALYSIS.md` remains archived; current code-level reference is `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`.
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

1. After explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`, build the current App source and record real Dart analyze/Flutter test results, run ID and source SHA. Latest successful run `38566673160` covers earlier source `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b`, before the present animation edits.
2. Check new APK signing: require V1/V2/V3=true for built APK and re-downloaded asset; confirm official certificate digest `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` and published asset SHA. Previous successful run warned that `META-INF/services/a1` and `META-INF/services/b1` are not protected by JAR/V1.
3. Install the resulting APK and recheck MT Manager. The earlier screenshot predates run `38566673160`, so current-install evidence remains missing.
4. Physically verify Fan OFF easing to full stop without dimming; Peltier is a visible full-colour six-arm crystal with no square box/bolts and no OFF fade; Speed gauge smoothly retargets between multiple speeds including a second change mid-transition, percentage stays authoritative, needle wobble is continuous, and OFF returns smoothly to far-left/0.
5. Verify voltage sheen has no edge snap and Bluetooth ripple rings fade smoothly across repeat boundaries; also verify notification JE icon/tap, dialog sizes/Cancel, offline `--` fallback and telemetry restore after reconnect.
6. Preserve no-standalone Battery Protection Guard UI, 1 Hz phone Battery heartbeat/five-second Firmware freshness TTL and one-App/one-cooler pairing as unverified enforcement.
7. Firmware V6.6 is final by user acceptance after two reported successful same-version Online OTA updates. Do not edit/compile Firmware or run BIN/Firebase/OTA/flash operations unless the user explicitly reopens Firmware work and separately authorizes it. The historical rapid-Hotside-rise request remains unimplemented and must not be added proactively.
8. No App Build was started for this animation execution; no Firmware source/compile/BIN/Firebase/OTA/flash/release operation happened.
## 15. Evidence labels and don't guess

- CURRENT / VERIFIED = directly rechecked live repo/run.
- SOURCE IMPLEMENTED / NOT RUN = code/test contract exists; it didn't necessarily execute.
- USER-REPORTED = user said it happened; not independently verified.
- UNVERIFIED = evidence missing.
- HYPOTHESIS = plausible, unconfirmed cause.
- HISTORICAL / SUPERSEDED = only valid for the old version named.
- NOT RELEASED = no authorized/proven production release.

Never equate test file with passing run; compile with full OTA installation; blue LED with successful HTTP; ACK with hardware state; reboot with proven brownout; version bump with BIN build; or existing BIN with source provenance.

## 16. Live blob fingerprints at pre-transfer HEAD `1b1b8d3088b04bf8270d0984cd14374b290f3403`

Fetched from live recursive tree `1b1b8d3088b04bf8270d0984cd14374b290f3403` immediately before this transfer write (65 entries; 47 blobs including the transfer file; 46 fingerprints below excluding this transfer file; `truncated=false`). The transfer file's own new blob SHA is intentionally omitted.

Canonical project memory and docs:
- `APP_NOTES.md`: `2e24b49f87f3a02681a4f242c4ae99239921d9f8` (14109 bytes)
- `BUILD_NOTES.md`: `fee1985c4fb1e4fc8ca2177689a740123005d3db` (6004 bytes)
- `CHANGELOG.md`: `586cd5c4cf8c5dc71e6b0d556087a8960871fc3f` (27118 bytes)
- `CHAT_RULES.md`: `b5bc4743bc5ef0fbf9297020799ae8dba00974bd` (8427 bytes)
- `CHAT_TRANSFER_PROMPTS.md`: `cb2290bf2b1b404cde29fc1b68b90ebbc1e62f34` (28068 bytes)
- `DESIGN_NOTES.md`: `e04382659dfdd618de0a156046f140452d275dc7` (2128 bytes)
- `FIRMWARE_NOTES.md`: `db53605779f157b3c966b15a07bef73199ca575d` (11583 bytes)
- `HANDOVER.md`: `06198716bd8d6bc35890bafcf7ce382e84085589` (6830 bytes)
- `MEMORY_INDEX.md`: `3be937ccf9f359166f88f2d20bcfb1a8824fe10d` (6859 bytes)
- `OTA_PROTECTION.md`: `06beb86b749b0f0e14c8cb517e43fe7c0f66a4e1` (4259 bytes)
- `OTA_REGRESSION_MEMORY.md`: `e961ca32a22ebf0fcba8ed221f12cc17a6429f52` (3953 bytes)
- `PROJECT_STATE.md`: `a0eac140d444e22fa825ad3c84903da8edbd65c5` (14394 bytes)
- `README.md`: `f0eca08bc811c8e89cf127e37486ceeae2171b0e` (4344 bytes)
- `VOLTAGE_TRANSITION_MEMORY.md`: `cf97f4745e6f5e33ce57beece5b2c1f742029b44` (5916 bytes)

Workflow and package files:
- `.github/workflows/jexfyz-app-build-trigger.yml`: `0e400cbdedfd54506ae3ac3255da41580c86d750` (19662 bytes)
- `.gitignore`: `a51c5ad7dabd81d6a7e42181fa7d5c3a25bdac15` (424 bytes)
- `pubspec.lock`: `1e92812bfda2c28244a0556d71d1ec94084acc66` (20203 bytes)
- `pubspec.yaml`: `8f558273e21692af9958f914527fdc62d623d63a` (833 bytes)

App source:
- `lib/app_settings.dart`: `232a7575460e5417f7b760f24b5057687a47ee1a` (52678 bytes)
- `lib/floating_monitor.dart`: `cfc21b3dc198b925786aa98658d647b1d8a3637b` (51218 bytes)
- `lib/jex_animated_glyph.dart`: `c9c5c2802cb0ed363c042620511148b0d58d36c4` (1730 bytes)
- `lib/main.dart`: `a1818d281fdbea900bf9cde5b83c40d09d61dcc3` (267178 bytes)

Tests:
- `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8` (867 bytes)
- `test/firmware_touch_adaptive_sync_test.dart`: `2d3fea509343a03b8d23623f4dcb2dd7fd972d39` (1622 bytes)
- `test/v6_6_qc_contract_test.dart`: `2bee4d960d014f0765422dcb5ed1c9870ba6ee3a` (20211 bytes)
- `test/widget_test.dart`: `4b7bf68f3c73d6ffe80509ccb75ce6e08607b020` (35762 bytes)

Android configuration, native code and icons:
- `android/app/build.gradle`: `6e216204908603d213700bcfcbc7f040f73d96f8` (4679 bytes)
- `android/app/google-services.json`: `f3ed065a7ee56b2a44f0a943a48fa578ba72e0d7` (761 bytes)
- `android/app/proguard-rules.pro`: `50fc26f726ae8660fe04cf19da688431c8dca4a0` (370 bytes)
- `android/app/src/main/AndroidManifest.xml`: `d82504cee09092d304d8edc98272ddd0b4732519` (3587 bytes)
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `55972b64329a2e1cc91e29a172d0a97a118d8ac1` (32562 bytes)
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt`: `9ea4dce7001bcd5cc10f9c1c7ad62f34ec54b03e` (3350 bytes)
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt`: `aecfc87121f2195ef6724613c612d674ed95ae55` (1043 bytes)
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`: `6c17a7e38c3a5b3f3f8fc6b3e5b38a99fd83081e` (15940 bytes)
- `android/app/src/main/res/drawable-nodpi/jexfyzicon.png`: `bad855f23416fd58aff194c30b7f8fd77f260ea8` (436439 bytes)
- `android/app/src/main/res/drawable/ic_notification.xml`: `cda9e8404d14a62a61157ec59fae2e491c19f5f7` (516 bytes)
- `android/build.gradle`: `ca11c0f28728b40577d25490811bcc2c8d05ca24` (593 bytes)
- `android/gradle.properties`: `13564f62c79279ecfd4fe0a8a247a4d2a4b11451` (296 bytes)
- `android/settings.gradle`: `14545695cc9aba5912393ec293c284ee60d9ec10` (1233 bytes)

Visual assets:
- `assets/jexfyzcooler.png`: `fbc47e3197534ae35330c1f1793c99705e5165d1` (1830171 bytes)
- `assets/jexfyzicon.png`: `bad855f23416fd58aff194c30b7f8fd77f260ea8` (436439 bytes)

Firmware source and technical reference:
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `59e38e34eb01455618932b7872490dfe79bc2208` (7545 bytes)
- `firmware/JEXFYZ-V6.6.ino`: `f51ba6db5d0e91318f63fea4014bb87f7bf76222` (164410 bytes)

Forensic-only archives:
- `archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md`: `10fab755affdbb8e29727390ad187fcb4bf6817d` (13348 bytes)
- `archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md`: `65ece82c5e8a07908accb4a81bd4c80e469b55de` (154262 bytes)
- `archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md`: `0438b7006d437d2c24d9e76d6aca7352ad5b0b2b` (101008 bytes)

Artifact repository separate check: `TenzoNkz/JEXFYZ-Firmware` main HEAD `cc0a0ae32b826753525c3f2a4442526648cef631`; its live root contains only `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. Source/BIN provenance remains independently unverified.
## 17. Final rule for the next chat

Do not restart project development from this snapshot alone. Boot from live main, read canonical memories fully, preserve every durable user decision and rejected approach, recover missing history from archives without guessing, and persist meaningful outcomes in the correct canonical note. Replace the transfer file at the end of every substantial context-limit reconciliation, after reading its prior version completely.