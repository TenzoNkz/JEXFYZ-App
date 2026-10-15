# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot checked against live GitHub main on 2026-10-16 (Asia/Jakarta), after successful Build #58 and current-note reconciliation. Read this file first in a new context, then fetch the live repository again. Live source/Git/Actions/Release evidence takes precedence over this snapshot. Production source repair and test-contract fix are built and CI-tested by Build #58; physical-device behavior remains unverified. `PROJECT_STATE.md` is current-only; `APP_NOTES.md` carries detailed App contracts; `APP_BUILD_REPORT.md` is the authoritative attempt/build evidence ledger; `CHANGELOG.md` is historical.

## 1. Repository identity and current Git checkpoint

- Canonical App source/memory repository: [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App), branch `main`.
- Main HEAD immediately before this final transfer-file update: `c2be58fcf5b2f274c386b29a30085836c0ebeec4` (last current-note update before this transfer-file commit).
- Build #58 / run `38793790061` succeeded with source/release target `db11df355780174b1da7dcea4d5947bfa7ba7ca5`. It includes production source repair checkpoint `98cfe7ba4d0e9d569b84498d261ad1b67f66eee7` and test-contract correction `432c30ec538ff7de6c7e77f0c68bac313f4f8015`; Dart analysis passed, **87/87 Flutter tests passed**, and all build/sign/release/asset verification gates passed. Only actual phone-side behavior remains unverified.
- Exact artifact repository: [TenzoNkz/JEXFYZ-Firmware](https://github.com/TenzoNkz/JEXFYZ-Firmware). Its live main tree was rechecked and contains exactly one entry: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. Keep this repo BIN-only; source notes/memory belong in the App repo. Source-to-BIN provenance is not independently verified.
- No new branches or PRs were created. All edits in this workstream were committed directly to `main`.

## 2. App identity, workflow, latest release versus current source

- App name `JE Cooler`, in-app brand `JE X FYZ`; package `com.horizontalzzz.jexfyz`; pubspec version `1.0.0+3`. Preserve Android Gradle `versionName "Telegram @horizontalzzz"` exactly.
- Only active build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. It runs only through its owner/title/body-token guarded issue-open/reopen trigger. Exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`; body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal pushes/PRs do not build.
- Latest verified release is [Build #58 / Actions run `38793790061`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38793790061), source/release commit `db11df355780174b1da7dcea4d5947bfa7ba7ca5`. Audit, dependencies, Dart analysis, **87/87 Flutter tests**, obfuscated APK build, V1/V2/V3 signature/certificate checks, source ZIP checks and downloaded asset verification all passed.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly two verified Build #58 assets: APK asset `644929744` (54,636,716 bytes, SHA-256 `88ee4aeadbba20279f36601dcf05e253746ba8189cefb125787db22a1553b2bd`) and corresponding source ZIP asset `644929745` (2,864,393 bytes, SHA-256 `c331bc2912999dee148922b90018a151a4a355cacc064c0d87653633fe5c4094`). Release target and source archive marker both match `db11df355780174b1da7dcea4d5947bfa7ba7ca5`.
- Build #57 / run `38793336598` failed only at five stale widget source-contract assertions (82 passed, 5 failed) after audit/dependencies/analyzer passed; no release was published by that attempt. Test-only correction `432c30ec538ff7de6c7e77f0c68bac313f4f8015` updated the assertions without deleting tests or relaxing a gate. Build #58 verified the corrected suite and release. Physical-device screen FPS/overlay behavior remains **NOT DEVICE-VERIFIED**.


## 3. Current source fingerprints

- Build #58 exact source/release commit: `db11df355780174b1da7dcea4d5947bfa7ba7ca5`. Main HEAD immediately before this final transfer-file replacement: `c2be58fcf5b2f274c386b29a30085836c0ebeec4`. Documentation-only commits after the release keep release provenance fixed at the Build #58 source SHA.
- Current implementation and test blobs:
  - `lib/main.dart`: `d24885cf0a40472b9fb23ee6ce73ad772ae73672`.
  - `lib/floating_monitor.dart`: `556217f0035e97fa6060041203151eec1c24ed76`.
  - `lib/app_settings.dart`: `4c89bcb3c04142ce49440a11b92054365c26f7a6`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `44030753bf6a27ac0e9630f2d0f7ca0cc8e3bd0b`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt`: `e44fac7cec76979ef47a256a3e1d416d09ef7e22`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`: `a139dfefe1121963c3a26b114b9b0fcc9f8fa16a`.
  - `android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl`: `5bd6c269212e523b190f7164e0ad1d257ed5e6a5`.
  - `test/widget_test.dart`: `d8e89083cbc6674962a5f9e013579477783243ad`.
  - `test/floating_monitor_layout_contract_test.dart`: `7f861d449e518af68fc4ece7278241aa3ce8691b`.
  - `test/shizuku_fps_contract_test.dart`: `5a9efb60b02c1cfabf44a35434f67fb555419c92`.
  - Workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `585d190324e522fc08e66cc95bd7ee80c5f37664`.
- Current docs immediately before this transfer-file replacement: `APP_BUILD_REPORT.md` `607cd3e3b1a5f919f283ed811ddb7336f8cb4910`; `PROJECT_STATE.md` `51442a04a640e3d26637e62e9fd5a4229da4d47c`; `MEMORY_INDEX.md` `6c7b26e2a7d644cea5de1da3541e4233ac720772`; `BUILD_NOTES.md` `b1da762bec97f4bec168bf55f4f106d4ce50ab0c`; `HANDOVER.md` `18e2a79206158724d39a79e3bc688c0df915a53c`; `APP_NOTES.md` `79894714cf8f5fb9cf0dc808d4ebe8f8b7f1265f`. This file is updated last; re-fetch its new blob/main HEAD after this commit rather than attempting self-reference.
- Build #58 passed the complete configured App tests and release workflow; history for all earlier attempts, warnings and exact artifacts is kept in `APP_BUILD_REPORT.md`.

## 4. Current Home indicator and animation contracts

- Disconnected telemetry remains unknown (`--`) and must not turn indicator/icon text black or generic grey. Keep each metric's lowest semantic accent as the fallback; do not imply that physical outputs are ON/OFF from an accent color.
- Battery temperature: Ice Blue at or below 30°C; smooth cyan/amber/orange transition through the 30–40°C band; Burning Red at or above 40°C. Battery thermal fill maps to 30–40°C. Battery warning/fire threshold remains exactly 40°C.
- Hotside temperature: Ice Blue at or below 30°C; smooth transition above 30°C; Burning Red at the currently configured Hotside Limit. Visual color never changes or replaces Firmware thermal protection.
- Manual voltage text/accent is 5V red, 9V green, 12V blue. Unknown/disconnected voltage falls back to the 5V red accent.
- The current source restores Build #54 `_JexIconPainter` drawing geometry and blends active effects with the current activity controller. Existing Fan phase/coast behavior and Peltier retargeting are retained. The source has not been rendered on-device, so smoothness is not yet device-verified. These are UI illustrations, not live RPM/ice measurements.
- Build #58 compiled this source and passed all 87 Flutter tests plus release checks. Phone-side rendering, animations and transition smoothness remain NOT DEVICE-VERIFIED; do not claim visual behavior was inspected on the phone.

## 5. Floating Monitor presentation and screen FPS

- Metrics remain F/B/H/V/A/P/S. Display Style was removed; the only style is Letters and persisted legacy Icons values normalize to Letters.
- Size is 0.30×–1.00× inclusive in 0.05× increments (14 intervals), default 0.60×. Slider, storage normalization, Flutter/native runtime size reconciliation, pinch scaling and native overlay bounds must agree.
- Opacity is 0–100% in 5% increments; show its current numeric value but no 50% midpoint label. Legacy persisted opacity values snap to the nearest 5%. Opacity changes the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical Letters rows share the same left edge. The overlay remains freely draggable; WindowManager gravity is TOP | START and saved coordinates remain intact.
- Shizuku card is compact: status `Shizuku Access Granted` or `Shizuku Access Denied`, and only `Grant Shizuku Access` and `Check Access`. No long help paragraphs or `Open Shizuku` button.
- FPS is intended to be **foreground screen FPS, not game-only FPS**. The native sampler now prefers the focused window identity and attempts to match that package against SurfaceFlinger timestamp layers, including JE Cooler, apps, launcher, Settings and Android system UI if the OEM exposes matching layers. It attempts a compositor-layer FPS estimate from SurfaceFlinger frame counters, not display refresh rate or Flutter frame timing; counter semantics and layer availability are Android/OEM-dependent. Zero is allowed only for a valid interval on the same layer after a previously positive sample in the current tracking session. First, missing, reset, out-of-range or invalid samples use --.
- FPS source implementation remains **NOT DEVICE-VERIFIED** despite Build #58 passing CI. Shizuku permission granted does not prove the UserService binds successfully or that a particular Android/OEM exposes SurfaceFlinger layer statistics. After installing/testing Build #58, switch the overlay across JE Cooler, Settings/launcher, apps and an actual game; capture native `fps_monitor_status` and logs if data remains unavailable. Do not infer device behavior from source-contract checks alone.

## 6. Firmware/hardware baseline and protections — unchanged here

- Active editable sketch: `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION="V6.6"`. User treats V6.6 as final and reported compiling it and two successful same-version online OTA updates; reports are user-reported, not independently verified here.
- ESP32-C3 Super Mini, one radio path for Wi-Fi/BLE. Pins: GPIO0 NTC ADC; GPIO1 TTP223 touch; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. NTC 10k + 10k divider, Beta 3950, 3.3V assumption and exactly one calibrated millivolt sample per second.
- Hotside limit range 40–50°C, default 45°C; manual restart re-arm requires Hotside ≤ hotLimit−1°C for five continuous seconds. Adaptive stages at 12/9/5V use 30s safety timing, Fan 100%, Peltier OFF; upward recovery is one rail at a time after 60s stable within saved ceiling. Peltier PWM 20kHz/8-bit with 5s soft start; Fan PWM 25kHz/8-bit. Rail handoff break-before-make 200ms and 1s settle. Verify live Firmware source before hardware changes.
- LED defaults 5V red, 9V green, 12V blue; customizable/resettable. Supported modes: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7; mode 3/Mirror Pulse is retired.
- Firmware protections / OTA are outside the authorized scope here. No Firmware source, BIN artifact, Firebase metadata, OTA, flash or physical device was changed during this App source/UI task.

## 7. Current repair scope and unverified points

- `lib/main.dart`: Build #54 `_JexIconPainter` drawing geometry restored; current activity controller provides an interpolated strength parameter. The existing fan phase/coast and Peltier retarget controllers were retained rather than blindly rewritten.
- `lib/floating_monitor.dart`: Shizuku-unavailable state no longer destructively removes persisted metric `F`; sampler refresh is requested when returning to the app if the enabled overlay still has `F` selected.
- Native FPS: fixed UserService operation `dumpsys window displays` is whitelisted; `dumpsys activity activities` remains the fallback. First/invalid/reset/out-of-range samples should render `--`; zero is only accepted for the same previously-positive layer in a valid interval.
- Added source-contract assertions for restored drawing primitives, F selection persistence, WindowManager operation and sample-state handling. Those tests were **not run**.
- Open verification: inspect visual output on device; run Dart/Flutter/Kotlin validation; test Shizuku bind/command output, foreground package and SurfaceFlinger layer matching on the actual Android/OEM version. Current static source checks cannot prove physical FPS.

## 7. Authorization protocol and next validation

- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- **Build #58 is the latest successful release and includes the current source/test checkpoint.** No new build is pending from this task. The next immediate validation is on-device: examine restored icon geometry/transitions and Floating Monitor behavior, then switch FPS sampling across JE Cooler, Settings/launcher, another app and an actual game. If F remains `--`, collect `fps_monitor_status` and focused-window/layer diagnostics. CI success is not a substitute for device evidence.
