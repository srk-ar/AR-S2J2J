# CANDIDATE-amplitude-modelling-opening-20260706

## Objective

Assemble the opening signal-amplitude modelling section from approved-style
P1-P2 ledgers, without editing `_chapters/`.

## Source Ledgers

```text
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P1-response-surface-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P2-regression-quantiles-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P3-ppa-scenario-targets-20260707.md
```

## Candidate Public Section

The signal-amplitude model estimates peak vibration amplitudes for blast loading cases indexed by source-to-receiver distance and maximum instantaneous charge (MIC). The retained response set includes peak particle velocity (PPV) and peak particle acceleration (PPA) as scalar amplitudes and as L, T, and V component amplitudes. The fitted models use MIC, distance, scaled distance, and logarithmic or reciprocal transformations of MIC and distance as explanatory variables. They are evaluated on the distance-MIC scenario grid, and the component PPA quantiles provide the acceleration-amplitude targets used later to generate scenario time histories.

For each retained amplitude response $Y$, the fitted model first estimates the amplitude at each scenario point and then applies an empirical offset derived from cross-validated out-of-fold residuals. In compact notation,

$$
\widehat{Y}_p(D,Q)
= \max\{0,\widehat{Y}(D,Q)+\widehat q_p(r)\},
\qquad
r_i = Y_i - \widehat{Y}^{\mathrm{OOF}}_i .
$$

Here $\widehat{Y}(D,Q)$ is the fitted amplitude at the scenario point, $r_i$ is the residual between a measured training response and its out-of-fold prediction, and $\widehat q_p(r)$ is the empirical residual quantile at level $p$. The project reports scenario amplitudes at $p=0.50$, $0.90$, and $0.95$ using the same PPV, PPA, and component definitions used for the measured records.

The component PPA quantiles become the target peak accelerations for the generated scenario histories. For a source record $j$ and original component $c \in \{L,T,V\}$, the acceleration history is scaled as

$$
a'_{j,c}(t;D,Q,p)
= a_{j,c}(t)
  \frac{G\,\widehat{\mathrm{PPA}}_c(D,Q,p)}
       {\max_t |a_{j,c}(t)|} .
$$

Here $G$ converts the predicted PPA units to the acceleration units of the processed histories. The scale factor sets the peak acceleration of each original source component to the corresponding scenario PPA target before the later scenario-generation steps produce the horizontal components and derived demand products.

## SoT Check

Preserved obligations:

```text
signal-amplitude model purpose;
scenario indexing by source-to-receiver distance and MIC;
PPV and PPA as scalar amplitudes and as L, T, and V component amplitudes;
explanatory variables based on charge, distance, scaled distance, and transforms;
evaluation over the distance-MIC grid;
empirical predictive quantiles;
component PPA quantiles as acceleration-amplitude levels for scenario histories;
quantile notation based on fitted amplitude plus empirical residual offset;
cross-validated out-of-fold residual basis;
consistent response definitions across PPV, PPA, and components;
component PPA quantiles as scenario peak-acceleration targets;
component-specific scale factor based on unit-converted predicted component PPA and source component peak acceleration;
scenario-scaling details and TITO-supported amplitude-scaling limitations deferred to C04 after contract audit.
```

Deferred obligations:

```text
PPA vs PPV model-performance comparison;
conditional PPV improvement;
record-selection metrics;
figures and tables.
```

Rejected public-report problems excluded from candidate:

```text
definition by negation;
software-manual language;
implementation file names;
helper/function names;
source-map metadata in prose;
claims about pore-pressure or liquefaction response;
PLAXIS-compatible framing;
spectral matching language.
```

## Validation

Forbidden implementation vocabulary checked against the candidate public
section:

```text
pipeline workflow script helper runner package CSV JSON folder path software
manual not a physics model not pore pressure not liquefaction PLAXIS-compatible
spectral matching human comfort building damage
```

Expected result:

```text
No rejected terms appear in the candidate public section.
```

## Status

P1-P2 approved by user on 2026-07-06, then revised on 2026-07-07 after style and contract audit; revised P1-P2 require re-approval before migration. P2 revised again on 2026-07-07 to replace generic conditional-mean notation with the project-supported residual-quantile equation. Original P3 approved by user on 2026-07-07. P3 revised on 2026-07-07 after contract audit and revised again to expose the unit-conversion factor used by the scaling contract; revised P3 requires re-approval before migration. Line-format rule approved on 2026-07-07. The current reading draft incorporates this material in expanded form at `dev/research/blast-report/DRAFT-report-reading-copy-20260707.md`, but no text has been migrated to `_chapters/`.
