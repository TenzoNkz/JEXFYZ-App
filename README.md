## CURRENT V6.1 EXECUTION — 2026-10-12

- [CURRENT TRUTH] Active firmware source: `firmware/JEXFYZ-V6.1.ino`; `FW_VERSION` is `V6.1`; target ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [IMPLEMENTED] V6.1 carries forward the Adaptive rail-handoff fix: Peltier PWM is disabled before the 200 ms selector break-before-make transition, and prior Peltier operation is restored after safe 5 V completion through the existing safety gates and 5-second OFF→ON soft-start.
- [IMPLEMENTED] Adaptive ON feedback remains three orange blinks after successful activation; Adaptive OFF feedback is deferred until the safe-5V handoff completes when the mode actually changed from ON to OFF, or starts immediately if already at 5 V.
- [DIAGNOSTIC] Firmware writes `BOOT: RESET_REASON=<reason>` to Serial during startup.
- [COMMITTED] V6.1 source added on `main` in commit `5fa7a4033a1cf2c5989c5fb9511be75cf34b7dbe`; the obsolete V6.0 source path was removed in commit `167f44df6c379d6d2a7a03b47f6620c609a4136c`. No PR was used.
- [NO BUILD] This V6.1 source/version promotion did not run a compile/build, generate a V6.1 BIN, flash hardware, or update production OTA metadata.
- [UNVERIFIED] Physical confirmation that the reported Adaptive restart is eliminated, that both LED indicators render on hardware, and that thermal/OTA regression remains pending.
- [NOT RELEASED] Production firmware repository `TenzoNkz/JEXFYZ-Firmware` and Firebase `firmware_update.json` were not changed. V6.1 remains source-only until separately built, validated, and explicitly released.

> The V6.0 section below is historical QC/build evidence only; it does not imply that V6.1 has been built, flashed, or released.

## HISTORICAL V6.0 EXECUTION — 2026-10-12

- [HISTORICAL] Active firmware source during the V6.0 QC snapshot: `firmware/JEXFYZ-V6.0.ino`; `FW_VERSION` was V6.0; target ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [FIX IMPLEMENTED] Adaptive ON now de-energizes Peltier PWM before a 200 ms selector break-before-make handoff to 5V. Once 5V completes, existing safety gates apply and the previously active Peltier is restored through `applyCoolingOutputs()`, invoking the existing 5-second OFF→ON soft-start.
- [FIX IMPLEMENTED] Adaptive OFF similarly de-energizes Peltier before forcing 5V; if Peltier was active, it is restored only after the 5V handoff completes and safety still permits it.
- [FIX IMPLEMENTED] Adaptive OFF white 3-blink feedback is deferred until the safe-5V handoff completes when the mode actually changed from ON to OFF; when already at 5V, feedback starts immediately. Successful Adaptive ON retains orange 3-blink feedback after activation and validation.
- [DIAGNOSTIC] Firmware boot prints `BOOT: RESET_REASON=<reason>` to Serial so reset cause can be captured even if BLE telemetry is interrupted.
- [COMMITTED] Adaptive handoff code: `2b119ac51f7989a00f82cfb4c190c0310881fdd1`.
- [COMMITTED] Firmware contract comment alignment: `45390c258d1769e3834b3c1dac68fd8eeced3b4d`.
- [COMMITTED] Firmware compile workflow: `e3e1922b05187e5df0fdbdc78402f62899dcf2e6`; QC prerelease delivery replaces artifact upload because Actions artifact storage quota was exhausted: `2e0aa75f9edb9a0646d90466d4183f20058f0306`.
- [VERIFIED BUILD] GitHub Actions run #83 passed with Arduino-ESP32 Core 3.3.7, target `esp32:esp32:esp32c3:PartitionScheme=min_spiffs`; job/run: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38267907193.
- [VERIFIED IMAGE] Compile reported 1,465,067 bytes program storage (74% of 1,966,080 bytes) and 46,740 bytes global RAM (14% of 327,680 bytes). Generated QC BIN is 1,465,216 bytes; ESP image magic `E9` and configured OTA size checks passed.
- [VERIFIED QC ASSET] Byte-for-byte release re-download verification passed. SHA-256: `b50af3bf9b43f1f78425e4dbd273534f218acd8c58a539eb2426bf3d9d5b10a8`. QC-only prerelease: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/firmware-qc-latest.
- [HISTORICAL] During the V6.0 QC snapshot, the GPIO mapping, NTC single-sample 1 Hz path, safety gates, selector deadtime, voltage guard, Adaptive 5-second upward dwell, OTA runtime logic, BLE/P1, App source, and production OTA metadata were not intentionally changed. The V6.0 production BIN in `TenzoNkz/JEXFYZ-Firmware` and Firebase `firmware_update.json` remained unchanged.
- [AUDIT PASS] Post-change lexical delimiter check passed; Adaptive start/stop order, delayed OFF indicator, OTA pending-flag cleanup, and boot reset diagnostic were checked in source.
- [UNVERIFIED] Physical ESP32-C3 flash/update; whether the original restart is eliminated on hardware; physical orange/white LED feedback; Peltier/Fan and thermal regression; Local/Online production OTA regression.
- [NOT RELEASED] Project remains DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED. The `firmware-qc-latest` prerelease is for manual/local QC only; it is not the production OTA release. App Build was not run.

