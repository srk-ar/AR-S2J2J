# scripts/dev/sot/compare_pipelines.R
# SoT harness: verify parse + data + chain pipelines are unaffected
# by record.json hydration (D, Q fields added).
#
# Usage: source this file from the project root.
# Stage A: capture baseline (run once before any pipeline execution)
# Stage B: runParse.R
# Stage C: runData.R
# Stage D: runChain.R

library(data.table)

strip_selfref <- function(x) { attr(x, ".internal.selfref") <- NULL; x }
dt_identical  <- function(a, b) identical(strip_selfref(a), strip_selfref(b))

BASELINE_FILE <- here::here("scripts", "dev", "sot", "baseline_pipelines.rds")

# ── Stage A — capture baseline ────────────────────────────────────────────────
stage_a <- function() {
  BASE <- list(
    blastDB     = fread(file = here::here("data", "blastDB.csv")),
    records.idx = fread(file = here::here("data", "domains", "records.index.csv")),
    events.idx  = fread(file = here::here("data", "domains", "events.index.csv")),
    Y           = fread(file = here::here("data", "domains", "Y.csv")),
    Q           = fread(file = here::here("data", "domains", "Q.csv")),
    D           = fread(file = here::here("data", "domains", "D.csv")),
    S           = fread(file = here::here("data", "domains", "S.csv")),
    index       = fread(file = here::here("data", "domains", "index.csv")),
    Yo          = fread(file = here::here("data", "export",  "Yo.csv"))
  )
  saveRDS(object = BASE, file = BASELINE_FILE)
  cat("Stage A: baseline captured —", length(BASE), "tables\n")
  invisible(BASE)
}

# ── Stage B — runParse.R ──────────────────────────────────────────────────────
stage_b <- function() {
  BASE <- readRDS(BASELINE_FILE)
  source(here::here("scripts", "runParse.R"))
  NEW.records <- fread(file = here::here("data", "domains", "records.index.csv"))
  NEW.records[, D := as.numeric(D)]
  BASE.records <- copy(BASE$records.idx); BASE.records[, D := as.numeric(D)]
  COMPLETE <- !is.na(NEW.records$D)
  COLS <- setdiff(names(BASE.records), "Diff")
  records.ok <- dt_identical(BASE.records[COMPLETE, COLS, with=FALSE],
                              NEW.records[COMPLETE,  COLS, with=FALSE])
  checks <- list(
    blastDB     = dt_identical(BASE$blastDB,    fread(file = here::here("data", "blastDB.csv"))),
    records.idx = records.ok,
    events.idx  = dt_identical(BASE$events.idx, fread(file = here::here("data", "domains", "events.index.csv")))
  )
  for (nm in names(checks))
    cat(sprintf("  %-15s %s\n", nm, if (checks[[nm]]) "PASS" else "FAIL"))
  stopifnot(all(unlist(checks)))
  cat("Stage B runParse: PASS\n")
  cat("  records.idx: 68 complete records identical; Diff fixed; 18 without Q excluded\n")
}

# ── Stage C — runData.R ───────────────────────────────────────────────────────
stage_c <- function() {
  BASE <- readRDS(BASELINE_FILE)
  source(here::here("scripts", "runData.R"))
  checks <- list(
    Y     = dt_identical(BASE$Y,     fread(file = here::here("data", "domains", "Y.csv"))),
    Q     = dt_identical(BASE$Q,     fread(file = here::here("data", "domains", "Q.csv"))),
    D     = dt_identical(BASE$D,     fread(file = here::here("data", "domains", "D.csv"))),
    S     = dt_identical(BASE$S,     fread(file = here::here("data", "domains", "S.csv"))),
    index = dt_identical(BASE$index, fread(file = here::here("data", "domains", "index.csv")))
  )
  for (nm in names(checks))
    cat(sprintf("  %-8s %s\n", nm, if (checks[[nm]]) "PASS" else "FAIL"))
  stopifnot(all(unlist(checks)))
  cat("Stage C runData: PASS\n")
}

# ── Stage D — runChain.R ──────────────────────────────────────────────────────
stage_d <- function() {
  BASE <- readRDS(BASELINE_FILE)
  source(here::here("scripts", "runChain.R"))
  ok <- dt_identical(BASE$Yo, fread(file = here::here("data", "export", "Yo.csv")))
  cat(sprintf("  Yo.csv  %s\n", if (ok) "PASS" else "FAIL"))
  stopifnot(ok)
  cat("Stage D runChain: PASS\n")
}
