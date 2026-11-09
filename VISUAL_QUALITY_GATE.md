# JE X FYZ / JE Cooler — Visual Quality Gate

Status: canonical visual-review and UI acceptance checklist. Apply with `PRODUCT_DESIGN_CONSTITUTION.md`, `DESIGN_NOTES.md` and the relevant Flutter skills.

## 1. Purpose

This gate prevents visually inconsistent, inaccessible, misleading or unverified UI changes from being accepted as complete. Passing a Flutter test or App Build does not, by itself, mean that visual quality passed. A source review or a generated mockup does not prove actual Android rendering.

Use this gate for Home, Bluetooth/Connection, Settings, Floating Monitor, dialogs, sheets, controls, icons, animations, typography, layout and other user-facing App surfaces.

## 2. Review record

For each non-trivial UI change, record:
- Commit/source SHA and affected screens/components.
- The user-visible problem and the approved reference used.
- Viewport size in logical dp, physical screenshot dimensions and Android density/configuration where available.
- Language, theme, text-scale/accessibility configuration and relevant device state.
- Screenshots before and after, with matching conditions when comparison is meaningful.
- Which checks passed, failed, were not run or remain unverified.
- Any approved exception and its owner/design reference.

Do not claim a screenshot was captured or inspected unless it was actually provided or produced and reviewed.

## 3. Mandatory review sequence

### Gate A — Contract and scope

- [ ] Confirm the user request and avoid redesigning beyond it.
- [ ] Read `PRODUCT_DESIGN_CONSTITUTION.md`, relevant `DESIGN_NOTES.md` sections and the applicable App/Flutter skill.
- [ ] Identify the exact widget/page, shared components, ThemeData/style owner, data source and interaction owner.
- [ ] Record the protected layout, localization, color, state, telemetry, BLE and safety contracts.
- [ ] Check whether an existing shared component already solves the problem.
- [ ] Identify the primary user task and the visual hierarchy expected for that screen.

### Gate B — Visual craft

- [ ] The screen looks coherent with the established JE Cooler Home identity and its approved page-specific contract.
- [ ] Primary, secondary and tertiary information have clear and consistent hierarchy.
- [ ] Baselines, alignment, padding, gaps, widths, heights and component edges are deliberate.
- [ ] Typography uses consistent semantic roles; no arbitrary one-off font-size/weight drift.
- [ ] Color and semantic states follow the existing theme and approved status mapping.
- [ ] Icons use a consistent family/weight and have clear meaning.
- [ ] Surfaces/cards/borders/radii/effects are purposeful; redundant containers and decorative clutter are removed.
- [ ] Empty space, content density and line lengths feel balanced; important content is not crowded or lost.
- [ ] There is no clipping, overflow, text collision, accidental truncation or awkward wrapping.
- [ ] No fake telemetry, placeholder state or decorative visualization misrepresents the device.
- [ ] Motion is purposeful, phase/lifecycle safe, performant and consistent with the state it depicts.

### Gate C — Interaction and state completeness

- [ ] Every actionable control performs its advertised action and provides feedback.
- [ ] Enabled, disabled, pressed, focused, loading, success and error states are coherent where applicable.
- [ ] Bluetooth-dependent screens cover disconnected, scanning, connecting, connected and failure states where relevant.
- [ ] Unknown/disconnected measurements remain unknown; ACK is not substituted for telemetry.
- [ ] Error messages are concise, localized and actionable; raw protocol/debug identifiers are not exposed.
- [ ] Dialog/sheet dismissal, keyboard, insets, back navigation and lifecycle behavior are checked where relevant.
- [ ] No visual treatment suggests an action or physical output is available when safety/protocol gating forbids it.

### Gate D — Viewport, density and content

Run the matrix cases that apply to the changed surface; do not assume every screen shares the same layout contract.

| Dimension | Required coverage |
|---|---|
| Existing JE Cooler width contract | 350-dp and 420-dp cases for surfaces covered by the 360-dp master-canvas DPI contract |
| Other viewport/orientation cases | Narrowest supported phone width, normal portrait, and landscape/other window size where the screen supports it |
| Language | English and Indonesian, including the longest relevant strings |
| Theme | Light and dark where supported |
| Content/state | Normal, empty, loading, error, disconnected/unknown, and long/dynamic values as applicable |
| Accessibility | Normal text scale and supported enlarged text/accessibility settings |
| System UI | Status/navigation bars, safe area, keyboard and insets where relevant |

- [ ] The 360-dp canvas and its DPI-compensation/physical-size invariants are preserved where required.
- [ ] Width and density are not conflated; no accidental double-scaling, hardcoded pixel assumptions or device-model assumptions.
- [ ] Content reflows or scrolls without clipping or overlap when available space changes.
- [ ] Long Indonesian/English strings and dynamic telemetry values do not break the layout.
- [ ] Larger text/accessibility configuration does not make essential actions unreachable or silently truncate critical content.

### Gate E — Accessibility and touch

