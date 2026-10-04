## 2026-10-04 — CHAT-LIMIT HANDOVER CHECKPOINT

- Current chat is being handed over because the context limit is near.
- README.md already contains the detailed copy-ready new-chat prompt and is the mandatory first-read entry point.
- HANDOVER.md is the portable handoff artifact; the embedded prompt remains the required continuation prompt.
- Current firmware remains V3.7; active source is `firmware/JEXFYZ-V3.7.ino`.
- Latest verified App Build remains #50; no App Build was triggered by this handover checkpoint.
- Firmware V3.7 ArduinoDroid/Core 3.3.7 compile, BIN publication, Firebase promotion, and physical validation remain unperformed.
- Next chat must perform the full repository memory preflight before any action.

## 2026-10-04 — PROCESS RULE / ALL-MEMORY SYNCHRONIZATION MATRIX

- Every meaningful JE X FYZ event must perform a synchronization pass across the complete memory stack before the event is considered complete.
- Mandatory memory stack:
  - `README.md`
  - `PROJECT_STATE.md`
  - `CHAT_RULES.md`
  - `APP_NOTES.md`
  - `FIRMWARE_NOTES.md`
  - `BUILD_NOTES.md`
  - `CHANGELOG.md`
  - `HANDOVER.md`
  - `CHAT_TRANSFER.md`
  - `firmware/FIRMWARE_ANALYSIS.md` when firmware context is relevant
- `PROJECT_STATE.md` is the mandatory current-state checkpoint after every meaningful event.
- Other memory files must be updated whenever that event changes their knowledge domain; if a file does not need textual change, it must still be considered during the synchronization pass rather than silently skipped.
- A Discussion event may therefore create memory-only commits while leaving functional source/build/release untouched.
- An Execution or Build event must never finish with source changes that are absent from the persistent memory record.
- This matrix exists specifically so a chat/subchat reaching its context limit cannot discard a requirement, decision, change, build fact, failure, or validation result merely because the user did not explicitly request a memory update.

## 2026-10-04 — EXECUTION FULL / MEMORY FOUNDATION BOOTSTRAP

- Completed the persistent continuity architecture requested for JE X FYZ.
- Confirmed `README.md` is the mandatory first-read project operating manual and contains the detailed copy-ready new-chat prompt.
- Confirmed `BUILD_NOTES.md`, `CHANGELOG.md`, and `HANDOVER.md` are persistent continuity artifacts.
- Added the missing `PROJECT_STATE.md` snapshot in the final step of this execution so the repository has a single current-state checkpoint.
- Mandatory preflight now includes every memory layer before any project action, including Build App subchats.
- Automatic memory synchronization is part of every meaningful Discussion, Execution, Build, Gemini, compile/test, and hardware-test workflow; the user does not need to request a memory update.
- A successful App Build is a persistent memory checkpoint and must preserve the exact source SHA, run/artifact evidence, all changes included, gates, and remaining validation boundary.
- This execution made no functional App/Firmware behavior change and did not trigger App Build or firmware compilation.

## 2026-10-04 — EXECUTION FULL / PERMANENT MEMORY ARCHITECTURE

- Added `README.md` as the mandatory project operating manual and new-chat entry point.
- Added `PROJECT_STATE.md` as the current-state snapshot.
- Added `BUILD_NOTES.md` as Build App continuity/artifact memory.
- Added `CHANGELOG.md` as milestone/version history.
- Added `HANDOVER.md` as a portable copy-ready continuation prompt.
- Formalized mandatory memory preflight for every project action, including separate Build App subchats.
- Formalized automatic memory synchronization after every meaningful Discussion, Execution, Build, Gemini review, compile/test attempt, runtime observation, or rules change.
- Updated Discussion semantics: `@Thinking Diskusi!` remains functional-source/build/release read-only, but memory-only documentation may be synchronized automatically so context is not lost.
- Build App is explicitly treated as a complex engineering workflow; successful builds are persistent memory checkpoints containing source SHA, run/artifact evidence, all included changes, gates, and remaining validation boundaries.
- Chat-limit handling now requires memory synchronization plus a refreshable `PROJECT_STATE.md` and `HANDOVER.md` before continuity is handed to a new chat.
## 2026-10-04 — PROCESS RULE / MANDATORY MEMORY PREFLIGHT + BUILD-SUBCHAT CONTINUITY

