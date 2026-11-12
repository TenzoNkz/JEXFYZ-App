## CURRENT CHECKPOINT — PELTIER PREREQUISITE MODAL BOTTOM ANCHOR REQUESTED / SOURCE CHANGE PENDING — 2026-11-13

**Mode:** `@Thinking Diskusi!` — visual review and documentation-only decision record. No App source, test, configuration, workflow, Actions, Build, Release, Firmware or device operation is authorized/performed in this interaction.

### Live source and release baseline

- **Repository/branch:** `TenzoNkz/JEXFYZ-App` / `main`.
- **Live main at review:** `6e57c9d2dab7ec8b75adf0f555e5dd156f73b7f1`; source `lib/main.dart` blob `a948a5b104507c082a6f844ba6d64d759ccd63df`; regression file `test/widget_test.dart` blob `189bdeddf0163b3a71d6661e57625d15dcd5d160`.
- **Latest verified release:** Build #157, Actions run `43247876115`, immutable package source SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. Build #157 passed analyzer (23 infos, 0 warnings/errors), Flutter tests 187/187 and Android Gradle. The main branch is 24 commits ahead / 0 behind Build #157 only because four Markdown files changed; App source/test and workflow paths still match the built source. The screenshot's centered Peltier modal therefore reflects the current released source implementation.
- **Current source cause:** `_togglePeltier(bool enabled)` in `lib/main.dart` wraps the card in `Center(` at approximately line 6576. The Peltier source-contract test in `test/widget_test.dart` explicitly expects `Center(`.
- **Existing in-app precedent:** LED Color Picker in the same `main.dart` already uses `Align(alignment: Alignment.bottomCenter)` inside `JexFixedScalePage` and `SafeArea`.

### Owner-approved presentation decision

- The card's current appearance, dimensions, typography, copy, buttons and behavior are accepted. The defect is its vertical placement: it must no longer be vertically centered.
- **New position:** anchor the Peltier prerequisite card at `Alignment.bottomCenter` within the existing `SafeArea`, leaving the existing 10-dp vertical breathing margin. Keep the existing 16-dp horizontal margin and 296-dp maximum card width.
- Implementation direction for the next authorized source change: replace the outer `Center(` with `Align(alignment: Alignment.bottomCenter,` around the same `Padding` and `ConstrainedBox`. Preserve the existing `JexFixedScalePage`, one 360-dp transform, SafeArea/inset handling, fade/scale transition, non-scrollable card and compact-height behavior. Do not add another transform or convert it into a full-height bottom sheet.
- Update the existing regression assertion to require `Align(` plus `alignment: Alignment.bottomCenter`; remove the old expectation that the Peltier panel is centered. Keep the assertions for 296-dp width, 20-dp radius, 48-dp actions, bilingual copy, command-free Cancel/barrier and FAN:ON → successful ACK → PELTIER:ON order.
- The previous centered-layout sentence in `DESIGN_NOTES.md` is superseded by this newer owner instruction and will be corrected in the documentation update below.

### Scope and next action

- This Diskusi interaction makes a durable documentation/design-contract update only. Current source and test files remain unchanged; Build #157 remains the latest package.
- After the owner issues `@Thinking Eksekusi Full!`, implement only the bottom-anchor source and regression-test change, run available formatter/focused/full tests/analyzer, update the canonical notes and commit. A fresh `Eksekusi Build App!` is separately required to package the changed source.
- Visual acceptance remains **VISUAL NOT VERIFIED** until the actual revised Android screenshot is reviewed, including SafeArea/gesture-navigation spacing and supported 350-dp/420-dp configurations.

---

## LAST VERIFIED BUILD BASELINE — BUILD #157 SUCCESS / RELEASE VERIFIED — 2026-11-12

**Disposition:** guarded App Build/QC/release COMPLETED SUCCESSFULLY. No further Build App trigger is needed for this source SHA.

### Immutable build and validation evidence

- **Run/job/source:** Build #157 / Actions run `43247876115`, workflow `374946166`, issue event, attempt 1, job `131285336987`; tested/released source SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. [View Actions run](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43247876115).
- **Gates:** steps 1–21 and cleanup/post-job steps 39–43 all SUCCESS.
- **Dart analyzer:** 23 info-level deprecations, 0 warnings, 0 errors.
- **Flutter tests:** **187/187 passed**.
- **Android Gradle:** `BUILD SUCCESSFUL in 3m19s`. App native JUnit test compile/process/test tasks `NO-SOURCE`; no native Android JUnit test cases executed.
- **APK:** `JEXFYZ-release.apk`, obfuscated with `--obfuscate --split-debug-info=build/symbols`; **55,980,123 bytes**, SHA-256 `24a42feb2ec8968209ac5dd764c6acb789c09fb0fc9a26df8e7d4bf5e1652aef`. [Download APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- **Corresponding source ZIP:** `JEXFYZ-corresponding-source.zip`; **2,932,445 bytes**, SHA-256 `3b6f0a84a760b26587ca39a946f14383f2acee933fb5b30247270713a32e6a06`. [Download source ZIP](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- **Release/tag parity:** Release ID `403010611` / tag `jexfyz-latest`; Release target and Git tag both point to exact Build #157 SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. Exactly one APK + one corresponding source ZIP. Gate 21 re-downloaded both, matched checksums, confirmed ZIP integrity and source marker, and independently verified downloaded APK JAR/V1, V2, V3, one signer and pinned cert.
- **Certificate:** RSA 4096, JE X FYZ DN, pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 pass. Self-signed signer, PKIX trust-chain validation and no timestamp remain explicit caveats; it is not publicly CA-trusted. V3.1/V3.2/V4/SourceStamp were not required and were false.
- Android Gradle `versionName "Telegram @horizontalzzz"` unchanged; Flutter app version `1.0.0+3`.

### Preserved failure history and repository state

- Build #154 / run `43243342029` remains FAILED at analyzer (6 errors); Build #155 / `43244335274` remains FAILED at Flutter tests (183 pass / 4 fail); Build #156 / `43246666829` remains FAILED at Flutter tests (186 pass / 1 fail). All original failure causes and concrete repairs remain preserved in APP_BUILD_REPORT.md. Build #157 is the first successful build after these repairs.
- Pre-final-doc live main HEAD: `07f9d706d5a9a19953f155351df2911cd131a2db`. Comparison to immutable build SHA shows 20 commits ahead / 0 behind and exactly four changed Markdown paths: APP_BUILD_REPORT.md, CHAT_TRANSFER.md, HANDOVER.md and PROJECT_STATE.md. No App source/test, Gradle/config, Firmware or workflow change after built SHA. Recursive tree 132 entries, not truncated.
- Workflow blob remains `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`, issue opened/reopened only with owner/title/body-token guard; no push/PR trigger. Actions queue and active filters are both zero. Actions artifacts API is empty by design; the Release owns APK/ZIP assets.
- **Formatter:** workflow has no Dart formatter step; `dart format` remains NOT RUN / UNVERIFIED.

### Evidence boundary / next action

Build #157 proves hosted App CI, package and Release only. Firmware V7.2 compile/BIN, Firebase, OTA/flash, physical BLE/device/NVS/rail/LED, thermal/electrical cooling, owner installation and OEM visual acceptance remain NOT RUN / UNVERIFIED.

Next: owner installs Build #157 and performs physical App/BLE/OEM visual acceptance at 350-dp/420-dp, Light/Dark, EN/ID, reconnect and Lock Voltage. No further App Build until App source changes.

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
