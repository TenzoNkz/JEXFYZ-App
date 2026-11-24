# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-24 (Asia/Jakarta). Operating authority: `MASTER_PROMPT.md`.

## Three dedicated ChatGPT workspaces — current operating model

- The repository now defines three independent owner-created ChatGPT conversations: **Diskusi!**, **Eksekusi Code Full!**, and **Eksekusi Build App!**. Each has one copy-ready starter in `CHAT_TRANSFER_PROMPTS.md`; exactly three prompts are maintained.
- The owner must create/select the three chats manually. GitHub/repository prompts cannot open ChatGPT conversations. Chat transcripts are not shared automatically; the three chats share GitHub `main` and canonical memory.
- `MASTER_PROMPT.md` is the single authority. `Eksekusi Full!` is a backward-compatible alias for `Eksekusi Code Full!`. `Chat Stuck!` is recovery inside the existing workspace, not a fourth chat or permission expansion.
- Shared writes/builds are single-writer: do not commit or launch an external operation from multiple chats concurrently. `00_WORK_STATUS.md` now records `WORKSPACE` as `DISKUSI`, `CODE_FULL` or `BUILD_APP`; it is event-driven, not a lock.
- Current workspace during this repository maintenance: `CODE_FULL`. No App Build/Release was started.

## Repository and latest App package

- Canonical repository/branch: `TenzoNkz/JEXFYZ-App` / `main`.
- **Latest published package: Build #167 — terminal SUCCESS.** Actions run `44510421466`, job `135512909555`, Issue #44, workflow `374946166`; immutable package/source SHA `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`.
- Release ID `403010611`, tag `jexfyz-latest`; Release target, Git tag and embedded source marker match the Build #167 source. Exactly two Release assets; no separate Actions artifacts. [Release](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest).
- APK `JEXFYZ-release.apk`: 56,180,827 bytes; SHA-256 `d7c461478e033b4598d1744e2ea7ec969eea8046bf5e4a3d6caaf511bc461691`. Source ZIP `JEXFYZ-corresponding-source.zip`: 3,259,558 bytes; SHA-256 `58711342358639695624bbe05cc598220c9f20710bb04deaa785b93b85ca1546`. Both freshly downloaded and verified by workflow step 21.
- Build gates: security/architecture audit and locked dependencies PASS; analyzer 107 info-level findings / zero warnings-errors; Flutter tests 205/205; Android Gradle BUILD SUCCESSFUL in 2m59s; steps 1–21 and cleanup 39–43 SUCCESS.
- APK V1/V2/V3 signature checks PASS; single-signer pinned certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Self-signed/untrusted PKIX chain and META-INF signature-coverage warnings remain. Native App JUnit tasks were NO-SOURCE; do not count them as executed tests.
- Protected versions retained: Flutter `1.0.0+3`; Android Gradle `versionName "Telegram @horizontalzzz"`.
- Full attempt chronology, step evidence, hashes and warnings are retained in `APP_BUILD_REPORT.md`.

## Current Home cooler design and acceptance

- Build #167 includes the Home cooler sizing correction: right artwork column flex 14; uniform 1.08× scale anchored at `Alignment.centerRight`; `BoxFit.contain` retained; seven left metric rows stay 45 dp. Asset: `assets/jexfyzcooler.png`, blob `bf065985acceab8639d72c670344b805d9e5ba6f`.
- Protected layout: 360-dp canvas/single DPI transform, full square artwork/silhouette and transparency, Home header, metric hierarchy, notification slot, tabs, Light/Dark theme, EN/ID localization, BLE/P1 and authoritative telemetry.
- **Visual acceptance: NOT VERIFIED.** CI and widget tests do not prove Android rendering. Review an actual installed Build #167 at 350-dp/420-dp, EN/ID, Light/Dark, portrait/constrained height; check full silhouette/no crop, longest metric-label clearance, NOTIFY spacing and safe margins. Use `DESIGN_NOTES.md` and `VISUAL_QUALITY_GATE.md`.
- The replacement cooler image's transparency/dimensions/pixels have not been independently re-inspected in this recovery; package inclusion does not prove visual asset acceptance.

## App architecture, workflows and other current boundaries

