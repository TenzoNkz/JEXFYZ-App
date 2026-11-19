# CURRENT LIVE MAIN — BUILD #166 RELEASED / HOME COOLER IMAGE SIZING CHANGE VALIDATED — 2026-11-19

This assessment reflects the Home cooler-artwork enlargement completed after the Build #166 package. It is a source/test improvement on main, not an APK release.

## Current package and validated source

- **Latest published package:** Build #166 / run `44505634022` / job `135496368532` / Issue #43 / immutable source `2ca2235a8e238bb9ca58c11ec878bbfc3f6d25fe`, terminal SUCCESS. Release ID `403010611` / tag `jexfyz-latest`; tag, Release, APK and corresponding source ZIP all match that SHA. Exactly one APK and one source ZIP; fresh downloads, checksums, ZIP integrity, V1/V2/V3 signature and pinned signer passed.
- **New Home sizing source:** `lib/main.dart` increases the cooler column from flex 13 to flex 14 and applies a uniform `Transform.scale(scale: 1.08)` anchored at `Alignment.centerRight`. The image still uses `BoxFit.contain`, original asset `assets/jexfyzcooler.png`, computed `imageHeight`, and the same 360-dp master canvas. Seven metric rows remain 45 dp; Home header, NOTIFY slot, tabs, themes, localization and BLE/telemetry state are unchanged.
- **Regression test:** `test/widget_test.dart` now checks the image path/height, flex 14, scale 1.08, centered-right alignment, `BoxFit.contain`, rejects `BoxFit.cover`, and retains the seven-row 45-dp invariant.
- **Design contract:** `DESIGN_NOTES.md` records the owner screenshot correction, preserved transparency/aspect-ratio contract, protected Home structure, and required visual acceptance matrix.

## Latest hosted Validation Only evidence

- **Validation Only #48:** run `44508252306` / job `135505409417`, source SHA `53852b57fc6cb542a88f16d8863cc12a93c3ac80`, terminal SUCCESS.
- Flutter 3.47.2 / Dart 3.13.2.
- Locked dependencies PASS.
- Read-only Dart formatter PASS; 18 files checked, 0 changes. Formatter apply and formatter commit SKIPPED.
- Analyzer PASS with 107 info-level diagnostics, zero warnings and zero errors.
- Flutter tests **205/205 PASS**, including the new Home cooler sizing regression contract and the existing seven-row height invariant.
- This establishes hosted Flutter source/test validation for the new sizing change. It is **not** an Android APK build, signing/release check, actual device screenshot or OEM visual acceptance.

## Relevant source and current main state

- Main HEAD at Validation Only #48 checkout: `53852b57fc6cb542a88f16d8863cc12a93c3ac80`; recursive tree 140 entries / 94 blobs / 46 trees / `truncated=false`.
- Live `lib/main.dart` blob: `801341d383fd57c68acba1b466da733ea22e335a`.
- Live `test/widget_test.dart` blob: `12bf6f20356796f158dfab9c72092579bace8f2f`.
- Live `DESIGN_NOTES.md` blob: `89a267cb225cebe897a403afcdce21b87cb9ac64`.
- New cooler photo remains `assets/jexfyzcooler.png`, blob `827289e130eda890d853f347b8c6aef4e90c5fee`, registered in `pubspec.yaml`. Actual PNG pixel/alpha inspection and full screenshot acceptance remain **VISUAL NOT VERIFIED**.

## Readiness and next authorization

- **SOURCE / HOSTED VALIDATION: PASS.** No analyzer/test/formatter gate remains open for the current sizing patch.
- **LATEST APK STILL BUILD #166:** Build #166's immutable source `2ca2235a8e238bb9ca58c11ec878bbfc3f6d25fe` predates the Home flex/scale change, so the published APK does not yet contain the larger cooler presentation.
- **APP BUILD AUTHORIZATION: NOT GRANTED BY THIS EKSEKUSI FULL interaction.** Do not trigger a build from this mode. A fresh explicit `Eksekusi Build App!` command is required before one new guarded package/release attempt. Then repeat the live pre-trigger checks, use a fresh owner-authored issue with the exact existing title/token, and do not reuse Issue #43.
- **Visual outcome remains VISUAL NOT VERIFIED** until actual post-change Android screenshots are inspected at 350-dp/420-dp, English/Indonesian, Light/Dark, portrait and constrained-height states. Check full silhouette/no crop, balance against the metric column, label clearance, NOTIFY gap and safe margins. A passing test suite is not a visual pass.
- No Firmware/BIN, Firebase, OTA, flashing, physical BLE/RF, thermal/electrical or device operation was performed or authorized.
