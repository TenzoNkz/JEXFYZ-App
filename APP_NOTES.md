# JE X FYZ / JE Cooler — App Behavior Reference

Purpose: canonical current App/UI/BLE/telemetry contract. Current source defines implementation; DESIGN_NOTES.md holds approved visual constraints; CHANGELOG.md and APP_BUILD_REPORT.md hold history/evidence.

## Current implementation checkpoint — 2026-10-23

The latest independently verified App release is Build #128 / run `39908023440`, packaged source `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. The owner reports installing/overwriting their App with Build #128 (`USER-REPORTED`); the supplied screenshots/video are consistent with that report, but the installed package identity was not independently read from the device. The un-released UI-sizing patch began in commit `57ebcf8d971decf399e7a4d3e5dd5bf3d605010d` and was refined in commits `c92b0d08a16d101abf01b448804431dc795060fd` and `25adcfed5dd24b5c41ff603797087a30e704e8ae`, changing `lib/floating_monitor.dart` and `test/floating_monitor_layout_contract_test.dart`; `lib/main.dart` and `lib/app_settings.dart` remain unchanged from Build #128. Build #128 CI passed 121 Flutter tests, analyzer exit 0 (25 informational diagnostics), the configured Android gate, signing/source/release/downloaded-asset checks. The newer sizing patch has not been run through Flutter tests/analyzer or a new App Build in this environment, and does not prove BLE/hardware or OTA behavior.

- Settings and the Language, Appearance, Notifications, Bluetooth and Floating Settings routes use `JexFixedScalePage`; selected modal surfaces include the BLE Connection sheet, Peltier safety dialog, LED picker and Firmware Update dialog. The wrapper caps scale at 1.0: narrow viewports use a 360-dp logical canvas that can lay out before being proportionally scaled down, while wider viewports use their full available logical width with no up-scaling. An `OverflowBox` preserves the logical design dimensions during narrow scaling so parent viewport constraints do not shrink the child before the transform. Native typography, spacing, icons and control sizes stay at 1× above 360 dp.
- **Owner visual feedback / source fix (2026-10-23):** Settings and the Bluetooth Connection sheet looked zoomed in supplied screenshots/video. Initial change: `57ebcf8d971decf399e7a4d3e5dd5bf3d605010d`; responsive transform tests refined in `c92b0d08a16d101abf01b448804431dc795060fd`; child sizing/overflow constraints refined in `25adcfed5dd24b5c41ff603797087a30e704e8ae`. Widget coverage checks 420-dp wide and 320-dp narrow viewports. Flutter tests, Dart analyzer/formatter and device QA have NOT RUN in this environment because Flutter/Dart are unavailable and network access to fetch tooling is unavailable. The source patch is committed but remains unvalidated/unreleased; Build #128 is still the latest package. The Home brand header remains JE X FYZ.
- User-facing device wording uses Device / Perangkat rather than using JE X FYZ as a generic noun. The current lock heading is CONNECT YOUR DEVICE FIRST / HUBUNGKAN PERANGKAT TERLEBIH DAHULU; supporting copy is also bilingual. Preserve custom BLE names; identity matching/filtering is unchanged.
- Floating Monitor native overlay detaches at Dashboard startup and whenever synchronized BLE telemetry reports disconnected. It can reattach only when saved enable intent is active, overlay permission exists, and the full BLE/P1 session has synchronized connected=true. Startup payload includes current telemetry. Offline state or missing overlay permission does not erase saved enable intent.
- Alert notification IDs 2101–2104, persistent BLE foreground notification ID 2110 and Floating Monitor ID 2301 are distinct. Existing channel IDs remain unchanged. Alert, BLE-service and Floating Monitor channel labels/descriptions sync to App language on startup and every language change, including when services are stopped.
- OTA result events retain their raw result token until display time so user-facing text uses the then-current locale. The App-only UI work did not alter OTA protocol/transport, endpoints, allowlist, redirects, image/size/status checks or Firmware logic.

## Identity, package and app navigation

- App display name: JE Cooler; product branding/header: JE X FYZ.
- Android package: com.horizontalzzz.jexfyz. Flutter version: 1.0.0+3 at last live config review.
- Android Gradle versionName "Telegram @horizontalzzz" is intentional creator/contact identity; preserve it exactly.
- Visual assets are transparent square PNGs: assets/jexfyzicon.png and assets/jexfyzcooler.png. Preserve transparency and aspect ratio.
- Core Dashboard modes are VOLTAGE and ADAPTIVE. The compact menu hierarchy is VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Do not reintroduce the removed About Settings page/row without a new request.

## Home state and NOTIFY

