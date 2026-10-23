# JE X FYZ / JE Cooler — Chat-Limit LOAD + CONTINUE Prompts

Exactly two copy-ready payloads live here. The command header is intentionally **not included** in either copy block.

## How to use

At the top of the same message, type the command yourself, then paste the matching payload beneath it. Do not paste a command a second time inside the copy block.

- General Discussion: type `@Thinking Diskusi!` yourself, then paste **Prompt 1**.
- New explicitly authorized source/docs execution: type `@Thinking Eksekusi Full!` yourself, then paste **Prompt 1**.
- Recovery of an interrupted, already-authorized operation: type `@Thinking Chat Stuck!` yourself, then paste **Prompt 1**.
- Continuing an already-authorized App Build/QC operation: type `@Thinking Eksekusi Build App!` yourself, then paste **Prompt 2**.

The prompt payload itself never authorizes a task. Never use Prompt 2 unless the Build App operation has actually been authorized.

## Prompt 1 — General engineering / code chat

Use for general Discussion, a specifically authorized engineering/code task, or recovery of an interrupted operation that was already authorized.

### Copy-ready payload

```text
CHAT-LIMIT LOAD + CONTINUE — GENERAL ENGINEERING / CODE CHAT

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Load the latest saved checkpoint and live repository evidence, then continue the same general engineering workstream immediately. This is not a recap request. Do not ask the owner to repeat requirements already saved in project records. Do not infer source-change or build authorization from this payload.

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
- After a Discussion conclusion or execution success/blockage, update CHAT_TRANSFER.md and relevant canonical notes. Verify post-write content and live main before reporting.
- Do not run App Build, Firmware compile, BIN publication, Firebase changes, OTA, flashing or device operations under this general payload.

REPORT
Start with a short statement of the restored checkpoint and evidence boundary, then continue the actual work. Never produce a recap-only chat.
```

## Prompt 2 — App Build / QC chat only

Use only to continue an App Build/QC operation that was explicitly authorized. Type that command yourself at the beginning of the same message, then paste the payload below. This is a one-shot LOAD + CONTINUE payload, not a second confirmation or recap.

### Copy-ready payload

```text
BUILD APP CHAT-LIMIT LOAD + CONTINUE — APP BUILD / QC ONLY

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Resume the same authorized App Build/QC operation from live repository, workflow, Actions/Release evidence and APP_BUILD_REPORT.md. Do not create a separate recap chat, and do not ask the owner to repeat saved details. This payload does not authorize a build on its own; the required Build App command must be supplied separately by the owner in this same message.

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
- Append each attempt, run ID, intended source SHA, failure evidence, fix, tests, APK/signature/release checks and result to APP_BUILD_REPORT.md as the operation progresses.
- Completion requires the live workflow's full gates, test/analyzer status, exactly one APK and corresponding source ZIP, signing/certificate validation, publication and downloaded-asset identity/checksum checks. Clearly separate CI evidence from physical-device/BLE/Firmware/OTA evidence.

BUILD-ONLY LIMITS
- This operation covers only the guarded App Build/QC/release workflow and justified App-scope repairs needed by it.
- It does not authorize Firmware compilation, BIN generation/publication, Firebase/production metadata changes, physical OTA, flashing, device operations or unrelated releases.
- Do not change the workflow so push/PR automatically publishes an APK. Read and follow the live guarded issue trigger.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- If the build task has already passed all gates, verify the package from live evidence and do not launch another build without a new explicit request.

REPORT
Continue immediately from the last valid attempt. Keep the user-facing status concise, evidence-based and labeled RECOVERED, BLOCKED or FAILED when appropriate. Never return only a recap.
```
