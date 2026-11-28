| Last updated | 2026-11-28T16:06:38+07:00 (Asia/Jakarta) |

> Event-driven project marker. It is not a live heartbeat or a GitHub lock.

## Current marker

| Field | Value |
|---|---|
| **STATUS** | **IN_PROGRESS** |
| SESSION STATUS | IN_PROGRESS — owner explicitly opened this BUILD_APP interaction with "Eksekusi Build App!" at 2026-11-28T16:00:00+07:00 (Asia/Jakarta). |
| WORK STATUS | IN_PROGRESS — pre-trigger checks are complete; one new guarded App Build/QC/release attempt is authorized and prepared. No trigger for this new attempt has been created yet. |
| WORKSPACE | BUILD_APP |
| Mode | Guarded Android App Build/QC/release only, plus narrowly justified App-scope repair if a real Build gate fails. Firmware/BIN, Firebase production metadata, OTA, flashing, physical-device operation and unrelated releases are excluded. |
| Request | Exact owner command: "Eksekusi Build App!" for TenzoNkz/JEXFYZ-App on canonical branch main using the guarded Build App workflow. |
| Active work package | Build App #174 — pre-trigger checkpoint. The unique new issue trigger must be created once after verifying the final intended source SHA; the issue/run identifiers will be recorded after the GitHub event is observed. |
| Owner authorization | CURRENT — the explicit command in this interaction authorizes one guarded Build App/QC/release work item. It supersedes the preceding CODE_FULL checkpoint's earlier instruction to postpone Build App. |
| Last verified App source/test checkpoint | Validation Only #339 / run 46127470525 / job 140925152695, terminal SUCCESS on exact App/test SHA c6206989cb0e30c94578c95b4d9c13bde5d36d71: locked dependencies PASS; Dart formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; Flutter tests 362/362 PASS. |
| Source delta after Validation Only | Live main before this checkpoint was b69138795ccb35fc1ae5a5b9733e51e2dace41a2, three commits ahead of c6206989cb0e30c94578c95b4d9c13bde5d36d71. Compare evidence shows only documentation/status/memory paths changed; no App source, tests, Build workflow or build configuration changed. This checkpoint commit is also documentation-only. |
| Latest published App package | Build App #173 / run 46121055519 / job 140905430951, terminal SUCCESS on source 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db. It predates WP9 and does not contain the updated Home locked-card change. |
| Current Release baseline | Release 403010611 / tag jexfyz-latest / target 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db; exactly two assets: APK ID 803673610 (56,279,131 bytes; SHA-256 5495fe52239e93d49b66c41b0d6da1ac6338c37a393b57dc77eb7e9c022e3076) and source ZIP ID 803673623 (3,340,010 bytes; SHA-256 d8029b887df3e3579966211878c893e30bdb25f2ea32e2a3dce2efe29430e60f). Release and tag match #173. |
| Current Actions state | No active Build App run found in the current Actions listing. Build #173 is terminal SUCCESS; Validation Only #339 is terminal SUCCESS. |
| Workflow/guard | Full live .github/workflows/jexfyz-app-build-trigger.yml reviewed. It triggers only on issues.opened/reopened; requires repository owner, exact title "JE X FYZ — EKSEKUSI BUILD APP TRIGGER" and body token "JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1"; serialized non-cancelling queue; no push/PR release trigger. |
| Open prior trigger issues | Existing issue #50 is still OPEN and was used for Build #173; older guarded issues are also open. None will be reused or reopened. A new unique issue will represent this separately authorized attempt. |
| Protected version | android/app/build.gradle preserves versionName exactly as "Telegram @horizontalzzz"; pubspec version is 1.0.0+3. |
| EXTERNAL OPERATION | NOT_STARTED — all currently observed Build runs are terminal; no new issue/run has been triggered in this interaction yet. |
| Current phase | PRE-TRIGGER READY — repository, source validation, full workflow, trigger guard, latest run/job, release/tag/assets and versionName have been verified. |
| Verified checkpoint | Current main was b69138795ccb35fc1ae5a5b9733e51e2dace41a2 before this four-document checkpoint. The resulting commit and exact intended Build source SHA must be read back before issue creation. |
| Next action | Read back the resulting main HEAD and the four updated files; confirm the App/test delta remains documentation-only, then create exactly one new issue with the required title/token and verify its Actions run head SHA. |

## Previous CODE_FULL checkpoint (historical)

WP9 removed the Connect/Hubungkan CTA from the disconnected Home locked card while preserving the top-left Bluetooth control and existing Connection flow. Validation Only #339 verified the expanded test matrix and Home-to-Connection source contract. The package-level screenshot of the updated card remains NOT YET CAPTURED / NOT YET REVIEWED. This visual evidence gap is separate from hosted Build gates and does not authorize device/hardware operations.
