# JE X FYZ / JE Cooler — Memory Index

## Current execution checkpoint — 2026-10-20

Build #124 / run `39386733061`, packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`, APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`, source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`. It includes the Wi-Fi password Show/Hide toggle and Home NOTIFY, passed 116 Flutter tests and configured App release gates; analyzer exited 0 with 25 info diagnostics, native Android test tasks were NO-SOURCE.
- Active Firmware update: `firmware/JEXFYZ-V7.1.ino` blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`; QC `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync test `7c203a11f79de62744af8536bbf2e3219d7f0909`. V7.1 is source-only / NOT COMPILED / NOT DEPLOYED; the prior V7.0 user report does not validate this revision.
- BLE App-only authorization remains BLOCKED / NOT IMPLEMENTED; OTA transport is protected and unchanged.

## Home NOTIFY — single latest-event message (validated in App Build #124)

- Packaged source blobs: `lib/main.dart` `2d44e1f1f5b88ca1dae8324082da751b6ef1485a`, `lib/app_settings.dart` `637c07be55c412451d9ffde762e080c8bd92fd5e`, `test/widget_test.dart` `90e1a582c49ce3ad1a1d9a3b875921098eaf2545`.
- Home NOTIFY displays one complete sentence for the latest confirmed event; ordinary Temperature samples do not notify, and Hotside-at-limit remains the safety-priority exception.
- Build #124 passed 116 Flutter tests. App CI does not validate Firmware V7.1 or physical thermal behavior.

## Current Adaptive Fan target-band contract

