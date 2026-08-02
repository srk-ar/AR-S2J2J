# nolint start
# Expects: DATASET, ID, X_AXIS_SCATTER, Y_AXIS_SCATTER, GROUP_LEGEND,
# SOURCE_UNKNOWN, ZERO_LABEL, PathResiduals and PathSources.

Residuals <- fread(PathResiduals)
Sources <- fread(PathSources, select = c("SampleID", "Source"))
COLS <- c("response", "dataset", "SampleID", "y_obs", "y_hat_oof")
if (length(setdiff(COLS, names(Residuals))) ||
    Sources[, anyDuplicated(SampleID)]) {
  stop("residscatter.R: invalid OOF or source schema.", call. = FALSE)
}
AUX <- Residuals[
  dataset == DATASET & response == ID & is.finite(y_obs) & is.finite(y_hat_oof)
]
if (!nrow(AUX) || AUX[, anyDuplicated(SampleID)]) {
  stop(sprintf("residscatter.R: invalid OOF residuals for response %s.", ID),
       call. = FALSE)
}
AUX[Sources, on = "SampleID", Source := i.Source]
AUX[is.na(Source) | !nzchar(Source), Source := SOURCE_UNKNOWN]
RNG <- AUX[, range(y_hat_oof)]

PLOT <- buildPlot(
  line.type = "line",
  data.lines = data.table(X = RNG, Y = c(0, 0), ID = ZERO_LABEL, size = 2),
  data.points = AUX[, .(X = y_hat_oof, Y = y_obs - y_hat_oof, ID = Source)],
  xAxis.log = FALSE,
  yAxis.log = FALSE,
  xAxis.legend = X_AXIS_SCATTER,
  yAxis.legend = Y_AXIS_SCATTER,
  group.legend = GROUP_LEGEND,
  legend.layout = "vertical",
  legend.align = "right",
  legend.valign = "middle",
  legend.show = TRUE,
  plot.height = 650,
  point.size = 4,
  plot.theme = NGR::hc_theme_538_gridlines()
)
PLOT$x$hc_opts$xAxis$labels <- list(
  formatter = htmlwidgets::JS("function(){var v=Math.pow(10,this.value);return v>=1?v.toFixed(1):v.toPrecision(2);}")
)
rm(AUX, COLS, Residuals, RNG, Sources)
# nolint end
