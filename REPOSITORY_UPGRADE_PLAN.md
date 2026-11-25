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
| `CHAT_RULES.md` | Compatibility pointer to canonical operating policy | ACTIVE POLICY POINTER | KEEP / VERIFIED (2026-11-26) |
| `CHAT_TRANSFER_PROMPTS.md` | Three dedicated workspace LOAD + CONTINUE templates | ACTIVE WORKSPACE TEMPLATES | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `CHAT_TRANSFER.md` | Rolling active continuation checkpoint | ACTIVE CODE_FULL CHECKPOINT | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `DESIGN_NOTES.md` | Owner-approved screen-specific visual contracts | ACTIVE DESIGN SUBJECT REFERENCE | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `FIRMWARE_NOTES.md` | Firmware and hardware requirements reference | PROTECTED — OUTSIDE APP-ONLY SCOPE | PROTECTED — NO CHANGE (2026-11-26) |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Firmware source-level architecture and safety reference | PROTECTED — OUTSIDE APP-ONLY SCOPE | PROTECTED — NO CHANGE (2026-11-26) |
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
| `README.md` | Project entrypoint / navigation index | ACTIVE PROJECT INDEX | KEEP / VERIFIED (2026-11-26) |
| `SKILLS_INDEX.md` | Reusable skill and capability catalogue | ACTIVE CAPABILITY INDEX | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
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

### WP0 — `README.md` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `0f6a5e1e1edb7ec8f6898211c5b17022c6666baa`; README blob `f6232cb8685202f43d0b68c06feb5455d86e96fa`. The complete 64-line / 6,557-byte file was inspected.
- **Role and consumers:** root project entrypoint and navigation index. It routes users and repository-aware agents to the canonical Master Prompt, workspace prompts, status/checkpoint, current-state and handover documents, skill index, App/design references, protected Firmware/OTA notes and evidence ledgers. Repository search also confirms the guarded Build App source-archive step explicitly includes `README.md` in the corresponding source ZIP; no release workflow change is included in this review.
- **Link/reference audit:** all 31 Markdown path links in README were resolved against the current recursive tree (142 entries; `truncated=false`); no missing path was found. No external URL dependency was embedded in README. Duplicate links in separate navigation sections are intentional cross-entry points, not broken references.
- **Finding / disposition:** content accurately describes the repository purpose, three isolated workspaces and permissions, current memory/navigation authorities, twelve reusable skills and release boundaries. It does not fork the Master Prompt into a second policy or duplicate product/build chronology. No obsolete path, inaccurate skill count or actionable content defect was found. Rewriting it as part of the App UI redesign would add unrelated churn. Disposition: **KEEP / VERIFIED**.
- **Acceptance evidence:** complete content review and internal-link/path check **PASS — STATIC SOURCE CHECK**. README remained unchanged from the Validation Only #72 tested source; that Flutter validation did not validate Markdown content. No Markdown linter was available or required by this review; no Flutter test, formatter, analyzer, build or screenshot is claimed for README.
- **Scope:** inventory row and this audit record only. `README.md`, source, tests, workflow, assets and package/release configuration remain unchanged. No source ZIP/APK or Release operation was initiated.
- **Next file:** `SKILLS_INDEX.md` (next inventory entry). Continue the remaining file review one path at a time; the 12 formatter-touched Dart files remain pending separate content review.

