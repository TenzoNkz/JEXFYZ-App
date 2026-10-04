## 2026-10-04 — CHAT-LIMIT CONTINUITY CHECKPOINT

- This repository is the persistent continuity boundary for JE X FYZ while the current chat approaches its context limit.
- The detailed copy-ready continuation prompt is available in both `README.md` and `HANDOVER.md`.
- A new chat must re-read the complete memory stack before any action, including Build App subchats.
- Current functional firmware remains V3.7; this checkpoint does not change runtime behavior.
- Latest verified App Build remains #50; no Build App was run during the handover.

# JE X FYZ — Project Operating Manual

> **This repository is the primary continuity/source repository for JE X FYZ / JE Cooler.**
> The goal of this README is not only to describe the codebase, but to provide the mandatory path an assistant must follow before doing any project work.

## 1. FIRST RULE — READ THE MEMORY BEFORE WORKING

Before any JE X FYZ discussion, analysis, source inspection, execution, audit, Gemini review, compile/build attempt, Build App workflow, or test-result interpretation, the assistant must rebuild project context from the repository.

### Mandatory preflight order

1. **README.md** — this operating manual.
2. **PROJECT_STATE.md** — current project snapshot.
3. **CHAT_RULES.md** — workflow/process rules.
4. **APP_NOTES.md** — App contract and App history.
5. **FIRMWARE_NOTES.md** — Firmware contract and Firmware history.
6. **BUILD_NOTES.md** — App Build history and build continuity.
7. **CHANGELOG.md** — historical milestone summary.
8. **firmware/FIRMWARE_ANALYSIS.md** — firmware architecture/safety map when Firmware context is relevant.
9. Inspect the **current source/workflow** that actually controls the task.

Never start from old chat memory alone.

### Source authority

When information conflicts, use this priority:

```
CURRENT SOURCE / CURRENT WORKFLOW
        >
PROJECT_STATE.md
        >
AUTHORITATIVE NOTES
        >
BUILD_NOTES.md / CHANGELOG.md / HANDOVER.md
        >
CURRENT CHAT
        >
OLD CHAT HISTORY
```

Historical notes must not resurrect superseded behavior.

---

## 2. MEMORY SYSTEM

The project uses multiple persistent memory layers because a single chat can reach its context limit.

| File | Role |
|---|---|
| `README.md` | Project operating manual and new-chat entry point |
| `PROJECT_STATE.md` | Current truth / latest snapshot |
| `CHAT_RULES.md` | Workflow and process rules |
| `APP_NOTES.md` | App engineering contract + history |
| `FIRMWARE_NOTES.md` | Firmware engineering contract + history |
| `BUILD_NOTES.md` | Build App continuity and artifact history |
| `CHANGELOG.md` | Version/milestone history |
| `HANDOVER.md` | Ready-to-copy continuation prompt |
| `firmware/FIRMWARE_ANALYSIS.md` | Firmware architecture and safety analysis |

### Important distinction

**Memory synchronization is not the same thing as functional source modification.**

For example, `@Thinking Diskusi!` must not modify firmware/App behavior, but the automatic memory checkpoint may update documentation/state files so the discussion is not lost when the chat ends.

---

## 3. AUTOMATIC MEMORY SYNCHRONIZATION

Memory synchronization is a mandatory part of every meaningful JE X FYZ workflow.

The user must not need to say “update memory”.

### Discussion

After meaningful discussion, record as applicable:

- new requirements;
- accepted/rejected decisions;
- frozen behavior;
- clarified ambiguities;
- confirmed facts;
- unresolved questions;
- validation conclusions;
- current next action;
- risks and known dead ends.

### Execution / Execution Full

Also record:

- exact changed files;
- source/version;
- commit SHA;
- regression/audit result;
- validation boundary;
- what was intentionally not changed.

### Build App

A Build App workflow is treated as a complex engineering workflow even when it runs in a separate chat.

Before building:

- re-read all project memory;
- inspect current App source;
- inspect the exact build workflow and trigger;
- identify the exact source SHA being built;
- identify current version/build number;
- identify the previous successful build;
- identify all known changes and unresolved risks.

