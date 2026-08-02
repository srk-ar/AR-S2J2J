# PLAN-gmsp-modernization-2026-06-23

## Objective

Two objectives are active.

1. Audit and repair `AR-S2J2J.R` scripts so the pipelines that consume `gmsp`
   work with the current `gmsp` version without deleting or overwriting old
   results.
2. Prepare standalone methodology chapters for stages shared by `AR-SABP0.R`
   and `AR-S2J2J.R`: record selection, signal processing / `runGMSP`,
   spectra / `runPSA`, IMF filtering, spectral match / `runMatch`, and related
   exports/plots where needed.

The two objectives share concepts but must be worked separately: script repair
is validated with harnesses; methodology chapters are validated against source
code, current `gmsp` contracts, and the user-identified TITO research source.

## Scope

- Repository: `AR-S2J2J.R`.
- Active script surface under `scripts/`.
- Existing SoT convention: `scripts/dev/sot/`.
- `gmsp` consumer scripts:
  - `scripts/runGMSP.R`
  - `scripts/gmsp/setup.R`
  - `scripts/runScenarios.R`
  - `scripts/runAudit.R`
  - `scripts/runPlots.R`
  - `scripts/plotTS.R`
  - `scripts/plotPSA.R`
  - `scripts/plotIMF.R`
  - `scripts/select/buildIndex.R`
  - `scripts/select/buildPlots.R`
  - `scripts/runSelect.R`
- Parse path touching `gmdb.v2/records/ISEE`:
  - `scripts/runParse.R`
  - `scripts/parse/*.R`
  - `scripts/manifest.json`
- Documentation surfaces:
  - `README.md`
  - `scripts/README.md`
  - `scripts/AGENTS.md`
  - future standalone methodology chapters.

## Mandatory Reading

Every agent must read these before acting:

- `/Users/averrik/Cloud/github/garage/harness/HARNESS.md`
- `/Users/averrik/Cloud/github/garage/style/AGENTS.md`
- `/Users/averrik/Cloud/github/garage/style/R.md`
- `/Users/averrik/Cloud/github/garage/style/R-data.table.md`
- `/Users/averrik/Cloud/github/garage/style/technical-writing.md`

`AR-S2J2J.R` track must additionally read:

- `scripts/AGENTS.md`
- `scripts/README.md`
- `README.md`
- `scripts/dev/sot/AUDIT-gmsp-consumers-2026-06-23.md`
- `scripts/dev/sot/HANDOFF-agent-scripts-gmsp-2026-06-23.md`

`gmsp` contract references:

- `/Users/averrik/Cloud/github/libraries/gmsp/dev/SoT/ACTIVE.md`
- `/Users/averrik/Cloud/github/libraries/gmsp/dev/plan/database/active.md`
- `/Users/averrik/Cloud/github/libraries/gmsp/dev/plan/parallel-0.5.1.md`
- `/Users/averrik/Cloud/github/libraries/gmsp/examples/scripts/README.md`

`AR-SABP0.R` methodology track must read:

- `/Users/averrik/Cloud/github/projects/AR-SABP0.R/AGENTS.md`
- `scripts/dev/sot/HANDOFF-agent-methodology-2026-06-23.md`
- `scripts/dev/sot/PLAN-methodology-chapters-2026-06-23.md`

`AR-SABP0.R/dev/TITO` is the user-identified source for TITO research. Do not
search for alternative TITO sources.

## Out Of Scope

- No deletion or overwrite under `data/gmsp/`.
- No deletion or overwrite under `data/records/scenarios/`.
- No production `runGMSP.R` or `runScenarios.R` execution without explicit user
  authorization.
- No broad scan of `gmdb.v2/records`.
- No broad read of `TITO/` or other generated research folders.
- No package/library edits in `gmsp` from this repo plan.

## Current Plan

### Track A — Pipeline Alignment And Repair

1. Inventory only code/docs, not data products.
2. Classify scripts as:
   - raw/gmdb producer;
   - processed-signal producer;
   - scenario producer;
   - selector/exporter;
   - plot/audit consumer;
   - project-specific model pipeline.
3. Compare each `gmsp` call with current `gmsp` 0.5.x contracts:
   - `runSelect(raw)` may feed producers;
   - durable processed records live under a `ProcessID`;
   - consumers should use processed selections or produced packages;
   - no `.work` or legacy checkpoint dependency.
4. Build a non-destructive harness plan:
   - copy or reference tiny fixtures only;
   - write all trial outputs to `/private/tmp` or a new explicitly named
     sandbox folder;
   - compare old accepted outputs with new outputs before any replacement.
5. Only after harnesses pass, apply minimal script edits.
6. Preserve old results by writing all tests to `/private/tmp` or a new
   explicitly named candidate output, never over accepted result folders.

### Track B — Shared Methodology Chapters

Prepare a separate written plan for standalone chapters shared by
`AR-SABP0.R` and `AR-S2J2J.R`:

