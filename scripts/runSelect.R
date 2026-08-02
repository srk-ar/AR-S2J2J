# scripts/runSelect.R — Select N records per scenario and write to PATH.out.
#
# HOW TO USE (human or agent):
#   Preferred: edit scripts/runSelect.json and run:
#     Rscript scripts/runSelect.R
#   Custom config:
#     Rscript scripts/runSelect.R path/to/config.json
#
# Outputs in PATH.out:
#   {RecordID}.{ID}.{DIR}.{ScenarioID}.csv — time-series file per selected record
#   {config}.json                          — copy of the run config
#
# SELECTION STRATEGY:
#   Sample.method = "rank"   — sort by Rank.by (multi-column tiebreak), take top Samples.N
#   Sample.method = "random" — random sample; Rank.by and Rank.dir are ignored
#   Ranking uses the first element of DIR to look up IMW candidates.
#   D.range and MIC.range filter scenario folders before record selection.

source(here::here("scripts", "tools", "setup.R"))

.readRange <- function(value, label) {
  value <- as.numeric(value)
  if (length(value) != 2L || any(is.na(value))) {
    stop(sprintf("runSelect: %s must be a numeric vector of length 2.", label),
         call. = FALSE)
  }
  sort(value)
}

.readCharacterVector <- function(x, label) {
  x <- as.character(x)
  if (!length(x) || any(is.na(x) | !nzchar(x))) {
    stop(sprintf("runSelect: %s must be a non-empty character vector.", label),
         call. = FALSE)
  }
  unique(x)
}

.readIntegerVector <- function(x, label) {
  x <- as.integer(x)
  if (!length(x) || any(is.na(x))) {
    stop(sprintf("runSelect: %s must be a non-empty integer vector.", label),
         call. = FALSE)
  }
  x
}

.readScalarNumber <- function(x, label) {
  x <- as.numeric(x)
  if (length(x) != 1L || is.na(x)) {
    stop(sprintf("runSelect: %s must be one number.", label), call. = FALSE)
  }
  x
}

.readSamplesN <- function(x) {
  x <- as.integer(x)
  if (length(x) != 1L || is.na(x) || x < 1L) {
    stop("runSelect: Samples.N must be one positive integer.", call. = FALSE)
  }
  x
}

.readSampleMethod <- function(x) {
  x <- .readCharacterVector(x, "Sample.method")
  if (length(x) != 1L || !x %chin% c("rank", "random")) {
    stop("runSelect: Sample.method must be 'rank' or 'random'.",
         call. = FALSE)
  }
  x
}

.readRankDir <- function(x) {
  x <- .readCharacterVector(x, "Rank.dir")
  if (length(x) != 1L || !x %chin% c("asc", "desc")) {
    stop("runSelect: Rank.dir must be 'asc' or 'desc'.", call. = FALSE)
  }
  x
}

.checkOutputPath <- function(PATH.out, PATH.scenarios) {
  OUT <- sub("/+$", "", normalizePath(PATH.out, winslash = "/", mustWork = FALSE))
  SRC <- sub("/+$", "", normalizePath(PATH.scenarios, winslash = "/", mustWork = TRUE))
  if (OUT == SRC || startsWith(SRC, paste0(OUT, "/")) ||
      startsWith(OUT, paste0(SRC, "/"))) {
    stop("runSelect: PATH.out cannot be data/records/scenarios or one of its parents/children.",
         call. = FALSE)
  }
  invisible(NULL)
}

.prepareSelectOutput <- function(PATH.cfg, PATH.out, OVERRIDE) {
  if (OVERRIDE && dir.exists(PATH.out)) unlink(PATH.out, recursive = TRUE)
  dir.create(PATH.out, recursive = TRUE, showWarnings = FALSE)
  file.copy(PATH.cfg, file.path(PATH.out, basename(PATH.cfg)), overwrite = TRUE)
  invisible(NULL)
}

.cleanSelectOutput <- function(PATH.out)
  unlink(list.files(PATH.out, pattern = "_files$", full.names = TRUE),
         recursive = TRUE)

.requireColumns <- function(DT, COLS, label) {
  MISSING <- setdiff(COLS, names(DT))
  if (length(MISSING)) {
    stop(sprintf("runSelect: missing %s columns: %s",
                 label, paste(MISSING, collapse = ", ")), call. = FALSE)
  }
  invisible(NULL)
}

