# nolint start
DEQ <- DEQTable[ID %in% ID.target & Vs30 %in% Vs30.target & Standard %in% Standard.target & Stage %in% Stage.target]
if (!"p" %in% names(DEQ)) DEQ[, p := "mean"]
if ("siteID" %in% names(DEQ) && exists("siteID.target", inherits = FALSE)) {
    DEQ <- DEQ[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DEQ) && uniqueN(DEQ$siteID, na.rm = TRUE) > 1L

DATA <- DEQ[, .(
    ID = if (SITE_BY) {
        paste0(siteID, " [", Standard, "]", " Class:", Class, " Stage:", Stage, " Vs30=", Vs30, " p:", p)
    } else {
        paste0("[", Standard, "]", " Class:", Class, " Stage:", Stage, " Vs30=", Vs30, " p:", p)
    },
    Y = SaF,
    X = Tn,
    style = fifelse(p == "mean", "Solid", "ShortDashDot"),
    size = fifelse(p == "mean", THICK_LINE_SIZE, THIN_LINE_SIZE)
)][order(X)][order(ID)] |> unique()


# DATA[X == 0, X := 0.001]
DATA <- DATA[order(X)][order(ID)] |> unique()
DUP <- DATA[, .N, by = .(ID, X)][N > 1]
if (nrow(DUP)) {
  stop("DEQ.R: more than one Sa ordinate found for at least one plotted series/Tn.")
}
PLOT <- buildPlot(
    yAxis.label = TRUE,
    line.type = "spline",
    plot.height = 750,
    legend.layout = "horizontal",
    legend.show = TRUE,
    xAxis.log = Tn.log,
    yAxis.log = Sa.log,
    xAxis.log.zero.label = "PGA",
    line.size = MID_LINE_SIZE,
    xAxis.legend = "Tn [s]",
    yAxis.legend = "Sa [g]",
    group.legend = "ID",
    plot.theme = NGR::hc_theme_538_gridlines(),
  fill.legend    = "Total Variability",
    fill.minmax    = TRUE,
    fill.max.size  = THICK_LINE_SIZE, # Envelope line width
    fill.min.size  = THICK_LINE_SIZE, # Envelope line width
    data.lines = DATA
)
rm(DEQ, DATA, SITE_BY, DUP)
