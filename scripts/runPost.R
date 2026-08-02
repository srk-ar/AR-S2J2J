## scripts/runPost.R — thin wrapper over ssel::postProcess.
## Usage: Rscript scripts/runPost.R [path/to/manifest.json]
##
## Reads the project manifest and dispatches to ssel::postProcess(),
## which produces data/export/predictions.csv (wide best + optional
## Transformed twin) and data/export/audit.csv (long disaggregated).
##
## Project-specific behavior lives entirely in manifest$post:
##   location   identity cols to carry (e.g. ["HoleID","From","To"])
##   transform  element-wise op (default identity), e.g.
##              {"op": "log",  "base": 10}
##              {"op": "exp",  "base": 2.71828}
##   normalize  row-wise op (default identity), e.g.
##              {"op": "closure", "target": 100}
##
## Bounds and responses come from manifest$responses.

library(jsonlite)
library(ssel)

.args         <- commandArgs(trailingOnly = TRUE)
PATH.manifest <- if (length(.args) >= 1L) .args[1] else "scripts/manifest.json"
stopifnot(file.exists(PATH.manifest))
M <- fromJSON(PATH.manifest, simplifyVector = TRUE, simplifyDataFrame = FALSE)

ssel::postProcess(
  .path.summary = "data/summary",
  .path.export  = "data/export",
  key           = if (!is.null(M$key)) M$key else "SampleID",
  responses     = M$responses$names,
  location      = M$post$location,
  transform     = M$post$transform,
  normalize     = M$post$normalize,
  boundsMin     = if (!is.null(M$responses$bounds$min)) M$responses$bounds$min else -Inf,
  boundsMax     = if (!is.null(M$responses$bounds$max)) M$responses$bounds$max else  Inf
)
