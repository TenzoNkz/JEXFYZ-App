# JE X FYZ / JE Cooler — Repository File-by-File Upgrade Register

Last inventory snapshot: 2026-11-26 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Purpose and completion rule

This is the single file-level inventory and rolling review register for the canonical repository `TenzoNkz/JEXFYZ-App`. Its purpose is to ensure every tracked file is consciously reviewed and either improved when justified or explicitly retained as verified/protected/immutable.

**"All files reviewed" does not mean "all files modified".** No file may be changed merely to create activity. A file that already meets its contracts must be recorded as `KEEP / VERIFIED`; a protected file must be respected; historical evidence must remain intact. Never mass-rewrite files without a file-level reason and acceptance test.

## Baseline inventory evidence

- Repository / branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Baseline HEAD before adding this register: `c9699c2bf9c4b5843eb28014e34c34fb436d6b15`.
- Recursive tree: 141 entries, 95 blobs, 46 trees; `truncated=false`.
- Extensions: 53 Markdown, 19 Dart, 3 workflow YML, 2 YAML, 1 Gitignore, 3 Gradle, 1 JSON, 1 ProGuard, 2 XML, 4 Kotlin, 3 PNG, 1 properties, 1 Firmware INO and 1 lockfile.
- This inventory is **path-complete, not content-audited**. Except for files explicitly reviewed in a linked work-package note, all rows begin with CONTENT REVIEW PENDING.

## File state model

`INVENTORIED — CONTENT REVIEW PENDING` → `REVIEWED — DECISION RECORDED` → one of:
- `KEEP / VERIFIED`
- `UPGRADE APPROVED`
- `REPLACE APPROVED`
- `PROTECTED — NO CHANGE`
- `RETIRE CANDIDATE — OWNER REVIEW REQUIRED`
- `IMMUTABLE — RETAIN`

If approved for change: `CHANGE PLANNED` → `IN_PROGRESS` → `CHANGED` → `VALIDATED` → `CLOSED / READ-BACK VERIFIED`.

Exceptional states: `BLOCKED`, `RECOVERY_REQUIRED`, `FAILED`, `WAITING_OWNER`. A file is not closed while required evidence is absent.

## Required per-file review record

For every reviewed file, update its row with the actual disposition and add a concise record under the relevant work package:
1. Exact path, file role, current source/commit checkpoint and content reviewed.
2. Owner contract/invariants and all relevant callers, imports, path links, workflow consumers or data dependencies.
3. Findings, including why keeping the file unchanged is or is not the best decision.
4. Disposition and explicit included/excluded scope.
5. Acceptance checks: static references, formatter, analyzer, unit/widget/integration tests, workflow checks, visual/device evidence, or rationale for not applicable.
6. Exact observed results and evidence class; never infer a test from test-source existence.
7. Final diff review, committed content read-back and closing main HEAD.

Do not duplicate large test/build logs here; link to the canonical subject note, `APP_BUILD_REPORT.md`, `CHANGELOG.md` or active checkpoint.

## Work-package sequence and dependency order

| WP | Scope | Main gate |
|---|---|---|
| WP0 | Governance, command names, status model, prompts, handoff and this register | One source of truth; three distinct workspaces; register complete |
| WP1 | Toolchain and test/validation foundations; analyzer/formatter/CI trust | Reproducible environment, exact SHA and stable quality baseline |
| WP2 | Dart application core, state ownership, BLE/P1 and telemetry contracts | Requirement-to-test traceability; no protocol/safety regression |
| WP3 | Flutter UI, accessibility, animation, localization and visual design | Behavioral tests plus screenshot/device acceptance where applicable |
| WP4 | Android native Kotlin, manifest, notifications, foreground service and overlay | Native lifecycle/security/permission regression and device evidence |
| WP5 | Android/Flutter configuration, Gradle, dependencies, lockfile and signing boundaries | Compatibility matrix, lock integrity, no identity/signing drift |
| WP6 | Non-publishing CI/PR validation workflows and source governance | Least privilege, pinned actions, no unintended write/publish path |
| WP7 | Guarded Build App workflow, packaging and release provenance | Fresh Build App authorization; no duplicate run; exact artifact/source verification |
| WP8 | Assets, iconography, transparency, dimensions, localization resources | Reference/path integrity and actual visual inspection |
| WP9 | Firmware source/reference, OTA, Firebase and other protected subsystems | Separate explicit authorization for each protected operation; no implicit compile/BIN/device/OTA permission |
| WP10 | Historical ledgers, archives, retention and final cross-link audit | Append-only/immutable evidence preserved; all live references resolve |

