# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Language policy

- **Language policy (owner decision 2026-11-28):** ChatGPT-facing explanations and reports in all three workspaces use clear standard Bahasa Indonesia, with English technical terms where precise. All explanatory and narrative text authored or revised in GitHub uses English only. Preserve required Indonesian App localization, protocol strings and verbatim evidence. See MASTER_PROMPT.md Section 2B.

## Code workstream — WP9 SOURCE/REGRESSION VERIFIED CI / UPDATED HOME SCREENSHOT WAITING_OWNER

- Owner cadence: each fresh @Thinking Eksekusi Code! command authorizes exactly one WP. WP8 Floating Monitor boundary is COMPLETED. WP9 source/test implementation is COMPLETED and VERIFIED CI. Overall WP9 remains WAITING_OWNER for a fresh package screenshot of the changed Home card. WP10 has NOT STARTED.
- **Current owner UI contract:** the disconnected locked submenu card is informational only; it has no Connect/Hubungkan CTA. Home's top-left Bluetooth icon/button remains the only Home entry point to the existing manual Connection flow. The Connection sheet, Settings > Bluetooth and BLE ownership/implementation remain unchanged. Lock precedence, blur/dim, pointer blocking and semantics exclusion are preserved.
- **Implementation:** 62a89aa3602575062f268c4823a186f034faf9ec removes the lock-card callback and button. Test matrix 80fb686609ce60112e0e67d185a23488a71bb0df covers 350/420 dp × EN/ID × Light/Dark. Home-to-Connection source contract 49bc706986600b52f21666abd57ab71bdb1ca9f2 preserves the existing callback and guarded modal/manual-sheet flow. Formatter-only follow-up c6206989cb0e30c94578c95b4d9c13bde5d36d71.
- **Changed files:** lib/dashboard_display_menu.dart, lib/main.dart, test/dashboard_display_menu_test.dart and test/widget_test.dart. Production source changed only in the implementation commit; the two later commits update tests and formatting.
- **Validation Only #339:** run 46127470525 / job 140925152695, exact source/test SHA c6206989cb0e30c94578c95b4d9c13bde5d36d71, terminal SUCCESS: locked dependencies PASS; formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; full Flutter suite 362/362 PASS. [Actions run](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/46127470525).
- **Validation recovery:** #337 and #338 failed only formatter checks while dependency/analyzer and 362/362 tests passed. Exact runner formatting was applied without changing assertions or behavior.
- **Latest package:** Build App #173 / source SHA 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db remains the latest published package. Its five owner-confirmed captures are accepted for the previous stage only; they predate the current code and do not verify the updated lock card. No new package was built in CODE_FULL. Build App is postponed by the owner.
- **Unshown evidence:** all five Dashboard feature tabs, Settings subpages, Usage Statistics, further dialogs/sheets and Floating Monitor configuration/native overlay remain outside the five accepted screenshots and unverified.
- **Deferred hardware:** cooler BLE discovery/session, commands, telemetry, Firmware interaction, thermal/electrical behavior and physical cooler operation remain DEFERRED / NOT TESTED.
- **Local execution:** Flutter/Dart/Gradle/ADB/emulator and Android SDK are unavailable. Hosted Validation Only is Flutter-only; no Android build/render/device operation occurred in CODE_FULL.

## Next action — WAITING_OWNER / BUILD APP POSTPONED

WP9 source/test work is complete and exact-SHA verified. Wait for the owner to authorize Build App in the separate workspace later, then inspect a screenshot of the updated Home/disconnected lock card. This recommendation does not authorize a build. WP9 overall remains WAITING_OWNER until that screenshot is reviewed; WP10 remains NOT STARTED.
