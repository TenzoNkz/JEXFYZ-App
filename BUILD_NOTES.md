## VERIFIED RELEASE BUILD — 2026-10-05
- [BUILT][VERIFIED] Workflow run: 37245703677.
- [VERIFIED] Source commit: fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- [VERIFIED] Security/architecture audit, dependencies, Dart analysis, Flutter tests, obfuscated APK compilation, production signing, and filename preparation passed.
- [VERIFIED] GitHub Release `jexfyz-latest` updated successfully.
- [VERIFIED] Exactly one Release asset exists: `JEXFYZ-release.apk`.
- [VERIFIED] Asset ID: 610989112; size: 54,327,520 bytes; SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- [VERIFIED] Actions artifact list for the run is empty.

## WORKFLOW RESTORE — 2026-10-05 (HISTORICAL)
- Restored the Build #50-era two-workflow architecture under new filenames.
- Trigger workflow: `.github/workflows/jexfyz-app-build-trigger.yml`.
- Reusable engine: `.github/workflows/jexfyz-app-build-engine.yml`.
- Engine preserves obfuscated release APK generation, production certificate verification, APK Actions artifact upload, and Dart symbols artifact upload.
- No App Build was executed by this workflow restore.

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
- [REPLACED] Previous single workflow `.github/workflows/jexfyz-build.yml` was removed.
- [COMMITTED] Restored manual trigger: `.github/workflows/jexfyz-app-build-trigger.yml`.
- [COMMITTED] Restored reusable engine: `.github/workflows/jexfyz-app-build-engine.yml`.
- [COMMITTED] Restored engine now uses GitHub Release delivery for exactly one APK; it no longer uploads Actions artifacts.
- [VERIFIED] No normal push/PR trigger is present in the restored pair.
- [HISTORICAL] New workflow run #1 cleanup step completed and all build/signing gates passed before the quota fix.
- [HISTORICAL] New workflow run #1 artifact upload failed because Actions artifact storage quota was exhausted.
- [IMPLEMENTED] Current engine publishes `JEXFYZ-release.apk` to `jexfyz-latest` with `--clobber`; verification is pending the new build.

## BUILD HISTORY
### #50 — historical verified downloadable APK
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

## CI DELIVERY FIX — 2026-10-05
- [HISTORICAL] The former `.github/workflows/jexfyz-build.yml` workflow used the same Release-asset delivery mechanism and is no longer active.
- [COMMITTED] Added direct GitHub Release publication using tag `jexfyz-latest`.
- [COMMITTED] Existing release is kept synchronized to the latest build commit with `gh release edit --target` and marked Latest.
- [COMMITTED] Exactly one APK is delivered as `JEXFYZ-release.apk`; an existing release asset is replaced with `gh release upload --clobber`.
- [HISTORICAL] Workflow run #2 proved GitHub Release creation/update and asset verification end-to-end; this is the reference implementation.

## WORKFLOW RUN #2 — VERIFIED RELEASE DELIVERY — 2026-10-04 (HISTORICAL)
- [BUILT][VERIFIED] Run: 37201925842 (workflow run #2)
- [VERIFIED] Source commit: 9136f11799143d91eb58e947ea10e9e576bb579f
- [VERIFIED] Result: SUCCESS
- [VERIFIED] Audit, dependencies, Dart analysis, Flutter tests, release APK compilation, production signing, filename preparation, and GitHub Release publication all passed.
- [VERIFIED] GitHub Release: jexfyz-latest / JE X FYZ — Latest App
- [VERIFIED] Release ID: 403010611
- [VERIFIED] Asset ID: 609813273
- [VERIFIED] Asset: JEXFYZ-release.apk
- [VERIFIED] APK size: 54,327,520 bytes
- [VERIFIED] APK SHA256: 24fcd6f4d1f7843f34e8a31c352b43f23a581b57fc2d29ae71053eb7924092bb
- [VERIFIED] Actions-artifact list for the run is empty; no Actions artifact was created.

## LATEST VERIFIED APK
- Workflow run #2 is now the latest verified downloadable APK.
- Delivery: GitHub Release `jexfyz-latest`
- Asset: JEXFYZ-release.apk
- APK size: 54,327,520 bytes
- APK SHA256: 24fcd6f4d1f7843f34e8a31c352b43f23a581b57fc2d29ae71053eb7924092bb

## BUILD BOUNDARY
- Build #50 validates only its exact source commit.
- Build #53 proves the current App source passed CI through signing, but not artifact delivery.
- No future App Build may be inferred from Build #53.
- Workflow run #2 is valid evidence for the current source commit 9136f11799143d91eb58e947ea10e9e576bb579f.
- The current explicit Build App run must validate the new Release delivery path on the restored two-workflow architecture.
