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
