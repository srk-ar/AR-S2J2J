# nolint start
# Expects: DATASET, METHOD, RESPONSES, RESPONSE_LABELS, PathSummary, PathIter,
# UNITS, FONT.SIZE.BODY and FONT.SIZE.HEADER. Optional: FAMILY.

if (!is.character(RESPONSES) || !length(RESPONSES) ||
    anyNA(RESPONSES) || any(!nzchar(RESPONSES)) ||
    anyDuplicated(RESPONSES)) {
  stop("performance.R: RESPONSES must declare unique response IDs.",
       call. = FALSE)
}

Metrics <- fread(file.path(PathSummary, "metrics.csv"))
Residuals <- fread(file.path(PathSummary, "residuals_oof.csv"))
COLS.metrics <- c("method", "dataset", "response", "n", "rmse", "r2")
COLS.residuals <- c("dataset", "response", "SampleID", "y_obs", "y_hat_oof")
if (length(setdiff(COLS.metrics, names(Metrics))) ||
    length(setdiff(COLS.residuals, names(Residuals)))) {
  stop("performance.R: invalid summary-product schema.", call. = FALSE)
}

SUMMARY <- Metrics[
  method == METHOD & dataset == DATASET,
  .(response, n, rmse, r2)
]
if (exists("FAMILY", inherits = FALSE)) {
  if (!is.character(FAMILY) || length(FAMILY) != 1L || !nzchar(FAMILY)) {
    stop("performance.R: FAMILY must be one non-empty pattern.",
         call. = FALSE)
  }
  if (any(!grepl(FAMILY, RESPONSES))) {
    stop("performance.R: RESPONSES cross the declared family.",
         call. = FALSE)
  }
  SUMMARY <- SUMMARY[grepl(FAMILY, response)]
}
if (!nrow(SUMMARY) || SUMMARY[, anyDuplicated(response)] ||
    SUMMARY[, any(!is.finite(n) | !is.finite(rmse) | !is.finite(r2))]) {
  stop("performance.R: retained metrics are incomplete.", call. = FALSE)
}
if (!setequal(SUMMARY$response, RESPONSES)) {
  stop("performance.R: retained metrics do not cover the declared responses.",
       call. = FALSE)
}

Iterations <- sort(unique(c(
  0L,
  fread(file.path(PathIter, "convergence.csv"), select = "iter")$iter
)))
SELECTED <- rbindlist(lapply(SUMMARY$response, function(Response) {
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
      "performance.R: retained snapshot was not found for response %s.",
      Response
    ), call. = FALSE)
  }
  data.table(response = Response, iteration = Matches[1L])
}))

RESIDUAL.CHECK <- Residuals[
  dataset == DATASET & is.finite(y_obs) & is.finite(y_hat_oof),
  .(rmse.residuals = sqrt(mean((y_obs - y_hat_oof)^2)),
    r2.residuals = stats::cor(y_obs, y_hat_oof)^2),
  by = response
][SUMMARY, on = "response"]
if (nrow(RESIDUAL.CHECK) != nrow(SUMMARY) ||
    RESIDUAL.CHECK[, any(!is.finite(rmse.residuals) |
      !is.finite(r2.residuals) |
      abs(rmse.residuals - rmse) > 1e-8 |
      abs(r2.residuals - r2) > 1e-8)]) {
  stop("performance.R: residuals_oof does not reconstruct the retained ensemble metrics.")
}

DT <- SUMMARY[SELECTED, on = "response"]
AUX <- Residuals[
  dataset == DATASET & is.finite(y_obs) & is.finite(y_hat_oof),
  .(rmse.physical = sqrt(mean((10^y_obs - 10^y_hat_oof)^2))),
  by = response
]
DT <- merge(DT, AUX, by = "response", all.x = TRUE)
if (DT[, any(!is.finite(rmse.physical))]) {
  stop("performance.R: physical-unit RMSE could not be calculated for every response.")
}

Families <- sub("[LTV]$", "", DT$response)
if (any(!Families %in% names(UNITS))) {
  stop("performance.R: unsupported response family.", call. = FALSE)
}
DT[, `:=`(
  units = unname(UNITS[Families]),
  r2 = round(r2, 3),
  rmse = round(rmse, 3),
  rmse.physical = round(rmse.physical, fifelse(Families == "ppv", 2L, 3L))
)]
DT <- DT[, .(response, iteration, n, r2, rmse, rmse.physical, units)]
DT <- DT[order(chmatch(response, RESPONSES))]
DT[, response := unname(RESPONSE_LABELS[response])]
if (DT[, any(is.na(response) | !nzchar(response))]) {
  stop("performance.R: at least one response has no public label.",
       call. = FALSE)
}
setnames(
  DT,
  c("response", "iteration", "n", "r2", "rmse", "rmse.physical", "units"),
  c(
    "Response", "Retained t*", "OOF pairs N", "OOF R²",
    "OOF RMSE [log10(response)]", "OOF RMSE [physical]", "Physical unit"
  )
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(AUX, COLS.metrics, COLS.residuals, DT, Families, Iterations, Metrics,
   RESIDUAL.CHECK, Residuals, SELECTED, SUMMARY)
# nolint end
