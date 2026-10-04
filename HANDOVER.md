# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.5
- Active source: firmware/JEXFYZ-V4.5.ino
- Firmware blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App: 1.0.0+3
- App main blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings blob: f11235bab559b291928550e06984532581ddad6a
- App test blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Current App workflow blob: 5c7faeb8fece972179a0607ffd2278bdfd174704
- Current App trigger workflow blob: 04d2293725e97c3cbc67ce8b6f0d9c1230802afd
- Latest verified downloadable App Build: #50
- Build #53: App validation passed through signing; artifact creation blocked by Actions quota.

## CURRENT OBJECTIVE
Preserve this state across chat transfer, then on a future explicit Build App request publish the current App as one APK after workflow artifact cleanup succeeds.

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
- Current App source is not validated for downloadable artifact delivery beyond Build #50.

## CI DELIVERY STATE
- Both App Build workflows were deleted and recreated.
- Release workflow now clears all existing Actions artifacts using actions: write, then uploads exactly one JEXFYZ-release.apk with overwrite and 7-day retention.
- Trigger remains owner/title/token-gated issue workflow with no push/PR trigger.
- Runtime proof of the reset workflow producing a new artifact is pending.

## NEXT
On the next explicit App Build request, run the manual trigger and verify cleanup, CI gates, signing, and single APK artifact publication. Separately compile/flash Firmware V4.5 and perform physical OTA/BLE validation.
