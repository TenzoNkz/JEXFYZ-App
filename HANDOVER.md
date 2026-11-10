# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-10 (Asia/Jakarta).

## Current result — Build #135 test failure; App-scope repair committed

- **Authorized mode:** owner issued `Eksekusi Build App!`. Scope is guarded Android App Build/QC/Release plus justified App-scope repairs. Firmware compilation, BIN generation/publication, Firebase changes, OTA, flashing, device operation and unrelated releases remain excluded.
- **Build #135:** [Actions run 42747092939](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42747092939), workflow ID `374946166`, attempt 1, source `2cd9a0e886167c857504926043b5cab03c67c163`, job `129601682007`. Terminal failure at step 13 `Run Flutter tests`. Steps 1–12 passed, including `flutter analyze --no-fatal-infos` (25 info diagnostics, no warnings). Flutter suite result: **153 passed / 4 failed**.
- **Failures:** two broad `find.byType(CustomPaint)` assertions counted Flutter/Material chrome (7 in empty state; 12 populated) instead of only the five Usage Statistics canvases; timestamp label test looked in a lazy ListView before scrolling it into view; Floating Monitor static test searched for the Usage Statistics route in `app_settings.dart` though the route is implemented in `floating_monitor.dart`.
- **Repairs:** `7b539c0c9e50e6a2cd9860cd5fd33e5e0bf35c10` adds stable keys to the five Usage Statistics chart canvases without changing graph logic or appearance. `bb0c540d1bb9e7800d0d9c18ed0f2fab178a8715` narrows chart assertions and scrolls timestamp metadata into view. `39457247735fbebe487ddd137831cc831f80aef4` fixes the static contract to inspect `floating_monitor.dart`. Each updated source/test file was fetched back and exact content verified. No workflow, analyzer flags, tests/gates or signing checks were weakened; repair is not yet CI-validated.
- **Current repository state:** candidate App/test repair head before docs-only checkpoint `39457247735fbebe487ddd137831cc831f80aef4`. The final Build #136 source SHA must be taken from the actual new run and match the final pre-trigger `main` HEAD.
- **Current Actions state:** #135 is terminal; no active/queued run was reported. Issue #33 is OPEN with owner `TenzoNkz`, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, exact body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Next action after final docs/read-back is close #33 once and reopen once; confirm exactly one issue-triggered run, no duplicate trigger.
- **Latest published package:** Build #133 / run `42619673642`, source `5201a3e07f36305ffe3882a1b965b9e7414cd71a`. Release `jexfyz-latest` (ID `403010611`) and tag still target it. Existing APK SHA-256 `8fc837b9ec946cb3bccb6a8d400dc1483a19de9eff506c22ada2d4dcef0b1146`; source ZIP SHA-256 `3a35158b16df567dbc2be1804c9bd0681d96012daffc61adddf61aa6b7be01fb`. No #135 package was created.
- **Protected Android config:** `versionName "Telegram @horizontalzzz"` remains unchanged.
- **Validation boundary:** local Flutter/Dart/Gradle/ADB are unavailable. No local tests, analyzer, APK or device checks were run. Hosted CI does not prove installation, OEM layout, BLE or cooling/thermal performance.

## Separate Firmware backlog

Touch single-tap Voltage one-way cycle (V7.2 plan) remains separate. No Firmware source/test change, compile, BIN, Firebase, OTA, flashing or device operation is included in this App Build work.
