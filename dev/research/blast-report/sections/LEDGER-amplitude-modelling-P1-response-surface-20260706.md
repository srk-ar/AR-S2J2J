# LEDGER-amplitude-modelling-P1-response-surface-20260706

## Section

P1: opening methodology paragraph for the signal-amplitude model.

## Report Purpose

Introduce the amplitude model before any discussion of error metrics,
conditional PPV improvement, scenario scaling details, figures, or tables.

The paragraph must state that the model estimates peak vibration amplitudes
for blast loading cases indexed by source-to-receiver distance and maximum
instantaneous charge. It must connect the model responses and predictors to the
scenario time histories generated later in the methodology.

## Sources Read

Project source:

```text
scripts/manifest.json
scripts/data/buildDomains.R
scripts/data/buildDatasets.R
scripts/runModel.R
scripts/runPost.R
data/export/predictions.csv
data/summary/metrics.csv
```

Library source:

```text
/Users/averrik/Cloud/github/libraries/ssel/vignettes/ensemble-theory.Rmd
/Users/averrik/Cloud/github/libraries/ssel/docs/articles/pipeline.md
```

Style source:

```text
/Users/averrik/Cloud/github/garage/style/technical-writing.md
/Users/averrik/Cloud/github/tools/psha/dev/SoT/LEDGER-srs-methodology-P1-record-selection-20260702.md
/Users/averrik/Cloud/github/tools/psha/dev/SoT/CANDIDATE-srs-professional-report-chapter-20260703.md
```

## Exact Claims Allowed

- The signal-amplitude model estimates peak vibration amplitudes for blast
  loading cases indexed by source-to-receiver distance and MIC.
- The response family includes PPV and PPA as scalar amplitudes and as L, T,
  and V component amplitudes.
- The explanatory variables include charge, distance, scaled distance, and
  logarithmic or reciprocal transformations of distance and charge.
- The fitted models are evaluated on the distance-MIC scenario grid.
- Component PPA quantiles define acceleration-amplitude levels used for
  scenario time-history generation.

## Claims Not Allowed

- Do not define the model by contrast or negation.
- Do not discuss pore-pressure, liquefaction, deformation, or numerical model
  response in this paragraph.
- Do not state that PPV error is reduced by conditioning on PPA.
- Do not report RMSE, R2, or other model-performance values in this paragraph.
- Do not name scripts, packages, helper functions, file paths, generated
  tables, or implementation directories.

## Equations Allowed

None.

P1 is a formulation paragraph. Regression notation and scaling equations may
be introduced later if they improve the chapter flow.

## Equations Excluded

- Regression equation.
- Predictive quantile equation.
- Scenario scaling equation.
- Chain-regression equations.
- Pore-pressure or liquefaction equations.

## Vocabulary Allowed

- `signal-amplitude model`
- `peak vibration amplitude`
- `blast loading case`
- `source-to-receiver distance`
- `maximum instantaneous charge`
- `MIC`
- `peak particle velocity`
- `PPV`
- `peak particle acceleration`
- `PPA`
- `L, T, and V component amplitude`
- `scaled distance`
- `explanatory variable`
- `distance-MIC scenario grid`
- `empirical predictive quantile`
- `scenario time history`

## Vocabulary Rejected

- `pipeline`
- `workflow`
- `script`
- `helper`
- `runner`
- `package`
- `CSV`
- `JSON`
- `folder`
- `path`
- `software`
- `manual`
- `not a physics model`
- `not pore pressure`
- `not liquefaction`
- `PLAXIS-compatible`
- `spectral matching`
- `human comfort`
- `building damage`

Rejected terms may appear in this ledger only to define exclusions.

## Candidate Public Paragraph Or Section

The signal-amplitude model estimates peak vibration amplitudes for blast loading cases indexed by source-to-receiver distance and maximum instantaneous charge (MIC). The retained response set includes peak particle velocity (PPV) and peak particle acceleration (PPA) as scalar amplitudes and as L, T, and V component amplitudes. The fitted models use MIC, distance, scaled distance, and logarithmic or reciprocal transformations of MIC and distance as explanatory variables. They are evaluated on the distance-MIC scenario grid, and the component PPA quantiles provide the acceleration-amplitude targets used later to generate scenario time histories.

## Candidate Translation Terminology

Do not translate P1 until the English paragraph is approved.

Terminology likely needed after approval:

- `signal-amplitude model`: `modelo de amplitud de senal`
- `peak vibration amplitude`: `amplitud maxima de vibracion`
- `blast loading case`: `caso de carga de voladura`
- `source-to-receiver distance`: `distancia fuente-receptor`
- `maximum instantaneous charge`: `carga maxima instantanea`
- `scaled distance`: `distancia escalada`
- `explanatory variable`: `variable explicativa`
- `distance-MIC scenario grid`: `grilla de escenarios distancia-MIC`
- `empirical predictive quantile`: `cuantil predictivo empirico`
- `scenario time history`: `historia temporal de escenario`

Spanish accents are intentionally omitted in this ledger to keep repository
editing ASCII-only until the translation pass decides the file encoding policy.

## Open Gaps

- Decide whether to cite `ssel` methodology in this paragraph or reserve the
  citation for the paragraph that introduces model fitting and residual
  quantiles.
- The PPV conditional-improvement comparison remains deferred to the final
  result-validation stage.
- Candidate paragraph approved in
  `dev/research/blast-report/sections/CANDIDATE-amplitude-modelling-opening-20260706.md`
  on 2026-07-06, then revised on 2026-07-07 after style and contract audit.
  Revised P1 requires re-approval before migration.

## Validation

Forbidden implementation vocabulary checked against the candidate:

```text
pipeline workflow script helper runner package CSV JSON folder path software
manual not a physics model not pore pressure not liquefaction PLAXIS-compatible
spectral matching human comfort building damage
```

Result:

```text
No rejected terms appear in the candidate paragraph.
```

Structural validation:

```text
No heading is proposed for migration.
No equation is proposed for P1.
No public report file is edited by this ledger.
```
