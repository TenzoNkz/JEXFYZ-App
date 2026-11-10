## Current App build candidate — Build #141 active (2026-11-10)

- **Latest verified package:** Build #138 / run `42749408202`, source `b553f22092d9b33b2c81753254d2e3f03928fa18`; 21 main gates and Flutter 157/157 passed, analyzer 25 infos, Android Gradle gate with app JUnit tasks `NO-SOURCE`, signing/certificate, source ZIP, Release/tag and downloaded-asset identity/checksums verified.
- **Build #139:** terminal analyzer failure due outdated `lastTemperatureChangeAtMs` plus unused locals; repaired by `93b1ba7b859089eeccd30719ddfb8b8ab2dabaf6` and `2656b6eb9071cf878de2373cfab03d1872e089f8`.
- **Build #140:** run `42781821476`, job `129713425920`, source `cdd0b6dc6bc91d01029e89a0b88fc1185205e239`, terminal analyzer failure. Test declaration `lastValidSample` had two stale `lastValueChange` references. Repair commit `2a0b1b94f7ebce1607ba26067441accb31a105c7` updates both; file read-back verified. Steps 13–21 skipped; no asset/Release mutation.
- **Candidate before docs checkpoint:** `2a0b1b94f7ebce1607ba26067441accb31a105c7`, complete tree 131 entries. Current App changes include Default hybrid Home header correction plus authoritative FAN/PELTIER-active per-second Usage Statistics; the analyzer repairs are committed.
- **Build #141 CI:** run `42782355435`, job `129715178789`, source `2fb8dc6ec4a0f41e7cce73e6a49db0e716b56cda` exactly matched main at trigger. Steps 1–3 success; step 4 Flutter setup in progress; steps 5–21 pending. No result claimed yet.
- **Trigger:** issue #33 exact/open; it was closed once/reopened once; exactly one #141 run appeared. No active duplicate or open PR. Workflow unchanged issue-only with all 21 gates. Preserve `versionName "Telegram @horizontalzzz"`.
- **Status:** current App candidate/test repairs committed and under CI validation in Build #141. Per-second storage stress, physical BLE, OEM visuals, install and thermal/electrical behavior remain UNVERIFIED.

---
## HISTORICAL App build candidate — Build #140 active before analyzer failure

- **Latest verified package:** Build #138 / run `42749408202`, source `b553f22092d9b33b2c81753254d2e3f03928fa18`; analyzer 25 infos, Flutter 157/157, Android Gradle gate successful with native app JUnit tasks `NO-SOURCE`, APK V1/V2/V3 and production cert, corresponding source ZIP, Release/tag parity and downloaded checksums/signatures verified.
- **Latest attempt #139:** run `42765001359`, job `129659294295`, source `2ad43deb499f73dede808e2cc03d1a8843697f59`, failed at analyzer step 12. Exact error was stale test reference `lastTemperatureChangeAtMs`; warnings were unused `range` and `expectedTime`. All downstream gates skipped; no APK or Release update. Concrete repairs are committed and included in #140 source.
- **Repairs committed/read back:** `93b1ba7b859089eeccd30719ddfb8b8ab2dabaf6` removes unused chart local; `2656b6eb9071cf878de2373cfab03d1872e089f8` updates regression test to current `lastTemperatureSampleAtMs` API and elapsed-sample wording and removes obsolete locals. Awaiting CI validation.
- **Current App source in Build #140:** immutable checkout `cdd0b6dc6bc91d01029e89a0b88fc1185205e239` (main matched exactly at trigger); recursive tree remains complete at 131 entries. Includes Default hybrid Home header resolver for metrics/NOTIFY while keeping Default lower panel light; Usage Statistics gated by synchronized authoritative FAN/PELTIER outputs; per-second Battery/Hotside SQLite samples with explicit null gaps on elapsed active-run time; Voltage/Adaptive/Fan Speed state events. The wall-clock period selector is removed; 30-day retention remains.
- **Release baseline:** Release `jexfyz-latest` ID `403010611` and tag still target #138 source; APK hash `2ed225d992288cccc02313d206675a7313c73a4cad061de70cddf7209d39b9f8`; source ZIP hash `47161a972131c95a74e8f5a191754504b76e2c31edd95fd19b1b4c75717ab906`.
- **Workflow/trigger:** unchanged guarded issue-only workflow; issue #33 exact/open; #139 terminal; no active/queued run, no open PR. No #140 trigger sent yet. Preserve `versionName "Telegram @horizontalzzz"`.
- **Build #140 CI:** run `42781821476`, job `129713425920`, active. Steps 1–3 passed; step 4 Flutter setup is in progress; steps 5–21 pending. No analyzer/test/build/signing/artifact result is claimed yet.
- **Status:** candidate source/test fixes committed but NOT YET CI-VERIFIED. Per-second SQLite capacity/queue stress, owner install, screenshot/OEM, physical BLE and thermal/electrical validation remain UNVERIFIED.

