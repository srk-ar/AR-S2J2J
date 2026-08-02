# nolint start
# Expects: root, FONT.SIZE.BODY, FONT.SIZE.HEADER

if (!exists("AuditTable")) AuditTable <- fread(file.path(root, "data", "audit", "summary.csv"))

DT <- AuditTable[, .(ScenarioID, SF.L, SF.T, SF.V, UP.ok, energy.ok, PGA.pos, PASS)][order(ScenarioID)]

TBL <- DT |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

if (!exists("CAPTION", inherits = FALSE)) {
  CAPTION <- "Component scale factors and generated-history checks per scenario: vertical target match, horizontal energy preservation after rotation, and positive component peaks."
}
rm(DT)
# nolint end
