## Active App QC — Build #146 (2026-11-11)

- Run 42944693211, job 130274555621, source SHA `d5bc688cc14243cd944f2d8d653bbcb59d2805fe`. Steps 1–2 success; step 3 Java setup in progress.
- Includes repairs for #144 helper/method scope, timeline widget key, imports and #145 nullability/path assertion.
- #144 ended at analyzer (12 errors, 3 warnings); #145 ended at analyzer (1 error, 1 warning). Neither reached Flutter tests/Android/APK/Release.
- Existing performance risks remain: full selected-session summary recomputation every one-second batch, unbounded/unbatched recorder queue, long-session CPU/memory/backpressure, animation lifecycle/60–120-Hz tests.

---
## Build #145 analyzer failure — follow-up nullable-field fix committed (2026-11-11)

- Run 42944293567, job 130273243595, source `264469a80b49f70a09f2d705b6ad339ae3ba5fe4`. Steps 1–11 passed, step 12 failed with 1 error, 1 warning, 23 infos; downstream gates skipped.
- #144 structural errors (helper method scope, action parameter, cursor methods and timeline key) are now resolved in the #145 analyzer log.
- Remaining error: class painter field `referenceValue` did not flow-promote through the field null check before passing to `yFor(double)`. Warning: unnecessary `path!` in the else branch after a branch predicate already establishes non-null.
- Fix commit `250d2a031667c0b7ceab98e3077a35a97408d8ce`: local alias `reference` is null-checked then passed to `yFor`; redundant path assertion removed. Read-back verified; no hosted revalidation yet.
- A new guarded retry is authorized by the original Build App command after current preflight. Keep all original gates and risk register.

---
## Active validation — Build #145 (2026-11-11)

- Run 42944293567, job 130273243595, immutable source `264469a80b49f70a09f2d705b6ad339ae3ba5fe4`; issue-triggered attempt 1.
- Steps 1–3 success; Step 4 Flutter setup in progress; later gates pending. No package yet.
- Repair commits: `80b8874c9d851d1422009cfdbb85f33eec74f8b2` and `1e04495416426ea5f4b3c9280704b1deee9a821c`.
- #144 stopped at analyzer; 12 errors, 3 warnings, 25 infos. No downstream test/build/release. Root cause was cursor helpers embedded in `_messageState` parameter list plus missing key forwarding on timeline widget.
- Known open performance gaps: selected-session full-summary recompute each one-second UI batch; unbounded/unbatched recorder write queue; long-session CPU/memory/backpressure; animation lifecycle/60–120-Hz testing. Do not claim these are solved by normal CI gates.

---
## Build #144 analyzer failure — concrete App repair committed, hosted retry pending (2026-11-11)

- Run 42943589237, job 130270923510, source `e1d624bc0990ed3552ebbefaac1164cf025b794f`. Steps 1–11 success, step 12 analyzer failure, downstream 13–21 skipped; no package/Release mutation.
- Analyzer: 40 findings = 12 errors, 3 warnings, 25 infos. Core failure: cursor helper methods were inserted inside the _messageState named parameter list; action became undefined, helpers were out of class scope, parser/private-parameter errors cascaded. Timeline widget constructor also did not accept `key`.
- Repairs: commit `80b8874c9d851d1422009cfdbb85f33eec74f8b2` moves helpers back to class scope, restores optional action parameter, forwards key in timeline widget, removes unused previousY and unnecessary non-null assertion. Commit `1e04495416426ea5f4b3c9280704b1deee9a821c` removes redundant imports. Read-back confirms changes; no Flutter toolchain means no local analyzer/test evidence.
- Next guarded retry is authorized under same owner Build App command. Preflight must re-confirm #144 terminal, issue #33 guard, no active run/PR and exact repaired source SHA. Never weaken tests.
- Still open: incremental summary optimization, SQLite queue bounds/backpressure and long-session CPU/memory, animation lifecycle/60–120-Hz test coverage.

