# JE X FYZ — CHAT RULES

## 1. Chat workflow

This file contains the project-wide rules for how the JE X FYZ work is handled in ChatGPT. It is separate from App/Firmware engineering notes.

### Explicit command meanings

- `@Thinking Diskusi!` = discussion/review only. Do not modify source files, repository state, commits, or builds unless the user explicitly changes that instruction in the same request.
- `@Thinking Eksekusi!` = implement only the approved changes, update the relevant maintenance notes, and commit the changes. Do not build unless the user separately requests a build.
- `@Thinking Build App!` = run the App build/validation workflow against the intended current source. Do not make unrelated source changes during the build request.
- `@Thinking Eksekusi & Build App!` = implement the approved changes, update the relevant maintenance notes, commit them, then run the App build/validation workflow.

## 2. End-of-response status

Every assistant response in the JE X FYZ project chat must end with one clear workflow-status block so the next action is unambiguous.

Allowed status values:

- `🟡 STATUS: LANJUT DISKUSI` = analysis/review is still in progress.
- `🟢 STATUS: SIAP EKSEKUSI` = the root cause and implementation plan are sufficiently defined; the next implementation step can be `@Thinking Eksekusi!`.
- `🔵 STATUS: PERLU TANYA GEMINI` = a specific unresolved technical question should be independently checked before implementation.
- `🟣 STATUS: SIAP BUILD APP` = the approved implementation is complete and committed; the next validation step can be `@Thinking Build App!`.
- `🔴 STATUS: JANGAN EKSEKUSI DULU` = material uncertainty, missing evidence, or regression risk remains.

The status block must be the final content of the response.

## 3. Gemini second-opinion rule

Gemini is a second-opinion source, not an automatic decision-maker.

Use it only when:
- a concrete technical question remains unresolved after source inspection and available evidence, or
- an independent review would materially reduce implementation risk.

When requesting a Gemini opinion, define the exact question to verify. Do not replace source verification with a generic “ask Gemini”.

## 4. Source-first rule

Before proposing implementation, inspect the current repository/source state that actually controls the behavior under discussion.

Do not rely on old snippets, memory of earlier revisions, or assumptions when the current source can be checked.

## 5. Build separation

A repository commit, a healthy workflow, or a successful historical build is not by itself proof that the current source has been built.

App build validation must be explicitly requested through the project workflow.

## 6. Chat continuity

Use one continuous project subchat for the JE X FYZ lifecycle.

When a subchat reaches its platform limit, create a copy-ready handover prompt containing:
- current repository state
- relevant commits
- source versions
- completed changes
- validation evidence
- pending work
- known risks
- exact next step

Continue from that handover rather than restarting the project history.

## 7. Maintenance-note rule

Every implementation change must update the relevant maintenance record in the same workflow:
- App changes → `APP_NOTES.md`
- Firmware changes → `FIRMWARE_NOTES.md`
- Chat/process rules → `CHAT_RULES.md`

Process-rule changes belong in this file and should not be duplicated into App or Firmware notes unless they are also relevant engineering history.

## 8. Memory and notes must always be read

At the start of every relevant JE X FYZ task, the assistant must read the available project memory and the authoritative project notes before making conclusions or proposing changes.

This includes, as applicable:
- prior conversation/context memory
- `CHAT_RULES.md`
- `APP_NOTES.md`
- `FIRMWARE_NOTES.md`
- current repository/source files relevant to the task
- any user-provided evidence or attachments relevant to the behavior

The assistant must use the newest verified information and must not silently rely on stale memory when a current note or source file can be checked.

When a task crosses App, Firmware, Android, CI, or process boundaries, read the corresponding notes rather than assuming the other layer is unchanged.

## 9. Mandatory chat-limit handover

When the active subchat reaches, or is close enough to, its platform/context limit that continuity may be lost, the assistant must prepare a complete copy-ready handover prompt for the next chat.

The handover must summarize the project state from the beginning of the current subchat through its latest state, not only the most recent issue.

The handover prompt must contain, with as much verified detail as available:
- project identity and architecture
- repositories and repository boundaries
- current App and Firmware versions
- current source/branch/HEAD state and relevant commit SHAs
- all meaningful changes made during the subchat
- confirmed bugs and their symptoms
- root-cause findings and competing hypotheses
- user-requested behavior and frozen requirements
- BLE/P1/API/UUID contracts relevant to continuation
- Android/runtime/OTA/CI constraints relevant to continuation
- validation already completed, including exact build/run IDs and artifact evidence when applicable
- physical/device validation status and what remains unverified
- known risks, regressions, unresolved questions, and why they remain unresolved
- exact files/areas to inspect next
- exact next action for the new chat
- current workflow status (Diskusi, Eksekusi, Build, Perlu Gemini, etc.)
- the required first step in the new chat, including any source/notes that must be re-read before continuing

The final handover must be written as a single ready-to-copy prompt, with explicit instructions to continue from the recorded state rather than restart the project.

Do not compress away important technical details merely to make the handover shorter. Accuracy and continuity take priority.

The handover is documentation/continuity work only unless the user separately authorizes implementation or build.
