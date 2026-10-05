# PROMPT 1 — CHAT-LIMIT RECAP / SAVE TO REPOSITORY

~~~
@Thinking CHAT-LIMIT RECAP — SAVE TO REPOSITORY

CHAT INI SUDAH MENDAPATI PERINGATAN CONTEXT/CHAT LIMIT.
INI ADALAH PROSEDUR PENYIMPANAN CONTEXT SEBELUM CHAT DITINGGALKAN.

JANGAN melakukan functional source change, release, atau Build App hanya karena prompt ini.

TUJUAN:
BACA SELURUH CONTEXT CHAT → REKONSTRUKSI SELURUH STATE → REKONSILIASI DENGAN
REPOSITORY → SIMPAN LANGSUNG KE CHAT_TRANSFER.md → VERIFIKASI SAVE.

WAJIB:
1. Baca seluruh pesan chat yang masih tersedia dari awal sampai sekarang.
2. Gunakan source, repository, build, test, hardware, dan Gemini evidence yang benar-benar tersedia.
3. Jangan hanya membaca pesan terakhir.
4. Jangan mengarang evidence atau menaikkan hypothesis menjadi fact.

REKONSTRUKSI:
- project, repository, branch, current task, workflow, objective, next action;
- user requirements, frozen/accepted/rejected/obsolete decisions;
- App/UI, Firmware, BLE/P1/UUID, Android, OTA, Firebase, CI/build, security,
  timing, persistence, safety, hardware;
- exact source paths, versions, commit SHA, blob SHA, functional vs documentation-only;
- build/compile/test attempts, source SHA, run ID, artifact ID, checksum, gates, errors;
- bugs, symptoms, reproduction, evidence, verified root causes, hypotheses;
- Gemini questions/results, failed approaches, risks, unresolved questions.

Gunakan label:
[USER REQUIREMENT] [CONFIRMED] [VERIFIED] [IMPLEMENTED] [COMMITTED]
[BUILT] [TESTED] [UNVERIFIED] [HYPOTHESIS] [OBSOLETE] [REJECTED]
[BLOCKED] [OPEN QUESTION]

Pisahkan PERSISTENT dari CHAT-ONLY.

REPOSITORY SAVE:
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Transfer file: CHAT_TRANSFER.md

Lakukan:
1. Read current CHAT_TRANSFER.md.
2. Replace CHAT_TRANSFER.md with a new complete snapshot of this chat.
3. Update PROJECT_STATE.md and affected notes with any new persistent state.
4. Do not change functional App/Firmware source.
5. Commit the documentation changes.
6. Re-read CHAT_TRANSFER.md.
7. Verify commit SHA, current HEAD, current source/workflow, and saved content.
8. Record exact persistence evidence.

CHAT_TRANSFER.md minimal wajib berisi:
1. TRANSFER METADATA
2. CURRENT TASK
3. CURRENT WORKFLOW
4. USER REQUIREMENTS
5. FROZEN / ACCEPTED DECISIONS
6. REJECTED / OBSOLETE DECISIONS
7. APP STATE
8. FIRMWARE STATE
9. ANDROID / BLE / OTA / FIREBASE / CI
10. SOURCE CHANGES
11. COMMITS / SHAs
12. BUILD STATE
13. BUGS / SYMPTOMS
14. VERIFIED ROOT CAUSES
15. HYPOTHESES / LIKELY CAUSES
16. GEMINI RESULTS
17. FAILED APPROACHES / DEAD ENDS
18. KNOWN RISKS
19. UNRESOLVED QUESTIONS
20. CHAT-ONLY INFORMATION
21. EXACT NEXT ACTION
22. REQUIRED FIRST ACTION IN NEW CHAT
23. AUTHORITY / RECONCILIATION NOTES
24. TRANSFER COMPLETION

Jika repository write gagal:
- jangan mengklaim persistence;
- tandai [BLOCKED];
- beri fallback recap hanya sebagai emergency output.

SEKARANG LAKUKAN PROSEDUR TERSEBUT.
~~~

