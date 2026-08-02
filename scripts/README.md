# AR-S2J2J Scripts Runbook

This directory contains several related pipelines. They do not all have the
same dependencies, and they are not all runnable by every user. This README is
written so an agent can rerun each stage without inferring contracts from the
code.

Always run commands from the repository root:

```sh
cd /path/to/AR-S2J2J
```

## Dependencies

| Level        | Scripts                                                | Requirements                                                                                                       |
|--------------|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| Local base   | `runData.R`, `runPlots.R`, `runSelect.R`, `scripts/select/buildIndex.R`, `scripts/select/buildPlots.R` | common CRAN packages (`data.table`, `jsonlite`, `here`, `crayon`, `NGR`, `htmlwidgets`) and existing data products |
| Local parse  | `runParse.R`                                           | access to `~/kashimaDB/gmdb.v2/records` and packages loaded by `scripts/parse/setup.R`                             |
| Modeling     | `runModel.R`, `runChain.R`, `runPost.R`                | installed `ssel` library                                                                                           |
| GMSP signals | `runGMSP.R`, `runScenarios.R`, `runAudit.R`, `plot*.R` | installed `gmsp` library and `scripts/gmsp/setup.R`                                                                |

`gmsp` and `ssel` may be in development or pending public availability. A user
without those libraries cannot run those pipeline levels, although they can
inspect existing CSV and HTML products.

## JSON Policy

There are three JSON classes. Do not mix them.

| Class                | Rule                                                                                                             | Examples                                                                                                                                     |
|----------------------|------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| Single-runner config | `scripts/runX.R` reads `scripts/runX.json` by default and accepts an alternate path as the first CLI argument    | `runSelect.R` -> `runSelect.json`; `runPlots.R` -> `runPlots.json`; `runScenarios.R` -> `runScenarios.json`; `runAudit.R` -> `runAudit.json` |
| Shared manifest      | `scripts/manifest.json` does not belong to one runner; it is the common contract for parse/data/model/chain/post | `runParse.R`, `runData.R`, `runModel.R`, `runChain.R`, `runPost.R`                                                                           |
| Product sidecar      | The JSON has the same name as the output folder and describes that product                                       | `data/gmsp/F80.Qo.Do.eemd/F80.Qo.Do.eemd.json`; `data/records/scenarios/F80.D150.Q150.p90/F80.D150.Q150.p90.json`                            |

Do not create opaque alternatives such as `config.json`, `params.json`, or
`manifest2.json`. If a new runner owns its config, use `runNew.R` +
`runNew.json`. If the config belongs to the data/model contract, read
`scripts/manifest.json`.

`scripts/select/buildIndex.R` and `scripts/select/buildPlots.R` are internal
selection steps, not top-level pipelines. They do not own JSON configs; pass
the PLAXIS output folder as the first command-line argument.

## Release Integrity

The development scripts do not contain runtime integrity gates. Agents and
maintainers must be able to edit and rerun pipelines without first updating a
signature file.

For author-certified handoffs, use standard repository/release mechanisms
instead of custom runtime barriers:

- Review and commit the exact scripts and JSON configs used for a run.
- Tag the accepted revision in Git.
- For package libraries (`gmsp`, `ssel`), rely on the normal R package flow:
  `R CMD build`, `R CMD check`, and the source tarball/release artifact.
- If a file-level audit is needed for a release bundle, generate an external
  manifest with base R tools such as `tools::md5sum()`. Do not make runtime
  pipelines depend on that audit file.

## Recommended Order

Full maintainer flow:

```sh
Rscript scripts/runParse.R
Rscript scripts/runData.R
Rscript scripts/runModel.R
Rscript scripts/runPost.R
Rscript scripts/runGMSP.R
Rscript scripts/runScenarios.R
Rscript scripts/runAudit.R
Rscript scripts/runPlots.R
Rscript scripts/runSelect.R
Rscript scripts/select/buildIndex.R data/records/plaxis
Rscript scripts/select/buildPlots.R data/records/plaxis TRUE
```

Not every job needs every step:

- If `data/blastDB.csv` is already curated, `runParse.R` is usually unnecessary.
- If `data/export/predictions.csv` already exists and is accepted, do not
  retrain before `runScenarios.R` unless the model inputs changed.
