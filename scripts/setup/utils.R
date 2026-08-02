# nolint start
readFile <- function(file, hint, readFun, ...) {
  if (!file.exists(file)) stop(paste0("Missing data: ", basename(file), ". ", hint))
  readFun(file, ...)
}

.fmt <- function(x, d = 2) formatC(x, format = "f", digits = d)

.fmti <- function(x) formatC(x, format = "d", big.mark = ",")

.matchP <- function(p, target) {
  TOL <- 1e-10
  PText <- trimws(as.character(p))
  TargetText <- trimws(as.character(target))
  PNum <- suppressWarnings(as.numeric(PText))
  TargetNum <- suppressWarnings(as.numeric(TargetText))

  OK <- rep(FALSE, length(PText))
  Text <- tolower(TargetText[!is.finite(TargetNum)])
  Text <- Text[!is.na(Text) & nzchar(Text)]
  if (length(Text)) OK <- OK | tolower(PText) %in% Text

  TargetNum <- TargetNum[is.finite(TargetNum)]
  if (length(TargetNum)) {
    OK <- OK | vapply(PNum, function(x) {
      is.finite(x) && any(abs(x - TargetNum) <= TOL)
    }, logical(1))
  }
  OK
}

.formatNumber <- function(x, digits = 0) {
  if (digits == 0) .fmti(round(as.numeric(x))) else .fmt(as.numeric(x), digits)
}

formatRange <- function(x, digits = 0, unit = NULL) {
  OUT <- paste(.formatNumber(range(as.numeric(x), na.rm = TRUE), digits), collapse = " to ")
  if (is.null(unit) || !nzchar(unit)) OUT else paste(OUT, unit)
}

.formatAEP <- function(TR) paste0("1/", .fmti(as.numeric(TR)))

.convertKmax <- function(x, units) {
  if (units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) round(x * 988, 0)
  else if (units == "g") round(x, 3)
  else x
}

.currentTarget <- function(name, envir = parent.frame()) {
  if (exists(name, envir = envir, inherits = TRUE)) get(name, envir = envir, inherits = TRUE) else NULL
}

.cleanTarget <- function(x) {
  x <- unique(as.character(x))
  x[!is.na(x) & nzchar(x)]
}

.sourceChunkLabel <- function(options) {
  Code <- options$yaml.code
  Line <- grep("^#\\|[[:space:]]*label:", Code, value = TRUE)
  if (!length(Line)) return(options$label)
  trimws(sub(
    "^#\\|[[:space:]]*label:[[:space:]]*",
    "",
    Line[[1L]]
  ))
}

.siteChunkLabel <- function(label, envir = knitr::knit_global()) {
  if (length(label) != 1L || is.na(label) ||
      !grepl("^(fig|tbl)-", label)) {
    return(label)
  }
  SiteID <- trimws(.cleanTarget(
    .currentTarget("siteID.target", envir = envir)
  ))
  if (!length(SiteID)) return(label)
  if (length(SiteID) != 1L ||
      !nzchar(SiteID) ||
      grepl("[^[:alnum:]_.-]", SiteID)) {
    stop(
      "literal multisite chunk labels require one valid siteID.target.",
      call. = FALSE
    )
  }
  Kind <- sub("^((fig|tbl)-).*", "\\1", label)
  Stem <- sub("^(fig|tbl)-", "", label)
  Prefix <- paste0(Kind, tolower(SiteID), "-")
  if (startsWith(label, Prefix)) label else paste0(Prefix, Stem)
}

.siteChunkLabelHook <- function(options) {
  options$label <- .siteChunkLabel(.sourceChunkLabel(options))
  options
}

.installSiteChunkLabelHook <- function() {
  if (!isTRUE(getOption("psha.multisite.literal.includes"))) {
    return(invisible(FALSE))
  }
  Hook <- knitr::opts_hooks$get("label")
  if (is.function(Hook) &&
      isTRUE(attr(Hook, "psha.multisite.literal.includes"))) {
    return(invisible(TRUE))
  }
  if (!is.null(Hook)) {
    stop(
      "literal multisite labels cannot replace an existing knitr label hook.",
      call. = FALSE
    )
  }
  Hook <- .siteChunkLabelHook
  attr(Hook, "psha.multisite.literal.includes") <- TRUE
  knitr::opts_hooks$set(label = Hook)
  invisible(TRUE)
}

