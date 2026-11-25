## Current package baseline — Build #167 — 2026-11-24

- The Home cooler enlargement (right image column flex 14; uniform 1.08× scale anchored right; `BoxFit.contain`; seven left metrics unchanged at 45 dp) is now included in the published Build #167 package.
- Package source: `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; Release `403010611` / tag `jexfyz-latest`.
- UI acceptance remains **VISUAL NOT VERIFIED** until actual installed Android screenshots are reviewed at the viewport/locale/theme matrix in the Home cooler artwork section below. Hosted Flutter tests and Build App CI do not replace screenshot evidence.


## Full App visual redesign brief — owner request 2026-11-26

**Direction: “Quiet Luxury / Precision Instrument”.** This is the design brief for the full App rework recorded in `APP_PREBUILD_AUDIT.md`. It expands the earlier motion refinement into a screen-by-screen visual system; it is not a new brand/asset/font/palette approval and is not yet implemented.

### Visual character

JE Cooler should feel like a considered premium hardware product: quiet confidence, precise information, tactile controls, generous but disciplined spacing and responsive feedback. Elegance comes from typography, proportions, alignment, material restraint and predictable interaction—not a stack of rounded cards, gradients, glows or decorative movement.

- Define a semantic palette with clear background/surface/elevated/outline/foreground/accent/status roles and deliberate Light/Dark mappings. Derive exact values from the existing JE X FYZ theme and owner-approved reference screenshots; do not invent final HEX values from taste alone.
- Establish a type scale with a clear brand/title, screen title, metric/value, section, body, supporting and micro-label role. Avoid all-caps microcopy for ordinary content, over-bold labels and multiple unrelated fonts. Check small-device readability and long Indonesian copy.
- Set one spacing rhythm, corner scale, border weight, elevation policy and control geometry. Use a small number of semantic surface types; avoid nesting multiple cards to contain each other.
- Keep functional accent color meaningful: selected tab/action and real hardware/safety semantics only. Disconnected, unknown, pending, acknowledged, confirmed, warning, locked and error states must not share misleading color/icon treatment.
- Use the existing Phosphor family and approved cooler art. Retain the full transparent artwork and do not generate a replacement logo/asset as part of this code plan.

### Screen composition goals

- **Home:** cooler remains the hero; metrics form a calm, easy-to-scan information column; header and controls feel balanced; connection state and Notification are explicit; primary Connect/Settings affordances are discoverable. Preserve the seven metric rows and approved 360-dp geometry until any proposed composition change has its own owner-reviewed visual decision.
- **Five control tabs:** retain individual task identity but share a clear tab selector, consistent control sizes, alignment, state labels and interaction feedback. Give primary settings the strongest hierarchy and secondary explanation enough space without clutter. Avoid making every tab a clone.
- **Connection:** use a clear progression rather than a generic scanning spinner: permission and adapter prerequisites, scan action, discovered device, connecting, P1 syncing/ready and failure/retry. Animate actual transitions, not invented device activity.
- **Settings:** concise grouped sections, clear page titles and subtitles, aligned leading icons, readable supporting text and predictable navigation. Make the important device-level setting distinct without introducing excess containers.
- **Usage Statistics:** present session identity/time range, key metrics, temperature trends, activity state lanes and selected-time details as one analytical composition. Use a restrained chart grid and readable axes; retain real gaps and exact timestamp mapping.
- **Floating Monitor:** make its Settings/configuration visually coherent with the App, but establish a native Canvas typography/spacing/contrast specification for the actual overlay. Review real available width, localization, drag/resize handles and OEM/window insets separately.
- **Dialogs and sheets:** one hierarchy for title, concise explanation, consequence, primary action and secondary escape. Use consistent corner treatment and motion; do not use color alone to signal risk.
- **Firmware Update presentation:** show only actual state/stage, confirmed progress, actionable error and recovery message. This visual work cannot change transport/trust/security/retry/recovery implementation.

### Interaction and motion goals

Use the motion timings recorded in the 2026-11-25 proposal (100–140 ms press, 160–220 ms control/state, 180–240 ms tab, 220–300 ms route/dialog). Keep the same easing family and distance logic across the App. Keep transitions interruptible and lifecycle-safe. Hardware-coupled Fan/LED/Peltier motion remains tied to its existing confirmed state and LED phase contract; telemetry numbers never roll through fabricated intermediate values. Platform reduced-motion preference must replace nonessential loops with stable states.

### Visual decision rule

Before changing an approved Home composition, cooler scale, master canvas/DPI formula, typography contract, theme identity or asset, record the problem, screenshot evidence, alternative treatments and impact on accessibility/localization. This owner-requested full redesign permits that exploration, but the final specific layout/token change still requires a recorded decision; no silent contract replacement.

### Visual acceptance matrix

Capture actual App screenshots and review Home, each control tab, Connection, Settings/subpages, Usage Statistics, dialogs/sheets and Floating Monitor. Cover applicable 350-dp/420-dp fixed-canvas cases, narrow supported viewport, portrait/constrained height, EN/ID, Light/Dark, connected/disconnected/error/locked states, supported enlarged text and reduced motion. Record source SHA, device/Android version, logical dp/density and all relevant settings. Goldens and widget tests are regression aids; they do not substitute for Android rendering. Until the real-screen matrix is inspected, report **VISUAL NOT VERIFIED**.

### Owner screenshot review — Build #167 Home — 2026-11-24

- **Evidence:** SCREENSHOT REVIEWED — owner supplied one portrait Home screenshot labelled Build #167. It shows English / Light appearance / BLE disconnected. The cooler silhouette is fully visible in the captured viewport; all seven metric labels remain readable; the Notification card and locked submenu overlay are visible. Screenshot metadata does not identify exact source SHA, logical dp width/density or text-scale configuration.
- **Outcome:** overall acceptance remains **VISUAL NOT VERIFIED**. This is one screenshot/state, not the required 350-dp/420-dp, English/Indonesian, Light/Dark, connected/disconnected, portrait/constrained-height matrix; Settings, Connection, Usage Statistics, Floating Monitor and Firmware Update screens were not supplied.
- **Candidate P2 semantic review:** in the disconnected state, the Home notification renderer falls through to the mint-green shield/check treatment because its warning predicate is conditioned on `connected` and disconnection itself is not an error predicate. On the supplied image this green success-like treatment accompanies “Device disconnected.” Review a neutral/informational connection-state treatment so color/icon semantics do not imply success. This is a review finding, not an approved new mapping.
- **Candidate P3 interaction review:** the locked display submenu explains that the device must be connected, but the overlay has no direct Connect action. Consider one explicit action that opens the existing Bluetooth connection flow, while retaining the single BLE owner and all session gates.
- **Accessibility review:** current Home and `JexFixedScalePage` override text scaling with `TextScaler.noScaling` to preserve the fixed 360-dp canvas. Evaluate an owner-approved accessible text/reflow mode that does not break the standard DPI/canvas contract; do not simply remove the scale override without a viewport and interaction regression plan.

## Whole-App visual and motion audit — owner direction — 2026-11-25

**Status: DISCUSSION PROPOSAL / STATIC SOURCE REVIEW ONLY.** The owner requested a whole-App UI refinement that avoids generic AI-generated styling and feels smoother with purposeful animation. This review does not change App source, tests, dependencies, native UI, workflow or release. Implementation requires a fresh explicit command in the separate Eksekusi Code! workspace; package delivery still requires Eksekusi Build App.

### Design direction

- Treat JE Cooler as a precision instrument interface for a real thermoelectric device: confident hierarchy, measured spacing, crisp typography, matte surfaces, restrained semantic color and clear physical/device state.
- Preserve JE X FYZ/Horizon identity, existing cooler artwork/aspect ratio/transparency, Phosphor icon family, current Home composition, 360-dp master canvas and the approved DPI compensation rules. Do not replace the app with a generic card dashboard or add neon gradients/glass/glow/shadows/badges by default.
- Consolidate existing visual decisions into one source of truth: semantic light/dark surfaces, text roles, spacing, corners, borders, focus/disabled/pending states and motion durations. Reuse shared components instead of styling every tab independently.
- Keep product-specific density, but improve the smallest labels and long EN/ID copy after actual 350-dp/420-dp screenshot review. Do not solve fit by shrinking text or touch areas. New/materially changed controls target 48 x 48 dp; do not shrink the documented compact Connection controls.

### Proposed motion language

- **Press/selection feedback:** approximately 100–140 ms; subtle scale/ink/tonal response, never a large bounce.
- **Control and state transition:** approximately 160–220 ms with one shared easing family; only reflect a confirmed device state. Pending command, ACK and telemetry-confirmed output remain visually distinct.
- **Tab content:** approximately 180–240 ms; short fade plus 4–8 dp directional movement, with stable tab keys and scroll state. Do not slide the entire Home canvas or animate every row independently.
- **Dialogs/sheets/routes:** approximately 220–300 ms; coherent fade/scale for dialogs and native sheet/page motion for navigation. Avoid a different flourish on every dialog.
- **Telemetry presentation:** preserve exact readings. Prefer a brief text cross-fade/highlight on a newly received value, not a fabricated rolling number or a value that appears to be real measurement between samples.
- **Hardware-correlated motion:** Fan rotor speed/coast must continue to follow confirmed Fan state and existing Voltage/PWM policy; LED preview must remain synchronized to Firmware LED phase; Peltier visuals must remain gated by confirmed state and keep their explicit presentation-only semantics. Stop/reset where required on disconnect/lifecycle loss.
- **Reduced motion:** explicitly respect platform animation-reduction preferences for custom looping motion. Replace non-essential movement with short fades or a static state; never make a repeating animation accelerate when animations are disabled.
- **Performance:** use implicit animation for simple property changes and explicit controllers only for phase/state-driven motion. Isolate the animated region, pass invariant subtrees through AnimatedBuilder.child, dispose controllers, pause unnecessary off-screen loops, and profile before optimizing.

### Source findings — initial static baseline (2026-11-25; superseded where noted below)

- `lib/main.dart` is about 11,434 lines and still combines Home/tab rendering, BLE/P1 session state, command lifecycle, telemetry and OTA coordination. `lib/floating_monitor.dart` is about 1,959 lines; `lib/app_settings.dart` about 1,904; `lib/usage_statistics.dart` about 3,650.
- **Resolved (2026-11-26):** the static `.glyph` constructor path was removed from `JexAnimatedIcon`; all 12 former call sites use `JexAnimatedGlyph`, so static glyphs no longer mount the seven-controller animated State. See the direct source verification below. No runtime performance gain has been measured.
- Battery, Hotside and Voltage animation permission remains true whenever BLE is connected, even when their displayed reading is unchanged. Consider changing these to event-driven value/warning transitions rather than perpetual sensor loops. Keep active Fan/Adaptive/Peltier and phase-synchronized LED motion only where it communicates actual hardware state.
- **Resolved structurally (2026-11-26):** the left/right arrows are now outside the phase-driven `AnimatedBuilder`, and its invariant mode label is supplied via `child`. Only the inner LED-column row is rebuilt for each phase frame. See the LED preview update below; no frame-time improvement is claimed without profiling.
- No AnimatedSwitcher, Hero or PageRouteBuilder transition system was found in the inspected Dart UI files. The five dashboard tabs replace keyed subtrees without a dedicated content transition; MaterialPageRoute/default platform transitions still exist, and two custom modal transition builders already use fade/scale.
- `main.dart` contains nine AnimatedContainer sites, one AnimatedOpacity, one TweenAnimationBuilder and two AnimatedBuilder sites; `usage_statistics.dart` already has custom animated charts. The app is not motionless, but motion is distributed rather than governed by one motion spec.
- **Implemented in the current CODE_FULL WP1 increment (2026-11-26):** Battery/Hotside/Voltage Home indicators no longer run autonomous idle loops. Their existing level and warning transition controllers remain active for real telemetry changes; other active-state indicators retain their existing loop policy. The reduced-motion gate still stops nonessential animation.
- `TextScaler.noScaling` is applied to Home and `JexFixedScalePage`, preserving the fixed-canvas contract but preventing user text-size scaling on those surfaces. A dedicated accessible reflow/text mode needs design and regression work; do not remove the scale override casually.
- **Implemented in the current CODE_FULL WP1 increment (2026-11-26):** disconnected Home Notification now uses a neutral information icon/grey semantic color and suppresses stale command-error styling while offline. The disconnected submenu lock panel offers a 48-dp Connect action wired to the existing `_showBluetoothMenu()` path; no second BLE client or scan owner is introduced.
- The Usage Statistics charts already animate the latest plotted value and cursor/timeline. Any refinement must preserve the raw 1-Hz record, session boundaries, explicit gaps, HOT-only P1 freshness, decimation, timestamp mapping and no interpolation across invalid gaps. Long-session performance remains a separate profile-first concern.
- Native Floating Monitor is rendered by `FloatingMonitorService.kt` custom Canvas/WindowManager rather than Flutter widgets. Its drag/resize/attach experience must be evaluated as a native surface, not assumed to inherit Flutter route/theme animation.


#### Direct source verification and static-glyph repair — 2026-11-26

The original finding below was confirmed against live source and corrected in the authorized `CODE_FULL` session. The patch is a source/lifecycle simplification; it does not change animated telemetry indicators or the visual contract.

- **Resolved:** all 12 production `JexAnimatedIcon.glyph` call sites in `lib/main.dart` now use the existing `JexAnimatedGlyph` stateless widget from `lib/jex_animated_glyph.dart`. The obsolete `.glyph` constructor, optional `glyph` state field and static-icon build branch were removed from `JexAnimatedIcon`. Static navigation/action/status fallback glyphs no longer mount `_JexAnimatedIconState` and therefore do not allocate its seven AnimationControllers.
- **Appearance contract preserved:** `JexAnimatedGlyph` retains the prior `RepaintBoundary(child: Icon(icon, size: size, color: color))` rendering. The removed `active`/`warning` arguments on the old static constructor were inert because the old build branch always returned a plain Icon; no gesture, BLE state, telemetry or indicator behavior was moved into the stateless widget.
- **Regression coverage:** `test/widget_test.dart` now requires the shared stateless import/use and rejects the obsolete constructor/state branch. A widget test pumps a `JexAnimatedGlyph` and asserts the actual Phosphor `IconData`, color, size and widget type. The existing separate custom animated indicator state/policy checks remain.
- **Follow-up lint repair:** the `animationIsActive` local in `_homeMetric()` became unused once the inert static-glyph arguments were removed. It was deleted; the remaining `animationActive` input continues to drive the animated indicator branch in its existing call sites. The one formatter correction reported in Validation Only #57 was applied, then Validation Only #58 confirmed the final source formatting is clean.
- **Commits:** source/test migration `ac8e9113ad947ff370b4f09aa57351ca41fdd58d`; unused-local/format correction `edf9a62cac12339e445dbb1fe86dbb0fc46ef3a9`.
- **Hosted validation:** Validation Only #58 / run `45660178142` / job `139367583668`, exact tested source `edf9a62cac12339e445dbb1fe86dbb0fc46ef3a9`, terminal SUCCESS. Flutter/Dart setup and locked dependency resolution passed; formatter scanned 19 files with 0 changes; `flutter analyze --no-fatal-infos` succeeded with 107 info-only diagnostics and zero warnings/errors; full Flutter suite **213/213 PASS**. No formatter auto-commit was needed.
- **Intermediate run:** Validation Only #57 / run `45659724890` is retained as a terminal failure on the preceding source. Its log exposed the now-unused `animationIsActive` local after the constructor removal; all 213 tests passed, but analyzer failed and the workflow correctly withheld its formatter-only commit. The source/lint issue and formatting were repaired before #58. Do not count #57 as a successful gate.
- **Evidence limit:** this is a static architecture/lifecycle correction backed by source diff and hosted tests. Runtime FPS, memory, frame scheduling and physical-device rendering were not measured. Whole-App visual acceptance remains **VISUAL NOT VERIFIED**.

#### LED preview rebuild isolation — 2026-11-26

- **Source:** commit `94cddc93ebee26b3edc35f4ae5e567b886a3ffe5` hoists both mode arrows outside the phase-driven `AnimatedBuilder` and supplies the static mode label through `AnimatedBuilder.child`. Its builder still computes LED levels/colours from the elapsed `Stopwatch` phase and creates the two LED columns. Formatter-only commit `2fab1f1313d22152fdafbc78131b07c3deae7fb7` applies the CI formatter output.
- **Synchronization preservation (STATIC SOURCE CHECK):** `ledPhaseMs` and `ledCycleMs` initialize the phase anchor; the clock remains monotonic while reduced motion stops frame scheduling. A changed `ledSyncRevision` resets the anchor. The current parser increments that revision when a full `LED_SYNC` snapshot is applied and when the compatibility `LED_CYCLE_MS` field updates the cycle. The preview continues to derive the current phase from the anchor plus elapsed time.
- **Regression/CI:** the LED widget test retains the static mode-label/arrow identity checks and adds numeric phase wraparound, `ledSyncRevision` anchor reset and reduced-motion clock-preservation coverage. Validation Only #67 / run `45696341946` / job `139494616397` is terminal SUCCESS on input source `538c0eb760f89cdcf6efb13e0bb4a906d941668e`; formatter post-check and analyzer passed, and Flutter tests passed **219/219**. The formatter-only commit `9cbb8d60fb889fc22640f05d507f63b6e3249968` is the corresponding post-format source commit.
- **Regression update (2026-11-26):** a pure millisecond phase helper now covers modulo wraparound, non-negative elapsed time and invalid cycle fallback. A source-contract regression verifies `ledSyncRevision` resets the anchor and elapsed origin while reduced-motion changes stop only frame scheduling. These tests do not prove Firmware snapshot timing or physical LED output. No runtime FPS, raster time, jank, CPU or memory profile was collected; the performance change remains source-structural only. Whole-App visual acceptance remains **VISUAL NOT VERIFIED**.
- **WP1 disposition — SOURCE/TEST/CI COMPLETE (2026-11-26):** Battery/Hotside/Voltage idle-loop feedback, disconnected Notification/Connect semantics, and LED numeric phase/re-anchor regression are implemented and passed Validation Only #67 (219/219). Usage Statistics long-session performance remains a separate profile-first item. Android visual/device and physical Firmware/BLE evidence remain unverified.

### Screen-by-screen implementation proposal

1. **Home:** retain the cooler-led composition and seven 45-dp metrics; refine typography/spacing, connection/safety semantics, notification state colors and safe margins; add a clear Connect action to the disconnected lock panel; animate state changes, not fabricated telemetry.
2. **Voltage / Control / Adaptive:** add a coherent tab indicator and content transition; unify control feedback and pending/confirmed/disabled styles; preserve every existing Voltage, Adaptive, Lock Voltage, Fan/Peltier interlock and firmware command gate.
3. **LED:** retain the firmware-phase-synchronized LED preview and color selection; optimize the animated subtree; animate selection/brightness feedback without extra decorative glow.
4. **Temperature:** make steppers, locked zones and value changes consistent with the shared control system; preserve all configured ranges and firmware-owned limits.
5. **Bluetooth Connection:** make permission, adapter, scan, discovery, connect, sync-ready and failure states easy to distinguish; animate only real scan/result/state changes; preserve passive Auto Connect, scan ownership and P1 readiness semantics.
6. **Settings and subpages:** use consistent section/list hierarchy, typography, icon alignment, focus/pressed feedback and route transitions; retain compact Settings theme, persisted keys, EN/ID behavior and current page order.
7. **Usage Statistics:** refine chart/summary hierarchy and cursor/selected-time transitions; retain exact data truth, event ordering, gap/session rules and SQLite schema/retention; profile long sessions before adding effects.
8. **Floating Monitor:** unify configuration UI with the App visual system while treating the native overlay separately; smooth drag/resize and attach/detach only if native profiling supports it; preserve one BLE owner and telemetry forwarding.
9. **Dialogs / sheets / Firmware Update:** adopt one transition language and clear progress/error hierarchy. Firmware progress must represent actual stages; this UI scope must not modify OTA transport, certificate policy, metadata, recovery or Firmware behavior.

### Acceptance and sequencing

- First create a stable visual/motion baseline and shared primitives; then fix high-value Home/lock/status semantics and tab/control transitions; then Settings/Connection; then Statistics/Floating Monitor/dialogs. Do not combine a visual rewrite, SDK upgrade and BLE/OTA refactor in one uncontrolled change.
- Add behavioral/widget tests for connected/disconnected/scanning/sync/pending/error/reduced-motion states, with stable keys and controller disposal. Add targeted golden/screenshot coverage with animations settled or disabled; use actual Android screenshots for final visual acceptance.
- Review at 350-dp and 420-dp, English and Indonesian, Light and Dark, connected/disconnected/error, normal and constrained portrait height, normal/enlarged text settings and reduced-motion settings. Retain real-device/OEM verification as a separate gate.
- Proposed visual outcome for the single supplied Home screenshot remains limited to that one state; whole-App outcome remains **VISUAL NOT VERIFIED** until the complete matrix is inspected.
- No new animation package is required by this proposal: Flutter already supplies implicit and explicit animation primitives. Prefer the framework over adding another dependency solely for motion.

## Usage Statistics alignment refinement — included in Build #163 — 2026-11-16

**Status: SOURCE INCLUDED IN BUILD #163 AND RETAINED IN BUILD #167 / VERIFIED CI / VISUAL NOT VERIFIED.** This refinement entered the package in Build #163 and remains part of the latest published Build #167. The design remains subject to screenshot-based visual acceptance.

- **Problem evidence:** supplied Android screenshots showed left-aligned Min/Avg/Max and selected-time readouts within equal columns, a Selected time heading/time pair that was not optically centered, Activity elapsed labels that did not share the chart plot gutters, and overly heavy discrete state bars.
- **Layout correction:** center the Usage Statistics AppBar title; center each Min/Avg/Max label/value pair; align Activity start/end labels with the same 34-dp left and 8-dp right plot insets used by temperature chart, timeline and shared cursor geometry.
- **Selected-time dock:** center the heading/time cluster independently from the trailing 48×48 dp close action, center all six values and labels in the existing two-row/three-column arrangement, and regularize vertical padding. Keep the dock in the bottom SafeArea and preserve its existing height limit.
- **Activity lanes:** render Voltage, Adaptive and Peltier state bars at 18 dp and vertically centered within the existing 34-dp gesture lane. The interaction/hit area remains 34 dp; Fan Speed remains its own 54-dp plot.
- **Protected invariants:** raw 1-Hz capture, SQLite schema/retention, recorder queue, event analytics, timestamp weighting, Hotside threshold semantics, session/P1 boundaries, authoritative telemetry, null gaps, decimation, interpolation rules, tap/drag timestamp mapping and six metric values remain unchanged.
- **Source/test lineage:** alignment implementation `b4b57e83261c0b1fcb7873efa8544c3410ad0208`; formatter-only follow-up `873a825020659dadcac2e5c7242e759209776414`. Validation Only #16 passed its 188-test baseline. Later Validation Only #19 passed the latest package source lineage with 197/197 tests; the subsequent compare to Build #163 shows only documentation/skill/status/checkpoint changes.
- **Original package evidence:** Build #163 / run `43679305537` / job `132706236782`, package source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`, terminal SUCCESS. Analyzer 118 infos / zero warnings-errors; Flutter 197/197; Android Gradle gate SUCCESS. This remains historical evidence for the original inclusion; Build #167 is the current package baseline at the top of this design note.
- **Visual outcome:** **VISUAL NOT VERIFIED.** CI/widget tests do not prove Android rendering. Actual Build #167 screenshots still need review at 350-dp/420-dp, EN/ID, Light/Dark, portrait/constrained height and selected-cursor states.


