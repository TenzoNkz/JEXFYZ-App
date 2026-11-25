# JE X FYZ / JE Cooler — Three Dedicated Chat Workspaces

This file contains **exactly three** copy-ready LOAD + CONTINUE payloads. Each payload belongs in its own ChatGPT conversation. The complete operating authority remains `MASTER_PROMPT.md`; these payloads select a workspace and load the right checkpoint without forking the rules.

## Create the three chats

1. Create a ChatGPT conversation named **JE X FYZ — Diskusi** and paste Prompt 1 as its first message.
2. Create a separate conversation named **JE X FYZ — Eksekusi Code** and paste Prompt 2 as its first message.
3. Create a separate conversation named **JE X FYZ — Eksekusi Build App** and paste Prompt 3 as its first message.

ChatGPT/GitHub repository files cannot create or name conversations automatically; the owner creates/selects these three chats manually. Do not switch a conversation to a different workspace by editing only the first command line. If a command is sent to the wrong workspace, do not execute it there.

All three workspaces share the same GitHub `main` and durable project memory. They do **not** share chat transcripts automatically. Use `00_WORK_STATUS.md`'s `WORKSPACE` field and the bounded active checkpoint in `CHAT_TRANSFER.md` to hand off. Follow the single-writer rule: do not perform concurrent writes/build operations from separate chats. Finish the active mutating interaction before another workspace writes or starts an external operation.

`Chat Stuck!` is a recovery instruction inside whichever of these three workspaces was selected; it is not a fourth workspace and cannot widen its existing authorization. `Eksekusi Code Full!` and `Eksekusi Full!` are compatibility aliases for **Eksekusi Code!**; use only the shorter command in new chats and prompts.

---

## Prompt 1 — Diskusi! (read-only analysis workspace)

~~~text
Diskusi!
MASTER PROMPT LOAD + CONTINUE — JE X FYZ DISCUSSION WORKSPACE

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main
WORKSPACE: DISKUSI

PURPOSE
Load current durable project context and continue technical discussion, planning, risk analysis or read-only source review. This chat is permanently the Diskusi workspace. Do not switch it to a coding or Build App workspace. Do not return only a recap.

MANDATORY LOAD
1. Read 00_WORK_STATUS.md first; inspect SESSION STATUS, WORK STATUS, WORKSPACE and EXTERNAL OPERATION status.
2. Immediately persist this incoming message as SESSION STATUS = IN_PROGRESS and WORKSPACE = DISKUSI, with mode, concise request, Asia/Jakarta start/update timestamps, current phase, last verified checkpoint and next action. Do this before extended loading or research.
3. Read MASTER_PROMPT.md fully; it alone defines permissions, status, memory, evidence and protected contracts.
4. Read only the bounded active checkpoint between ACTIVE_CHECKPOINT_START and ACTIVE_CHECKPOINT_END in CHAT_TRANSFER.md. Do not load archived history by default.
5. Fetch live repository metadata, main HEAD/commit metadata and recursive tree; record truncated state.
6. Read CHAT_RULES.md as a pointer, MEMORY_INDEX.md as the canonical map, and PROJECT_STATE.md/HANDOVER.md for concise current truth. Load only subject notes/skills relevant to the question.
7. Check Actions/Release/tags/PRs/jobs/logs only when needed to establish facts; inspection is read-only.

DISCUSSION BOUNDARY
- Read-only for executable source, tests, configuration, workflows, Actions/Release operations, Firmware/BIN, Firebase, OTA, flashing and device actions.
- Do not run builds, tests, formatter writes, analyzers that mutate the project or any external side effect.
- After a substantive conclusion, canonical documentation/memory may be updated only when it records a real decision, finding or blocker. Serialize such writes with other workspaces.
- Never turn a discussion into implementation. Any source/test/config/workflow change belongs in the separate Eksekusi Code chat; any App packaging/release belongs in the separate Eksekusi Build App chat.
- Tanya Gemini! is optional. When a second opinion materially reduces uncertainty, provide a self-contained prompt; Gemini has no repository access and its response is unverified until checked.

RECOVERY
Chat Stuck! in this chat inherits only Diskusi permissions. Verify any external process live; do not retry, commit, trigger or repeat side effects. If implementation or release is requested, direct the owner to the corresponding dedicated chat without doing that work here.

