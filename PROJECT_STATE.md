# JE X FYZ / JE Cooler — Current Project State

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #124 / run 39386733061 is the latest verified App release on packaged source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a and includes Wi-Fi password visibility. Current Firmware V7.1 is a later source-only change and has NOT been compiled/deployed. User-reported V7.0 compile/Online OTA success does not validate V7.1.

## Latest execution checkpoint — 2026-10-20 (Firmware V7.1 source-only)

- Latest verified App release: Build #124 / run `39386733061`, source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`; APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`; source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`. Build #124 includes Wi-Fi password Show/Hide and passed 116 Flutter tests/configured App gates.
- Firmware V7.1 Adaptive Fan bands use 2°C whole-degree categories relative to configured limit. At 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%.
- Source `firmware/JEXFYZ-V7.1.ino` blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`; QC `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync `7c203a11f79de62744af8536bbf2e3219d7f0909`. Static mapping/source markers were reviewed; contract tests and Arduino compile have NOT RUN.
- Prior V7.0 compile/Online OTA is USER-REPORTED only for the earlier revision. No V7.1 BIN/Firebase/OTA/flash/device operation occurred. BLE App-only authorization remains BLOCKED; OTA stays protected and unchanged.

## Home NOTIFY — single latest-event message (validated in App Build #124)

- Packaged blobs: `lib/main.dart` `2d44e1f1f5b88ca1dae8324082da751b6ef1485a`; `lib/app_settings.dart` `637c07be55c412451d9ffde762e080c8bd92fd5e`; `test/widget_test.dart` `90e1a582c49ce3ad1a1d9a3b875921098eaf2545`.
- Home NOTIFY presents one complete sentence for the newest confirmed event; repeated telemetry creates no new event. Ordinary Temperature samples do not notify. Hotside at its configured limit gets safety-priority copy with measured temperature and limit in English/Indonesian.
- Build #124 passed 116 Flutter tests and configured release gates. App CI does not validate Firmware V7.1 or physical thermal behavior.

## Current App / Release state

- Latest verified App release is Build #124 / run `39386733061`, packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`; the `jexfyz-latest` Release/tag and assets match that source.
- APK asset 658613910, 54,751,323 bytes, SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`; source ZIP asset 658613911, 2,873,358 bytes, SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`.
- Build #124 includes password Show/Hide and Home NOTIFY. Current Firmware V7.1 is a later source-only update and is not validated by App CI.
- Preserve Android versionName `Telegram @horizontalzzz`. This Firmware-only execution did not modify App source or run another App Build.

## Current localization copy — validated in App Build #124

- English/Indonesian labels and notices use centralized localization strings. Home heading is `Notification` / `Notifikasi`; Settings remains `Notifications` / `Notifikasi`; Contact Developer is localized.
- Firmware Update Wi-Fi password remains masked by default with localized Show/Hide controls; secure storage is preserved.
- Build #124 validates these App changes. V7.1 is a later independent Firmware-only change.

## Current Firmware source — V7.1 Adaptive Fan 2°C bands; compile unverified

- Exactly one active versioned sketch: `firmware/JEXFYZ-V7.1.ino`, source blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`, embedded `FW_VERSION="V7.1"`. V7.0 is the previous revision. The prior user-reported V7.0 compile / Online OTA success does not validate V7.1.
- Adaptive 12 V target uses `temperatureCategoryC = floor(hotsideC)` and `belowLimitC = hotLimit - temperatureCategoryC`: ≤2 →100%; ≤4 →90%; ≤6 →80%; ≤8 →70%; ≤10 →60%; ≥11 →50%. At a 40°C limit: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%. All bands shift with configured limit.
- Immediate raw-decimal safety `hotsideC >= hotLimit` still forces Fan 100%, and the existing supervisor turns Peltier OFF. PWM pacing remains +10 points every 1 second / −10 every 10 seconds. Adaptive 5 V / 9 V remains 100%; rail/Peltier timing, Touch actions, NTC cadence and OTA are unchanged.
- QC contract blob `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync contract blob `7c203a11f79de62744af8536bbf2e3219d7f0909`. Contract tests and Arduino compile have NOT RUN for V7.1; installed version and physical behavior are UNVERIFIED.
- No V7.1 BIN/Firebase metadata was changed. OTA deployment is pending for V7.1; keep `TenzoNkz/JEXFYZ-Firmware` BIN-only.

## Safety and implementation constraints

- NTC remains one calibrated `analogReadMilliVolts(PIN_NTC)` sample per second. The user rejected median/trimmed/multi-sample NTC filtering; do not add it without renewed approval.
- Hotside configurable limit is 40–50°C (default 45°C). Manual Peltier latch rearms only at/below `hotLimit - 1°C` continuously for 5 s. Invalid NTC retains its existing fail-safe. No slope/rate-of-rise shutdown or manual-rearm feature was added by this task.
- OTA implementation, redirects, image validation, TLS trade-off, Firebase fields, BLE protocol, Adaptive rail sequencing, manual control and physical safety predicates were not intentionally changed. No BIN artifact, Firebase, OTA, flashing or hardware operation occurred.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"` and current App workflow `.github/workflows/jexfyz-app-build-trigger.yml`.

## Source of truth and handoff

