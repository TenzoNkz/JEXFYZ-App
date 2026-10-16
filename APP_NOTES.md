# JE X FYZ / JE Cooler — App Reference

This file is the durable App behavior/design contract. Live source and the current workflow remain authoritative. The FPS TimeStats sampling/parser patch is built and CI-tested by Build #65; physical FPS behavior remains unverified on a target phone/OEM.

## Current source and build verification checkpoint (2026-10-16)

Build #65 ([run `38851040144`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38851040144), source `f301c1fbbafa3d6c17803d9a2f50bae390dc1343)) passed the App security/architecture/license audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, native FPS parser JUnit tests, obfuscated Android release build, V1/V2/V3 signing and certificate checks, source archive validation, Release publication and downloaded asset verification. It includes the TimeStats sampling/parser patch `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`, widget assertion repair `14347cd731b2c471fea9937f796ca21f8defc261`, and Gradle heap `-Xmx4096M`.

Build #63 had one stale widget assertion (87 passed, 1 failed); the test-only repair aligns layer matching with the TimeStats layer object. Build #64 passed Flutter tests but the native JUnit gate hit `Java heap space` during JetifyTransform with a 2 GiB heap. Raising Gradle to 4 GiB fixed the evidence-backed resource failure. Build #65 then passed all gates; no test or gate was deleted or weakened. Full attempt evidence lives in `APP_BUILD_REPORT.md`.

The current sampler reads bounded 64-layer SurfaceFlinger TimeStats every 500 ms, uses per-interval `averageFPS`, matches `packageName` when supplied, falls back to exact layer matching, and prefers SurfaceView/BLAST. Physical-device FPS, successful Shizuku binding on the target phone, OEM TimeStats visibility and visual rendering remain unverified. No Firmware, Firebase, OTA, BLE hardware-control or thermal-safety code was changed.

