# nolint start
# buildTS.R → records.index.csv
# Reads kashimaDB record.json files (raw.owner/record.json) instead of
# scanning raw TS headers. Requires record.json to be hydrated with
# DateTime, ppvL/T/V, ppaL/T/V, D, Q fields.
# Expects: .path.kashimaDB, .path.domains, GAP.THRESHOLD

suppressPackageStartupMessages({
  library(data.table)
  library(jsonlite)
  library(digest)
})

source(here::here("scripts", "tools", "json.R"))

FILES <- list.files(
  path       = file.path(path.expand(.path.kashimaDB), "ISEE"),
  pattern    = "^record[.]json$",
  recursive  = TRUE,
  full.names = TRUE)

DT <- rbindlist(Filter(Negate(is.null), lapply(FILES, function(FILE) {
  tryCatch({
    json <- .readJson(FILE)
    FilenameTS <- .jsonRequire(json, c("Record", "FileID"), FILE)[1L]
    EventID <- .jsonRequire(json, c("Event", "EventID"), FILE)
    DateTime <- as.POSIXct(.jsonRequire(json, "DateTime", FILE),
                           format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
    data.table(
      FilenameTS  = FilenameTS,
      TSID        = toupper(substr(digest(FilenameTS, algo = "md5", serialize = FALSE), 1L, 4L)),
      EventID     = EventID,
      StationID   = .jsonRequire(json, c("Station", "StationID"), FILE),
      DateTime    = DateTime,
      FS          = .jsonRequire(json, c("Record", "Fs"), FILE)[1L],
      ppvL        = .jsonNumber(json, "ppvL"),
      ppvT        = .jsonNumber(json, "ppvT"),
      ppvV        = .jsonNumber(json, "ppvV"),
      ppaL        = .jsonNumber(json, "ppaL"),
      ppaT        = .jsonNumber(json, "ppaT"),
      ppaV        = .jsonNumber(json, "ppaV"),
      D           = .jsonNumber(json, "D"))
  }, error = function(e) NULL)
})), use.names = TRUE)

setorderv(DT, cols = c("DateTime", "FilenameTS"))

DT[, Diff        := c(NA_integer_, as.integer(diff(DateTime)))]
DT[, isSameEvent := !is.na(Diff) & Diff <= GAP.THRESHOLD]

setcolorder(DT, c("FilenameTS","TSID","EventID","StationID",
                  "DateTime","Diff","isSameEvent","FS",
                  "ppvL","ppvT","ppvV","ppaL","ppaT","ppaV","D"))

fwrite(x = DT, file = file.path(.path.domains, "records.index.csv"))
cat(sprintf("records.index.csv: %d rows, %d events\n",
            nrow(DT), uniqueN(DT$EventID)))
# nolint end
