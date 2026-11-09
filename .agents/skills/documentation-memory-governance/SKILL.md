---
name: documentation-memory-governance
description: Use for repository Markdown audits, Master Prompt maintenance, checkpoint/handover updates, source-of-truth mapping, changelog/build-ledger hygiene, link checks, and durable project-memory work.
---

# Documentation and Memory Governance

## Objective
Keep project memory concise, traceable and internally consistent without destroying forensic history.

## Authority model
- MASTER_PROMPT.md is the single full operating ruleset.
- CHAT_RULES.md is only a compatibility pointer.
- CHAT_TRANSFER_PROMPTS.md contains exactly two LOAD + CONTINUE prompts.
- CHAT_TRANSFER.md is the rolling checkpoint, not a transcript.
- PROJECT_STATE.md is current-only truth; HANDOVER.md is the immediate next action.
- Subject notes own durable App/Firmware/design/security contracts.
- BUILD_NOTES.md is the current release procedure; APP_BUILD_REPORT.md is append-only build evidence.
- CHANGELOG.md is dated history. archive/*.md is immutable forensic evidence.

## Procedure
1. Load live tree and classify each Markdown file by role and authority.
2. Find contradictory current-status claims, duplicated rules, stale release numbers and obsolete next actions.
3. Check relative links and path references in Markdown, source, tests and workflows before moving/deleting anything.
4. Replace duplicated prose with links to one canonical source. Do not create a second document for an existing topic without a clear ownership reason.
5. Keep current-state notes concise. Put attempt-by-attempt details in the correct ledger.
6. Preserve user decisions, failure evidence, uncertainty and historical chronology. Label USER-REPORTED, VERIFIED CI, NOT RUN, HYPOTHESIS and NOT RELEASED accurately.
7. Update MEMORY_INDEX.md whenever files or roles change.
8. After each substantive milestone, update CHAT_TRANSFER.md and the relevant canonical note. Verify written content, commit, final HEAD and recursive tree before saying saved.

## Guardrails
Do not edit archive/*.md. Do not delete APP_BUILD_REPORT.md or CHANGELOG.md for size reasons. Diskusi allows documentation/memory changes only, not source/config/workflow mutation. Avoid empty commits.
