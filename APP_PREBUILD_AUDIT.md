# JE Cooler App — Full Pre-Build Audit

**Audit date:** 2026-11-12 (Asia/Jakarta)  
**Mode:** `@Thinking Diskusi!` — static source/repository analysis only.  
**Disposition:** **READY FOR GUARDED APP BUILD QC — NOT RELEASE-ACCEPTED.** Source-level P1 remediations and regression tests are committed. Flutter/Dart are unavailable in this runtime, so current tests, formatter and analyzer have not run; the guarded workflow must validate the exact source SHA next. Visual/device acceptance remains separate and unverified.

## 1. Baseline and evidence

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Audited baseline:** executable source snapshot `4d02fbf705a85820a4ea1e530d167ebb53ab3a68`. **Current source HEAD:** `aa58a2f14354692a1dbcebfcb70436deb3aabf06`; recursive tree has 132 entries and is not truncated. Source remediation commits are `5763b08f8b37fccafd2ac2403a51b26ad0be4b41`, `b1275d278ca0b0d2765174364250873044a943d1` and `aa58a2f14354692a1dbcebfcb70436deb3aabf06`.
- **Audit progression:** the initial static audit was performed on executable snapshot `4d02fbf705a85820a4ea1e530d167ebb53ab3a68`. Three subsequent source commits addressed P1 findings; current source is `aa58a2f14354692a1dbcebfcb70436deb3aabf06`. Current recursive tree has 132 entries, not truncated.
- **Current executable surface:** 7 Dart library files; 9 test files. Main implementation is concentrated in `lib/main.dart` (10,563 lines / ~387 KB), `lib/usage_statistics.dart` (3,298 lines / ~106 KB), `lib/floating_monitor.dart` (1,808 lines / ~65 KB) and `lib/app_settings.dart`.
- **Tests in current main:** 184 declarations — 171 unit/source-contract and 13 widget tests. This is an inventory only, not a passing result. All current-main tests remain **NOT RUN**.
- **Latest verified package:** Build #153 / Actions run `43145542329`, tested source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Release ID `403010611`, tag `jexfyz-latest`. Build #153 reported 176/176 Flutter tests, analyzer 23 info / 0 warnings / 0 errors, and Android Gradle success. Its native Android JUnit tasks were NO-SOURCE; no native Android JUnit test cases ran.
- **Source/release gap:** current `main` is 55 commits ahead / 0 behind Build #153. GitHub compare reports 18 changed paths (11 Markdown, 4 Dart source and 3 test files). Current Settings/About, Statistics, Peltier, Temperature, Home hit-target, polling and integrity-screen fixes are not in Build #153 APK. Release #153 remains the latest package.
- **CI state at audit:** latest run #153 is completed SUCCESS; no active run or open PR. Release tag still resolves to the Build #153 source SHA. No build trigger was sent.

Evidence is classified as **STATIC SOURCE CHECK** unless explicitly stated otherwise. Source inspection does not prove runtime behavior, performance or visual acceptance.

## 2. What is already in good shape — preserve it

1. **Product identity:** retain the JE X FYZ Home composition, 3D cooler hero asset, seven telemetry indicators, Phosphor icon family and existing telemetry-specific color meanings. Do not replace this with a generic dashboard/card template.
2. **One visual canvas:** preserve the 360-dp master canvas, single DPI transform, safe-area/inset conversion and compact Settings theme. No second transform or global zoom change.
3. **State truth:** BLE P1 readiness, Firmware-owned Lock Voltage, authoritative telemetry, disconnected/unknown `--`, command/ACK/telemetry distinction and Fan-ACK-before-Peltier remain protected.
4. **Localization:** 354 localization keys were found; no duplicate keys and no missing statically referenced `JexText.of('key')` entries were detected. Preserve EN/ID and verify long translated strings in UI.
5. **Theme:** light/dark semantic foreground/surface roles and the compact Settings theme are centralized in `app_settings.dart`. Keep semantic telemetry colors; do not collapse every color into one accent.
6. **Current Settings refinement:** one-line Settings rows, useful right-side values, concise Lock Voltage status, boxed About credits and removal of Diagnostics are already in source. This was source-read-back only and remains unrendered.
7. **Safety and prior fixes:** Peltier prerequisite remains centered and non-scrollable, requires successful `FAN:ON` ACK before `PELTIER:ON`, and Cancel is command-free. Temperature global reset UI remains removed. Device Diagnostics remains removed.

## 3. P1 remediation — source implemented; QC evidence pending

