# nolint start
# SoT prototype: parsePipeline without canonical_table.csv runtime dependency.
# Intentional changes:
#   1. records.index.csv keeps D from kashimaDB raw.owner/record.json.
#   2. audit/compare.csv is not generated.
#   3. data/records staging is optional and only runs when parse.dirs.records
#      is explicitly configured.

parsePipelineV2 <- function(M, PC) {
  .path.domains    <- M$dirs$domains
  .path.records    <- PC$dirs$records
  .path.kashimaDB  <- PC$dirs$kashimaDB
  GAP.THRESHOLD    <- PC$gapThreshold

  if (is.null(.path.kashimaDB))
    stop("parsePipelineV2: parse.dirs.kashimaDB is required")

  dir.create(.path.domains, recursive = TRUE, showWarnings = FALSE)

  source("scripts/parse/buildTS.R", local = TRUE)
  mergeClientDataV2(.path.domains)
  source("scripts/parse/buildEvents.R", local = TRUE)

  if (!is.null(.path.records)) {
    .path.raw.fixed  <- PC$dirs$fixed
    .path.raw.mobile <- PC$dirs$mobile
    if (is.null(.path.raw.fixed) || is.null(.path.raw.mobile))
      stop("parsePipelineV2: parse.dirs.fixed/mobile are required only when parse.dirs.records is configured")
    source("scripts/parse/buildRecords.R", local = TRUE)
    for (.edir in list.dirs(.path.records, recursive = FALSE, full.names = TRUE))
      system2(file.path(R.home("bin"), "Rscript"),
              c("scripts/parse/parseEvent.R", .edir),
              stdout = FALSE, stderr = FALSE)
    source("scripts/parse/mergeEvent.R", local = TRUE)
  }

  exportDB(PC, .path.domains)

  cat("\nIndices built:\n")
  cat(paste0("  ", list.files(.path.domains, pattern = "\\.csv$")), sep = "\n")
}
# nolint end
