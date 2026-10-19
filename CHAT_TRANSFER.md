# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after recovering the approved Home NOTIFY alignment and Battery/Hotside/Voltage animation scope on 2026-10-19 (Asia/Jakarta). This is the canonical boot snapshot. Pre-transfer HEAD/tree below are live evidence immediately before this final transfer write; the transfer blob cannot self-reference its future hash.

## 1. Authority, scope and command protocol

- Canonical editable repository: TenzoNkz/JEXFYZ-App, branch main. Work directly on main; do not create branches/PRs unless explicitly requested.
- Pre-transfer HEAD: 49773d3acce176dd8bf88b7b9b686288d774ffca. Parent: ca9384ae29cf2b006ce956181f69d1e466a8498b. Tree: 6eb08808770eadbc0aa84f160b8d34cab9271fa9.
- Commands: Diskusi is read-only. Eksekusi Full permits scoped App source/tests/docs/audit/commit only; it does not authorize App Build, Firmware compile, BIN, Firebase, OTA, flash or device operations. Eksekusi Build App is the sole end-to-end App build/QC/release authorization. Chat Stuck recovers the latest valid authorized operation from evidence and never broadens scope or blindly retries.
- The combined user command was handled as a scoped Full execution with recovery: inspect actual source and test state first, resume only the approved task, do not start a build.
- The approved visual scope is: Battery/Hotside overheat effects replaced by oval ember bursts; Voltage central electrical spine/inner strikes replaced by outer-contour edge pulses; Home NOTIFY left-aligned and without CONNECTED/DISCONNECTED badge, with up to two readable lines. Adaptive, Peltier, Fan and Fan Speed are explicitly out of animation-change scope.
- Preserve semantic colours and telemetry/state authority. Do not alter BLE/protocol, warning thresholds, firmware safety predicates, control behavior or unknown-state rules.
- Preserve Android Gradle versionName "Telegram @horizontalzzz". The App repository owns all source, tests and project memory. Firmware artifact repository is BIN-only.

## 2. Current live App repository and source fingerprints

- Current HEAD before this transfer write: 49773d3acce176dd8bf88b7b9b686288d774ffca; recursive tree 6eb08808770eadbc0aa84f160b8d34cab9271fa9, 67 entries (49 blobs / 18 trees), not truncated. Five branches, zero open PRs.
- Current source implementation is already present in commit 8c12bb22e919e987aed3f11505242b94596a87f4 (redesign of oval thermal bursts and Voltage edge pulses). This recovery found no need to duplicate or reapply the functional patch.
- lib/main.dart blob: 7e09a3d28b4efe24bdced858db4274cf70806284.
- lib/app_settings.dart blob: 8f228000d38d73038c06f569c052b1af601288a5.
- test/widget_test.dart blob: 5a82cf79e6c5c40fc34489ce90cf1200cf9faccb.
- APP_NOTES.md blob after reconciling stale animation descriptions: 7603f2f2a9922efa846fb49496315229bcc641a5.
- DESIGN_NOTES.md: 15b71fa19705d936b15c4caef97f2d7f18565357.
- PROJECT_STATE.md: c6e76733fbab517f9e91c97840e7ea1f4da49b22.
- HANDOVER.md: 6e54be9431b748676eb2e9e561a99494b94e9fa5.
- MEMORY_INDEX.md: cb833ee5cdd8ad6028326b2dce40f957c521d6c0.
- CHANGELOG.md: ea2ff744b8b58826d77f75d44896f1f43d28353b.
- APP_BUILD_REPORT.md: fdbbb3d9507eea2b858c3b622c63126ceb82a9a2.
- CHAT_RULES.md: 58f48fc129fe89e4c563709d04febda451da7de3.
- BUILD_NOTES.md: 304ad67924638f9218beb0697053df69d30e8bc2.
- Workflow .github/workflows/jexfyz-app-build-trigger.yml: 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12. Guarded issue-open/reopen workflow; do not add push/PR/manual bypass.

## 3. Latest verified App release — Build #106

- Actions run 39279938461 completed successfully with source commit 9f90cf6063ee7786613f8b5dfa1c6b0412d89638. Analyzer exited 0 with 25 info-level findings and no errors/warnings; 108 Flutter tests passed; configured Android gate, APK signature/certificate, source ZIP integrity and downloaded asset checks passed.
- APK asset ID 656702702, 54,734,939 bytes, SHA-256 bab332a4312c628178e384a88d513cf8546ff15ab4b4e3f3becf2e70b10830cc.
- Corresponding source ZIP asset ID 656702729, 2,866,720 bytes, SHA-256 0bb86c4e6bd7d3cb7a6bb894658bd707acee48bac106fc5227f8adcba584ec98.
- Release jexfyz-latest and tag target Build #106 source 9f90cf6063ee7786613f8b5dfa1c6b0412d89638. Build #106 does not contain the current source follow-up below.

