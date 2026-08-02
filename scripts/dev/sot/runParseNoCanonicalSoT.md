# runParse No-Canonical SoT

Date: 2026-05-24

## Contract

`runParse.R` must not read `data/raw/canonical_table.csv` or any canonical
CSV as a runtime source. The parse source for local blast records is
`~/kashimaDB/gmdb.v2/records/ISEE/*/*/raw.owner/record.json`.
`EventID` is the exact value from that JSON. The old client/index format
`EYYYYMMDDHHMMSS` is not normalized back in.

Current kashimaDB coverage is 86 records total:

- 68 records have hydrated `D/Q`.
- 18 records do not have hydrated `D/Q`; they remain in `records.index.csv`
  with `D = NA`.
- `exportDB.R` exports only complete local records, so `blastDB.csv` is rebuilt
  with 68 `IMPALA` rows.

## Implemented Edits

- `scripts/parse/buildTS.R:20-43`
  - Reads `D` with exact list indexing (`J[["D", exact = TRUE]]`) so missing
    `D` does not partial-match `DateTime`.
  - Reads `EventID` directly from kashimaDB `record.json`; no legacy
    `EYYYYMMDDHHMMSS` conversion.
  - Keeps missing `D` as `NA_real_`.

- `scripts/parse/mergeClientData.R:1-25`
  - Removes the canonical-table read and the audit/compare writer.
  - Validates that `records.index.csv` already has `D` from kashimaDB.
  - Preserves `D = NA` for unhydrated records.

- `scripts/parse/parsePipeline.R:12-41`
  - Requires `parse.dirs.kashimaDB`.
  - Sources `buildTS.R`, `mergeClientData.R`, and `buildEvents.R`.
  - Treats `parse.dirs.records` as optional; legacy staging scripts run only
    when that field is configured.

- `scripts/manifest.json:103-109`
  - Removes `parse.dirs.canonical`.
  - Removes unused parse audit config.
  - Keeps `parse.dirs.kashimaDB` as the runtime record source.

## Verification

Prototype harness:

```sh
Rscript scripts/dev/sot/compareRunParseNoCanonical.R
```

Final result:

- `records.structure`: PASS
- `records.hydrated`: PASS
- `records.missingD`: PASS
- `events.index`: PASS
- `blastDB.other`: PASS
- `blastDB.impalaN`: PASS
- kashimaDB records: 86
- hydrated D/Q: 68
- missing D/Q: 18
- current/prototype `blastDB` IMPALA rows: 68/68

Production run:

```sh
Rscript -e 'options(warn = 1); source("scripts/runParse.R")'
```

Final result:

- `records.index.csv`: 86 rows, 21 events
- D resolved from kashimaDB: 68/86
- `data/blastDB.csv`: 68 `IMPALA` rows, 2324 total rows
- no warnings
