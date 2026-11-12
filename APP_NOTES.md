## Current implementation update — 2026-11-12

**Status: SOURCE IMPLEMENTED / 185 TESTS WRITTEN / TEST, FORMATTER AND ANALYZER NOT RUN / VISUAL NOT VERIFIED.** Current executable source/test HEAD: `a963f8bd100f7f2c41f720933ade2cd586145270`. Build #153 remains the latest published APK; the current source is not packaged.

- The selected-time dock now sizes to its content and retains the bottom SafeArea, elapsed time, six synchronized metrics and 48×48 dp clear action. Regression asserts a height ≤200 dp and Clear removes the dock.
- Temperature charts use a 160-dp plot, 10-dp axis/time labels and tighter section spacing. Y-axis labels now derive decimal precision from tick spacing, avoiding duplicate rounded labels when a temperature range is narrow.
- Analytics groups by session/metric, de-duplicates event identities, merges ordered events, skips unnecessary event sorting and computes one summary per one-second live batch. Decimated points are cached and cursor lookup uses binary search.
- SQLite schema v2, 30-day retention, raw 1-Hz observations, null gaps and HOT-only P1 freshness remain. Sample insert + matching session freshness update are transactional. The serial write queue limits scheduled operations to 64 and waits for capacity; failures remain visible.
- **Additional static review (2026-11-12):** the queue's 64-operation counter covers admitted serial operations, not every suspended producer Future. Production Battery/HOT/state call sites in lib/main.dart use unawaited(), so a sustained writer slowdown may accumulate waiting Futures outside pendingWriteCount. This is an unobserved source-level risk; the current queue regression does not model that producer pattern.
- **Gap-density review:** decimatePoints(maxPoints: 1600) intentionally retains every null and breakBefore point. This preserves gaps, but output may exceed 1,600 for dense invalid/alternating-gap histories. The current 12k test uses mostly valid continuous data. Add invalid-heavy tests and a segment-aware reduction policy before claiming a hard chart-point cap.
- Current Usage Statistics tests cover a 12k-per-sensor synthetic history, bounded chart points, queue FIFO/capacity, selected-dock height/clear and narrow-axis label precision. The full current suite contains 185 declarations (172 unit/source-contract, 13 widget), but none has run on this source yet.
- No raw telemetry, sampling cadence, database schema, P1 protocol, Firmware or native security behavior was changed. One full selected-session summary/decimation pass still occurs once per second; long-session Android CPU/memory soak and OEM visual acceptance remain pending.

# JE X FYZ / JE Cooler — App Behavior Reference

Purpose: canonical current App/UI/BLE/telemetry contract. Current source defines implementation; DESIGN_NOTES.md holds owner-approved screen-specific visual constraints; PRODUCT_DESIGN_CONSTITUTION.md defines cross-screen design principles; VISUAL_QUALITY_GATE.md defines evidence-based visual acceptance; CHANGELOG.md and APP_BUILD_REPORT.md hold history/evidence.

## Current source and release boundary — checked 2026-11-12