---
## PREVIOUS PACKAGE CHECKPOINT — Usage Statistics presentation included in Build #162 — 2026-11-13

This describes the Build #162 package baseline. The current main alignment refinement is documented at the top of this file; Build #162 itself remains unchanged.

- Use one compact session header for status, start date/time and the single primary elapsed duration. If multiple sessions exist, expose the selector inside this same header; dropdown options show session status and start time, not a second duration.
- Battery and Hotside remain independent measured temperature charts. Label the Y axis at every integer degree with 1°C spacing. Derive each plot range from valid observed temperature data, padded by one degree; do not include a distant Hotside limit in the scale. Increase plot height when a wider actual range needs more label rows. Keep the configured limit label, and draw its dashed reference only when it lies inside the plotted data range.
- Keep Min / Average / Max. Remove Observed, the More details disclosure and the Last sample footer from the visible dashboard. Retain four activity lanes: Voltage, Adaptive Mode, Peltier and Fan Speed, with one shared elapsed-time axis and cursor.
- Preserve secondary summaries and state durations in analytics even though the More details text block is removed. Do not discard data or weaken storage/analytics contracts to simplify presentation.
- Selected time remains a bottom SafeArea dock with six synchronized values in two rows of three columns. Keep the selected timestamp prominent, labels secondary, values tabular/bold, a compact surface and a 48-dp icon-only close action.
- Localize chart headings, metric labels, ON/OFF states and numeric temperatures. Indonesian decimal separator is comma; English is dot. Retain the JE theme, Phosphor icon family, compact 360-dp canvas and Light/Dark semantic colors.
- Preserve actual telemetry values, raw 1-Hz collection, SQLite schema/retention, recorder queue, session boundaries, HOT-based P1 freshness, invalid/null gaps, chart decimation and shared tap/drag cursor. Never interpolate across a gap or session.
- **Hosted regression evidence:** Build #162 passed **188/188 Flutter tests**; analyzer had 23 info-level diagnostics and zero warnings/errors; Android Gradle gate succeeded. The workflow has no Dart formatter step, so no formatter pass is claimed.
- **Visual outcome:** **VISUAL NOT VERIFIED** until actual Build #162 screenshots are reviewed at 350-dp/420-dp, portrait/constrained height, English/Indonesian and Light/Dark.

