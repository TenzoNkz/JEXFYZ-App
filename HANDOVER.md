# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Immediate next action — configure approved Copilot agent pipeline

- Owner decision 2026-11-27: supersede direct-main-only. Routine App-only WP0–WP10 coding is approved for GitHub Copilot cloud agent on `copilot/*` branches and PRs to `main`, without repeated per-task permission prompts.
- Target loop: ChatGPT produces a precise Agent Work Order → create GitHub Issue and assign Copilot → agent edits/tests on branch and opens PR → ChatGPT reviews full diff/evidence and directs fixes → PR validation → auto-merge only when configured requirements pass.
- Repository facts verified live: `TenzoNkz/JEXFYZ-App` is public; connected GitHub identity has admin permission; `allow_auto_merge=false`. The JE X FYZ Validation Only workflow is push-to-main only, so it does not validate Copilot PRs. `.github/copilot-instructions.md` and `.github/workflows/copilot-setup-steps.yml` are absent. Build App remains separately guarded by its issue/title/body-token condition.
- Copilot cloud-agent assignment by Issue is public preview and requires an eligible paid Copilot plan; account entitlement is unverified. GitHub Copilot Automations are restricted to private/internal repositories, so they are not available while this repo is public. Do not change repository visibility as a shortcut.
- The current GitHub connector exposes issue creation/assignee actions but not the dedicated Agent Tasks API or optional agent-assignment fields. Test bot assignment only in CODE_FULL and report actual returned session/PR evidence. Do not claim a task began merely because an issue was created.
- Keep the default human approval gate for Copilot PR Actions until validation workflows, token permissions, secrets and agent-editable paths have been audited. Never expose signing/release secrets or write permissions to unreviewed PR code. Do not add any PR/push route to the Build App release workflow. Protected Firmware/BIN, BLE/P1 wire/security, OTA, Firebase production, signing, flashing and device scopes remain excluded.
- Implementation of the pipeline belongs to CODE_FULL, not Diskusi. No source/config/workflow change, Copilot session, issue assignment, PR, Actions run or release was initiated in this Diskusi session.

## Existing App workstream

- Active work remains App-only WP0–WP10; validated source checkpoint `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0`, Validation Only #213 / run `46012060878` / job `140549796007`, terminal SUCCESS.
- WP0, WP4 cross-route semantic-token classification, WP5 visual/screenshot acceptance, WP6–WP10 and physical/platform evidence remain open as recorded in CHAT_TRANSFER.md.
- Current App source is not packaged; Build #167 remains the latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`.
- Build App, Firmware/BIN, BLE/P1 wire/security, OTA, Firebase production, signing, flashing and device operations remain separately restricted.
