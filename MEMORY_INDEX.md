# JE X FYZ / JE Cooler — Memory Index

Last reconciled against live `main` on 2026-10-15 (Asia/Jakarta). Latest verified App Build remains #35 / run `38669526891`, built from older code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`; its Dart analyze and 74 Flutter tests passed, APK V1/V2/V3 checks passed, and the release asset was verified. Newer Color Picker and Floating Monitor/ADB FPS source/test changes have been committed but are UNBUILT and their added tests have NOT RUN. `@Thinking Chat Stuck!` is a valid recovery command. This index routes memory; always fetch live HEAD and blob fingerprints before acting. Device-side rendering/signature inspection and Firmware/hardware validation remain separate gates.
## New-chat boot order
1. Read `CHAT_TRANSFER.md` completely.
2. Fetch live `main` HEAD, recursive tree, active Firmware source, App source, tests, build workflow and open-PR state.
3. Read `MEMORY_INDEX.md`, `CHAT_RULES.md` and `PROJECT_STATE.md` completely.
4. Read all canonical subject files relevant to the task: App → `APP_NOTES.md`; Firmware/hardware → `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`; OTA → `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md`; Peltier rail transitions → `VOLTAGE_TRANSITION_MEMORY.md`; Build → `BUILD_NOTES.md`; approved visuals → `DESIGN_NOTES.md`.
5. Read `HANDOVER.md` for exact next actions and `CHANGELOG.md` for history.
6. For general/Discussion chat limits, use Prompt A for a full project-memory reconciliation when needed, or Prompt B for a read-only new-chat boot. For a Build App chat limit, use Prompt D exactly once as the first message in the replacement Build App chat; it loads live state and continues the work. No separate recap chat/prompt.
7. Only the general project-memory reconciliation Prompt A replaces `CHAT_TRANSFER.md`, and only when that reconciliation is actually needed. A Build App handoff uses `APP_BUILD_REPORT.md` + Prompt D; do not run Prompt A or replace `CHAT_TRANSFER.md` just to transfer Build App work.

## Command protocol quick reference
- Full read-only planning: `@Thinking #Diskusi!`.
- Gemini prompt/answer only with parent: `@Thinking #Diskusi! #Tanya Gemini!` and `@Thinking #Diskusi! #Jawaban Gemini!`; reject either without `#Diskusi!` and do not handle the substantive request.
- Full authorized execution: `@Thinking #Eksekusi Full!`; it does not trigger App Build.
- Full App Build retry/verification/report loop: `@Thinking #Build App!`.
- Emergency recovery: `@Thinking Chat Stuck!` — inspect live logs/state and resume the last verified checkpoint under the existing authorization; no blind retries or automatic build.
- Retired: standalone `#Eksekusi!` and combined `#Eksekusi & Build App!`.

