# JE X FYZ / JE Cooler — Memory Index

## Current Adaptive Fan temperature-category contract

- Firmware-owned Adaptive Fan target tiers live in `firmware/JEXFYZ-V7.0.ino`; its filename and embedded `FW_VERSION="V7.0"` now agree. The target uses floored whole-degree Hotside categories; for a 40°C limit, both 36.3°C and 36.8°C target 70%, while target 80% starts in category 37.
- Preserve the independent raw-decimal Hotside safety override (immediate Fan 100%), 10-point PWM pacing (up every 1 second, down every 10 seconds), one NTC sample each second and the non-blocking main loop.
- Current source/test hashes, unrun test/compile status and implementation details are recorded in `PROJECT_STATE.md`, `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`, `APP_NOTES.md`, `HANDOVER.md`, and the newest `CHANGELOG.md` / `CHAT_TRANSFER.md` entries.

## Current localization copy contract

- English/Indonesian labels and user-facing notices live in `lib/app_settings.dart` (`JexText`) or `JexText.phrase()` in `lib/main.dart`. Keep the Home heading localized as `Notification` / `Notifikasi`, Settings as `Notifications` / `Notifikasi`, and Contact Developer as `Contact Developer` / `Hubungi Pengembang`.
- Current source/test fingerprints and validation boundaries are recorded in `PROJECT_STATE.md`, `APP_NOTES.md`, `HANDOVER.md`, `CHAT_TRANSFER.md`, and the latest `CHANGELOG.md` entry. Build #116 remains the latest verified App release; this copy pass is source-only until the separate Build App flow.


Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #116 is the latest successful App release; the final flame/rounded-clip/NOTIFY-label follow-up is source-updated but NOT RUN / NOT RELEASED. V6.9 compile/install was previously user-reported; active V7.0 source is NOT COMPILED / NOT INSTALLED. Source-to-BIN provenance and installed-device version remain UNVERIFIED. Live source/refs/Actions/Release override memory.

## Current verified release and source checkpoint

- Latest successful release: Build #116 / Actions run 39355262101, packaged source 48683874db659df940272bed1c860072ead2d767. The live jexfyz-latest Release/tag and both assets target that commit.
- APK asset 657979004, 54,734,939 bytes, SHA-256 8570914f331583d2cc462f61881609c0eae56639a139f2d60a832e4aaa81ea27; corresponding source ZIP asset 657979008, 2,867,315 bytes, SHA-256 60ef4e79529aabcbb4f4093b9f8a18b5d383d5c651c1c303dd8bb774e7b0dd5d.
- Build #116 passed 109 Flutter tests, analyzer exit 0 with 25 info-level diagnostics, Android gate/signing checks, source ZIP integrity and downloaded-asset/tag verification. Native Android test tasks were NO-SOURCE.
- Current unvalidated source/test blobs: lib/main.dart 8eb24de58a2e510b3d05abbb29bce45bb0a42810; test/widget_test.dart a82875dd47ad904818fcd4c1c47b1a3ac0ca8fd2. All seven Home rows remain 45 dp, NOTIFY stays fixed at 44 dp with a 2 dp title inset and exact category-free heading, the body scales to two lines, and the latest falling-flame background is rounded-frame-clipped. Flutter tests/analyzer have NOT RUN for this final follow-up.
- Active Firmware source is `firmware/JEXFYZ-V7.0.ino`, blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`, embedded `FW_VERSION="V7.0"`. V7.0 is source-only / NOT COMPILED / NOT INSTALLED; the prior V6.9 report does not validate this revision.

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
| `APP_BUILD_REPORT.md` | Authoritative App Build history; Build #116 is latest successful release; the post-#116 flame/NOTIFY follow-up remains unvalidated |
| `CHANGELOG.md` | Significant history and superseded decisions; never override current source |
| `DESIGN_NOTES.md` | Approved grille/logo/assets and dashboard motion/layout contracts |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Authoritative guarded manual App Build workflow |
| `test/*.dart` | Five current Flutter/source-contract test files; execution must be proven from run evidence |
| `firmware/JEXFYZ-V7.0.ino` | Active editable Firmware V7.0 source; not compiled/installed; verify matching BIN provenance before claiming source-to-BIN identity |
| `archive/*.md` | Immutable forensic snapshots; stale “CURRENT” claims remain historical, paths retained verbatim |

- Active Firmware: `firmware/JEXFYZ-V7.0.ino` blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`; QC contract: `test/firmware_qc_contract_test.dart` blob `a44c12d32c472f109687c06316ea40f70fcf93ce`; Touch/Adaptive sync contract: `test/firmware_touch_adaptive_sync_test.dart` blob `b3e23e59deae19408cd7ccbacbad84273f958970`. V7.0 tests and Arduino compile have NOT RUN; the previous V6.9 compile/install report is not V7.0 validation.
## Current source fingerprints (Build #116 successful; final App follow-up NOT RUN; Firmware V7.0 source-only)

- lib/main.dart: 8eb24de58a2e510b3d05abbb29bce45bb0a42810 — seven 45 dp Home rows, 3 dp pre-NOTIFY gap, fixed 44 dp NOTIFY with exact category-free heading, 2 dp label inset and adaptive two-line body, stable cooler constraints, and rounded-frame-clipped falling flame background; NOT RUN / NOT RELEASED.
- test/widget_test.dart: a82875dd47ad904818fcd4c1c47b1a3ac0ca8fd2 — layout/painter contracts for 45 dp rows, fixed-height two-line NOTIFY, stable image constraints, flame paths, rounded-frame clipping and category-free heading; tests NOT RUN.
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
- Latest exact next action: after a separate `@Thinking Eksekusi Build App!`, verify the issue-triggered workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; then re-fetch and compare Release metadata, APK/source ZIP hashes and source marker. Until then, overall Release handoff is **BLOCKED**.
