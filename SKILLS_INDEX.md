# JE X FYZ / JE Cooler — Skills & Capability Index

Last reconciled: 2026-11-24 (Asia/Jakarta). This is the discovery map for reusable agent skills and the actual tool capabilities available to project chats. The operating authority remains MASTER_PROMPT.md.

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

### Account-specific plugin connection snapshot — checked 2026-11-24

- The platform confirmed Figma successfully connected for the active ChatGPT account on 2026-11-24. The `mcp__Figma__use_figma` connector action is now available and supports Figma Design files, FigJam boards and Figma Slides, including creating/editing/syncing UI screens, components, styles and variables. This current connector capability supersedes the older 2026-11-18 limitation note below for the active account; plugin status remains account-specific.
- Before every `mcp__Figma__use_figma` call, load the installed `figma-use` skill as required by the connector. No Figma file or design was created/changed during the 2026-11-24 plugin-advisory follow-up.
- The separate 2026-11-24 catalog check earlier in the same advisory initially showed Figma as not connected; the later platform connection event supersedes that result. Google Drive was then reported `DISABLED_BY_ADMIN`; Gmail and Google Calendar were available but not connected. Those are account- and time-scoped observations, not guarantees for other ChatGPT accounts, and were not rechecked after the Figma connection event.
- Do not infer that Figma is connected in the owner's other ChatGPT accounts. Re-check the target account before relying on external app availability.

### Plugin and GitHub workflow snapshot — checked 2026-11-18

- GitHub ChatGPT integration is installed/enabled and already provides repository, issue/PR, Actions run/job/log, Release and tag access. Do not add a duplicate GitHub connector.
- Figma is shown installed/enabled in the current plugin catalog; a read-only Figma `whoami` succeeded on 2026-11-17. Its direct ChatGPT integration supports FigJam diagrams and Figma Slides, not editable Figma Design app screens. No Figma file was created or changed in this work.
- Context7 was originally suggested as optional during the 2026-11-25 advisory. **Superseding connection event (2026-11-25):** the platform confirmed Context7 successfully connected. Its `mcp__Context7__resolve_library_id` and `mcp__Context7__query_docs` actions are now available. A live query against Flutter's official API reference verified `MediaQuery.disableAnimationsOf(context)` and `AnimationBehavior.normal`; the latter shortens controller duration under `disableAnimations`, but repeating custom loops still need an explicit stop/static fallback policy. Use Context7 for version-sensitive upstream docs; do not treat it as an authority for project-specific behavior or replace source/tests.
- Do not add Linear/Notion/Asana/Trello solely for task tracking while GitHub Issues and canonical repository Markdown remain the project source of truth. Defer Firebase or analytics integrations until a specific backend task or privacy/data contract is approved.
- The tree still has no `.github/dependabot.yml`. A separate `.github/workflows/jexfyz-app-pr-validation.yml` now runs on pull requests with `contents: read`, pinned actions, checkout credentials disabled and caching disabled. It checks locked dependencies, read-only Dart formatting, analysis and Flutter tests; it has no secrets, formatter mutation, build or publish step. The source was statically reviewed at commit `96c5fa395e8a6f96c420a47fa2dd6ad74e569523`; no PR is open, so hosted CI has not exercised it yet.
- Existing Validation Only remains a push-to-`main` workflow and can write a formatter-only commit to `lib/` and `test/`; do not expose it to PR events. Keep it separate from the guarded Build App release flow.
- Before requiring PR checks or adding weekly Dependabot updates for `pub`, `gradle` and `github-actions`, first observe a normal PR run of the new workflow. Keep owner review and no auto-merge.
- The active Ruleset `main-safety-guard` (ID `27528678`) protects the default branch from deletion and non-fast-forward updates, with no bypass actors. The separate classic branch-protection API returned 403, so that state remains unverified.
- A repository-specific security-scanning plugin was not surfaced in the current plugin searches. No separate security plugin is needed to decide the current App rebuild question; review workflow/dependency automation separately if desired.

### Plugin / tooling advisory — checked 2026-11-25

