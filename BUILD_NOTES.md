# JE X FYZ / JE Cooler — App Build & Release Procedure

This file describes the current guarded App release process. APP_BUILD_REPORT.md is the detailed append-only attempt ledger; CHANGELOG.md is general change history.

## Durable build-memory checkpoint policy

- Chat text is not automatically committed to GitHub. For this workflow, only verified commits to `APP_BUILD_REPORT.md` and `CHAT_TRANSFER.md` count as durable saved state.
- Before ending a substantive Build App chat, review changes since the prior checkpoint and save all new durable attempt evidence, blockers, unfinished steps, and next actions. Do not wait for a separate save request; avoid empty commits when there is no new durable state.
- Append each actual attempt, run ID, source SHA, gate/job result, failure evidence, repair, test outcome, artifact/checksum verification, and blocker as the work progresses; preserve older attempt records.
- At each logical milestone, and before any likely context-limit interruption, checkpoint the live run status, last completed gate, exact remaining gates, active-run state, blocker and next step in `CHAT_TRANSFER.md`. Finalize both the ledger and handoff at success/blockage.
- A replacement Build App chat must inspect the live Actions run/jobs/logs and release state before acting. If a save did not commit before abrupt interruption, recover from the last verified checkpoint plus live evidence; do not assume unsaved conversation content or start a duplicate run.

## Current release baseline

- **Latest verified App package:** Build #129, [run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), exact packaged source commit `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `668498025`, 54,751,323 bytes, SHA-256 `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`.
- **Matching source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `668498026`, 2,878,916 bytes, SHA-256 `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed **122 Flutter tests**, Dart analyzer exit 0 with 25 informational diagnostics, and the configured Android Gradle gate (`BUILD SUCCESSFUL`). Native Android unit-test tasks were `NO-SOURCE`. Obfuscated APK build, V1/V2/V3 and production-certificate checks, matching source ZIP, Release/tag parity and downloaded asset digest/source-marker/signature checks all passed.
- **Home-equivalent sizing patch validated/released:** Settings root/subpages, Bluetooth Connection sheet and selected modal surfaces use the same uncapped 360-dp DPI-compensating canvas as Home. The fixed-physical-size density regression test passed on the hosted Flutter runner.
- **New compact Settings/Connection source pass after Build #129:** `main` now has compact-only base typography/spacing on Settings root/subpages and the Connection sheet, while retaining the released master canvas and DPI formula. Source/test commits: `5ab14e258a9e21bfec486e3c6a3d81d6705c6d0f`, `bfdcafd1ad044974935b4e473d68f2096a297fbf`, `415d240db3cd9b3e2bca3ef760c4ba667459c604`. This source is not part of Build #129. The targeted Flutter test and `dart format` could not start because Flutter/Dart are unavailable (`command not found`, exit 127); analyzer/full suite and device QA remain NOT RUN. A separate explicit `@Thinking Eksekusi Build App!` is required before packaging.
- The owner previously reported installing/overwriting Build #128 on the shipped unit; the exact installed package identity was not independently read. Do not assume Build #129 is installed. Firmware V7.1 compile/Online OTA remains USER-REPORTED. App CI does not prove field installation, physical-device display/BLE/cooling/OTA behavior, Firmware compilation or BIN provenance.

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
