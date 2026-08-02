# nolint start
CoefficientsSummary <- local({
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  ID.target <- .resolveDerivedIDTarget(
    kmaxTable,
    "coefficients summary",
    suffix = ".max",
    target = .currentTarget("ID.target"),
    siteID = .currentTarget("siteID.target")
  )
  IDn.target <- "ensemble"
  IDg.target <- IDg.gmdp
  level.target <- "mean"
  TR.target <- intersect(c(2500, 10000), TR.gmdp)
  Da.target <- intersect(c(1, 5), Da.gmdp)
  p.target <- c("mean", "0.84")
  PSA_Units <- "g"
  Kmax.extrap.required <- TRUE

  sys.source(
    file.path(root, "scripts", "setup", "summary", "slope.R"),
    envir = environment()
  )

  ReturnPeriods <- sort(unique(kmax$TR))
  Displacements <- sort(unique(kmax$Da))
  n <- uniqueN(IDg.target) * length(ReturnPeriods) *
    length(Displacements) * 2L
  KmaxRange <- kmax[
    ,
    .(minimum = min(kmax), maximum = max(kmax)),
    by = .(Da, p)
  ][order(Da, p)]
  KhRange <- Kh[
    ,
    .(minimum = min(Kh), maximum = max(Kh)),
    by = .(Da, p)
  ][order(Da, p)]
  list(
    geometryCount = uniqueN(Ts$IDg),
    returnPeriods = ReturnPeriods,
    displacements = Displacements,
    kmax = KmaxRange,
    kh = KhRange,
    extrapolation = Kmax.extrap
  )
})
# nolint end
