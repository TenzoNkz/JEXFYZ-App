# JE X FYZ / JE Cooler — Current Project State

Last refreshed: 2026-11-09 (Asia/Jakarta). Current-state summary only; always fetch live main/source, tests, Actions and Release data before acting.

## Home Light Mode indicator and NOTIFY repair — source changed / validation blocked (2026-11-09)

- **Mode:** `@Pikirkan Eksekusi Full!` / scoped `Eksekusi Full!`. **Result:** App source and regression-test source are committed to `main`; the requested presentation repair is SOURCE IMPLEMENTED / NOT RUN and is NOT RELEASED.
- **Changed files:** `lib/main.dart` (latest source blob `0d90b418c9140cfbb6090f2723ab24c8fbd5e9fc`) and `test/widget_test.dart` (latest test blob `9d348949091603c444a8339571b49cf7b5697a7e`). Latest main App-source commit: `ab833650ff14f9d3b2ea0c7048902826693a57b6`; latest test-fixture change: `66bb5008398b6e2b79aec276018ede9c391a8f75`. The latest test fixture uses the actual `.07` success/warning NOTIFY tint alpha. Later commits in this task record current-state documentation.
- **Implementation:** Home painter accepts theme brightness/surface/outline, keeps Dark Mode's original paint fallback, and uses theme-aware depth/cavity paint for Battery, Hotside, Voltage, Adaptive, Peltier, Fan and Fan Speed. Theme palette differences invalidate the painter. Home metric values use a Light Mode HSL contrast search targeting >=4.5:1; Dark Mode keeps original semantic accents. NOTIFY uses separate Light Mode success/warning/error foregrounds while retaining status tints, original state predicates, localized message priority, dark body copy and 44 dp left-layout.
- **Regression source:** added tests for theme propagation/repaint, Light/Dark painter treatment including Adaptive/Hotside, semantic metric accent contrast, composited NOTIFY status tint contrast and Dark Mode foreground preservation. Existing painter/NOTIFY layout and state-contract assertions were adapted, not weakened.
- **Static checks:** GitHub read-back verified both changed Dart files. A lexical delimiter scan reported balanced delimiters for each file. Static painter audit found no remaining direct near-black paint expressions; the original dark colors remain only as arguments for the Dark Mode fallback. **These are STATIC SOURCE CHECKS only.**
- **Validation blocker:** this runtime was rechecked and `flutter`, `dart`, `gradle` and `adb` are all NOT FOUND. Formatter, focused widget tests, full Flutter tests and `flutter analyze` are BLOCKED / NOT RUN. No test success is claimed.
- **Visual/field status:** no actual screenshots were captured or inspected. `VISUAL NOT VERIFIED`. Required matrix: Home at 350-dp and 420-dp; Light/Dark; EN/ID; every indicator normal/warning/unknown and voltage state; NOTIFY success/warning/error with short and two-line copy. OEM/device rendering is UNVERIFIED.
- **Release baseline:** Build #131 / run `42474266430`, packaged source `b3c4fee432fddc49430840daeb1e2eecbe78a0db`, remains latest verified App release. This new source is NOT RELEASED. No Build App, APK, Release, Firmware, BIN, Firebase, OTA, flash or device operation was performed.
- **Next exact action:** validate with Flutter 3.47.2 in a toolchain-enabled environment: `dart format`, focused new/affected widget tests, full `flutter test`, then `flutter analyze --no-fatal-infos`. Resolve any findings in a separately authorized Full task. After source validation, real screenshot review is still needed; App packaging requires separate `Eksekusi Build App!`.

## Agent skills and capability system

- `MASTER_PROMPT.md` remains the single operating authority; `AGENTS.md` is the cross-agent entrypoint and `SKILLS_INDEX.md` maps the reusable skill library.
- Twelve task-specific skills are now present as canonical `.agents/skills/*/SKILL.md` definitions for Codex-compatible discovery and byte-identical `.github/skills/*/SKILL.md` mirrors for GitHub Copilot, including Copilot code-review and product-design quality guidance.
- Skills cover repository forensics, code review, product design/visual quality, Flutter App engineering, Flutter test/regression, BLE P1 audit, ESP32-C3 Firmware safety, OTA/release integrity, GitHub Actions triage, electronics/power/thermal analysis, technical research/Gemini and documentation/memory governance.
- UI work now routes through `product-design-and-visual-quality`, `PRODUCT_DESIGN_CONSTITUTION.md` and `VISUAL_QUALITY_GATE.md`. These documentation standards do not change UI source or validate/release the pending compact Settings/Connection pass.
- Current ChatGPT mobile/web must fetch/read relevant repository skill files through GitHub tools when needed; do not claim private repo skills are automatically installed in ChatGPT. Gemini still has no GitHub access and is only a manual second-opinion handoff.
- Current container checked 2026-11-07: Python 3 and Git are available; Flutter, Dart, Gradle, ADB, Arduino CLI and ESP-IDF are absent. Re-check tool availability per task. This environment cannot claim local Flutter/Android/Firmware builds or physical-device validation.
## Production and release baseline

