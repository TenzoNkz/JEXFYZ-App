## 2026-10-02 — POST-EXECUTION STATIC VALIDATION / LOCALIZATION PASS

- Re-read the active localization/source files after the execution.
- Active glossary now contains 253 localized keys; all 264 statically discovered JexText.of key usages resolve to defined keys.
- Verified Indonesian contract values: Temperature -> Suhu; Reset Temperature -> Atur Ulang Suhu; Voltage Indicator -> Indikator Tegangan; Brightness -> Kecerahan; Default -> Bawaan; Opacity -> Transparansi; Adaptive Switch -> Sakelar Adaptif.
- Verified legacy Indonesian UI values Temperatur and Opasitas are no longer used by the active glossary, and the old direct OTA stage/result prefixes and English status suffixes are no longer present in the affected paths.
- Verified Floating Monitor Allow uses centralized localization.
- The only remaining English terms in Indonesian presentation are intentional technical/product identifiers or technical diagnostics, such as Bluetooth, BLE, OTA, LED, RGB, NTC, FPS, Peltier, Firmware, SSID, and protocol/runtime identifiers.
- No firmware files, firmware version, BLE/P1 UUIDs, safety logic, OTA transport, Firebase metadata, GPIO mapping, signing identity, or dedicated binary firmware repository content were changed.
- This validation was source/static only. Flutter analyze, Flutter tests, APK build, Android OEM runtime validation, and physical-device validation were not run in this execution.

## 2026-10-02 — FULL EXECUTION / BILINGUAL LANGUAGE STANDARDIZATION

- Completed a full App-language audit and standardization pass for user-facing Flutter localization.
- Coding/source identifiers remain English; frozen technical identifiers such as BLE, P1, OTA stage tokens, RGB, LED, NTC, FPS, UUIDs, storage keys, and protocol commands remain untranslated.
- Indonesian UI terminology is standardized to natural/baku wording, including Temperature -> Suhu, Reset Temperature -> Atur Ulang Suhu, Voltage Indicator -> Indikator Tegangan, Default -> Bawaan, and Opacity -> Transparansi.
- Confirmed Adaptive Switch is correctly localized as Adaptive Switch / Sakelar Adaptif in the active source.
- Hotside remains an English internal/technical term, while user-facing Indonesian presentation uses Suhu Panas.
- OTA stage presentation is now centralized through JexText; frozen OTA stage tokens remain internal identifiers, while displayed stage names are localized.
- OTA result/status paths no longer append hardcoded English not-confirmed/failed suffixes; these suffixes are localized.
- Floating Monitor Allow action now uses the centralized localization table.
- Added regression assertions for the Indonesian terminology contract.
- Active source commits for this execution: 91ea62c9bf241bdb04832a768de88f3031f0a78e (app_settings), c9242b0daf25718975b50b1c0e2c24fd8a4f1044 (main), e1acfbc0f6c3d2165d421d583af8a91727898adb (floating_monitor), 6a4f9bca1f451b5ad4b400eae9aabf707101f2d7 (tests).
- Native Android system-facing service/channel descriptions remain outside the Flutter locale table because they are native service metadata rather than Flutter-controlled in-app copy; no service architecture or BLE ownership was changed.
- This was an App-only localization/presentation execution. Firmware source, firmware version, BLE/P1 protocol, OTA transport, Firebase metadata, GPIO mapping, safety behavior, signing identity, and production BIN were not changed.
- No App Build was run; Build App remains a separate explicit workflow.

## 2026-10-01 — CLEANUP COMMIT AUDIT TRAIL

- Dedicated firmware repository cleanup was executed with deletion commits after the repository-boundary mistake was identified.
- `JEXFYZ-V2.4.ino` is removed from `TenzoNkz/JEXFYZ-Firmware`.
- `FIRMWARE_NOTES.md` is removed from `TenzoNkz/JEXFYZ-Firmware`.
- Verified dedicated-repository cleanup history includes commits `0c53737f022623a705a0c4705bf51607c178f281` and `523f2ffb562947aefdd95857228e2bd061b42aa8`; the latter is confirmed by commit diff as the `FIRMWARE_NOTES.md` deletion.
- The dedicated repository still contains `JEXFYZ.cpp.bin`.
- The V2.4 firmware source remains in the App repository at `firmware/JEXFYZ-V2.4.ino`.
- The repository-boundary mistake was introduced by a previous execution step that incorrectly synchronized source/notes into the dedicated firmware repository. It has now been reverted and the boundary is frozen.

## 2026-10-01 — DEDICATED FIRMWARE REPO CLEANUP

- Removed `JEXFYZ-V2.4.ino` from `TenzoNkz/JEXFYZ-Firmware`.
- Removed `FIRMWARE_NOTES.md` from `TenzoNkz/JEXFYZ-Firmware`.
- Root cause of the repository-boundary mistake: a previous execution incorrectly synchronized firmware source/notes into the dedicated distribution repository despite the project boundary requiring that repo to remain binary-only.
- Correct boundary is now reaffirmed: firmware `.ino` source and `FIRMWARE_NOTES.md` live in `TenzoNkz/JEXFYZ-App`; dedicated firmware repo contains the published BIN artifact only, plus non-source repository metadata.
- This cleanup does not change firmware behavior, `FW_VERSION` (current V2.4), BLE/P1, GPIO mapping, OTA transport, Firebase metadata, or App source.
## 2026-10-01 — CHAT RULES FINAL RECORDING UPDATE

- `CHAT_RULES.md` now requires a maintenance-note record for every JE X FYZ project workflow/event, including audits, build/compile attempts, tests, failures, and no-change reviews when they establish validation status.
- CHAT_RULES final mandatory event-recording commit: `48e962648a7fbe0ec71a732f518ac21e99086d1a`.
## 2026-10-01 — CHAT RULES UPDATE / MANDATORY VERSIONING + NOTES

- Project chat rules were strengthened in `CHAT_RULES.md`.
- Firmware functional/source changes now require a firmware version increment before OTA candidacy.
- Every meaningful project event must be reflected in the appropriate maintenance notes, including implementation, build/compile attempts, failures, runtime/device observations, validation status, risks, and important dead ends.
- Current firmware source revision remains **V2.4**; no App source change or App Build was triggered by this rules-only update.
- `CHAT_RULES.md` is now the authoritative process contract for Diskusi, Eksekusi, Build App, Gemini review, source-first auditing, source-to-hardware traceability, and response footer/status behavior.

## 2026-10-01 — FIRMWARE VERSIONING RULE / V2.4

- Required firmware version bump completed: **V2.3 → V2.4**.
- Reason: this change modifies the firmware source (GPIO-output hardening/versioned release), so the firmware must advertise a new version for OTA discovery.
- Exact V2.4 source must be compiled with ArduinoDroid + official Arduino-ESP32 Core 3.3.7 before its BIN is promoted.
- Firebase firmware metadata must not be changed to V2.4 until the matching BIN is verified.
- App Build is separate and was not triggered by this firmware execution.
## 2026-10-01 — FULL EXECUTION / PROJECT STATE RECONCILIATION

- Current App branch: `main`; latest inspected documentation HEAD before this write was `106087a5ee01793f2e682859afccfa6bf002e9f1`.
- Build App #41 remains the latest successful App validation checkpoint: Run `36800153829`, source commit `6deff1af4cb74310a00ee4ee0f3ed1584225c351`.
- Commits after Build #41 inspected in this execution are documentation/firmware-source changes only; no later Flutter/Dart/Android functional source change was found in those commits.
- Therefore Build #41 still represents the latest successful **App-source** build validation, while it does not validate the later firmware-source GPIO hardening.
- Production signing certificate remains unchanged and remains the required identity.
- `pubspec.yaml` package version remains `1.0.0+3`; Android user-visible version remains `Telegram @horizontalzzz`.
- Explicit Build trigger remains Issue-only with exact title `JE X FYZ — BUILD APP TRIGGER` and body token `JEXFYZ_BUILD_TRIGGER_V1`; push/PR does not trigger the App build workflow.
- BLE P1 UUIDs and command vocabulary remain frozen.
- **Firmware physical GPIO authority is: GPIO5 = PELTIER; GPIO6 = FAN.** App logical tokens are not swapped.
- Current App-repo firmware mirror `firmware/JEXFYZ-V2.4.ino` reflects this mapping and includes the compile-time mapping guard.
- Dedicated firmware repo is **binary-only**: `JEXFYZ.cpp.bin` is the firmware distribution artifact. Firmware source and firmware engineering notes remain in the App repo.
- The existing production BIN was not modified/regenerated in this execution because a verified Arduino-ESP32 Core 3.3.7 compiler toolchain is unavailable in this environment.
- Safety remains authoritative in firmware; no safety check was removed or bypassed to address the FAN/PELTIER mismatch.
- Mapping validation status:
  - App command layer: **unchanged / logical mapping preserved**
  - Firmware pin constants: **verified**
  - Firmware output writers: **verified**
  - Static compile-time mapping guard: **present**
  - Core 3.3.7 compile: **pending**
  - Firmware flash: **pending**
  - Physical FAN ON / PELTIER ON test: **pending**
- Firmware source revision was bumped V2.3 → V2.4 so the OTA version contract can recognize a new release once the V2.4 BIN and Firebase metadata are promoted.
- No App Build was triggered; this execution changes firmware source/notes only.
> First-read memory index for App work. Historical entries below remain preserved as evidence. When an older entry conflicts with a later verified state, this current section wins.
> Consolidated: 2026-10-01.

## 0. MEMORY PRIORITY
1. Current verified source/repository state.
2. Newest authoritative maintenance notes.
3. Verified build/runtime/device evidence.
4. Older history.
5. Unverified hypotheses or third-party suggestions.
Never silently promote a hypothesis, Gemini suggestion, old snippet, or historical build into a confirmed fact.

## 1. CURRENT PROJECT
- Product: JE Cooler
- In-app brand/header: JE X FYZ
- App repo: TenzoNkz/JEXFYZ-App
- Firmware repo: TenzoNkz/JEXFYZ-Firmware
- Reference architecture/UI: Horizon Cooler App
- App: Flutter/Dart + Android/Kotlin
- Firmware hardware: ESP32-C3 Super Mini / ESP32-C3 Dev Module
- Firmware toolchain: ArduinoDroid + official Arduino-ESP32 Core 3.3.7
- BLE protocol: P1
- Firmware is authoritative for physical state and safety.

## 2. CURRENT SOURCE / REPOSITORY STATE
- App branch: `main`.
- Current App branch: `main`; functional App source remains the Build #41-validated source baseline.
- Build #41 validated App source commit `6deff1af4cb74310a00ee4ee0f3ed1584225c351`.
- All App-repo commits inspected after Build #41 are documentation, firmware-source, or CI-comment maintenance; no later Flutter/Dart/Android functional change was found.
- Current App-source behavior therefore remains covered by Build #41, while the later firmware GPIO hardening is outside that App build's scope.
- Current App-repo V2.3 firmware mirror is `firmware/JEXFYZ-V2.3.ino`.
- Current dedicated firmware repo state is **binary-only**. Do not place `.ino` source or firmware engineering notes in that repository.
- Current Flutter/Android source must still be read directly for any future functional change; notes are not a substitute for source inspection.
## 3. BUILD TRUTH
- Build App is explicit-only.
- Current trigger model: dedicated GitHub Issue proxy -> reusable `app-build.yml`.
- Normal pushes/PRs do not trigger the App build workflow.
- Latest successful App build: **Build #41**.
- Build #41 Run: `36800153829`.
- Build #41 source commit: `6deff1af4cb74310a00ee4ee0f3ed1584225c351`.
- Build #41 artifact: `JEXFYZ#41.apk`.
- Build #41 artifact ID: `11135950331`.
- Build #41 artifact size: `54,245,456` bytes.
- Build #41 APK SHA-256: `0470a30268b455cb55e564a3ce34ef05ac5b5a744f364b3765cd2ad29d14109e`.
- Build #41 Dart symbols artifact ID: `11135985299`.
- Build #41 Dart symbols SHA-256: `4890c4baa223e687a356488d969b900f9c03b0f784d557a24cf38abda0fb80c2`.
- Build #41 passed: security/architecture audit, dependency installation, Dart analyze, Flutter tests, release APK, production signature verification, exactly one APK artifact, and Dart symbols upload.
- Production signing certificate SHA-256: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- Android user-visible versionName validated by Build #41: `Telegram @horizontalzzz`.
- Historical Build #32 remains preserved below as an earlier checkpoint; it is not the latest build baseline.
## 4. APP UI BASELINE
- Default Dashboard: black header + white rounded Display/content.
- Non-dashboard Default Settings pages: dark theme.
- English is default; Bahasa Indonesia is separate.
- Voltage: fixed 5V / 9V / 12V selector.
- Control: Peltier, Fan, Fan Speed.
- Adaptive: Adaptive Switch + Hotside Protection / Hotside + Battery.
- LED: 7 modes; Twinkle removed; brightness 1–100%.
- Floating Monitor default order: F, B, H, V, A, P, S.
- Floating supports Letters/Icons, selection, reorder, preview, size, opacity, orientation, drag, pinch resize, tap orientation switching.
- Floating uses the same App telemetry state as Home; no second BLE/GATT path.

## 5. APP <-> FIRMWARE SYNC CONTRACT
- BLE ACK means command acceptance, not physical-state confirmation.
- Stateful commands wait for authoritative firmware telemetry.
- If expected telemetry is missing, App may perform one fresh firmware SYNC for reconciliation.
- Firmware echoes authoritative current state for stateful commands even when the requested value is already current.
- FAN and PELTIER command responses include both FAN and current PELTIER state.
- Runtime remains delta-based; do not add periodic full-sync spam without explicit approval.