---
## HISTORICAL App build candidate — Build #139 pre-trigger before analyzer failure

- **Latest verified published package:** Build #138 / [Actions run 42749408202](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42749408202), source b553f22092d9b33b2c81753254d2e3f03928fa18; all 21 main CI steps passed, 157/157 Flutter tests passed and the hosted Release/download verification succeeded. Its APK/ZIP remain the current published artifacts, not the newer source candidate.
- **Current App candidate at preflight:** main 8115f6702c9be1381c10d1ed610b4a6e720c6753; recursive tree 131 entries, complete. The branch is 25 commits ahead of #138 source and 0 behind.
- **Default hybrid Home:** committed source now uses jexHomeHeaderUsesDarkPalette(AppThemePreset) for both metric/icon palette decisions and NOTIFY foreground; Default/Dark header dark, Light header light. jexDashboardContentUsesDarkPalette independently keeps Default/Light lower content light and Dark content dark. Test coverage exists for the three presets and both semantic areas. Awaiting CI.
- **Usage Statistics:** committed source now opens a run only after full synchronized BLE/P1 readiness and known authoritative Firmware outputs, with active = FAN ON OR PELTIER ON. Both OFF, disconnect or stale P1 ends the run. Battery and Hotside are stored as per-second samples, including null gaps, in local SQLite schema v2; Voltage/Adaptive/Fan Speed remain transition events against elapsed session time. The wall-clock 1H/24H/7D/30D selector is removed; 30-day pruning is retention only. Regression tests cover output gating, elapsed-time analytics, gaps, separate sessions and local-only storage. Awaiting CI; storage growth/backpressure stress validation remains open.
- **Workflow/trigger:** unchanged guarded issue-only workflow; issue #33 is OPEN and exact owner/title/token matched. No active/queued run or open PR exists. No #139 event has yet been sent; the checkpointed final main SHA must match the new run's actual head_sha.
- **Status:** App source/tests are committed but NOT YET VERIFIED BY CI on the new candidate. Build #138 remains the only verified package. Preserve versionName "Telegram @horizontalzzz".
- **Evidence boundary:** installation, physical BLE, screenshot/OEM acceptance, cooling/thermal/electrical behavior, Firmware/BIN and OTA remain separate and unverified. No Firmware/device operation occurred.

---

## Current App release and validation — Build #138 — 2026-11-10

- **Latest verified published package:** Build #138 / [Actions run 42749408202](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42749408202), job `129609197264`, terminal `success`, immutable tested source `b553f22092d9b33b2c81753254d2e3f03928fa18`.
- **CI:** all 21 main workflow steps succeeded. Dart analyzer exited successfully with 25 info-level diagnostics and no analyzer warnings/errors. Full Flutter suite: **157/157 passed**, including the responsive Usage Statistics reset and localization trailing-comma contract repairs.
- **Android gate caveat:** Gradle `:app:testDebugUnitTest` command completed successfully in 3m 33s, but app JUnit compile/test tasks were `NO-SOURCE`; no native app JUnit case executed.
- **Artifact provenance:** obfuscated APK built; V1/V2/V3 verification and expected production certificate identity passed. Release `jexfyz-latest` ID `403010611` and tag target the exact source SHA. Exactly one APK and one corresponding source ZIP were published and re-downloaded/verified.
- APK asset `729969125`: 55,455,835 bytes; SHA-256 `2ed225d992288cccc02313d206675a7313c73a4cad061de70cddf7209d39b9f8`.
- Source ZIP asset `729969127`: 2,908,354 bytes; SHA-256 `47161a972131c95a74e8f5a191754504b76e2c31edd95fd19b1b4c75717ab906`.
- **Post-build repository state:** `main` contains documentation-only checkpoint, build-ledger, state and handover updates beyond the exact tested source. No executable source, tests, configuration or workflow changed after Build #138. Docs newer than the APK source do not alter package provenance.
- **Outstanding owner/device validation:** Build #138 installation, screenshot/OEM visual acceptance, physical BLE lifecycle, storage-size stress and cooling/thermal/electrical behavior are UNVERIFIED. Build #138 is VERIFIED CI, not physical acceptance. Gradle cache writes were non-blockingly denied by token scope; workflow succeeded.
- Preserve Android `versionName "Telegram @horizontalzzz"`. No Firmware compile/BIN, Firebase, OTA, flashing or device operation was part of the App build.

