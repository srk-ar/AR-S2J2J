# nolint start
# mergeClientData.R
# Keeps D from records.index.csv as built from kashimaDB raw.owner/record.json.
# canonical_table.csv is not a runtime source. Records missing D remain NA and
# are excluded downstream by exportDB.R.
#
# Expects: .path.domains

FILE <- file.path(.path.domains, "records.index.csv")
if (!file.exists(FILE))
  stop(sprintf("mergeClientData: missing index file: %s", FILE))

DT <- fread(FILE)
if (!"D" %chin% names(DT))
  stop("mergeClientData: records.index.csv must contain D from kashimaDB record.json")

DT[, D := as.numeric(D)]
if (DT[!is.na(D), .N] == 0L)
  stop("mergeClientData: records.index.csv contains no non-NA D values")

setorder(DT, DateTime, FilenameTS)
fwrite(DT, FILE)

cat("records.index: D resolved,", DT[!is.na(D), .N], "/", nrow(DT),
    "with D (source: kashimaDB record.json)\n")
# nolint end
