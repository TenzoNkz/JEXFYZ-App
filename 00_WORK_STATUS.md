# 00_WORK_STATUS — JE X FYZ / JE Cooler

> **This is the first file-level work marker in the repository root.** The value below describes the latest recorded chat work session, not the overall completion of the product.

## Current marker

| Field | Value |
|---|---|
| **STATUS** | **IN_PROGRESS** |
| Mode | Eksekusi Full |
| Work item | Implement per-interaction, milestone and terminal-state lifecycle for JE X FYZ work status |
| Started | 2026-11-14 06:26 Asia/Jakarta |
| Updated | 2026-11-14 Asia/Jakarta |
| Current phase | Defining canonical protocol and updating Master Prompt, transfer prompts and current-state records |
| Last completed milestone | Reconciled Build #162 Actions run 43430275967 / job 131901744336: job completed SUCCESS; all required steps 1–21 and cleanup 39–43 completed SUCCESS |
| Separate external operation | Build #162 / run 43430275967 / source `6854d8eb58a5f077cbc99749a35d37a4f55b8efa` |
| External operation status | **COMPLETED / SUCCESS** — APK, signature, source ZIP, Release/tag and downloaded-asset verification gates completed |
| Result | Current status task remains IN_PROGRESS. Build #162 is independently verified complete; it must no longer be represented as an active process. |
| Blocker | No blocker to documentation change. This environment cannot emit GitHub updates automatically on its own; status will be persisted at each assistant-handled start/milestone/close. |
| Next action | Apply and verify the new status lifecycle protocol; close this Full interaction with a truthful terminal status. |

## Status meanings

- **IN_PROGRESS** — a substantive Diskusi, Eksekusi Full or Build App task has started and its requested scope has not been closed.
- **COMPLETED** — the selected mode's scope is finished, its durable checkpoint is saved and the final repository state has been re-read. This does not mean the entire JE Cooler project or a later release is complete.
- **BLOCKED** — work is unfinished because a concrete tool, runner, validation result, service or other dependency prevents progress. Record the blocker and exact next action.
- **WAITING_OWNER** — work is unfinished and requires an owner decision, input or a new authorization.
- **RECOVERY_REQUIRED** — a `Chat Stuck!` recovery has found an unfinished prior session. Continue only within that session's last valid authorization.

## Update protocol

1. **At the start of every substantive work session**, set this marker to `IN_PROGRESS`, record the selected mode, task, start date and last verified checkpoint. Do this before substantive edits or side effects.
2. **At every meaningful milestone**, refresh the last completed milestone, current step, evidence and last known commit/checkpoint. Keep the status `IN_PROGRESS` until the requested scope is closed.
3. **At the end of the session**, set `COMPLETED` only after the work for that mode is complete, required available checks have been run, canonical notes/checkpoint are saved, and GitHub read-back verifies the final state. Otherwise use `BLOCKED` or `WAITING_OWNER`.
4. **During `Chat Stuck!` recovery**, read this file first. If it says `IN_PROGRESS`, mark the prior work `RECOVERY_REQUIRED`, read `CHAT_TRANSFER.md`, verify live main/Actions and resume only a recoverable, already-authorized scope. Once recovery is underway, update the marker to `IN_PROGRESS` with the recovered scope.
5. Keep this file as a **single current snapshot**, not an append-only log. Detailed engineering state belongs in `CHAT_TRANSFER.md`; release attempts and artifact evidence belong in `APP_BUILD_REPORT.md`; historical decisions belong in the relevant subject notes and `CHANGELOG.md`.

## Important limitation: not a live process monitor

GitHub cannot tell whether a ChatGPT conversation is still generating, has frozen, or was closed unexpectedly. There is no automatic heartbeat from the chat to this repository.

- If a chat is interrupted between updates, this marker remains at its last committed value—usually `IN_PROGRESS`. That is a durable indication that the session was not formally closed, **not proof that a background process is still running**.
- The `Updated` date and last completed milestone show how fresh the information is. A new `Chat Stuck!` session must inspect this marker, `CHAT_TRANSFER.md`, live GitHub state and any actual Actions run before deciding what can safely resume.
- A status becomes `COMPLETED` only when the closing update has been committed and verified. The marker remains useful even when the final chat response is never delivered.

## Canonical links

- [Detailed continuation checkpoint](CHAT_TRANSFER.md)
- [Current project state](PROJECT_STATE.md)
- [Immediate handover](HANDOVER.md)
- [Operating rules and authorization](MASTER_PROMPT.md)
- [Build attempt and release evidence](APP_BUILD_REPORT.md)