---

## App — Usage Statistics implementation state (2026-11-09)

- **Owner direction:** no standalone Firmware timer for now. Build an App Usage Statistics / Statistik Penggunaan page inside Settings from locally recorded telemetry.
- **Build #138 layout baseline (superseded by owner revision below):** Phone Battery Temperature trend first; Hotside Temperature trend second; Operating Profile timeline third with Voltage (5V/9V/12V), Adaptive ON/OFF and Fan Speed (%) lanes. Released periods were 1h / 24h / 7d / 30d, default 24h; the owner now requests per-second active-session elapsed time instead.
- **Capture:** while a synchronized cooling run is active, persist each phone Battery 1Hz observation and each Firmware HOT heartbeat as a timestamped sample, even when unchanged; persist explicit null samples for stale/missing data rather than carrying values forward. Voltage/Adaptive/Fan Speed remain authoritative state-transition events.
- **Storage:** App-local SQLite (sqflite 2.4.2), not flutter_secure_storage, Firmware NVS or Firebase. Current source uses schema v2 with a usage_samples table for per-second Battery/Hotside readings plus usage_events for state transitions; it prunes older data under a 30-day retention rule. No 1-minute rollup table exists. Storage-size and recorder-queue stress validation remain open.
- **Status:** VERIFIED CI in Build #138 / source `b553f22092d9b33b2c81753254d2e3f03928fa18`. The full Flutter suite passed 157/157 and includes Usage Statistics chart/timeline layout, timestamp and localization contracts. The page, P1 sync-gated capture, SQLite persistence, Settings navigation, graph/timeline periods, clear-history and 30-day retention were included in the released source. Storage-size stress validation remains open; owner installation, screenshot/OEM behavior, real BLE session capture and device behavior remain UNVERIFIED.
- **Timer decision:** separate Firmware session/operating timer is DEFERRED by owner in favor of this App Usage Statistics feature; see `FIRMWARE_NOTES.md`.

- **Owner revision (2026-11-10):** remove the 1H/24H/7D/30D chart-period selector. The user wants per-second Battery/Hotside samples only while the cooler is actually operating; no samples or active-duration accumulation while idle/OFF/disconnected. Recommended active rule: authoritative `FAN == ON` OR `PELTIER == ON`; fan-only thermal-protection operation still counts because a physical output is running. `ADAPTIVE` flag/connection/ACK alone is not sufficient.
- **Implemented session/display model:** each OFF→ON run is a separate local session. The session starts only after full P1 readiness and known authoritative outputs show FAN ON or PELTIER ON; fan-only thermal-protection operation counts. Both OFF, disconnect/disposal or stale P1 closes it. Per-second Battery/Hotside observations use elapsed-run time, with explicit null gaps; Voltage/Adaptive/Fan Speed remain state transitions. The 1H/24H/7D/30D selector is removed; 30-day pruning is storage retention only.
- **Implementation source:** lib/main.dart gates start/end from synchronized output telemetry; lib/usage_statistics.dart uses SQLite schema v2 (usage_samples plus usage_events), serializes recorder writes, stores 1Hz readings, and ends sessions on P1 staleness. Core commits: 8c1d57b593e7f471a0d5715929575f416e396a2b, 58fdac9fab2ce15b9154907d369096a49fb6b308, and coverage commit 0413b536fcb5771652ad6312cc40b5bcb748639e.
- **Status:** APP SOURCE/TEST IMPLEMENTED ON MAIN; AWAITING VERIFIED CI in Build #139. Build #138 is a prior package containing the earlier wall-clock-period design and does not include this new model. Per-second database growth/queue backpressure, physical BLE sampling and owner/OEM visual acceptance remain UNVERIFIED.

