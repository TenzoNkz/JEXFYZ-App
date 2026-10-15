# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot timestamp: 2026-10-16 00:04 Asia/Jakarta.
Read this entire file first in a new context, then re-fetch live GitHub. This is one handover, not a competing source of truth. PROJECT_STATE.md is current-only, APP_BUILD_REPORT.md is the authoritative build-attempt ledger, APP_NOTES.md and the Firmware/OTA notes are the subject-specific contracts, and CHANGELOG.md is historical.

## 1. Repository identity and snapshot evidence

- Canonical App/source/memory repository: TenzoNkz/JEXFYZ-App.
- Canonical branch: main. Snapshot was audited against parent HEAD 329fd18e3c6ced8f43a7dbfaf7bf02206c17d42a immediately before this documentation-only reconciliation.
- Parent recursive Git tree was fetched live, not truncated, and contained 80 entries. Five branches were live: diag/latest-stable-v16 (ec77759d224c581870d98330d9278896ff29e50b), diagnostic/v1.6-heap-check (1a4cd83b3ee82cdc2d86277dc4a0eb4c4238f8a3), fix/adaptive-power-sequencing (33740be782d976a881e285bbf8b86b3b485b83c1), main (329fd18e3c6ced8f43a7dbfaf7bf02206c17d42a), tmp-jexfyz-v5-test (b388cba98ea1d9e92873df64ba3224d6cb99156d). Open PR count: 0.
- After this snapshot's commit, main HEAD will be the docs-only reconciliation commit whose parent is 329fd18e3c6ced8f43a7dbfaf7bf02206c17d42a. Re-fetch live HEAD/tree before any further work. This file intentionally does not store its own future blob SHA.
- App artifact repo: TenzoNkz/JEXFYZ-Firmware. Live recursive tree was fetched and confirmed exactly one entry: JEXFYZ.cpp.bin, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6, 1,455,936 bytes. Never add notes there. The BIN source provenance is unverified.

## 2. App version, source, active tests and workflow

- App name JE Cooler, brand/header JE X FYZ. Package com.horizontalzzz.jexfyz. pubspec.yaml version 1.0.0+3. Preserve Android Gradle versionName exactly as "Telegram @horizontalzzz".
- Current main source blobs at snapshot basis:
  - lib/main.dart: 72c450d9b1e8783e4b82b8e37a5f39e2d49b6289.
  - lib/floating_monitor.dart: 05a61e5670ec09c9c46cf60466a1dd301dfe5352.
  - lib/app_settings.dart: 46cc838f43a06c325af6f6832e200a4e1ed4f75d.
  - android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt: 0c9cfdee776ca2f1de5daf2205d1f9f8da63683d.
  - android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FpsShizukuUserService.kt: 1f5ed36dadaba9dc70ecfbe0793114b34c8ab08b.
  - android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt: a139dfefe1121963c3a26b114b9b0fcc9f8fa16a.
  - android/app/src/main/aidl/com/horizontalzzz/jexfyz/IFpsShizukuUserService.aidl: 5bd6c269212e523b190f7164e0ad1d257ed5e6a5.
  - android/app/src/main/AndroidManifest.xml: 393c9f9bfe02b9d71b2e3445ce873d5d16912ce1.
  - android/app/build.gradle: cc35d2d3dbe603e7b5a7157d37dde222d646ea42.
  - android/build.gradle: d6dbd400ba0baf2b33c14bb514745334a1e2ad33.
  - pubspec.yaml: 8f558273e21692af9958f914527fdc62d623d63a; pubspec.lock: 1e92812bfda2c28244a0556d71d1ec94084acc66.
  - .github/workflows/jexfyz-app-build-trigger.yml: 585d190324e522fc08e66cc95bd7ee80c5f37664.
- Six active test files and current blobs:
  - test/app_protocol_notify_contract_test.dart: 92214dd90178c705844d3979d3f8f7bd17bcc4b8.
  - test/firmware_touch_adaptive_sync_test.dart: 2d3fea509343a03b8d23623f4dcb2dd7fd972d39.
  - test/floating_monitor_layout_contract_test.dart: 31d9aabf4ac0839855308b6bd2a0708fa399a3a9.
  - test/shizuku_fps_contract_test.dart: 798633a24907fd8aca567e70a6376dc59c6e41c9.
  - test/v6_6_qc_contract_test.dart: 2bee4d960d014f0765422dcb5ed1c9870ba6ee3a.
  - test/widget_test.dart: 520399fcdc6be4fd69cb48f50aa8961f5d9183c5.