.validateReportContext <- function(x, context = "report context") {
  COLS <- c("multiple", "key", "label")
  if (!is.list(x) || !identical(names(x), COLS)) {
    stop(sprintf(
      "%s: ReportContext must contain exactly: %s.",
      context, paste(COLS, collapse = ", ")
    ), call. = FALSE)
  }
  if (!is.logical(x$multiple) || length(x$multiple) != 1L ||
      is.na(x$multiple)) {
    stop(sprintf("%s: ReportContext multiple must be TRUE or FALSE.",
                 context), call. = FALSE)
  }
  if (!is.character(x$key) || length(x$key) != 1L ||
      is.na(x$key) || !nzchar(trimws(x$key)) ||
      grepl("[^[:alnum:]_.-]", x$key)) {
    stop(sprintf("%s: ReportContext key is invalid.", context),
         call. = FALSE)
  }
  if (!is.character(x$label) || length(x$label) != 1L ||
      is.na(x$label) || !nzchar(trimws(x$label))) {
    stop(sprintf("%s: ReportContext label must be one non-empty value.",
                 context), call. = FALSE)
  }
  list(
    multiple = x$multiple,
    key = trimws(x$key),
    label = trimws(x$label)
  )
}

.newReportContext <- function(multiple, key, label, context = "report") {
  .validateReportContext(
    list(
      multiple = multiple,
      key = key,
      label = label
    ),
    context = context
  )
}

.currentReportContext <- function(envir = parent.frame()) {
  if (!exists("ReportContext", envir = envir, inherits = TRUE)) return(NULL)
  .validateReportContext(
    get("ReportContext", envir = envir, inherits = TRUE)
  )
}

.reportLabel <- function(envir = parent.frame()) {
  Target <- trimws(.cleanTarget(
    .currentTarget("siteLabel.target", envir = envir)
  ))
  if (length(Target)) {
    if (length(Target) != 1L || !nzchar(Target)) {
      stop("siteLabel.target must be one non-empty value.", call. = FALSE)
    }
    return(Target)
  }
  OUT <- .currentReportContext(envir = envir)
  if (is.null(OUT)) "" else OUT$label
}

.reportMultiple <- function(envir = parent.frame()) {
  OUT <- .currentReportContext(envir = envir)
  !is.null(OUT) && OUT$multiple
}

.composeTargetStem <- function(stem, envir = parent.frame()) {
  if (length(stem) != 1L || is.na(stem) || !nzchar(stem)) {
    stop("target stem must be one non-empty value.", call. = FALSE)
  }
  OUT <- .currentReportContext(envir = envir)
  if (!is.null(OUT)) {
    if (!OUT$multiple) return(stem)
    return(paste(OUT$key, stem, sep = "-"))
  }
  AUX <- .cleanTarget(.currentTarget("siteID.target", envir = envir))
  AUX <- tolower(AUX)
  if (!length(AUX)) return(stem)
  if (length(AUX) != 1L) {
    stop("target stem requires one site key.", call. = FALSE)
  }
  paste(AUX, stem, sep = "-")
}

.targetChoices <- function(x, n = 12L) {
  x <- .cleanTarget(x)
  OUT <- head(x, n)
  if (length(x) > n) OUT <- c(OUT, sprintf("... %d more", length(x) - n))
  paste(OUT, collapse = ", ")
}

.requireOneTarget <- function(values, targetName, context) {
  Values <- .cleanTarget(values)
  if (length(Values) == 1L) return(Values)
  if (!length(Values)) {
    stop(sprintf("%s: no %s candidates found.", context, targetName), call. = FALSE)
  }
  stop(sprintf(
    "%s: set %s to one of: %s.",
    context, targetName, .targetChoices(Values)
  ), call. = FALSE)
}

