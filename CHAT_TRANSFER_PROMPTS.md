# JE X FYZ / JE Cooler — Chat Transfer Prompt Templates

Use these templates to move the correct workstream across a context/chat limit without relying on imperfect chat recall. Prompt A is for broad project-memory reconciliation; Prompt B is a read-only general/Discussion boot. For a Build App chat limit, use Prompt D exactly once as the first message in the replacement Build App chat: it loads the current repository/build evidence and continues the same work. There is no separate Build App recap chat or recap prompt. Current command gate: `@Thinking Diskusi!`, `@Thinking Diskusi! Tanya Gemini!`, `@Thinking Diskusi! Jawaban Gemini!`, `@Thinking Eksekusi Full!`, `@Thinking Eksekusi Build App!`, and standalone recovery command `@Thinking Chat Stuck!`. Chat Stuck halts blind retries, inspects live logs/state and resumes only the most recent valid authorization; it does not independently trigger a build or expand scope. The two Gemini subcommands are invalid without `Diskusi!`; App Build attempts and evidence belong in `APP_BUILD_REPORT.md`.

---

## Prompt A — Chat limit / reconcile and save everything

```text
@Thinking Eksekusi Full! CHAT-LIMIT RECONCILIATION — READ EVERYTHING, RECONCILE, SAVE TO REPOSITORY

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPO: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main
ARTIFACT REPO: TenzoNkz/JEXFYZ-Firmware (JEXFYZ.cpp.bin ONLY)

GOAL
Preserve all durable project memory from this chat and earlier project chats in the canonical App repository. Audit the complete repository, correct stale/conflicting notes, and replace CHAT_TRANSFER.md with one detailed, accurate transfer snapshot. Do not rely on remembered summaries where the repository can be checked.

NON-NEGOTIABLE RULES
1. Directly use main unless explicitly instructed otherwise; do not create a branch or PR.
2. Read CHAT_TRANSFER.md completely BEFORE replacing it. Read every current canonical memory/reference file fully, including beyond the first screen/range.
3. Fetch live main HEAD, full recursive tree, active .ino inventory and FW_VERSION, App source/version, all tests, the exact active workflow, open PR/branch state, and current blob SHAs before making claims.
4. Audit every text/document/config/test file in the App repo, not just the files that look like notes. Inspect source/config for current identity, paths, workflows and references. Do not expose credential contents in summaries.
5. Reconcile every old memory against live source. Do not leave contradictory “CURRENT” / “CURRENT TRUTH” blocks from V5.x, V6.1, V6.2, or V6.3 inside current status files. Keep useful history in CHANGELOG.md with a HISTORICAL/SUPERSEDED label.
6. Preserve ALL durable discussion memory: approved features, technical decisions, hardware/wiring, pins, sensor model, timings, UI/UX, app/firmware protocol, safety thresholds, Adaptive modes, LED mapping, OTA decisions, failed approaches and why they failed, user's explicit restrictions, build/release process, visual/grille design, validation evidence and pending checks.
7. Distinguish CURRENT/VERIFIED, SOURCE IMPLEMENTED/NOT RUN, USER-REPORTED, UNVERIFIED, HYPOTHESIS, HISTORICAL/SUPERSEDED and NOT RELEASED. A test file is not proof it ran. A compile report for one version is not proof for a later version. LEDs alone do not prove a specific HTTP/TLS error.
8. If a decision is in chat but not backed by current code, save it as user requirement or a proposed/pending decision—not as implemented behavior. Preserve why a prior path was rejected.
9. Keep every note, memory, handover, transfer prompt, changelog and reference in TenzoNkz/JEXFYZ-App. TenzoNkz/JEXFYZ-Firmware must contain JEXFYZ.cpp.bin only; do not add/readme notes there. Never edit the BIN during documentation work.
10. Do not perform firmware compile, BIN generation/publication, flash/OTA, Firebase/production metadata changes, App Build, release or device operations unless each operation is explicitly authorized. The user compiles firmware.
11. Every functional Firmware source edit requires FW_VERSION bump, matching active filename and exactly one active versioned .ino. Documentation-only work does not cause a version bump.
12. Keep Android versionName "Telegram @horizontalzzz" unchanged.
13. Do not alter protected OTA code during unrelated cleanup. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before touching OTA. Read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits.
14. Rename or delete files only after updating all links, path-based tests and indexes. Verify exact post-write paths and hashes.
15. Do not say “saved/reconciled” unless GitHub confirms the exact writes and the final tree/HEAD are re-read.

REQUIRED READING
- CHAT_TRANSFER.md
- MEMORY_INDEX.md
- README.md
- CHAT_RULES.md
- PROJECT_STATE.md
- HANDOVER.md
- APP_NOTES.md
- FIRMWARE_NOTES.md
- firmware/FIRMWARE_TECHNICAL_REFERENCE.md
- OTA_PROTECTION.md
- OTA_REGRESSION_MEMORY.md
- VOLTAGE_TRANSITION_MEMORY.md
- BUILD_NOTES.md
- CHANGELOG.md
- DESIGN_NOTES.md
- .github/workflows/jexfyz-app-build-trigger.yml
- pubspec.yaml, android/app/build.gradle, manifests and app configuration relevant to the work
- every test file under test/
- current active firmware/App source
Read complete content for all relevant files. Cross-check all links, filenames, version strings, historical labels and hashes.

TASK SEQUENCE
A. Inventory live main HEAD/tree, file sizes/types, branches, PRs, workflow and test files.
B. Read old CHAT_TRANSFER.md fully and read the required memory docs fully.
C. Search and review every file reference for stale paths, wrong source version, duplicated current-state blocks, old build claims and claims unsupported by evidence.
D. Compare durable memories from the current chat and available prior project context with repository notes; categorize KEEP CURRENT, MOVE TO CANONICAL FILE, MARK HISTORICAL, CORRECT, or UNVERIFIED.
E. Reorganize docs under clear names while preserving meaningful details. Do not create two competing “current truth” sources. MEMORY_INDEX.md must route each category to one canonical file.
F. Update canonical notes and CHANGELOG with the durable decisions/results that are missing.
G. Rebuild CHAT_TRANSFER.md as a complete boot snapshot: live HEAD and timestamp/timezone; current active source/version/hash; App version/source; test/workflow state; branch/PR state; repo roles; permanent user rules; hardware/pin/sensor summary; current safety/Adaptive/timing behavior; App/BLE/UI constraints; OTA trade-off and protected-flow reminder; approved visual design; history pointers; verified vs reported vs unverified evidence; next exact actions.
H. Re-fetch all changed files and verify the repository tree, exact filenames, source constant/path alignment, all references, hashes and main HEAD. Check the App repo contains the notes; confirm the artifact repo holds only the BIN if repository cleanup is within the explicitly authorized scope.
I. Commit direct to main. Report only verifiable changes, final commit(s), changed/deleted paths, current state, and operations explicitly not performed.

DONE CONDITIONS
- No duplicate/conflicting current-status blocks remain in current files.
- All durable decisions have a home and are linked from MEMORY_INDEX.md.
- The transfer snapshot is long and detailed enough to boot the next chat without asking the user to repeat known decisions.
- Every retained history item is clearly historical; every unverified result remains unverified.
- File references and current blob hashes match live main after writing.
```