- Latest verified App package: **Build #153**, Actions run [43145542329](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43145542329), immutable package source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. Release/tag identity, asset hashes and full QC evidence are detailed in PROJECT_STATE.md and APP_BUILD_REPORT.md.
- Build #153 passed the security/architecture audit, analyzer (**23 info-level findings, zero warnings/errors**), and **176/176 Flutter tests**. Android Gradle gate passed; `:app:testDebugUnitTest` and native compile/process prerequisites were `NO-SOURCE`, so no native Android JUnit case ran. Hosted CI does not establish screenshot/OEM or physical-device acceptance.
- The immutable Build #153 package included the Lock Voltage overlay/Settings card, custom Peltier safety card, About page, Device Diagnostics snapshot, simplified Statistics diagrams and cross-screen icon/NOTIFY polish. Since that source, current main has unbuilt App/test follow-ups: a fixed compact Peltier dialog, removal of Temperature reset, compact Lock Voltage Settings card, About moved into its own card, and removal of Device Diagnostics. Therefore Diagnostics is present in the Build #153 APK but absent from current main. Build #153 hosted analyzer/tests validate only its immutable source SHA, not these follow-ups.
- Compact Settings/Connection sizing, Bluetooth scan-state presentation, scanner ownership/handoff and existing Home contrast work are already present in Build #151. Current refinement reuses the existing JE Cooler theme, compact Settings typography, 360-dp canvas and Phosphor icon family; no new font, parallel palette or global scale transform was introduced.
- **Validation boundary:** Build #153 provides hosted analyzer, Flutter and Android Gradle evidence for the App source. This environment still has no local Flutter/Dart/Gradle/ADB toolchain, so local formatter and local test runs were NOT RUN. Android rendering, screenshot/OEM acceptance, and exact owner-installed APK identity remain owner-side evidence.
- **Separate gaps remain:** physical BLE lifecycle/security, NVS power-cycle, rail/selector/LED, thermal/electrical cooling, Firmware V7.2 compile/BIN provenance, Firebase/OTA/flash and OEM visual acceptance are not established by App source checks.

## Build #151 Peltier dialog and LED Color Picker baseline (historical source; 2026-11-11)

- This compact AlertDialog refinement and 60-color picker were later included in Build #151. The current main custom Peltier safety card is a newer second-stage redesign and is documented below.
- Peltier popup now targets an approximately 312-dp card width inside the existing 360-dp fixed canvas, uses 18/14/14 dp title/body/actions and tightened vertical padding. Cancel/Fan targets remain 48 dp high. English/Indonesian copy is shorter. Fan-first safety and existing command/ACK sequence are unchanged.
- LED Color Picker has 60 unique named colors with complete English/Indonesian localization, six columns, internal scrolling, 48×48 dp hit cells and 32×32 dp swatches. Names now match standard HEX values where available. Preview, tooltip, accessibility label, draft selection, Cancel and explicit Select/commit share the same color name/value mapping. Legacy stored RGB aliases remain supported.
- These compact dialog and 60-color picker refinements were subsequently included in Build #151 and passed that build's hosted analyzer/Flutter test gates. That validation applies to the Build #151 source baseline; it does not validate the newer custom Peltier card now on current main. Physical screenshot/OEM acceptance still requires owner-side visual review.


## Lock Voltage 5V — App source included in Build #153; Firmware field validation pending

- Add a Settings control named **Lock Voltage** / **Kunci Tegangan**. Its persisted authority is Firmware ESP32 Preferences/NVS, not Android SharedPreferences. The value is learned from a new Firmware P1 full-sync/state field such as VOLTAGE_LOCK.
- ON locks actual Firmware rail requests to 5 V, disables the App's 9 V/12 V Voltage controls and disables the Adaptive switch/profile controls with visible lock treatment. Keep Home metrics truthful: Voltage reflects actual telemetry (5 V once handoff completes) and Adaptive reflects actual OFF state; show a lock marker rather than inventing values.
- On enable from 9/12 V or Adaptive ON, show an in-progress/locked state until authoritative Firmware telemetry confirms Adaptive OFF and Voltage 5 V. Do not optimistically paint the rail as 5 V before the transition completes.
- The Lock Voltage setting remains available only when the BLE/P1 session is ready and Firmware's lock state has been synchronized. Before full sync or while disconnected, do not default the value to OFF or use stale Android storage as authority.
- OFF is sent explicitly through the App setting. Firmware persists the change before acknowledging. Unlocking only removes the rail ceiling; do not automatically restore a prior 9/12 V voltage or enable Adaptive. Remain at 5 V until the user selects a new mode.
- Localize title, supporting copy, ON/OFF, lock status, pending 5 V handoff, persistence-error and retry messages in English/Indonesian. If runtime Lock is ON but VOLTAGE_LOCK_SAVED is OFF, keep Voltage/Adaptive locked and clearly warn that the lock is only active for this session until NVS saving succeeds.
- If an App voltage request is rejected specifically because Lock Voltage is ON, show a concise localized explanation; Firmware also emits its two-red-flash rejection signal. Firmware remains the enforcement point even when an older App still exposes manual buttons.
- App-only security caveat: current BLE bonding/Just Works + P1 readiness do not authenticate the official App. Strict prevention of third-party BLE clients unlocking the feature requires the separate BLE App authentication design; do not imply that this UI-only change solves it.
- Source status: App Settings/P1/lock-control source is included in the Build #153 source SHA and passed the hosted analyzer/176-test Flutter suite. Build #153 Release packages the App side only; Firmware V7.2 compilation/BIN and physical NVS/rail behavior remain separately NOT RUN. No local Flutter/Dart formatting or tests were executed in this container.




