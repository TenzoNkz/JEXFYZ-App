## Latest live inventory — Validation Only #223 green; WP1 and Floating Monitor storage/bridge tests verified (2026-11-28)

- Latest validated App test source: `1cd1843a5fe0b635601b895276e15286919075fa`; recursive main tree 168 entries / 122 blobs / 46 trees, `truncated=false`.
- Register reconciliation: the File inventory below contains 122 unique rows for 122 tracked blobs, with no duplicate paths. Path coverage is not proof of full content/architecture review or WP0–WP10 completion.
- Validation Only #223 / run `46042517291` / job `140653549455`, exact test source SHA `1cd1843a5fe0b635601b895276e15286919075fa`, terminal SUCCESS — locked dependencies PASS; formatter **46 files / 0 changed**; analyzer PASS (`--no-fatal-infos`, 129 info-level diagnostics, zero warnings/errors); **306/306 Flutter tests PASS**.
- Storage/bridge coverage: **18 secure-storage mock tests** are verified (14 AppSettingsStore/KnownCoolerStore cases plus four FloatingStore load/save/failure cases); **10 FloatingBridge MethodChannel tests** verify permission, service commands, config/telemetry payloads, runtime state and channel-error handling. #223 validates the entire suite. Production Flutter/native implementation was not changed; real Android keystore, service/WindowManager and OEM behavior remain unverified.
- WP2/WP3: ordered bootstrap, App root, Settings presentation, P1 frame decoder, pure command classification and FIFO ACK-waiter lifecycle remain separated. Dashboard remains the only BLE/GATT/P1/session and authoritative telemetry/command owner.
- WP4: shared geometry, semantic color, typography and shape token foundation exists. Batch 1 compact-control radius and Batch 2 `JexStatisticsTypographyTokens.axisLabel = 10.0` are verified by #213; the latter has three painter call sites and focused source-contract assertions. Similar numeric font sizes on other routes currently map to different component roles; continue classification without globalizing them. One-off telemetry, chart, device and fixed-canvas geometry remains local; screenshot acceptance is open.
- WP5 Batch 1: `lib/dashboard_shared_components.dart` extracts the established Dashboard Card and section heading as presentation-only widgets; 12 Card and 7 heading call sites in Control/Temperature use them. Validation #194 covered the original source; #205 revalidates current main.
- WP5 Batch 2: `lib/dashboard_control_components.dart` extracts `_switchRow`, `_jexToggle` and `_smoothList` into a state-bound presentation extension; Control/Temperature callsites use the helpers. No BLE/GATT/P1/session/command owner moved.
- WP5 Batch 3: `JexDashboardTabTransition` wraps only Dashboard tab content with 210-ms fade + approximately 5.4-dp slide; reduced motion uses a 90-ms fade only. Outgoing subtrees have no pointer/semantics; active subtree remains discoverable during its first frame. A toggle key-ownership bug and related widget tests were corrected. Validation #205 verified the exact source.
- WP0/WP4/WP5–WP10 remaining: full Dashboard/main.dart ownership/content audit; remaining large-module review; cross-route token role classification and justified tokenization; screen-by-screen refinement and screenshot evidence; WP6 Connection/Settings/dialogs; WP7 Usage Statistics architecture/UI; WP8 Floating Monitor lifecycle recovery decision, native integration and visual/device acceptance; WP9 screenshots/goldens/integration/platform evidence; WP10 final file/diff/governance closure.
- Evidence limits: local Flutter/Dart/Gradle/ADB unavailable. Android/Kotlin compile, Android/OEM screenshots/device behavior, SQLite v1→v2 runtime fixture and 1h/6h/24h performance profiles remain NOT RUN. Whole-App visual result remains VISUAL NOT VERIFIED. Build #167 remains the latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged.
- Scope: no Build App/APK/sign/release, Firmware/BIN/P1 wire/security, OTA, Firebase production, signing material, flashing or device operation occurred.

# JE X FYZ / JE Cooler — Repository File-by-File Upgrade Register

Last inventory snapshot: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Purpose and completion rule

This is the single file-level inventory and rolling review register for the canonical repository `TenzoNkz/JEXFYZ-App`. Its purpose is to ensure every tracked file is consciously reviewed and either improved when justified or explicitly retained as verified/protected/immutable.

**"All files reviewed" does not mean "all files modified".** No file may be changed merely to create activity. A file that already meets its contracts must be recorded as `KEEP / VERIFIED`; a protected file must be respected; historical evidence must remain intact. Never mass-rewrite files without a file-level reason and acceptance test.

## Baseline inventory evidence

- Repository / branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Baseline HEAD before adding this register: `c9699c2bf9c4b5843eb28014e34c34fb436d6b15`.
- Recursive tree: 141 entries, 95 blobs, 46 trees; `truncated=false`.
- Extensions: 53 Markdown, 19 Dart, 3 workflow YML, 2 YAML, 1 Gitignore, 3 Gradle, 1 JSON, 1 ProGuard, 2 XML, 4 Kotlin, 3 PNG, 1 properties, 1 Firmware INO and 1 lockfile.
- This inventory is **path-complete, not content-audited**. Except for files explicitly reviewed in a linked work-package note, all rows begin with CONTENT REVIEW PENDING.

## HISTORICAL — live inventory checkpoint after Validation Only #198 (superseded by #205)

- Validated App source: 727f30a0f0cb6bbb14921b4a9ded77b668cc0183; source root tree 2408f2e0c1f0a430ec6d548081fd209c86452a3c; recursive tree 166 entries / 120 blobs / 46 trees, truncated=false.
- Register reconciliation: the File inventory below contains 120 unique rows for 120 tracked blobs, with no duplicate paths. Path coverage is not proof of a full content/architecture review or WP0–WP10 completion.
- Validation Only #198: run 45986589466 / job 140463697552, exact source SHA above, terminal SUCCESS — locked dependencies PASS; Dart formatter 44 files / 0 changed; analyzer PASS (121 information-level diagnostics, zero warnings/errors under --no-fatal-infos); full Flutter tests 281/281 PASS.
- WP1 storage coverage: test/app_settings_store_test.dart adds seven plugin-mock behavior tests for AppSettingsStore load/defaults/save/firmware-notice gating and KnownCoolerStore trim/blank/save/clear. Production storage keys/defaults/schema were not changed. Secure-storage error/failure injection remains open.
- WP2/WP3: ordered bootstrap, App root, Settings presentation, P1 frame decoder, pure command contract and FIFO ACK-waiter lifecycle remain separated. Dashboard remains the only BLE/GATT/P1/session and authoritative telemetry/command owner.
- WP4: shared geometry, semantic color, typography and shape tokens exist; cross-route consumer audit and actual visual acceptance remain open.
- WP5 Batch 1: lib/dashboard_shared_components.dart extracts the established Dashboard Card and section heading as presentation-only widgets; 12 Card and 7 heading call sites in Control/Temperature use them. Widget contract test covers margins, padding, radius, semantic surface/border, shadow and heading typography. No device/session/command state moved; Validation Only #194 verifies the exact source.
- WP5 Batch 2: lib/dashboard_control_components.dart extracts _switchRow, _jexToggle and _smoothList into a state-bound presentation extension; Control and Temperature callsites use these helpers. Widget and Firmware QC source-contract tests read the correct part file. No BLE/GATT/P1/session/command owner or protocol behavior moved; Validation Only #198 verifies the exact source.
- WP0/WP4/WP5–WP10 remaining: full Dashboard/main.dart owner and content audit; remaining large-module review; cross-route semantic-token audit; WP5 screen refinement and visual evidence; WP6 Connection/Settings/dialogs; WP7 Usage Statistics architecture/UI; WP8 Floating Monitor Flutter/native split; WP9 screenshots/goldens/integration/platform evidence; WP10 final file/diff/governance closure.
- Evidence limits: local Flutter/Dart/Gradle/ADB unavailable. Android/Kotlin compile, Android/OEM screenshots/device behavior, SQLite v1→v2 runtime fixture and 1h/6h/24h performance profiles remain NOT RUN. Whole-App visual result remains VISUAL NOT VERIFIED. Build #167 remains the latest published package on immutable source 0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81; current main is not packaged.
- Scope: no Build App/APK/sign/release, Firmware/BIN/P1 wire/security, OTA, Firebase production, signing material, flashing or device operation occurred.

## HISTORICAL — inventory checkpoint after Validation Only #91 (superseded 2026-11-27)

- **Current source/test HEAD:** `a91ce73d6e7cafbc5a6b04af95fa9d4455c04407`; root tree `5616dd76d1ddde85ed4ffdba506bf03f1abbee3a`; recursive inventory **146 entries / 100 blobs / 46 trees**, `truncated=false`.
- The new App modules `lib/home_notify.dart` and `lib/led_controls.dart` are included and have file-level dispositions below. All 100 tracked paths now have explicit dispositions; this is not proof that every content audit or WP0–WP10 implementation gate is complete.
- **Validation Only #91:** run `45873143183` / job `140093397714`, terminal SUCCESS on exact source/test HEAD above. Locked dependencies, formatter precheck/post-check, analyzer and Flutter tests **230/230 PASS**; analyzer emitted 107 info-level diagnostics under `--no-fatal-infos`. Formatter application/commit was skipped because the read-only formatter check was clean.
- **Interim regressions retained:** #88 failed 1/230 because the bilingual phrase scan did not include the newly extracted Home presentation module; #89 added `lib/home_notify.dart` without lowering the threshold and passed 230/230. #90 failed 1/230 because the LED picker Cancel-copy assertion still read `main.dart`; #91 redirected that unchanged assertion to `led_controls.dart` and passed 230/230.
- **Implementation commits:** Home Notification/OTA presentation extraction `ef7186ac2f8350f515d911893556c98f33b2b6bd`; localization scanner correction and #89 validation input `57b217470439be86912f3ef0dd3bf15876d04e8a`; LED controls/preview extraction `461561e24fd25518f06ee51aa86eb1dd341d0967`; LED picker test correction and current HEAD `a91ce73d6e7cafbc5a6b04af95fa9d4455c04407`.
- **Current source blobs:** `lib/main.dart` `71b06b5537ef2f36d1355a2767cbad8141a4c874` (9,735 lines); `lib/led_controls.dart` `e795122f61ca31fc814a9b4b04840332a33c980f` (965 lines); `test/widget_test.dart` `bbb327323abb7d782f4fcf3c847e045acc4d1ebd`; `test/firmware_qc_contract_test.dart` `212424531b0ca0e49b4389985187246eb0cb0cb8`; `test/localization_contract_test.dart` `30e87d63efaecedd74abd2a72db7ed813db0e8d4`.
- Build #167 remains the latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; the latest source/test changes are not in that package. No Build App/APK/sign/Release, Firmware/BIN, Firebase production, OTA, flashing or physical-device operation was performed.
## HISTORICAL — direct-main checkpoint before governance batch (2026-11-27; superseded)

- **Live branch:** `main` at `10cca8e160ebd7f1d25d3af48c2d94b69b4e64a9`; GitHub reported exactly one branch and no active repository rulesets.
- **Recursive tree:** 148 entries / 102 blobs / 46 trees; `truncated=false`. This batch retires the PR-only validator and registers both `lib/jex_animated_icon.dart` and `lib/connection_sheet.dart`.
- **Direct-main CI:** one read-only Validation Only workflow runs on relevant main pushes. It does not apply formatting, upload formatter patches, push bot commits or request write permissions. Guarded Build App remains a separate manual issue/title/token release path.
- **Connection extraction evidence:** source and tests are present. Validation Only #96 ran against earlier SHA `c00b7a81d777bf98e9d57796373a4606b9aaf579`; dependency/formatter/analyzer/test steps passed, but the final summary failed because main advanced before the formatter-only commit. It does not establish a terminal pass for current main.
- Build #167 remains the latest published App package. No App Build/release, Firmware/BIN, Firebase production mutation, OTA, flashing or physical-device operation was performed.

## Latest live inventory — Home NOTIFY validated on current main (2026-11-27)

- **Live main:** `c97a2fdc2698b16339d3f03ff04d992f2a0e7848`; root tree `0fb0dc18806ca564ea937964eb9ad77dae486e3c`; 147 entries / 101 blobs / 46 trees; `truncated=false`.
- **Branch/ruleset:** GitHub returned exactly one branch (`main`) and zero active repository rulesets. No secondary branches or PRs; all project changes commit directly to `main`.
- **Register:** File inventory contains 101 unique path rows for all 101 live blobs; no missing/stale/duplicate path.
- **Validation Only:** run `45884911511` / job `140133094930`, exact source/test SHA `c97a2fdc2698b16339d3f03ff04d992f2a0e7848`, terminal SUCCESS. Locked dependency resolution, read-only formatter, analyzer and Flutter tests **233/233 PASS**; final summary SUCCESS.
- **CI shape:** main-only and read-only (`contents: read`, checkout credentials disabled, no formatter mutation or bot commit). PR validator removed. Guarded Build App workflow unchanged.
- **Home NOTIFY:** `lib/home_notify.dart` contains stateless `HomeNotifyCard` with fixed 44-dp layout. Dashboard supplies final state/copy/theme/error/warning/foreground values and retains safety/HOT-limit decisions. Tests cover disconnected and warning renders.
- **Other presentation boundaries:** `lib/connection_sheet.dart`, `lib/jex_animated_icon.dart` and `lib/led_controls.dart` are present. Dashboard retains scanner/GATT/P1/session authority.
- Build #167 remains latest published App package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`. Current main source is not released. No Build App/APK/sign/release, Firmware/BIN, Firebase production, OTA, flashing or device operation occurred.


## HISTORICAL — WP3 P1 command contract extraction and clean regression formatting; superseded by Validation Only #158 (2026-11-27)

