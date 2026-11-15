# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-15 (Asia/Jakarta). Current truth only. Build history remains in APP_BUILD_REPORT.md and CHANGELOG.md; rolling chat continuation remains in CHAT_TRANSFER.md.

## Repository baseline

- Canonical repository/branch: TenzoNkz/JEXFYZ-App / main.
- Latest validated App source: fc39de16a5480347ce13083760424a309957c311. Recursive tree is not truncated.
- Twelve canonical .agents/skills and twelve .github/skills are mirrored byte-for-byte. Guarded App release and non-publishing Validation Only workflows remain separate.
- Root analysis_options.yaml enables locked flutter_lints 6.0.0.

## Latest hosted source validation — Validation Only #19 SUCCESS

- Run/job: 43677560315 / 132700920324; tested source 8fca2ecebf8b2ffb83fc9475a817c832f8269dc5; terminal SUCCESS.
- Flutter 3.47.2 / Dart 3.13.2; locked dependency resolution PASS.
- Formatter checked 18 files, applied one correction, then final check passed with zero remaining changes. Formatter-only follow-up: fc39de16a5480347ce13083760424a309957c311.
- Analyzer: 118 info-level findings, zero warnings/errors.
- Flutter tests: 197/197 passed.
- Run #18 (43677411117) is preserved as a failed historical attempt (196/197) caused by one stale LED-copy expectation. The assertion was corrected before #19; do not rewrite #18 as success.

## Localization and state semantics now implemented

- English remains the master and default language. The JexText table has 354 bilingual keys. Tests check both locale entries and matching placeholder sets; literal inline bilingual phrases have placeholder-parity coverage.
- Thermal Safety is Keselamatan. Successful safety status is Pemeriksaan keselamatan berhasil. Fan-before-cooling title/body now state the prerequisite explicitly. The protected sequence remains FAN:ON → successful ACK → PELTIER:ON.
- Adaptive is a logical mode: EN ACTIVE/INACTIVE, ID AKTIF/NONAKTIF.
- Peltier/Fan/LED are physical outputs: compact EN ON/OFF, ID HIDUP/MATI; natural Indonesian prose uses menyala/mati.
- Fan Speed remains numeric while running and OFF/MATI when stopped. Disconnected/unknown values remain --.
- Usage Statistics distinguishes UsageStateDomain.logicalMode from hardwareOutput while preserving voltage and unknown states.
- OTA mismatch copy labels received bytes first and expected bytes second, matching Firmware event order. JexText.format resolves named bilingual placeholders.
- Preserve language labels English / Indonesia and enum/storage identifiers english / indonesia. Preserve Floating Monitor / Monitor Melayang, Bluetooth notification copy, and About credit App Developer & Builder / Pengembang Aplikasi & Perakit.

## Latest verified App package — Build #162 SUCCESS

- Run/job 43430275967 / 131901744336; package source 6854d8eb58a5f077cbc99749a35d37a4f55b8efa.
- Release ID 403010611 and tag jexfyz-latest. APK SHA-256 56c08bd490e52a8616627613675141a91c14ab6893cca0e1e54d5e5ac1a053f2. Source ZIP SHA-256 86bd61edfe59acd6063367f7b8704356d2bf192d8c55c150f0f0e6b6285db42e.
- New localization/state changes are NOT RELEASED in Build #162. Owner installation is not independently confirmed. Android/OEM screenshot acceptance remains VISUAL NOT VERIFIED.

## App architecture and protected contracts

- Usage Statistics uses SQLite schema v2 with v1→v2 migration, 30-day retention, raw 1-Hz Battery/Hotside samples, explicit data gaps, HOT-only P1 freshness, and bounded writer admission (64 normal + 8 reserved + 1 critical endSession slot). Long-duration CPU/memory and storage-pressure soak remain unverified.
- BLE scan ownership is serialized with attempt-generation invalidation and subscription/timer cleanup. CI/widget tests do not establish OEM/device behavior.
- Preserve Android Gradle versionName "Telegram @horizontalzzz" and Flutter version 1.0.0+3.
- Root analysis_options.yaml activates flutter_lints 6.0.0; Validation Only is non-publishing.

## Firmware and security boundary

- Current sketch: firmware/JEXFYZ-V7.2.ino, FW_VERSION="V7.2". App CI does not establish Arduino compile, BIN provenance, Firebase identity, OTA, flash, BLE security or thermal/electrical safety.
- BLE App-only identity authentication remains BLOCKED / NOT IMPLEMENTED. Online OTA uses cloudClient.setInsecure(): transport is encrypted but server certificate identity is not authenticated. Preserve protected OTA allow-list/recovery contracts.
- No Firmware/BIN/Firebase/OTA/flash/device operation was performed for the localization or repository-cleanup work.

## Chat-load/repository hygiene

- CHAT_TRANSFER.md contains one bounded active checkpoint between explicit markers. Its former 723-line snapshot is preserved in archive/CHAT_TRANSFER_PRE_COMPACTION_2026-11-15.md.
- CHAT_TRANSFER_PROMPTS.md contains exactly two copy-ready prompts. README, MASTER_PROMPT, MEMORY_INDEX and relevant skills direct routine continuation to the bounded checkpoint only.
- APP_BUILD_REPORT.md, CHANGELOG.md and archive/*.md remain retained history; they are not loaded wholesale during normal chat transfer.

## Immediate next action

- Source/test work and Validation Only #19 are complete. A separate explicit owner command Eksekusi Build App! is required for guarded App packaging/QC; it has not been authorized.
- Firmware compile/BIN/Firebase/OTA/flash/device operations remain separately gated.
