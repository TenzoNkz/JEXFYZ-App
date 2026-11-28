| Last updated | 2026-11-28T15:42:17+07:00 (Asia/Jakarta) |

> Event-driven project marker. It is not a live heartbeat or a GitHub lock.

## Current marker

| Field | Value |
|---|---|
| **STATUS** | **IN_PROGRESS** |
| SESSION STATUS | IN_PROGRESS — CODE_FULL resumed by a fresh owner command. Build App is explicitly postponed by the owner; no Build/App package operation is authorized in this interaction. |
| WORK STATUS | IN_PROGRESS — WP9 remains active. The disconnected-card regression now covers 350/420 dp × EN/ID × Light/Dark and all 362 Flutter tests pass on the current test commit; #337 exposed only a formatter failure. Apply the runner's exact formatter output, strengthen the preserved Home-to-Connection-flow structural contract, then run exact-SHA Validation Only. |
| WORKSPACE | CODE_FULL |
| Mode | ChatGPT/Codex-only App source/test work directly on main; one WP per fresh owner command. Build App/APK/Release, Firmware/BIN, OTA, production Firebase, signing, flashing and physical-device operations remain outside this workspace. |
| Request | 2026-11-28 — owner says Build App should wait and asks to continue Code work first until the authorized Code scope is genuinely complete. |
| Active work package | WP9 — locked-card CTA removal and regression coverage. Source patch 62a89aa3602575062f268c4823a186f034faf9ec; formatter fix baseline 3d21cf5eac31eee76f5e8ef784bce10886a7584d; expanded matrix commit 80fb686609ce60112e0e67d185a23488a71bb0df. Do not start WP10 in this command. |
| Owner decision | Keep the locked submenu card informational without Connect/Hubungkan. Preserve Home top-left Bluetooth entry point and its existing manual Connection flow. Defer Build App until owner explicitly requests it. |
| Validation Only #337 | Run 46126865168 / job 140923281634, exact SHA 80fb686609ce60112e0e67d185a23488a71bb0df, terminal FAILURE solely at formatter. Locked dependencies PASS; analyzer PASS; full Flutter suite 362/362 PASS. One changed file: test/dashboard_display_menu_test.dart; exact canonical output captured from runner and remains to apply. |
| Previous validation | Validation Only #336 / run 46123591878 / job 140913176417, SUCCESS on SHA 3d21cf5eac31eee76f5e8ef784bce10886a7584d: dependencies PASS; formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; Flutter tests 361/361 PASS. |
| Previous package | Build App #173 / run 46121055519, source SHA 478bdfdc5ee18379e07baad5e4dfd8ab598dc2db; its five owner-accepted screenshots predate the current locked-card CTA change. No new package is requested now. |
| Local validation | Flutter, Dart, Gradle, ADB and emulator are unavailable; Android SDK environment variables are unset. Hosted Validation Only is Flutter-only. |
| Deferred hardware | Cooler discovery/session, real BLE, commands, telemetry, Firmware interaction, thermal/electrical behavior and physical cooler operation remain DEFERRED / NOT TESTED. |
| External operation | Validation Only #337 is terminal FAILURE (formatter only). No Build App/APK/Release or device operation is authorized or running. |
| Next action | Apply exact canonical formatting to the matrix test and strengthen the Home-to-Connection structural contract; then verify a new exact-SHA Validation Only run. Keep the post-patch screenshot deferred and do not cross into WP10. |

## Historical workspace context

WP8 Floating Monitor boundary remains COMPLETED. The owner's acceptance of Build #173 applies to the previously shown stage only; the latest locked-card change is not rendered in that package. Build App is postponed at the owner's direction. WP10 remains NOT STARTED.
