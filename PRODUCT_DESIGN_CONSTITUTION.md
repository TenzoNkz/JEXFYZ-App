# JE X FYZ / JE Cooler — Product Design Constitution

Status: canonical product-design principles. `DESIGN_NOTES.md` remains the authority for owner-approved, screen-specific visual contracts; live source and captured product output establish what is actually implemented.

## 1. Product design intent

JE Cooler is a precision companion interface for a physical thermoelectric cooler. Its UI should communicate device state and controls with the clarity of a carefully engineered hardware product.

The intended character is:
- **Precise:** alignment, sizing, spacing and state transitions feel deliberate.
- **Legible:** important device information is quickly scannable at normal use distance.
- **Calm:** visual emphasis is reserved for meaningful information, controls, warnings and feedback.
- **Coherent:** every screen feels like part of the same JE Cooler product.
- **Trustworthy:** displayed values and states are grounded in authoritative App/Firmware data.
- **Purposeful:** visual effects and motion explain state or improve interaction; they are not decoration added to fill space.

This constitution does not prescribe a speculative new brand, color palette, font family, component library or wholesale redesign. Derive the existing visual language from approved references, `DESIGN_NOTES.md`, assets and live Flutter source. Record any proposed evolution explicitly before implementation.

## 2. Authority and design baseline

Apply these sources in order:
1. The owner's explicit current design decision and supplied reference screenshot/video.
2. The applicable approved contract in `DESIGN_NOTES.md`.
3. Current App source, theme definitions, shared widgets and assets.
4. Product Design Constitution and `VISUAL_QUALITY_GATE.md`.
5. Platform guidance (Flutter/Android accessibility and adaptive-layout guidance).
6. General visual conventions and an agent's aesthetic preference.

If sources conflict, do not silently reinterpret the product. Report the conflict and preserve the more specific owner-approved contract until it is resolved.

The existing JE Cooler Home screen is the primary visual reference for the surrounding App. Settings, Bluetooth Connection, Floating Monitor, dialogs and future screens should share its visual language while using hierarchy and density appropriate to their task. "Match Home" means coherent typography, surfaces, colors, spacing logic and interaction quality—not copying every Home layout or making every screen identical.

### Protected current design decisions

- Preserve the established JE X FYZ / JE Cooler brand and approved assets. Do not replace assets or invent a new identity without an explicit design decision.
- Preserve the current Home composition and specific icon/animation contracts recorded in `DESIGN_NOTES.md`.
- Preserve the Home-equivalent 360-dp master canvas and the approved DPI compensation formula for Settings/subpages, Bluetooth Connection and designated modal surfaces. Do not add a second scale transform, change the master canvas, or replace it with generic breakpoints as part of an unrelated visual task.
- Treat the existing compact Settings/Connection implementation as **source implemented, validation pending** until its formatter, tests, analyzer, complete suite and device visual QA are observed. Do not call it released or runtime-validated based on static source inspection.
- Preserve inherited light/dark theme behavior, English/Indonesian localization, safe areas/insets, status colors, and established 40–42 dp compact control hit areas until a separately scoped interaction/accessibility review approves a change. Never shrink these existing targets further for visual density.
- Preserve BLE P1 gating, authoritative telemetry, disconnected/unknown semantics, safe outputs and all Firmware behavior. A design treatment must never imply a control is available or an output is active when the underlying state says otherwise.
- Preserve all protected project contracts in `MASTER_PROMPT.md` and `APP_NOTES.md`.

## 3. Core visual principles

### 3.1 Hierarchy before decoration

Every screen must make the primary task, current state and secondary details distinguishable. Use size, weight, position, spacing, grouping and restrained color to establish hierarchy. Do not give every card, label or icon equal emphasis.

A user should be able to answer quickly:
- What is the current device/connection state?
- What information is most important on this screen?
- Which actions are available now?
- What changed after an interaction?
- What should be done when something fails?

### 3.2 Density with breathing room

Use space intentionally. Avoid both cramped layouts and oversized empty areas. Repeated rows, cards, sections and controls should follow a consistent spacing rhythm. A compact design must remain readable and touchable; do not make text, icons or hit areas smaller merely to fit more content.

### 3.3 Restraint and purpose

Cards, borders, gradients, shadows, blur, glow, badges and animation are tools—not defaults. Add an effect only when it establishes grouping, depth, state, affordance or feedback. Remove it when it competes with data or adds no information.

A gradient or glow is not automatically wrong; an unexplained decorative effect is. The same rule applies to excessive rounded surfaces, repeated cards, floating labels, accent colors and ornamental icons.

### 3.4 Consistent components

Prefer shared components and established ThemeData/style helpers over one-off implementations. Before adding a new widget variant, inspect existing usages and determine whether the difference is semantic, state-driven or merely accidental styling drift.

Keep icon families, stroke/weight, corner treatment, typography roles, control states and motion behavior coherent. Do not mix unrelated icon packs or create near-duplicate components without a documented reason.

### 3.5 Honest device information

The UI is a product interface to physical hardware, not a concept dashboard:
- Use authoritative telemetry for physical state.
- Never substitute placeholder, stale, inferred or fabricated readings for unknown values.
- Keep command intent, protocol ACK and telemetry-confirmed output state distinct.
- Do not use decorative charts, fake activity, simulated percentages or ungrounded labels to make the screen look active.
- Warning and safety states must be distinguishable without relying on color alone.
- Visual animations must reflect the approved state/phase contract and stop/reset when required.

