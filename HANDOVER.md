# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-12 (Asia/Jakarta).

## Current source validation follow-up — 2026-11-12

- Live `main` HEAD: `82114a7540a7f225482c67ffb7772894c956b0b1` (132 entries, not truncated). The Usage Statistics source/test checkpoint is `6c551c4ff95329e56eca7ce758078c9590b4b726`.
- Main is 96 commits ahead / 0 behind Build #153; 18 paths differ. The release tag still targets old source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. There are no Actions runs for live main or the current source/test checkpoint.
- Recount: 187 current test declarations across 9 files (174 unit/source-contract + 13 widget). An independent Python simulation passed 60,726 randomized decimator fixtures; this is not Dart/Flutter test evidence.
- Local Dart/Flutter/Gradle/ADB are absent; outbound DNS to GitHub/Flutter SDK hosts is blocked. Formatter, focused/full Flutter tests, analyzer and Android Gradle remain **BLOCKED / NOT RUN**.
- The only Actions workflow is the guarded App build/release flow. It runs analyzer/tests/Gradle and publishes the APK/source ZIP but has no formatter step and no separate validation-only mode. It was not triggered.
- **Disposition: HOLD before Build App.** This Full session made documentation-only updates; no source/test/config/workflow change or Build/Release/device operation occurred.

## Latest verified App release — Build #153 SUCCESS

- Actions run [43145542329](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43145542329), job 130942369953, attempt 1; immutable source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. All workflow steps 1–21 and cleanup 39–43 passed.
- QC: App audit passed; analyzer 23 infos / zero warnings/errors; Flutter 176/176 tests passed; Android Gradle `BUILD SUCCESSFUL in 3m41`. Native app JUnit tasks were `NO-SOURCE`; no native Android JUnit cases executed.
- Release ID 403010611 / tag `jexfyz-latest` target exact source SHA above. Exactly one APK + one corresponding source ZIP; downloaded SHA values, ZIP integrity/source marker and downloaded APK V1/V2/V3/pinned-certificate verification passed.
- APK: 55,996,507 bytes, SHA-256 `d956959414eb085e1779c30bf035a0bbc64d18330e19b85251cc0ead90f5661c`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- Source ZIP: 2,929,311 bytes, SHA-256 `87808fe37f31e7fec589477a3c658a2f10fa06362bd72b173eeada95d3b03604`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- Certificate: RSA 4096, JE X FYZ DN, pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 verified. Keep self-signed PKIX trust-chain/no-timestamp `jarsigner` caveat explicit.
- Android `versionName "Telegram @horizontalzzz"` unchanged; app version 1.0.0+3.
- Build #152 / run `43144337555` remains a historical failure at Flutter tests (171 pass / 5 fail), no artifact. Its five failures, the three test-only repair commits and preservation of the failure are documented in APP_BUILD_REPORT.md. Build #153 passed 176/176 afterward.

## Boundaries / not verified

Build #153 proves hosted App CI/package/release only. No Firmware compilation, BIN generation/publication, Firebase modification, OTA, flashing, physical BLE/device/NVS/rail/LED testing, thermal/electrical cooling test, owner installation confirmation or OEM visual acceptance occurred. Firmware V7.2 compile/BIN and field validation remain separate.

## Current App source — bounded Statistics implementation; QC pending

- **Repository:** `TenzoNkz/JEXFYZ-App`, branch `main`. Current source/test code checkpoint `6c551c4ff95329e56eca7ce758078c9590b4b726`; `lib/usage_statistics.dart` blob `3afd0d8e440b5c4b7c19fb46b825a8a821e5492b`; `test/usage_statistics_test.dart` blob `fb665eeb3894a613c2a5bbcfb8ae72537b1c37a0`. Documentation-only commits follow this executable code checkpoint.
- **Writer admission:** 64 normal pending slots + 8 reserved control slots + 1 critical endSession slot (73 total). All producer admissions return immediately; accepted work executes FIFO and is not evicted. Excess incoming writes are rejected, counted and shown via a persistent bilingual “history may be incomplete” warning. This removes unbounded suspended producer Futures from fire-and-forget callers but explicitly accepts loss of incoming (not accepted) history during sustained overload.
- **Reserved operations:** session start/clear and Voltage/Adaptive/Peltier transitions may consume the 8 reserved slots; only endSession can consume the additional critical slot. Temperature samples and Fan Speed use the normal 64. Clear History propagates queue-full rejection to its existing UI error handler instead of silently appearing successful.
- **P1/gap integrity:** HOT freshness is based on actual Firmware HOT receipt time, not DB write progress. A DB backlog does not falsely timeout a continuously receiving P1 stream. A late HOT packet after the 2.5-second stale threshold does not refresh or enter the old session; the previous receipt remains for the watchdog to close through the critical endSession slot. Explicit null markers are stored when a sensor's persisted samples become stale or a session closes; HOT-stale close also stores a Battery gap before ending the session. SQLite schema v2, raw 1-Hz capture, retention and HOT-only freshness remain intact.
- **Chart rendering:** decimation now has a hard `maxPoints` ceiling. Bucket endpoints/extrema are kept; discarded null/`breakBefore` boundaries are carried forward on the next retained valid point so no rendered line bridges invalid time. Raw observations and summary inputs are never decimated.
- **Regression inventory:** 187 declarations (174 unit/source-contract + 13 widget). New cases exercise held writer/fire-and-forget queue submission, 64+8+1 bound, explicit rejection, FIFO accepted work and critical endSession acceptance, Clear error propagation, 24,000 alternating valid/null points across budgets 1/2/3/7/8/1599/1600, no-gap-bridging, late-HOT/P1-watchdog ordering and overload warning copy.
- **Validation boundary:** static source read-back, structural checks, delimiter scan and separate algorithm simulation completed. No Dart compiler or Flutter test execution. Flutter/Dart/Gradle/ADB are not available here; formatter, focused/full `flutter test`, analyzer and Android Gradle are **NOT RUN**. The guarded workflow has no formatter step. No Actions, App Build, APK, Release, screenshots, performance soak or device operation occurred.
- **Remaining performance/visual evidence:** one complete selected-session summary/chart pass still happens each 1-second batch. 1h/8h storage-pressure/backlog drain/rejection rate, CPU/memory, animation lifecycle/60–120-Hz frame pacing and 350/420-dp EN/ID Light/Dark screenshots remain unverified.
- **Latest package:** Build #153 remains the latest published artifact, source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`, run `43145542329`, Release ID `403010611`. It does not contain this current source/test code.

## Next action

**Terhambat — owner-side Flutter/Dart validation is required before guarded QC.** Run `dart format` check (the workflow does not enforce it), focused/full Flutter tests and `flutter analyze` against the exact source/test revision `6c551c4ff95329e56eca7ce758078c9590b4b726`. Review all results; only then should a separate owner command `Eksekusi Build App!` authorize guarded packaging. No Build App is authorized by this handover.
