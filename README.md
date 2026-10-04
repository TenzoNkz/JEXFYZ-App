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

# PROMPT 2 — NEW CHAT TRANSFER / READ REPOSITORY

~~~
@Thinking NEW CHAT TRANSFER — READ FROM REPOSITORY AND CONTINUE

Ini adalah chat baru JE X FYZ.

JANGAN mengandalkan chat lama atau menganggap context sebelumnya masih tersedia.
JANGAN langsung implement/build berdasarkan asumsi.

TUJUAN:
REPOSITORY → REBUILD CONTEXT → VERIFY CURRENT SOURCE/WORKFLOW →
ESTABLISH CURRENT PROJECT TRUTH → CONTINUE EXACT NEXT ACTION.

MANDATORY PREFLIGHT:
1. README.md
2. PROJECT_STATE.md
3. CHAT_RULES.md
4. APP_NOTES.md
5. FIRMWARE_NOTES.md
6. BUILD_NOTES.md
7. CHANGELOG.md
8. firmware/FIRMWARE_ANALYSIS.md bila Firmware relevan
9. HANDOVER.md
10. CHAT_TRANSFER.md
11. Inspect exact current source/workflow yang mengendalikan task.

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

Baca CHAT_TRANSFER.md SEPENUHNYA, lalu reconcile dengan:
PROJECT_STATE, CHAT_RULES, APP_NOTES, FIRMWARE_NOTES, BUILD_NOTES,
CHANGELOG, HANDOVER, current source, current workflow, branch, dan HEAD.

Untuk mismatch:
1. catat claim transfer;
2. catat repository evidence;
3. pilih current verified truth;
4. tandai data lama obsolete/historical bila perlu.

VERIFY CURRENT:
- repo, branch, HEAD;
- App version/build;
- Firmware version/source bila relevan;
- latest verified App Build;
- exact build source SHA;
- relevant workflow/trigger;
- changes after latest verified build;
- validation boundaries.

CURRENT PROJECT TRUTH wajib menetapkan:
- project;
- repository;
- branch;
- HEAD;
- App version/build;
- Firmware version/source;
- latest verified build;
- current task;
- workflow;
- changed;
- verified;
- unverified;
- risks;
- open questions;
- exact next action.

CONTINUE, JANGAN RESTART:
- jangan mengulang pekerjaan yang sudah committed/verified;
- jangan meminta user mengulang informasi yang sudah persisted;
- lanjutkan exact next action sesuai current rules/workflow.

COMMAND SEMANTICS:
- @Thinking Diskusi! = discussion/review only.
- @Thinking Tanya Gemini! = diagnosis/patch-request; Gemini returns exact OLD → NEW patches only.
- @Thinking Eksekusi! = implement approved scope + sync + commit.
- @Thinking Eksekusi Full! = implement + full affected audit + sync + commit.
- @Thinking Build App! = full App build workflow; fresh engineering environment.
- @Thinking Eksekusi & Build App! = implement → audit → sync → commit → explicit App Build.

Build hanya boleh dilakukan jika command/build policy mengizinkan.

MEMORY SYNC:
Setelah reconciliation atau meaningful continuation, sinkronkan memory.
Dokumentasi sync tidak boleh menyelundupkan functional source change.

FIRST RESPONSE:
CURRENT PROJECT TRUTH
RECAP VS REPOSITORY
VERIFIED
UNVERIFIED
KNOWN RISKS
OPEN QUESTIONS
NEXT EXACT ACTION
MEMORY SYNC REQUIRED
WORKFLOW STATUS

Lalu lanjutkan task yang memang diotorisasi.

SEKARANG MULAI DARI MANDATORY PREFLIGHT.
~~~
