# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after @Thinking Eksekusi Full! on 2026-10-20 (Asia/Jakarta). Pre-change main HEAD was 8d74c0382089590160d65d81f8e505af7243ccc5; recursive tree b24abf62698aa91852eb57bec413b488fcfab129 had 67 entries (49 blobs / 18 trees). This file is written last and cannot self-reference the resulting commit; live HEAD/tree override this baseline.

## 1. Authority and operation scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; continue directly on `main`, with no branch/PR unless explicitly requested.
- Pre-task HEAD: `8d74c0382089590160d65d81f8e505af7243ccc5`; parent `05e4f644d6bf82ae2682154082c3e44a4876205a`. Pre-task tree `b24abf62698aa91852eb57bec413b488fcfab129`, 67 entries (49 blobs / 18 trees), not truncated.
- `Diskusi` is read-only. `Eksekusi Full` authorizes scoped source/tests/docs/static audit/commit only; it does not authorize App Build, Firmware compile, BIN publication, Firebase, OTA, flashing or physical-device operations. `Eksekusi Build App` is the separate authorization for official App validation/build/release. `Chat Stuck` recovers evidence and never expands scope.
- Keep Android Gradle `versionName "Telegram @horizontalzzz"`. App repository owns code, tests, docs/memory; `TenzoNkz/JEXFYZ-Firmware` remains BIN-only. The user compiles Firmware separately in ArduinoDroid / Arduino-ESP32 Core 3.3.7.

## 2. Current App release and source boundary

- Latest successful App release is Build #113, Actions run 39350217172, packaged commit 05e4f644d6bf82ae2682154082c3e44a4876205a. Live jexfyz-latest Release/tag and both assets target that commit.
- APK asset 657872748, 54,718,555 bytes, SHA-256 7252e952983560254822b8d77a9a1c47d5a3f91d80bf8ed50e58586bbe2c2991.
- Corresponding source ZIP asset 657872749, 2,866,922 bytes, SHA-256 0fcccecc639e20f16d65976a5f3c334dd2ce4f7692d2a4d95b5b8aaad7dae59f.
- Build #113 passed 109 Flutter tests and all 21 main workflow steps; analyzer exit 0 with 25 info-level diagnostics. Native Android test tasks were NO-SOURCE. Release/tag ref, asset digests and source marker were verified.

## 3. Current App follow-up — source updated; validation/release pending

- Current source blobs: lib/main.dart d0fdb7482d939b34b0a1824b33d37f6457835818; test/widget_test.dart 09cfe3e7b744b988571a28ad0d9377da5ee36cb1. The follow-up is newer than the released source and NOT RUN / NOT RELEASED.
- Seven Home rows are 45 dp; NOTIFY is fixed at 44 dp and body text scales down if it wraps to two lines; the gap above it is 3 dp. Cooler image constraints remain stable with one- or two-line copy.
- Battery/Hotside fire particles draw first as background, clipped OUTSIDE the foreground silhouette with ClipOp.difference. Icon shell/body/tube/graduations paint over them. Battery warning stays ≥40°C and Hotside warning stays at configured limit.
- Flutter tests and Dart analyzer have NOT RUN for this follow-up. No App Build or device operation was started; guarded workflow remains unchanged.


## 4. Current Firmware V6.9 — compile/install USER-REPORTED

