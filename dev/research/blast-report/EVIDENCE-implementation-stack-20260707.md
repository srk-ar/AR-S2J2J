# EVIDENCE-implementation-stack-20260707

Append-only evidence. Consolidated implementation facts gathered on 2026-07-07 to hydrate the blast-report methodology chapters. Sources are code and package documentation, classified as internal technical sources per RESEARCH-LEDGER-HARNESS.

## ssel — learning model (internal technical source)

Package: `~/github/libraries/ssel` v0.1.2, "Semi-Supervised Ensemble Learning". Math is documented in `vignettes/ensemble-theory.Rmd` and `vignettes/chain-regression.Rmd`; both match the equations already in the reading draft.

- Regression model: `Y | x = eta_Y(x) + eps_Y`; two estimates: conditional mean from the ensemble fit, residual distribution from cross-validated out-of-fold (OOF) residuals.
- Base learners K=3: random forest (`ranger`), gradient boosting (`gbm`), MARS (`earth`), all trained through one caret CV wrapper with identical folds and grids.
- Ensembles: RMSE-weighted (w_k prop 1/RMSE_k) and R2-weighted (w_k prop R2_k), weights normalized; export selector `M$model$ensemble` (default `ensemble.RMSE`).
- CV: 5 folds, grid resolution 10 points per tunable parameter, RMSE-minimizing grid point, refit on full training split; OOF predictions retained for weights and residuals.
- Predictive quantiles: `Q_p(x) = clamp[ ens(x) + q_p(r) ]` with empirical residual quantiles at p = 0.50, 0.90, 0.95 and physical bounds clamp (this is the `max{0, ...}` in the draft).
- Ambiguity decomposition (Krogh-Vedelsby) justifies the ensemble; overfit audit = relative optimism (CV RMSE vs in-sample RMSE) in `overfit.csv`.
- Multi-response chain (`chainPipeline()`): regressor chain generalized to iterative Jacobi (parallel, default) or Gauss-Seidel sweeps; chain features are previous-iteration OOF predictions for training rows and previous-iteration grid medians for scenario rows (suffix `.o`); Boruta-style shadow or fixed-threshold active-set gating; stopping by scale-free delta, mean-R2 improvement strikes, divergence strikes, maxIter cap; final exports stitched per response at its best iteration (iteration 0 = no-chain baseline is a valid winner).
- Per-response dataset selection: lowest OOF ensemble RMSE across declared feature sets (QS vs QDS datasets in this project).

## gmsp — record processing (internal technical source)

Package: `~/github/libraries/gmsp` (installed 0.4.7 for the production run; 0.5.x is current dev). Applied contract audited in `scripts/dev/sot/AUDIT-signal-processing-gmsp-2026-07-06.md`.

- Canonical bundle: velocity records read from kashimaDB (`readTS(kind="VT")`), `VT2TS()` derives AT/VT/DT; materialized as TSL/TSW.
- EEMD: `TS2IMF(method="eemd")`, K.imf=10; retention rule discards IMF1 and last two IMFs; filtered AT rebuilt to VT/DT with `AT2TS(isRaw=FALSE)`.
- Spectra: `TSL2PS(output="PSW", D50=TRUE, nTheta=180)`; PSA/PSV/SD per component plus median rotated horizontal (D50).
- IMs: `TSL2IM()` — PGA/PGV/PGD, AI, CAV, CAV5, durations; materialized IMW.csv.
- Scaling: `.scaleAT()` — per-component factor = G * predicted PPA / source component peak; units bridged via `gmsp:::.getSF()` and `data/domains/units.json` (mm/s, g).
- Rotation: covariance-eigenvector rotation of scaled L/T into H1/H2; V renamed UP.
- Audit checks: `UP.ok` (vertical target match), `energy.ok` (quadratic horizontal energy preserved, tol 0.001), `PGA.pos`; June 2026 F125 run: 30/36 PASS, 6 energy failures marginal at the strict tolerance.

## Executed pipeline (project source of truth)

Runner chain per `scripts/README.md`: runParse -> runData -> runModel -> runChain -> runPost -> runGMSP -> runScenarios -> runAudit -> runPlots -> runSelect(+buildIndex,+buildPlots).

- Training data: kashimaDB ISEE records parsed to `data/blastDB.csv`; datasets QS/QDS under `data/datasets/`.
- Model runs: `ssel::modelPipeline()` then `ssel::chainPipeline()` (maxIter=10, tol=0.01, patience=10, jacobi); exports `data/export/predictions.csv` with D, MIC, p, ppaL, ppaT, ppaV.
- Signal cache: `data/gmsp/{F50,F80,F125}.Qo.Do{,.eemd}` (~2.1 GB).
- Scenarios: D grid 150-400 m step 50, MIC grid 150-400 kg step 50, p=0.90, D50=TRUE, nTheta=180; 72 scenario folders (36 F80 + 36 F125) under `data/records/scenarios/`.
- Audit: `data/audit/<ScenarioID>.csv` + `summary.csv` (InputID F125.Qo.Do.eemd, tol=0.001).
- Client deliverable: `data/records/plaxis/` — 602 acceleration time-series CSVs (t, s @ 0.004 s), F80 family only, p=0.90, H1 component only, D in [0-300] m, 25 records per scenario ranked by PGV descending; companion IMW.csv, unique.csv, runSelect.json sidecar, review HTML.

## Draft-vs-implementation checks pending

- RMSE values quoted in the draft (PPA 0.0379 resultant; 0.0264/0.0236/0.0220 L/T/V; PPV 2.8077; 1.7609/2.0186/1.5058) must be verified against `data/summary/metrics.csv` (bounded read) before publication.
- Draft says selection "retains a fixed number of records per matching scenario"; actual run: n=25, F80 only, H1 only, D<=300 m. Results chapter must state the exact executed configuration.
- Conditional PPV (P4) remains quarantined: no accepted baseline-vs-conditional artifact; candidate source is `data/iter/convergence.csv` stitched metrics, not yet approved.

## Stage-2 boundary (IDUAPRIEM)

Stage 2 will correct/scale measured IMPALA records by IDUAPRIEM attenuation (Wave3D/VMD modal-transfer concept). Reserved context: `scripts/dev/sot/HANDOFF-agent-wave3d-vmd-modal-attenuation-2026-07-06.md`. Out of scope for the stage-1 report chapters.
