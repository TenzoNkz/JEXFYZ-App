## Current App source and verified package — Build #163 SUCCESS — 2026-11-16

- **Latest verified package:** Build #163 / [Actions run 43679305537](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43679305537) / job `132706236782`, attempt 1, terminal SUCCESS on immutable package source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`.
- **Validation lineage:** Validation Only #19 / run `43677560315`, job `132700920324`, passed on source `8fca2ecebf8b2ffb83fc9475a817c832f8269dc5`. The formatted source follow-up is `fc39de16a5480347ce13083760424a309957c311`. A verified compare from that source to Build #163's package source shows only documentation/skill/status/checkpoint paths changed; no App source, tests, Android config, dependencies or workflows changed in between. Build #163 therefore packages the same validated executable/test state.
- **Hosted QC:** Flutter 3.47.2 / Dart 3.13.2; locked dependencies PASS; formatter checked 18 files, applied one correction, and final formatter check had zero changes; analyzer **118 info-level findings / 0 warnings / 0 errors**; Flutter tests **197/197 passed**.
- **Android Gradle:** `:app:testDebugUnitTest` gate **BUILD SUCCESSFUL in 2m43s**; 162 actionable tasks (161 executed, 1 up-to-date). Native Android App Kotlin/Java test tasks were `NO-SOURCE`; no native JUnit case executed.
- **Release identity:** Release ID `403010611` / tag `jexfyz-latest` target the exact package source SHA. The Release contains exactly one APK and one corresponding source ZIP.
- **APK:** `JEXFYZ-release.apk`, **55,881,819 bytes**, SHA-256 `97c7cf99bef5d89f82b13d8f1c4b3c02dede541c2642a751ba61c8f9290a245c`.
- **Source ZIP:** `JEXFYZ-corresponding-source.zip`, **2,943,100 bytes**, SHA-256 `866117d208d38d2c04a2f7f097b5dc8941850a16bd52172a35d761af71334c00`. The embedded source marker, ZIP integrity and downloaded identity were verified.
- **Signing:** APK V1/V2/V3 signatures and the single-signer pinned certificate fingerprint `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` passed. The certificate is self-signed and has no publicly trusted PKIX chain.
- **Protected Android version:** Gradle `versionName "Telegram @horizontalzzz"` remains unchanged; Flutter version is `1.0.0+3`.
- **Retained warnings:** Kotlin Gradle Plugin 2.2.20 future Flutter compatibility warning; deprecated Android Gradle properties; generated native ELF DWARF debug-info warning; JAR META-INF unsigned-entry warnings. These are non-blocking but not represented as fixed.
- **Evidence boundary:** Build #163 is VERIFIED CI / RELEASE SUCCESS, not owner installation, Android/OEM screenshot, BLE field behavior, Firmware compilation/BIN provenance, Firebase/OTA/flash, thermal or electrical acceptance. Native Android JUnit tasks were NO-SOURCE.
- **Pending owner-directed work:** the 2026-11-15/16 bilingual copy corrections and Adaptive selector/card presentation decisions are **not included** in Build #163. They remain source/test implementation work for a separately authorized `Eksekusi Full!`; another APK requires a separate `Eksekusi Build App!`.

## Current approved UI and data contracts — included in Build #163

- **Peltier prerequisite:** preserve the ordered operation `FAN:ON → successful ACK → PELTIER:ON`. Cancel/barrier dismissal sends no command.
- **Lock Voltage:** Firmware P1 state is authoritative. Keep the one-line Settings card, static neutral lock tile and visible Switch; never infer OFF while state is unknown/disconnected. Preserve NVS save-failure/retry and actual-voltage telemetry semantics.
- **About and Home tabs:** About title is Special Thanks / Ucapan Terima Kasih; Horizon role is App Developer & Builder / Pengembang Aplikasi & Perakit and handle exactly `@horizontalzzz`. Five Home tabs retain equal width and 38-dp visible pills within the existing 48-dp row/hit target.
- **Usage Statistics:** one session header/elapsed timer and selector; integer 1°C Battery/Hotside axis labels based on observed data; Min/Avg/Max; four operating lanes; shared six-metric cursor; compact two-row/three-column selected-time dock. The later alignment refinement is included in Build #163.
- **Usage Statistics invariants:** SQLite schema v2 and v1→v2 migration; 30-day retention; raw 1-Hz observations; explicit null gaps; session continuity; HOT-only P1 freshness; bounded writer queue (64 normal + 8 reserved + 1 critical endSession slot); FIFO accepted writes and explicit overload warning. One full selected-session summary/decimation pass still runs per one-second batch; long-duration CPU/memory and sustained storage-pressure soak remain unverified.
- **Bluetooth lifecycle:** Dashboard disposal cancels connection/notification/rediscovery subscriptions and timers; scanner attempts use serialized ownership/generation invalidation. Android permission and reconnect behavior still need physical/OEM validation.
- **Visual acceptance:** **VISUAL NOT VERIFIED.** Review actual Build #163 screenshots at 350-dp/420-dp, portrait/constrained height, English/Indonesian, Light/Dark, Home, Settings, Bluetooth, Floating Monitor and Usage Statistics states before marking visual acceptance.


---
# JE X FYZ / JE Cooler — App Behavior Reference

Purpose: canonical current App/UI/BLE/telemetry contract. Current source defines implementation; DESIGN_NOTES.md holds owner-approved screen-specific visual constraints; PRODUCT_DESIGN_CONSTITUTION.md defines cross-screen design principles; VISUAL_QUALITY_GATE.md defines evidence-based visual acceptance; CHANGELOG.md and APP_BUILD_REPORT.md hold history/evidence.

## Historical source and release snapshot — Build #157 (superseded by Build #162)

- Latest verified App package: **Build #157**, Actions run [43247876115](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43247876115), immutable package source SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. Release ID `403010611` / tag `jexfyz-latest` still target this exact source. Release hashes and full QC evidence are detailed in PROJECT_STATE.md and APP_BUILD_REPORT.md.
- Build #157 passed the security/architecture audit, analyzer (**23 info-level findings, zero warnings/errors**), and **187/187 Flutter tests**. Android Gradle gate passed (`BUILD SUCCESSFUL in 3m19s`); app native JUnit compile/process/test prerequisites were `NO-SOURCE`, so no native Android JUnit case ran. Hosted CI does not establish screenshot/OEM or physical-device acceptance.
- The immutable Build #157 package includes the App source through `10d1065`. The four refinements described in the current checkpoint above were committed later in `a5d4586`; they are not included in Build #157 and have no hosted validation result. Current main continues to omit the removed Device Diagnostics page; do not infer its presence in the current source from older release notes.
- Compact Settings/Connection sizing, Bluetooth scan-state presentation, scanner ownership/handoff and existing Home contrast work are already present in Build #151. Current refinement reuses the existing JE Cooler theme, compact Settings typography, 360-dp canvas and Phosphor icon family; no new font, parallel palette or global scale transform was introduced.
- **Validation boundary:** Build #157 provides hosted analyzer, Flutter and Android Gradle evidence only for its immutable source SHA. For current main `a5d4586`, formatter/tests/analyzer/Gradle are BLOCKED / NOT RUN because the active runtime has no Dart/Flutter/Gradle/ADB toolchain. Android rendering, screenshot/OEM acceptance, and exact owner-installed APK identity remain owner-side evidence.
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




## Current App UI and behavior contracts — included in Build #163

