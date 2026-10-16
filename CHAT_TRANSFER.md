# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot reconciled against live GitHub main on 2026-10-16 (Asia/Jakarta), after commit 8217a2e8d19dc82e9fe3bfa7e4e1c1692d0b7941 removed FPS and Shizuku from active App source. Build #69 remains the latest verified APK/release, but it predates this change and its APK/source archive still contain the old FPS implementation. The current six-metric source, migration tests and updated workflow have NOT YET BEEN BUILT OR TESTED. PROJECT_STATE.md is current-only; APP_NOTES.md owns App behavior; APP_BUILD_REPORT.md is the build ledger; CHANGELOG.md is history only.

## 1. Repository identity and current Git checkpoint

- Canonical App source/memory repository: TenzoNkz/JEXFYZ-App, branch main.
- Main HEAD immediately before this transfer-file replacement: 8217a2e8d19dc82e9fe3bfa7e4e1c1692d0b7941 (commit message: Remove FPS and label Floating Fan Speed as F). Recursive tree is complete/not truncated: 67 entries, 49 blobs and 18 trees. The commit was made directly on main; no branch or PR was created.
- Latest verified release remains Build #69 / run 38896502185 from release/source commit 01212c32a802ca0e67f559307fe4e19a667489c6. It passed all 21 release workflow steps: architecture/security audit, dependencies, Dart analysis, 88/88 Flutter tests, native FPS parser/watchdog JUnit, obfuscated APK, V1/V2/V3 signing/certificate, source ZIP, Release publication and downloaded-asset checks. Those results apply to the prior FPS-enabled source, not current main.
- Build #69 APK SHA-256: 40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102; matching source ZIP SHA-256: 1ab19e552c128d09773794738a6a4340abfa82086fa83f2d7e883ed62f60a699. Current release tag jexfyz-latest still targets Build #69 and has exactly one APK plus one source ZIP. Do not label that release as containing the FPS-removal change.
- The current main commit removes FPS/Shizuku runtime integration and switches Floating Monitor to six metrics B/H/V/A/P/F, with F=Fan Speed. New source/tests/workflow have NOT RUN / NOT BUILT; only static source/cross-file audit was performed here.
- Branches: diag/latest-stable-v16, diagnostic/v1.6-heap-check, fix/adaptive-power-sequencing, main, tmp-jexfyz-v5-test. Open pull requests: zero.
- Dedicated Firmware repository TenzoNkz/JEXFYZ-Firmware remains BIN-only: exactly JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Source-to-BIN provenance remains unverified. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## 2. App identity, workflow, latest release versus current source

- App name JE Cooler, in-app brand/header JE X FYZ; Android package com.horizontalzzz.jexfyz; pubspec version 1.0.0+3, minimum SDK 24. Preserve Android Gradle versionName exactly as Telegram @horizontalzzz. Toolchain: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Only active build workflow: .github/workflows/jexfyz-app-build-trigger.yml, current blob 8a8533aff7e0e0e01412bf522e1966e81aa1a39f. It listens only to issue opened/reopened and checks repository owner, exact title JE X FYZ — EKSEKUSI BUILD APP TRIGGER, and token JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1. Normal push/PR never launches a release. The Android unit-test/compile gate remains in the workflow.
- Release jexfyz-latest remains the Build #69 release with exactly two verified assets:
  - JEXFYZ-release.apk, asset 647189019, 54,636,716 bytes, SHA-256 40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102.
  - JEXFYZ-corresponding-source.zip, asset 647189016, 2,877,171 bytes, SHA-256 1ab19e552c128d09773794738a6a4340abfa82086fa83f2d7e883ed62f60a699.
- Both Build #69 assets were re-downloaded and verified with V1/JAR, V2 and V3 signing and the official certificate. Certificate SHA-256 is dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0. These are prior-release results, not a build result for commit 8217a2e8d19dc82e9fe3bfa7e4e1c1692d0b7941.
- Keep normal push/PR from producing an APK. Do not run App Build unless the user separately issues @Thinking Eksekusi Build App!. This FPS-removal execution did not trigger a build.

## 3. Current source fingerprints

