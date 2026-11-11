# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-11 (Asia/Jakarta).

## Latest verified App release — Build #143

- Actions run 42783474515, workflow 374946166, attempt 1; job 129718855331; conclusion success. All 21 required gates and post-job cleanup steps passed.
- Exact build/release source: 121ef9e0f5ed6a0003837d32e4c8b1701f38631a; tag jexfyz-latest and Release ID 403010611 point to this same commit.
- Analyzer: 25 info-level findings, 0 warnings/errors. Flutter tests: 159/159 passed. Android Gradle :app:testDebugUnitTest was NO-SOURCE; native Android JUnit coverage was not executed.
- APK V1/V2/V3 verification and the pinned production certificate passed, including after downloading the Release asset. Certificate SHA-256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- APK and corresponding-source ZIP are published with verified SHA-256/source marker/signatures. Android versionName "Telegram @horizontalzzz" remains preserved.
- **Important:** Build #143 predates the latest compact modal and animated Statistics source. Do not identify it as containing either change.

## Current Statistics source — 1-Hz diagram refresh; pre-build QC incomplete

- Latest App source/test checkpoint: `33fe9a545d7a8594e6e3a5119d3b1f564a93d868`. Files: `lib/usage_statistics.dart` (`0be670370685725283d51c84f1d33df83dd7e6e8`), `lib/main.dart` (`56e71dcaa482cabddd141cd3ae5c6cf28437ada7`), `test/usage_statistics_test.dart` (`af23d8b6b2e08d11ef28dc58496b574d1fa17e3b`).
- Six charts/readouts: Battery °C, Hotside °C, Voltage 5/9/12V, Adaptive ON/OFF, Peltier ON/OFF and Fan Speed 0–100%. Shared elapsed-time cursor reads all six.
- Peltier baseline is seeded from completed P1 full sync and subsequent state comes from telemetry-confirmed PELTIER events. Open-session chart coverage is bounded by the latest fresh HOT heartbeat. Raw sensor sampling remains about 1 Hz.
- **New owner adjustment:** page-level live diagram batches now flush every one second using `usageStatisticsDiagramRefreshInterval`. Pending live update objects remain accumulated until flush; no sampling/downsampling or database-write interval was changed. Temperature chart tweening continues to use Flutter vsync; Voltage/Adaptive/Peltier remain discrete.
- Regression source now includes an assertion for the one-second diagram refresh and independent data capture. It is committed but NOT RUN.
- **Remaining concern:** each one-second batch still recalculates the complete in-memory session summary; the SQLite read is avoided, but analytics are not yet truly incremental. Serialized write queue remains unbounded/unbatched. Add an incremental accumulator plus queue/long-session and animation lifecycle/frame-rate coverage before release packaging.
- No Flutter/Dart/Gradle toolchain is installed in the current environment: formatter, focused/full Flutter tests, analyzer and Android gate are BLOCKED / NOT RUN. Actual screenshot acceptance is VISUAL NOT VERIFIED.
- **Build readiness:** NOT YET RECOMMENDED for Build App until the remaining source/performance concerns and regression work are closed. Build #143 remains the latest verified APK and predates the Statistics source. Use a separate `Eksekusi Build App!` only after source readiness; no Build was triggered here.

## Guarded Build App workflow state

- Workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, current blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`; issue-only opened/reopened trigger; exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`; required body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Do not add push/PR release triggers.
- Owner issue #33 is OPEN with the exact title and body token. To emit a fresh `reopened` trigger event, it must be closed and reopened during the separately authorized Build App task.
- Latest Actions run is #143 / 42783474515, completed success. No active Build run appears in the latest Actions page. The jexfyz-latest tag and Release ID 403010611 still target #143 source SHA, not the current Statistics source.
- Build App's workflow must pass security/architecture audit, analyzer, full Flutter tests, Android Gradle gate, obfuscated APK build, mandatory V1/V2/V3 and pinned certificate, corresponding-source ZIP, exact tag/release target, exactly one APK plus one source ZIP, re-download hashes, source marker and downloaded signature checks.

## Compact modal source remains unbuilt

- Peltier safety dialog typography 20/15/14 dp and action minima 72×48 / 128×48 dp; fan-first safety flow unchanged.
- LED picker cap 312 dp width / min(308 dp, 82% safe-area height), six-column scrollable palette, all 36 colors, 48-dp cells / 32-dp swatches, explicit preview/Cancel/Select semantics.
- Source/tests remain newer than Build #143. Formatter/tests/analyzer and actual Android screenshots remain NOT RUN / VISUAL NOT VERIFIED.

## Next exact action

`Lanjut Eksekusi Full!` is the recommended (not yet authorized) next action to finish incremental analytics, backpressure and animation-lifecycle regression coverage. After those source fixes, owner must issue separate `Eksekusi Build App!` to start hosted QC/package. Never infer Firmware/BIN/Firebase/OTA/flash/device permission from App work.

Preserve mode boundaries: Diskusi! is read-only for executable source; Eksekusi Full! is App source/tests/docs only; Eksekusi Build App! is guarded App Build/QC/release only.