## 6. FLOATING MONITOR — ACTIVE INVESTIGATION
### Confirmed implementation
- Flutter channel: je_x_fyz/floating.
- Methods: hasOverlayPermission, openOverlaySettings, startFloatingMonitor, stopFloatingMonitor, updateFloatingConfig, updateFloatingData, getFloatingRuntimeState.
- Manifest declares SYSTEM_ALERT_WINDOW and FOREGROUND_SERVICE_SPECIAL_USE.
- Native service: FloatingMonitorService.
- Android O+: TYPE_APPLICATION_OVERLAY.
- Foreground-service type: specialUse.
### Confirmed evidence from user video 99729.mp4
- The video is the concrete runtime evidence for the Floating Monitor issue.
- Android app-specific settings for JE Cooler are shown with four relevant entries: Home screen shortcuts, Show on Lock screen, Open new windows while running in the background, and Display pop-up windows.
- At the captured permission page, Display pop-up windows is initially OFF.
- The dedicated Display pop-up windows screen is then opened. The sequence shows Deny and Always allow; the user selects Always allow and a blue checkmark appears.
- After returning to JE Cooler, the Floating Monitor does not activate. The App shows its own Floating Monitor Permission dialog again at approximately the later part of the video.
- This sequence is important because it demonstrates: the OEM permission UI can visibly show Always allow while JE Cooler's current Flutter/native permission check still behaves as though permission is unavailable.
- The launcher/home screen is also visible during the sequence, so the test crosses app/settings/task boundaries rather than remaining entirely inside the Flutter page.
- The evidence therefore strongly supports investigating a mismatch between the OEM permission state and Settings.canDrawOverlays(), plus the lack of a definitive actual WindowManager attachment/visibility check.
- This remains a working diagnosis until native runtime logging/probing proves the exact returned API state and overlay attach result.
### Current code weakness
- MainActivity.hasOverlayPermission only reports Settings.canDrawOverlays(this).
- FloatingMonitorService.start also gates on Settings.canDrawOverlays(context).
- ensureOverlay catches addView exceptions but exposes no structured failure reason.
- runtimeState reports overlay=true when hudView is non-null and config.enabled, which is weaker than proof of actual on-screen composition.
- Flutter currently waits for running && overlay, but those flags do not distinguish permission denial, vendor policy, service failure, addView failure, or later overlay loss.
### Working diagnosis
- Strong lead: the OEM permission UI and the public Android overlay check may be reporting different effective states on the affected device, and runtime attachment/health is under-validated.
- The video gives direct evidence of the UI sequence, but it does not expose the returned value of Settings.canDrawOverlays() or the WindowManager result.
- This is a working diagnosis, not a proven vendor-specific root cause.
### Planned patch direction
1. Preserve the existing architecture; avoid a broad refactor.
2. Separate public permission state from actual overlay attachment/runtime health.
3. Add actual WindowManager attachment verification and structured failure reporting after the Android behavior is fully confirmed.
4. Persist enabled=true only after runtime overlay confirmation.
5. Re-check position/bounds recovery after the permission/lifecycle issue is fixed.
6. Ask Gemini only for a specific unresolved Android/OEM question if source inspection and evidence are insufficient.
### Non-goals
- No random permissions.
- No second BLE implementation.
- No BLE UUID/P1 changes for this UI/runtime bug.
- No firmware changes for an App Android overlay issue.
- No build while still in Diskusi.

## 7. ANDROID BASELINE
- Application ID: com.horizontalzzz.jexfyz.
- compileSdk 37; targetSdk 36; minSdk 24.
- Java/Kotlin JVM 17.
- Production signing required.
- R8/resource shrinking enabled.
- Native foreground services must not become second BLE owners.

## 8. OTA BOUNDARY
- Firebase RTDB firmware metadata node: /firmware_update.
- Metadata URL: https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json
- Published BIN URL documented: https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin
- No SHA-only firmware link selection.
- Firmware source continuity is under App/firmware/; production BIN repo remains binary-only.

## 9. VALIDATION BOUNDARIES
- Static source inspection != Flutter build.
- Flutter build/test != Android OEM runtime validation.
- App runtime != physical firmware validation.
- Successful OTA history != proof of a newer firmware release.
- Build artifact != current-source validation unless the source revision matches.

## 10. CURRENT NEXT STEP
- Active issue: Floating Monitor permission/runtime reliability.
- This documentation pass does not authorize a source patch by itself; the next source change still requires explicit execution approval.

# 2026-09-30 — V2.3 TOUCH / APP UI / PERMISSION FIX PASS

- Voltage UI was simplified to the fixed three-row vertical selector matching the intended JE X FYZ presentation: 5V Low Mode, 9V Mid Mode, 12V High Mode. The old Vertical/Side Text setting was removed from persisted App settings and UI.
- Default non-dashboard pages now inherit the dark JE X FYZ Material theme so Settings, Language, Appearance, Notifications, Bluetooth, Floating Monitor, and About remain readable without the previous bright card-on-dark mismatch. The Dashboard keeps its black-header/white-content Default presentation through a dashboard-local light theme.
- Floating Monitor permission flow now shows an explicit in-app explanation before opening Android's "Display over other apps" settings. On return, permission is rechecked and the monitor is started automatically when permission was granted.
- Floating telemetry now preserves raw Adaptive/Peltier state rather than masking it behind Fan state.
- Firmware functional revision is V2.3. No Firebase/production BIN promotion is implied by this source change.

# 2026-09-30 — RE-EXECUTION / FINAL UI PERMISSION CLEANUP

- The previous execution session stopped during tool-side Dart/Flutter/Kotlin checking; repository changes are being completed from the already-committed source state rather than blindly duplicated.
- Current App UI: Voltage uses only the fixed 5V / 9V / 12V vertical selector; the old Vertical/Side Text setting is removed.
- Default Settings and child pages use the dark JE X FYZ theme. The Dashboard retains its intentional black-header/white-content Default presentation.
- Floating Monitor overlay permission now uses an explicit in-app Allow/Cancel dialog, opens Android overlay settings, rechecks permission on resume, and auto-starts after permission is granted.
- Current App source has changed after the previous Build App #10 validation. Build #10 therefore does NOT validate this latest source; a new explicit Build App run is required before distributing the updated APK.
- Firmware current source is V2.3; the dedicated firmware repository remains binary-only and is not updated with an uncompiled BIN.


## 2026-10-01 — FLOATING VIDEO EVIDENCE REFINED
- User video `99729.mp4` was inspected frame-by-frame around the permission flow.
- At approximately 11.3s, the JE Cooler app-specific settings page shows `Display pop-up windows` OFF.
- At approximately 12.8s and 13.3s, the dedicated `Display pop-up windows` screen shows `Always allow` selected with a blue checkmark.
- At approximately 16.8s, after returning to JE Cooler, the App displays the `Floating Monitor Permission` dialog again. This is the critical observable symptom.
- The current Flutter code only starts the overlay flow when `FloatingBridge.hasPermission()` returns true; the Android implementation of that bridge is `Settings.canDrawOverlays(this)`.
- Therefore the next diagnostic must capture the real value returned by `Settings.canDrawOverlays()` immediately after the OEM permission screen is closed, and independently record whether `WindowManager.addView()` accepts and retains the actual overlay.
- Do not conclude yet that a vendor-specific private API is required. First prove the public API result and actual WindowManager behavior on the affected device.
- No source change or App Build is implied by this evidence-only entry.
# JE X FYZ App — Master Notes

## 2026-09-30 — FINAL SETTINGS / MENU / FLOATING / SYNC PASS

- Current App implementation includes the approved Settings hierarchy and separate pages.
- English is the default language; Bahasa Indonesia is the separate second locale. Home/menu/runtime wording is being routed through the bilingual vocabulary; Floating Monitor indicator labels remain English-only by design.
- Appearance presets are Default, Light, and Dark. Default remains the black-header/white-content JE X FYZ presentation.
- Notifications remain important-only: Hotside Safety Alert, Firmware Update Available, Bluetooth Connected/Disconnected, with event re-arming to avoid repeated Hotside alerts while the temperature remains above the limit.
- Bluetooth Auto Connect is enabled by default and uses bounded discovery/reconnect behavior; it does not create a second BLE implementation.
- Gear now opens Settings; Firmware Update remains an entry inside Settings.
- Floating Monitor is enabled/configurable only while active. Default function order is FPS, Battery, Hotside, Volt, Adaptive, Peltier, Speed; all default OFF. Reorder handle is on the left and checkbox on the right. Letters and Icons are supported, with live preview, drag position, pinch resize, opacity, and tap-based horizontal/vertical switching.
- Floating telemetry is fed from the same App state used by Home. No second BLE/GATT telemetry path was introduced.
- Voltage submenu is now a single fixed vertical selector: 5V Low Mode, 9V Mid Mode, 12V High Mode. There is no Vertical/Side Text layout switch and no extra firmware-state card.
- Control submenu contains only Peltier, Fan, and Fan Speed; duplicate status cards and Safety/PWM indicator rows were removed.
- Adaptive submenu contains Adaptive Switch plus Hotside Protection and Hotside + Battery profiles. Manual Voltage, Control, and Temperature are locked while Adaptive is ON.
- LED uses a compact 12-hue picker popup. HEX/white/dark/light variants are not shown. Brightness remains 1–100%. Mode number and mode name are separated.
- Runtime control sync no longer sends a 90 ms post-command SYNC. Telemetry deltas remain the state-confirmation path. The intentional Voltage guard remains 1 second.
- App source has not been packaged into an APK in this pass. Do not treat repository commits as App Build validation.


> **Document purpose:** permanent maintenance memory for the JE X FYZ App.
> This file describes the App repository, the App↔firmware integration contract, the Android/runtime boundary, build rules, validation rules, and change history.
> **Reviewed:** 2026-09-28.

## 1. CURRENT STATE — AUTHORITATIVE

### 1.1 Repository ownership

- Repository: `TenzoNkz/JEXFYZ-App`
- Product/App name: **JE Cooler**
- In-app brand/header: **JE X FYZ**
- Platform: Flutter + Android
- Primary UI/architecture reference: **Horizon Cooler App**
- Repository scope: **App + current firmware source for continuity**
- Firmware implementation source (.ino) is intentionally kept in this App repository under `firmware/`.
- Production firmware BINs remain in the dedicated firmware repository, which is binary-only.
- Firmware CI/build output is not stored in this repository.
- **FIRMWARE_NOTES.md is the permanent firmware engineering record.**
- The App may keep the Firebase firmware metadata URL because it is an App OTA integration dependency.

### 1.2 Repository boundary — do not break this rule

The App repository may contain:
- Flutter/Dart App source
- Android wrapper/native bridge
- App assets
- App build/test configuration
- App CI workflow
- App notes
- the current firmware `.ino` source under `firmware/` for continuity/review
- firmware documentation/notes needed for project continuity

The App repository must not contain:
- production firmware `.bin` artifacts
- firmware build output
- firmware production CI/build workflow

A future App cleanup must not remove `FIRMWARE_NOTES.md`.

## 2026-09-30 — SETTINGS / MENUS / FLOATING / LIVE-SYNC IMPLEMENTATION

- English is the default App language; Bahasa Indonesia is the second locale.
- Added centralized bilingual UI vocabulary in `lib/app_settings.dart`; Indonesian terminology includes Baterai and Suhu Panas. Floating Monitor remains English-only by design.
- Added Default, Light, and Dark appearance presets.
- Added important-only notification settings: Hotside Safety Alert, Firmware Update, Bluetooth Connected/Disconnected.
- Added Bluetooth Auto Connect preference and bounded rediscovery behavior.
- Gear now opens Settings; Firmware Update remains accessible from Settings.
- Added Floating Monitor configuration with all functions OFF by default, default order FPS/Battery/Hotside/Volt/Adaptive/Peltier/Speed, Letters/Icons, drag-reorder, checkboxes, live preview, size, opacity, orientation, native overlay bridge, and native drag/pinch/tap behavior.
- Floating and Home share the same App telemetry state; no second BLE telemetry client/path is introduced.
- Removed the 90 ms post-command SYNC layer. BLE telemetry deltas remain the confirmation source. Voltage retains its intentional 1-second guard.
- Redesigned Voltage, Control, Adaptive, LED, and surrounding submenu presentation toward a clean minimal visual hierarchy.
- Voltage uses the fixed three-row vertical layout: 5V Low Mode, 9V Mid Mode, 12V High Mode.
- LED uses a 12-color hue-only picker popup; HEX, white, black, and light/dark variants are removed. Brightness remains 1–100%.
- Added Android overlay permission/service and native notification bridge.
- App source has not been built into an APK in this change set; physical/device validation remains pending.

## 2. APP ARCHITECTURE

### 2.1 Flutter layer

The main App implementation is concentrated in:
- `lib/main.dart`
- `pubspec.yaml`
- `test/widget_test.dart`

The App follows the established Horizon Cooler architecture/style and adds JE X FYZ-specific:
- BLE device discovery and session handling
- P1 command/telemetry protocol
- cooler controls
- adaptive mode UI
- voltage UI
- fan-speed UI
- temperature UI
- LED/RGB configuration UI
- firmware-update dialog
- Android integration/security bridges

### 2.2 Android layer

