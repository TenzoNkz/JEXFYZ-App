# JE X FYZ / JE Cooler — App Behavior Reference

Purpose: canonical current App/UI/BLE/telemetry contract. Current source defines implementation; DESIGN_NOTES.md holds owner-approved screen-specific visual constraints; PRODUCT_DESIGN_CONSTITUTION.md defines cross-screen design principles; VISUAL_QUALITY_GATE.md defines evidence-based visual acceptance; CHANGELOG.md and APP_BUILD_REPORT.md hold history/evidence.

## Current source and release boundary — checked 2026-11-11

- Latest verified App package: **Build #149**, Actions run [42967289995](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42967289995), built from source SHA `0507e3e11b67b8f8d042e49b74cc14a53bfc4f21`. Current Release/tag identity, asset hashes and full QC evidence are maintained in `PROJECT_STATE.md` and `APP_BUILD_REPORT.md`; those files remain the detailed release authorities.
- Build #149 passed the security/architecture audit, analyzer (23 info-level findings, zero warnings/errors), and **166/166 Flutter tests**. The Android Gradle gate succeeded, but the app's Android JUnit compile/test tasks were `NO-SOURCE`; no native app JUnit case ran. Hosted CI is not screenshot/OEM or physical-device acceptance.
- Compact Settings/Connection sizing, Bluetooth scan-state presentation and scanner-ownership/handoff regression coverage are included in the current Build #149 package. Their automated App contracts passed in the hosted suite; real Android/OEM layout and BLE-radio behavior still require field validation.
- The Home Default-hybrid contrast repair passed hosted CI in Build #143 and is included in the later Build #149 source package. Its actual installed-device appearance is still not visually accepted until owner screenshots/OEM rendering are inspected.
- **Field acceptance remains pending:** the exact APK installed by the owner is not independently identified. Validate Home, Settings/Connection, dialogs and Usage Statistics on the actual phone; physical BLE lifecycle, live sensor-history soak and thermal/electrical cooling behavior remain unverified. Firmware/BIN/Firebase/OTA/flash status must not be inferred from App CI.

## Peltier safety dialog and LED Color Picker — current main source refinement (2026-11-11)

- Current `main` contains an unreleased refinement newer than Build #149. Build #149 remains the latest published package and does not contain these latest modal changes.
- Peltier popup now targets an approximately 312-dp card width inside the existing 360-dp fixed canvas, uses 18/14/14 dp title/body/actions and tightened vertical padding. Cancel/Fan targets remain 48 dp high. English/Indonesian copy is shorter. Fan-first safety and existing command/ACK sequence are unchanged.
- LED Color Picker has 60 unique named colors with complete English/Indonesian localization, six columns, internal scrolling, 48×48 dp hit cells and 32×32 dp swatches. Names now match standard HEX values where available. Preview, tooltip, accessibility label, draft selection, Cancel and explicit Select/commit share the same color name/value mapping. Legacy stored RGB aliases remain supported.
- Source and regression-test files are committed, but Flutter/Dart are unavailable locally and no formatter, local tests, analyzer, hosted CI, new APK or visual screenshot validation has run for this refinement. Visual status remains VISUAL NOT VERIFIED until real screenshots are inspected.


## Owner-requested Lock Voltage 5V — App presentation contract (2026-11-11; pending implementation)

- Add a Settings control named **Lock Voltage** / **Kunci Tegangan**. Its persisted authority is Firmware ESP32 Preferences/NVS, not Android SharedPreferences. The value is learned from a new Firmware P1 full-sync/state field such as VOLTAGE_LOCK.
- ON locks actual Firmware rail requests to 5 V, disables the App's 9 V/12 V Voltage controls and disables the Adaptive switch/profile controls with visible lock treatment. Keep Home metrics truthful: Voltage reflects actual telemetry (5 V once handoff completes) and Adaptive reflects actual OFF state; show a lock marker rather than inventing values.
- On enable from 9/12 V or Adaptive ON, show an in-progress/locked state until authoritative Firmware telemetry confirms Adaptive OFF and Voltage 5 V. Do not optimistically paint the rail as 5 V before the transition completes.
- The Lock Voltage setting remains available only when the BLE/P1 session is ready and Firmware's lock state has been synchronized. Before full sync or while disconnected, do not default the value to OFF or use stale Android storage as authority.
- OFF is sent explicitly through the App setting. Firmware persists the change before acknowledging. Unlocking only removes the rail ceiling; do not automatically restore a prior 9/12 V voltage or enable Adaptive. Remain at 5 V until the user selects a new mode.
- Localize title, supporting copy, ON/OFF, lock status, pending 5 V handoff, persistence-error and retry messages in English/Indonesian. If runtime Lock is ON but VOLTAGE_LOCK_SAVED is OFF, keep Voltage/Adaptive locked and clearly warn that the lock is only active for this session until NVS saving succeeds.
- If an App voltage request is rejected specifically because Lock Voltage is ON, show a concise localized explanation; Firmware also emits its two-red-flash rejection signal. Firmware remains the enforcement point even when an older App still exposes manual buttons.
- App-only security caveat: current BLE bonding/Just Works + P1 readiness do not authenticate the official App. Strict prevention of third-party BLE clients unlocking the feature requires the separate BLE App authentication design; do not imply that this UI-only change solves it.
- No App source/test is changed by this Discussion. The feature is part of the pending cross-layer Firmware V7.2 implementation scope and still needs a separate guarded App Build after source work.


