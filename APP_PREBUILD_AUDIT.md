# JE Cooler App — Full Pre-Build Audit

**Audit date:** 2026-11-12 (Asia/Jakarta)  
**Mode:** `@Thinking Eksekusi Full!` — App source, regression tests and documentation only; no Build/Release, workflow trigger, Firmware or device operation.  
**Disposition:** **HOLD BEFORE GUARDED APP BUILD QC — both Statistics boundedness source findings have been remediated and regression source added, but no Dart/Flutter execution or formatter evidence exists.** The writer now has a hard 72-operation ceiling with immediate visible rejection for excess submissions, and decimation enforces the render-point budget while carrying gap boundaries forward. The 187-test current suite, formatter and analyzer remain NOT RUN; the guarded workflow has no formatter step. Long-session performance and visual/device acceptance remain unverified.

## 1. Baseline and evidence

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Audited baseline:** executable source snapshot `4d02fbf705a85820a4ea1e530d167ebb53ab3a68`. **Current repository tree:** 132 entries, recursive listing not truncated. Documentation-only checkpoint commits follow this executable source snapshot. **Current source/test code checkpoint:** `632cdc1f55e9080d6b1559f103f33e3eed698006` (latest code/test commit before these documentation updates); `lib/usage_statistics.dart` blob `2ab91603e28be53ca1138d279ee33fb0b0e0375e`, `test/usage_statistics_test.dart` blob `46fb3765e47dbecf24da18ec3df20df8c2f25bb2`. Source remediation commits are `5763b08f8b37fccafd2ac2403a51b26ad0be4b41`, `b1275d278ca0b0d2765174364250873044a943d1`, `aa58a2f14354692a1dbcebfcb70436deb3aabf06` and `a963f8bd100f7f2c41f720933ade2cd586145270`.
- **Audit progression:** the initial static audit was performed on executable snapshot `4d02fbf705a85820a4ea1e530d167ebb53ab3a68`. Subsequent source/test commits have remediated the bounded writer, HOT receipt-time closure and gap-aware render budget; current code/test checkpoint is `632cdc1f55e9080d6b1559f103f33e3eed698006`. Current recursive tree has 132 entries, not truncated.
- **Current executable surface:** 7 Dart library files; 9 test files. Main implementation is concentrated in `lib/main.dart` (10,563 lines / ~387 KB), `lib/usage_statistics.dart` (3,298 lines / ~106 KB), `lib/floating_monitor.dart` (1,808 lines / ~65 KB) and `lib/app_settings.dart`.
- **Tests in current main:** 187 declarations — 174 unit/source-contract and 13 widget tests. This is an inventory only, not a passing result. All current-main tests remain **NOT RUN**.
- **Latest verified package:** Build #153 / Actions run `43145542329`, tested source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Release ID `403010611`, tag `jexfyz-latest`. Build #153 reported 176/176 Flutter tests, analyzer 23 info / 0 warnings / 0 errors, and Android Gradle success. Its native Android JUnit tasks were NO-SOURCE; no native Android JUnit test cases ran.
- **Source/release gap:** current `main` is 79 commits ahead / 0 behind Build #153. GitHub compare reports 18 changed paths (11 Markdown, 4 Dart source and 3 test files). Current Settings/About, Statistics, Peltier, Temperature, Home hit-target, polling and integrity-screen fixes are not in Build #153 APK. Release #153 remains the latest package.
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

- `UsageStatsWriteQueue` serializes accepted writes FIFO with 64 normal slots plus 8 reserved control slots (72 total). Producer submissions do not wait for admission. Excess submissions are rejected immediately, counted and surfaced through `lastWriteError`; accepted operations are not evicted. Clear History propagates rejection to its UI error handler.
- Temperature sample persistence and its session freshness update now share one SQLite transaction. Hotside alone updates P1 `last_seen_at_ms`; phone Battery updates only its own freshness. Null samples remain explicit gaps. Database schema/version 2, retention and raw 1-Hz capture are unchanged.
- Live updates are coalesced per one-second flush. A selected-session event identity set de-duplicates updates; sorted merge avoids rescanning existing events per addition; analytics summary is calculated once per flush batch.
- Analytics indexes events by session/metric in one pass, sorts only when a group is not already chronological, uses binary search for selected-time temperature lookup, and caches decimated chart points in the summary.
- Regression tests construct 12,000 Battery and 12,000 Hotside observations, assert raw points remain present and chart output is bounded to 1,600 points per sensor, and now add a 24,000-point alternating-null/gap-heavy decimation fixture plus fire-and-forget queue admission/reserve/rejection/FIFO/Clear-error coverage. These tests are written but NOT RUN.
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

