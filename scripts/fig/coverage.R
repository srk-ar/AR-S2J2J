# nolint start
# Expects: root

if (!exists("AuditTable"))     AuditTable     <- fread(file.path(root, "data", "audit", "summary.csv"))
if (!exists("SelectionTable")) SelectionTable <- fread(file.path(root, "data", "records", "plaxis", "IMW.csv"))

DT <- unique(AuditTable[, .(X = D, Y = MIC)])
AUX <- unique(SelectionTable[, .(X = D, Y = MIC)])
DT[, ID := "Generated"]
DT[AUX, on = .(X, Y), ID := "Selected for analysis"]

PLOT <- buildPlot(
  line.type     = "line",
  plot.height   = 600,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.legend  = "D [m]",
  yAxis.legend  = "MIC [kg]",
  group.legend  = "ID",
  point.size    = 6,
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.points   = DT
)

if (!exists("CAPTION", inherits = FALSE)) {
  CAPTION <- "Scenario coverage over the distance-charge domain. Every grid point retains multiple source-record realizations; highlighted points feed the selected demand ensemble."
}
rm(DT, AUX)
# nolint end
