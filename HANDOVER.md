# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.6
- Active source: firmware/JEXFYZ-V4.6.ino
- Firmware blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- Firmware compile/BIN/flash/physical validation: UNVERIFIED
- App: 1.0.0+3
- App main blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings blob: f11235bab559b291928550e06984532581ddad6a
- App tests blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified downloadable App Build: workflow run 37245703677 / GitHub Release jexfyz-latest.
- Latest verified APK SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.

## V4.6 EXECUTION
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling long press ON: Fan is forced to 100%.
- Peltier OFF → ON: existing cooperative 5-second soft-start is preserved.
- BOOT_AP_HARD_LIMIT_MS: 60 seconds preserved.
- Rapid Hotside-rise protection: removed completely.
- Normal Hotside temperature-limit protection: preserved.
- All unrelated firmware, BLE/P1, OTA, Adaptive, RGB, telemetry, and App behavior remain unchanged.

## FROZEN
- Local OTA Golden Path.
- Single-radio Wi-Fi/BLE ownership.
- BLE Service/RX/TX UUIDs.
- P1 session contract.
- App package identity and App Build policy.
- Production signing certificate identity.

## VALIDATION
- V4.6 source/static audit: PASS.
- Firmware compile/BIN/flash/physical validation: pending.
- App Build was not run by this execution.
