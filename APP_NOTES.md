# JE X FYZ / JE Cooler — App Reference

This file is the durable App behavior/design contract. Live source and the current workflow remain authoritative.

## Current production checkpoint — 2026-10-21

- The owner confirms the sold/shipped unit is using App Build #124 and Firmware V7.1; Firmware V7.1 was compiled and successfully updated through Online OTA. Record this as USER-REPORTED product/deployment status.
- Independently verified App release evidence: Build #124 / Actions run `39386733061`, package source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`, APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`, source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`. Build #124 passed 116 Flutter tests and the configured App release gates.
- The App release record does not independently prove Firmware compilation, exact source-to-BIN identity, installed version, physical OTA/reboot/BLE recovery, or thermal/electrical behavior. Do not contradict the owner's report with stale V7.0/V7.1 status text.
- Since the unit is sold and shipped and cannot be routinely disassembled, treat Build #124 + V7.1 as the production baseline. OTA/BLE/reconnect changes are high-risk and must not be bundled into unrelated UI cleanup.

## Audit findings — Settings UI scale, Floating Monitor BLE visibility, and phone-notification copy (implementation pending)

- The Home/dashboard visual canvas locks text scaling and scales a 360-dp design canvas to the viewport. The separately pushed Settings/sub-settings routes do not inherit this route-local lock. Root-navigator dialogs/sheets are also outside that subtree, so they need an explicit shared fixed-canvas policy rather than relying on Home's `MediaQuery`.
- Native Floating Monitor currently replaces output values with `--` when telemetry says disconnected but does not remove the overlay. A future fix must distinguish the saved user preference from native runtime visibility; otherwise the current runtime health reconciler can clear the enabled preference while the window is intentionally hidden.
- App push notification review: Bluetooth copy is generic but bilingual; Hotside safety copy is already localized; firmware-update availability sends the version string alone as its body; native notification channel labels/descriptions are English-only; cached OTA notice text must be localized again at send time after any language change.
- Proposed correction and tests are tracked in `CHAT_TRANSFER.md`. No code or test files changed as part of this audit.

## HISTORICAL / SUPERSEDED — security checkpoint before Build #124 (2026-10-20; BLE authorization blocked)

- Build #123 / Actions run `39371864780`, source `14e90e7e26b8eb4400bd01ec8d0eab5ed4195f1c`; APK SHA-256 `1d06c806b1e75440dfe16108d236dd4c5f0e9b85d50e56989263793952351abb`; source ZIP SHA-256 `0118f201027747f8f682a8d3a393334585a14845a8741f2296da07afae06fbe1`. This release predates and does not include the password-visibility patch.
- User reports the App release is installed safely and Firmware V7.0 compiled and successfully updated via Online OTA. This is **USER-REPORTED**; installed firmware version and source-to-BIN provenance have not been independently verified.
- Added a toggleable eye icon to the Firmware Update Wi-Fi password field. It is masked by default, supports localized English/Indonesian Show/Hide tooltips, and retains `FlutterSecureStorage`. New source/test blobs: `lib/main.dart` `2d44e1f1f5b88ca1dae8324082da751b6ef1485a`, `lib/app_settings.dart` `637c07be55c412451d9ffde762e080c8bd92fd5e`, `test/widget_test.dart` `90e1a582c49ce3ad1a1d9a3b875921098eaf2545`. Flutter tests, analyzer, and App Build have NOT RUN for this patch.
- **BLE App-only command authorization remains BLOCKED / NOT IMPLEMENTED.** Live V7.0 has encrypted/bonded BLE writes, Just Works pairing and a gate opened by `SYNC_READY`, but no per-install App identity or authenticated enrollment. No trusted backend signing/enrollment/owner-claim endpoint or deployment path was found in the repository. See `BLE_APP_AUTH.md`.
- No first-connection client may self-register a trusted key. Do not claim nRF Connect is blocked until server-authorized enrolment, per-session challenge-response, firmware verification and rejection tests are implemented.
- User-approved UX: power on cooler → open App → Connect BLE → use it; no QR and no additional Touch gesture. All existing Touch gestures and hardware safety remain unchanged.
- **OTA is frozen and was not changed.** No OTA state machine/transport, TLS, URL/redirect, timeout, radio handoff, recovery/restart, Firebase production config/metadata, firmware source/version, BIN, App Build, compile, flash, or device action was changed/run in this task.


## Home NOTIFY — single latest-event message (validated in Build #124)