# PROMPT 2 — NEW CHAT TRANSFER / QC PRE-RELEASE

~~~
@Thinking NEW CHAT TRANSFER — QC / PRE-RELEASE

Ini adalah chat baru JE X FYZ.

PROJECT PHASE:
V4.6 — CODE COMPLETE → QC / PRE-RELEASE → NOT RELEASED

JANGAN memulai ulang development.
JANGAN langsung implement/build berdasarkan asumsi.
JANGAN menambah fitur.

TUJUAN:
REPOSITORY → REBUILD CONTEXT → VERIFY CURRENT SOURCE/WORKFLOW →
ESTABLISH QC TRUTH → CONTINUE DARI QC GATE TERAKHIR.

MANDATORY PREFLIGHT:
1. README.md
2. PROJECT_STATE.md
3. CHAT_RULES.md
4. APP_NOTES.md
5. FIRMWARE_NOTES.md
6. BUILD_NOTES.md
7. CHANGELOG.md
8. firmware/FIRMWARE_ANALYSIS.md
9. HANDOVER.md
10. CHAT_TRANSFER.md
11. Inspect exact current Firmware source + current App source + current workflow.
12. Verify branch HEAD and active version/file alignment.

SOURCE AUTHORITY:
CURRENT SOURCE / CURRENT WORKFLOW
>
PROJECT_STATE.md
>
AUTHORITATIVE NOTES
>
BUILD_NOTES.md / CHANGELOG.md / HANDOVER.md
>
CHAT_TRANSFER.md
>
CURRENT CHAT
>
OLD CHAT

CHAT_TRANSFER.md adalah transfer evidence, bukan source of truth.

QC RULE:
Selama QC, functional source dianggap FROZEN.
Functional source hanya boleh berubah jika QC menemukan kegagalan yang:
- dapat direproduksi atau dibuktikan dari source;
- memiliki root cause yang jelas;
- benar-benar relevan terhadap release gate.

Jangan melakukan refactor, feature addition, workflow redesign, atau perubahan
yang tidak diperlukan untuk memperbaiki temuan QC.

QC GATES:
1. Firmware compile V4.6
2. BIN generation
3. Flash ESP32-C3
4. Hardware-only QC
5. Safety QC
6. Local OTA Golden Path
7. Online OTA + BLE recovery
8. App ↔ Firmware integration QC
9. Release Gate

HARDWARE QC:
- Single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: soft-start 5 detik → 100%.
- Double-tap RGB.
- Long-press Adaptive OFF.
- Touch timing and voltage guard/deadtime.

SAFETY QC:
- Hotside limit 40–50°C (default 45°C).
- NTC fault.
- Fan/Peltier interlock.
- 200 ms selector deadtime.
- 1 s voltage guard.
- Confirm Rapid Hotside Rise protection is absent and does not generate
  RAPID_HOTSIDE_RISE.

OTA QC:
- Local OTA remains Golden/Protected and must not be altered for unrelated issues.
- Online OTA must preserve single-radio Wi-Fi/BLE ownership.
- Active BLE GATT disconnect before Wi-Fi ownership.
- Restart → BLE recovery → P1 sync.

BUILD POLICY:
App Build remains manual-by-issue only.
Issue title: JE X FYZ — BUILD APP TRIGGER
Token: JEXFYZ_BUILD_TRIGGER_V1
Current workflow: .github/workflows/jexfyz-app-build-trigger.yml
Normal push/PR MUST NOT produce a release APK.
Do not run App Build unless the explicit Build App command is given.

VALIDATION LANGUAGE:
- Static/source audit is not compile validation.
- Compile is not flash validation.
- Flash is not physical behavior validation.
- App Build is not Firmware validation.
- Never claim PASS for a gate that was not actually tested.

FIRST RESPONSE IN NEW CHAT:
CURRENT PROJECT TRUTH
QC STATUS
REPOSITORY RECONCILIATION
VERIFIED
UNVERIFIED
KNOWN RISKS
OPEN QUESTIONS
NEXT EXACT QC GATE
WORKFLOW STATUS

THEN continue from the exact next QC gate.
~~~
