# AGENTS.md — Scripts agent guide (AR-S2J2J)

## What this pipeline does

Guides agents through the user-facing script workflows: reviewing existing
scenarios, selecting records for PLAXIS, rebuilding PLAXIS indexes and plots,
and generating scenarios only when explicitly requested.

Primary user tasks supported here:

- Generate scenario HTML plots from existing scenarios.
- Select and export scenario records for PLAXIS.
- Rebuild PLAXIS folder indexes and review plots after selection.
- Prepare small matched-record folders such as `mesh.test/` when explicitly
  requested.
- Generate or refresh scenarios only when the user explicitly asks for it.

---

## CRITICAL — what the agent must NOT do

- For routine user runs, **do not edit any `.R` file**. Edit only JSON config
  files and run the documented scripts.
- Only edit `.R` files when the user explicitly asks for code repair or a new
  runner, after stating the plan and validating the change with a real command.
- Do not modify `PATH.scenarios` — it is the read-only source database.
- Do not run `runGMSP.R` or `runScenarios.R` without explicit user authorization.
- Do not delete or overwrite files under `data/records/scenarios/` or `data/gmsp/`.
- Do not change package/library code to make a user run work. CRAN dependencies
  are handled by the shared loader; if a non-CRAN/development dependency such as
  `gmsp` or `ssel` is missing, report it and stop.

---

## Ambiguity policy — ask before running

The JSON examples below are templates, not permission to run the broadest
possible job. If the user does not specify enough information, ask a short
clarifying question before editing JSON or launching R.

For PLAXIS selection, do not assume missing values for:

- `Fmax`
- `P`
- `D.range`
- `MIC.range`
- `DIR`
- `ID`
- `Samples.N`
- `Sample.method`
- `Rank.by` and `Rank.dir` when using ranked selection
- `PATH.out`
- `OVERRIDE`

Never widen scope silently. For example, if the user says `H1`, export only
`H1`; do not add `H2` or `UP`. If the user says `F80`, use only `F80`; do not
add `F125`. If a user asks whether something works, run a minimal validation
with a temporary `PATH.out` outside the project tree unless they explicitly ask
to write production PLAXIS outputs.

Before running `runSelect.R`, verify that every `Rank.by` column exists in the
matching scenario `IMW.csv` files. If any requested column is missing, stop and
report which scenarios are affected.

---

## Script structure

```
scripts/
  setup.R (deleted — no longer used)
  tools/setup.R       — lightweight helpers; legacy table wrappers delegate to gmsp
  gmsp/setup.R        — gmsp-heavy: buildTS, filterTS, suggestFmax, scaleAT
  runSelect.R         — sources tools/setup.R only, reads runSelect.json
  select/buildIndex.R — sources tools/setup.R only, rebuilds PLAXIS IMW/unique
  select/buildPlots.R — sources tools/setup.R only, builds PLAXIS review plots
  runAudit.R          — sources tools/setup.R only, reads runAudit.json, requires gmsp namespace
  runPlots.R          — sources tools/setup.R only, reads runPlots.json
  runScenarios.R      — sources gmsp/setup.R, reads runScenarios.json
```

Selection scripts (`runSelect.R`,
`select/buildIndex.R`, `select/buildPlots.R`) do **not** require gmsp or its
dependencies. They only need: `data.table`, `here`, `jsonlite`, `NGR`,
`htmlwidgets`. `runPlots.R`, `plotPSA.R`, `plotTS.R`, `plotIMF.R`, and
`runAudit.R` require `gmsp` because table shape decoding is delegated to
`gmsp::TSW2TSL()` / `gmsp::PSW2PSL()`.

---

## Prerequisites

### 1. Verify R is installed
```
Rscript --version
```
Requires R >= 4.1.

### 2. Verify required packages for selection, postprocess, and plots
```
Rscript -e "stopifnot(requireNamespace('data.table'), requireNamespace('here'), requireNamespace('jsonlite'), requireNamespace('NGR'), requireNamespace('htmlwidgets'))"
```
`gmsp` is NOT required for `runSelect.R`, `select/buildIndex.R`, or
`select/buildPlots.R`. It is required for GMSP generation, audit, and plot
scripts that decode `TSW` / `PSW` tables.

