# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Language policy

- **Language policy (owner decision 2026-11-28):** ChatGPT-facing explanations and reports in all three workspaces use clear standard Bahasa Indonesia, with English technical terms where precise. All explanatory and narrative text authored or revised in GitHub uses English only. Preserve required Indonesian App localization, protocol strings and verbatim evidence. See MASTER_PROMPT.md Section 2B.

## Code workstream — WP9 BLOCKED / VISUAL NOT VERIFIED

- Owner cadence: each fresh `@Thinking Eksekusi Code!` command authorizes exactly one WP. WP8 Floating Monitor boundary is COMPLETED. The current 2026-11-28 command selected WP9 Visual/regression evidence only; WP9 is BLOCKED because required actual Android/OEM screen evidence is unavailable. WP10 has not started. ChatGPT/Codex remains sole author/reviewer; scoped changes go directly to `main`.
- **Validated App source/test checkpoint:** `048c22ba4722848b962dc58d5b3e9dc7fe994961`. Validation Only #327 / run 46113283625 / job 140881362489 terminal SUCCESS: locked dependencies PASS; formatter 62 files / 0 changed; analyzer 159 info / 0 warnings / 0 errors; full Flutter suite 359/359 PASS. Ten commits after that SHA up to the current documentation checkpoint are documentation-only.
- **Partial regression coverage:** Home 350/420 dp × EN/ID × theme presets; Temperature 360/420 dp × EN/ID × Light/Dark accessibility; LED controls 350-dp Light/EN plus 420-dp Dark/ID; Floating Monitor Settings 350/420 dp × EN/ID × Light/Dark. These are Flutter widget/semantics tests, not Android screenshot evidence.
- **Visual outcome:** VISUAL NOT VERIFIED. No actual screenshot/golden set for the reviewed SHA exists in the live tree. Build #167's Home-only EN/Light/disconnected screenshot (2026-11-24) lacks exact source SHA, logical dp width and density. The currently published `jexfyz-latest` Release uses older source SHA `67ff49fdb566a2fa7748e32e5207217c8e4b98b7` and cannot prove current visuals.
- **Environment:** Flutter, Dart, Gradle, ADB and emulator are unavailable; Android SDK variables are unset. Validation Only runs Flutter dependency/formatter/analyzer/test gates; it does not provide native Android/OEM screenshots or Canvas/WindowManager validation.
- **Unblock WP9:** obtain actual Android screenshot evidence at the exact source/test SHA above for Home, five Dashboard tabs, Connection, Settings/subpages, Usage Statistics, applicable dialogs/sheets and Floating Monitor. Include device/Android version, source SHA, dp/physical dimensions and density, locale/theme, text scale/reduced motion and connected/disconnected/error/locked states. Native overlay must be captured separately. A fresh owner command is required to resume WP9.
- No source/test/native/Firmware/OTA/Firebase/release/APK/device operation occurred in the WP9 attempt. No App package was built. No Actions run is active.

## Next action — BLOCKED

Wait for the current-SHA Android screenshot matrix and metadata. Do not start WP10 before WP9 is accepted. Resume only with a fresh explicit `@Thinking Eksekusi Code!` command after evidence is available.
