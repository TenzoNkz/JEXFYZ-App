# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main: 2026-10-18. Live code, Git refs, Actions results and Release assets supersede stale memory snapshots.

## Current verified checkpoint

- Latest verified App release is Build #71 / run `39008259484`, source/release commit `d9e026f70ec62455763de05048cba1557edfaf23`. Audit, dependencies, Dart analysis, **88/88 Flutter tests**, Android production compilation/configured gate, obfuscated APK, V1/V2/V3 signing/certificate, matching source archive and re-downloaded asset checks all passed. Full evidence is in APP_BUILD_REPORT.md.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains one [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) (asset `649710440`, `54,603,867` bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`) and one [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) (asset `649710439`, `2,847,410` bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`). Both assets were re-downloaded and verified against the exact source marker.
- Build #71 includes the post-Build-70 indicator-motion continuity and manual-voltage-toggle styling changes. Motion continues during the 440 ms OFF fade before pausing and resumes from retained phase at a loop-equivalent boundary; flame motion meets at the loop seam, Battery segments ripple subtly, Peltier sparks orbit a steady six-branch crystal, and active manual-voltage switches use theme primary while labels retain red/green/blue semantics.
- Gradle configured unit-test gate passed, but native JUnit tasks were NO-SOURCE after FPS-specific native tests were retired; no native JUnit cases ran in Build #71. Physical overlay/icon rendering, toggle appearance and live BLE/Fan Speed behavior remain **UNVERIFIED** on a real device.
- Current source hashes: `lib/main.dart` `bf2007203455c64c2dd840a84b31368063df44eb`; `lib/floating_monitor.dart` `31b45ea08b08ac7fc25ebd991dca873b889fdd14`; `lib/app_settings.dart` `36927823c91904a35d87d2f21bd77932a2214e83`; `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt` `ef35590cfc91fafe5dec104b7cfd7828011185bf`; active `firmware/JEXFYZ-V6.7.ino` `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`; `test/widget_test.dart` `767e7843f379c854fe7c8ab98293b4ec36008c88`; `test/floating_monitor_layout_contract_test.dart` `87e805095202ac3edfe55b9aeb3138c7c6886375`; `test/v6_7_qc_contract_test.dart` `6b71cc2ebbef9b3f1c9757728067eec4d11ff5ee`; `test/firmware_touch_adaptive_sync_test.dart` `94c0f074247f47fce7d939a72b0130eb1b2d70fa`.
- V6.6 compile/two-OTA claims are historical user reports. Current source is V6.7 for authorized Adaptive Fan PWM and remains uncompiled/unpublished. Build #71 remains the latest APK; no BIN/Firebase/OTA/flash/device action occurred, and the artifact repo remains BIN-only.

- Current source-only warning-screen change: failed official signing-certificate checks still route into `TamperScreen`; visible copy is intentionally profanity-only, and `HUBUNGI DEVELOPER` opens the contact link through the native bridge without showing its handle. This is a signer-identity gate, not a universal anti-tamper guarantee. Widget tests were added but not run; Build #71 remains the latest verified APK. Details live in APP_NOTES.md and HANDOVER.md.

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
- @Thinking Eksekusi Full! executes the approved source/docs/tests/audit scope and may commit directly to main; it does not authorize App Build or Firmware/device operations implicitly. The post-Build-70 motion/toggle source is now analyzed/tested/built/released by Build #71; further source changes require their own App Build/QC before claiming validation.
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
| APP_BUILD_REPORT.md | Authoritative build-attempt ledger; Build #71 is latest verified release. FPS parser/watchdog runs are historical. |
| CHANGELOG.md | Historical behavior/decision/failure ledger, not current truth |
| DESIGN_NOTES.md | Approved grille, icons/cooler and visual requirements |
| .github/workflows/jexfyz-app-build-trigger.yml | Authoritative manual issue-triggered App Build workflow |
| test/*.dart and Android native unit-test gate | Five Dart test files remain; Build #70 ran 86/86 Flutter tests. Native JUnit tasks were NO-SOURCE after retired FPS test removal. |
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
- The live artifact repo tree was re-fetched during the 2026-10-17 reconciliation and is exactly one file: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, size 1,455,936 bytes. This does not establish that the BIN was produced from the current source.
- Each durable decision has one canonical subject file. Update PROJECT_STATE.md for current state; APP_BUILD_REPORT.md for every build attempt; CHANGELOG.md for significant history; MEMORY_INDEX.md for changed routing; replace CHAT_TRANSFER.md last at context limit.
- Do not output credential contents from google-services.json or signing environment. Keep archives byte-for-byte and restore useful facts to canonical notes with explicit historical labels.
- V6.6 was previously user-accepted; current source is V6.7 after explicit source-change authorization and remains uncompiled. Do not edit/compile Firmware, generate/publish/replace BIN, alter Firebase, OTA/flash or operate hardware without separate explicit authorization. Functional Firmware edits require FW_VERSION bump, matching filename and exactly one active versioned .ino. Do not introduce blocking delay()/timing while loops.
- Do not show a standalone Battery Protection Guard in the App UI. One-App/one-cooler exclusive pairing-lock remains a design requirement until source and physical behavior prove exclusivity. Keep OTA protected; read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before touching it, and VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing changes.
