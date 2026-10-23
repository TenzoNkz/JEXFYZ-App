# JE X FYZ / JE Cooler — App Build & Release Procedure

This file describes the current guarded App release process. APP_BUILD_REPORT.md is the detailed append-only attempt ledger; CHANGELOG.md is general change history.

## Durable build-memory checkpoint policy

- Chat text is not automatically committed to GitHub. For this workflow, only verified commits to `APP_BUILD_REPORT.md` and `CHAT_TRANSFER.md` count as durable saved state.
- Before ending a substantive Build App chat, review changes since the prior checkpoint and save all new durable attempt evidence, blockers, unfinished steps, and next actions. Do not wait for a separate save request; avoid empty commits when there is no new durable state.
- Append each actual attempt, run ID, source SHA, gate/job result, failure evidence, repair, test outcome, artifact/checksum verification, and blocker as the work progresses; preserve older attempt records.
- At each logical milestone, and before any likely context-limit interruption, checkpoint the live run status, last completed gate, exact remaining gates, active-run state, blocker and next step in `CHAT_TRANSFER.md`. Finalize both the ledger and handoff at success/blockage.
- A replacement Build App chat must inspect the live Actions run/jobs/logs and release state before acting. If a save did not commit before abrupt interruption, recover from the last verified checkpoint plus live evidence; do not assume unsaved conversation content or start a duplicate run.

## Current release baseline

- Latest verified App package: Build #128, [run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), exact packaged source commit `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`.
- APK: [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `668133495`, 54,751,323 bytes, SHA-256 `2f5fdf4ffab0eccac3db886855b34f8c2c6c83afb54d7088fd2f8b578d322c5b`.
- Corresponding source ZIP: [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `668133492`, 2,877,957 bytes, SHA-256 `9b740671f7e8d3b9d4cfc1b1e5f3200af905ba207d4a6c8a6b27114f39ec32f4`.
- Build #128 passed 121 Flutter tests; Dart analyzer exited 0 with 25 informational diagnostics; the configured Android Gradle gate reported BUILD SUCCESSFUL. Native Android JUnit tasks were NO-SOURCE. Production APK V1/V2/V3 and expected certificate checks passed; Release/tag parity, exactly-one-APK-plus-source-ZIP, and downloaded asset checksum/source-marker/signature checks all passed.
- The owner-reported shipped unit baseline remains App Build #124 + Firmware V7.1 Online OTA. That field status is USER-REPORTED; Build #128 CI does not prove the new APK is installed or verify Firmware compilation, BIN provenance, physical OTA, BLE recovery, or thermal/electrical behavior.
- Build #128 packages the previously source-only Settings, Device/Perangkat copy, Floating Monitor and language-synchronized notification-channel changes. See APP_BUILD_REPORT.md for complete gate, signing and release evidence.
- New source-only UI sizing patch: commit `57ebcf8d971decf399e7a4d3e5dd5bf3d605010d` caps `JexFixedScalePage` at native 1× for viewports ≥360 dp and adds widget regression coverage at 420/320 dp. This commit is not included in Build #128; Flutter tests, analyzer/formatter and device QA for this patch have not run. Do not describe it as released; verify the live source and require a separate explicit `@Thinking Eksekusi Build App!` before packaging.

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