- **Live source/test checkpoint:** `main` `0448d03c39536c57ad7e8c2d36718d525d2d60fb`; recursive tree `0223c26690013fe45ec3ac521b68642f5177b7fd`, **157 entries / 111 blobs / 46 trees**, `truncated=false`. The live file register contains **111/111 unique tracked blob dispositions**; all seven paths added since the 104-blob checkpoint are now recorded.
- **Validation state:** Validation Only #148 / run `45943879592` is currently IN_PROGRESS on exact source/test SHA `0448d03c39536c57ad7e8c2d36718d525d2d60fb`. Do not mark the current P1 command-contract tests VERIFIED CI until this run is terminal.
- **Prior green evidence:** Validation Only #142 / run `45942130255`, exact SHA `03c6abe7fef1fe785ad57c8d028f0025527511f9`, terminal SUCCESS — locked dependencies, read-only formatter (33 files / 0 changed), analyzer, and **249/249 Flutter tests**. It covers the App root shell, base layout/semantic tokens, P1 frame decoder and its tests, Temperature accessibility regression, bootstrap and extracted Settings pages. This is hosted Flutter/Dart evidence, not Android/Kotlin compilation or screenshots.
- **P1 framing boundary:** `lib/p1_frame_decoder.dart` owns only a partial receive buffer and frame boundaries; Dashboard still parses ACKs, commits snapshots and gates SYNC/SYNC_READY/session readiness. The decoder is reset on a new Dashboard connection session. Existing newline framing, atomic SYNC ordering, incomplete-frame blocking and 16,000-character overflow behavior are retained and covered by pure tests.
- **P1 command boundary:** `lib/p1_command_contract.dart` contains pure classification only: command→ACK item, output command→expected telemetry, GATT write-response policy and ACK-success vocabulary. Dashboard still owns BLE/GATT, serialized writes, command transaction sequencing, ACK waiters, SYNC, telemetry mutation and physical-output confirmation. No P1 wire value or Firmware source changed.
- **Regression history:** #143/#144 exposed stale source-test references and an incorrect MapEntry/ACK expected-value table; #145 confirmed analyzer PASS and **254/254 tests PASS**, but formatter was not clean. #147 confirmed analyzer PASS and **254/254 tests PASS**, formatter detected two changed tests. Exact Dart formatter output was applied to `test/p1_command_contract_test.dart`, `test/firmware_qc_contract_test.dart` and `test/widget_test.dart`; the temporary capture probe was removed in commit `0448d03c39536c57ad7e8c2d36718d525d2d60fb`.
- **Known remaining scope:** Dashboard is still a 6,500-line screen/state owner; typed session state, one adapter/controller boundary, ACK waiter lifecycle, telemetry projection, screen presentation extraction and WP4–WP10 remain open. Whole-App visual acceptance remains **VISUAL NOT VERIFIED**; Android/Kotlin build, real screenshots/OEM behavior, SQLite v1→v2 runtime fixture and 1h/6h/24h performance profiling are NOT RUN.
- **Implementation commits:** P1 command classification `6a94513e161cc5751bce3559176b09754a63e4ca`; test source-contract relocation/fixes `344eab583e01e0074847ec8995c3ed2c950b72ca`, `d7664d03d2513c723ffe6c02f2ec3be47bb022b2`; formatter/diagnostic follow-up `1ca028aceb0479c33a9a7c4688972afbc4bb244b`, `3629b7cb9fde3455071d37182fcbe0aabcb10bf2`; probe removal and final formatting `0448d03c39536c57ad7e8c2d36718d525d2d60fb`.
- **Release boundary:** Build #167 remains the latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/APK/signing/Release, Firmware/BIN, Firebase production, OTA, flashing or physical device operation occurred.

## Latest live inventory — CODE_FULL WP2 bootstrap and Settings extraction (2026-11-27)

- **main:** `56445f0919672e34a7cabb069066228de0c3ac23`; root tree `f602e0f29bc6fccc0e9c62d1bcdd01478961e03d`; recursive tree 150 entries / 104 blobs / 46 trees; `truncated=false`.
- **Path reconciliation:** 104 unique rows cover all 104 tracked blobs; no missing, duplicate or stale paths after the three additions.
- **Added paths:** `lib/app_bootstrap.dart` isolates startup orchestration; `lib/settings_pages.dart` contains Settings presentation as a part of `floating_monitor.dart`; `test/app_bootstrap_test.dart` covers five startup gate/order/failure paths.
- **Validation Only:** #116 passed locked dependencies, analyzer and 239/239 Flutter tests but failed only the read-only formatter gate. Current #118 / run `45919092056` / job `140245350553` validates the exact current code source `4c5feb51c8777b0576d0ac11f3fafb921db91b38`; terminal result pending.

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
| WP6 | Main-only read-only Validation Only CI and direct-main governance; no PR/branch workflow | Least privilege, pinned actions, no unintended write/publish path |
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

Keep the three authorization workspaces separate. All changes commit directly to `main`; do not create secondary branches or PRs. The shared `WORKSPACE` marker records the selected mode.

## Fail-closed gates

- G0 — session/workspace, current main HEAD/tree, direct-main policy and external-operation preflight.
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
- At the 2026-11-26 Diskusi handoff: **17/96 blob dispositions** are recorded. `lib/floating_monitor.dart` is now UPGRADE APPROVED after a full static source/caller/bridge/test review; source implementation remains in the separate Eksekusi Code workspace. Eleven of the 12 formatter-touched Dart/test files still require individual content review. The next unreviewed inventory path is `lib/jex_animated_glyph.dart`.
- In the Code workspace, first reconcile live HEAD/tree/status, then resume WP0 and WP1. Keep the App-only scope and protected path exclusions in the active plan; Firmware/BIN, BLE protocol/security changes, OTA, Firebase production, signing, package/release, flashing and device operation are not authorized by this register or owner UI request.

## File inventory

