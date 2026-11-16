<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — BUILD #164 COMPLETED / RELEASE VERIFIED — 2026-11-16

## Session and authorization
- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: TenzoNkz/JEXFYZ-App / main.
- Mode: Eksekusi Build App! — guarded App Build/QC and release only. No Firmware/BIN/Firebase/OTA/flashing/device operations were performed.
- SESSION STATUS: COMPLETED. WORK STATUS: COMPLETED. EXTERNAL OPERATION STATUS: COMPLETED / SUCCESS.

## BUILD #164 — TERMINAL SUCCESS / RELEASE VERIFIED

- Owner trigger: Issue #41, created by TenzoNkz with the exact required title and body token. Exactly one issue-event Build run was produced.
- Run: 43863417641; workflow 374946166; attempt 1; source/checkout SHA a41baaf3bc53a02d72e12a4f3840f0c84c493497. Run completed SUCCESS at 2026-11-16T12:11:32Z. Job build / 133285765871 completed SUCCESS at 12:11:31Z.
- All explicit gates 1–21 and cleanup steps 39–43 are SUCCESS. Analyzer: 107 infos, zero analyzer warnings/errors. Flutter tests: 200/200 passed. Android Gradle unit-test gate: BUILD SUCCESSFUL in 2m35s, with app:testDebugUnitTest marked NO-SOURCE (no native Android JUnit tests were present).
- APK: JEXFYZ-release.apk, 55,881,819 bytes, SHA-256 6553af0d07162e804bea838cbd1c391432471630db0de6d56bdd303c713eaa8c. Obfuscated release build used --obfuscate and split debug symbols.
- Signing: V1/V2/V3 all true; one RSA-4096 signer; exact pinned certificate DN CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID; certificate SHA-256 dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- Matching source ZIP: JEXFYZ-corresponding-source.zip, 2,944,808 bytes, SHA-256 1c15f4bc5bfe112594212f42eea925514a7ab138071915c9fe486f6c909bb576; archive integrity passed and embedded source SHA matches the APK.
- Release ID 403010611; release page https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest; tag jexfyz-latest, tag target and Release target all match package source SHA a41baaf3bc53a02d72e12a4f3840f0c84c493497. Exactly two assets exist, one APK and one source ZIP; step 21 re-downloaded both and passed byte-identity SHA-256 checks and APK signing verification.
- Android Gradle versionName Telegram @horizontalzzz unchanged; Flutter version 1.0.0+3.
- Residual warnings: self-signed signing certificate causes PKIX trust warnings; no signature timestamp (certificate expires 2054-02-05); upstream META-INF entries are not covered by the APK signer; Kotlin 2.2.20 / Firebase KGP future Flutter compatibility warning; Gradle 10 deprecation warning; native ELF DWARF visibility warning. All required current signing checks passed; none of these follow-up warnings were altered or represented as fixed.
- Hosted CI does not prove physical installation, OEM visual acceptance, BLE field behavior, Firmware/BIN, Firebase, OTA, flashing, thermal or electrical acceptance. Those remain separate and unverified.

## Next action and authorization
- No further Build App action is pending. The current work item and its external Actions operation are COMPLETED / SUCCESS.
- Retain Release jexfyz-latest as the current package. Any future source change or new build requires the appropriate owner-selected mode and a new guarded trigger; never reuse Issue #41 or older trigger issues.
- Firmware compilation/BIN generation/publication/replacement, Firebase mutation, OTA, flashing and device operations remain outside this Build App authorization.

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
- Latest verified package is Build #164 / run `43863417641` / Release `403010611` / tag `jexfyz-latest`, source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`; both Release assets passed downloaded identity, checksum and signing verification.
- Visual/OEM acceptance at 350-dp/360-dp, actual owner installation, BLE field behavior, Firmware compile/BIN provenance, thermal/electrical tests, Firebase, OTA/flash remain unverified.
- Build #164 CI/release closure is complete. Physical install/OEM visual, BLE/field behavior, Firmware/BIN, Firebase, OTA/flash, thermal and electrical acceptance remain unverified and outside this mode.
<!-- ACTIVE_CHECKPOINT_END -->