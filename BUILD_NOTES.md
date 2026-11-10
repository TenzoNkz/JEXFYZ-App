# JE X FYZ / JE Cooler — App Build & Release Procedure

This file describes the current guarded App release process. APP_BUILD_REPORT.md is the detailed append-only attempt ledger; CHANGELOG.md is general change history.

## Durable build-memory checkpoint policy

- Chat text is not automatically committed to GitHub. For this workflow, only verified commits to `APP_BUILD_REPORT.md` and `CHAT_TRANSFER.md` count as durable saved state.
- Before ending a substantive Build App chat, review changes since the prior checkpoint and save all new durable attempt evidence, blockers, unfinished steps, and next actions. Do not wait for a separate save request; avoid empty commits when there is no new durable state.
- Append each actual attempt, run ID, source SHA, gate/job result, failure evidence, repair, test outcome, artifact/checksum verification, and blocker as the work progresses; preserve older attempt records.
- At each logical milestone, and before any likely context-limit interruption, checkpoint the live run status, last completed gate, exact remaining gates, active-run state, blocker and next step in `CHAT_TRANSFER.md`. Finalize both the ledger and handoff at success/blockage.
- A replacement Build App chat must inspect the live Actions run/jobs/logs and release state before acting. If a save did not commit before abrupt interruption, recover from the last verified checkpoint plus live evidence; do not assume unsaved conversation content or start a duplicate run.

## Current release baseline

- **Latest verified App package:** Build #133, [Actions run 42619673642](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42619673642), exact tested/package source `5201a3e07f36305ffe3882a1b965b9e7414cd71a`.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `727484780`, 54,849,627 bytes, SHA-256 `8fc837b9ec946cb3bccb6a8d400dc1483a19de9eff506c22ada2d4dcef0b1146`.
- **Matching source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `727484787`, 2,890,067 bytes, SHA-256 `3a35158b16df567dbc2be1804c9bd0681d96012daffc61adddf61aa6b7be01fb`.
- Build #133 passed all 21 main workflow gates; **145 Flutter tests passed**; Dart analyzer exited 0 with 25 info-level diagnostics; Android Gradle gate reported `BUILD SUCCESSFUL in 3m 29s`. Native Android app JUnit compile/process/test tasks were `NO-SOURCE`, so no native app JUnit case executed.
- APK command: `flutter build apk --release --obfuscate --split-debug-info=build/symbols`. V1/V2/V3 signatures and expected production certificate passed; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- Release ID `403010611` and live `jexfyz-latest` tag both target `5201a3e07f36305ffe3882a1b965b9e7414cd71a`. Exactly one APK and one matching source ZIP are attached. Step 21 re-downloaded both assets and verified APK/source checksums, source marker, ZIP integrity, signature and certificate.
- **Included in Build #133:** theme-aware Home Light Mode icon/painter, contrast-adjusted metrics and contrast-safe NOTIFY foregrounds, plus the repaired source-contract assertions. Existing compact Settings/Connection UI, localization, Bluetooth scan-state and passive/manual/one-shot scanner ownership remain included.
- **Physical QA pending:** CI widget tests do not replace screenshot review or Android/OEM testing. Owner installation of Build #133 is not yet confirmed. Do not infer physical BLE/cooling behavior, Firmware/BIN identity or OTA from App CI.
- **Build #132 history:** run `42619044436` failed at Flutter tests with 144 passed / 1 stale whitespace-sensitive source-contract matcher failure. The test-only fix was committed before #133; preserve both attempt outcomes in APP_BUILD_REPORT.md.
- **Warnings:** 25 analyzer info notices; Kotlin Gradle Plugin 2.2.20 upgrade advisory; deprecated Android Gradle options / Gradle 10 advisory; nonfatal Flutter watcher and ELF DWARF notices; self-signed/untimestamped certificate and auxiliary META-INF notices; cache save denied by read-only token scope with cleanup successful. Required V1/V2/V3 and certificate checks passed.
- Android Gradle `versionName` remains exactly `Telegram @horizontalzzz`. Firmware V7.1 compile/Online OTA remains USER-REPORTED and separate from Build #133.



## Usage Statistics release-candidate preflight — 2026-11-10

