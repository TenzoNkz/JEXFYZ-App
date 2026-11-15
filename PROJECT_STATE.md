# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-15 (Asia/Jakarta). Current truth only. Build history remains in APP_BUILD_REPORT.md and CHANGELOG.md; rolling chat continuation remains in CHAT_TRANSFER.md.

## Repository baseline

- Canonical repository/branch: TenzoNkz/JEXFYZ-App / main.
- Latest App code validation is Validation Only #19: run 43677560315 / job 132700920324, tested source 8fca2ecebf8b2ffb83fc9475a817c832f8269dc5, terminal SUCCESS.
- Current code after formatter follow-up fc39de16a5480347ce13083760424a309957c311 differs from #19 tested workspace only by a formatter-only line wrap in test/localization_contract_test.dart; remaining intervening changes are documentation/checkpoint/skill-mirror records.
- Guarded App Build #163 is active on immutable source 9466e8eeb269da5bc8806f0df1d4212cf24e1746 (run 43679305537 / job 132706236782, Issue #40). Steps 1–13 are SUCCESS; Android Gradle gate step 14 is IN_PROGRESS; gates 15–21 pending. See APP_BUILD_REPORT.md for live gate chronology.

## Latest hosted source validation — Validation Only #19 SUCCESS

- Run/job: 43677560315 / 132700920324; tested source 8fca2ecebf8b2ffb83fc9475a817c832f8269dc5; terminal SUCCESS.
- Flutter 3.47.2 / Dart 3.13.2; locked dependency resolution PASS.
- Formatter checked 18 files, applied one correction, then final check passed with zero remaining changes. Formatter-only follow-up: fc39de16a5480347ce13083760424a309957c311.
- Analyzer: 118 info-level findings, zero warnings/errors.
- Flutter tests: 197/197 passed.
- Run #18 (43677411117) remains a failed historical intermediate (196/197); the stale LED-copy assertion was corrected before #19.

## Localization and state semantics now implemented

- English remains the master and default language. JexText contains 354 bilingual keys with dictionary locale/placeholder and inline placeholder-parity regression checks.
- Thermal Safety uses Keselamatan; successful safety status is Pemeriksaan keselamatan berhasil. Fan-before-cooling copy states its prerequisite; protected sequence remains FAN:ON → successful ACK → PELTIER:ON.
- Adaptive is a logical mode: EN ACTIVE/INACTIVE, ID AKTIF/NONAKTIF. Peltier/Fan/LED are physical outputs: compact EN ON/OFF, ID HIDUP/MATI; natural Indonesian prose uses menyala/mati.
- Fan Speed remains numeric while running and OFF/MATI when stopped. Disconnected/unknown values remain --.
- Usage Statistics distinguishes logical mode from hardware output while preserving voltage/unknown states. OTA mismatch copy labels received bytes first and expected bytes second in event order.

## Latest verified App package — Build #162 SUCCESS / CURRENT RELEASE BASELINE

- Run/job 43430275967 / 131901744336; package source 6854d8eb58a5f077cbc99749a35d37a4f55b8efa.
- Release ID 403010611 and tag jexfyz-latest. APK SHA-256 56c08bd490e52a8616627613675141a91c14ab6893cca0e1e54d5e5ac1a053f2. Source ZIP SHA-256 86bd61edfe59acd6063367f7b8704356d2bf192d8c55c150f0f0e6b6285db42e.
- Build #163 is currently at the Android Gradle gate; Build #162 remains published until full #163 success and downloaded-asset verification are independently confirmed. Owner installation and Android/OEM screenshot acceptance remain VISUAL NOT VERIFIED.

## App architecture and protected contracts

- Usage Statistics uses SQLite schema v2 with v1→v2 migration, 30-day retention, raw 1-Hz Battery/Hotside samples, explicit data gaps, HOT-only P1 freshness, and bounded writer admission. Long-duration CPU/memory and storage-pressure soak remain unverified.
- BLE scan ownership is serialized with attempt-generation invalidation and subscription/timer cleanup. CI/widget tests do not establish OEM/device behavior.
- Preserve Android Gradle versionName "Telegram @horizontalzzz" and Flutter version 1.0.0+3.
- Root analysis_options.yaml activates locked flutter_lints 6.0.0; Validation Only is non-publishing.

## Firmware and security boundary

- Current sketch: firmware/JEXFYZ-V7.2.ino, FW_VERSION="V7.2". App CI does not establish Arduino compile, BIN provenance, Firebase identity, OTA, flash, BLE security or thermal/electrical safety.
- BLE App-only identity authentication remains BLOCKED / NOT IMPLEMENTED. Online OTA uses cloudClient.setInsecure(): transport is encrypted but server certificate identity is not authenticated.
- No Firmware/BIN/Firebase/OTA/flash/device operation was performed for Build #163.

## Chat-load/repository hygiene

- CHAT_TRANSFER.md contains one bounded active checkpoint between explicit markers. Its former 723-line snapshot is preserved in archive/CHAT_TRANSFER_PRE_COMPACTION_2026-11-15.md.
- CHAT_TRANSFER_PROMPTS.md contains exactly two copy-ready prompts; APP_BUILD_REPORT.md, CHANGELOG.md and archive/*.md preserve history.

## Immediate next action

- Continue only Build #163 run 43679305537 / job 132706236782. Inspect actual steps/logs, append transitions and preserve every gate. No duplicate trigger.
- Firmware compile/BIN/Firebase/OTA/flash/device operations remain separately gated.
