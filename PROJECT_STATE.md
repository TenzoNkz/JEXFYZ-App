# JE X FYZ / JE Cooler — Current Project State

Last refreshed: 2026-11-09 (Asia/Jakarta). Current-state summary only; always fetch live main/source, tests, Actions and Release data before acting.

## Latest verified App release and Home Light Mode repair — Build #133 (2026-11-09)

- **Latest verified published App package:** Build #133 / [Actions run 42619673642](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42619673642), terminal success, all 21 main workflow steps passed. Exact tested/package source SHA: `5201a3e07f36305ffe3882a1b965b9e7414cd71a`.
- **Included Home change:** theme-aware painter depth/cavity colors across Battery, Hotside, Voltage, Adaptive, Peltier, Fan and Fan Speed; Light Mode metric accent contrast; Light Mode NOTIFY success/warning/error foreground contrast. Dark Mode painter colors and status-card tints/predicates remain preserved. Theme palette changes invalidate painter output.
- **Regression and QC evidence:** analyzer exit 0 with 25 info-level diagnostics; full Flutter test suite **145/145 passed**, including painter theme/repaint, Light/Dark fallback, metric contrast and composited NOTIFY foreground tests. The #132 indentation-sensitive source-contract matcher was repaired by whitespace normalization while retaining semantic color/helper/state/geometry assertions.
- **APK:** Release asset `727484780`, 54,849,627 bytes, SHA-256 `8fc837b9ec946cb3bccb6a8d400dc1483a19de9eff506c22ada2d4dcef0b1146`.
- **Matching source ZIP:** asset `727484787`, 2,890,067 bytes, SHA-256 `3a35158b16df567dbc2be1804c9bd0681d96012daffc61adddf61aa6b7be01fb`.
- **Signing/release identity:** V1/V2/V3 all verified; expected production certificate DN and SHA-256 match. Release ID `403010611`, live tag `jexfyz-latest`, Release metadata and tag ref all target the exact package SHA. Exactly one APK plus one matching source ZIP; step 21 downloaded both and verified digest, source marker, ZIP integrity, APK signatures and certificate.
- **Android Gradle caveat:** `:app:testDebugUnitTest` gate passed (`BUILD SUCCESSFUL in 3m 29s`), but native app JUnit compile/process/test tasks were `NO-SOURCE`; no native Android JUnit case ran.
- **Release warnings:** 25 Dart infos; Kotlin Gradle Plugin 2.2.20 upgrade advisory; deprecated Android Gradle options / future Gradle 10 warnings; nonfatal Flutter watcher and ELF DWARF notices; self-signed/untimestamped certificate and auxiliary META-INF JAR notices; post-job cache saves denied by token scope but cleanup succeeded. Required V1/V2/V3 and expected production certificate checks passed.
- **Source/HEAD parity:** current `main` is ahead of the package source only through documentation/checkpoint commits; the verified compare after Build #133 showed no App source, test, workflow or Android config changes after the packaged SHA.
- **Field boundary:** Build #133 installation is not independently confirmed. No screenshot/OEM visual acceptance, physical BLE session, cooling/thermal measurement, Firmware compile, BIN/Firebase mutation, OTA, flashing or device operation occurred in the build.
- **Next exact action:** owner installs Build #133 and performs the visual matrix (350-dp/420-dp, Light/Dark, EN/ID, icon normal/warning/unknown states and NOTIFY variants), then real-device BLE/connection checks. Do not infer these outcomes from hosted CI.

## Agent skills and capability system