### 3. Run from the project root
```
cd /path/to/AR-S2J2J
```

---

## Agent workflow for users

### A. Review source scenario plots, if needed

Allowed file to edit: `scripts/runPlots.json`.

```json
{
  "Fmax"    : [125, 80],
  "P"       : 0.90,
  "DIR"     : ["D50", "H1", "H2", "UP"],
  "OVERRIDE": false
}
```

Run:

```
Rscript scripts/runPlots.R
```

This reads `data/records/scenarios/` and writes HTML plots inside each source
scenario folder. It must not alter the scenario CSV/JSON products. These are
not PLAXIS selection plots. The distributed scenario outputs are F80 and F125;
do not assume F50 scenarios exist just because `data/gmsp/F50.*` source caches
exist.

### B. Export selected records for PLAXIS

#### Step 1 — Edit `scripts/runSelect.json`

The agent edits **only this JSON file**. Do NOT edit `runSelect.R`.

```json
{
  "PATH.out"     : "data/records/plaxis",
  "Fmax"         : [80, 125],
  "P"            : 0.90,
  "D.range"      : [150, 400],
  "MIC.range"    : [150, 400],
  "DIR"          : ["H1"],
  "ID"           : ["AT"],
  "Samples.N"    : 25,
  "Sample.method": "rank",
  "Rank.by"      : ["AI"],
  "Rank.dir"     : "desc",
  "OVERRIDE"     : false
}
```

| Field | Description |
|---|---|
| `Fmax` | Source Fmax values — must match available scenarios |
| `P` | Exceedance probability: 0.5, 0.90, or 0.95 |
| `D.range` | Scenario distance limits [m], inclusive |
| `MIC.range` | Scenario MIC limits [kg], inclusive |
| `DIR` | Components: `"H1"`, `"H2"`, `"UP"` |
| `ID` | Signal types: `"AT"` (mm/s²), `"VT"` (mm/s), `"DT"` (mm) |
| `Samples.N` | Records to select per scenario |
| `Sample.method` | `"rank"` \| `"random"` |
| `Rank.by` | IMW columns for multi-column sort. Use `["AI"]` for maximum Arias intensity, `["CAV5"]` for maximum CAV5, or another `IMW.csv` column. Ignored when `"random"` |
| `Rank.dir` | `"desc"` = highest N \| `"asc"` = lowest N. Ignored when `"random"` |
| `OVERRIDE` | `true` clears output folder before writing. Use `false` when accumulating multiple criteria in the same folder. |

Check available scenarios:
```
ls data/records/scenarios/
```

#### Step 2 — Run
```
Rscript scripts/runSelect.R
```
Custom config:
```
Rscript scripts/runSelect.R path/to/custom.json
```

`PATH.out` is a single flat delivery folder generated by `runSelect.R`. Do not
create, rename, or reorganize PLAXIS files manually. Do not edit `runSelect.R`;
change only `runSelect.json` and run the script.

Record CSV filenames written by the script have this form:

```
<RecordID>.AT.H1.F80.D150.Q150.p90.csv
```

The selector writes record CSV files and copies the JSON config. It does not
generate HTML plots.

#### Step 3 — Rebuild PLAXIS indexes

Run this after all requested selection criteria have been written to the same
`PATH.out`:

```
Rscript scripts/select/buildIndex.R data/records/plaxis
```

The postprocess scans the whole flat folder and rebuilds root-level `IMW.csv`
and `unique.csv`.

#### Step 4 — Build PLAXIS review plots

Run this only after all selections for the folder are complete and after
`scripts/select/buildIndex.R` has rebuilt the folder indexes:

```
Rscript scripts/select/buildPlots.R data/records/plaxis TRUE
```

This scans the final flat folder and writes:

```
<ScenarioID>.TS-<ID>-<DIR>.html
<ScenarioID>.PSA-<DIR>.html
```

