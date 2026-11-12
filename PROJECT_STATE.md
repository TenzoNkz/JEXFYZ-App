## CURRENT CHECKPOINT — BUILD #153 ACTIVE / GUARDED APP QC — 2026-11-12

- **Run:** Actions `43145542329`, workflow 374946166, attempt 1, issue event #33, job `130942369953`; immutable source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. Current run active; initial state steps 1–2 success, step 3 Java 17 setup in progress.
- Build #153 includes test-only repairs after Build #152 failure: Home NOTIFY source anchors/adaptive font assertion, explicit nonzero Statistics test viewport, and Diagnostics localization/casing. No production App source, Firmware, workflow or Gradle versionName changed in repair.
- Build #152 / run `43144337555` remains a preserved failure at Flutter suite (171 pass / 5 fail), no artifact. Full failure evidence and test repair summary are in APP_BUILD_REPORT.md.
- **Latest published App remains Build #151** (Release 403010611, tag `jexfyz-latest` source `e383924067b7ab2da27f2e41f21232cfb7144ec0`) until #153 clears all gates.
- Android Gradle `versionName "Telegram @horizontalzzz"` exact.
- No Firmware compile/BIN/Firebase/OTA/flash/device/BLE/NVS/rail/LED/thermal/electrical/OEM validation. App CI does not prove physical field acceptance.
- **Next:** monitor Build #153 to full gate and Release verification; no additional trigger.

---
## Firmware V7.2 source implementation — App CI verified; Firmware validation pending (2026-11-12)

- **CURRENT source:** `firmware/JEXFYZ-V7.2.ino`, `FW_VERSION="V7.2"`, blob `140e758e7101cadc3ccc58cc5c52e49534b0032c`; it is the only active versioned `.ino` in the complete recursive tree (131 entries, `truncated=false`). The source-review baseline before this Diskusi's documentation-only updates was main SHA `ddf9aa441a22dc715bb026f4a1c3bd74e9b425ae`.
- **STATIC SOURCE CHECK:** `vLock5V` is firmware-owned in Preferences namespace `jexfyz`; an absent key defaults OFF, while failed Preferences initialization fails closed. Lock ON applies the runtime interlock before persistence/handoff, blocks requests above 5V at the central request gate and final selector boundary, redirects an in-flight transition without restarting its 200ms deadtime, and maintains a loop-level 5V endpoint. Unlock persists OFF before removing the lock, leaves the rail at 5V and Adaptive OFF; Adaptive can be re-enabled only by a separate explicit action after unlock.
- **P1/App integration:** full sync publishes `VOLTAGE_LOCK` and `VOLTAGE_LOCK_SAVED`; the App waits for ACK plus matching lock telemetry, reports NVS save failure/retry separately, and reflects the actual rail only from VOLTAGE telemetry. Touch single tap follows actual rail 5V→9V→12V→5V. Denied Touch/manual requests use a nonblocking double-red pulse that yields to NTC/Hotside/OTA safety indications.
- **VERIFIED CI — App scope:** Build #151 / run `43080954412`, job `130733048413`, exact package source SHA `e383924067b7ab2da27f2e41f21232cfb7144ec0`. Relevant Firmware/App/test blobs are identical to current `main`. Analyzer: 23 info-level findings, zero warnings/errors. Flutter: **171/171 passed**, including the V7.2 one-way Touch test and four Lock Voltage/App source-contract tests. Android `:app:testDebugUnitTest` was `NO-SOURCE`; no native Android JUnit tests ran. This is App and static-source contract evidence, not Firmware compilation/runtime evidence.
- **NOT RUN / UNVERIFIED:** Arduino-ESP32 Core 3.3.7 compile, BIN provenance, NVS persistence/power-cycle, rail/selector/soft-start behavior, physical Touch/LED, BLE security/identity, thermal/electrical cooling, OTA/flash and owner-side OEM visual acceptance.
- **Security limitation:** bonded Just Works + `SYNC_READY` still does not authenticate the official App; another bonded/manual client may send `VOLTAGE_LOCK:OFF`. `BLE_APP_AUTH.md` remains BLOCKED / NOT IMPLEMENTED.
- **Independent Gemini review (cross-checked against live source):** P0 Adaptive handoff deadlock is NOT SUBSTANTIATED because `forceAdaptiveFiveVolt()` explicitly allows/redirects a V5 target while locked; P2 LED stuttering is NOT SUBSTANTIATED because the trigger returns while a flash is already active. The BLE identity limitation is CONFIRMED and pre-existing. H1/H2 transition/Adaptive runtime cases remain important unverified tests; H4's 10s debounce premise is wrong because Lock uses immediate `putBool()` + read-back; H5 must follow actual safety LED behavior rather than assume a generic red thermal blink. See `FIRMWARE_NOTES.md`, `VOLTAGE_TRANSITION_MEMORY.md` and `BLE_APP_AUTH.md` for full evidence.
- **Source cleanup item:** the sketch's opening comment says `V7.1 Firmware` although `FW_VERSION` is `V7.2`; no runtime effect, but fix in an authorized source patch.
- **Next:** resolve in Diskusi whether Lock Voltage is intended only as an operational/accidental-change interlock or must enforce cryptographic official-App-only unlocking. Do not start BLE authorization implementation until its backend/enrollment scope and required permissions are explicitly approved. Firmware compile and any BIN/OTA/flash/device operation remain separately gated.

