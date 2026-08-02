# nolint start
# Expects: root, ID (response), D_TARGET (distance in m)
# Empirical PDF: kernel-smoothed bootstrap of LOG-space OOF residuals around the
# fitted median (X = median * exp(r + kernel noise), r = log(y_obs) - log(y_hat)).
# Multiplicative residuals render symmetric on the log axis with natural tails
# (the additive linear bootstrap produced right-crowded multimodal shapes).
# Note: the exported report quantiles remain the additive construction; this
# figure is a density visualization of the same OOF evidence.

Q.SET <- c(150, 200, 250, 300, 350, 400)
NBOOT <- 5000L

if (!exists("DemandTable")) {
  AUX <- fread(file.path(root, "data", "domains", "index.csv"))[
    fread(file.path(root, "data", "datasets", sprintf("%s.csv", names(jsonlite::fromJSON(file.path(root, "scripts", "manifest.json"))$datasets)[1])))[set == "predict", .(SampleID)],
    on = "SampleID", nomatch = 0][, .(SampleID, Q = MIC, D, SD = round(D / sqrt(MIC), 4))]
  DemandTable <- fread(file.path(root, "data", "export", "Yo.csv"))[AUX, on = "SampleID"]
}
if (!exists("ResidualsTable")) ResidualsTable <- fread(file.path(root, "data", "summary", "residuals_oof.csv"))

set.seed(42L)
AUX <- DemandTable[response == ID & p == 0.50 & D == D_TARGET & Q %in% Q.SET]
# responses and OOF residuals live in log10 space already
R <- ResidualsTable[response == ID & dataset == AUX$dataset[1L], y_obs - y_hat_oof]
UNITS <- if (grepl("^ppv", ID)) "mm/s" else "g"

# M2P2B rendering: bin in log space over a LINEAR axis of log10 values (labels
# show 10^v). Highcharts then computes contiguous column widths natively — no
# logarithmic-axis width breakage, no pixel hacks.
PLOT <- buildPlot.Histogram(
  AUX[, .(X = value + sample(R, NBOOT, replace = TRUE) + rnorm(NBOOT, 0, stats::bw.nrd0(R))), by = Q][, .(X, ID = sprintf("%s(Q=%d,D=%d)", ..ID, Q, as.integer(D_TARGET)))],
  plot.type     = c("histogram", "density"),
  histogram.breaks = 40,
  xAxis.log     = FALSE,
  xAxis.legend  = sprintf("%s [%s] (log scale)", ID, UNITS),
  yAxis.legend  = "Count",
  legend.layout = "vertical",
  legend.align  = "right",
  legend.valign = "middle",
  plot.height   = 650
)
PLOT$x$hc_opts$xAxis$labels <- list(formatter = htmlwidgets::JS("function(){var v = Math.pow(10, this.value); return v >= 1 ? v.toFixed(0) : v.toPrecision(1);}"))
PLOT$x$hc_opts$plotOptions$column <- list(grouping = FALSE, pointPadding = 0, groupPadding = 0, borderWidth = 0.5)
for (i in seq_along(PLOT$x$hc_opts$series)) {
  if (grepl(" Density$", PLOT$x$hc_opts$series[[i]]$name)) PLOT$x$hc_opts$series[[i]]$visible <- FALSE
}
rm(i)

if (!exists("CAPTION", inherits = FALSE)) {
  CAPTION <- sprintf(
    "Conditional demand in terms of %s [%s] at D=%d m: empirical distributions from out-of-fold residual resampling around the fitted median, per MIC.",
    ID, UNITS, as.integer(D_TARGET)
  )
}
rm(AUX, R, UNITS, Q.SET, NBOOT)
# nolint end
