# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-10-14 (Asia/Jakarta). This file is current-only; refresh the live repository before relying on it. History belongs in CHANGELOG.md; exact pre-cleanup copies are in archive and must not be treated as current.

## Current release phase
- **Phase:** DEVELOPMENT + QC / PRE-RELEASE.
- **Release state:** NOT RELEASED.
- **Active Firmware source:** firmware/JEXFYZ-V6.6.ino.
- **Firmware constant:** FW_VERSION = "V6.6".
- **Firmware source blob last observed:** f51ba6db5d0e91318f63fea4014bb87f7bf76222.
- **Active App source:** lib/main.dart, current blob 6012d2e2d60dcbf2c5a816c78e63edbfb04b44c2.
- **Package/version:** com.horizontalzzz.jexfyz, pubspec 1.0.0+3.
- **Android identity:** Gradle versionName "Telegram @horizontalzzz"; intentional, preserve exactly.
- **QC contracts:** test/v6_6_qc_contract_test.dart, test/firmware_touch_adaptive_sync_test.dart, test/app_protocol_notify_contract_test.dart, test/widget_test.dart. Test execution must be checked independently.
- **Current App/UI hashes:** `lib/main.dart` = 6012d2e2d60dcbf2c5a816c78e63edbfb04b44c2; `lib/app_settings.dart` = 232a7575460e5417f7b760f24b5057687a47ee1a; `test/widget_test.dart` = c8780386edcf8e6dfbff965fbba4ff2e8541655f; `test/v6_6_qc_contract_test.dart` = 2bee4d960d014f0765422dcb5ed1c9870ba6ee3a; `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt` = 6c17a7e38c3a5b3f3f8fc6b3e5b38a99fd83081e; `JeForegroundService.kt` = 9ea4dce7001bcd5cc10f9c1c7ad62f34ec54b03e; `FloatingMonitorService.kt` = 55972b64329a2e1cc91e29a172d0a97a118d8ac1; `JexNotificationUtils.kt` = d0b2d7cadd2c87f2807d9a6c8414962799ccc906; `drawable/ic_notification.xml` = d62800ff34ed3e63946871b0f9b811c5b40341a6.
- **Workflow:** .github/workflows/jexfyz-app-build-trigger.yml; explicit title/token trigger only.
- V6.6 has not been independently compiled or hardware-tested by the assistant. User-reported V6.3 compile/Online OTA connection success refers to the prior revision and does not certify V6.6.
- Do not infer that the existing artifact BIN matches current V6.6 source; source/BIN provenance remains unverified.
- Latest checked open-PR search returned zero results. Fetch live state before acting.

## Current V6.6 Firmware behavior

### Rail transition / Peltier ramp
- If Peltier is logically OFF, rail changes must not turn it ON.
- Adaptive ON/OFF still returns the selector to safe 5 V, but does not force Peltier OFF solely for the handoff. The existing voltage handler pauses only an active soft-start; a completed ramp remains at 100%. Explicit OFF and Hotside/NTC/OTA safety still override.
- During a normal Manual Volt or Adaptive transition accepted while the 5-second soft-start is active, pause GPIO5 PWM at 0% before selector outputs change; preserve 200 ms break-before-make; remain paused during the existing 1-second settle; then start a fresh full 5-second ramp.
- When the 5-second ramp is complete, keep Peltier PWM at 100% continuously through the transition; do not force 0% or add another ramp just because voltage changes.
- Fan stays ON/forced 100% during the handoff. Peltier-OFF, Hotside/NTC safety and OTA safe-output cancel pending ramp resume.
- User reported a restart when changing 5 V→12 V with Peltier/Fan ON during active soft-start. Supply transient/brownout is unconfirmed; collect BOOT: RESET_REASON=... if reproduced.
- A separate earlier user report described a restart when enabling Adaptive at 12 V with Peltier/Fan already ON; exact reset reason and any shared root cause are unknown. Do not merge the two reports into one confirmed cause.

