## AUTHORIZED V6.2 OTA EXCEPTION — 2026-10-13

- Online OTA was explicitly approved for standard CA certificate verification to the already allowlisted GitHub raw BIN repository. The allowlist and existing download/update steps remain in place.
- Local OTA is explicitly unchanged: no checksum, signature, or additional verification layer was added.
- BLE write encryption/bonding was added because Online OTA credentials travel over the BLE command channel.
- V6.2 OTA paths remain uncompiled and untested on hardware. No APK build, Firmware compile, BIN, flashing or OTA operation was performed.
- This exception authorizes only the discussed Online HTTPS and BLE write protections; it does not grant broader OTA redesign.

# JE X FYZ — OTA PROTECTION

> 🔐 **OTA PROTECTED / FROZEN**

Dokumen ini adalah **segel pengingat engineering** untuk jalur OTA JE X FYZ.
Tujuannya mencegah perubahan OTA secara tidak sengaja saat kita memperbaiki fitur lain.

## 🚫 Jangan ubah sembarangan

Bagian berikut dianggap **protected**:

- Local OTA
- Online OTA
- OTA state machine
- OTA priority / lifecycle
- Wi-Fi ↔ BLE radio handoff
- OTA recovery setelah gagal
- OTA safety output
- OTA timeout dan retry logic
- Image validation
- Firmware OTA URL/path contract
- App OTA version-selection contract

**Jangan melakukan refactor, cleanup, optimasi, atau perubahan kecil pada OTA hanya karena sedang mengerjakan fitur lain.**

## ✅ Perubahan OTA hanya jika

1. Ada bug OTA yang benar-benar terbukti.
2. Root cause sudah jelas.
3. Perubahan dibahas dan disetujui secara eksplisit.
4. Setelah perubahan, seluruh jalur OTA diaudit ulang.

## 📌 Kontrak versi

**ANTI-DOWNGRADE: OFF**

Versi firmware yang **valid dan berbeda** dari versi perangkat boleh di-update.

Contoh:

- V5.7 → V5.8 ✅
- V5.7 → V5.6 ✅
- V5.7 → V6.0 ✅
- V5.7 → V5.7 ❌ tidak perlu update

Jadi segel ini **tidak** mengubah kebijakan versi OTA.

## 🔒 Kondisi baseline

OTA V5.7 sudah berhasil digunakan untuk memperbarui hardware sebelum QC V5.8.
Active source saat ini adalah V6.1, tetapi source-only: belum dikompilasi, dibuat BIN, diflash, atau divalidasi pada hardware:

`firmware/JEXFYZ-V6.1.ino`

Keberhasilan OTA V5.7 adalah bukti historis untuk V5.7 saja, bukan bukti OTA V6.1.

Dokumen ini **bukan** cryptographic signature, bukan CI enforcement, dan bukan pengganti pengujian OTA pada hardware.

### Prinsip utama

> **OTA sudah bekerja — jangan disentuh kecuali ada alasan OTA yang nyata.**