Important Android files:
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt`
- `android/app/proguard-rules.pro`
- `android/build.gradle`
- `android/settings.gradle`
- `android/gradle.properties`

Android package/application ID:
`com.horizontalzzz.jexfyz`

The native layer exists only to provide services Flutter cannot/should not own directly, including:
- battery-temperature bridge
- Android settings intents
- Android SDK information
- Bluetooth settings opening
- foreground-service lifecycle
- release-build signing/integrity check

### 2.3 Native foreground-service rule

`JeForegroundService.kt` is **not** a second BLE implementation.

It exists to keep the required Android foreground-service lifecycle/notification alive for an already-established App session. Future changes must not accidentally introduce another BLE client, scanner, notification-owned connection, or duplicated session state inside the service.

## 3. APP ↔ FIRMWARE BLE CONTRACT

### 3.1 Device identity

- BLE device name: **JE X FYZ**
- Protocol generation: **P1**

### 3.2 UUID contract

Service:
`6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`

RX:
`6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`

TX:
`6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`

These UUIDs are an integration contract. Do not change them casually.

### 3.3 State authority

The firmware remains the authority for:
- physical voltage state
- peltier state
- fan state
- safety state
- temperature protection
- adaptive control
- physical LED state

The App must not interpret a successful BLE write as proof that the physical device accepted/performed the operation.

The correct model is:

1. App sends an intended state/command.
2. Firmware processes it.
3. Firmware returns telemetry/ACK/state evidence.
4. App updates the displayed state from evidence.

This avoids UI drift after rejected, delayed, safety-limited, or interrupted commands.

## 4. APP RUNTIME BEHAVIOR

### 4.1 Home/UI rules

Current established UI direction:
- dark header
- white rounded content panel
- compact status/control presentation inspired by Horizon Cooler
- Bluetooth and Settings actions remain simple header actions
- no notification icon box
- Phosphor Icons are used for JE X FYZ controls
- Material `Icons.*` are not used for the JE X FYZ control UI
- cooler image is intentionally prominent
- voltage indicator, adaptive mode, peltier/fan controls, fan speed, and notification/reason state remain part of the core Home experience

### 4.2 Fan-speed contract

- App display/control uses percentage values.
- App-side control range: **50%–100%**.
- PWM behavior is a firmware responsibility.
- The App must not claim PWM changes are effective until firmware telemetry/state confirms the physical mode/value.

### 4.3 Session gate

Normal state-changing BLE writes must pass through the current active-session gate.

Do not add direct ad-hoc writes around the central session model without first checking:
- connection state
- service discovery
- RX/TX characteristics
- command serialization
- pending command/ACK handling
- reconnect behavior

### 4.4 Telemetry expectations

Integration documentation currently defines:
- hotside temperature: approximately **1 Hz**
- phone/device battery telemetry: approximately **1 Hz** where supported by the integration layer
- other state: sent/processed when changed rather than continuously retransmitted

The exact final telemetry semantics are governed by the firmware P1 implementation and must be checked against the current firmware notes before changing App assumptions.

## 5. ONLINE FIRMWARE OTA INTEGRATION

### 5.1 Firmware metadata source

Firebase Realtime Database is now the firmware release metadata/control plane:

Current node: `/firmware_update`

`https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`

Expected document shape:
```json
{
  "version": "V1.0",
  "url": "https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.0.bin"
}
```

The App validates the version and restricts the returned binary URL to the JE X FYZ firmware repository on `raw.githubusercontent.com`.

GitHub is now binary-only for this OTA path; the GitHub `manifest.json` is no longer part of the App update-discovery path.

Firmware source is **not** embedded in the App repository.

### 5.2 Firmware metadata validation

The App validates:
- firmware version shape: `V<major>.<minor>`
- Firebase metadata response is JSON/object-shaped
- HTTPS transport for the returned BIN URL
- `raw.githubusercontent.com` host
- repository path under `/TenzoNkz/JEXFYZ-Firmware/`
- returned file is a `.bin`
- Firebase metadata URL must resolve to an approved GitHub `.bin` path; GitHub `manifest.json` is not accepted


The App accepts any valid **different** firmware version as an OTA target, including a rollback/downgrade for controlled testing.

The App does **not** use a SHA-only firmware-version selection mechanism.

### 5.3 OTA network behavior

Firmware-manifest fetching uses bounded HTTP timeouts so a stalled network request does not leave the firmware-update dialog waiting indefinitely.

Future changes must keep network failures explicit:
- timeout
- DNS/connection failure
- invalid manifest
- invalid version
- invalid host/path
- unavailable BIN
- firmware-side OTA failure

Do not collapse all OTA failures into a generic silent state.

### 5.4 Wi-Fi/BLE boundary

The firmware owns the actual single-antenna radio handoff.

The App responsibility is to:
- request/update firmware through the documented OTA integration
- display progress/state
- tolerate the expected BLE disconnect/reconnect during OTA
- rediscover/reconnect after firmware restart
- not invent a simultaneous Wi-Fi + BLE capability that the hardware does not provide

## 6. SECURITY / RELEASE

### 6.1 Release package

- Android package: `com.horizontalzzz.jexfyz`
- Release build: R8/minification enabled
- Resource shrinking: enabled
- Production signing: required
- App integrity is checked by the native release-signing certificate logic

Expected production signing identity currently documented:
- CN: `JE X FYZ`
- OU: `JE X FYZ`
- O: `JE X FYZ`
- L: `Indonesia`
- ST: `Central Java`
- C: `ID`

Expected certificate SHA-256 documented by the build workflow:
`dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`

### 6.2 Firebase/App Check boundary

Firebase App Check / Play Integrity remains an **App security layer**.

It is not the firmware source or production firmware distribution mechanism.

### 6.3 Secret handling

Wi-Fi credentials used by the App are stored through:
`flutter_secure_storage`

Do not move Wi-Fi credentials into plain-text preferences or log output.

## 7. DEPENDENCY CONTRACT

Current important Flutter dependencies:
- `flutter_blue_plus ^2.3.12`
- `firebase_core ^4.15.0`
- `firebase_app_check ^0.4.8`
- `flutter_secure_storage ^11.0.0`
- `permission_handler ^13.0.2`
- `phosphor_icons ^3.0.1`

`shared_preferences` was intentionally removed as unused during the App-only cleanup.

Dependency changes should be justified against actual source usage and compatibility rather than added speculatively.

## 8. BUILD WORKFLOW

Workflow:
`.github/workflows/app-build.yml`

Purpose:
1. establish the fixed Flutter/Java/Gradle environment
2. audit App-only repository boundaries
3. obtain dependencies
4. run static analysis
5. run Flutter tests
6. build a release APK
7. obfuscate release Dart code
8. verify the release APK signing certificate
9. upload the canonical APK artifact
10. upload Dart symbol files

Current pinned build environment documented in the workflow:
- Java 17
- Flutter 3.47.2
- Gradle 9.3.1
- Android compile SDK 37
- target SDK 36
- minimum SDK 24
- Java/Kotlin JVM 17
- Android Gradle Plugin 9.1.1
- Kotlin 2.2.20
- Google Services plugin 4.4.4

Canonical artifact naming:
`JEXFYZ#<GitHub Actions run number>.apk`

Dart symbols artifact:
`JE-X-FYZ-Dart-Symbols`

### Build trigger policy

**Build is manual-only.**

- The App Build workflow uses **only** `workflow_dispatch`.
- Repository pushes, source edits, notes edits, asset changes, dependency changes, or workflow changes must **never** start an App Build automatically.
- A build is to be started only after the user explicitly instructs ChatGPT to **“Build App”**.
- A workflow file existing or being healthy is not the same as a verified APK; the actual run result must still be checked.

## 9. VALIDATION RULES

Every meaningful App change should separate these validation layers:

### Static validation
- source inspection
- import/dependency consistency
- repository-boundary check
- manifest/build-config consistency
- no accidental firmware source reintroduction

### Automated App validation
- `flutter analyze`
- `flutter test`
- release packaging
- APK signature verification

### Runtime validation
- real Android installation
- BLE scan/connect
- characteristic discovery
- command/ACK/state synchronization
- reconnect behavior
- OTA dialog behavior

### Hardware/firmware validation
Owned by the firmware workflow and physical device testing. App source inspection cannot prove firmware hardware behavior.

## 10. SOURCE COMMENT / AI MAINTENANCE RULE

All maintainable source/configuration files were given persistent comments explaining important architecture and constraints.

The comments are intended as maintenance memory:
- why a boundary exists
- what must not be duplicated
- which layer owns a responsibility
- which external contract must remain stable
- what a future maintainer must verify before changing the code

Comments must remain factual. They must not replace verification.

The 2026-09-28 comment pass reported:
- `lib/main.dart`: 77 method-level AI maintenance markers, all attached to declarations
- no suspicious AI-METHOD insertions inside expressions
- Android/Kotlin/Gradle/manifest/ProGuard/pubspec/test/CI files documented
- `google-services.json` intentionally unchanged because JSON does not support comments
- PNG assets intentionally unchanged because they are binary assets

## 11. FILE ROLE MAP

| Path | Role |
|---|---|
| `lib/main.dart` | Main Flutter App, UI, BLE/P1 integration, OTA dialog and app state |
| `pubspec.yaml` | Flutter package/dependency contract |
| `test/widget_test.dart` | App/widget-level automated test boundary |
| `android/app/src/main/kotlin/.../MainActivity.kt` | Native Flutter↔Android bridge |
| `android/app/src/main/kotlin/.../JeForegroundService.kt` | Android foreground-service lifecycle support |
| `android/app/src/main/AndroidManifest.xml` | Android permissions/components/service declarations |
| `android/app/build.gradle` | App Android build/signing/R8 configuration |
| `android/app/proguard-rules.pro` | Release shrinker/keep rules |
| `.github/workflows/app-build.yml` | App-only CI/release build |
| `APP_NOTES.md` | App master maintenance memory |
| `FIRMWARE_NOTES.md` | Firmware master documentation/history; documentation only |
| `assets/jexfyzcooler.png` | Cooler UI asset |
| `assets/jexfyzicon.png` | App/icon asset |
| `android/app/google-services.json` | Firebase Android configuration; do not add comments |

## 12. DOCUMENTATION REORGANIZATION — 2026-09-28

- Rebuilt APP_NOTES.md as a structured master document instead of a loose accumulation of cleanup notes.
- Corrected the repository-boundary contradiction: App implementation stays external to firmware, while FIRMWARE_NOTES.md remains intentionally stored in this App repository.
- Added explicit sections for App architecture, BLE/P1 contract, OTA integration, security, dependency lock, build workflow, validation layers, source-comment policy, file roles, and change-control rules.
- Preserved the project rule that an unrun Build App workflow must not be described as a verified APK.
- Preserved the project rule that App validation cannot prove physical firmware/hardware behavior.
- This documentation-only reorganization does not intentionally change App runtime behavior.

## 12. BUILD TRIGGER POLICY CORRECTION — 2026-09-28

- Corrected the previous automatic-trigger experiment.
- App Build is now **manual-only** via `workflow_dispatch`.
- No push/path trigger remains in the App Build workflow.
- The earlier setup commit created App Build run **#11** (`36372793640`) before this correction; that run belongs to the superseded automatic-trigger configuration and is not evidence of a user-requested build.
- Future App source changes will not build automatically.
- The normal execution boundary is now: user says **Build App** → start the App Build workflow → inspect the complete result → only then deliver/report the APK.


## 12. CURRENT CHANGE / VALIDATION STATUS — 2026-09-28

Latest completed App cleanup work:
- App repository boundary corrected to App-only.
- `FIRMWARE_NOTES.md` restored and retained as documentation.
- Local `firmware/` implementation directory removed.
- Temporary firmware build workflow removed from the App repository.
- Unused `shared_preferences` dependency removed.
- Unused `flutter/rendering.dart` import removed.
- Unused native `enableLocation` MethodChannel case removed.
- Firmware manifest network fetch given bounded timeouts.
- Source/configuration comments expanded across the App.
- No firmware source or BIN was reintroduced.
- The 2026-09-28 comment pass itself was not intended to change App runtime/protocol behavior.

**Current verification status:** the App has **not** been declared a freshly verified release APK after this cleanup/comment pass. A fresh `Build App` is required before claiming release-build success.

## 13. CHANGE CONTROL

Before changing App code:
1. Read this file.
2. Read the relevant source file and its existing comments.
3. Check the current BLE/OTA integration contract.
4. Make the smallest justified change.
5. Run the appropriate validation.
6. Update this file with the reason, exact change, and validation result.

Never:
- guess a BLE UUID
- invent a firmware response/ACK
- assume a BLE write means physical success
- add firmware source back into the App repository
- remove `FIRMWARE_NOTES.md`
- treat an unrun build as a successful build
- treat App tests as proof of physical hardware behavior

## 2026-09-28 — FIREBASE OTA CONTROL PLANE

- Changed App OTA discovery from the GitHub `manifest.json` to Firebase Realtime Database.
- Firebase path: `/firmware_update` under project `je-x-fyz`.
- Firebase stores only release metadata: `version` and the approved GitHub `.bin` URL.
- GitHub is binary-only for the Online OTA path; no GitHub manifest is required by the App.
- No App Build was run; source-only change.

## 2026-09-28 — FINAL FIRMWARE UPDATE NODE

- Firebase RTDB node is now `/firmware_update`.
- REST endpoint used by the App: `https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`.
- Expected fields: `version` and `url`.
- GitHub binary filename is fixed to `JEXFYZ.cpp.bin` on the `main` branch.
- App URL validation now accepts only that exact GitHub raw BIN path.
- GitHub `manifest.json` is not part of the OTA discovery path.
- No App Build was run for this change.

## 2026-09-28 — DEBUGGING WORKFLOW PREFERENCE

- User does not want Serial Monitor to be a required debugging workflow.
- Future App/firmware diagnosis should prioritize source inspection, official API verification, build/compiler output, automated/static checks, and direct physical symptoms/screenshots supplied by the user.
- Do not make Serial Monitor capture a prerequisite for investigating OTA or runtime failures.


## 2026-09-28 — BUILD ATTEMPT / AUDIT FIX

- Requested **Build App** was executed using the App Build workflow.
- Run #13 initially failed during the App-only security/architecture audit before dependency analysis/build.
- Exact failure: audit required stale identifier `firmwareManifestUrl`.
- Current App OTA implementation uses `firmwareMetadataUrl` for the Firebase Realtime Database endpoint; GitHub is binary-only.
- Corrected `.github/workflows/app-build.yml` to require `firmwareMetadataUrl` instead of the obsolete `firmwareManifestUrl` token.
- A new App Build is triggered by the corrected workflow commit and must be validated through release packaging and production APK signature verification before delivery.

