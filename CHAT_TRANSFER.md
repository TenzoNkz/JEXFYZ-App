<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — BUILD #164 RELEASE VERIFIED / BLUETOOTH NAME DISPLAY FIX VALIDATED — 2026-11-16



## Current session and authorization

- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current owner mode: `Eksekusi Build App!` — guarded App Build/QC/release and justified App-scope repairs only.
- Current SESSION STATUS is IN_PROGRESS. Current WORK ITEM: package the latest App Bluetooth device-name correction, which has hosted formatter/analyzer/test validation but is not yet included in the published APK.
- No Firmware compilation, BIN generation/publication/replacement, Firebase mutation, OTA, flashing, device operation or unrelated release work is authorized.

## Bluetooth display-name correction — source/test validated

**Expected App behavior:** the Bluetooth Connection row displays `JE X FYZ`, not the localized generic fallback `Perangkat`.

- Firmware V7.2 tracked source already defines `BLE_NAME = "JE X FYZ"` and initializes the BLE peripheral with `BLEDevice::init(BLE_NAME)`; no Firmware edit was needed or made.
- App root cause: the Connection row selected `platformName` before `advName`, then hid even the true `JE X FYZ` name behind `JexText.of('device', lang)`.
- `lib/connection_scan_state.dart` adds `connectionDeviceDisplayName(...)`: trimmed current advertisement name first, platform name second, localized generic fallback only when both are empty. `lib/main.dart` uses that helper.
- Tests cover advertisement precedence, stale platform name, platform fallback, localized empty fallback, and Connection sheet contract. BLE UUIDs/service filter, scanner ownership/generation, connection handoff, P1 framing/session rules and Firmware source remain unchanged.
- Real phone/cooler BLE advertisement and display remain NOT VERIFIED pending owner installation and device check.

## Latest source/test validation — Validation Only #44

- Run `43899329198` / job `133411358928`, tested input SHA `4a875b3d63beea6e7d469c27f0c8930ab9b7cd09`, terminal SUCCESS.
- Locked dependencies PASS; Dart formatter final PASS (18 files checked, two test files formatted in runner workspace); analyzer PASS (107 info-level findings, zero warnings/errors); Flutter tests **205/205 PASS**.
- Formatter-only output/source-test tree: `0a2b3c03af433a17d82afa1d4db60beb7b1bd023`.
- Comparing that source/test tree to pre-trigger main found 12 documentation-only commits; no App source/test, Android Gradle, dependency, asset or workflow input changed after validation. Local Flutter/Dart are unavailable; hosted CI is the validation evidence.
- Validation Only #40–#43 were earlier attempts with documented formatter guard/test-boundary failures; #44 is the successful result. Do not repeat #44.

## Current published baseline — Build #164

- Build #164 / run `43863417641` / job `133285765871` / Issue #41 / source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`, terminal SUCCESS. Steps 1–21 and cleanup 39–43 all SUCCESS.
- Analyzer 107 infos; Flutter tests 200/200; Android Gradle BUILD SUCCESSFUL in 2m35s. Native Android JUnit tasks were NO-SOURCE.
- Release ID `403010611`, tag `jexfyz-latest`, target source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`. Exactly one APK and one matching source ZIP; both re-downloaded hashes, source marker and APK V1/V2/V3 + pinned certificate verification passed.
- APK SHA-256 `6553af0d07162e804bea838cbd1c391432471630db0de6d56bdd303c713eaa8c`; source ZIP SHA-256 `1c15f4bc5bfe112594212f42eea925514a7ab138071915c9fe486f6c909bb576`. This package predates the Bluetooth name correction and remains the published baseline until the next run passes every gate.
- Retain Build #164 warnings: self-signed/PKIX and META-INF signing coverage, no signing timestamp, Kotlin/Firebase KGP compatibility, Gradle deprecations and native ELF DWARF; native Android JUnit tasks NO-SOURCE. Do not rewrite these as resolved.

## Build #165 — Android Gradle passed; APK build active

- Exactly one fresh Issue #42 triggered run `43905426531` / job `133432846684`, attempt 1, source `cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d`.
- **Steps 1–14 SUCCESS.** Android Gradle Step 14 completed SUCCESS at `2026-11-16T16:19:46Z` (3m21s elapsed).
- **Step 15 `Build latest release APK` IN_PROGRESS.** Steps 16–21 (V1/V2/V3/certificate, filename, source ZIP, Release/tag and downloaded asset verification) are pending, as is cleanup.
- Full logs remain unavailable during the active job; detailed Gradle output, exact analyzer count, test total and native-test NO-SOURCE status await the terminal job log.
- Continue only run/job/source above; no duplicate trigger/retry. Build #164 remains the published baseline until all #165 gates pass.

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