## HISTORICAL App release — Build #149 verified (2026-11-11; superseded by Build #151)

- **Latest verified package:** Build #149 / Actions run 42967289995, job 130347345586, conclusion success; all 21 required workflow steps and cleanup 39–43 passed.
- **Exact source/tag:** 0507e3e11b67b8f8d042e49b74cc14a53bfc4f21. jexfyz-latest tag and Release ID 403010611 target this exact commit. Current main also contains the newer, unreleased Peltier/LED source refinement documented below; it is not part of Build #149.
- **Quality gates:** App security/architecture audit passed; analyzer 23 info-level, zero warnings/errors; Flutter suite 166/166 passed, including pinned selected-time Statistics cursor panel after tapping scrolled Peltier lane. Android :app:testDebugUnitTest gate completed successfully but app JUnit compile/test tasks were NO-SOURCE (no native JUnit test cases ran).
- **APK:** Flutter release build used --obfuscate --split-debug-info=build/symbols. APK V1/V2/V3 and pinned production certificate verified on build output and re-downloaded Release APK. Cert SHA-256 dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0, RSA 4096, JE X FYZ DN.
- **Assets:** APK 55,881,819 bytes, SHA-256 84a9165f67420e99d6ae7585340e0ef7e29e80de1d413fbc9c7352866d0670d5; source ZIP 2,918,953 bytes, SHA-256 521a06c1f804a3f04a9b0f7165796e806c60bbd9e027c9986ff91e5f2e326782. Release has exactly one APK and one matching source ZIP; downloaded asset checksums, source marker, ZIP integrity and APK signature/certificate were verified.
- Android versionName "Telegram @horizontalzzz" remains exact; Release app version 1.0.0+3.
- **Warnings:** native Android app JUnit tasks NO-SOURCE; Kotlin 2.2.20 compatibility/Built-in Kotlin warning; Gradle 10 deprecations; native ELF DWARF symbols remain; jarsigner PKIX trust-chain/META-INF warnings although pinned cert and V1/V2/V3 checks passed; optional cache writes denied; 29 package updates constrained.
- **Performance gaps remain OPEN:** full selected-session analytics recomputed each one-second batch; unbounded/unbatched SQLite write queue; long-session CPU/memory/backpressure and animation lifecycle/60–120-Hz stress tests. Do not infer these are validated by normal CI.
- **Field evidence UNVERIFIED:** owner install identity, OEM visuals at 350-dp/420-dp, physical BLE, real Usage Statistics telemetry/soak, cooling thermal/electrical performance, Firmware/BIN/OTA. No Firmware/device operations were performed.

