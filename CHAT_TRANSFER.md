# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Reconciled from live GitHub main after `@Thinking Eksekusi Full!` on 2026-10-20 (Asia/Jakarta). The working source includes earlier thermal-visual and English/Indonesian localization revisions plus an Adaptive Fan whole-degree target correction. Live `main` is authoritative; the Firmware update is source-only and not compiled/installed.

## 1. Authority and operation scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; continue directly on `main`, no branch/PR unless requested.
- `@Thinking Diskusi!` is read-only. `@Thinking Eksekusi Full!` authorizes only scoped source/tests/docs/static audit/commit; it does NOT authorize official App Build/release, Firmware compile, BIN publication, Firebase, OTA, flashing or physical-device operations. `@Thinking Eksekusi Build App!` remains the separate App Build authorization.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. `TenzoNkz/JEXFYZ-Firmware` is BIN-only; do not inspect or modify its payload.
- Latest successful App release is Build #120 / Actions run 39365201489, packaging commit `aeadaa47bd7ad64af6044afce5783781f0c0d82f`. It passed 115 Flutter tests and the configured release gates. APK SHA-256 `aa162e57a04f229922cca4fe48773a49585328e2337761f5c641097957ff0392`; source ZIP SHA-256 `3e7585549d2eef68ad93b35c378bd76332d80a92a0edf1856aec8303df5e28d7`. Build #120 validates only its packaged source, not this latest single-event NOTIFY patch.

## 2. Home visual and localization follow-up — source-only / NOT RUN / NOT RELEASED

- `lib/main.dart` blob: `07178b5cce55fc8f78cc7c2953f4d8e352ccefe7`.
- `test/widget_test.dart` blob: `0a5901ac6dc23c947356189a312bb1dec418298e`.
- Battery/Hotside use deterministic falling flame-shaped particles (not plain oval dots), with orange/gold body, warm yellow-white hot cores, soft halo, subtle drift/rotation and edge fading. Flames fall from the top like the Peltier snowfall.
- Fire draws as a background layer. The permitted path is the rounded painter frame minus the foreground thermal silhouette; the frame clip stops particles escaping rounded corners, and the foreground battery/thermometer casing remains above them. Existing Battery >=40°C and configured Hotside warning gates plus the 280 ms warning transition are unchanged. Peltier animation is not changed.
- Home Notification heading is localized as `Notification` / `Notifikasi` in the selected app language, with no `• ERROR`, `• STATUS`, `• SYNC`, `• WARNING`, or connection suffix. A 2 dp top inset lowers the label away from the card border. The card remains fixed at 44 dp, body remains up to two lines with only necessary font shrinking, Home metric rows stay 45 dp with a 3 dp gap before the card, and cooler-image constraints stay stable.
- Regression contracts cover flame paths, rounded-frame clipping, localized notification/contact labels and the top inset. Flutter tests and Dart analyzer were **NOT RUN** in this Full execution. Do not claim the latest changes are test-passing, built or released until separately validated.
- No App Build/release, Firmware compile, BIN inspection/publication, Firebase edit, OTA, flash, or device operation took place here.

## Localization copy pass — source-only / NOT RUN / NOT RELEASED

- Home heading: `Notification` / `Notifikasi`; Settings section: `Notifications` / `Notifikasi`; Contact Developer: `Contact Developer` / `Hubungi Pengembang`.
- Updated notification descriptions, Hotside terminology, palette labels, Bluetooth/firmware copy and Android Floating Monitor status text.
- Latest NOTIFY source blobs: `lib/main.dart` a167e884f765a8a9ef379108262c366c8bcdcf99; `lib/app_settings.dart` 44431e926bfa2557c26345899e2333bd767f3f8e; `test/widget_test.dart` 5cb9ccacf585823a874976432478529893f71da3. Native `FloatingMonitorService.kt` blob remains `f2c5d5e8b5731be36ae3b82109a75beaefe5fb4d`. Tests and analyzer have NOT RUN for the latest source-only fix.

## Home NOTIFY — single latest-event message (2026-10-20; source-only / NOT RUN / NOT RELEASED)

- Current blobs: `lib/main.dart` `a167e884f765a8a9ef379108262c366c8bcdcf99`; `lib/app_settings.dart` `44431e926bfa2557c26345899e2333bd767f3f8e`; `test/widget_test.dart` `5cb9ccacf585823a874976432478529893f71da3`.
- Home NOTIFY presents only the newest confirmed event as one complete sentence. A new event replaces the previous one; it never concatenates Adaptive, Voltage, Fan and Peltier into a combined summary. Example sequence: `Adaptive ON.` → `Voltage set to 5V.` → `Fan speed reduced to 70%.`
- Events cover Voltage, Fan/Peltier ON/OFF, Adaptive ON/OFF/profile/ceiling, Fan speed increase/reduction, LED ON/OFF/mode/brightness/color and safety-state changes. Repeated identical telemetry creates no event, and a delayed ACK cannot overwrite newer telemetry.
- Ordinary Temperature samples do not generate Home NOTIFY. Hotside reaching the configured limit displays the measured temperature and configured limit in English/Indonesian, with safety priority. Android push still follows its notification preference and re-arms when Hotside falls below the limit.
- Language changes re-render the latest event immediately. BLE protocol/ownership, Firmware safety rules, OTA transport and Android `versionName` remain unchanged.
- Build #120 remains the last successful App release; the latest source/test changes are NOT RUN / NOT RELEASED. No App Build, Firmware compile, BIN/Firebase, OTA, flash or device operation was performed.
## Adaptive Fan whole-degree target fix — source-only / NOT COMPILED / NOT TESTED

