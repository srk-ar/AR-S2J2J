# ARTIFACT-conditional-ppv-comparison-20260707

Baseline-versus-conditional amplitude-model comparison (experiment E1, Decision 3 of `dev/plan/blast-report/active.md`). Append-only evidence; not public prose.

## Definitions

- **Baseline**: iteration-0 model, base features only (QS: MIC, LnQ, iQ, SD; QDS: adds D, LnD, iD), ranger-only ensemble (`ensemble.RMSE`), 5-fold CV out-of-fold metrics, seed 42, bounds [0, Inf). Regenerated 2026-07-07 in sandbox `/private/tmp/blast-baseline-E1/` with `ssel::modelPipeline()` on copies of `data/datasets/{QS,QDS}.csv`.
- **Conditional**: production `data/summary/metrics.csv` (2026-05-21), the per-response best-iteration stitch of the `chainPipeline` run (Jacobi, maxIter 10, suffix `.o`). Predictor counts prove which rows are conditional: p=14 (QDS) / p=11 (QS) include the 7 chain features; p=7 / p=4 are iteration-0 (no chain).
- Best row per response (minimum RMSE across datasets), method `ensemble.RMSE`. Units: PPV family mm/s, PPA family g.

## Comparison

| response | units | baseline RMSE (dataset) | conditional RMSE (dataset, p) | RMSE reduction | baseline R2 | conditional R2 |
|---|---|---|---|---|---|---|
| ppv  | mm/s | 2.8512 (QS)  | 2.8077 (QDS, 14) | 1.5%  | 0.540 | 0.552 |
| ppvL | mm/s | 1.7759 (QS)  | 1.7609 (QS, 11)  | 0.8%  | 0.513 | 0.521 |
| ppvT | mm/s | 2.0347 (QS)  | 2.0186 (QS, 11)  | 0.8%  | 0.478 | 0.483 |
| ppvV | mm/s | 1.5583 (QDS) | 1.5058 (QS, 4)   | 3.4% (*) | 0.514 | 0.541 |
| ppa  | g    | 0.0592 (QDS) | 0.0379 (QDS, 14) | 36.0% | 0.680 | 0.867 |
| ppaL | g    | 0.0285 (QS)  | 0.0264 (QS, 11)  | 7.3%  | 0.526 | 0.590 |
| ppaT | g    | 0.0351 (QS)  | 0.0236 (QS, 11)  | 32.9% | 0.789 | 0.902 |
| ppaV | g    | 0.0331 (QS)  | 0.0220 (QDS, 14) | 33.5% | 0.712 | 0.870 |

(*) The production ppvV winner is itself an iteration-0 row (p=4, no chain features), so its 3.4% delta against the regenerated baseline is pure reproduction noise, not a conditioning effect. It sets the noise floor of this comparison at roughly 3-4%.

## Reproduction caveats

- Current `data/datasets/` files contain 220 training rows; the May 2026 production run used 222 (metrics n column). The datasets were rebuilt after the model run; the two-row difference contributes to the noise floor.
- Regeneration used currently installed ssel 0.1.2, ranger 0.18.0, caret 7.0.1, which may differ from the May 2026 production versions.
- Baseline and conditional therefore come from different dataset builds and possibly different package versions; the comparison is diagnostic, not bit-reproducible.

## Verdict

- **PPV RMSE-reduction claim: NOT supported for public prose.** Apparent PPV-family gains from conditioning (0.8-1.5%) are below the ~3-4% reproduction noise floor. The P4 quarantine stands; the report must not claim that conditioning on PPA-family estimates reduces PPV RMSE.
- **PPA-family improvement: large and well above noise** (33-36% RMSE reduction for ppa, ppaT, ppaV; R2 gains of ~0.11-0.19). If a public claim about the multi-response chain is wanted, the defensible statement is that the conditional formulation materially improved the PPA-family out-of-fold errors, with the caveat that the baseline was regenerated (dataset/version drift).
- The draft sentence calling the production metrics "independent-model metrics" is wrong: `data/summary/metrics.csv` is the stitched chain output, conditional for every response except ppvV. C03 prose must be corrected accordingly.

## Traceability

- Baseline: `/private/tmp/blast-baseline-E1/data/summary/metrics.csv` (sandbox, disposable; regenerate with `/private/tmp/blast-baseline-E1/run.R`).
- Conditional: `data/summary/metrics.csv` (production, 2026-05-21).
- Runner configs: `scripts/runModel.R`, `scripts/runChain.R`, `scripts/manifest.json`.
