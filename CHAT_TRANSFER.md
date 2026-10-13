# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Snapshot date: 2026-10-13 (Asia/Jakarta). This file replaces the previous snapshot; it is a boot/transfer protocol, not a substitute for checking live GitHub state.

Current OTA source note: V6.3 Online OTA has been restored to `cloudClient.setInsecure()`. The embedded CA certificate and OTA-only NTP time-sync gate are removed; blue feedback follows Wi-Fi connection before the GitHub GET attempt. The raw GitHub BIN URL allowlist and redirect blocking remain. This bypasses server certificate identity validation. [USER-REPORTED] Firmware compile succeeded and Online OTA connects to GitHub again after this change. Full transfer, flash/apply completion, successful reboot, and installed-version confirmation are not independently recorded here. Canonical prevention record: [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md).

## 0. Mandatory boot and authority

1. Read this file first, then fetch current `main` HEAD and source blobs.
2. Read `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_RULES.md`, `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `firmware/FIRMWARE_ANALYSIS.md`, `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`, `BUILD_NOTES.md`, and `CHANGELOG.md`.
3. Verify current workflows, tests, open/closed PRs, and relevant branches.
4. Authority order: live source/Git refs/workflows; `PROJECT_STATE.md`; technical notes; `HANDOVER.md`/`CHAT_RULES.md`/`CHANGELOG.md`; this file; chat-only state.
5. Label statements as CURRENT TRUTH, VERIFIED, USER-REPORTED, UNVERIFIED, HYPOTHESIS, HISTORY/OBSOLETE, or CHAT-ONLY STATE. Never turn historical or user-reported facts into verified facts without evidence.

## 1. User command and safety protocol

- [USER REQUIREMENT] `Diskusi` = inspect/explain/recommend; do not write changes.
- [USER REQUIREMENT] `Eksekusi` authorizes the discussed change only; keep scope narrow.
- [USER REQUIREMENT] Build App only after an explicit “Build App” command.
- [USER REQUIREMENT] Firmware compile/build, BIN generation, flash, OTA, Firebase/production metadata changes, and release each require their own explicit authorization.
- [USER REQUIREMENT] Prefer direct commits to `main`; do not create branches or PRs unless requested.
- [USER REQUIREMENT] User will compile Firmware themselves; do not compile on their behalf.
- [USER-CONFIRMED] Android Gradle `versionName "Telegram @horizontalzzz"` is intentional creator/contact identity. Preserve it exactly.
- Never claim a write, test, build, device validation, or release that did not occur.

## 2. Current repository checkpoint

- [VERIFIED] Repository: `TenzoNkz/JEXFYZ-App`; primary branch: `main`.
- [VERIFIED] Latest functional OTA source restoration commit: `a87bbcecdca26b3648abff9cb88937e250b41f1f`; `firmware/JEXFYZ-V6.3.ino` now uses `cloudClient.setInsecure()` without the embedded CA or NTP gate. Commit: https://github.com/TenzoNkz/JEXFYZ-App/commit/a87bbcecdca26b3648abff9cb88937e250b41f1f. The OTA contract test update follows in commit `dc0d6ec13d3f58ab864e006e7defb543fd4752b6`.
- [CURRENT SOURCE — USER-REPORTED COMPILE SUCCESS] Active Firmware source is `firmware/JEXFYZ-V6.3.ino`, blob `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`; it remains one self-contained `.ino`, with `cloudClient.setInsecure()` used for Online OTA. Embedded CA and NTP gate are removed. User reports compile succeeded and GitHub connection works again. V6.2 source was retired from the active tree.
- [VERIFIED] App source: `lib/main.dart`, blob `535e396005a3bd1429db3096c627d87043b0e1b4`. Package `com.horizontalzzz.jexfyz`; pubspec version remains `1.0.0+3`.
- [VERIFIED] `android/app/build.gradle` blob `d8681cb73156b61da7749633abd63e2fb8c287ba`; intentional `versionName "Telegram @horizontalzzz"` remains unchanged.
- [VERIFIED] Latest V6.3 QC contract test: `test/v6_3_qc_contract_test.dart`, blob `bf9d96cf671547e48465525c4661e48afd9863ee`.
- [VERIFIED] Firmware regression test `test/firmware_touch_adaptive_sync_test.dart` remains part of the project; fetch its live blob before quoting a SHA.
- [IMPLEMENTED IN SOURCE; USER-REPORTED COMPILE SUCCESS] The previous Online OTA behavior is restored to `cloudClient.setInsecure()`. The embedded ISRG Root X1 PEM, CA validation, `configTime()`, and `TIME_SYNCING`/20-second NTP gate are removed. Blue Wi-Fi feedback now leads directly to the GitHub GET attempt. The user reports compilation succeeded and GitHub connectivity recovered. This intentionally skips server certificate validation; the GitHub raw-BIN URL allowlist and redirect blocking remain.
- [VERIFIED] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`); `.gitignore` is present.
- [VERIFIED] Only observed workflow in `.github/workflows/` is `.github/workflows/jexfyz-app-build-trigger.yml`, blob `6b1d6cd3c65c4913c288652ac7597e126b37d0cf`. It is manually issue-triggered with title `JE X FYZ — BUILD APP TRIGGER` and body token `JEXFYZ_BUILD_TRIGGER_V1`; normal pushes/PRs do not build the release APK.
- [VERIFIED] Branch search returned `main`, `fix/adaptive-power-sequencing`, `diag/latest-stable-v16`, `diagnostic/v1.6-heap-check`, and `tmp-jexfyz-v5-test`. The non-main branches are not authorization to switch development context; main is authoritative.
- [VERIFIED CURRENT QUERY] Open-PR search returned zero results. Closed-PR search returned #18, #7, #5, #4, #3, #2, and #1. The search connector does not expose a reliable merged flag in these results; closure is verified, but do not infer merged/unmerged status for each item solely from the closed list. Earlier project notes record PR #18 as CLOSED / NOT MERGED; confirm its merge field directly before relying on that distinction.

