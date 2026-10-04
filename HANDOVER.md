# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.5
- Active source: firmware/JEXFYZ-V4.5.ino
- Firmware blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App: 1.0.0+3
- App main blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings blob: f11235bab559b291928550e06984532581ddad6a
- App test blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Current App workflow: .github/workflows/jexfyz-build.yml
- Current App workflow blob: 08a137b4d315cc12e830a7e8dbc1ea40c3d2873d
- Legacy app-build.yml and app-build-trigger.yml are deleted.
- Latest verified downloadable App Build: workflow run #2 / GitHub Release jexfyz-latest.
- Build #53: App validation passed through signing; legacy artifact creation blocked by Actions quota.
- CI delivery fix is [VERIFIED]: workflow run #2 successfully published JEXFYZ-release.apk to GitHub Release.

## CURRENT OBJECTIVE
Preserve this state across chat transfer, then on a future explicit Build App request publish the current App as one APK through the GitHub Release asset path.

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
- Legacy App Build workflows were deleted; a single new `.github/workflows/jexfyz-build.yml` is current.
- Current workflow no longer uses Actions-artifact cleanup/upload; it publishes exactly one JEXFYZ-release.apk GitHub Release asset.
- Current workflow is owner/title/token-gated issue-based with no push/PR trigger.
- New workflow run #1 verified all build/signing gates but failed its legacy Actions-artifact publication step due quota; this is historical.
- The replacement GitHub Release delivery path is now end-to-end [VERIFIED] by workflow run #2.

## NEXT
On the next explicit App Build request, run the current single workflow and verify CI gates, signing, GitHub Release update, and exactly one JEXFYZ-release.apk asset. Separately compile/flash Firmware V4.5 and perform physical OTA/BLE validation.
