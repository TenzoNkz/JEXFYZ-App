# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-16. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Verified checkpoint

- Latest successful App release is Build #60 / run `38817543342`, source/release commit `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`. Security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK, V1/V2/V3 signing/certificate, matching source archive and downloaded asset identity/hash/signature checks all passed. Full attempt evidence is in `APP_BUILD_REPORT.md`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains one [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) (asset `645381550`, `54,636,716` bytes, SHA-256 `47892215de179c8cb2975ad5c99b8b3b1398559873352411ed74d001aa001274`) and one [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) (asset `645381553`, `2,866,092` bytes, SHA-256 `dd9bdc1f8082c70ab2ff73892f5434057d36cedc870fd92184b8ed579e2b538a`). Both artifacts are verified against release source commit `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`.
- Build #59 / run `38817257209` failed on one stale widget source-contract assertion after audit/dependencies/Dart analysis passed; **87 passed, 1 failed** and no release steps ran. Test-only commit `7a576e60f0938cec94fcddb96340cd5376fa15de` updated the assertion to current `validZero`/full-window fallback behavior without deleting tests or relaxing a gate. Build #60 then passed the complete test suite and release pipeline.
- Source diagnostic checkpoint `6e9b4c73db12c51f4452717d8cf102f49d325dcf` and test correction `7a576e60f0938cec94fcddb96340cd5376fa15de` are built/CI-tested. The sampler now falls back to full `dumpsys window`, distinguishes a valid zero sample from first/invalid/reset samples, cancels stale poll tasks and displays native status in Settings. Physical icon rendering, Shizuku UserService/runtime behavior, OEM SurfaceFlinger access and actual foreground FPS remain **UNVERIFIED** until device tests/logs.
- Current source hashes: `lib/main.dart` `d24885cf0a40472b9fb23ee6ce73ad772ae73672`; `lib/floating_monitor.dart` `d43bd17a7adebf7c9f95fc5fdf921ba2a22a231b`; `lib/app_settings.dart` `4c89bcb3c04142ce49440a11b92054365c26f7a6`; native `FloatingMonitorService.kt` `c7ca3e75c28b53ea8cda207836befbe04a2e5a6f`; `FpsShizukuUserService.kt` `9f70d480bd31a4875653add70804ab50fc15b747`; `widget_test.dart` `f8a8ff0f5f6527a0a6f6e2c453fe5c0836437785`; floating layout test `7f861d449e518af68fc4ece7278241aa3ce8691b`; Shizuku FPS test `93aca6d5f5ad6c3c4723b2545eaf997cf8ee996f`; workflow `585d190324e522fc08e66cc95bd7ee80c5f37664`.
- Non-blocking findings: 23 Dart deprecation info findings, Gradle 9.3.1 out of date, native ELF DWARF data not obfuscated, JAR self-signed/no-timestamp/META-INF warnings, and cache save denied by token scope. Full details are in `APP_BUILD_REPORT.md`.
- Active Firmware remains user-accepted V6.6. Build #60 was App-only: no Firmware compilation, BIN publication, Firebase, OTA, flashing or device operation occurred.

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
| test/*.dart | Six active test files; Build #60 ran the complete configured suite: 88/88 passed. File presence alone is not execution evidence |
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
