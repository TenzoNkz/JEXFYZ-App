# JE X FYZ / JE Cooler — Current Project State

Last updated: 2026-10-21 (Asia/Jakarta). This file is current-only state; use `CHANGELOG.md` for historical changes.

## Product and deployed baseline

- **App Build #124:** owner confirms this is the App used by the sold unit.
- **Firmware V7.1:** owner confirms it compiled successfully and was installed by Online OTA.
- **Product status:** sold and shipped; routine physical disassembly/repair is unavailable. Treat future changes as remote-maintenance work with a high bar for firmware/OTA safety.
- These compile/deployment facts are USER-REPORTED. The App release itself is independently evidenced by Actions run `39386733061` and package source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. Repository/App CI does not independently establish exact installed BIN identity, in-field boot/reconnect behavior or thermal/electrical behavior.

## Code and release baseline

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`. Fetch live HEAD and tree each time; do not treat the source SHA packaged in Build #124 as the current docs/source HEAD.
- Active Firmware source: `firmware/JEXFYZ-V7.1.ino`; embedded version `FW_VERSION="V7.1"`. Firmware artifact repository `TenzoNkz/JEXFYZ-Firmware` is BIN-only.
- Build #124 passed 116 Flutter tests and configured App release gates. Analyzer exit was 0 with 25 info-level diagnostics; Android unit-test tasks were NO-SOURCE. APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`, source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.

## Firmware operating contract — do not alter during cleanup

- Adaptive target bands relative to the configured Hotside limit: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%. At 40°C, exact bands are 40/39/38→100%, 37/36→90%, 35/34→80%, 33/32→70%, 31/30→60%, ≤29→50%.
- Raw-decimal protection remains immediate: Fan 100% and Peltier OFF at/above the configured limit. Adaptive ramp up is +10 points/second; down is −10 points/10 seconds; Adaptive 5 V/9 V stays at 100%.
- Maintain NTC one-sample-per-second calibration path, cooperative non-blocking loop, Touch/P1 behavior, Peltier/selector/rail timing, BLE/radio ownership, safe OTA outputs and failure/recovery logic.

## OTA and remote-maintenance policy

- Baseline is frozen for discretionary functional work. Prefer no release unless it fixes a concrete problem or is required for maintenance.
- Do not casually modify Local/Online OTA, redirects, allowlists, size/image checks, timeouts, Update lifecycle, restart or BLE-recovery logic. The current Online OTA path uses `cloudClient.setInsecure()`, which does not authenticate server certificate identity; retain the current chosen trade-off unless a specific authorized redesign is evaluated.
- App-only changes can still affect BLE, OTA command sequencing, URL/version handling, reconnect behavior and update UX. They require source review and the required App validation/release authorization.
- An App Build command does not authorize Firmware compilation/BIN publication, Firebase changes, OTA, flash or device operations. `@Thinking Eksekusi Full!` does not authorize the App Build pipeline.

## Current known blockers / evidence boundaries

- BLE App-only authorization is BLOCKED / NOT IMPLEMENTED: trusted backend enrollment/signing is missing. Encrypted/bonded BLE writes and `SYNC_READY` do not prove official App identity.
- Owner confirms V7.1 compile and successful Online OTA to the sold unit, but exact BIN-to-source provenance, independent installed-version query, physical reboot/BLE recovery and long-run thermal behavior are not independently observable from the repository.
- Do not claim a physical reset cause without `BOOT: RESET_REASON=...` or equivalent evidence. Hotside rate-of-rise protection remains an unimplemented historic requirement unless live source shows otherwise.

## Memory and handoff protocol

- `CHAT_TRANSFER.md` is a rolling checkpoint, not a long transcript recap. Keep it accurate and update it after a substantive Discussion concludes and after each execution completes/blocks.
- General/Discussion context limit: Prompt B in `CHAT_TRANSFER_PROMPTS.md` loads live state then continues without a recap stage. Build App context limit: Prompt D loads build state and `APP_BUILD_REPORT.md`, then continues the same authorized operation.
- Prompt A is reserved for explicit full-memory reconciliation. If interrupted before a checkpoint write, recover from the last saved point and verify live evidence; do not pretend unsaved content was saved.