## Bluetooth Connection sheet — scan presentation contract

- The sheet starts its initial scan after its first frame and observes `FlutterBluePlus.isScanning` separately from fresh `onScanResults`. A completed scan with no matching JE Cooler displays the localized not-found message rather than remaining on Scanning or showing cached results from an earlier scan.
- Permission denial, Bluetooth/legacy-location unavailability, scan startup/stream errors and active scanning have distinct localized message keys. A guarded retry handler is shared by the scan button and permission retry. Dismissing the sheet still stops scanning.
- Manual-sheet ownership, asynchronous generation invalidation, serialized scanner operations and a connection-handoff fence until `_bleConnecting` is assigned are coordinated by `ConnectionScanCoordinator`. Passive reconnect uses fresh `onScanResults`; neutral dismissal resumes only after cleanup and existing Auto Connect gates are rechecked.
- A passive scan reservation begins before asynchronous permission/adapter checks and remains active for the entire radio scan window. The implementation waits for `FlutterBluePlus.isScanning` to become false before releasing the lease, then rechecks its generation token.
- One-shot Auto Connect/OTA reserves a coordinator token synchronously before permission/adapter awaits, excludes overlapping passive/one-shot scans, and invalidates a pending attempt when manual-sheet ownership or connection handoff begins. All one-shot scanner start/stop commands pass through the shared FIFO queue with an in-queue token check; the lease spans primary and fallback discovery without holding the queue through the entire radio scan.
- Primary and fallback discovery use fresh `onScanResults`. The known-remote-ID fallback remains available for ESP32-C3 advertisements that omit the 128-bit service UUID, but only current-scan results can initiate the fallback connection. The pinned `flutter_blue_plus 2.3.14` plugin may retain previous values in `scanResults`; `onScanResults` is the fresh per-scan stream.
- The manual Connection UI has distinct scanning, completed-no-result, permission-required, adapter/location unavailable and scan-failed presentations. A stopped scan updates the plugin lifecycle stream; the UI does not rely on a fixed 10-second spinner.
- Regression assertions for layout source shape, Fan Speed callsite structure and await-safe BLE cancellation were repaired after Build #130 and remain included in the later Build #149 source package. The full hosted Flutter suite passed 166/166; this validates automated App behavior/contracts, not real radio timing or OEM behavior.
- **Physical validation remains pending:** after Build #149 is installed, test passive rediscovery, prerequisite cancellation, manual-sheet open/neutral dismissal, selected-device handoff, fresh primary/fallback advertisements, adapter loss and reconnect on the real phone/cooler. BLE P1 UUIDs, framing, GATT connection/session synchronization and authoritative telemetry semantics remain unchanged.



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

