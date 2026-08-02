# AUDIT-gmsp-consumers-2026-06-23

## Objective

Identify where `AR-S2J2J.R` consumes `gmsp` or `gmdb.v2`, classify which
pipelines are obsolete or risky under current `gmsp`, and define a
non-destructive modernization path.

## Scope

Static audit only. No generated products were deleted, overwritten, or
regenerated.

Files read:

- `README.md`
- `scripts/README.md`
- `scripts/AGENTS.md`
- `scripts/manifest.json`
- `scripts/runGMSP.R`
- `scripts/gmsp/setup.R`
- `scripts/runScenarios.R`
- `scripts/runAudit.R`
- `scripts/runPlots.R`
- `scripts/runSelect.R`
- `scripts/select/buildIndex.R`
- `scripts/select/buildPlots.R`
- `scripts/plotTS.R`
- `scripts/plotPSA.R`
- `scripts/plotIMF.R`
- `scripts/runParse.R`
- `scripts/parse/parsePipeline.R`
- `scripts/parse/buildTS.R`

## Environment Finding

The current R environment resolves `gmsp` as version `0.4.7`.

Exported APIs visible in that environment include:

```text
readTS
selectRecords
TSW2TSL
PSW2PSL
TSL2PS
TSL2IM
AT2TS
VT2TS
TS2IMF
```

Missing from the installed environment:

```text
getRecord
getRecords
runProcess
```

This repo cannot be considered tested against the current `gmsp` 0.5.x surface
until a temporary library or explicit local install is used for harnesses.

## Pipeline Classification

### Raw/gmdb producer

`scripts/runParse.R` and `scripts/parse/*.R` are project-specific parsers for
the blasting database and domain tables. They read
`~/kashimaDB/gmdb.v2/records/ISEE` through `scripts/manifest.json`.

Current risk:

- `scripts/parse/buildTS.R` uses recursive `list.files(..., recursive = TRUE)`
  under `records/ISEE` looking for `raw.owner/record.json`.
- It is not a `gmsp` processing pipeline, but it still depends on the old ISEE
  raw-owner metadata shape.

### Processed-signal producer

`scripts/runGMSP.R` sources `scripts/gmsp/setup.R` and runs:

```text
.buildTS() -> .filterTS() -> .suggestFmax()
```

`scripts/gmsp/setup.R::.buildTS()`:

- reads `~/kashimaDB/gmdb.v2/index/RawRecordTable.ISEE.csv`;
- selects `RecordID`, `OwnerID`, `EventID`, `StationID`;
- calls `readTS(.x = SEL, path = .PATH.RECORDS, kind = "VT")`;
- calls `VT2TS()`, `TSL2TSW()`, `TSL2IM()`, and `TSL2PS()`;
- writes local source caches under `data/gmsp/<InputID>/`.

Current risks:

- It is coupled to `RawRecordTable.ISEE.csv`, not the current `RawMasterIndex`
  / process-table vocabulary used in `gmsp` 0.5.x.
- It recursively lists `records/ISEE` again to build `META.csv`.
- It writes project-local caches, not durable `gmdb.v2` `ProcessID` products.
- It has no small-record subset hook, so a safe producer harness cannot run it
  without either a prototype or a temp database fixture.

`scripts/gmsp/setup.R::.filterTS()`:

- consumes `data/gmsp/<InputID>/TSL.csv`;
- calls `TS2IMF()`, removes IMF components, reconstructs AT, then calls
  `AT2TS()`, `TSL2TSW()`, `TSL2IM()`, and `TSL2PS()`;
- writes `TSL.csv`, `TSW.csv`, `IMW.csv`, `IMF.csv`, `IMF_metrics.csv`,
  `META.csv`, `PSL.csv`, and JSON under `data/gmsp/<OutputID>/`.

Current risks:

- The method is still named `eemd`; the new methodology request mentions VMD.
  The implementation and methodology chapters must not conflate EEMD and VMD.
- IMF outputs are project-local source-cache products, not current database
  `ProcessID` products.

### Scenario producer

`scripts/runScenarios.R` calls `.scaleAT()`.

`.scaleAT()`:

- consumes `data/gmsp/<InputID>/TSL.csv` and JSON;
- consumes `data/export/predictions.csv` and `data/domains/units.json`;
- uses `gmsp:::.getSF()` for unit conversion;
- scales L/T/V acceleration to predicted PPA;
- rotates horizontal components to H1/H2 and UP;
- calls `TSL2TSW()`, `TSL2PS(..., output = "PSW", D50 = ..., D100 = ...)`,
  and `TSL2IM()`;
- writes WIDE scenario products under `data/records/scenarios/<ScenarioID>/`.

Current risks:

- It calls private `gmsp:::.getSF()`. Private APIs can break without notice.
- It is intentionally project-specific and should not be forced into generic
  `gmsp::runProcess()`.
