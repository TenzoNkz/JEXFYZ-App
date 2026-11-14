## Immediate next step — Explicit scope for workflow and quality-gate hardening — 2026-11-14

The documentation source-of-truth sync for Build #162 is complete. The current project snapshot is `PROJECT_STATE.md`; the full execution/cross-check evidence is at the top of `CHAT_TRANSFER.md`.

### Completed in the current Eksekusi Full session

- `BUILD_NOTES.md`: Build #162 is now the current verified release record; Build #159 remains below as previous release history.
- `APP_NOTES.md`: current App contracts, 188/188 test evidence and Build #162 device-acceptance boundary are reconciled.
- `DESIGN_NOTES.md`: current Statistics, Peltier and Home-tab contracts reflect Build #162's 188/188 hosted test result; visual acceptance remains pending.
- `APP_PREBUILD_AUDIT.md`: superseded pre-Build #162 snapshots and obsolete trigger instructions are marked historical and linked to the verified #162 result.
- `PROJECT_STATE.md`: condensed to a current-only snapshot below 100 lines. Build failure/attempt history remains in `APP_BUILD_REPORT.md`; immutable archives and history ledgers were not deleted or rewritten.

### Remaining confirmed work

1. **P1 release concurrency defect:** the current workflow still has workflow-level `concurrency.group: jexfyz-cooler-build` and `cancel-in-progress: true`, before the owner/title/body-token job guard. Move concurrency into the guarded `jobs.build`; do not cancel a running release. Explicitly choose queue policy; use `queue: max` if every valid trigger must queue FIFO (up to 100 pending). Preserve the manual owner/title/token guard and every release gate.
2. **P2 lint/format baseline:** root `analysis_options.yaml` is absent while `flutter_lints` is declared. Add the documented include, stage the new diagnostics, normalize formatting and then add a formatter gate.
3. **CI/governance:** add non-publishing validation CI, meaningful BLE/MethodChannel/SQLite migration tests, a persisted coverage baseline and reviewed full-SHA action pinning. Consider branch protection after validation checks are stable.
4. **Source modularization:** defer broad extraction until regression coverage is strengthened. Start with low-coupling boundaries; BLE coordinator is high-risk and should be last.

### Authorization boundary

This session changed Markdown documentation only. The command `Eksekusi Full!` selects the implementation mode but does not expand an unspecified scope. The workflow and root analyzer configuration were therefore left unchanged because this turn did not explicitly authorize those CI/configuration files. To continue, owner must explicitly authorize:
- `.github/workflows/jexfyz-app-build-trigger.yml` concurrency policy;
- adding root `analysis_options.yaml` and any related non-publishing validation workflow, if included.

No Build App/APK/Release, Firmware compile/BIN/Firebase/OTA/flash, or device operation is authorized here. Any package/release must still use the separate `Eksekusi Build App!` path.

---

## Historical pre-Build #162 source follow-up — Usage Statistics presentation refresh — 2026-11-13

**Historical state before Build #162:** the current source contained the Usage Statistics refresh but had not yet passed guarded App QC. Build #162 subsequently validated and packaged it.

- UI source: `lib/usage_statistics.dart`, latest code cleanup commit `f32c1278308bea7cedd4f150255d2128cac138bb`; intermediate main UI commits `9b9262d934ff2ab6575256b264f8bf851280dddf` and `364f5c3c1b777606647c3d85777091314988ea7f`.
- Regression source: `test/usage_statistics_test.dart`, latest test commit `b560403877fd2080db2019fc04d86d67020418dd`; test inventory remains **188 declarations across 9 files**.
- Implemented: one elapsed session timer in one header; selector menu excludes secondary duration; Battery/Hotside Y axes have 1°C whole-degree ticks and data-based ranges; Observed/More details/Last sample removed; Min/Avg/Max, four activity lanes and the six-field selected-time dock retained and tidied; EN/ID labels and decimal separators improved.
- Telemetry, raw sample cadence, SQLite schema/retention, queue, session/gap handling, P1 freshness, analytics and Firmware remain unchanged.
- **At that snapshot:** Dart formatter, tests, analyzer and Android Gradle were not run locally because the runtime lacked the toolchain. **Subsequent resolution:** Build #162 passed Flutter 188/188, analyzer and Android Gradle; the workflow still has no Dart formatter gate. Screenshots/device acceptance remain unverified.
- **Subsequent resolution:** Build #162 / source `6854d8eb58a5f077cbc99749a35d37a4f55b8efa` packages this source state. It is VERIFIED CI / RELEASE SUCCESS; actual visual/device acceptance remains **NOT VERIFIED**.
- The historical next step was completed by the separately authorized Build #162. No new Build App is required for the already packaged immutable source.

