## Latest CODE_FULL checkpoint — WP4 Batch 2 Statistics axis typography; Validation Only #213 green — 2026-11-27

- Validated App source: `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0`; recursive tree 166 entries / 120 blobs / 46 trees, `truncated=false`; current file inventory covers 120 unique tracked blobs, but path completeness is not full content review.
- Validation Only #213: run `46012060878` / job `140549796007`, exact source SHA above, terminal SUCCESS — locked dependencies PASS; formatter **44 files / 0 changed**; analyzer PASS; full Flutter suite **285/285 PASS**.
- WP4 Batch 1: `JexShapeTokens.compactControlRadius = 11.0` continues to name the matching Lock Voltage/LED compact-control corner role; existing dimensions/padding are preserved.
- WP4 Batch 2: `JexStatisticsTypographyTokens.axisLabel = 10.0` names the feature-specific Statistics chart axis typography shared by the Y-axis tick labels and the two X-axis time endpoints. Source-contract tests check the token value and exactly three painter uses. A formatter-only assertion-layout correction was committed in `test/usage_statistics_test.dart` before #213; no chart geometry, tick calculation, localization, data or persistence behavior changed.
- WP4 cross-route audit: shared layout, semantic color, typography and shape foundations exist across Dashboard, Settings, Statistics, LED and Floating Monitor. Search results show other similar numeric sizes, but their consumers occupy different component roles; no further global typography token is justified from those matches alone. Preserve chart plot geometry, 360-dp canvas/DPI compensation, device thresholds and status colors as domain-specific contracts.
- Next bounded work: continue route/consumer role classification and the Dashboard `main.dart` ownership/content audit. Any new token or extraction must have a proven semantic role, caller map, focused regression and exact-source validation.
- Still open: full Dashboard `main.dart` content/ownership audit; remaining large-module reviews; WP5 screen refinement and screenshot/design acceptance; WP6 Connection/Settings/dialogs; WP7 Usage Statistics performance/architecture; WP8 Floating Monitor Flutter/native lifecycle; WP9 screenshots/goldens/integration/platform evidence; WP10 final file/diff/governance closure.
- Evidence boundary: local Flutter/Dart/Gradle/ADB unavailable. Android/Kotlin compile, actual screenshots/OEM/device behavior, SQLite v1→v2 runtime fixture and 1h/6h/24h profile remain NOT RUN. Whole-App visual outcome **VISUAL NOT VERIFIED**. Build #167 remains latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/APK/sign/release, Firmware/BIN/OTA/Firebase production/device operation occurred.
---

## HISTORICAL — CODE_FULL checkpoint after Validation Only #198 (superseded by #205)

- Validated App source: 727f30a0f0cb6bbb14921b4a9ded77b668cc0183; source root tree 2408f2e0c1f0a430ec6d548081fd209c86452a3c; 166 entries / 120 blobs / 46 trees, truncated=false; canonical file register now covers 120/120 unique tracked paths with no duplicate rows.
- Validation Only #198: run 45986589466 / job 140463697552, exact SHA above, terminal SUCCESS — locked dependencies PASS; read-only formatter PASS (44 files / 0 changed); analyzer PASS (121 information-level diagnostics, zero warnings/errors under --no-fatal-infos); full Flutter tests 281/281 PASS.
- WP1 storage regression: seven plugin-mock tests for AppSettingsStore and KnownCoolerStore remain passing; production persistence keys/defaults/schema unchanged. Plugin failure injection and real Android secure-storage behavior remain open.
- WP2/WP3: ordered bootstrap, App root and Settings presentation remain separated. P1 frame decoding, pure command classification and per-item FIFO ACK waiters remain separate pure modules. Dashboard remains the sole BLE/GATT/P1/session/telemetry/command authority.
- WP5 Batch 1: lib/dashboard_shared_components.dart owns reusable Dashboard Card and section heading presentation. Twelve Card and seven heading usages moved from Dashboard state to Control/Temperature presentation parts. Widget contract test verifies established geometry, semantic colors, border/shadow and typography.
- WP5 Batch 2: lib/dashboard_control_components.dart owns the state-bound presentation extension for _switchRow, _jexToggle and _smoothList. Control/Temperature callsites use it; widget and Firmware QC source-contract tests were updated to inspect the moved helpers. No device/session/command/protocol owner moved.
- Still open: full Dashboard/main.dart ownership/content audit and remaining large-module review; remaining WP4 route-token audit; WP5 Home/Control/Adaptive/LED/Temperature refinement and screenshot/design review; WP6 Connection/Settings/dialogs; WP7 Usage Statistics; WP8 Floating Monitor Flutter/native split; WP9 screenshots/goldens/integration/Android/OEM evidence; WP10 final register/diff/governance closure.
- Evidence boundary: local Flutter/Dart/Gradle/ADB unavailable. Android/Kotlin build, actual screenshots/OEM/device behavior, SQLite v1→v2 runtime fixture and 1h/6h/24h performance profile NOT RUN. Whole-App visual outcome VISUAL NOT VERIFIED. Build #167 remains latest published package on older immutable source 0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81; current main is un-packaged. No Build App/APK/sign/release or Firmware/BIN/OTA/Firebase production/device operation occurred.
---

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