- [ ] New or materially changed interactive targets aim for 48 × 48 dp or a documented, reviewed platform-specific alternative.
- [ ] Existing documented 40–42 dp compact Connection targets are not made smaller; their legacy exception is not described as full platform compliance.
- [ ] Contrast is checked for normal/large text, status colors, controls and disabled states; color is not the only state cue.
- [ ] Semantics, accessible labels, focus order and screen-reader announcements are meaningful.
- [ ] Interactive controls remain separated enough to avoid accidental adjacent activation.
- [ ] Animation and flashing do not create distraction or accessibility hazards.

### Gate F — Evidence and regression

- [ ] Changed Dart is formatted and static analysis is reviewed when the Flutter toolchain is available.
- [ ] Relevant widget/golden/source-contract tests are selected based on behavior, not just source-string convenience.
- [ ] Visual screenshots are captured from the actual app/emulator/device at the source SHA under review.
- [ ] Before/after comparison uses equivalent conditions; dynamic regions are controlled or excluded from pixel-diff interpretation.
- [ ] A second-pass reviewer challenges the design for hierarchy, inconsistency, clipping, misleading state and accessibility. For major/high-impact redesigns, seek an independent human/agent review when available; otherwise mark the review as author self-review, not independent approval.
- [ ] Physical Android/OEM rendering is checked when device access is available and the change materially depends on system bars, fonts, density or OEM behavior.
- [ ] Only tests and checks actually run are marked passed. Missing toolchain/device/screenshot evidence remains NOT RUN or UNVERIFIED.

## 4. Rejection conditions

Reject the UI change or leave it incomplete when any of these is true:
- The change violates an owner-approved design or behavior contract.
- Primary hierarchy is unclear or the screen becomes materially harder to scan.
- Layout clips, overlaps, hides essential content/actions or breaks the required viewport matrix.
- A style/effect/component was added without a clear purpose and makes the screen noisier.
- UI state or telemetry is false, stale, ambiguous or visually misleading.
- Localization, theme or accessibility is broken in a supported configuration.
- Interactive affordances do not work, provide feedback or respect BLE/safety gating.
- The change shrinks already-approved touch areas or introduces unreviewed accessibility regressions.
- The author marks visual PASS without actual rendered evidence for a change whose appearance is the acceptance target.

Classify findings:
- **P0 — Safety/truth violation:** false physical state, bypassed control gating, unsafe action indication or safety-contract regression.
- **P1 — Release-blocking UX/layout:** essential action inaccessible, major clipping/overlap, broken primary task or severe hierarchy failure.
- **P2 — Material quality defect:** inconsistent components, typography/spacing drift, localization overflow, insufficient contrast or confusing feedback.
- **P3 — Polish:** minor visual imbalance or non-blocking consistency issue.

P0/P1 must be resolved before acceptance. P2 must be resolved or explicitly accepted with rationale. P3 may be tracked if it does not undermine the product's identity or clarity.

## 5. Acceptance outcome

Choose exactly one outcome:
- **VISUAL PASS:** applicable gates pass with actual rendered evidence, and no unresolved P0/P1 or unaccepted P2 findings.
- **VISUAL PASS WITH ACCEPTED LIMITS:** all critical gates pass; specific remaining limitations are explicit and owner-accepted.
- **VISUAL REJECT:** at least one acceptance/rejection condition fails.
- **VISUAL NOT VERIFIED:** required screenshot, toolchain, environment or device evidence is missing. This is not a pass.

A successful build/test may be reported separately from this visual outcome. Do not merge them into one quality claim.

## 6. JE Cooler reference constraints

- Home is the main visual reference; exact page-specific rules remain in `DESIGN_NOTES.md`.
- Preserve the 360-dp master canvas and approved DPI formula for designated Settings/Connection/modal surfaces. Do not add another transform.
- Preserve compact Settings typography/spacing work and its opt-in theme scope; its runtime validation/release state must be read from current project notes.
- Preserve localization, theme inheritance, safe area/insets, status colors, BLE P1, authoritative telemetry and unknown/disconnected semantics.
- Keep the existing icon/animation contracts and never let decorative effects imply physical behavior.
- Preserve current 40–42 dp compact controls until separately reviewed; target at least 48 × 48 dp for new/changed interactive targets where feasible.
- App Build, Firmware, OTA and device-operation authorization remain governed by `MASTER_PROMPT.md`, not this visual checklist.

## 7. Official baseline references

- [Flutter accessibility checklist](https://docs.flutter.dev/ui/accessibility) — active interactions, TalkBack/VoiceOver, contrast, target sizes and large text settings.
- [Flutter UI design and styling for accessibility](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling) — contrast and touch-target guidance.
- [Android responsive/adaptive design](https://developer.android.com/develop/ui/views/layout/responsive-adaptive-design-with-views) — adapting to available window space and form factors.
- [Android window size classes](https://developer.android.com/develop/adaptive-apps/guides/use-window-size-classes) — viewport-based layout guidance, distinct from a device's physical screen identity.
- [WCAG 2.2 contrast minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) — contrast criteria and exceptions.
