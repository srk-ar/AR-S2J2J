# nolint start
# Expects SCENARIO_SUMMARY, SCENARIO_META, SCENARIO_SOURCE, COMPONENT,
# X_AXIS, Y_AXIS, SERIES_LABEL and TOOLTIP_FORMAT.

COLS <- c("ScenarioID", "D", "MIC", "SF.L", "SF.T", "SF.V", "n.records")
if (length(setdiff(COLS, names(SCENARIO_SUMMARY)))) {
  stop("scenarios.scaling.R: incomplete scenario-summary schema.",
       call. = FALSE)
}
COLS <- c("RecordID", "OCID", "PGV")
if (length(setdiff(COLS, names(SCENARIO_SOURCE)))) {
  stop("scenarios.scaling.R: incomplete source-history schema.",
       call. = FALSE)
}
COLS <- c("ScenarioID", "D", "MIC", "P", "RecordID")
if (length(setdiff(COLS, names(SCENARIO_META)))) {
  stop("scenarios.scaling.R: incomplete scenario-metadata schema.",
       call. = FALSE)
}
if (length(COMPONENT) != 1L || !COMPONENT %in% c("L", "T", "V")) {
  stop("scenarios.scaling.R: unsupported source component.", call. = FALSE)
}
if (SCENARIO_SUMMARY[, anyDuplicated(ScenarioID)] ||
    SCENARIO_SOURCE[, anyDuplicated(.SD), .SDcols = c("RecordID", "OCID")]) {
  stop("scenarios.scaling.R: duplicated scenario or source-record keys.",
       call. = FALSE)
}

if (SCENARIO_META[
  , any(data.table::uniqueN(D) != 1L | data.table::uniqueN(MIC) != 1L),
  by = ScenarioID
][, any(V1)]) {
  stop("scenarios.scaling.R: each scenario requires one D-Q condition.",
       call. = FALSE)
}
AUX <- SCENARIO_META[, .(
  D = unique(D),
  MIC = unique(MIC),
  N = data.table::uniqueN(RecordID)
), by = ScenarioID]
if (!setequal(AUX$ScenarioID, SCENARIO_SUMMARY$ScenarioID)) {
  stop("scenarios.scaling.R: scenario metadata do not match the inventory.",
       call. = FALSE)
}
AUX <- AUX[SCENARIO_SUMMARY, on = "ScenarioID", .(
  ScenarioID,
  D = x.D,
  MIC = x.MIC,
  N,
  D.audit = i.D,
  MIC.audit = i.MIC,
  N.audit = i.n.records
)]
if (AUX[, any(D != D.audit | MIC != MIC.audit | N != N.audit)]) {
  stop("scenarios.scaling.R: scenario metadata differ from the inventory.",
       call. = FALSE)
}

DT <- data.table::melt(
  SCENARIO_SUMMARY,
  id.vars = c("ScenarioID", "D", "MIC", "n.records"),
  measure.vars = c("SF.L", "SF.T", "SF.V"),
  variable.name = "Component",
  value.name = "Target",
  variable.factor = FALSE
)
data.table::set(DT, j = "Component", value = sub("^SF[.]", "", DT$Component))
DT <- DT[
  SCENARIO_SOURCE,
  on = c("Component" = "OCID"),
  allow.cartesian = TRUE,
  .(
    ScenarioID,
    D,
    MIC,
    Component,
    RecordID = i.RecordID,
    Target,
    PGV = i.PGV,
    Lambda = Target / i.PGV
  )
]
if (!nrow(DT) ||
    DT[, anyDuplicated(.SD), .SDcols = c("ScenarioID", "RecordID", "Component")] ||
    DT[, any(!is.finite(D) | !is.finite(MIC) | !is.finite(Target) |
               !is.finite(PGV) | !is.finite(Lambda) | Target <= 0 |
               PGV <= 0 | Lambda <= 0)]) {
  stop("scenarios.scaling.R: invalid scale-factor matrix.", call. = FALSE)
}

