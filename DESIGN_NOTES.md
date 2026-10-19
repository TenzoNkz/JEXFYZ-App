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

- Keep each Home indicator as a high-contrast integrated 2D silhouette; effects support the symbol and never obscure its identity.
- Battery/Hotside use a redesigned molten-lava effect: layered tapered tongues with warm red/orange/yellow cores, subtle lateral drift and three rising teardrop-shaped lava fragments that taper and fade at each end. The effect layer and thermal accent ease in/out over 280 ms when the exact warning predicate switches; the configured temperature thresholds themselves remain unchanged. Battery uses a shorter/wider plume from the lower shell; Hotside uses a taller plume rooted near the thermometer bulb. Use deterministic integer harmonics so every repeated cycle joins without a phase snap. No circular ember particles, dot confetti or short line dashes.
- Battery stays Ice Blue at ≤30°C, transitions smoothly through cyan/amber/orange from 30–40°C, and reaches red plus lava effect at ≥40°C. Hotside stays Ice Blue at ≤30°C and reaches red/full-height heat effect exactly at the configured Hotside Limit. These visuals never alter or replace Firmware-owned thermal safety.
- Voltage keeps 5V red, 9V green and 12V blue. Add two short, staggered side strikes clipped inside the bolt alongside the bright current segment travelling along its closed lightning spine. Visual current intensity stays 25% / 50% / 100% for 5V / 9V / 12V; it is not a physical current reading.
- Adaptive keeps exactly two directional arcs/arrowheads, improved with a restrained halo and inner highlight; no orbiting dot or unrelated particles.
- Peltier keeps one six-branch rotating snow crystal and recognisable branched flakes falling behind it. Frost strength/density maps to established 5V / 9V / 12V classes. A small faceted centre adds depth without obscuring the crystal; no random dots or orbiting sparks.
- Fan uses one five-blade swept rotor and a layered central hub. Exactly three curved airflow ribbons remain fixed behind the blades throughout spin; their path, count, width and colour never change with voltage or PWM. Only rotor angular speed changes: 5V slow, 9V medium and 12V uses authoritative PWM. Airflow stays visible while spinning and fades only during the permitted one-shot connected ON→OFF coast; then Fan rests static.
- Fan Speed uses a fixed upper-half semicircle gauge (start π, sweep π): a known OFF state puts the needle at the far-left endpoint, intermediate PWM is proportional, and 100% reaches the far-right endpoint. Needle and filled arc smoothly retarget authoritative PWM with no autonomous phase loop, wobble or orbiting glint. If PWM/output state is unknown or BLE is disconnected, hide the needle rather than implying OFF.
- Animation gating is strict: while BLE is disconnected, stop and reset every custom icon controller. While connected, Battery, Hotside and Voltage loop continuously, even if a sensor value is unknown (retain “--”). Adaptive, Peltier, Fan and LED animate only when authoritative state is ON. Fan Speed is event-driven and has no repeating phase loop. OFF outputs remain in a fully-coloured standby pose, except the connected Fan’s one-shot coast. Bluetooth remains static.
- Repeating paths use phase-compatible integer harmonics and must be visually continuous at their wrap. All effects are illustrative: never fabricate sensor values, voltage/output state, electrical current or physical RPM. Preserve semantic colours, approved icon/card layout, brand identity, controls and telemetry behavior.
- Manual VOLTAGE rows remain neutral. 5V/9V/12V labels keep red/green/blue semantic colours; the active toggle uses theme-primary without a check glyph. Peltier, Adaptive, Fan and LED switch rows follow that convention: neutral row/icon surface, stable semantic icon colour, no knob checkmark and no adjacent ON/OFF label. Preserve selector commands, Fan safety gating, BLE state semantics, voltage locks, authoritative telemetry, and Fan Speed slider layout/behavior.
- When Bluetooth is disconnected, blur/dim the entire active display submenu with exactly one centered lock card; keep the top-level tab strip and Home Bluetooth control usable. When Adaptive is ON or transitioning while Bluetooth is connected, apply the same whole-submenu lock only to Voltage, Control and Temperature; leave Adaptive and LED reachable. The text is centered over the submenu content, not placed as an extra row below it.

- LED contract: RGB ON/OFF controls only custom RGB effects. Voltage, thermal/safety, Adaptive, OTA/error and other system indicators remain independent; saved master Brightness applies to every physical WS2812 indication. Phone-side preview remains readable at low hardware Brightness.

## Static action glyphs versus animated status indicators

- Navigation, settings, drag handles and other action affordances use static high-contrast glyphs. They do not run idle loops because they do not represent live state or telemetry.
- Live Home status indicators use the data-driven `JexAnimatedIcon` painter and the connection/authoritative-state gates above. Bluetooth remains static and communicates state through semantic colour.
- The native Floating Monitor retains its established compact letters-only B/H/V/A/P/F presentation and schema; values/status still follow live telemetry, unknown values remain `--`, and disconnected state must never imply current physical output. Replacing those letters with native pictograms is a separate presentation/layout change, not a hidden side effect of the Home icon refresh.

## Visual-change protocol

1. Inspect the exact latest reference or source image.
2. State which elements are locked and which are requested to change.
3. Change only authorized elements.
4. Verify square ratio, symmetry, mounting holes, interior pattern, logo shape and flat-print constraints before delivery.
5. Do not overwrite an approved design with a speculative alternative.
