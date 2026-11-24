# CURRENT LIVE MAIN — BUILD #167 RELEASED / APP VALIDATION + RELEASE VERIFIED — 2026-11-24

This is the current App pre-build/packaging snapshot. Build #167 has already completed and published the Home cooler sizing correction. Do not trigger another build merely to repeat successful CI.

## Current package and source

- **Latest published package:** Build #167 / Actions run `44510421466` / job `135512909555` / Issue #44 / immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`, terminal SUCCESS. All steps 1–21 and cleanup 39–43 SUCCESS.
- **Release parity:** Release ID `403010611`, tag `jexfyz-latest`; Release target, Git tag and embedded source marker match the exact Build #167 source.
- **APK:** `JEXFYZ-release.apk`, 56,180,827 bytes, SHA-256 `d7c461478e033b4598d1744e2ea7ec969eea8046bf5e4a3d6caaf511bc461691`. V1/V2/V3 and pinned certificate checks passed.
- **Matching source ZIP:** `JEXFYZ-corresponding-source.zip`, 3,259,558 bytes, SHA-256 `58711342358639695624bbe05cc598220c9f20710bb04deaa785b93b85ca1546`; source marker matches the exact package source. Step 21 freshly downloaded and verified both Release assets.
- **Validation:** Validation Only #49 source-only formatter 18 files / 0 changes, analyzer 107 info / zero warnings-errors, Flutter tests 205/205 PASS. Build #167 analyzer 107 info / zero warnings-errors, Flutter tests 205/205 PASS, Android Gradle BUILD SUCCESSFUL in 2m59s. Native Android App JUnit tasks were NO-SOURCE; no native JUnit case ran.
- **Home cooler correction packaged:** flex 14, uniform 1.08× scale at Alignment.centerRight, BoxFit.contain retained, seven metric rows remain 45 dp. Source SHA and asset details are in APP_BUILD_REPORT.md and PROJECT_STATE.md.
- **Remaining visual gate:** VISUAL NOT VERIFIED. Actual Android screenshots are still required at 350-dp/420-dp, EN/ID, Light/Dark, portrait/constrained height. Check full cooler silhouette/no crop, longest metric labels, NOTIFY clearance, margins and balance.
- **Retained release warnings:** self-signed/untrusted PKIX certificate chain and META-INF signature-coverage warnings. Explicit V1/V2/V3 checks passed; warnings remain unresolved.
- **Scope boundary:** no Firmware compile/BIN, Firebase, OTA, flashing, BLE field, thermal/electrical or physical-device acceptance is inferred from this App release.

**Readiness decision:** Build #167 is already released. No new App Build is indicated absent a demonstrated source defect and a fresh explicit `Eksekusi Build App!` authorization. A future source repair belongs in Eksekusi Code Full! first, not in Discussion or this report.


## Quality readiness review — Diskusi assessment — 2026-11-25

- **Evidence baseline:** current main was inspected at commit `943ab579827265dc63caa1dec3f80b4244ac61a0` (141 tree entries, recursive tree not truncated). Build #167 remains the latest published APK; Validation Only #56 is the latest observed source-only CI success (212/212 Flutter tests, formatter clean, 107 info diagnostics, zero warnings/errors). These are hosted source/build checks, not whole-device or visual acceptance.
- **Visual outcome remains VISUAL NOT VERIFIED:** only one owner-provided Home screenshot (English / Light / disconnected) has been reviewed. No complete source-SHA-tagged screenshot matrix covers 350/420 dp, EN/ID, Light/Dark, connected/disconnected/error, constrained portrait, enlarged text and reduced motion, nor the secondary screens/native Floating Monitor.
- **Repository QA infrastructure gaps (CURRENT TREE CHECK):** no `integration_test/` directory, no checked-in golden/screenshot test suite, no Gradle Wrapper files under the inspected wrapper paths, and no `.github/dependabot.yml`. The read-only PR validator exists, but no open PR was present and no PR-triggered run was observed; the workflow has not yet been exercised by a normal PR.
- **Native/device coverage:** Build #167 Android JUnit task was `NO-SOURCE`; it did not execute native App JUnit test cases. Flutter widget/hosted tests do not establish OEM permissions, notifications, overlays, BLE/P1, radio or physical cooler behavior. Those require emulator/physical Android and actual hardware.
- **Performance:** Usage Statistics long-session CPU/memory/storage soak (1h/6h/24h) remains unverified. Profile the current implementation first; preserve SQLite v2/migration, 30-day retention, raw 1-Hz samples, explicit gaps, P1 freshness and bounded queue semantics.
- **Separate security tracks:** BLE App-only identity remains NOT IMPLEMENTED; Online OTA server identity remains unauthenticated while `setInsecure()` is used. These are distinct high-priority architecture/security projects with separate authorization; do not fold them into UI, dependency or build work.
- **Recommended sequence:** (1) capture a reproducible Build #167 Android baseline and finish the visual matrix; (2) implement the already-proposed staged UI/motion work with reduced-motion, state-truth and lifecycle tests; (3) add `integration_test` and screenshot/golden regression coverage, then native Patrol only for required OS UI flows; (4) profile Usage Statistics and native Floating Monitor on representative devices; (5) exercise PR validation, then separately decide required checks/Dependabot with human review and no auto-merge; (6) migrate Flutter/Material UI/AGP/Gradle/Kotlin/packages in a compatibility matrix with a checked-in checksum-verified Gradle Wrapper; (7) scope BLE identity and OTA trust separately.
- **Tooling decision:** GitHub, Figma and Context7 are sufficient connected ChatGPT integrations for the current roadmap. Prioritize an owner-controlled Android Studio + SDK/ADB + AVD + Flutter/DevTools workstation and a physical Android phone + JE Cooler unit. No extra ChatGPT plugin or animation package is currently justified.
- **Scope/evidence:** this is a Diskusi static repository/workflow-metadata assessment. No App source, tests, dependencies, config, workflow, build, release, Firmware, Firebase, OTA, flash or device operation changed or ran.

---

## HISTORICAL / SUPERSEDED — pre-Build #167 packaging audit (2026-11-19)


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
