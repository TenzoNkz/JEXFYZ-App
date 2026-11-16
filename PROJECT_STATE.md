# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-16 16:52 (Asia/Jakarta). Current truth only. Build history remains in APP_BUILD_REPORT.md and CHANGELOG.md; rolling chat continuation remains in CHAT_TRANSFER.md.

## Repository baseline

- Canonical repository/branch: TenzoNkz/JEXFYZ-App / main.
- Build #163 is the latest verified App package and Release: Actions run 43679305537 / job 132706236782 / Issue #40; immutable package source 9466e8eeb269da5bc8806f0df1d4212cf24e1746; terminal SUCCESS.
- At recovery-review entry, the compare from Build #163 source to main covered 17 changed paths, including App source/tests, Android presentation code and documentation. `lib/main.dart` alone showed +33,581 / −11 lines; current main is not equivalent to the released package.
- Twelve canonical .agents/skills and twelve .github/skills are mirrored byte-for-byte. Guarded App release and non-publishing Validation Only workflows remain separate.

## Live source recovery status — 2026-11-16

**Source recovery: COMPLETE. Hosted Flutter validation: SUCCESS — Validation Only #38 passed all required gates and committed its formatter-only result to current main. App Build: NOT AUTHORIZED.**

- Restored `lib/main.dart` from verified clean baseline blob `48dd0c943075db076769c3d9dc53b8b71a28a5c3`; source commit `b4558cee8b5a4455603473d31e46b3b108f20576`; final blob `b12ea764b674b79f8a19bd70191fcf25ea3046a5` (401,983 characters / 11,427 lines).
- Live readback shows one active `LedColorPreset`, `TamperApp`, and `DashboardScreen`; malformed fragments and duplicate declarations from the damaged 1.58 MB source are gone.
- Reapplied Home/NOTIFY decimal parsing and legacy normalization, localized Hotside threshold/re-arm copy, OTA byte grouping and Adaptive profile notice translation. Removed only the visible Adaptive ceiling card; retained `adaptiveCeiling` state and `ADAPTIVE_CEILING` telemetry. No Firmware/BLE protocol changes.
- Regression tests updated: `test/localization_contract_test.dart` (blob `aa22fcfd0d493b86bc6697eebb7456446d1f7868`), `test/widget_test.dart` (blob `3d4595759900483195d8f498322d82d59a6f40fe`), `test/usage_statistics_test.dart` (blob `e366371350c9267bb23362ed744bb39ec653b464`). Added tests for decimal comma/dot parsing, legacy notices, locale-grouped OTA bytes, exact active/legacy Adaptive labels and Adaptive-card absence with telemetry preservation.
- Static checks passed: delimiter/comment/string scan for six Dart files; one copy of each previously duplicated class; no visible Adaptive ceiling card; retained internal ceiling state/telemetry; localized parser/grouping and current regression expectations present.
- Hosted Validation Only #38 (run `43843348889`, job `133217253810`) tested source SHA `01cf1295458564820b52afc6ca33037583a430c6` and completed SUCCESS. Locked dependencies passed; formatter applied five Dart-file formatting changes and the final check passed; analyzer passed; Flutter tests passed 200/200. The workflow then committed its formatter-only patch as `b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da`, now current `main` HEAD. No separate subsequent Validation Only run is listed for this auto-format commit; it represents the exact formatted workspace tested in run #38. Local Flutter/Dart SDK is unavailable, so verification is hosted only.
- Latest verified package remains Build #163 / run `43679305537` / Release `403010611` / tag `jexfyz-latest`, immutable source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`. It predates current restored source. No App Build, Release, Firmware, BIN, Firebase, OTA, flash or device operation was performed.
- **Source validation gate:** COMPLETE for the current formatted source. Build App remains a separate operation and is not authorized by the current Eksekusi Full command; require explicit `Eksekusi Build App!` before package/release work.
- **Visual status:** NOT VERIFIED. No new APK/screenshots or owner-side device evidence exists for the restored source.

## Historical hosted validation baseline — Validation Only #19 SUCCESS (pre-localization correction set)

