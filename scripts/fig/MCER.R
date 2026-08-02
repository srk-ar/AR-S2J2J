# nolint start
# ASCETable is produced by `oqt --process --steps mcer` and loaded by
# scripts/setup/global.R (.loadOQ). No in-script rebuild.

Spectrum.target <- "mcer"
P.target <- if (exists("MCERPTarget", inherits = TRUE)) {
  MCERPTarget
} else {
  .currentTarget("p.target")
}

MCER <- .selectASCETable(
  ASCETable,
  "MCER.R",
  idTarget = .currentTarget("ID.target"),
  siteID = .currentTarget("siteID.target"),
  vs30 = Vs30.target,
  p = P.target,
  spectrum = Spectrum.target
)

DATA <- MCER[, .(
  ID    = paste(ID, Vs30, p),
  X     = Tn,
  Y     = SaF,
  style = fifelse(p == "mean", "Solid",       "ShortDashDot"),
  size  = fifelse(p == "mean", THICK_LINE_SIZE, THIN_LINE_SIZE)
)] |> unique()
setorder(DATA, ID, X)

DUP <- DATA[, .N, by = .(ID, X)][N > 1]
if (nrow(DUP)) {
  stop("MCER.R: more than one Sa ordinate found for at least one plotted series/Tn.")
}

PLOT <- buildPlot(
  line.type     = "line",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = Tn.log,
  yAxis.log     = Sa.log,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = DATA
)
rm(DATA, DUP, MCER, P.target)
# nolint end
