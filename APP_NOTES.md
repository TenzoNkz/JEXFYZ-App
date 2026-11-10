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

- The sheet starts its initial scan after its first frame and observes `FlutterBluePlus.isScanning` separately from fresh `onScanResults`. A completed scan with no matching JE Cooler displays the localized not-found message rather than remaining on Scanning or showing cached results from an earlier scan.
- Permission denial, Bluetooth/legacy-location unavailability, scan startup/stream errors and active scanning have distinct localized message keys. A guarded retry handler is shared by the scan button and permission retry. Dismissing the sheet still stops scanning.
- Manual-sheet ownership, asynchronous generation invalidation, serialized scanner operations and a connection-handoff fence until `_bleConnecting` is assigned are coordinated by `ConnectionScanCoordinator`. Passive reconnect uses fresh `onScanResults`; neutral dismissal resumes only after cleanup and existing Auto Connect gates are rechecked.
- A passive scan reservation begins before asynchronous permission/adapter checks and remains active for the entire radio scan window. The implementation waits for `FlutterBluePlus.isScanning` to become false before releasing the lease, then rechecks its generation token.
- One-shot Auto Connect/OTA reserves a coordinator token synchronously before permission/adapter awaits, excludes overlapping passive/one-shot scans, and invalidates a pending attempt when manual-sheet ownership or connection handoff begins. All one-shot scanner start/stop commands pass through the shared FIFO queue with an in-queue token check; the lease spans primary and fallback discovery without holding the queue through the entire radio scan.
- Primary and fallback discovery use fresh `onScanResults`. The known-remote-ID fallback remains available for ESP32-C3 advertisements that omit the 128-bit service UUID, but only current-scan results can initiate the fallback connection. The pinned `flutter_blue_plus 2.3.14` plugin may retain previous values in `scanResults`; `onScanResults` is the fresh per-scan stream.
- The manual Connection UI has distinct scanning, completed-no-result, permission-required, adapter/location unavailable and scan-failed presentations. A stopped scan updates the plugin lifecycle stream; the UI does not rely on a fixed 10-second spinner.
- Regression assertions for layout source shape, Fan Speed callsite structure and await-safe BLE cancellation were repaired after Build #130 and passed in Build #131. The full hosted Flutter suite passed 142/142; this validates automated App behavior/contracts, not real radio timing or OEM behavior.
- **Physical validation remains pending:** after Build #131 is installed, test passive rediscovery, prerequisite cancellation, manual-sheet open/neutral dismissal, selected-device handoff, fresh primary/fallback advertisements, adapter loss and reconnect on the real phone/cooler. BLE P1 UUIDs, framing, GATT connection/session synchronization and authoritative telemetry semantics remain unchanged.



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

### Home indicators and NOTIFY — Light Mode contrast repair (2026-11-09)

