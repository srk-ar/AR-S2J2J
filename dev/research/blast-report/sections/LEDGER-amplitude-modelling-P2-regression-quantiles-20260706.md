# LEDGER-amplitude-modelling-P2-regression-quantiles-20260706

## Section

P2: regression formulation and predictive quantiles for signal-amplitude
responses.

## Report Purpose

Define how fitted amplitude estimates and out-of-fold residual offsets are combined to obtain scenario amplitude quantiles. This paragraph follows P1, which defines the response family and explanatory variables.

P2 should introduce the regression formulation and empirical predictive
quantiles at methodology level. It must not discuss model-performance results,
conditional PPV improvement, scenario scaling equations, or implementation
artefacts.

## Sources Read

Project source:

```text
scripts/runModel.R
scripts/runPost.R
data/summary/residuals_oof.csv
data/summary/prediction_quantiles.csv
data/export/predictions.csv
```

Library source:

```text
/Users/averrik/Cloud/github/libraries/ssel/vignettes/ensemble-theory.Rmd
/Users/averrik/Cloud/github/libraries/ssel/docs/articles/pipeline.md
/Users/averrik/Cloud/github/libraries/ssel/R/model.R
/Users/averrik/Cloud/github/libraries/ssel/R/auditQuantiles.R
/Users/averrik/Cloud/github/libraries/ssel/R/oofEnsemble.R
```

Style source:

```text
/Users/averrik/Cloud/github/garage/style/technical-writing.md
/Users/averrik/Cloud/github/tools/psha/dev/SoT/LEDGER-srs-methodology-P5-response-spectrum-operator-20260702.md
/Users/averrik/Cloud/github/tools/psha/dev/SoT/LEDGER-srs-methodology-P7-modal-objective-20260702.md
```

## Exact Claims Allowed

- Each amplitude response is estimated with a supervised regression model.
- The fitted model estimates each amplitude response at each D/MIC scenario point.
- Cross-validated out-of-fold residuals are used to estimate empirical residual offsets.
- Scenario amplitudes are reported as the fitted amplitude plus the empirical residual offset at the requested quantile level.
- The same response definition is used for PPV, PPA, and their L, T, and V
  component quantities.

## Claims Not Allowed

- Do not report RMSE, R2, overfit diagnostics, or final model ranking.
- Do not state that PPV error is reduced by conditioning on PPA.
- Do not introduce the iterative chain model in this paragraph.
- Do not describe training folders, exported tables, model files, helper
  functions, package internals, or command-line execution.
- Do not describe pore-pressure, deformation, or liquefaction response.

## Equations Allowed

Residual-quantile notation:

$$
\widehat{Y}_p(D,Q)
= \max\{0,\widehat{Y}(D,Q)+\widehat q_p(r)\},
\qquad
r_i = Y_i - \widehat{Y}^{\mathrm{OOF}}_i
$$

where:

```text
Y                         amplitude response;
D                         source-to-receiver distance;
Q                         maximum instantaneous charge;
\widehat{Y}(D,Q)          fitted amplitude at the scenario point;
r_i                       out-of-fold residual for training record i;
\widehat q_p(r)           empirical residual quantile at level p.
```

The lower bound at zero is project-specific and follows the response bounds in `scripts/manifest.json`.

## Equations Excluded

- RMSE equation.
- R2 equation.
- Chain-regression update equations.
- Scenario scaling equation.
- Pore-pressure or liquefaction equations.

## Vocabulary Allowed

- `amplitude response`
- `supervised regression model`
- `fitted amplitude`
- `explanatory variable`
- `residual variability`
- `cross-validated`
- `out-of-fold residual`
- `empirical residual offset`
- `scenario amplitude`
- `predictive quantile`
- `PPV`
- `PPA`
- `L, T, and V component quantity`

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
- `training directory`
- `export file`
- `ranger`
- `caret`
- `chain`
- `PLAXIS-compatible`

Rejected terms may appear in this ledger only to define exclusions.

## Candidate Public Paragraph Or Section

For each retained amplitude response $Y$, the fitted model first estimates the amplitude at each scenario point and then applies an empirical offset derived from cross-validated out-of-fold residuals. In compact notation,

$$
\widehat{Y}_p(D,Q)
= \max\{0,\widehat{Y}(D,Q)+\widehat q_p(r)\},
\qquad
r_i = Y_i - \widehat{Y}^{\mathrm{OOF}}_i .
$$

Here $\widehat{Y}(D,Q)$ is the fitted amplitude at the scenario point, $r_i$ is the residual between a measured training response and its out-of-fold prediction, and $\widehat q_p(r)$ is the empirical residual quantile at level $p$. The project reports scenario amplitudes at $p=0.50$, $0.90$, and $0.95$ using the same PPV, PPA, and component definitions used for the measured records.

## Candidate Translation Terminology

Do not translate P2 until the English paragraph is approved.

Terminology likely needed after approval:

- `amplitude response`: `respuesta de amplitud`
- `supervised regression model`: `modelo de regresion supervisada`
- `fitted amplitude`: `amplitud ajustada`
- `explanatory variable`: `variable explicativa`
- `residual variability`: `variabilidad residual`
- `cross-validated`: `validado cruzadamente`
- `out-of-fold residual`: `residual fuera de pliegue`
- `empirical residual offset`: `desplazamiento residual empirico`
- `scenario amplitude`: `amplitud de escenario`
- `predictive quantile`: `cuantil predictivo`

Spanish accents are intentionally omitted in this ledger to keep repository
editing ASCII-only until the translation pass decides the file encoding policy.

## Open Gaps

- Decide whether this paragraph should cite `ssel` or whether the citation
  belongs in a later methods appendix or footnote.
- Decide whether the final chapter should retain the regression equation in
  the main text or move it to a compact mathematical note.
- Candidate paragraph approved in
  `dev/research/blast-report/sections/CANDIDATE-amplitude-modelling-opening-20260706.md`
  on 2026-07-06, then revised on 2026-07-07 after style and contract audit.
  Revised again on 2026-07-07 to replace generic conditional-mean notation
  with the project-supported residual-quantile equation. Revised P2 requires
  re-approval before migration.

## Validation

Forbidden implementation vocabulary checked against the candidate:

```text
pipeline workflow script helper runner package CSV JSON folder path software
manual training directory export file ranger caret chain PLAXIS-compatible
```

Result:

```text
No rejected terms appear in the candidate paragraph.
```

Structural validation:

```text
No heading is proposed for migration.
One regression equation is proposed for P2.
No public report file is edited by this ledger.
```
