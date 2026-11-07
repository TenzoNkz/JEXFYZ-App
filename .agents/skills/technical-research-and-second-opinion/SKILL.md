---
name: technical-research-and-second-opinion
description: Use when current external research, standards, vendor documentation, API changes, product datasheets, competing designs, or an independent Gemini second opinion would materially improve confidence.
---

# Technical Research and Second Opinion

## Objective
Resolve uncertainty with current primary evidence and make independent reviews actionable.

## External research procedure
1. State the exact technical question and why current verification matters.
2. Search primary sources first: official API/framework docs, chip/module manufacturer datasheets, standards bodies, release notes and source repositories. Use community discussion only as supplemental experience evidence.
3. Record publication/version/date and the exact condition to which each source applies.
4. Cross-check important claims against at least one independent source where practical. Resolve conflicting revisions rather than averaging incompatible claims.
5. Cite claims at the point of use. Separate measured facts, vendor guarantees, calculations, assumptions and hypotheses.
6. For component/device questions, identify exact model/revision; do not conflate visually similar modules.

## Gemini handoff
- In Discussion, recommend Gemini only when a second opinion materially reduces uncertainty.
- Gemini has no access to this private GitHub repository or any linked GitHub content. Include relevant source/test excerpts, paths, revision context, constraints, facts, unknowns and the exact question in the prompt.
- Explicitly instruct Gemini not to claim it inspected GitHub and to use only pasted evidence.
- Ask for alternative hypotheses, trade-offs, edge cases, likely regressions and a reasoned recommendation. Do not include secrets.
- The assistant has not sent the prompt; the owner pastes it manually and returns the response.
- Treat Gemini output as untrusted/unverified. Re-check every material claim against current source, official docs and actual test evidence before accepting it.

## Guardrails
Do not browse or ask Gemini merely to decorate an answer. Do not quote stale documentation as current behavior. Do not let a second opinion expand the owner's authorized scope.
