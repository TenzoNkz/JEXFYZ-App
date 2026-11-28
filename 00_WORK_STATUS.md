| Last updated | 2026-11-28T15:40:08+07:00 (Asia/Jakarta) |

> Event-driven project marker. It is not a live heartbeat or a GitHub lock.

## Current marker

| Field | Value |
|---|---|
| **STATUS** | **IN_PROGRESS** |
| SESSION STATUS | IN_PROGRESS — CODE_FULL resumed by a fresh owner command. Build App is explicitly postponed by the owner; no Build/App package operation is authorized in this interaction. |
| WORK STATUS | IN_PROGRESS — WP9 is active. Expanded the locked-card regression to the 350/420-dp × EN/ID × Light/Dark widget matrix. Exact-SHA Validation Only is running; review terminal evidence, repair any genuine in-scope defect, then checkpoint the completed Code-only scope and keep package visual review deferred. |
| WORKSPACE | CODE_FULL |
| Mode | ChatGPT/Codex-only App source/test work directly on main; one WP per fresh owner command. Build App/APK/Release, Firmware/BIN, OTA, production Firebase, signing, flashing and physical-device operations remain outside this workspace. |
| Request | 2026-11-28 — owner says Build App should wait and asks to continue Code work first until the authorized Code scope is genuinely complete. |
| Active work package | WP9 — locked-card CTA removal and regression coverage. Implementation commit `62a89aa3602575062f268c4823a186f034faf9ec`; initial exact validation #336 on SHA `3d21cf5eac31eee76f5e8ef784bce10886a7584d`; expanded viewport/theme/locale matrix commit `80fb686609ce60112e0e67d185a23488a71bb0df`. Do not start WP10 in this command. |
| Owner decision | Keep the locked submenu card informational without Connect/Hubungkan. Preserve Home top-left Bluetooth entry point. Defer Build App until owner explicitly requests it. |
| External validation | Validation Only #337 / run `46126865168`, exact head SHA `80fb686609ce60112e0e67d185a23488a71bb0df`, status IN_PROGRESS at last observation. |
| Previous validation | Validation Only #336 / run `46123591878` / job `140913176417`, SUCCESS on SHA `3d21cf5eac31eee76f5e8ef784bce10886a7584d`: dependencies PASS; formatter 63 files / 0 changed; analyzer 157 info / 0 warnings / 0 errors; Flutter tests 361/361 PASS. |
| Previous package | Build App #173 / run `46121055519`, source SHA `478bdfdc5ee18379e07baad5e4dfd8ab598dc2db`; its five owner-accepted screenshots predate the current locked-card CTA change. No new package is requested now. |
| Local validation | Flutter, Dart, Gradle, ADB and emulator are unavailable; Android SDK environment variables are unset. Hosted Validation Only is Flutter-only. |
| Deferred hardware | Cooler discovery/session, real BLE, commands, telemetry, Firmware interaction, thermal/electrical behavior and physical cooler operation remain DEFERRED / NOT TESTED. |
| External operation | Validation Only #337 is IN_PROGRESS. No Build App/APK/Release or device operation is authorized or running. |
| Next action | Inspect #337 job/steps/summary on the exact SHA; if it passes, finish WP9's Code-only gates and mark the package-level screenshot as deferred until a later separately authorized Build App. Do not cross into WP10. |

## Historical workspace context

WP8 Floating Monitor boundary remains COMPLETED. The owner's acceptance of Build #173 applies to the previously shown stage only; the latest locked-card change is not rendered in that package. Build App is postponed at the owner's direction. WP10 remains NOT STARTED.
