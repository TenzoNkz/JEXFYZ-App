# JE X FYZ / JE Cooler — Chat-Limit LOAD + CONTINUE Prompts

This file intentionally contains exactly two prompts. Both load live state and continue the actual workstream; neither asks for a recap-only response.

## Prompt 1 — General engineering / code chat

Use for ordinary Discussion, an explicitly authorized Eksekusi Full scope, or recovery of an already-authorized interrupted engineering operation. Before sending, keep the command header that matches the real authorization mode:
- Leave @Thinking Diskusi! for read-only discussion.
- Replace the first line with @Thinking Eksekusi Full! only when the user has explicitly authorized the new execution scope in the same request.
- Replace the first line with @Thinking Chat Stuck! when recovering an already-authorized operation interrupted by a stall/context limit.
Do not send multiple command headers. This prompt grants no new permissions.

### Copy prompt

@Thinking Diskusi! CHAT-LIMIT LOAD + CONTINUE — GENERAL ENGINEERING / CODE CHAT

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Load the latest saved checkpoint and live repository evidence, then continue the same general engineering workstream immediately. This is not a recap request. Do not ask the owner to repeat requirements already in saved records. Do not infer a source change or build authorization from this prompt.

LOAD
1. Read CHAT_TRANSFER.md fully before making assumptions.
2. Fetch live main HEAD, commit metadata and the full recursive repository tree.
3. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md and HANDOVER.md completely.
4. Read the complete canonical subject references for the current task. Inspect relevant live source, tests, configuration and workflow only as needed. For a full documentation audit, inspect every Markdown file and classify active reference, append-only ledger or immutable archive.
5. Check current Actions/Release/PR status when relevant. A saved hash or prior checkpoint is not proof of current state.

CONTINUE — NO RECAP STAGE
- Identify the latest durable decision, the last verified task state, and any live evidence that supersedes it.
- Continue the inherited discussion/task from that point; do not stop after a long summary and wait for the user to restate the work.
- Ask a question only if a material user decision cannot be recovered from the source of truth.
- If later chat content may have been lost before checkpointing, say exactly what is recoverable; never invent an unsaved answer or claim it was saved.
- For @Thinking Chat Stuck!, inspect actual logs/tool results and live state first, then recover only the most recent valid already-authorized operation. Avoid blind retries and duplicate side effects. If scope/authorization cannot be established, stay read-only.

STRICT AUTHORIZATION
- Discussion is read-only for executable source, config, workflow, builds/releases, Firmware/BIN/Firebase, OTA, flash and devices. Once a substantive discussion concludes, update canonical memory/checkpoint documentation only.
- Eksekusi Full performs only the specifically authorized code/docs/tests/static-audit task and commits directly to main. It never authorizes App Build/APK release, Firmware compilation, BIN/Firebase mutation, OTA, flash or device work.
- Chat Stuck inherits only a valid in-progress authorization and never widens it.
- Preserve production baseline Build #124 + Firmware V7.1. Firmware compile/Online OTA success is owner-reported; exact BIN identity and physical behavior remain unverified. The sold unit is not available for routine repair.
- Preserve Android Gradle versionName "Telegram @horizontalzzz", protected BLE/P1, telemetry, Touch, safe-output, rail-timing and OTA contracts. Before authorized OTA-related changes, read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md.
- Do not remove historical evidence merely because it is old. Keep APP_BUILD_REPORT.md and CHANGELOG.md as history ledgers and archive/*.md immutable unless explicitly directed otherwise.
- After a discussion conclusion or execution success/blockage, update CHAT_TRANSFER.md and the relevant canonical notes. Verify the post-write content and live main before reporting.
- Do not run App Build, Firmware compile, BIN publication, Firebase changes, OTA, flash or device operations under this general prompt.

REPORT
Start with a short statement of the restored checkpoint and evidence boundary, then continue the actual work. Never produce a recap-only chat.

## Prompt 2 — App Build / QC chat only

Use only for a Build App workstream that the owner has explicitly authorized through this command. Paste once at the beginning of the replacement Build App chat. It is a one-shot LOAD + CONTINUE prompt, not a second confirmation or recap.

### Copy prompt

@Thinking Eksekusi Build App! BUILD APP CHAT-LIMIT LOAD + CONTINUE — APP BUILD / QC ONLY

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main

PURPOSE
Resume the same authorized App Build/QC operation from live repository, workflow, Actions/Release evidence and APP_BUILD_REPORT.md. Do not create a separate recap chat, and do not ask the owner to repeat saved details.

MANDATORY LOAD
1. Read CHAT_TRANSFER.md fully and fetch live main HEAD plus recursive tree.
2. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md, HANDOVER.md, BUILD_NOTES.md and the entire current .github/workflows/jexfyz-app-build-trigger.yml.
3. Read APP_BUILD_REPORT.md through to the latest attempt, including fixes, failures, test counts, source commit, signing, release-asset checks and outstanding gates. It is the authoritative execution ledger; older entries are history.
4. Inspect the live App source, relevant tests, dependency/package configuration, Android signing configuration and workflow contracts relevant to the current blocker.
5. Fetch current Actions runs, jobs/logs and Releases. Do not infer run status, package identity, tag target or artifact hashes from old notes.

CONTINUE THE BUILD — NO RECAP
- Determine whether the exact intended run is active, failed, cancelled, blocked or already complete.
- If active, inspect its actual jobs/logs and continue monitoring within this response's available tools; do not launch a duplicate run.
- If failed, identify the exact failing gate and fix an App-scope cause rather than weakening checks. Commit the justified fix to main, then trigger only the guarded issue workflow and verify the run targets the intended commit.
- Retry only after a concrete code/config fix or an evidence-backed transient infrastructure issue. Never retry blindly.
- If blocked by missing permissions, hosted runner, secrets/signing credentials, external service or a required owner/device action, record the precise blocker and stop. Do not claim success.
- Append each attempt, run ID, intended source SHA, failure evidence, fix, tests, APK/signature/release checks and result to APP_BUILD_REPORT.md while the operation progresses.
- Completion requires the live workflow's full gates, test/analyzer status, exactly one APK and corresponding source ZIP, signing/certificate validation, publication and downloaded-asset identity/checksum checks. Clearly separate CI evidence from physical-device/BLE/Firmware/OTA evidence.

BUILD-ONLY LIMITS
- This command authorizes only the guarded App Build/QC/release workflow and justified App-scope repairs required by it.
- It does not authorize Firmware compilation, BIN generation/publication, Firebase/production metadata changes, physical OTA, flash, device operations or unrelated releases.
- Do not change the workflow so push/PR automatically publishes an APK. Read and follow the live guarded issue trigger.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- If the build task has already passed all gates, verify the package from live evidence and do not launch another build without a new explicit request.

REPORT
Continue immediately from the last valid attempt. Keep the user-facing status concise, evidence-based and labeled RECOVERED, BLOCKED or FAILED when appropriate. Never return only a recap.

