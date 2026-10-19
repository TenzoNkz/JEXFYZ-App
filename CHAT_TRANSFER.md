# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after the Home STATUS / NOTIFY localization and OTA summary sanitization source follow-up on 2026-10-19 (Asia/Jakarta). This is the canonical boot snapshot. The pre-transfer HEAD/tree below describes live main immediately before this final transfer write. This file is written last and does not self-reference its future commit/blob; fetch final HEAD/tree/blob after committing.

## 1. Authority, repository roles and command protocol

- Canonical editable repository: TenzoNkz/JEXFYZ-App, branch main. Continue directly on main; do not create branches/PRs unless explicitly requested.
- Pre-transfer HEAD: 40e27083a61b0d2ea56a55f66347ed8c9791ac08. Parent: 3339267b8d8b0d04a18fd2083a8951bc38060a93. Tree: 9c6be05ae94e504375c89b0b0b3270286484bca3.
- Artifact-only repository: TenzoNkz/JEXFYZ-Firmware must contain exactly JEXFYZ.cpp.bin. Last inspected blob dca6a1267762152519f6d2889e4f0adf46fd8803, 1,457,008 bytes. Only tree metadata was inspected; the payload was not read and source-to-BIN provenance is UNVERIFIED.
- Commands: @Thinking Diskusi! is read-only; @Thinking Eksekusi Full! permits scoped App source/tests/docs/audit/commit but not App Build/Firmware/device actions; @Thinking Eksekusi Build App! alone authorizes the official App build/QC/release pipeline; @Thinking Chat Stuck! recovers the authorized task without widening scope. Retired aliases: @Thinking Build App!, @Thinking Eksekusi & Build App!, and standalone @Thinking Eksekusi!.
- Build workflow remains .github/workflows/jexfyz-app-build-trigger.yml, blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12. It is guarded to issues.opened/reopened with repository owner/title/body token only. No push/PR/manual bypass.
- Preserve Android Gradle versionName "Telegram @horizontalzzz". User compiles Firmware. No firmware, BIN, Firebase, OTA, flash, or physical-device operations are authorized under Eksekusi Full.
- Current task scope is Home STATUS / NOTIFY wording/localization, including concise bilingual OTA outcome summaries that hide raw ERROR/CODE/event identifiers. Code and tests are committed after Build #100; tests/analyzer/build are NOT RUN for this follow-up. Build #100 remains the latest successful release.

## 2. Latest verified App release

- Latest successful released artifact: Build #100 / Actions run 39237262140, exact packaged source commit 51bea70b2ca17f285bf35c3e547dc44c70f26d59.
- All 21 workflow steps passed. Analyzer exited 0 with 25 info-level findings and no errors/warnings. Flutter test result: 103/103 passed. APK signature/certificate, corresponding source ZIP, downloaded asset digests, and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- APK asset 655957943, 54,718,555 bytes, SHA-256 a59c0a37b2025ad2b250bd4354b887379d96658e9f7757692691fa23b7b4d0a2.
- Corresponding source ZIP asset 655957946, 2,862,476 bytes, SHA-256 e60c4705097009d843b624bf8f0f989770a76aba6fdfbdd8d2159d77f98890f1.
- Release jexfyz-latest and Release metadata match Build #100 source 51bea70b2ca17f285bf35c3e547dc44c70f26d59. Do not manually move the tag.

## 3. Current post-Build-#100 STATUS / NOTIFY copy and OTA diagnostic sanitization — NOT RUN / NOT RELEASED

- Current source: lib/main.dart blob 51b52042b6429ae2e4a4f2508685cd8326af68c8.
- Localization table: lib/app_settings.dart blob e91ecd2a00eafdec3f681daabb74fd49fcd25bf2.
- Regression tests: test/widget_test.dart blob 9d80171a12af084748b88fcdd06d3d6b3cf65e1f.
- The screenshot's raw message “The device did not confirm the Peltier change. PELTIER_SAFETY_LATCH” is addressed by central localized reason mapping and removal of raw code concatenation. Known safety tokens map to clear English/Indonesian instructions; unknown underscore tokens use generic localized copy or are removed. Raw tokens remain diagnostic-only.
- Peltier safety re-arm wording now explains the threshold/action in concise localized text without changing the existing threshold formula or firmware predicate.
- Home category labels are short: STATUS / STATUS, CONNECTION / KONEKSI, SYNC / SINKRONISASI, WARNING / PERINGATAN, ERROR / ERROR.
- Common unconfirmed-command/failure text is normalized by action and language. The error badge also recognizes unconfirmed outcomes in English and Indonesian. OTA failure cards omit raw ERROR/CODE fields, numeric firmware return codes, internal event suffixes, and unknown OTA mode identifiers. Known localized stage, safe version, and valid progress can remain when useful.
- Regression assertions cover Peltier latch text in both languages, voltage-failure copy, known/unknown reason tokens, concise labels, command-confirmation errors, and English/Indonesian OTA summary formatting without raw diagnostics.
- This source/test update is newer than Build #100. Tests and analyzer are NOT RUN; the new text behavior is NOT RELEASED/NOT in the APK. Existing Build #100 remains the latest successful artifact.

## 3. Current post-Build-#99 icon-state redraw — NOT RUN / NOT RELEASED

