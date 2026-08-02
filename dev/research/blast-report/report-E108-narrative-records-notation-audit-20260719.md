# E108 — Narrative, Records And ML Notation Audit

Date: 2026-07-19

Status: read-only evidence complete except for the separate spectral-control
plot verdict; awaiting user veto before public edits

Repository: `/Users/averrik/Cloud/github/projects/AR-S2J2J.X`

## Objective

Audit the Blast report title architecture, introductory framing, Records
executive text, Table 2.1 and the core ML notation without modifying public
chapters or producing new data. The audit must distinguish random variables,
realizations, fitted functions, OOF predictions, observed residuals and
empirical predictive quantiles. It must also prove whether each proposed
notation change preserves the implemented operation.

## Authority

1. Current SSEL implementation.
2. Blast runners, manifest and produced artifacts.
3. SSEL documentation only where it agrees with the implementation.
4. Current Blast prose as the object being audited, never as mathematical
   authority.

AR-M2P2B.R (Brasil) is obsolete and mathematically ambiguous by user ruling.
It does not control any equation, distribution or notation in this audit.

## Prohibitions Observed

- No public chapter, summary, title, builder, pipeline or manifest was edited.
- No R process, model, chain, signal-processing run or render was executed.
- SSEL and gmsp were read only.
- No new data or plot input was generated.
- No package fix is proposed under this report-writing task.

## Narrative Architecture Verdict

The current sequence is correct and does not require reorganization:

```text
instrumental histories + D/Q metadata
  -> multi-response PPV/PPA prediction
  -> scenario demand histories
  -> pending dynamic geotechnical response
  -> pending exceedance/failure probability
```

Three terms must remain distinct:

- **integrated study model**: the complete sequence;
- **multi-response PPV/PPA predictive model**: the ML component;
- **dynamic geotechnical model of the section**: the pending deformation
  analysis.

### Recommended title family

| Level | Current | Recommended candidate |
|---|---|---|
| Cover | Ground Vibration Attenuation Model / Blast-Induced Dynamic Demand | Modelo integrado de demanda por voladuras para evaluación dinámica y confiabilidad geotécnica |
| Part introduction | Demanda sísmica inducida por voladuras | Formulación y alcance del modelo integrado |
| Records | Base de registros de vibración | Datos de vibración: historias instrumentales y observaciones de amplitud |
| ML | Modelo de predicción de amplitudes | Predicción ML multirrespuesta de PPV y PPA |
| Scenarios | Generación y verificación de escenarios de voladura | Construcción y verificación de escenarios de demanda |
| Risk | Análisis de riesgos | Formulación de confiabilidad geotécnica condicionada por escenario |

The introductory H2 candidates, without changing the current organization,
are:

1. `Contexto de la demanda por voladuras`;
2. `Objetivo y alcance del estudio`;
3. `Secuencia analítica`, only if it explains dependencies instead of repeating
   the table of contents.

`Análisis de riesgos` is rejected while no dynamic-response results exist. The
last H2 can be `Estado de la evaluación` rather than `Resultados` until that
analysis is executed.

## Records Verdict

### Instrumental population and metadata

- The source contains 86 three-component particle-velocity records, each with
  L/T/V: 86 triplets.
- The 258 rows are component histories, not a second population.
- D and Q are contractor metadata available for 68 records.
- The Records chapter counts those 68 in `META.csv`; the ML pipeline constructs
  its population independently from `blastDB.csv`. Equal cardinality does not
  prove one-to-one identity. Do not claim identity until a key crosswalk exists.
- The 18 records without D/Q already belong to the instrumental population;
  they do not “expand” it.

Recommended conceptual sentence:

> La base contiene 86 registros tridimensionales de velocidad; 68 disponen
> además del par de metadatos de distancia fuente–receptor y carga instantánea
> máxima reportado por el contratista.

The ML population must be introduced separately afterward.

### Directions

- L/T/V: instrumental longitudinal, transverse and vertical components.
- H1: horizontal analysis direction with greatest acceleration variance after
  component scaling.
- H2: orthogonal horizontal direction.
- UP: vertical analysis direction.

H1/H2/UP must be defined at their first executive use, not only later in the
Scenarios methodology.

### Metrics and consumers

AI, CAV, CAV5 and significant durations are calculated and retained. They are
not active ML features, do not set the scenario scale and do not govern the
current record selection; the current selection configuration ranks PGV.
Therefore they may remain defined in detailed methodology, but the executive
summary must not present them as decisive outputs or invent a consumer.