> Older V5.9 sections remain historical; the V6.1 source-only state is recorded above.

# PROMPT 1 — CHAT-LIMIT RECAP / SAVE TO REPOSITORY

~~~
@Thinking CHAT-LIMIT RECAP — SAVE TO REPOSITORY

CHAT INI SUDAH MENDAPATI PERINGATAN CONTEXT/CHAT LIMIT.
INI ADALAH PROSEDUR PERSISTENCE SEBELUM CHAT DITINGGALKAN.

TUJUAN:
REKONSTRUKSI STATE CHAT → REKONSILIASI DENGAN REPOSITORY → REPLACE
CHAT_TRANSFER.md DENGAN TRANSFER PROTOCOL YANG TERKINI → VERIFIKASI SAVE.

ATURAN KERAS:
- JANGAN melakukan functional source change, release, atau Build App hanya karena transfer.
- JANGAN mengulang pertanyaan yang jawabannya sudah ada di repository/state docs.
- JANGAN mengarang evidence.
- JANGAN mengangkat hypothesis menjadi verified fact.
- Current repository source/workflow selalu mengalahkan historical notes.

WAJIB:
1. Baca seluruh context chat yang masih tersedia.
2. Rekonstruksi hanya state yang benar-benar relevan dan masih berlaku.
3. Reconcile dengan current main branch.
4. Baca CHAT_TRANSFER.md yang sekarang sebelum menggantinya.
5. Identifikasi:
   - project/repository/branch/current phase;
   - active Firmware/App/source/workflow;
   - user requirements;
   - frozen/accepted/rejected/obsolete decisions;
   - hardware safety/timing;
   - App/BLE/P1/OTA/Firebase/CI contracts;
   - exact versions, paths, blob SHA, commit SHA;
   - compile/build/test/flash/OTA evidence;
   - bugs, symptoms, root causes, hypotheses;
   - Gemini evidence;
   - risks, blockers, unresolved questions;
   - exact next action.

LABEL:
[USER REQUIREMENT] [CONFIRMED] [VERIFIED] [IMPLEMENTED] [COMMITTED]
[BUILT] [TESTED] [UNVERIFIED] [HYPOTHESIS] [OBSOLETE] [REJECTED]
[BLOCKED] [OPEN QUESTION]

TRANSFER FILE RULE:
CHAT_TRANSFER.md adalah BOOT/TRANSFER PROTOCOL, bukan source of truth.

STRUKTUR WAJIB:
0. READ FIRST / MANDATORY BOOT
1. PROJECT IDENTITY
2. AUTHORITY HIERARCHY
3. USER COMMAND PROTOCOL
4. CURRENT PROJECT MODE
5. HARDWARE CONTRACT
6. FIRMWARE CONTRACT
7. TOUCH CONTRACT
8. APP CONTRACT
9. BLE/P1 CONTRACT
10. OTA PROTECTED CONTRACT
11. FIREBASE / OTA METADATA
12. ANDROID / APP BUILD CONTRACT
13. SOURCE / COMMIT MAP
14. QC STATUS
15. RISKS
16. OBSOLETE / DO NOT REUSE
17. GEMINI EVIDENCE
18. FAILED APPROACHES
19. EXACT QC SEQUENCE
20. NEW CHAT FIRST RESPONSE
21. TRANSFER / MEMORY RULES
22. CHAT-ONLY STATE
23. TRANSFER COMPLETION