Dependency order may change only when a documented technical dependency requires it. Work in small, dependency-coherent batches; do not start a downstream WP while its prerequisite gate is failed or blocked.

## Cross-workspace operating flow

1. **Diskusi!** — read-only technical inspection/planning. Establish facts, file map, risks, alternatives and acceptance matrix. Save decision, exclusions and handoff packet in the bounded active checkpoint plus the relevant subject note. Do not change executable source/tests/config/workflows or trigger external processes.
2. **Eksekusi Code!** — verify the handoff against live `main`, re-fetch target SHAs, review each approved file individually, implement only the authorized work package, add/maintain regression coverage, run required available checks, review the full diff and save verified canonical memory. No App package/release, Firmware compilation/BIN, Firebase production mutation, OTA, flashing or device operation.
3. **Eksekusi Build App!** — accept only a build-ready handoff tied to an exact verified source commit and required source validation. Read current `BUILD_NOTES.md` and the full guarded workflow; check active runs before acting; require a fresh explicit Build App authorization; run the guarded process once; inspect jobs/logs/artifacts/release/tag/source digests; update the evidence ledger and final handoff. No Firmware/device work.
4. **Chat Stuck!** — recovery only inside the selected workspace. Verify live operation state, repository HEAD and previous results first. It never widens authorization or repeats a side effect blindly.

The three chats must remain separate. The shared `WORKSPACE` marker is identification, not a lock. Only one project writer/build operator may act at a time.

## Fail-closed gates

- G0 — session, workspace, current HEAD/tree, single-writer and external-operation preflight.
- G1 — exact owner authorization, included/excluded paths and protected-path check.
- G2 — complete inventory, source-of-truth map and dependency/reference trace.
- G3 — accepted design/technical decision, risks, test plan and acceptance criteria.
- G4 — scoped implementation; per-file decisions recorded.
- G5 — independent diff review, formatter, analyzer, focused tests and full required regression.
- G6 — exact source SHA and hosted CI reconciliation; no unverified claim.
- G7 — separate Build App authorization and package/release provenance (when requested).
- G8 — documentation/checkpoint/status read-back, final main HEAD/tree and handoff closure.

A failed gate blocks dependent work. Retry only after classifying root cause (source defect, test defect, formatting, dependency/network, runner/queue, credentials, workflow guard, artifact/release, environment or device). Never downgrade a required gate or make a retry to hide a failure.

## Active owner request — full App rework overlay — 2026-11-26

- The owner requested a full App-side repository rework and complete premium/elegant UI redesign. The detailed execution plan and ordered WPs are in `APP_PREBUILD_AUDIT.md` → “Owner-requested full App rework + premium UI redesign — 2026-11-26”; design direction and screen brief are in `DESIGN_NOTES.md` → “Full App visual redesign brief — owner request 2026-11-26”.
- This register remains the single source of truth for **per-file disposition**. Review every file against actual role, consumers, contracts and evidence. Do not mass-edit or mark every file UPGRADE just because the request says “full rework”.
- At this handoff: 3/96 blob dispositions are recorded (analysis_options.yaml KEEP / VERIFIED; pubspec.yaml UPGRADE / CLOSED / READ-BACK VERIFIED; pubspec.lock KEEP / VERIFIED). The 12 formatter-touched Dart files still require individual content review. The next unreviewed inventory path after the lockfile is `README.md`.
- In the Code workspace, first reconcile live HEAD/tree/status, then resume WP0 and WP1. Keep the App-only scope and protected path exclusions in the active plan; Firmware/BIN, BLE protocol/security changes, OTA, Firebase production, signing, package/release, flashing and device operation are not authorized by this register or owner UI request.

## File inventory

