# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-10-23 (Asia/Jakarta). This is the rolling continuation state, not a transcript or a substitute for live repository checks. Prompt 1 begins with `Diskusi!`; Prompt 2 begins with `Eksekusi Build App!`. For explicitly authorized execution/recovery variants, replace Prompt 1's first line with `Eksekusi Full!` or `Chat Stuck!`.

## Product/release baseline

- **Field unit (USER-REPORTED):** the sold/shipped unit remains reported at App Build #124 + Firmware V7.1, compiled/applied through Online OTA. Build #128 has not been independently observed installed on that physical unit; avoid inferring field behavior from CI.
- **Latest verified App release:** [Build #128 / run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), packaged source `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. Release ID `403010611`; Release metadata and `refs/tags/jexfyz-latest` both target that exact source SHA.
- APK: [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), 54,751,323 bytes, SHA-256 `2f5fdf4ffab0eccac3db886855b34f8c2c6c83afb54d7088fd2f8b578d322c5b`. Corresponding source ZIP: [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), 2,877,957 bytes, SHA-256 `9b740671f7e8d3b9d4cfc1b1e5f3200af905ba207d4a6c8a6b27114f39ec32f4`.
- Build #128 passed all 21 workflow gates, 121 Flutter tests, analyzer (25 informational diagnostics), the configured Android Gradle gate, V1/V2/V3 + expected certificate checks, source-marker/ZIP checks and independent downloaded APK/source checksum verification. Native Android JUnit tasks were NO-SOURCE.
- App release CI is not evidence of Firmware compile/BIN identity, installation on the sold unit, OTA apply/reboot, BLE recovery or thermal/electrical behavior.

## Latest App Build result — SUCCESS — 2026-10-23 (Asia/Jakarta)

- **Build #128 complete:** [Actions run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), conclusion `success`; job `120264345808`, runner `1000002427`. Exact tested/package source: `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. All 21 workflow steps and post-job cleanup completed successfully.
- **QC:** analyzer exit 0 with 25 info diagnostics; 121 Flutter tests passed; configured Android Gradle gate passed (native Android JUnit tasks were `NO-SOURCE`). APK build/obfuscation, generated/downloaded APK V1/V2/V3 signatures, official certificate, corresponding ZIP/source marker, exactly-one-APK-plus-one-ZIP and step-21 re-download verification all passed.
- **Release identity:** Release ID `403010611` and live tag `jexfyz-latest` target the exact run SHA. APK SHA-256 `2f5fdf4ffab0eccac3db886855b34f8c2c6c83afb54d7088fd2f8b578d322c5b`; source ZIP SHA-256 `9b740671f7e8d3b9d4cfc1b1e5f3200af905ba207d4a6c8a6b27114f39ec32f4`.
- **Durable ledger:** [APP_BUILD_REPORT.md success checkpoint](https://github.com/TenzoNkz/JEXFYZ-App/commit/b881b708d7be38c7d98e6270d7775d09af7eb044). Latest package does not prove installation/behavior on the shipped unit; its Build #124 + V7.1 status remains USER-REPORTED.
- **Next:** no additional build is needed for this source. Do not trigger another release unless the owner explicitly requests a new one. Preserve Android `versionName "Telegram @horizontalzzz"`; no Firmware/BIN/Firebase/OTA/flash/device operations are authorized.

## Live repository point

- Documentation audit began on TenzoNkz/JEXFYZ-App/main at 11a0ef162f1c2945704229ed7697dc70e7617e9b, commit message "fix: sync Android notification channels with app language", dated 2026-10-23. The docs-only rework commit moves main forward; fetch live HEAD/tree at every boot instead of trusting this audit-base SHA.
- At audit start, recursive tree had 69 entries, untruncated; no open PRs were returned.
- Active Firmware source is firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- Latest verified App release is Build #128 / run `39908023440`, packaged source `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`; the release/tag and downloaded asset checks are verified in `APP_BUILD_REPORT.md`.

## Last durable task and result

### Memory checkpoint rule

GitHub memory is not an automatic transcript of this chat. A state is considered saved only after the relevant checkpoint/note is committed to `main` and the resulting content is verified. Save at each durable decision, logical milestone, and task success/blockage; for Build App, update `APP_BUILD_REPORT.md` as each attempt progresses. Before an expected chat limit, record the active scope, last verified step, remaining work, run status, blocker, and next action. If interruption happens before a commit finishes, recover only the last verified checkpoint and live evidence; never claim the unsaved portion was preserved.

Latest durable task/result (2026-10-23): under `@Thinking Eksekusi Build App!`, Build #125 hit a pre-runner startup failure; Builds #126/#127 exposed three stale static-test assertions; those assertions were repaired without changing runtime App behavior or weakening gates. Build #128 then passed all workflow gates and published the exact tested source, production-signed APK and matching source ZIP. Detailed evidence and all failed attempts remain preserved in `APP_BUILD_REPORT.md`; this checkpoint records the successful current package.

Important persistence boundary: GitHub does not automatically receive the ChatGPT transcript. An abrupt interruption before a verified commit can leave an unsaved tail; next chat must recover the last committed checkpoint and live source/run evidence rather than inventing that missing tail.

Exactly two transfer prompts remain in `CHAT_TRANSFER_PROMPTS.md`: Prompt 1 starts `Diskusi!` and can be switched to `Eksekusi Full!` or `Chat Stuck!`; Prompt 2 starts `Eksekusi Build App!`. The copy-ready command names intentionally omit `@Thinking`.

The prior memory-policy audit was documentation-only. The subsequent, separately authorized App Build operation did execute the guarded App QC/release workflow and is now recorded above. No Firmware compile, BIN/Firebase mutation, OTA, flash or device action occurred. Always fetch live main HEAD/tree and the latest Actions/Release evidence on a new task.

Durable design decision (2026-10-23): the Home notice heading follows the selected App language — `Notification` in English and `Notifikasi` in Indonesian. The current Build #128 source/release has since passed all guarded App CI gates; this CI result still does not establish physical-device installation or Firmware/device behavior.

## Historical pre-Build notes reconciliation — 2026-10-23 (superseded by Builds #126–#128)

- This Discussion-mode audit began from live `main` HEAD `3234cecd7903f66622e5bf1b14fdb1dfc86fcb82`, commit "docs: checkpoint Home notice localization decision". Its recursive tree had 69 entries (`truncated=false`), and the open-PR query returned none. Documentation-only writes from this audit advance main beyond that starting SHA; fetch the final live HEAD before any later action.
- A stale sentence in `MEMORY_INDEX.md` still described the Home notice heading as an unresolved mismatch, contradicting the owner decision and the resolved contracts in `APP_NOTES.md`/`DESIGN_NOTES.md`. It has now been corrected. `CHANGELOG.md`, `PROJECT_STATE.md` and `HANDOVER.md` were also refreshed to record the pre-build state and keep the handoff accurate.
- At this historical point, Build #125 / run `39905665853` had failed before runner steps: job `120256919402`, `runner_id=0`, empty runner name, no steps/log/artifacts. This was later followed by #126 and #127 test failures and then the successful #128 runner/build/release; the earlier infrastructure blocker is closed for the current run, while its root cause was never established.
- At this historical point, Release `jexfyz-latest` and its tag still targeted Build #124 source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. That package has since been superseded by the verified Build #128 release documented above.
- Build readiness decision at the time: do not broadly rewrite every repo note. The current release now exists, and this handoff supersedes that pre-build readiness status. Keep `APP_BUILD_REPORT.md` and `CHANGELOG.md` as history ledgers and leave `archive/*.md` immutable.
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
