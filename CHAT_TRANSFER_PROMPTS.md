# JE X FYZ / JE Cooler — Chat Transfer Prompt Templates

Use these templates when a conversation is nearing its context limit or a new chat is started. They are intended to recover the project from repository memory, not from a model's imperfect conversational recall.

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
5. Learn the permanent rules: Discussion is read-only; Execute is narrow; Execute Full includes relevant audit/memory sync but not App Build or Firmware compile; Build App only on explicit request; user compiles firmware; no BIN/Firebase/OTA/flash/release without separate explicit authorization; work directly on main; keep App Gradle identity unchanged.
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
6. Update MEMORY_INDEX.md and all cross-links if file paths/names changed.
7. Verify post-write content, branch HEAD, blob hashes and no stale path/version references.
8. Do not report an unrun test/build/compile/device check as passed.
```


---

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
- Auto Connect and reconnection prerequisites; Floating Monitor seven stable metrics F/B/H/V/A/P/S, native bridge channel, permission/lifecycle contracts.
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
