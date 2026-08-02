# AUDIT — Blast Executive Summary EN: narrative and professional prose

Date: 2026-07-20. Front: E135-A6z. Status: diagnostic-only; no public prose
edited.

## Why This Exists

The owner rejected the current English Executive Summary as contaminated and
insufficiently fluent after its internal sub-headings were removed. This audit
records the diagnosis in the repository, as required by the Harness. It
complements, and does not supersede,
`dev/SoT/DIAGNOSTICO-RESUMEN-EJECUTIVO-20260720.md`, which records the
genealogy of the contamination and an initial Spanish candidate.

## Objective

Read the current English memo as a standalone professional executive summary
and diagnose its narrative structure, paragraph function, professional English,
method/result balance, redundancy, table integration, notation, and residual
implementation or audit language.

## Scope

- `summary.en.qmd`.
- `_summary/records.summary.md` and `_summary/records.executive.qmd`.
- `_summary/model.summary.md` and `_summary/model.executive.qmd`.
- `_summary/scenarios.summary.md` and `_summary/scenarios.executive.qmd`.
- `_summary/risk.summary.md`.
- Executive branches of `_tbl/metrics.qmd` and `_tbl/scenarios.qmd`.
- Rendered `docx/summary.en.docx`, mtime
  `2026-07-20T18:31:06-0300`, read in full as plain text.
- Writing controls:
  `~/github/garage/style/technical-writing.md`,
  `~/github/garage/style/summary.md`, and
  `dev/SoT/LEDGER-BLAST-ENGLISH-TERMINOLOGY-20260719.md`.

## Out Of Scope

- Rewriting public ES or EN prose.
- Changing the owner ruling that the Executive Summary is one continuous
  section without internal headings.
- Revalidating SSEL mathematics, VMD, gmsp products, scenario products, or
  numerical metrics.
- Editing tables, builders, pipelines, data products, references, Book,
  RevealJS, styles, or `format.qmd`.

## Verdict

The English text is mostly grammatical sentence by sentence, but the assembled
document is not acceptable as a professional executive summary. The primary
defect is not the absence of internal headings. The headings were removed
without re-authoring the former four section blocks as one narrative. The
result is four short methodology chapters concatenated in sequence, with
repeated introductions, delayed results, weak transitions, and no continuous
engineering argument.

Functionally, after the lead, the body allocates fourteen paragraphs to method
or pending-state description and six paragraphs to project results. This is a
content imbalance, not a word-count ruling. Important detail must remain when
needed to explain what was done; the present text instead retains several
chapter-level mechanics while leaving the engineering meaning of the reported
results largely unstated.

## Diagnostic Findings

### D1 — The section-removal operation exposed unrewritten seams

`summary.en.qmd` now calls the Records, Model, Scenarios, and Risk blocks with
no headings and no transition prose. Each block restarts the subject:

- “The dynamic analysis uses...”;
- “The multi-response model estimates...”;
- “A dynamic-demand scenario comprises...”;
- “The proposed formulation relates...”.

These are four openings, not successive movements of one summary. The proper
continuous sequence is evidence -> prediction -> record suite -> dynamic and
reliability application. The output of each movement must become the stated
input of the next; removing headings alone does not create that relation.

### D2 — Results are subordinated to methodology

The Records block presents four methodological paragraphs before reporting the
86 records, 258 component histories, 68 records with contractor metadata, and
the amplitude statistics. The Model block presents four methodological
paragraphs before reporting OOF performance. The Scenarios block presents
three methodological paragraphs before reporting the 36 scenarios and 3,096
realizations. Risk has three methodology/status paragraphs and no result.

The executive reading is therefore delayed repeatedly. Each movement should
combine only the method necessary to interpret its project result, then state
the result and its consequence.

### D3 — Chapter-level mechanics contaminate the memo

The following items may be valid in the detailed chapters but are overexposed
in the current executive narrative:

- `K=10`, IMF1, IMF2--IMF10, zero central frequency, and the decomposition
  closure difference;
- five-fold mechanics, inverse-OOF-RMSE weighting, the complete learner list,
  the independent `t=0` state, Jacobi updates, and companion responses fixed at
  `t-1`;
- the full component-wise scaling and horizontal principal-direction
  transformation procedure;
- the detailed future estimator for conditional failure probability and the
  separation rule for performance criteria.

