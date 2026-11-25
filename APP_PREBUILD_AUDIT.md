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

**Readiness decision:** Build #167 is already released. No new App Build is indicated absent a demonstrated source defect and a fresh explicit `Eksekusi Build App!` authorization. A future source repair belongs in Eksekusi Code! first, not in Discussion or this report.


## CODE_FULL implementation increment — static action glyph lifecycle — 2026-11-26

**Status: SOURCE + REGRESSION IMPLEMENTED / VALIDATION ONLY #58 SUCCESS / NOT RELEASED.**

- Replaced the 12 production `JexAnimatedIcon.glyph` call sites in `lib/main.dart` with the existing `JexAnimatedGlyph` stateless widget. Removed the obsolete stateful `.glyph` constructor, glyph field and static build branch; this avoids allocating the seven animated-indicator controllers for plain icons.
- Preserved rendered output through the existing `RepaintBoundary` + Flutter `Icon` implementation. Removed inert `active`/`warning` parameters only from static usages; custom animated indicators remain on `JexAnimatedIcon`.
- Added static-path contract assertions and a widget rendering regression for icon data, color and size. Removed the unused `animationIsActive` local left behind after static usages stopped consuming that value.
- Commits: `ac8e9113ad947ff370b4f09aa57351ca41fdd58d` (source/test migration); `edf9a62cac12339e445dbb1fe86dbb0fc46ef3a9` (analyzer/formatter follow-up).
- Validation Only #58 / run `45660178142` / job `139367583668`, source SHA `edf9a62cac12339e445dbb1fe86dbb0fc46ef3a9`: locked dependency resolution PASS; Dart formatter PASS (19 files, 0 changed); analyzer PASS (107 info-only diagnostics, zero warnings/errors); Flutter tests **213/213 PASS**. Workflow terminal SUCCESS.
- Validation Only #57 / run `45659724890` is a retained intermediate FAILURE: formatter identified one required source-format correction and analyzer reported the obsolete `animationIsActive` local as unused. The correction was committed and #58 reran all gates successfully.
- This increment is not in Build #167 and no APK/build/release was created. Runtime profiling and actual Android screenshot/device acceptance were not run; whole-App status remains **VISUAL NOT VERIFIED**.

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


## Prepared grouped execution plan — Diskusi only — 2026-11-25

**Disposition: READY FOR OWNER SCHEDULING / NOT IMPLEMENTED / NOT AUTHORIZED.** The owner asked for discretionary action in Diskusi. This section turns the verified gaps into bounded work packages; it does not authorize source changes, test execution, App Build, Firmware, Firebase, OTA, flashing or device work.

### WP0 — Capture a reproducible Build #167 baseline

- Do not rebuild #167 just to obtain screenshots. Use the existing installed Build #167 APK as the comparison baseline where available.
- Capture actual Android screenshots and record device model, Android version, logical dp size, density/DPI, orientation, text scale, locale, theme, reduced-motion preference, connected/disconnected/error state and exact installed App/build provenance where known.
- Cover Home and all major App surfaces: Voltage/Control/Adaptive/LED/Temperature; Bluetooth Connection; Settings/subpages; Usage Statistics; dialogs/sheets; Firmware Update presentation; and the native Floating Monitor separately.
- If exact installed source provenance or a matrix dimension is unavailable, preserve that limitation in the review record. Do not mark whole-App VISUAL PASS from the existing single Home / EN / Light / disconnected screenshot.

### WP1 — Test foundation and motion/Home correction

**Likely touchpoints:** `lib/main.dart`, `lib/jex_animated_glyph.dart`, `test/widget_test.dart`, with canonical references in `DESIGN_NOTES.md`.

