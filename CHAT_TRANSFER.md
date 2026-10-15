# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot checked against live GitHub main on 2026-10-16 (Asia/Jakarta), after successful Build #60 and current-note reconciliation. Read this file first in a new context, then fetch live repository state again. Build #60 verifies the post-Build #58 FPS diagnostics and test-contract correction (88/88 Flutter tests plus full release checks); physical-device FPS/rendering remains unverified. `PROJECT_STATE.md` is current-only; `APP_NOTES.md` carries detailed App contracts; `APP_BUILD_REPORT.md` is the authoritative attempt/build evidence ledger; `CHANGELOG.md` is historical.

## 1. Repository identity and current Git checkpoint

- Canonical App source/memory repository: [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App), branch `main`.
- Main HEAD immediately before this final transfer-file replacement: `971d7c138003845506528a242d9982e3282501e6` (last current-note update before replacing this file).
- Latest verified build/release is Build #60 / run `38817543342`, exact release source `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`. It passed App audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK build, V1/V2/V3 signing/certificate, source ZIP, publication and downloaded-asset verification. Trigger was owner-authored [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33).
- FPS diagnostics patch `6e9b4c73db12c51f4452717d8cf102f49d325dcf` and test-contract fix `7a576e60f0938cec94fcddb96340cd5376fa15de` are included in Build #60. Build #59 had one stale source-contract assertion fail; the assertion was corrected without deleting tests or relaxing gates, then the full Build #60 pipeline passed.
- Exact artifact repository: [TenzoNkz/JEXFYZ-Firmware](https://github.com/TenzoNkz/JEXFYZ-Firmware). Its live main tree was rechecked and contains exactly one entry: `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, `1,455,936` bytes. Keep this repo BIN-only; source notes/memory belong in the App repo. Source-to-BIN provenance is not independently verified.
- No new branches or PRs were created for this build. All repairs/documentation edits were committed directly to `main`.

## 2. App identity, workflow, latest release versus current source

- App name `JE Cooler`, in-app brand `JE X FYZ`; package `com.horizontalzzz.jexfyz`; pubspec version `1.0.0+3`. Preserve Android Gradle `versionName "Telegram @horizontalzzz"` exactly.
- Only active build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. It runs only through the owner/title/body-token guarded issue-open/reopen trigger. Exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`; body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal pushes/PRs do not build.
- Latest verified release is [Build #60 / Actions run `38817543342`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38817543342), source/release commit `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`. Audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK build, V1/V2/V3 signature/certificate checks, source ZIP and downloaded asset verification all passed.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly two verified Build #60 assets: APK asset `645381550` (`54,636,716` bytes, SHA-256 `47892215de179c8cb2975ad5c99b8b3b1398559873352411ed74d001aa001274`) and corresponding source ZIP asset `645381553` (`2,866,092` bytes, SHA-256 `dd9bdc1f8082c70ab2ff73892f5434057d36cedc870fd92184b8ed579e2b538a`). Release target and embedded source archive marker both match `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`.
- Build #59 / run `38817257209` failed only because one `test/widget_test.dart` source-contract assertion expected removed `lastPositiveSample`/`verifiedZero` variables (87 passed, 1 failed) after audit/dependencies/analyzer passed. Test-only commit `7a576e60f0938cec94fcddb96340cd5376fa15de` corrected that assertion against current `validZero` and the full WindowManager fallback. Build #60 then passed the full suite/release; no test or gate was removed/weakened.
- Physical-device screen FPS and overlay behavior remain **NOT DEVICE-VERIFIED** despite the successful release.

## 3. Current source fingerprints

- Build #60 exact source/release commit: `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`. Main HEAD immediately before this transfer-file replacement: `971d7c138003845506528a242d9982e3282501e6`. Documentation-only commits after the release keep release provenance fixed at the Build #60 source SHA.
- Current implementation and test blobs:
  - `lib/main.dart`: `d24885cf0a40472b9fb23ee6ce73ad772ae73672`.
  - `lib/floating_monitor.dart`: `d43bd17a7adebf7c9f95fc5fdf921ba2a22a231b`.
  - `lib/app_settings.dart`: `4c89bcb3c04142ce49440a11b92054365c26f7a6`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `c7ca3e75c28b53ea8cda207836befbe04a2e5a6f`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt`: `9f70d480bd31a4875653add70804ab50fc15b747`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`: `a139dfefe1121963c3a26b114b9b0fcc9f8fa16a`.
  - `android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl`: `5bd6c269212e523b190f7164e0ad1d257ed5e6a5`.
  - `test/widget_test.dart`: `f8a8ff0f5f6527a0a6f6e2c453fe5c0836437785`.
  - `test/floating_monitor_layout_contract_test.dart`: `7f861d449e518af68fc4ece7278241aa3ce8691b`.
  - `test/shizuku_fps_contract_test.dart`: `93aca6d5f5ad6c3c4723b2545eaf997cf8ee996f`.
  - Workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `585d190324e522fc08e66cc95bd7ee80c5f37664`.
- Current docs immediately before this transfer-file replacement: `APP_BUILD_REPORT.md` `a5025958e5f45be09ee403f5e7d525fb6e3432a3`; `PROJECT_STATE.md` `e10fa8f36fc4c325252a213d2a99ec299690c826`; `MEMORY_INDEX.md` `87775765e6a66e344e6306a9fd1f6cc7df9f1b9d`; `BUILD_NOTES.md` `44f3c4e657ed5fabb4a8a20679ce8fb0b9e917f7`; `HANDOVER.md` `95808827b47f80fab1388794021e8500ae6e72af`; `APP_NOTES.md` `ad78a28e3b06fc53e09d786a3787b6f90a034bc4`; `CHANGELOG.md` `88319c2eac5817ba7031441a63c0e467db0fe284`; `README.md` `0b8f92660fc5a85f06401d065db0648ba69d24c2`; `CHAT_RULES.md` `43b28863666f2c437012d5cb8df112e179358217`. This file is updated last; re-fetch its new blob/main HEAD after this commit rather than attempting self-reference.
- Build #60 passed the full configured App tests/release workflow; attempt details, signatures, hashes, warnings and Build #59 repair evidence are kept in `APP_BUILD_REPORT.md`.

## 4. Current Home indicator and animation contracts

- Disconnected telemetry remains unknown (`--`) and must not turn indicator/icon text black or generic grey. Keep each metric's lowest semantic accent as the fallback; do not imply that physical outputs are ON/OFF from an accent color.
- Battery temperature: Ice Blue at or below 30°C; smooth cyan/amber/orange transition through the 30–40°C band; Burning Red at or above 40°C. Battery thermal fill maps to 30–40°C. Battery warning/fire threshold remains exactly 40°C.
- Hotside temperature: Ice Blue at or below 30°C; smooth transition above 30°C; Burning Red at the currently configured Hotside Limit. Visual color never changes or replaces Firmware thermal protection.
- Manual voltage text/accent is 5V red, 9V green, 12V blue. Unknown/disconnected voltage falls back to the 5V red accent.
- The current source restores Build #54 `_JexIconPainter` drawing geometry and blends active effects with the current activity controller. Existing Fan phase/coast behavior and Peltier retargeting are retained. The source has not been rendered on-device, so smoothness is not yet device-verified. These are UI illustrations, not live RPM/ice measurements.
- Build #60 compiled this source and passed all 88 Flutter tests plus release checks. Phone-side rendering, animations and transition smoothness remain NOT DEVICE-VERIFIED; do not claim visual behavior was inspected on the phone.

## 5. Floating Monitor presentation and screen FPS

- Metrics remain F/B/H/V/A/P/S. Display Style was removed; the only style is Letters and persisted legacy Icons values normalize to Letters.
- Size is 0.30×–1.00× inclusive in 0.05× increments (14 intervals), default 0.60×. Slider, storage normalization, Flutter/native runtime size reconciliation, pinch scaling and native overlay bounds must agree.
- Opacity is 0–100% in 5% increments; show its current numeric value but no 50% midpoint label. Legacy persisted opacity values snap to the nearest 5%. Opacity changes the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical Letters rows share the same left edge. The overlay remains freely draggable; WindowManager gravity is TOP | START and saved coordinates remain intact.
- Shizuku card is compact: status `Shizuku Access Granted` or `Shizuku Access Denied`, and only `Grant Shizuku Access` and `Check Access`. No long help paragraphs or `Open Shizuku` button.
- FPS is intended to be **foreground screen FPS, not game-only FPS**. The native sampler uses focused-window identity and tries `dumpsys window displays`, full `dumpsys window`, then ActivityManager fallback before matching the foreground package to SurfaceFlinger layers. It estimates compositor-layer FPS from counter deltas, not display refresh rate or Flutter frame timing; exact semantics/layer availability are Android/OEM-dependent. A valid `0 FPS` is displayed after two matching layer snapshots over a valid interval with zero delta, even if the layer has not previously produced a positive sample. First snapshots, missing layers, counter resets, invalid intervals and command/service failures are not represented as zero. The post-release source changes implementing this have not been built/tested yet.
- FPS source implementation is built/CI-tested by Build #60 but remains **NOT DEVICE-VERIFIED**. Shizuku permission granted does not prove the UserService binds successfully or that a particular Android/OEM exposes SurfaceFlinger layer statistics. After installing/testing Build #60, switch the overlay across JE Cooler, Settings/launcher, apps and an actual game; capture native `fps_monitor_status` and logs if data remains unavailable. Do not infer device behavior from source-contract checks alone.

## 6. Firmware/hardware baseline and protections — unchanged here

- Active editable sketch: `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION="V6.6"`. User treats V6.6 as final and reported compiling it and two successful same-version online OTA updates; reports are user-reported, not independently verified here.
- ESP32-C3 Super Mini, one radio path for Wi-Fi/BLE. Pins: GPIO0 NTC ADC; GPIO1 TTP223 touch; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. NTC 10k + 10k divider, Beta 3950, 3.3V assumption and exactly one calibrated millivolt sample per second.
- Hotside limit range 40–50°C, default 45°C; manual restart re-arm requires Hotside ≤ hotLimit−1°C for five continuous seconds. Adaptive stages at 12/9/5V use 30s safety timing, Fan 100%, Peltier OFF; upward recovery is one rail at a time after 60s stable within saved ceiling. Peltier PWM 20kHz/8-bit with 5s soft start; Fan PWM 25kHz/8-bit. Rail handoff break-before-make 200ms and 1s settle. Verify live Firmware source before hardware changes.
- LED defaults 5V red, 9V green, 12V blue; customizable/resettable. Supported modes: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7; mode 3/Mirror Pulse is retired.
- Firmware protections / OTA are outside the authorized scope here. No Firmware source, BIN artifact, Firebase metadata, OTA, flash or physical device was changed during this App source/UI task.

## 7. Current repair scope and unverified points

- `lib/main.dart`: Build #54 `_JexIconPainter` geometry is restored with eased active-effect interpolation; Build #60 compiled the source, but phone animation quality remains unverified.
- `lib/floating_monitor.dart`: preserves metric `F` while Shizuku is unavailable, refreshes sampler status on resume, displays native diagnostic state, and waits for startup status to resolve.
- Native FPS implementation now tries `dumpsys window displays`, then full `dumpsys window`, then ActivityManager fallback. Valid zero requires two matched layer snapshots over a valid interval. Reset/invalid counters remain diagnostically distinct; retry cancels stale scheduled polling tasks.
- New FPS source-contract assertions check the fallback, status feedback, valid-zero behavior and retry lifecycle. Build #60 ran all tests and passed 88/88.
- Open verification: install Build #60 and inspect the diagnostic status plus `F:` across JE Cooler, Settings/launcher, another app and a real game. If FPS remains unavailable, capture `fps_monitor_status` plus native logs before proposing another source patch. CI does not prove physical FPS or visual smoothness.

## 7. Authorization protocol and next validation

- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- **Build #60 is the latest successful release and includes diagnostic checkpoint `6e9b4c73db12c51f4452717d8cf102f49d325dcf`.** There is no additional App build pending from this task. The next verification is on-device: install the Build #60 APK, capture Settings sampler status plus `F:` while switching between JE Cooler, Settings/launcher, another app and a real game. If FPS remains unavailable, use the native status and logs to separate foreground detection, layer matching, service/command failure, invalid samples and a genuine zero-frame interval. CI success is not a substitute for device evidence.