# JE X FYZ / JE Cooler — Approved Design Contract

This document stores owner-approved, screen-specific visual constraints, not a build history. Live App source determines current implementation. PRODUCT_DESIGN_CONSTITUTION.md defines cross-screen design principles; VISUAL_QUALITY_GATE.md defines evidence-based acceptance. CHANGELOG.md / APP_BUILD_REPORT.md retain dated validation evidence.

## Current published UI baseline — Build #167 — 2026-11-24

The latest published App package is Build #167 / Actions run `44510421466` / job `135512909555`, immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`. It includes the Home cooler artwork sizing correction below plus the previously approved UI refinements. Analyzer reported 107 info-level findings with zero warnings/errors; Flutter tests passed 205/205; Android Gradle completed `BUILD SUCCESSFUL` in 2m59s. Native Android App JUnit tasks were `NO-SOURCE`. Release ID `403010611` / tag `jexfyz-latest`, APK and corresponding source ZIP match the exact source; V1/V2/V3 and downloaded-asset checks passed. APK and source ZIP hashes and retained warnings are in `APP_NOTES.md` and `APP_BUILD_REPORT.md`. Actual Android screenshot/OEM acceptance remains **VISUAL NOT VERIFIED**.


## Product identity and supplied assets

- App name: JE Cooler. Brand/header: JE X FYZ.
- Preserve assets/jexfyzicon.png and assets/jexfyzcooler.png as transparent square 1:1 PNGs. Do not distort geometry, transparency or aspect ratio.
- The cooler image remains on the right within the established compact Horizon Cooler-inspired layout, with a dark header, white rounded content panel and compact mode navigation.
- Do not casually redesign the approved identity or replace assets with speculative alternatives.

