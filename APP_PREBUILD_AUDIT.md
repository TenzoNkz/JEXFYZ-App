# JE Cooler App — Full Pre-Build Audit

**Audit date:** 2026-11-12 (Asia/Jakarta)  
**Mode:** `@Thinking Diskusi!` — static source/repository analysis only.  
**Disposition:** **NOT READY FOR NEXT BUILD.** This is not a claim that the App is broken; it means known pre-build risks and the gap between current source and last tested/released source must be closed before packaging.

## 1. Baseline and evidence

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Audited branch HEAD:** `4d02fbf705a85820a4ea1e530d167ebb53ab3a68` (documentation checkpoint). The latest executable App/test state is source commit `1cae4cfc061328b3b2b8bed96987c410f37373f2` plus regression test commit `96301aec962739c39518e84f38cd4294d975595f`.
- **Tree:** 131 entries, recursive listing not truncated. No working-tree/source mutation, test execution or build was performed during this audit.
- **Current executable surface:** 7 Dart library files; 9 test files. Main App implementation is concentrated in `lib/main.dart` (10,632 lines / ~390 KB), followed by `lib/usage_statistics.dart` (3,179 lines / ~103 KB), `lib/floating_monitor.dart` (1,788 lines / ~65 KB) and `lib/app_settings.dart` (1,678 lines / ~63 KB).
- **Tests in current main:** 179 test declarations — 166 unit/source-contract and 13 widget tests. This is a source inventory, not a passing result. The 3 tests added after Build #153 have not been executed on current main.
- **Latest verified package:** Build #153 / Actions run `43145542329`, tested source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Release ID `403010611`, tag `jexfyz-latest`. Build #153 reported 176/176 Flutter tests, analyzer 23 info / 0 warnings / 0 errors, and Android Gradle success. Its native Android JUnit tasks were NO-SOURCE; no native Android JUnit test cases ran.
- **Source/release gap:** current main is 47 commits ahead / 0 behind Build #153; compare lists 13 paths (8 Markdown and 5 App/test paths). Current Settings/About, Peltier dialog and Temperature-tab changes are not in the Build #153 APK. Release #153 is still the latest package.
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

## 3. P1 — close before the next App Build

### P1.1 — Usage Statistics long-session cost and backpressure

**Evidence in source**
- `UsageStatisticsRecorder._enqueue()` appends every SQLite operation to a single Future chain without a queue bound, coalescing policy or backpressure signal.
- `_flushLiveUpdates()` merges the new updates into the selected session's full event list, scans existing events with `.any()` for each incoming event, sorts the merged list, then calls `UsageStatsAnalytics.summarize()` over the full snapshot every one-second refresh.
- Existing project notes already identify long-session CPU/memory, queue backpressure and 60/120-Hz animation lifecycle as unverified.

**Risk:** O(n²)-like duplicate checking in each batch plus repeated full-session summarize/sort can progressively cost more as a session grows. Slow storage can grow the queued Future chain. This is a source-derived performance risk, not a reproduced field failure.

**Remediation direction:** use a keyed event identity set/map for batch de-duplication; maintain incremental summary state where mathematically safe; bound/coalesce queued writes without dropping raw sensor observations or falsifying gaps; expose persistent write failure clearly; preserve the local SQLite schema/retention and P1 coverage semantics. Add synthetic long-session tests and measure memory/CPU and write-queue depth before/after.

### P1.2 — Native status polling can overlap

**Evidence in source**
- `_ConnectionSheetContentState` starts a 650-ms periodic timer. Each refresh requests adapter state, multiple permission statuses, Android SDK level and location-service state. There is no explicit in-flight/coalescing guard in `_refreshStatus()`.
- Floating Monitor starts a 300-ms runtime timer while enabled/connected. Each pass checks overlay permission and requests native runtime state; `_syncRuntimeState()` has no explicit in-flight guard.
- The project comments describe Floating Monitor reconciliation as low-frequency, but 300 ms is approximately 3.3 cycles per second.

**Risk:** slow MethodChannel/plugin responses can overlap; older results may arrive after newer state, cause redundant rebuilds, or increase bridge/battery work. This was not profiled or reproduced on an OEM device.

**Remediation direction:** add single-flight/coalescing guards and lifecycle-aware refresh; use adapter streams/native events where available; otherwise use a lower bounded interval and immediate refresh only on open/resume/user action. Retain permission revocation detection and overlay-attachment recovery. Add deterministic tests for delayed/out-of-order responses and ensure disposal cancels all work.

### P1.3 — Home and Temperature touch targets

**Evidence in source**
- Home Bluetooth and Settings IconButtons constrain their targets to 36×36 dp.
- Home tab row is 42 dp high.
- Temperature +/- buttons draw and hit-test at 34×34 dp.
- Connection sheet's 40–42 dp controls are a documented legacy exception; do not make them smaller.

**Risk:** the visible glyph/button is compact but targets in Home and Temperature are below the 48×48 dp target used by the current design/accessibility standard.

**Remediation direction:** preserve the visible 25-dp icons and 34-dp stepper artwork, but give each a 48×48 dp hit surface with deliberate spacing. Increase the Home tab hit area to 48 dp without changing the 360-dp canvas or Home geometry beyond the required small vertical allowance. Test at 350/420 dp and inspect actual touch boundaries. Do not shrink the Connection legacy controls.

### P1.4 — Tamper/integrity screen copy

**Evidence in source**
- `TamperScreen` displays a long wall of explicit Indonesian profanity via hard-coded `_insult()` widgets.
- `test/widget_test.dart` deliberately asserts the “insult-only wall” behavior. This is an existing test contract, not accidental localization leakage.
- The screen is entered when the native official-signature check returns false or cannot be confirmed.

**Risk:** an invalid signature, unexpected verification failure or unsupported build can expose abusive content rather than an actionable integrity explanation. This is inconsistent with a professional device-control product.

**Remediation direction:** replace the profanity with a neutral, localized “Official build verification failed” state, brief instructions to obtain/install the official signed release, and the existing developer-contact action. Preserve the fail-closed integrity gate and signing-certificate verification; never make failed verification launch the normal App. Update the explicit legacy test to assert the neutral integrity state.

### P1.5 — Latest source has no execution evidence yet

**Evidence:** current main contains 179 tests, while the latest verified Build #153 ran 176 tests against an older immutable SHA. No current-main formatter, analyzer, focused test, complete Flutter suite, APK, screenshot or device run has occurred.

**Required before package:** run the entire current suite on the exact source SHA and inspect actual analyzer/test logs. Do not quote Build #153's 176/176 as proof of current main. Any new failure must be repaired at its root and rerun; never weaken a test to force success.

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

**Audit conclusion:** current App source is materially newer than Build #153 and has not been validated. Several measurable UX/performance/accessibility risks remain. The next operation should be a scoped `Eksekusi Full!` remediation pass, not Build App. This audit does not modify App/Firmware source, tests, build workflow or release artifacts.
