---
name: flutter-app-engineering
description: Use for Flutter/Dart app architecture, widgets, navigation, themes, state management, localization, responsive layouts, animations, Android integration, or UI regression analysis in JE Cooler.
---

# Flutter App Engineering

## Objective
Design and review Flutter changes as a complete stateful UI system, not isolated widget edits.

## Product-design requirement

For every non-trivial UI/UX task, load `.agents/skills/product-design-and-visual-quality/SKILL.md` and read `PRODUCT_DESIGN_CONSTITUTION.md` plus `VISUAL_QUALITY_GATE.md`. `DESIGN_NOTES.md` remains authoritative for owner-approved screen-specific constraints. Treat Home as the primary visual reference without copying its layout mechanically. Protect the existing 360-dp canvas/DPI formula, compact Settings scope, localization, theme, telemetry truth, BLE/safety gates and icon contracts. Do not introduce generic styling, arbitrary tokens or a redesign to solve a narrow issue.

## Review sequence
1. Identify the UI owner: route/page, state notifier/store, BLE/telemetry source, persistence schema, localization source and Android/native bridge.
2. Trace data flow from firmware/BLE/parser through authoritative model state into widgets. Keep command intent, acknowledgement and physical telemetry distinct.
3. Inspect widget lifecycle, async callbacks, mounted checks, timers/streams disposal, navigation ownership, rebuild scope and error states.
4. Preserve existing design contracts: Home-equivalent 360-dp canvas/DPI scaling, compact Settings theme opt-in, safe insets, theme inheritance, localization, tap-target sizing and approved visual hierarchy. Re-fetch current design notes and source; do not rely on this list if a newer decision exists.
5. Check small/large logical widths, text scaling behavior, orientation, long localized strings, empty/loading/error/disconnected states, keyboard/insets and accessibility semantics.
6. For animations, inspect controller lifecycle, ticker disposal, frame cost, phase synchronization and whether the visual is merely illustrative or represents measured telemetry.
7. For persisted settings, inspect serialization, defaults, migration and backward compatibility before changing schemas.
8. Propose the smallest change that satisfies the owner request without widening scope.

## Validation
- Use the existing Flutter/Dart version and project conventions.
- Format changed Dart files; run focused widget/unit/source-contract tests; run analyzer; then the full test suite where the environment permits.
- Distinguish source review, widget tests, hosted CI and physical Android/OEM rendering.
- When visual screenshots are supplied, compare geometry, baselines, clipping, tap areas and text hierarchy; do not infer unobserved device behavior.
- For appearance-sensitive changes, capture and inspect screenshots from the actual App at the reviewed source SHA; compare matched conditions, viewport, density, language, theme and device state. A mockup, source inspection or successful build is not visual evidence.
- Record a separate visual outcome from formatter/tests/analyzer/CI/device results using the exact outcomes defined in `VISUAL_QUALITY_GATE.md`.

## JE Cooler invariants
- Firmware telemetry is authoritative for physical state; an ACK alone never proves output state.
- Unknown/disconnected values remain unknown (for example `--`), not stale or fabricated values.
- Preserve BLE P1 synchronization/gating, localization, notification-channel identity and current persisted schema unless a scoped migration is approved.
- Preserve Android Gradle versionName exactly: `Telegram @horizontalzzz`.

## Guardrails
- No UI improvement may weaken Firmware safety or BLE gating.
- Do not reintroduce retired pages/features without a new request.
- Diskusi: read-only. Eksekusi Full: only the specifically authorized App source/tests/docs. App packaging requires separate Eksekusi Build App!
