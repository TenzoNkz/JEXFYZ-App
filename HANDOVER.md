# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-11 (Asia/Jakarta).

## Current App candidate — post-Build #146 test repairs

- Failed run: Build #146 / Actions run 42944693211, job 130274555621, source d5bc688cc14243cd944f2d8d653bbcb59d2805fe. Analyzer passed (23 info, 0 warnings/errors); Flutter tests failed 161/5; downstream Android/Release gates skipped. No artifact.
- Test fixes committed: LED height rounds to integer logical pixels (4028949dca6c2f5ced55f54861b6c5197426c1dd); Statistics contract checks vsync-driven animation and cursor test ensures lane fully visible before tap (fb845d88567503de4a78668c2b6b08eeb61de5e5); LED/Peltier compact layout contracts updated (b1609b01d4dee470b96e2030cb5583df1efc1351).
- Next: one guarded hosted retry after fresh preflight. New run must prove all fixes and original 21 gates.
- Known risks remain: full-summary recomputation each second; unbounded/unbatched SQLite queue; long-session CPU/memory/backpressure; animation lifecycle/60–120-Hz stress tests.

## Latest verified package — Build #143

- Run 42783474515, job 129718855331, source/tag 121ef9e0f5ed6a0003837d32e4c8b1701f38631a. All 21 gates passed. Flutter 159/159; Android native task NO-SOURCE caveat. Signing/source/Release/download checks passed.
- Build #143 predates current overlay/Statistics source. Preserve versionName "Telegram @horizontalzzz"; App-only scope.

