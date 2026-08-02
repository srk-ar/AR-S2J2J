# nolint start
DisplacementsSummary <- local({
  SiteID <- .currentTarget("siteID.target")
  if ("siteID" %in% names(DnTable)) {
    SiteID <- .resolveSiteIDTarget(
      DnTable,
      "displacements summary",
      target = SiteID
    )
  }

  ID.target <- .resolveDerivedIDTarget(
    DnTable,
    "displacements summary",
    suffix = ".max",
    target = .currentTarget("ID.target"),
    siteID = SiteID
  )
  DnKy <- 0.05
  DnTR <- intersect(c(2500, 10000), TR.gmdp)
  DT <- DnTable[
      ID %in% ID.target & IDg %in% IDg.gmdp &
      IDn %in% c("ensemble", "rigid", "flexible") &
      TR %in% DnTR & .matchP(p, "mean")
  ]
  DnByMaterial <- DT[
    ,
    {
      OK <- is.finite(ky) & is.finite(Dn) & ky > 0 & Dn > 0
      IDX <- order(ky[OK])
      .(Dn = exp(approx(
        log(ky[OK][IDX]),
        log(Dn[OK][IDX]),
        log(DnKy),
        rule = 1,
        ties = mean
      )$y))
    },
    by = .(TR, IDg, IDm, IDn)
  ]

  n <- length(DnTR) * uniqueN(IDg.gmdp) *
    uniqueN(IDm.gmdp) * 3L
  DnReference <- DnByMaterial[
    ,
    .(Dn = mean(Dn, na.rm = TRUE)),
    by = .(TR, IDg, IDn)
  ]
  n <- length(DnTR) * uniqueN(IDg.gmdp) * 3L
  DnRange <- DnReference[
    ,
    .(minimum = min(Dn), maximum = max(Dn)),
    by = .(TR, IDn)
  ][order(TR, IDn)]
  list(
    ky = DnKy,
    returnPeriods = DnTR,
    range = DnRange
  )
})
# nolint end