- **Lock Voltage overlay:** reuses the existing centered blur/lock surface. Bluetooth-disconnected priority and the existing Adaptive tab gate are preserved. A synchronized Firmware Lock Voltage ON overlays only Voltage (tab 0) and Adaptive (tab 2); Lock Voltage alone leaves Control, LED and Temperature available. Voltage says it is returning to 5V until actual VOLTAGE telemetry reports 5V; the locked-at-5V message is telemetry-gated.
- **Settings rows:** each setting now uses one horizontal line with a 13-dp title, an optional right-aligned 11-dp value, and the existing Phosphor chevron. The row guarantees a 48-dp minimum height. Only actionable current values are shown: Language, Appearance, Bluetooth Auto/Manual, Floating Monitor ON/OFF and a known Firmware version. Notifications count, the Usage Statistics descriptor, About subtitle and unknown Firmware `V?` placeholder are omitted.
- **Settings Lock Voltage:** remains Firmware-owned and first below the Settings AppBar. New owner decision: keep a fixed one-line card with static neutral lock tile, no permanent state subtitle, and a Switch that remains visible while busy (disabled during the operation). Only the Switch animates when authoritative P1 state changes. Preserve unavailable-state tooltips and icon-only NVS retry. No App-local preference becomes authoritative.
- **Peltier prerequisite:** custom amber JE card in the existing general-dialog/fixed-canvas route. CTA states the real paired operation, Fan ON then Peltier ON. Cancel remains command-free and Fan ACK failure still prevents PELTIER:ON.
- **About / Tentang:** remains immediately below Firmware in its own single-row Settings Card. The page heading is `Special Thanks` / `Ucapan Terima Kasih`; the single credit Card stretches each of its three blocks full-width and aligns them left. Horizon's role is `App Developer & Builder` / `Pengembang Aplikasi & Perakit`; FYZ/Logos roles and all exact handles remain.
- **Device Diagnostics removal:** owner requested removal. The Device Diagnostics Settings row, page, manual-copy action, EN/ID labels, route arguments and dedicated widget test have been removed. No diagnostics data is displayed elsewhere; existing BLE/telemetry state remains available to features that own it.
- **Usage Statistics:** current presentation is recorded in the 2026-11-13 refresh section above: one primary session timer, Battery/Hotside graphs with whole-degree 1°C ticks, Min/Avg/Max only, four activity timelines, and a compact six-metric selected-time dock. The Observed row, More details disclosure and Last sample footer are removed from the visible page. Secondary aggregates remain in analytics. The underlying session/gap/telemetry behavior, SQLite schema v2, raw 1-Hz observations, retention, write queue, HOT-only P1 freshness and chart decimation are unchanged.
- **Cross-screen polish:** current primary App surfaces use Phosphor icons. Existing Light/Dark semantic ColorScheme, compact Settings textTheme and 360-dp master canvas remain. Home NOTIFY remains 44 dp with readable text; Home composition/geometry is unchanged.
- **Regression evidence:** Build #163 ran the current Flutter suite with **197/197 passing**. Coverage includes Settings, Statistics selected-dock height/clear, long-history and gap-heavy chart budgets, write-queue FIFO/admission/rejection, P1 watchdog ordering, Connection/Floating polling, touch-surface contracts and the latest localization/state regressions.
- **Visual acceptance:** **VISUAL NOT VERIFIED** until actual Build #163 screenshots are reviewed at 350-dp/420-dp, portrait/constrained height, English/Indonesian and Light/Dark, with Home, Settings, Bluetooth, Floating Monitor and Usage Statistics states.
- **Hosted validation:** the current App source/test state is packaged in Build #163 / run `43679305537` on immutable source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`; analyzer reported 118 info-level findings / zero warnings/errors, Flutter passed 197/197, and Android Gradle succeeded in 2m43s. Native Android App JUnit tasks were `NO-SOURCE`. Validation Only #19 separately confirmed a clean formatter result. Physical screenshots/OEM outcome remains **VISUAL NOT VERIFIED**.


## Bluetooth Connection sheet — scan presentation contract

- The sheet starts its initial scan after its first frame and observes `FlutterBluePlus.isScanning` separately from fresh `onScanResults`. A completed scan with no matching JE Cooler displays the localized not-found message rather than remaining on Scanning or showing cached results from an earlier scan.
- Permission denial, Bluetooth/legacy-location unavailability, scan startup/stream errors and active scanning have distinct localized message keys. A guarded retry handler is shared by the scan button and permission retry. Dismissing the sheet still stops scanning.
- Manual-sheet ownership, asynchronous generation invalidation, serialized scanner operations and a connection-handoff fence until `_bleConnecting` is assigned are coordinated by `ConnectionScanCoordinator`. Passive reconnect uses fresh `onScanResults`; neutral dismissal resumes only after cleanup and existing Auto Connect gates are rechecked.
- A passive scan reservation begins before asynchronous permission/adapter checks and remains active for the entire radio scan window. The implementation waits for `FlutterBluePlus.isScanning` to become false before releasing the lease, then rechecks its generation token.
- One-shot Auto Connect/OTA reserves a coordinator token synchronously before permission/adapter awaits, excludes overlapping passive/one-shot scans, and invalidates a pending attempt when manual-sheet ownership or connection handoff begins. All one-shot scanner start/stop commands pass through the shared FIFO queue with an in-queue token check; the lease spans primary and fallback discovery without holding the queue through the entire radio scan.
- Primary and fallback discovery use fresh `onScanResults`. The known-remote-ID fallback remains available for ESP32-C3 advertisements that omit the 128-bit service UUID, but only current-scan results can initiate the fallback connection. The pinned `flutter_blue_plus 2.3.14` plugin may retain previous values in `scanResults`; `onScanResults` is the fresh per-scan stream.
- The manual Connection UI has distinct scanning, completed-no-result, permission-required, adapter/location unavailable and scan-failed presentations. A stopped scan updates the plugin lifecycle stream; the UI does not rely on a fixed 10-second spinner.
- Regression assertions for layout source shape, Fan Speed callsite structure and await-safe BLE cancellation are included in the Build #162 package. Build #162's full hosted Flutter suite passed 188/188; this validates automated App behavior/contracts, not real radio timing or OEM behavior.
- **Physical validation remains pending:** Build #162 owner installation has not been independently confirmed. After installation, test passive rediscovery, prerequisite cancellation, manual-sheet open/neutral dismissal, selected-device handoff, fresh primary/fallback advertisements, adapter loss and reconnect on the real phone/cooler. BLE P1 UUIDs, framing, GATT connection/session synchronization and authoritative telemetry semantics remain unchanged.



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

1. **Battery Temperature / Suhu Baterai** — first trend chart. Show the actual phone-battery sensor reading in °C, with minimum, maximum and duration-weighted average for the selected period. Keep the visible chart title concise as `Suhu Baterai`; explain the phone-battery sensor source in supporting copy only when needed.
2. **Hotside Temperature / Suhu Sisi Panas** — second trend chart. Show the actual Hotside NTC reading in °C, minimum/maximum/duration-weighted average and a reference line for the current configured Hotside limit. In Indonesian UI, translate the component name as `Sisi Panas`. Invalid NTC / `--` creates a gap, never zero.
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
- Historical initial-state note (2026-11-09): the first recorder queue had no explicit bound. Superseded on 2026-11-12 by bounded fail-fast admission: 64 normal slots, 8 reserved control slots and 1 critical endSession slot, immediate visible rejection for unaccepted incoming work, and FIFO completion for accepted work. A persistent recording warning remains available even when the Statistics page is closed; Clear History surfaces admission failure through its UI error path.

### User-visible limitation

- Statistics represent periods when the App's connected-device service actually received telemetry. They are not guaranteed full-day hardware logs while BLE is disconnected, App is force-stopped, or Android does not deliver the connected-device session. Show invalid/missing-data gaps clearly; keep sampling and local-storage provenance available through the Info dialog. The separate Last sample footer is intentionally omitted from the approved dashboard.

**Status:** SOURCE IMPLEMENTED / VALIDATION NOT RUN. Live source contains SQLite persistence, P1-session recording, Settings navigation, period selector, charts/timelines and clear-history flow. The 30D selector and 30-day event retention are now present. Focused tests are committed but not executed in this runtime; visual/device acceptance remains unverified. App packaging still requires separate `Eksekusi Build App!`.

### Static source audit follow-up — 2026-11-10

- Live-source review confirms the recording boundary is after completed P1 synchronization; HOT freshness bounds the operating timeline, Phone Battery freshness is tracked separately, invalid temperature readings create gaps, and sessions are closed on disconnect/process interruption. Settings navigation, duration-weighted summaries and event-driven state lanes are present in source.
- **Display accuracy correction — 2026-11-10:** the “Last value change” label now uses `UsageStatsAnalytics.lastTemperatureChangeAtMs(snapshot)` to select the latest valid persisted Battery/Hotside temperature event, bounded by the owning session's actual end (`endedAtMs`, or `snapshot.toMs` while active) so the two sensors retain independent freshness. Synthetic held-value chart endpoints are no longer used for this label. A focused widget regression test supplies an earlier Battery baseline, a later Hotside event and a still-later unchanged-sensor freshness endpoint; it asserts the displayed time is the persisted event time. SQLite schema and chart sample-and-hold behavior are unchanged.
- The recorder writer now has a hard in-memory admission ceiling (64 normal + 8 reserved + 1 critical session-close operation) and rejects excess submissions without suspending producers. No sustained telemetry/storage-pressure soak has run; actual backlog drain rate, rejection frequency and 30-day raw-store growth remain runtime validation risks, not observed device failures.
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
- The serialized SQLite queue is now bounded at 73 total pending operations (64 normal, 8 reserved control and 1 critical endSession) and fail-fast under overload; batching is not implemented. No sustained telemetry/storage-pressure soak is available.
- Current tests now cover bounded queue admission/rejection, reserved control capacity, FIFO accepted work and gap-dense decimation. They still do not establish 60/120-Hz frame progression, animation lifecycle pause/dispose or long-session performance.
- Flutter/Dart are not installed in the active environment. `dart format`, targeted Flutter tests, full `flutter test`, `flutter analyze`, Android Gradle and screenshot capture are BLOCKED / NOT RUN. Delimiter/source inspection is not a compile/test pass.
- Actual Android screenshots remain VISUAL NOT VERIFIED (350-dp/420-dp, Light/Dark and English/Indonesian).

