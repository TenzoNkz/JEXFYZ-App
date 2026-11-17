# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-17 17:39:26 (Asia/Jakarta).

## Current state — BUILD #165 RELEASED SUCCESS

- **Latest package:** Build #165 / Actions run 43905426531 / job 133432846684 / Issue #42 / source cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d. All workflow steps 1–21 and cleanup 39–43 SUCCESS.
- **Validation:** analyzer 107 infos / 0 warnings/errors; Flutter tests 205/205; Android Gradle BUILD SUCCESSFUL in 3m20s. Native App JUnit tasks were NO-SOURCE.
- **APK:** [Download JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — 55,881,819 bytes, SHA-256 1934f9223ea4d5ffbd540601c69157d13923b996c41cf0694128e19372809687. V1/V2/V3 signatures verified; one signer; pinned certificate dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- **Matching source:** [Download JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — 2,945,408 bytes, SHA-256 6f98df3633c00d74a7687697a3332a16606d7edea76f82d1a00d8d201e82bd29; embedded source marker exact cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d; ZIP integrity and downloaded checksum passed.
- **Release:** ID 403010611 / tag jexfyz-latest; tag, Release target and source marker match the exact Build #165 source. Exactly two Release assets; Step 21 re-downloaded and verified both.
- **Protected versions:** Flutter 1.0.0+3; Android Gradle versionName Telegram @horizontalzzz.
- **Bluetooth correction included:** Connection row prioritizes advertised local name JE X FYZ, falls back to platform name, and uses localized generic fallback only if both are empty. No Firmware/BLE protocol change was made.

## GitHub repository hardening — owner-approved / pending manual creation

- Rulesets API currently returned empty list; owner screenshots also showed no classic branch protection rule. No repository settings have been changed by the assistant.
- Owner approved a minimal branch Ruleset: `main-safety-guard`, target default branch `main`, Enforcement `Active`, no bypass entries, only `Restrict deletions` + `Block force pushes`; all other rules OFF. This preserves normal direct pushes and the existing Validation Only formatter commit path.
- Owner reports image upload is limited. Continue setup using text-only field verification; no screenshot is required.
- Before owner clicks Create, verify the form values in text: name, Active enforcement, default-branch target, empty bypass list, and exact two enabled rules. GitHub's form defaults Enforcement to Disabled, so owner must explicitly select Active. After Create, owner should report the resulting ruleset status/target/rules in text; no test force-push or deletion should be performed.
- Detailed continuation: `CHAT_TRANSFER.md`, Stage 4. Active setup remains a manual owner action; this Diskusi has not created a Ruleset.

## Next action and boundaries

- Immediate owner-side next step: continue the approved `main-safety-guard` setup through GitHub UI using the text-only verification path. After repository hardening, the separate physical next step remains installing Build #165 APK and confirming the real cooler's Bluetooth Connection row displays JE X FYZ. CI does not prove physical radio behavior or OEM visuals.
- Retain warnings: self-signed PKIX trust chain, META-INF signature coverage, Kotlin 2.2.20 / Firebase KGP compatibility, Android Gradle/Gradle 10 deprecations, Notification priority deprecations, native ELF DWARF, and native Android JUnit NO-SOURCE.
- Firmware compile/BIN provenance, Firebase, OTA/flash, thermal/electrical, long-session soak and OEM visual acceptance remain separate and unverified. No such operation was performed or authorized.
