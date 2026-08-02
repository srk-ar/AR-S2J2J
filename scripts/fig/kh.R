# nolint start
# kh plot (kmaxTable) - Kh vs Da
# Expects from caller/setup:
# - kmaxTable (data.table)
# - TR.target (scalar)
# - IDg.target (scalar)
# - ID.target (vector)
# - Da.target (vector, Da in cm)
# - IDn.target (Newmark selector)

KMT0 <- kmaxTable
if ("siteID" %in% names(KMT0) && exists("siteID.target", inherits = FALSE)) {
  KMT0 <- KMT0[siteID %in% siteID.target]
}
if (!exists("IDn.target") || !length(IDn.target)) IDn.target <- "ensemble"
KMT0 <- KMT0[
  ID %in% ID.target &
    IDg %in% IDg.target &
    TR %in% TR.target &
    Da %in% Da.target &
    IDn %in% IDn.target
][.matchP(p, p.target)]
IDN_MULTI <- uniqueN(KMT0$IDn) > 1L
SITE_BY <- "siteID" %in% names(KMT0) && uniqueN(KMT0$siteID, na.rm = TRUE) > 1L
KMT_BY <- c(if (SITE_BY) "siteID", "IDn", "ID", "TR", "IDg", "Da", "p")

KMT <- KMT0[, .(
  Kh = mean(Kh, na.rm = TRUE)
), by = KMT_BY]

DATA <- KMT[, .(
  ID    = if (SITE_BY && IDN_MULTI) paste(siteID, IDn, p) else if (IDN_MULTI) paste(IDn, p) else if (SITE_BY) paste(siteID, p) else as.character(p),
  Y     = Kh,
  X     = Da,
  style = if (IDN_MULTI) fifelse(IDn == "ensemble", "Solid", fifelse(IDn == "flexible", "Dash", "ShortDashDot")) else fifelse(p == "mean", "Solid", "ShortDashDot"),
  size  = fifelse(p == "mean", THICK_LINE_SIZE, THIN_LINE_SIZE)
)][order(X)][order(ID)]
DATA <- DATA[is.finite(Y)]

PLOT <- buildPlot(
  yAxis.label = TRUE,
  line.type = "spline",
  plot.height = 750,
  legend.layout = "horizontal",
  legend.show = TRUE,
  xAxis.log = TRUE,
  line.size = MID_LINE_SIZE,
  xAxis.legend = "Da [cm]",
  yAxis.legend = "Kh [% PGA]",
  group.legend = if (IDN_MULTI) "IDn / p" else "p",
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA
)
# nolint end
rm(KMT0, KMT, KMT_BY, DATA, SITE_BY, IDN_MULTI)
