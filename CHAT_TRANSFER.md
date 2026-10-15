# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

## 0. Snapshot scope and evidence boundary

Snapshot reconciled from live GitHub on 2026-10-15 (Asia/Jakarta). This file is the full boot snapshot for the canonical project and is refreshed last in the memory update. The verified repository checkpoint immediately before the authorized Build #48 attempt was:

- App repo: TenzoNkz/JEXFYZ-App
- Branch: main
- Parent HEAD: 608a394f1b764ad8759ce240eafc90b6b9dd2c59
- Parent root tree: 5ed77afe1823e47455569931fc888814601cc36d — 76 tree entries / 55 blobs; recursive response not truncated
- Branches: 5; open PRs: 0
- Active App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml, current workflow blob 5c5af03075f87297a31f5ee26f0e42025f05977b
- App version/package: 1.0.0+3 / com.horizontalzzz.jexfyz
- Active firmware source in the App repo: firmware/JEXFYZ-V6.6.ino; embedded FW_VERSION = "V6.6"
- Artifact repo: TenzoNkz/JEXFYZ-Firmware, main HEAD cc0a0ae32b826753525c3f2a4442526648cef631, root contains only JEXFYZ.cpp.bin
- This snapshot captures authorized Build #48 / run 38735820460, triggered by issue #21 on source commit 608a394f1b764ad8759ce240eafc90b6b9dd2c59. Job 116424719108 failed before steps; steps=[] and log retrieval returned BlobNotFound. No build/test/signing/release stage ran. Re-fetch live HEAD and blob hashes on the next chat; this file intentionally does not store its own future blob SHA.

Evidence terms:
- CURRENT / VERIFIED means directly checked against live source/repo/CI evidence.
- SOURCE IMPLEMENTED / NOT RUN means implementation exists but its required execution has no evidence.
- USER-REPORTED means the user reported it; do not present it as an assistant-witnessed result.
- UNVERIFIED means the required evidence is missing.
- HYPOTHESIS means possible, not demonstrated.
- HISTORICAL / SUPERSEDED means it applies only to an older revision or path.
- NOT RELEASED means no verified released artifact contains the current source.
- A test contract is not proof a test ran; App CI is not Arduino firmware compilation; successful APK compilation is not release publication; visual LED feedback does not identify a specific HTTP/TLS error.

## 1. Current release/build state — read first for App Build work

### App Build evidence, in order

- Build #48 — run `38735820460`, https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38735820460, source/workflow commit `608a394f1b764ad8759ce240eafc90b6b9dd2c59`, trigger issue [#21](https://github.com/TenzoNkz/JEXFYZ-App/issues/21). Job `116424719108` failed about four seconds after creation, the live steps endpoint returned `[]`, and log fetch returned `BlobNotFound`; no workflow build/test step ran. The issue was closed after the run. This is consistent with the earlier pre-runner failure pattern but its runner_id was not exposed.
- Build #40 — APK compiled/signed; publication blocked: run 38713854518, source commit d638f6941d9ac16a228f4b78ed001ca2e925f716. Security/architecture/license audit, Flutter dependency install, Dart analysis, all 80 Flutter tests, obfuscated APK assembly, V1/V2/V3 signing, and official production-certificate verification passed. The workflow made JEXFYZ-corresponding-source.zip and unzip -t passed. It then stopped because a grep asserted the wrong SPAKE2 Java source path. Expected old path was android/src/main/java/io/github/muntashirakon/crypto/spake2/Spake2Context.java; actual tag-1.0.5 file is src/main/java/com/flyfish233/crypto/spake2/Spake2Context.java. Release upload and post-download checksum/signature gates were skipped.
- Path assertion correction remains present in the renamed workflow blob 5c5af03075f87297a31f5ee26f0e42025f05977b for the correct SPAKE2 source path. The repair is source-level verified by reading the workflow, but a full post-fix run has not yet reached that step.
- Builds #41–#45 — no runner/zero steps: these failed before the workflow executed a step, so no Dart tests/APK/signing/source archive/release ran in those attempts:
  - #41: run 38715261426, job 116356817322 (attempt 2)
  - #42: run 38715656340, job 116357869559 (attempt 2)
  - #43: run 38715911768, job 116358423340
  - #44: run 38718952314, jobs 116368449764 and 116368665443 (attempts 1/2)
  - #45: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38719397780, job 116369943522
  All observed failures finished in about 2–4 seconds with runner_id=0, blank/empty runner metadata and steps=[]. No usable logs were created. This is consistent with hosted-runner dispatch/provisioning or account/repository restrictions, but the actual cause is unknown. GitHub Status was reported operational during a controlled attempt; that does not prove this repository/account configuration is healthy.