| Path | File class | Guard / authority | Current review state |
|---|---|---|---|
| `.agents/skills/ble-p1-protocol-audit/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/code-review/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/documentation-memory-governance/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/esp32c3-firmware-safety/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/flutter-app-engineering/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/flutter-quality-and-regression/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/github-actions-triage/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/hardware-power-thermal-analysis/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/ota-and-release-integrity/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/product-design-and-visual-quality/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/repository-forensics/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.agents/skills/technical-research-and-second-opinion/SKILL.md` | Canonical agent skill | CANONICAL SKILL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/ble-p1-protocol-audit/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/code-review/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/documentation-memory-governance/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/esp32c3-firmware-safety/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/flutter-app-engineering/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/flutter-quality-and-regression/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/github-actions-triage/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/hardware-power-thermal-analysis/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/ota-and-release-integrity/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/product-design-and-visual-quality/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/repository-forensics/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/skills/technical-research-and-second-opinion/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Guarded release workflow | WORKFLOW — SECURITY / SCOPE GATED | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/workflows/jexfyz-app-pr-validation.yml` | Validation workflow | WORKFLOW — SECURITY / SCOPE GATED | INVENTORIED — CONTENT REVIEW PENDING |
| `.github/workflows/jexfyz-app-validation.yml` | Validation workflow | WORKFLOW — SECURITY / SCOPE GATED | INVENTORIED — CONTENT REVIEW PENDING |
| `.gitignore` | Repository ignore policy | REPOSITORY CONFIG | INVENTORIED — CONTENT REVIEW PENDING |
| `00_WORK_STATUS.md` | Session continuity | ACTIVE STATUS / CHECKPOINT | INVENTORIED — CONTENT REVIEW PENDING |
| `AGENTS.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `analysis_options.yaml` | Dart analyzer policy | QUALITY CONFIG — ANALYZER GATE | KEEP / VERIFIED — 2026-11-26 (WP1) |
| `android/app/build.gradle` | Android build configuration | BUILD CONFIG — COMPATIBILITY GATED | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/google-services.json` | Firebase Android config | PROTECTED — SENSITIVE CONFIGURATION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/proguard-rules.pro` | Android manifest/resource/security config | ANDROID CONFIG — PLATFORM REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/src/main/AndroidManifest.xml` | Android manifest/resource/security config | ANDROID CONFIG — PLATFORM REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/src/main/res/drawable-nodpi/jexfyzicon.png` | Binary visual asset | BINARY ASSET — VISUAL / INTEGRITY REVIEW | INVENTORIED — CONTENT REVIEW PENDING |
| `android/app/src/main/res/drawable/ic_notification.xml` | Android manifest/resource/security config | ANDROID CONFIG — PLATFORM REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `android/build.gradle` | Android build configuration | BUILD CONFIG — COMPATIBILITY GATED | INVENTORIED — CONTENT REVIEW PENDING |
| `android/gradle.properties` | Android build configuration | BUILD CONFIG — COMPATIBILITY GATED | INVENTORIED — CONTENT REVIEW PENDING |
| `android/settings.gradle` | Android build configuration | BUILD CONFIG — COMPATIBILITY GATED | INVENTORIED — CONTENT REVIEW PENDING |
| `APP_BUILD_REPORT.md` | Append-only evidence ledger | APPEND-ONLY / NO REWRITE | INVENTORIED — CONTENT REVIEW PENDING |
| `APP_NOTES.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `APP_PREBUILD_AUDIT.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md` | Immutable archive | IMMUTABLE / HISTORICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `archive/CHAT_TRANSFER_PRE_COMPACTION_2026-11-15.md` | Immutable archive | IMMUTABLE / HISTORICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md` | Immutable archive | IMMUTABLE / HISTORICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md` | Immutable archive | IMMUTABLE / HISTORICAL | INVENTORIED — CONTENT REVIEW PENDING |
| `assets/jexfyzcooler.png` | Binary visual asset | BINARY ASSET — VISUAL / INTEGRITY REVIEW | INVENTORIED — CONTENT REVIEW PENDING |
| `assets/jexfyzicon.png` | Binary visual asset | BINARY ASSET — VISUAL / INTEGRITY REVIEW | INVENTORIED — CONTENT REVIEW PENDING |
| `BLE_APP_AUTH.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `BUILD_NOTES.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `CHANGELOG.md` | Append-only evidence ledger | APPEND-ONLY / NO REWRITE | INVENTORIED — CONTENT REVIEW PENDING |
| `CHAT_RULES.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `CHAT_TRANSFER_PROMPTS.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `CHAT_TRANSFER.md` | Session continuity | ACTIVE STATUS / CHECKPOINT | INVENTORIED — CONTENT REVIEW PENDING |
| `DESIGN_NOTES.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `FIRMWARE_NOTES.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `firmware/JEXFYZ-V7.2.ino` | Firmware source | PROTECTED — FIRMWARE AUTHORIZATION REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `HANDOVER.md` | Session continuity | ACTIVE STATUS / CHECKPOINT | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/app_settings.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `lib/connection_scan_coordinator.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/connection_scan_state.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/floating_monitor.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `lib/jex_animated_glyph.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/main.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `lib/usage_statistics.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `MASTER_PROMPT.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `MEMORY_INDEX.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `OTA_PROTECTION.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `OTA_REGRESSION_MEMORY.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `PRODUCT_DESIGN_CONSTITUTION.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `PROJECT_STATE.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `pubspec.lock` | Flutter dependency manifest/lock | DEPENDENCY CONTRACT — REVIEW BEFORE CHANGE | KEEP / VERIFIED (2026-11-26) |
| `pubspec.yaml` | Flutter dependency manifest/lock | DEPENDENCY CONTRACT — REVIEW BEFORE CHANGE | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `README.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `SKILLS_INDEX.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `test/app_protocol_notify_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/connection_scan_coordinator_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `test/connection_scan_state_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/device_copy_notification_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `test/firmware_qc_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `test/firmware_touch_adaptive_sync_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/floating_monitor_layout_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `test/github_actions_workflow_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `test/localization_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `test/support/source_contract_helpers.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/usage_statistics_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `test/widget_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING (FORMATTER ONLY, `003bccd6`) |
| `VISUAL_QUALITY_GATE.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `VOLTAGE_TRANSITION_MEMORY.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `REPOSITORY_UPGRADE_PLAN.md` | Repository-wide upgrade register | Canonical per-file audit register | CREATED — inventory snapshot maintained above |