### WP0 — `SKILLS_INDEX.md` — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `e1e5e1ed08da968f0cedc0bf26e4c52d9f13f84a`; prior index blob `79491279a7720f85bff0940439b94bb4d3343403`. The full 116-line capability/skill index was inspected; updated blob `cd8924f7eebbb815f204a5ae34d517dbcb8ea773`.
- **Role and consumers:** single catalogue for the 12 canonical project skills, 12 GitHub Copilot mirror paths, current product-design references, connected tool families, local engineering environment and task-to-tool boundaries. Search confirms active references from `AGENTS.md`, `README.md`, `MASTER_PROMPT.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_TRANSFER.md`, `CHAT_TRANSFER_PROMPTS.md` and historical `CHANGELOG.md`; their roles remain compatible with the updated index.
- **Skill-library check — STATIC SOURCE CHECK:** current recursive tree lists 12 `.agents/skills/*/SKILL.md` canonical skills and 12 `.github/skills/*/SKILL.md` mirrors. All 12 canonical/mirror blob SHA pairs are equal; no skill file was modified.
- **Capability correction:** this session's available tool catalogue confirms GitHub, Figma, Context7, file/skill, and automation tool families, plus general web product search. It did **not** expose a dedicated Shopee connector. The former Shopee-specific capability row and session claim were replaced with a precise web product-discovery statement; this does not claim Shopee account/listing integration.
- **Environment correction:** live container checks on 2026-11-26 report Git 2.47.3, Python 3.13.5, OpenJDK/Javac 21.0.12.1; `flutter`, `dart`, `gradle`, `adb`, `arduino-cli` and `idf.py` are absent from PATH. The environment heading/date and exact absence boundary were refreshed. Do not infer availability from an older environment snapshot.
- **Finding / disposition:** the skill catalogue and product-design routing remain accurate; no new skill or connector is justified. Updating the current capability/toolchain facts prevents a false implication of Shopee-specific access and stale SDK availability. Disposition: **UPGRADE — CLOSED / READ-BACK VERIFIED**.
- **Acceptance evidence:** full content review, 12/12 mirror-hash comparisons and tool/runtime inventory are **STATIC SOURCE CHECK**. The Markdown file has no Markdown-link destinations requiring path repair; path consumers were searched. No Flutter formatter, analyzer, unit/widget tests, build, or visual/device checks apply to this index; the local Flutter toolchain is unavailable. No CI was started.
- **Scope:** `SKILLS_INDEX.md` and its disposition/record in this inventory only. No skills, source, tests, workflows, dependency files or assets changed; no plugins were installed or external operation started.
- **Next file:** `CHAT_RULES.md` in current tree order; continue WP0 one path at a time. Twelve formatter-touched Dart files remain pending individual review.