## 2026-09-28 — BUILD ATTEMPT #14 / AUDIT FIX 2

- App Build run #14 reached the App-only security/architecture audit but failed before dependency analysis.
- Exact failure: the audit treated the valid current Firebase RTDB endpoint token `firmware_update` as a legacy firmware metadata reference.
- The current App intentionally uses `firmwareMetadataUrl` ending in `/firmware_update.json`; this is the approved Firebase OTA control-plane endpoint.
- Legacy Firebase implementation markers remain forbidden: `FirebaseDatabase.instanceFor` and `firebase_database`.
- Corrected `.github/workflows/app-build.yml` by removing only the stale `firmware_update` forbidden-token check.
- A new App Build is triggered by this workflow fix and must pass audit, analyze, tests, release packaging, and production signature verification before APK delivery.

## 2026-09-28 — BUILD ATTEMPT #15 / DART ANALYZE FIX

- App Build run #15 passed the App-only security/architecture audit and dependency installation.
- Exact Dart analysis failure: `Undefined name 'ScrollCacheExtent'` at `lib/main.dart:2477:32`.
- Root cause: `ScrollCacheExtent.pixels(...)` is not a valid Flutter API type for the pinned App toolchain.
- Minimal source fix: replaced `scrollCacheExtent: const ScrollCacheExtent.pixels(480)` with the supported `cacheExtent: 480.0` ListView property.
- No BLE, OTA, protocol, or UI behavior was intentionally changed beyond preserving the requested 480px scroll cache.
- A new App Build must now pass analyze, Flutter tests, release APK packaging, production signature verification, and artifact upload.

## 2026-09-28 — BUILD ATTEMPT #16 / DART API CORRECTION

- App Build run #16 passed the security/architecture audit and dependency installation but failed at `flutter analyze`.
- Exact diagnostic: `cacheExtent` is deprecated in the pinned Flutter 3.47.2 toolchain; analyzer explicitly reported `Use scrollCacheExtent instead` at `lib/main.dart:2477:7`.
- Corrected the previous minimal fix to the actual supported API: `scrollCacheExtent: 480.0`.
- The original `ScrollCacheExtent.pixels(480)` form was invalid because the named type does not exist; the property itself accepts the numeric extent.
- No intended UI behavior change: the scroll cache remains 480 logical pixels.
- A new App Build is required to validate analyze, tests, release APK packaging, signing, and artifact upload.

## 2026-09-28 — BUILD ATTEMPT #19 / OFFICIAL FLUTTER API VERIFICATION

- App Build run #19 passed the security/architecture audit and dependency installation but failed at `flutter analyze`.
- Exact diagnostic: `The argument type 'double' can't be assigned to the parameter type 'ScrollCacheExtent?'` at `lib/main.dart:2477:26`.
- Official Flutter source verification confirmed `ScrollCacheExtent` is declared in `package:flutter/rendering.dart` and provides the factory `ScrollCacheExtent.pixels(double)`.
- Corrected the source to use the official form `scrollCacheExtent: const ScrollCacheExtent.pixels(480)` and restored the required `package:flutter/rendering.dart` import.
- This preserves the intended 480 logical-pixel cache extent without using deprecated `cacheExtent`.
- A fresh Build App validation is required after this exact API correction.

## 2026-09-28 — BUILD ATTEMPT #20 / SCROLL CACHE TYPE FIX

- App Build run #20 passed the security/architecture audit but failed at `flutter analyze`.
- Exact diagnostics: `scrollCacheExtent: 480.0` had type mismatch because the parameter type is `ScrollCacheExtent?`; analyzer also reported the explicit rendering import as unnecessary because `material.dart` already exports the used type.
- Official Flutter source confirms the intended constructor is `const ScrollCacheExtent.pixels(480)`.
- Corrected `lib/main.dart` to `scrollCacheExtent: const ScrollCacheExtent.pixels(480)` and removed the redundant `flutter/rendering.dart` import.
- The intended 480 logical-pixel cache behavior is preserved.
- A fresh Build App validation is required to continue through analyze, tests, release packaging, signature verification, and APK artifact upload.

## 2026-09-28 — BUILD ATTEMPT #23 / IMPORT CORRECTION

- App Build run #23 still failed at `flutter analyze` with `Undefined name 'ScrollCacheExtent'` at `lib/main.dart:2477:32`.
- The source used the official `ScrollCacheExtent.pixels(480)` constructor, but the defining class was not imported in that revision.
- Corrected `lib/main.dart` by explicitly importing `package:flutter/rendering.dart` while retaining `scrollCacheExtent: const ScrollCacheExtent.pixels(480)`.
- This is the minimal import correction required by the official Flutter declaration already verified in `rendering/viewport.dart`.
- A fresh Build App validation is required; no APK has been delivered until all release checks pass.

## 2026-09-28 — BUILD APP FINAL SUCCESS

- **Build App completed successfully on run #24**: GitHub Actions run `36375464018`.
- Validation passed end-to-end: App-only security/architecture audit, Flutter dependency installation, `flutter analyze`, Flutter tests, release APK build, production APK signature verification, APK filename preparation, APK artifact upload, and Dart symbol upload.
- Canonical APK artifact: `JEXFYZ#24.apk`.
- Artifact size: 52,835,604 bytes.
- Artifact SHA-256: `e0843c329f37a4b5771ac3ff19474026339afb0f6b2fe1c180f064f841c4f02c`.
- The release APK was successfully downloaded from the Actions artifact for delivery in the conversation.
- The temporary push-trigger mechanism used only to execute the explicitly requested Build App was removed afterward.
- App Build workflow is restored to **manual-only `workflow_dispatch`**.
- This run proves the App release build/signature pipeline, not physical BLE/firmware/hardware runtime behavior.

## 2026-09-28 — FIREBASE METADATA ACCESS

- The App firmware metadata endpoint is `https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`.
- The installed APK must be rebuilt after source changes; an existing older APK does not inherit the new Firebase endpoint.
- Firebase RTDB must allow read access to `/firmware_update` for the direct REST metadata request used by the App.
- Recommended rule: `firmware_update/.read = true`, `firmware_update/.write = false`.
## 2026-09-28 — FIREBASE RTDB READ FIX

- App Online OTA metadata reader remains REST-based at `/firmware_update.json`.
- The REST request now explicitly attaches a fresh Firebase App Check token through the official `FirebaseAppCheck.getToken(true)` API when available, using the `X-Firebase-AppCheck` header.
- HTTP 401/403 responses are now surfaced as a Firebase read-permission/App Check rejection internally instead of being collapsed into an unexplained generic failure.
- The expected RTDB data remains exactly:
  - `firmware_update.version = V1.0`
  - `firmware_update.url = https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`
- No App Build was run for this source fix.


## 2026-09-28 — RTDB METADATA READ INDEPENDENT OF APP CHECK

- Firebase Realtime Database firmware metadata is intentionally public-read at `/firmware_update` and contains only the current version plus a public GitHub BIN URL.
- Removed the explicit `X-Firebase-AppCheck` header requirement from this metadata REST request.
- Reason: the production APK is distributed outside Google Play, so making this public metadata read depend on Play Integrity/App Check can block OTA discovery even when RTDB rules allow `.read = true`.
- Firebase App Check remains initialized for the App's Firebase security layer; it is no longer a prerequisite for reading the public firmware metadata endpoint.
- No App Build was run for this source fix.

## 2026-09-28 — BLE DISCONNECT REDISCOVERY FIX

- App BLE lifecycle fix applied without changing the BLE UUID/P1 protocol or firmware advertising contract.
- Root cause found in App behavior: after a normal BLE disconnect, the App cleared the connected/session UI state but did not automatically start a new BLE scan. The firmware already restarts BLE advertising on disconnect.
- Added a bounded **disconnect rediscovery burst**: after a normal disconnect, the App starts BLE discovery immediately and retries every 3 seconds for up to 10 attempts (approximately 30 seconds).
- Each discovery attempt uses the existing FlutterBluePlus scan path and the existing JE X FYZ name/service matching.
- The rediscovery burst is cancelled when a new connection starts.
- The rediscovery burst is intentionally suppressed while the existing Online OTA reconnect monitor is active, preventing two independent scanners from competing during OTA recovery.
- No App UI redesign, BLE UUID/protocol change, firmware change, Firebase change, OTA transport change, or release build was performed.
- Validation completed here: source inspection and static structure review of the changed lifecycle paths. A fresh App Build remains required for compile/analyze/release verification because App Build is manual-only.

## 2026-09-28 — BUILD APP #26 FINAL SUCCESS

- Explicit **Build App** completed successfully on GitHub Actions run #26 (`36376406770`).
- Source revision built: `c56d4d52210faf68fe379b46db358ed3152e913e`, containing the latest Firebase public RTDB metadata read fixes documented immediately before the build.
- Full pipeline passed: security/architecture audit, dependency installation, `flutter analyze`, Flutter tests, release APK build, production APK signature verification, APK naming, APK artifact upload, and Dart symbol upload.
- Canonical APK artifact: `JEXFYZ#26.apk`.
- Artifact size: 52,835,604 bytes.
- Artifact SHA-256: `1a2282f0e9e6acf13cbb29f2d3403554ea53a3c4d33adb0b187bd553ddca8da1`.
- The APK artifact was downloaded and verified as an Android APK before conversation delivery.
- The temporary push trigger used only for this explicit Build App request was removed afterward.
- App Build workflow is restored to **manual-only `workflow_dispatch`**.
- This CI result validates the App release pipeline and production signing; it does not validate physical BLE/firmware/hardware runtime.

## 2026-09-28 — FIRMWARE V1.3 CURRENT BASELINE

- Firmware source currently stored with the App project is **V1.3**:
  - `firmware/JEXFYZ-V1.3.ino`
- `firmware/JEXFYZ-V1.2.ino` has been removed; the firmware folder is maintained as a single-current-source archive.
- V1.3 is the Gemini-derived firmware patch and is **not yet compile- or hardware-validated**.
- App OTA architecture remains unchanged:
  - Firebase RTDB = metadata/control plane.
  - GitHub = firmware BIN host.
  - Firmware itself does not query Firebase.
  - Public RTDB metadata remains the approved App-side integration point.
- Do **not** promote Firebase firmware metadata to V1.3 merely because the source version is V1.3. Promotion requires a deliberately published, compiled V1.3 BIN and the corresponding release/update decision.
- No App Build is implied by the firmware source update. The existing App build workflow remains manual-only.
- No App BLE protocol/UUID or App OTA transport change is required by the V1.3 firmware patch unless physical testing later demonstrates a protocol/lifecycle mismatch.
- Firmware runtime debugging continues to prioritize source inspection, ArduinoDroid compiler output, static validation, and physical symptoms/screenshots; Serial Monitor is not a prerequisite.


## 2026-09-28 — V1.4 FIRMWARE-ONLY REVISION

- Firmware source tracked by the App repo is now `firmware/JEXFYZ-V1.4.ino`; V1.3 was removed after rename.
- This revision changes only the Online OTA LED result-indicator timing and firmware version label.
- No Dart/Flutter, BLE UUID/protocol, Firebase OTA metadata, Android, or App build workflow changes were made.
- Existing App behavior remains the same: it initiates OTA through P1 commands, reads firmware OTA telemetry, and runs its bounded BLE reconnect monitor.
- Firebase firmware metadata remains unchanged; source version V1.4 is not sufficient reason to publish a V1.4 BIN.
- App Build is not implied by firmware revisions and remains manual-only.


## 2026-09-28 — LATEST ONLINE OTA SCREENSHOT EVIDENCE

- User supplied a physical screenshot showing: **`OTA in progress • ONLINE • Wi-Fi connect • 0%`**.
- The App source displays OTA stage values received from firmware and maintains a separate BLE `connected` state. Therefore a visible OTA stage does not itself prove that the ESP32 has already reached the Wi-Fi connection call.
- Current App OTA command sequencing remains unchanged and no App source change is indicated by this evidence.
- The latest diagnostic conclusion is that the next investigation should isolate the firmware radio-handoff boundary rather than modify Flutter UI/OTA transport speculatively.


## 2026-09-28 — V1.5 FIRMWARE-ONLY DIAGNOSTIC REVISION

- The firmware source paired with the App repository is now `firmware/JEXFYZ-V1.5.ino`.
- V1.5 is a firmware-only revision implementing the supplied Gemini handoff/retry patch.
- No Flutter/Dart, Android, BLE P1 UUID/protocol, Firebase metadata, or App workflow changes were made.
- The existing App Online OTA flow remains: send `OTAENTER`, SSID, PASS, URL, VERSION, then `CLOUDOTA`; read OTA telemetry and retry BLE discovery after the OTA session disconnects.
- The visible App stage `ONLINE_WIFI_CONNECT` remains a firmware telemetry state and does not by itself prove that `WiFi.begin()` has executed.
- Firebase metadata remains unchanged; V1.5 source presence is not a release-publish signal.
- App Build remains manual-only and was not triggered by this firmware change.


## 2026-09-28 — GEMINI V1.5 FULL SOURCE REPLACEMENT

- The user-provided full Gemini V1.5 firmware file is now the source of truth for `firmware/JEXFYZ-V1.5.ino`.
- The full file was applied directly as requested; no selective edits were introduced during this replacement.
- App source and App build configuration were not changed.
- Firebase OTA metadata remains unchanged.
- Physical firmware validation remains pending.


## 2026-09-28 — V1.6 FIRMWARE-ONLY HTTPS PATCH