.requireNumericColumns <- function(DT, COLS, label) {
  .requireColumns(DT, COLS, label)
  OK <- vapply(COLS, function(Column) is.numeric(DT[[Column]]), logical(1L))
  if (!all(OK)) {
    stop(sprintf("runSelect: non-numeric %s columns: %s",
                 label, paste(COLS[!OK], collapse = ", ")), call. = FALSE)
  }
  invisible(NULL)
}

.requireScenarioFiles <- function(SCENARIOS) {
  FILES <- unlist(lapply(seq_len(nrow(SCENARIOS)), function(i) {
    c(file.path(SCENARIOS$PATH.sc[i], c("IMW.csv", "TSW.csv")),
      SCENARIOS$JSON.file[i])
  }), use.names = FALSE)
  MISSING <- FILES[!file.exists(FILES)]
  if (length(MISSING)) {
    stop(sprintf("runSelect: missing source files:\n%s",
                 paste(MISSING, collapse = "\n")), call. = FALSE)
  }
  invisible(NULL)
}

.preflightSelect <- function(SCENARIOS, DIR, ID,
                             Samples.N, Sample.method, Rank.by) {
  for (i in seq_len(nrow(SCENARIOS))) {
    ScenarioID <- SCENARIOS$ScenarioID[i]
    PATH.sc <- SCENARIOS$PATH.sc[i]
    IMTable <- fread(file.path(PATH.sc, "IMW.csv"))
    .requireColumns(IMTable, c("RecordID", "OCID"), sprintf("%s IMW", ScenarioID))
    if (Sample.method == "rank") {
      .requireNumericColumns(IMTable, Rank.by, sprintf("%s IMW", ScenarioID))
    }

    IMTable <- IMTable[OCID == DIR[1L]]
    if (!nrow(IMTable)) {
      stop(sprintf("runSelect: %s has no IMW rows for OCID=%s.",
                   ScenarioID, DIR[1L]), call. = FALSE)
    }
    RECORDS <- IMTable[, unique(RecordID)]
    if (length(RECORDS) < Samples.N) {
      stop(sprintf("runSelect: %s has %d records; Samples.N=%d.",
                   ScenarioID, length(RECORDS), Samples.N), call. = FALSE)
    }

    TSTable <- fread(file.path(PATH.sc, "TSW.csv"), nrows = 0L)
    TSW.cols <- CJ(ID = ID, DIR = DIR)[, paste(ID, DIR, sep = ".")]
    .requireColumns(TSTable, TSW.cols, sprintf("%s TSW", ScenarioID))
  }
  invisible(NULL)
}

.scenarioFiles <- function(PATH.out, ScenarioID, RECORDS, ID, DIR) {
  CJ(RecordID = RECORDS, ID = ID, DIR = DIR)[
    , file.path(PATH.out,
                sprintf("%s.%s.%s.%s.csv", RecordID, ID, DIR, ScenarioID))]
}

.selectComplete <- function(PATH.out, ScenarioID, RECORDS, ID, DIR) {
  all(file.exists(.scenarioFiles(PATH.out = PATH.out, ScenarioID = ScenarioID,
                                 RECORDS = RECORDS, ID = ID, DIR = DIR)))
}

# ── Config ────────────────────────────────────────────────────────────────────
.args    <- commandArgs(trailingOnly = TRUE)
PATH.cfg <- if (length(.args) >= 1L) .args[1L] else here::here("scripts", "runSelect.json")
stopifnot(file.exists(PATH.cfg))
CFG <- .readJson(PATH.cfg)

