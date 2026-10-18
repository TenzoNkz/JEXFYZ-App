# JE X FYZ / JE Cooler — Changelog

## 2026-10-18 — Distinct indicator motion, aligned toggles and centered menu locks (source-only)

- Rebuilt the Hotside thermometer into one continuous tube/bulb contour, eliminating the overlapping internal outline. Added distinct, phase-driven effects for Battery fill, Hotside liquid/bulb, Voltage flash, Adaptive directional arrows, Peltier branch highlights, Speed gauge glint, LED wave/dot and Bluetooth stem pulse. Fan rotation retains voltage-aware phase behavior and coast-down; no Bluetooth ripple rings or Peltier orbiting sparks were added.
- Non-Fan indicators keep quiet ambient cycles after the 440 ms active-state fade. These are visual-only idle motion, not a claim about physical output state. Fan OFF still coasts to a resting position.
- Peltier, Adaptive and LED switch rows now use neutral surfaces like Manual Voltage; their knob no longer includes a checkmark and the adjacent ON/OFF label is omitted. Theme-primary toggle accent and all BLE state/enable/command gates remain in place.
- Added a centralized menu-lock policy. Bluetooth disconnected blurs/dims the entire active submenu and centers one lock panel; top tabs and Home Bluetooth remain usable. Adaptive active/transitioning applies the same one-panel treatment only to Voltage, Control and Temperature. The content beneath the blur ignores pointer input.
- Added four Flutter test contracts for the lock matrix, one centered overlay, toggle styling and indicator contour/motion signatures. **Tests and Dart analysis were not run** because this environment has no Flutter/Dart executable. Build #73 remains the latest verified APK and does not contain this change; no APK build/CI, native compile, firmware, cloud or device actions were triggered.
- Source blobs: `lib/main.dart` `0f6335435570691c5e9509f3f1a2619cf351e732`; `test/widget_test.dart` `661130f0bc2197478cc5f0e083324bdc41c8e6a3`.

## 2026-10-18 — Opaque profanity warning screen and developer contact (source-only)

- Replaced the explanatory launch-rejection page with a dense, scrollable Indonesian slang/profanity wall; the page no longer shows a technical reason or any of the forbidden diagnostic wording. The warning remains JE X FYZ branded and keeps the contact action pinned at the bottom.
- Replaced the old Exit button with the single label `HUBUNGI DEVELOPER`. The existing security MethodChannel routes this action to Android `ACTION_VIEW` for `https://t.me/horizontalzzz`, without displaying the handle/URL on the screen.
- Preserved the pre-existing native signing-certificate gate and its debug-build allowance. This check compares signing identity; it should not be described as universal runtime detection of every tamper method.
- Added a Flutter widget contract for the copy, forbidden visible terms, and contact callback. A follow-up static review fixed a case-sensitive matcher in that new test; the test and Dart analysis remain NOT RUN. Source blobs: main.dart `bf2007203455c64c2dd840a84b31368063df44eb`, MainActivity.kt `ef35590cfc91fafe5dec104b7cfd7828011185bf`, app_settings.dart `36927823c91904a35d87d2f21bd77932a2214e83`, widget_test.dart `605d79e5019ba0cbe857d47d22db23e9204003a0`.
- Static text/bridge checks passed during preparation. Flutter tests/Dart analysis were **NOT RUN** because the runtime has no Flutter/Dart SDK and GitHub clone could not resolve DNS. No APK build/release, firmware, BIN, Firebase, OTA, flash or device operation occurred; Build #71 remains the latest verified APK.

## 2026-10-17 — Integrated 2D indicators, localization, master LED brightness and Adaptive V6.7 Fan PWM (source-only)

- Replaced stacked dashboard painter visuals with integrated 2D shapes and restrained phase-continuous motion; kept app identity, grille/logo, cards, layout and control semantics. Tests now check integrated silhouettes and retain Fan motion/gauge coverage.
- Refined EN/ID copy: dashboard `Suhu Panas` / `Hotside Temperature` (Hotside remains unhyphenated); Floating Monitor F is `Kipas` / `Fan` while PWM setting stays `Kecepatan Kipas` / `Fan Speed`; RGB toggle is `Daya RGB` / `RGB Power`; direction is `Kiri / Kanan` / `Left / Right`, without a center glyph.
- RGB ON/OFF gates only the user RGB effect. Voltage and system indicators remain independent, and lit physical `showAll` status paths use the master hardware Brightness; preview pixels remain readable at low hardware brightness.
- Active Firmware source advanced to V6.7 with a matching filename. Adaptive Fan PWM at 12V requires ten recent one-second NTC samples, average and every sample at/below `hotLimit - 2°C`, no meaningful warming trend and one stable 10-second interval before reducing 10 points every 10 seconds to 50%. Lost margin/warming raises 10 points per new sample; reaching the configured Hotside limit forces 100% immediately. Adaptive 5V/9V and existing Peltier/thermal safety remain unchanged.
- Current blobs: `lib/main.dart` 3bb9a772e7e4a192cd9b4457846b111e28ec305a; `lib/app_settings.dart` 77faaa80264ed65ab5c104588978bb903e9f89db; `firmware/JEXFYZ-V6.7.ino` 1d0fa0d5e308b9789fd1c32211ce0a127d497f6a; `test/widget_test.dart` 66861cad0638433bd7b575439bb4a2b637f1f856; `test/v6_7_qc_contract_test.dart` 6b71cc2ebbef9b3f1c9757728067eec4d11ff5ee; `test/firmware_touch_adaptive_sync_test.dart` 94c0f074247f47fce7d939a72b0130eb1b2d70fa.
- Static source checks only. Flutter tests/Dart analysis/Android build were not run, Firmware V6.7 was not compiled, and no APK release, BIN/Firebase publication, OTA, flash or physical-device validation occurred. Build #71 remains latest verified APK and does not contain these changes.
## 2026-10-17 — Dashboard motion continuity and manual voltage toggle styling

- Indicator motion now continues through the eased OFF fade before pausing. Reactivation preserves the last phase and travels to the next equivalent cycle boundary rather than restarting from phase zero. The Fan retains its separate voltage-phase handoff and coast-down behavior.
- Thermal flame motion uses integer harmonics to match its shape at the loop boundary; Battery segments have a subtle staggered ripple. The six-branch Peltier crystal stays visually stable while four bounded sparks orbit smoothly and fade with activity. These remain decorative App visuals only.
- Manual 5V/9V/12V rows stay neutral. Their active toggle uses the theme primary color without a check glyph, while voltage labels retain red/green/blue semantic colors. Other shared control toggles and the voltage command/lock/telemetry logic remain unchanged.
- Added source-contract regressions for activity fade/pause/resume, loop-compatible flame motion, Peltier spark orbit and manual voltage toggle styling.
- Source/tests/docs were committed under `Eksekusi Full`, which did not start a release build. Build #71 subsequently passed Dart analysis, 88/88 Flutter tests, Android production compilation/configured gate, APK signing, source archive and Release asset verification for these changes. Physical-phone animation/toggle checks remain pending.


## 2026-10-17 — Build #71 release verified: dashboard motion and manual voltage toggle

- Build #71 / [Actions run `39008259484`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39008259484) completed successfully against exact source/release commit `d9e026f70ec62455763de05048cba1557edfaf23`. All 21 active workflow steps passed: audit, dependencies, Dart analysis, **88/88 Flutter tests**, Android production compilation/configured gate, APK obfuscation, V1/V2/V3 signature/certificate checks, matching source ZIP, Release publication and re-downloaded asset verification.
- It includes motion-continuity refinements: OFF animation continues during the 440 ms fade before pausing; reactivation resumes retained phase and advances to an equivalent loop boundary; thermal flame geometry is loop-seam compatible; Battery segments ripple subtly; four bounded Peltier sparks orbit around the stable six-branch crystal.
- Manual VOLTAGE rows stay neutral, with only the active toggle using theme primary and no redundant check glyph; 5V/9V/12V labels retain red/green/blue semantic color. Voltage command/lock/telemetry behavior and other shared toggles remain unchanged.
- APK asset `649710440`, 54,603,867 bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`; matching source ZIP asset `649710439`, 2,847,410 bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`. Release `jexfyz-latest` targets the exact source SHA and the workflow verified both downloaded assets.
- The configured Gradle `:app:testDebugUnitTest` gate passed, but Kotlin/Java unit-test compile/test tasks were NO-SOURCE after FPS-specific native test cases were retired; do not count native JUnit cases as executed in Build #71.
- Physical animation smoothness, overlay layout, manual toggle visuals and live BLE/Fan Speed behavior remain **NOT DEVICE-VERIFIED**. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.



## 2026-10-17 — Build #70 release verified after FPS retirement

- Build #70 / run 38998407325 succeeded on exact source/release commit eb1224232241ca5d44d43e25919fd228875029ab. All 21 active workflow steps passed: audit, dependency resolution, Dart analysis (23 info-level deprecations), 86/86 Flutter tests, Android production compile/configured gate, obfuscated APK, V1/V2/V3 signature/certificate checks, matching source archive, publication and re-downloaded artifact verification.
- Build #70 includes FPS/Shizuku retirement and six Floating Monitor metrics B/H/V/A/P/F, with F=Fan Speed. Persisted schema v2 drops old schema-v1 F (FPS) and migrates S (Speed) to F.
- Native JUnit tasks were NO-SOURCE after FPS-specific parser/watchdog native tests were removed; no native JUnit cases ran in Build #70. Do not report the old Build #69 parser/watchdog test results as Build #70 test results.
- Released APK: asset 649412242, 54,538,331 bytes, SHA-256 229aaae5745456498d35f356ee6e0cdde81e7bb29f37238b1172f99f992ab404. Corresponding source ZIP: asset 649412243, 2,847,010 bytes, SHA-256 d0a79cdaf99b169b68cda04c5c3162062f493f0cb6f6ec02c1531950e4bbd8ae. Both match release target source commit eb1224232241ca5d44d43e25919fd228875029ab and were downloaded and verified by the workflow.
- Physical Floating Monitor visual/telemetry checks remain UNVERIFIED. Build #70 was App-only; no Firmware/BIN/Firebase/OTA/flash/device operation occurred.


## HISTORICAL / SUPERSEDED — 2026-10-16 — FPS retired; Floating Monitor Fan Speed label changed to F (later validated by Build #70)

- User approved removing FPS instead of continuing device-specific sampler diagnosis after repeated F:-- failures. Current source removes SurfaceFlinger/TimeStats polling, Shizuku permission/setup/status flow, Shizuku API/provider dependency and Manifest provider, UserService/AIDL, parser/watchdog source and tests, Shizuku-only Dart contract test, Shizuku license/notice files, and workflow requirements that bundled them.
- Floating Monitor now exposes six metrics only: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan Speed). Fan Speed telemetry/control behavior remains unchanged; only the Floating Monitor identifier/label changes to F.
- Persisted schema version 2 migrates older schema-v1 metric identifiers: legacy S maps to Fan Speed F; legacy F (FPS) is dropped, so an FPS selection cannot be misread as fan speed. Flutter contract tests cover migration and FPS/Shizuku UI removal.
- At this checkpoint Build #69 was the latest verified release; that status was superseded by Build #70 on 2026-10-17, which validated the FPS-removal source. No Firmware/BIN/Firebase/OTA/flash/device operations occurred as part of this changelog update.


Chronological record of durable App/Firmware decisions and prior approaches. Live source defines current implementation; older version entries are always historical.

## HISTORICAL / SUPERSEDED — 2026-10-16 — Build #69 release verified; native FPS tests rerun (superseded by Build #70)

