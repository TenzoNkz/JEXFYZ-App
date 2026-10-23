# JE X FYZ / JE Cooler — App Build & Release Procedure

This file describes the current guarded App release process. APP_BUILD_REPORT.md is the detailed append-only attempt ledger; CHANGELOG.md is general change history.

## Durable build-memory checkpoint policy

- Chat text is not automatically committed to GitHub. For this workflow, only verified commits to `APP_BUILD_REPORT.md` and `CHAT_TRANSFER.md` count as durable saved state.
- Append each actual attempt, run ID, source SHA, gate/job result, failure evidence, repair, test outcome, artifact/checksum verification, and blocker as the work progresses; preserve older attempt records.
- At each logical milestone, and before any likely context-limit interruption, checkpoint the live run status, last completed gate, exact remaining gates, active-run state, blocker and next step in `CHAT_TRANSFER.md`. Finalize both the ledger and handoff at success/blockage.
- A replacement Build App chat must inspect the live Actions run/jobs/logs and release state before acting. If a save did not commit before abrupt interruption, recover from the last verified checkpoint plus live evidence; do not assume unsaved conversation content or start a duplicate run.

## Current release baseline

- Latest verified App package returned by live Actions/Release queries: Build #124, [run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), packaged source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a.
- APK SHA-256: c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318.
- Source ZIP SHA-256: e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152.
- Build #124 passed 116 Flutter tests and configured release gates. Analyzer exited 0 with 25 informational diagnostics. Native Android unit-test tasks were NO-SOURCE.
- The owner reports the shipped unit uses Build #124. Its Firmware V7.1 compile/Online OTA is separately USER-REPORTED. App CI does not prove Firmware compile, BIN provenance, physical OTA, BLE recovery, or thermal/electrical behavior.
- Source-only App changes made after Build #124 have not been packaged by a later verified run. Fetch live Actions/Release evidence before describing what is currently released.

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