### Read-only Floating Monitor source audit — 2026-11-26 (Diskusi)

- **Current source identity:** main HEAD `22b02bc3c5dab2e3ed53efa47cf6bcb77a1ed690`. Reviewed blobs: `lib/floating_monitor.dart` `176a21242602eb0db44420d2a9324eebe05e95b5`; `MainActivity.kt` `cab1cabf10b57a0f5d547fccf85b76b067503c0e`; `FloatingMonitorService.kt` `8e66da2525b5cc75ef8780c2d480607328492df6`; `test/floating_monitor_layout_contract_test.dart` `4784fb775388f226d19fd4acb02beea9f7074d03`.
- **Ownership confirmed by static source:** DashboardScreen constructs FloatingTelemetry from Flutter session state and publishes it through FloatingBridge. MainActivity owns the `je_x_fyz/floating` MethodChannel host route. FloatingMonitorService owns only foreground-service and WindowManager/Canvas overlay behavior; no BLE/GATT client exists there. Flutter configuration is persisted under FlutterSecureStorage key `jexfyz_floating_v1`; native drag position, size and orientation are stored separately in SharedPreferences `jexfyz_floating_native_v1`.
- **Lifecycle reliability risk — source-derived, not runtime reproduced:** FloatingMonitorService returns `START_NOT_STICKY`. The three-second runtime health timer is owned by FloatingSettingsPage and is canceled when that page is disposed or the App leaves the resumed lifecycle state. Dashboard's `_floatingStartAttemptedForSession` prevents another start attempt after the first attempt; it is reset on App resume and BLE disconnect, not on an independently observed service death. While the same BLE session remains active, the telemetry publisher forwards `updateFloatingData`; the native data path does not start a missing service. Consequently an unexpected service termination while the Dashboard remains active and Floating Settings is not mounted may leave the overlay absent until a later resume/session reset or Settings re-entry. Treat this as a **HYPOTHESIS / reliability gap to decide**, not a confirmed device bug.
- **Test coverage gap — static inventory:** current tree contains 12 Dart test files. They cover config normalization and schema-v1 metric migration, state presentation, selected source/layout contracts, and post-start telemetry replay. No direct mocked MethodChannel test for FloatingBridge or direct FlutterSecureStorage round-trip/failure test for FloatingStore was found. Existing source-contract checks do not prove permission behavior, WindowManager attachment or service restart behavior.
- **Validation boundary:** this was a Diskusi-only STATIC SOURCE CHECK. No source/test/config/workflow edit, test, formatter, analyzer, Android build, Actions, release or physical-device validation was performed. App/OEM runtime behavior remains UNVERIFIED. This entry does not close a WP0 disposition or authorize WP8 implementation.
- **Decision needed before any handoff:** decide whether same-session automatic overlay recovery is a required product contract. If yes, specify the one health-monitor owner, retry/backoff and user-visible failure behavior, plus channel/storage tests and Android service-kill/reattach acceptance before separately authorizing Eksekusi Code.

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

### WP0 — `APP_PREBUILD_AUDIT.md` — UPGRADE / REVIEWED (2026-11-26)

- **Reviewed blob:** `602d1455647f64daa92aa64acd52af5647efe8a5`. The active owner-approved WP0–WP10 package, protected exclusions, proposed target architecture/data flow, Quiet Luxury / Precision Instrument design direction, all screen contracts, motion rules, dependency order, acceptance/stop gates, native Floating Monitor recovery proposal, Build #167 boundary, and historical Diskusi/second-opinion planning sections were inspected.
- **Current-state correction:** the opening status had a stale 63/96 count and directed the next review to `APP_BUILD_REPORT.md`. The live register now records 67/96 after the ledger and App behavior reference were reviewed. This audit document is the current path being closed; the next sorted pending file is the first immutable archive.
- **Implementation status:** WP0 remains incomplete; seven formatter-touched Dart/test files still need whole-file reviews, and `main.dart` remains the primary architectural concentration. WP2–WP10 are not marked complete merely because a plan exists. The existing staged sequence and safety gates remain authoritative.
- **Design/evidence decision:** keep the existing assets/font/palette/Home composition and 360-dp contracts protected absent evidence and explicit design review. Actual screenshots and Android/OEM/native evidence are still required; `VISUAL NOT VERIFIED` remains the correct whole-App status. Profiling is required before Usage Statistics/native overlay optimization.
- **Disposition:** `UPGRADE / REVIEWED`; this file's active count/checkpoint text is reconciled below. No source, tests, workflows, Firmware, OTA, Firebase, signing, assets or release artifacts were modified.


