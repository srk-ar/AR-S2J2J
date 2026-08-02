# HANDOFF-agent-wave3d-vmd-modal-attenuation-2026-07-06

## Objective

Design a numerical model for hybrid blast-vibration scenario histories using:

- Wave3D synthetic records for site A, Iduapriem, from virtual geophones at
  multiple source distances;
- a fixed or arbitrary MIC simulation basis at site A, with no real records
  available at that site;
- VMD-based modal decomposition of those records;
- mode-wise attenuation with distance;
- reconstruction of the full attenuated signal from attenuated modes;
- real site B blast-array records with different charge arrays, delays, MIC
  values, and comparatively low distance variability.

The model is project-specific and unpublished. The agent must not present it as
a standard method or as a literature-established workflow. The goal is to
formulate a defensible transfer/adaptation model, define assumptions, identify
what can be calibrated from the available data, and specify validation tests.
The practical objective is to correct or adapt the VMD modes of real site B
records so that they are more representative of site A, using Wave3D-derived
modal distance behavior from Iduapriem.

Non-negotiable modelling frame: all analysis is based on IMFs/modes separated
with VMD. The full time history is not the primary modelling object; it is the
reconstruction obtained after modal correction, and it is used for validation
and downstream demand metrics.

## Start Folder

Repository root:

```text
/Users/averrik/Cloud/github/projects/AR-S2J2J.R
```

## Mandatory Reading

Read in order:

1. `dev/SoT/ACTIVE.md`
2. `dev/plan/blast-report/active.md`
3. `dev/research/blast-report/HANDOFF-blast-report-methodology-20260707.md`
4. `scripts/dev/sot/AUDIT-signal-processing-gmsp-2026-07-06.md`
5. `dev/research/blast-report/tito-output-audit-2026-07-06.md`
6. `dev/research/blast-report/sources/tito-compiled/md/T5.compile.research.md`
7. `dev/research/blast-report/sources/tito-compiled/md/T6.compile.research.md`
8. `dev/research/blast-report/sources/tito-compiled/md/T9.compile.research.md`
9. `dev/research/blast-report/sources/tito-compiled/md/T10.compile.research.md`
10. `/Users/averrik/Cloud/github/garage/harness/HARNESS.md`
11. `/Users/averrik/Cloud/github/garage/harness/RESEARCH-LEDGER-HARNESS.md`
12. `/Users/averrik/Cloud/github/garage/style/technical-writing.md`

TITO task examples are embedded later in this handoff. Do not depend on the
original TITO task folder being present; the user may delete the original TITO
workspace after the compiled research material has been preserved under
`dev/research/blast-report/sources`.

## User-Provided Concept To Preserve

The user is proposing a hybrid model not yet researched or published in this
project:

1. Site A is Iduapriem.
2. At site A there are no real blast-vibration records available.
3. Site A evidence consists of Wave3D simulations for arbitrary MIC values.
4. Wave3D virtual geophones provide histories at multiple distances from the
   source.
5. The Wave3D simulations are intended to capture site A variability of
   frequency content with distance.
6. VMD is applied to the Wave3D histories.
7. The relationship between VMD modes and distance is used to calibrate
   attenuation or transformation by mode for site A.
8. The global attenuated signal is reconstructed by summing the corrected or
   attenuated VMD modes.
9. Site B has real velocity or acceleration histories from multiple blast-array
   realizations.
10. Site B records include different MIC values, charge arrays, delays, and
   blast designs, but have comparatively low distance variability.
11. Site B real records are intended to provide empirical variability in
    source, MIC, delay-array, and charge-array frequency content.
12. The objective is to learn from both evidence surfaces: use site B real
    records for source-array/MIC/delay variability, and use site A Wave3D
    simulations for site-specific distance/path modal behavior, then correct or
    adapt VMD modes of site B records to site A conditions.

Everything above is modal-first. The agent must not design a model that first
fits global PGA, PPV, CAV, Arias intensity, or response-spectrum attenuation
and then uses VMD only as a diagnostic. Those global quantities are validation
or reporting products derived from reconstructed modal histories.

The agent should treat the problem as cross-site modal transfer or domain
adaptation, not as direct calibration from paired real records. There are no
paired real site A records, so the site-transfer assumptions must be explicit
and validated indirectly.

## Scope

The agent should design the numerical model and validation protocol.

In scope:

- notation and model architecture;
- data contracts for site A Wave3D virtual-geophone records and site B real
  blast-array histories;
- VMD decomposition choices and mode tracking across distances;
- IMF/mode-level feature extraction, calibration, transformation, uncertainty,
  and reconstruction;