---

## Prompt B — New chat boot / learn before asking questions

```text
@Thinking Diskusi! NEW CHAT BOOT — LOAD JE X FYZ MEMORY BEFORE DOING ANYTHING

Work on JE X FYZ / JE Cooler from repository memory. Do not assume this chat is the first conversation.

1. Read CHAT_TRANSFER.md fully first.
2. Fetch live TenzoNkz/JEXFYZ-App main HEAD and recursive tree. Then read MEMORY_INDEX.md, CHAT_RULES.md, PROJECT_STATE.md and HANDOVER.md fully.
3. Read the complete subject reference that matches the current request. For App: APP_NOTES.md. For Firmware/hardware: FIRMWARE_NOTES.md + firmware/FIRMWARE_TECHNICAL_REFERENCE.md. For OTA: OTA_PROTECTION.md + OTA_REGRESSION_MEMORY.md. For voltage/Peltier sequencing: VOLTAGE_TRANSITION_MEMORY.md. For Build App: BUILD_NOTES.md and the actual workflow. For grille/visuals: DESIGN_NOTES.md. Use CHANGELOG.md only for history.
4. Inspect current source/test/workflow and verify all current claims. Do not trust an old SHA/path/version without a live fetch.
5. Learn and enforce the current Thinking protocol from CHAT_RULES.md. `@Thinking Diskusi!` is full read-only discussion. Gemini prompt/answer commands require `Diskusi!` in the same message. `@Thinking Eksekusi Full!` executes only approved work and never implies Build App. `@Thinking Eksekusi Build App!` owns end-to-end App build, App-scope repair/retry, artifact verification and `APP_BUILD_REPORT.md` logging. `@Thinking Chat Stuck!` is a standalone recovery command that resumes the last authorized operation from evidence without blindly retrying or broadening permission. Reject missing-parent Gemini commands without processing their substantive content. The old standalone `Eksekusi!` and combined `Eksekusi & Build App!` commands are retired.
6. Respect repository split: App repo owns all code source and every note/memory. Firmware artifact repo must contain JEXFYZ.cpp.bin only.
7. Preserve every approved requirement, previous failure and rejected approach. Never ask the user to repeat details already in the repository or available project context. If something is missing, report the exact gap rather than inventing.
8. Return a compact boot report: current HEAD/source version/hash, App version, workflow/test/PR state, relevant constraints, known bugs and exact unverified gates. Then wait for the user's next command. Do not write changes or start any build during boot.
```