## HISTORICAL App source candidate — Peltier dialog and 60-color LED palette (later included in Build #151)

- **Historical source commit:** `7f31c2d3b2571dbb9f1c4fa87dea0db0d3851bda`, with test cleanup `b24848222c0a90f213dd6017571e13857138d4f9`. These UI/test refinements were later included in Build #151 source `e383924067b7ab2da27f2e41f21232cfb7144ec0`; they are no longer an unreleased candidate.
- **Peltier dialog:** effective width target approximately 312 dp in the protected 360-dp canvas; 18/14/14 dp title/body/actions; reduced insets and vertical padding. Cancel/Fan targets remain at least 48 dp high. Bilingual safety copy is shorter. The FAN-before-PELTIER command/ACK order and safety predicates are preserved.
- **LED palette:** 60 unique HEX presets, 60 unique localization keys, 60 unique English names and 60 unique Indonesian names. Six-column scroll, 48-dp cells, 32-dp swatches, staged preview, Cancel, explicit Select/commit and legacy RGB aliases are retained. Known CSS-aligned names now match their exact HEX values.
- **Regression source:** widget tests cover dialog sizing/copy/tap heights/fan-first order, 60-color uniqueness, complete bilingual names, representative HEX-name mapping, final white, six-column scrolling and swatch/hit-target sizes. Review found older assertions still pinned to 36 colors and an old first-color/name; test commit `b24848222c0a90f213dd6017571e13857138d4f9` updates those expectations to 60, `#800000` and `Kayu Manis`.
- **Static evidence:** 60 unique HEX entries, 60 unique localization keys, 60 unique English and Indonesian names; no missing localization or duplicate values/names; final swatch remains white; Peltier actions remain 48 dp with fan-first command order.
- **Historical validation boundary at that snapshot:** local Flutter/Dart/Gradle/ADB tools were not installed, so local commands were BLOCKED / NOT RUN at that time. Build #151 later packaged these App refinements and passed hosted analyzer/tests. Screenshot/OEM/device acceptance and open Statistics/SQLite/animation performance risks remain separate and unverified.
- **Historical next action:** the later guarded App Build completed as Build #151; see the active release checkpoint at the top of this file.

---
## HISTORICAL App QC — Build #149 APK build active — 2026-11-11

## HISTORICAL App QC — Build #149 active (2026-11-11)

- **Run:** 42967289995, job 130347345586, workflow 374946166, issue event, attempt 1; immutable source SHA 0507e3e11b67b8f8d042e49b74cc14a53bfc4f21.
- **Trigger:** issue #33 exact guard closed/reopened once; exactly one run created. No duplicate.
- **Initial status:** steps 1–3 passed; step 4 Flutter setup in progress; steps 5–21 pending. No artifact/Release yet.
- **Candidate fix:** selected Statistics cursor readout is now pinned in Scaffold.bottomNavigationBar rather than the lazily built ListView. This should keep the selected-time text mounted when Peltier lane is far down the list; existing tap test remains.
- **Prior failures:** #144/#145 analyzer; #146 161/5 tests; #147 164/2; #148 165/1. No candidate release.
- **Risks still open:** selected-session summary recomputation each second, unbounded SQLite write queue, long-session CPU/memory/backpressure, animation lifecycle/60–120-Hz stress tests.
- Preserve Android versionName Telegram @horizontalzzz; App-only scope.

---
## HISTORICAL App candidate — cursor readout pinned; pre-build QC pending (2026-11-11)