ZMIN <- min(log10(DT$Lambda))
ZMAX <- max(log10(DT$Lambda))
AUX <- data.table::data.table(
  Lambda = c(
    min(DT$Lambda), sqrt(min(DT$Lambda)), 1, 2, 5, 10, 20, 50,
    max(DT$Lambda)
  ),
  Color = c(
    "#00366C", "#91BAEB", "#F9F9F9", "#FDEBA8", "#F8CD6D",
    "#F5A800", "#F17B00", "#E54000", "#7D0025"
  )
)
AUX <- unique(
  AUX[log10(Lambda) >= ZMIN & log10(Lambda) <= ZMAX],
  by = "Lambda"
)
data.table::setorder(AUX, Lambda)
STOPS <- Map(
  function(x, color) list((log10(x) - ZMIN) / (ZMAX - ZMIN), color),
  AUX$Lambda,
  AUX$Color
)
MARKS <- c(1, 2, 5, 10, 20, 50)
MARKS <- MARKS[log10(MARKS) >= ZMIN & log10(MARKS) <= ZMAX]
AUX <- unique(DT[, .(ScenarioID, D, MIC)])[order(D, MIC)]
data.table::set(
  AUX,
  j = "X",
  value = sprintf(
    "%03d | D=%s m | Q=%s kg",
    seq_len(nrow(AUX)), format(AUX$D, trim = TRUE), format(AUX$MIC, trim = TRUE)
  )
)
DT <- DT[Component == COMPONENT]
data.table::set(DT, j = "X", value = AUX$X[match(DT$ScenarioID, AUX$ScenarioID)])
data.table::set(DT, j = "Y", value = DT$RecordID)
data.table::set(DT, j = "Z", value = log10(DT$Lambda))
data.table::setorder(DT, X, Y)

PLOT <- NGR::buildHeatmap(
  .data = DT[, .(X, Y, Z)],
  xAxis.legend = X_AXIS,
  yAxis.legend = Y_AXIS,
  colorAxis.min = ZMIN,
  colorAxis.max = ZMAX,
  color.stops = STOPS,
  series.name = SERIES_LABEL,
  border.width = 0,
  tooltip.format = TOOLTIP_FORMAT,
  legend.align = "right",
  legend.layout = "vertical",
  legend.valign = "middle",
  plot.theme = NGR::hc_theme_538_gridlines()
)

for (i in seq_len(nrow(DT))) {
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$scenario <- DT$ScenarioID[i]
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$d <- formatC(DT$D[i], format = "fg")
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$q <- formatC(DT$MIC[i], format = "fg")
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$record <- DT$RecordID[i]
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$component <- DT$Component[i]
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$target <- formatC(
    DT$Target[i], format = "f", digits = 3L
  )
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$pgv <- formatC(
    DT$PGV[i], format = "f", digits = 3L
  )
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$lambda <- formatC(
    DT$Lambda[i], format = "f", digits = 3L
  )
}

PLOT$x$hc_opts$xAxis$categories <- sprintf(
  "D=%s<br>Q=%s",
  format(AUX$D, trim = TRUE),
  format(AUX$MIC, trim = TRUE)
)
PLOT$x$hc_opts$xAxis$labels <- list(
  rotation = -60,
  style = list(fontSize = "8px")
)
PLOT$x$hc_opts$yAxis$labels <- list(enabled = FALSE)
PLOT$x$hc_opts$colorAxis$labels <- list(
  formatter = htmlwidgets::JS(
    "function () { return Highcharts.numberFormat(Math.pow(10, this.value), 2); }"
  )
)
PLOT$x$hc_opts$colorAxis$tickPositions <- log10(MARKS)
PLOT <- highcharter::hc_size(PLOT, height = 850)

rm(AUX, COLS, DT, MARKS, STOPS, ZMAX, ZMIN, i)
# nolint end
