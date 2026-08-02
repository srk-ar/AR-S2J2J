# root <- here::here()

DT <- DEQTable[
    ID %in% ID.target & Standard %in% Standard.target &
    Stage %in% Stage.target & Tn == Tn.target &
    Vs30 %in% Vs30.target
]
if (!"p" %in% names(DT)) DT[, p := "mean"]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
    DT <- DT[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
DT <- DT[
    ,
    c(if (SITE_BY) "siteID", "Standard", "Class", "TR", "Stage", "p", "Vs30", "SaF", "ID"),
    with = FALSE
][, PGA := SaF][, SaF := NULL] |> unique()

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) {
    DT[, PGA := round(PGA * 988, 0)]
}

if (PSA_Units %in% c("g")) {
    DT[, PGA := round(PGA, 3)]
}
DT <- DT[order(as.numeric(Vs30))]
AUX <- dcast(
    DT[, c(if (SITE_BY) "siteID", "Standard", "Class", "Stage", "TR", "p", "Vs30", "PGA"), with = FALSE],
    stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "Standard", "Class", "Stage", "TR", "p"), collapse = " + "), "~ Vs30")),
    value.var = "PGA",
    fun.aggregate = mean
)
setcolorder(AUX, c(if (SITE_BY) "siteID", "Standard", "Class", "Stage", "p", sort(as.numeric(unique(DT$Vs30)))))
AUX <- AUX[order(Standard, chmatch(Class, c("Low", "Significant", "High", "Very High", "Extreme")), Stage, p != "mean", p)]


TBL <- AUX |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
)
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
rm(DT, AUX, SITE_BY)
