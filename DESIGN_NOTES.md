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

## Dashboard indicator motion and manual voltage selector

- The user explicitly replaced the earlier Home-icon-silhouette lock on 2026-10-17. Redesign all animated dashboard indicators as integrated, restrained 2D silhouettes with organic phase-continuous motion. Avoid decorative stacks of glow, rings, sparks, flames, or highlight sweeps. Preserve semantic color, bounded Canvas geometry, brand identity and layout.
- State changes use a separate eased activity transition. On OFF, animated detail continues through the fade before pausing; on ON, the retained phase advances to the next equivalent cycle boundary rather than restarting at frame zero. Periodic shapes must match at the loop seam, including thermal flames.
- Peltier is one six-branch crystal shape with subtle self-motion, not orbiting sparks. Fan is one coherent rotor; Battery/Hotside use internal thermal fill; Voltage one bolt; Adaptive one morphing loop; LED one travelling wave; Bluetooth has no ripple rings. All motion is illustrative, not telemetry or a claim about cooling performance.
- The manual VOLTAGE rows remain neutral. 5V/9V/12V labels keep red/green/blue semantic colors, while the active toggle uses the theme primary color and has no redundant check glyph. Do not alter selector commands, lock conditions or authoritative telemetry behavior.

- LED contract: RGB ON/OFF controls only custom RGB effects. Voltage, thermal/safety, Adaptive, OTA/error and other system indicators remain independent; saved master Brightness applies to every physical WS2812 indication. Phone-side preview remains readable at low hardware Brightness.

## Visual-change protocol

1. Inspect the exact latest reference or source image.
2. State which elements are locked and which are requested to change.
3. Change only authorized elements.
4. Verify square ratio, symmetry, mounting holes, interior pattern, logo shape and flat-print constraints before delivery.
5. Do not overwrite an approved design with a speculative alternative.
