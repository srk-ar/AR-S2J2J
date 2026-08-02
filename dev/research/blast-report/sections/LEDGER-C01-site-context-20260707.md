# report-blast-C01-site-context-20260707

## Section

C01 Introduction, motivation, and dynamic-analysis program of the stage-1 (Impala) blast-demand report.

## Report Purpose

Give the reviewer the site identity, the engineering concern, the stage-1 scope boundary, and the receiving-model description, replacing the IMPAL placeholder wording.

## Sources Read

- `ref/Impala BRPM TSF - Blasting Modelling_Rev1.docx` (SRK Argentina technical-economic proposal, Rev1, 2026-07-03). Project source of truth. Full text read 2026-07-07.
- User caution: the record-selection wording in that proposal may be obsolete or describe stage-2 work (e.g., 700-record calibrated suite, model retraining with new monitoring data, geophone relocation). Do not import those as stage-1 claims.

## Exact Claims Allowed

- The Impala mining operation uses the Northern Concentrator tailings storage facilities, which include the BRPM TSF.
- Production blasting at adjacent mining operations occurs near the BRPM TSF; vibration monitoring has been implemented at the site.
- The broader study objective is to propose practical limits for blasting distance and load (MIC) scenarios that keep the TSF performance uncompromised.
- Stage 1 comprised the calibration of a ground-motion prediction model for peak blast-vibration amplitudes and a preliminary dynamic deformation assessment of the critical section S1; this report covers the demand-development side of stage 1.
- The receiving model is an effective-stress plane-strain (2D) dynamic deformation analysis of critical TSF sections; response quantities include excess pore-pressure ratio $r_u$, shear strains/distortions, and deformation measures.
- Saturated fine tailings; blast loading is short-duration, high-frequency transient vibration, different from conventional seismic design loading.

## Claims Not Allowed

- Any stage-2 content as done work: complementary lab testing (cyclic DSS/triaxial), piezometer/accelerometer monitoring, PM4Sand/HSS recalibration, HeA production catalogue (>600 Q-R cases), reliability framework, safe-threshold recommendations, 700-record calibrated suite, model retraining.
- Naming the analysis software product in public prose (the proposal itself uses plane-strain/constitutive-model wording, not the product name).
- Claiming the deformation assessment results in this demand report; they belong to the geotechnical response reporting.

## Equations Allowed

None new; $r_u$ symbol already in the draft.

## Equations Excluded

All stage-2 reliability formulations (demand-capacity probability of failure); belongs to the future stage-2 report.

## Vocabulary Allowed

BRPM TSF; Northern Concentrator tailings storage facilities; Impala mining operation; production blasting; maximum instantaneous charge (MIC); effective-stress plane-strain dynamic deformation analysis; excess pore-pressure ratio; critical section S1.

## Vocabulary Rejected

- "IMPAL" placeholder (replace).
- "PLAXIS" as public product name in chapter prose (use plane-strain effective-stress wording; product naming may go to an appendix if the user asks).
- "PGA/PPV model" as the amplitude-model name (this repo's trained responses are the PPA and PPV families; keep PPA/PPV).
- Stage-2 phase names (Phase 1/2/3) in stage-1 prose.

## Candidate Public Paragraph Or Section

See the C01 edit set proposed to the user on 2026-07-07 (three edits: site identity sentence, broader-objective sentence, receiving-model wording without product name).

## Candidate Translation Terminology

- tailings storage facility -> deposito de relaves (es); TSF acronym retained.
- maximum instantaneous charge (MIC) -> carga instantanea maxima; MIC acronym retained.
- excess pore-pressure ratio -> razon de exceso de presion de poros.

## Open Gaps

- Confirm with the user whether the client/operator name and BRPM can appear in the public report (the proposal uses them freely, so default yes).
- Figure for site context (satellite image analogous to proposal Figure 1-1) not yet available in this repo.
- Whether the report should mention section E2 (stage-2 scope) at all; default no.

## Validation

Forbidden-term grep and hard-wrap validation run on the public draft after the C01 edits are applied.
