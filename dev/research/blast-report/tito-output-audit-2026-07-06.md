# TITO Output Audit - TSF Blasting Research - 2026-07-06

## Purpose

This audit classifies the TITO Markdown outputs generated for the
`AR-S2J2J.R` blast-vibration report. It is not public report prose. It
identifies which claims can be developed into paragraph ledgers, which claims
need primary-source verification, and which outputs must remain quarantined.

The project frame is nearby blasting effects on a tailings storage facility
with saturated fine tailings, dynamic pore-pressure accumulation, cyclic
mobility, and liquefaction-type response as the engineering concern. The
methodology must describe measured-record processing, scenario construction,
record selection, and limitations. It must not introduce spectral matching,
human comfort, building damage, or PLAXIS input preparation as the controlling
method.

## Source Set

Reviewed outputs:

```text
dev/research/blast-report/sources/tito-compiled/md/T1.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T3.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T5.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T6.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T7.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T8.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T9.compile.research.md
dev/research/blast-report/sources/tito-compiled/md/T10.compile.research.md
dev/research/blast-report/sources/tito-compiled/bib/T1.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T3.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T5.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T6.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T7.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T8.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T9.compile.research.biblatex.bib
dev/research/blast-report/sources/tito-compiled/bib/T10.compile.research.biblatex.bib
```

The empty dummy KB used during TITO execution was not preserved because it is
not evidence and must not support any technical claim.

## Output Classification

### T1. Standards And Charge Window

Status: quarantined.

Reason: the run produced usable Markdown, but it drifted into building damage,
human-response, and general compliance material. Those topics are outside the
TSF pore-pressure methodology unless mentioned only to separate them from the
geotechnical assessment.

Allowed use:

- as a negative boundary source after primary verification;
- to remind the report that blast-monitoring standards can support acquisition
  and reporting vocabulary but do not establish saturated-tailings liquefaction
  criteria.

Not allowed:

- fixed PPV, building-damage, or human-comfort thresholds as TSF acceptance
  criteria;
- any public paragraph that treats T1 as an authoritative source by itself.

### T3. EEMD Filtering Validation

Status: conditionally useful.

Allowed use:

- signal-processing limitation language for EMD/EEMD decomposition,
  reconstruction, mode mixing, end effects, and validation checks;
- support for requiring peak, energy, drift, duration, spectrum, and visual
  checks after filtering.

Required before promotion:

- screen every claim for relevance to engineering vibration records;
- avoid generic signal-processing exposition that does not affect the
  methodology;
- verify key EEMD references and replace working `Ref###` keys with curated
  bibliography entries.

### T5. TSF Blasting, Pore Pressure, And Liquefaction

Status: high-value basis for methodology ledgers.

Useful claim families:

- blast records define dynamic demand histories; they do not directly define
  excess pore pressure, effective stress, cyclic strain, or liquefaction state;
- the bridge from blast vibration to saturated-tailings response comes from
  soil dynamics, cyclic resistance, pore-pressure generation, and coupled
  effective-stress modelling;
- simplified cyclic-stress concepts can be used as screening analogies, but
  earthquake duration and equivalent-cycle assumptions are not automatically
  transferable to short blast pulses;
- the report can discuss `CSR`, `CRR`, factor of safety against triggering,
  and excess pore-pressure ratio `r_u`, provided the assumptions and
  limitations are explicit;
- material parameters required for calibrated response include effective stress
  state, saturation, density/state, fines/plasticity, cyclic resistance,
  hydraulic conductivity, stiffness/damping, dilatancy/contractiveness, and
  residual or liquefied strength.

Equations suitable for ledger development:

```tex
CSR = \frac{\tau_{cyc}}{\sigma'_{v0}}
    \approx 0.65 \frac{a_{max}}{g}
    \frac{\sigma_{v0}}{\sigma'_{v0}} r_d
```

```tex
FS_{liq} = \frac{CRR_{M=7.5} MSF K_\sigma K_\alpha}{CSR}
```

```tex
r_u = \frac{\Delta u}{\sigma'_{v0}}
```

Required before promotion:

- verify the exact form and applicability of every equation against primary
  liquefaction references;
- avoid claiming that a blast record alone can predict `r_u`;
- verify DOI metadata in `dev/research/blast-report/sources/tito-compiled/bib/T5.compile.research.biblatex.bib`;
- do not cite `KBT1` or `KBT3` generated Markdown as external authority.

### T6. Blast Record Selection Metrics

Status: high-value but citation quality is mixed.

Useful claim families:

- record selection for TSF pore-pressure response should not rely on peak
  measures alone;
- useful descriptors span amplitude, cumulative loading, frequency content,
  duration, and cycle count;
