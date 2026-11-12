## CURRENT CHECKPOINT — BUILD #154 ACTIVE / FLUTTER SETUP — 2026-11-12

**Mode:** `@Thinking Eksekusi Build App!` — guarded App Build/QC/release only. No Firmware compilation/BIN, Firebase, OTA, flashing or device operation.

### Live repository and source/release boundary

- Repository: `TenzoNkz/JEXFYZ-App`, branch `main`. Immutable Build #154 checkout SHA: `dd7e75f1597e14c3d929b1ca78825dc806aef25d`; recursive tree at trigger: 132 entries, `truncated=false`.
- Current executable source/test checkpoint: `6c551c4ff95329e56eca7ce758078c9590b4b726`. The run checkout SHA above is the exact source/repository commit under validation; intervening commits are documentation-only.
- Compared with Build #153 source `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, the checkout is 99 commits ahead / 0 behind; 18 changed paths comprise 11 Markdown files, 4 Dart libraries and 3 Dart test files. The current Usage Statistics/Settings/Floating Monitor/Home changes and their regressions are not in the #153 APK.
- Build #153 remains the last published Release until #154 passes: Release ID `403010611`, tag `jexfyz-latest`, old target SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`.

### Build #154 — active guarded run

- Run `43243342029`, workflow `374946166`, issue event, attempt 1, job `131269364235`, checkout SHA `dd7e75f1597e14c3d929b1ca78825dc806aef25d`. [Actions run](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43243342029).
- Trigger: issue #33 exact owner/title/body-token guard closed/reopened once. Exactly one #154 run exists. No duplicate trigger.
- Current first job snapshot: runner, checkout, Java 17 succeeded; Flutter 3.47.2 setup is in progress; remaining gates pending. Continue this run only.
- Current workflow blob: `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`; only issue opened/reopened trigger, owner/title/token gate; no push/PR release path.
- **Formatter caveat:** workflow has no Dart formatter step. `dart format` remains NOT RUN / UNVERIFIED; this is not represented as a passed gate. The explicit owner Build App command authorized proceeding with the existing guarded workflow, and no existing gate was weakened.
- Preflight: no open PR and zero queued/in-progress Actions runs before trigger. Android Gradle `versionName "Telegram @horizontalzzz"` remains exact.
- Next: inspect run `43243342029` / job `131269364235` steps/logs; do not trigger another run while active. Record actual analyzer/test/Gradle/signing/release results only when observed.

### Acceptance boundaries

CI/Release is App-only. Firmware V7.2 compile/BIN, Firebase/OTA/flash, physical BLE/device/NVS/rail/LED, thermal/electrical cooling, OEM rendering and owner installation remain separately NOT RUN / UNVERIFIED.

---

## HISTORICAL CHECKPOINT — BOUNDED STATISTICS WRITER + GAP DECIMATION IMPLEMENTED / VALIDATION HOLD — 2026-11-12

**Current mode:** `@Thinking Eksekusi Full!` — App source, regression tests and canonical documentation only. No App Build/QC, Actions trigger, APK/Release, Firmware, Firebase, OTA, native Android, flashing or device operation was performed. Build authorization remains separate.

### Live branch and package boundary

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Latest source/test code checkpoint:** `6c551c4ff95329e56eca7ce758078c9590b4b726`.
- **Code blobs:** `lib/usage_statistics.dart` = `3afd0d8e440b5c4b7c19fb46b825a8a821e5492b`; `test/usage_statistics_test.dart` = `fb665eeb3894a613c2a5bbcfb8ae72537b1c37a0`. Documentation commits follow this code checkpoint.
- **Current repository tree:** 132 entries, recursive listing not truncated.
- **Latest published package remains Build #153:** source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Actions run `43145542329`, Release ID `403010611`, tag `jexfyz-latest`. Current changes are NOT in that APK/source ZIP.

### Usage Statistics — bounded writer admission implemented

