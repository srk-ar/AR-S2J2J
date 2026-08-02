# _fig/plotPSA.R — spaghetti plot: PSA all records, one curve per RecordID.
suppressPackageStartupMessages({
  library(data.table)
  library(NGR)
  library(jsonlite)
  library(here)
  library(gmsp)
})

source(here::here("scripts", "tools", "setup.R"))

# ── Schema ───────────────────────────────────────────────────────────────────
InputID <- "F125.Qo.Do.eemd"
DIR     <- "T"    # "L" | "T" | "V"

if (!exists("MID_LINE_SIZE", inherits = FALSE)) MID_LINE_SIZE <- 0.8

# ── Paths + json ─────────────────────────────────────────────────────────────
PATH.in <- here::here("data", "gmsp", InputID)
FILE        <- file.path(PATH.in, sprintf("%s.json", InputID))
json        <- .readJson(FILE)
Fmax        <- .jsonRequire(json, "Fmax", FILE)
XI          <- unlist(.jsonGet(json, "XI", .jsonGet(json, "xi")))[1L]
TargetUnits <- .jsonRequire(json, "TargetUnits", FILE)

# ── Load ─────────────────────────────────────────────────────────────────────
TSW <- fread(file.path(PATH.in, "TSW.csv"))
Cols <- paste(c("AT", "VT", "DT"), DIR, sep = ".")
stopifnot(all(Cols %chin% names(TSW)))
TSL <- gmsp::TSW2TSL(TSW[, c("RecordID", "t", Cols), with = FALSE])
Tn <- 10^seq(log10(.jsonRequire(json, "Tn.min", FILE)),
             log10(.jsonRequire(json, "Tn.max", FILE)),
             length.out = if (.jsonHas(json, "Method")) 50L else 101L)
PSTable <- TSL2PS(.x = TSL, xi = XI, Tn = Tn, output = "PSW")
META <- fread(file.path(PATH.in, "META.csv"))
PSTable <- PSTable[META, on = "RecordID"]

DATA <- PSTable[, .(ID = sprintf("D=%d Q=%d %s", D, Q, RecordID),
                    X = Tn, Y = get(paste("PSA", DIR, sep = ".")),
                    size = MID_LINE_SIZE)][order(X)]

Plot <- NGR::buildPlot(
  line.type     = "spline",
  plot.height   = 1000,
  legend.show   = TRUE,
  legend.layout = "vertical",
  xAxis.log     = TRUE,
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = paste0("PSA(", DIR, ") [", TargetUnits, "/s²]"),
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = DATA)

Plot
htmlwidgets::saveWidget(widget = Plot,
                        file   = file.path(PATH.in, sprintf("PSA-%s.html", DIR)),
                        selfcontained = TRUE)
