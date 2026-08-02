# nolint start
# Deterministic scenario (MCE) spectral table: rows Tn, one column per
# (scenario, fractile). Consumes MCETable (scenario spectra carry no
# TR); scenario identity is the base ID (no .site/.max).
if (!exists("p.target") || !length(p.target)) {
  p.target <- c("0.50", "0.84", "0.90", "0.95", "mean")
}
if (!exists("Tn.target") || !length(Tn.target)) Tn.target <- Tn.gmdp
if (!exists("ID.target") || !length(ID.target)) {
  stop("MCE.R: set ID.target to the scenario base IDs.", call. = FALSE)
}
if (!exists("Vs30.target", inherits = FALSE) || length(Vs30.target) != 1L) {
  stop("MCE.R: set scalar Vs30.target.", call. = FALSE)
}

DT <- MCETable[
  ID %in% ID.target & Vs30 %in% Vs30.target &
    Tn %in% Tn.target & .matchP(p, p.target)
]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
if (!nrow(DT)) {
  stop("MCE.R: no scenario rows for the selected targets.", call. = FALSE)
}

SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
DT <- DT[, c(if (SITE_BY) "siteID", "ID", "Tn", "p", "SaF"), with = FALSE][, MCE := SaF][, SaF := NULL]
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, MCE := round(MCE * 988, 0)]
if (PSA_Units %in% c("g"))                                DT[, MCE := round(MCE, 3)]

AUX <- dcast(
  DT,
  stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "Tn"), collapse = " + "), "~ ID + p")),
  value.var = "MCE",
  sep = " "
)
setnames(AUX, "Tn", "Tn[s]")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, SITE_BY)
# nolint end