The current spectral product is PSA pre/post VMD for all 86 records. It is not
spectral matching and is not a CAV/CAV5 selection diagnostic.

## Normalization, Scaling And Table 2.1

`scripts/runGMSP.R` calls `.buildTS()` with its default `NORMALIZE=FALSE`, then
`.filterTS()`. The processed source therefore preserves physical amplitudes.
During scenario generation `.scaleAT()` calculates

\[
\lambda_{r,c}
=\frac{\operatorname{PPV}^{*}_{c}}{\operatorname{PGV}_{r,c}},
\qquad
\begin{bmatrix}a'_{r,c}(t)\\v'_{r,c}(t)\\d'_{r,c}(t)\end{bmatrix}
=\lambda_{r,c}
\begin{bmatrix}a_{r,c}(t)\\v_{r,c}(t)\\d_{r,c}(t)\end{bmatrix}.
\]

Dividing first by PGV and later multiplying by the target PPV is an algebraic
decomposition of this operation. A unit-amplitude library is not materialized.

Only velocity would have a unit peak in that conceptual decomposition:

\[
\max_t|\widetilde v_{r,c}(t)|=1,
\qquad
\max_t|\widetilde a_{r,c}(t)|
=\frac{\operatorname{PGA}_{r,c}}{\operatorname{PGV}_{r,c}}\ne1.
\]

The acceleration ratio has units of inverse time. PPA must not equal one
because PPV is the scaling anchor; independently normalizing acceleration
would break kinematic coherence.

Table 2.1 reads `F125.Qo.Do.vmd/IMW.csv` and correctly reports physical PPA in
g and PPV in mm/s using p16/p50/p84. It is not a table of unit parameters.

Recommended caption:

> Amplitudes físicas de las historias procesadas antes del escalamiento.

Recommended minimal explanation:

> La tabla resume las amplitudes físicas de la biblioteca de historias
> procesadas, antes de asignar las condiciones de escenario. Durante la
> generación se calcula, para cada registro y componente, el factor
> \(\lambda_{r,c}=\operatorname{PPV}^{*}_{c}/\operatorname{PGV}_{r,c}\), que
> se aplica en común a aceleración, velocidad y desplazamiento. La operación
> fija la velocidad pico en la PPV objetivo; no fija una PPA unitaria.

## SSEL And Blast Scale Contract

SSEL fits the response scale supplied by the application. Blast supplies
rounded decimal-log responses through `buildDomains.R` and applies the inverse
base-10 transformation in `postProcess()` according to `manifest.json`.
Consequently SSEL does not authorize introducing a Normal distribution,
lognormality or a sigma parameter into the Blast chapter.

The predictive offsets are empirical type-7 quantiles of OOF residuals,
calculated by response and dataset in `auditQuantiles.R`. They are added in the
modeled log10 scale before the physical inverse transform.

## Required Notation Matrix

Index convention imposed by the user:

- \(h=1,\ldots,m\): response type or component (for example PPV-L or PPA-V);
- \(j=1,\ldots,n_h\): observation;
- \(k\in\mathcal K_h\): learner family participating for response \(h\);
- \(t\): chain iteration;
- \(p\): predictive-quantile level.

Random responses carry no observation index. They are written
\(Y^{(h)}\) and \(Z^{(h)}=\log_{10}Y^{(h)}\). Their observed realizations are
\(y_j^{(h)}\) and \(z_j^{(h)}\). The random response vector is
\(\mathbf Y=(Y^{(1)},\ldots,Y^{(m)})^{\mathsf T}\); the observed vector for row
\(j\) is \(\mathbf y_j\). Thus \(Z_j\) is explicitly prohibited when \(j\)
means an observation.

