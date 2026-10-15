# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-15 (Asia/Jakarta). This is a working checklist, not authority over live GitHub state. Re-fetch HEAD, tree, current source hashes, Actions and release before acting.

## Current code and release state
- **Current source checkpoint:** `b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b`; Floating UI `232fde06efda5bfaa2221825a04c0106ad5feb33`; app settings `6f99911bc59451473823aea91efe5377a0b6d0d1`; widget tests `520399fcdc6be4fd69cb48f50aa8961f5d9183c5`; Shizuku contract test `bd27d2c7adc20ab76bab504378a2353d01ab473b`. Source is committed, but tests/analyzer/Android build have NOT run.
- **Last successful Build App:** [Build #49 / run 38739077916](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38739077916), source `2b2d2886abb66481b7134e5036824f625ab5659d`; all 80 tests and release gates passed for older source only.
- **Current release:** `jexfyz-latest` contains Build #49's APK and matching source ZIP; neither contains Shizuku FPS migration source.
- **FPS design:** metric F requires Shizuku running, supported Binder/UserService and explicit user approval. Fixed FPS operations execute via AIDL UserService; old Wireless ADB/Kadb/SPAKE2/identity-store/grant-revoke UI was removed.
- **Build workflow:** `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`; trigger gate unchanged; Shizuku/MIT audit and source ZIP updates NOT RUN.
- **Tests:** widget assertions and the Shizuku FPS contract test are committed but NOT RUN. `@Thinking Chat Stuck!` does not trigger a build; use `@Thinking Eksekusi Build App!` only when separately authorized.
- **Physical validation remains unverified:** phone UI, Shizuku permission/Binder/UserService, live foreground FPS, overlay lifecycle, BLE/cooling/safety. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Current App motion contract

- Fan indicator follows authoritative BLE voltage: 5 V = 2600 ms, 9 V = 1250 ms, 12 V = 620 ms; voltage changes preserve angular phase. Fan OFF coasts forward and settles at a full stop; blades/hub stay full colour.
- Peltier indicator is a six-branch crystal with no square module frame/center box/bolts. While ON, motion and voltage-class frost interpolation run; OFF freezes the full-colour crystal without fade. This is decorative UI, not a physical ice/temperature measurement.
- Fan Speed gauge retargets from the current rendered value to each new target over 420 ms; OFF eases to zero over 520 ms. The reported percentage remains authoritative. Integer-frequency wobble is continuous at its cycle seam.
- Voltage sheen sweeps sinusoidally back and forth. Bluetooth ripples use a squared-sine opacity envelope that reaches zero with zero slope at loop boundaries.
- Color Picker: 36 localized hue-ordered presets with no HEX text, bottom pinned. Swatches stage a local draft only; the localized top-right Select sends the confirmed COLOR command and closes only after success. The top-left Cancel discards the draft. Outside taps and Android system Back are blocked, so only the action buttons close the dialog. Updated source regression assertions cover these contracts, but they have not been run; physical behavior is also unverified. Existing Fan-before-Peltier confirmation is unchanged. Notification branding is a transparent white JE vector small icon, with no large icon. See `APP_NOTES.md` and `DESIGN_NOTES.md`.

## Firmware/hardware boundary

- Active editable source: `firmware/JEXFYZ-V6.6.ino`, blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`, `FW_VERSION = "V6.6"`; exactly one active versioned `.ino` is expected and filename/version must match.
- User acceptance (2026-10-14): user considers V6.6 final/correct and reports successful compile plus two successful Online OTA updates on the same V6.6 version. This is **USER-REPORTED**, not an assistant-witnessed compile/OTA log. Source-to-BIN provenance is **UNVERIFIED**. Do not change/recompile/reflash Firmware or change Firebase/BIN without separate explicit authorization.
- ESP32-C3 Super Mini, 3.3 V; pins GPIO0 NTC, 1 TTP223, 3 12 V selector, 4 9 V selector, 5 Peltier MOSFET, 6 Fan MOSFET, 7 WS2812. NTC 10 kΩ + 10 kΩ divider, Beta 3950, calibrated `analogReadMilliVolts`, one sample/sec (user explicitly rejected median/trimmed/multi-sample filtering).
- Hotside limit 40–50°C/default 45°C; Peltier OFF→ON 5 s ramp; manual re-arm <= hotLimit−1°C for 5 continuous seconds. Adaptive 30 s thermal stage at each voltage, Peltier OFF/Fan 100%; recovery rules are in `FIRMWARE_NOTES.md` and `VOLTAGE_TRANSITION_MEMORY.md`. No rapid Hotside-rate protection is implemented in V6.6.
- Selector 200 ms break-before-make; shared 1 s voltage settle; during an accepted transition only an active soft-start is paused, then restarted after settle; a completed Peltier ramp remains 100%; a Peltier that was OFF stays OFF. Safety/OFF/OTA may cancel resume.
- Two distinct reset reports remain unverified: 5→12 V while loads were ON during active ramp, and enabling Adaptive from 12 V with Fan/Peltier ON. Reset reason unknown; brownout is only a hypothesis. Adaptive-OFF white three-blink missing after restart was also reported; boot-time indication is not physically verified.
- App phone Battery heartbeat is 1 Hz; firmware TTL 5 s, zone hysteresis 0.5°C; zones currently 25°C at 5 V and 35°C at 12 V. Do not show a standalone Battery Protection Guard UI. The one-App/one-cooler lock is a design requirement; exclusive enforcement is unverified.

## OTA and repository safety

- OTA protected files/notes: read `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md` fully before any OTA changes; read `VOLTAGE_TRANSITION_MEMORY.md` before rail/Peltier timing edits. ESP32-C3 has one radio path; current Local OTA SoftAP uses a 10 s no-client timeout, 60 s hard cap after interaction, then Wi-Fi shutdown and 160 ms settle before BLE.
- Online OTA currently uses `cloudClient.setInsecure()`; this bypasses server certificate identity validation. The earlier CA + NTP-gated path was removed together after user-reported blue-then-red failure; the precise root cause was not isolated. Do not infer HTTP/TLS error codes from LEDs.
- App repo owns all docs, memory, source and transfer prompts. `TenzoNkz/JEXFYZ-Firmware` must contain `JEXFYZ.cpp.bin` only. Last verified artifact tree had exactly that file (blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes); verify live before future actions. Provenance to V6.6 remains unverified.

## Permanent command protocol and authorization rules

- `@Thinking Diskusi!`: full discussion/analysis only; no repository writes.
- `@Thinking Diskusi! Tanya Gemini!`: prepare one complete Gemini prompt from the agreed discussion.
- `@Thinking Diskusi! Jawaban Gemini!`: evaluate the user's pasted Gemini answer against source and project memory. Either Gemini subcommand without `Diskusi!` in the same command must be rejected without processing its substantive content.
- `@Thinking Eksekusi Full!`: full approved implementation, related audit/tests/docs/memory verification and commit. It does not imply Build App.
- `@Thinking Eksekusi Build App!`: end-to-end App Build, justified App-scope fixes/retries, successful artifact/release verification and mandatory `APP_BUILD_REPORT.md` update. When this Build App chat reaches context limit, use Prompt D in `CHAT_TRANSFER_PROMPTS.md` once as the replacement chat's opening message; it loads and continues from evidence, with no separate recap chat.
- `@Thinking Chat Stuck!`: standalone emergency recovery command. Inspect logs/live state, stop blind retries, resume only the last authorized task from its checkpoint and report RECOVERED/BLOCKED/FAILED. No automatic build or new permissions.
- Retired aliases: `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid; use `@Thinking Eksekusi Build App!` for the complete App build cycle.
- Build uses issue title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; re-read workflow before triggering.
- Build App does not authorize Firmware compile/source change, BIN/Firebase mutation, physical OTA, flash, device operations or unrelated releases. User compiles Firmware.
- Preserve Gradle `versionName "Telegram @horizontalzzz"`. Work directly on `main`, no PR/branch unless requested.
- Report verified results only; distinguish CI from physical-device validation.

## Exact next QC actions (only when separately authorized)

1. Install the latest Build #49 APK and inspect MT Manager's signature display. CI verified V1/V2/V3 and the production certificate, but MT Manager's exact on-device signature interpretation is still unverified.
2. On device verify Fan coast-down/full colour, Peltier crystal OFF pose, repeated/mid-transition Fan Speed target changes, OFF-to-zero, needle wobble seam, voltage sheen and Bluetooth ripple loop boundary.
3. Build #49 has already run Dart analysis/tests and the complete official App Build/QC/release gates for source commit `2b2d2886abb66481b7134e5036824f625ab5659d`. Do not run a duplicate build without App source changes or a new explicit request. Pairing/FPS/overlay still need physical-device QA. On device verify notification permission prompt, Wireless Debugging mDNS discovery + RemoteInput pairing code, ADB connection and fixed DUMP grant, identity persistence/revocation/failure fallback; then verify Color Picker staged selection/Select/Cancel/outside/back, foreground FPS layer/parser, variable game FPS, overlay telemetry replay/background survival and connected/disconnected `--`. CI source contracts are not physical-device tests.
4. Do not reopen Firmware tasks unless the user explicitly changes their V6.6 final acceptance.

## Canonical references

Read `CHAT_TRANSFER.md` first at each new chat/context limit; use `MEMORY_INDEX.md` for routing. `PROJECT_STATE.md` is current-only; `CHANGELOG.md` is history-only; archive files are forensic-only and their embedded old CURRENT claims must not be copied forward.


## Historical Home UI implementation snapshot — 2026-10-15

- Full redraw of all seven Home indicator kinds is committed: battery thermal segments, non-overlapping Hotside thermometer, moving voltage sweep, Adaptive orbit/core, reduced Peltier crystal, Fan rotor with coast-down, and telemetry-retargeted Fan Speed gauge.
- Home Notify fallback badge now uses CONNECTED/DISCONNECTED (English) in both app languages; explicit errors and in-progress states remain unchanged.
- New temperature normalization and Notify-label regression tests were added but have NOT RUN. This is source execution only, not an App Build. Request @Thinking Eksekusi Build App! separately for Flutter tests/analyze, Android/Kotlin compile, release APK and signing/QC; then verify visual motion on a physical phone.
- No firmware source/BIN, Firebase metadata, OTA, flash, or device was touched.

- Follow-up static audit corrected the raw Dart Celsius regex and ensured ordinary "Bluetooth Disconnected" is treated as a connection status rather than an ERROR badge. Regression assertions cover both connected/disconnected state with this notice.

## CURRENT CHECKPOINT — Floating Monitor visual controls (2026-10-15)

- Floating Monitor remains freely draggable. The alignment change is inside the box only: horizontal metric groups are centered as a group, and vertical rows are centered individually. Native WindowManager gravity stays `Gravity.TOP | Gravity.START`; drag offset persistence is preserved.
- Native HUD spacing is tightened (5dp-scaled inter-metric gap, 8dp-scaled horizontal padding, 5dp-scaled vertical padding) and the corner radius is reduced.
- Size is normalized to `0.30×–0.80×` in `0.05×` steps, with current numeric value shown in the menu. Default is `0.60×`.
- Background Opacity covers `0–100%` (stored as normalized `0.0–1.0`), with live numeric percent and scale labels `0%`, `50%`, `100%`. At 0%, only the background vanishes; metric text remains visible.
- Background color is user-selectable Black/White, persisted with FloatingConfig and applied natively; foreground text and icons switch to a contrasting color. Default remains Black and Opacity remains 90%.
- Source/test blob hashes at this checkpoint:
  - `lib/floating_monitor.dart`: `3516b742d39e86c8796a0e77f77c0e9c1f1c1110`
  - `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`: `0c9cfdee776ca2f1de5daf2205d1f9f8da63683d`
  - `lib/app_settings.dart`: `46cc838f43a06c325af6f6832e200a4e1ed4f75d`
  - `test/floating_monitor_layout_contract_test.dart`: `31d9aabf4ac0839855308b6bd2a0708fa399a3a9`
- Source-level contract tests were added but are NOT RUN. No Dart analysis, Flutter test run, Android/Kotlin compile, APK build, release, workflow trigger or physical-device validation was performed. Build #49 remains the last verified APK and does not contain these changes.
- Firmware V6.6, firmware/BIN repository, Firebase, OTA, flash and physical device remain untouched.