After a successful build, immediately record:

- exact source SHA;
- workflow/run ID;
- build number/version;
- artifact name/ID;
- APK size and SHA256 when available;
- symbols artifact metadata when available;
- all source/config/workflow/dependency changes included since the previous successful build;
- build-only troubleshooting changes;
- validation gates;
- what remains unvalidated;
- exact next state.

A successful build is a **persistent memory checkpoint**, not merely an APK.

### Gemini review

Record the exact question, the received result, the accepted/rejected conclusion, and what remains unverified. Never fabricate a Gemini answer.

### Hardware / runtime test

Record the exact device/binary/version, expected behavior, observed behavior, evidence, pass/fail, and remaining risk.

---

## 4. CHAT-LIMIT CONTINUITY

When the active chat approaches a context limit, continuity must be prepared before information is lost.

The assistant must:

```
FREEZE CURRENT UNDERSTANDING
        ↓
SYNC ALL RELEVANT MEMORY
        ↓
REFRESH PROJECT_STATE
        ↓
REFRESH HANDOVER
        ↓
PROVIDE COPY-READY PROMPT
        ↓
NEW CHAT READS README FIRST
```

The new chat must not assume the previous conversation is available.

`HANDOVER.md` is portable context. `PROJECT_STATE.md` is the current persistent snapshot.

---


## 4A. DUAL-PROMPT CHAT-LIMIT CONTINUITY SYSTEM

Untuk mencegah kehilangan konteks saat satu chat mencapai limit, JE X FYZ
menggunakan dua prompt resmi yang bekerja berurutan:

**PROMPT A — CHAT-LIMIT RECAP**
- dipakai di chat lama ketika peringatan limit muncul;
- mengekspor seluruh konteks chat menjadi `JE X FYZ CHAT RECAP PACKAGE`;
- mencatat requirement, decision, source, commit, build, bug, root cause,
  hypothesis, test evidence, Gemini, dead ends, risk, unresolved question,
  dan exact next action;
- membedakan persistent repository memory dengan chat-only information;
- tidak boleh mengarang evidence;
- tidak menjadi source of truth final.

**PROMPT B — NEW CHAT TRANSFER**
- dipakai di chat baru bersama package dari Prompt A;
- membaca seluruh project memory terlebih dahulu;
- inspect current source/workflow;
- membandingkan package dengan repository;
- merekonsiliasi discrepancy;
- menetapkan current project truth;
- hanya setelah itu melanjutkan workflow yang memang diizinkan.

### Authority rule

Chat Recap Package adalah **transfer evidence**, bukan replacement untuk
repository memory. Current source/current workflow tetap menjadi authority
tertinggi.

### Mandatory sequence

```
CHAT LAMA + LIMIT WARNING
        ↓
PROMPT A — FULL CHAT RECAP
        ↓
JE X FYZ CHAT RECAP PACKAGE
        ↓
CHAT BARU
        ↓
PROMPT B — MEMORY PREFLIGHT
        ↓
CURRENT SOURCE / WORKFLOW INSPECTION
        ↓
RECONCILIATION
        ↓
CURRENT PROJECT TRUTH
        ↓
CONTINUE EXACT NEXT ACTION
```

### Special Build App rule

Build App subchat juga wajib menggunakan Prompt B. Recap tidak boleh
menggantikan mandatory memory preflight, current-source inspection,
workflow/trigger verification, atau exact-build-SHA identification.

### Official copy-ready prompts

Prompt lengkap berada di `README.md` dan `HANDOVER.md` dengan judul:
- **PROMPT A — CHAT-LIMIT RECAP**
- **PROMPT B — NEW CHAT TRANSFER**

## 5. WORKFLOW COMMANDS

### `@Thinking Diskusi!`

Discussion/review only.

Allowed automatically:
- read source;
- inspect repository;
- analyze;
- update persistent memory/documentation required by the memory-sync rule.

Not allowed:
- functional App source changes;
- functional Firmware source changes;
- build/release actions;
- unrelated repository changes.

