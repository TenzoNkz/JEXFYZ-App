# JE X FYZ / JE Cooler — Documentation Index and Retention Policy

Last reconciled: 2026-10-23 (Asia/Jakarta). This index defines which document is authoritative for each topic and why each Markdown record is retained. Always verify implementation facts against live main/source, tests, Actions and Release data.

## Current production checkpoint

- Baseline reported by the owner: Android App Build #124 and Firmware V7.1 successfully compiled/installed through Online OTA on the sold/shipped unit. The Firmware compile/OTA statement is USER-REPORTED.
- Independently verified App artifact: [Build #124 / Actions run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), package source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. APK SHA-256 c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318; source ZIP SHA-256 e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152.
- Live documentation rework began from main HEAD 11a0ef162f1c2945704229ed7697dc70e7617e9b. Fetch live HEAD/tree before using this or any saved source hash as current.
- Current source-only App changes for fixed Settings scaling, Device/Perangkat copy, BLE-gated Floating Monitor and language-synchronized notifications are in source but have not been validated by a new App Build since Build #124. No build/release was run during this documentation rework.
- Important audit finding: live source currently returns Notification / Notifikasi for the Home notice heading via the localization key; DESIGN_NOTES.md contains an older rule saying the heading must always be exactly NOTIFY in both languages. This UI contract mismatch is recorded for an explicit follow-up; this docs task does not change App behavior.

## Recovery protocol

1. Read CHAT_TRANSFER.md fully.
2. Fetch live main HEAD, recursive tree and commit metadata.
3. Read CHAT_RULES.md, this index, PROJECT_STATE.md, HANDOVER.md, and the entire canonical note relevant to the current task.
4. Paste Prompt 1 from CHAT_TRANSFER_PROMPTS.md as one complete message; its first line is Diskusi! by default. For a specifically authorized Eksekusi Full task or recovery of an already-authorized interrupted operation, replace only its first line with Eksekusi Full! or Chat Stuck!, respectively. The prompt uses these short command names without @Thinking.
5. Prompt 2 starts with Eksekusi Build App!; use it only for the guarded Build App/QC operation. Do not add a duplicate command line above either copied block.
6. Continue the prior workstream directly; no recap-only chat. GitHub is not an automatic transcript store: only committed and verified document changes are durable memory. Save after each durable decision, important finding, logical milestone, test result, and blockage. At the end of each substantive Discussion/Eksekusi Full task, update CHAT_TRANSFER.md and the relevant active notes before reporting completion. During Build App, update APP_BUILD_REPORT.md as each real attempt/milestone happens and refresh CHAT_TRANSFER.md with live run status.
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