- Packaged source blobs in Build #124: `lib/main.dart` `2d44e1f1f5b88ca1dae8324082da751b6ef1485a`, `lib/app_settings.dart` `637c07be55c412451d9ffde762e080c8bd92fd5e`, and `test/widget_test.dart` `90e1a582c49ce3ad1a1d9a3b875921098eaf2545`.
- Home NOTIFY displays one complete sentence for the newest confirmed event. Ordinary Temperature samples do not create messages; Hotside-at-limit remains the safety-priority exception. New confirmed Voltage, Control, Adaptive, Fan, LED or safety events replace the earlier notice instead of being combined into a state summary.
- Build #124 passed 116 Flutter tests and configured release gates. This verifies packaged source and CI gates, not physical phone animation, BLE state accuracy or firmware thermal behavior.
- Owner confirms Build #124 is used by the sold/shipped unit. Firmware V7.1 compile and Online OTA success are separately USER-REPORTED; App CI does not verify firmware BIN identity or physical OTA/reboot/reconnect.


## HISTORICAL / SUPERSEDED — earlier App release and follow-up checkpoint (Build #123, 2026-10-20)

- At this historical checkpoint (2026-10-20), Build #123 / run 39371864780 was the latest verified App release, source `14e90e7e26b8eb4400bd01ec8d0eab5ed4195f1c`. APK SHA-256 `1d06c806b1e75440dfe16108d236dd4c5f0e9b85d50e56989263793952351abb`; source ZIP SHA-256 `0118f201027747f8f682a8d3a393334585a14845a8741f2296da07afae06fbe1`. Build #124 subsequently superseded this release checkpoint.
- Latest unbuilt Home NOTIFY single-event follow-up: lib/main.dart `40f172a5d190b429d3a952f2531349c1ee220d1f`; lib/app_settings.dart `44431e926bfa2557c26345899e2333bd767f3f8e`; test/widget_test.dart `132c3b000abd63599ebea9d26fc5085cb577e50e`. Flutter tests and analyzer have NOT RUN for this follow-up.
- Home: seven 45 dp metric rows, 3 dp pre-card gap, and a fixed 44 dp icon-left/text-left card. Its heading is localized as `Notification` / `Notifikasi` with a 2 dp top inset; body copy scales down only as needed and is limited to two lines. Cooler-image constraints remain stable.
- Battery/Hotside: small stylized orange/gold flame particles descend from the top with warm yellow-white cores, a soft halo and subtle drift/rotation. The particles are background-first, clipped to a rounded frame minus the foreground shell, and cannot escape the rounded boundary or paint inside the battery chamber/thermometer tube. Existing warning gates and safety logic are unchanged.
- At that checkpoint, Build #123 validated the single-event NOTIFY implementation in its packaged source but did not include the password-visibility patch. Build #124 later included password visibility and is the current verified App release; neither release proves physical-phone behavior. BLE App identity authentication is not implemented; no firmware/BIN/Firebase/OTA/device state changed in this follow-up.
- The owner later confirmed that Firmware V7.1 compiled and was updated via Online OTA on the sold/shipped unit (USER-REPORTED). Exact source-to-BIN provenance and independent installed-device identity remain UNVERIFIED.

## HISTORICAL / SUPERSEDED — localization copy pass checkpoint (2026-10-20)

- Home and contact actions use centralized localization keys for English and Indonesian. The Home heading is `Notification` / `Notifikasi`; the Settings page keeps `Notifications` / `Notifikasi`. Hotside labels consistently use `Hotside` / `Suhu Hotside`.
- Notification descriptions use natural action language (`Send a notification` / `Kirim notifikasi`). User-facing errors avoid surfacing internal backend wording. Flutter tests and Dart analysis have NOT RUN; the last verified App build remains #120.

## Tamper warning screen and developer contact — rounded text blocks included by Build #80