- **Latest executable App source:** f56b2a9a4893a1a0810cfdfb38524fd79df87d05. Moves selected Statistics cursor readout to conditional Scaffold.bottomNavigationBar so it remains mounted/visible when the user scrolls to lower chart lanes. Initial hint remains in ListView when no selected timestamp. Listener/tap-up/drag cursor handlers and existing Peltier-lane widget regression are retained.
- **Build failures:** #144 analyzer 12 errors/3 warnings; #145 analyzer one nullable-double error; #146 analyzer passed, Flutter 161/5; #147 analyzer passed, Flutter 164/2; #148 analyzer passed, Flutter 165/1 (only selected-time readout not found). No later gate/package/release from these attempts.
- **Root cause:** selected readout was an early lazy ListView child and could be evicted while the Peltier lane was visible. Pinned readout panel is a targeted App UI fix, not a weakened test.
- **Preflight baseline:** workflow blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12, issue #33 exact OPEN, no active runs/open PR. Latest published package remains Build #143 / source SHA 121ef9e0f5ed6a0003837d32e4c8b1701f38631a.
- **Still open:** full analytics recomputation per 1Hz update, unbounded SQLite queue/backpressure, long-session CPU/memory and animation lifecycle/60–120-Hz stress tests. No claim of stress validation.
- Preserve Android versionName "Telegram @horizontalzzz"; App-only boundary. New cursor patch is NOT YET HOSTED-VALIDATED.

---
## HISTORICAL App candidate — Build #148 cursor test failure and pointer attempts (2026-11-11)

## HISTORICAL App QC — Build #148 active / Flutter test failure — 2026-11-11

## HISTORICAL App candidate — Build #147 two test failures repaired — 2026-11-11

## HISTORICAL App QC — Build #147 active / Flutter test gate — 2026-11-11

## HISTORICAL App candidate — Build #147 pre-trigger ready (2026-11-11)

- Main before this checkpoint: 245f9870f7bd75b1c7f18827a4f4fb6ae5588b4b; latest executable App/test commit b1609b01d4dee470b96e2030cb5583df1efc1351. Includes rounded LED height and compact-picker/Peltier/Statistics cursor/animation contract updates.
- Build #146: analyzer passed (23 infos, zero warnings/errors); Flutter test 161 passed / 5 failed; steps 14–21 skipped; no artifact or Release mutation.
- Fixes in current candidate: integer logical-pixel max height, Ticker/vsync animation assertions, ensure full cursor lane visibility before tap, current 19/14sp LED and 20/15/14sp Peltier compact UI contracts.
- Preflight: no active/queued Actions runs, no open PR, issue #33 exact OPEN, workflow blob unchanged issue-only guard, full tree 131 entries, Android versionName preserved. Latest release still Build #143.
- Exactly one guarded retry is authorized by the original explicit Build App command. Next run must prove all original gates.
- Known performance gaps persist: full-summary recompute each second; unbounded/unbatched SQLite queue; long-session CPU/memory/backpressure; animation lifecycle/60–120-Hz stress coverage.
- No Firmware/BIN/Firebase/OTA/flash/device operation.

---
## HISTORICAL App candidate — Build #146 Flutter test failures repaired; hosted retry pending (2026-11-11)

- Build #146: run 42944693211, job 130274555621, source d5bc688cc14243cd944f2d8d653bbcb59d2805fe. Steps 1–12 passed; analyzer 23 info, 0 warnings/errors. Flutter tests 161 passed / 5 failed; Android/build/release steps skipped. No #146 package.
- Test findings/fixes: (1) fractional max-height double precision fixed by round-to-logical-pixel; (2) animation source test now asserts vsync/Ticker rather than a removed 16ms timer; (3) old LED overlay contracts now match 19/14sp + 48dp compact swatches; (4) Peltier dialog contract now matches 20/15/14sp and 72x48/128x48 targets; (5) cursor tap test fully ensures Peltier lane visible before center tap.
- Commits: App height rounding 4028949dca6c2f5ced55f54861b6c5197426c1dd; Statistics test fb845d88567503de4a78668c2b6b08eeb61de5e5; widget contracts b1609b01d4dee470b96e2030cb5583df1efc1351. Source/read-back verification only; new hosted validation pending.
- Retry: prior owner Build App command authorizes concrete App repairs/retry. Recheck #146 terminal, no active run/PR, exact issue #33/workflow guard and versionName, then one guarded event.
- Known performance/test gaps: full selected-session summary recomputation per one-second batch; unbounded/unbatched SQLite queue; long-session CPU/memory/backpressure; animation lifecycle/60–120-Hz tests remain open.
- Preserve Android versionName "Telegram @horizontalzzz"; no Firmware/BIN/Firebase/OTA/flash/device operation.