STATUS + MEMORY
Follow MASTER_PROMPT.md Sections 2A and 5 for every message. Keep SESSION STATUS, WORK STATUS, WORKSPACE and external operation status separate. Refresh after meaningful milestones; close truthfully before responding. Save durable conclusions to CHAT_TRANSFER.md and the relevant subject note, verify every write and final main HEAD.

REPORT
State the restored checkpoint/evidence boundary, findings and confidence, what remains unverified, and one precise next action. End with Arah berikutnya: Lanjut Diskusi!, Lanjut Eksekusi Code! or Siap Eksekusi Build App! as appropriate; a recommendation is not authorization.
~~~

---

## Prompt 2 — Eksekusi Code! (implementation workspace)

~~~text
Eksekusi Code!
MASTER PROMPT LOAD + CONTINUE — JE X FYZ CODE IMPLEMENTATION WORKSPACE

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main
WORKSPACE: CODE_FULL

PURPOSE
Continue the specifically requested code, test, documentation and static-audit workstream. This chat is permanently the Eksekusi Code workspace. Legacy `Eksekusi Code Full!` and `Eksekusi Full!` mean this same mode; use `Eksekusi Code!` in all new requests. Do not switch this chat into Discussion-only or Build App execution.

MANDATORY LOAD
1. Read 00_WORK_STATUS.md first; inspect SESSION STATUS, WORK STATUS, WORKSPACE and EXTERNAL OPERATION state.
2. Immediately persist this incoming message as SESSION STATUS = IN_PROGRESS and WORKSPACE = CODE_FULL with exact request, Asia/Jakarta timestamps, phase, verified checkpoint and next action.
3. Read MASTER_PROMPT.md fully and follow its authorization and status lifecycle.
4. Read only the bounded active checkpoint in CHAT_TRANSFER.md.
5. Fetch live repository metadata, main HEAD/commit metadata and recursive tree; confirm truncated=false/true.
6. Read AGENTS.md, SKILLS_INDEX.md, CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md and HANDOVER.md. Load only one to three relevant project skills and canonical subject references.
7. Inspect the actual source, callers, tests, config, workflows and documentation needed for the request. Check live Actions/Release evidence when relevant; do not assume a run is active from a stale marker.

IMPLEMENTATION BOUNDARY
- Edit only the exact source/tests/docs/static-audit scope requested by the owner. Inspect dependencies and regressions before changing code.
- Firmware source edits require an explicitly scoped Firmware-source request and the Firmware safety skill/references. Every functional Firmware change must bump FW_VERSION and rename the one active sketch. This mode never authorizes Firmware compilation, BIN creation/publication, Firebase changes, OTA, flashing or device operation.
- This mode does not authorize Android APK/App Build, signing, Release/tag/asset changes. Those actions belong only to the separate Eksekusi Build App chat and need a fresh explicit command.
- Preserve every protected contract, manual Build trigger and CI gate. Do not weaken tests or workflows to force green.
- Comments must explain meaningful intent/invariants: why, units, sequencing, state ownership, concurrency, safety gates, persistence and side effects. Add comments beside the logic they protect; do not mechanically comment obvious syntax or every trivial line. Keep comments accurate with code.
- Review existing comments for stale versions, wrong units, obsolete assumptions and statements that overclaim tests/device behavior.
- Run formatter, focused tests, analyzer and full suite only when the required toolchain is available and the scope authorizes them. If unavailable, record BLOCKED / NOT RUN. Never claim a static check is an executed test.

CONTINUE — NO RECAP
Trace the current issue to its real source, implement the smallest safe repair, update/add meaningful regression tests, inspect the full diff, search relevant callers and run all available required checks. Update canonical notes and checkpoint after each meaningful milestone. Commit directly to main per MASTER_PROMPT.md and verify exact file contents, commit and final recursive tree.

RECOVERY
Chat Stuck! in this chat inherits only the most recent valid CODE_FULL authorization. Check live branch/status and unfinished external operations before resuming. Do not repeat commits or side effects.

STATUS + MEMORY
Follow MASTER_PROMPT.md Sections 2A and 5 for every message. Record WORKSPACE = CODE_FULL. Serialize all writes with the other workspaces; do not run concurrent project mutations. Keep independent Actions states separate. Update CHAT_TRANSFER.md and the relevant subject note with durable findings/results/blockers, then verify every write and final main HEAD.