### P1.0 — Usage Statistics selected-time dock

**Status: SOURCE FIX IMPLEMENTED / HEIGHT REGRESSION ADDED / TEST NOT RUN / VISUAL NOT VERIFIED.**

- The selected-time readout remains in `Scaffold.bottomNavigationBar`; its outer `Column` now uses `MainAxisSize.min`, and the dock has stable key `usage-selected-time-dock`.
- All six selected-time values, elapsed time, SafeArea, existing 48×48 dp clear target and chart/timeline interactions are retained.
- Widget test now asserts the dock measures no more than 200 dp at normal text scale and disappears after Clear.
- The owner screenshot established the old layout defect. The correction is source-read-back/static evidence until a new APK is rendered on Android.

### P1.1 — Usage Statistics long-session cost and write backpressure

**Status: SOURCE OPTIMIZED / SYNTHETIC LONG-HISTORY TEST ADDED / DEVICE SOAK NOT RUN.**

- `UsageStatsWriteQueue` serializes writes with a maximum of 64 scheduled operations and waits for capacity instead of intentionally discarding accepted work. Write failures remain visible through `lastWriteError`.
- Temperature sample persistence and its session freshness update now share one SQLite transaction. Hotside alone updates P1 `last_seen_at_ms`; phone Battery updates only its own freshness. Null samples remain explicit gaps. Database schema/version 2, retention and raw 1-Hz capture are unchanged.
- Live updates are coalesced per one-second flush. A selected-session event identity set de-duplicates updates; sorted merge avoids rescanning existing events per addition; analytics summary is calculated once per flush batch.
- Analytics indexes events by session/metric in one pass, sorts only when a group is not already chronological, uses binary search for selected-time temperature lookup, and caches decimated chart points in the summary.
- Regression tests construct 12,000 Battery and 12,000 Hotside observations, assert raw points remain present and chart output is bounded to 1,600 points per sensor, and exercise queue capacity/FIFO completion.
- **Remaining evidence gap:** one selected-session summary/chart-decimation pass still runs per one-second diagram refresh. This is not a fully incremental accumulator. No Android CPU/memory soak or sustained SQLite backlog measurement has run. Validate 1-hour/8-hour/longer sessions before final product acceptance.

### P1.2 — Native status polling overlap

**Status: SOURCE GUARD IMPLEMENTED / REGRESSION SOURCE ADDED / DEVICE VERIFICATION NOT RUN.**

- Connection sheet status refresh is single-flight, runs every 3 seconds while active, refreshes immediately on open/resume, and cancels its timer while backgrounded/disposed.
- Floating Monitor reconciliation is single-flight, runs every 3 seconds while enabled/connected, and pauses in the background; resume restarts the timer and performs one immediate check.
- The 300-ms interval remains only in the bounded, maximum-2-second Android overlay-permission return flow. It is not a permanent poll.
- Source-contract tests cover cadence, guards and lifecycle. Slow/out-of-order MethodChannel responses, permission revocation and OEM overlay recovery still require device validation.

### P1.3 — Home and Temperature touch targets

**Status: SOURCE IMPLEMENTED / REGRESSION SOURCE ADDED / DEVICE TOUCH TEST NOT RUN.**

- Home Bluetooth and Settings header actions now provide 48×48 dp hit surfaces while visible Phosphor artwork remains 25 dp.
- Home tab strip height is 48 dp.
- Temperature +/- retains 34×34 dp visible artwork inside a 48×48 dp Material/InkWell surface.
- Existing Connection 40–42 dp legacy controls are unchanged.
- Source-contract test checks dimensions. Actual Android touch boundaries and adjacent-control behavior require device QA.

### P1.4 — Tamper/integrity screen copy

**Status: SOURCE IMPLEMENTED / WIDGET REGRESSION UPDATED / NATIVE SECURITY CONTRACT UNCHANGED.**

- The profanity wall and `_insult()` presentation have been removed.
- The screen now uses concise bilingual official-build verification failure copy, an explicit dark Material theme, instructions to install the official release, and the existing developer-contact action.
- The widget test asserts Indonesian copy, CTA behavior, absence of profanity and the retained native developer-contact route.
- Native signing-certificate verification, fail-closed routing and Android/native code were not modified. The new test is written but not run on current main.

### P1.5 — Current-source execution evidence

**Status: BLOCKED / NOT RUN LOCALLY; READY FOR GUARDED CI VALIDATION.**

