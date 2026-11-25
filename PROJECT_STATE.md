# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-25 (Asia/Jakarta). Operating authority: `MASTER_PROMPT.md`.

## Three dedicated ChatGPT workspaces — current operating model

- The repository now defines three independent owner-created ChatGPT conversations: **Diskusi!**, **Eksekusi Code Full!**, and **Eksekusi Build App!**. Each has one copy-ready starter in `CHAT_TRANSFER_PROMPTS.md`; exactly three prompts are maintained.
- The owner must create/select the three chats manually. GitHub/repository prompts cannot open ChatGPT conversations. Chat transcripts are not shared automatically; the three chats share GitHub `main` and canonical memory.
- `MASTER_PROMPT.md` is the single authority. `Eksekusi Full!` is a backward-compatible alias for `Eksekusi Code Full!`. `Chat Stuck!` is recovery inside the existing workspace, not a fourth chat or permission expansion.
- Shared writes/builds are single-writer: do not commit or launch an external operation from multiple chats concurrently. `00_WORK_STATUS.md` now records `WORKSPACE` as `DISKUSI`, `CODE_FULL` or `BUILD_APP`; it is event-driven, not a lock.
- Most recent implementation session: `CODE_FULL` completed on 2026-11-24; the follow-up owner review is in the separate `DISKUSI` workspace. No App Build/Release was started.

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

## Whole-App modernization — Discussion proposal only — 2026-11-24

- Owner supplied one Build #167 Home screenshot (English / Light / disconnected). The screenshot was reviewed; the full visual acceptance matrix remains NOT VERIFIED. Findings and candidate UI refinements are recorded in `DESIGN_NOTES.md`.
- Current architecture baseline: `lib/main.dart` is approximately 11.4k lines and combines Dashboard, BLE/P1 lifecycle, command/telemetry and OTA coordination with presentation. `lib/usage_statistics.dart` is approximately 3.65k lines and combines models, SQLite, recorder/queue, analytics, UI and charts. Prefer incremental feature/service extraction, not a rewrite.
- Stable platform candidate (checked 2026-11-24): Flutter 3.50.1 / Dart 3.14.0 and Material UI 1.11.1 migration; Android AGP 9.5.2 / Gradle 9.9.2 with AGP built-in Kotlin, retaining JDK 17, compileSdk 37, targetSdk 36, minSdk 24 and Android versionName `Telegram @horizontalzzz` unless separately approved.
- Candidate direct package upgrades: firebase_core 5.2.0, firebase_app_check 0.5.2 and sqflite 2.4.6. flutter_blue_plus 2.3.15 is gated on confirming its current commercial-license terms/entitlement before any update. flutter_secure_storage 11.2.0, permission_handler 13.0.2, phosphor_icons 3.0.1, flutter_lints 6.0.0 and path 1.9.1 are already at the stable versions found in this review.
- No source, dependency manifest/lockfile, workflow, Android build configuration or release was changed by this Discussion. This modernization proposal is not an implementation authorization; each phase belongs in the separate Eksekusi Code Full workspace. Build #167 remains the latest published package.

## Whole-App UI / motion refinement — Discussion proposal — 2026-11-25

- Owner requested a full App UI refinement that avoids generic AI-slop patterns and feels smoother with purposeful animation. Current Diskusi review is read-only; no App source, tests, dependency, native code, configuration or release was changed.
- Static source baseline: `lib/main.dart` ~11,434 lines, `lib/floating_monitor.dart` ~1,959, `lib/app_settings.dart` ~1,904, `lib/usage_statistics.dart` ~3,650. `JexAnimatedIcon` allocates seven controllers even for static `.glyph` icons; connected Battery/Hotside/Voltage loops repeat without a reading change; LED preview rebuilds invariant row content on each animation tick; no explicit app-level reduced-motion handling or dedicated tab content transition was found.
- Full visual/motion proposal and screen-by-screen sequence are recorded in `DESIGN_NOTES.md`. Direction: precision JE Cooler hardware interface; preserve approved identity/Home/canvas/telemetry and hardware-correlated Fan/LED motion; unify shared visual/motion tokens; add short meaningful tab/route/control feedback; honor Android/iOS reduced-motion; optimize animated subtree/controller allocation; never synthesize telemetry or progress.
- Implementation is not started. A bounded implementation must be authorized in the separate Eksekusi Code Full conversation. No extra animation plugin is recommended; use Flutter framework animation primitives already available. Build #167 remains latest package and any new package requires separate Eksekusi Build App authorization.

## Plugin / engineering tools audit — 2026-11-25

