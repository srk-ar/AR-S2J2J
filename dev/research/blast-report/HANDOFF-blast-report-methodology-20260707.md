# HANDOFF-blast-report-methodology-20260707

## Recovery Entry Point

Start from:

```text
dev/SoT/ACTIVE.md
dev/plan/blast-report/active.md
```

The active topic is the blast-report methodology workspace. Loose historical `PLAN-*`, `AUDIT-*`, and `HANDOFF-*` files are evidence only when this handoff or the active plan points to them.

## Current Objective

Build an English professional report on blast-induced dynamic demand for TSF dynamic response assessment. The report should converge to introduction/motivation, methodology, results, and executive-summary material, then later migrate approved sections to the project report structure following the `psha/scaffold` philosophy.

## Current Public Reading Draft

The current clean reading draft is:

```text
dev/research/blast-report/DRAFT-report-reading-copy-20260707.md
```

Status:

- It is the best current continuous draft.
- It is not approved for migration to `_chapters/`.
- It has one physical line per paragraph, display math with `$$...$$`, inline math with `$...$`, and no ledger/source-map notes embedded in public prose.
- It includes expanded methodology for signal processing, EEMD filtering, intensity measures, SDOF spectra, amplitude modelling, scenario scaling, record selection, result organization, and executive-summary draft text.

## Files To Read First

Read these in order:

```text
dev/plan/blast-report/active.md
dev/research/blast-report/HANDOFF-blast-report-methodology-20260707.md
dev/research/blast-report/DRAFT-report-reading-copy-20260707.md
dev/research/blast-report/GAPS-report-reading-copy-20260707.md
dev/research/blast-report/EVIDENCE-TITO-methodology-support-20260707.md
dev/research/blast-report/AUDIT-methodology-text-contracts-20260707.md
```

Then read the section ledgers only if editing that section:

```text
dev/research/blast-report/sections/CANDIDATE-amplitude-modelling-opening-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P1-response-surface-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P2-regression-quantiles-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P3-ppa-scenario-targets-20260707.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P4-conditional-ppv-20260707.md
```

Use this internal implementation audit only when checking signal-processing mechanics:

```text
scripts/dev/sot/AUDIT-signal-processing-gmsp-2026-07-06.md
```

## Current Useful Evidence

TITO compiled outputs were copied into:

```text
dev/research/blast-report/sources/tito-compiled/
```

Use the manifest first:

```text
dev/research/blast-report/sources/tito-compiled/MANIFEST.md
```

Practical status:

- T1: quarantined; building/human-response criteria are not TSF acceptance criteria.
- T3: conditionally useful for EEMD, superseded by T9 where both overlap.
- T5: high-value for TSF blasting, pore pressure, liquefaction concepts, and demand/response boundary.
- T6: high-value for record-selection metrics, but many claims need primary-source curation.
- T7 and T10: useful for amplitude-scaling limitations and scenario demand history wording.
- T8: useful for TSF guidance framing, with primary-source verification needed.
- T9: preferred source for EEMD/filtering limitations and validation checks.

Raw `Ref###`, `WebSource`, ResearchGate, vendor, Semantic Scholar, and generated KB entries are discovery material only. Public prose uses stable keys in `bib/references.bib`.

## Curated Bibliography Already Added

Current curated keys promoted to `bib/references.bib`:

```text
BommerAcevedo2004
WhittakerEtAl2011NISTGCRScaling
LucoBazzurro2007
BooreBommer2005
HuangEtAl1998EMD
WuHuang2009EEMD
```

These support record-scaling limitations, strong-motion processing limitations, and EMD/EEMD framing. Additional TITO references require curation before public use.

## Current Technical Boundaries

- The project analyzes blast-induced dynamic demand for a TSF with saturated fine tailings.
- The current AR-S2J2J signal-processing path uses EEMD filtering. Do not describe the current project as VMD-filtered.
- VMD and Wave3D/Iduapriem modal attenuation are future-model work, not the current AR-S2J2J processing method.
- The project does not use spectral matching.
- PPA component predictions are the scenario acceleration targets.
- PPV remains a modelled vibration-amplitude response and may be part of conditional modelling, but public RMSE-reduction claims need an accepted baseline-versus-conditional artifact.
- Acceleration histories are demand inputs; pore pressure, cyclic mobility, deformation, and liquefaction-type response are outputs of the later geotechnical model.
- Do not define methods by negation in public prose. Use positive formulations and place exclusions in ledgers or handoff material.

## Future Stage Boundary

