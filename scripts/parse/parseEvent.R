# nolint start
# parseEvent.R
# Usage: Rscript scripts/parse/parseEvent.R <event_folder>
# Output per StationID/: VToW.csv, record.json
# Output per EventID/:   Offset.csv

source("scripts/parse/setup.R")

.path.event <- commandArgs(trailingOnly = TRUE)[1]
.event.id   <- basename(.path.event)

.col.map <- c(Tran = "VT.T", Vert = "VT.V", Long = "VT.L")

.sq <- function(s) gsub('^"|"$', "", trimws(s))

.isCsv <- function(lines) grepl('","', lines[1], fixed = TRUE)

.parseHeader <- function(lines, csv) {
  meta <- list()
  for (ln in lines) {
    s <- .sq(ln)
    if (!nchar(trimws(s))) { if (length(meta)) break; next }
    if (s == "Waveform Data Channels") break
    if (csv) {
      p <- strsplit(.sq(ln), '","', fixed = TRUE)[[1]]
      if (length(p) == 3 && p[1] %in% names(.col.map)) break
      if (length(p) >= 2) meta[[p[1]]] <- p[2]
    } else {
      pos <- regexpr("\\s+:\\s+", s)
      if (pos > 0) meta[[trimws(substring(s, 1, pos - 1))]] <-
                        trimws(substring(s, pos + attr(pos, "match.length")))
    }
  }
  meta
}

.dataLine <- function(lines, csv) {
  if (csv) {
    for (i in seq_along(lines)) {
      p <- strsplit(.sq(lines[i]), '","', fixed = TRUE)[[1]]
      if (length(p) == 3 && p[1] == "Tran") return(i)
    }
  } else {
    seen <- FALSE
    for (i in seq_along(lines)) {
      s <- trimws(lines[i])
      if (!seen && nchar(s)) seen <- TRUE
      if (seen && !nchar(s))
        for (j in seq(i + 1, length(lines)))
          if (grepl("Tran", lines[j], fixed = TRUE)) return(j)
      if (.sq(s) == "Waveform Data Channels")
        for (j in seq(i + 1, length(lines)))
          if (grepl("Tran", lines[j], fixed = TRUE)) return(j)
    }
  }
  NA_integer_
}

.parseRow <- function(l, csv) {
  p <- if (csv) strsplit(gsub('"', "", trimws(l)), ",")[[1]]
       else Filter(nchar, trimws(strsplit(l, "\t")[[1]]))
  v <- suppressWarnings(as.numeric(p))
  if (length(v) >= 3 && !any(is.na(v[1:3]))) v else NULL
}

# ── per station ───────────────────────────────────────────────────────────────

.records <- list()

for (sdir in list.dirs(.path.event, recursive = FALSE, full.names = TRUE)) {
  sid <- basename(sdir)

  raw <- list.files(sdir, pattern = "\\.(TXT|txt|CSV|csv)$", full.names = TRUE)
  raw <- raw[!grepl("^VToW\\.csv$", basename(raw))]
  if (!length(raw)) next
  fp <- raw[1]

  lines <- readLines(fp, warn = FALSE, encoding = "UTF-8")
  csv   <- .isCsv(lines)
  meta  <- .parseHeader(lines, csv)
  dl    <- .dataLine(lines, csv)
  if (is.na(dl)) next

  g  <- function(...) { for (k in c(...)) if (!is.null(meta[[k]])) return(meta[[k]]); NA_character_ }
  fs <- as.integer(regmatches(g("SampleRate","Sample Rate"), regexpr("[0-9]+", g("SampleRate","Sample Rate"))))
  units <- if (grepl("mm/s", g("Units"), fixed = TRUE)) "mm/s" else g("Units")
  dt <- tryCatch(
    as.POSIXct(paste(trimws(gsub('"', "", g("EventDate","Event Date"))),
                     trimws(gsub('"', "", g("EventTime","Event Time")))),
               format = "%Y-%m-%d %H:%M:%S", tz = "UTC"),
    error = function(e) as.POSIXct(NA))
  if (is.na(dt))
    dt <- tryCatch(
      as.POSIXct(paste(trimws(gsub('"', "", g("Event Date"))),
                       trimws(gsub('"', "", g("Event Time")))),
                 format = "%B %d, %Y %H:%M:%S", tz = "UTC"),
      error = function(e) as.POSIXct(NA))

  cols <- if (csv) strsplit(.sq(lines[dl]), '","', fixed = TRUE)[[1]]
          else Filter(nchar, trimws(strsplit(lines[dl], "\t")[[1]]))
  vi   <- which(cols %in% names(.col.map))

  vals <- Filter(Negate(is.null), lapply(lines[seq(dl + 1, length(lines))], .parseRow, csv))
  ns   <- length(vals)
  if (!ns) next

  t    <- round((seq_len(ns) - 1L) / fs, 6)
  vtow <- data.table(t = t)
  for (ci in vi) set(vtow, j = .col.map[cols[ci]], value = sapply(vals, `[`, ci))
  set(vtow, j = "EventID",   value = .event.id)
  set(vtow, j = "StationID", value = sid)
  set(vtow, j = "Units",     value = units)

  fwrite(vtow, file.path(sdir, "VToW.csv"))
  writeLines(
    sprintf('{\n  "FS": %d,\n  "NS": %d,\n  "Units": "%s",\n  "FilenameTS": "%s",\n  "DateTime": "%s"\n}',
            fs, ns, units, basename(fp), format(dt, "%Y-%m-%d %H:%M:%S")),
    file.path(sdir, "record.json"))

  .records[[sid]] <- data.table(StationID = sid, DateTime = dt, FS = fs, NS = ns)
}

# ── Offset.csv ────────────────────────────────────────────────────────────────

if (length(.records)) {
  off   <- rbindlist(.records)
  minDT <- min(off$DateTime, na.rm = TRUE)
  off[, t0 := as.numeric(difftime(DateTime, minDT, units = "secs"))]
  setorder(off, t0)
  fwrite(off[, .(StationID, t0, DateTime, FS, NS)], file.path(.path.event, "Offset.csv"))
}
# nolint end