### LED mode and App/firmware synchronization
- Firmware V6.6 supports Static (1), Breath (2), Comet (4), Dual Chase (5), Left/Right (6), and Rainbow (7). ID 3 is retired; persisted ID 3/invalid values migrate to Static, and new mode-3 commands are rejected.
- Firmware publishes one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple calculated at BLE notify time; App interpolates monotonically between snapshots and corrects drift without restarting the animation for every update.
- LED preview uses a compact row: left arrow, four left pixels, centered localized mode name only (no numeric index), four right pixels and right arrow. Static/Rainbow cores remain full-colour independently of hardware Brightness. Comet/Dual Chase use pale neutral pixels where the animation has no active LED; selected colour and glow follow the animation phase. The 36-preset localized Color Picker remains a separate menu but opens in the display-menu region instead of screen center; hue ordering, aliases and no-HEX presentation remain unchanged.
- App tests and firmware contract tests were updated but have NOT been run. V6.6 has not been compiled or physically validated; artifact BIN remains unchanged and provenance is unverified.

### Thermal / Adaptive safety
- Hotside limit: 40–50°C, default 45°C; NTC is authoritative.
- One calibrated ADC sample per second. No median/trimmed/multi-sample filter.
- Manual Peltier re-arm needs Hotside <= hotLimit - 1°C for 5 continuous seconds.
- Adaptive protection: 30-second stage at 12 V/9 V/5 V, Peltier OFF and Fan 100%; five stable seconds at/below hotLimit - 1°C before deadline cancels stage; otherwise step down one rail at 12/9 V or enter terminal manual-restart lock at unrecovered 5 V.
- After thermal step-down, one-step upward restoration needs 60 continuous seconds at/below hotLimit - 1°C, capped by the saved pre-downshift ceiling.
- V6.6 does not implement rapid Hotside rise/slope protection. A previous user request for immediate Peltier shutdown/manual re-arm on very rapid temperature rise is preserved as an unimplemented requirement, not current functionality.
- HOTSIDE is startup default; HOTSIDE_BATTERY is runtime-only. Battery loss falls back to HOTSIDE behavior without silently changing profile.

### OTA
- V6.3-origin correction remains in V6.6: Online OTA uses cloudClient.setInsecure(); embedded CA validation and OTA-only NTP/TIME_SYNCING gate are absent.
- Blue feedback after Wi-Fi connection leads into GitHub GET. Raw GitHub BIN URL allowlist, redirect blocking, status/length/size/image checks, safe outputs, update lifecycle and failure recovery are protected.
- Boot Local OTA SoftAP currently owns the single radio with a 10-second no-client timeout and 60-second hard limit after interaction; Wi-Fi shuts down and settles 160 ms before BLE owns the radio. This is a source-derived timing contract and must not be retuned during unrelated changes.
- setInsecure() bypasses server certificate identity validation; this is a known security trade-off.
- User reported the prior V6.3 source compiled and GitHub connection recovered. Full download/apply, restart and installed-version confirmation remain unverified.
- Read both OTA memory documents before any related edit.

## Phone Battery input / App display requirements

- [SOURCE VERIFIED] App reads Android Battery temperature through `je_x_fyz/battery_temp` and sends `PHONE:BT=<Celsius>` at a one-second heartbeat while BLE is ready; pending heartbeat messages are coalesced.
- [SOURCE VERIFIED] Firmware Battery input has a 5-second freshness TTL and 0.5°C Battery-zone hysteresis. Current configured zone defaults are 5 V = 25°C and 12 V = 35°C. If Battery data becomes stale, HOTSIDE_BATTERY runtime control falls back to HOTSIDE without silently changing the selected profile.
- [USER REQUIREMENT] Do not display a standalone Battery Protection Guard badge/status in App UI. Do not weaken thermal safety or suppress independently actionable, localized safety/Notify messages.
- [USER DESIGN REQUIREMENT / ENFORCEMENT UNVERIFIED] Pairing intent is one authorized App identity/key-lock relationship per cooler firmware. Current source proves encrypted/bonded writes but exclusive one-App provisioning/lock and physical pairing behavior are not established here.

