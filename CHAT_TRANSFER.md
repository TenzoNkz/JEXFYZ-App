# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Reconciled from live GitHub main after `@Thinking Eksekusi Full!` on 2026-10-20 (Asia/Jakarta). Original pre-change HEAD: `766a52afd284529a214f8a47dd3bcf74662b23ff`; base tree: `c42df15b82815fdc7f1dfc7edc26cc8221075ce7`. The main UI update is committed as `69f7034270cf6ad76af6cae17ae2daf372084ce8`; this snapshot records a small follow-up correction to the regression test. Live HEAD overrides this pre-commit snapshot.

## 1. Authority and operation scope

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; continue directly on `main`, no branch/PR unless requested.
- `@Thinking Diskusi!` is read-only. `@Thinking Eksekusi Full!` authorizes only scoped source/tests/docs/static audit/commit; it does NOT authorize official App Build/release, Firmware compile, BIN publication, Firebase, OTA, flashing or physical-device operations. `@Thinking Eksekusi Build App!` remains the separate App Build authorization.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. `TenzoNkz/JEXFYZ-Firmware` is BIN-only; do not inspect or modify its payload.
- Latest successful App release is Build #116 / Actions run 39355262101, packaging commit `48683874db659df940272bed1c860072ead2d767`. It passed 109 Flutter tests and the configured release gates. Its APK SHA-256 is `8570914f331583d2cc462f61881609c0eae56639a139f2d60a832e4aaa81ea27`; source ZIP SHA-256 is `60ef4e79529aabcbb4f4093b9f8a18b5d383d5c651c1c303dd8bb774e7b0dd5d`. Build #116 validates only its packaged source, not this new follow-up.

## 2. Final Home visual follow-up — source-only / NOT RUN / NOT RELEASED

- `lib/main.dart` blob: `8eb24de58a2e510b3d05abbb29bce45bb0a42810`.
- `test/widget_test.dart` blob: `a82875dd47ad904818fcd4c1c47b1a3ac0ca8fd2`.
- Battery/Hotside use deterministic falling flame-shaped particles (not plain oval dots), with orange/gold body, warm yellow-white hot cores, soft halo, subtle drift/rotation and edge fading. Flames fall from the top like the Peltier snowfall.
- Fire draws as a background layer. The permitted path is the rounded painter frame minus the foreground thermal silhouette; the frame clip stops particles escaping rounded corners, and the foreground battery/thermometer casing remains above them. Existing Battery >=40°C and configured Hotside warning gates plus the 280 ms warning transition are unchanged. Peltier animation is not changed.
- Home NOTIFY heading is now exactly `NOTIFY` in all languages/states: no `• ERROR`, `• STATUS`, `• SYNC`, `• WARNING`, or connection suffix. A 2 dp top inset lowers the label away from the card border. Card remains fixed 44 dp, body remains up to two lines with only necessary font shrinking, Home metric rows stay 45 dp with a 3 dp gap before NOTIFY, and cooler-image constraints stay stable.
- The regression source contract was updated for flame shape paths, rounded-frame clipping, exact NOTIFY label and the top inset. Flutter tests and Dart analyzer were **NOT RUN** in this Full execution. Do not claim the latest changes are test-passing, built or released until separately validated.
- No App Build/release, Firmware compile, BIN inspection/publication, Firebase edit, OTA, flash, or device operation took place here.

## 3. Current validated release versus working source

- **Latest validated/released App:** Build #116, commit `48683874db659df940272bed1c860072ead2d767`.
- **Current working source:** source blob listed above and test blob listed above; main UI commit `69f7034270cf6ad76af6cae17ae2daf372084ce8` is followed by a small correction to align the test's expected top-to-bottom particle start offset with source. This complete follow-up remains **UNVALIDATED / NOT RELEASED**; live `main` HEAD is authoritative.
- Any next official App validation/release requires the distinct `@Thinking Eksekusi Build App!` command. Never infer APK contents from a newer main source hash alone.

## 4. Canonical memory files and updated fingerprints (test offset correction included)

- `lib/main.dart`: `8eb24de58a2e510b3d05abbb29bce45bb0a42810`
- `test/widget_test.dart`: `a82875dd47ad904818fcd4c1c47b1a3ac0ca8fd2`
- `PROJECT_STATE.md`: `d8e126e3b521d42c7d3a37008c552866e11052ef`
- `DESIGN_NOTES.md`: `48fa3014c5b3e93028f36adbdda4525bd4ee69e7`
- `APP_BUILD_REPORT.md`: `377db79e937a3d1704616a3e487090dfddf0e94f`
- `CHANGELOG.md`: `a28b6d1ba5bab5663f7468ba0008c4d151c2c2de`
- `README.md`: `6712a0c2e9b6e425acb5ff3de09c546919358af3`
- `HANDOVER.md`: `af335a5e23380dc5eff2223106be3ccc4da7341c`
- `CHAT_RULES.md`: `cc2798d1d1b4f5a48005966f14d70954c3ef4b86`
- `APP_NOTES.md`: `55bf0fc25c1753e6c8d9528d366679f808daf143`
- `MEMORY_INDEX.md`: `9dfdc34039996ac01216f0e1e4b7a30a84439ed1`
- Guarded App trigger workflow stays unchanged at blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`.

## 5. Firmware checkpoint / protected behavior

- Active Firmware source is `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`. User reports compile/install success; independent compile logs, source-to-BIN provenance, installed version and physical PWM/thermal results remain **UNVERIFIED**.
- Firmware QC test blob `1b35feeb1e411efec44261ec130eec4535004454` and Touch/Adaptive sync test blob `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8` have NOT RUN for V6.9 in recorded CI evidence.
- Preserve the existing safety gates, 1 Hz calibrated NTC sample, Adaptive downstep/upstep cadence, voltage handoff, BLE/P1 protocol, OTA protection, Firebase policy and current app build workflow. No unrelated changes.
