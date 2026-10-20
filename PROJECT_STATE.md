# JE X FYZ / JE Cooler — Current Project State

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #116 / run 39355262101 is the latest successful App release, packaging source 48683874db659df940272bed1c860072ead2d767. This execution adds a source-only English/Indonesian localization and copy follow-up that is NOT RUN / NOT RELEASED. Firmware V6.9 compile/install is USER-REPORTED; independent logs, source-to-BIN provenance and physical behavior remain UNVERIFIED.

## Current App / Release state

- Canonical repo: TenzoNkz/JEXFYZ-App, branch main. Build #116 / run 39355262101 is the latest successful App release; live jexfyz-latest Release/tag point to packaged source 48683874db659df940272bed1c860072ead2d767.
- APK asset 657979004, 54,734,939 bytes, SHA-256 8570914f331583d2cc462f61881609c0eae56639a139f2d60a832e4aaa81ea27; source ZIP asset 657979008, 2,867,315 bytes, SHA-256 60ef4e79529aabcbb4f4093b9f8a18b5d383d5c651c1c303dd8bb774e7b0dd5d.
- Build #116 validated the preceding fixed Home layout and bounded background ember painter. The preceding source-only visual follow-up refines falling flame shapes and rounded-frame clipping. This localization follow-up changes the Home heading to `Notification` / `Notifikasi`, localizes Contact Developer, and polishes user-facing English/Indonesian copy. The seven 45 dp rows, 3 dp gap and fixed 44 dp notification card remain unchanged.
- Current source/test blobs for the unvalidated localization follow-up: lib/main.dart 07178b5cce55fc8f78cc7c2953f4d8e352ccefe7; test/widget_test.dart 0a5901ac6dc23c947356189a312bb1dec418298e. Source assertions were updated, but Flutter tests and Dart analysis have NOT RUN for these edits; Build #116 does not validate them.
- Preserve Android versionName Telegram @horizontalzzz, BLE/control/telemetry semantics and the guarded App workflow. No App Build, firmware compile, BIN, Firebase, OTA, flash or device operation was performed.

## Current localization copy — source-only / validation pending

- The app supports English and Indonesian. The Home card heading now uses the centralized `notification` key (`Notification` / `Notifikasi`); the Settings section retains the plural `Notifications` / `Notifikasi` label. Contact Developer is localized through the same table.
- Hotside terminology is consistent (`Hotside Temperature` / `Suhu Hotside`), notification settings descriptions use `Send a notification` / `Kirim notifikasi`, and user-facing firmware/Bluetooth messages avoid exposing implementation details such as Firebase read access.
- Flutter tests and Dart analysis have NOT RUN for this copy pass. Build #116 remains the latest verified App release and does not include these changes.

## Current Firmware source — V6.9 source updated; compile unverified

- Exactly one active versioned sketch: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`, embedded `FW_VERSION="V6.9"`. V6.8 is superseded and was removed from the active tree.
- Adaptive 12 V target tiers remain delta <1.5°C →100%, 1.5–<2.5°C →90%, 2.5–<3.5°C →80%, 3.5–<4.5°C →70%, 4.5–<5.5°C →60%, and ≥5.5°C →50%. Actual PWM now changes by 10 percentage points: down every 10 seconds, up every 1 second. Voltage handoff and thermal-dwell paths reset the pacing clock, preventing an immediate 100% →50% drop after 9 V →12 V. Hotside limit/protection still forces 100% immediately; Adaptive 5/9 V remains 100%.
- `test/firmware_qc_contract_test.dart` `1b35feeb1e411efec44261ec130eec4535004454` checks the tiers, 10-second/1-second ramp timing, safety gates, one NTC sample per second and absence of blocking timing loops. `test/firmware_touch_adaptive_sync_test.dart` `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8` now reads V6.9. Firmware tests have NOT RUN for V6.9 in recorded CI evidence; the user reports compile/install success. Independent compile logs, BIN provenance, installed version and physical reset cause remain unverified.
- `TenzoNkz/JEXFYZ-Firmware` is BIN-only. Its live recursive tree contains exactly `JEXFYZ.cpp.bin`, blob `821b022f97353d9a7aea4695b2e37c98b7488e15`, 1,456,560 bytes; only tree metadata was inspected. Only repository tree metadata was checked; BIN payload was not read or changed. Source-to-BIN provenance remains UNVERIFIED.

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
- No current App Build has exercised the tag-ref workflow repair. Next authorized step is `@Thinking Eksekusi Build App!`; verify a new official issue-trigger run starts, all gates pass, `refs/tags/jexfyz-latest == run.head_sha`, Release metadata, APK/source ZIP digests and embedded source marker match, then independently re-fetch tag and artifacts. Until then, overall release handoff stays BLOCKED.
