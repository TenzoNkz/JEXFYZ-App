# JE X FYZ / JE Cooler — Memory Index

Last reconciled against `main`: 2026-10-14 (Asia/Jakarta). This is a routing index, not a substitute for checking GitHub live.

## New-chat boot order

1. Read `CHAT_TRANSFER.md` completely.
2. Fetch current `main` HEAD, recursive tree, active Firmware source, App source, tests, build workflow and open-PR state.
3. Read `CHAT_RULES.md` and `PROJECT_STATE.md` completely.
4. Read `APP_NOTES.md` for an App task; `FIRMWARE_NOTES.md` and `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` for firmware/hardware; `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` for OTA; `VOLTAGE_TRANSITION_MEMORY.md` for voltage/Peltier transitions; `BUILD_NOTES.md` for build; `DESIGN_NOTES.md` for grille/icon/visual work.
5. Read `HANDOVER.md` for next actions. Read `CHANGELOG.md` for historical context only.
6. Follow `CHAT_TRANSFER_PROMPTS.md` at chat/context limit. Never rely only on an old chat summary.

## File ownership

| File | Canonical purpose |
|---|---|
| `README.md` | Project overview and documentation navigation |
| `MEMORY_INDEX.md` | This index: read order and memory routing |
| `CHAT_RULES.md` | Permanent commands, user authorization, versioning, repo split and persistence rules |
| `PROJECT_STATE.md` | Current state / source version / validation gates only; no historical state dumps |
| `CHAT_TRANSFER.md` | Detailed transfer snapshot, boot checklist, critical user decisions and current checkpoint |
| `CHAT_TRANSFER_PROMPTS.md` | Copy-ready prompts for context persistence and new-chat boot |
| `HANDOVER.md` | Short actionable next steps and unresolved gates |
| `APP_NOTES.md` | App UI, behavior, BLE/protocol, telemetry, localization and reconnection contracts |
| `FIRMWARE_NOTES.md` | Hardware, GPIO, NTC, cooling, Adaptive, timing and safety contracts |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Code-level firmware architecture and static invariants |
| `OTA_PROTECTION.md` | Frozen/protected OTA contract and approval checklist |
| `OTA_REGRESSION_MEMORY.md` | Online OTA TLS/time-gate incident, chosen trade-off and evidence boundary |
| `VOLTAGE_TRANSITION_MEMORY.md` | Peltier ramp-interruption incident and exact voltage-transition timing contract |
| `BUILD_NOTES.md` | Manual APK build trigger, toolchain, output and release boundaries |
| `CHANGELOG.md` | Chronological historical changes, including superseded approaches |
| `DESIGN_NOTES.md` | Approved grille geometry, purple X monogram, icons and design constraints |
| `test/*.dart` | Static/regression contracts; file presence never means tests ran |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Authoritative App build workflow |
| `firmware/JEXFYZ-V6.4.ino` | Current canonical editable Firmware source |

## Evidence and authority

1. Live GitHub source, tree, branch refs and current workflow definitions determine current implementation facts.
2. `CHAT_RULES.md` controls the user's authorization/working preferences.
3. `PROJECT_STATE.md` captures current state after reconciliation.
4. The relevant subject-specific reference/memory file owns detailed technical facts.
5. `HANDOVER.md` contains current next actions.
6. `CHANGELOG.md` is historical; old entries never establish current state.
7. `CHAT_TRANSFER.md` must be verified against current main before reliance.
8. Chat summaries are context clues, not repository evidence.

## Required evidence labels

- **CURRENT / VERIFIED**: directly rechecked against current GitHub state/evidence.
- **IMPLEMENTED IN SOURCE / NOT RUN**: code or a test contract exists, execution has not been proven.
- **USER-REPORTED**: user reported it; assistant has not independently verified it.
- **UNVERIFIED**: evidence is missing.
- **HYPOTHESIS**: possible explanation, not an established cause.
- **HISTORICAL / SUPERSEDED**: valid only in the named older version.
- **NOT RELEASED**: not authorized/proven as production release.

## Persistence protocol

- Every approved durable decision must be saved in the single canonical subject file, with a concise changelog entry when it changes project behavior or a hard rule.
- At context limit, read the prior `CHAT_TRANSFER.md` completely, inspect current files, reconcile hashes and claims, then replace the whole snapshot. Never append a second “current” snapshot.
- Update all references and paths after a rename. Read back the changed files and inspect the final tree.
- Current-state files must not accumulate stale V5.x/V6.1/V6.2 “current truth” blocks.
- Preserve decisions, rejected approaches and their rationale, bugs/symptoms, hypotheses, validation state and user constraints. Do not fill gaps by guessing.