- Establish a shared JE motion contract using existing Flutter APIs; no animation package is justified.
- Explicitly read platform reduced-motion preference through the current Flutter API and stop/replace nonessential repeating loops with stable visuals. Do not rely on shortening an infinite controller duration and do not globally override controller behavior used by scroll/physics.
- **COMPLETED sub-item (2026-11-26):** the 12 `JexAnimatedIcon.glyph` production call sites now use the existing stateless `JexAnimatedGlyph`; the obsolete stateful glyph constructor/branch was removed and a widget-render regression was added. Validation Only #58 passed formatter, analyzer and 213/213 Flutter tests. See the CODE_FULL increment above and `DESIGN_NOTES.md`. No performance claim is made without a device profile.
- **COMPLETED sub-item (2026-11-26, source commit `94cddc93ebee26b3edc35f4ae5e567b886a3ffe5`; formatter-only follow-up `2fab1f1313d22152fdafbc78131b07c3deae7fb7`):** the LED preview now keeps its left/right arrows outside the per-frame `AnimatedBuilder` and passes the invariant mode label through `AnimatedBuilder.child`. The phase-driven builder continues to calculate the LED levels/colours from the anchored `Stopwatch` clock. A widget regression checks stable mode-label/arrow widget identity across a 120-ms tick and that a mode-name update is reflected. Validation Only #63 / run `45688790870` / job `139468394666` completed SUCCESS on source `94cddc…`; formatter initially changed only `lib/main.dart` and `test/widget_test.dart`, then the post-format check was clean (19 files / 0 changed), analyzer succeeded and the full Flutter suite passed **216/216**. The hosted run's `head_sha` is `94cddc…`; its formatter-only commit is `2fab1f1…`, and the current source tree includes that formatting follow-up. This is structural regression/CI evidence, not a measured FPS, jank or memory improvement.
- **COMPLETED in CODE_FULL WP1 (2026-11-26):** connected Battery/Hotside/Voltage indicators now avoid autonomous idle loops while retaining their existing measured-level and warning transitions; thresholds and telemetry values are unchanged.
- Keep Fan rotation/coast bound to confirmed state and Voltage/PWM; keep LED preview synchronized to the Firmware phase; preserve Peltier gating. **LED subtree isolation is now completed**: static arrows sit outside the ticker-driven `AnimatedBuilder`, while the static mode label is passed through `AnimatedBuilder.child`; only phase-driven LED columns/paint are rebuilt. Preserve the existing `Stopwatch` phase clock/anchor and `ledSyncRevision` re-anchor contract.
- **COMPLETED in CODE_FULL WP1 (2026-11-26):** disconnected Home Notification is neutral/informational and the submenu lock panel exposes Connect through the existing Bluetooth sheet/controller; no new BLE owner or P1 bypass was added.
- **COMPLETED source/test/hosted validation (2026-11-26):** numeric LED phase wraparound and `ledSyncRevision` re-anchor/reduced-motion clock-preservation regressions passed Validation Only #67 (219/219 tests, analyzer and formatter gates PASS). Existing reduced-motion on/off, controller disposal, Fan OFF coast and 360-dp/45-dp/asset/theme/language contracts remain in force. Android visual/device acceptance remains separately unverified.

### WP2 — Controls, Connection and Settings coherence

**Likely touchpoints:** `lib/main.dart`, `lib/floating_monitor.dart`, `lib/app_settings.dart`, existing connection/localization/widget tests.

- Apply the shared visual/motion rules to Voltage, Control, Adaptive, LED and Temperature; use one restrained keyed tab transition while preserving selection, scroll state and stable control ownership.
- Normalize pressed, focused, pending, acknowledged, telemetry-confirmed, disabled, locked and error states. A command ACK must never paint a physical output as confirmed before authoritative telemetry.
- Clarify Bluetooth permission, adapter, scan, discovery, connect, P1 sync-ready and failure states; animate only genuine transitions.
- Preserve passive Auto Connect behavior, serialized scan ownership, stale-attempt invalidation, saved device identity, settings keys/defaults, EN/ID and 360-dp canvas/DPI behavior.
- Keep existing compact Connection controls at their recorded 40–42 dp legacy dimensions; do not shrink them. Newly introduced/materially changed controls should aim for 48 × 48 dp.
- **Exit criteria:** state-matrix/widget tests for disconnected/scanning/connecting/syncing/ready/failure, pending-vs-ACK-vs-telemetry, all five tabs and lifecycle; no new BLE owner; EN/ID, Light/Dark and fixed-canvas regression tests remain green.

### WP3 — Screenshot/golden and App-flow automation

**Likely touchpoints:** new `integration_test/` and golden test assets under `test/`, with no new third-party package presumed.

- Add stable golden coverage for selected Flutter components/screens after their layout contracts are settled. Freeze or disable animation and inject deterministic telemetry; avoid brittle full-screen goldens for volatile regions.
- Add `integration_test` flows for App navigation, Settings persistence, local Usage Statistics flows and other paths that can be tested without real hardware. Use controlled fakes at an existing injection boundary; do not refactor BLE ownership solely to make a test harness easy.
- Keep real BLE/P1, Android permission dialogs, native notification/overlay and physical cooler behavior as emulator/physical-device acceptance where widget/integration tests cannot prove the platform behavior.
- Consider Patrol only if a concrete native system-UI test is needed. Do not add it pre-emptively.
- **Exit criteria:** repeatable tests on the selected emulator profile, deterministic screenshots, documented test source SHA and separate actual Android visual evidence. Golden pass is not a physical-device visual pass.