- Before **any** JE X FYZ project action, including reading/analyzing source, discussion, execution, audit, Build App, Gemini review, compile/build attempt, or test-result interpretation, the assistant must re-read the current project memory before acting.
- Mandatory preflight order is:
  1. `README.md` — project operating manual and continuation entry point.
  2. `PROJECT_STATE.md` — current project snapshot.
  3. `CHAT_RULES.md` — workflow/process rules.
  4. `APP_NOTES.md` — App contract and App history.
  5. `FIRMWARE_NOTES.md` — Firmware contract and Firmware history.
  6. `BUILD_NOTES.md` — Build App checkpoints and artifact continuity.
  7. `CHANGELOG.md` — milestone/version history.
  8. `HANDOVER.md` — portable continuity context when present.
  9. `firmware/FIRMWARE_ANALYSIS.md` — firmware architecture/safety map when firmware context is relevant.
  7. Inspect the current repository source/workflow that actually controls the task.
- For **Build App**, this preflight is mandatory even though Build App may run in a separate subchat. A Build App chat must not rely on remembered context from a previous chat; it must rebuild context from repository memory and current source.
- A Build App workflow is therefore treated as a full engineering continuity workflow, not as a short artifact-generation shortcut.
- Before Build App starts, record the exact App source/commit intended for the build, relevant workflow file/trigger, current release/version state, latest known successful build, and all known unresolved risks.
- After **every successful App Build**, automatically synchronize the project memory without waiting for a user reminder. At minimum record:
  - exact source commit/SHA that was built;
  - workflow/run identifier and result;
  - build number/version if changed;
  - artifact name, artifact ID, size, and checksum when available;
  - all source/config/workflow/dependency changes included since the prior successful build;
  - any build-only troubleshooting changes or files changed during the build workflow;
  - validation gates that passed/failed;
  - what was not validated (especially physical firmware/device state);
  - exact next state/action.
- A successful build is not only an artifact result; it is a **memory checkpoint**. The repository memory must describe what changed so a future Build App chat can understand the build without the user reconstructing the history.
- If the build changes anything, the corresponding App/process/memory records must be updated in the same Build App workflow. If only build metadata changed, record that metadata explicitly.
- When Build App uses a separate subchat, the handover/current-state memory must be sufficient for the new chat to continue without relying on the previous conversation.
- This rule applies to every project workflow, not only Build App: each meaningful Discussion, Execution, Audit, Gemini review, Compile, Build, or Hardware Test must leave persistent current-state/memory information before continuity can be considered complete.

## 2026-10-04 — EXECUTION FULL / V3.7 ANALYSIS DOCUMENT FINALIZATION

- Added the repository-level firmware analysis map at `firmware/FIRMWARE_ANALYSIS.md`.
- The document records the authoritative V3.7 control/safety contract and a critical-function source map.
- No firmware behavior or App behavior was changed by this documentation-only addition.
- Analysis document commit: `e2ab50edeb428e95ce21a9b5a54e169d904ade84`.
- Main branch current HEAD after this documentation pass: `e2ab50edeb428e95ce21a9b5a54e169d904ade84`.
- Validation boundary remains source/static audit only; App Build and physical firmware validation were not triggered.

## 2026-10-04 — EXECUTION FULL / V3.7 SOURCE DOCUMENTATION + REPOSITORY CLEANUP

- User explicitly authorized `@Thinking Eksekusi Full!`.
- Authoritative source was re-read from `firmware/JEXFYZ-V3.7.ino` before editing.
- Functional firmware version remains **V3.7**; this pass is documentation/cleanup only and does not introduce a new functional version.
- Source cleanup completed:
  - added an authoritative firmware contract block at the top of the source;
  - added a contract comment block before every detected firmware function definition (**136** function contracts);
  - added detailed line-level intent comments around Peltier PWM, output interlocks, voltage transitions, Hotside safety, Adaptive timing, BLE radio handoff, OTA, setup, and loop;
  - normalized mixed-language comments to English;
  - removed stale version/baseline references;
  - separated a joined declaration and removed unnecessary blank-line runs;
  - normalized a split OTA state case and retained the existing non-blocking architecture.
