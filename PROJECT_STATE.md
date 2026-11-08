# JE X FYZ / JE Cooler — Current Project State

Last refreshed: 2026-11-08 (Asia/Jakarta). Current-state summary only; always fetch live main/source, tests, Actions and Release data before acting.

## Agent skills and capability system

- `MASTER_PROMPT.md` remains the single operating authority; `AGENTS.md` is the cross-agent entrypoint and `SKILLS_INDEX.md` maps the reusable skill library.
- Twelve task-specific skills are now present as canonical `.agents/skills/*/SKILL.md` definitions for Codex-compatible discovery and byte-identical `.github/skills/*/SKILL.md` mirrors for GitHub Copilot, including Copilot code-review and product-design quality guidance.
- Skills cover repository forensics, code review, product design/visual quality, Flutter App engineering, Flutter test/regression, BLE P1 audit, ESP32-C3 Firmware safety, OTA/release integrity, GitHub Actions triage, electronics/power/thermal analysis, technical research/Gemini and documentation/memory governance.
- UI work now routes through `product-design-and-visual-quality`, `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md`. These documentation standards do not change UI source or validate/release the pending compact Settings/Connection pass.
- Current ChatGPT mobile/web must fetch/read relevant repository skill files through GitHub tools when needed; do not claim private repo skills are automatically installed in ChatGPT. Gemini still has no GitHub access and is only a manual second-opinion handoff.
- Current container checked 2026-11-07: Python 3 and Git are available; Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF are absent. Re-check tool availability per task. This environment cannot claim local Flutter/Android/Firmware builds or physical-device validation.
## Production and release baseline

