# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Immediate next action — finish Copilot pipeline readiness

- Owner decision 2026-11-27: routine App-only WP0–WP10 coding is approved for Copilot cloud agent, without per-task permission prompts. Target flow is Agent Work Order → Copilot task/session → agent branch/PR → independent review → PR CI → merge only after all checks/protections pass.
- Live repo: TenzoNkz/JEXFYZ-App is public; connected identity has admin permission; allow_auto_merge=false. No copilot/* branches or open PRs exist. Validation Only remains push-to-main only. Build App is still separately issue/title/body-token guarded.
- There are two different APIs: (1) Issue assignment is available on eligible paid Copilot plans, public preview, via REST/GraphQL and a user-to-server token; fine-grained PAT scope is metadata read + Actions/contents/issues/pull requests read/write (classic PAT repo scope). (2) Agent Tasks REST start/list/get is public preview, but Start a task is currently only Copilot Business/Enterprise; it needs a fine-grained PAT or GitHub App user access token with Agent tasks read/write, and GitHub App installation tokens are unsupported. The linked GitHub connector exposes neither direct task start nor optional issue agent_assignment fields. Verify plan and choose the supported secure user-token integration before claiming fully automated start.
- Copilot cloud agent/Issue assignment can work for eligible paid-plan accounts on public GitHub repos unless disabled/managed policy blocks it. Copilot Automations for scheduled/event triggers require private/internal repositories; do not change repo visibility as a shortcut.
- Twelve mirrored GitHub Copilot skill files and AGENTS.md already exist. Missing: .github/copilot-instructions.md. Missing: .github/workflows/copilot-setup-steps.yml, which only helps when agent sessions run on GitHub Actions, not cloud sandbox. Existing Validation Only workflow validates only push to main; add a least-privilege pull_request path, protect workflow-file changes and do not add triggers to Build App workflow.
- allow_auto_merge=false. Branch protection/ruleset settings cannot be verified using current GitHub connector; inspect settings in GitHub before changing them. Copilot code review defaults to Comment, not Approve. Workflows from Copilot PRs are not run until approved by default; keep this until validation workflow, secrets, token permissions and agent-editable paths are audited. Do not expose release signing secrets or write tokens to unreviewed code.
- Copilot setup should include: PR requirement for main, required successful status checks, conversation resolution, stale approval dismissal and no force push/deletion/bypass; enable auto-merge only after checks. If a policy requires a reviewer, do not expect Copilot Code Review's Comment to count as approval; ChatGPT review currently has no native GitHub status-check integration.
- No source/workflow/repo-settings changes, Copilot session, task, Issue assignment or PR were made in this Diskusi session.

## Existing App workstream

- Active work remains App-only WP0–WP10; validated source checkpoint d0ab20533c2bf27be18dbb25c3ad9c762663d7e0, Validation Only #213 / run 46012060878 / job 140549796007, terminal SUCCESS.
- WP0, WP4 cross-route semantic-token classification, WP5 visual/screenshot acceptance, WP6–WP10 and physical/platform evidence remain open.
- Current App source is not packaged; Build #167 remains latest published package on immutable source 0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81.
- Build App, Firmware/BIN, BLE/P1 wire/security, OTA, Firebase production, signing, flashing and device operations remain separately restricted.
