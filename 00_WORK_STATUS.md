# 00_WORK_STATUS — JE X FYZ / JE Cooler

> Single current snapshot for JE X FYZ project interactions. This file records the latest persisted observation, not a continuously running heartbeat or overall product completion.

## Current marker

| Field | Value |
|---|---|
| **STATUS** | **IN_PROGRESS** |
| SESSION STATUS | IN_PROGRESS |
| WORK STATUS | IN_PROGRESS |
| Mode | Eksekusi Full! |
| Request / work item | Make non-publishing Flutter validation run automatically without owner manual dispatch; trigger and inspect validation only, never Build App/Release or Firmware/device |
| Started | 2026-11-14 (Asia/Jakarta) |
| Last updated | 2026-11-14 08:17 (Asia/Jakarta) |
| Current phase | Summary echo bug fixed and formatter-patch artifact preview added; automatic Validation Only run #3 started on corrected workflow SHA; waiting for dependency/quality gates and patch artifact |
| Last completed milestone | Run #2 findings captured; summary source-SHA backtick removed; optional formatter preview now runs `dart format lib test` only in ephemeral runner after tests and uploads a 7-day review patch; upload-artifact pinned to full SHA; GitHub automatically created run #3 / 43539667033 / source `6fb0f2be8f648a420bd10aa1a1a3b4070e4547e1` |
| Last verified main checkpoint | `6fb0f2be8f648a420bd10aa1a1a3b4070e4547e1` — corrected validation workflow commit triggering current automatic run #3 |
| EXTERNAL OPERATION | No new validation run; historical Build #162 / run 43430275967 / source `6854d8eb58a5f077cbc99749a35d37a4f55b8efa` remains latest completed App build |
| EXTERNAL OPERATION STATUS | **IN_PROGRESS — Validation Only run #3 / 43539667033 / source `6fb0f2be8f648a420bd10aa1a1a3b4070e4547e1`** |
| Result / evidence | New workflow is manual-only, contents:read, Flutter 3.47.2, locked pub get, read-only formatter, analyzer and all Flutter tests; individual quality gate outcomes are aggregated into a final failing status if any gate fails. YAML and embedded shell static checks PASS. Actual pub get/analyzer/formatter/tests and actionlint remain NOT RUN; no Build App or device operations were run. |
| Blocker | Formatter baseline still needs a patch preview and a formatting-only source review; `actionlint` remains unavailable locally. Run #3 is in progress. |
| Next action | Monitor run #3 and fetch `jexfyz-dart-format-preview` artifact if produced; verify the patch changes only formatting, then apply only the formatter output as a narrow source change and allow push-triggered validation to rerun. Preserve no-build/release/Firmware/device constraints. |

## Status model

`STATUS` is a compatibility alias for `SESSION STATUS`, so every new project interaction visibly starts as `IN_PROGRESS`. Keep SESSION STATUS, WORK STATUS and EXTERNAL OPERATION STATUS separately populated.

### Session status — the current owner message/interaction

- **IN_PROGRESS** — opened at the beginning of every JE X FYZ project-related owner message, before extended loading/research/execution.
- **COMPLETED** — this interaction has been handled and its result/checkpoint has been saved and verified.
- **BLOCKED** — this interaction cannot proceed because a concrete tool, service, permission, runner or environment dependency is unavailable.
- **WAITING_OWNER** — a specific decision, input or new authorization is required from the owner.
- **FAILED** — an attempted acceptance objective ended unsuccessfully and no in-scope repair completed it.
- **CANCELLED** — the owner explicitly stopped/cancelled the interaction.
- **RECOVERY_REQUIRED** — a prior interaction ended unexpectedly before a terminal close; verify it before resuming.

### Work status — the requested objective across steps or chats

- **IN_PROGRESS** — the requested work item still has authorized work or a verified external process underway.
- **COMPLETED** — all requested acceptance criteria and available required checks are complete; this does not mean the entire product is complete.
- **BLOCKED** — completion is prevented by a concrete dependency/tool/permission/service/runner issue.
- **WAITING_OWNER** — work is paused for a precise owner decision/input/authorization.
- **FAILED** — the work item reached an unsuccessful terminal result with no safe in-scope repair.
- **CANCELLED** — the owner cancelled the work item.
- **RECOVERY_REQUIRED** — the previous work item was interrupted and its last state/authorization must be reconciled.

### External operation status — only for an actual process

- **NOT_APPLICABLE** — no independent external process exists.
- **QUEUED** — an external operation is confirmed queued.
- **IN_PROGRESS** — an actual run/job/process is confirmed active by its live status.
- **COMPLETED / SUCCESS** — the external operation reached successful terminal state.
- **FAILED** or **CANCELLED** — the external operation reached that terminal state.
- **UNKNOWN** — current live state could not be verified; never infer from an old checkpoint.

## Update protocol

1. **Every JE X FYZ project-related owner message** opens with SESSION STATUS = IN_PROGRESS. This includes explicit mode commands, ordinary project questions, corrections, follow-ups and stop/cancel instructions, whether in a new or existing chat. Unrelated non-project conversation does not update this file.
2. First read this file; immediately persist the new interaction, work item, mode, Asia/Jakarta timestamp, current phase, last verified checkpoint and next action as IN_PROGRESS before extended loading or execution. Preserve an existing independent external operation in its own fields.
3. Update this snapshot after every meaningful milestone, actual tool/test result, commit, blocker, permission/authorization change or external-operation state transition. Update `Last updated` using the current Asia/Jakarta time and report the actual last verified evidence.
4. At closure, set SESSION STATUS and WORK STATUS independently. A short answer still gets a start and terminal close. If a real external operation remains active after the current interaction ends, SESSION STATUS may be COMPLETED while WORK STATUS and EXTERNAL OPERATION STATUS remain IN_PROGRESS; record its exact run/job and next monitoring action.
5. If the previous session/work status was IN_PROGRESS when a new chat starts, verify live Actions/process state first. Record the unfinished prior item as RECOVERY_REQUIRED in CHAT_TRANSFER when appropriate, then begin the new interaction as IN_PROGRESS. Never assume a frozen chat is still running or repeat an irreversible side effect.
6. If the opening or closing status write fails, report that persistence failure explicitly. Do not claim GitHub is synchronized; avoid irreversible operations until the marker can be persisted.

## Automation boundary

This process is automatic in the assistant's handling of project messages, but **not** a GitHub webhook or background monitor. GitHub cannot receive ordinary ChatGPT messages directly, and no status write occurs while ChatGPT is disconnected, frozen or not executing a tool call. Updates are therefore event-driven at interaction start, real milestones/state transitions and closure—not per-second. `Last updated` is the timestamp of the last successful persistence.

## Canonical references

- [Authoritative status lifecycle and mode policy](MASTER_PROMPT.md)
- [Detailed continuation checkpoint](CHAT_TRANSFER.md)
- [Current project state](PROJECT_STATE.md)
- [Immediate handover](HANDOVER.md)
- [App Build attempt/evidence ledger](APP_BUILD_REPORT.md)
