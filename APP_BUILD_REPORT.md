# JE X FYZ / JE Cooler — App Build Report

This is the durable evidence ledger for `@Thinking #Build App!`. A replacement Build App chat uses Prompt D in `CHAT_TRANSFER_PROMPTS.md` to load this file and continue the same workstream across a context limit; there is no separate Build App recap chat. Discussion can consult this ledger for evidence. It records only evidence actually present in GitHub Actions/Release outputs; a build, analysis, APK signature, release publication and physical-device verification are distinct gates.

## Current report status

- **Latest recorded successful build:** Build #35, workflow run [38669526891](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38669526891).
- **Code commit built:** `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`.
- **Result:** SUCCESS for the App CI/build/release gates listed below.
- **Built and downloaded asset:** one `JEXFYZ-release.apk`, 54,521,947 bytes.
- **SHA-256:** `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`.
- **Signature verification:** V1, V2 and V3 passed for both built APK and re-downloaded Release asset. Expected production certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` matched.
- **Analysis/tests:** Dart analyze passed; all 74 Flutter tests passed.
- **Other gates:** security/architecture audit, dependency resolution, APK build, publication to `jexfyz-latest`, re-download and asset verification passed.
- **Known warning:** JAR/V1 output states certain dependency `META-INF` entries, including `META-INF/services/a1` and `META-INF/services/b1`, are not protected by the JAR/V1 signature. Record this warning separately from the passing APK signature-scheme checks; do not suppress it.
- **Not verified by CI:** physical installation/rendering, MT Manager's displayed signature interpretation, BLE connection or cooling/safety behavior, Firmware compilation, OTA/flash and installed Firmware version.
- **Firmware boundary:** Firmware V6.6 is user-accepted as final. No Firmware compile, BIN change, Firebase edit, physical OTA/flash or hardware operation was performed by Build #35.

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
