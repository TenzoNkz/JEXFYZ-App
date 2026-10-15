# JE X FYZ / JE Cooler — Build & Release Notes

## Authorization policy

- The only App Build command is `@Thinking Eksekusi Build App!`. It authorizes the complete App build/validation workflow, including justified App-scope repair, retries and the approved issue-triggered Release pipeline.
- `@Thinking Eksekusi Full!` does not authorize App Build; discussion, source edits, tests or regular pushes do not silently trigger the release workflow.
- Retired aliases `@Thinking Build App!` and `@Thinking Eksekusi & Build App!`, plus standalone `@Thinking Eksekusi!`, must not be used. `@Thinking Eksekusi Full!` does not authorize App Build.
- Build App does not authorize Firmware compilation, BIN creation/publication/replacement, Firebase metadata changes, physical OTA, flashing, device operation, or unrelated release operations.
- Never claim CI success proves BLE, cooling/safety behavior, Firmware compilation, OTA installation or installed device version.

## Current App Build workflow

- Active workflow path: `.github/workflows/jexfyz-app-build-trigger.yml` — fetch live definition before every authorized build.
- Trigger title: `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`.
- Required body token: `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`.
- Manual issue-open/reopen trigger only, with owner/title/token validation. Normal push/PR must not generate a release APK.
- Toolchain last recorded in workflow: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Intended output: exactly one obfuscated, production-signed ordinary Android APK, filename `JEXFYZ-release.apk`, published to GitHub Release `jexfyz-latest`. No Play Store bundle and no Actions artifact upload.
- Production signing certificate SHA-256 in prior build record: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Verify against live workflow/config before relying on it.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.

## Current App Build blocker — hosted runner dispatch (2026-10-15)

