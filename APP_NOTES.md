# JE X FYZ / JE Cooler — App Behavior Reference

Purpose: canonical current App/UI/BLE/telemetry contract. Current source defines implementation; DESIGN_NOTES.md holds approved visual constraints; CHANGELOG.md and APP_BUILD_REPORT.md hold history/evidence.

## Current implementation checkpoint — 2026-10-23

The latest independently verified App release is Build #129 / [run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), packaged source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`. Release/tag and downloaded APK/source ZIP identities and digests match the tested source SHA.

- **Release APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), 54,751,323 bytes, SHA-256 `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`.
- **Matching source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), 2,878,916 bytes, SHA-256 `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- **Home-equivalent DPI canvas validated/released:** Settings root/subpages, Bluetooth Connection sheet and selected dialogs use `JexFixedScalePage` matching Home's uncapped 360-dp master canvas. Implementation commit `d0f87b09c96a89063dc3b6f8c23e763bd11dc66e`; density-regression test commit `f680837ad61653fbda071bb8f451ccd4113acfaf`; contract-comment commit `cf0b66d6c5cf131d55aa99783fa3518274275d57`.
- **Compact Settings/Connection source pass on `main` — not released, runtime validation pending:** commits `5ab14e258a9e21bfec486e3c6a3d81d6705c6d0f` (scoped compact theme and base sizes), `bfdcafd1ad044974935b4e473d68f2096a297fbf` (precise subpage/Connection values), `415d240db3cd9b3e2bca3ef760c4ba667459c604` (per-role source-contract assertions), `f5bf63b0f5c8a837f47617b77e85d8dce93d845c` (preserve inherited theme colors on compact surfaces), and `9db9ee3fc453f537ceaca88462b02e36318a487e` (formatter-safe test contract). Settings root/subpages and Bluetooth Connection opt into `buildJexCompactUiTheme`; it derives from the inherited theme where appropriate, preserving the Connection sheet's existing light/dark appearance. The 360-dp canvas/DPI formula is unchanged. Flutter test and `dart format` attempts both stopped at `command not found` (exit 127); analyzer/full suite and device QA have not run. Build #129 remains the latest verified release and does not contain this compact pass.
- **Regression validation:** Build #129 passed **122 Flutter tests**, including the test holding a 1080×2400 physical viewport constant while simulating 420-dp and 320-dp logical widths, expecting a 360×800 logical canvas with scales 420/360 and 320/360. Dart analyzer exited 0 with 25 informational diagnostics. The configured Android Gradle gate succeeded; native Android JUnit tasks were `NO-SOURCE`.
- **Release checks:** obfuscated APK build, V1/V2/V3 signing and expected production certificate, corresponding source ZIP/source marker, exact Release/tag target and downloaded APK/ZIP checksum/signature checks all passed.
- **Validation boundary:** local `dart format` and physical-device/OEM density QA were not run. Hosted CI validates the widget/test/build contracts, not real Android display rendering, BLE/overlay, cooling, Firmware, or OTA behavior. The owner-reported field unit was previously said to use Build #128; Build #129 installation is not independently confirmed.
- Generic user-facing device identity remains Device / Perangkat. The Home heading follows App language: `Notification` in English and `Notifikasi` in Indonesian. Existing BLE gating, Floating Monitor offline behavior, notification IDs/channels and OTA protocol/transport remain unchanged.
- **Compact visual pass (2026-10-23; source implemented, validation pending):** implemented the planned roughly 10–20% reduction while preserving the Home-equivalent canvas. Settings AppBar 20→18, row title 13, summary 12→11, section labels 10→9, glyphs 21→19/caret 18→16, row vertical padding 13→10; Settings subpages use a scoped compact theme. Connection header 66→60, title 18→16, status label 10.5→9.5, glyph sizes reduced, Devices title 13, empty-state message 13→12. Close/status/refresh controls retain 40–42 dp hit areas and status pills remain 42 dp tall. Added source-contract coverage. No BLE, language, theme colors, Home layout, or 360-dp/DPI math changes. The source is on `main` but not in Build #129; Flutter test, formatter, analyzer/full suite and device QA remain unverified because tools are unavailable.

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
