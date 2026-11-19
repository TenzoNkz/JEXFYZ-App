# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-19 17:11:46 (Asia/Jakarta).

## Current state — BUILD #165 RELEASED / JE X FYZ DISPLAY OWNER-REPORTED

- **Latest package:** Build #165 / Actions run 43905426531 / job 133432846684 / Issue #42 / source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d. All workflow steps 1–21 and cleanup 39–43 SUCCESS.
- **Validation:** analyzer 107 infos / 0 warnings/errors; Flutter tests 205/205; Android Gradle BUILD SUCCESSFUL in 3m20s. Native App JUnit tasks were NO-SOURCE.
- **APK:** [Download JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — 55,881,819 bytes, SHA-256 1934f9223ea4d5ffbd540601c69157d13923b996c41cf0694128e19372809687. V1/V2/V3 signatures verified; one signer; pinned certificate dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- **Matching source:** [Download JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — 2,945,408 bytes, SHA-256 6f98df3633c00d74a7687697a3332a16606d7edea76f82d1a00d8d201e82bd29; embedded source marker exact cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d; ZIP integrity and downloaded checksum passed.
- **Release:** ID 403010611 / tag jexfyz-latest; tag, Release target and source marker match the exact Build #165 source. Exactly two Release assets; Step 21 re-downloaded and verified both.
- **Protected versions:** Flutter 1.0.0+3; Android Gradle versionName Telegram @horizontalzzz.
- **Bluetooth correction included:** Connection row prioritizes advertised local name JE X FYZ, falls back to platform name, and uses localized generic fallback only if both are empty. No Firmware/BLE protocol change was made.
- **Build #166 candidate — new cooler photo:** `assets/jexfyzcooler.png` is modified on current main (blob `827289e130eda890d853f347b8c6aef4e90c5fee`, 1,947,244 bytes). The file is registered in `pubspec.yaml` and used in Home via `BoxFit.contain`.
- **Validation Only #45:** run `44487957151` / job `135436061477` / source `ac7348fe754130935d0fb2085b25b9ec03d4fce4`, terminal SUCCESS; read-only formatter PASS, analyzer 107 infos / no warnings/errors, Flutter tests 205/205. Its source contains the new photo; later main changes are documentation-only.
- **Technical readiness:** READY for one new guarded App Build once the owner sends a fresh explicit `Eksekusi Build App!` command. No Build #166 run exists and no run is active. Issue #42 already triggered Build #165; do not reuse it. A new owner-authored guarded issue is required after authorization.
- **Image visual caveat:** transparent 1:1 PNG is required by the design contract, but the binary's alpha/dimensions/pixels were not independently inspected in this review. Build App static audit only checks asset existence/non-empty size; visual outcome remains VISUAL NOT VERIFIED.

## GitHub repository hardening — owner-approved and verified

- Owner-approved branch Ruleset: `main-safety-guard`, target default branch `main`, Enforcement `Active`, empty bypass list, only `Restrict deletions` and `Block force pushes`.
- Last owner screenshot (2026-11-18, 14:13): Rulesets list showed `main-safety-guard` Active with 2 rules / 1 target branch; Export/Delete menu was open then. Current phone screen was not inspected; assistant selected neither item.
- Live Rulesets API recheck (2026-11-18 19:23:05 Asia/Jakarta; main HEAD before note sync 9ffd5f632009504aeb9473e04d3fd06dac1fa632): ID `27528678`, active, targets `~DEFAULT_BRANCH`, excludes none, rules `deletion` + `non_fast_forward`, bypass actors empty, `current_user_can_bypass=never`. Recursive tree: 139 entries / 93 blobs / 46 trees / `truncated=false`.
- This matches the approved minimal protection and preserves ordinary non-force direct updates. The Validation Only workflow still pushes its verified formatter-only commit directly to `main`; keep update restrictions, required PRs and required status checks off.
- The Ruleset is complete. Close the open menu without selecting **Delete ruleset**. No force-push or deletion test is needed.
- Classic branch protection is separate and remains API-UNVERIFIED because the integration previously returned 403. A prior owner screenshot showed no classic rule listed; the current Rulesets API does not establish current classic protection state.
- The owner now reports that the App again safely displays `JE X FYZ` (USER-REPORTED). No screenshot, exact installed APK/build or advertisement payload was provided, so independent RF/OEM confirmation remains unverified. This result alone does not call for Eksekusi Full! or a new App Build.

## Next action and boundaries

- **Current readiness decision:** Build #165 remains the latest published App package; Release/tag/ APK/source ZIP still match source `cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d`. The only App runtime delta since #165 is the new `assets/jexfyzcooler.png`, already present in Validation Only #45's passing checkout. A new Build #166 is technically ready but not authorized by Diskusi.
- The owner says no additional field screenshot/package-identity check is needed now. The displayed name remains USER-REPORTED; if independent acceptance is wanted later, Build #165 can be identified and checked without rebuilding.
- A separate read-only PR workflow is now implemented at `.github/workflows/jexfyz-app-pr-validation.yml`. It checks locked dependencies, read-only formatting, analyzer and Flutter tests with `contents: read`; checkout credentials and cache are disabled. Static review passed. No PR is open, so no GitHub run has exercised this new workflow yet.
- Existing Validation Only remains a push-to-main workflow that may write a formatter-only commit; it is not connected to PR events. The guarded Build App release workflow is unchanged. The active main ruleset still does not require PRs or status checks; no Dependabot configuration was added.
- Live state at this handover: Build #165 and Validation Only #45 are terminal-successful; no active/queued Build App run and no open PR. This Diskusi ran no tests, App Build, release, Firmware or device operation. The PR-validation workflow remains hosted-CI NOT RUN until a PR arrives.
- **Immediate next step:** owner sends `Eksekusi Build App!` to authorize one fresh guarded Build #166 attempt. Then repeat live pre-trigger verification, create one new owner-authored issue with exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`, and monitor all gates through downloaded APK/source ZIP verification. Do not reuse Issue #42. The later PR-required-check/Dependabot decision remains separate.
- The last owner screenshot showed Export/Delete open at 14:13; current phone state is unknown. If that menu is still open, close by tapping outside; do not select Delete.
- Classic branch protection remains API-UNVERIFIED (the connected integration previously returned 403), separate from the active Ruleset.
- Firmware compile/BIN provenance, Firebase, OTA/flash, thermal/electrical acceptance and long-session soak remain unverified and need separate scope/authorization.
- Retained Build #165 warnings remain as recorded above: self-signed PKIX / META-INF signature coverage, Kotlin/Gradle deprecations, native ELF DWARF and Android JUnit NO-SOURCE.