---
## Active guarded release attempt — Build #144 (2026-11-11)

- Run 42943589237, job 130270923510, workflow 374946166, issue event, attempt 1; source SHA `e1d624bc0990ed3552ebbefaac1164cf025b794f`.
- Issue #33 exact guarded trigger closed/reopened once. Exactly one run created; no duplicate.
- Initial runner status in_progress at step 1 Set up job; no later result/artifact at this checkpoint.
- Candidate source includes compact Peltier/LED overlays, six-metric Usage Statistics, Peltier telemetry, synchronized cursor, interpolation/decimation, one-second page refresh and new tests.
- Open risk register: selected-session summary recompute per one-second batch, unbounded/unbatched SQLite recorder queue, long-session CPU/memory/backpressure and animation lifecycle/60–120-Hz stress tests. Not independently validated by a passing CI run.
- Keep every existing gate. Preserve Android versionName `Telegram @horizontalzzz`; App-only scope.

---
## Current candidate — guarded Build App requested (2026-11-11)

- Owner command: explicit `Eksekusi Build App!`; one new guarded issue-triggered App Build/QC attempt is authorized, without weakening gates.
- Candidate main before this documentation checkpoint: `18787069be826cad3027dc1a1eb9952cfaf92641`; latest executable source/test commit `33fe9a545d7a8594e6e3a5119d3b1f564a93d868`.
- New App changes since Build #143: compact Peltier and LED overlays; Peltier telemetry state and seeded baseline; six synchronized Usage Statistics charts; shared cursor, temperature interpolation, discrete operating-state lanes, HOT freshness bound and display decimation; one-second UI batch refresh. Widget and Statistics regression source added.
- Open risk register: selected-session full summary is recomputed per one-second batch; SQLite serialized write queue remains unbounded/unbatched; long-session CPU/memory/backpressure and animation lifecycle/60–120-Hz stress tests incomplete. Current local session has no Flutter/Dart/Gradle, so no local format/analyzer/test execution. Hosted workflow is now the authorized validation path; these risks must remain in final report even if gates pass.
- Preflight: workflow blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`, issue-only exact guard, issue #33 OPEN exact, no active Actions run/open PR. Release baseline Build #143 / tag SHA `121ef9e0f5ed6a0003837d32e4c8b1701f38631a`.
- Keep Android `versionName "Telegram @horizontalzzz"`; App-only scope.

---
## Current verified App release — Build #143 SUCCESS (2026-11-10)

- **Latest verified package:** Build #143 / run 42783474515, job 129718855331, final conclusion success; all 21 workflow gates and cleanup passed.
- **Exact App source:** 121ef9e0f5ed6a0003837d32e4c8b1701f38631a; the jexfyz-latest tag / Release ID 403010611 targets that same SHA. Main's later documentation checkpoints do not alter the tested App source.
- **Validation:** security/architecture audit passed; analyzer 25 info-only, zero warnings/errors; Flutter tests 159/159 passed. Android Gradle :app:testDebugUnitTest returned NO-SOURCE; no native Android app JUnit tests ran, even though the Gradle gate completed successfully.
- **Build/signing:** Flutter release build used --obfuscate --split-debug-info=build/symbols; production APK one signer, RSA 4096, V1/V2/V3 all verified. Pinned certificate SHA-256 dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0; expected JE X FYZ DN matched. Same checks passed on the downloaded Release APK.
- **APK asset:** JEXFYZ-release.apk, 55,685,211 bytes, SHA-256 65d001c7a8df708dd35d5c80665c4cb7e377d47f11bdb675022c00817b251cd0; download https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk.
- **Source asset:** JEXFYZ-corresponding-source.zip, 2,911,348 bytes, SHA-256 b7682a0d73a1d494d5d187481115480465bdb6aaf3fa9db79fcebca8279e4fc6; download https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip. Workflow confirmed exactly one APK plus one source ZIP, matching tag/source SHA, archive integrity, source marker, local/downloaded SHA equality and downloaded APK signature.
- **Release:** jexfyz-latest, Release ID 403010611, target 121ef9e0f5ed6a0003837d32e4c8b1701f38631a. Android versionName "Telegram @horizontalzzz" remains intact; release metadata reports 1.0.0+3.
- **Warnings:** Android test task NO-SOURCE; Flutter/Kotlin warning (Kotlin 2.2.20 soon below compatibility recommendation 2.3.20); Gradle deprecations before Gradle 10; native ELF DWARF debug info remains present despite Dart obfuscation; jarsigner PKIX trust-chain/META-INF warnings (expected pinned certificate matched; apksigner V1/V2/V3 passed). Optional cache writes were denied during cleanup but job succeeded. Native ELF debug-symbol stripping and toolchain modernization are follow-up App hardening work, not reasons to misstate this build.
- **Not covered:** physical install/OEM QA, responsive layout at 350-dp/420-dp, real BLE/device telemetry and Statistics soak, thermal/electrical behavior, Firmware/BIN/Firebase/OTA/flash.

## Superseded failure repairs included in Build #143

- #139 analyzer failure repaired by 93b1ba7b859089eeccd30719ddfb8b8ab2dabaf6 and 2656b6eb9071cf878de2373cfab03d1872e089f8.
- #140 stale test identifier repaired by 2a0b1b94f7ebce1607ba26067441accb31a105c7.
- #141 Indonesian localized assertion repaired by bafff332f406fdb75e4534d3d9c426d13e83a31b.
- #142 elapsed label changed to stable-key lookup by f210e6b9036723150f1596d3d54ed270f401ca63.
- Build #143 passed analyzer and Flutter suite with all these repairs included.

---

## Authorization and trigger

- Start end-to-end App Build/QC/release only with @Thinking Eksekusi Build App!.
- Read the full .github/workflows/jexfyz-app-build-trigger.yml and current main before invoking anything.
- Workflow is issue-triggered only. Required title: JE X FYZ — EKSEKUSI BUILD APP TRIGGER. Required body token: JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1.
- Do not add push/PR release triggers or weaken workflow gates to make a build easier.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- Produce the single ordinary obfuscated production-signed APK and its corresponding source ZIP; do not produce a Play Store app bundle.

## Required release gates

1. Confirm live main, intended source SHA, current workflow and trigger input.
2. Follow the workflow's architecture/security/license/dependency, Dart analyzer and Flutter test gates.
3. Verify APK compilation, obfuscation, V1/V2/V3 signing and the configured production certificate.
4. Verify the corresponding-source ZIP and required source markers/path/license checks.
5. Confirm Release publication and the live tag target.
6. Download the published APK and ZIP, then verify exact count, name, size, digest and identity against the build output.
7. Record all evidence, warnings, skips and unverified physical behavior in APP_BUILD_REPORT.md.

## Evidence-based repair and retry

- Inspect actual failing step/job logs. Repair an App-scope root cause instead of lowering test expectations or bypassing a gate.
- Commit justified repairs to main, then trigger a new run and confirm its intended source SHA.
- Retry only after a concrete fix or a documented transient infrastructure cause. Never launch duplicate builds blindly.
- If permissions, runner allocation, signing secrets, external services or owner/device action blocks progress, record the exact blocker and stop as BLOCKED.
- A successful App build does not authorize Firmware compilation, BIN publication/replacement, Firebase mutation, OTA, flash or device actions. Those require separate explicit permission.
- Use Prompt 2 in CHAT_TRANSFER_PROMPTS.md for chat-limit LOAD + CONTINUE of the guarded Build App/QC workflow. Its copy-ready block already begins with Eksekusi Build App! (without the @Thinking prefix); paste it as one complete message without a duplicate command line. Keep the run ledger, not a recap chat, as the continuation source.
