<!-- ACTIVE_CHECKPOINT_START -->

## Active checkpoint — CODE_FULL then REPO_FULL — 2026-11-27

- **Owner scope:** finish App-only WP0–WP10 and evidence-backed build-ready handoff first; afterward run one approved REPO_FULL cleanup cycle. Build App requires separate explicit authorization.
- **Repository policy:** direct commits to `main` only; no secondary branches or PRs. GitHub verified only branch `main`, empty rulesets list, and no active Actions run during recovery.
- **Current verified main:** `c97a2fdc2698b16339d3f03ff04d992f2a0e7848`; root tree `0fb0dc18806ca564ea937964eb9ad77dae486e3c`; recursive tree 147 entries / 101 blobs / 46 trees, `truncated=false`.
- **Register:** `REPOSITORY_UPGRADE_PLAN.md` contains 101 unique file-path rows for 101 live blobs; no missing or duplicate paths. Both `lib/connection_sheet.dart` and `lib/jex_animated_icon.dart` are registered.
- **Connection extraction:** `lib/connection_sheet.dart` owns manual sheet presentation/OS status lifecycle; scan/connect orchestration, BLE/GATT and P1 ownership remain in Dashboard/coordinator.
- **Home NOTIFY extraction:** `HomeNotifyCard` in `lib/home_notify.dart` renders a stateless fixed 44-dp card. Dashboard supplies final label/message, theme, connected/error/warning flags and foreground color; error priority, safety/HOT-limit classification, locale and contrast decisions remain in Dashboard. Widget coverage includes disconnected and warning renders.
- **Latest source validation:** Validation Only run `45884911511` / job `140133094930`, exact SHA `c97a2fdc2698b16339d3f03ff04d992f2a0e7848`; locked dependency, read-only formatter, analyzer, full Flutter tests **233/233 PASS**, summary SUCCESS.
- **CI/repository policy:** main-only, read-only Validation Only (`contents: read`, checkout credentials disabled, formatter check only, analyzer/tests; no formatter write or bot commit). PR validator removed. Guarded Build App workflow unchanged.
- **Protected contracts:** BLE/P1 UUID/framing/commands/SYNC_READY, single GATT owner, telemetry truth, Usage Statistics v2/migration/retention/1-Hz/HOT/gaps/64+8+1, OTA/Firebase/signing and Firmware safeguards remain protected.
- **Release/evidence boundary:** Build #167 remains latest published package; current source is not released. No Build App/APK/sign/release, Firmware/BIN, Firebase production, OTA, flashing or physical-device operation. Local Flutter/Dart/Gradle/ADB unavailable. Android/Kotlin build, screenshots/OEM/device acceptance, SQLite migration fixture and long-session soak remain NOT RUN. Whole-App visual status **VISUAL NOT VERIFIED**.
- **Next action:** continue CODE_FULL Dashboard architecture/state-ownership audit and ordered WP0–WP10. Only after CODE_FULL closes, perform the approved REPO_FULL cycle.

<!-- ACTIVE_CHECKPOINT_END -->
