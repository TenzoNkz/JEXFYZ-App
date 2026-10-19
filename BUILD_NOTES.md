# JE X FYZ / JE Cooler — Build & Release Notes

## Authorization policy

- The only App Build command is `@Thinking Eksekusi Build App!`. It authorizes the complete App build/validation workflow, including justified App-scope repair, retries and the approved issue-triggered Release pipeline.
- `@Thinking Eksekusi Full!` does not authorize App Build; discussion, source edits, tests or regular pushes do not silently trigger the release workflow.
- Retired aliases `@Thinking Build App!` and `@Thinking Eksekusi & Build App!`, plus standalone `@Thinking Eksekusi!`, must not be used. `@Thinking Eksekusi Full!` does not authorize App Build.
- Build App does not authorize Firmware compilation, BIN creation/publication/replacement, Firebase metadata changes, physical OTA, flashing, device operation, or unrelated release operations.
- Never claim CI success proves BLE, cooling/safety behavior, Firmware compilation, OTA installation or installed device version.

## LATEST SUCCESSFUL APP BUILD — Build #92 (release handoff verified; newer icon source follow-up pending)

- Latest successful verified App artifact run: [Build #92 / run `39211726896`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39211726896), source `6610fecb3e47d9941cbf96043b7da3b2a869753b`. All 21 workflow steps passed; **98/98 Flutter tests passed**, analyzer passed with 23 info-level deprecation findings, configured Android gate passed, APK signing/official certificate, corresponding source ZIP, re-downloaded asset hashes, Release publication and tag/source equality passed. Native `:app:testDebugUnitTest` was NO-SOURCE; no native JUnit test cases ran.
- APK asset `655482761`, 54,636,635 bytes, SHA-256 `ee3ce9cb9697b8bcabf4da829fc64c16524bbe914eb83901f5d21c855d706926`; matching source ZIP asset `655482764`, 2,857,021 bytes, SHA-256 `7ec969d092638790dd36b5d71c758b68cdc11a0e8db2bdfb390c812f541e677a`.
- At Build #92, published Release `jexfyz-latest` metadata and the live Git tag matched the run's source commit. The official issue-trigger workflow guard remains unchanged and was exercised successfully by that build.
- The present `@Thinking Eksekusi Full!` source follow-up changes the seven Home indicator visuals: Battery/Hotside falling fire particles + thermal halo, Voltage luminous bolt, Adaptive two rotating arrows, Peltier snow/crystal with falling flakes, Fan three broad blades, Fan Speed half-circle gauge with a consistent luminous core. Source/test blobs are `lib/main.dart` `ec8d682432946bd5b9afea925685855d632610b8` and `test/widget_test.dart` `ab0862470846455465b65ec294d33d39c07aac62`.
- The follow-up is newer than Build #92 and is **NOT RUN / NOT RELEASED**. Do not treat Build #92's 98/98 result as test evidence for the newer source. No build was run in this execution; Firmware/BIN/Firebase/OTA/flash/device operations were not performed.
- `@Thinking Eksekusi Full!` never launches App Build. Only the separate `@Thinking Eksekusi Build App!` authorizes the full analyzer/test/build/release retry workflow. Preserve the owner/title/body-token guard and Gradle `versionName "Telegram @horizontalzzz"`.



## HISTORICAL / SUPERSEDED — Build #71 (verified release; superseded by Build #83; kept for history)

- Build #71 / [Actions run `39008259484`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39008259484) released exact source `d9e026f70ec62455763de05048cba1557edfaf23`; all 21 active workflow steps passed with **88/88 Flutter tests**, 23 non-fatal Dart deprecation infos, Android compile/configured gate, APK obfuscation, V1/V2/V3 certificate checks, matching source ZIP and downloaded-asset verification.
- APK asset `649710440`, 54,603,867 bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`; source ZIP asset `649710439`, 2,847,410 bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`. Build #71 included the 440ms OFF fade/phase-continuity refinements and neutral manual-voltage selector styling.
- Native JUnit compile/test tasks were NO-SOURCE after FPS-specific tests were retired; no native JUnit cases ran. Physical-device animation, overlay and BLE behavior remained unverified. Build #83 later superseded it as the latest successful App artifact run.

## HISTORICAL / SUPERSEDED — Build #49 successful App release (superseded by Build #70)
- **Run:** [Build #49 / `38739077916`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38739077916), issue [#22](https://github.com/TenzoNkz/JEXFYZ-App/issues/22), source commit `2b2d2886abb66481b7134e5036824f625ab5659d`, job `116435785328`, runner `1000002352`. Every main step passed.
- **Validation:** architecture/security/license audit, dependency resolution, Dart analysis and all 80 Flutter tests passed; release APK built obfuscated; V1/V2/V3 signing and official certificate verified; corresponding-source ZIP passed integrity/path/license checks; Release upload and re-downloaded APK/source verification passed.
- **Release target:** `jexfyz-latest` now points at source commit `2b2d2886abb66481b7134e5036824f625ab5659d`. Exactly one APK plus one matching source archive:
  - `JEXFYZ-release.apk`, asset `643896939`, 56,087,614 bytes, SHA-256 `d365a99812470986de08be4df1bd54254fe1eb1ea1e3739806d03a6503e3c52a`.
  - `JEXFYZ-corresponding-source.zip`, asset `643896917`, 3,156,558 bytes, SHA-256 `51783b82eae47fc69ab08dd90521e5acdeed0988600042dd1bc3b94f5483dbc8`.
- **Earlier cause:** Build #48's UI annotation said recent account payments failed or the spending limit needed to be increased. Build #49 now confirms the workflow could allocate a runner and finish; no workflow edits or manual-dispatch trigger were added. The exact off-repo billing fix is not independently observed.
- **Non-blocking note:** post-job Gradle cache write warned that its token had no writable scopes; the full build job and every release gate still concluded success. This cache warning did not prevent artifact verification or Release publication.
- **Out of scope:** no Firmware compile/source edit, BIN, Firebase, physical OTA, flash or device operation. App CI does not prove hardware behavior.


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
- [SIGNATURE-VERIFICATION FOLLOW-UP] Workflow hardening commit `90d48ec3c97318b5aff4e147151eee96e41b5b25` has since been exercised by run `38560939271`, which verifies V1/V2/V3=true on both the built APK and downloaded release asset using `--min-sdk-version 23`; Android manifest `minSdk` remains 24. The run log contains a warning that `META-INF/services/b1` is not protected by the JAR/V1 signature. MT Manager's exact `Verified failed` reason remains unverified until the current release is installed/rechecked on device. This historical run predates the latest icon changes; Build #58 later built and test-verified the restored icon/FPS source. Device behavior remains unverified.
