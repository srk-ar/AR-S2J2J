# nolint start

KT <- kmaxTable
if ("siteID" %in% names(KT)) {
  if (!exists("siteID.target", inherits = FALSE) && uniqueN(KT$siteID, na.rm = TRUE) > 1L) {
    stop("kh.R: set siteID.target to one siteID before building a table without siteID columns.")
  }
}
if ("siteID" %in% names(KT) && exists("siteID.target", inherits = FALSE)) {
  if (length(unique(siteID.target)) != 1L) stop("kh.R: siteID.target must select one siteID.")
  KT <- KT[siteID %in% siteID.target]
}
if (length(unique(IDn.target)) != 1L) {
  stop("kh.R: IDn.target must select one Newmark scenario. Call the table once per scenario.")
}
if (length(unique(ID.target)) != 1L) {
  stop("kh.R: ID.target must select one hazard envelope.")
}
if (length(unique(as.character(p.target))) != 1L) {
  stop("kh.R: p.target must select one probability level.")
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
  Kh = if (all(is.na(Kh))) NA_real_ else mean(Kh, na.rm = TRUE)
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

DT[, Kh := round(Kh, 0)]

AUX <- data.table::dcast(
  DT,
  stats::as.formula(paste(paste(c("IDg", "Hs", "beta", if (uniqueN(DT$TR) > 1L) "TR"), collapse = " + "), "~ Da")),
  value.var = "Kh",
  fun.aggregate = mean
)
data.table::setorder(AUX, IDg)
if ("IDg" %in% names(AUX)) AUX[, IDg := NULL]
if ("TR" %in% names(AUX)) data.table::setnames(AUX, "TR", "TR[yr]")
data.table::setnames(AUX, c("Hs", "beta"), c("Hs [m]", "beta [deg]"))

COLS <- setdiff(names(AUX), c("Hs [m]", "beta [deg]", "TR[yr]"))
data.table::setnames(AUX, old = COLS, new = paste0(COLS, " cm"))

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
