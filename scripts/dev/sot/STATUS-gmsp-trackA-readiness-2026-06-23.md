# STATUS-gmsp-trackA-readiness-2026-06-23

## Objective

Track A only: audit and repair `AR-S2J2J.R` scripts that consume or surround
`gmsp` so they remain compatible with the current `gmsp` contracts, without
deleting or overwriting accepted project outputs.

## Scope

Repository:

```text
/Users/averrik/Cloud/github/projects/AR-S2J2J.R
```

Files in this readiness audit:

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
scripts/tools/setup.R
scripts/runSelect.json
scripts/runScenarios.json
scripts/runPlots.json
scripts/runAudit.json
```

SoT/status files in scope:

```text
scripts/dev/sot/HANDOFF-agent-scripts-gmsp-2026-06-23.md
scripts/dev/sot/PLAN-gmsp-modernization-2026-06-23.md
scripts/dev/sot/AUDIT-gmsp-consumers-2026-06-23.md
scripts/dev/sot/STATUS-gmsp-trackA-readiness-2026-06-23.md
```

## Out Of Scope

- No methodology chapter work.
- No reads or edits under `AR-SABP0.R/dev/TITO`.
- No edits to the `gmsp` package.
- No deletion or overwrite under `data/gmsp/`.
- No deletion or overwrite under `data/records/scenarios/`.
- No full `scripts/runGMSP.R` or `scripts/runScenarios.R` run without user
  approval.
- No recursive scan of `~/kashimaDB/gmdb.v2/records`.
- No use of `data/records/raw` as an active runtime fallback.

## Current Plan

Harness tier: Tier 1 for deterministic script outputs when a code change is
made. The first intended smoke is consumer-only, writing to `/private/tmp`.

1. Complete mandatory reading and static inventory.
2. Record the readiness gate and compatibility matrix in this SoT.
3. Run syntax / JSON checks only after this SoT is current.
4. User approved generating/copying a bounded scenario fixture under
   `/private/tmp`.
5. Run the PLAXIS consumer smoke from a temporary project root under
   `/private/tmp`, using copied scripts and synthetic scenario products, so the
   repository does not receive a `data/records/scenarios` fixture.
6. If a compatibility failure is found, update this SoT with the exact file to
   edit before touching code.

Updated user request after bounded harnesses:

1. Commit and push the Track A SoT/audit state before a broad run.
2. Run the Track A scripts to see whether the production path works.
3. Use current `gmsp` explicitly, not the installed `0.4.7` library.

Full-run command order after commit/push:

```text
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runGMSP.R
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runScenarios.R
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runAudit.R
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runPlots.R
Rscript scripts/runSelect.R
Rscript scripts/select/buildIndex.R data/records/plaxis
Rscript scripts/select/buildPlots.R data/records/plaxis TRUE
```

This is a production-output run. Existing configs have `OVERRIDE = FALSE` for
`runGMSP.R`, `runScenarios.R`, `runPlots.R`, and `runSelect.R`; do not change
that before running. `runScenarios.R` may create `data/records/scenarios/`
because it is currently missing in this checkout.

## Readiness Gate

### 1. Roles

- Raw/gmdb producer:
  `scripts/runParse.R`, `scripts/parse/parsePipeline.R`, and
  `scripts/parse/buildTS.R`. These are project-specific data/domain parsers,
  not `gmsp` processing runners.
- Processed-signal producer:
  `scripts/runGMSP.R` plus `scripts/gmsp/setup.R::.buildTS()` and
  `.filterTS()`. They build project-local source caches under `data/gmsp/`.
- Scenario producer:
  `scripts/runScenarios.R` plus `scripts/gmsp/setup.R::.scaleAT()`. They build
  scenario products under `data/records/scenarios/`.
- Scenario / PLAXIS selector:
  `scripts/runSelect.R`, `scripts/select/buildIndex.R`, and
  `scripts/select/buildPlots.R`. They consume already materialized scenario
  folders and write a flat PLAXIS delivery folder.
- Scenario plot/audit consumers:
  `scripts/runPlots.R` and `scripts/runAudit.R`.
- Manual diagnostics:
  `scripts/plotTS.R`, `scripts/plotPSA.R`, and `scripts/plotIMF.R`.

### 2. Reads And Writes

- `runGMSP.R` reads no JSON. It runs fixed Fmax/kNyq rows through `.buildTS()`,
  `.filterTS()`, and `.suggestFmax()`, writing `data/gmsp/<InputID>/` and
  `data/gmsp/<OutputID>/`.
- `.buildTS()` reads `~/kashimaDB/gmdb.v2/index/RawRecordTable.ISEE.csv` and
  raw records under `~/kashimaDB/gmdb.v2/records`; it writes `TSL.csv`,
  `TSW.csv`, `IMW.csv`, `META.csv`, `PSL.csv`, and JSON under `data/gmsp/`.
- `.filterTS()` reads `data/gmsp/<InputID>/TSL.csv`, `META.csv`, and JSON; it
  writes filtered `TSL.csv`, `TSW.csv`, `IMW.csv`, `IMF.csv`,
  `IMF_metrics.csv`, `META.csv`, `PSL.csv`, and JSON under `data/gmsp/`.
- `runScenarios.R` reads `scripts/runScenarios.json` and calls `.scaleAT()`;
  after scenario generation it rebuilds `data/records/scenarios/IMW.csv`.
- `.scaleAT()` reads `data/gmsp/<InputID>/TSL.csv`, source JSON,
  `data/export/predictions.csv`, and `data/domains/units.json`; it writes
  `TSW.csv`, `PSW.csv`, `IMW.csv`, and JSON under
  `data/records/scenarios/<ScenarioID>/`.
- `runAudit.R` reads `scripts/runAudit.json`, `data/domains/units.json`,
  `data/gmsp/<InputID>/TSW.csv`, `IMW.csv`, source JSON, and matching
  scenarios; it writes `data/audit/<ScenarioID>.csv` and `summary.csv`.
- `runPlots.R` reads `scripts/runPlots.json` and scenario `PSW.csv`, `TSW.csv`,
  and JSON; it writes `PSA-<OCID>.html` and `TS-<OCID>.html` inside scenario
  folders.
- `runSelect.R` reads `scripts/runSelect.json` or an alternate JSON plus
  scenario `TSW.csv`, `IMW.csv`, and JSON; it writes selected record CSV files
  and a copied config into `PATH.out`.
- `select/buildIndex.R` reads the flat PLAXIS CSV folder and scenario
  `IMW.csv`; it writes `PATH.out/IMW.csv` and `PATH.out/unique.csv`.
- `select/buildPlots.R` reads the flat PLAXIS CSV folder and scenario
  `PSW.csv` plus JSON; it writes PLAXIS review HTML into `PATH.out`.
- `plotTS.R`, `plotPSA.R`, and `plotIMF.R` read `data/gmsp/<InputID>/` or
  `<OutputID>/` products and may write HTML under those same source-cache
  folders.
- `runParse.R` reads `scripts/manifest.json`; `parse/buildTS.R` reads
  kashimaDB `ISEE/*/*/raw.owner/record.json` and writes
  `data/domains/records.index.csv`.

### 3. `gmsp` Calls

- `.buildTS()`: `readTS()`, `VT2TS()`, `gmsp::TSL2TSW()`,
  `gmsp::TSL2IM()`, and `gmsp::TSL2PS()`.
- `.filterTS()`: `TS2IMF()`, `AT2TS()`, `gmsp::TSL2TSW()`,
  `gmsp::TSL2IM()`, and `gmsp::TSL2PS()`.
- `.scaleAT()`: `gmsp:::.getSF()`, `gmsp::TSL2TSW()`, `gmsp::TSL2PS()`,
  and `gmsp::TSL2IM()`.
- `runAudit.R`: `gmsp:::.getSF()` and `gmsp::TSW2TSL()`.
- `runPlots.R`: `gmsp::PSW2PSL()` only to discover available OCIDs.
- `plotTS.R`: `gmsp::TSW2TSL()` and `TSL2PS()`.
- `plotPSA.R`: `gmsp::TSW2TSL()` and `TSL2PS()`.
- `plotIMF.R`: `AT2TS()`, `TSL2PS()`, and `gmsp::TSW2TSL()`.
- `runSelect.R`, `select/buildIndex.R`, `select/buildPlots.R`, `runParse.R`,
  `parse/parsePipeline.R`, and `parse/buildTS.R` do not call `gmsp`.

### 4. Current Public API Vs Private Or Legacy

Installed `gmsp` in the local R library is `0.4.7`; the checked-out current
`gmsp` source is `0.5.1`.

Public in current `gmsp` source by `NAMESPACE`:

```text
readTS
selectRecords
TSW2TSL
PSW2PSL
TSL2TSW
TSL2IM
TSL2PS
AT2TS
VT2TS
TS2IMF
normalizeTS
```

Private / not exported:

```text
gmsp:::.getSF()
```

Current `gmsp` example-runner helpers, not package exports:

```text
runProcess
getRecord
getRecords
recordAccess.R::selectRecords(keys, criteria, singleRecord, paths)
```

Legacy or risk-bound contracts in this repo:

- `.buildTS()` uses `RawRecordTable.ISEE.csv`; current `gmsp` database
  documents `index/RawMasterIndex.csv` for the raw global master.
- `.buildTS()` and `parse/buildTS.R` recursively list ISEE record JSON files.
- `.buildTS()` and `.filterTS()` write project-local `data/gmsp` caches rather
  than durable `gmdb.v2` `ProcessID` products.

### 5. Why `runSelect.R` Must Remain A Scenario / PLAXIS Selector

`scripts/runSelect.R` selects from already scaled scenario folders under
`data/records/scenarios/`. It filters by scenario `Fmax`, `P`, `D.range`, and
`MIC.range`, ranks records using scenario `IMW.csv`, then exports scaled
`TSW.csv` columns into a flat PLAXIS delivery folder. The selected CSV names
include `<RecordID>.<ID>.<DIR>.<ScenarioID>.csv` because the same raw record may
appear in multiple scaled scenario products.

`gmsp::selectRecords()` filters a record metadata table and returns
`RecordID, OwnerID, EventID, StationID` keys for raw or processed record access.
The current example-runner `recordAccess.R::selectRecords()` filters a
database/index by `ProcessID`. Neither function knows about
`D.range`/`MIC.range` scenario folders, PLAXIS flat exports, or scaled
scenario-specific filenames. Replacing this repo's `runSelect.R` with
`gmsp::selectRecords()` would remove the project-specific PLAXIS export
contract.

### 6. Current `gmsp` Database Contract

The accepted `gmsp` database flow is:

```text
runSelect(processID = "raw") -> runProcess -> stage/<ProcessID>.selection/selection.csv
runPlot/runExport/runMatch -> existing ProcessID selection or produced package
```

Durable processed records live under:

```text
records/<OwnerID>/<EventID>/<StationID>/<ProcessID>/<Output>.<RecordID>.csv
process/<ProcessID>/process.json
process/<ProcessID>/MasterIndex.csv
process/<ProcessID>/IntensityTable.csv
index/MasterIndex.csv
index/IntensityTable.csv
index/RawMasterIndex.csv
```

`runProcess` is a producer of record-local process products and parent-owned
process/index tables. `runPlot`, `runExport`, and `runMatch` are consumers of
an existing processed selection or produced package. This contract explains
why this repo's project-local `data/gmsp/` producers should not be assumed
compatible with `ProcessID` workflows without a separate producer prototype.

### 7. Test Output Location And Non-Overwrite Proof

The intended PLAXIS smoke output is:

```text
/private/tmp/AR-S2J2J-plaxis-smoke-20260623
```

The smoke config must set:

```text
PATH.out = /private/tmp/AR-S2J2J-plaxis-smoke-20260623
Samples.N = 1
OVERRIDE = TRUE
```

Non-overwrite proof:

- use a temp JSON under `/private/tmp`;
- verify `PATH.out` is outside the repository;
- run `git status --short --branch` before and after;
- inspect only expected files under the temp output folder;
- do not run `runScenarios.R`, `runGMSP.R`, or any script that writes
  `data/gmsp/` or `data/records/scenarios/`.

Current blocker: this checkout has no `data/records/scenarios` directory, so
the PLAXIS smoke has no read-only scenario input. Generating scenarios to
unblock it would require `runScenarios.R`, which is explicitly not authorized
for this phase.

Updated decision: the user authorized generating test materials in
`/private/tmp`. The accepted harness path is a synthetic WIDE scenario fixture,
not a `runScenarios.R` producer run.

## Compatibility Matrix

| script | role | input | output | gmsp API | risk | proposed harness |
|---|---|---|---|---|---|---|
| `scripts/runGMSP.R` | processed-signal producer runner | fixed Fmax/kNyq schema; kashimaDB via `.buildTS()` | `data/gmsp/F*.Qo.Do*` | through `.buildTS()`, `.filterTS()`, `.suggestFmax()` | full producer writes large accepted caches; no subset hook | blocked; needs prototype or temp gmdb fixture |
| `scripts/gmsp/setup.R::.buildTS()` | raw/gmdb to source-cache producer | `RawRecordTable.ISEE.csv`; `records/ISEE`; raw VT files | `TSL`, `TSW`, `IMW`, `META`, `PSL`, JSON under `data/gmsp` | `readTS`, `VT2TS`, `TSL2TSW`, `TSL2IM`, `TSL2PS` | uses legacy raw index name and recursive ISEE listing | Stage C producer prototype only |
| `scripts/gmsp/setup.R::.filterTS()` | source-cache filter producer | `data/gmsp/<InputID>/TSL.csv`, `META.csv`, JSON | filtered source-cache tables under `data/gmsp/<OutputID>` | `TS2IMF`, `AT2TS`, `TSL2TSW`, `TSL2IM`, `TSL2PS` | large deterministic producer; parallel IMF path | temp fixture after `.buildTS()` strategy |
| `scripts/gmsp/setup.R::.scaleAT()` | scenario producer | `data/gmsp/<InputID>/TSL.csv`, predictions, units sidecar | `data/records/scenarios/<ScenarioID>` | private `.getSF`, `TSL2TSW`, `TSL2PS`, `TSL2IM` | writes official scenarios; private unit helper | no run without user approval; use temp/candidate root only after design |
| `scripts/runScenarios.R` | scenario producer runner | `scripts/runScenarios.json`; `data/gmsp`; predictions; units | `data/records/scenarios` and master `IMW.csv` | through `.scaleAT()` | official scenario overwrite risk | blocked pending user approval |
| `scripts/runAudit.R` | scenario audit consumer | `runAudit.json`; `data/gmsp`; scenarios; units | `data/audit` | private `.getSF`; `TSW2TSL` | writes repo audit products; private helper | temp-output patch would be needed before smoke |
| `scripts/runPlots.R` | scenario plot consumer | `runPlots.json`; scenario `PSW`, `TSW`, JSON | HTML inside scenario folders | `PSW2PSL` | writes into official scenarios | no first smoke; possible temp copied scenario only |
| `scripts/runSelect.R` | scenario / PLAXIS selector | `runSelect.json`; scenario `TSW`, `IMW`, JSON | flat PLAXIS CSVs and copied config in `PATH.out` | none | requires existing scenario products | first smoke once scenario source exists |
| `scripts/select/buildIndex.R` | PLAXIS postprocess | flat PLAXIS CSVs; source scenario `IMW.csv` | `PATH.out/IMW.csv`, `PATH.out/unique.csv` | none | low if `PATH.out` is temp | first smoke once selection exists |
| `scripts/select/buildPlots.R` | PLAXIS review plotter | flat PLAXIS CSVs; source scenario `PSW.csv`; JSON | PLAXIS review HTML in `PATH.out` | none | low if `PATH.out` is temp | first smoke once selection exists |
| `scripts/plotTS.R` | manual diagnostic | `data/gmsp/<ProcessID>/TSW.csv`, JSON | interactive plot object | `TSW2TSL`, `TSL2PS` | hardcoded record; may compute over source cache | parse/static only |
| `scripts/plotPSA.R` | manual diagnostic | `data/gmsp/<InputID>/TSW.csv`, `META.csv`, JSON | HTML in `data/gmsp/<InputID>` | `TSW2TSL`, `TSL2PS` | writes source-cache HTML | parse/static only |
| `scripts/plotIMF.R` | manual diagnostic | `data/gmsp/<OutputID>/IMF.csv`, `TSW.csv`, JSON | HTML in `data/gmsp/<OutputID>` | `AT2TS`, `TSL2PS`, `TSW2TSL` | writes source-cache HTML | parse/static only |
| `scripts/runParse.R` | project-specific parse runner | `scripts/manifest.json` | parse/domain outputs via `parsePipeline` | none | can scan kashimaDB and update domain tables | no run in this track |
| `scripts/parse/parsePipeline.R` | project-specific parse orchestrator | manifest parse config; kashimaDB paths | domain CSVs and `blastDB` through sourced scripts | none | writes domain tables; optional legacy raw branch | no run in this track |
| `scripts/parse/buildTS.R` | kashimaDB metadata index producer | `ISEE/*/*/raw.owner/record.json` | `data/domains/records.index.csv` | none | recursive kashimaDB listing; no small fixture hook | blocked; bounded prototype only |
| `scripts/manifest.json` | shared config | parse/data/model config | none directly | none | kashimaDB path points at records root | JSON parse only |

## Status

Mandatory reading completed:

- `scripts/AGENTS.md`
- `scripts/dev/sot/PLAN-gmsp-modernization-2026-06-23.md`
- `scripts/dev/sot/AUDIT-gmsp-consumers-2026-06-23.md`
- `/Users/averrik/Cloud/github/garage/harness/HARNESS.md`
- `/Users/averrik/Cloud/github/garage/style/AGENTS.md`
- `/Users/averrik/Cloud/github/garage/style/R.md`
- `/Users/averrik/Cloud/github/garage/style/R-data.table.md`
- `/Users/averrik/Cloud/github/libraries/gmsp/dev/SoT/ACTIVE.md`
- `/Users/averrik/Cloud/github/libraries/gmsp/dev/plan/database/active.md`
- `/Users/averrik/Cloud/github/libraries/gmsp/examples/scripts/README.md`

Additional Track A docs read:

- `README.md`
- `scripts/README.md`
- `/Users/averrik/Cloud/github/garage/style/technical-writing.md`
- `/Users/averrik/Cloud/github/libraries/gmsp/dev/plan/parallel-0.5.1.md`

Static inspection completed for candidate scripts and configs. Static parse and
JSON validation passed after this SoT was created. The bounded PLAXIS consumer
smoke passed from a synthetic `/private/tmp` fixture. Current-`gmsp` API/source
checks passed with a temp library. `runPlots.R` passed against the same temp
scenario under current `gmsp`. A bounded `.scaleAT()` producer prototype passed
in a separate temp root under current `gmsp`, and `runAudit.R` passed against
that temp scenario. A bounded `.filterTS()` source-cache prototype passed under
current `gmsp`. A bounded `.buildTS()` raw-to-source-cache prototype passed
under current `gmsp`. A bounded `scripts/parse/buildTS.R` prototype passed.
No production pipeline was run. No code files were edited. The bounded
Track A audit found no script repair that is justified by current harness
evidence.

Current filesystem findings:

- local R resolves installed `gmsp` as `0.4.7`;
- local `gmsp` checkout has `DESCRIPTION` version `0.5.1`;
- this checkout has `data/gmsp/` source-cache folders;
- this checkout has no `data/records/scenarios` directory;
- `git status` already had untracked SoT files from the prior audit/handoff.
- user approved generating bounded fixture files under `/private/tmp`.
- later `git status` showed an additional untracked
  `scripts/dev/sot/PLAN-arias-cav-plots-2026-06-23.md`; it was not created by
  this Track A harness and is out of scope.
- later `git status` also showed untracked
  `scripts/dev/sot/HANDOFF-agent-arias-cav-plots-2026-06-23.md`; it was not
  created by this Track A harness and is out of scope.

## Completed

- Read mandatory docs and supplementary Track A docs.
- Mapped candidate scripts by role, input, output, and `gmsp` calls.
- Confirmed `runSelect.R` is a scenario/PLAXIS selector, not a `gmsp`
  database selector.
- Confirmed current `gmsp` database contract and the public/private boundary.
- Confirmed the proposed PLAXIS consumer smoke is blocked by missing scenario
  inputs in this checkout.
- Ran static script parse successfully.
- Ran JSON parse successfully.
- Rechecked git status after validation.
- Created `/private/tmp/AR-S2J2J-plaxis-fixture-20260623` with copied scripts
  and one synthetic WIDE scenario.
- Ran `Rscript scripts/runSelect.R
  /private/tmp/AR-S2J2J-plaxis-fixture-20260623/runSelect.smoke.json` from the
  temp root.
- Ran `Rscript scripts/select/buildIndex.R
  /private/tmp/AR-S2J2J-plaxis-smoke-20260623` from the temp root.
- Ran `Rscript scripts/select/buildPlots.R
  /private/tmp/AR-S2J2J-plaxis-smoke-20260623 TRUE` from the temp root.
- Validated temp smoke outputs:
  - one selected record CSV with 10 rows;
  - `IMW.csv` with 1 row;
  - `unique.csv` with 1 row;
  - one TS HTML;
  - one PSA HTML.
- Confirmed the repository still has no `data/records/scenarios` directory.
- Installed local `gmsp` checkout version `0.5.1` into
  `/private/tmp/AR-S2J2J-gmsp-lib-20260623`.
- Verified current `gmsp` exports required by the repo:
  `readTS`, `selectRecords`, `TSW2TSL`, `PSW2PSL`, `TSL2TSW`, `TSL2IM`,
  `TSL2PS`, `AT2TS`, `VT2TS`, and `TS2IMF`.
- Verified private `gmsp:::.getSF()` exists in current `gmsp` `0.5.1`.
- Sourced `scripts/gmsp/setup.R` successfully under current `gmsp` without
  executing producer runners.
- Copied `scripts/runPlots.R` into the temp fixture and ran it under
  `gmsp` `0.5.1`.
- Validated temp scenario HTML from `runPlots.R`:
  - `PSA-H1.html`;
  - `TS-H1.html`.
- Created `/private/tmp/AR-S2J2J-scaleAT-fixture-20260623` with copied
  `scripts/gmsp/setup.R`, tools helpers, one synthetic source `TSL.csv`,
  `predictions.csv`, and `data/domains/units.json`.
- First `.scaleAT()` attempt failed because the synthetic `predictions.csv`
  had only one distance row; `.interp2D()` legitimately requires at least two
  distance values for `approx()`.
- Corrected the synthetic predictions grid to two distance rows.
- Ran `.scaleAT()` under current `gmsp` `0.5.1` with `D50 = TRUE`,
  `nTheta = 6`, `PARALLEL = FALSE`, and output under the temp root.
- Validated `.scaleAT()` temp outputs:
  - `TSW.csv` with 101 rows;
  - `IMW.csv` with OCIDs `H1,H2,UP`;
  - `PSW.csv` with `PSA/PSV/SD` columns for `H1,H2,UP,D50`;
  - scenario JSON sidecar.
- Generated source-cache `TSW.csv` and `IMW.csv` in the `.scaleAT()` temp
  fixture for `runAudit.R`.
- Copied `scripts/runAudit.R` into the temp fixture and ran it under
  `gmsp` `0.5.1`.
- Validated `runAudit.R` temp outputs:
  - `data/audit/F80.D150.Q150.p90.csv` with 1 row;
  - `data/audit/summary.csv` with 1 row;
  - `PASS = TRUE`.
- Created `/private/tmp/AR-S2J2J-filterTS-fixture-20260623` with copied
  `scripts/gmsp/setup.R`, tools helpers, and synthetic source-cache
  `TSL.csv`, `META.csv`, and JSON.
- Ran `.filterTS()` under current `gmsp` `0.5.1` with `Method = "emd"`,
  `K.imf = 3`, `IMF.remove = 1`, `PARALLEL = FALSE`, and temp output.
- Validated `.filterTS()` temp outputs:
  - `TSL.csv` with 4500 rows;
  - `TSW.csv` with 500 rows;
  - `IMW.csv` with 3 rows;
  - `IMF.csv` with 1503 rows;
  - `IMF_metrics.csv` with 12 rows;
  - `META.csv` with 1 row;
  - `PSL.csv` with 459 rows;
  - output JSON sidecar.
- Noted expected fixture-level `AT2TS()` warning about synthetic short-signal
  bandwidth / few STFT windows.
- Created `/private/tmp/AR-S2J2J-buildTS-fixture-20260623` with copied
  `scripts/gmsp/setup.R`, tools helpers, a synthetic
  `RawRecordTable.ISEE.csv`, a raw `VT.<RecordID>` CSV/JSON sidecar, and
  `raw.owner/record.json`.
- Overrode `.FILE.INDEX` and `.PATH.RECORDS` inside the R session only and ran
  `.buildTS()` under current `gmsp` `0.5.1`.
- Validated `.buildTS()` temp outputs:
  - `TSL.csv` with 2160 rows;
  - `TSW.csv` with 240 rows;
  - `IMW.csv` with 3 rows;
  - `META.csv` with 1 row;
  - `PSL.csv` with 234 rows;
  - output JSON sidecar.
- Noted expected fixture-level `VT2TS()` warning about few STFT windows.
- Exact-file check found both real database index files exist on this machine:
  - `~/kashimaDB/gmdb.v2/index/RawRecordTable.ISEE.csv`;
  - `~/kashimaDB/gmdb.v2/index/RawMasterIndex.csv`.
- Created `/private/tmp/AR-S2J2J-parse-buildTS-fixture-20260623` with copied
  `scripts/parse/buildTS.R`, `scripts/tools/json.R`, and one hydrated
  `raw.owner/record.json`.
- Ran `scripts/parse/buildTS.R` in the temp root with explicit
  `.path.kashimaDB`, `.path.domains`, and `GAP.THRESHOLD`.
- Validated `records.index.csv` with 1 row, 1 event, and expected columns.

## Pending

- No code repair is pending from the bounded Track A harnesses.
- If future work opens producer modernization, write a new SoT section first
  deciding whether `data/gmsp` project-local caches remain accepted or whether
  production should move to current `gmsp` `ProcessID` helpers.
- Commit and push Track A SoT/audit files before running the production path.
- Run the full Track A production path under current `gmsp` `0.5.1`.

## Rejected

- Replacing `scripts/runSelect.R` with `gmsp::selectRecords()`: rejected because
  it would drop scenario/PLAXIS behavior.
- Running `scripts/runScenarios.R` to manufacture smoke inputs: rejected without
  explicit user approval. After user approval for `/private/tmp`, the accepted
  path is still a synthetic fixture, not running `runScenarios.R`.
- Running `scripts/runGMSP.R` or producer scripts directly: rejected without a
  bounded producer harness and user approval.
- Treating installed `gmsp` `0.4.7` as evidence of compatibility with current
  `gmsp` `0.5.1`: rejected.
- Using `data/records/raw` as a fallback scenario source: rejected because it is
  not the active scenario contract and `scripts/AGENTS.md` says legacy raw paths
  are removed from runtime parse expectations.

## Risks

- `.buildTS()` is coupled to `RawRecordTable.ISEE.csv` and raw-owner record
  JSON scanning, while current `gmsp` database docs use `RawMasterIndex.csv`
  and `ProcessID` publication.
- `.scaleAT()` and `runAudit.R` use private `gmsp:::.getSF()`. Current
  `gmsp` source does not export a public unit conversion helper.
- `runPlots.R`, `plotPSA.R`, and `plotIMF.R` write HTML into accepted product
  folders by default.
- A current-`gmsp` test requires an explicit library path/install for the
  `gmsp` `0.5.1` checkout.

## Validation

Validation completed before this SoT:

- `git status --short --branch`;
- static code reads and bounded metadata checks only.

Validation completed after this SoT:

```text
Rscript -e 'files <- c("scripts/runParse.R","scripts/runAudit.R","scripts/runGMSP.R","scripts/runScenarios.R","scripts/runPlots.R","scripts/runSelect.R","scripts/select/buildIndex.R","scripts/select/buildPlots.R","scripts/plotTS.R","scripts/plotPSA.R","scripts/plotIMF.R","scripts/parse/parsePipeline.R","scripts/parse/buildTS.R"); invisible(lapply(files, parse)); cat("parse OK\n")'
Rscript -e 'files <- c("scripts/manifest.json","scripts/runSelect.json","scripts/runScenarios.json","scripts/runPlots.json","scripts/runAudit.json"); invisible(lapply(files, jsonlite::read_json)); cat("json OK\n")'
git status --short --branch
```

Results:

```text
parse OK
json OK
git status: main...origin/main with untracked SoT/audit/handoff files only
```

Consumer smoke completed from a temp project root:

```text
Rscript scripts/runSelect.R /private/tmp/AR-S2J2J-plaxis-fixture-20260623/runSelect.smoke.json
Rscript scripts/select/buildIndex.R /private/tmp/AR-S2J2J-plaxis-smoke-20260623
Rscript scripts/select/buildPlots.R /private/tmp/AR-S2J2J-plaxis-smoke-20260623 TRUE
```

Results:

```text
runSelect done
select/buildIndex done
select/buildPlots done - 1 TS, 1 PSA
/private/tmp/AR-S2J2J-plaxis-smoke-20260623 contains:
  R001.AT.H1.F80.D150.Q150.p90.csv
  IMW.csv
  unique.csv
  F80.D150.Q150.p90.TS-AT-H1.html
  F80.D150.Q150.p90.PSA-H1.html
  runSelect.smoke.json
