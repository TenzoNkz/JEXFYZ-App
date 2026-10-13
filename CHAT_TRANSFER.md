# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Snapshot date: 2026-10-13 (Asia/Jakarta). This file replaces the previous snapshot; it is a boot/transfer protocol, not a substitute for checking live GitHub state.

Current source-layout note: the V6.3 Online OTA trust-anchor PEM stays inside `firmware/JEXFYZ-V6.3.ino` immediately before `prepareOnlineOtaDownload()`. The firmware remains a single self-contained `.ino`; CA-based HTTPS validation, GitHub raw-BIN allowlisting, NTP time sync and redirect blocking remain active. Compile/runtime status is UNVERIFIED.

## 0. Mandatory boot and authority

1. Read this file first, then fetch current `main` HEAD and source blobs.
2. Read `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_RULES.md`, `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `firmware/FIRMWARE_ANALYSIS.md`, `OTA_PROTECTION.md`, `BUILD_NOTES.md`, and `CHANGELOG.md`.
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
- [VERIFIED] Functional/source checkpoint immediately before the transfer-document replacement: `b29fbd4d8b7569e5735d8d7d7d2554bca3c17865`, message “Scope OTA ambiguity regression assertion correctly”. Commit: https://github.com/TenzoNkz/JEXFYZ-App/commit/b29fbd4d8b7569e5735d8d7d7d2554bca3c17865. The previous documentation-only snapshot replacement is `69e3c6b383ff5ef86f354e087cb7531b7d9db8d8` (https://github.com/TenzoNkz/JEXFYZ-App/commit/69e3c6b383ff5ef86f354e087cb7531b7d9db8d8); it changed only `CHAT_TRANSFER.md`, not functional source.
- [CURRENT SOURCE LAYOUT — NOT COMPILED] Active Firmware source is `firmware/JEXFYZ-V6.3.ino`; CA declaration stays inline in this single sketch, placed before `prepareOnlineOtaDownload()`. Re-fetch live blobs before quoting the post-change IDs. V6.2 source was retired from the active tree.
- [VERIFIED] App source: `lib/main.dart`, blob `535e396005a3bd1429db3096c627d87043b0e1b4`. Package `com.horizontalzzz.jexfyz`; pubspec version remains `1.0.0+3`.
- [VERIFIED] `android/app/build.gradle` blob `d8681cb73156b61da7749633abd63e2fb8c287ba`; intentional `versionName "Telegram @horizontalzzz"` remains unchanged.
- [VERIFIED] Latest V6.3 QC contract test: `test/v6_3_qc_contract_test.dart`, blob `985715321e0564346a9daab5a9edfc77b84341d8`.
- [VERIFIED] Firmware regression test `test/firmware_touch_adaptive_sync_test.dart` remains part of the project; fetch its live blob before quoting a SHA.
- [IMPLEMENTED IN SOURCE; NOT COMPILED] ISRG Root X1 remains inline in `firmware/JEXFYZ-V6.3.ino` so only one firmware `.ino` is needed. V6.3 still uses `cloudClient.setCACert(GITHUB_ROOT_CA)`; do not remove verification or use `setInsecure()`.
- [VERIFIED] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`); `.gitignore` is present.
- [VERIFIED] Only observed workflow in `.github/workflows/` is `.github/workflows/jexfyz-app-build-trigger.yml`, blob `6b1d6cd3c65c4913c288652ac7597e126b37d0cf`. It is manually issue-triggered with title `JE X FYZ — BUILD APP TRIGGER` and body token `JEXFYZ_BUILD_TRIGGER_V1`; normal pushes/PRs do not build the release APK.
- [VERIFIED] Branch search returned `main`, `fix/adaptive-power-sequencing`, `diag/latest-stable-v16`, `diagnostic/v1.6-heap-check`, and `tmp-jexfyz-v5-test`. The non-main branches are not authorization to switch development context; main is authoritative.
- [VERIFIED CURRENT QUERY] Open-PR search returned zero results. Closed-PR search returned #18, #7, #5, #4, #3, #2, and #1. The search connector does not expose a reliable merged flag in these results; closure is verified, but do not infer merged/unmerged status for each item solely from the closed list. Earlier project notes record PR #18 as CLOSED / NOT MERGED; confirm its merge field directly before relying on that distinction.

## 3. Current App follow-up in source

