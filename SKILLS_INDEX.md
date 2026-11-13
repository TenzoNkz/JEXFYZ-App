# JE X FYZ / JE Cooler — Skills & Capability Index

Last reconciled: 2026-11-13 (Asia/Jakarta). This is the discovery map for reusable agent skills and the actual tool capabilities available to project chats. The operating authority remains MASTER_PROMPT.md.

## Skill locations and loading

- Canonical skill definitions: `.agents/skills/<skill-name>/SKILL.md` for OpenAI Codex-compatible repository skill discovery.
- GitHub Copilot mirrors: `.github/skills/<skill-name>/SKILL.md` for Copilot cloud agent, Copilot code review, Copilot CLI/app and supported IDE agent modes.
- The two copies must remain byte-for-byte identical. Edit the canonical `.agents/skills` copy first, then mirror the exact content to `.github/skills`; verify their blob/content equality.
- Skills use progressive disclosure: load only the most relevant one to three skill files for a task, not all of them every time. Complex cross-layer investigations may combine more.
- ChatGPT in this conversation does not automatically scan private repository skill folders as an installed skill registry. The assistant must fetch and read the relevant repository SKILL.md through the GitHub connector when needed. Do not claim automatic activation in ChatGPT mobile/web.
- Skills are instruction packages. They do not grant GitHub permissions, connect external accounts, install SDKs, run CI, or authorize protected operations.

## Project skill catalogue

| Skill | Primary use | Canonical path |
|---|---|---|
| Repository forensics | Live repo boot, commit/diff archaeology, code/reference mapping, evidence tracing | `.agents/skills/repository-forensics/SKILL.md` |
| Code review | PR/commit/patch review for correctness, regression, safety, security and actionable findings; Copilot code-review integration | `.agents/skills/code-review/SKILL.md` |
| Flutter App engineering | Flutter/Dart architecture, state, UI, navigation, theme, localization, responsive/animation review | `.agents/skills/flutter-app-engineering/SKILL.md` |
| Product design and visual quality | Product identity, hierarchy, design-system consistency, anti-AI-slop review, accessibility and screenshot-based acceptance | `.agents/skills/product-design-and-visual-quality/SKILL.md` |
| Flutter quality and regression | Test design, source-contract quality, widget tests, formatter, analyzer, full-suite strategy | `.agents/skills/flutter-quality-and-regression/SKILL.md` |
| BLE P1 protocol audit | GATT, P1 session lifecycle, ACK-vs-telemetry, reconnect, race/stale-state review | `.agents/skills/ble-p1-protocol-audit/SKILL.md` |
| ESP32-C3 Firmware safety | Cooperative timing, NTC, thermal safety, PWM, rail transitions, radio handoff | `.agents/skills/esp32c3-firmware-safety/SKILL.md` |
| OTA and release integrity | Protected OTA audit, guarded APK release, signing, source ZIP, tag and digest provenance | `.agents/skills/ota-and-release-integrity/SKILL.md` |
| GitHub Actions triage | Runner/job/log triage, cancellation/concurrency, permission and workflow security review | `.agents/skills/github-actions-triage/SKILL.md` |
| Hardware power/thermal analysis | PD, buck converters, Peltier, MOSFET PWM, ripple/EMI, thermal derating and datasheets | `.agents/skills/hardware-power-thermal-analysis/SKILL.md` |
| Technical research and second opinion | Official docs/datasheets/standards, evidence comparison, Gemini handoff and answer review | `.agents/skills/technical-research-and-second-opinion/SKILL.md` |
| Documentation and memory governance | Markdown classification, single source of truth, link audit, checkpoint/ledger hygiene | `.agents/skills/documentation-memory-governance/SKILL.md` |

## Canonical product-design references

| Reference | Authority / purpose |
|---|---|
| `PRODUCT_DESIGN_CONSTITUTION.md` | Cross-screen design intent, authority order, protected JE Cooler identity, anti-AI-slop principles, design-system governance and accessibility baseline |
| `VISUAL_QUALITY_GATE.md` | Review sequence, viewport/state matrix, screenshot evidence rules, rejection severity and visual acceptance outcomes |
| `DESIGN_NOTES.md` | Owner-approved screen-specific visual constraints and existing implementation contracts; remains authoritative for those details |

For non-trivial UI changes, load the product-design skill plus the Flutter engineering skill; add Flutter quality/regression when planning or reviewing tests. Read the design constitution and visual gate rather than duplicating their rules in every skill.

## Capability matrix — current project-chat tool families