## Current App contracts
- Firmware telemetry owns physical state; ACK alone is not proof of hardware state.
- Voltage completion requires matching VOLTAGE telemetry.
- Home/dashboard and Floating Monitor telemetry show unknown values (`--`) while BLE is disconnected. CONTROL/ADAPTIVE/LED menu switch rows instead show a disabled OFF-looking fallback toggle positioned left; this is presentation only and must not be interpreted as physical output telemetry.
- Auto Connect/reconnect respects preference, known cooler identity, Bluetooth/permission/location prerequisites and syncing state.
- Ambiguous OTA ACK timeout/disconnect preserves recovery state until reconnect/result; only definite rejection while BLE remains connected permits rollback.
- User-facing text is localized; internal protocol tokens are not exposed.
- Android notifications use the real transparent `jexfyzicon.png` as the sole small icon (rendered through Android's alpha mask), with no large icon on the right. The legacy `ic_notification.xml` X vector is retained but unused by the notification builder. Event/status remains the localized body beneath the JE X FYZ title, tap opens the App, and BLE/Floating Monitor foreground notifications have meaningful non-empty descriptions. Android 13+ asks for permission at the first actual notification attempt.
- Touch Adaptive-OFF publishes authoritative Adaptive/ceiling/Fan/Peltier/Fan-speed state deltas before acknowledgement.

## Current UI execution status
- Source changes now include the actual JE X FYZ transparent logo asset as the single notification small icon (no large icon), pale inactive Comet/Dual-Chase preview pixels, display-anchored standalone Color and Peltier Safety menus, and seven redesigned smooth dashboard indicator animations.
- New widget/source-contract tests cover preview colour behaviour, menu anchoring, animation timing, and notification icon exclusivity. Flutter tests/analyze have NOT RUN in this environment because Flutter/Dart SDK is unavailable; Android OEM rendering, narrow-screen layout, and actual device appearance remain UNVERIFIED.
- The user reported a successful App build and in-place installation before these latest UI changes. That report does not certify the current source commit; no APK was built or published for this change set.

## App Build
- Only active workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- The latest observed successful App Build run is `38520146994` on commit `1024eb8e145429913aacb52f4cf352e087885d44` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38520146994). It predates the current UI/notification source commit and is NOT a fresh build/test certification of current `main`.
- Trigger title: JE X FYZ — BUILD APP TRIGGER; body token JEXFYZ_BUILD_TRIGGER_V1.
- Toolchain last recorded: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, Ubuntu 24.04.
- Intended output: one obfuscated, production-signed ordinary APK named JEXFYZ-release.apk, uploaded to GitHub Release jexfyz-latest. No Play Store bundle or Actions artifact.
- Do not trigger except explicit @Thinking Build App! or @Thinking Eksekusi & Build App!.

## Exact validation gates still open
1. User-side ArduinoDroid + Core 3.3.7 compile of V6.6 and confirmation of source/version/BIN provenance.
2. Physical active-ramp transition QC in Manual Volt and Adaptive.
3. Physical completed-ramp transition QC: continuous 100% PWM.
4. Peltier-OFF/safety cancellation, Hotside latch/re-arm, NTC invalid response and Adaptive thermal/recovery QC.
5. Flutter test/analyze if authorized; no recent passing result is implied.
6. Physical BLE/P1 pairing/reconnect and Touch telemetry UI QC.
7. Local OTA; Online OTA transfer/apply, reboot, BLE recovery and installed version.
8. Only after required gates, consider a separately authorized release flow.

## Repository split / operation boundary
- All source and memories live in TenzoNkz/JEXFYZ-App.
- TenzoNkz/JEXFYZ-Firmware must contain JEXFYZ.cpp.bin only; its notes were removed during this cleanup and the BIN was not touched. The last observed artifact root contains only the BIN; verify its live path/blob before any future publication.
- This documentation cleanup did not change functional source, run tests/build, compile Firmware, generate BIN, update Firebase, flash/OTA hardware or release.
