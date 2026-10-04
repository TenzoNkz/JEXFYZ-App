## 2026-10-04 — EXECUTION FULL / GEMINI ONLINE OTA PATCH APPLIED

- Applied the supplied Gemini Online OTA patch to the exact V4.0 source.
- Online OTA now uses `WiFiClientSecure cloudClient` + `setInsecure()`, intentionally prioritizing GitHub raw-BIN compatibility over CA validation.
- Removed only the intermediate GREEN-after-GitHub and BLUE-after-download transitions.
- Preserved Wi-Fi-success BLUE, YELLOW 20/40/60/80/100 download milestones, final GREEN success, and RED failure/recovery.
- Local OTA region was verified byte-for-byte unchanged.
- Current source blob: `0566105383a889912e5e756b0b9f265e5fcf0264`.
- Compile/BIN/Firebase/physical Online OTA validation remains unverified; fresh Assistant + Gemini review is required before flashing.

## 2026-10-04 — GEMINI PATCH-ONLY PROTOCOL

- [WORKFLOW] `@Thinking Tanya Gemini!` now uses the dedicated `GEMINI_PROMPT_ONLINE_OTA.md` prompt when diagnosing the current Online OTA issue.
- [REQUIRED GEMINI OUTPUT] Patch-only: exact `OLD` block → `NEW` block. Gemini must not return the full `.ino` file.
- [EXECUTION HANDOFF] After the user supplies Gemini's patch, `@Thinking Eksekusi Full!` is the stage that applies and audits the patch against the exact current repository source, then commits it.
- [LOCAL OTA] Frozen/protected because Local OTA has been proven working on hardware. Do not modify Local OTA for Online OTA fixes.
- [ONLINE OTA] User priority is simple reliable GitHub download/flash; `setInsecure()` is acceptable for the Online OTA path and the binary URL remains restricted to the JE X FYZ firmware repository.

## 2026-10-04 — V4.0 COMPILE FIX

- [FIXED] ArduinoDroid compile error from `batteryZoneFor(batteryC)` using the wrong argument count.
- [CORRECT] Call now uses `batteryZoneFor(batteryC, currentVoltage)`.
- [CURRENT SOURCE] `firmware/JEXFYZ-V4.0.ino` blob `415346ece09f4af33f907b2077140ccfc45c357b`.
- [GATE] Previous dual-party SAFE verdict applied to the older V4.0 blob and is superseded by this source change; fresh Gemini + Assistant review is required before flashing.

## 2026-10-04 — V4.0 DUAL-PARTY FLASH GATE DECISION

- [GEMINI] User-provided independent Gemini audit of exact V4.0 blob `b2a77fadeaa154412850d34c82b0bb78ef108bae`: **SAFE TO FLASH**.
- [ASSISTANT] Independent reconciliation against the same exact V4.0 source agrees: **SAFE TO FLASH**.
- [DUAL-PARTY] Assistant + Gemini now agree. The V4.0 source-level flash gate is OPEN for the controlled next validation stage.
- [CLARIFICATION] SAFE TO FLASH here means safe to proceed to compile/BIN/controlled hardware validation; it does not claim compile success or physical validation success.
- [VERIFIED] P0 300 ms post-selector stabilization, P1 trusted certificate-bundle TLS, 200 ms selector deadtime, rapid-rise safety latch, OTA safe outputs, anti-rollback, and GitHub raw BIN URL allowlist are present in the exact source.
- [NO SOURCE CHANGE] This is a review/gate event only.

## 2026-10-04 — CURRENT V4.0 EXECUTION STATE

- [CURRENT] Firmware advanced V3.9 → V4.0 after the approved full hardening execution.
- [CURRENT] Active source: `firmware/JEXFYZ-V4.0.ino`; source blob: `b2a77fadeaa154412850d34c82b0bb78ef108bae`.
- [IMPLEMENTED] P0 post-selector rail stabilization: 9V/12V activation now holds physical Peltier PWM at 0% for an initial cooperative 300 ms stabilization window while preserving the logical Peltier state and existing 5 s OFF→ON soft-start timeline.
- [IMPLEMENTED] P1 Online OTA TLS: `cloudClient.setInsecure()` removed; the exact Arduino-ESP32 Core 3.3.7 NetworkClientSecure certificate-bundle mechanism is enabled through a small derived client wrapper.
- [VERIFIED STATIC] V4.0: braces 581/581; parentheses 2123/2123; executable `delay()` 0; timing `while()` 0; `setInsecure()` 0; `stopBleRadio(false)` 0; DOC-CONTRACT 137.
- [UNVERIFIED] ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile/link, BIN generation, Firebase promotion, physical flash, rail/current measurements, and runtime validation.
- [GATE] The prior V3.9 NOT-SAFE decision no longer describes the current source, but V4.0 is NOT YET APPROVED TO FLASH because the required two-party Assistant + Gemini review must be repeated on the new V4.0 source first.
- [NO APP BUILD] App source/configuration remains unchanged; Build #50 remains the latest verified App artifact.
- [NEXT] Submit V4.0 to the same independent Assistant/Gemini audit; only after both agree proceed to compile/BIN/controlled hardware validation.