**Build readiness decision (Diskusi, 2026-11-11): NOT YET RECOMMENDED for release Build App.** Complete the incremental analytics/performance and animation-lifecycle regression pass under a new `Eksekusi Full!`, then use separate `Eksekusi Build App!` for hosted QC and packaging. The hosted Build workflow remains the mandatory analyzer/test/Android/signing/release gate; no Build was triggered by this audit.

**Protected scope:** App only. BLE/P1 identifiers/protocol, firmware, sampling rate, Android `versionName`, safety gates and release workflow remain unchanged. No Firmware compile, BIN, Firebase, OTA, flash or device operation occurred.

### Static source follow-up — bounded ingress and gap-safe chart rendering (2026-11-12)

**Status: SOURCE + REGRESSION IMPLEMENTED / FLUTTER VALIDATION NOT RUN / NOT RELEASED.**

- UsageStatsWriteQueue has 64 regular pending slots, 8 reserved control slots and 1 critical endSession slot (73 maximum). Temperature and Fan Speed writes are non-blocking admissions. Session start/clear and Voltage/Adaptive/Peltier state events can use the 8-slot reserve; endSession alone can use the additional critical slot.
- When full, a new submission is rejected immediately and is not counted as accepted. rejectedWriteCount increments, lastWriteError is retained and the Statistics page shows a bilingual warning that the local writer may be overloaded or storage may have failed. Accepted operations remain serialized FIFO; no accepted work is intentionally removed to make room. Clear History uses failOnReject so it reports an admission failure rather than displaying a false success.
- P1 HOT freshness is measured from actual HOT receipt time, not the last successful SQLite write. A late HOT packet arriving after the 2.5-second stale threshold does not refresh or backfill the old session; it leaves the previous receipt timestamp for the watchdog to close through the critical session-close slot. A slow/rejected history write therefore cannot falsely mark a continuously receiving P1 session stale. Persisted-sample gaps are written as explicit null rows when recording resumes or a session closes; the HOT-stale close path also marks a stale Battery segment before ending the SQLite session.
- decimatePoints(maxPoints) now has a strict output ceiling, including budgets below four. It keeps bucket endpoints/extrema and propagates skipped null/breakBefore boundaries to the next retained point. Only the render list is reduced; stored raw samples and full-resolution summary calculations are untouched.
- Regression source now covers fire-and-forget submissions against a held writer, the 64+8+1 capacity bound, explicit rejection and FIFO accepted work, Clear rejection propagation, critical endSession admission, a late-HOT/P1-watchdog ordering contract, a 24,000-point alternating-null history at budgets 1/2/3/7/8/1599/1600, gap-boundary propagation, and the localized overload warning.
- Suite inventory is 187 declarations (174 unit/source-contract + 13 widget). Static delimiter and structural checks passed, and a separate algorithm simulation exercised the gap-heavy budgets. These are not Dart compiler/test results.
- Flutter/Dart/Gradle/ADB are unavailable in the current runtime. dart format, focused/full Flutter tests, analyzer and Android Gradle are BLOCKED / NOT RUN. The guarded App workflow has no formatter step. No Actions run, Build App, APK, Release, screenshot, physical-device test or long-session soak was performed.
- Remaining performance acceptance: one selected-session summary/chart-decimation pass still runs per one-second batch; 1-hour/8-hour storage, CPU/memory, sustained writer-pressure and 60/120-Hz frame/lifecycle behavior remain unmeasured. Visual status remains VISUAL NOT VERIFIED.

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
- **Localization authority — owner decision, 2026-11-15:** English is the master/source language and default App language. Every user-facing string must have complete, grammatical English copy and a fully translated, natural, standard Indonesian counterpart; do not mix generic English words into Indonesian sentences. Use `Hotside` in English and `Sisi Panas` in Indonesian; `Battery` / `Baterai`; `Battery Temperature` / `Suhu Baterai`; `Hotside Temperature` / `Suhu Sisi Panas`; `Hotside Limit` / `Batas Suhu Sisi Panas`; `Hotside Protection` / `Perlindungan Sisi Panas`; and generic `cooler` / `pendingin`. Keep `Adaptive Mode` / `Mode Adaptif` and the owner-approved `Floating Monitor` / `Monitor Melayang`. Retain established technical names/acronyms such as Bluetooth, Firmware, Peltier, LED, OTA and SSID where they are genuinely technical terms. Never translate or rename internal identifiers, persisted keys, enum values, BLE commands or Firmware protocol tokens; do not expose raw protocol tokens as user-facing prose.
- JexText.of asserts on absent keys or locale entries in debug builds while retaining the existing release fallback. `test/widget_test.dart` verifies every localization table entry has English and Indonesian copy and that unknown lookup keys assert in debug. Legacy Adaptive Profile (`Sisi panas`) and older Hotside wording in stored notices must remain recognized when notices are re-localized; newly rendered Indonesian copy uses `Sisi Panas`.

### Global language, writing and formatting standard — owner direction 2026-11-15

Apply this standard to **all user-visible copy**, not only the thermal labels. It covers Settings, Home, Bluetooth/connection, Usage Statistics, dialogs, tooltips, accessibility/semantics labels, Home NOTIFY, Android notification channels/foreground notifications, Floating Monitor, OTA status and dynamically assembled messages.

1. **English source quality:** write the complete English message first. It must be grammatical, unambiguous, concise and natural for the exact UI context. English is the App default and semantic source. Do not write a broken English phrase merely because the Indonesian translation sounds natural.
2. **Indonesian translation quality:** translate the complete meaning into natural, standard Indonesian. Preserve the actor, object, action, condition, timing, certainty, warning severity and requested action. Do not translate word-for-word when the result is unnatural, but never add, omit or weaken meaning. Do not leave generic English nouns/adjectives in Indonesian sentences. Keep only established technical names and acronyms when an actual technical reason exists.
3. **Canonical vocabulary:** Battery → Baterai; Battery Temperature → Suhu Baterai; generic Hotside component references → Sisi Panas; Hotside Temperature → Suhu Sisi Panas; Hotside Limit → Batas Suhu Sisi Panas; generic thermal-protection prose → Perlindungan Sisi Panas; generic cooler → pendingin; Adaptive Mode → Mode Adaptif; Fan → Kipas; Fan Speed → Kecepatan Kipas; Voltage → Tegangan. For general prose that mentions both components, use natural wording such as “Sisi Panas dan Baterai”; do not invent a separate profile label from that phrase. The Adaptive profile selector has its own exact owner-approved exception, defined in the following decision section and bound to specific localization keys. Use “suhu baterai ponsel” in explanatory prose only when the phone-battery source needs to be distinguished; do not append “HP” to the compact metric title.
4. **Protected names:** keep JE X FYZ, JE Cooler, Bluetooth, Peltier, LED, OTA, SSID, BLE and NTC where they are names/acronyms or necessary technical terms. Keep the approved Floating Monitor / Monitor Melayang pair, language-picker presentation English / Indonesia, Home Notification / Notifikasi heading, Bluetooth connected notification pair, and App Developer & Builder / Pengembang Aplikasi & Perakit credit. “Firmware” may remain when it refers to the actual Firmware subsystem; generic Indonesian wording must still be fully translated. Do not translate or rename source identifiers, database keys, enum/storage values, BLE command strings, protocol fields or native channel IDs.
5. **Capitalization:** use consistent title capitalization for headings, section names and short named labels (for example, “Hotside Temperature” / “Suhu Sisi Panas”). Use normal sentence capitalization for explanations, notifications and full messages; capitalize proper names/acronyms exactly. In Indonesian running prose, write the generic translated phrase in lowercase unless it begins a sentence or is a title (for example, “suhu sisi panas” in a sentence but “Suhu Sisi Panas” as a heading). Reserve ALL CAPS for deliberate compact state/status badges and fixed metric identifiers; do not make ordinary sentences or descriptions uppercase. Do not vary title casing for the same term across screens.
6. **Punctuation and composition:** complete sentences end with one appropriate punctuation mark; short labels/buttons/tooltips do not gain unnecessary full stops. Use one space after punctuation, no space before commas/periods, consistent colon and parenthesis usage, and one approved ellipsis character (…) rather than mixing three dots and the ellipsis glyph. Use the middle dot only as a deliberate compact separator, not as a substitute for sentence punctuation. Dynamic fragments must be reviewed as the final assembled sentence in both languages.
7. **Numbers and units:** English decimal separator is a point; Indonesian decimal separator is a comma. Use locale-aware grouping for large numbers. Keep technical unit formatting consistent: “12 V”, “45 °C” and “50%”; do not mix “12V” with “12 V” or “45°C” with “45 °C” in equivalent presentation surfaces. Keep protocol/storage values unchanged even when visible labels use localized formatting. Byte counts must explicitly identify received versus expected values and use Indonesian “byte” in Indonesian copy.
8. **Dates and time:** use local device time for user-facing history, avoid ambiguous date-only numeric ordering in explanatory copy, and make the visible date format consistent with the selected App language. Preserve the existing 24-hour time convention unless a separate owner decision changes it.
9. **State vocabulary:** distinguish physical outputs from logical modes and user preferences. Physical Fan/Peltier/LED output status uses the approved compact ON/OFF (EN) and HIDUP/MATI (ID), with natural prose “menyala/mati”. Adaptive logical mode uses ACTIVE/INACTIVE (EN) and AKTIF/NONAKTIF (ID). Enabled/Disabled preferences are a separate concept. Never perform a global replacement across these categories.
10. **Safety and diagnostic copy:** use “Keselamatan” for thermal safety, not “Keamanan”. State the prerequisite and order explicitly in prose. Never expose raw internal tokens such as FAN, PELTIER, HOT, NTC_ERROR, underscore-formatted reason codes or raw OTA diagnostics to ordinary users. Preserve legacy input parsing only to re-localize stored notices; newly generated text must follow the new glossary.
11. **UI length and accessibility:** keep labels concise without deleting essential meaning. Review the longest translated values at supported widths, text scales, Light/Dark themes, dialogs, notifications and the compact Floating Monitor. Accessibility labels/tooltips must express the same action/state as visible text.