---

## Prompt C — Update one lasting decision during normal execution

```text
Before marking an execution complete:
1. Identify the canonical memory file for the changed subject.
2. Save the durable decision, behavior, rationale, rejected alternative, safety constraints and evidence status there.
3. Update PROJECT_STATE.md only if current state or validation gates changed.
4. Add a concise dated CHANGELOG entry for significant source/config/architecture changes.
5. Refresh CHAT_TRANSFER.md if the current checkpoint has changed; always read its old content first.
6. For any App Build attempt, append the exact run outcome, source commit, fixes, tests, APK/checksum/signing checks and unresolved gates to APP_BUILD_REPORT.md so the next Build App chat can resume through the one-shot Prompt D LOAD + CONTINUE; a Discussion chat may also consult the same evidence record.
7. Update MEMORY_INDEX.md and all cross-links if file paths/names changed.
8. Verify post-write content, branch HEAD, blob hashes and no stale path/version references.
9. Do not report an unrun test/build/compile/device check as passed.
```


---

## Prompt D — Build App chat-limit LOAD + CONTINUE (use once; no recap chat)

Use this prompt only when the current Build App chat itself reaches its context/chat limit. Paste it once as the opening message of the replacement Build App chat. It combines loading repository evidence and continuing the existing App Build operation. **Do not create a separate recap chat, run Prompt A for this handoff, or send a second prompt just to start the build.**