## 3. Current App follow-up in source

- [IMPLEMENTED IN SOURCE; NOT RUNTIME-VERIFIED] BLE disconnect rediscovery should not start when Auto Connect is disabled or no known cooler identity exists; it cancels retry work when Bluetooth/permissions/location prerequisites fail, suppresses scanning while syncing, and retries after Auto Connect is enabled or app resumes while disconnected.
- [IMPLEMENTED IN SOURCE; NOT RUNTIME-VERIFIED] A `CLOUDOTA` ACK timeout/disconnect is ambiguous, not proof of rejection. Keep OTA recovery state and show waiting-for-reconnect/result messaging. Roll back only on a definite rejection while BLE remains connected.
- [IMPLEMENTED IN SOURCE] The V6.3 QC contract test includes static regression assertions for reconnect cancellation and ambiguous OTA ACK behavior.
- [UNVERIFIED] Flutter tests and Dart analysis have not been run for this follow-up. The current environment reported no Flutter/Dart executable. A prior GitHub Actions run for the V6.2 candidate had 45 passing Flutter tests, but it does not validate current V6.3/current App changes.
- [STATUS] The user reports V6.3 compile success and restored GitHub connection. No APK build/Build App, assistant-side Firmware compile, BIN generation/publication, flash, independent physical BLE pairing, hardware thermal test, or complete OTA transfer/apply/reboot regression was performed in this session.
- [CURRENT TRUTH] No source changes should be made as part of a transfer snapshot. The two App fixes above were already reflected in the observed source before this transfer operation.

## 4. Firmware contract and status