- Build #69 / [Actions run `38896502185`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38896502185) passed the complete guarded App release workflow against exact source/release HEAD `01212c32a802ca0e67f559307fe4e19a667489c6`. All **21 active workflow steps passed**, including audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, APK obfuscation/build, V1/V2/V3 signing/certificate, source ZIP, Release publication and re-downloaded asset verification.
- Native Gradle tests completed with `BUILD SUCCESSFUL in 1m 30s`: four TimeStats parser cases and five watchdog-policy cases. Functional source remains unchanged from Build #67/#68 and includes TimeStats parser `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`, Shizuku bind timeout `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d`, and sampler exception isolation/watchdog `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46`. No test/gate was removed or weakened.
- Release `jexfyz-latest` targets Build #69. APK asset `647189019` (`54,636,716` bytes; SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`) and source ZIP asset `647189016` (`2,877,171` bytes; SHA-256 `1ab19e552c128d09773794738a6a4340abfa82086fa83f2d7e883ed62f60a699`) were both re-downloaded and verified. APK hash is unchanged from Builds #67/#68 because functional code did not change; ZIP source marker matches Build #69 HEAD.
- Expected production certificate remains `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID` / SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; built/downloaded APK V1/V2/V3 all true with one signer.
- Device boundary unchanged: physical Shizuku UserService binding, OEM TimeStats visibility, foreground FPS and overlay rendering remain **NOT DEVICE-VERIFIED**. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL / SUPERSEDED — Build #68 release verified; full release gates rerun