- mode-wise attenuation laws;
- reconstruction of unit-MIC records at target distances;
- source/MIC scaling assumptions;
- delay-array superposition assumptions;
- separation of site A path/distance effects from site B source-array effects;
- cross-site modal transfer assumptions and uncertainty;
- validation metrics tied to TSF response relevance;
- TITO gap tasks for VMD and adjacent literature where needed.

Out of scope unless explicitly requested:

- public report prose migration;
- `_chapters/`, `_fig/`, `_tbl/`, or bibliography promotion;
- final acceptance criteria for TSF safety;
- claiming pore-pressure generation directly from acceleration records;
- spectral matching;
- PLAXIS-specific input preparation as the controlling method;
- broad recursive scans of project data folders;
- edits to `gmsp` or production pipeline code.

## Method Classification

Classify the proposed model as:

```text
project-specific numerical methodology / unpublished modelling hypothesis
```

Do not classify it as:

```text
standard attenuation method
published VMD attenuation method
validated liquefaction prediction method
spectral matching
calibrated pore-pressure model
```

The role of literature and TITO is to hydrate adjacent concepts:

- VMD formulation and limitations;
- modal/component filtering validation;
- frequency-dependent attenuation and dispersion;
- blast source scaling and scaled-distance concepts;
- delay-array superposition and waveform interference;
- engineering validation of processed vibration histories.

Literature is not expected to prove the exact project-specific hybrid model.

## Modal-First Requirement

The modelling unit is:

```text
VMD mode / IMF-like component m, component c, record i, site s
```

All calibration and transfer must be expressed at this level before any
full-history metric is computed. Examples:

- mode amplitude or envelope attenuation with distance;
- mode energy attenuation with distance;
- mode center-frequency or bandwidth drift with distance;
- mode travel-time or phase behavior with distance;
- mode source/MIC scaling;
- mode sensitivity to delay-array interference;
- mode uncertainty and residual variability.

Full-signal products are downstream:

```text
corrected modes -> reconstructed time history -> demand metrics
```

The agent should reject any architecture that treats VMD as merely a plot,
filtering decoration, or post-hoc explanation for a model calibrated only on
global scalar measures.

## Proposed Model Architecture

Use notation like the following until data contracts are known.

Site A Wave3D basis:

```text
g_{A,j}^c(t) = Wave3D history at site A / Iduapriem,
               virtual geophone distance D_j,
               component c,
               simulation MIC q_A
```

VMD decomposition:

```text
g_{A,j}^c(t) = sum_{m=1..K} u_{A,j,m}^c(t) + r_{A,j}^c(t)
```

Use "VMD mode" or "mode" in public/technical notes. Do not call VMD modes
physically unique IMFs unless a curated VMD source and project validation
support that terminology. If the project code or user uses "IMF", write
"VMD mode (IMF-like component)" in internal notes until terminology is curated.

Mode-wise distance attenuation:

```text
A_m^c(D) = amplitude, energy, envelope, or spectral metric for mode m,
           component c, at distance D for site A Wave3D modes
```

Candidate attenuation forms to compare:

```text
log A_m^c(D) = beta_{0,m}^c - n_m^c log(D / D0) - kappa_m^c (D - D0)
```

or a frequency-dependent quality-factor form:

```text
A_m^c(D) / A_m^c(D0)
  = (D / D0)^(-n_m^c) exp[-pi f_m^c (D - D0) / (Q_m^c V_m^c)]
```

Do not assume either law is correct. Treat them as candidate parameterizations.

Unit-MIC reconstruction at target distance:

```text
g_hat_A^c(t; D*) = sum_m T_{A,m}^c[u_{A,ref,m}^c](t; D*) + r_hat_A^c(t; D*)
```

where `T_{A,m}^c` may include:

- amplitude scaling by mode;
- travel-time or phase shift;
- optional duration broadening;
- optional frequency/center-frequency drift if supported by data;
- no operation that cannot be calibrated or justified.

Site B real blast-array realization:

```text
y_{B,i}^c(t) = observed real site B array history i, component c
```

Array design variables:

```text
q_{i,h}     charge or MIC contribution for hole/delay group h
tau_{i,h}   delay time for group h
D_{i,h}     source-to-receiver distance for group h
az_{i,h}    optional azimuth/orientation variable, if available
```

Candidate superposition model:

```text
y_{B,i}^c(t)
  ~= sum_h sum_m S_m^c(q_{i,h})
       A_{B,m}^c(D_{i,h})
       phi_m^c(t - tau_{i,h} - travel_m^c(D_{i,h}))
     + epsilon_i^c(t)
```

This is a linear superposition hypothesis. It must be validated. If blast-array
records show nonlinear source, clipping, site saturation, or charge-interaction
effects, the model must either add terms or state its limitations.

