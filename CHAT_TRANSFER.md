# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Reconciled from live GitHub main after `@Thinking Eksekusi Full!` on 2026-10-20 (Asia/Jakarta). The working source includes the earlier thermal-visual revisions plus a new English/Indonesian localization and copy pass. Live `main` is authoritative; this snapshot records the source-only, not-yet-validated state.

## 1. Authority and operation scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; continue directly on `main`, no branch/PR unless requested.
- `@Thinking Diskusi!` is read-only. `@Thinking Eksekusi Full!` authorizes only scoped source/tests/docs/static audit/commit; it does NOT authorize official App Build/release, Firmware compile, BIN publication, Firebase, OTA, flashing or physical-device operations. `@Thinking Eksekusi Build App!` remains the separate App Build authorization.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. `TenzoNkz/JEXFYZ-Firmware` is BIN-only; do not inspect or modify its payload.
- Latest successful App release is Build #116 / Actions run 39355262101, packaging commit `48683874db659df940272bed1c860072ead2d767`. It passed 109 Flutter tests and the configured release gates. Its APK SHA-256 is `8570914f331583d2cc462f61881609c0eae56639a139f2d60a832e4aaa81ea27`; source ZIP SHA-256 is `60ef4e79529aabcbb4f4093b9f8a18b5d383d5c651c1c303dd8bb774e7b0dd5d`. Build #116 validates only its packaged source, not this new follow-up.

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
- Current source blobs: `lib/app_settings.dart` 6d143e6b6b5b986e2d6915dd8b608baca6f0d444; `lib/main.dart` 07178b5cce55fc8f78cc7c2953f4d8e352ccefe7; `test/widget_test.dart` 0a5901ac6dc23c947356189a312bb1dec418298e; `FloatingMonitorService.kt` f2c5d5e8b5731be36ae3b82109a75beaefe5fb4d. Flutter tests and Dart analysis have NOT RUN. Build #116 remains the latest verified release.

## 3. Current validated release versus working source

- **Latest validated/released App:** Build #116, commit `48683874db659df940272bed1c860072ead2d767`.
- **Current working source:** the latest localized source and test blobs listed above, layered on top of the prior thermal-visual work. This follow-up remains **UNVALIDATED / NOT RELEASED**; live `main` HEAD is authoritative.
- Any next official App validation/release requires the distinct `@Thinking Eksekusi Build App!` command. Never infer APK contents from a newer main source hash alone.

## 4. Canonical memory files and updated fingerprints (localization copy pass included)

- `lib/main.dart`: `07178b5cce55fc8f78cc7c2953f4d8e352ccefe7`
- `test/widget_test.dart`: `0a5901ac6dc23c947356189a312bb1dec418298e`
- `PROJECT_STATE.md`: `420515e3d69640b70174ea27e2ed32e0e86cddbc`
- `DESIGN_NOTES.md`: `48fa3014c5b3e93028f36adbdda4525bd4ee69e7`
- `APP_BUILD_REPORT.md`: `377db79e937a3d1704616a3e487090dfddf0e94f`
- `CHANGELOG.md`: `5dfb52c90fa48d755b80f9ce4ba213db32b99d3e`
- `README.md`: `95a799144c2cb093af6dab9a953884709663c5f2`
- `HANDOVER.md`: `ed5ca8fcb87184a8bd576efb1aca65dd12750cbb`
- `CHAT_RULES.md`: `cc2798d1d1b4f5a48005966f14d70954c3ef4b86`
- `APP_NOTES.md`: `bfb698deba9fcc0c44e801f9c1fb2562de064c64`
- `MEMORY_INDEX.md`: `7dc84007c6d0fbafcf96ac26b3d6b4ded7d4b7f1`
- Guarded App trigger workflow stays unchanged at blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`.

## 5. Firmware checkpoint / protected behavior

- Active Firmware source is `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`. User reports compile/install success; independent compile logs, source-to-BIN provenance, installed version and physical PWM/thermal results remain **UNVERIFIED**.
- Firmware QC test blob `1b35feeb1e411efec44261ec130eec4535004454` and Touch/Adaptive sync test blob `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8` have NOT RUN for V6.9 in recorded CI evidence.
- Preserve the existing safety gates, 1 Hz calibrated NTC sample, Adaptive downstep/upstep cadence, voltage handoff, BLE/P1 protocol, OTA protection, Firebase policy and current app build workflow. No unrelated changes.