**Current built source:** binding-lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` and TimeStats patch `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620` are included in Build #65. The native `FpsTimeStatsParserTest.kt` suite passed under `:app:testDebugUnitTest`; actual behavior on the target phone/OEM still requires device validation.

## Identity and package

- User-facing app name: **JE Cooler**; branding/header: **JE X FYZ**.
- Flutter/Dart Android app; BLE implemented with `flutter_blue_plus`.
- Package: `com.horizontalzzz.jexfyz`; pubspec version observed at last reconciliation: `1.0.0+3`.
- Android `versionName "Telegram @horizontalzzz"` is intentional creator/contact identity. Preserve exactly.
- Transparent 1:1 visual assets: `assets/jexfyzicon.png`, `assets/jexfyzcooler.png`; Android icon also exists at `android/app/src/main/res/drawable-nodpi/jexfyzicon.png`.

## Visual layout and navigation

- Design direction based on Horizon Cooler App: dark header with white rounded content panel, compact cards and tab layout.
- Principal mode tabs: VOLTAGE and ADAPTIVE.
- Main/home information: Hotside Temperature, Battery Temperature, voltage indicator, Adaptive mode, Peltier and Fan state, Fan speed and safety/Notify reason.
- Menu hierarchy expected by the project: VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. Keep submenus compact and sideways where specified.
- Cooler image belongs on the right in the established compact layout. Do not casually redesign the approved visual identity.
- Use `DESIGN_NOTES.md` for the approved grille/icon/design constraints.

## Home indicators: colors and animations

- Disconnected telemetry must render as unknown (--) without switching the icon/text to black or generic grey. Retain each metric's lowest semantic accent as a visual fallback; this is not a claim that the device output is ON or OFF.
- Battery temperature: Ice Blue at or below 30°C, a smooth cyan/amber/orange transition from 30–40°C, and Burning Red at or above 40°C. Battery thermal fill uses the same 30–40°C band; the ≥40°C warning threshold remains exact.
- Hotside temperature: Ice Blue at or below 30°C, smooth transition above 30°C, and Burning Red at the configured Hotside Limit. The visual palette/fill must track the current limit; it must never alter or replace Firmware-owned safety behavior.
- Manual Voltage selection text and semantic accent: 5V red, 9V green, 12V blue. Unknown/disconnected voltage uses the 5V/lowest-voltage red fallback.
- Home status icons use compact, bounded Canvas shapes with a shared eased activity transition. State changes should fade/retarget instead of resetting animation phase; shapes and decorative effects must stay within their drawing bounds. Fan rotation keeps its voltage-dependent phase-continuous cycle and OFF coast-down. Peltier remains a six-branched free-standing frost crystal.

## Floating Monitor presentation contract

- Stable metrics remain F/B/H/V/A/P/S. The display is Letters-only; legacy saved Icons configuration migrates to Letters and the style selector is removed.
- Size slider is 0.30×–1.00× in 0.05× steps (14 intervals), default 0.60×. Persisted values snap into that range. Native pinch scaling and runtime geometry must accept the same upper bound.
- Background opacity is 0–100% in 5% increments; the displayed number remains visible, but the 50% midpoint label is removed. Legacy values snap to the nearest 5%. Opacity affects the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical letter rows share a single left edge. The floating window remains freely draggable; WindowManager gravity stays TOP | START and saved position is unchanged.
- Shizuku card is compact: status Shizuku Access Granted or Shizuku Access Denied, plus only Grant Shizuku Access and Check Access. No explanatory paragraphs or Open Shizuku button. Access status reports permission/service availability, not successful FPS measurement by itself.

## Controls and voltage

- Manual voltage levels: 5 V, 9 V, 12 V. Expected user touch cycle is 5→9→12→9→5, with the established ~1-second manual-switch guard.
- Voltage indicator LED default mapping: 5 V red, 9 V green, 12 V blue. Users can customize colors and reset to defaults.
- PWM Fan speed control belongs in the CONTROL submenu; increments should be practical (multiples of 5 or 10).
- PWM Fan speed adjustment applies only to Manual Volt at 12 V, not Adaptive mode. Adaptive controls its own Fan behavior.
- Adaptive ON locks the manual voltage touch sensor. Toggling Adaptive ON/OFF returns hardware to safe 5 V first. When leaving Adaptive, restore a previously running Peltier only through the safety gates and its normal 5-second OFF→ON soft-start.
- The App must not claim rail transition complete until matching authoritative `VOLTAGE` telemetry confirms it.

## Firmware telemetry is authoritative

- App state must reflect physical Firmware telemetry, not only command ACKs or optimistic local writes.
- A Touch Adaptive-OFF gesture must publish the authoritative Adaptive/ceiling/Fan/Peltier/Fan-speed telemetry so Dashboard and Floating Monitor cannot remain stale.
- Home/dashboard telemetry and Floating Monitor show unknown output state (`--`) while BLE is offline; they must not display stale physical state. CONTROL, ADAPTIVE, and LED menu switch rows instead use a disabled visual OFF fallback with the toggle knob at the left. This is presentation only, not confirmation that hardware outputs are OFF; controls remain disabled until BLE/P1 session sync and authoritative state are received.
- Safety/Notify error state may be cleared only after healthy live safety telemetry, not from an unrelated success ACK.
- Safety messages must be clear and localized; never expose raw protocol stage tokens or underscore-formatted internal reason strings to normal UI.
- Hotside safety re-arm copy uses the current firmware rule: Hotside at or below `hotLimit - 1°C` continuously for five seconds.

## BLE / session contract

- BLE service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`.
- RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`.
- TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- Protocol identifier is P1; require P1 readiness during session sync.
- Auto Connect/reconnect must respect the saved preference, a previously known/pair-associated cooler identity, Android Bluetooth/permission/location prerequisites, and BLE sync state. Cancel retries/scanning when prerequisites are unavailable and suppress scans while syncing.
- Do not mutate UI physical state based only on Touch or control ACK. Consume authoritative state deltas.
- Secure BLE command writes use encryption and bonding. Reconnect/first pairing still needs physical Android validation; Just Works does not provide MITM identity assurance without an input/display path.

## Android notifications and icons

- Android notification small icons use the vector `R.drawable.ic_notification`: a bold white `JE` letterform on a transparent background, optimized as an alpha silhouette for Android's monochrome small-icon mask. `JexNotificationUtils.kt` sets this as the sole small icon and does not set a large icon. The full-color app icon and dashboard branding are unchanged.
- User notifications use `JE X FYZ` as the content title and the localized event/status as the body; connected/disconnected notifications must not reverse these fields. Tapping opens JE Cooler.
- The BLE foreground-service notification has a meaningful localized connected-session body rather than an empty string. Floating Monitor uses the same branded icon and a non-empty service description.
- When Android 13+ notification permission is absent, the first real notification attempt requests permission instead of silently dropping every alert. The actual display remains subject to user choice and Android/OEM behavior.

## Online OTA App state

- OTA protocol order in the established path: `OTAENTER`, `SSID`, `PASS`, `URL`, `VERSION`, `CLOUDOTA`.
- Arm expected OTA disconnect/recovery before sending `CLOUDOTA`; OTA disconnect is a lifecycle event, not a generic Bluetooth failure.
- Missing `CLOUDOTA` ACK due to TIMEOUT/DISCONNECTED is ambiguous, not proof of rejection. Preserve OTA recovery state and wait for reconnect/OTA result. Roll back only on a definite rejection while BLE remains connected.
- After OTA reconnect, require normal P1/session sync and surface the one-shot OTA result.
- Current production metadata is expected to provide version + link; do not add a hash/signature requirement without explicit user approval.
- Before any App OTA change, read `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md`.

## Localization and persistent settings

- All user-facing safety, Notify, command, BLE connection and OTA messages use the localization layer.
- LED color parsing normalizes optional `#` and letter case before confirmation.

