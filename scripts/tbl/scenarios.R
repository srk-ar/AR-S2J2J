# nolint start
# Expects: PathAudit, FONT.SIZE.BODY and FONT.SIZE.HEADER. Optional: EXECUTIVE.

Audit <- fread(PathAudit)
COLS <- c("ScenarioID", "D", "MIC", "SF.L", "SF.T", "SF.V", "n.records")
if (length(setdiff(COLS, names(Audit))) ||
    !nrow(Audit) ||
    Audit[, anyDuplicated(ScenarioID)] ||
    Audit[, any(!is.finite(D) | !is.finite(MIC) |
                !is.finite(SF.L) | !is.finite(SF.T) | !is.finite(SF.V) |
                !is.finite(n.records) | n.records < 1L)]) {
  stop("scenarios.R: scenario inventory is incomplete or invalid.",
       call. = FALSE)
}

if (exists("EXECUTIVE", inherits = FALSE) && isTRUE(EXECUTIVE)) {
  DT <- melt(
    Audit,
    measure.vars = c("SF.L", "SF.T", "SF.V"),
    variable.name = "Response",
    value.name = "PPV",
    variable.factor = FALSE
  )[, .(
    Minimum = round(min(PPV), 2),
    Maximum = round(max(PPV), 2)
  ), by = Response]
  DT <- DT[, .(
    Response = sub("^SF[.]", "PPV.", Response),
    Minimum,
    Maximum,
    Unit = "mm/s"
  )]
} else {
  DT <- Audit[, ..COLS]
  DT[, p := sub("^.*\\.(p[0-9]+)$", "\\1", ScenarioID)]
  if (DT[, any(p == ScenarioID)]) {
    stop("scenarios.R: predictive level is absent from ScenarioID.",
         call. = FALSE)
  }
  DT <- DT[, .(
    ScenarioID,
    `D [m]` = D,
    `MIC [kg]` = MIC,
    p,
    `PPV.L [mm/s]` = round(SF.L, 2),
    `PPV.T [mm/s]` = round(SF.T, 2),
    `PPV.V [mm/s]` = round(SF.V, 2),
    N = n.records
  )][order(`D [m]`, `MIC [kg]`, p)]
}

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(Audit, COLS, DT)
# nolint end
