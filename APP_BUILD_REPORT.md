# JE X FYZ / JE Cooler — App Build Report

This is the durable evidence ledger for `@Thinking #Build App!`. A replacement Build App chat uses Prompt D in `CHAT_TRANSFER_PROMPTS.md` to load this file and continue the same workstream across a context limit; there is no separate Build App recap chat. Discussion can consult this ledger for evidence. It records only evidence actually present in GitHub Actions/Release outputs; a build, analysis, APK signature, release publication and physical-device verification are distinct gates.

## Current report status

### Current source updates beyond last successful build — NOT BUILT / TESTS NOT RUN

- **Status:** Source and source-contract assertions are committed; Android/Dart analysis, Flutter tests, APK build, signing and release checks have NOT RUN for these changes. No App Build workflow was triggered by `@Thinking #Eksekusi Full!` or the recovery command.
- **Repository checkpoint before this report update:** `main` HEAD `846fbad83c0aaeb8b587fb2480fd53b5620059f5`. This checkpoint includes the Color Picker and Floating Monitor code, tests and protocol/memory documentation. The update to this file and the subsequent `CHAT_TRANSFER.md` refresh are documentation only.
- **Current source fingerprints:** `lib/main.dart` `c697497e16c94b8fe4fe8fd9bd1f9bc93598545f`; `lib/floating_monitor.dart` `af7bad48579f6c998761120e4f8233564fa06e6f`; `lib/app_settings.dart` `6483031e239d71e0a0784c529e2f45a94fb5404b`; `test/widget_test.dart` `2a87292d5c4bc468ee6aad6810b249d284a28bae`; `FloatingMonitorService.kt` `90e2f10f91fc60c64843e14f556b720fbc9f7030`; `MainActivity.kt` `12004b5b36b8339f7440e54f9a7330e5804e57ef`; `AndroidManifest.xml` `bcf9b3e96b254dd6577035a6643b6935f7320085`.
- **Color Picker:** The 36 swatches stage a local draft; localized Select sends the confirmed `COLOR` command and closes only after success. Cancel discards the draft; outside taps and system Back cannot close the dialog.
- **Floating Monitor UI/telemetry:** The settings-center live preview has been removed and replaced by explicit Horizontal/Vertical selection. Latest authoritative telemetry is replayed after native overlay startup to avoid the lost-initial-snapshot case; native HUD requests layout and redraw when live values change. BLE-disconnected physical state remains `--`.
- **Foreground FPS:** Flutter's own `FrameTiming` counter was removed. Native FPS uses SurfaceFlinger TimeStats deltas and filters layers to Android's resumed/focused package, with approximately one-second sampling. The user must manually grant Android's development-only `android.permission.DUMP` with trusted ADB; this is broad system-dump access, is not self-granted, and may be denied by an OEM ROM. No Shizuku fallback is included. FPS accuracy, permission grant, game-layer naming, service survival and overlay behavior are UNVERIFIED on a physical device.
- **Recovery protocol:** `@Thinking Chat Stuck!` is a standalone recovery command. It stops blind retries, fetches current logs/state and resumes only the most recent valid authorization from its verified checkpoint; it does not independently trigger App Build or authorize Firmware/device operations.
- **Regression assertions:** `test/widget_test.dart` now contains checks for Color Picker staging, preview removal/orientation controls, ADB grant/revoke wiring, foreground SurfaceFlinger FPS source, telemetry replay and disconnected-state presentation. These tests exist in source only; they were not executed. Flutter/Dart are absent from this execution environment. A Kotlin regex smoke-check verified example foreground-package strings, but this is not an Android/Kotlin build or on-device FPS verification.
- **Next authorized build:** run the complete official workflow only after explicit `@Thinking #Build App!`, then inspect build logs, Dart analysis, all tests, APK signatures, production certificate, Release asset and re-downloaded asset, and append evidence below. Do not call the new code successful based on the old APK.

### Last verified successful App Build (historical code)