### Home cooler artwork sizing — owner screenshot correction (2026-11-19)

- **Problem evidence:** the owner's Home screenshot shows the cooler product image visually undersized inside the available right-hand portion of the Home telemetry row.
- **Approved correction:** keep all seven telemetry indicators on the left and the cooler artwork on the right. Increase the image column from flex 13 to flex 14 and apply a **uniform 1.08× scale** anchored to `Alignment.centerRight`. This uses the existing inter-column/inner padding slack to grow the cooler without changing the row's seven 45-dp indicator heights.
- **Image integrity:** preserve `BoxFit.contain`, the centered-right alignment, the square 1:1 asset, transparency and full device silhouette. Do not use `BoxFit.cover`, non-uniform scaling, clipping or cropping to make it appear larger.
- **Protected layout:** retain the 360-dp master canvas and single DPI transform; preserve Home header, indicator icon tiles, metric typography semantics, notification slot, tab geometry, white rounded content panel, Light/Dark behavior and localization. Do not alter telemetry or Firmware/BLE state.
- **Regression contract:** `test/widget_test.dart` checks flex 14, uniform 1.08 scale, right alignment and `BoxFit.contain`; existing seven-row 45-dp invariant remains.
- **Acceptance:** compare actual App screenshots at 350-dp/420-dp, English/Indonesian, Light/Dark and portrait/constrained-height states. Verify the larger cooler remains fully visible, does not obscure the longest metric labels or NOTIFY, keeps safe margins and looks balanced against the telemetry column. Until actual Android screenshots are reviewed, status remains **VISUAL NOT VERIFIED**.