# Single definition of the deaggregation display grid: native (Mw, R)
# bins merge into 2x2 blocks by SUM (p is an additive PMF — never
# interpolate). R cannot go finer than 2x: the OpenQuake rupture
# discretization populates alternate 10-km distance bins on interface
# sources (verified on AR-S2L1W), so native-bin display stripes. Steps
# carry diff() float noise: grid and labels rounded. Input: one panel
# with columns Mw, R, p. Output adds MwBlk/RBlk dims.
.rmwBlocks <- function(x) {
  MwBlk <- round(2 * unique(diff(sort(unique(x$Mw))))[1], 3)
  RBlk  <- round(2 * unique(diff(sort(unique(x$R))))[1], 3)
  x[, .(p = sum(p)), by = .(
    Mw = round(MwBlk * floor(Mw / MwBlk) + MwBlk / 2, 2),
    R  = round(RBlk * floor(R / RBlk) + RBlk / 2, 1)
  )][, `:=`(MwBlk = MwBlk, RBlk = RBlk)][]
}

# Deaggregation caption statistics for one (Tn, TR) panel: modal block
# on the DISPLAY grid (.rmwBlocks) plus the grid-invariant mean scenario.
.rmwStats <- function(tn, tr) {
  DT <- RMwTable
  if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
    DT <- DT[siteID %in% siteID.target]
  }
  AUX <- sort(unique(DT$TR))
  TRo <- AUX[which.min(abs(AUX - tr))]
  DT <- DT[Tn == tn & TR == TRo]
  MwBar <- DT[, sum(p * Mw) / sum(p)]
  RBar  <- DT[, sum(p * R) / sum(p)]
  DT <- .rmwBlocks(DT[, .(Mw, R, p)])
  Modal <- DT[which.max(p)]
  list(
    TR = TRo, MwBlk = Modal$MwBlk, RBlk = Modal$RBlk,
    MwMode = Modal$Mw, RMode = Modal$R,
    pctMode = 100 * Modal$p / sum(DT$p),
    MwBar = MwBar, RBar = RBar
  )
}

# SRS caption hydration: executive-bullet captions computed from the
# match product tables (bounded reads; every number from a query).
# Client target wording is FIXED nomenclature: MCE = max of scenario
# means, MCE (84%) = max of scenario p84 — never internal lettering.
.srsTargetText <- function(pathSRS) {
  Config <- jsonlite::fromJSON(file.path(pathSRS, "metadata", "runMatch.json"), simplifyVector = FALSE)
  Target <- Config$target
  p <- as.character(Target$p)
  Txt <- switch(as.character(Target$ID),
    design = "the design envelope max(UHS TR-10,000, MCE (84%))",
    max = if (identical(p, "0.84")) "the MCE (84%) envelope" else "the MCE envelope",
    sprintf("the mean UHS at TR = %s yr", prettyNum(round(as.numeric(Target$TR), 0), big.mark = ","))
  )
  Band <- if (!is.null(Target$envelope)) {
    sprintf(" (containment band p%s-p%s)", sub("^0[.]", "", Target$envelope$lower), sub("^0[.]", "", Target$envelope$upper))
  } else ""
  list(text = Txt, band = Band, Vs30 = as.numeric(Target$Vs30))
}

.srsReadCols <- function(file, select, context) {
  Head <- names(data.table::fread(file, nrows = 0L))
  Missing <- setdiff(select, Head)
  if (length(Missing)) {
    stop(sprintf("%s: %s missing columns: %s.", context, basename(file), paste(Missing, collapse = ", ")),
         call. = FALSE)
  }
  data.table::fread(file, select = select)
}

.srsPsaG <- function(pathSRS) {
  File <- file.path(pathSRS, "metadata", "runMatch.json")
  Config <- jsonlite::fromJSON(File, simplifyVector = FALSE)
  Units <- Config$units$psa
  if (is.null(Units) || !nzchar(Units)) {
    stop(sprintf("SRS caption requires units.psa in %s.", File), call. = FALSE)
  }
  switch(gsub("\\s+", "", tolower(Units)),
    "g" = 1,
    "m/s2" = 9.80665,
    "m/s^2" = 9.80665,
    "m/s/s" = 9.80665,
    "cm/s2" = 980.665,
    "cm/s^2" = 980.665,
    "cm/s/s" = 980.665,
    "gal" = 980.665,
    "mm/s2" = 9806.65,
    "mm/s^2" = 9806.65,
    "mm/s/s" = 9806.65,
    stop(sprintf("SRS caption: unsupported units.psa '%s' in %s.", Units, File), call. = FALSE)
  )
}

