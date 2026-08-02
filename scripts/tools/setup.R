# scripts/tools/setup.R
# Loads NGR + htmlwidgets + lightweight helpers. Some legacy table-shape
# wrappers lazily delegate to gmsp when called.

.loadPackages <- function(packages) {
  OK <- vapply(packages, requireNamespace, logical(1L), quietly = TRUE)
  if (!all(OK)) {
    install.packages(packages[!OK], repos = "https://cloud.r-project.org")
    OK <- vapply(packages, requireNamespace, logical(1L), quietly = TRUE)
    if (!all(OK)) {
      stop(sprintf("Missing required R packages: %s",
                   paste(packages[!OK], collapse = ", ")),
           call. = FALSE)
    }
  }

  suppressPackageStartupMessages(
    invisible(lapply(packages, library, character.only = TRUE))
  )
}

.loadPackages(c("data.table", "jsonlite", "here", "NGR", "htmlwidgets"))
source(here::here("scripts", "tools", "json.R"))

if (!exists("MID_LINE_SIZE",  inherits = FALSE)) MID_LINE_SIZE  <- 0.8
if (!exists("THIN_LINE_SIZE", inherits = FALSE)) THIN_LINE_SIZE <- 0.5

.resolveIMF <- function(cols, idx)
  cols[c(idx[idx > 0L], length(cols) + idx[idx < 0L] + 1L)]

.interp2D <- function(Grid, D, MIC, COL) {
  if (D   < min(Grid$D)   || D   > max(Grid$D)   ||
      MIC < min(Grid$MIC) || MIC > max(Grid$MIC)) return(NA_real_)
  MIC.min <- max(Grid$MIC[Grid$MIC <= MIC])
  MIC.max <- min(Grid$MIC[Grid$MIC >= MIC])
  AUX <- Grid[MIC == MIC.min][order(D)]
  V.min <- approx(x = AUX$D, y = AUX[[COL]], xout = D, rule = 1)$y
  if (MIC.min == MIC.max) return(V.min)
  AUX <- Grid[MIC == MIC.max][order(D)]
  V.max <- approx(x = AUX$D, y = AUX[[COL]], xout = D, rule = 1)$y
  V.min + (MIC - MIC.min) / (MIC.max - MIC.min) * (V.max - V.min)
}

.requireGmspTableApi <- function() {
  if (!requireNamespace("gmsp", quietly = TRUE)) {
    stop("Missing required R package: gmsp", call. = FALSE)
  }
  Required <- c("TSW2TSL", "TSL2TSW", "PSW2PSL")
  Missing <- setdiff(Required, getNamespaceExports("gmsp"))
  if (length(Missing)) {
    stop(sprintf("Missing gmsp API: %s", paste(Missing, collapse = ", ")),
         call. = FALSE)
  }
  invisible(NULL)
}

.tsw2tsl <- function(.x) {
  .requireGmspTableApi()
  gmsp::TSW2TSL(.x)
}

.tsl2tsw <- function(.x) {
  .requireGmspTableApi()
  gmsp::TSL2TSW(.x)
}

.getPSWCols <- function(.x, ID = c("PSA", "PSV", "SD")) {
  .requireGmspTableApi()
  IDFilter <- ID
  PSL <- gmsp::PSW2PSL(.x, ids = ID)
  OUT <- unique(PSL[PSL[["ID"]] %chin% IDFilter, .(ID, OCID)])
  paste(OUT$ID, OUT$OCID, sep = ".")
}

.getPSWOCID <- function(.x, ID = c("PSA", "PSV", "SD")) {
  .requireGmspTableApi()
  IDFilter <- ID
  PSL <- gmsp::PSW2PSL(.x, ids = ID)
  unique(PSL[PSL[["ID"]] %chin% IDFilter, OCID])
}