- The native launch gate in `MainActivity.isOfficialBuild()` allows local debug builds, then compares the installed APK signing certificate against the configured official production signer; an absent configured certificate, mismatch, or native exception rejects the launch. This is a signing-identity gate, not proof of detecting every possible tamper technique.
- On a rejected release launch, `main()` continues to mount only `TamperApp` / `TamperScreen`. The visible screen is deliberately opaque: JE X FYZ branding plus a dense, scrollable Indonesian slang/profanity wall. It does not explain the reason or display technical terms.
- The bottom-pinned `Contact Developer` / `Hubungi Pengembang` button calls the existing `je_x_fyz/security` MethodChannel's `openDeveloperContact` method. Android dispatches `ACTION_VIEW` to `https://t.me/horizontalzzz`; the username/URL is not printed in the UI. Launch failure leaves the warning visible and does not grant entry.
- The certificate-verification decision is unchanged. The screen is triggered only by the existing official signing check returning false; ordinary application errors are not relabelled as tampering.
- Packaged Build #83 source/test fingerprints at that time were lib/main.dart 99bdf225b990fbe8a4ff92c224b4fccc4ae4624a and test/widget_test.dart 9fffea531bdb19315c01aaf0e253ebdfacd7a1ed. Build #80 introduced the rounded-box layout; Build #83 included both that layout and the explicit static warning Icon. Current main has newer dashboard animation code, as recorded above.
- Build #83's widget contract covered visible-copy restrictions, developer-contact behavior, rounded text-block layout/static warning icon, Peltier snowflake layer order, Adaptive orbit-dot removal, closed Voltage spine, airflow-behind-rotor layering, static Fan Speed needle and thermal flame shapes; its 96/96 Flutter test pass applies to the historical source/test blobs above. New assertions for the latest dashboard animation refresh have NOT RUN.

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
- Battery temperature: Ice Blue at or below 30°C, a smooth cyan/amber/orange transition from 30–40°C, and Burning Red at or above 40°C. At ≥40°C, elongated orange/gold fire embers with yellow-white cores fall behind the battery foreground. They are clipped OUTSIDE the shell; the battery body is painted above the particles. The warning threshold remains exactly 40°C.
- Hotside temperature: Ice Blue at or below 30°C, smooth transition above 30°C, and Burning Red with taller oval ember bursts exactly at the configured Hotside Limit. Embers fall in the canvas background, clipped OUTSIDE the raised thermometer silhouette; the tube and graduations stay above them. The visual palette/fill tracks the current limit; this visual warning must never alter or replace Firmware-owned safety behavior.
- Manual Voltage labels retain their semantic accent: 5V red, 9V green, 12V blue; unknown/disconnected voltage uses the 5V/lowest-voltage red fallback. The 5V/9V/12V rows stay neutral and the active toggle alone uses the theme primary color, without an extra check glyph. The shared switch helper and other control toggles keep their existing styling.
- Home indicator policy: when BLE is disconnected, every custom icon animation controller stops and resets immediately. While connected, Battery, Hotside and Voltage loop continuously—even if a sensor value is unknown (the number still stays “--”). Adaptive, Peltier, Fan, Fan Speed and LED animate only while their authoritative state is ON; OFF icons are static at their canonical pose. Bluetooth itself is always static and uses colour to show connection. The glyph’s semantic colour/opacity never dims between ON/OFF.
- Distinct effects remain bounded to established silhouettes: Battery and Hotside use top-down falling oval fire embers in the background, clipped OUTSIDE the foreground icon and active only at their exact warning thresholds; Voltage keeps a static bolt face/core while two phase-offset pulses travel only on the closed outer contour, with its existing 25%/50%/100% visual mapping for 5V/9V/12V; Peltier retains 25%/50%/100% frost and snow for 5V/9V/12V; Fan rotor speed follows 5V/9V/12V classes and, at 12V, actual PWM, with matching curved airflow streamlines; Fan Speed uses a stable, full-colour tick-mark gauge and smoothly retargeted live needle. Fan may coast down once when switched OFF while still connected, then stays still. These effects must never fabricate sensor values, voltage state, electrical current, or physical RPM.

## Display submenu locking and switch-row contract

- The five display submenus are Voltage (0), Control (1), Adaptive (2), LED (3) and Temperature (4). When Bluetooth is disconnected, a single overlay blurs the entire selected submenu content (including its heading and cards), dims it, and centers one lock panel over that area. The top-level tab strip and Home Bluetooth control remain outside the overlay and usable.
- Bluetooth lock copy: `CONNECT TO JE X FYZ FIRST` / `HUBUNGKAN KE JE X FYZ TERLEBIH DAHULU`. If connected but Adaptive is ON or transitioning, one matching overlay applies only to Voltage, Control and Temperature: `LOCKED BY ADAPTIVE MODE` / `TERKUNCI OLEH MODE ADAPTIF`. Adaptive and LED remain usable in Adaptive mode. Bluetooth lock takes priority.
- The overlay uses a single `ImageFiltered` blur plus one centered lock panel and an absorbing dim layer; the underlying submenu is under `IgnorePointer` so it cannot be operated through the blur. This is a presentation gate in addition to the existing per-control enable/command checks, not a replacement for them.
- Peltier, Adaptive, Fan and LED `_switchRow` controls match Manual Voltage’s visual convention: neutral row/icon surface, stable semantic icon colour, theme-primary toggle accent, no check mark in the knob and no ON/OFF text immediately before the toggle. Fan safety enablement, state telemetry, BLE command gating, and Fan Speed slider geometry/behavior remain unchanged.