- **Status:** SOURCE IMPLEMENTED / VERIFIED CI in Build #143; included in the later Build #149 package. This is an App-only presentation repair. Hosted CI validates automated contracts only; field screenshots/OEM appearance remain pending.
- `JexAnimatedIcon` and `_JexIconPainter` now receive Light Mode state plus surface/outline colors from the inherited Home theme. Battery, Hotside, Voltage, Adaptive, Peltier, Fan and Fan Speed depth layers route through theme-aware paint helpers. The Dark Mode branch retains the previous hard-coded depth/cavity colors. Painter theme changes are included in `shouldRepaint`.
- `_homeMetric()` uses the contrast-safe `lightThemeAccentText()` helper for Light Mode value text only. The helper searches HSL lightness toward a foreground that meets a minimum 4.5:1 ratio against the active surface. Dark Mode still uses the original accent directly. Label typography, card/tile geometry and 45 dp metric rows remain unchanged.
- `_homeNotify()` separates its semantic foreground from the pastel status tint. Light Mode uses success `#027A48`, warning `#B54708`, error `#B42318` for the icon and localized Notification/Notifikasi heading; the original mint/amber/coral fill tint, status predicates, body copy, priority, 44 dp geometry, left alignment and no-badge design remain. Dark Mode keeps its original foreground colors.
- Regression source in `test/widget_test.dart` covers painter token propagation/theme repaint, Light/Dark palette branches including Adaptive and Hotside, metric 4.5:1 assertions across semantic accent families, NOTIFY foreground compositing against status tints, and unchanged Dark Mode mapping/layout/source structure.
- **Commits:** latest `lib/main.dart` commit `ab833650ff14f9d3b2ea0c7048902826693a57b6` (blob `0d90b418c9140cfbb6090f2723ab24c8fbd5e9fc`); latest `test/widget_test.dart` change commit `66bb5008398b6e2b79aec276018ede9c391a8f75` (blob `9d348949091603c444a8339571b49cf7b5697a7e`). The latest test change aligns success/warning tint fixtures to the source's actual `.07` alpha. Full commit history is retained on `main`.
- **Evidence:** STATIC SOURCE CHECK only. Both changed Dart files passed a lexical delimiter-balance scan; changed source and tests were fetched back from GitHub and old painter-literal source assertions were removed/migrated while geometry/state assertions remain.
- **Not run / unverified:** a real screenshot from the owner's installed Build #149, OEM rendering and physical-device visual review. Build #149 hosted CI ran the analyzer and full Flutter suite successfully; a separate formatter run is not recorded. Visual status remains `VISUAL NOT VERIFIED` until actual rendered evidence is inspected.
- Build #149 is the latest verified release. This Diskusi did not trigger an App Build or perform any Firmware, BIN, Firebase, OTA, flashing or device operation. Any later package requires a separate `Eksekusi Build App!`.

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
- Phone Battery temperature comes from the existing Android `getBatteryTemperature` reader (`_readBatteryTemperatureOnce()`), scheduled at 1 Hz during the connected telemetry session. The current recorder persists every observation, including an unchanged value; invalid/unavailable readings create an explicit gap.
- Hotside comes from authoritative Firmware `HOT` telemetry, delivered on the existing ~1 Hz scheduler. The current recorder persists every received sample tick, including unchanged values; invalid NTC readings create an explicit gap.
- Voltage, Adaptive ON/OFF and Fan Speed are event-driven state changes. Record an initial baseline from the completed P1 full sync and subsequent records only when the corresponding telemetry state changes. Do not invent per-second state samples.
- Timestamp every record in UTC/epoch and render it in the phone's local timezone. Keep records keyed by cooler identity so separate devices are not silently merged.
- If the BLE session disconnects, App process stops receiving telemetry, the phone Battery reading is invalid, or NTC becomes invalid, close the current data segment and render a visible gap. On reconnect, begin a new segment from the new verified full-sync snapshot; never draw a continuous line across an unobserved interval.
- Temperature chart statistics use timestamp-weighted coverage and valid samples, not a simple average of state changes. Missing/invalid intervals remain gaps and must not be connected or interpolated across.

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
- **Display accuracy correction — 2026-11-10:** the “Last value change” label now uses `UsageStatsAnalytics.lastTemperatureChangeAtMs(snapshot)` to select the latest valid persisted Battery/Hotside temperature event, bounded by the owning session's actual end (`endedAtMs`, or `snapshot.toMs` while active) so the two sensors retain independent freshness. Synthetic held-value chart endpoints are no longer used for this label. A focused widget regression test supplies an earlier Battery baseline, a later Hotside event and a still-later unchanged-sensor freshness endpoint; it asserts the displayed time is the persisted event time. SQLite schema and chart sample-and-hold behavior are unchanged.
- The serialized recorder write queue still has no explicit bound/coalescing, and the 30-day raw event store has not been stress-measured. These remain validation risks, not observed runtime failures.
- Validation remains **STATIC SOURCE CHECK / FLUTTER VALIDATION NOT RUN**. The source and regression test were committed and read back from `main`; Flutter/Dart/Gradle/ADB are unavailable here, so formatter, focused test, full suite, analyzer, screenshot, physical-device and App Build results are not claimed.
- Live tag `jexfyz-latest` resolves to source `5201a3e07f36305ffe3882a1b965b9e7414cd71a`; the Usage Statistics source and regression test were added to `main` after that package tag. Usage Statistics is therefore **not included in the currently tagged package**.