.srsMotionUnit <- function(pathSRS) {
  File <- file.path(pathSRS, "metadata", "runMatch.json")
  Config <- jsonlite::fromJSON(File, simplifyVector = FALSE)
  Units <- gsub("\\s+", "", tolower(Config$units$psa))
  switch(Units,
    "m/s2" = "m",
    "m/s^2" = "m",
    "m/s/s" = "m",
    "cm/s2" = "cm",
    "cm/s^2" = "cm",
    "cm/s/s" = "cm",
    "gal" = "cm",
    "mm/s2" = "mm",
    "mm/s^2" = "mm",
    "mm/s/s" = "mm",
    "mm"
  )
}

.srsMetricRange <- function(x, digits, unit = NULL) {
  x <- as.numeric(x)
  x <- x[is.finite(x)]
  if (!length(x)) stop("SRS caption: metric range has no finite values.", call. = FALSE)
  OUT <- paste(.formatNumber(range(x), digits), collapse = "-")
  if (is.null(unit) || !nzchar(unit)) OUT else paste(OUT, unit)
}

.srsCapDir <- function(pathSRS, id, dir) {
  SEL <- data.table::fread(file.path(pathSRS, "metadata", "selection.csv"), select = c("RecordID", "EventID"))
  SC <- .srsReadCols(file.path(pathSRS, "match", "scale.csv"), c("RecordID", "scaleFactor"), "SRS caption")
  SC <- SC[RecordID %in% SEL$RecordID & is.finite(scaleFactor)]
  if (!nrow(SC)) stop("SRS caption: scale.csv has no finite selected scaleFactor values.", call. = FALSE)

  File <- file.path(pathSRS, "data", "IMW.csv")
  if (file.exists(File)) {
    MI <- .srsReadCols(
      File,
      c("RecordID", "OCID", "PGA", "AI", "D0595", "PGV", "PGD", "CAV", "CAV5"),
      "SRS caption"
    )
    data.table::setnames(MI, "OCID", "DIR")
  } else {
    MI <- .srsReadCols(
      file.path(pathSRS, "metadata", "MasterIndex.csv"),
      c("RecordID", "DIR", "PGA", "AI", "D0595", "PGV", "PGD", "CAV", "CAV5"),
      "SRS caption"
    )
  }
  MI <- MI[SEL, on = "RecordID", nomatch = 0L][DIR == dir]
  if (!nrow(MI)) stop(sprintf("SRS caption: no metric rows for component %s.", dir), call. = FALSE)

  G <- .srsPsaG(pathSRS)
  U <- .srsMotionUnit(pathSRS)
  Metric <- switch(id,
    AT = sprintf(
      "matched peak accelerations %s, significant durations D5-95 %s",
      .srsMetricRange(MI$PGA / G, 2, "g"), .srsMetricRange(MI$D0595, 0, "s")
    ),
    VT = sprintf("matched peak velocities %s", .srsMetricRange(MI$PGV, 0, paste0(U, "/s"))),
    DT = sprintf("matched peak displacements %s", .srsMetricRange(MI$PGD, 1, U)),
    AI = sprintf("matched Arias intensities %s", .srsMetricRange(MI$AI, 0, paste0(U, "/s"))),
    CAV = sprintf("matched CAV %s", .srsMetricRange(MI$CAV, 0, paste0(U, "/s"))),
    CAV5 = sprintf("matched CAV5 %s", .srsMetricRange(MI$CAV5, 0, paste0(U, "/s"))),
    sprintf("%d matched records", nrow(MI))
  )
  sprintf(
    "Scaled suite of %d records (%d events), component %s: %s; scale factors %.2f-%.2f (median %.2f).",
    data.table::uniqueN(SEL$RecordID), data.table::uniqueN(SEL$EventID), dir,
    Metric, min(SC$scaleFactor), max(SC$scaleFactor), stats::median(SC$scaleFactor)
  )
}

