# JE X FYZ / JE Cooler — Approved Design Contract

This document stores owner-approved, screen-specific visual constraints, not a build history. Live App source determines current implementation. PRODUCT_DESIGN_CONSTITUTION.md defines cross-screen design principles; VISUAL_QUALITY_GATE.md defines evidence-based acceptance. CHANGELOG.md / APP_BUILD_REPORT.md retain dated validation evidence.

## Product identity and supplied assets

- App name: JE Cooler. Brand/header: JE X FYZ.
- Preserve assets/jexfyzicon.png and assets/jexfyzcooler.png as transparent square 1:1 PNGs. Do not distort geometry, transparency or aspect ratio.
- The cooler image remains on the right within the established compact Horizon Cooler-inspired layout, with a dark header, white rounded content panel and compact mode navigation.
- Do not casually redesign the approved identity or replace assets with speculative alternatives.

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
- **Physical visual status:** screenshot review and Android/OEM validation at 350-dp/420-dp remain NOT VERIFIED. Validate the actual installed Build #149; hosted widget tests are not visual acceptance.

### Peltier safety dialog and LED Color Picker — compact refinement and 60-color palette (2026-11-11)

**Status: SOURCE IMPLEMENTED on current main / NOT YET RELEASED / VISUAL NOT VERIFIED.** The source/test changes are newer than Build #149 and are not included in its APK. Local Flutter/Dart formatter, focused tests, analyzer and full suite are BLOCKED / NOT RUN because Flutter and Dart are absent from the active container. No hosted CI or device capture has been run for this refinement.

- **Protected layout contract:** both overlays remain inside the existing `JexFixedScalePage`. Preserve the 360-dp logical canvas, single `constraints.maxWidth / 360` transform, safe-area/inset handling and surrounding Home geometry. No global scale or second transform was introduced.
- **Peltier safety dialog:** outer max width remains 340 dp; the fixed-canvas page keeps its 16-dp side padding and AlertDialog horizontal inset is reduced to 8 dp, giving an effective target width of approximately 312 dp on the 360-dp canvas. Vertical inset is 8 dp. Title/body/actions are 18/14/14 dp; title/content/actions padding is 16/12/16/4, 16/0/16/4 and 8/2/8/6 dp respectively. The dialog uses natural localized content height rather than a fixed height, keeping it short without clipping longer strings. Cancel/Fan action minimum targets remain 72×48 / 128×48 dp. Copy is shortened in English and Indonesian. Fan-before-Peltier confirmation and ACK ordering remain unchanged.
- **LED Color Picker:** palette now contains exactly 60 unique RGB presets, ordered by hue families. The six-column internal-scroll grid remains unchanged; each cell remains 48×48 dp and swatch artwork remains 32×32 dp. Panel max width remains 312 dp and max height remains `min(308 dp, 82% of available safe-area height)`. Selected preview, localized color name, tooltip/semantics, white outline, Cancel and explicit Select/commit behavior are preserved.
- **Naming contract:** each preset has one unique localization key with both English and Indonesian values. The selected preview, swatch tooltip and semantics resolve the same localized name. Standard exact HEX matches use established names (for example Orange Red `#FF4500`, Tomato `#FF6347`, Gold `#FFD700`, Chartreuse `#7FFF00`, Deep Pink `#FF1493`, Turquoise `#40E0D0`, Hot Pink `#FF69B4`). Descriptive labels are used for curated shades without an exact CSS named-color match. Previously stored legacy RGB aliases remain available; no black/OFF swatch was added. Reference: [MDN CSS named colors](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/named-color).
- **Regression coverage source:** `test/widget_test.dart` checks compact Peltier typography/insets/padding, retained 48-dp action heights, concise bilingual safety copy and fan-before-Peltier command ordering; for the picker it checks 60 unique HEX/name keys, unique English/Indonesian labels, representative exact name-to-HEX mappings, final white, six-column scrolling, 48-dp cells and 32-dp swatches. Follow-up review corrected older assertions that still expected 36 colors, the old first swatch and the prior `#A85D32` label; test cleanup is committed as `b24848222c0a90f213dd6017571e13857138d4f9`. Test source is updated but no Flutter test has been run.
- **Protected behavior:** no BLE/P1, RGB protocol, color storage format, LED mode gating, theme system, Home geometry, Settings, Firmware, sensor, or safety predicate was changed. Selected color remains staged until explicit Select; Cancel still discards the draft.
- - **Post-commit recovery audit (2026-11-11):** compared the new 60-entry preset array against the Build #149 baseline and confirmed all 36 original HEX values are retained; the 24 additions have no duplicate HEX. All 60 preset keys, English labels and Indonesian labels are unique and non-empty; every preset has both translations. The latest regression source no longer contains stale 36-entry expectations or the old first-color assertion. This is static GitHub source/read-back evidence, not Flutter test execution.

