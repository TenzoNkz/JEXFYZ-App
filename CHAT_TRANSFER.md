<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — SOURCE VALIDATED / BUILD APP PREFLIGHT BLOCKED — 2026-11-16

## Session and authorization
- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current mode: `Eksekusi Full!` — owner explicitly authorized source recovery, regression repair, and non-publishing validation.
- **Source/test validation: COMPLETED; Build App readiness: BLOCKED.** Validation Only #38 passed all Flutter/source gates, but a stale exact-string assertion in the guarded Build App workflow will fail its pre-build architecture audit. Do not trigger Build App until the workflow check is reconciled.
- This Diskusi did not modify executable source, tests, configuration or workflows, and did not trigger Build App. App Build/release requires a separate explicit Eksekusi Build App!; Firmware, BIN, Firebase, OTA, flashing and physical-device operations remain outside this scope.

## Build App readiness assessment (Diskusi, 2026-11-16)

**Decision: NOT READY TO TRIGGER BUILD APP YET.** Flutter/source validation is green, but the guarded Build App workflow contains one deterministic stale static-audit assertion that will fail before APK build.

- Validation Only #38 / run 43843348889 / job 133217253810 passed on tested source SHA 01cf1295458564820b52afc6ca33037583a430c6: locked dependencies PASS; formatter applied five Dart-file formatting changes and final formatter check PASS; analyzer PASS (107 info-level findings; no warning/error gate failure); Flutter tests 200/200 PASS; formatter-preview upload and formatter-only commit PASS.
- The exact formatted source/test tree was committed by the workflow as b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da. Later main commits in this discussion are documentation/status only and do not change those source/test blobs.
- Compared with Build #163 package source 9466e8eeb269da5bc8806f0df1d4212cf24e1746, current main is 147 commits ahead / 0 behind and changes 20 paths: 10 project-memory documents, 2 Android Kotlin files, 4 Flutter source files and 4 test files. Build workflow, Pub dependencies/lockfile, Android Gradle configuration and manifest are unchanged.
- **Blocking mismatch:** .github/workflows/jexfyz-app-build-trigger.yml blob 41c0b7c1f18c0e2d0aa30028c7fc0e8f0554e4ba, line 222, expects the old Fan Speed native text using data.speed.toString() without a percent suffix. Live FloatingMonitorService.kt:609 emits the speed with %. The matching Dart regression test already expects the percent suffix. The Python audit raises 'JE X FYZ audit failed; Floating metric F must display Fan Speed' and exits at workflow step 10, before analyzer, Flutter tests, Gradle and APK steps. This is deterministic, not speculative.
- Read-only reconstruction of the other explicit static audit checks found required tokens present, no legacy command/asset/Firebase/Shizuku/weak-password-storage patterns, dedicated Flutter/native MethodChannel contracts present exactly once, metric migration contract present, R8/resource shrinking and embedded signing-certificate marker present, all required assets present, and no executable Dart Firmware import. The Fan Speed exact-string assertion is the one confirmed mismatch.
- Build App workflow guard remains issue-only: issues.opened / issues.reopened; job requires issue author = repository owner, exact title 'JE X FYZ — EKSEKUSI BUILD APP TRIGGER', exact body token 'JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1'. The release job is serialized with cancel-in-progress false / queue max; there is no push/PR shortcut.
- Existing Build #163 / run 43679305537 is terminal SUCCESS but packaged older source 9466e8eeb269da5bc8806f0df1d4212cf24e1746. Release ID 403010611, tag jexfyz-latest and its APK/source ZIP assets currently point to that older package. A future successful guarded build will update the existing Release/tag/assets.
- Issue #40 remains OPEN and was already consumed to trigger Build #163. Do not reuse or reopen it. No new Build run is active; no Build App trigger was created in this Diskusi.
- Android Gradle versionName 'Telegram @horizontalzzz' and Flutter version 1.0.0+3 remain unchanged. Signing-secret values are not inspectable in this review; the workflow checks the four required values at runtime. Build #163 passed that check on 2026-11-15, but current secret presence is not independently re-proven here.
- Remaining non-CI evidence: visual/OEM acceptance, owner installation, BLE field behavior, long-session CPU/memory/storage soak, Firmware/BIN provenance, Firebase, OTA/flash, thermal and electrical acceptance. Validation Only #38 does not establish these.

### Next safe sequence
1. A new explicit Eksekusi Full! may authorize the one-line workflow static-audit correction plus narrow static verification; do not trigger Build App in that mode.
2. Once the stale audit matcher is reconciled and read back, use a separate explicit Eksekusi Build App! command. Only then create one new owner-authored issue with the guarded title/token and monitor exactly one resulting Build run.
3. Do not modify protected app version values, weaken other workflow gates, or touch Firmware/BIN/Firebase/OTA/device operations.

