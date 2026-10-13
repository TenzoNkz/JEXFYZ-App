## CURRENT V6.3 EXECUTION STATUS — 2026-10-13

- [CURRENT TRUTH] Active Firmware source: `firmware/JEXFYZ-V6.3.ino`, blob `c2909e5ad4046596618175352934f89815f3e44c`; V6.2 was retired from the active tree. App source remains `lib/main.dart`, version `1.0.0+3`.
- [FIXED] The manual Peltier safety latch now remains blocking until `enforceSafety()` observes Hotside at or below `hotLimit - 1°C` for five continuous seconds. One low sample can no longer bypass re-arm stability.
- [PRESERVED] Adaptive thermal protection remains 30 seconds at 12 V, 9 V and 5 V, with Peltier OFF and Fan 100%. Five-second stable thermal recovery before the deadline cancels the timer; otherwise 12 V/9 V steps down and unrecovered 5 V enters terminal manual-restart lock. Thermal voltage restoration remains one step after each 60-second stable interval, bounded by the saved pre-downshift ceiling.
- [CURRENT TRUTH] `pubspec.lock` is committed (blob `1e92812bfda2c28244a0556d71d1ec94084acc66`) and `.gitignore` is present. Earlier V6.2 notes about a missing lockfile are historical.
- [TEST EVIDENCE — V6.2 CANDIDATE] GitHub Actions run 38362882150 recorded 45 passing Flutter tests. Its plain `flutter analyze` exited nonzero because 23 info-level deprecation notices were treated as fatal; the existing App release workflow uses `flutter analyze --no-fatal-infos`. This evidence predates the V6.3 latch patch and does not certify V6.3.
- [UNVERIFIED] The added V6.3 latch regression has not been run. No V6.3 Firmware compile, BIN, flash, hardware, Android BLE pairing, or OTA regression has been performed. No APK Build was run.
- [NOT RELEASED] V6.3 remains source-only DEVELOPMENT + QC / PRE-RELEASE. Production firmware repository and Firebase release metadata were not changed.

## HISTORICAL V6.2 OTA EXCEPTION — 2026-10-13

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

OTA V5.7 berhasil digunakan untuk memperbarui hardware pada tahap historis sebelumnya.
Active source saat ini adalah V6.2 dan tetap source-only: belum dikompilasi, dibuat BIN, diflash, atau divalidasi pada hardware:

`firmware/JEXFYZ-V6.2.ino`

Keberhasilan OTA V5.7 adalah bukti historis untuk V5.7 saja, bukan bukti bahwa OTA V6.2 telah lulus hardware validation.

Dokumen ini **bukan** cryptographic signature, bukan CI enforcement, dan bukan pengganti pengujian OTA pada hardware.

### Prinsip utama

> **OTA sudah bekerja — jangan disentuh kecuali ada alasan OTA yang nyata.**

## Online OTA TLS clock validation — 2026-10-13

- V6.2 Online OTA synchronizes system time before TLS validation and fails safely if the clock does not become valid within 20 seconds.
- Redirects are disabled for the direct raw GitHub BIN endpoint; CA validation remains enabled, after NTP time is synchronized (20-second deadline).
- Repository allowlist remains limited to `TenzoNkz/JEXFYZ-Firmware`; no custom firmware SHA/signature is added; Local OTA remains unchanged.
- The unapproved temporary quality workflow was removed after it failed to push a generated lockfile; test/analyze steps were skipped and no lockfile was committed.