- [IMPLEMENTED IN SOURCE; NOT RUNTIME-VERIFIED] BLE disconnect rediscovery should not start when Auto Connect is disabled or no known cooler identity exists; it cancels retry work when Bluetooth/permissions/location prerequisites fail, suppresses scanning while syncing, and retries after Auto Connect is enabled or app resumes while disconnected.
- [IMPLEMENTED IN SOURCE; NOT RUNTIME-VERIFIED] A `CLOUDOTA` ACK timeout/disconnect is ambiguous, not proof of rejection. Keep OTA recovery state and show waiting-for-reconnect/result messaging. Roll back only on a definite rejection while BLE remains connected.
- [IMPLEMENTED IN SOURCE] The V6.3 QC contract test includes static regression assertions for reconnect cancellation and ambiguous OTA ACK behavior.
- [UNVERIFIED] Flutter tests and Dart analysis have not been run for this follow-up. The current environment reported no Flutter/Dart executable. A prior GitHub Actions run for the V6.2 candidate had 45 passing Flutter tests, but it does not validate current V6.3/current App changes.
- [UNVERIFIED] No APK build/Build App, V6.3 Firmware compile, BIN generation/publication, firmware flash, physical BLE pairing, hardware thermal test, or OTA regression has been performed for the current state.
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
- [VERIFIED SOURCE] Online OTA validates HTTPS certificate chain using the configured ISRG Root X1 CA and only permits the allowlisted raw GitHub firmware URL prefix. No custom SHA/signature layer was added; Firebase firmware metadata remains version + link.
- [UNVERIFIED] Current Firebase rules/App Check enforcement and live metadata were not checked in this transfer.
- [VERIFIED REPOSITORY CHECKPOINT FROM PRIOR AUDIT] Separate production repository `TenzoNkz/JEXFYZ-Firmware` had a `JEXFYZ.cpp.bin` upload whose timestamp predated V6.3 source. Do not assume production BIN corresponds to V6.3; verify version before any authorized release/OTA.
- [USER REQUIREMENT] Do not publish BIN, edit Firebase metadata, flash, or initiate OTA during transfer or QC discussion.

## 6. Android build and release

- [VERIFIED] Workflow file: `.github/workflows/jexfyz-app-build-trigger.yml`; issue title `JE X FYZ — BUILD APP TRIGGER`; body token `JEXFYZ_BUILD_TRIGGER_V1`.
- [VERIFIED WORKFLOW CONFIG] Java 17, Flutter 3.47.2 stable; workflow runs `flutter analyze --no-fatal-infos`, `flutter test`, and builds one obfuscated production-signed release APK after checks.
- [USER REQUIREMENT] Do not trigger this workflow unless user explicitly says Build App.
- [UNVERIFIED] Current V6.3 App source has not passed a new test/analyze/build run; do not report green status based on older CI evidence.
- [UNVERIFIED] The single-file source-layout update has not been compiled. Compile/test/runtime status remains unverified.

## 7. Persistent state files and what changed

- [VERIFIED] At snapshot time, `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_RULES.md`, `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `BUILD_NOTES.md`, `firmware/FIRMWARE_ANALYSIS.md`, `OTA_PROTECTION.md`, and `CHANGELOG.md` already contain the current V6.3 status and App reconnect/OTA acknowledgement follow-up. Their observed blobs were respectively:
  - `PROJECT_STATE.md`: `c6becd8b774b2bef984180db08a3a49384ad08b7`
  - `HANDOVER.md`: `dd3386d58cfa8455d723d3cddbfcbecb521dea09`
  - `CHAT_RULES.md`: `ff5b724310c16643212e31bad20f58f7efb2f24a`
  - `APP_NOTES.md`: `24e09e0c642f9980ce94280ee35b3c51fc41dd0a`
  - `FIRMWARE_NOTES.md`: `e3d7e1fbedcf1cc1754202bb7cb352b7124ba2ba`
  - `BUILD_NOTES.md`: `ec044b85b2492adde2673022991ea9ab0a80d3fa`
  - `firmware/FIRMWARE_ANALYSIS.md`: `a2dd82d1b53531c2efc3b251a2df2e38168a613f`
  - `OTA_PROTECTION.md`: `73df0712e86a05611deb632450ebe99b335aaa2b`
  - `CHANGELOG.md`: `960d962c76c0a46259665e2c4cc5a82e6d3918ed`
- [CURRENT TRUTH] These persistent state files did not require additional edits for this transfer: the current App follow-up was already recorded. Only `CHAT_TRANSFER.md` is to be replaced in this operation.
- [HISTORY/OBSOLETE] Older snapshots embedded below this file’s prior current-status header were contradictory and stale. This file is now being fully replaced to remove duplicate/obsolete snapshots; do not append another copy.

## 8. Historical validation ledger — do not overstate

- [HISTORY — V6.2 CANDIDATE] GitHub Actions run #38362882150 recorded 45 Flutter tests passing. Plain `flutter analyze` returned nonzero due to 23 info-level deprecation notices. This is not evidence that the current V6.3 App or its latest regression test passed.
- [UNVERIFIED CURRENT] No V6.3 firmware compile, BIN, flash, hardware run, BLE pairing test, OTA test, Flutter test, Dart analysis, or APK build is verified for the latest state.
- [CURRENT TRUTH] Project remains DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED. No production BIN or Firebase metadata was modified by the App fixes or this transfer.

## 9. Next session checklist

1. Re-fetch live main HEAD and all source/test/workflow blobs before making claims.
2. Confirm PR states and inspect divergent branches without switching away from main.
3. If user requests validation, run only the explicitly authorized validation; distinguish test/analyze from build, firmware compile, flash, and OTA.
4. Prefer validating the new App regression test and full Flutter test/analyze before Build App, but do not run the build workflow without the explicit trigger command.
5. If the user says they are ready, let them compile/flash V6.3 themselves and gather actual logs/results. Do not infer installed firmware version from source alone.
