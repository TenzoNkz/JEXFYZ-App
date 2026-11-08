# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-08 (Asia/Jakarta).

## Latest verified state

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

The Full-mode source/test repair is committed but not yet validated. In a Flutter 3.47.2-enabled environment, format changed Dart files; run `connection_scan_state_test.dart`, `connection_scan_coordinator_test.dart`, `floating_monitor_layout_contract_test.dart` and `widget_test.dart`; run `flutter analyze --no-fatal-infos` and the complete `flutter test` suite. Then verify actual Android scanner handoff (passive-to-manual, neutral close, selected-device handoff) and inspect Home/Settings/Connection at 350-dp/420-dp in English/Indonesian and Light/Dark. Build App remains a separate authorization. Only explicit `Eksekusi Build App!` authorizes APK packaging.

## Evidence and safety boundary

Build #129 is the latest published artifact, not proof of installation on the field unit. Firmware V7.1 compile/Online OTA remains USER-REPORTED; BIN identity and physical behavior remain UNVERIFIED. No Firmware compile, BIN/Firebase operation, OTA, flashing or device operation is authorized by this note.