| Equation / current location | Current symbol | Current role/problem | Proposed symbol | Proposed role / definition | Distribution or definition | Invariant operation | Affected public files | Open gate |
|---|---|---|---|---|---|---|---|---|
| log response, `model.es.md:42-52` | \(Z_j=\log_{10}Y_j\) | Observation index attached to random-variable typography | \(z_j^{(h)}=\log_{10}y_j^{(h)}\), \(y_j^{(h)}>0\) | Physical observation and modeled-scale realization for response type \(h\) | Deterministic transform of observation \(j\) | Same base-10 transform executed by Blast | model body and summary | Decide whether six-decimal rounding needs a note |
| same | \(Y_j,Z_j\) | Random responses and realizations are conflated | \(Y^{(h)}\), \(Z^{(h)}=\log_{10}Y^{(h)}\) | Physical and modeled-scale random responses of type \(h\) | \(Z^{(h)}\mid\mathbf X=\mathbf x\overset d=\eta_h(\mathbf x)+\varepsilon^{(h)}\), \(\varepsilon^{(h)}\sim F_h\) | Semantic separation only | model body | No Normal or sigma |
| feature vector, `model.es.md:27-38` | \(D,Q,S,\mathbf x(D,Q)\) | Uppercase symbols used for realized inputs and grid values | \(d_j,q_j,s_j\), \(\mathbf x_j=\mathbf x(d_j,q_j)\); grid \(\mathbf x(d,q)\) | Realized covariates; reserve \(\mathbf X\) for random feature vector | \(s=d/\sqrt q\) and same eight entries | Same feature construction | model plus dependent scenario/risk notation | Distribution of \(\mathbf X\) is not modeled |
| conditional model, `model.es.md:47-52` | \(\eta_j\) called estimated component | Observation index used where response type is intended; population function and estimator conflated | \(\eta_h(\mathbf x)\), \(\widehat\eta_h(\mathbf x)\) | Regression function and fitted estimator for response type \(h\) | SSEL documents \(\eta_h(\mathbf x)=E[Z^{(h)}\mid\mathbf X=\mathbf x]\) | Same fitted prediction target | model body/summary | Do not call it median |
| same | \(\varepsilon_j\) called residual | Random error confused with observed difference and indexed as an observation | \(\varepsilon^{(h)}\sim F_h\) | Unobservable random error for response type \(h\) | Nonparametric family; conceptual zero conditional mean only if retained from SSEL theory | No numerical change | model body | Code does not test mean-zero or estimate sigma |
| OOF residual, `model.es.md:94-104` | \(r_{ij}^{(t)}\) | Indices do not identify response type versus observation | \(r_j^{\mathrm{OOF},(h,t)}=z_j^{(h)}-\widehat z_j^{\mathrm{OOF},(h,t)}\) | Observed OOF residual for observation \(j\), response \(h\), iteration \(t\) | Empirical residual sample by response/dataset/iteration | Exact `oofEnsemble()` operation | model body/summary | None |
| weighted ensemble, `model.es.md:56-70` | \(\widehat Z_j(\mathbf x)\) | Observation index and uppercase random-variable typography used for a deterministic prediction | \(\widehat z^{(h)}(\mathbf x)=\sum_{k\in\mathcal K_h}\widehat w_{hk}\widehat f_{hk}(\mathbf x)\) | Numeric fitted prediction for response \(h\); weights estimated from OOF RMSE | \(\widehat w_{hk}\propto1/\operatorname{RMSE}_{hk}^{\mathrm{OOF}}\) | Intended SSEL formula; correct for OOF reconstruction | model body/summary | Blocked for current grid by MATH-B006 |
| OOF ensemble evidence | implicit | Fold exclusion and prediction class hidden | \(\widehat z_{j,k}^{\mathrm{OOF},(h)}=\widehat f_{hk}^{(-\kappa(j))}(\mathbf x_j)\) | Learner-k prediction for observation j from fit excluding its fold | Define \(\kappa(j)\) as held-out fold | Same OOF values | model body if needed | Avoid excessive executive detail |
| chain, `model.es.md:76-88` | \(\widehat Z_j^{(t)}\), train described as point OOF | Observation index used as response index; uppercase and wrong train/grid distinction | Grid \(\widehat z^{(h,t)}(\mathbf x)=\widehat f_h^{(t)}(\mathbf x,\widehat{\mathbf z}_{0.50,-h}^{(t-1)}(\mathbf x))\); train uses \(\widehat{\mathbf z}_{j,0.50,-h}^{\mathrm{OOF},(t-1)}\) | Deterministic predictions; both regimes use empirical p50, with OOF values for training | Previous point prediction plus \(\widehat q_{h,0.50}\) | Exact `aggregateResponses()` + `.augmentDatasetsChain()` behavior | model body and summary | Current SSEL vignette simplifies train incorrectly |
| OOF support, `model.es.md:88` | \(N_{j,t}\) | Observation index used as response index; deterministic count written uppercase | \(n_{h,t}\) | Number of valid OOF observations for response \(h\), iteration \(t\) | Cardinality of evaluated set | Same denominator and sum | model body/results summary | None |
| selection, `model.es.md:88-90` | \(R_{j,t}^{2,\mathrm{OOF}},t_j^*\) | Observation index used as response index | \(\widehat R_{h,t}^{2,\mathrm{OOF}}\), \(t_h^*=\arg\max_t\widehat R_{h,t}^{2,\mathrm{OOF}}\) | OOF statistic and chosen iteration for response type \(h\) | Squared Pearson correlation on valid observations | Exact per-response stitch | model body/summary | None for current run |
| predictive quantiles, `model.es.md:97-104` | \(\widehat q_{j,p}^{(t)},\widehat Y_{j,p}^{(t)}\) | Observation index used as response index; uppercase physical output suggests random response | \(\widehat q_{h,p}^{(t)}\), \(\widehat y_p^{(h,t)}(d,q)=10^{\widehat z^{(h,t)}(\mathbf x(d,q))+\widehat q_{h,p}^{(t)}}\) | Sample residual quantile and physical quantile prediction for response \(h\) | Empirical type-7 residual quantile; no parametric family | Exact Blast inverse transform | model body/summary/results captions | No conditional-coverage guarantee |

