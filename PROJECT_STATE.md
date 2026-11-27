# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Active workspace and operation

- Active workspace: BUILD_APP. Explicit owner command received: “@Thinking Eksekusi Build App!”.
- Repository TenzoNkz/JEXFYZ-App; main is the canonical branch. Connected GitHub account and repository owner are both TenzoNkz; current integration has admin/push permission.
- **Build App attempt #168 is IN_PROGRESS:** Issue #46; GitHub Actions workflow run #169 / ID 46060632706 / workflow 374946166 / attempt 1; immutable source SHA 3ccc6528adddeb547a3ff770718b72f0e2aa8824; job build / 140713746680. Steps 1–2 SUCCESS, step 3 Set up Java 17 IN_PROGRESS; later required gates pending.
- The attempt is bound to one freshly created exact owner/title/body-token Issue #46. No duplicate trigger, issue reopen or retry was performed. Continue only the current run/job.
- Active main HEAD after documentation checkpointing: 5a35056cf3cff84069fb6e6dd1373f0de721b37f (operational docs only); the Actions checkout is immutable at 3ccc6528adddeb547a3ff770718b72f0e2aa8824. Do not conflate the two.
- A prior workflow run #168 / ID 46037111406 came from CODE_FULL Issue #45 and was terminal SKIPPED by the title guard. It is not a Build attempt and is not to be retried.

## App source validation and package baseline

- Latest pre-Build source validation: Validation Only #253 / run 46059017532 / job 140708450872; exact source a60444f555038c90ea16ac3d6ea878de13d414a1; terminal SUCCESS. Flutter 3.47.2 / Dart 3.13.2; locked dependency resolution PASS; formatter 50 files / 0 changed; analyzer 139 info diagnostics / zero warnings-errors; Flutter tests 326/326 PASS. This was Flutter-only Validation Only, not Android Gradle or APK evidence.
- Commits from validated source through Build source SHA only update 00_WORK_STATUS.md and do not change App source, tests, dependencies or build configuration.
- Latest published package before this attempt remains Build #167 / run 44510421466 / job 135512909555 / source 0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81. Release ID 403010611 / tag jexfyz-latest points to that old source until the current Build passes publication and downloaded-asset checks.
- Baseline APK asset ID 767350299: 56,180,827 bytes; SHA-256 d7c461478e033b4598d1744e2ea7ec969eea8046bf5e4a3d6caaf511bc461691. Baseline corresponding-source ZIP asset ID 767350301: 3,259,558 bytes; SHA-256 58711342358639695624bbe05cc598220c9f20710bb04deaa785b93b85ca1546. Exactly two old baseline assets; do not report them as new Build output.

## Build procedure and evidence requirements

- BUILD_NOTES.md (355 lines), full .github/workflows/jexfyz-app-build-trigger.yml (562 lines), ota-and-release-integrity and github-actions-triage canonical skills were read. Workflow blob 28281db3118e36fd1658cdaef2e30c78e6c4977b.
- Guard is issue-only (opened/reopened), owner + exact title + body token; no push/PR release trigger. Serialized queue has cancel-in-progress false. Direct actions are pinned to verified immutable SHAs. Required audit/dependency/analyzer/Flutter/Android Gradle/obfuscation/V1-V3/certificate/source ZIP/Release/tag/count/fresh-download identity gates remain unchanged.
- android/app/build.gradle has exact protected versionName "Telegram @horizontalzzz".
- APP_BUILD_REPORT.md has the append-only Build #168 trigger/run/job/source and initial step-state record. CHAT_TRANSFER.md has a bounded active BUILD_APP checkpoint. Continue appending actual gate results, warnings, failures/repairs, asset IDs/sizes/digests, and tag/source identity only when observed.

## Remaining project work and limits

- Complete the active Build attempt and reconcile exact source SHA, all gates, one APK plus one source ZIP, V1/V2/V3 signatures and pinned certificate, tag/Release parity, fresh downloads and SHA-256 identity.
- Native Android test tasks must be reported as actually observed (they may be NO-SOURCE). Hosted CI does not prove physical install, OEM visual behavior, BLE runtime, Firmware, OTA, cooling or electrical/thermal safety.
- Visual acceptance remains VISUAL NOT VERIFIED absent actual representative Android screenshots. Firmware/BIN, Firebase production metadata, OTA, flashing and device operations are outside this workspace and were not performed.
- Prior CODE_FULL WP0–WP10 work remains parked as historical/incomplete continuation context; it is not active authorization in this BUILD_APP chat.

## Protected contracts

- Preserve BLE P1 UUID/framing/commands/SYNC/SYNC_READY, Dashboard single-radio/session/ACK/telemetry ownership, reconnect semantics, unknown/disconnected handling and persisted-data contracts.
- Preserve safe outputs, NTC, rail/Peltier/selector timing, cooperative Firmware scheduling, OTA protection/recovery semantics and the Android Gradle versionName exactly "Telegram @horizontalzzz".
- This workspace does not authorize Firmware compilation/BIN, Firebase/production metadata changes, OTA, flashing, physical-device operations, or unrelated release work.

## Immediate next action

Continue only Actions run 46060632706 / job 140713746680 / source 3ccc6528adddeb547a3ff770718b72f0e2aa8824. Inspect live job steps and terminal logs; if a gate fails, identify the exact cause and repair only justified App-scope code without weakening gates. Never create a duplicate trigger or blindly retry.