PISAHKAN:
- CURRENT TRUTH
- VERIFIED
- UNVERIFIED
- HISTORY / OBSOLETE
- CHAT-ONLY

REPOSITORY:
- Repo: TenzoNkz/JEXFYZ-App
- Branch: main
- File: CHAT_TRANSFER.md

SAVE:
1. Read current CHAT_TRANSFER.md.
2. Reconstruct current state.
3. Replace CHAT_TRANSFER.md — do not append duplicate snapshots.
4. Update PROJECT_STATE.md/HANDOVER.md only for meaningful persistent state.
5. Do not modify functional App/Firmware source for transfer work.
6. Commit documentation changes.
7. Re-read CHAT_TRANSFER.md.
8. Verify new HEAD + active source + workflow + saved content.
9. Record exact persistence evidence.

ANTI-REPETITION:
Before asking the user for clarification, check this file, PROJECT_STATE.md,
HANDOVER.md, authoritative notes, and current source/configuration.

JIKA SAVE GAGAL:
- jangan klaim persistence;
- tandai [BLOCKED];
- berikan emergency transfer summary saja.

SELESAIKAN PROSEDUR TRANSFER.
~~~

# PROMPT 2 — NEW CHAT BOOT / QC PRE-RELEASE

~~~
@Thinking NEW CHAT BOOT — JE X FYZ / QC PRE-RELEASE

INI ADALAH CHAT BARU.
JANGAN memulai ulang project.
JANGAN meminta user mengulang context yang sudah tersedia.
JANGAN langsung implement/build berdasarkan asumsi.

MANDATORY BOOT:
1. Read CHAT_TRANSFER.md terlebih dahulu.
2. Read PROJECT_STATE.md.
3. Read HANDOVER.md.
4. Read CHAT_RULES.md.
5. Read relevant current notes:
   - APP_NOTES.md
   - FIRMWARE_NOTES.md
   - firmware/FIRMWARE_ANALYSIS.md
   - OTA_PROTECTION.md
   - CHANGELOG.md bila perlu untuk history.
6. Inspect current active Firmware source, App source, and App Build workflow.
7. Verify current main HEAD.
8. Verify active Firmware filename/version/blob alignment.
9. Reconcile any contradictions.
10. Do NOT modify functional source during boot/reconciliation.

AUTHORITY:
CURRENT SOURCE / CURRENT WORKFLOW
>
PROJECT_STATE.md
>
AUTHORITATIVE CURRENT NOTES
>
CHAT_RULES.md / HANDOVER.md / CHANGELOG.md
>
CHAT_TRANSFER.md
>
CURRENT CHAT
>
OLD CHAT

CHAT_TRANSFER.md = transfer protocol/evidence.
It is NOT a replacement for verifying current repository truth.

ANTI-REPETITION:
DO NOT ask the user to repeat:
- current firmware version;
- active source path;
- GPIO map;
- Adaptive rules;
- NTC rules;
- BLE UUIDs;
- OTA protection rules;
- App Build trigger rules;
when those facts already exist in the transfer/repository.

Only ask when a genuinely new decision or a real contradiction must be resolved.

CURRENT PROJECT:
- Firmware: V5.8
- Active source: firmware/JEXFYZ-V5.8.ino
- Status: DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED
- V5.7 compile + hardware update: user-confirmed success
- V5.8 compile/flash/physical regression: pending
- App: 1.0.0+3
- Phase: DEVELOPMENT + QC / PRE-RELEASE
- Release: NOT RELEASED
- Hardware: ESP32-C3 Super Mini
- Single-radio Wi-Fi/BLE rule is FROZEN.