## Firmware — Touch single-tap Voltage one-way cycle requested (2026-11-09)

- **Owner request:** physical TTP223 single tap must cycle `5V → 9V → 12V → 5V → 9V → 12V → ...`, not ping-pong `5V → 9V → 12V → 9V → 5V`.
- **Current implementation:** only active sketch is `firmware/JEXFYZ-V7.1.ino`, embedded `FW_VERSION="V7.1"`, source blob `c44e076b2c1ee2d0b66b4fcd308d0febc69976e9`. `executeTouchSingle()` uses `touchVoltageAscending` to reverse direction; static inspection confirms the reported behavior. The current QC test file pins the V7.1 filename/version and has no test for the Touch Voltage cycle.
- **Decision/specification:** derive the next step from authoritative `currentVoltage`: V5→V9, V9→V12, V12→V5. Keep the change limited to hardware single tap while Adaptive is OFF. App/manual rail changes should naturally become the new starting point. Double tap RGB, long press, Touch debounce/timing, and Adaptive gate remain unchanged.
- **Safety invariants:** preserve `requestVoltage()` validation (OTA/transition/manual permission, voltage guard, NTC safe-5V, Hotside and Adaptive clamp), 200 ms selector deadtime, 1 s guard, Peltier soft-start pause/resume, Fan 100% handoff, safety override priority and non-blocking millis() logic.
- **Implementation/version plan:** under a new explicit `Eksekusi Full!`, update the source/test contracts, rename the one active sketch to `firmware/JEXFYZ-V7.2.ino`, set `FW_VERSION="V7.2"`, update hard-pinned test source paths/version expectations and add sequence/rejection/other-gesture regression coverage. Owner-side compilation with Arduino-ESP32 Core 3.3.7, BIN identity/publication, Firebase and OTA/flash are separate and are not authorized by Diskusi or Eksekusi Full.
- **Current evidence/status:** STATIC SOURCE CHECK and owner requirement recorded; REQUEST RECORDED / NOT IMPLEMENTED. No executable Firmware source/test changes, compile, BIN, Firebase, OTA or device action occurred.

## Prior App release and Home Light Mode repair — Build #133 (superseded by Build #138 on 2026-11-10)

- **Historical package:** Build #133 / [Actions run 42619673642](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42619673642), terminal success, all 21 main workflow steps passed. Its tested/package source SHA was `5201a3e07f36305ffe3882a1b965b9e7414cd71a`; Build #138 is now the current published package.
- **Included Home change:** theme-aware painter depth/cavity colors across Battery, Hotside, Voltage, Adaptive, Peltier, Fan and Fan Speed; Light Mode metric accent contrast; Light Mode NOTIFY success/warning/error foreground contrast. Dark Mode painter colors and status-card tints/predicates remain preserved. Theme palette changes invalidate painter output.
- **Regression and QC evidence:** analyzer exit 0 with 25 info-level diagnostics; full Flutter test suite **145/145 passed**, including painter theme/repaint, Light/Dark fallback, metric contrast and composited NOTIFY foreground tests. The #132 indentation-sensitive source-contract matcher was repaired by whitespace normalization while retaining semantic color/helper/state/geometry assertions.
- **APK:** Release asset `727484780`, 54,849,627 bytes, SHA-256 `8fc837b9ec946cb3bccb6a8d400dc1483a19de9eff506c22ada2d4dcef0b1146`.
- **Matching source ZIP:** asset `727484787`, 2,890,067 bytes, SHA-256 `3a35158b16df567dbc2be1804c9bd0681d96012daffc61adddf61aa6b7be01fb`.
- **Signing/release identity:** V1/V2/V3 all verified; expected production certificate DN and SHA-256 match. Release ID `403010611`, live tag `jexfyz-latest`, Release metadata and tag ref all target the exact package SHA. Exactly one APK plus one matching source ZIP; step 21 downloaded both and verified digest, source marker, ZIP integrity, APK signatures and certificate.
- **Android Gradle caveat:** `:app:testDebugUnitTest` gate passed (`BUILD SUCCESSFUL in 3m 29s`), but native app JUnit compile/process/test tasks were `NO-SOURCE`; no native Android JUnit case ran.
- **Release warnings:** 25 Dart infos; Kotlin Gradle Plugin 2.2.20 upgrade advisory; deprecated Android Gradle options / future Gradle 10 warnings; nonfatal Flutter watcher and ELF DWARF notices; self-signed/untimestamped certificate and auxiliary META-INF JAR notices; post-job cache saves denied by token scope but cleanup succeeded. Required V1/V2/V3 and expected production certificate checks passed.
- **Source/HEAD parity at Build #133:** at the time of that package, later `main` commits were documentation-only. This was superseded on 2026-11-10: current `main` includes the Usage Statistics and persisted-temperature-timestamp App/test changes described in the current Build candidate checkpoint above; Build #133 does not contain them.
- **Field boundary:** Build #133 installation is not independently confirmed. No screenshot/OEM visual acceptance, physical BLE session, cooling/thermal measurement, Firmware compile, BIN/Firebase mutation, OTA, flashing or device operation occurred in the build.
- **Historical next action superseded:** installation/visual acceptance should now be performed against Build #138, not Build #133.