- Separate diagnostic probes (HISTORICAL; workflow deleted): diagnostic run #1 38722954080 used ubuntu-24.04; diagnostic run #2 38723038511 used ubuntu-22.04. Both failed before step 1 with runner_id=0 and no useful logs. The file .github/workflows/hosted-runner-diagnostic.yml was subsequently deleted from current main by commit 41627c26189706bc9f4aabad15a83857cda55229; do not tell the next chat to run that workflow because it is not present. The result does not identify a root cause.
- Release trigger runs #46 (38722953908) and #47 (38723038530) were skipped by the release workflow's owner/title/token guard; they were not App builds.
- Build #39: run 38705765370, https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38705765370, passed audit/dependency resolution/Dart analysis/all 80 Flutter tests, then failed at :app:mergeReleaseNativeLibs because com.github.Flyfish233:spake2-java:1.0.5 could not be resolved. android/build.gradle now adds JitPack narrowly scoped to com.github.Flyfish233:spake2-java (blob bb8c0caf26927bd614bb9b05ef79366424063663), and Build #40 later proved that dependency resolution and APK compilation/signing worked.
- Build #36 — last successful release: run 38689044316, https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38689044316, built source commit 893393388b99fc6d9e59c420070a159a29e45e9a. It passed security/architecture audit, dependencies, Dart analysis, 77 Flutter tests, obfuscated APK build, V1/V2/V3 signing, official certificate checks, release publication, re-download checksum comparison and downloaded signature verification. It validates only that older source revision, not later Wireless ADB or Home UI commits.

### Current published artifact

