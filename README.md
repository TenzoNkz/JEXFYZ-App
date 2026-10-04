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

# 9. COPY-READY NEW CHAT PROMPT

The following prompt is intentionally detailed. **Copy it into a new JE X FYZ chat whenever the current chat reaches its limit or when starting a separate Build App subchat.**

```
@Thinking CONTINUE JE X FYZ PROJECT

Saya melanjutkan project JE X FYZ / JE Cooler dari repository resmi.

JANGAN mengandalkan memory percakapan lama sebagai source of truth.
JANGAN mulai dari asumsi.
JANGAN mengulang desain lama yang sudah superseded.

============================================================
MANDATORY MEMORY PREFLIGHT — WAJIB SEBELUM ACTION APA PUN
============================================================

Sebelum membaca, menganalisa, berdiskusi, mengeksekusi, Build App,
bertanya kepada Gemini, melakukan audit, membaca hasil build, atau
menafsirkan hasil hardware:

1. Baca README.md.
2. Baca PROJECT_STATE.md.
3. Baca CHAT_RULES.md.
4. Baca APP_NOTES.md.
5. Baca FIRMWARE_NOTES.md.
6. Baca BUILD_NOTES.md.
7. Baca CHANGELOG.md.
8. Bila firmware relevan, baca firmware/FIRMWARE_ANALYSIS.md.
9. Setelah itu inspeksi CURRENT SOURCE / CURRENT WORKFLOW yang benar-benar
   mengendalikan task.

JANGAN melewati langkah preflight walaupun:
- ini chat baru;
- Build App;
- task terlihat sederhana;
- perubahan hanya satu baris;
- saya mengatakan "lanjutkan";
- konteks chat sebelumnya sudah hilang.

============================================================
SOURCE / MEMORY AUTHORITY
============================================================

Gunakan urutan kebenaran:

CURRENT SOURCE / CURRENT WORKFLOW
>
PROJECT_STATE.md
>
AUTHORITATIVE APP/FIRMWARE NOTES
>
BUILD_NOTES.md / CHANGELOG.md / HANDOVER.md
>
CURRENT CHAT
>
OLD CHAT HISTORY

Jika ada konflik:
- source terbaru menang;
- jangan menghidupkan kembali fitur lama;
- verifikasi commit/source sebelum menyimpulkan.

============================================================
REPOSITORY
============================================================

APP:
https://github.com/TenzoNkz/JEXFYZ-App

FIRMWARE DISTRIBUTION:
https://github.com/TenzoNkz/JEXFYZ-Firmware

APP REPO menyimpan source firmware untuk continuity.
FIRMWARE REPO adalah binary distribution repository.
JANGAN memindahkan source .ino atau FIRMWARE_NOTES.md ke firmware repo.

============================================================
AUTOMATIC MEMORY SYNCHRONIZATION — WAJIB
============================================================

Setelah setiap meaningful:
- Diskusi;
- Audit;
- Eksekusi;
- Eksekusi Full;
- Build App;
- Tanya Gemini;
- compile attempt;
- runtime test;
- hardware test;
- failure;
- rules change;

WAJIB sinkronkan memory yang relevan tanpa menunggu saya meminta.

Minimal pertahankan:
PROJECT_STATE.md
CHAT_RULES.md
APP_NOTES.md
FIRMWARE_NOTES.md

Dan sesuai kebutuhan:
BUILD_NOTES.md
CHANGELOG.md
HANDOVER.md
firmware/FIRMWARE_ANALYSIS.md

Jangan kehilangan:
- requirement terbaru;
- keputusan accepted/rejected;
- exact source SHA;
- exact build/run/artifact;
- failed attempt/dead end;
- validation status;
- unresolved risks;
- next action.

Memory update tidak boleh dipakai untuk menyelundupkan functional source
change ketika command saya hanya @Thinking Diskusi!.

============================================================
BUILD APP — KHUSUS DAN KOMPLEKS
============================================================

Build App boleh dilakukan hanya ketika saya meminta @Thinking Build App!
atau @Thinking Eksekusi & Build App!.

Build App biasanya dilakukan pada subchat berbeda.
Karena itu Build App TIDAK BOLEH bergantung pada context chat sebelumnya.

Sebelum Build:
- baca seluruh memory;
- baca current App source;
- baca workflow;
- baca trigger;
- tentukan exact source SHA;
- tentukan current version/build number;
- catat previous successful build;
- catat semua perubahan sejak previous successful build;
- catat known risks.

Setelah Build sukses:
- simpan source SHA;
- workflow/run ID;
- build number;
- artifact;
- artifact ID;
- size;
- SHA256;
- symbols;
- semua perubahan source/config/workflow/dependency;
- troubleshooting changes;
- validation gates;
- known unvalidated areas;
- next build baseline.

Successful Build = MEMORY CHECKPOINT.

============================================================
FIRMWARE CONTINUITY
============================================================

Current firmware source must be determined from PROJECT_STATE + repository.

Known platform contract:
- ESP32-C3;
- Arduino Standard;
- Arduino-ESP32 Core 3.3.7.

GPIO authority:
GPIO0 = NTC
GPIO1 = Touch
GPIO3 = 12V selector
GPIO4 = 9V selector
GPIO5 = Peltier
GPIO6 = Fan
GPIO7 = WS2812

Logical BLE tokens:
FAN:* -> Fan
PELTIER:* -> Peltier

Do not change physical/logical mapping without verified evidence.

Firmware source versioning is mandatory for functional image changes.

Never claim:
source audit = compile
compile = BIN publication
BIN = hardware test
App Build = firmware validation

============================================================
WORKFLOW SEMANTICS
============================================================

@Thinking Diskusi!
= review/analysis only; memory-sync documentation is allowed automatically.
No functional source/build/release changes.

@Thinking Eksekusi!
= implement + audit relevant area + memory-sync + commit.

@Thinking Eksekusi Full!
= implement + full affected-area regression + memory-sync + commit.

@Thinking Build App!
= complete build/validation workflow only.

@Thinking Eksekusi & Build App!
= implementation + audit + memory-sync + commit + Build App + build-memory checkpoint.

@Thinking Tanya Gemini!
= focused second opinion; never fabricate result.

============================================================
WHEN CHAT LIMIT IS NEAR
============================================================

Do NOT wait for me to remember the handover.

Before continuity becomes unsafe:
1. Sync memory.
2. Refresh PROJECT_STATE.md.
3. Refresh HANDOVER.md.
4. Produce a complete copy-ready continuation prompt.

The new chat must begin again from README.md and perform the mandatory
preflight before doing anything else.

============================================================
FIRST RESPONSE AFTER THIS PROMPT
============================================================

After completing the mandatory preflight, report:

CURRENT PROJECT STATE
CURRENT APP VERSION/BUILD
CURRENT FIRMWARE VERSION
CURRENT SOURCE SHA
LATEST VERIFIED BUILD
WHAT CHANGED LAST
WHAT IS VERIFIED
WHAT IS NOT VERIFIED
KNOWN RISKS
NEXT EXACT ACTION
WORKFLOW STATUS

Then continue the task I provide.

DO NOT invent missing evidence.
DO NOT fabricate Gemini.
DO NOT claim physical validation without a physical test.
DO NOT Build App unless I explicitly request it.
```

---

## 10. Quick New-Chat Command

For normal continuation, the detailed prompt above is preferred.

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
firmware/FIRMWARE_ANALYSIS.md bila relevan
lalu inspect current source/workflow.

Sync project memory automatically after every meaningful project event.
For Build App, treat the subchat as a fresh engineering environment.
```

---

## 11. Golden Rules

**Never trust memory without checking source.**

**Never trust old source over current source.**

**Never claim an unperformed validation.**

**Never let a chat limit become a data-loss event.**

**Never require the user to remind the assistant to update project memory.**

**Build success must permanently explain what was actually built and what changed.**

**Current state must always be recoverable from the repository alone.**
