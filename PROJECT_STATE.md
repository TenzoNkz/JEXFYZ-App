# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Language policy

- **Language policy (owner decision 2026-11-28):** ChatGPT-facing explanations and reports in all three workspaces use clear standard Bahasa Indonesia, with English technical terms where precise. All explanatory and narrative text authored or revised in GitHub uses English only. Preserve required Indonesian App localization, protocol strings and verbatim evidence. See MASTER_PROMPT.md Section 2B.

## Code workstream — WP9 SOURCE/TEST VERIFIED CI / PACKAGE SCREENSHOT WAITING_OWNER

- Owner cadence: each fresh `@Thinking Eksekusi Code!` command authorizes exactly one WP. WP8 Floating Monitor boundary is COMPLETED. WP9's locked-card CTA source/test slice is implemented and VERIFIED CI. WP9 overall is WAITING_OWNER for a fresh package screenshot of the changed Home card. WP10 has NOT STARTED.
- **Current owner UI contract:** the disconnected locked submenu card is informational only; it has no Connect/Hubungkan CTA. The Home top-left Bluetooth icon/button remains the only Home entry point to the existing Connection flow. The Connection sheet, Settings > Bluetooth and BLE ownership/connection implementation remain unchanged; pointer blocking, semantics exclusion and state-derived lock rules are preserved.
- **Implementation commits:** `62a89aa3602575062f268c4823a186f034faf9ec` removes the lock-card callback and button; `3d21cf5eac31eee76f5e8ef784bce10886a7584d` is a pure canonical-formatting follow-up. Four paths changed: `lib/dashboard_display_menu.dart`, `lib/main.dart`, `test/dashboard_display_menu_test.dart`, `test/widget_test.dart`.
- **Validation Only #336:** run `46123591878` / job `140913176417`, exact source/test SHA `3d21cf5eac31eee76f5e8ef784bce10886a7584d`, terminal SUCCESS: locked dependencies PASS; formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; full Flutter suite 361/361 PASS. [Actions run](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/46123591878).
- **Repair history:** Validation Only #335 / run `46123335620` failed only the formatter gate on two test files; dependency/analyzer gates passed and all 361 tests passed. The formatter-only correction was applied from the runner's exact output; no assertion or behavior was changed.
- **Latest package:** Build App #173 / source SHA `478bdfdc5ee18379e07baad5e4dfd8ab598dc2db` remains the latest published package. Owner confirmed five 691 × 1536 captures from that APK and accepted the shown stage. Those screenshots predate the current code change and do not verify the updated lock card. No new package was built in CODE_FULL.
- **Unshown evidence:** all five Dashboard feature tabs, Settings subpages, Usage Statistics, further dialogs/sheets and Floating Monitor configuration/native overlay were not included in the five accepted captures; these remain outside the accepted stage evidence and unverified. The new Home locked-card treatment is still awaiting a current-package screenshot.
- **Deferred hardware:** cooler BLE discovery/session, commands, telemetry, Firmware interaction, thermal/electrical behavior and physical cooler operation are DEFERRED / NOT TESTED until owner demonstration.
- **Execution environment:** local Flutter/Dart/Gradle/ADB/emulator and Android SDK are unavailable. The hosted Validation Only workflow is Flutter-only; no Android build/render/device operation occurred in CODE_FULL.

## Next action — AWAITING SEPARATE BUILD APP AUTHORIZATION

A fresh explicit `@Thinking Eksekusi Build App!` command is required in the separate Build App workspace to package the exact current main SHA. Then inspect the changed Home/disconnected lock card from that package. This recommendation does not itself authorize a build. WP9 overall remains WAITING_OWNER; WP10 remains NOT STARTED.
