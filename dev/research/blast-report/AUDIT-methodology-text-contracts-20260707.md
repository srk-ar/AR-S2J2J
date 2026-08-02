# AUDIT-methodology-text-contracts-20260707

## Purpose

Audit the active methodology ledgers and candidate text after the user questioned the phrase `component-wise scalar scaling`, the location of the TITO support, and the risk of promotional or instructional language.

This file is not public report prose.

## Contract Sources Read

Project contracts:

```text
scripts/gmsp/setup.R::.scaleAT()
scripts/runScenarios.R
scripts/runScenarios.json
data/export/predictions.csv
data/domains/units.json
```

Active methodology text:

```text
dev/research/blast-report/sections/CANDIDATE-amplitude-modelling-opening-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P1-response-surface-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P2-regression-quantiles-20260706.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P3-ppa-scenario-targets-20260707.md
dev/research/blast-report/sections/LEDGER-amplitude-modelling-P4-conditional-ppv-20260707.md
dev/research/blast-report/EVIDENCE-TITO-methodology-support-20260707.md
```

## Project Contract Found

The accepted project-side scenario-generation contract is:

1. read filtered source histories from the selected `InputID`;
2. read scenario predictions `ppaL`, `ppaT`, and `ppaV` from `data/export/predictions.csv` at the selected quantile level;
3. convert PPA units from the model-response units to the target time-history units;
4. compute the source peak acceleration for each source `RecordID` and original component label `OCID`;
5. for each scenario and each original component `L`, `T`, and `V`, compute an effective factor equal to scenario target PPA divided by the corresponding source component peak acceleration;
6. multiply all time-history ordinates for that source record and original component by the effective factor;
7. rotate the scaled `L/T` histories to `H1/H2`, relabel `V` as `UP`, and then compute scenario `TSW`, `IMW`, and `PSW` products.

This contract supports a record-specific and original-component-specific amplitude factor. It does not require the public term `component-wise scalar scaling`.

## Finding 1: Imported Label In P3

The phrase `component-wise scalar scaling` was technically adjacent to the contract but not a project term and not a user-supplied term. It made the public paragraph read as though an external method had been selected, rather than describing the actual project operation.

Correction applied:

- removed `component-wise scalar scaling` from the P3 public paragraph;
- removed public P3 citations to `BommerAcevedo2004` and `WhittakerEtAl2011NISTGCRScaling`;
- kept the P3 public paragraph tied to the project factor equation;
- deferred TITO-supported amplitude-scaling limitations to C04, where full scenario generation is described.

## Finding 2: TITO Was Forced Into P3 Too Early

TITO T7/T10 naturally supports the general statement that multiplying a time history by a constant changes amplitude while retaining the time coordinate and within-record shape. However, P3 is mainly an amplitude-model bridge and not the full scenario-generation method. The natural home for T7/T10 is C04, where the report will describe source histories, original component factors, horizontal rotation, product generation, and limitations.

Correction applied:

- P3 now records TITO as reviewed but not promoted in the public P3 paragraph;
- the TITO support map sends T7/T10 to C04.

## Finding 3: P4 Is Not Yet A Public Result Paragraph

P4 is methodologically plausible from `ssel::chainPipeline()` and `scripts/runChain.R`, but the current working tree does not contain the accepted conditional comparison artifact. Therefore P4 should not be treated as an approved public paragraph until the project supplies or regenerates the accepted chained/conditional outputs.

Correction applied:

- mark P4 as a ledger-only formulation candidate, not a public paragraph ready for assembly;
- avoid adding it to a candidate chapter until the conditional model contract and result artifact are approved.

## Finding 4: Promotional Or Instructional Language

The strongest public-prose issue was not overt promotion; it was imported-method framing. P3 has been corrected. P4 still contains phrases that should be tightened before public use:

```text
This formulation allows...
while preserving out-of-sample error accounting.
```

These are not grossly promotional, but they read as advocacy. A professional report should state the mechanism:

```text
Training rows use out-of-fold estimates for the conditioning quantities, and scenario rows use predicted median responses at the same scenario point.
```

## Current Text Status

```text
CANDIDATE-amplitude-modelling-opening-20260706.md: P1-P2 revised after approved-text audit; P1-P3 require re-approval.
LEDGER-amplitude-modelling-P3-ppa-scenario-targets-20260707.md: corrected after contract audit; no public TITO citation remains.
LEDGER-amplitude-modelling-P4-conditional-ppv-20260707.md: deactivated as public candidate; technical ledger only until accepted conditional model artifacts exist.
EVIDENCE-TITO-methodology-support-20260707.md: updated so TITO support for scaling moves to C04.
```

## Finding 5: Approved P1-P2 Style Audit

P1 and P2 did not contain the P3 error of naming an implied external method. However, two public phrases had the same risk profile:

```text
component-wise responses
This formulation carries model uncertainty into the scenario amplitudes while preserving...
```

The first phrase was too generic for the project contract, which explicitly uses scalar responses and L, T, and V component responses. The second phrase read as an advocacy sentence rather than a mechanism. Both were revised in the active ledgers and candidate section. The revised P1-P2 text now requires re-approval before migration.

## Finding 6: Mathematical Notation Audit

The earlier P2 equation,

```text
Y | x = eta_Y(x) + epsilon_Y
```

is present in the `ssel` theory vignette, but it is a general regression statement. It is not the clearest contract for this project report. The active public candidate now uses the residual-quantile equation that maps directly to `auditQuantiles()` and `predictModel()`: an estimated amplitude at the scenario point plus the empirical out-of-fold residual quantile, bounded below by zero.

The P3 scaling equation is project-specific. It now includes the unit-conversion factor `G` used by `.scaleAT()` and writes the denominator as the source-component peak acceleration. This maps directly to the sequence: read `ppaL/ppaT/ppaV`, convert PPA units, compute source component peaks, compute `eff = SF / PGA`, and multiply the acceleration-history ordinates.

## Finding 7: Remaining Plans And P4 Audit

The remaining active planning files were audited for wording that could leak into public prose. C02 now describes `TSL2PS()` as computing PSA/PSV/SD for each available component, with D50/D100 as derived rotated horizontal components only where the scenario products include them. C03 now uses the residual-quantile equation and the unit-converted PPA scaling equation instead of the generic regression equation and the incomplete scaling ratio. C04 now states the scalar-component scaling operation as unchanged time coordinates plus multiplication of all ordinates by one component factor, avoiding the broader word `preserves`.

P4 remains deactivated as public prose. Its generic conditional-mean equations have been quarantined; no P4 equation is approved for migration until the accepted conditional-model artifact exists.

## Next Corrective Step

Build a C04 ledger from the actual `.scaleAT()` contract before drafting scenario-scaling prose. Use T7/T10, Luco and Bazzurro, and NIST/Bommer-Acevedo only where they naturally support scenario demand histories and scaling limitations.
