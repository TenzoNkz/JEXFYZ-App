# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed for the seven-icon visual rework on 2026-10-19 (Asia/Jakarta). This is the canonical boot snapshot. Before further action, re-fetch live `main`, full tree, relevant source/test/doc hashes, workflow, Actions runs, Release/tag, branches/PRs and the firmware-artifact repository. This file is written last; the pre-transfer values below refer to the source state immediately before this transfer commit. It deliberately does not self-reference its future blob or commit SHA.

## 1. Authority, repository roles and command protocol

- **Canonical editable repository:** `TenzoNkz/JEXFYZ-App`, branch `main`. Use the live source, tests, docs, workflow and build ledger.
- **Artifact-only repository:** `TenzoNkz/JEXFYZ-Firmware` must contain exactly `JEXFYZ.cpp.bin`. Latest inspected recursive tree contained exactly one entry: blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, size 1,457,008 bytes. The payload was not read; source-to-BIN provenance remains UNVERIFIED.
- **Commands:** `@Thinking Diskusi!` = read-only; `@Thinking Eksekusi Full!` = scoped source/tests/docs/audit/commit, but not App Build, Firmware or device operations; `@Thinking Eksekusi Build App!` = the only command authorizing complete App analyzer/test/build/release flow; `@Thinking Chat Stuck!` = recover an existing stalled task without wider authorization. Retired aliases: `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, standalone `@Thinking Eksekusi!`.
- **Workflow:** `.github/workflows/jexfyz-app-build-trigger.yml`, blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`. It remains guarded to `issues.opened`/`issues.reopened` and exact repository-owner/title/body-token checks. No push/PR/manual bypass.
- User compiles Firmware. Functional Firmware edits require matching version/filename and exactly one active versioned sketch. Do not modify Firmware/BIN, Firebase production metadata, OTA, flash or physical hardware without separate authorization.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`. Never expose signing-key contents. Test files/source assertions/CI do not prove physical behavior.
- Current task scope was App icon visuals, regression assertions and related docs. No Dart/Flutter tests/analyzer, App Build/release, Firmware compile/edit, BIN payload access, Firebase/OTA/flash/device operation was performed.

## 2. App/Firmware identity

- App: JE Cooler; header/brand JE X FYZ; pubspec `1.0.0+3`; application ID `com.horizontalzzz.jexfyz`; minSdk 24, targetSdk 36, compileSdk 37.
- Active editable Firmware: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`, embedded `FW_VERSION="V6.7"`. User-reported compile/online-update status is not independently verified; source-to-BIN provenance and installed-device version remain UNVERIFIED.
- The latest successful App artifact remains **Build #92**, [Actions run 39211726896](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39211726896), exact source `6610fecb3e47d9941cbf96043b7da3b2a869753b`. Analyzer passed with 23 informational deprecations; 98/98 Flutter tests passed; all 21 workflow steps passed; Android configured gate, APK V1/V2/V3 + production certificate, source ZIP, downloaded digests and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- Build #92 APK asset `655482761`, 54,636,635 bytes, SHA-256 `ee3ce9cb9697b8bcabf4da829fc64c16524bbe914eb83901f5d21c855d706926`. Corresponding source ZIP asset `655482764`, 2,857,021 bytes, SHA-256 `7ec969d092638790dd36b5d71c758b68cdc11a0e8db2bdfb390c812f541e677a`. These results apply to Build #92 source only.

## 3. Current seven-icon source follow-up — NOT RUN / NOT RELEASED

- Current `lib/main.dart` blob: `ec8d682432946bd5b9afea925685855d632610b8`.
- Current `test/widget_test.dart` blob: `ab0862470846455465b65ec294d33d39c07aac62`.
- Current `lib/jex_animated_glyph.dart` blob: `b37fc4e0807c874b2f01db00c7f606810cb5deca`; generic navigation/settings/action glyphs remain static, since they are not live telemetry indicators.
- Source changes after Build #92: Battery/Hotside warnings add three pointed embers falling top-to-bottom within their own silhouettes with smooth fade-in/out; anchored flame tongues and existing 280 ms warning transition remain. The Hotside configured threshold, colours and safety behavior are unchanged.
- Fan rotor geometry changed to **exactly three broad swept blades** and a layered hub. The existing three airflow ribbons remain fixed in geometry/count/colour regardless of PWM; only rotor speed follows the established voltage/PWM policy, with the existing permitted connected one-shot coast-down.
- A shared restrained luminous-core helper now gives Battery/Hotside, Voltage bolt, Adaptive arrows, Peltier crystal, Fan rotor and Fan Speed active arc/needle a consistent premium glow. Voltage’s closed-spine pulse and branch strikes, Adaptive’s paired rotating arrows, six-branch Peltier crystal and falling branched snow, and half-circle PWM speed gauge retain their distinct state/telemetry behavior.
- Updated source-contract assertions cover falling fire, three-blade geometry, glow helper and state gates. They have **NOT RUN**. Do not report Build #92's 98/98 tests as validation of the newer source. This update is not in the Build #92 APK.
- No Home layout/control, semantic voltage colours (5V red, 9V green, 12V blue), BLE protocol, telemetry meaning, Adaptive/PWM control or firmware safety behavior was changed.

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