The Site A/Site B Wave3D/VMD modal-transfer methodology is future-stage modelling work. It is not the objective of this AR-S2J2J report chapter and must not be used as the basis for current chapter prose. The current chapter describes the measured-record processing, EEMD filtering, amplitude modelling, PPA-based scenario scaling, selection, and result organization already audited for this project.

The future modelling handoff is kept only as separate context for the later agent that will design the Iduapriem/Site A modal-transfer model:

```text
scripts/dev/sot/HANDOFF-agent-wave3d-vmd-modal-attenuation-2026-07-06.md
```

Do not delete that file during report-workspace cleanup. It belongs to a different future modelling agent.

## Current Open Gaps

See:

```text
dev/research/blast-report/GAPS-report-reading-copy-20260707.md
```

Main gaps:

- User must provide IMPAL/TSF site context for the introduction and motivation.
- Conditional PPV comparison artifact is missing; no public claim about PPV RMSE reduction is approved.
- Result-object builders and captions are not yet defined.
- T6 selection-metric claims need primary-source curation before public formulas beyond those already supported by `gmsp` internals.

## Cleanup Performed

Deleted as obsolete or superseded:

```text
dev/research/blast-report/chapter-plans/
dev/research/blast-report/evidence-ledger.md
dev/research/blast-report/sections/S01-scope-boundary-2026-07-06.md
dev/research/blast-report/sections/S02-amplitude-modelling-source-map-2026-07-06.md
scripts/dev/sot/PLAN-report-chapter-architecture-2026-07-06.md
scripts/dev/sot/PLAN-report-longform-methodology-2026-07-06.md
```

Reason: those files were superseded by the current active plan, current reading draft, TITO evidence map, contract audit, and section ledgers. Keeping them as operational plans would contaminate a fresh session with stale instructions.

## Files Intentionally Kept

Kept current report workspace:

```text
dev/SoT/ACTIVE.md
dev/plan/blast-report/active.md
dev/research/blast-report/DRAFT-report-reading-copy-20260707.md
dev/research/blast-report/GAPS-report-reading-copy-20260707.md
dev/research/blast-report/EVIDENCE-TITO-methodology-support-20260707.md
dev/research/blast-report/AUDIT-methodology-text-contracts-20260707.md
dev/research/blast-report/tito-output-audit-2026-07-06.md
dev/research/blast-report/sections/
dev/research/blast-report/sources/tito-compiled/
```

Kept unrelated or supporting `scripts/dev/sot/` material:

```text
scripts/dev/sot/AUDIT-signal-processing-gmsp-2026-07-06.md
scripts/dev/sot/HANDOFF-agent-wave3d-vmd-modal-attenuation-2026-07-06.md
scripts/dev/sot/PLAN-gmsp-modernization-2026-06-23.md
scripts/dev/sot/STATUS-gmsp-trackA-readiness-2026-06-23.md
```

Do not treat these kept `scripts/dev/sot/` files as current report plans. They are implementation or future-model evidence only.

## Next Work

The next useful report task is a paragraph-by-paragraph review of the current reading draft with the user. Start with C01 only after the user supplies site context. If the user wants methodology first, start with C02 signal processing because it already has strong project and library support.

Recommended next command:

```bash
sed -n '1,90p' dev/research/blast-report/DRAFT-report-reading-copy-20260707.md
```

## Validation To Run Before Any Migration

Public draft validation:

```bash
rg -n "\\[\\[|\\b(Candidate|candidate|ledger|SoT|placeholder|pending|must|should|requires|required|user|approve|approval|internal|helper|script|pipeline|workflow|folder|path|CSV|JSON|manual|prototype)\\b|not presented|not a|component-wise scalar scaling|response surface|PLAXIS-compatible|spectral matching|human comfort|building damage" dev/research/blast-report/DRAFT-report-reading-copy-20260707.md
```

Hard-wrap validation:

```bash
awk 'BEGIN{block=0; bad=0} /^```/{block=!block; next} /^\$\$/{block=!block; next} block{next} /^[[:space:]]{2,}[[:alnum:]`$]/ {print FILENAME ":" FNR ":" $0; bad=1} END{exit bad}' dev/research/blast-report/DRAFT-report-reading-copy-20260707.md
```

Citation validation:

```bash
rg -n "\\[@|\\[-@" dev/research/blast-report/DRAFT-report-reading-copy-20260707.md
rg -n "BommerAcevedo2004|WhittakerEtAl2011NISTGCRScaling|LucoBazzurro2007|BooreBommer2005|HuangEtAl1998EMD|WuHuang2009EEMD" bib/references.bib
```

## Final Caution

Do not resume by scanning every old plan or raw TITO session. The current active state is intentionally small. Read the active plan, this handoff, the draft, gaps, evidence map, and only the section ledger being edited.