Cross-site modal adaptation target:

```text
y_hat_{A|B,i}^c(t; D_A*)
  = sum_m C_{B->A,m}^c[
        u_{B,i,m}^c(t),
        q_i,
        D_{B,i},
        D_A*
    ] + r_hat_{A|B,i}^c(t)
```

where `C_{B->A,m}^c` is an explicit modal correction operator. It may include:

- site A distance attenuation from Wave3D;
- source/MIC scaling inferred from site B real records;
- delay-array interference retained from the real site B waveform;
- frequency-band or center-frequency adjustment if VMD mode tracking supports
  it;
- uncertainty terms for unpaired site transfer.

Do not implement `C_{B->A,m}^c` as a black-box correction. The agent must state
which part comes from site A Wave3D data, which part comes from site B real
records, and which part is an assumption.

## Separation Of Effects

The intended decomposition of evidence is:

- Site A / Iduapriem Wave3D virtual geophones: site A path, distance, and modal
  frequency-content evolution, but no empirical real-record source variability.
- Site B real blast-array records: empirical source-array, delay, MIC, and
  blast-design frequency-content variability, but limited distance variability
  and not the target site path response.

The agent should test whether this separation is identifiable. A separable
model may look like:

```text
adapted mode demand at site A
  = source/delay/array term learned from site B real records
    x site A modal path-distance correction from Wave3D
    x component/orientation term
    x cross-site residual variability
```

Potential source term:

```text
S_m^c(q) = q^{alpha_m^c}
```

Do not assume `alpha = 1`, square-root scaling, or cube-root scaling without
project evidence or literature support. If only unit-MIC Wave3D records exist,
charge scaling must come from the blast-array records, external blasting
attenuation literature, or a clearly stated assumption.

Critical identifiability issue:

- Site A has no real records, so there is no direct paired observation to prove
  that a site B VMD mode corrected with site A Wave3D attenuation is a true site
  A real blast mode.
- The defensible claim is weaker: the model constructs site-A-adapted scenario
  histories by combining site B empirical source variability with site A
  simulated modal path behavior.
- Validation must therefore focus on internal consistency, held-out Wave3D
  distance reconstruction, held-out site B source/MIC behavior, robustness of
  VMD mode matching, and sensitivity of TSF-relevant demand metrics.

## VMD-Specific Risks

The project already has TITO support for EEMD filtering validation through T9,
but VMD has not yet been researched in this workflow.

The VMD modelling agent must not copy EEMD limitations directly into VMD
without checking VMD literature. Likely VMD-specific issues to research:

- choice of number of modes `K`;
- bandwidth penalty / alpha;
- center-frequency initialization;
- convergence tolerance;
- mode splitting and mode merging;
- mode tracking across distance;
- boundary effects in short transient records;
- whether mode center frequencies drift with distance;
- whether modes can be aligned across records by center frequency, spectral
  overlap, envelope correlation, or energy ranking;
- whether modes are stable under small parameter changes.

Treat VMD modes as signal-processing components unless independent validation
links them to physical wave types, source mechanisms, or site modes.

## Validation Protocol

The first validation layer is Wave3D-only:

- hold out one or more virtual geophone distances;
- fit mode-wise attenuation on remaining distances;
- validate mode-level predictions first: mode energy, envelope, center
  frequency, bandwidth, phase/travel-time, and mode matching across distance;
- reconstruct full histories at held-out distances;
- compare raw versus reconstructed histories in time and frequency domains only
  after modal checks are acceptable.

Recommended metrics:

- peak velocity and/or acceleration by component;
- Arias intensity, CAV, RMS, and significant duration where available;
- Fourier amplitude or power spectral density;
- response spectra at TSF-relevant periods;
- low-frequency band energy relevant to tailings response;
- mode energy by distance;
- phase/travel-time residuals;
- full waveform RMSE only as a secondary diagnostic.

The second validation layer is blast-array prediction:

- hold out complete blast-array realizations;
- predict VMD modes using source terms, delay superposition, and mode-wise path
  attenuation or correction;
- reconstruct histories from predicted modes;
- compare modal residuals before global demand metrics;
- inspect residuals by MIC, distance, delay pattern, and component.

The third validation layer is TSF relevance:

- compare selected scenario records using metrics identified in T6:
  amplitude, duration/cycles, frequency content, cumulative measures, and
  response spectra;
- do not infer pore pressure directly from the records;
- state that pore-pressure response remains conditional on material state,
  drainage, effective stress, and calibrated constitutive modelling.

## TITO Coordination

Use TITO only for what the modelling agent cannot responsibly answer from
local data and first principles. TITO tasks must contain context and questions,
not rules, output templates, or forbidden-claim blocks.