## Floating Monitor presentation contract

- Exactly six metrics are supported: **B/H/V/A/P/F** — Battery Temperature, Hotside, Voltage, Adaptive, Peltier and Fan. F is labelled `Fan` / `Kipas`; it displays live PWM speed while running, localized OFF/MATI while the Fan is off, and `--` when disconnected; FPS is retired.
- Persisted metric schema version 2 migrates older schema-v1 configurations: old F (FPS) selections are discarded and old S (Speed) selections migrate to F. Config is normalized before it is sent to the native overlay so an old seven-metric order cannot reintroduce a retired metric.
- The display is Letters-only; legacy saved Icons configuration migrates to Letters and the style selector remains removed.
- Size slider is 0.30×–1.00× in 0.05× steps (14 intervals), default 0.60×. Persisted values snap into that range. Native pinch scaling and runtime geometry accept the same upper bound.
- Background opacity is 0–100% in 5% increments; the displayed number remains visible, but the 50% midpoint label is removed. Legacy values snap to the nearest 5%. Opacity affects the background only, not metric text.
- Horizontal metrics remain centered as one group. Vertical letter rows share a single left edge. The floating window remains freely draggable; WindowManager gravity stays TOP | START and saved position is unchanged.
- Floating Monitor has no Shizuku permission card or privileged FPS sampler. Fan Speed shows its live speed while Fan is on, localized OFF/MATI while Fan is off, and unknown (--) while disconnected.

## Controls and voltage

