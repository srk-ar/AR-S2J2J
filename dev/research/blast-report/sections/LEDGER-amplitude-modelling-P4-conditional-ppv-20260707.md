# LEDGER-amplitude-modelling-P4-conditional-ppv-20260707

## Section

P4: conditional multi-response formulation for PPV estimation using predicted amplitude responses.

## Report Purpose

Introduce the conditional PPV formulation only after P1-P3 have established the amplitude responses, residual-quantile estimates, and component PPA scenario targets.

The paragraph must describe the method as amplitude modelling, not as a result claim. It may state how the D/MIC explanatory variables are supplemented with estimated values of the other amplitude responses, and how predicted PPA responses can enter the PPV regressions. It must not claim an RMSE reduction until the official conditional-model comparison artifact is present and approved.

## Sources Read

Project source:

```text
scripts/manifest.json
scripts/runChain.R
data/summary/metrics.csv
```

Library source:

```text
/Users/averrik/Cloud/github/libraries/ssel/docs/articles/chain-regression.md
/Users/averrik/Cloud/github/libraries/ssel/docs/articles/ensemble-theory.md
/Users/averrik/Cloud/github/libraries/ssel/R/chain.R
```

Style source:

```text
/Users/averrik/Cloud/github/garage/style/technical-writing.md
/Users/averrik/Cloud/github/tools/psha/dev/SoT/LEDGER-srs-methodology-P7-modal-objective-20260702.md
/Users/averrik/Cloud/github/tools/psha/dev/SoT/CANDIDATE-srs-professional-report-chapter-20260703.md
```

## Exact Claims Allowed

- PPV can be estimated as a conditional amplitude response.
- The D/MIC explanatory variables for a response can be supplemented with estimated values of the remaining amplitude responses.
- The response being fitted is excluded from its own conditioning vector.
- Training-row conditioning quantities are out-of-fold predictions.
- Scenario-point conditioning quantities are predicted median responses at the scenario point.
- Predicted PPA-family responses can enter the PPV regressions as amplitude information.
- Training rows use out-of-fold conditioning values so the fitted response is not conditioned on its own measured value.

## Claims Not Allowed

- Do not state that PPV RMSE is reduced by conditioning on PPA.
- Do not report baseline-vs-conditional metrics.
- Do not claim the conditional model is the accepted final result until the official convergence and model-comparison outputs are present.
- Do not describe command-line execution, implementation directories, generated file names, or package internals in the public paragraph.
- Do not describe pore-pressure, deformation, liquefaction, or numerical model response.
- Do not introduce VMD, Wave3D, IMF attenuation, spectral matching, or PLAXIS framing.

## Equations Allowed

None for public migration from this ledger.

The earlier generic chain-regression equations are quarantined until an accepted conditional-model artifact is present. A future public paragraph must be written from the accepted project outputs and the exact `ssel` chain contract, not from generic regression notation.

## Equations Excluded

- Iterative update equations.
- Convergence or stopping equations.
- Generic conditional-mean equations.
- RMSE and R2 equations.
- Scenario acceleration scaling equation.
- Response-spectrum equations.
- Pore-pressure or liquefaction equations.

## Vocabulary Allowed

- `conditional amplitude response`
- `explanatory variable`
- `conditioning variable`
- `remaining amplitude responses`
- `out-of-fold prediction`
- `scenario point`
- `predicted median response`
- `PPA-family response`
- `PPV regression`
- `amplitude information`
- `out-of-fold conditioning value`

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
- `file`
- `chain feature`
- `ranger`
- `caret`
- `PLAXIS-compatible`
- `spectral matching`
- `VMD`
- `Wave3D`
- `IMF`
- `pore pressure`
- `liquefaction`
- `RMSE reduction`

Rejected terms may appear in this ledger only to define exclusions.

## Candidate Public Paragraph Or Section

No active public paragraph is approved in this ledger.

## Candidate Translation Terminology

Do not translate P4 until an English paragraph is approved.

Terminology likely needed after approval:

- `conditional amplitude-response problem`: `problema de respuesta de amplitud condicional`
- `explanatory variable`: `variable explicativa`
- `conditioning variable`: `variable de condicionamiento`
- `remaining amplitude responses`: `respuestas de amplitud restantes`
- `out-of-fold prediction`: `prediccion fuera de pliegue`
- `scenario point`: `punto de escenario`
- `predicted median response`: `respuesta mediana predicha`
- `PPA-family response`: `respuesta de la familia PPA`
- `PPV regression`: `regresion PPV`
- `amplitude information`: `informacion de amplitud`
- `out-of-fold conditioning value`: `valor de condicionamiento fuera de pliegue`

Spanish accents are intentionally omitted in this ledger to keep repository editing ASCII-only until the translation pass decides the file encoding policy.

## Open Gaps

- The official baseline-vs-conditional PPV comparison remains deferred because no `data/iter/convergence.csv` artifact is present in the current working tree.
- A later results ledger must provide baseline and conditional metrics before any public claim about RMSE reduction.
- The iterative update, active-set selection, stopping criteria, and response-specific best-iteration stitch should be handled in a separate paragraph only if those details remain necessary for the professional report and are supported by accepted project outputs.

## Validation

Forbidden implementation and unapproved-result vocabulary checked against the candidate:

```text
pipeline workflow script helper runner package CSV JSON folder path software manual file chain feature ranger caret PLAXIS-compatible spectral matching VMD Wave3D IMF pore pressure liquefaction RMSE reduction
```

Result:

```text
No active public paragraph remains in this ledger.
```

Structural validation:

```text
No heading is proposed for migration.
No public equation block is proposed for migration from P4.
No public report file is edited by this ledger.
```

Status:

```text
Deactivated as public candidate on 2026-07-07 after contract audit because the current working tree does not contain the accepted conditional comparison artifact needed to establish the public method/result boundary. Keep as technical ledger only until accepted conditional model artifacts exist.
```
