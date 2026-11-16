# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-16 16:10 (Asia/Jakarta). Detailed owner decisions and evidence remain in CHAT_TRANSFER.md and APP_NOTES.md.

## Current state — SOURCE RESTORED / VALIDATION UNKNOWN

- Owner authorized `Eksekusi Full!`. Source recovery and scoped regression repairs are committed to canonical `main`.
- `lib/main.dart` restored from clean baseline blob `48dd0c943075db076769c3d9dc53b8b71a28a5c3`; source commit `b4558cee8b5a4455603473d31e46b3b108f20576`; current blob `b12ea764b674b79f8a19bd70191fcf25ea3046a5`, 401,983 characters / 11,427 lines.
- Static readback confirms one active `LedColorPreset`, `TamperApp`, and `DashboardScreen`; previous duplicate classes/malformed fragments are gone.
- Reapplied localized Home temperature parsing/notices, legacy notice normalization, Peltier re-arm copy, OTA byte grouping and Adaptive profile notification. Removed only the visible Adaptive ceiling card. Internal `adaptiveCeiling` state and `ADAPTIVE_CEILING` telemetry remain; no Firmware/BLE protocol change.
- Regression tests updated in `test/localization_contract_test.dart`, `test/widget_test.dart`, and `test/usage_statistics_test.dart`. Added coverage for decimal comma/dot, legacy Home notices, OTA grouping, exact active/legacy profile labels, and Adaptive card absence with state retention.

## Validation gate

- Static lexical scan passed for six Dart source/test files; source contract checks passed for duplicate class removal, card absence, retained state/telemetry, locale parser, OTA grouping and updated test expectations.
- Local Dart/Flutter SDK is unavailable. Formatter, analyzer and Flutter test suite are **NOT VERIFIED**.
- `.github/workflows/jexfyz-app-validation.yml` is push-triggered for `main` changes under `lib/**` and `test/**`. The available GitHub workflow-run lookup exposes PR-triggered runs only; latest push-run status is UNKNOWN. Obtain the latest `JE X FYZ — Validation Only` run ID/result before treating source as build-ready.
- **Do not run Build App until formatter, analyzer and Flutter tests are green.** A separate `Eksekusi Build App!` is mandatory after validation.
- Latest verified package remains Build #163 / run `43679305537` / job `132706236782` / Release `403010611` / tag `jexfyz-latest` / source `9466e8eeb269da5bc8806f0df1d4212cf24e1746`. It predates this source recovery.
- Visual/OEM screenshots, owner installation, BLE field behavior, Firmware compile/BIN provenance, thermal/electrical tests, Firebase, OTA/flash remain unverified.

## Next action

Owner checks the latest Validation Only run in GitHub Actions and shares its run ID/outcome. Continue repairs under the current Eksekusi Full authorization if any gate fails; only after all gates pass should a separate Eksekusi Build App! be considered.

## External evidence

- Validation Only #27 / run `43808741923` / job `133105410519` / source `05ab2bcf9a619b497d1a9f6f2abc974093808f37`: historical terminal CANCELLED; formatter/parser and analyzer failures were caused by the previously corrupted source.
- Build #163 / run `43679305537` / Release `403010611`: SUCCESS for the older package source only.
