# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-11-07 (Asia/Jakarta), after a Discussion-mode skills and agent-capability rollout. The single operating authority is `MASTER_PROMPT.md`; root `AGENTS.md` is a short cross-agent entrypoint. Eleven focused project skills are available in `.agents/skills/` with byte-identical GitHub Copilot mirrors in `.github/skills/`. `SKILLS_INDEX.md` documents the catalogue, platform compatibility and tool limits.

## Skills and capability rollout

- **11 skill workflows:** `repository-forensics`, `code-review`, `flutter-app-engineering`, `flutter-quality-and-regression`, `ble-p1-protocol-audit`, `esp32c3-firmware-safety`, `ota-and-release-integrity`, `github-actions-triage`, `hardware-power-thermal-analysis`, `technical-research-and-second-opinion`, and `documentation-memory-governance`.
- Codex-compatible canonical skills: `.agents/skills/<name>/SKILL.md`. GitHub Copilot mirrors: `.github/skills/<name>/SKILL.md`. Mirrors must remain byte-for-byte identical. The dedicated `code-review` skill is intended for Copilot code-review use when that surface/configuration supports repository skills.
- `MASTER_PROMPT.md` now routes tasks to one-to-three relevant skills and defines a high-rigor workflow: scope, evidence, system model, alternatives/quantitative checks, adversarial review, test/evidence design, diff and checkpoint verification.
- ChatGPT in this conversation does not automatically discover private repo skills as installed ChatGPT skills. Fetch/read a relevant `SKILL.md` with GitHub tools when needed. Gemini has no repository/GitHub access; consultation is a fully self-contained prompt for the owner to paste manually.
- `AGENTS.md`, `SKILLS_INDEX.md`, `MASTER_PROMPT.md`, README, MEMORY_INDEX, current state and handover were updated. No executable source, test source, Firmware, build workflow or release configuration was changed in this skills rollout.
- Current container checked 2026-11-07: Python 3 and Git available; Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF absent. Re-check at task start. This environment cannot claim local Flutter/Android/Firmware builds or physical-device validation.

## Last App engineering milestone

- Compact Settings/Connection source pass is committed but NOT RELEASED. The five stale Settings route test expectations were corrected in commit `c37aea44abeb832987e13a1c74701d415e85a737` to include `compactUi: true` for Language, Appearance, Notifications, Bluetooth and Floating Settings.
- STATIC SOURCE CHECK only: all five updated expected substrings appear exactly once in live source and test; old exact strings are absent. Flutter/Dart formatting, targeted test, analyzer, full suite and physical-device/OEM QA remain NOT RUN.
- Preserve the Home-equivalent 360-dp canvas, BLE P1, telemetry authority, localization, theme, safety, OTA and rail-timing contracts.

## Release baseline and field evidence

- Latest independently verified published App package (live check 2026-11-06): Build #129 / [Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), tested source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`; Release ID `403010611`; tag `jexfyz-latest` targets the same source.
- APK SHA-256: `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`; matching source ZIP SHA-256: `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed 21 workflow steps, 122 Flutter tests, analyzer (25 informational diagnostics), Android gate, signing/certificate, ZIP/source marker, Release/tag and downloaded-asset identity/digest checks. Native Android JUnit tasks were NO-SOURCE.
- Protected known production reference remains App Build #124 + Firmware V7.1. Owner previously reported installing/overwriting Build #128; exact field APK identity remains unverified. Firmware V7.1 compile/Online OTA is USER-REPORTED; exact BIN identity and physical behavior remain UNVERIFIED.

## Precise next engineering action

In a Flutter-enabled environment:

1. `dart format lib/app_settings.dart lib/floating_monitor.dart lib/main.dart test/floating_monitor_layout_contract_test.dart`
2. `flutter test test/floating_monitor_layout_contract_test.dart`
3. `flutter analyze --no-fatal-infos`
4. `flutter test`

Review actual results, then perform physical-device/OEM UI QA when available. A separate explicit `Eksekusi Build App!` is required before packaging the compact UI pass.

## Durable memory and safety

- Read `MASTER_PROMPT.md`, then this checkpoint, live main HEAD/tree, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `HANDOVER.md` and relevant skills/subject references.
- GitHub does not automatically save chat text. Save durable decisions, findings, milestones, test results, blockers and next steps to canonical notes plus this checkpoint; verify commit/content/HEAD before saying saved.
- `APP_BUILD_REPORT.md` is append-only build evidence; `CHANGELOG.md` is dated history; `archive/*.md` is immutable.
- Diskusi changes documentation/skill instructions only. Eksekusi Full is the specifically authorized source/docs/tests scope. Only Eksekusi Build App! authorizes the guarded App release workflow. Firmware compilation, BIN/Firebase changes, OTA, flashing and device work require separate explicit authorization.