Candidate TITO tasks, if needed:

```text
gap-vmd-transient-vibration-validation
gap-vmd-mode-tracking-distance-attenuation
gap-blast-array-delay-superposition-frequency-content
gap-charge-scaling-unit-mic-modal-source-term
gap-cross-site-modal-transfer-unpaired-blast-records
```

Candidate questions for `gap-vmd-transient-vibration-validation.md`:

1. What are the authoritative VMD references for transient, nonstationary
   engineering vibration signals?
2. Which VMD parameters most affect mode stability and reconstruction?
3. How should VMD modes be validated before they are used as engineering scale
   bands?
4. What terminology is defensible for VMD modes without overclaiming physical
   uniqueness?

Candidate questions for `gap-vmd-mode-tracking-distance-attenuation.md`:

1. Is there literature on tracking decomposition modes across sensors,
   distances, or propagation paths?
2. Which mode-alignment diagnostics are defensible: center frequency, spectral
   overlap, energy ranking, envelope correlation, phase/group delay, or other
   metrics?
3. How should uncertainty be reported when a mode cannot be matched robustly
   across distances?

Candidate questions for `gap-blast-array-delay-superposition-frequency-content.md`:

1. How do blast delay arrays affect frequency content and waveform interference
   in measured ground vibration?
2. What assumptions are used when individual charge contributions are linearly
   superposed?
3. What limitations should be stated for multi-hole or multi-delay synthetic
   histories constructed from unit-source responses?

Candidate questions for `gap-charge-scaling-unit-mic-modal-source-term.md`:

1. Which charge-scaling or scaled-distance relationships are used for blast
   vibration amplitude and frequency content?
2. Can charge scaling be frequency-dependent or mode-dependent in published
   blasting literature?
3. What assumptions are required to extrapolate a unit-MIC response to larger
   MIC values?

Candidate questions for `gap-cross-site-modal-transfer-unpaired-blast-records.md`:

1. Which adjacent literatures discuss transferring modal, spectral, or
   frequency-band corrections between one simulated site and another measured
   site when paired observations do not exist?
2. What assumptions are normally required for unpaired domain adaptation of
   time histories or spectra?
3. Which validation language is defensible when a model combines simulated
   target-site path behavior with real source variability from a different
   site?
4. How should uncertainty be described when the target site has no real records
   for direct calibration?

Do not relaunch old T1 unless the task is narrowed to charge-window or
maximum-charge-per-delay definitions. The previous T1 drifted into receiver
criteria that are not central to this model.

## Required Deliverables

First deliverable:

```text
scripts/dev/sot/PLAN-wave3d-vmd-modal-attenuation-2026-07-06.md
```

It must include:

- exact data sources requested from the user;
- site mapping as now clarified: site A is Iduapriem/Wave3D-only and site B is
  real-record-only;
- notation and model alternatives;
- assumptions that are data-supported versus assumed;
- planned TITO tasks, if any;
- validation metrics;
- what will be written only to `/private/tmp`;
- exact next command.

Second deliverable after user approval:

```text
dev/research/blast-report/sections/S0X-wave3d-vmd-modal-attenuation-2026-07-06.md
```

This is a research ledger, not public prose. It should follow
`RESEARCH-LEDGER-HARNESS.md`.

Third deliverable after model design approval:

```text
scripts/dev/sot/SPEC-wave3d-vmd-modal-attenuation-2026-07-06.md
```

It should specify the mathematical model, calibration procedure, validation
protocol, and open implementation questions.

## Rejected

- Treating VMD and EEMD as interchangeable.
- Treating VMD modes as physical wave modes without validation.
- Treating the modal attenuation model as published methodology.
- Treating Wave3D unit-MIC records as sufficient to infer charge scaling.
- Calibrating only global PGA, PPV, CAV, Arias intensity, response spectra, or
  waveform metrics and then using VMD as post-hoc explanation.
- Inferring pore pressure or liquefaction directly from the vibration records.
- Using only peak amplitude error as validation.
- Introducing spectral matching.
- Building public figures, tables, or chapters before the model ledger is
  approved.

## Exact Next Command

Create the active plan:

```text
scripts/dev/sot/PLAN-wave3d-vmd-modal-attenuation-2026-07-06.md
```

The plan must first ask the user to provide bounded paths or manifests for:

- site A / Iduapriem Wave3D virtual-geophone histories;
- site A Wave3D simulation metadata: MIC value(s), source definition,
  distances, components, time step, units, and virtual geophone coordinates;
- site B real blast-array realization histories;
- site B array metadata: charges, MIC, delay times, distances, components,
  sensor orientation, and units.