- Usage Statistics: SQLite schema v2 with v1→v2 migration, 30-day retention, raw 1-Hz Battery/Hotside samples, explicit data gaps, HOT-only P1 freshness and bounded writer admission. Long-duration CPU/memory and storage-pressure soak remain unverified.
- BLE scan ownership is serialized with attempt-generation invalidation and subscription/timer cleanup. Build/Flutter CI does not establish OEM BLE/RF behavior or physical-device acceptance.
- The read-only PR validation workflow exists at `.github/workflows/jexfyz-app-pr-validation.yml`; no open PR was found in the 2026-11-24 recovery check, so this workflow has no observed PR-triggered hosted run yet. Validation Only remains separate; guarded Build App release remains issue/title/token-triggered.
- **Guarded Build App workflow hardening (source-only, no release):** commit `39c33cabe549a9199d118bafa6390ec21081daa6` pins checkout v6, setup-java v6, Flutter action v2 and Gradle setup v6 to upstream-verified full commit SHAs; disables checkout credential persistence; sets workflow permissions to deny-by-default with only guarded-job `contents: write`; disables the Flutter composite's nested mutable cache actions; and scopes Android signing secrets to the APK build and apksigner steps. The explicit `GH_TOKEN` environment is present only on Release publish/final-verification steps, but `contents: write` is granted at the single `build` job level; GitHub notes that actions can access `github.token` without explicit pass-through, so this is job-wide rather than step-level isolation. No post-hardening Build App run or token leak was observed; a stricter split-job/App-token design remains a separate follow-up. Manual issue owner/title/body-token guard, serialized queue and release gates remain intact. Regression protection lives in `test/github_actions_workflow_contract_test.dart`.
- **Validation evidence:** Validation Only run #56 / ID `45408666963` on `9f40c6f73881133327b9227654617eb64c51f4e0` completed SUCCESS: Dart formatter clean, analyzer 107 info-only diagnostics with zero warnings/errors, Flutter tests 212/212 PASS. This is non-publishing CI; Build #167 remains latest package. No APK/App Build/release was initiated.
- Last documented Ruleset API check (2026-11-18): `main-safety-guard` active on the default branch with deletion and non-fast-forward restrictions, no bypass actors. This was not re-queried in the 2026-11-24 recovery. Classic branch protection remains separately API-UNVERIFIED.
- Owner-approved localization/profile wording and previous copy-audit findings remain documented in `APP_NOTES.md`; confirm exact current source coverage with a targeted audit before planning another language cleanup. Do not treat historical audit notes as fresh source inspection.
- Firmware source reference: `firmware/JEXFYZ-V7.2.ino`, `FW_VERSION="V7.2"`. This App Build is not evidence of Firmware compile/BIN provenance, Firebase identity, OTA, flashing, thermal/electrical safety or device behavior.
- BLE App-only identity authentication remains BLOCKED / NOT IMPLEMENTED until trusted enrollment/signing and Firmware verification exist. Online OTA's `cloudClient.setInsecure()` encrypts transport but does not authenticate server certificate identity. OTA stays protected/frozen absent demonstrated defect and explicit authorization.
- No Firmware/BIN, Firebase, OTA, flashing or physical-device operation was performed during Build #167 or the 2026-11-24 Discussion recovery.

## Current repository evidence and next action

- Build #167 package source SHA is immutable. After that checkout, current `main` contains canonical documentation updates, one non-functional Firmware opening-comment correction in `firmware/JEXFYZ-V7.2.ino` (V7.1 text → V7.2), the guarded Build App workflow security hardening and its static source-contract test. No executable App/Firmware runtime code or Firmware behavior changed; the current workflow/test hardening is not included in the Build #167 package.
- Recursive `main` tree at the post-hardening documentation checkpoint: 141 entries / 95 blobs / 46 trees; `truncated=false`. The final HEAD and recursive tree are re-verified after the closing status write.
- **Immediate next acceptance:** obtain actual Build #167 Android screenshots for the Home cooler matrix above. Do not trigger another build merely to repeat successful CI. A source repair requires separate explicit `Eksekusi Code Full!` (legacy alias `Eksekusi Full!`); repackaging requires fresh explicit `Eksekusi Build App!`.
- `APP_BUILD_REPORT.md` holds build history; `CHAT_TRANSFER.md` is the bounded continuation checkpoint; `HANDOVER.md` holds the immediate next step. Subject requirements remain in `APP_NOTES.md`, `DESIGN_NOTES.md`, `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md`.
