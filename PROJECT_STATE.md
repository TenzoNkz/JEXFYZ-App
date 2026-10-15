# JE X FYZ / JE Cooler — Current Project State

Last reconciled from live GitHub on 2026-10-16 00:04 Asia/Jakarta. This file is current-only. Use CHANGELOG.md for historical decisions and APP_BUILD_REPORT.md for each build attempt.

## App identity and repository

- Canonical App repo: TenzoNkz/JEXFYZ-App, branch main. Parent HEAD before this documentation reconciliation: 329fd18e3c6ced8f43a7dbfaf7bf02206c17d42a. Recursive tree had 80 entries and was not truncated; 5 branches, 0 open PRs.
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

## Current source fingerprints

- lib/main.dart: 72c450d9b1e8783e4b82b8e37a5f39e2d49b6289.
- lib/floating_monitor.dart: 05a61e5670ec09c9c46cf60466a1dd301dfe5352.
- lib/app_settings.dart: 46cc838f43a06c325af6f6832e200a4e1ed4f75d.
- test/widget_test.dart: 520399fcdc6be4fd69cb48f50aa8961f5d9183c5.
- test/floating_monitor_layout_contract_test.dart: 31d9aabf4ac0839855308b6bd2a0708fa399a3a9.
- test/shizuku_fps_contract_test.dart: 798633a24907fd8aca567e70a6376dc59c6e41c9.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: 0c9cfdee776ca2f1de5daf2205d1f9f8da63683d.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt: 1f5ed36dadaba9dc70ecfbe0793114b34c8ab08b.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt: a139dfefe1121963c3a26b114b9b0fcc9f8fa16a.
- android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl: 5bd6c269212e523b190f7164e0ad1d257ed5e6a5.
- .github/workflows/jexfyz-app-build-trigger.yml: 585d190324e522fc08e66cc95bd7ee80c5f37664.
- pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66.
- android/app/build.gradle: cc35d2d3dbe603e7b5a7157d37dde222d646ea42; android/build.gradle: d6dbd400ba0baf2b33c14bb514745334a1e2ad33; AndroidManifest.xml: 393c9f9bfe02b9d71b2e3445ce873d5d16912ce1.

Build #54 used source commit 437e7730; current main parent HEAD 329fd18 is one documentation-only commit later. Gradle versionName remains unchanged.

## Active tests and QC scope

Six active test files: test/app_protocol_notify_contract_test.dart; test/firmware_touch_adaptive_sync_test.dart; test/floating_monitor_layout_contract_test.dart; test/shizuku_fps_contract_test.dart; test/v6_6_qc_contract_test.dart; test/widget_test.dart. Build #54 ran all and passed 86/86. Test/source-contract success does not establish physical-device behavior.

## Open physical-device issue: Shizuku granted, F remains --

- USER-REPORTED screenshot: permission card says “Shizuku permission granted”, yet the overlay pill shows F:--, while Battery 41.5°C, Hotside 31.3°C, Voltage 12V, Adaptive OFF, Peltier OFF and Speed 100 are visible.
- The same screenshot appears to show the JE Cooler Floating Monitor settings screen in the foreground. Native pollSurfaceFlinger() explicitly sets no_game_foreground and keeps FPS -- when the focused package equals JE Cooler's own package. Thus the screenshot is consistent with the app correctly refusing to count its own UI, but this is a plausible explanation, not a confirmed device diagnosis.
- Permission grant is only one gate. It doesn't prove UserService binding, /system/bin/dumpsys access, focused-app parsing or a matching SurfaceFlinger layer. No runtime status dump/logcat has been supplied.
- Next step is a device test with an actual game in foreground while the overlay remains enabled. If F stays --, capture fps_monitor_status and logs for shizuku_userservice_unavailable/disconnected/error, surfaceflinger_blocked, dumpsys_timeout, foreground_unknown, no_game_foreground, no_layer_data or waiting_for_frames. Do not report a confirmed cause before there is evidence. Gemini was not consulted; available plugin search did not find a Gemini connector.
  
## Current Floating Monitor appearance

- Freely draggable overlay; text group/rows centered inside the compact box, without locking the box to the screen center.
- Size 0.30×–0.80×, 0.05× steps, default 0.60×, with a numeric label.
- Opacity affects the background only, 0–100%, with live percentage and 0/50/100 marks.
- Black/White background selector, default Black; text and icons auto-contrast. Opacity 0% hides the background only. These source and test contracts are included in Build #54.

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