- **Protected known production reference:** App Build #124 + Firmware V7.1. Keep this stable reference distinct from newer published artifacts and the exact package installed on the field unit.
- **Latest independently verified published App package:** Build #131 / [Actions run 42474266430](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42474266430), exact tested/package source `b3c4fee432fddc49430840daeb1e2eecbe78a0db`. Release `jexfyz-latest` (ID `403010611`) and live tag both target this SHA.
- APK asset `723696457`: 54,849,627 bytes, SHA-256 `d614bc42c6270fa3de616d944d043fc833cd0ab0ffc391d89526627606c3ee35`.
- Matching source ZIP asset `723696458`: 2,888,040 bytes, SHA-256 `cca5609e5a471f204118f2bdfc40e6aa0fa7dcb6dc151a4b306e6c9ca4615177`.
- Build #131 passed all 21 main workflow steps, 142 Flutter tests, analyzer (25 info-level diagnostics), the configured Android Gradle gate, obfuscated APK build, V1/V2/V3 and expected production-certificate checks, matching ZIP/source marker, exact Release/tag parity, and downloaded-asset checksum/identity/signature verification.
- Android `:app:testDebugUnitTest` Gradle gate completed successfully (`BUILD SUCCESSFUL`), but `:app:compileDebugUnitTestKotlin`, `:app:compileDebugUnitTestJavaWithJavac`, `:app:processDebugUnitTestJavaRes` and `:app:testDebugUnitTest` were `NO-SOURCE`; no native Android JUnit case executed.
- Latest live Actions query after completion: Build #131 terminal `success`; zero active, queued or waiting runs for this workflow.
- **Field evidence (USER-REPORTED / UNVERIFIED):** owner previously reported installing/overwriting Build #128. Exact installed APK identity has not been independently read; do not assume Build #131 is installed. Firmware V7.1 compile/Online OTA remains USER-REPORTED; exact BIN identity and physical behavior remain unverified.



## Current App source and validation

- Localization repair is included in Build #131: Home Fan Speed uses the full Fan Speed / Kecepatan Kipas label with the captured locale, while the fan switch and compact Floating Monitor F metric retain Fan / Kipas. Hotside and Adaptive Mode terminology is standardized; Indonesian Floating Monitor copy uses Monitor Melayang, including native foreground-service notifications. Debug builds assert on missing localization keys/locale entries.
- Static dictionary audit confirms 320 entries with both English and Indonesian values and no missing direct production lookup keys. Regression coverage checks the full table, contextual Fan Speed/Fan distinction and legacy re-localization.
- Home-equivalent uncapped 360-dp DPI canvas for Settings/subpages, Connection sheet and selected dialogs remains validated/released from Build #129. The later compact Settings/Connection typography/spacing pass is now included in Build #131.
- Compact UI regression coverage checks the opt-in compact theme and inherited palette at 350-dp/420-dp widths. Hosted Flutter suite passed 142/142; this is widget/test evidence, not screenshot review or physical OEM validation.
- Bluetooth scan-state presentation distinguishes active scanning, completed no-result scans, permission requirements, adapter/legacy-location unavailability and scan failures with localized copy and guarded retry.
- `ConnectionScanCoordinator` now arbitrates passive/manual/one-shot scanner ownership, generation-based invalidation, FIFO scanner start/stop operations, a full passive scan lifetime lease, and a selected-device handoff fence until `_bleConnecting` is assigned. Primary/fallback discovery uses fresh `onScanResults`; known-remote-ID fallback remains for ESP32-C3 advertisements without the service UUID.
- The complete hosted Flutter suite in Build #131 passed 142 tests, including scanner-coordinator and source/widget regression coverage. Analyzer passed with 25 info-level diagnostics. The Android Gradle gate succeeded but native Android JUnit tasks were `NO-SOURCE`.
- Exact packaged source is `b3c4fee432fddc49430840daeb1e2eecbe78a0db`; Build #131 run 42474266430 released it. Later main commits in the current checkpoint are documentation-only and do not change that packaged source.
- Local `dart format` was not run because the current environment lacks Dart; the guarded workflow has no formatter step. No screenshot/OEM visual QA or real-device BLE lifecycle test has been performed.
- Build #131 installation on the owner's phone remains unconfirmed. The hosted App build does not establish physical BLE, overlay, cooling, thermal, Firmware, BIN, Firebase or OTA behavior.



## Open design and engineering gaps

- **Physical App acceptance remains pending:** after the owner installs Build #131, inspect Settings and Bluetooth Connection at 350-dp/420-dp, English/Indonesian and Light/Dark themes; compare screenshots against the approved Home-equivalent 360-dp canvas and compact typography contract.
- **BLE runtime acceptance remains pending:** verify passive rediscovery, pending-prerequisite cancellation, manual-sheet pre-emption and neutral dismissal, selected-device handoff, fresh primary/fallback advertisement handling, adapter loss and reconnect behavior on the actual phone/cooler. The 142 passing Flutter tests are automated tests, not a physical radio session.
- Exact Build #131 installation on the field unit, Firmware V7.1 source-to-BIN identity, physical OTA/reboot/BLE recovery and thermal/electrical behavior remain independently UNVERIFIED.
- BLE App-only identity authorization remains BLOCKED / NOT IMPLEMENTED until trusted enrollment/signing backend and Firmware verification exist.
- Rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm remains NOT IMPLEMENTED in Firmware V7.1; do not conflate it with Adaptive Fan tiers or ordinary Hotside-limit protection.



## Protected contracts

- Preserve Android Gradle versionName `Telegram @horizontalzzz`.
- Preserve BLE P1, authoritative telemetry, session synchronization, radio ownership, Touch synchronization, unknown/disconnected value semantics and persisted schema compatibility.
- Preserve safe outputs, calibrated one-sample-per-second NTC path, cooperative millis() timing, Peltier/selector/rail timing and OTA recovery.
- Online OTA intentionally uses `cloudClient.setInsecure()`; HTTPS server certificate identity is not authenticated. Preserve the allowlist, redirect blocking, response/size/image validation and safe-output/recovery behavior.
- Do not add Firebase firmware hash/signature requirements or a standalone Battery Protection Guard UI without explicit owner approval.
- The sold unit is not available for routine disassembly/repair; do not infer device-operation authorization.