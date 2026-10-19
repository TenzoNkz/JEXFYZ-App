# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed for the post-Build-#95 animation-smoothness source follow-up on 2026-10-19 (Asia/Jakarta). This is the canonical boot snapshot. Before further action, re-fetch live `main`, full tree, relevant source/test/doc hashes, workflow, Actions runs, Release/tag, branches/PRs and the firmware-artifact repository. This file is written last. Pre-transfer HEAD/tree below describes live `main` immediately before this transfer write; this snapshot deliberately does not self-reference its future commit or blob SHA.

## 1. Authority, repository roles and command protocol

- **Canonical editable repository:** `TenzoNkz/JEXFYZ-App`, branch `main`. Use the live source, tests, docs, workflow and build ledger.
- **Artifact-only repository:** `TenzoNkz/JEXFYZ-Firmware` must contain exactly `JEXFYZ.cpp.bin`. Latest inspected recursive tree contained exactly one entry: blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, size 1,457,008 bytes. The payload was not read; source-to-BIN provenance remains UNVERIFIED.
- **Commands:** `@Thinking Diskusi!` = read-only; `@Thinking Eksekusi Full!` = scoped source/tests/docs/audit/commit, but not App Build, Firmware or device operations; `@Thinking Eksekusi Build App!` = the only command authorizing complete App analyzer/test/build/release flow; `@Thinking Chat Stuck!` = recover an existing stalled task without wider authorization. Retired aliases: `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, standalone `@Thinking Eksekusi!`.
- **Workflow:** `.github/workflows/jexfyz-app-build-trigger.yml`, blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`. It remains guarded to `issues.opened`/`issues.reopened` and exact repository-owner/title/body-token checks. No push/PR/manual bypass.
- User compiles Firmware. Functional Firmware edits require matching version/filename and exactly one active versioned sketch. Do not modify Firmware/BIN, Firebase production metadata, OTA, flash or physical hardware without separate authorization.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. Never expose signing-key contents. Test files/source assertions/CI do not prove physical behavior.
- Current task scope was App icon visuals, regression assertions and related docs. No Dart/Flutter tests/analyzer, App Build/release, Firmware compile/edit, BIN payload access, Firebase/OTA/flash/device operation was performed.

## 2. App/Firmware identity

