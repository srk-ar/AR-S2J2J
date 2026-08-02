if (!exists("ID.target") || !length(ID.target)) {
    ID.target <- .resolveDerivedIDTarget(
        UHSTable,
        "PSA_Vs30.R",
        suffix = ".max",
        siteID = .currentTarget("siteID.target")
    )
}
DT <- UHSTable[Tn %in% Tn.target & .matchP(p, p.target) & ID %in% ID.target & Vs30 %in% Vs30.target & TR %in% TR.target]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
    DT <- DT[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
DT <- DT[
    ,
    c(if (SITE_BY) "siteID", "TR", "Vs30", "SaF", "Tn", "p", "ID"),
    with = FALSE
][, PSA := SaF][, SaF := NULL]
DT <- DT[order(as.numeric(Vs30))]
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) {
    DT[, PSA := round(PSA * 988, 0)]
}
if (PSA_Units %in% c("g")) {
    DT[, PSA := round(PSA, 3)]
}
DT <- DT[, .(PSA = max(PSA, na.rm = FALSE)), by = c(if (SITE_BY) "siteID", "Tn", "TR", "Vs30", "p")]
AUX <- dcast(
    DT,
    stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "Tn", "TR", "p"), collapse = " + "), "~ Vs30")),
    value.var = "PSA"
)
setcolorder(AUX, c(if (SITE_BY) "siteID", "Tn", "TR", sort(as.numeric(unique(DT$Vs30))), "p"))
setnames(AUX, old = c("Tn"), new = c("Tn[s]"))
setnames(AUX, old = c("TR"), new = c("TR[yr]"))
TBL <- AUX |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
)
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
rm(DT, AUX, SITE_BY)
