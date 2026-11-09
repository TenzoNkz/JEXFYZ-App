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



## Home layout, submenu lock and controls

- Keep the established Home card geometry and high-contrast status icon silhouettes. Short status copy should remain compact; long notice copy must not overlap metric rows or escape its card.
- Home notice is icon-left/text-left with no separate CONNECTED/DISCONNECTED badge; physical state is conveyed through the localized primary message when relevant. Current source card height is 44 dp.
- Preserve one centered blur/dim lock overlay over the active submenu when BLE is disconnected. Top-level tab strip and Home Bluetooth control remain usable. When BLE is connected but Adaptive is ON/transitioning, lock Voltage, Control and Temperature only; Adaptive and LED remain available. The lock overlay does not replace control gating.
- Lock copy is bilingual and uses generic Device / Perangkat: CONNECT YOUR DEVICE FIRST / HUBUNGKAN PERANGKAT TERLEBIH DAHULU. Do not use JE X FYZ as a generic noun in this sentence.
- Switch styling: neutral row/icon surface, stable semantic icon colour, theme-primary toggle accent, no checkmark in knob, no extra ON/OFF label beside the toggle. Manual Voltage rows remain neutral with 5V red, 9V green, 12V blue labels.

## Home status icon contract

- Unknown/disconnected state must never fabricate values or imply output ON/OFF. Preserve semantic accent at rest; stop and reset state-driven animations while disconnected.
- Battery: Ice Blue at/below 30°C, smooth transition through cyan/amber/orange from 30–40°C, red/fire effect at or above 40°C. Falling oval embers with warm yellow-white cores, soft restrained halo and deterministic phases are behind the shell and clipped inside the rounded frame but outside the foreground icon.
- Hotside: Ice Blue at/below 30°C, smooth transition to red/flame at the configured Hotside limit. Embers are background-only, clipped outside the raised thermometer silhouette; tube, bulb and graduations paint above particles. UI effect never modifies Firmware safety.
- Voltage: bolt face/core remains static. Two pulses travel along the closed outer contour. No moving central spine or internal strikes; no white pixels may leak beyond the bolt silhouette. Keep 5V/9V/12V red/green/blue and 25%/50%/100% visual intensity mapping.
- Adaptive: exactly two directional arcs/arrowheads with restrained halo/highlight; no orbiting dot or unrelated particles.
- Peltier: one six-branch rotating snow crystal and recognisable flakes behind it. Frost/snow strength maps to 5V/9V/12V classes; no random dots or orbiting sparks.
- Fan: one five-blade swept rotor and layered hub; exactly three curved airflow ribbons remain fixed behind the blades. Only rotor angular speed changes by voltage/PWM class. Airflow fades only during the permitted one-shot connected ON→OFF coast, then Fan is static.
- Fan Speed: fixed upper-half semicircle gauge, start π and sweep π. Known OFF puts the needle at far-left; proportional PWM reaches far-right at 100%. Retarget from authoritative state without autonomous phase loop/wobble. Hide the needle for unknown/disconnected PWM instead of implying OFF.
- Animation gate: while BLE disconnected, stop/reset all custom icon controllers. While connected, Battery/Hotside/Voltage loop continuously even if the sensor value is unknown (value remains --). Adaptive/Peltier/Fan/LED animate only when authoritative state is ON; OFF is static, except the connected Fan's one-shot coast. Bluetooth icon is static.
- Keep animations phase-compatible at loop seams. Effects must not fabricate sensor values, voltage, current, output state or physical RPM.

## Home notice copy and known mismatch

- The intended notice is a single concise latest-event message, not a concatenated state summary. Ordinary temperature samples do not create notices; Hotside at/above the limit has safety priority. Delayed ACKs must not replace newer telemetry-confirmed events.
- User-facing notice copy is professional, actionable and localized. Never display raw reason IDs, internal underscore tokens, OTA ERROR/CODE text or internal event suffixes.
- **Resolved design decision (2026-10-23):** the Home notice heading follows the selected App language — `Notification` in English and `Notifikasi` in Indonesian. Keep this localized heading aligned with live source; do not use the former fixed `NOTIFY` wording. This is a documentation/design decision only; it does not authorize source edits or a build.

## LED semantics

- RGB ON/OFF controls custom RGB effects only. Voltage, thermal/safety, Adaptive, OTA/error and other system indications remain independent.
- Saved master LED brightness applies to every physical WS2812 indication. Phone-side preview remains readable at low hardware Brightness.
- Safety/OTA indication outranks decorative RGB effects.

### Light Mode contrast correction — execution contract (2026-11-09; implementation pending)

