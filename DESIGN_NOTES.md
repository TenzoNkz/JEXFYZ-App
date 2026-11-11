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

### Peltier safety dialog and LED Color Picker — Build #149 baseline and owner follow-up (2026-11-10 to 2026-11-11)

**Current implementation status: SOURCE IMPLEMENTED / VERIFIED CI in Build #149.** The modal source and regression tests are included in the source SHA `0507e3e11b67b8f8d042e49b74cc14a53bfc4f21`; the hosted analyzer and full Flutter suite passed as recorded in `PROJECT_STATE.md`. The active container still has no Flutter/Dart toolchain, so no separate local formatter/test/analyzer run is claimed. Visual acceptance remains **VISUAL NOT VERIFIED** because the owner's screenshot is not tied to an independently identified installed APK/source SHA and there is no matched before/after device capture.

- **Protected layout contract:** both overlays remain inside `JexFixedScalePage`. Preserve the 360-dp logical canvas, single `constraints.maxWidth / 360` transform, safe-area/inset handling and surrounding Home geometry. Do not add a global scale or a second transform.
- **Peltier safety dialog — current source:** outer max width 340 dp; AlertDialog horizontal/vertical inset 30/18 dp; title/body/action text 20/15/14 dp; title/content/actions use tightened 20/12 dp horizontal padding families. Cancel/Fan action minimum targets are 72×48 / 128×48 dp. Screenshot review on 2026-11-11 shows that the resulting modal still reads too tall/narrow and oversized to the owner. The narrow effective content width causes the bilingual safety sentence to wrap and contributes to dialog height.
- **LED Color Picker — current source:** panel max width 312 dp and maximum height `min(308 dp, 82% of available safe-area height)`; internal scroll; 36 hue-ordered named presets; six columns; 48×48 dp cells with 32×32 dp visible swatches; selected-color preview and localized name; localized tooltips/semantics; 72×48 dp Cancel/Select targets. Existing selection staging, explicit Select/commit, Cancel behavior, final white option and RGB command path are preserved.
- **Color labels — current source review:** the 36 presets already have English and Indonesian localization keys. However, some names do not accurately match their exact RGB values under familiar standard color naming. Examples to correct during the palette pass: `#FF6347` is currently labeled Coral but is the standard Tomato value; standard Coral is `#FF7F50`. `#FFD700` is Gold; `#7FFF00` is Chartreuse; `#FF1493` is Deep Pink; and `#FF4500` is Orange Red. Use exact standard names where a standard hex match exists; otherwise use a consistent descriptive shade name. Reference: [MDN CSS named colors](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/named-color).
- **Palette naming behavior:** the selected preview, tooltip and accessibility label should all resolve from the same localized name key. Keep English and Indonesian complete and natural; do not expose HEX values in the user interface. Existing stored RGB values and legacy display-name aliases must continue to resolve correctly. Do not introduce pure black as a normal color swatch without a separate decision because users may interpret black as LED OFF.
- **Protected behavior:** no BLE/P1, RGB protocol, color persistence, LED mode gating, theme colors, localization infrastructure, Peltier/Fan safety semantics, other Home geometry, Settings or Firmware behavior may be changed by these visual refinements.
- **Existing CI regression coverage:** `test/widget_test.dart` covers Peltier typography and fan-first command ordering, responsive picker height, all 36 entries/final white, max panel width, six-column scrollable grid, 48-dp cells/action targets and 32-dp swatches. Build #149 passed 166/166 Flutter tests; CI evidence does not establish physical visual quality.

#### Owner request and recommended next design (2026-11-11) — DISCUSSION ONLY / NOT IMPLEMENTED

**Peltier safety popup**
- Make the card visibly wider and shorter, approximately 304–312 dp effective width and a target height around 132–142 dp, subject to English/Indonesian wrapping and safe-area constraints.
- Keep the 340-dp outer max width and existing 360-dp canvas; reduce the AlertDialog horizontal inset from 30 dp to approximately 8–12 dp. The existing 16-dp outer page padding remains, so the dialog does not touch the screen edge.
- Recommended typography: title 18 dp, body 14 dp, actions 14 dp. Reduce vertical title/content/action padding and gaps. Keep both action targets at least 48 dp high; do not gain compactness by shrinking touch targets.
- Keep the safety copy short and direct in both languages, with the same meaning: Fan must be running before Peltier can be enabled. Preserve the current Cancel and Fan-start choices and all fan-first safety/ACK sequencing.

