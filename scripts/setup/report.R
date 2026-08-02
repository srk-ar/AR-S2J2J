.resolveReportSites <- function(x, config = NULL, label = NULL,
                                context = "report") {
  if (is.null(x) || !"siteID" %in% names(x)) {
    stop(sprintf("%s: canonical product has no siteID column.", context),
         call. = FALSE)
  }
  AUX <- .cleanTarget(x$siteID)
  if (!length(AUX)) {
    stop(sprintf("%s: canonical product has no siteID values.", context),
         call. = FALSE)
  }

  if (is.null(config)) {
    if (length(AUX) != 1L) {
      stop(sprintf(
        "%s: define params.report.sites to select and order one or more of: %s.",
        context, .targetChoices(AUX)
      ), call. = FALSE)
    }
    if (is.null(label) || !length(label)) {
      OUT <- character()
    } else {
      if (is.list(label) || length(label) != 1L || is.na(label)) {
        stop(sprintf("%s: params.site must be scalar.", context),
             call. = FALSE)
      }
      OUT <- trimws(as.character(label))
      if (!nzchar(OUT)) OUT <- character()
    }
    OUT <- data.table::data.table(
      siteID = AUX,
      label = if (length(OUT)) OUT else AUX,
      SRS = NA_character_,
      siteID.storage = AUX
    )
  } else {
    if (!is.list(config) || !length(config) ||
        !all(vapply(config, is.list, logical(1)))) {
      stop(sprintf(
        "%s: params.report.sites must be a non-empty YAML list.", context
      ), call. = FALSE)
    }
    OUT <- vapply(config, function(x) {
      COLS <- names(x)
      !is.null(COLS) &&
        !anyDuplicated(COLS) &&
        all(c("siteID", "label") %in% COLS) &&
        all(COLS %in% c("siteID", "label", "SRS", "siteID.storage")) &&
        length(x$siteID) == 1L && !is.list(x$siteID) &&
        length(x$label) == 1L && !is.list(x$label) &&
        (!("SRS" %in% COLS) ||
         (length(x$SRS) == 1L && !is.list(x$SRS))) &&
        (!("siteID.storage" %in% COLS) ||
         (length(x$siteID.storage) == 1L && !is.list(x$siteID.storage) &&
          !is.na(x$siteID.storage) &&
          nzchar(trimws(as.character(x$siteID.storage)))))
    }, logical(1))
    if (!all(OUT)) {
      stop(sprintf(
        paste0(
          "%s: each params.report.sites entry must define one scalar siteID, ",
          "one scalar label, and at most one scalar SRS and siteID.storage."
        ),
        context
      ), call. = FALSE)
    }
    DT <- data.table::rbindlist(config, fill = TRUE, use.names = TRUE)
    if (!"SRS" %in% names(DT)) DT[, SRS := NA_character_]
    if (!"siteID.storage" %in% names(DT)) {
      DT[, siteID.storage := NA_character_]
    }
    DT <- DT[, .(
      siteID = trimws(as.character(siteID)),
      label = trimws(as.character(label)),
      SRS = trimws(as.character(SRS)),
      siteID.storage = trimws(as.character(siteID.storage))
    )]
    if (anyNA(DT$siteID) || any(!nzchar(DT$siteID)) ||
        anyNA(DT$label) || any(!nzchar(DT$label))) {
      stop(sprintf(
        "%s: params.report.sites siteID and label values must be non-empty.",
        context
      ), call. = FALSE)
    }
    if (anyDuplicated(DT$siteID)) {
      stop(sprintf("%s: params.report.sites contains duplicate siteID values.",
                   context), call. = FALSE)
    }
    DT[is.na(siteID.storage), siteID.storage := siteID]
    OUT <- setdiff(DT$siteID, AUX)
    if (length(OUT)) {
      stop(sprintf(
        "%s: configured siteID not found: %s. Available: %s.",
        context, paste(OUT, collapse = ", "), .targetChoices(AUX)
      ), call. = FALSE)
    }
    OUT <- DT
  }

  OUT[, key := tolower(gsub("[^[:alnum:]_.-]+", "-", siteID))]
  OUT[, key := gsub("(^[-.]+|[-.]+$)", "", key)]
  if (any(!nzchar(OUT$key)) || anyDuplicated(OUT$key)) {
    stop(sprintf(
      "%s: configured siteID values do not produce unique report keys.",
      context
    ), call. = FALSE)
  }
  OUT[]
}

.reportSite <- function(x, i, stem, vars = list(), context = "report") {
  if (!data.table::is.data.table(x) ||
      !all(c("siteID", "label", "SRS", "siteID.storage", "key") %in%
           names(x))) {
    stop(sprintf("%s: SiteTable does not satisfy the report contract.", context),
         call. = FALSE)
  }
  if (length(i) != 1L || is.na(i) || i < 1L || i > nrow(x)) {
    stop(sprintf("%s: site row index is invalid.", context), call. = FALSE)
  }
  if (length(stem) != 1L || is.na(stem) || !nzchar(stem)) {
    stop(sprintf("%s: stem must be one non-empty value.", context),
         call. = FALSE)
  }
  if (!is.list(vars) ||
      (length(vars) &&
       (is.null(names(vars)) || any(!nzchar(names(vars)))))) {
    stop(sprintf("%s: vars must be a named list.", context), call. = FALSE)
  }
  COLS <- intersect(
    c("siteID.target", "siteID.storage", "ReportContext"),
    names(vars)
  )
  if (length(COLS)) {
    stop(sprintf(
      "%s: report context variables are owned by SiteTable: %s.",
      context, paste(COLS, collapse = ", ")
    ), call. = FALSE)
  }
  AUX <- nrow(x) > 1L
  ReportContext <- .newReportContext(
    multiple = AUX,
    key = x$key[[i]],
    label = x$label[[i]],
    context = context
  )
  vars$siteID.target <- x$siteID[[i]]
  vars$siteID.storage <- x$siteID.storage[[i]]
  vars$ReportContext <- ReportContext
  list(
    siteID = x$siteID[[i]],
    siteID.storage = x$siteID.storage[[i]],
    SRS = x$SRS[[i]],
    context = ReportContext,
    stem = if (ReportContext$multiple) {
      paste(ReportContext$key, stem, sep = "-")
    } else {
      stem
    },
    labels = if (ReportContext$multiple) "rewrite" else "keep",
    vars = vars
  )
}