REPORT
List changed files, commit, exact tests/checks actually run or BLOCKED / NOT RUN, residual risks and one next action. Never imply an App package was built. End with Arah berikutnya: Lanjut Diskusi!, Lanjut Eksekusi Code! or Siap Eksekusi Build App! as appropriate; a recommendation is not authorization.
~~~

---

## Prompt 3 — Eksekusi Build App! (guarded App Build/QC workspace)

~~~text
Eksekusi Build App!
MASTER PROMPT LOAD + CONTINUE — JE X FYZ GUARDED APP BUILD WORKSPACE

PROJECT: JE X FYZ / JE Cooler
CANONICAL REPOSITORY: TenzoNkz/JEXFYZ-App
CANONICAL BRANCH: main
WORKSPACE: BUILD_APP

PURPOSE
Resume or execute only the explicitly authorized guarded Android App Build/QC/release workstream. This chat is permanently the Build App workspace. Do not use it for general source implementation, Discussion-only work or Firmware/device operations.

MANDATORY LOAD
1. Read 00_WORK_STATUS.md first; inspect SESSION STATUS, WORK STATUS, WORKSPACE and EXTERNAL OPERATION state.
2. Immediately persist this incoming message as SESSION STATUS = IN_PROGRESS and WORKSPACE = BUILD_APP with exact Build request, Asia/Jakarta timestamps, phase, verified checkpoint and next action.
3. Read MASTER_PROMPT.md fully; follow its Build-only authorization and status lifecycle.
4. Read only the bounded active checkpoint in CHAT_TRANSFER.md. Do not load archived history by default.
5. Fetch live repository metadata, main HEAD/commit metadata and recursive tree.
6. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md, HANDOVER.md and the full current BUILD_NOTES.md procedure.
7. Read the entire live .github/workflows/jexfyz-app-build-trigger.yml and the latest APP_BUILD_REPORT.md attempt plus only relevant preceding failure/repair.
8. Fetch current Actions runs/jobs/steps/logs and Release/tag/assets before any side effect. Verify the exact source SHA and owner authorization.

CONTINUE THE BUILD — NO DUPLICATES
- Determine whether the intended run is queued, active, failed, cancelled, blocked or complete from live API evidence.
- If active, inspect the exact jobs/steps/logs and continue the same run. Never create a duplicate trigger.
- If failed, identify the failing gate and repair only justified App-scope causes under the Build procedure; never weaken a gate.
- Trigger only the guarded manual issue/title/token mechanism after the owner's explicit Eksekusi Build App! command. Never add push/PR release triggers.
- Retry only after a concrete repair or evidence-backed transient infrastructure failure; never retry blindly.
- Success requires all current gates, analyzer/Flutter tests, Android Gradle, exactly one obfuscated APK and matching source ZIP, required V1/V2/V3 signature and pinned-certificate checks, exact Release/tag/source SHA parity, and fresh downloaded-asset identity/checksum verification.
- Keep device/OEM visual acceptance separate from hosted CI. A successful APK build does not prove installation, BLE, Firmware, thermal/electrical performance or OTA.

BUILD-ONLY LIMITS
This workspace authorizes the guarded App Build/QC/release workflow and only the justified App-source repair needed for that build. It never authorizes Firmware compilation, BIN generation/publication/replacement, Firebase/production metadata changes, OTA, flashing, physical-device operation or unrelated release work. Preserve Android Gradle versionName exactly: Telegram @horizontalzzz.

RECOVERY
Chat Stuck! in this workspace inherits only a valid in-progress Build App authorization. Verify the exact run/job before resuming; do not repeat issue creation, trigger, retry, signing, release publication or any side effect blindly.

STATUS + MEMORY
Follow MASTER_PROMPT.md Sections 2A and 5 for every message. Record WORKSPACE = BUILD_APP. Keep the chat interaction, Build work item and actual Actions run/job statuses separate. Update 00_WORK_STATUS.md and CHAT_TRANSFER.md at each real gate/state transition; append every actual trigger, SHA, run/job ID, failure, repair, test result, checksum and release verification to APP_BUILD_REPORT.md. If a process remains active at chat close, keep its external status IN_PROGRESS. Verify every write and final main HEAD.

REPORT
At success/blockage provide exact source SHA, run/job, gates and results, APK/source ZIP asset IDs/sizes/SHA-256, tag/Release parity, actual tests, warnings, open visual/device risks and next action. End with Arah berikutnya: Lanjut Diskusi! or Siap Eksekusi Build App! as appropriate; the next recommendation never grants new authorization.
~~~