.srsCapSpec <- function(pathSRS, id, dir) {
  Target <- .srsTargetText(pathSRS)
  ST <- data.table::fread(file.path(pathSRS, "match", "stage.csv"))
  CO <- data.table::fread(file.path(pathSRS, "match", "compatibility.csv"))
  sprintf(
    "Matched %s spectra of the %d-record suite against %s at Vs30 = %.0f m/s%s, component %s: thin curves are individual scaled records, the thick curve is the suite mean; suite spectral RMSE %.2f, %.0f%% of ordinates inside the band, final PGA inside the band for %d of %d records; scale factors %.2f-%.2f.",
    id, CO$records[1L], Target$text, Target$Vs30, Target$band, dir,
    ST$RMSE[1L], 100 * ST$insideFraction[1L], CO$nPGA.inside[1L], CO$records[1L],
    ST$scaleMin[1L], ST$scaleMax[1L]
  )
}

.tableIDs <- function(x, context, siteID = NULL) {
  if (is.null(x)) stop(sprintf("%s: missing data table.", context), call. = FALSE)
  DT <- x
  SiteID <- .cleanTarget(siteID)
  if (length(SiteID) && "siteID" %in% names(DT)) DT <- DT[DT[["siteID"]] %in% SiteID]
  if (!"ID" %in% names(DT)) stop(sprintf("%s: table has no ID column.", context), call. = FALSE)
  .cleanTarget(DT$ID)
}

.baseIDs <- function(ids) {
  ids <- .cleanTarget(ids)
  ids[!grepl("\\.(site|max)$", ids) & !ids %in% c("max", "min")]
}

.validateIDTarget <- function(target, candidates, context) {
  Target <- .cleanTarget(target)
  if (!length(Target)) return(NULL)
  Missing <- setdiff(Target, candidates)
  if (length(Missing)) {
    stop(sprintf(
      "%s: ID.target not found: %s. Available: %s.",
      context, paste(Missing, collapse = ", "), .targetChoices(candidates)
    ), call. = FALSE)
  }
  Target
}

.resolveIDTarget <- function(x, context, target = NULL, siteID = NULL, base = FALSE) {
  IDs <- .tableIDs(x, context, siteID)
  Candidates <- IDs
  if (base) Candidates <- .baseIDs(Candidates)
  Target <- .cleanTarget(target)
  if (!length(Target)) Target <- .cleanTarget(.currentTarget("ID.gmdp"))
  if (length(Target)) return(.validateIDTarget(Target, Candidates, context))
  .requireOneTarget(Candidates, "ID.target", context)
}

.targetBaseID <- function(target, context) {
  Target <- .cleanTarget(target)
  Target <- Target[!Target %in% c("max", "min")]
  Target <- sub("\\.(site|max)$", "", Target)
  .requireOneTarget(Target, "ID.target", context)
}

.resolveDerivedIDTarget <- function(x, context, suffix, target = NULL, siteID = NULL) {
  IDs <- .tableIDs(x, context, siteID)
  Candidates <- IDs[endsWith(IDs, suffix)]
  Target <- .cleanTarget(target)
  if (!length(Target)) Target <- .cleanTarget(.currentTarget("ID.gmdp"))

  if (length(Target)) {
    if (all(endsWith(Target, suffix))) return(.validateIDTarget(Target, Candidates, context))
    Base <- .targetBaseID(Target, context)
    Derived <- paste0(Base, suffix)
    if (Derived %in% Candidates) return(Derived)
    stop(sprintf(
      "%s: derived ID.target not found for %s from %s. Available: %s.",
      context, suffix, paste(Target, collapse = ", "), .targetChoices(Candidates)
    ), call. = FALSE)
  }

  .requireOneTarget(Candidates, "ID.target", context)
}

.resolveUhsIDTarget <- function(x, context, target = NULL, siteID = NULL) {
  IDs <- .tableIDs(x, context, siteID)
  Target <- .cleanTarget(target)
  if (length(Target)) {
    if (length(Target) == 1L && Target %in% .baseIDs(IDs)) {
      Site <- paste0(Target, ".site")
      if (Site %in% IDs) return(c(Site, Target))
      stop(sprintf("%s: derived ID.target not found: %s.", context, Site), call. = FALSE)
    }
    return(.validateIDTarget(Target, IDs, context))
  }
  Base <- .resolveIDTarget(x, context, siteID = siteID, base = TRUE)
  Site <- paste0(Base, ".site")
  if (Site %in% IDs) return(c(Site, Base))
  stop(sprintf("%s: derived ID.target not found: %s.", context, Site), call. = FALSE)
}

