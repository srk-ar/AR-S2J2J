# scripts/select/buildIndex.R — rebuild PLAXIS selection indexes for one folder.
#
# Usage:
#   Rscript scripts/select/buildIndex.R data/records/plaxis.F80
#   Rscript scripts/select/buildIndex.R
#
# Without an argument, PATH.out is read from scripts/runSelect.json.

source(here::here("scripts", "tools", "setup.R"))

.readOutputPath <- function(args) {
  if (length(args) >= 1L) return(here::here(args[1L]))
  PATH.cfg <- here::here("scripts", "runSelect.json")
  JSON <- .readJson(PATH.cfg)
  here::here(.jsonRequire(JSON, "PATH.out", PATH.cfg))
}

.readSelectionFiles <- function(PATH.out) {
  FILES <- list.files(PATH.out, pattern = "[.]csv$", full.names = TRUE)
  FILES <- FILES[!basename(FILES) %chin% c("IMW.csv", "unique.csv")]
  if (!length(FILES)) {
    stop(sprintf("select/buildIndex: no record CSV files found under %s.", PATH.out),
         call. = FALSE)
  }

  OUT <- rbindlist(lapply(FILES, function(FILE) {
    Stem <- sub("[.]csv$", "", basename(FILE))
    Parts <- strsplit(Stem, ".", fixed = TRUE)[[1L]]
    if (length(Parts) < 4L) return(NULL)
    data.table(
      FILE       = FILE,
      RecordID   = Parts[1L],
      ID         = Parts[2L],
      DIR        = Parts[3L],
      ScenarioID = paste(Parts[4L:length(Parts)], collapse = "."))
  }), use.names = TRUE)
  if (!nrow(OUT)) {
    stop(sprintf("select/buildIndex: no files match RecordID.ID.DIR.ScenarioID.csv under %s.",
                 PATH.out), call. = FALSE)
  }
  unique(OUT)
}

.writeSelectionIMW <- function(SEL, PATH.out) {
  SCENARIOS <- .readScenarioIndex(here::here("data", "records", "scenarios"))
  SEL <- SCENARIOS[SEL, on = "ScenarioID", nomatch = 0L]
  if (!nrow(SEL)) {
    stop("select/buildIndex: no selected files match known scenario sidecars.",
         call. = FALSE)
  }

  LIST <- lapply(split(SEL, by = "ScenarioID", keep.by = TRUE), function(DT) {
    IMTable <- fread(file.path(DT$PATH.sc[1L], "IMW.csv"))
    IDX <- unique(DT[, .(RecordID, OCID = DIR)])
    OUT <- IMTable[IDX, on = c("RecordID", "OCID"), nomatch = 0L]
    set(OUT, j = "ScenarioID", value = DT$ScenarioID[1L])
    set(OUT, j = "Fmax",       value = DT$Fmax[1L])
    set(OUT, j = "D",          value = DT$D[1L])
    set(OUT, j = "MIC",        value = DT$MIC[1L])
    set(OUT, j = "P",          value = DT$P[1L])
    COLS <- intersect(c("ScenarioID", "Fmax", "D", "MIC", "P",
                        "RecordID", "OCID"), names(OUT))
    setcolorder(OUT, c(COLS, setdiff(names(OUT), COLS)))
    OUT
  })

  COLS <- names(LIST[[1L]])
  OK <- vapply(LIST, function(DT) identical(names(DT), COLS), logical(1L))
  if (!all(OK)) stop("select/buildIndex: selected IMW schemas differ.", call. = FALSE)
  OUT <- rbindlist(LIST, use.names = TRUE)
  fwrite(OUT, file.path(PATH.out, "IMW.csv"))
  message(sprintf("select/buildIndex: %d rows -> %s/IMW.csv", nrow(OUT), PATH.out))
  invisible(OUT)
}

.writeUniqueRecordIndex <- function(SEL, PATH.out) {
  SCENARIOS <- .readScenarioIndex(here::here("data", "records", "scenarios"))
  OUT <- SCENARIOS[SEL, on = "ScenarioID", nomatch = 0L][, .(
    N          = .N,
    Scenario.N = uniqueN(ScenarioID),
    Scenarios  = paste(sort(unique(ScenarioID)), collapse = ","),
    ID.values  = paste(sort(unique(ID)), collapse = ","),
    DIR.values = paste(sort(unique(DIR)), collapse = ","),
    Fmax       = paste(sort(unique(Fmax)), collapse = ","),
    D.min      = min(D, na.rm = TRUE),
    D.max      = max(D, na.rm = TRUE),
    D.values   = paste(sort(unique(D)), collapse = ","),
    MIC.min    = min(MIC, na.rm = TRUE),
    MIC.max    = max(MIC, na.rm = TRUE),
    MIC.values = paste(sort(unique(MIC)), collapse = ",")
  ), by = RecordID][order(-N, RecordID)]

  fwrite(OUT, file.path(PATH.out, "unique.csv"))
  message(sprintf("select/buildIndex: %d unique RecordID -> %s/unique.csv",
                  nrow(OUT), PATH.out))
  invisible(OUT)
}

.args <- commandArgs(trailingOnly = TRUE)
PATH.out <- .readOutputPath(.args)
SEL <- .readSelectionFiles(PATH.out)
.writeSelectionIMW(SEL = SEL, PATH.out = PATH.out)
.writeUniqueRecordIndex(SEL = SEL, PATH.out = PATH.out)
message("select/buildIndex done")
