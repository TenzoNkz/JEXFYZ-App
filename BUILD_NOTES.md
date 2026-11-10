## Current release baseline — Build #138; Build #140 analyzer failure repaired; candidate awaits #141

- **Latest verified package:** Build #138 / run `42749408202`, source `b553f22092d9b33b2c81753254d2e3f03928fa18`; all 21 main steps, Flutter 157/157, analyzer 25 info-only diagnostics, Android Gradle gate (app JUnit tasks `NO-SOURCE`), APK V1/V2/V3 + expected certificate, corresponding source ZIP, Release/tag parity and downloaded-asset checks passed.
- **Build #139 failed:** analyzer step 12 due stale `lastTemperatureChangeAtMs` and two unused locals; repaired in `93b1ba7b859089eeccd30719ddfb8b8ab2dabaf6` and `2656b6eb9071cf878de2373cfab03d1872e089f8`.
- **Build #140 failed:** run `42781821476`, job `129713425920`, source `cdd0b6dc6bc91d01029e89a0b88fc1185205e239`, step 12 analyzer; 25 infos, 1 warning and 2 errors from two stale `lastValueChange` references after declaration rename. Repair `2a0b1b94f7ebce1607ba26067441accb31a105c7` updates both remaining references; test file read-back confirms old name zero.
- **Candidate before documentation:** main source/test HEAD `2a0b1b94f7ebce1607ba26067441accb31a105c7`, complete recursive tree 131 entries. Includes Home hybrid palette fix and active-output gated per-second Usage Statistics plus analyzer/test repairs; awaiting CI.
- **Release/tag:** Release `jexfyz-latest` ID `403010611` still targets #138; APK SHA-256 `2ed225d992288cccc02313d206675a7313c73a4cad061de70cddf7209d39b9f8`; source ZIP SHA-256 `47161a972131c95a74e8f5a191754504b76e2c31edd95fd19b1b4c75717ab906`.
- **Workflow/trigger:** unchanged issue-only guarded workflow, all 21 gates. Issue #33 OPEN exact; #140 terminal, no active run/PR; no #141 trigger sent. Current Build App authorization permits one guarded retry after checkpoint/read-back.
- Preserve Android `versionName "Telegram @horizontalzzz"`. Physical installation/OEM/BLE/storage soak/thermal/electrical/Firmware/BIN/OTA are not proven by CI.

## Build #141 candidate — active CI run

- **Active run:** [Build #141 / Actions run 42782355435](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42782355435), job `129715178789`, exact source `2fb8dc6ec4a0f41e7cce73e6a49db0e716b56cda`. Steps 1–12 passed including Dart analyzer; step 13 full Flutter test suite is in progress; steps 14–21 pending. No test count, build artifact or new Release yet.

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