## Current main UI refinement — Lock Voltage, Peltier, About and Statistics (2026-11-12)

- **Lock Voltage overlay:** reuses the existing centered blur/lock surface. Bluetooth-disconnected priority and the existing Adaptive tab gate are preserved. A synchronized Firmware Lock Voltage ON overlays only Voltage (tab 0) and Adaptive (tab 2); Lock Voltage alone leaves Control, LED and Temperature available. Voltage says it is returning to 5V until actual VOLTAGE telemetry reports 5V; the locked-at-5V message is telemetry-gated.
- **Settings rows:** each setting now uses one horizontal line with a 13-dp title, an optional right-aligned 11-dp value, and the existing Phosphor chevron. The row guarantees a 48-dp minimum height. Only actionable current values are shown: Language, Appearance, Bluetooth Auto/Manual, Floating Monitor ON/OFF and a known Firmware version. Notifications count, the Usage Statistics descriptor, About subtitle and unknown Firmware `V?` placeholder are omitted.
- **Settings Lock Voltage:** remains Firmware-owned and first below the Settings AppBar. The compact card uses a 34-dp lock tile and preserves switch/retry interactions. State copy appears only when useful: not synchronized, Firmware V7.2+ required, active but not saved, or the active 5V/Adaptive-OFF limit. A synchronized, saved OFF state has no explanatory subtitle. No App-local preference becomes authoritative.
- **Peltier prerequisite:** custom amber JE card in the existing general-dialog/fixed-canvas route. CTA states the real paired operation, Fan ON then Peltier ON. Cancel remains command-free and Fan ACK failure still prevents PELTIER:ON.
- **About / Tentang:** remains immediately below Firmware in its own single-row Settings Card, without a repeated `JE Cooler` subtitle. The page shows `JE Cooler` and one compact credit Card; the generic `Special Thanks` heading was removed. Existing bilingual roles, names and handles for Horizon, FYZ and Logos are unchanged.
- **Device Diagnostics removal:** owner requested removal. The Device Diagnostics Settings row, page, manual-copy action, EN/ID labels, route arguments and dedicated widget test have been removed. No diagnostics data is displayed elsewhere; existing BLE/telemetry state remains available to features that own it.
- **Usage Statistics:** graph-first layout retains Battery/Hotside plots, four activity timelines, shared six-metric cursor, Min/Avg/Max/Observed, Hotside limit, all aggregates, provenance and data gaps. Charts are 160 dp high with 10-dp painter axis labels and tighter section spacing. The selected-time dock uses content height (`MainAxisSize.min`) and retains the 48-dp Clear action. Live batches use event identities, sorted merge, one summary per batch, grouped session/metric indexing, conditional sort, cached decimated chart points and binary-search cursor lookup. SQLite sample + session freshness update is transactional; schema v2, raw 1-Hz samples, null gaps and HOT-only P1 freshness remain. A serial capacity-64 write queue applies backpressure rather than intentionally discarding accepted writes. One full selected-session summary/decimation pass remains per second; long-session CPU/memory soak is still required.
- **Cross-screen polish:** current primary App surfaces use Phosphor icons. Existing Light/Dark semantic ColorScheme, compact Settings textTheme and 360-dp master canvas remain. Home NOTIFY remains 44 dp with readable text; Home composition/geometry is unchanged.
- **Regression source:** current suite has 185 declarations (172 unit/source-contract, 13 widget), including Settings, Statistics selected-dock height/clear, 12k-per-sensor long history/bounded charts, write queue FIFO/capacity, Connection/Floating polling and 48-dp touch surfaces, and neutral TamperScreen/contact behavior. These tests are written but NOT RUN here.
- **Current source validation:** GitHub source read-back/static structural checks passed. Flutter/Dart are unavailable in this runtime; formatter, focused tests, analyzer and the full 185-test suite are BLOCKED / NOT RUN. Next guarded Build App QC must validate exact main SHA `a963f8bd100f7f2c41f720933ade2cd586145270`. No new APK has been packaged; visual outcome remains **VISUAL NOT VERIFIED**.