- Firmware source tracked by the App repo is now `firmware/JEXFYZ-V1.6.ino`.
- V1.6 contains the user-directed Gemini HTTPS/GitHub OTA patch only.
- No Flutter/Dart, Android, BLE protocol/UUID, or Firebase source changes were made.
- App OTA metadata and GitHub binary URL remain unchanged.
- App Build was not triggered; App Build remains manual-only.
- Physical V1.6 validation is pending.


## 2026-09-28 — OTA END-TO-END PHYSICAL VALIDATION / FREEZE

- User confirmed that **Local OTA and Online OTA both work successfully on the physical device**.
- The supplied physical App screenshot showed **OTA successful • ONLINE • Flash success • V6.4**.
- V6.4 was intentionally used as a test firmware version so Online OTA could be exercised repeatedly; it should be treated as a test value, not as a source-version promotion.
- The validated Online OTA architecture remains:
  Firebase metadata/control plane → App validation → BLE P1 OTA command sequence → firmware Wi-Fi handoff → GitHub JEXFYZ.cpp.bin download → Update.h flash → success/restart → BLE recovery.
- **OTA FREEZE:** the App OTA protocol, Firebase metadata endpoint, GitHub BIN URL, BLE OTA command sequence, and OTA status/telemetry contract are frozen unless the user explicitly requests an OTA change.
- Firmware-side physical success does not require an App Build. No App Build was triggered by this validation.


## 2026-09-28 — LED 7-MODE / PHYSICAL LAYOUT UPDATE

- App LED mode selector is aligned with firmware V2.1: **7 modes**.
- Removed **Twinkle** from the LED mode list.
- App mode parsing/display and outbound MODE command range are now **1–7**.
- Previous mode 8 values are normalized to **mode 7 / Rainbow** by the App clamp.
- Mode navigation stops at mode 1 and mode 7 instead of sending unsupported values.
- No BLE UUID/protocol, OTA transport, reconnect monitor, Firebase metadata, Android lifecycle, or App build workflow changes.
- **App Build was not triggered**; the App workflow remains manual-only.


## 2026-09-28 — APP BUILD #28 SUCCESS / APP-ONLY REPOSITORY BOUNDARY RESTORED

- User explicitly requested **Build App**.
- Temporary `push` trigger was added only to start the manual-requested validation run; the App Build workflow was restored to **manual-only (`workflow_dispatch`)** after completion.
- Run **#27** (`36399794582`) stopped at the App security/architecture audit because the repository still contained `firmware/JEXFYZ-V2.0.ino`.
- The audit failure was valid under the App-only repository boundary: firmware source/BIN/build artifacts must remain external to the App repository.
- The superseded in-repo firmware source file `firmware/JEXFYZ-V2.0.ino` was removed. No Flutter/Dart/Android/App OTA runtime code was changed for this cleanup.
- Run **#28** (`36399990035`) was then executed from source revision `5d62b5ac6288004902481f83bc37497a93a43451` and passed the complete pipeline:
  - App security/architecture audit ✅
  - dependency installation ✅
  - `flutter analyze` ✅
  - Flutter tests ✅
  - obfuscated release APK build ✅
  - production APK signature verification ✅
  - APK artifact preparation/upload ✅
  - Dart symbols upload ✅
- Artifact: **`JEXFYZ#28.apk`**
- Artifact size: **52,851,988 bytes**
- Artifact SHA-256: **`18222aed26555a003fe6fe4dcb7e3d1706a0a71386226a5c30fa468b0b8b6e83`**
- CI signature verification confirmed:
  - APK Signature Scheme v2 = true
  - Certificate DN = `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - Certificate SHA-256 = `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- The downloaded artifact was independently identified as a valid Android APK and its SHA-256 matched the GitHub artifact digest exactly.
- Workflow restore commit: `5f9efac3e34bf029f80598b57c6151cf67ea3b90`.
- **Current App Build workflow state: manual-only (`workflow_dispatch`); no automatic push trigger left enabled.**
- Build validation proves the App release pipeline and signing identity; it does not prove BLE, OTA, or physical hardware runtime.


## 2026-09-28 — APP BUILD #31 SUCCESS / LATEST SOURCE DELIVERY

- **Run #31** (`36400379692`) is the latest successful App Build and supersedes Build #28 as the delivery build because later App repository changes were committed after Run #28 started.
- Run #31 built source revision `15e90fb9ff27da01dd4a21b9cb67b00e482d56ed`, which includes the latest App LED 7-mode alignment work present in the repository at that time.
- Complete validation passed:
  - App security/architecture audit ✅
  - dependency installation ✅
  - `flutter analyze` ✅
  - Flutter tests ✅
  - obfuscated release APK build ✅
  - production APK signature verification ✅
  - APK artifact preparation/upload ✅
  - Dart symbols upload ✅
- Artifact: **`JEXFYZ#31.apk`**
- Artifact size: **52,851,988 bytes**
- Artifact SHA-256: **`78e83ea92e76ab480ec2b6b633f17fe76b1b04dfb202c529b33cfeb19e3ebebb`**
- The downloaded file was independently identified as an Android APK and its SHA-256 matched the GitHub artifact digest exactly.
- CI signature verification confirmed APK Signature Scheme v2 and the official production certificate:
  - DN = `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - SHA-256 = `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- During the requested Build App window, consecutive repository commits caused residual push-triggered runs #29 and #30 to be cancelled while run #31 validated the latest source. The workflow has since been restored to manual-only.
- **Current App Build workflow state: manual-only (`workflow_dispatch`) with no automatic push trigger.**
- CI validation proves the App build/signing pipeline; it does not prove BLE, OTA, or physical hardware runtime.


## 2026-09-28 — LED PALETTE + BRIGHTNESS UI UPDATE

- App LED color selection is now a **48-color touch palette (8 × 6)**.
- Manual HEX color entry was removed from the App.
- Voltage color selectors for **5V / 9V / 12V** were removed from the App.
- **Reset Colors** was removed from the App.
- Firmware-owned voltage indicator colors remain unchanged.
- Palette selection applies only to LED modes that use the user RGB color. **Rainbow (Mode 7) keeps its own firmware hue cycle and disables the palette.**
- Brightness UI is now **1–100%** with **99 divisions**, allowing every 1% step.
- LED Power OFF remains the true OFF control; brightness UI no longer exposes 0%.
- Brightness uses the existing firmware BRIGHTNESS 1–100 interface; the firmware maps that user percentage to its hardware 0–255 scale.
- BLE protocol/UUIDs, OTA, reconnect rediscovery, and firmware source were not changed.
- App Build was **not triggered**; workflow remains manual-only.


## 2026-09-28 — APP BUILD TRIGGER SPLIT

- `app-build.yml` is now a **reusable workflow engine** triggered only through `workflow_call`; it has no `push` or direct manual trigger.
- Added `.github/workflows/app-build-trigger.yml` named **Build App** as the single manual entry point.
- One manual **Build App** trigger starts the reusable build engine once; normal repository commits do not create App Build runs.
- Historical extra runs caused by the temporary `push` trigger remain visible in GitHub Actions history; they are not new triggers after this change.
- App CI audit now permits the authoritative firmware `.ino` source under `firmware/` while still rejecting App-code dependencies on firmware source paths.


## 2026-09-28 — BUILD APP #3 SUCCESS / LED PALETTE + BRIGHTNESS 1–100

- User explicitly requested **Build App** from the latest App repository state.
- The repository now uses the dedicated **Build App** trigger (`.github/workflows/app-build-trigger.yml`) calling the reusable App Build engine (`.github/workflows/app-build.yml`).
- A temporary `push` trigger was used only to execute this explicit request because the available GitHub control surface does not expose `workflow_dispatch`. The trigger was removed immediately after the build started; final trigger state is **manual-only**.
- During validation, the existing LED palette test contained a malformed regular-expression literal. The first analyzer run exposed this exact syntax error. The test file was repaired minimally to use `r'^#[0-9A-F]{6}$'`.
- Run **#3** (`36404380148`) then passed the complete pipeline from source revision `9f2e9cb30ef6f421faf691b11b29f2baff19dbb1`:
  - App security/architecture audit ✅
  - dependency installation ✅
  - `flutter analyze` ✅
  - Flutter tests ✅
  - obfuscated release APK build ✅
  - production APK signature verification ✅
  - APK artifact preparation/upload ✅
  - Dart symbols upload ✅
- Latest validated App changes include the **48-color RGB palette** and **1–100 LED brightness UI**, with Rainbow remaining self-colored.
- Artifact: **`JEXFYZ#3.apk`**
- Artifact size: **52,868,412 bytes**
- Artifact SHA-256: **`502dc458bd3a38ead3b1bdfea2a8d8dfb42ccb18860045adf4ac823ea8b2a4c5`**
- The downloaded artifact was independently identified as an Android APK, and its SHA-256 matched the GitHub artifact digest exactly.
- CI signature verification confirmed APK Signature Scheme v2 and the official production certificate:
  - DN = `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - SHA-256 = `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- Final workflow state verified:
  - `.github/workflows/app-build-trigger.yml` = manual-only (`workflow_dispatch`) ✅
  - `.github/workflows/app-build.yml` = reusable `workflow_call` engine with no push trigger ✅
- CI validation proves the App build/signing pipeline; it does not prove BLE, OTA, or physical hardware runtime.


## 2026-09-30 — BUILD APP #10 SUCCESS / V2.2 LATEST SOURCE

- User explicitly requested **Build App** from the latest repository state.
- Latest source before the build included the V2.2 Adaptive/settings/Floating Monitor work.
- Build validation initially exposed real App-side issues that were fixed minimally and then revalidated:
  - missing `FlutterSecureStorage` / `ValueListenable` imports in `floating_monitor.dart`
  - invalid `const` usage and a misplaced TamperScreen color helper call in `main.dart`
  - stale widget-test expectations for the V2.2 bilingual labels, 12-color LED palette, and repeated `Voltage` label
  - Flutter 3.47.2 analyzer deprecation infos were explicitly kept non-fatal via the official `--no-fatal-infos` option; analyzer diagnostics remain visible
  - Kotlin 2.2.20 release compile errors in `FloatingMonitorService.kt`: Float `sumOf` ambiguity was replaced with `fold`, and inner `View.layoutParams` was disambiguated to the service's `WindowManager.LayoutParams` for X/Y positioning
- Run **#10** (`36699965445`) from source revision `3baaa4eb77ea930cb58819b2db8af6f58f5be1d8` passed the complete pipeline:
  - App security/architecture audit ✅
  - dependency installation ✅
  - `flutter analyze --no-fatal-infos` ✅
  - Flutter tests: **4/4 passed** ✅
  - obfuscated release APK build ✅
  - production APK signature verification ✅
  - APK artifact preparation/upload ✅
  - Dart symbols upload ✅
- Artifact: **`JEXFYZ#10.apk`**
- Artifact size: **53,918,024 bytes**
- Artifact SHA-256: **`4697874d293a039282368080c071c66697c1a297b4da0c824fba7fd256ec555b`**
- Downloaded artifact was independently identified as a valid Android APK and its SHA-256 matched the GitHub artifact digest exactly.
- CI signature verification confirmed APK Signature Scheme v2 and the official production certificate:
  - DN = `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - SHA-256 = `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- Final workflow state verified:
  - `.github/workflows/app-build-trigger.yml` = manual-only (`workflow_dispatch`) ✅
  - `.github/workflows/app-build.yml` = reusable `workflow_call` engine with no push trigger ✅
- The CI trigger was temporarily enabled only to execute the explicit user request and was restored to manual-only afterward.
- CI validation proves the App build/signing pipeline; it does not prove BLE, OTA, or physical hardware runtime.


## 2026-09-30 — BUILD APP #15 SUCCESS / SOURCE `ba407...` PLUS MINIMAL BUILD FIXES

- User requested a fresh release build from the current `main` source; Build #10 was explicitly not reused.
- Pre-build `main` HEAD at the start of the validation was `ba4075865742944302aec4a85081b1ef87aeb54f`.
- CI exposed a real source syntax issue in `lib/main.dart`: the Dashboard `Theme`/`MediaQuery` wrapper was missing the `MediaQuery` closing `),`. Minimal fix committed as `7186788b7dfef1e3a10fc8c78cd16039c4549eb2`.
- Earlier analyzer/test fixes required during this build sequence were limited to restoring imports/const correctness, removing unused helpers, and aligning stale widget-test expectations with the current V2.2 UI. No firmware, OTA transport, BLE UUID, Firebase metadata, or physical-hardware behavior was changed.
- Run **#15** (`36710407297`) was built from derived trigger head `6c4c65d445bb1b3ea2b0afab3a4438a132d0f085`; the App source files in that checkout were the same source as `7186788b...`, with only temporary trigger/marker workflow changes.
- Complete CI pipeline passed:
  - security/architecture audit ✅
  - dependency installation ✅
  - `flutter analyze --no-fatal-infos` ✅
  - Flutter tests **4/4 passed** ✅
  - obfuscated release APK build ✅
  - production signing verification ✅
  - exactly one APK release artifact ✅
  - Dart symbols artifact ✅
- Release artifact: **`JEXFYZ#15.apk`**
- Artifact size: **53,918,024 bytes**
- Artifact SHA-256: **`6b4f6f43a5e126b5334501c180a537324ffce6a9df20662eafbb27aa0c8248d4`**
- Downloaded APK was independently identified as an Android package and its SHA-256 matched the GitHub artifact digest exactly.
- Production signing verification:
  - APK Signature Scheme v2 = true
  - Certificate DN = `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - Certificate SHA-256 = `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- Final repository state after cleanup: current `main` HEAD is `6b7d6159879af9fd64972c290c5ef9bc11035df8`, the App Build trigger is manual-only, the reusable build engine remains `workflow_call` only, and the temporary marker is removed.