```text
@Thinking Eksekusi Build App! BUILD APP CHAT-LIMIT LOAD — CONTINUE FROM LIVE REPOSITORY EVIDENCE

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
This is a one-shot LOAD + CONTINUE handoff for an already-authorized Build App workstream that reached the chat/context limit. The prior transcript may no longer be available; repository memory and APP_BUILD_REPORT.md are the durable state. Load and verify them, then continue the same Build App/QC operation without a separate recap stage.

1. LOAD LIVE STATE FIRST
- Read CHAT_TRANSFER.md fully.
- Fetch live main HEAD and the current repository tree/file identities.
- Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md, HANDOVER.md, BUILD_NOTES.md, APP_BUILD_REPORT.md, and the complete current .github/workflows/jexfyz-app-build-trigger.yml.
- Inspect the current App source, relevant tests, Android/package/signing configuration and dependency files needed for the current failure or build.
- Read all relevant prior entries in APP_BUILD_REPORT.md, including the exact last run/commit, failed steps, fixes already made, and unresolved gates.
- Verify current Actions runs, Releases and trigger state from live GitHub evidence. Do not trust historical run IDs or source SHAs without fetching them.

2. RESUME THE EXISTING BUILD OPERATION — DO NOT RECAP
- Determine whether an intended workflow run is still in progress, failed, blocked, or already passed all required gates.
- If the intended run is in progress, continue monitoring/verifying that run; do not create a duplicate trigger.
- If it failed, inspect the exact log and root cause. Repair only authorized App-scope causes, preserve tests/security gates, commit the justified fix directly to main, and start a fresh run using the current official workflow when retry is evidence-based.
- If the job failed before step 1 with `runner_id=0`, missing runner details or no steps, do not re-trigger the same unchanged job. Investigate Actions usage/budget, repository/account Actions policy, security/verification restrictions and available check-run evidence; escalate to GitHub Support when appropriate. Resume the build only when runner dispatch is demonstrably working or new evidence supports one justified retry.
- If blocked, continue any permitted investigation and record the exact blocker and required action.
- If the existing target commit already passed every required gate and the exact release asset has been independently verified, do not start an unnecessary duplicate build. Verify evidence, complete the report, and close as SUCCESS.
- Continue the work in this chat without stopping after a boot summary and waiting for another prompt. The user has already supplied the Build App command by using this handoff prompt.

3. OFFICIAL BUILD WORKFLOW
- Re-fetch and follow the live .github/workflows/jexfyz-app-build-trigger.yml. Documented trigger title: JE X FYZ — EKSEKUSI BUILD APP TRIGGER. Required body token: JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1. Verify owner/title/token checks before triggering.
- Never change the workflow to run on push/PR as a shortcut.
- Inspect actual results for security/architecture checks, dependency resolution, Dart analysis, Flutter tests, APK build, signing verification, Release publication and re-downloaded asset verification.
- Repair App-scope failures by fixing root causes; never weaken/delete tests or skip mandatory gates just to obtain a green run.
- Retry only after a concrete repair or evidence-based transient failure; do not loop blindly.

4. REQUIRED DURABLE RECORD
- Append every new attempt, exact run ID/URL, source commit, failing step, root cause, code/doc fix, rerun and verification result to APP_BUILD_REPORT.md.
- Record Dart/test results and counts; APK filename/count/size/SHA-256; V1/V2/V3 and production-certificate verification; Release/tag and re-downloaded asset identity; warnings and all remaining unverified checks.
- Preserve past failures and successful history. Do not rewrite history to hide a failure.
- Re-fetch the updated report and verify the final main HEAD and report blob after writing.

5. AUTHORIZATION BOUNDARIES
- Work directly on main; do not create branches or PRs unless explicitly requested.
- Preserve Gradle versionName "Telegram @horizontalzzz".
- This command authorizes App Build, App-scope fixes required for the build, relevant tests, artifact verification and APP_BUILD_REPORT.md updates only.
- Do not compile/edit Firmware, generate/replace/publish BIN, modify Firebase production metadata, perform OTA/flash, operate hardware/device, expose secrets, or perform unrelated release work without separate explicit authorization.
- Do not infer physical-device rendering, BLE/cooling behavior or OTA success from CI results.
- If progress needs unavailable permission/secret, external service recovery, user/device action or separate authorization, stop at that boundary, record BLOCKED and the exact next action. Never claim success without evidence.

6. FINAL DISPOSITION
Report SUCCESS only when every mandatory App Build/release gate has verified evidence; otherwise report BLOCKED or FAILED accurately. Give the source commit, run URL, trigger details, test results, APK/signing/checksum/release evidence and unresolved checks. Keep the response concise.

IMPORTANT: This Prompt D is used once when a Build App chat reaches its context limit. It is the LOAD + CONTINUE prompt for the replacement Build App chat. There is no Build App recap chat or separate recap prompt. Do not replace CHAT_TRANSFER.md or run the general project-memory reconciliation Prompt A just to transfer the Build App work.
```

## Mandatory memory inventory — include all categories before ending a transfer

When reconciling or booting a chat, check every category below against the canonical current notes, the full legacy archives, and available chat/project context. Mark each as FOUND / UPDATED / HISTORICAL / NOT FOUND; never silently omit an unresolved category.

