# scripts/dev/sot/tools_setup_v2.R — prototype: scripts/tools/setup.R
# No gmsp dependency. Loads NGR + htmlwidgets + lightweight helpers.

suppressPackageStartupMessages({
  library(data.table)
  library(jsonlite)
  library(here)
  library(NGR)
  library(htmlwidgets)
})

if (!exists("MID_LINE_SIZE",  inherits = FALSE)) MID_LINE_SIZE  <- 0.8
if (!exists("THIN_LINE_SIZE", inherits = FALSE)) THIN_LINE_SIZE <- 0.5

.resolveIMF <- function(cols, idx)
  cols[c(idx[idx > 0L], length(cols) + idx[idx < 0L] + 1L)]

.interp2D <- function(Grid, D, MIC, COL) {
  if (D   < min(Grid$D)   || D   > max(Grid$D)   ||
      MIC < min(Grid$MIC) || MIC > max(Grid$MIC)) return(NA_real_)
  MIC.min <- max(Grid$MIC[Grid$MIC <= MIC])
  MIC.max <- min(Grid$MIC[Grid$MIC >= MIC])
  AUX <- Grid[MIC == MIC.min][order(D)]
  V.min <- approx(x = AUX$D, y = AUX[[COL]], xout = D, rule = 1)$y
  if (MIC.min == MIC.max) return(V.min)
  AUX <- Grid[MIC == MIC.max][order(D)]
  V.max <- approx(x = AUX$D, y = AUX[[COL]], xout = D, rule = 1)$y
  V.min + (MIC - MIC.min) / (MIC.max - MIC.min) * (V.max - V.min)
}

.tsw2tsl <- function(.x)
  melt(.x, id.vars = c("RecordID","t"), variable.name = "key", value.name = "s"
  )[, c("ID","OCID") := tstrsplit(key, ".", fixed = TRUE)][, key := NULL]

.tsl2tsw <- function(.x)
  dcast(.x, RecordID + t ~ ID + OCID, value.var = "s", sep = ".")

.plotPSA <- function(InputID, DIR,
                     path = here::here("data", "records", "scenarios")) {
  PATH.in <- file.path(path, InputID)
  J       <- read_json(file.path(PATH.in, sprintf("%s.json", InputID)))
  XI   <- unlist(if (!is.null(J$XI)) J$XI else J$xi)[1L]
  Fmax <- J$Fmax
  PSL  <- fread(file.path(PATH.in, "PSL.csv"))[OCID == DIR & ID == "PSA" & xi == XI & Tn >= 1/Fmax]
  stopifnot(nrow(PSL) > 0L)
  DATA <- PSL[, .(ID = RecordID, X = Tn, Y = S, size = MID_LINE_SIZE)][order(X)]
  PLOT <- NGR::buildPlot(
    line.type = "spline", plot.height = 1000,
    legend.show = TRUE, legend.layout = "vertical",
    xAxis.log = TRUE, xAxis.legend = "Tn [s]",
    yAxis.legend = paste0("PSA(", DIR, ") [", J$TargetUnits, "/s²]"),
    plot.theme = NGR::hc_theme_538_gridlines(),
    data.lines = DATA)
  PLOT$x$hc_opts$series <- lapply(PLOT$x$hc_opts$series, function(s) { s$visible <- FALSE; s })
  htmlwidgets::saveWidget(widget = PLOT,
                          file   = file.path(PATH.in, sprintf("PSA-%s.html", DIR)),
                          selfcontained = TRUE)
  invisible(PLOT)
}

.plotTS <- function(InputID, DIR,
                    path = here::here("data", "records", "scenarios")) {
  PATH.in <- file.path(path, InputID)
  J       <- read_json(file.path(PATH.in, sprintf("%s.json", InputID)))
  TSL  <- .tsw2tsl(fread(file.path(PATH.in, "TSW.csv")))[ID == "AT" & OCID == DIR]
  stopifnot(nrow(TSL) > 0L)
  DATA <- TSL[, .(ID = RecordID, X = t, Y = s, size = THIN_LINE_SIZE)][order(X)]
  PLOT <- NGR::buildPlot(
    line.type     = "line",  plot.height = 1000,
    legend.show   = TRUE,    legend.layout = "vertical",
    xAxis.legend  = "t [s]",
    yAxis.legend  = paste0("AT(", DIR, ") [", J$TargetUnits, "/s²]"),
    plot.theme    = NGR::hc_theme_538_gridlines(),
    data.lines    = DATA)
  PLOT$x$hc_opts$series <- lapply(PLOT$x$hc_opts$series, function(s) { s$visible <- FALSE; s })
  htmlwidgets::saveWidget(widget = PLOT,
                          file   = file.path(PATH.in, sprintf("TS-%s.html", DIR)),
                          selfcontained = TRUE)
  invisible(PLOT)
}

.buildMasterIMW <- function(PATH.out) {
  FOLDERS <- list.files(PATH.out, pattern = "^F", full.names = FALSE)
  LIST <- lapply(FOLDERS, function(ScenarioID) {
    PATH.sc  <- file.path(PATH.out, ScenarioID)
    FILE     <- file.path(PATH.sc, "IMW.csv")
    if (!file.exists(FILE)) return(NULL)
    DT <- fread(FILE)
    JSON.file <- file.path(PATH.sc, sprintf("%s.json", ScenarioID))
    if (file.exists(JSON.file)) {
      J <- read_json(JSON.file)
      set(DT, j = "ScenarioID", value = ScenarioID)
      set(DT, j = "Fmax",       value = J$Fmax)
      set(DT, j = "D",          value = J$D)
      set(DT, j = "MIC",        value = J$MIC)
      set(DT, j = "P",          value = J$P)
    } else {
      AUX <- as.integer(regmatches(ScenarioID, gregexpr("\\d+", ScenarioID))[[1L]])
      set(DT, j = "ScenarioID", value = ScenarioID)
      set(DT, j = "Fmax",       value = AUX[1L])
      set(DT, j = "D",          value = AUX[2L])
      set(DT, j = "MIC",        value = AUX[3L])
      set(DT, j = "P",          value = AUX[4L] / 100)
    }
    DT
  })
  LIST <- LIST[!vapply(LIST, is.null, logical(1L))]
  if (!length(LIST)) stop(sprintf(".buildMasterIMW: no scenario IMW.csv files under %s.", PATH.out))
  COLS <- names(LIST[[1L]])
  OK   <- vapply(LIST, function(DT) identical(names(DT), COLS), logical(1L))
  if (!all(OK)) stop(".buildMasterIMW: IMW schemas differ across scenarios.", call. = FALSE)
  DT <- rbindlist(LIST, use.names = TRUE)
  COLS <- intersect(c("ScenarioID","Fmax","D","MIC","P","RecordID","OCID"), names(DT))
  setcolorder(DT, c(COLS, setdiff(names(DT), COLS)))
  fwrite(DT, file.path(PATH.out, "IMW.csv"))
  message(sprintf(".buildMasterIMW: %d rows -> %s/IMW.csv", nrow(DT), PATH.out))
  invisible(DT)
}
