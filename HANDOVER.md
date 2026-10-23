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

The active request is to make Settings and the Bluetooth Connection bottom sheet look smaller and more standard; the user describes them as oversized/zoomed. Live source points to the shared `JexFixedScalePage`: it scales its entire child by `constraints.maxWidth / 360.0`, enlarging text, spacing, icons and controls together on viewports wider than 360 logical dp. The planned minimal correction is to cap up-scaling at 1.0 while adapting the child's logical width to the available width, retaining proportional down-scaling only for narrow screens. This is a source-level diagnosis and proposed patch only; no executable source/test/build change has been made in Discussion mode.

The authorized `@Thinking Eksekusi Build App!` operation is complete. Build #125 was a pre-runner startup failure; #126 and #127 reached their CI runner but failed on stale source-contract test assertions. Those test-only expectation mismatches were corrected without weakening any gate. Build #128 then passed the full guarded App release workflow and its downloaded-asset verification. Full attempt-by-attempt evidence is in `APP_BUILD_REPORT.md`; the rolling checkpoint is `CHAT_TRANSFER.md`.

The latest App release contains the earlier Settings layout, generic Device/Perangkat copy, offline-safe BLE-gated Floating Monitor behavior and notification-language changes. The Home heading follows the selected App language: `Notification` in English and `Notifikasi` in Indonesian. The owner reports Build #128 installed/overwritten, but package identity was not independently read. The new sizing correction has not yet been implemented or released.

## Next continuation

1. On a new task, fetch the live `main` HEAD/tree and current Actions/Release/tag state; do not assume a saved SHA is still the live HEAD.
2. Read `CHAT_RULES.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `BUILD_NOTES.md` and the full active-task reference.
3. For the current sizing request, wait for explicit `@Thinking Eksekusi Full!` authorization to modify `JexFixedScalePage` and relevant tests. Verify analyzer and Flutter tests; do not run a release as part of that scope. If the owner then wants an installable package for the UI fix, use a separate `@Thinking Eksekusi Build App!` task with the unchanged guarded issue-only trigger and full gate set, preserving Android `versionName "Telegram @horizontalzzz"` and verifying downloaded asset identity/checksums.
4. Keep App CI evidence separate from user-reported Firmware V7.1/Online OTA, physical-device behavior, and any Firmware/BIN/Firebase/OTA operation; those remain outside App Build authorization.

## Safety boundary

This handover authorizes no Firmware compilation, BIN generation/publication, Firebase production metadata change, OTA, flash or device operation. Those require separate explicit permission.
