## 2026-10-04 — CHAT-LIMIT HANDOVER CHECKPOINT

- Current chat is being handed over because the context limit is near.
- README.md already contains the detailed copy-ready new-chat prompt and is the mandatory first-read entry point.
- HANDOVER.md is the portable handoff artifact; the embedded prompt remains the required continuation prompt.
- Current firmware remains V3.7; active source is `firmware/JEXFYZ-V3.7.ino`.
- Latest verified App Build remains #50; no App Build was triggered by this handover checkpoint.
- Firmware V3.7 ArduinoDroid/Core 3.3.7 compile, BIN publication, Firebase promotion, and physical validation remain unperformed.
- Next chat must perform the full repository memory preflight before any action.

## 2026-10-04 — EXECUTION FULL / MEMORY ARCHITECTURE CHECKPOINT

- Build-memory continuity is now part of the mandatory project preflight for every subchat.
- A successful App Build is a permanent checkpoint and must identify the exact source revision, run, artifacts, checksums, all included changes, gates, and remaining validation boundaries.
- No App Build was executed in this memory-architecture task.
- Latest verified build remains #50; newer repository commits are not covered by that build.

## 2026-10-04 — DUAL CHAT-LIMIT BUILD CONTINUITY

- Build App subchats now use the same two-stage continuity model.
- Prompt A can capture build-related chat-only facts when a Build App chat nears its limit.
- Prompt B must re-read all build memory, inspect current App source/workflow/trigger, reconcile the recap, and establish the exact intended source SHA before any build.
- Chat recap never substitutes for exact build evidence or repository/source verification.
- No App Build was triggered by this process change.
## 2026-10-04 — REPOSITORY-FIRST TRANSFER FILE

- CHAT_TRANSFER.md is the rolling repository transfer snapshot shared by ordinary and Build App subchats.
- Prompt 1 saves the old-chat context directly to the repository before handoff.
- Prompt 2 reads the saved transfer plus all build memory and current workflow before continuing.
- No Build App was triggered by this continuity implementation.

# JE X FYZ — BUILD NOTES

## AUTHORITATIVE BUILD CORE — 2026-10-04

### Build policy
- App Build is a separate workflow and may run in a separate subchat.
- A Build App subchat must begin with the complete memory preflight and current-source inspection.
- Normal push/PR activity must not generate the release APK.
- Expected trigger issue title: `JE X FYZ — BUILD APP TRIGGER`
- Required trigger token: `JEXFYZ_BUILD_TRIGGER_V1`
- Intended release output: one normal APK, not a Play Store bundle.
- Production signing identity remains unchanged.
- A successful build is a **memory checkpoint** and must record exact source, run, artifact, changes, gates, and remaining validation boundaries.

### Current build toolchain
- Java: 17
- Flutter: 3.47.2 stable
- Gradle: 9.3.1
- Runner: ubuntu-24.04
- Production certificate SHA256:
  `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`

---

## BUILD #50 — LATEST VERIFIED SUCCESS

### Identity
- Build number: **#50**
- GitHub Actions run: **36996987220**
- Source commit: `bf01595253eb5a1912471c4aee57c4eed4421f0f`
- Result: **SUCCESS**
- Physical/device test: **NOT performed**

### APK
- Artifact ID: `11222007634`
- Size: `54,245,456` bytes
- SHA256: `82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0`

### Symbols
- Artifact ID: `11222132522`
- Size: `8,308,848` bytes
- SHA256: `a87a3181bada92e229da3c1f79d9a59339d7669c11b32ac1d8c219ae435c9062`

### Validation gates
- Security audit: PASS
- Dependency checks: PASS
- Architecture/static analysis: PASS
- Tests: PASS
- Release packaging: PASS
- Signing/certificate verification: PASS

### Build continuity
Build #50 validates only source commit `bf01595253eb5a1912471c4aee57c4eed4421f0f`.

It does **not** validate:
- later App commits;
- later firmware source;
- current V3.7 runtime;
- physical hardware;
- Firebase state.

### Changes after Build #50
The repository subsequently received:
- Firmware V3.7 source/documentation changes;
- firmware analysis documentation;
- memory/continuity documentation changes;
- README/project-state/build-memory/handover system changes from this execution.

None of these later changes are included in Build #50.

---

## BUILD CHECKPOINT TEMPLATE

Every future successful build must append a new checkpoint containing:

### Identity
- Build number:
- Workflow/run ID:
- Source commit:
- Result:
- Date:

### Scope
- App source files changed since previous successful build:
- Android/config files changed:
- Workflow files changed:
- Dependency changes:
- Build-only troubleshooting changes:

### APK
- Artifact name:
- Artifact ID:
- Size:
- SHA256:

### Symbols
- Artifact name:
- Artifact ID:
- Size:
- SHA256:

### Validation
- Security:
- Dependency:
- Static/architecture analysis:
- Tests:
- Release:
- Signing:

### Remaining boundary
- What was not validated:
- Physical device:
- Firmware compile/BIN:
- Firebase:
- OTA runtime:

### Continuity
- What the next Build App subchat must read:
- Exact next build baseline:
- Known risks:

## 2026-10-04 — DISCUSSION / APP BUILD REQUIREMENT FOR HARDWARE TEST

- [CONFIRMED] A hardware test does not automatically require rebuilding the App.
- [VERIFIED] Build #50 remains the latest verified App artifact, and current App functional source/configuration has no post-Build-#50 functional delta requiring a new APK.
- [DECISION] The existing Build #50 APK is the appropriate App baseline for the initial V3.7 hardware/runtime test.
- A new App Build becomes necessary when App source/runtime/configuration/dependency/release behavior changes, or when a fresh artifact is explicitly needed for test control.
- [UNVERIFIED] This baseline does not prove V3.7 Firmware compatibility; firmware/device evidence must be recorded independently.
