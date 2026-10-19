# JE X FYZ / JE Cooler — Current Project State

Current state reconciled against live GitHub main on 2026-10-19 (Asia/Jakarta). Build #106 is the latest successful release; the newer left-aligned Home NOTIFY layout and Battery/Hotside/Voltage animation redesign are source-only, NOT RUN / NOT RELEASED. APP_BUILD_REPORT.md owns build evidence; CHAT_TRANSFER.md is the final handoff snapshot.

## Current App / Release state — Build #106 verified; current UI follow-up is NOT RELEASED

- Canonical repo: TenzoNkz/JEXFYZ-App, branch main. Current UI edits are committed directly to main after Build #106 and remain NOT RUN / NOT RELEASED. No branch or PR was created.
- Latest successful release is Build #106 / Actions run 39279938461, source `9f90cf6063ee7786613f8b5dfa1c6b0412d89638`. Analyzer exited 0 with 25 info findings and no errors/warnings; 108 Flutter tests passed; the configured Android gate, APK signature/certificate, source archive integrity and downloaded Release-asset checks passed.
- Build #106 APK asset ID `656702702`, 54,734,939 bytes, SHA-256 `bab332a4312c628178e384a88d513cf8546ff15ab4b4e3f3becf2e70b10830cc`; source ZIP asset ID `656702729`, 2,866,720 bytes, SHA-256 `0bb86c4e6bd7d3cb7a6bb894658bd707acee48bac106fc5227f8adcba584ec98`.
- Current source is newer than Build #106 and NOT RUN / NOT RELEASED: `lib/main.dart` `7e09a3d28b4efe24bdced858db4274cf70806284`; `lib/app_settings.dart` `8f228000d38d73038c06f569c052b1af601288a5`; `test/widget_test.dart` `5a82cf79e6c5c40fc34489ce90cf1200cf9faccb`.
- Current NOTIFY retains localized `NOTIFY • category`, left-aligns its heading/body, removes the separate connection badge, and wraps long copy to at most two lines. Battery/Hotside use clipped oval ember bursts instead of animated tapered flames/teardrops; Voltage uses edge-following pulses instead of a moving central spine/inner strikes. OTA diagnostics remain sanitized. Tests/analyzer have NOT RUN for the current source; Build #106 does not include these changes.
- The guarded App Build workflow is unchanged. The App UI follow-up remains unvalidated as documented above. Active Firmware source is now V6.8 for Adaptive Fan temperature-tier control; its source contracts are not run and V6.8 is not compiled or installed. No BIN artifact, Firebase state, OTA, flashing, or hardware was operated.

## Current source fingerprints

- `lib/main.dart`: `7e09a3d28b4efe24bdced858db4274cf70806284` — oval thermal bursts, outer-bolt edge pulses, left-aligned responsive NOTIFY; NOT RUN / NOT RELEASED.
- `lib/app_settings.dart`: `8f228000d38d73038c06f569c052b1af601288a5` — bilingual connection/OTA copy; unchanged in this UI pass.
- `test/widget_test.dart`: `5a82cf79e6c5c40fc34489ce90cf1200cf9faccb` — regression contracts for oval thermal bursts, Voltage edge pulses, and left-aligned badge-free NOTIFY; NOT RUN.
- `lib/jex_animated_glyph.dart`: `b37fc4e0807c874b2f01db00c7f606810cb5deca` — generic navigation/settings/action glyphs remain static.
- Existing independent contract tests remain test/floating_monitor_layout_contract_test.dart, test/firmware_qc_contract_test.dart, test/app_protocol_notify_contract_test.dart and test/firmware_touch_adaptive_sync_test.dart.
- App config: pubspec 1.0.0+3, applicationId com.horizontalzzz.jexfyz, minSdk 24, targetSdk 36, compileSdk 37.

## Current approved seven-icon rules and static-state redraw

