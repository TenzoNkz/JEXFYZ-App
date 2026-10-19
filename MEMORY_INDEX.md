# JE X FYZ / JE Cooler — Memory Index

Reconciled against live GitHub `main` on 2026-10-19 (Asia/Jakarta). This file is the navigation index; `PROJECT_STATE.md` carries current state, subject files own detailed contracts, `APP_BUILD_REPORT.md` owns build evidence, `CHANGELOG.md` owns history, and `CHAT_TRANSFER.md` is the detailed next-chat boot snapshot. Live source, Git refs, Actions and Release metadata override memory.

## Current verified checkpoint

- Latest successful App artifact run is Build #83 / [Actions run `39192430789`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39192430789), exact packaged source `dfc7e6633298498bb6eac21182c9306d5e3cac1d`. All 21 workflow steps passed, including analysis (23 informational deprecation findings), **96/96 Flutter tests**, Android configured gate, obfuscated APK, production certificate and V1/V2/V3 signatures, matching source ZIP, Release publication and re-downloaded asset verification. Native JUnit tasks were NO-SOURCE; no native JUnit cases ran.
- Release handoff remains **BLOCKED**. Release metadata and both assets target Build #83 source, but actual `refs/tags/jexfyz-latest` still points to `9136f11799143d91eb58e947ea10e9e576bb579f`.
- Build #83 assets: APK `655087433`, 54,620,251 bytes, SHA-256 `1b5e2cf4a16e6e521a7a332b2ab252c45a2f632a39f259203f9dce47602e9b92`; matching source ZIP `655087446`, 2,854,731 bytes, SHA-256 `c7e3952d20510d203f2d9fbf901033d5289fdcdbf8c6c141c7ff29b9a413c018`. Both contain source marker `dfc7e6633298498bb6eac21182c9306d5e3cac1d`.
- Current App source/test inputs still match Build #83: `lib/main.dart` blob `99bdf225b990fbe8a4ff92c224b4fccc4ae4624a`, `test/widget_test.dart` blob `9fffea531bdb19315c01aaf0e253ebdfacd7a1ed`; no App-source change followed #83.
- The current guarded build workflow blob is `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`, commit `0c266f3064d77a394d660acd16595ff43166fb7f`. A malformed YAML fragment outside a `run: |` block was removed and the final tag-equality assertion put inside the download-verification step. The repair is **NOT RUN in an official workflow yet**. Runs #84–#87 were push events failing with no jobs; latest issue-trigger run remains #83. Issue #34 has the exact owner/title/token but no newer issue-event run was observed. The bad YAML is a plausible cause, not a confirmed root cause/recovery.
- Active Firmware source: `firmware/JEXFYZ-V6.7.ino`, `FW_VERSION="V6.7"`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`. User-reported compilation/online update on 2026-10-18 is **USER-REPORTED**; source-to-BIN provenance, compile log, OTA logs and installed version remain **UNVERIFIED**.
- The latest read-only artifact-repo tree for `TenzoNkz/JEXFYZ-Firmware` is not truncated and contains exactly `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. The BIN payload was not read or changed; path/version/date do not prove source-to-BIN identity.
- App config: pubspec `1.0.0+3`, Android applicationId `com.horizontalzzz.jexfyz`, minSdk 24, targetSdk 36, compileSdk 37. Preserve Gradle `versionName "Telegram @horizontalzzz"` exactly.
- The last complete App tree scan returned 67 entries (49 blobs/18 trees), five branches and zero open PRs. Re-fetch for any later session.

## New-chat boot order

