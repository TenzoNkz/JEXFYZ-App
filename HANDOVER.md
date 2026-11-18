# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-18 18:05:22 (Asia/Jakarta).

## Current state — BUILD #165 RELEASED / JE X FYZ DISPLAY OWNER-REPORTED

- **Latest package:** Build #165 / Actions run 43905426531 / job 133432846684 / Issue #42 / source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d. All workflow steps 1–21 and cleanup 39–43 SUCCESS.
- **Validation:** analyzer 107 infos / 0 warnings/errors; Flutter tests 205/205; Android Gradle BUILD SUCCESSFUL in 3m20s. Native App JUnit tasks were NO-SOURCE.
- **APK:** [Download JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — 55,881,819 bytes, SHA-256 1934f9223ea4d5ffbd540601c69157d13923b996c41cf0694128e19372809687. V1/V2/V3 signatures verified; one signer; pinned certificate dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- **Matching source:** [Download JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — 2,945,408 bytes, SHA-256 6f98df3633c00d74a7687697a3332a16606d7edea76f82d1a00d8d201e82bd29; embedded source marker exact cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d; ZIP integrity and downloaded checksum passed.
- **Release:** ID 403010611 / tag jexfyz-latest; tag, Release target and source marker match the exact Build #165 source. Exactly two Release assets; Step 21 re-downloaded and verified both.
- **Protected versions:** Flutter 1.0.0+3; Android Gradle versionName Telegram @horizontalzzz.
- **Bluetooth correction included:** Connection row prioritizes advertised local name JE X FYZ, falls back to platform name, and uses localized generic fallback only if both are empty. No Firmware/BLE protocol change was made.

## GitHub repository hardening — owner-approved and verified

- Owner-approved branch Ruleset: `main-safety-guard`, target default branch `main`, Enforcement `Active`, empty bypass list, only `Restrict deletions` and `Block force pushes`.
- Owner's 2026-11-18 14:13 screenshot shows the Ruleset in the list as Active, with 2 branch rules and 1 target branch. The menu is open and offers Export / Delete; the assistant did not act on either option.
- Live read-only API verification at main HEAD `81a17a212dc3cecf1e3aed3d29f7c1edc0e716af`: repository default branch `main`; recursive tree 139 entries / 93 blobs / 46 trees, `truncated=false`; Rulesets API lists exactly ID `27528678`, `main-safety-guard`, branch target, repository source, enforcement `active`. Detail response confirms `include=["~DEFAULT_BRANCH"]`, `exclude=[]`, rules `deletion` + `non_fast_forward`, `bypass_actors=[]`, `current_user_can_bypass=never`. GitHub creation time: 2026-11-18 14:13:18 +07:00.
- This matches the approved minimal protection and preserves ordinary non-force direct updates. The Validation Only workflow still pushes its verified formatter-only commit directly to `main`; keep update restrictions, required PRs and required status checks off.
- The Ruleset is complete. Close the open menu without selecting **Delete ruleset**. No force-push or deletion test is needed.
- Classic branch protection is separate and remains API-UNVERIFIED because the integration previously returned 403. A prior owner screenshot showed no classic rule listed; the current Rulesets API does not establish current classic protection state.
- The owner now reports that the App again safely displays `JE X FYZ` (USER-REPORTED). No screenshot, exact installed APK/build or advertisement payload was provided, so independent RF/OEM confirmation remains unverified. This result alone does not call for Eksekusi Full! or a new App Build.

## Next action and boundaries

- Ruleset verification is complete. Owner may close the open menu by tapping outside it; do not select **Delete ruleset**.
- No further Ruleset change or test push is needed. The exact live configuration is recorded above and in `PROJECT_STATE.md`.
- No source or build step is indicated for the owner-reported display result. If independently auditable evidence is desired later, provide a fresh scan screenshot and installed build details; the current report remains USER-REPORTED.
- Classic branch protection remains API-UNVERIFIED (403 from the connected integration); a prior owner screenshot showed no rule listed, but it was not rechecked during this Ruleset verification.
- Retain package warnings and boundaries: certificate is self-signed / PKIX-untrusted and META-INF coverage warnings remain; Kotlin 2.2.20 / Firebase KGP compatibility, Android Gradle/Gradle 10 deprecations, Notification priority deprecations, native ELF DWARF, and native JUnit NO-SOURCE remain recorded and unfixed.
- Firmware compile/BIN provenance, Firebase, OTA/flash, thermal/electrical acceptance and long-session soak remain unverified and require separate authorization.
