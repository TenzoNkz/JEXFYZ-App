# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot checked against live GitHub main on 2026-10-16 (Asia/Jakarta). Read this file first in a new context, then fetch the live repository again. Live source/Git/Actions/Release evidence takes precedence over this snapshot. `PROJECT_STATE.md` is current-only; `APP_NOTES.md` carries detailed App contracts; `APP_BUILD_REPORT.md` is the authoritative build evidence ledger; `CHANGELOG.md` is historical.

## 1. Repository identity and current Git checkpoint

- Canonical App source/memory repository: [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App), branch `main`.
- Main HEAD when this snapshot was prepared and before replacing this file: `072754ce940cabc7157ac55f61687800772dda04`; commit tree `87842b88b59bb4e9dd85826d1816270477b32c5e`, recursive listing full/not truncated, 80 entries. Five branches exist; zero open PRs. This file replacement is the next documentation-only commit.
- Latest source/test checkpoint (functional changes; docs commits followed): `311a18934a3cbe86a2a4718442c92541f081183f`; tree at that point `8c16a479d5aaeb81f0c2cb30a4446ee310e3f7ec`, full/not truncated, 80 entries.
- Exact artifact repository: [TenzoNkz/JEXFYZ-Firmware](https://github.com/TenzoNkz/JEXFYZ-Firmware). Its live main tree was rechecked and contains exactly one entry: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. Keep this repo BIN-only; source notes/memory belong in the App repo. Source-to-BIN provenance is not independently verified.
- No new branches or PRs were created. All edits in this workstream were committed directly to `main`.

## 2. App identity, workflow, latest release versus current source

- App name `JE Cooler`, in-app brand `JE X FYZ`; package `com.horizontalzzz.jexfyz`; pubspec version `1.0.0+3`. Preserve Android Gradle `versionName "Telegram @horizontalzzz"` exactly.
- Only active build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. It runs only through its owner/title/body-token guarded issue-open/reopen trigger. Exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`; body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal pushes/PRs do not build.
- Latest **verified release** is [Build #55 / Actions run `38783100421`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38783100421), triggered by [issue #28](https://github.com/TenzoNkz/JEXFYZ-App/issues/28), source commit `3ba172b3f35f4ec01732d5848a7ffc807663e710`. It passed Dart analysis, 86/86 Flutter tests, obfuscated APK build, V1/V2/V3 signature/certificate checks, corresponding source ZIP checks, publication, and downloaded asset/hash/signature verification.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset `644735661`, 54,538,412 bytes, SHA-256 `1ae3ef476c170ab0a9d78a77264c5281d60341a931db102c7b8645e4b0dadd19`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset `644735668`, 2,860,630 bytes, SHA-256 `112b14a95f4b21fa04cdd5684e4a0124ee4b50cb17636bcef149e71a20481dce`.
- Functional source/test checkpoint `311a18934a3cbe86a2a4718442c92541f081183f` is included in Build #55. Seven commits after that checkpoint changed project docs/memory only; exact checked-out build/release SHA was `3ba172b3f35f4ec01732d5848a7ffc807663e710`.
- Current Home indicator colors/animations, Floating Monitor controls and foreground screen-FPS changes are **BUILT / CI-TESTED**. They are not yet physical-device verified: native Shizuku UserService behavior, actual SurfaceFlinger layer access, OEM rendering and real foreground FPS remain open. Build #55 does not establish BLE, cooling, Firmware or OTA behavior.


## 3. Current source fingerprints

- `lib/main.dart`: `69eef38d26282b94ad1bea297d812dfd8b9e91e3`.
- `lib/floating_monitor.dart`: `f3ba1518e9f5158cd7f7a1fccac8df0fbac3b2fb`.
- `lib/app_settings.dart`: `4c89bcb3c04142ce49440a11b92054365c26f7a6`.
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `dd10ff0b2c23941badaa33949967fc373f98aeb9`.
- `test/widget_test.dart`: `2426eecea66a357d63ce10214a2d331224c81e37`.
- `test/floating_monitor_layout_contract_test.dart`: `7f861d449e518af68fc4ece7278241aa3ce8691b`.
- `test/shizuku_fps_contract_test.dart`: `798633a24907fd8aca567e70a6376dc59c6e41c9`.
- Current docs immediately before this handoff replacement: `APP_BUILD_REPORT.md` `3946ff8dbb14b37a7095e260615e78aa13a22e50`; `APP_NOTES.md` `2275930b9d8d2f58d54d4c6c87153a9a20638360`; `BUILD_NOTES.md` `128d1c2c77014200d16a6e162443a3cbae3b3c1a`; `PROJECT_STATE.md` `1eaa12af76c773b018b48aefe93138dc403e0dc1`; `CHANGELOG.md` `527fd2ad2c31b71150bbed2f1340ff7ec68a575b`; `MEMORY_INDEX.md` `10126b2f75c3cb05873fb6865d79c1ce65e1182b`; `HANDOVER.md` `abd800a67c60bafb4fb9a6af2491e0051e40b793`; `README.md` `dceb890c68639c9855187034bc09287e17947e76`; `CHAT_RULES.md` `3c1c4f57a8856fc4086e5563e89a9257bacedf1a`; workflow hash above. Re-fetch all files and hashes before relying on this snapshot. This transfer file is updated last; its new blob hash is intentionally not included here.

## 4. Current Home indicator and animation contracts

- Disconnected telemetry remains unknown (`--`) and must not turn indicator/icon text black or generic grey. Keep each metric's lowest semantic accent as the fallback; do not imply that physical outputs are ON/OFF from an accent color.
- Battery temperature: Ice Blue at or below 30°C; smooth cyan/amber/orange transition through the 30–40°C band; Burning Red at or above 40°C. Battery thermal fill maps to 30–40°C. Battery warning/fire threshold remains exactly 40°C.
- Hotside temperature: Ice Blue at or below 30°C; smooth transition above 30°C; Burning Red at the currently configured Hotside Limit. Visual color never changes or replaces Firmware thermal protection.
- Manual voltage text/accent is 5V red, 9V green, 12V blue. Unknown/disconnected voltage falls back to the 5V red accent.
- Home custom Canvas icons have a cleaner bounded geometry and a shared eased activity transition; state changes preserve phase rather than snapping regular icons to frame zero. Voltage sheen stays clipped to its bolt, Bluetooth ripples fade continuously at loop boundaries, Adaptive uses a compact orbit/core, Peltier remains a six-branch free-standing frost crystal, and Fan uses compact blades with the existing voltage-dependent phase continuity/coast behavior. Fan Speed target still retargets smoothly. These are UI illustrations, not live RPM/ice measurements.
- Build #55 compiled this source and passed all 86 Flutter tests plus release checks. Phone-side rendering, animations and transition smoothness remain NOT DEVICE-VERIFIED; do not claim visual behavior was inspected on the phone.

## 5. Floating Monitor presentation and screen FPS

- Metrics remain F/B/H/V/A/P/S. Display Style was removed; the only style is Letters and persisted legacy Icons values normalize to Letters.
- Size is 0.30×–1.00× inclusive in 0.05× increments (14 intervals), default 0.60×. Slider, storage normalization, Flutter/native runtime size reconciliation, pinch scaling and native overlay bounds must agree.
- Opacity is 0–100% in 5% increments; show its current numeric value but no 50% midpoint label. Legacy persisted opacity values snap to the nearest 5%. Opacity changes the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical Letters rows share the same left edge. The overlay remains freely draggable; WindowManager gravity is TOP | START and saved coordinates remain intact.
- Shizuku card is compact: status `Shizuku Access Granted` or `Shizuku Access Denied`, and only `Grant Shizuku Access` and `Check Access`. No long help paragraphs or `Open Shizuku` button.
- FPS is intended to be **foreground screen FPS, not game-only FPS**. The native sampler now prefers the focused window identity and attempts to match that package against SurfaceFlinger timestamp layers, including JE Cooler, apps, launcher, Settings and Android system UI if the OEM exposes matching layers. It uses presented-frame deltas, not the nominal panel refresh rate or Flutter frame timing. After sampling a baseline, a present tracked foreground layer with no new frame delta can report 0 instead of -- just because the screen is static; -- remains for genuinely unavailable foreground identity/layer/access.
- FPS source implementation remains **NOT DEVICE-VERIFIED** despite Build #55 passing CI. Shizuku permission granted does not prove the UserService binds successfully or that a particular Android/OEM exposes SurfaceFlinger layer statistics. After installing/testing Build #55, switch the overlay across JE Cooler, Settings/launcher, apps and an actual game; capture native `fps_monitor_status` and logs if data remains unavailable. Do not infer device behavior from source-contract checks alone.

## 6. Firmware/hardware baseline and protections — unchanged here

- Active editable sketch: `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION="V6.6"`. User treats V6.6 as final and reported compiling it and two successful same-version online OTA updates; reports are user-reported, not independently verified here.
- ESP32-C3 Super Mini, one radio path for Wi-Fi/BLE. Pins: GPIO0 NTC ADC; GPIO1 TTP223 touch; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. NTC 10k + 10k divider, Beta 3950, 3.3V assumption and exactly one calibrated millivolt sample per second.
- Hotside limit range 40–50°C, default 45°C; manual restart re-arm requires Hotside ≤ hotLimit−1°C for five continuous seconds. Adaptive stages at 12/9/5V use 30s safety timing, Fan 100%, Peltier OFF; upward recovery is one rail at a time after 60s stable within saved ceiling. Peltier PWM 20kHz/8-bit with 5s soft start; Fan PWM 25kHz/8-bit. Rail handoff break-before-make 200ms and 1s settle. Verify live Firmware source before hardware changes.
- LED defaults 5V red, 9V green, 12V blue; customizable/resettable. Supported modes: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7; mode 3/Mirror Pulse is retired.
- Firmware protections / OTA are outside the authorized scope here. No Firmware source, BIN artifact, Firebase metadata, OTA, flash or physical device was changed during this App source/UI task.

## 7. Authorization protocol and next validation

- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- **Build #55 is successful; no additional App build is currently pending.** Immediate open validation is device-side: install/use the published APK, examine icon colors/transitions, Floating Monitor size/opacity/drag behavior, then test foreground FPS across JE Cooler, Android system UI and an actual game. If F remains `--`, collect native `fps_monitor_status` and logs before proposing any source change. CI success is not a substitute for this device evidence.




- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- Immediate next step is the distinct explicit command `@Thinking Eksekusi Build App!` to analyze, run Flutter tests, compile Android, verify signing and publish a matching APK/source ZIP only if all gates pass. Then physically validate the new icon design/animation and foreground screen FPS. Current source remains NOT BUILT / NOT DEVICE-VERIFIED.
