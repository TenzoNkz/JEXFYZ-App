# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot checked against live GitHub main on 2026-10-16 at 10:31 Asia/Jakarta, after Build #62 and the Chat Stuck full-memory audit. Build #62 remains the latest verified App release; its 88/88 Flutter tests, APK obfuscation/signing, certificate, source ZIP, publication and downloaded-asset checks are verified. Current main after the release source contains documentation/memory-only commits. The Shizuku UserService lifecycle patch is in Build #62, but actual binding, foreground layer availability, FPS and phone-side rendering remain UNVERIFIED. `PROJECT_STATE.md` is current-only; `APP_NOTES.md` owns detailed App behavior; `APP_BUILD_REPORT.md` is the authoritative build-attempt ledger; `CHANGELOG.md` is history only.

## 1. Repository identity and current Git checkpoint

- Canonical App source/memory repository: [TenzoNkz/JEXFYZ-App](https://github.com/TenzoNkz/JEXFYZ-App), branch `main`.
- Main HEAD immediately before this final transfer-file replacement: `dc9bb08334d1443abc30c6f43d5e50948be821b9`; tree `3d32b9efc9684e41f21dd59965145f630606a664`. Full recursive tree is NOT TRUNCATED: 80 entries, 55 blobs and 25 trees (21 Markdown files). This transfer snapshot is the last file to be written in this reconciliation.
- Latest verified release is Build #62 / run `38841458441`, exact release/source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. It passed App audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK build, V1/V2/V3 signing/certificate checks, matching source ZIP, publication and downloaded-asset verification. Trigger used the owner/title/token guarded [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33), via the configured issue-reopen event.
- Build #61 / run `38841172623` failed at Flutter tests with 87 passed / 1 failed after audit, dependency resolution and Dart analysis passed. The single stale widget assertion expected an old shared binding call / fallback parser. Test-only correction in commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4` aligned it with attempt-scoped binding and current WindowManager diagnostic behavior; Build #62 then passed the full suite and release pipeline. No test/gate was deleted or weakened.
- FPS diagnostic source `6e9b4c73db12c51f4452717d8cf102f49d325dcf`, earlier contract correction `7a576e60f0938cec94fcddb96340cd5376fa15de`, and Shizuku UserService lifecycle patch `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` are included in the verified Build #62 source.
- Dedicated firmware artifact repository: [TenzoNkz/JEXFYZ-Firmware](https://github.com/TenzoNkz/JEXFYZ-Firmware). Last verified tree has exactly one file, `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, `1,455,936` bytes. Keep it BIN-only; this does not prove source-to-BIN provenance.
- Live branch/PR check: five branches and zero open PRs. Other branch tips are `diag/latest-stable-v16`=`ec77759d224c581870d98330d9278896ff29e50b`, `diagnostic/v1.6-heap-check`=`1a4cd83b3ee82cdc2d86277dc4a0eb4c4238f8a3`, `fix/adaptive-power-sequencing`=`33740be782d976a881e285bbf8b86b3b485b83c1`, and `tmp-jexfyz-v5-test`=`b388cba98ea1d9e92873df64ba3224d6cb99156d`. No PRs are open. This recovery/reconciliation used direct commits to `main`; no branch/PR was created.

## 2. App identity, workflow, latest release versus current source

- App name `JE Cooler`, in-app brand/header `JE X FYZ`; Android package/applicationId `com.horizontalzzz.jexfyz`; pubspec package `jexfyz_cooler`, version `1.0.0+3`, `minSdk=24`. Preserve Android Gradle `versionName "Telegram @horizontalzzz"` exactly. Build toolchain: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1 (out-of-date notice is non-blocking in Build #62).
- Only active build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. It is issue-open/reopen only, guarded by repository owner, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal push/PR does not build.
- Latest verified run [Build #62 / Actions `38841458441`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441) targets `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. All 20 active workflow steps passed, including audit, dependencies, Dart analysis, **88/88 tests**, APK build, V1/V2/V3/certificate validation, source archive, Release publication and re-downloaded asset hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has exactly two verified assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `645909183`, `54,636,716` bytes, SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `645909184`, `2,871,177` bytes, SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`.
- Release target, embedded source marker and the downloaded asset checks match source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. Built and downloaded APKs both passed V1/JAR, V2 and V3 verification with one signer; expected certificate SHA-256 is `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- Non-blocking warnings: 23 Dart deprecation infos; Gradle `9.3.1` is out of date; native ELF DWARF debug information is not obfuscated; self-signed/no-timestamp JAR and META-INF coverage warnings; pub-cache save denied due to token scope. None failed a required gate.
- Physical FPS, real Shizuku runtime binding, OEM SurfaceFlinger layer visibility and device rendering remain unverified; CI must not be treated as device proof.

## 3. Current source fingerprints

- Release/source target is `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. Current `main` through `dc9bb08334d1443abc30c6f43d5e50948be821b9` remains source-, test-, workflow- and config-equivalent to that release source; commits after the release target are documentation/memory-only. This transfer snapshot is updated last.
- Current implementation/test/config blobs (current main source equals the verified Build #62 source):
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
  - `test/v6_6_qc_contract_test.dart`: `2bee4d960d014f0765422dcb5ed1c9870ba6ee3a`.
  - `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`.
  - `test/firmware_touch_adaptive_sync_test.dart`: `2d3fea509343a03b8d23623f4dcb2dd7fd972d39`.
  - `pubspec.yaml`: `8f558273e21692af9958f914527fdc62d623d63a`; `pubspec.lock`: `1e92812bfda2c28244a0556d71d1ec94084acc66`.
  - `android/app/build.gradle`: `cc35d2d3dbe603e7b5a7157d37dde222d646ea42`; `android/build.gradle`: `d6dbd400ba0baf2b33c14bb514745334a1e2ad33`; `android/settings.gradle`: `14545695cc9aba5912393ec293c284ee60d9ec10`; `android/gradle.properties`: `13564f62c79279ecfd4fe0a8a247a4d2a4b11451`.
  - `android/app/src/main/AndroidManifest.xml`: `393c9f9bfe02b9d71b2e3445ce873d5d16912ce1`; `android/app/proguard-rules.pro`: `65cba53a2e76e2735e9e9ae79a91d50c89752c44`.
  - Workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `585d190324e522fc08e66cc95bd7ee80c5f37664`.
- Canonical documentation blobs immediately before this final transfer replacement (live at parent HEAD `dc9bb08334d1443abc30c6f43d5e50948be821b9`):
  - `README.md`: `8b843124effded03db5eecaeba7d371b2e93edc0`.
  - `CHAT_RULES.md`: `0cb25fb86a11d52d354c1d4e0706553f0be17211`.
  - `PROJECT_STATE.md`: `3c8f51cd948c0d9f0ca711ab127a48f8d76eb5c6`.
  - `HANDOVER.md`: `1f1d1aa9e5d10859e8e6bf6fdbae7c34b463f058`.
  - `APP_NOTES.md`: `4a562e6c04825d3e7ca27945d9fa95c6a70af8cc`.
  - `MEMORY_INDEX.md`: `a4c81c0b0039438df9cf61b7c358019a4e69500d`.
  - `APP_BUILD_REPORT.md`: `b94b35a227472be09201f5979a223f8e7935b204`.
  - `BUILD_NOTES.md`: `e22f88d76deeb3474aea388c9d8de2a8a019adee`.
  - `CHANGELOG.md`: `280a5df3541116df7d5c74d3628a9f45db5c98d0`.
  - `CHAT_TRANSFER_PROMPTS.md`: `ccb473293fefd6d166f79b634724235ea6615f1a`.
  - `DESIGN_NOTES.md`: `e04382659dfdd618de0a156046f140452d275dc7`.
  - `FIRMWARE_NOTES.md`: `3d98e29e1a57d9c33bf08617aa5affc93affb805`.
  - `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `ff889a9e6d7f96f56184a1743b19e579d15dad29`.
  - `OTA_PROTECTION.md`: `06beb86b749b0f0e14c8cb517e43fe7c0f66a4e1`.
  - `OTA_REGRESSION_MEMORY.md`: `1d015da5a5c8d67194730cfd3b57680e371e8bff`.
  - `VOLTAGE_TRANSITION_MEMORY.md`: `9907f9c0bd5896662d2b3e041d75b5f0b2eca7a2`.
  - Previous `CHAT_TRANSFER.md` blob: `bed0dad0321a4a8cdcdfa528263a7be003265ab8`; verify the new blob live after this final write; do not self-reference the new hash.
- Build #62 analyzed and tested current App source and produced the APK/source archive above. Full run evidence, Build #61 failure and the narrow test-only repair are in `APP_BUILD_REPORT.md`.

## 4. Current Home indicator and animation contracts

- Disconnected telemetry remains unknown (`--`) and must not turn indicator/icon text black or generic grey. Keep each metric's lowest semantic accent as the fallback; do not imply that physical outputs are ON/OFF from an accent color.
- Battery temperature: Ice Blue at or below 30°C; smooth cyan/amber/orange transition through the 30–40°C band; Burning Red at or above 40°C. Battery thermal fill maps to 30–40°C. Battery warning/fire threshold remains exactly 40°C.
- Hotside temperature: Ice Blue at or below 30°C; smooth transition above 30°C; Burning Red at the currently configured Hotside Limit. Visual color never changes or replaces Firmware thermal protection.
- Manual voltage text/accent is 5V red, 9V green, 12V blue. Unknown/disconnected voltage falls back to the 5V red accent.
- Approved JE X FYZ grille is a symmetrical square 1:1 white geometric grille with central purple X (not HZ) and four corner mounting holes. Preserve the original interior pattern/frame; remove only the two small midpoint protrusions on the left/right outer sides when explicitly requested. Flat 2D/print-ready only: no shadows, bevels, faux depth, gradients, textures or invented details. “Enlarge only” means scale the existing design, not redesign.
- The current source restores Build #54 `_JexIconPainter` drawing geometry and blends active effects with the current activity controller. Existing Fan phase/coast behavior and Peltier retargeting are retained. The source has not been rendered on-device, so smoothness is not yet device-verified. These are UI illustrations, not live RPM/ice measurements.
- Build #62 compiled this source and passed all 88 Flutter tests plus release checks. Phone-side rendering, animations and transition smoothness remain NOT DEVICE-VERIFIED; do not claim visual behavior was inspected on the phone.

## 5. Floating Monitor presentation and screen FPS

- Metrics remain F/B/H/V/A/P/S. Display Style was removed; the only style is Letters and persisted legacy Icons values normalize to Letters.
- Size is 0.30×–1.00× inclusive in 0.05× increments (14 intervals), default 0.60×. Slider, storage normalization, Flutter/native runtime size reconciliation, pinch scaling and native overlay bounds must agree.
- Opacity is 0–100% in 5% increments; show its current numeric value but no 50% midpoint label. Legacy persisted opacity values snap to the nearest 5%. Opacity changes the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical Letters rows share the same left edge. The overlay remains freely draggable; WindowManager gravity is TOP | START and saved coordinates remain intact.
- Shizuku card is compact: status `Shizuku Access Granted` or `Shizuku Access Denied`, and only `Grant Shizuku Access` and `Check Access`. No long help paragraphs or `Open Shizuku` button. Access Granted proves permission/Binder prerequisites only; it does not establish successful UserService binding or readable SurfaceFlinger layers.
- FPS is intended to be **foreground screen FPS, not game-only FPS**. The native sampler uses focused-window identity and tries `dumpsys window displays`, full `dumpsys window`, then ActivityManager fallback before matching the foreground package to SurfaceFlinger layers. It estimates compositor-layer FPS from counter deltas, not display refresh rate or Flutter frame timing; exact semantics/layer availability are Android/OEM-dependent. A valid `0 FPS` is displayed after two matching layer snapshots over a valid interval with zero delta. First snapshots, missing layers, counter resets, invalid intervals and command/service failures are not represented as zero. These diagnostics and the binding lifecycle repair are built in Build #62.
- Binding lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` adds per-attempt UserService binding identities/tags, asynchronous latch wait, late-callback rejection, typed bind/timeout/dead-Binder/remote-call failures, bounded native diagnostics and cleanup guarded by the availability of an existing connected Binder. Dart analysis, 88/88 Flutter tests, Android release compilation/signing and asset re-download checks all passed under Build #62.
- FPS and the binding lifecycle patch are built/CI-tested by Build #62 but remain **NOT DEVICE-VERIFIED**. Shizuku permission granted does not prove the UserService binds successfully or that a particular Android/OEM exposes SurfaceFlinger layer statistics. Install Build #62 and switch the overlay across JE Cooler, Settings/launcher, other apps and an actual game; capture native `fps_monitor_status` and filtered `JexFpsDiag` logs if data remains unavailable. Do not infer device behavior from source-contract checks alone.

## 6. Firmware/hardware baseline and protections — unchanged here

- Active editable sketch: `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION="V6.6"`. User treats V6.6 as final and reported compiling it and two successful same-version online OTA updates; reports are user-reported, not independently verified here.
- ESP32-C3 Super Mini, one radio path for Wi-Fi/BLE. Pins: GPIO0 NTC ADC; GPIO1 TTP223 touch; GPIO3 12 V selector; GPIO4 9 V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. NTC 10 kΩ + 10 kΩ divider, Beta 3950, 3.3 V assumption and exactly one calibrated millivolt sample per second. No median/trimmed/multi-sample averaging without renewed explicit approval. BLE service UUID `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`; RX `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`; TX `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`; protocol P1 readiness is required. Encrypted/bonded writes exist, but an exclusive one-App/one-cooler key-lock is a design requirement whose end-to-end implementation is not established.
- Hotside limit range 40–50°C, default 45°C; manual safety latch re-arms only after Hotside ≤ hotLimit−1°C continuously for five seconds, never a single low sample. Adaptive thermal control uses 30-second stages at 12/9/5 V, Peltier OFF and Fan 100%; five continuous seconds cool enough before timeout cancels a stage, otherwise 12/9 V downshift one rail and unrecovered 5 V terminal-locks pending manual restart. After thermal downshift, recover upward one rail at a time after 60 seconds stable, never above the saved pre-downshift ceiling. HOTSIDE is startup default; HOTSIDE_BATTERY is runtime-only and stale phone Battery data falls back to HOTSIDE control without changing the chosen profile. Peltier PWM is 20 kHz/8-bit with a 5-second normal OFF→ON soft-start; Fan PWM is 25 kHz/8-bit. Rail handoff is 200 ms break-before-make plus the existing 1-second settle. An interrupted active ramp restarts a fresh 5-second ramp after handoff; a completed 100% ramp remains continuous. OFF/Hotside/NTC/OTA safety cancels deferred resume. No rapid Hotside-rise/slope protection exists in V6.6; it is a historical, unimplemented request.
- LED defaults 5 V red, 9 V green, 12 V blue; customizable/resettable. Supported decorative IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6 and Rainbow 7; ID 3/Mirror Pulse is retired/migrates to Static. Firmware emits atomic `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` and safety/OTA indication outranks decorative animation. Persistent settings use a 10-second quiet-period write; Adaptive Profile is runtime-only.
- Touch input is one TTP223 only (there is no separate Wi-Fi/BLE toggle). Recorded gesture timing: ~1 s startup grace, 30 ms qualification, raw HIGH tap 60–500 ms, 800 ms double-tap window from first valid release, 5 s long press; verify live source before changing.
- Phone Battery temp is sent via `PHONE:BT=<Celsius>` at 1 Hz while P1-ready. Firmware input TTL is 5 s; current Battery-zone defaults are 25°C (5 V) and 35°C (12 V), with 0.5°C hysteresis. Stale phone Battery data falls back to HOTSIDE behavior without changing the runtime profile.
- Adaptive indicators: ON orange three blinks; OFF white three blinks; OFF feedback waits for safe 5 V handoff if Adaptive had been active. A missing white boot/OFF indication was reported historically; physical behavior remains UNVERIFIED.
- OTA protected flow: Local boot SoftAP has 10 s no-client timeout and a 60 s hard cap after interaction; then Wi-Fi fully shuts down with 160 ms settle before BLE owns the ESP32-C3 single radio path. Online OTA uses `cloudClient.setInsecure()`—it does not authenticate HTTPS server certificate identity. CA validation and OTA-only NTP/TIME_SYNCING gate were removed together after a user-reported failure; which factor caused the observed issue remains unknown. Keep the raw GitHub URL allowlist, redirects blocked, HTTP/length/size/image checks, safe outputs, streaming update lifecycle, failure recovery/restart and App reconnect/P1 result flow. Firebase metadata remains firmware version + link; do not invent a SHA/signature field. Do not infer HTTP/TLS code from red/blue LEDs alone.
- Permanent App UI rule: do not show a standalone Battery Protection Guard badge/status; this does not weaken firmware thermal safety or suppress independently actionable localized Notify messages.
- No Firmware source, BIN artifact, Firebase metadata, OTA, flash, physical device, App Build or Release was changed/triggered during this documentation task.

## 7. Current repair scope and unverified points

- `lib/main.dart`: Build #54 `_JexIconPainter` geometry is restored with eased active-effect interpolation; Build #62 compiled the source, but phone animation quality remains unverified.
- `lib/floating_monitor.dart`: preserves metric `F` while Shizuku is unavailable, refreshes sampler status on resume, displays native diagnostic state, waits for startup status to resolve, and labels binding exception/timeout/dead-Binder/remote-call errors separately.
- Native UserService binding now uses an attempt-scoped `UserServiceArgs` tag, `ServiceConnection`, generation and `CountDownLatch`. Late callbacks are rejected/cleaned using only their attempt's tag, with explicit bind failure/timeout/disconnect/cancellation states. Logs record bind lifecycle and command results without dumping full command output.
- Native foreground/layer/sample logs include the detection source, foreground package, candidate/matched layer counts, chosen layer, delta, interval, FPS and status. Stop cleanup only attempts `--disable` when an existing connected/alive UserService remains, preventing an immediate rebind after a Binder failure.
- Source/test checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` and the widget contract repair are included in Build #62 (88/88 tests, complete Android release gates). Only physical-device FPS/service/overlay behavior remains unverified.

## 8. Durable App/design decisions, failures and evidence boundaries

- Main UI follows the Horizon Cooler direction: dark header, white rounded content panel, compact cards, VOLTAGE/ADAPTIVE tabs and cooler image on the right. Intended menu hierarchy is VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE with compact/sideways submenus. Preserve approved visual identity and make only requested narrow edits.
- The LED color picker uses 36 curated hue-ordered presets with localized names and no HEX labels. Swatch taps update only a local draft; explicit Select sends confirmed COLOR, Cancel discards it, and outside taps/system Back do not dismiss the dialog. Brightness remains the single hardware intensity control; preview visibility stays vivid at low hardware brightness and must not imply physical change before confirmation.
- Android notification small icon is the monochrome JE glyph on transparent background. Notification title is `JE X FYZ`, localized event/status belongs in the body, tapping opens JE Cooler, and the BLE foreground-service notification must not have an empty body.
- Home painter geometry was restored from Build #54 and built in Build #62; phase-continuous Fan rotation/coast, smooth active-effect blending and Peltier retargeting are retained. Exact phone-side icon shape, animation smoothness, color rendering and overlay geometry remain NOT DEVICE-VERIFIED.
- Build #61 was a genuine failed attempt: 87 passed/1 failed because of a stale widget source-contract assertion. It was corrected against current attempt-scoped binding/WindowManager behavior; Build #62 then passed 88/88. No test/gate was removed or weakened. The six active test blobs are listed in Section 3; file presence alone is not execution evidence.
- Evidence labels: CURRENT/VERIFIED = live source/GitHub Actions/Release artifact; SOURCE-CONTRACT CI = executed Flutter tests; USER-REPORTED = user says V6.6 compiled and two same-version online OTA updates succeeded; UNVERIFIED = target-phone FPS, UserService runtime, OEM layer visibility, rendering, hardware safety/OTA; HYPOTHESIS = brownout or whether CA vs NTP individually caused the earlier OTA failure; HISTORICAL/SUPERSEDED = older V5/V6 and earlier build states.
- Link audit: no missing local Markdown links in canonical active docs. Some root-relative links in the three frozen `archive/*.md` snapshots do not resolve inside `archive/`; archive blobs remain byte-for-byte unchanged. Use canonical root files; do not treat archived V5/V6.1/V6.2/V6.3 `CURRENT` blocks as live truth.

## 9. Authorization protocol and next validation

- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- **Build #62 is the latest successful release and includes binding checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae`.** Remaining gate is physical-device validation, not another unrequested build: install [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), test `F` while foreground changes among JE Cooler, Settings/launcher, another app and a real game, and capture exact Settings sampler status plus filtered `JexFpsDiag` logs if it stays `--`. Prior screenshots showed both `shizuku_userservice_unavailable` and `starting`; no runtime log proves which stage failed. Do not call FPS fixed or substitute display refresh rate.