- If `data/gmsp/<InputID>/` already exists and is accepted, `runGMSP.R` is not
  needed.
- `runPlots.R`, `runSelect.R`, `scripts/select/buildIndex.R`, and
  `scripts/select/buildPlots.R` can run on existing scenarios and PLAXIS
  folders.

## Common User Workflow

For users who only need scenario plots and PLAXIS-ready records, the normal
workflow starts from existing `data/records/scenarios/` products. Only scenario
generation or refresh requires `data/gmsp/`, `data/export/predictions.csv`,
and `gmsp`. Do not edit `.R` files for routine user runs; edit only the JSON
files listed below.

1. Generate or refresh scenarios, only if needed:

```sh
Rscript scripts/runScenarios.R
```

Edit `scripts/runScenarios.json` to choose the source signal folders, for
example `F80.Qo.Do.eemd` or `F125.Qo.Do.eemd`.
This step requires `gmsp`. `D.grid`, `MIC.grid`, and `P` are declared in
`scripts/runScenarios.json`.

2. Review source scenario HTML plots, if needed:

```sh
Rscript scripts/runPlots.R
```

Edit `scripts/runPlots.json` to choose `Fmax`, `P`, and `DIR`. This step reads
existing source scenarios and does not require `gmsp`. These are not PLAXIS
selection plots. The distributed scenario outputs are for F80 and F125; F50 is
a source cache in `data/gmsp/` unless a maintainer has generated additional F50
scenarios.

3. Export selected records for PLAXIS:

```sh
Rscript scripts/runSelect.R
```

Edit `scripts/runSelect.json` to set:

- `PATH.out`: output folder, normally `data/records/plaxis`.
- `Fmax`: one or more available scenario frequencies, normally `[80]`, `[125]`,
  or `[80, 125]`.
- `P`: probability level, normally `0.90`.
- `D.range`: scenario distance limits to export, for example `[150, 300]`.
- `MIC.range`: scenario MIC limits to export, for example `[150, 300]`.
- `DIR`: components to export, usually `["H1", "H2", "UP"]` or a subset.
- `ID`: signal type to export: `AT`, `VT`, and/or `DT`.
- `Samples.N`: number of records per scenario. It must be lower than or equal
  to the available record count for every matching scenario.
- `Sample.method`: `random` or `rank`.
- `Rank.by`: ranking column when `Sample.method = "rank"`, for example
  `["AI"]` for maximum Arias intensity or `["CAV5"]` for maximum CAV5.
- `Rank.dir`: `desc` for maximum values, `asc` for minimum values.

`runSelect.R` writes a flat PLAXIS delivery folder under `PATH.out`. It does
not create one subfolder per scenario. Record CSV filenames start with
`RecordID` so repeated base records group together visually; the scenario ID is
kept at the end to avoid collisions between scaled versions.

4. Rebuild PLAXIS indexes and plots after all selections are complete:

```sh
Rscript scripts/select/buildIndex.R data/records/plaxis
Rscript scripts/select/buildPlots.R data/records/plaxis TRUE
```

`scripts/select/buildIndex.R` rebuilds `IMW.csv` and `unique.csv` from the
whole flat folder. `scripts/select/buildPlots.R` builds the PLAXIS review HTML
from the same final folder contents. Do not use `runPlots.R` for PLAXIS
folders; `runPlots.R` is only for source scenario folders under
`data/records/scenarios/`.

## Parse Pipeline

Command:

```sh
Rscript scripts/runParse.R
Rscript scripts/runParse.R path/to/manifest.json
```

Config:

- Reads `scripts/manifest.json` by default.
- Uses `manifest$parse`.

Main inputs:

- `manifest$parse$dirs$kashimaDB`, normally `~/kashimaDB/gmdb.v2/records`.
- `data/blastDB.csv`, if it exists and must be updated or preserved.
- Curated metadata under `data/metadata/`.

Main outputs:

- Index tables under `data/domains/`.
- `data/blastDB.csv`, updated by `scripts/parse/exportDB.R`.

Current contract:

- The normal record source is kashimaDB: `ISEE/*/*/raw.owner/record.json`.
- `data/raw/` and `data/records/raw/` are not active runtime inputs.
- `parse.dirs.records` is an optional legacy branch; if configured,
  `parse.dirs.fixed` and `parse.dirs.mobile` must also be configured.