- candidate measures include `PGA`, `PPV`/`PGV`, significant duration
  (`D5-95`, `D5-75`), equivalent or apparent cycles, dominant/centroid
  frequency, Fourier or spectral power in the TSF response band, Arias
  intensity, `CAV`, cutoff-`CAV`, and RMS acceleration;
- response spectra are useful for dynamic-demand characterization and checking
  energy near the facility response range, but they are not a pore-pressure
  generation model;
- scaled distance is a source-receiver predictor, not a waveform-selection
  intensity measure by itself.

Useful formulas for ledger development:

```tex
PGA = \max_{t \in [0,T]} |a(t)|
```

```tex
PGV = \max_{t \in [0,T]} |v(t)|,
\quad v(t) = v_0 + \int_0^t a(\tau)\,d\tau
```

```tex
D_{5-95} = t_{95} - t_5
```

```tex
N_{eq} = \sum_i N_i \left(\frac{\tau_i}{\tau_{ref}}\right)^b
```

```tex
I_A = \frac{\pi}{2g}\int_0^T a^2(t)\,dt
```

```tex
CAV = \int_0^T |a(t)|\,dt
```

Claims requiring primary-source verification before public use:

- `PGA` ranking 61st of 62 pore-pressure predictors;
- shear-strain threshold near 0.01 percent for pore-pressure initiation;
- specific blast-induced liquefaction field thresholds;
- CANLEX and Rollins field-test interpretations;
- Arias intensity lower-bound values for liquefaction;
- cutoff-`CAV` thresholds and applicability to blast records;
- spectral power in a 0-5 Hz band and the reported `R^2` value for tailings
  dam demand;
- typical blast dominant-frequency ranges near TSFs;
- claims about fine-tailings cyclic mobility versus full liquefaction.

Not allowed without additional support:

- a single scalar acceptance criterion for TSF safety;
- treating `CAV5` as validated for sub-second blast records;
- treating earthquake magnitude-scaling factors as directly applicable to
  blast records.

### T7. Scaling Measured Blast Records

Status: useful for method wording and limitations.

Useful claim families:

- scalar amplitude scaling of a measured component preserves the time axis,
  duration, relative timing, phase timing, normalized waveform shape, and
  frequency locations;
- linear products such as velocity, displacement, Fourier amplitude, and
  linear response spectra scale by the same factor if processing is otherwise
  unchanged;
- independent component scaling can change measured vector amplitude ratios,
  polarization, directional demand, and resultant particle-motion envelopes;
- the scaled records should be described as scenario demand histories or scaled
  measured input motions, not as new measured events or calibrated predictions
  of future blasts;
- amplitude scaling is distinct from spectral matching, synthetic waveform
  generation, and calibrated blast source modelling.

Required before promotion:

- use primary references for amplitude scaling where possible;
- treat NIST response-history guidance as a general engineering analogue, not
  blast-specific proof;
- do not rely on arXiv-only synthesis where a peer-reviewed or official source
  is available;
- keep pore-pressure response as a model output conditional on material
  parameters and effective-stress assumptions.

### T8. TSF/Dam/Tailings Guidance

Status: useful for report framing, but standards/legal claims require careful
primary verification.

Useful claim families:

- TSF guidance frames blasting/dynamic loading as a project-specific
  geotechnical assessment and monitoring problem, not as a universal PPV limit;
- GISTM, IFC, ANCOLD, ICOLD, MAC, and South African guidance can frame the
  distinction between governance, monitoring, design criteria, and analysis
  assumptions;
- building-damage and human-response criteria should be explicitly separated
  from TSF geotechnical performance;
- pore-pressure monitoring and dynamic response assessment are part of the
  performance-verification framework when blasting occurs near a TSF.

Required before promotion:

- verify every standard/guideline citation against the primary document;
- verify current South African mining/blasting guidance and applicability;
- check whether quoted ANCOLD factors of safety and return-period statements
  are exact and context-correct;
- avoid presenting international guidance as local legal requirements unless
  the project or jurisdiction explicitly adopts it.

Not allowed:

- public prose that centers human comfort or building-damage criteria;
- fixed blast PPV thresholds for TSF safety unless a project-specific criterion
  is later supplied by the user or an approved project source.

### T9. EEMD Filtering Validation With Claude

Status: useful and preferred over T3 for EEMD/filtering ledger development,
subject to primary-source curation.

Run context: T9 reran the T3 EEMD task with the `claude` executor. It produced
compiled research and BibLaTeX outputs:

```text
dev/research/blast-report/sources/tito-compiled/md/T9.compile.research.md
dev/research/blast-report/sources/tito-compiled/bib/T9.compile.research.biblatex.bib
```

Useful claim families:

- EMD/EEMD can be described as adaptive decomposition and reconstruction for
  nonlinear or non-stationary records;
- EEMD reduces mode mixing through noise-assisted ensembles, but it does not
  produce uniquely physical blast-wave components;
