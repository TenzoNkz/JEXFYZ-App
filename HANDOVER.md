# JE X FYZ / JE Cooler — Current Handover

Last reconciled against live GitHub on 2026-10-17 (Asia/Jakarta). Build #70 verifies FPS retirement in the released source. Read CHAT_TRANSFER.md for the full technical boot snapshot; this file records the immediate state and next action.

## Current App and release state

- Canonical repo: TenzoNkz/JEXFYZ-App, branch main. Audit baseline HEAD before this memory transaction: 927aed0070f1fbfde0b3ddbe80d2afd8e708a413. Five branches, zero open PRs.
- Latest verified App release: Build #70 / run 38998407325, source commit eb1224232241ca5d44d43e25919fd228875029ab. All 21 active workflow steps passed, 86/86 Flutter tests passed, Dart analysis and Android production compile/gate passed, and APK/source ZIP signature/hash/source checks passed.
- Native JUnit test tasks reported NO-SOURCE because FPS-specific native parser/watchdog tests were retired; do not report native JUnit cases as passed in Build #70.
- APK asset 649412242, 54,538,331 bytes, SHA-256 229aaae5745456498d35f356ee6e0cdde81e7bb29f37238b1172f99f992ab404: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk
- Corresponding source ZIP asset 649412243, 2,847,010 bytes, SHA-256 d0a79cdaf99b169b68cda04c5c3162062f493f0cb6f6ec02c1531950e4bbd8ae: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip
- Release tag jexfyz-latest targets exact source commit eb1224232241ca5d44d43e25919fd228875029ab. Main has later docs and a nonfunctional stale-comment correction; no later functional app change is intended. APP_BUILD_REPORT.md has the full verified ledger.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan Speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Install/update using the Build #70 APK and verify the six metric labels plus the Fan Speed value from live telemetry. FPS diagnostics are retired; no new build is needed just to validate FPS removal.

## Firmware / OTA boundary

- Firmware source: firmware/JEXFYZ-V6.6.ino; blob f51ba6db5d0e91318f63fea4014bb87f7bf76222; FW_VERSION="V6.6"; exactly one versioned active .ino. User accepts V6.6 as final and reports compile plus two same-version Online OTA updates. USER-REPORTED; source-to-BIN provenance remains UNVERIFIED.
- Artifact repository TenzoNkz/JEXFYZ-Firmware contains exactly JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not read/change the BIN or add notes there.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. User/device validation of Build #70: install the released APK and check B/H/V/A/P/F, especially F reflects Fan Speed telemetry and not old FPS.
2. Any code change later: use @Thinking Diskusi! to discuss, @Thinking Eksekusi Full! for authorized scoped source/tests/docs and memory work, and separately @Thinking Eksekusi Build App! for a fresh App build/release. @Thinking Chat Stuck! only recovers the last authorized task.
3. No Build App, Firmware compile, Firebase, OTA/flash, or physical device operation was performed in this reconciliation.
