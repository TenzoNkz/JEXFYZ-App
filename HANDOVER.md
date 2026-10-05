# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.5
- Active source: firmware/JEXFYZ-V4.5.ino
- Firmware blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App: 1.0.0+3
- App main blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings blob: f11235bab559b291928550e06984532581ddad6a
- App test blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Latest verified downloadable App Build: workflow run #2 / GitHub Release jexfyz-latest.
- Build #53: App validation passed through signing; legacy artifact creation blocked by Actions quota.
- The direct workflow is owner/title/token-gated and publishes one `JEXFYZ-release.apk` to GitHub Release `jexfyz-latest`.
- A new Build App run is now being executed; workflow run #2 remains historical reference evidence until this run succeeds.

## CURRENT OBJECTIVE
Preserve this state across chat transfer. On a future explicit Build App request, use the restored manual trigger to invoke the reusable App Build engine and verify its artifacts/signing gates.

Expected Online OTA:
Update Firmware → active GATT disconnect → live App telemetry stops → Online OTA continues → restart → BLE reconnect → P1 sync → OTA result is shown.

## FROZEN
- Local OTA Golden Path
- BLE UUID/P1 contract
- App package identity
- Manual App Build trigger + reusable App Build engine
- V3.2-style Online OTA transport/retry/result-indicator path
- Cooperative timing rules
- Firmware version/file alignment

## VALIDATION
- Build #53 passed security/architecture audit, dependency resolution, Dart analysis, Flutter tests, release APK compilation, and production signing verification.
- Build #53 failed only during legacy artifact creation because GitHub Actions artifact storage quota was exhausted; Build #2 proves the replacement Release delivery path.
- Firmware V4.5 compile/BIN/flash/physical OTA validation remains pending.
- Current App source is validated for downloadable Release delivery by workflow run #2.

## CI DELIVERY STATE
- `.github/workflows/jexfyz-app-build-trigger.yml` is the manual issue trigger.
- Normal push/PR events do not trigger App Build.
- Workflow run 37245703677 updated and verified `jexfyz-latest`.

## NEXT
Build 37245703677 verified CI gates, production signing, exactly one Release asset, and the Release asset digest/size. Separately compile/flash Firmware V4.5 and perform physical OTA/BLE validation. Separately compile/flash Firmware V4.5 and perform physical OTA/BLE validation.
