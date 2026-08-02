## buildDatasets.R
##
## Agnostic dataset assembler. Reads the manifest, joins per-domain CSVs
## by the manifest key, and writes one CSV per declared dataset to
## manifest$dirs$datasets.
##
## Knows nothing about charge, distance, blocks, or any project semantics.
## The only semantic distinction is the domain `role`: domains with
## role="response" are left-joined (NA preserved); domains with
## role="feature" are inner-joined (rows without all required features
## are dropped). Rows whose every response column is NA are tagged as
## prediction rows in the `set` column; the rest are training rows.

library(data.table)

buildDatasets <- function(manifest) {
  key          <- manifest$key
  domains_dir  <- manifest$dirs$domains
  datasets_dir <- manifest$dirs$datasets

  # Wipe + recreate so datasets no longer in the manifest don't linger as
  # orphans that downstream steps (buildGrid, runModel) would still pick up.
  if (dir.exists(datasets_dir)) unlink(datasets_dir, recursive = TRUE)
  dir.create(datasets_dir, recursive = TRUE)

  ## ── load every declared domain into a named list ─────────────────────────
  D <- list()
  for (nm in names(manifest$domains)) {
    f <- file.path(domains_dir, manifest$domains[[nm]]$file)
    if (!file.exists(f)) stop(sprintf("buildDatasets: %s not found", f))
    D[[nm]] <- fread(f)
    if (!key %in% names(D[[nm]]))
      stop(sprintf("buildDatasets: %s missing key column %s", f, key))
  }

  response_letter <- names(Filter(function(d) isTRUE(d$role == "response"),
                                  manifest$domains))
  if (length(response_letter) != 1L) {
    stop("buildDatasets: exactly one domain must declare role=\"response\".")
  }
  response_cols <- manifest$responses$names

  # Guard: every declared dataset must include the response domain
  for (ds_name in names(manifest$datasets)) {
    if (!response_letter %in% manifest$datasets[[ds_name]]$domains)
      stop(sprintf("buildDatasets: dataset '%s' does not include response domain '%s'",
                   ds_name, response_letter))
  }

  # Guard: no feature domain column can share a name with a response column
  feat_letters <- names(Filter(function(d) !isTRUE(d$role == "response"), manifest$domains))
  for (nm in feat_letters) {
    overlap <- intersect(names(D[[nm]]), c(response_cols, key))
    overlap <- setdiff(overlap, key)  # key allowed on both sides (join column)
    if (length(overlap) > 0L)
      stop(sprintf("buildDatasets: feature domain '%s' has columns that overlap with responses: [%s]",
                   nm, paste(overlap, collapse = ", ")))
  }

  ## ── assemble each dataset ────────────────────────────────────────────────
  for (ds_name in names(manifest$datasets)) {
    letters <- manifest$datasets[[ds_name]]$domains
    feats   <- setdiff(letters, response_letter)

    ## inner-join all feature domains by key
    if (length(feats) == 0L) {
      stop(sprintf("buildDatasets: dataset %s has no feature domain", ds_name))
    }
    ds <- D[[feats[1]]]
    for (l in feats[-1]) {
      ds <- merge(ds, D[[l]], by = key)   # inner by default
    }

    ## left-join the response domain (preserves prediction-only rows)
    if (response_letter %in% letters) {
      ds <- merge(ds, D[[response_letter]], by = key, all.x = TRUE)
    }

    ## tag training vs prediction rows
    resp_present <- intersect(response_cols, names(ds))
    if (length(resp_present) == 0L) {
      ds[, set := "predict"]
    } else {
      has_any_resp <- ds[, Reduce(`|`, lapply(.SD, function(v) !is.na(v))),
                         .SDcols = resp_present]
      ds[, set := ifelse(has_any_resp, "train", "predict")]
    }

    setcolorder(ds, c(key, "set"))
    fwrite(ds, file.path(datasets_dir, paste0(ds_name, ".csv")))

    cat(sprintf("%-6s: %d rows  (train=%d, predict=%d)  [%s]\n",
                ds_name, nrow(ds),
                sum(ds$set == "train"),
                sum(ds$set == "predict"),
                paste(letters, collapse = "+")))
  }

  ## ── location index for postProcess ──────────────────────────────────────
  ## Write data/domains/index.csv: SampleID + post.location cols.
  ## postProcess() reads this to join location into predictions.csv.
  ## Location columns come from the DOMAIN files (dataset-independent: the
  ## active datasets need not carry the raw MIC/D columns).
  loc_cols <- manifest$post$location
  stopifnot(!is.null(loc_cols), length(loc_cols) > 0L)
  IDX <- Reduce(function(a, b) merge(a, b, by = key, all = TRUE), Filter(Negate(is.null),
    lapply(manifest$domains, function(dm) {
      DT <- fread(file.path(domains_dir, dm$file))
      hit <- intersect(loc_cols, names(DT))
      if (!length(hit)) NULL else DT[, c(key, hit), with = FALSE]
    })))
  stopifnot(!is.null(IDX), all(loc_cols %in% names(IDX)))
  IDX <- unique(IDX[, c(key, loc_cols), with = FALSE], by = key)
  setorderv(IDX, key)
  fwrite(IDX, file.path(domains_dir, "index.csv"))
  cat(sprintf("index.csv: %d rows  [%s]\n", nrow(IDX), paste(loc_cols, collapse = ", ")))
}