## Approved grille / manufacturable visual

- White, symmetrical geometric grille; central purple X monogram; four corner mounting holes.
- Outer silhouette is square 1:1 and symmetrical; preserve the approved interior pattern and frame.
- When continuing the approved edit, remove only the two small protrusions at the midpoint of the left/right outer sides. Do not invent holes, ribs, borders or extra pattern pieces.
- Flat 2D and print-ready: no shadows, bevels, faux depth, gradients or texture.
- HZ monogram was rejected; keep X.

## Settings and modal sizing

- Settings root, all subpages, Bluetooth Connection sheet and designated modal surfaces use the same 360-dp master-canvas scaling model as Home.
- **Master-canvas validated/released in Build #129:** implementation uses `scale = constraints.maxWidth / 360.0`, fixed logical child width 360 dp, `designHeight = constraints.maxHeight / scale`, and converts safe-area/inset values through the scale. An outer `OverflowBox` preserves the logical child before a single `Transform.scale`, with clipping at viewport boundaries.
- **Compact UI pass validated/released in Build #131:** Settings root/subpages and Connection sheet use compact-only typography, glyph and spacing values while preserving the same 360-dp master canvas, DPI formula, inherited Light/Dark theme colors, localization, status colors and BLE behavior. The root rows use compact title/summary typography and reduced icon/spacing; Connection uses the compact header/status/message styles. Existing interactive targets remain within the approved 40–42 dp legacy constraint for this sheet.
- **Automated regression evidence:** the hosted Build #131 Flutter suite passed 142/142. Coverage includes the 360-dp density canvas contract, compact-theme rendering at 350-dp/420-dp logical widths with inherited palette checks, scan-state mapping and source/layout regression contracts. This establishes test-suite behavior; it does not establish physical display/OEM visual quality.
- Compact Theme remains opt-in (`compactUi: true`) on Settings root, Language/Appearance/Notifications/Bluetooth/Floating Settings subpages and the Connection sheet. Other fixed-canvas dialogs remain unchanged. Do not add a second transform or compromise the master canvas.
- Do not change Home geometry, the 360-dp master canvas, `scale = width / 360`, safe-area/inset conversion, localization, status colors, BLE P1 behavior or Firmware behavior without a separately authorized scope.
- **Physical visual status:** screenshot review and Android/OEM validation at 350-dp/420-dp remain NOT VERIFIED. Build #167 is the latest verified package. Build #163 remains the historical package checkpoint for the original four App UI refinements from `a5d4586`; later About, Statistics, Floating Monitor and Home cooler sizing corrections are included in the newer package. Actual visual acceptance still requires owner-side installation and screenshots.

### Peltier safety dialog and LED Color Picker — compact refinement and 60-color palette (2026-11-11)

**Historical baseline:** this earlier compact Peltier AlertDialog and the 60-color LED picker were subsequently included in Build #151. The Peltier surface was later replaced by the custom prerequisite card documented below; do not treat this historical geometry as the current Peltier design. The LED picker remains part of the established App contract.

- **Protected layout contract:** both overlays remain inside the existing `JexFixedScalePage`. Preserve the 360-dp logical canvas, single `constraints.maxWidth / 360` transform, safe-area/inset handling and surrounding Home geometry. No global scale or second transform was introduced.
- **Peltier safety dialog:** outer max width remains 340 dp; the fixed-canvas page keeps its 16-dp side padding and AlertDialog horizontal inset is reduced to 8 dp, giving an effective target width of approximately 312 dp on the 360-dp canvas. Vertical inset is 8 dp. Title/body/actions are 18/14/14 dp; title/content/actions padding is 16/12/16/4, 16/0/16/4 and 8/2/8/6 dp respectively. The dialog uses natural localized content height rather than a fixed height, keeping it short without clipping longer strings. Cancel/Fan action minimum targets remain 72×48 / 128×48 dp. Copy is shortened in English and Indonesian. Fan-before-Peltier confirmation and ACK ordering remain unchanged.
- **LED Color Picker:** palette now contains exactly 60 unique RGB presets, ordered by hue families. The six-column internal-scroll grid remains unchanged; each cell remains 48×48 dp and swatch artwork remains 32×32 dp. Panel max width remains 312 dp and max height remains `min(308 dp, 82% of available safe-area height)`. Selected preview, localized color name, tooltip/semantics, white outline, Cancel and explicit Select/commit behavior are preserved.
- **Naming contract:** each preset has one unique localization key with both English and Indonesian values. The selected preview, swatch tooltip and semantics resolve the same localized name. Standard exact HEX matches use established names (for example Orange Red `#FF4500`, Tomato `#FF6347`, Gold `#FFD700`, Chartreuse `#7FFF00`, Deep Pink `#FF1493`, Turquoise `#40E0D0`, Hot Pink `#FF69B4`). Descriptive labels are used for curated shades without an exact CSS named-color match. Previously stored legacy RGB aliases remain available; no black/OFF swatch was added. Reference: [MDN CSS named colors](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/named-color).
- **Regression coverage source:** `test/widget_test.dart` checks compact Peltier typography/insets/padding, retained 48-dp action heights, concise bilingual safety copy and fan-before-Peltier command ordering; for the picker it checks 60 unique HEX/name keys, unique English/Indonesian labels, representative exact name-to-HEX mappings, final white, six-column scrolling, 48-dp cells and 32-dp swatches. Follow-up review corrected older assertions that still expected 36 colors, the old first swatch and the prior `#A85D32` label; test cleanup is committed as `b24848222c0a90f213dd6017571e13857138d4f9`. Test source is updated but no Flutter test has been run.
- **Protected behavior:** no BLE/P1, RGB protocol, color storage format, LED mode gating, theme system, Home geometry, Settings, Firmware, sensor, or safety predicate was changed. Selected color remains staged until explicit Select; Cancel still discards the draft.
- - **Post-commit recovery audit (2026-11-11):** compared the new 60-entry preset array against the Build #149 baseline and confirmed all 36 original HEX values are retained; the 24 additions have no duplicate HEX. All 60 preset keys, English labels and Indonesian labels are unique and non-empty; every preset has both translations. The latest regression source no longer contains stale 36-entry expectations or the old first-color assertion. This is static GitHub source/read-back evidence, not Flutter test execution.