1. Earthquake/record selection criteria.
2. `runGMSP` / `AT2TS` methodology:
   - acceleration to velocity/displacement integration;
   - resampling;
   - flattening;
   - trimming/cropping into time series.
3. IMF filtering methodology:
   - current project usage;
   - VMD equations from TITO research, read only from bounded named files.
4. spectra / `runPSA` methodology:
   - oscillator equation;
   - PSA/PSV/SD definitions;
   - RotD50/RotD100 where used.
5. `runMatch` methodology:
   - target spectrum;
   - multipliers/factors;
   - objective metrics;
   - output interpretation.

Final location is a pending decision. Working drafts must be created as SoT
documents first; approved shared methodology should then be promoted to the
documentation surface that owns the method, not copied as raw TITO research.

## Status

Started. Only bounded repository entrypoints and local instructions have been
read. No generated results were modified.

Status update after external agent reports on 2026-06-23:

- Track A readiness is complete in
  `scripts/dev/sot/STATUS-gmsp-trackA-readiness-2026-06-23.md`;
- Track A found no script repair justified by the bounded harness evidence;
- Track A validated the main AR-S2J2J consumers against a temporary local
  `gmsp` 0.5.1 library and wrote only to `/private/tmp`;
- remaining Track A risks are architectural, not immediate bugs:
  project-local `data/gmsp` caches, private `gmsp:::.getSF()`, and legacy
  raw/index coupling in `.buildTS()`;
- Track B produced the IMF/VMD source map and draft under
  `/Users/averrik/Cloud/github/projects/AR-SABP0.R/dev/SoT`;
- Track B draft is grounded in `gmsp::TS2IMF()` and current IMF runners, not in
  P2 as controlling source;
- Track B must reconcile the `runFilterIMF.R` name in handoff docs with the
  actual current files `runIMF.R` and `runBuildIMFTS.R`;
- Track B source map contains an additional TITO/research search exception; if
  the user did not explicitly authorize that exception, remove it before
  promoting any chapter.

## Completed

- Read `scripts/AGENTS.md`.
- Read top-level `README.md`.
- Listed top-level repo and `scripts/` folder.
- Confirmed git branch is `main` and clean.
- Confirmed existing SoT convention under `scripts/dev/sot/`.

## Pending

- Read `garage/style` files required for this audit:
  - `style/AGENTS.md`
  - `style/R.md`
  - `style/R-data.table.md`
  - `style/technical-writing.md`
- Read bounded script surfaces listed in `Scope`.
- Produce `AUDIT-gmsp-consumers-2026-06-23.md`.
- Produce `PLAN-methodology-chapters-2026-06-23.md`.
- Decide harness names and exact smoke commands.
- Decide final documentation location for approved shared chapters.
- Ask user before any production producer run.

## Agent Handoffs

- `scripts/dev/sot/HANDOFF-agent-scripts-gmsp-2026-06-23.md`
- `scripts/dev/sot/HANDOFF-agent-methodology-2026-06-23.md`
- `scripts/dev/sot/PLAN-methodology-chapters-2026-06-23.md`

Both agents have a readiness gate. Reading the handoff is not sufficient for
editing or drafting. Each agent must first write a short SoT section proving it
understands the relevant scripts, helpers, inputs, outputs, and limits.

## Rejected

- Rejected broad `rg` over `TITO/`: it produced too much output and is not a
  safe way to extract methodology. Future TITO reads must target named files and
  bounded line ranges only.
- Rejected in-place update of generated products during audit.
- Rejected treating project-specific blasting/model pipelines as `gmsp` issues
  before classification.

## Risks

- `AR-S2J2J.R` uses older local wrappers around `gmsp` concepts
  (`buildTS`, `filterTS`, `scaleAT`, EEMD folders) that may not map one-to-one
  to current `gmsp` `ProcessID` workflows.
- Existing user-facing outputs may be deliverables; any overwrite is unsafe.
- Documentation currently mentions legacy raw folders and old `gmsp` cache
  shapes; some text may be historical, not active.
- Methodology chapters need careful source control: TITO research may contain
  large generated prose; read bounded source excerpts only.
- User correction on 2026-06-23: do not store or copy the TITO/VMD research in
  this repo. The source is external to this project at
  `/Users/averrik/Cloud/github/projects/AR-SABP0.R/dev/TITO`.

## Validation

Current validation target for audit-only phase:

- `git status --short --branch`
- parse selected script files only, no data execution;
- JSON parse of active configs;
- no writes outside SoT/audit docs until plan is reviewed.

Future validation target for pipeline modernization:

- old/new output comparison on tiny fixtures;
- no writes to `data/gmsp/` or `data/records/scenarios/`;
- new outputs only under `/private/tmp` unless the user approves a repo
  sandbox folder.

## Exact Next Command

Use only the user-identified TITO source under
`/Users/averrik/Cloud/github/projects/AR-SABP0.R/dev/TITO` when the methodology
chapter work is opened. Do not search for alternative TITO sources or create
new gmsp documentation folders.