- Run/job: 43677560315 / 132700920324; tested source 8fca2ecebf8b2ffb83fc9475a817c832f8269dc5; terminal SUCCESS.
- Flutter 3.47.2 / Dart 3.13.2; locked dependency resolution PASS.
- Formatter checked 18 files, applied one correction, then final check passed with zero remaining changes. Formatter-only follow-up fc39de16a5480347ce13083760424a309957c311 changes one test assertion's line wrapping only.
- Analyzer: 118 info-level findings, zero warnings/errors. Flutter tests: 197/197 passed.
- Validation Only #18 (43677411117) remains a failed historical intermediate (196/197); the stale LED-copy expectation was corrected before #19.

## Latest verified App package — Build #163 SUCCESS

- Trigger Issue #40; Actions run 43679305537 / job 132706236782; attempt 1; source SHA 9466e8eeb269da5bc8806f0df1d4212cf24e1746.
- All workflow steps 1–21 and cleanup 39–43 SUCCESS. Analyzer 118 infos / 0 warnings / 0 errors; Flutter 197/197.
- Android Gradle `:app:testDebugUnitTest`: BUILD SUCCESSFUL in 2m43s; 162 actionable tasks (161 executed, 1 up-to-date). Native App Kotlin/Java unit-test tasks were NO-SOURCE; no native JUnit case ran.
- Release ID 403010611 / tag jexfyz-latest. Tag and Release target match exact source SHA.
- APK: JEXFYZ-release.apk, 55,881,819 bytes, SHA-256 97c7cf99bef5d89f82b13d8f1c4b3c02dede541c2642a751ba61c8f9290a245c.
- Corresponding source ZIP: 2,943,100 bytes, SHA-256 866117d208d38d2c04a2f7f097b5dc8941850a16bd52172a35d761af71334c00; embedded source marker matches exact SHA. Release has exactly these two assets; downloaded hashes/signature/ZIP integrity passed.
- APK V1/V2/V3 signatures and one-signer pinned certificate passed. Fingerprint dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0; certificate is self-signed and has no publicly trusted PKIX chain.
- Android Gradle versionName "Telegram @horizontalzzz" preserved exactly; Flutter version 1.0.0+3.

## Retained warnings and limitations

- Flutter reports Kotlin Gradle Plugin 2.2.20 will soon need upgrading to at least 2.3.20; Android Gradle properties android.builtInKotlin=false, android.newDsl=false and android.enableJetifier=true are deprecated.
- Generated native ELF libraries report unobfuscated DWARF debug information. This is a non-blocking hardening warning, not a claim that it was removed.
- JAR signature tooling warns about self-signed PKIX chain and META-INF entries not protected by the signature. V1/V2/V3 and the pinned certificate fingerprint still passed the guarded checks.
- Android native test tasks were NO-SOURCE. Owner installation, Android/OEM screenshots, BLE/device behavior, Firmware compile/BIN provenance, Firebase, OTA/flash, thermal/electrical safety remain unverified.
- The Actions run has no workflow artifacts; the required APK and source ZIP are delivered and verified as GitHub Release assets.

## Localization and state semantics in the Build #163 package baseline (historical)

- English remains the master/default language. JexText contains 353 bilingual keys on the live source; dictionary locale/placeholder and inline phrase placeholder parity are covered by tests.
- Thermal Safety uses Keselamatan; successful safety status is Pemeriksaan keselamatan berhasil. Fan-before-cooling copy states its prerequisite; protected sequence remains FAN:ON → successful ACK → PELTIER:ON.
- Adaptive is a logical mode: EN ACTIVE/INACTIVE, ID AKTIF/NONAKTIF. Peltier/Fan/LED are physical outputs: compact EN ON/OFF, ID HIDUP/MATI; natural Indonesian prose uses menyala/mati.
- Fan Speed remains numeric when running and OFF/MATI when stopped; disconnected/unknown values remain --. Usage Statistics distinguishes logical mode from hardware output while preserving voltage/unknown states. OTA mismatch copy labels received bytes first and expected bytes second.

## Owner-approved localization correction — partial main-branch implementation; recovery required — 2026-11-15

