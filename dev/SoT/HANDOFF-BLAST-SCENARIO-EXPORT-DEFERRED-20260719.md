# Blast scenario export deferred — 2026-07-19

> **E127 correction:** “do not regenerate/export” does not prohibit consuming
> an already complete and coherent `TSW.csv`/`PSW.csv` family. The blanket
> instruction below not to reconnect `scenarios.PSA` was an agent inference,
> not an owner instruction. The live tree is currently mixed only because four
> directories were partially overwritten; see E127 in
> `dev/plan/blast-report/active.md` before using or restoring them.

## Decision

Do not regenerate or export scenario time series to close the Blast report or
RevealJS. The SSEL B006 correction justified refreshing model metrics and
predictions, not rematerializing the 36 scenario histories.

## Preserved products for the report

The report may consume the complete products that predate the interrupted
E125-N3 run:

- `data/audit/summary.csv` for the existing scenario inventory and PPV targets;
- `data/gmsp/F125.Qo.Do.vmd/IMW.csv` for source-history peak velocities;
- `data/records/scenarios/IMW.csv` for the existing aggregated scenario peak
  measures.

These products support the inventory, effective scale-factor diagnostic and
PPA variability diagnostic without exporting new time series.

## Interrupted run

E125-N3 was stopped without a sentinel after completing four cases:

- `F125.D150.Q150.p90`;
- `F125.D200.Q150.p90`;
- `F125.D250.Q150.p90`;
- `F125.D300.Q150.p90`.

The four folders occupy approximately 378 MiB. They are not consumed by the
report-closing builders above. `OVERRIDE` has been restored to `false`.

The pre-run snapshot is:

`/private/tmp/blast-E125-pre-B006.OMJOpq`

Do not delete, restore, complete or audit the four folders without an explicit
owner decision.

## Deferred products

Any figure that requires **refreshed** per-scenario `TSW.csv` or `PSW.csv`
remains deferred. This does not exclude `scenarios.PSA` or the parametric SRS
decks from consuming a restored, internally consistent existing family. Do not
publish the current mixed live tree or select an arbitrary history. A future
scenario refresh still requires its own SoT plan and explicit authorization
because it rematerializes gigabytes of derived histories.

## Consumer audit

The 2026-07-19 read-only crosswalk resolves the apparent contradiction:

- no object currently connected to the public Book or principal `ppt.qmd`
  reads `TSW.csv` or `PSW.csv` directly;
- `scenarios.PSA` is nevertheless an implemented and legitimate public
  consumer of all 36 `PSW.csv` products. It aggregates the median PSA across
  all realizations by scenario, component, and period; it never selected an
  arbitrary record;
- the parameterized TS decks (`TS_AT`, `TS_VT`, `TS_DT`) and PS decks
  (`PS_PSA`, `PS_PSV`, `PS_SD`) were designed as separate RevealJS products.
  Their base builders remain available, but their Blast entrypoints were never
  completed;
- `records.PSA` is a different, rejected pre/post-processing comparison and is
  not a reason to reject `scenarios.PSA`;
- inventory, effective scaling, and PPA variability remain connected through
  the aggregate audit/IMW products derived from the scenario family.

Therefore, “no current direct consumer” is a transient graph fact, not a data
contract or an instruction to remove TSW/PSW products and builders. Preserve
the snapshot, live products, sidecars, `scenarios.PSA`, and the TS/PS builders.
Reconnection waits only for a coherent lineage decision.

## Report-closing boundary

Close Book and RevealJS with:

- existing scenario inventory;
- effective scale factors reconstructed from existing PPV targets and source
  PGV values, matching the scaling relation already used by the official
  runner;
- PPA variability from the existing aggregated `IMW.csv`.

Do not claim that these scenario products were regenerated after B006.
