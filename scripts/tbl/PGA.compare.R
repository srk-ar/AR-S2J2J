# nolint start
# Rock PGA comparator table: rows = hazard levels (TR, PSHA) followed by
# the deterministic scenarios (MCE); columns = hazard models + MCE.
SITE_ID <- if (exists("siteID.target", inherits = FALSE)) siteID.target else {
  unique(UHSTable[!is.na(siteID) & nzchar(siteID), siteID])
}
if (length(SITE_ID) != 1L) stop("PGA.compare.R: set siteID.target to one siteID.", call. = FALSE)
# Deck policy: ONE reported model; internal trial models never reach a client deck.
if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveIDTarget(UHSTable, "PGA.compare.R", siteID = SITE_ID, base = TRUE)
}

DT <- UHSTable[
  Vs30 == 760 & .matchP(p, "mean") & ID %in% ID.target
][siteID %in% SITE_ID][Tn == min(Tn), .(
  Ord = as.numeric(TR),
  Case = paste("TR", prettyNum(round(TR, 0), big.mark = ","), "yr"),
  src = ID, PGA = SaF
)]
if (exists("MCETable") && !is.null(MCETable)) {
  DT <- rbindlist(list(DT, MCETable[
    Vs30 == 760 & .matchP(p, "mean") &
      !ID %in% c("max", "min") & !grepl("\\.(site|max)$", ID)
  ][siteID %in% SITE_ID][Tn == min(Tn), .(
    Ord = Inf, Case = ID, src = "MCE", PGA = SaF
  )]), use.names = TRUE)
}
if (!nrow(DT)) stop("PGA.compare.R: no rock PGA rows.", call. = FALSE)
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PGA := round(PGA * 988, 0)]
if (PSA_Units %in% c("g"))                                DT[, PGA := round(PGA, 3)]

AUX <- dcast(DT, Ord + Case ~ src, value.var = "PGA")[order(Ord, Case)][, Ord := NULL]
setnames(AUX, "Case", "TR / Scenario")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, SITE_ID)
# nolint end