- Current main contains 187 test declarations (174 unit/source-contract, 13 widget). They have not run in the current runtime because Flutter/Dart executables are unavailable.
- Build #153's 176/176 result applies only to old immutable SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, not current main.
- Next evidence must come from the separate guarded App Build workflow on exact source SHA `a963f8bd100f7f2c41f720933ade2cd586145270`. Fix any failure at root and rerun; do not weaken contracts.
- The guarded workflow currently has no Dart formatter step. Formatter/lint policy remains a P2 follow-up and must not be reported as passed.

## 4. P2 — professional polish and maintainability

### P2.7 — Statistics writer admission and fire-and-forget producer bound

**Status: SOURCE REMEDIATION IMPLEMENTED / REGRESSION SOURCE ADDED / RUNTIME NOT RUN.**

- UsageStatsWriteQueue no longer waits for queue admission. It accepts FIFO work up to 64 normal pending operations; session lifecycle and Voltage/Adaptive/Peltier control operations may use 8 additional reserved slots (72 total). Fan Speed and raw temperature producers use the normal ceiling.
- A submission beyond its applicable ceiling is rejected synchronously, increments rejectedOperations and reports a StateError through lastWriteError. Accepted work is never evicted to make room. This removes the unbounded chain of suspended producer Futures created when main.dart uses unawaited() calls.
- Overload is an explicit availability-versus-history trade-off: excess incoming records are not accepted and the Statistics page displays a persistent bilingual warning. The design does not claim lossless indefinite buffering under a permanently stalled store. Clear History uses failOnReject and reaches the existing UI error handler instead of appearing successful.
- P1 freshness is based on actual HOT receipt time, not SQLite write progress. A slow/rejected history write cannot falsely stale a continuously receiving P1 session. A late HOT packet after the 2.5-second stale threshold does not refresh or enter the old session; it leaves the previous receipt timestamp for the watchdog to close through reserved capacity. Explicit null sample gaps are written on recovery or close; both sensor segments are handled when a session ends, including the HOT-stale path.
- Regression source now models a held writer and fire-and-forget submissions, asserts bounded capacity plus reserve, explicit rejection, FIFO for accepted operations and error propagation; a separate source-contract also asserts that a late HOT packet leaves the old receipt timestamp intact so the watchdog retains closure authority. These tests do not replace a sustained SQLite/device storage-pressure soak.
- **Remaining evidence gap:** all Dart tests/analyzer/formatter are NOT RUN; 1-hour/8-hour backlog drain rate, rejection frequency, CPU/memory and data completeness under real device storage pressure remain unmeasured.

### P2.8 — Chart decimation hard cap under dense invalid/gap data

**Status: SOURCE REMEDIATION IMPLEMENTED / INVALID-HEAVY REGRESSION SOURCE ADDED / RUNTIME NOT RUN.**

- decimatePoints(maxPoints) now selects at most four representatives per bucket (endpoints/minimum/maximum) and returns no more than maxPoints, including small budgets below four.
- Null/breakBefore points that are not retained are represented by breakBefore=true on the next retained valid point. This preserves visual discontinuities without requiring every gap marker to consume a render slot. The painter therefore starts a new path and does not connect across a discarded invalid interval.
- Raw SQLite samples, session data and full-resolution summary/statistics inputs are not decimated or deleted; only the rendered chart-point list is reduced.
- Regression source creates 24,000 alternating valid/null points plus periodic explicit boundaries and session changes, checks budgets 1/2/3/7/8/1599/1600 and verifies no retained line bridges a skipped gap.
- **Remaining evidence gap:** the Dart test is written but NOT RUN. Large-history UI frame time, allocation, chart rendering and long-session memory need device/Flutter validation.

### P2.9 — Formatting is not a guarded workflow gate

**Status: BLOCKED / NOT RUN / NOT ENFORCED BY CURRENT WORKFLOW.**

