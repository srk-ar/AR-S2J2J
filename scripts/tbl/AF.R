# Model average
DT <- UHSTable[Tn == 0 & p == p.target &  ID %in% AF.model.target & Vs30 %in% Vs30.target & TR %in% TR.target]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
DT <- DT[, c(if (SITE_BY) "siteID", "TR", "Vs30", "AF", "Tn", "p"), with = FALSE]
# AF are available only in ID=="gmdp" models
DT[, `:=`(AF = round(AF, 2), POE = round(100 * (1 - exp(-50 / TR)), 1))]
AUX <- dcast(
  DT[, c(if (SITE_BY) "siteID", "TR", "Vs30", "AF", "POE"), with = FALSE],
  stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "TR", "POE"), collapse = " + "), "~ Vs30")),
  value.var = "AF", 
  fun.aggregate = mean
)
setnames(AUX, old = "POE", new = "poe[%]")

COLS <- grep(colnames(AUX), pattern = "[0123456789]", value = TRUE)
setnames(AUX, old = COLS, new = paste0(COLS, " m/s"))

TBL <- AUX |> buildTable(
  library         = "flextable", 
  align.body      = "center",
  font.size.body  = FONT.SIZE.BODY, 
  font.size.header= FONT.SIZE.HEADER
)
TBL <- flextable::set_table_properties(TBL,layout = "autofit")
rm(DT, AUX, COLS, SITE_BY)