- Workflow: owner/title/token guarded issue opened/reopened only. Exact title JE X FYZ — EKSEKUSI BUILD APP TRIGGER; exact body token JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1. Normal push/PR doesn't run a build. Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1. Pipeline runs static security/architecture/license audit, flutter pub get, Dart analyze, Flutter tests, release APK build/obfuscation, V1/V2/V3 signing/certificate checks, corresponding-source ZIP, Release publication and downloaded asset verification. One ordinary APK and one matching source ZIP; no Play Store bundle or Actions artifact.
- Last observed live Actions runs: #54 success (38767611593), #53 failure (38767300776), #52 failure (38766565895), #51 failure (38766215071), #50 failure (38765636867), #49 older success (38739077916). Five branches, zero open PRs.
- Build #50–#53 failures and repair reasons must stay in APP_BUILD_REPORT.md: #50 Dart analysis flagged private unused state, repaired in source; #51 exposed two over-escaped temperature parsing assertions, regex corrected; #52 AIDL compilation failed due inconsistent explicit/implicit transaction IDs, interface transaction ID corrected; #53 then exposed an outdated AIDL test assertion, corrected. No test was weakened to obtain green. Build #54 is the full success.
- Latest successful Build #54, run 38767611593, job 116534803134, source commit 437e7730dbcaf9666ae4828e546a45343bb4890c, completed at 2026-10-15 16:21:50Z. Dart analysis passed; 86/86 Flutter tests passed; obfuscated APK build, signing and expected production certificate verification, source ZIP validation, release publication and re-downloaded asset/hash verification passed.
- Release tag jexfyz-latest, target source commit 437e7730dbcaf9666ae4828e546a45343bb4890c. Exact assets:
  - JEXFYZ-release.apk, ID 644438898, 54,636,716 bytes, SHA-256 cdf8a7f94424b9cb60be6e04489a9f0f0d8ddad43ab76c33c2e2c6333fa61327.
  - JEXFYZ-corresponding-source.zip, ID 644438897, 2,862,590 bytes, SHA-256 3b208c987def59a7c1857ed0fcc9ca5d74d591767e5658dfab04c9c1be85450f.
- Signing gates reported V1/JAR=true, V2=true, V3=true, one signer and expected production certificate DN/SHA-256 matched. Non-blocking warnings: analyzer deprecation infos (ReorderableListView, Radio groupValue/onChanged, Color getters), Kotlin Gradle Plugin future migration, Gradle update notice, dependency upgrades outside current constraints, native ELF DWARF metadata, and jarsigner self-signed/no-timestamp. These warnings are recorded; do not treat them as build failure because explicit mandatory gates passed.
- CI is not device proof. It does not prove physical UI/drag/lifecycle, BLE/cooling, firmware compilation, actual FPS, OTA/flash, or source-to-BIN provenance.

## 3. Current Floating Monitor implementation and open FPS issue