---
## HISTORICAL App QC — Build #146 active before Flutter test failure (2026-11-11)

- **Run:** 42944693211, job 130274555621, workflow 374946166, issue event, attempt 1; immutable source `d5bc688cc14243cd944f2d8d653bbcb59d2805fe`.
- **Initial status:** steps 1–2 success; step 3 Java 17 setup in progress; steps 4–21 pending. No artifact yet.
- **Fixes included:** #144 method/helper scope and timeline key repairs (`80b8874c9d851d1422009cfdbb85f33eec74f8b2`); redundant imports removed (`1e04495416426ea5f4b3c9280704b1deee9a821c`); nullable painter value local promotion and removal of redundant `path!` (`250d2a031667c0b7ceab98e3077a35a97408d8ce`).
- **Prior attempts:** #144 analyzer 12 errors/3 warnings/25 infos; #145 1 error/1 warning/23 infos. No downstream tests/build/Release on either attempt.
- **Unverified performance gaps:** per-one-second full-session summary recomputation, unbounded/unbatched SQLite queue, long-session CPU/memory/backpressure, animation lifecycle and 60–120-Hz stress.
- Preserve versionName `Telegram @horizontalzzz`; no Firmware/BIN/Firebase/OTA/flash/device operation.

---
## HISTORICAL App candidate — Build #145 analyzer failure repaired — 2026-11-11

## HISTORICAL App QC — Build #145 terminal analyzer failure — 2026-11-11

## HISTORICAL App candidate — Build #144 analyzer failure / repair — 2026-11-11

## HISTORICAL App QC — Build #144 active / terminal analyzer failure — 2026-11-11

## HISTORICAL App candidate — guarded Build App requested (2026-11-11)

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

## Firmware — V7.2 planned scope: Touch cycle + persistent Lock Voltage (2026-11-11)

- **Current active Firmware remains V7.1:** firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", source blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9. Exactly one active .ino is present. No V7.2 source change, Arduino compile, BIN, Firebase, OTA or flash has occurred.
- **Touch one-way cycle request:** hardware TTP223 single tap should step from actual current rail: 5V→9V→12V→5V, repeating; current V7.1 executeTouchSingle() still uses touchVoltageAscending and ping-pongs.
- **New owner-requested Lock Voltage 5V:** App Settings toggle persists in ESP32 Preferences/NVS namespace jexfyz (proposed key vLock5V). It must survive power unplug/reboot until explicit App OFF. Use immediate write-through, not the normal ten-second settings debounce.
- Lock ON must disable Adaptive, force/handoff to 5 V through the existing safe selector pipeline, and centrally reject every 9/12 V request from App, Touch or automatic sources. App Voltage and Adaptive controls must visibly lock; Firmware full sync/state telemetry is authoritative. If NVS save fails during ON, keep the runtime lock active and 5 V enforcement in place but surface unsaved status/retry; if OFF persistence fails, keep lock active. Unlock does not restore a prior voltage or re-enable Adaptive.
- Any valid physical single tap refused by Firmware (lock, Adaptive gate, transition/guard) returns a rejected ACK and two red LED flashes; an App 9/12 V request blocked by Lock ON gets the same feedback. The new blink is non-blocking and must not override OTA/Hotside/NTC safety indicators.
- Proposed P1 command/state: VOLTAGE_LOCK:ON|OFF, synchronized on full sync. Preserve UUIDs/framing. Official-App-only unlock is not guaranteed because BLE_APP_AUTH remains BLOCKED / NOT IMPLEMENTED; this limitation must remain explicit.
- **V7.2 scope proposal:** combine the one-way Touch cycle, persistent 5V Lock, Firmware QC regression coverage, App Settings toggle, Voltage/Adaptive lock presentation, and P1 full-sync/state handling. Keep double tap RGB, long press, Peltier/Fan, NTC/Hotside and OTA semantics unchanged.
- **Evidence boundary:** STATIC SOURCE CHECK confirms only V7.1/ping-pong behavior and existing Preferences/NVS infrastructure. The new behavior is REQUEST RECORDED / NOT IMPLEMENTED. No Firmware/App source or test was changed, no tests/format/analyzer/compile run, no BIN/Firebase/OTA/flash/device action.
- **Next authorization:** owner may issue a new Eksekusi Full! for this combined V7.2 Firmware + App source/test scope. Firmware Arduino compilation is separate; App packaging requires separate Eksekusi Build App!.


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

