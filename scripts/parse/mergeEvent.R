# nolint start
# mergeEvent.R
# Merges all station VToW.csv files within each event folder.
# Output per EventID/: VToW.csv
# Expects: .path.records

for (edir in list.dirs(.path.records, recursive = FALSE, full.names = TRUE)) {
  eid   <- basename(edir)
  files <- list.files(edir, pattern = "^VToW\\.csv$",
                      recursive = TRUE, full.names = TRUE)
  if (!length(files)) next
  dt <- rbindlist(lapply(files, fread))
  fwrite(dt, file.path(edir, "VToW.csv"))
}
# nolint end