This is not a blanket prohibition on methodology or equations. OOF is central
to the credibility of the predictive performance, and the relation between
PPV targets and the calibrated three-component record suite is central to the
deliverable. Those ideas must remain, but at the level required to explain the
results rather than reproduce the chapter formulation.

### D4 — Repetition replaces continuity

The assembled document introduces or explains the following more than once:

- source-to-receptor distance and MIC;
- the IMPALA/S11D combined sample and its transferability assumption;
- PPV and PPA;
- component scaling from source histories to PPV targets;
- predictive levels;
- OOF observation--prediction pairs.

The Records block already describes the scenario scaling later described in
the Scenarios block. The Model block restates the sample already defined in
Records. The result is patchwork autonomy at block level rather than autonomy
at document level.

### D5 — Residual audit, implementation, and delivery language

Several expressions expose internal validation or workflow reasoning instead
of the engineering study:

- “The quantitative deliverable concludes...”;
- records “delivered to” another model;
- “retained formulation” and “independent `t=0` formulation” used repeatedly
  as if they were client-facing product names;
- “companion responses fixed at `t-1`”;
- “not inferred from architectural complexity”;
- “The identity of the source time history ... remain associated”;
- “one per scenario--source-record combination”.

Traceability, equal-cohort comparison, and absence of leakage are legitimate
technical obligations. The memo should express the resulting evidence, not
narrate the audit contract or the organization of intermediate products.

### D6 — Professional English is syntactically sound but often unnatural

Representative constructions that require re-authoring rather than local word
substitution are:

- “integrated blast-induced dynamic-demand model” — excessive modifier stack;
- “The quantitative deliverable concludes...” — contractual/project-management
  voice;
- “complete instrumental population” — unnatural collocation;
- S11D observations “admitted only where...” — procedural/legalistic voice;
- “physical predictions” — unclear shorthand for back-transformed predictions
  in physical units;
- PPV targets “feed scenario construction” — mechanical wording;
- records “delivered to the dynamic deformation model” — workflow language.

The issue is not isolated grammar. Local polishing would preserve the defective
narrative functions.

### D7 — Numbers are reported without an executive interpretation

The memo reports record counts, coverage ranges, empirical amplitudes, OOF
`R^2`, physical-unit RMSE, improvement relative to `t=0`, scenario counts, and
PPV target ranges. It rarely states what those results mean:

- which response controls or performs least strongly;
- what the OOF improvement establishes about the multi-response refinement;
- how the prediction evidence supports use of the p90 targets;
- what the scenario ranges represent in relation to the evaluated blasting
  conditions;
- what has been completed for engineering use and what remains unavailable.

The paragraph following the model metrics says that the comparison “supports”
the predictive levels but does not connect reduced RMSE and increased `R^2` to
the reliability objective or to the distance/MIC conditions that can be
evaluated at a target probability of failure.

### D8 — The executive tables are not integrated into the narrative

The two tables appear without a preceding interpretive sentence and largely
repeat the immediately preceding prose.

The model prose reports ranges over all eight responses. The DOCX table then
shows the PPV response family and only the resultant PPA. That narrower scope
is stated in the caption but not motivated in the narrative, so the reader
cannot map the reported PPA range to the displayed rows. The caption is itself
a compact methods section: it defines common OOF pairs, physical units,
`Delta RMSE`, `Delta R2`, `t=0`, and why components were retained.

The scenarios paragraph and its table repeat the same 36-scenario grid, 3,096
realizations, and PPV component ranges. The prose uses `p90`; the table caption
uses `p = 0.90`. One representation should carry the principal result and the
other should add information, not duplicate it.

### D9 — Notation changes without executive need

The prose introduces lowercase `d` and `q`, then the table uses `D` and `MIC`.
The scaled-distance expression uses `q`, although the report convention treats
charge and its observations carefully. The memo does not require this notation
unless the expression is retained as essential mathematics. If retained, its
symbols and random-variable/observation role must agree with the approved model
chapter and SSEL notation; otherwise distance, MIC, and scaled distance should
be stated in words.

The predictive level also changes from `p90` in prose to `p = 0.90` in the
table. PPV, PPA, and MIC are expanded repeatedly because the former blocks were
written as locally autonomous sections.

### D10 — The Risk movement is disproportionately methodological

