# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-19 17:45:00 (Asia/Jakarta).

## Current state — BUILD #166 RELEASED / HOME COOLER SIZING SOURCE VALIDATED

- **Latest package:** Build #166 / Actions run `44505634022` / job `135496368532` / Issue #43 / source `2ca2235a8e238bb9ca58c11ec878bbfc3f6d25fe`. All workflow steps 1–21 and cleanup 39–43 SUCCESS.
- **Build #166 validation:** analyzer 107 infos / zero warnings-errors; Flutter tests 205/205; Android Gradle BUILD SUCCESSFUL in 2m38s; native App JUnit tasks NO-SOURCE.
- **APK:** [Download JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — 55,996,507 bytes, SHA-256 `ff924fb130f6198eca33c1c1b541748cc4564dc608b7817198e42ae21b2f8d17`. V1/V2/V3 verified; one signer; pinned certificate `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- **Matching source:** [Download JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — 3,012,386 bytes, SHA-256 `851d6e3917e62c450f68874c1031176aeb2ac76a9a891649478cddf8ac9a63b9`; embedded source marker exactly `2ca2235a8e238bb9ca58c11ec878bbfc3f6d25fe`; ZIP integrity and fresh downloaded checksum passed.
- **Release:** ID 403010611 / tag `jexfyz-latest`; tag, Release target and source marker match Build #166 source. Exactly two assets, both freshly downloaded and verified.
- **Protected versions:** Flutter 1.0.0+3; Android Gradle versionName Telegram @horizontalzzz.
- **Bluetooth correction included:** Connection row prioritizes advertised local name JE X FYZ, falls back to platform name, and uses localized generic fallback only if both are empty. No Firmware/BLE protocol change was made.
- **Build #166 candidate — new cooler photo:** `assets/jexfyzcooler.png` is modified on current main (blob `827289e130eda890d853f347b8c6aef4e90c5fee`, 1,947,244 bytes). The file is registered in `pubspec.yaml` and used in Home via `BoxFit.contain`.
- **Validation Only #45:** run `44487957151` / job `135436061477` / source `ac7348fe754130935d0fb2085b25b9ec03d4fce4`, terminal SUCCESS; read-only formatter PASS, analyzer 107 infos / no warnings/errors, Flutter tests 205/205. Its source contains the new photo; later main changes are documentation-only.
- **Technical readiness:** READY for one new guarded App Build once the owner sends a fresh explicit `Eksekusi Build App!` command. No Build #166 run exists and no run is active. Issue #42 already triggered Build #165; do not reuse it. A new owner-authored guarded issue is required after authorization.
- **Image visual caveat:** transparent 1:1 PNG is required by the design contract, but the binary's alpha/dimensions/pixels were not independently inspected in this review. Build App static audit only checks asset existence/non-empty size; visual outcome remains VISUAL NOT VERIFIED.
- **Home cooler enlargement — source implemented / hosted validation PASS:** the Home cooler column is flex 14 (was 13) and the image receives uniform 1.08× scaling anchored right, retaining BoxFit.contain. Seven 45-dp metric rows and all other Home/canvas/NOTIFY/tab contracts are unchanged.
- **Validation Only #48:** run 44508252306 / job 135505409417 / source 53852b57fc6cb542a88f16d8863cc12a93c3ac80, terminal SUCCESS; formatter 18 files / 0 changes, analyzer 107 infos / zero warnings-errors, Flutter tests 205/205.
- **Package boundary:** Build #166's immutable source predates the size change. The new source is not in the current published APK; a separate explicit Eksekusi Build App! is required to package it. This Eksekusi Full operation did not trigger Build/Release.
- **Visual outcome remains NOT VERIFIED:** no post-change Android screenshots. Confirm 350-dp/420-dp, EN/ID, Light/Dark, portrait/constrained height, full silhouette/no crop, margin and metric/NOTIFY clearance after installation.

## GitHub repository hardening — owner-approved and verified

- Owner-approved branch Ruleset: `main-safety-guard`, target default branch `main`, Enforcement `Active`, empty bypass list, only `Restrict deletions` and `Block force pushes`.
- Last owner screenshot (2026-11-18, 14:13): Rulesets list showed `main-safety-guard` Active with 2 rules / 1 target branch; Export/Delete menu was open then. Current phone screen was not inspected; assistant selected neither item.
- Live Rulesets API recheck (2026-11-18 19:23:05 Asia/Jakarta; main HEAD before note sync 9ffd5f632009504aeb9473e04d3fd06dac1fa632): ID `27528678`, active, targets `~DEFAULT_BRANCH`, excludes none, rules `deletion` + `non_fast_forward`, bypass actors empty, `current_user_can_bypass=never`. Recursive tree: 139 entries / 93 blobs / 46 trees / `truncated=false`.
- This matches the approved minimal protection and preserves ordinary non-force direct updates. The Validation Only workflow still pushes its verified formatter-only commit directly to `main`; keep update restrictions, required PRs and required status checks off.
- The Ruleset is complete. Close the open menu without selecting **Delete ruleset**. No force-push or deletion test is needed.
- Classic branch protection is separate and remains API-UNVERIFIED because the integration previously returned 403. A prior owner screenshot showed no classic rule listed; the current Rulesets API does not establish current classic protection state.
- The owner now reports that the App again safely displays `JE X FYZ` (USER-REPORTED). No screenshot, exact installed APK/build or advertisement payload was provided, so independent RF/OEM confirmation remains unverified. This result alone does not call for Eksekusi Full! or a new App Build.

## Next action and boundaries

- **Current readiness decision:** Build #166 is the latest published App package (source `2ca2235a8e238bb9ca58c11ec878bbfc3f6d25fe`) and includes the replacement cooler photo. The newer Home cooler sizing source (flex14 / scale1.08) is on main and passes Validation Only #48, but is not included in the Build #166 APK. A new APK requires a separate explicit `Eksekusi Build App!` command.
- The owner says no additional field screenshot/package-identity check is needed now. The displayed name remains USER-REPORTED; if independent acceptance is wanted later, Build #165 can be identified and checked without rebuilding.
- A separate read-only PR workflow is now implemented at `.github/workflows/jexfyz-app-pr-validation.yml`. It checks locked dependencies, read-only formatting, analyzer and Flutter tests with `contents: read`; checkout credentials and cache are disabled. Static review passed. No PR is open, so no GitHub run has exercised this new workflow yet.
- Existing Validation Only remains a push-to-main workflow that may write a formatter-only commit; it is not connected to PR events. The guarded Build App release workflow is unchanged. The active main ruleset still does not require PRs or status checks; no Dependabot configuration was added.
- Live state at this handover: Build #166 and Validation Only #48 are terminal-successful; no App Build was started by this Full request. Validation #46/#47 were intermediate failures: #46 caught the stale asset-indent assertion; #47 Flutter tests passed, but its formatter-only commit was safely refused because main advanced; the exact formatter change was applied and #48 passed cleanly. This session ran no APK build/release, Firmware or device operation. The PR-validation workflow remains hosted-CI NOT RUN until a PR arrives.
- **Immediate next step:** review the larger cooler on an actual installed Android build when a new Build App is separately authorized. To package this source, owner sends a fresh `Eksekusi Build App!`; then repeat live pre-trigger verification, create a new owner-authored issue with the exact guard title/token, do not reuse Issue #43, and monitor all gates through downloaded APK/source ZIP verification. This current Full request did not authorize a Build. The later PR-required-check/Dependabot decision remains separate.
- The last owner screenshot showed Export/Delete open at 14:13; current phone state is unknown. If that menu is still open, close by tapping outside; do not select Delete.
- Classic branch protection remains API-UNVERIFIED (the connected integration previously returned 403), separate from the active Ruleset.
- Firmware compile/BIN provenance, Firebase, OTA/flash, thermal/electrical acceptance and long-session soak remain unverified and need separate scope/authorization.
- Retained Build #165 warnings remain as recorded above: self-signed PKIX / META-INF signature coverage, Kotlin/Gradle deprecations, native ELF DWARF and Android JUnit NO-SOURCE.