- English is the master/source language and default App language. All user-visible English copy must be complete and grammatical; Indonesian copy must be fully translated, natural and standard rather than mixed-language.
- Approved general UI glossary: Battery → Baterai; Battery Temperature → Suhu Baterai; generic Hotside component references → Sisi Panas; Hotside Temperature → Suhu Sisi Panas; Hotside Limit → Batas Suhu Sisi Panas; generic cooler → pendingin; Adaptive Mode → Mode Adaptif; Fan → Kipas; Fan Speed → Kecepatan Kipas; Voltage → Tegangan. General thermal-protection prose uses Perlindungan Sisi Panas. The Adaptive profile selector is a key-specific exception: active key `hotsideProtection` must render `Hotside Protection / Perlindungan Suhu Panas`, and `hotsideBattery` must render `Hotside & Battery Protection / Perlindungan Suhu Panas & Baterai`. Preserve legacy dictionary aliases `hSideProtection` and `hSideBattery`; do not rename or delete keys, and align their display values to the same exact profile pairs as the active keys.
- Keep the approved Floating Monitor / Monitor Melayang pair. Bluetooth, Firmware, Peltier, LED, OTA and SSID remain established technical terms where appropriate. Internal identifiers, persisted keys, enum values, BLE commands and Firmware protocol tokens are not renamed or surfaced as ordinary translated prose.
- The previous source rule retaining Hotside in both locales is superseded by this explicit owner decision. Current source still contains old copy in Usage Statistics, App Settings and Home/NOTIFY. Existing usage-statistics widget tests assert the old wording; update source and regression tests together in a separately authorized Eksekusi Full task.
- This is a localization decision/checkpoint only. No App source/tests were changed and no new App package was created in this Diskusi. Build #163 remains the latest verified package and predates these corrections.

## Comprehensive copy quality audit — partial main-branch implementation; current source blocked — 2026-11-15

- Inventory: 353 bilingual dictionary entries; 167 inline bilingual phrase call sites; 258 lookup call sites; native copy is also present in JeForegroundService.kt, FloatingMonitorService.kt and MainActivity.kt. Locale-presence and placeholder tests do not prove language quality.
- Source defects include untranslated Hotside labels/copy, Usage Statistics “Suhu Baterai HP” / “Suhu Hotside” / “Baterai HP”, generic “cooler” left in Indonesian sentences, internal FAN/PELTIER tokens in user-facing copy, and dynamically constructed Home/NOTIFY messages that still emit Hotside.
- Formatting findings: temperature units vary between “45 °C” and “45°C”; voltage varies between “12 V” and “12V”; Usage Statistics fractional axis ticks use dot decimals without locale input; Floating Monitor scale value uses dot decimals in both locales; session date labels are a fixed dd/MM HH:mm shape in both locales.
- Tests currently include old Usage Statistics label expectations and do not enforce the complete glossary, grammar/meaning, capitalization, punctuation, native copy, or locale-aware date/number/unit formatting.
- Recovered 2026-11-16 static review confirmed 353 (not 354) live dictionary entries, 167 inline phrase pairs and 258 lookup calls. Additional defects: EN `Volt` vs ID `Tegangan`, untranslated OTA `Online`, logical Adaptive copy using physical `OFF/MATI`, ambiguous 5 V/12 V battery-temperature threshold labels, and non-equivalent `Device alerts` / `Notifikasi perangkat` channel title. Current Firmware V7.2 source inspection now confirms the 5 V upper-temperature ceiling and 12 V lower-temperature floor semantics (25 °C / 35 °C defaults, 0.5 °C hysteresis); only final UI wording/fit remains to be checked.
- Additional formatting gaps: Native Floating HUD displays `°` rather than `°C`, omits spacing in voltage and `%` for Fan Speed; Home/phone battery decimals and Usage/Floating axis numbers are not fully locale-aware; OTA byte grouping and localized session dates need correction. Preserve dot-decimal protocol payloads, BLE/internal identifiers, stored timestamps and local time semantics.
- Exact owner profile-label exception remains EN `Hotside Protection` / ID `Perlindungan Suhu Panas` and EN `Hotside & Battery Protection` / ID `Perlindungan Suhu Panas & Baterai`; generic thermal copy still uses `Sisi Panas`. RGB remains `RGB Power` / `Daya RGB` under `LED`.
- Pre-implementation source binding was checked: `lib/main.dart` consumes `hotsideProtection` and `hotsideBattery` for the active profile selector, but current dictionary values still read `Perlindungan Hotside` and `Hotside + Battery / Hotside + Baterai`. This active-key mismatch must be corrected in the next authorized source pass; the legacy aliases stay present. The separate `hotsideProtectionActive` message remains generic thermal prose, not selector copy.
- APP_NOTES.md now contains the owner-approved global language, writing and formatting standard plus the full read-only audit. CHAT_TRANSFER.md carries the full implementation handoff.
- No source/test/native changes or formatter/analyzer/test/render/build operation occurred in Diskusi. Build #163 remains the latest package and contains the pre-correction copy.

