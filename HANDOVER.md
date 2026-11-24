# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-24 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Three dedicated ChatGPT workspaces — SETUP IN REPOSITORY

- Create three separate ChatGPT conversations manually: **JE X FYZ — Diskusi**, **JE X FYZ — Eksekusi Code Full**, and **JE X FYZ — Eksekusi Build App**.
- Start each conversation with its matching copy-ready block in `CHAT_TRANSFER_PROMPTS.md` (Prompts 1, 2 and 3). There are exactly three; do not re-use one prompt by simply changing the command line in an existing chat.
- `MASTER_PROMPT.md` is the sole rules authority. `Eksekusi Full!` is a legacy alias for `Eksekusi Code Full!`. `Chat Stuck!` recovers only the active workspace's existing authorization.
- All three chats share the same GitHub `main` and canonical memory but not their chat transcripts. `00_WORK_STATUS.md` identifies the active workspace (`DISKUSI`, `CODE_FULL`, `BUILD_APP`). Repository state is global, not three separate branches or isolated copies.
- **Single-writer rule:** finish/close any mutating session before another chat commits, updates shared memory or starts an external Build App operation. The WORKSPACE marker is not a lock.
- The repository cannot create ChatGPT chat windows. The owner must create/select each conversation and paste the corresponding starter prompt.

## Current state — BUILD #167 PUBLISHED / CI AND RELEASE VERIFIED

- **Latest App package:** Build #167 / Actions run `44510421466` / job `135512909555` / Issue #44 / immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`. Run/job terminal SUCCESS; all workflow steps 1–21 and cleanup 39–43 SUCCESS.
- **Validation:** analyzer 107 info-level findings / zero warnings-errors; Flutter tests 205/205; Android Gradle `BUILD SUCCESSFUL` in 2m59s. Native App JUnit tasks were `NO-SOURCE`, so no native App JUnit test cases ran.
- **Release:** ID `403010611`, tag `jexfyz-latest`; Release target and Git tag match Build #167 source. [Open GitHub Release](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest).
- **APK:** [Download JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — 56,180,827 bytes, SHA-256 `d7c461478e033b4598d1744e2ea7ec969eea8046bf5e4a3d6caaf511bc461691`. V1/V2/V3 and the pinned single-signer certificate fingerprint `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` verified.
- **Matching source:** [Download JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — 3,259,558 bytes, SHA-256 `58711342358639695624bbe05cc598220c9f20710bb04deaa785b93b85ca1546`; embedded source marker matches exact Build #167 SHA. Both assets were freshly downloaded and verified in step 21; Release contains exactly one APK and one source ZIP.
- **Home cooler change included:** right image column flex 14, uniform 1.08× scale anchored right, `BoxFit.contain` preserved; seven left telemetry rows remain 45 dp.
- **Post-package main changes:** after the immutable Build #167 checkout, canonical documentation, one non-functional Firmware header-comment correction (V7.1 text → V7.2), guarded Build App workflow security hardening (commit `39c33cabe549a9199d118bafa6390ec21081daa6`) and a static regression test (`test/github_actions_workflow_contract_test.dart`) were committed. No executable App/Firmware runtime behavior changed; current workflow/test hardening is not included in Build #167.
- **Latest source validation:** Validation Only #56 / run `45408666963` / job `138496176455`, tested source `9f40c6f73881133327b9227654617eb64c51f4e0`, terminal SUCCESS: Dart format clean, analyzer 107 info-only diagnostics / zero warnings-errors, Flutter tests 212/212. This is a non-publishing validation, not a new App Build.
- **Warnings / limitations:** self-signed/untrusted PKIX chain and META-INF signature-coverage warnings remain. They did not fail explicit V1/V2/V3 checks. No Actions artifacts were produced; Release assets are the delivery. Android JUnit task is NO-SOURCE.
- **Visual acceptance: NOT VERIFIED.** One owner screenshot of Build #167 Home (English / Light / disconnected) was reviewed on 2026-11-24; it shows the complete cooler silhouette and readable metric labels. The screenshot does not identify exact source SHA or logical dp/density, and does not cover the required viewport/locale/theme/connected-state matrix. CI/widget tests cannot prove the full rendered layout. See `DESIGN_NOTES.md`.

## Immediate next action — staged whole-App modernization (PROPOSED, NOT AUTHORIZED)

- The next implementation session should be opened in the separate **Eksekusi Code Full!** conversation. Start with a bounded platform/dependency modernization phase; do not combine SDK migration, whole-App architecture rewrite and all UI changes in one uncontrolled patch.
- Foundation phase proposal: move Flutter/Dart to stable 3.50.1/3.14.0 and migrate framework Material imports to official `material_ui`; coordinate Android AGP 9.5.2 / Gradle 9.9.2 / AGP built-in Kotlin migration; restore a committed, checksum-pinned Gradle Wrapper; keep JDK 17, compileSdk 37, targetSdk 36, minSdk 24 and `versionName "Telegram @horizontalzzz"` unchanged. Update and keep all Flutter SDK versions consistent across Validation Only, PR Validation and guarded Build App workflows.
- Upgrade Firebase Core/App Check and SQLite in separate validated commits. Hold `flutter_blue_plus` 2.3.15 until the owner confirms commercial-use licensing/entitlement; do not change BLE/P1 semantics or create a second BLE client.
- After the foundation passes hosted validation, incrementally extract Dashboard/BLE state, Usage Statistics storage/analytics/UI and Settings/theme/localization boundaries; then refine Home, Connection, control tabs, Settings, Statistics, Floating Monitor, dialogs and Firmware Update presentation with behavioral and screenshot regressions.
- Owner-provided visual evidence is still required across 350-dp/420-dp, EN/ID, Light/Dark and connected/disconnected/error/constrained-height states. Build #167 remains the latest published package. Any implementation requires a new explicit Code Full command in its own chat; any package republish requires a separate fresh `Eksekusi Build App!` authorization. This proposal grants neither.

## Other boundaries

- PR validation workflow `.github/workflows/jexfyz-app-pr-validation.yml` is implemented; no open PR or PR-triggered run was observed in the 2026-11-24 recovery check.
- Last documented `main-safety-guard` API verification was 2026-11-18; current ruleset and classic branch protection were not re-queried in this recovery. Classic branch protection was previously API-UNVERIFIED.
- Firmware V7.2 source is not evidence of compilation or BIN provenance. Firmware/BIN, Firebase, OTA, flashing, BLE field behavior, thermal/electrical acceptance and physical-device operation remain outside this App Build and unverified.
- BLE App-only identity authentication remains BLOCKED / NOT IMPLEMENTED. Online OTA `cloudClient.setInsecure()` encrypts transport but does not authenticate server certificate identity; OTA remains protected absent a demonstrated defect and separate authorization.
- Detailed Build #167 evidence/checksums are in `APP_BUILD_REPORT.md`; current state is in `PROJECT_STATE.md`; bounded continuation context is in `CHAT_TRANSFER.md`.

