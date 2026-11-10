## Current release baseline — Build #138; Build #139 failed analyzer; candidate awaits Build #140

- **Latest verified package:** Build #138 / [Actions run 42749408202](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42749408202), source `b553f22092d9b33b2c81753254d2e3f03928fa18`. All 21 main workflow steps passed; analyzer 25 info-level diagnostics; Flutter tests 157/157; Android Gradle gate succeeded with native app JUnit tasks `NO-SOURCE`; APK V1/V2/V3 and expected production certificate, matching source ZIP, Release/tag and downloaded-asset checks passed.
- **APK:** asset `729969125`, 55,455,835 bytes, SHA-256 `2ed225d992288cccc02313d206675a7313c73a4cad061de70cddf7209d39b9f8`.
- **Source ZIP:** asset `729969127`, 2,908,354 bytes, SHA-256 `47161a972131c95a74e8f5a191754504b76e2c31edd95fd19b1b4c75717ab906`.
- **Build #139 failed:** run `42765001359`, job `129659294295`, source `2ad43deb499f73dede808e2cc03d1a8843697f59`. Steps 1–11 passed; analyzer step 12 failed with 25 info diagnostics, two warnings (unused `range`, unused `expectedTime`) and one error (test references removed `lastTemperatureChangeAtMs`). Steps 13–21 skipped; no APK/ZIP/Release update.
- **Concrete repair on main:** `93b1ba7b859089eeccd30719ddfb8b8ab2dabaf6` removes unused `range`; `2656b6eb9071cf878de2373cfab03d1872e089f8` switches the test to `lastTemperatureSampleAtMs` and removes obsolete expected-time locals. Both files read-back verified. No analyzer/test/release gate changed.
- **Current source candidate before checkpoint:** main `2656b6eb9071cf878de2373cfab03d1872e089f8`, complete recursive tree 131 entries. It includes hybrid Home header palette repair and cooler-output gated per-second Usage Statistics; new UI/test plus analyzer repairs are awaiting hosted CI.
- **Workflow:** blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`, issue opened/reopened only, owner/title/body-token guard, Flutter `3.47.2`, Gradle `9.3.1`; all architecture/security, dependency, analyzer, Flutter test, Android, obfuscated APK, V1/V2/V3/certificate, source ZIP, Release/tag and downloaded-asset checks remain.
- **Trigger state:** issue #33 OPEN, exact owner/title/token. #139 terminal; no active/queued run or open PR. No #140 trigger sent. The current repeated Build App authorization permits one guarded close/reopen after the docs checkpoint and fresh final preflight.
- **Next:** after commit/read-back, recheck final main/tree/workflow/issue/Actions/Release/tag/protected version; close #33 once, verify closed/no run, reopen once; confirm a single new run with exact final main SHA. Stop BLOCKED if event does not produce a run.
- Preserve Android `versionName "Telegram @horizontalzzz"`. Physical installation, OEM visuals, BLE, storage soak, thermal/electrical, Firmware/BIN/OTA remain separate and unverified.

## Build #140 candidate — pre-trigger, no run yet

- **App source:** Default/Dark Home header uses dark palette; Light uses light; Default lower content remains light. Metrics and NOTIFY share the header resolver. Usage Statistics requires full P1 readiness and confirmed FAN/PELTIER output, records per-second temperature samples/gaps in local SQLite against elapsed run time, and retains transition events for Voltage/Adaptive/Fan Speed. The 1H/24H/7D/30D chart period selector is removed; 30-day DB pruning is retention.
- **Test:** latest sample regression now matches `lastTemperatureSampleAtMs`, and stale test-only wall-clock formatting code was removed. The hosted workflow must revalidate the complete suite.
- **Run state:** NOT STARTED; no #140 run/job ID exists. Latest verified package remains #138.

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