```

Current-`gmsp` API/source check completed:

```text
R CMD INSTALL -l /private/tmp/AR-S2J2J-gmsp-lib-20260623 /Users/averrik/Cloud/github/libraries/gmsp
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript -e '<api and source check>'
```

Result:

```text
gmsp 0.5.1 api/source OK
```

`runPlots.R` temp smoke completed:

```text
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runPlots.R /private/tmp/AR-S2J2J-plaxis-fixture-20260623/runPlots.smoke.json
```

Result:

```text
PSA F80.D150.Q150.p90 / H1 passed
TS F80.D150.Q150.p90 / H1 passed
runPlots done - 1 scenarios x 1 dirs
```

`.scaleAT()` temp prototype completed:

```text
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript -e 'source("scripts/gmsp/setup.R"); .scaleAT(InputID = "F80.Qo.Do.eemd", D.grid = 150, MIC.grid = 150, P = 0.90, D50 = TRUE, nTheta = 6L, PARALLEL = FALSE, OVERRIDE = TRUE)'
```

Result:

```text
.scaleAT done -> 1 scenarios
TSW rows: 101
IMW rows: 3; OCID: H1,H2,UP
PSW includes PSA/PSV/SD for H1,H2,UP,D50
```

`runAudit.R` temp smoke completed:

```text
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runAudit.R /private/tmp/AR-S2J2J-scaleAT-fixture-20260623/runAudit.smoke.json
```

Result:

```text
F80.D150.Q150.p90 passed with n=1
1/1 scenarios PASS
scenario audit rows: 1
summary rows: 1; PASS TRUE
```

`.filterTS()` temp prototype completed:

```text
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript -e 'source("scripts/gmsp/setup.R"); .filterTS(InputID = "F80.Qo.Do", OutputID = "F80.Qo.Do.eemd", Method = "emd", K.imf = 3L, IMF.remove = 1L, keepResidual = FALSE, PARALLEL = FALSE, OVERRIDE = TRUE)'
```

Result:

```text
.filterTS done -> F80.Qo.Do.eemd/
TSL.csv 4500 rows
TSW.csv 500 rows
IMW.csv 3 rows
IMF.csv 1503 rows
IMF_metrics.csv 12 rows
META.csv 1 row
PSL.csv 459 rows
```

`.buildTS()` temp prototype completed:

```text
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript -e 'source("scripts/gmsp/setup.R"); .FILE.INDEX <- "/private/tmp/AR-S2J2J-buildTS-fixture-20260623/gmdb/index/RawRecordTable.ISEE.csv"; .PATH.RECORDS <- "/private/tmp/AR-S2J2J-buildTS-fixture-20260623/gmdb/records"; .buildTS(InputID = "F40.Qo.Do", Fmax = 40, kNyq = 3.125, Tn.max = 0.10, n.Tn = 25L, OVERRIDE = TRUE)'
```

Result:

```text
.buildTS done -> F40.Qo.Do/
TSL.csv 2160 rows
TSW.csv 240 rows
IMW.csv 3 rows
META.csv 1 row
PSL.csv 234 rows
legacy RawRecordTable.ISEE.csv exists
current RawMasterIndex.csv exists
```

`scripts/parse/buildTS.R` temp prototype completed:

```text
Rscript -e '.path.kashimaDB <- "/private/tmp/AR-S2J2J-parse-buildTS-fixture-20260623/kashimaDB/records"; .path.domains <- "/private/tmp/AR-S2J2J-parse-buildTS-fixture-20260623/data/domains"; GAP.THRESHOLD <- 60; source("scripts/parse/buildTS.R")'
```

Result:

```text
records.index.csv: 1 rows, 1 events
records.index rows: 1
events: 1
columns: FilenameTS,TSID,EventID,StationID,DateTime,Diff,isSameEvent,FS,ppvL,ppvT,ppvV,ppaL,ppaT,ppaV,D
```

## Production Run 2026-06-24

User request:

```text
antes commit push; corre todo a ver si funciona
```

Completed publication before production run:

```text
git commit -m "Record gmsp Track A validation"
git push origin main
```

Commit pushed:

```text
038aa15 Record gmsp Track A validation
```

Production run status:

- `R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runGMSP.R`
  completed successfully; with `OVERRIDE = FALSE`, existing `data/gmsp`
  source caches were reused.
- `R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript
  scripts/runScenarios.R` completed successfully after restart in tmux.
- The run wrote production `data/records/scenarios/` outputs: 72 scenario
  directories, 72 `TSW.csv` files, 72 `PSW.csv` files, and
  `data/records/scenarios/IMW.csv` with 18,576 data rows.
- The user requested tmux after the connection interruption. `tmux ls` requires
  elevated execution in this sandbox and succeeds outside the sandbox; no tmux
  server was running at resume. Use tmux for subsequent long commands.
- Correction: the user clarified "pausa" meant pause the interaction, not stop
  the run. The non-tmux `runScenarios.R` process had already been interrupted
  with Ctrl-C. It was immediately restarted in tmux with `OVERRIDE = FALSE`.
- Completed tmux session:
  `ar-s2j2j-runScenarios-20260624`.
- Completed log:
  `/private/tmp/AR-S2J2J-runScenarios-20260624.log`.
- Final log marker: `EXIT:0`.

Remaining production commands were run in tmux session
`ar-s2j2j-trackA-rest-20260626` with log
`/private/tmp/AR-S2J2J-trackA-rest-20260626.log`.

Results:

- `R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript
  scripts/runAudit.R` exited 0 and wrote `data/audit/`, but the audit result
  was partial pass: 30/36 scenarios PASS.
- Audit failures:
  - `F125.D350.Q200.p90`
  - `F125.D350.Q350.p90`
  - `F125.D350.Q400.p90`
  - `F125.D400.Q150.p90`
  - `F125.D400.Q200.p90`
  - `F125.D400.Q400.p90`
- Failure mode: all six scenarios fail only `energy.ok`; `UP.ok` and
  `PGA.pos` remain true. Per-record `energy.ok` failures:
  `F125.D350.Q200.p90` 86/86, `F125.D350.Q350.p90` 5/86,
  `F125.D350.Q400.p90` 15/86, `F125.D400.Q150.p90` 86/86,
  `F125.D400.Q200.p90` 4/86, `F125.D400.Q400.p90` 86/86.
  Observed failing `E.ratio` ranges are close to the current `tol = 0.001`
  threshold: about 0.998538-0.998689, 1.000518-1.001057,
  0.998960-0.999156, 1.001266-1.001268, 1.000578-1.001176, and
  1.001349-1.001421 respectively.
- `R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript
  scripts/runPlots.R` exited 0 and generated 36 `PSA-D50.html` plus
  36 `TS-H1.html` files for the `F80` scenarios.
- `Rscript scripts/runSelect.R` exited 0 and selected 25 records for each of
  24 `F80` scenarios.
- `Rscript scripts/select/buildIndex.R data/records/plaxis` exited 0 and wrote
  `data/records/plaxis/IMW.csv` with 600 data rows plus
  `data/records/plaxis/unique.csv` with 35 data rows.
- `Rscript scripts/select/buildPlots.R data/records/plaxis TRUE` exited 0 and
  wrote 24 TS plus 24 PSA review HTML files.
- Final tmux log marker: `TMUX_EXIT:0`.

The command-level production path completed, but the Track A result is not a
clean functional pass because `runAudit.R` reported 6 failed scenarios.

Generated outputs are currently untracked:

```text
data/audit/
data/records/plaxis/
data/records/scenarios/
```

Do not stage these bulk outputs without an explicit decision.

Completed production command order:

```text
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runAudit.R
R_LIBS=/private/tmp/AR-S2J2J-gmsp-lib-20260623 Rscript scripts/runPlots.R
Rscript scripts/runSelect.R
Rscript scripts/select/buildIndex.R data/records/plaxis
Rscript scripts/select/buildPlots.R data/records/plaxis TRUE
```

## Exact Next Command

Investigate the six `runAudit.R` failures before treating this run as accepted.
Start with `data/audit/summary.csv`, then inspect per-scenario audit CSVs for
which check failed (`UP.ok`, `energy.ok`, or `PGA.pos`).

```text
Rscript -e 'S <- read.csv("data/audit/summary.csv"); print(S[!S$PASS, ])'
```
