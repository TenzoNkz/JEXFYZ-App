# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-16. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Verified checkpoint

- Latest source/test checkpoint before the remaining docs sync: 311a18934a3cbe86a2a4718442c92541f081183f; tree 8c16a479d5aaeb81f0c2cb30a4446ee310e3f7ec, not truncated, 80 entries; five branches; zero open PRs.
- App version 1.0.0+3, package com.horizontalzzz.jexfyz; preserve Android Gradle versionName "Telegram @horizontalzzz".
- Latest successful release is Build #54 / run 38767611593 at source commit 437e7730dbcaf9666ae4828e546a45343bb4890c. Dart analysis, 86/86 Flutter tests, Android compile, V1/V2/V3 signing/certificate, matching source archive and downloaded-asset checks passed.
- Release jexfyz-latest has JEXFYZ-release.apk, asset 644438898, SHA-256 cdf8a7f94424b9cb60be6e04489a9f0f0d8ddad43ab76c33c2e2c6333fa61327, and JEXFYZ-corresponding-source.zip, asset 644438897, SHA-256 3b208c987def59a7c1857ed0fcc9ca5d74d591767e5658dfab04c9c1be85450f.
- Current source hashes: main.dart 69eef38d26282b94ad1bea297d812dfd8b9e91e3; floating_monitor.dart f3ba1518e9f5158cd7f7a1fccac8df0fbac3b2fb; app_settings.dart 4c89bcb3c04142ce49440a11b92054365c26f7a6; native FloatingMonitorService.kt dd10ff0b2c23941badaa33949967fc373f98aeb9; widget_test.dart 2426eecea66a357d63ce10214a2d331224c81e37; floating layout test 7f861d449e518af68fc4ece7278241aa3ce8691b; Shizuku FPS test 798633a24907fd8aca567e70a6376dc59c6e41c9; workflow 585d190324e522fc08e66cc95bd7ee80c5f37664.
- Active Firmware source remains V6.6 at firmware/JEXFYZ-V6.6.ino, blob f51ba6db5d0e91318f63fea4014bb87f7bf76222. V6.6 compile/two same-version Online OTA reports are USER-REPORTED; source-to-BIN provenance UNVERIFIED.
- Current main UI/FPS changes are source-only and UNBUILT. Contract tests were updated but not executed because Flutter/Dart are not available in this runtime. Build #54 remains latest verified release from source 437e7730dbcaf9666ae4828e546a45343bb4890c; its APK/source ZIP do not include current changes. @Thinking Eksekusi Build App! is required for analyze/test/build/release.
- Open physical validation item: earlier screenshot showed Shizuku allowed while F was --. Current main source now follows the foreground window package across games, JE Cooler, launcher, Settings and system UI when matching SurfaceFlinger data is exposed, and returns 0 after baseline when a tracked layer is stable. This source fix is NOT device-verified; OEM permissions/layer naming may still leave data unavailable. See APP_NOTES.md / PROJECT_STATE.md.

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
