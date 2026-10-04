# JE X FYZ — BUILD NOTES

## APP BUILD POLICY
- App Build is explicit and separate from Firmware build/flash.
- Manual issue trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Required token: JEXFYZ_BUILD_TRIGGER_V1
- One normal APK, not a Play Store bundle.
- Obfuscation is required.
- Java 17 / Flutter 3.47.2 stable / Gradle 9.3.1 / ubuntu-24.04.
- Production signing certificate SHA256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0

## CURRENT DELIVERY WORKFLOW
- [COMMITTED] Legacy `.github/workflows/app-build.yml` and `.github/workflows/app-build-trigger.yml` were deleted.
- [COMMITTED] New single workflow: `.github/workflows/jexfyz-build.yml`.
- [VERIFIED] Current workflow blob: 08a137b4d315cc12e830a7e8dbc1ea40c3d2873d.
- [COMMITTED] Release workflow now uses permissions contents: write.
- [COMMITTED] Actions-artifact upload/cleanup is no longer part of the APK delivery path.
- [COMMITTED] Release publication is exactly one direct GitHub Release asset at jexfyz-latest, named JEXFYZ-release.apk; existing asset is replaced with --clobber.
- [COMMITTED] Dart symbols are still generated for obfuscation diagnostics but are not uploaded.
- [VERIFIED] Trigger workflow remains issue-based, owner/title/token gated, and reusable.
- [VERIFIED] New workflow run #1 cleanup step completed and all build/signing gates passed.
- [BLOCKED] New workflow run #1 artifact upload failed because Actions artifact storage quota remains exhausted.

## BUILD HISTORY
### #50 — latest verified downloadable APK
- [BUILT][VERIFIED] Run: 36996987220
- [VERIFIED] Source commit: bf01595253eb5a1912471c4aee57c4eed4421f0f
- [VERIFIED] Result: SUCCESS
- [VERIFIED] APK artifact ID: 11222007634
- [VERIFIED] APK size: 54,245,456 bytes
- [VERIFIED] APK SHA256: 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0
- [VERIFIED] Symbols artifact ID: 11222132522
- [VERIFIED] Symbols SHA256: a87a3181bada92e229da3c1f79d9a59339d7669c11b32ac1d8c219ae435c9062
- [VERIFIED] Security, dependency, architecture/static, tests, packaging, and signing audits passed.

### #51 — source parser failure
- [BUILT] Run: 37196189548
- [VERIFIED] Conclusion: failure
- [VERIFIED] flutter analyze reported 100 issues.
- [VERIFIED] Root cause: missing closing brace for _startCloudOta caused cascading scope/parser errors.
- [COMMITTED] Fix: ea5261230245fc86061cdf85f65ccd0208e607d3.
- [VERIFIED] No APK artifact.

### #52 — signing shell failure
- [BUILT] Run: 37196349621
- [VERIFIED] App analysis/tests/release compilation/signing passed.
- [VERIFIED] Failure occurred in signing-output shell verification under set -o pipefail; grep pipeline caused SIGPIPE on the producer.
- [COMMITTED] Fix: e33141efd47b8f1ca025e832097e1106d9119b65.
- [VERIFIED] No release artifact.

### #53 — artifact quota failure
- [BUILT] Run: 37196778932
- [VERIFIED] Audit, dependency resolution, Dart analysis, Flutter tests, release APK compilation, and production signing verification all passed.
- [VERIFIED] Filename preparation for JEXFYZ#53.apk passed.
- [BLOCKED] Upload failed: Failed to CreateArtifact: Artifact storage quota has been hit.
- [VERIFIED] No APK or symbols artifact exists for #53.
- [REJECTED] #53 is not a successful downloadable release.

## NEW WORKFLOW RUN #1 — 2026-10-04
- [BUILT] Run: 37199918015 (workflow run number 1 for `jexfyz-build.yml`).
- [VERIFIED] Source commit: 7332026374abdfec2c46efab84c9085a9e200283.
- [VERIFIED] Cleanup, toolchain, audit, dependencies, analysis, tests, release APK compilation, production signing, and filename preparation all passed.
- [BLOCKED] Artifact upload failed: Actions artifact storage quota has been hit; no artifact was created.
- [VERIFIED] Run artifact list is empty after failure.

## CI DELIVERY FIX — 2026-10-04
- [COMMITTED] Removed Actions-artifact publication from `.github/workflows/jexfyz-build.yml`.
- [COMMITTED] Added direct GitHub Release publication using tag `jexfyz-latest`.
- [COMMITTED] Existing release is kept synchronized to the latest build commit with `gh release edit --target` and marked Latest.
- [COMMITTED] Exactly one APK is delivered as `JEXFYZ-release.apk`; an existing release asset is replaced with `gh release upload --clobber`.
- [UNVERIFIED] A fresh Build App run is still required to prove GitHub Release creation/update and asset verification.

## LATEST VERIFIED APK
- Build #50 is the latest verified downloadable APK.
- Artifact ID: 11222007634
- APK SHA256: 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0

## BUILD BOUNDARY
- Build #50 validates only its exact source commit.
- Build #53 proves the current App source passed CI through signing, but not artifact delivery.
- No future App Build may be inferred from Build #53.
- The next explicit Build App must validate the new GitHub Release delivery path.
