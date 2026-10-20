# JE X FYZ / JE Cooler — Current Project State

Current state reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #110 is the latest successful App release. The current follow-up—falling fire particles, Hotside/Voltage geometry fixes, About removal, and Firmware V6.9 Adaptive Fan pacing—is source-only after Build #110 and NOT RUN / NOT RELEASED. APP_BUILD_REPORT.md owns build evidence; CHAT_TRANSFER.md is the final handoff snapshot.

## Current App / Release state — Build #110 verified; subsequent source follow-up is not released

- Canonical repo: TenzoNkz/JEXFYZ-App, branch main. Latest successful App release is Build #110 / Actions run 39300262741, source commit `b5adcffb2c9724a07cdba4cd8521c1307f1e6566`. Release/tag `jexfyz-latest` and its assets target that source.
- Build #110 APK asset `657047529`, 54,734,939 bytes, SHA-256 `258211ec9313c555aaac6cd797d1bf6abc6c62c3c2781cd37baa0a8c849bfb84`; source ZIP asset `657047524`, 2,866,352 bytes, SHA-256 `13d1cad6cf4fbb9b2560da7406f4c6bf875fe4ebc2ed5483e6f0001a3b24aa23`. The current source changes below are newer than the packaged build.
- Build #110 includes restored Home metric spacing (44 dp), the original icon-left/text-left NOTIFY Row, no CONNECTED/DISCONNECTED badge, and a 56 dp card/slot for up to two normal-size lines. The latest source follow-up changes the thermal particles to top-down falling embers, raises the Hotside inner tube, clips/insets the Voltage core, and removes the About section/page from Settings. Those changes are NOT RUN / NOT RELEASED.
- `test/widget_test.dart` now checks falling ember motion, 44 dp indicator rows, two-line NOTIFY layout, the raised thermometer tube and clipped/inset Voltage core; `test/floating_monitor_layout_contract_test.dart` asserts the About section/page is removed. Flutter tests and Dart analyzer have NOT RUN for this follow-up.
- Current App source/test fingerprints: `lib/main.dart` `08592a9d861a11ecdb8de1aa289f8ce06bf2e20c`; `lib/app_settings.dart` `f8e465648946a25eae44f3fad6a5a3bfaca8b050`; `lib/floating_monitor.dart` `e7c74bf749698a8331f2b0b31a847b2627ac3e4b`; `test/widget_test.dart` `b4a4ae36389432bb1334f8940b66caf3bf1ad184`; `test/floating_monitor_layout_contract_test.dart` `b053a92522223fd237a8f0e025648eb1b26730a5`.
- The guarded App Build workflow is unchanged. `@Thinking Eksekusi Full!` did not trigger an App Build. Only a separate `@Thinking Eksekusi Build App!` authorizes the full App validation/build/release workflow.

## Current Firmware source — V6.9 source updated; compile unverified

- Exactly one active versioned sketch: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`, embedded `FW_VERSION="V6.9"`. V6.8 is superseded and was removed from the active tree.
- Adaptive 12 V target tiers remain delta <1.5°C →100%, 1.5–<2.5°C →90%, 2.5–<3.5°C →80%, 3.5–<4.5°C →70%, 4.5–<5.5°C →60%, and ≥5.5°C →50%. Actual PWM now changes by 10 percentage points: down every 10 seconds, up every 1 second. Voltage handoff and thermal-dwell paths reset the pacing clock, preventing an immediate 100% →50% drop after 9 V →12 V. Hotside limit/protection still forces 100% immediately; Adaptive 5/9 V remains 100%.
- `test/firmware_qc_contract_test.dart` `1b35feeb1e411efec44261ec130eec4535004454` checks the tiers, 10-second/1-second ramp timing, safety gates, one NTC sample per second and absence of blocking timing loops. `test/firmware_touch_adaptive_sync_test.dart` `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8` now reads V6.9. Tests have NOT RUN and V6.9 is NOT COMPILED / NOT INSTALLED. The reported reset symptom's physical cause is not verified.
- `TenzoNkz/JEXFYZ-Firmware` is BIN-only. Its live recursive tree contains exactly `JEXFYZ.cpp.bin`, blob `9fdd915c3d298cad4de720765dab7fb03f47024d`, 1,456,368 bytes. Only repository tree metadata was checked; BIN payload was not read or changed. Source-to-BIN provenance remains UNVERIFIED.

## Safety and implementation constraints

- NTC remains one calibrated `analogReadMilliVolts(PIN_NTC)` sample per second. The user rejected median/trimmed/multi-sample NTC filtering; do not add it without renewed approval.
- Hotside configurable limit is 40–50°C (default 45°C). Manual Peltier latch rearms only at/below `hotLimit - 1°C` continuously for 5 s. Invalid NTC retains its existing fail-safe. No slope/rate-of-rise shutdown or manual-rearm feature was added by this task.
- OTA implementation, redirects, image validation, TLS trade-off, Firebase fields, BLE protocol, Adaptive rail sequencing, manual control and physical safety predicates were not intentionally changed. No BIN artifact, Firebase, OTA, flashing or hardware operation occurred.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"` and current App workflow `.github/workflows/jexfyz-app-build-trigger.yml`.