- Static C++-aware scan after the documentation pass:
  - `FW_VERSION = V3.7`: 1;
  - stale V3.5/V3.6 and old V1.0 baseline references: 0;
  - executable `delay(...)`: 0;
  - timing `while(...)`: 0;
  - braces: 535/535;
  - parentheses: 2002/2002;
  - function contract blocks: 136;
  - comment lines: 779.
- Source commit: `ef4519b8f4d032a6d2d1f84101785c05b8a89cfa`; source blob: `4a7e08a6ea0de57f4e3d3a742ad88cbd25a05e01`.
- No App source change, App Build, BIN generation, Firebase promotion, dedicated binary-repository update, or physical validation was performed.
- Next firmware validation boundary remains ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compilation, followed by real-device validation.

## 2026-10-04 — EXECUTION FULL / V3.7 PELTIER PWM SOFT-START

- User authorized combined **Diskusi & Eksekusi** after identifying the required Peltier PWM rule.
- The authoritative source was located in the App repository at `firmware/JEXFYZ-V3.6.ino`; the prior dedicated firmware repository is binary-only.
- Implemented V3.7: upward voltage transitions restart the 5-second Peltier PWM soft-start; downward transitions do not; Peltier OFF → ON always soft-starts.
- Updated firmware continuity source, retired V3.6 source, and recorded the App/Firmware/chat maintenance entries.
- No App Build was triggered.
- Next firmware validation remains ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compilation, then hardware validation.
  
## 2026-10-04 — EXECUTION FULL / V3.6 UNIVERSAL HOTSIDE SAFETY FLOW

- User explicitly authorized `@Thinking Eksekusi Full!`.
- Firmware source advanced V3.5 → V3.6 after implementing the finalized Adaptive/Manual Hotside safety flow and hardening two authority-boundary cases found during full regression.
- Current firmware source: `firmware/JEXFYZ-V3.6.ino`; source commit: `03ede906a34a5e06082f2c9520a29687f0abd710`.
- Maintenance notes were updated for Firmware, App contract, and Chat workflow.
- No App Build, firmware BIN promotion, Firebase update, dedicated binary-repository update, or physical validation was performed.
- Static checks passed for delimiter balance, required function uniqueness, no executable `delay()`, and no timing `while` loop.
- Next validation layer remains ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compilation, followed by BIN/device validation.
- The V3.6 safety contract is: one universal Hotside Limit; Manual hot → force 5V + Peltier safety latch + Fan ON; Adaptive hot → immediate one-level down + voltage ceiling reduction + Peltier OFF 5s after the down-step; Adaptive at 5V hot → Adaptive OFF; Hotside LED event → red blink 5s; Adaptive controls keep Voltage/Control/Temperature locked while active.
## 2026-10-04 — CORRECTIVE EXECUTION FULL / V3.4 SOURCE-STRUCTURE REPAIR
- Current corrective firmware HEAD: `2182794cb98964a8a7432d0ea75587b44b508573`.

- Exact-source post-commit verification of V3.3 detected malformed helper placement that a delimiter-only audit did not catch.
- The affected helpers were moved to global scope and the firmware version advanced V3.3 → V3.4 according to the project versioning rule.
- The corrected source passes delimiter, no-delay/no-timing-loop, and global function-definition-depth checks.
- No App Build, firmware BIN/Firebase promotion, dedicated binary-repository update, or physical validation was performed.

## 2026-10-04 — EXECUTION FULL / FIRMWARE V3.3 EVENT

- User explicitly authorized `@Thinking Eksekusi Full!` after the V3.2 discussion.
- Firmware source advanced to V3.3 with the approved Hotside-only 12V behavior, runtime Battery-loss fallback, LED brightness 1–100%, Online OTA 20/40/60/80/100 yellow flashes, and cooperative no-delay timing.
- Full affected-area audit found and repaired two latent V3.2 source-structure issues: an undefined `updateBatteryValidity()` call and duplicate active `lowerVoltage()` definitions.
- No App Build, firmware BIN/Firebase promotion, dedicated binary-repository update, or physical validation was performed.
- #118 and #124 were deliberately not guessed because their numbered descriptions were not present in the authoritative notes inspected for this execution.
- Next validation boundary is ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile, followed by BIN and physical-device validation.

