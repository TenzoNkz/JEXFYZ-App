# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.5
- Active source: firmware/JEXFYZ-V4.5.ino
- Firmware blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App: 1.0.0+3
- App main blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings blob: f11235bab559b291928550e06984532581ddad6a
- App test blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Current App Build trigger: .github/workflows/jexfyz-app-build-trigger.yml
- Current App Build engine: .github/workflows/jexfyz-app-build-engine.yml
- Latest verified downloadable App Build: workflow run #2 / GitHub Release jexfyz-latest.
- Build #53: App validation passed through signing; legacy artifact creation blocked by Actions quota.
- The restored workflows are based on the proven Build #50-era manual issue trigger and reusable artifact-producing App Build engine.
- No new build was started by this execution; workflow run #2 remains the latest verified downloadable APK.

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
- `.github/workflows/jexfyz-app-build-engine.yml` is the reusable build engine and restores the proven Actions-artifact APK + Dart-symbol delivery path.
- Normal push/PR events do not trigger App Build.
- Workflow run #2 / `jexfyz-latest` remains the latest verified downloadable APK, but no post-restore build has been run.

## NEXT
On the next explicit App Build request, use the manual trigger workflow to invoke the reusable engine, then verify build gates, production signing, and the expected APK/symbol artifacts. Separately compile/flash Firmware V4.5 and perform physical OTA/BLE validation.