- Current main commit for FPS removal: 8217a2e8d19dc82e9fe3bfa7e4e1c1692d0b7941. Current source changes remain NOT YET BUILT/TESTED.
- Current implementation/test blobs:
  - lib/main.dart: d24885cf0a40472b9fb23ee6ce73ad772ae73672 (unchanged).
  - lib/floating_monitor.dart: 31b45ea08b08ac7fc25ebd991dca873b889fdd14; six metrics and schema-v2 migration.
  - lib/app_settings.dart: 20f1ce0f838345c9eee4cbacde22255cb7852435; FPS/Shizuku status strings removed.
  - android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: 2d47a1ca766e454318e3c33911ffd7a7da234dbf; native overlay retained, sampler removed, F renders Fan Speed.
  - android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt: bd17c34211e8eb5c4723e06937ae47f0071b5e8b; permission/status bridge removed, overlay channels retained.
  - android/app/src/main/AndroidManifest.xml: c374b5d3ad6448b8b3e99a420ed7e8c49d38497a; Shizuku provider/query removed.
  - android/app/build.gradle: 060cdd36a4f7d4d2fa4c97a1b6a15954b8355350; Shizuku API/provider and unused native JUnit dependency removed.
  - .github/workflows/jexfyz-app-build-trigger.yml: 8a8533aff7e0e0e01412bf522e1966e81aa1a39f; FPS/Shizuku-specific audit and source-archive expectations removed, Android compile/test gate preserved.
  - test/widget_test.dart: 4e5a6d4fdc02e39ba5420a12cad9c39f9f82882e.
  - test/floating_monitor_layout_contract_test.dart: 87e805095202ac3edfe55b9aeb3138c7c6886375.
  - test/v6_6_qc_contract_test.dart: 083e0d19389c235b84f9785ee665d8ed8789e37f.
  - test/app_protocol_notify_contract_test.dart: 92214dd90178c705844d3979d3f8f7bd17bcc4b8.
  - test/firmware_touch_adaptive_sync_test.dart: 2d3fea509343a03b8d23623f4dcb2dd7fd972d39.
- Removed active paths: FpsShizukuUserService.kt, FpsTimeStatsParser.kt, FpsSamplerWatchdogPolicy.kt and both native FPS JUnit files; IFpsShizukuUserService.aidl; android/app/src/main/assets/licenses/shizuku-api-MIT.txt; test/shizuku_fps_contract_test.dart; third_party/Shizuku-API-MIT.txt; third_party/THIRD_PARTY_NOTICES.md. Verified recursive tree contains no path with FPS/Shizuku names.
- Canonical docs at the end of the source commit: APP_BUILD_REPORT.md 9d624ac13ddac291ef401d547a199ab2a85838a6; PROJECT_STATE.md ffe29d66737613fefed1538723ad1ee696656882; MEMORY_INDEX.md 4e7d6f60a913aea3894a702e7a95c564c633d209; BUILD_NOTES.md cbf3a47c10a6c5ac26bc56615b6f1d4fb244222a; HANDOVER.md 01eb22ec6d24a4abb70ad2d6d413aecfe8ab9cc0; APP_NOTES.md 6047ec51db902883d308ee62e9aec637c1535634; CHANGELOG.md 66d2d274ababed3b9551f04a48019d1859c32079; README.md 181a01cb5e1124f91e8fa66801ccff83d5e8585a; CHAT_RULES.md 3ca9f302419215b7036d3b8062e2068ea22edf2f; CHAT_TRANSFER_PROMPTS.md 91a5167f6c3dc6c3a3f66f5cef4e99b4c19d9ab3.
- Build report remains untouched because no Build App attempt was made. Old Build #63/#64 failures and repairs remain in APP_BUILD_REPORT.md; Build #69's old-source pass remains the latest release record.

## 4. Current Home indicator and animation contracts

