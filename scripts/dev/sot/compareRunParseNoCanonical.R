# nolint start
# SoT harness: compare current checked-in parse outputs with a canonical-free
# runParse prototype executed in a temporary output tree.
#
# Intentional behavioural change:
#   records without D in kashimaDB raw.owner/record.json keep D = NA and are
#   not exported to blastDB. In this workspace that means 68 IMPALA rows are
#   rebuilt from hydrated kashimaDB records; stale IMPALA rows backed only by
#   old parsed/canonical state are not preserved.
#
# Usage:
#   Rscript scripts/dev/sot/compareRunParseNoCanonical.R

suppressPackageStartupMessages({
  library(data.table)
  library(jsonlite)
})

.stripSelfRef <- function(DT) {
  attr(DT, ".internal.selfref") <- NULL
  DT
}

.dtIdentical <- function(left, right) {
  identical(.stripSelfRef(left), .stripSelfRef(right))
}

.copyFile <- function(fromPath, toPath) {
  dir.create(dirname(toPath), recursive = TRUE, showWarnings = FALSE)
  if (!file.copy(fromPath, toPath, overwrite = TRUE))
    stop(sprintf("copy failed: %s -> %s", fromPath, toPath))
}

.showCheck <- function(checkName, ok) {
  cat(sprintf("  %-18s %s\n", checkName, if (ok) "PASS" else "FAIL"))
}

.readKashima <- function(recordsDir) {
  FILES <- list.files(file.path(path.expand(recordsDir), "ISEE"),
                      pattern = "^record[.]json$", recursive = TRUE,
                      full.names = TRUE)
  rbindlist(lapply(FILES, function(FILE) {
    J <- read_json(FILE, simplifyVector = TRUE)
    D <- J[["D", exact = TRUE]]
    Q <- J[["Q", exact = TRUE]]
    data.table(
      FilenameTS = J$Record$FileID[1L],
      EventID    = J$Event$EventID,
      StationID  = J$Station$StationID,
      D          = if (!is.null(D)) as.numeric(D) else NA_real_,
      Q          = if (!is.null(Q)) as.numeric(Q) else NA_real_)
  }), use.names = TRUE)
}

PathRoot <- normalizePath(".", mustWork = TRUE)
PathTmp  <- file.path(tempdir(), sprintf("runParseNoCanonical-%s", Sys.getpid()))
unlink(PathTmp, recursive = TRUE)
dir.create(PathTmp, recursive = TRUE, showWarnings = FALSE)
on.exit(unlink(PathTmp, recursive = TRUE), add = TRUE)

PathDomains <- file.path(PathTmp, "domains")
PathBlastDB <- file.path(PathTmp, "blastDB.csv")

.copyFile(file.path(PathRoot, "data", "domains", "blasts.index.csv"),
          file.path(PathDomains, "blasts.index.csv"))
.copyFile(file.path(PathRoot, "data", "blastDB.csv"), PathBlastDB)

Base <- list(
  records = fread(file.path(PathRoot, "data", "domains", "records.index.csv")),
  events  = fread(file.path(PathRoot, "data", "domains", "events.index.csv")),
  blastDB = fread(file.path(PathRoot, "data", "blastDB.csv"))
)

Manifest <- fromJSON(file.path(PathRoot, "scripts", "manifest.json"),
                     simplifyVector = TRUE, simplifyDataFrame = FALSE)
ParseConfig <- Manifest$parse
Manifest$dirs$domains        <- PathDomains
ParseConfig$blastDB$path     <- PathBlastDB
ParseConfig$dirs$canonical   <- NULL
ParseConfig$dirs$audit       <- NULL
ParseConfig$dirs$records     <- NULL

source(file.path(PathRoot, "scripts", "parse", "exportDB.R"))
source(file.path(PathRoot, "scripts", "dev", "sot", "mergeClientDataV2.R"))
source(file.path(PathRoot, "scripts", "dev", "sot", "parsePipelineNoCanonicalV2.R"))

parsePipelineV2(Manifest, ParseConfig)

New <- list(
  records = fread(file.path(PathDomains, "records.index.csv")),
  events  = fread(file.path(PathDomains, "events.index.csv")),
  blastDB = fread(PathBlastDB)
)

Kashima <- .readKashima(ParseConfig$dirs$kashimaDB)
RowsComplete <- !is.na(Kashima$D) & !is.na(Kashima$Q)
RowsMissing  <- is.na(Kashima$D) | is.na(Kashima$Q)
COLS <- setdiff(names(Base$records), "D")
BaseD <- Base$records[Kashima[RowsComplete],
                      on = .(FilenameTS, EventID, StationID), D]
NewD <- New$records[Kashima[RowsComplete],
                    on = .(FilenameTS, EventID, StationID), D]

Checks <- list(
  recordsStructure = .dtIdentical(Base$records[, ..COLS], New$records[, ..COLS]),
  recordsHydrated  = identical(as.numeric(unname(BaseD)), as.numeric(unname(NewD))),
  recordsMissingD  = all(is.na(New$records[Kashima[RowsMissing],
                                           on = .(FilenameTS, EventID, StationID), D])),
  eventsIndex      = .dtIdentical(Base$events,  New$events),
  blastDBOther     = .dtIdentical(Base$blastDB[Source != "IMPALA"],
                                  New$blastDB[Source != "IMPALA"]),
  blastDBImpalaN   = New$blastDB[Source == "IMPALA", .N] == sum(RowsComplete)
)

cat("\n=== SoT checks: runParse without canonical ===\n")
for (CheckName in names(Checks)) .showCheck(CheckName, Checks[[CheckName]])

cat("\nIntentional D/Q coverage change:\n")
cat("  kashimaDB records:", nrow(Kashima), "\n")
cat("  hydrated D/Q:", sum(RowsComplete), "\n")
cat("  missing D/Q:", sum(RowsMissing), "\n")
cat("  current blastDB IMPALA:", Base$blastDB[Source == "IMPALA", .N], "\n")
cat("  prototype blastDB IMPALA:", New$blastDB[Source == "IMPALA", .N], "\n")

if (!Checks$recordsStructure) {
  cat("\nrecords.index non-D dimensions:\n")
  print(rbind(
    baseline  = dim(Base$records[, ..COLS]),
    prototype = dim(New$records[, ..COLS])))
}

if (!Checks$recordsHydrated) {
  cat("\nhydrated D diagnostic:\n")
  cat("  baseline type:", typeof(BaseD), "prototype type:", typeof(NewD), "\n")
  cat("  all.equal:", as.character(all.equal(BaseD, NewD)), "\n")
  Bad <- data.table(
    FilenameTS = Kashima[RowsComplete, FilenameTS],
    EventID    = Kashima[RowsComplete, EventID],
    StationID  = Kashima[RowsComplete, StationID],
    DBase      = BaseD,
    DNew       = NewD)[DBase != DNew | is.na(DBase) != is.na(DNew)]
  print(Bad)
}

if (!Checks$eventsIndex) {
  cat("\nevents.index dimensions:\n")
  print(rbind(
    baseline  = dim(Base$events),
    prototype = dim(New$events)))
}

if (!Checks$recordsMissingD) {
  cat("\nRecords expected to have D = NA in the prototype:\n")
  print(New$records[Kashima[RowsMissing], on = .(FilenameTS, EventID, StationID),
                    .(FilenameTS, EventID, StationID, D)])
}

stopifnot(all(unlist(Checks)))
cat("\n=== SoT PASS: canonical-free runParse prototype matches intended contract ===\n")
# nolint end