## LED mode and preview synchronization

- Six App modes use stable firmware IDs: 01 Static (1), 02 Breath (2), 03 Comet (4), 04 Dual Chase (5), 05 Left ↔ Right (6), 06 Rainbow (7). ID 3 / Mirror Pulse is retired and never reused.
- Firmware V6.6 emits one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple, computed immediately before BLE notify. Mode, phase and cycle arrive atomically, and the phase does not age while waiting in the queue.
- The App interpolates the phase from a monotonic local clock and adjusts drift at later snapshots; a phase update must not restart the animation controller. Separate `LED_PHASE` and `LED_CYCLE_MS` handling remains a compatibility fallback for older V6.x firmware.
- Preview pixel order follows the physical strip: right top→bottom indices 0–3, left bottom→top indices 4–7. The compact layout is left arrow, four left LEDs, centered localized mode name only (no numeric index), four right LEDs, right arrow.
- LED-column backgrounds are slightly darker for contrast. Preview pixel visibility/glow is independent of the hardware Brightness slider, so colors stay vivid even at low hardware brightness; animation levels still distinguish the active mode. This does not change brightness commands or physical Firmware rendering.
- The separate Color Picker offers 36 curated hue-ordered presets without HEX labels, remains bottom-pinned in the safe area, and uses localized top-left Cancel and top-right Select actions. Swatch taps update only a local draft (checkmark, preview swatch and localized name); they do not send BLE COLOR or dismiss the panel. Select sends the draft through the existing confirmed COLOR command and closes only after success; a definite failure or missing confirmation leaves the dialog open and preserves the last applied RGB state. Cancel discards the draft and closes without sending RGB. Taps outside the panel and system Back are blocked, so the action buttons control dismissal. The outer panel is not draggable or wrapped in a vertical scroll view. Text/swatch sizing is enlarged for comfortable viewing while preserving the six-column palette. Names are localized and legacy aliases (including Cyan #00FFFF) remain; Brightness stays the single intensity control.
- Firmware migrates saved mode ID 3/invalid values to Static and rejects new MODE:3 commands. On older firmware that still reports ID 3, the App labels the mode Unsupported rather than rendering Mirror Pulse; the user can select a supported mode.
- Firmware safety/OTA indicators continue to override decorative RGB effects.
- Do not change settings storage or defaults without a scoped task and regression review.
- Firmware persistent preferences use a 10-second quiet period; Adaptive Profile itself is runtime-only. See `FIRMWARE_NOTES.md`.

## Floating Monitor and Shizuku-gated foreground screen FPS

- FloatingMonitorService owns the overlay window; Flutter remains the single BLE/GATT client and streams authoritative telemetry. After native service attachment, Flutter replays the current telemetry snapshot. Native layout/redraw tracks changing live-value width.
- The overlay remains freely draggable with WindowManager gravity TOP | START and persisted coordinates. Horizontal metrics center as one group; vertical letter rows all share the same left edge. Size is 0.30×–1.00× in 0.05× steps (default 0.60×). Background opacity is 0–100% in 5% steps with live percent and endpoint marks only; midpoint 50% is removed. Black/White background and contrast behavior remain.
- The metric set is F/B/H/V/A/P/S. When BLE telemetry is disconnected, live device values are -- and no stale output state is inferred.
- FPS is intended to be foreground screen FPS, not game-only FPS. Build #65 uses Shizuku UserService to read bounded SurfaceFlinger TimeStats intervals (`--timestats -dump -clear -maxlayers 64`) every 500 ms and displays interval `averageFPS` instead of deriving FPS by subtracting cumulative frame counters.
- Foreground detection checks `mCurrentFocus`, `mFocusedWindow`, `mFocusedApp`, resumed/top-activity markers and WindowManager/ActivityManager fallbacks. If TimeStats provides `packageName`, the sampler matches it exactly; otherwise it uses package-boundary matching in `layerName`. Valid `SurfaceView`/BLAST layers are preferred over generic app layers.
- Native parser unit tests cover averageFPS parsing, multiline layer names, invalid/insufficient samples, static zero and SurfaceView/BLAST preference. Build #65 passed all four JUnit cases under `:app:testDebugUnitTest`.
- Metric F still requires Shizuku Binder availability, UserService support and explicit JE X FYZ approval in the Shizuku permission UI. Shizuku Access Granted confirms only the permission gate, not that the foreground layer is readable.
- **Built/CI-tested:** Build #65 includes binding lifecycle hardening, TimeStats parsing and its native JUnit gate; all 88 Flutter tests and release checks passed. **Not device-verified:** actual service binding on the target phone, OEM TimeStats/layer visibility, live foreground FPS and overlay/rendering behavior. Install the latest APK and capture Settings status plus filtered `JexFpsDiag` logs if F remains `--`.

## Phone battery telemetry and Battery Protection UI boundary

- The App reads Android battery temperature through the native `je_x_fyz/battery_temp` MethodChannel (`getBatteryTemperature`) and sends `PHONE:BT=<Celsius>` every 1 second while a BLE session is ready. Invalid/unavailable readings send the invalid sentinel rather than a stale temperature.
- The heartbeat queue coalesces pending battery messages so slow BLE transmission does not produce an unbounded backlog. Firmware considers phone Battery data valid only for its 5-second `BATTERY_VALID_TTL_MS`; when it expires, HOTSIDE_BATTERY behavior falls back to HOTSIDE control without silently changing the runtime-selected profile.
- Current Battery-zone setting defaults: 5 V threshold 25°C and 12 V threshold 35°C; current firmware has a 0.5°C zone hysteresis. Live source remains authoritative if these values change.
- **Permanent UI requirement:** do not display a standalone “Battery Protection Guard” badge/guard/status indicator in the App. This is a presentation rule, not permission to weaken thermal protection or suppress an independently actionable, localized safety/Notify message.
- **Pairing design requirement / implementation status not established:** the project intent is one authorized App identity/one key-lock pairing relationship per cooler firmware. Current source-level checks confirm encrypted/bonded BLE writes, but do not establish an exclusive one-App-only provisioning/lock mechanism end-to-end. Do not claim the exclusive pairing lock is implemented until its concrete source flow and physical pairing behavior are verified.

## Current App QC boundary

- Latest verified App release is Build #65 / run `38851040144`, source commit `f301c1fbbafa3d6c17803d9a2f50bae390dc1343`. It includes Home indicator restoration, Floating Monitor controls, foreground TimeStats FPS diagnostics, Shizuku binding lifecycle hardening and the native parser/JUnit gate.
- Build #65 passed App audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, obfuscated APK build, V1/V2/V3 signing and production-certificate checks, matching-source ZIP validation, publication and downloaded-asset hash/signature verification.
- APK SHA-256: `6823d87dbe25ded3ee5fd399ff231423078f9a33e814d7a80aed8ed1fe1b5b87`; source ZIP SHA-256: `df96a3cf43c860370d776995bff2ef4861ccf9f5e84744b49adb0cdab79d13cc`.
- Release `jexfyz-latest` contains exactly one APK (`JEXFYZ-release.apk`, asset `646151731`, `54,636,716` bytes) and one matching source ZIP (asset `646151729`, `2,874,038` bytes). The workflow re-downloaded both and verified hash/source identity; the APK passed V1/V2/V3 and certificate checks.
- Current source blobs: `lib/main.dart` `d24885cf0a40472b9fb23ee6ce73ad772ae73672`; `lib/floating_monitor.dart` `bae089f1f950bd70fe7e6f90e8afa1726293664f`; `lib/app_settings.dart` `4c89bcb3c04142ce49440a11b92054365c26f7a6`; native `FloatingMonitorService.kt` `0f9544c4e5f568531426e771f81e950397c86a7`; `FpsShizukuUserService.kt` `8bb6181b4c86e1a2ae2c635969646303b6d84483`; `FpsTimeStatsParser.kt` `66b5e3f489f4e160407d87c40d1ecee54e13282f`; native parser JUnit `FpsTimeStatsParserTest.kt` `ab6c63c627c05d9987de4d4af731f2ed86acde5b`; `test/widget_test.dart` `e9edc694dbc9f400fe034d99d1254628dc39a89f`.
- Build #63/#64 failure causes and repairs are preserved in `APP_BUILD_REPORT.md`; Build #65 verifies the TimeStats patch but cannot establish target-device binding, OEM access or visual behavior.

## Dashboard indicator motion

- Dashboard status indicators now use a cleaner, bounded Canvas design with consistent rounded strokes and fewer competing decorative elements. State changes use a separate eased activity controller and preserve animation phase instead of resetting regular icons to frame zero.
- Battery indicator remains segmented, but its visual thermal band now runs from Ice Blue at ≤30°C to Burning Red at ≥40°C. Hotside transitions from Ice Blue at ≤30°C to Burning Red at the configured Hotside Limit; neither palette changes safety decisions.
- Voltage bolt sheen moves back and forth continuously and remains clipped to the bolt shape. Bluetooth ripples use an opacity curve that approaches zero smoothly at the loop boundary. Adaptive remains a compact orbital ring/core. Peltier uses a six-branch crystal with bounded particles and no module box. Fan uses compact blades; its 5V/9V/12V rotation periods and phase-continuous voltage transition/coast behavior remain. Fan Speed retargets the current gauge smoothly.
- These are App-side visual changes. They do not change Firmware source, BLE command protocol, thermal safety or physical LED rendering. Animations/visual bounds are source-edited but have not been exercised on a physical phone.
