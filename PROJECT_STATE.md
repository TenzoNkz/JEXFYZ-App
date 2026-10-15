# JE X FYZ / JE Cooler — Current Project State

Last reconciled from live GitHub on 2026-10-16. This file is current-only. Use CHANGELOG.md for historical decisions and APP_BUILD_REPORT.md for build evidence.

## App identity and repository

- Canonical App repo: TenzoNkz/JEXFYZ-App, branch main. Current source execution checkpoint before doc synchronization: 00c55d4b42a529bc436e252be1aa1d9a2cf39682. Its recursive tree had 80 entries and was not truncated; 5 branches, 0 open PRs. Subsequent commits in this task update memory/docs only.
- App/package: JE Cooler / JE X FYZ, com.horizontalzzz.jexfyz, pubspec version 1.0.0+3. Preserve Gradle versionName exactly as "Telegram @horizontalzzz".
- Only active App build workflow: .github/workflows/jexfyz-app-build-trigger.yml; issue opened/reopened only; repository-owner, exact title and body-token guarded. Normal push/PR does not build/release.
- Firmware artifact repo TenzoNkz/JEXFYZ-Firmware has exactly one tree entry: JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not modify or inspect BIN payload during documentation work. This does not prove current source-to-BIN provenance.

## Latest App release — verified

- Build #54 / run 38767611593, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38767611593. Run completed success at 2026-10-15 16:21:50Z and used source commit 437e7730dbcaf9666ae4828e546a45343bb4890c.
- Passed security/architecture/license audit, dependency resolution, Dart analysis, all 86 Flutter tests, obfuscated APK build, V1/V2/V3 checks, production certificate validation, corresponding-source archive creation/validation, Release publication and re-downloaded asset/hash verification.
- Current release tag jexfyz-latest targets the Build #54 source and contains exactly two assets:
  - JEXFYZ-release.apk, asset ID 644438898, 54,636,716 bytes, SHA-256 cdf8a7f94424b9cb60be6e04489a9f0f0d8ddad43ab76c33c2e2c6333fa61327.
  - JEXFYZ-corresponding-source.zip, asset ID 644438897, 2,862,590 bytes, SHA-256 3b208c987def59a7c1857ed0fcc9ca5d74d591767e5658dfab04c9c1be85450f.
- Build attempts #50–#53 and their root causes/fixes are preserved in APP_BUILD_REPORT.md; #54 is the current successful release. Do not repeat outdated claims that #49 is the latest.
- Non-blocking warnings: analyzer deprecation infos, Gradle/Kotlin migration notices, dependency updates outside current constraints, native ELF DWARF debug metadata, and jarsigner self-signed/no-timestamp warnings. Explicit V1/V2/V3 and expected certificate identity checks passed. Details in APP_BUILD_REPORT.md.
- Build #54 remains the latest verified RELEASE, not the current source checkpoint. The newer indicator/Floating Monitor/screen-FPS source changes are unbuilt and do not appear in the published APK/source ZIP.

## Current source fingerprints

- lib/main.dart: 69eef38d26282b94ad1bea297d812dfd8b9e91e3.
- lib/floating_monitor.dart: 539172e927871415b60dff8e5321199237879c45.
- lib/app_settings.dart: 4c89bcb3c04142ce49440a11b92054365c26f7a6.
- test/widget_test.dart: 9a0c07b02b5ea63914d735be777fe0a3df66b2bb.
- test/floating_monitor_layout_contract_test.dart: bc5d3f9039f18e785c1268745de577bd388a731f.
- test/shizuku_fps_contract_test.dart: 798633a24907fd8aca567e70a6376dc59c6e41c9.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: dd10ff0b2c23941badaa33949967fc373f98aeb9.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt: 1f5ed36dadaba9dc70ecfbe0793114b34c8ab08b.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt: a139dfefe1121963c3a26b114b9b0fcc9f8fa16a.
- android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl: 5bd6c269212e523b190f7164e0ad1d257ed5e6a5.
- .github/workflows/jexfyz-app-build-trigger.yml: 585d190324e522fc08e66cc95bd7ee80c5f37664.
- pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66.
- android/app/build.gradle: cc35d2d3dbe603e7b5a7157d37dde222d646ea42; android/build.gradle: d6dbd400ba0baf2b33c14bb514745334a1e2ad33; AndroidManifest.xml: 393c9f9bfe02b9d71b2e3445ce873d5d16912ce1.

Build #54 used source commit 437e7730; current main parent HEAD 329fd18 is one documentation-only commit later. Gradle versionName remains unchanged.

## Active tests and QC scope

Six active test files: test/app_protocol_notify_contract_test.dart; test/firmware_touch_adaptive_sync_test.dart; test/floating_monitor_layout_contract_test.dart; test/shizuku_fps_contract_test.dart; test/v6_6_qc_contract_test.dart; test/widget_test.dart. Build #54 ran all and passed 86/86. Test/source-contract success does not establish physical-device behavior.

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