- Battery Temperature: recessed chamber and neutral unknown-state emblem; at the unchanged ≥40°C warning threshold, show clipped rounded oval ember bursts with orange bodies and bright yellow-white cores. No animated tapered flames or falling tear-drops.
- Hotside Temperature: continuous tube/bulb, recessed tube and fixed graduations in unknown state; at the configured Hotside Limit, show taller clipped oval ember bursts. Threshold and firmware safety predicate stay unchanged.
- Voltage: recessed bolt and static inner luminous core with two phase-offset pulses running along the outer contour only. No moving central spine or inner strikes. Colours remain 5V red, 9V green, 12V blue.
- Adaptive: strong dual circular arrows and recessed orbit track in every state; rotation only while authoritatively ON.
- Peltier: stronger beveled six-branch crystal and faceted core; falling snow appears only while the existing active-state rule permits it, not as frozen stray particles in disconnected/OFF poses.
- Fan: exactly three swept blades, three fixed airflow ribbons, recessed bearing ring, per-blade highlights and hub; existing voltage/PWM mapping and integrated phase retarget remain.
- Fan Speed: semicircle with recessed bezel, 11 graded scale ticks and layered pivot. Needle appears only for valid authoritative PWM.
- Unknown telemetry never becomes fabricated OFF/zero status. Floating Monitor stays B/H/V/A/P/F; no BLE, controls, Firmware or safety semantics change.



## Repository topology and roles