**Status:** prepared during `Pikirkan Diskusi!`; source and tests have not been changed. This is the scoped implementation plan for the next separately authorized `Eksekusi Full!`.

- **Problem found in current source:** the Home status-icon painter uses fixed near-black/navy shadows, cavities, outlines and hubs for Battery, Hotside, Voltage, Peltier, Fan and Fan Speed. Those layers were designed for a dark visual context and can appear as black patches against the Light Mode tile. `_homeMetric()` also sends the original bright semantic accent directly to its value text; the existing `lightThemeAccentText()` helper is not used there and its current fixed lightness clamp does not guarantee WCAG text contrast.
- **Icon treatment:** pass the active theme brightness and the existing light-theme surface/outline tokens into `_JexIconPainter`. Keep the current dark-theme paint values and behavior unchanged. In Light Mode, remove the offset near-black shadow layers and replace near-black cavities/hubs/underlays with the theme's light surface token; use the theme outline token and a restrained semantic accent edge for silhouette definition. Apply this to Battery/Hotside cavities, Voltage offset shadow, Peltier crystal outline/core, Fan outer/rotor/hub, and Fan Speed track/hub. Do not redraw the glyphs or add decorative effects.
- **Preserved icon contract:** keep each path/silhouette, geometry, painter order, clipping, tile dimensions (38 dp visible tile / 41 dp leading slot), 26 dp Home glyph, 45 dp indicator row, telemetry values, warning thresholds, animation phase/timing, connected/OFF/unknown gates, Fan coast and Fan Speed needle rules unchanged. The painter must repaint when the theme changes.
- **Metric value foreground:** wire `lightThemeAccentText()` into the Light Mode value-text path and revise its color selection so it actually meets at least 4.5:1 against the Home white surface for every used semantic accent. Dark Mode continues to use the existing accent unchanged. Do not change metric labels, typography, tile fills or geometry.
- **NOTIFY foreground/background separation:** retain the existing semantic pastel card fills and current error/warning/success predicates. In Light Mode only, use a separate accessible foreground for the icon and `Notification/Notifikasi` heading: success `#027A48`, warning `#B54708`, error `#B42318`. Keep the current bright semantic colors as the subtle card-tint source. The current calculated foreground contrast on the corresponding tinted light surfaces is approximately 5.20:1 (success), 5.18:1 (warning), and 5.79:1 (error). Dark Mode retains the original mint/amber/coral colors. The body copy stays `#16181D`; the 44 dp icon-left/text-left card, no-badge layout, wrapping and message/state logic remain unchanged.
- **Regression requirements:** add/adjust tests for theme propagation and painter repaint invalidation; Light/Dark icon palette separation; unchanged painter geometry and animation/state gates; Light Mode accent text >=4.5:1; all three NOTIFY foreground contrast ratios on the real tinted surfaces; Dark Mode color preservation; localized heading and existing message priority. Update old source-contract assertions that currently require hard-coded dark paint tokens rather than deleting or weakening the geometry/state assertions.
- **Visual acceptance matrix:** actual app screenshots at 350-dp and 420-dp Home widths; Light/Dark; English/Indonesian; Battery/Hotside normal and warning, Voltage 5V/9V/12V, Adaptive, Peltier, Fan and Fan Speed states; NOTIFY success/warning/error and one-/two-line copy. Compare matching states and inspect icon edges, cavities, silhouette clarity, title/icon contrast, wrapping and clipping. Source tests or a successful APK build alone cannot be called a visual pass.
- **Acceptance labels:** P0/P1 none; resolve material P2 contrast/overlap findings. Until actual screenshots are captured and reviewed, report `VISUAL NOT VERIFIED`, even if unit/widget tests pass. App Build/release requires the separate `Eksekusi Build App!` command.
## Change protocol

1. Inspect the exact current source/reference image.
2. Identify locked versus requested elements before editing.
3. Make only authorized changes; do not reinterpret a narrow edit as permission to redesign.
4. Verify square ratio, symmetry, mounting holes, interior pattern, logo shape, aspect ratio, transparency and flat-print constraints as applicable.
5. Record significant outcomes in CHANGELOG.md; keep historical build-specific proof in APP_BUILD_REPORT.md.

## Localization terminology — English and Indonesian

- The PWM speed control uses Fan Speed / Kecepatan Kipas. The Fan toggle and Floating Monitor F metric use the shorter Fan / Kipas label.
- Hotside remains the named thermal component in both locales; Adaptive Mode / Mode Adaptif is the consistent feature name. Legacy stored notices using Sisi panas are re-localized to Hotside.
- Floating Monitor is presented as Monitor Melayang in Indonesian, including its Android foreground-service notification channel, title and body. Keep the native channel ID unchanged.
