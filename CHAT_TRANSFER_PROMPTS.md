# JE X FYZ / JE Cooler — Chat-Limit LOAD + CONTINUE Prompts

Exactly two copy-ready payloads live here. Each block starts with the short command name only, without the `@Thinking` prefix. They are recovery/continuation prompts, not automatic saves.

## How to use

Paste one complete copy-ready block as a single message; do not add another command line above it.

- General Discussion: paste **Prompt 1** unchanged. Its first line is `Diskusi!`.
- New, explicitly authorized source/docs execution: replace only Prompt 1's first line with `Eksekusi Full!`.
- Recovery of an interrupted, already-authorized operation: replace only Prompt 1's first line with `Chat Stuck!`.
- Guarded App Build/QC: use **Prompt 2** only for that workflow. Its first line is `Eksekusi Build App!`.

These copy-ready blocks intentionally omit the `@Thinking` prefix. The first line identifies the intended chat mode; the remaining text does not widen its scope. Never duplicate the command line or use Prompt 2 for general engineering.

## Critical memory-save rule

A chat transcript or a prompt does **not** automatically save itself into GitHub. Durable project memory exists only when the relevant Markdown checkpoint/note or build ledger has actually been written, committed, and verified on `main`. Follow the save cadence inside each prompt; do not wait for the owner to issue a separate save command. If a chat ends abruptly before a checkpoint is committed, recover the last saved state only and explicitly identify any possible unsaved gap.

## Prompt 1 — General engineering / code chat

Use for general Discussion, a specifically authorized engineering/code task, or recovery of an interrupted operation that was already authorized.

### Copy-ready payload

```text
Diskusi!
CHAT-LIMIT LOAD + CONTINUE — GENERAL ENGINEERING / CODE CHAT

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Load the latest saved checkpoint and live repository evidence, identify the exact last verified step, and continue the same general engineering workstream immediately. This is not a recap request. Do not ask the owner to repeat requirements already saved in project records. Do not infer source-change or build authorization from this payload.

MEMORY SAVE — REQUIRED CADENCE
- Do not assume chat content is automatically written to GitHub. Only a repository update that was actually committed and verified is durable shared memory.
- Before ending a substantive project chat, review messages since the last checkpoint and commit any new durable requirements, decisions, findings, progress, open issues, or next steps to the relevant canonical notes. Do not wait for a separate save request. If nothing durable changed, keep the previous verified checkpoint and avoid empty commits.
- After every durable user decision, significant finding, completed logical milestone, test result, or blockage, update CHAT_TRANSFER.md plus the relevant canonical note; commit directly to main and verify the written content/HEAD before reporting the checkpoint as saved.
- At the end of every substantive Discussion or scoped Eksekusi Full task, record the decision/result, evidence label, unfinished work, and precise next action before reporting completion. For work that spans multiple milestones, checkpoint between milestones rather than waiting until the entire task finishes.
- When a chat-limit/context interruption is foreseeable, checkpoint immediately: active mode and authorized scope; latest completed milestone; exact remaining/uncommitted work; files/commit and test/log evidence; blockers; next safe step; and whether any operation is still running. Verify the live main branch and checkpoint after writing.
- If the chat ends abruptly before that save finishes, do not claim everything was saved. Recover from the latest verified GitHub checkpoint and live evidence; state any possible gap and do not invent missing decisions or blindly repeat side effects.

LOAD
1. Read CHAT_TRANSFER.md fully before making assumptions.
2. Fetch live main HEAD, commit metadata and the full recursive repository tree.
3. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md and HANDOVER.md completely.
4. Read the complete canonical subject references relevant to the current task. Inspect live source, tests, configuration and workflow only as needed. For a full documentation audit, inspect every Markdown file and classify it as an active reference, history ledger or immutable archive.
5. Check current Actions/Release/PR status when relevant. A saved hash or checkpoint is not proof of current state.

CONTINUE — NO RECAP STAGE
- Identify the latest durable decision, the last verified task state, and any live evidence that supersedes it.
- Continue the inherited discussion/task from that point; do not stop after a long summary and wait for the user to restate the work.
- Ask a question only if a material user decision cannot be recovered from the source of truth.
- If later chat content may have been lost before checkpointing, state exactly what is recoverable. Never invent unsaved content or claim it was saved.
- For Chat Stuck recovery, inspect actual logs/tool results and live state first, then resume only the most recent valid, already-authorized operation. Avoid blind retries and duplicate side effects. If scope/authorization cannot be established, remain read-only and request a valid command before writing.

AUTHORIZATION BOUNDARIES
- Discussion is read-only for executable source, configuration, workflow, builds/releases, Firmware/BIN/Firebase, OTA, flashing and device operations. When a substantive discussion concludes, update canonical project-memory documentation only.
- Eksekusi Full performs only the specifically authorized code/docs/tests/static-audit scope and commits directly to main. It never authorizes App Build/APK release, Firmware compilation, BIN/Firebase mutation, OTA, flashing or device work.
- Chat Stuck inherits only a valid in-progress authorization and never widens it.
- Preserve production baseline Build #124 + Firmware V7.1. Firmware compile/Online OTA success is owner-reported; exact BIN identity and physical behavior remain unverified. The sold unit is unavailable for routine repair.
- Preserve Android Gradle versionName "Telegram @horizontalzzz", BLE/P1, authoritative telemetry, Touch, safe-output, rail-timing and OTA contracts. Before any specifically authorized OTA-related change, read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md.
- Do not remove historical evidence merely because it is old. Keep APP_BUILD_REPORT.md and CHANGELOG.md as history ledgers and archive/*.md immutable unless explicitly directed otherwise.
- Apply the MEMORY SAVE cadence above after each durable decision/milestone and at scoped-task completion or blockage. Treat the checkpoint as saved only after verifying its live main content.
- Do not run App Build, Firmware compile, BIN publication, Firebase changes, OTA, flashing or device operations under this general payload.

REPORT
Start with a short statement of the restored checkpoint and evidence boundary, then continue the actual work. After every durable milestone and at task completion/blockage, verify the memory checkpoint before reporting. Never produce a recap-only chat.
```