## Agent skills and capability system

- `MASTER_PROMPT.md` remains the single operating authority; `AGENTS.md` is the cross-agent entrypoint and `SKILLS_INDEX.md` maps the reusable skill library.
- Twelve task-specific skills are now present as canonical `.agents/skills/*/SKILL.md` definitions for Codex-compatible discovery and byte-identical `.github/skills/*/SKILL.md` mirrors for GitHub Copilot, including Copilot code-review and product-design quality guidance.
- Skills cover repository forensics, code review, product design/visual quality, Flutter App engineering, Flutter test/regression, BLE P1 audit, ESP32-C3 Firmware safety, OTA/release integrity, GitHub Actions triage, electronics/power/thermal analysis, technical research/Gemini and documentation/memory governance.
- UI work now routes through `product-design-and-visual-quality`, `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md`. These documentation standards do not change UI source or validate/release the pending compact Settings/Connection pass.
- Current ChatGPT mobile/web must fetch/read relevant repository skill files through GitHub tools when needed; do not claim private repo skills are automatically installed in ChatGPT. Gemini still has no GitHub access and is only a manual second-opinion handoff.
- Current container checked 2026-11-07: Python 3 and Git are available; Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF are absent. Re-check tool availability per task. This environment cannot claim local Flutter/Android/Firmware builds or physical-device validation.
## Production and release baseline

- **Protected known production reference:** App Build #124 + Firmware V7.1. Keep separate from the newest published App package and from the exact package actually installed on the field phone.
- **Latest independently verified published App package:** Build #138 / run `42749408202`, exact tested source `b553f22092d9b33b2c81753254d2e3f03928fa18`. Release `jexfyz-latest` (ID `403010611`) and lightweight tag target this same SHA.
- APK asset `729969125`: 55,455,835 bytes, SHA-256 `2ed225d992288cccc02313d206675a7313c73a4cad061de70cddf7209d39b9f8`.
- Corresponding source ZIP asset `729969127`: 2,908,354 bytes, SHA-256 `47161a972131c95a74e8f5a191754504b76e2c31edd95fd19b1b4c75717ab906`.
- Build #138 passed all 21 workflow main steps, analyzer (25 info-only diagnostics), all 157 Flutter tests, configured Android Gradle gate, obfuscated APK build, V1/V2/V3 and expected production-certificate checks, corresponding source archive integrity/source marker, exact Release/tag parity and downloaded asset checksums/signatures.
- Android `:app:testDebugUnitTest` succeeded, but app JUnit compile/test tasks were `NO-SOURCE`; no native app JUnit case ran.
- Current `main` is two documentation-only commits beyond Build #138 source; it does not change the executable package source. Latest release provenance remains pinned to the exact Build #138 SHA.
- **Field evidence UNVERIFIED:** Build #138 installation, screenshot/OEM QA, physical BLE lifecycle, Firmware V7.1 source-to-BIN identity, physical OTA/reboot and cooler thermal/electrical behavior remain unverified. Do not infer them from hosted CI.

## Current App source and validation

