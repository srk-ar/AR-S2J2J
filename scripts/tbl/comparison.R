# nolint start
# Expects: DATASET, METHOD, RESPONSES, RESPONSE_LABELS, PathSummary, PathIter,
# UNITS, FONT.SIZE.BODY and FONT.SIZE.HEADER. Optional: EXECUTIVE.
# Iteration 0 and the retained formulation are compared on the same OOF pairs.

if (!is.character(RESPONSES) || !length(RESPONSES) ||
    anyNA(RESPONSES) || any(!nzchar(RESPONSES)) ||
    anyDuplicated(RESPONSES)) {
  stop("comparison.R: RESPONSES must declare unique response IDs.",
       call. = FALSE)
}

BASE <- fread(file.path(PathIter, "summary_0", "residuals_oof.csv"))[
  dataset == DATASET & response %in% RESPONSES
]
FINAL <- fread(file.path(PathSummary, "residuals_oof.csv"))[
  dataset == DATASET & response %in% RESPONSES
]

KEY <- c("response", "dataset", "SampleID")
COLS <- c(KEY, "y_obs", "y_hat_oof")
if (length(setdiff(COLS, names(BASE))) ||
    length(setdiff(COLS, names(FINAL))) ||
    BASE[, anyDuplicated(.SD), .SDcols = KEY] ||
    FINAL[, anyDuplicated(.SD), .SDcols = KEY] ||
    !setequal(FINAL$response, RESPONSES)) {
  stop("comparison.R: invalid or duplicated OOF keys.", call. = FALSE)
}
COMMON <- merge(
  BASE[, .(response, dataset, SampleID, y_obs.base = y_obs, y_hat.base = y_hat_oof)],
  FINAL[, .(response, dataset, SampleID, y_obs.final = y_obs, y_hat.final = y_hat_oof)],
  by = KEY,
  all = FALSE
)
if (nrow(COMMON) != nrow(FINAL) ||
    COMMON[, any(abs(y_obs.base - y_obs.final) > 1e-10)]) {
  stop("comparison.R: baseline and retained OOF samples are not comparable.")
}

Metrics <- fread(file.path(PathSummary, "metrics.csv"))
Responses <- Metrics[
  method == METHOD & dataset == DATASET & response %in% RESPONSES,
  unique(response)
]
if (!setequal(Responses, RESPONSES)) {
  stop("comparison.R: retained metrics do not cover the declared responses.",
       call. = FALSE)
}
Iterations <- sort(unique(c(
  0L,
  fread(file.path(PathIter, "convergence.csv"), select = "iter")$iter
)))
SELECTED <- rbindlist(lapply(Responses, function(Response) {
  FinalRows <- Metrics[response == Response & dataset == DATASET]
  Matches <- Iterations[vapply(Iterations, function(i) {
    FILE <- file.path(PathIter, sprintf("summary_%d", i), "metrics.csv")
    file.exists(FILE) && identical(
      FinalRows,
      fread(FILE)[response == Response & dataset == DATASET]
    )
  }, logical(1L))]
  if (!length(Matches)) {
    stop(sprintf(
      "comparison.R: retained snapshot was not found for response %s.",
      Response
    ), call. = FALSE)
  }
  data.table(response = Response, iteration = Matches[1L])
}))

DT <- COMMON[, .(
  N.common = .N,
  RMSE.t0 = sqrt(mean((y_obs.final - y_hat.base)^2)),
  RMSE.selected = sqrt(mean((y_obs.final - y_hat.final)^2)),
  R2.t0 = stats::cor(y_obs.final, y_hat.base)^2,
  R2.selected = stats::cor(y_obs.final, y_hat.final)^2,
  RMSE.physical = sqrt(mean((10^y_obs.final - 10^y_hat.final)^2))
), by = response][SELECTED, on = "response"]
if (DT[, any(!is.finite(RMSE.t0) | RMSE.t0 <= 0 |
              !is.finite(RMSE.selected) |
              !is.finite(R2.t0) | !is.finite(R2.selected) |
              !is.finite(RMSE.physical))]) {
  stop("comparison.R: non-finite common-sample metrics.")
}

Families <- sub("[LTV]$", "", DT$response)
if (any(!Families %in% names(UNITS))) {
  stop("comparison.R: unsupported response family.", call. = FALSE)
}
DT[, `:=`(
  `RMSE.reduction [%]` = 100 * (1 - RMSE.selected / RMSE.t0),
  Delta.R2 = R2.selected - R2.t0,
  RMSE.t0 = round(RMSE.t0, 3),
  RMSE.selected = round(RMSE.selected, 3),
  R2.t0 = round(R2.t0, 3),
  R2.selected = round(R2.selected, 3)
)]
DT[, `:=`(
  `RMSE.reduction [%]` = round(`RMSE.reduction [%]`, 1),
  Delta.R2 = round(Delta.R2, 3),
  RMSE.physical = round(
    RMSE.physical,
    fifelse(Families == "ppv", 2L, 3L)
  ),
  Unit = unname(UNITS[Families])
)]
DT <- DT[order(chmatch(response, RESPONSES))]
DT[, response := unname(RESPONSE_LABELS[response])]
if (DT[, any(is.na(response) | !nzchar(response))]) {
  stop("comparison.R: at least one response has no public label.",
       call. = FALSE)
}
if (exists("EXECUTIVE", inherits = FALSE) && isTRUE(EXECUTIVE)) {
  DT <- DT[, .(
    Response = response,
    N = N.common,
    `OOF R²` = R2.selected,
    `OOF RMSE` = RMSE.physical,
    Unit,
    `Delta RMSE [%]` = `RMSE.reduction [%]`,
    `Delta R²` = Delta.R2
  )]
} else {
  setcolorder(DT, c(
    "response", "iteration", "N.common", "RMSE.t0", "RMSE.selected",
    "RMSE.reduction [%]", "R2.t0", "R2.selected", "Delta.R2"
  ))
  DT <- DT[, .(
    response, iteration, N.common, RMSE.t0, RMSE.selected,
    `RMSE.reduction [%]`, R2.t0, R2.selected, Delta.R2
  )]
  setnames(
    DT,
    c(
      "response", "iteration", "N.common", "RMSE.t0", "RMSE.selected",
      "RMSE.reduction [%]", "R2.t0", "R2.selected", "Delta.R2"
    ),
    c(
      "Response", "Retained t*", "Common OOF pairs N",
      "OOF RMSE t=0 [log10(response)]",
      "OOF RMSE t* [log10(response)]", "OOF RMSE reduction [%]",
      "OOF R² t=0", "OOF R² t*", "Delta OOF R²"
    )
  )
}

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(BASE, COLS, COMMON, DT, FINAL, Families, Iterations, KEY, Metrics,
   Responses, SELECTED)
# nolint end