## 2026-10-04 — CHAT-LIMIT CONTINUITY CHECKPOINT

- This repository is the persistent continuity boundary for JE X FYZ while the current chat approaches its context limit.
- The detailed copy-ready continuation prompt is available in both `README.md` and `HANDOVER.md`.
- A new chat must re-read the complete memory stack before any action, including Build App subchats.
- Current functional firmware is now V3.8; this checkpoint records the functional soft-start scope change.
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
9. **HANDOVER.md** — portable continuity context when present.
10. **CHAT_TRANSFER.md** — latest old-chat transfer snapshot saved by Prompt 1.
11. Inspect the **current source/workflow** that actually controls the task.

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
| `CHAT_TRANSFER.md` | Rolling old-chat → new-chat transfer snapshot |
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

When the active chat approaches a context limit, the continuity process is
repository-first.

```
LIMIT WARNING
    ↓
PROMPT 1 — CHAT-LIMIT RECAP
    ↓
READ WHOLE CHAT + RECONCILE
    ↓
WRITE CHAT_TRANSFER.md
    ↓
UPDATE PROJECT_STATE / RELEVANT MEMORY
    ↓
COMMIT + VERIFY
    ↓
NEW CHAT
    ↓
PROMPT 2 — NEW CHAT TRANSFER
    ↓
READ COMPLETE MEMORY + CHAT_TRANSFER
    ↓
INSPECT CURRENT SOURCE / WORKFLOW
    ↓
RECONCILE
    ↓
CONTINUE EXACT NEXT ACTION
```

Prompt 1 runs in the old chat and saves the complete available chat context to
CHAT_TRANSFER.md. Prompt 2 runs in the new chat and rebuilds context from the
repository without requiring the old chat to remain available.

CHAT_TRANSFER.md is transfer evidence only. Current source/current workflow
remain authoritative.

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

`firmware/JEXFYZ-V3.8.ino`

Target:

- ESP32-C3 Super Mini / ESP32-C3 Dev Module;
- Arduino Standard;
- official Arduino-ESP32 Core 3.3.7.

Source/static audit, ArduinoDroid compilation, BIN generation, Firebase promotion, and physical-device validation are separate evidence layers.

Never claim a later layer from an earlier one.

---

# 9. OFFICIAL CHAT-LIMIT PROMPTS

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
8. firmware/FIRMWARE_ANALYSIS.md bila firmware relevan
9. HANDOVER.md
10. CHAT_TRANSFER.md
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

## Prompt usage rule

- Prompt 1 = CHAT → REPOSITORY.
- Prompt 2 = REPOSITORY → NEW CHAT.
- Prompt 2 never replaces the mandatory memory preflight.
- CHAT_TRANSFER.md never outranks current source/current workflow.
- Build App subchats use Prompt 2 as a fresh engineering environment.

## 10. Quick New-Chat Command

```
@Thinking NEW CHAT TRANSFER — READ FROM REPOSITORY AND CONTINUE

WAJIB preflight:
README.md
PROJECT_STATE.md
CHAT_RULES.md
APP_NOTES.md
FIRMWARE_NOTES.md
BUILD_NOTES.md
CHANGELOG.md
firmware/FIRMWARE_ANALYSIS.md bila relevan
HANDOVER.md
CHAT_TRANSFER.md
lalu inspect current source/workflow.

Baca CHAT_TRANSFER.md, reconcile dengan repository/current source,
tetapkan current project truth, dan lanjutkan exact next action.
Sync project memory automatically.
```

## 11. Golden Rules

**Never trust memory without checking source.**

**Never trust a chat transfer over current source/current workflow.**

**Never claim an unperformed validation.**

**Never let a chat limit become a data-loss event.**

**Never require the user to manually reconstruct project history when it can be
persisted in the repository.**

**Build success must permanently explain what was actually built and what changed.**

**Current state must always be recoverable from the repository alone.**

## 2026-10-04 — CURRENT FIRMWARE V3.9 HARDENING
- Current Firmware: V3.9
- Active source: `firmware/JEXFYZ-V3.9.ino`
- V3.9 implements the approved safety/OTA hardening pass.
- Frozen contract: Peltier 5 s soft-start is logical OFF -> ON only; voltage changes do not restart soft-start.
- V3.9 has not yet been compiled, flashed, or physically validated.
- App Build #50 remains the latest verified App artifact; no App Build is required for this firmware-only change.
