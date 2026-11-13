## CURRENT CHECKPOINT — BUILD #160 ACTIVE / JAVA 17 SETUP — 2026-11-13

**Mode:** Eksekusi Build App! — explicit owner authorization is active for guarded App Build/QC/release and justified App-scope repairs only. No Firmware compilation/BIN, Firebase mutation, OTA, flashing or device operation.

### Current run and immutable source

- **Repository/branch:** TenzoNkz/JEXFYZ-App / main.
- **Trigger:** owner-authored Issue #37 opened 2026-11-13T12:42:11Z with exact guarded title and token. Issues #33, #35 and #36 remain OPEN and were not reopened. Exactly one new run was observed.
- **Actions:** [Build #160 / run 43427419461](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43427419461), workflow 374946166, event issues, attempt 1; job 131892170041; run created 2026-11-13T12:42:14Z.
- **Immutable checkout source SHA:** 24c6393364cade3d6093aebb6c52904f1af66396, exact match to live main HEAD at final pre-trigger re-fetch.
- **Initial gate state:** steps 1 Set up job and 2 Checkout repository SUCCESS; step 3 Set up Java 17 IN_PROGRESS; steps 4–21 PENDING. No analyzer/test/Gradle/package/release result is asserted yet. Continue only this run.
- **Workflow:** blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12; complete 545-line workflow read. Trigger remains issues.opened/reopened with repo-owner, exact-title and token guard; no push/PR release route. Security audit, dependency, analyzer, Flutter, Android Gradle, obfuscated APK, V1/V2/V3 signing, pinned certificate, source ZIP, Release/tag parity and downloaded-asset gates unchanged.
- **Preflight:** tree 133 entries, truncated=false; zero active/queued/waiting/requested Actions runs; zero open PRs; Release ID 403010611 and tag jexfyz-latest remained on previous Build #159 source cdca38b9e4f2f99006db8feae40c07c6f9bdfb0a with exactly two verified assets; Android versionName "Telegram @horizontalzzz" exact.
- **Candidate executable/test changes since Build #159:** About lowercase @horizontalzzz; Usage Statistics one-header/one-timer redesign, 1°C observed-data chart axes and adaptive height, remove Observed/More details/Last sample while retaining Min/Avg/Max, four activity timelines and six-field cursor; native Floating Monitor duplicate F branch removed so F draws the three-blade Fan icon; matching About/Statistics/native tests. Commit details are in the pre-trigger checkpoint and APP_PREBUILD_AUDIT.md.
- **Test inventory:** 188 declarations / 9 Dart test files; inventory only, not execution.
- **Ledger:** APP_BUILD_REPORT.md appended Build #160 trigger/source/job and initial step state in commit f0155be748545538e6e2b2d086755a963fdc3393.

### Continuation and release baseline

- Inspect only run 43427419461 / job 131892170041. Update APP_BUILD_REPORT.md, CHAT_TRANSFER.md and 00_WORK_STATUS.md at each meaningful gate. Never start a duplicate run.
- If a gate fails, preserve the failure and inspect the exact job log; repair only a demonstrated App-scope cause without weakening tests/security/signing gates.
- Previous verified package Build #159 remains the live Release until this run reaches step 21 successfully:
  - APK 55,914,587 bytes; SHA-256 02bef5960e0b23bea360d2cf8a0532e7dbd202e05f5420e055c98b4dc7a61321.
  - Source ZIP 2,932,978 bytes; SHA-256 5dbb29ebc7629775835bc65d655069a1a077f6d3240114387c965b5ad4789558.
- On success verify all steps 1–21 and cleanup; exact analyzer/test counts; Gradle NO-SOURCE/native coverage; APK obfuscation; one signer/V1/V2/V3/pinned cert; source ZIP integrity/marker; exactly one APK and one source ZIP; Release/tag/source SHA; downloaded bytes/digests and downloaded signature.
- Workflow has no Dart formatter step; `dart format` is not implied. Local Dart/Flutter/Gradle/ADB are unavailable.
- **Evidence boundary:** Build App CI is not Firmware compile/BIN, Firebase, OTA/flash, BLE/device/NVS/rail/LED, thermal/electrical or OEM screenshot acceptance. Those remain NOT RUN / NOT VERIFIED by this workflow.

---

## CURRENT CHECKPOINT — USAGE STATISTICS UI REFINEMENT / WAITING OWNER BUILD QC — 2026-11-13

**Mode:** `Eksekusi Full!` — App UI source, Flutter regression source, static read-back and canonical documentation only. No App Build/Release, Actions trigger, Firmware/BIN, Firebase, OTA, flashing or device operation was authorized or performed.

### Source and change record

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`. Source, regression tests and the current project checkpoint are committed on `main`; the checkpoint records the current handover and evidence boundary.
- **Usage Statistics source:** commit `9b9262d934ff2ab6575256b264f8bf851280dddf`; subsequent source-only changes `364f5c3c1b777606647c3d85777091314988ea7f` (session dropdown no longer duplicates duration) and `f32c1278308bea7cedd4f150255d2128cac138bb` (remove obsolete details-only formatter). Latest file blob: `lib/usage_statistics.dart` = `64fa93a39516126bbce04b3f031fcdc7f4e4381f`.
- **Regression source:** commit `6c85166731fde4d6e72d44ab82d6a3a10826918a`; latest test correction `b560403877fd2080db2019fc04d86d67020418dd`. Latest file blob: `test/usage_statistics_test.dart` = `259ba2e64a540a04c7f798f3688b2f1c225ccb9b`.
- **UI behavior:** one session header contains status, date/time and the only elapsed duration; session selection remains in the header dropdown and menu entries omit elapsed durations. Battery/Hotside axes show every whole degree at 1°C intervals using observed data range and adaptive chart height. Hotside limit remains visible as text but no longer dictates the plot range. Visible Observed, More details and Last sample elements were removed. Min/Avg/Max, four activity lanes, the common cursor and six selected-time fields remain. The selected-time dock is compact and uses locale-aware labels/state/temperature formatting.
- **Data invariants:** no changes to actual telemetry values, raw one-second collection, SQLite schema v2/retention, queue capacity/backpressure, session continuity, null/invalid gaps, HOT-only P1 freshness, analytics event handling or decimation.
- **Test inventory:** 188 declarations across 9 Dart test files (2 + 12 + 5 + 5 + 27 + 3 + 13 + 24 + 97). The changed tests are written; this inventory is not execution evidence.

### Validation and release boundary

- GitHub read-back and static checks passed: redundant UI strings/helpers are absent from the current screen source; the one-degree axis helper and adaptive height are present; the six-field dock remains; all test files were fetched and declaration-counted.
- **NOT RUN:** `dart format`, focused/full `flutter test`, `flutter analyze`, Android Gradle, screenshot rendering, emulator and physical-device validation. The runtime has no Dart/Flutter/Gradle/ADB.
- **Latest verified package:** Build #159 / Actions run `43376503987` / immutable source `cdca38b9e4f2f99006db8feae40c07c6f9bdfb0a` / Release `403010611` tag `jexfyz-latest`. Neither the Usage Statistics refinement nor the prior native Fan icon fix is included in that APK.
- This source is **NOT RELEASED** and visual status is **NOT VERIFIED**. The next step requires a separate owner-issued `Eksekusi Build App!` for guarded QC. No workflow, issue, action run or release was created from this Full session.

---

## PREVIOUS CHECKPOINT — REPO AUDIT + FLOATING MONITOR FAN ICON FIX / WAITING OWNER BUILD QC — 2026-11-13

**Mode:** `Eksekusi Full!` — App-native source, regression test, static repository audit and canonical documentation only. No App Build/Release, Firmware, BIN, Firebase, OTA, flashing or device operation was authorized or performed.

### Current source and verified-release boundary

- **Repository/branch:** `TenzoNkz/JEXFYZ-App` / `main`.
- **Latest verified package:** Build #159 / Actions run `43376503987` / exact package source `cdca38b9e4f2f99006db8feae40c07c6f9bdfb0a`; Release/tag `jexfyz-latest` point to that source. CI passed analyzer (23 infos / 0 warnings / 0 errors), Flutter 187/187 and Android Gradle; native Android JUnit tasks were `NO-SOURCE`.
- **USER-REPORTED field state:** owner reports Firmware V7.2 updated, Build #159 installed and system safe in use. This is not independent compile/BIN/physical verification.
- **Confirmed Build #159 issue:** Kotlin compiler warned `FloatingMonitorService.kt:738:17 Duplicate branch condition in 'when'`. `drawIcon()` had two `"F"` cases; the first drew a gauge, the later one drew the Fan. Since Floating Monitor F is Fan Speed (not FPS), the first branch was unreachable and misleading.
- **Source correction:** removed the first duplicate gauge branch; retained the three-blade Fan glyph. Commit `e0b68c3e98a5d75fe40c71bc0a7647712615c33d`.
- **Regression correction:** added a test requiring exactly `B/H/V/A/P/F` unique metric branches and the three-blade Fan drawing contract. Commit `aff8b8ec2796d03432f4f8b000f6e70205eccf48`. Current source/test inventory is **188 declarations** across 9 test files; the new test has not run.
- **Release boundary:** the native correction is newer than Build #159 and is **NOT RELEASED**. The latest package and the new source checkpoint must not be conflated.

### Repository audit

- Complete recursive tree: 133 entries, not truncated; 88 blobs and 52 Markdown files. Exactly one active versioned Firmware sketch.
- The 12 `.agents/skills` canonical files and 12 `.github/skills` mirrors have matching blob IDs.
- Active documentation/canonical skills link audit found no actionable missing relative paths. Historical references in immutable archive snapshots were left untouched.
- Main branch metadata reports `protected=false`; branch-protection detail access was denied to this integration. Workflow refs are tag-based, not full-SHA-pinned. These are governance hardening recommendations; no repository settings or workflow changed.
- Build #159 non-blocking backlog: Kotlin 2.2.20 support deprecation; deprecated Gradle flags; deprecated Notification priority APIs. No toolchain upgrade attempted.
- Known security gap: BLE Just Works + `SYNC_READY` still does not authenticate official App identity; `BLE_APP_AUTH.md` remains BLOCKED / NOT IMPLEMENTED.

### Validation and exact next action

- **Static source/read-back:** native branch now has one F branch and exact six-branch map; test source is present and the proposed contract is statically checked.
- **NOT RUN:** Dart formatter, focused/full Flutter tests, Flutter analyzer, Kotlin/Android Gradle compile, screenshots and device validation. This runtime has Git/Python/Java but no Dart/Flutter/Gradle/ADB.
- **Next:** owner must separately issue `Eksekusi Build App!` to run the guarded workflow on current `main`, confirm the duplicate-branch warning is gone and tests/analyzer/Gradle pass, then publish a package if all gates pass. This recommendation is not Build authorization.

---

## LAST VERIFIED APP BUILD — BUILD #159 SUCCESS / RELEASE VERIFIED — 2026-11-13

**Mode:** `Eksekusi Build App!` — selected App Build/QC scope is COMPLETED. This authorized scope covered the guarded App workflow, App analyzer/tests/Android Gradle, obfuscated APK, signing, matching source archive and Release integrity. No Firmware compilation/BIN, Firebase mutation, OTA, flashing or device operation was performed or authorized.

### Final immutable build evidence

- **Repository/branch:** `TenzoNkz/JEXFYZ-App` / `main`.
- **Build:** #159 / [GitHub Actions run 43376503987](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43376503987), workflow `374946166`, event `issues`, attempt 1; job `131724120379`; terminal `completed / success`.
- **Immutable tested/package source SHA:** `cdca38b9e4f2f99006db8feae40c07c6f9bdfb0a`. It includes the four owner-approved UI refinements from source checkpoint `a5d45866bb244a2f260330a0e2ea332c391a9fcd` and the test-only About role assertion repair `2c75c5b96db21937ec66c46f954d672a45384a7f`.
- **Trigger:** owner-authored Issue #36, exact guarded title/body token; prior issues #33 and #35 were left OPEN and not reopened. Exactly one Build #159 run was generated.
- **All workflow gates:** steps 1–21 SUCCESS; cleanup/post-job 39–43 SUCCESS. No further active/queued run and zero open PRs at final audit.
- **Dart analyzer:** passed; 23 info-level deprecations, 0 analyzer warnings, 0 analyzer errors. Current findings cover Flutter deprecated `onReorder`, Radio `groupValue/onChanged`, and Color channel accessors.
- **Flutter tests:** 187/187 passed.
- **Android Gradle:** `./gradlew --no-daemon :app:testDebugUnitTest` — `BUILD SUCCESSFUL in 2m51s`, 162 actionable tasks. Caveat: native `:app:compileDebugUnitTestKotlin`, `:app:compileDebugUnitTestJavaWithJavac`, `:app:processDebugUnitTestJavaRes`, and `:app:testDebugUnitTest` are `NO-SOURCE`; no Android native app JUnit cases executed. Existing Kotlin warnings include a duplicate `when` branch at `FloatingMonitorService.kt:738` and deprecated Notification priority APIs; Gradle reports deprecations ahead of Gradle 10.
- **APK:** `JEXFYZ-release.apk`, obfuscated release build with split debug info; 55,914,587 bytes; SHA-256 `02bef5960e0b23bea360d2cf8a0532e7dbd202e05f5420e055c98b4dc7a61321`. [Download APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- **Corresponding source ZIP:** `JEXFYZ-corresponding-source.zip`, 2,932,978 bytes; SHA-256 `5dbb29ebc7629775835bc65d655069a1a077f6d3240114387c965b5ad4789558`. ZIP integrity and embedded source marker passed. [Download source ZIP](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- **Signing:** one RSA-4096 signer; DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. V1/JAR, V2 and V3 pass for generated and downloaded APK. Trust caveat: cert is self-signed; jarsigner reports PKIX trust-chain failure, so it is not publicly CA-trusted. This does not negate the workflow's pinned certificate and APK scheme checks.
- **Release parity:** Release ID `403010611`, tag `jexfyz-latest`, Release target, Git tag target and source-bundle marker all match `cdca38b9e4f2f99006db8feae40c07c6f9bdfb0a`. Release contains exactly one APK and one corresponding source ZIP; API size/digests match above. Step 21 re-downloaded both, matched local/download hashes and passed ZIP integrity, source marker and downloaded APK signature/certificate checks.
- **Protected version:** Android Gradle `versionName "Telegram @horizontalzzz"` exact; Flutter version `1.0.0+3`.
- **Formatter/cache caveats:** guarded workflow has no Dart formatter gate; `dart format` is not claimed. Post-job cache-write attempts were denied because workflow token lacked writable cache scope, but these optional cache actions and cleanup still ended SUCCESS; no retry needed.
- **Historical Build #158:** remains FAILED at Flutter tests (185 passed / 2 failed) on source `285f3d6ea29378e9be4c711ede1705bf4abd821a`. Failure was two stale Indonesian About role assertions. The exact test-only repair is recorded above and Build #159 validates it. Never rewrite #158 as success.
- **Latest release source:** Build #159 replaces Build #157 as latest verified package. Build #157 remains an accurate historical release attempt.

### Repository ledger and final evidence boundary

- `APP_BUILD_REPORT.md` contains append-only #158 trigger/failure/repair and #159 trigger/progress/final success details, exact asset hashes, signatures, release and CI caveats. Final Build #159 record was appended in commit `fd0bd7c98bf66bb8bf25b5fe6fb0b32582bac373`.
- **Session status:** `COMPLETED`; `00_WORK_STATUS.md` and this checkpoint have been committed/read back. The final reconciliation audit is recorded in APP_BUILD_REPORT.md: pre-checkpoint main HEAD `7826e87b3075441e4249186edc6906f6aabfda96`, 133-entry non-truncated tree, 18 commits ahead/0 behind package SHA with only eight Markdown documentation files changed; no executable App/test/Firmware/Gradle/workflow paths changed. The report audit commit is `0f82c8450c4010729ba4d5acc97bcefa4d32319e`; this checkpoint update itself is documentation-only.
- **Next owner action:** install Build #159 and inspect actual device screenshots/behavior at 350-dp/420-dp, portrait/constrained height, EN/ID, Light/Dark, plus BLE reconnect and Lock Voltage behavior. Visual acceptance and physical-device behavior remain NOT VERIFIED until owner evidence is available.
- **Not covered by this build:** Firmware V7.2 compile/BIN, Firebase, OTA/flash, physical BLE/device/NVS/rail/LED, cooling/thermal/electrical, Android OEM screenshot acceptance. All remain NOT RUN / NOT VERIFIED. No Firmware/BIN/OTA/device operation occurred.
- **Final repo verification still to perform after closing documentation:** re-fetch root status, checkpoint, build report, summary docs; inspect current main HEAD/tree, Release/tag parity and Actions to confirm only Markdown documentation advanced beyond immutable package SHA.

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
