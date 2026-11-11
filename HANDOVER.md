# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-11 (Asia/Jakarta).

## Current App candidate — cursor readout pinned; hosted QC pending

- Latest executable source: f56b2a9a4893a1a0810cfdfb38524fd79df87d05.
- Statistics selected-time readout is moved to a conditional pinned Scaffold.bottomNavigationBar. It remains mounted when the selected Peltier lane is far down the lazy ListView. Default prompt remains within the ListView before selection. Listener, tap-up and drag cursor callbacks remain; existing widget test taps the scrolled Peltier lane and expects Waktu dipilih.
- Build #144 failed analyzer (12 errors, 3 warnings); #145 failed analyzer (one nullable-double type error); #146 analyzer passed but Flutter tests 161/5; #147 analyzer passed, tests 164/2; #148 analyzer passed, tests 165/1 (cursor readout only). All are terminal, no package/release.
- Readout root cause was structural: its location inside a lazily built ListView could cause it to be unmounted when scrolling to a later chart. The pinned bottom panel fixes placement; hosted validation still required.
- No active run or open PR at preflight; issue #33 exact open; workflow issue-only unchanged. Release baseline remains Build #143.
- Performance gaps remain: full summary recompute each second, unbounded/unbatched SQLite queue, long-session CPU/memory/backpressure and animation lifecycle/60–120-Hz tests. These must not be claimed validated.
- Preserve Android versionName "Telegram @horizontalzzz". App-only scope.

## Latest verified release — Build #143

- Run 42783474515, job 129718855331, source/tag 121ef9e0f5ed6a0003837d32e4c8b1701f38631a. All 21 gates passed.
- Analyzer 25 info only, Flutter 159/159, Android task NO-SOURCE caveat; V1/V2/V3 signing, pinned certificate, source ZIP and downloaded Release checks passed.
- #143 predates the current Statistics and compact modal changes.