| Path | File class | Guard / authority | Current review state |
|---|---|---|---|
| `.agents/skills/ble-p1-protocol-audit/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/code-review/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/documentation-memory-governance/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/esp32c3-firmware-safety/SKILL.md` | Canonical agent skill | CANONICAL SKILL | PROTECTED — NO CHANGE (2026-11-26) |
| `.agents/skills/flutter-app-engineering/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/flutter-quality-and-regression/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/github-actions-triage/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/hardware-power-thermal-analysis/SKILL.md` | Canonical agent skill | CANONICAL SKILL | PROTECTED — NO CHANGE (2026-11-26) |
| `.agents/skills/ota-and-release-integrity/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/product-design-and-visual-quality/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/repository-forensics/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.agents/skills/technical-research-and-second-opinion/SKILL.md` | Canonical agent skill | CANONICAL SKILL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/ble-p1-protocol-audit/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/code-review/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/documentation-memory-governance/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/esp32c3-firmware-safety/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | PROTECTED — NO CHANGE (2026-11-26) |
| `.github/skills/flutter-app-engineering/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/flutter-quality-and-regression/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/github-actions-triage/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/hardware-power-thermal-analysis/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | PROTECTED — NO CHANGE (2026-11-26) |
| `.github/skills/ota-and-release-integrity/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/product-design-and-visual-quality/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/repository-forensics/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/skills/technical-research-and-second-opinion/SKILL.md` | Copilot skill mirror | MIRROR — MUST MATCH CANONICAL | KEEP / VERIFIED (2026-11-26) |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Guarded release workflow | WORKFLOW — SECURITY / SCOPE GATED | PROTECTED — NO CHANGE (2026-11-26) |
| `.github/workflows/jexfyz-app-validation.yml` | Main-only read-only Validation Only workflow | WORKFLOW — LEAST PRIVILEGE / CI GATE | UPGRADE / VERIFIED CI #187 — MAIN-ONLY READ-ONLY VALIDATION; ON-FAILURE FORMAT DIAGNOSTIC |
| `.gitignore` | Repository ignore policy | REPOSITORY CONFIG | KEEP / VERIFIED (2026-11-26) |
| `00_WORK_STATUS.md` | Session continuity | ACTIVE STATUS / CHECKPOINT | UPGRADE / CURRENT — THIS CHAT IS CODE_FULL; VALIDATION ONLY #187 SUCCESS |
| `AGENTS.md` | Operating governance | CANONICAL GOVERNANCE | KEEP / VERIFIED (2026-11-26) |
| `analysis_options.yaml` | Dart analyzer policy | QUALITY CONFIG — ANALYZER GATE | KEEP / VERIFIED — 2026-11-26 (WP1) |
| `android/app/build.gradle` | Android build configuration | BUILD CONFIG — COMPATIBILITY GATED | KEEP / VERIFIED (2026-11-26) |
| `android/app/google-services.json` | Firebase Android config | PROTECTED — SENSITIVE CONFIGURATION | PROTECTED — NO CHANGE (METADATA ONLY; CONTENT NOT OPENED) |
| `android/app/proguard-rules.pro` | Android shrinker rules | ANDROID CONFIG — PLATFORM REGRESSION | KEEP / VERIFIED (2026-11-26) |
| `android/app/src/main/AndroidManifest.xml` | Android manifest/resource/security config | ANDROID CONFIG — PLATFORM REGRESSION | KEEP / VERIFIED (2026-11-26) |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | KEEP / VERIFIED (2026-11-26) |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | KEEP / VERIFIED (2026-11-26) |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | KEEP / VERIFIED (2026-11-26) |
| `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt` | Android native source | ANDROID NATIVE — CODE AUTHORIZATION | KEEP / VERIFIED (2026-11-26) |
| `android/app/src/main/res/drawable-nodpi/jexfyzicon.png` | Binary visual asset | BINARY ASSET — VISUAL / INTEGRITY REVIEW | PROTECTED — NO CHANGE / OPAQUE-RGB TRANSPARENCY MISMATCH; OWNER VISUAL REVIEW REQUIRED (2026-11-26) |
| `android/app/src/main/res/drawable/ic_notification.xml` | Android notification small icon vector | ANDROID RESOURCE — NOTIFICATION BRANDING | KEEP / VERIFIED (2026-11-26) |
| `android/build.gradle` | Android root build configuration | BUILD CONFIG — COMPATIBILITY GATED | KEEP / VERIFIED (same blob as Build #167; 2026-11-26) |
| `android/gradle.properties` | Android Gradle properties | BUILD CONFIG — COMPATIBILITY GATED | KEEP / VERIFIED (same blob as Build #167; 2026-11-26) |
| `android/settings.gradle` | Android plugin/bootstrap configuration | BUILD CONFIG — COMPATIBILITY GATED | KEEP / VERIFIED (same blob as Build #167; KGP matrix caveat recorded; 2026-11-26) |
| `APP_BUILD_REPORT.md` | Append-only evidence ledger | APPEND-ONLY / NO REWRITE | APPEND-ONLY / READ-ONLY / REVIEWED (2026-11-26) |
| `APP_NOTES.md` | App behavior and UI contract reference | APP NOTES — CURRENT + HISTORICAL SNAPSHOTS | UPGRADE / CURRENT — MAIN 1b6b38b; WP1 STORAGE TESTS AND WP5 PRESENTATION PARTS |
| `APP_PREBUILD_AUDIT.md` | Current App rework and acceptance plan | APP PREBUILD AUDIT — WP0–WP10 AUTHORITY | UPGRADE / CURRENT — SOURCE 727f30a; #198 GREEN; 120/120 PATHS; WP0/WP4/WP5–WP10 OPEN |
| `archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md` | Immutable archive | IMMUTABLE / HISTORICAL | IMMUTABLE / HISTORICAL / REVIEWED (2026-11-26) |
| `archive/CHAT_TRANSFER_PRE_COMPACTION_2026-11-15.md` | Immutable archive | IMMUTABLE / HISTORICAL | IMMUTABLE / HISTORICAL / REVIEWED (2026-11-26; superseded) |
| `archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md` | Immutable archive | IMMUTABLE / HISTORICAL | IMMUTABLE / HISTORICAL / REVIEWED (2026-11-26; never current truth) |
| `archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md` | Immutable archive | IMMUTABLE / HISTORICAL | IMMUTABLE / HISTORICAL / REVIEWED (2026-11-26; never current truth) |
| `assets/jexfyzcooler.png` | Binary visual asset | BINARY ASSET — VISUAL / INTEGRITY REVIEW | PROTECTED / NO CHANGE — BINARY VISUAL REVIEW BLOCKED (bytes unavailable in Code workspace) |
| `assets/jexfyzicon.png` | Binary visual asset | BINARY ASSET — VISUAL / INTEGRITY REVIEW | PROTECTED / NO CHANGE — OPAQUE RGB / TRANSPARENCY MISMATCH; OWNER REVIEW |
| `BLE_APP_AUTH.md` | Project/configuration file | REVIEW REQUIRED | BLOCKED / PROTECTED — REQUIRES FIRMWARE + TRUSTED BACKEND SECURITY WORK |
| `BUILD_NOTES.md` | Project/configuration file | REVIEW REQUIRED | KEEP / VERIFIED — BUILD #167 HISTORICAL; NO CURRENT BUILD |
| `CHANGELOG.md` | Append-only evidence ledger | APPEND-ONLY / NO REWRITE | APPEND-ONLY / UPDATED — CLEAR HISTORY P1 FRESHNESS FIX (#82) |
| `CHAT_RULES.md` | Compatibility pointer to canonical operating policy | ACTIVE POLICY POINTER | KEEP / VERIFIED (2026-11-26) |
| `CHAT_TRANSFER_PROMPTS.md` | Three dedicated workspace LOAD + CONTINUE templates | ACTIVE WORKSPACE TEMPLATES | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `CHAT_TRANSFER.md` | Rolling active continuation checkpoint | ACTIVE CODE_FULL CHECKPOINT | UPGRADE / CURRENT — #198 GREEN; ACTIVE CODE_FULL CHECKPOINT READ-BACK VERIFIED |
| `DESIGN_NOTES.md` | Owner-approved screen-specific visual contracts | ACTIVE DESIGN SUBJECT REFERENCE | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `FIRMWARE_NOTES.md` | Firmware and hardware requirements reference | PROTECTED — OUTSIDE APP-ONLY SCOPE | PROTECTED — NO CHANGE (2026-11-26) |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Firmware source-level architecture and safety reference | PROTECTED — OUTSIDE APP-ONLY SCOPE | PROTECTED — NO CHANGE (2026-11-26) |
| `firmware/JEXFYZ-V7.2.ino` | Active versioned Firmware source | PROTECTED — EXPLICIT FIRMWARE AUTHORIZATION REQUIRED | PROTECTED — NO CHANGE (2026-11-26) |
| `HANDOVER.md` | Immediate next-action handover | ACTIVE CURRENT HANDOVER | UPGRADE / CURRENT — MAIN 1b6b38b; #187 GREEN; NEXT DASHBOARD/WP4 AUDIT |
| `lib/app_bootstrap.dart` | Flutter App source — ordered startup/security/Firebase/App Check orchestration | APP SOURCE — WP2 / APP BOOTSTRAP | UPGRADE / VERIFIED CI #142 — FIVE STARTUP ORDER/FAILURE TESTS; OFFICIAL GATE REMAINS FIRST |
| `lib/app_root.dart` | Flutter App root composition; receives the Dashboard widget from the entry point | APP SOURCE — WP2 / APP ROOT SHELL | UPGRADE / VERIFIED CI #142 — INJECTED DASHBOARD, SHARED THEME/LOCALE; NO SECOND BLE OWNER |
| `lib/app_security.dart` | Flutter App security/platform adapter | APP SOURCE — CODE AUTHORIZATION | UPGRADE / CLOSED — OFFICIAL-BUILD FAIL-CLOSED ADAPTER (#87) |
| `lib/app_settings.dart` | Flutter App source — persisted App preferences, localization and shared themes | APP SOURCE — WP4 / THEME + SETTINGS PRESENTATION | UPGRADE / TEST SUPPORT VERIFIED CI #187 — STORE BEHAVIOR COVERED; FAILURE INJECTION AND FULL-FILE REVIEW OPEN |
| `lib/connection_scan_coordinator.dart` | Flutter App source — process-wide BLE scanner ownership coordinator | APP SOURCE — TIER 1 / CONCURRENCY & LIFECYCLE CONTRACT | KEEP / VERIFIED (2026-11-26) |
| `lib/connection_scan_state.dart` | Flutter App source — Connection empty-state and device-name presentation mapping | APP SOURCE — TIER 2 / PRESENTATION STATE CONTRACT | KEEP / VERIFIED (2026-11-26) |
| `lib/connection_sheet.dart` | Flutter App source — manual Connection sheet UI and OS status lifecycle; BLE orchestration injected | APP SOURCE — TIER 2 / CONNECTION PRESENTATION | UPGRADE / CLOSED — PRESENTATION EXTRACTION; INCLUDED IN VALIDATION ONLY #458849 (233/233) |
| `lib/dashboard_control_tabs.dart` | Flutter App Dart library part — Dashboard Voltage, Control, Adaptive and LED presentation builders | APP SOURCE — WP5 PRESENTATION ONLY; Dashboard retains command/BLE/GATT/P1/session authority | UPGRADE / VERIFIED CI #205 — CONTROL ROW HELPERS + TAB TRANSITION CONSUMER; SCREEN/DESIGN REVIEW OPEN |
| `lib/dashboard_shared_components.dart` | Flutter App shared presentation widgets — Dashboard Card, section heading and keyed tab-content transition; no device/session state or commands | APP SOURCE — WP5 SHARED PRESENTATION ONLY; NO BLE/GATT/P1/SESSION OWNER | UPGRADE / VERIFIED CI #205 — WIDGET CONTRACT + REDUCED-MOTION TAB TRANSITION; SCREENSHOT REVIEW OPEN |
| `lib/dashboard_control_components.dart` | Flutter App library part — state-bound Dashboard control-row, toggle and smooth-list presentation extension; no independent device/session owner | APP SOURCE — WP5 PRESENTATION ONLY; Dashboard retains all BLE/GATT/P1/session/telemetry/command state | UPGRADE / VERIFIED CI #205 — HELPER + UNIQUE TOGGLE KEY OWNERSHIP; VISUAL REVIEW OPEN |
| `lib/dashboard_home_tab.dart` | Flutter App Dart library part — Dashboard Home presentation builder | APP SOURCE — WP5 HOME PRESENTATION ONLY; Dashboard retains telemetry/notification/BLE/P1 authority | UPGRADE / VERIFIED CI #187 — PRESENTATION PART; FINAL SCREEN/DESIGN REVIEW OPEN |
| `lib/dashboard_temperature_tab.dart` | Flutter App Dart library part — Dashboard Temperature presentation builder | APP SOURCE — WP5 TEMPERATURE PRESENTATION ONLY; Dashboard retains command/session authority | UPGRADE / VERIFIED CI #198 — SHARED HELPERS; ACCESSIBILITY/DESIGN REVIEW OPEN |
| `lib/floating_monitor.dart` | Flutter App source — Floating Monitor config/store/bridge/runtime and native telemetry projection | APP SOURCE — TIER 2 / FLOATING MONITOR BRIDGE + PRESENTATION | UPGRADE IN PROGRESS — SETTINGS PAGES EXTRACTED; CONFIG/BRIDGE/NATIVE LIFECYCLE SEPARATION OPEN |
| `lib/home_notify.dart` | Flutter App source — localized Home/OTA copy helpers and stateless fixed 44-dp HomeNotifyCard | APP SOURCE — TIER 2 / PRESENTATION CONTRACT | UPGRADE / CLOSED — DASHBOARD-OWNED STATUS ADAPTER; VALIDATION ONLY #458849 (233/233) |
| `lib/jex_animated_glyph.dart` | Flutter App source | APP SOURCE — CODE AUTHORIZATION | KEEP / VERIFIED — STATELESS STATIC ICON |
| `lib/jex_animated_icon.dart` | Flutter App source — animated state indicators and glyph painters | APP SOURCE — TIER 2 / PRESENTATION CONTRACT | UPGRADE / CLOSED — PRESENTATION-ONLY MODULE; CURRENT MAIN VALIDATED IN #458849 (233/233) |
| `lib/jex_design_tokens.dart` | Flutter App shared layout, semantic color, typography and shape tokens | APP SOURCE — WP4 / DESIGN SYSTEM FOUNDATION | UPGRADE / AUDIT IN PROGRESS — FOUNDATION + COMPACT-CONTROL RADIUS + STATISTICS AXIS TOKEN VERIFIED BY #213; CROSS-ROUTE ROLE CLASSIFICATION OPEN |
| `lib/led_controls.dart` | Flutter App source — LED mode/color/phase preview and picker presentation | APP SOURCE — TIER 2 / LED PRESENTATION CONTRACT | UPGRADE / CLOSED / READ-BACK VERIFIED — EXTRACTED FROM `main.dart`; VALIDATION ONLY #91 (2026-11-27) |
| `lib/main.dart` | Flutter App source — App entry and Dashboard sole BLE/GATT/P1/session owner | APP SOURCE — TIER 1 / SESSION OWNERSHIP | UPGRADE IN PROGRESS — HOME/CONTROL/TEMPERATURE PARTS + SHARED HELPERS + WP5 TAB TRANSITION WRAPPER; SOLE BLE/GATT/P1/SESSION/TELEMETRY OWNER; FULL CONTENT AUDIT OPEN |
| `lib/p1_ack_waiters.dart` | Pure per-item FIFO P1 ACK waiter coordinator; registration, timeout, exact cancellation and bulk completion only | APP SOURCE — WP3 / ACK WAITER LIFECYCLE; NO BLE/GATT OR SESSION OWNER | UPGRADE / VERIFIED CI #155 + #158 — FIVE LIFECYCLE TESTS; DASHBOARD RETAINS TRANSPORT/ACK DISPATCH/SESSION AUTHORITY |
| `lib/p1_command_contract.dart` | Pure P1 command classification — ACK item, expected telemetry, write-response policy and ACK success vocabulary | APP SOURCE — WP3 / PURE COMMAND CONTRACT; NO TRANSPORT OR SESSION OWNER | UPGRADE / VERIFIED CI #158 — DASHBOARD RETAINS WRITE/ACK/TELEMETRY SEQUENCING |
| `lib/p1_frame_decoder.dart` | Pure P1 stream framing and bounded partial-buffer decoder | APP SOURCE — WP3 / FRAME DECODER ONLY | UPGRADE / VERIFIED CI #142 — FRAME ORDER, SPLIT SYNC, OVERFLOW AND SESSION CLEAR TESTS PASS |
| `lib/settings_pages.dart` | Flutter App library part — Settings root, navigation and preference subpages | APP SOURCE — WP2 / WP4 SETTINGS PRESENTATION | UPGRADE / VERIFIED CI #158 — SEMANTIC SURFACE/FOREGROUND/OUTLINE TOKENS; STORAGE KEYS UNCHANGED; VISUAL ACCEPTANCE OPEN |
| `lib/usage_statistics.dart` | Usage Statistics storage/analytics/chart presentation; HOT freshness and queue ownership | APP SOURCE — WP4/WP7 / USAGE STATISTICS | UPGRADE / IN PROGRESS — CLEAR-HISTORY HOT-FRESHNESS FIX RETAINED; WP4 AXIS TOKEN VERIFIED BY #213; CURRENT FULL-FILE/PERFORMANCE EVIDENCE OPEN |
| `MASTER_PROMPT.md` | Operating governance | CANONICAL GOVERNANCE | UPGRADE / REVIEWED — FULL-CYCLE EKSEKUSI CODE POLICY |
| `MEMORY_INDEX.md` | Operating governance | CANONICAL GOVERNANCE | UPGRADE / CURRENT — 119-PATH INVENTORY AND #194 EVIDENCE RECONCILED |
| `OTA_PROTECTION.md` | Project/configuration file | REVIEW REQUIRED | PROTECTED / REVIEWED — NO TRANSPORT CHANGES |
| `OTA_REGRESSION_MEMORY.md` | Project/configuration file | REVIEW REQUIRED | PROTECTED / REVIEWED — HISTORICAL SECURITY TRADE-OFF |
| `PRODUCT_DESIGN_CONSTITUTION.md` | Project/configuration file | REVIEW REQUIRED | KEEP / VERIFIED — EXISTING BRAND / DESIGN AUTHORITY |
| `PROJECT_STATE.md` | Current-only product/source/release/validation truth | CANONICAL CURRENT STATE | UPGRADE / CURRENT — MAIN 1b6b38b; VALIDATION ONLY #187 280/280 |
| `pubspec.lock` | Flutter dependency manifest/lock | DEPENDENCY CONTRACT — REVIEW BEFORE CHANGE | KEEP / VERIFIED (2026-11-26) |
| `pubspec.yaml` | Flutter dependency manifest/lock | DEPENDENCY CONTRACT — REVIEW BEFORE CHANGE | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `README.md` | Project entrypoint / navigation index | ACTIVE PROJECT INDEX | KEEP / VERIFIED (2026-11-26) |
| `REPOSITORY_UPGRADE_PLAN.md` | Repository-wide upgrade register | Canonical per-file audit register | UPGRADE / CURRENT — 118/118 LIVE PATHS; CONTENT REVIEW REMAINS WP-BASED |
| `SKILLS_INDEX.md` | Reusable skill and capability catalogue | ACTIVE CAPABILITY INDEX | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `test/app_bootstrap_test.dart` | Dart test | TEST / REGRESSION | UPGRADE / VERIFIED CI #142 — OFFICIAL GATE, STARTUP ORDER AND CLOUD-FAILURE BEHAVIOR |
| `test/app_protocol_notify_contract_test.dart` | Dart test | TEST / REGRESSION | KEEP / VERIFIED — P1 / NOTIFICATION SOURCE CONTRACT |
| `test/app_security_test.dart` | Dart test | TEST / REGRESSION | UPGRADE / CLOSED — TRUE/FALSE/NULL/EXCEPTION CHANNEL CONTRACT (#87) |
| `test/app_settings_model_test.dart` | Pure AppSettings value-model JSON/default/fallback/copy regression tests | TEST / WP1 PREFERENCES MODEL | UPGRADE / VERIFIED CI #187 — 11 PURE MODEL/JSON/FALLBACK/PALETTE TESTS |
| `test/app_settings_store_test.dart` | Flutter plugin-mock behavioral regression tests for AppSettingsStore and KnownCoolerStore | TEST / WP1 PERSISTENCE REGRESSION | UPGRADE / VERIFIED CI #217 — 14 MOCK-STORAGE TESTS (7 NORMAL + 7 FAILURE-INJECTION) |
| `test/connection_scan_coordinator_test.dart` | Dart test | TEST / REGRESSION | UPGRADE / CLOSED — PASSIVE REDISCOVERY ERROR CONSUMPTION TEST (#85) |
| `test/connection_scan_state_test.dart` | Dart unit tests for Connection scan-state precedence and advertised/platform name trimming | TEST / WP1 CONNECTION REGRESSION | UPGRADE / VERIFIED CI #166 — PRIORITY + NAME NORMALIZATION |
| `test/device_copy_notification_contract_test.dart` | Dart test | TEST / REGRESSION | UPGRADE — CLOSED / READ-BACK VERIFIED (2026-11-26) |
| `test/firmware_qc_contract_test.dart` | Dart test | TEST / REGRESSION | UPGRADE / PENDING VALIDATION ONLY #148 — LOCK VOLTAGE CONTRACT TARGETS SETTINGS MODULE; P1 EXPECTATIONS FOLLOW COMMAND CONTRACT |
| `test/firmware_touch_adaptive_sync_test.dart` | Dart test | TEST / REGRESSION | KEEP / VERIFIED — TOUCH / ADAPTIVE SOURCE CONTRACT |
| `test/floating_monitor_layout_contract_test.dart` | Dart test | TEST / REGRESSION | UPGRADE / VERIFIED CI #158 — SETTINGS TOKEN/SOURCE CONTRACT UPDATED; FULL-FILE REVIEW OPEN |
| `test/floating_monitor_store_test.dart` | FloatingStore schema-v2 round-trip/default/read-failure/write-failure regression | TEST / WP8 PERSISTENCE | UPGRADE / VERIFIED CI #220 — 4 SECURE-STORAGE MOCK TESTS |
| `test/floating_monitor_bridge_test.dart` | FloatingBridge MethodChannel permission/start/stop/config/telemetry/runtime/error contract | TEST / WP8 NATIVE BRIDGE | UPGRADE / VERIFIED CI #223 — 10 CHANNEL TESTS |
| `test/github_actions_workflow_contract_test.dart` | Dart test — guarded release and main-only CI contracts | TEST / REGRESSION | UPGRADE / VERIFIED CI #458849 — 233/233; main-only read-only validation and guarded release contracts PASS |
| `test/localization_contract_test.dart` | Dart test | TEST / REGRESSION | UPGRADE / VERIFIED CI #89 — bilingual phrase scan includes extracted `home_notify.dart`; threshold retained |
| `test/p1_ack_waiters_test.dart` | Dart unit tests for per-item FIFO ACK waiter lifecycle | TEST / WP3 ACK WAITER REGRESSION | UPGRADE / VERIFIED CI #155 + #158 — FIFO ISOLATION, EXACT CANCELLATION, TIMEOUT, DISCONNECT AND DISPOSAL |
| `test/p1_command_contract_test.dart` | Dart regression tests for exact P1 command classification contracts | TEST / WP3 P1 REGRESSION | UPGRADE / VERIFIED CI #158 — ACK, TELEMETRY EXPECTATION, GATT RESPONSE POLICY AND SUCCESS VOCABULARY |
| `test/p1_frame_decoder_test.dart` | Dart unit tests for pure P1 stream framing | TEST / WP3 P1 REGRESSION | UPGRADE / VERIFIED CI #142 — SPLIT/ATOMIC FRAMES, ORDER, OVERFLOW AND CLEAR |
| `test/support/source_contract_helpers.dart` | Dart test | TEST / REGRESSION | KEEP / VERIFIED — SOURCE ASSERTION NORMALIZATION |
| `test/temperature_accessibility_test.dart` | Flutter semantics/widget test for Temperature limit action labels and handles | TEST / ACCESSIBILITY REGRESSION | UPGRADE / VERIFIED CI #205 — ACTIVE TAB SEMANTICS DURING FADE; FULL SUITE 285/285 |
| `test/usage_statistics_test.dart` | Usage Statistics unit/widget/source-contract coverage | TEST / REGRESSION | UPGRADE / VERIFIED CI #213 — AXIS TOKEN THREE-CALLOUT CONTRACT + HOT-FRESHNESS REGRESSION; FULL-CURRENT-FILE REVIEW OPEN |
| `test/widget_test.dart` | Dart widget/source-contract tests | TEST / REGRESSION | UPGRADE / VERIFIED CI #213 — DESIGN TOKEN/SCREEN REGRESSIONS INCLUDED IN 285/285 SUITE; FULL-FILE REVIEW OPEN |
| `VISUAL_QUALITY_GATE.md` | Project/configuration file | REVIEW REQUIRED | KEEP / VERIFIED — ACTUAL SCREENSHOTS STILL REQUIRED |
| `VOLTAGE_TRANSITION_MEMORY.md` | Project/configuration file | REVIEW REQUIRED | PROTECTED / REVIEWED — FIRMWARE-OWNED RAIL / SAFETY CONTRACT |

## Content review records

### WP0/WP6 — direct-main recovery and read-only Validation Only — 2026-11-27

- **Owner decision:** GitHub state is one branch (`main`) and zero repository rulesets. No secondary branches or PRs; all changes commit directly to main with expected-HEAD protection.
- **Workflow:** Validation Only triggers on relevant main pushes, has `contents: read`, disables persisted checkout credentials, checks formatting read-only, analyzes and runs the full Flutter suite. It never writes formatter output or pushes commits. The PR validator is removed. Guarded Build App workflow is unchanged.
- **Exact evidence:** Validation Only run `45884911511` / job `140133094930`, source SHA `c97a2fdc2698b16339d3f03ff04d992f2a0e7848`, terminal SUCCESS; dependency lock, formatter, analyzer and 233/233 Flutter tests PASS.
- **Path inventory:** recursive tree 147 entries / 101 blobs / 46 trees, not truncated. The File inventory contains 101 unique rows with no missing/stale/duplicate path.
- **Disposition:** direct-main policy and source CI are CLOSED / VERIFIED CI. Full content audit and WP0–WP10 App rework remain IN PROGRESS.
- **Next:** continue CODE_FULL Dashboard state ownership and dependency-ordered App review. REPO_FULL follows only after CODE_FULL closes.

### WP3 — Home NOTIFY presentation extraction — 2026-11-27

- **Implementation:** `HomeNotifyCard` is a stateless fixed 44-dp presentation widget. Dashboard supplies final text, label, theme, connected/error/warning flags and foreground color. Safety/HOT-limit classification, stale command-error suppression, locale and contrast decisions remain in Dashboard; BLE/GATT/P1/session authority is unchanged.
- **Regression:** Flutter widget tests include a fixed-height render check for disconnected and warning states plus existing Home text/geometry contracts.
- **Exact evidence:** source and tests included in main SHA `c97a2fdc2698b16339d3f03ff04d992f2a0e7848`; Validation Only #458849, formatter/analyzer and 233/233 tests PASS. Evidence class: VERIFIED CI. Whole-App screenshot/OEM/device acceptance remains NOT VERIFIED.
- **Disposition:** Home NOTIFY extraction CLOSED / VERIFIED CI; Dashboard architecture/design work remains OPEN.


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

### WP0 — `firmware/JEXFYZ-V7.2.ino` — PROTECTED / NO CHANGE (2026-11-26)

- **Reviewed checkpoint:** live `main` before this register update: `106e3c819c8aaeaf8928058abfc875bf4bce4f1c`; recursive tree `142 entries / 96 blobs / 46 trees / truncated=false`. The tree contains exactly one active `firmware/*.ino`: `firmware/JEXFYZ-V7.2.ino`, blob `842e2a3952739001b232a3d9e327c592ff9a6b5a`, 177,751 bytes. Only the first 40 lines were fetched to confirm the filename-matching V7.2 header; no functional source review was performed.
- **Role and authorization:** active ESP32-C3 Firmware sketch containing hardware control, BLE/P1, thermal/rail safety, Touch/LED and OTA behavior. The current owner request explicitly excludes all Firmware/BIN work and reserves Firmware edits for a separate explicitly scoped request with the Firmware safety skill/references. This App-only audit cannot authorize a functional review, edit, compile, BIN, Firebase, OTA, flash or device operation.
- **Disposition:** **PROTECTED — NO CHANGE**. Keep the single current sketch and its versioned filename untouched. The current tree's one-sketch count and V7.2 header are inventory evidence only; they are not proof of compilation, BIN provenance, installed-device identity, thermal/electrical safety or physical behavior.
- **Acceptance evidence:** recursive tree/path identity and first-line/header inspection **PASS — STATIC SOURCE CHECK** for the protection decision. Arduino-ESP32 Core 3.3.7 compile, tests, BIN, NVS, OTA, flashing, BLE/Touch/rail/thermal and physical validation are **NOT RUN / UNVERIFIED** under this authorization.
- **Scope:** no bytes of the Firmware sketch or any Firmware/BIN/Firebase/OTA/device artifact were changed.
- **Next file:** `HANDOVER.md` in live inventory order. Review whether its immediate-next-action role is concise/current and reconcile links with the already refreshed CODE_FULL checkpoint.

### WP0 — `HANDOVER.md` — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- **Reviewed checkpoint:** prior `main` HEAD `de2f6c74aebcdccf75068b958af827e81ca5d45f`; prior handover blob `2e3a1899c1074ee7dd7911cea8b22e102b922b37`; corrected blob `ef841269dc6232e3dd307e02d1b352413838fa4d` (13/96 update commit `838accc7f1065bc21ffe346b721f43549a45167d`). The complete prior 120-line / 26,376-byte file was inspected.
- **Role and consumers:** immediate next-action handover. Current links/references from `README.md`, `MASTER_PROMPT.md`, `CHAT_TRANSFER_PROMPTS.md`, `CHAT_TRANSFER.md`, `PROJECT_STATE.md` and memory governance are preserved. Repository search found no `HANDOVER.md#...` anchor references.
- **Finding / repair:** the former file repeated the three-workspace setup, Workflow v2 policy, Gemini risk review, Diskusi restore, Build #167 artifact hashes, historic WP1 checkpoints and obsolete 8/96 / README-first instructions. Those are already retained in their authoritative locations (`MASTER_PROMPT.md`, `APP_PREBUILD_AUDIT.md`, `PROJECT_STATE.md`, `CHAT_TRANSFER.md`, `APP_BUILD_REPORT.md`, `CHANGELOG.md` and immutable archives). The handover is now a concise 17-line CODE_FULL action packet with live audit position, exact current next file, #72 historical CI boundary, local tooling blockers, Build #167 package boundary and hard exclusions. No unique historical evidence was deleted.
- **Acceptance evidence:** current active workspace, 12/96 progress, protected exclusions, CI/evidence qualifiers and single next action were verified by exact read-back; obsolete Diskusi/Gemini history is absent. Result: **PASS — STATIC SOURCE CHECK**. No build, Flutter test, formatter, analyzer, screenshot or device check was run for this Markdown rewrite.
- **Scope:** `HANDOVER.md` and this register row/record only. No source/tests/config/workflows/Firmware/OTA/Firebase/package/release/device files changed.
- **Disposition:** **UPGRADE — CLOSED / READ-BACK VERIFIED**.
- **Next file:** `lib/app_settings.dart` in the live inventory. Review persisted keys/defaults, theme/language ownership, side effects, callers and tests before proposing any App-only source change.

### WP0 — `lib/app_settings.dart` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** `main` HEAD `b92027b29a6349908376f2bc5544039eb71d764b`; current file blob `1a1f1482eddc47914755c484d4301b30dbb16e31`, 66,079 bytes / 1,894 lines. The complete file was inspected. Pre-formatter CI input source `27ac09c5b77401c37f5fdbfd575001bab5ea9544` contains blob `da9dd8239f6903fb90b53ab1ad3cf5834c3d9675` (66,179 bytes / 1,904 lines).
- **Role / state ownership:** one source for the small persisted `AppSettings` model, app-level preference persistence, shared `ValueNotifier` projections, known-cooler identity storage, bilingual `JexText` lookup/format/relocalization, app themes and compact Settings/Connection typography. It does not own BLE/GATT, device output state, or runtime telemetry.
- **Persisted compatibility contracts:** `jexfyz_app_settings_v2` stores enum names `language`/`theme` and the `notifySafety`, `notifyFirmware`, `notifyBluetooth`, `autoConnect` booleans. New/malformed defaults remain English, `defaultTheme`, notifications enabled and Auto Connect disabled (Manual). Firmware notification deduplication uses separate `jexfyz_last_firmware_notice`. Known cooler identity uses `jexfyz_known_cooler_remote_id_v1`, trims/ignores blank IDs, and exposes only the known remote ID through its notifier. These keys, enum names, defaults and JSON fields are preserved; no storage identity/schema migration is justified.
- **Caller / side-effect map:** `main.dart` loads AppSettings and known cooler identity after the official-build gate, before Firebase initialization and app mount; it observes language and Auto Connect changes. Its passive reconnect path requires the stored preference, known remote ID, scan/connect permissions, Bluetooth adapter readiness and legacy location readiness; it saves the cooler remote ID only after GATT discovery and the P1 `SYNC/SYNC_READY` flow completes. The existing BLE owner remains in `main.dart`. `floating_monitor.dart` consumes the notifiers for Settings/theme and persists language, theme, notification and Auto Connect choices through `AppSettingsStore.save`; native notification-language updates remain a separate bridge. `usage_statistics.dart` consumes the language notifier for presentation. Firmware-notice de-duplication is called from the existing presentation path; no OTA transport/trust/recovery code was changed.
- **Localization inventory — STATIC SOURCE CHECK:** bounded parsing of the `JexText._values` map found **353 unique keys**, with exactly one English and one Indonesian value for every key; no duplicate IDs, missing locale values or mismatched named-placeholder sets were found. The current `test/localization_contract_test.dart` scans 353 matching entries, checks locale presence and placeholder parity, and exercises inline bilingual placeholder parity. `JexText.of` asserts on missing keys/locale values in debug; `JexText.format` asserts on unresolved placeholders; `formatNumber` retains EN/ID numeric display separators without changing stored/protocol values. Current `APP_NOTES.md` states the 353-key inventory; the separate 354-key statement belongs to its explicitly historical 2026-11-14 source baseline and was not rewritten.
- **Theme/design contracts:** `defaultTheme` remains the approved dark Settings theme with the hybrid Home header/content behavior supplied by the two palette helpers; light/dark foreground/surface mapping and compact Settings/Connection typography stay centralized here. `PRODUCT_DESIGN_CONSTITUTION.md` and `DESIGN_NOTES.md` remain authoritative for the protected 360-dp/DPI, visual identity and compact Connection contracts. No new palette, font, global TextScaler change or design token was introduced.
- **Formatter-side-effect audit:** current `app_settings.dart` and the corresponding `27ac09c` blob have identical 8,775-token Dart lexical sequences after whitespace and formatter-only trailing-comma normalization; comments/string literals and semantic tokens were retained. The same normalized token comparison is equal for the live caller paths `lib/main.dart`, `lib/floating_monitor.dart` and relevant `test/localization_contract_test.dart`, `test/widget_test.dart`, `test/floating_monitor_layout_contract_test.dart` and `test/firmware_qc_contract_test.dart`. This is a static lexical comparison, not a Dart AST parse or executed formatter.
- **Regression / coverage assessment:** Validation Only #72 / run `45700008025` / job `139507345524` ran on exact parent source `27ac09c` and recorded locked dependency resolution, formatter post-check, analyzer and **219/219 Flutter tests PASS**. The current source/callers/relevant tests are token-equivalent to that tested input apart from formatter whitespace/trailing commas, so this is applicable **VERIFIED CI** evidence for those contents; it is not a test executed locally in this interaction. Current widget tests check the Manual default and basic AppSettings parsing, theme helpers/default, passive Auto Connect prerequisites; localization tests check all 353 key pairs/placeholders.
- **WP1 regression disposition:** the separate `test/app_settings_store_test.dart` now includes seven test-only failure-injection cases covering settings load/read failure, settings save/write failure and notifier-before-write ordering, firmware notice blank/read/write error handling, and KnownCoolerStore load/read, save/write and clear/delete failures. Together with the seven pre-existing normal-path tests, Validation Only #217 verifies all **292 App tests PASS** including the new cases. Production error semantics and compatibility keys were preserved. Real Android secure-storage behavior remains unverified; do not infer physical keystore behavior from the plugin mock.
- **Finding / disposition:** no source defect, wrong owner, duplicate storage key, missing locale, placeholder mismatch, stale current comment or formatter semantic delta was demonstrated. The file already satisfies its current AppSettings/localization/theme ownership contract. Disposition: **KEEP / VERIFIED**; retain source unchanged.
- **Acceptance evidence:** full file inspection, caller and test map, persisted-key/default inspection, 353-key structural/placeholder check and normalized token comparison **PASS — STATIC SOURCE CHECK**. Validation Only #72 is **VERIFIED CI** on the token-equivalent parent input. Local Dart formatter, analyzer, focused tests and full Flutter suite are **BLOCKED / NOT RUN** because Flutter/Dart are not installed in this runtime. No screenshot, Android build, device, BLE/P1 or physical behavior was validated.
- **Scope:** register row and this file review record only. `lib/app_settings.dart`, callers, tests, storage keys, configuration, workflows, Firmware, OTA, Firebase and release artifacts remain unchanged.
- **Next file:** `lib/connection_scan_coordinator.dart` (next live inventory path). Continue WP0 one path at a time. WP1 secure-storage failure-injection coverage is now closed by Validation Only #217; real Android secure-storage behavior remains platform evidence to gather separately.

### WP0 — lib/connection_scan_coordinator.dart — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** main HEAD 0fabc0b72ddad1a757919f6da7adc53cfb86588a; file blob c633e90b61ca51b096b2c98afdb647df6e0ef729, 3,310 bytes / 116 lines. Current coordinator content is byte-identical to Validation Only #72 input source 27ac09c5b77401c37f5fdbfd575001bab5ea9544 (same blob SHA c633e90b61ca51b096b2c98afdb647df6e0ef729).
- **Role / ownership:** small in-memory coordination layer for the process-wide FlutterBluePlus scanner: passive Auto Connect rediscovery, one-shot Auto Connect/OTA discovery and manually opened Connection sheet. It explicitly does not own GATT connection/session state, P1 framing/protocol or physical device state. The sole App instance is owned by DashboardScreen in lib/main.dart; no second BLE client/owner was found.
- **Concurrency model:** one shared monotonically increasing generation is used by passive and one-shot attempt leases. A stale token cannot pass its current-attempt predicate, and stale finish operations clear a reservation only when their token still matches. Manual sheet open and connection handoff invalidate outstanding attempts; selected-device dismissal retains the handoff fence until _connect preflight has stopped the scanner and assigned _bleConnecting. Neutral sheet dismissal permits reconnect resumption only after scan cleanup succeeds.
- **Scanner command ordering:** runSerialized chains native scanner commands FIFO. The returned future preserves each operation's error, while the internal queue tail resolves both success and failure so a failed scan command does not poison future work. The queue is not held for the entire radio scan window. One-shot primary/fallback scan starts and stops use the queue with an in-queue lease check; passive/manual paths also serialize their scanner mutations.
- **Caller / lifecycle trace:** main.dart invalidates leases on dashboard dispose and rediscovery cancellation; the passive loop captures a lease before permission/adapter/SDK checks, rechecks after each asynchronous prerequisite, uses fresh onScanResults, and holds its reservation until isScanning == false; one-shot discovery reserves synchronously before prerequisites, rechecks mutable connection state before starting, uses fresh primary and fallback result streams, and releases in finally; manual sheet open blocks autonomous attempts, performs passive cleanup, serializes stop/start commands, and differentiates neutral close from selected-device handoff. Connection handoff wraps the stop/cancel preflight and closes before the BLE connecting state becomes authoritative. All callers and the focused pure helper tests were inspected.
- **Regression coverage:** test/connection_scan_coordinator_test.dart covers manual-sheet pre-emption of passive and one-shot prerequisites, passive/one-shot mutual exclusion, stale-token completion versus a newer generation, selected-device handoff, handoff blocking, full scan-lease duration, FIFO serialization and queue recovery after an error. test/floating_monitor_layout_contract_test.dart additionally asserts the production passive/one-shot scanner source structure and critical call ordering (reservation before permission, primary/fallback use fresh onScanResults, serial command wrapper, and finish after the passive scan-completion wait). test/connection_scan_state_test.dart covers permission/unavailable/error/scanning/not-found state priority and advertisement/platform/localized device-name fallback.
- **Test-quality qualification:** the coordinator tests are behavioral unit tests for its state and queue, but they simulate scanner operations through futures rather than invoking the FlutterBluePlus native/plugin radio. The layout contract test deliberately inspects source strings and call ordering; it is a useful structural guard, not an integration/runtime test and could miss a semantically dead caller path. This is retained rather than weakened. Android permission, adapter loss, real scan cancellation, advertisement timing and OEM behavior remain UNVERIFIED / DEVICE NOT TESTED.
- **Evidence alignment:** current lib/main.dart is byte-content token-equivalent to #72's input after formatter whitespace/trailing-comma normalization (57,645 tokens each); test/connection_scan_coordinator_test.dart is likewise token-equivalent (1,316 tokens); test/floating_monitor_layout_contract_test.dart is token-equivalent (5,550 tokens). The coordinator itself is byte-identical. Therefore Validation Only #72 / run 45700008025 / job 139507345524 terminal SUCCESS (formatter post-check, analyzer, locked dependency resolution and 219/219 tests) is applicable VERIFIED CI evidence for these contents. This is not a local test executed in the current interaction and no CI was retried.
- **Finding / disposition:** generation fencing, mutual exclusion, FIFO scanner command sequencing, selected-device handoff and cleanup ordering are internally consistent in the inspected source. No behavioral defect or unjustified second scanner owner was found. The method name invalidatePassiveAttempts() also increments the shared generation used by one-shot tokens; tests intentionally rely on that shared invalidation. This is a naming asymmetry, not a functional defect, and renaming all callers is not justified in this audit. Disposition: KEEP / VERIFIED.
- **Acceptance evidence:** complete coordinator/caller/test review, state transition/race analysis and CI-source equivalence PASS — STATIC SOURCE CHECK / VERIFIED CI. Local focused Flutter test, analyzer and formatter are BLOCKED / NOT RUN because Flutter/Dart are unavailable. No BLE scan, Android permission flow, App Build, physical device, Firmware, OTA or hardware operation was run or authorized.
- **Scope:** register row and this audit record only. No source/test/workflow/config/Firmware/OTA/Firebase/release/device code was changed.
- **Next file:** full `lib/main.dart` ownership/content review, continuing from Dashboard scan and FloatingTelemetry caller paths already sampled. `lib/connection_scan_coordinator.dart` and `lib/connection_scan_state.dart` are KEEP / VERIFIED; `lib/floating_monitor.dart` remains UPGRADE APPROVED for further modularization. Do not alter native service recovery until the product decision in APP_PREBUILD_AUDIT.md is resolved.

### WP0 — lib/connection_scan_state.dart — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** main HEAD f5f37228531b30416361af86988f9b3d232fae84; source blob 2cabc8aefe3f9b22a321f7632b5e743277d2c1bb (1,092 bytes / 32 lines); focused test blob c689e0cd58569ea67fd02670a4559a31305fef0f (2,864 bytes / 113 lines). Both files are byte-identical to Validation Only #72 input source 27ac09c5b77401c37f5fdbfd575001bab5ea9544.
- **Role / boundary:** two pure presentation helpers for the Flutter Bluetooth Connection sheet. They do not access FlutterBluePlus, own scan/session state, parse P1, identify an authenticated App or change physical device state.
- **Empty-state priority:** permission-required → Bluetooth/legacy-location unavailable → explicit scan error → active scan → completed/no matching device. Main.dart computes the live prerequisite/scanning/error inputs in _ConnectionSheetContentState and renders the returned localized JexText key beside the relevant connection-state icon and guarded scan/retry action. Localization entries exist for every returned key in app_settings.dart.
- **Peripheral identity display:** connectionDeviceDisplayName trims the current advertisement local name and returns it when non-empty; otherwise trims/uses Android platformName; only when both are empty does it return the localized generic Device/Perangkat fallback. main.dart passes result.advertisementData.advName and result.device.platformName from the current scan result in the rendered device row. No stale previous scanResults list or hard-coded generic label replaces an available JE X FYZ name in this row.
- **Caller / reference map:** one production caller for each pure helper was found in the live main.dart Connection sheet. test/connection_scan_state_test.dart is the pure mapping regression suite; test/floating_monitor_layout_contract_test.dart verifies helper placement and message rendering structure; test/widget_test.dart checks the Connection row uses the advertisement/platform/fallback helper and does not revert to the old generic-name comparison. App Notes record the approved scan-state and device-identity presentation contract.
- **Regression coverage:** nine pure tests cover permission priority, unavailable state, scan error, active scanning, completed not-found, advertised-name precedence, stale platform-name rejection, platform-name fallback and localized fallback after both names are blank. The helpers are deterministic and can be tested without hardware.
- **Test-quality gap:** no dedicated assertion currently combines bluetoothUnavailable=true with a simultaneous errorKey to lock the intended precedence (unavailable wins over error); likewise, the whitespace tests cover an empty/whitespace advertisement and a non-empty fallback, but do not explicitly assert trimming of a non-empty advertised name/platformName. These are small WP1 regression additions, not demonstrated source defects; avoid changing the pure mapping without evidence of an incorrect user state.
- **Evidence alignment:** source and pure helper test SHA values are exactly the same on current main and Validation Only #72 input. The relevant main.dart and widget_test.dart current versions are token-equivalent to that CI input after formatter whitespace/trailing-comma normalization. Validation Only #72 / run 45700008025 / job 139507345524 terminal SUCCESS on the CI input recorded **219/219 Flutter tests PASS**, formatter post-check, analyzer and locked dependency resolution. This is **VERIFIED CI** for the same semantic source/test content, not a test executed locally in this interaction.
- **Finding / disposition:** priority mapping and peripheral-name fallback are coherent with the owner-approved Connection contract and locale source. No broken caller, missing localization key or incorrect state mapping was found. Disposition: **KEEP / VERIFIED**; no code or test change is justified during this file review.
- **Acceptance evidence:** complete helper/caller/test inspection and current-to-CI source identity **PASS — STATIC SOURCE CHECK / VERIFIED CI**. Local Flutter test, formatter and analyzer remain BLOCKED / NOT RUN because the Dart/Flutter toolchain is unavailable. No real scan, OEM screen, BLE/P1, App Build, Firmware or hardware operation was run.
- **Scope:** this register row and record only. No source/test/config/workflow/Firmware/OTA/Firebase/release/device file changed.
- **Next file:** lib/floating_monitor.dart (next inventory path). It is a large formatter-touched Tier 2 App module; review its current architecture, persistence consumers, Flutter/native bridge, callers, tests and exact semantic diff before any extraction or visual change.

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

All 12 paths received only the workflow's `dart format` output at that time; this is not a substitute for file-level content/dependency/security review. `lib/floating_monitor.dart` has since received an individual static review and UPGRADE APPROVED disposition as recorded above. The other 11 paths remain **CONTENT REVIEW PENDING (FORMATTER ONLY)**, including the companion `test/floating_monitor_layout_contract_test.dart`. No semantic modernization is claimed from formatting alone.

### WP0 — skill catalogue and mirror audit — 2026-11-26

All 12 canonical skills under `.agents/skills/*/SKILL.md` and all 12 `.github/skills/*/SKILL.md` mirrors were read. Each canonical/mirror pair is byte-identical by Git blob SHA; no skill file was edited.

| Skill | Matching canonical/mirror blob SHA | Disposition |
|---|---|---|
| `ble-p1-protocol-audit` | `264fdb1617770a63899db97575fe83db0fc9f933` | KEEP / VERIFIED |
| `code-review` | `08944ea149006db8a7fa1236fffefb74315080a8` | KEEP / VERIFIED |
| `documentation-memory-governance` | `7ef1d2a0721bec7d1d2b7044cc66a1a9c9c0ff4d` | KEEP / VERIFIED |
| `esp32c3-firmware-safety` | `7052fadd98e7bac0c76974e1c3dcd78e44a12b69` | PROTECTED — NO CHANGE |
| `flutter-app-engineering` | `958129caf70528071827f076678e08802ce3b524` | KEEP / VERIFIED |
| `flutter-quality-and-regression` | `a1a1c57ad01dae50f0de945ce6e6b08a4dbec4e8` | KEEP / VERIFIED |
| `github-actions-triage` | `252cbf1ac50edac89c5fbda7c57ac2261aefdf91` | KEEP / VERIFIED |
| `hardware-power-thermal-analysis` | `bc633e8b2e2e71c1398c12f074075452d62f7d08` | PROTECTED — NO CHANGE |
| `ota-and-release-integrity` | `a58aceff1d2836761f11ff350cd31ff8997ed7bf` | KEEP / VERIFIED |
| `product-design-and-visual-quality` | `6034864cf500da55a658f89e1f9e4c51fc452db8` | KEEP / VERIFIED |
| `repository-forensics` | `a0746adce83ab77428038ff544940a248e55cb44` | KEEP / VERIFIED |
| `technical-research-and-second-opinion` | `4135f29236c469e22743dc827dae86cdb7d278f6` | KEEP / VERIFIED |

The Firmware-safety and hardware/power skills are retained as protected project references but are not being applied to the App work package. The three actively loaded engineering/design skills remain `flutter-app-engineering`, `flutter-quality-and-regression` and `product-design-and-visual-quality`.

### WP1 / WP6 — non-publishing CI workflow and contract-test review — 2026-11-26

- **Guarded Build App:** `.github/workflows/jexfyz-app-build-trigger.yml` blob `28281db3118e36fd1658cdaef2e30c78e6c4977b` is PROTECTED — NO CHANGE. Static review verified the issue-only opened/reopened trigger, owner + exact title + body-token guard, non-cancelling serialized queue, immutable direct action SHAs, checkout credential persistence disabled, mandatory analyzer/Flutter/Android/signing/tag/source-archive/download checks and the single intended APK plus source ZIP. No workflow was invoked and no Build App authorization is implied.
- **Release token caveat:** workflow-level permissions are empty, but `contents: write` is granted at the guarded `build` job level. Explicit `GH_TOKEN` environment wiring occurs only in Release publish/final verification steps; that is not a true step-level permission boundary because Actions can access `github.token` from the context without explicit pass-through. `BUILD_NOTES.md` already records this accurately. The contract test previously overclaimed that the “GitHub write token remains limited” to those two steps; the test is corrected to state that only explicit `GH_TOKEN` env wiring is scoped while the job token remains write-enabled. **Residual risk:** the job-level write permission remains available to all actions/steps in the job. A split read-only build + narrowly write-enabled publish boundary is a separate future hardening decision; the protected Build workflow is not edited here.
- **PR validation:** `.github/workflows/jexfyz-app-pr-validation.yml` blob `175606f80d4f916be919c9b2fd997067288368ff` is KEEP / VERIFIED: pull-request-only, `contents: read`, immutable action SHAs, nested cache disabled, locked dependency resolution, read-only formatter/analyzer/tests and fail-closed summary.
- **Validation Only:** `.github/workflows/jexfyz-app-validation.yml` blob `b6b35f7ce65e30f69124e3e780e0c9c99518a748` had `cache: true` on the SHA-pinned Flutter composite action, enabling its nested mutable `actions/cache@v5` reference. This was inconsistent with both PR validation and the release workflow, which set `cache: false`. Minimal hardening changes only this value to `false`; locked dependencies, read-only formatter check, conditional formatter-only patch/commit guard, analyzer and full Flutter test gates are unchanged.
- **Regression test:** `test/github_actions_workflow_contract_test.dart` previous blob `15b6982588a7e0ce8b6d1e858e6fe3c14f3653af` is upgraded to load both non-publishing workflows and assert that each Flutter setup step keeps `cache: false`; it also makes the job-level-vs-explicit-`GH_TOKEN` permission distinction observable. New source blobs: workflow `c0b75430a406d6756e301065bb727d84e4e0fea7`; test `3adace43dfad6b10aa267f45fbf99d9ccc6ee435`. This is a source-contract check, not an Actions execution.
- **Validation state:** local Flutter/Dart toolchain is unavailable, so local formatter/analyzer/focused/full tests are BLOCKED / NOT RUN. The source push includes `.github/workflows/jexfyz-app-validation.yml` and `test/**`, so confirm the actual live run, source SHA and all result steps after commit. Do not trigger Build App.

### WP0 — `.gitignore` — KEEP / VERIFIED (2026-11-26)

- Source blob: `d5c04d9c03a160f52b101d6c2aa27b7672e78532`.
- The rules separate Dart/Flutter generated output, Android local machine state, IDE files, private signing material/local environment files and OS noise. Canonical project memory, source and tests are not ignored.
- The explicit patterns `.env`, `.env.*`, `android/local.properties`, `android/key.properties`, `*.jks`, `*.keystore` and `*.p12` protect local secrets and signing material.
- The live recursive tree contains no tracked path matching those secret/property patterns. No source or test path is hidden by a broad ignore rule.
- Decision: KEEP unchanged. Static content and recursive-path review only; not a runtime test.

### WP1 / WP6 — Validation Only #74 / #75 closure — 2026-11-26

- **#74:** run `45824943829`, job `139926598155`, source SHA `8e8e5bff2b9ab4c8ada53406b026520b194044f6`, terminal FAILURE. Locked dependencies, formatter-final, analyzer and **220/220 tests** passed. Formatter precheck detected new test formatting; formatter apply/final and patch preview succeeded. The formatter-only commit step correctly refused to push because `main` advanced to `27e02e5` while the job ran. No CI formatter commit was made.
- **Recovery:** exact formatter patch artifact was applied only to `test/github_actions_workflow_contract_test.dart`, then committed as `a7466305d094e975b9f5ef2e1ffc08271bc20c25`. Read-back test blob: `f1707ad29ac572173393f1adb91ce7aa16efb35c`.
- **#75:** run `45825556040`, job `139928665698`, event `push`, exact source SHA `a7466305d094e975b9f5ef2e1ffc08271bc20c25`, terminal SUCCESS. Locked dependencies PASS; read-only formatter precheck PASS; formatter apply SKIPPED; post-format verification PASS; analyzer step SUCCESS; Flutter tests **220/220 PASS**; formatter patch/commit steps SKIPPED because no diff remained. Run and step results were read back from GitHub.
- **Closure:** Validation Only workflow cache hardening and workflow-contract regression/token-scope correction are `UPGRADE — CLOSED / READ-BACK VERIFIED`. No Build App workflow was edited or triggered.
- **Analyzer qualification:** CI analyzer used `--no-fatal-infos`; it completed SUCCESS while printing information-level diagnostics. This is not a claim of zero informational diagnostics.
- **Local validation:** Flutter/Dart/Gradle/ADB are unavailable locally; local format/analyzer/test/Android/device checks are BLOCKED / NOT RUN. Actual visual rendering remains `VISUAL NOT VERIFIED`.

### WP0 — BLE P1 audit skill and Copilot mirror — KEEP / VERIFIED (2026-11-26)

- **Reviewed canonical file:** `.agents/skills/ble-p1-protocol-audit/SKILL.md`, live blob `264fdb1617770a63899db97575fe83db0fc9f933`. The recursive tree records the same Git blob SHA for `.github/skills/ble-p1-protocol-audit/SKILL.md`, confirming a byte-identical mirror.
- **Content decision:** retain. The skill consistently treats BLE/P1 as a single-owner distributed state machine; separates command intent, ACK and authoritative physical telemetry; preserves unknown state through disconnect/unsynchronized periods; and keeps bonded SYNC_READY distinct from official App identity authentication. It requires caller/source/test evidence and regression mapping before protocol claims. No stale project contract or conflicting scope instruction was identified.
- **Scope result:** these are governance/skill files, not an authorization to change BLE UUIDs, P1 framing, commands, retry cadence, security or Firmware. P1 wire protocol and BLE identity/security remain excluded from this App rework. No source, test, workflow or hardware file changed.
- **Validation:** content and path review only; mirror identity is verified by matching Git blob SHA. No runtime/test/formatter/analyzer command is applicable to this documentation disposition.
- **Disposition:** `KEEP / VERIFIED` for both paths. The next unreviewed live inventory path is `.agents/skills/code-review/SKILL.md`.

## WP0 source review — `lib/floating_monitor.dart` — 2026-11-26

- **Reviewed checkpoint:** live `main` source blob `176a21242602eb0db44420d2a9324eebe05e95b5` (1,961 lines); callers in `lib/main.dart` blob `9663736fbe4bd7d251a8b3632b735a9cafb0b4d1`; regression test blob `4784fb775388f226d19fd4acb02beea9f7074d03`; native receiver `MainActivity.kt` blob `cab1cabf10b57a0f5d547fccf85b76b067503c0e`; native service `FloatingMonitorService.kt` blob `8e66da2525b5cc75ef8780c2d480607328492df6`. Latest source-fix commit `9a501fcdac5814abe4e98b229ca157eb771206d9`; Validation Only #73 / run `45717895008` / job `139568563820` completed SUCCESS on that SHA.
- **Boundary finding:** the file combines Floating Monitor models/store/bridge/settings with Settings navigation, shared 360-dp/compact-theme canvas, Lock Voltage row, About, Language, Appearance, Notifications and Bluetooth pages. `main.dart` remains the only BLE/GATT/P1/session owner and publishes the connected, synchronized telemetry projection. `MainActivity.kt` receives the matching `je_x_fyz/floating` MethodChannel; `FloatingMonitorService.kt` owns the foreground overlay/WindowManager/HUD and contains no BLE client.
- **Contract findings:** Flutter Secure Storage key `jexfyz_floating_v1` stores configuration only; native SharedPreferences `jexfyz_floating_native_v1` stores overlay geometry. Native gesture operations persist geometry and Flutter reconciles size/orientation through the 3-second runtime-state poll. The existing v2 B/H/V/A/P/F metric migration and unknown-while-disconnected behavior must remain intact. No concrete persistence corruption was observed.
- **Lifecycle/test follow-up (2026-11-28):** `test/floating_monitor_store_test.dart` now directly covers schema-v2 load/publish, default restoration on read failure, persisted schema/config values, and notifier retention when a write fails (4 tests; Validation Only #220). `test/floating_monitor_bridge_test.dart` covers all seven exposed MethodChannel operations, payload mapping, permission/start/stop behavior, runtime-state result validation and native channel errors (10 tests; Validation Only #223).
- **Disposition:** **UPGRADE APPROVED** under the existing App-only rework plan: separate Settings navigation/shared presentation and AppSettings-backed subpages from Floating Monitor configuration/persistence/bridge/application/presentation. This is a future Eksekusi Code source work package, not a change made or executed in Diskusi. The companion test file remains a separate pending inventory item; local tests, Android/OEM overlay and visual/device acceptance were not performed here.

### WP0 — 00_WORK_STATUS.md — KEEP / VERIFIED (2026-11-26)

- Reviewed the live status marker and status model. It keeps SESSION STATUS, cross-workspace WORK STATUS, WORKSPACE and independent EXTERNAL OPERATION STATUS separate; records Asia/Jakarta timestamps, phase, evidence, blocker and next action; and explicitly identifies itself as event-driven rather than a heartbeat or lock.
- Dynamic status values are intentionally updated per JE X FYZ interaction. No product/source behavior, credential, release or device data belongs in this file. The status schema is consistent with MASTER_PROMPT.md Section 2A.
- **Disposition:** KEEP / VERIFIED. No schema or policy change required.

### WP0 — AGENTS.md — KEEP / VERIFIED (2026-11-26)

- Reviewed the full cross-agent entrypoint. It routes to MASTER_PROMPT.md and SKILLS_INDEX.md, accurately distinguishes Diskusi / Eksekusi Code / Build App, preserves the single-writer rule and protected Firmware/OTA/Firebase/device boundaries, and does not establish a competing operating policy.
- Referenced root authority/index files are present in the live tree. No stale path or conflicting permission instruction was found.
- **Disposition:** KEEP / VERIFIED. Retain as the concise interoperability pointer.

### WP1 — test/device_copy_notification_contract_test.dart — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- Reviewed the complete test file. Its assertions are explicitly source-contract checks for bilingual device copy, notification ID separation, Floating Monitor full-sync gating, deferred OTA messaging and native notification-channel language; they do not claim runtime Android/permission/device coverage.
- The Android location compatibility check covers the private MainActivity.isLocationServiceEnabled() body. The initial assertion verified only that manager.isLocationEnabled appeared after the SDK guard and could pass if the API-28-only property were misplaced inside the legacy else branch.
- Corrected the false-positive by asserting api28Call < legacyBranch, with a nearby comment explaining the API-28 / minSdk 24–27 invariant. The current test blob is e32e17d0be304ae44d04e2bb3409058626734555; current implementation is on MainActivity.kt blob ff5e852bfaf33143fe6565a5fd37a560f8950c90.
- **VERIFIED CI:** Validation Only #77 / run 45830921047 / job 139947149887, exact source/test SHA b1ee13ddc5e2b13c72485a30518c70c06c77c13f, terminal SUCCESS. Locked dependencies PASS; formatter precheck/final PASS (19 files / 0 changed); analyzer step SUCCESS with --no-fatal-infos; Flutter tests 221/221 PASS. Formatter apply, patch upload and formatting commit were SKIPPED.
- **Caller reconciliation:** five Dart call sites exist for isLocationServiceEnabled in lib/main.dart: auto-connect, permission setup, one-shot scan, passive rediscovery and Bluetooth status refresh. The prior checkpoint statements that no Dart caller existed were incorrect; these are active legacy BLE prerequisites/status consumers, although no user-facing incident was reproduced. The API-28 guard's source-contract assertion is covered by the successful #77 run.
- **Evidence limit:** this test is a static source contract. The Validation Only workflow checks Flutter/Dart only; it does not compile Kotlin/Android or prove API 24–27 device behavior. Those remain BLOCKED / NOT RUN in this runtime.
- **Disposition:** UPGRADE / CLOSED / READ-BACK VERIFIED. Preserve the distinction between static source assertions and native runtime validation.


### WP5 — `android/app/build.gradle` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** live `main` configuration blob `075add443ab2cd4ecd58e588124bb7e41f8e8185`; root inventory remains 142 entries / 96 blobs / 46 trees at pre-register checkpoint HEAD `8cc168cd8f781657410c4c6547eb88fdbc1e60de`.
- **Identity/platform contract:** `namespace` and `applicationId` remain `com.horizontalzzz.jexfyz`; `minSdk 24`, `targetSdk 36`, `compileSdk 37`, Java 17 and Kotlin JVM 17 are retained. Flutter versionCode remains sourced from local properties with existing fallback; versionName is unchanged. Build features retain BuildConfig and AIDL.
- **Signing boundary:** release signing values are read only from environment variables; the release variant fails closed when required material/certificate cannot be loaded. Debug embeds an empty official-certificate value; release certificate material is derived from the configured keystore. V1/V2/V3 signing remain enabled, V4 disabled. No secret values or signing material were read or changed.
- **Finding / decision:** the earlier cleanup removed only an obsolete comment and an empty `dependencies {}` block; this review found no further justified source change. Keep the existing identity, signing and SDK contract unchanged.
- **Validation:** content/static review only. No Gradle wrapper, Flutter/Dart or Android SDK is available in this runtime; Kotlin/Android Gradle compilation and SDK/plugin compatibility are BLOCKED / NOT RUN. No APK/package build was invoked.
- **Disposition:** `KEEP / VERIFIED`.

### WP9 — `android/app/google-services.json` — PROTECTED / NO CHANGE (2026-11-26)

- **Metadata checkpoint:** path exists in the live recursive tree as blob `f3ed065a7ee56b2a44f0a943a48fa578ba72e0d7`. Only path/type/blob metadata was used to identify it.
- **Protection decision:** Firebase Android configuration is a protected sensitive configuration path. The file content was deliberately not fetched, printed, parsed, copied, edited or included in diagnostics. No Firebase console, production project, credential, rules or data mutation was performed.
- **Validation:** metadata/path-presence check only. Content validity, project registration and runtime Firebase initialization are expressly not claimed.
- **Disposition:** `PROTECTED — NO CHANGE`; content remains unopened.

### WP4 / WP5 — `android/app/proguard-rules.pro` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** blob `3831429706eafe4bfc354bbaf1f2c005e8c05740`; complete 11-line file reviewed alongside `AndroidManifest.xml` and the live `MainActivity.kt` class/bridge declaration.
- **Role and references:** the rule retains `com.horizontalzzz.jexfyz.MainActivity` and all its members, preserving the manifest launcher entrypoint and Flutter MethodChannel host methods through R8. The manifest explicitly declares the native service components; their component declarations remain part of Android's manifest-based reachability contract.
- **Finding / decision:** the keep rule is narrow to the host Activity and matches the current native entrypoint. Its comments are somewhat repetitive but do not create a correctness or maintenance defect sufficient to justify changing a shrinker rule without an authorized R8 build.
- **Validation:** static rule and manifest cross-reference only. No release variant, R8/resource-shrinking or APK verification was run; those checks require the separately guarded Build App workflow and a fresh authorization.
- **Disposition:** `KEEP / VERIFIED`.

### WP4 — `android/app/src/main/AndroidManifest.xml` — KEEP / VERIFIED (2026-11-26)

- **Reviewed checkpoint:** blob `776a62ae906b63603ecbec1b5b19da4cc91c1ee7`; complete manifest reviewed against live Gradle namespace/application ID, native Activity/service declarations and icon resource path.
- **Permission matrix:** Android 12+ BLE scan/connect permissions are declared, with `neverForLocation` on scan; legacy Bluetooth and location permissions are capped at API 30. Foreground service base, connected-device and special-use permissions, notification permission, Internet and overlay special access are declared consistently with the existing features.
- **Component contract:** `.MainActivity` remains the exported launcher Activity; `.JeForegroundService` is non-exported and declares `connectedDevice`; `.FloatingMonitorService` is non-exported and declares `specialUse` with the required subtype property. The corresponding Kotlin services promote themselves with the matching foreground-service type on API 29+ / API 34+, respectively. Flutter embedding v2 and the VIEW intent query remain present.
- **Resource/identity references:** application label remains JE Cooler; application class placeholder is retained; `@drawable/jexfyzicon` resolves to the tracked `drawable-nodpi/jexfyzicon.png` path. No namespace, package, service ownership or permission broadening was introduced.
- **Finding / decision:** declarations are internally consistent with the inspected native service implementations. Keep the manifest unchanged. This does not prove OEM-specific permission prompts, foreground-service eligibility, notification behavior or overlay behavior on physical devices.
- **Validation:** static XML/source/path review only. Android lint/manifest merge, Gradle compilation, API 24–36 emulator/device behavior and OEM regression remain BLOCKED / NOT RUN; visual acceptance remains VISUAL NOT VERIFIED.
- **Disposition:** `KEEP / VERIFIED`.


### WP0 — Android native Kotlin services and MethodChannel host — KEEP / VERIFIED (2026-11-26)

- Reviewed source blobs: FloatingMonitorService.kt 8e66da2525b5cc75ef8780c2d480607328492df6; JeForegroundService.kt 94b6fed7e4b8d99648eb427a87d10b1700363b35; JexNotificationUtils.kt 95110ac9b466ed7f6fe21d7cfe41386ec974cf23; MainActivity.kt ff5e852bfaf33143fe6565a5fd37a560f8950c90.
- Floating Monitor owns only the special-use foreground overlay, WindowManager attach/detach, Canvas HUD, geometry and gestures. Dart FloatingBridge and MainActivity agree on je_x_fyz/floating and its start/stop/config/data/runtime methods. Telemetry updates only target instance?.applyData(json); they do not start another service. The service has no BluetoothGatt / FlutterBluePlus implementation, stays START_NOT_STICKY, gates attach on overlay permission and connected telemetry, and removes its view/singleton during destruction. Manifest specialUse permission/type match. No service source edit was required.
- JeForegroundService backs an already-active Flutter BLE session only; MainActivity starts/stops it from the Dart session lifecycle. It contains no BLE/GATT client, uses the connected-device foreground type on API 29+ consistent with the Manifest, is not bound and is START_NOT_STICKY. Language updates do not change BLE ownership.
- JexNotificationUtils uses the tracked ic_notification resource and a MainActivity PendingIntent with CLEAR_TOP | SINGLE_TOP; immutable PendingIntent flags are applied on API 23+, above minSdk 24. Shared notification construction is presentation-only.
- MainActivity's four native MethodChannels match Dart callers (battery_temp, floating, security, notifications). The Activity remains the host for system settings, release-certificate comparison, battery temperature, notification permission/result and native support services; no BLE implementation is introduced. showUserNotification returns false when POST_NOTIFICATIONS is missing or posting fails, and true after NotificationManager.notify returns. The API-28 location guard is actively consumed at five Dart call sites as described above.
- Acceptance evidence: complete static file and call-site review; Flutter source contract for Floating overlay ownership passed Validation Only #78; Firmware notification result contract passed Validation Only #79. No Kotlin compile, Android Gradle/Manifest merge, R8 or API/OEM runtime test. Disposition for all four native Kotlin files: KEEP / VERIFIED.

### WP1 — test/floating_monitor_layout_contract_test.dart — UPGRADE / CLOSED / READ-BACK VERIFIED (2026-11-26)

- Reviewed original test blob 4784fb775388f226d19fd4acb02beea9f7074d03; added a Native Floating Monitor remains a presentation-only overlay owner source-contract test in commit b29be367b3d359f1930864c55e73706579330d35; formatter-only follow-up e227a423d3ab1449eeb03474ca45db6f4c257f57; current blob fadfbc9568a9d66e4efd8a67b0aba346688e2478.
- The new test checks no native BLE/GATT client, overlay specialUse manifest permission/type, WindowManager add/remove, instance-only telemetry forwarding, START_NOT_STICKY/destruction cleanup and the Dart/MainActivity MethodChannel contract.
- VERIFIED CI: Validation Only #78 / run 45837090089 / job 139968713612, exact source/test SHA b29be367b3d359f1930864c55e73706579330d35, terminal SUCCESS. Formatter-only test reflow was committed after the run; no semantic change.
- Evidence limit: source-contract + Flutter CI only. No Android compilation, WindowManager/OEM overlay or physical-device visual acceptance. Visual acceptance remains VISUAL NOT VERIFIED.
- Disposition: UPGRADE / CLOSED / READ-BACK VERIFIED.

### WP1 — lib/main.dart — targeted Firmware notification acknowledgement upgrade (whole-file audit remains open)

- Reviewed original source blob 9663736fbe4bd7d251a8b3632b735a9cafb0b4d1; targeted fix commit 80fbb23e887eb4424114169947ac6f441d3dceca; formatter-only follow-up 32f870bccd1935efdaba6073ec46efb3e2b4d4e7; current blob 346ce5ff6cbdbef24afe2a08b25443e560b9c5eb.
- The Firmware update dialog previously ignored the Boolean return from native showNotification and persisted the version cooldown unconditionally. It now invokes invokeMethod<bool> and calls markFirmwareNotified(version) only when the result is exactly true. Missing permission, null/false result or channel exception leaves the version eligible for a later check.
- Regression evidence: test/device_copy_notification_contract_test.dart checks the Dart result guard and native false-on-permission-denied / true-after-notify contract. Current test blob 99f8a920ecb7c6aea743c861eee5724a486a9cfa. Validation Only #79 / run 45838156356 / job 139972413867 terminal SUCCESS on tested commit 80fbb23e887eb4424114169947ac6f441d3dceca; the subsequent 32f870b commit contains formatter reflow only.
- Disposition: this targeted notification path is validated. The full lib/main.dart content/architecture review remains pending; retain it in the seven-file review queue.


### WP0 — Android launcher asset, notification icon and root Gradle configuration — 2026-11-26

#### `android/app/src/main/res/drawable-nodpi/jexfyzicon.png` — PROTECTED / NO CHANGE

- **Blob / identity:** `bad855f23416fd58aff194c30b7f8fd77f260ea8`; it is byte-identical to `assets/jexfyzicon.png` at the same blob SHA. The complete PNG chunk scan shows 1254×1254 pixels, 8-bit truecolor RGB (color type 2), no alpha channel and no `tRNS` transparency chunk. The visible artwork is the existing white JE monogram on an opaque black square.
- **Consumer:** `AndroidManifest.xml` points application icon to `@drawable/jexfyzicon`; Flutter declares the matching `assets/jexfyzicon.png` resource. Workflow audit requires the Android icon path to remain present and rejects the retired reference.
- **Contract discrepancy:** `APP_NOTES.md` and `DESIGN_NOTES.md` describe the supplied brand PNGs as transparent square assets, but this exact shared binary does not encode transparency. The pixel geometry/brand is preserved; this is an image-alpha contract mismatch, not an instruction to redraw or replace the logo.
- **Disposition:** keep the current binary protected and unchanged. A future alpha/background conversion would alter the launcher/Home visual and must be handled as an explicit visual asset decision with screenshot review. No asset was generated, modified, published or replaced in this session.

#### `android/app/src/main/res/drawable/ic_notification.xml` — KEEP / VERIFIED

- **Reviewed blob:** `8f1a4f045f72810f3df421e74233d0c4e84c6c8d`; 24dp × 24dp vector with a single white JE monogram silhouette on a transparent vector canvas.
- **Consumer and tests:** `JexNotificationUtils.kt` uses `setSmallIcon(R.drawable.ic_notification)`; the Widget source-contract test requires this vector, rejects the launcher PNG as a small icon and rejects a large-icon duplicate. This is the correct separation between launcher/Flutter artwork and Android's monochrome/tinted notification small icon.
- **Disposition:** KEEP / VERIFIED. No drawable or notification behavior change.

#### `android/build.gradle` — KEEP / VERIFIED

- **Reviewed blob:** `bfc244a4fbee7d71556449b2f32f67830722011d`; identical at Build #167 source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`.
- Shared repositories remain Google and Maven Central; generated output stays under the Flutter `build` directory; subprojects are evaluated against `:app`; `clean` deletes only generated root build output. Existing spacing/duplicate subproject blocks are valid and do not warrant a cleanup unrelated to behavior.
- Build #167 previously completed Android Gradle successfully with this exact root configuration. No current source edit.

#### `android/gradle.properties` — KEEP / VERIFIED

- **Reviewed blob:** `8ff8f1f512e1a7b1b197fe1d9a84b9777ca7cdd3`; identical at Build #167 source. It pins the 4 GB Gradle JVM heap, AndroidX and Jetifier, and deliberately sets `android.builtInKotlin=false` plus `android.newDsl=false`.
- Android's AGP 9 migration guidance identifies these two false properties as the paired temporary opt-out path for projects not yet migrated to built-in Kotlin. They are consistent with retaining the external `org.jetbrains.kotlin.android` plugin. No property was changed.
- Build #167 previously completed its Android Gradle build with this exact file. Keep unchanged pending a separately measured built-in-Kotlin migration.

#### `android/settings.gradle` — KEEP / VERIFIED WITH KGP MATRIX CAVEAT

- **Reviewed blob:** `1e36982890cf4522836eb05598747b7af5da7b4c`; byte-identical at Build #167 source. Plugin pins: Flutter loader 1.0.0, AGP 9.1.1, Kotlin Gradle Plugin 2.2.20, Google Services 4.4.4; Flutter SDK is resolved from local `android/local.properties`; the project includes only `:app`.
- Current Build App workflow explicitly pins Java 17, Flutter 3.47.2 and Gradle 9.3.1, and creates a local `gradlew` shell shim delegating to that already-installed Gradle; the repository intentionally does not track a binary wrapper. AGP 9.1.1's published minimum/default Gradle is 9.3.1, JDK requirement is 17, and its supported Android API ceiling is 37. The app's compileSdk 37 therefore falls within its declared AGP ceiling.
- **Compatibility caveat:** Kotlin's published fully-supported matrix lists KGP 2.2.20–2.2.21 through AGP 8.11.1, not AGP 9.1.1; the AGP 9.1.1 release notes list KGP 2.2.10 as its default. The KGP/AGP pair is therefore outside the KGP table's fully-supported matrix, although no failure is evidenced. Crucially, Build #167 used this identical `settings.gradle`, `gradle.properties` and root `build.gradle` and completed Android Gradle successfully. The current app-module `android/app/build.gradle` blob has since changed, so Build #167 is historical configuration evidence rather than a current-main compile.
- **Disposition:** KEEP / VERIFIED for the current pinned configuration; carry the KGP/AGP fully-supported-matrix caveat into the separately gated Android toolchain review. No plugin, DSL, Gradle wrapper, signing or build workflow change is made here.

## Current disposition

- Inventory coverage: **114/114 tracked blobs** at live main `d5228516e825a3e7b9ae72bcea8239bb90b32d38`; root tree `5260bcbc9bb520975c5d4cfc551938c750c7aafb`; recursive tree **160 entries / 114 blobs / 46 trees**, `truncated=false`. The File inventory has 114 unique rows, no missing/stale/duplicate paths.
- File disposition coverage: **114/114 tracked blobs have explicit KEEP / UPGRADE / PROTECTED / BLOCKED / IMMUTABLE decisions.** This is path coverage only. The full `lib/main.dart`/Dashboard owner and architecture audit remains deliberately OPEN; WP0–WP10 and build readiness are not complete.
- Large-file/source review remains open for `lib/main.dart`, `lib/app_settings.dart`, `lib/settings_pages.dart`, `lib/usage_statistics.dart`, `test/connection_scan_coordinator_test.dart`, `test/firmware_qc_contract_test.dart`, `test/floating_monitor_layout_contract_test.dart`, `test/localization_contract_test.dart`, `test/usage_statistics_test.dart` and `test/widget_test.dart`. Focused edits/tests and a green full suite do not replace full content/owner review.
- `APP_BUILD_REPORT.md` is APPEND-ONLY / READ-ONLY / REVIEWED (2026-11-26); it is not the next unreviewed path. Continue the open `main.dart` Dashboard owner audit and cross-check current consumers against the live tree. The launcher asset's alpha mismatch remains documented/protected; no image edit or asset publication occurred.
- Hosted Validation Only #158 is terminal SUCCESS on exact source/test SHA `f78d6b1294c88cb359b694041ea70dde0042bcd8`: dependencies, formatter (37/0), analyzer and 259/259 tests PASS. Current-main Android/Kotlin compilation, physical API/OEM, screenshot matrix, SQLite v1→v2 runtime fixture and 1h/6h/24h profile remain NOT RUN / NOT VERIFIED. Whole-App visual result remains VISUAL NOT VERIFIED.
- The owner-approved App-only WP0–WP10 work item remains IN_PROGRESS in `WORKSPACE=CODE_FULL`; REPO_FULL follows only after CODE_FULL closes. Build/release, Firmware/BIN, BLE P1 wire/security, OTA, Firebase production, signing and device operations remain excluded.
- Refresh the inventory after any path add/remove/rename; update touched rows; re-check the recursive tree and references before closing a work package.


### WP0 — `APP_BUILD_REPORT.md` — APPEND-ONLY / READ-ONLY / REVIEWED (2026-11-26)

- **Reviewed blob:** `78fd4d18f4d27935d0d7083afb8f818face36145` (706,193 characters). The ledger's latest entry at the top is Build #167 terminal SUCCESS on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`, Actions run `44510421466`, job `135512909555`; the exact APK and corresponding source ZIP hashes, Release/tag parity and fresh-download evidence are recorded there.
- **Role and evidence boundary:** append-only chronology for guarded App Build attempts, source SHAs, workflows/jobs, gates, artifacts, signatures, Release/tag and checksum verification. Historical ACTIVE/QUEUED entries remain in the file as time-scoped snapshots followed by later terminal records; they are not current process state. Live Actions and Release state must always be reconciled independently.
- **Current package interpretation:** Build #167 remains the latest package in the ledger. It is not a build of the current post-release `main` tree and does not validate subsequent WP1/App source changes. The ledger itself records Android Gradle success with native App JUnit tasks NO-SOURCE, retained PKIX/META-INF signing warnings, and whole-App visual acceptance as VISUAL NOT VERIFIED.
- **Disposition:** preserve exactly as append-only evidence. Do not rewrite, reorder, compact, amend historical entries or append Code-workspace audit notes. New Build attempt evidence belongs only to the separately authorized Build App workspace. No ledger content was changed.
- **Acceptance:** latest terminal ledger entry and chronology were checked against the active workspace checkpoint; no current Build App operation is inferred from old ACTIVE labels. No APK/build/release/test operation was started.

### WP0 — `APP_NOTES.md` — UPGRADE / REVIEWED (2026-11-26)

- **Reviewed blob before reconciliation:** `17e7c81e36c63345bf4efceb002440cba9d397d8`; the full App behavior reference was inspected (605 lines before this update), including its Build #167 package snapshot, product identity, Home, BLE/session/P1, telemetry, command/ACK, Usage Statistics, Floating Monitor, OTA presentation boundary, settings and bilingual localization contracts.
- **Finding:** the 2026-11-16 “Live recovery audit” accurately records a severe corruption state at that historical revision but uses a “current source” heading and old byte counts which can be misread as live. Current `lib/main.dart` is 409,357 bytes / 11,627 lines with a single active `TamperApp`, `DashboardScreen` and `_DashboardScreenState`; the prior repeated-declaration/parser failure is no longer present. The latest Build #167 package remains historical relative to current main.
- **Repair:** added a clearly dated current-main reconciliation at the top of `APP_NOTES.md`, explicitly superseding only the historical corruption status, recording the current source blob, the notification acknowledgement persistence guard and the Validation Only #79 evidence. The old incident details remain intact as historical audit evidence.
- **Evidence limits:** #79 is Flutter/Dart Validation Only on its exact source/test SHA. It does not prove Android/Kotlin compilation, device/OEM behavior or visual acceptance. The whole main.dart architecture/content audit remains pending; this note does not mark that file complete.
- **Disposition:** `UPGRADE / REVIEWED`; no App source, test, workflow, Firmware, OTA, Firebase, signing, asset or Release file changed in this documentation update.

### WP0 — `APP_PREBUILD_AUDIT.md` — UPGRADE / REVIEWED (2026-11-26)

- **Reviewed blob before update:** `602d1455647f64daa92aa64acd52af5647efe8a5`; the full 462-line work package was reviewed, including the active owner request, WP0–WP10 sequence, all screen/motion design criteria, architecture and telemetry ownership map, protected exclusions, recovery proposals, quality gates and retained historical planning.
- **Repair:** updated its active preflight with the owner's full-cycle `Eksekusi Code!` expectation, latest repository checkpoint and current main.dart identity. Replaced the stale register count/next-file pointer with the current live register state. Historical source snapshots and earlier Diskusi-only proposals remain labelled and preserved.
- **Acceptance:** all planned packages remain explicitly IN_PROGRESS until their outcomes are implemented and evidenced; no plan text is used as a substitute for tests, Android compilation, screenshot/device evidence or separate Build App authorization. Visual status remains VISUAL NOT VERIFIED.
- **Disposition:** `UPGRADE / REVIEWED`. No executable source, test, workflow, protected Firmware/OTA, asset, APK, Release or signing content changed.

### WP0 — Immutable archive set — IMMUTABLE / HISTORICAL / REVIEWED (2026-11-26)

- `archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md` (`10fab755affdbb8e29727390ad187fcb4bf6817d`, 145 lines): historical artifact-repository direction; retain the owner's BIN-only repository boundary. Never use as current work authorization.
- `archive/CHAT_TRANSFER_PRE_COMPACTION_2026-11-15.md` (`c5bf570e487e805750360215cb75b2c2c6c7fbff`, 723 lines): prior handoff and stale status; retain only as historical record.
- `archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md` (`65ece82c5e8a07908accb4a81bd4c80e469b55de`, 1,482 lines): historical source/contract snapshots, includes old Firmware revisions and superseded context; never copy forward without live-source verification.
- `archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md` (`0438b7006d437d2c24d9e76d6aca7352ad5b0b2b`, 1,057 lines): historical prompt/transfer chronology; no current authority.
- **Disposition:** all four archives remain byte-untouched and immutable. Their historical status/mode text is never allowed to override `MASTER_PROMPT.md`, current `00_WORK_STATUS.md` or live main.

### WP0 — Flutter usage / test / scan / localization / glyph source set — REVIEWED (2026-11-26)

- `lib/usage_statistics.dart` current blob `6c0bb51f2283e9e0a46851962b951ffd820f6ee9` / 3,640 lines: full store, schema/migration, session coverage, HOT freshness, queue, recorder, analytics, summary, decimation and presentation review completed. The Clear History freshness defect was fixed; see `APP_NOTES.md` and CHANGELOG. `UPGRADE / CLOSED`; no schema-version migration or raw-history rewrite.
- `test/usage_statistics_test.dart` current blob `aa5bc741760fe67dec06d4e4f272ffe4f598332e` / 1,248 lines: complete review; regression coverage added for no-HOT coverage and no synthetic Clear History baseline. #82 225/225 PASS. `UPGRADE / CLOSED`.
- `test/widget_test.dart` current blob `b09f0157776997557e30b2ae1d0a8c7c2bf80845` / 4,066 lines: complete review of Home/control/LED/connection/localization/reduced-motion/Floating Monitor/OTA presentation and widget/source contracts. `KEEP / VERIFIED` by #82 Flutter run; not Android screenshot evidence.
- `test/connection_scan_coordinator_test.dart` `6aa7e823560656d1e2b42b194a8cc7a5e497c3d7` / 246 lines: complete generation/lease/serialization/manual handoff coverage review. `KEEP / VERIFIED`.
- `test/connection_scan_state_test.dart` now includes regression coverage for permission/Bluetooth/error precedence and trimmed advertised/platform display names. Validation Only #166 / run `45956791122` / job `140365017067`, exact SHA `b61614a170e6c741fa0280adcc75cf9e7504d075`, terminal SUCCESS; **262/262 tests PASS**. Disposition: UPGRADE / VERIFIED CI.
- `test/firmware_qc_contract_test.dart` `adf12de873a15d3adef784037633629e9fe4a849` / 918 lines: complete static source-contract review. It checks Firmware source contracts only; it does not compile/test Firmware or prove physical behavior. `KEEP / VERIFIED`.
- `test/firmware_touch_adaptive_sync_test.dart` `01185431ec72dde4c14b5e91de396736220707da` / 72 lines: complete Touch/Adaptive/read-only contract review. `KEEP / VERIFIED`.
- `test/localization_contract_test.dart` `30e87d63efaecedd74abd2a72db7ed813db0e8d4` / 279 lines: complete EN/ID keys, labels, placeholders and token review. `KEEP / VERIFIED`.
- `test/app_protocol_notify_contract_test.dart` `fca6877915b9db3a7911527d987e18976bd6faaa` / 39 lines: P1 protocol token and notification source-contract review. `KEEP / VERIFIED`.
- `test/support/source_contract_helpers.dart` `247a9fd6bd811ac84e9878dd81976488ae232bdb` / 27 lines: whitespace-normalizing source contract helper; `KEEP / VERIFIED`.
- `lib/jex_animated_glyph.dart` `9e4fba0fe15744532cedcaba34645018bb04b451` / 26 lines: stateless Phosphor Icon wrapper and RepaintBoundary, no ticker or animation controller; `KEEP / VERIFIED`.
- **Validation:** Validation Only #82 / run `45858238070` / job `140042152884` terminal SUCCESS on source/test SHA `b5b11ac0f37c201b51f1cfb0e816ee56813f1d1b`; formatter-only result is persisted in current main follow-up `8b5b662725cfcf5b5b084209ed97989361148d13`. Entire Flutter suite 225/225 passed, analyzer/formatter/deps passed.

### WP0 — Security, build, OTA and design policy documents — REVIEWED / NO CHANGE (2026-11-26)

- `BLE_APP_AUTH.md` remains BLOCKED: Just Works + SYNC_READY does not cryptographically establish official App identity. The proposed design requires Firmware command gating, per-install Android Keystore proof, trusted enrollment/backend-signed grant, nonce, device binding, expiry and replay protection. Firmware and backend are outside this execution scope; no static/shared APK secret or first-peer trust workaround is acceptable.
- `BUILD_NOTES.md` and Build #167 were reviewed. Build #167 is the latest released package but targets immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`, not current main. Keep the guarded workflow boundary; no Build App was triggered.
- `CHANGELOG.md` was updated at its head with the Clear History/P1 freshness fix and Validation Only #82 evidence; prior entries were not edited.
- `MASTER_PROMPT.md` contains the full-cycle execution command and separate Build App boundary. `MEMORY_INDEX.md` is being reconciled to the live 96-blob inventory and current checkpoint.
- `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md` were read; transport/trust/certificates/redirects/image validation/recovery remain protected and unchanged. Historical `setInsecure()` trade-off is retained, not endorsed as a new secure design.
- `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md` were reviewed; no new brand, font, palette or Home composition was introduced. Actual screenshot acceptance remains `VISUAL NOT VERIFIED`.
- `VOLTAGE_TRANSITION_MEMORY.md` was reviewed; it records two separate user-reported restarts without a verified cause. Firmware is authoritative; no Firmware claim or change was made.

### WP0 — Binary visual assets — PROTECTED / EVIDENCE LIMITATION (2026-11-26)

- `assets/jexfyzicon.png` is byte-identical to the Android launcher bitmap, 1254×1254 RGB with no alpha/tRNS transparency. This conflicts with the transparent-asset statement in design notes. It is left protected pending owner design decision; no artwork was changed.
- `assets/jexfyzcooler.png` is a 2,130,606-byte PNG in the live tree. This Code workspace could not retrieve its binary bytes for direct visual/integrity inspection. The approved product hero is protected; retain unchanged and mark binary visual review BLOCKED rather than infer transparency, silhouette or image quality.



### WP2 — `lib/app_security.dart`, `lib/main.dart` and `test/app_security_test.dart` — UPGRADE / VERIFIED CI / READ-BACK VERIFIED (2026-11-26)

- **Implementation commit:** `b567cf7f51bb99dbcc874686547409519c2b632d`, parent `04300ac69fa22d15ae7d1337cdfc4d6fc846b4ed`. It adds `lib/app_security.dart` as the sole Dart owner of the existing `je_x_fyz/security` MethodChannel and official-install gate. `main.dart` imports the adapter and calls `isOfficialBuild()`; TamperScreen retains `openDeveloperContact`.
- **Fail-closed contract:** non-Android behavior remains allowed as before. Android returns true only for native Boolean `true`; false, null, invalid/missing result or channel exception returns false. Native `MainActivity.isOfficialBuild()`, debug allowance, release certificate comparison, configured signing identity, channel name/method and manifest are unchanged. This is App package-integrity validation, not BLE peer authentication.
- **Regression:** `test/app_security_test.dart` covers non-Android bypass, true, false, null and PlatformException. Tamper-screen widget test imports the channel from the extracted module.
- **Validation Only #86:** run `45865142367`, terminal FAILURE; locked deps, formatter-final and analyzer succeeded; 220 tests passed / 10 failed. Ten legacy widget tests used the removed channel declaration as the painter block end sentinel; the painter remained present and all new AppSecurity tests passed.
- **Regression repair:** commit `59fb624120b01ba505d23691df0928e55eefed3b` replaces the ten brittle delimiters in `test/widget_test.dart` with the real following class boundary `class TamperApp extends StatelessWidget`. Existing painter assertions remain in force.
- **Validation Only #87:** run `45865736407` / job `140067960188`, exact tested SHA `59fb624120b01ba505d23691df0928e55eefed3b`, terminal SUCCESS. Locked dependencies PASS; formatter apply/post-check PASS; analyzer PASS with 106 info-level diagnostics; Flutter tests **230/230 PASS**. Formatter-only follow-up `16b9f78f384011ca59def5e0ac32bb6bc33e4178` changes only `test/app_security_test.dart` and `test/widget_test.dart`.
- **Read-back blobs:** `lib/app_security.dart` `d068875271d0f0ba29b7e60dfb61b1a79d984e0b`; `lib/main.dart` `80360d5d5576bb6487e36ee05f0cac8c120a1a94`; `test/app_security_test.dart` `8dc3421643be284984015834141fe3bc156a9b27`; `test/widget_test.dart` `d6295320db42f2d3d25862b317cefbc2f4afcd63`. No Kotlin, manifest, workflow, signing material, APK, Release, Firmware, OTA or Firebase file changed.
- **Evidence boundary:** Flutter/Dart Validation Only only. No Kotlin/Android compile, device certificate test, screenshot, OEM or physical-device test. Whole-App visual status remains `VISUAL NOT VERIFIED`.


### WP2 / WP3 — Home Notification and LED presentation module extraction — UPGRADE / VERIFIED CI / READ-BACK VERIFIED (2026-11-27)

- **Home Notification extraction:** commit `ef7186ac2f8350f515d911893556c98f33b2b6bd` created `lib/home_notify.dart` from pure localized Home notification, safety notice, OTA summary, legacy notification relocalization and OTA upload-size mismatch presentation helpers previously at the top of `lib/main.dart`. Dashboard still supplies authoritative state and owns BLE/session/OTA orchestration; the module has no transport/storage/native owner.
- **Home Notification regression adaptation:** commit `57b217470439be86912f3ef0dd3bf15876d04e8a` adds the new module to the existing bilingual literal-phrase localization scan without lowering its threshold. Validation Only #88 failed 229/230 because the scan initially omitted the moved source; #89 / run `45872073369` / job `140089761072` passed **230/230** on that exact source.
- **LED presentation extraction:** commit `461561e24fd25518f06ee51aa86eb1dd341d0967` created `lib/led_controls.dart`, moving the LED preset palette, legacy color labels, mode-ID projection, `LedSyncSnapshot`, phase/cycle math, pixel preview, reduced-motion-aware `JexLedStripPreview` and color picker out of `main.dart`. The full moved block was compared against the pre-extraction source: identical except the color-picker widget class became public for cross-library use; `normalizeLedColor` moved without content change. No BLE/GATT, MethodChannel, command queue, P1 readiness or session-owner code exists in the new LED module.
- **LED regression adaptation:** `test/widget_test.dart` now reads LED preview/picker implementation from `led_controls.dart`; `test/firmware_qc_contract_test.dart` imports only `normalizeLedColor` from that presentation module. Validation Only #90 failed 229/230 because one existing Cancel-copy assertion still read `main.dart`; commit `a91ce73d6e7cafbc5a6b04af95fa9d4455c04407` redirects the same assertion to `ledSource`. No assertion was deleted or weakened.
- **Validation Only #91:** run `45873143183` / job `140093397714`, exact source/test SHA `a91ce73d6e7cafbc5a6b04af95fa9d4455c04407`, terminal SUCCESS. Locked dependency resolution, formatter precheck/post-format, analyzer and **230/230 Flutter tests PASS**. Analyzer emitted 107 information-level diagnostics under `--no-fatal-infos`; formatter apply/commit was skipped because formatting was already clean.
- **Read-back source blobs:** `lib/main.dart` `71b06b5537ef2f36d1355a2767cbad8141a4c874` (9,735 lines); `lib/led_controls.dart` `e795122f61ca31fc814a9b4b04840332a33c980f` (965 lines); `test/widget_test.dart` `bbb327323abb7d782f4fcf3c847e045acc4d1ebd`; `test/firmware_qc_contract_test.dart` `212424531b0ca0e49b4389985187246eb0cb0cb8`; `test/localization_contract_test.dart` `30e87d63efaecedd74abd2a72db7ed813db0e8d4`.
- **Evidence boundary:** #89/#91 are Flutter/Dart hosted CI only. No Kotlin/Android compilation, APK build/sign/release, Android screenshot/OEM/device verification, Firmware/BIN, OTA, Firebase production, flash or physical-device operation. Whole-App visual acceptance remains `VISUAL NOT VERIFIED`.

### WP1 — Connection scan state priority and display-name regression — 2026-11-27

- **Scope:** characterization-only regression coverage for the pure connection-scan presentation mapper; no BLE scanner, permission, transport, connection/session or P1 behavior changed.
- **Gaps closed:** assert that explicit Bluetooth/legacy-location unavailability outranks a simultaneous scan error, and assert that non-empty advertisement/platform display names are trimmed before presentation.
- **Files:** `test/connection_scan_state_test.dart`; source remains unchanged.
- **Acceptance:** Validation Only on the exact commit must pass locked dependency resolution, read-only Dart formatting, Flutter analyzer and the complete Flutter suite. This unit coverage does not prove Android permission behavior or real BLE discovery.
- **CI evidence:** Validation Only #166 / run `45956791122` / job `140365017067`, exact commit `b61614a170e6c741fa0280adcc75cf9e7504d075`, terminal SUCCESS: locked dependency resolution PASS, Dart formatter PASS (37 files / 0 changed), analyzer PASS, full Flutter suite **262/262 PASS**.
- **Disposition:** UPGRADE / VALIDATED / READ-BACK PENDING (the test and plan update are committed; exact final read-back follows).

### WP1 — AppSettings preference-model serialization and fallback tests — 2026-11-27

- **Scope:** pure immutable `AppSettings` value-model characterization only. Storage APIs, secure-storage key names, notifier side effects, KnownCooler identity persistence and firmware-notice persistence are not changed or mocked in this test slice.
- **Coverage:** default language/theme/notification/Auto Connect values; complete JSON round-trip; malformed JSON and non-map roots; unknown enum fallback without discarding valid booleans; wrong-typed/missing booleans restoring safe model defaults; `copyWith` preserving explicit `false` values and unspecified fields; default/light/dark Home-vs-Dashboard palette semantics.
- **Files:** new `test/app_settings_model_test.dart`; no production source changes.
- **Validation Only #167:** run `45957071431` / job `140365909777`, exact SHA `e2504ad49d298f76fb6e2184580716ac2b06fead`. Locked dependency resolution, analyzer and the full Flutter suite **273/273 PASS**; overall workflow **FAIL** because read-only formatter reported `38 files (1 changed)`. Inspection found the new test's 83-character test declaration as the sole line beyond the formatter's 80-column layout; correcting that one declaration before re-run. No production source or storage API changed.
- **Acceptance:** exact-commit Validation Only must pass dependency lock, read-only format, analyzer and the full Flutter suite. This does not close the separate plugin-backed `AppSettingsStore` / `KnownCoolerStore` storage-failure integration gap; keys and failure semantics remain protected.
- **Disposition:** UPGRADE / FIX APPLIED — REVALIDATION PENDING.

### WP1 — Connection scan state priority and display-name regression — CI closure

- Three added pure regression tests verify that Bluetooth/legacy-location unavailability wins over a simultaneous scan error and that valid advertisement/platform names are trimmed before presentation.
- Exact evidence: Validation Only #166 / run `45956791122` / job `140365017067` / source SHA `b61614a170e6c741fa0280adcc75cf9e7504d075`, terminal SUCCESS; locked dependencies, formatter (37/0), analyzer and 262/262 Flutter tests PASS.
- No scanner command, Android permission, BLE connection, GATT, P1, or Dashboard ownership behavior changed.


### WP1 — AppSettingsStore and KnownCoolerStore behavioral tests — VERIFIED CI #187 (2026-11-27)

- Added `test/app_settings_store_test.dart`. Seven Flutter tests exercise persisted-settings load/notifier projection; missing-setting defaults; save/read-back and notifier projection; firmware-notice suppression by exact version; known-cooler identity trimming; blank identity as unknown; and normalized save/blank-save/clear semantics.
- Tests use `FlutterSecureStorage.setMockInitialValues()` from the pinned plugin test API. Production storage code, keys, defaults and persisted schema were not changed. Plugin failure/error injection and real Android secure-storage behavior remain open/not verified.
- Validation Only #187 / run `45968056100` / job `140401426317`, exact SHA `1b6b38bddf902a251a385f48f921dad523ae036b`, terminal SUCCESS: locked dependencies PASS; formatter 42/0; analyzer PASS (109 info-level diagnostics under `--no-fatal-infos`); full suite **280/280 PASS**.

### WP5 — Dashboard Home, Control and Temperature presentation parts — VERIFIED CI #187 (2026-11-27)

- `lib/dashboard_home_tab.dart`, `lib/dashboard_control_tabs.dart` and `lib/dashboard_temperature_tab.dart` are Dart library parts of `main.dart`, extracting Home, Voltage/Control/Adaptive/LED and Temperature widget builders. They reuse enclosing Dashboard state and callbacks.
- Static source review found no additional BLE/GATT client, P1 parser/session, MethodChannel, persistence adapter or independent command owner in these parts. Dashboard remains the sole BLE/GATT/P1/session and authoritative telemetry owner.
- The extraction is included in Validation Only #187 and the 280/280 suite passed. This closes source/test compatibility for the split, not final redesign quality, visual acceptance or device behavior. Complete the full Dashboard owner/content audit and screen-specific design contract review before further decomposition.