- Overlay position remains freely draggable. WindowManager gravity is TOP | START with saved coordinates; only the metric content is centered. Horizontal metric values center as a group; vertical items are individually centered. No screen-center lock.
- Appearance settings persist: Size 0.30×–0.80× in 0.05× steps, default 0.60×, current number visible; background Opacity 0–100%, current percentage visible, scale marks 0%, 50%, 100%; Black/White background, default Black, foreground text/icons switch to a contrasting color. At opacity zero, only the background disappears. Tighter spacing/radius remain in source.
- Seven stable metrics are F/B/H/V/A/P/S; S is the only fan-related display metric. Telemetry is authoritative, not ACK-based. If disconnected, output states remain -- instead of inferring physical OFF.
- Shizuku migration: pinned API/provider 13.1.5 with MIT notice/license. FPS access requires Shizuku Binder available, Shizuku version >=10 and explicit JE X FYZ permission approved in Shizuku UI. UserService operations cross AIDL using fixed operation IDs. Ordinary app process does not run dumpsys and manifest does not request android.permission.DUMP. Removed legacy Wireless ADB pairing/identity storage, Kadb/SPAKE2 dependencies/licenses, ADB grant/revoke commands and old pairing test.
- Native FPS samples SurfaceFlinger timestats once per second and matches layers against Android's resumed/focused foreground package; it does not substitute display refresh rate or random busy background layers. The service deliberately shows -- when JE Cooler's own app package is the foreground package, when focused app cannot be identified, when no matching layer exists, or when read access fails.
- CURRENT DEVICE ISSUE / USER-REPORTED: the screenshot from the user shows “Shizuku permission granted” in settings but F:-- in the overlay pill, with B:41.5°, H:31.3°, V:12V, A:OFF, P:OFF, S:100. It appears the JE Cooler Floating Monitor settings page is foreground. This is consistent with the intentional no_game_foreground branch; it is a hypothesis, not verified cause. The permission label only proves authorization, not successful UserService binding or SurfaceFlinger read/layer match. No runtime fps_monitor_status dump/logcat was provided.
- NEXT DEVICE DIAGNOSTIC: enable the overlay, launch an actual game, and leave the game foreground. If F stays --, collect exact native fps_monitor_status and logs. Distinguish shizuku_userservice_unavailable, shizuku_userservice_disconnected/error, surfaceflinger_blocked, dumpsys_timeout, foreground_unknown, no_game_foreground, no_layer_data and waiting_for_frames. Don't claim a source fix or replace real FPS with refresh-rate number without evidence. The user invited “ask Gemini if useful”; no Gemini connector was found and Gemini was not consulted. Shizuku UserService/live Game FPS behavior remains UNVERIFIED on this OEM.

## 4. Active Firmware, hardware and current safety contract

- Active editable sketch: firmware/JEXFYZ-V6.6.ino, blob f51ba6db5d0e91318f63fea4014bb87f7bf76222, FW_VERSION="V6.6". Live repository had exactly one active versioned .ino. App source does not include Firmware as a build dependency.
- User considers Firmware V6.6 final/correct and reports compiling it plus two successful same-version Online OTA updates. USER-REPORTED only; this context did not independently witness build log or flashes. Source-to-BIN provenance remains UNVERIFIED. Do not compile Firmware, generate/replace/publish BIN or touch hardware without separate explicit authorization.
- MCU ESP32-C3 Super Mini / ESP32-C3 Dev Module, 3.3 V logic, single radio path for Wi-Fi/BLE. Pin map: GPIO0 NTC ADC, GPIO1 TTP223 touch, GPIO3 12V selector, GPIO4 9V selector, GPIO5 Peltier MOSFET PWM, GPIO6 Fan MOSFET PWM, GPIO7 WS2812.
- MOSFET memory: GPIO → R100 → Gate; 100 kΩ gate-source pull-down. Fan positive to supply, negative to MOSFET Drain. A prior apparent 12V selector problem was later traced to a loose cable, not established code defect.
- NTC: nominal 10 kΩ, fixed resistor 10 kΩ, Beta 3950, 3.3V divider assumption, calibrated analogReadMilliVolts(), exactly one sample per second. User explicitly rejected median, trimmed-mean and multi-sample averaging; do not reintroduce.
- Peltier PWM 20kHz/8-bit, normal OFF→ON soft-start 5 seconds. Fan PWM 25kHz/8-bit, manual 50–100%. Rail switch uses 200ms break-before-make and shared 1s settle. Fan stays ON/100% during handoff. If Peltier was OFF it stays OFF; if its ramp is active, pause GPIO5 to zero and restart a full 5-second soft-start after handoff; completed ramp remains at 100%. Explicit OFF, Hotside/NTC safety and OTA safe output cancel pending resume.
- Hotside threshold range 40–50°C, default 45°C. Manual re-arm only after Hotside <= hotLimit−1°C for five continuous seconds. One low sample cannot bypass latch.
- Adaptive temperature stages: 30 seconds at each of 12V/9V/5V with Peltier OFF, Fan 100%; five seconds stable at/below limit−1°C before deadline cancels a stage; otherwise 12/9 steps down and 5V terminal-locks. Recovery upward one rail at a time after 60 continuous seconds stable, capped at saved Adaptive ceiling. HOTSIDE default on boot; HOTSIDE_BATTERY runtime choice not persisted. App PHONE:BT heartbeat is 1Hz; firmware data TTL 5s, 0.5°C hysteresis, 5V threshold 25°C and 12V threshold 35°C; stale Battery data falls back to HOTSIDE without rewriting selected profile.
- No standalone Battery Protection Guard UI. There is no separate Wi-Fi/BLE touch switch. Adaptive ON indicator is 3 orange blinks; OFF is 3 white blinks after safe handoff as applicable. User reported missing initial OFF white blink after restart; still physically unverified. Request for rapid Hotside-rise/rate-of-rise shutdown/manual re-arm remains unimplemented in known V6.6.
- LED defaults: 5V red, 9V green, 12V blue; user-customizable/resettable. Supported RGB IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. ID3/Mirror Pulse is retired and migrates to Static. LED sync uses one atomic LED_SYNC mode/phase/cycle tuple. Persistent settings debounce has a 10-second quiet period.
- Touch timing record: about 1s startup grace, 30ms raw qualification/debounce, raw HIGH 60–500ms tap, 800ms double-tap window, 5s long press. Verify live source before adjusting.
- Separate user-reported resets must remain separate: Manual 5V→12V with Fan/Peltier on during active Peltier soft-start, and entering Adaptive at 12V with Fan/Peltier on. Reset reason unknown; brownout is a hypothesis only.

