# HANDOFF-agent-scripts-gmsp-2026-06-23

## Objective

Track A only: audit and repair `AR-S2J2J.R` scripts that consume `gmsp` so they
work with the current `gmsp` version, without deleting or overwriting old
results.

## Scope

Repository root:

```text
/Users/averrik/Cloud/github/projects/AR-S2J2J.R
```

Candidate script surface:

```text
scripts/runGMSP.R
scripts/gmsp/setup.R
scripts/runScenarios.R
scripts/runAudit.R
scripts/runPlots.R
scripts/runSelect.R
scripts/select/buildIndex.R
scripts/select/buildPlots.R
scripts/plotTS.R
scripts/plotPSA.R
scripts/plotIMF.R
scripts/runParse.R
scripts/parse/parsePipeline.R
scripts/parse/buildTS.R
scripts/manifest.json
```

## Out Of Scope

- Do not work on methodology chapters.
- Do not read or edit `AR-SABP0.R/dev/TITO`.
- Do not edit `gmsp` package code.
- Do not delete or overwrite:
  - `data/gmsp/`
  - `data/records/scenarios/`
  - old PLAXIS/export deliverables
- Do not run full `scripts/runGMSP.R` or `scripts/runScenarios.R` without user
  approval.
- Do not recursively scan `~/kashimaDB/gmdb.v2/records`.

## Mandatory Reading

Read in order:

1. `/Users/averrik/Cloud/github/projects/AR-S2J2J.R/scripts/AGENTS.md`
2. `/Users/averrik/Cloud/github/projects/AR-S2J2J.R/scripts/dev/sot/PLAN-gmsp-modernization-2026-06-23.md`
3. `/Users/averrik/Cloud/github/projects/AR-S2J2J.R/scripts/dev/sot/AUDIT-gmsp-consumers-2026-06-23.md`
4. `/Users/averrik/Cloud/github/garage/harness/HARNESS.md`
5. `/Users/averrik/Cloud/github/garage/style/AGENTS.md`
6. `/Users/averrik/Cloud/github/garage/style/R.md`
7. `/Users/averrik/Cloud/github/garage/style/R-data.table.md`
8. `/Users/averrik/Cloud/github/libraries/gmsp/dev/SoT/ACTIVE.md`
9. `/Users/averrik/Cloud/github/libraries/gmsp/dev/plan/database/active.md`
10. `/Users/averrik/Cloud/github/libraries/gmsp/examples/scripts/README.md`

## Current Known Findings

- The local R environment resolved `gmsp` as `0.4.7` during the first audit.
  Any compatibility claim with current `gmsp` requires an explicit current
  `gmsp` test environment.
- `runSelect.R` in this repo is a scenario/PLAXIS selector. It should not be
  rewritten as `gmsp::selectRecords()`.
- The likely repair risk is the producer path:
  `.buildTS()` / `.filterTS()` / `.scaleAT()`.
- `.buildTS()` reads `RawRecordTable.ISEE.csv` and recursively lists
  `records/ISEE`; this needs a bounded harness or prototype before any repair.
- `.scaleAT()` uses private `gmsp:::.getSF()`. Audit whether a public equivalent
  exists before changing it.

## Readiness Gate

Before editing any code or running a harness, write a short readiness section in
the active SoT answering these points:

1. Which scripts are producers, which are consumers, and which are
   project-specific selectors.
2. What each candidate script reads and writes.
3. Which `gmsp` helper/API each script calls.
4. Which calls are current public `gmsp` API and which are private or legacy.
5. Why `AR-S2J2J.R/scripts/runSelect.R` must remain a scenario/PLAXIS selector
   and must not be replaced by `gmsp::selectRecords()`.
6. How the current `gmsp` database contract works:
   - `runSelect(processID = "raw")` may feed `runProcess`;
   - `runProcess` publishes a `ProcessID`;
   - `runPlot`, `runExport`, and `runMatch` consume processed selections or
     produced packages.
7. Where outputs will be written during the test and how the agent proves old
   results were not overwritten.

If any point is uncertain, stop and ask before editing.

## Harness Rules

- Before editing any script, update this handoff or create a new SoT file naming
  the exact files in scope.
- Use Ship-of-Theseus:
  - Stage A: current behavior captured without changing production code.
  - Stage B: prototype or temp harness.
  - Stage C: swap minimal changes into production only after equivalence or
    accepted changed behavior is documented.
- Parse checks are not enough. For any behavior change, create a small harness.
- All smoke outputs go to `/private/tmp` unless the user approves a repo
  candidate folder.
- Never test by overwriting accepted `data/gmsp` or `data/records/scenarios`.

## Proposed First Harness

Consumer smoke only, no producers:

1. Create temp JSON under `/private/tmp` for `scripts/runSelect.R`.
2. Use one available scenario slice and `Samples.N = 1`.
3. Set `PATH.out` to `/private/tmp/AR-S2J2J-plaxis-smoke-20260623`.
4. Run:

```text
Rscript scripts/runSelect.R /private/tmp/<config>.json
Rscript scripts/select/buildIndex.R /private/tmp/AR-S2J2J-plaxis-smoke-20260623
Rscript scripts/select/buildPlots.R /private/tmp/AR-S2J2J-plaxis-smoke-20260623 TRUE
```

5. Validate outputs exist and no project result folder changed.

Before this harness is run, create a compatibility matrix with columns:

```text
script | role | input | output | gmsp API | risk | proposed harness
```

## Rejected

- Broad scans of data folders.
- Replacing scenario selection with gmdb selection.
- Adding JSON knobs for worker counts.
- Copying methodology/TITO content into this repo.

## Exact Next Command

Read mandatory docs, then create or update a SoT file for the first harness
before running any script.
