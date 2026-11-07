---
name: ota-and-release-integrity
description: Use for protected OTA lifecycle analysis or App release provenance, artifact checksums, APK signing, source archive parity, tag/release verification, and guarded production release review.
---

# OTA and Release Integrity

## Objective
Keep two separate release domains safe: App APK publication and Firmware OTA transport/application.

## App release procedure
1. Require explicit Eksekusi Build App! before a release attempt. Eksekusi Full and Diskusi never imply release permission.
2. Read BUILD_NOTES.md, APP_BUILD_REPORT.md and the full live guarded workflow. Verify exact issue title/body-token guard, no push/PR release trigger and all current security/test/analyzer gates.
3. Fetch live main HEAD and current Actions runs/jobs/logs before triggering. Never duplicate an active or completed intended run.
4. Match the run head SHA to the intended source commit. Record run ID, job IDs, actual gates and failures.
5. Require exactly the intended obfuscated APK and corresponding source ZIP; verify source marker, archive integrity, APK V1/V2/V3 signing, expected production certificate, Release/tag parity and freshly downloaded asset digest/size/identity.
6. Record CI warnings, skipped gates and physical-field evidence gaps. An App CI pass is not Firmware compile/BIN/OTA/device proof.

## OTA change procedure
1. Require a demonstrated defect and explicit OTA-specific owner authorization.
2. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md completely, plus full live related App/Firmware source and tests.
3. Preserve established command order, expected-disconnect/recovery state, ambiguous TIMEOUT/DISCONNECTED ACK behavior, normal P1 sync after reconnect, URL allowlist, redirect blocking, response/length/size/image checks, safe-output order and restart/failure recovery.
4. Treat `cloudClient.setInsecure()` as a known security trade-off: HTTPS transport encryption does not authenticate server certificate identity. Do not describe it as certificate-verified.
5. Do not add Firebase hash/signature semantics or alter TLS/NTP/CA behavior without explicit approval and a controlled one-variable experiment.
6. Keep source review, tests, compile, BIN provenance, physical OTA apply, restart, BLE recovery and installed-version verification as separate evidence gates.

## Guardrails
Do not initiate App Build from this skill alone. Do not compile/publish Firmware, alter Firebase, OTA or flash hardware unless separately and explicitly authorized. Never weaken a release gate to obtain a green run.