## 2026-10-04 — FOLLOW-UP EXECUTION FULL EVENT / FIRMWARE V3.2

- Full regression of V3.1 identified an authority-boundary edge case in the deadtime revalidation logic.
- Firmware continuity source advanced V3.1 → V3.2.
- Added explicit voltage-transition source tracking so Battery Adaptive can retarget/cancel only Battery-originated in-flight transitions.
- Safety/HOTSTEP/Adaptive/manual/touch voltage transitions are protected from Battery revalidation.
- No App Build, firmware BIN publication, Firebase promotion, dedicated binary-repository update, or physical validation was performed.

## 2026-10-04 — FOLLOW-UP EXECUTION FULL EVENT / FIRMWARE V3.1

- Full regression of V3.0 identified and corrected a Battery Adaptive stale in-flight target during the 200 ms selector deadtime.
- Firmware continuity source advanced V3.0 → V3.1.
- V3.1 revalidates Battery target at deadtime completion, cancels stale steps, retargets direction changes, and arms the 1-second dwell after a canceled deadtime attempt to suppress immediate re-attempt chatter.
- No App Build, firmware BIN publication, Firebase promotion, dedicated binary-repository update, or physical validation was performed.
- Next firmware validation layer remains ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile.

## 2026-10-04 — EXECUTION FULL EVENT / FIRMWARE V3.0 BATTERY ADAPTIVE

- User issued @Thinking Eksekusi Full! after the Battery Adaptive + Gemini audit.
- Firmware continuity source advanced V2.9 → V3.0.
- Implemented no-hysteresis Battery Adaptive mapping, continuous target evaluation, stale-target cancellation, one-step voltage movement, and a unified 1-second voltage dwell measured from completed physical voltage transition.
- Battery Adaptive no longer bypasses the voltage guard on downward movement.
- Retired Battery hysteresis/stable-zone/pending-state logic was removed from the active firmware source.
- No App Build, firmware BIN publication, Firebase promotion, dedicated binary-repository update, or physical validation was performed.
- Next firmware validation layer remains ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile, followed by BIN/device validation before any binary release promotion.

## 2026-10-03 — EXECUTION EVENT / FIRMWARE V2.9

- User issued @Thinking Eksekusi! after the V2.7 audit decisions.
- Implemented the approved firmware Touch, per-voltage-color cleanup, VOLTAGE-only guard narrowing, and conservative OTA-cap changes.
- Firmware source was versioned to V2.9. Intermediate V2.8 was immediately superseded by V2.9 to preserve the already-accepted Touch Adaptive-OFF indicator path.
- Active implementation commit: 5254ac4112aba63429ee075497f165d253541649.
- No App Build was triggered. No firmware BIN, Firebase metadata, or physical device validation was performed.
- Static source validation passed; ArduinoDroid/Core 3.3.7 compilation remains the next firmware validation layer.

## 2026-10-03 — V2.7 AUDIT EVENT / GROUPS M–S

- User continued the numbered firmware audit through groups M–S.
- Decisions and implementation boundaries were recorded in FIRMWARE_NOTES.md and APP_NOTES.md.
- #81 remains a recommended conservative 1.75 MB Local/Online OTA hard cap, pending explicit execution; the current 2 MB source limit remains unchanged until then.
- No source change or App Build was performed during this discussion event.

## 2026-10-02 — V2.7 AUDIT / GROUPS H–L REVIEW EVENT

- User continued the numbered firmware audit in @Thinking Diskusi! mode.
- No source/repository implementation or App Build was authorized by this audit event.
- Audit decisions and exact pending implementation requirements were recorded in the maintenance notes so later execution can use the same baseline without losing detail.
- Point #39 Touch requires special care: the final implementation should not allow a 3+ tap sequence to accidentally trigger single- or double-tap actions.

