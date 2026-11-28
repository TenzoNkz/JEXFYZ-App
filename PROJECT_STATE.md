# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28T16:09:59+07:00 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## App source and validation

- **Latest validated App/test SHA:** c6206989cb0e30c94578c95b4d9c13bde5d36d71. Validation Only #339 / run 46127470525 / job 140925152695 terminal SUCCESS: locked dependency resolution PASS; formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; Flutter tests 362/362 PASS.
- **Build #174 source SHA:** c1408fff0fae10bf6b98237c4485c2c5fb77c368. Four commits after the validated source change only documentation/status/handover files; no App source, tests, workflow or Gradle configuration changed.
- **WP9 contract:** disconnected Home locked submenu card is informational without Connect/Hubungkan. Home top-left Bluetooth remains the entry point to existing manual Connection flow. The Connection sheet, Settings > Bluetooth and BLE/session ownership remain preserved.
- **Visual boundary:** current Home locked-card screenshot is NOT CAPTURED / NOT REVIEWED. Build #173 screenshots predate WP9.

## Published App package before Build #174

- Build #173 / run 46121055519 / job 140905430951, terminal SUCCESS on source 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db.
- Release403010611 / tag jexfyz-latest targets the same source. Exactly two assets: APK ID803673610 / 56,279,131 bytes / SHA-256 5495fe52239e93d49b66c41b0d6da1ac6338c37a393b57dc77eb7e9c022e3076; source ZIP ID803673623 / 3,340,010 bytes / SHA-256 d8029b887df3e3579966211878c893e30bdb25f2ea32e2a3dce2efe29430e60f.

## Build App #174 — IN_PROGRESS

- **Owner authorization:** explicit "Eksekusi Build App!".
- **Trigger:** Issue #51 / ID6662377983; exact title and token verified.
- **Actions:** workflow374946166 / run46128979174 / attempt1 / job140929762652 / event issues; run/job IN_PROGRESS; source SHA c1408fff0fae10bf6b98237c4485c2c5fb77c368.
- **Gate status:** steps1–12 SUCCESS, including security/architecture audit, dependencies and analyzer. Step13 Flutter tests IN_PROGRESS. Steps14–21 and cleanup pending. Job log endpoint has not yet supplied a log blob while job is active; exact diagnostic/test counts are pending.
- **Workflow protections:** issue-only owner/title/token guard, serialized non-cancelling queue, no push/PR release trigger. All Android Gradle, obfuscation, V1/V2/V3, pinned certificate, source ZIP, Release/tag and fresh-download verification gates remain intact.
- **Protected version:** Android Gradle versionName exactly "Telegram @horizontalzzz"; Flutter version1.0.0+3.
- **Next:** continue the exact run/job and update evidence from live steps/logs.

## Hardware and device evidence boundary

Cooler BLE discovery/session, commands, telemetry, Firmware behavior, thermal/electrical performance, physical installation, OEM visual acceptance and OTA remain NOT TESTED / NOT VERIFIED. Hosted validation and Android release CI cannot establish those outcomes. No hardware/Firmware operation is authorized in BUILD_APP.
