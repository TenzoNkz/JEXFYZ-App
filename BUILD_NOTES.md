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

- [LATEST OBSERVED SUCCESSFUL APP BUILD — NOT CURRENT-SOURCE VALIDATION] Run `38535535278` completed successfully on commit `97c5497e2aa31184de425c264def6dec7844f734` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38535535278). The security/architecture audit, dependency install, Dart analyze, Flutter tests, obfuscated APK build, production signature verification, release upload and downloaded-asset verification all passed for that commit. Release `jexfyz-latest` currently targets that commit and contains `JEXFYZ-release.apk` (54,506,164 bytes; SHA-256 `bb740029d24e1b76b41796d3ef979bc7c3ee7d96ff3fe96fdaacbcdb5ebf426b`). This predates App-only commits `957bebbfe467affab5807ac6ef6666f645e46431` and `c957e7196608f81224d28b2b50b63209823dfa3f`, plus current smooth-motion/JE-icon/dialog commits including `46d368b`, `38bccb1`, `1289280`, `357b9e6`, `75f4b50`, `8e7f908`, `449e830`, `e43ad0f9`, `6ef0436d`, `739ea326`, `3e82eee3`, `6b7f2d7a`, `5757b844`, and `c2fc850a`. It does NOT validate or contain the latest changes. No new App Build was run in this execution.
