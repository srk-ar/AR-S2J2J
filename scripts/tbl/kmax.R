# nolint start

KT <- kmaxTable
if ("siteID" %in% names(KT)) {
  if (!exists("siteID.target", inherits = FALSE) && uniqueN(KT$siteID, na.rm = TRUE) > 1L) {
    stop("kmax.R: set siteID.target to one siteID before building a table without siteID columns.")
  }
}
if ("siteID" %in% names(KT) && exists("siteID.target", inherits = FALSE)) {
  if (length(unique(siteID.target)) != 1L) stop("kmax.R: siteID.target must select one siteID.")
  KT <- KT[siteID %in% siteID.target]
}
if (length(unique(IDn.target)) != 1L) {
  stop("kmax.R: IDn.target must select one Newmark scenario. Call the table once per scenario.")
}
if (length(unique(ID.target)) != 1L) {
  stop("kmax.R: ID.target must select one hazard envelope.")
}
if (length(unique(as.character(p.target))) != 1L) {
  stop("kmax.R: p.target must select one probability level.")
}
KT <- KT[
  IDn %in% IDn.target &
    TR %in% TR.target &
    Da %in% Da.target &
    IDg %in% IDg.target &
    ID %in% ID.target
][.matchP(p, p.target)]
KT_BY <- c("TR", "IDg", "ID", "Da")

DT <- KT[, .(
  kmax = mean(kmax, na.rm = TRUE)
), by = KT_BY]

GEO <- ShearTable[
  IDg %in% IDg.target,
  .(
    Hs = unique(Hs)[1],
    beta = round(atan(1 / unique(s)[1]) * 180 / pi, 1)
  ),
  by = IDg
]
DT <- GEO[DT, on = "IDg"]

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) {
  DT[, kmax := round(kmax * 988, 0)]
}

if (PSA_Units %in% c("g")) {
  DT[, kmax := round(kmax, 3)]
}

AUX <- data.table::dcast(
  DT,
  stats::as.formula(paste(paste(c("IDg", "Hs", "beta", if (uniqueN(DT$TR) > 1L) "TR"), collapse = " + "), "~ Da")),
  value.var = "kmax",
  fun.aggregate = mean
)
data.table::setorder(AUX, IDg)
if ("IDg" %in% names(AUX)) AUX[, IDg := NULL]
if ("TR" %in% names(AUX)) data.table::setnames(AUX, "TR", "TR[yr]")
data.table::setnames(AUX, c("Hs", "beta"), c("Hs [m]", "beta [deg]"))

valcols <- setdiff(names(AUX), c("Hs [m]", "beta [deg]", "TR[yr]"))
NEW <- paste0(valcols, " cm")
data.table::setnames(AUX, old = valcols, new = NEW)


TBL <- AUX |>
  buildTable(
    library          = "flextable",
    align.body       = "center",
    font.size.body   = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
  ) |>
  flextable::set_table_properties(layout = "autofit")

rm(KT, DT, GEO, KT_BY, AUX)
# nolint end
