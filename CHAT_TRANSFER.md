# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-11-07 (Asia/Jakarta), after the authorized product-design and visual-quality capability rollout. The single operating policy is `MASTER_PROMPT.md`; `AGENTS.md` is the cross-agent entrypoint; `SKILLS_INDEX.md` is the skill and tool-capability map.

## Skills and capability rollout

- **Twelve repository skill workflows:** `repository-forensics`, `code-review`, `product-design-and-visual-quality`, `flutter-app-engineering`, `flutter-quality-and-regression`, `ble-p1-protocol-audit`, `esp32c3-firmware-safety`, `ota-and-release-integrity`, `github-actions-triage`, `hardware-power-thermal-analysis`, `technical-research-and-second-opinion`, and `documentation-memory-governance`.
- Canonical Codex-compatible files are in `.agents/skills/<name>/SKILL.md`; GitHub Copilot mirrors are in `.github/skills/<name>/SKILL.md`. All 11 mirror pairs were fetched and verified byte-for-byte identical. The `code-review` skill is intended for Copilot code review where that surface and repository configuration support skills.
- `MASTER_PROMPT.md` now selects one to three relevant skills and requires scope/evidence/system modelling, alternatives and quantitative checks, adversarial review, test traceability, diff review and verified checkpointing.
- Non-trivial UI/UX work must use `product-design-and-visual-quality` and read `PRODUCT_DESIGN_CONSTITUTION.md` plus `VISUAL_QUALITY_GATE.md`; `DESIGN_NOTES.md` remains the authority for owner-approved screen-specific details. The new gate requires actual screenshot evidence for visual PASS and keeps visual status separate from build/test status.
- ChatGPT mobile/web does not auto-install these private repository skills. It must fetch/read the relevant SKILL.md through GitHub tools when needed. The installed native ChatGPT skill list in this session exposes `plugin-management` only; GitHub, web, Python/container, Shopee and Automation tools are separate connected tool families. There is no direct Gemini connector; Gemini is a self-contained manual handoff and has no GitHub access.
- Current container checked 2026-11-07: Python 3 and Git available; Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF absent. Re-check before each validation task. This environment cannot claim local Flutter/Android/Firmware builds or physical-device validation.
- Documentation tree after the 12-skill/product-design rollout: 123 entries and 50 Markdown files (45 active/index/subject/agent/skill docs, 2 history ledgers and 3 immutable archives), based on the prior verified 119-entry/46-Markdown tree plus four new Markdown paths. No App/Firmware source, tests, workflow, build or release behavior changed.

## Main skill/agent commits

- Master Prompt skill routing: [f9e8f456](https://github.com/TenzoNkz/JEXFYZ-App/commit/f9e8f4566d22ca7c485d94462433c31947389153).
- Skill/capability index: [b5b94e7f](https://github.com/TenzoNkz/JEXFYZ-App/commit/b5b94e7f0bac061491594a2a229ccdc9a9059506).
- Root agent entrypoint: [2ae747d8](https://github.com/TenzoNkz/JEXFYZ-App/commit/2ae747d861f54d0528f3190b2c173a8fa7117720).
- Canonical skills: `.agents/skills/`; Copilot mirrors: `.github/skills/`. See [SKILLS_INDEX.md](SKILLS_INDEX.md) for the complete catalogue. Product design standards: [PRODUCT_DESIGN_CONSTITUTION.md](PRODUCT_DESIGN_CONSTITUTION.md) and [VISUAL_QUALITY_GATE.md](VISUAL_QUALITY_GATE.md).

## Last App engineering milestone

- Compact Settings/Connection source pass is committed but NOT RELEASED. Five stale Settings route expectations were corrected in commit `c37aea44abeb832987e13a1c74701d415e85a737` to include `compactUi: true` for Language, Appearance, Notifications, Bluetooth and Floating Settings.
- STATIC SOURCE CHECK only: all five expected substrings appear exactly once in live source and test; obsolete exact strings are absent. Flutter/Dart formatting, targeted test, analyzer, full suite and physical-device/OEM QA remain NOT RUN.
- Preserve the Home-equivalent 360-dp canvas, BLE P1, telemetry authority, localization, theme, safe-output, OTA and rail-timing contracts.

## Release baseline and field evidence

- Latest independently verified published App package (live check 2026-11-07): Build #129 / [Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), tested source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`; Release ID `403010611`; tag `jexfyz-latest` targets the same source.
- APK SHA-256: `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`; matching source ZIP SHA-256: `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed 21 workflow steps, 122 Flutter tests, analyzer (25 informational diagnostics), Android gate, signing/certificate, ZIP/source marker, Release/tag and downloaded-asset identity/digest checks. Native Android JUnit tasks were NO-SOURCE.
- Live Actions check 2026-11-07: latest run remains #129; zero active runs, zero queued runs. Latest Release/tag still target the #129 package source.
- Protected known production reference remains App Build #124 + Firmware V7.1. Owner previously reported installing/overwriting Build #128; exact field APK identity remains unverified. Firmware V7.1 compile/Online OTA is USER-REPORTED; exact BIN identity and physical behavior remain UNVERIFIED.

## Precise next engineering action

In a Flutter-enabled environment:

1. `dart format lib/app_settings.dart lib/floating_monitor.dart lib/main.dart test/floating_monitor_layout_contract_test.dart`
2. `flutter test test/floating_monitor_layout_contract_test.dart`
3. `flutter analyze --no-fatal-infos`
4. `flutter test`

Review actual results, then perform physical-device/OEM UI QA when available. A separate explicit `Eksekusi Build App!` is required before packaging the compact UI pass.

## Durable memory and safety

- Read `MASTER_PROMPT.md`, `AGENTS.md`, `SKILLS_INDEX.md`, this checkpoint, live main HEAD/tree, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `HANDOVER.md` and only the skills/subject references relevant to the task.
- GitHub does not automatically save chat text. Save durable decisions, findings, milestones, test results, blockers and next steps to canonical notes plus this checkpoint; verify commit/content/HEAD before saying saved.
- `.agents/skills` is canonical for Codex discovery; `.github/skills` must stay byte-identical. In ChatGPT, fetch/read only the relevant skill manually.
- `APP_BUILD_REPORT.md` is append-only build evidence; `CHANGELOG.md` is dated history; `archive/*.md` is immutable.
- Diskusi changes canonical documentation/skill instructions only. Eksekusi Full is the specifically authorized source/docs/tests scope. Only Eksekusi Build App! authorizes guarded App release. Firmware compilation, BIN/Firebase changes, OTA, flashing and device work require separate explicit authorization.