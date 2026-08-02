# scripts/select/buildPlots.R — build HTML plots for one flat PLAXIS folder.
#
# Usage:
#   Rscript scripts/select/buildPlots.R data/records/plaxis.F80
#   Rscript scripts/select/buildPlots.R data/records/plaxis.F80 FALSE
#   Rscript scripts/select/buildPlots.R
#
# Without an argument, PATH.out is read from scripts/runSelect.json.
# The optional second argument controls overwrite; default is TRUE.

source(here::here("scripts", "tools", "setup.R"))

.readOutputPath <- function(args) {
  if (length(args) >= 1L) return(here::here(args[1L]))
  PATH.cfg <- here::here("scripts", "runSelect.json")
  JSON <- .readJson(PATH.cfg)
  here::here(.jsonRequire(JSON, "PATH.out", PATH.cfg))
}

.readOverride <- function(args) {
  if (length(args) < 2L) return(TRUE)
  OVERRIDE <- as.logical(args[2L])
  if (length(OVERRIDE) != 1L || is.na(OVERRIDE)) {
    stop("select/buildPlots: overwrite argument must be TRUE or FALSE.",
         call. = FALSE)
  }
  OVERRIDE
}

.readSelectionFiles <- function(PATH.out) {
  FILES <- list.files(PATH.out, pattern = "[.]csv$", full.names = TRUE)
  FILES <- FILES[!basename(FILES) %chin% c("IMW.csv", "unique.csv")]
  if (!length(FILES)) {
    stop(sprintf("select/buildPlots: no record CSV files found under %s.",
                 PATH.out), call. = FALSE)
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
    stop(sprintf("select/buildPlots: no files match RecordID.ID.DIR.ScenarioID.csv under %s.",
                 PATH.out), call. = FALSE)
  }
  unique(OUT)
}

.targetUnitLabel <- function(ID, TargetUnits) {
  if (ID == "AT") return(paste0(TargetUnits, "/s²"))
  if (ID == "VT") return(paste0(TargetUnits, "/s"))
  TargetUnits
}

.writeSelectionTSPlot <- function(SEL, PATH.out, JSON, JSON.file,
                                  ScenarioID, ID, DIR, OVERRIDE) {
  FILE.out <- file.path(PATH.out, sprintf("%s.TS-%s-%s.html", ScenarioID, ID, DIR))
  if (!OVERRIDE && file.exists(FILE.out)) return(FALSE)

  DATA <- rbindlist(lapply(seq_len(nrow(SEL)), function(i) {
    DT <- fread(SEL$FILE[i])
    if (!all(c("t", "s") %chin% names(DT))) {
      stop(sprintf("select/buildPlots: invalid TS csv: %s", SEL$FILE[i]),
           call. = FALSE)
    }
    DT[, .(ID = SEL$RecordID[i], X = t, Y = s, size = THIN_LINE_SIZE)]
  }), use.names = TRUE)[order(X)]
  if (!nrow(DATA)) {
    stop(sprintf("select/buildPlots: empty TS data for %s/%s/%s.",
                 ScenarioID, ID, DIR), call. = FALSE)
  }

  Plot <- NGR::buildPlot(
    line.type = "line", plot.height = 1000,
    legend.show = TRUE, legend.layout = "vertical",
    xAxis.legend = "t [s]",
    yAxis.legend = paste0(ID, "(", DIR, ") [",
                          .targetUnitLabel(ID, .jsonRequire(JSON, "TargetUnits", JSON.file)),
                          "]"),
    plot.theme = NGR::hc_theme_538_gridlines(),
    data.lines = DATA)
  Plot$x$hc_opts$series <- lapply(Plot$x$hc_opts$series,
                                  function(Series) { Series$visible <- FALSE; Series })
  htmlwidgets::saveWidget(widget = Plot, file = FILE.out, selfcontained = TRUE)
  TRUE
}

