# nolint start
DynamicsSummary <- local({
  IDg <- .cleanTarget(.currentTarget("IDg.target"))
  if (!length(IDg)) IDg <- .cleanTarget(IDg.gmdp)

  Level <- .cleanTarget(.currentTarget("level.target"))
  if (!length(Level)) Level <- "mean"

  Periods <- .slopePeriods(
    ShearTable,
    idg = IDg,
    level = Level,
    context = "dynamics summary"
  )
  list(periods = Periods)
})
# nolint end