- Current main contains 184 test declarations (171 unit/source-contract, 13 widget). They have not run in the current runtime because Flutter/Dart executables are unavailable.
- Build #153's 176/176 result applies only to old immutable SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, not current main.
- Next evidence must come from the separate guarded App Build workflow on exact source SHA `aa58a2f14354692a1dbcebfcb70436deb3aabf06`. Fix any failure at root and rerun; do not weaken contracts.
- The guarded workflow currently has no Dart formatter step. Formatter/lint policy remains a P2 follow-up and must not be reported as passed.

## 4. P2 — professional polish and maintainability

### P2.1 — Typography and microcopy hierarchy

Source contains 15 distinct explicit font-size values from 6.8 to 21 dp. Several presentation labels are particularly small:
- Home “Developed by Horizon” is 6.8 dp.
- Home tab captions are 9 dp.
- Home NOTIFY label/body are 9.5/10.5 dp.
- Usage chart axis labels are 9 dp.
- Firmware dialog's “saved securely” helper is 9 dp.

**Recommendation:** establish a restrained role hierarchy based on the existing Roboto/ThemeData roles: screen title, row/section title, primary value, supporting state, caption. Remove purely decorative microcopy where it adds no product information; make essential helper/axis text readable. Do not enlarge every label indiscriminately or sacrifice telemetry fit.

### P2.2 — Modal consistency

Peltier now has a compact custom JE card; LED picker has its own fixed-canvas panel; Firmware Update still uses a stock AlertDialog with scroll content and tiny helper copy. The Firmware dialog has a valid reason to scroll when the keyboard is open, so do not remove scrolling merely for visual uniformity.

**Recommendation:** align title/body/action typography, inset rhythm, surface, localized error/loading states and 48-dp action targets with the existing theme. Preserve scrolling/keyboard behavior, password visibility, secure credential storage, retry and OTA gating.

### P2.3 — Floating Monitor settings cohesion

Floating Monitor has a distinct configuration-heavy page with reorderable metric rows, checkboxes, two sliders, segmented background/orientation controls and a master enable switch. It is functional and compact, but uses more default Material ListTile/SwitchListTile/SegmentedButton presentation than the custom Home/Settings rows.

**Recommendation:** review the complete page at 350/420 dp and EN/ID before changing it. If it remains visually inconsistent, group related controls with one restrained section hierarchy; do not add nested cards or change stored configuration identifiers, reorder semantics, overlay permission flow, or native window ownership.

### P2.4 — Formatting, lint policy and source structure

- `pubspec.yaml` declares `flutter_lints`, but the recursive tree contains no `analysis_options.yaml`; the recommended lint set is therefore not configured through the standard analysis-options entry point.
- Current guarded workflow runs `flutter analyze --no-fatal-infos` and `flutter test`, but no Dart formatter check is present.
- Static scan found 40 lines over 120 characters in `main.dart`, 19 in `usage_statistics.dart`, 16 in `app_settings.dart`, and a compressed pair of statements in `FirmwareUpdateDialog`. A real `dart format` run is still required; line-length inspection is not a formatter substitute.
- `main.dart` contains ~10.6k lines mixing Dashboard/UI, BLE lifecycle/parsing, commands, notifications and OTA UI. `usage_statistics.dart` combines SQLite persistence, recorder, analytics, screen and painters.

**Recommendation:** format changed Dart files and review analyzer infos. Introduce a lint policy deliberately, after checking the current analyzer baseline. Defer broad file extraction until screen-level source stabilizes; later split UI components from BLE/OTA orchestration in small, test-backed steps. Do not mix a risky architectural rewrite into a visual cleanup.

### P2.5 — Design-token audit, not blanket normalization

Static source inventory found 71 distinct literal `Color(0x...)` values, 13 distinct corner radii and 15 explicit font sizes across the core Dart UI. Many colors encode telemetry meaning and chart lanes, so this count alone is not a defect.

**Recommendation:** document semantic roles and consolidate repeated surface/border/spacing/typography values only where the same meaning is currently implemented differently. Preserve the distinct battery, Hotside, voltage, adaptive, Peltier and Fan cues. Do not replace them with a generic single-accent palette.

### P2.6 — Fixed text scaling and visual evidence

Home and fixed-canvas routes use `TextScaler.noScaling` to preserve the established physical-size/DPI contract. Treat this as a known accessibility limitation, not as proof of large-text support. It must not be silently removed or changed during a visual sweep.