- [VERIFIED SOURCE] Target is ESP32-C3 Super Mini / ESP32-C3 Dev Module; logic 3.3 V.
- [USER REQUIREMENT] Pin map: NTC GPIO0; Touch GPIO1; 12 V GPIO3; 9 V GPIO4; Peltier GPIO5; Fan GPIO6; WS2812 GPIO7.
- [USER REQUIREMENT] NTC 10 kΩ + 10 kΩ, Beta 3950; one calibrated ADC sample per second; do not add median/multi-sample averaging. No blocking `delay()` or timing `while()`.
- [USER REQUIREMENT] Hotside limit 40–50 °C, default 45 °C. Manual Peltier re-arm threshold is `hotLimit - 1 °C` plus five seconds stable, as reflected in current V6.3 source/notes.
- [VERIFIED STATIC SOURCE CONTRACT] V6.3 manual Peltier safety latch remains blocking until `enforceSafety()` observes Hotside at/below `hotLimit - 1°C` for five continuous seconds; a single low sample cannot bypass stability.
- [VERIFIED STATIC SOURCE CONTRACT] Adaptive thermal protection has 30-second stages at 12 V, 9 V, and 5 V with Peltier OFF and Fan 100%. Five continuous seconds at/below `hotLimit - 1°C` before the stage deadline cancels the stage; otherwise it steps down 12→9→5 V. Unrecovered 5 V enters terminal lock requiring manual restart. Recovery up one rail requires 60 seconds stable per rail, capped by saved Adaptive ceiling.
- [VERIFIED STATIC SOURCE CONTRACT] Touch long-press while Adaptive is active publishes `ADAPTIVE`, `ADAPTIVE_CEILING`, `FAN`, `PELTIER`, and `FAN_SPEED` telemetry before the `TOUCH_ADAPTIVE` ACK.
- [UNVERIFIED] Static assertions do not prove compilation, real-time behavior, sensor accuracy, LEDs, cooling, or device safety. User-side compile/flash/device tests remain necessary.

## 5. BLE / OTA protected contracts

- BLE service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`; RX: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`; TX: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- [USER REQUIREMENT] ESP32-C3 has one radio path: Wi-Fi OTA and BLE must not own radio simultaneously. OTA flow, state machine, LED indications, recovery, and local OTA are protected; read `OTA_PROTECTION.md` before any OTA-related changes.
- [VERIFIED SOURCE] Online OTA uses TLS via `cloudClient.setInsecure()` and only permits the allowlisted raw GitHub firmware URL prefix; redirects remain blocked. Because certificate verification is bypassed, HTTPS server identity is not authenticated. No custom SHA/signature layer was added; Firebase firmware metadata remains version + link.
- [UNVERIFIED] Current Firebase rules/App Check enforcement and live metadata were not checked in this transfer.
- [VERIFIED CURRENT REPOSITORY CHECKPOINT] Artifact repository `TenzoNkz/JEXFYZ-Firmware` contains `JEXFYZ.cpp.bin`; latest observed upload commit is `b345637acfdbd3f80ae6159a14cc09ddbc05f934` (2026-10-13T13:47:12Z). Matching the BIN to the V6.3 source blob/build provenance has not been independently verified. Do not assume or republish it without provenance and explicit authorization. Its README and OTA regression memory now document this boundary.
- [CROSS-REPO MEMORY LINKS] Firmware artifact repo README: https://github.com/TenzoNkz/JEXFYZ-Firmware/blob/main/README.md. Mirrored OTA prevention note: https://github.com/TenzoNkz/JEXFYZ-Firmware/blob/main/OTA_REGRESSION_MEMORY.md. Canonical source-repo incident memory: https://github.com/TenzoNkz/JEXFYZ-App/blob/main/OTA_REGRESSION_MEMORY.md.
- [USER REQUIREMENT] Do not publish BIN, edit Firebase metadata, flash, or initiate OTA during transfer or QC discussion.

## 6. Android build and release