### Owner decision — Adaptive profile labels, Adaptive ceiling display and RGB toggle — 2026-11-15

**Adaptive ceiling display removal**
- Remove the entire user-facing Adaptive ceiling information card from the Adaptive control page. This is the row/card currently showing the localization key `adaptiveCeiling` (English “Adaptive Limit” / Indonesian “Batas Adaptif”) beside the current `adaptiveCeiling` voltage value.
- Do not replace the card with another ceiling label, table, badge or text elsewhere in that same Adaptive profile area.
- This is a **presentation-only removal**. Preserve the actual Adaptive voltage ceiling behavior, Firmware-side `adaptiveCeiling` state, `ADAPTIVE_CEILING` BLE telemetry/state synchronization, clamp logic, and all safety/voltage-transition rules. The visible card is not the safety mechanism; the internal maximum-voltage ceiling remains essential.
- Keep the Adaptive profile selector and its two options. Removing the readout must not change Adaptive ON/OFF, profile selection or Lock Voltage gating.

**New bilingual Adaptive profile names**
Use these exact owner-requested Indonesian names and the following complete English master labels:
- English: **Hotside Protection**  
  Indonesian: **Perlindungan Suhu Panas**
- English: **Hotside & Battery Protection**  
  Indonesian: **Perlindungan Suhu Panas & Baterai**

**Localization-key binding verified against current main:** `lib/main.dart` builds the active selector from `JexText.of('hotsideProtection', lang)` and `JexText.of('hotsideBattery', lang)`. Therefore the required exact values must be stored under `hotsideProtection` and `hotsideBattery`, not merely mentioned in notes. The dictionary also retains legacy aliases `hSideProtection` and `hSideBattery`; keep those keys (do not delete or rename IDs) and align their displayed values to the same exact profile pairs as the active keys, so no legacy/dynamic lookup can surface obsolete selector copy. Keep the separate `hotsideProtectionActive` sentence in the generic thermal category, where Indonesian must say `Sisi Panas`, not the selector-only phrase. This distinction prevents an over-broad glossary replacement.

These are the exact owner-approved contextual Adaptive profile labels. Keep the English master strings exactly as `Hotside Protection` and `Hotside & Battery Protection`: do not insert `Temperature`, hyphenate `Hotside`, or replace `&` with `+`. The Indonesian strings remain exactly as shown above. These labels apply only to this Adaptive profile selector; keep internal/persisted/protocol profile values `HOTSIDE`, `HOTSIDE_BATTERY`, `HOTSIDE_PROTECTION` and related identifiers unchanged. The generic glossary mapping for other thermal component references remains context-sensitive; chart titles and explanatory copy continue to use the approved Sisi Panas terminology.

**RGB toggle naming**
- Keep the LED section heading as **LED**.
- Keep the master toggle label **RGB Power** in English and **Daya RGB** in Indonesian. Do not rename this switch to “LED” or “LED Power”.
- Reason: the switch sends the RGB ON/OFF command and controls the user-selectable RGB lighting effect only. It does not switch off all LED indicators; voltage/system/safety indicators have independent behavior and priority. Calling the toggle “LED” would imply a broader function than it actually controls. “RGB Power” is therefore the accurate control name, while “LED” remains the broader section name.
- Preserve RGB command strings, mode IDs, color values, brightness behavior and Firmware indication priority.

**Required regression coverage for a later authorized implementation**
- Assert that the Adaptive page no longer renders “Adaptive Limit” / “Batas Adaptif” or the ceiling-value card.
- Assert that the new two Adaptive profile labels render correctly in English and Indonesian.
- Retain source/protocol/state-contract checks for `ADAPTIVE_CEILING`, actual ceiling clamp behavior and Lock Voltage safety gating.
- Assert that the LED section remains “LED” and its master toggle remains “RGB Power” / “Daya RGB”; include a regression check that independent voltage/system/safety LED indicators are not treated as controlled by the RGB user-effect switch.
- Update any source-contract tests and existing wording expectations together. Do not weaken Firmware or safety tests to satisfy the visual copy change.

**Evidence boundary:** this is a Diskusi decision and documentation update. No App/Firmware source, tests, configuration, build or device operation is changed or run here.

### Comprehensive language/copy audit — 2026-11-15 (read-only findings)

**Inventory at current main:** `lib/app_settings.dart` has 353 English/Indonesian dictionary entries (all entries contain both locales); `main.dart`, `floating_monitor.dart` and `usage_statistics.dart` contain 167 direct `JexText.phrase()` call sites and 258 `JexText.of()` lookup call sites. Native user-facing notification text is separately implemented in `JeForegroundService.kt`, `FloatingMonitorService.kt` and `MainActivity.kt`. The 353-entry structural/placeholder checks do not prove grammar, meaning, casing or full translation. Some repeated key/value pairs are contextual aliases and must be checked before consolidation.

**Confirmed copy defects / exact source targets:**
- `lib/app_settings.dart`: `hotside` still returns “Hotside” in Indonesian; the limit, protection, Hotside+Battery, temperature, confirmation/failure, notification-description and active-protection entries also contain untranslated Hotside. Apply the approved “Sisi Panas” glossary to all visible variants and keep internal key names unchanged.
- `lib/usage_statistics.dart`: the visible chart title is “Battery Temperature / Suhu Baterai HP” although the canonical dictionary already says “Suhu Baterai”; Hotside title is “Hotside Temperature / Suhu Hotside”; selected-time labels use “Battery / Baterai HP” and “Hotside”. The Info sentence mixes “Battery”, “Hotside” and “cooler” in Indonesian. The empty-state sentence exposes FAN and PELTIER protocol tokens. The clear-history and no-cooler messages also leave “cooler” untranslated.
- `lib/main.dart`: Peltier re-arm, Hotside-limit/NOTIFY messages and Adaptive-profile construction still generate “Hotside” in Indonesian. The parser recognizes legacy “Hotside” and “Sisi panas” variants, but the output branch currently rebuilds the Indonesian profile with “Hotside”; retain legacy parsing while generating the new translated term.
- `lib/floating_monitor.dart`: review the “Firmware V7.2+ required” sentence for natural Indonesian wording while preserving the technical Firmware version requirement.
- `test/usage_statistics_test.dart` still asserts “Suhu Baterai HP” and “Suhu Hotside” in multiple cases; update those expectations together with the visible copy. `test/widget_test.dart` also locks old Hotside wording in selected localization/relocalization assertions.
- Native Kotlin copy is separate from Flutter localization. Review the background-service notification/channel, Floating Monitor channel/title/body and main device-alert channel descriptions as complete bilingual pairs; retain owner-approved Bluetooth notification wording and channel IDs.
- The LED color palette contains many named shade translations. Review hue meaning, accepted Indonesian color terms, duplicated display names and Title Case as a separate visual glossary; do not alter HEX values or persisted color IDs.

**Formatting/capitalization defects or required verification:**
- `usageStateLabel()` renders normalized voltage as “12 V”, while other App strings and messages still use “5V/9V/12V”; unify visible unit formatting without changing protocol values.
- Usage Statistics’ `_formatTemperature()` already uses a locale decimal separator and a space before °C, but Home notices and chart reference labels concatenate “°C” without that space. Align equivalent visible measurements.
- `formatUsageAxisTick()` always uses a decimal point and has no locale input; review Indonesian rendering for any fractional tick labels. The compact Floating Monitor scale value uses fixed-dot formatting (“0.60×”) in both locales.
- Session timestamps use a fixed `dd/MM HH:mm` shape for both locales and omit the year. Review locale-appropriate, unambiguous display while preserving local-time conversion and the compact layout.
- Capitalization varies between title labels, sentence copy and state chips (for example, “Coba Lagi” versus “Coba lagi”, and “Firmware” versus “firmware”). Apply the rules above by context; do not lowercase proper names, technical acronyms or deliberate status badges.