### Product / App and Android
- App name JE Cooler, JE X FYZ branding, package and `versionName`; Horizon Cooler architecture/design reference.
- Main dashboard/Home labels, voltage/adaptive tabs, menu hierarchy VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE, compact UI and cooler-image placement.
- Manual 5/9/12 V cycle, 1-second voltage guard, default voltage LED colors and custom/reset behavior.
- Fan PWM control range and the distinction between Manual and Adaptive fan speed.
- Adaptive start/stop safe-5V behavior and touch-sensor lock.
- Localization, safety/Notify copy, output-unknown while disconnected, authoritative telemetry vs ACK, state reconciliation and LED preview phase synchronization.
- P1 protocol handshake, exact BLE service/RX/TX UUIDs, Secure BLE write/bonding constraints and no second Android GATT client.
- Auto Connect and reconnection prerequisites; current Floating Monitor six metrics B/H/V/A/P/F (F=Fan Speed), legacy schema-v1 S→F migration and old F=FPS removal, native bridge channel and permission/lifecycle contracts.
- Battery temperature heartbeat, Hotside telemetry cadence and firmware notice/preferences storage.
- Android package, target/min/compile SDK/tool versions, manifest permissions, services, release signing, R8 obfuscation, icon/assets, and preserved creator identity `versionName "Telegram @horizontalzzz"`.

### Firmware / electronics / physical hardware
- MCU and core: ESP32-C3 Super Mini / ESP32-C3 Dev Module, Arduino-ESP32 Core 3.3.7, single-radio Wi-Fi/BLE handoff.
- Full GPIO pin map; MOSFET gate/source/wiring notes; selector polarity should be checked in source.
- NTC resistance/Beta/divider supply, calibrated millivolt ADC function, single one-second sample, no median/multi-sample filters, fault/failsafe behavior.
- Peltier/Fan PWM frequencies/resolution, ON soft-start, rail deadtime/guard, Fan continuity through transition.
- Manual Peltier safety latch/hysteresis, Hotside range/default, Adaptive HOTSIDE/HOTSIDE_BATTERY rules, timeout, step-down, recovery, saved ceiling, terminal lock.
- Touch TTP223 startup grace/debounce/qualification/tap/double-tap/long-press timing and approved Adaptive ON/OFF LED blink feedback.
- WS2812/RGB mode list, default voltage LED map, persistent settings, one 10-second quiet-period debounce, runtime-only Adaptive Profile.
- Reset-reason diagnostic handling and separation between a symptom and a proven physical root cause.
- Version filename constant rule and exactly one active versioned `.ino`.

### OTA, cloud, protocol and security
- Local OTA Golden/Protected flow and Online OTA flow/state machine.
- Single-radio Wi-Fi-to-BLE transition; outputs must be safe during OTA.
- Exact OTA command/protocol sequence, expected disconnect, ACK timeout ambiguity, reconnect, P1 resync and result handling.
- Current `setInsecure()` trade-off, removed CA/NTP-gate experiment, user-reported symptom/result, and what exact evidence remains unavailable.
- Raw GitHub BIN URL allowlist, redirects, HTTP/length/size/image checks, `Update` lifecycle, error/recovery/restart.
- Firebase metadata remains version + link; don't invent SHA/signature fields or imply that current BIN matches active source without provenance.
- Every prior OTA regression, failed attempt and reason must remain recorded, even when the old implementation is superseded.

### Decisions, failures and validation
- Every explicit user requirement and every “do not do” instruction.
- Every rejected approach, why it was rejected, side effects/trade-offs, known bug symptom and reproduction conditions.
- Exact version/build/commit/test IDs only where directly verified; old IDs marked historical and discrepancies retained unresolved instead of guessing.
- For each quality gate, record source review, static contract, test execution, compiler, BIN, flash, hardware, BLE, OTA install/reboot and release separately.
- Include known open issues, pending verification, diagnostic evidence needed, and the precise next action.

### Visual design and build/release
- Approved white symmetric square grille, 1:1 outline, central purple X, four corner mounting holes, original internal pattern/frame, removal-only side protrusions, flat/no-effects/print-ready requirement.
- Approved app icon/cooler assets and transparent 1:1 constraint.
- Manual App Build issue title/token, current workflow, Java/Flutter/Gradle versions, production signing, one obfuscated APK, no bundle/artifact, no push-triggered builds.
- Exact commands that authorize App Build vs Firmware compile/BIN/OTA/Firebase/flash/release; do not infer one authorization from another.