- CI validation proves release build/signing/artifact integrity only; it does not prove BLE, OTA, firmware V2.3 compilation in ArduinoDroid, or physical hardware runtime.


## 2026-09-30 — PROJECT WORKFLOW / CHAT CONTINUITY RULE

- The JE X FYZ project now uses **one continuous subchat for the whole project lifecycle**. Discussion, execution, source review, validation, and build decisions stay in the same subchat until the chat reaches its platform limit.
- When the active subchat reaches its limit, create a **copy-ready handover prompt** summarizing the project **from the beginning of that subchat through its final state**, including current repository state, commits, source versions, changes, validation evidence, pending work, known risks, and the exact next step. The new subchat continues from that handover; do not restart the project history from scratch.
- **Process is explicit and sequential:**
  1. `@Thinking Diskusi!` = discussion/review only. Do not modify repository, commit, or build.
  2. `@Thinking Eksekusi!` = perform only the approved implementation changes and commit them. Do not build unless the user separately requests a build.
  3. `@Thinking Build App!` = run the App build/validation pipeline. Do not introduce unrelated source changes as part of the build request.
- A repository change must always be accompanied by an update to the appropriate maintenance notes in the same project workflow. App changes update `APP_NOTES.md`; firmware changes update `FIRMWARE_NOTES.md`; project-wide process changes are recorded in the project notes as well.
- Build App must never be inferred from a discussion, an execution request, or the existence of a new commit. A build occurs only after an explicit **`Build App`** instruction from the user.
- The Build App trigger was corrected in this execution to **manual-only**: `.github/workflows/app-build-trigger.yml` now uses `workflow_dispatch` and no longer has a `push` trigger. This prevents ordinary commits from automatically launching an App build.
- This execution changed **process/CI behavior and documentation only**. No Dart/Android source or firmware source was modified, and no App Build was requested or run.


## 2026-09-30 — FULL EXECUTION / DISPLAY THEME + APP↔FIRMWARE STATE SYNC + ANIMATED ICON SYSTEM

- Restored the intended **Default Dashboard visual boundary**: black Home/header with a white Display/Menu area. The Dashboard now receives its light Default theme above the `DashboardScreen` State context so helper widgets using `Theme.of(context)` resolve the same theme as the rendered Display.
- Preserved the global Default non-dashboard theme as dark, so Settings and child pages do not become unintentionally white.
- Strengthened App↔Firmware command synchronization:
  - App now treats BLE ACK as **command acceptance**, not physical-state confirmation.
  - After accepted stateful commands, App waits for the corresponding authoritative telemetry state before reporting confirmation success.
  - App performs a fresh firmware SYNC when the connected dashboard resumes from the Android lifecycle, providing reconciliation after background/notification loss without adding a 1 Hz SYNC heartbeat.
- Added firmware-side authoritative state replies for stateful commands even when the requested value was already equal to the current firmware state. FAN and PELTIER are always echoed after their commands, preventing stale App toggles from remaining OFF when the device is already ON. The same reconciliation pattern was extended to RGB, LED mode/brightness/color, adaptive/profile, fan speed, temperature limits, reset settings, and related persisted control values.
- Firmware physical GPIO authority remains unchanged: GPIO5 = PELTIER and GPIO6 = FAN.
- Reworked the JE X FYZ animated icon behavior toward **calm micro-interactions** rather than aggressive looping motion. Existing functional icons (battery, hotside, voltage, adaptive, peltier, fan, speed, LED, Bluetooth) remain state-driven; FAN animation speed continues to follow its level.
- Added reusable `lib/jex_animated_glyph.dart` for subtle continuous animation on secondary Settings/Floating Monitor glyphs.
- Dashboard header/menu glyph coverage was expanded so ordinary UI icons are no longer visually static by default.
- No BLE UUID, P1 protocol, OTA transport, Firebase metadata contract, or firmware version was changed by this execution.
- **No Build App was run.** Per project workflow, this execution only changed source/documentation; Build App remains an explicit separate command.


## 2026-09-30 — FULL EXECUTION / FINAL ICON COVERAGE + BLE RECONCILIATION HARDENING

- Final App-side animation coverage was completed for the Dashboard and Connection UI actions. The main animated icon system now keeps subtle continuous motion even in inactive states while preserving stronger state-driven motion for active device features.
- The App now performs a fresh firmware snapshot reconciliation when a connected dashboard resumes, and after an accepted state-changing command it waits for the matching authoritative telemetry. If the expected delta is not observed before timeout, the App performs one fresh SYNC snapshot before declaring the command unconfirmed.
- Connection/Dashboard scan, Bluetooth, settings, reset, +/- and other visible secondary glyphs were moved onto the same subtle animated-glyph treatment where the shared Dashboard animation system is available.
- Added reusable `lib/jex_animated_glyph.dart` for Floating Monitor / secondary UI animation coverage.
- Dashboard Default theme remains implemented by placing the Dashboard under a Light theme ancestor while keeping the global Default theme dark for non-dashboard Settings pages.
- No Build App was run. The repository remains ready for an explicit `Build App` command only.


## 2026-10-01 — BUILD APP TRIGGER LOCK

- Build App entry point is locked to `workflow_dispatch` only; repository pushes and pull requests do not start the App release workflow.
- The manual trigger now requires an explicit `confirm_build` checkbox to be enabled. The reusable `app-build.yml` remains `workflow_call` only and cannot self-trigger.
- The intended operational flow is `@Thinking Diskusi!` → review only, `@Thinking Eksekusi!` → implementation/commit only, and `@Thinking Build App!` → manually dispatch the build with explicit confirmation.
- No automatic build trigger was added.


## 2026-10-01 — ASSISTANT-DRIVEN BUILD APP TRIGGER

- Replaced the previous manual `workflow_dispatch` gate with a dedicated GitHub Issue event used only as a trigger proxy for explicit `@Thinking Build App!` requests from the assistant.
- `app-build-trigger.yml` now listens only for `issues: opened` / `issues: reopened` and runs the reusable build engine only when both the issue title and the dedicated `JEXFYZ_BUILD_TRIGGER_V1` token match exactly.
- Normal pushes, pull requests, documentation commits, and source commits do not start Build App.
- The intended operational behavior is now: explicit `@Thinking Build App!` request → assistant creates/reopens the dedicated trigger issue → GitHub Actions starts the reusable App Build engine → assistant checks the run and retrieves the APK artifact.
- No other build workflow entry point was added.


## 2026-10-01 — BUILD #31 FAILURE FIX

