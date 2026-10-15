# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

## 0. Snapshot scope and evidence boundary

Snapshot refreshed after `@Thinking Chat Stuck!` recovery on 2026-10-15 (Asia/Jakarta). Build #49 is still the last successful Release; Shizuku FPS source/workflow changes are committed but their tests/build/release have not run. No build trigger was opened.

- App repo: TenzoNkz/JEXFYZ-App
- Current implementation checkpoint: `b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b` (Shizuku FPS migration; later commits only update docs).
- Current source blobs: main.dart `3eeb4dff7b7fbb52a44022e5e2b130bc1826da23`; Floating UI `232fde06efda5bfaa2221825a04c0106ad5feb33`; app settings `6f99911bc59451473823aea1e1`; widget tests `520399fcdc6be4fd69cb48f50aa8961f5d9183c5`; Shizuku FPS contract test `bd27d2c7adc20ab76bab504378a2353d01ab473b`.
- Latest successful App build: [Build #49 / 38739077916](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38739077916), source commit `2b2d2886abb66481b7134e5036824f625ab5659d`, issue [#22](https://github.com/TenzoNkz/JEXFYZ-App/issues/22), job `116435785328`, runner `1000002352`. All 80 tests and release gates passed for that older source.
- Latest Release: [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) still contains Build #49's APK and matching source ZIP; neither contains current source commit `b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b`.
- Active App Build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`; issue-only owner/title/token gate remains intact. Its Shizuku/MIT audit and source-bundle packaging changes have not run in CI.
- Current changes include the existing thermal/Home animations plus Shizuku-gated FPS access. Metric F requires a running Shizuku Binder/API and explicit user approval; native FPS runs through a restricted fixed-operation AIDL UserService. Wireless ADB pairing, Kadb/SPAKE2, ADB identity-store code, manifest DUMP permission and grant/revoke UI are removed. Battery temperature reading and the one-second firmware heartbeat remain unchanged.
- Thermal/widget assertions and the Shizuku FPS contract test are committed but NOT RUN. `@Thinking Chat Stuck!` does not trigger a build; the separate App Build command is `@Thinking Eksekusi Build App!`.
- App version/package: 1.0.0+3 / com.horizontalzzz.jexfyz.
- Firmware repo TenzoNkz/JEXFYZ-Firmware remains BIN-only. No Firmware/BIN/Firebase/OTA/flash/device operation was performed.



Evidence terms:
- CURRENT / VERIFIED means directly checked against live source/repo/CI evidence.
- SOURCE IMPLEMENTED / NOT RUN means implementation exists but its required execution has no evidence.
- USER-REPORTED means the user reported it; do not present it as an assistant-witnessed result.
- UNVERIFIED means the required evidence is missing.
- HYPOTHESIS means possible, not demonstrated.
- HISTORICAL / SUPERSEDED means it applies only to an older revision or path.
- NOT RELEASED means no verified released artifact contains the current source.
- A test contract is not proof a test ran; App CI is not Arduino firmware compilation; successful APK compilation is not release publication; visual LED feedback does not identify a specific HTTP/TLS error.

## 1. Current source, Release state, and next App Build action

### Current source — IMPLEMENTED / NOT RUN / NOT RELEASED
- Implementation checkpoint: `b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b`. This adds Shizuku-gated FPS authorization/execution after the existing Home/thermal UI work. Key source: Floating UI `232fde06efda5bfaa2221825a04c0106ad5feb33`; localization `6f99911bc59451473823aea1e1`; widget assertions `520399fcdc6be4fd69cb48f50aa8961f5d9183c5`; Shizuku contract test `bd27d2c7adc20ab76bab504378a2353d01ab473b`.
- Before metric F can be selected, Shizuku must be running, its Binder/API must support UserService, and the user must approve JE X FYZ in Shizuku's permission UI. The native Floating Monitor enforces this gate independently of Flutter.
- Elevated FPS reads are performed by `FpsShizukuUserService` through an AIDL fixed-operation interface. The normal app process no longer executes dumpsys or declares `android.permission.DUMP`; the old Wireless ADB pairing/Kadb/SPAKE2/ADB identity/grant/revoke path is removed.
- Workflow static audit and corresponding-source packaging were updated for pinned Shizuku API/provider 13.1.5 and its MIT license notice. No tests, analyzer, Android/Kotlin compilation or App Build have run against this source. Current source is NOT RELEASED.

### Latest verified App Build: SUCCESS for older source
- Build #49 — [run 38739077916](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38739077916); job `116435785328`, runner `1000002352`; source commit `2b2d2886abb66481b7134e5036824f625ab5659d`; issue [#22](https://github.com/TenzoNkz/JEXFYZ-App/issues/22). All main steps passed, including 80 Flutter tests, APK, signing V1/V2/V3, production certificate, corresponding-source ZIP, Release publication and downloaded-asset verification. This result does not cover current thermal-animation source.
- Release: [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest), APK `JEXFYZ-release.apk` SHA-256 `d365a99812470986de08be4df1bd54254fe1eb1ea1e3739806d03a6503e3c52a`, corresponding source ZIP SHA-256 `51783b82eae47fc69ab08dd90521e5acdeed0988600042dd1bc3b94f5483dbc8`. These assets are still Build #49's older revision.
- Build #48's check annotation identified failed recent account payments or an insufficient spending limit; #49 allocated a runner and completed. No workflow modification/manual-dispatch trigger was needed.
- Workflow trigger semantics remain issue-open/reopen only with the owner/title/token gate; active blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. Shizuku/MIT audit and source ZIP changes are committed but have not run in CI.

### Next action
Use `@Thinking Eksekusi Build App!` to run Flutter analysis/tests, rebuild and sign the APK, verify the corresponding-source bundle, publish the new revision, and re-download/verify all Release assets. Do not claim the current source is released until those gates pass. Physical phone validation remains separate.


## 2. Repository boundaries and current inventory

- TenzoNkz/JEXFYZ-App is the canonical editable App + Firmware source repository and the only repository for all project docs, history, handover and prompts.
- TenzoNkz/JEXFYZ-Firmware is an artifact repository and must contain only JEXFYZ.cpp.bin. Live verified artifact root has exactly one file: blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6, 1,455,936 bytes. Do not add notes or touch the BIN during docs work.
- Canonical active workflow is `.github/workflows/jexfyz-app-build-trigger.yml` (blob `585d190324e522fc08e66cc95bd7ee80c5f37664`). Trigger remains issue opened/reopened, repo owner, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, and body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal push/PR does not trigger it.
- Branches at audited parent: diag/latest-stable-v16, diagnostic/v1.6-heap-check, fix/adaptive-power-sequencing, main, tmp-jexfyz-v5-test; open PR count = 0.
- Do not rely on older tree counts in history. This snapshot's parent is 76 tree entries / 55 blobs; fetch the live tree on the next task.
- Keep all docs in App repo. Do not rename or delete a file without repairing every link, prompt, index and test reference.
- Archived notes are immutable forensic snapshots. They contain duplicated and stale CURRENT TRUTH blocks for V5.x/V6.1/V6.2/V6.3/V6.4; do not quote those blocks as current truth.

## 3. Current source identity and important hashes at the audited parent

### App / Android / build

- lib/main.dart: 74b6bcc47d69ccf114f710ed73dfcefe93037111
- lib/floating_monitor.dart: bd230aee16fa77a0d8d2afb9f1a0c2d80cdcac86
- lib/app_settings.dart: c513cd4381ee960cd43612c4ac01e7954f651f62
- lib/jex_animated_glyph.dart: c9c5c2802cb0ed363c042620511148b0d58d36c4
- pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a, version 1.0.0+3
- pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66
- android/app/build.gradle: 05a0b863cfc6d73dc3789e364d7000eee0f3db0e
- android/settings.gradle: 14545695cc9aba5912393ec293c284ee60d9ec10
- android/gradle.properties: 13564f62c79279ecfd4fe0a8a247a4d2a4b11451
- android/app/src/main/AndroidManifest.xml: 2124dcd969347d2c7bb1bd99374a398cf50d2387
- android/app/proguard-rules.pro: 50fc26f726ae8660fe04cf19da688431c8dca4a0
- android/app/google-services.json: f3ed065a7ee56b2a44f0a943a48fa578ba72e0d7; never display or copy credential contents.
- Package ID com.horizontalzzz.jexfyz. Gradle versionName "Telegram @horizontalzzz" is intentional user identity; preserve exactly.
- Canonical BLE P1 UUIDs in current source: service 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001, RX 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001, TX 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001.
- Native relevant sources:
  - FloatingMonitorService.kt `bfc0956688bab5951ea2c626427a691ed63b6921`
  - MainActivity.kt `a139dfefe1121963c3a26b114b9b0fcc9f8fa16a`
  - FpsShizukuUserService.kt `1f5ed36dadaba9dc70ecfbe0793114b34c8ab08b`
  - IFpsShizukuUserService.aidl `ddb0c442029d8f291e99eb6682bd2a690e6c9709`
  - JeForegroundService.kt `9ea4dce7001bcd5cc10f9c1c7ad62f34ec54b03e`
  - JexNotificationUtils.kt `aecfc87121f2195ef6724613c612d674ed95ae55`
  - WirelessAdbPairingService.kt and WirelessAdbIdentityStore.kt are deleted from current tree.
- License/notice files: Shizuku MIT license `third_party/Shizuku-API-MIT.txt` (`2a779796d4f141d0fe3a13c612c4c66414a3d65a`), notice `third_party/THIRD_PARTY_NOTICES.md` (`4dcd7ea1d6979c081e0ebd5acb7db34f6e64e1f2`), plus a bundled MIT license asset. Old Kadb/SPAKE2/GPL license files are deleted.

- Assets: assets/jexfyzcooler.png blob fbc47e3197534ae35330c1f1793c99705e5165d1, size 1,830,171; assets/jexfyzicon.png and Android nodpi icon bad855f23416fd58aff194c30b7f8fd77f260ea8, 436,439; notification vector cda9e8404d14a62a61157ec59fae2e491c19f5f7.
- License/notice files: third_party/Kadb-1.3.0-LICENSE.txt 261eeb9e9f8b2b4b0d119366dda99c6fd7d35c64; third_party/THIRD_PARTY_NOTICES.md ec505ebc22dac34924bf3318158061ae693cb9d5; GPL-3.0 SPAKE2 license at both App third_party and Android assets is blob e72bfddabc15be5718a7cc061ac10e47741d8219.
- pubspec.yaml dependencies include Flutter, flutter_blue_plus, firebase_core, firebase_app_check, flutter_secure_storage, permission_handler, phosphor_icons; dev deps flutter_test and flutter_lints.

### Test inventory / executed evidence

### Current test inventory / execution evidence
- `test/shizuku_fps_contract_test.dart`: `bd27d2c7adc20ab76bab504378a2353d01ab473b` (committed, NOT RUN on current source).
- `test/widget_test.dart`: `520399fcdc6be4fd69cb48f50aa8961f5d9183c5` (updated source assertions, NOT RUN on current source).
- `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`.
- `test/firmware_touch_adaptive_sync_test.dart`: `2d3fea509343a03b8d23623f4dcb2dd7fd972d39`.
- `test/v6_6_qc_contract_test.dart`: `2bee4d960d014f0765422dcb5ed1c9870ba6ee3a`.

Historical CI: Build #49 run `38739077916` passed Dart analysis, all 80 Flutter tests and release gates for older source `2b2d2886abb66481b7134e5036824f625ab5659d`. This does not prove current Shizuku source has compiled or that the new tests pass. The prior ADB pairing test was deleted; presence of a new test file is not execution evidence.

No current-source build/test was started during `@Thinking Chat Stuck!` recovery.

## 4. Firmware source / hardware / timing — CURRENT source truth

- Active editable source exactly firmware/JEXFYZ-V6.6.ino, embedded static constexpr char FW_VERSION[] = "V6.6" blob f51ba6db5d0e91318f63fea4014bb87f7bf76222, 164,378 bytes / 5,254 lines. Exactly one active versioned .ino and filename/version match. App tree contains no other active .ino.
- Target ESP32-C3 Super Mini / ESP32-C3 Dev Module, 3.3V logic.
- Pin map: GPIO0 NTC; GPIO1 TTP223; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier MOSFET; GPIO6 Fan MOSFET; GPIO7 WS2812. A source static_assert reinforces Peltier pin 5, Fan pin 6.
- MOSFET wiring memory: GPIO → R100 → Gate; 100kΩ Gate–Source pull-down; Fan positive at supply and Fan negative at MOSFET Drain. Earlier apparent 12V selector defect was user-confirmed loose cable; do not label it a software defect.
- NTC 10k nominal + 10k fixed resistor, Beta 3950, calibrated analogReadMilliVolts(PIN_NTC), exactly one sample/sec; user explicitly rejected median, trimmed mean and multi-sample averaging. On invalid NTC, fail safe per active code: Peltier OFF, Fan 100%, Adaptive OFF and safe 5V.
- Peltier PWM 20kHz/8-bit, normal OFF→ON soft-start 5s. Fan PWM 25kHz/8-bit; manual target 50–100% in increments of 10; safety can force 100%. Rail selector break-before-make 200ms, shared 1,000ms guard/settle. Saved settings are flushed after a 10s quiet debounce.
- Accepted voltage transition:
  - Peltier logically OFF stays OFF across voltage switch.
  - If Peltier ON and 5s ramp is still in progress, pause GPIO5 at 0% before switching selectors, keep 200ms deadtime + 1s settle, then begin a fresh 5s ramp.
  - If ramp already completed, keep Peltier PWM at 100% across selector transition; no forced 0%, no redundant restart.
  - Fan remains on/forced to 100% during rail transition.
  - explicit Peltier OFF, Hotside/NTC safety and OTA clear/cancel pending resume.
  - Adaptive ON/OFF still hands selector to safe 5V without forcing a redundant Peltier OFF cycle solely for handoff; safety and explicit OFF always override.
  - Two reset symptoms reported separately: 5V→12V while Fan/Peltier on during active ramp, and enabling Adaptive while at 12V with Fan/Peltier on. Reset reason was not captured. Brownout is only a hypothesis; if user later authorizes reproduction, capture BOOT: RESET_REASON=... and telemetry. These issues are historical/not active work because the user accepted V6.6 final.
- Thermal safety:
  - Hotside limit 40–50°C; default 45°C.
  - manual Peltier re-arm at hotside <= hotLimit - 1°C continuously 5s; no single sample bypass.
  - Adaptive thermal stages of 30s at 12/9/5V, Peltier OFF, Fan 100%. Five seconds continuous stable at/below limit−1 before deadline cancels stage; otherwise step down at 12/9V or terminal manual-restart lock at 5V. Recovery rises one rail at a time after 60s continuously stable and does not exceed saved prior Adaptive ceiling.
  - No rapid Hotside rate-of-rise protection is implemented. The older request for rapid rise Peltier shutdown and manual re-arm remains unimplemented; not to implement post-user acceptance unless separately reopened.
- HOTSIDE startup default; HOTSIDE_BATTERY is runtime selectable, not persisted. App sends phone Battery PHONE:BT=<Celsius> heartbeat at 1Hz while BLE is ready; firmware TTL 5s; current thresholds 25°C at 5V and 35°C at 12V, hysteresis 0.5°C. Expired phone Battery falls back to HOTSIDE without rewriting profile. No standalone Battery Protection Guard UI.
- TTP223 one touch sensor only (no separate WiFi/BLE toggle); timings approx 1s startup grace, 30ms qualify, 60–500ms tap, 800ms double-tap window, 5s long press.
- LED mappings and sync below; no blocking delay() or timing while() in firmware source.

### LED / App-firmware sync

- Firmware IDs Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. Mode 3/Mirror Pulse retired; stored invalid/ID3 migrate Static; new MODE:3 is rejected.
- LED snapshot one atomic LED_SYNC:<mode>,<phase_ms>,<cycle_ms> based on BLE notify-time phase; App interpolates using monotonic time and corrects drift without restarting on every update. Old separate phase/cycle deltas are compatibility fallback.
- Adaptive ON indicator: 3 orange blinks; Adaptive OFF: 3 white blinks, deferred until safe 5V handoff where needed. Boot-time OFF white blink missing after restart was user-reported and remains physical/boot behavior unverified.
- Voltage color defaults: 5V red, 9V green, 12V blue; customizable/resettable. Safety/OTA indicators outrank decorative RGB.
- User's accepted V6.6 report: compiled and two successful Online OTA updates with same version. USER-REPORTED; assistant did not inspect the Arduino compile/OTA logs, and binary provenance is not independently verified.

## 5. OTA protections — DO NOT EDIT during unrelated cleanup

- Before any OTA changes read OTA_PROTECTION.md blob 06beb86b749b0f0e14c8cb517e43fe7c0f66a4e1 and OTA_REGRESSION_MEMORY.md blob 4342f3da76cf2962140146fbbe0ff8de5e956f4d. Before any voltage/rail/Peltier timing edit also read VOLTAGE_TRANSITION_MEMORY.md blob 1c2167659fd0ed8f5db16bf63eb7897344a690ea.
- Local OTA boot SoftAP has no-client timeout 10s, hard cap 60s after interaction, then Wi-Fi-off and 160ms radio settle before BLE owns radio. ESP32-C3 only has one radio path; do not allow BLE and Wi-Fi active together.
- During OTA outputs are forced safe per protected state machine; do not refactor Local OTA, Online OTA, state machine, radio handoff, priority, timeouts, redirect policy, image checks, Update lifecycle, failure recovery or restart without a proven OTA defect, discussion/explicit approval and full re-audit.
- Current Online OTA uses cloudClient.setInsecure(). The V6.3-origin change removed embedded CA validation and OTA-only NTP/TIME_SYNCING gate at the same time following user-reported blue Wi-Fi then red GitHub-stage failure. User then reported source compile and GitHub connectivity restored; exact HTTP/TLS cause was never isolated. setInsecure() encrypts but does not authenticate server certificate identity. Don't infer HTTP/TLS codes from LEDs; don't silently add CA/NTP gates.
- Preserve raw GitHub firmware URL allowlist https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/, redirects disabled, response/length/size checks, ESP image magic byte 0xE9, streaming update, safe outputs and recovery/restart semantics.
- OTA metadata intended by user is version + link only; no custom SHA/signature field without separate authorization. Do not assume the BIN matches current source without build provenance.
- App OTA sequence: OTAENTER → SSID → PASS → URL → VERSION → CLOUDOTA; timeout/disconnect ACK is ambiguous, preserve recovery state until result/reconnect. Separate Wi-Fi join, GET/HTTP status, full byte transfer, image validity, Update.end, reboot, BLE reconnect, installed firmware version and Firebase promotion evidence.

## 6. App UI / BLE / device behavior requirements

- App product JE Cooler, brand/title/header JE X FYZ, package com.horizontalzzz.jexfyz, pubspec version 1.0.0+3. Gradle versionName "Telegram @horizontalzzz" immutable.
- Visual reference Horizon Cooler App: dark header + white rounded content panel, compact VOLTAGE/ADAPTIVE tabs, Home shows Hotside/Battery temperatures, Voltage Indicator, Adaptive Mode, Peltier/Fan and Fan Speed plus Notify reason; menu order VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Do not casually redesign during QC.
- Firmware/telemetry is authoritative; ACK alone is not proof a physical output changed. Manual 5/9/12V cycle 5→9→12→9→5, one-second guard and wait for matching VOLTAGE telemetry before updating confirmed state. Manual Fan Speed is not Adaptive-controlled; Adaptive may demand 100% cooling.
- BLE App does not make a second GATT client in native services. Auto-connect passive: it cannot enable Bluetooth or request permissions itself; requires known cooler identity, permissions, adapter on and no sync collision. Disconnect rediscovery stops if disabled/prerequisites unavailable. Machine protocol tokens remain English; UI localized English/Indonesia. On disconnected Home/Floating values, use --, not cached state; disabled OFF-looking switch rows are a visual fallback only.
- App sends phone Battery heartbeat every second; pending heartbeats coalesced. No standalone Battery Protection Guard UI. One-App/one-cooler identity lock remains a user design requirement, not proven exclusive enforcement.
- Color Picker: 36 localized color preset names; no HEX labels; hue order, legacy aliases incl Cyan #00FFFF, no pure black preset. Draft swatch selection does not send BLE command until localized Select; Cancel discards draft; outside/system Back blocked; modal bottom-pinned with larger readable type and touch targets. Select closes only after the existing confirmed COLOR path reports success; failed/unconfirmed leaves dialog open.
- Submenus remain compact; OFF-looking toggles at left; no large center box. User requested separate reset buttons by function, not global reset. Preferences save 10s after no change and only changed data are sent.
- Seven Home indicator animation implementation:
  - Battery = segmented thermal bar driven by valid battery temp; Hotside = clean thermometer/bulb (heat-wave strokes removed to avoid overlap); both retarget 520ms, never invent missing sensor value.
  - Voltage bolt has sinusoidal sweep clipped to bolt, no snap/reset at boundary.
  - Adaptive ring/orbit/core moves only when actual Adaptive ON.
  - Peltier is a free-standing bright six-branch frost crystal with four peripheral sparks; no box/frame/bolts and no OFF fade.
  - Fan rotor follows authoritative voltage: 5V 2600ms, 9V 1250ms, 12V 620ms; phase preserved on rail changes; OFF eases out briefly (~0.16 turn) and full-color blades remain.
  - Fan Speed gauge retargets from current rendered level to actual new target over 420ms; OFF takes 520ms to zero; needle wobble uses integer-frequency sine harmonics for seamless repeat. Reported % stays authoritative.
  - Bluetooth ripples use squared-sine opacity with zero slope at loop edges.
  - Notify labels are exactly CONNECTED/DISCONNECTED in both app languages; detailed notices/error/connecting/syncing remain intact. A plain Bluetooth Disconnected body is not itself an error; current state uses BLE flag.
- Android notifications: use transparent white JE vector as the sole small notification icon, no large icon; localized meaningful body, tap opens App; Android13+ notification permission requested before native notification workflow.
- Android native Floating Monitor:
  - FloatingMonitorService.kt owns WindowManager overlay; Flutter is sole BLE client and streams telemetry. Settings center preview removed; explicit Horizontal/Vertical segmented control. Layout responds to live value width; replay current telemetry after service attach.
  - FPS does not count Flutter FrameTiming or substitute phone display refresh rate. It samples SurfaceFlinger --timestats about once per second, filtered to the Android resumed/focused package and matching layer names.
  - Hard gate: metric F requires Shizuku Binder/API availability and explicit JE X FYZ approval inside Shizuku's own permission UI. Native FloatingMonitorService independently enforces the gate; a saved F selection is removed when authorization is missing.
  - FPS dumpsys work executes in FpsShizukuUserService through AIDL fixed operation IDs for capture on/off, focused activity and SurfaceFlinger stats. No arbitrary command text is accepted; the normal app process does not execute dumpsys or declare android.permission.DUMP in its manifest.
  - The previous Wireless ADB pairing/RemoteInput/Kadb/SPAKE2/identity-store and manual ADB grant/revoke UI were removed. Shizuku API/provider 13.1.5 is MIT-licensed, with the notice and license bundled.
  - The Shizuku contract/widget tests have NOT RUN on current source. Shizuku startup, explicit permission, UserService binding, Binder loss/revocation, actual foreground-game FPS and OEM compatibility remain UNVERIFIED.

  - Source-contract tests passed in Build #39/#40 (80 tests) but phone/OEM behavior unverified.

## 7. Approved visual asset design (preserve exactly)

- Grille: solid white, symmetric square with exact 1:1 outer contour, purple X centered, four mounting holes in corners. Preserve interior original grille pattern/frame. If the request is to remove side protrusions, remove only left/right mid-side protrusions. Flat 2D, print-ready; no shadows, bevels, depth, gradient, texture or background. “Enlarge only” means scale only; do not redesign.
- HZ monogram was tried and rejected/reverted; the centered purple X is approved.
- App/cooler PNGs need transparency and 1:1 ratio; preserve approved current icon/cooler unless user explicitly asks.
- App branding and notification icon are separate constraints: launcher uses jexfyzicon; notification small icon uses white JE vector only, no large icon.

## 8. User decisions / failures / historical warnings to retain

- Old source state blocks for V5.x, V6.1/V6.2/V6.3/V6.4 inside archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md and archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md are historical forensic snapshots only. The current source is V6.6; never move legacy CURRENT TRUTH into live status.
- NTC averaging attempts (V5.6 16-sample trimmed mean / multi-sample filters) were rejected and retired; use one calibrated reading per second.
- A prior apparent 12V selector output issue was finally traced by user to loose cable, so it is not a confirmed firmware defect.
- Two reset symptoms as above are separate. Without reset diagnostics, brownout is only a hypothesis.
- Rapid Hotside-rise/rate-of-rise shutdown/manual-rearm was once requested but is not in V6.6. The user treats V6.6 as final; do not implement without request.
- User-reported Adaptive-OFF white three-blink feedback missing after restart remains physical/boot behavior unverified; normal transition path isn't proof boot indication works.
- OTA CA/NTP experiment: CA validation and OTA-only NTP gate were removed together after a reported stage failure; subsequent restored connection is reported, but no single factor isolated. setInsecure() doesn't authenticate server identity. Keep failed-path explanation and trade-off; no HTTP/TLS code was captured.
- The previously added hosted-runner diagnostic workflow was tested on both ubuntu-24.04 and ubuntu-22.04 and failed before first step, then was deleted. Retain historical evidence but do not reference it as an active workflow.
- Current Build #40 defect is specifically resolved at source level: correct SPAKE2 path uses src/main/java/com/flyfish233/crypto/spake2/Spake2Context.java. Remaining blocker is runner start/allocation; exact cause isn't known.
- JAR/V1 signature inspection warned that some dependency META-INF entries were not protected by JAR signature; this warning is distinct from the explicit successful V1/V2/V3 checks. MT Manager on installed current-source APK has not been checked.
- User explicitly said this conversation must not run App Build. This recovery is docs-only and must not trigger workflows.

## 9. Permanent commands and authorization protocol

- @Thinking Diskusi!: detailed read-only discussion, no repo writes.
- @Thinking Diskusi! Tanya Gemini!: create one self-contained Gemini prompt, no patch.
- @Thinking Diskusi! Jawaban Gemini!: evaluate pasted Gemini answer; no patch. Either Gemini subcommand without same-message Diskusi! is invalid.
- @Thinking Eksekusi Full!: full approved code/docs scope, audit/tests/references/memory, direct commit to main; does not authorize App Build.
- @Thinking Eksekusi Build App!: end-to-end App build and release/QC loop; may fix App-scope defects and rerun based on actual logs; must publish and verify both APK and corresponding-source bundle plus signing and hashes, or stop at an evidence-based blocker.
- @Thinking Chat Stuck!: recover the current already-authorized job, inspect live state and evidence, stop blind retries, do not widen authorization or trigger a build.
- Retired aliases: standalone `@Thinking Build App!`, combined `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid.
- User compiles the firmware. No firmware compile, BIN creation/publishing, Firebase/production metadata mutation, physical OTA, flash/device operation or release outside the approved App Build workflow without separate explicit authorization.
- Documentation-only work does not trigger firmware version bump. Any approved functional firmware change requires bump FW_VERSION, matching active .ino filename and exactly one active versioned .ino.
- Work directly on main by default, no PR/branch unless requested.
- Preserve Android versionName "Telegram @horizontalzzz" exactly.
- After every material write, re-fetch HEAD/tree/blob hashes. Do not claim success without confirmed GitHub result.

## 10. Canonical document map and parent-checkpoint blob fingerprints

The canonical map is MEMORY_INDEX.md. At this reconciliation, prepared blobs for the documentation commit are listed below; their final live SHA must be re-fetched after commit. These values were obtained from GitHub create_blob responses, not inferred filenames.

### Docs refreshed by the exact-threshold thermal indicator update
- APP_BUILD_REPORT.md: 65cfe338309f9e2718f17b1bb6583982e02d48ae
- BUILD_NOTES.md: ac645d08312285377c75ba5bcdb8a6b18ea61f88
- CHANGELOG.md: 7fc27ec58ec79127c18bb290c64da74784437db8
- HANDOVER.md: 4c25dec9444e4c1ca7516bd50a6354c085929181
- MEMORY_INDEX.md: 037ab324af33eaeb25b5ffd796eed821db26b42a
- PROJECT_STATE.md: cbe5fb41e8d131314b73bd7cacd687a76c3be0cb
- CHAT_TRANSFER.md: final write; its future blob SHA is not embedded in itself.
- Workflow unchanged: `.github/workflows/jexfyz-app-build-trigger.yml`, blob `5c5af03075f87297a31f5ee26f0e42025f05977b`.
- Current source commit `8b58c7033a5462864b52cb921ca25c714bca902f`, tree `fe266a9384e2c953a01c618ebc4c5c7028a6bbf3`; tests still NOT RUN.


### Canonical documents unchanged in this reconciliation (parent hashes)
- APP_NOTES.md: 48edcb1106a9d3968efd3fe201cef325661189bb
- FIRMWARE_NOTES.md: 3bf9e240a317cb5a2d07975ff7fabb0798205e24
- DESIGN_NOTES.md: e04382659dfdd618de0a156046f140452d275dc7
- OTA_PROTECTION.md: 06beb86b749b0f0e14c8cb517e43fe7c0f66a4e1
- OTA_REGRESSION_MEMORY.md: 4342f3da76cf2962140146fbbe0ff8de5e956f4d
- VOLTAGE_TRANSITION_MEMORY.md: 1c2167659fd0ed8f5db16bf63eb7897344a690ea
- firmware/FIRMWARE_TECHNICAL_REFERENCE.md: 58937006c1a34f0a8439d3ac4c7dc13b771987b2

### Current source/test hashes at the recovery checkpoint
- Firmware: `firmware/JEXFYZ-V6.6.ino` blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222` (leave untouched; V6.6 is user-accepted final).
- `lib/main.dart`: `3eeb4dff7b7fbb52a44022e5e2b130bc1826da23`.
- `lib/floating_monitor.dart`: `232fde06efda5bfaa2221825a04c0106ad5feb33`.
- `lib/app_settings.dart`: `6f99911bc59451473823aea1e1` (short fingerprint; fetch live file for full SHA).
- `test/widget_test.dart`: `520399fcdc6be4fd69cb48f50aa8961f5d9183c5`; `test/shizuku_fps_contract_test.dart`: `bd27d2c7adc20ab76bab504378a2353d01ab473b`.
- `MainActivity.kt`: `a139dfefe1121963c3a26b114b9b0fcc9f8fa16a`; `FloatingMonitorService.kt`: `bfc0956688bab5951ea2c626427a691ed63b6921`; `FpsShizukuUserService.kt`: `1f5ed36dadaba9dc70ecfbe0793114b34c8ab08b`; AIDL: `ddb0c442029d8f291e99eb6682bd2a690e6c9709`.
- `AndroidManifest.xml`: `393c9f9bfe02b9d71b2e3445ce873d5d16912ce1`; app Gradle `cc35d2d3dbe603e7b5a7157d37dde222d646ea42`; workflow `585d190324e522fc08e66cc95bd7ee80c5f37664`.
- `PROJECT_STATE.md`, `HANDOVER.md`, `APP_BUILD_REPORT.md`, `BUILD_NOTES.md`, `MEMORY_INDEX.md`, `APP_NOTES.md` and `CHANGELOG.md` now record the Shizuku design and validation boundary. `CHAT_TRANSFER.md` is refreshed in this commit.

## 11. Final operation state

This snapshot records that Build #49 from older source `2b2d2886abb66481b7134e5036824f625ab5659d` remains the last verified Release. Current source checkpoint `b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b` adds Shizuku-gated FPS authorization/execution. Current-source tests, analysis, Android build and Release were not run during Chat Stuck recovery. The issue-only workflow is unchanged in trigger semantics, with Shizuku/MIT audit and source packaging updates; no trigger issue was opened/reopened. Physical-device behavior remains unverified. No Firmware/BIN/Firebase/OTA/flash/device operation was performed.