### WP0 — `CHAT_RULES.md` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `55ae74be4bc996b2200a4db12ebc6f68cdaa6c69`; file blob `49677fd773ad434c09991ee6ee8c401007c01ebc`. The complete 18-line compatibility pointer was inspected.
- **Role and consumers:** preserves existing repository/chat-transfer links while routing all command permissions and policy to `MASTER_PROMPT.md`. It describes the three dedicated workspaces and directs owners to the three matching prompts in `CHAT_TRANSFER_PROMPTS.md`; it does not create a competing rule source.
- **Reference audit:** repository search confirms current references from `README.md`, `MASTER_PROMPT.md`, `CHAT_TRANSFER_PROMPTS.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `HANDOVER.md`, and the documentation-governance skill pair. Historical references in `CHANGELOG.md` and immutable archives are intentional. The linked `MASTER_PROMPT.md` and `CHAT_TRANSFER_PROMPTS.md` exist in the live tree; no broken path or migration is required.
- **Finding / disposition:** the file clearly labels itself as a compatibility pointer, defers to the canonical operating authority and avoids duplicating authorization or safety rules. It remains useful for legacy links and onboarding. No content change is justified. Disposition: **KEEP / VERIFIED**.
- **Acceptance evidence:** complete content review and repository path/caller search **PASS — STATIC SOURCE CHECK**. No Markdown linter, formatter, Flutter analyzer/test, build or visual check was run or applicable to this pointer; no external operation was initiated.
- **Scope:** register disposition and this record only. `CHAT_RULES.md`, source, tests, config, workflows, assets and release artifacts remain unchanged.
- **Next file:** `CHAT_TRANSFER_PROMPTS.md` in current tree order. Continue the file-by-file WP0 audit; the 12 formatter-touched Dart files remain pending individual content review.

### WP0 — `CHAT_TRANSFER_PROMPTS.md` — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `b3378c99fd95a28be939737af583c74af7b703c0`; prior file blob `a8804f75a20c96e0292d26eabd2ee3ba7ff28cf9`; corrected file blob `ebf275817689ab9a64274e87cb4cb6e5d337b658`. The complete 178-line, three-prompt file was inspected.
- **Role and consumers:** provides the exact three first-message workspace payloads (Diskusi, CODE_FULL and guarded Build App) and onboarding instructions. Direct consumers include `README.md`, `MASTER_PROMPT.md`, `AGENTS.md`, `HANDOVER.md` and `BUILD_NOTES.md`; their current references resolve and retain the intended separation. Current Prompt 2 contains the owner-approved App WP0–WP10 scope and hard exclusions.
- **Finding / repair:** Prompt 2's startup block hard-coded the historical 3/96 audit count and told the next session to start at `README.md`, which became stale once WP0 dispositions advanced. Replaced this with a live-tree/register instruction: recalculate current disposition counts, resume at the first unreviewed live inventory path, and individually review formatter-touched Dart files still pending. This prevents duplicated audit work without changing authorization or the owner-approved work package.
- **Structure / safety check — STATIC SOURCE CHECK:** exactly three prompt headings remain; Prompt 1 remains Diskusi read-only; Prompt 2 remains CODE_FULL with App-only code/docs/tests/static-audit scope and protected exclusions; Prompt 3 remains the separate guarded Build App workspace. The stale 3/96/README startup text is absent and the dynamic live-register instruction is present. No prompt's permissions were widened.
- **Acceptance evidence:** full text review, consumer search and three-prompt/stale-checkpoint assertions **PASS — STATIC SOURCE CHECK**. Current environment command inventory confirms Git 2.47.3, Python 3.13.5 and OpenJDK 21.0.12.1; Flutter, Dart, Gradle and ADB are **NOT FOUND**. No Flutter format/analyzer/test, Android build, visual screenshot or device test was run. No CI or external operation was started.
- **Scope:** one stale startup instruction in Prompt 2 plus its register row/record. No source, tests, dependency files, workflow, Firmware, assets, APK, Release, signing or device files changed.
- **Next file:** `CHAT_TRANSFER.md` (active checkpoint). Refresh its bounded checkpoint for CODE_FULL recovery and then continue WP0 at the next unreviewed path after `CHAT_TRANSFER_PROMPTS.md`.

### WP0 — `CHAT_TRANSFER.md` — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- **Reviewed checkpoint:** prior `main` HEAD `f13924f85350fe187d3e066e9d80c6e76381c7aa`; prior file blob `fd80756a13c93abc49044641a164fde033ca3b5a`; updated file blob `8503075a7842411e5c465114e9956d0682c55ec8`; checkpoint commit `6ef502cd238ce40060390045b779e9f613591a04`. The complete 46-line file and its bounded checkpoint markers were inspected.
- **Role and consumers:** single rolling handoff checkpoint read between `ACTIVE_CHECKPOINT_START/END`; `MASTER_PROMPT.md` defines this boundary and root onboarding/agent documents link to the file. The checkpoint must not duplicate the full policy or historical build ledger.
- **Finding / repair:** prior active content was a Diskusi restore and still said implementation had not started, directed the next session to open a separate Code chat, and retained the obsolete 3/96 / README-first position. Replaced only the bounded active checkpoint with a concise `CODE_FULL` recovery state: current HEAD/tree, seven dispositions, next file, CI/Actions/release evidence, toolchain absence, protected invariants/exclusions and WP1 evidence limits. No archived history or separate build ledger was added.
- **Acceptance evidence:** exact marker pair, new active workspace/state and required continuation fields are verified by file read-back. Result: **PASS — STATIC SOURCE CHECK**. No Markdown linter/formatter or Flutter tests apply to the checkpoint; no local Flutter tests/build/device checks were run.
- **Scope:** bounded checkpoint content plus this register row/record. No source, tests, config, workflows, Firmware, OTA, Firebase, assets or release artifacts changed.
- **Next file:** `PROJECT_STATE.md` (current-only project state summary). Refresh its former “planning only / 3 of 96 / next README” statements against live evidence; then reconcile `HANDOVER.md`.

### WP0 — `DESIGN_NOTES.md` — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `c1417f003ff463850e9ffff9ddf6d9c78b5ed674`; prior design-note blob `ff5b4de94342a713ed14c613fb2732cc7bdd3edc`; corrected blob `a78900bf8bf9119ed3d298ade34d6bb1dad57e31`. The complete 335-line file (including the Build #167 UI baseline, 2026-11-26 full redesign brief, screen contracts and historical accepted designs) was inspected.
- **Role and authority:** canonical record of owner-approved screen-specific layout/interaction contracts and current visual baseline. `PRODUCT_DESIGN_CONSTITUTION.md` owns cross-screen principles; `VISUAL_QUALITY_GATE.md` owns screenshot-based acceptance; `APP_NOTES.md` owns current behavior/data contracts; live source/tests determine actual implementation. The new “Quiet Luxury / Precision Instrument” brief is explicitly not a new brand/font/palette/asset approval and keeps the WP0–WP10 incremental sequence.
- **Consumers and path audit:** repository search verified references from `README.md`, `00_WORK_STATUS.md`, `MASTER_PROMPT.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_TRANSFER.md`, `CHAT_TRANSFER_PROMPTS.md`, `SKILLS_INDEX.md`, `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `APP_PREBUILD_AUDIT.md`, `PRODUCT_DESIGN_CONSTITUTION.md`, `VISUAL_QUALITY_GATE.md`, `BUILD_NOTES.md`, the Flutter/design skills, and historical `CHANGELOG.md`/immutable archive. The file contains one external MDN named-colors reference and no internal Markdown path links. All current referenced canonical files exist in the complete tree (142 entries, `truncated=false`).
- **Finding / repair — Usage Statistics consistency:** the “Usage Statistics density and performance follow-up — current main” paragraph incorrectly said the visible `Observed` row remained and its status still cited Build #162 / 188 tests. The live `lib/usage_statistics.dart` UI source contains no rendered `Observed` label; `test/usage_statistics_test.dart` explicitly asserts `find.text('Observed')` is `findsNothing` (line 1158); `APP_NOTES.md` confirms the current visible summary is Min/Avg/Max only, with Observed / More details / Last sample removed while internal aggregates remain. Corrected the design note to reflect Min/Avg/Max-only presentation, retained analytics aggregates and the current Build #167 / 205-of-205 package suite. The long-duration Android CPU/memory soak and screenshot visual acceptance remain **NOT VERIFIED**.
- **Preserved contracts:** Build #167 Home image remains flex 14, uniform 1.08× right-anchored scale, `BoxFit.contain`, seven 45-dp metrics, transparent square artwork and protected 360-dp DPI transform. EN/ID, Light/Dark, Phosphor, Connection's 40–42 dp legacy controls, 48-dp new target intent, P1/telemetry truth, command/ACK/confirmed state, hardware-coupled Fan/LED/Peltier motion, Usage Statistics schema v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT freshness, explicit gaps, gap-safe decimation and 64+8+1 writer queue remain protected. Floating Monitor stays a native Canvas/WindowManager surface and a Flutter telemetry projection; Firmware Update remains presentation-only.
- **Finding / disposition:** two stale Usage Statistics display/package statements were corrected; no new design tokens, font, palette, asset or layout contract was introduced. Historical design/build records were retained rather than rewritten. Disposition: **UPGRADE — CLOSED / READ-BACK VERIFIED**.
- **Acceptance evidence:** complete file review, consumer search, Markdown link/path inspection, current source/test comparison and exact text read-back **PASS — STATIC SOURCE CHECK**. No Flutter test, formatter, analyzer, Android build, screenshot or device validation was executed for this documentation-only correction; local Flutter/Dart/Gradle/ADB remain unavailable. No CI or external process was triggered.
- **Scope:** `DESIGN_NOTES.md` plus this register row/record only. No App source/test/config/workflow, assets, Firmware, OTA, Firebase, APK, Release, signing or device file changed.
- **Next file:** `FIRMWARE_NOTES.md` in live inventory order. Continue WP0 one file at a time; the 12 formatter-touched Dart/test files remain individually pending content review.

