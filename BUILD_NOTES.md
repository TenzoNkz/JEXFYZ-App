# JE X FYZ / JE Cooler — App Build & Release Procedure

This file describes the current guarded App release process. APP_BUILD_REPORT.md is the detailed append-only attempt ledger; CHANGELOG.md is general change history.

## Durable build-memory checkpoint policy

- Chat text is not automatically committed to GitHub. For this workflow, only verified commits to `APP_BUILD_REPORT.md` and `CHAT_TRANSFER.md` count as durable saved state.
- Before ending a substantive Build App chat, review changes since the prior checkpoint and save all new durable attempt evidence, blockers, unfinished steps, and next actions. Do not wait for a separate save request; avoid empty commits when there is no new durable state.
- Append each actual attempt, run ID, source SHA, gate/job result, failure evidence, repair, test outcome, artifact/checksum verification, and blocker as the work progresses; preserve older attempt records.
- At each logical milestone, and before any likely context-limit interruption, checkpoint the live run status, last completed gate, exact remaining gates, active-run state, blocker and next step in `CHAT_TRANSFER.md`. Finalize both the ledger and handoff at success/blockage.
- A replacement Build App chat must inspect the live Actions run/jobs/logs and release state before acting. If a save did not commit before abrupt interruption, recover from the last verified checkpoint plus live evidence; do not assume unsaved conversation content or start a duplicate run.

## Current release baseline — Build #138; newer candidate awaits Build #139

- **Latest verified published App package:** Build #138 / [Actions run 42749408202](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42749408202), source b553f22092d9b33b2c81753254d2e3f03928fa18. All 21 main workflow steps passed; analyzer exited 0 with 25 info-level diagnostics; Flutter suite passed 157/157. Android Gradle reported BUILD SUCCESSFUL in 3m 33s; app JUnit compile/test tasks were NO-SOURCE, so no native app JUnit cases ran.
- **APK:** Release asset 729969125, 55,455,835 bytes, SHA-256 2ed225d992288cccc02313d206675a7313c73a4cad061de70cddf7209d39b9f8. V1/V2/V3 and expected production certificate SHA-256 dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0 passed.
- **Matching source ZIP:** asset 729969127, 2,908,354 bytes, SHA-256 47161a972131c95a74e8f5a191754504b76e2c31edd95fd19b1b4c75717ab906. The workflow re-downloaded both assets and verified checksums, source marker, ZIP integrity, APK signatures/certificate.
- **Release/tag:** Release ID 403010611 and tag jexfyz-latest both target #138 source b553f22092d9b33b2c81753254d2e3f03928fa18. This is the current released baseline, not the newer App candidate.
- **Current candidate at preflight:** main HEAD 8115f6702c9be1381c10d1ed610b4a6e720c6753, complete recursive tree 131 entries; 25 commits ahead of #138 source and 0 behind. Current App source implements the Default hybrid Home header palette correction plus active-output-gated per-second Usage Statistics; tests cover both. These changes are committed but NOT YET CI-VALIDATED.
- **Workflow:** .github/workflows/jexfyz-app-build-trigger.yml blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12, issue opened/reopened only, owner/title/body-token guard. Flutter 3.47.2 stable; Gradle 9.3.1. Existing architecture/security audit, dependency, analyzer, full Flutter tests, Android Gradle gate, obfuscated APK, V1/V2/V3 + expected certificate, source ZIP, Release/tag and downloaded-asset verification remain intact.
- **Trigger preflight:** issue #33 is OPEN, owner TenzoNkz, exact title JE X FYZ — EKSEKUSI BUILD APP TRIGGER, exact body token JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1. Latest run #138 is terminal; no active/queued run or open PR. The current explicit Build App command authorizes one guarded issue close/reopen sequence after the docs checkpoint is committed/read back. Do not issue a second event or touch other issues.
- **Physical acceptance:** installation, screenshots/OEM visual QA, live BLE sessions/reconnects, per-second store soak/capacity and thermal/electrical behavior remain UNVERIFIED. CI is not device evidence.
- Preserve Android versionName "Telegram @horizontalzzz". Firmware compilation, BIN, Firebase, OTA, flashing and device operation remain excluded.

## Build #139 candidate — pre-trigger checkpoint, not yet a run

- **Source changes:** Default/Dark share the dark Home header palette, Light remains light; the Default lower content panel remains light. The resolver is shared by metric indicators and NOTIFY. Usage Statistics starts only after complete P1 synchronization and confirmed FAN/PELTIER outputs, stays active while either is ON, closes on both OFF or stale/disconnected telemetry, stores per-second Battery/Hotside samples plus explicit gaps, and plots against elapsed run time. Voltage/Adaptive/Fan Speed remain transition events. The old period selector is removed; 30-day pruning is retention only.
- **Tests:** latest Home theme test and Usage Statistics output/session/sample tests are committed on main. The hosted workflow must validate all of them; no local Flutter formatter/analyzer/test result is claimed for this candidate.
- **Run state:** NOT STARTED. No #139 run ID/job ID exists yet. Do not infer that the released #138 APK contains these changes.
- **Next exact action:** finish/re-read the pre-trigger documentation checkpoint, refresh main/Actions/issue/release, close #33 once and reopen exactly once, verify exactly one new issues run with the final main SHA. Stop BLOCKED rather than repeat the event if no run appears.

---

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