- **Confirmed ChatGPT connections:** GitHub and Figma both returned `installed=true` in the live plugin catalog. GitHub already covers repository, issues/PRs and Actions/Release inspection. Figma covers editable Design files, FigJam and Slides; the account already has dedicated Figma skills for design generation, motion, library/tokens and code-to-design. Do not install duplicate GitHub/Figma connectors.
- **New connection confirmed:** Context7 successfully connected on 2026-11-25. Its `resolve_library_id` and `query_docs` tools are available for version-aware upstream library/framework documentation during Flutter/Dart/Material UI/AGP/Gradle/Firebase upgrades. A first Flutter API lookup verified `MediaQuery.disableAnimationsOf(context)` and `AnimationBehavior.normal`. Respect the tool's requirement to resolve library IDs before querying docs; do not send secrets/proprietary code in queries.
- **Not recommended for the current phase:** PostHog (would require app event instrumentation, data collection and privacy/consent policy); Datadog (observability backend, instrumentation and ongoing operational cost, with no current Datadog workspace evidence); Firebase connector (broad backend/project-management surface and unnecessary access near protected OTA/Firebase production state); Atlassian (duplicates GitHub Issues/PRs and canonical Markdown); Product Design plugin (Figma plus the existing project design skills already covers the current design workflow). No dedicated Sentry plugin result was returned in the targeted catalog search; this does not prove none exists elsewhere in the full directory.
- **Use existing project skills first:** repository-forensics, code-review, flutter-app-engineering, product-design-and-visual-quality, flutter-quality-and-regression, ble-p1-protocol-audit, esp32c3-firmware-safety, ota-and-release-integrity, github-actions-triage, hardware-power-thermal-analysis, technical-research-and-second-opinion and documentation-memory-governance. The connected Figma workflow additionally has `figma-use` (mandatory before every use_figma call), `figma-generate-design`, `figma-generate-library`, `figma-implement-motion`, `figma-use-motion` and `figma-design-to-code`.
- **Potential project-skill refinement:** extend the existing Flutter engineering/quality skills with reduced-motion, animation-controller lifecycle, repaint isolation and profile-mode performance checks rather than creating overlapping generic skills. Consider two focused repository skills only if they become recurring workflows: `android-device-visual-qa` (350/420-dp, EN/ID, Light/Dark, connected/disconnected/error, native overlay and real-device BLE evidence) and `dependency-upgrade-matrix` (pub/plugin compatibility, licenses, Flutter/Dart, AGP/Gradle/Kotlin, Wrapper, GitHub Actions pins and lockfile validation).
- **Local engineering tools with highest practical value:** Android Studio stable; Android SDK Platform/Build Tools and Platform Tools (`adb`); AVD Manager/emulator with representative phone profiles; Flutter stable SDK (Dart and DevTools are bundled); one physical Android phone for OEM, notification, overlay and actual JE Cooler BLE/P1 testing; and the physical JE Cooler unit. These are developer-workstation tools, not ChatGPT plugins. The ChatGPT execution container inventory checked 2026-11-24 did not have Flutter, Dart, Gradle or ADB, so hosted CI and owner-supplied physical screenshots/device evidence remain necessary until a local workstation runner is available.
- **QA stack:** keep current unit/widget tests and hosted Validation Only/PR validation; add Flutter `integration_test` for end-to-end App flows on emulator/physical devices. Flutter's integration_test cannot interact with native platform UI, so consider Patrol only for Android permission dialogs/system settings/native interactions that require it. Use Flutter DevTools in profile mode to inspect UI/raster frame times, jank, rebuilds, CPU and memory; use Android Studio Profiler for native CPU/memory/graphics. A successful widget/CI run is not Android visual/device acceptance.
- **Evidence-backed references:** [Flutter DevTools](https://docs.flutter.dev/tools/devtools), [Flutter Performance view](https://docs.flutter.dev/tools/devtools/performance), [Flutter integration tests](https://docs.flutter.dev/testing/integration-tests), [Flutter integration testing limits / testing plugins](https://docs.flutter.dev/testing/testing-plugins), [Android Studio Profiler](https://developer.android.com/studio/profile/).
## Current execution-environment snapshot — checked 2026-11-24

- Current container verification: Git 2.47.3, Python 3.13.5, Java and Javac are available. Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF are absent. Do not claim local Flutter/Android/Firmware compilation, tests or physical-device validation from this runtime.
- GitHub repository read/write and Actions inspection are available through the connected integration, subject to the selected workspace authorization. Local SDK absence does not prevent read-only repository review or GitHub-hosted CI evidence inspection.
- Do not install toolchains or mutate the environment merely to force validation within a project chat. Record missing SDK checks as BLOCKED / NOT RUN and use the existing authorized hosted workflows where appropriate.
- App Actions comprise the push-to-main Validation Only workflow (which may commit only formatter changes under `lib/` and `test/`), a separate read-only `pull_request` Flutter validator, and the guarded Build/QC/release workflow. Only the explicit Eksekusi Build App! workspace authorizes the release path.


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