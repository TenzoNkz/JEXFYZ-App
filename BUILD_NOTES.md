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
- App workflow blob: 9cbb39a3bec997072b1866b01caeed756e6228eb
- Trigger workflow: .github/workflows/app-build-trigger.yml
- Trigger blob: 89598aff0b006bb3db6819080a13965fc5a6247d

## CURRENT BUILD BOUNDARY
- Current App source has passed analysis/tests/release compilation/signing verification in Build #53.
- Build #53 did not publish an APK because of GitHub Actions artifact quota.
- Existing Actions artifacts must be deleted or allowed to expire so GitHub storage can recalculate before the next release upload.
- Do not report Build #53 as a successful release artifact.
