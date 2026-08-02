# nolint start
# Expects: DATASET, ID, Q.TARGET, P.TARGET, UNIT, X_AXIS, Y_AXIS,
# GROUP_LEGEND, SOURCE_UNKNOWN, SOURCE_COLORS, LINE_FORMAT, PathDataset,
# PathDemand and PathSources.

if (!grepl("^ppa([LTV])?$", ID)) {
  stop(sprintf("demand.PPA.R: unsupported response %s.", ID),
       call. = FALSE)
}
if (!length(Q.TARGET) || any(!is.finite(Q.TARGET)) ||
    !length(P.TARGET) || any(!is.finite(P.TARGET)) ||
    length(UNIT) != 1L || is.na(UNIT) || !nzchar(UNIT)) {
  stop("demand.PPA.R: incomplete figure contract.", call. = FALSE)
}

DATA <- fread(
  PathDataset,
  select = c("SampleID", "set", "MIC", "D", "SD", ID)
)
if (DATA[, anyDuplicated(SampleID)]) {
  stop("demand.PPA.R: dataset SampleID values are not unique.",
       call. = FALSE)
}
Grid <- DATA[set == "predict", .(SampleID, Q = MIC, D, SD)]
Train <- DATA[set == "train"]
Sources <- fread(PathSources, select = c("SampleID", "Source"))
if (Sources[, anyDuplicated(SampleID)]) {
  stop("demand.PPA.R: source SampleID values are not unique.",
       call. = FALSE)
}
Train[Sources, on = "SampleID", Source := i.Source]
Train[is.na(Source) | !nzchar(Source), Source := SOURCE_UNKNOWN]

Demand <- fread(
  PathDemand,
  select = c("SampleID", "response", "p", "value", "dataset")
)[dataset == DATASET][Grid, on = "SampleID", nomatch = 0]
if (!nrow(Demand) ||
    Demand[, anyDuplicated(.SD), .SDcols = c("SampleID", "response", "p")]) {
  stop("demand.PPA.R: prediction product keys are incomplete or duplicated.",
       call. = FALSE)
}
if (!all(Q.TARGET %in% Grid$Q)) {
  stop("demand.PPA.R: requested charges lie outside the prediction grid.",
       call. = FALSE)
}
AUX <- Demand[
  response == ID & Q %in% Q.TARGET & p %in% P.TARGET
][order(Q, p, D)]
Combos <- data.table::CJ(Q = Q.TARGET, p = P.TARGET)
if (!nrow(AUX) ||
    nrow(Combos[unique(AUX[, .(Q, p)]), on = .(Q, p), nomatch = 0L]) !=
      nrow(Combos) ||
    AUX[, any(!is.finite(D) | !is.finite(SD) | !is.finite(value))]) {
  stop(sprintf("demand.PPA.R: incomplete prediction grid for %s.", ID),
       call. = FALSE)
}

Lines <- AUX[, .(
  X = SD,
  Y = 10^value,
  ID = sprintf(LINE_FORMAT, format(Q, trim = TRUE), round(100 * p)),
  size = fifelse(p == 0.50, THICK_LINE_SIZE, MID_LINE_SIZE)
)]
Points <- Train[
  is.finite(SD) & is.finite(get(ID))
][, .(X = SD, Y = 10^get(ID), ID = Source)][is.finite(Y) & Y > 0]

PLOT <- buildPlot(
  line.type = "spline",
  data.lines = Lines,
  data.points = Points,
  xAxis.log = FALSE,
  yAxis.log = TRUE,
  xAxis.legend = X_AXIS,
  yAxis.legend = Y_AXIS,
  group.legend = GROUP_LEGEND,
  legend.layout = "vertical",
  legend.align = "right",
  legend.valign = "middle",
  legend.show = TRUE,
  plot.height = 700,
  point.size = 3,
  plot.theme = NGR::hc_theme_538_gridlines()
)

Colors <- setNames(
  grDevices::hcl.colors(length(Q.TARGET), "Dark 3"),
  paste0("Q=", Q.TARGET)
)
for (i in seq_along(PLOT$x$hc_opts$series)) {
  Name <- PLOT$x$hc_opts$series[[i]]$name
  Base <- sub(" \\|.*$", "", Name)
  if (Base %in% names(Colors)) {
    PLOT$x$hc_opts$series[[i]]$color <- Colors[[Base]]
  }
  if (grepl("p90$", Name)) {
    PLOT$x$hc_opts$series[[i]]$dashStyle <- "Dash"
    PLOT$x$hc_opts$series[[i]]$showInLegend <- FALSE
  }
  if (grepl("p95$", Name)) {
    PLOT$x$hc_opts$series[[i]]$dashStyle <- "Dot"
    PLOT$x$hc_opts$series[[i]]$showInLegend <- FALSE
  }
  if (Name %in% names(SOURCE_COLORS)) {
    PLOT$x$hc_opts$series[[i]]$color <- SOURCE_COLORS[[Name]]
  }
}

rm(
  AUX, Base, Colors, Combos, DATA, Demand, Grid, Lines, Name, Points,
  Sources, Train, i
)
# nolint end