## Bluetooth Connection sheet — scan presentation contract

- The sheet starts its initial scan after its first frame and observes `FlutterBluePlus.isScanning` separately from fresh `onScanResults`. A completed scan with no matching JE Cooler displays the localized not-found message rather than remaining on Scanning or showing cached results from an earlier scan.
- Permission denial, Bluetooth/legacy-location unavailability, scan startup/stream errors and active scanning have distinct localized message keys. A guarded retry handler is shared by the scan button and permission retry. Dismissing the sheet still stops scanning.
- Manual-sheet ownership, asynchronous generation invalidation, serialized scanner operations and a connection-handoff fence until `_bleConnecting` is assigned are coordinated by `ConnectionScanCoordinator`. Passive reconnect uses fresh `onScanResults`; neutral dismissal resumes only after cleanup and existing Auto Connect gates are rechecked.
- A passive scan reservation begins before asynchronous permission/adapter checks and remains active for the entire radio scan window. The implementation waits for `FlutterBluePlus.isScanning` to become false before releasing the lease, then rechecks its generation token.
- One-shot Auto Connect/OTA reserves a coordinator token synchronously before permission/adapter awaits, excludes overlapping passive/one-shot scans, and invalidates a pending attempt when manual-sheet ownership or connection handoff begins. All one-shot scanner start/stop commands pass through the shared FIFO queue with an in-queue token check; the lease spans primary and fallback discovery without holding the queue through the entire radio scan.
- Primary and fallback discovery use fresh `onScanResults`. The known-remote-ID fallback remains available for ESP32-C3 advertisements that omit the 128-bit service UUID, but only current-scan results can initiate the fallback connection. The pinned `flutter_blue_plus 2.3.14` plugin may retain previous values in `scanResults`; `onScanResults` is the fresh per-scan stream.
- The manual Connection UI has distinct scanning, completed-no-result, permission-required, adapter/location unavailable and scan-failed presentations. A stopped scan updates the plugin lifecycle stream; the UI does not rely on a fixed 10-second spinner.
- Regression assertions for layout source shape, Fan Speed callsite structure and await-safe BLE cancellation were repaired after Build #130 and remain included in the later Build #149 source package. The full hosted Flutter suite passed 166/166; this validates automated App behavior/contracts, not real radio timing or OEM behavior.
- **Physical validation remains pending:** after Build #153 is installed, test passive rediscovery, prerequisite cancellation, manual-sheet open/neutral dismissal, selected-device handoff, fresh primary/fallback advertisements, adapter loss and reconnect on the real phone/cooler. BLE P1 UUIDs, framing, GATT connection/session synchronization and authoritative telemetry semantics remain unchanged.



## Identity, package and app navigation