- **Assessment:** READY TO START ONE GUARDED BUILD/QC ATTEMPT; NOT YET VERIFIED RELEASE-READY. The source feature is committed on `main` and the current workflow executes the missing hosted validation gates (`flutter analyze --no-fatal-infos`, full `flutter test`, Android `:app:testDebugUnitTest`) before APK creation. A missing local Flutter run is therefore not a reason to bypass or pretend validation; the official pipeline itself must supply that evidence.
- **Candidate source state:** live `main` before this documentation note was `2377ee40e8435b2505426a7398473600123772fe`. `jexfyz-latest` still targets Build #133 source `5201a3e07f36305ffe3882a1b965b9e7414cd71a`; compare reported `main` ahead by 53 commits and identifies `lib/usage_statistics.dart` and `test/usage_statistics_test.dart` as additions after the tag. Usage Statistics is not in the current package.
- **Workflow:** `.github/workflows/jexfyz-app-build-trigger.yml` remains issue opened/reopened only, owner + exact title + body-token guarded. The re-fetched workflow uses Flutter `3.47.2` stable and Gradle `9.3.1`; it runs the architecture/security audit, dependency resolution, analyzer, all Flutter tests, Android Gradle gate, obfuscated APK, V1/V2/V3 signing, expected production certificate, corresponding-source ZIP, Release/tag and re-downloaded asset verification. No gate is to be weakened.
- **Trigger inventory:** issue #33 is closed, authored by `TenzoNkz`, has the exact required title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; issue #32 is another matching closed trigger. Issue #34 is deleted (GitHub returned 410). There are no open issues or open PRs. #33 is the newest valid reusable trigger candidate; only reopen it once after a fresh Actions-state check and an explicit `Eksekusi Build App!`. This Diskusi did not reopen/create an issue or trigger a run.
- **Known items that will remain visible even if CI passes:** low-priority “Last value change” label can display a synthetic held-value endpoint rather than the last persisted event; recorder queue has no explicit bound/coalescing; 30-day raw event-store growth is not stress-measured. These are not proven runtime failures and must not be described as fixed by CI. Physical/OEM visual acceptance is separate.
- **Result boundary:** Build #133 remains the latest documented verified package. The new Usage Statistics code has no hosted analyzer/test/Android/build/signature/release evidence yet. `Eksekusi Build App!` authorizes a single guarded validation/release attempt and justified App-scope repairs from concrete failures; it does not authorize Firmware/BIN/Firebase/OTA/flash/device actions.

## Authorization and trigger

- Start end-to-end App Build/QC/release only with @Thinking Eksekusi Build App!.
- Read the full .github/workflows/jexfyz-app-build-trigger.yml and current main before invoking anything.
- Workflow is issue-triggered only. Required title: JE X FYZ — EKSEKUSI BUILD APP TRIGGER. Required body token: JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1.
- Do not add push/PR release triggers or weaken workflow gates to make a build easier.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- Produce the single ordinary obfuscated production-signed APK and its corresponding source ZIP; do not produce a Play Store app bundle.

## Required release gates

1. Confirm live main, intended source SHA, current workflow and trigger input.
2. Follow the workflow's architecture/security/license/dependency, Dart analyzer and Flutter test gates.
3. Verify APK compilation, obfuscation, V1/V2/V3 signing and the configured production certificate.
4. Verify the corresponding-source ZIP and required source markers/path/license checks.
5. Confirm Release publication and the live tag target.
6. Download the published APK and ZIP, then verify exact count, name, size, digest and identity against the build output.
7. Record all evidence, warnings, skips and unverified physical behavior in APP_BUILD_REPORT.md.

## Evidence-based repair and retry

- Inspect actual failing step/job logs. Repair an App-scope root cause instead of lowering test expectations or bypassing a gate.
- Commit justified repairs to main, then trigger a new run and confirm its intended source SHA.
- Retry only after a concrete fix or a documented transient infrastructure cause. Never launch duplicate builds blindly.
- If permissions, runner allocation, signing secrets, external services or owner/device action blocks progress, record the exact blocker and stop as BLOCKED.
- A successful App build does not authorize Firmware compilation, BIN publication/replacement, Firebase mutation, OTA, flash or device actions. Those require separate explicit permission.
- Use Prompt 2 in CHAT_TRANSFER_PROMPTS.md for chat-limit LOAD + CONTINUE of the guarded Build App/QC workflow. Its copy-ready block already begins with Eksekusi Build App! (without the @Thinking prefix); paste it as one complete message without a duplicate command line. Keep the run ledger, not a recap chat, as the continuation source.
