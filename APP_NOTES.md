# JE X FYZ / JE Cooler — App Reference

This file is the durable App behavior/design contract. Live `lib/` source and the current workflow remain authoritative for implementation.

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

## Floating Monitor and real foreground FPS

- The Floating Monitor settings page has no duplicate/live-preview pill in the middle of the screen. Display orientation is controlled explicitly by the Horizontal / Vertical selector; tapping a preview no longer doubles as the orientation control.
- The native `FloatingMonitorService` owns the actual overlay; Flutter remains the single BLE/GATT client and streams the current authoritative telemetry. When the native service is newly started/restored, immediately replay `floatingTelemetryNotifier.value` after the service is confirmed attached; early telemetry updates are intentionally dropped if the native service instance does not exist yet. Native value updates request both layout and redraw so changing label/value widths do not clip or disappear.
- FPS no longer counts JE Cooler's own Flutter `FrameTiming`. The native collector uses `dumpsys SurfaceFlinger --timestats` frame-count deltas at approximately one-second intervals, first identifies the Android resumed/focused app through `dumpsys activity activities`, then filters SurfaceFlinger layer names to that exact package. It must never fall back to display refresh-rate or an unrelated/high-activity background layer. This reports compositor-presented frames for the focused app, which may differ from a game's internal simulation/update rate.
- FPS sampling runs only when the user has enabled the overlay, the real window is attached, and metric F is selected. When JE Cooler/system UI is foreground, foreground package cannot be resolved, no matching layer appears, the permission is missing, or the device blocks the dump, the indicator stays `--` or explicitly shows `ADB`; it must not fabricate FPS. FPS counts are not mixed into the firmware's BLE telemetry.
- Access setup is intentionally user-controlled. The built-in Android 11+ path starts a native foreground notification flow; it discovers the local `_adb-tls-pairing._tcp.` endpoint, accepts a fresh six-digit code only through Android `RemoteInput`, pairs an ADB host identity, discovers `_adb-tls-connect._tcp.`, and executes only the fixed `pm grant com.horizontalzzz.jexfyz android.permission.DUMP` request. Android package-manager permission state is then checked independently. The app exposes no arbitrary shell command, remote hostname or remote port, does not save the pairing code, and never turns Wireless/USB debugging on itself. Trusted-computer ADB grant/revoke commands remain available as a manual fallback.
- **Security/compatibility boundary:** Android marks `DUMP` as a powerful `signature|privileged|development` permission not intended for third-party apps. This grant is for the user's own phone only; the UI must disclose its scope, keep only fixed Activity/SurfaceFlinger commands, avoid persisting/exporting raw dumps, and report unavailable status if Android/OEM blocks the grant. The ADB host identity is AES-GCM encrypted with an Android Keystore key in `noBackupFilesDir`; it remains paired until forgotten in Wireless debugging or ADB authorizations are revoked. Pairing uses Apache-2.0 Kadb 1.3.0 (`third_party/Kadb-1.3.0-LICENSE.txt`), not Shizuku.
- **Verification status:** the notification-driven pairing feature and its updated source-contract test are now in `main`, but they were added after Build #36, are NOT BUILT, and Dart/Flutter tests plus Android/Kotlin compilation have NOT RUN for this feature. On-device mDNS discovery, notification RemoteInput, the TLS pairing/connection, OEM acceptance of `DUMP`, foreground layer names, live in-game FPS, service survival and overlay behavior remain UNVERIFIED.

## Phone battery telemetry and Battery Protection UI boundary

- The App reads Android battery temperature through the native `je_x_fyz/battery_temp` MethodChannel (`getBatteryTemperature`) and sends `PHONE:BT=<Celsius>` every 1 second while a BLE session is ready. Invalid/unavailable readings send the invalid sentinel rather than a stale temperature.
- The heartbeat queue coalesces pending battery messages so slow BLE transmission does not produce an unbounded backlog. Firmware considers phone Battery data valid only for its 5-second `BATTERY_VALID_TTL_MS`; when it expires, HOTSIDE_BATTERY behavior falls back to HOTSIDE control without silently changing the runtime-selected profile.
- Current Battery-zone setting defaults: 5 V threshold 25°C and 12 V threshold 35°C; current firmware has a 0.5°C zone hysteresis. Live source remains authoritative if these values change.
- **Permanent UI requirement:** do not display a standalone “Battery Protection Guard” badge/guard/status indicator in the App. This is a presentation rule, not permission to weaken thermal protection or suppress an independently actionable, localized safety/Notify message.
- **Pairing design requirement / implementation status not established:** the project intent is one authorized App identity/one key-lock pairing relationship per cooler firmware. Current source-level checks confirm encrypted/bonded BLE writes, but do not establish an exclusive one-App-only provisioning/lock mechanism end-to-end. Do not claim the exclusive pairing lock is implemented until its concrete source flow and physical pairing behavior are verified.

## Current App QC boundary