- Source: `firmware/JEXFYZ-V7.0.ino` blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`.
- QC contract: `test/firmware_qc_contract_test.dart` blob `a44c12d32c472f109687c06316ea40f70fcf93ce`.
- Use `floorf(hotsideC)` to select the whole-degree target category. At a 40°C limit, 36.0–36.99°C stays at 70%; target 80% begins at category 37. Preserve the unrounded Hotside safety override, immediate 100% cooling, 10-point ramp steps (up 1 second / down 10 seconds), one calibrated NTC sample per second and the non-blocking loop.
- Static readback checks passed. Firmware contract tests and Arduino compile were NOT RUN; the earlier user-reported V6.9 install does not validate this source revision. No BIN payload was inspected/changed, and no Firebase, OTA, flash or device operation occurred. A real OTA still requires a V7.0 BIN compiled from this source and Firebase metadata `version: "V7.0"` pointing to that artifact.

## 3. Current validated release versus working source

- **Latest validated/released App:** Build #120, commit `aeadaa47bd7ad64af6044afce5783781f0c0d82f`. The new single-event NOTIFY source is not included in that release.
- **Current working source:** the latest localized source and test blobs listed above, layered on top of the prior thermal-visual work. This follow-up remains **UNVALIDATED / NOT RELEASED**; live `main` HEAD is authoritative.
- Any next official App validation/release requires the distinct `@Thinking Eksekusi Build App!` command. Never infer APK contents from a newer main source hash alone.

## 4. Canonical memory files and updated fingerprints (localization copy pass included)

- `lib/main.dart`: `07178b5cce55fc8f78cc7c2953f4d8e352ccefe7`
- `test/widget_test.dart`: `0a5901ac6dc23c947356189a312bb1dec418298e`
- `PROJECT_STATE.md`: `b1923c30b5fef9c7502adcc96e9d58f04fea6d71`
- `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`: `7e7a4a30c779e46f71c2a573653fcf001284d4b8`
- `VOLTAGE_TRANSITION_MEMORY.md`: `f4b5d953dfca0319ebc30e055ad90893d8612dee`
- `DESIGN_NOTES.md`: `48fa3014c5b3e93028f36adbdda4525bd4ee69e7`
- `APP_BUILD_REPORT.md`: `377db79e937a3d1704616a3e487090dfddf0e94f`
- `CHANGELOG.md`: `791e58466b5d463fbe159e21a217b762e8193ba6`
- `README.md`: `95a799144c2cb093af6dab9a953884709663c5f2`
- `HANDOVER.md`: `c11dd8c9feb885176eb2216f3729d8825f5ebd31`
- `CHAT_RULES.md`: `cc2798d1d1b4f5a48005966f14d70954c3ef4b86`
- `APP_NOTES.md`: `21e53cb65ec4e99f66fc1499cc6e79d930ef95bd`
- `MEMORY_INDEX.md`: `7d0ec09ab84189e6c583987a382e4d189905b658`
- Guarded App trigger workflow stays unchanged at blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`.

## 5. Firmware checkpoint / protected behavior

- Active Firmware source is `firmware/JEXFYZ-V7.0.ino`, current blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`, embedded `FW_VERSION="V7.0"`; QC contract test blob `a44c12d32c472f109687c06316ea40f70fcf93ce` and Touch/Adaptive test blob `b3e23e59deae19408cd7ccbacbad84273f958970`. Adaptive 12 V target selection now groups Hotside readings by floored whole degrees (36.3°C and 36.8°C are both category 36 and target 70% when the limit is 40°C; target 80% starts at category 37). The immediate safety override still uses the raw decimal temperature and forces 100% at the limit. PWM ramp timing and 1 Hz single NTC read are unchanged. The user reported compile/install for an earlier V6.9 revision; the current hashes have NOT been compiled/installed. Compile logs, source-to-BIN provenance, installed version and physical PWM/thermal results remain **UNVERIFIED**.
- Firmware QC test blob `1b35feeb1e411efec44261ec130eec4535004454` and Touch/Adaptive sync test blob `b3e23e59deae19408cd7ccbacbad84273f958970` have NOT RUN for V7.0.
- Preserve the existing safety gates, 1 Hz calibrated NTC sample, Adaptive downstep/upstep cadence, voltage handoff, BLE/P1 protocol, OTA protection, Firebase policy and current app build workflow. No unrelated changes.