Do not use `runPlots.R` for PLAXIS folders. `runPlots.R` is only for source
scenario folders under `data/records/scenarios/`.

### C. Generate or refresh scenarios

Only do this if the user explicitly asks for scenario generation. It requires
`gmsp` and existing `data/export/predictions.csv`. Do not edit `.R` files to
change scenario grids or probability levels; edit only `runScenarios.json`.

Allowed file to edit: `scripts/runScenarios.json`.

```json
{
  "InputID" : ["F80.Qo.Do.eemd", "F125.Qo.Do.eemd"],
  "D.grid"  : [150, 200, 250, 300, 350, 400],
  "MIC.grid": [150, 200, 250, 300, 350, 400],
  "P"       : 0.90,
  "D50"     : true,
  "nTheta"  : 180,
  "PARALLEL": false,
  "OVERRIDE": false
}
```

Run:

```
Rscript scripts/runScenarios.R
```

---

## Other JSON-driven pipelines (DO NOT RUN without authorization)

| Script | Config | Controls |
|---|---|---|
| `runScenarios.R` | `runScenarios.json` | InputID list, D.grid, MIC.grid, P, D50, nTheta, PARALLEL, OVERRIDE |
| `runPlots.R` | `runPlots.json` | Fmax, P, DIR, OVERRIDE |
| `runAudit.R` | `runAudit.json` | InputID, tol |

---

## Outputs (`data/records/plaxis/`)

```
{RecordID}.{ID}.{DIR}.{ScenarioID}.csv  — time series per record × ID × DIR × scenario
<config>.json                           — copied selection config
IMW.csv                                 — rebuilt by select/buildIndex.R
unique.csv                              — rebuilt by select/buildIndex.R
{ScenarioID}.TS-{ID}-{DIR}.html         — rebuilt by select/buildPlots.R
{ScenarioID}.PSA-{DIR}.html             — rebuilt by select/buildPlots.R
```

**Total record files** = Samples.N × (matching scenarios) × len(DIR) × len(ID).
That formula applies to one fresh selection run. If multiple criteria are
accumulated in the same flat folder with `OVERRIDE = false`, repeated filenames
are overwritten and the final file count is whatever remains in the folder.

---

## Postprocessed IMW (`IMW.csv` at folder root)

Columns: `ScenarioID, Fmax, D, MIC, P, RecordID, OCID, D.real, Q.real` +
all intensity measures (PGA [mm/s²], PGV [mm/s], PGD [mm], AI, CAV, CAV5, ...).

Run `scripts/select/buildIndex.R` after all selections for the folder have
finished. It rebuilds `IMW.csv` and `unique.csv` from all matching
`{RecordID}.{ID}.{DIR}.{ScenarioID}.csv` files in the flat folder.

---

## Units contract (2026-05-23)

The pipeline now carries **explicit per-row unit declarations** end-to-end
so the ML predictions ↔ time-series boundary cannot drift silently.

### Source of truth — `data/blastDB.csv`

The user is responsible for declaring units **per row** in two columns:

| Column | Allowed values | Notes |
|---|---|---|
| `ppv.Units` | `mm/s` | Every active blast source. Verified empirically (magnitudes [0.01, 231]). |
| `ppa.Units` | `g`, `gal`, `m/s2`, `mm/s2`, `cm/s2`, or `NA` | Confirmed `g` for CAV/IMPALA/S11D via implied dominant frequency check; `NA` for PMC sources whose `ppa*` columns are themselves `NA`. |

When `exportDB.R` writes new rows for the local site (`manifest.parse.blastDB.siteID`),
it pulls units from `manifest.parse.blastDB.units = { ppv, ppa }` and writes them
into the new columns. **Fails loud** if the manifest declaration is missing.

### Propagation — `data/domains/units.json`

`scripts/data/buildDomains.R` asserts unit homogeneity across the enabled-sources
× in-range subset of `blastDB.csv` *before* assembling `Y/Q/D/S.csv` (which
remain unit-agnostic — the ML pipeline never sees the `*.Units` columns). If
homogeneous, the resolved units are written to a propagation sidecar:

