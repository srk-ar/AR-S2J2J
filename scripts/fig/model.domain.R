# nolint start
# Expects: PathDataset, PathSources, PathScenarios, GRID_LABEL, GROUP_LEGEND
# and SOURCE_COLORS. Optional: X_AXIS and Y_AXIS. Leaves PLOT for the QMD
# wrapper.

DATA <- fread(
  PathDataset,
  select = c("SampleID", "set", "D", "MIC")
)[set == "train"]
Sources <- fread(PathSources, select = c("SampleID", "Source"))
Scenarios <- fread(
  PathScenarios,
  select = c("ScenarioID", "D", "MIC", "P")
)

if (!nrow(DATA) || DATA[, anyDuplicated(SampleID)] ||
    !nrow(Sources) || Sources[, anyDuplicated(SampleID)] ||
    !setequal(DATA$SampleID, Sources$SampleID)) {
  stop("model.domain.R: QDS training rows and sources are not one-to-one.",
       call. = FALSE)
}
if (DATA[, any(!is.finite(D) | D <= 0 | !is.finite(MIC) | MIC <= 0)] ||
    !nrow(Scenarios) ||
    Scenarios[, any(!is.finite(D) | D <= 0 | !is.finite(MIC) | MIC <= 0 |
                     !is.finite(P) | P <= 0 | P >= 1)] ||
    Scenarios[, uniqueN(P)] != 1L) {
  stop("model.domain.R: distance-charge support is incomplete or invalid.",
       call. = FALSE)
}

DATA[Sources, on = "SampleID", Source := i.Source]
if (DATA[, any(is.na(Source) | !nzchar(Source))]) {
  stop("model.domain.R: at least one training row has no source.",
       call. = FALSE)
}

Grid <- unique(Scenarios[, .(D, MIC)])
if (nrow(Grid) != uniqueN(Grid$D) * uniqueN(Grid$MIC)) {
  stop("model.domain.R: scenario conditions do not form a complete lattice.",
       call. = FALSE)
}

DT <- rbindlist(list(
  DATA[, .(X = D, Y = MIC, ID = Source)],
  Grid[, .(X = D, Y = MIC, ID = GRID_LABEL)]
), use.names = TRUE)

PLOT <- buildPlot(
  line.type = "line",
  data.points = DT,
  xAxis.log = TRUE,
  yAxis.log = TRUE,
  xAxis.legend = if (exists("X_AXIS", inherits = FALSE)) X_AXIS else "D [m]",
  yAxis.legend = if (exists("Y_AXIS", inherits = FALSE)) {
    Y_AXIS
  } else {
    "Q (MIC) [kg]"
  },
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

rm(DATA, DT, Grid, Name, Scenarios, Sources, i)
# nolint end