### WP0 — `FIRMWARE_NOTES.md` — PROTECTED / NO CHANGE (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `d868284ab082c3a64b326f6f60a53fe3bb189eed`; document blob `47ca7c0fcfe56dd3a137060357f3b4ea81484899`. Complete 172-line / 28,863-byte contents were reviewed, including the owner field report, BLE identity limitation, pinout, timing/safety contracts, Lock Voltage/Touch requirements, App-to-Firmware telemetry boundaries, OTA restrictions and evidence/incident routing.
- **Role and consumers:** durable Firmware/hardware contract, not an App implementation note. Search confirms consumers/references from `README.md`, `MASTER_PROMPT.md`, `MEMORY_INDEX.md`, `FIRMWARE_TECHNICAL_REFERENCE.md`, `BLE_APP_AUTH.md`, `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`, `VOLTAGE_TRANSITION_MEMORY.md`, the BLE/ESP32 safety skill definitions and App subject references. Historical archive references are intentionally retained. The file contains no Markdown link destinations requiring path repair.
- **Finding / protection:** requirements and status labels explicitly distinguish source implementation, App/Dart hosted CI, owner-reported field use, Firmware compilation/BIN provenance, OTA, and physical device evidence. The latest field report remains clearly **USER-REPORTED** (Firmware V7.2 + App Build #159 as of 2026-11-13); it does not claim Build #167 is installed or prove physical/thermal acceptance. BLE App-only identity stays BLOCKED / NOT IMPLEMENTED and Online OTA's certificate-authentication limitation stays explicit. These are protected hardware/security contracts and are not being rewritten as part of the App UI work.
- **Cross-reference finding (not changed):** the opening baseline sentence still labels blob `140e758e7101cadc3ccc58cc5c52e49534b0032c` as the active Firmware sketch, while the live recursive `main` tree identifies `firmware/JEXFYZ-V7.2.ino` as blob `842e2a3952739001b232a3d9e327c592ff9a6b5a`. The later V7.2 implementation checkpoint in this same document already cites `842e2a...`; several related protected notes also retain the older fingerprint. This is a documentation-pointer discrepancy only; source behavior/version are not inferred from the hash. A correction would touch the protected Firmware/OTA/BLE subject-note set and is outside this App-only authorization, so it is recorded for a separately scoped documentation review.
- **Disposition:** **PROTECTED — NO CHANGE**. No Firmware source, version, sketch filename, technical reference, OTA/BLE security document, Firebase, BIN, Release, flash or device file was edited. Do not treat this as a pass on Firmware behavior or physical safety.
- **Acceptance evidence:** complete content inspection, repository consumer search, current tree/path check and exact live sketch blob comparison **PASS — STATIC SOURCE CHECK** for this audit decision. No Arduino compile, Firmware test, BIN, Firebase, OTA, flashing, NVS power-cycle or physical operation was run or authorized. No App test/build is claimed for this Firmware reference.
- **Next file:** `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` (next inventory path). Continue its review as a protected reference only; do not repair Firmware claims or source fingerprints under this App-only work package.

### WP0 — `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` — PROTECTED / NO CHANGE (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `b5dea79c4b62b4b3100b4cbb134080af99f9ae9e`; technical-reference blob `004923c4638398b11bec5d9136d006f3b33515a0`. The complete 91-line document was inspected.
- **Role and consumers:** canonical source-level Firmware architecture, GPIO/timing/safety, voltage/Peltier transitions, Hotside/Adaptive, Touch/LED/persistence, OTA and evidence reference. It is referenced by `README.md`, `MASTER_PROMPT.md`, `MEMORY_INDEX.md`, `FIRMWARE_NOTES.md`, `BLE_APP_AUTH.md`, `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`, `VOLTAGE_TRANSITION_MEMORY.md`, and the canonical/mirrored ESP32-C3 safety skills. Historical and protected source-link paths remain resolvable; the file has no Markdown link destinations requiring repair.
- **Protected-scope finding:** the document correctly states that Firmware telemetry owns physical state, App ACK does not prove outputs, and source-contract tests do not prove Arduino compilation, BIN provenance, NVS power-cycle, electrical/thermal safety, BLE security or OTA/device behavior. These contracts are outside the owner-approved App-only code work package and were not edited.
- **Discrepancies recorded, not repaired:** the “Current source blob” still identifies `140e758e7101cadc3ccc58cc5c52e49534b0032c`, whereas the live recursive tree identifies the active `firmware/JEXFYZ-V7.2.ino` as `842e2a3952739001b232a3d9e327c592ff9a6b5a`. The note also says the opening sketch comment still says V7.1; the live sketch header now reads “Firmware V7.2 source.” These are documentation/reference drifts, not evidence that the active sketch source/version is wrong. Because the reference is a protected Firmware contract and this workspace has no Firmware-doc repair authorization, leave it unchanged and record the discrepancy for a separately authorized Firmware documentation pass.
- **Disposition:** **PROTECTED — NO CHANGE**. No Firmware source/BIN/version, App source, test, workflow, OTA, Firebase, release, signing, flashing or device file changed.
- **Acceptance evidence:** full document review, current tree/blob identity, live sketch header (first 40 lines), consumer search and path checks **PASS — STATIC SOURCE CHECK** for the protection decision only. No Arduino compile, Firmware tests, BIN generation, OTA, flashing, physical hardware or thermal/electrical check was run or authorized.
- **Next file:** `firmware/JEXFYZ-V7.2.ino` (next inventory entry). Record it as a Firmware-protected source path only; do not perform functional source review, edit, compile or operation in this App-only workspace.

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
