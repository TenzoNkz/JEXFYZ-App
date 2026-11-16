<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — BUILD #164 RELEASE VERIFIED / BLUETOOTH NAME DISPLAY FIX VALIDATED — 2026-11-16



## Current session and authorization

- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: TenzoNkz/JEXFYZ-App / main.
- Mode: Eksekusi Build App! — guarded App Build/QC/release only; no Firmware/BIN/Firebase/OTA/flash/device operations.
- **Current interaction/work item: COMPLETED.** Build #165 completed every required App Build/QC/release gate, published the APK and matching source ZIP, and passed fresh downloaded-asset verification. External operation status is COMPLETED / SUCCESS.
- Latest release: Build #165 / run 43905426531 / job 133432846684 / Issue #42 / source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d; Release ID 403010611 / tag jexfyz-latest. Build #164 is superseded as latest package, but its history remains intact.

## Bluetooth device-name correction — included in Build #165

- The Connection row displays the current advertisement local name first, platform device name second, and localized generic Device / Perangkat only if both are empty. The previous UI mapping no longer hides JE X FYZ.
- Firmware V7.2 source already declares BLE_NAME = JE X FYZ and initializes the BLE stack with it. No Firmware source/BIN or BLE protocol change was made.
- Validation Only #44 / run 43899329198 / job 133411358928: formatter final PASS; analyzer 107 infos / zero warnings/errors; Flutter tests 205/205 PASS; formatted source/test tree 0a2b3c03af433a17d82afa1d4db60beb7b1bd023.
- Build #165 source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d compares 17 commits ahead / 0 behind that validated source/test tree; changes are documentation-only. No App source/test change occurred after Validation Only #44.
- **Physical verification remains NOT DONE:** owner must install the Build #165 APK and confirm the actual cooler advertisement and App Connection row display JE X FYZ. CI/source tests do not prove phone/cooler radio behavior.

## Build #165 — terminal SUCCESS / verified release

- Exactly one owner-authored Issue #42 with exact guarded title/token; no older issue reused/reopened. Run 43905426531, workflow 374946166, attempt 1; job 133432846684; terminal SUCCESS at 2026-11-16T16:23:29Z; source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d.
- Workflow: all steps 1–21 and cleanup 39–43 SUCCESS. Full terminal log: 374,121 characters / 3,552 lines.
- Analyzer: flutter analyze --no-fatal-infos PASS, 107 info-level findings, zero warnings/errors. Flutter tests: 205/205 PASS.
- Android Gradle: BUILD SUCCESSFUL in 3m20s; 162 actionable tasks (161 executed, 1 up-to-date); native App JUnit tasks NO-SOURCE.
- Obfuscated APK: JEXFYZ-release.apk, 55,881,819 bytes, SHA-256 1934f9223ea4d5ffbd540601c69157d13923b996c41cf0694128e19372809687, asset ID 755548795. V1/V2/V3 true, one signer, pinned certificate fingerprint dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0, expected JE X FYZ DN. Certificate is self-signed; PKIX trust-chain and META-INF signature-coverage warnings remain.
- Matching source ZIP: JEXFYZ-corresponding-source.zip, 2,945,408 bytes, SHA-256 6f98df3633c00d74a7687697a3332a16606d7edea76f82d1a00d8d201e82bd29, asset ID 755548797. Internal source marker exactly matches cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d; ZIP integrity passed.
- Release ID 403010611 / tag jexfyz-latest; Release target, Git tag ref and source marker exactly equal cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d. Exactly one APK + one source ZIP. Step 21 freshly downloaded both; checksums matched Release API digests, ZIP integrity passed, and downloaded APK V1/V2/V3 plus pinned certificate passed.
- Flutter version 1.0.0+3; Android Gradle versionName Telegram @horizontalzzz. No GitHub Actions artifacts; both deliverables are Release assets.
- Warnings retained: Kotlin 2.2.20/Firebase KGP compatibility, Android Gradle property and Gradle 10 deprecations, deprecated Notification priority, native ELF DWARF visibility, self-signed PKIX/META-INF coverage and native Android test NO-SOURCE. These did not fail gates and are not marked fixed.
- No Firmware compilation, BIN, Firebase, OTA, flashing or device operation was performed.

## Exact next action

- Owner-side next step: install the Build #165 APK from the Release and confirm the Bluetooth Connection row displays JE X FYZ from the real cooler. Record device/OEM/real-radio evidence separately from hosted CI.
- No new Build App trigger is needed unless future App source changes are explicitly requested and validated. Firmware/BIN/Firebase/OTA/flash/device operations require separate authorization.

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