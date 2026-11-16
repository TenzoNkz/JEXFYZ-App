<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — RECOVERY REQUIRED — 2026-11-16

## Session and authorization
- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Prior work item: the interrupted `Eksekusi Full!` bilingual-copy, locale-formatting, Home notice and Adaptive-presentation implementation.
- **WORK STATUS: RECOVERY_REQUIRED.** It has durable source commits but is not complete or validated. The incoming `Diskusi!` interaction performed read-only recovery review and documentation only; it does not inherit source-edit, test-write, workflow, Build App, Firmware or device authorization.
- Preserve the exact next authorization boundary: only a new explicit `Eksekusi Full!` may repair the specified App source/tests/docs scope. A separate `Eksekusi Build App!` is required for any App package/release operation.

## Owner-approved contracts — still authoritative
- English is the master/default language; Indonesian must be complete, natural and semantically equivalent.
- General glossary includes Battery → Baterai; Battery Temperature → Suhu Baterai; Hotside (generic component) → Sisi Panas; Hotside Temperature → Suhu Sisi Panas; Hotside Limit → Batas Suhu Sisi Panas; generic cooler → pendingin; Adaptive Mode → Mode Adaptif; Fan → Kipas; Fan Speed → Kecepatan Kipas; Voltage → Tegangan.
- Exact Adaptive profile labels: EN `Hotside Protection` / ID `Perlindungan Suhu Panas`; EN `Hotside & Battery Protection` / ID `Perlindungan Suhu Panas & Baterai`. Keep active keys `hotsideProtection`, `hotsideBattery` and legacy aliases `hSideProtection`, `hSideBattery`; do not rename protocol/storage identifiers. Generic thermal-protection prose remains Sisi Panas.
- Remove the entire visible Adaptive Limit/ceiling information card and readout. This is presentation-only: preserve `adaptiveCeiling`, `ADAPTIVE_CEILING` telemetry/state, Firmware clamp, Lock Voltage and all safety/transition logic.
- Keep LED as the section heading and RGB Power / Daya RGB as the user RGB-effect toggle. Independent voltage/system/safety indicators remain separate.
- Preserve Bluetooth, Firmware, Peltier, LED, OTA, SSID and BLE protocol tokens where technically appropriate; never translate protocol values or storage keys.
- Battery threshold roles: 5 V is the upper-temperature ceiling; 12 V is the lower-temperature floor. Existing defaults and hysteresis must not change.
- Locale display formatting must not alter protocol/storage serialization or timestamps. Preserve one-second telemetry, local history semantics, metric identifiers B/H/V/A/P/F, notification IDs/channel IDs, and stable BLE contracts.

## Restored checkpoint and live repository evidence
- The prior status snapshot named `39e70cb0bac4271785905f9b56fdaca5337dbb30` as its last source milestone. Live main had advanced through source commits to `05ab2bcf9a619b497d1a9f6f2abc974093808f37`; the incoming status marker then created documentation-only commit `b047f209ce958faa97a5b5d06155871d341ea395`.
- At the time of recovery review, main tree SHA was `fe0c09a9a033515ccc9448bd0c5ffee9523ab6f2`: recursive tree not truncated, 139 entries, 53 Markdown files. No open PR was found.
- Compare from immutable Build #163 package source `9466e8eeb269da5bc8806f0df1d4212cf24e1746` to the source-updated main revision showed 17 changed paths, including Dart source, Kotlin presentation files and tests. `lib/main.dart` alone had +33,581 / −11 lines.
- The good `lib/main.dart` baseline blob is `48dd0c943075db076769c3d9dc53b8b71a28a5c3` (403,036 bytes), present at Build #163 source and commit `39e70cb0...`. Current damaged main blob is `c28b1bcdb26673c3f317bf2448839b9ab7cd66ae` (1,582,015 bytes; 45,030 lines).
- Main currently contains top-level declarations repeatedly in active Dart code, not inside comments/strings: for example `LedColorPreset` at lines 1,034 / 12,320 / 23,331 / 34,617; `TamperApp` at 4,434 / 15,720 / 26,731 / 38,017; and `DashboardScreen` at 4,567 / 15,853 / 26,864 / 38,150. Around line 11,447 there is an orphaned fragment beginning `, caseSensitive: false), '')` immediately after a closed class. This breaks parsing in addition to duplicate definitions.
- Hosted Validation Only #27 (run `43808741923`, job `133105410519`, source `05ab2bcf...`) ended CANCELLED. Its logs show `dart format` exiting 65 on malformed Dart and `flutter analyze` reporting repeated `duplicate_definition` errors in `lib/main.dart`; Flutter tests did not reach a successful terminal result. This is direct CI evidence that current main is not a valid build candidate.
- Earlier Validation Only #20 (run `43806817665`, source `39e70cb...`) failed 1 test: expected old `Suhu Hotside`, actual `Suhu Sisi Panas`. Validation Only #22 (run `43807291287`, source `694a3219...`) also failed: `test/usage_statistics_test.dart` still called the now-three-argument `formatUsageAxisTick` with two arguments. Runs #23–#27 were cancelled; there is no successful Validation Only result for the current correction set.
- Build #163 remains the latest successful App package: run `43679305537`, job `132706236782`, Release `403010611`, tag `jexfyz-latest`, package source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`. The tag/Release target match. This package predates the current localization source changes. No App Build, Firmware, BIN, Firebase, OTA, flash or device action was started in this Diskusi interaction.

