# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot date: 2026-10-17 (Asia/Jakarta). Prepared against live TenzoNkz/JEXFYZ-App main after the scoped dashboard-indicator motion/manual-voltage-toggle commits and canonical-memory updates. This transfer file is being committed last as a transfer-only follow-up; it deliberately does not include its own future blob/commit hash. Always fetch live main again at the next boot.

Source-of-truth order: live main source/tree and exact Actions/Release evidence → CHAT_RULES.md for authorization → PROJECT_STATE.md for current state → subject reference files and APP_BUILD_REPORT.md → HANDOVER.md / this snapshot → CHANGELOG.md for history → archive/*.md for forensic recovery only. Archived “CURRENT” wording is not live truth.

## 1. Current Git and repository state

- Canonical editable App, Firmware source and all project notes/memory: TenzoNkz/JEXFYZ-App, branch `main`. HEAD immediately before this transfer-only write: `023f8fbb92ae11f23a1ca33364d7af6ecd10caaa`, message “docs(memory): update indicator motion source checkpoint”, tree SHA `9cb3e954ad26f2f316c751c1d2518675c43a659e`. Re-fetch the branch and tree at the next boot.
- Recent relevant commits: FPS retirement source commit `8217a2e8d19dc82e9fe3bfa7e4e1c1692d0b7941`; Build #70 source commit `eb1224232241ca5d44d43e25919fd228875029ab`; post-release indicator-motion source commit `2ce326240d38918d9f685145504b1d51c0ea11ec`; regression tests commit `db6ae59a8bf00a6d8116823465079c90ddb9f02a`. The new motion/toggle source is NOT RELEASED and needs a separate App Build/QC run.
- Five branches observed: main; diag/latest-stable-v16; diagnostic/v1.6-heap-check; fix/adaptive-power-sequencing; tmp-jexfyz-v5-test. Open pull requests: zero. Refresh this data next boot.
- Artifact repo TenzoNkz/JEXFYZ-Firmware was re-fetched and its root tree contains exactly one blob: JEXFYZ.cpp.bin, 1,455,936 bytes, SHA/blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. No BIN payload was read or edited. Its provenance from the source sketch remains UNVERIFIED.
- No files are intentionally removed in this memory transaction. Frozen archive files are preserved byte-for-byte. Their root-relative links may not resolve from inside archive/; one example is a link from archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md to VOLTAGE_TRANSITION_MEMORY.md, which resolves incorrectly under archive/. Do not rewrite the forensic archive to “fix” this; canonical root files are the current references.

## 2. Latest verified App release versus current source

- Latest release is Build #70 / GitHub Actions run 38998407325: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38998407325. The exact source/release commit is eb1224232241ca5d44d43e25919fd228875029ab. Run completed successfully at 2026-10-17T03:26:42Z (10:26:42 Asia/Jakarta). The release tag jexfyz-latest targets that exact commit.
- All 21 active workflow steps passed: guard/audit, dependency resolution, Dart analysis, Flutter tests, Android production compile/configured test gate, obfuscated APK, V1/V2/V3 signing and production certificate checks, matching source archive, Release publication, re-download and artifact/signature verification.
- Dart analysis completed with 23 info-level deprecation findings. 86/86 Flutter tests passed. The configured Gradle task :app:testDebugUnitTest succeeded, but the retired FPS native JUnit files no longer exist, so native Kotlin/Java test-compilation and test tasks were NO-SOURCE: no native JUnit cases ran in Build #70. Do not count the old parser/watchdog cases from #69 as #70 test executions.
- Released APK: JEXFYZ-release.apk, asset 649412242, size 54,538,331 bytes, SHA-256 229aaae5745456498d35f356ee6e0cdde81e7bb29f37238b1172f99f992ab404. Download: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk
- Matching corresponding-source archive: JEXFYZ-corresponding-source.zip, asset 649412243, size 2,847,010 bytes, SHA-256 d0a79cdaf99b169b68cda04c5c3162062f493f0cb6f6ec02c1531950e4bbd8ae. Download: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip
- Signing: V1/JAR, V2 and V3 verified true, one signer. Production certificate SHA-256 dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0. Non-blocking warnings and exact workflow output are recorded in APP_BUILD_REPORT.md.
- Build #70 is the first verified release after FPS/Shizuku retirement. Build #69 and earlier are historical FPS-enabled builds. Build #70 is App CI/build/release evidence, not proof of physical BLE, Fan Speed, cooling, Firmware, thermal safety or OTA behavior.
- No App Build workflow was triggered for the indicator-motion/manual-toggle change. `Eksekusi Full!` authorizes scoped source/tests/docs/memory work, not release. Build #70 remains the last verified release and does not contain these edits.

## 3. App identity, active workflow and source fingerprints

- User-facing name JE Cooler; brand/header JE X FYZ; Android application ID/package com.horizontalzzz.jexfyz; pubspec version 1.0.0+3; minSdk 24; preserve Gradle versionName exactly “Telegram @horizontalzzz”.
- Toolchain from the live workflow: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Only active build workflow: .github/workflows/jexfyz-app-build-trigger.yml, blob 8a8533aff7e0e0e01412bf522e1966e81aa1a39f. It triggers only on issues opened/reopened and requires repository owner, exact title “JE X FYZ — EKSEKUSI BUILD APP TRIGGER” and body token JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1. Never add push/PR build triggers.
- Main app source fingerprints at the checkpoint above:
  - lib/main.dart — `c10a708022ca8e8defbe1583b47fb0b10ddda8ed`. Post-Build-70 source adds fade-before-pause activity transitions, retained-phase resume at equivalent cycle boundaries, loop-seam-safe thermal flames, a subtle Battery segment ripple, four orbiting Peltier sparks, and neutral theme-primary manual-voltage toggles. NOT RELEASED; tests/build have not run.
  - lib/floating_monitor.dart — 31b45ea08b08ac7fc25ebd991dca873b889fdd14.
  - lib/app_settings.dart — 20f1ce0f838345c9eee4cbacde22255cb7852435.
  - android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt — 7368df11ecb369f8b71607c82e6a1b44472cc79b.
  - android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt — bd17c34211e8eb5c4723e06937ae47f0071b5e8b.
  - android/app/src/main/AndroidManifest.xml — c374b5d3ad6448b8b3e99a420ed7e8c49d38497a.
  - android/app/build.gradle — 060cdd36a4f7d4d2fa4c97a1b6a15954b8355350.
  - pubspec.yaml — 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock — 1e92812bfda2c28244a0556d71d1ec94084acc66.
  - .github/workflows/jexfyz-app-build-trigger.yml — 8a8533aff7e0e0e01412bf522e1966e81aa1a39f.
- Five active Dart tests and current blob SHAs:
  - test/widget_test.dart — `ce03201590667befb8e3d05b0a9788665fdd54a8`. New source-contract tests cover animation phase continuity/flame loop seam, Peltier spark orbit/fade and manual-voltage toggle styling; they have NOT RUN.
  - test/floating_monitor_layout_contract_test.dart — 87e805095202ac3edfe55b9aeb3138c7c6886375.
  - test/v6_6_qc_contract_test.dart — 083e0d19389c235b84f9785ee665d8ed8789e37f.
  - test/app_protocol_notify_contract_test.dart — 92214dd90178c705844d3979d3f8f7bd17bcc4b8.
  - test/firmware_touch_adaptive_sync_test.dart — 2d3fea509343a03b8d23623f4dcb2dd7fd972d39.
- The v6_6_qc_contract_test is Dart source-contract coverage; it is not an Arduino compile. The five Dart files were executed in Build #70 and 86/86 tests passed.

## 4. Current Floating Monitor: FPS retired, F means Fan Speed

- User chose to remove FPS entirely after repeated F:-- and Shizuku UserService failures, rather than continue speculative device-specific FPS fixes. This decision is implemented and released in Build #70.
- Active Floating Monitor supports exactly six metric IDs: B (Battery Temperature), H (Hotside Temperature), V (Voltage), A (Adaptive), P (Peltier), F (Fan Speed). The F label is not FPS. Speed telemetry and Firmware Fan behavior were not changed.
- Persisted configuration schema version 2 handles legacy schema v1: old F meant FPS and is discarded; old S meant Speed/Fan Speed and migrates to new F. This avoids displaying an old FPS selection as a fabricated fan-speed reading. Current default ordering and permitted metric selection use B/H/V/A/P/F.
- Removed active FPS SurfaceFlinger/TimeStats sampler and watchdog/parser, Shizuku permission/status UI and channel methods, Shizuku provider/dependency and manifest query, UserService/AIDL, FPS-only Kotlin tests, Shizuku-only Dart contract test, and Shizuku-only notice/license files. The workflow's audit explicitly guards against those paths/dependencies returning and verifies native metric F maps to Fan Speed.
- The unsafe approaches proposed in discussion were rejected: replacing the parser with source-incompatible Gemini pseudocode, inventing nonexistent methods/APIs, choosing an arbitrary BLAST/SurfaceView layer with no foreground package attribution, or claiming Scene internals were known. The runtime root cause was never established; FPS was retired at the user's direction, not because a particular parser hypothesis was proven.
- Native overlay still owns only the floating window/lifecycle/config/telemetry rendering; Flutter remains the one BLE/GATT client. The native Floating Monitor MethodChannel remains. FPS access/status methods were removed.
- Visual/layout contract: Letters only (legacy Icons normalize to Letters); freely draggable with persisted coordinates; horizontal metrics centered together, vertical rows share the left edge; size 0.30×–1.00× in 0.05× increments (default 0.60×); opacity 0–100% in 5% steps, shows current percent and endpoints without 50% midpoint; opacity affects background only; Black/White backgrounds with contrasting text. Fan on displays live speed, Fan off localized OFF/MATI, disconnected output is --.
- Build #70 verifies the source and app build, but real-phone overlay layout/rendering, telemetry correctness and Fan Speed display remain UNVERIFIED. Next product check is to install/update with the Build #70 APK and check B/H/V/A/P/F and real Fan Speed telemetry. No new build is needed merely to validate FPS retirement.

## 5. BLE, protocol and App safety/telemetry contracts

- Flutter uses flutter_blue_plus as the sole BLE/GATT client. Native foreground service supports an already-active connected session; it must not become a second BLE client.
- BLE Service UUID: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001. RX: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001. TX: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001. The App requires protocol P1 session readiness for synced interaction.
- Hardware telemetry is authoritative. Command ACK does not prove physical output/rail state. Wait for matching VOLTAGE telemetry before claiming a rail transition completed. Touch Adaptive-OFF should publish Adaptive/ceiling/Fan/Peltier/Fan Speed telemetry before its ACK.
- Secure BLE command writes use encryption/bonding. An exclusive one-App/one-cooler pairing/key-lock is a user design requirement; existing encrypted/bonded writes do not alone prove end-to-end exclusivity. Keep this status UNVERIFIED until provisioning/source flow and physical pairing behavior are proven.
- Auto Connect is passive: it must not enable Bluetooth or request prerequisites by itself. Requires a known saved cooler identity, Bluetooth and applicable Android permission/location prerequisites, and no scan collision while syncing. Cancel rediscovery/retry if prerequisites become unavailable. Current default Auto Connect is Manual/off.
- When BLE telemetry is disconnected, Home/dashboard and Floating Monitor output values remain unknown (--) rather than preserving stale hardware state. Some CONTROL/ADAPTIVE/LED switches use a disabled OFF-looking fallback as a UI design; this is not confirmation of hardware OFF. Commands must be disabled until readiness/sync.
- Android phone Battery temperature is sent as PHONE:BT=<Celsius> at 1 Hz while P1-ready; pending heartbeat writes coalesce. Firmware input freshness TTL is 5 s. If phone Battery input expires, HOTSIDE_BATTERY runtime control falls back to HOTSIDE behavior without silently rewriting the chosen runtime-only profile.
- Do not display a standalone Battery Protection Guard badge/status. This is an App presentation restriction, not permission to weaken Firmware thermal protection or suppress independently actionable localized Notify messages.
- Safety/Notify reasons are localized in normal UI. Do not show raw protocol tokens/underscore-form internal stage names. Clear old safety Notify only when healthy live safety telemetry is received, not from an unrelated success ACK.
- Notification icon: bold white JE monogram on transparent background as Android small icon; no full-color large icon. Notification title is JE X FYZ, localized event/status is the body, tap opens the app, and the connected-device/Floating service notification body must be meaningful/non-empty.

## 6. Current App UI/design contract

- Main design direction is based on Horizon Cooler App: dark header, white rounded content panel, compact cards, VOLTAGE and ADAPTIVE principal tabs, cooler visual on the right. Intended sub-menu hierarchy: VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Keep changes scoped; do not rework the approved visual identity without explicit request.
- Home indicators: disconnected value unknown but keep its lowest semantic accent instead of black/generic grey; color alone does not assert output state. Battery: Ice Blue at ≤30°C, smooth cyan/amber/orange transition from 30–40°C, Burning Red at ≥40°C with exact warning threshold at 40°C. Hotside: Ice Blue ≤30°C, smooth above, Burning Red at the configured Hotside Limit. Manual-voltage accents: 5 V red, 9 V green, 12 V blue; unknown voltage falls back to 5 V red. Visual palettes do not implement/replace Firmware safety.
- Fan icon has voltage-dependent rotation: 5 V slow (~2600 ms), 9 V medium (~1250 ms), 12 V fast (~620 ms), with phase-continuous handoff and smooth OFF coast-down. Peltier uses a bounded six-branch free-standing frost crystal; its visual intensity follows reported voltage. These are illustrative animations, not RPM or actual ice/cooling measurements. Exact physical-device animation/shape remains UNVERIFIED.
- LED color picker uses 36 curated hue-ordered color presets with localized names, no HEX labels in UI. Tapping a swatch updates a local draft only; explicit Select sends the confirmed COLOR command and only closes after success. Cancel discards without BLE write. Outside taps/system Back cannot dismiss the panel. Brightness remains the single physical intensity control; preview stays vivid at low hardware brightness and must not imply hardware changed before confirmation.
- Supported decorative LED firmware IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. ID 3/Mirror Pulse is retired; stored ID 3/invalid values migrate to Static, and new MODE:3 commands are rejected. Firmware emits atomic LED_SYNC:<mode>,<phase_ms>,<cycle_ms> at BLE-notify time; App interpolates monotonically and corrects drift without restarting animation each snapshot. Older separate phase/cycle deltas remain compatibility fallback.
- Approved printable JE X FYZ grille: exact square 1:1 symmetric outer shape, white geometric grille, central purple X (not HZ), four corner mounting holes, preserve interior pattern/frame. Remove only the two small left/right midpoint protrusions when requested. Flat manufacturable 2D: no shadow, bevel, faux depth, gradient, texture or invented elements. “Enlarge only” means scale the approved geometry only. Transparent 1:1 PNG assets are assets/jexfyzicon.png and assets/jexfyzcooler.png; Android icon is android/app/src/main/res/drawable-nodpi/jexfyzicon.png.
- Do only narrow approved visual edits. Historical attempt to use an HZ monogram was rejected; purple X remains approved.

## 7. Firmware V6.6 and hardware baseline (not changed here)

- Canonical editable source: firmware/JEXFYZ-V6.6.ino, blob f51ba6db5d0e91318f63fea4014bb87f7bf76222; embedded FW_VERSION = "V6.6"; exactly one active versioned .ino. Target ESP32-C3 Super Mini/Dev Module, Arduino-ESP32 Core 3.3.7, user compiles using ArduinoDroid.
- User accepts Firmware V6.6 as final/correct and reports successful compilation plus two successful same-version Online OTA updates. This is USER-REPORTED, not assistant-witnessed logs. Installed version and source-to-BIN provenance remain UNVERIFIED. Do not reopen/compile/reflash firmware or promote BIN/Firebase unless user reopens that task and separately authorizes it.
- ESP32-C3 has one radio path: Wi-Fi OTA and BLE may not own the radio concurrently; explicitly transfer ownership.
- Pin map: GPIO0 Hotside NTC ADC; GPIO1 TTP223 touch input; GPIO3 12 V selector; GPIO4 9 V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812.
- MOSFET wiring memory: GPIO → R100 → gate; 100 kΩ gate-source pull-down. Fan positive goes to supply (“Decoy” as written in user note); fan negative goes to MOSFET Drain. A prior 12 V selector problem was later traced to a loose cable, not established code defect; verify physical wiring before changing code.
- NTC: 10 kΩ nominal thermistor, 10 kΩ fixed divider, Beta 3950, 3.3 V reference assumption, calibrated analogReadMilliVolts(PIN_NTC). One sample per second, no median/trimmed mean/multi-sample averaging without explicit renewed approval. NTC invalid state fails safe (Peltier OFF, Fan 100%, Adaptive OFF and safe 5 V per current contract).
- Hotside limit range 40–50°C, default 45°C. Manual Peltier safety latch re-arms only after Hotside ≤ hotLimit−1°C continuously for five seconds; a single low sample must not bypass the latch.
- Peltier PWM is 20 kHz/8-bit, ordinary OFF→ON has 5 s soft-start; Fan PWM is 25 kHz/8-bit, manual target 50–100%, safety can force 100%. Selector break-before-make is 200 ms and shared rail guard/settle is 1 s. Use cooperative millis() timing; no executable delay() or timing while loops.
- During voltage transition, if soft-start is active, capture interrupted-ramp state, force GPIO5 PWM 0% before selector output changes, wait 200 ms deadtime plus existing 1 s settle, then start a fresh 5 s ramp. If ramp is completed/full duty 100%, do not force PWM to zero and do not re-ramp; keep it continuous. If Peltier was logically OFF, voltage change must not turn it on. Fan stays ON/100% during handoff. Explicit OFF/Hotside/NTC/OTA safety cancels pending resume.
- Adaptive uses a 30 s thermal stage at each of 12 V, 9 V, 5 V; Peltier OFF/Fan 100%. Five continuous seconds at/below hotLimit−1°C before expiry cancels/recovers the dwell; otherwise 12 V and 9 V step down one rail and unrecovered 5 V enters terminal lock requiring manual restart. Following thermal downshift, recover upward one rail after 60 s stable and never above saved pre-downshift ceiling. HOTSIDE is startup default; HOTSIDE_BATTERY is runtime selectable and not persisted. Missing/stale phone Battery data causes HOTSIDE fallback without rewriting the selected profile.
- HISTORICAL / NOT IMPLEMENTED in V6.6: user asked for rapid Hotside rise/rate-of-rise shutdown and manual re-arm. Do not claim this exists or add it without reopening the requirement.
- Reported reset incidents are distinct: (1) 5 V→12 V while Peltier/Fan ON and soft-start active; (2) Adaptive ON after selecting 12 V and enabling Peltier/Fan. Reset reason was not captured. Brownout/supply transient is a HYPOTHESIS only. If user later authorizes reproduction, capture BOOT: RESET_REASON and telemetry; do not assume same root cause for both incidents.
- TTP223 is the only touch sensor; there is no separate Wi-Fi/BLE switch. Recorded timing reference: ~1 s startup grace, 30 ms qualification, raw HIGH tap 60–500 ms, 800 ms double-tap window from first valid release, 5 s long press; inspect current source before changing.
- Adaptive ON indication: three orange blinks. Adaptive OFF: three white blinks, deferred until safe 5 V handoff if needed. A missing white boot/OFF indication was reported historically; physical initial-boot behavior is UNVERIFIED.
- Voltage LED defaults: 5 V red, 9 V green, 12 V blue; configurable/resettable. Safety/OTA indicators outrank decorative effects. Settings writes share a 10-second quiet period; only changed persisted values are written. Adaptive Profile is runtime-only.

## 8. Protected OTA/cloud and history

- OTA is PROTECTED/FROZEN. Before any OTA/TLS/recovery code edit, read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md fully. Before rail/Peltier timing changes, read VOLTAGE_TRANSITION_MEMORY.md. Do not casually refactor/retime OTA.
- Local boot SoftAP: 10 s no-client timeout; 60 s hard cap after AP interaction; Wi-Fi is fully shut down and settles 160 ms before BLE takes the ESP32-C3 radio.
- Active Online OTA uses cloudClient.setInsecure(), which bypasses HTTPS server-certificate identity validation. The previous CA PEM validation and OTA-only NTP/TIME_SYNCING gate were removed together after a user-reported Wi-Fi-blue then GitHub-red failure. There was no serial/HTTP/TLS code establishing exact failure; the change that alone caused it was not isolated. Do not infer a specific TLS/HTTP result from LEDs and do not silently restore CA/NTP.
- Keep raw GitHub URL allowlist https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/, redirects disabled, HTTP status/length/size/image magic checks (ESP image magic 0xE9), streaming Update lifecycle, output-safe sequence, failure recovery/restart, and App reconnect/P1/one-shot result handling.
- App OTA command sequence: OTAENTER, SSID, PASS, URL, VERSION, CLOUDOTA. Arm expected OTA disconnect/recovery before sending CLOUDOTA. TIMEOUT/DISCONNECTED ACK is ambiguous, not proof of rejection; retain recovery state and await reconnect/result. Roll back only on a definite rejection while BLE is still connected. Firebase OTA metadata is firmware version + link; do not invent SHA/signature metadata fields without explicit approval.
- Source-to-BIN provenance is UNVERIFIED even though the repo contains a BIN-only artifact with the hash above. A source version bump does not establish a matching binary, compilation, OTA, reboot, or installed-version proof.

## 9. Durable build failures and rejected approaches

- Build #63 was a real failure: 87 Flutter tests passed, one stale widget assertion failed. Build #64 passed Flutter but native JUnit failed during JetifyTransform due Java heap OOM under 2 GiB. The assertion was repaired without weakening tests and Gradle heap was increased to -Xmx4096M; Builds #65–#69 passed the old FPS-enabled source gates.
- Build #70 verified the FPS-retired source: 86/86 Flutter tests, Dart analysis, Android production compile/gate, one obfuscated APK, V1/V2/V3 and certificate, corresponding-source ZIP and re-downloaded artifact checks; native JUnit tasks NO-SOURCE. Full detailed evidence is in APP_BUILD_REPORT.md.
- The previous FPS approach was rejected after repeated F:-- and no device log proof. Gemini proposals for imaginary APIs/methods, source-incompatible parsers and arbitrary BLAST/SurfaceView layer selection were not applied because they could pick the wrong app layer and were not grounded in the actual source.
- Historical Build #39 Maven-resolution failure and Build #40 source-archive path-check failure remain in APP_BUILD_REPORT.md/CHANGELOG.md; Builds #41–#45 failed before steps with runner_id=0/no logs; hosted-runner diagnostics were later deleted, and the external root cause was unconfirmed. Build #49 later succeeded. These are history, not current workflow state.
- Preserve all failed/rejected approaches and label their scope/version. A source-contract test is not proof it ran; App CI is not Firmware compilation; Firmware compile is not BIN provenance; successful download is not OTA update/reboot; user-reported success is not assistant-witnessed evidence.

## 10. Canonical memory inventory and blob hashes at the parent snapshot

Current canonical responsibility:
- PROJECT_STATE.md = current verified state only.
- MEMORY_INDEX.md = boot order and routing.
- CHAT_RULES.md = command/authorization/security/repository rules.
- CHAT_TRANSFER.md = full boot snapshot; read old version completely before replacing and re-fetch after write.
- CHAT_TRANSFER_PROMPTS.md = Prompt A reconciliation, B read-only boot, C lasting decision, D one-shot Build App LOAD + CONTINUE.
- README.md = repository navigation/current release boundary.
- HANDOVER.md = immediate next action.
- APP_NOTES.md = App UI, menus, BLE, telemetry, localization, Floating Monitor, App OTA contracts.
- FIRMWARE_NOTES.md and firmware/FIRMWARE_TECHNICAL_REFERENCE.md = board, code contract and evidence boundaries.
- OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md = frozen OTA safeguards/incident.
- VOLTAGE_TRANSITION_MEMORY.md = Peltier ramp/rail transition incident and contract.
- BUILD_NOTES.md = build procedure/workflow; APP_BUILD_REPORT.md = only complete build attempt ledger.
- CHANGELOG.md = historical decisions/failures; DESIGN_NOTES.md = approved design.
- archive/*.md = immutable forensic snapshots only.

Verified blob hashes after first reconciliation commit:
- README.md 099b93fb35eb34d1657dc63036de3d04094f3029
- MEMORY_INDEX.md f22a739fbdba77ccd6d341ba4a2dba25101730e0
- CHAT_RULES.md db3b1faabf0a21dd5368d6f634bf7c1bc7f01dee
- PROJECT_STATE.md b9b534f7f404d5e72c7d9b3be48cd500e5539ad0
- HANDOVER.md 4a500b9d00c4f5c615240c417cd82fa326e40756
- APP_NOTES.md 29e947b03cd8e6b7a5499de5bed4e1b651c6d19d
- FIRMWARE_NOTES.md e4d43acadfae36178c5c812c4b622d7a11adc663
- firmware/FIRMWARE_TECHNICAL_REFERENCE.md c001884d70a411dee8037bca24badd0b8345b97c
- OTA_PROTECTION.md 06beb86b749b0f0e14c8cb517e43fe7c0f66a4e1
- OTA_REGRESSION_MEMORY.md cd570a9bb70d36beeb19445eb236369f93fbe974
- VOLTAGE_TRANSITION_MEMORY.md 8b27203d6f7ab7a19608a5ca4db5b59e64b64b17
- BUILD_NOTES.md e62c86ccd247dcb3b5137461bfadb94fdcefced0
- CHANGELOG.md a07f860d4f0aa8c79f0117fb09507867faf8ea3a
- DESIGN_NOTES.md 5672906b840947aebcc6b3c7092605249f6fd6d6
- CHAT_TRANSFER_PROMPTS.md 91a5167f6c3dc6c3a3f66f5cef4e99b4c19d9ab3
- APP_BUILD_REPORT.md 8330ef4fa522fa5913d4e1fd6f95d43b87eeb2a5
- .github/workflows/jexfyz-app-build-trigger.yml 8a8533aff7e0e0e01412bf522e1966e81aa1a39f
- This file is being replaced in the final transfer-only commit; its next hash should not be embedded here.

## 11. Evidence labels and exact next actions

- CURRENT / VERIFIED: checked against live GitHub HEAD/tree, exact source refs, Actions/Release artifacts.
- SOURCE IMPLEMENTED / NOT RUN: code exists but the matching test/build command did not run.
- USER-REPORTED: user says Firmware V6.6 compiled and two same-version Online OTA updates succeeded; not independently witnessed.
- UNVERIFIED: physical phone overlay/Fan Speed telemetry/animation, BLE pairing exclusivity, firmware thermal/LED behavior, source-to-BIN provenance, end-to-end OTA/reboot/installed version.
- HYPOTHESIS: brownout for historical resets; whether CA or NTP alone caused the earlier OTA failure.
- HISTORICAL / SUPERSEDED: Build #69 and earlier FPS/Shizuku source/results, old V5.x–V6.x source snapshots, archive CURRENT claims.
- NOT RELEASED: source states without a corresponding verified release (Build #70 itself is the latest verified App release; Firmware BIN provenance is separate).
- Immediate next action: run `@Thinking Eksekusi Build App!` for the post-Build-70 source, because `Eksekusi Full!` did not authorize Flutter tests, analysis, Android build or release. After a passing build, install its APK and inspect OFF/ON motion continuity, the Peltier spark orbit and neutral theme-primary voltage toggles on a physical phone.
- For a new source change, discuss with @Thinking Diskusi!, then @Thinking Eksekusi Full! for approved source/tests/memory and separately @Thinking Eksekusi Build App! for release. @Thinking Chat Stuck! only recovers the previous authorized task and never expands permission.
- Source/tests and current notes were updated on `main`. Flutter tests, Dart analysis, Android build/release/signature gates and physical-phone checks were NOT RUN. No Firmware compile, BIN read/change/publication, Firebase update, OTA/flash, App Build, release trigger or physical device operation occurred.