**Required visual acceptance:** capture actual app screenshots at 350-dp/420-dp, portrait and constrained height, English/Indonesian and Light/Dark. Verify Peltier copy wrapping, card width/height, button alignment and touch targets; for the picker verify all 60 swatches, scroll to the final rows, localized preview/tooltips, white selection, Cancel and Select. Until those screenshots are reviewed, outcome remains VISUAL NOT VERIFIED.
- **Authorization:** implemented only within the owner's `Eksekusi Full!` App source/test/documentation scope. A new APK still requires a separate `Eksekusi Build App!`. No Firmware, BIN, Firebase, OTA, flashing or physical device operation occurred.

## Usage Statistics — implemented and included in Build #153 (2026-11-12)

**Status: SOURCE INCLUDED IN BUILD #153 / VERIFIED CI / VISUAL NOT VERIFIED.** The hosted Build #153 Flutter suite passed 176/176 tests at immutable source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. Actual Android/OEM screenshots are still required before a visual pass.

- **Six metric diagrams:** Phone Battery °C and Hotside °C remain separate measured temperature plots; Voltage (5V/9V/12V), Adaptive ON/OFF, Peltier ON/OFF and Fan Speed 0–100% remain four operating timelines, each with its own scale and semantics.
- **Shared inspection:** one elapsed-session cursor synchronizes Battery, Hotside, Voltage, Adaptive, Peltier and Fan Speed. Preserve the selected time and unknown/gap values as `--`.
- **Telemetry and continuity:** Peltier baseline is sourced from completed P1 full sync; later changes require authoritative PELTIER telemetry, not command ACK. Session coverage is bounded by fresh HOT heartbeat. Invalid sensor readings and session boundaries remain visible gaps; do not interpolate across gaps.
- **Presentation:** graph-first composition; compact session metadata and cursor; concise last-sample metadata; detailed sampling/storage provenance behind an information affordance; secondary operating durations and Fan aggregates in collapsed details. Keep Min/Avg/Max, Observed coverage and the Hotside limit visible without discarding the useful aggregates.
- **Capture/storage invariant:** this visual pass does not change one-second collection, raw observations, recorder behavior, SQLite schema, retention, analytics or persistence.
- **Open performance risks:** live batches still recompute the selected-session analytics summary; serialized SQLite writes remain unbounded/unbatched. Long-session CPU/memory, queue backpressure and animation lifecycle/60–120-Hz stress remain unverified. Ordinary CI does not establish long-session soak performance.
- **Regression evidence:** Build #153 hosted Flutter suite passed 176/176, including the current Statistics cursor/detail/provenance contracts. No local formatter, focused test, analyzer or Android rendering was run in this Diskusi.
- **Visual acceptance:** **VISUAL NOT VERIFIED** until actual App screenshots are reviewed at 350-dp/420-dp, Light/Dark, English/Indonesian, portrait/constrained height, and representative active/completed/no-data/gap/long-session states.

### Peltier safety popup — implemented in Build #153