## Prompt 2 — App Build / QC chat only

Use only for the guarded App Build/QC workflow. The copy-ready block starts with `Eksekusi Build App!`; paste it as one complete message without adding another command line. This is a one-shot LOAD + CONTINUE prompt, not a recap.

### Copy-ready payload

```text
Eksekusi Build App!
BUILD APP CHAT-LIMIT LOAD + CONTINUE — APP BUILD / QC ONLY

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Resume the same App Build/QC operation from live repository, workflow, Actions/Release evidence and APP_BUILD_REPORT.md. Do not create a separate recap chat or ask the owner to repeat saved details. Inspect the exact live run state before taking any action so a chat-limit recovery never starts a duplicate build. The `Eksekusi Build App!` command selects the guarded App Build/QC workflow and its justified App-scope repairs; it does not authorize Firmware/device operations.

MEMORY SAVE — REQUIRED CADENCE
- GitHub memory is not automatic: only changes actually committed and verified in the repository are durable. Do not rely on the conversation transcript as the only record of a build.
- Append each actual build attempt/result, source SHA, run ID, job/failure evidence, repair, validation status, artifact/release checks, and blocker to APP_BUILD_REPORT.md as the workflow progresses. Never rewrite older attempt evidence to make it look successful.
- At each logical build milestone and before any foreseeable chat-limit interruption, update CHAT_TRANSFER.md with the exact current run status, source SHA, last completed gate, remaining gate/next action, and whether a run is still active. Commit and verify the saved ledger/checkpoint on main.
- At successful completion or blockage, finalize APP_BUILD_REPORT.md and CHAT_TRANSFER.md with evidence labels before reporting. If the chat cuts off before the update commits, recover the last saved state and live Actions/jobs/logs; explicitly note any possible unsaved gap.

MANDATORY LOAD
1. Read CHAT_TRANSFER.md fully and fetch live main HEAD plus the recursive repository tree.
2. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md, HANDOVER.md, BUILD_NOTES.md and the entire current .github/workflows/jexfyz-app-build-trigger.yml.
3. Read APP_BUILD_REPORT.md through to the latest attempt, including fixes, failures, test counts, source commit, signing, release-asset checks and outstanding gates. It is the authoritative execution ledger; older entries are history.
4. Inspect the live App source, relevant tests, dependency/package configuration, Android signing configuration and workflow contracts relevant to the current blocker.
5. Fetch current Actions runs, jobs/logs and Releases. Do not infer run status, package identity, tag target or artifact hashes from old notes.

CONTINUE THE BUILD — NO RECAP
- Determine whether the exact intended run is active, failed, cancelled, blocked or already complete.
- If active, inspect its actual jobs/logs and continue from the current state; do not launch a duplicate run.
- If failed, identify the exact failing gate and fix an App-scope cause instead of weakening checks. Commit the justified fix to main, then trigger only the guarded issue workflow and verify the run targets the intended commit.
- Retry only after a concrete source/config repair or an evidence-backed transient infrastructure condition. Never retry blindly.
- If blocked by missing permissions, hosted runner allocation, secrets/signing credentials, external service or a required owner/device action, record the precise blocker and stop. Do not claim success.
- Append each attempt, run ID, intended source SHA, failure evidence, fix, tests, APK/signature/release checks and result to APP_BUILD_REPORT.md as the operation progresses. After each logical milestone, verify the ledger/checkpoint is committed before claiming it is saved.
- Completion requires the live workflow's full gates, test/analyzer status, exactly one APK and corresponding source ZIP, signing/certificate validation, publication and downloaded-asset identity/checksum checks. Clearly separate CI evidence from physical-device/BLE/Firmware/OTA evidence.

BUILD-ONLY LIMITS
- This operation covers only the guarded App Build/QC/release workflow and justified App-scope repairs needed by it.
- It does not authorize Firmware compilation, BIN generation/publication, Firebase/production metadata changes, physical OTA, flashing, device operations or unrelated releases.
- Do not change the workflow so push/PR automatically publishes an APK. Read and follow the live guarded issue trigger.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- If the build task has already passed all gates, verify the package from live evidence and do not launch another build without a new explicit request.

REPORT
Continue immediately from the last valid attempt. Checkpoint each milestone and finalize both the build ledger and handoff checkpoint at success/blockage. Keep status concise, evidence-based and labeled RECOVERED, BLOCKED or FAILED when appropriate. Never return only a recap.
```