## Source of truth and handoff

- Current implementation: this `PROJECT_STATE.md`; detailed source contracts: `APP_NOTES.md`, `FIRMWARE_NOTES.md`, `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`, `DESIGN_NOTES.md`, `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`, `VOLTAGE_TRANSITION_MEMORY.md`.
- Build history/results: `APP_BUILD_REPORT.md`. Decisions/failures: `CHANGELOG.md`. Navigation: `MEMORY_INDEX.md`. Authorization: `CHAT_RULES.md`. `CHAT_TRANSFER.md` must be written last after each meaningful execution.


## Current approved seven-icon rules and static-state redraw

- Battery Temperature: at the unchanged ≥40°C warning threshold, draw clipped, elongated orange/gold fire embers with bright yellow-white cores falling from the top of the battery chamber; fade particles at the inner bounds. Do not restore rising ember bursts, tapered tongues, or falling teardrop-shaped flames.
- Hotside Temperature: retain the continuous outer thermometer silhouette and fixed graduations. Raise the inner tube close to the upper cap while retaining the same lower endpoint; falling orange/gold fire embers are clipped to the thermometer/tube bounds and activate only at the configured Hotside Limit.
- Voltage: retain the static inner luminous core and two phase-offset pulses along the outer bolt contour; inset the upper-right white-core point and clip core painting to the bolt so no white pixel escapes the silhouette. Keep 5V red, 9V green, 12V blue.
- Adaptive: strong dual circular arrows and recessed orbit track in every state; rotation only while authoritatively ON.
- Peltier: one six-branch rotating snow crystal and falling snow, only while the existing active-state rule permits animation.
- Fan: exactly three swept blades and three fixed airflow ribbons behind the rotor; retain existing voltage/PWM mapping and phase retargeting.
- Fan Speed: semicircle gauge, 11 graded ticks and event-driven live-PWM needle. Unknown telemetry never becomes fabricated OFF/zero status.
- Home NOTIFY: original icon-left/text-left Row, no CONNECTED/DISCONNECTED badge, normal-size one/two-line localized copy, 56 dp card/slot. Seven metric rows stay at 44 dp with 38 dp tile in 41 dp lane. The Settings About section/page is removed; keep General, Device, Firmware only.
## Repository topology and roles

- At the last complete recursive tree fetch, the App repo had 67 entries (49 blobs / 18 trees), five branches and zero open PRs. Re-fetch before relying on these counts in a later task.
- `TenzoNkz/JEXFYZ-App` owns editable App/Firmware source, tests, build workflow, all notes, memory and changelog.
- `TenzoNkz/JEXFYZ-Firmware` is BIN-only. Its live recursive tree currently contains exactly `JEXFYZ.cpp.bin`, blob `9fdd915c3d298cad4de720765dab7fb03f47024d`, 1,456,368 bytes. Only repository tree metadata was checked; BIN payload was not read or changed. Source-to-BIN provenance remains **UNVERIFIED**.
- Archive snapshots under `archive/` are immutable forensic history. Archived “CURRENT” language never overrides live main.

## Current App UI, BLE and Floating Monitor contract

- App name JE Cooler, header JE X FYZ. UI direction based on Horizon Cooler: dark header, white rounded content panel, compact cards, cooler image right; main VOLTAGE/ADAPTIVE tabs and menu hierarchy VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE.
- Home semantic colors: Battery Ice Blue ≤30°C, cyan/amber/orange transition 30–40°C, red at ≥40°C with oval ember bursts; Hotside Ice Blue ≤30°C and red/oval bursts at the configured Hotside limit. Voltage labels remain 5 V red, 9 V green, 12 V blue. Disconnect shows unknown `--`, never stale output telemetry or black/grey semantic fallback. Do not display a standalone Battery Protection Guard badge.
- Dashboard effects are integrated 2D silhouettes. Battery/Hotside use clipped top-down falling fire embers; Hotside's inner tube is raised close to the cap; Voltage uses edge-following pulses and an inset, silhouette-clipped inner core; Peltier retains the rotating six-branch snow crystal/falling snow; Adaptive retains two arcs/arrowheads; Fan retains fixed airflow behind blades; Fan Speed remains an event-driven live-PWM gauge. Bluetooth stays static. NOTIFY is left-aligned in the original icon-left/text-left Row, with no CONNECTED/DISCONNECTED badge and a 56 dp two-line slot. Peltier/Adaptive/LED toggles keep neutral rows with a theme-primary knob and no checkmark or adjacent ON/OFF text.
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