## Current Discussion — Lock Voltage UI presentation refinement (2026-11-12)

- Owner requests the Lock Voltage UI to use the same centered lock icon + blurred submenu treatment already used for Bluetooth-disconnected and Adaptive-active states, and requests Kunci Tegangan be moved to the very top of Settings with a cleaner dedicated card.
- Live source review: `displayMenuLockReason()` currently has only `none`, `bluetoothDisconnected`, and `adaptiveActive`; it prioritizes disconnected and maps Adaptive-active/transitioning to tabs 0/1/4. `_lockedDisplayMenu()` already provides blur, dimming, a centered lock panel, and pointer blocking. Lock Voltage is not currently part of this overlay decision; Voltage/Adaptive pages instead render local inline lock notices/disabled controls.
- Design contract recorded in `APP_NOTES.md`: a synchronized Lock Voltage ON should invoke the overlay on Voltage (tab 0) and Adaptive (tab 2) only. Keep Control, LED, and Temperature available for Lock Voltage alone; existing Adaptive-active/transitioning and Bluetooth-disconnected gates retain their current scope/priority. Voltage copy must distinguish pending safe handoff from confirmed 5V using actual Firmware voltage telemetry.
- Settings contract: show Kunci Tegangan as the first dedicated card directly below the Settings AppBar and before UMUM; retain the Firmware-owned notifier, unknown/disconnected state, busy state, persistence warning and retry.
- This is a Discussion/design checkpoint only. No executable source/tests or app package changed; no formatter, tests, analyzer, build, release, Firmware compile, OTA or device operation was run. Next recommended mode: `Eksekusi Full!` for the App-only UI/test implementation. This is a recommendation, not authorization.


## Current Discussion — Peltier safety popup visual redesign (2026-11-12)

- Owner says the existing Peltier safety popup still feels rigid. Source review confirms that the 2026-11-11 compacting pass retained a stock `AlertDialog`; it changed sizing/typography rather than the visual composition.
- Proposed App-only redesign is recorded in `DESIGN_NOTES.md` and `APP_NOTES.md`: custom JE X FYZ safety card inside the existing general-dialog/fixed-canvas route; restrained amber prerequisite icon; concise title/explanation; two-step Fan ON → Peltier ON visual; full-width paired-action button and quieter Cancel below; responsive 300–312-dp width, natural/scrollable height, theme-aware surface and subtle fade/scale transition.
- Copy/action correction required: displayed CTA currently says only “Turn on Fan” / “Nyalakan Kipas”, but approval then sends FAN:ON, awaits ACK, and sends PELTIER:ON. Proposed CTA accurately names both outputs. Preserve Fan-first ACK order; if Fan is not confirmed, Peltier must not be commanded.
- Keep this amber informational prerequisite distinct from red thermal/NTC fault states. Cancel remains command-free; no Firmware safety policy, BLE/P1, command semantics, Home geometry, fixed-canvas transform or physical output behavior changes are included.
- Discussion-only checkpoint: no App source/tests changed or run, no build/release and no Firmware/device operation. Next recommended direction remains a scoped `Eksekusi Full!` for App UI + regression tests only; this is not authorization.


