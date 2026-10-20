# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Reconciled from live GitHub main on 2026-10-20 (Asia/Jakarta). Latest verified App release is Build #124 / run 39386733061 on packaged source commit 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. Active Firmware V7.1 has 2°C limit-relative Adaptive 12 V Fan target bands and remains source-only / NOT COMPILED / NOT DEPLOYED.

Reconciled from live GitHub main on 2026-10-20 (Asia/Jakarta). Build #123 is the latest verified App release; user reports the App is installed safely and Firmware V7.0 compiled/updated by Online OTA. The latest password-visibility patch is source-only and not yet built.

## Latest checkpoint — 2026-10-20 (Firmware V7.1 source-only)

- Latest verified App release is Build #124 / run `39386733061`, source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`; APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`, source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`. Build #124 includes Wi-Fi password Show/Hide and passed 116 Flutter tests plus configured App release gates.
- Active Firmware is V7.1: `firmware/JEXFYZ-V7.1.ino` blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`; QC contract `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync contract `7c203a11f79de62744af8536bbf2e3219d7f0909`.
- At limit 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%. Bands shift with configured limit. PWM remains −10 points/10 s and +10 points/1 s; raw-decimal protection remains immediate.
- Tests and Arduino compile have NOT RUN for V7.1. Prior user-reported V7.0 compile/Online OTA does not verify this revision. No V7.1 BIN/Firebase/OTA/flash/device action occurred.
- BLE App-only authorization remains BLOCKED / NOT IMPLEMENTED pending trusted backend enrollment/signing. OTA remains protected/unchanged; all Touch actions remain unchanged.

## 1. Authority and operation scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; continue directly on `main`, no branch/PR unless requested.
- `@Thinking Diskusi!` is read-only. `@Thinking Eksekusi Full!` authorizes only scoped source/tests/docs/static audit/commit; it does NOT authorize official App Build/release, Firmware compile, BIN publication, Firebase, OTA, flashing or physical-device operations. `@Thinking Eksekusi Build App!` remains the separate App Build authorization.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. `TenzoNkz/JEXFYZ-Firmware` is BIN-only; do not inspect or modify its payload.
- Latest verified App release is Build #123 / Actions run 39371864780, packaging commit `14e90e7e26b8eb4400bd01ec8d0eab5ed4195f1c`. It passed 115 Flutter tests and configured release gates. APK SHA-256 `1d06c806b1e75440dfe16108d236dd4c5f0e9b85d50e56989263793952351abb`; source ZIP SHA-256 `0118f201027747f8f682a8d3a393334585a14845a8741f2296da07afae06fbe1`. It does not include the current password-visibility patch.

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
- Latest NOTIFY source blobs: `lib/main.dart` 40f172a5d190b429d3a952f2531349c1ee220d1f; `lib/app_settings.dart` 44431e926bfa2557c26345899e2333bd767f3f8e; `test/widget_test.dart` 132c3b000abd63599ebea9d26fc5085cb577e50e. Native `FloatingMonitorService.kt` blob remains `f2c5d5e8b5731be36ae3b82109a75beaefe5fb4d`. Tests and analyzer have NOT RUN for the latest source-only fix.

## Home NOTIFY — latest-event message (validated in App Build #124)

- Packaged App blobs: `lib/main.dart` `2d44e1f1f5b88ca1dae8324082da751b6ef1485a`; `lib/app_settings.dart` `637c07be55c412451d9ffde762e080c8bd92fd5e`; `test/widget_test.dart` `90e1a582c49ce3ad1a1d9a3b875921098eaf2545`.
- Home NOTIFY shows one complete sentence for the newest confirmed event; ordinary Temperature samples do not notify. Hotside at its configured limit remains the safety-priority exception.
- Build #124 passed 116 Flutter tests. App CI does not validate Firmware V7.1 or physical thermal behavior.

## Adaptive Fan 2°C target-band update — V7.1 source-only / NOT COMPILED

- Active source: `firmware/JEXFYZ-V7.1.ino`, blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`; QC contract `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync contract `7c203a11f79de62744af8536bbf2e3219d7f0909`.
- Targets derive from `floorf(hotsideC)` and configured `hotLimit`: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%. At 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29°C →50%.
- Immediate raw-decimal safety, +10 points/1 second upsteps, −10 points/10 seconds downsteps, 1 Hz NTC sampling, non-blocking loop, Touch, Peltier/rail timing and OTA remain unchanged.
- Static source/mapping review passed, but Dart contract tests and Arduino compilation have NOT RUN. V7.0 user-reported compile/OTA applies to the prior revision only.

## 3. Current validated release versus working source

- **Latest validated/released App:** Build #124 / run `39386733061`, packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`; APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`; source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`.
- Build #124 passed 116 Flutter tests and configured App release gates. Analyzer exit 0 with 25 info-level diagnostics; native Android unit tests were NO-SOURCE.
- Current Firmware V7.1 source-only changes postdate the packaged App source and are not compiled/deployed. An App build requires the distinct `@Thinking Eksekusi Build App!` command; no App Build ran here.

## 4. Canonical memory files and updated fingerprints

- Active Firmware `firmware/JEXFYZ-V7.1.ino`: `6ef355d666b83fc83b4d7c48ee377753828ca02c`
- QC contract `test/firmware_qc_contract_test.dart`: `12e30d7ec16b322e7411cefa7c99cd42aff6c056`
- Touch/Adaptive sync contract `test/firmware_touch_adaptive_sync_test.dart`: `7c203a11f79de62744af8536bbf2e3219d7f0909`
- Updated canonical references: `FIRMWARE_NOTES.md` `0fc97bd5ecff2a049263c6ef44a93a0a3a5ae97a`; `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` `55aafae1be80c9fd161ca768bc609a152e92047c`; `PROJECT_STATE.md` `833b53a7838c425eda23cbc271a12c259306fcf6`; `HANDOVER.md` `a518bd004898eead8f3ea2f59aa9127e20892466`; `MEMORY_INDEX.md` `ad51543097e5bf57af960c6a9b7e126cc375f522`.
- OTA/auth/handoff references updated in the same commit; protected App trigger workflow unchanged. No compile, BIN/Firebase, OTA or device operation occurred.

## 5. Firmware checkpoint / protected behavior

- Active Firmware `firmware/JEXFYZ-V7.1.ino` blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`, embedded `FW_VERSION="V7.1"`; QC `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync `7c203a11f79de62744af8536bbf2e3219d7f0909`.
- At limit 40°C, Adaptive 12 V target bands: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%. Band thresholds shift with configured limit.
- Raw-decimal Hotside protection remains immediate: Fan 100% and Peltier OFF at/above limit. PWM remains +10 points each 1 s / −10 points each 10 s; Adaptive 5 V/9 V remains 100%.
- V7.1 tests/Arduino compile have NOT RUN, and exact source-to-BIN/installed identity remains UNVERIFIED. V7.0 success was user-reported for that earlier revision only.
- `TenzoNkz/JEXFYZ-Firmware` remains BIN-only. No V7.1 BIN/Firebase/OTA/flash/device action occurred. Preserve all Touch, Peltier/rail timing, BLE/P1 and OTA contracts.
