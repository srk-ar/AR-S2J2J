# nolint start
# Expects: AUX, HISTOGRAM_BREAKS, Range, RESPONSE_LABEL, SERIES, TOOLTIP,
# UNIT and Y_AXIS.

PLOT <- NGR::buildPlot.Histogram(
  AUX,
  plot.type = c("histogram", "density"),
  histogram.breaks = HISTOGRAM_BREAKS,
  xAxis.log = FALSE,
  xAxis.legend = sprintf("%s [%s]", RESPONSE_LABEL, UNIT),
  yAxis.legend = Y_AXIS,
  legend.layout = "horizontal",
  legend.align = "right",
  legend.valign = "top",
  legend.show = TRUE,
  plot.height = 650
)
PLOT <- highcharter::hc_add_theme(PLOT, NGR::hc_theme_538_gridlines())
PLOT$x$hc_opts$xAxis$min <- Range[1L]
PLOT$x$hc_opts$xAxis$max <- Range[2L]
PLOT$x$hc_opts$xAxis$labels <- list(
  formatter = htmlwidgets::JS(
    "function(){var v=Math.pow(10,this.value);return v>=1?v.toFixed(1):v.toPrecision(2);}"
  )
)
PLOT$x$hc_opts$plotOptions$column <- list(
  grouping = FALSE,
  pointPadding = 0,
  groupPadding = 0,
  borderWidth = 0.5
)
LIST <- lapply(
  c(TOOLTIP, unit = UNIT),
  jsonlite::toJSON,
  auto_unbox = TRUE
)
PLOT$x$hc_opts$tooltip <- list(
  useHTML = TRUE,
  formatter = htmlwidgets::JS(sprintf(
    paste0(
      "function(){var v=Math.pow(10,this.x);",
      "var a=v>=1?v.toFixed(2):v.toPrecision(3);",
      "var y=this.series.type==='areaspline'?%s:%s;",
      "return '<b>'+this.series.name+'</b><br/>'+%s+': '+a+' '+%s+",
      "'<br/>'+y+': '+Highcharts.numberFormat(this.y,2);}"
    ),
    LIST[["density"]], LIST[["count"]], LIST[["amplitude"]], LIST[["unit"]]
  ))
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
rm(i, LIST)
# nolint end