.writeSelectionPSAPlot <- function(SEL, PATH.out, PATH.sc, JSON, JSON.file,
                                   ScenarioID, DIR, OVERRIDE) {
  FILE.out <- file.path(PATH.out, sprintf("%s.PSA-%s.html", ScenarioID, DIR))
  if (!OVERRIDE && file.exists(FILE.out)) return(FALSE)

  FILE.psw <- file.path(PATH.sc, "PSW.csv")
  if (!file.exists(FILE.psw)) {
    stop(sprintf("select/buildPlots: missing PSW.csv for %s.", ScenarioID),
         call. = FALSE)
  }

  Column <- paste("PSA", DIR, sep = ".")
  PSTable <- fread(FILE.psw)
  if (!Column %chin% names(PSTable)) {
    stop(sprintf("select/buildPlots: missing %s in %s.", Column, FILE.psw),
         call. = FALSE)
  }

  XI <- unlist(.jsonGet(JSON, "XI", .jsonGet(JSON, "xi")))[1L]
  if ("xi" %chin% names(PSTable)) PSTable <- PSTable[xi == XI]
  DATA <- PSTable[
    RecordID %chin% SEL$RecordID & Tn >= 1 / .jsonRequire(JSON, "Fmax", JSON.file),
    .(ID = RecordID, X = Tn, Y = get(Column), size = MID_LINE_SIZE)
  ][order(X)]
  if (!nrow(DATA)) {
    stop(sprintf("select/buildPlots: empty PSA data for %s/%s.",
                 ScenarioID, DIR), call. = FALSE)
  }

  Plot <- NGR::buildPlot(
    line.type = "spline", plot.height = 1000,
    legend.show = TRUE, legend.layout = "vertical",
    xAxis.log = TRUE, xAxis.legend = "Tn [s]",
    yAxis.legend = paste0("PSA(", DIR, ") [",
                          .jsonRequire(JSON, "TargetUnits", JSON.file), "/s²]"),
    plot.theme = NGR::hc_theme_538_gridlines(),
    data.lines = DATA)
  Plot$x$hc_opts$series <- lapply(Plot$x$hc_opts$series,
                                  function(Series) { Series$visible <- FALSE; Series })
  htmlwidgets::saveWidget(widget = Plot, file = FILE.out, selfcontained = TRUE)
  TRUE
}

.args <- commandArgs(trailingOnly = TRUE)
PATH.out <- .readOutputPath(.args)
OVERRIDE <- .readOverride(.args)

SEL <- .readSelectionFiles(PATH.out)
SCENARIOS <- .readScenarioIndex(here::here("data", "records", "scenarios"))
SEL <- SCENARIOS[SEL, on = "ScenarioID", nomatch = 0L]
if (!nrow(SEL)) {
  stop("select/buildPlots: no selected files match known scenario sidecars.",
       call. = FALSE)
}

N.TS <- 0L
N.PSA <- 0L
for (ScenarioID.i in sort(unique(SEL$ScenarioID))) {
  SEL.scenario <- SEL[ScenarioID == ScenarioID.i]
  JSON.file <- SEL.scenario$JSON.file[1L]
  JSON <- .readJson(JSON.file)

  for (i in seq_len(nrow(unique(SEL.scenario[, .(ID, DIR)])))) {
    KEY <- unique(SEL.scenario[, .(ID, DIR)])[i]
    SEL.ts <- SEL.scenario[ID == KEY$ID & DIR == KEY$DIR]
    N.TS <- N.TS + .writeSelectionTSPlot(
      SEL = SEL.ts, PATH.out = PATH.out, JSON = JSON, JSON.file = JSON.file,
      ScenarioID = ScenarioID.i, ID = KEY$ID, DIR = KEY$DIR, OVERRIDE = OVERRIDE)
  }

  for (DIR.i in sort(unique(SEL.scenario$DIR))) {
    SEL.psa <- unique(SEL.scenario[DIR == DIR.i, .(RecordID)])
    N.PSA <- N.PSA + .writeSelectionPSAPlot(
      SEL = SEL.psa, PATH.out = PATH.out, PATH.sc = SEL.scenario$PATH.sc[1L],
      JSON = JSON, JSON.file = JSON.file, ScenarioID = ScenarioID.i,
      DIR = DIR.i, OVERRIDE = OVERRIDE)
  }

  unlink(list.files(PATH.out, pattern = "_files$", full.names = TRUE),
         recursive = TRUE)
  message(sprintf("plots %s", ScenarioID.i))
}

message(sprintf("select/buildPlots done — %d TS, %d PSA", N.TS, N.PSA))