- The Fan-OFF → user requests Peltier-ON path now uses a custom JE Cooler amber prerequisite card inside the existing `showGeneralDialog` / fixed-canvas route; it no longer uses the stock AlertDialog composition.
- The card explains the airflow prerequisite and shows the Fan ON → Peltier ON sequence. Its paired primary CTA names both outputs; Cancel remains a no-command action.
- Preserve the ordered transaction `FAN:ON` → wait for successful ACK → `PELTIER:ON`. If Fan confirmation fails or the widget is no longer mounted, do not send the Peltier command. Keep timeout/error handling and bilingual copy.
- Amber indicates the missing Fan prerequisite; do not conflate it with red thermal/NTC fault or latch states. The visual redesign does not alter Firmware safety policy or BLE command semantics.
- **Evidence:** source/test is included in Build #153 and hosted CI passed. Actual light/dark rendering, localized wrapping and touch-target screenshots remain **VISUAL NOT VERIFIED**.

### Lock Voltage, Settings About and Device Diagnostics — implemented in Build #153

- **Lock Voltage:** uses the existing centered blur/lock treatment on Voltage and Adaptive only when Firmware lock state is known and ON. Bluetooth-disconnected remains highest priority; existing Adaptive restrictions are preserved. Pending handoff copy must not claim 5V until actual VOLTAGE telemetry confirms it. The Firmware-owned setting card is first below the Settings AppBar; unknown/session/busy/save-failure/retry semantics remain.
- **About / Tentang:** appears immediately after Firmware. Preserve the bilingual credits and exact handles: Horizon (@Horizontalzzz), FYZ (@FYZ737), Logos (@Logos3dMichael). Do not invent profile URLs or contributions beyond the approved role labels.
- **Device Diagnostics:** opening-time snapshot only; show source-backed App/Firmware, BLE/P1, measurements, confirmed outputs, safety and Lock Voltage facts. Unknown stays `--`; no fabricated sample freshness, signal, health or uptime metrics. Copy Diagnostics is a manual, bilingual, redacted local action; no automatic upload.
- **Evidence:** these App source and regression changes are included in the immutable Build #153 source and its 176-test hosted pass. Firmware V7.2 compilation/BIN/NVS and physical rail/Touch/LED behavior remain separate and unverified.

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



### Peltier safety dialog — fixed compact follow-up (source change after Build #153; not released)

- **Problem/reference:** owner screenshot showed a draggable/scrollable oversized popup and dialog text with anomalous inherited-looking underlines/face. Scope is only the Fan-OFF → Peltier-ON prerequisite dialog.
- **Fixed geometry:** preserve `JexFixedScalePage`, one existing 360-dp transform and safe-area behavior. Keep the panel centered with 296-dp max width, 20-dp radius and compact internal spacing. Remove `SingleChildScrollView` so the card cannot be dragged/scroll-shifted; remove the entrance SlideTransition while retaining restrained fade/scale. No second transform or global scaling change.
- **Typography:** explicitly use the existing ThemeData Roboto family and `TextDecoration.none` for raw dialog copy; title 15–15.5 dp, body 11.5–12.5 dp, step labels 10.5 dp. Keep adequate line-height and test the longest EN/ID strings. These are modal-only compact values, not new global text tokens.
- **Actions and safety:** preserve 48-dp primary and Cancel targets, amber fan-prerequisite meaning, barrier/Cancel no-command behavior, and exact FAN:ON → successful ACK → PELTIER:ON order. Do not modify BLE/P1, Firmware, telemetry authority, or thermal/NTC behavior.
- **Temperature tab:** remove the global Reset Temperature Settings control and its App handler/label. Keep Hotside limit and battery 5V/12V zone controls unchanged; leave generic command acknowledgement classification untouched.
- **Acceptance:** 350-dp/420-dp fixed-canvas behavior; portrait and constrained height; EN/ID longest strings; Light/Dark; Fan OFF and Cancel/approve/fan-ACK-failure. Capture actual Android screenshots before marking visual acceptance. Status after source commit: STATIC SOURCE CHECK only / VISUAL NOT VERIFIED.
