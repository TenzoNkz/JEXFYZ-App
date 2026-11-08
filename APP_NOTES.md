# JE X FYZ / JE Cooler — App Behavior Reference

Purpose: canonical current App/UI/BLE/telemetry contract. Current source defines implementation; DESIGN_NOTES.md holds owner-approved screen-specific visual constraints; PRODUCT_DESIGN_CONSTITUTION.md defines cross-screen design principles; VISUAL_QUALITY_GATE.md defines evidence-based visual acceptance; CHANGELOG.md and APP_BUILD_REPORT.md hold history/evidence.

## Current source and release boundary — checked 2026-11-08

- Latest verified App release is Build #131 / [Actions run 42474266430](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42474266430), packaged source `b3c4fee432fddc49430840daeb1e2eecbe78a0db`. The detailed append-only build/artifact evidence is APP_BUILD_REPORT.md; live package identity is summarized in PROJECT_STATE.md.
- APK asset `723696457`: 54,849,627 bytes, SHA-256 `d614bc42c6270fa3de616d944d043fc833cd0ab0ffc391d89526627606c3ee35`; matching source ZIP asset `723696458`: 2,888,040 bytes, SHA-256 `cca5609e5a471f204118f2bdfc40e6aa0fa7dcb6dc151a4b306e6c9ca4615177`. Release and live tag both target the exact package source SHA; downloaded asset integrity/source marker and APK V1/V2/V3/certificate checks passed.
- Build #131 passed 142 Flutter tests, analyzer exit 0 with 25 info-level diagnostics, and the configured Android Gradle gate. Native Android JUnit tasks were `NO-SOURCE`. Hosted test rendering does not substitute for screenshot/OEM visual QA or a physical BLE session.
- The compact Settings/Connection pass is now released in Build #131. It reduces selected text, glyph and spacing values while preserving the Home-equivalent 360-dp canvas/DPI formula, inherited theme colors, localization, status colors, and interactive hit-area constraints. Automated widget regression coverage, including compact-theme checks at 350-dp/420-dp, passed in the full suite.
- Bluetooth scan-state presentation, manual/passive/one-shot scanner ownership and selected-device handoff fencing are included in the package. The full Flutter suite passed, including coordinator and source/widget regression coverage. This is CI evidence only; physical Android plugin/radio behavior remains to be tested after owner installation.
- Home Fan Speed explicitly resolves `JexText.of('fanSpeedLabel', lang)` using the captured locale; the fan switch and compact Floating Monitor F metric retain the short Fan/Kipas label.
- Owner previously reported installing/overwriting Build #128; the exact installed field APK was not independently identified. Build #131 installation is also not yet confirmed. Firmware V7.1 compile/Online OTA remains USER-REPORTED. App CI does not prove physical display, BLE/overlay/cooling, Firmware, BIN or OTA behavior.



## Bluetooth Connection sheet — scan presentation contract