- The current workflow runs flutter analyze --no-fatal-infos, flutter test, Android Gradle and release signing/package gates; no dart format --output=none --set-exit-if-changed step exists.
- A successful guarded Build App therefore will not prove Dart formatting. Dart is unavailable in the current runtime and the changed files have not been formatted or checked. The changed Dart files still need explicit formatting/check evidence or a separately approved formatter gate.


### P2.1 — Typography and microcopy hierarchy

Source contains 15 distinct explicit font-size values from 6.8 to 21 dp. Several presentation labels are particularly small:
- Home “Developed by Horizon” is 6.8 dp.
- Home tab captions are 9 dp.
- Home NOTIFY label/body are 9.5/10.5 dp.
- Usage chart axis labels are 10 dp; narrow-range y-axis ticks now choose decimal precision from tick spacing to avoid duplicate rounded values.
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

There are no screenshot/golden or `integration_test` assets in the current test tree. Only 13 of 187 tests are widget tests; actual visual acceptance is still a manual/device gate. Capture matched 350/420-dp, EN/ID, Light/Dark screenshots at the exact tested source SHA.

## 5. Design direction for the whole App

- **Keep the signature:** JE Cooler Home hero image, telemetry colors, Phosphor glyphs and 360-dp master canvas stay recognizable. The Home screen should be refined, not replaced.
- **Use one hierarchy:** section title → grouped controls → primary value/state → optional concise helper. Remove redundant explanatory paragraphs if the control/value already communicates the state.
- **Use surfaces sparingly:** card only for meaningful grouping; avoid nested cards, random pills/badges, decorative gradients, neon glow, shadow stacks and unneeded animations.
- **Compact by structure, not by shrinking:** align values and actions, reduce duplicate copy, use consistent row spacing, preserve readable text and 48-dp hit surfaces.
- **Keep state honest:** unknown remains `--`; display command confirmation separately from physical telemetry; no decorative state or stale metric is introduced.
- **Localization is part of layout:** test the longest EN/ID strings and right-aligned values, not just short English examples.

## 6. Pre-build remediation sequence

1. **Pass A — UX and accessibility:** neutral integrity screen copy while retaining the fail-closed gate; 48-dp touch surfaces for Home header/tabs/Temperature +/-; review microtext and dialog consistency.
2. **Pass B — runtime efficiency:** remove overlapping Connection/Floating polling, add lifecycle/in-flight controls, bound Statistics writer admission without blocking BLE producers, preserve explicit raw-data gaps, and continue to assess per-second full-history recomputation.
3. **Pass C — code quality:** explicitly format all changed Dart files, configure/verify lint policy, review analyzer infos, run the new bounded-ingress and dense-gap regressions plus long-session storage/backpressure, tap-target, EN/ID, unknown/disconnected-state and cancellation tests.
4. **Pass D — guarded App validation:** build only after Passes A–C and current-main tests are clean. Then inspect real screenshots and device behavior; a successful APK build alone is not visual or physical acceptance.

## 7. Definition of “ready to build”

- All accepted P1 findings and the two Statistics boundedness edge cases are fixed or explicitly dispositioned; no silent deferrals.
- Formatter is clean through an explicit formatter run or enforced formatter gate; analyzer has no errors/warnings and the info baseline is reviewed. None of these current-source results is available yet.
- All tests on the exact current SHA pass, with delayed-writer/unawaited-submitter, invalid-heavy gap decimation, long-session and polling-overlap cases included.
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

**Audit conclusion (updated 2026-11-12):** source remediation now resolves both identified Statistics boundedness issues at the code level: producer admission is capped at 64 normal + 8 reserved operations with explicit rejection, late HOT receipts do not mask a stale P1 timeout, session-close gaps remain explicit, and rendered decimation is hard-capped with gap-boundary propagation. The current source/test revision has 187 written test declarations, but none has run here; formatter and analyzer are also NOT RUN, and the guarded workflow has no formatter gate. **Disposition: HOLD guarded Build QC until Dart formatting and exact-source Flutter tests/analyzer are evidenced.** No Build App/Actions trigger was sent. Full-session summary/decimation still occurs once per second; long-session CPU/memory soak and Android visual/touch acceptance remain unverified.