### Repository hygiene and final transfer
- App repo owns all source and every memory/note; artifact repo contains only `JEXFYZ.cpp.bin`.
- Check the full recursive tree, docs and code/config references. Avoid printing secrets from configuration files.
- Search the current (non-archive) files for stale versions, incorrect filenames, dead links, old workflow path names and contradictory “current” paragraphs.
- Historical archives are preservation only. Search them for a missing past detail, then restore the useful fact to its canonical file with a clear historical/current label. Never quote archive “CURRENT” text as live truth.
- Update `MEMORY_INDEX.md`, current-only `PROJECT_STATE.md`, subject-specific memory, `CHANGELOG.md`, `HANDOVER.md` if next steps changed, and replace `CHAT_TRANSFER.md` last.
- Final confirmation must state current main HEAD, exact source/version/active .ino count, final test paths, workflow/PR state, artifact repo root, doc hashes and operations not performed.


## Additional mandatory reconciliation gates — full repository memory

- Inspect all current text, config, source, workflow and test files in the recursive tree, not only the listed note files. Read the whole prior CHAT_TRANSFER.md before replacing it. Read the listed docs fully and inspect the archives for missing historical decisions; archives are forensic only and never override live code.
- Preserve explicit UI exclusions, including that a standalone Battery Protection Guard must not be shown in the App. Preserve phone Battery temperature telemetry separately from NTC sampling: App sends PHONE:BT at approximately 1 Hz while BLE is ready; Firmware freshness TTL is 5 seconds. The user’s one-App/one-cooler pairing-lock intent is a design requirement until exclusive enforcement is proved in source and physically verified.
- Verify Local OTA boot SoftAP ownership and current timeouts in source (currently 10-second no-client timeout, 60-second hard limit after interaction, then Wi-Fi shutdown/radio settle before BLE). Do not change OTA logic during a memory cleanup.
- Preserve Android identity versionName Telegram @horizontalzzz. App Build and firmware compile/BIN/OTA/Firebase/flash/release are separately gated operations. Documentation authorization is not build authorization.
- Check every local Markdown link and all current path/version/workflow/test references after writing. Preserve archives byte-for-byte; restore relevant facts from them into canonical notes with honest historical labels.
- Before replacing CHAT_TRANSFER.md, update all other canonical docs, indexes and prompt templates first. Record the live main HEAD immediately before the transfer write, then re-fetch the final transfer and verify its commit parent, file tree, source/version/hash, tests, workflow, PR state, and artifact-repository BIN-only contents. Never store CHAT_TRANSFER.md’s own future blob SHA inside its own contents.
- Readable prior chats are not guaranteed to be available to every new context. Use current repository notes, transfer prompts, archives, Git history and available project context; never claim a missing chat was read, and report any unrecoverable gap instead of guessing.


## JE X FYZ durable-decision ledger — do not omit during transfer

When rebuilding memory, explicitly reconcile each item below against the live source and current user requirements. Retain it in the named canonical memory even if the immediate task is unrelated; classify implementation/evidence correctly.

### Firmware source identity, hardware and wiring