There are no screenshot/golden or `integration_test` assets in the current test tree. Only 13 of 179 tests are widget tests; actual visual acceptance is still a manual/device gate. Capture matched 350/420-dp, EN/ID, Light/Dark screenshots at the exact tested source SHA.

## 5. Design direction for the whole App

- **Keep the signature:** JE Cooler Home hero image, telemetry colors, Phosphor glyphs and 360-dp master canvas stay recognizable. The Home screen should be refined, not replaced.
- **Use one hierarchy:** section title → grouped controls → primary value/state → optional concise helper. Remove redundant explanatory paragraphs if the control/value already communicates the state.
- **Use surfaces sparingly:** card only for meaningful grouping; avoid nested cards, random pills/badges, decorative gradients, neon glow, shadow stacks and unneeded animations.
- **Compact by structure, not by shrinking:** align values and actions, reduce duplicate copy, use consistent row spacing, preserve readable text and 48-dp hit surfaces.
- **Keep state honest:** unknown remains `--`; display command confirmation separately from physical telemetry; no decorative state or stale metric is introduced.
- **Localization is part of layout:** test the longest EN/ID strings and right-aligned values, not just short English examples.

## 6. Pre-build remediation sequence

1. **Pass A — UX and accessibility:** neutral integrity screen copy while retaining the fail-closed gate; 48-dp touch surfaces for Home header/tabs/Temperature +/-; review microtext and dialog consistency.
2. **Pass B — runtime efficiency:** remove overlapping Connection/Floating polling, add lifecycle/in-flight controls, bound/coalesce the Statistics writer and reduce per-second full-history recomputation without losing raw data/gaps.
3. **Pass C — code quality:** format all changed Dart files, configure/verify lint policy, review analyzer infos, strengthen tests for timers, long-session storage/backpressure, tap targets, EN/ID, unknown/disconnected states and cancellation.
4. **Pass D — guarded App validation:** build only after Passes A–C and current-main tests are clean. Then inspect real screenshots and device behavior; a successful APK build alone is not visual or physical acceptance.

## 7. Definition of “ready to build”

- All accepted P1 findings are fixed or explicitly dispositioned; no silent deferrals.
- Formatter is clean; analyzer has no errors/warnings and the info baseline is reviewed.
- All tests on the exact current SHA pass, with long-session/backpressure and polling overlap tests included.
- No accidental change to BLE P1, telemetry authority, Firmware safety, OTA, persisted schemas, Android `versionName "Telegram @horizontalzzz"`, theme/localization or 360-dp canvas.
- Actual screenshot matrix is prepared for Home, Settings, Bluetooth/Connection, Floating Monitor, Usage Statistics, Voltage/Control/Adaptive/LED/Temperature tabs, Peltier dialog, LED picker and Firmware dialog at 350/420 dp, EN/ID and Light/Dark. Include constrained height and disconnected/unknown/locked/error states.
- Owner visual review is recorded separately as VISUAL PASS / VISUAL PASS WITH ACCEPTED LIMITS / VISUAL REJECT / VISUAL NOT VERIFIED.
- Only then issue a separate `Eksekusi Build App!`; no build is authorized by this audit.

## 8. Independent review handoff (Gemini)

Gemini cannot read this private repository. For an independent opinion, paste this brief with the current Settings/Home/Connection/Statistics/Tamper/Firmware snippets from the relevant source files. Ask the reviewer to:
1. rank the P1/P2 findings by user impact and engineering risk;
2. identify missing risks without inventing runtime facts;
3. challenge the proposed compact visual hierarchy against JE Cooler identity and anti-AI-slop rules;
4. propose the smallest safe implementation sequence and objective acceptance criteria;
5. explicitly separate source-derived concerns, hypotheses requiring tests, and visual findings requiring screenshots.

Do not ask Gemini to claim it inspected GitHub, executed Flutter tests, or saw an APK; its response is advisory and must be checked against live source and test evidence.

---

**Audit conclusion (updated 2026-11-12):** source remediation is implemented for the Statistics dock/data path, native polling overlap, Home/Temperature touch targets and TamperScreen presentation. The current 184-test suite, analyzer and formatter have not run here. The next operation may be the separate guarded `Eksekusi Build App!` QC on exact main SHA `aa58a2f14354692a1dbcebfcb70436deb3aabf06`. This means ready to execute QC, not a passed build, visual pass, device validation or release. One selected-session summary/decimation pass remains each second; long-session CPU/memory soak, formatter/lint standard and Android visual/touch acceptance remain explicit follow-up evidence.
