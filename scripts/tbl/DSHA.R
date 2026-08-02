# nolint start
# DSHA comparison table: probabilistic UHS (TR 10,000, mean) vs the
# deterministic scenarios (mean and p84) and the MCE envelopes, per Tn.
# Client-facing nomenclature FIXED by the user: MCE = per-period maximum
# of the scenario means (MCETable ID "max", p "mean"); MCE (84%) = the
# maximum of the scenario 84th fractiles (ID "max", p "0.84").
if (!exists("Vs30.target", inherits = FALSE) || length(Vs30.target) != 1L) Vs30.target <- 760

SITE_ID <- if (exists("siteID.target", inherits = FALSE)) siteID.target else {
  unique(MCETable[!is.na(siteID) & nzchar(siteID), siteID])
}
if (length(SITE_ID) != 1L) stop("DSHA.R: set siteID.target to one siteID.", call. = FALSE)
if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveIDTarget(UHSTable, "DSHA.R", siteID = SITE_ID, base = TRUE)
}

SCN <- sort(unique(MCETable[
  !ID %in% c("max", "min") & !grepl("\\.(site|max)$", ID) & siteID %in% SITE_ID, ID
]))
TNS <- intersect(c(0, 0.1, 0.2, 0.5, 1, 2, 5), unique(MCETable$Tn))

# Rock cells are the base scenario IDs; amplified sites use the
# per-scenario .max family at the target Vs30.
MCE.ID <- if (Vs30.target == 760) SCN else paste0(SCN, ".max")
DT <- rbindlist(list(
  UHSTable[
    ID %in% ID.target & siteID %in% SITE_ID & Vs30 == Vs30.target &
      TR == 10000 & .matchP(p, "mean") & Tn %in% TNS,
    .(Tn, col = "UHS TR-10,000", DSHA = SaF)
  ],
  MCETable[
    ID %in% MCE.ID & siteID %in% SITE_ID & Vs30 == Vs30.target &
      .matchP(p, c("mean", "0.84")) & Tn %in% TNS,
    .(Tn, col = fifelse(
      .matchP(p, "mean"), sub("\\.max$", "", ID), paste0(sub("\\.max$", "", ID), " (84%)")
    ), DSHA = SaF)
  ],
  MCETable[
    ID == "max" & siteID %in% SITE_ID & Vs30 == Vs30.target &
      .matchP(p, c("mean", "0.84")) & Tn %in% TNS,
    .(Tn, col = fifelse(.matchP(p, "mean"), "MCE", "MCE (84%)"), DSHA = SaF)
  ]
), use.names = TRUE)
if (!nrow(DT)) stop("DSHA.R: no rows for the selected site/Vs30.", call. = FALSE)
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, DSHA := round(DSHA * 988, 0)]
if (PSA_Units %in% c("g"))                                DT[, DSHA := round(DSHA, 3)]

AUX <- dcast(DT, Tn ~ col, value.var = "DSHA")
COLS <- intersect(
  c("Tn", "UHS TR-10,000", as.vector(rbind(SCN, paste0(SCN, " (84%)"))), "MCE", "MCE (84%)"),
  names(AUX)
)
setcolorder(AUX, COLS)
setnames(AUX, "Tn", "Tn[s]")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")
TBL <- flextable::bold(TBL, j = intersect(c("MCE", "MCE (84%)"), names(AUX)), part = "header")

rm(DT, AUX, COLS, SCN, TNS, MCE.ID, SITE_ID)
# nolint end
