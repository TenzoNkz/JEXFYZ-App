# JE X FYZ / JE Cooler — Approved Design Contract

This document stores durable design constraints, not a build history. Live App source determines current implementation; CHANGELOG.md / APP_BUILD_REPORT.md retain dated validation evidence.

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

- Settings root, all subpages, the Bluetooth Connection sheet and designated modal surfaces use the same 360-dp master-canvas scaling model as Home.
- **Validated and released in Build #129:** implementation commit `d0f87b09c96a89063dc3b6f8c23e763bd11dc66e` removes the interim scale cap. It uses `scale = constraints.maxWidth / 360.0`, fixed logical child width 360 dp, `designHeight = constraints.maxHeight / scale`, `MediaQuery.size = Size(360.0, designHeight)`, and converts `padding`, `viewPadding`, and `viewInsets` by dividing through the scale. An outer `OverflowBox` preserves the logical 360-dp child before a single `Transform.scale`, and `ClipRect` clips at viewport boundaries.
- **Regression test passed in hosted CI:** `test/floating_monitor_layout_contract_test.dart` (test commit `f680837ad61653fbda071bb8f451ccd4113acfaf`, contract comment commit `cf0b66d6c5cf131d55aa99783fa3518274275d57`) holds a 1080×2400 physical test viewport constant while simulating 420-dp and 320-dp logical widths. It checks a 360×800 logical canvas, factors 420÷360 and 320÷360, invariant physical dimensions and no thrown layout exception. Build #129 passed 122/122 Flutter tests.
- Keep text hierarchy, padding relationships, colors, language behavior, controls and BLE logic unchanged. Dart analyzer exited 0 with 25 info-level diagnostics; the configured Android Gradle gate succeeded. Native Android JUnit tasks were `NO-SOURCE`.
- **Remaining QA boundary:** local `dart format` was not run because Flutter/Dart executables are unavailable locally; physical-device/OEM layout QA is also not run. The source is part of Build #129 and the published `jexfyz-latest` release, but widget tests do not prove actual Android rendering across OEM display settings.


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

## Change protocol

1. Inspect the exact current source/reference image.
2. Identify locked versus requested elements before editing.
3. Make only authorized changes; do not reinterpret a narrow edit as permission to redesign.
4. Verify square ratio, symmetry, mounting holes, interior pattern, logo shape, aspect ratio, transparency and flat-print constraints as applicable.
5. Record significant outcomes in CHANGELOG.md; keep historical build-specific proof in APP_BUILD_REPORT.md.
