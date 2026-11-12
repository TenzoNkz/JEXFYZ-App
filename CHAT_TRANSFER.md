## CURRENT CHECKPOINT — STATISTICS BOUNDEDNESS REVIEW / SOURCE FOLLOW-UP BEFORE BUILD QC — 2026-11-12

**Prior implementation mode:** `@Thinking Eksekusi Full!` — App source, regression tests and documentation only. **Current review mode:** `@Thinking Diskusi!` — static source/repository inspection and documentation-only checkpoint update. No Build App, Actions execution, APK/Release, Firmware, Firebase, OTA, flashing, native Android code or device operation was performed in this review.

### Live branch and Release boundary

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`.
- **Current repository tree:** 132 entries, recursive listing not truncated. Documentation-only checkpoint commits follow this executable source/test snapshot.
- **Current executable source/test HEAD:** `a963f8bd100f7f2c41f720933ade2cd586145270`.
- Recursive tree: 132 entries, `truncated=false`.
- Remediation commits: `5763b08f8b37fccafd2ac2403a51b26ad0be4b41` (Statistics dock/analytics/storage + P1 touch/polling/integrity fixes), `b1275d278ca0b0d2765174364250873044a943d1` (Statistics chart density + integrity dark theme), `aa58a2f14354692a1dbcebfcb70436deb3aabf06` (skip redundant sort for chronological live events), and `a963f8bd100f7f2c41f720933ade2cd586145270` (dynamic narrow-range axis precision).
- Compared with Build #153, executable source/test SHA is 57 commits ahead / 0 behind; 18 changed paths (11 Markdown, 4 Dart source, 3 test files).
- **Build #153 remains the latest published package:** source `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, Actions run `43145542329`, Release ID `403010611`, tag `jexfyz-latest`. Current fixes are not in that APK.

### Usage Statistics — source implemented

- Selected-time dock now uses intrinsic content height via outer Column `MainAxisSize.min`; stable key supports measured-height regression. Bottom placement, SafeArea, six selected values and 48×48 dp Clear target remain. Test asserts dock ≤200 dp at normal text scale and removal after Clear.
- Temperature charts are 160 dp high, axis painter labels 10 dp with tick-spacing-aware precision, and Hotside-to-Activity spacing is tighter. Battery/Hotside plots, four activity timelines, six-value cursor, Min/Avg/Max/Observed, Hotside limit, aggregates, provenance and data gaps remain.
- Analytics groups events by session/metric, de-duplicates via event identity, merges ordered events, sorts only when needed, computes summary once per live batch, caches decimated chart points and uses binary search for cursor temperature.
- SQLite sample + matching freshness update is transactional. Schema v2, retention, raw 1-Hz samples, null gaps and HOT-only P1 freshness remain. The internal serial queue admits up to 64 scheduled operations and exposes write failures; a follow-up static review found that this does not bound all waiting producer Futures because important main.dart call sites use unawaited().
- **Remaining performance boundary:** one full selected-session summary/chart-decimation pass still runs per one-second refresh. No 1h/8h/long-session Android CPU/memory soak or sustained SQLite backlog measurement has run.

### Additional static review — two Statistics boundedness gaps

- **Queue ingress:** lib/usage_statistics.dart UsageStatsWriteQueue.enqueue() waits for _tail after 64 admitted operations, but lib/main.dart submits Battery/Hotside samples and state changes through unawaited(). If storage remains slower than producers, callers can accumulate waiting Futures outside pendingOperations; the current capacity/FIFO test observes only admitted operations. This is a STATIC SOURCE RISK, not an observed data-loss/runtime failure.
- **Gap-heavy chart decimation:** UsageStatsAnalytics.decimatePoints() preserves every null and breakBefore point. That preserves gaps, but it can return more than maxPoints when the data contains many invalid samples or segment boundaries. The existing 12k-per-sensor cap test uses continuous valid samples and does not establish a hard cap under dense gaps. This is a deterministic source-level edge case, not a device observation.
- **Required next review:** design bounded ingress/backpressure without blocking the BLE telemetry callback or silently discarding accepted 1-Hz samples; make gap-aware chart reduction preserve invalid intervals while explicitly bounding or documenting output under dense gaps; add delayed-writer, many-submitter and invalid-heavy regressions. Preserve SQLite schema v2, raw samples, null gaps, HOT-only P1 freshness and telemetry authority.
- **Formatting gate:** the guarded workflow has no dart format --output=none --set-exit-if-changed step; formatting is still NOT RUN. This must be explicitly handled in the next source/quality pass rather than assumed to be covered by Build QC.

### Other P1 source remediation

- Connection status refresh is single-flight, 3-second while active, immediate on open/resume and paused in background/dispose.
- Floating Monitor runtime reconcile is single-flight, 3-second while enabled/connected, paused in background and checked immediately on resume. The 300-ms interval remains only in the bounded max-2-second overlay permission return flow.
- Home header actions use 48×48 dp hit surfaces with 25-dp visible artwork; Home tab strip is 48 dp; Temperature +/- art remains 34 dp inside 48×48 dp tap areas. Existing Connection 40–42 dp legacy controls are unchanged.
- TamperScreen now has concise bilingual official-build verification failure copy and an explicit dark theme while retaining developer contact. Native signature verification/fail-closed route is untouched.
- Settings one-line rows, compact Lock Voltage, boxed About, Device Diagnostics removal, Peltier FAN-ACK gate and Temperature reset removal remain.

### Regression inventory and validation boundary

- Current suite: **185 declarations** (172 unit/source-contract + 13 widget). Current long-history test covers 12k valid Battery + 12k valid Hotside events; queue test checks admitted-operation capacity/FIFO but not blocked unawaited producer Futures; dense-null/gap chart decimation is not covered. The current suite remains NOT RUN.
- Source read-back/static structural checks passed. Flutter/Dart are unavailable in this runtime; formatter, focused tests, analyzer and full suite are **BLOCKED / NOT RUN**. Written tests are not passing tests.
- No Actions run, App Build, APK, Release, screenshot/device test or performance soak was started. Current visual status is **VISUAL NOT VERIFIED**.
- Native Android code/Firmware/BIN, BLE/P1, Firmware safety, OTA, Firebase, notification IDs, SQLite schema/version, Android versionName and 360-dp DPI canvas were not changed.

### Exact next action

**Arah berikutnya: Lanjut Eksekusi Full! (rekomendasi, belum diotorisasi).** Before any Build App trigger, resolve or explicitly disposition the end-to-end queue-ingress bound and gap-heavy decimation bound on source snapshot a963f8bd100f7f2c41f720933ade2cd586145270. Add regression cases for delayed SQLite writes with more than 64 unawaited submissions and for invalid-heavy/alternating gap histories; choose an overload strategy that preserves every accepted raw sample and does not block BLE parsing. Also decide how the missing formatter gate is satisfied. Only after the source/tests and formatting policy are clean should the owner issue a separate Eksekusi Build App!. No build is authorized or started by this checkpoint.


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
