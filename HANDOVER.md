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

## DUAL-PROMPT CHAT-LIMIT HANDOVER

This handover model separates context export from context restoration.

### PROMPT A — CHAT-LIMIT RECAP

Use in the **old chat** immediately after the limit warning:

```
@Thinking CHAT-LIMIT RECAP — JE X FYZ

CHAT INI SUDAH MENDAPATI PERINGATAN CONTEXT/CHAT LIMIT.
JANGAN melakukan implementasi, build, release, atau perubahan functional source.
Tugas kamu sekarang hanya membuat TRANSFER PACKAGE lengkap dari seluruh data
yang masih tersedia di chat ini agar bisa dipindahkan ke chat baru.

============================================================
A. TUJUAN
============================================================

Buat satu paket recap utuh yang merepresentasikan kondisi chat ini
dari awal sampai pesan terakhir.

JANGAN hanya merangkum pesan terakhir.
JANGAN hanya merangkum issue terakhir.
JANGAN menghapus detail teknis yang masih dibutuhkan untuk melanjutkan.
JANGAN mengarang detail yang tidak ada.
JANGAN menganggap sesuatu verified hanya karena pernah disebut.

Gunakan:
1. seluruh percakapan yang masih tersedia di chat ini;
2. hasil tool/source inspection yang benar-benar sudah dilakukan;
3. data repository/memory yang sudah dibaca;
4. keputusan user yang eksplisit;
5. hasil build/test/compile/hardware/Gemini yang benar-benar memiliki evidence.

Repository/current source tetap lebih tinggi daripada chat history.

============================================================
B. WAJIB REKONSTRUKSI SELURUH CHAT
============================================================

Telusuri seluruh konteks yang tersedia dan kumpulkan:

1. PROJECT CONTEXT
- identitas project;
- repository;
- branch;
- tujuan task;
- subchat type;
- workflow command terakhir;
- current state yang diketahui.

2. USER REQUIREMENTS
- semua requirement baru;
- requirement lama yang ditegaskan ulang;
- constraint;
- exact wording bila wording mempengaruhi behavior;
- requirement yang masih pending.

3. DECISIONS
- keputusan yang accepted/final;
- keputusan yang rejected;
- behavior yang frozen;
- behavior yang obsolete/superseded;
- perubahan prioritas.

4. TECHNICAL DISCUSSION
- architecture;
- source flow;
- UI behavior;
- BLE/P1;
- UUID;
- Android;
- Firebase;
- OTA;
- Firmware;
- hardware;
- CI/build;
- security;
- persistence;
- timing;
- safety.

5. SOURCE / REPOSITORY EVENTS
Untuk setiap source event yang terjadi di chat:
- exact file;
- exact path;
- branch;
- source version;
- commit SHA;
- blob SHA bila tersedia;
- before/after summary;
- apakah functional atau documentation-only;
- apakah sudah committed;
- apakah sudah diverifikasi dari repository.

6. BUILD EVENTS
Untuk setiap Build App/compile/build attempt:
- requested atau tidak;
- source SHA yang dimaksud;
- workflow;
- trigger;
- run ID;
- result;
- artifact name;
- artifact ID;
- APK size;
- SHA256;
- symbols;
- signing;
- gates;
- error/failure log;
- troubleshooting;
- apakah build benar-benar membuktikan source revision tertentu.

7. TEST / VALIDATION
Pisahkan secara eksplisit:
- static/source audit;
- automated tests;
- app release build;
- firmware compile;
- BIN generation;
- Firebase promotion;
- runtime test;
- hardware test;
- OTA test;
- BLE test.

Untuk setiap test:
- expected;
- observed;
- evidence;
- pass/fail;
- exact revision/binary;
- remaining uncertainty.

8. BUGS / SYMPTOMS
Catat setiap bug:
- symptom;
- kapan terjadi;
- device/version;
- reproduction;
- evidence;
- current status.

9. ROOT CAUSE
Pisahkan:
- VERIFIED ROOT CAUSE;
- STRONG EVIDENCE / LIKELY;
- HYPOTHESIS;
- NOT YET DETERMINED.

JANGAN menaikkan hypothesis menjadi root cause.

10. GEMINI
Untuk setiap Gemini interaction:
- exact question;
- actual answer;
- accepted conclusion;
- rejected conclusion;
- unresolved portion.

JANGAN membuat jawaban Gemini sendiri.

11. DEAD ENDS / FAILED APPROACHES
Simpan pendekatan yang sudah dicoba dan gagal agar chat baru tidak
mengulang kesalahan yang sama.

12. RISKS
- regression risk;
- source mismatch;
- build mismatch;
- firmware/app mismatch;
- hardware uncertainty;
- security concern;
- stale documentation;
- unresolved issue.

13. NEXT ACTION
Tentukan satu:
- exact next discussion;
- exact file/source area;
- exact build;
- exact test;
- exact Gemini question;
- atau exact reason mengapa belum boleh dieksekusi.

============================================================
C. STATUS CLASSIFICATION
============================================================

Gunakan label berikut secara eksplisit:

[USER REQUIREMENT]
[CONFIRMED]
[VERIFIED]
[IMPLEMENTED]
[COMMITTED]
[BUILT]
[TESTED]
[UNVERIFIED]
[HYPOTHESIS]
[OBSOLETE]
[REJECTED]
[BLOCKED]
[OPEN QUESTION]

Jangan mencampur label tersebut.

============================================================
D. CROSS-CHECK REPOSITORY
============================================================

Bila repository/source sudah diakses di chat ini:
- catat exact current HEAD yang terakhir terlihat;
- catat source SHA;
- catat relevant file SHA/blob;
- catat discrepancy antara chat dan repository;
- jangan menebak state repository setelah titik terakhir evidence.

Bila suatu perubahan dibahas tetapi belum berhasil di-commit:
status = [UNCOMMITTED] atau [UNVERIFIED], bukan [IMPLEMENTED].

Bila build berhasil tetapi source kemudian berubah:
build hanya berlaku untuk exact source SHA yang dibuild.

============================================================
E. PERSISTENT MEMORY VS CHAT-ONLY DATA
============================================================

Pisahkan dengan jelas:

PERSISTENT / ALREADY RECORDED
- informasi yang sudah tersimpan di repository memory.

CHAT-ONLY / NOT YET PERSISTED
- informasi penting yang hanya muncul di chat ini dan belum dipastikan
  sudah tercatat di repository.

JANGAN mengklaim repository sudah menyimpan sesuatu bila belum ada evidence.

============================================================
F. OUTPUT FORMAT — WAJIB
============================================================

Output SATU blok yang dimulai:

===== JE X FYZ CHAT RECAP PACKAGE START =====

Lalu gunakan struktur:

1. RECAP METADATA
2. CURRENT TASK
3. CURRENT WORKFLOW COMMAND
4. PROJECT / REPOSITORY STATE
5. USER REQUIREMENTS
6. FROZEN DECISIONS
7. REJECTED / OBSOLETE DECISIONS
8. APP STATE
9. FIRMWARE STATE
10. ANDROID / OTA / BLE / FIREBASE STATE
11. CI / BUILD STATE
12. SOURCE CHANGES
13. COMMITS / SHAs
14. BUGS / SYMPTOMS
15. VERIFIED ROOT CAUSES
16. HYPOTHESES
17. TEST / VALIDATION EVIDENCE
18. GEMINI RESULTS
19. FAILED APPROACHES / DEAD ENDS
20. KNOWN RISKS
21. UNRESOLVED QUESTIONS
22. CHAT-ONLY INFORMATION NOT YET PERSISTED
23. EXACT NEXT ACTION
24. REQUIRED FIRST ACTION IN NEW CHAT
25. SOURCE / MEMORY AUTHORITY RULE

Akhiri dengan:

===== JE X FYZ CHAT RECAP PACKAGE END =====

============================================================
G. NEW-CHAT HANDLING
============================================================

JANGAN membuat prompt transfer yang hanya berkata "lanjutkan".
Paket harus dapat diberikan utuh ke chat baru.

Paket harus cukup detail sehingga chat baru:
- tahu apa yang sudah dilakukan;
- tahu apa yang belum dilakukan;
- tahu apa yang benar-benar verified;
- tahu apa yang hanya hypothesis;
- tahu apa yang obsolete;
- tahu exact source/build evidence;
- tahu exact next action.

============================================================
H. SAFETY RULE
============================================================

Recap ini BUKAN source of truth final.
Recap hanya merupakan transfer evidence dari chat lama.

Chat baru WAJIB:
1. membaca seluruh project memory;
2. inspect current source/workflow;
3. compare recap dengan repository;
4. reconcile discrepancy;
5. menetapkan CURRENT PROJECT TRUTH.

Jangan melakukan implementation/build hanya karena recap menyebutnya,
kecuali workflow command dan evidence saat ini memang mengizinkan.

Sekarang hasilkan TRANSFER PACKAGE lengkap.
```