### Latest CODE_FULL implementation checkpoint — passive BLE rediscovery + AppSecurity extraction — 2026-11-26

- **WP1 passive rediscovery correction:** `_startDisconnectRediscovery()` consumes the asynchronous `_connect(result.device)` failure path and logs the failure. Manual connection flow, scan-generation fences, GATT ownership, P1 and command semantics are unchanged. Regression passed Validation Only #85 (226/226).
- **WP2 App security adapter:** `lib/app_security.dart` owns the existing `je_x_fyz/security` channel and fail-closed official-build decision. Android accepts only Boolean true; false/null/channel errors deny; non-Android behavior remains unchanged. `main.dart` calls the adapter; the Tamper contact action retains its existing method. Kotlin certificate/signing implementation was untouched.
- **Validation Only #86:** 220 passed / 10 failed because ten widget source-contract tests used the removed channel declaration as the painter end sentinel. The painter remained. #87 updates those boundaries to the actual following `TamperApp` class; all 230 tests pass.
- **Validation Only #87:** run `45865736407` / job `140067960188`, tested SHA `59fb624120b01ba505d23691df0928e55eefed3b`, terminal SUCCESS: locked deps, formatter/post-format, analyzer (106 info-level) and **230/230 Flutter tests** PASS. Formatter-only follow-up is `16b9f78f384011ca59def5e0ac32bb6bc33e4178`.
- **Not complete:** full `main.dart` audit/state extraction and screen redesign remain open. No Android/Kotlin build, screenshot/OEM/device, SQLite upgrade fixture or performance soak was run.


## CODE_FULL implementation checkpoint — App bootstrap + Settings presentation extraction — 2026-11-27

- **Current main source checkpoint:** `4c5feb51c8777b0576d0ac11f3fafb921db91b38`; root tree `a7474fc394c6b070de0195e82b53127a63e0bf38`; 150 entries / 104 blobs / 46 trees; `truncated=false`. The live file register is being reconciled to all 104 blobs.
- **WP2 bootstrap:** new `lib/app_bootstrap.dart` (105 lines) takes ordered startup from `main.dart`: verify official installation, load local App/KnownCooler/Floating preferences, initialize Firebase best-effort, attempt App Check after Firebase, set portrait orientation and launch the existing tamper/official root. Five regression tests cover gate, sequence and failures. Android verifier/signing implementation was untouched.
- **WP2 Settings:** `lib/settings_pages.dart` (762 lines) is a Dart part of `floating_monitor.dart` and now owns Settings root/subpages, Lock Voltage presentation and About. About 755 lines moved. FloatingConfig/secure storage, MethodChannel bridge, permission lifecycle, native service, native renderer and telemetry projection remain in the original library; BLE/GATT was not moved.
- **Dashboard boundary:** `lib/main.dart` is now 6,682 lines; Dashboard remains the single BLE/GATT/P1 owner. App composition/root and session extraction remain open WP2/WP3 work; no wire protocol or runtime session behavior changed in these extractions.
- **Validation Only intermediate outcomes:** #112/#113 failed only the formatter gate while analyzer and 239/239 Flutter tests passed; #114 was cancelled when main advanced. #115 failed formatter and one stale Lock Voltage source assertion (238/239); its test now reads the extracted module. #116 passed locked dependencies, analyzer and 239/239 tests but formatter still failed on bootstrap test formatting/whitespace. #117 was superseded. Run #118 / job `140245350553` checks exact source SHA `4c5feb51c8777b0576d0ac11f3fafb921db91b38`; terminal result pending.
- **Evidence boundaries:** local Flutter/Dart/Gradle/ADB unavailable; Android/Kotlin compile not run; actual Android screenshots, OEM/device behavior, SQLite v1→v2 fixture, and 1h/6h/24h performance profile remain NOT RUN. Whole-App visual status remains VISUAL NOT VERIFIED. No Build App, APK, signing, Release, Firmware/BIN, Firebase production, OTA, flashing or device operation.