## 2026-10-02 — V2.7 FIRMWARE EXECUTION EVENT\n\n- User explicitly changed workflow from discussion to execution and authorized the approved V2.6 audit corrections to be implemented first, with discussion to continue afterward.\n- Functional firmware work followed the frozen command semantics: source change + firmware version increment + maintenance-note update + commit, without triggering App Build.\n- No App Build was run during this execution because Build App remains a separate explicit workflow.\n- The execution preserved the project rule that firmware source/BIN/Firebase/device validation are separate layers.\n\n## 2026-10-02 — FULL GEMINI REVIEW AUTHORIZATION / AUDIT WORKFLOW

- User explicitly granted the assistant discretion to request Gemini second opinions whenever technically useful during JE X FYZ analysis.
- This does not change Gemini's role: Gemini remains a second-opinion source, never an automatic decision-maker, and no Gemini result may be fabricated.
- The assistant may formulate focused follow-up Gemini questions when a first answer is incomplete, conflicting, overly broad, or materially important to implementation risk.
- Source inspection and verified project evidence remain authoritative over third-party suggestions.
- During @Thinking Diskusi!, Gemini review and note updates do not authorize source/repository/build changes; implementation still requires an explicit execution command.
- Current firmware audit workflow is proceeding group-by-group from the numbered V2.6 inventory, with decisions recorded only after discussion/evidence review.

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
## 2026-10-04 — EXECUTION FULL / DUAL CHAT-LIMIT PROMPT SYSTEM

- Formalized a two-stage chat-limit continuity system.
- Prompt A — CHAT-LIMIT RECAP is used in the old chat after a context-limit warning. It exports the complete available chat context into a structured JE X FYZ CHAT RECAP PACKAGE, including requirements, decisions, source/commit/build evidence, bugs, root causes, hypotheses, validation, Gemini results, dead ends, risks, unresolved questions, chat-only data, and the exact next action.
- Prompt B — NEW CHAT TRANSFER is used in the new chat. It treats Prompt A output as transfer evidence only, performs the mandatory full memory preflight, inspects current source/workflow, reconciles the package against repository truth, and only then continues the permitted workflow.
- Current source/current workflow remain the highest authority. The recap cannot override newer repository state.
- Prompt B is mandatory for separate Build App subchats as well; a recap does not replace the Build App memory/source/workflow preflight.
- This execution changed documentation/process only. No functional App or Firmware source was changed and no Build App was triggered.

### 9A. Prompt 1 — CHAT-LIMIT RECAP

When the platform shows or is reasonably close to showing a chat/context-limit warning, the old chat must use the official **PROMPT 1 — CHAT-LIMIT RECAP** from README.md/HANDOVER.md.

Prompt 1 must:
- reconstruct the whole available chat, not only the last exchange;
- preserve requirements, decisions, source changes, commits, builds, tests, bugs, root causes, hypotheses, Gemini results, dead ends, risks, open questions, and exact next action;
- classify facts as VERIFIED, CONFIRMED, USER REQUIREMENT, IMPLEMENTED, COMMITTED, BUILT, TESTED, UNVERIFIED, HYPOTHESIS, OBSOLETE, REJECTED, BLOCKED, or OPEN QUESTION as appropriate;
- distinguish persistent repository memory from chat-only information;
- never invent missing evidence;
- produce exactly one complete JE X FYZ CHAT RECAP PACKAGE.

Prompt 1 is context export only. It does not authorize implementation or build.

### 9B. Prompt 2 — NEW CHAT TRANSFER

The new chat must use the official **PROMPT 2 — NEW CHAT TRANSFER** with the complete Prompt A package.

Prompt 2 must:
- perform the full mandatory memory preflight before acting;
- inspect the current source/workflow;
- compare the recap against current repository truth;
- reconcile mismatches rather than trusting the recap blindly;
- treat the recap as transfer evidence, not source of truth;
- establish the current project baseline before continuing;
- preserve obsolete/history records without allowing them to override current truth;
- apply the same rules to separate Build App subchats.

Prompt 2 does not permit Build App by itself. Build permission still follows the frozen workflow commands and build policy.

### 9C. Repository-First Transfer Semantics

The canonical continuity flow is now:

```
OLD CHAT
  ↓
PROMPT 1 — READ CHAT + RECONCILE + SAVE TO REPOSITORY
  ↓
PERSISTED CHAT RECAP / CURRENT STATE
  ↓
NEW CHAT
  ↓
PROMPT 2 — READ COMPLETE REPOSITORY + INSPECT CURRENT SOURCE/WORKFLOW
  ↓
CONTINUE FROM CURRENT PROJECT TRUTH
```

