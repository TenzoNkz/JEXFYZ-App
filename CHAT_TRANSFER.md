<!-- ACTIVE_CHECKPOINT_START -->
# ACTIVE CHECKPOINT — BUILD #163 RELEASE VERIFIED — PRE-EXECUTION REVIEW COMPLETE — 2026-11-16

**Project:** JE X FYZ / JE Cooler  
**Repository:** TenzoNkz/JEXFYZ-App — branch main  
**Last completed release mode:** Eksekusi Build App! — guarded App Build / QC / release only.  
**Current mode:** Diskusi! — read-only pre-implementation consistency review.  
**Build #163 disposition:** **COMPLETED / SUCCESS.** No active Build run remains. No Firmware compile/BIN, Firebase mutation, OTA, flashing or device operation was performed or authorized.  
**Current Diskusi disposition:** **WAITING_OWNER** for explicit `Eksekusi Full!`; source/test/native/config/workflow/build/release/Firmware/device changes remain unauthorized in this mode.

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

## Recovery note — Chat Stuck! — 2026-11-16 09:28 Asia/Jakarta

- The prior audit interaction was interrupted while still marked IN_PROGRESS. Its last durable point is the inventory, source inspection and findings in the section immediately below; no source/test/native/config/workflow write was made.
- Re-checked live main: `ad75589a2f5e8d326f5194455713e2688c1ccb07`; recursive tree is complete (139 entries, 53 Markdown files, not truncated).
- Re-checked the only recorded external operation, Build #163 run `43679305537`: terminal `completed / success`, job `132706236782` completed successfully; Release `403010611` / tag `jexfyz-latest` still has exactly one APK and one source ZIP. No active or queued Build operation is associated with this recovery.
- Resume the same owner request under the inherited `Diskusi!` boundary: audit and document the complete bilingual copy/format correction plan only. Do not edit executable source, tests, Kotlin, configuration, Firmware, workflows; do not run formatter, analyzer, tests, build, OTA or device operations.
- Verified live-source additions from the interrupted pass: Usage Statistics has mixed-language helper text, raw `FAN` / `PELTIER` tokens in an empty-state explanation, incorrect `Suhu Baterai HP` / `Suhu Hotside` / `Baterai HP` labels; Home notification generation and legacy-message normalization still produce or retain Hotside in Indonesian; the axis/overlay decimal and session-date formats are not fully locale-aware. See APP_NOTES.md for the consolidated audit.

## Comprehensive language / writing / format audit — 2026-11-15

**Owner request:** “Perbaiki semuanya bahasa, ejaan, penulisan, format, serta capitalnya!”  
**Current mode:** Diskusi — full audit and documentation only; no source/test/native/config/workflow/build change.

### Full-surface inventory

- lib/app_settings.dart: 353 bilingual dictionary entries; each currently contains EN and ID values. Structural placeholder checks do not prove linguistic quality.
- Direct bilingual phrases: lib/main.dart 117, lib/floating_monitor.dart 11, lib/usage_statistics.dart 39; **167 total**.
- JexText.of() lookup call sites across those three UI files: **258 total**.
- Native notification/localized content is maintained separately in JeForegroundService.kt, FloatingMonitorService.kt and MainActivity.kt.
- Existing checks include test/localization_contract_test.dart, test/device_copy_notification_contract_test.dart, test/widget_test.dart and test/usage_statistics_test.dart. Current tests do not comprehensively verify grammar, meaning, word choice, typography, date/number/unit formats or all native strings.

### Confirmed source corrections to implement

- Dictionary: translate all visible Hotside occurrences into Sisi Panas in Indonesian (component, temperature, limit, protection, profile, notification and error copy); never rename internal code/protocol identifiers.
- Usage Statistics: correct “Suhu Baterai HP” → “Suhu Baterai”; “Suhu Hotside” → “Suhu Sisi Panas”; “Baterai HP” → “Baterai”; translate generic “cooler” as “pendingin”; rewrite the Info sentence as natural full Indonesian; replace raw FAN / PELTIER tokens in the empty state with readable user-facing names.
- Home/NOTIFY: use Sisi Panas in re-arm, threshold, profile and limit messages; preserve old stored notice variants in the parser, but ensure every newly generated Indonesian message uses the approved vocabulary.
- Settings/Floating Monitor: review every dynamic dictionary lookup and inline phrase, including “Firmware V7.2+ required”, while preserving the actual technical meaning.
- Native notifications: audit the channel name, description, foreground notification title/body and alerts in all three Kotlin source files as complete bilingual pairs; preserve stable channel identifiers and the owner's approved Bluetooth notification copy.
- Color Picker: review all named color/shade translations for precise hue meaning, accepted Indonesian terms, duplicate display names and consistent capitalization; do not change HEX values or persisted IDs.
- Tests: update old expected labels in test/usage_statistics_test.dart and test/widget_test.dart; add a semantic glossary/content-quality contract and more complete native/locale/date/number coverage.

