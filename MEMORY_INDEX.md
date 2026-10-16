# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-16. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Verified checkpoint

- Latest successful App release is Build #62 / run `38841458441`, source/release commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. Security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK, V1/V2/V3 signing/certificate, matching source archive and downloaded asset identity/hash/signature checks all passed. Full attempt evidence is in `APP_BUILD_REPORT.md`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains one [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) (asset `645909183`, `54,636,716` bytes, SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`) and one [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) (asset `645909184`, `2,871,177` bytes, SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`). Both assets were re-downloaded and verified against release source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`.
- Build #61 / run `38841172623` failed on one stale widget source-contract assertion after audit/dependencies/Dart analysis passed; **87 passed, 1 failed** and no release steps ran. Commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4` updates assertions for attempt-scoped UserService binding and current WindowManager fallback diagnostics; Build #62 then passed the complete test suite and release pipeline without deleting tests or relaxing gates.
- Shizuku binding lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` was built/CI-tested by Build #62. Current main then added FPS TimeStats sampling/parser repair in `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`; **that new source, parser JUnit tests and workflow gate are not yet built or CI-tested**. Actual Shizuku binding, OEM layer access, foreground FPS and overlay rendering remain **UNVERIFIED** until device checks/logs.
- Current main source fingerprints: `lib/main.dart` `d24885cf0a40472b9fb23ee6ce73ad772ae73672`; `lib/floating_monitor.dart` `bae089f1f950bd70fe7e6f90e8afa1726293664f`; `lib/app_settings.dart` `4c89bcb3c04142ce49440a11b92054365c26f7a6`; `FloatingMonitorService.kt` `0f9544c4e5f568531426e771f81e950397c86a7`; `FpsShizukuUserService.kt` `8bb6181b4c86e1a2ae2c635969646303b6d84483`; new `FpsTimeStatsParser.kt` `66b5e3f489f4e160407d87c40d1ecee54e13282f`; new `FpsTimeStatsParserTest.kt` `ab6c63c627c05d9987de4d4af731f2ed86acde5b`; `widget_test.dart` `e2b79bf3023e15ebd4f5cac5edd9a3e1cd48a612`; `shizuku_fps_contract_test.dart` `276ebde11c7462a5090fb7b2a3518a6c080e9872`; workflow `df7cbfee8d6fb8ef12683a35b0419c5d3980a4e3`; Gradle `46d503aef8320864632d3eb2bf7536048b8fd96f`.
- Non-blocking findings: 23 Dart deprecation info findings, Gradle 9.3.1 out of date, native ELF DWARF data not obfuscated, JAR self-signed/no-timestamp/META-INF warnings, and cache save denied by token scope. Full details are in `APP_BUILD_REPORT.md`.
- Active Firmware remains user-accepted V6.6. Build #62 was App-only: no Firmware compilation, BIN publication, Firebase, OTA, flashing or device operation occurred.

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
| APP_BUILD_REPORT.md | Authoritative attempt-by-attempt ledger; Build #62 is latest verified release; current FPS patch at `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620` is unbuilt/unverified and must not be recorded as a successful build |
| CHANGELOG.md | Historical behavior/decision/failure ledger, not current truth |
| DESIGN_NOTES.md | Approved grille, icons/cooler and visual requirements |
| .github/workflows/jexfyz-app-build-trigger.yml | Authoritative manual issue-triggered App Build workflow |
| test/*.dart | Six active test files; Build #62 ran the complete configured suite: 88/88 passed. File presence alone is not execution evidence |
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
- The live artifact repo tree was re-fetched during the 2026-10-16 reconciliation and is exactly one file: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, size 1,455,936 bytes. This does not establish that the BIN was produced from the current source.
- Each durable decision has one canonical subject file. Update PROJECT_STATE.md for current state; APP_BUILD_REPORT.md for every build attempt; CHANGELOG.md for significant history; MEMORY_INDEX.md for changed routing; replace CHAT_TRANSFER.md last at context limit.
- Do not output credential contents from google-services.json or signing environment. Keep archives byte-for-byte and restore useful facts to canonical notes with explicit historical labels.
- User accepts Firmware V6.6 as final. Do not edit/compile Firmware, generate/publish/replace BIN, alter Firebase, OTA/flash or operate hardware without separate explicit authorization. Functional Firmware edits require FW_VERSION bump, matching filename and exactly one active versioned .ino. Do not introduce blocking delay()/timing while loops.
- Do not show a standalone Battery Protection Guard in the App UI. One-App/one-cooler exclusive pairing-lock remains a design requirement until source and physical behavior prove exclusivity. Keep OTA protected; read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before touching it, and VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing changes.
