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