- Manual voltage levels: 5 V, 9 V, 12 V. Expected user touch cycle is 5→9→12→9→5, with the established ~1-second manual-switch guard.
- Voltage indicator LED default mapping: 5 V red, 9 V green, 12 V blue. Users can customize colors and reset to defaults.
- PWM Fan speed control belongs in the CONTROL submenu. Manual PWM control is available only in Manual mode at 12V, in 50–100% increments of 10; App control remains disabled during Adaptive.
- Adaptive Fan PWM is Firmware-owned. Current active source is `firmware/JEXFYZ-V7.1.ino` (blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`). Target bands at 12 V use floored whole-degree categories relative to configured Hotside Limit: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%. At limit 40°C: 40/39/38 →100%, 37/36 →90%, 35/34 →80%, 33/32 →70%, 31/30 →60%, ≤29 →50%. Bands move with the setting. Immediate raw-decimal Hotside safety remains Fan 100% and Peltier OFF at/above limit; Adaptive 5 V/9 V stays 100%. PWM pacing remains −10 points/10 seconds and +10 points/1 second. The owner subsequently confirmed V7.1 was compiled and installed via Online OTA. Exact source-to-BIN provenance and physical behavior remain independently UNVERIFIED.
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

- Six App modes use stable firmware IDs: 01 Static (1), 02 Breath (2), 03 Comet (4), 04 Dual Chase (5), 05 Left / Right (6), 06 Rainbow (7). ID 3 / Mirror Pulse is retired and never reused.
- Firmware V6.7 emits one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple, computed immediately before BLE notify. Mode, phase and cycle arrive atomically, and the phase does not age while waiting in the queue.
- The App interpolates the phase from a monotonic local clock and adjusts drift at later snapshots; a phase update must not restart the animation controller. Separate `LED_PHASE` and `LED_CYCLE_MS` handling remains a compatibility fallback for older V6.x firmware.
- Preview pixel order follows the physical strip: right top→bottom indices 0–3, left bottom→top indices 4–7. The compact layout is left arrow, four left LEDs, centered localized mode name only (no numeric index), four right LEDs, right arrow.
- LED-column backgrounds are slightly darker for contrast. Preview pixel visibility/glow is independent of the hardware Brightness slider, so colors stay vivid even at low hardware brightness; animation levels still distinguish the active mode. This does not change brightness commands or physical Firmware rendering.
- The separate Color Picker offers 36 curated hue-ordered presets without HEX labels, remains bottom-pinned in the safe area, and uses localized top-left Cancel and top-right Select actions. Swatch taps update only a local draft (checkmark, preview swatch and localized name); they do not send BLE COLOR or dismiss the panel. Select sends the draft through the existing confirmed COLOR command and closes only after success; a definite failure or missing confirmation leaves the dialog open and preserves the last applied RGB state. Cancel discards the draft and closes without sending RGB. Taps outside the panel and system Back are blocked, so the action buttons control dismissal. The outer panel is not draggable or wrapped in a vertical scroll view. Text/swatch sizing is enlarged for comfortable viewing while preserving the six-column palette. Names are localized and legacy aliases (including Cyan #00FFFF) remain; Brightness stays the single intensity control.
- Firmware migrates saved mode ID 3/invalid values to Static and rejects new MODE:3 commands. On older firmware that still reports ID 3, the App labels the mode Unsupported rather than rendering Mirror Pulse; the user can select a supported mode.
- Firmware safety/OTA indicators continue to override decorative RGB effects.
- Do not change settings storage or defaults without a scoped task and regression review.
- Firmware persistent preferences use a 10-second quiet period; Adaptive Profile itself is runtime-only. See `FIRMWARE_NOTES.md`.

## Floating Monitor implementation and current source state

- FloatingMonitorService owns the overlay window; Flutter remains the single BLE/GATT client and streams authoritative telemetry. After native service attachment, Flutter replays the current telemetry snapshot. Native layout/redraw tracks changing live-value width.
- The overlay remains freely draggable with WindowManager gravity TOP | START and persisted coordinates. Horizontal metrics center as one group; vertical letter rows all share the same left edge. Size is 0.30×–1.00× in 0.05× steps (default 0.60×). Background opacity is 0–100% in 5% steps with live percent and endpoint marks only; Black/White background and text contrast remain.
- Current metrics are B/H/V/A/P/F. F is labelled Fan/Kipas and displays live PWM speed while running. When BLE telemetry is disconnected, live device values are unknown (--) and no stale output state is inferred.
- FPS, SurfaceFlinger TimeStats sampling, Shizuku permission UI/provider/UserService/AIDL, related parser/watchdog tests and Shizuku-only license files are removed from active App source. The release workflow audit and source archive packaging no longer depend on them.
- Schema version 2 maps old schema-v1 S (Speed) to F (Fan Speed) and drops old schema-v1 F (FPS). Flutter contract tests cover migration and removal of FPS/Shizuku UI.
- Historical Build #83 / run 39192430789 was superseded by later App releases. Build #124 is the latest independently verified App package and includes the single-event Home NOTIFY behavior described above. Physical-phone rendering, animation smoothness, BLE telemetry and OTA/device behavior remain unverified by App CI.

## Phone battery telemetry and Battery Protection UI boundary

- The App reads Android battery temperature through the native `je_x_fyz/battery_temp` MethodChannel (`getBatteryTemperature`) and sends `PHONE:BT=<Celsius>` every 1 second while a BLE session is ready. Invalid/unavailable readings send the invalid sentinel rather than a stale temperature.
- The heartbeat queue coalesces pending battery messages so slow BLE transmission does not produce an unbounded backlog. Firmware considers phone Battery data valid only for its 5-second `BATTERY_VALID_TTL_MS`; when it expires, HOTSIDE_BATTERY behavior falls back to HOTSIDE control without silently changing the runtime-selected profile.
- Current Battery-zone setting defaults: 5 V threshold 25°C and 12 V threshold 35°C; current firmware has a 0.5°C zone hysteresis. Live source remains authoritative if these values change.
- **Permanent UI requirement:** do not display a standalone “Battery Protection Guard” badge/guard/status indicator in the App. This is a presentation rule, not permission to weaken thermal protection or suppress an independently actionable, localized safety/Notify message.
- **Pairing design requirement / implementation status not established:** the project intent is one authorized App identity/one key-lock pairing relationship per cooler firmware. Current source-level checks confirm encrypted/bonded BLE writes, but do not establish an exclusive one-App-only provisioning/lock mechanism end-to-end. Do not claim the exclusive pairing lock is implemented until its concrete source flow and physical pairing behavior are verified.

## Physical validation boundary

- Build #83 verifies the App source/test contracts, APK signing and published artifact bytes, but not OEM/phone rendering, animation smoothness, BLE connection/reconnect, live Fan Speed telemetry, exclusive pairing behavior, physical cooling/electrical safety, Firmware compile/source-to-BIN identity or end-to-end OTA/reboot/installed-version state.
- The workflow tag-ref correction was exercised successfully in Build #91; its Release metadata and `jexfyz-latest` tag matched that run's source SHA. The current generic-action glyph follow-up is newer than Build #91 and requires a separately authorized App Build to validate/release it.

## Settings presentation update — source only

- The About section, AboutSettingsPage, its reusable About row, and EN/ID labels were removed from Settings. General, Device and Firmware remain; Build #116 validated/released this removal. The newest flame-shape/NOTIFY-label follow-up has not been validated.
