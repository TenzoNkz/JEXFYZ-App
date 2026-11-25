# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-25 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

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

## Immediate next action — whole-App UI and motion refinement (PROPOSED, NOT IMPLEMENTED)

- Continue in the separate **Eksekusi Code Full!** conversation with a fresh explicit owner command. The current Diskusi remains read-only. Do not combine this UI task with the separate Flutter/Material UI/Android toolchain and Firebase/SQLite upgrade roadmap.
- **Stage 1 — motion foundation and high-value Home fixes:** create one shared, documented JE motion spec/theme layer; explicitly honor Android `disableAnimations` and iOS `reduceMotion`; make static `.glyph` icons avoid animated-controller allocation; make animated icon controllers lazy/only allocate what each icon kind needs; replace perpetual Battery/Hotside/Voltage loops with change/warning feedback; preserve telemetry-driven Fan coast and Firmware-phase LED motion; use `AnimatedBuilder.child` for static LED preview content; add a short keyed tab-content transition; correct the disconnected Notification success-like tint and add a direct Connect action to the disconnected lock panel through the existing Bluetooth flow.
- **Stage 2 — controls, Connection and Settings:** unify control pending/confirmed/disabled/locked/pressed styles; add restrained transitions to Voltage/Control/Adaptive/LED/Temperature tabs; refine scan/discovery/connection/sync/failure feedback; align Settings sections and subpage navigation with the Home identity. Preserve all BLE P1 gates, command/ACK/telemetry distinctions, passive Auto Connect, persisted keys, EN/ID and 360-dp scaling contracts.
- **Stage 3 — Statistics, Floating Monitor, dialogs and Firmware Update presentation:** optimize chart animation/build scopes without changing historical data, raw 1-Hz collection, null gaps, session boundaries, SQLite schema/retention or time mapping; treat native Floating Monitor as a native Canvas/WindowManager surface; apply the same motion language to dialogs/sheets; show only actual Firmware update stages/progress. Do not alter OTA transport/security, metadata, recovery or Firmware behavior.
- Do not add an animation plugin solely for these effects; Flutter SDK primitives already provide implicit and explicit animations. Hold broad dependency/toolchain upgrades for their separately validated project.
- **Acceptance:** widget/behavior tests for reduced motion, controller disposal, state transitions, command pending vs telemetry confirmed, disconnected/unknown state, tab switching and lifecycle; screenshot/golden matrix at 350-dp/420-dp, English/Indonesian, Light/Dark, connected/disconnected/error and constrained portrait; actual Build #167 screenshot comparison plus real Android rendering after a separately authorized package. No visual PASS without rendered evidence.
- Build #167 remains the latest published package. A fresh Code Full command authorizes only the named App source/tests/docs work; a new APK/build/release still requires a separate fresh `Eksekusi Build App!` authorization. BLE App identity and OTA certificate trust remain separate protected projects.

## Tooling readiness before the next grouped execution batch — 2026-11-25

- GitHub, Figma and Context7 are now confirmed connected; no duplicate integration is needed. Context7 `resolve_library_id` and `query_docs` are available for version-aware Flutter/Dart/Material UI/Gradle/Firebase documentation. First live Flutter API lookup verified `MediaQuery.disableAnimationsOf(context)`, `AnimationController.new` defaulting to `AnimationBehavior.normal`, and `AnimationController.unbounded` defaulting to `AnimationBehavior.preserve`. Flutter notes `preserve` helps prevent repeating animations from flashing rapidly when the widget ignores `disableAnimations`; explicitly stop/replace nonessential infinite loops with stable visuals instead of merely shortening their duration.
- Skip PostHog, Datadog, Firebase, Atlassian and Product Design ChatGPT connectors for now; the first two require an observability/privacy plan, Firebase has broad backend access near protected OTA state, Atlassian duplicates GitHub and Product Design overlaps Figma.
- Prepare the developer workstation with Android Studio, SDK/Platform Tools (`adb`), AVD emulator, Flutter stable SDK/DevTools and a physical Android phone + JE Cooler hardware. Use Flutter `integration_test` for app flows and consider Patrol only when native permission/system UI interaction is required. Profile with Flutter DevTools (profile mode) and Android Studio Profiler.
- Existing JE repository skills already cover Flutter engineering, product design/anti-AI-slop, Flutter test/regression, BLE P1, Firmware safety, OTA/release integrity, GitHub Actions and documentation governance. Prefer extending these; only add focused Android visual/device-QA or dependency-upgrade-matrix skills when those workflows are formally adopted. Details and sources are in `SKILLS_INDEX.md`.


