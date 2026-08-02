# nolint start
# buildRecords.R  ·  Copy raw TS into records/{EventID}/{StationID}/
# Expects: .path.raw.fixed, .path.raw.mobile, .path.domains, .path.records

master <- fread(file.path(.path.domains, "records.index.csv"))
master <- master[nchar(EventID) > 0]

rawIndex <- data.table(
  FullPath = c(
    list.files(.path.raw.fixed,  pattern="\\.(TXT|txt|CSV|csv)$", recursive=TRUE, full.names=TRUE),
    list.files(.path.raw.mobile, pattern="\\.(TXT|txt|CSV|csv)$", recursive=TRUE, full.names=TRUE))
)[, FileName := basename(FullPath)]

if (dir.exists(.path.records)) unlink(.path.records, recursive=TRUE)

master[, {
  destDir <- file.path(.path.records, EventID, StationID)
  dir.create(destDir, recursive=TRUE, showWarnings=FALSE)
  src <- rawIndex[FileName == FilenameTS, FullPath]
  if (length(src) == 1) file.copy(src, file.path(destDir, FilenameTS))
}, by=.(EventID, StationID, FilenameTS)]

cat("records/:", uniqueN(master$EventID), "events,", nrow(master), "files\n")
# nolint end
