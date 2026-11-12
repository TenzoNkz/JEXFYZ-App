## CURRENT CHECKPOINT — FULL APP PRE-BUILD AUDIT / NOT READY — 2026-11-12

**Mode:** `@Thinking Diskusi!` — static App/repository analysis and documentation only. No executable source, tests, configuration, build workflow, Firmware, Actions, Release, Firebase, OTA, flashing or device operations were changed or run.

### Live repository and package state

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Executable source snapshot analyzed:** `4d02fbf705a85820a4ea1e530d167ebb53ab3a68` (131-entry tree). The subsequent audit/checkpoint commits were documentation only. The current recursive tree has 132 entries, not truncated; no App source, tests, configuration, workflow, Firmware or Release assets changed during this Diskusi.
- **Latest executable App/test state:** Settings/About source `1cae4cfc061328b3b2b8bed96987c410f37373f2`; test additions `96301aec962739c39518e84f38cd4294d975595f`.
- **Current verified package remains Build #153:** source `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Actions run `43145542329`, Release ID `403010611`, tag `jexfyz-latest`. Current source is newer than the APK.
- Actions latest #153 completed SUCCESS; no open PR or active run. No build trigger was sent.

### Audit result

- Complete static inventory: 7 Dart library files, 9 test files, 179 test declarations (166 unit/source-contract and 13 widget tests). The latest source suite is **NOT RUN**; Build #153's 176/176 result applies only to its older source SHA.
- Full findings and remediation priority are recorded in `APP_PREBUILD_AUDIT.md`.
- **P1 not ready:** Usage Statistics full-session recompute + unbounded serialized write queue; overlapping 650-ms Connection and 300-ms Floating Monitor polling; 36/42/34-dp Home/Temperature hit targets; profane hard-coded TamperScreen copy with an explicit test contract; latest current-main tests not executed.
- **New owner screenshot defect (2026-11-12):** Usage Statistics timeline tap expands the selected-time dock to almost the full screen. High-confidence source cause: `_sharedCursorReadout()` outer `Column` defaults to `MainAxisSize.max` inside `Scaffold.bottomNavigationBar`. Same `usage_statistics.dart` blob exists in Build #153 and current main. See `DESIGN_NOTES.md` and `APP_PREBUILD_AUDIT.md`. Proposed narrow fix is `mainAxisSize: MainAxisSize.min` plus a widget-height regression; no source change yet.
- **P2:** no `analysis_options.yaml` although `flutter_lints` is declared; no formatter check in guarded workflow; monolithic main.dart; microtype (6.8–10.5 dp) and dialog/Floating presentation inconsistency; semantic token/contrast and fixed TextScaler accessibility review.
- **Positive findings:** 354 localized keys, no duplicate keys or missing static `JexText.of` references; semantic telemetry colors and Phosphor icon family are coherent; current Settings one-line rows/About/Peltier/Temperature/Diagnostics changes are present in source.
- **Evidence:** STATIC SOURCE CHECK only. No format/analyzer/test, screenshots, App Build, physical device or performance soak was run. No false claim of a clean or visually accepted App.

### Required remediation order

1. UX/accessibility: touch surfaces, Home microcopy hierarchy, neutral TamperScreen UX while preserving fail-closed signature check, modal/overlay consistency.
2. Runtime/performance: single-flight/lifecycle-aware polling; bounded/coalesced Statistics writes and scalable summary/deduplication, with long-session tests.
3. Code quality: formatter/lint baseline and current-source analyzer/test pass, without weakening contracts.
4. Then guarded App Build, followed by actual screenshot/device visual acceptance. The precise matrix and exit conditions are in `APP_PREBUILD_AUDIT.md`.

### Exact next action

Use a separate `Eksekusi Full!` first for the owner-reported Usage Statistics selected-time dock defect: compact the bottom readout using intrinsic content height and add the missing height regression at 350/420 dp, EN/ID and Light/Dark. The broader P1 audit items remain open. **Do not build yet.** Issue `Eksekusi Build App!` only after the P1 findings are fixed/dispositioned, current-source tests/analyzer/formatter are clean, and the pre-build criteria in `APP_PREBUILD_AUDIT.md` are met.