### Owner follow-up — professional animated multi-metric diagrams (2026-11-10 to 2026-11-11)

**Status: SOURCE IMPLEMENTED / PRE-BUILD REVIEW INCOMPLETE / NOT RELEASED.** The owner requested a more professional Usage Statistics page, smooth transitions and a diagram for each tracked operating value. “AI mode” maps to the existing **Adaptive Mode / Mode Adaptif** feature. Implementation is committed on `main`; hosted analyzer, Flutter tests, Android gate and APK Build have not run for this source.

**Implemented in live App source:**
- `lib/main.dart`: captures Peltier baseline from the synchronized full-session state and records only telemetry-confirmed `PELTIER` events. No command ACK is used as physical-state evidence.
- `lib/usage_statistics.dart`: adds Peltier state events/duration, a live telemetry-delta stream, six-metric cursor readout, two animated temperature charts, discrete Voltage/Adaptive/Peltier timelines and a Fan Speed 0–100% area/step chart.
- Temperature and Fan Speed presentation tweens use Flutter `AnimationController`/vsync; there is no 1-ms polling loop. Live Statistics diagram batches flush once per second via `usageStatisticsDiagramRefreshInterval`; raw Battery/Hotside collection, recorder events and SQLite persistence remain independent and unchanged.
- Long temperature paths use extrema/gap-aware render decimation while summaries and stored observations remain full-resolution. Cursor readout uses the same elapsed timestamp across Battery, Hotside, Voltage, Adaptive, Peltier and Fan Speed.
- Live session coverage is capped by the latest fresh Firmware HOT heartbeat. Battery phone samples cannot extend a P1 operating-session timeline after HOT becomes stale. Invalid sensor samples and session boundaries remain explicit chart gaps.
- `test/usage_statistics_test.dart`: adds coverage for Peltier state/duration and exact transition boundaries, HOT-coverage expiry, bounded interpolation, render decimation/gap retention, Peltier chart presence and the synchronized chart cursor at compact widths.

**Current source evidence at latest pre-documentation HEAD `e1b43200d276808fa5b37612d32f0f71f4ea1420`:** `lib/usage_statistics.dart` blob `2c175ba727b5d06137b6e69fa8151f99c833b56c`; `lib/main.dart` blob `56e71dcaa482cabddd141cd3ae5c6cf28437ada7`; `test/usage_statistics_test.dart` blob `e99b1bcab8ad7e0df4fb494eeb6a90306c480524`. This HEAD is newer than Build #143 and is NOT in the current `jexfyz-latest` APK/source ZIP.

**Remaining pre-build concerns:**
- The live page avoids a full SQLite query on each recorder event, but `_flushLiveUpdates` still recomputes `UsageStatsAnalytics.summarize` over the selected in-memory session after each live batch. This is not yet a true incremental analytics accumulator; CPU/memory cost on long sessions remains unmeasured.
- The serialized SQLite write queue is still not explicitly bounded/coalesced or batch-written. No sustained telemetry/storage-pressure soak is available.
- Current tests cover interpolation bounds, coverage expiry, decimation, Peltier and cursor behavior, but do not yet establish 60/120-Hz frame progression, animation lifecycle pause/dispose, bounded-queue backpressure or long-session performance.
- Flutter/Dart are not installed in the active environment. `dart format`, targeted Flutter tests, full `flutter test`, `flutter analyze`, Android Gradle and screenshot capture are BLOCKED / NOT RUN. Delimiter/source inspection is not a compile/test pass.
- Actual Android screenshots remain VISUAL NOT VERIFIED (350-dp/420-dp, Light/Dark and English/Indonesian).

**Build readiness decision (Diskusi, 2026-11-11): NOT YET RECOMMENDED for release Build App.** Complete the incremental analytics/performance and animation-lifecycle regression pass under a new `Eksekusi Full!`, then use separate `Eksekusi Build App!` for hosted QC and packaging. The hosted Build workflow remains the mandatory analyzer/test/Android/signing/release gate; no Build was triggered by this audit.

**Protected scope:** App only. BLE/P1 identifiers/protocol, firmware, sampling rate, Android `versionName`, safety gates and release workflow remain unchanged. No Firmware compile, BIN, Firebase, OTA, flash or device operation occurred.
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