- Exactly one active versioned sketch is present: firmware/JEXFYZ-V6.9.ino, blob 8e0f0ff5a65962ebdb44300b05fc161cf9349d96, embedded FW_VERSION V6.9. V6.8 has been retired; user reports compile/install success, but independent proof is pending.
- Adaptive 12 V target tiers remain based on `delta = hotLimit - hotsideC`: delta <1.5°C →100%; 1.5–<2.5°C →90%; 2.5–<3.5°C →80%; 3.5–<4.5°C →70%; 4.5–<5.5°C →60%; ≥5.5°C →50%. Whole-degree examples stay 1°C below limit=100%, 2°C=90%, 3°C=80%, 4°C=70%, 5°C=60%, and 6°C or more=50%.
- PWM changes in 10-point steps: down every 10 seconds, up every 1 second. The pacing clock resets during voltage handoff, Adaptive hot-step transitions, thermal dwell, and inactive/paused cooling-output states, so a 9V→12V change does not immediately downshift from 100% to a low target. Reaching Hotside Limit or active protection forces 100% immediately. Adaptive 5V/9V remains 100%.
- NTC acquisition stays exactly one calibrated `analogReadMilliVolts(PIN_NTC)` sample per second. Static source inspection verified no blocking `delay()` or timing `while()`, removed the old trend/window state names, and retained the immediate 100% safety branch.
- Firmware tests: `test/firmware_qc_contract_test.dart` blob `1b35feeb1e411efec44261ec130eec4535004454`; `test/firmware_touch_adaptive_sync_test.dart` blob `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8`. Recorded CI Firmware tests have NOT RUN for V6.9. The user reports the Firmware was successfully compiled and installed; compile logs, source-to-BIN provenance, installed version, physical reset cause and actual PWM ramp remain UNVERIFIED independently.

## 5. Firmware artifact boundary

- `TenzoNkz/JEXFYZ-Firmware` tree has exactly one file: `JEXFYZ.cpp.bin`, blob 821b022f97353d9a7aea4695b2e37c98b7488e15, size 1,456,560 bytes. Only tree metadata was checked; the BIN payload was not read or changed. Source-to-BIN provenance remains UNVERIFIED.
- No Arduino compile, App Build, BIN generation/publication, Firebase update, OTA, flashing or device operation was performed in this recovery.

## 6. Canonical memory/document fingerprints before transfer write

- `FIRMWARE_NOTES.md` `cbd98b32ed40e81549a5f23af6017724d7f987aa`
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` `92fa33131cc3a434033e45bdab930812a8bf85cb`
- `PROJECT_STATE.md` `98a36ec6d56019c80469c483e44d1a93c9e1d003`
- `HANDOVER.md` `9503016ef34f5e74e515890eb6dfe6ccebd23adf`
- `MEMORY_INDEX.md` `3d2be0cec693f5f14c4ca1cda8f88af57b518b7e`
- `APP_NOTES.md` `6bccafbc9be14cabea52dcd158131be0476e0367`
- `DESIGN_NOTES.md` `2f7d15b5bafddbbae14a0000cd905bebd7a96f9b`
- `README.md` `71d948fbf7db206f03a66536968893cc7e9f7535`
- `CHANGELOG.md` `78979ceb5a7f6889f2a6d7ff309a4b89ad3cdb91`
- `APP_BUILD_REPORT.md` `2b9f9ef1df25c3ce8362a7ee5034e6f66cde8f4e`
- `CHAT_RULES.md` `7f07107a388d3997e733961c9544c28c780953b1`
- `CHAT_TRANSFER_PROMPTS.md` `95545a00dd37ca972dd89c8c368ebec2a71eb50a`
- `BUILD_NOTES.md` `d4503bf79f293e447f4ea6dbe35e2f6d829531af`
- `OTA_PROTECTION.md` `01e17086b537afb4fd90a64d6b22c3a33b37b010`
- `OTA_REGRESSION_MEMORY.md` `ca4415fde22eb55c95eaed97f07fa376c9d9ed86`
- `VOLTAGE_TRANSITION_MEMORY.md` `8ed01d20a6408a7df36952feb930bbe1c4f667a7`
- `.github/workflows/jexfyz-app-build-trigger.yml` stays guarded and unchanged at workflow blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`.

## 7. Recovery disposition

- EXECUTED (Eksekusi Full): committed Home layout/thermal background-layer source and regression-contract updates to `main` in `0494d51dd776535c1e208297039a106d7d5c7d0f` and `b4bb63591f03568a9287017275e76c308f57e36a`; this transfer snapshot records the final memory reconciliation. Flutter tests and analyzer have NOT RUN for the newest source. No App Build or Firmware/device operation was started.
- Final source/test validation remains NOT RUN for the newest follow-up; only source-level/static-contract inspection was performed. Build #113 remains the latest successful App release for the preceding source. Current 45 dp/fixed-NOTIFY/background-fire changes are NOT RELEASED; Firmware V6.9 compile/install is USER-REPORTED; independent compile logs, source-to-BIN provenance and installed version remain UNVERIFIED.