- **Already connected:** GitHub and Figma. No duplicate connector is needed. Figma-specific design/motion/library skills and the JE repository engineering skills are already available.
- **Context7 connected (2026-11-25):** Context7's library resolver and documentation query tools are available. Flutter's `MediaQuery.disableAnimationsOf(context)` exposes the platform accessibility preference. `AnimationController.new` defaults to `AnimationBehavior.normal`, which reduces duration when animations are disabled; `AnimationController.unbounded` defaults to `AnimationBehavior.preserve`, which Flutter says helps avoid rapid flashing for repeating animations when a widget does not handle the preference. The App should explicitly stop/replace nonessential infinite loops with a stable visual state; do not merely shorten their duration. Use Context7 for version-specific upstream docs and verify behavior against live project source/tests.
- **Do not install more ChatGPT plugins for now:** PostHog/Datadog need actual product analytics/observability instrumentation and privacy/operations policy; Firebase connector has broad backend access near protected OTA state; Atlassian duplicates GitHub workflow; Product Design overlaps Figma and existing design skills. A targeted catalog query did not surface Sentry.
- **High-value developer workstation setup:** Android Studio + Android SDK/Platform Tools/ADB + AVD emulator + Flutter stable SDK/DevTools, plus a physical Android phone and actual JE Cooler unit. These are local tools, not ChatGPT plugins. The current ChatGPT execution container lacks Flutter/Dart/Gradle/ADB.
- **QA strategy:** existing Flutter unit/widget/hosted CI plus `integration_test` on emulator/physical Android; consider Patrol only for native Android permission/system UI flows. Use Flutter DevTools profile-mode frame/build/raster and CPU/memory evidence plus Android Studio Profiler. Actual BLE/P1, OEM notification/overlay and hardware behavior require physical-device evidence.
- GitHub, Figma and Context7 are confirmed connected. Full catalog status, Figma/repository skill inventory, QA workstation stack and official tooling references are recorded in `SKILLS_INDEX.md`. No additional ChatGPT connector is recommended for the current scope.


## Remaining quality gates — assessment 2026-11-25

- **Visual:** overall acceptance remains VISUAL NOT VERIFIED. One Home / EN / Light / disconnected screenshot is not the required 350/420-dp, EN/ID, Light/Dark, connected/disconnected/error, constrained-height and accessibility matrix.
- **Automated QA:** current tree has no Flutter `integration_test/` or checked-in golden/screenshot regression suite. Build #167 native Android JUnit was NO-SOURCE. PR validation exists but has not been exercised by a real PR; no open PR was found in this review.
- **Developer/device QA:** prioritize Android Studio, Android SDK/ADB, AVD, Flutter SDK/DevTools, a physical Android phone and the JE Cooler unit. Add real-device BLE/P1, notification, permission and native Floating Monitor evidence; use profile-mode performance measurements.
- **Performance:** Usage Statistics 1h/6h/24h CPU, memory and storage soak remains unverified; measure before changing architecture or queue behavior.
- **Governance:** add/enable reviewed PR and controlled Dependabot only after the read-only PR workflow is observed in a normal PR. Restore a checksum-verified Gradle Wrapper as part of the separately reviewed Android toolchain migration.
- BLE App-only identity and OTA server identity remain separate high-priority security projects; not part of UI/toolchain scope.


## CODE_FULL source checkpoint — 2026-11-26

- **Implemented:** the 12 static `JexAnimatedIcon.glyph` call sites were migrated to `JexAnimatedGlyph`; the old stateful static-glyph constructor/field/build branch was removed. A widget regression protects IconData/color/size and source routing. The unused local exposed by the first hosted analyzer run was removed.
- **Verified:** Validation Only #58 / run `45660178142` on source `edf9a62cac12339e445dbb1fe86dbb0fc46ef3a9` terminal SUCCESS — formatter clean (19 files / 0 changed), analyzer 107 info-only / zero warnings-errors, Flutter tests 213/213. Validation Only #57 remains a terminal intermediate failure and is documented in the audit/changelog.
- **Not released:** Build #167 remains the latest published APK; Release `jexfyz-latest` / ID `403010611` remains pinned to package source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`. This Code Full source commit did not build or publish an APK.
- **Remaining WP1 work:** implement platform reduced-motion behavior for nonessential repeats; replace unchanged Battery/Hotside/Voltage idle loops with meaningful feedback; isolate invariant LED preview content without altering Firmware phase sync; repair disconnected Notification semantics/direct Connect through existing BLE ownership. Preserve all P1/safety/telemetry contracts. See `APP_PREBUILD_AUDIT.md` and `DESIGN_NOTES.md`.
- Existing QA gaps remain: no `integration_test/` or golden suite, Android App JUnit remains NO-SOURCE in Build #167, no checked-in Gradle Wrapper or Dependabot configuration, and no observed PR validation run. Device/performance/whole-App visual acceptance is still unverified.

## Current repository evidence and next action

- Build #167 package source SHA is immutable. After that checkout, current `main` contains canonical documentation updates, one non-functional Firmware opening-comment correction in `firmware/JEXFYZ-V7.2.ino` (V7.1 text → V7.2), the guarded Build App workflow security hardening and its static source-contract test. No executable App/Firmware runtime code or Firmware behavior changed; the current workflow/test hardening is not included in the Build #167 package.
- Recursive `main` tree at the post-hardening documentation checkpoint: 141 entries / 95 blobs / 46 trees; `truncated=false`. The final HEAD and recursive tree are re-verified after the closing status write.
- **Immediate next acceptance:** obtain actual Build #167 Android screenshots for the Home cooler matrix above. Do not trigger another build merely to repeat successful CI. A source repair requires separate explicit `Eksekusi Code Full!` (legacy alias `Eksekusi Full!`); repackaging requires fresh explicit `Eksekusi Build App!`.
- `APP_BUILD_REPORT.md` holds build history; `CHAT_TRANSFER.md` is the bounded continuation checkpoint; `HANDOVER.md` holds the immediate next step. Subject requirements remain in `APP_NOTES.md`, `DESIGN_NOTES.md`, `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md`.