- IMF retention/removal is defensible only as a documented filtering,
  denoising, detrending, or scale-band selection rule;
- EEMD-filtered histories need validation against raw records in time domain,
  frequency domain, integrated velocity/displacement, peak preservation,
  energy, baseline/drift, and response spectra;
- reported conclusions remain conditional on ensemble size, added-noise level,
  sifting/stopping criteria, endpoint treatment, and component-selection rule.

Useful source direction:

- T9 bibliography includes DOI-backed EMD/EEMD and strong-motion processing
  sources, including Huang et al. (1998), Wu and Huang (2009),
  Flandrin/Rilling/Goncalves, Boudraa/Cexus, Kopsinis/McLaughlin, Boore and
  Bommer, Boore, and Boore/Akkar.

Required before promotion:

- replace `Ref###` with stable bibliography keys;
- verify DOI metadata and full titles/authors;
- do not cite `KBT3.compile.research.md` as authority;
- avoid public claims that retained IMFs are physical source/path/site
  components unless independent project evidence is later supplied.

### T10. Scaling Measured Blast Records With Claude

Status: useful for comparison with T7, but not preferred as-is for public
citations because the bibliography is mixed.

Run context: T10 reran the T7 scaling task with the `claude` executor. It
produced compiled research and BibLaTeX outputs:

```text
dev/research/blast-report/sources/tito-compiled/md/T10.compile.research.md
dev/research/blast-report/sources/tito-compiled/bib/T10.compile.research.biblatex.bib
```

Useful claim families:

- scalar amplitude scaling can be expressed as `a_s(t) = SF a(t)`;
- constant time-domain scaling preserves normalized waveform shape, time axis,
  phase timing, duration, and frequency locations;
- acceleration-derived linear products scale predictably when processing is
  otherwise unchanged;
- independent component scaling can change measured component ratios and
  vector coherency;
- scaled measured records should be described as scenario demand histories, not
  as measured events at the scenario amplitude or calibrated future-blast
  predictions;
- acceleration histories define dynamic demand; pore-pressure response remains
  conditional on material model, effective-stress state, drainage assumptions,
  and cyclic response.

Required before promotion:

- prefer T7/T10 overlap only where both agree and a primary source can be
  curated;
- verify Bommer/Acevedo, NIST, Luco/Bazzurro, and any dam-analysis guidance
  from primary sources;
- do not promote claims supported only by Semantic Scholar pages, blogs,
  ResearchGate, vendor pages, arXiv-only synthesis, or generated KB Markdown;
- be cautious with any wording that presents spectral matching as a normal
  comparator; the AR-S2J2J public method must simply state that spectral
  matching was not performed.

## Bibliography Promotion Rules

Selected TITO-discovered sources have been curated into `bib/references.bib` with stable keys. The raw `Ref###`, `WebSource`, and generated KB entries in the copied TITO outputs remain working discovery material only.

Before promotion:

- replace `Ref###` keys with stable descriptive keys;
- replace `WebSource` titles with full metadata;
- prefer primary standards, official manuals, peer-reviewed papers, DOI records,
  and authoritative monographs;
- reject Wikipedia as a public report source;
- use ResearchGate only as a discovery path to the actual publication;
- do not cite generated `KB` Markdown as external authority;
- record inaccessible or abstract-only sources in the evidence ledger.

## Ledger Development Order

The next paragraph-development sequence should be:

1. Scope boundary: the study characterizes blast-induced dynamic demand for a
   TSF, not spectral matching, human comfort, building damage, or a numerical
   software workflow.
2. Data provenance and measured-record products: measured blast records are
   processed into traceable component histories and derived demand products.
3. Scenario construction: component-wise prediction and amplitude scaling
   create scenario demand histories, with explicit preservation/distortion
   limits.
4. Record-selection logic: selected histories should consider amplitude,
   duration/cycles, frequency content, and cumulative measures rather than peak
   amplitudes alone.
5. Link to TSF response: pore-pressure generation, cyclic mobility, and
   liquefaction potential require material state, effective-stress, drainage,
   and cyclic-resistance assumptions not contained in the motion records alone.
6. Guidance framing: published guidance supports project-specific assessment
   and monitoring, not universal TSF blast-vibration limits.

Each paragraph needs its own ledger before migration to `_chapters/`.

## Remaining Research Gaps

- Primary-source curation for every TITO `Ref###` bibliography entry.
- Project-specific introduction context from the user.
- Bounded project summaries for numerical results, scenario inventories, and
  selected records.
- Review of local `_fig`, `_tbl`, `scripts/fig`, and `scripts/tbl` prototypes
  against the `psha/scaffold` builder contract.
- Decision on whether to run additional TITO for charge-window definitions and
  component-wise attenuation after T5-T8 are digested.
