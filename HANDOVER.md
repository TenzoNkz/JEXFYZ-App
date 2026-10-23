# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-10-23 (Asia/Jakarta).

## Baseline

- Product owner reports the shipped unit uses Android App Build #124 and Firmware V7.1, compiled and installed through Online OTA.
- Verified App package: [Build #124 / run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a.
- These are two different evidence types: App release is CI-verified; Firmware compile/OTA is USER-REPORTED. Exact BIN identity and physical behavior remain unverified.
- Latest source-only UI changes on main are not yet covered by a newer App Build. This docs task does not run a build.

## Current handoff

The current task is documentation/repository rework under @Thinking Eksekusi Full!. Preserve source/runtime behavior. The live tree was checked at 11a0ef162f1c2945704229ed7697dc70e7617e9b before this docs commit; fetch live main after the commit for the actual new HEAD.

The rework simplifies current-only docs, removes the old four-prompt taxonomy, defines exactly two LOAD + CONTINUE prompts, and audits current notes versus history ledgers/archive. It does not change App/Firmware code, config, workflows or tests.

## Next continuation

1. Read CHAT_TRANSFER.md fully.
2. Fetch live main HEAD and recursive tree.
3. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md and the complete reference relevant to the user's next request.
4. Use Prompt 1 in CHAT_TRANSFER_PROMPTS.md for general engineering, or Prompt 2 only for an authorized App Build chat.
5. Before a new UI implementation, explicitly resolve the current disagreement over Home notice heading: live source localizes it as Notification / Notifikasi while DESIGN_NOTES.md retains a fixed NOTIFY requirement.
6. If a substantive Discussion ends or an authorized execution completes/blocks, refresh the checkpoint and canonical notes.

## Safety boundary

No App Build/release, Firmware compile, BIN/Firebase update, OTA, flash or device action is included in this handover. Do not treat @Thinking Eksekusi Full! as Build App authorization.
