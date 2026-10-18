# JE X FYZ / JE Cooler — App Reference

This file is the durable App behavior/design contract. Live source and the current workflow remain authoritative.

## Latest verified release and current source — 2026-10-19

- Latest verified App release: Build #80 / [Actions run `39171729285`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39171729285), source/release commit `4e9f14b959cdbf60136158187db26d0bb65f6287`. All 21 workflow steps passed; Dart analysis had 23 info-level deprecations, **96/96 Flutter tests passed**, and Android configured compile/build, obfuscated APK, V1/V2/V3 signing/certificate, source ZIP, Release publishing and downloaded-asset verification passed.
- Native Kotlin/Java test compilation and `:app:testDebugUnitTest` were NO-SOURCE in Build #80; the configured Gradle gate passed but no native JUnit cases ran. Full evidence and digests are in `APP_BUILD_REPORT.md`.
- Floating Monitor supports B/H/V/A/P/F; F is Fan/Kipas and carries the live Fan Speed value. Schema v2 removes legacy F (FPS) and migrates S (Speed) to F.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) targets `4e9f14b959cdbf60136158187db26d0bb65f6287`. APK asset `654626935`, 54,620,251 bytes, SHA-256 `b403ccd3813f1974b82703730fce2c60bab972b067bc7ac4875d51d0e55558c6`; corresponding source ZIP asset `654626933`, 2,852,944 bytes, SHA-256 `bae47230267438073c9fd2bdf9ee58bfd768a5fcdfedf7102983c05dc23bf0cc`. Both were re-downloaded and verified.
- Build #80 is the latest verified APK. It includes the rounded TamperScreen text blocks and the state-gated Home indicator animation/toggle/menu-lock changes, but not the newest source-only cleanup that replaces the TamperScreen warning-icon wrapper with a direct static `Icon`. Physical phone rendering, animation smoothness, BLE/Fan Speed telemetry and hardware behavior remain NOT DEVICE-VERIFIED.

## Current source-only scope after Build #80

- **Current `main` has one small source-only UI follow-up after Build #80:** the TamperScreen warning glyph is now a plain Flutter `Icon` instead of the generic `JexAnimatedIcon.glyph` wrapper. Its glyph, size, color, surrounding frame, all 10 text blocks, every text string/order, typography and developer-contact action are unchanged. Current dashboard gating, color thresholds, BLE flow, menu locks and saved-setting behavior were audited; their existing implementations/contracts already match the agreed source rules, so they were not rewritten in this change. The user reports Firmware V6.7 compiled and was updated online; this remains USER-REPORTED without independent BIN/OTA/device verification.
- Flutter/Dart tests and analyzer were NOT RUN for this small source-only follow-up. The existing test contract was extended to assert that the TamperScreen warning uses a static Icon and not the animation wrapper. No App Build/release was started in this `Eksekusi Full` task. The current source cleanup is not in Build #80.
- Dashboard indicators now use integrated 2D silhouettes and restrained phase-continuous motion. Approved brand, grille/logo, cards, layout and control semantics remain unchanged.
- Labels: Indonesian dashboard `Suhu Panas`, English `Hotside Temperature` (Hotside is always unhyphenated); Floating Monitor F label `Kipas` / `Fan`; PWM setting `Kecepatan Kipas` / `Fan Speed`; RGB toggle `Daya RGB` / `RGB Power`; direction `Kiri / Kanan` / `Left / Right` without a center emoji/glyph.
- Adaptive Fan PWM at 12V is automatic only in Adaptive mode. Reaching the configured Hotside limit immediately forces Fan PWM to 100%.
- Downshift requires ten recent one-second NTC samples, their rolling average and every sample at/below `hotLimit - 2°C`, no meaningful warming trend, and one continuous stable 10-second interval. Decrease by 10 percentage points every 10 seconds, down to a 50% floor.
- Losing the safe margin or detecting a warming trend cancels downshift and raises PWM by 10 points per fresh one-second sample. Adaptive 5V/9V keep existing 100% Fan behavior. Existing Peltier/thermal safety logic retains authority.
- NTC acquisition remains one calibrated reading per second. Averaging is used only for Fan PWM downshift permission; no extra ADC reads or blocking timing loops were introduced.

