# nolint start
# Deterministic scenario (MCE) PSA table at reference rock: rows Tn,
# columns = p fractiles. Consumes MCETable (no TR dimension).
if (!exists("p.target") || !length(p.target)) {
  p.target <- c("0.50", "0.84", "0.90", "0.95", "mean")
}
if (!exists("Tn.target") || !length(Tn.target)) Tn.target <- sort(unique(MCETable$Tn))
if (!exists("ID.target") || !length(ID.target)) {
  stop("MCE.PSA.R: set ID.target to the scenario base IDs.", call. = FALSE)
}

DT <- MCETable[
  ID %in% ID.target & Vs30 == 760 & Tn %in% Tn.target & .matchP(p, p.target)
]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
if (!nrow(DT)) stop("MCE.PSA.R: no rock rows for the selected scenario.", call. = FALSE)
DT <- DT[, .(ID, Tn, p, PSA = SaF)]
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PSA := round(PSA * 988, 0)]
if (PSA_Units %in% c("g"))                                DT[, PSA := round(PSA, 3)]

# Scenarios compose by COLUMNS: Tn rows, scenario-major fractile groups.
AUX <- dcast(DT, Tn ~ ID + p, value.var = "PSA", sep = " ")
P_COLS <- c("0.05", "0.16", "0.50", "0.84", "0.90", "0.95", "mean")
COLS <- unlist(lapply(sort(unique(DT$ID)), function(s) paste(s, P_COLS)))
setcolorder(AUX, c("Tn", intersect(COLS, names(AUX))))
setnames(AUX, "Tn", "Tn[s]")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, P_COLS, COLS)
# nolint end
