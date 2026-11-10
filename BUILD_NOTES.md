## Current release baseline — Build #138; Build #141 test locale mismatch repaired; candidate awaits #142

- **Latest verified package:** Build #138 / run `42749408202`, source `b553f22092d9b33b2c81753254d2e3f03928fa18`; all 21 gates, Flutter 157/157, analyzer 25 info-only, Android gate (JUnit tasks `NO-SOURCE`), V1/V2/V3/certificate, source ZIP, Release/tag and downloaded asset checks passed.
- **Build #141:** run `42782355435`, job `129715178789`, source `2fb8dc6ec4a0f41e7cce73e6a49db0e716b56cda`. Analyzer passed; Flutter suite 158 passed / 1 failed. Test set Indonesian locale but expected English `Completed cooling run`; correct Indonesian UI label is `Sesi pendinginan selesai` for the completed fixture. Steps 14–21 skipped; no asset/release update.
- **Repair:** commit `bafff332f406fdb75e4534d3d9c426d13e83a31b` changes both locale expectations to `Sesi pendinginan selesai`. Read-back confirms two matching assertions; production UI/localization unchanged. Hosted suite still needs validation.
- **Current candidate before docs checkpoint:** `bafff332f406fdb75e4534d3d9c426d13e83a31b`, full tree 131 entries; current Home and active-run Statistics implementation preserved.
- **Release/tag:** Release `jexfyz-latest` ID `403010611` remains at #138. APK SHA-256 `2ed225d992288cccc02313d206675a7313c73a4cad061de70cddf7209d39b9f8`; source ZIP SHA-256 `47161a972131c95a74e8f5a191754504b76e2c31edd95fd19b1b4c75717ab906`.
- **Trigger state:** workflow issue-only with owner/title/body token guard and all 21 gates; issue #33 OPEN exact; #141 terminal; no active run or open PR. No #142 event sent. Explicit Build App mode authorizes one guarded retry after checkpoint and fresh preflight.
- Preserve Android `versionName "Telegram @horizontalzzz"`; physical install/OEM/BLE/thermal, Firmware/BIN/OTA are separate.

## Build #142 candidate — active CI run

- **Active run:** [Build #142 / Actions run 42782901555](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42782901555), job `129716981807`, exact source `6ec326bd662744eee786817c7ebf68485741a915`. Steps 1–2 passed, step 3 Java 17 in progress, steps 4–21 pending. No artifacts/release yet.

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