- Current source: `lib/main.dart` blob `c697497e16c94b8fe4fe8fd9bd1f9bc93598545f`; current widget test `test/widget_test.dart` blob `2a87292d5c4bc468ee6aad6810b249d284a28bae`.
- Latest successful App Build is [Build #36 / run `38689044316`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38689044316), source commit `893393388b99fc6d9e59c420070a159a29e45e9a`: security/architecture audit, dependency resolution, Dart analyze, all 77 Flutter tests, obfuscated APK build, APK V1/V2/V3 checks, production certificate check, release publication and re-downloaded asset verification passed. This APK predates the later Wireless ADB pairing commits; it does NOT contain the pairing notification feature.
- Current release `jexfyz-latest` contains one `JEXFYZ-release.apk` (54,620,251 bytes), SHA-256 `a5c9d97a3d28f7f711b0cd3c524289bc136cecec56d3b1d88821e43c713e9a13`. Production certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. V1/V2/V3 independently verified on built and re-downloaded APKs; this release asset does not include source commits added after `893393388b99fc6d9e59c420070a159a29e45e9a`.
- Build #34 exposed a mismatch: the prior `Curves.easeInOutCubic` yielded 0.510125 at progress 0.5, while the regression contract expects 0.5. Current `jexSmoothFanSpeedLevel` uses symmetric cubic smoothstep `t*t*(3-2*t)`; the test was not loosened, and Build #35 passed it within all 74 Flutter tests.
- JAR/V1 validation warns that certain dependency `META-INF` entries are not protected by the JAR signature; this warning is distinct from the separate successful V1/V2/V3 checks. The earlier MT Manager text `Signature: Verified failed` was not revalidated on the installed #35 APK.
- CI does not prove physical rendering, BLE, cooling, safety behavior or installed-device signature interpretation. Firmware V6.6 compile/Online OTA success twice is user-reported; artifact BIN source provenance remains unverified.

## Dashboard indicator motion

- The seven Home indicators use custom Canvas artwork. Active motion remains driven by the looping controller; repeating effects must return visually continuously at the 0→1 boundary.
- Fan rotation follows BLE voltage classes: 5V = 2600 ms, 9V = 1250 ms, 12V = 620 ms. Voltage changes preserve angular phase by travelling to an equivalent full-turn boundary. Fan OFF decelerates with ease-out over a short period-dependent travel (up to 0.16 turn) and holds the final pose, with full-colour blades/hub.
- Peltier is a free-standing six-branched frost crystal without square frame, center box or corner bolts. Crystal/particles move while active and frost intensity/count interpolates over 420 ms on voltage changes. OFF stops/fixes the animation with the full-colour crystal still visible; there is no OFF fade.
- Fan Speed now interpolates its actual visual gauge level from the currently displayed level to each new active target with symmetric cubic smoothstep (`t*t*(3-2*t)`) over 420 ms. Rapid target changes retarget from the current interpolated value, not from the prior target or zero. OFF animates the visual target to 0 over 520 ms and settles at the far-left mark. The reported percentage remains authoritative and static. ON wobble is only a subtle needle offset using integer-frequency sine harmonics, so it is continuous across repeat.
- The voltage-bolt sheen uses a sinusoidal back-and-forth sweep instead of a linear sweep that resets at loop end. Bluetooth ripples use a squared-sine opacity envelope that is zero with zero slope at both ends, avoiding a flash when radius cycles wrap.
- LED status-preview pulses are periodic sine/cosine loops; navigation/action glyphs remain static by design. All of these are presentation-only; Firmware source, BLE command protocol, thermal safety and physical LEDs are unchanged.
- Color Picker retains existing preview contrast, typography/swatch sizing and bottom-pinned six-column layout. Draft swatch selection is separate from applying the live RGB; localized Cancel discards the draft, localized Select applies it, and outside taps/system Back cannot dismiss the modal. Peltier Safety targets and the mandatory Fan-before-Peltier gate remain unchanged.



## Home indicator animation redesign — 2026-10-15

- Approved scope: keep the existing Home/dashboard layout and cooler image placement; redesign the seven status indicators (Battery Temperature, Hotside Temperature, Voltage Indicator, Adaptive Mode, Peltier Switch, Fan Switch and Fan Speed) as dedicated custom-painted graphics.
- Battery Temperature uses three restrained thermal segments driven by the displayed Celsius reading. Hotside Temperature is now a single clean thermometer silhouette with a separated bulb; no decorative heat-wave strokes cross or overlap the glass. Both temperature level transitions are interpolated over 520 ms and use valid telemetry only.
- Voltage keeps a moving charge sweep clipped to the lightning silhouette. Adaptive uses a minimal ring/orbit/core; Peltier uses a legible six-arm crystal with only four small peripheral sparks; Fan blades rotate independently around a stable hub and coast down on OFF; Fan Speed retains a telemetry-driven gauge with retargeted smooth transitions and a seamless small needle wobble.
- Adaptive orbital motion stops when Adaptive is OFF. Motion is gated by the connected live session as before; no sensor value is treated as physical truth unless it comes from telemetry.
- Home Notify's connection badge uses CONNECTED / DISCONNECTED in English and TERHUBUNG / TERPUTUS in Indonesian. Existing error, Connecting and Syncing states and the detailed body message are preserved.
- Source/test update is committed separately from the explicit Build App workflow. These changes are NOT BUILT / NOT RUN in Flutter and still require the separate @Thinking #Build App! authorization for full CI QC and physical-device verification.

- Follow-up audit clarified that the ordinary “Bluetooth Disconnected” notice is not itself classified as an error badge; the right-side connection status now reflects the live BLE flag, while failed scan/discovery and explicit error messages still show ERROR.
