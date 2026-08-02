# nolint start
# Expects: DATASET, RESPONSES, RESPONSE_LABELS, PathSummary, FONT.SIZE.BODY and
# FONT.SIZE.HEADER.

DT <- fread(file.path(PathSummary, "prediction_quantiles.csv"))[
  dataset == DATASET,
  .(
    response,
    N.OOF = n,
    q50 = round(q_50, 3),
    q90 = round(q_90, 3),
    q95 = round(q_95, 3),
    f90.p50 = round(10^(q_90 - q_50), 2),
    f95.p50 = round(10^(q_95 - q_50), 2)
  )
]
if (!nrow(DT) || DT[, anyDuplicated(response)] ||
    DT[, any(!is.finite(N.OOF) | !is.finite(q50) |
             !is.finite(q90) | !is.finite(q95))]) {
  stop("bands.R: incomplete predictive-quantile product.")
}
DT <- DT[order(chmatch(response, RESPONSES))]
DT[, response := unname(RESPONSE_LABELS[response])]
if (DT[, any(is.na(response) | !nzchar(response))]) {
  stop("bands.R: at least one response has no public label.", call. = FALSE)
}
setnames(
  DT,
  c("response", "N.OOF", "q50", "q90", "q95", "f90.p50", "f95.p50"),
  c(
    "Response", "OOF pairs N", "Residual q50 [log10]",
    "Residual q90 [log10]", "Residual q95 [log10]", "p90/p50 factor",
    "p95/p50 factor"
  )
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(DT)
# nolint end
