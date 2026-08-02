# nolint start
# Expects: root, ID (response), D_TARGET (distance in m), FONT.SIZE.BODY, FONT.SIZE.HEADER

Q.SET <- c(150, 200, 250, 300, 350, 400)

if (!exists("DemandTable")) {
  AUX <- fread(file.path(root, "data", "datasets", "QDS.csv"))[set == "predict", .(SampleID, Q = MIC, D, SD)]
  DemandTable <- fread(file.path(root, "data", "export", "Yo.csv"))[AUX, on = "SampleID"]
}

DIGITS <- if (grepl("^ppv", ID)) 1L else 3L
DT <- dcast(
  DemandTable[response == ID & D == D_TARGET & Q %in% Q.SET,
              .(Q, p = paste0(round(100 * p), "%"), value = round(10^value, DIGITS))],
  Q ~ p, value.var = "value"
)
setnames(DT, "Q", "MIC[kg]")

TBL <- DT |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(DT, DIGITS, Q.SET)
# nolint end