.plotPSA <- function(InputID = NULL, DIR,
                     path = here::here("data", "records", "scenarios"),
                     PATH.in = NULL) {
  if (is.null(PATH.in)) PATH.in <- file.path(path, InputID)
  FILE <- .findScenarioJson(PATH.in)
  if (is.na(FILE) && !is.null(InputID)) {
    FILE <- file.path(PATH.in, sprintf("%s.json", InputID))
  }
  if (!file.exists(FILE)) {
    stop(sprintf(".plotPSA: missing json sidecar under %s", PATH.in),
         call. = FALSE)
  }
  JSON  <- .readJson(FILE)
  XI    <- unlist(.jsonGet(JSON, "XI", .jsonGet(JSON, "xi")))[1L]
  Fmax  <- .jsonRequire(JSON, "Fmax", FILE)
  Column <- paste("PSA", DIR, sep = ".")
  PSTable <- fread(file.path(PATH.in, "PSW.csv"))
  stopifnot(Column %chin% names(PSTable))
  if ("xi" %chin% names(PSTable)) PSTable <- PSTable[xi == XI]
  DATA <- PSTable[Tn >= 1/Fmax, .(ID = RecordID, X = Tn, Y = get(Column), size = MID_LINE_SIZE)][order(X)]
  stopifnot(nrow(DATA) > 0L)
  Plot <- NGR::buildPlot(
    line.type = "spline", plot.height = 1000,
    legend.show = TRUE, legend.layout = "vertical",
    xAxis.log = TRUE, xAxis.legend = "Tn [s]",
    yAxis.legend = paste0("PSA(", DIR, ") [",
                          .jsonRequire(JSON, "TargetUnits", FILE), "/s²]"),
    plot.theme = NGR::hc_theme_538_gridlines(),
    data.lines = DATA)
  Plot$x$hc_opts$series <- lapply(Plot$x$hc_opts$series, function(s) { s$visible <- FALSE; s })
  htmlwidgets::saveWidget(widget = Plot,
                          file   = file.path(PATH.in, sprintf("PSA-%s.html", DIR)),
                          selfcontained = TRUE)
  invisible(Plot)
}

.plotTS <- function(InputID = NULL, DIR,
                    path = here::here("data", "records", "scenarios"),
                    PATH.in = NULL) {
  if (is.null(PATH.in)) PATH.in <- file.path(path, InputID)
  FILE <- .findScenarioJson(PATH.in)
  if (is.na(FILE) && !is.null(InputID)) {
    FILE <- file.path(PATH.in, sprintf("%s.json", InputID))
  }
  if (!file.exists(FILE)) {
    stop(sprintf(".plotTS: missing json sidecar under %s", PATH.in),
         call. = FALSE)
  }
  JSON <- .readJson(FILE)
  Column <- paste("AT", DIR, sep = ".")
  TSW  <- fread(file.path(PATH.in, "TSW.csv"))
  stopifnot(Column %chin% names(TSW))
  DATA <- TSW[, .(ID = RecordID, X = t, Y = get(Column), size = THIN_LINE_SIZE)][order(X)]
  stopifnot(nrow(DATA) > 0L)
  Plot <- NGR::buildPlot(
    line.type     = "line",  plot.height = 1000,
    legend.show   = TRUE,    legend.layout = "vertical",
    xAxis.legend  = "t [s]",
    yAxis.legend  = paste0("AT(", DIR, ") [",
                           .jsonRequire(JSON, "TargetUnits", FILE), "/s²]"),
    plot.theme    = NGR::hc_theme_538_gridlines(),
    data.lines    = DATA)
  Plot$x$hc_opts$series <- lapply(Plot$x$hc_opts$series, function(s) { s$visible <- FALSE; s })
  htmlwidgets::saveWidget(widget = Plot,
                          file   = file.path(PATH.in, sprintf("TS-%s.html", DIR)),
                          selfcontained = TRUE)
  invisible(Plot)
}