.knitReportBlock <- function(path, stem, sites, i, vars = list(), root,
                             heading = NULL, level = 4L, anchor = NULL,
                             context = "report") {
  AUX <- .reportSite(sites, i, stem, vars, context)
  if (AUX$context$multiple && !is.null(heading)) {
    if (length(heading) != 1L || is.na(heading) || !nzchar(heading) ||
        length(anchor) != 1L || is.na(anchor) || !nzchar(anchor) ||
        length(level) != 1L || is.na(level) || level < 1L) {
      stop(sprintf(
        "%s: multisite heading requires scalar heading, level, and anchor.",
        context
      ), call. = FALSE)
    }
    cat(sprintf(
      "%s %s {#%s-%s}\n\n",
      strrep("#", as.integer(level)), AUX$context$label, anchor,
      AUX$context$key
    ))
  }
  COLS <- names(AUX$vars)
  LIST <- vector("list", length(COLS))
  names(LIST) <- COLS
  OUT <- setNames(logical(length(COLS)), COLS)
  for (COL in COLS) {
    OUT[[COL]] <- exists(COL, envir = knitr::knit_global(), inherits = FALSE)
    if (OUT[[COL]]) {
      LIST[[COL]] <- get(COL, envir = knitr::knit_global(), inherits = FALSE)
    }
    assign(COL, AUX$vars[[COL]], envir = knitr::knit_global())
  }
  on.exit({
    for (COL in rev(COLS)) {
      if (OUT[[COL]]) {
        assign(COL, LIST[[COL]], envir = knitr::knit_global())
      } else if (exists(COL, envir = knitr::knit_global(), inherits = FALSE)) {
        rm(list = COL, envir = knitr::knit_global())
      }
    }
  }, add = TRUE)
  NGR::knitBlock(
    path = path,
    stem = AUX$stem,
    labels = AUX$labels,
    root = root
  )
  invisible(AUX)
}

.resolveReportSRS <- function(sites, i, root, context = "report SRS") {
  AUX <- .reportSite(sites, i, "srs", context = context)
  FILE <- file.path(root, "gmsp", "match")
  FILES <- if (dir.exists(FILE)) {
    list.files(FILE, all.files = FALSE, full.names = FALSE, no.. = TRUE)
  } else {
    character()
  }
  FILES <- FILES[dir.exists(file.path(FILE, FILES))]
  FILES <- .cleanTarget(FILES)
  OUT <- .cleanTarget(AUX$SRS)
  if (!length(OUT)) {
    if (length(FILES) != 1L) {
      stop(sprintf(
        "%s: set SRS for siteID %s in params.report.sites; available runs: %s.",
        context, AUX$siteID,
        if (length(FILES)) .targetChoices(FILES) else "none"
      ), call. = FALSE)
    }
    OUT <- FILES
  }
  if (length(OUT) != 1L) {
    stop(sprintf("%s: SRS must select one run for siteID %s.",
                 context, AUX$siteID), call. = FALSE)
  }
  if (!OUT %in% FILES) {
    stop(sprintf(
      "%s: SRS run not found: %s. Available: %s.",
      context, OUT, if (length(FILES)) .targetChoices(FILES) else "none"
    ), call. = FALSE)
  }
  FILE <- file.path(FILE, OUT, "metadata", "runMatch.json")
  if (!file.exists(FILE)) {
    stop(sprintf("%s: missing %s.", context, FILE), call. = FALSE)
  }
  DT <- jsonlite::read_json(FILE, simplifyVector = TRUE)
  if (!identical(
    as.character(DT$target$siteID), AUX$siteID
  )) {
    stop(sprintf(
      "%s: SRS %s targets siteID %s, expected %s.",
      context, OUT, paste(DT$target$siteID, collapse = ", "),
      AUX$siteID
    ), call. = FALSE)
  }
  list(SRS.target = OUT, PathSRS = dirname(dirname(FILE)))
}

.resolveOptionalReportSRS <- function(sites, root,
                                      context = "optional report SRS") {
  lapply(seq_len(nrow(sites)), function(i) {
    AUX <- .cleanTarget(sites$SRS[[i]])
    if (!length(AUX)) return(NULL)
    .resolveReportSRS(sites, i, root, context = context)
  })
}

AUX <- NULL
if (!is.null(params$report)) {
  if (!is.list(params$report)) {
    stop("report: params.report must be a YAML mapping.", call. = FALSE)
  }
  AUX <- params$report$sites
}
SiteTable <- .resolveReportSites(
  UHSTable, config = AUX, label = params$site, context = "report"
)
rm(AUX)
