# JE X FYZ / JE Cooler — Chat Rules Pointer

This file is retained for compatibility with existing links and chat-transfer instructions.

**The single authoritative operating ruleset is [MASTER_PROMPT.md](MASTER_PROMPT.md).** Read it fully before acting. Do not maintain duplicate mode, authorization, Gemini, memory-save or safety rules here.

## Three dedicated ChatGPT workspaces

- **Diskusi!** — read-only engineering discussion, planning and source review.
- **Eksekusi Code!** — specifically authorized App source/tests/docs/config/static-audit implementation. Legacy `Eksekusi Code Full!` and `Eksekusi Full!` are compatibility aliases.
- **Eksekusi Build App!** — guarded Android App Build/QC/release only.

Each command has its own ChatGPT conversation. The owner creates/selects the three chats manually using the three copy-ready blocks in [CHAT_TRANSFER_PROMPTS.md](CHAT_TRANSFER_PROMPTS.md). The chats share GitHub memory but not transcripts. Do not switch modes inside one chat. `Chat Stuck!` is recovery within the active workspace, not another workspace.

All project changes go directly to `main`; secondary branches and PRs are not used. The owner confirms this CODE_FULL subchat is the only active execution chat. Re-fetch current main and target-file SHAs before writes; Build App remains a separate explicit operation.

For every JE X FYZ project message, open `SESSION STATUS = IN_PROGRESS` at the start, refresh at meaningful milestones, and close with the actual result. Keep the interaction/work item separate from external Actions state. Follow MASTER_PROMPT.md Section 2A; this is event-driven, not a background heartbeat.