- Current implementation: this `PROJECT_STATE.md`; detailed source contracts: `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`, `DESIGN_NOTES.md`, `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`, `VOLTAGE_TRANSITION_MEMORY.md`.
- Build history/results: `APP_BUILD_REPORT.md`. Decisions/failures: `CHANGELOG.md`. Navigation: `MEMORY_INDEX.md`. Authorization: `CHAT_RULES.md`. `CHAT_TRANSFER.md` must be written last after each meaningful execution.


## Current approved seven-icon rules and static-state redraw

- Battery Temperature: at the unchanged ≥40°C warning threshold, draw compact stylized orange/gold flame particles falling from the top, with warm yellow-white cores and soft restrained halos. Draw behind the foreground silhouette and clip to a rounded frame minus the icon silhouette; particles must not leak outside the rounded frame or appear inside the casing/chamber.
- Hotside Temperature: retain the continuous outer thermometer silhouette and fixed graduations; inner tube geometry and lower endpoint stay unchanged. Use the same refined falling-flame language, with the rounded-frame/silhouette clip keeping particles behind and outside the tube/casing. Activate only at the configured Hotside Limit.
- Voltage: retain the static inner luminous core and two phase-offset pulses along the outer bolt contour; inset the upper-right white-core point and clip core painting to the bolt so no white pixel escapes the silhouette. Keep 5V red, 9V green, 12V blue.
- Adaptive: strong dual circular arrows and recessed orbit track in every state; rotation only while authoritatively ON.
- Peltier: one six-branch rotating snow crystal and falling snow, only while the existing active-state rule permits animation.
- Fan: exactly three swept blades and three fixed airflow ribbons behind the rotor; retain existing voltage/PWM mapping and phase retargeting.
- Fan Speed: semicircle gauge, 11 graded ticks and event-driven live-PWM needle. Unknown telemetry never becomes fabricated OFF/zero status.
- Home Notification: icon-left/text-left Row, no CONNECTED/DISCONNECTED badge, fixed 44 dp card height; the localized heading is `Notification` / `Notifikasi`, with a small top inset. Body text can wrap to at most two lines and scales down only as needed. Seven indicator rows are 45 dp with 38 dp tile in 41 dp lane and a 3 dp gap before the card. The Settings About section/page is removed; keep General, Device, Firmware only.
## Repository topology and roles

- At the last complete recursive tree fetch, the App repo had 67 entries (49 blobs / 18 trees), five branches and zero open PRs. Re-fetch before relying on these counts in a later task.
- `TenzoNkz/JEXFYZ-App` owns editable App/Firmware source, tests, build workflow, all notes, memory and changelog.
- `TenzoNkz/JEXFYZ-Firmware` is BIN-only. Its live recursive tree currently contains exactly `JEXFYZ.cpp.bin`, blob `821b022f97353d9a7aea4695b2e37c98b7488e15`, 1,456,560 bytes; only tree metadata was inspected. Only repository tree metadata was checked; BIN payload was not read or changed. Source-to-BIN provenance remains **UNVERIFIED**.
- Archive snapshots under `archive/` are immutable forensic history. Archived “CURRENT” language never overrides live main.

## Current App UI, BLE and Floating Monitor contract

- App name JE Cooler, header JE X FYZ. UI direction based on Horizon Cooler: dark header, white rounded content panel, compact cards, cooler image right; main VOLTAGE/ADAPTIVE tabs and menu hierarchy VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE.
- Home semantic colors: Battery Ice Blue ≤30°C, cyan/amber/orange transition 30–40°C, red at ≥40°C with oval ember bursts; Hotside Ice Blue ≤30°C and red/oval bursts at the configured Hotside limit. Voltage labels remain 5 V red, 9 V green, 12 V blue. Disconnect shows unknown `--`, never stale output telemetry or black/grey semantic fallback. Do not display a standalone Battery Protection Guard badge.
- Dashboard effects are integrated 2D silhouettes. Battery/Hotside use top-down falling fire embers drawn behind the foreground icon and clipped outside its silhouette; Hotside's inner tube is raised close to the cap; Voltage uses edge-following pulses and an inset, silhouette-clipped inner core; Peltier retains the rotating six-branch snow crystal/falling snow; Adaptive retains two arcs/arrowheads; Fan retains fixed airflow behind blades; Fan Speed remains an event-driven live-PWM gauge. Bluetooth stays static. NOTIFY is left-aligned in the original icon-left/text-left Row, with no CONNECTED/DISCONNECTED badge; the card has a fixed 44 dp height and reduces wrapped body copy to fit two lines. Peltier/Adaptive/LED toggles keep neutral rows with a theme-primary knob and no checkmark or adjacent ON/OFF text.
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
- Build #123 / run `39371864780` completed SUCCESS on packaged source `14e90e7e26b8eb4400bd01ec8d0eab5ed4195f1c`; the live `jexfyz-latest` tag/Release and APK/source ZIP hashes matched that source. This does not cover the newer password-visibility patch. Its tests/analyzer have NOT RUN and it remains NOT RELEASED until the separately authorized `@Thinking Eksekusi Build App!` flow verifies it. BLE App authorization remains BLOCKED in `BLE_APP_AUTH.md` pending trusted enrollment/signing backend work.
