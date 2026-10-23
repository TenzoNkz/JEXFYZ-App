# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-10-23 (Asia/Jakarta). This is the rolling continuation state, not a transcript or a substitute for live repository checks. Prompt 1 begins with `Diskusi!`; Prompt 2 begins with `Eksekusi Build App!`. For explicitly authorized execution/recovery variants, replace Prompt 1's first line with `Eksekusi Full!` or `Chat Stuck!`.

## Product/release baseline

- Owner reports the sold/shipped unit uses App Build #124; Firmware V7.1 was compiled and installed through Online OTA. Treat those deployment claims as USER-REPORTED.
- Verified App artifact: [Actions run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), packaged source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. APK SHA-256 c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318; source ZIP SHA-256 e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152.
- Production baseline remains Build #124 + V7.1. The unit is sold/shipped and not routinely available for physical repair; future changes must be conservative.
- App release CI is not evidence of Firmware compile/BIN identity, OTA apply/reboot, BLE recovery or thermal/electrical behavior.

## Active Build App/QC recovery — 2026-10-23 (Asia/Jakarta)

- **Status: BUILD #128 ACTIVE, Flutter tests running.** [Run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), exact source SHA `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`, job `120264345808`, hosted runner `1000002427`.
- **Passed:** steps 1–12; the security/architecture audit, dependencies and Dart analyzer all succeeded. **Current:** step 13 `Run Flutter tests` is `in_progress`; this is the first run to validate the three stale assertion fixes.
- **Pending:** Flutter test result, Android Gradle gate, obfuscated release APK, V1/V2/V3 + certificate checks, source ZIP, Release/tag parity and downloaded asset hashes/source marker. Active logs are unavailable until later in the run; the live step API is still returning status.
- **Checkpoint:** ledger commit `0ee981a90ecaa6f925f4cb7db068d7b29cf505ce` is committed and verified. Verify this transfer update too. Do not trigger a duplicate while #128 is active. Build #124 remains latest verified package. Preserve `versionName "Telegram @horizontalzzz"`; no Firmware/BIN/Firebase/OTA/flash/device actions.

## Live repository point

- Documentation audit began on TenzoNkz/JEXFYZ-App/main at 11a0ef162f1c2945704229ed7697dc70e7617e9b, commit message "fix: sync Android notification channels with app language", dated 2026-10-23. The docs-only rework commit moves main forward; fetch live HEAD/tree at every boot instead of trusting this audit-base SHA.
- At audit start, recursive tree had 69 entries, untruncated; no open PRs were returned.
- Active Firmware source is firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- Latest release record is Build #124; current App source-only UI changes have no later verified package.

## Last durable task and result

### Memory checkpoint rule

GitHub memory is not an automatic transcript of this chat. A state is considered saved only after the relevant checkpoint/note is committed to `main` and the resulting content is verified. Save at each durable decision, logical milestone, and task success/blockage; for Build App, update `APP_BUILD_REPORT.md` as each attempt progresses. Before an expected chat limit, record the active scope, last verified step, remaining work, run status, blocker, and next action. If interruption happens before a commit finishes, recover only the last verified checkpoint and live evidence; never claim the unsaved portion was preserved.

Latest durable task: under `@Thinking Eksekusi Full!`, audited the chat-limit memory workflow and strengthened the durable save cadence across the two prompts and current project-memory docs. The policy now requires a review/save pass before ending any substantive project chat, even if the larger task is unfinished; checkpoint after durable decisions, milestones, tests, and blockers; update `APP_BUILD_REPORT.md` as build attempts progress; and verify the actual commit before describing the state as saved. If nothing new is durable, avoid no-op commits and retain the last verified checkpoint.

Important persistence boundary: GitHub does not automatically receive the ChatGPT transcript. An abrupt interruption before a verified commit can leave an unsaved tail; next chat must recover the last committed checkpoint and live source/run evidence rather than inventing that missing tail.

Exactly two transfer prompts remain in `CHAT_TRANSFER_PROMPTS.md`: Prompt 1 starts `Diskusi!` and can be switched to `Eksekusi Full!` or `Chat Stuck!`; Prompt 2 starts `Eksekusi Build App!`. The copy-ready command names intentionally omit `@Thinking`.

This execution was documentation-only. No executable source, config, workflow, tests, App Build/release, Firmware compile, BIN/Firebase, OTA, flash or device work was performed. Main was at `34f6f3ab14459078fdecd2e0ef980002b0b53090` immediately before this final handoff update; always fetch the live HEAD after boot.

Latest durable decision (2026-10-23): the owner confirmed the Home notice heading must follow the selected App language — `Notification` in English and `Notifikasi` in Indonesian. This resolves the former DESIGN_NOTES.md mismatch with live localization source. The decision is documentation/design-only: no executable source, tests, configuration or workflow were changed; no test/build/release or Firmware/BIN/Firebase/OTA/flash/device operation was run. Next safe action: continue the Discussion workstream from live evidence; if a later UI implementation is requested, use this heading contract and obtain the appropriate execution authorization first.

## Latest pre-Build notes reconciliation — 2026-10-23

