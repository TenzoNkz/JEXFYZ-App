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

- [LATEST VERIFIED SUCCESSFUL APP BUILD — NOT CURRENT-SOURCE VALIDATION] Run `38545637192` completed successfully on commit `9e790765f6683d342025317ce6594cc8519026de` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38545637192). Security/architecture audit, dependency install, Dart analyze, Flutter tests, APK build, V1/V2/V3 signing enforcement, signature verification, release upload and downloaded-asset verification passed. Release `jexfyz-latest` targets that commit and contains one `JEXFYZ-release.apk` (54,505,507 bytes; SHA-256 `26b3746a9d6969475e72a56122d5c4051eaa8742f7d4e3559cc80f4fdb4d2b87`). It predates the current animation/Peltier/dialog/JE-icon source/test commits including `2005f4c1` and `3af190d4`. It does NOT validate or contain the latest changes; no App Build was run for the current source.
