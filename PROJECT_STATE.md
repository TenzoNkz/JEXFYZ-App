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
- **Layout:** Phone Battery Temperature trend first; Hotside Temperature trend second; Operating Profile timeline third with separate Voltage (5V/9V/12V), Adaptive ON/OFF and Fan Speed (%) lanes. Implemented periods: 1h / 24h / 7d / 30d, default 24h.
- **Capture:** phone Battery from existing Android 1Hz reader; Hotside from Firmware ~1Hz `HOT`; Voltage/Adaptive/Fan Speed only on authoritative state changes. Save only changed temperature values with timestamps; show explicit gaps when session/data is missing. Use duration-weighted averages for change-only samples.
- **Storage:** App-local SQLite (`sqflite` 2.4.2), not `flutter_secure_storage`, Firmware NVS or Firebase. Current source retains changed-value temperature events and state changes for 30 days; no 1-minute rollup table exists. Storage-size stress validation remains open.
- **Status:** VERIFIED CI in Build #138 / source `b553f22092d9b33b2c81753254d2e3f03928fa18`. The full Flutter suite passed 157/157 and includes Usage Statistics chart/timeline layout, timestamp and localization contracts. The page, P1 sync-gated capture, SQLite persistence, Settings navigation, graph/timeline periods, clear-history and 30-day retention were included in the released source. Storage-size stress validation remains open; owner installation, screenshot/OEM behavior, real BLE session capture and device behavior remain UNVERIFIED.
- **Timer decision:** separate Firmware session/operating timer is DEFERRED by owner in favor of this App Usage Statistics feature; see `FIRMWARE_NOTES.md`.

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

## Default hybrid Home theme contrast regression — diagnosed, not repaired (2026-11-09)

- **Observed:** owner-provided Default screenshot shows the intended dark Home header and light lower Display Menu panel, but Home metric labels/values and NOTIFY body use low-contrast Light-theme foregrounds on the dark header. The Light and explicit Dark screenshots show their expected coherent variants.
- **Root cause (STATIC SOURCE CHECK):** `JeCoolerApp` intentionally wraps the Default Dashboard in a Light `ThemeData` to preserve the lower white panel and light lock dialog. `_dashboardTopColor()` independently paints the Default header dark. But `_homeMetric()` and `_homeNotify()` infer header color mode from inherited `Theme.of(context).brightness`, which remains Light for Default. Header title/icons use the preset directly, causing inconsistent semantic palettes within the same dark header.
- **Recommended repair:** introduce one preset-based Home-header palette resolver (Default/Dark = dark; Light = light) for metric text, indicator painter and NOTIFY. Keep lower panel resolution independent (Default/Light = light; Dark = dark). Do not darken the complete Default Dashboard.
- **Build boundary:** Build #133 / source `5201a3e07f36305ffe3882a1b965b9e7414cd71a` contains the previous Light Mode contrast corrections, but the current source still has the Default mixed-theme bug. The provided screenshot APK identity is not independently established.
- **Status:** diagnosed only in `@Pikirkan Diskusi!`; no App source/test edit and no new build was made. Next source repair requires explicit `Eksekusi Full!`; packaging subsequently requires separate `Eksekusi Build App!`. `DESIGN_NOTES.md` stores the full acceptance matrix.

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