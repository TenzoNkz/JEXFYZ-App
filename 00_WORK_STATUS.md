| Last updated | 2026-11-28T15:46:04+07:00 (Asia/Jakarta) |

> Event-driven project marker. It is not a live heartbeat or a GitHub lock.

## Current marker

| Field | Value |
|---|---|
| **STATUS** | **IN_PROGRESS** |
| SESSION STATUS | IN_PROGRESS — CODE_FULL executing the single active WP9. Build App is explicitly postponed by the owner; no package/build operation is authorized in this interaction. |
| WORK STATUS | IN_PROGRESS — WP9 lock-card regression now covers 350/420 dp × EN/ID × Light/Dark; Home-to-Connection structural contract is added. Validation Only #338 completed with formatter-only failure; dependencies, analyzer and 362/362 tests passed. Apply exact canonical formatter output to both tests, then run exact-SHA validation. |
| WORKSPACE | CODE_FULL |
| Mode | ChatGPT/Codex-only App source/test work directly on main; one WP per fresh owner command. Build App/APK/Release, Firmware/BIN, OTA, production Firebase, signing, flashing and physical-device operations remain outside this workspace. |
| Request | 2026-11-28 — owner says Build App should wait and asks to continue Code work first until the authorized Code scope is genuinely complete. |
| Active work package | WP9 — locked-card CTA removal and regression coverage. Do not start WP10 in this command. |
| Owner decision | Keep the locked submenu card informational without Connect/Hubungkan. Preserve Home top-left Bluetooth entry point and its existing manual Connection flow. Defer Build App until owner explicitly requests it. |
| Current test commit | 49bc706986600b52f21666abd57ab71bdb1ca9f2. Test matrix covers 350/420 dp × EN/ID × Light/Dark; source-contract assertions ensure Home Bluetooth still calls the guarded manual Connection sheet and preserves its scanner/connect callbacks. |
| Validation Only #338 | Run 46127149091 / job 140924164593, exact SHA 49bc706986600b52f21666abd57ab71bdb1ca9f2, terminal FAILURE solely at formatter for test/dashboard_display_menu_test.dart and test/widget_test.dart. Dependencies PASS; analyzer PASS; full Flutter suite 362/362 PASS. Exact canonical output captured from runner and remains to apply. |
| Validation Only #337 | Run 46126865168 / job 140923281634, exact SHA 80fb686609ce60112e0e67d185a23488a71bb0df, terminal FAILURE only at formatter for test/dashboard_display_menu_test.dart. Dependencies/analyzer PASS; full Flutter suite 362/362 PASS. |
| Validation Only #336 | Run 46123591878 / job 140913176417, terminal SUCCESS on SHA 3d21cf5eac31eee76f5e8ef784bce10886a7584d: dependencies PASS; formatter 63/0 changed; analyzer 157 info / 0 warnings / 0 errors; tests 361/361 PASS. |
| Previous package | Build App #173 / run 46121055519, source SHA 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db; its five owner-accepted screenshots predate the current locked-card CTA change. No new package is requested now. |
| Local validation | Flutter, Dart, Gradle, ADB and emulator are unavailable; Android SDK environment variables are unset. Hosted Validation Only is Flutter-only. |
| Deferred hardware | Cooler discovery/session, real BLE, commands, telemetry, Firmware interaction, thermal/electrical behavior and physical cooler operation remain DEFERRED / NOT TESTED. |
| External operation | Validation Only #338 is terminal FAILURE (formatter only). No Build App/APK/Release or device operation is authorized or running. |
| Next action | Apply exact runner formatting to both changed test files, review the pure-format diff, and verify a new exact-SHA Validation Only run. Keep package screenshot deferred and do not cross into WP10. |

## Historical workspace context

WP8 Floating Monitor boundary remains COMPLETED. Build #173 acceptance applies to the previously shown stage only; the latest locked-card change is not rendered in that package. Build App is postponed at the owner's direction. WP10 remains NOT STARTED.
