# nolint start
# Response-spectrum view for one tectonic regime: median spectral
# acceleration of every individual GMPE versus structural period at a
# fixed magnitude, depth, and epicentral-distance cell, with the
# weighted ensemble mixture highlighted. The ensemble 5th and 95th
# percentiles bound a shaded central mixture band (buildPlot fill boundaries
# .min/.max). Consumes GMPETable (one ID per TRT).
if (!exists("ID.target", inherits = FALSE) || length(ID.target) != 1L) {
  stop("GMPE.PSA.R: set scalar ID.target (one TRT grid).", call. = FALSE)
}
if (!exists("Mw.target", inherits = FALSE) || length(Mw.target) != 1L) {
  stop("GMPE.PSA.R: set scalar Mw.target.", call. = FALSE)
}
if (!exists("Repi.target", inherits = FALSE) || length(Repi.target) != 1L) {
  stop("GMPE.PSA.R: set scalar Repi.target.", call. = FALSE)
}
if (!exists("dep.target", inherits = FALSE) || length(dep.target) != 1L) {
  dep.target <- min(GMPETable[ID %in% ID.target, dep])
}
if (!exists("p.target") || !length(p.target)) p.target <- c("0.10", "0.16", "0.50", "0.84", "0.90")

# Snap to the nearest producer distance cell (log grid); idempotent when
# the wrapper already snapped for its caption.
AUX <- sort(unique(GMPETable[ID %in% ID.target, Repi]))
Repi.target <- AUX[which.min(abs(log(AUX) - log(Repi.target)))]
rm(AUX)

DT <- GMPETable[
  ID %in% ID.target & Mw == Mw.target & dep == dep.target & Repi == Repi.target &
    ((model != "ensemble" & .matchP(p, "0.50")) |
     (model == "ensemble" & .matchP(p, unique(c(p.target, "0.05", "0.95")))))
]
if (!nrow(DT)) {
  stop("GMPE.PSA.R: no rows for the selected grid cell.", call. = FALSE)
}

DATA <- DT[, .(
  ID    = fifelse(
    model == "ensemble",
    fifelse(.matchP(p, "0.05"), ".min", fifelse(.matchP(p, "0.95"), ".max", paste("ensemble", p))),
    model
  ),
  X     = Tn,
  Y     = Sa,
  style = fifelse(model == "ensemble", fifelse(.matchP(p, "0.50"), "Solid", "Dash"), "ShortDashDot"),
  size  = fifelse(
    model == "ensemble",
    fifelse(.matchP(p, "0.50"), THICK_LINE_SIZE, THIN_LINE_SIZE),
    MID_LINE_SIZE
  ),
  fill  = model == "ensemble" & .matchP(p, c("0.05", "0.95"))
)][order(X)][order(ID)]

DUP <- DATA[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) {
  stop("GMPE.PSA.R: duplicate ordinates for at least one series/Tn.", call. = FALSE)
}

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 650,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "Model",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  fill.legend   = "5th–95th percentile band",
  fill.min.style = "Dash",
  fill.min.size = THIN_LINE_SIZE,
  fill.max.style = "Dash",
  fill.max.size = THIN_LINE_SIZE,
  data.lines    = DATA
)
rm(DT, DATA, DUP)
# nolint end
