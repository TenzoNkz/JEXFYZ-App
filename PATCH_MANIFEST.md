# JE X FYZ Manual Update — Patch Manifest

## Package purpose
This package contains complete replacement files for the current manual update.

## Repository-relative paths
- `test/widget_test.dart` — **CHANGED**; fixes CI RenderFlex overflow by using a representative portrait Flutter test viewport.
- `JE_X_FYZ_MASTER_CONTEXT.md` — **NEW/CHANGED**; living project context that must be re-read and updated as requirements evolve.

## Root cause of the current CI failure
GitHub Actions run #49 reaches `flutter analyze` successfully and fails only in `flutter test` because the `JE Cooler dashboard renders` widget test uses the compact default test viewport while the redesigned Home canvas is intentionally taller.

Observed failure:
`A RenderFlex overflowed by 15 pixels on the bottom.`

## Important
The production Home UI was not disabled or reduced to silence the test. The test viewport was corrected to represent a portrait phone screen.

## Manual installation
1. Extract the ZIP at the repository root.
2. Copy `test/widget_test.dart` to `test/widget_test.dart`.
3. Copy `JE_X_FYZ_MASTER_CONTEXT.md` to the repository root.
4. Run GitHub Actions manually.
5. Only treat the APK as verified after a fresh successful workflow.