- Disconnected telemetry remains unknown (`--`) and must not turn indicator/icon text black or generic grey. Keep each metric's lowest semantic accent as the fallback; do not imply that physical outputs are ON/OFF from an accent color.
- Battery temperature: Ice Blue at or below 30°C; smooth cyan/amber/orange transition through the 30–40°C band; Burning Red at or above 40°C. Battery thermal fill maps to 30–40°C. Battery warning/fire threshold remains exactly 40°C.
- Hotside temperature: Ice Blue at or below 30°C; smooth transition above 30°C; Burning Red at the currently configured Hotside Limit. Visual color never changes or replaces Firmware thermal protection.
- Manual voltage text/accent is 5V red, 9V green, 12V blue. Unknown/disconnected voltage falls back to the 5V red accent.
- Approved JE X FYZ grille is a symmetrical square 1:1 white geometric grille with central purple X (not HZ) and four corner mounting holes. Preserve the original interior pattern/frame; remove only the two small midpoint protrusions on the left/right outer sides when explicitly requested. Flat 2D/print-ready only: no shadows, bevels, faux depth, gradients, textures or invented details. “Enlarge only” means scale the existing design, not redesign.
- The current source restores Build #54 `_JexIconPainter` drawing geometry and blends active effects with the current activity controller. Existing Fan phase/coast behavior and Peltier retargeting are retained. The source has not been rendered on-device, so smoothness is not yet device-verified. These are UI illustrations, not live RPM/ice measurements.
- Build #69 compiled the prior source and passed 88/88 Flutter tests, native parser/watchdog JUnit and release checks. The new FPS-removal source has NOT BEEN BUILT; phone-side rendering, animations and transition smoothness remain NOT DEVICE-VERIFIED.

## 5. Floating Monitor presentation and current source state

- Supported metrics are exactly B/H/V/A/P/F: Battery Temperature, Hotside Temperature, Voltage, Adaptive, Peltier and Fan Speed. F now means Fan Speed; there is no active FPS metric or Shizuku/FPS access card.
- Persisted metric schema v2 handles older schema-v1 configuration: old F (FPS) is discarded; old S (Speed/Fan Speed) maps to new F. The migration is serialized in FloatingConfig and the six-metric config is sent to native overlay before enabling/restoring it.
- Display Style was removed earlier; Letters remains the only style and persisted legacy Icons values normalize to Letters.
- Size is 0.30×–1.00× inclusive in 0.05× increments (14 intervals), default 0.60×. Slider, storage normalization, Flutter/native runtime size reconciliation, pinch scaling and native overlay bounds must agree.
- Opacity is 0–100% in 5% increments; show its current numeric value but no 50% midpoint label. Legacy persisted opacity values snap to the nearest 5%. Opacity changes the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical Letters rows share the same left edge. The overlay remains freely draggable; WindowManager gravity is TOP | START and saved coordinates remain intact.
- Fan Speed preserves existing firmware telemetry/control behavior. While connected, display the live speed when Fan is ON and localized OFF/MATI when Fan is OFF. While BLE is disconnected, display unknown (--), never stale physical state.
- Flutter regression tests cover the old schema migration, six-metric order, F=Fan Speed and FPS/Shizuku UI retirement. They have NOT RUN. Build #69's previous tests were run against the old seven-metric/FPS-enabled source.

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
- Build #69 was App-only. No Firmware source/BIN, Firebase metadata, OTA, flash or physical device operation occurred in this execution.

## 7. Current repair scope and unverified points

- User decision (2026-10-16): remove FPS after repeated F:--/Shizuku UserService failures rather than continue to pursue device-specific foreground sampler behavior. This decision is implemented in source commit 8217a2e8d19dc82e9fe3bfa7e4e1c1692d0b7941.
- Native FloatingMonitorService was narrowed to overlay lifecycle, configuration, telemetry and rendering; MainActivity retains the overlay MethodChannel and removes Shizuku/FPS permission/status methods. Manifest/Gradle remove Shizuku provider/dependencies. FPS sampler classes, AIDL, native FPS JUnit, Shizuku Dart contract test and license/notice files were deleted.
- Floating Monitor schema version 2 prevents saved F (FPS) from becoming a fabricated fan speed and migrates saved S (Speed) to F. No Fan PWM, firmware control, BLE protocol or telemetry production changes were made.
- Workflow security audit checks that retired FPS/Shizuku files are absent and that metric F is the native Fan Speed value. The issue/title/token release guard and native Android unit-test/compile gate remain intact.
- Static source and cross-reference audit was performed. Flutter/Dart tests, Dart analysis, native compile/tests, Android release build/signing, source-archive packaging, APK publication and physical overlay/telemetry checks are NOT RUN for the current source. Only the separately authorized @Thinking Eksekusi Build App! can trigger App Build.
- No Firmware source/BIN, Firebase metadata, OTA, flash, physical device operation or Build App workflow was changed/run. Firmware V6.6 remains user-accepted final; the artifact repository remains BIN-only.