- Build #68 / [Actions run `38894177060`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38894177060) passed the complete guarded App release workflow against release/HEAD commit `1f35dcbc3c8bc85410e765b58430b4b485366c2c`. All **21 active workflow steps passed**, including audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, APK obfuscation/build, V1/V2/V3 signing/certificate, source ZIP, Release publication and downloaded asset verification.
- Native JUnit step completed with `BUILD SUCCESSFUL in 1m 52s`: four TimeStats parser cases plus five watchdog-policy cases. Functional source is unchanged from Build #67; its sampler watchdog/exception isolation, 35-second Shizuku bind timeout / 50.4-second Settings polling and TimeStats layer parser remain included. No test/gate was removed or weakened.
- Release `jexfyz-latest` targets exact source commit. APK asset `647139769` (`54,636,716` bytes; SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`) and matching source ZIP asset `647139772` (`2,877,222` bytes; SHA-256 `d957f4c966d725d848b6ebf39fb54a1affe4ce7d21cc2a773ce40a623493a317`) were both re-downloaded and verified. The APK hash matches Build #67 because no functional code changed; the ZIP source marker matches Build #68 HEAD.
- Expected production certificate DN/SHA-256 remain `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID` / `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; built/downloaded APK V1/V2/V3 all true with one signer.
- Not verified by CI: actual target-phone Shizuku service binding, OEM TimeStats visibility, foreground FPS and overlay rendering. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL / SUPERSEDED — Build #67 release verified; sampler watchdog built and CI-tested

- Build #67 / [Actions run `38890997565`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38890997565) passed the full guarded App pipeline against release/source commit `8efbfebe1b12e162dccddbdf68b8627d8723f756`. All **21 active workflow steps passed**, including audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, APK build, V1/V2/V3 signing/certificate validation, source archive, Release publication and downloaded asset verification.
- It includes sampler exception-isolation/watchdog checkpoint `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46`, with a 60-second startup-progress timeout and 30-second polling-progress timeout, localized failure statuses, and five pure Kotlin watchdog-policy JUnit cases. Four existing TimeStats parser JUnit tests and all 88 Flutter tests also passed. No tests or gates were removed/weakened.
- Release `jexfyz-latest` targets the exact Build #67 source and contains one APK asset `647067767` (54,636,716 bytes; SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`) plus one matching source ZIP asset `647067768` (2,877,328 bytes; SHA-256 `4b5403d27d74167cd2c15ca6c5eb780d9622b5be0924c42c04256e240d9545cd`). Both were re-downloaded and verified. V1/V2/V3 and production certificate checks passed.
- The earlier Build #66 Shizuku bind timeout repair (35-second client deadline, 50.4-second Settings polling) remains included and verified.
- Still NOT DEVICE-VERIFIED: Shizuku UserService binding on the target phone, OEM TimeStats visibility, real foreground FPS and overlay rendering. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL / SUPERSEDED — FPS sampler exception isolation and progress watchdog first committed (later verified by Build #67)

- After Build #66, the user's screenshot showed Shizuku access granted but the Floating Monitor still showed `starting` and `F:--`. This is the visible status, not proof of the exact runtime cause.
- Source commit `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46` wraps capture startup and periodic TimeStats polling in exception handling. This prevents an unexpected polling exception from silently cancelling future scheduled executions without a status.
- Added a main-handler progress watchdog: 60 seconds without startup progress and 30 seconds without polling progress. It reports `sampler_start_timeout` or `sampler_stalled`, cancels on sampler stop, and adds localized exception status messages. New pure Kotlin `FpsSamplerWatchdogPolicy.kt` and five JUnit policy tests were added; Flutter source-contract assertions were updated.
- **State when this entry was first recorded:** `@Thinking Eksekusi Full!` authorized source/test/documentation changes, not App Build, so the code was initially untested/unbuilt. Build #67 later passed 88/88 Flutter tests, four TimeStats parser JUnit tests, five watchdog-policy JUnit tests and the full Android release pipeline, so this patch is now built/CI-tested. Root cause on the target phone and actual FPS remain unverified pending device evidence.
- App-only. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL — Build #66 verified; superseded by Build #67

- Build #66 / [Actions run `38859288444`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38859288444) passed the full guarded App release pipeline against source/release commit `a2b19d4708f3075730132ac16f375f2a352aa50a`. All **21 active workflow steps passed**, including audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, APK obfuscation/build, V1/V2/V3 signature/certificate checks, source ZIP validation, Release publication and downloaded asset verification.
- It includes timeout fix `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d`: native UserService binding deadline `35_000L`, localized 35-second status message, and Settings polling every 350 ms up to 144 iterations (50.4 seconds). This corrects the previous 6-second local deadline that could abandon a cold start before Shizuku's 30-second server window expired.
- Release `jexfyz-latest` targets the exact source. APK asset `646344237` (54,636,716 bytes; SHA-256 `cae0364670324511551742295a40fc4208399a5de4330b5a18d5d43ca5d488cf`) and source ZIP asset `646344244` (2,874,306 bytes; SHA-256 `9a3a008e377fa6bdcc7d4add2fecbce9167df88b2b0ce924512ca703e5eeac69`) were re-downloaded and verified. V1/V2/V3 and production certificate checks passed.
- Build #63's stale widget assertion and Build #64's 2 GiB Gradle heap failure plus their repairs remain recorded below. Build #65 verified the prior TimeStats implementation; Build #66 then verified the timeout repair without removing tests or gates.
- Still NOT DEVICE-VERIFIED: actual Shizuku service binding on the target phone, OEM TimeStats availability, foreground FPS and overlay rendering. App-only operation; no Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL — 2026-10-16 — Shizuku UserService bind timeout repair committed; later verified by Build #66

- Screenshot evidence showed permission granted but `UserService did not connect within 6 seconds (shizuku_userservice_timeout)`. Official Shizuku's UserServiceManager allows up to 30 seconds for a process to start; the App's 6-second client timeout could retire/unbind a slow valid cold start before the server's startup window expired.
- Source commit `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d` changes the local deadline to 35 seconds (server's 30-second startup allowance plus callback grace), extends Settings polling to 50.4 seconds and updates localized status text and source-contract tests.
- **Initial state when committed:** this was `@Thinking Eksekusi Full!`, not Build App, so source commit `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d` was initially unbuilt. Build #66 later validated it through Dart analysis, 88/88 Flutter tests, native JUnit, Android release build/signing and downloaded asset verification. The timeout alignment remains an evidence-based mitigation; service connection/FPS on the target phone is still unverified.
- App-only scope. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL — Build #65 release verified (superseded by Build #66, later #67)

- Build #65 / [Actions run `38851040144`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38851040144) passed the full guarded App release workflow against source `f301c1fbbafa3d6c17803d9a2f50bae390dc1343`. All **21 active steps passed**, including App audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, obfuscated APK, V1/V2/V3 signing and certificate, matching source ZIP, Release publication and downloaded-asset verification.
- Includes TimeStats sampling/parser patch `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`, test-only widget contract repair `14347cd731b2c471fea9937f796ca21f8defc261`, and Gradle heap increased to `-Xmx4096M`.
- Release `jexfyz-latest` contains APK asset `646151731` (54,636,716 bytes; SHA-256 `6823d87dbe25ded3ee5fd399ff231423078f9a33e814d7a80aed8ed1fe1b5b87`) and matching source ZIP asset `646151729` (2,874,038 bytes; SHA-256 `df96a3cf43c860370d776995bff2ef4861ccf9f5e84744b49adb0cdab79d13cc`). Both were re-downloaded; asset hashes, embedded source marker and production APK signatures match the release source.
- Build #63 failed on a stale source-contract assertion (87 passed, 1 failed); assertion repair was test-only. Build #64 passed Flutter tests but native Kotlin/JUnit hit `Java heap space` under the old 2 GiB heap. Raising Gradle heap to 4 GiB resolved that resource failure; Build #65 passed both gates and the entire release pipeline without removing tests or weakening gates.
- Still NOT DEVICE-VERIFIED: actual Shizuku UserService binding on the target phone, OEM TimeStats visibility, foreground FPS and overlay/icon rendering. This was App-only; no Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL / SUPERSEDED — 2026-10-16 — FPS TimeStats sampling repair committed to main (later verified by Build #65)

- Source commit `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620` changes Floating Monitor sampling to bounded `SurfaceFlinger --timestats -dump -clear -maxlayers 64` calls every 500 ms, uses per-interval `averageFPS`, prefers SurfaceView/BLAST, matches TimeStats `packageName` when available, broadens foreground marker parsing and improves permission-error classification.
- Added `FpsTimeStatsParser.kt`, four native JUnit parser tests, JUnit dependency and guarded workflow step `:app:testDebugUnitTest`; updated Flutter source-contract assertions to the new method.
- **State at initial recording:** this entry initially described an unbuilt patch; Build #63 later exposed one stale widget assertion and Build #64 hit the 2 GiB Gradle heap during the native JUnit gate. Build #65 then passed the repaired tests and full release pipeline. Physical Shizuku, OEM TimeStats visibility and live FPS remain unverified; no claim of 100% device success is made.
- Repository boundary: App source/docs/tests/workflow only. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL / AS-OF-BUILD-62 — Chat Stuck recovery: final memory and reference audit

- Recovered the authorized full project-memory reconciliation against live `main`, rather than retrying previous writes blindly. Confirmed the recursive tree is complete/not truncated (80 entries), five branches exist with zero open PRs, the only active App build workflow is the guarded issue-triggered `.github/workflows/jexfyz-app-build-trigger.yml`, Build #62 remains the latest verified release, and current `main` changes after its source target are documentation/memory only.
- Rechecked the current App identity/version, Android Gradle `versionName "Telegram @horizontalzzz"`, active Firmware `firmware/JEXFYZ-V6.6.ino` with `FW_VERSION="V6.6"`, all six active tests and their current blob IDs, exact Build #62 source/release and asset hashes, branch/PR state, and artifact-repo tree. `TenzoNkz/JEXFYZ-Firmware` still contains exactly `JEXFYZ.cpp.bin`; its source-to-BIN provenance remains unverified.
- Corrected the stale opening validation sentence in `VOLTAGE_TRANSITION_MEMORY.md`: Build #62 executed the App Flutter suite and passed 88/88, including source-contract checks in `test/v6_6_qc_contract_test.dart`; this is not Arduino compile or physical voltage-transition evidence. Marked the OTA static checklist as a future explicitly authorized preflight that was not run in this reconciliation.
- Audited Markdown links across all 21 Markdown files. Active canonical docs have no missing local Markdown targets. Some root-relative links in the three frozen `archive/*.md` snapshots no longer resolve when viewed from the `archive/` subdirectory; archives were intentionally left byte-for-byte unchanged, and README/MEMORY_INDEX now document the caveat and direct readers to canonical root files.
- Read the existing `CHAT_TRANSFER.md` in full before replacing it. This transfer file is the last file to be written; it will be re-read with its new blob SHA/HEAD after the other docs are verified.
- No App source, tests, active workflow, Firmware source/BIN, Firebase, OTA, physical device, App Build or Release was changed or triggered by this reconciliation. Release #62 remains the latest verified artifact; physical Shizuku/FPS/overlay behavior remains unverified.

## HISTORICAL / AS-OF-BUILD-62 — Full project-memory reconciliation after Build #62

- Audited live App `main`, the complete recursive tree, current App/Firmware source identities, guarded Build App workflow, all six active test files, current Actions/Release evidence, five branches, zero open PRs, and the BIN-only artifact repository.
- Corrected stale current-state documentation: README's duplicate validation block still cited Build #60 artifact IDs/hashes; PROJECT_STATE still called the now-Build-#62-verified Shizuku lifecycle patch "unbuilt"; MEMORY_INDEX still directed readers to preserve only older Build #54; the Firmware Technical Reference incorrectly labeled user-accepted V6.6 "NOT RELEASED", and FIRMWARE_NOTES.md still cited Build #54 as its latest App CI evidence. Those statements were reconciled to live verified/current and user-reported/unverified evidence.
- Confirmed Build #62 source/release commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4` remains the exact published source. Comparison of release source to current `main` found documentation-only commits; no App source, test, workflow, Firmware source or artifact was changed after that release source.
- No Firmware compile, BIN generation/publication, Firebase/production metadata, OTA, flash, hardware/device operation, App Build trigger or release operation occurred during this documentation reconciliation.

## HISTORICAL / SUPERSEDED — 2026-10-16 — Build #62 release verified; Shizuku binding lifecycle built and CI-tested (superseded by Build #65)

- Build #62 / [Actions run `38841458441`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441) passed the complete guarded App release workflow against source `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. All 20 active workflow steps passed, including audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK compilation, V1/V2/V3 plus expected certificate checks, source ZIP validation, release publication and re-downloaded asset identity/hash/signature verification.
- It includes Shizuku UserService binding lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae`. The test-only fix in `test/widget_test.dart` matches the per-attempt bind call and current WindowManager foreground diagnostics; no native behavior was weakened and no test was deleted.
- Release `jexfyz-latest` targets the exact source and has one APK asset `645909183` (54,636,716 bytes; SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`) plus one matching source ZIP asset `645909184` (2,871,177 bytes; SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`). Both were re-downloaded; APK V1/V2/V3 and production certificate checks passed.
- Build #61 / run `38841172623` is preserved as a failed attempt: audit/dependencies/analyzer passed, then the stale widget assertion failed (87 passed, 1 failed); APK/release steps were correctly skipped. Build #62 passed after the source-contract repair, without weakening or deleting gates.
- Not proven by CI: actual Shizuku binding/lifecycle on the target phone, OEM SurfaceFlinger layer access, foreground FPS and overlay rendering. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## 2026-10-16 — Shizuku UserService binding lifecycle hardened (source checkpoint later verified by Build #62)

- Source checkpoint subsequently included in Build #62: `225cc9ae4c67b3fbb76426db3b2503ef6934aaae`, following commits `faedb1057904375c2add46eb731dd96d91bcfa41`, `806af710d14fd31bc09098628ed719db5a4baa7f`, `c53b21587ef8681cfb7aecb2f0159672e4e8fda4` and `891edea5c1c9e8e66db399106d7f1721f89dee61`.
- Replaced shared Shizuku binding state with per-attempt `UserServiceArgs` tag, `ServiceConnection`, generation and `CountDownLatch`. Binding/timeout/disconnect/cancellation are explicit states; late callbacks are rejected and cleaned by that attempt's tag, not a newer attempt's service.
- Exposes precise binding/remote failure codes; adds bounded logs for bind/callback/cleanup, UserService UID, command exit/error/output size, foreground source, matched layer and final frame sample. Raw dumpsys output is not logged. Stop cleanup now attempts `--disable` only when an existing connected/alive UserService is available, avoiding an immediate rebind after Binder failure.
- Updated `test/shizuku_fps_contract_test.dart` and `test/widget_test.dart`, including raw-string fixes for literal `# JE X FYZ / JE Cooler — Changelog

Chronological record of durable App/Firmware decisions and prior approaches. Live source defines current implementation; older version entries are always historical.

 assertions. At the time this source-only history entry was first recorded, analysis/tests/build had not yet run. Build #61 exposed one stale widget-test assertion; the test-only correction in commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4` resolved it, and Build #62 later passed all 88 tests plus the full Android release/signing/asset pipeline. Physical-device verification remains pending.

## HISTORICAL / SUPERSEDED — 2026-10-16 — Build #60 release verified (superseded by Build #62)

- Build #60 / [run `38817543342`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38817543342), trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33), succeeded on exact source commit `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`.
- All release gates passed: security/architecture/license audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, obfuscated APK build, V1/V2/V3 signature and production certificate, matching-source ZIP, Release publication and re-downloaded asset hash/signature verification.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains APK asset `645381550` (`54,636,716` bytes, SHA-256 `47892215de179c8cb2975ad5c99b8b3b1398559873352411ed74d001aa001274`) and source ZIP asset `645381553` (`2,866,092` bytes, SHA-256 `dd9bdc1f8082c70ab2ff73892f5434057d36cedc870fd92184b8ed579e2b538a`), both matching commit `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`.
- Diagnostic checkpoint `6e9b4c73db12c51f4452717d8cf102f49d325dcf` adds a fixed full `dumpsys window` fallback, waits for a valid sample, distinguishes valid zero from missing/invalid/reset snapshots, cancels stale FPS polling tasks on retry, and displays native sampler status in Settings.
- Build #59 exposed one outdated assertion expecting `lastPositiveSample` / `verifiedZero` even though the current implementation correctly uses `validZero` without requiring a prior positive sample. Test-only repair `7a576e60f0938cec94fcddb96340cd5376fa15de` asserts the current behavior and full-window fallback. Build #60 passed all tests; no test/gate was deleted or weakened.
- **Physical-device behavior remains UNVERIFIED:** live FPS, Shizuku UserService behavior, OEM SurfaceFlinger access, overlay layout and animation rendering still need a device check. CI does not validate Firmware/BIN, Firebase, OTA, BLE hardware control or cooling safety. No Firmware/BIN/Firebase/OTA/flash/device action occurred.

## 2026-10-16 — Icon/FPS source repair included in Build #58

- Source commit [`98cfe7ba4d0e9d569b84498d261ad1b67f66eee7`](https://github.com/TenzoNkz/JEXFYZ-App/commit/98cfe7ba4d0e9d569b84498d261ad1b67f66eee7) restores Build #54 `_JexIconPainter` geometry while retaining interpolated activity effects.
- Floating FPS preserves the user-selected metric `F` when Shizuku is unavailable, uses a fixed WindowManager focus operation with ActivityManager fallback, and distinguishes verified zero-frame samples from first/invalid/reset samples.
- Test-contract correction `432c30ec538ff7de6c7e77f0c68bac313f4f8015` was included in Build #58 after Build #57 exposed five outdated assertions. Build #58 then passed Dart analysis, 87/87 Flutter tests, APK build/signing and release artifact validation. Actual phone rendering and live FPS remained device-unverified.

## 2026-10-16 — App Build #55 success; indicator/Floating Monitor/screen-FPS source released (device verification pending)

- [Build #55 / run 38783100421](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38783100421), triggered by [issue #28](https://github.com/TenzoNkz/JEXFYZ-App/issues/28), built exact source commit `3ba172b3f35f4ec01732d5848a7ffc807663e710`. The functional source checkpoint `311a18934a3cbe86a2a4718442c92541f081183f` is included; commits afterward only synchronized documentation.
- All release gates passed: architecture/security/license audit, dependency resolution, Dart analysis, 86/86 Flutter tests, obfuscated APK compilation, explicit V1/V2/V3 signing and certificate checks, source archive validation, Release publication and downloaded asset identity/hash/signature verification.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has exactly one [APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) (asset 644735661, 54,538,412 bytes, SHA-256 `1ae3ef476c170ab0a9d78a77264c5281d60341a931db102c7b8645e4b0dadd19`) and one [matching source ZIP](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) (asset 644735668, 2,860,630 bytes, SHA-256 `112b14a95f4b21fa04cdd5684e4a0124ee4b50cb17636bcef149e71a20481dce`).
- The new indicator colors/animations, Floating Monitor controls and focused-window SurfaceFlinger FPS code are now built and CI-tested. Actual device rendering, Shizuku UserService operation and OEM foreground FPS/layer availability remain UNVERIFIED pending phone-side checks.
- Non-blocking warnings include 23 Dart deprecation infos, 11 dependency updates outside constraints, Kotlin Gradle Plugin 2.2.20 and Gradle 9.3.1 migration notices, native DWARF metadata, jarsigner self-signed/no-timestamp/META-INF warnings and a post-job cache-write scope warning. All required signature/checksum gates passed; no Firmware/BIN/Firebase/OTA/flash/device action occurred.

## HISTORICAL — 2026-10-16 — Indicator redesign, Floating Monitor controls and foreground screen FPS (pre-Build #55 checkpoint)

- Source changes committed directly to App main through latest source/test checkpoint `311a18934a3cbe86a2a4718442c92541f081183f`; the recursive tree is complete with 80 entries. No PR was opened.
- Home indicators: disconnected states retain semantic low-state accents instead of black/grey; Battery is Ice Blue through 30°C and Burning Red from 40°C with a smooth intervening palette; Hotside is Ice Blue through 30°C and transitions to Burning Red at the configured Hotside Limit. These are presentation thresholds only and do not change Firmware safety logic. Manual voltage text/accents are 5V red, 9V green, 12V blue.
- Icon painter redesigned with tighter geometry, bounded effects, clipped energy sheen, smooth activity transitions and phase preservation rather than resetting every icon to its first frame. Fan, Speed, Adaptive, Peltier, Battery, Hotside, Voltage and Bluetooth artwork use the revised painter.
- Floating Monitor size is now 0.30×–1.00× in 0.05× increments, including Flutter runtime synchronization and native overlay bounds; opacity snaps to 5% increments and removes the 50% midpoint label; Display Style is removed with legacy Icons settings normalized to Letters; vertical rows are left-aligned. Shizuku UI shows only Access Granted/Denied and Grant Shizuku Access / Check Access.
- FPS sampler no longer blocks JE Cooler, launcher, Settings or Android system UI as foreground targets. It prioritizes focused-window package identity and matches that package's SurfaceFlinger layers. After the initial baseline, a visible layer with no new presented frames reports 0 rather than returning to -- solely due to a stable frame count. Real device/OEM SurfaceFlinger access remains UNVERIFIED.
- Updated source-contract tests for thermal bounds, voltage/disconnected colors, animation geometry/transitions, Floating Monitor migration/slider steps and generic foreground screen FPS. Flutter/Dart tests and analysis were NOT RUN because this runtime has no Flutter or Dart executables. No Android/App build, APK release or physical-device validation was performed.
- At this point in the timeline, Build #54 was the latest verified release and did not include this newer source. Build #55 subsequently built and released these changes; see the current Build #55 entry above. Firmware source, BIN-only artifact repo, Firebase, OTA and physical hardware were not touched.
## HISTORICAL / SUPERSEDED — 2026-10-15 — App Build #54 success (Build #55 is latest; physical Game FPS remains unverified)

- Build #54 / run 38767611593 built App source commit 437e7730dbcaf9666ae4828e546a45343bb4890c. Dart analysis and all 86 Flutter tests passed; Android release APK compiled and passed explicit V1/V2/V3/certificate checks; corresponding source ZIP validated, published and re-downloaded with matching SHA-256. Release jexfyz-latest contains exactly one APK plus one source ZIP.
- APK asset 644438898, 54,636,716 bytes, SHA-256 cdf8a7f94424b9cb60be6e04489a9f0f0d8ddad43ab76c33c2e2c6333fa61327. Source asset 644438897, 2,862,590 bytes, SHA-256 3b208c987def59a7c1857ed0fcc9ca5d74d591767e5658dfab04c9c1be85450f.
- Builds #50–#53 exposed and repaired an analyzer warning, temperature-source parser assertions, AIDL transaction-ID mismatch, then an outdated AIDL assertion. Failures remain in APP_BUILD_REPORT.md; the gates were not weakened.
- After the release, the user reported Shizuku permission granted while F remains --, with other telemetry showing in a screenshot of JE Cooler's settings page. Source deliberately does not count JE Cooler as a foreground game, so no_game_foreground is plausible but not a proven runtime diagnosis. Test with a real foreground game; if unresolved, capture fps_monitor_status and logs. CI does not prove live game FPS.
- No Firmware compile, BIN/Firebase update, OTA, flash or physical-device operation was performed as part of the Build #54 source release/verification.


## HISTORICAL / SUPERSEDED — Floating Monitor visual controls (2026-10-15; later included in Build #55)

- Floating Monitor remains freely draggable. The alignment change is inside the box only: horizontal metric groups are centered as a group, and vertical rows are centered individually. Native WindowManager gravity stays `Gravity.TOP | Gravity.START`; drag offset persistence is preserved.
- Native HUD spacing is tightened (5dp-scaled inter-metric gap, 8dp-scaled horizontal padding, 5dp-scaled vertical padding) and the corner radius is reduced.
- Size is normalized to `0.30×–0.80×` in `0.05×` steps, with current numeric value shown in the menu. Default is `0.60×`.
- Background Opacity covers `0–100%` (stored as normalized `0.0–1.0`), with live numeric percent and scale labels `0%`, `50%`, `100%`. At 0%, only the background vanishes; metric text remains visible.
- Background color is user-selectable Black/White, persisted with FloatingConfig and applied natively; foreground text and icons switch to a contrasting color. Default remains Black and Opacity remains 90%.
- Source/test blob hashes at this checkpoint:
  - `lib/floating_monitor.dart`: `3516b742d39e86c8796a0e77f77c0e9c1f1c1110`
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `0c9cfdee776ca2f1de5daf2205d1f9f8da63683d`
  - `lib/app_settings.dart`: `46cc838f43a06c325af6f6832e200a4e1ed4f75d`
  - `test/floating_monitor_layout_contract_test.dart`: `31d9aabf4ac0839855308b6bd2a0708fa399a3a9`
- Source-level contract tests were added but are NOT RUN. No Dart analysis, Flutter test run, Android/Kotlin compile, APK build, release, workflow trigger or physical-device validation was performed. Build #49 remains the last verified APK and does not contain these changes.
- Firmware V6.6, firmware/BIN repository, Firebase, OTA, flash and physical device remain untouched.


## HISTORICAL / SUPERSEDED — Shizuku FPS migration source checkpoint (2026-10-15; later included in Build #55)

- Shizuku permission is now the FPS gate: the user must have Shizuku running and approve JE X FYZ through Shizuku's own permission dialog before metric F can be selected.
- Added official Shizuku provider integration, AIDL and restricted UserService with a fixed FPS operation allow-list. The ordinary app process no longer executes dumpsys or uses the manifest DUMP permission.
- Removed Wireless ADB pairing/identity-store source, Kadb/SPAKE2 dependencies and licenses, ADB grant/revoke UI and obsolete pairing test. Added Shizuku API/provider 13.1.5, MIT notice/assets, updated workflow license/source packaging and a dedicated Shizuku contract test.
- Source checkpoint: b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b. Widget and Shizuku source-contract tests are committed but have NOT RUN; no Android build or release was triggered. Current APK remains Build #49's older source 2b2d2886abb66481b7134e5036824f625ab5659d.
- @Thinking Chat Stuck! recovered the latest source state and saved this report; it did not authorize an App Build. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.
## HISTORICAL / SUPERSEDED — Thermal indicator source checkpoint (2026-10-15; later included in Build #55)

- App source commit `8b58c7033a5462864b52cb921ca25c714bca902f` committed directly to `main`: `lib/main.dart` blob `3eeb4dff7b7fbb52a44022e5e2b130bc1826da23`; `test/widget_test.dart` blob `e673bdbc5ffa80791564b1138db28c6a8731aaec`.
- Thermal Battery now treats its segmented fill as temperature level (20°C empty, 30°C half, 40°C+ full), transitions from ice blue through cyan/green/amber/orange to red, and shows animated fire at ≥40°C. Text and icon colors tween together. The existing phone battery-temperature read and one-second firmware heartbeat are unchanged.
- Hotside color/fill follows the configured live firmware `hotLimit`; fire appears at the configured limit. Voltage uses red/green/blue at 5V/9V/12V and graduated discharge energy. Home/menu Fan/Peltier/Adaptive indicators now get matching semantic colors and voltage/speed state parameters.
- Added three thermal unit-test groups and an updated voltage painter source-contract test. They have **not been run**; no Build App workflow was triggered and no APK/source bundle was regenerated for this source.
- Last successful Release remains Build #49 from source `2b2d2886abb66481b7134e5036824f625ab5659d`; `jexfyz-latest` does not include commit `8b58c7033a5462864b52cb921ca25c714bca902f`. Run the explicitly authorized App Build workflow to analyze/test/build/sign/release the new source.
- No firmware source/BIN, Firebase, OTA, flash or device operation occurred.

## HISTORICAL / SUPERSEDED — Build #49 successful App release (2026-10-15; superseded by Build #55)

- Official issue-triggered [Build #49 / run 38739077916](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38739077916) used issue [#22](https://github.com/TenzoNkz/JEXFYZ-App/issues/22) and built source commit `2b2d2886abb66481b7134e5036824f625ab5659d`. Job `116435785328`, hosted runner `1000002352`; run completed SUCCESS at 2026-10-15T13:06:51Z.
- Security/architecture/license audit, dependency resolution, Dart analysis, all **80 Flutter tests**, obfuscated APK compilation, V1/V2/V3 signing and official production certificate checks all passed. The source ZIP passed integrity/content/path/license assertions. Release publication and re-downloaded APK/source verification passed; all main workflow steps succeeded.
- Release `jexfyz-latest` now targets the exact built source revision and has two assets only: `JEXFYZ-release.apk` (asset `643896939`, 56,087,614 bytes, SHA-256 `d365a99812470986de08be4df1bd54254fe1eb1ea1e3739806d03a6503e3c52a`) and `JEXFYZ-corresponding-source.zip` (asset `643896917`, 3,156,558 bytes, SHA-256 `51783b82eae47fc69ab08dd90521e5acdeed0988600042dd1bc3b94f5483dbc8`). The downloaded APK/source were independently verified by the workflow.
- Build #48's job annotation identified the pre-step blocker as recent account payment failure or a spending limit that needed increasing. Build #49 subsequently allocated a hosted runner and completed the full release pipeline without changing the workflow or adding manual dispatch; the precise external billing action is unknown.
- Workflow remains issue-open/reopen only, guarded by repository owner, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. No push/PR/manual trigger was added.
- CI does **not** verify physical-phone UI, BLE/cooling/safety, FPS/overlay, installed Firmware or OTA behavior. No Firmware source/BIN/Firebase/OTA/flash/device operation occurred.


## HISTORICAL — Command protocol and App build trigger rename (2026-10-15)

- Canonical command spellings use no `#`: `@Thinking Diskusi!`, `@Thinking Diskusi! Tanya Gemini!`, `@Thinking Diskusi! Jawaban Gemini!`, `@Thinking Eksekusi Full!`, `@Thinking Eksekusi Build App!`, and standalone `@Thinking Chat Stuck!`. Legacy aliases `@Thinking Build App!` and `@Thinking Eksekusi & Build App!` are retired. Gemini commands still require `Diskusi!` in the same message.
- Renamed the active workflow display name to `JE X FYZ Eksekusi Build App`; the file path remains `.github/workflows/jexfyz-app-build-trigger.yml` (blob `5c5af03075f87297a31f5ee26f0e42025f05977b`). Its guarded issue trigger now requires title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Owner validation and issue opened/reopened-only behavior remain; no push/PR shortcut was added.
- This execution changed command/workflow metadata and canonical docs only. No issue was opened/reopened, no App Build was run, no APK/source ZIP was published, and no Firmware, BIN, Firebase, OTA, flash or device operation occurred.
- The runner blocker remains unresolved: Builds #41–#45 failed pre-step with `runner_id=0`; root cause is unknown. Diagnose account Actions budget/permissions/security and runner dispatch before any justified retry. Build #40 passed its 80-test/analyze/compile/signing/certificate gates but failed a stale source-path assertion, which was corrected in prior workflow source; no complete post-fix run has reached the steps.

## HISTORICAL — Chat Stuck full repository-memory reconciliation (2026-10-15)

- Live App 'main' before this documentation-only reconciliation sequence: `41627c26189706bc9f4aabad15a83857cda55229`; root tree `a7a6ba4dc4bf5ea52f44c906a17ef480b370f70e`, 76 entries/55 blobs, recursive tree not truncated. Active workflow is `.github/workflows/jexfyz-app-build-trigger.yml` only; diagnostic workflow file was deleted from current main.
- Build #45 / run `38719397780`, job `116369943522`, failed pre-step with `runner_id=0`, blank runner/group names and no logs. Builds #41–#45 share this signature. Diagnostic probes #1 `38722954080` (Ubuntu 24.04) and #2 `38723038511` (Ubuntu 22.04) also failed pre-step; #46 and #47 App-trigger workflow runs were skipped by its owner/title/token guard. The hosted runner/account root cause is unknown; do not blindly retry or reference the deleted diagnostic workflow.
- Build #40 / `38713854518` passed the audit/license gates, dependency install, Dart analysis, all 80 Flutter tests, obfuscated APK compile, V1/V2/V3 signing and official certificate verification. It created a valid source ZIP, then failed a stale SPAKE2 source-path assertion. Current active workflow blob `225584c8feaf8e43ff7228fd6ab3dc84491e34ba` has the corrected path; no complete post-fix run reached workflow steps. No new APK or source ZIP has been published.
- Updated canonical status, README, handover, build notes, app notes and memory routing so #39/#40 test/build evidence no longer conflicts with old “NOT RUN” language; current app hashes were corrected. Archives and superseded version histories remain preserved as historical/forensic material.
- Active firmware stays `firmware/JEXFYZ-V6.6.ino`, `FW_VERSION = "V6.6"`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`; current App version/package `1.0.0+3` / `com.horizontalzzz.jexfyz`, keep `versionName "Telegram @horizontalzzz"`. Artifact repo remains BIN-only with `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes; source/BIN provenance remains unverified.
- No functional App/Firmware source was changed. No App Build/release workflow, Firmware compile, BIN generation/publication, Firebase, OTA, flash or device operation was performed.

## HISTORICAL / SUPERSEDED — 2026-10-15 — Hosted-runner diagnostic workflow introduced

- Live parent checkpoint: `main` `16369c8b1723732eb94c73689b4f9d1a85a20641`, root tree `ed1b3bdcdc1f2e1ea983ba6b256c0e2947126ff7` (76 entries / 55 blobs, recursive tree not truncated). Latest attempt #45 / run `38719397780` / job `116369943522` fails in about two seconds with `runner_id=0`, empty runner metadata and zero steps; no logs exist. Builds #41–#45 share the pattern.
- Compared with Build #40 / run `38713854518`, where runner `1000002340` executed through audit, 80 Flutter tests, APK assembly, signing and production certificate verification. #40 failed only at the source-archive path assertion; publication was skipped.
- At the time this entry was first written, `.github/workflows/hosted-runner-diagnostic.yml` (blob `8364d906b5c8570d7bda8c0ea3aef4a308931ff7`) had just been added as a manual-only smoke test with no checkout/secrets/build/release. Its later outcomes and deletion are recorded immediately below; this historical workflow is not part of current `main`.
- **Subsequent outcome — historical update:** diagnostic run #1 `38722954080` on Ubuntu 24.04 and run #2 `38723038511` on Ubuntu 22.04 both failed before the first step with `runner_id=0`/no logs. The diagnostic workflow file was later deleted from live `main` by commit `41627c26189706bc9f4aabad15a83857cda55229`; it is not available in the current tree. Root cause remains unconfirmed.
- Reconciled build report, state, handover, build notes, README, memory index and transfer snapshot. No App Build/diagnostic workflow was triggered; no APK/source ZIP was published; no Firmware/BIN/Firebase/OTA/flash/device action occurred.
- Evidence: [Build #45](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38719397780), [GitHub Status](https://www.githubstatus.com/), [Community #208438](https://github.com/orgs/community/discussions/208438), [Community #207926](https://github.com/orgs/community/discussions/207926). Exact repository/account root cause remains unconfirmed without a running job or GitHub-side diagnostic.

## HISTORICAL — 2026-10-15 — Build #40 source archive assertion failure and path repair prepared

- [Build #40 / run 38713854518](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38713854518) built source commit `d638f6941d9ac16a228f4b78ed001ca2e925f716`. Security/license audit, Flutter dependency installation, Dart analysis and **80 tests passed**; APK build, V1/V2/V3 signing and official certificate verification passed.
- Corresponding-source ZIP was created and its integrity check passed. Packaging failed only because a follow-up path grep expected the obsolete `android/src/main/java/io/github/muntashirakon/crypto/spake2/Spake2Context.java`; correct source-tag path is `src/main/java/com/flyfish233/crypto/spake2/Spake2Context.java`.
- Prepared workflow blob `225584c8feaf8e43ff7228fd6ab3dc84491e34ba` corrects the path check. Release publication and downloaded-asset verification were skipped; no new APK was published. Next action is commit the workflow correction and run the official build again.

## HISTORICAL — 2026-10-15 — Preserve Kadb; add corresponding-source and license checks to App Release (NOT YET BUILD-VERIFIED)

- The selected technical route retains the current Wireless ADB/FPS functionality rather than swapping in a newer, less-audited pairing implementation.
- Added the full upstream GPL-3.0 license text from SPAKE2-Java tag `1.0.5` as `third_party/spake2-java-1.0.5-GPL-3.0.txt` and packaged the same text under `android/app/src/main/assets/licenses/spake2-java-GPL-3.0.txt`. Added `third_party/THIRD_PARTY_NOTICES.md` listing Kadb 1.3.0 (Apache-2.0) and SPAKE2-Java 1.0.5 (GPL-3.0).
- The revised official workflow will audit those notices, build the obfuscated APK, create `JEXFYZ-corresponding-source.zip` with exact-commit app/build/test source plus upstream Kadb tag `1.3.0` and SPAKE2-Java tag `1.0.5` including its pinned native submodule, publish that archive beside the single APK, and verify both downloaded SHA-256 values.
- Workflow blob for the source/license steps: `187956b1344680eaf89f48fec28fd8a92e77f832`. This is NOT yet a passing build. The next action is an authorized Build App run, followed by evidence-based repair/retry until complete or a concrete external blocker is documented.
- The source bundle is attached to the same private Release; the repository remains private. This packaging is a technical source-availability safeguard, not a legal opinion. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## HISTORICAL — 2026-10-15 — Repair Build #39 Maven resolution configuration (build still unverified)

- Live main before this update: `a70d1ea3ec29e0656b8e0c071cb1e8a3c14626b5`; root tree `a2750f5956fb709d9a19a612e4db243d430a8a47` (71 entries / 52 blobs; recursive tree not truncated).
- Build #39 / run `38705765370` failed at `:app:mergeReleaseNativeLibs` after security/architecture audit, Flutter dependency installation, Dart analysis and all 80 Flutter tests passed. Gradle could not find `com.github.Flyfish233:spake2-java:1.0.5`; APK/signing/release steps did not run.
- Updated `android/build.gradle` to add `https://jitpack.io`, narrowly filtered to `com.github.Flyfish233:spake2-java`; blob SHA `bb8c0caf26927bd614bb9b05ef79366424063663`. This directly addresses the missing repository configuration but has not yet been run through Gradle, so success is NOT claimed.
- The transitive SPAKE2 artifact is GPL-3.0 while Kadb itself is Apache-2.0. The next source change chooses to retain Kadb and extend the private Release with the exact corresponding-source ZIP and GPL license text; this packaging/distribution route itself must still pass the official workflow. No APK from #39 was published.
- Updated current-state build notes, handover, index and transfer snapshot to preserve the exact run evidence and licensing gate. No Firmware, BIN, Firebase, OTA, flash, or physical device operation occurred.

## HISTORICAL — 2026-10-15 — Redesign animated Home status indicators and Notify connection labels

- Reworked the seven dashboard indicators with custom-painted, simplified geometry: segmented Battery Temperature, isolated Hotside thermometer, moving voltage charge sweep, Adaptive ring/orbit/core, reduced six-arm Peltier crystal, rotor blades with natural coast-down, and smooth telemetry-driven Fan Speed gauge.
- Removed the decorative heat waves running alongside/across the Hotside tube; liquid level now follows the Hotside reading. Battery and Hotside icon levels are mapped from valid Celsius text and eased over 520 ms rather than snapping on each telemetry refresh.
- Adaptive icon motion now follows the actual Adaptive ON state. Fan speed and voltage-dependent rotor timing remain intact.
- Home Notify connection badge now reads CONNECTED/DISCONNECTED (same exact labels in both app languages). Existing explicit error, connecting/syncing badges and detailed Notify body remain unchanged.
- Added widget tests for sensor-level parsing/clamping and both-language Notify badge labels, including the normal `Bluetooth Disconnected` notice staying DISCONNECTED rather than ERROR. Corrected the Celsius regex to parse digits/decimals in a raw Dart regular expression. Tests/analyze and APK build remain NOT RUN pending the separate @Thinking #Build App! authorization. No Firmware/BIN/Firebase/OTA/device operation was performed.

## HISTORICAL — 2026-10-15 — Chat Stuck recovery and QC-state reconciliation

- Recovered the already-authorized Home indicator/Notify execution from live `main`; no source re-implementation or new build was needed for this recovery.
- Reconciled stale current App/widget-test fingerprints and the old Build #35 release checksum in `PROJECT_STATE.md` / `APP_NOTES.md`. The verified latest successful build is still #36 on its older source commit; current Home UI and Wireless ADB source are not present in that APK.
- Static repository readback confirmed the Celsius regex, isolated Hotside thermometer (no heat-wave overlap), CONNECTED/DISCONNECTED labels in both language settings, and regression assertions including normal `Bluetooth Disconnected` handling.
- Flutter/Dart/Gradle executables are unavailable in the current execution environment. Flutter tests, Dart analysis, Android/Kotlin compile, APK build and physical-device verification remain NOT RUN / UNVERIFIED. No Build App workflow, Firmware, BIN, Firebase, OTA, flash or physical device operation occurred.

## HISTORICAL — 2026-10-15 — Recover and harden notification-driven Wireless ADB pairing

- Recovered the authorized App execution from live main rather than duplicating the existing feature commit. Existing source commit 4ad5d99bcea96e865978e3003482661b1e26101f introduced the native notification flow, and 89855b59c8d6ee40151847e6633a07cb75aff6b0 repaired the mDNS-listener closure and identity temporary-file naming.
- Hardened local mDNS discovery: declare ACCESS_NETWORK_STATE, ACCESS_WIFI_STATE and CHANGE_WIFI_MULTICAST_STATE; acquire a short-lived WifiManager.MulticastLock only while discovery is active; release it on stop/failure/destroy. Fixed the permission confirmation loop to stop once Android confirms android.permission.DUMP.
- When Android 13+ notification permission is missing, the Activity now requests it and requires the user to retry before starting the pairing notification. Pairing remains user-started; the native service only accepts a fresh six-digit code through RemoteInput, uses local loopback ADB, runs one fixed pm grant com.horizontalzzz.jexfyz android.permission.DUMP, and independently verifies permission state.
- Enhanced test/adb_pairing_contract_test.dart with assertions for discovery permissions, multicast-lock lifecycle and notification-permission request. Static authoring checks passed in this recovery run; Flutter/Dart tests, Dart analysis and Android/Kotlin compilation were NOT RUN.
- Updated current App notes, state, handover and index; CHAT_TRANSFER.md is updated separately after the resulting parent commit is verified last. Build #36 (run 38689044316, source 893393388b99fc6d9e59c420070a159a29e45e9) remains the latest successful APK, but it predates all Wireless ADB pairing changes. The pairing feature remains NOT BUILT and device behavior UNVERIFIED.
- No App Build workflow, Release update, Firmware source/BIN, Firebase, OTA, physical flash/device operation or hardware was touched.

## HISTORICAL — 2026-10-15 — Chat Stuck recovery and transfer checkpoint reconciliation

- Resumed the authorized chat-limit reconciliation from live `main` after inspecting the prior recovery checkpoint; stopped repetitive fingerprint-only updates and used an evidence-first, grouped documentation update.
- Rechecked the full recursive App repository tree: 66 entries, 48 tracked files, including 20 Markdown files and four Dart tests; tree response was not truncated. Active Firmware inventory remains exactly `firmware/JEXFYZ-V6.6.ino` with `FW_VERSION = "V6.6"`. The artifact repository contains only `JEXFYZ.cpp.bin`.
- Reconfirmed five App branches and zero open pull requests at the checkpoint. The only authorized workflow remains the manual issue-triggered App workflow; no App Build or Firmware/device operation was triggered.
- Corrected a stale Floating Monitor hash in `PROJECT_STATE.md`, expanded `MEMORY_INDEX.md` routing for the ADB/SurfaceFlinger FPS and telemetry work, and fixed duplicate list numbering in Prompt C. `CHAT_TRANSFER.md` is refreshed separately and last after the resulting parent commit and document fingerprints are verified.
- Current Color Picker and Floating Monitor/ADB FPS code remains SOURCE IMPLEMENTED / NOT RUN / NOT BUILT. Flutter/Dart analysis/tests and Android/Kotlin build were not run in this environment; device-side permission granting and dynamic foreground game FPS remain UNVERIFIED. Build #35 remains valid only for its older source commit.
- No Firmware source, BIN, Firebase metadata, protected OTA code, build workflow, release, physical device or hardware was changed or operated.
## HISTORICAL — 2026-10-15 — Floating Monitor foreground FPS, telemetry recovery and Chat Stuck

- Removed the live preview pill from the center of Floating Monitor settings. Orientation is now selected explicitly using Horizontal / Vertical controls.
- Removed Flutter app-window frame counting as the FPS source. The native overlay now uses SurfaceFlinger `--timestats` frame-count deltas, resolved to Android's resumed/focused foreground package and matching layer names; it does not substitute the phone's refresh-rate setting or a busy background app's layer. Sample values are updated about once per second while the overlay is attached and FPS metric F is selected.
- Added a user-controlled ADB setup/check flow for Android development-only `android.permission.DUMP`, with fixed grant/revoke commands, Developer Options shortcut and localized status text. Android documents DUMP as a powerful development permission not intended for third-party apps; JE Cooler must disclose this, never grant it to itself, execute only fixed Activity/SurfaceFlinger dumps, and show unavailable status when OEM/API output is blocked. No Shizuku integration is included in this revision.
- Corrected the likely overlay-start data race: if live telemetry was published before the native overlay service existed, the bridge dropped that update. The latest authoritative telemetry snapshot is now resent after the service starts/restores, and native HUD requests layout as well as redraw when values change. Native status values remain unknown (`--`) when BLE is disconnected; OFF is shown only with a valid connected snapshot.
- Added source-contract regression assertions for preview removal/orientation selection, ADB bridge and grant/revoke commands, focused-package FPS filtering, no Flutter frame counter, telemetry replay, and disconnected status. Dart/Flutter tests and analysis were NOT RUN because those SDKs are unavailable in this execution environment; the changes are NOT BUILT, physical ADB permission/FPS behavior is UNVERIFIED, and no App Build was triggered.
- Added `@Thinking Chat Stuck!` as a standalone recovery command: stop blind retries, inspect live logs/repository/workflow/checkpoint, continue only the most recent valid authorization, avoid duplicate commits/builds, and report `RECOVERED`, `BLOCKED` or `FAILED`. It never implies Build App or Firmware/device authorization.
- Updated `lib/floating_monitor.dart`, `lib/app_settings.dart`, `lib/main.dart`, `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`, `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`, `android/app/src/main/AndroidManifest.xml`, `test/widget_test.dart`, and canonical notes/rules. Firmware V6.6, firmware BIN, Firebase, workflow trigger and physical device were not changed or operated.

## HISTORICAL — 2026-10-15 — Color Picker staged selection and explicit dismissal

- Changed `_JexColorPickerCard` to retain a local draft. Tapping any of the 36 palette swatches now updates only the checkmark/preview/name; it does not send BLE `COLOR` or close the modal.
- Added localized top-right Select (`Select` / `Pilih`) and retained localized top-left Cancel (`Cancel` / `Batal`). Select applies the selected draft through the existing confirmed COLOR command and closes only when confirmed; selecting the already-active color closes without sending a redundant command. Failed/unconfirmed changes leave the modal open and the previous applied RGB state unchanged. Cancel discards the draft.
- Set `barrierDismissible: false` and wrapped the modal content in `PopScope<void>(canPop: false)` so outside taps and system Back do not close it; Cancel/Select pop programmatically. Kept the six-column 36-color palette, bottom anchor, no-HEX names, swatch sizing and animation style.
- Added Widget test source-contract assertions for staged selection, Select callback, localized label and blocked dismissal. **Tests/Dart analysis were NOT RUN**: the available execution environment has no Flutter or Dart SDK. No App Build/APK was triggered; physical UI behavior remains unverified. Next authorized build command is `@Thinking #Build App!`.
- Files: `lib/main.dart`, `lib/app_settings.dart`, `test/widget_test.dart`, `APP_NOTES.md`, `PROJECT_STATE.md`, `HANDOVER.md`, `MEMORY_INDEX.md` and `CHAT_TRANSFER.md`. Firmware/workflow/Firebase/BIN/OTA/device state unchanged.

## HISTORICAL — 2026-10-15 — One-shot Build App chat-limit handoff

- Clarified that a Build App chat reaching the context limit uses Prompt D from `CHAT_TRANSFER_PROMPTS.md` exactly once as the first message in the replacement Build App chat. The prompt loads live repository/build evidence and continues the existing work; there is no separate recap chat or recap prompt. Prompt A remains for broad project-memory reconciliation and is not the Build App handoff.
- Aligned `CHAT_RULES.md`, `BUILD_NOTES.md`, `APP_BUILD_REPORT.md`, `HANDOVER.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `README.md` and the refreshed `CHAT_TRANSFER.md` with this single-load handoff model. Documentation-only; no App/Firmware source or workflow changed, and no App Build was run.

## HISTORICAL — 2026-10-15 — Thinking protocol replacement and App Build report

- Replaced the permanent command model: `#Diskusi!` is full read-only analysis; `#Tanya Gemini!` and `#Jawaban Gemini!` are valid only when paired with `#Diskusi!` in the same command; `#Eksekusi Full!` is the sole full-execution command; `#Build App!` owns end-to-end App Build, App-scope repairs/retries, release-artifact verification and durable reporting.
- Retired standalone `#Eksekusi!` and combined `#Eksekusi & Build App!`. A missing-parent Gemini command must be rejected without answering its substantive content.
- Added `APP_BUILD_REPORT.md` as the shared build evidence ledger for source commit, trigger/run IDs, failure analysis/fixes, test/analyze results, APK identity/checksum/signing, warnings, blockers and device-side unknowns.
- Updated `CHAT_RULES.md`, `BUILD_NOTES.md`, `HANDOVER.md`, `README.md`, `PROJECT_STATE.md`, `MEMORY_INDEX.md` and `CHAT_TRANSFER_PROMPTS.md`. This documentation-only change does not start App Build or modify app/Firmware source, the build workflow, BIN, Firebase, OTA or hardware.
- Previous App Build #35 / run `38669526891` remains the last known successful run in these records until a new live run is explicitly triggered and verified. Physical-device rendering and MT Manager verification remain separate open gates.


## HISTORICAL — 2026-10-15 — Chat-limit reconciliation after Build #35

- Reconciled the current App/UI checkpoint against live `main`, recursive tree, source/tests, active build workflow, Actions run, Release asset, branch/open-PR state and artifact-repository root. Build #35 targets code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`; this documentation reconciliation does not change that code or run another build.
- Corrected stale “tests not run/latest build #33” statements in README, Memory Index, App Reference and Handover. Removed the duplicate current-state section from Handover, corrected the easing reference, clarified Build #34's failed midpoint assertion versus the symmetric cubic fix, and separated CI validation from device validation.
- Updated Firmware technical/OTA/voltage references so the Build #35 Flutter/source-contract run is acknowledged without implying Firmware compilation or physical OTA verification.
- Build #35 evidence: Dart analyze and all 74 Flutter tests passed; one `JEXFYZ-release.apk` (54,521,947 bytes) was built, V1/V2/V3 verified, published and re-downloaded; SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. JAR/V1 META-INF warnings remain documented.
- Firmware V6.6 source/BIN, workflow, Firebase metadata, physical hardware and OTA were not changed or operated. The user's V6.6 compile/two Online OTA successes remain user-reported; source-to-BIN provenance and device-side rendering/MT Manager verification remain unverified.




## HISTORICAL — 2026-10-15 — Fan Speed midpoint correction and App Build #35

- Build #34 correctly stopped before APK compilation: 73 Flutter tests passed and one failed in `Fan Speed level retargeting eases between values without abrupt jumps`. The test expected the easing curve to return exactly 0.5 at progress 0.5, while `Curves.easeInOutCubic` returned 0.510125.
- Corrected `jexSmoothFanSpeedLevel` in `lib/main.dart` to use symmetric cubic smoothstep `t * t * (3.0 - 2.0 * t)`, preserving eased motion with zero velocity at the endpoints and an exact midpoint. This fixes the intended UI interpolation contract rather than weakening the test.
- App Build #35 passed on code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`: security/architecture audit, dependency installation, Dart analyze, all 74 Flutter tests, APK compilation, V1/V2/V3 verification, release publication and re-downloaded asset verification.
- Published one `JEXFYZ-release.apk` at `jexfyz-latest` (54,521,947 bytes), SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. Production certificate SHA-256 matched `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 verified true for both built APK and downloaded release asset.
- JAR/V1 verification still reports dependency `META-INF` entries not protected by the JAR signature, including `META-INF/services/a1` and `META-INF/services/b1`. Record this as a warning; it does not negate the separate successful V2/V3 results.
- This was App-only work. No Firmware compile, BIN change/publication, Firebase edit, OTA/flash or physical hardware validation occurred; device-side animation and MT Manager inspection remain open.

## HISTORICAL / SUPERSEDED — 2026-10-15 — Smooth Fan Speed retargeting and seamless indicator loops

- Added `jexSmoothFanSpeedLevel`, with a dedicated retargetable `AnimationController` for the Fan Speed gauge. Each new active speed target interpolates from the currently displayed value over 420 ms; another target arriving mid-transition starts from the current interpolated position rather than jumping back. Fan OFF smoothly retargets the gauge to zero over 520 ms; the telemetry percentage remains authoritative.
- Replaced the Fan Speed needle's non-integer wobble harmonic with integer harmonics so both position and slope match across the loop's 0/1 boundary.
- Changed the voltage-bolt highlight from a one-way linear sweep with a snap-back to a sinusoidal back-and-forth movement.
- Changed Bluetooth connection ripple opacity to a squared-sine envelope, transparent with zero slope at cycle edges, avoiding a visible ring flash when the radius wraps.
- Added regression contracts for interpolation endpoints/easing, wobble boundary continuity, and voltage/Bluetooth loop effects. Static source/readback checks passed; Flutter tests/analyze and device rendering have not run for these edits.
- No App Build, Firmware compile, BIN/Firebase update, OTA/flash, or release operation was performed for this animation task.



## HISTORICAL / SUPERSEDED — 2026-10-15 — Smooth status animation loops and retargetable Fan Speed gauge

- Added a dedicated Fan Speed value-transition controller, separate from the cyclic wobble controller. Each active speed change retargets from the currently rendered gauge level to the latest target over 420 ms; if another target arrives mid-transition, it continues from the current interpolation. OFF animates to 0 over 520 ms and later OFF telemetry changes no longer restart that transition.
- Replaced the non-integer needle wobble harmonic with integer harmonics so position and slope repeat cleanly at the animation loop boundary.
- Changed voltage-bolt sheen from a one-way linear sweep that snapped at the repeat boundary to a sinusoidal back-and-forth sweep.
- Changed Bluetooth ripple opacity to a squared-sine envelope that reaches transparency with zero slope at both ends of each loop, avoiding a flash on ring reset.
- Added deterministic regression tests for eased interpolation endpoints/midpoints, loop-seamless needle wobble, the voltage sheen, and Bluetooth ripple envelope. Updated the prior Speed source-contract test.
- Static source/readback checks passed. Flutter tests/analyze and device rendering were NOT run after these edits; no APK contains this source yet. No Build App, Firmware compile, BIN, Firebase, OTA, flash, or hardware action occurred.



## HISTORICAL / SUPERSEDED — 2026-10-14 — Fan coast-down, static Peltier crystal, natural Fan Speed gauge

- Fan now eases through a short period-dependent coast-down when turned OFF, then holds its final rotor pose. Blade and hub colours are unchanged by OFF; the animation stops without dimming the icon.
- Removed the square Peltier module frame, center box and corner bolts. The six-branched frost crystal and particles remain visible at full icon colour while OFF; its animation is frozen rather than faded out. Voltage-class intensity/particle interpolation remains active only as applicable while Peltier is ON.
- Fan Speed keeps the reported percentage stable while ON and adds a subtle two-frequency needle wobble. On OFF, the pointer smoothly returns to zero over 520 ms, then rests without wobble; gauge, pointer and hub stay fully coloured.
- Updated `test/widget_test.dart` source-contracts for phase-preserving Fan changes/coast-down, no-box/no-fade Peltier artwork, full-colour Fan blade/hub and Speed needle wobble/stop. Static source consistency checks passed; Flutter tests/analyze and device rendering were NOT run after these edits.
- App-only presentation change. No Firmware source, BLE protocol, safety logic, BIN/Firebase, App Build, OTA, flash or release operation changed.



## HISTORICAL / SUPERSEDED — 2026-10-14 — APK signature verification hardening / Firmware V6.6 user acceptance

- Investigated the user's MT Manager screenshot showing `Signature: Verified failed`. The latest successful App Build before this fix was run `38556896542` on commit `67c5d26723c433b4af856c7759a967a3425bf67a`; its log reported V1=false, V2=true and V3=true while the workflow accepted the build because it relied on `jarsigner`'s `jar verified.` text and did not require `apksigner` V1=true.
- Hardened `.github/workflows/jexfyz-app-build-trigger.yml` to sign with `--min-sdk-version 23`, run `apksigner verify --min-sdk-version 23`, and fail unless V1/V2/V3 all verify on both the built APK and the re-downloaded release asset. Android manifest minSdk remains 24. The workflow change was subsequently exercised in Actions run `38560939271` on commit `2aa77113950ac462bd27fa6f1ca416371eaa7ad8`: V1/V2/V3 all verified true on the produced APK and re-downloaded release asset. The run passed tests/analyze for that earlier source, not the current Fan/Peltier/Speed edits. Its log warns `META-INF/services/b1` is not protected by JAR/V1. No device-side recheck of MT Manager's label has yet confirmed the cause.
- The screenshot's installed-app metadata says last update 17:11 Asia/Jakarta, earlier than the latest successful run completing at 18:36, so the shown installed copy predates that release. The precise reason MT Manager shows failure remains unverified until a new APK is built, installed and checked.
- User confirms Firmware V6.6 is final/correct and reports successful compilation plus two successful Online OTA flashes/updates on the same V6.6 version. Do not change/recompile/reflash Firmware unless the user explicitly reopens the task and separately authorizes the operation. Source-to-BIN provenance remains a separate unverified fact, not a reason to initiate another Firmware operation.
- No App Build, Firmware compile, BIN update, Firebase change, physical OTA/flash or release operation was performed in this execution.


## HISTORICAL / SUPERSEDED — 2026-10-14 — Chat-limit reconciliation after App UI execution

- Re-read the prior transfer snapshot and canonical App/Firmware/OTA/build/design memories; refreshed current source/test hashes, current App build boundary, repository branch/PR and BIN-only artifact evidence in the transfer snapshot.
- Corrected stale active-App and build wording in current status/handover, refreshed memory routing, removed the duplicate newest UI entry, and explicitly marked older logo/large-icon descriptions as superseded by the transparent JE notification monogram.
- Current source remains App-only UI work: phase-continuous Fan motion, geometric Peltier crystal with 360 ms ON fade / 420 ms voltage interpolation / 520 ms OFF fade, larger dialogs, and JE notification small icon. Firmware stays V6.6.
- Flutter/Dart SDK is unavailable in this execution environment, so current-source Flutter tests/analyze were NOT run. Latest verified successful App Build is run `38545637192` on older source commit `9e790765f6683d342025317ce6594cc8519026de`; it does not contain the current changes.
- No App Build, Firmware compile, BIN replacement/publication, Firebase update, OTA, flash/device operation or release was performed.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Smooth motion, crystal Peltier, JE notification and dialog sizing

- Fan voltage changes now update rotation duration without resetting angular phase; the controller travels smoothly to an equivalent full-turn boundary before continuing at the new speed, and Fan OFF coasts forward to a retained pose. Peltier frost intensity/particle count interpolate over 420 ms across voltage classes, fade in over 360 ms on ON and out over 520 ms on OFF; crystal branches, particles and center fade fully, periodic drift avoids loop-boundary jumps, while the thermoelectric frame remains visible.
- Replaced the flower-like Peltier icon with a framed thermoelectric module and six-branched geometric frost crystal. The Color Picker remains bottom-pinned with localized top-left Cancel that dismisses without sending RGB; all 36 curated presets and the existing color command path are retained.
- Increased Color Picker title/selected-color/Cancel text and swatch height; increased Peltier Safety title/body/action typography, spacing and minimum touch targets. Palette colors and mandatory Fan-before-Peltier safety gate are unchanged.
- Android notifications now use a bold white `JE` vector monogram with transparent background as the sole small icon; no large icon is set, and the full-color app icon remains unchanged.
- Added widget contracts for phase continuity/coast-down, Peltier crystal geometry/interpolation, dialog sizing, and JE icon path. Static readback checks passed. Flutter tests/analyze and App Build were NOT run for these current commits (Flutter/Dart SDK unavailable); device rendering is unverified. No Firmware, BIN, Firebase, OTA, flash or release operation occurred.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Voltage-aware Fan/Peltier icons and bottom-pinned Color Picker

- Fan dashboard motion now uses distinct continuous rotation durations from authoritative BLE-reported voltage: 5V slow (2600 ms), 9V medium (1250 ms), and 12V fast (620 ms). Peltier frost icon increases glow and crystal density across the same voltage classes and fades its frost overlay over 520 ms when switched OFF. These are illustrative visuals, not RPM or temperature/ice measurements; no firmware, BLE command, safety or physical LED behavior changed.
- Pinned the LED Color Picker to the bottom safe area and removed the outer scroll view/top-offset positioning, preventing the panel from being dragged vertically. Added localized Cancel at the top-left; Cancel closes without sending a new colour, while swatch selection preserves the prior RGB command path.
- Added widget contracts for voltage mapping, comparative fan timing, frost density/intensity, bottom anchoring and Cancel dismissal.
- Static source transformation and live file readback checks passed. Flutter test/analyze and an APK build were NOT run; device rendering and physical appearance remain unverified. Firmware V6.6 was untouched by this App-only execution; the user's earlier compile/Online OTA report was not independently re-verified here.

## 2026-10-14 — HISTORICAL / SUPERSEDED: notification logo, LED contrast, anchored menus and status-icon motion

- Switched notification small-icon branding to the existing transparent JE X FYZ logo PNG (`R.drawable.jexfyzicon`) so Android uses the actual logo alpha shape, and removed `setLargeIcon`; only one logo appears at the left. The legacy X vector remains unused; title/body, tap intent and service messages remain unchanged.
- Updated LED preview so Static/Rainbow remain fully vivid independently of hardware Brightness, while truly inactive Comet/Dual Chase pixels use a pale neutral baseline. Animation phase and physical firmware commands are unchanged.
- Kept Color Picker and Peltier Safety as separate dismissible menus but anchored each below the dashboard/display-tab region. Localized Cancel / Turn On Fan and the mandatory Fan-before-Peltier safety gate remain.
- Replaced the dashboard indicator painter with per-kind filled forms, soft layered glows, smooth orbit/rotor motion and slower distinct cycles for Battery, Hotside, Voltage, Adaptive, Peltier, Fan and Fan Speed. This is App-only presentation.
- Added/updated widget contracts for preview colour behaviour, menu anchoring, indicator timing and single-logo notifications.
- Static source transformation checks passed. Flutter test/analyze and APK build were not run (Flutter/Dart SDK unavailable here); Android OEM rendering, current-source installation and physical UI appearance remain unverified. No firmware/BIN/Firebase/OTA/device/release operation occurred.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Chat-limit reconciliation and test-contract cleanup

- Audited the latest non-truncated main tree and canonical notes; preserved the current source-only V6.6/NOT RELEASED boundary and the artifact repository BIN-only rule.
- Corrected the stale widget-test palette expectation from 24 colors/old first color to 36 curated presets/current first color `#FF1744`, and removed the accidentally duplicated native notification source-contract test.
- Corrected stale Build Notes: the latest observed successful App Build run is `38520146994` on `1024eb8e145429913aacb52f4cf352e087885d44`; it predates the LED UI/notification source changes and does not validate current source. Failures `38519913851` and `38519669369` also predate that work.
- Reconciled current test SHA references in App/voltage/OTA memory and normalized the handover QC numbering. Current test files exist but tests/analyze were NOT RUN for this reconciliation.
- No functional Firmware source change/version bump, App Build, Firmware compile, BIN, Firebase, OTA/flash/device operation or release was performed.
- This entry records a documentation/test-contract correction, not a test pass.

## 2026-10-14 — HISTORICAL / SUPERSEDED: LED preview/picker, disconnected menu fallback and Android notifications

- Compactened the LED preview row, removed the numeric mode index, narrowed its center card, and darkened left/right LED column backgrounds for contrast.
- Decoupled LED preview core opacity/glow from the hardware Brightness setting so colors stay visible at low hardware brightness; Firmware brightness/protocol behavior is unchanged.
- Replaced the code-only palette with 36 curated hue-ordered colors, localized names, and a centered responsive dialog. HEX values remain internal to the RGB command and are not displayed. Common colors stored by prior palette versions retain localized aliases; legacy Cyan #00FFFF and classic Red are still selectable without adding dark/light brightness variants.
- CONTROL/ADAPTIVE/LED menu switch rows show an OFF-looking disabled fallback with the toggle at left while BLE is disconnected. Home/dashboard and Floating Monitor remain unknown (`--`) when physical telemetry is unavailable.
- Added monochrome Android notification icon plus the full-color branded large icon, fixed BLE event title/body order, added app-open tap intents and meaningful localized foreground service bodies, and requests Android 13+ notification permission at the first actual notification attempt.
- Updated UI/source-contract tests and canonical memory. Tests/analyze are NOT RUN; Android OEM notification rendering, narrow-screen layout and hardware LED appearance remain UNVERIFIED.
- No Firmware source/protocol, BIN, Firebase, OTA, flashing, release, App Build or Firmware compile operation was performed.

## HISTORICAL / SUPERSEDED — 2026-10-14 — V6.6 LED mode removal, brightness preview and phase synchronization

- Bumped active Firmware source to `firmware/JEXFYZ-V6.6.ino`, `FW_VERSION = "V6.6"`; exactly one active versioned `.ino` remains.
- Retired Mirror Pulse ID 3 in Firmware and App without renumbering supported protocol IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. Persisted ID 3/invalid values migrate to Static; new MODE:3 commands are rejected.
- Replaced separate queued `LED_PHASE` and `LED_CYCLE_MS` updates with a single `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple. The marker is resolved at the BLE notify boundary, so phase does not become stale while waiting in the queue. BLE UUID/P1 transport is unchanged.
- App parses the tuple atomically and interpolates on a monotonic clock. New snapshots correct drift without restarting the animation controller on every phase update; separate legacy phase/cycle parsing remains for older firmware.
- Reworked LED UI into one row: left arrow, four left pixels, centered mode number/name, four right pixels, right arrow; removed the old MODE header and duplicate caption. Unsupported ID 3 from older firmware is labelled Unsupported until the user selects a supported mode.
- Fixed low-brightness preview by preserving RGB chroma and applying brightness through pixel alpha/glow rather than scaling all RGB channels toward black. Firmware brightness commands/hardware rendering are unchanged.
- Added App tests for supported IDs, atomic snapshot parsing and low-brightness chroma; added firmware contract tests for retirement/migration of ID 3 and snapshot creation at notification time. Tests/analyze have NOT been run; static inspection is not runtime verification.
- Firmware compile, BIN generation/provenance, physical LED verification, App Build/APK, Firebase, OTA, flash and release were NOT performed. V6.6 remains source-only DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED.

## HISTORICAL / SUPERSEDED — 2026-10-14 — V6.5 Adaptive Peltier transition continuity

- Bumped the active Firmware source to `firmware/JEXFYZ-V6.5.ino` and `FW_VERSION = "V6.5"`; retained exactly one active versioned `.ino`.
- Adaptive ON/OFF still returns the selector to safe 5 V but no longer toggles the logical Peltier state OFF solely for that handoff. Both paths use the existing output reconciliation and voltage-transition pause helper.
- An active five-second soft-start is paused by `requestVoltage()`, then restarted after selector deadtime and the existing one-second settle. The settle timestamp is set before Adaptive activation reconciles output state, so an old timestamp cannot shorten the wait. If the ramp has completed, PWM remains at 100%. A Peltier already OFF stays OFF.
- Explicit user Peltier-OFF cancels deferred Adaptive-stop restoration; Hotside/NTC safety and OTA safe-output also remain higher priority. The change does not weaken thermal/OTA protections.
- Renamed the active static contract to `test/v6_5_qc_contract_test.dart` and added a regression assertion that Adaptive ON/OFF handoff code does not introduce its own `peltierOn = false` cycle.
- Static source/diff inspection only. Flutter tests/analyze, ArduinoDroid compile, BIN provenance, physical hardware tests, OTA, App Build and release were NOT run; V6.5 remains source-only and NOT RELEASED.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Memory-system cleanup / V6.4 checkpoint

- Reconciled current source version to `firmware/JEXFYZ-V6.4.ino`, `FW_VERSION = "V6.4"`; one active versioned source file.
- Replaced stale, duplicated “current status” blocks in the current-state, handover, App, Firmware, build and rules documents with canonical focused references.
- Added `MEMORY_INDEX.md`, `CHAT_TRANSFER_PROMPTS.md`, and `DESIGN_NOTES.md`; established `README.md` as the project index and transfer prompts as a separate file.
- Consolidated V6.4 Peltier transition logic into `VOLTAGE_TRANSITION_MEMORY.md`; preserved Online OTA incident and evidence boundary in `OTA_REGRESSION_MEMORY.md`.
- Set documented repo boundary: all code source and memory under `TenzoNkz/JEXFYZ-App`; `TenzoNkz/JEXFYZ-Firmware` is intended to contain only `JEXFYZ.cpp.bin`.
- Added verbatim archives of the legacy state/reference docs and transfer/rules/history snapshots before replacing them, plus an archive of the removed artifact-repository notes. Archives are for recovery only; old CURRENT/version statements inside them are stale.
- Renamed the old `test/v5_9_contract_test.dart` to `test/app_protocol_notify_contract_test.dart` to reflect what it tests; test content is unchanged and has not been executed here.
- Enforced the user-requested artifact repository split: removed README and duplicated note files from `TenzoNkz/JEXFYZ-Firmware`; verified the BIN itself was not modified.
- Expanded transfer prompt templates with a mandatory memory-category checklist and an archive-recovery policy.
- Documentation/test-path cleanup only; no functional App/Firmware behavior was intentionally changed, no tests were run, and no Build App, Firmware compile, BIN replacement, Firebase, device or release operation was performed.
- Full chat-limit memory reconciliation refreshed the canonical memory map and handover/prompts, and made two durable requirements explicit in `APP_NOTES.md`: do not display a standalone Battery Protection Guard; preserve the 1 Hz Android Battery heartbeat/5-second Firmware freshness TTL. The one-App/one-cooler pairing-lock intent is preserved as a user requirement while exclusive enforcement remains unverified.
- Rechecked current Local OTA boot SoftAP/radio lifecycle from active source: 10-second no-client timeout, 60-second hard cap after interaction, and 160 ms Wi-Fi-off settle before BLE starts. Documented in Firmware technical/OTA references without changing protected code.
- Transfer prompt now requires full-tree audit, local-link/path/hash checks, source-versus-test-versus-runtime evidence separation, archive handling, and replacement of `CHAT_TRANSFER.md` last. No functional source changed and no tests/build/compile/BIN/OTA/Firebase/flash/release operation was performed.
- Preserved two separate user-reported restart incidents in current memory: (1) Manual 5 V→12 V during active Peltier soft-start and (2) enabling Adaptive from 12 V with Peltier/Fan ON. Reset reason is unknown in both reports; brownout remains a hypothesis, and they must not be conflated.
- Preserved the prior user request for rapid Hotside-rise shutdown/manual re-arm as NOT IMPLEMENTED in V6.4, and the historical report that the Adaptive-OFF white three-blink indicator was missing immediately after restart. Transition/boot LED code and physical status still require direct verification; no source behavior was changed in this docs task.

## HISTORICAL / SUPERSEDED — 2026-10-13 — V6.4 voltage-transition source contract

- A voltage transition pauses GPIO5 Peltier PWM at 0% only if the existing 5-second soft-start is active when a normal Manual Volt/Adaptive transition is accepted.
- Interrupted soft-start stays paused through selector handoff and the existing 1-second settle, then starts a fresh full 5-second ramp.
- Completed soft-start stays at 100% continuously through selector transition; no forced 0%, needless re-ramp or Peltier auto-enable when OFF.
- Preserve selector break-before-make of 200 ms; Fan stays ON/100% during the handoff; explicit OFF, Hotside/NTC safety and OTA safe-output cancel pending resume.
- Reason: user reported a hardware restart during 5 V→12 V with Peltier/Fan ON during active ramp. Supply transient/brownout remains unconfirmed. Reset diagnostics must be captured if reproduced.
- Test contract: `test/v6_4_qc_contract_test.dart`. Test is present but unrun. V6.4 compile and physical checks remain pending.

## HISTORICAL / SUPERSEDED — 2026-10-13 — V6.3-origin Online OTA connection restoration

- User-reported failure: Wi-Fi showed connection/blue feedback, then failure/red feedback at the GitHub connection stage after adding an embedded ISRG Root X1 CA validation path and OTA-only NTP/time-sync gate.
- Restored `cloudClient.setInsecure()`; removed embedded CA, `setCACert()`, `configTime()`, `TIME_SYNCING`, epoch-validity and the 20-second NTP gate. On Wi-Fi connection, blue feedback proceeds to the GitHub GET attempt.
- Kept the raw GitHub BIN URL allowlist, redirect blocking, HTTP/length/size/image checks, safe outputs, streaming update lifecycle and failure recovery.
- User reported this V6.3 revision compiled and GitHub connection succeeded. The CA and NTP changes were removed together; evidence does not isolate which alone caused the prior failure. This is not evidence that the later V6.4 source compiled or that full BIN apply/reboot succeeded.
- Known trade-off: `setInsecure()` bypasses server certificate identity validation. Do not silently change this baseline; require explicit discussion and one-variable-at-a-time evidence.

## HISTORICAL / SUPERSEDED — 2026-10-13 — App BLE rediscovery and OTA ACK handling

- BLE rediscovery avoids starting if Auto Connect is disabled or paired cooler identity is unknown; cancels polling if Bluetooth/permission/location prerequisites fail; suppresses scanning while syncing.
- `CLOUDOTA` ACK `TIMEOUT`/`DISCONNECTED` is treated as ambiguous rather than rejection; preserve OTA recovery state until reconnect/result. Definite rejection only rolls back while the BLE session remains connected.
- Static test contracts updated; the test run itself remains unverified.

## HISTORICAL / SUPERSEDED — 2026-10-13 — Touch Adaptive-OFF telemetry and safety latch

- Touch long-press Adaptive-OFF must publish authoritative Adaptive state/ceiling, Fan, Peltier and Fan-speed telemetry before the Touch ACK so App/Floating Monitor doesn't retain stale state.
- Manual Peltier safety latch cannot be bypassed by a single low Hotside sample; require Hotside at/below `hotLimit - 1°C` for 5 continuous seconds.
- Tests/source assertions were added, but test execution was not implied.

## 2026-10-13 — V6.2 thermal safety history (superseded source)

- Adaptive thermal safety used a 30-second stage at 12 V, 9 V and 5 V; Peltier OFF, Fan 100%. Five stable seconds at/below `hotLimit - 1°C` before timeout cancelled a stage; failure stepped down at 12/9 V and terminal-locked at 5 V.
- Thermal restoration moved up one rail only after 60 continuous seconds stable, capped by the saved Adaptive ceiling.
- A temporary App quality workflow failed to push `pubspec.lock` non-fast-forward; tests/analyze were skipped and the temporary workflow removed. This is a historical CI incident, not current workflow status.

## 2026-10-12 — V6.1 source-only safety/LED baseline (historical)

- Adaptive entry/exit used safe-5V handoff; restore previously-running Peltier only through safety gates and the normal 5-second OFF→ON soft-start.
- Adaptive ON blinked orange three times; Adaptive OFF blinked white three times, deferred until safe handoff completed if mode was active.
- Serial `BOOT: RESET_REASON=...` diagnostic was retained. Version promotion did not include assistant-side compile/BIN/flash/release.

## 2026-10-08 — V6.0 behavior decisions (historical)

- Adaptive Profile is runtime-only; default HOTSIDE on boot, HOTSIDE_BATTERY remains optional and is not persisted.
- Persistent settings use a shared 10-second quiet-period debounce; only values differing from persisted shadow are written.
- Approved RGB modes: Static, Breath, Mirror Pulse, Comet, Dual Chase, Left/Right and Rainbow. Center Out/Outer In retired.
- Firmware publishes LED animation phase/cycle telemetry so App preview can track physical animation phase. Safety/OTA LED indication has priority.

## 2026-10-06 — V5.8 NTC single-sample and re-arm correction (historical)

- User rejected V5.6 multi-sample/trimmed-mean NTC filtering. V5.8 restored one calibrated ADC sample every second.
- NTC model: 10 kΩ fixed resistor, nominal 10 kΩ NTC, Beta 3950, 3.3 V divider assumption.
- Re-arm feedback history used a threshold variant of `hotLimit - 2°C`; this is superseded by the current V6.x `hotLimit - 1°C` / five-second stability contract.

## 2026-10-06 — V5.7 Touch gesture correction (historical)

- Raw GPIO qualification ~30 ms, startup grace ~1,000 ms, raw HIGH tap duration 60–500 ms, double-tap window 800 ms, long press 5,000 ms; no blocking wait introduced.

## 2026-10-05 — V5.4–V5.6 adaptive/safety history (historical)

- HOTSIDE adaptive safety historically used 10-second step-down dwell with fan/LED rules; subsequent versions changed thermal dwell, re-arm behavior and recovery. Do not apply this old 10-second policy to current V6.6 behavior; the current transition and timing contract lives in FIRMWARE_NOTES.md and VOLTAGE_TRANSITION_MEMORY.md.
- Adaptive upward voltage dwell became 5 seconds after every completed increase in both profiles.
- Historical GPIO mapping: NTC0, Touch1, 12V3, 9V4, Peltier5, Fan6, WS2812 7; 200 ms selector deadtime and 5-second Peltier OFF→ON ramp were retained across later versions.

## 2026-10-04–2026-10-05 — App build/release workflow history (historical)

- Build workflow was restored to a single manual issue/title/token-gated obfuscated release APK.
- Output became one `JEXFYZ-release.apk` asset on GitHub Release `jexfyz-latest`; normal pushes and PRs must not publish the APK.
- Exact previous build runs/assets are historical; verify live Release/Actions state before use.

## HISTORICAL / SUPERSEDED — Pre-V5 history

Detailed V4.x/V5.0–V5.3 changes are retained in earlier commit history and the previous changelog entries. When investigating an old regression, inspect the relevant commits and source diff, but never treat an old baseline as current implementation.
