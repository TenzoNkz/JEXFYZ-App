# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-06 (Asia/Jakarta).

## Latest verified state

- The single operating policy is [MASTER_PROMPT.md](MASTER_PROMPT.md). [CHAT_RULES.md](CHAT_RULES.md) is only a compatibility pointer.
- Exactly two LOAD + CONTINUE prompts remain in [CHAT_TRANSFER_PROMPTS.md](CHAT_TRANSFER_PROMPTS.md). Prompt 1 is general engineering; Prompt 2 is guarded Build App/QC only.
- Gemini consultation may be proposed proactively during Discussion when a second opinion materially reduces uncertainty. Gemini has no GitHub access; the owner must paste a fully self-contained prompt and return its answer for repository-backed review.
- Latest independently verified App release remains Build #129 / run `39925045446`, source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`. The compact Settings/Connection pass is on main but not in that release.
- Latest compact UI source/test repair: commit `c37aea44abeb832987e13a1c74701d415e85a737` updates five stale route expectations. Static substring checks pass; Flutter runtime validation has not run.
- Repository workflow/documentation cleanup is documentation-only. No App source, Firmware source, tests, build workflow or release behavior is authorized to change merely by this handover.

## Next safe action

In a Flutter-enabled environment, run formatting, the targeted `floating_monitor_layout_contract_test.dart`, analyzer and the complete Flutter suite for the compact UI pass. Review actual results and then perform physical-device/OEM layout QA when available. Only after validation, and only with a separate explicit `Eksekusi Build App!`, may a new APK be packaged.

## Evidence and safety boundary

Build #129 is the latest published artifact, not proof of installation on the field unit. Firmware V7.1 compile/Online OTA remains USER-REPORTED; BIN identity and physical behavior remain UNVERIFIED. No Firmware compile, BIN/Firebase operation, OTA, flashing or device operation is authorized by this note.