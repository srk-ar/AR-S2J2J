# nolint start
# buildEvents.R → EventTable.csv
# Aggregates RecordTable.csv into one row per unique event.
# Source: kashimaDB record.json timestamps only.
# Link EventID ↔ BlastID established separately via BlastTable.csv.
# Expects: .path.domains

ts <- fread(file.path(.path.domains, "records.index.csv"))

events <- ts[!is.na(EventID), .(
  StationCount = uniqueN(StationID),
  TSCount      = .N,
  DateTime     = min(DateTime, na.rm = TRUE)
), by = EventID]

setorder(events, DateTime)

fwrite(events[, .(EventID, StationCount, TSCount, DateTime)],
       file.path(.path.domains, "events.index.csv"))
cat("EventTable.csv:", nrow(events), "rows\n")
# nolint end
