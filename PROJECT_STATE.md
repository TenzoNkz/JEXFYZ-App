# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-18 18:05:22 (Asia/Jakarta).

## Repository baseline

- Canonical repository/branch: TenzoNkz/JEXFYZ-App / main.
- Latest published App package: Build #165 / run 43905426531 / job 133432846684 / Issue #42 / Release 403010611 / tag jexfyz-latest; immutable package source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d; terminal SUCCESS.
- Latest validated App source/test tree: 0a2b3c03af433a17d82afa1d4db60beb7b1bd023, formatter-only result from Validation Only #44. The same App source/test content was packaged by Build #165; compare from that tree to Build checkout is 17 documentation-only commits ahead / 0 behind.
- Current repository tree remains 139 entries and not truncated. Build ledger/history remains in APP_BUILD_REPORT.md; rolling continuation remains in CHAT_TRANSFER.md.

## Bluetooth device-name display correction — included in Build #165

**Status: SOURCE + REGRESSION IMPLEMENTED / HOSTED VALIDATION GREEN / INCLUDED IN LATEST RELEASE. Physical BLE/OEM confirmation remains NOT VERIFIED.**

- Firmware V7.2 already declares BLE_NAME = JE X FYZ and initializes the BLE peripheral with it. No Firmware/BIN change was needed or made.
- App root cause: the Connection row masked the real local name with a localized generic Device / Perangkat label.
- lib/connection_scan_state.dart implements connectionDeviceDisplayName(...): current advertisement name first, Android platform name second, localized generic fallback only if both are empty. lib/main.dart uses the helper.
- Regression coverage: advertisement-name precedence, platform-name fallback, empty fallback, and Connection sheet source contract. BLE UUID/service filter, scan lifecycle/ownership, connection handoff, P1 protocol and Firmware source were not changed.
- Validation Only #44 / run 43899329198 / job 133411358928: formatter final PASS, analyzer 107 info-level / zero warnings/errors, Flutter tests 205/205 PASS. Resulting formatted source/test tree 0a2b3c03af433a17d82afa1d4db60beb7b1bd023.
- Build #165 source includes the validated App code/tests. - Owner reports that the App again safely displays `JE X FYZ` (USER-REPORTED, 2026-11-18). No screenshot, exact installed APK/build or live advertisement payload was supplied, so independent visual/RF/OEM confirmation remains unverified. No additional source repair or App Build is indicated by this report alone.

## Latest verified App package — Build #165 SUCCESS

- Build #165 / run 43905426531 / job 133432846684 / Issue #42 / attempt 1 / source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d. All workflow steps 1–21 and cleanup 39–43 SUCCESS.
- Analyzer 107 infos / 0 warnings/errors; Flutter tests 205/205; Android Gradle BUILD SUCCESSFUL in 3m20s, 162 actionable tasks (161 executed, 1 up-to-date). Native App JUnit tasks were NO-SOURCE.
- APK JEXFYZ-release.apk, 55,881,819 bytes, SHA-256 1934f9223ea4d5ffbd540601c69157d13923b996c41cf0694128e19372809687.
- Matching source ZIP, 2,945,408 bytes, SHA-256 6f98df3633c00d74a7687697a3332a16606d7edea76f82d1a00d8d201e82bd29; embedded source marker matches exact packaged SHA.
- Release ID 403010611 / tag jexfyz-latest; Release target and tag ref match exact source SHA. Exactly one APK plus one corresponding source ZIP. Step 21 downloaded checksum, ZIP integrity, APK signature/certificate identity all passed.
- V1/V2/V3 signature validation and pinned certificate fingerprint dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0 passed. Certificate remains self-signed / PKIX chain untrusted; META-INF signature coverage warnings remain.
- Protected Flutter version 1.0.0+3 and Android versionName Telegram @horizontalzzz unchanged.

## Previous verified App package — Build #164 (superseded)

- Build #164 / run 43863417641 / job 133285765871 / source a41baaf3bc53a02d72e12a4f3840f0c84c493497 was terminal SUCCESS and remains preserved in APP_BUILD_REPORT.md and BUILD_NOTES.md history.
- Build #164 predates the Bluetooth display-name correction; Build #165 is now the current published package.

## Remaining evidence boundaries and next action