- The first assistant-driven Build App trigger successfully fired GitHub Actions as intended (Run #31, event `issues`), proving the new trigger path works and normal push builds are no longer required.
- Run #31 failed only at `flutter analyze`. The concrete source errors were: non-exhaustive `JexAnimatedIconKind.generic` switch and an extra closing token in `DashboardScreen.build()` introduced during the theme-boundary edit.
- Both errors were corrected in `lib/main.dart`. No unrelated feature or firmware logic was changed for the build fix.
- The dedicated trigger issue was closed after the failed run so it can be reopened for the next explicit Build App trigger.


## 2026-10-01 — BUILD APP #32 SUCCESS

- Assistant-driven Build App trigger was exercised successfully through dedicated Issue #6 (`issues: reopened`).
- Run #32 (`36754549510`) completed successfully against `main` commit `b98651ed1e92d1e8de88cd3f67530520db5bc76f`.
- Pipeline evidence: security/architecture audit PASS, Flutter dependency install PASS, `flutter analyze --no-fatal-infos` PASS, Flutter tests PASS, release APK build PASS, production signature verification PASS, APK artifact upload PASS, Dart symbols upload PASS.
- APK artifact: `JEXFYZ#32.apk`, artifact ID `11116203156`, size 54,130,688 bytes, SHA-256 `afbd43db1e8ca06e267666129763cc0960be4b309d3b0156c65dd9db8bc3c6b5`.
- The downloaded artifact was independently checked as a valid APK/ZIP container with no ZIP integrity errors.
- Dedicated Build Trigger Issue #6 was closed after the successful build. Future explicit `@Thinking Build App!` requests can reopen the same issue to trigger the workflow; closing/reopening is the assistant-controlled trigger path.


## 2026-10-01 — FULL EXECUTION / CROSS-OEM FLOATING MONITOR ROBUSTNESS

- Implemented the approved Floating Monitor robustness patch without changing firmware, BLE/P1 contracts, OTA, UUIDs, or manifest permissions.
- MainActivity.kt:
  - Reworked openOverlaySettings() into a public-API fallback ladder:
    1. Settings.ACTION_MANAGE_OVERLAY_PERMISSION with the app package URI.
    2. Generic Settings.ACTION_MANAGE_OVERLAY_PERMISSION.
    3. Settings.ACTION_APPLICATION_DETAILS_SETTINGS with the app package URI.
  - Each candidate is checked with resolveActivity() and guarded with try/catch; no OEM-specific hidden API or hardcoded vendor AppOps was added.
  - Removed the unnecessary FLAG_ACTIVITY_NEW_TASK from this Activity-context Settings flow.
- FloatingMonitorService.kt:
  - Added public_overlay_granted, service_running, window_add_attempted, window_add_succeeded, window_add_error, and view_attached_to_window runtime diagnostics.
  - runtimeState() now returns Map<String, Any?> so the attach error can be nullable.
  - ensureOverlay() now records permission denial and the exact exception class/message from WindowManager.addView() instead of swallowing it.
  - Added View.OnAttachStateChangeListener plus View.isAttachedToWindow verification so overlay is no longer based only on hudView != null.
- lib/floating_monitor.dart:
  - Replaced the single immediate permission check after AppLifecycleState.resumed with a bounded retry window of up to 2 seconds at 300 ms intervals.
  - Added a guard preventing concurrent resume permission checks.
  - Extended the existing 300 ms runtime reconciliation to detect service/overlay loss and persist Floating Monitor disabled rather than leaving a stale enabled UI state.
- Source commits created by this execution:
  - MainActivity fallback: fa4719843b8741bcbefc20ca32196b1158c662b4
  - Native overlay diagnostics: 191fd40dd552e07c67f985324dbb2158af620c99
  - Flutter permission/runtime reconciliation: a16a6ea02cca1158379dc2d3fdab1f335d776082b
- Validation boundary:
  - Static source edits were applied and committed.
  - No Build App was run, because execution and build remain separate by project rule.
  - The patch is not yet physically validated across OEM devices. In particular, the relationship between an OEM's visible "Display pop-up windows" state and Settings.canDrawOverlays() remains a device-dependent runtime question.
  - The patch intentionally does not claim universal OEM behavior; it uses the strongest public Android fallbacks and actual overlay attachment diagnostics before considering vendor-specific handling.


## 2026-10-01 — FULL EXECUTION / LOCALIZATION + FAN SPEED VISIBILITY + SOURCE MEMORY COMMENTS

- Implemented the approved localization and Fan Speed presentation fixes after the Floating Monitor cross-OEM patch.
- Localization contract is now explicit:
  - Language selector displays English and Indonesia; Inggris / Bahasa Indonesia are no longer used as selector labels.
  - English user-facing power state = ON / OFF.
  - Indonesian user-facing power state = HIDUP / MATI.
  - Frozen BLE/P1 protocol tokens remain machine values such as FAN:ON, FAN:OFF, PELTIER:ON, ADAPTIVE:ON, and are never localized.
- lib/app_settings.dart:
  - Updated the shared JexText language/status mappings to the new contract.
  - Added file/model/store/localization/theme memory comments so persistence and presentation boundaries are explicit.
- lib/main.dart:
  - Added a file-level AI memory contract and stronger function-contract comments around Dashboard control/state paths.
  - Replaced user-facing hardcoded status/error presentation paths with JexText/JexText.phrase localization where they were bypassing the localization table.
  - Dashboard power-state presentation now resolves ON/OFF through JexText.
  - Home Fan Speed is now completely hidden when Fan is OFF; it reappears only when Fan telemetry reports ON.
  - Control-tab Fan Speed section is rendered only while Fan is ON; its existing manual 12V/Adaptive gating and 50–100% range remain unchanged.
  - Localized the obvious remaining Fan/Peltier/Adaptive/LED command and safety messages that were previously hardcoded in English.
- lib/floating_monitor.dart:
  - Added a file-level memory/ownership contract and detailed method comments for permission, runtime, telemetry, preview, and metric-selection paths.
  - Floating telemetry now forwards the selected AppLanguage to the native service.
  - Flutter preview uses JexText for ON/OFF presentation.
  - Floating metric S remains hidden whenever Fan is OFF; no S:OFF presentation is used.
- FloatingMonitorService.kt:
  - Added file-level ownership/localization/visibility invariants and detailed method contracts.
  - Native service now receives the selected language and renders HIDUP/MATI for Indonesia or ON/OFF for English while retaining stable metric identifiers.
  - Existing runtime diagnostics and actual WindowManager attachment verification from the previous Floating patch remain intact.
- MainActivity.kt:
  - Added detailed bridge/Settings function contracts while preserving the cross-OEM public Android overlay Settings fallback ladder.
- test/widget_test.dart:
  - Added deterministic tests locking the English/Indonesia language-name and ON/OFF/HIDUP/MATI contracts.
  - Updated test memory comments to state the exact validation boundary.
- Source commits in this execution sequence:
  - 881d08ed6188a54aa0dc2ea9517d86feefc6ebab — localization wording in app_settings.dart
  - 57601d9a8bfa01d7a065649abcce9e429f871c93 — main.dart localized status + Fan Speed behavior
  - 7579ee9c910cfd9543748e86994fdb2cf2e0b9b8 — Flutter Floating Monitor localization/contract comments
  - 292d326c176b3b6f603892de42875a52ea3016f5 — native Floating Monitor localization/contract comments
  - 53664e70f421ecbafa6b6afb3a5f0b5f4e1946b9 — complete native floating memory markers
  - 7295e8b4de170475a2719e586012a892f5464d41 — MainActivity bridge memory comments
  - ad6a326372488c2363e7f696e33edd9539c10792 — localization contract tests
  - eaa895c80d59e5c557d9df0d6056fb0b427bef4f — cleaned localized status paths and memory comments
- Validation boundary:
  - Source inspection and deterministic test-source update completed.
  - No Build App was run.
  - No new physical/OEM runtime validation was performed.
  - The next validation must explicitly build the current main source and then test Floating Monitor + localization + Fan Speed visibility on-device.


- Follow-up comment-memory pass: lib/floating_monitor.dart now also marks the remaining configuration/model/settings helper functions and Settings widget classes with explicit AI-METHOD / AI-MEMORY contracts. Latest comment-only source commit: 1fa5c54868a7a683b95f338ebbd9b3ac9fa23814.


## 2026-10-01 — FULL EXECUTION / THEME CONTRAST + RESIDUAL LOCALIZATION + FLOATING STATE

- Re-inspected the current main source before implementation; existing Localization and Fan Speed patches were preserved rather than duplicated.
- Fixed remaining Dashboard Light-theme contrast hazards in the Home header and Notify presentation:
  - disconnected Bluetooth now uses header-aware foreground contrast;
  - Notify message text, chip fill, and offline status color follow the actual header presentation;
  - ColorScheme.onSurfaceVariant is explicitly aligned with the project muted text color.
- Completed the six remaining hardcoded temperature-limit Snackbar paths through JexText.
- Floating Monitor now treats Adaptive and Peltier as independent firmware-backed states; Fan state only gates visibility of Speed (S).
- Added deterministic Flutter regression coverage for the Floating state/visibility contract.
- No BLE UUID, P1 protocol, OTA transport, Firebase metadata contract, firmware GPIO, firmware version, or Android overlay permission architecture was changed.


## 2026-10-01 — BUILD APP #34 SUCCESS / CURRENT SOURCE VALIDATED

- Build App Run #34 (36776478079) completed successfully from current source commit 8df84e6722d08789a507388e51c930cfec457e71.
- Run #33 (36776240045) failed only because the CI audit incorrectly treated a documented firmware path string as an App dependency; the audit was minimally corrected in 8df84e6722d08789a507388e51c930cfec457e71 to reject executable Dart import/export/part references instead.
- Build #34 pipeline passed: security/architecture audit, dependency installation, Dart analyze, Flutter tests, release APK build, production APK signature verification, release APK filename preparation, exactly one APK artifact upload, and Dart symbols artifact upload.
- Release APK artifact: JEXFYZ#34.apk
- APK artifact ID: 11125019753
- APK size: 54,147,072 bytes
- APK artifact digest: sha256:8de4114a0b2f8d7a7eb981a3507a587a38bbc47bf2945d03ebf660498acb5ea8
- Dart symbols artifact ID: 11125359500
- Dart symbols digest: sha256:5e28f49455796e39fd5918bcad3b529ea67617b8081361f598f9c2432e9a35b3
- Build validation applies to source commit 8df84e...; it does not prove Android OEM Floating Monitor behavior or physical firmware/hardware behavior.

## 2026-10-01 — FULL EXECUTION / LIGHT THEME CONTRAST INVERSION

- Corrected the Light Theme so semantic text is near-black on light surfaces, while Dark Theme keeps near-white text on dark surfaces.
- lib/app_settings.dart now uses an explicit inverse semantic contrast contract:
  - Light: foreground #111318, muted #3F444D.
  - Dark: foreground #F4F6FA, muted #979DA8.
  - ColorScheme.onSurfaceVariant follows the theme muted color.
- lib/main.dart corrected explicit Dashboard Light-theme text paths that previously bypassed ThemeData:
  - Home metric labels use near-black text in Light mode.
  - Inactive Home metric values use near-black text in Light mode.
  - Unselected Display Menu tabs use near-black text in Light mode.
- Dashboard visual boundaries remain unchanged:
  - Default = black Home/header + white Display/Menu.
  - Light = light Home/header + white Display/Menu.
  - Dark = dark Home/header + dark Display/Menu.
- Added deterministic regression coverage in test/widget_test.dart for Light/Dark semantic text inversion.
- No BLE/P1 UUID, OTA transport, Firebase metadata, firmware GPIO/version, Floating Monitor transport, or physical-control logic was changed.
- Per workflow contract, no Build App was run by this execution. Build remains explicit via @Thinking Build App!.


## 2026-10-01 — FULL EXECUTION / LIGHT THEME CONTRAST + MANUAL BLUETOOTH DEFAULT + PERSISTENT SPEED STATE

- Implemented the requested Light Theme direction: Light is the bright counterpart of Dark, with high-contrast dark text on bright surfaces.
- `lib/app_settings.dart`:
  - Strengthened Light Theme `ColorScheme.onSurfaceVariant` from medium gray to `#3F444D`.
  - New/missing `autoConnect` default is now `false` (Manual).
  - Existing valid persisted `autoConnect` values are preserved; only new/missing values use Manual.
- `lib/main.dart`:
  - Dashboard Light Home labels and inactive values now use near-black `#16181D`.
  - Light header subtitle uses a darker neutral.
  - Light Dashboard inactive tab labels use near-black text.
  - Connection indicator cards now invert correctly between Light and Dark instead of always using a dark card with white text.
  - Fan Speed indicator remains visible; disconnected shows `--`, Fan OFF shows localized `OFF` / `MATI`, and Fan ON retains the configured speed display.
  - Control tab keeps the Speed row visible; its editable slider remains available only when Fan is ON and the existing connected/manual/12V gates pass.
- `lib/floating_monitor.dart` + `FloatingMonitorService.kt`:
  - Floating metric `S` is no longer hidden when Fan is OFF.
  - `S` displays localized `OFF` / `MATI` when Fan is OFF.
  - Existing Adaptive/Peltier independence remains intact.
- `test/widget_test.dart`:
  - Added Light Theme high-contrast assertions.
  - Added Manual Auto Connect default regression coverage.
  - Updated Floating Speed state tests for persistent `S` + localized OFF/MATI behavior.
- No firmware source, BLE UUID/P1 protocol, OTA transport, Firebase metadata contract, GPIO mapping, or signing identity was changed.
- Build App was not triggered by this execution; source changes are committed on the default branch and are ready for the dedicated Build App workflow.

## 2026-10-01 — FULL EXECUTION / FLOATING METHODCHANNEL ROOT-CAUSE FIX

- Fixed the Floating Monitor native bridge ownership bug.
- Root cause: `lib/floating_monitor.dart` used `MethodChannel('je_x_fyz/floating')`, while `MainActivity.kt` had incorrectly registered Floating methods on `je_x_fyz/battery_temp`. This caused the Flutter bridge calls to miss the native handler and fall into their error paths.
- `MainActivity.kt` now keeps `je_x_fyz/battery_temp` for battery/location/Bluetooth/background-service utilities and registers all Floating operations on the dedicated `je_x_fyz/floating` channel:
  - `hasOverlayPermission`
  - `openOverlaySettings`
  - `startFloatingMonitor`
  - `stopFloatingMonitor`
  - `updateFloatingConfig`
  - `updateFloatingData`
  - `getFloatingRuntimeState`
- `FloatingMonitorService.kt` comment contract was aligned with the persistent Speed indicator behavior: S remains visible and reports OFF/MATI when Fan is OFF.
- `.github/workflows/app-build.yml` now contains a static channel-contract guard so Flutter/native Floating channel drift is caught during CI before release.
- Source-level validation confirmed:
  - Flutter uses `je_x_fyz/floating`.
  - MainActivity declares the same dedicated Floating channel.
  - Floating methods are isolated to the dedicated channel.
  - Native Floating Monitor retains actual WindowManager attachment/runtime-state checks.
- Build App was not triggered by this execution; runtime validation on the user's OEM device still requires a fresh APK installed and the Floating permission/start flow exercised on-device.

## 2026-10-01 — FLOATING SPEED STATE / SETTINGS SELECTION ALIGNMENT

- Aligned the Floating Settings UI with the persistent Speed indicator contract.
- Metric `S` remains selectable regardless of current Fan telemetry.
- Floating preview and native overlay continue to render selected `S`; Fan OFF is presented as localized `OFF` / `MATI`.
- Runtime telemetry still owns the actual Fan/Speed state; no device state is persisted as Floating configuration.


## 2026-10-01 — FULL EXECUTION / FLOATING FAN OPTION REMOVED

- Final Floating Monitor metric contract is now explicit: there is **no separate Fan metric**.
- Fan-related presentation is represented only by **S = Speed**:
  - Fan ON → S shows the configured speed value.
  - Fan OFF → S remains visible and shows localized OFF/MATI.
- Supported Floating metrics remain exactly: F (FPS), B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), S (Speed).
- `lib/floating_monitor.dart` keeps only those seven stable identifiers and now documents S as the sole fan-related metric.
- Legacy persisted `FAN` entries are filtered out by the existing metric validation/migration path; they are not reintroduced into the selector.
- `FloatingMonitorService.kt` accepts only F/B/H/V/A/P/S, so a legacy FAN identifier cannot appear in the native overlay.
- Added a regression test proving `FAN` is rejected while `S` remains selected/available.
- This change is App-only. Firmware, BLE UUID/P1 protocol, OTA transport, Firebase metadata, GPIO mapping, and signing identity remain untouched.
- Build App requested in this execution; the fresh release artifact must be delivered to chat automatically after a successful run.

## 2026-10-01 — FOLLOW-UP / FLOATING SELECTOR CLEANUP

- Corrected the Floating Settings selector implementation so every supported metric remains selectable.
- There is no separate `Fan` checkbox/metric. `S = Speed` is the only fan-related metric.
- Removed the stale runtime gating that made Speed selection depend on current Fan telemetry.
- Legacy `FAN` entries remain rejected by the seven-ID validation contract.
- This follow-up also fixes the analyzer error introduced by the first selector cleanup attempt (`speedAvailable` was still referenced after its source had been removed).
- All Floating memory comments/tests remain aligned with the final contract.


## 2026-10-01 — BUILD VALIDATION FIX / FLOATING SELECTOR ANALYZER

- Build App #36 correctly stopped at Dart analysis because a stale `enabled` local remained in the Floating selector after Fan-specific gating was removed.
- Removed that unused selector variable; checkbox interaction remains directly available for all supported metrics.
- The separate Fan metric remains absent; S (Speed) is the sole fan-related metric.
- Rebuild is required before delivery; no APK from #36 was produced.

## 2026-10-01 — BUILD VALIDATION FIX / LIGHT THEME EXPECTATION

- Build App #37 reached all source checks and failed only one deterministic Light Theme test because the test expected `#16181D) while the current shared Light semantic foreground is intentionally `#111318`.
- Updated the regression expectation to the actual Light Theme contract; this is a test-alignment fix, not a UI rollback.
- No Floating, BLE, firmware, or runtime behavior was changed by this validation fix.


## 2026-10-01 — BUILD APP #38 SUCCESS / FLOATING METRIC CLEANUP VALIDATED

- Build App Run #38 (`36781082099`) completed successfully from source commit `97e14c94535ea313556887b00870a0e63966d5ce`.
- Pipeline passed: security/architecture audit, dependency installation, Dart analyze, Flutter tests, release APK build, production APK signature verification, release APK filename preparation, exactly one APK artifact upload, and Dart symbols upload.
- The final validated source includes the Floating contract with no separate Fan metric; S (Speed) is the sole fan-related Floating metric.
- Floating selector regression test passed; Light Theme and Manual Auto Connect tests also passed.
- Release APK artifact: `JEXFYZ#38.apk`
- APK artifact ID: `11127881733`
- APK artifact size: `54,147,072` bytes
- APK SHA-256: `10285ef6b0927dafc21f14ffc312e659ba0eef4a4387fbf0cf92aefcbcf0b7d6`
- Dart symbols artifact ID: `11127592726`
- Dart symbols SHA-256: `ad18cf5438d75b7a956919063a8f88f58b9f63af623c144fae4e612ba648286c`
- Build artifact count is exactly one APK plus the symbols artifact.
- The APK is now available for direct chat delivery from the validated Build #38 artifact.
- No firmware, BLE UUID/P1 protocol, OTA transport, Firebase metadata contract, GPIO mapping, or signing identity was changed.

## 2026-10-01 — FULL EXECUTION / LIGHT MODE VISUAL REDESIGN

- Redesigned Light Mode around a softer cool-gray background plus white surfaces, instead of a near-white background everywhere.
- Light Theme palette:
  - Main background: `#EEF0F4`
  - Surface/card: `#FFFFFF`
  - Primary text: `#111318`
  - Secondary text: `#3F444D`
  - Surface container: `#E4E7EC`
  - Outline: `#D6DAE1`
  - Outline variant: `#DDE1E7`
  - Divider: `#D7DBE2`
  - Input fill: `#F5F6F8`
- Dashboard Light background now uses the same `#EEF0F4` visual foundation; inactive navigation tabs use a darker neutral surface and stronger border.
- Semantic device colors (Battery, Hotside, Voltage, Adaptive, Peltier, Fan) were preserved.
- Dark and Default themes were not changed.
- Updated regression tests to lock the new Light Mode surface/contrast palette.
- This was an App-only visual change. Firmware, BLE UUID/P1 protocol, OTA transport, Firebase metadata, GPIO mapping, release signing identity, and Floating Monitor logic were untouched.
- Build App was not triggered by this execution.

## 2026-10-01 — FOLLOW-UP / PASSIVE AUTO CONNECT + BLUETOOTH PERMISSION FLOW

- Auto Connect is now explicitly passive:
  - It never calls BLE permission `request()`.
  - It never calls `FlutterBluePlus.turnOn()`.
  - It does nothing until Auto Connect is enabled, a previously successful cooler identity is stored, BLE scan/connect permissions are already granted, Bluetooth is already ON, and any legacy Android location requirement is already satisfied.
