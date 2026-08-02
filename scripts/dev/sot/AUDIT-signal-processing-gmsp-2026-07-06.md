# AUDIT-signal-processing-gmsp-2026-07-06

## Objective

Audit how `AR-S2J2J.R` processed blasting signals using `gmsp`, comparing the
project runners with the current template contracts under
`/Users/averrik/Cloud/github/libraries/gmsp/examples/scripts`.

## Scope

Documentation/audit only. Files in scope:

```text
scripts/runParse.R
scripts/parse/*.R
scripts/runData.R
scripts/data/*.R
scripts/runGMSP.R
scripts/gmsp/setup.R
scripts/runScenarios.R
scripts/runAudit.R
scripts/runPlots.R
scripts/runSelect.R
scripts/select/buildIndex.R
scripts/select/buildPlots.R
scripts/tools/setup.R
scripts/*.json
/Users/averrik/Cloud/github/libraries/gmsp/examples/scripts/**
```

## Out Of Scope

- No code edits.
- No pipeline execution.
- No generated data reads beyond metadata/header/small bounded summaries if
  needed.
- No recursive scan of `gmdb.v2/records`.
- No spectral-matching methodology for `AR-S2J2J.R`; this project does not use
  `runMatch`.
- No TITO/VMD broad scan.

## Current Plan

1. Read bounded project runner/config source files.
2. Read bounded `gmsp/examples/scripts` runner/config source files relevant to
   selection, GMSP/process, IMF, PSA, plot, and export.
3. Build a stage map: project stage, inputs, `gmsp` calls, outputs, and current
   contract differences.
4. Record an audit verdict suitable for later methodology drafting.

## Live Runs

none

## Status

Started. The worktree is clean except for the already modified methodology SoT
that records the user correction about spectral matching.

## Completed

- Read garage harness/style guidance in the prior step.
- Read `scripts/AGENTS.md`.
- Read `gmsp/examples/scripts/README.md`.
- Confirmed user correction: `AR-S2J2J.R` does not use spectral matching.
- Read bounded project runners/configs:
  `runParse.R`, `parse/*.R`, `runData.R`, `data/*.R`, `runModel.R`,
  `runGMSP.R`, `gmsp/setup.R`, `runScenarios.R`, `runAudit.R`, `runPlots.R`,
  `runSelect.R`, `select/buildIndex.R`, `select/buildPlots.R`,
  `tools/setup.R`, and active JSON configs.
- Read bounded `gmsp/examples/scripts` runners/configs for selection, GMSP,
  process, IMF, PSA, export, and plot.
- Read bounded `gmsp` function sources for `AT2TS`, `VT2TS`, `TS2IMF`,
  `TSL2PS`, table contracts, and `.getSF`.
- Read production-run evidence from
  `STATUS-gmsp-trackA-readiness-2026-06-23.md`.

## Pending

- Use this audit as the source map for methodology drafting.
- Decide whether to write a public method chapter in this repo or only a
  draft/ledger first.

## Rejected

- Rejected treating `gmsp/examples/scripts/match` or `gmsp::runMatch` as part
  of this project's methodology.

## Risks

- `AR-S2J2J.R` has legacy local wrappers around `gmsp`; these may differ from
  the current template runner names.
- Some existing project outputs are generated deliverables and must not be
  read, modified, staged, or deleted as part of this audit.

## Validation

- Source-only audit.
- Use bounded reads and no broad data scans.
- Final audit must distinguish applied project stages from `gmsp` template
  stages that are not used here.
- No pipeline commands were run during this audit.
- No generated data folders were read recursively.

## Audit Verdict

`AR-S2J2J.R` uses `gmsp` as a signal-processing library, not as a direct clone
of the current `gmsp/examples/scripts` pipeline surface.

The project-specific chain is:

```text
kashimaDB record metadata + blast metadata
  -> project parse/domain/model stages
  -> data/export/predictions.csv with ppaL/ppaT/ppaV over D x MIC x p
  -> gmsp-derived signal caches under data/gmsp/
  -> scaled scenario products under data/records/scenarios/
  -> audit, scenario plots, PLAXIS selection/export, PLAXIS review plots
```

