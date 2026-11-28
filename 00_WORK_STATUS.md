| Last updated | 2026-11-28T12:20:51+07:00 (Asia/Jakarta) |

> Event-driven project marker. It is not a live heartbeat or a GitHub lock.

## Current marker

| Field | Value |
|---|---|
| **STATUS** | **IN_PROGRESS** |
| SESSION STATUS | IN_PROGRESS — fresh `@Thinking Eksekusi Code!` command; WP8 only. |
| WORK STATUS | IN_PROGRESS — WP8 Floating Monitor boundary: scoped extraction of Dart value models, storage, MethodChannel/runtime projection and stateless Flutter configuration view; preserve native renderer/lifecycle contracts. |
| WORKSPACE | CODE_FULL |
| Request / work item | 2026-11-28 — exact owner command `@Thinking Eksekusi Code!`; active checkpoint authorizes next pending WP8 only. |
| Started | 2026-11-28T12:17:57+07:00 (Asia/Jakarta) |
| Current phase | G3 passed — preflight and bounded architecture plan complete. Begin exact-SHA implementation of the Dart-only Floating Monitor boundary; update behavioral/source-contract tests and durable docs. |
| Verified base main | `b4bb16251d0cec18b5fd22f40e963867a16e4396`; recursive tree 179 entries / 133 blobs / 46 trees / `truncated=false`; WP8 target source/test blobs fetched live. |
| Included source paths | `lib/floating_monitor.dart` (controller/composition), new `lib/floating_monitor_models.dart`, `lib/floating_monitor_store.dart`, `lib/floating_monitor_bridge.dart`, `lib/floating_monitor_state.dart`, `lib/floating_monitor_settings_view.dart`; `lib/main.dart` (explicit authoritative telemetry/language projection), `lib/app_bootstrap.dart` (startup restore/state publication). |
| Included regression paths | `test/floating_monitor_store_test.dart`, `test/floating_monitor_bridge_test.dart`, `test/floating_monitor_accessibility_test.dart`, `test/floating_monitor_layout_contract_test.dart`; add focused view/model tests only if required by the extracted contracts. Review existing source contracts in `test/widget_test.dart` and bootstrap tests. |
| Native and protected invariants | Read-only native references `MainActivity.kt`, `FloatingMonitorService.kt`, AndroidManifest; no edits planned. Preserve channel `je_x_fyz/floating`, existing method names and JSON keys, config schema v2 and legacy v1 metric migration, FlutterSecureStorage key `jexfyz_floating_v1`, native SharedPreferences key `jexfyz_floating_native_v1`, size 0.30–1.00/0.05 steps/default 0.60, opacity 0–100%/5%/default 90%, six metric IDs B/H/V/A/P/F, selected language mapping, permission gate, service START_NOT_STICKY and no new same-session retry/reattach/recovery policy. Dashboard remains sole BLE/GATT/P1/session/telemetry owner; bridge is value/method only. |
| Architecture acceptance | Models are immutable and independent of global state; store only loads/saves config and no longer publishes notifiers; app/state composition publishes loaded/updated config; bridge exposes typed runtime snapshot while preserving native key/alias compatibility; Settings visual is a StatelessWidget with values/callbacks only and no storage/channel/lifecycle owner. Existing view geometry, EN/ID copy, theme, slider semantics and controls remain unchanged. |
| Validation requirement | Focused store/bridge/view/layout tests, formatter, analyzer, full Flutter suite and push-triggered Validation Only on the exact final source/test SHA; inspect every diff/read-back. Android/Kotlin runtime/device/screenshot evidence is separate and unavailable here. |
| EXTERNAL OPERATION STATUS | No active Actions run observed during startup. Validation Only must be checked for the exact source/test commit after implementation. |
| Blockers / stop conditions | If extraction requires a storage-schema/key change, bridge method/channel/JSON contract change, native service lifecycle/recovery change, BLE owner movement, or an unapproved visual/layout change, stop and record blocker. No native, Firmware, OTA, Build App, signing or device action. |
| Next action | Re-fetch exact `main` HEAD and target blob SHAs before first implementation write; split value/store/bridge/state/presentation files in bounded direct-main commits and update only in-scope tests/docs. |
