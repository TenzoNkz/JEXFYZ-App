# JE X FYZ / JE Cooler — Current Project State

Last reconciled from live GitHub on 2026-10-17. This file is current-only. Use CHANGELOG.md for historical decisions and APP_BUILD_REPORT.md for build evidence.

## Current App source/release state — Build #71 verified

- Latest verified App release: Build #71 / run `39008259484`, exact source/release commit `d9e026f70ec62455763de05048cba1557edfaf23`. This release includes post-Build-70 dashboard-indicator motion continuity refinements and manual-voltage-toggle styling.
- All 21 active release workflow steps passed. Dart analysis reported 23 info-level deprecations; **88/88 Flutter tests passed**. Android production compile and configured `:app:testDebugUnitTest` gate succeeded in 1m34s; native JUnit tasks were NO-SOURCE after FPS-specific tests were removed, so no native JUnit cases ran.
- Release `jexfyz-latest` targets `d9e026f70ec62455763de05048cba1557edfaf23`. APK asset `649710440`, 54,603,867 bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`. Matching source ZIP asset `649710439`, 2,847,410 bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`. Both were re-downloaded and verified. Full evidence is in `APP_BUILD_REPORT.md`.
- Signing: V1/JAR, V2 and V3 verified true with one signer; production certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Non-blocking warnings are detailed in the report.
- Dashboard indicators now continue through a 440 ms OFF fade before pausing and resume from the retained phase at an equivalent loop boundary; flame cycles join smoothly, Battery segments ripple subtly, and four Peltier sparks orbit the stable six-branch crystal. Manual-voltage rows remain neutral; only the active toggle uses theme-primary while labels retain red/green/blue semantics.
- Physical overlay appearance, actual animation smoothness, toggle styling on-device and live BLE/Fan Speed telemetry remain UNVERIFIED on the phone. Build #71 is App CI/release evidence, not firmware compile or hardware proof.
- No Firmware source/BIN, Firebase, OTA, flash or device operation occurred.

## App identity and repository

- Canonical App repo: TenzoNkz/JEXFYZ-App, branch `main`. Latest verified release is Build #70 from `eb1224232241ca5d44d43e25919fd228875029ab`; current main includes post-Build-70 indicator/toggle changes that have not been built or released. Overlay and icon-animation rendering remain unverified on the phone.
- App/package: JE Cooler / JE X FYZ, com.horizontalzzz.jexfyz, pubspec version 1.0.0+3. Preserve Gradle versionName exactly as "Telegram @horizontalzzz".
- Only active App build workflow: .github/workflows/jexfyz-app-build-trigger.yml; issue opened/reopened only; repository-owner, exact title and body-token guarded. Normal push/PR does not build/release.
- Firmware artifact repo TenzoNkz/JEXFYZ-Firmware has exactly one tree entry: JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not modify or inspect BIN payload during documentation work. This does not prove current source-to-BIN provenance.

## HISTORICAL / SUPERSEDED — Build #69 release artifact and signing record

- Build #69 / run `38896502185`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38896502185. Completed at 2026-10-16 11:56:09Z (2026-10-16 18:56:09 Asia/Jakarta); exact source/release commit `01212c32a802ca0e67f559307fe4e19a667489c6`.
- Passed security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate, matching source archive, publication and re-downloaded asset checks. All 21 active workflow steps passed.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #69 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `647189019`, `54,636,716` bytes, SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `647189016`, `2,877,171` bytes, SHA-256 `1ab19e552c128d09773794738a6a4340abfa82086fa83f2d7e883ed62f60a699`.
- Signing: V1/JAR=true, V2=true, V3=true; one signer. Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched for built and downloaded APKs.
- Build #69 reran four TimeStats parser JUnit cases and five watchdog-policy JUnit cases; native tests succeeded in 1m 30s. All 88 Flutter tests passed. Functional source is unchanged from Build #67/#68; APK hash remains the same while the source ZIP carries the new HEAD marker.
- Non-blocking warnings: 23 Dart deprecation infos, Gradle `9.3.1` out-of-date, native ELF DWARF data not obfuscated, self-signed/no-timestamp JAR and META-INF notices, cache save denied by token scope. None failed a required gate.
- Build #71 verified the six-metric source plus indicator-motion/manual-toggle refinements through App CI and release gates. No Firmware source/BIN, Firebase metadata, OTA, flash or device operation occurred.

## HISTORICAL / SUPERSEDED — Build #66 release artifact and signing record

- Build #66 / run `38859288444`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38859288444. Completed successfully at 2026-10-16 06:11:34Z (2026-10-16 13:11:34 Asia/Jakarta); source commit `a2b19d4708f3075730132ac16f375f2a352aa50a`.
- Passed security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate verification, matching source archive, publication and re-downloaded asset identity/hash/signature checks. All 21 active workflow steps passed.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #66 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `646344237`, `54,636,716` bytes, SHA-256 `cae0364670324511551742295a40fc4208399a5de4330b5a18d5d43ca5d488cf`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `646344244`, `2,874,306` bytes, SHA-256 `9a3a008e377fa6bdcc7d4add2fecbce9167df88b2b0ce924512ca703e5eeac69`.
- Signing: V1/JAR=true, V2=true, V3=true; one signer. Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched for built and downloaded APK.
- Non-blocking warnings: 23 Dart deprecation infos, Gradle `9.3.1` out-of-date notice, native ELF DWARF data not obfuscated, self-signed/no-timestamp JAR and META-INF notices, cache save denied by token scope. None failed a required gate.
- Actual Shizuku UserService binding, OEM TimeStats visibility, live foreground FPS and phone overlay rendering remain not device-verified. Build #66 was App-only: no Firmware compilation, BIN publication, Firebase, OTA, flashing or device operation occurred.