- **Status:** SOURCE IMPLEMENTED / NOT RUN. This is an App-only presentation repair committed during the explicitly authorized `@Pikirkan Eksekusi Full!` task. It is not included in the Build #131 package and is NOT RELEASED.
- `JexAnimatedIcon` and `_JexIconPainter` now receive Light Mode state plus surface/outline colors from the inherited Home theme. Battery, Hotside, Voltage, Adaptive, Peltier, Fan and Fan Speed depth layers route through theme-aware paint helpers. The Dark Mode branch retains the previous hard-coded depth/cavity colors. Painter theme changes are included in `shouldRepaint`.
- `_homeMetric()` uses the contrast-safe `lightThemeAccentText()` helper for Light Mode value text only. The helper searches HSL lightness toward a foreground that meets a minimum 4.5:1 ratio against the active surface. Dark Mode still uses the original accent directly. Label typography, card/tile geometry and 45 dp metric rows remain unchanged.
- `_homeNotify()` separates its semantic foreground from the pastel status tint. Light Mode uses success `#027A48`, warning `#B54708`, error `#B42318` for the icon and localized Notification/Notifikasi heading; the original mint/amber/coral fill tint, status predicates, body copy, priority, 44 dp geometry, left alignment and no-badge design remain. Dark Mode keeps its original foreground colors.
- Regression source in `test/widget_test.dart` covers painter token propagation/theme repaint, Light/Dark palette branches including Adaptive and Hotside, metric 4.5:1 assertions across semantic accent families, NOTIFY foreground compositing against status tints, and unchanged Dark Mode mapping/layout/source structure.
- **Commits:** latest `lib/main.dart` commit `ab833650ff14f9d3b2ea0c7048902826693a57b6` (blob `0d90b418c9140cfbb6090f2723ab24c8fbd5e9fc`); latest `test/widget_test.dart` change commit `66bb5008398b6e2b79aec276018ede9c391a8f75` (blob `9d348949091603c444a8339571b49cf7b5697a7e`). The latest test change aligns success/warning tint fixtures to the source's actual `.07` alpha. Full commit history is retained on `main`.
- **Evidence:** STATIC SOURCE CHECK only. Both changed Dart files passed a lexical delimiter-balance scan; changed source and tests were fetched back from GitHub and old painter-literal source assertions were removed/migrated while geometry/state assertions remain.
- **Not run / unverified:** Flutter formatter, focused widget tests, full `flutter test`, `flutter analyze`, screenshots and physical/OEM display review. The current runtime lacks Flutter, Dart, Gradle and ADB. Report these as BLOCKED / NOT RUN; visual status is `VISUAL NOT VERIFIED`.
- Build #131 remains the latest verified release. No App Build, APK/Release, Firmware, BIN, Firebase, OTA, flash or device operation occurred. A later package requires separate `Eksekusi Build App!`.

## Usage Statistics — App-only implementation contract (2026-11-09)

**Owner direction:** do not add a standalone Firmware timer for now. Prefer a Usage Statistics / Statistik Penggunaan page inside Settings, showing historical telemetry and Operating Profile so the owner can draw conclusions from actual cooler use.

### Settings navigation and page hierarchy

- Add a distinct **Statistics / Statistik** section to `SettingsPage` (currently in `lib/floating_monitor.dart`), after Device and before Firmware, with one `Usage Statistics / Statistik Penggunaan` entry. Open it as a Settings subpage using the established `JexFixedScalePage(compactUi: true, ...)` contract.
- The page is vertically scrollable and uses the existing Settings compact visual system, light/dark themes, English/Indonesian localization and the established 360-dp canvas/DPI behavior.
- Default period selector proposal: 1 hour, 24 hours, 7 days and 30 days. Open at 24 hours unless product review selects another default.

### Requested data presentation

1. **Phone Battery Temperature / Suhu Baterai HP** — first trend chart. Show actual phone battery temperature in °C, with minimum, maximum and duration-weighted average for the selected period. Label it as the phone battery, not an unspecified cooler battery.
2. **Hotside Temperature / Suhu Hotside** — second trend chart. Show actual NTC Hotside temperature in °C, minimum/maximum/duration-weighted average and a reference line for the current configured Hotside limit. Invalid NTC / `--` creates a gap, never zero.
3. **Operating Profile Timeline / Riwayat Operasi** — one shared time axis with three separate lanes: Voltage as 5V/9V/12V step states; Adaptive as ON/OFF state intervals; Fan Speed as a percentage step line. Keep their units/legends separate rather than plotting unlike scales as one temperature curve. Optional summary: time spent at each rail, Adaptive active duration, average/maximum Fan Speed.

### Capture and truth rules

