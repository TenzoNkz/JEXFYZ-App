# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub main on 2026-10-19 (Asia/Jakarta). Build #106 is the latest successful release; current Home NOTIFY alignment and Battery/Hotside/Voltage animation edits are newer source and NOT RUN / NOT RELEASED. This file is the navigation index; `PROJECT_STATE.md` carries current state, subject files own detailed contracts, `APP_BUILD_REPORT.md` owns build evidence, `CHANGELOG.md` owns history, and `CHAT_TRANSFER.md` is the detailed next-chat boot snapshot. Live source, Git refs, Actions and Release metadata override memory.

## Current verified release and source checkpoint

- Latest successful release is Build #106 / Actions run 39279938461, packaged source `9f90cf6063ee7786613f8b5dfa1c6b0412d89638`. Analyzer exited 0 with 25 info findings/no errors or warnings; 108 Flutter tests passed; Android gate and release-asset validation passed.
- Build #106 APK asset ID `656702702`, SHA-256 `bab332a4312c628178e384a88d513cf8546ff15ab4b4e3f3becf2e70b10830cc`; source ZIP asset ID `656702729`, SHA-256 `0bb86c4e6bd7d3cb7a6bb894658bd707acee48bac106fc5227f8adcba584ec98`.
- Current Home NOTIFY alignment and icon-animation source is NOT RUN / NOT RELEASED: `lib/main.dart` `7e09a3d28b4efe24bdced858db4274cf70806284`; `lib/app_settings.dart` `8f228000d38d73038c06f569c052b1af601288a5`; `test/widget_test.dart` `5a82cf79e6c5c40fc34489ce90cf1200cf9faccb`.
- Home NOTIFY uses left-aligned bilingual copy, no CONNECTED/DISCONNECTED badge, and at most two readable lines. Battery/Hotside use clipped oval thermal bursts; Voltage uses outer-contour pulses. Raw reason/OTA identifiers remain hidden.
- Tests/analyzer have NOT RUN for the current source. Build #106 remains the latest successful release and does not include these changes. No Firmware/BIN/Firebase/OTA/device operation occurred.

## Current visual-state redraw checklist

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
| `APP_BUILD_REPORT.md` | Authoritative complete build attempts/fixes/results; current Build #83 and blocked Release handoff |
| `CHANGELOG.md` | Significant history and superseded decisions; never override current source |
| `DESIGN_NOTES.md` | Approved grille/logo/assets and dashboard motion/layout contracts |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Authoritative guarded manual App Build workflow |
| `test/*.dart` | Five current Flutter/source-contract test files; execution must be proven from run evidence |
| `firmware/JEXFYZ-V6.7.ino` | Active editable V6.7 source; user compiles separately |
| `archive/*.md` | Immutable forensic snapshots; stale “CURRENT” claims remain historical, paths retained verbatim |

## Current source fingerprints (Build #106 successful; current UI follow-up NOT RUN)

- lib/main.dart: 7e09a3d28b4efe24bdced858db4274cf70806284 — oval thermal bursts, Voltage edge pulses, left-aligned NOTIFY; NOT RUN / NOT RELEASED.
- test/widget_test.dart: 5a82cf79e6c5c40fc34489ce90cf1200cf9faccb — animation/layout source contracts; NOT RUN / NOT RELEASED.
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

- All source, documentation, tests and project memory remain in `TenzoNkz/JEXFYZ-App`. Keep `TenzoNkz/JEXFYZ-Firmware` BIN-only. The currently checked BIN metadata is `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes; do not read or mutate payload during documentation tasks, and do not infer source provenance.
- User reports V6.7 compilation and online update. Source/BIN identity, installed version, Firebase state, and full OTA apply/reboot/reconnect remain unverified. The previous V6.6 compile/two-OTA statements are historical user reports.
- Current UI excludes a standalone Battery Protection Guard. The exclusive one-App/one-cooler pairing lock is a user design requirement; encrypted/bonded writes alone do not prove exclusive provisioning.
- Preserve OTA protection and its `setInsecure()` server-identity trade-off; read OTA and voltage-transition references before changes. Preserve the approved white square grille/purple X/four corner holes/flat-print design and transparent square app assets.
- Keep the permanent hardware timings, NTC single-sample rule, safety gates, Adaptive profile behavior, BLE P1 UUIDs, LED mode IDs and telemetry contracts in their canonical subject files.
- Latest exact next action: after a separate `@Thinking Eksekusi Build App!`, verify the issue-triggered workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; then re-fetch and compare Release metadata, APK/source ZIP hashes and source marker. Until then, overall Release handoff is **BLOCKED**.