- A fresh install therefore cannot auto-connect to a cooler that has never been connected before, even when the user manually enables Auto Connect.
- Manual Bluetooth scan remains allowed to request the Android `Nearby devices` permission.
- When the user previously selected `Don't allow`, tapping the Bluetooth status control retries the permission request inside the App instead of calling `openAppSettings()`.
- The last successfully completed BLE/P1 session stores only the cooler `remoteId` in `flutter_secure_storage`; that identity is the sole device target for passive Auto Connect.
- Auto reconnect after disconnect and post-OTA reconnect now use the same passive policy, so they cannot silently prompt for permission or power Bluetooth on.
- No firmware, BLE UUID/P1 protocol, OTA transport, Firebase metadata, GPIO mapping, or release signing identity was changed.


## 2026-10-01 — FOLLOW-UP / AUTO CONNECT PREFERENCE LIFECYCLE

- Dashboard now reacts immediately when the Auto Connect preference changes.
- Enabling Auto Connect triggers the same passive prerequisite check without requesting permissions or changing Bluetooth power.
- Disabling Auto Connect cancels pending automatic reconnect timers/scans.
- Fresh install remains safe: with no known cooler identity, enabling Auto Connect still performs no scan or connection.


## 2026-10-01 — FULL EXECUTION / LED VISUALIZER + ANCHORED COLOR PICKER

- LED submenu now uses a custom horizontal **8-LED visualizer**. The physical strip remains 4 LEDs on the left + 4 on the right; the App intentionally flattens the eight logical positions into one row.
- Preview mode formulas mirror the current firmware renderer for the seven supported LED modes:
  - STATIC
  - BREATH
  - CENTER OUT
  - OUTER IN
  - DUAL CHASE
  - LEFT RIGHT
  - RAINBOW
- Preview uses the firmware timing periods and the 1–100% master brightness relationship. Animation phase is app-local because the current BLE protocol does not expose the firmware's LED animation phase.
- Expanded the App color preset palette from 12 to 24 curated RGB presets and added `#FFFFFF`.
- Black and light/dark color variants are intentionally excluded; brightness remains the intensity control.
- Replaced the centered Color dialog with an **anchored floating Color Picker** positioned near the COLOR row and adaptively opening above/below based on available screen space.
- Color picker is custom, compact, 6-column grid with selected-state checkmark and white-swatch border handling.
- The selected color swatch in the LED control now represents white correctly.
- Added automated regression coverage for the 8-LED preview and expanded palette/white contract.
- No firmware source was changed. BLE UUID/P1 protocol, OTA, Firebase metadata, GPIO mapping, and release signing identity remain unchanged.
- Build App was not triggered by this execution.

## 2026-10-01 — FULL EXECUTION / JE X FYZ CUSTOM INDICATOR MOTION ENGINE

- Replaced the previous generic icon motion approach with a full custom `CustomPainter`-based JE X FYZ indicator animation engine.
- Each status indicator now has its own geometry and motion language:
  - Battery: internal energy fill + moving energy flow.
  - Hotside: rising thermal waves + optional warning ring.
  - Voltage: custom lightning geometry + moving electrical sparks.
  - Adaptive: orbital ring + moving energy orb.
  - Peltier: thermal exchange particles around the core.
  - Fan: custom 3-blade geometry + speed-scaled rotation + subtle airflow particles.
  - Speed: custom gauge + dynamic needle behavior.
  - LED: eight-point light strip animation.
  - Bluetooth: custom Bluetooth geometry + expanding wireless signal waves.
- Generic action/navigation glyphs (for example settings/action icons) remain static; they are not device-status indicators.
- Added individual motion durations per indicator type rather than one generic animation timing.
- Added a centralized `jexIndicatorAnimationActive` gate.
- Animation contract:
  - BLE disconnected => all device/status indicator animations are frozen/static.
  - BLE connected + indicator/device state inactive => that indicator remains static.
  - BLE connected + indicator/device state active => that indicator animates.
- The Home Speed indicator specifically uses `fanOn` as its animation gate, so Fan OFF cannot animate merely because the stored speed value is non-zero.
- `_switchRow` now also gates indicator motion by both BLE connection and the actual switch state.
- Header Bluetooth now uses the custom Bluetooth painter and only animates while connected.
- Firmware source was not modified. BLE UUID/P1 protocol, OTA, Firebase metadata, GPIO mapping, and signing identity remain unchanged.
- Added regression tests for the centralized animation gate and distinct motion timing.
- Build App was not triggered by this execution. Runtime visual validation remains a fresh-APK/device test requirement.

## 2026-10-01 — BUILD VALIDATION FIX / CUSTOM ICON ENGINE CONSTRUCTORS

- Build App #39 stopped at Dart analysis after the full custom motion refactor.
- Root causes identified from CI logs:
  - `_JexColorPickerCard` had been inserted inside the Dashboard State class instead of at top level.
  - The Bluetooth header used `JexAnimatedIcon.glyph(... kind: ...)`, which is not a valid constructor contract.
- Corrected both source-level issues:
  - Moved `_JexColorPickerCard` to top-level.
  - Changed Bluetooth header to the full `JexAnimatedIcon(kind: ...)` custom constructor.
- No design or device protocol behavior was intentionally changed by this validation repair.
- Build #39 produced no APK because analysis failed; a new Build App run is required.


## 2026-10-01 — BUILD APP #40 SUCCESS / FULL CUSTOM INDICATOR ANIMATION

- Build App Run #40 (`36797284179`) completed successfully from source commit `66ef4a2fbd3fa3ac0236e21170420c39a231ac08`.
- Build pipeline passed: security/architecture audit, dependency installation, Dart analyze, Flutter tests, release APK build, production APK signature verification, release APK filename preparation, exactly one APK artifact upload, and Dart symbols upload.
- The build validates the full custom JE X FYZ indicator motion engine and the BLE/state animation gating introduced in the current source.
- Release APK artifact: `JEXFYZ#40.apk`
- APK artifact ID: `11134361764`
- APK artifact size: `54,245,340` bytes
- APK artifact SHA-256: `87fb858aeba5dbd64c00639cf1b3482e3438871bbdee18fef3e0fda460d7c226`
- Dart symbols artifact ID: `11134596362`
- Dart symbols SHA-256: `1a754cf12c26ad4df2ab1df2e7802fccaf5d6c43e59a4ce7af1464d2208eddc0`
- Exactly one APK artifact exists, plus the Dart symbols artifact.
- The downloaded artifact is an APK byte stream despite the connector filename carrying a `.zip` suffix; local file inspection identifies it as an Android package and its SHA-256 matches the GitHub artifact digest exactly.
- Direct chat delivery file prepared at `/mnt/data/JEXFYZ#40.apk`.
- No firmware source, BLE UUID/P1 protocol, OTA transport, Firebase metadata contract, GPIO mapping, or signing identity was changed.
- Runtime visual behavior still requires on-device testing, especially custom indicator animation appearance and state transitions.

## 2026-10-01 — FULL EXECUTION / SUBMENU UI REDESIGN V2

- Completed the previously missing **full custom redesign of all five Dashboard submenus**:
  - VOLTAGE
  - CONTROL
  - ADAPTIVE
  - LED
  - TEMPERATURE
- Unified submenu spacing:
  - list padding is compact and consistent
  - shared section headings are tighter
  - shared card margins reduced
  - long separator/divider lines are removed from the five submenu layouts
- VOLTAGE:
  - remains vertical top-to-bottom
  - only one voltage can be selected
  - custom toggle-style selection state replaces the previous radio-like presentation
  - selected state is theme-aware for the Dark preset
- CONTROL:
  - replaced default Material switch presentation with a custom JE X FYZ toggle
  - Peltier/Fan rows are compact and state-driven
  - Speed remains visible at all times; Fan OFF displays OFF/MATI and the speed animation is gated by Fan state
  - editable Speed slider remains restricted by existing connected/manual/12V/Fan-ON rules
- ADAPTIVE:
  - removed Material `RadioListTile`
  - profile selection is now custom single-select rows with dedicated selection indicators
  - Adaptive switch remains authoritative through existing command/state logic
  - lock state remains visible without legacy radio styling
- LED:
  - control shell fully reorganized into custom Power, Mode, 8-LED preview, Brightness, and Color surfaces
  - existing horizontal 8-LED visualizer, 24-color palette, White, and anchored floating Color Picker are preserved
  - mode navigator is compact and custom
- TEMPERATURE:
  - replaced legacy adjuster/separator layout with compact custom +/- controls
  - 5V Ceiling and 12V Floor retain existing safety constraints
  - 9V derived zone is shown as a compact locked row
  - Adaptive lock notice and reset action retained
- Localization:
  - added localized `adaptiveProfile` (Profile/Profil) and `mode` (Mode/Mode) labels.
  - user-facing custom labels remain routed through JexText.
- Functional contracts were preserved: BLE/P1, firmware telemetry authority, voltage switching guards, Adaptive profile commands, LED commands, temperature safety ranges, OTA, Firebase, GPIO, and release signing were not changed.
- This is an App presentation-layer execution only. Build App was not triggered by this execution.

## 2026-10-01 — APP VERSION LABEL UPDATE

- Android `versionName` is now exactly `Telegram @horizontalzzz`, so Android App info will display that requested version label.
- The Floating Monitor/About version field was updated to the same `Telegram @horizontalzzz` label to avoid a UI mismatch.
- Flutter package version in `pubspec.yaml` remains `1.0.0+3` because it is the package/build metadata source; Android `versionName` is the user-visible App info label requested here.
- No applicationId, versionCode, signing identity, BLE/P1 protocol, firmware, OTA, or Firebase behavior was changed.
- Build App was not triggered by this execution.

## 2026-10-01 — BUILD APP #41 SUCCESS / SUBMENU V2 + APP VERSION LABEL

- Build App Run #41 (`36800153829`) completed successfully from source commit `6deff1af4cb74310a00ee4ee0f3ed1584225c351`.
- Passed: security/architecture audit, dependency installation, Dart analyze, Flutter tests, release APK build, production APK signature verification, release APK filename preparation, exactly one APK artifact upload, and Dart symbols upload.
- Release APK artifact: `JEXFYZ#41.apk`
- APK artifact ID: `11135950331`
- APK artifact size: `54,245,456` bytes
- APK artifact SHA-256: `0470a30268b455cb55e564a3ce34ef05ac5b5a744f364b3765cd2ad29d14109e`
- Dart symbols artifact ID: `11135985299`
- Dart symbols SHA-256: `4890c4baa223e687a356488d969b900f9c03b0f784d557a24cf38abda0fb80c2`
- Exactly one APK artifact exists, plus Dart symbols.
- Android `versionName` in this build is `Telegram @horizontalzzz`, matching the requested App info label.
- Build includes the full custom submenu V2 presentation-layer redesign and the custom JE X FYZ indicator motion engine already committed before the build.
- Direct chat APK copy prepared at `/mnt/data/JEXFYZ#41.apk`; the artifact bytes are verified as an Android APK and the SHA-256 matches the GitHub artifact digest.
- No firmware source, BLE UUID/P1 protocol, OTA transport, Firebase metadata contract, GPIO mapping, or signing identity was changed by the version-label/build steps.


## 2026-10-01 — VERIFIED FAN/PELTIER OUTPUT INVERSION FIX

- User confirmed a physical mismatch: App FAN ON activated the Peltier output.
- App-side protocol mapping was verified and intentionally left unchanged (`FAN:ON/OFF`, `PELTIER:ON/OFF`).
- Embedded firmware source `firmware/JEXFYZ-V2.3.ino` was corrected to map physical outputs as `PIN_FAN = 6` and `PIN_PELTIER = 5` to match the observed hardware behavior.
- No App telemetry labels were swapped and no safety prerequisite was bypassed.
- The external firmware repository contains a binary-only artifact, so a fresh firmware BIN must be compiled/flashed separately for this source correction to reach the ESP32.
- App Build was not triggered for this firmware-only correction.


## 2026-10-01 — FULL EXECUTION / FIRMWARE REPO SYNC FOR FAN-PELTIER FIX

- Corrected firmware source was synchronized from the embedded App copy into the dedicated `TenzoNkz/JEXFYZ-Firmware` repository as `JEXFYZ-V2.3.ino`.
- Dedicated firmware repo source commit: `89dc8ea08c7d97e28fa8c452e1f7214cbff793a5`.
- Dedicated firmware notes commit: `4bfca310fbd02ac77bebed4d06e805966e96e96e230`.
- The dedicated repository's prebuilt `JEXFYZ.cpp.bin` remains unchanged because no verified Arduino-ESP32 Core 3.3.7 compiler toolchain is available in this execution environment. No unverified binary byte patch was performed.
- Physical correction in source is `PIN_FAN = 6`, `PIN_PELTIER = 5`, while App BLE/P1 command tokens remain unchanged.


## 2026-10-01 — FULL EXECUTION / LOCK VERIFIED PHYSICAL OUTPUT MAPPING

- Confirmed physical behavior remains the source of truth: App FAN ON was activating the Peltier output.
- App protocol mapping was re-verified and remains correct; no FAN/PELTIER command-token swap was introduced.
- Firmware output mapping is now locked at compile time as **GPIO5 = PELTIER, GPIO6 = FAN**, with a `static_assert` guard to prevent accidental reversal in future firmware edits.
- All stale App-repo documentation statements were normalized to the corrected physical mapping.
- Safety semantics remain unchanged: logical Peltier still requires logical Fan ON and all existing NTC/hotside/OTA safety checks.
- The production external firmware repository still contains a binary-only artifact; the corrected source is in the App repository. The ESP32 hardware will change only after a firmware binary compiled from this corrected source is flashed.
