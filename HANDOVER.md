# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-08 (Asia/Jakarta).

## Latest verified state

- Latest one-shot scanner source repair: implementation commit `6974d4e41d903f0ae11a5d0f7c316b6066029051` plus compatibility follow-up `310818f228a389930e24c85ec087476875686138`; the later documentation checkpoint is `0776d57d37078435d935a1b3620456556a7ac58b`. No executable source changed in that final documentation checkpoint. The implementation reserves one-shot Auto Connect/OTA before async prerequisites, uses fresh scan-result streams and serializes scanner commands. Validation remains NOT RUN; source is not released.

- The single operating policy is [MASTER_PROMPT.md](MASTER_PROMPT.md). [CHAT_RULES.md](CHAT_RULES.md) is only a compatibility pointer.
- Exactly two LOAD + CONTINUE prompts remain in [CHAT_TRANSFER_PROMPTS.md](CHAT_TRANSFER_PROMPTS.md). Prompt 1 is general engineering; Prompt 2 is guarded Build App/QC only.
- Gemini consultation may be proposed proactively during Discussion when a second opinion materially reduces uncertainty. Gemini has no GitHub access; the owner must paste a fully self-contained prompt and return its answer for repository-backed review.
- Latest independently verified App release remains Build #129 / run `39925045446`, source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`. The compact Settings/Connection pass is on main but not in that release.
- Latest `main` workstream corrects English/Indonesian labels (Fan Speed vs Fan, Hotside, Adaptive Mode and Floating Monitor/Monitor Melayang), localizes the Android Floating Monitor notification and adds regression contracts. A static audit confirms 320 bilingual dictionary entries; widget tests now validate the complete table and reject missing debug localization keys. It also adds explicit Bluetooth scan lifecycle/no-result/permission/error presentation and 350-dp/420-dp compact-theme coverage. Source/tests are NOT RUN because Flutter/Dart/Android toolchains are absent. Latest App source fix commit: `04716e7eb79774c3b3d9bff6217797a4edacf05c`; final localization coverage-test commit: `b3578e3a2672a93427507814b883d343a0588bd4`. Verify live `main` before the next change.
- Repository workflow/documentation cleanup is documentation-only. No App source, Firmware source, tests, build workflow or release behavior is authorized to change merely by this handover.

## Agent skills and capability routing

- `MASTER_PROMPT.md` is the sole operating policy; `AGENTS.md` is the cross-agent entrypoint; `SKILLS_INDEX.md` is the skill catalogue.
- Twelve skills are stored in `.agents/skills/` for Codex-compatible discovery and mirrored byte-for-byte under `.github/skills/` for GitHub Copilot. The catalogue includes dedicated `code-review` and `product-design-and-visual-quality` skills.
- Non-trivial UI/UX work must load the product-design skill and read `PRODUCT_DESIGN_CONSTITUTION.md` plus `VISUAL_QUALITY_GATE.md`; `DESIGN_NOTES.md` remains the authority for approved screen-specific constraints.
- ChatGPT in this environment must fetch/read a relevant private repo `SKILL.md` manually through GitHub tools; it is not auto-installed as a ChatGPT skill. Gemini is manual-only and has no GitHub access.
- Current tool snapshot: Python/Git available; Flutter/Dart/Gradle/ADB/Arduino CLI/ESP-IDF unavailable. Re-check before any validation task.

## Next safe action

The passive/manual/one-shot scanner ownership repair and coordinator regression coverage are committed, SOURCE IMPLEMENTED / NOT RUN, and have no additional source defect substantiated by the latest static review.

1. In a Flutter 3.47.2 environment, run `dart format lib/main.dart lib/connection_scan_coordinator.dart test/connection_scan_coordinator_test.dart test/floating_monitor_layout_contract_test.dart`.
2. Run `flutter test test/connection_scan_coordinator_test.dart test/floating_monitor_layout_contract_test.dart test/widget_test.dart`.
3. Run `flutter analyze --no-fatal-infos`, then the complete `flutter test` suite.
4. If any formatter/test/analyzer failure identifies a source defect, use a scoped `Eksekusi Full!` repair, commit it to `main`, and repeat the affected checks. Do not repeat the already-completed scanner implementation without a new finding.
5. When formatting is clean and source repair is no longer pending, separately authorize `Eksekusi Build App!`. Its guarded hosted workflow independently runs the architecture/security audit, dependency install, analyzer, full Flutter tests, Android Gradle gate, APK build, V1/V2/V3 + certificate checks, corresponding-source ZIP, Release/tag and downloaded-asset integrity gates.
6. After the resulting APK is installed by the owner, perform physical Android BLE lifecycle QA: duplicate Auto Connect during pending prerequisites; manual-sheet pre-emption and neutral dismissal; selected-device handoff; fresh primary/fallback advertisements; adapter loss; OTA disconnect/recovery. Also inspect the compact UI at 350-dp/420-dp. Hosted CI is not proof of device or visual behavior.

Flutter/Dart/Gradle/ADB are unavailable in this container, so formatter and local test/analyzer checks remain BLOCKED / NOT RUN. No build or device operation has been performed in this Discussion.

## Evidence and safety boundary

Build #129 is the latest published artifact, not proof of installation on the field unit. Firmware V7.1 compile/Online OTA remains USER-REPORTED; BIN identity and physical behavior remain UNVERIFIED. No Firmware compile, BIN/Firebase operation, OTA, flashing or device operation is authorized by this note.