## Current Discussion — About Settings page and contributor credits (2026-11-12)

- Owner explicitly requests an About entry below Firmware in Settings and supplies three contributor credits. This supersedes the earlier historical removal of About from Settings.
- Recommended English copy: **JE Cooler** / **Special Thanks** / **App Development & Build — Horizon (@Horizontalzzz)** / **Design Inspiration — FYZ (@FYZ737)** / **3D Design & Printing — Logos (@Logos3dMichael)**.
- Recommended Indonesian copy: **JE Cooler** / **Ucapan Terima Kasih** / **Pengembangan Aplikasi & Build — Horizon (@Horizontalzzz)** / **Inspirasi Desain — FYZ (@FYZ737)** / **Desain & Pencetakan 3D — Logos (@Logos3dMichael)**.
- “Special Thanks” is the natural standalone heading; “Design Inspiration” corrects the initial phrase. “3D Design & Printing” assumes Logos contributed both design and printing; narrow it to printing-only wording if that assumption is incorrect.
- Add About / Tentang immediately after Firmware in Settings; open a compact fixed-scale About page with a clear role/name/handle hierarchy. Preserve handles; do not invent profile URLs.
- This is Discussion/design only. The existing test currently explicitly rejects About and must be revised during implementation. No executable source/tests, build, release, Firmware or device behavior changed or ran.
- Next recommended mode: scoped `Eksekusi Full!` for the accumulated App UI tasks (Lock Voltage overlay/Settings placement, Peltier popup redesign, and About page) with focused regression tests. This is a recommendation, not authorization.


## Current Discussion — Whole-App visual refinement and Usage Statistics redesign (2026-11-12)

- Owner explicitly approves adopting the complete premium/professional refinement direction and requests a cleaner Usage Statistics diagram with substantially less always-visible prose. The project already has `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md`; these are the governing design/acceptance contracts, not a request to invent a new brand.
- Global scope: unify semantic typography, spacing/radius/surface hierarchy, icon family/weights and interaction/motion; review Home NOTIFY readability; reduce redundant cards, labels and effects; maintain existing Home composition/360-dp scale, theme, EN/ID, telemetry truth, safety, BLE/P1 and Firmware behavior.
- Statistics source review: `UsageStatisticsPage` displays two temperature charts, four operating timeline lanes, a shared cursor with six metric values, session selector/header, axis text, Min/Avg/Max and observed labels, a long always-visible sampling/storage explanation, an always-visible last-sample sentence, an initial cursor instruction, and a trailing Wrap of seven operational summary texts. The current widget test exercises the sample page at 350-dp Light and 420-dp Dark (Indonesian) but does not establish the full cross-product visual matrix.
- Statistics design direction: preserve all six metrics, their chart types, common cursor, useful aggregates, session history and truthful gap handling. Consolidate session metadata; shorten visible prose; move explanatory provenance behind an info affordance; keep a compact Min/Avg/Max row and Hotside limit; retain all secondary durations/fan aggregates behind collapsed details; simplify cursor hint/readout; do not add chart cards or decorative effects. No data model, cadence, persistence, SQL or analytics changes under this visual scope.
- Device Diagnostics is accepted as a future feature direction, conditional on auditing which values are actually exposed. Show only confirmed App/Firmware/session/sync/sample/output/safety facts. Unknown remains unknown; no raw tokens, credentials, secrets, fabricated signal/health metrics or automatic uploads.
- Execution order: current approved Lock Voltage/Peltier/About UI scope; Statistics visual simplification; cross-screen design-system/NOTIFY/motion polish; Device Diagnostics field audit + implementation; full visual QC with actual screenshot evidence at 350/420 dp, EN/ID, Light/Dark and edge states.
- Current mode remains `Diskusi!`: no executable source or tests changed/run; no App Build, Release, Firmware compile/BIN, Firebase, OTA, flash or device operation. Recommended next mode: `Eksekusi Full!` beginning with the staged App UI/design work; this is recommendation only.
