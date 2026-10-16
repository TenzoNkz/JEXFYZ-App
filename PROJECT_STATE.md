# JE X FYZ / JE Cooler — Current Project State

Last reconciled from live GitHub on 2026-10-16. This file is current-only. Use CHANGELOG.md for historical decisions and APP_BUILD_REPORT.md for build evidence.

## Current App source/release — 2026-10-16

- Latest verified release is [Build #62 / run `38841458441`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441), source/release commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`, triggered through guarded issue [#33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK build, V1/V2/V3 signing, certificate, matching source archive and downloaded asset checks all passed.
- Build #62 includes Shizuku UserService lifecycle hardening checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` and a test-only correction aligning the widget test with attempt-scoped binding and current WindowManager diagnostics. Build #61's single stale source-contract failure and exact repair are recorded in `APP_BUILD_REPORT.md`; no tests or gates were removed.
- The Shizuku change uses per-attempt `UserServiceArgs` tags/connections/latches, rejects and cleans late callbacks, exposes bind/timeout/dead-Binder/remote-call status, and avoids rebinding solely to disable capture after Binder failure. It is now analyzed, tested and Android-built by Build #62. Physical FPS and overlay behavior remain device-unverified.
- The screenshot showing Shizuku granted plus `F:--` does not establish the runtime root cause. Physical FPS and overlay rendering remain device-unverified.
- No Firmware/BIN, Firebase metadata, OTA, BLE hardware-control or thermal-safety changes were made.

## App identity and repository

- Canonical App repo: TenzoNkz/JEXFYZ-App, branch `main`. Latest verified release is Build #62 from source `42a72d863b10adfb5d6a0ee332a2f879a78173a4`; it includes Shizuku binding lifecycle hardening and passed 88/88 Flutter tests plus all release checks. Live reconciliation on 2026-10-16 verified **5 branches and 0 open PRs**. All commits after the release source are documentation/memory updates; App/Firmware source and tests remain identical to the verified Build #62 source tree.
- App/package: JE Cooler / JE X FYZ, com.horizontalzzz.jexfyz, pubspec version 1.0.0+3. Preserve Gradle versionName exactly as "Telegram @horizontalzzz".
- Only active App build workflow: .github/workflows/jexfyz-app-build-trigger.yml; issue opened/reopened only; repository-owner, exact title and body-token guarded. Normal push/PR does not build/release.
- Firmware artifact repo TenzoNkz/JEXFYZ-Firmware has exactly one tree entry: JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not modify or inspect BIN payload during documentation work. This does not prove current source-to-BIN provenance.

## Build #62 release artifact and signing record

- Build #62 / run `38841458441`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441. Completed successfully at 2026-10-16 02:43:37Z (2026-10-16 09:43:37 Asia/Jakarta); exact source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`, triggered by guarded [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33).
- Passed security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate verification, matching source-archive validation, publication and re-downloaded asset identity/hash/signature checks. The Build #62 test repair and prior Build #61 failure are kept in `APP_BUILD_REPORT.md`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #62 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `645909183`, `54,636,716` bytes, SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `645909184`, `2,871,177` bytes, SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`.
- Signing: V1/JAR=true, V2=true, V3=true; one signer. Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched.
- Non-blocking warnings: 23 Dart deprecation infos, Gradle 9.3.1 out-of-date notice, native ELF DWARF debugging information not obfuscated, self-signed/no-timestamp certificate and META-INF JAR notices, and pub-cache save denied by token scope. None failed a required gate.
- Physical phone rendering, Shizuku UserService runtime, OEM SurfaceFlinger layer access and actual foreground FPS remain unverified. CI success does not prove BLE/cooling safety/Firmware/OTA behavior. No Firmware source/BIN, Firebase metadata, physical OTA, flash or device operation was performed.

## Current source fingerprints

- lib/main.dart: d24885cf0a40472b9fb23ee6ce73ad772ae73672.
- lib/floating_monitor.dart: bae089f1f950bd70fe7e6f90e8afa1726293664f.
- lib/app_settings.dart: 4c89bcb3c04142ce49440a11b92054365c26f7a6.
- test/widget_test.dart: eb5b0b9b820ca48a8df47bf74ec64992cbd08232.
- test/floating_monitor_layout_contract_test.dart: 7f861d449e518af68fc4ece7278241aa3ce8691b.
- test/shizuku_fps_contract_test.dart: 5996eb0d899bf9abf8eae68f554a7a409faa00f1.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: d6f3231fecbc4c8669dedeae5d1484d2cdb6a415.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt: 5c4e04e87897ea2f9432809c3be4d29bff378315.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt: a139dfefe1121963c3a26b114b9b0fcc9f8fa16a.
- android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl: 5bd6c269212e523b190f7164e0ad1d257ed5e6a5.
- .github/workflows/jexfyz-app-build-trigger.yml: 585d190324e522fc08e66cc95bd7ee80c5f37664.
- pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66.
- android/app/build.gradle: cc35d2d3dbe603e7b5a7157d37dde222d646ea42; android/build.gradle: d6dbd400ba0baf2b33c14bb514745334a1e2ad33; AndroidManifest.xml: 393c9f9bfe02b9d71b2e3445ce873d5d16912ce1.

Build #62 used release source commit 42a72d863b10adfb5d6a0ee332a2f879a78173a4; it includes the Shizuku UserService lifecycle checkpoint 225cc9ae4c67b3fbb76426db3b2503ef6934aaae and the corrected widget source-contract assertions. Gradle versionName remains unchanged.

## Active tests and QC scope

Six active test files: test/app_protocol_notify_contract_test.dart; test/firmware_touch_adaptive_sync_test.dart; test/floating_monitor_layout_contract_test.dart; test/shizuku_fps_contract_test.dart; test/v6_6_qc_contract_test.dart; test/widget_test.dart. Build #62 ran the current release-source tests and passed 88/88, including the per-attempt Shizuku binding/source-contract assertions. Test/source-contract success does not establish physical-device behavior.

## Current physical-device validation pending — Shizuku FPS

- USER-REPORTED screenshot: Shizuku access appears granted, but overlay metric F showed --. The original screenshot was captured in JE Cooler's own settings screen; this alone did not prove why FPS data was absent.
- Build #58's FPS source uses focused-window identity and frame-delta validation, but the target phone still showed `F:--` despite Shizuku being granted. This points to a remaining runtime/sample path problem, not an overlay-enable or checkbox problem.
- **Build #62 includes and CI-tested** binding-lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae`: each UserService attempt has its own `UserServiceArgs` tag, `ServiceConnection`, generation and latch; stale callbacks are rejected/cleaned, bind exception/timeout/dead Binder/remote AIDL errors are distinguished, and filtered binding/command/foreground/layer/frame diagnostics are available. Cleanup avoids starting a fresh UserService only to disable capture after the active Binder has failed.
- **Remaining gate is on-device, not a pending build:** install the Build #62 release, check Settings' exact sampler status and `F:` while foregrounding JE Cooler, Settings/launcher, another app and a real game. If `F` remains `--`, capture filtered `JexFpsDiag` logs. CI does not prove runtime binding, SurfaceFlinger access or a valid live FPS measurement.

## Current Floating Monitor appearance

- Freely draggable overlay with saved coordinates. Horizontal metrics center as a group; vertical Letters rows share one left edge. Display Style is removed and persisted Icons configurations migrate to Letters.
- Size 0.30×–1.00×, 0.05× steps (14 intervals), default 0.60×. Slider, persistence normalization and native runtime scaling share the same range.
- Opacity is 0–100% in 5% steps with current percentage and endpoint labels only; the 50% midpoint label is removed. Legacy persisted opacity snaps to the nearest 5%.
- Black/White background selector, default Black; foreground contrasts automatically. Opacity 0% hides the background only.
- Shizuku card contains only Granted/Denied status, Grant Shizuku Access and Check Access; explanatory paragraphs and Open Shizuku button are removed.

## Current Firmware/hardware reference

- Active source firmware/JEXFYZ-V6.6.ino, blob f51ba6db5d0e91318f63fea4014bb87f7bf76222, FW_VERSION="V6.6", exactly one active versioned .ino.
- MCU ESP32-C3 Super Mini/Dev Module. GPIO0 NTC ADC; GPIO1 TTP223; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. NTC 10k + 10k divider, Beta 3950, 3.3 V assumption, calibrated millivolt read once/sec.
- Thermal reference: Hotside 40–50°C, default 45°C; manual re-arm at hotLimit−1°C continuously for 5 s. Adaptive 30 s stage at 12/9/5 V, Peltier off/Fan 100%; stable recovery 5 s cancels; otherwise step down/terminal-lock at 5 V. Upward recovery after 60 s stable, capped by saved ceiling. HOTSIDE startup default, HOTSIDE_BATTERY runtime-only. App PHONE:BT heartbeat 1 Hz, Firmware TTL 5 s; no standalone Battery Protection Guard UI.
- Peltier 20kHz/8-bit, normal OFF→ON soft-start 5s; Fan 25kHz/8-bit; selector break-before-make 200ms and 1s settle. Active ramp is paused/restarted across rail changes; completed ramp stays at 100%; outputs/safety take priority.
- User accepts Firmware V6.6 as final and reports compilation/two same-version Online OTA updates. Those are USER-REPORTED; source-to-BIN provenance remains UNVERIFIED. Do not compile Firmware or change BIN, Firebase or hardware.
- Read FIRMWARE_NOTES.md and firmware/FIRMWARE_TECHNICAL_REFERENCE.md before Firmware discussion. Read OTA_PROTECTION.md + OTA_REGRESSION_MEMORY.md before any OTA work, and VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing work. Keep OTA protected.

## Authorization rules

- @Thinking Diskusi! is read-only. @Thinking Eksekusi Full! handles only the scoped work and must not trigger a build implicitly. @Thinking Eksekusi Build App! authorizes the App build/release pipeline. @Thinking Chat Stuck! recovers the last authorized task without blind retries or scope expansion.
- Retired commands: @Thinking Build App!, @Thinking Eksekusi & Build App!, standalone @Thinking Eksekusi!.
- Use main directly; no branch/PR unless requested. Do not run Firmware compile, BIN creation/publication, Firebase production metadata changes, OTA, flash or device operation without separate explicit authorization. Keep Android versionName "Telegram @horizontalzzz".
