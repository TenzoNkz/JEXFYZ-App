# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot checked against live GitHub main on 2026-10-16 (Asia/Jakarta), after Build #62 and full project-document reconciliation. Build #62 is the latest verified release (88/88 tests, APK obfuscation, V1/V2/V3 signing, certificate, source archive and downloaded release assets all verified). The Shizuku UserService lifecycle patch is now included in the APK; physical-device FPS, service binding and overlay rendering remain unverified. `PROJECT_STATE.md` is current-only; `APP_NOTES.md` carries detailed App contracts; `APP_BUILD_REPORT.md` is the authoritative attempt/build evidence ledger; `CHANGELOG.md` is historical.

## 1. Repository identity and current Git checkpoint

- Canonical App source/memory repository: [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App), branch `main`.
- Main HEAD immediately before this final transfer-file replacement: `c2a0dfda9b7624dbba7ac8c93f862fee2dd6074d` (handover documentation reconciliation following Build #62).
- Latest verified release is Build #62 / run `38841458441`, exact release/source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. It passed App audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK build, V1/V2/V3 signing/certificate checks, matching source ZIP, publication and downloaded-asset verification. Trigger used the owner/title/token guarded [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33), via the configured issue-reopen event.
- Build #61 / run `38841172623` failed at Flutter tests with 87 passed / 1 failed after audit, dependency resolution and Dart analysis passed. The single stale widget assertion expected an old shared binding call / fallback parser. Test-only correction in commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4` aligned it with attempt-scoped binding and current WindowManager diagnostic behavior; Build #62 then passed the full suite and release pipeline. No test/gate was deleted or weakened.
- FPS diagnostic source `6e9b4c73db12c51f4452717d8cf102f49d325dcf`, earlier contract correction `7a576e60f0938cec94fcddb96340cd5376fa15de`, and Shizuku UserService lifecycle patch `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` are included in the verified Build #62 source.
- Dedicated firmware artifact repository: [TenzoNkz/JEXFYZ-Firmware](https://github.com/TenzoNkz/JEXFYZ-Firmware). Last verified tree has exactly one file, `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, `1,455,936` bytes. Keep it BIN-only; this does not prove source-to-BIN provenance.
- Live branch/PR check at reconciliation: five branches; zero open PRs. Build #61/#62 and documentation commits were made directly on `main`, with no branch/PR created for this workflow.

## 2. App identity, workflow, latest release versus current source

- App name `JE Cooler`, in-app brand `JE X FYZ`; package `com.horizontalzzz.jexfyz`; pubspec version `1.0.0+3`. Preserve Android Gradle `versionName "Telegram @horizontalzzz"` exactly.
- Only active build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. It is issue-open/reopen only, guarded by repository owner, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal push/PR does not build.
- Latest verified run [Build #62 / Actions `38841458441`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441) targets `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. All 20 active workflow steps passed, including audit, dependencies, Dart analysis, **88/88 tests**, APK build, V1/V2/V3/certificate validation, source archive, Release publication and re-downloaded asset hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has exactly two verified assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `645909183`, `54,636,716` bytes, SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `645909184`, `2,871,177` bytes, SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`.
- Release target, embedded source marker and the downloaded asset checks match source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. Built and downloaded APKs both passed V1/JAR, V2 and V3 verification with one signer; expected certificate SHA-256 is `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- Non-blocking warnings: 23 Dart deprecation infos; Gradle `9.3.1` is out of date; native ELF DWARF debug information is not obfuscated; self-signed/no-timestamp JAR and META-INF coverage warnings; pub-cache save denied due to token scope. None failed a required gate.
- Physical FPS, real Shizuku runtime binding, OEM SurfaceFlinger layer visibility and device rendering remain unverified; CI must not be treated as device proof.

## 3. Current source fingerprints

- Release source commit: `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. Current `main` after the documentation commits remains source-equivalent; the next commit is this transfer-snapshot replacement.
- Current implementation/test blobs:
  - `lib/main.dart`: `d24885cf0a40472b9fb23ee6ce73ad772ae73672`.
  - `lib/floating_monitor.dart`: `bae089f1f950bd70fe7e6f90e8afa1726293664f`.
  - `lib/app_settings.dart`: `4c89bcb3c04142ce49440a11b92054365c26f7a6`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `d6f3231fecbc4c8669dedeae5d1484d2cdb6a415`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt`: `5c4e04e87897ea2f9432809c3be4d29bff378315`.
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`: `a139dfefe1121963c3a26b114b9b0fcc9f8fa16a`.
  - `android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl`: `5bd6c269212e523b190f7164e0ad1d257ed5e6a5`.
  - `test/widget_test.dart`: `eb5b0b9b820ca48a8df47bf74ec64992cbd08232`.
  - `test/floating_monitor_layout_contract_test.dart`: `7f861d449e518af68fc4ece7278241aa3ce8691b`.
  - `test/shizuku_fps_contract_test.dart`: `5996eb0d899bf9abf8eae68f554a7a409faa00f1`.
  - Workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `585d190324e522fc08e66cc95bd7ee80c5f37664`.
- Canonical docs immediately before this transfer-file replacement:
  - `APP_BUILD_REPORT.md`: `b94b35a227472be09201f5979a223f8e7935b204`.
  - `PROJECT_STATE.md`: `c5abc48b0da2548236045129f7a3e74591a74318`.
  - `MEMORY_INDEX.md`: `10b6811e9901e2ad43fb168465bf18548b06db6d`.
  - `BUILD_NOTES.md`: `e22f88d76deeb3474aea388c9d8de2a8a019adee`.
  - `HANDOVER.md`: `8ce81fea4ed929e62d098d114f6c030cd9b03ece`.
  - `APP_NOTES.md`: `4a562e6c04825d3e7ca27945d9fa95c6a70af8cc`.
  - `CHANGELOG.md`: `03f521d6c081f3b42b312e2ddfbbdb7b51b03f63`.
  - `README.md`: `5df216c3e93d1625c7dbfe2d3aa820aac5e8a0c6`.
  - `CHAT_RULES.md`: `0cb25fb86a11d52d354c1d4e0706553f0be17211`.
- Build #62 analyzed and tested current App source and produced the APK/source archive above. Full run evidence, Build #61 failure and the narrow test-only repair are in `APP_BUILD_REPORT.md`.

## 4. Current Home indicator and animation contracts

- Disconnected telemetry remains unknown (`--`) and must not turn indicator/icon text black or generic grey. Keep each metric's lowest semantic accent as the fallback; do not imply that physical outputs are ON/OFF from an accent color.
- Battery temperature: Ice Blue at or below 30°C; smooth cyan/amber/orange transition through the 30–40°C band; Burning Red at or above 40°C. Battery thermal fill maps to 30–40°C. Battery warning/fire threshold remains exactly 40°C.
- Hotside temperature: Ice Blue at or below 30°C; smooth transition above 30°C; Burning Red at the currently configured Hotside Limit. Visual color never changes or replaces Firmware thermal protection.
- Manual voltage text/accent is 5V red, 9V green, 12V blue. Unknown/disconnected voltage falls back to the 5V red accent.
- The current source restores Build #54 `_JexIconPainter` drawing geometry and blends active effects with the current activity controller. Existing Fan phase/coast behavior and Peltier retargeting are retained. The source has not been rendered on-device, so smoothness is not yet device-verified. These are UI illustrations, not live RPM/ice measurements.
- Build #62 compiled this source and passed all 88 Flutter tests plus release checks. Phone-side rendering, animations and transition smoothness remain NOT DEVICE-VERIFIED; do not claim visual behavior was inspected on the phone.

## 5. Floating Monitor presentation and screen FPS

- Metrics remain F/B/H/V/A/P/S. Display Style was removed; the only style is Letters and persisted legacy Icons values normalize to Letters.
- Size is 0.30×–1.00× inclusive in 0.05× increments (14 intervals), default 0.60×. Slider, storage normalization, Flutter/native runtime size reconciliation, pinch scaling and native overlay bounds must agree.
- Opacity is 0–100% in 5% increments; show its current numeric value but no 50% midpoint label. Legacy persisted opacity values snap to the nearest 5%. Opacity changes the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical Letters rows share the same left edge. The overlay remains freely draggable; WindowManager gravity is TOP | START and saved coordinates remain intact.
- Shizuku card is compact: status `Shizuku Access Granted` or `Shizuku Access Denied`, and only `Grant Shizuku Access` and `Check Access`. No long help paragraphs or `Open Shizuku` button.
- FPS is intended to be **foreground screen FPS, not game-only FPS**. The native sampler uses focused-window identity and tries `dumpsys window displays`, full `dumpsys window`, then ActivityManager fallback before matching the foreground package to SurfaceFlinger layers. It estimates compositor-layer FPS from counter deltas, not display refresh rate or Flutter frame timing; exact semantics/layer availability are Android/OEM-dependent. A valid `0 FPS` is displayed after two matching layer snapshots over a valid interval with zero delta. First snapshots, missing layers, counter resets, invalid intervals and command/service failures are not represented as zero. These diagnostics and the binding lifecycle repair are built in Build #62.
- Binding lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` adds per-attempt UserService binding identities/tags, asynchronous latch wait, late-callback rejection, typed bind/timeout/dead-Binder/remote-call failures, bounded native diagnostics and cleanup guarded by the availability of an existing connected Binder. Dart analysis, 88/88 Flutter tests, Android release compilation/signing and asset re-download checks all passed under Build #62.
- FPS and the binding lifecycle patch are built/CI-tested by Build #62 but remain **NOT DEVICE-VERIFIED**. Shizuku permission granted does not prove the UserService binds successfully or that a particular Android/OEM exposes SurfaceFlinger layer statistics. Install Build #62 and switch the overlay across JE Cooler, Settings/launcher, other apps and an actual game; capture native `fps_monitor_status` and filtered `JexFpsDiag` logs if data remains unavailable. Do not infer device behavior from source-contract checks alone.

## 6. Firmware/hardware baseline and protections — unchanged here

- Active editable sketch: `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION="V6.6"`. User treats V6.6 as final and reported compiling it and two successful same-version online OTA updates; reports are user-reported, not independently verified here.
- ESP32-C3 Super Mini, one radio path for Wi-Fi/BLE. Pins: GPIO0 NTC ADC; GPIO1 TTP223 touch; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. NTC 10k + 10k divider, Beta 3950, 3.3V assumption and exactly one calibrated millivolt sample per second.
- Hotside limit range 40–50°C, default 45°C; manual restart re-arm requires Hotside ≤ hotLimit−1°C for five continuous seconds. Adaptive stages at 12/9/5V use 30s safety timing, Fan 100%, Peltier OFF; upward recovery is one rail at a time after 60s stable within saved ceiling. Peltier PWM 20kHz/8-bit with 5s soft start; Fan PWM 25kHz/8-bit. Rail handoff break-before-make 200ms and 1s settle. Verify live Firmware source before hardware changes.
- LED defaults 5V red, 9V green, 12V blue; customizable/resettable. Supported modes: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7; mode 3/Mirror Pulse is retired.
- Firmware protections / OTA are outside the authorized scope here. No Firmware source, BIN artifact, Firebase metadata, OTA, flash or physical device was changed during this App source/UI task.

## 7. Current repair scope and unverified points

- `lib/main.dart`: Build #54 `_JexIconPainter` geometry is restored with eased active-effect interpolation; Build #62 compiled the source, but phone animation quality remains unverified.
- `lib/floating_monitor.dart`: preserves metric `F` while Shizuku is unavailable, refreshes sampler status on resume, displays native diagnostic state, waits for startup status to resolve, and labels binding exception/timeout/dead-Binder/remote-call errors separately.
- Native UserService binding now uses an attempt-scoped `UserServiceArgs` tag, `ServiceConnection`, generation and `CountDownLatch`. Late callbacks are rejected/cleaned using only their attempt's tag, with explicit bind failure/timeout/disconnect/cancellation states. Logs record bind lifecycle and command results without dumping full command output.
- Native foreground/layer/sample logs include the detection source, foreground package, candidate/matched layer counts, chosen layer, delta, interval, FPS and status. Stop cleanup only attempts `--disable` when an existing connected/alive UserService remains, preventing an immediate rebind after a Binder failure.
- Source/test checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` and the widget contract repair are included in Build #62 (88/88 tests, complete Android release gates). Only physical-device FPS/service/overlay behavior remains unverified.

## 7. Authorization protocol and next validation

- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- **Build #62 is the latest successful release and includes binding checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae`.** The next action is physical-device validation: install [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), capture the Settings sampler status plus `F:` while foreground changes across apps and a real game, and include filtered `JexFpsDiag` logs if it remains `--`. CI success is not a substitute for device evidence.
