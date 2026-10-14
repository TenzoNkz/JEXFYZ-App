# JE X FYZ / JE Cooler — Build & Release Notes

## Authorization policy

- App Build is a separate explicit operation. Execute it only after `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`.
- Firmware-only changes, documentation tidy-up, test changes or regular pushes do not authorize App Build.
- Do not compile Firmware, generate/publish BIN, modify Firebase metadata, flash hardware, run physical OTA, or release unless separately authorized.
- A passing App build/test does not establish Firmware compile, OTA success, physical safety or installed version.

## Current App Build workflow

- Active workflow path: `.github/workflows/jexfyz-app-build-trigger.yml` — fetch live definition before every authorized build.
- Trigger title: `JE X FYZ — BUILD APP TRIGGER`.
- Required body token: `JEXFYZ_BUILD_TRIGGER_V1`.
- Manual issue-open/reopen trigger only, with owner/title/token validation. Normal push/PR must not generate a release APK.
- Toolchain last recorded in workflow: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Intended output: exactly one obfuscated, production-signed ordinary Android APK, filename `JEXFYZ-release.apk`, published to GitHub Release `jexfyz-latest`. No Play Store bundle and no Actions artifact upload.
- Production signing certificate SHA-256 in prior build record: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Verify against live workflow/config before relying on it.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.

## Validation sequence

1. Inspect current branch/source and workflow.
2. Run authorized dependency resolution, Dart analysis and Flutter tests as configured.
3. Build only the requested one obfuscated release APK if gates pass.
4. Verify APK name/count, signing, release asset and workflow outputs from live run data.
5. Record exact run ID, source commit, asset ID/size/digest, and test/analyze results only when actually verified.
6. If failure occurs, record exact failure and whether test/analyze were reached; do not imply skipped checks passed.

## Historical evidence — never assume current

Previous documents recorded a successful App release run `37245703677`, source commit `fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366`, and APK SHA-256 `a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2` (asset ID `610989112`, size `54,327,520` bytes). Other historical records contain different run/asset IDs. These IDs are **historical only**; fetch current Actions/Releases before calling any run the latest build.

- [LATEST VERIFIED SUCCESSFUL APP BUILD BEFORE SIGNING-WORKFLOW HARDENING] Run `38556896542` completed successfully on pre-fix commit `67c5d26723c433b4af856c7759a967a3425bf67a` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38556896542). Security/architecture audit, dependency install, Dart analyze, Flutter tests, APK build, release signing, and release re-download verification passed. The release asset is one `JEXFYZ-release.apk` (54,521,947 bytes; SHA-256 `95e8c9460b69b8c58d183c2bb80102590cf6208c9a48008ba4dc3bf74e5fbd38`), targeting that pre-fix commit. Logs show the expected certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`, V2=true and V3=true, but V1=false. The previous workflow accepted this because it relied on `jarsigner` printing `jar verified.` and did not require `apksigner` V1 verification.
- [SIGNATURE-VERIFICATION FOLLOW-UP — NOT YET BUILD-VERIFIED] The user's MT Manager screenshot reports `Signature: Verified failed`; its installed-package metadata says last update 2026-10-14 17:11, before run `38556896542` finished at 18:36 Asia/Jakarta, so the installed copy shown is older than the newest APK release. Root cause of MT Manager's display is not yet independently established. Workflow fix commit `90d48ec3c97318b5aff4e147151eee96e41b5b25` now passes `--min-sdk-version 23` during signing/verification and requires `apksigner` to report V1, V2 and V3 true both for the built APK and re-downloaded release asset. This affects signing validation/compatibility only; Android manifest `minSdk` remains 24. No build has run after this workflow change, so a new APK and device verification still require explicit `@Thinking Build App!`.
