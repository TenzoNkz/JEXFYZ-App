<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — BUILD #164 RELEASE VERIFIED / BLUETOOTH NAME DISPLAY FIX VALIDATED — 2026-11-16



## Current session and authorization

- Project: JE X FYZ / JE Cooler.

- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.

- Mode: `Eksekusi Full!` — App-only Bluetooth device-name display correction, targeted regression coverage and canonical documentation.

- **SESSION STATUS: COMPLETED. WORK STATUS: COMPLETED for this App source/test correction.**

- **EXTERNAL OPERATION: Validation Only #44 / run `43899329198` / job `133411358928` — COMPLETED / SUCCESS.** No Build App, APK/Release, Firmware/BIN, Firebase, OTA, flashing or device operation was performed.



## Bluetooth device-name correction



**Result:** the Connection menu now displays the real advertised Bluetooth name `JE X FYZ` instead of hiding it behind the generic localized label `Perangkat`.



- Owner screenshot showed the Bluetooth list row as `Perangkat`, while the Home/app product identity remained `JE X FYZ`.

- Investigation confirmed Firmware V7.2's tracked source already defines `static constexpr char BLE_NAME[] = "JE X FYZ";` and calls `BLEDevice::init(BLE_NAME)`. Therefore the BLE peripheral's source-defined name was already correct; no Firmware edit was necessary or made.

- Root cause was App presentation in the Connection `ListTile`: it chose `platformName` before `advName`, then deliberately replaced an empty name **or the real name `JE X FYZ`** with `JexText.of('device', lang)`, which renders `Perangkat` in Indonesian.

- New helper in `lib/connection_scan_state.dart`, `connectionDeviceDisplayName(...)`, selects the trimmed current BLE advertisement name first, then the platform name, then localized generic fallback only if both names are empty.

- `lib/main.dart` now uses that helper for the Connection device row. BLE UUIDs, service filter, fresh `onScanResults`, scanner ownership/generation, connection handoff, P1 framing/session rules and Firmware source are unchanged.

- Regression tests in `test/connection_scan_state_test.dart` cover advertisement precedence, stale platform name, platform fallback and localized empty-name fallback. `test/widget_test.dart` verifies the Connection sheet calls the helper and does not mask `JE X FYZ`. Separately, read-only inspection of tracked Firmware V7.2 source confirmed its `BLE_NAME` / `BLEDevice::init(BLE_NAME)` contract; the widget test does not read the Firmware file.



## Hosted validation evidence

- Validation Only #44 / run `43899329198` / job `133411358928`, tested input SHA `4a875b3d63beea6e7d469c27f0c8930ab9b7cd09`, terminal SUCCESS.

- Locked dependencies: PASS.

- Dart formatter: final PASS. It checked 18 Dart files and formatted two test files in the runner workspace; formatter verification after apply was clean.

- Flutter analyzer: PASS, 107 info-level findings, zero warnings/errors.

- Flutter tests: **205/205 PASS**.

- Formatter-only commit: `0a2b3c03af433a17d82afa1d4db60beb7b1bd023`, message `style: format Dart sources and tests`. This is the validated source/test tree.

- Earlier Validation Only #40/#41/#43 attempts encountered the workflow's exact-HEAD formatter commit safety guard while concurrent commits advanced `main`; #42 exposed a test-only source-slice boundary error. Those were diagnosed and corrected. Run #44 is the successful terminal validation; do not retry it.

- Local Flutter/Dart executables remain unavailable; positive formatter/analyzer/test evidence is hosted CI. No native Android Build or real BLE radio test was run for this correction.



## Package and physical verification boundary

- Latest published App remains **Build #164** / run `43863417641` / job `133285765871`, source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`, Release ID `403010611`, tag `jexfyz-latest`.

- Build #164 predates this Bluetooth display-name fix. Its existing APK does not contain the correction. A new APK requires a separate explicit `Eksekusi Build App!`; this interaction did not create a new trigger, Build run or Release.

- Actual phone scan/display and owner installation remain **NOT VERIFIED** until the corrected App is built and installed. Firmware advertisement source is confirmed in tracked code, but not independently measured on hardware.

- No Firmware/BIN, Firebase, OTA, flash, thermal/electrical or device operation occurred or is authorized by this checkpoint.



## Next action

- The source/test correction is complete. Keep the validated change on `main`.

- To package this correction, use a separate explicit `Eksekusi Build App!` command and a fresh owner-authored issue with the exact guarded title/token. Issue #41 already triggered Build #164; do not reuse/reopen it.

- After install, verify the Bluetooth scan row shows `JE X FYZ` on the real phone. Do not mark physical verification complete from CI alone.



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