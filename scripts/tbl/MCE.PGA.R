# nolint start
# Deterministic scenario (MCE) PGA table at reference rock: one row per
# scenario, columns = p fractiles. Consumes MCETable (no TR dimension).
if (!exists("p.target") || !length(p.target)) {
  p.target <- c("0.50", "0.84", "0.90", "0.95", "mean")
}
if (!exists("ID.target") || !length(ID.target)) {
  stop("MCE.PGA.R: set ID.target to scenario base IDs.", call. = FALSE)
}

DT <- MCETable[ID %in% ID.target & Vs30 == 760 & .matchP(p, p.target)]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
if (!nrow(DT)) stop("MCE.PGA.R: no rock rows for the selected scenario.", call. = FALSE)
Tn.pga <- min(DT$Tn)
DT <- DT[Tn == Tn.pga, .(ID, p, PGA = SaF)]
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PGA := round(PGA * 988, 0)]
if (PSA_Units %in% c("g"))                                DT[, PGA := round(PGA, 3)]

AUX <- dcast(DT, ID ~ p, value.var = "PGA")
P_COLS <- intersect(c("0.05", "0.16", "0.50", "0.84", "0.90", "0.95", "mean"), names(AUX))
setcolorder(AUX, c("ID", P_COLS))
setnames(AUX, "ID", "Scenario")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")
if ("mean" %in% names(AUX)) TBL <- flextable::bold(TBL, j = "mean", part = "header")

rm(DT, AUX, P_COLS, Tn.pga)
# nolint end
