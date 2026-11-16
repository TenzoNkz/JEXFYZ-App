<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — BUILD #164 LIVE PREFLIGHT CLEAR / FRESH TRIGGER NEXT — 2026-11-16

## Session and authorization
- Project: JE X FYZ / JE Cooler.
- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- Current mode: `Eksekusi Build App!` — the current owner message explicitly authorizes the guarded App Build/QC/release workflow and justified App-scope repairs only.
- Session is IN_PROGRESS. The active work item is one guarded App Build/QC/release attempt from current validated App source/test baseline. No #164 trigger issue/run has been created yet.
- No Firmware compilation, BIN generation/publication/replacement, Firebase mutation, OTA, flashing, device operation or unrelated release work is authorized.

## Build #164 live pre-trigger status

**PRE-TRIGGER CLEAR — one fresh guarded owner-authored issue is authorized; do not reuse any existing trigger issue.**

- Latest Validation Only #38 / run `43843348889` / job `133217253810`, source input SHA `01cf1295458564820b52afc6ca33037583a430c6`: dependency resolution PASS; formatter applied five Dart-file changes and final check PASS; analyzer PASS (107 info-level); Flutter tests 200/200 PASS; formatter-only commit `b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da`.
- Pre-trigger source comparison from that validated source/test tree to current main showed only guarded workflow and canonical documentation/checkpoint paths changed; no App source/test/Android Gradle/dependency path changed.
- Current guarded workflow blob `af342fc21e5c0ff0815628dfacec65ae519f69ae`, full 546 lines read. Only issue opened/reopened event; repository-owner author + exact title + body-token guard; serialized queue with `cancel-in-progress: false` and `queue: max`; no push/PR/workflow-dispatch release path. Corrected Step 10 Fan Speed percent assertion is present. All 20 explicit release gates (steps 2–21) remain.
- Live Build App history: latest Build #163 / run `43679305537` / job `132706236782`, attempt 1, terminal SUCCESS; steps 1–21 and cleanup 39–43 all SUCCESS. Current status queries: zero queued, in-progress, waiting or requested Build runs.
- Issue #40 is still OPEN and already used for Build #163. Existing trigger issues #39, #38, #37, #36, #35 and #33 must not be reused/reopened. Authenticated GitHub identity `TenzoNkz` matches repository owner.
- Published baseline before the next run: Release ID `403010611`, tag `jexfyz-latest`, tag target/source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`; exactly one APK and one source ZIP. Detailed sizes/digests are recorded in the latest Build #163 report and the Build #164 pre-trigger entry in `APP_BUILD_REPORT.md`.
- Flutter app version remains `1.0.0+3`; Android Gradle `versionName "Telegram @horizontalzzz"` verified unchanged.
- The Build #163 self-signed certificate/PKIX and META-INF warnings, Kotlin/Gradle deprecations, native ELF DWARF warning and NO-SOURCE native Android JUnit tasks remain disclosed. Local Flutter/Dart/actionlint are unavailable. Physical install/OEM visuals, BLE/device, Firmware/BIN, Firebase, OTA/flash, thermal/electrical acceptance remain unverified.

## Exact next action

- Fetch the final current main HEAD immediately before trigger; then create exactly one new owner-authored issue with title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`.
- Do not reuse/reopen Issue #40 or other old trigger issues. Verify exactly one resulting Build run and record the actual issue ID, run ID, job ID, source SHA and status from live Actions.
- Continue only that run. Record meaningful gate transitions, inspect full logs at any failure, repair only demonstrated App-scope causes without weakening checks, and retry only after a concrete repair or evidence-backed infrastructure transient.
- Success requires every current workflow gate, analyzer/tests, exactly one obfuscated APK and matching source ZIP, signature/certificate verification, Release/tag/source SHA parity, and downloaded asset identity/checksum verification.
- Keep Firmware, BIN, Firebase, OTA, flashing and device operations outside scope.

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