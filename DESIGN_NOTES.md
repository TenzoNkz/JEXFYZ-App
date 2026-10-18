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

- The motion direction is an integrated 2D silhouette for each Home indicator, with an effect specific to that function rather than a generic pulse. Bounded in-shape highlights, thermal embers, snow particles, lightning streaks, airflow, gauge ticks/glints and LED wave/dot are permitted when clipped to sensible Canvas bounds. Keep them visually disciplined: no stacked glow/ripple rings, no Peltier orbiting sparks, no extra fan blades or decorative orbiting objects. Preserve each silhouette, semantic colour, brand identity, card layout and controls.
- Animation gating is strict: while BLE is disconnected, stop and reset every custom icon controller immediately. While connected, only Battery, Hotside and Voltage loop continuously, including when a sensor value is unknown; retain “--” and never invent readings. Adaptive, Peltier, Fan, Fan Speed and LED animate only while their authoritative state is ON. OFF icons return to a fixed, fully-coloured standby pose with no repeating cycle; Fan may perform one brief coast-down only after a connected ON→OFF transition. Bluetooth itself remains static; its connection colour communicates state. Phase-safe retargeting is retained for active motion, and no effect may fabricate sensor values, voltage state or physical RPM.
- Battery colour is Ice Blue at ≤30°C, transitions smoothly toward Burning Red over 30–40°C, and reaches red plus a dense, full-strength bounded flame/ember effect at ≥40°C. Hotside is Ice Blue at ≤30°C and reaches red plus dense embers exactly at the configured Hotside Limit; this is a visual cue only and never replaces firmware safety.
- Voltage keeps 5V red, 9V green and 12V blue; lightning detail is 25% / 50% / 100% respectively. Peltier remains one six-branch crystal; frost/snow intensity is 25% / 50% / 100% at 5V / 9V / 12V. No orbiting Peltier sparks.
- Fan remains one coherent rotor, with 5V slow, 9V medium, 12V fast motion; at 12V the rotor and airflow account for the actual PWM level. Curved streaks exit in the direction of airflow. Fan Speed gets a fixed-colour tick-mark gauge, smooth live needle retargeting, and a restrained active glint; OFF rests at the zero position. LED’s travelling wave/dot animates only while RGB is on. These visuals are illustrative, not telemetry or a claim about cooling performance.
- Manual VOLTAGE rows remain neutral. 5V/9V/12V labels keep red/green/blue semantic colours; the active toggle uses theme-primary without a check glyph. Peltier, Adaptive, Fan and LED switch rows follow that convention: neutral row/icon surface, stable semantic icon colour, no knob checkmark and no adjacent ON/OFF label. Preserve selector commands, Fan safety gating, BLE state semantics, voltage locks, authoritative telemetry, and Fan Speed slider layout/behavior.
- When Bluetooth is disconnected, blur/dim the entire active display submenu with exactly one centered lock card; keep the top-level tab strip and Home Bluetooth control usable. When Adaptive is ON or transitioning while Bluetooth is connected, apply the same whole-submenu lock only to Voltage, Control and Temperature; leave Adaptive and LED reachable. The text is centered over the submenu content, not placed as an extra row below it.

- LED contract: RGB ON/OFF controls only custom RGB effects. Voltage, thermal/safety, Adaptive, OTA/error and other system indicators remain independent; saved master Brightness applies to every physical WS2812 indication. Phone-side preview remains readable at low hardware Brightness.

## Visual-change protocol

1. Inspect the exact latest reference or source image.
2. State which elements are locked and which are requested to change.
3. Change only authorized elements.
4. Verify square ratio, symmetry, mounting holes, interior pattern, logo shape and flat-print constraints before delivery.
5. Do not overwrite an approved design with a speculative alternative.