## Confirmed MATH-B006 Defect In The Current Blast Artifacts

Blast passes eight responses and one dataset QDS in one SSEL call. During Stage
2, `trainRegressionModel.R` rebuilds `R2` and `RMSE` per response/dataset cell.
Stage 3 then predicts every response but does not rebuild those objects for the
current cell.

A CSV-only reconstruction was performed on existing
`data/iter/summary_0` through `summary_3`, without executing R or retraining.
For every response in every iteration, the recorded grid
`ensemble.RMSE` equals the weighted combination formed with the **ppvV** RMSE
weights to approximately \(10^{-14}\). It does not generally equal the
combination formed with that response's own weights; the discrepancy reaches
approximately \(4.7\times10^{-2}\) in log10 scale.

### Proven blast radius

- OOF residuals, OOF metrics and empirical residual quantiles remain
  response-specific because `oofEnsemble()` rebuilds weights by cell.
- Training chain features are based on response-specific OOF-p50 values.
- Grid `response_long.csv`, `Yo.csv`, grid rows of `predictions.csv` and
  `audit.csv`, and subsequent grid-p50 chain features are affected.
- Dataset-selection differences do not affect this run because only QDS exists.
- `postProcess()` does consume the affected grid point predictions before
  adding quantile offsets and applying \(10^z\).

Therefore the notation family can be approved conceptually, but the weighted
ensemble equation cannot be claimed as an exact description of the current
E96-R1b surfaces. SSEL requires a separately authorized production audit/fix
and Blast requires regenerated artifacts before that correspondence can close.

## Provenance Of Current Equations

`_chapters/model.es.md` is modified and `_chapters/model.summary.es.md` is
untracked. The committed E69 seed contained only two introductory paragraphs.
The current equations were introduced by the E69/E80 report-writing lineage,
using the Map-B prototype and subsequent editorial revisions. They are not
original user text and are not a verbatim SSEL source. Git does not identify an
individual sub-agent for the uncommitted working-tree text, so no finer author
claim is made.

## Rejected Spectral-Filler Plot And Legacy Inventory

The user rejected the `F125.Qo.Do` versus `F125.Qo.Do.vmd` plot as irrelevant
filler. It is not to be renamed or defended. It must be removed from the public
Records results after the edit gate opens.

The historical trace is now closed. The Signal Processing section of both the
tracked `ppt.qmd` and the historical `ppt.html` was an explicit placeholder;
there was no completed Records plot set in that RevealJS presentation. No
missing public EDA builder was found in legacy or SoT.

The old scripts `plotTS.R`, `plotPSA.R`, `plotIMF.R` and
`_fig/plotTS_all.R` are not candidates for promotion. They use obsolete EEMD
products, arbitrary individual records, or recalculate spectra. They cannot be
used as evidence of a representative population and do not satisfy the
builder-only-consumer boundary.

The useful historical presentation products are confined to the existing ML
and scenario families: PPV demand curves, observed-versus-OOF predictions,
OOF residuals, performance metrics and scenario audit. These stay with their
semantic owners. A future Records EDA, if approved, must be designed explicitly
from existing audited products (PPA/PPV distributions by component and source,
D--Q coverage and metadata completeness); it is not a recovery operation and
does not authorize a new producer or pipeline.

The rejected spectral plot only compared an already processed product with
the incremental VMD/IMF1-removal product. It could not quantify the full change
from instrumental velocity histories to delivered signals because the required
intermediate products are not materialized. This confirms removal, not
renaming.

## Gate Before Public Editing

Present to the user:

1. title family;
2. Records wording and Table 2.1 correction;
3. notation matrix;
4. confirmed MATH-B006 blast radius;
5. final spectral-control verdict.

Only approved items may then be migrated to public chapters. MATH-B006 cannot
be resolved by editorial wording.