- Record only while the App has a valid synchronized BLE/P1 session and is receiving real values. Do not fabricate values or infer a physical state from command ACK alone.
- Phone Battery temperature comes from the existing Android `getBatteryTemperature` reader (`_readBatteryTemperatureOnce()`), already scheduled at 1 Hz during the connected telemetry session. Record a timestamped sample on valid value change; invalid/unavailable readings create a gap.
- Hotside comes from authoritative Firmware `HOT` telemetry, already delivered on the existing ~1 Hz scheduler. Record at most one sample per received telemetry tick and write only when the numeric value changes (or validity changes).
- Voltage, Adaptive ON/OFF and Fan Speed are event-driven state changes. Record an initial baseline from the completed P1 full sync and subsequent records only when the corresponding telemetry state changes. Do not invent per-second state samples.
- Timestamp every record in UTC/epoch and render it in the phone's local timezone. Keep records keyed by cooler identity so separate devices are not silently merged.
- If the BLE session disconnects, App process stops receiving telemetry, the phone Battery reading is invalid, or NTC becomes invalid, close the current data segment and render a visible gap. On reconnect, begin a new segment from the new verified full-sync snapshot; never draw a continuous line across an unobserved interval.
- Because temperature points are stored only when values change, chart drawing holds the last valid value horizontally until the next changed sample, but only inside a confirmed observation segment. Compute average as duration-weighted (not a simple arithmetic average of change events); min/max use valid observations.

### Local storage and retention proposal

- Keep statistics on the Android App locally. Do not send raw history to Firebase and do not persist it in Firmware NVS. Existing `AppSettingsStore` / `flutter_secure_storage` is for small user preferences and is not a time-series database.
- Current source uses App-local SQLite (`sqflite` 2.4.2) behind a repository boundary and custom Flutter painters; no additional chart package is used. The database stores changed temperature values and authoritative state-change events.
- Current implementation retains changed-value temperature events and operating-state events for 30 days. It does not yet build 1-minute rollup tables; do not describe the retained history as aggregated. Database growth under sustained high-change telemetry remains a validation item. Clear Statistics requires confirmation.
- Recording is submitted to a serialized asynchronous queue so BLE parsing/UI do not await SQLite operations. The queue is not currently bounded or coalesced and is not batch-written; stress/backpressure validation remains open. A local write exception is retained for the current process and surfaced as a recording warning on the Statistics page. Collection is not dependent on the page being open.

### User-visible limitation

- Statistics represent periods when the App's connected-device service actually received telemetry. They are not guaranteed full-day hardware logs while BLE is disconnected, App is force-stopped, or Android does not deliver the connected-device session. Show coverage / missing-data gaps and the last-recorded timestamp so the graph is not misleading.

**Status:** SOURCE IMPLEMENTED / VALIDATION NOT RUN. Live source contains SQLite persistence, P1-session recording, Settings navigation, period selector, charts/timelines and clear-history flow. The 30D selector and 30-day event retention are now present. Focused tests are committed but not executed in this runtime; visual/device acceptance remains unverified. App packaging still requires separate `Eksekusi Build App!`.

### Static source audit follow-up — 2026-11-10

- Live-source review confirms the recording boundary is after completed P1 synchronization; HOT freshness bounds the operating timeline, Phone Battery freshness is tracked separately, invalid temperature readings create gaps, and sessions are closed on disconnect/process interruption. Settings navigation, duration-weighted summaries and event-driven state lanes are present in source.
- **Display accuracy correction — 2026-11-10:** the “Last value change” label now uses `UsageStatsAnalytics.lastTemperatureChangeAtMs(snapshot)` to select the latest valid persisted Battery/Hotside temperature event, bounded by its owning session and the snapshot end. Synthetic held-value chart endpoints are no longer used for this label. A focused widget regression test supplies an earlier Battery baseline, a later Hotside event and a still-later unchanged-sensor freshness endpoint; it asserts the displayed time is the persisted event time. SQLite schema and chart sample-and-hold behavior are unchanged.
- The serialized recorder write queue still has no explicit bound/coalescing, and the 30-day raw event store has not been stress-measured. These remain validation risks, not observed runtime failures.
- Validation remains **STATIC SOURCE CHECK / FLUTTER VALIDATION NOT RUN**. The source and regression test were committed and read back from `main`; Flutter/Dart/Gradle/ADB are unavailable here, so formatter, focused test, full suite, analyzer, screenshot, physical-device and App Build results are not claimed.
- Live tag `jexfyz-latest` resolves to source `5201a3e07f36305ffe3882a1b965b9e7414cd71a`; `main` is 57 commits ahead; the comparison shows the feature source and tests were added after that tag. Usage Statistics is therefore **not included in the currently tagged package**.

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
