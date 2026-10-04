## 2026-10-04 — CHAT-LIMIT HANDOVER REFRESH

- Prepared for immediate transfer to a new chat because the current conversation is near its context limit.
- The detailed copy-ready continuation prompt remains stored below and in README.md.
- New chat must start with README.md and perform the complete memory preflight before any analysis or action.
- Current firmware: V3.7; current source: `firmware/JEXFYZ-V3.7.ino`.
- Latest verified App Build: #50.
- No new App Build or firmware compile was performed for this handover.

# JE X FYZ — HANDOVER

> Portable continuation prompt. Copy the prompt below into a new JE X FYZ chat, especially when the previous chat is near its context limit or when starting a separate Build App subchat.

## CURRENT SNAPSHOT

- Project: JE X FYZ / JE Cooler.
- App repository: https://github.com/TenzoNkz/JEXFYZ-App
- Firmware distribution repository: https://github.com/TenzoNkz/JEXFYZ-Firmware
- Current firmware source: `firmware/JEXFYZ-V3.7.ino`
- Current firmware source blob: `4a7e08a6ea0de57f4e3d3a742ad88cbd25a05e01`
- Last verified App Build: #50, run 36996987220.
- Newer repository documentation/firmware commits have not been included in a newer App Build.
- V3.7 ArduinoDroid compilation, BIN publication, Firebase promotion, and physical validation are still unperformed.

## REPOSITORY-FIRST CHAT-LIMIT HANDOVER

Official continuity flow:

```
OLD CHAT
  ↓
PROMPT 1 — READ CHAT + RECONCILE + SAVE
  ↓
CHAT_TRANSFER.md
  ↓
NEW CHAT
  ↓
PROMPT 2 — READ REPOSITORY + RECONCILE
  ↓
CURRENT PROJECT TRUTH
  ↓
CONTINUE
```

## PROMPT 1 — CHAT-LIMIT RECAP / SAVE TO REPOSITORY

Use this in the old/current chat after the platform warns about the context
limit.

```
@Thinking CHAT-LIMIT RECAP — SAVE TO REPOSITORY

CHAT INI SUDAH MENDAPATI PERINGATAN CONTEXT/CHAT LIMIT.
INI ADALAH PROSEDUR PENYIMPANAN CONTEXT SEBELUM CHAT DITINGGALKAN.

JANGAN melakukan functional source change, release, atau Build App hanya karena prompt ini.

TUJUAN:
BACA SELURUH CONTEXT CHAT → REKONSTRUKSI SELURUH STATE → REKONSILIASI DENGAN
REPOSITORY → SIMPAN LANGSUNG KE CHAT_TRANSFER.md → VERIFIKASI SAVE.

1. Baca seluruh pesan chat yang masih tersedia dari awal sampai sekarang.
2. Gunakan semua source/tool/repository/build/test/hardware/Gemini evidence yang benar-benar tersedia.
3. Jangan hanya membaca pesan terakhir.
4. Jangan mengarang evidence atau menaikkan hypothesis menjadi fact.

WAJIB rekonstruksi:
- project, repo, branch, current task, workflow, objective, next action;
- semua user requirements dan exact wording yang mempengaruhi behavior;
- accepted/frozen decisions;
- rejected/obsolete/superseded decisions;
- App/UI, Firmware, BLE/P1/UUID, Android, OTA, Firebase, CI/build,
  security, timing, persistence, safety, hardware;
- exact source files, paths, before/after, functional vs documentation-only,
  version, commit SHA, blob SHA, committed/uncommitted, verified/unverified;
- semua build/compile/test attempts beserta source SHA, run ID, artifact ID,
  size, SHA256, symbols, signing, gates, error, troubleshooting;
- bugs/symptoms/reproduction/evidence/status;
- verified root causes vs likely causes vs hypotheses;
- actual Gemini questions/results only;
- failed approaches/dead ends;
- current risks;
- unresolved questions;
- exact next action.

Gunakan label bila relevan:
[USER REQUIREMENT] [CONFIRMED] [VERIFIED] [IMPLEMENTED] [COMMITTED]
[BUILT] [TESTED] [UNVERIFIED] [HYPOTHESIS] [OBSOLETE] [REJECTED]
[BLOCKED] [OPEN QUESTION]

Pisahkan:
PERSISTENT = sudah benar-benar ada di repository.
CHAT-ONLY = penting tetapi belum terbukti persisted.

REPOSITORY SAVE:
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Official transfer file: CHAT_TRANSFER.md

Lakukan:
1. Read current CHAT_TRANSFER.md jika sudah ada.
2. Build snapshot baru yang merepresentasikan SELURUH chat ini.
3. Replace CHAT_TRANSFER.md dengan snapshot terbaru.
4. Jangan menghapus history Git sebelumnya.
5. Update PROJECT_STATE.md dan notes terkait bila chat ini menghasilkan requirement/decision/state baru.
6. Jangan mengubah functional App/Firmware source.
7. Commit seluruh memory/documentation changes.
8. Re-read CHAT_TRANSFER.md setelah commit.
9. Verifikasi commit SHA, current HEAD, dan isi transfer.
10. Catat exact persistence evidence.

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
16. VALIDATION EVIDENCE
17. GEMINI RESULTS
18. FAILED APPROACHES / DEAD ENDS
19. KNOWN RISKS
20. UNRESOLVED QUESTIONS
21. CHAT-ONLY INFORMATION
22. EXACT NEXT ACTION
23. REQUIRED FIRST ACTION IN NEW CHAT
24. AUTHORITY / RECONCILIATION NOTES
25. TRANSFER COMPLETION

TRANSFER COMPLETION wajib memuat:
- recap completed;
- repository write success/failure;
- exact commit SHA;
- current HEAD observed;
- current source/workflow observed;
- next action.

Jika repository write gagal:
- jangan mengklaim persistence;
- tandai [BLOCKED];
- berikan fallback recap hanya sebagai emergency output.

PROMPT 1 = CHAT → REPOSITORY.
Repository adalah transfer medium.
SEKARANG LAKUKAN PROSEDUR TERSEBUT.
```

