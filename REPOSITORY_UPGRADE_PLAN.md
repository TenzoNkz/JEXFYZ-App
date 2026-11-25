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
| `analysis_options.yaml` | Dart analyzer policy | QUALITY CONFIG — ANALYZER GATE | INVENTORIED — CONTENT REVIEW PENDING |
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
| `lib/app_settings.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/connection_scan_coordinator.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/connection_scan_state.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/floating_monitor.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/jex_animated_glyph.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/main.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `lib/usage_statistics.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | INVENTORIED — CONTENT REVIEW PENDING |
| `MASTER_PROMPT.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `MEMORY_INDEX.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `OTA_PROTECTION.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `OTA_REGRESSION_MEMORY.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `PRODUCT_DESIGN_CONSTITUTION.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `PROJECT_STATE.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `pubspec.lock` | Flutter dependency manifest/lock | DEPENDENCY CONTRACT — REVIEW BEFORE CHANGE | INVENTORIED — CONTENT REVIEW PENDING |
| `pubspec.yaml` | Flutter dependency manifest/lock | DEPENDENCY CONTRACT — REVIEW BEFORE CHANGE | INVENTORIED — CONTENT REVIEW PENDING |
| `README.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `SKILLS_INDEX.md` | Operating governance | CANONICAL GOVERNANCE | INVENTORIED — CONTENT REVIEW PENDING |
| `test/app_protocol_notify_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/connection_scan_coordinator_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/connection_scan_state_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/device_copy_notification_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/firmware_qc_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/firmware_touch_adaptive_sync_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/floating_monitor_layout_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/github_actions_workflow_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/localization_contract_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/support/source_contract_helpers.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/usage_statistics_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `test/widget_test.dart` | Dart test | TEST / REGRESSION | INVENTORIED — CONTENT REVIEW PENDING |
| `VISUAL_QUALITY_GATE.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `VOLTAGE_TRANSITION_MEMORY.md` | Project/configuration file | REVIEW REQUIRED | INVENTORIED — CONTENT REVIEW PENDING |
| `REPOSITORY_UPGRADE_PLAN.md` | Repository-wide upgrade register | Canonical per-file audit register | CREATED — inventory snapshot maintained above |

## Current disposition

- Inventory coverage: **95/95 existing tracked blobs** at the baseline HEAD above; this register is the 96th file after creation and must be included in subsequent tree snapshots.
- Content review coverage: **not yet complete**. The fact that every path is listed does not mean every file's contents, callers, security or runtime behavior has been reviewed.
- No blanket source/config/workflow/Firmware/BIN/asset update is authorized by this plan.
- The current open source work item remains WP1 in the separate Code workspace. It must not be silently merged with this repository-wide roadmap.
- Refresh the inventory when files are added/removed/renamed; update the row of every file touched; re-check the recursive tree and all references before closing a WP.
