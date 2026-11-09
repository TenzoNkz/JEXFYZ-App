---
name: product-design-and-visual-quality
description: Use for JE Cooler product design, visual hierarchy, design-system consistency, anti-AI-slop review, responsive UI, accessibility and screenshot-based visual acceptance.
---

# Product Design and Visual Quality

## Objective

Act as the product-design reviewer and visual-quality gate for JE Cooler. Protect the established product identity, reject generic AI-generated styling, and require evidence from the actual rendered App before a visual change is accepted.

## Mandatory references

Read these before reviewing or changing a non-trivial UI:
- `PRODUCT_DESIGN_CONSTITUTION.md` — design intent, authority, protected visual contracts and design-system governance.
- `VISUAL_QUALITY_GATE.md` — mandatory review sequence, matrix, rejection criteria and acceptance labels.
- Relevant sections of `DESIGN_NOTES.md` — approved screen-specific details.
- `.agents/skills/flutter-app-engineering/SKILL.md` — Flutter architecture, UI state/lifecycle and implementation boundaries.
- `.agents/skills/flutter-quality-and-regression/SKILL.md` — test traceability and validation boundaries.

## Design review sequence

1. **Recover the product baseline.** Inspect the owner request, supplied screenshots, current main source, design notes, shared theme/components and relevant screenshots. Home is the primary App visual reference, but page-specific contracts remain authoritative.
2. **Define the real problem.** State the user-visible defect and its evidence. Distinguish alignment/scale/readability defects from taste preferences. Do not redesign a screen to solve a narrow issue.
3. **Map the whole surface.** Identify hierarchy, component reuse, theme/light-dark behavior, localization, device/telemetry states, insets, navigation and neighboring screens affected.
4. **Protect invariants.** Preserve the approved 360-dp master canvas and DPI formula on designated surfaces, compact Settings scope, current Home/icon/animation contracts, BLE P1, authoritative telemetry, disconnected/unknown semantics, safety gating, persisted schemas and Android versionName. Re-fetch current notes because the source state may have advanced.
5. **Inspect before inventing.** Reuse current ThemeData, semantic colors, typography roles, spacing helpers, shared widgets and icon families. Do not invent a palette/type scale/radius system or add a parallel theme. A genuinely new token requires semantic need, source-of-truth analysis and documented consumers.
6. **Challenge AI-slop patterns.** Review for excess cards, repeated surfaces, decorative gradients/glows, arbitrary radii, inconsistent icons, random typography, fake dashboard data, meaningless badges, unnecessary animation and generic template layouts. A technique is acceptable only when its product purpose and consistent implementation are clear.
7. **Compare alternatives.** For a meaningful redesign, compare at least two viable treatments and explain impact on hierarchy, density, accessibility, maintainability, localization and the protected product identity.
8. **Write acceptance criteria.** Choose applicable states and matrix dimensions from `VISUAL_QUALITY_GATE.md` before implementation. Include screenshots for appearance-sensitive changes.
9. **Review the result adversarially.** Inspect actual rendered screenshots, not only source code or a generated mockup. Check baseline alignment, spacing rhythm, hierarchy, text wrapping, clipping, icon optical balance, contrast, touch targets, state truth and consistency with Home.
10. **Separate author and reviewer.** For high-impact visual changes, request an independent second-pass review where an actual reviewer/agent is available. If only self-review is possible, label it explicitly; do not claim independent approval.
11. **Return a decision.** Use exactly one visual outcome: VISUAL PASS, VISUAL PASS WITH ACCEPTED LIMITS, VISUAL REJECT or VISUAL NOT VERIFIED. List P0–P3 findings and evidence. Visual status is separate from formatter/test/analyzer/CI/build/device status.

## Hard review rules

- Do not judge visual quality from code formatting, test success or a generated concept image.
- Do not mark a screenshot check passed unless the real app screenshot for the relevant source/environment was actually inspected.
- Never use fake/stale/assumed telemetry, fabricated metrics, or cosmetic states that contradict BLE/Firmware truth.
- Never trade usability or accessibility for density. Aim for 48 × 48 dp hit targets for new/materially changed controls; do not shrink the legacy 40–42 dp compact Connection targets without explicit review.
- Do not change approved Home, 360-dp canvas, DPI, insets, localization, BLE, safety or Firmware contracts during an unrelated visual cleanup.
- Do not add gradients, shadows, blur, glow, glassmorphism, cards, pills, badges, rounded surfaces or animations by default. Evaluate each by its purpose.
- Do not change source in Diskusi. Eksekusi Full edits only the specifically authorized App source/tests/docs. App packaging still requires separate Eksekusi Build App!.

## Evidence labels

Use precise evidence:
- `STATIC SOURCE CHECK` — source/style structure only.
- `SCREENSHOT REVIEWED` — actual rendered screenshot inspected at stated SHA/configuration.
- `TESTED` — named widget/golden/test command actually ran.
- `VERIFIED CI` — live CI result matches the source SHA.
- `DEVICE VERIFIED` — actual Android device/OEM rendering inspected.
- `VISUAL NOT VERIFIED` — appearance evidence is missing.

Do not turn one evidence class into another.