## PROMPT 2 — NEW CHAT TRANSFER / READ REPOSITORY

Use this in the new chat. Prompt 2 reads CHAT_TRANSFER.md directly from the
repository; manual copy-paste of the old chat is not required.

```
@Thinking NEW CHAT TRANSFER — READ FROM REPOSITORY AND CONTINUE

Ini adalah chat baru JE X FYZ.

JANGAN mengandalkan chat lama atau menganggap context sebelumnya masih tersedia.
JANGAN langsung implement/build berdasarkan asumsi.

TUJUAN:
REPOSITORY → REBUILD CONTEXT → VERIFY CURRENT SOURCE/WORKFLOW →
ESTABLISH CURRENT PROJECT TRUTH → CONTINUE EXACT NEXT ACTION.

MANDATORY PREFLIGHT — WAJIB sebelum action apa pun:
1. README.md
2. PROJECT_STATE.md
3. CHAT_RULES.md
4. APP_NOTES.md
5. FIRMWARE_NOTES.md
6. BUILD_NOTES.md
7. CHANGELOG.md
8. HANDOVER.md
9. CHAT_TRANSFER.md
10. firmware/FIRMWARE_ANALYSIS.md bila firmware relevan
11. inspect exact current source/workflow yang mengendalikan task.

Untuk Build App, semua langkah di atas tetap wajib.

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

Baca CHAT_TRANSFER.md SEPENUHNYA:
- task/workflow;
- requirements;
- decisions;
- obsolete/rejected items;
- App/Firmware state;
- Android/BLE/OTA/Firebase/CI;
- source changes;
- commits;
- build/test evidence;
- bugs/root causes/hypotheses;
- Gemini;
- dead ends;
- risks;
- unresolved questions;
- exact next action.

RECONCILE:
Bandingkan transfer dengan PROJECT_STATE, CHAT_RULES, APP_NOTES,
FIRMWARE_NOTES, BUILD_NOTES, CHANGELOG, HANDOVER, current source,
current workflow, branch dan HEAD.

Untuk setiap mismatch:
1. catat claim dari CHAT_TRANSFER;
2. catat current repository evidence;
3. pilih current verified truth;
4. tandai data lama sebagai obsolete/historical bila perlu.

Jangan menghapus historical evidence hanya karena obsolete.
Jangan menghidupkan kembali behavior yang sudah superseded.

VERIFY CURRENT:
- repo;
- branch;
- HEAD;
- App version/build;
- Firmware version/source bila relevan;
- latest verified App Build;
- exact build source SHA;
- changes after latest verified build;
- relevant workflow/trigger;
- validation boundaries.

PERSISTENCE CHECK:
CHAT_TRANSFER.md harus ada dan transfer commit harus bisa diverifikasi.
Jika transfer tidak ada/gagal, jangan mengarang missing context.

CURRENT PROJECT TRUTH wajib menetapkan:
- project;
- repository;
- branch;
- HEAD;
- App version/build;
- Firmware version/source;
- latest verified build;
- current task;
- current workflow;
- changed;
- verified;
- unverified;
- risks;
- open questions;
- exact next action.

CONTINUE, JANGAN RESTART:
- jangan mengulang pekerjaan yang sudah committed/verified;
- jangan meminta user mengulang informasi yang sudah persisted;
- lanjutkan dari exact next action selama diizinkan current CHAT_RULES/workflow.

COMMAND SEMANTICS:
- @Thinking Diskusi! = discussion/review only.
- @Thinking Eksekusi! = implement approved scope + sync + commit.
- @Thinking Eksekusi Full! = implement + full affected audit + sync + commit.
- @Thinking Build App! = full App build workflow; fresh engineering environment.
- @Thinking Eksekusi & Build App! = implement → audit → sync → commit → build.

Jika transfer menyatakan siap build, itu BUKAN build authorization.
Build hanya boleh dilakukan jika command/build policy mengizinkan.

MEMORY SYNC:
Setelah reconciliation atau meaningful continuation, sinkronkan memory secara otomatis.
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

PROMPT 2 = REPOSITORY → NEW CHAT.
SEKARANG MULAI DARI MANDATORY PREFLIGHT.
```


## Transfer boundary

- CHAT_TRANSFER.md is the official rolling transfer snapshot.
- Prompt 1 writes the latest complete snapshot directly to the repository.
- Prompt 2 reads that snapshot directly from the repository.
- Previous transfer snapshots remain recoverable through Git history.
- Current source/current workflow always outrank transfer text.
- Build App subchats must use Prompt 2 and still perform the complete build preflight.