### PROMPT B — NEW CHAT TRANSFER

Use in the **new chat** and paste the complete Prompt A package at the bottom:

```
@Thinking NEW CHAT TRANSFER — JE X FYZ

Saya membawa CHAT RECAP PACKAGE dari chat sebelumnya.
Anggap package ini sebagai transfer evidence, BUKAN sebagai source of truth.

============================================================
A. NON-NEGOTIABLE RULE
============================================================

JANGAN langsung melanjutkan implementation/build berdasarkan recap.

Kamu WAJIB membangun ulang context dari repository terlebih dahulu.

Priority:

CURRENT SOURCE / CURRENT WORKFLOW
>
PROJECT_STATE.md
>
AUTHORITATIVE NOTES
>
BUILD_NOTES.md / CHANGELOG.md / HANDOVER.md
>
CHAT RECAP PACKAGE
>
CURRENT CHAT CLAIMS
>
OLD CHAT HISTORY

Jika recap berbeda dengan source:
- source/current workflow menang;
- jangan menghidupkan behavior lama;
- tandai discrepancy;
- jelaskan reconciliation.

============================================================
B. MANDATORY PREFLIGHT
============================================================

Sebelum action apa pun:

1. Baca README.md.
2. Baca PROJECT_STATE.md.
3. Baca CHAT_RULES.md.
4. Baca APP_NOTES.md.
5. Baca FIRMWARE_NOTES.md.
6. Baca BUILD_NOTES.md.
7. Baca CHANGELOG.md.
8. Baca HANDOVER.md.
9. Bila firmware relevan, baca firmware/FIRMWARE_ANALYSIS.md.
10. Inspect exact current source/workflow yang mengendalikan task.

Ini berlaku untuk:
- Diskusi;
- Eksekusi;
- Eksekusi Full;
- Build App;
- Gemini;
- compile;
- audit;
- runtime test;
- hardware test.

JANGAN melewati preflight karena recap dianggap lengkap.

============================================================
C. RECAP INGESTION
============================================================

Setelah memory preflight selesai:
1. baca seluruh JE X FYZ CHAT RECAP PACKAGE;
2. ekstrak requirements/decisions/state/evidence;
3. kelompokkan data menjadi:
   - VERIFIED;
   - CONFIRMED;
   - IMPLEMENTED;
   - UNVERIFIED;
   - HYPOTHESIS;
   - OBSOLETE;
   - OPEN QUESTION;
4. jangan mengubah label tanpa evidence.

============================================================
D. RECONCILIATION
============================================================

Bandingkan recap dengan:

1. PROJECT_STATE.md
2. current source
3. current workflow
4. APP_NOTES.md
5. FIRMWARE_NOTES.md
6. BUILD_NOTES.md
7. CHANGELOG.md
8. relevant firmware analysis

Untuk setiap mismatch:
- tulis apa yang diklaim recap;
- tulis apa yang sekarang dibuktikan source;
- tentukan mana yang berlaku;
- tandai data lama sebagai obsolete bila memang superseded.

============================================================
E. SOURCE / COMMIT VERIFICATION
============================================================

Verifikasi:
- repository;
- branch;
- current HEAD;
- current App source;
- current Firmware source bila relevan;
- exact workflow;
- trigger;
- current app version/build;
- latest verified App Build;
- exact source SHA of latest verified build;
- later commits since that build;
- relevant file/blob SHAs.

Jangan menyamakan:
source revision ≠ build revision
build success ≠ hardware validation
firmware source ≠ firmware BIN
BIN ≠ physical validation

============================================================
F. MEMORY INTEGRITY
============================================================

Tentukan mana information yang:
- sudah persistent di repository;
- hanya berasal dari recap;
- perlu disinkronkan ke memory;
- bertentangan dengan current source;
- tidak boleh dipertahankan karena obsolete.

Jangan menghapus history hanya karena conflict.
Gunakan current-state sections untuk menetapkan current truth.

============================================================
G. BUILD APP SAFETY
============================================================

Build App adalah engineering workflow kompleks.

Jangan Build kecuali workflow command saat ini memang mengizinkan.

Untuk Build App:
- baca seluruh memory;
- inspect current source;
- inspect workflow + trigger;
- record intended source SHA;
- current version/build;
- previous successful build;
- all delta since previous build;
- unresolved risks;
- setelah build sukses, persist exact source/run/artifact/checksum/gates/boundary.

Build tidak boleh dilakukan hanya karena recap menyebut "siap build".

============================================================
H. REQUIRED OUTPUT SETELAH RECONCILIATION
============================================================

Setelah semua preflight + reconciliation, jawab dengan:

CURRENT PROJECT TRUTH
- Project
- Repository
- Branch
- Current HEAD
- App version/build
- Firmware version/source
- Latest verified App Build
- Exact source SHA of latest verified build

RECAP VS REPOSITORY
- What matches
- What differs
- What became obsolete
- What remains chat-only

VERIFIED
- facts with repository/source/test evidence

UNVERIFIED
- items without sufficient evidence

KNOWN RISKS
- current meaningful risks only

OPEN QUESTIONS
- only questions that actually remain open

NEXT EXACT ACTION
- one precise next action

MEMORY SYNC REQUIRED
- which memory files need updating now, if any

WORKFLOW STATUS
- use the project's allowed status value exactly.

JANGAN mulai implementation/build sebelum status/workflow command memang
mengizinkannya.

============================================================
I. PERSISTENCE RULE
============================================================

Setelah rekonsiliasi selesai, jika ditemukan information penting yang belum
persisted, lakukan memory synchronization sesuai workflow rules.

Memory sync:
- boleh memperbarui documentation/state;
- tidak boleh menyelundupkan functional source change;
- harus mencatat discrepancy dan final reconciled truth;
- harus menyimpan next exact action.

============================================================
J. CHAT RECAP PACKAGE
============================================================

Tempel package di bawah prompt ini:

===== JE X FYZ CHAT RECAP PACKAGE START =====
[PASTE COMPLETE CHAT RECAP PACKAGE HERE]
===== JE X FYZ CHAT RECAP PACKAGE END =====

Mulai dari MANDATORY PREFLIGHT.
Jangan mengasumsikan chat lama masih tersedia.
```

### Continuity rule

Prompt A captures the chat.
Prompt B rebuilds and verifies the project state.

The repository/current source/current workflow remain authoritative over the recap.

## HANDOVER MAINTENANCE RULE

Whenever the chat-limit system itself changes, refresh:
- README.md
- CHAT_RULES.md
- PROJECT_STATE.md
- HANDOVER.md
- CHANGELOG.md

Update Build/APP/Firmware notes when the new continuity behavior affects their
domain.