Risk has no quantitative result at this stage. Three paragraphs describe the
future plane-strain effective-stress response, comparison with capacity,
weighted exceedance fraction, reliability index, separate criteria, missing
capacities, and missing weights.

The executive finding is narrower: the scenario-conditioned reliability
formulation is defined, while probabilities of failure, reliability indices,
and acceptability conclusions remain pending the dynamic responses, approved
capacities/criteria, and realization weights. The equation for `beta` may
remain if the owner judges it essential to identify the reported risk measure;
the surrounding future methodology should not dominate the closing movement.

### D11 — The lead inventories the study but does not lead with findings

The opening paragraph names all four work fronts in one long sentence, then
states that the “quantitative deliverable concludes” with time histories. It
does not state the headline evidence: database size and coverage, predictive
performance/improvement, calibrated-suite size and amplitude range, or the
boundary that quantitative reliability results are not yet available.

It reads as a table of contents in prose. A professional lead should establish
the engineering purpose, identify what has been completed, state the main
quantitative outcomes, and define the remaining decision boundary.

## What Is Technically Worth Preserving

The diagnosis does not reject the substantive core:

- the measured particle-velocity histories and their coherent derived motions;
- the separation between the full waveform population and the subset with
  contractor-reported distance/MIC;
- the IMPALA/S11D provenance and transferability assumption;
- the eight PPV/PPA responses and the role of component PPV in scaling;
- OOF evaluation, the independent reference formulation, and the measured
  improvement of the multi-response refinement;
- empirical predictive levels;
- the three-component calibrated record suite and its component-wise scaling
  caveat;
- the observed counts, ranges, OOF metrics, and scenario inventory;
- the explicit boundary between completed dynamic-demand work and pending
  quantitative reliability results.

The repair is a selection and re-authoring task, not a deletion of important
content and not a rollback to the previously committed prose.

## Required Narrative Architecture

Preserve the owner ruling: one continuous Executive Summary without internal
headings. Re-author it as connected movements:

1. engineering purpose, completed scope, principal outputs, and present limit;
2. instrumental evidence and the project-specific database results;
3. amplitude prediction, essential OOF basis, and predictive-performance
   result;
4. conversion of those predictions into the calibrated three-component record
   suite and its quantitative inventory;
5. role of the suite in the dynamic and reliability analysis;
6. explicit statement of the inputs still required before risk and
   acceptability can be quantified.

Transitions must carry the analytical dependency: “Using this database...”,
“The resulting predictions...”, “These targets define...”, and “The resulting
time histories provide...”. These are functions, not mandatory literal
phrases.

Each table must be introduced by a sentence that states the engineering result
it substantiates. Decide the table scope before rewriting: either show the same
response family summarized in the prose or explain the deliberate executive
selection. Remove duplicated prose/table inventories and use one `p90`
convention.

## Rejected Repair Paths

- Restoring internal headings without rewriting: rejected; it hides rather
  than repairs the four-block patchwork.
- Shortening by word count: rejected; compact blocks may be incomplete, while
  longer blocks may carry necessary engineering content.
- Local synonym replacement in EN: rejected; the defects are paragraph
  function and narrative order.
- Rewriting EN independently: rejected; the approved workflow makes ES the
  master and EN its terminology-controlled mirror.
- Rolling back to commit `24cd45c`: rejected by E135-A6y; it restores the
  inherited contamination.
- Removing all equations or all methodological explanation: rejected; OOF and
  the relationship between predictions and the calibrated record suite are
  essential to explain what was done.

## Validation Performed

- Read `summary.en.qmd` and every visible EN include in source form.
- Extracted and read the complete current `docx/summary.en.docx` text.
- Confirmed the document has one section, followed only by References.
- Counted paragraph function: fourteen method/status paragraphs, six result
  paragraphs, one lead, plus two tables.
- Compared the public wording against the technical-writing, executive-summary,
  and English terminology ledgers.
- No public files, builders, data, pipelines, or rendered products were edited.

## Status And Exact Next Step

Diagnostic complete. Public prose remains unchanged. The next step requires
owner approval of the diagnosis and narrative architecture. After approval,
re-author the complete ES Executive Summary as one document, audit it against
the approved chapters and hydrated results, obtain the owner's paragraph-level
verdict, then regenerate EN through the terminology ledger and render one DOCX
canary.
