# SoT harness for exact JSON access.
# Stage A: records with real D/Q remain byte-identical to legacy extraction.
# Stage B: records without D/Q do not partial-match D -> DateTime and emit no warnings.

suppressPackageStartupMessages({
  library(data.table)
  library(jsonlite)
})

source(file.path("scripts", "dev", "sot", "jsonExactV2.R"))
source(file.path("scripts", "tools", "json.R"))

.readIseeRecordOld <- function(file) {
  Json <- read_json(file, simplifyVector = TRUE)
  data.table(
    EventID   = Json$Event$EventID,
    StationID = Json$Station$StationID,
    Fs        = Json$Record$Fs[1L],
    D         = if (!is.null(Json$D)) as.numeric(Json$D) else NA_real_,
    Q         = if (!is.null(Json$Q)) as.integer(Json$Q) else NA_integer_)
}

.readIseeRecordFinal <- function(file) {
  Json <- .readJson(file)
  D <- .jsonGet(Json, "D")
  Q <- .jsonGet(Json, "Q")
  data.table(
    EventID   = .jsonRequire(Json, c("Event", "EventID"), file),
    StationID = .jsonRequire(Json, c("Station", "StationID"), file),
    Fs        = .jsonRequire(Json, c("Record", "Fs"), file)[1L],
    D         = if (!is.null(D)) as.numeric(D) else NA_real_,
    Q         = if (!is.null(Q)) as.integer(Q) else NA_integer_)
}

.withWarnings <- function(expr) {
  Warnings <- character()
  Value <- withCallingHandlers(
    expr,
    warning = function(e) {
      Warnings <<- c(Warnings, conditionMessage(e))
      invokeRestart("muffleWarning")
    })
  list(Value = Value, Warnings = Warnings)
}

PathRecords <- path.expand("~/kashimaDB/gmdb.v2/records/ISEE")
FILES <- list.files(PathRecords, pattern = "^record[.]json$",
                    recursive = TRUE, full.names = TRUE)
stopifnot(length(FILES) == 86L)

Raw <- rbindlist(lapply(FILES, function(FILE) {
  Json <- read_json(FILE, simplifyVector = TRUE)
  data.table(FILE = FILE,
             hasD = "D" %chin% names(Json),
             hasQ = "Q" %chin% names(Json),
             partialD = !("D" %chin% names(Json)) && !is.null(Json$D))
}))

stopifnot(Raw[, sum(hasD & hasQ)] == 68L)
stopifnot(Raw[, sum(!hasD & !hasQ)] == 18L)
stopifnot(Raw[, sum(partialD)] == 18L)

Old <- .withWarnings(rbindlist(lapply(FILES, .readIseeRecordOld),
                               use.names = TRUE))
New <- .withWarnings(rbindlist(lapply(FILES, .readIseeRecordV2),
                               use.names = TRUE))
Final <- .withWarnings(rbindlist(lapply(FILES, .readIseeRecordFinal),
                                 use.names = TRUE))

setorder(Old$Value, EventID, StationID)
setorder(New$Value, EventID, StationID)
setorder(Final$Value, EventID, StationID)

OK <- Raw[hasD & hasQ, .(FILE)]
OldOK <- .withWarnings(rbindlist(lapply(OK$FILE, .readIseeRecordOld),
                                 use.names = TRUE))
NewOK <- .withWarnings(rbindlist(lapply(OK$FILE, .readIseeRecordV2),
                                 use.names = TRUE))
setorder(OldOK$Value, EventID, StationID)
setorder(NewOK$Value, EventID, StationID)
stopifnot(identical(OldOK$Value, NewOK$Value))

Missing <- New$Value[is.na(D) & is.na(Q)]
stopifnot(nrow(Missing) == 18L)
stopifnot(!length(New$Warnings))
stopifnot(!length(Final$Warnings))
stopifnot(identical(New$Value, Final$Value))
stopifnot(any(grepl("NAs introduced by coercion", Old$Warnings)))

cat("PASS compareJsonExact.R\n")
cat(sprintf("records: %d; with D/Q: %d; without D/Q: %d\n",
            nrow(New$Value), nrow(OldOK$Value), nrow(Missing)))