## Data Pipeline

Command:

```sh
Rscript scripts/runData.R
Rscript scripts/runData.R path/to/manifest.json
```

Config:

- Reads `scripts/manifest.json` by default.
- Uses `manifest$dirs`, `manifest$responses`, `manifest$domains`,
  `manifest$datasets`, and `manifest$parse`.

Input:

- `data/blastDB.csv`.

Outputs:

- `data/domains/Y.csv`
- `data/domains/Q.csv`
- `data/domains/D.csv`
- `data/domains/S.csv`
- `data/domains/index.csv`
- `data/domains/units.json`
- `data/datasets/*.csv`

`data/domains/units.json` is the unit sidecar used later by
`runScenarios.R` and `runAudit.R`. Those pipelines must fail if it is missing.

## Model Pipeline

Command:

```sh
Rscript scripts/runModel.R
Rscript scripts/runModel.R path/to/manifest.json
```

Requires `ssel`.

Phases:

1. Runs `scripts/runData.R` to rebuild domains and datasets.
2. Runs `ssel::modelPipeline()`.

Main outputs:

- `data/model/`
- `data/metrics/`
- `data/response/`
- `data/summary/metrics.csv`
- `data/summary/response_long.csv`
- `data/export/Yo.csv`
- `data/export/Y.csv`
- `data/export/Xo.csv`
- `data/export/X.csv`

## Chain Pipeline

Command:

```sh
Rscript scripts/runChain.R
Rscript scripts/runChain.R path/to/manifest.json
```

Requires `ssel`.

Phases:

1. Runs `scripts/runData.R`.
2. Runs `ssel::chainPipeline()`.

Additional outputs:

- `data/iter/convergence.csv`
- `data/iter/Y*.csv`
- `data/iter/Yo*.csv`
- `data/iter/metrics_*.csv`

Current chain parameters are set in `runChain.R`, not in `manifest.json`:
`MAX_ITER`, `TOL`, `PATIENCE`, `SWEEP`, `SUFFIX`, `CHAIN_GATE`,
`CHAIN_THRESH`, `CHAIN_STABLE`, `RESUME`.

## Post Pipeline

Command:

```sh
Rscript scripts/runPost.R
Rscript scripts/runPost.R path/to/manifest.json
```

Requires `ssel`.

Reads `scripts/manifest.json` and runs `ssel::postProcess()`.

Outputs:

- `data/export/predictions.csv`
- `data/export/audit.csv`

`data/export/predictions.csv` is the input used by `runScenarios.R` to scale
signals with predicted `ppaL`, `ppaT`, and `ppaV`.

## GMSP Source Pipeline

Command:

```sh
Rscript scripts/runGMSP.R
```

Requires `gmsp`, kashimaDB, and `scripts/gmsp/setup.R`.

`runGMSP.R` generates source caches in `data/gmsp/` for F125, F80, and F50.
It runs:

- `.buildTS()` to build `F*.Qo.Do`.
- `.filterTS()` to build `F*.Qo.Do.eemd`.
- `.suggestFmax()` after filtering, as a diagnostic only. It reads
  `IMF_metrics.csv` and reports retained-IMF upper-frequency quantiles; it does
  not change `Fmax`, sampling, or scenario products.

Expected products in each `data/gmsp/<InputID>/` folder:

```text
TSL.csv
TSW.csv
IMW.csv
META.csv
PSL.csv
<InputID>.json
```

In `data/gmsp/`, LONG files (`TSL.csv`, `PSL.csv`) are valid source-cache
products. The scenario WIDE-only contract does not apply there.

## Scenarios Pipeline

Command:

```sh
Rscript scripts/runScenarios.R
Rscript scripts/runScenarios.R path/to/runScenarios.json
```

Config:

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

Requires `gmsp`.

Inputs:

- `data/gmsp/<InputID>/TSL.csv`
- `data/gmsp/<InputID>/<InputID>.json`
- `data/export/predictions.csv`
- `data/domains/units.json`

Current runner behavior:

- `D.grid` defines the scenario distances [m].
- `MIC.grid` defines the scenario charges [kg].
- `P` defines the probability level. `0.90` writes `p90` scenario folders.
- `PARALLEL` can be `true` on machines where R parallel workers are available;
  use `false` on restricted desktops or sandboxes.