- Active Firmware source `firmware/JEXFYZ-V7.1.ino`, `FW_VERSION="V7.1"`, blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`. Target uses floored whole-degree categories relative to configured `hotLimit`: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%.
- At limit 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%. Bands shift with the configured limit.
- Preserve raw-decimal immediate safety, Fan 100% / Peltier OFF at or above limit, PWM pacing (+10 points/1 s and −10 points/10 s), one NTC sample per second, non-blocking loop and Adaptive 5 V/9 V at 100%.
- QC `12e30d7ec16b322e7411cefa7c99cd42aff6c056` and Touch/Adaptive sync `7c203a11f79de62744af8536bbf2e3219d7f0909` are updated; tests and Arduino compile have NOT RUN for V7.1.

## Current localization copy contract

- English/Indonesian labels and notices use centralized localization strings; Home heading `Notification` / `Notifikasi`, Settings `Notifications` / `Notifikasi`, Contact Developer localized.
- Firmware Update password is masked by default with localized Show/Hide controls and secure storage; released in Build #124.
- Firmware V7.1 does not modify App UI and is not included in Build #124's source package.

## Current verified release and source checkpoint

- Latest verified App release: Build #124 / run `39386733061`, packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`.
- APK asset 658613910, 54,751,323 bytes, SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`; source ZIP asset 658613911, 2,873,358 bytes, SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`.
- Build #124 passed 116 Flutter tests, analyzer exit 0 with 25 info diagnostics, configured Gradle gate, APK signature checks and source/release-asset validation; native Android JUnit tasks were NO-SOURCE.
- Active Firmware V7.1 `6ef355d666b83fc83b4d7c48ee377753828ca02c`; QC `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive `7c203a11f79de62744af8536bbf2e3219d7f0909`. Firmware V7.1 has NOT been compiled/deployed; no App source/build ran during this task.

## Current visual-state redraw checklist

- [x] Preserve Build #99's tested smoothness/state architecture without duplicating it.
- [x] Redraw disconnected/idle-state detail for all seven icons.
- [x] Keep unknown Battery/Hotside values from showing a fabricated live level.
- [x] Keep Peltier flakes and Fan Speed needle hidden when state/value is not authoritative.
- [x] Add source-contract regression for static detail, unknown-state rules and the 11-tick gauge.
- [ ] Run Dart analysis / Flutter tests for this follow-up.
- [ ] Inspect actual on-device rendering and profile frame workload.

## New-chat boot order

1. Read `CHAT_TRANSFER.md` completely before replacing it or making assumptions.
2. Fetch live `main` HEAD and recursive tree, current source/config/test/workflow hashes, branches/PRs, Actions runs, Release and tag refs, active `.ino`/embedded `FW_VERSION`, and artifact-repo tree.
3. Read `CHAT_RULES.md`, this index, `PROJECT_STATE.md`, `HANDOVER.md`, and the complete subject reference for the request.
4. Subject routing: App/UI/BLE → `APP_NOTES.md`; hardware/Firmware → `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`; OTA → `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md`; voltage/Peltier sequencing → `VOLTAGE_TRANSITION_MEMORY.md`; App build/release → `BUILD_NOTES.md`, `APP_BUILD_REPORT.md`, live workflow; grille/icons → `DESIGN_NOTES.md`; general history → `CHANGELOG.md`.
5. For a full chat-limit reconciliation, use Prompt A in `CHAT_TRANSFER_PROMPTS.md`, read the previous transfer fully, update and verify every other canonical file first, and replace `CHAT_TRANSFER.md` last. For a Build App context limit only, Prompt D is the one-shot LOAD + CONTINUE opener.
6. Use live source/run/ref evidence, never an old summary or historical hash. App CI does not prove physical BLE, cooling/safety, Firmware compilation, BIN identity, or OTA behavior.

## Permanent command and authorization protocol

- `@Thinking Diskusi!`: full read-only discussion; no repository writes.
- `@Thinking Diskusi! Tanya Gemini!` and `@Thinking Diskusi! Jawaban Gemini!` are valid only with `Diskusi!` in the same message.
- `@Thinking Eksekusi Full!`: execute the explicitly scoped source/docs/tests/audit task and commit directly to `main`; it does not authorize App Build, Firmware compile, BIN, Firebase, OTA, flash, device or unrelated release actions.
- `@Thinking Eksekusi Build App!`: sole end-to-end App Build/QC authorization, including evidence-based App-scope repairs/retries, published asset verification and updating `APP_BUILD_REPORT.md`.
- `@Thinking Chat Stuck!`: recover the most recent valid operation from live logs/state without blind retry or wider authorization.
- Retired commands: `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!`.
- Work directly on `main`; no branch/PR unless asked. Keep App trigger guarded to issue opened/reopened with repository owner, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, and token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; no push/PR bypass. Never change app `versionName "Telegram @horizontalzzz"`.

## Canonical file map

| File | Canonical purpose |
|---|---|
| `README.md` | Project overview, live validation boundary, navigation and repository split |
| `MEMORY_INDEX.md` | This memory routing index and current checkpoint |
| `CHAT_RULES.md` | Commands, authorization, version/repository separation and user restrictions |
| `PROJECT_STATE.md` | Current-only implementation/release state and open gates; no long build history |
| `CHAT_TRANSFER.md` | Detailed boot snapshot; replace last after complete reconciliation |
| `CHAT_TRANSFER_PROMPTS.md` | Prompt A memory reconciliation, Prompt B read-only boot, Prompt C persistence, Prompt D one-shot Build App LOAD + CONTINUE |
| `HANDOVER.md` | Immediate handoff, blocker, and next authorized action |
| `APP_NOTES.md` | UI, controls, BLE, state/telemetry, localization, notifications, Floating Monitor |
| `FIRMWARE_NOTES.md` | Hardware/pins, NTC, safety, Adaptive, transitions, touch/LED/preferences/telemetry |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Source architecture and implementation invariants; not compile proof |
| `OTA_PROTECTION.md` | Protected Local/Online OTA flow, safe outputs and gates |
| `OTA_REGRESSION_MEMORY.md` | CA/NTP experiment, failure evidence, `setInsecure()` security trade-off and preflight |
| `VOLTAGE_TRANSITION_MEMORY.md` | Peltier ramp, rail handoff, cancellation/recovery rules and hardware validation plan |
| `BUILD_NOTES.md` | Active App build procedure, toolchain, authorization and validation boundaries |
| `APP_BUILD_REPORT.md` | Authoritative App Build history; Build #123 is latest verified release; newest single-event NOTIFY follow-up remains unvalidated |
| `CHANGELOG.md` | Significant history and superseded decisions; never override current source |
| `DESIGN_NOTES.md` | Approved grille/logo/assets and dashboard motion/layout contracts |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Authoritative guarded manual App Build workflow |
| `test/*.dart` | Five current Flutter/source-contract test files; execution must be proven from run evidence |
| `firmware/JEXFYZ-V7.0.ino` | Active editable Firmware V7.0 source; user-reported compile/Online OTA success; verify matching BIN/device provenance independently |
| `archive/*.md` | Immutable forensic snapshots; stale “CURRENT” claims remain historical, paths retained verbatim |

- Active Firmware: `firmware/JEXFYZ-V7.0.ino` blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`; QC contract: `test/firmware_qc_contract_test.dart` blob `a44c12d32c472f109687c06316ea40f70fcf93ce`; Touch/Adaptive sync contract: `test/firmware_touch_adaptive_sync_test.dart` blob `b3e23e59deae19408cd7ccbacbad84273f958970`. V7.0 tests and Arduino compile have NOT RUN; the previous V6.9 compile/install report is not V7.0 validation.
## Historical source fingerprints (Build #99 validated older baseline; current single-event NOTIFY follow-up NOT RUN; Firmware V7.0 source-only)

- Current lib/main.dart: 40f172a5d190b429d3a952f2531349c1ee220d1f; lib/app_settings.dart: 44431e926bfa2557c26345899e2333bd767f3f8e; test/widget_test.dart: 132c3b000abd63599ebea9d26fc5085cb577e50e. Home NOTIFY uses one sentence per latest event, not a combined summary. Tests and analyzer have NOT RUN.
- Historical layout/painter test baseline: a82875dd47ad904818fcd4c1c47b1a3ac0ca8fd2; latest current test blob is recorded above.
- lib/jex_animated_glyph.dart: b37fc4e0807c874b2f01db00c7f606810cb5deca — generic action glyphs static.
- Build #99 validated source commit bc1498d5b3db7621ee18f5ca6f021e6013c73b09, source blob 30d864c2f03c40fd4d0b6926a9958153f2a3b236 and test blob 711a44b00eadee2e2bcd24e48383128f0d70ccc9.

## Evidence labels

- **CURRENT / VERIFIED:** directly checked live code/tree/ref/Actions/Release data.
- **SOURCE IMPLEMENTED / NOT RUN:** code/test contracts exist; test/analyzer/build has not executed for that change.
- **USER-REPORTED:** reported by user, not independently validated.
- **UNVERIFIED:** required supporting evidence is missing.
- **HYPOTHESIS:** plausible cause, not established.
- **HISTORICAL / SUPERSEDED:** valid for an older source/version/run only.
- **NOT RELEASED:** current source differs from last verified release or release tag/asset consistency is incomplete.

## Durable repository/evidence restrictions

- All source, documentation, tests and project memory remain in `TenzoNkz/JEXFYZ-App`. Keep `TenzoNkz/JEXFYZ-Firmware` BIN-only. Live BIN metadata: `JEXFYZ.cpp.bin`, blob `821b022f97353d9a7aea4695b2e37c98b7488e15`, 1,456,560 bytes. Only tree metadata was checked; do not read or mutate payload or infer source provenance.
- V6.9 source blob 8e0f0ff5a65962ebdb44300b05fc161cf9349d96 uses deterministic Adaptive Fan temperature tiers. The user reports compile/install success; exact source/BIN identity, installed version, Firebase state and full OTA apply/reboot/reconnect remain unverified. V6.7 compile/online-update and V6.6 two-OTA reports are historical user reports.
- Current UI excludes a standalone Battery Protection Guard. The exclusive one-App/one-cooler pairing lock is a user design requirement; encrypted/bonded writes alone do not prove exclusive provisioning.
- Preserve OTA protection and its `setInsecure()` server-identity trade-off; read OTA and voltage-transition references before changes. Preserve the approved white square grille/purple X/four corner holes/flat-print design and transparent square app assets.
- Keep the permanent hardware timings, NTC single-sample rule, safety gates, Adaptive profile behavior, BLE P1 UUIDs, LED mode IDs and telemetry contracts in their canonical subject files.
- Latest release checkpoint: Build #124 / run `39386733061` passed the guarded issue-trigger workflow; Release/tag and assets match packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. Password visibility is included. Firmware V7.1 remains source-only; BLE authorization remains blocked pending trusted enrollment/signing. BLE authorization remains blocked on the missing trusted enrollment/signing backend.