- App display name: JE Cooler; product branding/header: JE X FYZ.
- Android package: com.horizontalzzz.jexfyz. Flutter version: 1.0.0+3 at last live config review.
- Android Gradle versionName "Telegram @horizontalzzz" is intentional creator/contact identity; preserve it exactly.
- Visual assets are transparent square PNGs: assets/jexfyzicon.png and assets/jexfyzcooler.png. Preserve transparency and aspect ratio.
- Core Dashboard modes are VOLTAGE and ADAPTIVE. The compact menu hierarchy is VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE. The earlier removal of the About Settings page/row is historical and is superseded by the owner's explicit 2026-11-12 request to restore About below Firmware.

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
- Historical initial-state note (2026-11-09): the first recorder queue had no explicit bound. The current implementation supersedes that state with a serial capacity-64 scheduled-operation queue that waits for capacity; sustained producer/storage-pressure testing remains open. A local write exception is retained for the current process and surfaced as a recording warning on the Statistics page. Collection is not dependent on the page being open.

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
- Historical local-validation note (2026-11-10): that source-review session lacked Flutter/Dart/Android tools and did not run formatter, tests, analyzer or device rendering. This was superseded by Build #153 hosted evidence: analyzer 23 infos/zero warnings/errors and 176/176 Flutter tests passed. OEM visual acceptance and Firmware/device validation remain unverified.
### V7.2 Lock Voltage App integration — source contract

- Settings reads the Firmware-owned VoltageLockSettingsState notifier; it does not store the hardware lock in Android preferences. The toggle is unavailable until BLE/P1 session readiness and a valid VOLTAGE_LOCK snapshot are present. V7.1 firmware remains unknown/unsupported rather than defaulting to OFF in the UI.
- App sends absolute VOLTAGE_LOCK:ON / VOLTAGE_LOCK:OFF commands and waits for ACK plus authoritative VOLTAGE_LOCK telemetry. VOLTAGE_LOCK_SAVED separately identifies NVS persistence. Retry after ON persistence failure sends ON again. Actual voltage remains telemetry-only; VOLTAGE:5V appears only after Firmware reports it.
- Voltage and Adaptive controls/profile rows are disabled while synchronized Lock is ON. Home telemetry is not optimistically changed. Settings and lock-state copy are bilingual.
- Hosted validation: Build #153 / run `43145542329`, immutable source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. Hosted analyzer reported 23 info-level findings, zero warnings/errors; Flutter passed **176/176** tests. Android Gradle gate passed, but `:app:testDebugUnitTest` and native compile/process prerequisites were `NO-SOURCE`, so no native Android JUnit cases ran. This does not compile or execute the ESP32 Firmware.
- Visual status: source exists, but actual Android/OEM screenshots at 350-dp/420-dp, English/Indonesian, Light/Dark, long text and enlarged text have NOT been captured/reviewed. VISUAL NOT VERIFIED.

## Owner UI refinement — Lock Voltage overlay and Settings priority (2026-11-12; included in Build #153)

- The requested centered Lock Voltage presentation is implemented by reusing the existing `_lockedDisplayMenu` surface, `ImageFiltered` blur, dim scrim, centered lock panel and `IgnorePointer`; no parallel visual language was introduced.
- With synchronized Firmware Lock Voltage ON, the overlay applies only to Voltage (tab 0) and Adaptive (tab 2). Control, LED and Temperature remain available unless an independent existing gate applies. Bluetooth-disconnected priority and Adaptive-active/transitioning gates remain intact.
- Voltage copy follows actual VOLTAGE telemetry: before the rail reaches 5V it communicates the pending safe return; it states locked at 5V only after Firmware reports 5V. Adaptive copy explains that Adaptive is forced OFF while Lock Voltage is active. Copy is bilingual.
- The Home Bluetooth control and navigation strip remain outside the blurred submenu. The submenu is non-interactive while covered.
- Lock Voltage is the first dedicated Settings card below the AppBar and before General, with the existing compact typography/theme and readable supporting text.
- Firmware-owned known/session/busy/NVS-save-failure/retry semantics remain. No Android preference becomes authoritative; BLE/P1 protocol and Firmware source are unchanged by this App UI refinement.
- Hosted analyzer and Build #153's 176/176 Flutter tests passed. Actual visual acceptance remains pending: screenshots/OEM rendering at 350-dp/420-dp, Light/Dark and EN/ID, followed by owner-side physical BLE/Lock Voltage validation.
## Owner UI correction — fixed compact Peltier popup and Temperature reset removal (2026-11-12)

