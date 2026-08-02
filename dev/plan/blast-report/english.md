# PLAN — Blast professional English mirror

Date: 2026-07-19

## Objective

Generate the English mirror of the owner-approved Spanish Blast report without
changing its technical content, mathematical formulation, data contracts,
results, or chapter architecture. The English text must read as a professional
engineering report for specialists in blasting, machine learning, and
geotechnical earthquake engineering; it is not a literal translation.

## Authority and boundaries

- The approved Spanish Book is the sole content and architecture master.
- The stale English root and legacy English chapters are inventory evidence,
  not translation sources.
- Every English paragraph must preserve the semantic obligations of its Spanish
  counterpart. Equations, symbols, equation labels, section anchors, citations,
  IDs, units, code, selectors, and hydrated numerical logic remain invariant.
- Public language belongs in `_index`, `_chapters`, `_summary`, `_fig`, `_tbl`,
  and presentation callers. `scripts/fig/*.R`, `scripts/tbl/*.R`, and shared
  `.cell.qmd` fragments remain language-neutral.
- This phase does not execute data, model, postprocessing, or scenario pipelines;
  does not modify SSEL or gmsp; and does not restore or reconnect the E127
  TSW/PSW/PSA front.
- No `data/**` path or pre-existing `dev/BorrarTodaEstaMierda/**` deletion may
  enter a translation commit.

## Exact public surface

### Static chapters

Create the English twins of the nine approved Spanish sources:

- `_chapters/blast.md`
- `_chapters/records.summary.md`
- `_chapters/records.md`
- `_chapters/model.summary.md`
- `_chapters/model.md`
- `_chapters/scenarios.summary.md`
- `_chapters/scenarios.md`
- `_chapters/risk.summary.md`
- `_chapters/risk.md`

### Hydrated summaries and results

Create English twins, preserving all executable expressions and changing only
public strings:

- `_summary/records.executive.qmd`
- `_summary/records.results.qmd`
- `_summary/model.executive.qmd`
- `_summary/model.results.qmd`
- `_summary/scenarios.executive.qmd`
- `_summary/scenarios.results.qmd`
- `_summary/risk.results.qmd`

### Composition

Replace the stale English composition with the approved Spanish graph:

- `_index/blast.qmd`
- `_index/records.qmd`
- `_index/model.qmd`
- `_index/scenarios.qmd`
- `_index/risk.qmd`
- `report.en.qmd`: Records → Predictive Model → Scenarios → Risk.

`_index/attenuation.qmd` is removed from the English root but is not deleted
without a separate graph and history decision. `_index/references.qmd` remains
the existing English references page.

### Connected figures and tables

Audit English public strings only in the productive graph:

- Figures: `records.distributions`, `model.architecture`, `model.domain`,
  `predictions.PPV`, `predictions.PPA`, `residuals.PPV`, `residuals.PPA`,
  `demand.PPV`, `demand.PPA`, `scenarios.scaling`, and `scenarios.response`.
- Tables: `records.descriptors`, `model.support`, `metrics`, and `scenarios`.

The first mandatory reaudits are `_fig/records.distributions.qmd`,
`_fig/model.architecture.qmd`, and `_tbl/metrics.qmd`, whose current English
defaults are abbreviated or semantically behind the approved Spanish callers.

Disconnected or separately ruled objects remain outside this phase:
`conditional.PPV`, public QA/audit, `records.PSA`, `scenarios.PSA`, demand
tables, and the parameterized TS/PS scenario decks.

## Source hierarchy

1. Approved Spanish report text and current project products.
2. Current SSEL documentation and implementation contracts for model terms.
3. Current gmsp/project contracts for signal and scenario terms.
4. Primary or authoritative technical literature recorded in
   `dev/SoT/LEDGER-BLAST-ENGLISH-TERMINOLOGY-20260719.md`.
5. Legacy reports only as contrast; they cannot override the four sources above.

## Execution stages and gates

### E128-A — Terminology and semantic ledger

