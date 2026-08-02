# nolint start
HazardSummary <- local({
  ID.target <- ID.gmdp
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  sys.source(
    file.path(root, "scripts", "setup", "summary", "hazard.R"),
    envir = environment()
  )
  sys.source(
    file.path(root, "scripts", "setup", "summary", "disagg.R"),
    envir = environment()
  )

  DOM <- Hazard.source[rank == 1L]
  list(
    returnPeriods = Hazard.TR.selected,
    pga = PGA,
    peak = SaPeak,
    modal = RMw,
    source = DOM
  )
})
# nolint end
