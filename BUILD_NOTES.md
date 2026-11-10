## Current release baseline — Build #138; Build #142 test finder failure repaired; candidate awaits #143

- **Latest verified package:** Build #138 / run `42749408202`, source `b553f22092d9b33b2c81753254d2e3f03928fa18`; all 21 gates, Flutter 157/157, analyzer 25 infos, Android gate with app JUnit tasks `NO-SOURCE`, V1/V2/V3/certificate, source ZIP, Release/tag and downloaded assets verified.
- **Build #142:** run `42782901555`, job `129716981807`, source `6ec326bd662744eee786817c7ebf68485741a915`; steps 1–12 passed including analyzer (25 infos, no warnings/errors); Flutter 158 passed / 1 failed because broad `find.text('00:10')` hit two legitimate widgets.
- **Repair:** commit `f210e6b9036723150f1596d3d54ed270f401ca63` replaces the global text-count assertion with a lookup by `usage-session-elapsed` key and checks `.data`. Test file read-back verified; chart-axis label is preserved.
- **Candidate before docs checkpoint:** `f210e6b9036723150f1596d3d54ed270f401ca63`, tree 131 complete; includes Home hybrid palette, cooler-active Statistics and all prior fixes.
- **Release:** `jexfyz-latest` ID `403010611` remains on #138; asset hashes unchanged and stored above.
- **Trigger:** issue #33 OPEN exact; #142 terminal; no active run/PR. No #143 event sent. The explicit Build App operation permits one guarded retry after checkpoint/read-back.
- Preserve Android `versionName "Telegram @horizontalzzz"`; device/OEM/BLE/thermal and Firmware/BIN/OTA remain distinct.

## Build #143 candidate — pre-trigger

- **Run state:** NOT STARTED. Next: docs read-back, final preflight, one close/reopen issue trigger, and verify one exact-SHA run. Stop BLOCKED if no run appears; no repeated event.

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
