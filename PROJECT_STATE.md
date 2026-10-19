# JE X FYZ / JE Cooler — Current Project State

Current state reconciled against live GitHub main on 2026-10-19 (Asia/Jakarta). Build #100 remains the latest successful release; the newer bilingual Home NOTIFY copy/layout changes are source-only, NOT RUN / NOT RELEASED. APP_BUILD_REPORT.md owns build evidence; CHAT_TRANSFER.md is the final handoff snapshot.

## Current App / Release state — Build #100 verified; notification copy follow-up is NOT RELEASED

- Canonical repo: TenzoNkz/JEXFYZ-App, branch main. Baseline before this source update was HEAD 27f1b572af2db8c73d325defed196086207649c8; the copy/test update is now committed on main after Build #100.
- Latest successful release is Build #100 / https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39237262140, source 51bea70b2ca17f285bf35c3e547dc44c70f26d59. All 21 workflow steps passed; 103/103 Flutter tests passed; analyzer exited 0 with 25 info-level findings and no errors/warnings; configured Android gate, APK signature/certificate, source ZIP integrity and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- Build #100 APK ID 655957943, 54,718,555 bytes, SHA-256 a59c0a37b2025ad2b250bd4354b887379d96658e9f7757692691fa23b7b4d0a2. Source ZIP ID 655957946, 2,862,476 bytes, SHA-256 e60c4705097009d843b624bf8f0f989770a76aba6fdfbdd8d2159d77f98890f1.
- Current Home STATUS/NOTIFY copy and layout follow-up is source-only / NOT RUN / NOT RELEASED. Blobs: `lib/main.dart` `5282fb226c818b8f4601ec89953c0c47ff4861e9`; `lib/app_settings.dart` `562e42c4dc1ee2ac0c15b3f7211e55fa7b11bac6`; `test/widget_test.dart` `0ebbf0cd03f041a44afa314d66b77278e26c646e`.
- The card removes the separate connection badge, retains the localized `NOTIFY • category` heading, centers the message, and supports natural one/two-line display at readable font size. Copy maps known safety reasons, hides raw internal/OTA identifiers, and polishes bilingual command/copy. OTA raw envelopes are routed to the dedicated localized formatter. Tests/analyzer have not run; Build #100 does not include these changes.
- Do not change the guarded Build App workflow. A separate @Thinking Eksekusi Build App! is required to validate/release this source. Firmware V6.7, BIN, Firebase, OTA, flash and physical hardware are untouched.

## Current source fingerprints

- `lib/main.dart`: `5282fb226c818b8f4601ec89953c0c47ff4861e9` — current Notify copy/layout changes, including centered responsive card and OTA message routing; NOT RUN / NOT RELEASED.
- `lib/app_settings.dart`: `562e42c4dc1ee2ac0c15b3f7211e55fa7b11bac6` — polished bilingual connection/OTA copy; NOT RUN / NOT RELEASED.
- `test/widget_test.dart`: `0ebbf0cd03f041a44afa314d66b77278e26c646e` — updated bilingual copy expectations and new Notify layout/source contracts; NOT RUN.
- `lib/jex_animated_glyph.dart`: `b37fc4e0807c874b2f01db00c7f606810cb5deca` — generic navigation/settings/action glyphs remain static.
- Existing independent contract tests remain test/floating_monitor_layout_contract_test.dart, test/v6_7_qc_contract_test.dart, test/app_protocol_notify_contract_test.dart and test/firmware_touch_adaptive_sync_test.dart.
- App config: pubspec 1.0.0+3, applicationId com.horizontalzzz.jexfyz, minSdk 24, targetSdk 36, compileSdk 37.

## Current approved seven-icon rules and static-state redraw

- Battery Temperature: recessed inner window and small neutral thermal emblem in unknown state; valid temperature uses existing mapped presentation and falling fire/warning follows the existing predicates.
- Hotside Temperature: continuous tube-and-bulb contour, dark recessed tube, fixed scale graduations and bulb bezel even when unknown; live column only when data is valid.
- Voltage: recessed shadowed bolt and inner luminous face; travelling current and staggered branches remain active-state gated. Colours remain 5V red, 9V green, 12V blue.
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

## Current Firmware / hardware status — V6.7 user-reported

