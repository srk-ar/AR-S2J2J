# _fig/plotTS.R — time histories (AT/VT/DT) + response spectra (PSA/PSV/SD)
# for one record, three OCIDs (H1/H2/UP) overlaid per panel.

suppressPackageStartupMessages({
  library(data.table)
  library(NGR)
  library(gmsp)
})

source(here::here("scripts", "tools", "setup.R"))

ProcessID   <- "F125.Qo.Do.eemd"
Target      <- "029f3010bc803a7d"   # RecordID; edit to plot another record

if (!exists("THIN_LINE_SIZE",  inherits = FALSE)) THIN_LINE_SIZE  <- 0.75
if (!exists("MID_LINE_SIZE",   inherits = FALSE)) MID_LINE_SIZE   <- 1.5
if (!exists("THICK_LINE_SIZE", inherits = FALSE)) THICK_LINE_SIZE <- 3.5

PATH.in <- here::here("data", "gmsp", ProcessID)

TSW <- fread(file.path(PATH.in, "TSW.csv"))
TSL <- gmsp::TSW2TSL(TSW[RecordID == Target])
OCID <- unique(TSL$OCID)
FILE <- file.path(PATH.in, sprintf("%s.json", ProcessID))
json <- .readJson(FILE)
TargetUnits <- .jsonRequire(json, "TargetUnits", FILE)
Tn   <- 10^seq(log10(.jsonRequire(json, "Tn.min", FILE)),
               log10(.jsonRequire(json, "Tn.max", FILE)),
               length.out = if (.jsonHas(json, "Method")) 50L else 101L)

.getTS <- function(ID) {
  rbindlist(lapply(OCID, function(.dir) {
    Column <- paste(ID, .dir, sep = ".")
    TSW[RecordID == Target, .(X = t, Y = get(Column),
                              ID = .dir, size = MID_LINE_SIZE)]
  }), use.names = TRUE)
}

PSW <- TSL2PS(.x = TSL,
              xi = unlist(.jsonRequire(json, "XI", FILE))[1L],
              Tn = Tn, output = "PSW")

.getPS <- function(ID) {
  COLS <- grep(paste0("^", ID, "[.]"), names(PSW), value = TRUE)
  rbindlist(lapply(COLS, function(Column) {
    PSW[Tn > 0, .(X = Tn, Y = get(Column),
                  ID = sub("^[^.]+[.]", "", Column),
                  size = MID_LINE_SIZE)]
  }), use.names = TRUE)[order(X)]
}

DATA <- .getTS("AT")
PlotAT <- NGR::buildPlot(
  line.type = "line", legend.show = TRUE, legend.layout = "horizontal",
  legend.align = "left",
  xAxis.legend = "t [s]",
  yAxis.legend = paste0("AT(OCID) [", TargetUnits, "/s²]"),
  data.lines = DATA)

DATA <- .getTS("VT")
PlotVT <- NGR::buildPlot(
  line.type = "line", legend.show = TRUE, legend.layout = "horizontal",
  legend.align = "left",
  xAxis.legend = "t [s]",
  yAxis.legend = paste0("VT(OCID) [", TargetUnits, "/s]"),
  data.lines = DATA)

DATA <- .getTS("DT")
PlotDT <- NGR::buildPlot(
  line.type = "line", legend.show = TRUE, legend.layout = "horizontal",
  legend.align = "left",
  xAxis.legend = "t [s]",
  yAxis.legend = paste0("DT(OCID) [", TargetUnits, "]"),
  data.lines = DATA)

DATA <- .getPS("PSA")
PlotPSA <- NGR::buildPlot(
  line.type = "spline",
  plot.height = 1000,
  legend.layout = "horizontal",
  legend.show = TRUE,
  group.legend = "ID",
  plot.theme = hc_theme_538_gridlines(),
  xAxis.log = TRUE, xAxis.legend = "Tn [s]",
  yAxis.legend = paste0("PSA(OCID) [", TargetUnits, "/s²]"),
  data.lines = DATA)

DATA <- .getPS("PSV")
PlotPSV <- NGR::buildPlot(
  line.type = "spline",
  plot.height = 750,
  legend.layout = "horizontal",
  legend.show = TRUE,
  group.legend = "ID",
  plot.theme = hc_theme_538_gridlines(),
  xAxis.log = TRUE, xAxis.legend = "Tn [s]",
  yAxis.legend = paste0("PSV(OCID) [", TargetUnits, "/s]"),
  data.lines = DATA)

DATA <- .getPS("SD")
PlotSD <- NGR::buildPlot(
  line.type = "spline",
  plot.height = 750,
  legend.layout = "horizontal",
  legend.show = TRUE,
  group.legend = "ID",
  plot.theme = hc_theme_538_gridlines(),
  xAxis.log = TRUE, xAxis.legend = "Tn [s]",
  yAxis.legend = paste0("SD(OCID) [", TargetUnits, "]"),
  data.lines = DATA)

PlotPSA