## 4. Current approved source follow-up — NOT RUN / NOT RELEASED

### Battery Temperature
- Existing exact warning predicate remains ≥40°C. The old animated tapered tongues, falling teardrop fragments, moving fill sheen and idle scanline are removed from the current source effect.
- The replacement draws deterministic, clipped oval ember bursts from the lower battery chamber: warm orange body, bright yellow-white core, restrained halo, short pulse/spread/rise, then shrink/fade.
- The 280 ms warning transition and all semantic colour/telemetry rules remain unchanged.

### Hotside Temperature
- Existing configured Hotside Limit and firmware safety predicate remain unchanged.
- Replace the old animated tapered tongues, falling teardrops and pulsing bulb with taller clipped oval ember bursts rising/spreading from the bulb inside the thermometer silhouette. Static tube/bulb/gauge geometry remains recognizable.

### Voltage
- Remove the moving central electrical spine and internal branch strikes. Bolt face and inner luminous core remain static.
- Two phase-offset light pulses follow the closed outer bolt contour with a white core, semantic-colour edge and soft halo. Preserve existing 5V red / 9V green / 12V blue mapping and current visual intensity classes (25% / 50% / 100%); this is not a real current measurement.

### Home NOTIFY and dashboard layout
- Keep the title/category and message left-aligned; do not restore center alignment. Keep the separate CONNECTED/DISCONNECTED badge removed.
- Short copy remains one line; longer copy wraps to at most two readable lines without FittedBox shrink-to-fit.
- The current Home metric row is 41 dp and the NOTIFY slot/container minimum is 48 dp. Keep these dimensions for now: they reflect evidence-based overflow repairs after runs #102/#103/#105. Do not revert blindly to 44 dp without separately proving that the dashboard no longer overflows.
- Regression source contracts now check oval thermal particles, absence of old animated thermal painters/drop paths, Voltage edge-only pulses, left-aligned badge-free NOTIFY, and the existing icon signatures.
- This recovery re-read current source and test contracts. Source-level checks confirmed these requested elements exist. There is no Flutter or Dart executable in the current execution environment; tests/analyzer for the current source have NOT RUN. Do not claim they pass.

## 5. Build recovery evidence and next gate

- Build #101 failed Dart analysis due to an unescaped test interpolation. #102 and #103 failed dashboard overflow checks (17 px then 14 px). #104 was cancelled during APK build/concurrency contention. #105 showed 106 tests passed and two failures (3 px dashboard overflow and a stale minimum-height source assertion). Fixes included 41 dp Home metric rows and a 48 dp NOTIFY slot/container; Build #106 passed against that older source.
- No new Build App was triggered in this recovery. Do not blindly retry. When the user issues @Thinking Eksekusi Build App!, validate the current intended main source through the official guarded workflow, then verify test/analyzer results, signing, APK/source ZIP, asset digests and tag/Release/source equality. Only that command authorizes the build.
- Build #106 remains the latest successful released artifact. The current left-aligned NOTIFY and oval-ember/Voltage-edge-pulse code is newer than Build #106 and is NOT RUN / NOT RELEASED.

## 6. Repository split and Firmware boundary

- Active App-repository sketch: firmware/JEXFYZ-V6.7.ino, blob efe6eaa62c178ab536fb68c06a310e54826cbaf2; project memory identifies embedded FW_VERSION as V6.7. Historical user-reported compile/update is not independently verified here.
- TenzoNkz/JEXFYZ-Firmware recursive tree contains exactly JEXFYZ.cpp.bin, blob dca6a1267762152519f6d2889e4f0adf46fd8803, size 1,457,008 bytes. BIN payload was not read; source-to-BIN provenance remains UNVERIFIED.
- No Firmware source/BIN, Firebase production metadata, OTA/flash/device operation was performed.

## 7. Audit result

- RECOVERED: the approved source changes were already committed; no duplicate functional patch or build was needed.
- Reconciled APP_NOTES.md, whose Home animation section still incorrectly described tapered flames as current, to the approved oval-burst/Voltage-edge contract; clarified that Build #100 validated the earlier static-state redraw while this post-Build-#106 source is still untested/unreleased.
- No Flutter/Dart tests or analyzer run; no App Build/release run. Physical-screen appearance, animation feel/frame pacing, current-source runtime wrapping, live BLE/PWM and hardware safety behavior remain UNVERIFIED.