**Regression gap:** `test/localization_contract_test.dart` checks that the dictionary has both locales and that placeholders match; it checks selected safety/state examples and placeholder parity for inline pairs. It does not enforce the full glossary, sentence meaning, mixed-language rejection, punctuation/capitalization rules, locale-aware numeric/date rendering or native notification copy completeness. Add content-quality tests by semantic category, not a naive ban on every English-looking word (which would reject valid terms such as Bluetooth, Firmware, Peltier and OTA).

**Scope/evidence:** this is a static source review and documentation decision only. No executable source, tests, native code, formatting, analyzer, test suite, Android rendering or App Build was changed/run in Diskusi. Implementation must update all visible surfaces and regression expectations together; Build App remains a separately authorized step.
- Historical local-validation note (2026-11-10): that source-review session lacked Flutter/Dart/Android tools and did not run formatter, tests, analyzer or device rendering. This was superseded by Build #153 hosted evidence: analyzer 23 infos/zero warnings/errors and 176/176 Flutter tests passed. OEM visual acceptance and Firmware/device validation remain unverified.

### Resumed full-surface copy audit — 2026-11-16 (static source review)

This continuation refines the 2026-11-15 findings. Live source still has **353** dictionary entries (not 354), 167 inline bilingual phrase calls (117 in main.dart, 11 in floating_monitor.dart, 39 in usage_statistics.dart) and 258 literal JexText lookup calls. Each dictionary entry has EN and ID values, but presence/placeholder parity is not semantic or editorial validation. This remains a static source review.

**Pre-implementation binding correction — 2026-11-16**
- The owner-approved Adaptive profile text was recorded, but the handoff did not identify the live dictionary keys consumed by the selector. Current `lib/main.dart` uses `hotsideProtection` and `hotsideBattery`; their current dictionary text is still `Hotside Protection / Perlindungan Hotside` and `Hotside + Battery / Hotside + Baterai`. Those active key values therefore do not yet implement the owner decision.
- Correct the active keys to the exact pairs `Hotside Protection / Perlindungan Suhu Panas` and `Hotside & Battery Protection / Perlindungan Suhu Panas & Baterai`. Keep the legacy aliases `hSideProtection` and `hSideBattery` rather than deleting keys; if any dynamic consumer reaches them, their display values must match the same profile pairs. Do not globally change `hotsideProtectionActive`, which is ordinary thermal prose and must use `Sisi Panas`.
- The currently visible `adaptiveCeiling` row is rendered from `JexText.of('adaptiveCeiling', lang)` plus the live value in the Adaptive page. Remove only this user-facing card/row. Retain the underlying state variable, BLE telemetry, Firmware clamp, profile logic and Lock Voltage behavior.
- This is a precise source-to-requirement mapping for the next authorized implementation; no source/test/native file was changed during this Diskusi review.


**Additional confirmed wording and state defects**
- The shared `volt` label is EN `Volt` / ID `Tegangan`. The English word names a unit, while the Indonesian word names the measured quantity. Use EN `Voltage` / ID `Tegangan` for the Floating Monitor metric label.
- `otaModeOnline` currently renders `Online` in both languages. In Indonesian OTA result copy, use the standard translation `Daring`; preserve `OTA` as the technical acronym. Do not change internal OTA mode values such as `ONLINE`.
- The sentence `Adaptive Mode is forced OFF while Lock Voltage is active.` is paired with `Mode Adaptif dipaksa MATI selama Kunci Tegangan aktif.`. Adaptive is a **logical mode**, not a physical output. The sentence must use EN `inactive` and ID `nonaktif` (for example, `Adaptive Mode is forced inactive while Lock Voltage is active.` / `Mode Adaptif dipaksa nonaktif selama Kunci Tegangan aktif.`). Keep physical Fan/Peltier/LED output wording ON/OFF and HIDUP/MATI unchanged.
- The Temperature screen uses `5V Limit` and `12V Limit` for two battery-temperature thresholds under a `Battery Temperature Zones` heading; their source keys identify a 5 V ceiling and a 12 V floor, while the values themselves are temperatures. These short labels are ambiguous without their parent heading. Implementation should make the voltage zone and threshold role explicit (candidate labels: `5 V Battery Temperature Ceiling` / `Batas atas suhu baterai pada 5 V`, and `12 V Battery Temperature Floor` / `Batas bawah suhu baterai pada 12 V`). Confirm the exact ceiling/floor semantics against the existing Firmware contract; do not change threshold values or control behavior.
- The Indonesian device-alert channel title is `Notifikasi perangkat` while the English title is `Device alerts`. These are not exact equivalents; use a faithful pair such as `Device alerts` / `Peringatan perangkat`. The existing channel ID and its permission/importance behavior are protected.
- The Adaptive selector remains a **specific exception** to the general Hotside glossary. Its exact pairs are EN `Hotside Protection` / ID `Perlindungan Suhu Panas` and EN `Hotside & Battery Protection` / ID `Perlindungan Suhu Panas & Baterai`. In all other generic thermal prose/metrics, translate Hotside as `Sisi Panas`. Do not run a blind global replacement across the selector and general copy.

**Additional verified formatting defects**
- Home safety/threshold notices emit temperature values as `45°C` and use a dot decimal in both locales; chart reference labels also append `°C` without the required preceding space. Match the existing Usage Statistics formatter: EN `45.8 °C`, ID `45,8 °C`. The Home parser/relocalizer must still accept legacy `45°C` and dot-decimal stored notices as well as the new spaced/comma forms.
- The phone-battery reading is converted to a one-decimal string with a period before it is displayed. Render the localized decimal separator at the UI boundary, but keep the raw numeric value and the frozen `PHONE:BT=` telemetry payload in its existing dot-decimal format.
- Native Floating Monitor HUD currently appends a bare degree symbol (`°`) to Battery/Hotside readings rather than `°C`; it also displays the voltage telemetry string without spacing and shows numeric Fan Speed without its percentage sign. Keep the compact metric identifiers `B/H/V/A/P/F` and all telemetry/state fields unchanged, but present complete, consistent units (for example, `45,8 °C`, `12 V`, `80%` in Indonesian).
- OTA upload-size mismatch formatting interpolates raw byte counts without locale grouping. Preserve received/expected order, but localize grouping (for example, `120,400 bytes` in English and `120.400 byte` in Indonesian); do not alter the numeric event/protocol fields.
- Session labels use local time but a fixed `dd/MM HH:mm` layout for both languages and omit the year. Use a locale-appropriate, unambiguous date with the existing 24-hour clock, retaining local-time conversion and compact layout. Do not parse or rewrite stored timestamps.
- Usage axis tick formatting and Floating Monitor scale formatting remain dot-decimal in Indonesian. Add the selected AppLanguage at the display-formatting boundary so EN uses a decimal point and ID uses a comma; keep persisted doubles, calculations and protocol payloads unchanged.
- Voltage choices and many messages still display `5V/9V/12V`, while Usage Statistics already formats telemetry as `5 V/9 V/12 V`. Standardize visible unit spacing, not internal values, command strings, stored event values or comparison keys.

**Color-name and alias handling**
- The current curated palette uses named shades tied to fixed HEX values. Names such as Dodger Blue and Rebecca Purple are proper named colors; do not replace them with approximate hue words without checking the swatch. Review all Indonesian shade labels against their exact HEX hues and accepted Indonesian color terms. `Teal Karibia` is a mixed-language candidate; `Biru Dodger` and `Ungu Rebecca` may be retained as proper-name forms if the final color glossary explicitly classifies them that way.
- Several dictionary keys intentionally share display values. `hSideProtection` and `hSideBattery` are duplicate legacy aliases; no literal use was found in the scanned Dart UI files, while the active Adaptive selector uses `hotsideProtection` and `hotsideBattery`. Align alias values with the exact owner-approved profile labels if a dynamic consumer is found; do not delete keys or change HEX values/persisted IDs merely to remove duplicates.
- `Coba Lagi` is appropriate for a standalone title-cased button label, while `Coba lagi` is appropriate in sentence case. Preserve the contextual capitalization rule; do not normalize these with a global replacement. Capitalize `Firmware` only when it denotes the named Firmware subsystem; use normal sentence capitalization for generic prose.

**Native notification surface checked**
- `JeForegroundService.kt`, `FloatingMonitorService.kt` and `MainActivity.kt` carry distinct user-visible channel names/descriptions and foreground notification title/body strings. The existing Bluetooth-connected notification pair is owner-approved and should remain exact. Floating Monitor's channel/title/body pairs are already semantically aligned. The device-alert title pair above needs correction. Dynamic MainActivity alert title/body come from Flutter and therefore must remain covered by the Flutter copy tests as well as the native channel tests.
- Keep channel IDs, notification IDs, permission requests, foreground-service type, priority, sound/vibration settings and channel behavior untouched during a copy-only implementation.