**Required visual acceptance:** capture actual app screenshots at 350-dp/420-dp, portrait and constrained height, English/Indonesian and Light/Dark. Verify Peltier copy wrapping, card width/height, button alignment and touch targets; for the picker verify all 60 swatches, scroll to the final rows, localized preview/tooltips, white selection, Cancel and Select. Until those screenshots are reviewed, outcome remains VISUAL NOT VERIFIED.
- **Authorization:** implemented only within the owner's `Eksekusi Full!` App source/test/documentation scope. A new APK still requires a separate `Eksekusi Build App!`. No Firmware, BIN, Firebase, OTA, flashing or physical device operation occurred.

## Usage Statistics — original Build #153 baseline; current presentation included in Build #163 (2026-11-16)

**Status: CURRENT PRESENTATION INCLUDED IN BUILD #163 / 197 OF 197 FLUTTER TESTS PASSED / VISUAL NOT VERIFIED.** Build #153 remains the original implementation baseline only; Build #163 packages the current presentation source and regression suite.

- **Six metric diagrams:** Phone Battery °C and Hotside °C remain separate measured temperature plots; Voltage (5V/9V/12V), Adaptive ON/OFF, Peltier ON/OFF and Fan Speed 0–100% remain four operating timelines, each with its own scale and semantics.
- **Shared inspection:** one elapsed-session cursor synchronizes Battery, Hotside, Voltage, Adaptive, Peltier and Fan Speed. Preserve the selected time and unknown/gap values as `--`.
- **Telemetry and continuity:** Peltier baseline is sourced from completed P1 full sync; later changes require authoritative PELTIER telemetry, not command ACK. Session coverage is bounded by fresh HOT heartbeat. Invalid sensor readings and session boundaries remain visible gaps; do not interpolate across gaps.
- **Historical Build #153 presentation baseline:** graph-first composition with compact session metadata/cursor, visible Observed coverage, last-sample metadata and collapsed details. The current Build #163 presentation supersedes those visible Observed / More details / Last sample elements while retaining secondary aggregates in analytics; see the current contract at the top of this file.
- **Capture/storage invariant:** one-second raw collection and explicit gap samples remain. SQLite schema/version 2 and retention remain. Current-main sample + session-freshness updates are transactional. The write queue uses 64 normal + 8 reserved control + 1 critical `endSession` slot (73 maximum), with fail-fast admission. Accepted operations remain FIFO; overflow submissions are rejected and surfaced through a persistent localized warning rather than being silently accepted or evicting accepted work.
- **Current-main analytics path:** grouped session/metric event index; event identity de-duplication and sorted merge; one summary per live flush; skip per-metric sort when already chronological; binary-search cursor lookup; cached decimated chart points. One selected-session summary/chart-decimation pass still occurs each second. Long-session CPU/memory and queue-backlog soak remain NOT RUN.
- **Current-main regression source:** selected dock height ≤200 dp plus clear behavior; narrow-range y-axis precision; 12k-per-sensor synthetic long-history with bounded chart rendering; queue capacity/FIFO/rejection; one-summary-per-batch, event identity and ordered merge. Build #163 ran the current 197-test suite successfully (197/197). Formatter is not part of the Build App workflow; Validation Only #19 has the separate formatter evidence. Physical Android rendering and screenshots remain NOT VERIFIED.
- **Visual acceptance:** **VISUAL NOT VERIFIED** until actual App screenshots are reviewed at 350-dp/420-dp, Light/Dark, English/Indonesian, portrait/constrained height, and representative active/completed/no-data/gap/long-session states.


### Selected-time detail dock — owner screenshot defect (fixed in current main source)

**Status: IMPLEMENTED AND INCLUDED IN BUILD #163 / HOSTED TEST GATES PASSED / VISUAL NOT VERIFIED.** The owner screenshot showed the selected-time surface expanding to nearly the entire viewport after chart interaction.

- **Correction:** outer readout Column now uses `mainAxisSize: MainAxisSize.min`; the dock remains in `Scaffold.bottomNavigationBar` and retains SafeArea, six metrics, selected elapsed time and 48×48 dp Clear action.
- **Regression:** current widget test asserts that the selected dock measures no more than 200 dp at normal text scale and disappears after Clear.
- **Evidence:** Build #163 packages this fix and its Flutter regression; the hosted suite passed 197/197. Actual Android visual acceptance remains **VISUAL NOT VERIFIED** pending owner screenshots.



### Usage Statistics density and performance follow-up — current main

- Temperature chart height is 160 dp (reduced from 170 dp); y-axis and elapsed-time painter labels use 10 dp. Y-axis tick precision follows tick spacing so narrow temperature ranges do not repeat the same rounded label. Battery/Hotside and Hotside/Activity section gaps are 18 dp. The visible summary is Min/Avg/Max only; the Observed row, More details disclosure and Last sample footer remain removed. The Hotside limit and four activity timelines remain, while observed-duration aggregates are retained for analytics.
- Current live analytics uses one session/metric event index, event identity set, ordered merge and a single summary per one-second live batch. Event groups are sorted only when not already chronological. Decimated chart points are cached in the summary; cursor lookup uses binary search.
- SQLite schema/version 2 and retention stay unchanged. Temperature sample insert + matching freshness update are one transaction. The writer uses 64 normal + 8 reserved + 1 critical endSession slot; producers do not wait for admission, overflow is rejected and shown as a persistent recording warning, and accepted work remains FIFO. Raw 1-Hz samples, explicit null gaps and HOT-only P1 coverage remain.
- **Performance boundary:** current implementation still performs one full selected-session summary and chart-decimation pass per one-second refresh. This is a linear indexed pass rather than the earlier repeated filtering/sorting and per-update summarization. A long-duration Android CPU/memory soak has not been performed.
- **Status:** Current presentation is retained in Build #167 (`0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`); the Build #167 Flutter suite passed 205/205 tests. Long-duration Android CPU/memory soak and screenshot-based visual acceptance remain **NOT VERIFIED**.


### Peltier safety popup — implemented in Build #153

