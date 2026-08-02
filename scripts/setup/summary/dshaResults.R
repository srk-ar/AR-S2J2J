# nolint start
DSHASummary <- local({
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  sys.source(
    file.path(root, "scripts", "setup", "summary", "dsha.R"),
    envir = environment()
  )
  list(
    scenarios = DSHA.scn,
    envelope = DSHA.mce,
    probabilisticPGA = DSHA.uhs,
    governorMean = DSHA.gov.mean,
    governorQ84 = DSHA.gov.p84
  )
})
# nolint end