- Source identity: exactly one active versioned `.ino`; filename matches embedded `FW_VERSION`; every functional Firmware change bumps version. Current known source expected V6.6, but always refetch.
- Board ESP32-C3 Super Mini / ESP32-C3 Dev Module at 3.3 V logic; GPIO0 NTC, GPIO1 TTP223, GPIO3 12 V selector, GPIO4 9 V selector, GPIO5 Peltier MOSFET, GPIO6 Fan MOSFET, GPIO7 WS2812.
- MOSFET wiring memory: GPIO → R100 → Gate, 100 kΩ Gate–Source pull-down; Fan positive goes to supply and Fan negative to MOSFET Drain. Verify physical wiring and cables; a previously suspected 12 V selection failure was ultimately a loose cable.
- NTC nominal 10 kΩ, fixed resistor 10 kΩ, Beta 3950, calibrated `analogReadMilliVolts()`, one sample per second. The user explicitly rejected median, trimmed-mean and multi-sample averaging; do not lose that rejected approach and its reason.
- If NTC is invalid, check current source fail-safe contract rather than guessing. Known contract: Peltier OFF, Fan 100%, Adaptive OFF, safe 5 V selection.
- Preserve hardware timings and control: Peltier 20 kHz/8-bit, normal OFF→ON five-second soft-start; Fan 25 kHz/8-bit, manual 50–100%, step 10; selector deadtime 200 ms; shared guard/settle 1 s; settings quiet debounce 10 s; HOTSIDE telemetry 1 Hz; state changes sent as deltas when changed.
- LED mode IDs are Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7; ID 3/Mirror Pulse is retired, persisted ID 3 migrates to Static and `MODE:3` is rejected.
- LED preview synchronization uses one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple generated at BLE notify time. App interpolates from snapshots via monotonic time and corrects drift without resetting animation on every update; older separate phase/cycle telemetry remains a compatibility fallback.
- Adaptive ON/OFF returns the selector to safe 5 V without a separate Peltier OFF/ON cycle. The existing transition handler pauses only an active soft-start; a completed ramp remains at 100%, subject to explicit OFF and current Hotside/NTC/OTA safety.

### Thermal, Adaptive, Touch and indicators

- Hotside limit configurable 40–50°C, default 45°C. Manual Peltier re-arm requires Hotside <= hotLimit−1°C for five continuous seconds. One low sample must not bypass re-arm.
- Adaptive 30-second thermal stages at 12 V / 9 V / 5 V, Peltier OFF and Fan 100%; five seconds stable at/below limit−1°C before deadline recovers, otherwise step down 12/9 or terminal-lock at 5 V. Restoration after thermal downshift goes up one rail only after 60 seconds continuously stable and never beyond saved ceiling. No rapid Hotside rise/slope protection is present in known V6.x.
- HOTSIDE is the startup default; HOTSIDE_BATTERY is runtime-selectable and not persisted. Battery input defaults are 5 V threshold 25°C and 12 V threshold 35°C, 0.5°C hysteresis, firmware data TTL 5 s. App sends `PHONE:BT` at 1 Hz and coalesces pending heartbeat. If battery data expires, fallback to HOTSIDE behavior without silently rewriting selected profile.
- App presentation rule: do not display a standalone Battery Protection Guard. This does not suppress actual thermal safety or independently actionable localized Notify messages.
- One TTP223 only; no separate Wi-Fi/BLE toggle. Retain startup calibration grace, qualification/tap/double-tap/long-press timings only after live source check. Current known timing record: ~1 s startup grace, 30 ms qualification, raw HIGH 60–500 ms tap, 800 ms double-tap window, 5 s long press.
- Adaptive ON is orange three blinks; OFF is white three blinks, with OFF indicator deferred until safe 5 V handoff when required. Voltage LED defaults: 5 V red, 9 V green, 12 V blue; user-customizable/resettable. Decorative RGB never overrides safety/OTA indications. Preserve the six supported RGB mode IDs (1, 2, 4, 5, 6, 7) and atomic LED_SYNC phase synchronization.

### App product, BLE and user-visible behavior

- Identity: App `JE Cooler`, brand/header `JE X FYZ`, package `com.horizontalzzz.jexfyz`, pubspec `1.0.0+3`; Gradle `versionName "Telegram @horizontalzzz"` is intentionally fixed.
- UI layout reference: Horizon Cooler App; dark header, white rounded content panel, compact VOLTAGE/ADAPTIVE tabs, Home Hotside/Battery temps, voltage indicator, Adaptive, Peltier/Fan, Fan Speed and Notify reason. Menu order VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE; do not redesign during QC.
- Manual 5/9/12 V selection/cycle and 1-second guard. Manual Fan speed control is not Adaptive-controlled; Adaptive can demand 100% cooling. Manual transition completion must wait for authoritative Firmware `VOLTAGE` telemetry.
- Firmware-owned state: ACK is not proof physical hardware changed. Disconnected dashboard/Home and Floating Monitor outputs display unknown (`--`); CONTROL/ADAPTIVE/LED switch rows use an OFF-looking disabled toggle at left as presentation only, not a claim of physical state. Touch Adaptive-OFF must publish state deltas before ACK.
- Protocol P1 UUIDs: service `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`, RX `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`, TX `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`. BLE write encryption/bonding is present; one-App-only pairing lock remains unverified unless code/physical tests establish it.
- Auto Connect is passive: it cannot enable Bluetooth or request BLE permissions by itself; requires known cooler identity, ready Bluetooth/permission/location prerequisites and no sync collision. Native services/channels must not create a second BLE/GATT client.
- English/Indonesia localization; user-facing power states ON/OFF versus HIDUP/MATI; machine identifiers remain English.

