# JE X FYZ — Chat Transfer Protocol

This file is reserved **only for transferring work between ChatGPT conversations**. It is not a project changelog, execution diary, or technical source of truth. Current project state belongs in `CHAT_TRANSFER.md`; persistent state and technical history belong in their dedicated files.

## Prompt 1 — Chat-Limit Recap / Save to Repository

Copy this prompt when the current conversation is nearing its context limit:

```text
@Thinking CHAT-LIMIT RECAP — SAVE TO REPOSITORY

Tujuan: rekonsiliasi state percakapan dengan repository, lalu REPLACE
CHAT_TRANSFER.md dengan transfer protocol/snapshot terbaru.

WAJIB:
1. Baca CHAT_TRANSFER.md sebelum menggantinya.
2. Verifikasi current main HEAD, source aktif, App source, workflow, dan status PR/branch yang relevan.
3. Baca PROJECT_STATE.md, HANDOVER.md, CHAT_RULES.md, serta catatan teknis yang relevan.
4. Pisahkan CURRENT TRUTH, VERIFIED, USER-REPORTED, UNVERIFIED, HYPOTHESIS,
   HISTORY/OBSOLETE, dan CHAT-ONLY STATE.
5. Simpan versi/path/blob SHA/commit SHA serta bukti compile, test, flash, dan OTA secara tepat.
6. Replace CHAT_TRANSFER.md; jangan append snapshot duplikat.
7. Update PROJECT_STATE.md/HANDOVER.md hanya jika state persisten memang berubah.
8. Re-read file yang disimpan dan verifikasi commit serta isinya.

BATASAN:
- Jangan mengubah source fungsional hanya karena proses transfer.
- Jangan compile Firmware, Build App, membuat BIN, flash/OTA, atau release tanpa
  perintah eksplisit yang sesuai.
- Prefer commit langsung ke main. Jangan membuat branch/PR kecuali diminta.
- Jangan mengklaim test atau validasi yang tidak dijalankan.
- Jika write gagal, tandai BLOCKED dan jangan mengklaim transfer tersimpan.

Selesaikan verifikasi persistence dan laporkan bukti commit secara singkat.
```

## Prompt 2 — New Chat Boot / QC Pre-Release

Copy this prompt when opening a new conversation:

```text
@Thinking NEW CHAT BOOT — JE X FYZ / QC PRE-RELEASE

Jangan memulai ulang project atau langsung mengubah source.

MANDATORY BOOT:
1. Baca CHAT_TRANSFER.md terlebih dahulu.
2. Baca PROJECT_STATE.md, HANDOVER.md, dan CHAT_RULES.md.
3. Baca APP_NOTES.md, FIRMWARE_NOTES.md, firmware/FIRMWARE_ANALYSIS.md,
   OTA_PROTECTION.md, BUILD_NOTES.md, dan CHANGELOG.md bila relevan.
4. Periksa current main HEAD, active Firmware source/version/blob,
   App source, workflow aktif, PR/branch penting, dan status file yang relevan.
5. Rekonsiliasi kontradiksi tanpa mengarang fakta.
6. Jangan mengubah source saat boot/reconciliation.

AUTHORITY:
Current source + active workflow > PROJECT_STATE.md > authoritative current notes
> CHAT_RULES.md/HANDOVER.md/CHANGELOG.md > CHAT_TRANSFER.md > current chat > old chat.

QC:
- Source presence/static audit bukan bukti compile, flash, atau physical behavior.
- Jangan Build App kecuali user eksplisit meminta Build App.
- Jangan compile/build Firmware kecuali user eksplisit meminta compile/build Firmware.
- Jangan flash, mengubah production OTA metadata, atau release tanpa otorisasi.
- Source fungsional frozen selama QC kecuali ada defect nyata dengan root cause jelas
  dan fix yang sempit.
- Jangan membuat PR/branch; default-nya commit langsung ke main bila ada izin eksekusi.

FIRST RESPONSE (Indonesian):
CURRENT PROJECT TRUTH
REPOSITORY RECONCILIATION
VERIFIED
UNVERIFIED
KNOWN RISKS
NEXT EXACT QC GATE
WORKFLOW STATUS

Jangan minta user mengulang informasi yang sudah tersedia. Setelah laporan boot,
tunggu perintah selanjutnya.
```