## Tamper warning screen and developer contact — rounded text blocks included by Build #80

- The native launch gate in `MainActivity.isOfficialBuild()` allows local debug builds, then compares the installed APK signing certificate against the configured official production signer; an absent configured certificate, mismatch, or native exception rejects the launch. This is a signing-identity gate, not proof of detecting every possible tamper technique.
- On a rejected release launch, `main()` continues to mount only `TamperApp` / `TamperScreen`. The visible screen is deliberately opaque: JE X FYZ branding plus a dense, scrollable Indonesian slang/profanity wall. It does not explain the reason or display technical terms.
- The bottom-pinned `HUBUNGI DEVELOPER` button calls the existing `je_x_fyz/security` MethodChannel's `openDeveloperContact` method. Android dispatches `ACTION_VIEW` to `https://t.me/horizontalzzz`; the username/URL is not printed in the UI. Launch failure leaves the warning visible and does not grant entry.
- The certificate-verification decision is unchanged. The screen is triggered only by the existing official signing check returning false; ordinary application errors are not relabelled as tampering.
- Current source/test fingerprints after explicit static warning-icon cleanup: `lib/main.dart` `522e108dd78d9b413316a6c79c8a4f0144f5e58f`; `test/widget_test.dart` `5098c30291cbd70422cd351f03cd9325f0870258`. Build #80 included the rounded-box layout, but not this direct-Icon source cleanup.
- The widget contract covers visible-copy restrictions, developer-contact behavior, rounded text-block layout and the now-explicit static warning icon. Flutter tests/Dart analysis were NOT RUN for this follow-up; source assertions were inspected only. No new APK or physical-device validation occurred.

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
- Battery temperature: Ice Blue at or below 30°C, a smooth cyan/amber/orange transition from 30–40°C, and Burning Red at or above 40°C. Battery thermal fill uses the same 30–40°C band; at ≥40°C the icon also emits a dense, bounded full-strength ember/flame effect. The warning threshold is exact.
- Hotside temperature: Ice Blue at or below 30°C, smooth transition above 30°C, and Burning Red with dense full-strength embers exactly at the configured Hotside Limit. The visual palette/fill tracks the current limit; this visual warning must never alter or replace Firmware-owned safety behavior.
- Manual Voltage labels retain their semantic accent: 5V red, 9V green, 12V blue; unknown/disconnected voltage uses the 5V/lowest-voltage red fallback. The 5V/9V/12V rows stay neutral and the active toggle alone uses the theme primary color, without an extra check glyph. The shared switch helper and other control toggles keep their existing styling.
- Home indicator policy: when BLE is disconnected, every custom icon animation controller stops and resets immediately. While connected, Battery, Hotside and Voltage loop continuously—even if a sensor value is unknown (the number still stays “--”). Adaptive, Peltier, Fan, Fan Speed and LED animate only while their authoritative state is ON; OFF icons are static at their canonical pose. Bluetooth itself is always static and uses colour to show connection. The glyph’s semantic colour/opacity never dims between ON/OFF.
- Distinct effects remain clipped/bounded to the established silhouettes: Battery and Hotside use a dense, full-strength flame/ember layer only at their exact warning thresholds; Voltage has 25%/50%/100% lightning detail for 5V/9V/12V; Peltier has 25%/50%/100% frost and snow for 5V/9V/12V; Fan rotor speed follows 5V/9V/12V classes and, at 12V, actual PWM, with matching curved airflow streaks; Fan Speed uses a stable, full-colour tick-mark gauge and smoothly retargeted live needle. Fan may coast down once when switched OFF while still connected, then stays still. These effects must never fabricate sensor values, voltage state, or physical RPM.

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
- PWM Fan speed control belongs in the CONTROL submenu; increments should be practical (multiples of 5 or 10).
- Manual PWM control remains available only in Manual mode at 12V. Adaptive manages PWM automatically at 12V; Adaptive at 5V or 9V retains established full-speed Fan behavior.
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
- Build #80 is the latest verified release (run `39171729285`, source/release `4e9f14b959cdbf60136158187db26d0bb65f6287`); 96/96 Flutter tests and all 21 workflow steps passed. It includes the TamperScreen rounded-block layout and the current Hotside/animation/toggle/menu-lock UI work. The explicit direct-Icon warning-symbol cleanup is source-only after Build #80; tests and analyzer have not run for that final delta. Phone overlay visuals and live BLE telemetry remain unverified.

