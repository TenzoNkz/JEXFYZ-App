# CURRENT LIVE MAIN — BUILD #165 RELEASED / DISPLAY-NAME CORRECTION INCLUDED — 2026-11-18

This top section supersedes the older Build #163 preflight/latest-package claim. Earlier audit attempts remain below as dated historical evidence.

- **Latest App package:** Build #165 / run `43905426531` / job `133432846684` / Issue #42 / attempt 1, terminal SUCCESS at source `cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d`. All workflow steps 1–21 and cleanup 39–43 succeeded. Release 403010611 / tag `jexfyz-latest` target the same source; the Release contains one APK and one corresponding source ZIP with verified digests.
- **Validation Only #44:** run `43899329198` / job `133411358928`, terminal SUCCESS. The live log confirms locked dependency resolution, a passing final formatter check after two Dart files were formatted, analyzer success with 107 info-level findings and zero warnings/errors, and **205/205 Flutter tests passed**. Formatter-only source/test tree: `0a2b3c03af433a17d82afa1d4db60beb7b1bd023`.
- **Validated-to-package comparison:** that formatted tree to Build #165 source is 17 commits ahead / 0 behind; the seven changed paths are Markdown only. No App source, test, dependency, Android configuration or workflow change separates the validated behavior from the packaged code.
- **Live recovery check (2026-11-18 19:23:05 Asia/Jakarta, before this note sync):** main HEAD `9ffd5f632009504aeb9473e04d3fd06dac1fa632`; recursive tree 139 entries (93 blobs / 46 trees), `truncated=false`. Compare from package source to that main HEAD is 128 commits ahead / 0 behind, with nine changed paths and no non-Markdown path. No open PR or active Actions run was found.
- **Ruleset recheck:** `main-safety-guard` (ID `27528678`) remains Active for `~DEFAULT_BRANCH`, with only deletion and non-fast-forward rules, no bypass actors, and `current_user_can_bypass=never`.
- **Bluetooth display correction:** Build #165 contains the App-only correction that prioritizes the advertisement name, then platform name, then localized generic fallback. The owner reports that `JE X FYZ` is visible (USER-REPORTED); no screenshot, exact installed package/build or advertisement payload was provided. Physical BLE/OEM confirmation remains NOT VERIFIED.
- **Decision:** the display-correction source, regression, hosted validation, guarded package/release and main safety Ruleset stages are complete. This does not mean all product validation is complete. No new source fix, Validation Only run or App Build is indicated by the owner report.
- **Separate evidence still unverified:** installed-package identity, screenshot/OEM/RF behavior, long-session CPU/memory/storage soak, Firmware compile/BIN provenance, BLE App-only identity, Firebase, OTA/flash, and thermal/electrical acceptance. These are separate scopes; Diskusi authorizes none of their operations.
- **Retained package warnings:** self-signed PKIX trust-chain and META-INF signature-coverage warnings; Kotlin 2.2.20/Firebase KGP compatibility; Android Gradle/Gradle 10 deprecations; Notification priority deprecations; native ELF DWARF; native Android JUnit tasks NO-SOURCE. These are not marked fixed.

### Next gate

- No App build gate remains for the display-name correction. If independent field acceptance is wanted, the owner can provide a fresh cooler-scan screenshot plus exact installed build/package details and (if available) the live advertisement name. No new build trigger is needed for that evidence.
- Keep Firmware/BIN, Firebase, OTA, flashing and physical electrical/thermal work outside App scope and separately authorized.