## HISTORICAL / SUPERSEDED — Build #62 release artifact and signing record

- Build #62 / run `38841458441`, URL https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441. Completed successfully at 2026-10-16 02:43:37Z (2026-10-16 09:43:37 Asia/Jakarta); exact source commit `42a72d863b10adfb5d6a0ee332a2f879a78173a4`, triggered by guarded [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33).
- Passed security/architecture/license audit, dependencies, Dart analysis, **88/88 Flutter tests**, obfuscated APK compilation, V1/V2/V3 signing, expected production certificate verification, matching source-archive validation, publication and re-downloaded asset identity/hash/signature checks. The Build #62 test repair and prior Build #61 failure are kept in `APP_BUILD_REPORT.md`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets Build #62 and contains exactly two assets:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `645909183`, `54,636,716` bytes, SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `645909184`, `2,871,177` bytes, SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`.
- Signing: V1/JAR=true, V2=true, V3=true; one signer. Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched.
- Non-blocking warnings: 23 Dart deprecation infos, Gradle 9.3.1 out-of-date notice, native ELF DWARF debugging information not obfuscated, self-signed/no-timestamp certificate and META-INF JAR notices, and pub-cache save denied by token scope. None failed a required gate.
- Physical phone rendering, Shizuku UserService runtime, OEM SurfaceFlinger layer access and actual foreground FPS remain unverified. CI success does not prove BLE/cooling safety/Firmware/OTA behavior. No Firmware source/BIN, Firebase metadata, physical OTA, flash or device operation was performed.

## Current source fingerprints

- Latest verified released functional source: Build #71 commit d9e026f70ec62455763de05048cba1557edfaf23, including the motion/toggle changes. Subsequent documentation updates must not be mistaken for a new functional source build.
- Current Flutter source blobs: lib/main.dart c10a708022ca8e8defbe1583b47fb0b10ddda8ed; lib/floating_monitor.dart 31b45ea08b08ac7fc25ebd991dca873b889fdd14; lib/app_settings.dart 20f1ce0f838345c9eee4cbacde22255cb7852435; test/widget_test.dart 032cefebf89e08f92fddaf992184c7580c185b2a; test/floating_monitor_layout_contract_test.dart 87e805095202ac3edfe55b9aeb3138c7c6886375; test/v6_6_qc_contract_test.dart 083e0d19389c235b84f9785ee665d8ed8789e37f.
- Native App source: FloatingMonitorService.kt 7368df11ecb369f8b71607c82e6a1b44472cc79b; MainActivity.kt bd17c34211e8eb5c4723e06937ae47f0071b5e8b; AndroidManifest.xml c374b5d3ad6448b8b3e99a420ed7e8c49d38497a; android/app/build.gradle 060cdd36a4f7d4d2fa4c97a1b6a15954b8355350; workflow .github/workflows/jexfyz-app-build-trigger.yml 8a8533aff7e0e0e01412bf522e1966e81aa1a39f.
- Five active Dart tests: widget_test.dart 4e5a6d4fdc02e39ba5420a12cad9c39f9f82882e; floating_monitor_layout_contract_test.dart 87e805095202ac3edfe55b9aeb3138c7c6886375; v6_6_qc_contract_test.dart 083e0d19389c235b84f9785ee665d8ed8789e37f; app_protocol_notify_contract_test.dart 92214dd90178c705844d3979d3f8f7bd17bcc4b8; firmware_touch_adaptive_sync_test.dart 2d3fea509343a03b8d23623f4dcb2dd7fd972d39.
- FPS UserService/parser/watchdog and native tests, Shizuku AIDL/provider/dependencies, Shizuku-only Dart contract and license/notice files are absent from current main tree. Workflow audit prevents their reintroduction and retains the Android production compile/test gate.
- Build #71 passed 88/88 Flutter tests and release gates. Native JUnit cases did not run because the unit-test tasks were NO-SOURCE after FPS-specific native tests were retired. Physical-device behavior remains UNVERIFIED.

## Active tests and QC scope

Five active Dart test files remain; Build #71 ran 88/88 successfully. Native FPS JUnit tests were removed and no native JUnit cases ran in Build #71 (NO-SOURCE). Physical overlay behavior remains outside CI proof.

## Current Floating Monitor state

- Supported metrics are B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier) and F (Fan Speed). No FPS or Shizuku UI/runtime remains in the intended current source.
- Persisted schema v1 compatibility: discard old F (FPS); migrate old S (Speed) to new F (Fan Speed). Schema v2 is serialized in FloatingConfig and sent to native overlay.
- The repeated F:-- / shizuku_userservice_timeout reports are historical symptoms and the reason FPS was retired; they are not an active diagnostic task for current main.
- Build #71 passed the Flutter contract tests for motion continuity and manual-voltage toggle styling, workflow audit, Android production compile/configured gate and release checks. Physical overlay behavior remains unverified. Further App Build is only for a new scoped change.

## Current Floating Monitor appearance

- Freely draggable overlay with saved coordinates. Horizontal metrics center as a group; vertical Letters rows share one left edge. Display Style is removed and persisted Icons configurations migrate to Letters.
- Size 0.30×–1.00×, 0.05× steps (14 intervals), default 0.60×. Slider, persistence normalization and native runtime scaling share the same range.
- Opacity is 0–100% in 5% steps with current percentage and endpoint labels only; the 50% midpoint label is removed. Legacy persisted opacity snaps to the nearest 5%.
- Black/White background selector, default Black; foreground contrasts automatically. Opacity 0% hides the background only.
- The Shizuku/FPS access card is removed. Fan Speed is the F metric; the six current identifiers are B/H/V/A/P/F.

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