QC SOURCE FREEZE:
Functional source is FROZEN during QC.
Only change functional source when a real QC defect is:
- demonstrable/reproducible;
- root cause is clear;
- relevant to the release gate;
- fixed narrowly;
- fully re-audited.

DO NOT:
- refactor unrelated code;
- add features during QC;
- redesign BLE without a demonstrated defect;
- alter OTA for cleanup;
- redesign App Build;
- reintroduce obsolete protections;
- claim validation that did not actually run.

FROZEN HARDWARE/SAFETY:
- GPIO: NTC 0, Touch 1, 12V 3, 9V 4, Peltier 5, Fan 6, WS2812 7.
- Touch: 1x Voltage, 2x RGB, 5s long press.
- Voltage sequence: 5V → 9V → 12V → 9V → 5V → ...
- Fan PWM: 25 kHz, 8-bit, 50–100%.
- Peltier PWM: 20 kHz; OFF→ON 5s cooperative soft-start.
- Selector deadtime: 200 ms.
- Voltage guard: 1 s.
- Hotside NTC: 1 s cadence, exactly one calibrated ADC reading, 10K/10K/Beta3950.
- Hotside limit: 40–50°C, default 45°C.
- NTC fault: Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- No RAPID_HOTSIDE_RISE.
- Adaptive upward dwell: 5 s after every completed upward step in BOTH HOTSIDE and HOTSIDE_BATTERY.
- Adaptive downward changes: immediate.
- Adaptive Hotside safety dwell: 20 s per rail; Fan 100%; LED 19 s red + final 1 s blue.
- Adaptive Hotside re-arm: if Hotside reaches <= hotLimit - 2°C before the 20 s boundary, Peltier resumes on the same rail and LED blinks green 2x.
- Adaptive step-down: 12V -> 9V -> 5V, with a fresh 20 s thermal stage on every reached rail; 5V remains terminal if the 20 s stage still does not reach re-arm.
- Adaptive 5V terminal lock: after the 20 s stage, Peltier remains locked and LED blinks red continuously until Hotside reaches <= hotLimit - 2°C; then green 2x and manual Peltier restart is required.
- Manual Hotside protection: selected voltage is preserved, Fan 100%, Peltier OFF, and red blink continues until <= hotLimit - 2°C; then green 2x. Peltier restart remains manual.
- Peltier safety green feedback is thermal-state based only; a normal successful Peltier ON command does not emit a green indicator.
- Peltier safety re-arm: Hotside <= hotLimit - 2°C.
- Normal Peltier ON/OFF has no green/red LED.
- Blocked safety re-arm ON = red 1s; successful re-arm ON = green 1s then latch clear.
- No executable delay(); no timing while() loops.

OTA:
READ OTA_PROTECTION.md.
OTA is protected/frozen.
- Local OTA protected.
- Online OTA protected.
- BLE/GATT must be torn down before Wi-Fi ownership.
- Single-radio rule is mandatory.
- Anti-downgrade is OFF.
- Any valid firmware version DIFFERENT from device version may update.
- Do not alter OTA for unrelated work.

BLE:
- Service: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001
- RX: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001
- TX: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001
- App uses flutter_blue_plus.
- One intended GATT session.

APP BUILD:
Manual issue-trigger only.
Title: JE X FYZ — BUILD APP TRIGGER
Token: JEXFYZ_BUILD_TRIGGER_V1
Workflow: .github/workflows/jexfyz-app-build-trigger.yml
Toolchain: Java 17 / Flutter 3.47.2 stable / Gradle 9.3.1 / ubuntu-24.04
Output: one obfuscated, production-signed JEXFYZ-release.apk via GitHub Release.
Normal push/PR MUST NOT create release APK.
Do not Build App unless explicit command is given.

VALIDATION LANGUAGE:
- Static audit != compile.
- Compile != flash.
- Flash != physical behavior.
- App Build != Firmware validation.
- Successful OTA transfer != complete OTA regression.
- Never call a pending gate PASS.

FIRST RESPONSE:
CURRENT PROJECT TRUTH
REPOSITORY RECONCILIATION
VERIFIED
UNVERIFIED
KNOWN RISKS
NEXT EXACT QC GATE
WORKFLOW STATUS

THEN WAIT FOR USER COMMAND.
~~~