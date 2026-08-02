## scripts/ssel/runModel.R — AR-S2J2J single-pass supervised pipeline.
## Usage: Rscript scripts/ssel/runModel.R [path/to/manifest.json]

library(jsonlite)
library(ssel)

# ── Schema (immutable, from manifest) ──────────────────────────────────────
.args <- commandArgs(trailingOnly = TRUE)
PATH.manifest <- if (length(.args) >= 1L) .args[1] else "scripts/manifest.json"
stopifnot(file.exists(PATH.manifest))
M  <- fromJSON(PATH.manifest, simplifyVector = TRUE, simplifyDataFrame = FALSE)

KEY        <- M$key
RESPONSES  <- M$responses$names
DATASETS   <- names(M$datasets)
BOUNDS_MIN <- if (!is.null(M$responses$bounds$min)) M$responses$bounds$min else -Inf
BOUNDS_MAX <- if (!is.null(M$responses$bounds$max)) M$responses$bounds$max else  Inf

# ── Runtime paths ──────────────────────────────────────────────────────────
PATH.DATASETS <- "data/datasets"
PATH.TRAIN    <- "data/train"
PATH.MODEL    <- "data/model"
PATH.METRICS  <- "data/metrics"
PATH.RESPONSE <- "data/response"
PATH.SUMMARY  <- "data/summary"
PATH.EXPORT   <- "data/export"

# ── Runtime config ─────────────────────────────────────────────────────────
COLS.ID  <- character(0)
SET_COL  <- "set"
METHODS  <- c("ranger", "earth", "gbm", "gamSpline", "glm")
SEED     <- 42L
ENSEMBLE <- "ensemble.RMSE"

# ── Phase 1: project-side data pipeline ────────────────────────────────────
source("scripts/runData.R")

# ── Phase 2: ssel supervised ───────────────────────────────────────────────
modelPipeline(
  .path.datasets = PATH.DATASETS,
  .path.train    = PATH.TRAIN,
  .path.model    = PATH.MODEL,
  .path.metrics  = PATH.METRICS,
  .path.response = PATH.RESPONSE,
  .path.summary  = PATH.SUMMARY,
  .path.export   = PATH.EXPORT,
  key            = KEY,
  responses      = RESPONSES,
  datasets       = DATASETS,
  colsId         = COLS.ID,
  setCol         = SET_COL,
  methods        = METHODS,
  seed           = SEED,
  ensemble       = ENSEMBLE,
  boundsMin      = BOUNDS_MIN,
  boundsMax      = BOUNDS_MAX
)

# ── Summary ────────────────────────────────────────────────────────────────
suppressPackageStartupMessages(library(data.table))
FILE.m <- file.path(PATH.SUMMARY, "metrics.csv")
if (file.exists(FILE.m)) {
  M.fin <- fread(FILE.m)[method == "ensemble.RMSE",
                          .SD[which.min(rmse)], by = response][order(response)]
  M.fin[, `:=`(rmse = round(rmse, 3), r2 = round(r2, 3))]
  cat(sprintf("\n=== Final metrics (manifest=%s, mode=model) ===\n", PATH.manifest))
  COLS <- intersect(c("response","dataset","rmse","r2"), names(M.fin))
  print(M.fin[, ..COLS])
  cat(sprintf("mean R²: %.4f   mean RMSE: %.4f\n", mean(M.fin$r2), mean(M.fin$rmse)))
}