- `lib/main.dart`: `ec8d682432946bd5b9afea925685855d632610b8`
- `lib/jex_animated_glyph.dart`: `b37fc4e0807c874b2f01db00c7f606810cb5deca`
- `test/widget_test.dart`: `ab0862470846455465b65ec294d33d39c07aac62`
- `DESIGN_NOTES.md`: `0222d1760ac21616ea78d24a5e296c016f8bbb4e`
- `CHANGELOG.md`: `0cd02c3d34b5ea7ab0c67be4bd036db88ed4356e`
- `APP_NOTES.md`: `7a6f886133d0c139d32259f55b27121436a9f420`
- `PROJECT_STATE.md`: `07eb09320048550c8bffb3e5f910b5865dd9b64e`
- `HANDOVER.md`: `bb5d6783972a172d387bc2fc95682c91387eaf07`
- `MEMORY_INDEX.md`: `61a277222121a85638be53d94816c5a41a20d688`
- `BUILD_NOTES.md`: `199916b7028dd3bb46cfbf6b543fff7170dcf138`
- `APP_BUILD_REPORT.md`: `ff26db36f03987f697df6d373f7b42f0a363bff8`
- `README.md`: `16107b66a6cf8031e72803f8e83a9797a6571819`
- `CHAT_RULES.md`: `97a2e149e51cf467d8a92fd76f17ec860ec319b8`
- Build workflow: `.github/workflows/jexfyz-app-build-trigger.yml` `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`.
- Pre-transfer main HEAD: `e21d8689b50854aaa5685c72d2f16f79557031e3`, parent `61570f23ec17a9e411eaab5cb260cef11c1f03ab`, commit tree `d3dca07b8e970bced866519e05869210aaf93425`. This file intentionally does not list its own future blob hash.

## 7. Exact next actions and validation gates

1. Re-fetch live `main` HEAD/tree and relevant source/test/doc hashes before the next action; then read this file, `MEMORY_INDEX.md`, `CHAT_RULES.md`, `PROJECT_STATE.md` and the subject-specific reference.
2. Current seven-icon follow-up is **SOURCE IMPLEMENTED / NOT RUN / NOT RELEASED**. Do not claim test/analyzer success based on Build #92 because that run predates the latest source.
3. Do not build as part of `@Thinking Eksekusi Full!`. After separate `@Thinking Eksekusi Build App!` authorization, use the unchanged official issue-only workflow, confirm intended source `head_sha`, pass all analyzer/test/Android/APK/signing/source-ZIP/digest gates and independently verify the Release/tag source equality.
4. Do not manually move `jexfyz-latest`, weaken workflow guards or add push/PR/manual bypasses.
5. Firmware compilation/online update remains user-controlled. Do not read/replace the BIN or touch Firebase, OTA, flash or hardware without separate authorization.

## 8. Audit / operations not performed

- Live source and tests were re-fetched. Static source-contract inspection confirmed the falling-fire helper and top-to-bottom particle path, fade-in/out and clipping, exactly three Fan blades, fixed three airflow ribbons, consistent luminous-core use on the icon family, explicit `BlurStyle`/`MaskFilter` imports, and the updated test assertions.
- Tree remains complete with 67 entries; firmware artifact repo still contains only `JEXFYZ.cpp.bin`. Workflow, Firmware V6.7 source and artifact BIN were not changed.
- **Not run:** Dart/Flutter analyzer and test suite; the source-contract tests are not execution evidence.
- **Not performed:** App Build/release, tag movement, Firmware edit/compile, BIN payload access, Firebase production-metadata changes, OTA, flash or physical device operation.
- Real-device rendering, animation smoothness, BLE/PWM response and thermal/cooling behavior remain UNVERIFIED.
