## V4.7 REALTIME TELEMETRY QC FIX — 2026-10-05
- Promoted Firmware V4.6 → V4.7 after hardware/App QC exposed stale realtime Fan/Peltier state in the App.
- Firmware cooling telemetry now uses pre-mutation state snapshots across Touch, Adaptive, safety, voltage completion, and command-setter paths.
- App applies unsolicited FAN/PELTIER/FAN_SPEED telemetry directly to Control state.
- App Home Notify clears stale command/connection errors only after healthy live cooling/safety telemetry; safety warnings remain visible.
- Home Notify warning presentation is gated by active BLE connection.
- Added regression coverage for realtime Notify reconciliation.
- No App Build was executed.
- V4.7 is NOT RELEASED pending compile/BIN/flash/OTA and App integration QC.

## APP CONTROL PRECHARGE — 2026-10-05
- Added a 2-second Fan precharge interval when the user requests Peltier ON while Fan is OFF.
- App now waits for confirmed FAN=ON telemetry before starting the 2-second interval.
- After the interval, App re-validates BLE connection, Adaptive OFF, and Fan ON before sending PELTIER:ON.
- Fan already ON remains an immediate Peltier-start path; no extra delay is added.
- Added a regression test locking the precharge duration to exactly 2 seconds.
- Firmware source, Firmware behavior, BLE protocol tokens, and App Build workflow were not changed.

## QC / PRE-RELEASE MODE — 2026-10-05
- V4.6 code is complete and the project is now in QC / PRE-RELEASE.
- Functional source is frozen during QC unless a demonstrated defect requires a targeted fix.
- The next release gate is Firmware V4.6 compile → BIN → flash → Hardware QC.
- V4.6 is not released.

## V4.6 — 2026-10-05
- Promoted the active Firmware source from V4.5 to V4.6 for the approved hardware control changes.
- Changed hardware single-tap voltage selection to the requested bounce sequence: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON via touch now forces Fan PWM to 100%.
- Preserved the existing Peltier OFF → ON 5-second soft-start.
- Preserved BOOT_AP_HARD_LIMIT_MS at 60 seconds.
- Removed Rapid Hotside-rise protection, including its dedicated slope threshold, event flag, and Hotside history state.
- Preserved normal Hotside temperature-limit safety.
- Preserved Local OTA, Online OTA, BLE/P1, Adaptive, RGB, telemetry, and App behavior.
- No App Build was executed for this Firmware-only change.

## VERIFIED RELEASE BUILD — 2026-10-05
- Workflow run 37245703677 completed successfully from source commit fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- All build, analysis, test, obfuscated release compilation, and production signing gates passed.
- GitHub Release `jexfyz-latest` now contains exactly one asset: `JEXFYZ-release.apk`.
- Release asset ID: 610989112; size: 54,327,520 bytes; SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- No Actions artifact was created.

## RELEASE DELIVERY RESTORE — 2026-10-05
- Converted the restored reusable App Build engine from Actions-artifact delivery back to direct GitHub Release delivery.
- Engine now requires `contents: write`, publishes exactly one `JEXFYZ-release.apk` under `jexfyz-latest`, and replaces the existing asset with `--clobber`.
- Trigger workflow was raised to `contents: write` so the reusable workflow can publish the Release.
- No App/Firmware runtime source was changed.
- This execution includes an explicit Build App run to verify the new Release delivery path.

## APP BUILD WORKFLOW RESTORE UNDER NEW NAMES — 2026-10-05
- Restored the proven two-workflow App Build architecture without reusing the legacy filenames.
- Manual trigger: `.github/workflows/jexfyz-app-build-trigger.yml`.
- Reusable build engine: `.github/workflows/jexfyz-app-build-engine.yml`.
- The restored engine is based on the Build #50-era verified configuration: Java 17, Flutter 3.47.2, Gradle 9.3.1, production signing verification, obfuscated release APK, Actions artifact for the APK, and Dart symbols artifact.
- The previous `.github/workflows/jexfyz-build.yml` single Release-asset workflow was removed.
- No App Build was started by this execution; this is a workflow/configuration restore only.
- App/Firmware runtime source was not changed.

# JE X FYZ — CHANGELOG

## CI ARTIFACT QUOTA FIX — 2026-10-04
- Replaced Actions-artifact APK delivery in `.github/workflows/jexfyz-build.yml` with direct GitHub Release asset publication.
- Workflow permission changed from `contents: read / actions: write` to `contents: write`.
- Exactly one delivery asset is maintained as `jexfyz-latest / JEXFYZ-release.apk`; existing assets are replaced with `--clobber`.
- This removes Actions-artifact storage quota from the APK delivery path.
- App/Firmware runtime source was not changed.
- Workflow run #2 verified the new Release asset path end-to-end.
- Existing Release updates now retarget `jexfyz-latest` to the current build commit and keep it marked Latest.


## SINGLE WORKFLOW / BUILD RUN #1 — 2026-10-04
- Deleted the legacy `.github/workflows/app-build.yml` and `.github/workflows/app-build-trigger.yml`.
- Created the new single `.github/workflows/jexfyz-build.yml`, based directly on the former App Build engine and gated by the dedicated owner/title/token issue trigger.
- Build run 37199918015 completed security/architecture audit, dependency installation, Dart analysis, Flutter tests, release APK compilation, production signing verification, and filename preparation successfully.
- Artifact upload was blocked by GitHub Actions artifact storage quota; no downloadable artifact was created.

## APP BUILD RUN #2 — VERIFIED — 2026-10-04
- Workflow run: 37201925842
- Source commit: 9136f11799143d91eb58e947ea10e9e576bb579f
- All App CI/security/build/signing gates passed.
- GitHub Release `jexfyz-latest` was updated successfully with exactly one asset: `JEXFYZ-release.apk`.
- Release asset ID: 609813273
- APK size: 54,327,520 bytes
- APK SHA256: 24fcd6f4d1f7843f34e8a31c352b43f23a581b57fc2d29ae71053eb7924092bb
- No Actions artifact was created by this run.

## V4.5 — 2026-10-04
- Promoted the active firmware source from V4.4 to V4.5 for functional hardening.
- Fixed explicit Online OTA GATT disconnect ordering so an active BLE session is closed before Wi-Fi radio handoff.
- Made OTA_UP_TO_DATE a one-shot LAST_OTA_RESULT event.
- Gated rapid Hotside-rise protection on Peltier being ON.
- Removed dead firmware state/legacy comparator and generated documentation noise.
- Synchronized App OTA recovery, safety presentation, Adaptive Ceiling, battery limits, and current OTA stage mapping.

## BUILD APP WORKFLOW RESET — 2026-10-04
- Deleted and recreated both App Build workflows.
- Historical workflow reset used Actions-artifact cleanup; current delivery uses GitHub Release asset publication.
- Trigger workflow remains manual issue-based and is restricted to the repository owner.

## BUILD APP CI — 2026-10-04
- Build #51 failed during Dart analysis because _startCloudOta was missing its closing brace; fixed in commit ea5261230245fc86061cdf85f65ccd0208e607d3.
- Build #52 confirmed App compilation and signing were correct; its workflow failed on a shell pipefail/SIGPIPE signing-output pipeline and was fixed in commit e33141efd47b8f1ca025e832097e1106d9119b65.
- Build #53 passed audit, analysis, tests, APK compilation, and production signing verification, then failed only because GitHub Actions artifact storage quota was exhausted.
- Current App build workflow publishes one replaceable direct GitHub Release asset and no separate symbol asset.

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