- `MASTER_PROMPT.md` remains the single operating authority; `AGENTS.md` is the cross-agent entrypoint and `SKILLS_INDEX.md` maps the reusable skill library.
- Twelve task-specific skills are now present as canonical `.agents/skills/*/SKILL.md` definitions for Codex-compatible discovery and byte-identical `.github/skills/*/SKILL.md` mirrors for GitHub Copilot, including Copilot code-review and product-design quality guidance.
- Skills cover repository forensics, code review, product design/visual quality, Flutter App engineering, Flutter test/regression, BLE P1 audit, ESP32-C3 Firmware safety, OTA/release integrity, GitHub Actions triage, electronics/power/thermal analysis, technical research/Gemini and documentation/memory governance.
- UI work now routes through `product-design-and-visual-quality`, `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md`. These documentation standards do not change UI source or validate/release the pending compact Settings/Connection pass.
- Current ChatGPT mobile/web must fetch/read relevant repository skill files through GitHub tools when needed; do not claim private repo skills are automatically installed in ChatGPT. Gemini still has no GitHub access and is only a manual second-opinion handoff.
- Current container checked 2026-11-07: Python 3 and Git are available; Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF are absent. Re-check tool availability per task. This environment cannot claim local Flutter/Android/Firmware builds or physical-device validation.
## Production and release baseline

- **Protected known production reference:** App Build #124 + Firmware V7.1. Keep this stable reference distinct from newer published artifacts and the exact package installed on the field unit.
- **Latest independently verified published App package:** Build #133 / [Actions run 42619673642](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42619673642), exact tested/package source `5201a3e07f36305ffe3882a1b965b9e7414cd71a`. Release `jexfyz-latest` (ID `403010611`) and live tag both target this SHA.
- APK asset `727484780`: 54,849,627 bytes, SHA-256 `8fc837b9ec946cb3bccb6a8d400dc1483a19de9eff506c22ada2d4dcef0b1146`.
- Matching source ZIP asset `727484787`: 2,890,067 bytes, SHA-256 `3a35158b16df567dbc2be1804c9bd0681d96012daffc61adddf61aa6b7be01fb`.
- Build #133 passed all 21 workflow main steps, 145 Flutter tests, analyzer (25 info-level diagnostics), configured Android Gradle gate, obfuscated APK build, V1/V2/V3 and expected production-certificate checks, source ZIP marker/integrity, exact Release/tag parity and downloaded-asset checksum/identity/signature verification.
- Android `:app:testDebugUnitTest` succeeded, but app JUnit compile/process/test tasks were `NO-SOURCE`; no native Android JUnit case executed.
- Live Actions query after completion: Build #133 terminal `success`; no active/queued/waiting run was created by this task. APK delivery uses GitHub Release assets, not Actions artifacts.
- **Field evidence (UNVERIFIED):** Build #133 installation on the phone has not been independently confirmed. Physical screenshot/OEM QA and BLE session remain pending. Firmware V7.1 compile/Online OTA remains USER-REPORTED; exact field BIN identity and physical behavior remain unverified.

## Current App source and validation

- Build #133 packages the Home Light Mode correction: the painter receives brightness/surface/outline theme tokens and preserves the previous Dark Mode paint fallback; depth/cavity finish is theme-aware for all Home indicators. Palette changes trigger painter repaint.
- Home metric values use Light Mode contrast-adjusted accents targeting >=4.5:1; Dark Mode semantic accents remain unchanged. NOTIFY uses distinct Light Mode success/warning/error foregrounds while preserving original status tints, message predicates/priority, localization and layout.
- Regression tests cover theme propagation/repaint, theme-aware geometry, metric contrast, NOTIFY composited foreground contrast and Dark Mode foreground preservation. Build #133 full Flutter suite passed 145/145.
- Localization is included: Home Fan Speed uses Fan Speed / Kecepatan Kipas while the switch and compact Floating Monitor F metric retain Fan / Kipas; Hotside/Adaptive wording and Monitor Melayang notification copy remain localized.
- Home-equivalent uncapped 360-dp canvas and compact Settings/Connection typography, Bluetooth scan-state presentation, and passive/manual/one-shot scanner arbitration are included in earlier released package changes; Build #133 preserves these behaviors.
- Analyzer passed with 25 info-level diagnostics. Android Gradle test gate succeeded but native JUnit app tasks were `NO-SOURCE`.
- Exact package source is `5201a3e07f36305ffe3882a1b965b9e7414cd71a`; later `main` commits are documentation/checkpoint-only. Local `dart format` was not run because Dart is not installed in the current runtime, and the guarded workflow has no formatter step.
- No actual screenshot/OEM visual QA or real-device BLE lifecycle test has been performed. CI is widget/test and hosted build evidence only, not physical acceptance.