- Build #138 packages the current App source at `b553f22092d9b33b2c81753254d2e3f03928fa18`, including Usage Statistics, SQLite telemetry and its responsive/layout/localization regression fixes.
- Build #138 analyzer passed with 25 info-level diagnostics and no warnings/errors; Flutter suite passed 157/157. Android Gradle gate succeeded, with app JUnit tasks `NO-SOURCE`.
- The release remains obfuscated and production-signed; V1/V2/V3 checks, expected certificate identity, corresponding source ZIP and downloaded Release asset verification passed.
- Android `versionName "Telegram @horizontalzzz"` is preserved.
- Local formatter was not run in this session. Build #138's hosted workflow did not include a separate Dart formatter step.
- No actual screenshot/OEM visual QA, installation identity, physical BLE lifecycle test, usage-history soak/storage stress test or thermal/electrical validation has been performed. Hosted CI is not physical acceptance.

## Default hybrid Home theme contrast — implemented; awaiting CI (2026-11-10)

- **Observed:** owner-provided Default screenshot showed the intended dark Home header and light lower Display Menu panel, but low-contrast metric labels/values, NOTIFY body and animated metric glyph treatment in the header.
- **Root cause (STATIC SOURCE CHECK):** Default intentionally inherits Light Theme for the lower white panel and light dialogs, while the header is dark. The former inherited-brightness checks in _homeMetric() and _homeNotify() selected the wrong header foreground/painter palette.
- **Implemented source:** lib/app_settings.dart defines a single preset-based jexHomeHeaderUsesDarkPalette resolver (Default/Dark = dark; Light = light), and a separate jexDashboardContentUsesDarkPalette resolver (only explicit Dark = dark). lib/main.dart uses the header resolver consistently in metrics/indicator painter and NOTIFY; the lower-panel resolver and Default white surface remain separate. Source commits: 8b9e04e06cc28aa88cdd38e70dae48aa7c2b5ba7 and follow-up test 8115f6702c9be1381c10d1ed610b4a6e720c6753.
- **Regression contract:** test/widget_test.dart checks Default/Dark/Light palette mapping, NOTIFY resolver usage and metric resolver usage. This is committed source/test evidence only until hosted CI passes.
- **Status:** IMPLEMENTED ON MAIN / AWAITING VERIFIED CI. The owner screenshot's installed APK identity remains unknown. No physical screenshot/OEM acceptance is inferred from source or widget-test intent.

## Open design and engineering gaps

- **Physical App acceptance remains pending:** after the owner installs Build #138, inspect Home, Settings/Connection and Usage Statistics at 350-dp/420-dp, English/Indonesian, Light/Dark. For Home, verify Battery/Hotside/Voltage/Adaptive/Peltier/Fan/Fan Speed normal, warning and unknown states plus NOTIFY success/warning/error with one-/two-line copy. CI tests are not screenshot/OEM acceptance.
- **BLE runtime acceptance remains pending:** verify passive rediscovery, prerequisite cancellation, manual-sheet pre-emption and neutral dismissal, selected-device handoff, fresh primary/fallback advertisement handling, adapter loss and reconnect on the actual phone/cooler. Flutter tests do not represent a physical radio session.
- Exact Build #138 installed APK identity on the field unit, Firmware V7.1 source-to-BIN identity, physical OTA/reboot/BLE recovery and thermal/electrical behavior remain independently UNVERIFIED.
- BLE App-only identity authorization remains BLOCKED / NOT IMPLEMENTED until trusted enrollment/signing backend and Firmware verification exist.
- Rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm remains NOT IMPLEMENTED in Firmware V7.1; do not conflate it with Adaptive Fan tiers or ordinary Hotside-limit protection.

## Protected contracts

- Preserve Android Gradle versionName `Telegram @horizontalzzz`.
- Preserve BLE P1, authoritative telemetry, session synchronization, radio ownership, Touch synchronization, unknown/disconnected value semantics and persisted schema compatibility.
- Preserve safe outputs, calibrated one-sample-per-second NTC path, cooperative millis() timing, Peltier/selector/rail timing and OTA recovery.
- Online OTA intentionally uses `cloudClient.setInsecure()`; HTTPS server certificate identity is not authenticated. Preserve the allowlist, redirect blocking, response/size/image validation and safe-output/recovery behavior.
- Do not add Firebase firmware hash/signature requirements or a standalone Battery Protection Guard UI without explicit owner approval.
- The sold unit is not available for routine disassembly/repair; do not infer device-operation authorization.