.resolveSiteIDTarget <- function(x, context, target = NULL) {
  if (is.null(x) || !"siteID" %in% names(x)) return(character())
  Sites <- .cleanTarget(x$siteID)
  Target <- .cleanTarget(target)
  if (length(Target)) {
    Missing <- setdiff(Target, Sites)
    if (length(Missing)) {
      stop(sprintf(
        "%s: siteID.target not found: %s. Available: %s.",
        context, paste(Missing, collapse = ", "), .targetChoices(Sites)
      ), call. = FALSE)
    }
    return(Target)
  }
  .requireOneTarget(Sites, "siteID.target", context)
}

.resolveSiteIDStorage <- function(siteID, config = NULL, context) {
  SiteID <- .requireOneTarget(siteID, "siteID.target", context)
  if (is.null(config)) return(SiteID)
  if (!is.list(config) || !length(config) ||
      !all(vapply(config, is.list, logical(1)))) {
    stop(sprintf(
      "%s: params.report.sites must be a non-empty YAML list.",
      context
    ), call. = FALSE)
  }
  ConfigID <- vapply(config, function(x) {
    if (is.null(x$siteID) || is.list(x$siteID) || length(x$siteID) != 1L) {
      return(NA_character_)
    }
    trimws(as.character(x$siteID))
  }, character(1))
  if (anyNA(ConfigID) || any(!nzchar(ConfigID)) || anyDuplicated(ConfigID)) {
    stop(sprintf(
      "%s: params.report.sites must contain unique scalar siteID values.",
      context
    ), call. = FALSE)
  }
  i <- match(SiteID, ConfigID)
  if (is.na(i)) {
    stop(sprintf(
      "%s: siteID.target not configured: %s.",
      context, SiteID
    ), call. = FALSE)
  }
  StorageID <- config[[i]][["siteID.storage"]]
  if (is.null(StorageID)) return(SiteID)
  if (is.list(StorageID) || length(StorageID) != 1L ||
      is.na(StorageID) || !nzchar(trimws(as.character(StorageID)))) {
    stop(sprintf(
      "%s: siteID.storage for %s must be one non-empty value.",
      context, SiteID
    ), call. = FALSE)
  }
  trimws(as.character(StorageID))
}

.slopePeriods <- function(x, idg, level, context) {
  Required <- c("IDg", "level", "Hs", "s", "lo", "b", "IDm", "Ts", "Go", "VSo")
  if (is.null(x) || !is.data.frame(x)) {
    stop(sprintf("%s: ShearTable must be a table.", context), call. = FALSE)
  }
  Missing <- setdiff(Required, names(x))
  if (length(Missing)) {
    stop(sprintf(
      "%s: ShearTable missing columns: %s.",
      context, paste(Missing, collapse = ", ")
    ), call. = FALSE)
  }
  IDgTarget <- .cleanTarget(idg)
  LevelTarget <- .cleanTarget(level)
  if (!length(IDgTarget) || !length(LevelTarget)) {
    stop(sprintf(
      "%s: IDg and level targets must be non-empty.",
      context
    ), call. = FALSE)
  }
  .one <- function(values) {
    Values <- unique(values)
    Values <- Values[!is.na(Values)]
    if (length(Values) != 1L) {
      stop(sprintf(
        "%s: expected one value within each IDg-level group.",
        context
      ), call. = FALSE)
    }
    Values
  }
  OUT <- data.table::as.data.table(x)[
    IDg %in% IDgTarget & level %in% LevelTarget,
    .(
      Hs = .one(Hs),
      s = .one(s),
      lo = .one(lo),
      b = .one(b),
      beta = round(atan(1 / .one(s)) * 180 / pi, 1),
      nIDm = data.table::uniqueN(IDm),
      Ts.min = min(Ts, na.rm = TRUE),
      Ts.max = max(Ts, na.rm = TRUE),
      Ts.med = median(Ts, na.rm = TRUE),
      Go.min = min(Go, na.rm = TRUE),
      Go.max = max(Go, na.rm = TRUE),
      VSo.min = min(VSo, na.rm = TRUE),
      VSo.max = max(VSo, na.rm = TRUE)
    ),
    by = .(IDg, level)
  ][order(IDg, level)]
  if (!nrow(OUT)) {
    stop(sprintf(
      "%s: no rows for IDg and level targets.",
      context
    ), call. = FALSE)
  }
  if (anyDuplicated(OUT[, .(IDg, level)])) {
    stop(sprintf("%s: periods are not unique by IDg and level.", context),
         call. = FALSE)
  }
  OUT
}

