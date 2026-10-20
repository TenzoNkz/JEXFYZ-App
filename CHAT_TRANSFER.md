# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after the falling-fire icon redesign, Home/Settings cleanup and Adaptive Fan V6.9 pacing on 2026-10-20 (Asia/Jakarta). This is the final handoff snapshot for this execution and is written after source/tests/docs.

## 1. Authority, scope and protocol

- Canonical editable repository: `TenzoNkz/JEXFYZ-App`, branch `main`. Continue directly on `main`; no branches/PRs unless explicitly requested.
- Pre-transfer HEAD: `0c08a3d9423df4e648f795e9c0a68e43f5a2567e`; parent `f3798df87e8b5295fa0ddc1a986e68c020f4681e`. Recursive tree immediately before this snapshot: `0c08a3d9423df4e648f795e9c0a68e43f5a2567e`, 67 entries (49 blobs / 18 trees), not truncated. This file is written last and cannot self-reference its future commit.
- `@Thinking Diskusi!` is read-only. `@Thinking Eksekusi Full!` permits scoped source/tests/docs/static audit/commit only and does not authorize App Build, Firmware compilation, BIN publication, Firebase updates, OTA, flashing or device operations. `@Thinking Eksekusi Build App!` is the separate authorization for official App validation/build/release. `@Thinking Chat Stuck!` recovers authorized work but never widens scope.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. App repository owns all source, tests, docs and memory; `TenzoNkz/JEXFYZ-Firmware` is BIN-only. User compiles Firmware separately in ArduinoDroid with Arduino-ESP32 Core 3.3.7.

## 2. Current successful App release — Build #110

- Actions run `39300262741` completed successfully on packaged source commit `b5adcffb2c9724a07cdba4cd8521c1307f1e6566`. Live `jexfyz-latest` Release/tag and both assets target this source. Build #110 is the latest successful App release.
- APK asset `657047529`, 54,734,939 bytes, SHA-256 `258211ec9313c555aaac6cd797d1bf6abc6c62c3c2781cd37baa0a8c849bfb84`.
- Corresponding source ZIP asset `657047524`, 2,866,352 bytes, SHA-256 `13d1cad6cf4fbb9b2560da7406f4c6bf875fe4ebc2ed5483e6f0001a3b24aa23`.
- Build #110 contains the restored Home metric row height (44 dp) and badge-free NOTIFY with the original icon-left/text-left `Row`, no `CONNECTED`/`DISCONNECTED` badge, and a 56 dp card/slot to fit two normal-size lines. It does not include the latest follow-up below.
- Current App follow-up after Build #110 is **NOT RUN / NOT RELEASED**. No App Build was started during this execution, and the guarded workflow `.github/workflows/jexfyz-app-build-trigger.yml` remains unchanged.

## 3. Current App source follow-up — NOT RUN / NOT RELEASED

- `lib/main.dart` blob `08592a9d861a11ecdb8de1aa289f8ce06bf2e20c`: Home rows remain 44 dp; NOTIFY remains 56 dp, icon-left/text-left, up to two lines, no connection badge. No unrelated Home/menu/BLE/control redesign.
- Battery/Hotside: fire particles now enter from the top and fall through the icon like Peltier's particle cadence, but as elongated orange/gold fire ovals with bright yellow-white cores, restrained halo, subtle drift/rotation and boundary fading. Particles stay clipped to the appropriate chamber/silhouette. Existing warning predicates stay unchanged: Battery ≥40°C, Hotside at configured Hotside Limit.
- Hotside geometry: inner tube moved from y=.17/h=.45 to y=.09/h=.53, closer to the outer cap while retaining its lower endpoint.
- Voltage geometry: `_boltInnerCore`'s upper-right vertex is inset and painting of the inner white core is clipped to the outer bolt, preventing the white area from leaking beyond the right-upper contour. The existing edge-following pulses and 5V red / 9V green / 12V blue mapping remain.
- Settings: removed ABOUT section, `AboutSettingsPage`, `_AboutRow` and their EN/ID translation keys. General, Device and Firmware sections remain.
- App blobs: `lib/app_settings.dart` `f8e465648946a25eae44f3fad6a5a3bfaca8b050`; `lib/floating_monitor.dart` `e7c74bf749698a8331f2b0b31a847b2627ac3e4b`; `test/widget_test.dart` `b4a4ae36389432bb1334f8940b66caf3bf1ad184`; `test/floating_monitor_layout_contract_test.dart` `b053a92522223fd237a8f0e025648eb1b26730a5`.
- New source contracts check falling particles, raised tube, clipped Voltage core, 44 dp rows, the 56 dp badge-free Notify Row and removal of the Settings About page. Flutter tests and Dart analyzer have **NOT RUN** for these latest changes. Do not claim Build #110 validates them.

