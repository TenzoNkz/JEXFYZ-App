## 2026-10-04 — WORKFLOW RECREATION
- Deleted and recreated `.github/workflows/app-build.yml` and `.github/workflows/app-build-trigger.yml`.
- New App Build workflow clears all existing Actions artifacts before the release build, then publishes exactly one `JEXFYZ-release.apk` artifact with overwrite enabled and 7-day retention; no symbols artifact is uploaded.
- New trigger grants `actions: write` to the reusable build and accepts only the repository owner's exact trigger issue title/token. Push/PR remain excluded.
- New App Build workflow blob: `5c7faeb8fece972179a0607ffd2278bdfd174704`.
- New trigger workflow blob: `04d2293725e97c3cbc67ce8b6f0d9c1230802afd`.

## 2026-10-04 — ARTIFACT STORAGE CLEANUP HARDENING

- Build #51 source parser failure was corrected in commit `ea5261230245fc86061cdf85f65ccd0208e607d3` by restoring the missing closing brace for `_startCloudOta`.
- Build #52 compiled successfully but failed only in production-signature shell verification; commit `e33141efd47b8f1ca025e832097e1106d9119b65` fixed the pipefail/SIGPIPE handling.
- Build #53 passed analysis, tests, release APK compilation, and signing verification but could not upload because GitHub Actions artifact storage quota was exhausted.
- App Build workflow commit `4514aac93b75abb18eed8073484bf96de1316ec7` now requires `actions: write`, deletes all existing workflow artifacts at the start of each explicit build, and uploads exactly one release APK. Dart symbols are no longer uploaded.
- Normal push/PR behavior remains unchanged; only the dedicated issue-triggered App Build reaches this cleanup step.

# JE X FYZ — BUILD NOTES

## APP BUILD POLICY
- App Build is explicit and separate from Firmware build/flash.
- Manual issue trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Required token: JEXFYZ_BUILD_TRIGGER_V1
- One normal APK, not a Play Store bundle.
- Java 17 / Flutter 3.47.2 stable / Gradle 9.3.1 / ubuntu-24.04.
- Production signing certificate SHA256:
  dd6ca6bec4e8f4d594214730426048c06081c2e977df8f260606849c2c2e0e0

## CURRENT APP BUILD VALIDATION
- Current App main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- Build #51 run 37196189548: failed at Dart analysis because _startCloudOta was missing its closing brace in the App source.
- Source fix commit: ea5261230245fc86061cdf85f65ccd0208e607d3.
- Build #52 run 37196349621: Dart analysis, tests, APK compilation, and signing succeeded; workflow failed only during signing-output grep because of shell pipefail/SIGPIPE.
- Workflow fix commit: e33141efd47b8f1ca025e832097e1106d9119b65.
- Build #53 run 37196778932: security/architecture audit, dependency installation, Dart analysis, Flutter tests, APK compilation, and production signing verification all PASSED.
- Build #53 failed only at artifact creation because GitHub Actions artifact storage quota was exhausted.
- No release APK artifact is available from #53.

## ARTIFACT DELIVERY POLICY
- Workflow now publishes exactly one direct APK artifact: JEXFYZ-release.apk.
- Artifact overwrite is enabled so repeated builds replace the previous APK artifact instead of accumulating one artifact per run.
- Artifact retention is limited to 7 days.
- Dart obfuscation remains enabled; debug symbols are generated during the build but are no longer uploaded as a second artifact.

## LATEST VERIFIED RELEASE APK
- Build #50 remains the latest verified downloadable APK.
- Run: 36996987220
- Source commit: bf01595253eb5a1912471c4aee57c4eed4421f0f
- APK artifact ID: 11222007634
- APK SHA256: 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0
- Symbols artifact ID: 11222132522
- Symbols SHA256: a87a3181bada92e229da3c1f79d9a59339d7669c11b32ac1d8c219ae435c9062

## WORKFLOWS
- App workflow: .github/workflows/app-build.yml
- App workflow blob: 5c7faeb8fece972179a0607ffd2278bdfd174704
- Trigger workflow: .github/workflows/app-build-trigger.yml
- Trigger blob: 04d2293725e97c3cbc67ce8b6f0d9c1230802afd

## CURRENT BUILD BOUNDARY
- Current App source has passed analysis/tests/release compilation/signing verification in Build #53.
- Build #53 did not publish an APK because of GitHub Actions artifact quota.
- Existing Actions artifacts must be deleted or allowed to expire so GitHub storage can recalculate before the next release upload.
- Do not report Build #53 as a successful release artifact.