- [VERIFIED] Workflow file: `.github/workflows/jexfyz-app-build-trigger.yml`; issue title `JE X FYZ — BUILD APP TRIGGER`; body token `JEXFYZ_BUILD_TRIGGER_V1`.
- [VERIFIED WORKFLOW CONFIG] Java 17, Flutter 3.47.2 stable; workflow runs `flutter analyze --no-fatal-infos`, `flutter test`, and builds one obfuscated production-signed release APK after checks.
- [USER REQUIREMENT] Do not trigger this workflow unless user explicitly says Build App.
- [UNVERIFIED] Current V6.3 App source has not passed a new test/analyze/build run; do not report green status based on older CI evidence.
- [USER-REPORTED] The corrected V6.3 source compiled successfully and GitHub connection recovered. [UNVERIFIED] The complete BIN transfer/apply/reboot result is not separately recorded; the assistant has not independently compiled or tested hardware.

## 7. Persistent state files and what changed

- [VERIFIED] The V6.3 Online OTA connection restoration, user-reported compile/GitHub connectivity result, and regression-prevention rules are recorded in the current project notes. Current observed blobs at reconciliation time:
  - `PROJECT_STATE.md`: `769dbc44b9a7d159662e5189c2c12a403f4016fd`
  - `HANDOVER.md`: `db0ba7cd3480de6f88c9c2f857eac8e60620198f`
  - `CHAT_RULES.md`: `8551ee7df1c6fae0a61f1a3545253ac7e10f864a`
  - `APP_NOTES.md`: `8791b4decb55f3a6df93ddf81c1bcb0436f86c0f`
  - `FIRMWARE_NOTES.md`: `0a1fd6c2b13d61eff0a90915c36e4bdc84978144`
  - `BUILD_NOTES.md`: `7e8efec367b04c8ff46f92f6515d63a2ac475e95`
  - `firmware/FIRMWARE_ANALYSIS.md`: `50cf53ca48aff04ca32a99594fea5a0527b9d761`
  - `OTA_PROTECTION.md`: `02a262c9ba2cf490ba3252985d5eba1ce4fbd0b5`
  - `CHANGELOG.md`: `46a354c2e8ac78f1472523d24f02f7c4d4826b83`
  - `OTA_REGRESSION_MEMORY.md`: `7c4dee64a75cec94cd6972e34bd39709abfec63a`
- [CURRENT TRUTH] The current V6.3 Online OTA correction, user-reported compile/GitHub recovery, and no-recurrence policy are recorded across the project notes and the new canonical `OTA_REGRESSION_MEMORY.md`. The companion `TenzoNkz/JEXFYZ-Firmware` repository now has a README and mirrored OTA memory; its BIN was not changed.
- [HISTORY/OBSOLETE] Older snapshots embedded below this file’s prior current-status header were contradictory and stale. This file is now being fully replaced to remove duplicate/obsolete snapshots; do not append another copy.

## 8. Historical validation ledger — do not overstate

- [HISTORY — V6.2 CANDIDATE] GitHub Actions run #38362882150 recorded 45 Flutter tests passing. Plain `flutter analyze` returned nonzero due to 23 info-level deprecation notices. This is not evidence that the current V6.3 App or its latest regression test passed.
- [UNVERIFIED CURRENT] The user reports V6.3 firmware compile success and restored GitHub connectivity after the `setInsecure()` rollback. A full OTA image transfer/apply/reboot confirmation, independent hardware verification, Flutter test, Dart analysis, and APK build are not verified.
- [CURRENT TRUTH] Project remains DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED. No production BIN or Firebase metadata was modified by the App fixes or this transfer.

## 9. Next session checklist

1. Read `OTA_REGRESSION_MEMORY.md` before any OTA connection/TLS/time-sync change; re-fetch live `main` HEAD and all source/test/workflow blobs before making claims.
2. Confirm PR states and inspect divergent branches without switching away from main.
3. If user requests validation, run only the explicitly authorized validation; distinguish test/analyze from build, firmware compile, flash, and OTA.
4. Prefer validating the new App regression test and full Flutter test/analyze before Build App, but do not run the build workflow without the explicit trigger command.
5. The user reports V6.3 compile success and restored GitHub connectivity. For full QC, ask for or inspect the actual device result/diagnostic log for BIN download completion, update finalization, restart and booted version; do not infer this from source or compile alone.
