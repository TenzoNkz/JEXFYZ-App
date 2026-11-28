# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28T16:06:38+07:00 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Language policy

- ChatGPT-facing explanations and reports use clear standard Bahasa Indonesia, retaining English technical terms where precise. New or revised explanatory repository prose is English only. Preserve required Indonesian App localization, protocol strings and verbatim evidence. See MASTER_PROMPT.md Section 2B.

## App source and validation

- **Latest validated App/test SHA:** c6206989cb0e30c94578c95b4d9c13bde5d36d71. Validation Only #339 / run 46127470525 / job 140925152695 terminal SUCCESS: locked dependency resolution PASS; Dart formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; Flutter tests 362/362 PASS.
- **WP9 source contract:** the disconnected Home locked submenu card is informational and has no Connect/Hubungkan CTA. Home's top-left Bluetooth control remains the entry point to the existing manual Connection flow. The Connection sheet, Settings > Bluetooth and BLE/session ownership are preserved.
- **Visual boundary:** the changed Home locked-card screenshot has not yet been captured/reviewed. Screenshots accepted from Build #173 predate WP9 and do not verify the updated card.
- **Main delta:** at the beginning of this Build App preflight, main was b69138795ccb35fc1ae5a5b9733e51e2dace41a2, three commits ahead of c6206989cb0e30c94578c95b4d9c13bde5d36d71. Compare evidence shows only documentation/status/memory paths changed after the validated App/test tree. No App source, test, workflow or Gradle configuration edits were made by those commits.

## Published App package

- **Latest published package before this Build attempt:** Build #173 / workflow run 46121055519 / job 140905430951 / exact source SHA 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db, terminal SUCCESS.
- **Release:** ID 403010611 / tag jexfyz-latest / target 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db; exactly two assets. APK ID 803673610, 56,279,131 bytes, SHA-256 5495fe52239e93d49b66c41b0d6da1ac6338c37a393b57dc77eb7e9c022e3076. Source ZIP ID 803673623, 3,340,010 bytes, SHA-256 d8029b887df3e3579966211878c893e30bdb25f2ea32e2a3dce2efe29430e60f.
- Build #173 predates WP9 and is not evidence that the updated Home locked card is packaged.

## Current Build App work item

- **Status:** IN_PROGRESS — new owner-authorized Build App work item, pre-trigger ready. The explicit owner command "Eksekusi Build App!" supersedes the prior CODE_FULL checkpoint that postponed Build App.
- **Workspace:** BUILD_APP. Scope is guarded App Build/QC/release plus narrowly justified App-scope repair only. Firmware/BIN, Firebase production changes, OTA, flashing, physical-device operation and unrelated releases are excluded.
- **Workflow:** .github/workflows/jexfyz-app-build-trigger.yml was read in full. It triggers only on issues.opened/reopened and requires the repository owner, exact title "JE X FYZ — EKSEKUSI BUILD APP TRIGGER" and body token "JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1". Queue is serialized and non-cancelling; there is no push/PR release trigger.
- **External operation:** NOT_STARTED at this checkpoint; no active Build App run exists. Prior Build #173 and Validation Only #339 are terminal.
- **Version invariant:** android/app/build.gradle versionName is exactly "Telegram @horizontalzzz"; Flutter package version is 1.0.0+3.
- **Next action:** read back the final documentation checkpoint SHA, create one new unique issue trigger for this owner command, and verify its Actions run/source SHA before continuing.

## Hardware and device evidence boundary

Cooler BLE discovery/session, commands, telemetry, Firmware behavior, thermal/electrical performance, physical installation, OEM visual acceptance and OTA remain NOT TESTED / NOT VERIFIED. Hosted Flutter validation and a successful Android release workflow cannot establish those outcomes. Do not perform hardware or Firmware operations in BUILD_APP.
