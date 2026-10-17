# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-17. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Current verified checkpoint

- Latest successful App release is Build #70 / run 38998407325, exact released source commit eb1224232241ca5d44d43e25919fd228875029ab. All 21 active workflow steps passed: audit, dependencies, Dart analysis, 86/86 Flutter tests, Android production compile/gate, obfuscated APK, V1/V2/V3 signing/certificate, source archive and re-downloaded Release asset verification. Native JUnit tasks were NO-SOURCE after FPS native tests were removed; no native JUnit cases ran. Full evidence is in APP_BUILD_REPORT.md.
- APK: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk; asset 649412242, 54,538,331 bytes, SHA-256 229aaae5745456498d35f356ee6e0cdde81e7bb29f37238b1172f99f992ab404. Source ZIP: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip; asset 649412243, 2,847,010 bytes, SHA-256 d0a79cdaf99b169b68cda04c5c3162062f493f0cb6f6ec02c1531950e4bbd8ae. Release tag targets eb1224232241ca5d44d43e25919fd228875029ab.
- FPS/Shizuku retirement is implemented and Build #70 verified the source. Floating Monitor supports B/H/V/A/P/F; F=Fan Speed. Schema-v1 saved F (FPS) is discarded and S (Speed) migrates to F in schema v2. Physical overlay, BLE telemetry and fan-speed display remain UNVERIFIED on the phone.
- Main now contains post-Build-70 indicator-motion and manual-voltage-toggle source edits, not yet App-QC verified. Current `lib/main.dart` blob is c10a708022ca8e8defbe1583b47fb0b10ddda8ed and `test/widget_test.dart` blob is 032cefebf89e08f92fddaf992184c7580c185b2a (the source-contract expectation was aligned with the new activity helper, but tests remain NOT RUN). Five branches and zero open PRs were observed before this scoped work. Artifact repo remains BIN-only; source-to-BIN provenance is UNVERIFIED.
- Firmware source is firmware/JEXFYZ-V6.6.ino, blob f51ba6db5d0e91318f63fea4014bb87f7bf76222, FW_VERSION="V6.6", exactly one active versioned .ino. User accepts V6.6 as final and reports compile plus two same-version Online OTA successes; USER-REPORTED, not independently witnessed. Preserve firmware/BIN/Firebase/OTA boundaries.

## New-chat boot order

1. Read CHAT_TRANSFER.md completely first.
2. Fetch live main HEAD and recursive tree, active firmware version/source, branches/PRs, build workflow, Actions and Release, current source hashes and artifact-repo tree.
3. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md and HANDOVER.md fully.
4. Subject routing: App → APP_NOTES.md; hardware/Firmware → FIRMWARE_NOTES.md + firmware/FIRMWARE_TECHNICAL_REFERENCE.md; OTA → OTA_PROTECTION.md + OTA_REGRESSION_MEMORY.md; rail/Peltier → VOLTAGE_TRANSITION_MEMORY.md; build → BUILD_NOTES.md + APP_BUILD_REPORT.md + exact live workflow; grille/assets → DESIGN_NOTES.md. CHANGELOG.md is history only.
5. For a full memory reconciliation, use Prompt A in CHAT_TRANSFER_PROMPTS.md, read the prior transfer completely, update other current notes first and replace CHAT_TRANSFER.md last. For a Build App chat limit, use Prompt D exactly once as the next Build App chat's first message; it loads and continues the same operation without a recap stage.
6. Use live source and GitHub evidence as ground truth. All-green App CI does not prove physical overlay telemetry, BLE, Firmware, or OTA behavior.

## Permanent command and authorization protocol

- @Thinking Diskusi! = full read-only discussion; no source/docs writes.
- @Thinking Diskusi! Tanya Gemini! and @Thinking Diskusi! Jawaban Gemini! are valid only when Diskusi! is present in the same command.
- @Thinking Eksekusi Full! executes the approved source/docs/tests/audit scope and may commit directly to main; it does not authorize App Build or Firmware/device operations implicitly. The current post-Build-70 motion/toggle source change requires a separate @Thinking Eksekusi Build App! before claiming Flutter/Android QC or release.
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
| APP_NOTES.md | App UI, menu, BLE, telemetry and six-metric Floating Monitor contracts (B/H/V/A/P/F) |
| FIRMWARE_NOTES.md | Hardware pins, NTC, safety, Adaptive, transitions, LED and telemetry contracts |
| firmware/FIRMWARE_TECHNICAL_REFERENCE.md | Firmware architecture/static invariants; not compile proof |
| OTA_PROTECTION.md | Protected Local/Online OTA flow and gates |
| OTA_REGRESSION_MEMORY.md | CA/NTP experiment, setInsecure trade-off and failure evidence |
| VOLTAGE_TRANSITION_MEMORY.md | Peltier ramp, rail changes, recovery rules and validation |
| BUILD_NOTES.md | Active App workflow/toolchain/build-requirements and historical build milestones |
| APP_BUILD_REPORT.md | Authoritative build-attempt ledger; Build #70 is latest verified release. FPS parser/watchdog runs are historical. |
| CHANGELOG.md | Historical behavior/decision/failure ledger, not current truth |
| DESIGN_NOTES.md | Approved grille, icons/cooler and visual requirements |
| .github/workflows/jexfyz-app-build-trigger.yml | Authoritative manual issue-triggered App Build workflow |
| test/*.dart and Android native unit-test gate | Five Dart test files remain; Build #70 ran 86/86 Flutter tests. Native JUnit tasks were NO-SOURCE after retired FPS test removal. |
| firmware/JEXFYZ-V6.6.ino | Current editable Firmware source, one versioned active sketch |
| archive/*.md | Immutable, verbatim forensic snapshots; archived “CURRENT” claims are not live truth. Root-relative links retained from originals may not resolve from the archive subdirectory; use canonical root docs and do not rewrite archives |

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
- The live artifact repo tree was re-fetched during the 2026-10-17 reconciliation and is exactly one file: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, size 1,455,936 bytes. This does not establish that the BIN was produced from the current source.
- Each durable decision has one canonical subject file. Update PROJECT_STATE.md for current state; APP_BUILD_REPORT.md for every build attempt; CHANGELOG.md for significant history; MEMORY_INDEX.md for changed routing; replace CHAT_TRANSFER.md last at context limit.
- Do not output credential contents from google-services.json or signing environment. Keep archives byte-for-byte and restore useful facts to canonical notes with explicit historical labels.
- User accepts Firmware V6.6 as final. Do not edit/compile Firmware, generate/publish/replace BIN, alter Firebase, OTA/flash or operate hardware without separate explicit authorization. Functional Firmware edits require FW_VERSION bump, matching filename and exactly one active versioned .ino. Do not introduce blocking delay()/timing while loops.
- Do not show a standalone Battery Protection Guard in the App UI. One-App/one-cooler exclusive pairing-lock remains a design requirement until source and physical behavior prove exclusivity. Keep OTA protected; read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before touching it, and VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing changes.
