## scripts/ssel/runChain.R — AR-S2J2J iterative chain regressor.
## Usage: Rscript scripts/ssel/runChain.R [path/to/manifest.json]

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

# ── Runtime paths (this experiment) ────────────────────────────────────────
PATH.DATASETS <- "data/datasets"
PATH.TRAIN    <- "data/train"
PATH.MODEL    <- "data/model"
PATH.METRICS  <- "data/metrics"
PATH.RESPONSE <- "data/response"
PATH.SUMMARY  <- "data/summary"
PATH.EXPORT   <- "data/export"
PATH.ITER     <- "data/iter"

# ── Runtime config (this experiment) ───────────────────────────────────────
COLS.ID      <- character(0)
SET_COL      <- "set"
METHODS      <- c("ranger", "earth", "gbm", "gamSpline", "glm")
SEED         <- 42L
ENSEMBLE     <- "ensemble.RMSE"
MAX_ITER     <- 3L
TOL          <- 0.01
PATIENCE     <- 5L
SWEEP        <- "jacobi"
SUFFIX       <- ".o"
CHAIN_GATE   <- "fixed"
CHAIN_THRESH <- 0
CHAIN_STABLE <- 1L
RESUME       <- FALSE

# ── Phase 1: project-side data pipeline (blastDB → domains → datasets) ────
source("scripts/runData.R")

# ── Phase 2: ssel iterative chain ─────────────────────────────────────────
chainPipeline(
  .path.datasets = PATH.DATASETS,
  .path.train    = PATH.TRAIN,
  .path.model    = PATH.MODEL,
  .path.metrics  = PATH.METRICS,
  .path.response = PATH.RESPONSE,
  .path.summary  = PATH.SUMMARY,
  .path.export   = PATH.EXPORT,
  .path.iter     = PATH.ITER,
  key            = KEY,
  responses      = RESPONSES,
  datasets       = DATASETS,
  colsId         = COLS.ID,
  setCol         = SET_COL,
  methods        = METHODS,
  seed           = SEED,
  ensemble       = ENSEMBLE,
  boundsMin      = BOUNDS_MIN,
  boundsMax      = BOUNDS_MAX,
  maxIter        = MAX_ITER,
  tol            = TOL,
  patience       = PATIENCE,
  sweep          = SWEEP,
  suffix         = SUFFIX,
  chainGate      = CHAIN_GATE,
  chainThresh    = CHAIN_THRESH,
  chainStable    = CHAIN_STABLE,
  resume         = RESUME
)

# ── End-of-run summary ─────────────────────────────────────────────────────
FILE.m <- file.path(PATH.SUMMARY, "metrics.csv")
if (file.exists(FILE.m)) {
  M.fin <- fread(FILE.m)[method == "ensemble.RMSE",
                          .SD[which.min(rmse)], by = response][order(response)]
  M.fin[, `:=`(rmse = round(rmse, 3), r2 = round(r2, 3))]
  FILE.m0 <- file.path(PATH.ITER, "metrics_0.csv")
  if (file.exists(FILE.m0))
    M.fin[fread(FILE.m0)[method == "ensemble.RMSE", .SD[which.min(rmse)], by = response],
          r2.0 := round(i.r2, 3), on = "response"]
  cat(sprintf("\n=== Final metrics (manifest=%s, mode=chain) ===\n", PATH.manifest))
  COLS <- intersect(c("response","dataset","rmse","r2","r2.0"), names(M.fin))
  print(M.fin[, ..COLS])
  cat(sprintf("mean R²: %.4f", mean(M.fin$r2)))
  if ("r2.0" %in% names(M.fin))
    cat(sprintf("   baseline R²: %.4f   Δ: %+.4f",
                mean(M.fin$r2.0), mean(M.fin$r2) - mean(M.fin$r2.0)))
  cat(sprintf("   mean RMSE: %.4f\n", mean(M.fin$rmse)))
}