- At the last complete recursive tree fetch, the App repo had 67 entries (49 blobs / 18 trees), five branches and zero open PRs. Re-fetch before relying on these counts in a later task.
- `TenzoNkz/JEXFYZ-App` owns editable App/Firmware source, tests, build workflow, all notes, memory and changelog.
- `TenzoNkz/JEXFYZ-Firmware` is BIN-only. Its live recursive tree currently contains exactly `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only repository tree metadata was checked; BIN payload was not read or changed. Source-to-BIN provenance remains **UNVERIFIED**.
- Archive snapshots under `archive/` are immutable forensic history. Archived “CURRENT” language never overrides live main.

## Current Firmware / hardware status — V6.8 source updated; compile unverified

- Exactly one active versioned sketch is intended: `firmware/JEXFYZ-V6.8.ino`, blob `4f8011337fc3c9e3f1ace717fbd7179e1331bff8`, embedded `FW_VERSION = "V6.8"`. The source-only change replaces Adaptive 12 V Fan PWM trend/stability logic with deterministic Hotside-limit temperature tiers. It has NOT been compiled or installed; source-to-BIN identity, OTA logs and current installed-device version remain UNVERIFIED. V6.7 compile/online update is a historical user-reported result only.
- MCU: ESP32-C3 Super Mini / ESP32-C3 Dev Module, 3.3 V logic. Pin map: GPIO0 NTC ADC; GPIO1 TTP223 touch; GPIO3 12 V selector; GPIO4 9 V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. Wiring memory: GPIO → R100 → gate, 100 kΩ gate-source pull-down; Fan positive to supply, negative to MOSFET drain. A previous apparent 12 V issue was traced to a loose cable; don't assert a code fault without evidence.
- NTC: 10 kΩ nominal thermistor, 10 kΩ fixed divider, Beta 3950, 3.3 V reference assumption, calibrated `analogReadMilliVolts(PIN_NTC)` once per second. The user explicitly rejected median/trimmed/multi-sample NTC filtering; do not add it without renewed approval.
- PWM/timing: Peltier 20 kHz/8-bit, normal OFF→ON soft-start 5 s; Fan 25 kHz/8-bit, manual target 50–100%. Selector break-before-make 200 ms, shared rail settle 1 s. Use cooperative `millis()`; no executable `delay()` or timing `while()`.
- Hotside configurable limit 40–50°C (default 45°C). Manual Peltier safety latch rearms only at/below `hotLimit - 1°C` continuously for 5 s. Invalid NTC fails safe: Peltier OFF, Fan 100%, Adaptive OFF and safe 5 V according to current source.
- Adaptive starts in HOTSIDE by default. HOTSIDE_BATTERY is runtime-selectable, not persisted; App sends `PHONE:BT=<Celsius>` at 1 Hz and Firmware freshness TTL is 5 s. Adaptive runs a 30 s thermal stage at 12/9/5 V with Peltier OFF/Fan 100%; 5 continuous seconds at/below `hotLimit - 1°C` before expiry cancels recovery, otherwise voltage steps down and an unrecovered 5 V state terminal-locks. Upward recovery occurs one rail at a time after 60 s stable, capped by the saved ceiling.
- Adaptive 12 V Fan PWM (V6.8): direct target by `delta = hotLimit - hotsideC`: delta ≤1°C →100%; 2°C →90%; 3°C →80%; 4°C →70%; 5°C →60%; delta ≥6°C →50%. Fractional readings select the nearest whole-degree tier using boundaries at 1.5/2.5/3.5/4.5/5.5°C; no trend gate, timed dwell or additional hysteresis. Hotside limit/protection forces 100%; Adaptive 5/9 V remains at 100%. Current source/test contracts are unrun and V6.8 is not compiled.
- Historical/unimplemented: a separate rapid Hotside rate-of-rise shutdown with manual re-arm was requested but is **NOT IMPLEMENTED** in the known V6.x contract. Two reported reset situations (5→12 V during active soft-start; Adaptive ON after selecting 12 V with outputs on) have no captured reset reason; brownout/supply transient is a **HYPOTHESIS**, not a finding. Initial-boot white Adaptive-OFF three-blink feedback was reported missing; physical behavior remains unverified.

## Current App UI, BLE and Floating Monitor contract

- App name JE Cooler, header JE X FYZ. UI direction based on Horizon Cooler: dark header, white rounded content panel, compact cards, cooler image right; main VOLTAGE/ADAPTIVE tabs and menu hierarchy VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE.
- Home semantic colors: Battery Ice Blue ≤30°C, cyan/amber/orange transition 30–40°C, red at ≥40°C with oval ember bursts; Hotside Ice Blue ≤30°C and red/oval bursts at the configured Hotside limit. Voltage labels remain 5 V red, 9 V green, 12 V blue. Disconnect shows unknown `--`, never stale output telemetry or black/grey semantic fallback. Do not display a standalone Battery Protection Guard badge.
- Dashboard effects are integrated 2D silhouettes. Battery/Hotside use clipped oval ember bursts; Voltage uses edge-following pulses and a static inner core; Peltier retains the rotating six-branch snow crystal/falling snow; Adaptive retains two arcs/arrowheads; Fan retains fixed airflow behind blades; Fan Speed remains an event-driven live-PWM gauge. Bluetooth stays static. NOTIFY is left-aligned, with no CONNECTED/DISCONNECTED badge. Peltier/Adaptive/LED toggles keep neutral rows with a theme-primary knob and no checkmark or adjacent ON/OFF text.
- Animation gates: disconnected BLE stops/resets custom animation controllers; Battery/Hotside/Voltage loop while connected even if the reading is unknown; Adaptive/Peltier/Fan/LED animate only when authoritative state is ON; Fan Speed is event-driven; OFF outputs rest in a fixed-colour pose except the one-shot connected Fan coast-down. Visuals must not invent physical state/RPM.
- BLE only has one Flutter/GATT client (`flutter_blue_plus`); native foreground service supports active session and is not a second client. P1 readiness required. Service UUID `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`; RX `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`; TX `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`. ACK is not proof of physical rail/state; await authoritative telemetry. Auto Connect is passive and requires known identity and OS prerequisites. Encrypted/bonded writes exist, but the one-App/one-cooler exclusive pairing lock remains a **design requirement, not proven implementation**.
- Floating Monitor has six metrics B/H/V/A/P/F; F is Fan/Kipas speed, FPS/Shizuku was retired. Schema v2 discards legacy F=FPS and maps old S=Speed to F. Letters-only, draggable with saved coordinates; size 0.30×–1.00× in 0.05× steps (default 0.60×); opacity 0–100% by 5%, background-only; horizontal metrics centered, vertical rows left-aligned.
- LED modes/IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. ID 3/Mirror Pulse retired, old values migrate to Static and MODE:3 rejected. `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` is atomic; preview interpolates from a monotonic local clock and corrects later snapshots without restarting.
- Color Picker: 36 hue-ordered presets, no HEX labels; swatches update draft only, Select sends confirmed COLOR, Cancel discards without BLE write; outside tap/system Back blocked. Localized EN/ID, no raw protocol tokens to user.
- TamperScreen: native signer-identity check, error screen copy stays intentionally opaque, rounded boxes and direct static warning Icon; contact action opens the existing Telegram developer link through native channel. This is a signing-identity gate, not universal tamper detection.
- Android notification: monochrome white JE alpha silhouette; title JE X FYZ and localized body. Keep package/application/build constraints above.

## Protected OTA, build and security boundaries

- OTA is PROTECTED/FROZEN. Read `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md` before any OTA change; read `VOLTAGE_TRANSITION_MEMORY.md` before rail/Peltier timing. Local OTA: 10 s no-client SoftAP timeout, 60 s interaction hard cap; Wi-Fi is shut down and settles 160 ms before BLE takes ESP32-C3 radio. OTA safe outputs are mandatory.
- Online OTA currently uses `cloudClient.setInsecure()`, bypassing HTTPS server-certificate identity validation. CA PEM and OTA-only NTP/TIME_SYNCING gates were removed together after a user-reported blue-on-Wi-Fi then red-at-GitHub symptom; exact root cause was not isolated. Do not infer HTTP/TLS diagnosis from LEDs or silently restore CA/NTP. Keep raw GitHub BIN allowlist, redirects disabled, HTTP/length/size/image magic `0xE9`, streaming Update lifecycle, safe outputs and recovery. Firebase OTA metadata remains firmware version + link; no custom SHA/signature field without approval.
- OTA App order: `OTAENTER`, `SSID`, `PASS`, `URL`, `VERSION`, `CLOUDOTA`; arm expected disconnect recovery before CLOUDOTA, treat TIMEOUT/DISCONNECTED ACK as ambiguous, and require reconnect/P1 sync plus result before completion.
- App Build authorization is only `@Thinking Eksekusi Build App!`; `@Thinking Eksekusi Full!` does not build/release. The issue title/token and workflow above must remain guarded; do not add push/PR bypasses. No Firmware compile/BIN/Firebase/OTA/flash/device operation without separate explicit authorization. User compiles Firmware. Keep the signing secret contents private.

## Canonical routing and next action

- Current only-truth file: this `PROJECT_STATE.md`. Build history/results and stale-tag details: `APP_BUILD_REPORT.md`. Decisions/failures history: `CHANGELOG.md`. Paths: `MEMORY_INDEX.md`. Authorization: `CHAT_RULES.md`.
- Subject detail: App/UI/BLE `APP_NOTES.md`; hardware/Firmware `FIRMWARE_NOTES.md` and `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`; OTA `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md`; rail/Peltier `VOLTAGE_TRANSITION_MEMORY.md`; visual approvals `DESIGN_NOTES.md`; build procedures `BUILD_NOTES.md`.
- No current App Build has exercised the tag-ref workflow repair. Next authorized step is `@Thinking Eksekusi Build App!`; verify a new official issue-trigger run starts, all gates pass, `refs/tags/jexfyz-latest == run.head_sha`, Release metadata, APK/source ZIP digests and embedded source marker match, then independently re-fetch tag and artifacts. Until then, overall release handoff stays BLOCKED.