- `UsageStatsWriteQueue` accepts FIFO work up to 64 normal pending operations plus 8 reserved control operations plus 1 critical endSession slot (73 total). Temperature and Fan-Speed producers never wait for capacity. Session start/clear and Voltage/Adaptive/Peltier state events can use the 8 reserved slots; only endSession can use the additional critical slot. Fan Speed remains under the normal ceiling.
- An operation beyond its applicable capacity is rejected immediately, increments `rejectedWriteCount`, and records a persistent `lastWriteError` that is surfaced as a bilingual Statistics warning. Accepted operations are never evicted. This explicitly trades lossless indefinite buffering for bounded memory and non-blocking BLE producers when the local store is overloaded; the incoming rejected record is not accepted.
- Clear History uses `failOnReject` so a queue-full request reaches the existing UI error handler instead of appearing successful.
- HOT freshness follows actual Firmware HOT receipt time, not SQLite write progress. A slow/rejected write cannot falsely mark a continuously receiving P1 session stale. A late HOT packet after the 2.5-second stale threshold does not refresh or enter the old session; it leaves the previous receipt timestamp for the watchdog to close through the critical session-close slot. Explicit null sample gaps are written when recording resumes or when a session closes; the HOT-stale close path also writes a Battery gap before ending the session.
- SQLite schema v2, raw 1-Hz capture policy, 30-day retention, transaction semantics and HOT-only P1 freshness authority remain unchanged.

### Usage Statistics — gap-safe chart budget implemented

- `decimatePoints(maxPoints)` now enforces a hard output ceiling, including budgets below four. It selects bucket endpoints/extrema and propagates any skipped null/`breakBefore` boundary onto the next retained valid point. The painter therefore starts a new path rather than visually bridging a discarded invalid interval.
- Only the render list is reduced. Raw SQLite samples and full-resolution summary/statistics inputs are unchanged.

### Regression inventory and evidence boundary

- Current test inventory: **187 declarations** (174 unit/source-contract + 13 widget). New source tests cover fire-and-forget producers against a held writer, 64 normal + 8 reserved + 1 critical-close capacity, immediate rejection, accepted FIFO order, error propagation for Clear, a 24,000-point alternating-null/gap-heavy chart across budgets 1/2/3/7/8/1599/1600, boundary propagation, late-HOT/P1-watchdog ordering, critical endSession admission at full normal/control capacity and the localized overload warning.
- GitHub read-back, custom delimiter balance scan and structural source checks passed. A separate algorithm simulation of the 24,000-point alternating-gap fixture returned no output above its budget and no missing gap breaks. These are **static/source checks and simulation only**, not Dart compilation or Flutter test results.
- Flutter/Dart/Gradle/ADB are unavailable in this runtime. `dart format`, focused/full `flutter test`, `flutter analyze` and Android Gradle remain **BLOCKED / NOT RUN**. The guarded App workflow contains no Dart formatter step; this task did not change or trigger the workflow.
- Remaining performance evidence: one selected-session analytics summary/decimation pass still occurs per one-second live batch. 1-hour/8-hour storage pressure, backlog drain rate/rejection frequency, CPU/memory, animation lifecycle/60–120-Hz frame behavior and OEM screenshots/device validation remain unmeasured. Visual status is **VISUAL NOT VERIFIED**.
- Only executable paths changed in this task are `lib/usage_statistics.dart` and `test/usage_statistics_test.dart`. Workflow, Android/native source, Firmware, assets, BLE/P1 identifiers, Firebase/OTA and release metadata were not changed.

### Exact next action

**Arah berikutnya: Terhambat — jalankan formatter check, focused/full Flutter tests and analyzer on this exact source/test revision in an environment with Flutter/Dart, then review the results.** No App Build is authorized by this checkpoint; after source validation, the owner must separately issue `Eksekusi Build App!` for guarded QC/package validation.


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
