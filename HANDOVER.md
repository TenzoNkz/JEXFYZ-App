# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.5
- Active source: firmware/JEXFYZ-V4.5.ino
- Firmware blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App: 1.0.0+3
- App main blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings blob: f11235bab559b291928550e06984532581ddad6a
- Current App workflow blob: 9cbb39a3bec997072b1866b01caeed756e6228eb
- Latest verified downloadable App Build: #50
- Build #53: App validation passed; artifact upload blocked by Actions storage quota.

## CURRENT OBJECTIVE
Deliver the current V4.5 App APK after artifact storage is cleared, then validate it together with Firmware V4.5.

Expected Online OTA:
Update Firmware → active GATT disconnect → live App telemetry stops → Online OTA continues → restart → BLE reconnect → P1 sync → OTA result is shown.

## FROZEN
- Local OTA Golden Path
- BLE UUID/P1 contract
- App package identity
- Manual App Build workflow
- V3.2-style Online OTA transport/retry/result-indicator path
- Cooperative timing rules
- Firmware version/file alignment

## VALIDATION
- Build #53 passed security/architecture audit, dependency resolution, Dart analysis, Flutter tests, release APK compilation, and production signing verification.
- Build #53 failed only during artifact creation because GitHub Actions artifact storage quota was exhausted.
- Firmware V4.5 compile/BIN/flash/physical OTA validation remains pending.

## CI DELIVERY FIX
- One direct APK artifact only.
- Stable artifact filename: JEXFYZ-release.apk.
- Artifact overwrite enabled.
- Retention: 7 days.
- No separate Dart-symbol artifact.
- Normal push/PR does not trigger release builds.

## NEXT
Clear obsolete Actions artifacts or allow quota to recalculate, then trigger the manual Build App workflow again. Do not change Firmware/App source unless validation exposes a new issue.