The applied `gmsp` functions are table/signal helpers:

```text
readTS(kind = "VT")
VT2TS()
TS2IMF(method = "eemd")
AT2TS(isRaw = FALSE)
TSL2TSW()
TSW2TSL()
TSL2IM()
TSL2PS()
PSW2PSL()
gmsp:::.getSF()
```

`gmsp::runMatch()` and the `examples/scripts/match` surface are not used in
this project and must not appear as AR-S2J2J methodology.

## Stage Map

### 0. Parse And Blast Database Refresh

Files:

```text
scripts/runParse.R
scripts/parse/parsePipeline.R
scripts/parse/buildTS.R
scripts/parse/exportDB.R
scripts/manifest.json
```

Purpose:

- Read kashimaDB `record.json` metadata for local blast records.
- Build `data/domains/records.index.csv` from hydrated record metadata.
- Merge event/blast metadata and update `data/blastDB.csv` for the project
  source.

Important contract:

- `exportDB()` requires per-row source-unit declarations from
  `manifest.parse.blastDB.units`.
- Current project declarations are `ppv = "mm/s"` and `ppa = "g"`.
- This stage is project-specific and is not a `gmsp` runner.

### 1. Domains, Datasets, And Prediction Surface

Files:

```text
scripts/runData.R
scripts/data/buildDomains.R
scripts/data/buildDatasets.R
scripts/runModel.R
scripts/manifest.json
```

Purpose:

- Convert `blastDB.csv` into domain tables `Y/Q/D/S.csv`.
- Include both training rows and synthetic prediction grid rows over charge
  (`MIC`, also written as `Q`) and distance (`D`).
- Build datasets `QS` and `QDS`.
- Train/export response predictions with `ssel::modelPipeline()`.

Important contract:

- `buildDomains()` asserts homogeneous `ppv.Units` and `ppa.Units` across
  the enabled training rows.
- It writes `data/domains/units.json`.
- That sidecar is the source-of-truth unit bridge into later signal scaling.
- The ML stage is unit-agnostic; units become physical again only when
  `.scaleAT()` and `runAudit.R` call `gmsp:::.getSF()`.

### 2. Source Signal Processing Cache

Files:

```text
scripts/runGMSP.R
scripts/gmsp/setup.R
```

Applied project settings:

```text
Fmax/kNyq: 125/3.2, 80/3.125, 50/4.0
InputID:  F<Fmax>.Qo.Do
Method:   eemd
K.imf:    10
Remove:   IMF1 and the last two IMFs
OutputID: F<Fmax>.Qo.Do.eemd
```

Purpose:

1. `.buildTS()` reads velocity records from kashimaDB with
   `gmsp::readTS(kind = "VT")`.
2. It converts velocity histories to canonical acceleration/velocity/
   displacement bundles using `gmsp::VT2TS()`.
3. It materializes:

   ```text
   TSL.csv  canonical long time series
   TSW.csv  wide time series with AT/VT/DT by OCID
   IMW.csv  intensity measures
   META.csv record D/Q/Fs metadata
   PSL.csv  response spectra
   <InputID>.json sidecar
   ```

4. `.filterTS()` decomposes each AT signal by `gmsp::TS2IMF()` using EEMD,
   removes selected modes, reconstructs filtered AT, and rebuilds VT/DT with
   `gmsp::AT2TS(isRaw = FALSE)`.
5. It recomputes `TSW`, `IMW`, `PSL`, and writes `IMF.csv` plus
   `IMF_metrics.csv`.

Methodology implication:

- Do not describe this project as VMD-filtered unless the active config changes.
  The current `runGMSP.R` uses `Method <- "eemd"`.
- VMD may be relevant to shared `gmsp`/TITO methodology, but the AR-S2J2J
  applied method is EEMD filtering.

### 3. Scenario Scaling

Files:

```text
scripts/runScenarios.R
scripts/runScenarios.json
scripts/gmsp/setup.R::.scaleAT()
```

Applied project settings:

