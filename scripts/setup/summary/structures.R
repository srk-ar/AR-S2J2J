# nolint start
StructuresSummary <- local({
  ID.target <- .cleanTarget(.currentTarget("ID.target"))
  if (!length(ID.target)) {
    ID.target <- .cleanTarget(.currentTarget("ID.gmdp"))
  }

  Spectra <- .selectASCETable(
    ASCETable,
    "structures summary",
    idTarget = ID.target,
    siteID = .currentTarget("siteID.target"),
    vs30 = Vs30.gmdp,
    p = "mean",
    spectrum = "mcer"
  )
  Spectra <- unique(Spectra[, .(Vs30, Tn, SaF, SDS, SD1, SMS, SM1)])

  PGA <- Spectra[Tn == min(Tn), .(PGA = SaF), by = Vs30]
  Peak <- Spectra[, .(SaPeak = max(SaF)), by = Vs30]
  Parameters <- unique(Spectra[, .(Vs30, SDS, SD1, SMS, SM1)])
  list(
    spectra = Spectra,
    pga = PGA,
    peak = Peak,
    parameters = Parameters
  )
})
# nolint end