- **Observed defect:** the Build #153 Peltier card was wrapped in a `SingleChildScrollView`, making the panel content draggable/scrollable. The supplied Android screenshot also shows dialog text with an anomalous inherited-looking face/underline treatment and an oversized card.
- **Peltier presentation fix:** the dialog is now centered in the existing `JexFixedScalePage` and fixed in place; the scroll view and entrance slide are removed. The card is capped at 296 dp, uses 20-dp corners, 40-dp amber icon, compact 15–15.5 dp title / 11.5–12.5 dp explanation / 10.5 dp step labels, and tighter vertical spacing. Text explicitly uses the existing theme Roboto family and `TextDecoration.none` so inherited decoration cannot mark the copy as underlined. Fade/scale entrance remains restrained.
- **Touch and safety contract:** primary action and Cancel remain 48 dp high. Cancel and barrier dismissal send no output command. Approval still sends `FAN:ON`, waits for successful ACK, and only then sends `PELTIER:ON`; failure/mount checks and existing timeout/error paths remain unchanged. No Firmware or BLE protocol behavior was altered.
- **Temperature UI:** removed the Temperature tab's “Reset Temperature Settings” / “Atur Ulang Pengaturan Suhu” button, its App-only handler and the now-unused button-label localization key. Hotside limit and 5V/12V battery-threshold controls remain. Generic `RESET:TEMPERATURE` protocol classification/ACK handling was left intact; this is removal of the UI affordance, not a Firmware protocol change.
- **Regression source:** updated the Peltier contract for centered 296-dp geometry, fixed non-scrollable behavior, explicit type/decor reset and preserved 48-dp actions; added a regression contract that the Temperature tab has no global reset affordance while retaining protocol classification.
- **Validation boundary:** source and test changes are committed/read back. Flutter/Dart are absent in this execution runtime, so `dart format`, focused/full Flutter tests and analyzer are BLOCKED / NOT RUN. No hosted Actions/App Build, APK/Release, screenshot rendering, emulator or physical-device operation was run. Visual outcome remains **VISUAL NOT VERIFIED** pending a new App package and actual owner screenshot review.


## Owner request — About page and bilingual contributor credits (2026-11-12)

- Restore an **About / Tentang** entry directly below the Firmware section in the main Settings list. It opens a vertically scrollable About subpage using the established `JexFixedScalePage(compactUi: true, ...)` contract. This is a new explicit owner request and overrides the historical removal note; update the existing source-contract test that currently asserts About must not exist.
- About page content, preserving the project/brand names and exact social handles:
  - English heading: **JE Cooler**; credit heading: **Special Thanks**.
  - **App Development & Build** — Horizon — `@Horizontalzzz`.
  - **Design Inspiration** — FYZ — `@FYZ737`.
  - **3D Design & Printing** — Logos — `@Logos3dMichael`.
  - Indonesian heading: **JE Cooler**; credit heading: **Ucapan Terima Kasih**.
  - **Pengembangan Aplikasi & Build** — Horizon — `@Horizontalzzz`.
  - **Inspirasi Desain** — FYZ — `@FYZ737`.
  - **Desain & Pencetakan 3D** — Logos — `@Logos3dMichael`.
- Wording notes: use “Special Thanks” as a standalone heading rather than “Special Thanks to:” because the credits are role/name pairs; “Design Inspiration” corrects the unidiomatic “Design Inspired”; “3D Design & Printing” is recommended assuming Logos contributed both 3D design and printing. If the role is print-only, narrow it to “3D Printing” / “Pencetakan 3D”.
- Keep handles exactly as supplied; display them as text unless the owner supplies verified profile URLs. Do not invent links or claim additional roles/endorsements.
- Presentation direction: clean single-column credit layout with the JE Cooler brand at top, clear role hierarchy, generous spacing and subtle separators. Reuse Settings typography, theme-aware colors, bilingual localization and the 360-dp compact-scale/DPI behavior. No extra claims, version metadata or legal text were requested.
- Regression requirements: About row appears after Firmware in Settings ordering; About subpage opens; all role labels and handles match exact copy in both locales; EN/ID switching updates the heading/role labels but not names/handles; light/dark and 350-dp/420-dp layouts remain readable without overflow.
- Status: requirement/design recorded in Diskusi only. No executable source/tests changed or run, no build/release, Firmware or device action.


