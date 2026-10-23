# JE X FYZ / JE Cooler — Documentation Index and Retention Policy

Last reconciled: 2026-10-23 (Asia/Jakarta). This index defines which document is authoritative for each topic and why each Markdown record is retained. Always verify implementation facts against live main/source, tests, Actions and Release data.

## Current production checkpoint

- **Field baseline reported by the owner:** the sold/shipped unit uses Android App Build #124 and Firmware V7.1, reportedly compiled and installed through Online OTA. Firmware compile/OTA and physical-unit state remain USER-REPORTED; Build #128 has not been independently observed installed on that unit.
- **Latest independently verified App release:** [Build #128 / Actions run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), exact package source `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. Release ID `403010611`; live Release metadata and `refs/tags/jexfyz-latest` target the same source.
- **APK:** asset ID `668133495`, 54,751,323 bytes, SHA-256 `2f5fdf4ffab0eccac3db886855b34f8c2c6c83afb54d7088fd2f8b578d322c5b`. **Corresponding source ZIP:** asset ID `668133492`, 2,877,957 bytes, SHA-256 `9b740671f7e8d3b9d4cfc1b1e5f3200af905ba207d4a6c8a6b27114f39ec32f4`.
- Build #128 passed all 21 workflow gates, 121 Flutter tests, analyzer (25 informational diagnostics), configured Android Gradle gate, APK V1/V2/V3 signing and expected certificate verification, matching source archive, exact tag/release parity and downloaded asset checksum/source-marker/signature checks. Native Android JUnit tasks were NO-SOURCE.
- The App/UI implementation that was source-only after Build #124 (Settings scaling, Device/Perangkat terminology, BLE-gated Floating Monitor and language-synchronized Android notifications) is now included in Build #128 and has CI validation. App CI does not prove physical-device behavior or Firmware/OTA/BIN identity.
- Resolved design alignment (2026-10-23): the owner confirmed the Home notice heading follows the selected App language — `Notification` in English and `Notifikasi` in Indonesian. `APP_NOTES.md` and `DESIGN_NOTES.md` now agree with the localization contract. This is a documentation/design decision only; no new runtime validation or release is implied.

## Recovery protocol

1. Read CHAT_TRANSFER.md fully.
2. Fetch live main HEAD, recursive tree and commit metadata.
3. Read CHAT_RULES.md, this index, PROJECT_STATE.md, HANDOVER.md, and the entire canonical note relevant to the current task.
4. Paste Prompt 1 from CHAT_TRANSFER_PROMPTS.md as one complete message; its first line is Diskusi! by default. For a specifically authorized Eksekusi Full task or recovery of an already-authorized interrupted operation, replace only its first line with Eksekusi Full! or Chat Stuck!, respectively. The prompt uses these short command names without @Thinking.
5. Prompt 2 starts with Eksekusi Build App!; use it only for the guarded Build App/QC operation. Do not add a duplicate command line above either copied block.
6. Continue the prior workstream directly; no recap-only chat. GitHub is not an automatic transcript store: only committed and verified document changes are durable memory. Save after each durable decision, important finding, logical milestone, test result, and blockage. Before ending any substantive project chat, review messages since the last checkpoint and save new durable details; if nothing changed, retain the existing checkpoint instead of creating an empty commit. At the end of each substantive Discussion/Eksekusi Full task, update CHAT_TRANSFER.md and the relevant active notes before reporting completion. During Build App, update APP_BUILD_REPORT.md as each real attempt/milestone happens and refresh CHAT_TRANSFER.md with live run status.
7. Before a likely context limit, save the current authorized mode/scope, last verified milestone, remaining work, current run/job state, evidence, blockers and next action. If the chat stops before a commit is verified, recover only from the latest saved checkpoint/live evidence; never claim uncommitted content was saved or infer missing decisions.

## Canonical authority map

| File | Role | Retention decision |
|---|---|---|
| README.md | Project entry page, safe scope and direct navigation | KEEP; short entrypoint, not a second project-state ledger |
| CHAT_RULES.md | Durable commands, authorization and safety workflow | KEEP; rules only, no duplicated current release fingerprints |
| CHAT_TRANSFER.md | Rolling checkpoint for the next chat | KEEP; concise, updated at each durable checkpoint |
| CHAT_TRANSFER_PROMPTS.md | The two current LOAD + CONTINUE templates | KEEP; exactly two prompts, retire A/B/C/D taxonomy |
| MEMORY_INDEX.md | This map and retention policy | KEEP; authoritative documentation navigation |
| PROJECT_STATE.md | Current-only product/source/validation status | KEEP; remove historical build-by-build narratives |
| HANDOVER.md | Short next-step handoff | KEEP; point to checkpoint and current blocker/task |
| APP_NOTES.md | Canonical App/BLE/UI/telemetry/language contract | KEEP; current contract only, old build snapshots belong in logs |
| DESIGN_NOTES.md | Approved visual assets/layout/animation rules | KEEP; approved design only, dated validation history belongs elsewhere |
| FIRMWARE_NOTES.md | Hardware, safety, operating contracts and durable reports | KEEP; current V7.1 facts plus material unresolved requirements |
| firmware/FIRMWARE_TECHNICAL_REFERENCE.md | Low-level live Firmware architecture/invariants | KEEP; live version facts at top, historical algorithm versions in changelog |
| OTA_PROTECTION.md | Frozen OTA contract and pre-change gates | KEEP; live-safe current baseline, no stale release claims |
| OTA_REGRESSION_MEMORY.md | Root-cause evidence, past attempt and security trade-off | KEEP; preserve the failed CA/NTP attempt and evidence limitation |
| VOLTAGE_TRANSITION_MEMORY.md | Two separate reset reports and rail/Peltier transition contract | KEEP; preserve hypotheses separately from confirmed cause |
| BLE_APP_AUTH.md | Unimplemented App-only identity/authentication design and blocker | KEEP; do not imply security feature is implemented |
| BUILD_NOTES.md | Current release procedure/gates | KEEP; build-by-build attempt evidence moves nowhere and remains in report |
| APP_BUILD_REPORT.md | Authoritative append-only log of Build App runs/fixes/gates | KEEP; preserve past attempt records as append-only, but maintain the current procedure/handoff block when workflow instructions change; the guarded workflow requires this root path, and its large history is not a boot document |
| CHANGELOG.md | Chronological record of decisions and changes | KEEP AS HISTORY; 155 KB reflects an append-only timeline, never use it as current truth |
| .github/workflows/jexfyz-app-build-trigger.yml | Guarded release workflow | KEEP; manual issue trigger only |
| test/*.dart | Source contracts and executable Flutter tests | KEEP; existence alone does not mean a test ran |
| archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md | Pre-cleanup artifact-repository forensic record | KEEP IMMUTABLE; history only |
| archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md | Snapshot of pre-reorganization mixed current/history notes | KEEP IMMUTABLE; never source current truth |
| archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md | Older transfer/rules/changelog snapshot | KEEP IMMUTABLE; not a current handoff prompt |

## Markdown cleanup conclusions

- Do not delete the large APP_BUILD_REPORT.md or CHANGELOG.md simply to reduce the visible repository size. Their chronology and evidence have historical value; the workflow also expects APP_BUILD_REPORT.md at the repository root. Keep them out of the boot path and summarize only the latest state in PROJECT_STATE.md.
- Do not edit archive/*.md. They are dated snapshots that intentionally contain stale versions and obsolete prompt formats.
- Subject references should not carry duplicate build logs, old current-state blocks or stale source/blob fingerprints. Keep release artifact checksums and incident evidence where they are evidentially meaningful.
- Keep current notes small enough to load selectively; CHAT_TRANSFER.md and HANDOVER.md must be materially smaller than history ledgers.
- Current docs must distinguish CURRENT SOURCE, USER-REPORTED, VERIFIED CI, SOURCE IMPLEMENTED / NOT RUN, UNVERIFIED, HYPOTHESIS and HISTORICAL / SUPERSEDED.
- Do not move files or rename paths unless all code/tests/workflow/docs references have been audited.

## Evidence labels

- CURRENT / VERIFIED: inspected live ref/source or an executed gate with matching evidence.
- USER-REPORTED: owner confirmed a deployment/behavior that was not independently witnessed here.
- SOURCE IMPLEMENTED / NOT RUN: code or static contract exists but relevant validation has not run.
- UNVERIFIED: evidence unavailable.
- HYPOTHESIS: plausible explanation, not proven.
- HISTORICAL / SUPERSEDED: valid for an earlier build or source revision only.
- NOT RELEASED: not proven to be part of the latest packaged artifact.

## Non-negotiable product boundaries

- Active Firmware file: firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1"; raw-decimal Hotside limit safety remains separate from Adaptive Fan target bands.
- Adaptive Fan bands at 40°C limit: 40/39/38→100%; 37/36→90%; 35/34→80%; 33/32→70%; 31/30→60%; ≤29→50%. PWM upsteps are 10 points/second; downsteps are 10 points/10 seconds.
- No rapid Hotside-rise/rate-of-rise shutdown/manual-rearm implementation exists in V7.1. Retain as an unimplemented user requirement, not a feature.
- Preserve BLE P1 identifiers, authoritative telemetry, unknown values when disconnected, protected single-radio handoff, OTA safeguards, Touch/rail/Peltier timing and stored schema compatibility.
- Do not add a standalone Battery Protection Guard UI; do not infer official App identity from BLE bonding/SYNC_READY.
