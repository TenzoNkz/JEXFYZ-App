# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-10-23 (Asia/Jakarta).

## Baseline and evidence

- **Field update (USER-REPORTED):** the owner says they installed/overwrote the app with the latest successful Build #128 and shared screenshots/video. The device's installed package identity was not independently read. Firmware V7.1 compile/Online OTA remains USER-REPORTED; CI cannot prove Firmware/physical behavior.
- **Latest verified App package:** [Build #128 / GitHub Actions run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), exact source commit `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. All 21 workflow steps and post-job cleanup succeeded.
- **Validation:** 121 Flutter tests passed; Dart analyzer exited 0 with 25 informational diagnostics; the configured Android Gradle gate reported BUILD SUCCESSFUL. Native Android JUnit tasks were NO-SOURCE.
- **Release:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), 54,751,323 bytes, SHA-256 `2f5fdf4ffab0eccac3db886855b34f8c2c6c83afb54d7088fd2f8b578d322c5b`. [Corresponding source ZIP](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), 2,877,957 bytes, SHA-256 `9b740671f7e8d3b9d4cfc1b1e5f3200af905ba207d4a6c8a6b27114f39ec32f4`.
- **Identity verified:** Release ID `403010611` and live `refs/tags/jexfyz-latest` both target `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. Workflow confirmed exactly one APK and one corresponding source ZIP, checksum/source-marker match, and downloaded APK signature V1/V2/V3 with expected production certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- **Build-only boundary:** no Firmware compile, BIN generation/publication, production Firebase edit, OTA, flashing or device operation occurred. CI success does not prove real-device UI, BLE/cooling behavior, Firmware/BIN identity or physical safety.

## Current handoff

The owner first authorized `@Thinking Eksekusi Full!` for oversized Settings/Connection UI. A scale cap was committed in `57ebcf8d971decf399e7a4d3e5dd5bf3d605010d`, followed by test/child-layout refinements `c92b0d08a16d101abf01b448804431dc795060fd` and `25adcfed5dd24b5c41ff603797087a30e704e8ae`; however, the owner has now clarified that the target must match Home's master-canvas behavior exactly to keep physical size stable when Android DPI changes. That latest requirement supersedes the 1.0 cap. Current main therefore does **not yet** implement the final requested contract. Next source task should remove the cap and use Home's uncapped `constraints.maxWidth / 360.0`, fixed 360-dp logical width, height/inset conversion by scale and one uniform transform for Settings/root/subpages/Connection. Update the regression tests to expect logical width 360 and scale `420/360` at 420 dp, and logical width 360 and scale `320/360` at 320 dp. Static checks have passed for the interim patch, but Flutter tests, formatter/analyzer and device QA have NOT RUN because Flutter/Dart executables are unavailable. Build #128 remains the latest release; no new build has been run.

The authorized `@Thinking Eksekusi Build App!` operation is complete. Build #125 was a pre-runner startup failure; #126 and #127 reached their CI runner but failed on stale source-contract test assertions. Those test-only expectation mismatches were corrected without weakening any gate. Build #128 then passed the full guarded App release workflow and its downloaded-asset verification. Full attempt-by-attempt evidence is in `APP_BUILD_REPORT.md`; the rolling checkpoint is `CHAT_TRANSFER.md`.

The latest App release Build #128 contains the earlier Settings layout, generic Device/Perangkat copy, offline-safe BLE-gated Floating Monitor behavior and notification-language changes. The Home heading follows the selected App language: `Notification` in English and `Notifikasi` in Indonesian. The owner reports Build #128 installed/overwritten, but package identity was not independently read. The new sizing correction is implemented on `main` but unvalidated/unreleased.

## Next continuation

1. On a new task, fetch the live `main` HEAD/tree and current Actions/Release/tag state; do not assume a saved SHA is still the live HEAD.
2. Read `CHAT_RULES.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `BUILD_NOTES.md` and the full active-task reference.
3. The sizing source patch and regression test are committed, but targeted widget tests, formatter/analyzer, full Flutter suite and device-layout QA remain NOT RUN because this environment has no Flutter/Dart tools. In a Flutter-enabled environment, run `dart format` on the modified files, the targeted `test/floating_monitor_layout_contract_test.dart`, `flutter analyze --no-fatal-infos`, and the full `flutter test` suite. Correct any genuine failures without weakening gates and checkpoint real results. Do not run an App Build as part of this `Eksekusi Full` task. If the owner then wants an installable package, a separate `@Thinking Eksekusi Build App!` task is required, using the unchanged guarded issue-only trigger and full gates, preserving Android `versionName "Telegram @horizontalzzz"` and verifying downloaded asset identity/checksums.
4. Keep App CI evidence separate from user-reported Firmware V7.1/Online OTA, physical-device behavior, and any Firmware/BIN/Firebase/OTA operation; those remain outside App Build authorization.

## Safety boundary

This handover authorizes no Firmware compilation, BIN generation/publication, Firebase production metadata change, OTA, flash or device operation. Those require separate explicit permission.