- Owner reports the App again displays `JE X FYZ` (USER-REPORTED); screenshot, installed package identity and advertisement payload were not independently verified. Broader OEM BLE/RF behavior, long-session performance/storage soak, Firmware compile/BIN provenance, BLE App authentication, Firebase, OTA/flash, thermal and electrical acceptance remain separate and unverified.
- Retained Build #165 warnings: self-signed certificate/PKIX and META-INF signature coverage; Kotlin 2.2.20 / Firebase KGP compatibility warning; Android Gradle property and Gradle 10 deprecations; native Notification priority deprecations; native ELF DWARF; native Android JUnit tasks NO-SOURCE. None are represented as fixed.
- **CURRENT / VERIFIED owner screenshot — 2026-11-18, phone clock 14:13:** the Rulesets list shows `main-safety-guard` with Active status, 2 branch rules and 1 targeted branch. The open menu contains Export ruleset and Delete ruleset; no menu action was taken by the assistant.
- **CURRENT / VERIFIED live Rulesets API — 2026-11-18 14:19:11:** at main HEAD `81a17a212dc3cecf1e3aed3d29f7c1edc0e716af`, repository metadata confirms default branch `main` and the recursive tree has 139 entries with `truncated=false`. The API lists exactly one branch ruleset: ID `27528678`, `main-safety-guard`, enforcement `active`. Details: include `~DEFAULT_BRANCH`, exclude none; rules `deletion` and `non_fast_forward`; bypass actors empty; `current_user_can_bypass=never`. GitHub reports creation at 2026-11-18 14:13:18 +07:00. This matches the owner-approved setup.
- Ruleset setup is complete. Do not select `Delete ruleset`; close the menu without selecting an item. No force-push or deletion test is needed.
- **Next step:** no Eksekusi Full! or Eksekusi Build App! is indicated for this reported display result. If independent evidence is later needed, the owner can provide a fresh scan screenshot and installed build details; hosted CI alone does not prove physical BLE behavior.
- Classic branch protection remains separately API-UNVERIFIED (the integration previously returned 403); prior owner UI evidence showed no classic rule listed. Recheck the Branches page only if the owner wants current visual confirmation.
- No Firmware compilation, BIN generation/publication/replacement, Firebase mutation, OTA, flashing or device operation was performed or authorized.

## Historical hosted validation baseline — Validation Only #19 SUCCESS (pre-localization correction set)

- Run/job: 43677560315 / 132700920324; tested source 8fca2ecebf8b2ffb83fc9475a817c832f8269dc5; terminal SUCCESS.
- Flutter 3.47.2 / Dart 3.13.2; locked dependency resolution PASS.
- Formatter checked 18 files, applied one correction, then final check passed with zero remaining changes. Formatter-only follow-up fc39de16a5480347ce13083760424a309957c311 changes one test assertion's line wrapping only.
- Analyzer: 118 info-level findings, zero warnings/errors. Flutter tests: 197/197 passed.
- Validation Only #18 (43677411117) remains a failed historical intermediate (196/197); the stale LED-copy expectation was corrected before #19.

## Historical App package — Build #163 SUCCESS (superseded by Build #165)

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

## Current Ruleset status and next action

- **Historical pre-Create evidence, superseded:** the 13:50 screenshots showed an unconfigured draft and the 13:52 API check returned `[]`. The owner later submitted Create; those earlier observations do not describe the current settings.
- **Current owner screenshot — 2026-11-18, phone clock 14:13:** the Rulesets list shows `main-safety-guard` as Active, with 2 branch rules and 1 targeted branch. The Export/Delete menu is open; the assistant did not select either option.
- **Current live API verification — 2026-11-18 14:19:11 Asia/Jakarta, main HEAD `81a17a212dc3cecf1e3aed3d29f7c1edc0e716af`:** repository default branch `main`; recursive tree 139 entries / 93 blobs / 46 trees, `truncated=false`; exactly one Ruleset, ID `27528678`, active. It includes `~DEFAULT_BRANCH`, excludes none, has rules `deletion` + `non_fast_forward`, an empty bypass list, and `current_user_can_bypass=never`. Created at 14:13:18 +07:00. This matches the approved configuration.
- Ruleset setup is complete. Close the open menu by tapping outside; do not select **Delete ruleset**. No deletion or force-push test is needed.
- **Next separate project acceptance:** owner installs Build #165 and confirms that the actual cooler advertisement and App Connection row display `JE X FYZ`. Physical BLE/OEM behavior remains unverified.
- Classic branch protection remains API-UNVERIFIED because the connected integration previously returned 403. Prior owner UI evidence showed no classic rule listed; this is separate from the Rulesets result.
- Build #165 remains the latest verified package. No Firmware compile/BIN, Firebase, OTA, flashing, thermal/electrical or device operation was performed or authorized in this Diskusi.
