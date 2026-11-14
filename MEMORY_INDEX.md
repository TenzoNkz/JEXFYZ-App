# JE X FYZ / JE Cooler — Documentation Map & Retention Policy

Last reconciled: 2026-11-14 (Asia/Jakarta). This file is the navigation and retention index, not an alternate operating ruleset or current-state ledger. Read MASTER_PROMPT.md for all operating instructions. Verify current implementation against live main/source/tests and current Actions/Release evidence.

## Authority order

1. Owner's explicit requirements and decisions determine intent and authorization.
2. Live main source, tests, configuration, workflow, Actions/jobs/logs and Release/tag/artifacts establish implementation and release facts.
3. Canonical subject notes establish durable contracts and design intent, but current implementation must still be checked against source.
4. `00_WORK_STATUS.md` records every JE X FYZ project interaction with separate SESSION STATUS, WORK STATUS and EXTERNAL OPERATION STATUS; it is timestamped/event-driven, not a live heartbeat, and does not establish product implementation truth. PROJECT_STATE.md summarizes current state; CHAT_TRANSFER.md and HANDOVER.md provide continuation context only.
5. CHANGELOG.md and APP_BUILD_REPORT.md preserve history/evidence. archive/*.md is immutable forensic material and never current truth.

## Canonical file map

| File | Role / authority | Class | Retention |
|---|---|---|---|
| 00_WORK_STATUS.md | Single root-level snapshot for every JE project interaction, with separate SESSION STATUS, WORK STATUS and EXTERNAL OPERATION STATUS, timestamps, last milestone and next action | Active operational marker | KEEP one concise snapshot; open IN_PROGRESS for every project-related owner message, refresh on real milestones/state transitions and close with observed result; event-driven, not a live heartbeat/history ledger |
| README.md | Project entrypoint and navigation; links directly to the current work marker | Active index | KEEP; no duplicated build history |
| MASTER_PROMPT.md | Single authority for commands, scope, Gemini, loading, memory cadence, evidence and protected contracts | Active operating policy | KEEP; maintain as the only full ruleset |
| CHAT_RULES.md | Compatibility pointer to MASTER_PROMPT.md | Active pointer | KEEP while legacy links refer to it; do not duplicate rules |
| CHAT_TRANSFER_PROMPTS.md | Exactly two copy-ready LOAD + CONTINUE prompts | Active templates | KEEP exactly two prompts; no historical prompt library |
| CHAT_TRANSFER.md | Rolling latest verified checkpoint for chat continuation | Active checkpoint | KEEP concise/current; not a transcript |
| MEMORY_INDEX.md | This authority map, file classification and retention policy | Active index | KEEP; update whenever Markdown structure changes |
| PROJECT_STATE.md | Current-only product/source/release/validation truth | Active state | KEEP below 100 lines; move build chronology to APP_BUILD_REPORT / CHANGELOG |
| HANDOVER.md | Immediate next action and nearest blockers | Active handover | KEEP short; no duplicate history |
| APP_NOTES.md | Current App behavior, BLE, telemetry, language and notification contracts | Active subject reference | KEEP; detailed implementation must match source |
| APP_PREBUILD_AUDIT.md | Rolling static pre-build audit, prioritized source risks, acceptance matrix and build-readiness decision | Active audit ledger | KEEP while the current source has open pre-build findings; update after each remediation pass and close only after verified acceptance |
| DESIGN_NOTES.md | Owner-approved screen-specific UI/design constraints and visual contracts | Active subject reference | KEEP; no build chronology |
| PRODUCT_DESIGN_CONSTITUTION.md | Cross-screen product-design intent, protected identity, design-system governance and anti-AI-slop principles | Active design reference | KEEP; do not override more specific owner-approved screen contracts |
| VISUAL_QUALITY_GATE.md | Evidence-based visual review, viewport/state matrix, accessibility checks and acceptance outcomes | Active quality standard | KEEP; visual acceptance is separate from build/test status |
| FIRMWARE_NOTES.md | Durable Firmware/hardware/safety requirements and user-reported evidence | Active subject reference | KEEP; distinguish implemented from requested |
| firmware/FIRMWARE_TECHNICAL_REFERENCE.md | Current Firmware architecture, pins, timing and safety invariants | Active technical reference | KEEP; prior-version history belongs in CHANGELOG |
| BLE_APP_AUTH.md | App-only BLE identity design and unimplemented blocker | Active security design | KEEP; never imply it is implemented |
| OTA_PROTECTION.md | Frozen OTA protocol, safety and authorization contract | Active protected reference | KEEP; read before any authorized OTA change |
| OTA_REGRESSION_MEMORY.md | OTA failure history, evidence limits and security trade-off | Incident reference | KEEP; preserve causal uncertainty |
| VOLTAGE_TRANSITION_MEMORY.md | Separate reset reports and Peltier/rail transition contract | Incident/contract reference | KEEP; keep separate incidents separate |
| BUILD_NOTES.md | Current guarded App Build/QC procedure | Active procedure | KEEP; no per-attempt history duplication |
| APP_BUILD_REPORT.md | Append-only App Build/QC attempt, failure, repair and artifact ledger | History ledger | KEEP; do not delete or rewrite old evidence |
| CHANGELOG.md | Dated project decisions and change chronology | History ledger | KEEP; append entries, never use as current truth |
| archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md | Pre-cleanup artifact-repository forensic snapshot | Immutable archive | KEEP IMMUTABLE |
| archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md | Verbatim pre-reorganization current-state/reference snapshot | Immutable archive | KEEP IMMUTABLE; contains stale historic claims |
| archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md | Verbatim legacy prompt/rules/handover/changelog snapshot | Immutable archive | KEEP IMMUTABLE; never reuse its old prompts as current |
| AGENTS.md | Cross-agent entrypoint that points to the Master Prompt and skill index | Active agent entry | KEEP short; do not duplicate policy |
| SKILLS_INDEX.md | Catalogue of portable project skills and capability boundaries | Active capability index | KEEP; update with skill additions/removals |
| .agents/skills/*/SKILL.md | Canonical repository skills for OpenAI Codex-compatible discovery | Active skill library | KEEP one focused workflow per skill; load progressively |
| .github/skills/*/SKILL.md | Byte-identical GitHub Copilot mirrors; the `code-review` skill is eligible for Copilot code review use | Active skill mirrors | KEEP synchronized with `.agents/skills`; verify exact content equality |

## Reconciliation — 2026-11-14

- Current verified App release is Build #162 / Actions run `43430275967` / source `6854d8eb58a5f077cbc99749a35d37a4f55b8efa`. `BUILD_NOTES.md` and `APP_NOTES.md` now identify it as current; older Build #159/pre-Build #162 snapshots remain historical.
- `DESIGN_NOTES.md` now identifies the Usage Statistics presentation contract as included in Build #162 with 188/188 hosted Flutter tests passed; physical screenshot/OEM acceptance remains separate.
- `APP_PREBUILD_AUDIT.md` keeps the current Build #162 success gate at the top and marks superseded pre-build/QC-pending snapshots as historical.
- `PROJECT_STATE.md` is condensed to a current-only summary under 100 lines. `APP_BUILD_REPORT.md`, `CHANGELOG.md` and immutable `archive/*.md` files remain retained; none were truncated, moved or deleted.
- Main's recursive tree at the start of this documentation pass contained 133 entries and 52 Markdown files, `truncated=false`. The 12 canonical `.agents/skills` and 12 `.github/skills` mirrors remain byte-identical. The earlier active-link audit found no actionable missing relative paths.
- The P1 workflow concurrency cancellation issue, missing Flutter lint configuration/formatter gate, absent non-publishing validation workflow and action SHA-pinning backlog remain open. Workflow/configuration changes were not made in this documentation-only scope; see `CHAT_TRANSFER.md` and `HANDOVER.md`.

---

## Markdown and skill-mirror audit — 2026-11-13

- Live recursive `main` tree at the start of this audit: **133 entries, not truncated; 88 blobs; 52 Markdown files**. The 52 Markdown files classify as 24 root-level policy/index/subject/checkpoint/ledger documents, 12 canonical `.agents/skills` definitions, 12 `.github/skills` mirrors, 1 Firmware technical reference and 3 immutable archives.
- All 12 canonical/mirror skill pairs were checked from the recursive tree; each pair has the same Git blob SHA. The active root-document and canonical-skill relative-link scan found no actionable missing paths.
- Some relative paths embedded in the three immutable archive snapshots point to files from their historical pre-cleanup context. Those historical references were not rewritten; archive content remains immutable by policy.
- No Markdown file was moved, renamed or deleted. Build ledgers and archive evidence remain intact.

## Markdown audit — 2026-11-07

- The recursive `main` tree was verified at **125 entries, not truncated, with 50 Markdown files** at commit `5d4940c2a0682ce1a312bcad1e7691afef0918d3` (2026-11-07, Asia/Jakarta). The 50 Markdown files classify as 45 active/index/subject/agent/skill documents, 2 history ledgers and 3 immutable archives. The 24 skill files form 12 canonical `.agents/skills` workflows plus 12 byte-identical `.github/skills` mirrors; all 12 pairs were fetched and compared successfully in the final audit.
- Every current Markdown file has one assigned role in the table above. No Markdown file was removed, renamed or moved in this cleanup.
- The archive files intentionally preserve stale and contradictory historical status. Never copy those statements into current notes without re-verifying the live repository.
- APP_BUILD_REPORT.md and CHANGELOG.md are large by design. Keep them out of the routine boot path; inspect only the latest relevant sections unless investigating history.
- Keep the Master Prompt as the sole rule source. README, CHAT_RULES, transfer prompts, PROJECT_STATE and HANDOVER should link to it rather than fork or repeat it.


- Codex repository skills are under `.agents/skills/`; GitHub Copilot repository skills are mirrored under `.github/skills/`. `AGENTS.md` is the cross-agent entrypoint. Current ChatGPT mobile/web must fetch the relevant private `SKILL.md` through GitHub tools rather than assume the repo files are auto-installed as ChatGPT skills.

## Evidence labels

- CURRENT / VERIFIED — inspected live repository/API state.
- USER-REPORTED — reported by the owner, not independently observed.
- STATIC SOURCE CHECK — source/text/structure comparison only; no runtime execution implied.
- TESTED — the named test command actually ran and its result was observed.
- VERIFIED CI — a live workflow/job result matches the intended source SHA.
- SOURCE IMPLEMENTED / NOT RUN — code/test exists but validation did not run.
- BLOCKED — a concrete tool, permission, service, runner or owner action prevents progress.
- UNVERIFIED — evidence is unavailable.
- HYPOTHESIS — plausible but unproven.
- HISTORICAL / SUPERSEDED — applies to an earlier source/build only.
- NOT RELEASED — not proven to be included in the current published artifact.

## Non-negotiable product boundaries

- The protected known production reference remains App Build #124 plus Firmware V7.1; later published App builds and owner-reported field installation must be described separately.
- Preserve Android Gradle versionName Telegram @horizontalzzz.
- Preserve BLE P1 identifiers/protocol, authoritative telemetry, session synchronization, radio ownership, Touch synchronization and disconnected/unknown-value semantics.
- Preserve safe outputs, NTC protection, Peltier/selector/rail timing, cooperative millis() scheduling and stored-data compatibility.
- Do not add executable Firmware delay() or timing while() loops. Functional Firmware changes require FW_VERSION bump and matching filename; exactly one active versioned .ino.
- Before any specifically authorized OTA change, read OTA_PROTECTION.md, OTA_REGRESSION_MEMORY.md and the full live related source/tests. Do not add Firebase hash/signature requirements without explicit approval.
- Do not show a standalone Battery Protection Guard UI. BLE bonding plus SYNC_READY does not prove official App identity; BLE App-only authorization remains blocked/unimplemented.

## Cleanup policy

- Prefer editing the existing canonical owner file instead of creating a second document for the same topic.
- Before deleting/moving/renaming any file, search links and path-based references across Markdown, source, tests and workflows; then verify the resulting tree.
- Do not delete evidence only because it is old or large. Do not edit archive/*.md.
- Avoid embedding volatile source/blob fingerprints in general notes. Store artifact checksums and exact SHAs only where they provide release, test or forensic identity.
- On future changes, update this index in the same documentation task and verify all new paths.