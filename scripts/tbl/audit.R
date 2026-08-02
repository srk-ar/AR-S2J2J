# nolint start
# Expects: PathAudit, FONT.SIZE.BODY and FONT.SIZE.HEADER.

Audit <- fread(PathAudit)
COLS <- c("ScenarioID", "D", "MIC", "n.records", "UP.ok", "energy.ok", "PGA.pos", "PASS")
if (length(setdiff(COLS, names(Audit))) ||
    !nrow(Audit) ||
    Audit[, anyDuplicated(ScenarioID)] ||
    Audit[, any(!is.finite(D) | !is.finite(MIC) |
                !is.finite(n.records) | n.records < 1L)] ||
    Audit[, anyNA(.SD), .SDcols = c("UP.ok", "energy.ok", "PGA.pos", "PASS")]) {
  stop("audit.R: scenario verification is incomplete or invalid.",
       call. = FALSE)
}

DT <- Audit[, ..COLS]
DT[, p := sub("^.*\\.(p[0-9]+)$", "\\1", ScenarioID)]
if (DT[, any(p == ScenarioID)]) {
  stop("audit.R: predictive level is absent from ScenarioID.", call. = FALSE)
}
DT <- DT[, .(
  ScenarioID,
  `D [m]` = D,
  `MIC [kg]` = MIC,
  p,
  N = n.records,
  `PPV.UP` = fifelse(UP.ok, "PASS", "FAIL"),
  `Norm.H` = fifelse(energy.ok, "PASS", "FAIL"),
  PGA = fifelse(PGA.pos, "PASS", "FAIL"),
  PASS = fifelse(PASS, "PASS", "FAIL")
)][order(`D [m]`, `MIC [kg]`, p)]

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(Audit, COLS, DT)
# nolint end
