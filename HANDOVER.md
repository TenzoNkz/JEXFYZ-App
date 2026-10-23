# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-10-23 (Asia/Jakarta).

## Baseline

- Product owner reports the shipped unit uses Android App Build #124 and Firmware V7.1, compiled and installed through Online OTA.
- Verified App package: [Build #124 / run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a.
- These are two different evidence types: App release is CI-verified; Firmware compile/OTA is USER-REPORTED. Exact BIN identity and physical behavior remain unverified.
- Latest source-only UI changes on main are not yet covered by a newer App Build. This docs task does not run a build.

## Current handoff

The current task is a documentation-only improvement to chat-memory recovery. The owner wants exactly two transfer prompts and wants each substantive Discussion/Eksekusi completion, important milestone and Build App attempt recorded into GitHub memory without a separate save command.

Important boundary: conversation text is not automatically committed to GitHub. Only actual, verified commits are durable. The transfer prompt must instruct the next chat to read the saved checkpoint, live main/tree, durable rules/index/state, relevant canonical notes, and live run logs before continuing; never infer or claim unsaved tail content survived.

## Next continuation

1. Read CHAT_TRANSFER.md fully.
2. Fetch live main HEAD and recursive tree.
3. Read CHAT_RULES.md, MEMORY_INDEX.md, PROJECT_STATE.md and the complete reference relevant to the user's next request.
4. Paste one complete block from CHAT_TRANSFER_PROMPTS.md as a single message. Prompt 1 starts with Diskusi!; replace only its first line with Eksekusi Full! or Chat Stuck! when that mode matches the task. Prompt 2 starts with Eksekusi Build App! and is only for the guarded App Build/QC workflow. These short command names intentionally omit @Thinking. Do not add a duplicate command line above the block.
5. Home notice heading decision is now resolved: use Notification in English and Notifikasi in Indonesian, following the selected App language. Keep source/design references consistent; this decision alone does not authorize executable changes.
6. Save durable memory at each decision/milestone and at every substantive Discussion/Eksekusi Full completion or blockage. For Build App, update APP_BUILD_REPORT.md while attempts progress and refresh CHAT_TRANSFER.md at each logical milestone. Verify the commit before claiming the checkpoint was saved; if an abrupt limit occurs first, recover the last committed checkpoint only.

## Safety boundary

No App Build/release, Firmware compile, BIN/Firebase update, OTA, flash or device action is included in this handover. Do not treat @Thinking Eksekusi Full! as Build App authorization.