---

## HISTORICAL CHECKPOINT — PELTIER DIALOG & TEMPERATURE RESET UI FIX — 2026-11-12

**Mode:** `@Thinking Eksekusi Full!` — authorized App-only source, regression-test and documentation scope. No App Build/APK/Release, Firmware compile/BIN, Firebase, OTA, flashing or device operation was performed.

### Live repository and release boundary

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Source commit:** `5296ba50f7fe0ba2c0ecff4e6112bed6e40dab2a` (`fix(app): pin compact Peltier prompt and remove temperature reset`), parent `e859c51ef17f5306d036d55344192e1a5d59e2ab`.
- **Recursive tree:** 131 entries, `truncated=false`; final source and documentation files were fetched back from main and their blob SHAs matched the committed tree.
- **Build #153 remains the latest verified APK/Release:** source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Actions run `43145542329`, job `130942369953`, Release ID `403010611`, tag `jexfyz-latest`. This new source fix is NOT in the released APK.
- Comparison to Build #153: main is 37 commits ahead / 0 behind; exactly 11 changed paths (8 Markdown files plus `lib/main.dart`, `lib/app_settings.dart`, `test/widget_test.dart`). No Firmware, Gradle/config, workflow or Release asset path changed.

### Owner-requested App fix

- **Screenshot defect:** the Build #153 Peltier prompt exposed a scrollable panel that could be moved and showed anomalous text decoration/type appearance while visually oversized.
- **Peltier dialog:** retained the existing `JexFixedScalePage` / 360-dp canvas and SafeArea, but replaced the inner scroll view with a fixed centered panel. Removed the slide entrance; retained restrained fade/scale. Max width is now 296 dp (previously 312), corner radius 20 dp, compact internal padding and responsive compact values for constrained height. Copy uses the existing ThemeData Roboto font explicitly and `TextDecoration.none`; icon/step tiles are compact. Primary and Cancel targets remain 48 dp high.
- **Safety invariant:** Cancel/barrier dismissal remain command-free. The implementation continues to send `FAN:ON`, require successful Fan ACK, then and only then send `PELTIER:ON`. No BLE/P1 command semantics, Firmware or thermal safety behavior changed.
- **Temperature tab:** removed “Reset Temperature Settings” / “Atur Ulang Pengaturan Suhu”, the App-only `_resetTemperatureSettings()` sender and the unused UI localization key. Hotside limit and 5V/12V battery threshold controls remain. Generic `RESET:TEMPERATURE` command classification/ACK mapping remains intact; no protocol/Firmware change was made.
- **Regression source:** updated Peltier geometry/fixed-panel/no-decoration/action assertions and added a Temperature reset UI absence contract while explicitly preserving protocol classification.

### Validation and evidence boundary

- **STATIC SOURCE CHECK / GitHub read-back:** passed for the centered non-scrollable dialog, absence of SlideTransition, 296-dp width, explicit theme font/no-decoration treatment, absence of the reset button/handler/label, preservation of protocol ACK classification and source test updates.
- Flutter/Dart are not installed in the active execution runtime. `dart format`, focused Flutter tests, analyzer and full Flutter suite are BLOCKED / NOT RUN. No hosted Actions run, new App Build, APK/Release, screenshot rendering, emulator or physical device validation was run.
- The owner screenshot was inspected as the defect reference; it is not evidence that the modified build renders correctly. Outcome remains **VISUAL NOT VERIFIED** until a newly built APK is installed and real Android screenshots are reviewed.
- No current build/release operation was started. Firmware V7.2 compilation/BIN, physical BLE/NVS/rail, thermal/electrical and OTA/flash checks remain outside this authorization.

### Exact next action

A separate `Eksekusi Build App!` is required to run the guarded App QC/package workflow for source commit `5296ba50f7fe0ba2c0ecff4e6112bed6e40dab2a`. After packaging, install that APK and capture the Peltier dialog at 350-dp/420-dp, portrait/constrained height, EN/ID and Light/Dark; verify it is fixed, compact, undecorated and all text/actions fit. Also confirm the Temperature tab no longer shows the reset button. Do not start Build App from this checkpoint without that separate command.
