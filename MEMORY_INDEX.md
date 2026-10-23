# JE X FYZ / JE Cooler — Documentation Index and Retention Policy

Last reconciled: 2026-10-23 (Asia/Jakarta). This index defines which document is authoritative for each topic and why each Markdown record is retained. Always verify implementation facts against live main/source, tests, Actions and Release data.

## Current production checkpoint

- **Field status (USER-REPORTED):** the owner previously reported installing/overwriting Build #128. Installed APK identity was not independently read; Build #129 is the latest published release but is not confirmed installed on the physical unit. Firmware V7.1 compile/Online OTA also remains USER-REPORTED.
- **Latest independently verified App release:** [Build #129 / Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), exact package source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`. Release ID `403010611`; Release metadata and live `refs/tags/jexfyz-latest` target the same SHA.
- **APK:** asset ID `668498025`, 54,751,323 bytes, SHA-256 `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`. **Source ZIP:** asset ID `668498026`, 2,878,916 bytes, SHA-256 `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed all 21 workflow gates, **122 Flutter tests**, analyzer (25 informational diagnostics), the configured Android Gradle gate, APK V1/V2/V3 + expected certificate, source ZIP marker/integrity, exact Release/tag parity and downloaded APK/source checksum/signature checks. Native Android JUnit tasks were `NO-SOURCE`.
- **Home-equivalent Settings/Connection/modal DPI sizing is validated and released in Build #129.** The density regression test held physical viewport 1080×2400 constant while checking 420-dp and 320-dp logical widths, a 360×800 logical canvas and scales 420÷360 / 320÷360. Physical-device/OEM rendering remains unverified.
- **Compact Settings/Connection pass is on `main` but unvalidated/unreleased (2026-10-23):** commits `5ab14e258a9e21bfec486e3c6a3d81d6705c6d0f`, `bfdcafd1ad044974935b4e473d68f2096a297fbf`, `415d240db3cd9b3e2bca3ef760c4ba667459c604`, `f5bf63b0f5c8a837f47617b77e85d8dce93d845c`, and `9db9ee3fc453f537ceaca88462b02e36318a487e` add compact-only theme/typography/spacing for Settings root/subpages and Connection, preserve inherited light/dark theme semantics and cover the key source contracts. The Home-equivalent 360-dp canvas and DPI formula remain unchanged. Flutter test/formatter/analyzer and device QA have not run because Flutter/Dart are unavailable; Build #129 remains latest release. See `APP_NOTES.md`, `DESIGN_NOTES.md`, `PROJECT_STATE.md`, `HANDOVER.md`, and `CHAT_TRANSFER.md`.
- The Home notice heading follows App language: `Notification` in English and `Notifikasi` in Indonesian. App CI does not prove installed package identity, real-device behavior or Firmware/OTA/BIN identity.

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
