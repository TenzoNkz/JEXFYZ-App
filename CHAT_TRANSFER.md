<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — SOURCE RESTORED / HOSTED VALIDATION PENDING — 2026-11-16

## Session and authorization
- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current mode: `Eksekusi Full!` — owner explicitly authorized source recovery, regression repair, and non-publishing validation.
- **WORK STATUS: BLOCKED ON VERIFIED HOSTED VALIDATION.** Source recovery and scoped test repairs are committed; Flutter formatter/analyzer/test results are not yet verified. Do not start Build App until the Validation Only result is green. A separate `Eksekusi Build App!` is required for any App package/release.
- No Firmware, BIN, Firebase, OTA, flashing, or physical-device operation was performed or authorized.

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
- Test commits: widget expectations `22c8b7543d3d509e348d267dfc393aad88ca1f8d`; localization contracts `f24a612c39138bbe41832adda1cec85091e0b6af`; Usage Statistics labels `787f1fff57075ead8f37699e2f9bbc10be3436e1`.
- Added regression checks for decimal comma/dot inputs, legacy Home notice forms, grouped OTA byte values, exact active/legacy Adaptive labels, and presentation-only Adaptive ceiling removal. Updated Usage Statistics and widget-copy expectations.

## Static verification completed
- Live readback confirms `lib/main.dart` is 401,983 characters / 11,427 lines and contains one copy of each previously duplicated top-level class.
- A lexical delimiter/string/comment scan passed for `lib/main.dart`, `test/localization_contract_test.dart`, `test/widget_test.dart`, `test/usage_statistics_test.dart`, `lib/app_settings.dart`, and `lib/usage_statistics.dart`: no unmatched delimiters or unterminated strings/comments.
- Source contract checks passed: Adaptive card absent from `_buildAdaptiveTab`; internal ceiling state/telemetry retained; comma-decimal parsing and OTA grouping present; exact profile labels present; stale Usage Statistics/widget copy expectations removed.
- These are static checks only. **Dart formatter, Flutter analyzer and Flutter tests have NOT been verified in this session.** The local runtime has no Dart/Flutter SDK.

## Hosted validation and next action
- `.github/workflows/jexfyz-app-validation.yml` is the non-publishing Flutter validation workflow and currently has a push trigger for `main` changes under `lib/**` and `test/**`. The latest source/test commit should trigger it automatically.
- The available GitHub workflow-run lookup returned no run for commit `f24a612c39138bbe41832adda1cec85091e0b6af`; that lookup is limited to PR-triggered runs and does not expose push-run status. Therefore the current push-run state is **UNKNOWN**, not PASS.
- Owner should open GitHub Actions and provide the latest `JE X FYZ — Validation Only` run ID and result. If green, the source can be considered validation-ready for a separate Build App authorization. If it fails, continue repair under the current Eksekusi Full scope.
- Latest verified package remains Build #163 / run `43679305537` / Release `403010611` / tag `jexfyz-latest`, source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`. It predates these restored changes; no new APK or Release was created.
- Visual/OEM acceptance at 350-dp/360-dp, actual owner installation, BLE field behavior, Firmware compile/BIN provenance, thermal/electrical tests, Firebase, OTA/flash remain unverified.
<!-- ACTIVE_CHECKPOINT_END -->