| Capability | What can be done | Boundary / dependency |
|---|---|---|
| GitHub repository tools | Read repository/tree/files/blobs/commits; search; compare commits; create/update files and commits; inspect branches, issues, PRs, reviews and comments | Actions are limited by the connected GitHub app/token and repository permissions. Re-check access before writes. |
| GitHub Actions tools | Inspect workflow runs, jobs, steps, logs, statuses and artifacts; rerun failed jobs where permitted | A rerun is a side effect and is subject to the selected command mode. The guarded App release still needs explicit Eksekusi Build App!. |
| Web research | Search current official documentation, standards, vendor datasheets, API changes and technical reports; cite supporting claims | Prefer primary sources. Marketplace descriptions and unsourced community claims are not datasheet evidence. |
| Python and shell/container | Calculations, data analysis, parsers, static audit scripts, file generation and Git inspection | Inspect actual installed commands. Current environment has Python and Git but lacks Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF. No physical USB/device access. |
| Visual analysis / image tools | Inspect user-supplied screenshots, compare UI geometry, generate or edit image assets when specifically requested | Generated imagery is not a substitute for editable vector/source assets or Android rendering tests. |
| Shopee product discovery | Search marketplace listings for prototype components and compare available listings | Listings do not establish electrical safety/rating. Verify exact model against manufacturer datasheets and measurement evidence. |
| Plugin and app integrations | Discover/suggest plugins or inspect available permissions/dependencies when an external account/service materially helps | Installation/connection and permission grants require the owner's action. |
| Automations | Set up authorized reminders/monitoring/recurring checks when explicitly requested or accepted | Requires a trigger/cadence and successful creation. It does not execute repository work in the background by itself. |
| Gemini second opinion | Prepare a complete prompt, then review an answer the owner returns | No direct Gemini access or GitHub access. The owner manually pastes the prompt and result. |

## ChatGPT session integration snapshot

- The installed ChatGPT plugin-skill list in this session exposes `plugin-management`; it is not a code-engineering skill. The project-specific SKILL.md files in this repository are loaded manually by fetching the relevant file through the GitHub connector, not by assuming they are installed into ChatGPT's native skill registry.
- Connected tool families visible in this session include GitHub repository/Actions/PR/issue tools, web research, Python/container utilities, Shopee product search, plugin management and task automations. Each action remains subject to tool availability, account connection, permission and the command-mode authorization in MASTER_PROMPT.md.
- No direct Gemini connector is available in this workflow. The owner manually pastes the prompt and returns Gemini's response for verification.

## Current execution-environment snapshot

- Checked 2026-11-13: Git, Python 3 and Java are available in the current runtime. Dart, Flutter, Gradle, ADB, Arduino CLI and ESP-IDF are absent. GitHub repository read/write is available through the connector; local Flutter/Android/Firmware compilation and physical-device validation cannot be claimed from this runtime.
- The connected GitHub Actions workflow can validate and publish the App, but its only current App workflow is the guarded Build/QC/release pipeline rather than a validation-only job. It must not be triggered from Diskusi or Eksekusi Full.
- No toolchain was installed and no local build/test command was attempted in this audit.


## High-rigor work pattern

1. Scope: restate the requested outcome, mode, protected invariants and stop conditions.
2. Evidence: fetch live source/config/tests/docs and current external references as relevant; label facts, user reports, hypotheses and unknowns.
3. Model: trace data/control flow, state ownership, timing, failure modes, dependencies and side effects. Use equations or explicit state tables when useful.
4. Alternatives: compare at least two viable options for material design choices; quantify cost, reliability, complexity and regression risk where data allows.
5. Adversarial review: independently challenge the preferred approach for edge cases, security/safety regressions, hidden coupling and unsupported assumptions. Use Gemini only when an independent opinion materially adds value.
6. Validation: map requirements to tests/evidence, choose the narrowest useful test, inspect actual output, and distinguish static checks from execution/CI/device evidence.
7. Delivery: make only authorized changes, review the diff, update canonical memory, commit and verify the final tree.

## Skill maintenance policy

- Add a new skill only when it defines a distinct repeatable workflow or expertise; do not add generic persona prompts or duplicate the Master Prompt.
- Keep SKILL.md descriptions concise and trigger-oriented so agents can discover the right skill.
- Keep product invariants in canonical subject notes; link to them instead of copying a second conflicting rule set into skills.
- Skills may include references/templates later. Do not add executable scripts in Diskusi; scripts require an explicitly authorized implementation scope and test strategy.
- Keep both provider mirrors in sync and verify exact file content after every skill change.
- Update MASTER_PROMPT.md, README.md and MEMORY_INDEX.md when skill loading conventions or the catalogue changes.