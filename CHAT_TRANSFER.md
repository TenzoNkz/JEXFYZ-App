# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after @Thinking Eksekusi Full! on 2026-10-20 (Asia/Jakarta). Pre-change main HEAD was 8d74c0382089590160d65d81f8e505af7243ccc5; recursive tree b24abf62698aa91852eb57bec413b488fcfab129 had 67 entries (49 blobs / 18 trees). This file is written last and cannot self-reference the resulting commit; live HEAD/tree override this baseline.

## 1. Authority and operation scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; continue directly on `main`, with no branch/PR unless explicitly requested.
- Pre-transfer HEAD: `af34f32f947a5c5ec7b7eac87948aa3f8b099329`; parent `7f95f8b8663c91fea56d99d20761a8be71d590ed`. Tree before transfer write: `af34f32f947a5c5ec7b7eac87948aa3f8b099329`, 67 entries (49 blobs / 18 trees), not truncated.
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

- `FIRMWARE_NOTES.md` `67ef8c56d5adf04b77279090ede3a5f1693638a9`
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` `86f95da09078922869bd8f4cbd1865f7402d3d5f`
- `PROJECT_STATE.md` `4c2d76fb793d8e1fbc512efc6bd4f23fc2c6db8d`
- `HANDOVER.md` `a103b5002eec3182dab8ddd0f59fea8c232e4923`
- `MEMORY_INDEX.md` `26a613ffab6eed59bbe4e84bd435a8a990245151`
- `APP_NOTES.md` `827f7e281c2af8bec399215a788b73acab1a662a`
- `DESIGN_NOTES.md` `e4a66b78dfb636d79e5b260e2e6893d21a676cf6`
- `README.md` `ce9c2839270334e5a73003e117a60d8c7b43d67b`
- `CHANGELOG.md` `4997f99cc06330af79ed81c6d544d48ad4eb49e1`
- `APP_BUILD_REPORT.md` `65ec94d99fc1bc75d8be49b7a40ab45eabf8988a`
- `CHAT_RULES.md` `849ea46d4137c29b7b427e853fbe15ac5e3d994a`
- `CHAT_TRANSFER_PROMPTS.md` `95545a00dd37ca972dd89c8c368ebec2a71eb50a`
- `BUILD_NOTES.md` `c43878a276b5bb998903d38cd7b44c8e354f4c9b`
- `OTA_PROTECTION.md` `01e17086b537afb4fd90a64d6b22c3a33b37b010`
- `OTA_REGRESSION_MEMORY.md` `ca4415fde22eb55c95eaed97f07fa376c9d9ed86`
- `VOLTAGE_TRANSITION_MEMORY.md` `0d3391ac5406fc9de97c962285d03cd3284cb8de`
- `.github/workflows/jexfyz-app-build-trigger.yml` stays guarded and unchanged at workflow blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`.

## 7. Recovery disposition

- RECOVERED: requested follow-up source/tests were already present on live `main`; no duplicate feature patch was applied. Corrected the stale fixed-56-dp NOTIFY source comment, synchronized current App source fingerprints and Home NOTIFY layout wording in canonical docs, and refreshed this transfer snapshot last.
- Final source/test validation remains NOT RUN; only source-level inspection was performed. Build #110 remains the latest successful App release for its older fixed-56-dp NOTIFY source. Current UI changes are NOT RELEASED; Firmware V6.9 compile/install is USER-REPORTED; independent compile logs, source-to-BIN provenance and installed version remain UNVERIFIED.