## Current implementation inventory — partial, not accepted
- `lib/app_settings.dart` now has the two exact active Adaptive profile labels and aligned legacy aliases; generic Hotside → Sisi Panas; `volt` → Voltage/Tegangan; OTA Online/Daring; Adaptive inactive/nonaktif wording; and the explicit 5 V ceiling / 12 V floor labels.
- Usage Statistics source now has locale-aware axis decimal formatting, localized month names/year with 24-hour time, locale temperature values and revised copy. `test/usage_statistics_test.dart` was updated to use the new formatter signature and labels.
- Floating Monitor slider scale labels use the locale-aware number helper. Native Floating HUD now formats °C, spaced voltage and Fan Speed percent while keeping B/H/V/A/P/F IDs. MainActivity's Device alerts title was aligned to Device alerts / Peringatan perangkat.
- Main Home/notification localization and legacy notice work exists in the damaged `main.dart`, but cannot be treated as valid/complete until the file is reconstructed and validated.
- The visible Adaptive ceiling card is still present in the surviving code (first occurrence around line 9,376, repeated in later concatenated copies). This owner-requested presentation removal is not complete.
- `formatOtaUploadSizeMismatch` now uses locale-grouped numbers, but `test/localization_contract_test.dart` still expects ungrouped values `120400` / `131072`; update the test expectation to locale grouping after source recovery.
- `test/device_copy_notification_contract_test.dart` still contains the old `Suhu Hotside` expectation. Semantic tests for exact profile labels, Adaptive-card absence, HEX/color semantics, notification-channel title and native HUD units are still incomplete. Color-name translations need HEX-aware review; 350-dp/360-dp layout and accessibility fit have not been visually verified.

## Recovery plan for the next authorized Eksekusi Full
1. Treat current `lib/main.dart` as corrupted; do not append to it, patch its tail blindly, or use the duplicated sections as the source of truth.
2. Rebuild from the clean baseline blob `48dd0c943075db076769c3d9dc53b8b71a28a5c3` (same file at Build #163 source / commit `39e70cb0...`) and reapply only the intended Home thermal-notice, locale-decimal parser, OTA-size-format and legacy Hotside-notice changes once. Preserve unrelated logic and verify a clean complete source file before any test run.
3. Remove the visible Adaptive ceiling card only; retain underlying state/telemetry/clamp and Lock Voltage.
4. Bring tests into alignment and add semantic/negative assertions: exact EN/ID profile labels, no visible ceiling card, localized grouped OTA bytes, old/new Home notice forms including comma/dot decimals and spaced/unspaced °C, native HUD units, Device alerts channel title, and protected telemetry/state contracts.
5. Run the allowed non-publishing formatter/analyzer/test validation only after source and tests are coherent. Do not start an App Build or release from this mode; that requires separate `Eksekusi Build App!`.
6. Re-review HEX-aware shade names and narrow-width EN/ID fit after the source is valid; no visual/OEM claim without actual screenshots/device evidence.

## Verification boundary
- This checkpoint is based on live GitHub metadata, full recursive-tree metadata, source/blob inspection and Actions/job logs. No source/test/config/workflow/Build/Firmware/device operation occurred in Diskusi.
- Last source-updated revision inspected: `05ab2bcf9a619b497d1a9f6f2abc974093808f37`; opening status commit: `b047f209ce958faa97a5b5d06155871d341ea395`.
- Next safe owner command: `Eksekusi Full!` for the source recovery scope above.
<!-- ACTIVE_CHECKPOINT_END -->