For blasting, signal processing, SSEL/ML, and geotechnical risk, record the
Spanish source term, approved professional English, rejected literal/calque,
authoritative basis, and allowed scope. Record paragraph obligations for each
chapter before producing its candidate.

Gate: no unresolved central term; no unsupported new claim; no use of a source
beyond what was read.

### E128-B — Static chapter mirror

Translate methodology first, then each independent executive summary. Preserve
all equations, labels, citations, definitions, assumptions, and reported
products. Write public paragraphs as continuous lines and exclude software,
pipeline, QA, marketing, tutorial, and audit language.

Gate: paragraph-level ES↔EN obligation check and exact equation/citation/anchor
parity.

### E128-C — Hydrated blocks and composition

Mirror the executable Spanish indexes and summaries. Translate public text,
captions, errors intended for readers, and connective prose; do not alter data
selection, calculations, result hydration, or fallbacks. Assemble the same five
English index files and the English root.

Gate: the EN include graph matches ES exactly and no silent language fallback
exists.

### E128-D — Product-language audit

Review the productive `_fig`/`_tbl` callers against their Spanish twins and the
terminology ledger. Keep PPV and PPA products separate. Do not duplicate or
translate helpers.

Gate: captions, axes, legends, tabs, column labels, and tooltips are technical
English; helper and cell diffs are zero unless an already-existing public
literal is proven to violate the caller contract and separately approved.

### E128-E — Static validation

- Exact inventories of equation labels, section anchors, citation keys, and
  public product IDs in ES and EN.
- Scan for Spanish residue, calques, implementation vocabulary, hardcoded
  results, and accidental legacy includes.
- QMD/R parsing where applicable and `git diff --check`.
- Read every assembled English chapter in order: executive summary, hydrated
  results, methodology, and detailed results.

### E128-R1 — English Book canary

Register command, cwd, tmux name, closed log, sentinel, baseline artifacts, and
acceptance criteria before running `qrt render report.en.qmd --profile book`.
Watch only the sentinel. On success require code zero, `Output created`, fresh
artifacts, correct English chapter graph, and zero Spanish residue. On failure,
the first diagnostic is limited to 8 KiB.

### E128-R2 — RevealJS language regression

Run `qrt render ppt.qmd --profile revealjs` only after the Book passes and only
because connected English caller strings may change. Apply the same sentinel
protocol and confirm the approved central evidence remains complete.

### E128-F — Independent review and handoff

An independent technical-English pass audits domain terminology, paragraph
function, executive-summary autonomy, and consistency between text, figures,
and tables. The owner receives the fresh Book and RevealJS plus a finite list of
plot tweaks that remain outside the language mirror.

## Acceptance checklist

- Nine static chapter twins, seven hydrated twins, five complete indexes, and a
  current English root exist.
- Chapter order, headings, anchors, equations, citations, and public products
  match the approved Spanish Book.
- ML terms conform to SSEL: base learners, out-of-fold (OOF) predictions,
  response-level ensembles, empirical signed OOF-residual offsets, and the
  response-specific retained iteration. OOF is not called a held-out test.
- Blasting terms distinguish particle-velocity histories, PPV, PPA, MIC,
  source-to-receptor distance, scaled distance, and blast-induced demand.
- `Q` remains a mathematical random variable; MIC remains the engineering field.
- Risk terms distinguish limit state, conditional probability of failure,
  reliability index, demand, and resistance.
- No technical assertion is added merely to make English prose sound complete.
- All public English is professional and affirmative, not instructional,
  promotional, encyclopedic, or an audit of code.
- Book and RevealJS pass the registered render and DOM gates.

## Live state at creation

- No Blast run is active.
- Last certified artifacts: Book ES E126-R1 PASS and RevealJS E126-R2c PASS.
- English Book has no current artifact and its root is stale.
- E127 scenario spectral products remain a separate owner-decision front.
- The worktree contains pre-existing `data/**` changes and deletions under
  `dev/BorrarTodaEstaMierda/**`; neither belongs to this plan.
