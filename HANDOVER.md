# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-10 (Asia/Jakarta).

## Latest verified App package — Build #143

- Actions run 42783474515, workflow 374946166, attempt 1; job 129718855331; conclusion success. All 21 required gates and post-job cleanup steps passed.
- Exact build/release source: 121ef9e0f5ed6a0003837d32e4c8b1701f38631a; tag jexfyz-latest and Release ID 403010611 point to this same commit. Workflow file remains guarded issue-only blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12.
- Analyzer: 25 info-level findings, 0 warnings/errors. Flutter tests: 159/159 passed. Android Gradle task completed, but :app:testDebugUnitTest is NO-SOURCE; native Android JUnit coverage was not executed.
- APK V1/V2/V3 verification and the pinned production certificate passed, including after downloading the Release asset. Certificate SHA-256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- **APK:** https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk — 55,685,211 bytes, SHA-256 65d001c7a8df708dd35d5c80665c4cb7e377d47f11bdb675022c00817b251cd0.
- **Source ZIP:** https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip — 2,911,348 bytes, SHA-256 b7682a0d73a1d494d5d187481115480465bdb6aaf3fa9db79fcebca8279e4fc6. Release has exactly one APK and one matching source ZIP; tag, source marker, downloaded hashes, ZIP integrity and downloaded APK signatures all match.
- Preserve Android versionName "Telegram @horizontalzzz"; Release metadata reports 1.0.0+3.

## Warnings / explicit limitations

- Android app JUnit task was NO-SOURCE, not a positive native test count.
- Kotlin 2.2.20 is approaching Flutter compatibility cutoff; Gradle reports deprecated features before Gradle 10.
- Native ELF shared libraries emit unobfuscated DWARF debug-information warnings; Flutter/Dart --obfuscate does not establish that native ELF debug sections were stripped.
- jarsigner reports custom certificate trust-chain/META-INF warnings. Expected pinned certificate fingerprint matched and apksigner V1/V2/V3 passed; do not describe this as a public-CA chain.
- Physical installation, OEM/layout screenshots, BLE reconnect, live telemetry/statistics soak, thermal/electrical cooling, Firmware/BIN/Firebase/OTA/flash remain separate and unverified.

## Prior repairs confirmed by Build #143

- #139/#140 analyzer/test identifier fixes, #141 Indonesian completed-session assertion repair and #142 stable-key elapsed-label assertion fix are included and now pass the hosted analyzer/Flutter test gates.

## Current scoped App UI workstream — compact modal overlays implemented

- **Peltier safety dialog:** title 20 dp, body 15 dp, actions 14 dp; tighter spacing and 72×48 / 128×48 dp minimum action sizes. Fan-first safety gating/ACK behavior preserved.
- **LED Color Picker:** width cap 312 dp, responsive height cap `min(308 dp, 82% of available safe-area height)`, six-column scrollable grid, all 36 colors including final white, 48×48 dp cells with 32×32 dp visible swatches. Preview/Cancel/Select semantics preserved.
- **Files:** `lib/main.dart` and `test/widget_test.dart`; details in `DESIGN_NOTES.md`. Source/test commits: `07602f598f2e95e71860a42b54521e08b8881680`, `ae44645cea27eced3f42749d892bd7794e5a2a7c`, `3d6fc0c3bd5df922b3949cc4d6f18acbc81e6853`.
- Local Flutter/Dart tools are unavailable. Formatter, tests and analyzer are BLOCKED / NOT RUN; static source delimiter checks passed. Real screenshots are not available for this new source SHA, so VISUAL NOT VERIFIED. No APK contains this change yet.
- Protected 360-dp canvas/DPI formula, Home, Settings, RGB protocol, BLE, Peltier/Fan safety, Firmware and Release workflow remain unchanged.

## Next direction

Build #143 remains the latest verified App package. A separate `Eksekusi Build App!` is now the next required step to run guarded hosted QC and package the overlay source/test changes. After that package is released, the owner should install it and provide actual visual acceptance screenshots for both overlays in English/Indonesian and at 350-dp/420-dp/constrained-height cases. Build #143 installation identity and OEM acceptance remain UNVERIFIED. Do not infer physical acceptance or Firmware/device authorization from CI.

Preserve the mode boundary: Diskusi! is engineering discussion only; Eksekusi Full! is App/source implementation when explicitly commanded; Eksekusi Build App! is guarded App Build/QC only.