- **Protected known production reference:** App Build #124 + Firmware V7.1. Keep this stable reference distinct from newer published artifacts and the exact package installed on the field unit.
- **Latest independently verified published App package (live check 2026-11-06):** Build #129 / [Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), exact tested/package source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`. Latest Release `jexfyz-latest` (ID `403010611`) and tag both target this SHA.
- APK asset `668498025`: 54,751,323 bytes, SHA-256 `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`.
- Matching source ZIP asset `668498026`: 2,878,916 bytes, SHA-256 `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed all 21 workflow gates, 122 Flutter tests, analyzer (25 informational diagnostics), configured Android Gradle gate, APK V1/V2/V3 and expected certificate, corresponding ZIP/source marker, exact Release/tag parity and downloaded asset identity/digest checks. Native Android JUnit tasks were NO-SOURCE.
- Live Actions check on 2026-11-06: latest listed run remains #129; zero in-progress runs, zero queued runs and zero open PRs.
- **Field evidence (USER-REPORTED):** owner previously reported installing/overwriting Build #128. Exact installed APK identity was not independently read; do not assume Build #129 is installed. Firmware V7.1 compile/Online OTA is also USER-REPORTED; exact BIN identity and physical behavior remain UNVERIFIED.

## Current App source and validation

- Localization repair implemented on main: Fan Speed controls now use the full Fan Speed / Kecepatan Kipas label while the fan switch and compact Floating Monitor F metric retain Fan / Kipas. Hotside and Adaptive Mode terminology is standardized; Indonesian Floating Monitor copy uses Monitor Melayang, including native foreground-service notifications. Debug builds assert on missing localization keys/locale entries. Legacy Sisi panas/Peltier re-arm notice text is still accepted for language switching.
- Static dictionary audit confirms 320 entries with both English and Indonesian values and no missing direct production lookup keys. Regression coverage in `test/widget_test.dart` now checks every table entry plus the contextual Fan Speed/Fan distinction and legacy re-localization. Latest App source fix commit: `04716e7eb79774c3b3d9bff6217797a4edacf05c`; final localization coverage-test commit: `b3578e3a2672a93427507814b883d343a0588bd4`.
- Home-equivalent uncapped 360-dp DPI canvas for Settings/subpages, Connection sheet and selected dialogs is validated/released in Build #129.
- The compact Settings/Connection pass remains implemented on `main` but NOT RELEASED. It reduces selected typography/glyph/spacing while preserving the approved 360-dp canvas and DPI formula.
- The follow-up scan-state repair distinguishes active scanning, completed no-result scans, permission requirement, adapter/legacy-location unavailability and scan failure. It uses the plugin's scan lifecycle stream and fresh scan-result stream, with one guarded retry handler. BLE P1 UUIDs, protocol, GATT connection ownership and telemetry semantics are unchanged.
- Regression tests now cover five scan-message mappings and render the opt-in compact theme at 350-dp/420-dp while checking inherited palette preservation. Test source is present; no test has run in this execution environment.
- A subsequent read-only audit found a stale source-string assertion in `test/floating_monitor_layout_contract_test.dart`: it still searches for the removed inline empty-state ternary instead of the current `connectionScanEmptyStateMessageKey(...)` helper call. The source literal is absent, so the assertion is expected to fail if run; this is STATIC SOURCE CHECK, not an executed test result.
- A separate unconfirmed race risk exists between the periodic passive reconnect scanner (2-second scan every 3 seconds) and the 10-second Connection-sheet scanner, because both use the global FlutterBluePlus scanner and no sheet-level pause of rediscovery was observed. No runtime reproduction or dedicated arbitration test exists in the inspected test files; treat this as HYPOTHESIS pending an explicit ownership decision and regression coverage.
- Formatter, targeted localization/scan/compact tests, analyzer, full suite, screenshots and physical-device/OEM QA remain NOT RUN; current container has Git/Python but no Flutter/Dart/Android toolchain. Localization and recent scan/compact source changes are NOT RELEASED. Do not claim runtime validation or release.

## Open design and engineering gaps

- **Next App UI validation:** first, under a separate explicit `Eksekusi Full!`, repair the stale empty-state matcher and resolve passive-reconnect versus Connection-sheet scan ownership, with regression coverage. Recommended default: the manually opened Connection sheet temporarily owns the global BLE scanner and pauses passive rediscovery; resume rediscovery only after sheet close and only while all existing Auto Connect gates remain true. Then, in a Flutter-enabled environment, format changed Dart files; run `connection_scan_state_test.dart`, `floating_monitor_layout_contract_test.dart` and `widget_test.dart`; run `flutter analyze --no-fatal-infos` and the full suite. Review actual outputs; source contracts and test files are not execution evidence.
- After source/test validation, physical-device/OEM layout QA remains necessary when a suitable device is available. A separate explicit `Eksekusi Build App!` is required before packaging the compact pass.
- BLE App-only identity authorization remains BLOCKED / NOT IMPLEMENTED until trusted enrollment/signing backend and Firmware verification exist.
- Rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm remains NOT IMPLEMENTED in Firmware V7.1; do not conflate it with Adaptive Fan tiers or raw-decimal limit safety.
- Exact field BIN-to-source identity, Build #129 installation, physical OTA/reboot/BLE recovery and thermal/electrical behavior remain independently UNVERIFIED.

## Protected contracts

- Preserve Android Gradle versionName `Telegram @horizontalzzz`.
- Preserve BLE P1, authoritative telemetry, session synchronization, radio ownership, Touch synchronization, unknown/disconnected value semantics and persisted schema compatibility.
- Preserve safe outputs, calibrated one-sample-per-second NTC path, cooperative millis() timing, Peltier/selector/rail timing and OTA recovery.
- Online OTA intentionally uses `cloudClient.setInsecure()`; HTTPS server certificate identity is not authenticated. Preserve the allowlist, redirect blocking, response/size/image validation and safe-output/recovery behavior.
- Do not add Firebase firmware hash/signature requirements or a standalone Battery Protection Guard UI without explicit owner approval.
- The sold unit is not available for routine disassembly/repair; do not infer device-operation authorization.