### WP4 — Usage Statistics and native Floating Monitor performance

**Likely touchpoints:** `lib/usage_statistics.dart`, `test/usage_statistics_test.dart`, `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`, `MainActivity.kt` and separate native/device evidence.

- First profile current Usage Statistics at representative 1h/6h/24h session sizes. Record summary-flush CPU time, UI/raster frame time, peak memory, SQLite size, query duration and dropped/rejected writes.
- Only if measured cost warrants it, consider incremental aggregates/windowed snapshot loads/batching; preserve schema v2, v1→v2 migration, 30-day retention, raw 1-Hz samples, timestamp weighting, session boundaries, HOT-only P1 freshness, explicit null gaps, gap-safe decimation and bounded 64 + 8 + 1 writer capacity.
- Treat Floating Monitor as native Canvas/WindowManager, not Flutter route UI. Measure draw/drag/resize/attach/detach and OEM behavior on real Android devices; do not move BLE/GATT into the service.
- **Exit criteria:** profile report before/after for any optimization; no change to stored data semantics or telemetry owner; physical Android evidence for native overlay behavior. Do not claim native JUnit coverage unless tests actually execute (Build #167's Android App JUnit task was NO-SOURCE).

### WP5 — Toolchain/dependency migration (separate batch)

- Handle Flutter/Dart/Material UI, AGP/Gradle/Kotlin, Firebase/App Check, SQLite and packages as one explicit compatibility matrix but in small independently validated steps.
- Restore a checked-in Gradle Wrapper with a verified distribution URL and checksum before relying on the wrapper as project infrastructure; reconcile this with the current Build App workflow, which has its own wrapper/setup behavior.
- Re-resolve current stable versions with Context7 and official release notes immediately before implementation. Do not reuse a version list as timeless truth.
- Move `sqflite` and its platform companions together with migration/retention fixtures. Keep the `flutter_blue_plus` update gated on confirmed commercial-license entitlement. Do not update already-current packages without a demonstrated reason.
- Keep Android `versionName "Telegram @horizontalzzz"`, application identity, target/min SDK and signing/release gates unchanged unless separately approved.
- **Exit criteria:** dependency lock stable, format/analyze/tests pass, v1→v2 and existing-install data tests pass, Build App workflow is separately proven by the authorized Build App workspace. No OTA/Firmware changes.

### WP6 — CI and repository governance (separate owner decision)

- Exercise the read-only PR validation workflow using a normal owner-approved PR before considering required status checks or a reviewed-PR-only workflow.
- Decide separately whether the project should move away from its current direct-main workflow. No branch protection/ruleset or merge-policy change is implied here.
- Only after PR validation is observed, consider controlled Dependabot for pub/Gradle/GitHub Actions with human review and no auto-merge.
- Treat the current Build App job-wide `contents: write` ceiling as a separate security-hardening item. A split read-only build/sign stage plus minimal write-enabled publish stage needs an explicit design and a separately authorized regression/build proof.

### WP7 — Separate security architecture tracks; not UI scope

- **BLE App identity:** design trusted enrollment, per-install keys, challenge-response, key rotation/revocation, ownership transfer and recovery across App/Firmware/backend. `SYNC_READY` plus Just Works bonding is not official-App identity. Requires separate explicit authorization and cross-component verification.
- **OTA server identity:** design certificate/CA identity validation, time/bootstrap assumptions and failure/recovery behavior around the current `setInsecure()` trade-off. Keep existing allowlist, redirect/status/size/image checks, safe-output sequence and recovery semantics. OTA stays protected/frozen until a demonstrated defect and separate owner authorization.
- Never fold either track into UI/motion, generic dependency upgrades or an App Build task.

### Cross-package release gates

- Keep formatter, analyzer and full Flutter tests separate from visual acceptance; Validation Only #56's 212/212 PASS is a historical source-SHA-specific result, not a claim for new changes.
- Use exact evidence labels: STATIC SOURCE CHECK, TESTED, VERIFIED CI, SCREENSHOT REVIEWED, DEVICE VERIFIED, VISUAL NOT VERIFIED.
- No Build App run or Release unless the owner separately authorizes `Eksekusi Build App!` after scoped source work and required checks. Build #167 remains the latest published package at this checkpoint.
- No source implementation or test/build/device operation is authorized by this plan. Implementation is deferred until the owner chooses the grouped execution batch and opens the separate `Eksekusi Code!` workspace.

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
