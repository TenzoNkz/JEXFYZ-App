## Immediate next step — Guarded QC for Usage Statistics presentation refresh — 2026-11-13

**Current App source is newer than Build #159.** The current Full session has implemented the requested Usage Statistics presentation changes on `main`, but has not run any local or hosted Flutter/Android validation and has not packaged a release.

- UI source: `lib/usage_statistics.dart`, latest code cleanup commit `f32c1278308bea7cedd4f150255d2128cac138bb`; intermediate main UI commits `9b9262d934ff2ab6575256b264f8bf851280dddf` and `364f5c3c1b777606647c3d85777091314988ea7f`.
- Regression source: `test/usage_statistics_test.dart`, latest test commit `b560403877fd2080db2019fc04d86d67020418dd`; test inventory remains **188 declarations across 9 files**.
- Implemented: one elapsed session timer in one header; selector menu excludes secondary duration; Battery/Hotside Y axes have 1°C whole-degree ticks and data-based ranges; Observed/More details/Last sample removed; Min/Avg/Max, four activity lanes and the six-field selected-time dock retained and tidied; EN/ID labels and decimal separators improved.
- Telemetry, raw sample cadence, SQLite schema/retention, queue, session/gap handling, P1 freshness, analytics and Firmware remain unchanged.
- **NOT RUN:** Dart formatter, focused/full Flutter tests, analyzer, Android Gradle, screenshots and device acceptance. The runtime has no Dart/Flutter/Gradle/ADB.
- Build #159 / source `cdca38b9e4f2f99006db8feae40c07c6f9bdfb0a` remains the latest verified APK; this source patch is **NOT RELEASED** and **VISUAL NOT VERIFIED**.
- **Next:** owner separately issues `Eksekusi Build App!` to run the guarded App QC/package process. Do not trigger it from this Full session.

---

## Previous source follow-up — Floating Monitor Fan icon repair — 2026-11-13

**Latest verified package remains Build #159.** The owner reports Firmware V7.2 and Build #159 are installed and the system is safe in use (USER-REPORTED). The latest repository change is newer than that APK.

- **Confirmed defect:** Build #159 Android compiler warned `FloatingMonitorService.kt:738:17 Duplicate branch condition in 'when'`. Two `"F"` branches existed in native `drawIcon()`; the first gauge branch made the later fan-blade branch unreachable.
- **Repair on main:** removed the redundant gauge branch and retained the three-blade Fan icon. Source commit `e0b68c3e98a5d75fe40c71bc0a7647712615c33d`.
- **Regression source:** `test/floating_monitor_layout_contract_test.dart` now requires one unique icon branch for each metric `B/H/V/A/P/F` and checks the Fan glyph. Test commit `aff8b8ec2796d03432f4f8b000f6e70205eccf48`.
- **Release status:** this patch is NOT in Build #159 and has not been packaged. No new Build/Release was triggered.
- **Validation:** local Dart/Flutter/Gradle/ADB are absent. Static GitHub read-back only; test, analyzer and Kotlin compile are NOT RUN. Build #159's old compiler warning is the evidence that motivated the patch, not proof that the new code compiles.
- **Next action:** owner must separately issue `Eksekusi Build App!` to validate current main through the guarded App workflow and publish a new package only if all gates pass. This is a recommendation, not an authorization.

### Remaining repository hardening backlog

- Consider enabling main-branch protection / required checks. GitHub branch metadata currently reports `protected=false`; the integration could not read detailed branch-protection settings.
- Plan a separate reviewed workflow-hardening task to pin third-party GitHub Actions by full commit SHA rather than version tags.
- Review Kotlin 2.2.20 support deprecation and deprecated Gradle property flags before a coordinated Android toolchain upgrade. Do not bump versions without exact-source CI validation.
- BLE App-only identity remains BLOCKED / NOT IMPLEMENTED; do not infer it is solved by successful V7.2 installation or normal BLE bonding.


## Historical App release — Build #157 SUCCESS (superseded by Build #159)

- Actions run [43247876115](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43247876115), job 131285336987, attempt 1; immutable package source SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. All workflow gates 1–21 and cleanup 39–43 passed.
- QC: analyzer **23 infos / 0 warnings / 0 errors**; Flutter **187/187 tests passed**; Android Gradle `BUILD SUCCESSFUL in 3m19s`.
- Native Android JUnit compile/process/test tasks were `NO-SOURCE`; no native Android JUnit cases executed.
- Release ID 403010611 / tag `jexfyz-latest` target exact Build #157 source SHA. Exactly one APK plus one corresponding source ZIP; downloaded hashes, ZIP integrity/source marker and APK V1/V2/V3 + pinned certificate were verified.
- APK: 55,980,123 bytes, SHA-256 `24a42feb2ec8968209ac5dd764c6acb789c09fb0fc9a26df8e7d4bf5e1652aef`.
- Source ZIP: 2,932,445 bytes, SHA-256 `3b6f0a84a760b26587ca39a946f14383f2acee933fb5b30270713a32e6a06`.
- Certificate: RSA 4096, pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 pass. Self-signed/PKIX trust-chain/no-timestamp caveat remains. Android `versionName "Telegram @horizontalzzz"` is preserved.

## Protected boundary

No App Build/Release, Firmware compilation/BIN publication, Firebase change, OTA, flashing, physical device action or hardware validation occurred in this Eksekusi Full task. These remain separately authorized scopes.
