# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-10 (Asia/Jakarta).

## Current published release — Build #138

- [Actions run 42749408202](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42749408202), job 129609197264, terminal success on source b553f22092d9b33b2c81753254d2e3f03928fa18.
- All 21 main workflow steps passed; analyzer had 25 info-only diagnostics/no warnings; Flutter suite passed 157/157. Android Gradle gate succeeded but native app JUnit tasks were NO-SOURCE.
- Obfuscated APK passed V1/V2/V3 and expected production-certificate verification. Matching source ZIP and downloaded Release assets passed integrity/identity verification. Release/tag jexfyz-latest point to #138 source.
- This package predates the current Home/Statistics source changes described below.

## Current App candidate — Build #139 pre-trigger

Preflight source HEAD: 8115f6702c9be1381c10d1ed610b4a6e720c6753; recursive tree 131 entries, complete. Two App change groups are now committed on main and await hosted CI:

**1. Default hybrid Home palette.** Default/Dark use the dark header palette; Light uses light. _homeMetric() and _homeNotify() share the same preset-based header resolver. The lower panel remains independently light for Default/Light and dark for explicit Dark. Regression tests assert all three mappings and both header call sites.

**2. Usage Statistics active-run sampling.** A run requires full BLE/P1 readiness, valid protocol and known authoritative output telemetry, and stays active only while FAN or PELTIER is ON. Both OFF, disconnect/disposal or stale P1 closes it. Per-second Battery/Hotside samples are stored in local SQLite with explicit null gaps. Voltage/Adaptive/Fan Speed remain event-driven against elapsed-run seconds. The wall-clock 1H/24H/7D/30D filter is removed; 30-day pruning remains retention. Regression tests cover output gating, elapsed-time analytics, gaps, session separation and local-only storage.

Per-second SQLite growth/queue pressure and actual phone BLE sampling remain UNVERIFIED; CI does not establish physical acceptance.

## Trigger / CI state

- Workflow: .github/workflows/jexfyz-app-build-trigger.yml, blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12; issue-open/reopen only with owner, exact title and body token; all analyzer/test/Android/signing/source/Release/download gates intact.
- Issue #33 is OPEN and exact: owner TenzoNkz, title JE X FYZ — EKSEKUSI BUILD APP TRIGGER, body token JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1.
- Latest App run #138 is terminal success; no active/queued run and no open PR were found. No new trigger has been sent yet.
- Last completed gate: repository/source/workflow/issue/Actions/jobs/logs/Release/tag/artifact preflight. Current run state: NOT STARTED.
- Next: commit/re-read this pre-trigger ledger/checkpoint; refresh final main HEAD/tree and trigger/Actions state. Then close issue #33 once, verify closed and no run, reopen exactly once. Follow only the single new issue-triggered run and require exact head_sha parity with final pre-trigger main. Do not repeat event if no run appears.

## Protected scope

Keep Android versionName "Telegram @horizontalzzz". Do not compile Firmware, publish/replace BIN, modify Firebase, use OTA, flash or operate devices. Build CI does not prove installation, OEM visuals, BLE behavior, cooling or thermal/electrical performance.
