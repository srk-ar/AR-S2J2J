# nolint start
# Expects: PathDataset, PathSources, PathScenarios, GRID_LABEL, GROUP_LEGEND,
# SOURCE_COLORS, X_AXIS and Y_AXIS. Leaves PLOT for the QMD wrapper.

DATA <- fread(
  PathDataset,
  select = c("SampleID", "set", "D", "MIC", "SD")
)[set == "train"]
Sources <- fread(PathSources, select = c("SampleID", "Source"))
Scenarios <- fread(
  PathScenarios,
  select = c("ScenarioID", "D", "MIC", "P")
)
Support <- fread(
  PathDataset,
  select = c("set", "D", "MIC", "SD")
)[set == "predict", .(D, MIC, SD)]

if (!nrow(DATA) || DATA[, anyDuplicated(SampleID)] ||
    !nrow(Sources) || Sources[, anyDuplicated(SampleID)] ||
    !setequal(DATA$SampleID, Sources$SampleID)) {
  stop("model.domain.SD.R: QDS training rows and sources are not one-to-one.",
       call. = FALSE)
}
if (DATA[, any(!is.finite(SD) | SD <= 0 | !is.finite(MIC) | MIC <= 0)] ||
    !nrow(Scenarios) ||
    Scenarios[, any(!is.finite(D) | D <= 0 | !is.finite(MIC) | MIC <= 0 |
                     !is.finite(P) | P <= 0 | P >= 1)] ||
    Scenarios[, uniqueN(P)] != 1L ||
    !nrow(Support) ||
    Support[, anyDuplicated(.SD), .SDcols = c("D", "MIC")] ||
    Support[, any(!is.finite(SD) | SD <= 0)]) {
  stop("model.domain.SD.R: transformed-domain support is invalid.",
       call. = FALSE)
}

DATA[Sources, on = "SampleID", Source := i.Source]
if (DATA[, any(is.na(Source) | !nzchar(Source))]) {
  stop("model.domain.SD.R: at least one training row has no source.",
       call. = FALSE)
}

Grid <- unique(Scenarios[, .(D, MIC)])
if (nrow(Grid) != uniqueN(Grid$D) * uniqueN(Grid$MIC)) {
  stop("model.domain.SD.R: scenario conditions do not form a complete lattice.",
       call. = FALSE)
}
Grid <- merge(Grid, Support, by = c("D", "MIC"), all.x = TRUE, sort = FALSE)
if (Grid[, any(!is.finite(SD) | SD <= 0)]) {
  stop("model.domain.SD.R: scenario conditions have no QDS scaled distance.",
       call. = FALSE)
}

DT <- rbindlist(list(
  DATA[, .(X = SD, Y = MIC, ID = Source)],
  Grid[, .(X = SD, Y = MIC, ID = GRID_LABEL)]
), use.names = TRUE)

PLOT <- buildPlot(
  line.type = "line",
  data.points = DT,
  xAxis.log = TRUE,
  yAxis.log = TRUE,
  xAxis.legend = X_AXIS,
  yAxis.legend = Y_AXIS,
  group.legend = GROUP_LEGEND,
  legend.layout = "vertical",
  legend.align = "right",
  legend.valign = "middle",
  legend.show = TRUE,
  plot.height = 650,
  point.size = 4,
  plot.theme = NGR::hc_theme_538_gridlines()
)

for (i in seq_along(PLOT$x$hc_opts$series)) {
  Name <- PLOT$x$hc_opts$series[[i]]$name
  if (Name %in% names(SOURCE_COLORS)) {
    PLOT$x$hc_opts$series[[i]]$color <- SOURCE_COLORS[[Name]]
  }
  if (identical(Name, GRID_LABEL)) {
    PLOT$x$hc_opts$series[[i]]$marker$radius <- 6
    PLOT$x$hc_opts$series[[i]]$marker$symbol <- "diamond"
    PLOT$x$hc_opts$series[[i]]$zIndex <- 10
  }
}

rm(DATA, DT, Grid, Name, Scenarios, Sources, Support, i)
# nolint end