```text
InputID: F80.Qo.Do.eemd and F125.Qo.Do.eemd
D.grid: 150, 200, 250, 300, 350, 400
MIC.grid: 150, 200, 250, 300, 350, 400
P: 0.90
D50: true
nTheta: 180
```

Purpose:

- Read filtered source signals from `data/gmsp/<InputID>`.
- Read prediction grid `ppaL`, `ppaT`, and `ppaV` for each `D/MIC/P`.
- Convert predicted PPA units to signal target units with `gmsp:::.getSF()`.
- Compute effective per-record scale factors by dividing target component peak
  acceleration by each record/component PGA.
- Scale longitudinal/transverse/vertical AT histories.
- Rotate scaled L/T histories to H1/H2 using the principal-axis angle from the
  covariance of the scaled horizontal acceleration pair.
- Rename V to UP.
- Write each scenario:

  ```text
  data/records/scenarios/<ScenarioID>/TSW.csv
  data/records/scenarios/<ScenarioID>/PSW.csv
  data/records/scenarios/<ScenarioID>/IMW.csv
  data/records/scenarios/<ScenarioID>/<ScenarioID>.json
  ```

- Response spectra are built with `gmsp::TSL2PS(..., output = "PSW",
  D50 = D50, D100 = D100, nTheta = nTheta)`.
- Technical contract: `TSL2PS()` computes `PSA`, `PSV`, and `SD` for every
  `OCID` present in the scenario `TSL` (`H1`, `H2`, and `UP` after
  scaling/rotation). The same operation can also append derived horizontal
  rotated spectra such as `D50` and `D100`; those derived spectra do not replace
  the per-direction spectra.
- Public-method phrasing: the scenario products include component-wise response
  spectra for the materialized directions (`H1`, `H2`, and `UP`), together with
  the median rotated horizontal spectrum `D50` used for horizontal spectral
  review and selection products in this study.

Methodology implication:

- This is not spectral matching. It is scenario scaling from predicted blast
  peak accelerations followed by component rotation and spectral/product
  materialization.

### 4. Scenario Audit

Files:

```text
scripts/runAudit.R
scripts/runAudit.json
```

Purpose:

- Compare each scaled scenario against its filtered source cache.
- Confirm:
  - vertical PGA matches the expected scaled vertical component (`UP.ok`);
  - horizontal rotation preserves L/T quadratic energy within tolerance
    (`energy.ok`);
  - all scenario component PGAs are positive (`PGA.pos`).

Production-run evidence:

- The full command path completed in June 2026.
- `runAudit.R` exited 0 but reported 30/36 PASS for `F125.Qo.Do.eemd`.
- The six failures were all `energy.ok = FALSE` near the strict
  `tol = 0.001` threshold:

```text
F125.D350.Q200.p90
F125.D350.Q350.p90
F125.D350.Q400.p90
F125.D400.Q150.p90
F125.D400.Q200.p90
F125.D400.Q400.p90
```

Methodology implication:

- The public method may describe the audit checks, but should not present the
  previous production run as a clean full pass.

### 5. Scenario Plots

Files:

```text
scripts/runPlots.R
scripts/runPlots.json
scripts/tools/setup.R::.plotPSA()
scripts/tools/setup.R::.plotTS()
```

Purpose:

- Generate scenario-folder HTML review products from materialized `TSW.csv`
  and `PSW.csv`.
- `runPlots.json` currently targets `F80`, `P = 0.90`, `DIR = D50`.
- For `D50`, time-series plots map back to `TS-H1.html`; spectra use
  `PSA-D50.html`.

Methodology implication:

- These plots are review products, not a signal-processing method.

### 6. Scenario Selection And PLAXIS Export

Files:

```text
scripts/runSelect.R
scripts/runSelect.json
scripts/select/buildIndex.R
scripts/select/buildPlots.R
```

Purpose:

- Read already materialized scenario folders.
- Filter scenarios by `Fmax`, `P`, `D.range`, and `MIC.range`.
- Rank candidate records by scenario `IMW.csv` columns such as `PGV`, `AI`, or
  `CAV5`.
- Export one flat CSV per selected `RecordID x ID x DIR x ScenarioID` for
  PLAXIS-style use.