.selectASCETable <- function(
  x,
  context,
  idTarget = NULL,
  siteID = NULL,
  vs30,
  p = NULL,
  spectrum = c("design", "mcer")
) {
  if (is.null(x) || !is.data.frame(x) || !nrow(x)) {
    stop(sprintf("%s: ASCETable must be a non-empty table.", context), call. = FALSE)
  }
  Schema <- c(
    "Spectrum", "siteID", "Vs30", "ID", "p", "Tn", "SaF",
    "SDS", "SD1", "SMS", "SM1"
  )
  if (!identical(names(x), Schema)) {
    stop(sprintf(
      "%s: ASCETable schema must be exactly: %s.",
      context, paste(Schema, collapse = ", ")
    ), call. = FALSE)
  }
  if (!setequal(unique(as.character(x$Spectrum)), c("design", "mcer"))) {
    stop(sprintf(
      "%s: ASCETable Spectrum must contain exactly design and mcer.",
      context
    ), call. = FALSE)
  }

  SiteID <- .cleanTarget(siteID)
  SiteID <- .resolveSiteIDTarget(x, context, target = SiteID)
  if (length(SiteID) != 1L) {
    stop(sprintf(
      "%s: siteID.target must select exactly one siteID.",
      context
    ), call. = FALSE)
  }
  IDs <- .resolveIDTarget(
    x,
    context,
    target = idTarget,
    siteID = SiteID,
    base = TRUE
  )
  if (length(IDs) != 1L) {
    stop(sprintf(
      "%s: ID.target must select exactly one base ID.",
      context
    ), call. = FALSE)
  }

  Vs30Target <- suppressWarnings(as.numeric(as.character(vs30)))
  SpectrumTarget <- .cleanTarget(spectrum)
  if (!length(Vs30Target) ||
      any(!is.finite(Vs30Target)) ||
      any(Vs30Target <= 0) ||
      anyDuplicated(Vs30Target)) {
    stop(sprintf(
      "%s: Vs30 target must contain unique finite positive values.",
      context
    ), call. = FALSE)
  }
  if (!length(SpectrumTarget)) {
    stop(sprintf(
      "%s: Spectrum target must be non-empty.",
      context
    ), call. = FALSE)
  }

  DT <- data.table::as.data.table(x)[
    ID %in% IDs &
      siteID %in% SiteID &
      Vs30 %in% Vs30Target &
      Spectrum %in% SpectrumTarget
  ]
  if (!nrow(DT)) {
    stop(sprintf(
      "%s: ASCETable has no rows for the selected targets.",
      context
    ), call. = FALSE)
  }
  PTarget <- .cleanTarget(p)
  if (!length(PTarget)) PTarget <- .cleanTarget(DT$p)
  if (!length(PTarget)) {
    stop(sprintf(
      "%s: selected ASCETable cells have no p values.",
      context
    ), call. = FALSE)
  }
  DT <- DT[.matchP(p, PTarget)]
  if (!nrow(DT)) {
    stop(sprintf(
      "%s: ASCETable has no rows for the selected p target.",
      context
    ), call. = FALSE)
  }

  Coverage <- data.table::CJ(
    Spectrum = SpectrumTarget,
    Vs30 = Vs30Target,
    p = PTarget,
    unique = TRUE
  )
  OK <- vapply(seq_len(nrow(Coverage)), function(i) {
    any(
      DT$Spectrum %in% Coverage$Spectrum[[i]] &
        DT$Vs30 %in% Coverage$Vs30[[i]] &
        .matchP(DT$p, Coverage$p[[i]])
    )
  }, logical(1))
  if (any(!OK)) {
    stop(sprintf(
      "%s: ASCETable does not cover every requested Spectrum, Vs30, and p combination.",
      context
    ), call. = FALSE)
  }
  if (anyNA(DT) ||
      any(!is.finite(DT$Vs30)) ||
      any(DT$Vs30 <= 0) ||
      any(!is.finite(DT$Tn)) ||
      any(DT$Tn < 0) ||
      any(!is.finite(DT$SaF)) ||
      any(DT$SaF <= 0) ||
      any(!is.finite(DT$SDS)) ||
      any(DT$SDS <= 0) ||
      any(!is.finite(DT$SD1)) ||
      any(DT$SD1 <= 0) ||
      any(!is.finite(DT$SMS)) ||
      any(DT$SMS <= 0) ||
      any(!is.finite(DT$SM1)) ||
      any(DT$SM1 <= 0)) {
    stop(sprintf(
      paste0(
        "%s: selected ASCETable values must be complete, with nonnegative ",
        "periods and positive finite spectra and design parameters."
      ),
      context
    ), call. = FALSE)
  }
  Parameters <- unique(DT[, .(
    siteID, Vs30, ID, p, SDS, SD1, SMS, SM1
  )])
  if (anyDuplicated(Parameters[, .(siteID, Vs30, ID, p)])) {
    stop(sprintf(
      paste0(
        "%s: SDS, SD1, SMS, and SM1 must be constant within each ",
        "(siteID, Vs30, ID, p) cell."
      ),
      context
    ), call. = FALSE)
  }
  Tolerance <- 1e-10
  SMSExpected <- 1.5 * DT$SDS
  SM1Expected <- 1.5 * DT$SD1
  SMSScale <- pmax(1, abs(DT$SMS), abs(SMSExpected))
  SM1Scale <- pmax(1, abs(DT$SM1), abs(SM1Expected))
  if (any(abs(DT$SMS - SMSExpected) > Tolerance * SMSScale) ||
      any(abs(DT$SM1 - SM1Expected) > Tolerance * SM1Scale)) {
    stop(sprintf(
      "%s: ASCETable must satisfy SMS = 1.5 * SDS and SM1 = 1.5 * SD1.",
      context
    ), call. = FALSE)
  }
  if (anyDuplicated(DT[, .(Spectrum, siteID, Vs30, ID, p, Tn)])) {
    stop(sprintf(
      "%s: selected ASCETable rows duplicate the natural key.",
      context
    ), call. = FALSE)
  }
  DT
}