Prompt 1 is not merely a copy generator. Its intended final behavior is to
persist the complete available chat recap/state into the repository's
continuity layer before the old chat is abandoned.

Prompt 2 treats the repository as the transfer boundary. It must read the
complete mandatory memory stack and the persisted recap/state, then inspect
current source/workflow before continuing. Prompt 2 must never rely on the
old chat being available.

The persisted recap remains subordinate to current source/current workflow.
It records chat context that may otherwise be lost; it does not override
newer verified repository truth.


## 2026-10-04 — EXECUTION FULL / REPOSITORY-FIRST TRANSFER IMPLEMENTATION

- Finalized the repository-first two-prompt chat-limit model.
- Prompt 1 runs in the old chat, reads the complete available chat, reconciles it with repository evidence, and saves the complete transfer snapshot to CHAT_TRANSFER.md.
- Prompt 2 runs in the new chat, reads the full repository memory stack plus CHAT_TRANSFER.md, inspects current source/workflow, reconciles discrepancies, and continues from current project truth.
- CHAT_TRANSFER.md is a rolling transfer file; previous snapshots remain recoverable through Git history.
- This process change does not authorize or introduce functional App/Firmware changes.


## 10. MEMORY INTEGRITY / PROFESSIONAL REASONING

- Treat CHAT_RULES.md, APP_NOTES.md, and FIRMWARE_NOTES.md as the project's persistent working memory.
- At the start of relevant work, reread the authoritative memory sections and then inspect the current source that actually controls the behavior.
- Maintain explicit labels mentally and in notes for: user requirement, confirmed fact, verified evidence, working hypothesis, historical fact, and third-party suggestion.
- Never turn a plausible explanation into a root-cause claim without evidence.
- Newer verified source state overrides older source snippets and historical notes; do not resurrect superseded behavior accidentally.
- A successful build validates only the exact source revision it built. A build number alone is not proof for newer source.
- App UI state is not physical firmware evidence when firmware telemetry is the authority.
- Screenshot evidence proves only what is visibly shown; it does not prove hidden Android API state.
- Preserve frozen contracts and avoid broad refactors unless explicitly approved.
- Prefer the smallest technically sufficient change with a clear validation boundary.
- Before execution, identify exact files/layers to change and exactly what validation can and cannot prove.
- When evidence is insufficient, keep the status at PERLU TANYA GEMINI or JANGAN EKSEKUSI DULU instead of guessing.

## 11. DOCUMENTATION CONSOLIDATION

- When the user asks to update all notes, update CHAT_RULES.md, APP_NOTES.md, and FIRMWARE_NOTES.md as applicable.
- Put current truth into an explicit AUTHORITATIVE MEMORY CORE at the top of APP_NOTES.md and FIRMWARE_NOTES.md.
- Preserve historical revision logs; do not rewrite history merely to remove contradictions.
- When historical entries conflict with current truth, resolve the conflict in the current memory core and explicitly mark old statements as historical/obsolete where necessary.
- Record current source, branch, commit, build, validation, and unresolved-risk state. Especially record what has NOT been validated.
- Process/chat rules belong in CHAT_RULES.md; App engineering belongs in APP_NOTES.md; firmware engineering belongs in FIRMWARE_NOTES.md.

## 12. CHAT-LIMIT HANDOVER STANDARD

- When the active chat reaches or approaches its platform/context limit, create one single copy-ready continuation prompt.
- The handover must cover the entire current subchat from beginning to latest state, not only the last issue.
- Include: project identity, architecture, repos, repo boundaries, current versions, current source/branch/HEAD, relevant commit SHAs, all meaningful changes, confirmed bugs/symptoms, root-cause findings, competing hypotheses, frozen requirements, BLE/P1/UUID/API contracts, Android/OTA/CI constraints, completed validation with exact run/artifact evidence, physical validation status, known risks, unresolved questions, exact files to inspect, exact next action, current workflow status, and the required first read/verification steps for the new chat.
- Preserve tested dead ends and failed attempts when they prevent repeating known mistakes.
- Make the handover a single prompt that can be copied directly into the new chat.
- Accuracy and continuity have priority over brevity.
- Handover generation itself does not authorize source changes or builds.

