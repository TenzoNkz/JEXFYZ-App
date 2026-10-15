# JE X FYZ / JE Cooler — Current Project State

Last reconciled from live GitHub on 2026-10-16. This file is current-only. Use CHANGELOG.md for historical decisions and APP_BUILD_REPORT.md for build evidence.

## Current App source/release — 2026-10-16

- Latest verified release is [Build #60 / run `38817543342`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38817543342), exact release source `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`; official trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). It passed audit, dependencies, Dart analysis, **88/88 Flutter tests**, release build/signing and downloaded asset verification.
- Build #60 includes post-Build #58 FPS diagnostics patch `6e9b4c73db12c51f4452717d8cf102f49d325dcf` and test-contract correction `7a576e60f0938cec94fcddb96340cd5376fa15de`. Build #59's single stale assertion failure was repaired and remains recorded in `APP_BUILD_REPORT.md`; no tests or gates were removed.
- FPS diagnostics try `dumpsys window displays`, then full `dumpsys window`, then ActivityManager; keep status `starting` until a valid sample; accept valid zero after two matching snapshots; distinguish reset/invalid counters; cancel stale polling on retry; and surface native sampler status in Settings.
- The screenshot showing Shizuku granted plus `F:--` does not establish the runtime root cause. Physical FPS and overlay rendering remain device-unverified.
- No Firmware/BIN, Firebase metadata, OTA, BLE hardware-control or thermal-safety changes were made.

## App identity and repository

- Canonical App repo: TenzoNkz/JEXFYZ-App, branch main. Latest successful release is Build #60 from source `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`; FPS diagnostics and corrected contract tests now pass CI. Five branches and zero open PRs at the last verified tree check.
- App/package: JE Cooler / JE X FYZ, com.horizontalzzz.jexfyz, pubspec version 1.0.0+3. Preserve Gradle versionName exactly as "Telegram @horizontalzzz".
- Only active App build workflow: .github/workflows/jexfyz-app-build-trigger.yml; issue opened/reopened only; repository-owner, exact title and body-token guarded. Normal push/PR does not build/release.
- Firmware artifact repo TenzoNkz/JEXFYZ-Firmware has exactly one tree entry: JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not modify or inspect BIN payload during documentation work. This does not prove current source-to-BIN provenance.

## Latest App release — verified

- Build #60 / run `38817543342`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38817543342. Completed successfully at 2026-10-15 22:35:39Z (2026-10-16 05:35:39 Asia/Jakarta); exact source commit `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`, triggered by [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33).
- Passed security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate verification, matching source-archive validation, publication and re-downloaded asset identity/hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #60 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `645381550`, `54,636,716` bytes, SHA-256 `47892215de179c8cb2975ad5c99b8b3b1398559873352411ed74d001aa001274`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `645381553`, `2,866,092` bytes, SHA-256 `dd9bdc1f8082c70ab2ff73892f5434057d36cedc870fd92184b8ed579e2b538a`.
- Signing: V1/JAR=true, V2=true, V3=true; one signer. Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched.
- Non-blocking warnings: 23 Dart deprecation infos, Gradle 9.3.1 out-of-date notice, native ELF DWARF debugging information not obfuscated, self-signed/no-timestamp certificate and META-INF JAR notices, and pub-cache save denied by token scope. None failed a required gate.
- Physical phone rendering, Shizuku UserService runtime, OEM SurfaceFlinger layer access and actual foreground FPS remain unverified. CI success does not prove BLE/cooling safety/Firmware/OTA behavior. No Firmware source/BIN, Firebase metadata, physical OTA, flash or device operation was performed.

## Current source fingerprints

- lib/main.dart: d24885cf0a40472b9fb23ee6ce73ad772ae73672.
- lib/floating_monitor.dart: d43bd17a7adebf7c9f95fc5fdf921ba2a22a231b.
- lib/app_settings.dart: 4c89bcb3c04142ce49440a11b92054365c26f7a6.
- test/widget_test.dart: f8a8ff0f5f6527a0a6f6e2c453fe5c0836437785.
- test/floating_monitor_layout_contract_test.dart: 7f861d449e518af68fc4ece7278241aa3ce8691b.
- test/shizuku_fps_contract_test.dart: 93aca6d5f5ad6c3c4723b2545eaf997cf8ee996f.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: c7ca3e75c28b53ea8cda207836befbe04a2e5a6f.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt: 9f70d480bd31a4875653add70804ab50fc15b747.
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt: a139dfefe1121963c3a26b114b9b0fcc9f8fa16a.
- android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl: 5bd6c269212e523b190f7164e0ad1d257ed5e6a5.
- .github/workflows/jexfyz-app-build-trigger.yml: 585d190324e522fc08e66cc95bd7ee80c5f37664.
- pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66.
- android/app/build.gradle: cc35d2d3dbe603e7b5a7157d37dde222d646ea42; android/build.gradle: d6dbd400ba0baf2b33c14bb514745334a1e2ad33; AndroidManifest.xml: 393c9f9bfe02b9d71b2e3445ce873d5d16912ce1.

Build #60 used release source commit b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3; FPS diagnostic checkpoint 6e9b4c73db12c51f4452717d8cf102f49d325dcf and test-contract fix 7a576e60f0938cec94fcddb96340cd5376fa15de are included. Gradle versionName remains unchanged.

## Active tests and QC scope

Six active test files: test/app_protocol_notify_contract_test.dart; test/firmware_touch_adaptive_sync_test.dart; test/floating_monitor_layout_contract_test.dart; test/shizuku_fps_contract_test.dart; test/v6_6_qc_contract_test.dart; test/widget_test.dart. Build #60 ran all active tests and passed 88/88. Test/source-contract success does not establish physical-device behavior.

## Current physical-device validation pending — Shizuku FPS

- USER-REPORTED screenshot: Shizuku access appears granted, but overlay metric F showed --. The original screenshot was captured in JE Cooler's own settings screen; this alone did not prove why FPS data was absent.
- Build #58's FPS source uses focused-window identity and frame-delta validation, but the target phone still showed `F:--` despite Shizuku being granted. This points to a remaining runtime/sample path problem, not an overlay-enable or checkbox problem.
- Current unbuilt source follow-up retries `dumpsys window` when `dumpsys window displays` has no parseable focus; keeps native state at `starting` until a valid sample; and displays the native sampler status in Settings. The source does not yet prove which runtime stage is failing.
- Install/build validation is still required for these latest changes. Once available, use the status line to decide whether to inspect foreground detection, SurfaceFlinger layer matching, command/service failure or invalid samples. Do not claim device FPS works without a valid displayed measurement.

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