1. Read `CHAT_TRANSFER.md` completely before replacing it or making assumptions.
2. Fetch live `main` HEAD and recursive tree, current source/config/test/workflow hashes, branches/PRs, Actions runs, Release and tag refs, active `.ino`/embedded `FW_VERSION`, and artifact-repo tree.
3. Read `CHAT_RULES.md`, this index, `PROJECT_STATE.md`, `HANDOVER.md`, and the complete subject reference for the request.
4. Subject routing: App/UI/BLE → `APP_NOTES.md`; hardware/Firmware → `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`; OTA → `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md`; voltage/Peltier sequencing → `VOLTAGE_TRANSITION_MEMORY.md`; App build/release → `BUILD_NOTES.md`, `APP_BUILD_REPORT.md`, live workflow; grille/icons → `DESIGN_NOTES.md`; general history → `CHANGELOG.md`.
5. For a full chat-limit reconciliation, use Prompt A in `CHAT_TRANSFER_PROMPTS.md), read the previous transfer fully, update every other canonical file first, and replace `CHAT_TRANSFER.md` last. For a Build App context limit only, Prompt D is the one-shot LOAD + CONTINUE opener.
6. Use live source/run/ref evidence, never an old summary or historical hash. App CI does not prove physical BLE, cooling/safety, Firmware compilation, BIN identity, or OTA behavior.

## Permanent command and authorization protocol

- `@Thinking Diskusi!`: full read-only discussion; no repository writes.
- `@Thinking Diskusi! Tanya Gemini!` and `@Thinking Diskusi! Jawaban Gemini!` are valid only with `Diskusi!` in the same message.
- `@Thinking Eksekusi Full!`: execute the explicitly scoped source/docs/tests/audit task and commit directly to `main`; it does not authorize App Build, Firmware compile, BIN, Firebase, OTA, flash, device or unrelated release actions.
- `@Thinking Eksekusi Build App!`: sole end-to-end App Build/QC authorization, including evidence-based App-scope repairs/retries, published asset verification and updating `APP_BUILD_REPORT.md`.
- `@Thinking Chat Stuck!`: recover the most recent valid operation from live logs/state without blind retry or wider authorization.
- Retired commands: `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!`.
- Work directly on `main`; no branch/PR unless asked. Keep App trigger guarded to issue opened/reopened with repository owner, exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, and token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; no push/PR bypass. Never change app `versionName "Telegram @horizontalzzz"`.

## Canonical file map

| File | Canonical purpose |
|---|---|
| `README.md` | Project overview, live validation boundary, navigation and repository split |
| `MEMORY_INDEX.md` | This memory routing index and current checkpoint |
| `CHAT_RULES.md` | Commands, authorization, version/repository separation and user restrictions |
| `PROJECT_STATE.md` | Current-only implementation/release state and open gates; no long build history |
| `CHAT_TRANSFER.md` | Detailed boot snapshot; replace last after complete reconciliation |
| `CHAT_TRANSFER_PROMPTS.md` | Prompt A memory reconciliation, Prompt B read-only boot, Prompt C persistence, Prompt D one-shot Build App LOAD + CONTINUE |
| `HANDOVER.md` | Immediate handoff, blocker, and next authorized action |
| `APP_NOTES.md` | UI, controls, BLE, state/telemetry, localization, notifications, Floating Monitor |
| `FIRMWARE_NOTES.md` | Hardware/pins, NTC, safety, Adaptive, transitions, touch/LED/preferences/telemetry |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | Source architecture and implementation invariants; not compile proof |
| `OTA_PROTECTION.md` | Protected Local/Online OTA flow, safe outputs and gates |
| `OTA_REGRESSION_MEMORY.md` | CA/NTP experiment, failure evidence, `setInsecure()` security trade-off and preflight |
| `VOLTAGE_TRANSITION_MEMORY.md` | Peltier ramp, rail handoff, cancellation/recovery rules and hardware validation plan |
| `BUILD_NOTES.md` | Active App build procedure, toolchain, authorization and validation boundaries |
| `APP_BUILD_REPORT.md` | Authoritative complete build attempts/fixes/results; current Build #83 and blocked Release handoff |
| `CHANGELOG.md` | Significant history and superseded decisions; never override current source |
| `DESIGN_NOTES.md` | Approved grille/logo/assets and dashboard motion/layout contracts |
| `.github/workflows/jexfyz-app-build-trigger.yml` | Authoritative guarded manual App Build workflow |
| `test/*.dart` | Five current Flutter/source-contract test files; execution must be proven from run evidence |
| `firmware/JEXFYZ-V6.7.ino` | Active editable V6.7 source; user compiles separately |
| `archive/*.md` | Immutable forensic snapshots; stale “CURRENT” claims remain historical, paths retained verbatim |

## Source fingerprints (live main before this index write)

- `lib/main.dart`: `99bdf225b990fbe8a4ff92c224b4fccc4ae4624a`
- `lib/app_settings.dart`: `36927823c91904a35d87d2f21bd77932a2214e83`
- `lib/floating_monitor.dart`: `31b45ea08b08ac7fc25ebd991dca873b889fdd14`
- `test/widget_test.dart`: `9fffea531bdb19315c01aaf0e253ebdfacd7a1ed`
- `test/floating_monitor_layout_contract_test.dart`: `87e805095202ac3edfe55b9aeb3138c7c6886375`
- `test/v6_7_qc_contract_test.dart`: `52671a0c9014ab48cfe3475d775d4457fede7124`
- `test/app_protocol_notify_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`
- `test/firmware_touch_adaptive_sync_test.dart`: `94c0f074247f47fce7d939a72b0130eb1b2d70fa`
- `firmware/JEXFYZ-V6.7.ino`: `efe6eaa62c178ab536fb68c06a310e54826cbaf2`
- `.github/workflows/jexfyz-app-build-trigger.yml`: `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`
- `pubspec.yaml`: `8f558273e21692af9958f914527fdc62d623d63a`; `pubspec.lock`: `1e92812bfda2c28244a0556d71d1ec94084acc66`
- Android `MainActivity.kt`: `ef35590cfc91fafe5dec104b7cfd7828011185bf`; `FloatingMonitorService.kt`: `8312cc12d391cde5f76b146ff98075856d32bae2`; `JeForegroundService.kt`: `9ea4dce7001bcd5cc10f9c1c7ad62f34ec54b03e`; `JexNotificationUtils.kt`: `aecfc87121f2195ef6724613c612d674ed95ae55`; `AndroidManifest.xml`: `c374b5d3ad6448b8b3e99a420ed7e8c49d38497a`; `android/app/build.gradle`: `060cdd36a4f7d4d2fa4c97a1b6a15954b8355350`
- These are blob SHAs, not build artifacts, and must be re-fetched before use in future work.

## Evidence labels

- **CURRENT / VERIFIED:** directly checked live code/tree/ref/Actions/Release data.
- **SOURCE IMPLEMENTED / NOT RUN:** code/test contracts exist; test/analyzer/build has not executed for that change.
- **USER-REPORTED:** reported by user, not independently validated.
- **UNVERIFIED:** required supporting evidence is missing.
- **HYPOTHESIS:** plausible cause, not established.
- **HISTORICAL / SUPERSEDED:** valid for an older source/version/run only.
- **NOT RELEASED:** current source differs from last verified release or release tag/asset consistency is incomplete.

## Durable repository/evidence restrictions

- All source, documentation, tests and project memory remain in `TenzoNkz/JEXFYZ-App`. Keep `TenzoNkz/JEXFYZ-Firmware` BIN-only. The currently checked BIN metadata is `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes; do not read or mutate payload during documentation tasks, and do not infer source provenance.
- User reports V6.7 compilation and online update. Source/BIN identity, installed version, Firebase state, and full OTA apply/reboot/reconnect remain unverified. The previous V6.6 compile/two-OTA statements are historical user reports.
- Current UI excludes a standalone Battery Protection Guard. The exclusive one-App/one-cooler pairing lock is a user design requirement; encrypted/bonded writes alone do not prove exclusive provisioning.
- Preserve OTA protection and its `setInsecure()` server-identity trade-off; read OTA and voltage-transition references before changes. Preserve the approved white square grille/purple X/four corner holes/flat-print design and transparent square app assets.
- Keep the permanent hardware timings, NTC single-sample rule, safety gates, Adaptive profile behavior, BLE P1 UUIDs, LED mode IDs and telemetry contracts in their canonical subject files.
- Latest exact next action: after a separate `@Thinking Eksekusi Build App!`, verify the issue-triggered workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; then re-fetch and compare Release metadata, APK/source ZIP hashes and source marker. Until then, overall Release handoff is **BLOCKED**.