- **Run:** Build #35 / [workflow run `38669526891`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38669526891).
- **Code commit built:** `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`. It predates the Color Picker and Floating Monitor changes above.
- **Result for that commit:** security/architecture audit, dependency resolution, Dart analyze, all 74 Flutter tests, APK compile, V1/V2/V3 signature checks, GitHub Release publication and re-downloaded asset verification passed.
- **Asset:** one `JEXFYZ-release.apk`, 54,521,947 bytes. SHA-256: `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`.
- **Certificate:** production certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched. JAR/V1 warns that certain dependency `META-INF` entries (including `META-INF/services/a1` and `META-INF/services/b1`) are not protected by JAR/V1; that warning is separate from the successful APK V1/V2/V3 checks.
- **Not verified by CI:** physical installation/rendering, live game FPS, the ADB DUMP grant on the target ROM, MT Manager's signature interpretation, BLE/cooler operation, Firmware compilation, OTA/flash and installed Firmware version. Firmware V6.6 is user-accepted as final; this task did not change/compile Firmware, BIN, Firebase, OTA or hardware.

## Required fields for every future attempt

Add a new dated section at the top of the attempt history (do not overwrite prior failed attempts). Include:

1. Status: `RUNNING`, `FAILED`, `BLOCKED` or `SUCCESS`.
2. Trigger issue number/URL and exact trigger title/token validation; do not expose secrets or signing credentials.
3. Source: exact `main` source commit SHA, workflow path and workflow run ID/URL.
4. Failure details for every failed attempt: job/step, concise log evidence, whether analysis/tests were reached, cause only when supported, fix commit and changed files.
5. Validation outcomes: security/architecture audit, dependency installation, Dart analyze, Flutter test count and pass/fail totals, APK build, package/file count, V1/V2/V3 and certificate result.
6. Artifact evidence: Release tag, asset name/ID if available, size, SHA-256, and re-downloaded asset identity/hash comparison.
7. Remaining warnings and validation gaps; distinguish CI from physical-device evidence.
8. Final disposition and next exact action. Only mark `SUCCESS` if all required App Build gates pass; use `BLOCKED` if further progress needs missing permission/secret, external service recovery or separate authorization.

## Attempt history

### HISTORICAL — 2026-10-15 — Prompt D LOAD + CONTINUE verification — SUCCESS (existing Build #35; pre-Color-Picker edit)