## 4. Current Firmware V6.9 — SOURCE UPDATED / NOT COMPILED / NOT INSTALLED

- Exactly one versioned sketch exists in the App repository: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`, embedded `FW_VERSION="V6.9"`. The prior V6.8 sketch has been retired.
- Adaptive 12 V target tiers remain based on `delta = hotLimit - hotsideC`: delta <1.5°C →100%; 1.5–<2.5°C →90%; 2.5–<3.5°C →80%; 3.5–<4.5°C →70%; 4.5–<5.5°C →60%; ≥5.5°C →50%. The whole-degree user examples remain 1°C below limit=100%, 2°C=90%, 3°C=80%, 4°C=70%, 5°C=60%, and 6°C or more=50%.
- PWM is paced in 10-point steps: down every 10 seconds, up every 1 second. The step clock resets during voltage handoff, Adaptive hot-step transition, thermal dwell and inactive/paused output state; after 9V→12V the fresh downshift timer prevents an immediate 100%→50% drop. When the Hotside limit is reached or protection is active, 100% is forced immediately without pacing. Adaptive 5V/9V remains at 100%.
- NTC sampling remains exactly one calibrated `analogReadMilliVolts(PIN_NTC)` sample per second. Static audits confirmed no blocking `delay()` or timing `while()` was introduced, the old trend/window state names are gone, and safety force-100% path remains. Firmware contract tests have **NOT RUN** for V6.9. V6.9 has **NOT been compiled or installed**.
- Firmware tests: `test/firmware_qc_contract_test.dart` blob `1b35feeb1e411efec44261ec130eec4535004454`; `test/firmware_touch_adaptive_sync_test.dart` blob `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8`.
- The reported hardware reset cause and physical ramp outcome remain UNVERIFIED. The 10-second downshift and 1-second upshift are intended to reduce abrupt load changes, but there is no hardware test result proving that resets are eliminated.

## 5. Firmware artifact repository boundary

- The live recursive tree of `TenzoNkz/JEXFYZ-Firmware` contains exactly one entry: `JEXFYZ.cpp.bin`, blob `9fdd915c3d298cad4de720765dab7fb03f47024d`, size 1,456,368 bytes. Only repository/tree metadata was inspected; the BIN payload was not read or changed. This metadata differs from an earlier checkpoint, so the current tree metadata is authoritative. Source-to-BIN provenance remains UNVERIFIED.
- No Firmware compile, BIN generation/publication/replacement, Firebase change, OTA, flashing or physical-device operation was performed.

## 6. Canonical documentation fingerprints before transfer write

- `FIRMWARE_NOTES.md` `67ef8c56d5adf04b77279090ede3a5f1693638a9`
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` `86f95da09078922869bd8f4cbd1865f7402d3d5f`
- `PROJECT_STATE.md` `1515f8d1c0362f7e6c821cd7545e494398895e91`
- `HANDOVER.md` `ba0923af98c06b025fe748c01dea71bb4dcf304e`
- `MEMORY_INDEX.md` `be7ba580b0a881b345d83028457749219a25db73`
- `APP_NOTES.md` `694a78480239d23d6b65d1dbe7db9e4822fb4d3e`
- `DESIGN_NOTES.md` `4ba83c1e6e8398b6c95f21f90cb848b34965f18b`
- `README.md` `78f0c4a16a4b7d14de72811dff4a8e220f4199e2`
- `OTA_PROTECTION.md` `01e17086b537afb4fd90a64d6b22c3a33b37b010`
- `OTA_REGRESSION_MEMORY.md` `ca4415fde22eb55c95eaed97f07fa376c9d9ed86`
- `VOLTAGE_TRANSITION_MEMORY.md` `0d3391ac5406fc9de97c962285d03cd3284cb8de`
- `CHAT_RULES.md` `1ade3d6fc902ba35e6604938bb3565736533b9a9`
- `CHAT_TRANSFER_PROMPTS.md` `95545a00dd37ca972dd89c8c368ebec2a71eb50a`
- `CHANGELOG.md` `859b95f3870b919af9b3bf9233e0bc3ecd249563`
- `BUILD_NOTES.md` `f937de5f286f73938daede52340ff43c6f0f8a68`
- `APP_BUILD_REPORT.md` `200add33c57f522170b69ca669533496f4f90b87`
- `.github/workflows/jexfyz-app-build-trigger.yml` `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12` (guarded issue-trigger workflow unchanged).

## 7. Final disposition

- RECOVERED / EXECUTED: falling thermal-fire effect, Hotside tube geometry, Voltage core containment, Home 44 dp/56 dp layout retained, Settings About removal, Adaptive Fan V6.9 paced PWM, source contracts and current memory updated.
- Static source inspections passed for requested source invariants. No Flutter/Dart test or analyzer run, no Arduino compile, no App Build/release, and no hardware/device action was performed during this execution.