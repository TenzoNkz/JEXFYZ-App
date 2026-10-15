# JE X FYZ / JE Cooler — Current Project State

Last reconciled from live GitHub on 2026-10-16. This file is current-only. Use CHANGELOG.md for historical decisions and APP_BUILD_REPORT.md for build evidence.

## Current unbuilt source repair — 2026-10-16

- Current main source repair: `98cfe7ba4d0e9d569b84498d261ad1b67f66eee7` (not built, tested or device-verified). Latest verified release remains Build #56 from source `235f47b47af4f32582a7f18825ed76d2c6bba54f`.
- Scope: restore Build #54 icon painter geometry while blending active effects; preserve Floating Monitor metric `F` when Shizuku is unavailable; read focused window via a restricted `dumpsys window displays` operation with ActivityManager fallback; do not show zero for unverified FPS samples.
- No Firmware/BIN, Firebase, OTA, BLE hardware-control or thermal safety changes were made. Tests were updated but have not been run for this source commit.

## App identity and repository

- Canonical App repo: TenzoNkz/JEXFYZ-App, branch main. Current repair checkpoint: 98cfe7ba4d0e9d569b84498d261ad1b67f66eee7 (unbuilt/unverified). Latest verified release remains Build #56 from source 235f47b47af4f32582a7f18825ed76d2c6bba54f. Five branches and zero open PRs at the last verified tree check.
- App/package: JE Cooler / JE X FYZ, com.horizontalzzz.jexfyz, pubspec version 1.0.0+3. Preserve Gradle versionName exactly as "Telegram @horizontalzzz".
- Only active App build workflow: .github/workflows/jexfyz-app-build-trigger.yml; issue opened/reopened only; repository-owner, exact title and body-token guarded. Normal push/PR does not build/release.
- Firmware artifact repo TenzoNkz/JEXFYZ-Firmware has exactly one tree entry: JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not modify or inspect BIN payload during documentation work. This does not prove current source-to-BIN provenance.

## Latest App release — verified

- Build #56 / run `38785365015`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38785365015. Completed successfully at 2026-10-15 18:29:26Z (2026-10-16 01:29:26 Asia/Jakarta); build/release source commit `235f47b47af4f32582a7f18825ed76d2c6bba54f`, triggered by [issue #29](https://github.com/TenzoNkz/JEXFYZ-App/issues/29).
- Passed security/architecture/license audit, dependency resolution, Dart analysis, **86/86 Flutter tests**, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate validation, corresponding-source archive checks, Release publication, and re-downloaded asset/hash/signature verification.
- Current release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #56 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `644776225`, `54,538,412` bytes, SHA-256 `1ae3ef476c170ab0a9d78a77264c5281d60341a931db102c7b8645e4b0dadd19`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `644776227`, `2,860,746` bytes, SHA-256 `546d9e6bd99b84273e3b2dca8aa85ced979e118c0704ad97a0a16ff5e9e046c3`.
- Signature: V1/JAR=true, V2=true, V3=true; one signer. Expected production certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched.
- Relative to Build #55, current main SHA `235f47b47af4f32582a7f18825ed76d2c6bba54f` changes only `CHAT_TRANSFER.md`; no functional App repair was needed. APK bytes are identical to Build #55; the matching source ZIP changed and now contains the exact Build #56 source snapshot.
- Warnings remain non-blocking: 23 analyzer info-level deprecation findings, Kotlin Gradle Plugin `2.2.20` future-compatibility notice, Gradle `9.3.1` out-of-date notice, native ELF DWARF information not obfuscated, self-signed/no-timestamp certificate and META-INF JAR warnings. Flutter pub-cache write was denied at post-job cleanup because the token lacks writable cache scope; it did not fail any required gate.
- **Physical-device behavior remains unverified:** icon transitions, Shizuku UserService runtime, OEM SurfaceFlinger access and real foreground FPS must still be tested on-device. CI does not establish BLE, cooling, Firmware or OTA behavior.
- No Firmware source/BIN, Firebase metadata, physical OTA, flashing or device operation was performed.


## Current source fingerprints

- lib/main.dart: d24885cf0a40472b9fb23ee6ce73ad772ae73672.
- lib/floating_monitor.dart: 556217f0035e97fa6060041203151eec1c24ed76.
- lib/app_settings.dart: 4c89bcb3c04142ce49440a11b92054365c26f7a6.
- test/widget_test.dart: 5a9dc285729b6c85c4f70399cdf17282af1a5c33.
- test/floating_monitor_layout_contract_test.dart: 7f861d449e518af68fc4ece7278241aa3ce8691b.
- test/shizuku_fps_contract_test.dart: 5a9efb60b02c1cfabf44a35434f67fb555419c92.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: 44030753bf6a27ac0e9630f2d0f7ca0cc8e3bd0b.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt: e44fac7cec76979ef47a256a3e1d416d09ef7e22.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt: a139dfefe1121963c3a26b114b9b0fcc9f8fa16a.
- android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl: 5bd6c269212e523b190f7164e0ad1d257ed5e6a5.
- .github/workflows/jexfyz-app-build-trigger.yml: 585d190324e522fc08e66cc95bd7ee80c5f37664.
- pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66.
- android/app/build.gradle: cc35d2d3dbe603e7b5a7157d37dde222d646ea42; android/build.gradle: d6dbd400ba0baf2b33c14bb514745334a1e2ad33; AndroidManifest.xml: 393c9f9bfe02b9d71b2e3445ce873d5d16912ce1.

Build #56 used release source commit 235f47b47af4f32582a7f18825ed76d2c6bba54f; functional source checkpoint 311a18934a3cbe86a2a4718442c92541f081183f remains unchanged by the documentation-only handoff update. Gradle versionName remains unchanged.

## Active tests and QC scope

Six active test files: test/app_protocol_notify_contract_test.dart; test/firmware_touch_adaptive_sync_test.dart; test/floating_monitor_layout_contract_test.dart; test/shizuku_fps_contract_test.dart; test/v6_6_qc_contract_test.dart; test/widget_test.dart. Build #56 ran all and passed 86/86. Test/source-contract success does not establish physical-device behavior.

## Current physical-device validation pending — Shizuku FPS

- USER-REPORTED screenshot: Shizuku access appears granted, but overlay metric F showed --. The original screenshot was captured in JE Cooler's own settings screen; this alone did not prove why FPS data was absent.
- Current main source has been changed to monitor the package behind the focused window, including JE Cooler, launcher, Settings and Android system UI when SurfaceFlinger supplies matching layer data. It uses presented-frame deltas, not nominal screen refresh rate. An existing foreground layer with no new frame delta should display 0 after a sample interval.
- This behavior is a source change only. It has NOT been verified on the user's physical phone, and OEM/Android restrictions may still deny SurfaceFlinger data. Flutter/Dart tests and App build have not been run for this checkpoint. A Shizuku permission grant alone does not prove that the UserService starts or that layer data is accessible.

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
