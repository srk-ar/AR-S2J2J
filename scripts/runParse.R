# Raw -> domains parse entry point (one-time / refresh of canonical
# index tables). Wholly project-specific: ssel is not even loaded.

library(jsonlite)

source("scripts/parse/parsePipeline.R")

.args <- commandArgs(trailingOnly = TRUE)
PATH.manifest <- if (length(.args) >= 1L) .args[1] else "scripts/manifest.json"
options(aR.manifest.path = PATH.manifest)
stopifnot(file.exists(PATH.manifest))
M  <- fromJSON(PATH.manifest, simplifyVector = TRUE, simplifyDataFrame = FALSE)
PC <- M$parse

parsePipeline(M, PC)
