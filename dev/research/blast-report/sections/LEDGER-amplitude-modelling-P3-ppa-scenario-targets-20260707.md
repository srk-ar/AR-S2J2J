# LEDGER-amplitude-modelling-P3-ppa-scenario-targets-20260707

## Section

P3: use of component PPA quantiles as scenario acceleration-amplitude targets.

## Report Purpose

Connect the amplitude model to the generation of scenario time histories. P1 defines the response family and D/MIC explanatory variables, and P2 defines the residual-quantile formulation. P3 should state how the predicted component PPA quantiles become target peak acceleration levels for each distance-charge scenario.

The paragraph must remain in the amplitude-modelling chapter. Detailed time-history products, horizontal rotation, response spectra, intensity measures, audit checks, and record selection belong to the following scenario-scaling chapter.

## Sources Read

Project source:

```text
scripts/runPost.R
scripts/gmsp/setup.R
scripts/runScenarios.R
scripts/runScenarios.json
data/export/predictions.csv
data/domains/units.json
data/gmsp/F80.Qo.Do.eemd/F80.Qo.Do.eemd.json
data/gmsp/F125.Qo.Do.eemd/F125.Qo.Do.eemd.json
```

Library source:

```text
/Users/averrik/Cloud/github/libraries/gmsp/vignettes/signal-processing.Rmd
/Users/averrik/Cloud/github/libraries/gmsp/vignettes/intensity-measures.Rmd
```

TITO research source reviewed for possible support:

```text
dev/research/blast-report/tito-output-audit-2026-07-06.md
dev/research/blast-report/sources/tito-compiled/md/T7.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T10.compile.research.md
dev/research/blast-report/sources/tito-compiled/bib/T7.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T10.compile.research.biblatex.bib
```

Curated bibliography promoted from the TITO evidence trail for later C02/C04 use:

```text
bib/references.bib::BommerAcevedo2004
bib/references.bib::WhittakerEtAl2011NISTGCRScaling
bib/references.bib::LucoBazzurro2007
bib/references.bib::BooreBommer2005
```

Style source:

```text
/Users/averrik/Cloud/github/garage/style/technical-writing.md
/Users/averrik/Cloud/github/tools/psha/dev/SoT/LEDGER-srs-methodology-P10-products-traceability-20260702.md
```

## Exact Claims Allowed

- Component PPA quantiles provide target peak accelerations for each distance-charge scenario.
- The target amplitude is applied by comparing the scenario PPA for a component with the peak acceleration of the corresponding source record component.
- The scale factor is component-specific and record-specific.
- Scaling produces scenario acceleration histories that retain the source record time axis and waveform shape within each component.
- The unit-conversion factor is read from the PPA units used by the amplitude model and the acceleration units of the processed histories.
- Project contract: scenario targets are the predicted `ppaL`, `ppaT`, and `ppaV` values at the selected distance, MIC, and quantile level.
- Project contract: target PPA units are converted to the time-history target units before the scale factor is computed.
- Project contract: the effective scale factor is computed for each source record and original component label `L`, `T`, or `V`; horizontal rotation to `H1` and `H2` and vertical relabelling to `UP` occur after scaling and belong to C04.
- TITO T7/T10 support general amplitude-scaling limitations and wording for scenario demand histories, but they do not define the project scaling contract. Their natural public use belongs in C04.

## Claims Not Allowed

- Do not discuss horizontal principal-axis rotation in this paragraph.
- Do not discuss D50, response spectra, intensity measures, plots, or selected-record exports.
- Do not claim physical equivalence between a scaled scenario history and a newly measured blast.
- Do not introduce the phrase `component-wise scalar scaling` in public prose.
- Do not claim that scaling the original L, T, and V channels preserves the measured three-component vector field when the channels receive different scale factors.
- Do not discuss PPV conditioning or PPV error reduction.
- Do not discuss pore-pressure, deformation, liquefaction, or numerical model response.
- Do not name scripts, packages, helper functions, file paths, generated tables, or implementation directories in the public paragraph.

## Equations Allowed

Scenario acceleration scaling relation:

$$
a'_{j,c}(t;D,Q,p)
= a_{j,c}(t)
  \frac{G\,\widehat{\mathrm{PPA}}_c(D,Q,p)}
       {\max_t |a_{j,c}(t)|}
$$

where:

```text
j                             source record index;
c                             original component L, T, or V;
D                             source-to-receiver distance;
Q                             maximum instantaneous charge;
p                             predictive quantile level;
a_{j,c}(t)                    source acceleration history;
\widehat{\mathrm{PPA}}_c      predicted component PPA;
G                             PPA unit-conversion factor;
\max_t |a_{j,c}(t)|           source component peak acceleration.
```