### OTA failure history, cloud contract and build operation

- OTA is protected code with priority over normal work and safe outputs. Local OTA uses the boot SoftAP; currently 10-second no-client timeout, 60-second hard cap after AP interaction, 160 ms Wi-Fi-off settle before BLE owns the single radio. Reconcile to current source before quoting.
- Online OTA earlier used CA certificate verification and OTA-only NTP/TIME_SYNCING gate; the observed user's failure was blue after Wi-Fi then red on the GitHub stage but no exact HTTP/TLS log was provided. The V6.3-origin correction removed CA/NTP together and restored `cloudClient.setInsecure()`, which user reported compiled and restored GitHub connection. This does not prove which removed factor alone caused the failure or validate V6.6. Trade-off: server identity is not authenticated.
- Keep the raw GitHub BIN allowlist, redirect blocking, status/length/size/image checks (`0xE9`), streaming Update lifecycle, safe outputs, recovery/restart semantics. No custom firmware SHA/signature field in Firebase OTA metadata; user expects version + link. Do not infer BIN provenance from path or upload date.
- App OTA sequence is `OTAENTER → SSID → PASS → URL → VERSION → CLOUDOTA`; timeout/disconnect ACK is ambiguous and must preserve recovery state. Separate OTA transport, full transfer, Update finalization, reboot, BLE recovery, installed-version confirmation, and Firebase promotion evidence.
- Build App is manual issue-trigger only: title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, one obfuscated production-signed APK `JEXFYZ-release.apk` in release `jexfyz-latest`. Do not run it unless explicitly authorized. Preserve Gradle identity.

### Approved physical/visual design and memory discipline

- Approved grille: solid white symmetric geometry, perfect square 1:1 outer contour, central purple X, four corner mounting holes. Preserve interior pattern/frame, remove only the two left/right midpoint protrusions when asked. Flat print-ready 2D, no shadow/bevel/gradient/texture. HZ monogram was tried and reverted; purple X is approved. “Enlarge only” changes scale, not design.
- Preserve icons/cooler PNG transparency and 1:1 aspect. All visual changes are scoped; don't invent a redesign.
- Preserve failed/rejected methods and their reason in the appropriate current note/changelog, but label older claims as historical. A source contract/test file is not a run; compile is not OTA install; blue/red LED is not an HTTP diagnosis; version bump is not a BIN; reboot symptom is not proof of brownout; closed PR is not automatically merged.
- At final boot snapshot include exact next steps, current and historical version boundary, current workflow and CI run SHA, all canonical document hashes, active tests, open PR/branch state, current BIN hash/provenance, and all not-run operations. Redact credentials and signing material.


## Historic symptoms that must not be silently dropped

During every full reconciliation, separately preserve the following reports and their evidence status in the canonical memory:
- The reported reset during Manual 5 V→12 V while Peltier/Fan were ON and Peltier soft-start was still active; reset reason was not captured and brownout is a hypothesis only.
- A separate reported reset when switching Adaptive ON after selecting 12 V and enabling Peltier/Fan; do not assume the two reset reports share a cause. Capture reset telemetry and physical conditions if the user later authorizes reproduction.
- The user previously requested rapid Hotside rise/rate-of-rise protection to turn Peltier OFF and require manual re-arm. This behavior is NOT implemented in current V6.6; record as unimplemented historical requirement, not as current functionality.
- The user reported the Adaptive-OFF white three-blink indication missing immediately after restart. A code path for OFF transition after user interaction does not prove boot-time initial OFF feedback; mark physical/boot behavior unverified until specifically checked.
- Preserve the corrected physical-wiring finding that an apparent 12 V selector malfunction was later traced to a loose cable, and do not label it a code defect without evidence.