## Content review records

### WP1 — `analysis_options.yaml` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `35959019dfeae2aaecd62ed9c2c7ac4fb11ed150`; file blob `26a17a80d98bcde51b90f61ee57eb2ab59b4ea90`.
- **Role and content:** the root analyzer policy contains only the repository intent comment and `include: package:flutter_lints/flutter.yaml`. It delegates lint definitions to the project dependency instead of copying or forking rule sets in this file.
- **Dependencies and consumers:** `pubspec.yaml` declares `flutter_lints: ^6.0.0` under `dev_dependencies`; `pubspec.lock` pins `flutter_lints 6.0.0` with its hosted checksum. The non-publishing Validation Only workflow includes this path in its main push filter and runs `flutter analyze --no-fatal-infos`, so analyzer changes remain covered by the normal quality gate.
- **Finding / disposition:** the include, manifest declaration and lock entry are consistent. No stale override, duplicate analyzer policy or mismatch was found. The current configuration is intentionally minimal; no change is justified. Disposition: **KEEP / VERIFIED**.
- **Acceptance evidence:** Validation Only #67 / run `45696341946` / job `139494616397` on source `538c0eb760f89cdcf6efb13e0bb4a906d941668e` reported its analyzer step SUCCESS; the job also reports formatter PASS and **219/219 Flutter tests PASS**. This file has the same blob SHA at the reviewed `3595901` HEAD, so the CI analyzer evidence applies to its unchanged contents. Evidence class: **VERIFIED CI** for the cited source SHA; this is not a test executed locally in this interaction.
- **Local validation:** Dart and Flutter executables are not installed in the current execution container. Local formatter/analyzer/test commands are **BLOCKED / NOT RUN**; no local test result is claimed. YAML-specific formatter/test is not applicable to this one-include policy.
- **Scope:** this review changes only the inventory disposition. It does not authorize changes to dependencies, analyzer rules, tests, workflows or App packaging.
- **Next file:** review `pubspec.yaml` and its lockfile/import/workflow consumers as a separate dependency-manifest audit.

