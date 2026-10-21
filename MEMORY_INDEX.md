# JE X FYZ / JE Cooler — Memory Index

Last reconciled: 2026-10-21 (Asia/Jakarta). This is a navigation index plus concise production checkpoint; detailed topic contracts live in the canonical files below. Always check live source and evidence before making current-state claims.

## Production checkpoint

- Owner-confirmed state: the sold/shipped unit uses Android App Build #124; Firmware V7.1 was compiled and updated through Online OTA. This is USER-REPORTED product/deployment status.
- Independently verified App artifact: Build #124 / Actions run `39386733061`, packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`, APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`, source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`. Build passed 116 Flutter tests and configured release gates; native Android tests were NO-SOURCE.
- Active editable Firmware source: `firmware/JEXFYZ-V7.1.ino`, `FW_VERSION="V7.1"`. At a 40°C limit, Adaptive target bands are 40/39/38→100%, 37/36→90%, 35/34→80%, 33/32→70%, 31/30→60%, ≤29→50%; thresholds shift with configured limit. Raw-decimal thermal safety remains immediate, Fan 100% / Peltier OFF at or above the limit. PWM ramps +10 percentage points/1 s and −10 points/10 s.
- Do not conflate the owner's compile/OTA report with independent source-to-BIN, installed-version, reboot, BLE recovery or physical thermal/electrical validation. The field unit is not available for routine physical repair; make remote updates conservative.

## New-chat and chat-limit recovery

1. Read `CHAT_TRANSFER.md` fully, then fetch live `main` HEAD + recursive tree.
2. Read this index, `CHAT_RULES.md`, `PROJECT_STATE.md`, `HANDOVER.md`, and the full canonical reference relevant to the task. Inspect live code/config/tests/workflow as needed.
3. General / Discussion chat-limit: use Prompt B (LOAD + CONTINUE) from `CHAT_TRANSFER_PROMPTS.md`; no separate recap-only chat.
4. Build App chat-limit: use Prompt D once; load live workflow and `APP_BUILD_REPORT.md`, then continue the same authorized work.
5. Prompt A is for explicitly requested full repository-memory reconciliation only, not default handoff.
6. After substantive Discussion conclusions and after execution success/blockage, update the checkpoint and canonical subject note. A hard interruption may occur before a write; resume from the last persisted checkpoint and verify live evidence.

## Permanent command and authorization protocol

- `@Thinking Diskusi!`: read-only for executable source/config/workflow and all build/release, firmware/BIN/Firebase, OTA/flash/device actions. Documentation-only checkpoint/canonical-note writes are permitted after substantive decisions or when the discussion concludes.
- `@Thinking Eksekusi Full!`: executes the approved scoped source/docs/tests/static-audit change and commits directly to `main`; it never implies App Build, firmware compile, BIN/Firebase changes, OTA, flashing or hardware operation.
- `@Thinking Eksekusi Build App!`: sole end-to-end App Build/QC authorization and required `APP_BUILD_REPORT.md` ledger update.
- `@Thinking Chat Stuck!`: resumes the last valid authorized operation from actual logs/current state without blind retry or broader authorization.
- Gemini subcommands require `Diskusi!` in the same command. Retired aliases remain invalid.
- Preserve Gradle `versionName "Telegram @horizontalzzz"`; App repository owns source + all memory, while `TenzoNkz/JEXFYZ-Firmware` is BIN-only (`JEXFYZ.cpp.bin`).

## Canonical file map

| File | Canonical purpose |
|---|---|
| `README.md` | Project overview, navigation, baseline and validation boundaries |
| `CHAT_RULES.md` | Commands, authorization, repository/OTA restrictions, persistence rules |
| `CHAT_TRANSFER.md` | Rolling LOAD + CONTINUE checkpoint; not transcript prose |
| `CHAT_TRANSFER_PROMPTS.md` | Prompt A full reconciliation, B general LOAD + CONTINUE, C persistence, D Build App LOAD + CONTINUE |
| `MEMORY_INDEX.md` | This routing index and compact production checkpoint |
| `PROJECT_STATE.md` | Current-only product/source/validation status |
| `HANDOVER.md` | Current checkpoint and exact next action |
| `APP_NOTES.md` | App UI, controls, BLE, telemetry, localization and notification contracts |
| `FIRMWARE_NOTES.md` | Hardware, safety, Adaptive, Touch, LEDs, settings and telemetry |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Source architecture and low-level firmware invariants |
| `OTA_PROTECTION.md` | Protected Local/Online OTA behavior and regression gates |
| `OTA_REGRESSION_MEMORY.md` | OTA failure history, CA/NTP experiment and TLS trade-off |
| `VOLTAGE_TRANSITION_MEMORY.md` | Rail/Peltier timing, cancellation and recovery behavior |
| `BUILD_NOTES.md` | Official App build procedure and validation boundaries |
| `APP_BUILD_REPORT.md` | Authoritative App Build attempt/fix/test/signing/release ledger |
| `DESIGN_NOTES.md` | Approved grille, logo, assets, animation and layout contracts |
| `BLE_APP_AUTH.md` | App identity/enrollment gap, requirements and blocker |
| `CHANGELOG.md` | Dated history; historical entries never override live state |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Authoritative guarded App Build trigger |
| `test/*.dart` | Flutter/source-contract tests; file presence is not proof of execution |
| `archive/*.md` | Immutable forensic snapshots; never current truth |

## Evidence labels

- **CURRENT / VERIFIED:** checked live source/tree/ref/Actions/Release or executed gate.
- **USER-REPORTED:** user-confirmed outcome not independently verified here.
- **SOURCE IMPLEMENTED / NOT RUN:** code or test exists but that validation did not run.
- **UNVERIFIED:** supporting evidence is missing.
- **HYPOTHESIS:** possible explanation, not an established cause.
- **HISTORICAL / SUPERSEDED:** valid for an earlier source/version/run only.
- **NOT RELEASED:** current source/artifact is not proven to be the released package.

## Non-negotiable safety and design boundaries

- Preserve protected OTA behavior and the current `cloudClient.setInsecure()` trade-off. No casual OTA refactor; read `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md` before any authorized OTA change.
- Firmware source changes require an `FW_VERSION` bump and matching filename; exactly one active versioned `.ino`. Keep cooperative `millis()` timing; no executable `delay()` or timing `while()`.
- No standalone Battery Protection Guard UI. Physical output state must not be inferred from command ACK alone. Keep BLE P1 IDs/protocol, radio ownership, Touch/Peltier/rail timing, thermal fail-safes and persisted schema compatibility.
- No firmware checksum/signature fields in Firebase OTA metadata without explicit user approval. Do not assume the BIN matches current source without provenance.
- Preserve approved white symmetric 1:1 grille, central purple X, four mounting holes, original interior pattern, and flat print-ready design. Keep existing App identity/assets and localization contracts.
