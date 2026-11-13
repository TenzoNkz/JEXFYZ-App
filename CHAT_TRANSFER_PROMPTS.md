# JE X FYZ / JE Cooler — Chat-Limit LOAD + CONTINUE Prompts

Exactly two copy-ready payloads live here. Both delegate the detailed operating contract to [MASTER_PROMPT.md](MASTER_PROMPT.md), so the rules are maintained once rather than duplicated in each prompt.

## How to use

Paste one complete block as a single message. Do not add a duplicate command line above it.

- Prompt 1 unchanged: general Discussion.
- Prompt 1 with only its first line changed to Eksekusi Full!: specifically authorized source/docs/tests/static-audit execution.
- Prompt 1 with only its first line changed to Chat Stuck!: recovery of an operation that already had valid authorization.
- Prompt 2: guarded App Build/QC only; its first line stays Eksekusi Build App!.

The copy-ready blocks intentionally use the short command name without the @Thinking prefix. The owner's normal chat command may include @Thinking.

## Prompt 1 — General engineering / code chat

Use for general Discussion, a specifically authorized Eksekusi Full task, or recovery of an already-authorized interrupted operation. Replace only the first line when selecting another mode.

### Copy-ready payload

~~~text
Diskusi!
MASTER PROMPT LOAD + CONTINUE — GENERAL ENGINEERING

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Load the current durable checkpoint and live repository evidence, then continue the same workstream. This is not a recap request. Do not ask the owner to repeat saved requirements. The first line selects the mode; the rest of this prompt does not widen its permissions.

MANDATORY LOAD
1. Read MASTER_PROMPT.md fully. It is the single authority for modes, permissions, Gemini handoff, evidence, memory cadence and protected contracts.
2. Read `00_WORK_STATUS.md` to identify the latest recorded mode/status and recovery requirement.
3. Read the active top checkpoint in CHAT_TRANSFER.md. Load older checkpoint history only when the current task needs it; use canonical notes/ledgers for the authoritative detail.
4. Fetch live repository metadata, main HEAD/commit metadata and the complete recursive tree. Confirm the tree is not truncated.
5. Read CHAT_RULES.md (pointer), MEMORY_INDEX.md, PROJECT_STATE.md and HANDOVER.md.
5. Read the full canonical subject references relevant to the task. Inspect live source/tests/config/workflow read-only as needed.
6. Check Actions, Releases, tags, PRs, jobs and logs when relevant.

CONTINUE — NO RECAP STAGE
- Identify the last verified milestone, latest durable decision, unfinished work, blockers and precise next action.
- Continue the actual workstream immediately; do not stop after a summary.
- Never infer an unsaved decision from old chat or a stale checkpoint.
- Chat Stuck! inherits only a valid in-progress authorization. If scope or authorization is unclear, remain read-only and ask for a valid command.

GEMINI CONSULTATION
During Discussion, proactively offer a self-contained Gemini review prompt whenever a second opinion would materially reduce uncertainty; the owner does not need to type Tanya Gemini! first. Gemini has zero access to this GitHub repository. Never ask it to open links or inspect files that are not pasted. Include the relevant facts, source/test excerpts, paths, revision context, constraints and exact question in the prompt. Do not include secrets. Treat its answer as unverified until checked against live source and canonical notes.

MEMORY SAVE
Follow the save cadence in MASTER_PROMPT.md. Set `00_WORK_STATUS.md` to IN_PROGRESS at start, update it at milestones, and close it as COMPLETED/BLOCKED/WAITING_OWNER before ending. Before ending a substantive task, save new durable decisions/results/blockers in CHAT_TRANSFER.md and the relevant subject note; verify each write and final main HEAD. Do not create empty commits. If nothing durable changed, keep the previous checkpoint.

AUTHORIZATION
- Diskusi! is read-only for executable source, tests, config, workflow, builds/releases, Firmware, BIN, Firebase, OTA, flashing and device operations. Only canonical documentation/memory may be updated after a substantive conclusion.
- Eksekusi Full! performs only the specifically authorized source/docs/tests/static-audit scope and commits to main. It never authorizes App Build/release or Firmware/device operations.
- Chat Stuck! inherits only a valid in-progress authorization.
- This general prompt does not authorize App Build, Firmware compilation, BIN publication, Firebase changes, OTA, flashing or physical device work.

REPORT
Start with the restored checkpoint and evidence boundary, then continue the task. At completion/blockage report changes, commit verification, actual tests run/not run, open risks and the next safe action. Never return only a recap.
~~~

## Prompt 2 — App Build / QC chat only

Use only when the owner explicitly selects Eksekusi Build App!. This prompt does not authorize Firmware/device work.

### Copy-ready payload

~~~text
Eksekusi Build App!
MASTER PROMPT LOAD + CONTINUE — GUARDED APP BUILD / QC ONLY

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Resume the same authorized App Build/QC operation from live repository, workflow, Actions/Release evidence and APP_BUILD_REPORT.md. Do not create a recap-only chat, request already-saved requirements again, or trigger a duplicate run.

MANDATORY LOAD
1. Read MASTER_PROMPT.md fully.
2. Read `00_WORK_STATUS.md` to identify the latest recorded mode/status, then the active top checkpoint in CHAT_TRANSFER.md. Do not load superseded checkpoint history wholesale.
3. Fetch live main HEAD, commit metadata and the complete recursive tree.
4. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md, HANDOVER.md and BUILD_NOTES.md.
5. Read the entire live .github/workflows/jexfyz-app-build-trigger.yml.
6. Read the latest APP_BUILD_REPORT.md attempt and the immediately relevant preceding failure/repair evidence only. Fetch older build entries only when comparing a regression, artifact or unresolved historical claim.
7. Fetch current Actions runs, jobs, logs, releases, tags and artifact metadata before any side effect.

CONTINUE THE BUILD — NO RECAP
- Determine whether the intended run is active, queued, failed, cancelled, blocked or complete.
- If active, inspect its actual jobs/logs and continue; do not start another run.
- If failed, identify the exact failing gate and repair the App-scope root cause without weakening checks.
- Trigger only the guarded manual issue/title/token workflow. Never introduce push/PR release triggers.
- Retry only after a concrete repair or evidence-backed transient infrastructure failure; never retry blindly.
- Stop as BLOCKED when permissions, runner allocation, signing, external services or owner/device action prevent safe progress.
- Success requires all current workflow gates, analyzer/test evidence, exactly one obfuscated APK and matching source ZIP, signature/certificate verification, exact Release/tag/source SHA parity, and downloaded-asset identity/checksum verification.

MEMORY SAVE
Set `00_WORK_STATUS.md` to IN_PROGRESS when the Build session starts; update it alongside each durable milestone. Append every real attempt, source SHA, run/job ID, failure evidence, repair, test result, artifact/release verification and blocker to APP_BUILD_REPORT.md as the work progresses. At every milestone update CHAT_TRANSFER.md with exact run state, last completed gate, remaining work and whether a run is active. Commit and re-read the ledger/checkpoint. Never rewrite historical failures as successes.

BUILD-ONLY LIMITS
This operation authorizes only the guarded App Build/QC/release workflow and justified App-scope repairs needed by it. It does not authorize Firmware compilation, BIN generation/publication/replacement, Firebase changes, OTA, flashing, device operation or unrelated release work. Preserve Android Gradle versionName exactly: Telegram @horizontalzzz.

REPORT
Continue from the latest valid attempt. At success/blockage finalize the build ledger and checkpoint with exact evidence. Distinguish CI from physical-device, BLE, Firmware, BIN and OTA evidence. Never respond with only a recap.
~~~