- The Fan-OFF → user requests Peltier-ON path now uses a custom JE Cooler amber prerequisite card inside the existing `showGeneralDialog` / fixed-canvas route; it no longer uses the stock AlertDialog composition.
- The card explains the airflow prerequisite and shows the Fan ON → Peltier ON sequence. Its paired primary CTA names both outputs; Cancel remains a no-command action.
- Preserve the ordered transaction `FAN:ON` → wait for successful ACK → `PELTIER:ON`. If Fan confirmation fails or the widget is no longer mounted, do not send the Peltier command. Keep timeout/error handling and bilingual copy.
- Amber indicates the missing Fan prerequisite; do not conflate it with red thermal/NTC fault or latch states. The visual redesign does not alter Firmware safety policy or BLE command semantics.
- **Evidence:** source/test is included in Build #153 and hosted CI passed. Actual light/dark rendering, localized wrapping and touch-target screenshots remain **VISUAL NOT VERIFIED**.

### Build #153 baseline — Lock Voltage, About and Device Diagnostics (historical package behavior)

- Build #153 included the Firmware-owned Lock Voltage card, About/Tentang contributor page and Device Diagnostics snapshot. The released APK remains immutable at source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`.
- **Lock Voltage contract:** centered blur/lock treatment on Voltage and Adaptive only when Firmware lock state is known and ON. Bluetooth-disconnected remains highest priority; existing Adaptive restrictions are preserved. Pending handoff copy must not claim 5V until actual VOLTAGE telemetry confirms it. Lock state, busy, NVS save-failure and retry semantics remain Firmware-owned.
- **About / Tentang:** appears immediately after Firmware. Preserve bilingual credits and exact handles: Horizon (@horizontalzzz), FYZ (@FYZ737), Logos (@Logos3dMichael). Do not invent profile URLs or contributions beyond approved role labels.
- **Device Diagnostics:** this page existed in Build #153 as a source-backed opening-time snapshot with manual redacted copy. It was subsequently removed from current main by the owner's 2026-11-12 request; it must not be reintroduced without a new request.
- **Evidence:** the above describes Build #153 package behavior only. Current main has subsequent Settings changes documented below.

### Settings follow-up — compact Lock Voltage, remove Device Diagnostics, box About (source after Build #153)

- **Owner screenshot issue:** Lock Voltage card was taller than adjacent Settings rows; About appeared as a bare row outside a card. Owner also explicitly requested that Device Diagnostics be removed.
- **Lock Voltage card:** retain its first position below AppBar, existing ThemeData/card surface, Firmware-owned state model and tap behavior. Reduce the lock icon tile to 34×34 dp, tighten card padding to 11×7 dp, title/support copy to 12.5/10.5 dp and status strings to concise bilingual forms; use at most two lines. Do not reduce switch or retry targets, change Firmware authority, or alter Lock Voltage protocol behavior.
- **About:** wrap the existing About row in its own single-row Card (no duplicate section heading) immediately below the Firmware card. Keep the existing credits and About page unchanged.
- **Device Diagnostics:** remove the Settings menu row, `DeviceDiagnosticsPage`, the SettingsPage diagnostic-only constructor/state inputs, Home-to-Settings diagnostic snapshot plumbing, localization labels and the Diagnostics-specific widget test. Do not remove telemetry/state used by Home, Usage Statistics or other existing controls.
- **Other Settings:** preserve General, Device (Bluetooth and Floating Monitor), Statistics (Usage Statistics), Firmware Update, order, compact theme, 360-dp canvas/DPI formula, safe areas, localization and Light/Dark roles. Section-label vertical spacing is slightly tightened; row tap geometry is retained.
- **Acceptance:** Settings at 350-dp/420-dp; portrait and constrained height; EN/ID; Light/Dark; disconnected/unknown and connected Lock Voltage states including save-failure/retry. Verify About is visibly inside a card, and no Diagnostics item/page remains. Source-only evidence is not a visual pass.
- **Status after source update:** STATIC SOURCE CHECK / GitHub read-back; tests/analyzer/build and actual Android screenshots not yet run. VISUAL NOT VERIFIED.



### Professional Settings and About content — implemented on current main (2026-11-12)

**Status: SOURCE IMPLEMENTED / TEST SOURCE UPDATED / VALIDATION BLOCKED / VISUAL NOT VERIFIED.** Keep the interface concise and functional; do not add decorative containers or a new design system.

- **Settings rows:** maintain the existing General, Device, Statistics and Firmware grouped Cards, section order, theme, Phosphor family, compact ThemeData and 360-dp canvas. Each actionable setting uses a single horizontal row: icon, left-aligned title, optional right-aligned current value and chevron. Use the existing 13-dp title / 11-dp value typography, single-line ellipsis and a minimum 48-dp row height. Keep values only when they aid a decision: selected Language/Appearance, Bluetooth Auto/Manual, Floating Monitor ON/OFF and a known Firmware version. Do not show a notification count, duplicate Usage Statistics description, About subtitle or unknown `V?` Firmware placeholder.
- **Lock Voltage:** preserve its top-of-Settings position, static 34-dp neutral lock tile, Firmware-owned notifier and fixed card geometry. The row stays one line for saved ON/OFF; do not render a subtitle for synchronized, unknown or save-failure states. The Switch remains visible for known state while busy (disabled during the request), and its ON/OFF animation follows the authoritative P1 `VOLTAGE_LOCK` state only. Preserve the neutral icon, Bluetooth/info tooltip for unavailable/unknown state and icon-only retry + tooltip when NVS saving fails. Do not add any persistent status copy under the title or weaken synchronization/save/retry semantics.
- **About:** keep a standalone one-row Settings Card beneath Firmware, without a redundant JE Cooler subtitle. On the About page replace the internal `JE Cooler` heading with `Special Thanks` / `Ucapan Terima Kasih` according to App language. Stretch the existing credit-card Column so all three `_credit` blocks use the same full width and left edge; retain one simple Card. Use the role `App Developer & Builder` / `Pengembang Aplikasi & Perakit` for Horizon / `@horizontalzzz`; retain Design Inspiration / Inspirasi Desain for FYZ / `@FYZ737`; retain 3D Design & Printing / Desain & Pencetakan 3D for Logos / `@Logos3dMichael`.
- **Guardrails:** do not add extra nested cards, gradients, glow, badges, ornamental icons, decorative animation or a parallel palette/type scale. Do not change Home geometry, BLE/P1, Firmware, notifications persistence, usage statistics data, theme behavior or the 360-dp DPI transform. Keep row tap targets and the existing 48-dp Lock Voltage switch/retry interactions usable.
- **Acceptance:** verify row/value alignment and long localized titles at 350-dp/420-dp, English/Indonesian, Light/Dark, and accessible text settings supported by the existing canvas. Check Lock Voltage disconnected/unknown, Firmware unsupported, active-unsaved, active-saved and saved-OFF states. Check About role/name/handle wrapping. Flutter tests and actual Android screenshots are still required before acceptance.



### Owner screenshot corrections — Lock Voltage row and About credits (2026-11-13)