- It writes official scenario products; harnesses must use temp output or
  approved candidate roots, not overwrite existing scenarios.

### Scenario selector/exporter

`scripts/runSelect.R`, `scripts/select/buildIndex.R`, and
`scripts/select/buildPlots.R` are PLAXIS/scenario selection tools.

They do not select from `gmdb.v2` and should not be merged with
`gmsp::selectRecords()`. Their input is already materialized scenario folders.

Current risk:

- `scripts/select/buildPlots.R` reads scenario `PSW.csv` for selected records,
  so it depends on scenario table schema staying compatible.

### Plot/audit consumers

`scripts/runAudit.R` reads `data/gmsp/<InputID>` and scenarios. It uses
`gmsp::TSW2TSL()` and private `gmsp:::.getSF()`.

`scripts/runPlots.R` reads scenarios and uses `gmsp::PSW2PSL()` only to infer
available OCIDs from `PSW.csv`.

`scripts/plotTS.R`, `scripts/plotPSA.R`, and `scripts/plotIMF.R` are
interactive diagnostic scripts. They use `TSW2TSL()`, `TSL2PS()`, and `AT2TS()`
over existing `data/gmsp` products.

Current risks:

- README text says some scenario plotting does not require `gmsp`, but
  `scripts/runPlots.R` explicitly checks for `gmsp::PSW2PSL()`.
- Diagnostic scripts use editable constants at top level and write HTML inside
  `data/gmsp/<InputID>/`; they should remain manual diagnostics, not batch
  modernization harnesses.

## Validation Already Run

Static checks only:

```text
parse OK for selected scripts
json OK 14 files
git status: main...origin/main plus this SoT/audit work
```

No data-generation pipeline was run.

## Modernization Plan

### Stage A — No-Code Compatibility Audit

1. Use a temporary R library with current local `gmsp` 0.5.x.
2. Re-run parse and JSON checks under that environment.
3. Check that table-conversion calls still exist:
   - `TSW2TSL`
   - `TSL2TSW`
   - `PSW2PSL`
   - `TSL2PS`
   - `TSL2IM`
   - `AT2TS`
   - `VT2TS`
   - `TS2IMF`
4. Do not run producers.

### Stage B — Consumer Smoke Without Overwrite

Use existing scenario products read-only and write only to `/private/tmp`:

1. Create a temp `runSelect` JSON with:
   - one known Fmax/P/D/MIC slice;
   - `Samples.N = 1`;
   - `PATH.out = /private/tmp/AR-S2J2J-plaxis-smoke-<date>`;
   - `OVERRIDE = TRUE`.
2. Run:
   - `Rscript scripts/runSelect.R <temp-json>`;
   - `Rscript scripts/select/buildIndex.R <temp-out>`;
   - `Rscript scripts/select/buildPlots.R <temp-out> TRUE`.
3. Validate:
   - selected CSV exists;
   - `IMW.csv` exists;
   - `unique.csv` exists;
   - TS/PSA HTML exists;
   - no writes occurred under `data/gmsp/` or `data/records/scenarios/`.

### Stage C — Producer Prototype

Blocked until a small-input strategy is chosen.

Options:

1. Add a SoT-only prototype wrapper that lets `.buildTS()` receive an explicit
   small `RecordID`/key table and a temp output root.
2. Build a minimal temp database fixture under `/private/tmp` and run the
   current `.buildTS()` against it.
3. Replace local `.buildTS()` with current `gmsp` database helpers only if the
   ISEE raw velocity contract maps cleanly to current `gmsp` `getRecords()` /
   `runProcess()` behavior.

Rejected for now:

- running `scripts/runGMSP.R` directly;
- writing a new `data/gmsp` folder before the producer smoke exists;
- rewriting `runSelect.R` to use `gmsp::selectRecords()`.

### Stage D — Candidate Full Regeneration

Only after Stages A-C pass and the user approves:

1. Generate candidate products in a new explicit root or external temp location.
2. Compare schemas, row counts, key sets, and selected intensity columns against
   accepted old products.
3. Keep old results untouched until comparison is approved.

## Decisions Needed From User

1. Whether the modernized source signal producer should remain a project-local
   cache builder under `data/gmsp/`, or become a `gmdb.v2` `ProcessID`.
2. Whether the final candidate products should live under a new repo folder
   name or only be staged externally first.
3. Correct TITO/VMD source is external:
   `/Users/averrik/Cloud/github/projects/AR-SABP0.R/dev/TITO`.
   Do not search for alternatives and do not store/copy it in this repo.

## Exact Next Command

When the methodology chapter work is opened, read the exact user-identified
TITO source under `/Users/averrik/Cloud/github/projects/AR-SABP0.R/dev/TITO`;
do not create new gmsp documentation folders.
