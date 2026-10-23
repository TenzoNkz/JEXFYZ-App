# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-10-23 (Asia/Jakarta). This is the rolling continuation state, not a transcript or a substitute for live repository checks. Prompt 1 defaults to `@Thinking Diskusi!`; Prompt 2 begins with `@Thinking Eksekusi Build App!`. For Prompt 1 execution/recovery variants, replace its first line with the matching command.

## Product/release baseline

- Owner reports the sold/shipped unit uses App Build #124; Firmware V7.1 was compiled and installed through Online OTA. Treat those deployment claims as USER-REPORTED.
- Verified App artifact: [Actions run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), packaged source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. APK SHA-256 c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318; source ZIP SHA-256 e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152.
- Production baseline remains Build #124 + V7.1. The unit is sold/shipped and not routinely available for physical repair; future changes must be conservative.
- App release CI is not evidence of Firmware compile/BIN identity, OTA apply/reboot, BLE recovery or thermal/electrical behavior.

## Live repository point

- Documentation audit began on TenzoNkz/JEXFYZ-App/main at 11a0ef162f1c2945704229ed7697dc70e7617e9b, commit message "fix: sync Android notification channels with app language", dated 2026-10-23. The docs-only rework commit moves main forward; fetch live HEAD/tree at every boot instead of trusting this audit-base SHA.
- At audit start, recursive tree had 69 entries, untruncated; no open PRs were returned.
- Active Firmware source is firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- Latest release record is Build #124; current App source-only UI changes have no later verified package.

## Last durable task and result

Latest durable task: the owner requested that every copy-ready chat-transfer prompt include the command prefix appropriate to its chat mode, after a transfer payload sent without a recognized command was treated as a prompt title rather than a command. The two-prompt structure remains intact: Prompt 1 defaults to `@Thinking Diskusi!` and its first line is replaced with `@Thinking Eksekusi Full!` or `@Thinking Chat Stuck!` for those respective modes; Prompt 2 begins with `@Thinking Eksekusi Build App!`. No command is duplicated above the pasted block.

The prior documentation rework remains complete. The Home notice-heading mismatch stays unresolved: live source renders localized Notification / Notifikasi, while DESIGN_NOTES.md still records the fixed NOTIFY requirement. No product behavior change is included in this prompt-prefix task.

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
- After a durable Discussion conclusion or execution completion/blockage, refresh this checkpoint and the relevant canonical note. Copy-ready transfer prompts include command prefixes: Prompt 1 defaults to `@Thinking Diskusi!` (replace its first line for Eksekusi Full or Chat Stuck), and Prompt 2 starts with `@Thinking Eksekusi Build App!`. If chat limit interrupts before saving, recover only from the last checkpoint and live evidence; do not claim unsaved content was preserved.