## Latest maintenance decision — defer APK optimization (2026-10-21)

- The owner cancelled the proposed APK-size/performance optimization and unused-file cleanup. The current APK works; avoiding unnecessary regression risk on the sold/shipped product is the priority.
- Keep Build #124 + Firmware V7.1 as the production baseline. Do not remove assets/dependencies, split APKs by ABI, refactor the app, or make size/performance changes without a new explicit request tied to a concrete issue or measurable need.
- This decision does not authorize source edits, tests/builds, firmware compilation, BIN/Firebase changes, OTA, flashing, or device operations. Reconsider only if a real problem or requirement appears, using baseline measurements and a narrowly scoped, reversible plan.



## Pending user-requested work — Settings UI scale, BLE-gated Floating Monitor, bilingual notifications (audit only)

- Owner requested three App-side fixes under `@Thinking Diskusi!`: (1) make all Settings UI use the same physical-size/DPI lock as Home and audit every unlocked route/modal; (2) hide the Floating Monitor overlay whenever the cooler BLE session is disconnected, then restore it automatically after a fully synchronized reconnection if the user had enabled it; (3) professionalize all phone-notification copy in English and Indonesian.
- **Current Home lock:** `DashboardScreen.build` wraps its own body in `MediaQuery.copyWith(textScaler: TextScaler.noScaling)` and a 360-dp `Transform.scale` canvas. The separate `SettingsPage`, `LanguageSettingsPage`, `AppearanceSettingsPage`, `NotificationsSettingsPage`, `BluetoothSettingsPage`, and `FloatingSettingsPage` routes in `lib/floating_monitor.dart` do not use that shell. Root-navigator surfaces such as the BLE connection sheet, firmware update dialog, Peltier-safety dialog, and LED color picker likewise need to be audited/wrapped consistently; disabling text scaling alone does not lock physical dimensions against Android display-size/DPI changes.
- **Floating Monitor issue:** `DashboardScreen._handleBleDisconnected()` publishes disconnected telemetry, but native `FloatingMonitorService.applyData()` currently updates/redraws values without removing the overlay. More importantly, `FloatingSettingsPage._syncRuntimeState()` can treat an intentionally detached overlay as a runtime failure and persist `enabled=false`, which would destroy automatic restore intent. Separate the user's desired-enabled setting from runtime visibility; hide/detach while BLE is down and recreate only after the App confirms the full BLE/P1 synchronization (`connected=true` after the session gate), while respecting Android overlay permission and never starting an overlay offline.
- **Notification audit:** Bluetooth push bodies currently use generic “Bluetooth connected/disconnected” copy; Hotside title/body are already bilingual. Firmware-update-available push currently uses a localized title but its body is only the raw version string. Android notification channel names/descriptions are hard-coded English; the persistent background channel needs the same language audit. OTA result summaries are formatted bilingually, but cached `pendingOtaNotice` can be generated before language changes, so verify the body is re-rendered in the currently selected language at send time. Keep raw protocol/error tokens out of user-facing messages.
- Proposed verification: shared fixed-canvas widget tests across changed logical widths/system text scales; route/sheet/dialog lock audit; Floating Monitor tests for offline hide, persisted user intent, valid reconnect restore and explicit user disable; bilingual notification tests for every push title/body and channel text. Test the boundary between link-connected and fully synchronized BLE session.
- **Status: AUDIT COMPLETE / IMPLEMENTATION PENDING.** This was a Discussion-only pass: no source, test, workflow, firmware, Firebase, build, BIN or OTA change was made. Implement only after the user issues the applicable execution command. Do not combine these changes with APK-size optimization, which the owner explicitly cancelled.
