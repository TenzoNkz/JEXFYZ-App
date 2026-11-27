# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Immediate next action — WP1 secure-storage failure tests

- Owner instruction 2026-11-27: stop using Copilot; return to full ChatGPT/Codex-only CODE_FULL execution. ChatGPT/Codex is the sole implementation author and reviewer, writing scoped App changes directly to `main` with the connected GitHub integration. No Copilot assignments, external agents, feature branches or PR handoffs.
- Pre-write gate: re-fetch exact `main` HEAD and target file blob SHA; verify only the approved WP1 paths will change; preserve current source behavior unless a test demonstrates a defect; inspect complete diff before commit; read back changed files and commit afterward.
- Live repo facts at last check: `TenzoNkz/JEXFYZ-App` public; connected identity has admin permission; only `main` branch; branch API reports `protected=false`; `allow_auto_merge=false`. Recheck live state before consequential writes.
- Validation Only workflow: `.github/workflows/jexfyz-app-validation.yml`. It triggers on push to `main` for selected App/config/assets paths and runs read-only dependency, formatter, analyzer and full Flutter tests. Inspect the actual workflow and every run/job on the exact changed SHA. Build App remains separately issue/title/token guarded and is not authorized here.
- WP1 allowed modifications: `lib/app_settings.dart` and `test/app_settings_store_test.dart` only. Inspect `app_bootstrap.dart`, `main.dart`, `settings_pages.dart`, `app_settings_model_test.dart` and `pubspec.lock` without modifying them absent a demonstrated dependency.
- Current WP1 source preserves keys `jexfyz_app_settings_v2`, `jexfyz_last_firmware_notice`, `jexfyz_known_cooler_remote_id_v1`; defaults, JSON schema, notifier update order, bootstrap sequencing and GATT discovery + SYNC + SYNC_READY gate before KnownCooler save.
- Resolved `flutter_secure_storage` is 11.2.0. `FlutterSecureStorage.setMockInitialValues(values)` installs its in-memory platform using the supplied backing Map. A test-only `MapBase<String,String>` can deterministically throw on map read/write/remove and inject plugin storage failures without a new package or production test seam.
- Required tests: AppSettingsStore.load read failure→defaults + all notifiers; save write failure→does not escape + notifiers published before write; shouldNotifyFirmware blank→false and read failure→true; markFirmwareNotified write failure→does not escape; KnownCoolerStore.load read failure→null + notifier cleared; KnownCoolerStore.save write failure→does not escape + notifier semantics; KnownCoolerStore.clear delete failure→does not escape + notifier semantics.
- Last validated App source `d0ab20533c2bf27be18dbb25c3ad9c762663d7e0`; Validation Only #213 / run `46012060878` / job `140549796007`, exact SHA, terminal SUCCESS (formatter 44 files unchanged, analyzer PASS, 285/285 tests PASS). This does not validate later commits.
- Local Flutter/Dart/Gradle/ADB were unavailable previously; check the current runtime. Android/Kotlin/device/OEM/screenshots/SQLite runtime migration/performance soak remain unverified. Build #167 remains latest published package; current main is not packaged.

## Protected scope

No Build App/APK/sign/release, Firmware/BIN, BLE/P1 wire/security, OTA transport/trust/recovery, Firebase production, signing secrets, flashing or device operations. Visual outcome remains NOT VERIFIED until actual rendered Android evidence exists.