## 5. App/BLE/UI and accepted visual design

- UI reference: Horizon Cooler app architecture/design; dark header, white rounded content panel, compact dashboard. Menu order VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Home holds Battery/Hotside temps, voltage, Adaptive, Peltier/Fan, Fan Speed and Notify reason; cooler image remains on right.
- BLE protocol P1 UUIDs: service 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001, RX 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001, TX 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001. Native Android services/overlay must not create a second BLE/GATT client. Encrypted/bonded writes exist; an exclusive one-App/one-cooler provisioning lock is a design requirement but exclusive enforcement remains UNVERIFIED.
- Manual voltage switching has 1-second guard; Adaptive returns safe 5V and does not own manual Fan PWM; Adaptive can demand 100% cooling. Firmware telemetry is authoritative. ACK alone doesn't prove hardware action. Disconnected Home/Floating output states are --.
- App phone Battery temp heartbeat PHONE:BT at about 1Hz and coalesces pending writes. Firmware data freshness TTL 5s. Do not render a standalone Battery Protection Guard.
- LED Color Picker: 36 curated localized hue-ordered presets, no HEX labels, stage a draft before Select, Cancel discards, no outside-tap/system-back dismissal. Mode IDs above remain stable.
- Dashboard custom visuals: segmented Battery thermometer/colors and fire at >=40°C; Hotside thermometer without overlapping heat waves and limit-aware color; voltage bolt uses sinusoidal/back-and-forth energy sweep; Adaptive orbit/core reflects actual ON; six-branch free-standing Peltier frost crystal has no module box/frame/bolts and no OFF fade; Fan rotor: 5V 2600ms / 9V 1250ms / 12V 620ms phase-continuous change and brief coast-down; Fan Speed gauge retargets over 420ms and returns to zero over 520ms with seamless integer-harmonic wobble. Bluetooth ripple uses a squared-sine opacity envelope to avoid a cycle seam flash. These are App illustrations, not measured ice/RPM.
- Notify badge uses CONNECTED/DISCONNECTED consistently in both languages for plain connection state; real errors/in-progress continue to show richer status. Power state localizes ON/OFF vs HIDUP/MATI; machine protocol strings stay English. Android notifications use the transparent white JE monogram small icon only and a meaningful body/tap intent.
- Approved grille design: white symmetric square, 1:1 outline, central purple X, four corner mounting holes, preserve interior pattern/frame, remove side-midpoint protrusions only when requested, flat print-ready 2D with no shadows/bevel/gradient/texture. HZ monogram is rejected; purple X is approved. PNG app/cooler icons must stay transparent 1:1.

## 6. OTA/cloud/security decisions (protected)

- Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery change; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing. Do not touch protected OTA code during unrelated cleanup.
- Local OTA boot SoftAP: current known 10s no-client timeout, 60s hard cap after interaction, Wi-Fi shutdown and 160ms radio settle before BLE owns the radio again. Reconcile with live source before edits.
- Online OTA currently uses cloudClient.setInsecure(), bypassing TLS certificate identity validation. An earlier embedded CA + OTA-only NTP/TIME_SYNCING gate was removed together after a user-reported blue Wi-Fi-success then red GitHub-connection-stage symptom. Exact HTTP/TLS root cause was not isolated; do not infer precise error from LEDs. Keep raw GitHub BIN URL allowlist, redirects blocked, HTTP/content-length/size/image checks, safe outputs, streaming Update lifecycle and error recovery.
- Firebase firmware metadata is version + link; user explicitly rejected SHA field in Firebase. Do not invent signing/checksum metadata or source-to-BIN claims.
- App OTA sequence OTAENTER → SSID → PASS → URL → VERSION → CLOUDOTA. Timeout/disconnect ACK is ambiguous, preserve recovery until reconnect/result. Separate transport, download, Update finalize, reboot, BLE recovery, installed version and Firebase promotion evidence.
- One radio path means BLE and Wi-Fi are not concurrent; OTA has priority and Peltier/Fan/LED safe behavior remains protected.