## Adaptive profile / ceiling presentation / RGB naming — partial implementation; recovery required — 2026-11-16

- Owner decision: remove the Adaptive page's visible information card labelled “Adaptive Limit” / “Batas Adaptif” and its displayed ceiling voltage. Remove the whole card, not just its label.
- Safety boundary: presentation-only. Retain internal `adaptiveCeiling`, `ADAPTIVE_CEILING` telemetry/state synchronization, Firmware voltage clamp, and all safety/transition behavior.
- New profile labels: EN “Hotside Protection” / ID “Perlindungan Suhu Panas”; EN “Hotside & Battery Protection” / ID “Perlindungan Suhu Panas & Baterai”. These exact English strings are authoritative; do not insert `Temperature`, hyphenate `Hotside`, or replace `&` with `+`. They apply only to this profile selector; do not rename internal profile values or protocol/storage keys.
- RGB decision: keep the LED section heading “LED” and toggle label “RGB Power” / “Daya RGB”. The RGB switch controls the user RGB lighting effect only; separate voltage/system/safety LED indicators remain independent.
- No App/Firmware source or tests changed in Diskusi. See APP_NOTES.md and CHAT_TRANSFER.md for exact scope and regression requirements.

## App architecture and protected contracts

- Usage Statistics uses SQLite schema v2 with v1→v2 migration, 30-day retention, raw 1-Hz Battery/Hotside samples, explicit data gaps, HOT-only P1 freshness and bounded writer admission. Long-duration CPU/memory and storage-pressure soak remain unverified.
- BLE scan ownership is serialized with attempt-generation invalidation and subscription/timer cleanup. CI/widget tests do not establish OEM/device behavior.
- Root analysis_options.yaml activates locked flutter_lints 6.0.0; Validation Only is non-publishing.

## Firmware and security boundary

- Current sketch: firmware/JEXFYZ-V7.2.ino, FW_VERSION="V7.2". App Build #163 does not establish Arduino compile, BIN provenance, Firebase identity, OTA, flash, BLE security or thermal/electrical safety.
- BLE App-only identity authentication remains BLOCKED / NOT IMPLEMENTED. Online OTA uses cloudClient.setInsecure(): transport is encrypted but server certificate identity is not authenticated.
- No Firmware/BIN/Firebase/OTA/flash/device operation was performed in Build #163.

## Chat-load/repository hygiene

- CHAT_TRANSFER.md contains one bounded active checkpoint between explicit markers. Its former 723-line snapshot is preserved in archive/CHAT_TRANSFER_PRE_COMPACTION_2026-11-15.md.
- CHAT_TRANSFER_PROMPTS.md contains exactly two copy-ready prompts; APP_BUILD_REPORT.md, CHANGELOG.md and archive/*.md preserve history.

## Immediate next action

- The authorized source recovery, analyzer cleanup, regression alignment and hosted Validation Only checks are complete. Current main HEAD is `b8fcdaf191c5e8bb5df5fa44c50c80a12dfd03da`; run #38 passed dependency resolution, formatter, analyzer and 200/200 Flutter tests before committing the formatter-only changes.
- Do not start package/release operations under this mode. A separate explicit `Eksekusi Build App!` is required for guarded App Build/QC.
- Physical-device/OEM visual/BLE checks remain owner/device tasks and are not inferred from CI. No Firmware/BIN/Firebase/OTA/flash/device work is authorized by this checkpoint.