- App: JE Cooler; header/brand JE X FYZ; pubspec `1.0.0+3`; application ID `com.horizontalzzz.jexfyz`; minSdk 24, targetSdk 36, compileSdk 37. Preserve Gradle `versionName "Telegram @horizontalzzz"`.
- **Latest successful released artifact:** Build #95 / [Actions run 39217718351](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39217718351), packaged source commit `cd691b874ddb0e454ba69891a3e0da3001df892f`. All 21 workflow steps passed, 99/99 Flutter tests passed, analyzer passed with 23 info-level deprecation findings, APK/signing/certificate, source ZIP, asset-integrity and tag/Release/source checks passed. Native JUnit tasks were NO-SOURCE.
- Build #95 APK asset `655596091`, 54,702,171 bytes, SHA-256 `856718ada30c5ef5081b5bb28a5e00c3b9d234e00ebced58a211112cc381140d`. Corresponding source ZIP asset `655596090`, 2,858,246 bytes, SHA-256 `262d552e564b7c0a1727048a2e2897777ff18fa7296381a77f2c10236784ce7e`. These results apply to Build #95's exact source; the current smoothness follow-up is not in the APK.
- Active editable Firmware source remains `firmware/JEXFYZ-V6.7.ino`, embedded `FW_VERSION="V6.7"`. User-reported compile/online-update remains unverified; source-to-BIN provenance/device version remain UNVERIFIED. Artifact-only repo `TenzoNkz/JEXFYZ-Firmware` retains exactly one `JEXFYZ.cpp.bin`; its payload was not read.
- Workflow `.github/workflows/jexfyz-app-build-trigger.yml` is unchanged at blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12` and remains issue-owner/title/body-token guarded. No trigger bypass was added.

## 3. Current animation smoothness rework — NOT RUN / NOT RELEASED

- Source-level seven-icon geometry and luminous-core styling were included in Build #95. The new follow-up addresses smoothness issues detected in current source and the supplied recording, without changing the Home layout, BLE/device state, control, telemetry, or safety policies.
- Source blob `lib/main.dart`: `f0bc1375799e7b9e4466a3124ddb031d5f58e522`. Updated test blob `test/widget_test.dart`: `653a67f3c946bb10c0da350f9677e19b3275ed58`. Generic navigation/settings/action glyphs remain static in `lib/jex_animated_glyph.dart` blob `b37fc4e0807c874b2f01db00c7f606810cb5deca`.
- Diagnosis: Battery/Hotside cycle periods 4.2/4.4 s and Adaptive 6.4 s were slow for tiny icon detail; ember/snow particles were small; fire drift used a non-integer phase multiplier; whole-icon breathing scaled the entire glyph; Peltier crystal spun with the snowfall phase; Fan PWM/voltage target updates changed repeating cycle duration abruptly.
- Current UI cadence targets: Battery 1500 ms, Hotside 1650 ms, Voltage 1000 ms, Adaptive 2300 ms, Peltier 2100 ms. Falling fire/snow is enlarged, uses eased boundary fades and periodic per-particle drift; Peltier crystal has only a tiny independent rock; whole-glyph breathing is removed; Home glyph size rises 22→26 dp inside the existing 38×38 dp tile.
- Fan retains exactly three blades and three fixed airflow ribbons. An unbounded radian phase and integrated smoothstep rate simulation retarget angular speed over 420 ms when valid PWM/voltage targets change, preserving rotor angle. Confirmed OFF decelerates to zero; disconnect resets phase under existing state policy. Existing voltage/PWM target mapping is unchanged.
- Tests were updated for fade mathematics, Fan rate/phase integration, cadence targets, Peltier motion separation, repaint dependencies and Home glyph size. **Dart/Flutter tests and analyzer are NOT RUN** because neither CLI is installed in the execution environment. These source changes are not packaged in Build #95. Physical-phone smoothness and profile-mode frame-time performance are UNVERIFIED.
- No App Build, Android APK build/release, tag movement, Firmware/BIN/Firebase/OTA/flash/device operation occurred in this task.

## 4. Icon behavior contract

- **Battery Temperature:** battery outline and temperature fill; warning fire stays anchored while three ember drops fall inside battery cavity, then fade.
- **Hotside Temperature:** continuous thermometer outline and live column; falling embers are clipped inside the thermometer during the existing warning state.
- **Voltage:** strong lightning bolt, luminous core, travelling current along closed spine and staggered inner branch strikes. Preserve 5V red / 9V green / 12V blue.
- **Adaptive:** two opposite arrows on separate arcs rotate together only when authoritative Adaptive state is ON; OFF is static and full colour.
- **Peltier:** recognizable six-branch snowflake/crystal with faceted core and falling branched snow behind the icon; existing voltage/state intensity policy remains.
- **Fan:** exactly three curved blades, layered hub, existing voltage/PWM rotor timing and exactly three fixed airflow ribbons.
- **Fan Speed:** upper-half speedometer with smooth actual-PWM retarget; existing OFF endpoint left / 100% endpoint right; hide needle when value is unknown or disconnected.
- Shared glow is restrained and consistent; particle/count/intensity changes must not fabricate telemetry or cooling output. BLE disconnect stops/resets custom status-icon animation; Bluetooth remains static and uses semantic colour.
- Floating Monitor keeps its compact letter-only **B/H/V/A/P/F** layout, with F = Fan Speed. Turning those letters into pictograms is a separate layout/design change and is not part of this scope.

## 5. Other permanent technical boundaries

- BLE firmware telemetry is authoritative for physical Fan/Peltier/Adaptive/LED state. A BLE write/ACK is not proof the physical output changed; wait for authoritative telemetry.
- BLE uses one Flutter/GATT client; native foreground services must not create a second BLE/GATT client.
- Preserve the menu order VOLTAGE → CONTROL → ADAPTIVE → LED → TEMPERATURE, Horizon-style dark header/white rounded content, JE Cooler/JE X FYZ identity, and existing lock/unknown-state semantics.
- Keep the existing phone battery telemetry cadence, voltage command guard, LED mode IDs/sync contract, and every existing OTA protection constraint. Do not re-open OTA, BLE protocol, firmware safety or control sequencing during unrelated visual work.
- Unknown/disconnected dashboard/Floating Monitor outputs display `--`; never substitute stale telemetry or fabricated OFF/0. Adaptive, Peltier, Fan and LED animate only when authoritative state is ON; Battery/Hotside/Voltage follow their existing connected policy; Fan Speed is event-driven. Bluetooth stays static.
- Grille/logo approved design is separate: flat white square silhouette with symmetric rounded hex/lattice structure, purple X and four mounting holes. No grille/image assets were modified.

## 6. Canonical docs and source hashes before this transfer write

- `lib/main.dart`: `f0bc1375799e7b9e4466a3124ddb031d5f58e522`
- `test/widget_test.dart`: `653a67f3c946bb10c0da350f9677e19b3275ed58`
- `lib/jex_animated_glyph.dart`: `b37fc4e0807c874b2f01db00c7f606810cb5deca`
- `DESIGN_NOTES.md`: `2e9a63a3f3bb7494fea22c8331c8125fd6176a9a`
- `APP_NOTES.md`: `7b258cba73fc2b648192a17ed3a013d23d79245c`
- `PROJECT_STATE.md`: `f1a8c007ac9c73b4addfa550302d1456b7d359cd`
- `MEMORY_INDEX.md`: `2ebda3ff40d672800d58cbe268490baa5206184d`
- `HANDOVER.md`: `9eec579f4f445e6e5027e88e25a93cf085f89338`
- `BUILD_NOTES.md`: `113ce4bc47735897fc84b9da2c66b5a82e55e334`
- `APP_BUILD_REPORT.md`: `2d86f5efe84ce9059cd4ff8d3c60300e607cca1b`
- `CHANGELOG.md`: `bb07a15427ae533005321c01fb14f20451214395`
- `README.md`: `6856a051e47619a374b9e62b89b474fb313169b2`
- `CHAT_RULES.md`: `97a2e149e51cf467d8a92fd76f17ec860ec319b8`
- Workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`.
- **Pre-transfer main state:** HEAD `fa781a8edb07c9882134ec1ba0cd2a988fbe7d8c`, parent `0e3e76832be770f58ecb12a1e3406175f1ec2f07`, tree `7fd8e62ce6b73dcd879e54858f9289f65ec647ec`. This snapshot intentionally omits its own future transfer commit/blob. Re-fetch final HEAD/tree after this write.

