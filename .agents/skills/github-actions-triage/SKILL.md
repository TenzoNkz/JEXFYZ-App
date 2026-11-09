---
name: github-actions-triage
description: Use to diagnose GitHub Actions runner, workflow, job, step, cancellation, permissions, concurrency, artifact, or security failures without blind retries or release-guard bypasses.
---

# GitHub Actions Triage and Workflow Security

## Objective
Find the actual failing layer and preserve guarded release semantics.

## Diagnostic sequence
1. Fetch live workflow run list, intended run metadata, event, source SHA, run_attempt and current status.
2. Fetch jobs and steps for the latest attempt. Retrieve complete logs for failed or ambiguous jobs; do not diagnose from run conclusion alone.
3. Classify failure: trigger/guard, queue/runner allocation, checkout/ref, permission/token, dependency/network, analysis/test, Android build/sign, artifact upload/download, Release/tag, concurrency/cancel or post-job cleanup.
4. Separate runner startup from code failure. A runner_id of zero/no runner logs is not a source failure; a completed failed test step is.
5. Check concurrency groups and existing queued/in-progress runs before any retry. Never trigger a duplicate while status is contradictory.
6. Compare the run's source SHA and workflow blob with current main; identify whether the run tested the intended source.
7. Propose the narrowest root-cause repair. Preserve all security, analyzer, test, signing and artifact gates.
8. For workflow security review, inspect least-privilege GITHUB_TOKEN permissions, action pinning to verified full commit SHAs, untrusted PR input handling, secrets exposure, artifact provenance, cache trust and deployment environment boundaries.
9. Verify fix with the relevant non-release checks first where available. An App release trigger remains guarded and needs explicit Eksekusi Build App!.

## Reporting
Provide a timeline with run/job/step IDs, source SHA, timestamps, exact log evidence, failure class, proposed fix, retry safety and remaining uncertainty.

## Guardrails
A retry is justified only by a concrete repair or evidence-backed transient infrastructure cause. Never weaken guards, use push/PR bypasses, expose secrets or report success from an ambiguous API state.