- `runScenarios.R` writes only scenario CSV/JSON products. HTML plots are a
  separate responsibility of `runPlots.R`.
- After all `.scaleAT()` calls finish, `runScenarios.R` rebuilds
  `data/records/scenarios/IMW.csv` once from all complete scenario folders.
- Do not edit `.R` files to change scenario grids or probability levels.

Outputs per scenario in `data/records/scenarios/<ScenarioID>/`:

```text
TSW.csv
PSW.csv
IMW.csv
<ScenarioID>.json
```

Scenario contract:

- Final scenario products are WIDE: `TSW.csv`, `PSW.csv`, `IMW.csv`, and JSON.
- `runScenarios.R` does not generate HTML. Scenario HTML is generated later by
  `runPlots.R`.
- Do not keep `TSL.csv`, `PSL.csv`, or `META.csv` under
  `data/records/scenarios/`.
- If `D50` is `true`, `PSW.csv` must contain `PSA.D50`, `PSV.D50`, and
  `SD.D50` columns.
- `D50` is a derived `OCID`; product names must not use `RotD50`, `RotD100`,
  or `D100`.

## Audit Pipeline

Command:

```sh
Rscript scripts/runAudit.R
Rscript scripts/runAudit.R path/to/runAudit.json
```

Config:

```json
{
  "InputID": "F125.Qo.Do.eemd",
  "tol"    : 0.001
}
```

Requires `gmsp` because it uses the library unit conversion helper.

Inputs:

- `data/gmsp/<InputID>/TSW.csv`
- `data/gmsp/<InputID>/IMW.csv`
- `data/gmsp/<InputID>/<InputID>.json`
- `data/records/scenarios/*/TSW.csv`
- `data/records/scenarios/*/IMW.csv`
- `data/records/scenarios/*/<ScenarioID>.json`
- `data/domains/units.json`

Outputs:

- `data/audit/<ScenarioID>.csv`
- `data/audit/summary.csv`

## Plots Pipeline

Command:

```sh
Rscript scripts/runPlots.R
Rscript scripts/runPlots.R path/to/runPlots.json
```

Config:

```json
{
  "Fmax"    : [125, 80],
  "P"       : 0.90,
  "DIR"     : ["D50"],
  "OVERRIDE": false
}
```

Does not require `gmsp`. Reads already generated WIDE scenarios. The
distributed scenario outputs are F80 and F125; do not include F50 unless F50
scenarios were generated separately.

Inputs:

- `data/records/scenarios/<ScenarioID>/PSW.csv`
- `data/records/scenarios/<ScenarioID>/TSW.csv`
- `data/records/scenarios/<ScenarioID>/<ScenarioID>.json`

Outputs:

- `PSA-<OCID>.html`
- `TS-<OCID>.html`, except for `D50` because there is no D50 time series.

Y-axis labels must include `OCID`, for example `PSA(D50)` or `AT(H1)`.

## Select Pipeline

Command:

```sh
Rscript scripts/runSelect.R
Rscript scripts/runSelect.R path/to/runSelect.json
Rscript scripts/select/buildIndex.R data/records/plaxis
Rscript scripts/select/buildPlots.R data/records/plaxis TRUE
```

Config:

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

Does not require `gmsp`. Reads already generated WIDE scenarios.

Inputs for `runSelect.R`:

- `data/records/scenarios/<ScenarioID>/TSW.csv`
- `data/records/scenarios/<ScenarioID>/IMW.csv`
- `data/records/scenarios/<ScenarioID>/<ScenarioID>.json`

Additional input for `scripts/select/buildPlots.R`:

- `data/records/scenarios/<ScenarioID>/PSW.csv`

Outputs written by `runSelect.R` in `PATH.out`:

```text
<RecordID>.<ID>.<DIR>.<ScenarioID>.csv
<config>.json
```

`D.range` and `MIC.range` filter scenario folders before record selection.
`Sample.method = "rank"` sorts by `Rank.by` using `Rank.dir`. The first `DIR`
element defines the `OCID` used to select candidates in `IMW.csv`.
The output folder is intentionally flat; do not create scenario subfolders for
PLAXIS exports. `runSelect.R` does not generate HTML plots.

After one or more selections have been written to the same `PATH.out`, run:

```sh
Rscript scripts/select/buildIndex.R data/records/plaxis
```

The postprocess scans the whole flat folder and rebuilds:

```text
IMW.csv
unique.csv
```

After the postprocess, build review plots from the final PLAXIS folder:

```sh
Rscript scripts/select/buildPlots.R data/records/plaxis TRUE
```

`scripts/select/buildPlots.R` scans the selected record CSV files in
`PATH.out`, reads `PSW.csv` from the matching source scenario folders only for
PSA curves, and writes:

```text
<ScenarioID>.TS-<ID>-<DIR>.html
<ScenarioID>.PSA-<DIR>.html
```

Run plots last. If more selections are added to the same folder, rerun
`scripts/select/buildIndex.R` and then `scripts/select/buildPlots.R`.

## Diagnostic Plot Scripts

These scripts are interactive and have editable parameters at the top:

```text
scripts/plotPSA.R
scripts/plotTS.R
scripts/plotIMF.R
```

They require `gmsp` because they compute spectra in memory from `TSW.csv`.

Contract:

- They do not read `TSL.csv` or `PSL.csv`.
- They are not part of the batch pipeline.
- They may generate HTML under `data/gmsp/<InputID>/` as diagnostic artifacts.

## File Contracts

`data/gmsp/`:

- Source signal cache.
- May contain `TSL.csv` and `PSL.csv`.
- Used by `runGMSP.R`, `runScenarios.R`, `runAudit.R`, and diagnostic plot
  scripts.

`data/records/scenarios/`:

- Final scenario product area.
- Runtime contract is WIDE: `TSW.csv`, `PSW.csv`, `IMW.csv`, JSON.
- Plotters and selectors must not depend on `TSL.csv` or `PSL.csv`.

`data/records/plaxis*`:

- Flat PLAXIS delivery folders.
- Record files are named `<RecordID>.<ID>.<DIR>.<ScenarioID>.csv`.
- `runSelect.R` writes record CSV files and copies the config used for that
  run.
- `scripts/select/buildIndex.R` rebuilds folder-level `IMW.csv` and
  `unique.csv`.
- `scripts/select/buildPlots.R` rebuilds folder-level review HTML from final
  selected CSV files. Do not generate PLAXIS HTML inside `runSelect.R`.

`mesh.test/`:

- Ad hoc FEM mesh-comparison folder, not a pipeline source.
- Contains matched PLAXIS CSV files for the same `RecordID`, `ID`, `DIR`, and
  equivalent scenario across F50/F80/F125 so users can compare time-step and
  mesh performance.

`data/export/predictions.csv`:

- Product of `runPost.R`.
- Input to `runScenarios.R`.
- Must contain `D`, `MIC`, `p`, `ppaL`, `ppaT`, `ppaV`.

`data/domains/units.json`:

- Product of `runData.R`.
- Input to `runScenarios.R` and `runAudit.R`.
- Propagates units declared in `data/blastDB.csv`.

## Quick Checks

Validate that scenario helpers and batch plotters do not consume LONG files:

```sh
rg -n 'TSL[.]csv|PSL[.]csv|fread\\(.*TSL|fread\\(.*PSL' \
  scripts/tools/setup.R scripts/runPlots.R scripts/runSelect.R \
  scripts/select/buildIndex.R scripts/select/buildPlots.R
```

The command must return no matches.

Validate that scenarios do not keep LONG products:

```sh
find data/records/scenarios -mindepth 2 -maxdepth 2 \( -name 'TSL.csv' -o -name 'PSL.csv' \)
```

The command must list no files.

Validate that scenarios do not keep gmsp metadata products:

```sh
find data/records/scenarios -mindepth 2 -maxdepth 2 -name 'META.csv'
```

The command must list no files.

Validate syntax of main runners:

```sh
Rscript -e 'files <- c("scripts/runParse.R","scripts/runData.R","scripts/runModel.R","scripts/runChain.R","scripts/runPost.R","scripts/runAudit.R","scripts/runGMSP.R","scripts/runScenarios.R","scripts/runPlots.R","scripts/runSelect.R","scripts/select/buildIndex.R","scripts/select/buildPlots.R"); invisible(lapply(files, parse)); cat("parse OK\n")'
```

This check does not validate installed dependencies; it only confirms that the
scripts can be parsed.