```json
{ "ppv": "mm/s",
  "ppa": "g",
  "sources": [...],
  "n.train": 222,
  "dateUTC": "..." }
```

### Consumers — `.scaleAT()` and `runAudit.R`

Both read `data/domains/units.json` and call `gmsp:::.getSF(SourceUnits=UNITS$ppa,
TargetUnits=TargetUnits)` to get the conversion factor at the cross-domain
boundary. Neither hardcodes `G = 9806.65` any more. The old workaround
`scripts/units.json` was deleted in commit `09f3530`.

### Failure mode

If the manifest is missing units, the next `runParse` fails at `exportDB`.
If `blastDB.csv` has heterogeneous or `NA` units across enabled sources,
`runData` fails at `buildDomains`. If `data/domains/units.json` is missing,
`runScenarios` and `runAudit` fail at startup. **There is no silent
fallback** — every unit-aware boundary is gated by an explicit assertion.

---

## Legacy paths removed (2026-05-23)

* `data/records/raw/` — removed (commit `16ae869`). Nothing in the runtime
  parse pipeline may read from this location or from old client copies under
  `data/raw`. `buildTS.R` now sources records directly from
  `~/kashimaDB/gmdb.v2/records/ISEE/*/*/raw.owner/record.json`. Legacy staging
  through `buildRecords.R` is skipped unless `manifest.parse.dirs.records` is
  explicitly configured for that run.
* Blast design PDFs referenced by `data/domains/blasts.index.csv` are curated
  metadata under `data/metadata/Blast Design/`. Do not point `FullPath` back
  to `data/raw/Blast Design/`.

### Parse pipeline status — canonical removed (2026-05-24)

`runParse.R` is live again, but `canonical_table.csv` is not a runtime input.
The parse source for local blast records is now
`~/kashimaDB/gmdb.v2/records/ISEE/*/*/raw.owner/record.json`.

* `buildTS.R` builds `records.index.csv` from kashimaDB `record.json` files.
* `EventID` is the exact kashimaDB `record.json` value. Do not normalize it to
  the old client/index format `EYYYYMMDDHHMMSS`.
* `mergeClientData.R` only validates/preserves `D` from those records; it does
  not read canonical data and no longer writes `data/audit/compare.csv`.
* Records whose kashimaDB `record.json` lacks `D/Q` remain indexed with
  `D = NA`; `exportDB.R` excludes them from `blastDB.csv`.
* `parse.dirs.records` remains optional. If absent, the legacy staging scripts
  `buildRecords.R`, `parseEvent.R`, and `mergeEvent.R` are skipped rather than
  failing on `NULL`.

Do not re-introduce `parse.dirs.canonical` or a canonical fallback. Hydrate
kashimaDB `record.json` files when additional records should enter `blastDB`.
If any hand-maintained index still stores legacy `EventID` values, rewrite it
against kashimaDB or change that table's join to a stable non-EventID key.

* `scripts/units.json` — removed (commit `09f3530`). Replaced by the
  `data/domains/units.json` propagation sidecar described above.

## RotD removal (2026-05-24)

`runRotD.R` and `runRotD.json` were removed. Do not reintroduce
`AT2RotD()` or `PSR.csv` workflows. If a rotated median horizontal
spectrum is needed, the gmsp-side contract is
`TSL2PS(..., output = "PSW", D50 = TRUE, nTheta = ...)`, where `D50`
is an ordinary derived `OCID`.

---

## Coordination with gmsp library

* `scripts/gmsp/setup.R::.buildTS()` was migrated to call
  `VT2TS(.SD, units.source = "mm", ...)` (canonical base) instead of
  the old verbose `Units = "mm/s"`. Required by the gmsp strict units
  contract, which rejects verbose Units forms. See `gmsp/NEWS.md`
  § "Breaking changes — units contract".
* `scripts/gmsp/setup.R` is tracked in this repository. Check the current
  index and `.gitignore` before attributing a missing script to an exclusion.
