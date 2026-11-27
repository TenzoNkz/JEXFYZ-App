<!-- ACTIVE_CHECKPOINT_START -->

## Active checkpoint — CODE_FULL then REPO_FULL — 2026-11-27

- **Owner scope:** approved App-only WP0–WP10, followed by REPO_FULL after CODE_FULL closes. Build App requires a fresh explicit `Eksekusi Build App!`.
- **Repository policy:** `TenzoNkz/JEXFYZ-App`, direct `main` only; no branches/PRs. Re-fetch HEAD/tree/target blobs before each write and use expected-HEAD updates.
- **Live main:** `d5228516e825a3e7b9ae72bcea8239bb90b32d38`; root tree `5260bcbc9bb520975c5d4cfc551938c750c7aafb`; recursive tree 160 entries / 114 blobs / 46 trees, `truncated=false`. The file register now has 114/114 path dispositions; this is not proof that every file's content/architecture review is complete.
- **Latest green App source:** Validation Only #166 / run `45956791122` / job `140365017067`, exact SHA `b61614a170e6c741fa0280adcc75cf9e7504d075`, terminal SUCCESS: dependencies, formatter (37/0), analyzer and **262/262 Flutter tests** PASS. Three Connection scan state/name regressions are verified there.
- **Current validation:** #168 / run `45957362284` targets exact live SHA `d5228516e825a3e7b9ae72bcea8239bb90b32d38`; it was IN_PROGRESS at the last status read. Its changes include 11 AppSettings value-model/palette tests. #167 on the parent test commit `e2504ad...` failed only the formatter gate (38 files / 1 changed) while dependencies, analyzer and **273/273 tests** passed. The overlong declaration was wrapped in `d522851...`; do not close the new test until #168 is terminal SUCCESS.
- **WP1:** pure Connection scan mapper priority/name trimming tests are VERIFIED CI #166. New `test/app_settings_model_test.dart` covers model defaults, JSON round-trip/fallback, malformed values, copyWith false booleans and palette selection; plugin-backed secure-storage failure/integration tests remain OPEN.
- **WP3:** P1 frame decoder, pure command classifier and per-item FIFO ACK waiter lifecycle are separate narrow modules. Dashboard remains the sole BLE/GATT/P1/session and authoritative telemetry owner.
- **WP4:** existing semantic ColorScheme roles/layout/typography/shape tokens and base/compact theme consumers are present. Cross-route audit and screenshot acceptance remain open; do not introduce a second palette or mechanical token aliases.
- **Next:** complete WP4 consumer review, then implement WP5 Home and control surfaces in small behavior-preserving packages. Preserve 360-dp canvas/DPI geometry, cooler hero, seven metric rows, status semantics, command gating and telemetry truth.
- **Protected:** BLE/P1 UUID/framing/commands/SYNC/SYNC_READY; one BLE owner; serialized scan generation; ACK vs telemetry truth; Usage Statistics v2/v1→v2, 30-day retention, raw 1-Hz/HOT freshness/null gaps/gap-safe decimation/64+8+1; native Canvas/WindowManager; Firmware/OTA boundaries.
- **Release/evidence:** Build #167 remains the latest published package on immutable source `0dd96228d33b08c66e736ae91a8a6c3e5c3ddb81`; current main is not packaged. No Build App/APK/sign/release, Firmware/BIN, P1 wire/security, OTA, Firebase production, flashing or device operations. Local Flutter/Dart/Gradle/ADB unavailable; Android/Kotlin, screenshot/OEM/device, SQLite runtime fixture and performance profile NOT RUN; overall visual result **VISUAL NOT VERIFIED**.

<!-- ACTIVE_CHECKPOINT_END -->
