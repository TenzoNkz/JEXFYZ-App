---
name: flutter-quality-and-regression
description: Use when designing, updating, or reviewing Flutter/Dart tests, source-contract checks, widget tests, analyzers, formatting, test failures, or regression coverage for JE Cooler.
---

# Flutter Quality and Regression Engineering

## Objective
Turn each requirement into observable acceptance evidence and prevent tests from becoming brittle or misleading.

## Visual acceptance integration

For any UI-facing test plan or regression review, apply `VISUAL_QUALITY_GATE.md` in addition to behavioral tests. Define the applicable viewport, locale, theme, text scale, device-state and system-inset matrix before implementation. Include screenshot/golden coverage when it gives reliable value; control or mask dynamic telemetry/animation rather than asserting unstable full-screen pixel identity. Inspect actual Android screenshots for the final visual claim.

New/materially changed interactive targets should aim for 48 × 48 dp. The documented 40–42 dp compact Connection controls are a legacy project-specific constraint: never shrink them further and do not claim general platform compliance without a separate review. A passing widget test is not a visual pass; use the distinct visual outcomes in `VISUAL_QUALITY_GATE.md`.

## Test-design procedure
1. Rewrite the requirement as one or more observable behaviors with preconditions, action, expected result and safety invariant.
2. Build a traceability table: requirement → source owner → test type → exact test → evidence status.
3. Choose the cheapest meaningful test first: pure unit test, parser/model test, widget test, source-contract test, then integration/device validation.
4. Prefer behavioral assertions over exact source-string matching. Use source-contract checks only when the contract is intentionally structural (for example command order, unique identifier or protected workflow guard).
5. For source-contract tests, assert stable semantic tokens/ordering and avoid brittle whitespace or large exact code fragments. Keep tests synchronized when an intentional source wrapper/signature changes.
6. Add negative and boundary cases: disconnected/unknown state, stale telemetry, duplicate/delayed ACK, reconnect during sync, cancellation, malformed input, migration from old schema, narrow viewport, long localized text and lifecycle disposal.
7. Review the tests themselves for false positives, vacuous assertions, over-mocking, test-order dependencies and assertions that merely restate implementation.
8. Never weaken or delete an existing regression test simply to make a failing change pass. Repair the contract or source root cause.

## Validation sequence
- Check whether the toolchain exists before invoking commands.
- Run formatter on changed files.
- Run the narrowest focused test.
- Run analyzer/type checks.
- Run the full test suite.
- Inspect actual exit codes and logs. If a tool is absent, record BLOCKED / NOT RUN, not FAILED and not PASSED.
- Validate Android/native/device behavior separately when widget tests cannot establish it.

## Result labels
Use STATIC SOURCE CHECK, TESTED, VERIFIED CI, DEVICE VERIFIED, BLOCKED / NOT RUN and UNVERIFIED precisely. State command, environment, source SHA and actual result when available.

## JE Cooler regression themes
- 360-dp DPI canvas geometry and scale invariance.
- Settings compact tokens and 40–42 dp legacy Connection targets; new/changed targets aim for 48 × 48 dp.
- Screenshot-based visual acceptance and separate VISUAL PASS / REJECT / NOT VERIFIED outcomes.
- BLE P1 session readiness, command/ACK/telemetry ordering and disconnected values.
- Notification/localization consistency and stable IDs/channels.
- Floating Monitor persisted schema migration and telemetry authority.
- OTA lifecycle state and recovery (only within explicit authorization).

## Guardrails
No test execution or source edit in Diskusi. Eksekusi Full only authorizes the requested tests/change. App Build/release still requires Eksekusi Build App!.