**Implementation and regression matrix**
- Update the 353-key glossary and all 167 inline phrase pairs; preserve all intentional technical names, placeholders and contextual exceptions. Audit final assembled dynamic messages, not just fragments.
- Correct Usage Statistics titles, selected-time labels, empty state and history-info sentence. Use full Indonesian such as `Sesi hanya direkam ketika Firmware mengonfirmasi bahwa kipas atau Peltier menyala.`; never render raw `FAN` or `PELTIER` tokens in prose.
- Correct Home/NOTIFY Hotside output to `Sisi Panas` in Indonesian while retaining recognition of historic stored-message variants (including old `Hotside` wording). Do not change protocol reason IDs, internal profile IDs, telemetry fields or safety severity.
- Keep exact Adaptive profile labels and remove only the visible Adaptive ceiling card/value; retain `adaptiveCeiling`, `ADAPTIVE_CEILING` telemetry, Firmware clamp and Lock Voltage gating. Keep `LED` heading and `RGB Power` / `Daya RGB` toggle.
- Update `test/usage_statistics_test.dart`, `test/widget_test.dart`, `test/localization_contract_test.dart` and `test/device_copy_notification_contract_test.dart` together. Add curated semantic-pair/glossary assertions, locale-number/date/unit tests, dynamic-notice legacy/new-form tests, no-raw-token UI assertions, exact native channel pair checks and protected-state/protocol regressions. Do not ban every English-looking token; the permitted technical names and owner exceptions must be explicit.
- Formatting helpers must operate on presentation values only. Never feed localized decimal commas, spaced voltage labels or translated labels back into BLE commands, stored state, SQLite keys, Firmware comparisons or notification reason identifiers.

**Evidence and authorization:** no App source, test, Kotlin/native file, config, workflow or Firmware file was changed. No formatter, analyzer, Flutter test, Android render, screenshot or build was run. These are confirmed static findings and an implementation plan under recovered Diskusi authorization; source changes require a separate explicit `Eksekusi Full!`, and a new APK requires the separate `Eksekusi Build App!` command.

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
  - **App Development & Build** — Horizon — `@horizontalzzz`.
  - **Design Inspiration** — FYZ — `@FYZ737`.
  - **3D Design & Printing** — Logos — `@Logos3dMichael`.
  - Indonesian heading: **JE Cooler**; credit heading: **Ucapan Terima Kasih**.
  - **Pengembangan Aplikasi & Build** — Horizon — `@horizontalzzz`.
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


## Usage Statistics alignment refinement — source and hosted validation — 2026-11-14

- The owner screenshots exposed centering/alignment inconsistencies in the AppBar, temperature Min/Avg/Max strip, Activity elapsed axis and Selected time readout. The current main source centers the AppBar title and each metric summary; the Activity axis labels share the plot gutters used by chart/timeline/cursor geometry.
- The Selected time dock now centers its heading/time cluster and all six labels/values while retaining two rows of three, bottom SafeArea, fixed 48×48 dp clear control and the existing compact dock limit. The close target is reserved independently at the right edge.
- Voltage/Adaptive/Peltier timeline state segments are thinner and vertically centered within the existing 34-dp interaction lane. Fan Speed plot semantics and height are unchanged.
- No capture, BLE/P1, telemetry, session, SQL schema, retention, queue, aggregate, temperature range, Hotside limit, null-gap, cursor selection or sensor-truth logic was intentionally changed.
- Implementation commit `b4b57e83261c0b1fcb7873efa8544c3410ad0208`; formatter-only follow-up `873a825020659dadcac2e5c7242e759209776414`. Validation Only run #16 / job `132317129708` passed on exact formatted source `873a825020659dadcac2e5c7242e759209776414`: locked dependencies, clean formatter, analyzer (119 infos, zero warnings/errors), and 188/188 Flutter tests.
- This source is not included in Build #162. Android screenshot/OEM acceptance remains VISUAL NOT VERIFIED until a new separately authorized App package is installed and inspected.


### Owner request — English-master language quality audit (Diskusi only) — 2026-11-14

**Owner direction:** English is the master copy. Every user-facing English phrase must be grammatically correct and serve as the semantic source for its Indonesian translation. Indonesian may use natural Indonesian grammar, but must not add, omit, weaken or change the meaning, condition, subject, action, timing, certainty or safety severity.

**STATIC SOURCE AUDIT — source code/test baseline `873a825020659dadcac2e5c7242e759209776414`:**
- `AppSettings()` defaults to `AppLanguage.english`; `JexText.phrase(english, indonesia)` chooses its first argument for English.
- `lib/app_settings.dart` contains 354 localization keys, each with both `AppLanguage.english` and `AppLanguage.indonesia` values.
- Flutter call sites include 167 inline bilingual `JexText.phrase()` calls across `main.dart`, `floating_monitor.dart` and `usage_statistics.dart`, plus 260 `JexText.of()` call sites. Some lookup keys are dynamic (LED color presets and OTA stage labels); static literal-only checks cannot establish all runtime paths.
- Native foreground-service/Floating Monitor notification text is bilingual but maintained separately in `JeForegroundService.kt` and `FloatingMonitorService.kt`.
- Existing `test/widget_test.dart` verifies that all dictionary entries contain both locales and tests selected terminology; it does not judge the semantic accuracy or grammar of every pair. It currently explicitly requires display labels `English / Indonesia` and ON/OFF labels `HIDUP / MATI` in Indonesian.
- Internal enum/storage identifiers `english` and `indonesia` are compatibility values; a display-label correction must not casually rename them. Preserve protocol tokens, IDs, UUIDs, brand names, technical values, placeholders and unit symbols.

**Concrete review candidates (not yet owner-approved corrections):**
- Language picker: English UI currently labels the language `Indonesia`; recommended review is `Indonesian`. In the Indonesian UI, consider `Bahasa Inggris / Bahasa Indonesia`. Update display copy/tests only if approved; retain the internal enum/storage identifier.
- `peltierFanRequiredTitle`: “Fan required before cooling” → “Kipas perlu dinyalakan” omits the explicit before-cooling relationship.
- `peltierSafety` and `sensorErrorCoolingLocked`: “Safety” is translated as `Keamanan` in these keys while other safety copy uses `Keselamatan`; standardize based on safety meaning, not security.
- `otaUploaded` + `otaBytes`: the Indonesian fragment describes “ukuran unggahan” while the English fragment says “uploaded [N] bytes”; review the whole assembled sentence, not fragments independently.
- `fullSyncFailed`: “Could not complete device sync.” is rendered “Sinkronisasi perangkat tidak selesai.”; review a more natural exact equivalent such as “Tidak dapat menyelesaikan sinkronisasi perangkat.”
- `resetDeepSleep`: Indonesian wording omits the explicit sleep state in “low-power sleep”.
- `main.dart` inline phrase at the safety notice path: “Safety checks passed.” → “Pemeriksaan keselamatan normal.” changes “passed” into “normal”.
- About credit source uses “App Developer & Builder” / “Pengembang Aplikasi & Perakit”, while the prior approved APP_NOTES wording is “App Development & Build” / “Pengembangan Aplikasi & Build”. Resolve the role wording against owner intent.
- State terminology differs by surface: catalog/native HUD uses `HIDUP/MATI`, Usage Statistics uses `AKTIF/NONAKTIF`, and full-sentence notifications use `aktif/nonaktif`. Decide a context-aware consistent glossary; do not mechanically force one word where the UI meaning differs.
- Review less severe technical labels such as “Dual Chase” / “Chase Ganda”, “Wi-Fi retry” / “Percobaan Wi-Fi”, and “Range retry” / “Ulangi rentang” for clarity and consistent OTA terminology.

**Proposed process:** review all 354 catalog pairs, all 167 inline phrase pairs, dynamic lookup contexts and native notification/service copy. Produce a bilingual terminology glossary and an exhaustive correction table before source edits. This is a discussion/audit record only: no executable source, tests, config, native code, workflow, build or release was changed or run. Gemini has not been contacted; a copy-ready handoff prompt was prepared for the owner to paste with the source attachments.



### Gemini second-opinion review — report received / partial due to missing attachments — 2026-11-14

**Evidence boundary:** The uploaded `JE X FYZ Language Audit Report.txt` explicitly states that Gemini received no attached source files and therefore did not perform the exhaustive 354-key / 167-inline-phrase review. Its Part C lists only prompt-provided candidates and marks the remaining entries pending file attachment. Treat this report as a useful architecture/glossary proposal and a partial review, not a completed source audit. The owner has already supplied the source files to this ChatGPT audit, so the following cross-check is based on the live `main` source currently inspected here.

