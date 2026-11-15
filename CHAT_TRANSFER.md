<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — BUILD #163 COMPLETE — RELEASE VERIFIED — 2026-11-15

**Project:** JE X FYZ / JE Cooler  
**Repository:** TenzoNkz/JEXFYZ-App — branch main  
**Last mode:** Eksekusi Build App! — guarded App Build / QC / release only.  
**Disposition:** **COMPLETED / SUCCESS.** No active Build run remains. No Firmware compile/BIN, Firebase mutation, OTA, flashing or device operation was performed or authorized.

## Completed guarded attempt

- Owner-authored trigger Issue [#40](https://github.com/TenzoNkz/JEXFYZ-App/issues/40), exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, exact body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`, opened once by TenzoNkz.
- Build #163: [Actions run 43679305537](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43679305537), workflow 374946166, `issues` event, attempt 1, completed SUCCESS; job `build` / `132706236782`, ubuntu-24.04. Started 2026-11-15T05:02:07Z and completed 05:08:29Z.
- Immutable source SHA: `9466e8eeb269da5bc8806f0df1d4212cf24e1746`. All required steps 1–21 and post-job cleanup 39–43 SUCCESS.
- Analyzer: 118 info-level findings, zero warnings and zero errors. Flutter tests: 197/197 passed.
- Android Gradle `:app:testDebugUnitTest`: `BUILD SUCCESSFUL in 2m 43s`; 162 actionable tasks (161 executed, 1 up-to-date). The App's Kotlin/Java unit-test compile/process/test tasks were `NO-SOURCE`; this gate did not execute native Android JUnit test cases.
- Release APK built with `flutter build apk --release --obfuscate --split-debug-info=build/symbols`.

## Published Release and downloaded asset verification

- GitHub Release ID `403010611`; tag `jexfyz-latest`; Release target and tag ref both point exactly to source SHA `9466e8eeb269da5bc8806f0df1d4212cf24e1746`.
- Exactly two assets:
  - `JEXFYZ-release.apk` (asset ID 749904437), 55,881,819 bytes; SHA-256 `97c7cf99bef5d89f82b13d8f1c4b3c02dede541c2642a751ba61c8f9290a245c`.
  - `JEXFYZ-corresponding-source.zip` (asset ID 749904434), 2,943,100 bytes; SHA-256 `866117d208d38d2c04a2f7f097b5dc8941850a16bd52172a35d761af71334c00`.
- Source ZIP was generated from the exact run SHA, contains the embedded `SOURCE_BUNDLE_README.md` marker for that SHA, and passed ZIP integrity before and after download.
- Workflow downloaded both published assets; local/downloaded APK and source hashes matched. Downloaded APK verified V1/JAR, V2 and V3, one signer, pinned certificate identity. Release API asset digests match the downloaded checksums.
- The Android Gradle `versionName "Telegram @horizontalzzz"` remains exact; Flutter version `1.0.0+3`.

## Warnings and limitations retained

- Signing is valid under V1/V2/V3 and the pinned certificate fingerprint matches, but the signing certificate is self-signed; JAR verification reports an untrusted PKIX chain. The workflow's fingerprint check passed; this does not make the self-signed certificate publicly CA-trusted.
- Non-blocking toolchain warnings: deprecated Android Gradle properties (`android.builtInKotlin=false`, `android.newDsl=false`, `android.enableJetifier=true`); Flutter warns Kotlin Gradle Plugin 2.2.20 will soon need upgrading to at least 2.3.20; generated native ELF libraries warn that DWARF debug information is not obfuscated; JAR META-INF entries produce unsigned-entry warnings.
- Android native unit-test tasks were `NO-SOURCE`. CI does not establish owner installation, device/OEM screenshots, BLE/device behavior, Firmware compile/BIN provenance, Firebase, OTA/flash, thermal or electrical acceptance.
- The Actions run has no workflow artifacts; the two required deliverables are in the verified GitHub Release assets.



## Recovery verification — Chat Stuck! — 2026-11-15 12:17–12:19 Asia/Jakarta

- Re-fetched Build #163 run `43679305537` / job `132706236782`: terminal SUCCESS; all required steps 1–21 and cleanup 39–43 succeeded. The full 3,548-line job log was retrieved and reviewed.
- Release 403010611 / tag `jexfyz-latest` still target exact build SHA `9466e8eeb269da5bc8806f0df1d4212cf24e1746`; exactly one APK plus one source ZIP remain, with the recorded hashes and sizes above.
- Post-build compare to current main shows only seven Markdown status/ledger/checkpoint files changed; no App source/test/workflow/release-input changes after the packaged SHA. Build filters show zero active/queued/waiting/requested/pending Build runs.
- No new trigger/rerun was created. Recovery interaction closed COMPLETED; WORK STATUS and EXTERNAL OPERATION STATUS remain COMPLETED / SUCCESS. Remaining owner task is physical installation/OEM visual/BLE/device verification only.

## Latest owner decision — complete EN→ID localization — 2026-11-15 (Asia/Jakarta)

**Mode:** Diskusi (read-only for executable source/tests/config/workflow/build).  
**Disposition:** terminology and copy audit completed at discussion/documentation level. No App source or test was changed, no validation/test/build was run.

### Required localization standard

- English is the master/source language and default App language. Every user-visible English string must be grammatical and complete; its Indonesian counterpart must be a complete, natural, standard Indonesian translation. Never leave generic English words embedded in Indonesian prose.
- Approved glossary:
  - `Battery` → `Baterai`
  - `Battery Temperature` → `Suhu Baterai` (do not add `HP` to this concise chart/metric label)
  - `Hotside` → `Sisi Panas`
  - `Hotside Temperature` → `Suhu Sisi Panas`
  - `Hotside Limit` → `Batas Suhu Sisi Panas`
  - `Hotside Protection` → `Perlindungan Sisi Panas`
  - `Hotside + Battery` → `Sisi Panas + Baterai`
  - generic `cooler` → `pendingin`
  - `Adaptive Mode` → `Mode Adaptif`; `Fan` → `Kipas`; `Fan Speed` → `Kecepatan Kipas`; `Voltage` → `Tegangan`
  - preserve approved `Floating Monitor / Monitor Melayang`; established technical names/acronyms (Bluetooth, Firmware, Peltier, LED, OTA, SSID) may remain where technically appropriate.
- This owner decision supersedes the previous APP_NOTES rule that required `Hotside` to remain unchanged in Indonesian. Translate only user-facing wording; do not rename internal keys, persisted values, enum IDs, BLE command strings or Firmware protocol identifiers. Raw tokens such as `FAN` / `PELTIER` must not be exposed in ordinary UI prose.

### Verified localization findings

- Current localization dictionary scan found 353 paired entries with both English and Indonesian fields; no missing locale field was detected in that scan. Existing contract tests check locale/placeholder presence, not whether every sentence is idiomatic, fully translated or terminologically consistent.
- Concrete visible-copy defects:
  - `lib/usage_statistics.dart`: `Battery Temperature / Suhu Baterai HP`, `Hotside Temperature / Suhu Hotside`, and the selected-time labels `Battery / Baterai HP`.
  - Usage Statistics information sentence mixes `Battery`, `Hotside`, and `cooler` into Indonesian prose (`Battery dan Hotside ... operasi cooler ...`).
  - Usage Statistics empty-state copy exposes internal tokens `FAN` and `PELTIER`; rewrite as normal user-facing names.
  - `lib/app_settings.dart`: multiple Indonesian Hotside dictionary values remain untranslated, including the component label, limit, protection, profile and notification/error copy.
  - `lib/main.dart`: Hotside remains embedded in several Indonesian safety, limit and NOTIFY messages; relocalization logic must continue recognizing old stored-message variants while generating the new `Sisi Panas` translation.
- `test/usage_statistics_test.dart` currently asserts the old `Suhu Baterai HP` and `Suhu Hotside` text. It must be updated alongside source changes. Current localization contract tests do not enforce the approved glossary or detect these mixed-language sentences.
- APP_NOTES.md now records the new glossary and authority rule. This is a documentation decision only; the live App source and Build #163 package still contain the old wording.

### Scope boundary and next action

- No source/test/config/workflow edits, Flutter formatter/analyzer/tests, Android package, Release, Firmware or device operation occurred during this Diskusi.
- Next authorized implementation scope should update every visible Flutter/native/notification phrase and corresponding regression expectations, maintain legacy notice parsing, and add a terminology/content-quality contract. Then run appropriate source validation. A new APK still requires a separate explicit `Eksekusi Build App!` command.
- Build #163 remains the latest verified package; it does not contain the pending glossary/copy corrections.

## Next action

- Recommended next mode: `Eksekusi Full!` to implement the approved EN-master/ID-standard localization corrections and regression coverage. This recommendation is not authorization; wait for the owner's explicit mode command.
- Owner installation and physical-device/OEM visual/BLE verification of Build #163 remain separate and are not inferred from CI.
- For routine chat transfer, load only this bounded checkpoint; full build history remains in append-only `APP_BUILD_REPORT.md`, and older transfer history remains archived without being loaded during routine boot.
<!-- ACTIVE_CHECKPOINT_END -->