## Equations Excluded

- PPV conditional prediction equations.
- Chain-regression update equations.
- Response-spectrum equations.
- Intensity-measure equations.
- Pore-pressure or liquefaction equations.

## Vocabulary Allowed

- `component PPA quantile`
- `target acceleration amplitude`
- `source record`
- `source component`
- `component scale factor`
- `unit-conversion factor`
- `scenario acceleration history`
- `source-to-receiver distance`
- `maximum instantaneous charge`
- `predictive quantile level`
- `time axis`
- `waveform shape`
- `unit consistency`

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
- `D50`
- `PSW`
- `IMW`
- `PLAXIS-compatible`
- `spectral matching`
- `pore pressure`
- `liquefaction`
- `new measured event`

Rejected terms may appear in this ledger only to define exclusions.

## Candidate Public Paragraph Or Section

The component PPA quantiles become the target peak accelerations for the generated scenario histories. For a source record $j$ and original component $c \in \{L,T,V\}$, the acceleration history is scaled as

$$
a'_{j,c}(t;D,Q,p)
= a_{j,c}(t)
  \frac{G\,\widehat{\mathrm{PPA}}_c(D,Q,p)}
       {\max_t |a_{j,c}(t)|} .
$$

Here $G$ converts the predicted PPA units to the acceleration units of the processed histories. The scale factor sets the peak acceleration of each original source component to the corresponding scenario PPA target before the later scenario-generation steps produce the horizontal components and derived demand products.

## Candidate Translation Terminology

Do not translate P3 until the English paragraph is approved.

Terminology likely needed after approval:

- `component PPA quantile`: `cuantil PPA de componente`
- `target acceleration amplitude`: `amplitud objetivo de aceleracion`
- `source record`: `registro fuente`
- `source component`: `componente fuente`
- `component scale factor`: `factor de escala de componente`
- `unit-conversion factor`: `factor de conversion de unidades`
- `scenario acceleration history`: `historia de aceleracion de escenario`
- `predictive quantile level`: `nivel de cuantil predictivo`
- `time axis`: `eje temporal`
- `waveform shape`: `forma de onda`
- `unit consistency`: `consistencia de unidades`

Spanish accents are intentionally omitted in this ledger to keep repository editing ASCII-only until the translation pass decides the file encoding policy.

## Open Gaps

- Decide whether this equation remains in C03 or is repeated only in C04, where the full scenario-scaling procedure is described.
- Horizontal rotation and vertical component naming should be handled in C04, not in this paragraph.
- C04 should describe the full scenario-generation contract: predicted `ppaL`, `ppaT`, and `ppaV` targets; source-record and original-component scale factors; horizontal rotation to `H1/H2`; vertical relabelling to `UP`; scenario `TSW`, `IMW`, and `PSW` products; and audit/export products.
- C04 should document the effect of different scale factors on original component amplitude ratios and directional demand using T7/T10 only where the connection is natural and with curated support from Luco and Bazzurro [-@LucoBazzurro2007] if retained.
- C02 or C04 should use Boore and Bommer [-@BooreBommer2005] where baseline correction, filtering, integration, and derived velocity/displacement products are discussed.

## Validation

Forbidden implementation vocabulary checked against the candidate:

```text
pipeline workflow script helper runner package CSV JSON folder path software manual D50 PSW IMW PLAXIS-compatible spectral matching pore pressure liquefaction new measured event
```

Result:

```text
No rejected terms appear in the candidate paragraph, except excluded concepts listed in the ledger controls.
```

TITO support validation:

```text
T7/T10 reviewed but not used in the public P3 paragraph after contract audit.
The P3 public paragraph is supported by the project scenario-generation contract, not by an imported scaling methodology label.
T7/T10 limitations on amplitude scaling and component ratios are deferred to C04.
No public citation appears in P3 after the corrective audit.
```

Structural validation:

```text
No heading is proposed for migration.
One scenario-scaling equation is proposed for P3.
No public report file is edited by this ledger.
```

Approval status:

```text
Original P3 approved by user on 2026-07-07. Revised on 2026-07-07 after contract audit to remove imported `component-wise scalar scaling` language and public TITO citations. Revised again on 2026-07-07 to expose the unit-conversion factor used by `.scaleAT()` and to write the denominator as the source-component peak acceleration. Revised public paragraph requires re-approval before migration to _chapters/.
```