## 8. Durable App/design decisions, failures and evidence boundaries

- Main UI follows the Horizon Cooler direction: dark header, white rounded content panel, compact cards, VOLTAGE/ADAPTIVE tabs and cooler image on the right. Intended menu hierarchy is VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE with compact/sideways submenus. Preserve approved visual identity and make only requested narrow edits.
- The LED color picker uses 36 curated hue-ordered presets with localized names and no HEX labels. Swatch taps update only a local draft; explicit Select sends confirmed COLOR, Cancel discards it, and outside taps/system Back do not dismiss the dialog. Brightness remains the single hardware intensity control; preview visibility stays vivid at low hardware brightness and must not imply physical change before confirmation.
- Android notification small icon is the monochrome JE glyph on transparent background. Notification title is `JE X FYZ`, localized event/status belongs in the body, tapping opens JE Cooler, and the BLE foreground-service notification must not have an empty body.
- Home painter geometry was restored from Build #54 and built in Build #67; phase-continuous Fan rotation/coast, smooth active-effect blending and Peltier retargeting are retained. Exact phone-side icon shape, animation smoothness, color rendering and overlay geometry remain NOT DEVICE-VERIFIED.
- Build #63 was a genuine failed attempt: 87 passed/1 failed because of a stale TimeStats layer-matching assertion. Build #64 passed Flutter tests but failed native JUnit at JetifyTransform due to a 2 GiB Gradle heap (`Java heap space`). The typed-layer assertion and heap increase to 4 GiB are documented in `APP_BUILD_REPORT.md`; Builds #65–#69 passed 88/88 plus native JUnit and the complete release pipeline. No test/gate was removed or weakened.
- Evidence labels: CURRENT/VERIFIED = live source/GitHub refs and the older verified Build #69 release; SOURCE-CONTRACT CI = tests actually executed on the matching commit; USER-REPORTED = user says V6.6 compiled and two same-version online OTA updates succeeded; UNVERIFIED = current six-metric source build/tests, phone overlay rendering, BLE/hardware/OTA behavior; HYPOTHESIS = brownout or whether CA vs NTP individually caused the earlier OTA failure; HISTORICAL/SUPERSEDED = retired FPS investigations and older V5/V6/build states.
- Local Markdown-link audit has not been rerun during this FPS-removal source task. Some root-relative links in the frozen archive/*.md snapshots do not resolve inside archive/; archive blobs remain byte-for-byte unchanged. Use canonical root files and do not treat archived V5/V6.1/V6.2/V6.3 CURRENT blocks as live truth.

## 9. Authorization protocol and next validation

- `@Thinking Diskusi!` means read-only discussion.
- `@Thinking Eksekusi Full!` authorizes scoped source/docs/tests changes directly on main but does **not** authorize App release/build, Firmware compile, BIN/Firebase/OTA/flash/device operations.
- `@Thinking Eksekusi Build App!` alone authorizes the complete App analysis/test/build/sign/release pipeline. Use the guarded issue trigger with exact owner/title/body token; do not bypass its gate or add push/PR build triggers.
- Do not change `versionName "Telegram @horizontalzzz"`, signing material or `google-services.json` content. Do not mutate Firmware/BIN/Firebase/OTA/hardware without separate explicit authorization.
- Build #69 remains the latest successful release for the old FPS-enabled source, with functionally unchanged source from Build #67/#68: TimeStats patch f527b5ec82b7a3e4f563eb28f4ac50438ed6b620, timeout fix 34880ba490bfbd0d38c4b10ab69a683ca7b4a29d, and sampler watchdog 946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46. Current main is newer and not built.
- Build #69's sampler repair and five policy tests are historical and no longer part of active source. The latest current main commit removes that feature; no duplicate Build App run was fired, because that command was not authorized in this task.
- Next validation: run @Thinking Eksekusi Build App! as a separate command. Verify the new static audit, Flutter analysis/tests, Kotlin compile gate, signed APK/source archive and Release download. Only after the new APK is available should the user validate the six-metric overlay and live Fan Speed telemetry on-device; FPS diagnostics are retired.
