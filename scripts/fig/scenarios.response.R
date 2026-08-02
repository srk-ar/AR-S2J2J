# nolint start
# Expects SCENARIO_RESPONSE, SCENARIO_P, G, COMPONENT, X_AXIS, Y_AXIS,
# SERIES_LABEL and TOOLTIP_FORMAT.

COLS <- c("ScenarioID", "D", "MIC", "P", "RecordID", "OCID", "PGA")
if (length(setdiff(COLS, names(SCENARIO_RESPONSE)))) {
  stop("scenarios.response.R: incomplete scenario-response schema.",
       call. = FALSE)
}
if (length(COMPONENT) != 1L || !COMPONENT %in% c("H1", "H2", "UP")) {
  stop("scenarios.response.R: unsupported analysis component.",
       call. = FALSE)
}
if (!is.numeric(G) || length(G) != 1L || !is.finite(G) || G <= 0) {
  stop("scenarios.response.R: invalid acceleration-unit scale.",
       call. = FALSE)
}

DT <- SCENARIO_RESPONSE[
  P == SCENARIO_P & OCID %in% c("H1", "H2", "UP")
]
if (!nrow(DT) ||
    DT[, anyDuplicated(.SD), .SDcols = c("ScenarioID", "RecordID", "OCID")] ||
    DT[, any(!is.finite(D) | !is.finite(MIC) | !is.finite(PGA) | PGA <= 0)]) {
  stop("scenarios.response.R: invalid scenario-response matrix.",
       call. = FALSE)
}
AUX <- DT[, .(
  N = data.table::uniqueN(RecordID),
  D.N = data.table::uniqueN(D),
  Q.N = data.table::uniqueN(MIC)
), by = ScenarioID]
if (AUX[, any(N < 1L | D.N != 1L | Q.N != 1L)] ||
    data.table::uniqueN(AUX$N) != 1L) {
  stop("scenarios.response.R: inconsistent scenario realization matrix.",
       call. = FALSE)
}

data.table::set(DT, j = "PPA", value = DT$PGA / G)
ZMIN <- floor(min(log10(DT$PPA)) * 10) / 10
ZMAX <- ceiling(max(log10(DT$PPA)) * 10) / 10
AUX <- unique(DT[, .(ScenarioID, D, MIC)])[order(D, MIC)]
data.table::set(
  AUX,
  j = "X",
  value = sprintf(
    "%03d | D=%s m | Q=%s kg",
    seq_len(nrow(AUX)), format(AUX$D, trim = TRUE), format(AUX$MIC, trim = TRUE)
  )
)
DT <- DT[OCID == COMPONENT]
data.table::set(DT, j = "X", value = AUX$X[match(DT$ScenarioID, AUX$ScenarioID)])
data.table::set(DT, j = "Y", value = DT$RecordID)
data.table::set(DT, j = "Z", value = log10(DT$PPA))
data.table::setorder(DT, X, Y)

PLOT <- NGR::buildHeatmap(
  .data = DT[, .(X, Y, Z)],
  xAxis.legend = X_AXIS,
  yAxis.legend = Y_AXIS,
  colorAxis.min = ZMIN,
  colorAxis.max = ZMAX,
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
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$component <- DT$OCID[i]
  PLOT$x$hc_opts$series[[1L]]$data[[i]]$ppa <- formatC(
    DT$PPA[i], format = "f", digits = 4L
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
    "function () { return Highcharts.numberFormat(Math.pow(10, this.value), 3); }"
  )
)
PLOT <- highcharter::hc_size(PLOT, height = 850)

rm(AUX, COLS, DT, ZMAX, ZMIN, i)
# nolint end