**Recommendations supported by live source and existing owner notes:**
- English display label should be `Indonesian`, not `Indonesia`; Indonesian locale may display `Bahasa Inggris / Bahasa Indonesia`. Change display values/tests only; retain `AppLanguage.english`, `AppLanguage.indonesia` and serialized preference identifiers.
- Translate physical/thermal `Safety` as `Keselamatan`; reserve `Keamanan` for Security/access/cryptographic concepts. Current `peltierSafety` and `sensorErrorCoolingLocked` use `Keamanan` for thermal safety.
- Improve `peltierFanRequiredTitle` to a complete and precise pair such as `The fan must be on before cooling starts.` / `Kipas harus menyala sebelum pendinginan dimulai.`. Priority is copy clarity: the adjacent existing body/detail already states that the fan must be ON before Peltier starts, and the source flow sends FAN:ON, waits for ACK, then sends PELTIER:ON. This is not evidence of a broken Firmware safety interlock and should not be labelled a P0 hardware defect.
- Correct `Safety checks passed.` / `Pemeriksaan keselamatan normal.` because `normal` does not express a successful/passed check. Recommended ID: `Pemeriksaan keselamatan berhasil.` (or `Semua pemeriksaan keselamatan lolos.` after voice/tone review).
- `fullSyncFailed`: `Gagal menyelesaikan sinkronisasi perangkat.` is a clearer full equivalent than `Sinkronisasi perangkat tidak selesai.`.
- `resetDeepSleep`: preserve sleep explicitly: `Perangkat kembali aktif dari mode tidur hemat daya.`.
- Restore the previously owner-approved About role pair from this file's 2026-11-12 About brief: `App Development & Build` / `Pengembangan Aplikasi & Build`, rather than source's `App Developer & Builder` / `Pengembang Aplikasi & Perakit`. The latter misleadingly suggests physical assembly.
- Gemini's context-aware separation of physical `ON/OFF`, logical `Active/Inactive` and preference `Enabled/Disabled` is a useful glossary direction, subject to per-surface mapping below.
- `Range retry` / `Ulangi rentang` needs clearer download context; `Download range retry` / `Percobaan ulang rentang unduhan` is a reasonable candidate. `Firmware image verification` / `Verifikasi citra firmware` and `Flash readback verification` / `Verifikasi baca ulang Flash` are candidates, subject to the exact OTA stage semantics and copy width.

**Corrections / limits to Gemini's recommendations:**
- Do NOT adopt the glossary proposal that `Floating Monitor` must remain English in both locales. Existing owner-approved `APP_NOTES.md` explicitly specifies `Floating Monitor / Monitor Melayang`, including Android foreground-service notification/channel copy. The current source and tests follow that bilingual contract.
- Do NOT replace the OTA upload-size mismatch message with `Uploaded {count} bytes` / `Terunggah {count} byte`. The App constructs `otaUploaded + parts[3] + ' / ' + parts[4] + otaBytes`. The active Firmware sketch formats the event as `UPLOAD_SIZE_MISMATCH_<received>_<expected>`, using `localOtaBytesReceived` then `localOtaExpectedBytes`. Both values, their order and the mismatch/failure meaning must be preserved. Preferred future full-sentence pair should use named placeholders, for example: EN `OTA failed: {receivedBytes} bytes received; {expectedBytes} bytes expected.`; ID `OTA gagal: {receivedBytes} byte diterima, sedangkan {expectedBytes} byte diharapkan.`. Verify final copy length in the Home notification surface.
- Gemini's `Active/Inactive` taxonomy is not yet fully implemented by the current source. `usage_statistics.dart::_localizedUsageStateValue()` currently maps every ON/OFF value to `AKTIF/NONAKTIF`, including both Adaptive and Peltier readouts, even though Adaptive Mode is a logical mode and Peltier is a physical output. Native HUD also currently shares HIDUP/MATI for A and P. Any approved taxonomy must map each metric/control explicitly: Peltier/Fan/LED hardware outputs vs Adaptive Mode/Lock Voltage logical state vs user preference Enabled/Disabled. Do not globally replace strings without context.
- The fan prerequisite title is a short title; the nearby `fanRequiredPeltier` and `peltierCoolingPrerequisite` body copy already preserve the condition. Treat the title as a wording improvement, not proof that the system currently allows cooling without fan confirmation.
- The former rule that kept `Hotside` unchanged in Indonesian was superseded by the owner's explicit 2026-11-15 decision: all Indonesian user-facing Hotside terminology must render as `Sisi Panas`. Preserve the English term and all internal/protocol identifiers unchanged. `Floating Monitor / Monitor Melayang` remains the approved bilingual feature name.

**Test-plan assessment:** Gemini's test ideas are directionally useful: non-empty catalog pairs, correct display labels without renaming enum/storage values, Safety glossary invariant, state mapping by semantic class, placeholder/unit preservation, full OTA mismatch rendering, EN/ID layout fit at 350/420 dp and light/dark. Add explicit tests for inline phrase pairs and dynamic lookup branches, native notification/channel locale changes, and separate Peltier-vs-Adaptive Usage Statistics/HUD state labels. Avoid simplistic scans that reject legitimate technical terms or synonyms without checking context. No tests were run in this Diskusi.

**Decision status:** These are cross-checked recommendations, not source edits. The high-level English-master / Indonesian-same-meaning rule is owner-directed. Specific copy recommendations remain to be approved in the subsequent execution scope. No executable source, test, Firmware, native code or APK was modified by this review.

 
### Latest source-driven localization audit correction — 2026-11-14

**Evidence baseline:** executable source at 873a825020659dadcac2e5c7242e759209776414; audit performed against current-main documentation HEAD 088e18e3995f0564cbca970f830a5a7b027320b3. Current main remains source-identical to that baseline; the intervening 18 commits changed only eight Markdown files.

- Corrected inventory: JexText.phrase() has **166 actual inline call sites** (116 in main.dart, 10 in floating_monitor.dart, 40 in usage_statistics.dart). The earlier count of 167 included a comment in main.dart. There are 260 JexText.of() call sites across those three UI files. The dictionary has 354 complete bilingual entries; a static parser found no placeholder-set mismatch among those dictionary pairs.
- Confirmed wording defects: peltierSafety translates thermal Safety as Keamanan Peltier; sensorErrorCoolingLocked uses demi keamanan for a thermal-protection condition; peltierFanRequiredTitle omits the “before cooling” relationship; and Safety checks passed. is translated as Pemeriksaan keselamatan normal., which does not preserve “passed”.
- State consistency requires a per-metric map. usage_statistics.dart::_localizedUsageStateValue() maps ON/OFF to AKTIF/NONAKTIF for Adaptive and Peltier readouts. Native FloatingMonitorService.kt::itemText() maps both A (Adaptive) and P (Peltier) to HIDUP/MATI. These labels are not consistent across surfaces or semantic classes; separate physical output, logical mode/lock and preference states before choosing words. Do not globally replace state terms.
- OTA mismatch event order is verified in firmware/JEXFYZ-V7.2.ino: UPLOAD_SIZE_MISMATCH_<received>_<expected>. The App renders the two values in that order, but the assembled wording “uploaded X / Y bytes” does not clearly identify the expected count. A future full sentence should label both values explicitly and preserve both numbers and order.
- The native foreground notification and Floating Monitor channel/notification text are bilingual. Preserve the owner-approved Floating Monitor / Monitor Melayang label and its native copy.
- **About-credit correction:** the current approved contract at the top of this file is App Developer & Builder / Pengembang Aplikasi & Perakit. Do not follow the older Gemini/checkpoint suggestion to change this to App Development & Build; that suggestion conflicts with the current canonical App contract. DEVELOPED BY HORIZON / DIKEMBANGKAN OLEH HORIZON is a separate Home subtitle.
- Other review candidates, not confirmed defects: fullSyncFailed naturalness, explicit “sleep” in resetDeepSleep, display names Indonesia / Indonesian, and OTA stage wording such as Range retry / image verification. The language-picker tests currently lock display values to English / Indonesia; display wording can change only after owner approval, while enum/storage IDs remain fixed.
- Existing localization tests verify dictionary field presence and selected examples; they do not establish semantic equivalence for all dictionary/inline/native strings. No tests were run in this Diskusi session.

**Status:** STATIC SOURCE CHECK / discussion-only audit. No executable source, tests, config, workflow, build, release, Firmware, BIN, Firebase, OTA, flash or device operation was changed or triggered. A separate Eksekusi Full! is needed before source/test implementation.


## Gemini localization answer cross-check — 2026-11-15 (Diskusi only)

**Evidence baseline:** current main at the incoming review was `cef1de09f9e71e581dc51766758a017ba0745b3c`, recursive tree 137 entries / `truncated=false`. Compare against executable source baseline `873a825020659dadcac2e5c7242e759209776414`: 33 commits ahead / 0 behind; all eight changed paths are Markdown. The live Dart/Kotlin/Firmware source and tests therefore still match the source inspected in the preceding localization audit.

### Gemini recommendations accepted with corrections

