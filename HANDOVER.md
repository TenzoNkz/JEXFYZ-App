# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-09 (Asia/Jakarta).

## Current App feature — Usage Statistics requested, not implemented (2026-11-09)

- Owner no longer wants a standalone Firmware timer for now; instead asks for a Usage Statistics / Statistik Penggunaan page under Settings.
- Page order: Phone Battery Temperature trend; Hotside Temperature trend; Operating Profile timeline with separate Voltage 5/9/12V, Adaptive ON/OFF and Fan Speed (%) lanes. Proposed filters 1h / 24h / 7d / 30d.
- App-side capture: existing Android phone Battery reader ~1Hz; Firmware Hotside `HOT` ~1Hz; voltage/adaptive/fan-speed on telemetry state changes. Store timestamped changed values; compute time-weighted averages and render gaps for disconnected/invalid/missing telemetry.
- Proposed local data architecture: SQLite, batched writes, no Firebase upload and no Firmware NVS history. Existing `flutter_secure_storage` remains settings-only. Proposed retention: 7 days detailed records + 30 days 1-minute rollups/state summaries.
- Exact data and visual acceptance is recorded in `APP_NOTES.md` and `DESIGN_NOTES.md`. Feature requires a separate explicit App-scoped `Eksekusi Full!`; APK packaging requires separate `Eksekusi Build App!`.
- No App source/test/dependency/database change was made in Diskusi. A new Firmware timer is deferred.

## Separate pending Firmware request — Touch Voltage one-way cycle

- Physical single-tap sequence remains requested: 5V→9V→12V→5V; current V7.1 still ping-pongs. The full implementation/version/test scope is in `FIRMWARE_NOTES.md` and the relevant state/checkpoint.
- Keep this separate from the App Usage Statistics feature. No Firmware source/BIN/OTA/flash/device change is authorized by the present Diskusi.
## Immediate next task — implement Touch Voltage one-way cycle in Firmware (2026-11-09)

- Owner-requested physical TTP223 single-tap sequence: `5V → 9V → 12V → 5V → 9V → 12V → ...`; do not reverse direction at 12V.
- Current active Firmware is V7.1; `executeTouchSingle()` uses `touchVoltageAscending` and implements the old ping-pong sequence. Static source review confirmed the cause. The existing Firmware QC test pins V7.1 filename/version and does not currently assert the Touch Voltage cycle.
- Recommended implementation under a new explicit `Eksekusi Full!`: derive next rail directly from `currentVoltage` (V5→V9, V9→V12, V12→V5), preserve all requestVoltage/safety/selector/Peltier/Fan/OTA contracts, and keep other Touch gestures unchanged.
- Functional Firmware version rule: rename the single active sketch to `firmware/JEXFYZ-V7.2.ino`, set `FW_VERSION="V7.2"`, update hard-pinned source/version test references, and add tests for repeated cycle, alternate starting rails, request rejection and gesture invariants.
- No source/test edit, compile, BIN, Firebase, OTA, flash or device action was performed in this Diskusi. `Eksekusi Full!` is not yet authorized. Owner compiles separately with Arduino-ESP32 Core 3.3.7; BIN/OTA/flash requires separate explicit permission.

## Latest verified state

- **Latest App release:** Build #133, [Actions run 42619673642](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42619673642), source `5201a3e07f36305ffe3882a1b965b9e7414cd71a`; terminal success, all 21 main workflow steps passed.
- **Release/tag:** `jexfyz-latest`, Release ID `403010611`, tag and Release both target exact source SHA. Exactly one APK and one corresponding source ZIP are attached and independently verified by post-publication re-download.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset `727484780`, 54,849,627 bytes, SHA-256 `8fc837b9ec946cb3bccb6a8d400dc1483a19de9eff506c22ada2d4dcef0b1146`. V1/V2/V3 and expected production certificate passed.
- **Source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset `727484787`, 2,890,067 bytes, SHA-256 `3a35158b16df567dbc2be1804c9bd0681d96012daffc61adddf61aa6b7be01fb`; ZIP integrity and exact source marker passed.
- **QC:** 145 Flutter tests passed; analyzer exit 0 with 25 info-level diagnostics; Android Gradle gate succeeded. Native Android JUnit app compile/process/test tasks were `NO-SOURCE`, so no native JUnit case executed.
- Home Light Mode theme-aware indicator depth/cavity, metric contrast and NOTIFY foreground corrections are included in Build #133. The stale whitespace-sensitive test contract from failed Build #132 was repaired without deleting semantic assertions; #133 passed 145/145.
- Android Gradle `versionName "Telegram @horizontalzzz"` remains unchanged.
- **Field boundary:** installation of Build #133 is not yet independently confirmed; visual screenshot/OEM QA, physical BLE lifecycle, cooling/thermal, Firmware/BIN/OTA behavior remain separate/unverified.

## Next safe action

- **Immediate recommended source task:** owner may issue a new scoped `Eksekusi Full!` to repair the Default hybrid Home theme contrast regression. This is only a recommendation; Diskusi did not authorize source/test edits.
- Use a preset-based Home-header palette resolver: Default and Dark use dark-header foreground/painter/NOTIFY treatment; Light uses light-header treatment. Preserve the Default lower white panel, light navigation tabs and light disconnected lock dialog. Do not darken the entire Default Dashboard.
- Add a regression matrix separating header palette from lower-panel palette across Default, Light and Dark. Run formatter, focused tests, full Flutter suite and analyzer in the available Flutter 3.47.2 environment; capture actual screenshots before claiming visual acceptance.
- After a validated source repair, a new APK requires a separate explicit `Eksekusi Build App!`. Build #133 remains the latest verified package and its installation is not independently confirmed.
- Physical Home/Settings/Bluetooth visual QA and BLE lifecycle validation remain pending after the owner installs the relevant APK. Record physical evidence separately; do not infer Firmware, BIN, OTA, cooling/thermal or hardware status from App CI.

## Evidence and safety boundary

- Build #133 validates the App source SHA above only. It does not prove the exact package has been installed on the owner's phone or physically accepted.
- Firmware V7.1 compile/Online OTA remains USER-REPORTED. Exact field BIN identity, physical OTA, installed App identity and physical device behavior remain UNVERIFIED.
- No Firmware compile, BIN publication/replacement, Firebase operation, OTA, flashing or device operation occurred in this Build App task.
- BLE App-only identity authorization remains BLOCKED / NOT IMPLEMENTED; rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm is also NOT IMPLEMENTED in Firmware V7.1.
- The single operating policy is [MASTER_PROMPT.md](MASTER_PROMPT.md). [CHAT_RULES.md](CHAT_RULES.md) is only a compatibility pointer. [CHAT_TRANSFER.md](CHAT_TRANSFER.md) is the latest durable continuation checkpoint; [APP_BUILD_REPORT.md](APP_BUILD_REPORT.md) contains append-only build evidence.
