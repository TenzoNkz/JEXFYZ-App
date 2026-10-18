# JE X FYZ / JE Cooler — Approved Design Notes

This file stores durable, user-approved visual constraints. Do not reinterpret a narrowly-scoped adjustment as permission to redesign.

## JE X FYZ grille — approved reference

- Approved direction: symmetrical white geometric grille, central purple X monogram, four corner mounting holes.
- Outer silhouette must be a geometrically square 1:1 shape and symmetrical.
- Keep the approved original interior pattern and surrounding frame unchanged unless the user explicitly requests a change.
- Remove only the two small protrusions at the midpoint of the left/right outer sides when continuing the approved edit.
- Flat 2D manufacturable/print-ready design: no shadows, bevels, faux depth, gradients or texture.
- White solid grille with purple X monogram. Do not change the monogram to HZ; user reverted that experiment and re-approved X.
- For an “enlarge only” request, scale up the existing design only. Do not invent new holes, ribs, borders, pattern pieces or logos.
- Do not search for a replacement design or redesign from scratch when the user asks to clean up or scale the approved reference.

## App visual assets / interface direction

- App name: JE Cooler; top/brand label: JE X FYZ.
- `assets/jexfyzicon.png` and `assets/jexfyzcooler.png` are transparent 1:1 PNG visual assets. Preserve their intended aspect ratio and transparency.
- UI direction: dark header, white rounded main content panel, compact navigation; VOLTAGE and ADAPTIVE are the principal modes. Cooler image sits on the right in the established Horizon Cooler-inspired layout.
- If a future visual request supplies an image, preserve unmentioned geometry/details and edit only what the user asked to change.

## Dashboard indicator motion, switch styling and menu locks

- The current motion direction is an integrated, restrained 2D silhouette for each Home indicator, with a distinct phase-driven effect instead of a generic pulse-only animation. The latest source-only update supersedes the earlier “no highlight sweeps” limit: narrow in-shape glints, travelling fill sheen, gauge glint, LED travelling dot and sequential Peltier branch highlights are approved when subtle and clipped/bounded. Keep effects visually disciplined: no stacked glow/ripple rings, no Peltier orbiting sparks, no extra fan blades or decorative orbiting objects. Preserve semantic colors, Canvas bounds, brand identity, card layout and controls.
- Non-Fan indicators continue a quiet ambient cycle after the 440 ms state-emphasis fade; idle motion is decorative and never claims hardware is ON. Fan is the exception: it coasts to a resting position and stays still when OFF. Phase transitions remain continuous. Motion effects must not fabricate sensor values, voltage state or physical RPM.
- Battery uses an internal-fill travelling sheen; Hotside uses one continuous tube-to-bulb outline and inner liquid/bulb highlight; Voltage has a clipped flash through one bolt; Adaptive uses two moving directional arcs/arrowheads rather than a nearly empty ring; Peltier is one six-branch crystal with restrained branch highlights; Fan is one coherent rotor; Speed has a moving gauge glint and retargeted needle; LED uses a travelling wave/dot; Bluetooth pulses its glyph/stem without ripple rings. These visuals are illustrative, not telemetry or a claim about cooling performance.
- Manual VOLTAGE rows remain neutral. 5V/9V/12V labels keep red/green/blue semantic colors; the active toggle uses theme-primary without a check glyph. Peltier, Adaptive and LED switch rows now follow that convention: neutral row/icon surface, no knob checkmark and no adjacent ON/OFF label. Do not alter selector commands, BLE state semantics, voltage lock conditions or authoritative telemetry behavior.
- When Bluetooth is disconnected, blur/dim the entire active display submenu with exactly one centered lock card; keep the top-level tab strip and Home Bluetooth control usable. When Adaptive is ON or transitioning while Bluetooth is connected, apply the same whole-submenu lock only to Voltage, Control and Temperature; leave Adaptive and LED reachable. The text is centered over the submenu content, not placed as an extra row below it.

- LED contract: RGB ON/OFF controls only custom RGB effects. Voltage, thermal/safety, Adaptive, OTA/error and other system indicators remain independent; saved master Brightness applies to every physical WS2812 indication. Phone-side preview remains readable at low hardware Brightness.

## Visual-change protocol

1. Inspect the exact latest reference or source image.
2. State which elements are locked and which are requested to change.
3. Change only authorized elements.
4. Verify square ratio, symmetry, mounting holes, interior pattern, logo shape and flat-print constraints before delivery.
5. Do not overwrite an approved design with a speculative alternative.
