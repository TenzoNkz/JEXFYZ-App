Current-state summary synchronized from live GitHub on 2026-10-19 (Asia/Jakarta). The execution baseline was main HEAD `8ffcabb6668f0a095eabb0d0e051520fcae29310`; final post-write HEAD/tree and exact changed blob SHAs are recorded in `CHAT_TRANSFER.md`. This file is current state, not the build-history ledger; use `APP_BUILD_REPORT.md` for exact run evidence and `CHANGELOG.md` for history.

Current state refreshed against live main on 2026-10-19 (Asia/Jakarta). Pre-rework release baseline is Build #92, source `6610fecb3e47d9941cbf96043b7da3b2a869753b`; this source-only icon follow-up is newer and NOT RUN / NOT RELEASED. The final `CHAT_TRANSFER.md` records exact final HEAD/tree/blob hashes. Use `APP_BUILD_REPORT.md` for authoritative build evidence and `CHANGELOG.md` for history.

Last fully audited from live GitHub on 2026-10-19 (Asia/Jakarta), beginning at main HEAD/tree `e224c5e1d3e86def06a5b97b0111a6e9c33e979a` (67 entries; recursive tree not truncated). This is the current-state file, not the build-history ledger. `CHAT_TRANSFER.md` records the later pre-transfer parent snapshot; use `APP_BUILD_REPORT.md` for exact run evidence and `CHANGELOG.md` for superseded decisions.

## Current App / Release state — Build #92 verified; seven-icon follow-up is NOT RELEASED

- Canonical repo: `TenzoNkz/JEXFYZ-App`, branch `main`. Source-only icon rework baseline begins at Build #92 source commit `6610fecb3e47d9941cbf96043b7da3b2a869753b`; exact final current HEAD/tree and hashes are recorded in `CHAT_TRANSFER.md`.
- Latest successful App artifact is **Build #92** / [Actions run `39211726896`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39211726896). All 21 workflow steps passed; **98/98 Flutter tests passed**, analyzer had 23 info-level deprecation findings, configured Android gate, obfuscated APK, V1/V2/V3 production-signature/certificate checks, source ZIP, downloaded assets, and Release/tag/source consistency passed. Native JUnit tasks were NO-SOURCE.
- Build #92 APK asset `655482761`, SHA-256 `ee3ce9cb9697b8bcabf4da829fc64c16524bbe914eb83901f5d21c855d706926`; corresponding source ZIP asset `655482764`, SHA-256 `7ec969d092638790dd36b5d71c758b68cdc11a0e8db2bdfb390c812f541e677a`.
- **Current source-only follow-up:** battery/Hotside warning effects now use falling ember particles and thermal glow; Fan rotor is three broad blades; Voltage, Adaptive, Peltier and Fan Speed receive consistent luminous-core detail while retaining their existing motion/state/telemetry rules. New tests were added/updated to assert falling fire and three-blade geometry.
- These changes are **NOT RUN / NOT RELEASED**. No analyzer/test/build or physical-device validation was performed in this scope. Do not report Build #92's 98/98 test result as validation of this newer commit. Build #92 remains the latest successful artifact for its exact historical source.
- Workflow remains guarded to its official issue-event/title/token path; no workflow changes or Build App operations were performed. Keep Android Gradle `versionName "Telegram @horizontalzzz"` unchanged.

## Current source fingerprints

- `lib/main.dart`: `18f0a4d11948c7d584e8eeff5fd88eb6230d17e8` (seven-icon animation rework; NOT RUN / NOT RELEASED).
- `lib/jex_animated_glyph.dart`: `b37fc4e0807c874b2f01db00c7f606810cb5deca` (static generic action/settings glyphs).
- `test/widget_test.dart`: `d4a4006fd74b9e4a348b1ddcac1ae31a043a1b53` (falling-fire and three-blade contracts; NOT RUN).
- Other active Dart test paths remain `test/floating_monitor_layout_contract_test.dart`, `test/v6_7_qc_contract_test.dart`, `test/app_protocol_notify_contract_test.dart`, and `test/firmware_touch_adaptive_sync_test.dart`.
- App config remains pubspec `1.0.0+3`, applicationId `com.horizontalzzz.jexfyz`, minSdk 24, targetSdk 36, compileSdk 37. Preserve Gradle `versionName "Telegram @horizontalzzz"`.

## Current approved icon animation rules

- Battery/Hotside: anchored flame tongues during connected warning state plus three embers falling downward within the shape and fading smoothly, in the same direction family as Peltier snow. Existing thermal thresholds/colours and firmware safety are unchanged.
- Voltage: illuminated bolt with closed-spine pulse and staggered internal strikes; semantic colours remain 5V red, 9V green, 12V blue.
- Adaptive: two opposite arrows on circular arcs; only authoritative active state rotates the arcs.
- Peltier: six-branch crystal with falling snowflakes behind it; existing intensity/state gating stays intact.
- Fan: three-blade rotor, shared subtle glow, same voltage/PWM timing policy and fixed three airflow ribbons.
- Fan Speed: upper-half gauge, smooth PWM retarget, hidden needle for unknown/disconnected values.
- BLE disconnect stops/resets custom animation controllers. Floating Monitor remains compact B/H/V/A/P/F labels; no values are fabricated. Physical display, real BLE/PWM and cooling/safety remain UNVERIFIED.


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
