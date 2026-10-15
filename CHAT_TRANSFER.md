# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot checked against live GitHub main on 2026-10-16 (Asia/Jakarta). Read this file first in a new context, then fetch the live repository again. Live source/Git/Actions/Release evidence takes precedence over this snapshot. The current source repair is not yet built or tested. `PROJECT_STATE.md` is current-only; `APP_NOTES.md` carries detailed App contracts; `APP_BUILD_REPORT.md` is the authoritative build evidence ledger; `CHANGELOG.md` is historical.

## 1. Repository identity and current Git checkpoint

- Canonical App source/memory repository: [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App), branch `main`.
- Main HEAD immediately before this transfer-file update: `60b2777b47335a40528c3a476e38c524811dc26e`. This file replacement will be the final documentation-only commit for this repair cycle.
- Current functional source repair checkpoint: `98cfe7ba4d0e9d569b84498d261ad1b67f66eee7`. It restores Build #54 icon geometry with smoothed active-effect interpolation and updates Floating FPS; it has **not** been analyzed, test-run, compiled, built or device-verified.
- Exact artifact repository: [TenzoNkz/JEXFYZ-Firmware](https://github.com/TenzoNkz/JEXFYZ-Firmware). Its live main tree was rechecked and contains exactly one entry: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. Keep this repo BIN-only; source notes/memory belong in the App repo. Source-to-BIN provenance is not independently verified.
- No new branches or PRs were created. All edits in this workstream were committed directly to `main`.

## 2. App identity, workflow, latest release versus current source

- App name `JE Cooler`, in-app brand `JE X FYZ`; package `com.horizontalzzz.jexfyz`; pubspec version `1.0.0+3`. Preserve Android Gradle `versionName "Telegram @horizontalzzz"` exactly.
- Only active build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. It runs only through its owner/title/body-token guarded issue-open/reopen trigger. Exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`; body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal pushes/PRs do not build.
- Latest **verified release** remains [Build #56 / Actions run `38785365015`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38785365015), source commit `235f47b47af4f32582a7f18825ed76d2c6bba54f`. It passed security/architecture/license audit, dependency resolution, Dart analysis, 86/86 Flutter tests, obfuscated APK build, V1/V2/V3 signature/certificate checks, source ZIP checks and publication/downloaded asset verification.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly two verified Build #56 assets: APK asset `644776225` (54,538,412 bytes, SHA-256 `1ae3ef476c170ab0a9d78a77264c5281d60341a931db102c7b8645e4b0dadd19`) and corresponding source ZIP asset `644776227` (2,860,746 bytes, SHA-256 `546d9e6bd99b84273e3b2dca8aa85ced979e118c0704ad97a0a16ff5e9e046c3`).
- **Important distinction:** Build #56 predates and does not contain current repair commit `98cfe7ba4d0e9d569b84498d261ad1b67f66eee7`. Current source-contract tests were edited but have not been run. Current source has not received Dart analysis, Flutter tests, Kotlin compile, APK build or physical-device testing. Do not label the repair CI-tested or released.


## 3. Current source fingerprints

- Current source blobs after repair commit `98cfe7ba4d0e9d569b84498d261ad1b67f66eee7`:
  - `lib/main.dart`: `d24885cf0a40472b9fb23ee6ce73ad772ae73672`.
  - `lib/floating_monitor.dart`: `556217f0035e97fa6060041203151eec1c24ed76`.
  - `lib/app_settings.dart`: `4c89bcb3c04142ce49440a11b92054365c26f7a6`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `44030753bf6a27ac0e9630f2d0f7ca0cc8e3bd0b`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt`: `e44fac7cec76979ef47a256a3e1d416d09ef7e22`.
  - `test/widget_test.dart`: `5a9dc285729b6c85c4f70399cdf17282af1a5c33`.
  - `test/floating_monitor_layout_contract_test.dart`: `7f861d449e518af68fc4ece7278241aa3ce8691b`.
  - `test/shizuku_fps_contract_test.dart`: `5a9efb60b02c1cfabf44a35434f67fb555419c92`.
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

## 7. Current repair scope and unverified points

- `lib/main.dart`: Build #54 `_JexIconPainter` drawing geometry restored; current activity controller provides an interpolated strength parameter. The existing fan phase/coast and Peltier retarget controllers were retained rather than blindly rewritten.
- `lib/floating_monitor.dart`: Shizuku-unavailable state no longer destructively removes persisted metric `F`; sampler refresh is requested when returning to the app if the enabled overlay still has `F) selected.
- Native FPS: fixed UserService operation `dumpsys window displays` is whitelisted; `dumpsys activity activities` remains the fallback. First/invalid/reset/out-of-range samples should render `--`; zero is only accepted for the same previously-positive layer in a valid interval.
- Added source-contract assertions for restored drawing primitives, F selection persistence, WindowManager operation and sample-state handling. Those tests were **not run**.
- Open verification: inspect visual output on device; run Dart/Flutter/Kotlin validation; test Shizuku bind/command output, foreground package and SurfaceFlinger layer matching on the actual Android/OEM version. Current static source checks cannot prove physical FPS.

## 7. Authorization protocol and next validation

- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- **Build #56 is the latest successful release; current repair is not in that APK.** Next automated validation/release step requires the separate `@Thinking Eksekusi Build App!` command. After build validation, device testing must examine the restored icon design and transitions, Floating Monitor behavior and foreground FPS. If F remains `--`, collect `fps_monitor_status` and focused/window/layer diagnostics. CI success is not a substitute for device evidence.