---

## Historical pre-Build #162 source follow-up — Floating Monitor Fan icon repair — 2026-11-13

**Historical state before Build #162:** Build #159 was the latest verified package when the Fan icon repair was made. The owner reported Firmware V7.2 and Build #159 installed and safe in use (USER-REPORTED); this remains a report about that earlier version, not proof of Build #162 installation.

- **Confirmed defect:** Build #159 Android compiler warned `FloatingMonitorService.kt:738:17 Duplicate branch condition in 'when'`. Two `"F"` branches existed in native `drawIcon()`; the first gauge branch made the later fan-blade branch unreachable.
- **Repair on main:** removed the redundant gauge branch and retained the three-blade Fan icon. Source commit `e0b68c3e98a5d75fe40c71bc0a7647712615c33d`.
- **Regression source:** `test/floating_monitor_layout_contract_test.dart` now requires one unique icon branch for each metric `B/H/V/A/P/F` and checks the Fan glyph. Test commit `aff8b8ec2796d03432f4f8b000f6e70205eccf48`.
- **Subsequent resolution:** Build #162 / source `6854d8eb58a5f077cbc99749a35d37a4f55b8efa` included and packaged this correction; the Build #162 Android Gradle and 188/188 Flutter gates passed.
- **At the time:** local Dart/Flutter/Gradle/ADB were absent, so that source session had only static read-back. **Subsequent resolution:** Build #162 compiled the Kotlin change and passed analyzer, 188/188 Flutter tests and Android Gradle. Actual phone/OEM behavior remains separate.
- The historical next action was completed by the owner's separate Build #162 authorization. No additional Build App is needed for this immutable package.

### Remaining repository hardening backlog

- Consider enabling main-branch protection / required checks. GitHub branch metadata currently reports `protected=false`; the integration could not read detailed branch-protection settings.
- Plan a separate reviewed workflow-hardening task to pin third-party GitHub Actions by full commit SHA rather than version tags.
- Review Kotlin 2.2.20 support deprecation and deprecated Gradle property flags before a coordinated Android toolchain upgrade. Do not bump versions without exact-source CI validation.
- BLE App-only identity remains BLOCKED / NOT IMPLEMENTED; do not infer it is solved by successful V7.2 installation or normal BLE bonding.


## Historical App release — Build #157 SUCCESS (superseded by Build #162)

- Actions run [43247876115](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43247876115), job 131285336987, attempt 1; immutable package source SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. All workflow gates 1–21 and cleanup 39–43 passed.
- QC: analyzer **23 infos / 0 warnings / 0 errors**; Flutter **187/187 tests passed**; Android Gradle `BUILD SUCCESSFUL in 3m19s`.
- Native Android JUnit compile/process/test tasks were `NO-SOURCE`; no native Android JUnit cases executed.
- Release ID 403010611 / tag `jexfyz-latest` target exact Build #157 source SHA. Exactly one APK plus one corresponding source ZIP; downloaded hashes, ZIP integrity/source marker and APK V1/V2/V3 + pinned certificate were verified.
- APK: 55,980,123 bytes, SHA-256 `24a42feb2ec8968209ac5dd764c6acb789c09fb0fc9a26df8e7d4bf5e1652aef`.
- Source ZIP: 2,932,445 bytes, SHA-256 `3b6f0a84a760b26587ca39a946f14383f2acee933fb5b30270713a32e6a06`.
- Certificate: RSA 4096, pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 pass. Self-signed/PKIX trust-chain/no-timestamp caveat remains. Android `versionName "Telegram @horizontalzzz"` is preserved.

## Protected boundary

No App Build/Release, Firmware compilation/BIN publication, Firebase change, OTA, flashing, physical device action or hardware validation occurred in this Eksekusi Full task. These remain separately authorized scopes.