## Owner-approved visual refinement direction — whole App and Usage Statistics (2026-11-12)

- Owner says to adopt the full premium/professional refinement direction and specifically simplify the Usage Statistics diagrams to look cleaner with less explanatory text. This is a design approval, not source implementation.
- Follow `PRODUCT_DESIGN_CONSTITUTION.md`: use one coherent JE Cooler design language; preserve current brand/assets, Home geometry, 360-dp fixed-canvas rules, theme roles, bilingual support, real telemetry and interaction/safety contracts. Audit existing theme/components before creating tokens. No speculative fonts/palette, extra containers, random gradients/glow, arbitrary badges, mixed icon weights or decorative motion.
- Cross-App audit scope: semantic typography; consistent spacing/radius/borders/elevation; mostly Phosphor icon family with justified system exceptions; card/surface hierarchy; Home NOTIFY/readability; command/ACK/telemetry feedback; interaction/motion lifecycle and disabled/loading/error states. Keep existing Home composition; do not change protected geometry as collateral.
- Device Diagnostics is accepted as a future App feature direction, subject to a source-field availability audit. Candidate fields only: App/Firmware version; current Bluetooth/P1 session and sync status; last valid Battery/Hotside sample times; actual voltage; Firmware-confirmed Fan/Peltier/Adaptive state; localized safety status. Never fabricate unavailable fields or expose raw protocol/reason tokens, Wi-Fi credentials or secrets. A user-triggered copy report may be considered with sensitive identifiers redacted; automatic upload/cloud telemetry is out of scope absent new approval.
- **Usage Statistics visual contract:** retain six metrics and their meaning (Battery/Hotside measured line charts; Voltage, Adaptive and Peltier stepped timelines; Fan Speed 0–100% step/area), common time cursor, session selection, all useful aggregates and current values. Do not alter measurement cadence, SQL/persistence, analytics, gap/session handling or sensor truth for a visual-only change.
- Reduce always-visible text: remove the long sampling/storage paragraphs from the chart flow and replace them with concise last-sample/provenance metadata plus optional information details; keep session status/start/elapsed in one compact header; keep only the necessary axis labels; keep Min/Avg/Max in one aligned strip; preserve Hotside limit reference.
- For Operating Profile, keep four timeline lanes. Remove the permanently visible seven-item text Wrap of voltage-duration, Adaptive/Peltier ON-duration and Fan average/maximum; expose all these useful aggregates through a compact collapsed-by-default details disclosure or a minimal integrated summary. Do not discard analytics.
- Remove the initial “touch any chart...” instruction sentence from persistent content; the interaction must remain discoverable and accessible. Keep synchronized tap/drag cursor. Selected state becomes a compact fixed readout with selected time and six values, plus icon-only accessible clear action. Unknown values and invalid-data gaps remain explicit; never bridge a gap or session.
- Avoid putting every graph in an extra card; prioritize plot readability, consistent scales/axes, modest grid lines, true state steps and existing semantic colors. Do not add ornamental legends, gradients, glow or fake smooth curves.
- Required chart acceptance: 350/420 dp; EN/ID; Light/Dark; 1/multiple sessions; active/completed; empty/error; storage-write warning; missing/invalid sensor gaps; Hotside limit; cursor off/on; long session duration and long localized strings. Update existing widget tests, which currently cover a limited combination (ID at 350/light and 420/dark) and one interactive cursor path. Actual screenshots required for visual acceptance.
- Execution remains staged: agreed Lock Voltage UI, Peltier popup, About; Statistics redesign; shared UI system/polish audit; Device Diagnostics after data-source audit; end-to-end visual QA. No App source/tests modified or run in this Diskusi.
