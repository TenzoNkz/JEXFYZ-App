# JE X FYZ / JE Cooler — Current Handover

Updated: 2026-10-23 (Asia/Jakarta).

## Production checkpoint

The owner confirms that the deployed Android App is Build #124, Firmware V7.1 was compiled and successfully updated via Online OTA, and the unit has been sold and shipped. This is USER-REPORTED product/deployment status. The unit is unavailable for routine physical disassembly or repair, so future maintenance must prioritize preserving OTA and remote recovery.

## Latest independently verified App release

- Build #124 / Actions run [39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061)
- Packaged source commit: `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`
- APK SHA-256: `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`
- Source ZIP SHA-256: `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`
- Build passed 116 Flutter tests and configured App gates; native Android JUnit tasks were NO-SOURCE.
- App CI does not prove physical BLE, cooling, safe thermal response, source-to-BIN identity or in-field OTA behavior.

## Active editable Firmware baseline

- `firmware/JEXFYZ-V7.1.ino`, `FW_VERSION="V7.1"`.
- User confirms compile + Online OTA succeeded. Do not mislabel the deployed product as uncompiled based on stale notes. Do not claim independent BIN provenance or device validation without evidence.
- Preserve Adaptive whole-degree target bands and immediate raw-decimal Hotside safety, current Touch/P1 semantics, cooperative timing, Peltier/rail sequence, BLE radio ownership and OTA flow.
- `TenzoNkz/JEXFYZ-Firmware` is binary-only, containing `JEXFYZ.cpp.bin`; never replace or inspect the payload during cleanup.

## Latest source-only App maintenance — 2026-10-23

- Explicit @Thinking Eksekusi Full! authorized source changes directly on main for fixed-DPI Settings canvas, generic bilingual Device/Perangkat wording, BLE-gated Floating Monitor visibility and notification ID/channel hygiene.
- Home brand header remains JE X FYZ. Existing Android channel IDs and BLE service/UUID matching are preserved.
- Floating Monitor is sent an offline snapshot immediately at Dashboard startup, hides while telemetry says disconnected and restores only after Dashboard full sync; startup of the native service includes current telemetry. Saved user preference survives disconnect and missing overlay permission.
- Alert IDs 2101–2104, ongoing BLE notification 2110, and Floating Monitor 2301 are distinct. Alert, BLE foreground-service and Floating Monitor channel names/descriptions sync to the selected App language on startup and language changes. OTA notifications render in the current language; no OTA protocol or transport protection was edited.
- Static contract tests were added/updated, but tests, analysis/formatting and Android compilation have not run. No App Build/release, firmware compile, BIN/Firebase production write, OTA, flash or device action occurred. Preserve Build #124 / Firmware V7.1 baseline.

## Next action and limits

No firmware update, OTA, App Build, release, Firebase edit, BIN publication or physical-device action was performed for this source-only maintenance. Inspect live main/workflow/source before the next authorized task. For future changes, prefer documentation-only or isolated App improvements; any change that can affect BLE/OTA requires an explicit rationale, regression review and the appropriate authorization.

## Chat-limit recovery

- General / Discussion: Prompt B in `CHAT_TRANSFER_PROMPTS.md` — LOAD + CONTINUE from this checkpoint and live repository; no recap-only chat.
- Build App: Prompt D — load current workflow and `APP_BUILD_REPORT.md`, then continue the same authorized Build App operation without a second start command.
- Prompt A is only for a requested full project-memory reconciliation.
- Checkpoint after substantive Discussion conclusions and after each execution completes or blocks. A hard limit may interrupt before a write; always be honest about the last persisted point.

## Canonical routing

`CHAT_RULES.md` governs commands/authorization; `MEMORY_INDEX.md` routes all topic contracts; `PROJECT_STATE.md` is current-only; `APP_NOTES.md` owns App/UI/BLE; `FIRMWARE_NOTES.md` and `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` own firmware/hardware; `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` own OTA; `BUILD_NOTES.md` + `APP_BUILD_REPORT.md` own App release evidence; `CHANGELOG.md` is historical.