- Firmware telemetry is authoritative for physical state. A command ACK by itself does not prove a physical state change. While BLE is disconnected or a value is unknown, show -- rather than fabricated/stale voltage, temperature or output values.
- Home notice shows the newest confirmed event rather than concatenating a growing status summary. Ordinary temperature samples do not create notices. Hotside at/above the configured limit is the safety-priority exception. A delayed ACK must not overwrite newer authoritative telemetry/event state.
- Status/error prose must be professional, concise, actionable and localized in English/Indonesian. Never show raw Firmware reason identifiers, underscore-formatted diagnostics, OTA ERROR/CODE internals or protocol suffixes.
- Known reason codes receive localized actionable copy; unknown codes use a generic localized message. A clear failure state must not disappear because of an unrelated ACK; clear safety errors only after healthy authoritative safety telemetry.
- Home notice heading decision (2026-10-23): use the selected App language — `Notification` in English and `Notifikasi` in Indonesian, matching the current localization source and `DESIGN_NOTES.md`. This records the owner’s decision; it does not claim new runtime validation.
- The Home notice card is compact, icon-left/text-left, fixed at 44 dp in current source, without a separate CONNECTED/DISCONNECTED badge. Preserve current event/safety predicates unless a scoped UI task authorizes a change.

## Home indicators and controls

- Disconnected data stays unknown, but each metric retains its semantic visual accent rather than becoming misleading generic black/grey. Unknown-state presentation must not imply output ON/OFF.
- Battery/Hotside warning visual effects are presentation only; they never replace Firmware safety. Battery warning red/flames begin at the configured visual 40°C contract. Hotside warning/flames follow the configured Hotside limit.
- Default Voltage colour map: 5 V red, 9 V green, 12 V blue. Keep manual voltage rows neutral and use the theme primary colour for active toggles, without a checkmark inside the toggle or an extra ON/OFF label next to the switch.
- Peltier, Adaptive, Fan and LED switch rows follow the same neutral row/icon plus primary-toggle convention. Preserve controls' existing BLE gating and safety enablement.
- When Bluetooth is disconnected, blur/dim the active display submenu with one centered lock overlay; keep the top-level tab strip and Home Bluetooth control usable. When connected but Adaptive is ON/transitioning, lock Voltage, Control and Temperature only; keep Adaptive and LED reachable. Underlying controls remain independently gated.

## Floating Monitor

- Exactly six metrics: B/H/V/A/P/F = Battery temperature, Hotside, Voltage, Adaptive, Peltier, Fan. F is Fan/Kipas, not FPS. Fan shows live PWM speed when running, localized OFF/MATI when off, and -- when disconnected.
- Persisted metric schema v2 migrates old configurations: retired old F (FPS) selections are discarded; old S (Speed) selections migrate to F. The display style is Letters-only; saved Icons mode migrates to Letters.
- Size range 0.30×–1.00× in 0.05× steps, default 0.60×. Background opacity is 0–100% in 5% increments and only affects background, not text. Existing drag position and free-drag behavior stay compatible.
- No Shizuku permission card or privileged FPS sampler. Flutter remains the single BLE/GATT client and streams authoritative telemetry to the native overlay. Native attachment does not itself prove that current device telemetry is connected.

## BLE session and protocol invariants

- Service UUID: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001.
- RX UUID: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001.
- TX UUID: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001.
- Protocol identifier: P1. Require the normal P1 session-readiness/synchronization gate.
- Auto Connect/reconnect respects saved preference, known/pair-associated device identity, Android Bluetooth permissions/prerequisites, and session synchronization. Suppress scans while syncing; stop retries when prerequisites are unavailable.
- Hardware Touch changes must result in authoritative state synchronization for Dashboard and Floating Monitor. A command ACK alone is not a state source.
- Secure RX writes use BLE encryption/bonding, but current Just Works pairing plus SYNC_READY does not prove official App identity. App-only authorization remains BLOCKED / NOT IMPLEMENTED; see BLE_APP_AUTH.md.

## Notifications and localization

- Native notification small icon uses the monochrome JE letterform resource. Content title is JE X FYZ where designed; device/service body copy is localized English/Indonesian.
- Android notification permission display remains subject to OS and user choice.
- The selected App language must be reflected in all app-facing safety, NOTIFY, command, BLE and OTA results. Notification channel names/descriptions update at startup and on language changes without changing existing channel IDs.
- OTA results render from validated event state in the currently selected locale. Protocol/diagnostic tokens remain internal.
- Do not let notifications fabricate connected state, physical outputs or successful OTA completion.

## OTA App lifecycle — protected

- Established command order: OTAENTER → SSID → PASS → URL → VERSION → CLOUDOTA.
- Arm expected OTA disconnect/recovery before CLOUDOTA. TIMEOUT or DISCONNECTED ACK is ambiguous, not proof of rejection; preserve recovery state until reconnect/result or a definite rejection while still connected.
- After OTA reconnect, complete normal P1/session sync and surface the one-shot result.
- Before any authorized App OTA change, read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md completely. Do not add Firebase hash/signature semantics without explicit approval.

## Battery and persistent configuration

- The App sends phone battery temperature via PHONE:BT at 1 Hz while the BLE session is ready; pending heartbeat values are coalesced.
- Firmware Battery input TTL is 5 seconds; when stale, HOTSIDE_BATTERY behavior falls back to HOTSIDE without silently changing the selected profile.
- Do not show a standalone Battery Protection Guard. The presentation rule never weakens Firmware safety or suppresses an independently actionable localized safety notice.
- Avoid changes to persisted Settings schemas/defaults without scoped migration/compatibility testing.
