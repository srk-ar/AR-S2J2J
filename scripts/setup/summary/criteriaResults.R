# nolint start
CriteriaSummary <- local({
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  Standard.target <- c("GISTM", "CDA", "ANCOLD")
  Stage.target <- c("Operation", "Closure", "Post-Closure")
  ID.target <- .resolveDerivedIDTarget(
    DEQTable,
    "criteria summary",
    suffix = ".site",
    target = .currentTarget("ID.target"),
    siteID = .currentTarget("siteID.target")
  )
  p.target <- "mean"
  Tn.target <- Tn.PGA
  PSA_Units <- "cm/s2"

  sys.source(
    file.path(root, "scripts", "setup", "summary", "criteria.R"),
    envir = environment()
  )

  list(
    standards = Standard.target,
    stages = Stage.target,
    data = DEQ
  )
})
# nolint end