- The sheet starts its initial scan after its first frame and observes `FlutterBluePlus.isScanning` separately from fresh `onScanResults`. The completed 10-second scan with no matching JE Cooler displays the localized not-found message instead of remaining on Scanning or showing cached results from an earlier scan.
- Permission denial, Bluetooth/legacy-location unavailability, scan startup/stream errors and active scanning have distinct localized message keys. A guarded retry handler is shared by the scan button and permission retry. Dismissing the sheet still stops scanning.
- These are App presentation/lifecycle states only. BLE P1 framing, UUIDs, GATT connection ownership, synchronization and authoritative telemetry contracts are unchanged. Manual-sheet ownership, async generation invalidation, serialized scanner operations and a connection-handoff fence lasting until `_bleConnecting` is assigned are coordinated by `ConnectionScanCoordinator` in current source; regression tests are present but NOT RUN.
- **Resolved regression finding (2026-11-08):** the stale inline-ternary assertion in `test/floating_monitor_layout_contract_test.dart` has been replaced with a helper/render contract for `connectionScanEmptyStateMessageKey(...)`, `JexText.of(messageKey, lang)` and the 12-dp message style. Execution remains NOT RUN.
- **Scanner ownership implementation (SOURCE IMPLEMENTED / NOT RUN):** a narrow `ConnectionScanCoordinator` now gives the manual Connection sheet exclusive temporary ownership, invalidates suspended passive attempts with generation tokens, serializes scanner stop/start commands and distinguishes neutral dismissal from device selection. Passive reconnect uses `onScanResults`; neutral dismissal resumes only after cleanup and existing Auto Connect gates are rechecked. No device reproduction has run; validate with the new deterministic coordinator tests and Android QA before release.
- The locked plugin version is `flutter_blue_plus 2.3.14`. Its [versioned API docs](https://pub.dev/packages/flutter_blue_plus/versions/2.3.14) specify that `onScanResults` clears between scans whereas `scanResults` can include previous results. Both the manual Connection UI and passive rediscovery now consume fresh `onScanResults` rather than allowing retained prior results to initiate a passive connection.
- **Independent review refinement (2026-11-08):** a simple manual-sheet-open boolean plus _cancelDisconnectRediscovery() was not sufficient because passive scanOnce() awaits permissions, adapter state, SDK and potentially location status. The coordinator now registers the attempt before those awaits, checks a generation token after each await, and serializes scanner commands.
- **Passive attempt lifetime correction (SOURCE IMPLEMENTED / NOT RUN):** the attempt token remains active for the full passive scan window; code awaits `FlutterBluePlus.isScanning.where((scanning) => !scanning).first` after `startScan()`, then rechecks the generation before `finally` releases the attempt. This is required because pinned FlutterBluePlus `startScan()` completes when scanning has started, not when it ends. One-shot Auto Connect/OTA now reserves a one-shot attempt synchronously before the first permission/adapter await. The lease excludes duplicate one-shot scans and passive rediscovery; opening the manual sheet or beginning a connection invalidates a pending lease. Every one-shot `startScan()`/`stopScan()` command is routed through the same FIFO operation queue and rechecks lease validity inside the queue. The lease spans the primary and fallback discovery sequence. This coordinates commands without holding the queue for the entire radio scan window.
- **Connection selection handoff fence (SOURCE IMPLEMENTED / NOT RUN): the sheet marks device selection before pop. `ConnectionScanCoordinator` retains a connection-handoff lock after neutral sheet ownership is released; `_connect()` begins that lock synchronously and clears it only after `_bleConnecting=true` is assigned. `_tryAutoConnect`, `_scanAndConnect(automatic:true)` and passive rediscovery all recheck the lock. This closes the await gap before `_bleConnecting` is set; runtime validation remains NOT RUN.
- **UI state correction:** a stopped scan updates the sheet's isScanning stream; the current UI does not use a fixed 10-second spinner. Premature passive stop can instead cause a premature completed/no-results presentation.
- **Retained result semantics:** `scanResults` may include previous scan results in flutter_blue_plus 2.3.14. Manual, passive and one-shot Auto Connect/OTA discovery now use fresh `onScanResults`. The one-shot fallback intentionally retains known-remote-ID-only matching because some ESP32-C3 advertisements omit the service UUID; it now accepts that fallback only from the fresh current scan, rather than retained results. Static source review verifies passive ownership remains active until `isScanning == false`. Runtime plugin behavior remains NOT RUN.

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

## English/Indonesian localization

- English and Indonesian are the two supported App locales. Every JexText table entry has both locale values; production callsites must use the semantically correct key rather than relying only on a valid translation existing.
- Keep component/metric names distinct from controls: Home/Fan speed controls use Fan Speed / Kecepatan Kipas; the Floating Monitor F metric and the Fan switch retain the compact Fan / Kipas label.
- Keep Hotside as the named product component in both locales. Adaptive control/status copy uses Adaptive Mode / Mode Adaptif. The Floating Monitor feature is presented as Floating Monitor / Monitor Melayang, including its Android foreground-service notification/channel copy.
- JexText.of asserts on absent keys or locale entries in debug builds while retaining the existing release fallback. `test/widget_test.dart` verifies every localization table entry has English and Indonesian copy and that unknown lookup keys assert in debug. Legacy Adaptive Profile (Sisi panas) and Peltier re-arm messages remain recognized when stored notices are re-localized.
- Source inspection only at this checkpoint; Flutter formatter, tests, analyzer and Android/device rendering have not run because Flutter/Dart/Android toolchains are unavailable in this environment.
