## Current App candidate — guarded Build App requested (2026-11-11)

- **Owner command:** explicit `Eksekusi Build App!` authorizes one new guarded App Build/QC attempt for current source. This does not waive checks or authorize other subsystem/device operations.
- **Candidate main before documentation checkpoint:** `18787069be826cad3027dc1a1eb9952cfaf92641`; latest executable source/test commit `33fe9a545d7a8594e6e3a5119d3b1f564a93d868`.
- **Included App changes after Build #143:** compact Peltier safety prompt and LED color picker; six synchronized Usage Statistics charts/readouts (Battery, Hotside, Voltage, Adaptive, Peltier, Fan Speed); Peltier state seeded from P1 sync and recorded from telemetry; sensor freshness bounded by HOT heartbeat; shared cursor and interpolated temperature trends; one-second page-level chart batch flush; regression tests for overlay sizing, chart states/cursor/freshness/decimation and one-second refresh.
- **Known unverified risks:** full selected-session analytics summary is still recomputed on each one-second live batch; SQLite serialized write queue is unbounded/unbatched; long-session CPU/memory/backpressure and animation lifecycle/60–120-Hz stress tests remain incomplete. No local Flutter/Dart/Gradle available, so formatter and local tests/analyzer were not run.
- **Build preflight:** workflow blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`; guarded issue-only event; issue #33 OPEN and exact title/token; no active Actions run and no open PR. One new reopened event is authorized.
- **Release baseline:** Build #143 / run `42783474515`, source/tag `121ef9e0f5ed6a0003837d32e4c8b1701f38631a`. New candidate is not yet built/released.
- **Protected contract:** Android `versionName "Telegram @horizontalzzz"`. Firmware, BIN, Firebase, OTA, flashing, physical BLE/cooling actions remain out of scope.
- **Status:** PRE-TRIGGER. Await the official workflow's analyzer/test/Android/signing/Release/download verification; do not declare the new source released until every required gate passes.

---
## Current App release — Build #143 completed and verified (2026-11-10)

- **Latest verified package:** Build #143 / Actions run 42783474515, job 129718855331, final conclusion success; all 21 required gates and cleanup passed.
- **Exact package source/tag:** 121ef9e0f5ed6a0003837d32e4c8b1701f38631a. The jexfyz-latest tag and Release ID 403010611 target this exact commit. Later main updates are documentation-only; do not misidentify them as the APK source.
- **Quality gates:** App security/architecture audit passed; analyzer 25 info-level only (zero warnings/errors); Flutter suite 159/159 passed. Android :app:testDebugUnitTest task completed but reported NO-SOURCE, so native Android JUnit tests were not run.
- **APK:** obfuscated Flutter release output using --obfuscate --split-debug-info=build/symbols; APK V1/V2/V3 and pinned official certificate verified on build output and downloaded Release file. Certificate SHA-256 dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0 (RSA 4096, JE X FYZ DN).
- **Assets:** APK download URL https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk, 55,685,211 bytes, SHA-256 65d001c7a8df708dd35d5c80665c4cb7e377d47f11bdb675022c00817b251cd0; source ZIP https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip, 2,911,348 bytes, SHA-256 b7682a0d73a1d494d5d187481115480465bdb6aaf3fa9db79fcebca8279e4fc6. Release contains exactly these two intended assets and re-download/hash/source-marker/signature checks passed.
- Android versionName "Telegram @horizontalzzz" preserved. Release metadata version 1.0.0+3.
- **Known warnings:** :app:testDebugUnitTest NO-SOURCE; Kotlin 2.2.20 and Gradle deprecations; generated native ELF DWARF debug info not removed/obfuscated despite Dart obfuscation flags; Java jarsigner trust-chain/META-INF warnings although expected pinned cert and apksigner V1/V2/V3 verified. Review native ELF symbol stripping and toolchain modernization separately.
- **Field evidence UNVERIFIED:** installation identity, OEM screenshots/layout at 350-dp/420-dp, physical BLE lifecycle, Usage Statistics real sensor/soak/storage behavior, cooling thermal/electrical performance, Firmware V7.1 source-to-BIN identity, physical OTA/reboot and recovery. No Firmware/device operation was performed.

---
## Current App Statistics implementation — one-second diagram refresh; pre-build QC incomplete (2026-11-11)

- **Owner direction:** professional Usage Statistics diagrams for Battery, Hotside, Voltage, Adaptive Mode, Peltier and Fan Speed, with smooth transitions and one synchronized elapsed-time cursor.
- **Latest source/test checkpoint:** source commit `33fe9a545d7a8594e6e3a5119d3b1f564a93d868`; `lib/usage_statistics.dart` blob `0be670370685725283d51c84f1d33df83dd7e6e8`; `lib/main.dart` blob `56e71dcaa482cabddd141cd3ae5c6cf28437ada7`; `test/usage_statistics_test.dart` blob `af23d8b6b2e08d11ef28dc58496b574d1fa17e3b`.
- **Presentation:** two analog temperature charts plus four operating diagrams: Voltage 5/9/12V, Adaptive ON/OFF, Peltier ON/OFF and Fan Speed 0–100%. Temperature interpolation remains Flutter-vsync driven; discrete state lanes remain stepped.
- **Diagram cadence:** `usageStatisticsDiagramRefreshInterval` is `Duration(seconds: 1)`. Live update objects are batched and flushed to the page once per second. This changes only diagram-page aggregation/render refresh cadence; it does not downsample the telemetry stream or alter Battery/Hotside capture, recorder event processing, timestamps or SQLite persistence.
- **Regression source:** added a test asserting the one-second interval is wired to the live diagram flush while the independent data-capture path remains present. The new test and existing suite are NOT RUN.
- **Remaining source/performance gap:** each one-second flush still recomputes the complete selected-session in-memory analytics summary rather than using an incremental accumulator. The serialized SQLite write queue is still unbounded/unbatched. Long-session CPU/memory/backpressure and animation lifecycle/60–120-Hz tests remain outstanding.
- **Validation:** no Flutter/Dart/Gradle toolchain is available locally; formatter, targeted/full Flutter tests, analyzer, Android gate and real screenshots are BLOCKED / NOT RUN. Visual outcome is VISUAL NOT VERIFIED.
- **Release distinction:** Build #143 / run 42783474515 / source `121ef9e0f5ed6a0003837d32e4c8b1701f38631a` remains the latest verified APK and does not contain the current Statistics source. Current `jexfyz-latest` tag/Release ID 403010611 still targets that older SHA.
- **Build decision:** NOT YET RECOMMENDED to trigger release Build App until remaining source/performance and regression work is completed, then hosted QC passes. No Build/Release has been triggered for current Statistics source.

## Current App UI correction — compact modal overlays implemented, validation pending

- **Release/source distinction:** Build #143 remains the latest verified package. The modal sizing correction below is committed to `main` but is NOT in Build #143 and has not been packaged.
- **Peltier safety dialog:** title 20 dp, body 15 dp, actions 14 dp; reduced insets and internal padding; Cancel 72×48 dp and Fan 128×48 dp minimums. FAN-before-PELTIER safety flow and ACK semantics remain unchanged.
- **LED Color Picker:** width cap 312 dp; responsive max height `min(308 dp, 82% of available height)`; compact card/header typography; 36 colors retained in the existing six-column order. Internal scrollbar replaces the non-scrollable grid. Each grid cell remains 48×48 dp with 32×32 dp visible swatch art. Cancel/Select controls remain 72×48 dp; preview/commit and final white option remain.
- **Protected invariants:** only the two overlays and their tests changed. No 360-dp canvas, transform, Home, Settings, BLE/P1, RGB protocol, color storage, Peltier safety, Firmware, versionName, workflow or Release change.
- **Regression source:** `test/widget_test.dart` now checks modal sizes/safety ordering, picker responsive max height, all 36 color entries, final white, six-column scrolling and 48-dp cells/action targets. These tests are committed but not executed locally.
- **Evidence:** source commits `07602f598f2e95e71860a42b54521e08b8881680` and `ae44645cea27eced3f42749d892bd7794e5a2a7c`; test commit `3d6fc0c3bd5df922b3949cc4d6f18acbc81e6853`. Static delimiter scan passed for both Dart files. Flutter/Dart are unavailable; formatter, tests, analyzer and device screenshots are BLOCKED / NOT RUN. Visual status remains VISUAL NOT VERIFIED.
- **Next:** a separate owner-issued `Eksekusi Build App!` is required for hosted QC/package. Build #143 remains the verified APK baseline.

## HISTORICAL App build candidate — Build #142 active before test failure

- **Latest verified package:** Build #138 / run `42749408202`, source `b553f22092d9b33b2c81753254d2e3f03928fa18`; 21 main gates, Flutter 157/157 and analyzer 25 info-only passed; Android gate passed with JUnit tasks `NO-SOURCE`; APK V1/V2/V3/certificate, source ZIP, Release/tag and downloaded asset verification all passed.
- **Build #141:** run `42782355435`, job `129715178789`, source `2fb8dc6ec4a0f41e7cce73e6a49db0e716b56cda`. Analyzer passed (25 infos, no warning/error); Flutter tests failed **158/1** because test locale was Indonesian but expected English `Completed cooling run`. The actual localized UI label is `Sesi pendinginan selesai`; fixture was a completed session. No APK/Release changes.
- **Repair:** commit `bafff332f406fdb75e4534d3d9c426d13e83a31b` updates both test expectations to the Indonesian localized label; full file read-back confirmed. Awaiting CI.
- **Candidate source before docs checkpoint:** `bafff332f406fdb75e4534d3d9c426d13e83a31b`, complete recursive tree 131 entries. Home hybrid header palette resolver and cooler-output gated per-second Usage Statistics remain unchanged.
- **Workflow/trigger:** issue-only guarded workflow unchanged with all 21 gates. Issue #33 is OPEN exact; #141 terminal; no active/queued runs or open PR. No #142 trigger sent yet. Preserve `versionName "Telegram @horizontalzzz"`.
- **Status:** source and test repairs committed but full Flutter suite remains UNVERIFIED. Storage soak, physical BLE, OEM visuals, installation and thermal/electrical tests remain separate.

---
## HISTORICAL App build candidate — Build #141 active before test failure

- **Latest verified package:** Build #138 / run `42749408202`, source `b553f22092d9b33b2c81753254d2e3f03928fa18`; 21 main gates and Flutter 157/157 passed, analyzer 25 infos, Android Gradle gate with app JUnit tasks `NO-SOURCE`, signing/certificate, source ZIP, Release/tag and downloaded-asset identity/checksums verified.
- **Build #139:** terminal analyzer failure due outdated `lastTemperatureChangeAtMs` plus unused locals; repaired by `93b1ba7b859089eeccd30719ddfb8b8ab2dabaf6` and `2656b6eb9071cf878de2373cfab03d1872e089f8`.
- **Build #140:** run `42781821476`, job `129713425920`, source `cdd0b6dc6bc91d01029e89a0b88fc1185205e239`, terminal analyzer failure. Test declaration `lastValidSample` had two stale `lastValueChange` references. Repair commit `2a0b1b94f7ebce1607ba26067441accb31a105c7` updates both; file read-back verified. Steps 13–21 skipped; no asset/Release mutation.
- **Candidate before docs checkpoint:** `2a0b1b94f7ebce1607ba26067441accb31a105c7`, complete tree 131 entries. Current App changes include Default hybrid Home header correction plus authoritative FAN/PELTIER-active per-second Usage Statistics; the analyzer repairs are committed.
- **Build #141 CI:** run `42782355435`, job `129715178789`, source `2fb8dc6ec4a0f41e7cce73e6a49db0e716b56cda` exactly matched main at trigger. Steps 1–12 passed including analyzer; step 13 full Flutter tests is in progress; steps 14–21 pending. Test count/result not yet known; no APK/Release result.
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

## Default hybrid Home theme contrast — implemented; Build #143 CI passed; field QA pending (2026-11-10)

- **Observed:** owner-provided Default screenshot showed the intended dark Home header and light lower Display Menu panel, but low-contrast metric labels/values, NOTIFY body and animated metric glyph treatment in the header.
- **Root cause (STATIC SOURCE CHECK):** Default intentionally inherits Light Theme for the lower white panel and light dialogs, while the header is dark. The former inherited-brightness checks in _homeMetric() and _homeNotify() selected the wrong header foreground/painter palette.
- **Implemented source:** lib/app_settings.dart defines a single preset-based jexHomeHeaderUsesDarkPalette resolver (Default/Dark = dark; Light = light), and a separate jexDashboardContentUsesDarkPalette resolver (only explicit Dark = dark). lib/main.dart uses the header resolver consistently in metrics/indicator painter and NOTIFY; the lower-panel resolver and Default white surface remain separate. Source commits: 8b9e04e06cc28aa88cdd38e70dae48aa7c2b5ba7 and follow-up test 8115f6702c9be1381c10d1ed610b4a6e720c6753.
- **Regression contract:** test/widget_test.dart checks Default/Dark/Light palette mapping, NOTIFY resolver usage and metric resolver usage. This is committed source/test evidence only until hosted CI passes.
- **Status:** IMPLEMENTED ON MAIN / BUILD #143 HOSTED CI VALIDATED / FIELD ACCEPTANCE PENDING. The owner screenshot's installed APK identity remains unknown. No physical screenshot/OEM acceptance is inferred from source or widget-test intent.

## Open design and engineering gaps

- **Physical App acceptance remains pending:** after the owner installs Build #143, inspect Home, Settings/Connection and Usage Statistics at 350-dp/420-dp, English/Indonesian, Light/Dark. For Home, verify Battery/Hotside/Voltage/Adaptive/Peltier/Fan/Fan Speed normal, warning and unknown states plus NOTIFY success/warning/error with one-/two-line copy. CI tests are not screenshot/OEM acceptance.
- **App visual correction — modal overlays (2026-11-10):** Peltier dialog and LED Color Picker compact sizing are now SOURCE IMPLEMENTED with regression test source committed. Local formatter/tests/analyzer are BLOCKED / NOT RUN because Flutter/Dart are unavailable; actual screenshots remain VISUAL NOT VERIFIED. Build #143 is still the latest verified APK. A separate `Eksekusi Build App!` is required to run hosted QC and package the changes.
- **BLE runtime acceptance remains pending:** verify passive rediscovery, prerequisite cancellation, manual-sheet pre-emption and neutral dismissal, selected-device handoff, fresh primary/fallback advertisement handling, adapter loss and reconnect on the actual phone/cooler. Flutter tests do not represent a physical radio session.
- Exact Build #143 installed APK identity on the field unit, Firmware V7.1 source-to-BIN identity, physical OTA/reboot/BLE recovery and thermal/electrical behavior remain independently UNVERIFIED.
- BLE App-only identity authorization remains BLOCKED / NOT IMPLEMENTED until trusted enrollment/signing backend and Firmware verification exist.
- Rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm remains NOT IMPLEMENTED in Firmware V7.1; do not conflate it with Adaptive Fan tiers or ordinary Hotside-limit protection.

## Protected contracts

- Preserve Android Gradle versionName `Telegram @horizontalzzz`.
- Preserve BLE P1, authoritative telemetry, session synchronization, radio ownership, Touch synchronization, unknown/disconnected value semantics and persisted schema compatibility.
- Preserve safe outputs, calibrated one-sample-per-second NTC path, cooperative millis() timing, Peltier/selector/rail timing and OTA recovery.
- Online OTA intentionally uses `cloudClient.setInsecure()`; HTTPS server certificate identity is not authenticated. Preserve the allowlist, redirect blocking, response/size/image validation and safe-output/recovery behavior.
- Do not add Firebase firmware hash/signature requirements or a standalone Battery Protection Guard UI without explicit owner approval.
- The sold unit is not available for routine disassembly/repair; do not infer device-operation authorization.