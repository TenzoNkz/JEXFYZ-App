# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28T16:12:37+07:00 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## App source and validation

- **Latest validated App/test SHA:** c6206989cb0e30c94578c95b4d9c13bde5d36d71. Validation Only #339 / run46127470525 / job140925152695 terminal SUCCESS: locked dependencies PASS; formatter63 files / 0 changed; analyzer157 info / 0 warnings / 0 errors; Flutter tests362/362 PASS.
- **Build #174 source:** c1408fff0fae10bf6b98237c4485c2c5fb77c368; subsequent commits are documentation/status only, with no App source/tests/workflow/Gradle configuration changes.
- **WP9 contract:** disconnected Home locked submenu card is informational without Connect/Hubungkan. Home's top-left Bluetooth control remains the entry to the existing manual Connection flow. The Connection sheet, Settings > Bluetooth and BLE/session ownership are preserved.
- **Visual boundary:** the changed Home locked-card screenshot is NOT CAPTURED / NOT REVIEWED. Build #173 screenshots predate WP9.

## Published App package before Build #174

- Build #173 / run46121055519 / job140905430951 terminal SUCCESS on source478bdfdc5ee18379e07baad5e4dfd8ab598dc2db.
- Release403010611 / tag jexfyz-latest targets that source. Exactly two assets: APK803673610 / 56,279,131 bytes / SHA-2565495fe52239e93d49b66c41b0d6da1ac6338c37a393b57dc77eb7e9c022e3076; source ZIP803673623 / 3,340,010 bytes / SHA-256d8029b887df3e3579966211878c893e30bdb25f2ea32e2a3dce2efe29430e60f.

## Build App #174 — IN_PROGRESS

- **Owner authorization:** explicit "Eksekusi Build App!".
- **Trigger:** Issue #51 / ID6662377983; exact title/token verified.
- **Run:** workflow374946166 / run46128979174 / attempt1 / event issues / job140929762652; source SHA c1408fff0fae10bf6b98237c4485c2c5fb77c368. Run/job IN_PROGRESS.
- **Completed gates:** steps1–14 SUCCESS, including security/architecture audit, dependencies, analyzer, Flutter tests and Android unit-test gate.
- **Current gate:** step15 obfuscated release APK build IN_PROGRESS. Steps16–21 and cleanup pending. Exact test/analyzer counts and Gradle metrics await job-log availability.
- **Workflow protections:** issue-only owner/title/token guard; serialized non-cancelling queue; no push/PR release trigger; V1/V2/V3, pinned certificate, source archive, Release/tag and fresh-download verification remain required.
- **Protected version:** Android Gradle versionName "Telegram @horizontalzzz"; Flutter1.0.0+3.
- **Next action:** continue only the current run/job and record the actual signing, archive and Release gates.

## Hardware and device boundary

Cooler BLE discovery/session, commands, telemetry, Firmware behavior, thermal/electrical performance, physical installation, OEM visuals and OTA remain NOT TESTED / NOT VERIFIED. Hosted CI cannot establish those outcomes. No hardware/Firmware operation is authorized in BUILD_APP.
