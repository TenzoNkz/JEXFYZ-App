---
name: repository-forensics
description: Use for repository boot, source-of-truth recovery, codebase mapping, commit/diff analysis, reference tracing, stale documentation detection, or any task where the live repository state must be established before decisions.
---

# Repository Forensics

## Objective
Establish an evidence-backed understanding of the live repository before proposing or making changes.

## Procedure
1. Confirm repository, branch and requested scope. Fetch live branch HEAD, commit metadata and a complete recursive tree; record whether the tree is truncated.
2. Load the rolling checkpoint and Master Prompt first, then the relevant subject references. Check live files rather than trusting hashes or copied snippets in notes.
3. Map the smallest relevant dependency surface: callers, state owners, protocol parsers, configuration, tests, workflow consumers and documentation links. Search for every use of changed identifiers and paths.
4. Compare the current file with its parent commit or a known baseline when regression history matters. Distinguish ancestor history from current source and current release.
5. Build a claim/evidence table: claim, source path/line or commit, evidence class, confidence, unresolved assumptions.
6. For repository cleanup, enumerate every Markdown file, classify active reference / pointer / checkpoint / ledger / immutable archive, then validate links and path-based references before any move or deletion.
7. Before writing, re-fetch the target file and confirm main has not changed unexpectedly. After writing, re-fetch file, commit metadata, HEAD and recursive tree.

## Required outputs
- Exact current HEAD and the evidence boundary.
- Relevant file/dependency map.
- Confirmed findings versus assumptions.
- Regression surface and tests affected.
- Safest next action.

## Guardrails
- Live main and current source outrank stale prose, but owner decisions remain authoritative for intent and permission.
- Never call a test passed because it exists. Never call source implemented evidence of runtime behavior.
- Do not invent file contents, line numbers, hashes, run states or links.
- Do not delete history just to reduce repository size.
- Respect the selected command mode; Diskusi is read-only except canonical documentation updates at substantive conclusions.
