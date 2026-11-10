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
- **Physical visual status:** screenshot review and Android/OEM validation at 350-dp/420-dp remain NOT VERIFIED. The owner must install Build #131 and review the actual screens; hosted widget tests are not visual acceptance.

### Peltier safety dialog and LED color picker sizing — owner screenshots (2026-11-10)

**Status:** SOURCE IMPLEMENTED / STATIC SOURCE CHECK. Formatter, Flutter tests and analyzer are BLOCKED / NOT RUN because Flutter/Dart are not installed in the active environment. Actual Android screenshots remain VISUAL NOT VERIFIED. The owner-provided 691×1536 screenshots are not tied to a verified installed APK/source SHA.

- **Protected layout contract:** both overlays remain inside the existing `JexFixedScalePage`. The 360-dp logical canvas, single `constraints.maxWidth / 360` transform, safe-area handling and surrounding Home geometry are unchanged. No global scaling or second transform was introduced.
- **Peltier safety dialog — implemented in `lib/main.dart`:** maximum outer width 340 dp; AlertDialog inset 30 dp horizontal / 18 dp vertical; title 20 dp; body 15 dp; action labels 14 dp. Title/content/actions padding tightened to 20/12 dp horizontal families and reduced vertical gaps. Cancel/Fan action minimum sizes are 72×48 dp and 128×48 dp. Fan-before-Peltier approval/ACK ordering, cancel behavior, bilingual safety copy and physical gating are unchanged.
- **LED Color Picker — implemented in `lib/main.dart`:** panel max width 312 dp and maximum height `min(308 dp, 82% of available safe-area height)`; outer horizontal padding 24 dp and vertical padding 4 dp. Card radius 18 dp, elevation 12, internal padding 7×8 dp, 48-dp header and 19-dp title. Selection preview dot/name is 16/14 dp. Cancel/Select text is 14 dp with 72×48 dp minimum targets.
- **Palette geometry:** all 36 hue-ordered presets remain present, including `#FFFFFF` as the final entry. The six-column grid now scrolls internally; each grid cell is 48×48 dp, while the visible swatch artwork is 32×32 dp. With a 312-dp panel, 7-dp horizontal card padding and 2-dp column gaps, each of six hit cells is exactly 48 dp. The selected-color preview, swatch staging, white border, Cancel and explicit Select/commit behavior are preserved.
- **Protected behavior:** no BLE/P1, RGB protocol, color persistence, LED mode gating, theme colors, localization, Peltier/Fan safety semantics, other Home geometry, Settings or Firmware code was changed. The full 36-color palette is scrollable rather than reduced to the initially visible rows.
- **Regression coverage added:** `test/widget_test.dart` includes source-contract/helper coverage for compact Peltier typography and fan-first action ordering; responsive picker height; all 36 colors/final white; max panel width; six-column scrollable grid; 48-dp grid cells/action targets; and 32-dp visible swatches. These are test source additions, not executed test results.
- **Static evidence:** current `lib/main.dart` blob `6fc50bf1812575f1502d433499270bc0cad8c14f`; current `test/widget_test.dart` blob `795de84a1d18c990a67dd6a40e8420a2c6ccbd0f`. Delimiter-balance scan of both full Dart files found no unmatched parentheses/braces/brackets. Static inspection confirms 36 presets and the existing fixed-canvas wrapper. No Flutter formatter, widget test, analyzer, Build App, APK, Release or device operation was run.
- **Required visual acceptance:** install a separately produced App package and inspect both overlays at 350-dp/420-dp, English/Indonesian, portrait and constrained-height cases. Verify no clipping/overlap; Peltier Cancel and FAN-confirm action; picker scroll to rows 5–6, final white option, preview/Cancel/Select; and 48×48 dp interactive areas. Until actual App screenshots are reviewed, status remains VISUAL NOT VERIFIED.
- **Authorization boundary:** current owner command combined `Diskusi!` and `Eksekusi Full!`; the two App overlay source/test changes are implemented within that scope. Any APK still requires a separate `Eksekusi Build App!`. No Firmware, BIN, Firebase, OTA, flashing or device operation occurred.


## Usage Statistics — professional animated chart direction (owner request, 2026-11-10)

**Status:** DESIGN DIRECTION RECORDED / NOT IMPLEMENTED. Current source still uses a 450-ms refresh debounce, step-shaped temperature painter and three compact Operating Profile timeline lanes. No source/test was changed for this Diskusi.

- **Overall hierarchy:** compact cooling-session summary (LIVE/completed, elapsed active duration, last sample and data coverage); two temperature charts; then a coordinated Operating Profile area containing four distinct charts.
- **Temperature charts:** separate Phone Battery and Hotside plots in °C; current reading and Min/Avg/Max summary; Hotside safety-limit reference. Use a restrained curve/line transition that never overshoots observed points or hides abrupt safety-relevant changes. Preserve visible data gaps.
- **Operating charts:** Voltage as a 5V/9V/12V discrete step chart; Adaptive Mode (the current App term, not a separate AI feature) as ON/OFF step chart; Peltier Switch as ON/OFF step chart; Fan Speed as a 0–100% trace with 0% explicitly indicating Fan OFF. Keep a separate legend and semantic scale for each chart.
- **Shared inspection:** all charts align to the same elapsed-since-session-start axis. A shared tap/drag cursor and tooltip should show the verified values at one selected time across all metrics. Show event markers for rail/mode/output changes and preserve gaps/coverage.
- **Motion:** raw Battery/Hotside collection remains about 1 Hz. Smoothness is display animation on Flutter vsync (about 16.7 ms per frame at 60 Hz or 8.3 ms at 120 Hz), not 1-ms polling, 1000 writes/sec or synthetic measurement data. Analog traces may interpolate display motion between timestamped observations; Boolean/rail state charts remain stepped and must never show fictional intermediate states (e.g. 7V between 5V and 9V). Do not interpolate through invalid/stale/disconnected periods or separate sessions.
- **Performance:** the existing 450-ms notifier debounce reloads the full SQLite session snapshot and recomputes the page summary. Prefer an incremental in-memory live chart model/delta path while persisting authoritative observations asynchronously. Keep full-resolution data for analytics; use extrema/gap-preserving decimation for plot rendering on long runs. Validate serialized write-queue backpressure and long-session performance before increasing capture frequency.
- **Data gap:** current source records Voltage, Adaptive and Fan Speed events, but does not yet persist Peltier ON/OFF as an Operating Profile event. Add a Peltier baseline after completed P1 full sync and record telemetry-confirmed PELTIER state transitions. Never use command ACK as proof of physical state. Fan ON/OFF is currently represented by Fan Speed 0% versus nonzero.
- **Acceptance:** exact state durations and summaries; no interpolation across gaps; no numeric interpolation between discrete voltage/mode values; correct 60/120-Hz transition behavior; lifecycle pause/disposal; large-session decimation preserving true min/max and coverage; 350-dp/420-dp, Light/Dark, English/Indonesian and long-session screenshots. Visual outcome stays VISUAL NOT VERIFIED until actual App screenshots are inspected.

