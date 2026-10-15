# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-16 00:04 Asia/Jakarta. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Verified checkpoint

- Parent HEAD before this docs reconciliation: 329fd18e3c6ced8f43a7dbfaf7bf02206c17d42a. Recursive tree 80 entries, not truncated; five branches; zero open PRs.
- App version 1.0.0+3, package com.horizontalzzz.jexfyz; preserve Android Gradle versionName "Telegram @horizontalzzz".
- Latest successful release is Build #54 / run 38767611593 at source commit 437e7730dbcaf9666ae4828e546a45343bb4890c. Dart analysis, 86/86 Flutter tests, Android compile, V1/V2/V3 signing/certificate, matching source archive and downloaded-asset checks passed.
- Release jexfyz-latest has JEXFYZ-release.apk, asset 644438898, SHA-256 cdf8a7f94424b9cb60be6e04489a9f0f0d8ddad43ab76c33c2e2c6333fa61327, and JEXFYZ-corresponding-source.zip, asset 644438897, SHA-256 3b208c987def59a7c1857ed0fcc9ca5d74d591767e5658dfab04c9c1be85450f.
- Current source hashes: main.dart 72c450d9b1e8783e4b82b8e37a5f39e2d49b6289; floating_monitor.dart 05a61e5670ec09c9c46cf60466a1dd301dfe5352; app_settings.dart 46cc838f43a06c325af6f6832e200a4e1ed4f75d; widget_test.dart 520399fcdc6be4fd69cb48f50aa8961f5d9183c5; floating layout test 31d9aabf4ac0839855308b6bd2a0708fa399a3a9; Shizuku FPS test 798633a24907fd8aca567e70a6376dc59c6e41c9; workflow 585d190324e522fc08e66cc95bd7ee80c5f37664.
- Active Firmware source remains V6.6 at firmware/JEXFYZ-V6.6.ino, blob f51ba6db5d0e91318f63fea4014bb87f7bf76222. V6.6 compile/two same-version Online OTA reports are USER-REPORTED; source-to-BIN provenance UNVERIFIED.
- Open physical issue: user screenshot shows Shizuku permission granted while F is -- and other telemetry is live. The screenshot is the JE Cooler settings page foreground; source intentionally skips JE Cooler's own package as a game. This is a plausible explanation, not a confirmed device diagnosis. See APP_NOTES.md / PROJECT_STATE.md.

## New-chat boot order

1. Read CHAT_TRANSFER.md completely first.
2. Fetch live main HEAD and recursive tree, active firmware version/source, branches/PRs, build workflow, Actions and Release, current source hashes and artifact-repo tree.
3. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md and HANDOVER.md fully.
4. Subject routing: App → APP_NOTES.md; hardware/Firmware → FIRMWARE_NOTES.md + firmware/FIRMWARE_TECHNICAL_REFERENCE.md; OTA → OTA_PROTECTION.md + OTA_REGRESSION_MEMORY.md; rail/Peltier → VOLTAGE_TRANSITION_MEMORY.md; build → BUILD_NOTES.md + APP_BUILD_REPORT.md + exact live workflow; grille/assets → DESIGN_NOTES.md. CHANGELOG.md is history only.
5. For a full memory reconciliation, use Prompt A in CHAT_TRANSFER_PROMPTS.md, read the prior transfer completely, update other current notes first and replace CHAT_TRANSFER.md last. For a Build App chat limit, use Prompt D exactly once as the next Build App chat's first message; it loads and continues the same operation without a recap stage.
6. Use live source and GitHub evidence as ground truth. All-green App CI does not prove physical FPS/BLE/Firmware/OTA behavior.

## Permanent command and authorization protocol

- @Thinking Diskusi! = full read-only discussion; no source/docs writes.
- @Thinking Diskusi! Tanya Gemini! and @Thinking Diskusi! Jawaban Gemini! are valid only when Diskusi! is present in the same command.
- @Thinking Eksekusi Full! executes the approved source/docs/tests/audit scope and may commit directly to main; it does not authorize App Build or Firmware/device operations implicitly.
- @Thinking Eksekusi Build App! is the only command authorizing full App analyze/test/build/sign/release verification.
- @Thinking Chat Stuck! recovers the last authorized task from live evidence; no blind retries or scope expansion.
- Retired aliases: @Thinking Build App!, @Thinking Eksekusi & Build App!, and standalone @Thinking Eksekusi!.
- Work directly on main by default; no branch or PR unless requested. The only active App workflow is .github/workflows/jexfyz-app-build-trigger.yml, owner/title/token guarded and issue-open/reopen only. Preserve versionName "Telegram @horizontalzzz".