- Thermal/physical Safety should use `Keselamatan`: correct `peltierSafety` to `Keselamatan Peltier` and `sensorErrorCoolingLocked` to `... demi keselamatan`. `Keamanan` is less precise in this thermal-protection context. This is a user-facing terminology defect, not evidence of a failed safety function.
- The Fan prerequisite title should explicitly state timing. Preferred concise pair: EN `The fan must be on before cooling starts.`; ID `Kipas harus menyala sebelum pendinginan dimulai.`. The current supporting body already says Fan is confirmed ON before Peltier starts, and the source flow remains FAN:ON → successful ACK → PELTIER:ON. Therefore this is a title-clarity fix, not a broken interlock.
- For that body sentence, prefer natural prose `Kipas akan dipastikan menyala sebelum Peltier mulai bekerja.` rather than inserting an uppercase badge word `HIDUP` into a full sentence. Keep HIDUP/MATI for compact physical-output badges.
- `Safety checks passed.` → `Pemeriksaan keselamatan berhasil.` is accepted; current `Pemeriksaan keselamatan normal.` describes a condition rather than a successful check.
- Split state presentation by semantic domain: Usage Statistics should show Adaptive as a logical mode (`Active/Inactive` / `AKTIF/NONAKTIF`) and Peltier as a physical output (`ON/OFF` / `HIDUP/MATI`). Keep Voltage labels (5V/9V/12V) unchanged. Native HUD should likewise map A separately from P.
- Keep Fan metric F's actual behavior: when running it displays the numeric PWM speed, not an ON label; when off it displays OFF/MATI. Thus the P/F physical-output glossary applies to F's off state only.
- OTA full-sentence proposal is accepted: EN `OTA failed: {receivedBytes} bytes received; {expectedBytes} bytes expected.`; ID `OTA gagal: {receivedBytes} byte diterima; {expectedBytes} byte diharapkan.`. Firmware emits `UPLOAD_SIZE_MISMATCH_<received>_<expected>`; App uses parts[3] then parts[4]. A source sweep confirms `otaUploaded` and `otaBytes` each have one dictionary definition and one App call site, so Gemini's unknown-caller concern is not present in current main. The new placeholders require a real formatter/helper; `JexText.of()` does not interpolate placeholders by itself.
- `fullSyncFailed`: prefer `Tidak dapat menyelesaikan sinkronisasi perangkat.`. `resetDeepSleep`: prefer `Perangkat kembali aktif dari mode tidur hemat daya.`.
- Bluetooth notification copy (`Bluetooth connected · device session active` / `Bluetooth terhubung · sesi perangkat aktif`) is correct and should remain. Preserve `Floating Monitor / Monitor Melayang` and the current About role `App Developer & Builder / Pengembang Aplikasi & Perakit`.

### Corrections to Gemini's taxonomy, severity and assumptions

- **No P0 finding is substantiated.** The current findings are copy/terminology/state-presentation inconsistencies. They do not show an immediate hardware safety failure, broken Fan interlock, unsafe Peltier output, security compromise or data loss. Using the repo code-review severity rubric, thermal terminology and misleading success wording are P2; the prerequisite title/body polish is P3; state presentation and OTA diagnostics clarity are P2.
- Do not classify `BLE Device Session` as a logical operating mode. Use lifecycle states such as Connected/Disconnected, Syncing/Ready/Not Ready. Likewise, OS permission state (Granted/Not Granted/Not Requested) is distinct from an App preference Enabled/Disabled.
- Lock Voltage is Firmware-owned and authoritative. A compact descriptive status may say Active/Inactive, but do not mechanically replace its owner-approved Settings Switch or all ON/OFF control affordances. Preserve the existing rule that unknown/disconnected state is not inferred as OFF.
- Native HUD truncation is not demonstrated by source: `itemWidth()` measures the current localized text, `onMeasure()` sizes to content, WindowManager uses `WRAP_CONTENT`, and `applyData()` calls `requestLayout()` when language/data changes. Longer labels can still expand a horizontal six-metric overlay beyond a comfortable viewport; verify actual screenshots at supported sizes/orientations before claiming visual acceptance. Do not abbreviate `NONAKTIF` speculatively.
- Language labels: `Indonesian` in English UI and `Bahasa Inggris / Bahasa Indonesia` in Indonesian UI are linguistically clearer. However, current source comment and widget test explicitly lock the display to `English / Indonesia` in both locales. This is an owner-facing display-contract decision, not authorized by the Gemini answer alone. Preserve enum/storage IDs `english` and `indonesia`; wait for owner approval before changing labels/assertions.

### Regression coverage: confirmed gaps and exact follow-up

- Existing `test/widget_test.dart` asserts the Peltier title's current pair, language labels and global ON/OFF values. Its Floating Monitor state test currently expects A and P both to be ON/HIDUP; update it only alongside approved per-domain mapping, keeping F numeric when on and OFF/MATI when off.
- Existing Usage Statistics tests verify activity/session calculations, but do not assert the localized Adaptive-vs-Peltier formatter result. Add explicit paired EN/ID cases, plus unknown/null preservation.
- Existing `device_copy_notification_contract_test.dart` checks native channel-language update hooks, not the exact bilingual notification body/channel copy. Add exact copy contracts for the connected-device sentence and Floating Monitor / Monitor Melayang.
- Current widget tests assert the English `Safety checks passed.` result but do not assert the corrected Indonesian result. Add both-language checks. Add exact terminology assertions for thermal Safety entries and the Fan prerequisite pair; avoid a simplistic global scan if future Safety/security contexts differ.
- Add OTA mismatch formatter tests for received/expected order in both locales, malformed event fallback and both numeric values. Add dictionary placeholder parity (354 entries), literal inline phrase parity (166 call sites), and explicit tests for non-literal/dynamic phrase/lookup branches. Existing dictionary structure tests only check locale-field presence.
- Test HUD text measurement/layout contract for longer translated values, but retain actual Android screenshot verification as a separate gate. A Dart source-contract/widget test is not a native Android runtime or OEM visual test.

**Outcome:** Gemini's main wording/state direction is useful and mostly accepted, with the above qualifications. The source/test changes remain unimplemented. No formatter, Flutter tests, analyzer, Android Gradle, Build App, Kotlin native test, Firmware compile, BIN, Firebase, OTA, flash or device check was run in this Diskusi review.


## Localization/state semantics and regression coverage — 2026-11-15

- English remains the master/default language. The JexText dictionary has 354 entries with English and Indonesian copy; tests verify locale presence and matching placeholder sets. Literal inline bilingual phrase calls also receive placeholder-parity coverage. Dynamic branches and native Kotlin copy retain their own source/test contracts.
- Thermal Safety terminology is Keselamatan. The sensor-error cooling lock says demi keselamatan; successful SAFETY telemetry renders Pemeriksaan keselamatan berhasil.
- Fan prerequisite title and body explicitly state that the fan must be on before cooling starts. This is copy clarification only: preserve FAN:ON → successful ACK → PELTIER:ON and command-free Cancel behavior.
- State taxonomy: Adaptive is a logical mode (EN ACTIVE/INACTIVE, ID AKTIF/NONAKTIF); Peltier/Fan/LED are physical outputs (compact EN ON/OFF, ID HIDUP/MATI; natural Indonesian prose menyala/mati). Fan Speed stays numeric while running and OFF/MATI when stopped; disconnected values stay --.
- BLE device session and Android OS permission states remain separate lifecycle/permission concepts, not generic mode/preference states.
- Usage Statistics uses UsageStateDomain to distinguish logical mode from hardware output while preserving voltage and unknown values.
- Native Floating Monitor A uses Active/Inactive while P remains physical ON/OFF; F stays numeric while running and OFF/MATI when stopped. Native width is computed from localized text; long-label viewport acceptance still requires actual Android screenshots.
- OTA mismatch strings identify received bytes first and expected bytes second, matching Firmware event UPLOAD_SIZE_MISMATCH_<received>_<expected>. JexText.format performs named bilingual interpolation after locale selection; JexText.of and phrase remain non-interpolating lookups.
- Validation Only #19 / run 43677560315, job 132700920324, tested source 8fca2ecebf8b2ffb83fc9475a817c832f8269dc5 and passed: formatter clean after one auto-format correction; analyzer 118 infos / zero warnings/errors; Flutter 197/197. Formatter follow-up is fc39de16a5480347ce13083760424a309957c311.
- Validation Only #18 / run 43677411117 is preserved as an intermediate failure (196/197) caused by one stale LED output-copy expectation. The assertion was corrected and #19 passed.
- Build #163 / run `43679305537` is the latest verified package and includes this localization/state remediation on source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`; Validation Only #19 passed 197/197 on the same executable/test lineage. The additional 2026-11-16 full copy/format audit and Adaptive profile-card changes remain separate, NOT IMPLEMENTED / NOT RELEASED work. Actual Android/OEM visual acceptance remains unverified.
