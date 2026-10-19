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

## Approved seven-icon animation family — included in Build #95

- Battery: recognizable shell with a downward-falling three-ember thermal warning effect.
- Hotside: continuous thermometer tube/bulb and falling embers clipped to its inner corridor.
- Voltage: closed bolt, luminous core, travelling spine pulse and staggered inner strikes.
- Adaptive: two opposing circular arrows with the established active-only animation gate.
- Peltier: six-branch crystal with falling snow behind it.
- Fan: exactly three broad swept blades, stable hub, and three fixed airflow ribbons.
- Fan Speed: semicircular gauge and value-driven needle with the existing PWM/unknown-state mapping.
- Build #95 is the latest verified release for this icon family. It passed 99/99 Flutter tests; this does not prove physical-screen smoothness.

## Smoothness rework validated in Build #99

- Build #99 / [Actions run 39230380636](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39230380636) validated the seven-icon motion baseline: 102/102 Flutter tests passed; analyzer had 25 info-level findings and no errors/warnings; required Android/APK/signing/source-ZIP/Release-tag checks passed. This evidence applies to Build #99 source, not later redraws.
- Cadences are Battery 1500 ms, Hotside 1650 ms, Voltage 1000 ms, Adaptive 2300 ms, Peltier 2100 ms. Falling particles use deterministic phase, larger geometry and boundary fades; whole-icon breathing was removed; Peltier crystal rocking is separate from snowfall; Fan uses integrated angular-rate retarget from accumulated phase; Home glyph is 26 dp within the unchanged 38×38 tile.
- Build #99 source blob: lib/main.dart 30d864c2f03c40fd4d0b6926a9958153f2a3b236; test blob: test/widget_test.dart 711a44b00eadee2e2bcd24e48383128f0d70ccc9.

## Static / unknown-state icon-family redraw after Build #99 — SOURCE ONLY / NOT RUN / NOT RELEASED

- The disconnected-state screenshot showed thin/empty glyphs when animation stopped. This follow-up changes static geometry itself rather than adding more idle animation.
- Battery gets a recessed dark window and a subtle semantic-colour thermal emblem in unknown state, never fabricated numeric fill. Hotside gets a dark tube, fixed graduations and a bulb bezel; its live column only reflects valid data.
- Voltage gets a shadowed, inset bolt face; travelling pulse remains state-gated. Adaptive gets stronger twin arrows, thicker arcs and a recessed orbit track, with no idle glow when inactive.
- Peltier's six-arm crystal and centre facet are stronger at rest; secondary flakes are not drawn as frozen particles when not allowed to move. Fan gets a bearing ring, dark blade outline and per-blade specular strips without changing its exact three-blade geometry or three fixed airflow ribbons.
- Speedometer gets a recessed track, 11 graded ticks and layered pivot. The actual needle remains visible only for valid authoritative PWM.
- Source blob lib/main.dart: 6a008c5c3e5ba7118e948e0b1f36277c01e73529; test blob test/widget_test.dart: 94dad7a7506fbcbeea63f300ea25b7f32299d471. These changes are NOT RUN / NOT RELEASED and do not appear in Build #99. Physical-device appearance/smoothness remains UNVERIFIED.

## Static action glyphs versus animated status indicators

- Navigation, settings, drag handles and other action affordances use static high-contrast glyphs. They do not run idle loops because they do not represent live state or telemetry.
- Live Home status indicators use the data-driven `JexAnimatedIcon` painter and the connection/authoritative-state gates above. Bluetooth remains static and communicates state through semantic colour.
- The native Floating Monitor retains its established compact letters-only B/H/V/A/P/F presentation and schema; values/status still follow live telemetry, unknown values remain `--`, and disconnected state must never imply current physical output. Replacing those letters with native pictograms is a separate presentation/layout change, not a hidden side effect of the Home icon refresh.

## Home STATUS / NOTIFY copy contract — 2026-10-19

- Home status categories are concise: STATUS / STATUS, CONNECTION / KONEKSI, SYNC / SINKRONISASI, WARNING / PERINGATAN, ERROR / ERROR.
- User-facing messages must follow the supported English/Indonesian language setting. Never concatenate firmware reason IDs such as PELTIER_SAFETY_LATCH or underscore-formatted diagnostic tokens into visible prose.
- Map known reason codes to localized, actionable copy. Unknown codes use a generic localized message. Keep raw identifiers in internal diagnostics only.
- OTA result presentation must never expose raw ERROR/CODE fields or internal event suffixes. Show concise localized success/failure summaries, a known localized stage when useful, and a validated firmware version; keep protocol diagnostics out of Home STATUS.
- Classify unconfirmed command outcomes as errors in both languages. Preserve existing safety thresholds, predicates, controls, BLE protocol, command semantics and telemetry state.
- Normalize Home STATUS text consistently, including after language changes, but preserve OTA result envelopes for their dedicated parser.

## Visual-change protocol

1. Inspect the exact latest reference or source image.
2. State which elements are locked and which are requested to change.
3. Change only authorized elements.
4. Verify square ratio, symmetry, mounting holes, interior pattern, logo shape and flat-print constraints before delivery.
5. Do not overwrite an approved design with a speculative alternative.


## Home NOTIFY card — clean centered two-line layout (source updated; NOT RUN / NOT RELEASED)

- Remove the right-side CONNECTED / DISCONNECTED badge completely. Connection state remains communicated by the localized main message when relevant; never duplicate it in a separate chip.
- Keep the category heading as `NOTIFY • STATUS`, `NOTIFY • CONNECTION`, `NOTIFY • SYNC`, `NOTIFY • WARNING`, or `NOTIFY • ERROR`, using the existing English/Indonesian category localizations.
- Center the heading and body text horizontally; vertically center the whole text group beside the left status icon. The text region uses symmetric side insets so its center aligns with the card center.
- Card height is content-driven with a minimum height. Short body copy stays on one line; longer copy wraps naturally to at most two lines. Keep a readable font size; do not use `FittedBox` to shrink long messages. Only content beyond two lines may ellipsize after message normalization.
- Keep existing status icon/color selection, connection logic, BLE semantics, safety thresholds/predicates and telemetry authority unchanged.
- Polish Home NOTIFY copy in both supported languages, including direct acknowledgements for accepted fan-speed, Hotside-limit and 5V/12V battery-limit commands. Map known reason codes to actionable text, use generic localized copy for unknown identifiers, and route raw OTA envelopes through the dedicated formatter before normalizing. No raw reason IDs, OTA ERROR/CODE values or internal event suffixes may reach the card.
- Current source blobs: `lib/main.dart` `b0d3a18f79b903bc8574d03a95cbc134b9234f20`; `lib/app_settings.dart` `8f228000d38d73038c06f569c052b1af601288a5`; `test/widget_test.dart` `df1b400b46cbe1e1e79c95e0cf537fbe4d7efd98`. The changes have not been executed through Flutter tests/analyzer or released. Physical-device layout remains UNVERIFIED.
