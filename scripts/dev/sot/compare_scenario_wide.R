#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
  library(jsonlite)
  library(here)
})

source(here::here("scripts", "tools", "setup.R"))

.stripSelfref <- function(.x) {
  if (is.data.table(.x)) {
    attr(.x, ".internal.selfref") <- NULL
    return(.x)
  }
  if (is.list(.x)) lapply(.x, .stripSelfref) else .x
}

.dtIdentical <- function(x, y)
  identical(.stripSelfref(x), .stripSelfref(y))

.PSL2PSW <- function(.x) {
  OUT <- dcast(.x, RecordID + xi + Tn ~ ID + OCID, value.var = "S", sep = ".")
  COLS <- grep("^(PSA|PSV|SD)[.]", names(OUT), value = TRUE)
  setcolorder(OUT, c("RecordID", "xi", "Tn", COLS))
  OUT[]
}

.check <- function(label, ok) {
  cat(sprintf("%-62s %s\n", label, if (ok) "PASS" else "FAIL"))
  if (!ok) stop(label, call. = FALSE)
}

ScenarioID <- "F80.D150.Q150.p90"
PATH.sc    <- here::here("data", "records", "scenarios", ScenarioID)
J          <- read_json(file.path(PATH.sc, sprintf("%s.json", ScenarioID)))
XI         <- unlist(if (!is.null(J$XI)) J$XI else J$xi)[1L]

PSW <- if (file.exists(file.path(PATH.sc, "PSW.csv"))) {
  fread(file.path(PATH.sc, "PSW.csv"))
} else {
  PSL <- fread(file.path(PATH.sc, "PSL.csv"))
  .PSL2PSW(PSL)
}
TSW <- fread(file.path(PATH.sc, "TSW.csv"))

if (file.exists(file.path(PATH.sc, "PSL.csv"))) {
  PSL <- fread(file.path(PATH.sc, "PSL.csv"))
  DT <- PSL[OCID == "D50" & ID == "PSA" & xi == XI & Tn >= 1/J$Fmax,
            .(ID = RecordID, X = Tn, Y = S, size = MID_LINE_SIZE)]
  OUT <- PSW[xi == XI & Tn >= 1/J$Fmax,
             .(ID = RecordID, X = Tn, Y = get("PSA.D50"), size = MID_LINE_SIZE)]
  setorder(DT, ID, X)
  setorder(OUT, ID, X)
  .check("PSA(D50) plot data: PSL long vs PSW wide", .dtIdentical(DT, OUT))
} else {
  OUT <- PSW[xi == XI & Tn >= 1/J$Fmax,
             .(ID = RecordID, X = Tn, Y = get("PSA.D50"), size = MID_LINE_SIZE)]
  .check("PSA(D50) plot data exists in PSW", nrow(OUT) > 0L)
  cat("PSL legacy baseline absent; skipped PSL-vs-PSW identity check.\n")
}

DT <- .tsw2tsl(copy(TSW))[ID == "AT" & OCID == "H1",
                           .(ID = RecordID, X = t, Y = s, size = THIN_LINE_SIZE)]
OUT <- TSW[, .(ID = RecordID, X = t, Y = get("AT.H1"), size = THIN_LINE_SIZE)]
setorder(DT, ID, X)
setorder(OUT, ID, X)
.check("AT(H1) plot data: TSW->TSL long vs TSW wide", .dtIdentical(DT, OUT))
.check("PSW OCID detection includes D50/H1/H2/UP",
       identical(sort(.getPSWOCID(PSW)), c("D50", "H1", "H2", "UP")))

cat("scenario wide checks: PASS\n")
