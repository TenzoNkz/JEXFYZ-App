# JE X FYZ / JE Cooler — Current Project State

Last checked against live main at the start of the documentation rework: 2026-10-23 (Asia/Jakarta). This is current-only state, not history; fetch live HEAD and tree on every new task.

## Product baseline and evidence

- Owner-reported field baseline: Android App Build #124 and Firmware V7.1, reportedly compiled and updated through Online OTA. The product is sold/shipped and unavailable for routine physical repair.
- Independently verified App release: [Build #124 / Actions run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), packaged source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. APK SHA-256 c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318; source ZIP SHA-256 e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152.
- Build #124 passed 116 Flutter tests and configured App release gates; native Android JUnit tasks were NO-SOURCE. This verifies the package/build gates for that source commit, not Firmware compilation, OTA apply/reboot, BLE behavior or hardware safety.
- Keep Build #124 + Firmware V7.1 as the production baseline. Avoid discretionary releases and preserve remote recovery/safety.

## Durable project-memory / recovery policy

- `TenzoNkz/JEXFYZ-App/main` is the shared project-memory source, but chat transcripts are not automatically synchronized to GitHub. A state is saved only after the relevant document update is committed and verified.
- The two transfer prompts are in `CHAT_TRANSFER_PROMPTS.md`: Prompt 1 for Discussion/general engineering, specifically authorized Eksekusi Full, or recovery of an already-authorized operation; Prompt 2 only for guarded Build App/QC.
- Checkpoint each durable decision, meaningful finding, logical milestone, test result, or blocker. At substantive task completion, update `CHAT_TRANSFER.md` and the relevant canonical note. While Build App progresses, append actual attempts to `APP_BUILD_REPORT.md` and checkpoint the current run in `CHAT_TRANSFER.md`.
- On recovery, load the latest committed checkpoint and current repository/Actions evidence. If interruption happened before a write was committed, treat the unsaved conversation tail as potentially lost; never invent its content or repeat side effects blindly.

## Pre-Build repository check — 2026-10-23 (Asia/Jakarta)

- Canonical repository: TenzoNkz/JEXFYZ-App, branch main. At the start of this pre-build audit, live main HEAD was `3234cecd7903f66622e5bf1b14fdb1dfc86fcb82`, commit "docs: checkpoint Home notice localization decision". Its recursive tree contained 69 entries and was not truncated; the live query returned no open pull requests. Documentation-only corrections made during this audit move main beyond that SHA; always fetch the final live HEAD before any future build.
- Active Firmware: firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", source blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- Latest guarded attempt: Build #125 / run 39905665853 targeted source `709f03a94ae8312af541b0bd876e67ea01fdd395` and failed in pre-runner startup with `runner_id=0`, no runner name, no steps/logs/artifacts. No named release gate ran; the exact infrastructure root cause remains UNVERIFIED. Full evidence is in APP_BUILD_REPORT.md.
- Owner update (2026-10-23): the owner reports the Actions issue has been fixed and now works (`USER-REPORTED`). Live Actions still lists #125 as the newest run, so the claimed recovery is not independently verified by a later run. Do not trigger anything in Discussion; after separate `@Thinking Eksekusi Build App!` authorization, run a fresh preflight and use the existing issue-only trigger once to verify runner startup and exact `head_sha`.
- Latest verified release remains Build #124 / run 39386733061; Release `jexfyz-latest` and its tag still target packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. Build #125 produced no package. The newer App source therefore remains unvalidated/unreleased.

## Latest App source implementation — not yet released/validated

The latest source-only App implementation on main covers:
- Home-matched 360-dp Settings/sub-settings and modal design canvas, with system text scaling disabled.
- Device / Perangkat terminology for user-facing device labels, locked-menu copy, BLE discovery/errors and service notifications.
- Floating Monitor detaches while disconnected and only attaches when the saved enable preference and synchronized connected telemetry permit it. Saved intent survives disconnect or missing overlay permission.
- Alert IDs 2101–2104, persistent BLE foreground ID 2110 and Floating Monitor ID 2301 are distinct; channel IDs remain stable. Channel labels/descriptions synchronize to the selected App language on startup and language change.
- OTA-result messages are formatted using the language selected when displayed. OTA protocol/transport was not edited in that UI change.

The related static tests exist, including test/device_copy_notification_contract_test.dart and test/floating_monitor_layout_contract_test.dart. They were not executed in this documentation rework. Dart analyze/format and Android compilation have not been run for this latest source-only change. No new App release is proven; Build #124 + V7.1 remains the reported field baseline.

## Open design/validation items

- Home notice heading contract is resolved by owner decision (2026-10-23): use `Notification` in English and `Notifikasi` in Indonesian, following the selected App language. Documentation only; no executable source change or build was authorized.
- Rapid Hotside-rise/slope shutdown plus manual re-arm remains an unimplemented Firmware requirement. Do not imply it is covered by Adaptive Fan tiers or raw-decimal limit safety.
- BLE App-only authorization is BLOCKED / NOT IMPLEMENTED until a trusted backend, device-bound enrollment grant and per-session signature verification are designed/deployed.
- Exact field BIN-to-source identity, installed-version evidence, physical reboot/BLE recovery and thermal/electrical behavior remain independently unverified despite the owner's report.
- Historical reports of resets during a voltage transition and during Adaptive entry have no captured reset reason; brownout remains a hypothesis. Keep the two incidents separate.

## Protected baseline

- Firmware Hotside limit 40–50°C (default 45°C); at or above limit, existing safety forces Fan 100% and Peltier OFF.
- Adaptive Fan tiers relative to limit: delta ≤2°C→100%; 3–4→90%; 5–6→80%; 7–8→70%; 9–10→60%; ≥11→50%. Ramp +10 points/second, −10 points/10 seconds; Adaptive 5 V/9 V remains 100%.
- Preserve NTC one-sample-per-second path, cooperative millis() timing, Touch/P1, voltage/Peltier sequencing, radio ownership and Local/Online OTA recovery.
- Online OTA intentionally uses cloudClient.setInsecure(); server certificate identity is not authenticated. Keep the GitHub BIN allowlist, redirect blocking, response/image/size checks and version+link metadata contract.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- No App Build/release, Firmware compile, BIN/Firebase mutation, OTA, flash or device operation was authorized or performed by this documentation rework.
