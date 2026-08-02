# nolint start
RMw <- RMwTable
if ("siteID" %in% names(RMw) && exists("siteID.target", inherits = FALSE)) {
  RMw <- RMw[siteID %in% siteID.target]
}
if ("siteID" %in% names(RMw) && uniqueN(RMw$siteID, na.rm = TRUE) > 1L) {
  stop("RMw3D: set siteID.target to one siteID.")
}

DT <- RMw[Tn == Tn.target & TR == TR.target]
if (!nrow(DT)) {
  AUX       <- sort(unique(RMw$TR))
  TR.target <- AUX[which.min(abs(AUX - TR.target))]
  DT        <- RMw[Tn == Tn.target & TR == TR.target]
  rm(AUX)
}
DT[, pct := p / sum(p) * 100]

Widest <- RMw[Tn == Tn.target & TR == sort(unique(RMw[Tn == Tn.target]$TR))[1] & p > 0]
RStep  <- unique(diff(sort(unique(RMw$R))))[1]
MwStep <- unique(diff(sort(unique(RMw$Mw))))[1]
Rmax   <- min(max(Widest$R), RStep * 16L)
NICE   <- c(50, 100, 150, 200, 250, 300, 400, 500, 750, 1000)
AUX    <- NICE[which(NICE >= Rmax)[1]]
if (!is.na(AUX)) Rmax <- AUX
MwSpan <- max(Widest$Mw) - min(Widest$Mw)
MwPad  <- max(0, (8L * MwStep - MwSpan) / 2)
MwMin  <- floor((min(Widest$Mw) - MwPad) / MwStep) * MwStep
MwMax  <- ceiling((max(Widest$Mw) + MwPad) / MwStep) * MwStep
DT     <- DT[R <= Rmax & Mw >= MwMin & Mw <= MwMax]
rm(Widest, RStep, MwStep, Rmax, NICE, AUX, MwSpan, MwPad, MwMin, MwMax)

DT   <- DT[pct >= 1e-3]
DATA <- DT[, .(
  Y = round(Mw, 2),
  X = round(R),
  Z = pct,
  Size = pmax(3, sqrt(pct) * 2)
)]

PLOT <- plotly::plot_ly(
  x = DATA$X,
  y = DATA$Y,
  z = DATA$Z,
  type = "scatter3d",
  mode = "markers",
  marker = list(
    size = DATA$Size,
    color = DATA$Z,
    colorscale = "Viridis",
    opacity = 0.85,
    showscale = TRUE,
    colorbar = list(title = "Contribution [%]")
  ),
  text = sprintf("R = %s km<br>Mw = %.2f<br>Contribution = %.3f%%", DATA$X, DATA$Y, DATA$Z),
  hoverinfo = "text"
)
PLOT <- plotly::layout(
  PLOT,
  title = sprintf(
    "Hazard Deaggregation | Tn=%.2f s | TR=%s yr",
    Tn.target,
    prettyNum(round(TR.target, 0), big.mark = ",")
  ),
  scene = list(
    xaxis = list(title = "R [km]"),
    yaxis = list(title = "Mw"),
    zaxis = list(title = "Contribution [%]")
  )
)
# nolint end
rm(RMw, DT, DATA)
