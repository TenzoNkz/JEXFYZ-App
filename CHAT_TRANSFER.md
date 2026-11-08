# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-11-08 (Asia/Jakarta), after the authorized Bluetooth scan-state and compact-theme regression repair. The single operating policy is `MASTER_PROMPT.md`; `AGENTS.md` is the cross-agent entrypoint; `SKILLS_INDEX.md` is the skill and tool-capability map.

## Skills and capability rollout

- **Twelve repository skill workflows:** `repository-forensics`, `code-review`, `product-design-and-visual-quality`, `flutter-app-engineering`, `flutter-quality-and-regression`, `ble-p1-protocol-audit`, `esp32c3-firmware-safety`, `ota-and-release-integrity`, `github-actions-triage`, `hardware-power-thermal-analysis`, `technical-research-and-second-opinion`, and `documentation-memory-governance`.
- Canonical Codex-compatible files are in `.agents/skills/<name>/SKILL.md`; GitHub Copilot mirrors are in `.github/skills/<name>/SKILL.md`. All 12 mirror pairs were fetched and verified byte-for-byte identical at the final product-design audit. The `code-review` skill is intended for Copilot code review where that surface and repository configuration support skills.
- `MASTER_PROMPT.md` now selects one to three relevant skills and requires scope/evidence/system modelling, alternatives and quantitative checks, adversarial review, test traceability, diff review and verified checkpointing.
- Non-trivial UI/UX work must use `product-design-and-visual-quality` and read `PRODUCT_DESIGN_CONSTITUTION.md` plus `VISUAL_QUALITY_GATE.md`; `DESIGN_NOTES.md` remains the authority for owner-approved screen-specific details. The new gate requires actual screenshot evidence for visual PASS and keeps visual status separate from build/test status.
- ChatGPT mobile/web does not auto-install these private repository skills. It must fetch/read the relevant SKILL.md through GitHub tools when needed. The installed native ChatGPT skill list in this session exposes `plugin-management` only; GitHub, web, Python/container, Shopee and Automation tools are separate connected tool families. There is no direct Gemini connector; Gemini is a self-contained manual handoff and has no GitHub access.
- Current container checked 2026-11-07: Python 3 and Git available; Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF absent. Re-check before each validation task. This environment cannot claim local Flutter/Android/Firmware builds or physical-device validation.
- Final recursive `main` tree audit: 125 entries, not truncated, and 50 Markdown files (45 active/index/subject/agent/skill docs, 2 history ledgers and 3 immutable archives). All 24 skill files were fetched; the 12 canonical/mirror pairs are byte-for-byte identical. No App/Firmware source, tests, workflow, build or release behavior changed.

## Main skill/agent commits

