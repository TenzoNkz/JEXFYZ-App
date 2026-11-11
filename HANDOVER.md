# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-11 (Asia/Jakarta).

## Latest verified App package — Build #149

- Actions run 42967289995, workflow 374946166, attempt 1; job 130347345586; final conclusion success. All 21 required gates and post-job cleanup 39–43 passed.
- Exact build/release source SHA: 0507e3e11b67b8f8d042e49b74cc14a53bfc4f21; jexfyz-latest tag and Release ID 403010611 point to this exact SHA. Current main includes the newer unbuilt Peltier/LED source refinement in commit `7f31c2d3b2571dbb9f1c4fa87dea0db0d3851bda`; the published tag/Release still points to the exact Build #149 source SHA.
- Analyzer: 23 info-level findings, zero warnings/errors. Flutter tests 166/166 passed, including selected Statistics cursor readout after tapping Peltier lane while scrolled. Android Gradle gate succeeded, but :app:testDebugUnitTest and app JUnit compile/test tasks were NO-SOURCE; no native Android app JUnit tests ran.
- APK built using Flutter --obfuscate --split-debug-info=build/symbols. Production certificate SHA-256 dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0 (RSA 4096, JE X FYZ DN); V1/V2/V3 all verified on original and downloaded APK.
- **APK:** https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk — 55,881,819 bytes; SHA-256 84a9165f67420e99d6ae7585340e0ef7e29e80de1d413fbc9c7352866d0670d5.
- **Source ZIP:** https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip — 2,918,953 bytes; SHA-256 521a06c1f804a3f04a9b0f7165796e806c60bbd9e027c9986ff91e5f2e326782. Exactly one APK and one corresponding ZIP in Release; downloaded checksums, ZIP/source marker and downloaded APK signatures/cert passed.
- Android versionName "Telegram @horizontalzzz" preserved; Release app version 1.0.0+3.

## Warnings and open validation

- Kotlin 2.2.20 compatibility/Built-in Kotlin migration advisory; Gradle 10 deprecations; native ELF DWARF debug data remains despite Dart obfuscation; jarsigner PKIX trust-chain and META-INF notices even though expected cert fingerprint and V1/V2/V3 passed; cache writes denied by token permissions; 29 package updates outside constraints.
- The normal suite did not close the performance risks: full summary recompute per one-second batch, unbounded/unbatched SQLite recorder queue, long-session CPU/memory/backpressure, animation lifecycle/60–120-Hz tests.
- Physical installation, OEM visuals, 350-dp/420-dp field layout, BLE runtime, real sensor Statistics soak, thermal/electrical cooling, Firmware/BIN/Firebase/OTA/flash remain unverified.

## Next direction

The latest owner request is a cross-layer Firmware V7.2 scope: combine the pending one-way Touch voltage cycle with a persistent 5V Lock Voltage stored in ESP32 Preferences/NVS, its App Settings toggle and locked Voltage/Adaptive controls, P1 synchronization, and two-red-flash rejection feedback. Detailed design/guardrails are in FIRMWARE_NOTES.md and APP_NOTES.md. Current V7.1/App source is unchanged for this request. Recommended next mode: Eksekusi Full! for the specifically scoped Firmware + App source/tests/docs. This does not authorize Arduino compile, BIN, Firebase, OTA, flashing, device work or App release; a new APK still requires separate Eksekusi Build App!.