- Lock Voltage is a single-line control: no visible subtitle or state-driven card resizing. Keep its static neutral lock tile and card surface unchanged. Keep the Switch visible through busy state, disabled while busy, and let only its native thumb/track animate when authoritative P1 state changes. Unknown/not-ready explanation and unsaved retry remain tooltip/icon affordances, not permanent copy.
- About heading is `Special Thanks` (EN) / `Ucapan Terima Kasih` (ID), not `JE Cooler`. The credit parent Column must stretch children to full width so all three role/name/handle blocks align at the same left inset. Horizon's role is `App Developer & Builder` / `Pengembang Aplikasi & Perakit`; preserve FYZ and Logos roles and all three exact handles.
- Preserve the single credit Card, theme, localization, safe areas and existing Settings/360-dp canvas. Do not add decorative containers or change the app's JE Cooler identity.

## Whole-App visual refinement — owner-approved direction, Phase 1 in Build #153

**Status: PHASE 1 SOURCE INCLUDED IN BUILD #153 / VERIFIED CI / VISUAL NOT VERIFIED.** The owner approved the complete refinement direction. Implementation preserves the established JE X FYZ identity, Home composition, 360-dp canvas and semantic theme rather than introducing a second visual system.

- **Design system:** reuse existing ThemeData, semantic Light/Dark roles, Roboto and compact Settings textTheme. Phosphor is the primary icon family across App surfaces; use justified system exceptions rather than mechanical substitution.
- **Hierarchy and density:** prioritize primary state/readings, reduce redundant cards, duplicate labels and explanatory prose, and retain readable type/touch targets. Do not shrink text or controls merely to fit content.
- **Color and states:** preserve established metric/status mapping, Light/Dark behavior, warning/fault/disabled/unknown distinction and non-color cues. Physical state remains telemetry-authoritative.
- **Motion and feedback:** use motion only for real state/progress/affordance; keep it restrained, interruptible and lifecycle-safe. Avoid ambient animation and cosmetic states that imply device activity.
- **Home:** preserve approved Home composition and 360-dp geometry. Build #153 retains the 44-dp NOTIFY region and readable 10.5/9.5-dp text with two-line ellipsis; screenshot review must confirm real translated content.
- **Not a global redesign:** this phase did not introduce a new font, parallel palette, global scale transform or wholesale Home/theme rewrite. Additional shared spacing/motion refinements should be driven by actual screenshot findings and separately scoped.
- **Acceptance matrix:** real App screenshots at 350-dp/420-dp, portrait/constrained height, English/Indonesian, Light/Dark, connected/disconnected/unknown/safety states, plus Statistics short/long and one/multiple sessions. Keep BLE P1, telemetry truth, safety, persistence and Firmware contracts unchanged.
- **Visual result remains VISUAL NOT VERIFIED:** passing analyzer/Flutter tests/Build #153 does not prove actual Android/OEM visual quality.



### Peltier safety dialog — fixed compact follow-up (included in Build #163)

- **Owner placement correction (2026-11-13):** the panel must sit at the bottom rather than the center of the screen. Apply bottom-center alignment within `SafeArea`; preserve the current card geometry and the safe-area inset so it remains above Android's gesture/navigation area. This is a position-only update, not a redesign.

- **Problem/reference:** owner screenshot showed a draggable/scrollable oversized popup and dialog text with anomalous inherited-looking underlines/face. Scope is only the Fan-OFF → Peltier-ON prerequisite dialog.
- **Fixed geometry:** preserve `JexFixedScalePage`, one existing 360-dp transform and safe-area behavior. The owner later superseded the original centered placement: anchor the panel at `Alignment.bottomCenter` inside the existing `SafeArea`, with the existing 10-dp vertical breathing margin and 16-dp horizontal margin. Keep 296-dp max width, 20-dp radius and compact internal spacing. Remove `SingleChildScrollView` so the card cannot be dragged/scroll-shifted; remove the entrance SlideTransition while retaining restrained fade/scale. No second transform or global scaling change.
- **Typography:** explicitly use the existing ThemeData Roboto family and `TextDecoration.none` for raw dialog copy; title 15–15.5 dp, body 11.5–12.5 dp, step labels 10.5 dp. Keep adequate line-height and test the longest EN/ID strings. These are modal-only compact values, not new global text tokens.
- **Actions and safety:** preserve 48-dp primary and Cancel targets, amber fan-prerequisite meaning, barrier/Cancel no-command behavior, and exact FAN:ON → successful ACK → PELTIER:ON order. Do not modify BLE/P1, Firmware, telemetry authority, or thermal/NTC behavior.
- **Temperature tab:** remove the global Reset Temperature Settings control and its App handler/label. Keep Hotside limit and battery 5V/12V zone controls unchanged; leave generic command acknowledgement classification untouched.
- **Acceptance:** 350-dp/420-dp fixed-canvas behavior; portrait and constrained height; EN/ID longest strings; Light/Dark; Fan OFF and Cancel/approve/fan-ACK-failure. Build #163 hosted Flutter suite passed 197/197. Capture actual Android screenshots before marking visual acceptance; current result remains VISUAL NOT VERIFIED.
- **Current implementation:** source and regression contract are included in Build #163; `test/widget_test.dart` requires bottom-center `Align` and preserves Fan-ACK-before-Peltier ordering. Build #163 analyzer, Flutter 197/197 and Android Gradle gates passed. The Build App workflow has no formatter gate; Validation Only #19 separately verifies formatting. Visual acceptance remains NOT VERIFIED.

### Home display-menu tabs — shorter visual pills and clean separator (owner screenshot, 2026-11-13)

- **Observed issue:** the five Home display-menu tabs have the correct equal widths, but their visible pill shapes are too tall. A thin grey horizontal Divider directly below the row adds an unnecessary visual boundary before the submenu content.
- **Tab geometry:** preserve the existing five-way Expanded width distribution, horizontal canvas padding (8 dp), per-tab horizontal inset (2 dp), tab order/labels, 12-dp corner radius, colors, border treatment and 9-dp text/weight. Set the visible pill to **38 dp high**, vertically centered within the existing **48-dp tab row**.
- **Touch target:** keep the entire tab's InkWell hit area at least **48 dp high**. The visible pill alone is shortened; do not reduce the tap target or tab width. Use a full-size interactive child (for example, SizedBox.expand) and center the 38-dp pill inside it.
- **Divider cleanup:** remove the Padding + Divider(thickness: 1, height: 1) between the tab row and submenu. Replace its total 8-dp vertical footprint (1-dp Divider + following 7-dp gap) with one SizedBox(height: 8). This removes the line without moving the submenu content or changing the overall Home geometry.
- **Protected geometry:** retain the 11-dp top inset above the tab row, 48-dp row height, existing 360-dp master canvas/DPI scale, Home area height, rounded white content panel, notification layout, submenu padding, and all Home metrics/image.
- **Acceptance:** same tab widths and order at 350-dp/420-dp; visible pill 38 dp; interactive bounds 48 dp; no divider line; existing 8-dp gap retained; selection/tap behavior and disconnected/Adaptive/Lock Voltage overlays unchanged; EN/ID and Light/Dark; actual Android screenshot review required.
- **Status:** INCLUDED IN BUILD #162 / 188 OF 188 FLUTTER TESTS PASSED. `test/widget_test.dart` includes 38-dp pill / 48-dp row / no-divider / 8-dp spacer source contracts. Actual Android/OEM screenshots remain NOT VERIFIED.

