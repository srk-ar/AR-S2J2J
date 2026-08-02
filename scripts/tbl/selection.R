# nolint start
# Expects: root, FONT.SIZE.BODY, FONT.SIZE.HEADER

G <- 9806.65  # mm/s^2 per g

if (!exists("SelectionTable")) SelectionTable <- fread(file.path(root, "data", "records", "plaxis", "IMW.csv"))

DT <- SelectionTable[, .(
  n         = .N,
  PGV.max   = round(max(PGV), 1),
  PGV.med   = round(median(PGV), 1),
  PGA.max   = round(max(PGA) / G, 3),
  AI.med    = round(median(AI), 1),
  CAV5.med  = round(median(CAV5), 0),
  D0595.med = round(median(D0595), 2)
), by = .(ScenarioID, D, MIC)][order(D, MIC)]
setnames(DT, c("D", "MIC", "PGV.max", "PGV.med", "PGA.max", "AI.med", "CAV5.med", "D0595.med"),
         c("D[m]", "MIC[kg]", "PGV.max[mm/s]", "PGV.med[mm/s]", "PGA.max[g]", "AI.med[mm/s]", "CAV5.med[mm/s]", "D0595.med[s]"))

TBL <- DT |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

if (!exists("CAPTION", inherits = FALSE)) {
  CAPTION <- "Selected-record ensemble per scenario: record count, PGV ranking metric, peak acceleration, and median cumulative and duration descriptors of the principal horizontal direction."
}
rm(DT, G)
# nolint end