- New source: lib/main.dart blob 6a008c5c3e5ba7118e948e0b1f36277c01e73529.
- New regression test source: test/widget_test.dart blob 94dad7a7506fbcbeea63f300ea25b7f32299d471.
- This source update reworks the static/idle/disconnected appearance of all seven indicators. It is newer than Build #99 and is not packaged in the current APK/source ZIP. Tests and analyzer have NOT RUN for these newer source/test blobs.
- Battery: recessed dark inner window with a small neutral thermal emblem when the value is unknown; never fabricate a live numeric fill. Valid reading and falling-fire behavior keep existing telemetry/warning gates.
- Hotside: complete tube/bulb silhouette, recessed tube, fixed graduations and bulb bezel in idle/unknown state; live temperature column only when data is valid.
- Voltage: shadowed/inset bolt face and static inner luminous core; travelling current and branch strikes remain state-gated; semantic colours remain 5V red, 9V green, 12V blue.
- Adaptive: stronger two-arrow circular mark with a recessed orbit track; arrows move only under the existing authoritative ON gate; no idle spinner.
- Peltier: stronger beveled six-arm snowflake/crystal with faceted centre; falling flakes are not drawn as frozen stray particles when the existing active-state gate is false.
- Fan: exactly three swept blades, three fixed airflow ribbons, recessed bearing ring, per-blade highlights and layered hub. Existing voltage/PWM policy and phase-continuous retargeting are preserved.
- Fan Speed: semicircle with recessed bezel, 11 graded scale ticks and layered pivot. Needle remains hidden when PWM/value is unknown, expired, or disconnected.
- The redesign does not change BLE protocol/telemetry, warning predicates, voltage/PWM mapping, Adaptive controls, RGB, safety behavior, Home card/tile layout, or Floating Monitor. Floating Monitor stays letters-only B/H/V/A/P/F, with F = Fan Speed. Unknown state must never be fabricated as zero/OFF/active.

## 4. Icon motion and static-state source validated by Build #100

- Build #99 validated the smoothness source: phase-periodic falling particles and boundary fades, 26 dp Home glyph, Peltier crystal motion decoupled from snowfall, and Fan angular velocity with integrated smoothstep and accumulated-phase preservation.
- Build #100 validated the static/unknown-state icon redraw against source main.dart blob 6a008c5c3e5ba7118e948e0b1f36277c01e73529 and test/widget_test.dart blob 94dad7a7506fbcbeea63f300ea25b7f32299d471 with 103/103 Flutter tests.
- Seven static icon poses have stronger definition for OFF/unknown data; Fan retains exactly three blades and three fixed airflow ribbons; Fan Speed needle remains hidden for unknown PWM. This note does not claim real-device animation smoothness.
- The current Notify copy follow-up is separate from those releases; it has not been tested or packaged.
- Real-device appearance, frame timing, BLE/PWM runtime and physical cooling/safety remain UNVERIFIED.

## 5. Source and canonical documentation hashes immediately before this transfer write

- lib/main.dart: 51b52042b6429ae2e4a4f2508685cd8326af68c8
- lib/app_settings.dart: e91ecd2a00eafdec3f681daabb74fd49fcd25bf2
- test/widget_test.dart: 9d80171a12af084748b88fcdd06d3d6b3cf65e1f
- DESIGN_NOTES.md: 92bc43fdc12c1ef9c48f36992debc9e709fc2a52
- APP_NOTES.md: d2af8f5cb88892662fc0b583e44b735bbeab8b96
- PROJECT_STATE.md: 8eab17d0c508b7b568a4827d4a7221f9114d1062
- MEMORY_INDEX.md: 230808b2d538a51bbb8be5249b4e6f13477191eb
- HANDOVER.md: e463d46b10e3efc2656029f9608f68778ad8bf01
- BUILD_NOTES.md: 0635faeb83aade3adf37e2a8643c0b8141718d08
- APP_BUILD_REPORT.md: a41c80e95ef7e35977d7c2592051299bf1084bd9
- CHANGELOG.md: b88780138a1f23e47b9062f3ea14cffe37834eb3
- README.md: a68b24c4cda137901193644b7f6ff1173ac15f4d
- CHAT_RULES.md: 60ea9d84e09d887cf83a079384dea4c3026c14e5
- Build workflow: 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12
- This transfer blob intentionally is not listed because its future blob SHA cannot be self-referenced.

## 6. Exact next actions and validation gates

1. Re-fetch live main HEAD/tree and source/test/document hashes before the next action.
2. The current STATUS/NOTIFY localization and OTA-summary sanitization is committed but NOT RUN / NOT RELEASED. Flutter tests and analyzer still require actual execution.
3. Build #100 remains the latest successful release, source commit 51bea70b2ca17f285bf35c3e547dc44c70f26d59; it does not contain the current copy changes.
4. Only after separate @Thinking Eksekusi Build App! authorization, run the official guarded workflow against intended main source and verify tests, analyzer, Android/APK/signature/source-ZIP/download checks and Release/tag/source equality.
5. Do not start App Build under Eksekusi Full. Keep Firmware/BIN/Firebase/OTA/flash/device untouched unless separately authorized.

## 7. Audit / operations not performed

- Inspected live source, localization table, existing tests and latest Build #100 report before editing.
- Committed notification normalization, known reason-code mapping, professional English/Indonesian failure copy, concise status headings, OTA summary sanitization, and regression assertions to main.
- No Flutter/Dart tests or analyzer were run for the current notification follow-up. OTA summary helper/test changes were source-checked only; do not claim the tests passed.
- No App Build/release, APK build, release-tag movement, Firmware edit/compile, BIN payload read/write, Firebase metadata change, OTA, flash or device operation occurred.
- Build #100 remains the latest successful artifact and does not contain these notification source changes. Runtime wrapping, language switching, visible OTA messages, and command classification remain unverified until the new source is run and reviewed on-device.