### WP1 — `pubspec.yaml` — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- **Reviewed checkpoint:** current `main` HEAD `003bccd6e88b38710557df1d352386665491a254`; manifest blob `a0b8698c7c89efe43bb32b3ac6871c66bfcc873d`; lock blob `7475e368d4c6c237c726a61a38631b75bb84f0c1`; regression test blob after format-only commit `e0851999ca7177e3ef080e0b9c5ad1be10ba062d`.
- **Role and consumers:** this is the Flutter package manifest, defining package identity/version, SDK bounds, direct runtime/dev dependencies and the two registered assets. Every direct package has a source/test or platform integration consumer: Firebase Core/App Check, BLE `flutter_blue_plus`, secure storage, permissions, Phosphor icons, `path` and local SQLite via `sqflite`; Flutter Test and `flutter_lints` serve tests/analyzer. Android integration is resolved through Flutter's Gradle plugin loader and the tracked platform manifest/services. Both `assets/jexfyzcooler.png` and `assets/jexfyzicon.png` are present in the repository and declared here.
- **Finding / repair:** the prior Dart lower bound `>=3.9.0` was below the resolved dependency graph's lockfile minimum `>=3.13.0`, and the manifest omitted the lockfile's Flutter SDK minimum `>=3.38.4`. Validation Only and guarded Build App workflows use Flutter `3.47.2`. Updated `environment.sdk` to `>=3.13.0 <4.0.0`, added `environment.flutter: '>=3.38.4'`, and changed only the root `sqflite` constraint from exact `2.4.2` to `^2.4.2`. A nearby comment explains that the lockfile preserves the exact resolved release/CI version.
- **Dependency/lock invariants:** no package version was upgraded, removed or added. `pubspec.lock` is unchanged and still pins `sqflite 2.4.2`; all other resolved package versions and checksums remain unchanged. App version `1.0.0+3` and both asset declarations remain unchanged. The locked graph and root constraints are now consistent.
- **Regression repair:** `test/usage_statistics_test.dart` now asserts that the root manifest uses the intended caret range rather than pinning the exact package version, while preserving the assertions for local SQLite tables/schema/upgrade path and the exclusion of Firebase persistence. The file was restored from the verified pre-edit baseline before applying this one-assertion/comment change.
- **Validation evidence:** local YAML parsing and manifest/source/asset structural checks PASS. Validation Only #72 / run `45700008025` / job `139507345524` completed SUCCESS on input source `27ac09c5b77401c37f5fdbfd575001bab5ea9544`: locked dependency resolution (`flutter pub get --enforce-lockfile`) PASS; formatter applied and post-format verification PASS; analyzer PASS (106 info-level notices, no warning/error failures); Flutter tests **219/219 PASS**. The same job committed the formatter-only child `003bccd6e88b38710557df1d352386665491a254` with message `style: format Dart sources and tests`; it touched exactly 12 paths under `lib/` and `test/` and is the current main HEAD. The commit parent is the tested source SHA. No further run was triggered by the bot's GITHUB_TOKEN push, so CI evidence is labelled against the parent source; the child is strictly the workflow's Dart formatter output, and the job's post-format check was PASS.
- **Local toolchain boundary:** Flutter, Dart, Gradle and ADB are unavailable in the execution container. Local Dart format/analyzer/Flutter tests are **BLOCKED / NOT RUN**. The local YAML parser/structural checks are STATIC SOURCE CHECK evidence, not Flutter test execution.
- **Release boundary:** the manifest/test changes and formatter commit are not included in the immutable Build #167 APK. No Build App, APK, signing, tag, Release or asset operation occurred.
- **Scope/disposition:** change is limited to SDK lower bounds, the `sqflite` root version range/comment and its regression assertion; no dependency upgrade or lockfile rewrite was performed. Disposition: **UPGRADE — CLOSED / READ-BACK VERIFIED**.
- **Next file:** audit `pubspec.lock` independently as the exact resolved dependency graph: direct/transitive declarations, SDK constraints, package sources/checksums, platform packages and correspondence to the manifest/workflows. Do not update package versions unless a specific mismatch or defect is demonstrated.

