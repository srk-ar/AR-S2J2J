# nolint start
# Expects: DATASET, RESPONSES, RESPONSE_LABELS, PathDataset, PathResiduals,
# PathSources, FONT.SIZE.BODY and FONT.SIZE.HEADER. Leaves TBL for the wrapper.

DATA <- fread(
  PathDataset,
  select = c("SampleID", "set", "D", "MIC", RESPONSES)
)[set == "train"]
Sources <- fread(PathSources, select = c("SampleID", "Source"))
Residuals <- fread(
  PathResiduals,
  select = c("response", "dataset", "SampleID", "y_obs", "y_hat_oof")
)[dataset == DATASET & response %in% RESPONSES]

if (!nrow(DATA) || DATA[, anyDuplicated(SampleID)] ||
    !nrow(Sources) || Sources[, anyDuplicated(SampleID)] ||
    !setequal(DATA$SampleID, Sources$SampleID)) {
  stop("model.support.R: QDS training rows and sources are not one-to-one.",
       call. = FALSE)
}
if (DATA[, any(!is.finite(D) | D <= 0 | !is.finite(MIC) | MIC <= 0)] ||
    !nrow(Residuals) ||
    Residuals[, anyDuplicated(.SD),
              .SDcols = c("response", "dataset", "SampleID")] ||
    Residuals[, any(!is.finite(y_obs) | !is.finite(y_hat_oof))] ||
    !setequal(Residuals$response, RESPONSES)) {
  stop("model.support.R: training or retained OOF sample is invalid.",
       call. = FALSE)
}

DATA[Sources, on = "SampleID", Source := i.Source]
Residuals[Sources, on = "SampleID", Source := i.Source]
if (DATA[, any(is.na(Source) | !nzchar(Source))] ||
    Residuals[, any(is.na(Source) | !nzchar(Source))]) {
  stop("model.support.R: source attribution is incomplete.", call. = FALSE)
}

DT <- melt(
  DATA,
  id.vars = c("SampleID", "Source", "D", "MIC"),
  measure.vars = RESPONSES,
  variable.name = "response",
  value.name = "value",
  variable.factor = FALSE
)[
  is.finite(value),
  .(
    N.available = .N,
    D.min = min(D),
    D.max = max(D),
    MIC.min = min(MIC),
    MIC.max = max(MIC)
  ),
  by = .(Source, response)
]
AUX <- Residuals[, .(N.OOF = .N), by = .(Source, response)]
DT[AUX, on = .(Source, response), N.OOF := i.N.OOF]
DT[is.na(N.OOF), N.OOF := 0L]
if (!nrow(DT) || !setequal(DT$response, RESPONSES) ||
    DT[, any(!is.finite(N.available) | N.available < 1L |
             !is.finite(N.OOF) | N.OOF < 0L)] ||
    DT[, any(N.OOF > N.available)]) {
  stop("model.support.R: observation counts are inconsistent.", call. = FALSE)
}

DT[, `:=`(
  D.min = round(D.min, 2),
  D.max = round(D.max, 2),
  MIC.min = round(MIC.min, 2),
  MIC.max = round(MIC.max, 2)
)]
DT <- DT[
  order(chmatch(response, RESPONSES), Source),
  .(Source, response, N.available, N.OOF, D.min, D.max, MIC.min, MIC.max)
]
DT[, response := unname(RESPONSE_LABELS[response])]
if (DT[, any(is.na(response) | !nzchar(response))]) {
  stop("model.support.R: at least one response has no public label.",
       call. = FALSE)
}
setnames(
  DT,
  c("Source", "response", "N.available", "N.OOF", "D.min", "D.max",
    "MIC.min", "MIC.max"),
  c("Data source", "Response", "Available observations", "OOF pairs",
    "Minimum D [m]", "Maximum D [m]", "Minimum MIC [kg]",
    "Maximum MIC [kg]")
)

TBL <- DT |>
  buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
  ) |>
  flextable::set_table_properties(layout = "autofit")

rm(AUX, DATA, DT, Residuals, Sources)
# nolint end
