# JE X FYZ / JE Cooler — Chat Transfer Snapshot

Snapshot reconciled against live `main` on 2026-10-19 (Asia/Jakarta), after Home animation refinement, current source/test hash audit, and README/BUILD_NOTES/APP_BUILD_REPORT synchronization. Build #80 is the latest verified APK; it includes rounded TamperScreen boxes and the earlier dashboard/menu work, but not the direct static warning-Icon cleanup or current painter refinements. Peltier uses a rotating crystal with falling snowflakes; Adaptive has no orbiting dot; Voltage uses a closed lightning current path; Fan airflow curves behind the rotor; Fan Speed has no autonomous glint/wobble; thermal effects use flame tongues rather than round ember particles; Battery/LED highlights wrap beyond clipped bounds. Flutter tests/analyzer and physical-phone rendering remain unverified. V6.7 compile/online-update status remains USER-REPORTED. This file is written last and deliberately excludes its own future blob/commit hash.

Source-of-truth order: live main source/tree and exact Actions/Release evidence → CHAT_RULES.md for authorization → PROJECT_STATE.md for current state → subject reference files and APP_BUILD_REPORT.md → HANDOVER.md / this snapshot → CHANGELOG.md for history → archive/*.md for forensic recovery only. Archived “CURRENT” wording is not live truth.

## 1. Current Git and repository state

- Canonical App/Firmware source and project-memory repository: `TenzoNkz/JEXFYZ-App`, branch `main`.
- Parent HEAD immediately before this transfer-snapshot commit: `c0e2b9f296eb2ddb8d0bed9681c0e70270da4fdf`, message `docs(build): update post-Build-80 animation boundary`. This snapshot is written last; final live source/test fingerprints are included below.
- Latest verified release: Build #80 / [Actions run `39171729285`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39171729285), exact release/source commit `4e9f14b959cdbf60136158187db26d0bb65f6287`. Completed at `2026-10-18T22:25:23Z` (`2026-10-19 05:25:23 Asia/Jakarta`). All 21 active workflow steps passed, including audit, dependencies, Dart analysis, **96/96 Flutter tests**, Android production compilation/configured gate, obfuscated APK, V1/V2/V3 signing/certificate, source ZIP, Release publication and re-downloaded asset verification.
- Build #70 is historical and verified FPS/Shizuku retirement plus schema-v2 migration to six metrics B/H/V/A/P/F (F=Fan Speed). Build #71 is newer and includes the post-Build-70 motion/toggle refinements.
- Build #71 was triggered through owner/title/token-guarded [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Issue owner `TenzoNkz`, title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; workflow blob `8a8533aff7e0e0e01412bf522e1966e81aa1a39f` is unchanged and listens only to issue opened/reopened. No push/PR/dispatch bypass.
- Live branch/PR check: five branches and zero open PRs. No branch or PR was created for this Build App work.
- Dedicated Firmware artifact repository `TenzoNkz/JEXFYZ-Firmware` is BIN-only. Its complete live tree has exactly `JEXFYZ.cpp.bin`, blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes. The BIN payload was not read or changed; source-to-BIN provenance remains UNVERIFIED.

## 2. Latest verified App release and artifacts

- Release APK [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk): asset ID `654626935`, 54,620,251 bytes, SHA-256 `b403ccd3813f1974b82703730fce2c60bab972b067bc7ac4875d51d0e55558c6`.
- Matching [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip): asset ID `654626933`, 2,852,944 bytes, SHA-256 `bae47230267438073c9fd2bdf9ee58bfd768a5fcdfedf7102983c05dc23bf0cc`.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets exact source `4e9f14b959cdbf60136158187db26d0bb65f6287`, contains exactly one APK and one matching source ZIP; both were re-downloaded and verified. V1/V2/V3 and production certificate checks passed.
- Signing: one signer; expected certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; RSA key 4096 bits.
- `flutter analyze --no-fatal-infos` passed with 23 info-level deprecation findings; 96/96 Flutter tests passed in Build #80. Native JUnit tasks were NO-SOURCE; no native JUnit cases ran.
- Non-blocking warnings: Gradle 9.3.1 out-of-date; native ELF DWARF information not obfuscated; JAR/META-INF V1 coverage and self-signed/no-timestamp certificate notices; pub-cache save denied by token scope. None failed a required release gate.
- CI does not prove phone visuals, live BLE/Fan Speed telemetry, source-to-BIN identity, cooling/thermal safety, OTA/reboot/current installed version, physical flash or hardware behavior. The user separately reports V6.7 compiled and was updated online; this was not independently verified in the App-only task. No Firmware source/BIN, Firebase, OTA, flash or device operation was performed by the assistant in this task.

## 3. Current source fingerprints and canonical docs

- Latest **verified release source** is `4e9f14b959cdbf60136158187db26d0bb65f6287` (Build #80). It includes rounded TamperScreen blocks and the earlier Home animation/state-gating/toggle/menu-lock changes, but not the direct static warning `Icon` cleanup or latest source-only painter refactor and contracts.
- Current source/test/config blobs, re-fetched from the complete `main` tree:
  - `lib/main.dart`: `99bdf225b990fbe8a4ff92c224b4fccc4ae4624a`.
  - `lib/floating_monitor.dart`: `31b45ea08b08ac7fc25ebd991dca873b889fdd14`.
  - `lib/app_settings.dart`: `36927823c91904a35d87d2f21bd77932a2214e83`.
  - `test/widget_test.dart`: `2527fa278a56da30bf74eb488287580d0d2c99d8`.
  - `test/floating_monitor_layout_contract_test.dart`: `87e805095202ac3edfe55b9aeb3138c7c6886375`.
  - `test/v6_7_qc_contract_test.dart`: `6b71cc2ebbef9b3f1c9757728067eec4d11ff5ee`.
  - `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`.
  - `test/firmware_touch_adaptive_sync_test.dart`: `94c0f074247f47fce7d939a72b0130eb1b2d70fa`.
  - Native `FloatingMonitorService.kt`: `8312cc12d391cde5f76b146ff98075856d32bae2`; `MainActivity.kt`: `ef35590cfc91fafe5dec104b7cfd7828011185bf`; `AndroidManifest.xml`: `c374b5d3ad6448b8b3e99a420ed7e8c49d38497a`; `android/app/build.gradle`: `060cdd36a4f7d4d2fa4c97a1b6a15954b8355350`.
  - Active workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `8a8533aff7e0e0e01412bf522e1966e81aa1a39f`.
  - Current app configuration: `pubspec.yaml` `8f558273e21692af9958f914527fdc62d623d63a`; `pubspec.lock` `1e92812bfda2c28244a0556d71d1ec94084acc66`; `android/app/build.gradle` `060cdd36a4f7d4d2fa4c97a1b6a15954b8355350`; `android/gradle.properties` `aeb7ffd8c41e6c668c1eeb4e656755e5b1cc18f6`; `AndroidManifest.xml` `c374b5d3ad6448b8b3e99a420ed7e8c49d38497a`; `android/app/proguard-rules.pro` `50fc26f726ae8660fe04cf19da688431c8dca4a0`; `.github/workflows/jexfyz-app-build-trigger.yml` `8a8533aff7e0e0e01412bf522e1966e81aa1a39f`.
  - Firebase config file `android/app/google-services.json`: blob `f3ed065a7ee56b2a44f0a943a48fa578ba72e0d7`, 761 bytes. Only JSON structure was checked; no credential values are included in this transfer snapshot.
- Canonical docs immediately before this transfer-only commit:
  - `APP_BUILD_REPORT.md`: `0efea694062fe11173f2503c2fea334ffa71964b`.
  - `PROJECT_STATE.md`: `9cbaeb1a141160c22ae66de8f8a01c7a0c4e516b`.
  - `MEMORY_INDEX.md`: `c120d734661d324c10560151bd8a74de99f5631a`.
  - `BUILD_NOTES.md`: `63153acbd22e9e2d21bd6babce850b2d58face0b`.
  - `HANDOVER.md`: `0fd974bb7ddba319c7892aa5d082781ccc52e1f3`.
  - `APP_NOTES.md`: `f108bc14d89e45f802438c1b755dc5cb110227e7`.
  - `CHANGELOG.md`: `ef9ce4583ee81a37f833ddd2d0c5287d68de6f6f`.
  - `README.md`: `2388d472c767fdf0a45fca09fdb00e5db0e43ac4`.
  - `CHAT_RULES.md`: `3ec9a68447955d4f5e5e94e38ee1db36a412e07e`.
  - `FIRMWARE_NOTES.md`: `1b0897dc4ea11c6eb51324e691fb9637a118612f`.
  - `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `a9b40284a2fa9125e4d381fdd6b14708eab45daf`.
  - `OTA_PROTECTION.md`: `767364ed6c8afd87104f0348490a5afd245d2fe3`.
  - `OTA_REGRESSION_MEMORY.md`: `1eb7365d0e31cdb8ab06e4d63ce9d6f33ca7bba9`.
  - `VOLTAGE_TRANSITION_MEMORY.md`: `d29e9c480d4976086968967ed705cfee2357159b`.
  - `DESIGN_NOTES.md`: `c30e0d174a678a83224e3a62878a371e9b2f978c`.
  - `CHAT_TRANSFER_PROMPTS.md`: `64fc43d66a2f8df1a710fcdfecc02b4345ad7fa5`.
  - `android/app/proguard-rules.pro`: `50fc26f726ae8660fe04cf19da688431c8dca4a0` (obsolete FPS/Shizuku class keep rules removed; config-only cleanup).
  - `android/gradle.properties`: `aeb7ffd8c41e6c668c1eeb4e656755e5b1cc18f6` (replaced the stale FPS-parser test comment only; Gradle values were unchanged).

## 3A. TamperScreen warning/contact behavior — rounded text blocks included by Build #80; static Icon source-only

- The native signer-identity check and developer-contact behavior are unchanged. Build #80 includes all ten text blocks framed in consistent dark rounded boxes. The sole post-release follow-up replaces the generic glyph wrapper with a direct static Flutter `Icon` using the exact same warning glyph, size and color; all wording/order, text colors, typography, frame and contact action remain unchanged.
- Base warning/contact behavior and rounded text-box layout are included in Build #80 source marker `4e9f14b959cdbf60136158187db26d0bb65f6287`. The direct-Icon simplification and its test assertion are not in the current release. The refined Home indicator painter is also post-Build-80 and source-only.

## 3B. Home indicator motion, toggles and submenu locks — included by Build #80

- Hotside contour is one continuous tube-to-bulb silhouette; liquid fill/highlight is separate from the outer stroke. Animation policy is strict: Battery/Hotside/Voltage loop while BLE is connected (including unknown readings); Adaptive/Peltier/Fan/LED animate only while authoritative state is ON; Fan Speed has only smooth event-driven PWM transitions, not a phase loop; OFF outputs are static except a connected Fan's one-shot coast-down; Bluetooth is static. Post-Build-80 source refinement adds rotating Peltier snow with falling branched flakes, removes Adaptive's orbit dot, runs the Voltage current pulse along a closed lightning spine, puts curved airflow behind the Fan rotor, removes Fan Speed glint/wobble, and replaces Battery/Hotside dot embers with tapered flame tongues. Battery/LED moving highlights wrap beyond their clipped bounds to avoid visible jumps. Semantic color, temperature thresholds, BLE, controls and safety behavior are unchanged. This refinement is NOT BUILT or TESTED by Flutter in this task.
- Peltier, Adaptive and LED submenu toggles use neutral rows like Manual Voltage, omit the knob checkmark and adjacent ON/OFF label, and keep theme-primary toggle accent. BLE/Firmware state authority and command gating are unchanged.
- If Bluetooth is disconnected, the complete selected submenu is blurred/dimmed under one centered lock card; top-level tabs and Home Bluetooth remain usable. If connected but Adaptive is active/transitioning, only Voltage, Control and Temperature use the whole-menu blur and centered lock. Messages: CONNECT TO JE X FYZ FIRST / HUBUNGKAN KE JE X FYZ TERLEBIH DAHULU and LOCKED BY ADAPTIVE MODE / TERKUNCI OLEH MODE ADAPTIF.
- Build #80's 96/96 Flutter tests cover the source included in that release, including lock policy, centered overlay, toggle presentation, indicator contour/motion and thermal thresholds. Post-Build-80 direct-Icon and refined animation-painter contracts are NOT RUN; Flutter/Dart executables are unavailable here. No App Build was triggered in this `Eksekusi Full` task; physical rendering, BLE/device behavior and thermal performance remain unverified.
- Current fingerprints: lib/main.dart 99bdf225b990fbe8a4ff92c224b4fccc4ae4624a; test/widget_test.dart 2527fa278a56da30bf74eb488287580d0d2c99d8; lib/floating_monitor.dart 31b45ea08b08ac7fc25ebd991dca873b889fdd14; lib/app_settings.dart 36927823c91904a35d87d2f21bd77932a2214e83; MainActivity.kt ef35590cfc91fafe5dec104b7cfd7828011185bf.

## 4. Current Floating Monitor: FPS retired, F label is Fan/Kipas

- The user chose to remove FPS entirely after repeated F:-- and Shizuku UserService failures rather than continue speculative device-specific FPS fixes. This decision was implemented in Build #70 and is included in the current release.
- Exactly six metric IDs: B (Battery Temperature), H (Hotside Temperature), V (Voltage), A (Adaptive), P (Peltier), F (Fan Speed). F is labelled Fan/Kipas and its numeric value shows live fan speed, not FPS. Fan telemetry and Firmware speed control were not changed.
- Persisted schema v2 migrates legacy schema v1: old F (FPS) selections are discarded; old S (Speed/Fan Speed) migrates to F. This avoids interpreting a saved FPS setting as a Fan Speed value.
- FPS SurfaceFlinger/TimeStats sampler and watchdog/parser, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-specific tests, Shizuku-only Dart contract, and Shizuku-only notice/license files are removed. The active workflow audit guards against their reintroduction.
- Overlay contract: Letters-only (legacy Icons normalize to Letters), freely draggable with saved coordinates; horizontal metrics centered as a group, vertical rows share a left edge; size 0.30×–1.00× in 0.05× increments (default 0.60×); opacity 0–100% in 5% steps, current percent/endpoints, no midpoint; opacity affects background only. Fan on displays live speed, Fan off localized OFF/MATI, disconnected output is `--`.
- Build #80 verifies its exact source/release, including updated indicator animation/state-gating, rounded warning-page layout, toggles and submenu locks. It does not prove physical-phone rendering, BLE hardware connection or live Fan Speed telemetry; device check remains open.

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
- Build #71 introduced earlier eased phase-continuity/manual-voltage styling and is historical. Build #80 later released the Home motion/state-gating, toggle, menu-lock and rounded TamperScreen layout. The newest post-release UI delta is only the direct static-Icon warning simplification; source/test status is described in the current checkpoint above.
- **CI verified but not device verified:** Build #71 passed 88/88 Flutter tests and release gates for these changes. Physical animation smoothness, geometry and toggle appearance remain unverified on a phone.
- LED color picker uses 36 curated hue-ordered presets with localized names and no HEX UI. Swatches update local draft only; explicit Select sends confirmed COLOR, Cancel discards without BLE write. Existing LED mode IDs Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7 remain; mode 3/Mirror Pulse is retired.
- Approved printable JE X FYZ grille is exact symmetric 1:1 square, white geometric grille, purple central X, four corner holes, preserve pattern/frame. Flat 2D, no shadow/bevel/gradient/texture/invented elements. Transparent assets: `assets/jexfyzicon.png`, `assets/jexfyzcooler.png`, Android icon `android/app/src/main/res/drawable-nodpi/jexfyzicon.png`.

## 7. Active Firmware V6.7 and hardware baseline (user-reported compile/online update; not independently verified)

- Canonical active source: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; embedded `FW_VERSION="V6.7"`; exactly one active versioned `.ino`. On 2026-10-18 the user reported successful compilation and online update. This is USER-REPORTED; no build output, BIN identity, OTA log or current installed-device version was independently inspected.
- V6.6 compile/two-same-version-OTA statements are historical USER-REPORTED evidence. The V6.7 compile/online-update status is now separately USER-REPORTED; source-to-BIN provenance, current installed version, physical safety/thermal/LED behavior and full OTA apply/reboot/reconnect gates remain UNVERIFIED. No Firmware source or artifact was changed by the assistant in this App-layout task.
- ESP32-C3 has one radio path: Wi-Fi OTA and BLE may not own the radio concurrently; explicitly transfer ownership.
- Pin map: GPIO0 Hotside NTC ADC; GPIO1 TTP223 touch input; GPIO3 12 V selector; GPIO4 9 V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812.
- MOSFET wiring memory: GPIO → R100 → gate; 100 kΩ gate-source pull-down. Fan positive goes to supply (“Decoy” as written in user note); fan negative goes to MOSFET Drain. A prior 12 V selector problem was later traced to a loose cable, not established code defect; verify physical wiring before changing code.
- NTC: 10 kΩ nominal thermistor, 10 kΩ fixed divider, Beta 3950, 3.3 V reference assumption, calibrated analogReadMilliVolts(PIN_NTC). One sample per second, no median/trimmed mean/multi-sample averaging without explicit renewed approval. NTC invalid state fails safe (Peltier OFF, Fan 100%, Adaptive OFF and safe 5 V per current contract).
- Hotside limit range 40–50°C, default 45°C. Manual Peltier safety latch re-arms only after Hotside ≤ hotLimit−1°C continuously for five seconds; a single low sample must not bypass the latch.
- Peltier PWM is 20 kHz/8-bit, ordinary OFF→ON has 5 s soft-start; Fan PWM is 25 kHz/8-bit, manual target 50–100%, safety can force 100%. Selector break-before-make is 200 ms and shared rail guard/settle is 1 s. Use cooperative millis() timing; no executable delay() or timing while loops.
- Adaptive 12V Fan PWM: the 10-sample downshift gate remains conservative (all samples and average ≤ hotLimit−2°C, continuously stable 10 s, then −10 points at most every 10 s to a 50% floor). Upshift now requires four consecutive 1 Hz samples rising by ≥0.25°C overall with at least two rising intervals; +10 points at most once per 3 s. Failure to qualify for downshift alone holds current PWM. Hotside limit still forces 100%; 5V/9V retain 100%. The user reports V6.7 was compiled and updated online; that status is not independently verified and does not establish source-to-BIN provenance or physical behavior.
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

## 10. Canonical memory inventory and live blob hashes at the parent snapshot

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
- `APP_BUILD_REPORT.md`: `efe84c67d8b2df27bd9694f2e71f613b16a1a450`.
- `PROJECT_STATE.md`: `c9b1be5a500f24eb77df9f36ba927abe6937d77b`.
- `MEMORY_INDEX.md`: `96d05826fc9cbbb1b3f4c70935d5777278138446`.
- `BUILD_NOTES.md`: `f211ef98aabc641e85efde4fc43c71fc6d6aacd7`.
- `HANDOVER.md`: `11e50c36e5662e56c89921b0523cea57a7e1fba9`.
- `APP_NOTES.md`: `29a1d14c19d28fd38a18084b229045b8f3fba9f6`.
- `CHANGELOG.md`: `05c0ec7b97dfc890ab1008b2c3ad8a1a8c3e614e`.
- `README.md`: `9aa587a005035a859c93764d08a195d105c54278`.
- `CHAT_RULES.md`: `51e878baa0a775c44444da2771f4fec2533d25c6`.
- `FIRMWARE_NOTES.md`: `9e128e88ff836230b55c906065765ba944668bf6`.
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `6fa16e938e200b4f279cf7f05c013dee12f5675a`.
- `OTA_PROTECTION.md`: `767364ed6c8afd87104f0348490a5afd245d2fe3`.
- `OTA_REGRESSION_MEMORY.md`: `1eb7365d0e31cdb8ab06e4d63ce9d6f33ca7bba9`.
- `VOLTAGE_TRANSITION_MEMORY.md`: `d61828c7de7efeefd8e1f79cc3f41b625541d62a`.
- `DESIGN_NOTES.md`: `c30e0d174a678a83224e3a62878a371e9b2f978c`.
- `CHAT_TRANSFER_PROMPTS.md`: `64fc43d66a2f8df1a710fcdfecc02b4345ad7fa5`.
- `.github/workflows/jexfyz-app-build-trigger.yml`: `8a8533aff7e0e0e01412bf522e1966e81aa1a39f`.
- This file is being committed last; do not embed its own future hash.

## 11. Evidence labels and exact next actions

- **CURRENT / VERIFIED:** Build #80 / run `39171729285` passed 96/96 Flutter tests and all 21 active workflow steps. Release `jexfyz-latest` targets exact source `4e9f14b959cdbf60136158187db26d0bb65f6287`.
- **LATEST VERIFIED RELEASE (Build #80):** includes rounded TamperScreen text blocks and current Home indicator motion/state-gating, toggle styling and submenu locks.
- **CURRENT SOURCE ONLY / NOT BUILT / NOT RUN:** only the direct static `Icon` warning glyph cleanup and its new widget-test assertions, after Build #80. Flutter/Dart tests and analysis were not run for this last delta.
- **TEST CAVEAT:** the configured Gradle unit-test gate passed in Build #80, but native JUnit compilation/testing was NO-SOURCE; no native JUnit cases ran.
- **NOT DEVICE-VERIFIED:** phone-side icon/animation smoothness, toggle appearance, overlay geometry, live BLE/Fan Speed telemetry, BLE pairing exclusivity, Firmware thermal/LED behavior, source-to-BIN provenance and end-to-end OTA/reboot/installed version.
- **HISTORICAL / SUPERSEDED:** Build #70 and earlier release details, FPS/Shizuku code/results, older Firmware snapshots and archive CURRENT claims. Full build attempt history is in `APP_BUILD_REPORT.md`.
- **HISTORICAL USER-REPORTED:** V6.6 compile/two-same-version-OTA statements remain historical. V6.7 has a separate user-reported compile/online-update success, not independently verified; current device version, binary/source identity and physical behavior remain UNVERIFIED.
- **Immediate next step:** to put the latest direct-Icon cleanup in a distributable APK and rerun tests/analyze/signing/release verification, use the separate `@Thinking Eksekusi Build App!` authorization. Build #80 does not contain this tiny final cleanup.
- For a new functional source change, use `@Thinking Diskusi!` then `@Thinking Eksekusi Full!` for approved source/tests/docs and separately `@Thinking Eksekusi Build App!` for CI/release. `@Thinking Chat Stuck!` only resumes the last authorized task and never expands permission.
- Current workflow is `.github/workflows/jexfyz-app-build-trigger.yml`, blob `8a8533aff7e0e0e01412bf522e1966e81aa1a39f`; event gate is issues opened/reopened only, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`, repository-owner guard retained. No workflow file was changed and no Build App trigger was emitted in this task.
- All durable current notes route through `MEMORY_INDEX.md`: source/build evidence via `APP_BUILD_REPORT.md`/`BUILD_NOTES.md`; current project truth via `PROJECT_STATE.md`; app UI/protocol via `APP_NOTES.md`; hardware/Firmware via `FIRMWARE_NOTES.md` and `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`; OTA via `OTA_PROTECTION.md`/`OTA_REGRESSION_MEMORY.md`; transition rules via `VOLTAGE_TRANSITION_MEMORY.md`; approved visual contracts via `DESIGN_NOTES.md`; permanent authorization through `CHAT_RULES.md`. Archive snapshots are immutable forensic history.
- At the earlier project-memory reconciliation, the change was documentation plus two config-only files: `android/app/proguard-rules.pro` removed keep rules for already-retired FPS/Shizuku classes, and `android/gradle.properties` had a stale FPS-parser test comment corrected (no Gradle values changed). In this task, only `lib/main.dart`, `test/widget_test.dart` and project documentation/memory files changed. No Firmware source/BIN, Firebase, OTA, flash or device action occurred.
- Build #80 remains the latest verified APK; physical-device checks remain pending. The latest source delta after Build #80 is the static warning-Icon simplification plus its regression assertion. No App Build or Firmware/BIN/Firebase/OTA/flash/device operations were performed by this task.