## 7. Exact next actions and validation gates

1. Re-fetch live `main` HEAD/tree and current source/test/doc hashes before any new action. Read `MEMORY_INDEX.md`, `CHAT_RULES.md`, `PROJECT_STATE.md`, and relevant subject notes.
2. Current smoothness follow-up is **SOURCE IMPLEMENTED / NOT RUN / NOT RELEASED**. Latest released APK is Build #95, which does not include this follow-up. Do not claim new tests/analyzer passed.
3. No build is part of `@Thinking Eksekusi Full!`. A separate `@Thinking Eksekusi Build App!` is required for the guarded analyzer/test/Android/APK/release workflow, then confirm intended `head_sha` and independent Release/tag/source equality.
4. Do not manually move `jexfyz-latest`, weaken guards or add push/PR/manual bypass.
5. Firmware compilation/online update remains user-controlled. Do not read/replace BIN or touch Firebase, OTA, flash or hardware without separate authorization.

## 8. Audit / operations not performed

- Live source and the supplied screen recording were reviewed. Source-level changes address slow cycles, tiny particle details, phase-wrap behaviour, whole-icon breathing, crystal/snow coupling, Fan rate discontinuities, and Home glyph drawing size.
- Exact source/test and documentation hashes are listed above. The tree was complete and not truncated at the pre-transfer checkpoint.
- **Not run:** Flutter/Dart tests and analyzer. New source/tests have not executed. No device/profile measurements are available, so on-device smoothness and frame time remain UNVERIFIED.
- **Not performed:** App Build/release, Android APK build, tag movement, Firmware edit/compile, BIN payload access, Firebase metadata changes, OTA, flash or hardware operation.
- Build #95 remains the latest successful artifact, validated for its exact historical source only. The current smoothness source is not included in that APK.

