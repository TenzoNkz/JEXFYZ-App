# JE X FYZ / JE Cooler — Build & Release Notes

## Authorization policy

- The only App Build command is `@Thinking #Build App!`. It authorizes the complete App build/validation workflow, including justified App-scope repair, retries and the approved issue-triggered Release pipeline.
- `@Thinking #Eksekusi Full!` does not authorize App Build; discussion, source edits, tests or regular pushes do not silently trigger the release workflow.
- Retired standalone `#Eksekusi!` and combined `#Eksekusi & Build App!` commands must not be used.
- Build App does not authorize Firmware compilation, BIN creation/publication/replacement, Firebase metadata changes, physical OTA, flashing, device operation, or unrelated release operations.
- Never claim CI success proves BLE, cooling/safety behavior, Firmware compilation, OTA installation or installed device version.

## Current App Build workflow

- Active workflow path: `.github/workflows/jexfyz-app-build-trigger.yml` — fetch live definition before every authorized build.
- Trigger title: `JE X FYZ — BUILD APP TRIGGER`.
- Required body token: `JEXFYZ_BUILD_TRIGGER_V1`.
- Manual issue-open/reopen trigger only, with owner/title/token validation. Normal push/PR must not generate a release APK.
- Toolchain last recorded in workflow: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Intended output: exactly one obfuscated, production-signed ordinary Android APK, filename `JEXFYZ-release.apk`, published to GitHub Release `jexfyz-latest`. No Play Store bundle and no Actions artifact upload.
- Production signing certificate SHA-256 in prior build record: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Verify against live workflow/config before relying on it.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.

## Current App Build blocker — hosted runner dispatch (2026-10-15)

- Current `main` HEAD before this update is `16369c8b1723732eb94c73689b4f9d1a85a20641` (documentation-only follow-ups); App workflow/source-path repair is commit `f9ca1e98aaed10712f77502c3441cb98904e3594`, correcting the corresponding-source archive's SPAKE2-Java 1.0.5 path assertion.
- Build #40 `38713854518` on `d638f6941d9ac16a228f4b78ed001ca2e925f716` passed the audit/license checks, Flutter dependency install, Dart analysis, all 80 tests, obfuscated APK compilation and V1/V2/V3 plus production certificate validation. It failed only because the corresponding-source step checked an obsolete path. The corrected path is `src/main/java/com/flyfish233/crypto/spake2/Spake2Context.java`.
- Build #41–#45 on the corrected source did not reach any workflow step. Runs: #41 `38715261426` (attempt 2 job `116356817322`), #42 `38715656340` (attempt 2 job `116357869559`), #43 `38715911768` (attempt 1 job `116358423340`), #44 `38718952314` (jobs `116368449764` and `116368665443`) and #45 `38719397780` (job `116369943522`). Every observed failed job completed in roughly two to four seconds with `runner_id=0`, empty runner name and zero steps; #45 also reports an empty runner group. No usable logs exist.
- One explicit retry of Build #44 failed with the same signature. A fresh official trigger (#45) was then justified because GitHub Status showed Actions operational, but it reproduced the same pre-step failure. The observed pattern is consistent with hosted-runner dispatch/provisioning trouble; exact repository/account cause is unconfirmed. Similar symptoms were reported in GitHub Community: https://github.com/orgs/community/discussions/208438 and https://github.com/orgs/community/discussions/209028.
- **Release status:** no APK or source bundle was published by #40–#44. Release tag `jexfyz-latest` still targets older Build #36 commit `893393388b99fc6d9e59c420070a159a29e45e9a`. Do not describe the latest source as released.
- **Distribution route already chosen:** retain Kadb 1.3.0 and Wireless ADB. Include the GPL-3.0 license text in APK assets, and package the exact App source plus Kadb 1.3.0 and SPAKE2-Java 1.0.5 source/licenses as `JEXFYZ-corresponding-source.zip` alongside exactly one APK in the same private Release. Continue this existing route; do not ask the user to choose A/B again. This is a technical source-availability safeguard, not a legal opinion.
- **Next:** do not blindly retrigger Issue #13. Run the manual `.github/workflows/hosted-runner-diagnostic.yml` (blob `8364d906b5c8570d7bda8c0ea3aef4a308931ff7`) in the separate Build App workstream first. It uses the same `ubuntu-24.04` label but does not checkout, compile, or publish the App. If it fails before steps with runner ID 0, inspect account Actions minutes/budget/spending cap, repository Settings → Actions permissions/allowed actions, security/verification restrictions and the job check-run annotation; contact GitHub Support if those settings are normal. If it succeeds, inspect release-workflow trigger/concurrency and then run the corrected end-to-end App release. This `#Eksekusi Full!` execution did not trigger either workflow.

## Validation sequence

1. Inspect current branch/source and workflow.
2. Run authorized dependency resolution, Dart analysis and Flutter tests as configured.
3. Build only the requested one obfuscated release APK if gates pass.
4. Verify APK name/count, signing, release asset and workflow outputs from live run data.
5. Record exact run ID, source commit, asset ID/size/digest, and test/analyze results only when actually verified.
6. If failure occurs, record exact failure and whether test/analyze were reached; do not imply skipped checks passed.

## Build App repair/retry policy

1. Start only from `@Thinking #Build App!`. Fetch current `main`, read this file and the full `.github/workflows/jexfyz-app-build-trigger.yml` before triggering.
2. Follow the owner/title/token-validated manual issue workflow. Never change the workflow to build on push/PR merely to make triggering easier.
3. When a check fails, inspect the exact failing step and logs. If the defect is within approved App scope, fix the cause rather than weakening tests or skipping a required gate; commit the fix to `main`, then trigger a fresh run and verify it targets the intended commit.
4. Repeat only when a concrete repair was made or a transient failure has evidence-based reason to retry. Do not loop blindly. If blocked by missing repository permissions/secrets, external service, signing credentials, or device-side action, record the blocker and required action; report status as BLOCKED, not successful.
5. Do not declare completion until workflow success, required analysis/tests, APK file/count, signing schemes, production certificate, Release publication and re-downloaded asset identity/checksum are all verified against live run output.
6. Update `APP_BUILD_REPORT.md` during the workflow with every attempt and fix, and finish with source commit, trigger issue, run ID/link, test counts/status, APK name/count/size/SHA-256, signature checks, remaining warnings and unverified device checks. A successful or interrupted Build App workstream must be resumable from this ledger by the one-shot Prompt D LOAD + CONTINUE handoff, without a separate recap chat.
7. If fix would touch Firmware, protected OTA behavior, secrets, Firebase production metadata, or requires changing authorization boundaries, stop and ask for the separate required authorization; do not treat a Build App request as permission for those changes.

## Latest verified build result — 2026-10-15

- **Latest successful App Build:** run #35 / ID `38669526891`, code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8` ([Actions run](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38669526891)).
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
