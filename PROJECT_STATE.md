# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28T16:08:45+07:00 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## App source and validation

- **Latest validated App/test SHA:** c6206989cb0e30c94578c95b4d9c13bde5d36d71. Validation Only #339 / run 46127470525 / job 140925152695 terminal SUCCESS: locked dependency resolution PASS; Dart formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; Flutter tests 362/362 PASS.
- **WP9 source contract:** the disconnected Home locked submenu card is informational and has no Connect/Hubungkan CTA. Home's top-left Bluetooth control remains the entry point to the existing manual Connection flow. The Connection sheet, Settings > Bluetooth and BLE/session ownership are preserved.
- **Visual boundary:** the changed Home locked-card screenshot has not yet been captured/reviewed. Screenshots accepted from Build #173 predate WP9 and do not verify the updated card.
- **Build source SHA:** c1408fff0fae10bf6b98237c4485c2c5fb77c368. Four commits after the latest App/test validation SHA changed only documentation/status/handover files; no App source, tests, workflow or Gradle build config changed.

## Published App package

- **Previous latest package:** Build #173 / run 46121055519 / job 140905430951 / exact source SHA 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db, terminal SUCCESS.
- **Release:** ID 403010611 / tag jexfyz-latest / target 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db; exactly two assets. APK ID 803673610, 56,279,131 bytes, SHA-256 5495fe52239e93d49b66c41b0d6da1ac6338c37a393b57dc77eb7e9c022e3076. Source ZIP ID 803673623, 3,340,010 bytes, SHA-256 d8029b887df3e3579966211878c893e30bdb25f2ea32e2a3dce2efe29430e60f.
- Build #173 predates WP9 and does not contain the updated Home locked card.

## Current Build App work item — IN_PROGRESS

- **Workspace:** BUILD_APP. The explicit owner command "Eksekusi Build App!" authorizes guarded Android App Build/QC/release plus narrowly justified App-source repair only.
- **Trigger:** Issue #51 / ID 6662377983; exact title "JE X FYZ — EKSEKUSI BUILD APP TRIGGER" and required token verified.
- **Actions:** Build #174 / workflow 374946166 / run 46128979174 / attempt 1 / job build 140929762652; run/job IN_PROGRESS. Immutable source SHA c1408fff0fae10bf6b98237c4485c2c5fb77c368 matches issue body, run head_sha and main at trigger creation.
- **Initial step state:** Set up job SUCCESS; Checkout repository IN_PROGRESS; later steps pending. No downstream gate result is claimed yet.
- **Workflow:** issue opened/reopened only; repository owner + exact title + body token guard; serialized non-cancelling queue; no push/PR publishing trigger. All test, Android Gradle, obfuscation, V1/V2/V3, certificate, source ZIP, Release/tag and fresh-download verification gates remain intact.
- **Version invariant:** android/app/build.gradle versionName is exactly "Telegram @horizontalzzz"; Flutter package version is 1.0.0+3.
- **Next action:** continue run 46128979174, record each gate in APP_BUILD_REPORT.md, and close only after live Release/tag/assets and downloaded asset identity/checksum are verified.

## Hardware and device evidence boundary

Cooler BLE discovery/session, commands, telemetry, Firmware behavior, thermal/electrical performance, physical installation, OEM visual acceptance and OTA remain NOT TESTED / NOT VERIFIED. Hosted Flutter validation and a successful Android release workflow cannot establish those outcomes. Do not perform hardware or Firmware operations in BUILD_APP.