## Remaining quality gates — Diskusi assessment — 2026-11-25

- Current tree has no `integration_test/`, golden/screenshot regression suite, checked-in Gradle Wrapper or Dependabot configuration. The read-only PR validator is implemented but still has no observed PR run; exercise it through a normal reviewable PR before making branch checks mandatory.
- Build #167 and Validation Only #56 succeeded, but visual acceptance remains NOT VERIFIED. Only one Home / EN / Light / disconnected screenshot was reviewed; capture actual installed-app evidence at 350/420 dp, EN/ID, Light/Dark, connected/disconnected/error, constrained portrait, accessibility text scale and reduced-motion states. Cover Home, each control tab, Connection, Settings, Usage Statistics, native Floating Monitor, dialogs and Firmware Update presentation.
- Next quality investments: Flutter `integration_test` for real app flows; goldens for stable Flutter widgets/screens; Patrol only if native Android permission/system UI needs automation; profile-mode DevTools and Android Studio Profiler; 1h/6h/24h Usage Statistics soak. Native overlay/BLE/P1 requires physical Android and cooler hardware.
- Keep architecture work incremental; profile long-session Statistics before optimizing. Keep BLE App identity and OTA certificate/server trust as separate protected projects. Do not combine either with visual or toolchain migration.
- No extra ChatGPT connector or animation dependency is recommended. GitHub, Figma and Context7 are sufficient; owner workstation/device tooling remains the main practical gap.


## Grouped execution readiness — clarified source targets — 2026-11-25

- The execution plan is now recorded in `APP_PREBUILD_AUDIT.md` (WP0–WP7). Read it before source work. `DESIGN_NOTES.md` contains the animation/Statistics source clarification.
- Direct source check confirms `JexAnimatedIcon.glyph` has 12 `main.dart` call sites and still constructs the stateful icon's seven controllers in `initState` before returning a static Icon in `build`. The separate `JexAnimatedGlyph` is stateless. Optimize the actual static constructor/call sites and add lifecycle regression evidence; do not treat source allocation alone as measured jank.
- `JexLedStripPreview` rebuilds its Row and invariant mode/arrows inside the per-frame AnimatedBuilder. Profile/optimize by isolating animated paint while preserving LED phase anchor/sync.
- Usage Statistics merges live session events then re-summarizes the selected snapshot during diagram flush. Profile 1h/6h/24h first; preserve raw 1-Hz data, schema v2/migration, 30-day retention, explicit gaps, HOT freshness and bounded 64+8+1 queue.
- Repository currently has 11 test Dart files plus helper, no `integration_test/`, no golden suite, no native Android test source, no checked-in Gradle Wrapper and no Dependabot config. PR validation is implemented but has no observed PR run.
- Execution remains **deferred**, consistent with the owner's earlier instruction to group the work with other pending tasks. No source/test/dep/config/workflow/build/release/Firmware/Firebase/OTA/device action was performed in this Diskusi.


## Recovery disposition — 2026-11-25

- A `Chat Stuck!` recovery in Diskusi found no unfinished work or active external operation. The prior grouped execution plan had already been closed and read back; recent GitHub Actions runs were all terminal. No operation was repeated.
- Continue to defer WP0–WP7 until a fresh explicit command in the separate `Eksekusi Code Full!` chat. Keep Build App/release authority separate.

## Other boundaries

- PR validation workflow `.github/workflows/jexfyz-app-pr-validation.yml` is implemented; no open PR or PR-triggered run was observed in the 2026-11-24 recovery check.
- Last documented `main-safety-guard` API verification was 2026-11-18; current ruleset and classic branch protection were not re-queried in this recovery. Classic branch protection was previously API-UNVERIFIED.
- Firmware V7.2 source is not evidence of compilation or BIN provenance. Firmware/BIN, Firebase, OTA, flashing, BLE field behavior, thermal/electrical acceptance and physical-device operation remain outside this App Build and unverified.
- BLE App-only identity authentication remains BLOCKED / NOT IMPLEMENTED. Online OTA `cloudClient.setInsecure()` encrypts transport but does not authenticate server certificate identity; OTA remains protected absent a demonstrated defect and separate authorization.
- Detailed Build #167 evidence/checksums are in `APP_BUILD_REPORT.md`; current state is in `PROJECT_STATE.md`; bounded continuation context is in `CHAT_TRANSFER.md`.