.findScenarioJson <- function(PATH.sc) {
  FILES <- list.files(PATH.sc, pattern = "[.]json$", full.names = TRUE)
  if (!length(FILES)) return(NA_character_)

  OK <- vapply(FILES, function(FILE) {
    JSON <- tryCatch(.readJson(FILE), error = function(e) NULL)
    is.list(JSON) &&
      all(c("OutputID", "Fmax", "D", "MIC", "P") %chin% names(JSON))
  }, logical(1L))
  FILES <- FILES[OK]
  if (!length(FILES)) return(NA_character_)
  if (length(FILES) > 1L) {
    stop(sprintf(".findScenarioJson: multiple scenario json sidecars under %s.",
                 PATH.sc), call. = FALSE)
  }
  FILES
}

.readScenarioIndex <- function(PATH.scenarios) {
  DIRS <- list.dirs(PATH.scenarios, recursive = FALSE, full.names = TRUE)
  LIST <- lapply(DIRS, function(DIR) {
    JSON.file <- .findScenarioJson(DIR)
    if (is.na(JSON.file)) {
      FILES <- file.path(DIR, c("TSW.csv", "PSW.csv", "IMW.csv"))
      if (any(file.exists(FILES))) {
        stop(sprintf(".readScenarioIndex: missing scenario json sidecar under %s",
                     DIR), call. = FALSE)
      }
      return(NULL)
    }
    JSON <- .readJson(JSON.file)
    data.table(
      ScenarioID = .jsonRequire(JSON, "OutputID", JSON.file),
      PATH.sc    = DIR,
      JSON.file  = JSON.file,
      InputID    = .jsonGet(JSON, "InputID", NA_character_),
      Fmax       = .jsonRequire(JSON, "Fmax", JSON.file),
      D          = .jsonRequire(JSON, "D", JSON.file),
      MIC        = .jsonRequire(JSON, "MIC", JSON.file),
      P          = .jsonRequire(JSON, "P", JSON.file))
  })
  LIST <- LIST[!vapply(LIST, is.null, logical(1L))]
  if (!length(LIST)) {
    stop(sprintf(".readScenarioIndex: no scenarios found under %s.",
                 PATH.scenarios), call. = FALSE)
  }
  rbindlist(LIST, use.names = TRUE)
}

.buildMasterIMW <- function(PATH.out) {
  SCENARIOS <- .readScenarioIndex(PATH.out)
  LIST <- lapply(seq_len(nrow(SCENARIOS)), function(i) {
    DIR <- SCENARIOS$PATH.sc[i]
    FILE <- file.path(DIR, "IMW.csv")
    if (!file.exists(FILE)) return(NULL)
    DT <- fread(FILE)
    JSON.file <- SCENARIOS$JSON.file[i]
    JSON <- .readJson(JSON.file)
    ScenarioID <- .jsonRequire(JSON, "OutputID", JSON.file)
    set(DT, j = "ScenarioID", value = ScenarioID)
    set(DT, j = "Fmax",       value = .jsonRequire(JSON, "Fmax", JSON.file))
    set(DT, j = "D",          value = .jsonRequire(JSON, "D", JSON.file))
    set(DT, j = "MIC",        value = .jsonRequire(JSON, "MIC", JSON.file))
    set(DT, j = "P",          value = .jsonRequire(JSON, "P", JSON.file))
    DT
  })
  LIST <- LIST[!vapply(LIST, is.null, logical(1L))]
  if (!length(LIST)) stop(sprintf(".buildMasterIMW: no scenario IMW.csv files under %s.", PATH.out))
  COLS <- names(LIST[[1L]])
  OK   <- vapply(LIST, function(DT) identical(names(DT), COLS), logical(1L))
  if (!all(OK)) stop(".buildMasterIMW: IMW schemas differ across scenarios.", call. = FALSE)
  DT <- rbindlist(LIST, use.names = TRUE)
  COLS <- intersect(c("ScenarioID","Fmax","D","MIC","P","RecordID","OCID"), names(DT))
  setcolorder(DT, c(COLS, setdiff(names(DT), COLS)))
  fwrite(DT, file.path(PATH.out, "IMW.csv"))
  message(sprintf(".buildMasterIMW: %d rows -> %s/IMW.csv", nrow(DT), PATH.out))
  invisible(DT)
}