.resolveValueTarget <- function(values, targetName, context, target = NULL) {
  Values <- .cleanTarget(values)
  Target <- .cleanTarget(target)
  if (length(Target)) {
    Missing <- setdiff(Target, Values)
    if (length(Missing)) {
      stop(sprintf(
        "%s: %s not found: %s. Available: %s.",
        context, targetName, paste(Missing, collapse = ", "), .targetChoices(Values)
      ), call. = FALSE)
    }
    return(Target)
  }
  .requireOneTarget(Values, targetName, context)
}

.captionFormat <- function(x) {
  Num <- suppressWarnings(as.numeric(x))
  if (length(Num) == length(x) && all(is.finite(Num))) {
    return(prettyNum(Num, big.mark = ",", scientific = FALSE))
  }
  as.character(x)
}

.captionField <- function(name, label, envir = parent.frame(), unit = NULL) {
  Value <- .currentTarget(name, envir = envir)
  Value <- .cleanTarget(Value)
  if (!length(Value)) return(character())
  if (length(Value) > 4L) Value <- c(head(Value, 4L), sprintf("... %d more", length(Value) - 4L))
  Text <- paste(.captionFormat(Value), collapse = ", ")
  if (!is.null(unit) && nzchar(unit)) Text <- paste(Text, unit)
  sprintf("%s: %s", label, Text)
}

.captionSite <- function(envir = parent.frame()) {
  Site <- .currentTarget("siteID.target", envir = envir)
  Site <- .captionFormat(.cleanTarget(Site))
  if (length(Site)) return(sprintf("Site: %s", paste(Site, collapse = ", ")))

  Params <- .currentTarget("params", envir = envir)
  if (is.list(Params) && !is.null(Params$site) && nzchar(Params$site)) {
    return(sprintf("Site: %s", Params$site))
  }
  character()
}
# nolint end
