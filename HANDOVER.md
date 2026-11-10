# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-10 (Asia/Jakarta).

## Current release baseline — Build #138

- **Latest verified package:** Build #138 / [Actions run 42749408202](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42749408202), terminal success, exact source `b553f22092d9b33b2c81753254d2e3f03928fa18`.
- All 21 main workflow steps passed; analyzer had 25 info-only diagnostics/no warnings; Flutter tests **157/157 passed**. Android Gradle gate succeeded, but native app JUnit compile/test tasks were `NO-SOURCE`.
- Obfuscated APK passed V1/V2/V3 and expected production-certificate verification. Matching source ZIP and downloaded Release assets verified. Release/tag `jexfyz-latest` point to Build #138 source.
- Preserve `versionName "Telegram @horizontalzzz"`. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Next authorized work candidate — combined Home + Statistics corrections

**A. Default hybrid Home contrast:** the 2026-11-10 owner screenshot shows the dark Home header with low-contrast metric labels/values and NOTIFY body. Source root cause is confirmed: Default intentionally inherits Light Theme to preserve the white lower panel, but `_homeMetric()` and `_homeNotify()` use inherited brightness for the header palette. Repair with one preset-based header resolver (Default/Dark = dark, Light = light), keeping lower-panel resolution separate.

**B. Usage Statistics revised by owner (2026-11-10):** remove the 1H/24H/7D/30D range selector. Store per-second Battery/Hotside measurements only during actual cooler operation, not merely while BLE is connected. Proposed gate: authoritative Firmware output `FAN == ON` OR `PELTIER == ON`; both OFF closes the run; fan-only thermal-protection cooling counts because an actual output remains active. Each OFF→ON run is a separate local session; disconnect/stale P1 closes it. Persist fresh per-second readings or explicit gaps; keep Voltage/Adaptive/Fan Speed as event-driven transitions on the elapsed-seconds axis. Show completed run history without fixed wall-clock range filters. Existing 30-day pruning is a DB retention rule, not a chart range.

**Recommended next command:** `Eksekusi Full!` — authorize both narrowly scoped App repairs and regression tests. For Statistics, prove idle-connected no-recording, FAN-only/PELTIER-only active sessions, both-OFF end, reconnect resync, stale/missing sample gaps, and per-second data. For Home, prove all three presets' header and lower-panel palette choices. Preserve Home geometry, painter paths/animation, NOTIFY semantics, 360-dp canvas, BLE/safety/telemetry truth and local-only SQLite; no Firmware changes.

This is a recommendation, not source-change authorization. After source/tests are reviewed, a separate explicit `Eksekusi Build App!` is required to package the APK.

Open risks: per-second SQLite data growth requires stress/capacity validation; actual device screenshots and BLE/thermal behavior remain unverified. Firmware TTP223 Voltage one-way-cycle V7.2 remains separate and NOT IMPLEMENTED.