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

### Home Light Mode contrast correction — source implementation (2026-11-09)

**Status:** SOURCE IMPLEMENTED / NOT RUN. The owner authorized this scoped repair with `@Pikirkan Eksekusi Full!`. Source and regression-test changes are committed to `main`; formatter, Flutter tests, analyzer, screenshots and device rendering have not been run.

- **Implementation:** `JexAnimatedIcon` now passes Light Mode state and the inherited surface/outline tokens to `_JexIconPainter`. Theme-aware depth/cavity helpers preserve the original dark paint values on the Dark Mode branch and use the Home theme's light surface/outline treatment on Light Mode.
- **Icon coverage:** Battery, Hotside, Voltage, Adaptive (recessed track and directional arrow edges), Peltier (crystal outline/core), Fan (outer ring, rotor outline and hub) and Fan Speed (track/hub) now use theme-aware depth colors. The painter invalidates when theme/palette inputs change. Paths, dimensions, clipping, draw ordering, animation timing/phase, warning predicates, telemetry/unknown states, Fan coast and Fan Speed needle mapping were not intentionally changed.
- **Metric foreground:** `lightThemeAccentText()` now finds a darker HSL color by bounded lightness search until it reaches at least 4.5:1 against the active light surface. It is used only on Light Mode; Dark Mode retains the original semantic accent directly. The metric label, type scale, tile fill/border and 45 dp row geometry are unchanged.
- **NOTIFY foreground:** the icon and localized `Notification/Notifikasi` heading now use separate Light Mode foregrounds: success `#027A48`, warning `#B54708`, error `#B42318`. The original mint/amber/coral colors still define the existing subtle card tint; the body remains `#16181D`. Dark Mode returns the original status foreground colors. The status predicates, priority, localized message, 44 dp card and icon-left/text-left/no-badge layout remain unchanged.
- Against the actual Light Mode composited card tints (`.07` alpha for success/warning, `.11` for error), these foregrounds calculate to approximately **5.22:1**, **5.22:1**, and **5.79:1**, respectively.
- **Regression source added/updated:** `test/widget_test.dart` now checks theme propagation and repaint invalidation, Light/Dark painter palette separation including Adaptive/Hotside, unchanged icon structure/state contracts, metric contrast, NOTIFY contrast against composited tinted surfaces and Dark Mode color preservation. Existing painter source-contract assertions were migrated to the theme helper without removing their geometry/state checks.
- **Implementation commits:** `lib/main.dart` source path latest commit `ab833650ff14f9d3b2ea0c7048902826693a57b6`, live blob `0d90b418c9140cfbb6090f2723ab24c8fbd5e9fc`; `test/widget_test.dart` latest change commit `0d168c8e54dd61bfd0d51c70b00cc070fc9443b5`, live blob `cd60dff690a8dc17fd45dcc13a3e8d94f4afef37`. Additional implementation/test/style commits are preserved in git history.
- **Static source audit:** painter's fixed near-black paint operations were replaced by theme-aware helpers; delimiter-balance checks passed for both changed Dart files; no old source-contract assertions requiring those removed raw painter expressions remain. This is STATIC SOURCE CHECK only.
- **Validation blocker:** the active runtime has no Flutter, Dart, Gradle or ADB. `dart format`, focused tests, full `flutter test`, `flutter analyze`, real screenshots and OEM/device checks are BLOCKED / NOT RUN. Do not report TESTED, VERIFIED CI or VISUAL PASS from this source inspection.
- **Visual acceptance still required:** actual-app screenshots at 350-dp/420-dp, Light/Dark, English/Indonesian; Battery/Hotside normal and warning, Voltage 5V/9V/12V, Adaptive, Peltier, Fan and Fan Speed; NOTIFY success/warning/error and one-/two-line messages. Until reviewed, the result remains `VISUAL NOT VERIFIED`.
- **Release boundary:** Build #131 remains the latest verified APK, packaged from `b3c4fee432fddc49430840daeb1e2eecbe78a0db`. This source change is NOT RELEASED. A later package requires separate `Eksekusi Build App!`; no build, release, Firmware, BIN, Firebase, OTA, flash or device operation was performed here.

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