### WP1 — `pubspec.lock` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** current `main` HEAD `46ab7901341a5dda943c756f9ba01efdf72bf4c6`; lock blob `7475e368d4c6c237c726a61a38631b75bb84f0c1`; matching manifest blob `a0b8698c7c89efe43bb32b3ac6871c66bfcc873d`.
- **Role and graph:** generated Flutter package lock containing 91 package records: 9 direct runtime, 2 direct development, and 80 transitive/SDK-support records. The 11 direct package declarations match `pubspec.yaml` one-for-one. Each locked direct hosted version satisfies its declared caret constraint; `flutter` and `flutter_test` are SDK dependencies.
- **Integrity/source structure:** 87 hosted package records resolve from `https://pub.dev` and each includes a SHA-256 checksum. Four packages are supplied by the Flutter SDK. No Git or path package source is present. Locked platform-interface/implementation families exist for Firebase Core/App Check, BLE, secure storage, permission handling and SQLite/sqflite. This verifies the lock graph's declared package structure, not runtime behavior on every platform.
- **SDK correspondence:** lockfile Dart constraint `>=3.13.0 <4.0.0` and Flutter constraint `>=3.38.4` exactly match the current manifest environment bounds. The locked `sqflite 2.4.2` satisfies the manifest's `^2.4.2`; no package is outside the current direct constraints.
- **Workflow consumers:** Validation Only and the read-only PR validator both use Flutter `3.47.2` and run `flutter pub get --enforce-lockfile`. The PR workflow has `contents: read`, disables checkout credential persistence and cache, and does not write files. Validation Only's formatter commit is explicitly restricted to `lib/` and `test/`; it does not regenerate or stage `pubspec.lock`.
- **Acceptance evidence:** Validation Only #72 / run `45700008025` / job `139507345524` recorded locked dependency resolution PASS on input source `27ac09c5b77401c37f5fdbfd575001bab5ea9544`. The current `main` manifest and lock blobs are byte-identical to those at that tested input SHA, so that specific CI dependency-resolution evidence applies to the same manifest/lock contents. This is **VERIFIED CI** from the recorded run, not a run executed during this Diskusi session.
- **Local validation boundary:** Flutter/Dart executables are unavailable in the current ChatGPT execution container. No local `flutter pub get`, formatter, analyzer or test was run. This interaction's package/constraint/source checks are **STATIC SOURCE CHECK** only.
- **Finding / disposition:** no missing/extra direct package, out-of-range locked direct version, SDK-bound mismatch, non-pub.dev hosted source, absent hosted checksum, or Git/path dependency was found. Rewriting the lockfile would create churn without correcting an evidenced defect. Disposition: **KEEP / VERIFIED**; lockfile remains unchanged.
- **Next file:** `README.md` remains the next inventory entry for the separate repository-wide content audit. The audit remains incomplete; the 12 formatter-only Dart files still require individual content review.

### Formatter-only side effect — 12 Dart files — CONTENT REVIEW PENDING (2026-11-26)

Validation Only #72's formatter gate identified 12 existing files requiring the workflow's locked Dart formatter. The workflow applied formatting, verified the post-format state, passed analyzer and all 219 Flutter tests, and committed the resulting formatter-only patch as `003bccd6e88b38710557df1d352386665491a254` (parent/source tested by run #72: `27ac09c5b77401c37f5fdbfd575001bab5ea9544`). Exact paths:

- `lib/app_settings.dart`
- `lib/floating_monitor.dart`
- `lib/main.dart`
- `lib/usage_statistics.dart`
- `test/connection_scan_coordinator_test.dart`
- `test/device_copy_notification_contract_test.dart`
- `test/firmware_qc_contract_test.dart`
- `test/floating_monitor_layout_contract_test.dart`
- `test/github_actions_workflow_contract_test.dart`
- `test/localization_contract_test.dart`
- `test/usage_statistics_test.dart`
- `test/widget_test.dart`

These files received only the workflow's `dart format` output; this is not their file-level content/dependency/security review or final KEEP/UPGRADE disposition. Their register rows explicitly remain **CONTENT REVIEW PENDING (FORMATTER ONLY)** until each is inspected individually. No semantic modernization is claimed from formatting alone.

## Current disposition

- Inventory coverage: **95/95 existing tracked blobs** at the baseline HEAD above; this register is the 96th file after creation and must be included in subsequent tree snapshots.
- Content review coverage: **not yet complete**. The fact that every path is listed does not mean every file's contents, callers, security or runtime behavior has been reviewed.
- No blanket source/config/workflow/Firmware/BIN/asset update is authorized by this plan.
- The current open source work item remains WP1 in the separate Code workspace. It must not be silently merged with this repository-wide roadmap.
- Refresh the inventory when files are added/removed/renamed; update the row of every file touched; re-check the recursive tree and all references before closing a WP.
