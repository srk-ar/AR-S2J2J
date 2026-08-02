# nolint start
# Expects: SCENARIO_PSA, SCENARIO_TARGET_UNITS, OCID.target, MIC.target.

REQ <- c("ScenarioID", "D", "MIC", "P", "OCID", "Tn", "q50", "N")
if (!exists("SCENARIO_PSA", inherits = FALSE) ||
    !data.table::is.data.table(SCENARIO_PSA) ||
    !nrow(SCENARIO_PSA) ||
    length(setdiff(REQ, names(SCENARIO_PSA)))) {
  stop("scenarios.PSA.R: the validated scenario PSA table is unavailable.",
       call. = FALSE)
}
if (!exists("OCID.target", inherits = FALSE) ||
    length(OCID.target) != 1L ||
    !OCID.target %in% c("H1", "H2", "UP")) {
  stop("scenarios.PSA.R: OCID.target must identify H1, H2, or UP.",
       call. = FALSE)
}
if (!exists("MIC.target", inherits = FALSE) ||
    length(MIC.target) != 1L ||
    !is.finite(MIC.target)) {
  stop("scenarios.PSA.R: MIC.target must be one finite charge.",
       call. = FALSE)
}
if (!exists("SCENARIO_TARGET_UNITS", inherits = FALSE) ||
    length(SCENARIO_TARGET_UNITS) != 1L ||
    !nzchar(SCENARIO_TARGET_UNITS)) {
  stop("scenarios.PSA.R: the source length unit is unavailable.",
       call. = FALSE)
}

D.ALL <- sort(unique(SCENARIO_PSA$D))
TN.ALL <- sort(unique(SCENARIO_PSA$Tn))
AUX <- SCENARIO_PSA[
  OCID == OCID.target & abs(MIC - MIC.target) < 1e-12
][order(D, Tn)]
if (!nrow(AUX) ||
    !setequal(unique(AUX$D), D.ALL) ||
    !setequal(unique(AUX$Tn), TN.ALL) ||
    any(!is.finite(AUX$q50)) ||
    any(AUX$q50 <= 0)) {
  stop("scenarios.PSA.R: the requested component-charge panel is incomplete.",
       call. = FALSE)
}

COMPONENT.RANGE <- SCENARIO_PSA[
  OCID == OCID.target,
  range(q50)
]
if (length(COMPONENT.RANGE) != 2L ||
    any(!is.finite(COMPONENT.RANGE)) ||
    any(COMPONENT.RANGE <= 0)) {
  stop("scenarios.PSA.R: common component limits are invalid.", call. = FALSE)
}
LOG.SPAN <- diff(log10(COMPONENT.RANGE))
PAD <- if (is.finite(LOG.SPAN) && LOG.SPAN > 0) 10^(0.03 * LOG.SPAN) else 1

DATA <- AUX[, .(
  ID = sprintf("D = %s", format(D, trim = TRUE, scientific = FALSE)),
  X = Tn,
  Y = q50,
  style = "Solid",
  size = THICK_LINE_SIZE
)]

PLOT <- buildPlot(
  line.type = "spline",
  data.lines = DATA,
  color.palette = "Viridis",
  plot.height = 650,
  legend.layout = "horizontal",
  legend.show = TRUE,
  xAxis.log = TRUE,
  yAxis.log = TRUE,
  xAxis.log.zero = TRUE,
  xAxis.log.zero.label = "PGA",
  xAxis.legend = "Tn [s]",
  yAxis.legend = sprintf(
    "PSA(%s) [%s/s2]",
    OCID.target,
    SCENARIO_TARGET_UNITS
  ),
  yAxis.min = COMPONENT.RANGE[1L] / PAD,
  yAxis.max = COMPONENT.RANGE[2L] * PAD,
  group.legend = "Distance",
  plot.theme = NGR::hc_theme_538_gridlines()
)

rm(AUX, COMPONENT.RANGE, DATA, D.ALL, LOG.SPAN, PAD, REQ, TN.ALL)
# nolint end