### Formatting and capitalization findings

- usageStateLabel() emits voltage with a space (“12 V”) while other visible strings still use “5V/9V/12V”.
- Usage Statistics _formatTemperature() already localizes decimal separators and includes a space before °C; Home NOTIFY and chart reference labels often append °C without a space.
- formatUsageAxisTick() has no locale input and always uses a decimal point; Indonesian fractional ticks require a comma. Floating Monitor scale text also uses a fixed decimal point (“0.60×”) in both locales.
- Session date labels use fixed dd/MM HH:mm for both languages and omit the year; review for locale-appropriate, unambiguous display while preserving local-time conversion and compact layout.
- Capitalization varies by context (for example “Coba Lagi” vs “Coba lagi”, “Firmware” vs “firmware”). Apply title capitalization to headings/short named labels, sentence case to full prose, and preserve proper names/acronyms. Keep ALL CAPS only for deliberate status chips and state abbreviations.
- Keep physical output wording separate from logical mode and preference wording; do not globally replace ON/OFF, ACTIVE/INACTIVE, ENABLED/DISABLED. Continue using “Keselamatan” for thermal safety, not “Keamanan”.
- Owner-approved exceptions remain: English / Indonesia picker labels; Floating Monitor / Monitor Melayang; Notification / Notifikasi heading; Bluetooth connected notification; App Developer & Builder / Pengembang Aplikasi & Perakit credit. Do not revise these as incidental copy cleanup.

### Agreed content standard

English is the default master/source and must be complete, grammatical, concise and semantically precise. Indonesian must be a complete, natural, standard translation—no mixed generic English, dropped conditions, changed severity or rewritten meaning. Preserve technical terms/acronyms only where justified. Use consistent title capitalization for headings/short labels, sentence case for sentences, proper-name/acronym casing, one punctuation policy, locale-aware decimal/grouping/date presentation and consistent units (12 V, 45 °C, 50%). Keep raw protocol/internal identifiers out of user-visible prose. Full details and the approved glossary are in APP_NOTES.md under “Global language, writing and formatting standard”.

**Evidence boundary:** source inspection only. No formatter, analyzer, Flutter tests, Android rendering, screenshot review or App Build was run. No source/test/native file was changed. Build #163 remains the latest verified package and still contains the pre-correction text.


### Recovered audit additions — 2026-11-16

- Revalidated live source counts: 353 bilingual dictionary entries (the current source is not 354), 167 inline phrase pairs and 258 lookup calls. All entries have both locale values, but that is structural evidence only.
- Additional verified defects: `volt` is EN `Volt` / ID `Tegangan` (English should be `Voltage`); OTA mode label `Online` is unchanged in Indonesian (use `Daring` in localized OTA copy); `Adaptive Mode is forced OFF` is translated with physical-output term `MATI` even though Adaptive is a logical mode (use `inactive/nonaktif`); Temperature screen `5V Limit/12V Limit` labels obscure the battery-temperature ceiling/floor roles.
- Native Floating HUD emits a bare `°`, does not space the voltage value, and omits `%` from the Fan Speed number. Keep compact metric IDs `B/H/V/A/P/F`, but localize/complete display units only.
- Phone battery temperature display, Home threshold notices, Usage axis ticks and Floating Monitor scale labels do not all apply Indonesian decimal commas. The BLE `PHONE:BT=` payload must retain its existing dot decimal. Home notice parsers must continue to accept old stored `Hotside` and unspaced `°C` forms as well as the new translated/locale forms.
- Session timestamps use fixed `dd/MM HH:mm` and omit the year; OTA byte counts are not locale-grouped. MainActivity's `Device alerts` / `Notifikasi perangkat` channel title pair is not equivalent; use `Peringatan perangkat` for Indonesian. The owner-approved Bluetooth notification and Floating Monitor notification pairs remain unchanged.
- Color shade labels need hue/HEX-aware terminology review; proper named colors must not be replaced with approximate hue guesses. Do not change HEX values or stored color IDs.
- Full source locations, proposed copy, protected invariants and regression matrix are recorded in APP_NOTES.md under `Resumed full-surface copy audit — 2026-11-16`. No executable source/test/native file or config was modified; no formatter/analyzer/test/build/device operation was run.

## Owner decision — Adaptive profile names / ceiling card / RGB switch — 2026-11-15

