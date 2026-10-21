# JE X FYZ / JE Cooler — LIVE CHAT CHECKPOINT

Checkpoint maintenance date: 2026-10-21 (Asia/Jakarta). This is a concise continuation checkpoint, not a transcript summary. Always verify live `main` before relying on hashes or current Actions/Release state.

## Production status — confirmed by product owner

- **Android App:** the sold unit is using **Build #124**, as confirmed by the owner.
- **Firmware:** **V7.1 was compiled and successfully updated through Online OTA**, as confirmed by the owner.
- **Product:** unit sold and shipped to the buyer. It is not available for routine physical disassembly or repair.
- Treat Build #124 + Firmware V7.1 as the **production baseline**. Future maintenance may use the App and online firmware-update path, but avoid discretionary updates and any change that could strand the remote device.
- These deployment/compile/OTA outcomes are **USER-REPORTED**. The source repository and App CI alone do not independently verify the installed device, exact BIN identity, live OTA behavior, reboot, BLE recovery, or thermal/electrical behavior. Do not turn this evidence limitation into a claim that the owner-reported deployment did not happen.

## Repository and release evidence

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; work directly on main unless explicitly asked otherwise.
- Cleanup base HEAD: `ca143274994316ebfee6195b47c59bab9cd1b3bb` (2026-10-20). The cleanup series is committed through verified HEAD `9778255bdf0bed36cabc79d365e3e8510e4ea0ae` (11 commits ahead of base; 68 recursive entries, not truncated). This checkpoint was re-read at that HEAD before its wording correction; always fetch live HEAD/tree on every new chat.
- Latest independently verified App release record: Build #124 / Actions run [39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), package source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. It passed 116 Flutter tests and configured release gates; native Android unit-test tasks were NO-SOURCE. APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`; corresponding source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`.
- Active editable Firmware source: `firmware/JEXFYZ-V7.1.ino`, `FW_VERSION="V7.1"`, current blob `c44e076b2c1ee2d0b66b4fcd308d0febc69976e9`. The owner's compile/OTA confirmation applies to the product in the field; no binary payload was inspected and its source-to-BIN identity is not independently proven here.
- Current source-contract fingerprints after comment-only maintenance: QC `test/firmware_qc_contract_test.dart` blob `367acddd4ca9123c2834f8a5177039d9dadaabc9`; Touch/Adaptive sync `test/firmware_touch_adaptive_sync_test.dart` blob `dfa1f604327f1705b52134aa794d7ce60232841e`; Floating Monitor layout `test/floating_monitor_layout_contract_test.dart` blob `1159ac2970381cd6811a7a4a84c9d92321080f7b`.
- Comment-only equivalence was checked for all changed source/test/config files against their pre-cleanup blobs. No runtime logic changed. No test, analysis, Gradle build, Arduino compile, App Build, BIN, Firebase, OTA, flash or device operation ran in this cleanup.

- Artifact repository metadata observed before the final checkpoint write: `TenzoNkz/JEXFYZ-Firmware` contains only `JEXFYZ.cpp.bin`, 1,456,480 bytes, blob `a9718ab56afa19ff37ec29186caafa72ab48d01f`. Only tree/file metadata was inspected; BIN payload was not read or changed.
- Branches observed: `main`, `diag/latest-stable-v16`, `diagnostic/v1.6-heap-check`, `fix/adaptive-power-sequencing`, `tmp-jexfyz-v5-test`. No open pull requests were returned by the live query. Continue directly on `main`; create no branch/PR unless asked.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.

## Firmware behavior contract — preserve as-is

- Adaptive Fan target bands are relative to configured Hotside limit using whole-degree temperature categories: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%. At limit 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%.
- Raw-decimal safety remains immediate: at/above the configured Hotside limit, Fan 100% and Peltier OFF. Adaptive PWM increases by 10 percentage points per second and decreases by 10 points per 10 seconds; Adaptive 5 V/9 V remains 100%.
- Keep Touch/P1, single-radio Wi-Fi↔BLE handoff, BLE state reconciliation, Peltier and rail timing, Local OTA, Online OTA, output-safe recovery and restart behavior unchanged during maintenance.
- Online OTA intentionally retains `cloudClient.setInsecure()`; this encrypts transport but does not authenticate server certificate identity. Keep the raw-GitHub BIN allowlist, redirect policy and image/size/status checks. Do not add firmware checksum/signature fields to Firebase metadata without explicit approval.

