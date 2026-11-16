# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-16 (Asia/Jakarta). This is the immediate operating handover; detailed decisions and evidence remain in CHAT_TRANSFER.md and APP_NOTES.md.

## Current state — RECOVERY_REQUIRED

- Prior `Eksekusi Full!` localization/formatting work was interrupted before closure. The source changes are partially committed, but the current main branch is **not buildable**.
- Latest live main HEAD at the current Diskusi review entry was `5007a9b1eab972ea89d2dfc2939db7adf69e6799`; the source-updated revision remains `05ab2bcf9a619b497d1a9f6f2abc974093808f37`. Subsequent commits in this review are documentation/status-only; no source repair has occurred.
- `lib/main.dart` is corrupted: 1,582,015 bytes / 45,030 lines versus the clean 403,036-byte baseline blob `48dd0c943075db076769c3d9dc53b8b71a28a5c3`. It contains repeated top-level classes/functions and an orphaned fragment near line 11,447. Hosted Validation Only #27 logs show Dart formatter failure (exit 65) and duplicate-definition analyzer errors. Do not build this source.
- **Latest delivered package remains Build #163**, run `43679305537` / job `132706236782`, Release `403010611`, tag `jexfyz-latest`, package SHA `9466e8eeb269da5bc8806f0df1d4212cf24e1746`. It remains valid as the previous package but does not contain the recent localization changes.

## Partial progress already present on main

- Exact Adaptive profile labels and legacy aliases are aligned in `lib/app_settings.dart`; generic Hotside, Voltage, OTA Online/Daring, Adaptive inactive/nonaktif and 5 V ceiling / 12 V floor labels have been corrected.
- Usage Statistics dates, decimal axes, temperature labels/units and copy were partly localized; its focused test was updated.
- Floating Monitor scale numbers and native HUD metric units were localized; MainActivity Device alerts title was corrected.
- Home notice and OTA byte grouping changes are present in the damaged main.dart and require reconstruction before acceptance.

## Remaining blockers and QC gaps

1. Rebuild `lib/main.dart` from clean blob `48dd0c943075db076769c3d9dc53b8b71a28a5c3`; reapply only intended Home/NOTIFY, locale parser, OTA byte-grouping and legacy-notice changes once. Never append full-file content or salvage by arbitrary truncation.
2. Remove the visible Adaptive ceiling card/readout while preserving `adaptiveCeiling`, `ADAPTIVE_CEILING`, Firmware clamp and Lock Voltage behavior.
3. Update stale regression expectations: `test/localization_contract_test.dart` expects ungrouped OTA bytes; `test/device_copy_notification_contract_test.dart` still expects `Suhu Hotside`. Add the missing semantic, native-HUD, Device alerts, Adaptive-card absence and protected-contract tests.
4. Re-review HEX-aware color names; verify EN/ID labels at 350-dp/360-dp only after an authorized build/render or actual screenshots are available.

## Next authorization

- The next safe command is `Eksekusi Full!` to repair the App source/tests/docs scope and run the allowed non-publishing quality checks once the source is syntactically complete.
- `Eksekusi Full!` does **not** authorize App Build/release. A new APK requires a separate `Eksekusi Build App!` command.
- No Firmware compilation, BIN publication, Firebase mutation, OTA, flashing or physical-device operation is authorized or implied.

## External evidence

- Validation Only #27 / run `43808741923` / job `133105410519` / source `05ab2bcf9a619b497d1a9f6f2abc974093808f37`: terminal CANCELLED; job logs show formatter/parser and duplicate-definition analyzer errors.
- Earlier Validation Only #20 failed one stale copy assertion; #22 failed stale formatter-signature calls. Runs #23–#27 were cancelled; no successful validation covers the current correction set.
- Build #163 / run `43679305537` / Release `403010611`: COMPLETED / SUCCESS for the older package source only.