**Mode:** Diskusi; source, tests, Firmware, protocol, config and build remain read-only.

- Remove the entire Adaptive-page information card that displays `Adaptive Limit / Batas Adaptif` and the current ceiling voltage. Do not replace it with another visible ceiling row/table/text in that profile area.
- This removes only the presentation card. Keep internal `adaptiveCeiling`, `ADAPTIVE_CEILING` telemetry, Firmware clamp/ceiling behavior, and safety/voltage-transition logic intact. Do not remove or weaken the actual maximum-voltage ceiling.
- Replace the two visible Adaptive profile titles with these bilingual pairs:
  - EN `Hotside Protection` / ID `Perlindungan Suhu Panas`
  - EN `Hotside & Battery Protection` / ID `Perlindungan Suhu Panas & Baterai`
- These are the exact owner-approved English master labels; do not insert `Temperature`, hyphenate `Hotside`, or replace `&` with `+`. They apply only to this selector. Keep internal values `HOTSIDE`, `HOTSIDE_BATTERY`, `HOTSIDE_PROTECTION` and all storage/protocol identifiers unchanged. 
- RGB recommendation: **keep `RGB Power` / `Daya RGB`** as the toggle label. Keep `LED` as the enclosing section title. The switch controls the user RGB effect only, not all physical/system/safety LED indicators; “LED” or “LED Power” on the toggle would overstate its function.
- Regression plan: verify the Adaptive ceiling card is absent; both profile labels switch correctly EN/ID; internal ADAPTIVE_CEILING clamp/telemetry and Lock Voltage remain unchanged; LED heading and RGB Power/Daya RGB control remain; independent system/voltage/safety LEDs are not gated by RGB state.
- Full decision and exact source location/rationale are in APP_NOTES.md under “Owner decision — Adaptive profile labels, Adaptive ceiling display and RGB toggle”.
- No source/test/Firmware/config change, formatter/analyzer/test, App Build, Firmware compile or device operation was performed in this Diskusi.

## Pre-execution consistency review — 2026-11-16

- Live source mapping: the Adaptive selector in `lib/main.dart` reads `hotsideProtection` and `hotsideBattery`; their current `lib/app_settings.dart` display values do not match the exact owner-approved bilingual labels. Update those active keys to `Hotside Protection / Perlindungan Suhu Panas` and `Hotside & Battery Protection / Perlindungan Suhu Panas & Baterai`. Preserve legacy aliases `hSideProtection` / `hSideBattery`; never globally replace generic `hotsideProtectionActive` copy.
- Preserve the presentation-only Adaptive card removal: remove only the visible card/readout built from `adaptiveCeiling`, but retain state, `ADAPTIVE_CEILING` telemetry, Firmware clamp, profile logic and Lock Voltage behavior.
- Current package documentation is reconciled to Build #163 across APP_NOTES.md, APP_PREBUILD_AUDIT.md and DESIGN_NOTES.md. Build #163 remains run `43679305537` / job `132706236782`, source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`; Release/tag and two artifact digests are verified in the subject notes.
- Additional existing audit items remain: generic Hotside translation, Usage Statistics text and raw-token cleanup, Home notice legacy parsing, decimal/date/unit/byte formatting, native HUD units, Device alerts channel copy, semantic regressions and HEX-aware color naming. Temperature-zone ceiling/floor labels remain candidates until the actual Firmware comparison semantics and UI fit are checked; do not change thresholds or control behavior.
- This preflight updated documentation only. No App source/tests/Kotlin/native/config/workflow/Firmware changes and no formatter/analyzer/Flutter test/Gradle/render/build were run.

## Next action

- Recommended next mode: `Eksekusi Full!` to implement the reviewed EN/ID copy and formatting scope from APP_NOTES.md, including the corrected active Adaptive key mappings, generic Hotside prose, Usage Statistics, Home/NOTIFY legacy parsing, native HUD and device-alert copy, locale-aware numbers/dates/units/byte grouping, HEX-aware color review, and semantic/native regression tests. Preserve internal telemetry, BLE/protocol/state identifiers, NVS/SQLite compatibility, Firmware safety/clamps, RGB indicator priority, HEX values and notification channel/IDs. This recommendation is not authorization; wait for the owner's explicit mode command. A new APK still separately requires `Eksekusi Build App!`.
- Owner installation and physical-device/OEM visual/BLE verification of Build #163 remain separate and are not inferred from CI.
- For routine chat transfer, load only this bounded checkpoint; full build history remains in append-only `APP_BUILD_REPORT.md`, and older transfer history remains archived without being loaded during routine boot.
<!-- ACTIVE_CHECKPOINT_END -->