## Default hybrid Home theme contrast regression — diagnosed, not repaired (2026-11-09)

- **Observed:** owner-provided Default screenshot shows the intended dark Home header and light lower Display Menu panel, but Home metric labels/values and NOTIFY body use low-contrast Light-theme foregrounds on the dark header. The Light and explicit Dark screenshots show their expected coherent variants.
- **Root cause (STATIC SOURCE CHECK):** `JeCoolerApp` intentionally wraps the Default Dashboard in a Light `ThemeData` to preserve the lower white panel and light lock dialog. `_dashboardTopColor()` independently paints the Default header dark. But `_homeMetric()` and `_homeNotify()` infer header color mode from inherited `Theme.of(context).brightness`, which remains Light for Default. Header title/icons use the preset directly, causing inconsistent semantic palettes within the same dark header.
- **Recommended repair:** introduce one preset-based Home-header palette resolver (Default/Dark = dark; Light = light) for metric text, indicator painter and NOTIFY. Keep lower panel resolution independent (Default/Light = light; Dark = dark). Do not darken the complete Default Dashboard.
- **Build boundary:** Build #133 / source `5201a3e07f36305ffe3882a1b965b9e7414cd71a` contains the previous Light Mode contrast corrections, but the current source still has the Default mixed-theme bug. The provided screenshot APK identity is not independently established.
- **Status:** diagnosed only in `@Pikirkan Diskusi!`; no App source/test edit and no new build was made. Next source repair requires explicit `Eksekusi Full!`; packaging subsequently requires separate `Eksekusi Build App!`. `DESIGN_NOTES.md` stores the full acceptance matrix.

## Open design and engineering gaps

- **Physical App acceptance remains pending:** after the owner installs Build #133, inspect Home and Settings/Connection at 350-dp/420-dp, English/Indonesian, Light/Dark. For Home, verify Battery/Hotside/Voltage/Adaptive/Peltier/Fan/Fan Speed normal, warning and unknown states plus NOTIFY success/warning/error with one-/two-line copy. CI tests are not screenshot/OEM acceptance.
- **BLE runtime acceptance remains pending:** verify passive rediscovery, prerequisite cancellation, manual-sheet pre-emption and neutral dismissal, selected-device handoff, fresh primary/fallback advertisement handling, adapter loss and reconnect on the actual phone/cooler. Flutter tests do not represent a physical radio session.
- Exact Build #133 installed APK identity on the field unit, Firmware V7.1 source-to-BIN identity, physical OTA/reboot/BLE recovery and thermal/electrical behavior remain independently UNVERIFIED.
- BLE App-only identity authorization remains BLOCKED / NOT IMPLEMENTED until trusted enrollment/signing backend and Firmware verification exist.
- Rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm remains NOT IMPLEMENTED in Firmware V7.1; do not conflate it with Adaptive Fan tiers or ordinary Hotside-limit protection.

## Protected contracts

- Preserve Android Gradle versionName `Telegram @horizontalzzz`.
- Preserve BLE P1, authoritative telemetry, session synchronization, radio ownership, Touch synchronization, unknown/disconnected value semantics and persisted schema compatibility.
- Preserve safe outputs, calibrated one-sample-per-second NTC path, cooperative millis() timing, Peltier/selector/rail timing and OTA recovery.
- Online OTA intentionally uses `cloudClient.setInsecure()`; HTTPS server certificate identity is not authenticated. Preserve the allowlist, redirect blocking, response/size/image validation and safe-output/recovery behavior.
- Do not add Firebase firmware hash/signature requirements or a standalone Battery Protection Guard UI without explicit owner approval.
- The sold unit is not available for routine disassembly/repair; do not infer device-operation authorization.