## Owner-approved contracts — still authoritative
- English is the master/default language; Indonesian must be complete, natural and semantically equivalent.
- General glossary includes Battery → Baterai; Battery Temperature → Suhu Baterai; generic Hotside component references → Sisi Panas; Hotside Temperature → Suhu Sisi Panas; Hotside Limit → Batas Suhu Sisi Panas; generic cooler → pendingin; Adaptive Mode → Mode Adaptif; Fan → Kipas; Fan Speed → Kecepatan Kipas; Voltage → Tegangan.
- Exact Adaptive profile labels: EN `Hotside Protection` / ID `Perlindungan Suhu Panas`; EN `Hotside & Battery Protection` / ID `Perlindungan Suhu Panas & Baterai`. Preserve active keys `hotsideProtection`, `hotsideBattery` and legacy aliases `hSideProtection`, `hSideBattery`.
- Remove the visible Adaptive ceiling card only; preserve `adaptiveCeiling`, `ADAPTIVE_CEILING` telemetry/state, Firmware clamp, Lock Voltage and safety/transition behavior.
- Keep LED as the section heading and RGB Power / Daya RGB as the user RGB-effect toggle. Independent voltage/system/safety indicators remain separate.
- Preserve Bluetooth, Firmware, Peltier, LED, OTA, SSID and BLE protocol tokens where technically appropriate; never translate protocol values or storage keys.
- Battery threshold roles: 5 V is the upper-temperature ceiling; 12 V is the lower-temperature floor. Existing defaults and hysteresis must not change.

## Restored source and regression checkpoint
- Clean baseline used: `lib/main.dart` blob `48dd0c943075db076769c3d9dc53b8b71a28a5c3`.
- Restored/repaired source commit: `b4558cee8b5a4455603473d31e46b3b108f20576`; final `lib/main.dart` blob `b12ea764b674b79f8a19bd70191fcf25ea3046a5`, 401,983 characters / 11,427 lines.
- Verified one active declaration each for `LedColorPreset`, `TamperApp`, and `DashboardScreen`; the previous four-copy duplication and malformed source fragments are gone.
- Reapplied once: locale-aware comma/dot Home temperature parsing; localized Hotside threshold notices and Peltier re-arm copy; legacy Home notice normalization (including spaced/unspaced °C); locale-grouped OTA received/expected byte values; localized Adaptive profile telemetry notice.
- Removed only the visible Adaptive ceiling card/readout. `adaptiveCeiling` state and `ADAPTIVE_CEILING` telemetry mapping remain; no Firmware or BLE protocol code was changed.
- Validation repair commits: `1e269a664e7ce4e006af6e6caba34e70cb6e7eea` removed unused `fixed`/`localized` locals and corrected Fan Speed/locale-aware size assertions; `ca0dbd2b927190715ae5aecee69fac5ce9b8ce84` replaced a stale one-line max-label assertion; `01cf1295458564820b52afc6ca33037583a430c6` changed it to a regex that tolerates Dart formatter line wrapping while preserving the exact `JexText.formatNumber(1.00, ...)` contract.
- Formatter commit generated by the successful hosted workflow: `b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da`, message `style: format Dart sources and tests`.

## Hosted Validation Only evidence
- Earlier #34 / run `43837117020` / job `133196401001` and #35 / run `43837240360` / job `133196812177` failed due to one unused-local analyzer warning and stale test expectations.
- Intermediate #36 / run `43842484678` and #37 / run `43842896647` each failed with 199 tests passed / 1 failed because the Floating Monitor max-label assertion assumed one-line formatting.
- **Validation Only #38 / run `43843348889` / job `133217253810` — SUCCESS**, tested source SHA `01cf1295458564820b52afc6ca33037583a430c6`.
  - Locked dependencies: PASS.
  - Formatter pre-check found formatting changes in 5 Dart files; formatting apply and final check: PASS.
  - Flutter analyzer: PASS.
  - Flutter tests: **200/200 PASS**.
  - Formatter preview upload: PASS.
  - Formatter-only commit: PASS, creating `b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da`.
- Workflow #38 ran the formatter, analyzer and test suite in the same working tree before committing its format-only patch. A separate subsequent Validation Only run is not present for the auto-formatter commit SHA; the current main head is that exact auto-committed formatter result.
- Direct Actions runs lookup exposes push runs; prior notes claiming the available lookup was limited to PR runs are superseded.

## Final repository state and remaining boundaries
- Verified source/test tree commit: `b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da`; subsequent main commits only synchronize canonical documentation/status and preserve the source/test blobs validated in #38.
- Verified recursive tree: 139 entries, `truncated=false`. Relevant source/test read-backs confirm the unused local is gone, Fan Speed assertion includes the live percent suffix, and the size/max-label assertions verify locale-aware formatting.
- The local runtime has no Dart/Flutter SDK; validation evidence is from hosted GitHub Actions only.
- Latest verified package remains Build #163 / run `43679305537` / Release `403010611` / tag `jexfyz-latest`, source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`; it predates restored changes. No new APK, App Build or Release was created.
- Visual/OEM acceptance at 350-dp/360-dp, actual owner installation, BLE field behavior, Firmware compile/BIN provenance, thermal/electrical tests, Firebase, OTA/flash remain unverified.
- Any App Build/package/release requires a separate explicit `Eksekusi Build App!` command; Firmware/device work remains outside scope.
<!-- ACTIVE_CHECKPOINT_END -->