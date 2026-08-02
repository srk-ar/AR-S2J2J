# _fig/plotIMF.R — IMFs + reconstruction + per-mode response spectra
# for ONE record × one OCID.

suppressPackageStartupMessages({
  library(data.table)
  library(NGR)
  library(gmsp)
  library(here)
  library(jsonlite)
})

source(here::here("scripts", "tools", "setup.R"))

# ── Schema ──────────────────────────────────────────────────────────────────
OutputID        <- "F50.Qo.Do.eemd"
DIR             <- "L"
RecordID.target <- "8fd025db4109b656"

if (!exists("MID_LINE_SIZE",   inherits = FALSE)) MID_LINE_SIZE   <- 1.5
if (!exists("THICK_LINE_SIZE", inherits = FALSE)) THICK_LINE_SIZE <- 3.5

# ── Paths + json ─────────────────────────────────────────────────────────────
PATH.in <- here::here("data", "gmsp", OutputID)
FILE        <- file.path(PATH.in, sprintf("%s.json", OutputID))
json        <- .readJson(FILE)
xi          <- unlist(.jsonRequire(json, "XI", FILE))[1L]
TargetUnits <- .jsonRequire(json, "TargetUnits", FILE)
Fmax        <- .jsonRequire(json, "Fmax", FILE)
kNyq        <- .jsonRequire(json, "kNyq", FILE)
Tn.grid     <- 10^seq(log10(.jsonRequire(json, "Tn.min", FILE)),
                      log10(.jsonRequire(json, "Tn.max", FILE)), length.out = 101)

# ── Load ─────────────────────────────────────────────────────────────────────
TSW   <- fread(file.path(PATH.in, "IMF.csv"))[RecordID == RecordID.target & OCID == DIR]
TSW.R <- fread(file.path(PATH.in, "TSW.csv"))

COLS <- grep("^IMF[0-9]+$", names(TSW), value = TRUE)
COLS <- COLS[vapply(COLS, function(COL) any(!is.na(TSW[[COL]])), logical(1L))]
TS   <- melt(TSW[, c("t", "signal", COLS), with = FALSE],
             id.vars = "t", variable.name = "mode", value.name = "s")

# ── Per-IMF spectra ───────────────────────────────────────────────────────────
PSW <- TS[, {
  W <- .SD[, .(t, s)]
  setnames(W, "s", .BY$mode)
  TSL <- AT2TS(W, units.source = TargetUnits, Fmax = Fmax, kNyq = kNyq,
               units.target = TargetUnits, isRaw = FALSE,
               output = "TSL")
  TSL2PS(.x = TSL, xi = xi, Tn = Tn.grid, output = "PSW")
}, by = .(mode), .SDcols = c("t", "s")]

COLS.R <- paste(c("AT", "VT", "DT"), DIR, sep = ".")
stopifnot(all(COLS.R %chin% names(TSW.R)))
TSL.R <- gmsp::TSW2TSL(TSW.R[RecordID == RecordID.target,
                              c("RecordID", "t", COLS.R), with = FALSE])
PSW.R <- TSL2PS(.x = TSL.R, xi = xi, Tn = Tn.grid, output = "PSW")

# ── Comparison PSA: signal (original) vs filtered ────────────────────────────
AUX   <- PSW[  mode == "signal", .(Tn, S = PSA.signal)][order(Tn)]
AUX.R <- PSW.R[, .(Tn, S = get(paste("PSA", DIR, sep = ".")))][order(Tn)]

# ── Plots ─────────────────────────────────────────────────────────────────────
DATA <- rbindlist(list(
  TS[mode == "signal", .(X = t, Y = s, ID = "signal", style = "Dashed", size = THICK_LINE_SIZE)],
  TS[mode != "signal", .(X = t, Y = s, ID = mode,     style = "Solid",  size = MID_LINE_SIZE)]
), use.names = TRUE)
PLOT_IMF <- NGR::buildPlot(
  line.type = "line", legend.show = TRUE, legend.layout = "horizontal",
  xAxis.legend = "t [s]", yAxis.legend = paste0("AT(", DIR, ") [", TargetUnits, "/s²]"),
  data.lines = DATA)

DATA <- rbindlist(list(
  AUX[,   .(X = Tn, Y = S, ID = "signal",  style = "Dashed", size = THICK_LINE_SIZE)],
  AUX.R[, .(X = Tn, Y = S, ID = OutputID,  style = "Solid",  size = MID_LINE_SIZE)]
), use.names = TRUE)
PLOT_PSA <- NGR::buildPlot(
  line.type = "spline", plot.height = 750,
  legend.layout = "horizontal", legend.show = TRUE, group.legend = "ID",
  xAxis.log = TRUE, xAxis.legend = "Tn [s]",
  yAxis.legend = paste0("PSA(", DIR, ") [", TargetUnits, "/s²]"),
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA)

.specPlot <- function(col, ylab) {
  DATA <- rbindlist(list(
    PSW[mode == "signal", .(X = Tn, Y = get(col), ID = "signal",
                            style = "Dashed", size = THICK_LINE_SIZE)][order(X)],
    PSW[mode != "signal", .(X = Tn, Y = get(col), ID = mode,
                            style = "Solid",  size = MID_LINE_SIZE)][order(X)]
  ), use.names = TRUE)
  NGR::buildPlot(
    line.type = "spline", plot.height = 750,
    legend.layout = "horizontal", legend.show = TRUE, group.legend = "ID",
    xAxis.log = TRUE, xAxis.legend = "Tn [s]", yAxis.legend = ylab,
    plot.theme = NGR::hc_theme_538_gridlines(),
    data.lines = DATA)
}
PLOT_PSA_IMF <- .specPlot("PSA.signal", paste0("PSA(", DIR, ") [", TargetUnits, "/s²]"))
PLOT_PSV_IMF <- .specPlot("PSV.signal", paste0("PSV(", DIR, ") [", TargetUnits, "/s]"))
PLOT_SD_IMF  <- .specPlot("SD.signal",  paste0("SD(",  DIR, ") [", TargetUnits, "]"))

htmlwidgets::saveWidget(PLOT_IMF,     file.path(PATH.in, sprintf("IMF-%s.html",     DIR)), selfcontained = TRUE)
htmlwidgets::saveWidget(PLOT_PSA,     file.path(PATH.in, sprintf("PSA-%s.html",     DIR)), selfcontained = TRUE)
htmlwidgets::saveWidget(PLOT_PSA_IMF, file.path(PATH.in, sprintf("PSA-IMF-%s.html", DIR)), selfcontained = TRUE)
