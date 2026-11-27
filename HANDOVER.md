# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Immediate next action — GitHub coding-agent workflow decision

- Current owner policy: direct commits to `main`; no secondary branches or PRs. Do not trigger Copilot coding work in this repo while that policy remains unchanged.
- GitHub Copilot cloud agent is technically suitable for delegated App coding: it accepts natural-language instructions, edits code, runs tests and iterates, but works on a `copilot/*` branch and requires human review/merge. It cannot approve or merge its own PR.
- Current JE X FYZ Validation Only triggers only on push to `main`; it does not validate PR branches. Live tree has no `.github/copilot-instructions.md` or `.github/workflows/copilot-setup-steps.yml`. Existing `AGENTS.md` and `.github/skills/` are partial agent context.
- Proposed safe adoption (NOT APPROVED): owner authorizes branch/PR policy; add repository-specific Copilot instructions and pinned Flutter setup; enable PR validation on Copilot branches; enforce human review and required checks; preserve Build App's separate owner/title/token guard; prohibit protected Firmware/BIN, BLE/P1 wire/security, OTA, Firebase production, signing, flashing and device paths unless separately authorized.
- GitHub Agentic Workflows are better suited to read-only issue/CI triage, reporting, documentation and bounded test-coverage tasks with read-only defaults and declared safe outputs; not a substitute for the Copilot cloud coding agent.
- Copilot plan/account availability is unverified. The current ChatGPT GitHub tool catalogue does not expose a Copilot coding-session start action; the owner would start/assign the agent in GitHub UI after a policy decision.

## Existing App workstream

- Active work remains App-only WP0–WP10; validated source checkpoint `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0`, Validation Only #213 / run `46012060878` / job `140549796007`, terminal SUCCESS.
- Current App source is not packaged; Build #167 remains the latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`.
- Build App, Firmware/BIN, BLE/P1 wire/security, OTA, Firebase production, signing, flashing and device operations remain separately restricted.