- One active versioned sketch: `firmware/JEXFYZ-V6.7.ino`, live blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`, embedded `FW_VERSION = "V6.7"`. On 2026-10-18 the user reported successful compilation and online update. This is **USER-REPORTED** only: compile output, generated BIN identity, OTA logs and current installed-device version were not independently inspected. V6.6 compile/OTA reports are historical.
- MCU: ESP32-C3 Super Mini / ESP32-C3 Dev Module, 3.3 V logic. Pin map: GPIO0 NTC ADC; GPIO1 TTP223 touch; GPIO3 12 V selector; GPIO4 9 V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. Wiring memory: GPIO → R100 → gate, 100 kΩ gate-source pull-down; Fan positive to supply, negative to MOSFET drain. A previous apparent 12 V issue was traced to a loose cable; don't assert a code fault without evidence.
- NTC: 10 kΩ nominal thermistor, 10 kΩ fixed divider, Beta 3950, 3.3 V reference assumption, calibrated `analogReadMilliVolts(PIN_NTC)` once per second. The user explicitly rejected median/trimmed/multi-sample NTC filtering; do not add it without renewed approval.
- PWM/timing: Peltier 20 kHz/8-bit, normal OFF→ON soft-start 5 s; Fan 25 kHz/8-bit, manual target 50–100%. Selector break-before-make 200 ms, shared rail settle 1 s. Use cooperative `millis()`; no executable `delay()` or timing `while()`.
- Hotside configurable limit 40–50°C (default 45°C). Manual Peltier safety latch rearms only at/below `hotLimit - 1°C` continuously for 5 s. Invalid NTC fails safe: Peltier OFF, Fan 100%, Adaptive OFF and safe 5 V according to current source.
- Adaptive starts in HOTSIDE by default. HOTSIDE_BATTERY is runtime-selectable, not persisted; App sends `PHONE:BT=<Celsius>` at 1 Hz and Firmware freshness TTL is 5 s. Adaptive runs a 30 s thermal stage at 12/9/5 V with Peltier OFF/Fan 100%; 5 continuous seconds at/below `hotLimit - 1°C` before expiry cancels recovery, otherwise voltage steps down and an unrecovered 5 V state terminal-locks. Upward recovery occurs one rail at a time after 60 s stable, capped by the saved ceiling.
- Adaptive 12 V Fan PWM downshift: ten fresh one-second NTC samples, every sample and rolling average ≤ `hotLimit - 2°C`, no warming trend, continuous 10 s stable window, then -10 points at most every 10 s down to 50%. Upshift: four readings spanning ≥0.25°C net rise, with at least two of three intervals rising; +10 points no more often than each 3 s. A failed downshift gate alone holds present PWM. Hotside limit forces 100%; 5/9 V stay at 100%.
- Historical/unimplemented: a separate rapid Hotside rate-of-rise shutdown with manual re-arm was requested but is **NOT IMPLEMENTED** in the known V6.x contract. Two reported reset situations (5→12 V during active soft-start; Adaptive ON after selecting 12 V with outputs on) have no captured reset reason; brownout/supply transient is a **HYPOTHESIS**, not a finding. Initial-boot white Adaptive-OFF three-blink feedback was reported missing; physical behavior remains unverified.

## Current App UI, BLE and Floating Monitor contract

- App name JE Cooler, header JE X FYZ. UI direction based on Horizon Cooler: dark header, white rounded content panel, compact cards, cooler image right; main VOLTAGE/ADAPTIVE tabs and menu hierarchy VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE.
- Home semantic colors: Battery Ice Blue ≤30°C, cyan/amber/orange transition 30–40°C, red at ≥40°C with tapered flame tongues; Hotside Ice Blue ≤30°C and red/flame at configured Hotside limit. Voltage labels: 5 V red, 9 V green, 12 V blue. Disconnect shows unknown `--`, never stale output telemetry or black/grey semantic fallback. Do not display a standalone Battery Protection Guard badge.
- Dashboard effects are integrated 2D silhouettes. Peltier: rotating six-branch snow crystal with falling branched snowflakes behind; Adaptive: two arcs/arrowheads with no orbit dot; Voltage: current pulse along closed lightning spine; Fan: curved airflow behind blades with no right-side air lines; Fan Speed: stable gauge and live-PWM retarget only, no looping glint/wobble; Battery/Hotside: tapered red/orange/yellow flame tongues. Bluetooth icon remains static. Peltier/Adaptive/LED toggles use neutral rows with theme-primary knob, no knob checkmark or adjacent ON/OFF text.
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