### `@Thinking Eksekusi!`

Implement the approved change, synchronize memory, and commit.

Do not Build App unless explicitly requested.

### `@Thinking Eksekusi Full!`

Implement the approved change, audit the full affected area, synchronize memory, and commit.

Do not Build App unless explicitly requested.

### `@Thinking Build App!`

Build/validate the App using the current intended source.

This is a **full continuity workflow** because Build App normally uses a separate subchat.

Do not make unrelated source changes during the build.

### `@Thinking Eksekusi & Build App!`

Implement → audit → synchronize memory → commit → Build App → synchronize build memory.

### `@Thinking Tanya Gemini!`

Use a focused second-opinion question when technically useful. Never invent Gemini output.

---

## 6. APP / FIRMWARE REPOSITORY BOUNDARY

### App repository

`TenzoNkz/JEXFYZ-App`

Contains:

- Flutter App source;
- Android project;
- CI/build workflow;
- firmware continuity source under `firmware/`;
- project memory and engineering documentation.

### Dedicated Firmware repository

`TenzoNkz/JEXFYZ-Firmware`

Distribution boundary:

- binary-only;
- do not place `.ino` source here;
- do not place `FIRMWARE_NOTES.md` here.

---

## 7. CURRENT BUILD POLICY

App Build is manual-by-issue-trigger only.

Expected issue title:

`JE X FYZ — BUILD APP TRIGGER`

Required body token:

`JEXFYZ_BUILD_TRIGGER_V1`

Normal push/PR activity must not generate the release APK.

The release workflow currently uses Java 17, Flutter 3.47.2 stable, and Gradle 9.3.1. The production release uses the existing signing identity. The intended result is one normal APK artifact, not a Play Store bundle.

Build details and historical artifacts belong in `BUILD_NOTES.md`.

---

## 8. FIRMWARE VALIDATION POLICY

Current functional Firmware source:

`firmware/JEXFYZ-V3.7.ino`

Target:

- ESP32-C3 Super Mini / ESP32-C3 Dev Module;
- Arduino Standard;
- official Arduino-ESP32 Core 3.3.7.

Source/static audit, ArduinoDroid compilation, BIN generation, Firebase promotion, and physical-device validation are separate evidence layers.

Never claim a later layer from an earlier one.

---

# 9. OFFICIAL CHAT-LIMIT PROMPTS

The project maintains two distinct prompts. Use them in order.

## PROMPT A — CHAT-LIMIT RECAP

Copy the complete block below into the **old chat** when the platform warns
that the chat/context limit is approaching.

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

## PROMPT B — NEW CHAT TRANSFER

Copy the complete block below into the **new chat**, then paste the complete
output from Prompt A into its designated package section.

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

## Prompt selection rule

Do not use Prompt A in a new chat.
Do not use Prompt B as a substitute for Prompt A.
Do not treat the recap as authoritative until current repository/source/workflow
reconciliation is complete.

## 10. Quick New-Chat Command

For normal continuation, the detailed Prompt B above is preferred.

A shorter entry is:

```
@Thinking CONTINUE JE X FYZ

WAJIB preflight:
README.md
PROJECT_STATE.md
CHAT_RULES.md
APP_NOTES.md
FIRMWARE_NOTES.md
BUILD_NOTES.md
CHANGELOG.md
HANDOVER.md
firmware/FIRMWARE_ANALYSIS.md bila relevan
lalu inspect current source/workflow.

Sync project memory automatically after every meaningful project event.
Untuk chat transfer, gunakan Prompt B.
Untuk Build App, perlakukan subchat sebagai fresh engineering environment.
```

## 11. Golden Rules

**Never trust memory without checking source.**

**Never trust old source over current source.**

**Never trust a chat recap over current source/current workflow.**

**Never claim an unperformed validation.**

**Never let a chat limit become a data-loss event.**

**Never require the user to remind the assistant to update project memory.**

**Build success must permanently explain what was actually built and what changed.**

**Current state must always be recoverable from the repository alone.**