## Phone battery telemetry and Battery Protection UI boundary

- The App reads Android battery temperature through the native `je_x_fyz/battery_temp` MethodChannel (`getBatteryTemperature`) and sends `PHONE:BT=<Celsius>` every 1 second while a BLE session is ready. Invalid/unavailable readings send the invalid sentinel rather than a stale temperature.
- The heartbeat queue coalesces pending battery messages so slow BLE transmission does not produce an unbounded backlog. Firmware considers phone Battery data valid only for its 5-second `BATTERY_VALID_TTL_MS`; when it expires, HOTSIDE_BATTERY behavior falls back to HOTSIDE control without silently changing the runtime-selected profile.
- Current Battery-zone setting defaults: 5 V threshold 25°C and 12 V threshold 35°C; current firmware has a 0.5°C zone hysteresis. Live source remains authoritative if these values change.
- **Permanent UI requirement:** do not display a standalone “Battery Protection Guard” badge/guard/status indicator in the App. This is a presentation rule, not permission to weaken thermal protection or suppress an independently actionable, localized safety/Notify message.
- **Pairing design requirement / implementation status not established:** the project intent is one authorized App identity/one key-lock pairing relationship per cooler firmware. Current source-level checks confirm encrypted/bonded BLE writes, but do not establish an exclusive one-App-only provisioning/lock mechanism end-to-end. Do not claim the exclusive pairing lock is implemented until its concrete source flow and physical pairing behavior are verified.

## Current App QC boundary

- Latest verified release: Build #80 / run `39171729285`, released source commit `4e9f14b959cdbf60136158187db26d0bb65f6287`. 96/96 Flutter tests and all 21 workflow steps passed; native JUnit tasks were NO-SOURCE. The APK/source ZIP asset identifiers and hashes are recorded in the current release summary at the start of this file and in `APP_BUILD_REPORT.md`.
- 91/91 Flutter tests passed in Build #73. Dart analysis and all 21 active release workflow steps passed, including Android production compile/configured gate, obfuscated APK, V1/V2/V3 certificate checks, matching source ZIP and re-downloaded Release asset verification. Native JUnit tasks were NO-SOURCE after FPS-specific native test files were removed; no native JUnit cases ran. Follow-up Hotside/animation/toggle/menu-lock changes are source-only, and their added tests/analysis were not run.
- APK asset `652517541`, 54,538,331 bytes, SHA-256 `90ed2f36658ea0e4fa487d43ea7e4347545c9875b13d703ec9c2765445eea48b`. Matching source ZIP asset `652517543`, 2,846,735 bytes, SHA-256 `ed7429aa9f6cb36e327d6d7b85efdf0b895ee8529c09a159053b98c8628902ef`. Certificate/warning/step detail remains in APP_BUILD_REPORT.md.
- Physical overlay layout, live BLE telemetry/Fan Speed value, phone animation and actual BLE/Firmware/thermal/OTA behavior remain UNVERIFIED. Build #73 was App-only and does not prove physical behavior.
