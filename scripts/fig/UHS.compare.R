# nolint start
# Rock comparator: mean uniform hazard spectra per hazard model across
# ALL return periods (PSHA) overlaid with the deterministic scenario
# means (MCE). Vs30 = 760 only; dash style encodes TR (solid = longest),
# MCE scenarios are thick solid.
SITE_ID <- if (exists("siteID.target", inherits = FALSE)) siteID.target else {
  unique(UHSTable[!is.na(siteID) & nzchar(siteID), siteID])
}
if (length(SITE_ID) != 1L) stop("UHS.compare.R: set siteID.target to one siteID.", call. = FALSE)
# Deck policy: ONE reported model; internal trial models never reach a client deck.
if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveIDTarget(UHSTable, "UHS.compare.R", siteID = SITE_ID, base = TRUE)
}

DASH <- c("ShortDash", "ShortDashDot", "DashDot", "Dash", "LongDash", "Solid")
DT <- UHSTable[
  Vs30 == 760 & .matchP(p, "mean") & ID %in% ID.target
][siteID %in% SITE_ID]
if (!nrow(DT)) stop("UHS.compare.R: no rock mean rows for the selected site.", call. = FALSE)
AUX <- sort(unique(DT$TR))
DT <- DT[, .(
  ID    = paste0(ID, " TR ", prettyNum(round(TR, 0), big.mark = ","), " yr (PSHA)"),
  X     = Tn,
  Y     = SaF,
  style = DASH[pmax(1L, length(DASH) - length(AUX) + match(TR, AUX))],
  size  = MID_LINE_SIZE
)]
if (exists("MCETable") && !is.null(MCETable)) {
  DT <- rbindlist(list(DT, MCETable[
    Vs30 == 760 & .matchP(p, c("mean", "0.84")) &
      !ID %in% c("max", "min") & !grepl("\\.(site|max)$", ID)
  ][siteID %in% SITE_ID][, .(
    ID    = paste0(ID, " ", p, " (MCE)"),
    X     = Tn,
    Y     = SaF,
    style = fifelse(p == "mean", "Solid", "Dash"),
    size  = fifelse(p == "mean", MID_LINE_SIZE, THIN_LINE_SIZE)
  )]), use.names = TRUE)
}

DATA <- DT[order(X)][order(ID)] |> unique()
DUP <- DATA[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) stop("UHS.compare.R: duplicate ordinates for at least one series/Tn.", call. = FALSE)

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "Model / Scenario",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = DATA
)
rm(DT, DATA, DUP, AUX, DASH, SITE_ID)
# nolint end
