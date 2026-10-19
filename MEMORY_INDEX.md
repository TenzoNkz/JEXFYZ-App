# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub `main` on 2026-10-19 (Asia/Jakarta). This file is the navigation index; `PROJECT_STATE.md` carries current state, subject files own detailed contracts, `APP_BUILD_REPORT.md` owns build evidence, `CHANGELOG.md` owns history, and `CHAT_TRANSFER.md` is the detailed next-chat boot snapshot. Live source, Git refs, Actions and Release metadata override memory.

## Current verified release and source checkpoint

- Latest successful verified release: **Build #95** / [Actions run 39217718351](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39217718351), source `cd691b874ddb0e454ba69891a3e0da3001df892f`. All 21 guarded workflow steps passed; analyzer passed with 23 info-level deprecations; **99/99 Flutter tests passed**; APK signature/certificate, corresponding source ZIP, release assets and tag/source checks passed. Native JUnit tasks were NO-SOURCE.
- Build #95 APK asset `655596091`, SHA-256 `856718ada30c5ef5081b5bb28a5e00c3b9d234e00ebced58a211112cc381140d`; source ZIP asset `655596090`, SHA-256 `262d552e564b7c0a1727048a2e2897777ff18fa7296381a77f2c10236784ce7e`.
- The current smoothness follow-up is newer than Build #95 and **SOURCE ONLY / NOT RUN / NOT RELEASED**. Source blob: `lib/main.dart` `f0bc1375799e7b9e4466a3124ddb031d5f58e522`; test blob: `test/widget_test.dart` `aaf911cdcf5e23a23b80c2ef47ca4e11d406f9cf`.
- Diagnosed stiffness: slow 4.2–6.4 s cycles on tiny glyphs, tiny particle geometry, non-periodic drift, whole-icon breathing, crystal spin tied to snowfall, and abrupt Fan angular-rate changes. The follow-up updates cycle timing, particle size/fade, periodic phase drift, Peltier crystal motion, Home drawable size, and phase-integrated Fan speed changes.
- Regression tests cover fade math, Fan rate integration, cadences, crystal movement separation, painter repaint dependencies and Home drawable size. Neither Dart nor Flutter CLI is installed; analysis/tests are **NOT RUN**. Build #95 is not proof that this newer source is validated or packaged. Physical rendering remains UNVERIFIED.

## Current smoothness-rework checklist

- [x] Source and supplied recording reviewed; likely causes identified.
- [x] Battery/Hotside particles enlarged, drift periodic, phase-wrap fade added.
- [x] Peltier snow enlarged/faded; crystal motion decoupled from snowfall.
- [x] Fan angular rate is integrated and retargeted without resetting accumulated phase.
- [x] Home glyph size increased inside the unchanged tile; layout/state semantics preserved.
- [x] Regression test source updated.
- [ ] Dart analysis / Flutter tests (CLI unavailable; NOT RUN).
- [ ] Real-device/profile-mode smoothness verification.


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

## Source fingerprints (after animation smoothness follow-up; final HEAD/tree in CHAT_TRANSFER.md)

- `lib/main.dart`: `f0bc1375799e7b9e4466a3124ddb031d5f58e522` (smoothness follow-up; NOT RUN / NOT RELEASED).
- `test/widget_test.dart`: `aaf911cdcf5e23a23b80c2ef47ca4e11d406f9cf` (updated deterministic/source-contract tests; NOT RUN).
- `lib/jex_animated_glyph.dart`: `b37fc4e0807c874b2f01db00c7f606810cb5deca` (static generic action/settings glyph).
- Final commit and all changed-document hashes are recorded in `CHAT_TRANSFER.md`.


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