PATH.scenarios <- here::here("data", "records", "scenarios")  # read-only
PATH.out       <- here::here(.jsonRequire(CFG, "PATH.out", PATH.cfg))
Fmax           <- .readIntegerVector(.jsonRequire(CFG, "Fmax", PATH.cfg), "Fmax")
P              <- .readScalarNumber(.jsonRequire(CFG, "P", PATH.cfg), "P")
DIR            <- .readCharacterVector(.jsonRequire(CFG, "DIR", PATH.cfg), "DIR")
ID             <- .readCharacterVector(.jsonRequire(CFG, "ID", PATH.cfg), "ID")
Samples.N      <- .readSamplesN(.jsonRequire(CFG, "Samples.N", PATH.cfg))
Sample.method  <- .readSampleMethod(.jsonRequire(CFG, "Sample.method", PATH.cfg))
Rank.by        <- if (Sample.method == "rank") .readCharacterVector(.jsonRequire(CFG, "Rank.by", PATH.cfg), "Rank.by") else character()
Rank.dir       <- if (Sample.method == "rank") .readRankDir(.jsonRequire(CFG, "Rank.dir", PATH.cfg)) else "desc"
D.range        <- .readRange(.jsonRequire(CFG, "D.range", PATH.cfg), "D.range")
MIC.range      <- .readRange(.jsonRequire(CFG, "MIC.range", PATH.cfg), "MIC.range")
OVERRIDE       <- isTRUE(.jsonRequire(CFG, "OVERRIDE", PATH.cfg))

.checkOutputPath(PATH.out = PATH.out, PATH.scenarios = PATH.scenarios)

# ── Pipeline ─────────────────────────────────────────────────────────────────
Fmax.cfg <- Fmax
P.cfg <- P
SCENARIOS <- .readScenarioIndex(PATH.scenarios)[
  Fmax %in% Fmax.cfg & P == P.cfg &
    D >= D.range[1L] & D <= D.range[2L] &
    MIC >= MIC.range[1L] & MIC <= MIC.range[2L]]
setorder(SCENARIOS, Fmax, D, MIC, P, ScenarioID)
if (!nrow(SCENARIOS)) {
  stop("runSelect: no scenarios match Fmax/P/D.range/MIC.range.",
       call. = FALSE)
}
.requireScenarioFiles(SCENARIOS = SCENARIOS)
.preflightSelect(SCENARIOS = SCENARIOS,
                 DIR = DIR, ID = ID, Samples.N = Samples.N,
                 Sample.method = Sample.method, Rank.by = Rank.by)
.prepareSelectOutput(PATH.cfg = PATH.cfg, PATH.out = PATH.out, OVERRIDE = OVERRIDE)

for (i in seq_len(nrow(SCENARIOS))) {
  ScenarioID <- SCENARIOS$ScenarioID[i]
  PATH.sc <- SCENARIOS$PATH.sc[i]

  IMTable <- fread(file.path(PATH.sc, "IMW.csv"))[OCID == DIR[1L]]
  TSTable <- fread(file.path(PATH.sc, "TSW.csv"))

  RECORDS <- IMTable[, unique(RecordID)]
  if (length(RECORDS) < Samples.N) {
    stop(sprintf("runSelect: %s has %d records; Samples.N=%d.",
                 ScenarioID, length(RECORDS), Samples.N), call. = FALSE)
  }
  if (Sample.method == "rank") {
    .requireNumericColumns(IMTable, Rank.by, sprintf("%s IMW", ScenarioID))
  }
  TSW.cols <- CJ(ID = ID, DIR = DIR)[, paste(ID, DIR, sep = ".")]
  .requireColumns(TSTable, TSW.cols, sprintf("%s TSW", ScenarioID))

  Records.sel <- if (Sample.method == "random") {
    sample(RECORDS, Samples.N)
  } else {
    Ranked <- copy(IMTable)
    setorderv(Ranked, cols = Rank.by,
              order = if (Rank.dir == "desc") -1L else 1L)
    Ranked[seq_len(Samples.N), RecordID]
  }

  TSTable.sel <- TSTable[RecordID %in% Records.sel]

  if (!OVERRIDE && .selectComplete(PATH.out = PATH.out, ScenarioID = ScenarioID,
                                   RECORDS = Records.sel, ID = ID, DIR = DIR)) {
    message(sprintf("skip %s", ScenarioID)); next
  }

  # Individual time-series files — one per record × ID × DIR
  for (d in DIR) for (id in ID)
    for (rid in Records.sel) {
      Column <- paste(id, d, sep = ".")
      fwrite(TSTable.sel[RecordID == rid, .(t, s = get(Column))],
             file.path(PATH.out,
                       sprintf("%s.%s.%s.%s.csv", rid, id, d, ScenarioID)))
    }

  .cleanSelectOutput(PATH.out = PATH.out)
  message(sprintf("done %s — %d records [%s]", ScenarioID, Samples.N, Sample.method))
}

.cleanSelectOutput(PATH.out = PATH.out)
message("runSelect done")
