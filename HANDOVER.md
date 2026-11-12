# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-12 (Asia/Jakarta).

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

## Current App source change — ready for guarded QC, not packaged

- Current main SHA `a963f8bd100f7f2c41f720933ade2cd586145270`; tree 132 entries, not truncated.
- Usage Statistics selected-time dock is content-sized; widget regression checks ≤200 dp and Clear behavior. Graphs are 160 dp, axis labels 10 dp with tick-spacing-aware precision, spacing is tighter. Analytics indexes events by session/metric, de-duplicates/merges sorted updates, summarizes once per batch, skips sort if chronological, caches decimated points and uses binary search for cursor. SQLite sample + freshness write is transactional; schema v2, raw 1-Hz data, gaps and HOT-only P1 freshness remain. Serial queue capacity64/backpressure.
- Connection and Floating Monitor runtime polling are single-flight 3s/lifecycle-aware. Home header/tab and Temperature hit areas are 48 dp with artwork preserved. TamperScreen is neutral bilingual integrity copy in explicit dark theme; native signature fail-closed behavior remains unchanged.
- Current source suite is 185 declarations (172 unit/source-contract +13 widget), written but not run. Flutter/Dart formatter, tests and analyzer are BLOCKED / NOT RUN in this runtime. Long-session CPU/memory soak and real Android visual/touch QA remain unverified. No Build App or screenshot validation has occurred.
- Latest published package remains Build #153; current main is unbuilt.

## Next action

Issue a separate guarded `Eksekusi Build App!` on exact main SHA `a963f8bd100f7f2c41f720933ade2cd586145270`. Validate the 185-test suite, analyzer, Android package/signing/checksums/source ZIP and Release identity. If a gate fails, return to `Eksekusi Full!` for root-cause repair. After successful packaging, install and inspect Usage Statistics at 350/420 dp, EN/ID, Light/Dark, including selected-time dock height/clear, graph/cursor, session variants and long history. Also recheck Connection/Floating polling, Home/Temperature touch surfaces, TamperScreen and earlier Settings/Peltier/Temperature changes. Visual acceptance remains NOT VERIFIED until actual screenshots are reviewed.
