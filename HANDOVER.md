# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-10-23 (Asia/Jakarta).

## Baseline and evidence

- **Field unit (USER-REPORTED):** the sold/shipped unit remains reported at Android App Build #124 + Firmware V7.1, reportedly compiled and applied through Online OTA. No physical installation/behavior evidence was produced by the App Build run.
- **Latest verified App package:** [Build #128 / GitHub Actions run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), exact source commit `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. All 21 workflow steps and post-job cleanup succeeded.
- **Validation:** 121 Flutter tests passed; Dart analyzer exited 0 with 25 informational diagnostics; the configured Android Gradle gate reported BUILD SUCCESSFUL. Native Android JUnit tasks were NO-SOURCE.
- **Release:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), 54,751,323 bytes, SHA-256 `2f5fdf4ffab0eccac3db886855b34f8c2c6c83afb54d7088fd2f8b578d322c5b`. [Corresponding source ZIP](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), 2,877,957 bytes, SHA-256 `9b740671f7e8d3b9d4cfc1b1e5f3200af905ba207d4a6c8a6b27114f39ec32f4`.
- **Identity verified:** Release ID `403010611` and live `refs/tags/jexfyz-latest` both target `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. Workflow confirmed exactly one APK and one corresponding source ZIP, checksum/source-marker match, and downloaded APK signature V1/V2/V3 with expected production certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- **Build-only boundary:** no Firmware compile, BIN generation/publication, production Firebase edit, OTA, flashing or device operation occurred. CI success does not prove real-device UI, BLE/cooling behavior, Firmware/BIN identity or physical safety.

## Current handoff

The authorized `@Thinking Eksekusi Build App!` operation is complete. Build #125 was a pre-runner startup failure; #126 and #127 reached their CI runner but failed on stale source-contract test assertions. Those test-only expectation mismatches were corrected without weakening any gate. Build #128 then passed the full guarded App release workflow and its downloaded-asset verification. Full attempt-by-attempt evidence is in `APP_BUILD_REPORT.md`; the rolling checkpoint is `CHAT_TRANSFER.md`.

The latest App release contains the source-only changes previously awaiting CI validation: Home-matched Settings scaling, generic Device/Perangkat copy, offline-safe BLE-gated Floating Monitor behavior, and Android notification channel language synchronization. The Home heading follows the selected App language: `Notification` in English and `Notifikasi` in Indonesian. Do not describe these changes as installed on the shipped field unit without new evidence.

## Next continuation

1. On a new task, fetch the live `main` HEAD/tree and current Actions/Release/tag state; do not assume a saved SHA is still the live HEAD.
2. Read `CHAT_RULES.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `BUILD_NOTES.md` and the full active-task reference.
3. No duplicate build is needed for the current source; do not start another release unless the owner explicitly requests a new one. Any future App release must use the unchanged guarded issue-only trigger and full gate set, preserve Android `versionName "Telegram @horizontalzzz"`, and verify downloaded asset identity/checksums.
4. Keep App CI evidence separate from user-reported Firmware V7.1/Online OTA, physical-device behavior, and any Firmware/BIN/Firebase/OTA operation; those remain outside App Build authorization.

## Safety boundary

This handover authorizes no Firmware compilation, BIN generation/publication, Firebase production metadata change, OTA, flash or device operation. Those require separate explicit permission.
