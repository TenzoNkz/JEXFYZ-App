## CURRENT CHECKPOINT — PROFESSIONAL SETTINGS / NOT RELEASED — 2026-11-12

**Mode:** `@Thinking Eksekusi Full!` — App Settings/About source, regression tests and documentation only. No App Build/APK/Release, Firmware compile/BIN, Firebase, OTA, flashing or device operation.

### Live branch and release boundary

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Settings source commit:** `1cae4cfc061328b3b2b8bed96987c410f37373f2`.
- **Regression test commit:** `96301aec962739c39518e84f38cd4294d975595f`.
- Recursive tree: 131 entries, `truncated=false`; no file paths were added or removed in this pass.
- **Build #153 remains the latest verified APK/Release:** immutable source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Actions run `43145542329`, job `130942369953`, Release ID `403010611`, tag `jexfyz-latest`. Current main UI follow-ups are NOT included in that APK.

### Implemented professional Settings/About refinement

- **Settings rows:** each setting is now one horizontal row: icon, setting name, optional right-aligned value and chevron. Single-line title/value with ellipsis; minimum row height 48 dp. Useful values retained: Language, Appearance, Bluetooth Auto/Manual, Floating Monitor ON/OFF, and known Firmware version.
- Removed the hard-coded Notifications count, duplicate Usage Statistics explanation, repeated About subtitle `JE Cooler`, and unknown Firmware placeholder `V?`.
- **Lock Voltage:** remains first, Firmware-owned and functional. Compact tile/text retained. State text appears only when needed: Not synchronized; Firmware V7.2+ required; Active · not saved; 5V limit · Adaptive OFF. A synchronized/known/saved OFF state has no redundant explanatory text. Switch, retry and all state semantics remain.
- **About:** standalone row card under Firmware, no duplicate subtitle. About page retains JE Cooler title and three compact credits in one card; generic Special Thanks/Ucapan Terima Kasih heading removed. All exact role/name/handle pairs remain.
- **Unchanged:** grouped General/Device/Statistics/Firmware cards and their order, theme, EN/ID, Phosphor icons, compact Settings scope, 360-dp canvas/DPI transform, Home, BLE/P1, Firmware, persistence and Usage Statistics data. Earlier Diagnostics removal, Peltier Fan-ACK gate and Temperature reset removal are retained.

### Regression source

- Updated `test/floating_monitor_layout_contract_test.dart` for 48-dp horizontal Settings rows, right-aligned values, removed redundant labels, hidden unknown Firmware version, compact About card and existing canvas contract.
- Widget tests cover one-line Language/value alignment, omitted filler copy, known/unknown Firmware version display, Lock Voltage state text in EN/ID, and About card/credits.
- The tests are **written but NOT RUN**. Flutter and Dart are not installed in the active runtime; formatter, focused widget/source-contract tests, analyzer and full suite are BLOCKED / NOT RUN. No hosted Actions run/build/release was triggered.
- Source read-back and static checks passed. The modified source has not been rendered on Android; appearance remains **VISUAL NOT VERIFIED**.

### Exact next action

Use a separate guarded `Eksekusi Build App!` for the current App source, then inspect actual screenshots at 350-dp/420-dp in EN/ID and Light/Dark. Review row alignment and truncation, all meaningful right-side values, compact Lock Voltage unknown/active/OFF states, About credits, and the previously changed Peltier popup and Temperature tab. Build #153 remains the current published package until the new guarded workflow passes.


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