- This Discussion-mode audit began from live `main` HEAD `3234cecd7903f66622e5bf1b14fdb1dfc86fcb82`, commit "docs: checkpoint Home notice localization decision". Its recursive tree had 69 entries (`truncated=false`), and the open-PR query returned none. Documentation-only writes from this audit advance main beyond that starting SHA; fetch the final live HEAD before any later action.
- A stale sentence in `MEMORY_INDEX.md` still described the Home notice heading as an unresolved mismatch, contradicting the owner decision and the resolved contracts in `APP_NOTES.md`/`DESIGN_NOTES.md`. It has now been corrected. `CHANGELOG.md`, `PROJECT_STATE.md` and `HANDOVER.md` were also refreshed to record the pre-build state and keep the handoff accurate.
- Fresh live Actions still show Build #125 / run `39905665853` completed as failure before runner steps: job `120256919402`, `runner_id=0`, empty runner name, `steps=[]`, no usable log and no artifacts. The owner subsequently reported the Actions issue fixed and working, but no new run has verified that claim; the exact old failure cause remains `UNVERIFIED INFRASTRUCTURE BLOCKER`. No gate ran and no retry was issued.
- Release `jexfyz-latest` and `refs/tags/jexfyz-latest` still target Build #124 source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`, with the same recorded APK/source ZIP digests. Build #124 is the latest verified package; #125 produced none.
- Build readiness decision: do not broadly rewrite every repo note. Keep active canonical notes current, preserve `APP_BUILD_REPORT.md` and `CHANGELOG.md` as history ledgers, and leave `archive/*.md` immutable. The owner-reported Actions recovery is not yet CI-verified; the next separately authorized Build App task must preflight live state and verify the new run reaches real runner steps before treating the blocker as resolved.
- This reconciliation changed project-memory documentation only. No App/Firmware source, config, workflow or tests were changed; no test, build/release, Firmware compile, BIN/Firebase, OTA, flashing or device action ran.

## Current UI implementation / validation

Source-only UI implementation on main includes:
- Fixed 360-dp Home-matched Settings canvas, used by Settings/sub-settings and designated modal surfaces, with text scaling disabled.
- Device / Perangkat wording across lock prompts, BLE-discovery/error copy, firmware-update guidance and Android service/notification channels.
- Floating Monitor hides whenever synchronized connected telemetry is false; it restores only when enabled and the full BLE/P1 session gate is met. Saved intent survives disconnect/missing overlay permission.
- Persistent BLE foreground notification ID 2110 is distinct from transient alert IDs 2101–2104 and Floating Monitor ID 2301; existing notification channel IDs are preserved.
- Android alert/BLE/Floating Monitor channel names/descriptions synchronize to App language on startup and language changes.
- OTA result copy is localized at display time; OTA protocol/transport is unchanged.

Static contract files exist, notably test/device_copy_notification_contract_test.dart and test/floating_monitor_layout_contract_test.dart, but they have NOT been executed for these latest UI changes. Latest Dart analyze/formatter/Android compilation and packaged release validation remain NOT RUN for this source revision.

## Permanent technical boundaries

- Adaptive Fan targets are relative to configured Hotside limit: delta ≤2°C→100%; 3–4→90%; 5–6→80%; 7–8→70%; 9–10→60%; ≥11→50%. At limit 40°C, 40/39/38→100%, 37/36→90%, 35/34→80%, 33/32→70%, 31/30→60%, ≤29→50%.
- Raw-decimal Hotside safety is independent: at/above limit, Fan 100% and Peltier OFF. PWM rises by 10 percentage points/second and falls by 10 points/10 seconds; Adaptive 5 V/9 V remains Fan 100%.
- Rapid Hotside-rise/slope shutdown plus manual re-arm is NOT IMPLEMENTED in V7.1; do not conflate it with Adaptive Fan tiers.
- Preserve one calibrated NTC reading/second, cooperative millis() timing, Touch/P1, authoritative telemetry, BLE single-radio ownership, selector/Peltier timing, safe outputs, and Local/Online OTA recovery.
- Current Online OTA uses cloudClient.setInsecure(): transport is encrypted but HTTPS server certificate identity is not authenticated. Preserve current allowlist, redirect/status/length/size/image checks and Firebase version+link contract.
- Exclusive App identity authorization remains BLOCKED / NOT IMPLEMENTED until trusted backend enrollment/signing and Firmware verification exist.
- Keep Gradle versionName "Telegram @horizontalzzz"; the Firmware artifact repository remains BIN-only.

## Canonical notes and prompt use

- Rules/authorization: CHAT_RULES.md.
- Index and retention decisions for every Markdown file: MEMORY_INDEX.md.
- Current-only state: PROJECT_STATE.md. Immediate handoff: HANDOVER.md.
- App behavior: APP_NOTES.md. Approved visual design: DESIGN_NOTES.md.
- Hardware/firmware: FIRMWARE_NOTES.md and firmware/FIRMWARE_TECHNICAL_REFERENCE.md.
- OTA: OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md. Voltage/Peltier: VOLTAGE_TRANSITION_MEMORY.md.
- App build process: BUILD_NOTES.md. Full attempt ledger: APP_BUILD_REPORT.md. History-only timeline: CHANGELOG.md. Immutable forensic snapshots: archive/.
- General Discussion/engineering handoff: Prompt 1 in CHAT_TRANSFER_PROMPTS.md. Build App handoff: Prompt 2 only.
- After a durable Discussion conclusion or execution completion/blockage, refresh this checkpoint and the relevant canonical note. Copy-ready transfer prompts use short command names without `@Thinking`: Prompt 1 defaults to `Diskusi!` (replace its first line with `Eksekusi Full!` or `Chat Stuck!` for those modes), and Prompt 2 starts with `Eksekusi Build App!`. If chat limit interrupts before saving, recover only from the last checkpoint and live evidence; do not claim unsaved content was preserved.
