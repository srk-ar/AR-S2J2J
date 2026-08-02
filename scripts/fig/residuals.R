# nolint start
# Expects: DATASET, ID, RESPONSE_LABEL, X_AXIS_HIST, Y_AXIS_HIST, SERIES
# and PathResiduals.

Residuals <- fread(PathResiduals)
COLS <- c("response", "dataset", "SampleID", "y_obs", "y_hat_oof")
if (length(setdiff(COLS, names(Residuals)))) {
  stop("residuals.R: invalid OOF schema.", call. = FALSE)
}
AUX <- Residuals[
  dataset == DATASET & response == ID & is.finite(y_obs) & is.finite(y_hat_oof),
  .(X = y_obs - y_hat_oof, ID = RESPONSE_LABEL)
]
if (!nrow(AUX)) {
  stop(sprintf("residuals.R: no OOF residuals for response %s.", ID),
       call. = FALSE)
}

PLOT <- buildPlot.Histogram(
  AUX,
  plot.type = c("histogram", "density"),
  histogram.breaks = 25,
  xAxis.log = FALSE,
  xAxis.legend = X_AXIS_HIST,
  yAxis.legend = Y_AXIS_HIST,
  legend.layout = "vertical",
  legend.align = "right",
  legend.valign = "middle",
  plot.height = 650
)
for (i in seq_along(PLOT$x$hc_opts$series)) {
  if (grepl(" Histogram$", PLOT$x$hc_opts$series[[i]]$name)) {
    PLOT$x$hc_opts$series[[i]]$name <- SERIES[["histogram"]]
  }
  if (grepl(" Density$", PLOT$x$hc_opts$series[[i]]$name)) {
    PLOT$x$hc_opts$series[[i]]$name <- SERIES[["density"]]
    PLOT$x$hc_opts$series[[i]]$visible <- FALSE
  }
}
rm(i, AUX, COLS, Residuals)
# nolint end