## 13. RESPONSE-END STATUS REQUIREMENT

- Every response must end with exactly one clear project workflow status block.
- The status block must be the final content of the response.
- The status must reflect actual evidence, not optimism.

## 14. MANDATORY FIRMWARE VERSIONING

- Every functional firmware/source change that can affect the firmware image must increment the firmware version before that changed source is treated as an OTA candidate.
- Example: V2.4 -> V2.5 for the next functional firmware change.
- Documentation-only changes do not require a firmware version bump.
- A firmware source version bump does **not** by itself mean the BIN, Firebase metadata, or physical device has been updated.
- The exact workflow is:
  1. change firmware source;
  2. increment `FW_VERSION`;
  3. keep the source filename/version aligned when the project uses versioned source filenames;
  4. update firmware notes;
  5. compile with ArduinoDroid + official Arduino-ESP32 Core 3.3.7;
  6. verify the resulting BIN;
  7. only then promote the OTA/Firebase version metadata;
  8. only claim device/runtime validation after the binary is actually flashed and tested.
- Never reuse an older firmware version for a new functional firmware image merely because the code change is small.

## 15. MANDATORY NOTES / EVENT RECORDING

- Notes are part of the project's persistent engineering memory and must be updated for **every JE X FYZ project workflow/event** (Diskusi, Eksekusi, Eksekusi Full, Build App, Tanya Gemini, audit, compile/build attempt, runtime/physical test, failure, or rules change), not only when source code changes.
- Record as applicable:
  - source/repository changes;
  - process/chat-rule changes;
  - build attempts and results;
  - compile attempts and failures;
  - runtime/device observations;
  - physical test results;
  - failed approaches/dead ends that prevent repetition;
  - validation boundaries;
  - unresolved risks/questions.
- Every implementation execution must update the relevant maintenance note in the same workflow. Every review/audit/build/test attempt must also record its outcome and validation boundary in the relevant note, even when no source change is made.
- If nothing was changed but a requested audit/review materially establishes a new verified fact or validation status, record that fact/status in the appropriate note.
- Never record an unverified physical, build, runtime, or third-party result as confirmed.

## 16. COMMAND SEMANTICS — FROZEN

- `@Thinking Diskusi!` -> discuss/audit/plan only; do not modify repository/source.
- `@Thinking Eksekusi!` -> implement the requested/approved change, update relevant notes, and commit; do not run App Build unless explicitly requested.
- `@Thinking Eksekusi Full!` -> implement the approved change plus a full affected-area audit, update all relevant notes, and commit; still do not run App Build unless explicitly requested.
- `@Thinking Diskusi & Eksekusi!` -> perform discussion sufficient to resolve the request, then execute the approved change in the same response/workflow; update notes and commit.
- `@Thinking Build App!` -> App build/validation only in the dedicated Build App workflow/chat; do not make unrelated source changes.
- `@Thinking Tanya Gemini!` -> obtain/analyze a specific second opinion when the unresolved question warrants it; never invent a Gemini response.
- Build App is never triggered by ordinary push/PR activity.

## 17. SOURCE-TO-HARDWARE TRACEABILITY — FROZEN

For any hardware/control mismatch, verify in order:
`App logical command -> BLE/P1 -> firmware command handler -> logical state -> GPIO/output writer -> physical wiring/output -> telemetry`.

- Do not swap App command tokens to compensate for a firmware/hardware mapping problem unless the actual protocol contract itself is proven wrong.
- ACK is not physical confirmation.
- Telemetry is the firmware state authority.
- Do not claim physical validation without an actual device test.
- Do not change safety logic merely to make UI/runtime behavior appear correct.

## 18. BUILD / RELEASE SEPARATION — FROZEN

- App Build and Diskusi/Eksekusi are separate workflows/chats.
- No App Build on ordinary repository push.
- Firmware source compile is separate from App Build.
- A successful historical build never validates a newer source revision unless the built source revision matches.
- Firmware source, BIN, Firebase metadata, and physical device state must be treated as separate validation layers.
- Repository boundary is frozen: `TenzoNkz/JEXFYZ-App` stores firmware source/engineering notes for continuity; `TenzoNkz/JEXFYZ-Firmware` is **binary-only** and must not receive `.ino` source or `FIRMWARE_NOTES.md`.