- Rebuild PLAXIS root indexes:

  ```text
  data/records/plaxis/IMW.csv
  data/records/plaxis/unique.csv
  ```

- Build PLAXIS review plots:

  ```text
  <ScenarioID>.TS-<ID>-<DIR>.html
  <ScenarioID>.PSA-<DIR>.html
  ```

Important contract:

- This stage is not `gmsp::selectRecords()`.
- `gmsp` selection filters raw/processed record indexes by seismological or
  processed-record metadata.
- `AR-S2J2J.R/scripts/runSelect.R` selects from scenario products and exports
  scaled scenario-specific records.

## Contrast With Current `gmsp/examples/scripts`

Current `gmsp` template surface:

```text
selection/runSelect.R
process/runProcess.R
gmsp/runGMSP.R
trim/runTrim.R
imf/runIMF.R
imf/runBuildIMFTS.R
psa/runPSA.R / psa/runBuildPSA.R
plot/runPlot.R
export/runExport.R
match/runMatch.R
```

Differences:

- `gmsp` current GMSP runner reads selected raw acceleration records with
  `gmsp::readAT()`, maps/rotates components with `gmsp::mapComponents()`, and
  publishes ProcessID products through the gmdb process contract.
- `AR-S2J2J.R` reads velocity records with `readTS(kind = "VT")`, calls
  `VT2TS()`, and writes project-local caches under `data/gmsp/`.
- `gmsp` current IMF pipeline is separated into `runIMF.R` and
  `runBuildIMFTS.R`, defaulting to VMD in the example JSON.
- `AR-S2J2J.R` combines decomposition and reconstruction in `.filterTS()` and
  currently uses EEMD.
- `gmsp` current PSA pipeline is a separate stage that reads a materialized
  source and writes a PSA product.
- `AR-S2J2J.R` computes spectra inside `.buildTS()`, `.filterTS()`, and
  `.scaleAT()` as supporting products for caches/scenarios.
- `gmsp::runExport()` packages generic processed products.
- `AR-S2J2J.R` exports scenario-specific PLAXIS files after scenario
  selection.
- `gmsp::runMatch()` exists in the library but is out of scope here.

## Methodology Drafting Guidance

A project methodology for AR-S2J2J should be organized around these sections:

1. **Blast record curation and unit propagation.**
2. **Prediction surface for blast peak responses** over charge and distance.
3. **Signal conversion from velocity to AT/VT/DT canonical products** using
   `gmsp::VT2TS()`.
4. **EEMD-based filtering and reconstruction** of acceleration histories.
5. **Scenario scaling from predicted component PPAs**, including unit
   conversion, per-record PGA normalization, horizontal principal-axis rotation,
   and vertical UP scaling.
6. **Scenario products and response spectra**, including `TSW`, `IMW`, `PSW`,
   and `D50` spectra where used.
7. **Audit checks** for vertical scaling, horizontal energy preservation, and
   positive PGAs.
8. **Record selection/export for PLAXIS**, clearly distinguished from raw
   `gmsp` record selection.

Public prose should follow the `psha/scaffold` chapter style:

- describe the methodological operation and study product, not the software
  switch or runner argument;
- keep function names, file names, and configuration keys in the research
  ledger/source map unless they are needed for traceability;
- write in the study voice: "the scenario products include...", "the spectra
  are evaluated...", "the selected records are retained/exported...", rather
  than "when configured/requested..." or user-instruction language;
- state explicitly that the blast-record workflow does not perform spectral
  matching.

Do not include:

```text
spectral matching
runMatch
target-spectrum matching
Stage A / Stage B match language
VMD as the active AR-S2J2J filtering method unless config changes
```

## Exact Next Command

```text
Draft a methodology source map/ledger from this audit before writing public prose.
```

## Exact Next Command

```text
wc -l scripts/runGMSP.R scripts/gmsp/setup.R scripts/runScenarios.R scripts/runAudit.R scripts/runPlots.R scripts/runSelect.R scripts/select/buildIndex.R scripts/select/buildPlots.R scripts/tools/setup.R
```
