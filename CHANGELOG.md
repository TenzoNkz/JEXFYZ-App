# JE X FYZ — CHANGELOG

## SINGLE WORKFLOW / BUILD RUN #1 — 2026-10-04
- Deleted the legacy `.github/workflows/app-build.yml` and `.github/workflows/app-build-trigger.yml`.
- Created the new single `.github/workflows/jexfyz-build.yml`, based directly on the former App Build engine and gated by the dedicated owner/title/token issue trigger.
- Build run 37199918015 completed security/architecture audit, dependency installation, Dart analysis, Flutter tests, release APK compilation, production signing verification, and filename preparation successfully.
- Artifact upload was blocked by GitHub Actions artifact storage quota; no downloadable artifact was created.

## V4.5 — 2026-10-04
- Promoted the active firmware source from V4.4 to V4.5 for functional hardening.
- Fixed explicit Online OTA GATT disconnect ordering so an active BLE session is closed before Wi-Fi radio handoff.
- Made OTA_UP_TO_DATE a one-shot LAST_OTA_RESULT event.
- Gated rapid Hotside-rise protection on Peltier being ON.
- Removed dead firmware state/legacy comparator and generated documentation noise.
- Synchronized App OTA recovery, safety presentation, Adaptive Ceiling, battery limits, and current OTA stage mapping.

## BUILD APP WORKFLOW RESET — 2026-10-04
- Deleted and recreated both App Build workflows.
- Release workflow now clears existing Actions artifacts with `actions: write`, then publishes one replaceable APK only.
- Trigger workflow remains manual issue-based and is restricted to the repository owner.

## BUILD APP CI — 2026-10-04
- Build #51 failed during Dart analysis because _startCloudOta was missing its closing brace; fixed in commit ea5261230245fc86061cdf85f65ccd0208e607d3.
- Build #52 confirmed App compilation and signing were correct; its workflow failed on a shell pipefail/SIGPIPE signing-output pipeline and was fixed in commit e33141efd47b8f1ca025e832097e1106d9119b65.
- Build #53 passed audit, analysis, tests, APK compilation, and production signing verification, then failed only because GitHub Actions artifact storage quota was exhausted.
- App build workflow now publishes one replaceable direct APK artifact with 7-day retention and no separate symbol artifact.

## V4.4 — 2026-10-04
- Added explicit active BLE GATT disconnect before Online OTA Wi-Fi handoff.
- Preserved the V3.2-style Online OTA transport/retry/result-indicator behavior.
- User subsequently confirmed V4.4 Local OTA and Online OTA success.

## V4.3 — 2026-10-04
- Restored Online OTA to the pre-yellow V3.2-style path.
- Removed yellow progress indicators and V4.2 cumulative passive Wi-Fi retry.
- User confirmed Local OTA and Online OTA success.

## V4.2 — 2026-10-04
- Introduced cumulative Online OTA Wi-Fi connection handling.
- Superseded by V4.3 rollback.

## V4.1 — 2026-10-04
- Simplified Online OTA Wi-Fi retry architecture.
- Superseded by V4.3 rollback.

## V4.0 — 2026-10-04
- Firmware hardening baseline before the V4.1–V4.3 OTA iterations.

## PRE-V4
- V3.3 introduced the yellow Online OTA progress layer.
- V3.2 is the exact pre-yellow Online OTA baseline.
