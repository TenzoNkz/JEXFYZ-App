# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-16. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Verified checkpoint

- Latest successful App release is Build #58 / run `38793790061`, source/release commit `db11df355780174b1da7dcea4d5947bfa7ba7ca5`; security/architecture/license audit, dependencies, Dart analysis, **87/87 Flutter tests**, obfuscated APK, V1/V2/V3 signing/certificate, matching source archive and downloaded asset identity/hash/signature checks all passed. The full attempt ledger is in `APP_BUILD_REPORT.md`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly one [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) (asset `644929744`, `54,636,716` bytes, SHA-256 `88ee4aeadbba20279f36601dcf05e253746ba8189cefb125787db22a1553b2bd`) and one [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) (asset `644929745`, `2,864,393` bytes, SHA-256 `c331bc2912999dee148922b90018a151a4a355cacc064c0d87653633fe5c4094`). The corresponding source archive marker matches `db11df355780174b1da7dcea4d5947bfa7ba7ca5`.
- Build #57 / run `38793336598` failed at five stale widget source-contract assertions after audit/dependencies/Dart analysis passed; **82 tests passed, 5 failed** and no release steps ran. Test-only fix commit `432c30ec538ff7de6c7e77f0c68bac313f4f8015` updated those expectations without deleting tests or relaxing gates. Build #58 then verified the post-fix source successfully.
- Production source checkpoint `98cfe7ba4d0e9d569b84498d261ad1b67f66eee7` and test-contract fix `432c30ec538ff7de6c7e77f0c68bac313f4f8015` are now built/CI-tested. Physical icon rendering, Shizuku UserService/runtime permission behavior, OEM SurfaceFlinger layer access and actual foreground FPS remain **UNVERIFIED** until device tests/logs.
- Current source hashes: `lib/main.dart` `d24885cf0a40472b9fb23ee6ce73ad772ae73672`; `lib/floating_monitor.dart` `556217f0035e97fa6060041203151eec1c24ed76`; `lib/app_settings.dart` `4c89bcb3c04142ce49440a11b92054365c26f7a6`; native `FloatingMonitorService.kt` `44030753bf6a27ac0e9630f2d0f7ca0cc8e3bd0b`; `widget_test.dart` `d8e89083cbc6674962a5f9e013579477783243ad`; floating layout test `7f861d449e518af68fc4ece7278241aa3ce8691b`; Shizuku FPS test `5a9efb60b02c1cfabf44a35434f67fb555419c92`; workflow `585d190324e522fc08e66cc95bd7ee80c5f37664`.
- Non-blocking findings remain: 23 Dart deprecation info findings, Gradle 9.3.1 out of date, native ELF DWARF data not obfuscated, JAR self-signed/no-timestamp/META-INF warnings, and cache save denied by token scope. Full warning/evidence detail is in `APP_BUILD_REPORT.md`.
- Active Firmware remains user-accepted V6.6. Build #58 was App-only: no Firmware compilation, BIN publication, Firebase, OTA, flashing or device operation occurred.

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
| test/*.dart | Seven? active test files tracked in repo; Build #58 ran the complete configured suite: 87/87 passed. File presence alone is not execution evidence |
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