## Canonical file map

| File | Canonical purpose |
|---|---|
| README.md | Project overview, current validation and navigation |
| MEMORY_INDEX.md | Memory routing and boot order |
| CHAT_RULES.md | Commands, authorization, repository/user rules |
| PROJECT_STATE.md | Current App/Firmware/release state and open gates only |
| CHAT_TRANSFER.md | Detailed current boot snapshot, replaced at chat limit after reading old content |
| CHAT_TRANSFER_PROMPTS.md | Prompt A full reconciliation, Prompt B read-only boot, Prompt C persistence, Prompt D one-shot Build App load+continue |
| HANDOVER.md | Current handover and next diagnostic/action |
| APP_NOTES.md | App UI, menu, BLE, telemetry, Floating Monitor and Shizuku FPS contracts |
| FIRMWARE_NOTES.md | Hardware pins, NTC, safety, Adaptive, transitions, LED and telemetry contracts |
| firmware/FIRMWARE_TECHNICAL_REFERENCE.md | Firmware architecture/static invariants; not compile proof |
| OTA_PROTECTION.md | Protected Local/Online OTA flow and gates |
| OTA_REGRESSION_MEMORY.md | CA/NTP experiment, setInsecure trade-off and failure evidence |
| VOLTAGE_TRANSITION_MEMORY.md | Peltier ramp, rail changes, recovery rules and validation |
| BUILD_NOTES.md | Active App workflow/toolchain/build-requirements and historical build milestones |
| APP_BUILD_REPORT.md | Attempt-by-attempt evidence; preserve failed #50–#53 and successful #54 |
| CHANGELOG.md | Historical behavior/decision/failure ledger, not current truth |
| DESIGN_NOTES.md | Approved grille, icons/cooler and visual requirements |
| .github/workflows/jexfyz-app-build-trigger.yml | Authoritative manual issue-triggered App Build workflow |
| test/*.dart | Six active test files; Build #54 ran 86/86. File presence alone is not execution evidence |
| firmware/JEXFYZ-V6.6.ino | Current editable Firmware source, one versioned active sketch |
| archive/*.md | Immutable forensic snapshots; archived “CURRENT” claims are not live truth |

## Evidence labels and sources

- CURRENT / VERIFIED: directly checked source/GitHub/run/Release data.
- SOURCE IMPLEMENTED / NOT RUN: code or tests exist but have not been executed.
- USER-REPORTED: user-reported outcome without independent evidence.
- UNVERIFIED: evidence gap remains.
- HYPOTHESIS: plausible explanation, not established.
- HISTORICAL / SUPERSEDED: accurate only for older source.
- NOT RELEASED: current source does not exist in an authoritative successful release.

Source of truth ordering: live main code/tree/Refs and exact Actions/Release evidence → CHAT_RULES.md for permissions → PROJECT_STATE.md for current status → subject notes and APP_BUILD_REPORT.md → HANDOVER.md / CHAT_TRANSFER.md → CHANGELOG.md for history → archive/context summaries for recovery only.

## Repository and memory persistence rules

- All source, documentation, tests and memory stay in TenzoNkz/JEXFYZ-App. TenzoNkz/JEXFYZ-Firmware is BIN-only.
- The live artifact repo tree is exactly one file: JEXFYZ.cpp.bin, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6, size 1,455,936 bytes. This does not establish that the BIN was produced from the current source.
- Each durable decision has one canonical subject file. Update PROJECT_STATE.md for current state; APP_BUILD_REPORT.md for every build attempt; CHANGELOG.md for significant history; MEMORY_INDEX.md for changed routing; replace CHAT_TRANSFER.md last at context limit.
- Do not output credential contents from google-services.json or signing environment. Keep archives byte-for-byte and restore useful facts to canonical notes with explicit historical labels.
- User accepts Firmware V6.6 as final. Do not edit/compile Firmware, generate/publish/replace BIN, alter Firebase, OTA/flash or operate hardware without separate explicit authorization. Functional Firmware edits require FW_VERSION bump, matching filename and exactly one active versioned .ino. Do not introduce blocking delay()/timing while loops.
- Do not show a standalone Battery Protection Guard in the App UI. One-App/one-cooler exclusive pairing-lock remains a design requirement until source and physical behavior prove exclusivity. Keep OTA protected; read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before touching it, and VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing changes.
