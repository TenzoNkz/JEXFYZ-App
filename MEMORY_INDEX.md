# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-18 (Asia/Jakarta); current App tree audited with `truncated=false`. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Current verified checkpoint

- Latest verified App release is Build #80 / [Actions run `39171729285`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39171729285), exact source/release commit `4e9f14b959cdbf60136158187db26d0bb65f6287`. All 21 active workflow steps passed; Dart analysis reported 23 info-level deprecations and **96/96 Flutter tests passed**. Android production compile/configured gate, APK obfuscation, V1/V2/V3 signing/certificate, matching source archive and downloaded-asset checks passed. Full evidence is in `APP_BUILD_REPORT.md`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains the verified Build #80 APK (asset `654626935`, 54,620,251 bytes, SHA-256 `b403ccd3813f1974b82703730fce2c60bab972b067bc7ac4875d51d0e55558c6`) and matching source ZIP (asset `654626933`, 2,852,944 bytes, SHA-256 `bae47230267438073c9fd2bdf9ee58bfd768a5fcdfedf7102983c05dc23bf0cc`). Both were re-downloaded and checked.
- Native JUnit compile/test tasks were NO-SOURCE in Build #80; no native JUnit cases ran. Physical Home icon rendering, BLE/Fan telemetry and hardware behavior remain unverified on a real device.
- Current source hashes: `lib/main.dart` `522e108dd78d9b413316a6c79c8a4f0144f5e58f`; `lib/floating_monitor.dart` `31b45ea08b08ac7fc25ebd991dca873b889fdd14`; `lib/app_settings.dart` `36927823c91904a35d87d2f21bd77932a2214e83`; `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt` `ef35590cfc91fafe5dec104b7cfd7828011185bf`; active `firmware/JEXFYZ-V6.7.ino` `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; `test/widget_test.dart` `5098c30291cbd70422cd351f03cd9325f0870258`; `test/floating_monitor_layout_contract_test.dart` `87e805095202ac3edfe55b9aeb3138c7c6886375`; `test/v6_7_qc_contract_test.dart` `6b71cc2ebbef9b3f1c9757728067eec4d11ff5ee`; `test/firmware_touch_adaptive_sync_test.dart` `94c0f074247f47fce7d939a72b0130eb1b2d70fa`.
- Build #80 includes TamperScreen rounded text blocks plus the current Home animation/state gating, toggle styling and submenu-lock overlays. The only post-Build-80 source delta is an explicit static `Icon` in place of the generic glyph wrapper for the warning symbol, plus its regression assertion.
- Peltier, Adaptive and LED toggles use neutral rows like Manual Voltage, have no knob checkmark, and omit their adjacent ON/OFF text. When Bluetooth is disconnected one overlay blurs the entire selected submenu with a centered lock panel; tabs and Home Bluetooth remain usable. Adaptive active/transitioning applies that single overlay only to Voltage, Control and Temperature.
- Existing widget/test contracts cover the menu lock matrix, centered overlay, toggle design, indicator contour/motion and thermal color boundaries. The TamperScreen contract now also asserts the warning symbol is a plain static Icon. **This post-Build-80 source follow-up has NOT been tested/analyzed or built** because Flutter/Dart executables are unavailable in this runtime. Static source checks are not runtime test results.

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
- @Thinking Eksekusi Full! executes the approved source/docs/tests/audit scope and may commit directly to main; it does not authorize App Build or Firmware/device operations implicitly. Build #80 is the latest verified release. Current source edits after that exact checkout require separate App Build/QC before claiming validation.
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
| APP_BUILD_REPORT.md | Authoritative build-attempt ledger; Build #80 is latest verified release; older failures remain in the history. |
| CHANGELOG.md | Historical behavior/decision/failure ledger, not current truth |
| DESIGN_NOTES.md | Approved grille, icons/cooler and visual requirements |
| .github/workflows/jexfyz-app-build-trigger.yml | Authoritative manual issue-triggered App Build workflow |
| test/*.dart and Android native unit-test gate | Build #80 passed 96/96 Flutter tests; native JUnit tasks were NO-SOURCE. The post-Build-80 static warning-Icon source contract is added but NOT RUN. |
| firmware/JEXFYZ-V6.7.ino | Current editable Firmware source, one versioned active sketch |
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
- The live artifact repo tree was re-fetched on 2026-10-18 and is complete/not truncated with exactly one entry: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, size 1,455,936 bytes. The BIN payload was not downloaded/read, and source-to-BIN provenance is UNVERIFIED.
- Each durable decision has one canonical subject file. Update PROJECT_STATE.md for current state; APP_BUILD_REPORT.md for every build attempt; CHANGELOG.md for significant history; MEMORY_INDEX.md for changed routing; replace CHAT_TRANSFER.md last at context limit.
- Do not output credential contents from google-services.json or signing environment. Keep archives byte-for-byte and restore useful facts to canonical notes with explicit historical labels.
- V6.6 was previously user-accepted; on 2026-10-18 the user reported V6.7 compiled successfully and was updated online. Treat this as USER-REPORTED, not independently verified: no compile log, BIN identity, Firebase state, OTA logs or current device version was inspected. Do not edit/compile Firmware, generate/publish/replace BIN, alter Firebase, OTA/flash or operate hardware without separate explicit authorization. Functional Firmware edits require FW_VERSION bump, matching filename and exactly one active versioned .ino. Do not introduce blocking delay()/timing while loops.
- Do not show a standalone Battery Protection Guard in the App UI. One-App/one-cooler exclusive pairing-lock remains a design requirement until source and physical behavior prove exclusivity. Keep OTA protected; read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before touching it, and VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing changes.
