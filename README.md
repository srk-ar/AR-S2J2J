# AR-S2J2J — Blast seismograph signal processing pipeline

## Data structure

### `data/blastDB.csv`
Training database. Columns: `Source, Q, D, SD, ppvL, ppvT, ppvV, ppaL, ppaT, ppaV`.
- `Q` — charge weight [kg]
- `D` — source-to-station distance [m]
- `SD` — scaled distance [m/kg^(1/3)]
- `ppvL/T/V` — peak particle velocity, L/T/V components [mm/s]
- `ppaL/T/V` — peak particle acceleration, L/T/V components [**g**]

### `data/export/predictions.csv`
Attenuation model predictions grid. Columns: `D, MIC, p, ppaL, ppaT, ppaV`.
- `D` — distance [m]
- `MIC` — Maximum Instantaneous Charge [kg]
- `p` — exceedance probability (0.5, 0.90, 0.95)
- `ppaL/T/V` — predicted PPA per component [**g**]

### `data/gmsp/F{Fmax}.Qo.Do/`
Raw processed signals from `buildTS`. One folder per `Fmax` (50, 80, 125 Hz).
- `TSL.csv` — long time series: `RecordID, OCID, ID, t, s`. OCID ∈ {L,T,V}; ID ∈ {AT,VT,DT}. Units: AT [mm/s²], VT [mm/s], DT [mm].
- `TSW.csv` — wide time series: `RecordID, t, AT.L, AT.T, AT.V, VT.L, …`
- `PSL.csv` — response spectra: `RecordID, OCID, xi, Tn, ID, S`. ID ∈ {PSA,PSV,SD}. Units: PSA [mm/s²], PSV [mm/s], SD [mm].
- `IMW.csv` — intensity measures wide: PGA [mm/s²], PGV [mm/s], PGD [mm], CAV [mm/s], IAI [mm²/s³], etc.
- `META.csv` — record metadata: `RecordID, D [m], Q [kg], Fs [Hz]` (real-world blast parameters).

### `data/gmsp/F{Fmax}.Qo.Do.eemd/`
EEMD-filtered signals from `filterTS`. Same file structure as above. IMF1 (high-freq) + IMF9+IMF10 (low-freq drift) removed.

### `data/records/scenarios/F{Fmax}.D{D}.Q{MIC}.p{P×100}/`
Scaled scenarios from `scaleAT`. Naming: `Fmax` [Hz], `D` [m], `MIC` [kg], `P` exceedance (e.g. p90 = 90th percentile).

Each folder contains:
- `TSL.csv` / `TSW.csv` — scaled, PCA-rotated time series. OCID ∈ {H1,H2,UP}. Units: AT [mm/s²], VT [mm/s], DT [mm].
- `PSL.csv` — absolute response spectra. PSA [mm/s²], PSV [mm/s], SD [mm]. PSA at Tn=0 equals PGA of that record for the scenario.
- `IMW.csv` — intensity measures for H1/H2/UP. PGA [mm/s²], PGV [mm/s], etc.
- `META.csv` — original real-world record metadata (D, Q from kashimaDB — not the scenario D/Q).
- `{ScenarioID}.json` — scenario parameters: `Fmax`, `D`, `MIC`, `P`, `SF.L/T/V` [**g**] = target PPA per component, `xi`, `TargetUnits`.

**Scale**: AT amplitude satisfies `max(|AT.L|) ≈ SF.L × 9806.65 mm/s²` before PCA rotation. After rotation, PGA.H1 reflects the combined L+T contribution.

### `data/records/raw/`
Raw blast event folders (`E{YYYYMMDDHHMMSS}/`). Velocity records in mm/s, Fs = 1024 Hz (ISEE format).

### `data/selections/`
Output of `runSelect.R`. Subfolders by ScenarioID. Files: `sel.{criterion}.N{N}.csv` — selected AT H1 time series (RecordID, t, s [mm/s²]).

---

## Pipeline scripts (`scripts/`)

| Script | Function | Notes |
|---|---|---|
| `runGMSP.R` | buildTS + filterTS | Run from project root |
| `runScenarios.R` | scaleAT — generate D×MIC scenarios | OVERRIDE=TRUE to regenerate |
| `runSelect.R` | Select N records → `data/records/plaxis/` | Edit Schema only — see `scripts/AGENTS.md` |
| `runPlots.R` | PSA-H1 + TS-H1 HTML plots | Run from RStudio |
| `runAudit.R` | Energy + PGA audit | Validates scaleAT output |

---

## Record selection (`runSelect.R`)

Select N records per scenario by intensity criterion and export to a user-defined
output folder (default `data/records/plaxis/`).

**Edit only the Schema section** of `scripts/runSelect.R` — see `scripts/AGENTS.md`
for full instructions.

Key Schema variables:

```r
Fmax     <- c(80L, 125L)   # which Fmax scenarios to process
P        <- 0.90           # exceedance probability
DIR      <- c("H1")        # components: "H1" | "H2" | "UP" (or multiple)
ID       <- c("AT")        # signal types: "AT" | "VT" | "DT" (or multiple)
N        <- 25L            # records per scenario
Rank.by  <- c("AI")        # one or more IMW columns — multi-column sort
Rank.dir <- "desc"         # "desc" | "asc" | "random"  (random ignores Rank.by)
OVERRIDE <- FALSE          # TRUE = clear output first
```

Output per scenario: `{RecordID}.{ID}.{DIR}.csv` + `IMW.csv` + HTML spaghetti plots.
Master `IMW.csv` at `data/records/plaxis/IMW.csv` across all selected scenarios.

---

## Unit summary

| Quantity | Unit |
|---|---|
| Acceleration (AT, PSA) | mm/s² |
| Velocity (VT, PSV) | mm/s |
| Displacement (DT, SD) | mm |
| PPA in blastDB / predictions | **g** |
| SF.L/T/V in scenario JSON | **g** |
| PPV in blastDB | mm/s |
