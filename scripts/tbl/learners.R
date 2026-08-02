# nolint start
# Expects: DATASET, RESPONSES, RESPONSE_LABELS, LEARNERS, ENSEMBLES, FAMILY,
# PathSummary, FONT.SIZE.BODY and FONT.SIZE.HEADER. Leaves TBL for the QMD
# wrapper.

Responses <- RESPONSES[grepl(FAMILY, RESPONSES)]
Methods <- c(LEARNERS, ENSEMBLES)
if (!length(Responses) || !length(LEARNERS) || !length(ENSEMBLES) ||
    anyDuplicated(Methods)) {
  stop("learners.R: invalid response or method contract.", call. = FALSE)
}

COLS <- c("method", "dataset", "response", "n", "rmse", "r2")
DT <- fread(file.path(PathSummary, "metrics.csv"))[
  dataset == DATASET & response %in% Responses & method %in% Methods,
  ..COLS
]
if (!nrow(DT) ||
    DT[, anyDuplicated(.SD), .SDcols = c("method", "response")] ||
    DT[, any(!is.finite(n) | n < 1L | !is.finite(rmse) | rmse < 0 |
             !is.finite(r2))]) {
  stop("learners.R: incomplete or invalid OOF metrics.", call. = FALSE)
}

AUX <- CJ(response = Responses, method = Methods, unique = TRUE)
if (!fsetequal(DT[, .(response, method)], AUX)) {
  stop("learners.R: metrics do not cover the declared methods and responses.",
       call. = FALSE)
}

DT <- DT[
  order(chmatch(response, Responses), chmatch(method, Methods)),
  .(
    response = unname(RESPONSE_LABELS[response]),
    method,
    n = as.integer(n),
    rmse = round(rmse, 3),
    r2 = round(r2, 3)
  )
]
if (DT[, any(is.na(response) | !nzchar(method))]) {
  stop("learners.R: at least one response or method identifier is missing.",
       call. = FALSE)
}

TBL <- DT |>
  buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
  ) |>
  flextable::set_table_properties(layout = "autofit")

rm(AUX, COLS, DT, Methods, Responses)
# nolint end
