# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Owner scope and repository policy

- Workspace: CODE_FULL — complete owner-approved App-only WP0–WP10 and evidence-backed build-ready handoff; then execute approved REPO_FULL.
- Repository: TenzoNkz/JEXFYZ-App, integration branch `main`; owner-approved App source/test implementation uses GitHub Copilot `copilot/*` branches and PRs. Diskusi documentation-only status/checkpoint updates may commit directly to `main`.
- Included: Flutter/Dart App source/tests/docs/configuration/static audit and non-publishing Validation Only CI.
- Excluded: Build App/APK/sign/release until a fresh Eksekusi Build App!; Firmware/BIN/P1 wire/behavior, BLE identity/security, OTA transport/trust/recovery, Firebase production, signing material, flashing and device operations.

## GitHub agent execution decision — 2026-11-27

- Owner superseded the earlier direct-main-only policy and granted standing authorization for routine App-only WP0–WP10 work through GitHub Copilot cloud agent, without requesting permission for each in-scope task.
- Target path: ChatGPT prepares a detailed Agent Work Order → GitHub Issue assigned to Copilot → Copilot branch/PR → independent ChatGPT diff/evidence review → required validation → auto-merge only when configured requirements pass. No code agent session has been delegated or started in this Diskusi session.
- Live repository facts: visibility is public; GitHub reports admin access for the connected identity and `allow_auto_merge=false`. Validation Only currently runs only on `push` to `main`, not PRs. Build App remains issue/title/token guarded and separate.
- Copilot cloud-agent issue assignment requires an eligible paid Copilot plan and is public preview through the issue API. Copilot Automations are unavailable to public repositories. The connected GitHub tools expose issue creation/assignee actions but not the dedicated Agent Tasks API or optional agent-assignment fields; successful agent start must be proven by a returned Copilot assignment/session/PR.
- GitHub Actions approval remains enabled by default for Copilot PRs. Do not remove it or expose privileged secrets/write tokens merely to eliminate prompts; first audit a least-privilege PR validation design. No repository visibility change is authorized or implied.

## Clarification of rework scope

“Full Rework” is the name of the owner-approved WP0–WP10 App modernization scope, not a claim that the application was rewritten from zero. Comparing Build #167 source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81` with validated source `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0` shows 603 descendant repository commits and 77 changed paths, including 21 App source files and 18 test files. The App-source delta is +11,377/-10,489 lines, much of it code extraction/reorganization: `main.dart` 11,434→4,831 lines; `usage_statistics.dart` 3,650→3,651; `floating_monitor.dart` 1,959→1,209 with Settings subpages in `settings_pages.dart`. Dashboard remains the sole BLE/GATT/P1/session/telemetry/command owner. The 603 commits are the aggregate repository history since Build #167, not 603 source rewrites or work performed in a single interaction.

## Current source and validation

- Validated source: `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0`; recursive tree 166 entries / 120 blobs / 46 trees, `truncated=false`.
- Validation Only #213 / run `46012060878` / job `140549796007`, exact source SHA above, terminal SUCCESS — locked dependencies PASS; formatter 44 files / 0 changed; analyzer PASS; **285/285 Flutter tests PASS**.
- WP1 storage: test/app_settings_store_test.dart adds seven mock-storage behavior tests. Production keys/defaults/schema unchanged. Plugin error injection and real Android storage behavior remain open/not verified.
- WP2/WP3: ordered bootstrap, App root, Settings presentation, pure P1 frame decoder, pure command contract and FIFO ACK-waiter lifecycle are separated. Dashboard remains the only BLE/GATT/P1/session/telemetry/command authority.
- WP4: shared layout/semantic color/typography/shape token foundation exists. Batch 1 compact-control radius and Batch 2 Statistics axis-label typography (`JexStatisticsTypographyTokens.axisLabel = 10.0`, three painter uses) are covered and revalidated by #213. Cross-route role classification remains open; preserve screen-specific density and measured plot geometry. Visual acceptance remains open.
- WP5 Batch 1: lib/dashboard_shared_components.dart contains reusable JexDashboardCard and JexDashboardSectionTitle. Twelve Card and seven heading call sites moved from main.dart to Control/Temperature presentation parts. Widget contract test verifies established geometry, theme surface/border/shadow and title typography; exact source passed #194. No Dashboard state/command/telemetry ownership moved.
- WP5 Batch 2: lib/dashboard_control_components.dart extracts _switchRow, _jexToggle and _smoothList into a state-bound presentation extension. Control and Temperature callsites use the extension; widget and Firmware QC source-contract tests follow the new part location. Exact source passed #198, 281/281 tests. Runtime BLE/GATT/P1/session/command ownership remains in Dashboard.
- WP5 Batch 3: keyed Dashboard content transition (210-ms fade + approximately 5.4-dp slide; 90-ms fade under reduced motion), outgoing tab pointer/semantics isolation, active-tab semantics at the first frame, unique toggle key ownership and regression tests. Validation Only #205 passed on exact source above.
- WP5 remaining: refine Home/Control/Adaptive/LED/Temperature screen composition, visual hierarchy, responsive fit and accessibility only where current source/test/visual evidence identifies a bounded issue; do not claim screenshot acceptance without device captures.
- WP6–WP10: Connection/Settings/dialog polish; Usage Statistics architecture/UI; Floating Monitor Flutter/native split; deterministic visual/integration/platform evidence; final file/diff/governance closure remain open.

## Protected contracts and evidence limits

P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE/GATT owner; ACK vs telemetry-confirmed physical outputs; settings keys/defaults and Usage Statistics v2/v1→v2, 30-day retention, raw 1-Hz samples, HOT-only P1 freshness, explicit null gaps and bounded queue; native Canvas/WindowManager; brand, theme/assets/localization and 360-dp canvas/DPI behavior remain protected.

Flutter/Dart/Gradle/ADB are unavailable locally. Hosted Validation Only does not compile Android/Kotlin or prove OEM/device behavior. Android/Kotlin compilation, actual screenshots/device/OEM, SQLite v1→v2 runtime fixture, 1h/6h/24h performance profile and whole-App visual acceptance remain NOT RUN / VISUAL NOT VERIFIED.

Build #167 remains the latest published App package on immutable source 0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81; current main is not packaged. No Build App/release, Firmware/BIN, OTA, Firebase production, signing, flashing or device operation occurred.

## Next action

First configure the approved Copilot branch/PR execution path in CODE_FULL: repository-specific Copilot instructions, deterministic agent setup, PR validation that preserves least privilege, and reviewed auto-merge/branch protections. Verify Copilot plan/assignment availability before claiming the agent is running. Then resume the still-open WP0–WP10 App work, beginning with the full Dashboard owner/content audit and WP4 cross-route semantic-token classification; preserve unique plot/telemetry/canvas geometry.