## 19. REQUIRED RESPONSE FOOTER

- Every final project response must include the exact sentence:
  `Lanjut diskusi, eksekusi, tanya gemini, build app!`
- The sentence must appear before the final workflow status block so that the final content remains an unambiguous status block.
- The final workflow status block remains exactly one of the allowed project statuses defined in Section 2.

## 20. REPOSITORY BOUNDARY — FROZEN

- `TenzoNkz/JEXFYZ-App` is the firmware continuity/source repository for the JE X FYZ project, including `firmware/*.ino` and firmware engineering notes.
- `TenzoNkz/JEXFYZ-Firmware` is the **binary distribution repository**.
- Do not copy, synchronize, or commit firmware `.ino` source or `FIRMWARE_NOTES.md` into the dedicated binary repository.
- Published `JEXFYZ.cpp.bin` remains the distribution artifact. A source version bump is independent from BIN promotion.
- Any accidental repository-boundary change must be reverted and recorded in the appropriate notes.

## 21. CANONICAL MEMORY FILE ARCHITECTURE

- `README.md` = project operating manual + copy-ready continuation prompt.
- `PROJECT_STATE.md` = current truth/current snapshot.
- `CHAT_RULES.md` = project process and workflow rules.
- `APP_NOTES.md` = App/cross-layer engineering contract and history.
- `FIRMWARE_NOTES.md` = Firmware engineering contract and history.
- `BUILD_NOTES.md` = Build App checkpoints and artifact continuity.
- `CHANGELOG.md` = milestone/version history.
- `HANDOVER.md` = portable continuation prompt for chat transfer.
- `firmware/FIRMWARE_ANALYSIS.md` = Firmware architecture/safety analysis.

## 22. MEMORY-FIRST PROJECT GATE

- The first safe action in every new or existing project chat is to rebuild context from the repository memory.
- A separate Build App chat is not exempt: it must perform the same memory preflight before inspecting or building App source.
- The user should not need to restate project history after a chat transfer.
- If a current-state document is stale, refresh it from current source/repository evidence before continuing.

## 2026-10-04 — HARDWARE TEST / 9V TO 12V RESET — SOFT-START HYPOTHESIS

- [CONFIRMED] Hardware-test discussion must distinguish observation, hypothesis, and verified root cause.
- [USER REQUIREMENT] When a second-opinion/Gemini review is requested, only an actual tool/connector result may be recorded as a Gemini result.
- [BLOCKED] No Gemini-capable tool/connector was available for this event, so the review request is recorded as blocked rather than fabricated.

## 2026-10-04 — PROCESS RULE / GEMINI RELAY VIA USER

- [CONFIRMED] When the user requests `@Thinking Tanya Gemini!`, the intended workflow is a **user-mediated Gemini relay** unless a direct Gemini connector is actually available.
- The assistant must prepare a complete, copy-ready technical prompt containing the verified project context, exact question, relevant source excerpts/constraints, requested analysis scope, and a structured response format.
- The user sends that prompt to Gemini externally and brings Gemini's reply back into this chat.
- Do not claim a Gemini result before the user's relay reply is received.
- After the user returns Gemini's response, classify it as external second-opinion evidence, reconcile it against current repository/source authority, and record accepted/rejected conclusions plus what remains unverified.
- A direct Gemini connector/tool, when available, may be used instead of the relay; otherwise the user relay is the default requested path.

## 2026-10-04 — EXECUTION FULL / V3.8 FIRMWARE SOFT-START SCOPE

- [IMPLEMENTED] Approved scope was executed: soft-start is now only a genuine Peltier OFF → ON event.
- [IMPLEMENTED] Voltage-rise transitions no longer restart soft-start.
- [PRESERVE] 5 s soft-start duration, PWM configuration, safety, BLE/P1, GPIO, Adaptive, OTA, and non-blocking contracts remain unchanged.
- [NO BUILD] App Build was not triggered because App source/configuration was unchanged.
- [VALIDATION] Full affected firmware source/static audit completed; physical validation remains pending.
