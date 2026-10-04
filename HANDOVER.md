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

## COPY-READY PROMPT

```
@Thinking CONTINUE JE X FYZ PROJECT

JANGAN mengandalkan chat history lama sebagai source of truth.
JANGAN mulai dari asumsi.
JANGAN menghidupkan kembali behavior yang sudah superseded.

MANDATORY PREFLIGHT — SEBELUM ACTION APA PUN:

1. Read README.md.
2. Read PROJECT_STATE.md.
3. Read CHAT_RULES.md.
4. Read APP_NOTES.md.
5. Read FIRMWARE_NOTES.md.
6. Read BUILD_NOTES.md.
7. Read CHANGELOG.md.
8. Read firmware/FIRMWARE_ANALYSIS.md when firmware context is relevant.
9. Inspect the exact current source/workflow controlling the requested task.

Ini WAJIB untuk:
- Diskusi;
- Eksekusi;
- Eksekusi Full;
- Build App;
- Gemini;
- compile attempt;
- audit;
- runtime/hardware test;
- result interpretation.

MEMORY AUTHORITY:
CURRENT SOURCE / CURRENT WORKFLOW
>
PROJECT_STATE
>
AUTHORITATIVE NOTES
>
BUILD_NOTES / CHANGELOG / HANDOVER
>
CURRENT CHAT
>
OLD CHAT HISTORY

AUTOMATIC MEMORY SYNC:
Setiap meaningful project event harus meninggalkan persistent memory.
Jangan tunggu user berkata "update memory".

Untuk Diskusi:
- simpan requirement;
- keputusan;
- accepted/rejected;
- confirmed facts;
- unresolved questions;
- risks;
- next action.
Diskusi boleh mengubah memory-only documentation tetapi TIDAK boleh mengubah functional source,
build/release, atau behavior.

Untuk Eksekusi:
- simpan changed files;
- exact SHA;
- version;
- audit/regression;
- validation boundary.

Untuk Build App:
- treat as complex engineering workflow;
- baca semua memory walaupun subchat berbeda;
- inspect exact source/workflow;
- record exact source SHA before build;
- record latest previous build;
- record changes since previous build;
- setelah sukses, simpan run/build/artifact/checksum/gates/remaining boundary.

A SUCCESSFUL BUILD IS A MEMORY CHECKPOINT.

Untuk Gemini:
- record exact question;
- record actual result only;
- never fabricate Gemini;
- keep source as authority.

Untuk hardware:
- record device, binary/version, expected vs observed behavior, evidence, pass/fail, unresolved risk.

CHAT LIMIT:
Jika context mendekati limit:
1. sync memory;
2. refresh PROJECT_STATE;
3. refresh HANDOVER;
4. output one complete copy-ready prompt;
5. new chat starts again from README.

REPOSITORY:
APP = TenzoNkz/JEXFYZ-App
FIRMWARE DISTRIBUTION = TenzoNkz/JEXFYZ-Firmware

FIRMWARE GPIO:
GPIO0 NTC
GPIO1 Touch
GPIO3 12V selector
GPIO4 9V selector
GPIO5 Peltier
GPIO6 Fan
GPIO7 WS2812

V3.7 PELTIER:
OFF -> ON = 5 s soft-start
VOLTAGE UP while ON = restart 5 s soft-start
VOLTAGE DOWN = no restart

FIRMWARE PLATFORM:
ESP32-C3
Arduino Standard
official Arduino-ESP32 Core 3.3.7

APP BUILD:
manual-by-issue trigger only
issue title = JE X FYZ — BUILD APP TRIGGER
body token = JEXFYZ_BUILD_TRIGGER_V1
do not build from ordinary push/PR

NEVER claim:
source audit = compile
compile = BIN publication
BIN = hardware test
App Build = firmware validation

AFTER PREFLIGHT:
Report:
- CURRENT PROJECT STATE
- APP VERSION/BUILD
- FIRMWARE VERSION
- CURRENT SOURCE SHA
- LATEST VERIFIED BUILD
- LAST COMPLETED WORK
- VERIFIED
- NOT VERIFIED
- KNOWN RISKS
- NEXT EXACT ACTION
- WORKFLOW STATUS

Then continue the user task.
```

## HANDOVER MAINTENANCE RULE

This file must be refreshed whenever a chat-limit handover is generated.
The prompt must reflect the latest PROJECT_STATE rather than preserving obsolete source/version data.
