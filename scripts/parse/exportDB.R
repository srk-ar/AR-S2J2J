# nolint start
# exportDB.R
# Updates blastDB with the current project records from index tables.
# Idempotent: drops existing rows for this project's source and re-inserts.
# Schema: Source, Q, D, SD, ppvL, ppvT, ppvV, ppaL, ppaT, ppaV

library(data.table)
library(jsonlite)

exportDB <- function(parseConfig, domainsPath) {
  SOURCE_NAME <- parseConfig$blastDB$siteID
  DB_PATH     <- parseConfig$blastDB$path
  UNITS       <- parseConfig$blastDB$units

  if (!file.exists(DB_PATH))
    stop(sprintf("exportDB: blastDB not found: %s", DB_PATH))

  if (is.null(UNITS) || is.null(UNITS$ppv) || is.null(UNITS$ppa))
    stop("exportDB: manifest$parse$blastDB$units must declare both 'ppv' and 'ppa' (the canonical source-of-truth units for the local site's peaks).")

  for (.f in c("records.index.csv", "events.index.csv", "blasts.index.csv")) {
    if (!file.exists(file.path(domainsPath, .f)))
      stop(sprintf("exportDB: missing index file: %s", file.path(domainsPath, .f)))
  }

  RI <- fread(file.path(domainsPath, "records.index.csv"))
  EV <- fread(file.path(domainsPath, "events.index.csv"))
  BT <- fread(file.path(domainsPath, "blasts.index.csv"))

  BT[, DateBlast := as.IDate(DateBlast)]
  EV[, DateBlast := as.IDate(DateTime)]
  DT <- merge(RI,
    merge(EV[, .(EventID, DateBlast)],
          BT[!is.na(MIC), .(MIC = max(MIC)), by = DateBlast],
          by = "DateBlast", all.x = TRUE)[, .(EventID, MIC)],
    by = "EventID", all.x = TRUE)

  Rows <- DT[!is.na(MIC) & !is.na(D) &
             !is.na(ppvL) & !is.na(ppvT) & !is.na(ppvV) &
             !is.na(ppaL) & !is.na(ppaT) & !is.na(ppaV),
    .(Source = SOURCE_NAME,
      Q  = MIC,  D = D,  SD = round(D / sqrt(MIC), 4),
      ppvL = ppvL, ppvT = ppvT, ppvV = ppvV,
      ppaL = ppaL, ppaT = ppaT, ppaV = ppaV,
      ppv.Units = UNITS$ppv, ppa.Units = UNITS$ppa)]

  DB <- fread(DB_PATH)
  DB <- DB[Source != SOURCE_NAME]
  DB <- rbindlist(list(DB, Rows), use.names = TRUE)
  fwrite(DB, DB_PATH)

  cat(sprintf("%s updated: %d %s rows  (total: %d)  ppv=%s ppa=%s\n",
              DB_PATH, nrow(Rows), SOURCE_NAME, nrow(DB),
              UNITS$ppv, UNITS$ppa))
}
# nolint end