## 7. Authorization and permanent rules

- @Thinking Diskusi! is full read-only discussion.
- @Thinking Diskusi! Tanya Gemini! / Jawaban Gemini! only when Diskusi! is present in the same command.
- @Thinking Eksekusi Full! executes approved source/docs/tests and may commit to main; it does NOT imply App Build, Firmware compile, BIN, Firebase, OTA, flash or device operations.
- @Thinking Eksekusi Build App! is the only command authorizing complete App test/analyze/build/sign/release verification. Do not trigger the issue manually unless the command authorizes it. Current workflow checks owner, exact title and body token; no push/PR build.
- @Thinking Chat Stuck! recovers last authorized work from live repo/logs without blind retries or scope expansion.
- Retired aliases: @Thinking Build App!, @Thinking Eksekusi & Build App!, standalone @Thinking Eksekusi!.
- Use main directly; no branch/PR unless asked. All source and memory stay in App repo; firmware artifact repo BIN-only. Do not expose google-services.json contents/signing material. File renames/deletes require every link/index/test path update.
- User compiles Firmware. Every functional Firmware source edit requires FW_VERSION bump, matching file name and exactly one active versioned .ino. No blocking delay() or timing while loops. Preserve V6.6 final unless user explicitly reopens Firmware work.
- Keep Android Gradle versionName "Telegram @horizontalzzz". No protected OTA changes without rereading protection/regression notes.
- Never turn user-reported or hypothesized evidence into VERIFIED. CI/test source proves neither physical behavior nor OTA; LEDs do not prove a precise HTTP/TLS error; build success is not source-to-BIN provenance.

## 8. Canonical document hashes at snapshot preparation

The following blobs were prepared for the direct-to-main documentation reconciliation and must be read back and verified after commit:

- APP_NOTES.md: de981c991274e48597d9ab96dbc2fefdaf65b6e3.
- README.md: 3ff1ace4c048c236ae69eaf96c1576e3470d663e.
- PROJECT_STATE.md: bdc0c7c9089cb0a34a006e76977381f1cb787d99.
- HANDOVER.md: 7d2be171b49b828a359d640cded31f81d87f3862.
- MEMORY_INDEX.md: 92f140daca8d714d14510415dc9c55db7237c9cf.
- BUILD_NOTES.md: da40e1315422bdbd2172278087a0b66c83a0e3e4.
- APP_BUILD_REPORT.md: 68406ef39efff01950f3f73129d7a22c9ae9f153.
- CHAT_RULES.md: 9ff0d3c2de489e635ece63985a9ae64ac22f8032.
- CHANGELOG.md: f400951568dd813f3c811659fd6ed31117950afc.
- FIRMWARE_NOTES.md: 2520bc0ee113de7499e36618272df7b82fd2788c.
- firmware/FIRMWARE_TECHNICAL_REFERENCE.md: fd4bb56462d354a31ff114e8e2d53ace0ba864d8.
- CHAT_TRANSFER.md is replaced in this commit; this document cannot include its own future blob SHA. The current file's SHA must be derived from the final tree.

## 9. Required next action and validation boundary

1. Re-fetch live main HEAD/tree and re-read final versions/hashes of changed docs. Confirm recursive tree remains complete with same paths, no extra current-status sections, no missing links and exact source hashes unchanged.
2. Confirm artifact repo remains a single JEXFYZ.cpp.bin entry; do not alter it.
3. For FPS, test with a real foreground game with the overlay enabled. If still --, collect exact native status/logs before proposing any source fix. Do not blindly rebuild before diagnosis.
4. Do not run an App Build, firmware compile, BIN generation/publication, Firebase change, OTA/flash or device operation as part of this memory reconciliation.
