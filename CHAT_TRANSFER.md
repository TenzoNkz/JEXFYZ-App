# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot reconciled against live `main` on 2026-10-17 after source-only integrated 2D icon, localization/LED, and V6.7 Adaptive Fan PWM changes. Build #71 remains the latest verified APK; current `main` changes are unbuilt/uncompiled and not in that release. Physical visuals and hardware behavior remain unverified. This file is committed last and deliberately excludes its own future blob/commit hash.

Source-of-truth order: live main source/tree and exact Actions/Release evidence → CHAT_RULES.md for authorization → PROJECT_STATE.md for current state → subject reference files and APP_BUILD_REPORT.md → HANDOVER.md / this snapshot → CHANGELOG.md for history → archive/*.md for forensic recovery only. Archived “CURRENT” wording is not live truth.

## 1. Current Git and repository state

- Canonical App/Firmware source and project-memory repository: `TenzoNkz/JEXFYZ-App`, branch `main`.
- Parent HEAD immediately before this transfer-only commit: `d6354792bd81b2309cd341d492103ed4d77a181f`, message `feat: redesign indicators and adaptive fan PWM`, tree SHA `148681797d273ed6575a46f65b996953cc70ea65`. Recursive tree is complete/not truncated: 67 entries (49 blobs, 18 trees). Exactly one active versioned Firmware sketch exists: `firmware/JEXFYZ-V6.7.ino`. Re-fetch branch/tree at next boot.
- Latest verified release: Build #71 / [Actions run `39008259484`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39008259484), exact release/source commit `d9e026f70ec62455763de05048cba1557edfaf23`. Completed at `2026-10-17T06:05:54Z` (`2026-10-17 13:05:54 Asia/Jakarta`). All 21 active workflow steps passed: audit, dependencies, Dart analysis, **88/88 Flutter tests**, Android production compilation/configured gate, obfuscated APK, V1/V2/V3 signing and certificate checks, source ZIP, Release publication and re-downloaded asset verification.
- Build #70 is historical and verified FPS/Shizuku retirement plus schema-v2 migration to six metrics B/H/V/A/P/F (F=Fan Speed). Build #71 is newer and includes the post-Build-70 motion/toggle refinements.
- Build #71 was triggered through owner/title/token-guarded [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Issue owner `TenzoNkz`, title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; workflow blob `8a8533aff7e0e0e01412bf522e1966e81aa1a39f` is unchanged and listens only to issue opened/reopened. No push/PR/dispatch bypass.
- Live branch/PR check: five branches and zero open PRs. No branch or PR was created for this Build App work.
- Dedicated Firmware artifact repository `TenzoNkz/JEXFYZ-Firmware` is BIN-only. Its complete live tree has exactly `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. The BIN payload was not read or changed; source-to-BIN provenance remains UNVERIFIED.

## 2. Latest verified App release and artifacts

- Release APK [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk): asset ID `649710440`, 54,603,867 bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`.
- Matching [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip): asset ID `649710439`, 2,847,410 bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets exact source `d9e026f70ec62455763de05048cba1557edfaf23`, contains exactly one APK and one corresponding source ZIP; both were re-downloaded and verified against hashes/source marker. APK V1/V2/V3 checks passed for built and downloaded artifact.
- Signing: one signer; expected certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; RSA key 4096 bits.
- `flutter analyze --no-fatal-infos` passed with 23 info-level deprecation findings; 88/88 Flutter tests passed. The configured Gradle unit-test gate succeeded, but Kotlin/Java unit-test compilation and `:app:testDebugUnitTest` were NO-SOURCE after FPS-specific native tests were retired. **No native JUnit cases ran in Build #71.**
- Non-blocking warnings: Gradle 9.3.1 out-of-date; native ELF DWARF information not obfuscated; JAR/META-INF V1 coverage and self-signed/no-timestamp certificate notices; pub-cache save denied by token scope. None failed a required release gate.
- CI does not prove phone visuals, live BLE/Fan Speed telemetry, Firmware compilation, cooling/thermal safety, OTA/reboot/installed version, physical flash or hardware behavior. No Firmware source/BIN, Firebase, OTA, flash or device operation occurred.

## 3. Current source fingerprints and canonical docs

- Latest **verified release source** remains `d9e026f70ec62455763de05048cba1557edfaf23` (Build #71). Current `main` functional source is `d6354792bd81b2309cd341d492103ed4d77a181f`; it includes new unbuilt changes and must not be mistaken for a verified APK.
- Current source/test blobs:
  - `lib/main.dart`: `3bb9a772e7e4a192cd9b4457846b111e28ec305a`.
  - `lib/floating_monitor.dart`: `31b45ea08b08ac7fc25ebd991dca873b889fdd14`.
  - `lib/app_settings.dart`: `77faaa80264ed65ab5c104588978bb903e9f89db`.
  - `test/widget_test.dart`: `66861cad0638433bd7b575439bb4a2b637f1f856`.
  - `test/floating_monitor_layout_contract_test.dart`: `87e805095202ac3edfe55b9aeb3138c7c6886375`.
  - `test/v6_7_qc_contract_test.dart`: `6b71cc2ebbef9b3f1c9757728067eec4d11ff5ee`.
  - `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`.
  - `test/firmware_touch_adaptive_sync_test.dart`: `94c0f074247f47fce7d939a72b0130eb1b2d70fa`.
  - Native `FloatingMonitorService.kt`: `8312cc12d391cde5f76b146ff98075856d32bae2`; `MainActivity.kt`: `bd17c34211e8eb5c4723e06937ae47f0071b5e8b`; `AndroidManifest.xml`: `c374b5d3ad6448b8b3e99a420ed7e8c49d38497a`; `android/app/build.gradle`: `060cdd36a4f7d4d2fa4c97a1b6a15954b8355350`.
  - Active workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `8a8533aff7e0e0e01412bf522e1966e81aa1a39f`.
- Canonical docs immediately before this transfer-only commit:
  - `APP_BUILD_REPORT.md`: `2c9d2701aef8d02ff71f89214418b8f9aa3d0b6b`.
  - `PROJECT_STATE.md`: `369b673cf9055408b330f781f0d24b08396f5803`.
  - `MEMORY_INDEX.md`: `cd51978a4223fb3a43f87e5943e276081b2bca6d`.
  - `BUILD_NOTES.md`: `821f3370bbf6816874681195ceff21a36faf5573`.
  - `HANDOVER.md`: `2d1626f10251133de3c5ba89a8bdf33a62cf71d9`.
  - `APP_NOTES.md`: `4607cd20dbc87d97975440038661aaa338d6e24f`.
  - `CHANGELOG.md`: `002644d53454b117ac5bc8d9bc44df222ffd0418`.
  - `README.md`: `a5bb31bec9a83c03daddbab9cd127d537660a90e`.
  - `CHAT_RULES.md`: `eae86f7e921b3eb49337bea87a39255eabb7b4c3`.
  - `FIRMWARE_NOTES.md`: `32248ddfd38fef424c19502ba55ba239010ff84d`.
  - `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `4af64f254ce9f12cf5d34806f9c4f46f4900fdf4`.
  - `OTA_PROTECTION.md`: `767364ed6c8afd87104f0348490a5afd245d2fe3`.
  - `OTA_REGRESSION_MEMORY.md`: `e8c7986496b6dcc555823ee699a0a46deb6554c7`.
  - `VOLTAGE_TRANSITION_MEMORY.md`: `4de77610a070f5691ac3046c7055c6e8a332b77b`.
  - `DESIGN_NOTES.md`: `e2bc96eea271fb33cf176c1ea45131dc7e5782da`.
  - `CHAT_TRANSFER_PROMPTS.md`: `f838a490437407f714a04dce8e504e704bf39df1`.

## 4. Current Floating Monitor: FPS retired, F label is Fan/Kipas

- The user chose to remove FPS entirely after repeated F:-- and Shizuku UserService failures rather than continue speculative device-specific FPS fixes. This decision was implemented in Build #70 and is included in the current release.
- Exactly six metric IDs: B (Battery Temperature), H (Hotside Temperature), V (Voltage), A (Adaptive), P (Peltier), F (Fan Speed). F is labelled Fan/Kipas and its numeric value shows live fan speed, not FPS. Fan telemetry and Firmware speed control were not changed.
- Persisted schema v2 migrates legacy schema v1: old F (FPS) selections are discarded; old S (Speed/Fan Speed) migrates to F. This avoids interpreting a saved FPS setting as a Fan Speed value.
- FPS SurfaceFlinger/TimeStats sampler and watchdog/parser, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-specific tests, Shizuku-only Dart contract, and Shizuku-only notice/license files are removed. The active workflow audit guards against their reintroduction.
- Overlay contract: Letters-only (legacy Icons normalize to Letters), freely draggable with saved coordinates; horizontal metrics centered as a group, vertical rows share a left edge; size 0.30×–1.00× in 0.05× increments (default 0.60×); opacity 0–100% in 5% steps, current percent/endpoints, no midpoint; opacity affects background only. Fan on displays live speed, Fan off localized OFF/MATI, disconnected output is `--`.
- Build #71 verifies the updated App source/build but cannot prove actual phone layout, animation, BLE connection or live Fan Speed telemetry. Physical device check remains open; FPS is retired and must not be revived without a new explicit user request.

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

- Main design direction is based on Horizon Cooler App: dark header, white rounded content panel, compact cards, VOLTAGE and ADAPTIVE principal tabs, cooler visual on the right. Intended sub-menu hierarchy: VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Keep changes scoped; do not rework approved identity without explicit request.
- Home indicators: disconnected value unknown but preserve lowest semantic accent instead of black/grey; color alone does not assert hardware output. Battery is Ice Blue at ≤30°C, smooth cyan/amber/orange transition through 30–40°C, Burning Red at ≥40°C. Hotside is Ice Blue ≤30°C, smooth above and Burning Red at configured Hotside Limit. Visual palettes never replace Firmware safety.
- Manual voltage: neutral 5V/9V/12V rows; only the active toggle uses theme-primary, without a check glyph; labels retain 5V red, 9V green, 12V blue semantics; unknown voltage falls back to 5V red. Voltage command/lock/telemetry logic and other shared switches remain unchanged.
- Build #71 adds eased activity continuity: OFF transitions run through a 440 ms fade before pausing; ON resumes from retained phase at an equivalent loop boundary rather than jumping to frame zero. Thermal flame geometry meets at the loop seam, Battery bar segments ripple gently, and four bounded Peltier sparks orbit a stable six-branch crystal. Fan keeps voltage-dependent phase handoff/coast-down. These are illustrative animations, not actual RPM/ice/cooling measurements.
- **CI verified but not device verified:** Build #71 passed 88/88 Flutter tests and release gates for these changes. Physical animation smoothness, geometry and toggle appearance remain unverified on a phone.
- LED color picker uses 36 curated hue-ordered presets with localized names and no HEX UI. Swatches update local draft only; explicit Select sends confirmed COLOR, Cancel discards without BLE write. Existing LED mode IDs Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7 remain; mode 3/Mirror Pulse is retired.
- Approved printable JE X FYZ grille is exact symmetric 1:1 square, white geometric grille, purple central X, four corner holes, preserve pattern/frame. Flat 2D, no shadow/bevel/gradient/texture/invented elements. Transparent assets: `assets/jexfyzicon.png`, `assets/jexfyzcooler.png`, Android icon `android/app/src/main/res/drawable-nodpi/jexfyzicon.png`.

## 7. Active Firmware V6.7 and hardware baseline (source-only; not compiled)

- Canonical active source: `firmware/JEXFYZ-V6.7.ino`, blob `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`; embedded `FW_VERSION="V6.7"`; exactly one active versioned `.ino`. Target ESP32-C3 Super Mini/Dev Module, Arduino-ESP32 Core 3.3.7; user compiles via ArduinoDroid. V6.7 is source-only and uncompiled.
- V6.6 compile/two-same-version-OTA statements are historical USER-REPORTED evidence. The user reopened source work and authorized V6.7 Adaptive Fan PWM; V6.7 has no compile, BIN/source provenance, OTA, flash or device validation. No such operation was performed in this task.
- ESP32-C3 has one radio path: Wi-Fi OTA and BLE may not own the radio concurrently; explicitly transfer ownership.
- Pin map: GPIO0 Hotside NTC ADC; GPIO1 TTP223 touch input; GPIO3 12 V selector; GPIO4 9 V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812.
- MOSFET wiring memory: GPIO → R100 → gate; 100 kΩ gate-source pull-down. Fan positive goes to supply (“Decoy” as written in user note); fan negative goes to MOSFET Drain. A prior 12 V selector problem was later traced to a loose cable, not established code defect; verify physical wiring before changing code.
- NTC: 10 kΩ nominal thermistor, 10 kΩ fixed divider, Beta 3950, 3.3 V reference assumption, calibrated analogReadMilliVolts(PIN_NTC). One sample per second, no median/trimmed mean/multi-sample averaging without explicit renewed approval. NTC invalid state fails safe (Peltier OFF, Fan 100%, Adaptive OFF and safe 5 V per current contract).
- Hotside limit range 40–50°C, default 45°C. Manual Peltier safety latch re-arms only after Hotside ≤ hotLimit−1°C continuously for five seconds; a single low sample must not bypass the latch.
- Peltier PWM is 20 kHz/8-bit, ordinary OFF→ON has 5 s soft-start; Fan PWM is 25 kHz/8-bit, manual target 50–100%, safety can force 100%. Selector break-before-make is 200 ms and shared rail guard/settle is 1 s. Use cooperative millis() timing; no executable delay() or timing while loops.
- During voltage transition, if soft-start is active, capture interrupted-ramp state, force GPIO5 PWM 0% before selector output changes, wait 200 ms deadtime plus existing 1 s settle, then start a fresh 5 s ramp. If ramp is completed/full duty 100%, do not force PWM to zero and do not re-ramp; keep it continuous. If Peltier was logically OFF, voltage change must not turn it on. Fan stays ON/100% during handoff. Explicit OFF/Hotside/NTC/OTA safety cancels pending resume.
- Adaptive uses a 30 s thermal stage at each of 12 V, 9 V, 5 V; Peltier OFF/Fan 100%. Five continuous seconds at/below hotLimit−1°C before expiry cancels/recovers the dwell; otherwise 12 V and 9 V step down one rail and unrecovered 5 V enters terminal lock requiring manual restart. Following thermal downshift, recover upward one rail after 60 s stable and never above saved pre-downshift ceiling. HOTSIDE is startup default; HOTSIDE_BATTERY is runtime selectable and not persisted. Missing/stale phone Battery data causes HOTSIDE fallback without rewriting the selected profile.
- HISTORICAL / NOT IMPLEMENTED in V6.x: user asked for rapid Hotside rise/rate-of-rise shutdown and manual re-arm. V6.7 changes Fan PWM trend response only; it does not add a separate rapid Hotside-rise shutdown.
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

- Latest Build #71 / run `39008259484` passed all 21 active workflow steps and **88/88 Flutter tests**. Artifact/signing/source-marker evidence is in `APP_BUILD_REPORT.md`.
- Build #70 was the first verified release after FPS/Shizuku retirement; Build #71 is newer and includes the Dashboard motion/manual-voltage toggle changes.
- Historical Build #63 had a stale widget assertion failure (87 passed / 1 failed); Build #64 passed Flutter but native JUnit failed during JetifyTransform due Java heap OOM under 2 GiB. Assertion was repaired and Gradle heap increased to `-Xmx4096M`; Builds #65–#71 succeeded for their respective release source checkpoints. Keep exact per-run details in `APP_BUILD_REPORT.md`.
- The Build #71 configured Gradle unit-test gate passed, but Kotlin/Java unit-test compile/test tasks were NO-SOURCE after FPS-specific native tests were retired; no native JUnit cases ran in #71.
- FPS was retired after repeated F:--/Shizuku failures at the user's direction; the precise runtime root cause was never established. Do not revive speculative APIs/parsers or invent native surface attribution.
- Historical Build #39 Maven resolution failure, Build #40 source archive path failure and Builds #41–#45 no-runner failures remain historical; Build #49 later succeeded. A source-contract test does not prove it ran; App CI does not prove Firmware compile, BIN provenance, OTA/reboot or physical safety.

## 10. Canonical memory inventory and blob hashes at the parent snapshot

Current canonical responsibility:
- `PROJECT_STATE.md`: current verified state only.
- `MEMORY_INDEX.md`: boot order and routing.
- `CHAT_RULES.md`: command/authorization/security/repository rules.
- `CHAT_TRANSFER.md`: complete boot snapshot; read the prior version before replacing, and re-fetch after write.
- `CHAT_TRANSFER_PROMPTS.md`: Prompt A reconciliation, B read-only boot, C lasting decision, D one-shot Build App LOAD + CONTINUE.
- `README.md`: repository navigation/current release boundary; `HANDOVER.md`: immediate next action.
- `APP_NOTES.md`: App UI, menus, BLE, telemetry, localization.
- `FIRMWARE_NOTES.md` / `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: hardware and safety/source contracts.
- `OTA_PROTECTION.md` / `OTA_REGRESSION_MEMORY.md`: frozen OTA safeguards/incidents; `VOLTAGE_TRANSITION_MEMORY.md`: Peltier/rail-transition memory.
- `BUILD_NOTES.md`: build procedure/workflow; `APP_BUILD_REPORT.md`: authoritative build-attempt ledger.
- `CHANGELOG.md`: historical decisions/failures; `DESIGN_NOTES.md`: approved design; `archive/*.md`: immutable forensic snapshots.

Canonical document blob hashes immediately before this transfer-only write:
- `APP_BUILD_REPORT.md`: `2c9d2701aef8d02ff71f89214418b8f9aa3d0b6b`.
- `PROJECT_STATE.md`: `369b673cf9055408b330f781f0d24b08396f5803`.
- `MEMORY_INDEX.md`: `cd51978a4223fb3a43f87e5943e276081b2bca6d`.
- `BUILD_NOTES.md`: `821f3370bbf6816874681195ceff21a36faf5573`.
- `HANDOVER.md`: `2d1626f10251133de3c5ba89a8bdf33a62cf71d9`.
- `APP_NOTES.md`: `4607cd20dbc87d97975440038661aaa338d6e24f`.
- `CHANGELOG.md`: `002644d53454b117ac5bc8d9bc44df222ffd0418`.
- `README.md`: `a5bb31bec9a83c03daddbab9cd127d537660a90e`.
- `CHAT_RULES.md`: `eae86f7e921b3eb49337bea87a39255eabb7b4c3`.
- `FIRMWARE_NOTES.md`: `32248ddfd38fef424c19502ba55ba239010ff84d`.
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `4af64f254ce9f12cf5d34806f9c4f46f4900fdf4`.
- `OTA_PROTECTION.md`: `767364ed6c8afd87104f0348490a5afd245d2fe3`.
- `OTA_REGRESSION_MEMORY.md`: `e8c7986496b6dcc555823ee699a0a46deb6554c7`.
- `VOLTAGE_TRANSITION_MEMORY.md`: `4de77610a070f5691ac3046c7055c6e8a332b77b`.
- `DESIGN_NOTES.md`: `e2bc96eea271fb33cf176c1ea45131dc7e5782da`.
- `CHAT_TRANSFER_PROMPTS.md`: `f838a490437407f714a04dce8e504e704bf39df1`.
- `.github/workflows/jexfyz-app-build-trigger.yml`: `8a8533aff7e0e0e01412bf522e1966e81aa1a39f`.
- This file is being committed last; do not embed its own future hash.

## 11. Evidence labels and exact next actions

- **CURRENT / VERIFIED:** Build #71 / run `39008259484` passed 88/88 Flutter tests and all 21 active workflow steps. Release `jexfyz-latest` targets exact source `d9e026f70ec62455763de05048cba1557edfaf23`.
- **LATEST VERIFIED RELEASE (Build #71):** phase-continuous indicators and manual-voltage-toggle styling.
- **CURRENT SOURCE ONLY / NOT BUILT:** integrated 2D indicator redesign, EN/ID label/copy changes, RGB-only toggle gate, master physical LED Brightness and V6.7 Adaptive 12V Fan PWM.
- **TEST CAVEAT:** the configured Gradle unit-test gate passed but native JUnit compilation/testing was NO-SOURCE in #71; no native JUnit cases ran.
- **NOT DEVICE-VERIFIED:** phone-side icon/animation smoothness, toggle appearance, overlay geometry, live BLE/Fan Speed telemetry, BLE pairing exclusivity, Firmware thermal/LED behavior, source-to-BIN provenance and end-to-end OTA/reboot/installed version.
- **HISTORICAL / SUPERSEDED:** Build #70 and earlier release details, FPS/Shizuku code/results, older Firmware snapshots and archive CURRENT claims. Full build attempt history is in `APP_BUILD_REPORT.md`.
- **HISTORICAL USER-REPORTED:** V6.6 compile/two-same-version-OTA statements remain historical; they do not validate current uncompiled V6.7.
- **Immediate next step:** if a new APK is required, use the separate `@Thinking Eksekusi Build App!` authorization. Build #71 does not contain the source-only changes above. Phone-side visuals, live BLE telemetry and physical Firmware behavior remain unverified.
- For a new functional source change, use `@Thinking Diskusi!` then `@Thinking Eksekusi Full!` for approved source/tests/docs and separately `@Thinking Eksekusi Build App!` for CI/release. `@Thinking Chat Stuck!` only resumes the last authorized task and never expands permission.
- Build #71 and canonical notes are on `main`; physical-device checks remain pending. No Firmware compile, BIN read/change/publication, Firebase update, OTA/flash or physical-device operation occurred.