- Release tag: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest
- Target commit: 893393388b99fc6d9e59c420070a159a29e45e9a (Build #36)
- Exactly one asset: JEXFYZ-release.apk, asset ID 642851650, 54,620,251 bytes
- SHA-256: a5c9d97a3d28f7f711b0cd3c524289bc136cecec56d3b1d88821e43c713e9a13
- Production certificate SHA-256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0
- Current source is NOT RELEASED. Existing APK predates the Wireless ADB pairing and latest Home UI source. No current matching source ZIP has been published.

### Exact next action for the separate Build App workstream

Do not trigger from this general recovery chat and do not repeatedly reopen the issue without new information. In the dedicated Build App chat, inspect GitHub account Actions usage/minutes/budget/spending cap, repository Settings → Actions permissions/allowed actions, account security/verification restrictions, and check-run annotations where accessible. If those are normal, escalate the specific job/run IDs above to GitHub Support to investigate hosted-runner dispatch. Build #48 is the latest trigger attempt and it failed before steps. Do not re-trigger without new evidence. First inspect Actions usage/spending, repository Actions permissions/allowed actions, and account security/verification; if normal, contact GitHub Support with run/job IDs for #41–#45 and #48. Once runner dispatch is demonstrably restored, use @Thinking Eksekusi Build App!, trigger with a new issue using the current exact title/token, repair any actual source/archive failure shown by logs, and require every release gate to pass before calling the build successful. Do not use the deleted diagnostic workflow.

## 2. Repository boundaries and current inventory

- TenzoNkz/JEXFYZ-App is the canonical editable App + Firmware source repository and the only repository for all project docs, history, handover and prompts.
- TenzoNkz/JEXFYZ-Firmware is an artifact repository and must contain only JEXFYZ.cpp.bin. Live verified artifact root has exactly one file: blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6, 1,455,936 bytes. Do not add notes or touch the BIN during docs work.
- Canonical active workflow is .github/workflows/jexfyz-app-build-trigger.yml (blob 5c5af03075f87297a31f5ee26f0e42025f05977b). Its trigger is issue opened/reopened, owner must equal repo owner, exact title JE X FYZ — EKSEKUSI BUILD APP TRIGGER, body token JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1. Normal push/PR is not intended to start this release workflow.
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
  - FloatingMonitorService.kt 038f12b2ca82255a3b202b10dd770d5caa5b2bbf
  - JeForegroundService.kt 9ea4dce7001bcd5cc10f9c1c7ad62f34ec54b03e
  - JexNotificationUtils.kt aecfc87121f2195ef6724613c612d674ed95ae55
  - MainActivity.kt f7340e82a12cece063e310546dcba893e6a5a09f
  - WirelessAdbIdentityStore.kt 394eab93a17c563caf7db0511d4d36040c1c59ec
  - WirelessAdbPairingService.kt 7f2099cac0c78008d395ec0bb83e32e5f6d55384
- Assets: assets/jexfyzcooler.png blob fbc47e3197534ae35330c1f1793c99705e5165d1, size 1,830,171; assets/jexfyzicon.png and Android nodpi icon bad855f23416fd58aff194c30b7f8fd77f260ea8, 436,439; notification vector cda9e8404d14a62a61157ec59fae2e491c19f5f7.
- License/notice files: third_party/Kadb-1.3.0-LICENSE.txt 261eeb9e9f8b2b4b0d119366dda99c6fd7d35c64; third_party/THIRD_PARTY_NOTICES.md ec505ebc22dac34924bf3318158061ae693cb9d5; GPL-3.0 SPAKE2 license at both App third_party and Android assets is blob e72bfddabc15be5718a7cc061ac10e47741d8219.
- pubspec.yaml dependencies include Flutter, flutter_blue_plus, firebase_core, firebase_app_check, flutter_secure_storage, permission_handler, phosphor_icons; dev deps flutter_test and flutter_lints.

### Test inventory / executed evidence

All five live tests were read completely:
- test/adb_pairing_contract_test.dart: 03609184edc5b2df09f40e62ffe99959ea337bad
- test/app_protocol_notify_contract_test.dart: 92214dd90178c705844d3979d3f8f7bd17bcc4b8
- test/firmware_touch_adaptive_sync_test.dart: 2d3fea509343a03b8d23623f4dcb2dd7fd972d39
- test/v6_6_qc_contract_test.dart: 2bee4d960d014f0765422dcb5ed1c9870ba6ee3a
- test/widget_test.dart: 98c0c11d1c39b48cb5fc6657c3a0ca7d677b2d1b

Executed:
- Build #39 run 38705765370: Dart analysis passed and 80 tests passed, APK fail on missing SPAKE2 Maven artifact.
- Build #40 run 38713854518: Dart analysis + 80 tests passed, APK compile/signing/certificate passed, source ZIP valid, failed only obsolete path grep. #41–#45 did not reach any step.
- Presence of a test file is never test execution proof. App CI is not firmware build or phone validation.

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
  - FPS does not count Flutter FrameTiming and does not substitute phone display refresh rate. Uses native dumpsys SurfaceFlinger --timestats, frames every approx 1s, filtered by Android resumed/focused package and matching layer names. Poll only if enabled, overlay attached, metric F selected and android.permission.DUMP granted. Unknown package/layer/no frames/blocked dump -> -- or explicit ADB, never fake FPS. This measures compositor-presented frames; not necessarily game simulation/update rate.
  - FPS DUMP permission is a powerful signature|privileged|development permission. Access is user-controlled. Native Android 11+ Wireless ADB flow: foreground notification, NSD/mDNS _adb-tls-pairing._tcp., fresh six-digit code via RemoteInput, loopback Kadb 1.3.0 pairing, discover _adb-tls-connect._tcp., only fixed pm grant com.horizontalzzz.jexfyz android.permission.DUMP, independently query permission state. No arbitrary shell/remote host/port. Do not turn USB/Wireless debugging on itself. Pairing code not stored. ADB identity AES-GCM encrypted with Android Keystore inside noBackupFilesDir; stays paired until forgotten/revoked. Manual trusted-computer ADB grant/revoke fallback remains.
  - Kadb 1.3.0 is Apache-2.0, transitive SPAKE2-Java 1.0.5 is GPL-3.0. Workflow aims to include GPL license in APK and release one matching-source ZIP including exact App commit plus upstream Kadb 1.3.0/SPAKE2-Java 1.0.5 sources/licenses, alongside one APK in same private Release. The packaging route is technical safeguards, not legal advice. Build #40 reached APK/Signing but failed path assertion before publishing; no published source ZIP/current APK.
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

### Docs refreshed by the latest Build #48 record
- APP_BUILD_REPORT.md: 041aa67f836d81843511ce2f8be5f2cfd2175fc8
- BUILD_NOTES.md: ece12faf0659f9c865da7b77fa9339ea074a36c0
- CHANGELOG.md: 79a0140502c2edd0bd198413a8a53568baff2f31
- HANDOVER.md: f56fe6a1d92a5dae4a8a6d0af28e05400b96464a
- MEMORY_INDEX.md: 9e569e103b2bb3f09a496750e8423879fcb4170e
- PROJECT_STATE.md: d3bce30d06223c1112c5874493c3ae4b7f6e671c
- README.md: 1c7c8fb01f2c41b750fffa86df0d92dece588f19
- CHAT_RULES.md: 1547399a12444d2ec2be65385ddc901a6eb65c7f
- CHAT_TRANSFER_PROMPTS.md: ccb473293fefd6d166f79b634724235ea6615f1a
- .github/workflows/jexfyz-app-build-trigger.yml: 5c5af03075f87297a31f5ee26f0e42025f05977b
- CHAT_TRANSFER.md: this is the final write; its future hash is intentionally not embedded in itself.

### Canonical documents unchanged in this reconciliation (parent hashes)
- APP_NOTES.md: 48edcb1106a9d3968efd3fe201cef325661189bb
- FIRMWARE_NOTES.md: 3bf9e240a317cb5a2d07975ff7fabb0798205e24
- DESIGN_NOTES.md: e04382659dfdd618de0a156046f140452d275dc7
- OTA_PROTECTION.md: 06beb86b749b0f0e14c8cb517e43fe7c0f66a4e1
- OTA_REGRESSION_MEMORY.md: 4342f3da76cf2962140146fbbe0ff8de5e956f4d
- VOLTAGE_TRANSITION_MEMORY.md: 1c2167659fd0ed8f5db16bf63eb7897344a690ea
- firmware/FIRMWARE_TECHNICAL_REFERENCE.md: 58937006c1a34f0a8439d3ac4c7dc13b771987b2

### Current source/test hashes (unchanged in this documentation work)
- firmware/JEXFYZ-V6.6.ino: f51ba6db5d0e91318f63fea4014bb87f7bf76222
- lib/main.dart: 74b6bcc47d69ccf114f710ed73dfcefe93037111
- lib/floating_monitor.dart: bd230aee16fa77a0d8d2afb9f1a0c2d80cdcac86
- lib/app_settings.dart: c513cd4381ee960cd43612c4ac01e7954f651f62
- test/adb_pairing_contract_test.dart: 03609184edc5b2df09f40e62ffe99959ea337bad
- test/app_protocol_notify_contract_test.dart: 92214dd90178c705844d3979d3f8f7bd17bcc4b8
- test/firmware_touch_adaptive_sync_test.dart: 2d3fea509343a03b8d23623f4dcb2dd7fd972d39
- test/v6_6_qc_contract_test.dart: 2bee4d960d014f0765422dcb5ed1c9870ba6ee3a
- test/widget_test.dart: 98c0c11d1c39b48cb5fc6657c3a0ca7d677b2d1b
- pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66
- android/app/build.gradle: 05a0b863cfc6d73dc3789e364d7000eee0f3db0e; android/app/src/main/AndroidManifest.xml: 2124dcd969347d2c7bb1bd99374a398cf50d2387; android/build.gradle: bb8c0caf26927bd614bb9b05ef79366424063663
- android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: 038f12b2ca82255a3b202b10dd770d5caa5b2bbf; MainActivity.kt: f7340e82a12cece063e310546dcba893e6a5a09f; WirelessAdbPairingService.kt: 7f2099cac0c78008d395ec0bb83e32e5f6d55384; WirelessAdbIdentityStore.kt: 394eab93a17c563caf7db0511d4d36040c1c59ec
- GPL and third-party notice files are listed in §3 above.

## 11. Final operation state

This snapshot records current source/test truth at parent `608a394f1b764ad8759ce240eafc90b6b9dd2c59` and the authorized Build #48 attempt. The issue-only workflow is named JE X FYZ Eksekusi Build App and uses title JE X FYZ — EKSEKUSI BUILD APP TRIGGER plus token JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1. Issue #21 triggered run 38735820460 and was closed after it failed before the first step; its job step list was empty and log fetch returned BlobNotFound. Build #40 is still the last run that executed tests/build steps; its SPAKE2 source path assertion has been corrected but never passed in a full post-fix run. Current release remains old Build #36 and current main is NOT RELEASED. Diagnose Actions usage/policy/security and escalate runner dispatch to GitHub Support before another trigger. No App/Firmware source, BIN, Firebase, OTA, flash, device or release asset was changed.
