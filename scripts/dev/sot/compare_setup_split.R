# scripts/dev/sot/compare_setup_split.R — SoT: setup organizational split
# Verifies that moving helpers from gmsp/setup.R to tools/setup.R
# produces identical function outputs.
# Run: Rscript scripts/dev/sot/compare_setup_split.R

setwd(here::here())

strip <- function(x) { attr(x, ".internal.selfref") <- NULL; x }
PASS <- 0L; FAIL <- 0L
check <- function(label, expr) {
  ok <- tryCatch(isTRUE(expr), error = function(e) { message("  ERR: ", e$message); FALSE })
  if (ok) { message(sprintf("PASS  %s", label)); PASS <<- PASS + 1L }
  else    { message(sprintf("FAIL  %s", label)); FAIL <<- FAIL + 1L }
}

PATH.gmsp <- here::here("data", "gmsp")
InputID   <- "F80.Qo.Do.eemd"
DIR       <- "L"

# ── Stage A/B/C baseline — old gmsp/setup.R ──────────────────────────────────
source("scripts/gmsp/setup.R")

J    <- read_json(file.path(PATH.gmsp, InputID, sprintf("%s.json", InputID)))
XI   <- unlist(if (!is.null(J$XI)) J$XI else J$xi)[1L]
Fmax <- J$Fmax

DATA.psa.old <- fread(file.path(PATH.gmsp, InputID, "PSL.csv"))[
  OCID == DIR & ID == "PSA" & xi == XI & Tn >= 1/Fmax,
  .(ID = RecordID, X = Tn, Y = S, size = MID_LINE_SIZE)][order(X)]

DATA.ts.old <- .tsw2tsl(fread(file.path(PATH.gmsp, InputID, "TSW.csv")))[
  ID == "AT" & OCID == DIR,
  .(ID = RecordID, X = t, Y = s, size = THIN_LINE_SIZE)][order(X)]

TSL.old <- .tsw2tsl(fread(file.path(PATH.gmsp, InputID, "TSW.csv")))

# ── Overwrite with prototype: tools_setup_v2 ─────────────────────────────────
sys.source("scripts/dev/sot/tools_setup_v2.R", envir = globalenv())

DATA.psa.new <- fread(file.path(PATH.gmsp, InputID, "PSL.csv"))[
  OCID == DIR & ID == "PSA" & xi == XI & Tn >= 1/Fmax,
  .(ID = RecordID, X = Tn, Y = S, size = MID_LINE_SIZE)][order(X)]

DATA.ts.new <- .tsw2tsl(fread(file.path(PATH.gmsp, InputID, "TSW.csv")))[
  ID == "AT" & OCID == DIR,
  .(ID = RecordID, X = t, Y = s, size = THIN_LINE_SIZE)][order(X)]

TSL.new <- .tsw2tsl(fread(file.path(PATH.gmsp, InputID, "TSW.csv")))

# ── Checks ────────────────────────────────────────────────────────────────────
check("A  plotPSA DATA identical (Tn>=1/Fmax)",  identical(strip(DATA.psa.old), strip(DATA.psa.new)))
check("B  plotTS  DATA identical",               identical(strip(DATA.ts.old),  strip(DATA.ts.new)))
check("C  tsw2tsl output identical",             identical(strip(TSL.old),      strip(TSL.new)))

message(sprintf("\n%d PASS  %d FAIL", PASS, FAIL))
if (FAIL > 0L) stop("SoT FAILED")
