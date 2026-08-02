# nolint start
IDN_PLOT <- c("ensemble", "rigid", "flexible")
if (!exists("IDn.target") || !length(IDn.target)) IDn.target <- IDN_PLOT
IDn.target <- intersect(as.character(IDn.target), IDN_PLOT)
if (!exists("p.target") || !length(p.target)) p.target <- "mean"
DN_MIN_PLOT <- if (exists("DN_MIN_PLOT", inherits = FALSE)) DN_MIN_PLOT else 1e-4

DN <- DnPlotTable[
  IDg %in% IDg.target & IDn %in% IDn.target &
  ID  %in% ID.target  & TR  == TR.target &
  .matchP(p, p.target)
]
if ("siteID" %in% names(DN) && exists("siteID.target", inherits = FALSE)) {
  DN <- DN[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DN) && uniqueN(DN$siteID, na.rm = TRUE) > 1L
DN <- DN[Dn > DN_MIN_PLOT]

DATA <- DN[, .(
  ID    = if (SITE_BY) paste(siteID, IDn, p) else paste(IDn, p),
  Y     = Dn,
  X     = ky,
  style = fcase(
    IDn == "ensemble", "Solid",
    IDn == "flexible", "Dash",
    IDn == "rigid", "ShortDashDot",
    default = "ShortDashDot"
  ),
  size  = fifelse(as.character(p) == "mean", THICK_LINE_SIZE, THIN_LINE_SIZE)
)][order(X)][order(ID)] |> unique()

DUP <- DATA[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) {
  stop("Dn.R: more than one displacement ordinate found for at least one plotted series/ky.")
}

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  yAxis.min     = DN_MIN_PLOT,
  xAxis.legend  = "ky [g]",
  yAxis.legend  = "Dn [cm]",
  group.legend  = "IDn / p",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = DATA
)
rm(DN, DN_MIN_PLOT, DATA, DUP, SITE_BY, IDN_PLOT)
# nolint end