### 3.6 Responsive by contract

First identify the screen's actual layout contract. The JE Cooler 360-dp master canvas is a deliberate existing design contract for specified surfaces; it is not permission to scale every widget arbitrarily or a general substitute for responsive layout design.

Preserve the approved 350-dp/420-dp DPI behavior and fixed-physical-size assumptions where applicable. For other form factors, available window space, orientation, keyboard/insets and multi-window behavior, adapt content without clipping, overlapping or distorting the product hierarchy. Do not interpret 350 and 420 dp as universal device breakpoints.

### 3.7 Localization and content quality

English and Indonesian are first-class UI languages. Check real translated strings, not only short placeholder labels. Allow for different string lengths, consistent terminology, readable line breaks and action-oriented error messages. Never expose raw protocol tokens, internal reason IDs, debug output or implementation terminology to users.

### 3.8 Motion and feedback

Motion should communicate a state transition, progress, causality or affordance. It must be restrained, consistent, interruptible where appropriate, lifecycle-safe and performant. Avoid perpetual motion that does not encode live state. Respect the approved icon animation contracts and do not imply telemetry that is unavailable.

## 4. Anti-AI-slop rejection rules

Reject or revise a proposal when it contains any of the following without a concrete product reason:
- A generic dashboard/card template that ignores the existing JE Cooler visual language.
- Extra cards, containers, separators, pills or badges that repeat information or create unnecessary nesting.
- Random gradients, neon glow, glassmorphism, shadows, blur, ornamental borders or oversized rounded corners.
- Mixed icon styles, arbitrary emoji as interface icons, inconsistent glyph sizes or decorative symbols with unclear meaning.
- Arbitrary font sizes, weights, radii, spacing or colors invented independently for one screen.
- All-caps labels, excessive microcopy, redundant headings or vague AI-style phrases that reduce scanability.
- Fake charts, fabricated device readings, simulated connection activity or status indicators not backed by state.
- Animations that are ornamental, distracting, out of phase, continue in an invalid state or imply physical output.
- A complete redesign in response to a narrow alignment, sizing, wording or bug-fix request.
- Visual density achieved by shrinking text or touch targets below usable sizes.
- A screenshot mockup or generated image being presented as proof of the actual Flutter/Android rendering.
- A change justified only with phrases such as "looks modern", "more premium" or "more futuristic" without explaining the user problem and measurable design effect.

These are review triggers, not a ban on a specific visual technique. A technique may be retained when its purpose, consistency and effect are demonstrated.

## 5. Design-system governance

Before introducing or changing shared design tokens:
1. Inspect existing `ThemeData`, theme extensions, shared widgets, local style helpers, asset usage and approved screenshots.
2. Identify the current source of truth and all affected screens.
3. Reuse an existing token if it expresses the intended semantic role.
4. Add a new token only when a genuinely distinct semantic role exists; avoid aliases and near-duplicates.
5. Explain the token's role, light/dark behavior, states, contrast and consumers.
6. Audit all affected usages and capture representative visual output.
7. Update the approved design documentation when the token becomes a durable contract.

Do not create a second design system alongside the existing Flutter theme or hardcode a parallel palette inside individual pages.

## 6. Design-change decision record

For a material visual change, record a concise decision before or alongside implementation:
- **Problem:** what user-visible issue exists, with screenshot/source evidence.
- **Scope:** which screen, states and reusable components are affected.
- **Existing contract:** what must remain unchanged.
- **Approach:** the selected treatment and why it solves the problem.
- **Alternatives:** at least one viable alternative for a meaningful design decision.
- **Trade-offs:** impact on hierarchy, density, accessibility, localization, adaptive behavior and maintenance.
- **Acceptance:** the relevant checks from `VISUAL_QUALITY_GATE.md`.

Routine typo fixes or a one-value alignment correction do not require a heavyweight decision record. Do not manufacture process for trivial changes.

## 7. Accessibility baseline

- Design new or materially changed interactive targets toward at least 48 × 48 dp, subject to platform context and spacing. Keep the target area distinct from the visible icon/glyph size.
- The currently documented 40–42 dp compact Connection controls are a legacy project-specific constraint, not proof of general accessibility compliance. Do not shrink them. Review them explicitly before claiming the whole interface meets platform target-size guidance.
- Aim for at least 4.5:1 contrast for normal text and 3:1 for large text, while checking disabled/status states and non-text controls separately.
- Preserve meaningful semantics, labels, focus behavior and screen-reader descriptions for interactive controls.
- Do not communicate state by color alone; pair status color with text, icon shape or another clear cue.
- Check system text scaling/accessibility settings. The existing fixed-canvas/text-scaling behavior is a protected implementation contract that must be assessed rather than silently changed; never claim large-text accessibility without verifying it.
- Avoid flashing, excessive motion and motion that can be disabled or reduced only by adding unverified assumptions.

Use the Flutter accessibility guidance and the linked W3C contrast guidance in `VISUAL_QUALITY_GATE.md` as the baseline references.

## 8. Definition of a professional result

A design is ready only when it looks intentional, belongs to JE Cooler, makes the task and state clear, uses consistent components, respects protected behavior, handles real content and edge states, remains usable at the required viewport conditions, and has visual evidence from the actual app.

"Professional" is not synonymous with more visual effects, more components, more colors or a complete redesign. A restrained, well-aligned and truthful screen is preferable to a visually elaborate but incoherent one.
