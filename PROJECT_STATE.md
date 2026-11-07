# JE X FYZ / JE Cooler — Current Project State

Last refreshed: 2026-11-07 (Asia/Jakarta). Current-state summary only; always fetch live main/source, tests, Actions and Release data before acting.

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

- Home-equivalent uncapped 360-dp DPI canvas for Settings/subpages, Connection sheet and selected dialogs is validated/released in Build #129.
- The later compact Settings/Connection UI pass is committed on main but NOT RELEASED. It reduces Settings typography/glyphs/spacing and Connection header/status/empty-state sizes while preserving the 360-dp canvas, DPI formula, BLE behavior, localization, colors and 40–42 dp tap targets. Relevant source commits: `5ab14e258a9e21bfec486e3c6a3d81d6705c6d0f`, `bfdcafd1ad044974935b4e473d68f2096a297fbf`, `415d240db3cd9b3e2bca3ef760c4ba667459c604`, `f5bf63b0f5c8a837f47617b77e85d8dce93d845c`, `9db9ee3fc453f537ceaca88462b02e36318a487e`.
- Five stale Settings route expectations in `test/floating_monitor_layout_contract_test.dart` were corrected in commit `c37aea44abeb832987e13a1c74701d415e85a737` to include `compactUi: true` for Language, Appearance, Notifications, Bluetooth and Floating Settings. Static comparison confirms each expected substring occurs once in source and test, with the old strings absent. This is STATIC SOURCE CHECK only.
- Compact-pass formatter, targeted Flutter test, analyzer, full Flutter suite and physical-device/OEM QA have NOT RUN. The previous execution environment had no Flutter/Dart executable. Do not claim the compact pass is runtime-validated.

## Open design and engineering gaps

- **Next App UI validation:** in a Flutter-enabled environment run `dart format lib/app_settings.dart lib/floating_monitor.dart lib/main.dart test/floating_monitor_layout_contract_test.dart`, `flutter test test/floating_monitor_layout_contract_test.dart`, `flutter analyze --no-fatal-infos` and the full `flutter test` suite. Review actual output; static string matching is not a test pass.
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