**LED Color Picker**
- Recommended palette size: **60 curated colors total** (24 additions to the current 36), rather than an unbounded or randomly generated list. Aim for a more complete range of deep, mid-tone, vivid and pastel shades across red/orange, yellow, green, cyan/teal, blue, violet and pink.
- Keep the existing six-column grid, 48-dp hit cells, 32-dp swatches, internal scrolling, max panel width and preview/Cancel/Select interaction. The extra choices add scroll rows, not a taller card or smaller hit targets.
- Suggested additional CSS-aligned starting set: Maroon `#800000`, Dark Red `#8B0000`, Firebrick `#B22222`, Crimson `#DC143C`, Orange `#FFA500`, Sandy Brown `#F4A460`, Goldenrod `#DAA520`, Khaki `#F0E68C`, Olive `#808000`, Dark Green `#006400`, Forest Green `#228B22`, Pale Green `#98FB98`, Teal `#008080`, Turquoise `#40E0D0`, Aquamarine `#7FFFD4`, Deep Sky Blue `#00BFFF`, Dodger Blue `#1E90FF`, Midnight Blue `#191970`, Navy `#000080`, Rebecca Purple `#663399`, Medium Purple `#9370DB`, Lavender `#E6E6FA`, Plum `#DDA0DD`, and Hot Pink `#FF69B4`. Check all entries for exact duplicates before implementation.
- Use canonical English names with clear Indonesian equivalents; match the label to the hex rather than preserving a fashionable but inaccurate name. Keep the selected color name visible in the preview and expose the same localized name through each swatch's tooltip/semantics. Avoid adding text under every swatch because it would overload the compact grid.

**Acceptance matrix:** screenshot at 350-dp/420-dp, portrait and constrained height, English/Indonesian, Light/Dark. Confirm dialog copy wrapping, effective width/height, 48-dp action height, fan-first ordering and Cancel. For the picker, confirm 60 unique presets, hue ordering, every localized name, scrolling to the last row, final white option, selection preview, Cancel/Select and no RGB change before Select.

**Authorization:** this is an owner design request captured during `Diskusi!`. No source, tests, configuration, workflow, build, Release or device operation was changed or run in this discussion. The proposal is not a new approved implementation contract until the owner authorizes `Eksekusi Full!`.

## Usage Statistics — professional animated chart implementation and acceptance (owner request, 2026-11-10; source status 2026-11-11)

**Status: SOURCE IMPLEMENTED / PRE-BUILD REVIEW INCOMPLETE / VISUAL NOT VERIFIED.** The “AI mode” request is interpreted as the existing Adaptive Mode; it is not a new AI feature.

- **Six metric diagrams:** Phone Battery °C and Hotside °C are separate analog temperature plots; Voltage (5V/9V/12V), Adaptive ON/OFF and Peltier ON/OFF are discrete stepped charts; Fan Speed is a 0–100% area/step trace (0% means Fan OFF). Each has its own units/scale.
- **Shared inspection:** a single elapsed-session cursor synchronizes the readout for Battery, Hotside, Voltage, Adaptive, Peltier and Fan Speed.
- **Telemetry truth:** Peltier baseline comes from the synchronized P1 full-sync state; subsequent state events are recorded only when authoritative PELTIER telemetry is received. ACK is not treated as physical-state proof. Open-session coverage is bounded by the latest fresh HOT heartbeat; Battery phone readings cannot extend P1 operation after HOT stales.
- **Motion:** raw temperature sampling remains approximately 1 Hz. Analog display transitions use Flutter vsync/AnimationController; page-level live diagram batches flush once per second through `usageStatisticsDiagramRefreshInterval`; raw collection and persistence are unchanged. No 1-ms timer, synthetic measurements or higher-frequency sensor/database writes are introduced. Voltage/Adaptive/Peltier remain discrete.
- **Data continuity/performance:** invalid sensor readings and session boundaries remain gaps. Temperature render decimation keeps extrema and invalid-data boundaries; full persisted observations continue to feed summaries. Live chart updates use in-memory deltas instead of reloading the full SQLite snapshot after every recorder notification.
- **Performance gap still open:** the current page recomputes the complete selected-session analytics summary after each live batch, and the serialized SQLite queue remains unbounded/unbatched. Long-session CPU/memory and queue pressure are not stress-tested. A bounded/efficient incremental accumulator and lifecycle/backpressure coverage are the recommended remaining App source work before release.
- **Regression source now includes:** Peltier baseline/state-duration and transition-edge tests; HOT freshness coverage; bounded interpolation; extrema/gap-preserving decimation; six-lane page checks at 350/420 dp; synchronized cursor interaction. These tests are committed but NOT RUN. 60/120-Hz progression, pause/dispose and long-session soak are not yet established.
- **Visual acceptance:** source/widget test presence is not visual evidence. Inspect real App screenshots at 350-dp/420-dp, Light/Dark and English/Indonesian before VISUAL PASS. Current outcome: VISUAL NOT VERIFIED.
- **Release boundary:** Build #143 remains the latest verified APK and predates this source. Use Eksekusi Build App! only after the remaining source/performance pass; Build #143 cannot be described as containing this redesign.
