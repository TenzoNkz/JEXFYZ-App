# JE X FYZ / JE Cooler — Current Project State

Last reconciled from live GitHub on 2026-10-16. This file is current-only. Use CHANGELOG.md for historical decisions and APP_BUILD_REPORT.md for build evidence.

## Current App source/release — 2026-10-16

- Latest verified App release is [Build #66 / run `38859288444`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38859288444), source/release commit `a2b19d4708f3075730132ac16f375f2a352aa50a`, triggered through guarded issue [#33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Audit, dependencies, Dart analysis, **88/88 Flutter tests**, native FPS parser JUnit tests, obfuscated APK build, V1/V2/V3 signing, certificate, matching source archive and downloaded asset checks all passed.
- Build #66 includes Shizuku bind-timeout repair `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d`: native bind deadline is 35 seconds and Settings polls sampler status for 50.4 seconds. The timeout and UI/test contracts passed full CI; the target phone's actual UserService binding and FPS remain unverified.
- TimeStats sampler/parser `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`, four parser JUnit cases, widget fixes and 4 GiB Gradle heap passed Build #66. Current main adds exception isolation, watchdog and five policy tests in `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46`; these are NOT RUN / NOT BUILT.
- TimeStats samples are bounded to 64 layers and read every 500 ms; the sampler uses interval `averageFPS`, matches `packageName` when supplied, falls back to exact layer package matching and prefers SurfaceView/BLAST layers. Shizuku permission or CI success does not establish that a specific OEM exposes valid TimeStats. If `F:--` persists, capture Settings sampler status and `JexFpsDiag` logs.
- No Firmware/BIN, Firebase metadata, OTA, BLE hardware-control or thermal-safety changes were made.

## App identity and repository

- Canonical App repo: TenzoNkz/JEXFYZ-App, branch `main`. Build #66 remains latest verified release from `a2b19d4708f3075730132ac16f375f2a352aa50a`. Current main contains unbuilt sampler recovery commit `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46`; it is not in the release APK. Device binding/FPS remain unverified.
- App/package: JE Cooler / JE X FYZ, com.horizontalzzz.jexfyz, pubspec version 1.0.0+3. Preserve Gradle versionName exactly as "Telegram @horizontalzzz".
- Only active App build workflow: .github/workflows/jexfyz-app-build-trigger.yml; issue opened/reopened only; repository-owner, exact title and body-token guarded. Normal push/PR does not build/release.
- Firmware artifact repo TenzoNkz/JEXFYZ-Firmware has exactly one tree entry: JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not modify or inspect BIN payload during documentation work. This does not prove current source-to-BIN provenance.

## Latest release artifact and signing record — Build #66

- Build #66 / run `38859288444`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38859288444. Completed successfully at 2026-10-16 06:11:34Z (2026-10-16 13:11:34 Asia/Jakarta); source commit `a2b19d4708f3075730132ac16f375f2a352aa50a`.
- Passed security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate verification, matching source archive, publication and re-downloaded asset identity/hash/signature checks. All 21 active workflow steps passed.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #66 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `646344237`, `54,636,716` bytes, SHA-256 `cae0364670324511551742295a40fc4208399a5de4330b5a18d5d43ca5d488cf`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `646344244`, `2,874,306` bytes, SHA-256 `9a3a008e377fa6bdcc7d4add2fecbce9167df88b2b0ce924512ca703e5eeac69`.
- Signing: V1/JAR=true, V2=true, V3=true; one signer. Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched for built and downloaded APK.
- Non-blocking warnings: 23 Dart deprecation infos, Gradle `9.3.1` out-of-date notice, native ELF DWARF data not obfuscated, self-signed/no-timestamp JAR and META-INF notices, cache save denied by token scope. None failed a required gate.
- Actual Shizuku UserService binding, OEM TimeStats visibility, live foreground FPS and phone overlay rendering remain not device-verified. Build #66 was App-only: no Firmware compilation, BIN publication, Firebase, OTA, flashing or device operation occurred.

## Historical release artifact and signing record — Build #62 (superseded by #66)

- Build #62 / run `38841458441`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441. Completed successfully at 2026-10-16 02:43:37Z (2026-10-16 09:43:37 Asia/Jakarta); exact source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`, triggered by guarded [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33).
- Passed security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate verification, matching source-archive validation, publication and re-downloaded asset identity/hash/signature checks. The Build #62 test repair and prior Build #61 failure are kept in `APP_BUILD_REPORT.md`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #62 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `645909183`, `54,636,716` bytes, SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `645909184`, `2,871,177` bytes, SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`.
- Signing: V1/JAR=true, V2=true, V3=true; one signer. Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched.
- Non-blocking warnings: 23 Dart deprecation infos, Gradle 9.3.1 out-of-date notice, native ELF DWARF debugging information not obfuscated, self-signed/no-timestamp certificate and META-INF JAR notices, and pub-cache save denied by token scope. None failed a required gate.
- Physical phone rendering, Shizuku UserService runtime, OEM SurfaceFlinger layer access and actual foreground FPS remain unverified. CI success does not prove BLE/cooling safety/Firmware/OTA behavior. No Firmware source/BIN, Firebase metadata, physical OTA, flash or device operation was performed.

## Current source fingerprints

- Latest verified release source: `a2b19d4708f3075730132ac16f375f2a352aa50a` (Build #66). Current main includes unbuilt sampler recovery source `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46`; do not describe it as release-equivalent.
- `lib/main.dart`: `d24885cf0a40472b9fb23ee6ce73ad772ae73672`.
- `lib/floating_monitor.dart`: `fc88e61d8a9b0d0483d1ff5f08699b253a092a3c`.
- `lib/app_settings.dart`: `4c89bcb3c04142ce49440a11b92054365c26f7a6`.
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `8d575b448cb08b57674a07f5ddfed329079f3840`.
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt`: `8bb6181b4c86e1a2ae2c635969646303b6d84483`.
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsTimeStatsParser.kt`: `66b5e3f489f4e160407d87c40d1ecee54e13282f`; native JUnit `FpsTimeStatsParserTest.kt`: `ab6c63c627c05d9987de4d4af731f2ed86acde5b`; new policy `FpsSamplerWatchdogPolicy.kt` `c3d7bfa3a599f5748866dbe3e070c06cee968638` and tests `FpsSamplerWatchdogPolicyTest.kt` `fc3fe8aa3d7fe70ca8aafa7716ddd912ed5ffccb` (NOT RUN).
- `test/widget_test.dart`: `4b05e025e7765b30d04c20ada0322a17517025b9`; `test/shizuku_fps_contract_test.dart`: `0e60e2a8ec3458f6cafd3cd082d6437d4598a0ac`; `test/floating_monitor_layout_contract_test.dart`: `7f861d449e518af68fc4ece7278241aa3ce8691b`.
- `.github/workflows/jexfyz-app-build-trigger.yml`: `df7cbfee8d6fb8ef12683a35b0419c5d3980a4e3`.
- `android/app/build.gradle`: `46d503aef8320864632d3eb2bf7536048b8fd96f`; `android/gradle.properties`: `37ecfaa0b981a17640bb33ef01e7789ae8e4501e` (`-Xmx4096M`); `android/settings.gradle`: `14545695cc9aba5912393ec293c284ee60d9ec10`; `pubspec.yaml`: `8f558273e21692af9958f914527fdc62d623d63a`; `pubspec.lock`: `1e92812bfda2c28244a0556d71d1ec94084acc66`.
- Active Firmware remains user-accepted V6.6. Build #66 was App-only; no Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Active tests and QC scope

Six active Dart test files remain. Build #66 passed 88/88 Flutter tests and four native parser JUnit cases on its release source. Current main adds watchdog contract updates and five policy JUnit cases; these are NOT RUN. Physical-device behavior remains outside CI proof.

## Current physical-device validation pending — Shizuku FPS

- USER-REPORTED screenshot: Shizuku access appears granted, but overlay metric F showed --. The original screenshot was captured in JE Cooler's own settings screen; this alone did not prove why FPS data was absent.
- Build #58's FPS source uses focused-window identity and frame-delta validation, but the target phone still showed `F:--` despite Shizuku being granted. This points to a remaining runtime/sample path problem, not an overlay-enable or checkbox problem.
- **Build #62 includes and CI-tested** binding-lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae`: each UserService attempt has its own `UserServiceArgs` tag, `ServiceConnection`, generation and latch; stale callbacks are rejected/cleaned, bind exception/timeout/dead Binder/remote AIDL errors are distinguished, and filtered binding/command/foreground/layer/frame diagnostics are available. Cleanup avoids starting a fresh UserService only to disable capture after the active Binder has failed.
- **Next software gate:** run `@Thinking Eksekusi Build App!` for current main `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46`; Build #66 does not include it. After the new APK passes gates and is installed, capture status and filtered `JexFpsDiag` logs if `F:--` persists. CI cannot prove device behavior.

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