- **Disposition:** SUCCESS for the authorized App Build/CI/release gates. The existing intended build had already completed every mandatory gate, so this continuation verified the live evidence and did not create a duplicate workflow run.
- **Historical repository checkpoint at start of that continuation:** `TenzoNkz/JEXFYZ-App`, branch `main`, HEAD `f300cb3709f5b38510a2fe841a712b653d0d5856` (`docs: finalize Build App chat-limit handoff`), root tree `88831c03d259b4ff88309faf344edfd3fa3fa218`; recursive tree returned without truncation (66 entries, 48 blobs). At that historical checkpoint, `lib/main.dart` = `f4ee1e9b9e74f103e0f362db813dea642f285470` and `test/widget_test.dart` = `4b7bf68f3c73d6ffe80509ccb75ce6e08607b020`; those hashes are not current.
- **Diff vs Build #35 at that historical checkpoint:** comparison to then-current HEAD showed documentation-only differences and no source/test/workflow/package/signing/dependency changes. Subsequent Color Picker commits are newer than this historical comparison; do not reuse its old conclusion for current main.
- **Trigger evidence:** the live workflow remains `.github/workflows/jexfyz-app-build-trigger.yml` and still uses issue opened/reopened only, with owner check, exact title `JE X FYZ — BUILD APP TRIGGER`, and body token `JEXFYZ_BUILD_TRIGGER_V1`. Build #35 was triggered by reopening [issue #13](https://github.com/TenzoNkz/JEXFYZ-App/issues/13): issue author/owner `TenzoNkz`, exact title and token matched, last `reopened` event at `2026-10-15T02:09:44Z`, run created at `2026-10-15T02:09:46Z`. No new trigger was created during this continuation.
- **Latest run:** Build #35, run [38669526891](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38669526891), event `issues`, branch `main`, built source commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`, completed `success` at `2026-10-15T02:17:16Z`. All pipeline steps through Release re-download verification passed: security/architecture audit, dependency resolution, Dart analysis, Flutter tests, obfuscated release APK build, signing enforcement, production-certificate verification, Release publication, and re-downloaded asset verification.
- **Tests:** all **74 Flutter tests passed**. Dart analysis step passed. Build #34 history remains preserved below: analysis passed, tests stopped at 73 passed / 1 failed because the Fan Speed retargeting midpoint expected `0.5` but returned `0.510125`; APK/build/signing/release steps were skipped. The justified fix in `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8` uses symmetric cubic smoothstep and Build #35 then passed.
- **APK/signing:** exactly one intended delivery APK, `JEXFYZ-release.apk`, **54,521,947 bytes** (workflow build output ~54.5 MB). Built APK and downloaded release asset both passed V1/JAR, V2 and V3 verification, with one signer and production certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- **Release/asset identity:** [Release `jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest), targeting commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`, contains exactly one asset: ID `642373319`, `JEXFYZ-release.apk`, 54,521,947 bytes, GitHub Release API digest `sha256:77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. The workflow downloaded that exact published asset, compared it byte-for-byte by SHA-256 to the signed build APK, rechecked V1/V2/V3 and the certificate, and logged the same SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`.
- **Warnings:** JAR/V1 verification reports multiple dependency/metadata entries not protected for the JarInputStream interpretation, including `META-INF/services/a1` and `META-INF/services/b1`; this warning remains visible and is distinct from the explicitly passing V1/V2/V3 APK scheme checks. Dependency resolution also reports four packages with newer versions incompatible with current constraints; resolution itself passed, and no dependency change was justified for this continuation.
- **Live release/run state:** no Actions run is in progress; current Release metadata still points at Build #35 and contains the one expected APK. Live branch check returned five branches; current pull-request query returned zero open PRs.
- **Not verified by CI / remaining checks:** physical-device installation/rendering, MT Manager's displayed signature interpretation, BLE/cooling/safety behavior, Firmware compilation, OTA/flash, and installed Firmware version remain outside this App Build success claim.
- **Result:** the existing built App source and its exact published Release asset have verified CI evidence; no functional App repair or rerun was needed for the documentation-only commits after Build #35.

### 2026-10-15 — Build #35 — SUCCESS (last verified prior repository checkpoint)

- Workflow run: [38669526891](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38669526891).
- Built commit: `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`.
- The build included symmetric cubic smoothstep in `jexSmoothFanSpeedLevel`, fixing the exact midpoint expected by the regression contract. Build #34 stopped before APK compilation because one test failed: 73 passed, 1 failed; the previous curve returned 0.510125 at progress 0.5 where the contract expected 0.5.
- Run #35: security/architecture audit, dependency resolution, Dart analyze, all 74 Flutter tests, APK compilation, Release publication, APK V1/V2/V3 checks and re-downloaded asset verification passed.
- Asset: `JEXFYZ-release.apk`, 54,521,947 bytes, SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`; production certificate SHA-256 matched `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`.
- Warning: JAR/V1 reports unprotected dependency META-INF entries including `services/a1` and `services/b1`. The independent V1/V2/V3 APK verification gates passed.
- Not performed: physical install/rendering or MT Manager verification, Firmware compile, BIN change, Firebase edit, OTA/flash or hardware validation.
- Current disposition: **CI/build/release gates passed; physical-device rendering and MT Manager verification remain unverified.**

## Cross-chat usage

- Build App chat owns run execution and appends each attempt here.
- When a Build App chat reaches context limit, the replacement Build App chat starts with Prompt D once. Prompt D loads this ledger + live workflow/run state and continues execution; do not create a separate recap chat or run Prompt A for this handoff.
- Discussion chat must read this file before recommending what to fix, claiming current build state, or asking for another build.
- `PROJECT_STATE.md` and `HANDOVER.md` should keep only latest concise status and point here for attempt-by-attempt details.
- Never edit successful history to hide failures. Record retries/fixes as new entries.