- **Verified pre-change main at start of protocol update:** e4d3ffe48e50173f85f4c6d854e03ffba47e8acd; audited root tree 1e91b96631d485821e340cc27de8497aee80cf5e (76 entries, 55 blobs). This execution adds command/workflow metadata only; it does not run the App Build.
- **Latest release-trigger run:** [Build #45 / `38719397780`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38719397780), workflow commit `8a24619ebfdf6fad2e546be9524d43c61dd0094c`, failed in ~2 seconds with job `116369943522`, `runner_id=0`, blank runner/group names and zero steps. Builds #41–#45 share this symptom. Diagnostic #1 `38722954080` on `ubuntu-24.04` and #2 `38723038511` on `ubuntu-22.04` behaved the same. Root cause is unconfirmed; do not infer a source/build failure from these zero-step jobs.
- **Last build reaching actual steps:** [Build #40 / `38713854518`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38713854518) passed audit/license checks, `flutter pub get`, Dart analyze, all 80 Flutter tests, APK compilation, V1/V2/V3 signing and production certificate check. It made a valid source ZIP but failed one grep because its path was obsolete. The path is corrected in current workflow blob `5c5af03075f87297a31f5ee26f0e42025f05977b`; the complete corrected release run has not yet reached its steps.
- **Release status:** #40–#45 produced no new release asset. Tag `jexfyz-latest` still targets Build #36 commit `893393388b99fc6d9e59c420070a159a29e45e9a`; exactly one old APK is currently published. Do not describe current source as released.
- **Next exact step in the separate Build App workstream:** no further retry until new evidence. Inspect GitHub account Actions usage/budget/spending cap, repository Settings → Actions permissions/allowed-actions, account security/verification restrictions, and check-run annotations when accessible. If normal, escalate the run/job IDs in `APP_BUILD_REPORT.md` to GitHub Support. Do not instruct the next chat to run `hosted-runner-diagnostic.yml`, because that file has been deleted from current main. After hosted runner dispatch is restored, run the official release workflow against current main and verify source ZIP + APK re-download checks.
- **Scope boundary:** this document/recovery task did not trigger App Build, Firmware compilation, BIN publication, Firebase, OTA, flashing or device operations.

## Validation sequence

1. Inspect current branch/source and workflow.
2. Run authorized dependency resolution, Dart analysis and Flutter tests as configured.
3. Build only the requested one obfuscated release APK if gates pass.
4. Verify APK name/count, signing, release asset and workflow outputs from live run data.
5. Record exact run ID, source commit, asset ID/size/digest, and test/analyze results only when actually verified.
6. If failure occurs, record exact failure and whether test/analyze were reached; do not imply skipped checks passed.

## Build App repair/retry policy

1. Start only from `@Thinking Eksekusi Build App!`. Fetch current `main`, read this file and the full `.github/workflows/jexfyz-app-build-trigger.yml` before triggering.
2. Follow the owner/title/token-validated manual issue workflow. Never change the workflow to build on push/PR merely to make triggering easier.
3. When a check fails, inspect the exact failing step and logs. If the defect is within approved App scope, fix the cause rather than weakening tests or skipping a required gate; commit the fix to `main`, then trigger a fresh run and verify it targets the intended commit.
4. Repeat only when a concrete repair was made or a transient failure has evidence-based reason to retry. Do not loop blindly. If blocked by missing repository permissions/secrets, external service, signing credentials, or device-side action, record the blocker and required action; report status as BLOCKED, not successful.
5. Do not declare completion until workflow success, required analysis/tests, APK file/count, signing schemes, production certificate, Release publication and re-downloaded asset identity/checksum are all verified against live run output.
6. Update `APP_BUILD_REPORT.md` during the workflow with every attempt and fix, and finish with source commit, trigger issue, run ID/link, test counts/status, APK name/count/size/SHA-256, signature checks, remaining warnings and unverified device checks. A successful or interrupted Build App workstream must be resumable from this ledger by the one-shot Prompt D LOAD + CONTINUE handoff, without a separate recap chat.
7. If fix would touch Firmware, protected OTA behavior, secrets, Firebase production metadata, or requires changing authorization boundaries, stop and ask for the separate required authorization; do not treat a Build App request as permission for those changes.

## HISTORICAL — Build #35 successful result (superseded as latest success by Build #36)

- **Historical successful Build #35:** run ID `38669526891`, code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8` ([Actions run](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38669526891)). Build #36 is later and remains the latest published APK/source checkpoint.
- **Validation:** security/architecture audit, dependency install, Dart analyze, **74 Flutter tests passed**, release APK build, V1/V2/V3 signing, publish to GitHub Release and re-download verification all passed.
- **Release:** tag `jexfyz-latest`, exactly one asset `JEXFYZ-release.apk`, size 54,521,947 bytes; SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. [Direct APK download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- **Signing:** V1/JAR, V2 and V3 verified true for both the built APK and downloaded release asset. Official production certificate SHA-256: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. JAR verification still warns that dependency `META-INF` entries (including `META-INF/services/a1` and `META-INF/services/b1`) are not protected by the JAR/V1 signature. The workflow nevertheless independently verifies V2/V3 and explicitly gates on all three schemes.
- **Fix included:** `jexSmoothFanSpeedLevel` now uses symmetric cubic smoothstep. This makes progress `0.5` produce an exact midpoint while keeping ease-in/ease-out endpoints. It resolves Build #34's mismatched test assertion (expected 0.5, previous curve produced 0.510125). Build #34 was blocked before APK compilation; no APK from that failed run was published.
- CI success proves App checks/build/signing only; physical device rendering and MT Manager's displayed signature label remain unverified. No Firmware compile, BIN change, Firebase edit, OTA/flash or hardware operation was performed.

## Historical evidence — never assume current

Previous documents recorded a successful App release run `37245703677`, source commit `fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366`, and APK SHA-256 `a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2` (asset ID `610989112`, size `54,327,520` bytes). Other historical records contain different run/asset IDs. These IDs are **historical only**; fetch current Actions/Releases before calling any run the latest build.

- [PREVIOUS SUCCESSFUL APP BUILD BEFORE SMOOTH-ANIMATION EDITS] Run `38566673160` completed successfully on commit `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38566673160). Audit, dependency resolution, Dart analyze, Flutter tests, APK build and release re-download verification passed for that commit. V1/V2/V3 were true for both built APK and downloaded asset using `--min-sdk-version 23`; certificate SHA-256 was accepted. Release target is `4dccbd7eedcae4a8d1a9cd2b41d5cfda9055416b`, one `JEXFYZ-release.apk` (54,521,947 bytes; SHA-256 `f7ae531834c17fea0dd187307e2e8961dca65aa87b96754082b41475bfc9c845`). Logs warn `META-INF/services/a1` and `META-INF/services/b1` are not protected by JAR/V1; V3.1=false is not enforced by this workflow. This APK does not include the later Fan Speed retargeting, sinusoidal voltage sheen or Bluetooth ripple-envelope edits.
- [PREVIOUS SUCCESSFUL APP BUILD AFTER SIGNING-WORKFLOW HARDENING — OLDER SOURCE] Run `38560939271` completed successfully on commit `2aa77113950ac462bd27fa6f1ca416371eaa7ad8` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38560939271). Security/architecture audit, dependency install, Dart analyze, Flutter tests, APK build and downloaded-release verification passed. `apksigner verify --min-sdk-version 23` reported V1=true, V2=true and V3=true for both the produced APK and re-downloaded Release asset; the official certificate SHA-256 was confirmed. The release contains one `JEXFYZ-release.apk` (54,521,947 bytes; SHA-256 `95e8c9460b69b8c58d183c2bb80102590cf6208c9a48008ba4dc3bf74e5fbd38`) and targets this commit. The log still warns `META-INF/services/b1` is not protected by the JAR/V1 signature; MT Manager's displayed `Signature: Verified failed` has not been independently rechecked against this asset. **This run predates the current Fan coast-down / no-box Peltier / Speed needle source and test changes**, so it does not validate those edits.
- [LATEST VERIFIED SUCCESSFUL APP BUILD BEFORE SIGNING-WORKFLOW HARDENING] Run `38556896542` completed successfully on pre-fix commit `67c5d26723c433b4af856c7759a967a3425bf67a` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38556896542). Security/architecture audit, dependency install, Dart analyze, Flutter tests, APK build, release signing, and release re-download verification passed. The release asset is one `JEXFYZ-release.apk` (54,521,947 bytes; SHA-256 `95e8c9460b69b8c58d183c2bb80102590cf6208c9a48008ba4dc3bf74e5fbd38`), targeting that pre-fix commit. Logs show the expected certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`, V2=true and V3=true, but V1=false. The previous workflow accepted this because it relied on `jarsigner` printing `jar verified.` and did not require `apksigner` V1 verification.
- [SIGNATURE-VERIFICATION FOLLOW-UP] Workflow hardening commit `90d48ec3c97318b5aff4e147151eee96e41b5b25` has since been exercised by run `38560939271`, which verifies V1/V2/V3=true on both the built APK and downloaded release asset using `--min-sdk-version 23`; Android manifest `minSdk` remains 24. The run log contains a warning that `META-INF/services/b1` is not protected by the JAR/V1 signature. MT Manager's exact `Verified failed` reason remains unverified until the current release is installed/rechecked on device. This run predates the latest icon changes; those remain unbuilt.
