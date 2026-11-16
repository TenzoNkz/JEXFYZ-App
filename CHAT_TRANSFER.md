<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — SOURCE/TEST VALIDATED / BUILD APP PREFLIGHT READY — 2026-11-16

## Session and authorization
- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current mode: `Eksekusi Full!` — owner authorized the narrow Build App preflight workflow assertion repair and canonical readiness synchronization.
- **Authorized work: COMPLETED.** The stale Step 10 Fan Speed assertion now matches live native output; the full static contract review found no remaining deterministic preflight blocker.
- No App Build/APK/Release was triggered or published in this mode. Firmware, BIN, Firebase, OTA, flashing and device operations remain outside scope.

## Build App readiness decision

**READY FOR A SEPARATELY AUTHORIZED GUARDED APP BUILD/QC RUN — NOT YET BUILT OR RELEASED.**

- Validation Only #38 / run `43843348889` / job `133217253810` — SUCCESS, tested input SHA `01cf1295458564820b52afc6ca33037583a430c6`. Locked dependencies PASS; formatter applied five Dart-file changes and final formatter check PASS; analyzer PASS (107 info-level findings; `--no-fatal-infos` exited successfully); Flutter tests **200/200 PASS**; formatter preview/upload and formatter-only commit PASS.
- The workflow committed its formatted working tree as source/test baseline `b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da`. The App source/test blobs remain unchanged after that commit; this repair changes only the guarded Build workflow.
- Build workflow correction: commit `4ea1f6ff465d4514325778454e59fbd4644c4bfc`, workflow blob `af342fc21e5c0ff0815628dfacec65ae519f69ae`. The Step 10 audit now checks the exact live native Fan Speed output with `%` in `FloatingMonitorService.kt:609`, consistent with the regression expectation. This fixes an obsolete source assertion only; production behavior was not changed.
- Static reconstruction of the full pre-build Python audit passed: required protocol/security tokens present; legacy commands/assets/Firebase references absent; Flutter/native Floating Monitor MethodChannel contracts and method uniqueness intact; obsolete FPS/Shizuku paths and bridges absent; migration markers present; R8/resource shrinking and signing-certificate marker present; required App assets present; no Firmware source imports or unused `shared_preferences` declaration.
- Full guarded-workflow structure passed static assertions: only `issues.opened` / `issues.reopened` trigger; repository-owner author, exact issue title and body token remain mandatory; job-level queue uses `cancel-in-progress: false` and `queue: max`; no push/PR/workflow-dispatch bypass; all 20 explicit workflow gate steps (steps 2–21) remain present, including dependency, analyzer, Flutter tests, Android Gradle, obfuscated APK, V1/V2/V3 signing, certificate pin, source ZIP, Release/tag parity, exactly two assets and fresh downloaded-byte verification.
- Toolchain labels remain Flutter `3.47.2` and Gradle `9.3.1`. Flutter package version remains `1.0.0+3`; Android Gradle `versionName "Telegram @horizontalzzz"` is unchanged. Four production signing secrets are checked for non-empty values by the workflow; their present-day values cannot be inspected here.
- Latest published package remains Build #163 / run `43679305537` / job `132706236782`, Release ID `403010611`, tag `jexfyz-latest`, source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`. It predates the restored/validated source; its APK and source ZIP remain the current published baseline until a new guarded run passes every release gate.
- Trigger Issue #40 remains OPEN and was already consumed for Build #163. Do not reuse or reopen it. No new Build run/trigger/issue was created in this `Eksekusi Full!` interaction.
- Environment caveat: local `flutter`, `dart` and `actionlint` are unavailable. Flutter/source evidence is hosted Validation Only #38; the changed workflow line was statically inspected and checked against the native source. No guarded Build workflow run has yet exercised the updated Step 10.
- Residual non-CI acceptance: owner installation and screenshots/OEM visual review, BLE field behavior, long-session device CPU/memory/storage soak, Firmware/BIN provenance, Firebase, OTA/flash, and thermal/electrical acceptance are NOT VERIFIED. Prior Build #163 self-signed certificate/PKIX, Gradle/Kotlin deprecation and native ELF DWARF warnings remain documented. External Actions use major-version tags rather than immutable commit SHAs; no pinning change was made in this narrow repair.

## Next action and authorization
- The repository is ready for a separate explicit `Eksekusi Build App!` command.
- Only in that mode should one fresh owner-authored issue be created with exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; do not reuse Issue #40.
- Monitor exactly one resulting Build run; stop on the first failed required gate and never weaken checks or retry blindly.
- No Firmware/BIN/Firebase/OTA/flash/device operation is authorized by this checkpoint.

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