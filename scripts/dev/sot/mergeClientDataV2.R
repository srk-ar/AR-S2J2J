# nolint start
# SoT prototype: keep D from kashimaDB-derived records.index.csv.
# Intentional change: canonical_table.csv is not read and audit/compare.csv is
# not produced.

mergeClientDataV2 <- function(.path.domains) {
  FILE <- file.path(.path.domains, "records.index.csv")
  if (!file.exists(FILE))
    stop(sprintf("mergeClientDataV2: missing index file: %s", FILE))

  DT <- fread(FILE)
  if (!"D" %chin% names(DT))
    stop("mergeClientDataV2: records.index.csv must contain D from kashimaDB record.json")

  DT[, D := as.numeric(D)]
  if (DT[!is.na(D), .N] == 0L)
    stop("mergeClientDataV2: records.index.csv contains no non-NA D values")

  setorder(DT, DateTime, FilenameTS)
  fwrite(DT, FILE)

  cat("records.index: D resolved,", DT[!is.na(D), .N], "/", nrow(DT),
      "with D (source: kashimaDB record.json)\n")
  invisible(DT)
}
# nolint end