## Canonical file map
| File | Purpose |
|---|---|
| `README.md` | Project overview and navigation |
| `MEMORY_INDEX.md` | Read order and memory routing |
| `CHAT_RULES.md` | Permanent commands, user authorization, versioning, repository separation and persistence rules |
| `PROJECT_STATE.md` | Current state and unverified gates only; no historical status dumps |
| `CHAT_TRANSFER.md` | Detailed transfer snapshot and boot checklist; verify against live main |
| `CHAT_TRANSFER_PROMPTS.md` | Prompt A = broad project-memory reconciliation; Prompt B = read-only general/Discussion boot; Prompt C = persist a lasting decision; Prompt D = one-shot Build App chat-limit LOAD + CONTINUE (no recap chat) |
| `HANDOVER.md` | Current next actions and unresolved validation gates |
| `APP_NOTES.md` | UI/navigation, named LED palette/preview, voltage-aware Fan motion/coast-down, full-colour box-free Peltier crystal, retargetable Fan Speed gauge/zero return and seamless needle wobble, sinusoidal voltage sheen and Bluetooth ripple envelope, staged Color Picker draft with top-left Cancel/top-right Select and blocked outside/back dismissal, Peltier Safety dialogs, offline menu fallback, JE notification monogram, BLE/P1, telemetry, phone Battery heartbeat, Battery Protection Guard presentation rule, pairing-design caveat, localization, reconnect and App contracts |
| `FIRMWARE_NOTES.md` | Hardware, pins, sensor model, cooling, Adaptive, timing and safety contracts |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Current code architecture and static invariants |
| `OTA_PROTECTION.md` | Frozen OTA areas and required approval/re-audit |
| `OTA_REGRESSION_MEMORY.md` | Online OTA incident, current transport, trade-off and evidence boundary |
| `VOLTAGE_TRANSITION_MEMORY.md` | Peltier soft-start interruption, timing contract and physical QC plan |
| `BUILD_NOTES.md` | Manual APK trigger, end-to-end retry policy, toolchain and release boundaries |
| `APP_BUILD_REPORT.md` | Durable per-attempt Build App evidence ledger; Prompt D uses it to load and continue the same Build App work across context limits. Discussion may consult it for evidence; no separate Build App recap chat |
| `CHANGELOG.md` | Historical decisions and superseded approaches |
| `DESIGN_NOTES.md` | Approved grille, monogram, 1:1 geometry, assets and visual constraints |
| `android/app/src/main/res/drawable/ic_notification.xml` + `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JexNotificationUtils.kt` | Android notification JE monochrome small-icon vector and app-open PendingIntent |
| `test/*.dart` | Regression contracts; presence does not mean they ran |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Authoritative explicit App Build workflow |
| `firmware/JEXFYZ-V6.6.ino` | Canonical editable Firmware source |
| `archive/LEGACY_NOTES_SNAPSHOT_2026-10-14.md` | Verbatim pre-cleanup state/reference docs for forensic recovery only; contains stale claims |
| `archive/LEGACY_TRANSFER_HISTORY_2026-10-14.md` | Verbatim pre-cleanup transfer/rules/history docs for recovery only; contains stale claims |
| `archive/ARTIFACT_REPO_NOTES_PRE_BIN_ONLY_2026-10-14.md` | Verbatim prior notes from artifact repository before enforcing BIN-only policy; recovery only |

## Source-of-truth order
1. Live `main` source, tree, Git refs, workflow definitions and current CI/run data.
2. `CHAT_RULES.md` for user authorization and workflow rules.
3. `PROJECT_STATE.md` after live reconciliation.
4. Subject-specific reference and incident-memory files.
5. `HANDOVER.md` for next steps.
6. `CHANGELOG.md` for history only.
7. `CHAT_TRANSFER.md` after checking its HEAD/hash claims.
8. Chat summaries and legacy archives as context only; neither overrides live source.

## Evidence labels
- **CURRENT / VERIFIED** — directly rechecked against current GitHub state/evidence.
- **IMPLEMENTED IN SOURCE / NOT RUN** — code or test contract exists; execution is not proven.
- **USER-REPORTED** — user reported it; assistant did not independently verify it.
- **UNVERIFIED** — required evidence is missing.
- **HYPOTHESIS** — possible explanation, not established cause.
- **HISTORICAL / SUPERSEDED** — accurate only for the named older version.
- **NOT RELEASED** — not established or authorized as production.

## Persistence / reorganization rules
- Store all project source and memory in `TenzoNkz/JEXFYZ-App`. The separate `TenzoNkz/JEXFYZ-Firmware` repository must contain only `JEXFYZ.cpp.bin`.
- Each lasting decision belongs in one canonical subject file. The single App Build evidence log is `APP_BUILD_REPORT.md`; keep `PROJECT_STATE.md` concise and point to this log rather than duplicating every attempt. Update current state when it changes, add a concise changelog entry for meaningful behavior/rule changes, and refresh CHAT_TRANSFER after a substantial execution.
- At context limit, read the previous transfer snapshot completely, inventory live repo, reconcile current claims/hashes, then replace the whole snapshot. Never append another current-status block.
- After file moves/renames, update every Markdown link, prompt, path-based test, index and workflow comment; verify the final tree.
- Legacy archives preserve exact pre-cleanup content. Their old current/version claims are deliberately stale and must not be copied into current notes.
- Preserve approved decisions, rejected approaches and why, prior defects, symptoms, hypotheses, verification state and authorization limits. Do not fill memory gaps by guessing.
- The App note is the canonical home for the requirement that a standalone Battery Protection Guard must not be displayed, the 1 Hz phone-battery heartbeat contract, and the unverified one-App/one-cooler pairing-lock design intent. Do not promote the pairing-lock intent to implemented status without source and physical evidence.
