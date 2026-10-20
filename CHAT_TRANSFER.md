# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after `@Thinking Chat Stuck!` recovery on 2026-10-20 (Asia/Jakarta). This is the final checkpoint for the authorized Eksekusi Full task; source/test/docs status below is based on live `main`. The HEAD/tree recorded here are immediately before this transfer write; this file cannot self-reference its future commit.

## 1. Authority and operation scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; continue directly on `main`, with no branch/PR unless explicitly requested.
- Pre-transfer HEAD: `af34f32f947a5c5ec7b7eac87948aa3f8b099329`; parent `7f95f8b8663c91fea56d99d20761a8be71d590ed`. Tree before transfer write: `af34f32f947a5c5ec7b7eac87948aa3f8b099329`, 67 entries (49 blobs / 18 trees), not truncated.
- `Diskusi` is read-only. `Eksekusi Full` authorizes scoped source/tests/docs/static audit/commit only; it does not authorize App Build, Firmware compile, BIN publication, Firebase, OTA, flashing or physical-device operations. `Eksekusi Build App` is the separate authorization for official App validation/build/release. `Chat Stuck` recovers evidence and never expands scope.
- Keep Android Gradle `versionName "Telegram @horizontalzzz"`. App repository owns code, tests, docs/memory; `TenzoNkz/JEXFYZ-Firmware` remains BIN-only. The user compiles Firmware separately in ArduinoDroid / Arduino-ESP32 Core 3.3.7.

## 2. Current App release and source boundary

- Latest successful App release is **Build #110**, Actions run `39300262741`, packaged commit `b5adcffb2c9724a07cdba4cd8521c1307f1e6566`. Live `jexfyz-latest` Release/tag and both assets target that commit.
- APK asset `657047529`, 54,734,939 bytes, SHA-256 `258211ec9313c555aaac6cd797d1bf6abc6c62c3c2781cd37baa0a8c849bfb84`.
- Corresponding source ZIP asset `657047524`, 2,866,352 bytes, SHA-256 `13d1cad6cf4fbb9b2560da7406f4c6bf875fe4ebc2ed5483e6f0001a3b24aa23`.
- Build #110 includes 44 dp Home metric rows and the original icon-left/text-left, badge-free NOTIFY row with a fixed 56 dp card/slot. **The source follow-up below is newer than Build #110 and NOT RUN / NOT RELEASED.** No App Build was started during this recovery; the guarded trigger workflow is unchanged.

## 3. Current App follow-up — source updated; validation/release pending

- `lib/main.dart`: blob `2e2301db3199569273d0ad1466549ab3fcd04380`. The last source edit in recovery corrected a stale code comment to describe the dynamic Notify height; no runtime behavior changed in that edit.
- `lib/app_settings.dart`: blob `f8e465648946a25eae44f3fad6a5a3bfaca8b050`.
- `lib/floating_monitor.dart`: blob `e7c74bf749698a8331f2b0b31a847b2627ac3e4b`.
- `test/widget_test.dart`: blob `10de861b593c7b4955deaa160ab1d0c3be519f58`.
- `test/floating_monitor_layout_contract_test.dart`: blob `b053a92522223fd237a8f0e025648eb1b26730a5`.
- Home indicator rows are restored to 44 dp (38 dp tile centred in the original 41 dp icon lane); other Home layout/branding stays unchanged.
- NOTIFY is the original icon-left/text-left `Row`; the CONNECTED/DISCONNECTED badge is removed without centring the text or reserving a badge lane. Its minimum height is 44 dp and the container expands naturally only when the body wraps to a second line. Body copy stays normal size, left aligned and limited to two lines; the Home no longer reserves a fixed 56 dp slot.
- Battery/Hotside fire embers enter from the top and fall through the chamber/tube like Peltier snow cadence, but use elongated orange/gold ovals with yellow-white hot cores, restrained halo, deterministic phase lanes, subtle drift and edge fading. Particle geometry is clipped to the respective silhouette. Existing warning predicates stay the same: Battery ≥40°C, Hotside at configured Hotside Limit.
- Hotside inner tube is raised to y=.09 with height .53, closer to the outer cap while preserving the bottom endpoint.
- Voltage inner core vertices are inset; its white core and outline are painted under `canvas.clipPath(bolt)`, preventing white pixels from escaping the upper-right bolt contour. Edge-following voltage pulses remain; 5V red / 9V green / 12V blue mapping is unchanged.
- Settings no longer contains the ABOUT section, `AboutSettingsPage`, `_AboutRow`, or About localization keys. General, Device and Firmware sections remain.
- Contract tests check falling particles, the raised Hotside tube, clipped/inset Voltage core, 44 dp Home rows, dynamic 44 dp-minimum badge-free Notify and removal of Settings About. **Flutter tests and Dart analyzer have NOT RUN for this follow-up.** Do not claim these edits are validated by Build #110.

## 4. Current Firmware V6.9 — not compiled / not installed

- Exactly one active versioned sketch is present: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`, embedded `FW_VERSION="V6.9"`. V6.8 has been retired.
- Adaptive 12 V target tiers remain based on `delta = hotLimit - hotsideC`: delta <1.5°C →100%; 1.5–<2.5°C →90%; 2.5–<3.5°C →80%; 3.5–<4.5°C →70%; 4.5–<5.5°C →60%; ≥5.5°C →50%. Whole-degree examples stay 1°C below limit=100%, 2°C=90%, 3°C=80%, 4°C=70%, 5°C=60%, and 6°C or more=50%.
- PWM changes in 10-point steps: down every 10 seconds, up every 1 second. The pacing clock resets during voltage handoff, Adaptive hot-step transitions, thermal dwell, and inactive/paused cooling-output states, so a 9V→12V change does not immediately downshift from 100% to a low target. Reaching Hotside Limit or active protection forces 100% immediately. Adaptive 5V/9V remains 100%.
- NTC acquisition stays exactly one calibrated `analogReadMilliVolts(PIN_NTC)` sample per second. Static source inspection verified no blocking `delay()` or timing `while()`, removed the old trend/window state names, and retained the immediate 100% safety branch.
- Firmware tests: `test/firmware_qc_contract_test.dart` blob `1b35feeb1e411efec44261ec130eec4535004454`; `test/firmware_touch_adaptive_sync_test.dart` blob `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8`. Tests have NOT RUN for V6.9. Firmware has NOT been compiled or installed. The physical reset cause and actual hardware ramp remain UNVERIFIED.

## 5. Firmware artifact boundary

- `TenzoNkz/JEXFYZ-Firmware` tree has exactly one file: `JEXFYZ.cpp.bin`, blob `9fdd915c3d298cad4de720765dab7fb03f47024d`, size 1,456,368 bytes. Only tree metadata was checked; the BIN payload was not read or changed. Source-to-BIN provenance remains UNVERIFIED.
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
- Final source/test validation remains NOT RUN; only source-level inspection was performed. Build #110 remains the latest successful App release for its older fixed-56-dp NOTIFY source. Current UI changes are NOT RELEASED; Firmware V6.9 is NOT COMPILED / NOT INSTALLED.