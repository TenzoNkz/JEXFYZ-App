# JE X FYZ / JE Cooler — App Build & Release Procedure

This file describes the current guarded App release process. APP_BUILD_REPORT.md is the detailed append-only attempt ledger; CHANGELOG.md is general change history.

## Durable build-memory checkpoint policy

- Chat text is not automatically committed to GitHub. For this workflow, only verified commits to `APP_BUILD_REPORT.md` and `CHAT_TRANSFER.md` count as durable saved state.
- Before ending a substantive Build App chat, review changes since the prior checkpoint and save all new durable attempt evidence, blockers, unfinished steps, and next actions. Do not wait for a separate save request; avoid empty commits when there is no new durable state.
- Append each actual attempt, run ID, source SHA, gate/job result, failure evidence, repair, test outcome, artifact/checksum verification, and blocker as the work progresses; preserve older attempt records.
- At each logical milestone, and before any likely context-limit interruption, checkpoint the live run status, last completed gate, exact remaining gates, active-run state, blocker and next step in `CHAT_TRANSFER.md`. Finalize both the ledger and handoff at success/blockage.
- A replacement Build App chat must inspect the live Actions run/jobs/logs and release state before acting. If a save did not commit before abrupt interruption, recover from the last verified checkpoint plus live evidence; do not assume unsaved conversation content or start a duplicate run.

## Current release baseline

- **Latest verified App package:** Build #131, [Actions run 42474266430](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42474266430), exact tested/package source `b3c4fee432fddc49430840daeb1e2eecbe78a0db`.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `723696457`, 54,849,627 bytes, SHA-256 `d614bc42c6270fa3de616d944d043fc833cd0ab0ffc391d89526627606c3ee35`.
- **Matching source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `723696458`, 2,888,040 bytes, SHA-256 `cca5609e5a471f204118f2bdfc40e6aa0fa7dcb6dc151a4b306e6c9ca4615177`.
- Build #131 passed all 21 workflow main gates; **142 Flutter tests passed**; Dart analyzer exited 0 with 25 info-level diagnostics; Android Gradle gate reported `BUILD SUCCESSFUL`. Native Android JUnit compile/process/test tasks were `NO-SOURCE`, so no native JUnit case executed.
- APK build command: `flutter build apk --release --obfuscate --split-debug-info=build/symbols`. V1/V2/V3 signatures and the expected production certificate passed verification. Certificate SHA-256: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- Release ID `403010611` and live `jexfyz-latest` tag both target `b3c4fee432fddc49430840daeb1e2eecbe78a0db`. Exactly one APK and one corresponding source ZIP are attached. Step 21 re-downloaded both assets and verified APK/source checksums, source marker, signature and certificate.
- **Validated/released in Build #131:** compact Settings/Connection typography and spacing, scan lifecycle/error-state presentation, BLE scanner ownership coordination (passive/manual/one-shot and handoff fencing), and explicit Home Fan Speed localization are included in the package. The complete Flutter suite containing the regression coverage passed.
- **Physical QA remains pending:** CI widget tests do not replace screenshot review or Android/OEM testing. The owner has not confirmed installation of Build #131. Do not infer physical BLE/cooling behavior, Firmware/BIN identity or OTA state from App CI.
- **Historical Build #130 failure:** run `42473329529` failed at the Flutter test gate with 139 passed / 3 stale source-contract failures. The specific App/test repairs were committed before the #131 retry; preserve the complete failure record in APP_BUILD_REPORT.md.
- **Warnings:** 25 analyzer info notices, Kotlin Gradle Plugin 2.2.20/Built-in Kotlin migration advisory, Gradle deprecation advisory, non-fatal Flutter watcher message and cache-save denial due missing writable token scope. These did not fail the workflow. Native Android test tasks were `NO-SOURCE`.
- Android Gradle `versionName` remains exactly `Telegram @horizontalzzz`. Firmware V7.1 compile/Online OTA remains USER-REPORTED and separate from Build #131.



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