- Master Prompt skill routing: [f9e8f456](https://github.com/TenzoNkz/JEXFYZ-App/commit/f9e8f4566d22ca7c485d94462433c31947389153).
- Skill/capability index: [b5b94e7f](https://github.com/TenzoNkz/JEXFYZ-App/commit/b5b94e7f0bac061491594a2a229ccdc9a9059506).
- Root agent entrypoint: [2ae747d8](https://github.com/TenzoNkz/JEXFYZ-App/commit/2ae747d861f54d0528f3190b2c173a8fa7117720).
- Canonical skills: `.agents/skills/`; Copilot mirrors: `.github/skills/`. See [SKILLS_INDEX.md](SKILLS_INDEX.md) for the complete catalogue. Product design standards: [PRODUCT_DESIGN_CONSTITUTION.md](PRODUCT_DESIGN_CONSTITUTION.md) and [VISUAL_QUALITY_GATE.md](VISUAL_QUALITY_GATE.md).

## Product design quality rollout — verification

- Inventory reconciliation: `MEMORY_INDEX.md` updated in commit `6b8e25ae7d5b40f72c34dff924d50e1466a4ed58`; `CHANGELOG.md` records the audit in commit `a388912891d6dc86828a9ee7c3af501934cf6c1c`. This checkpoint is being refreshed last.

- Added `PRODUCT_DESIGN_CONSTITUTION.md`, `VISUAL_QUALITY_GATE.md` and the twelfth skill `product-design-and-visual-quality` with a byte-identical Codex/Copilot pair. Non-trivial UI/UX tasks are now routed through this skill and the existing Flutter engineering/quality skills.
- Updated Flutter engineering and Flutter quality skill pairs; both canonical/mirror pairs were re-fetched and verified identical. The new product-design skill pair was also fetched and verified identical. The nine other existing pairs were also fetched during the final audit. All 12 canonical/mirror pairs were independently re-fetched and verified identical.
- GitHub compare from prior checkpoint `b6a30dbdfe066a24152ca248729be4dd87e9bcff` to integration head `5e95e7a4402236c8adaacbadcb62213601fb7bc3` reports 19 changed paths, all Markdown. No executable App/Firmware source, test source, workflow, build/release configuration or artifact changed. The final checkpoint update is documentation-only as well.
- Static document/link/routing checks confirm the constitution, visual gate, skill index, Master Prompt and agent entrypoint are connected. The final recursive tree audit confirms 125 entries (not truncated) and 50 Markdown files.
- **Visual QA status: NOT RUN / UNVERIFIED.** No App screenshot was captured or reviewed in this documentation task. The standard defines how future UI changes must prove a visual PASS; it does not claim that any existing screen has passed or that the pending compact Settings/Connection pass is validated/released.

## Last App engineering milestone — Bluetooth scan-state and compact-theme test repair

- Added `lib/connection_scan_state.dart` to distinguish permission-required, Bluetooth/legacy-location unavailable, scan failure, active scan and completed-no-result messages using existing English/Indonesian localization keys.
- Connection sheet starts its initial scan after first frame, observes `FlutterBluePlus.isScanning` separately from fresh `onScanResults`, resets the results subscription for each scan generation to avoid stale previous-scan results, and routes retry through one guarded handler. Scan-start errors now reach the UI; sheet dismissal still stops scanning.
- BLE P1 UUIDs/framing, scan identity filter, GATT connect callback, P1 synchronization, authoritative telemetry, persisted schemas, DPI canvas, hit targets, Firmware and OTA contracts are unchanged.
- Added five pure state-mapping tests in `test/connection_scan_state_test.dart`. `test/floating_monitor_layout_contract_test.dart` now renders `compactUi: true`, verifies typography/inherited palette, tests 350-dp and 420-dp fixed physical geometry, and asserts the live scan-state integration.
- Source/test commits: `68ae5662ceb2b71f1c20790f66ad69d9010b1530` (state helper), `c49f523082f5f55f7441de9be7fadacd80e16485` (scan request lifecycle), `6dc650a9e7ece7d613fe0cf7eec23c2944428435` (scan UI), `00bdfe75f523eca1c246d599ce77111179575f13` (fresh scan results/reset), `cf2a20bbdce7663ae5cbcdd23534102e2524108f` (state tests), `34cb5a5eda8aa7b092d2ad701fc65693750bcfb2` (compact theme viewport coverage), `a61f5bb788039dfd0165addfe3909f2b72d6b1ce` (fresh result-stream contract), `5567ab9d668dfdb0fea1f0bcffcd4b61ac043de0` (clear stale error when an active scan is reused), and `ab460131d5190928b7585d5b57f9da8242689d6d` (assert guarded retry wiring).
- **Evidence: SOURCE IMPLEMENTED / NOT RUN.** Current container has Git/Python but no Flutter or Dart. Formatter, focused tests, analyzer and full Flutter suite have NOT RUN. No screenshot was captured; Visual QA remains NOT VERIFIED. These changes are NOT RELEASED and are absent from Build #129.
- **Pre-checkpoint main HEAD:** `ab460131d5190928b7585d5b57f9da8242689d6d`; the only remaining write in this task is this documentation checkpoint.
- **Next exact action:** in a Flutter-enabled environment run `dart format lib/main.dart lib/connection_scan_state.dart test/floating_monitor_layout_contract_test.dart test/connection_scan_state_test.dart`, then `flutter test test/connection_scan_state_test.dart test/floating_monitor_layout_contract_test.dart`, `flutter analyze --no-fatal-infos`, and `flutter test`. Inspect Android screenshots at 350-dp/420-dp, English/Indonesian and Light/Dark. Only a separate `Eksekusi Build App!` authorizes packaging.

## Release baseline and field evidence

- Latest independently verified published App package (live check 2026-11-08): Build #129 / [Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), tested source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`; Release ID `403010611`; tag `jexfyz-latest` targets the same source.
- APK SHA-256: `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`; matching source ZIP SHA-256: `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed 21 workflow steps, 122 Flutter tests, analyzer (25 informational diagnostics), Android gate, signing/certificate, ZIP/source marker, Release/tag and downloaded-asset identity/digest checks. Native Android JUnit tasks were NO-SOURCE.
- Live Actions check 2026-11-07: latest run remains #129; zero active runs, zero queued runs. Latest Release/tag still target the #129 package source.
- Protected known production reference remains App Build #124 + Firmware V7.1. Owner previously reported installing/overwriting Build #128; exact field APK identity remains unverified. Firmware V7.1 compile/Online OTA is USER-REPORTED; exact BIN identity and physical behavior remain UNVERIFIED.

## Precise next engineering action

In a Flutter-enabled environment:

1. `dart format lib/main.dart lib/connection_scan_state.dart test/floating_monitor_layout_contract_test.dart test/connection_scan_state_test.dart`
2. `flutter test test/connection_scan_state_test.dart test/floating_monitor_layout_contract_test.dart`
3. `flutter analyze --no-fatal-infos`
4. `flutter test`

Review exact output, then inspect actual Android screenshots at 350-dp/420-dp with English/Indonesian and Light/Dark themes. Only after validation and a separate explicit `Eksekusi Build App!` may an APK be packaged.
## Durable memory and safety

- Read `MASTER_PROMPT.md`, `AGENTS.md`, `SKILLS_INDEX.md`, this checkpoint, live main HEAD/tree, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `HANDOVER.md` and only the skills/subject references relevant to the task.
- GitHub does not automatically save chat text. Save durable decisions, findings, milestones, test results, blockers and next steps to canonical notes plus this checkpoint; verify commit/content/HEAD before saying saved.
- `.agents/skills` is canonical for Codex discovery; `.github/skills` must stay byte-identical. In ChatGPT, fetch/read only the relevant skill manually.
- `APP_BUILD_REPORT.md` is append-only build evidence; `CHANGELOG.md` is dated history; `archive/*.md` is immutable.
- Diskusi changes canonical documentation/skill instructions only. Eksekusi Full is the specifically authorized source/docs/tests scope. Only Eksekusi Build App! authorizes guarded App release. Firmware compilation, BIN/Firebase changes, OTA, flashing and device work require separate explicit authorization.
