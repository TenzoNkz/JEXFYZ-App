# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-11-06 (Asia/Jakarta), after repository workflow/documentation redesign in Diskusi. The canonical operating rules are now consolidated in MASTER_PROMPT.md. Gemini consultation can be proposed proactively when a second opinion materially helps; every handoff must contain all evidence because Gemini cannot access GitHub. CHAT_RULES.md is a compatibility pointer, and CHAT_TRANSFER_PROMPTS.md retains exactly two concise LOAD + CONTINUE prompts.

## Last engineering milestone

- Compact Settings/Connection source pass is committed but not released. The test's five stale route assertions were corrected in commit `c37aea44abeb832987e13a1c74701d415e85a737` to include `compactUi: true` for all five Settings subpages.
- STATIC SOURCE CHECK: each corrected expected substring occurs exactly once in both live source and test; all five obsolete strings are absent. Flutter/Dart formatting, targeted test, analyzer, full suite and physical-device/OEM QA remain NOT RUN. This is not a runtime test pass.
- No App source, Firmware source, tests or build workflow were changed in the repository-cleanup work. No App Build, Firmware compile, BIN/Firebase, OTA, flashing or device operation was performed.

## Release baseline and field evidence

- Latest independently verified App package (live check 2026-11-06): Build #129 / [Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), tested source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`; Release ID `403010611`; tag `jexfyz-latest` targets the same source.
- APK SHA-256: `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`; matching source ZIP SHA-256: `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed all 21 workflow steps, 122 Flutter tests, analyzer and the configured Android gate, signing/certificate, ZIP, tag/release and downloaded-asset checks. Native Android JUnit tasks were NO-SOURCE.
- Protected known production reference remains App Build #124 + Firmware V7.1. Owner previously reported installing/overwriting Build #128; the exact field APK identity is unknown. Firmware V7.1 compile/Online OTA remains USER-REPORTED. Exact BIN identity and physical behavior are UNVERIFIED.
- Live Actions check 2026-11-06: latest listed run #129; 0 active, 0 queued; 0 open PRs.

## Precise next action

In a Flutter-enabled environment run:

1. `dart format lib/app_settings.dart lib/floating_monitor.dart lib/main.dart test/floating_monitor_layout_contract_test.dart`
2. `flutter test test/floating_monitor_layout_contract_test.dart`
3. `flutter analyze --no-fatal-infos`
4. `flutter test`

Review actual results, then assess physical-device/OEM rendering. A separate explicit `Eksekusi Build App!` is required before creating a new APK.

## Durable memory and recovery

- Read MASTER_PROMPT.md before acting; it is the single authority for modes, authorization, Gemini handoff, evidence and memory cadence.
- Read this file fully, fetch live main HEAD/commit/tree, then read MEMORY_INDEX.md, PROJECT_STATE.md, HANDOVER.md and the canonical subject references for the task.
- GitHub does not automatically save chat text. Save durable decisions, findings, milestones, test results, blockers and next steps in the relevant notes plus this checkpoint; commit and re-read before claiming saved.
- APP_BUILD_REPORT.md is append-only attempt evidence; CHANGELOG.md is dated history; archive/*.md is immutable.