# nolint start
SiteSummary <- local({
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  sys.source(
    file.path(root, "scripts", "setup", "summary", "site.R"),
    envir = environment()
  )

  list(
    scope = SITE_SCOPE,
    siteConditions = SITE_VS30,
    returnPeriods = SITE_TR,
    pga = SITE_PGA,
    peak = SITE_PEAK_RANGE
  )
})
# nolint end
