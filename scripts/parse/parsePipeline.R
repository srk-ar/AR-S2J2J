# nolint start
# lib/parse.R — parsePipeline(manifest, parseConfig)
# Domain-specific: raw client data → index tables + blastDB update.
# parse scripts (buildTS.R etc.) are sourced INSIDE parsePipeline where
# path variables are defined — NOT at top level.

library(jsonlite)

source("scripts/parse/setup.R")   # library loads + helper functions only
source("scripts/parse/exportDB.R") # defines exportDB() function

parsePipeline <- function(M, PC) {
  .path.domains    <- M$dirs$domains
  .path.records    <- PC$dirs$records
  .path.kashimaDB  <- PC$dirs$kashimaDB
  GAP.THRESHOLD    <- PC$gapThreshold

  if (is.null(.path.kashimaDB))
    stop("parsePipeline: parse.dirs.kashimaDB is required")

  dir.create(.path.domains, recursive = TRUE, showWarnings = FALSE)

  source("scripts/parse/buildTS.R",         local = TRUE)
  source("scripts/parse/mergeClientData.R", local = TRUE)
  source("scripts/parse/buildEvents.R",     local = TRUE)

  if (!is.null(.path.records)) {
    .path.raw.fixed  <- PC$dirs$fixed
    .path.raw.mobile <- PC$dirs$mobile
    if (is.null(.path.raw.fixed) || is.null(.path.raw.mobile))
      stop("parsePipeline: parse.dirs.fixed/mobile are required only when parse.dirs.records is configured")
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