## App behavior and product constraints

- BLE P1: service `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`, RX `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`, TX `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- Firmware telemetry, not command ACK alone, is authoritative for physical state. When disconnected, physical values should remain unknown (`--`) rather than fabricated.
- Preserve bilingual English/Indonesian copy, latest-event Home NOTIFY, the no-standalone-Battery-Protection-Guard UI rule, Floating Monitor metrics B/H/V/A/P/F with Fan speed under F, and settings/storage compatibility.
- BLE App-only authorization remains BLOCKED / NOT IMPLEMENTED until trusted backend enrollment/signing is designed and implemented; encrypted/bonded writes and `SYNC_READY` are not proof of official App identity.

## Commands and authorization

- `@Thinking Diskusi!`: technical discussion. No executable source/config/workflow edits, build/release, firmware/BIN/Firebase, OTA, flashing or device operations. After a substantive discussion concludes, documentation-only checkpoint and canonical memory updates are allowed and expected.
- `@Thinking Eksekusi Full!`: perform the specifically approved source/docs/tests/static-audit task and commit to main. It does not authorize App Build/APK release, Firmware compile, BIN publication, Firebase production changes, OTA, flashing or physical-device work.
- `@Thinking Eksekusi Build App!`: sole end-to-end App Build/QC authorization. Follow the live guarded workflow and update `APP_BUILD_REPORT.md`.
- `@Thinking Chat Stuck!`: recover the last valid authorized operation from live logs/state without blind retries or widening scope.
- `Tanya Gemini!` and `Jawaban Gemini!` require `Diskusi!` in the same command. Retired commands remain invalid.

## Chat-limit LOAD + CONTINUE — no recap stage

- General/Discussion replacement chat: use **Prompt B** in `CHAT_TRANSFER_PROMPTS.md`. It reads this checkpoint + live repository and resumes the prior workstream without a recap-only chat.
- Build App replacement chat: use **Prompt D** once. It reads live source, workflow and `APP_BUILD_REPORT.md`, then resumes the same authorized Build App operation.
- **Prompt A is only for a requested full memory reconciliation**, not default chat-limit recovery.
- After each substantive Discussion reaches a conclusion and after each execution completes/blocks, update this checkpoint and relevant canonical note(s). During an ongoing execution, save durable milestones and blockers when they become known. A hard interruption before a checkpoint write can leave the latest unsaved chat content unavailable; recovery must be honest about that boundary.

## Canonical references

- Current-only state: `PROJECT_STATE.md`; quick index: `MEMORY_INDEX.md`; immediate handoff: `HANDOVER.md`.
- App/UI/BLE: `APP_NOTES.md`; hardware/firmware: `FIRMWARE_NOTES.md` and `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`.
- OTA: `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`; voltage/Peltier transitions: `VOLTAGE_TRANSITION_MEMORY.md`.
- Build/release: `BUILD_NOTES.md`, `APP_BUILD_REPORT.md`, `.github/workflows/jexfyz-app-build-trigger.yml`.
- Design constraints: `DESIGN_NOTES.md`; history: `CHANGELOG.md`; permanent rules and prompts: `CHAT_RULES.md`, `CHAT_TRANSFER_PROMPTS.md`.
- `archive/` is immutable forensic history. Never treat an archived “CURRENT” statement as present truth.

## Canonical document fingerprints — fetched from live main before final checkpoint commit

These fingerprints identify the exact document blobs available to this handoff, except for `CHAT_TRANSFER.md`, whose own future SHA is deliberately not embedded in itself. Re-fetch current files before relying on a saved fingerprint.

| Canonical file | Blob SHA |
|---|---|
| `README.md` | `45273eeaaec10647b17eb0ae85a88785a77c107c` |
| `MEMORY_INDEX.md` | `4b57591a24b49355e2a6a803839c10d551beea9d` |
| `CHAT_RULES.md` | `e9d604be6cab986aba95a047b669f397776830dd` |
| `CHAT_TRANSFER_PROMPTS.md` | `a5c3f773cdc7bf78f5246652ebdbc83d24320795` |
| `PROJECT_STATE.md` | `a7de1e167ca1386d48ed58435dfff7b03cb7f9a1` |
| `HANDOVER.md` | `db9ab829587772bc7451bfd1d49c74178127d4eb` |
| `APP_NOTES.md` | `01756fae059d278756f4f036d07884ee599b317c` |
| `FIRMWARE_NOTES.md` | `99b7cc2eab66f79d51dae84a52c5067536f0d83d` |
| `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` | `6ef87b4dd39d591f10f5acbe57326c03eca9169d` |
| `OTA_PROTECTION.md` | `cbe7db07eeebe80e49bb4bf8cf16be396c4d6875` |
| `OTA_REGRESSION_MEMORY.md` | `5d425baab7203db0d66eed90ed21f68c961cbe38` |
| `VOLTAGE_TRANSITION_MEMORY.md` | `efd0d8e45dc333179724e7be0baee54e84fb1074` |
| `BUILD_NOTES.md` | `2a1c0145aaebcd0327086f6ee8c6647cff25b576` |
| `APP_BUILD_REPORT.md` | `779faeaccc8a14002579ab0b1ccc5b0b05e908ed` |
| `CHANGELOG.md` | `f53397a2a4bb5e27fd73083202eafc833a8d7fe6` |
| `DESIGN_NOTES.md` | `3abb9a0b328ab981745dfc9eea4813edbf5d738e` |
| `BLE_APP_AUTH.md` | `18894247559a4a21566cc03f4dee6301e7d18028` |
| `.github/workflows/jexfyz-app-build-trigger.yml` | `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12` |

## Current source/test fingerprints

- Firmware: `firmware/JEXFYZ-V7.1.ino` `c44e076b2c1ee2d0b66b4fcd308d0febc69976e9`, `FW_VERSION="V7.1"`; exactly one active versioned sketch exists.
- App release source: `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`; source blobs in Build #124: `lib/main.dart` `2d44e1f1f5b88ca1dae8324082da751b6ef1485a`, `lib/app_settings.dart` `637c07be55c412451d9ffde762e080c8bd92fd5e`, `test/widget_test.dart` `90e1a582c49ce3ad1a1d9a3b875921098eaf2545`.
- Current contract tests: `test/app_protocol_notify_contract_test.dart` `cd56576d440f3c23d9f340755b522fe12d997156`; `test/firmware_qc_contract_test.dart` `367acddd4ca9123c2834f8a5177039d9dadaabc9`; `test/firmware_touch_adaptive_sync_test.dart` `dfa1f604327f1705b52134aa794d7ce60232841e`; `test/floating_monitor_layout_contract_test.dart` `1159ac2970381cd6811a7a4a84c9d92321080f7b`.
- Android Gradle preserves `versionName "Telegram @horizontalzzz"`. Build workflow SHA is above; it remains issue-triggered only, not push/PR triggered.

## Latest maintenance decision — defer APK optimization (2026-10-21)

- The owner cancelled the proposed APK-size/performance optimization and unused-file cleanup. The current APK works; avoiding unnecessary regression risk on the sold/shipped product is the priority.
- Keep Build #124 + Firmware V7.1 as the production baseline. Do not remove assets/dependencies, split APKs by ABI, refactor the app, or make size/performance changes without a new explicit request tied to a concrete issue or measurable need.
- This decision does not authorize source edits, tests/builds, firmware compilation, BIN/Firebase changes, OTA, flashing, or device operations. Reconsider only if a real problem or requirement appears, using baseline measurements and a narrowly scoped, reversible plan.

## Pending user-requested work — Settings UI scale, BLE-gated Floating Monitor, bilingual notifications (audit only)

- Owner requested three App-side fixes under `@Thinking Diskusi!`: (1) make all Settings UI use the same physical-size/DPI lock as Home and audit every unlocked route/modal; (2) hide the Floating Monitor overlay whenever the cooler BLE session is disconnected, then restore it automatically after a fully synchronized reconnection if the user had enabled it; (3) professionalize all phone-notification copy in English and Indonesian.
- **Current Home lock:** `DashboardScreen.build` wraps its own body in `MediaQuery.copyWith(textScaler: TextScaler.noScaling)` and a 360-dp `Transform.scale` canvas. The separate `SettingsPage`, `LanguageSettingsPage`, `AppearanceSettingsPage`, `NotificationsSettingsPage`, `BluetoothSettingsPage`, and `FloatingSettingsPage` routes in `lib/floating_monitor.dart` do not use that shell. Root-navigator surfaces such as the BLE connection sheet, firmware update dialog, Peltier-safety dialog, and LED color picker likewise need to be audited/wrapped consistently; disabling text scaling alone does not lock physical dimensions against Android display-size/DPI changes.
- **Floating Monitor issue:** `DashboardScreen._handleBleDisconnected()` publishes disconnected telemetry, but native `FloatingMonitorService.applyData()` currently updates/redraws values without removing the overlay. More importantly, `FloatingSettingsPage._syncRuntimeState()` can treat an intentionally detached overlay as a runtime failure and persist `enabled=false`, which would destroy automatic restore intent. Separate the user's desired-enabled setting from runtime visibility; hide/detach while BLE is down and recreate only after the App confirms the full BLE/P1 synchronization (`connected=true` after the session gate), while respecting Android overlay permission and never starting an overlay offline.
- **Notification audit:** Bluetooth push bodies currently use generic “Bluetooth connected/disconnected” copy; Hotside title/body are already bilingual. Firmware-update-available push currently uses a localized title but its body is only the raw version string. Android notification channel names/descriptions are hard-coded English; the persistent background channel needs the same language audit. OTA result summaries are formatted bilingually, but cached `pendingOtaNotice` can be generated before language changes, so verify the body is re-rendered in the currently selected language at send time. Keep raw protocol/error tokens out of user-facing messages.
- **Notification ID collision:** the Hotside alert is posted from Flutter with ID `2101`, which is also `JeForegroundService.NOTIFICATION_ID` for the persistent BLE-session notification. Android identifies a notification by the app plus tag/ID pair, and `startForeground(id, ...)` uses that NotificationManager ID; a same-ID alert can replace the foreground notification. Reserve separate IDs for ongoing services versus transient push alerts and add a uniqueness contract test. Reference: [NotificationManager.notify](https://developer.android.com/reference/android/app/NotificationManager#notify(int,%20android.app.Notification)) and [Service.startForeground](https://developer.android.com/reference/android/app/Service#startForeground(int,%20android.app.Notification)).
- Proposed verification: shared fixed-canvas widget tests across changed logical widths/system text scales; route/sheet/dialog lock audit; Floating Monitor tests for offline hide, persisted user intent, valid reconnect restore and explicit user disable; bilingual notification tests for every push title/body and channel text. Test the boundary between link-connected and fully synchronized BLE session.
- **Status: AUDIT COMPLETE / IMPLEMENTATION PENDING.** This was a Discussion-only pass: no source, test, workflow, firmware, Firebase, build, BIN or OTA change was made. Implement only after the user issues the applicable execution command. Do not combine these changes with APK-size optimization, which the owner explicitly cancelled.

## Last completed task — repository hygiene and LOAD + CONTINUE handoff

- Current-state docs and navigation were reconciled with the owner's Build #124 / Firmware V7.1 deployment confirmation, while preserving separate independent-evidence labels and dated history.
- Added explanatory comments to source/test/config files that lacked clear file-level contracts; exact comparison with pre-cleanup blobs proves the edits are comment-only. Protected behavior and executable logic were not changed.
- General chat-limit recovery now uses Prompt B to LOAD + CONTINUE; Build App retains Prompt D; Prompt A is reserved for explicitly requested full memory reconciliation.
- The change series from `ca143274994316ebfee6195b47c59bab9cd1b3bb` to pre-checkpoint HEAD `6e056ee3ccea1e9e2c96cd50dd9a41d761072d3d` contains documentation reconciliation plus explanatory comment additions only in firmware/native helper/test/config files; it did not alter runtime statements or protected OTA logic.
- Final correction records that V7.1 still lacks the requested rapid Hotside-rise/slope shutdown and manual-rearm feature. This remains an unimplemented user requirement; do not imply it is part of Adaptive Fan target bands.
- No tests/build/analysis/compile/release/BIN/Firebase/OTA/flash/device operation was run by this maintenance task. Next step: load live main and await the user's next specific request; do not start discretionary product changes.
